# Poseidon2 Hash HLS Architecture

## Overview

Poseidon2 is the algebraic hash function used throughout the STARK prover for
Merkle tree construction, transcript hashing, and proof-of-work grinding.
This document describes the FPGA HLS implementation for AMD UltraScale+ VU47P
and Versal VH1782.

**GPU reference files:**
- `pil2-proofman/pil2-stark/src/goldilocks/src/poseidon2_goldilocks.cuh` (GPU)
- `pil2-proofman/pil2-stark/src/goldilocks/src/poseidon2_goldilocks.hpp` (CPU)
- `pil2-proofman/pil2-stark/src/goldilocks/src/poseidon2_goldilocks.cpp` (CPU impl)
- `pil2-proofman/pil2-stark/src/goldilocks/src/poseidon2_goldilocks_constants.hpp`

## Algorithm

### Parameters

The prover instantiates Poseidon2 with multiple sponge widths:

| Width | RATE | CAPACITY | Full Rounds | Partial Rounds | Use Case           |
|-------|------|----------|-------------|----------------|--------------------|
| 4     | 0    | 4        | 8           | 21             | Grinding only      |
| 8     | 4    | 4        | 8           | 22             | Merkle (arity=2)   |
| 12    | 8    | 4        | 8           | 22             | Merkle (arity=3)   |
| 16    | 12   | 4        | 8           | 22             | Merkle (arity=4)   |

The primary configuration for the STARK prover is **SPONGE_WIDTH=12** (arity=3).

### Permutation Structure

For a state of W=SPONGE_WIDTH elements:

```
state = input[0..W-1]

1. matmul_external(state)              // Initial linear layer

2. for r = 0..3:                       // First half full rounds (4)
     state[i] = (state[i] + C[r*W+i])^7   for all i    // S-box + round const
     matmul_external(state)            // MDS matrix

3. for r = 0..21:                      // Partial rounds (22)
     state[0] += C[offset + r]         // Round constant (element 0 only)
     state[0] = state[0]^7             // S-box (element 0 only)
     sum = state[0] + state[1] + ... + state[W-1]
     state[i] = state[i] * D[i] + sum  // Internal diffusion

4. for r = 0..3:                       // Second half full rounds (4)
     state[i] = (state[i] + C[offset+r*W+i])^7  // S-box + round const
     matmul_external(state)            // MDS matrix

output = state[0..3]                   // Capacity portion = hash digest
```

### S-Box: x^7

Computed as: x^2, x^3 = x * x^2, x^4 = x^2 * x^2, x^7 = x^3 * x^4.
Cost: 4 gl64_mul per element. All elements are independent in full rounds.

### External MDS Matrix (matmul_external)

For W=12 (3 groups of 4):

```
1. Apply matmul_m4 to x[0:3], x[4:7], x[8:11] independently
2. stored[j] = x[j] + x[j+4] + x[j+8]  for j=0..3
3. x[i] += stored[i % 4]  for all i
```

**matmul_m4** uses ONLY additions (no multiplications!):
```
t0=x[0]+x[1]; t1=x[2]+x[3]; t2=2*x[1]+t1; t3=2*x[3]+t0
t4=4*t1+t3; t5=4*t0+t2; t6=t3+t5; t7=t2+t4
x = [t6, t5, t7, t4]
```

### Internal Diffusion Matrix (partial rounds)

```
sum = state[0] + state[1] + ... + state[W-1]
state[i] = state[i] * D[i] + sum
```

Cost: W gl64_mul (for D[i] multiply) + W gl64_add.

### Round Constants

- C array: Full-round constants (W per round) + partial-round constants (1 per round)
  - For W=12: 4*12 + 22 + 4*12 = 118 constants
- D array: Internal diffusion diagonal, W constants

Total BRAM for constants: 118 + 12 = 130 * 8 bytes = 1040 bytes (trivial).

## FPGA Architecture

### Design Philosophy

- **Iterative round processor**: One permutation at a time, looping through
  rounds.  This minimizes resource usage (DSPs) at the cost of throughput.
- **Fully pipelined alternative**: Unroll all 30 rounds into a deep pipeline
  for maximum throughput (one hash per cycle after initial fill).
  Requires ~30x more DSPs but is needed for Merkle tree leaves.
- **Streaming interface**: Process rows of data from HBM, hash each row
  independently. Natural fit for linearHash and Merkle leaf computation.

### Iterative Design (recommended for initial implementation)

One hash computation takes ~30 round iterations.  Each round iteration has
different cost:

| Round type | Muls per round | Adds per round | Rounds |
|-----------|---------------|----------------|--------|
| Full      | 48 (12*4)     | ~120           | 8      |
| Partial   | 16 (4+12)     | ~24            | 22     |
| **Total** | **736**       | **~1488**      | **30** |

With a single iterative hash unit at 300 MHz:
- Full round: 48 muls at II=1 = 48 cycles (using 12 DSP blocks, 4 muls each)
  Actually, with 12 parallel mul units (one per state element), each round
  takes 4 cycles (x^2, x*x^2, x^2*x^2, x^3*x^4).
- Partial round: 4 cycles for S-box + 1 cycle for sum + 12 cycles for prodadd
  = ~17 cycles (with 1 mul unit for S-box + 12 parallel for prodadd)
- Total per hash: 8*4 + 8*~20 + 22*17 = 32 + 160 + 374 = ~566 cycles
- Time per hash: 566 / 300M = 1.89 us
- Throughput: ~529K hashes/sec

