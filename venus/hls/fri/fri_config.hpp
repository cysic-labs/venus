// FRI Protocol Compile-Time Configuration for AMD FPGA (Vitis HLS)
//
// Parameters for FRI folding, transposition, and query operations.
//
// Reference:
//   pil2-proofman/pil2-stark/src/starkpil/starks_gpu.cu
//     fold(), fold_v2(), intt_tinny(), domain_size_inverse_[]
//   pil2-proofman/pil2-stark/src/starkpil/fri/fri.hpp

#ifndef VENUS_FRI_CONFIG_HPP
#define VENUS_FRI_CONFIG_HPP

#include "../goldilocks/gl64_t.hpp"
#include "../goldilocks/gl64_cubic.hpp"
#include "../goldilocks/gl64_constants.hpp"

// ---- Field extension degree ----
#define FRI_FIELD_EXTENSION 3

// ---- FRI step parameters ----
// Maximum number of FRI folding steps
#define FRI_MAX_STEPS       16

// Maximum fold ratio per FRI step: 2^(prevBits - currentBits)
// Typical values: 4 (2-bit step), 8, 16 (4-bit step)
#define FRI_MAX_FOLD_RATIO  16

// Maximum log2 of fold ratio
#define FRI_MAX_LOG_RATIO   4

// Maximum domain size (log2), matching NTT max
#define FRI_MAX_DOMAIN_BITS 27

// ---- Query parameters ----
// Maximum number of FRI queries
#define FRI_MAX_QUERIES     128

// Maximum proof buffer size per query
// = tree_width + max_levels * (arity-1) * HASH_SIZE
#define FRI_MAX_PROOF_SIZE  512

// ---- Merkle tree parameters (from merkle module) ----
#define FRI_HASH_SIZE       4
#define FRI_MERKLE_ARITY    3

// ---- Maximum final polynomial size (after all folds) ----
#define FRI_MAX_FINAL_POL   64

// ---- Domain-size inverse lookup: (2^k)^{-1} mod p ----
// Needed for the N^{-1} scaling step in the small INTT.
// Matches domain_size_inverse_[] from the GPU reference.
//
// inv(2) = (p+1)/2 = 0x7FFFFFFF80000001
// inv(2^k) = inv(2)^k
static const uint64_t FRI_DOMAIN_INV_RAW[FRI_MAX_LOG_RATIO + 1] = {
    0x0000000000000001ULL,  // inv(2^0) = inv(1) = 1
    0x7FFFFFFF80000001ULL,  // inv(2^1) = inv(2)
    0xBFFFFFFF40000001ULL,  // inv(2^2) = inv(4)
    0xDFFFFFFF20000001ULL,  // inv(2^3) = inv(8)
    0xEFFFFFFF10000001ULL,  // inv(2^4) = inv(16)
};

// Helper: get domain size inverse for a given log
inline gl64_t fri_domain_inv(unsigned int logN) {
    #pragma HLS INLINE
    return gl64_t(FRI_DOMAIN_INV_RAW[logN]);
}

#endif // VENUS_FRI_CONFIG_HPP
