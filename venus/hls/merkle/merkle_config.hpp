// Merkle Tree Compile-Time Configuration for AMD FPGA (Vitis HLS)
//
// Parameters for Merkle tree construction using Poseidon2 hash
// over Goldilocks field.

#ifndef VENUS_MERKLE_CONFIG_HPP
#define VENUS_MERKLE_CONFIG_HPP

#include <cstdint>
#include "../poseidon2/poseidon2_config.hpp"

// Hash output size (= Poseidon2 CAPACITY = 4 field elements)
static const unsigned int MT_HASH_SIZE = P2_CAPACITY; // 4

// Default arity (prover uses 3 as primary)
static const unsigned int MT_DEFAULT_ARITY = 3;

// Maximum supported arity
static const unsigned int MT_MAX_ARITY = 4;

// Sponge widths for each arity:
//   arity=2 -> SPONGE_WIDTH=8  (2 children * 4 = 8)
//   arity=3 -> SPONGE_WIDTH=12 (3 children * 4 = 12)
//   arity=4 -> SPONGE_WIDTH=16 (4 children * 4 = 16)

// Maximum number of tree levels (supports up to 2^27 leaves with arity=2)
static const unsigned int MT_MAX_LEVELS = 27;

// Maximum columns per leaf row for linearHash
static const unsigned int MT_MAX_COLS = 1024;

// Number of parallel hash units for tree construction
static const unsigned int MT_N_HASH_UNITS = 4;

#endif // VENUS_MERKLE_CONFIG_HPP
