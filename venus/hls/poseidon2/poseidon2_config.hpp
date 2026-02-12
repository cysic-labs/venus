// Poseidon2 Compile-Time Configuration for AMD FPGA (Vitis HLS)
//
// Template parameters for the Poseidon2 hash function over Goldilocks.
// The prover uses SPONGE_WIDTH=12 (arity=3) as the primary configuration.

#ifndef VENUS_POSEIDON2_CONFIG_HPP
#define VENUS_POSEIDON2_CONFIG_HPP

#include <cstdint>

// Sponge dimensions
static const unsigned int P2_SPONGE_WIDTH = 12;
static const unsigned int P2_CAPACITY = 4;
static const unsigned int P2_RATE = P2_SPONGE_WIDTH - P2_CAPACITY; // 8

// Round counts
static const unsigned int P2_FULL_ROUNDS_TOTAL = 8;
static const unsigned int P2_HALF_FULL_ROUNDS = P2_FULL_ROUNDS_TOTAL / 2; // 4
static const unsigned int P2_PARTIAL_ROUNDS = 22;
static const unsigned int P2_TOTAL_ROUNDS = P2_FULL_ROUNDS_TOTAL + P2_PARTIAL_ROUNDS; // 30

// Number of round constants in C array:
//   HALF_FULL * SPONGE_WIDTH + PARTIAL + HALF_FULL * SPONGE_WIDTH
//   = 4*12 + 22 + 4*12 = 118
static const unsigned int P2_NUM_C = P2_FULL_ROUNDS_TOTAL * P2_SPONGE_WIDTH + P2_PARTIAL_ROUNDS; // 118

// Hash output size (= CAPACITY)
static const unsigned int P2_HASH_SIZE = P2_CAPACITY; // 4 field elements

// Number of parallel hash units for Merkle tree construction
static const unsigned int P2_N_HASH_UNITS = 4;

#endif // VENUS_POSEIDON2_CONFIG_HPP
