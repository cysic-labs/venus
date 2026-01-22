# STARK Proof Structure

## Overview

A STARK proof is a carefully organized collection of cryptographic commitments, polynomial evaluations, and authentication paths that together convince a verifier of computational correctness. Understanding the structure of a STARK proof is essential for implementing provers, verifiers, and systems that process or aggregate proofs.

This document dissects the anatomy of a STARK proof, explaining each component's purpose and how they work together to establish soundness. We cover the logical organization, the data formats, and the relationships between different proof elements.

## High-Level Structure

### Proof Components

A STARK proof consists of several major sections:

```
STARK Proof
├── Trace Commitment
│   └── Merkle root of execution trace polynomials
├── Constraint Commitment
│   └── Merkle root of constraint composition polynomial
├── FRI Proof
│   ├── FRI Layer Commitments
│   │   └── Merkle roots of folded polynomials
│   ├── Final Polynomial
│   │   └── Coefficients of reduced polynomial
│   └── Query Responses
│       └── Evaluations and authentication paths
└── Deep Composition Data
    └── Out-of-domain evaluations
```

### Data Flow

The proof follows a logical flow:

1. **Commit**: Prover commits to trace and constraints
2. **Challenge**: Verifier challenges (via Fiat-Shamir)
3. **Compose**: Prover combines polynomials
4. **Prove degree**: FRI proves low-degree property
5. **Open**: Prover reveals values at query points

## Trace Commitment

### Purpose

The trace commitment binds the prover to the execution trace before any challenges are known. This prevents the prover from changing the trace to match challenges.

### Structure

```
Trace Commitment:
├── Merkle Root (32 bytes)
│   └── Root of tree over LDE evaluations
└── Metadata
    ├── Trace length
    ├── Number of columns
    └── LDE blowup factor
```

### Construction Process

1. **Interpolate**: Convert trace columns to polynomials
2. **Extend**: Evaluate on larger domain (LDE)
3. **Commit**: Hash evaluations row-wise, build Merkle tree

```
Trace columns: [col_0, col_1, ..., col_k]
    |
    v (interpolate)
Trace polynomials: [P_0(X), P_1(X), ..., P_k(X)]
    |
    v (LDE evaluation)
Extended evaluations: [[P_0(g*w^i), P_1(g*w^i), ...] for i in 0..n*blowup]
    |
    v (hash each row)
Leaf hashes: [H(row_0), H(row_1), ..., H(row_{n*blowup})]
    |
    v (Merkle tree)
Trace commitment root
```

### Multiple Trace Segments

For multi-stage proofs, there may be multiple trace commitments:

```
Stage 1: Base trace commitment
  (after challenge alpha)
Stage 2: Extended trace commitment
  (after challenge beta)
Stage 3: ...
```

Each stage adds columns that may depend on previous challenges.

## Constraint Commitment

### Purpose

The constraint commitment captures the constraint polynomials and their composition. It proves that constraints are satisfied (evaluate to zero on the trace domain).

### Composition Polynomial

Multiple constraint polynomials are combined:

```
C(X) = sum_i alpha^i * C_i(X)
```

where alpha is a random challenge and C_i are individual constraints.

### Quotient Polynomial

The key polynomial is the quotient:

```
Q(X) = C(X) / Z(X)
```

where Z(X) is the vanishing polynomial for the trace domain.

If C(X) = 0 at all trace points, Q(X) is a polynomial (not rational).

### Structure

```
Constraint Commitment:
├── Composition Merkle Root (32 bytes)
└── Quotient Degree Bound
```

## FRI Proof

### Overview

The FRI (Fast Reed-Solomon IOP) component proves that committed polynomials have bounded degree. This is the heart of the STARK's soundness.

### Layer Commitments

FRI proceeds in rounds, each committing to a folded polynomial:

```
FRI Layers:
├── Layer 0 Commitment (original polynomial)
├── Layer 1 Commitment (folded by alpha_0)
├── Layer 2 Commitment (folded by alpha_1)
├── ...
└── Layer k Commitment (small polynomial)
```

