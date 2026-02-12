// Expression Evaluation Engine for AMD FPGA (Vitis HLS)
//
// Bytecode-driven evaluator for polynomial constraint expressions.
// Processes one row at a time through a decode-execute pipeline.
//
// Reference:
//   pil2-proofman/pil2-stark/src/starkpil/expressions_gpu.cu
//     computeExpressions_() kernel, load__() device function
//   pil2-proofman/pil2-stark/src/starkpil/expressions_pack.hpp
//     ExpressionsPack::calculateExpressions(), load()

#ifndef VENUS_EXPR_ENGINE_HPP
#define VENUS_EXPR_ENGINE_HPP

#include "gl64_3_t.hpp"
#include "expr_config.hpp"

// ---- Data source type classification ----
// Given the type field from an instruction argument and the bufferCommitSize,
// determine which category the source belongs to.
//
// This mirrors the GPU load__() function logic:
//   type == B:     tmp1 (dim1 temps)
//   type == B+1:   tmp3 (dim3 temps)
//   type >= B+2:   constants (publicInputs, numbers, airValues, ...)
//   type == 0:     constPols
//   type 1..3:     trace/aux_trace
//   type == 4:     zi (vanishing polynomial)
//   type >= 5:     custom commits (not supported in this simplified kernel)

// ---- Simplified expression engine for a single expression ----
//
// This evaluates one expression's bytecode over a single row, producing
// either a dim1 or dim3 result.
//
// Template parameters:
//   MAX_N_OPS:   maximum bytecode instructions
//   N_COLS:      number of columns in the polynomial trace
//
// Parameters:
//   ops[]:       bytecode opcodes (uint8, length nOps)
//   args[]:      bytecode arguments (uint16, length nOps*8)
//   nOps:        number of instructions
//   row:         current row index
//   domainSize:  total rows in domain
//   trace[]:     polynomial trace data (AXI-MM, row-major, N_COLS wide)
//   constPols[]: constant polynomial data (row-major, nConstCols wide)
//   nConstCols:  number of constant polynomial columns
//   numbers[]:   constant pool
//   challenges[]:verifier challenges
//   evals[]:     evaluation values
//   publicInputs[]: public input values
//   airValues[]: AIR values
//   openingStrides[]: row strides for opening points (int64)
//   result1:     output for dim1 result
//   result3:     output for dim3 result
//   resultDim:   dimension of the result (1 or 3)
//
// The engine classifies sources into simplified categories:
//   - Polynomial data: loaded from trace[] with row-major indexing
//   - Constant polynomials: loaded from constPols[] with row-major indexing
//   - Temporaries: stored in local BRAM arrays
//   - Constants: loaded from numbers[], challenges[], etc.

