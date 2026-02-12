// AXI-wrapped expression evaluation test kernel for HLS co-simulation.
//
// Interface:
//   - trace[]:       polynomial trace data via AXI-MM
//   - constPols[]:   constant polynomial data via AXI-MM
//   - output[]:      result buffer via AXI-MM
//   - ops[]:         bytecode opcodes via AXI-MM
//   - args[]:        bytecode arguments via AXI-MM
//   - numbers[]:     constant pool via AXI-MM
//   - challenges[]:  verifier challenges via AXI-MM
//   - evals[]:       evaluation values via AXI-MM
//   - publicInputs[]:public inputs via AXI-MM
//   - airValues[]:   AIR values via AXI-MM
//   - strides[]:     opening point strides via AXI-MM
//   - op:            operation mode
//                      0 = evaluate single row
//                      1 = evaluate over domain
//   - nOps:          number of bytecode instructions
//   - row:           row index (for single-row mode)
//   - domainSize:    total rows in domain
//   - nTraceCols:    columns in trace
//   - nConstCols:    columns in constant polynomials
//   - bufferCommitSize: data source type threshold
//   - nStages:       number of stages
//   - resultDim:     result dimension (1 or 3)

#include "../expr_engine.hpp"

// Maximum bytecode ops per expression in test kernel
#define TEST_MAX_OPS 256

extern "C" {

void expr_test_kernel(
    const ap_uint<64>* trace,
    const ap_uint<64>* constPols,
    ap_uint<64>*       output,
    const ap_uint<8>*  ops_in,
    const ap_uint<16>* args_in,
    const ap_uint<64>* numbers_in,
    const ap_uint<64>* challenges_in,
    const ap_uint<64>* evals_in,
    const ap_uint<64>* publicInputs_in,
    const ap_uint<64>* airValues_in,
    const int*         strides_in,
    unsigned int op,
    unsigned int nOps,
    unsigned int row,
    unsigned int domainSize,
    unsigned int nTraceCols,
    unsigned int nConstCols,
    unsigned int bufferCommitSize,
    unsigned int nStages,
    unsigned int resultDim
) {
    #pragma HLS INTERFACE m_axi port=trace      bundle=gmem0 offset=slave depth=65536
    #pragma HLS INTERFACE m_axi port=constPols   bundle=gmem1 offset=slave depth=65536
    #pragma HLS INTERFACE m_axi port=output      bundle=gmem2 offset=slave depth=65536
    #pragma HLS INTERFACE m_axi port=ops_in      bundle=gmem3 offset=slave depth=4096
    #pragma HLS INTERFACE m_axi port=args_in     bundle=gmem4 offset=slave depth=32768
    #pragma HLS INTERFACE m_axi port=numbers_in  bundle=gmem5 offset=slave depth=1024
    #pragma HLS INTERFACE m_axi port=challenges_in bundle=gmem6 offset=slave depth=128
    #pragma HLS INTERFACE m_axi port=evals_in    bundle=gmem7 offset=slave depth=256
    #pragma HLS INTERFACE m_axi port=publicInputs_in bundle=gmem8 offset=slave depth=64
    #pragma HLS INTERFACE m_axi port=airValues_in bundle=gmem9 offset=slave depth=64
    #pragma HLS INTERFACE m_axi port=strides_in  bundle=gmem10 offset=slave depth=16
    #pragma HLS INTERFACE s_axilite port=op
    #pragma HLS INTERFACE s_axilite port=nOps
    #pragma HLS INTERFACE s_axilite port=row
    #pragma HLS INTERFACE s_axilite port=domainSize
    #pragma HLS INTERFACE s_axilite port=nTraceCols
    #pragma HLS INTERFACE s_axilite port=nConstCols
    #pragma HLS INTERFACE s_axilite port=bufferCommitSize
    #pragma HLS INTERFACE s_axilite port=nStages
    #pragma HLS INTERFACE s_axilite port=resultDim
    #pragma HLS INTERFACE s_axilite port=return

    // Copy bytecode and constants to local BRAM
    ap_uint<8>  ops_local[EXPR_MAX_OPS];
    ap_uint<16> args_local[EXPR_MAX_ARGS];
    gl64_t      numbers_local[EXPR_MAX_NUMBERS];
    gl64_t      challenges_local[EXPR_MAX_CHALLENGES];
    gl64_t      evals_local[EXPR_MAX_EVALS];
    gl64_t      publicInputs_local[EXPR_MAX_PUBLICS];
    gl64_t      airValues_local[EXPR_MAX_AIR_VALUES];
    int         strides_local[EXPR_MAX_OPENINGS];

    // Load bytecode
    LOAD_OPS:
    for (unsigned int i = 0; i < nOps && i < EXPR_MAX_OPS; i++) {
        #pragma HLS PIPELINE II=1
        ops_local[i] = ops_in[i];
    }

    LOAD_ARGS:
    for (unsigned int i = 0; i < nOps * 8 && i < EXPR_MAX_ARGS; i++) {
        #pragma HLS PIPELINE II=1
        args_local[i] = args_in[i];
    }

    // Load constants (burst)
    LOAD_NUMBERS:
    for (unsigned int i = 0; i < EXPR_MAX_NUMBERS; i++) {
        #pragma HLS PIPELINE II=1
        numbers_local[i].val = numbers_in[i];
    }
    LOAD_CHALLENGES:
    for (unsigned int i = 0; i < EXPR_MAX_CHALLENGES; i++) {
        #pragma HLS PIPELINE II=1
        challenges_local[i].val = challenges_in[i];
    }
    LOAD_EVALS:
    for (unsigned int i = 0; i < EXPR_MAX_EVALS; i++) {
        #pragma HLS PIPELINE II=1
        evals_local[i].val = evals_in[i];
    }
    LOAD_PUBLIC:
    for (unsigned int i = 0; i < EXPR_MAX_PUBLICS; i++) {
        #pragma HLS PIPELINE II=1
        publicInputs_local[i].val = publicInputs_in[i];
    }
    LOAD_AIR:
    for (unsigned int i = 0; i < EXPR_MAX_AIR_VALUES; i++) {
        #pragma HLS PIPELINE II=1
        airValues_local[i].val = airValues_in[i];
    }
    LOAD_STRIDES:
    for (unsigned int i = 0; i < EXPR_MAX_OPENINGS; i++) {
        #pragma HLS PIPELINE II=1
        strides_local[i] = strides_in[i];
    }

    switch (op) {
    case 0: { // Evaluate single row
        gl64_t   res1;
        gl64_3_t res3;

        expr_eval_single<TEST_MAX_OPS>(
            ops_local, args_local, nOps,
            row, domainSize,
            trace, nTraceCols,
            constPols, nConstCols,
            numbers_local, challenges_local, evals_local,
            publicInputs_local, airValues_local, strides_local,
            bufferCommitSize, nStages,
            res1, res3, resultDim
        );

        if (resultDim == 1) {
            output[0] = res1.val;
        } else {
            output[0] = res3.v[0].val;
            output[1] = res3.v[1].val;
            output[2] = res3.v[2].val;
        }
        break;
    }
    case 1: { // Evaluate over domain
        expr_eval_domain<TEST_MAX_OPS>(
            ops_local, args_local, nOps,
            domainSize,
            trace, nTraceCols,
            constPols, nConstCols,
            numbers_local, challenges_local, evals_local,
            publicInputs_local, airValues_local, strides_local,
            bufferCommitSize, nStages, resultDim,
            output
        );
        break;
    }
    default:
        break;
    }
}

} // extern "C"