Each layer halves (or reduces by folding factor) the polynomial degree.

### Final Polynomial

When the polynomial is small enough, its coefficients are sent directly:

```
Final Polynomial:
├── Coefficients: [c_0, c_1, ..., c_d]
└── Degree: d (typically <= 64)
```

The verifier checks that this polynomial is indeed low-degree.

### Query Responses

For each query index, the proof includes:

```
Query Response:
├── Query Index
├── Trace Evaluations
│   └── Values at trace columns for this index
├── Trace Authentication Path
│   └── Merkle siblings to root
├── FRI Layer Evaluations
│   └── Values at each FRI layer
└── FRI Layer Authentication Paths
    └── Merkle siblings for each layer
```

Multiple queries (typically 30-80) provide soundness amplification.

### FRI Structure Detail

```
FRI Proof:
├── Commitments: [commit_0, commit_1, ..., commit_k]
├── Challenges: [alpha_0, alpha_1, ..., alpha_{k-1}]
│   (derived via Fiat-Shamir)
├── Final Polynomial Coefficients
└── Query Responses:
    └── For each query i:
        ├── Layer 0: (value, auth_path)
        ├── Layer 1: (value, auth_path)
        ├── ...
        └── Layer k: (value, auth_path)
```

## Deep Composition

### Out-of-Domain Sampling

The DEEP (Domain Extension for Eliminating Pretenders) technique samples the polynomial outside the evaluation domain:

```
Sample point z (random, in extension field)
Evaluations: [P_0(z), P_1(z), ..., Q(z)]
```

### Purpose

Out-of-domain evaluation prevents attacks where the prover constructs a fake polynomial agreeing with a true low-degree polynomial only on the evaluation domain.

### Structure

```
Deep Composition:
├── OOD Point: z
├── OOD Evaluations:
│   ├── Trace polynomials at z
│   ├── Trace polynomials at z * g (for transitions)
│   └── Constraint polynomial at z
└── Deep Composition Polynomial Commitment
```

## Proof Serialization

### Binary Format

A typical proof serialization:

```
Proof Binary:
├── Header
│   ├── Version (4 bytes)
│   ├── Security parameter (4 bytes)
│   ├── Trace length (8 bytes)
│   └── Number of columns (4 bytes)
├── Trace Commitment (32 bytes)
├── Constraint Commitment (32 bytes)
├── OOD Evaluations
│   └── (num_columns + 1) * field_element_size
├── FRI Commitments
│   └── num_fri_layers * 32 bytes
├── FRI Final Polynomial
│   └── (final_degree + 1) * field_element_size
└── Query Responses
    └── num_queries * response_size
```

### Size Breakdown

For a typical STARK proof (trace of 2^20, 100 columns):

| Component | Approximate Size |
|-----------|-----------------|
| Commitments | ~500 bytes |
| OOD evaluations | ~1 KB |
| FRI commitments | ~500 bytes |
| Final polynomial | ~500 bytes |
| Query responses | 80-200 KB |
| **Total** | **~100-250 KB** |

Query responses dominate proof size.

## Verification Algorithm

### Verification Steps

The verifier processes the proof in stages:

```python
def verify_stark(proof, public_inputs):
    # 1. Reconstruct challenges via Fiat-Shamir
    transcript = initialize_transcript(public_inputs)
    transcript.absorb(proof.trace_commitment)
    alpha = transcript.squeeze_challenge()
    # ... more challenges

    # 2. Verify OOD consistency
    verify_ood_evaluations(proof, alpha, ...)

    # 3. Verify FRI
    verify_fri(proof.fri_proof, challenges)

    # 4. Verify query consistency
    for query in proof.queries:
        verify_query(query, proof, challenges)

    return True
```

### Query Verification

For each query, the verifier checks:

1. **Authentication**: Merkle paths are valid
2. **Consistency**: Evaluations match constraint composition
3. **FRI folding**: Layer-to-layer values are consistent

