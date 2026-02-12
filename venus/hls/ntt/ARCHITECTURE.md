# NTT (Number Theoretic Transform) HLS Architecture

## Overview

This document describes the FPGA architecture for the Goldilocks-field NTT,
the most performance-critical kernel in the STARK prover.  The design targets
AMD UltraScale+ VU47P (16 GB HBM2, 2520 DSP48E2, 1680 URAM, 4032 BRAM) and
Versal VH1782 (32 GB HBM2, AIE-ML array).

**GPU reference files:**
- `pil2-proofman/pil2-stark/src/goldilocks/src/ntt_goldilocks.cu`
- `pil2-proofman/pil2-stark/src/goldilocks/src/ntt_goldilocks.hpp`
- `pil2-proofman/pil2-stark/src/goldilocks/src/ntt_goldilocks.cpp`
- `pil2-proofman/pil2-stark/src/goldilocks/src/data_layout.cuh`

## Algorithm Background

### Radix-2 Cooley-Tukey NTT

The NTT of size N = 2^n over the Goldilocks field F_p (p = 2^64 - 2^32 + 1)
uses n butterfly stages.  Each butterfly computes:

```
DIT butterfly (stage s, twiddle W):
    t = W * a[j + 2^s]
    a[j]       = a[j] + t
    a[j + 2^s] = a[j] - t

DIF butterfly (stage s, twiddle W):
    t1 = a[j] + a[j + 2^s]
    t2 = (a[j] - a[j + 2^s]) * W
    a[j]       = t1
    a[j + 2^s] = t2
```

Each butterfly requires: 1 gl64_mul (~12 DSPs, II=1) + 1 gl64_add + 1 gl64_sub.

### Bit-Reversal Permutation

DIT NTT requires bit-reversal before butterfly stages; DIF requires it after.
For the LDE flow (INTT + extend + NTT), the reference uses "noBR" variants
that skip the intermediate bit-reversal, saving one HBM pass.

### Twiddle Factors

The k-th twiddle for stage s of a size-2^n NTT is:
    W[k] = omega^(k * 2^(n - s - 1))   (forward)
    W[k] = omega_inv^(k * 2^(n - s - 1)) (inverse)

where omega = root_of_unity(n).  The GPU stores a flat table of 2^(n-1)
elements and indexes with stride: `twiddles[k * (2^n >> (s+1))]`.

### LDE (Low Degree Extension) Flow

From `LDE_MerkleTree_GPU`:
1. `transposeBack` - rearrange from row-major to block-parallel layout
2. `INTT` (DIF, inverse=true, extend=true) - applies r[] shift factors
3. Zero-extend from N to N_ext = N * blowup_factor
4. `NTT` (DIT, forward) on extended domain
5. `transposeIn` - rearrange back to row-major
6. Merkle tree construction

### Multi-Column Support

The prover processes `nCols` polynomial columns simultaneously.
The GPU tiles columns into groups of BATCH_WIDTH=4 and processes each
group with a separate thread block.  On FPGA we process C_PAR columns
in parallel across HBM channels.

## FPGA Architecture

### Design Philosophy

- **Streaming multi-pass**: NTT domains (up to 2^27 = 1 GB per column) far
  exceed on-chip memory.  We partition into multiple HBM passes, each
  performing K butterfly stages on blocks of 2^K elements.
- **On-chip butterfly block**: Each pass loads a block of 2^K elements into
  BRAM, performs K radix-2 butterfly stages, and writes results back.
- **HBM ping-pong**: Use separate HBM read/write channels with double-
  buffering to overlap memory access with computation.
- **Column parallelism**: Independent HBM channels serve independent columns.

### Key Parameters

| Parameter  | Symbol | Default | Description                              |
|------------|--------|---------|------------------------------------------|
| Batch log  | K      | 10      | On-chip batch = 2^K elements (8 KB)      |
| Batch size | B      | 1024    | B = 2^K elements per butterfly block      |
| Parallelism| P      | 2       | Parallel butterfly pipelines per channel  |
| Col. par.  | C_PAR  | 4       | Columns processed in parallel             |
| Max log N  | 27     | 27      | Maximum NTT size = 2^27                   |
| Clock      | -      | 300 MHz | Target clock frequency                    |

### Architecture Block Diagram

