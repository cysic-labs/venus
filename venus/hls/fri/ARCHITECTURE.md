# FRI Protocol HLS Architecture

## Overview

FPGA implementation of the FRI (Fast Reed-Solomon Interactive Oracle Proof)
protocol for the STARK proving backend. The FRI protocol iteratively folds
polynomials to reduce degree, commits each folded polynomial via Merkle trees,
and answers random queries with authentication paths.

## Reference Implementations

- **GPU**: `pil2-proofman/pil2-stark/src/starkpil/starks_gpu.cu`
  - `fold()` / `fold_v2()` kernels (lines 610-782)
  - `fold_inplace()` host wrapper (lines 785-814)
  - `intt_tinny()` device function (lines 563-607)
  - `transposeFRI()` kernel (lines 816-831)
  - `merkelizeFRI_inplace()` (lines 833-865)
  - `getTreeTracePols()` / `getTreeTracePolsBlocks()` (lines 867-893)
  - `genMerkleProof_()` / `genMerkleProof()` (lines 895-927)
  - `moduleQueries()` (line 980)
  - `proveFRIQueries_inplace()` (lines 987-1003)
- **CPU**: `pil2-proofman/pil2-stark/src/starkpil/fri/fri.hpp`
  - `FRI<T>::fold()`, `merkelize()`, `proveQueries()`, `proveFRIQueries()`
  - `polMulAxi()`, `evalPol()`, `getTransposed()`

## FRI Fold Algorithm

For each FRI step, the polynomial is folded by a factor of `ratio = 2^(prevBits - currentBits)`.
For each element `g` in [0, sizeFoldedPol):

1. **Gather**: Collect `ratio` coefficients from the strided polynomial:
   `ppar[i] = friPol[(i * sizeFoldedPol + g) * 3 + k]` for k in [0,3)

2. **Small INTT** (`intt_tinny`): Transform gathered values from evaluation
   domain to coefficient domain. Uses:
   - Bit-reversal permutation
   - Butterfly stages with twiddle factors (omega_inv for the small domain)
   - N^-1 scaling

3. **Coefficient Scaling** (`polMulAxi`): Multiply coefficients by
   powers of `sinv`:
   - `sinv = invShift * invW^g`
   - `invShift = (1/shift)^(2^(nBitsExt - prevBits))`
   - `invW = 1/w(prevBits)`
   - `ppar[i] *= sinv^i`

4. **Horner Evaluation** (`evalPol`): Evaluate the polynomial at the
   challenge point using Horner's method in the cubic extension field:
   ```
   result = ppar[ratio-1]
   for i = ratio-2 down to 0:
       result = result * challenge + ppar[i]
   ```

## FRI Query Protocol

After folding, the prover must answer random queries:

1. **Index Reduction**: `query_idx %= (1 << currentBits)`
2. **Value Extraction**: Read polynomial values at query index from
   the transposed Merkle tree source
3. **Merkle Proof**: Generate authentication path from the tree nodes

## HLS Design

### fri_fold.hpp

Core folding operation for a single element. Template parameter `MAX_RATIO`
bounds the maximum fold ratio (typically 16 for 4-bit fold steps).

Key design choices:
- Small INTT fully unrolled for ratios up to MAX_RATIO
- Twiddle factors computed on-the-fly or from small BRAM table
- All intermediate values in cubic extension field (3 base field elements)
- `sinv` computed per-element via binary exponentiation

### fri_query.hpp

Query operations:
- `fri_transpose()`: Reshape folded polynomial for Merkle tree input
- `fri_extract_values()`: Read polynomial values at query indices
- Merkle proof generation reuses `merkle_proof.hpp` from merkle module

### Memory Layout

- Folded polynomial: `friPol[sizeFoldedPol * 3]` (cubic extension, row-major)
- Transpose buffer: `aux[width * height * 3]` where width = 2^nextBits,
  height = sizeFoldedPol / width
- Query buffer: per-query output = tree_width + proof_size elements

### Resource Estimates (VU47P target, 300 MHz)

| Resource | Fold (ratio=4) | Fold (ratio=16) |
|----------|---------------|-----------------|
| DSP48    | ~30           | ~60             |
| BRAM     | ~4 KB         | ~16 KB          |
| LUT      | ~8K           | ~20K            |
| Latency  | ~200 cycles   | ~800 cycles     |

The fold kernel processes one element per invocation. Domain-level
parallelism is achieved by instantiating multiple fold units.
