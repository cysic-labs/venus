// NTT Bit-Reversal Permutation for AMD FPGA (Vitis HLS)
//
// In-place bit-reversal permutation: for each index i, swap data[i] with
// data[bit_reverse(i, log_n)] when bit_reverse(i) > i.
//
// Reference: ntt_goldilocks.cu reverse_permutation_new, reverse_permutation_blocks

#ifndef VENUS_NTT_BITREV_HPP
#define VENUS_NTT_BITREV_HPP

#include "../goldilocks/gl64_t.hpp"
#include "ntt_config.hpp"
#include "ntt_addr_gen.hpp"

// In-place bit-reversal for a single column.
// Scans all indices and swaps pairs where bit_reverse(i) > i.
//
// For large N this is HBM-bandwidth-limited: requires N reads + N writes
// (each pair causes 2 reads + 2 writes, but ~N/2 pairs exist).
//
// Parameters:
//   data:   pointer to N elements in HBM (read-write)
//   log_n:  log2(domain_size)
inline void ntt_bitrev_inplace(
    ap_uint<64>* data,
    unsigned int log_n
) {
    #pragma HLS INLINE off
    uint32_t n = 1u << log_n;

    for (uint32_t i = 0; i < n; i++) {
        #pragma HLS PIPELINE II=1
        uint32_t j = bit_reverse(i, log_n);
        if (j > i) {
            ap_uint<64> tmp_i = data[i];
            ap_uint<64> tmp_j = data[j];
            data[i] = tmp_j;
            data[j] = tmp_i;
        }
    }
}

// Bit-reversal for block-parallel multi-column layout.
// Each column block (TILE_WIDTH columns) is stored contiguously.
//
// Matches GPU reverse_permutation_blocks:
//   For each row pair (r, bit_reverse(r)):
//     For each column in the block:
//       swap data[r * ncols_block + col] with data[br * ncols_block + col]
//
// Parameters:
//   data:        pointer to domain_size_out * TILE_WIDTH elements
//   log_n:       log2(domain_size_in)
//   ncols_block: number of columns in this block (<= TILE_WIDTH)
inline void ntt_bitrev_block(
    ap_uint<64>* data,
    unsigned int log_n,
    unsigned int ncols_block
) {
    #pragma HLS INLINE off
    uint32_t n = 1u << log_n;

    for (uint32_t r = 0; r < n; r++) {
        uint32_t br = bit_reverse(r, log_n);
        if (br > r) {
            for (unsigned int c = 0; c < ncols_block; c++) {
                #pragma HLS PIPELINE II=1
                uint32_t addr_r = r * ncols_block + c;
                uint32_t addr_br = br * ncols_block + c;
                ap_uint<64> tmp = data[addr_r];
                data[addr_r] = data[addr_br];
                data[addr_br] = tmp;
            }
        }
    }
}

// Bit-reversal for noBR (LDE) variant with blowup factor.
// Elements are spaced by blowupFactor in the output buffer.
//
// Matches GPU reverse_permutation_blocks_noBR.
inline void ntt_bitrev_block_nobr(
    ap_uint<64>* data,
    unsigned int log_n,
    unsigned int ncols_block,
    unsigned int blowup_factor
) {
    #pragma HLS INLINE off
    uint32_t n = 1u << log_n;

    for (uint32_t r = 0; r < n; r++) {
        uint32_t br = bit_reverse(r, log_n);
        if (br > r) {
            uint32_t r_bf = r * blowup_factor;
            uint32_t br_bf = br * blowup_factor;
            for (unsigned int c = 0; c < ncols_block; c++) {
                #pragma HLS PIPELINE II=1
                uint32_t addr_r = r_bf * ncols_block + c;
                uint32_t addr_br = br_bf * ncols_block + c;
                ap_uint<64> tmp = data[addr_r];
                data[addr_r] = data[addr_br];
                data[addr_br] = tmp;
            }
        }
    }
}

#endif // VENUS_NTT_BITREV_HPP
