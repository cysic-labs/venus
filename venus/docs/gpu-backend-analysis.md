# GPU Backend Analysis for FPGA Porting

Reference document for the venus-fpga team. Summarizes the computation graph
in pil2-proofman/pil2-stark that must be replicated on FPGA.

## Prove Pipeline Entry Point

```
cargo-zisk prove -w libzisk_witness.so -k provingKey -e ELF -i input -o output -a -y -r
```

The `-a` flag enables GPU acceleration, which invokes `genProof_gpu()` in
`pil2-proofman/pil2-stark/src/starkpil/gen_proof.cuh`.

## Computation Flow (Proof Generation Phases)

```
Phase 0: Setup & Trace Unpacking
  unpack_trace() / unpack_fixed()

Phase 1: Stage Commits (repeated for each stage)
  For stage s in 1..nStages:
    1. NTT extend (LDE): N -> NExtended polynomials
    2. Poseidon2 linear hash on rows
    3. Merkle tree build (bottom-up Poseidon2)
    4. Commit root to transcript
    5. Get challenges from transcript

Phase 2: Witness Calculation
  calculateImPolsExpressions()
  calculateWitnessSTD_gpu() (gprod_col / gsum_col)

Phase 3: Quotient Polynomial Q
  computeZerofier()
  calculateExpressionQ()
  extendAndMerkelize Q

Phase 4: Evaluation
  computeLEv_inplace() (Lagrange evaluation at xi)
  computeEvals_v2()
  Hash evals to transcript

Phase 5: FRI Protocol
  For each FRI step:
    1. fold() - polynomial folding with challenge
    2. Merkelize folded polynomial
    3. Get next challenge
  Final polynomial (scalar)
  grinding() - proof of work nonce
  proveQueries() - Merkle proofs for sampled positions

Phase 6: Proof Packaging
  Copy proof buffer to host
```

## Key Kernel Inventory

| Kernel | GPU File | Lines | Criticality | HBM Pattern |
|--------|----------|-------|-------------|-------------|
| Goldilocks field ops | gl64_t.cuh | ~200 | Foundation | N/A (inline) |
| NTT forward/inverse | ntt_goldilocks.cu | 1689 | Critical | Stride butterfly |
| Poseidon2 hash | poseidon2_goldilocks.cu | 632 | Critical | Row-parallel |
| Merkle tree build | merkleTreeGL.cpp + GPU | ~400 | Critical | Bottom-up tree |
| Expression eval | expressions_gpu.cu | 762 | High | Scattered poly access |
| FRI fold | starks_gpu.cu | ~200 | High | Halving access |
| Transcript | transcriptGL.cu | ~150 | Medium | Sequential |
| Hints/witness | hints.cu | 555 | Medium | Row-parallel |
| Grinding | poseidon2 (grinding_*) | ~100 | Low | Independent |

## Field: Goldilocks64

- Prime: p = 2^64 - 2^32 + 1
- Identity: 2^64 = 2^32 - 1 (mod p)
- Representation: uint64_t (partially reduced, values in [0, 2p))
- Multiplication: 64x64 -> 128 bit, then fast reduction
- Cubic extension: 3 Goldilocks elements (x, y, z)

## Data Layout

Tiled column-major format for memory coalescing:
- TILE_HEIGHT = 256 (2^8)
- TILE_WIDTH = 4 (or 8 at OPT_LEVEL >= 2)

```
offset = blockY * TILE_WIDTH * nRows
       + blockX * nCols_block * TILE_HEIGHT
       + (col % TILE_WIDTH) * TILE_HEIGHT
       + (row % TILE_HEIGHT)
```

## NTT Details

- Domain sizes: 2^1 to 2^33
- Twiddle factors: 33 precomputed omega values (roots of unity)
- Butterfly: radix-2 Cooley-Tukey
- Multi-column: processes multiple polynomial columns simultaneously
- Key variants: DIF (decimation-in-frequency), compact format for FRI

## Poseidon2 Details

- State width: 12 (SPONGE_WIDTH)
- Rate: 8
- Capacity: 4
- S-box: x^7 (pow7)
- MDS: External/internal matrix multiplication
- Full rounds + partial rounds structure
- Hash output: 4 Goldilocks elements (HASH_SIZE = 4)

## Merkle Tree

- Arity: 2 (binary tree)
- Hash: Poseidon2 over HASH_SIZE=4 elements
- Proof: sibling hashes along path from leaf to root
- nFieldElements = 4 for Goldilocks mode

## FRI Folding

- Steps: typically [27, 24, 21, 18, 15, 12, 9, 6, 3, 0]
- Each step reduces degree by factor of 8 (3-bit fold)
- Fold formula: P'(x) using challenge alpha
- Final output: scalar (degree-0 polynomial)

## Memory Budget

For the largest test case (~2^27 rows):
- Trace: ~16 GB
- Extended trace: ~32 GB (4x blowup)
- Merkle trees: ~8 GB
- FRI polynomials: ~4 GB
- Total peak: ~60 GB on GPU

FPGA targets:
- VU47P: 16 GB HBM -> must stream or partition
- VH1782: 32 GB HBM -> can hold extended trace

## Key Source File Paths

- API: pil2-proofman/pil2-stark/src/api/starks_api.cu
- Proof gen: pil2-proofman/pil2-stark/src/starkpil/gen_proof.cuh
- NTT: pil2-proofman/pil2-stark/src/goldilocks/src/ntt_goldilocks.cu
- Poseidon2: pil2-proofman/pil2-stark/src/goldilocks/src/poseidon2_goldilocks.cu
- Field: pil2-proofman/pil2-stark/src/goldilocks/src/gl64_t.cuh
- Expressions: pil2-proofman/pil2-stark/src/starkpil/expressions_gpu.cu
- Merkle: pil2-proofman/pil2-stark/src/starkpil/merkleTree/merkleTreeGL.cpp
- Transcript: pil2-proofman/pil2-stark/src/starkpil/transcript/transcriptGL.cu
- Starks GPU: pil2-proofman/pil2-stark/src/starkpil/starks_gpu.cu
