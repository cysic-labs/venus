// Expression Evaluation - Cubic Extension Field Arithmetic Dispatchers
//
// Re-exports gl64_3_t from the canonical goldilocks implementation
// and adds expression-evaluation-specific arithmetic dispatch functions.
//
// Reference:
//   pil2-proofman/pil2-stark/src/starkpil/expressions_gpu.cu
//     computeExpressions_() opcode dispatch logic

#ifndef VENUS_EXPR_GL64_3_T_HPP
#define VENUS_EXPR_GL64_3_T_HPP

#include "../goldilocks/gl64_cubic.hpp"
#include "expr_config.hpp"

// ---- Generic arithmetic dispatcher for dim1 (base field) ----
// op: 0=add, 1=sub, 2=mul, 3=rsub
static inline gl64_t expr_op_dim1(unsigned int op, gl64_t a, gl64_t b) {
    #pragma HLS INLINE
    switch (op) {
        case EXPR_OP_ADD:  return a + b;
        case EXPR_OP_SUB:  return a - b;
        case EXPR_OP_MUL:  return a * b;
        case EXPR_OP_RSUB: return b - a;
        default:           return gl64_t::zero();
    }
}

// ---- Generic arithmetic dispatcher for dim3 x dim1 ----
// op: 0=add, 1=sub, 2=mul, 3=rsub
static inline gl64_3_t expr_op_dim31(unsigned int op, gl64_3_t a, gl64_t b) {
    #pragma HLS INLINE
    switch (op) {
        case EXPR_OP_ADD:  return a + b;
        case EXPR_OP_SUB:  return gl64_3_t(a.v[0] - b, a.v[1], a.v[2]);
        case EXPR_OP_MUL:  return a * b;
        case EXPR_OP_RSUB: return b - a;  // uses friend operator-(gl64_t, gl64_3_t)
        default:           return gl64_3_t::zero();
    }
}

// ---- Generic arithmetic dispatcher for dim3 x dim3 ----
// op: 0=add, 1=sub, 2=mul, 3=rsub
static inline gl64_3_t expr_op_dim33(unsigned int op, gl64_3_t a, gl64_3_t b) {
    #pragma HLS INLINE
    switch (op) {
        case EXPR_OP_ADD:  return a + b;
        case EXPR_OP_SUB:  return a - b;
        case EXPR_OP_MUL:  return a * b;
        case EXPR_OP_RSUB: return b - a;
        default:           return gl64_3_t::zero();
    }
}

#endif // VENUS_EXPR_GL64_3_T_HPP