```
 HBM Channel 0     HBM Channel 1     HBM Channel 2     HBM Channel 3
    |                   |                   |                   |
    v                   v                   v                   v
+----------+       +----------+       +----------+       +----------+
| NTT PE 0 |       | NTT PE 1 |       | NTT PE 2 |       | NTT PE 3 |
| (col 0)  |       | (col 1)  |       | (col 2)  |       | (col 3)  |
+----------+       +----------+       +----------+       +----------+
    |                   |                   |                   |
    v                   v                   v                   v
 HBM Channel 4     HBM Channel 5     HBM Channel 6     HBM Channel 7
 (write-back)      (write-back)      (write-back)      (write-back)
```

Each **NTT PE** (Processing Element) is a self-contained NTT engine that
processes one column at a time.  For nCols > C_PAR, the host loops over
column groups.

### NTT Processing Element (ntt_pe) - Internal Architecture

```
                    +-----------+
   HBM read ------->| Read Addr |
   (AXI-MM)         | Generator |
                    +-----+-----+
                          |
                          v
                    +-----+-----+
                    | Input BRAM |  <-- 2^K x 64-bit, dual-port
                    | (ping)     |
                    +-----+-----+
                          |
               +----------+----------+
               |                     |
               v                     v
          +----+----+          +-----+-----+
          |Butterfly|          |  Twiddle   |
          | Unit    |<---------|  ROM/Gen   |
          | (II=1)  |          | (BRAM)     |
          +----+----+          +-----------+
               |
               v
          +----+-----+
          |Output BRAM|  <-- 2^K x 64-bit, dual-port
          | (pong)    |
          +-----+-----+
                |
                v
          +-----+-----+
          | Write Addr |
          | Generator  |-------> HBM write
          +-----------+         (AXI-MM)
```

#### Butterfly Unit Detail

The butterfly unit processes one butterfly per cycle (II=1):

```
cycle 0: read a_even, a_odd from BRAM
cycle 1: t = twiddle * a_odd       (gl64_mul, latency L_mul)
cycle 2+L_mul: a_even + t, a_even - t  (gl64_add, gl64_sub)
cycle 3+L_mul: write results to output BRAM
```

With L_mul ~ 6 cycles (pipelined), the butterfly has ~8 cycle latency
but II=1 throughput when fully pipelined.

For each on-chip batch of B = 2^K elements:
- K butterfly stages, each with B/2 butterflies
- Total: K * B/2 cycles per batch
- For K=10: 10 * 512 = 5120 cycles = 17.1 us @ 300 MHz

#### Twiddle Factor Management

**Option A: Pre-computed ROM (recommended for K <= 14)**
- Store 2^(K-1) forward + 2^(K-1) inverse twiddle factors in BRAM
- Total: 2^K * 8 bytes (for K=10: 8 KB, fits easily)
- ROM is indexed per butterfly stage and position

**Option B: On-the-fly generation (for K > 14)**
- Maintain running twiddle accumulator: W_next = W_curr * W_step
- One gl64_mul per twiddle (can share DSPs with butterfly when not conflicting)
- Requires careful pipeline scheduling

**Recommendation**: Use Option A (ROM) with K=10.  The twiddle table for the
maximum domain size (2^27) only needs 2^26 entries per direction, but we only
need twiddles for the local K stages within each batch.  The per-batch twiddle
subset is computed by the host and loaded via AXI-Lite or small side-channel,
or indexed from a master table.

**Global twiddle indexing** (matching GPU):
For the j-th butterfly in global stage s:
    twiddle_idx = (j % 2^s) * (2^(n-1) >> s)
This maps into the master twiddle table.  For on-chip batch stages, we
pre-compute the needed twiddle subset (at most 2^(K-1) entries per stage).

### Multi-Pass Orchestration

For NTT of size N = 2^n with batch size B = 2^K:
- Number of passes: P = ceil(n / K)
- Pass p processes butterfly stages [p*K .. min((p+1)*K-1, n-1)]

**DIT (forward NTT) pass schedule:**
```
Pass 0: bit-reversal permutation (separate kernel or integrated)
Pass 1: stages 0..K-1 on batches of B elements
Pass 2: stages K..2K-1 on batches of B elements (different stride)
...
Pass P: stages (P-1)*K..n-1
```

**DIF (inverse NTT) pass schedule (stages in reverse order):**
```
Pass 0: stages n-1..n-K
Pass 1: stages n-K-1..n-2K
...
Pass P-1: stages K-1..0
Pass P: bit-reversal permutation
```

