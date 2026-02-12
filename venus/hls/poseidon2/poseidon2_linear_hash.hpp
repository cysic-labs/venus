// Poseidon2 Sponge-Mode Linear Hash for AMD FPGA (Vitis HLS)
//
// Implements sponge-mode hashing of variable-length input,
// matching the CPU reference:
//   pil2-proofman/pil2-stark/src/goldilocks/src/poseidon2_goldilocks.cpp
//   Poseidon2Goldilocks<12>::linear_hash_seq()
//
// Sponge construction:
//   - RATE = 8 elements absorbed per permutation
//   - CAPACITY = 4 elements carried between permutations
//   - Output = capacity portion after final permutation

#ifndef VENUS_POSEIDON2_LINEAR_HASH_HPP
#define VENUS_POSEIDON2_LINEAR_HASH_HPP

#include "../goldilocks/gl64_t.hpp"
#include "poseidon2_config.hpp"
#include "poseidon2_core.hpp"

// ---- Linear hash: sponge-mode hash of variable-length input ----
// Absorbs RATE=8 elements at a time, applies Poseidon2 permutation,
// carries CAPACITY=4 elements forward. Outputs CAPACITY=4 elements.
//
// Algorithm (matching CPU reference exactly):
//   if size <= CAPACITY:
//     output = input[0..size-1], zero-padded to CAPACITY
//     return
//   while remaining > 0:
//     if first iteration:
//       state[RATE..RATE+CAPACITY-1] = 0   (zero capacity)
//     else:
//       state[RATE..RATE+CAPACITY-1] = prev_state[0..CAPACITY-1]
//     n = min(remaining, RATE)
//     state[0..n-1] = input chunk
//     state[n..RATE-1] = 0    (zero-pad)
//     state = poseidon2_permutation(state)
//     remaining -= n
//   output = state[0..CAPACITY-1]
//
// MAX_SIZE: compile-time bound on input size for HLS loop bounds.
template <unsigned int MAX_SIZE>
void p2_linear_hash(gl64_t output[P2_CAPACITY],
                    const gl64_t* input,
                    unsigned int size) {
    #pragma HLS INLINE off

    gl64_t state[P2_SPONGE_WIDTH];
    #pragma HLS ARRAY_PARTITION variable=state complete

    // Short input: no hash needed, just copy + zero-pad
    if (size <= P2_CAPACITY) {
        for (unsigned int i = 0; i < P2_CAPACITY; i++) {
            #pragma HLS UNROLL
            output[i] = (i < size) ? input[i] : gl64_t::zero();
        }
        return;
    }

    unsigned int remaining = size;
    bool first = true;

    // Sponge absorption loop
    SPONGE_LOOP:
    while (remaining > 0) {
        #pragma HLS LOOP_TRIPCOUNT min=1 max=MAX_SIZE/P2_RATE+1

        // Set capacity portion
        if (first) {
            for (unsigned int i = P2_RATE; i < P2_SPONGE_WIDTH; i++) {
                #pragma HLS UNROLL
                state[i] = gl64_t::zero();
            }
            first = false;
        } else {
            // Carry capacity from previous hash output
            for (unsigned int i = 0; i < P2_CAPACITY; i++) {
                #pragma HLS UNROLL
                state[P2_RATE + i] = state[i];
            }
        }

        // Determine how many elements to absorb this iteration
        unsigned int n = (remaining < P2_RATE) ? remaining : P2_RATE;
        unsigned int offset = size - remaining;

        // Absorb input into rate portion
        for (unsigned int i = 0; i < P2_RATE; i++) {
            #pragma HLS UNROLL
            state[i] = (i < n) ? input[offset + i] : gl64_t::zero();
        }

        // Apply Poseidon2 permutation
        p2_hash_full_result(state);

        remaining -= n;
    }

    // Extract capacity as output
    for (unsigned int i = 0; i < P2_CAPACITY; i++) {
        #pragma HLS UNROLL
        output[i] = state[i];
    }
}

// ---- AXI-MM variant for streaming from HBM ----
// Reads input from AXI memory-mapped interface, outputs to AXI-MM.
// Processes num_rows independent rows, each of num_cols elements.
template <unsigned int MAX_COLS>
void p2_linear_hash_rows(const ap_uint<64>* input,
                         ap_uint<64>* output,
                         unsigned int num_cols,
                         unsigned int num_rows) {
    #pragma HLS INLINE off

    ROW_LOOP:
    for (unsigned int row = 0; row < num_rows; row++) {
        #pragma HLS LOOP_TRIPCOUNT min=1 max=1048576

        gl64_t state[P2_SPONGE_WIDTH];
        #pragma HLS ARRAY_PARTITION variable=state complete

        unsigned int base = row * num_cols;

        if (num_cols <= P2_CAPACITY) {
            // Short row: direct copy
            for (unsigned int i = 0; i < P2_CAPACITY; i++) {
                #pragma HLS PIPELINE II=1
                ap_uint<64> v = (i < num_cols) ? input[base + i]
                                               : ap_uint<64>(0);
                output[row * P2_CAPACITY + i] = v;
            }
        } else {
            unsigned int remaining = num_cols;
            bool first = true;

            SPONGE_INNER:
            while (remaining > 0) {
                #pragma HLS LOOP_TRIPCOUNT min=1 max=MAX_COLS/P2_RATE+1

                if (first) {
                    for (unsigned int i = P2_RATE; i < P2_SPONGE_WIDTH; i++) {
                        #pragma HLS UNROLL
                        state[i] = gl64_t::zero();
                    }
                    first = false;
                } else {
                    for (unsigned int i = 0; i < P2_CAPACITY; i++) {
                        #pragma HLS UNROLL
                        state[P2_RATE + i] = state[i];
                    }
                }

                unsigned int n = (remaining < P2_RATE) ? remaining : P2_RATE;
                unsigned int offset = base + (num_cols - remaining);

                // Read rate elements from AXI-MM
                for (unsigned int i = 0; i < P2_RATE; i++) {
                    #pragma HLS PIPELINE II=1
                    if (i < n) {
                        state[i] = gl64_t(input[offset + i]);
                    } else {
                        state[i] = gl64_t::zero();
                    }
                }

                p2_hash_full_result(state);
                remaining -= n;
            }

            // Write capacity output
            for (unsigned int i = 0; i < P2_CAPACITY; i++) {
                #pragma HLS PIPELINE II=1
                output[row * P2_CAPACITY + i] = state[i].val;
            }
        }
    }
}

#endif // VENUS_POSEIDON2_LINEAR_HASH_HPP
