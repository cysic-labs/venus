// NTT Address Generation for AMD FPGA (Vitis HLS)
//
// Generates HBM and BRAM addresses for the multi-pass butterfly architecture.
// Replicates the GPU's element-to-batch mapping from br_ntt_batch_steps_blocks_par.
//
// Reference: ntt_goldilocks.cu br_ntt_batch_steps_blocks_par address computation

#ifndef VENUS_NTT_ADDR_GEN_HPP
#define VENUS_NTT_ADDR_GEN_HPP

#include "ntt_config.hpp"
#include <cstdint>

// Bit-reverse a 32-bit integer and shift right to get n-bit reversal.
// Matches GPU's __brev(x) >> (32 - n).
inline uint32_t bit_reverse(uint32_t x, unsigned int n) {
    #pragma HLS INLINE
    // Swap adjacent bits
    x = ((x & 0x55555555u) << 1) | ((x & 0xAAAAAAAAu) >> 1);
    // Swap adjacent 2-bit groups
    x = ((x & 0x33333333u) << 2) | ((x & 0xCCCCCCCCu) >> 2);
    // Swap nibbles
    x = ((x & 0x0F0F0F0Fu) << 4) | ((x & 0xF0F0F0F0u) >> 4);
    // Swap bytes
    x = ((x & 0x00FF00FFu) << 8) | ((x & 0xFF00FF00u) >> 8);
    // Swap 16-bit halves
    x = (x << 16) | (x >> 16);
    return x >> (32 - n);
}

// Compute the global HBM row index for a given local thread within a batch.
//
// This matches the GPU mapping in br_ntt_batch_steps_blocks_par:
//   groupSize = 1 << base_step
//   nGroups = domain_size / groupSize
//   low_bits = row / nGroups
//   high_bits = row % nGroups
//   global_row = high_bits * groupSize + low_bits
//
// Parameters:
//   batch_id:    which batch (0 .. n_batches-1)
//   local_idx:   element index within batch (0 .. BATCH_SIZE-1)
//   base_step:   first global butterfly stage for this pass
//   log_n:       log2(domain_size)
//
// Returns: global row index in [0, domain_size)
inline uint32_t ntt_global_row_dit(
    uint32_t batch_id,
    uint32_t local_idx,
    uint32_t base_step,
    uint32_t log_n
) {
    #pragma HLS INLINE
    uint32_t domain_size = 1u << log_n;
    // Linear thread index across all batches
    uint32_t row = batch_id * BATCH_SIZE + local_idx;

    uint32_t groupSize = 1u << base_step;
    uint32_t nGroups = domain_size / groupSize;
    uint32_t low_bits = row / nGroups;
    uint32_t high_bits = row % nGroups;
    return high_bits * groupSize + low_bits;
}

// Compute the global HBM row for DIF (stages run in reverse).
//
// Matches br_ntt_batch_steps_blocks_par_dif addressing:
// Same formula but base_step counts from the top.
inline uint32_t ntt_global_row_dif(
    uint32_t batch_id,
    uint32_t local_idx,
    uint32_t base_step,
    uint32_t log_n,
    uint32_t n_loc_steps
) {
    #pragma HLS INLINE
    uint32_t domain_size = 1u << log_n;
    uint32_t row = batch_id * BATCH_SIZE + local_idx;

    uint32_t groupSize = 1u << (base_step + 1 - n_loc_steps);
    uint32_t nGroups = domain_size / groupSize;
    uint32_t low_bits = row / nGroups;
    uint32_t high_bits = row % nGroups;
    return high_bits * groupSize + low_bits;
}

// Compute butterfly pair indices within the on-chip BRAM buffer.
//
// For local butterfly stage `loc_step` (0-based within the batch):
//   group_size = 2^loc_step
//   For butterfly index i (0 .. BATCH_HALF-1):
//     group = i / group_size
//     group_pos = i % group_size
//     index1 = 2 * group * group_size + group_pos
//     index2 = index1 + group_size
//
// This matches the GPU's inner butterfly addressing.
inline void ntt_butterfly_indices(
    uint32_t i,
    uint32_t loc_step,
    uint32_t& index1,
    uint32_t& index2
) {
    #pragma HLS INLINE
    uint32_t group_size = 1u << loc_step;
    uint32_t group = i >> loc_step;              // i / group_size
    uint32_t group_pos = i & (group_size - 1u);  // i % group_size
    index1 = (group << (loc_step + 1)) + group_pos;
    index2 = index1 + group_size;
}