template<int MAX_N_OPS>
static void expr_eval_single(
    // Bytecode
    const ap_uint<8>   ops[EXPR_MAX_OPS],
    const ap_uint<16>  args[EXPR_MAX_ARGS],
    unsigned int        nOps,

    // Row context
    unsigned int        row,
    unsigned int        domainSize,

    // Polynomial data (AXI-MM)
    const ap_uint<64>*  trace,
    unsigned int        nTraceCols,
    const ap_uint<64>*  constPols,
    unsigned int        nConstCols,

    // Constants (BRAM)
    const gl64_t        numbers[EXPR_MAX_NUMBERS],
    const gl64_t        challenges[EXPR_MAX_CHALLENGES],
    const gl64_t        evals[EXPR_MAX_EVALS],
    const gl64_t        publicInputs[EXPR_MAX_PUBLICS],
    const gl64_t        airValues[EXPR_MAX_AIR_VALUES],
    const int           openingStrides[EXPR_MAX_OPENINGS],

    // Configuration
    unsigned int        bufferCommitSize,
    unsigned int        nStages,

    // Output
    gl64_t&             result1,
    gl64_3_t&           result3,
    unsigned int        resultDim
) {
    #pragma HLS INLINE off

    // ---- Temporary buffers ----
    gl64_t  tmp1[EXPR_MAX_TEMP1];
    gl64_3_t tmp3[EXPR_MAX_TEMP3];
    #pragma HLS ARRAY_PARTITION variable=tmp1 complete dim=1
    #pragma HLS ARRAY_PARTITION variable=tmp3 complete dim=1

    unsigned int i_args = 0;

    EXPR_OPS:
    for (unsigned int kk = 0; kk < MAX_N_OPS; kk++) {
        #pragma HLS LOOP_TRIPCOUNT min=1 max=MAX_N_OPS
        #pragma HLS PIPELINE off
        if (kk >= nOps) break;

        ap_uint<8> opcode = ops[kk];
        unsigned int arith_op  = (unsigned int)args[i_args + 0];
        unsigned int dest_idx  = (unsigned int)args[i_args + 1];
        unsigned int type_a    = (unsigned int)args[i_args + 2];
        unsigned int idx_a     = (unsigned int)args[i_args + 3];
        unsigned int off_a     = (unsigned int)args[i_args + 4];
        unsigned int type_b    = (unsigned int)args[i_args + 5];
        unsigned int idx_b     = (unsigned int)args[i_args + 6];
        unsigned int off_b     = (unsigned int)args[i_args + 7];

        // ---- Load operand A (dim1) ----
        auto load_dim1 = [&](unsigned int type, unsigned int idx,
                             unsigned int off) -> gl64_t {
            #pragma HLS INLINE
            if (type == bufferCommitSize) {
                // tmp1 buffer
                return tmp1[idx];
            } else if (type >= bufferCommitSize + 2) {
                // Constants: direct index access
                unsigned int const_type = type - (bufferCommitSize + 2);
                switch (const_type) {
                    case 0: return publicInputs[idx];
                    case 1: return numbers[idx];
                    case 2: return airValues[idx];
                    // proofValues, airgroupValues, challenges, evals
                    case 5: return challenges[idx];
                    case 6: return evals[idx];
                    default: return gl64_t::zero();
                }
            } else if (type == 0) {
                // Constant polynomials
                int stride = (off < EXPR_MAX_OPENINGS) ?
                             openingStrides[off] : 0;
                unsigned int r = (row + stride + domainSize) % domainSize;
                gl64_t val;
                val.val = constPols[(ap_uint<64>)r * nConstCols + idx];
                return val;
            } else {
                // Trace polynomial (simplified: type 1 = trace)
                int stride = (off < EXPR_MAX_OPENINGS) ?
                             openingStrides[off] : 0;
                unsigned int r = (row + stride + domainSize) % domainSize;
                gl64_t val;
                val.val = trace[(ap_uint<64>)r * nTraceCols + idx];
                return val;
            }
        };

        // ---- Load operand A (dim3) ----
        auto load_dim3 = [&](unsigned int type, unsigned int idx,
                             unsigned int off) -> gl64_3_t {
            #pragma HLS INLINE
            if (type == bufferCommitSize + 1) {
                // tmp3 buffer
                return tmp3[idx];
            } else if (type >= bufferCommitSize + 2) {
                // Constants (dim3 = 3 consecutive elements)
                unsigned int const_type = type - (bufferCommitSize + 2);
                gl64_3_t val;
                switch (const_type) {
                    case 5: // challenges
                        val.v[0] = challenges[idx];
                        val.v[1] = challenges[idx + 1];
                        val.v[2] = challenges[idx + 2];
                        return val;
                    case 6: // evals
                        val.v[0] = evals[idx];
                        val.v[1] = evals[idx + 1];
                        val.v[2] = evals[idx + 2];
                        return val;
                    default:
                        return gl64_3_t::zero();
                }
            } else {
                // Trace polynomial (dim3 = 3 consecutive columns)
                int stride = (off < EXPR_MAX_OPENINGS) ?
                             openingStrides[off] : 0;
                unsigned int r = (row + stride + domainSize) % domainSize;
                gl64_3_t val;
                ap_uint<64> base = (ap_uint<64>)r * nTraceCols + idx;
                val.v[0].val = trace[base];
                val.v[1].val = trace[base + 1];
                val.v[2].val = trace[base + 2];
                return val;
            }
        };

        // ---- Execute instruction ----
        bool isLastOp = (kk == nOps - 1);

        switch ((unsigned int)opcode) {
        case EXPR_OPCODE_DIM1: {
            gl64_t a = load_dim1(type_a, idx_a, off_a);
            gl64_t b = load_dim1(type_b, idx_b, off_b);
            gl64_t res = expr_op_dim1(arith_op, a, b);
            if (isLastOp) {
                result1 = res;
            } else {
                tmp1[dest_idx] = res;
            }
            break;
        }
        case EXPR_OPCODE_DIM31: {
            gl64_3_t a = load_dim3(type_a, idx_a, off_a);
            gl64_t   b = load_dim1(type_b, idx_b, off_b);
            gl64_3_t res = expr_op_dim31(arith_op, a, b);
            if (isLastOp) {
                result3 = res;
            } else {
                tmp3[dest_idx] = res;
            }
            break;
        }
        case EXPR_OPCODE_DIM33: {
            gl64_3_t a = load_dim3(type_a, idx_a, off_a);
            gl64_3_t b = load_dim3(type_b, idx_b, off_b);
            gl64_3_t res = expr_op_dim33(arith_op, a, b);
            if (isLastOp) {
                result3 = res;
            } else {
                tmp3[dest_idx] = res;
            }
            break;
        }
        default:
            break;
        }

        i_args += 8;
    }
}