**Between passes**: the data must be re-arranged in HBM so that the next
pass's butterfly pairs are co-located within batches.  This is equivalent
to the GPU's implicit transpose between kernel launches.

### Address Generation

The core challenge is mapping global NTT butterfly indices to HBM addresses
and on-chip BRAM addresses.

**For pass p, global stage s = p*K + local_stage:**

The data layout after pass p has elements grouped into batches of B.
Within each batch, elements are in butterfly-natural order for stages
[p*K .. (p+1)*K-1].  Between batches, elements are strided according
to the bit-reversal of the remaining index bits.

**GPU mapping (for reference):**
```c
// From br_ntt_batch_steps_blocks_par:
groupSize = 1 << base_step;
nGroups = domain_size / groupSize;
row = (high_bits % nGroups) * groupSize + (row / nGroups);
```

The FPGA address generator replicates this logic in hardware, producing
sequential HBM read addresses and BRAM write indices.

### Bit-Reversal Kernel

A separate AXI-MM kernel that swaps element pairs:
```
for each i in [0, N):
    j = bit_reverse(i, n)
    if j > i: swap(data[i], data[j])
```

On FPGA, this is memory-bandwidth-limited.  We stream through HBM and
perform in-place swaps using a ping-pong buffer for conflict avoidance.

**Performance**: N reads + N writes = 2N * 8 bytes.
For N=2^27: 2 GB at 14.4 GB/s per channel = 139 ms (single channel).
With 4 channels: 35 ms.

### Data Transpose Kernel

Matches the GPU's `transposeSubBlocksInPlace` / `transposeSubBlocksBackInPlace`.
Converts between row-major multi-column layout and block-parallel layout:

- **Block-parallel (NTT-friendly)**: columns grouped into blocks of TILE_WIDTH,
  elements stored column-major within each block
- **Row-major (compute-friendly)**: all columns for one row are contiguous

This is a memory-bound reshape operation.  On FPGA, implement as a streaming
copy with address remapping between two HBM channel groups.

### INTT with Scale/Extend

When `inverse=true`, the final butterfly pass multiplies by `1/N (mod p)`.
When `extend=true`, it additionally multiplies by the shift factor `r[i]`
(powers of the multiplicative generator, used for LDE coset shift).

These are cheap extra gl64_muls fused into the butterfly write-back path.

## Resource Estimates (VU47P, per NTT PE)

| Resource    | Count   | Notes                                    |
|-------------|---------|------------------------------------------|
| DSP48E2     | ~24     | 12 per butterfly, x2 for ping-pong       |
| BRAM18K     | ~16     | 2x 2^10 x 64-bit data + twiddle ROM      |
| URAM        | 0       | Not needed for K=10                       |
| LUT         | ~4000   | Address gen, control, reduction logic     |
| FF          | ~6000   | Pipeline registers                        |

**Total for 4 PEs**: ~96 DSPs, ~64 BRAM18K, ~16K LUT, ~24K FF
(< 4% of VU47P resources, leaving ample room for other kernels)

## Performance Estimates

### Single-Column NTT (N = 2^27)

| Metric                  | Value                                    |
|-------------------------|------------------------------------------|
| Passes (K=10)           | 3                                        |
| Batches per pass        | 2^17 = 131072                            |
| Cycles per batch        | 5120 (compute) + ~200 (HBM I/O overlap)  |
| Cycles per pass         | ~131072 * 5120 = 671M                    |
| Time per pass @ 300 MHz | 2.24 s                                   |
| Total NTT time          | ~6.7 s (compute-bound)                   |
| HBM bandwidth per pass  | 2 * 2^27 * 8 = 2 GB                      |

### Optimization: Increase K to 12

| Metric                  | K=10       | K=12        | K=14        |
|-------------------------|------------|-------------|-------------|
| Passes                  | 3          | 3           | 2           |
| Batch size              | 1024       | 4096        | 16384       |
| Cycles/batch            | 5120       | 24576       | 114688      |
| Batches/pass            | 131072     | 32768       | 8192        |
| Cycles/pass             | 671M       | 806M        | 939M        |
| Time/pass               | 2.24s      | 2.69s       | 3.13s       |
| Total time              | 6.7s       | 8.1s        | 6.3s        |
| BRAM for data           | 4 BRAM18K  | 16 BRAM18K  | 64 BRAM18K  |

