// NTT Data Layout Transpose for AMD FPGA (Vitis HLS)
//
// Converts between row-major and block-parallel data layouts used by the
// NTT and other prover kernels.
//
// Block-parallel layout (used during NTT):
//   Columns grouped into blocks of TILE_WIDTH.
//   Within each block, elements are stored column-major:
//     block[col_local][row] = data[block_offset + row * TILE_WIDTH + col_local]
//
// Row-major layout (used for expression evaluation, Merkle, etc.):
//   All columns for one row are contiguous:
//     data[row * nCols + col]
//
// Reference: ntt_goldilocks.cu transposeSubBlocksInPlace,
//            transposeSubBlocksBackInPlace
//            data_layout.cuh getBufferOffset, getBufferOffsetRowMajor

#ifndef VENUS_NTT_TRANSPOSE_HPP
#define VENUS_NTT_TRANSPOSE_HPP

#include "../goldilocks/gl64_t.hpp"
#include "ntt_config.hpp"

// Transpose from row-major to block-parallel layout.
//
// Source: src[row * n_cols + col]
// Dest:   dst[block * TILE_WIDTH * n_rows + row * ncols_block + col_local]
//   where block = col / TILE_WIDTH, col_local = col % TILE_WIDTH
//   and ncols_block = min(TILE_WIDTH, n_cols - block * TILE_WIDTH)
//
// This is "transposeSubBlocksInPlace" from the GPU, but implemented as
// a copy between two buffers for simplicity.  In-place variants can be
// added later if HBM capacity is tight.
inline void ntt_transpose_to_block(
    const ap_uint<64>* src,
    ap_uint<64>* dst,
    unsigned int n_rows,
    unsigned int n_cols
) {
    #pragma HLS INLINE off
    unsigned int n_blocks = (n_cols + TILE_WIDTH - 1) / TILE_WIDTH;

    for (unsigned int block = 0; block < n_blocks; block++) {
        unsigned int col_base = block * TILE_WIDTH;
        unsigned int ncols_block = (n_cols - col_base) < TILE_WIDTH
                                 ? (n_cols - col_base) : TILE_WIDTH;
        uint64_t block_offset = (uint64_t)block * TILE_WIDTH * n_rows;

        for (unsigned int row = 0; row < n_rows; row++) {
            for (unsigned int c = 0; c < ncols_block; c++) {
                #pragma HLS PIPELINE II=1
                uint64_t src_addr = (uint64_t)row * n_cols + col_base + c;
                uint64_t dst_addr = block_offset + (uint64_t)row * ncols_block + c;
                dst[dst_addr] = src[src_addr];
            }
        }
    }
}

// Transpose from block-parallel to row-major layout.
//
// Inverse of ntt_transpose_to_block.
inline void ntt_transpose_to_rowmajor(
    const ap_uint<64>* src,
    ap_uint<64>* dst,
    unsigned int n_rows,
    unsigned int n_cols
) {
    #pragma HLS INLINE off
    unsigned int n_blocks = (n_cols + TILE_WIDTH - 1) / TILE_WIDTH;

    for (unsigned int block = 0; block < n_blocks; block++) {
        unsigned int col_base = block * TILE_WIDTH;
        unsigned int ncols_block = (n_cols - col_base) < TILE_WIDTH
                                 ? (n_cols - col_base) : TILE_WIDTH;
        uint64_t block_offset = (uint64_t)block * TILE_WIDTH * n_rows;

        for (unsigned int row = 0; row < n_rows; row++) {
            for (unsigned int c = 0; c < ncols_block; c++) {
                #pragma HLS PIPELINE II=1
                uint64_t src_addr = block_offset + (uint64_t)row * ncols_block + c;
                uint64_t dst_addr = (uint64_t)row * n_cols + col_base + c;
                dst[dst_addr] = src[src_addr];
            }
        }
    }
}

// Transpose with noBR layout for LDE (compact format).
//
// Source: block-parallel layout with domain_size_in rows
// Dest:   block-parallel layout with domain_size_out rows (zero-extended)
//
// Only domain_size_in / blowup_factor rows contain data; the rest are zero.
// Elements are placed at stride blowup_factor in the output.
//
// Matches GPU transposeSubBlocksBack_noBR_compact.
inline void ntt_transpose_back_nobr_compact(
    const ap_uint<64>* src,
    ap_uint<64>* dst,
    unsigned int log_n_in,
    unsigned int log_n_out,
    unsigned int n_cols
) {
    #pragma HLS INLINE off
    uint32_t n_in = 1u << log_n_in;
    uint32_t n_out = 1u << log_n_out;
    uint32_t blowup = n_out / n_in;
    unsigned int n_blocks = (n_cols + TILE_WIDTH - 1) / TILE_WIDTH;

    for (unsigned int block = 0; block < n_blocks; block++) {
        unsigned int col_base = block * TILE_WIDTH;
        unsigned int ncols_block = (n_cols - col_base) < TILE_WIDTH
                                 ? (n_cols - col_base) : TILE_WIDTH;
        uint64_t src_block_offset = (uint64_t)block * TILE_WIDTH * n_in;
        uint64_t dst_block_offset = (uint64_t)block * TILE_WIDTH * n_out;

        // Zero the destination block first
        for (uint32_t row = 0; row < n_out; row++) {
            for (unsigned int c = 0; c < ncols_block; c++) {
                #pragma HLS PIPELINE II=1
                dst[dst_block_offset + (uint64_t)row * ncols_block + c] = 0;
            }
        }

        // Copy source data into strided positions
        for (uint32_t row = 0; row < n_in; row++) {
            for (unsigned int c = 0; c < ncols_block; c++) {
                #pragma HLS PIPELINE II=1
                uint64_t src_addr = src_block_offset
                    + (uint64_t)row * ncols_block + c;
                // Place at position row within the appropriate sub-block
                uint32_t block_x = row / (TILE_HEIGHT / blowup);
                uint32_t row_block = row % (TILE_HEIGHT / blowup);
                uint32_t dst_row = block_x * TILE_HEIGHT + row_block;
                uint64_t dst_addr = dst_block_offset
                    + (uint64_t)dst_row * ncols_block + c;
                dst[dst_addr] = src[src_addr];
            }
        }
    }
}

#endif // VENUS_NTT_TRANSPOSE_HPP
