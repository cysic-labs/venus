// Poseidon2 Core Permutation for AMD FPGA (Vitis HLS)
//
// Implements the Poseidon2 hash permutation over Goldilocks field
// for SPONGE_WIDTH=12. Matches the CPU/GPU reference:
//   pil2-proofman/pil2-stark/src/goldilocks/src/poseidon2_goldilocks.cpp
//   pil2-proofman/pil2-stark/src/goldilocks/src/poseidon2_goldilocks.cuh
//
// Design: iterative round processor with 12 parallel gl64_mul units.
// ~328 cycles per hash @ 300 MHz.

#ifndef VENUS_POSEIDON2_CORE_HPP
#define VENUS_POSEIDON2_CORE_HPP

#include "../goldilocks/gl64_t.hpp"
#include "poseidon2_config.hpp"
#include "poseidon2_constants.hpp"

// ---- S-box: x^7 ----
// Computed as: x^2 = x*x, x^3 = x*x^2, x^4 = x^2*x^2, x^7 = x^3*x^4
// Cost: 4 gl64_mul
static void p2_pow7(gl64_t& x) {
    #pragma HLS INLINE
    gl64_t x2 = x * x;
    gl64_t x3 = x * x2;
    gl64_t x4 = x2 * x2;
    x = x3 * x4;
}

// ---- S-box with round constant addition: (x + c)^7 ----
// For full rounds, applied to all SPONGE_WIDTH elements.
static void p2_pow7add(gl64_t state[P2_SPONGE_WIDTH],
                       const gl64_t C[P2_SPONGE_WIDTH]) {
    #pragma HLS INLINE
    for (unsigned int i = 0; i < P2_SPONGE_WIDTH; i++) {
        #pragma HLS UNROLL
        gl64_t xi = state[i] + C[i];
        gl64_t x2 = xi * xi;
        gl64_t x3 = xi * x2;
        gl64_t x4 = x2 * x2;
        state[i] = x3 * x4;
    }
}

// ---- matmul_m4: 4x4 MDS matrix using ONLY additions ----
// Matches GPU matmul_m4_ exactly:
//   t0=x[0]+x[1]; t1=x[2]+x[3]; t2=2*x[1]+t1; t3=2*x[3]+t0
//   t4=4*t1+t3; t5=4*t0+t2; t6=t3+t5; t7=t2+t4
//   x = [t6, t5, t7, t4]
static void p2_matmul_m4(gl64_t x[4]) {
    #pragma HLS INLINE
    gl64_t t0 = x[0] + x[1];
    gl64_t t1 = x[2] + x[3];
    gl64_t t2 = x[1] + x[1] + t1;      // 2*x[1] + t1
    gl64_t t3 = x[3] + x[3] + t0;      // 2*x[3] + t0
    gl64_t t1_2 = t1 + t1;
    gl64_t t0_2 = t0 + t0;
    gl64_t t4 = t1_2 + t1_2 + t3;      // 4*t1 + t3
    gl64_t t5 = t0_2 + t0_2 + t2;      // 4*t0 + t2
    gl64_t t6 = t3 + t5;
    gl64_t t7 = t2 + t4;
    x[0] = t6;
    x[1] = t5;
    x[2] = t7;
    x[3] = t4;
}

// ---- matmul_external: External MDS matrix for W=12 ----
// For W=12 (3 groups of 4):
//   1. Apply matmul_m4 to state[0:3], state[4:7], state[8:11]
//   2. stored[j] = state[j] + state[j+4] + state[j+8]  for j=0..3
//   3. state[i] += stored[i % 4]  for all i
static void p2_matmul_external(gl64_t state[P2_SPONGE_WIDTH]) {
    #pragma HLS INLINE
    // Apply matmul_m4 to each group of 4
    p2_matmul_m4(&state[0]);
    p2_matmul_m4(&state[4]);
    p2_matmul_m4(&state[8]);

    // Cross-group sum (column sums across groups)
    gl64_t stored[4];
    #pragma HLS ARRAY_PARTITION variable=stored complete
    for (unsigned int j = 0; j < 4; j++) {
        #pragma HLS UNROLL
        stored[j] = state[j] + state[j + 4] + state[j + 8];
    }

    // Add column sums back
    for (unsigned int i = 0; i < P2_SPONGE_WIDTH; i++) {
        #pragma HLS UNROLL
        state[i] = state[i] + stored[i & 3];
    }
}

// ---- Full Poseidon2 permutation ----
// Computes the Poseidon2 permutation in-place on state[12].
// Returns the full state; caller extracts capacity (state[0..3]) as digest.
//
// Algorithm:
//   1. matmul_external(state)
//   2. 4 full rounds: pow7add + matmul_external
//   3. 22 partial rounds: const_add[0] + pow7[0] + sum + prodadd
//   4. 4 full rounds: pow7add + matmul_external
static void p2_hash_full_result(gl64_t state[P2_SPONGE_WIDTH]) {
    #pragma HLS INLINE off
    #pragma HLS ARRAY_PARTITION variable=state complete

    // Initial linear layer
    p2_matmul_external(state);

    // First half full rounds (4 rounds)
    for (unsigned int r = 0; r < P2_HALF_FULL_ROUNDS; r++) {
        #pragma HLS PIPELINE off
        p2_pow7add(state, &P2_C12[r * P2_SPONGE_WIDTH]);
        p2_matmul_external(state);
    }

    // Partial rounds (22 rounds)
    for (unsigned int r = 0; r < P2_PARTIAL_ROUNDS; r++) {
        #pragma HLS PIPELINE off
        // Round constant addition (element 0 only)
        state[0] = state[0] + P2_C12[P2_HALF_FULL_ROUNDS * P2_SPONGE_WIDTH + r];

        // S-box on element 0 only
        p2_pow7(state[0]);

        // Compute sum of all elements
        gl64_t sum = gl64_t::zero();
        for (unsigned int i = 0; i < P2_SPONGE_WIDTH; i++) {
            #pragma HLS UNROLL
            sum = sum + state[i];
        }

        // Internal diffusion: state[i] = state[i] * D[i] + sum
        for (unsigned int i = 0; i < P2_SPONGE_WIDTH; i++) {
            #pragma HLS UNROLL
            state[i] = state[i] * P2_D12[i] + sum;
        }
    }

    // Second half full rounds (4 rounds)
    for (unsigned int r = 0; r < P2_HALF_FULL_ROUNDS; r++) {
        #pragma HLS PIPELINE off
        p2_pow7add(state,
                   &P2_C12[P2_HALF_FULL_ROUNDS * P2_SPONGE_WIDTH +
                           P2_PARTIAL_ROUNDS +
                           r * P2_SPONGE_WIDTH]);
        p2_matmul_external(state);
    }
}

// ---- Single hash (capacity output only) ----
// Hashes input[12] and produces output[4] (the capacity portion).
static void p2_hash(gl64_t output[P2_CAPACITY],
                    const gl64_t input[P2_SPONGE_WIDTH]) {
    #pragma HLS INLINE off
    gl64_t state[P2_SPONGE_WIDTH];
    #pragma HLS ARRAY_PARTITION variable=state complete

    for (unsigned int i = 0; i < P2_SPONGE_WIDTH; i++) {
        #pragma HLS UNROLL
        state[i] = input[i];
    }

    p2_hash_full_result(state);

    for (unsigned int i = 0; i < P2_CAPACITY; i++) {
        #pragma HLS UNROLL
        output[i] = state[i];
    }
}

#endif // VENUS_POSEIDON2_CORE_HPP
