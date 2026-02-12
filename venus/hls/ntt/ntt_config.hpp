// NTT Compile-Time Configuration for AMD FPGA (Vitis HLS)
//
// Tunable parameters for the streaming multi-pass NTT architecture.
// Adjust these based on target device and performance requirements.

#ifndef VENUS_NTT_CONFIG_HPP
#define VENUS_NTT_CONFIG_HPP

#include <ap_int.h>
#include <cstdint>

// Maximum supported NTT domain size: 2^MAX_LOG_N
static const unsigned int MAX_LOG_N = 27;

// On-chip batch size: 2^BATCH_LOG elements per butterfly block.
// Larger K = fewer HBM passes but more BRAM.
// K=10: 1024 elements = 8 KB data BRAM, 3 passes for N=2^27
// K=12: 4096 elements = 32 KB data BRAM, 3 passes for N=2^27
// K=14: 16384 elements = 128 KB data BRAM, 2 passes for N=2^27
static const unsigned int BATCH_LOG = 10;
static const unsigned int BATCH_SIZE = 1 << BATCH_LOG; // 1024
static const unsigned int BATCH_HALF = BATCH_SIZE >> 1; // 512

// Column parallelism: number of columns processed in parallel.
// Each parallel column uses one HBM read + one HBM write channel.
// Must be <= available HBM pseudo-channels / 2.
// VU47P: 32 HBM pseudo-channels -> C_PAR <= 16
static const unsigned int C_PAR = 4;

// GPU-compatible tiling parameters (for transpose kernels)
static const unsigned int TILE_HEIGHT_LOG2 = 8;
static const unsigned int TILE_HEIGHT = 1 << TILE_HEIGHT_LOG2; // 256
static const unsigned int TILE_WIDTH = 4;

// Goldilocks prime
static const uint64_t GL_P = 0xFFFFFFFF00000001ULL;

#endif // VENUS_NTT_CONFIG_HPP
