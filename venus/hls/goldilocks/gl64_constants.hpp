// Goldilocks Field Constants for FPGA HLS
// Roots of unity and other constants needed by NTT and hash functions.
//
// Source: pil2-proofman/pil2-stark/src/goldilocks/src/goldilocks_base_field.cpp

#ifndef VENUS_GL64_CONSTANTS_HPP
#define VENUS_GL64_CONSTANTS_HPP

#include "gl64_t.hpp"

// Principal 2^k-th roots of unity for the Goldilocks field.
// W[k] is the principal 2^k-th root of unity, i.e. W[k]^(2^k) = 1 (mod p).
// The NTT of size 2^k uses W[k] as its twiddle factor generator.
// Maximum supported NTT size: 2^32 (using W[32]).
static const uint64_t GL64_ROOTS_RAW[33] = {
    0x0000000000000001ULL,  //  0: 1
    0xFFFFFFFF00000000ULL,  //  1: p-1 = -1
    0x0001000000000000ULL,  //  2: 2^48
    0x0000000001000000ULL,  //  3: 2^24
    0x0000000000001000ULL,  //  4: 2^12 = 4096
    0x0000000000000040ULL,  //  5: 64
    0x0000000000000008ULL,  //  6: 8
    0x000001FFFDFFFE00ULL,  //  7: from ntt_goldilocks.cuh
    0x3D212E8CBC8A1ED3ULL,  //  8
    0x594C6B9EF1635CA5ULL,  //  9
    0x3B0D463D6552A871ULL,  // 10
    0x7E785A6E2821983EULL,  // 11
    0x3C713933C4EB986BULL,  // 12
    0x3BCAB9C3F9DDE835ULL,  // 13
    0x62E4B94776C81AAAULL,  // 14
    0x1A0037386D98CA5EULL,  // 15
    0x71578C3FD9199C53ULL,  // 16
    0x4F5AAFC1370CC51AULL,  // 17
    0x2F57BB2F67816280ULL,  // 18
    0x7CA80B47BA4B38BDULL,  // 19
    0x1B5C0AD6B72DB3A1ULL,  // 20
    0x5AF3327DEA3A8CB9ULL,  // 21
    0x70C12BC56D66855CULL,  // 22
    0x5262AEE151C7655EULL,  // 23
    0x259B60F3625BAE63ULL,  // 24
    0x7B3336E748AC4576ULL,  // 25
    0x3425B3E207B557BFULL,  // 26
    0x44F8E4C2E7CBB309ULL,  // 27
    0x1DCC93E918DECF53ULL,  // 28
    0x231E5F6A3F50A6BBULL,  // 29
    0x1A708F62D4C6586BULL,  // 30
    0x30EAA905858B619FULL,  // 31
    0x64FDD1A46201E246ULL,  // 32
};

// Helper to get the k-th root of unity as a gl64_t
inline gl64_t gl64_root_of_unity(unsigned int k) {
    #pragma HLS INLINE
    return gl64_t(GL64_ROOTS_RAW[k]);
}

// The multiplicative generator (shift element) used in LDE
static const uint64_t GL64_SHIFT_RAW = 7;

inline gl64_t gl64_shift() {
    #pragma HLS INLINE
    return gl64_t(GL64_SHIFT_RAW);
}

#endif // VENUS_GL64_CONSTANTS_HPP