**Observation**: Compute time is nearly the same regardless of K because
total butterflies is fixed at n*N/2.  The benefit of larger K is fewer
HBM passes (less HBM traffic, less address overhead).

### Optimization: P Parallel Butterfly Pipelines

With P parallel butterflies processing P batches simultaneously:

| P | Total time (K=10) | DSPs per PE | Notes                       |
|---|-------------------|-------------|-----------------------------|
| 1 | 6.7 s             | 12          | Baseline                    |
| 2 | 3.4 s             | 24          | 2x throughput               |
| 4 | 1.7 s             | 48          | May hit HBM bandwidth limit |
| 8 | 0.84 s            | 96          | Approaching HBM limit       |

**HBM bandwidth check** (P=4, K=10):
- Data rate: 4 batches * 1024 elements * 8 bytes / 5120 cycles * 300 MHz
- = 4 * 8192 / 5120 * 300M = 1.92 GB/s per channel
- Well within 14.4 GB/s per HBM channel

### Multi-Column Performance

For nCols columns with C_PAR=4 parallel PEs:
- Column groups: ceil(nCols / C_PAR)
- Total time: ceil(nCols / 4) * single_column_time
- For nCols=100, P=4: ceil(100/4) * 1.7s = 42.5 s

## HLS Kernel Interfaces

### ntt_butterfly_kernel (main NTT compute kernel)

```cpp
void ntt_butterfly_kernel(
    const ap_uint<64>* data_in,   // AXI-MM, HBM read channel
    ap_uint<64>* data_out,        // AXI-MM, HBM write channel
    const ap_uint<64>* twiddles,  // AXI-MM or AXI-Lite, twiddle factors
    unsigned int log_n,           // log2(domain_size)
    unsigned int base_step,       // first butterfly stage in this pass
    unsigned int n_steps,         // number of stages in this pass (<=K)
    unsigned int n_batches,       // number of batches = domain_size / 2^K
    bool inverse,                 // true for INTT
    bool extend,                  // true for LDE (multiply by r[])
    uint64_t inv_factor           // 1/N mod p (for INTT final pass)
);
```

### ntt_bitrev_kernel (bit-reversal permutation)

```cpp
void ntt_bitrev_kernel(
    ap_uint<64>* data,            // AXI-MM, in-place
    unsigned int log_n,           // log2(domain_size)
    unsigned int n_elements       // domain_size
);
```

### ntt_transpose_kernel (layout conversion)

```cpp
void ntt_transpose_kernel(
    const ap_uint<64>* src,       // AXI-MM, source layout
    ap_uint<64>* dst,             // AXI-MM, destination layout
    unsigned int n_rows,          // domain_size
    unsigned int n_cols,          // number of columns
    unsigned int tile_height,     // TILE_HEIGHT (256)
    unsigned int tile_width,      // TILE_WIDTH (4)
    bool forward                  // true: row-major->block, false: block->row-major
);
```

### ntt_twiddle_init_kernel (twiddle factor precomputation)

```cpp
void ntt_twiddle_init_kernel(
    ap_uint<64>* fwd_twiddles,    // AXI-MM, forward twiddle table
    ap_uint<64>* inv_twiddles,    // AXI-MM, inverse twiddle table
    unsigned int log_domain_size  // max domain size log2
);
```

### ntt_r_init_kernel (shift factor precomputation for LDE)

```cpp
void ntt_r_init_kernel(
    ap_uint<64>* r,               // AXI-MM, shift factor table
    unsigned int log_domain_size  // domain size log2
);
```

## HLS Implementation Notes

### Butterfly Pipeline (critical path)

```cpp
// Inner butterfly loop - must achieve II=1
for (unsigned int i = 0; i < batch_size / 2; i++) {
    #pragma HLS PIPELINE II=1
    gl64_t a_even = bram_ping[addr_even(i, stage)];
    gl64_t a_odd  = bram_ping[addr_odd(i, stage)];
    gl64_t w      = twiddle_rom[twiddle_idx(i, stage)];

    gl64_t t = a_odd * w;           // 1 gl64_mul
    bram_pong[addr_even(i, stage)] = a_even + t;   // 1 gl64_add
    bram_pong[addr_odd(i, stage)]  = a_even - t;   // 1 gl64_sub
}
```

