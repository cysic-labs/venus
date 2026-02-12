// Expression Evaluation HLS - Configuration
//
// Compile-time bounds for the bytecode-driven expression evaluator.
// These match the typical sizes encountered in zisk STARK proofs.

#ifndef VENUS_EXPR_CONFIG_HPP
#define VENUS_EXPR_CONFIG_HPP

#include "../goldilocks/gl64_t.hpp"

// ---- Field extension degree ----
// Goldilocks cubic extension: F_p[x] / (x^3 - x - 1)
#define FIELD_EXTENSION 3

// ---- Bytecode bounds ----
// Maximum number of operations in a single expression
#define EXPR_MAX_OPS      4096

// Maximum number of uint16_t arguments (8 per op)
#define EXPR_MAX_ARGS     (EXPR_MAX_OPS * 8)

// Maximum number of constant-pool field elements
#define EXPR_MAX_NUMBERS  1024

// ---- Temporary buffer bounds ----
// Maximum dim1 temporaries (base field elements)
#define EXPR_MAX_TEMP1    128

// Maximum dim3 temporaries (cubic extension elements)
#define EXPR_MAX_TEMP3    128

// ---- Data source bounds ----
// Maximum number of stages (nStages) supported
#define EXPR_MAX_STAGES   4

// Maximum opening points (for cyclic row offsets)
#define EXPR_MAX_OPENINGS 16

// Maximum constant-value arrays
#define EXPR_MAX_PUBLICS      64
#define EXPR_MAX_CHALLENGES   128
#define EXPR_MAX_EVALS        256
#define EXPR_MAX_AIR_VALUES   64
#define EXPR_MAX_PROOF_VALUES 64

// ---- Polynomial buffer parameters ----
// Maximum columns in any trace stage
#define EXPR_MAX_COLS         2048

// ---- Operation codes (matching GPU/CPU reference) ----
// Arithmetic operations (encoded in args[0])
#define EXPR_OP_ADD   0
#define EXPR_OP_SUB   1
#define EXPR_OP_MUL   2
#define EXPR_OP_RSUB  3   // reverse subtract: b - a

// Instruction opcodes (encoded in ops[kk])
#define EXPR_OPCODE_DIM1   0   // dim1 x dim1 -> dim1
#define EXPR_OPCODE_DIM31  1   // dim3 x dim1 -> dim3
#define EXPR_OPCODE_DIM33  2   // dim3 x dim3 -> dim3

#endif // VENUS_EXPR_CONFIG_HPP
