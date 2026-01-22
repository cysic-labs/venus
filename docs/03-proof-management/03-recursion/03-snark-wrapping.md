# SNARK Wrapping

## Overview

SNARK wrapping converts a STARK proof into a SNARK proof by proving, inside a SNARK system, that STARK verification succeeds. The result is a tiny proof (typically 128-300 bytes) that attests to the validity of the original STARK computation. This technique combines STARK's transparent setup and fast proving with SNARK's minimal proof size and efficient verification.

The process encodes the STARK verifier as an arithmetic circuit suitable for SNARK proving. The STARK proof becomes witness data, and the circuit checks that running the STARK verifier on this witness produces "accept." The SNARK proof then attests to correct verification. This is a specific form of recursive proving where the inner proof system is STARK and the outer system is SNARK.

Understanding SNARK wrapping is essential for practical proof system deployment. Many applications require tiny proofs for on-chain verification or bandwidth-constrained environments. SNARK wrapping achieves proof sizes up to 500x smaller than native STARK, making previously impractical applications viable. This document covers the wrapping process, circuit design, and implementation considerations.

## Why SNARK Wrapping

### Motivation

Benefits of wrapping:

```
Proof size:
  Native STARK: 100-400 KB
  Wrapped SNARK: 128-300 bytes
  Reduction: ~1000x

Verification cost:
  STARK: ~500,000 gas (Ethereum)
  SNARK: ~200,000-300,000 gas
  Significant savings

Combined benefits:
  STARK: Fast proving, transparent setup
  SNARK: Tiny proofs, cheap verification
  Best of both worlds
```

### When to Wrap

Decision criteria:

```
Wrap when:
  On-chain verification required
  Bandwidth constrained
  Many verifiers (amortize wrap cost)
  Proof storage expensive

Don't wrap when:
  Off-chain verification only
  Latency critical (wrapping is slow)
  Single-use proofs
  Trusted setup unacceptable
```

## The Wrapping Process

### High-Level Flow

Steps to wrap a STARK proof:

```
1. Generate STARK proof:
   Native STARK proving
   Output: proof π_stark, public inputs

2. Prepare wrapper circuit inputs:
   STARK proof as private witness
   Public inputs as public circuit inputs

3. Prove STARK verification:
   Run SNARK prover on wrapper circuit
   Witness includes π_stark
   Output: SNARK proof π_snark

4. Result:
   π_snark attests: Verify_STARK(π_stark, pub) = accept
   Size: ~128-300 bytes
```

### Verification Circuit

What the wrapper circuit computes:

```
Circuit inputs:
  Public: statement (public inputs to STARK)
  Private: STARK proof components

Circuit computation:
  1. Parse STARK proof structure
  2. Verify polynomial commitments
  3. Check FRI proof validity
  4. Verify constraint evaluations
  5. Validate challenge derivation
  6. Output: 1 if valid, 0 otherwise

Circuit constraint:
  Output must equal 1
```

### Critical Components

Most expensive circuit parts:

```
Hash computations:
  Challenge derivation (Fiat-Shamir)
  Merkle path verification
  Commitment checks
  Dominates circuit size

FRI verification:
  Query response checking
  Folding verification
  Multiple rounds

Field arithmetic:
  Constraint evaluation
  Polynomial evaluation
  Native or emulated
```

## Circuit Design

### Hash Function Choice

The most important design decision:

```
Standard hashes (SHA-256, Keccak):
  Circuit size: ~25,000 constraints per hash
  Many hashes needed: ~100s to 1000s
  Total: millions of constraints
  Impractical for most SNARKs

Algebraic hashes (Poseidon):
  Circuit size: ~250-500 constraints per hash
  Same hash count
  Total: 100,000s of constraints
  Practical for modern SNARKs

Impact:
  100x difference in circuit size
  Poseidon essentially required
  Design STARK with wrapping in mind
```

### STARK Verifier as Circuit

Encoding verification steps:

```
Commitment verification:
  Input: claimed root, value, path
  Compute: hash up the path
  Check: equals root

FRI verification:
  For each query:
    Verify folding consistency
    Check evaluations match
    Verify layer commitments

Constraint check:
  Evaluate constraints at query point
  Combine with challenges
  Verify quotient relationship
```

### Circuit Optimization

Reducing circuit size:

```
Reduce STARK parameters for wrapping:
  Fewer FRI queries (less security)
  Fewer constraints
  Acceptable because SNARK adds security

Batch operations:
  Verify multiple paths together
  Share intermediate computations

Hint-based verification:
  Prover provides intermediate values
  Circuit verifies correctness
  Reduces circuit depth
```

## SNARK System Selection

### Groth16

Smallest proofs:

```
Properties:
  Proof size: 128 bytes (BN254)
  Verification: 3 pairings
  Trusted setup: Per-circuit

Advantages:
  Smallest possible proofs
  Fastest verification
  Mature implementation

Disadvantages:
  Circuit-specific setup
  Setup ceremony required
  Large proving key
```

### PLONK and Variants

Universal setup:

```
Properties:
  Proof size: ~300-500 bytes
  Verification: ~10-20ms
  Trusted setup: Universal (one-time)

Variants:
  PLONK: Original
  FFLONK: Faster prover
  HyperPLONK: Different trade-offs

Advantages:
  One setup for all circuits
  Good tooling
  Active development

Disadvantages:
  Larger proofs than Groth16
  More complex verification
```

### Halo2

No trusted setup (with recursion):

```
Properties:
  Proof size: ~5-10 KB
  Verification: Polynomial commitments
  Setup: Transparent (Pedersen-based)

Advantages:
  No trusted setup
  Good performance
  Strong ecosystem

Disadvantages:
  Larger proofs
  Different commitment scheme
  May need recursion for small proofs
```

## Field Considerations

### Field Matching

Compatibility requirements:

```
STARK field:
  Typically prime field
  Goldilocks (64-bit) common
  Or larger (256-bit)

SNARK field:
  Determined by elliptic curve
  BN254: ~254-bit prime
  BLS12-381: ~381-bit prime

Compatibility:
  Ideal: STARK field embeds in SNARK field
  Otherwise: Non-native arithmetic
  Significant overhead if mismatched
```

### Non-Native Arithmetic

When fields don't match:

```
Problem:
  STARK uses field F_p
  SNARK uses field F_q
  p ≠ q

Solution:
  Emulate F_p arithmetic in F_q
  Represent F_p elements as limbs
  Multi-precision constraints

Cost:
  10-100x overhead
  Much larger circuit
  May need intermediate recursion
```

### Field-Friendly Design

Designing for compatibility:

```
Approaches:
  Choose STARK field = SNARK field
  Use field with efficient embedding
  Accept emulation cost if necessary

Example:
  STARK over BN254 scalar field
  Wrap with Groth16 over BN254
  Native arithmetic, efficient wrap
```

## Implementation Considerations

### Prover Resources

Wrapper proving costs:

```
Memory:
  Full circuit in memory
  Large proving key (Groth16)
  10-100 GB typical

Time:
  Circuit size dependent
  Minutes to hours
  GPU acceleration helps

Optimization:
  Smaller wrapper circuit
  Better prover implementation
  Hardware acceleration
```

### Verification Resources

Wrapped proof verification:

```
SNARK verification:
  Parse proof
  Perform pairings (Groth16/PLONK)
  Check equations

On-chain:
  Precompiles for pairings
  Gas cost ~200-300K
  Constant regardless of original size

Off-chain:
  Milliseconds
  Constant time
  Minimal resources
```

### Production Pipeline

Practical wrapping system:

```
Architecture:
  STARK prover (fast, parallel)
  Wrapper prover (slower, specialized)
  Proof storage and routing

Workflow:
  1. Batch STARK proofs
  2. Aggregate (optional)
  3. Wrap to SNARK
  4. Submit wrapped proof

Considerations:
  Batching amortizes wrap cost
  Multiple wrapper workers
  GPU/FPGA acceleration
```

## Security Considerations

### Combined Security

Security of wrapped system:

```
STARK security:
  Hash collision resistance
  FRI soundness
  Computational security

SNARK security:
  Discrete log hardness
  Pairing assumptions
  May include trusted setup

Combined:
  Both must hold
  Weaker assumptions of either
  Typically limited by SNARK
```

### Trusted Setup

SNARK setup considerations:

```
Groth16:
  Circuit-specific setup
  Must trust setup ceremony
  Or verify MPC transcript

Universal SNARK:
  One-time setup
  Reusable for any circuit
  Still requires trust/MPC

Transparent SNARK:
  No trusted setup
  Usually larger proofs
  Halo2, etc.
```

## Key Concepts

- **SNARK wrapping**: Converting STARK proof to tiny SNARK proof
- **Wrapper circuit**: STARK verifier encoded as arithmetic circuit
- **Algebraic hash**: Essential for practical wrapper circuit size
- **Field compatibility**: Matching STARK and SNARK fields
- **Combined security**: Security from both proof systems

## Design Considerations

### SNARK System Trade-offs

| Groth16 | PLONK | Halo2 |
|---------|-------|-------|
| 128 bytes | ~400 bytes | ~5 KB |
| Per-circuit setup | Universal setup | No trusted setup |
| Fastest verify | Medium verify | Slower verify |
| Smallest | Balanced | Largest |

### Wrapping Strategy

| Direct Wrap | Multi-Stage |
|-------------|-------------|
| STARK → SNARK | STARK → STARK → SNARK |
| One conversion | Multiple stages |
| Simpler | Better compression |
| Larger wrapper circuit | Smaller final circuit |

## Related Topics

- [Recursive Proving](01-recursive-proving.md) - General recursion
- [Proof Compression](02-proof-compression.md) - Size reduction
- [Algebraic Hashes](../../01-mathematical-foundations/03-hash-functions/01-algebraic-hashes.md) - Hash design
- [FRI Protocol](../../02-stark-proving-system/03-fri-protocol/01-fri-fundamentals.md) - What gets verified

