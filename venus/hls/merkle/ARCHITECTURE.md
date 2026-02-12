# Merkle Tree HLS Architecture

## Overview

Merkle tree construction is the primary consumer of Poseidon2 hashes in the
STARK prover. Each commitment stage and FRI layer requires building a
Merkle tree from leaf data. This document describes the FPGA HLS
implementation targeting AMD UltraScale+ VU47P and Versal VH1782.

**GPU reference files:**
- `pil2-proofman/pil2-stark/src/starkpil/merkleTree/merkleTreeGL.cpp`
- `pil2-proofman/pil2-stark/src/starkpil/merkleTree/merkleTreeGL.hpp`
- `pil2-proofman/pil2-stark/src/goldilocks/src/poseidon2_goldilocks.cu` (merkletreeCoalesced)
- `pil2-proofman/pil2-stark/src/starkpil/starks_gpu.cu` (genMerkleProof)

## Algorithm

### Tree Layout

The tree is stored as a flat array of Goldilocks field elements.
`nFieldElements = HASH_SIZE = CAPACITY = 4` (four 64-bit words per hash).

```
nodes[0 .. numNodes*4 - 1]

Level 0 (leaves): nodes[0 .. height*4-1]
  - Each leaf = linearHash(source_row) = 4 field elements
Level 1: nodes[leaf_end .. leaf_end + ceil(height/arity)*4 - 1]
  - Each node = Poseidon2(children concatenated)
...
Root: nodes[numNodes - 4 .. numNodes - 1]
```

### Node Count Calculation

```
numNodes = height
nodesLevel = height
while nodesLevel > 1:
    extraZeros = (arity - (nodesLevel % arity)) % arity
    numNodes += extraZeros
    nextN = ceil(nodesLevel / arity)
    numNodes += nextN
    nodesLevel = nextN
totalElements = numNodes * 4   (4 field elements per hash)
```

### Construction (Two Phases)

**Phase 1: Leaf hashing (linearHash)**
For each row i in [0, num_rows):
  - `nodes[i*4 .. i*4+3] = linearHash(source[i*num_cols .. (i+1)*num_cols-1])`
  - This uses sponge-mode Poseidon2 with RATE=8, CAPACITY=4

**Phase 2: Internal tree levels**
```
pending = num_rows
nextIndex = 0
while pending > 1:
    extraZeros = (arity - (pending % arity)) % arity
    if extraZeros > 0:
        zero-fill nodes[nextIndex + pending*4 .. +extraZeros*4]
    nextN = ceil(pending / arity)
    for i in 0..nextN-1:
        input = nodes[nextIndex + i*SPONGE_WIDTH .. +SPONGE_WIDTH-1]
        nodes[nextIndex + (pending+extraZeros+i)*4 .. +3] = hash(input)
    nextIndex += (pending + extraZeros) * 4
    pending = nextN
```

For arity=3 (SPONGE_WIDTH=12):
- Each internal hash takes 12 input elements (3 children * 4 elements each)
- Produces 4 output elements (capacity)
- Uses `p2_hash()` from poseidon2_core.hpp

### Merkle Proof Generation

Given a leaf index `idx`, walk up the tree collecting sibling hashes:

```
genMerkleProof(nodes, proof, idx, offset=0, n=height):
    if n <= 1: return
    currIdx = idx % arity      // position within group
    nextIdx = idx / arity       // parent index
    si = idx - currIdx          // start of sibling group

    for i in 0..arity-1:
        if i == currIdx: continue
        proof[] = nodes[(offset + si + i) * 4 .. +3]  // sibling hash

    nextN = ceil(n / arity)
    genMerkleProof(nodes, proof, nextIdx, offset + nextN*arity, nextN)
```

Proof size = `ceil(log_arity(height)) * (arity-1) * 4` field elements.

## FPGA Architecture

### Design Overview

The Merkle tree kernel has two main phases:

1. **Leaf hash phase**: Stream source rows from HBM, apply linearHash,
   write leaf hashes to tree buffer in HBM. This reuses
   `p2_linear_hash_rows()` from poseidon2_linear_hash.hpp.

2. **Tree build phase**: Iterate over tree levels, reading child hashes
   from HBM, computing parent hashes, writing back. Each level has
   progressively fewer nodes (divides by arity each level).

### Parallelism Strategy

**Leaf hashing**: Deploy N_HASH_UNITS=4 parallel Poseidon2 hash units.
Each unit processes independent rows. With ~328 cycles/hash and multiple
sponge iterations per row, leaf hashing is the dominant cost.

**Internal levels**: Same N_HASH_UNITS process independent parent nodes.
Since each level has fewer nodes, parallelism decreases naturally.
For arity=3, a tree with 2^20 leaves has ~20 levels.

### Memory Layout

The tree buffer is allocated in HBM. For N leaves with W-column source:
- Source: N * W * 8 bytes
- Tree nodes: numNodes * 4 * 8 bytes
- For N=2^20, arity=3: ~4.2M nodes * 32B = ~134 MB

### Resource Estimates (4 hash units)

| Resource  | Count | Notes                               |
|-----------|-------|-------------------------------------|
| DSP48E2   | ~576  | 4 hash units * ~144 DSPs each       |
| BRAM18K   | ~16   | 4 * (C[118] + D[12]) + row buffers  |
| LUT       | ~15K  | 4 * ~3K (matmul + control)          |
| FF        | ~20K  | 4 * ~4K (pipeline + state regs)     |
| HBM BW    | ~6 GB/s | Dominated by source row reads     |

### Performance Estimates

For N=2^20 leaves, 100 columns per row, arity=3:
- Leaf hashing: 2^20 rows * ceil(100/8) = ~13.6M Poseidon2 calls
  With 4 units @ 914K hash/s each: ~3.7 seconds
- Internal levels: ~525K Poseidon2 calls total (geometric sum)
  With 4 units: ~0.14 seconds
- **Total: ~3.9 seconds per tree**

GPU comparison: ~0.3 seconds (with thousands of CUDA cores).
FPGA advantage: lower power, deterministic latency, concurrent with NTT.

## HLS Kernel Interfaces

### merkle_tree_kernel (full tree construction)

```cpp
void merkle_tree_kernel(
    const ap_uint<64>* source,    // AXI-MM: leaf source data
    ap_uint<64>* tree,            // AXI-MM: tree node buffer
    unsigned int num_cols,        // columns per leaf row
    unsigned int num_rows,        // number of leaf rows
    unsigned int arity            // 2, 3, or 4
);
```

### merkle_proof_kernel (proof extraction)

```cpp
void merkle_proof_kernel(
    const ap_uint<64>* nodes,     // AXI-MM: tree nodes
    ap_uint<64>* proof,           // AXI-MM: proof output
    unsigned int idx,             // leaf index to prove
    unsigned int num_leaves,      // total leaves
    unsigned int arity            // 2, 3, or 4
);
```

## Verification Plan

1. **Small tree (8 leaves, arity=3)**: Build tree, verify root matches CPU
2. **Merkle proof**: Generate proof for each leaf, verify path to root
3. **Edge cases**: num_rows=1, num_rows not divisible by arity
4. **Large tree**: 1024 leaves, compare all internal nodes against CPU
5. **Multi-column linearHash**: Verify leaf hashes match CPU linearHash

## File Structure

```
venus/hls/merkle/
    ARCHITECTURE.md              -- this file
    merkle_config.hpp            -- parameters (arity, hash sizes)
    merkle_tree.hpp              -- tree construction (leaf hash + levels)
    merkle_proof.hpp             -- proof generation
    test/
        tb_merkle.cpp            -- C-simulation testbench
        merkle_test_kernel.cpp   -- AXI-wrapped test kernel
        Makefile                 -- csim/csynth/cosim targets
        hls_config.cfg           -- Vitis HLS configuration
```