// ---- Batch expression evaluation over a domain ----
// Evaluates the same bytecode expression for every row in [0, domainSize),
// writing dim1 or dim3 results to output[].
template<int MAX_N_OPS>
static void expr_eval_domain(
    // Bytecode
    const ap_uint<8>   ops[EXPR_MAX_OPS],
    const ap_uint<16>  args[EXPR_MAX_ARGS],
    unsigned int        nOps,

    // Domain
    unsigned int        domainSize,

    // Polynomial data (AXI-MM)
    const ap_uint<64>*  trace,
    unsigned int        nTraceCols,
    const ap_uint<64>*  constPols,
    unsigned int        nConstCols,

    // Constants (BRAM)
    const gl64_t        numbers[EXPR_MAX_NUMBERS],
    const gl64_t        challenges[EXPR_MAX_CHALLENGES],
    const gl64_t        evals[EXPR_MAX_EVALS],
    const gl64_t        publicInputs[EXPR_MAX_PUBLICS],
    const gl64_t        airValues[EXPR_MAX_AIR_VALUES],
    const int           openingStrides[EXPR_MAX_OPENINGS],

    // Configuration
    unsigned int        bufferCommitSize,
    unsigned int        nStages,
    unsigned int        resultDim,

    // Output (AXI-MM)
    ap_uint<64>*        output
) {
    #pragma HLS INLINE off

    DOMAIN_LOOP:
    for (unsigned int row = 0; row < domainSize; row++) {
        #pragma HLS LOOP_TRIPCOUNT min=8 max=1048576

        gl64_t   res1;
        gl64_3_t res3;

        expr_eval_single<MAX_N_OPS>(
            ops, args, nOps,
            row, domainSize,
            trace, nTraceCols,
            constPols, nConstCols,
            numbers, challenges, evals,
            publicInputs, airValues, openingStrides,
            bufferCommitSize, nStages,
            res1, res3, resultDim
        );

        if (resultDim == 1) {
            output[row] = res1.val;
        } else {
            output[(ap_uint<64>)row * FIELD_EXTENSION + 0] = res3.v[0].val;
            output[(ap_uint<64>)row * FIELD_EXTENSION + 1] = res3.v[1].val;
            output[(ap_uint<64>)row * FIELD_EXTENSION + 2] = res3.v[2].val;
        }
    }
}

#endif // VENUS_EXPR_ENGINE_HPP