**Actually, let me compute more carefully:**

With 12 parallel gl64_mul units (one per state element):

Full round (per round):
- pow7add: 4 cycles (x^2 || x+C, x^3=x*x^2, x^4=x^2*x^2, x^7=x^3*x^4)
  All 12 elements in parallel = 4 cycles
- matmul_external: ~12 gl64_add operations, ~6 cycles (pipelined adds)
- Total: ~10 cycles per full round
- 8 full rounds = 80 cycles

Partial round (per round):
- Round constant add + pow7 on state[0]: 4 cycles (1 mul unit)
- Sum computation: ~6 cycles (tree reduction of 12 adds)
- prodadd: state[i] = state[i]*D[i] + sum: 1 cycle (12 parallel muls)
- Total: ~11 cycles per partial round
- 22 partial rounds = 242 cycles

Initial matmul_external: ~6 cycles

**Total: ~328 cycles per hash = 1.09 us @ 300 MHz**
**Throughput: ~914K hashes/sec with 12 DSP blocks (~144 DSPs)**

### Pipelined Design (for high-throughput Merkle leaf hashing)

Unroll all 30 rounds into a pipeline. Each round is a separate stage.
With II=1, one hash output per cycle after pipeline fill.

Resource cost:
- Full round stage: 48 gl64_mul (12 S-boxes * 4 muls) = ~576 DSPs per stage
- Partial round stage: 16 gl64_mul = ~192 DSPs per stage
- Total: 8 * 576 + 22 * 192 = 4608 + 4224 = 8832 DSPs

This exceeds VU47P's 2520 DSPs.  **Fully pipelined is NOT feasible.**

### Hybrid Design: Unrolled within rounds, iterated between rounds

Use 12 parallel gl64_mul units that process one round per iteration:
- For full rounds: 4 pipeline stages per S-box (x^2, x^3, x^4, x^7)
- For partial rounds: sequential S-box then parallel prodadd
- Round constants and D stored in BRAM ROM

This gives the best tradeoff: ~144 DSPs, ~328 cycles per hash.

### Multiple Hash Units for Merkle Tree

For Merkle tree construction (millions of leaf hashes), we need high throughput.
Deploy N_HASH parallel hash units, each independently processing different rows:

| N_HASH | DSPs | Throughput (hashes/s) | Notes              |
|--------|------|-----------------------|--------------------|
| 1      | 144  | 914K                  | Baseline           |
| 2      | 288  | 1.83M                 | Good balance       |
| 4      | 576  | 3.66M                 | ~23% of VU47P DSPs |
| 8      | 1152 | 7.31M                 | ~46% of VU47P DSPs |

**Recommendation: 4 parallel hash units** (576 DSPs, ~23% of device).

### Resource Estimates (per hash unit, VU47P)

| Resource  | Count | Notes                                    |
|-----------|-------|------------------------------------------|
| DSP48E2   | ~144  | 12 gl64_mul units, each ~12 DSPs         |
| BRAM18K   | ~2    | Round constants C (118*8=944B) + D (96B) |
| LUT       | ~3000 | matmul_m4 (additions), control logic     |
| FF        | ~4000 | Pipeline registers, state registers      |

## HLS Kernel Interfaces

### poseidon2_hash_kernel (single permutation, for testing)

```cpp
void poseidon2_hash_kernel(
    const ap_uint<64> input[12],   // AXI-Lite or AXI-MM
    ap_uint<64> output[12],        // AXI-Lite or AXI-MM
    unsigned int sponge_width      // 4, 8, 12, or 16
);
```

### poseidon2_linear_hash_kernel (sponge-mode hashing of variable-length input)

```cpp
void poseidon2_linear_hash_kernel(
    const ap_uint<64>* input,      // AXI-MM, row data
    ap_uint<64>* output,           // AXI-MM, 4-element digest per row
    unsigned int num_cols,         // columns per row
    unsigned int num_rows          // number of rows to hash
);
```

### poseidon2_merkle_kernel (Merkle tree construction)

```cpp
void poseidon2_merkle_kernel(
    ap_uint<64>* tree,             // AXI-MM, tree buffer
    const ap_uint<64>* input,      // AXI-MM, leaf data
    unsigned int num_cols,         // columns per leaf row
    unsigned int num_rows,         // number of leaf rows
    unsigned int arity             // 2, 3, or 4
);
```

## Verification Plan

1. **Single permutation**: Hash known input, compare against CPU reference
   `Poseidon2Goldilocks<12>::hash_full_result_seq`
2. **Linear hash**: Hash multi-column rows, compare capacity output
3. **Merkle tree**: Build small tree, verify root matches CPU
4. **Grinding**: Verify PoW nonce search produces valid hash
5. **Test vectors**: Use test vectors from `tests.cu` (Poseidon2 GPU tests)

## File Structure

```
venus/hls/poseidon2/
    ARCHITECTURE.md                  -- this file
    poseidon2_config.hpp             -- parameters (sponge width, rounds)
    poseidon2_constants.hpp          -- C[], D[] round constant arrays
    poseidon2_core.hpp               -- core permutation (pow7, matmul, rounds)
    poseidon2_linear_hash.hpp        -- sponge-mode linear hash
    test/
        tb_poseidon2.cpp             -- C-simulation testbench
        poseidon2_test_kernel.cpp    -- AXI-wrapped test kernel
        Makefile                     -- csim/csynth/cosim targets
```
