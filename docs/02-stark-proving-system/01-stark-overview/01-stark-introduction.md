# STARK Introduction

## Overview

STARK (Scalable Transparent ARgument of Knowledge) is a proof system that enables one party (the prover) to convince another party (the verifier) that a computation was performed correctly, without the verifier needing to re-execute the computation. STARKs are the cryptographic engine powering modern zkVMs, providing the mathematical machinery to transform execution traces into succinct, verifiable proofs.

The "Scalable" property means proving time grows nearly linearly with computation size while verification remains fast. "Transparent" indicates no trusted setup is required - all parameters are publicly derivable. "ARgument of Knowledge" means the prover demonstrably possesses a valid witness (execution trace) satisfying the claimed constraints.

This document introduces the fundamental concepts, workflow, and properties of STARK proof systems.

## The Core Idea

### From Computation to Proof

A STARK transforms computational correctness into a mathematical statement about polynomials:

```
Correct Computation <-> Low-Degree Polynomials Satisfying Constraints
```

The prover demonstrates that polynomials encoding the execution trace:
1. Have bounded degree (are "low-degree")
2. Satisfy constraint equations at all trace positions

If both conditions hold, the computation was correct with overwhelming probability.

### Why Polynomials?

Polynomials have a remarkable property: a polynomial of degree d is uniquely determined by d + 1 points. This means:

- If two polynomials of degree d agree at d + 1 points, they are identical
- If they disagree at even one point beyond d, they differ at most points

This enables efficient probabilistic testing: checking agreement at random points provides high confidence about polynomial equality.

## STARK Architecture

### High-Level Flow

```
Execution Trace
      |
      v
Encode as Polynomials (trace columns -> polynomials)
      |
      v
Extend to Larger Domain (Reed-Solomon encoding)
      |
      v
Commit via Merkle Tree (binding commitment)
      |
      v
Compute Constraint Polynomials
      |
      v
FRI Low-Degree Test (prove constraints are satisfied)
      |
      v
Generate Query Responses
      |
      v
Final Proof
```

### The Execution Trace

The execution trace is a table recording the complete state of the computation at each step:

```
Step | PC  | Reg0 | Reg1 | ... | Memory | ...
-----|-----|------|------|-----|--------|----
  0  | 100 |  0   |  5   | ... |  ...   | ...
  1  | 104 |  5   |  5   | ... |  ...   | ...
  2  | 108 |  10  |  5   | ... |  ...   | ...
  ...
```

Each column becomes a polynomial, with row i corresponding to evaluation at omega^i (where omega is a root of unity).

### Constraint System

Constraints express the rules the computation must follow:

**Transition constraints**: Relate consecutive rows
```
next_pc = pc + 4  (for sequential instructions)
next_reg0 = reg0 + reg1  (for ADD instruction)
```

**Boundary constraints**: Fix values at specific positions
```
pc[0] = entry_point  (initial PC)
output[last] = claimed_output  (final output)
```

**Consistency constraints**: Global properties
```
memory_read_value = memory_write_value  (for same address)
```

### The Quotient Polynomial

If constraint polynomial C(X) equals zero at all trace positions, it must be divisible by the vanishing polynomial Z(X):

```
C(X) = Q(X) * Z(X)
```

The prover computes quotient Q(X) and commits to it. If Q exists as a polynomial (not a rational function), then C(X) was indeed zero at all required points.

### FRI Protocol

FRI (Fast Reed-Solomon Interactive Oracle Proof) verifies that committed polynomials have bounded degree. It works by:

1. Repeatedly "folding" the polynomial to reduce its degree
2. Checking consistency between folding layers
3. Verifying the final (small) polynomial directly

FRI is the core mechanism that makes STARKs work.

## Properties of STARKs

### Scalability

**Prover time**: O(n log n) where n is trace size
- Near-linear in computation size
- Dominated by NTT operations

**Verifier time**: O(log^2 n)
- Polylogarithmic in computation size
- Essentially constant for practical purposes

**Proof size**: O(log^2 n)
- Grows slowly with computation size
- Typically tens to hundreds of kilobytes

### Transparency

No trusted setup ceremony required:
- All parameters derived from public information
- No trapdoors or secret values
- Anyone can verify parameter generation

This eliminates a significant trust assumption present in many SNARKs.

### Post-Quantum Security

STARKs rely only on:
- Collision-resistant hash functions
- Information-theoretic soundness of polynomial testing

No assumptions about discrete logarithms or elliptic curves, which are vulnerable to quantum attacks.

### Soundness

If the prover cheats (claims incorrect computation), they are caught with probability at least 1 - 2^(-lambda) where lambda is the security parameter (typically 80-128).

The soundness comes from:
- Random sampling of evaluation points
- Cryptographic binding of commitments
- Low probability of "lucky" fake polynomials

## The STARK Workflow

### Setup Phase

