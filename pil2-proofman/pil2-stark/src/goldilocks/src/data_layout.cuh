#ifndef __DATA_LAYOUT_CUH__
#define __DATA_LAYOUT_CUH__

#include <stdint.h>

// GPU_RESTRICT: __restrict__ on hot kernel pointers
// Enabled by ENABLE_GPU_RESTRICT flag or OPT_LEVEL == 3 only.
// NOT included at OPT_LEVEL >= 4 — causes regression on medium inputs
// by changing nvcc code generation globally.
#if defined(ENABLE_GPU_RESTRICT) || (defined(OPT_LEVEL) && OPT_LEVEL == 3)
#define GPU_RESTRICT __restrict__
#else
#define GPU_RESTRICT
#endif

// R2-P4: __launch_bounds__ disabled — causes 3.3% regression on small inputs
// by over-constraining register allocation (minBlocks=2 → 128 regs/thread).
// The compiler's default heuristic performs better across all input sizes.
#define GPU_LAUNCH_BOUNDS(maxThreads, minBlocks)

// Poseidon2 threads per block: 256 at OPT_LEVEL >= 1 for better SM occupancy
#if defined(OPT_LEVEL) && OPT_LEVEL >= 1
#define POSEIDON2_TPB 256
#else
#define POSEIDON2_TPB 128
#endif

#define TILE_HEIGHT_LOG2 8
#define TILE_HEIGHT (1 << TILE_HEIGHT_LOG2)
#define TILE_WIDTH  4
// Max block height for 2D kernel launches (TILE_HEIGHT x TILE_WIDTH must not exceed 1024 threads)
#define TILE_BLOCK_HEIGHT ((TILE_HEIGHT * TILE_WIDTH <= 1024) ? TILE_HEIGHT : (1024 / TILE_WIDTH))

__device__ __forceinline__ uint64_t getBufferOffset(
    uint64_t row,
    uint64_t col,
    uint64_t nRows,
    uint64_t nCols
) {
    uint64_t blockY = col / TILE_WIDTH;                  
    uint64_t blockX = row / TILE_HEIGHT;
    uint64_t nCols_block = (nCols - TILE_WIDTH * blockY < TILE_WIDTH) 
                           ? (nCols - TILE_WIDTH * blockY) : TILE_WIDTH;
    uint64_t col_block = col % TILE_WIDTH;
    uint64_t row_block = row % TILE_HEIGHT;

    return blockY * TILE_WIDTH * nRows + blockX * nCols_block * TILE_HEIGHT
           + col_block * TILE_HEIGHT + row_block;
}

__device__ __forceinline__ uint64_t getBufferOffsetRowMajor(
    uint64_t row,
    uint64_t col,
    uint64_t nRows,
    uint64_t nCols
) {
    uint64_t blockY = col / TILE_WIDTH;                  
    uint64_t nCols_block = (nCols - TILE_WIDTH * blockY < TILE_WIDTH) 
                           ? (nCols - TILE_WIDTH * blockY) : TILE_WIDTH;
    uint64_t col_block = col % TILE_WIDTH;

    return blockY * TILE_WIDTH * nRows + row * nCols_block + col_block;
}

//fill the first TILE_HEIGHT/(blowup factor) rows of each block
__device__ __forceinline__ uint64_t getBufferOffsetRowMajor_compact(
    uint64_t row,
    uint64_t col,
    uint64_t nRows,
    uint64_t nCols,
    uint32_t blowup
) {

    uint64_t tile_height_blown = TILE_HEIGHT / blowup;
    uint64_t blockY = col / TILE_WIDTH;                  
    uint64_t blockX = (row / tile_height_blown);
    uint64_t nCols_block = (nCols - TILE_WIDTH * blockY < TILE_WIDTH) 
                           ? (nCols - TILE_WIDTH * blockY) : TILE_WIDTH;
    uint64_t col_block = col % TILE_WIDTH;
    uint64_t row_block = row % tile_height_blown;

    return blockY * TILE_WIDTH * nRows + blockX * nCols_block * TILE_HEIGHT
           + row_block * nCols_block + col_block;
}

#endif