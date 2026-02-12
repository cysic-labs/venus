# Proof Flow Integration Architecture

## Overview

End-to-end proof orchestration that chains the individual HLS kernels into
the STARK proving flow. This module mirrors the GPU's `genProof_gpu()` from
`pil2-proofman/pil2-stark/src/starkpil/gen_proof.cuh`.

## Proving Flow

```
Step 0: Prepare witness data
  |
Step 1: Stage commits (for each AIR stage)
  |  NTT extend -> linearHash -> Merkle tree -> transcript.put(root)
  |
Step 2: Q polynomial
  |  transcript.getField() -> expression eval -> NTT -> Merkle -> transcript.put(root)
  |
Step 3: Evaluations
  |  transcript.getField(xi) -> evaluate polynomials at opening points -> transcript.put(evals)
  |
Step 4: FRI protocol (for each FRI step)
  |  transcript.getField() -> fold -> transpose -> Merkle -> transcript.put(root)
  |
Step 5: Proof of work (grinding)
  |  Poseidon2 hash search for nonce
  |
Step 6: FRI queries
  |  transcript.getPermutations() -> extract Merkle proofs at query positions
  |
Output: Serialized proof buffer
```

## Component Dependencies

```
                goldilocks (base field)
               /     |     \
            ntt   poseidon2  expressions
                     |
              +----- | ------+
              |      |       |
           merkle  transcript  fri
              |      |       |
              +------+-------+
                     |
                proof_flow (orchestration)
```

## HLS Implementation Strategy

### Phase 1: Component Validation (Current)
Individual HLS kernels validated via C-simulation testbenches.
Each kernel has bit-exact reference implementations for verification.

### Phase 2: Integration Validation
- `proof_flow.hpp`: Chains transcript + FRI + Merkle in a single kernel
- Integration testbench verifies end-to-end consistency

### Phase 3: Hardware Build
- Package each kernel as XO (`v++ -c`)
- Link kernels with HBM connectivity config (`v++ -l`)
- Host program manages kernel execution via XRT

## HBM Memory Map (VU47P - 16 GB)

| Bank | Content | Size Estimate |
|------|---------|---------------|
| 0-3  | Trace polynomials (extended) | 4 GB |
| 4-5  | Merkle trees (trace + Q) | 2 GB |
| 6-7  | FRI polynomials + trees | 2 GB |
| 8    | Constant polynomials | 1 GB |
| 9    | Constant tree | 1 GB |
| 10   | Scratch (NTT twiddles, etc.) | 1 GB |
| 11   | Proof buffer | 256 MB |

## Kernel-to-HBM Connectivity

Each kernel is mapped to HBM banks via Vitis link configuration:

```ini
[connectivity]
# NTT kernel reads/writes trace polynomials
sp=ntt_kernel.input:HBM[0:3]
sp=ntt_kernel.output:HBM[0:3]
sp=ntt_kernel.twiddles:HBM[10]

# Merkle kernel reads polynomial data, writes tree nodes
sp=merkle_kernel.source:HBM[0:3]
sp=merkle_kernel.nodes:HBM[4:5]

# FRI fold kernel
sp=fri_kernel.friPol:HBM[6]
sp=fri_kernel.output:HBM[7]

# Transcript kernel (small data, AXI-Lite feasible)
```