**BRAM partitioning**: Use `#pragma HLS ARRAY_PARTITION` or
`#pragma HLS BIND_STORAGE` to ensure dual-port access without conflicts.
For the butterfly, we need two reads and two writes per cycle from the
same BRAM.  Partition into even/odd banks:

```cpp
gl64_t bram_even[BATCH_SIZE/2];
gl64_t bram_odd[BATCH_SIZE/2];
#pragma HLS BIND_STORAGE variable=bram_even type=ram_2p impl=bram
#pragma HLS BIND_STORAGE variable=bram_odd type=ram_2p impl=bram
```

For stage s: the butterfly pair (i, i + 2^s) maps to:
- If bit s of i is 0: even bank, index i >> (s+1) concatenated with i[s-1:0]
- The partner is in the odd bank at the same index

This gives conflict-free access for all stages.

### BRAM Ping-Pong for Stage Chaining

Between butterfly stages within a batch, swap ping/pong BRAMs:

```cpp
for (int stage = 0; stage < n_steps; stage++) {
    #pragma HLS DATAFLOW
    butterfly_stage(bram_ping, bram_pong, twiddles, stage, ...);
    // swap: next stage reads from pong, writes to ping
    std::swap(bram_ping_ptr, bram_pong_ptr);
}
```

Actually, for K stages with II=1, the total pipeline depth is K * B/2 cycles.
We can unroll the stage loop and let HLS schedule the BRAM accesses.

### HBM Access Pattern

For pass p with base_step = p*K, the global element index mapping is:

```cpp
// Matching GPU's br_ntt_batch_steps_blocks_par addressing:
uint32_t groupSize = 1 << base_step;
uint32_t nGroups = domain_size / groupSize;
uint32_t batch_local_idx = threadIdx_x;  // 0..B-1
uint32_t batch_id = blockIdx_x;           // 0..n_batches-1

// Global row index:
uint32_t low_bits = batch_local_idx / nGroups;  // NOT simple: need to match GPU
uint32_t high_bits = batch_local_idx % nGroups;
uint32_t global_row = high_bits * groupSize + low_bits;
```

On FPGA, this address computation runs in the Read/Write Address Generator
and is pipelined at II=1.

### Inverse NTT Scaling

When the final pass completes (all n stages done) and inverse=true:
```cpp
// Fuse into butterfly write-back
gl64_t result = butterfly_output;
if (is_final_pass && inverse) {
    result = result * inv_n;   // inv_n = 1/N mod p
    if (extend) {
        result = result * r[bit_rev_row];  // LDE shift
    }
}
data_out[addr] = result;
```

This adds 1-2 extra gl64_muls on the final pass only, negligible overhead.

## Verification Plan

### C-Simulation Testbench

1. **Small NTT correctness** (N=8, 16, 32):
   - Forward NTT, check against CPU reference NTT_Goldilocks::NTT
   - Inverse NTT, check NTT(INTT(x)) == x
   - Verify twiddle factor generation matches GL64_ROOTS_RAW

2. **Boundary cases**:
   - N=1 (trivial), N=2 (single butterfly)
   - All-zero input, all-one input
   - Input with values near p

3. **Bit-reversal**:
   - Verify permutation is self-inverse
   - Check against CPU BR() function

4. **LDE flow**:
   - INTT with extend=true
   - Forward NTT on extended domain
   - Verify against CPU NTT_Goldilocks::extendPol

5. **Multi-pass consistency**:
   - For K=10, verify NTT with N=2^12 (2 passes) matches single-pass
   - Verify intermediate state between passes

### Co-Simulation

Verify RTL matches C model for representative sizes (N=1024, 4096).

## File Structure

```
venus/hls/ntt/
    ARCHITECTURE.md          -- this file
    ntt_config.hpp           -- compile-time parameters (K, P, C_PAR, etc.)
    ntt_butterfly.hpp        -- butterfly unit with BRAM ping-pong
    ntt_addr_gen.hpp         -- address generation for HBM and BRAM
    ntt_twiddle.hpp          -- twiddle factor ROM and generation
    ntt_bitrev.hpp           -- bit-reversal permutation logic
    ntt_transpose.hpp        -- data layout transpose logic
    test/
        tb_ntt.cpp           -- C-simulation testbench
        ntt_test_kernel.cpp  -- AXI-wrapped test kernel
        Makefile             -- csim/csynth/cosim targets
```
