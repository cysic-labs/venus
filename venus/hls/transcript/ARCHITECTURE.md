# Transcript (Fiat-Shamir) HLS Architecture

## Overview

FPGA implementation of the Fiat-Shamir transcript for the STARK prover.
The transcript converts an interactive proof into a non-interactive one by
deriving verifier challenges deterministically from the prover's commitments
using a Poseidon2 sponge construction.

## Reference Implementations

- **CPU**: `pil2-proofman/pil2-stark/src/starkpil/transcript/transcriptGL.hpp/.cpp`
  - TranscriptGL class with `put()`, `getField()`, `getPermutations()`
- **GPU**: `pil2-proofman/pil2-stark/src/starkpil/transcript/transcriptGL.cu/.cuh`
  - TranscriptGL_GPU class, single-thread CUDA kernels
- **Rust**: `pil2-proofman/fields/src/transcript.rs`
  - Generic Transcript<F, C, W> implementation

## Sponge Design (Arity = 3)

For arity=3, SPONGE_WIDTH=12 (Poseidon2-12):

```
SPONGE_WIDTH = 4 * arity = 12
RATE         = 4 * (arity - 1) = 8  (input absorption rate)
CAPACITY     = 4                      (state preserved across hashes)
```

### State Buffers
- `state[12]` - Full sponge state (persists across operations)
- `pending[8]` - Input accumulation buffer (RATE elements)
- `out[12]` - Hash output buffer (for challenge extraction)
- `pending_cursor` - Number of elements in pending buffer
- `out_cursor` - Number of remaining elements in output buffer

### _updateState Operation
1. Zero-pad `pending` from `pending_cursor` to RATE
2. Build hash input: `inputs[0:7] = pending[0:7]` (rate)
                      `inputs[8:11] = state[0:3]` (capacity)
3. Full Poseidon2 hash: `out = Poseidon2_full(inputs)`
4. Copy output to state: `state = out`
5. Set `out_cursor = SPONGE_WIDTH` (12 elements available)
6. Clear `pending`, reset `pending_cursor = 0`

### Key Operations

| Operation | Description |
|-----------|-------------|
| `put(input, n)` | Absorb n elements one by one; triggers `_updateState` when pending fills |
| `getField(output)` | Squeeze 3 field elements for cubic extension challenge |
| `getState(output)` | Flush pending, return capacity portion `state[0:3]` |
| `getPermutations(res, n, nBits)` | Generate n query indices with nBits bits each |

### Challenge Extraction (getField)
Calls `getFields1()` three times to produce a cubic extension element:
- If `out_cursor == 0`, trigger `_updateState` first
- Return `out[(SPONGE_WIDTH - out_cursor) % SPONGE_WIDTH]`
- Decrement `out_cursor`

### Query Generation (getPermutations)
1. Compute `NFields = ceil(n * nBits / 63)`
2. Squeeze `NFields` field elements from transcript
3. Extract `nBits` bits per query from the field elements (bit-serial)
4. Each field element provides 63 usable bits

## Proving Flow Integration

The transcript is used throughout the STARK proving flow:

1. **Initial**: Add verification key root + public inputs
2. **Stage 1**: Commit trace polynomial, add Merkle root to transcript
3. **Stage 2**: Get challenges, compute witness, commit, add root
4. **Stage Q**: Get challenges, compute quotient polynomial, add root
5. **Evaluations**: Get xi challenge, compute evaluations, add to transcript
6. **FRI Folding**: For each FRI step:
   - Get FRI challenge from transcript
   - Fold polynomial
   - Merkelize and add root to transcript
7. **FRI Queries**: Create permutation transcript, generate query indices

## HLS Design

### transcript.hpp

Implements the transcript as a self-contained state machine:
- All state stored in registers/BRAM (state, pending, out, cursors)
- Uses `p2_hash_full_result()` from poseidon2_core.hpp for the sponge
- Sequential operations (each depends on previous state)
- `getPermutations` uses floor(totalBits/63)+1 field squeezes

### Resource Estimates (VU47P target, 300 MHz)

| Resource | Estimate |
|----------|----------|
| DSP48    | ~48 (Poseidon2 core) |
| BRAM     | <1 KB (state buffers) |
| LUT      | ~15K |
| Per-hash | ~328 cycles (Poseidon2 permutation) |