// Compute the twiddle factor index for a butterfly within the global NTT.
//
// Matches GPU twiddle indexing from br_ntt_batch_steps_blocks_par:
//   global_step = base_step + loc_step
//   global_group_size = 2^global_step
//   batched_butterfly_index = blockIdx.x * BATCH_HALF + i
//   global_butterfly_index = undo_batching(bbi)
//   global_group_pos = gbi % global_group_size
//   twiddle_idx = global_group_pos * (2^maxLogN >> (global_step + 1))
//
// For on-chip ROM access, we return just global_group_pos (the ROM
// stores twiddles pre-indexed for the current stage).
inline uint32_t ntt_twiddle_index_dit(
    uint32_t batch_id,
    uint32_t butterfly_i,
    uint32_t base_step,
    uint32_t loc_step,
    uint32_t log_n
) {
    #pragma HLS INLINE
    uint32_t gs = base_step + loc_step;       // global step
    uint32_t ggs = 1u << gs;                  // global group size

    // Remaining high bits for batching
    uint32_t remaining_high_bits = log_n - (base_step + 1);
    uint32_t high_mask = (1u << remaining_high_bits) - 1u;

    // Batched butterfly index
    uint32_t bbi = batch_id * BATCH_HALF + butterfly_i;

    // Undo the batching to get global butterfly index
    uint32_t gbi = ((bbi & high_mask) << base_step) + (bbi >> remaining_high_bits);

    // Global group position
    uint32_t ggp = gbi & (ggs - 1u);

    return ggp;
}

// Twiddle index for DIF (reverse stage order).
inline uint32_t ntt_twiddle_index_dif(
    uint32_t batch_id,
    uint32_t butterfly_i,
    uint32_t base_step,
    uint32_t loc_step,
    uint32_t log_n,
    uint32_t n_loc_steps
) {
    #pragma HLS INLINE
    uint32_t gs = base_step - (n_loc_steps - 1 - loc_step);
    uint32_t ggs = 1u << gs;

    uint32_t remaining_high_bits = log_n - 1 - (base_step + 1 - n_loc_steps);
    uint32_t high_mask = (1u << remaining_high_bits) - 1u;

    uint32_t bbi = batch_id * BATCH_HALF + butterfly_i;
    uint32_t gbi = ((bbi & high_mask) << (base_step + 1 - n_loc_steps))
                 + (bbi >> remaining_high_bits);
    uint32_t ggp = gbi & (ggs - 1u);

    return ggp;
}

// INTT index mapping: for the inverse NTT, element i maps to
// position (N - i) mod N after the final stage.
// Reference: ntt_goldilocks.hpp intt_idx
inline uint32_t ntt_intt_idx(uint32_t i, uint32_t n) {
    #pragma HLS INLINE
    return (i == 0) ? 0 : (n - i);
}

// Compute HBM address for multi-column block-parallel layout.
//
// Matches GPU data_layout.cuh getBufferOffset:
//   block = col / TILE_WIDTH
//   block_offset = block * TILE_HEIGHT * TILE_WIDTH
//   local_col = col % TILE_WIDTH
//   address = block_offset + row * TILE_WIDTH + local_col
//
// This layout groups TILE_WIDTH columns together for memory coalescing.
inline uint64_t ntt_block_layout_addr(
    uint32_t row,
    uint32_t col,
    uint32_t domain_size_out
) {
    #pragma HLS INLINE
    uint32_t block = col / TILE_WIDTH;
    uint32_t local_col = col % TILE_WIDTH;
    uint64_t block_offset = (uint64_t)block * TILE_WIDTH * domain_size_out;
    return block_offset + (uint64_t)row * TILE_WIDTH + local_col;
}

// Row-major address for multi-column layout.
// Simple: row * nCols + col
inline uint64_t ntt_row_major_addr(
    uint32_t row,
    uint32_t col,
    uint32_t n_cols
) {
    #pragma HLS INLINE
    return (uint64_t)row * n_cols + col;
}

#endif // VENUS_NTT_ADDR_GEN_HPP
