#ifndef __DATA_LAYOUT_CUH__
#define __DATA_LAYOUT_CUH__

#include <stdint.h>

#define TILE_HEIGHT_LOG2 8
#define TILE_HEIGHT (1 << TILE_HEIGHT_LOG2)
#define TILE_WIDTH  4

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

// Specialized getBufferOffset when row = chunkBase + threadIdx.x and chunkBase is
// a multiple of TILE_HEIGHT. Saves the row / TILE_HEIGHT division and row % TILE_HEIGHT
// modulo since row_block == threadIdx.x and blockX == chunkBase >> TILE_HEIGHT_LOG2.
__device__ __forceinline__ uint64_t getBufferOffset_pack256(
    uint64_t chunkBase,
    uint64_t col,
    uint64_t nRows,
    uint64_t nCols
) {
    uint64_t blockY = col >> 2;
    uint64_t blockX = chunkBase >> TILE_HEIGHT_LOG2;
    uint64_t rem = nCols - (blockY << 2);
    uint64_t nCols_block = rem < TILE_WIDTH ? rem : TILE_WIDTH;
    uint64_t col_block = col & 3;

    return (blockY << 2) * nRows + blockX * nCols_block * TILE_HEIGHT
           + (col_block << TILE_HEIGHT_LOG2) + threadIdx.x;
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