Before proving begins:
1. Fix the constraint system (defines what computation means)
2. Choose field and security parameters
3. Precompute domain elements (roots of unity, twiddle factors)

No secret information is involved - setup is deterministic and public.

### Prove Phase

Given an execution trace, the prover:

1. **Interpolates trace polynomials**: Convert columns to coefficient form
2. **Extends evaluations**: Evaluate on a larger domain (LDE)
3. **Commits to trace**: Build Merkle tree, publish root
4. **Computes constraint polynomials**: Evaluate constraints on LDE domain
5. **Computes quotient polynomials**: Divide by vanishing polynomial
6. **Commits to quotients**: Build Merkle tree, publish root
7. **Runs FRI**: Prove polynomials have correct degree
8. **Answers queries**: Open commitments at random positions

The proof consists of all commitments, FRI responses, and query openings.

### Verify Phase

The verifier:

1. **Regenerates challenges**: Using Fiat-Shamir on proof transcript
2. **Checks FRI validity**: Verify folding consistency
3. **Spot-checks constraints**: Verify opened values satisfy constraints
4. **Verifies Merkle paths**: Confirm openings match commitments

Verification is fast because it samples only a few positions.

## The Random Oracle Model

### Fiat-Shamir Transform

Interactive proofs require verifier challenges. The Fiat-Shamir transform makes them non-interactive:

```
challenge = Hash(previous_proof_messages)
```

The prover cannot predict challenges without first committing, and changing commitments changes challenges unpredictably.

### Transcript Building

A "transcript" accumulates all messages:

```python
def generate_challenge(transcript, domain_separator):
    transcript.append(domain_separator)
    challenge = Hash(transcript)
    transcript.append(challenge)
    return challenge
```

This ensures challenges depend on all prior commitments.

## Security Analysis

### Soundness Error

The probability a cheating prover succeeds is bounded by:

```
soundness_error <= (constraint_degree / |F|)^num_queries + fri_soundness_error
```

With:
- Large field |F| ~ 2^64
- Many queries (e.g., 50)
- Conservative FRI parameters

Soundness error is negligible (< 2^(-100)).

### Completeness

An honest prover with a valid trace always produces a valid proof:
- Polynomial interpolation is exact
- Constraints are satisfied by construction
- FRI accepts valid low-degree polynomials

### Knowledge Soundness

Beyond just soundness, STARKs are "arguments of knowledge":
- If the prover produces a valid proof, they must "know" a valid trace
- Formally: an extractor can recover the trace from the prover

This is crucial for applications where the trace itself is meaningful.

## Comparison with IOPs

### Interactive Oracle Proofs

STARKs are built on Interactive Oracle Proofs (IOPs):
- Prover sends polynomial "oracles"
- Verifier can query oracles at chosen points
- Multiple rounds of interaction

### Compiling IOPs to STARKs

To make IOPs concrete:
- Replace oracles with Merkle commitments
- Replace interaction with Fiat-Shamir
- Replace point queries with Merkle openings

This transforms the theoretical IOP into a practical STARK.

## Key Concepts

- **STARK**: Scalable Transparent ARgument of Knowledge
- **Execution trace**: Table of computation state at each step
- **Constraint polynomial**: Polynomial encoding correctness rules
- **Quotient polynomial**: Result of dividing constraints by vanishing polynomial
- **FRI**: Protocol proving polynomial has bounded degree
- **Fiat-Shamir**: Transforms interactive proof to non-interactive
- **Soundness**: Probability of catching a cheating prover

## Design Considerations

### Parameter Selection

Key parameters and their trade-offs:

| Parameter | Increase Effect | Decrease Effect |
|-----------|-----------------|-----------------|
| Field size | Better soundness | Slower arithmetic |
| Expansion factor | Smaller proofs | More computation |
| Number of queries | Better soundness | Larger proofs |
| FRI folding factor | Fewer rounds | More work per round |

### Constraint Optimization

Efficient STARKs require careful constraint design:
- Lower degree constraints are faster
- Fewer constraint polynomials reduce overhead
- Structured constraints enable optimizations

### Proof Size vs. Prover Time

Trade-off exists between:
- Larger expansion factor -> Smaller proofs, slower prover
- More queries -> Better soundness, larger proofs
- Higher FRI reduction -> Fewer rounds, more work per round

## Related Topics

- [STARK vs SNARK](02-stark-vs-snark.md) - Comparison with alternative proof systems
- [Proof Structure](03-proof-structure.md) - Detailed anatomy of a STARK proof
- [FRI Fundamentals](../03-fri-protocol/01-fri-fundamentals.md) - Core low-degree testing protocol
- [Constraint System](../02-constraint-system/01-algebraic-intermediate-representation.md) - Expressing computation as constraints
- [Witness Generation](../04-proof-generation/01-witness-generation.md) - Building the execution trace