```python
def verify_query(query, proof, challenges):
    # Verify trace Merkle path
    assert merkle_verify(
        proof.trace_commitment,
        query.index,
        query.trace_values,
        query.trace_auth_path
    )

    # Verify constraint consistency
    constraint_eval = evaluate_constraints(query.trace_values, challenges)
    assert constraint_eval == query.constraint_value

    # Verify FRI folding consistency
    for i in range(num_fri_layers):
        verify_fri_folding(
            query.fri_values[i],
            query.fri_values[i+1],
            challenges.fri_alpha[i]
        )
```

## Proof Composition

### Aggregating Multiple Proofs

Multiple STARK proofs can be composed:

```
Proof Aggregation:
├── Individual Proofs: [proof_1, proof_2, ...]
├── Aggregation Challenge
└── Combined Verification Polynomial
```

### Recursive Proofs

In recursive composition, the proof includes:

```
Recursive Proof:
├── Inner Proof Hash (or commitment)
├── Verification Computation Trace
└── Outer STARK Proof (proving verification)
```

## Optimization Considerations

### Proof Size Optimization

Techniques to reduce proof size:

1. **Merkle tree optimization**: Use smaller hash outputs, prune paths
2. **Batched openings**: Share authentication paths for nearby queries
3. **Compressed representations**: Delta-encode similar values
4. **FRI parameter tuning**: Balance rounds vs. query count

### Verification Optimization

For faster verification:

1. **Parallelization**: Verify queries independently
2. **Batch verification**: Combine Merkle path checks
3. **Precomputation**: Cache domain elements
4. **Hardware acceleration**: Use SIMD for field arithmetic

### Prover Optimization

For faster proving:

1. **NTT optimization**: Use cache-friendly NTT variants
2. **Parallelization**: Commit and evaluate in parallel
3. **Memory management**: Stream large traces
4. **GPU acceleration**: Offload NTT and hashing

## Security Parameters

### Parameter Relationships

Key parameters and their security implications:

| Parameter | Effect on Security | Effect on Performance |
|-----------|-------------------|----------------------|
| Field size | Larger = more secure | Larger = slower |
| Blowup factor | Larger = smaller proofs | Larger = slower |
| Num queries | More = more secure | More = larger proofs |
| FRI folding | Larger = fewer rounds | Larger = more work/round |
| Hash output | Larger = more secure | Larger = larger proofs |

### Typical Secure Configurations

For 100+ bits security:

```
Field: Goldilocks (64-bit) or larger
Blowup factor: 4-8x
Queries: 40-80
FRI folding factor: 2-4
Hash: 256-bit (SHA-256 or Poseidon)
Extension degree: 2-4 for challenges
```

## Key Concepts

- **Trace commitment**: Merkle root binding prover to execution trace
- **Constraint commitment**: Merkle root of composed constraint polynomial
- **FRI layers**: Progressive folding commitments proving low degree
- **Query responses**: Openings at random positions with authentication
- **OOD evaluations**: Out-of-domain samples preventing certain attacks
- **Proof serialization**: Binary format for storage and transmission

## Design Considerations

### Format Stability

For long-term proof storage:
- Version proof format explicitly
- Document all serialization details
- Plan for format evolution

### Interoperability

For cross-system proof verification:
- Standardize field representations
- Define canonical Merkle tree construction
- Specify challenge derivation precisely

### Compression

For transmission or storage:
- Query responses are compressible
- Consider application-level compression
- Trade-off decompression cost vs. size

## Related Topics

- [STARK Introduction](01-stark-introduction.md) - Foundational concepts
- [STARK vs SNARK](02-stark-vs-snark.md) - Alternative proof structures
- [FRI Fundamentals](../03-fri-protocol/01-fri-fundamentals.md) - FRI protocol details
- [Trace Commitment](../04-proof-generation/02-trace-commitment.md) - Building trace commitments
- [Verification Algorithm](../05-verification/01-verification-algorithm.md) - Full verification procedure
