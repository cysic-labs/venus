# Proof Generation Pipeline

## Overview

The proof generation pipeline transforms an execution trace into a cryptographic proof that the execution was correct. This pipeline consists of multiple stages: polynomial construction from the trace, commitment to these polynomials, constraint evaluation, and finally the FRI-based proof of polynomial proximity. Each stage builds on the previous, culminating in a compact proof that can be efficiently verified.

Understanding the pipeline helps optimize proving performance and diagnose issues. Each stage has distinct computational characteristics: trace interpolation is memory-intensive, commitment involves many cryptographic operations, and FRI queries require careful scheduling. This document covers pipeline stages, data flow, and optimization strategies for efficient proof generation.

## Pipeline Overview

### Pipeline Stages

From trace to proof:

```
Stage 1: Witness Preparation
  Input: Execution trace, auxiliary columns
  Output: Complete witness matrix
  Operations: Padding, ordering, validation

Stage 2: Polynomial Interpolation
  Input: Witness matrix columns
  Output: Polynomials representing columns
  Operations: FFT/IFFT, domain transformation

Stage 3: Polynomial Commitment
  Input: Polynomials
  Output: Merkle roots (commitments)
  Operations: Evaluation, hashing, tree construction

Stage 4: Constraint Evaluation
  Input: Polynomials, challenges
  Output: Composition polynomial
  Operations: Constraint computation, combination

Stage 5: FRI Protocol
  Input: Composition polynomial, challenges
  Output: FRI layers and queries
  Operations: Folding, commitment, query generation

Stage 6: Proof Assembly
  Input: All commitments and query responses
  Output: Final proof
  Operations: Serialization, formatting
```

### Data Flow

Information passing between stages:

```
Trace Matrix
    ↓
[Interpolation] → Trace Polynomials
    ↓
[Commitment] → Merkle Roots (sent to verifier)
    ↓                ↓
    ← Verifier Challenges ←
    ↓
[Constraint Eval] → Composition Polynomial
    ↓
[FRI] → FRI Commitments + Queries
    ↓
[Assembly] → Final Proof
```

## Witness Preparation

### Trace Finalization

Preparing the trace for proving:

```
Padding:
  Trace length to power of 2
  Fill unused rows with padding

Validation:
  Check all columns populated
  Verify constraints hold (optional pre-check)

Ordering:
  Columns in expected order
  Rows properly indexed
```

### Auxiliary Completion

Ensuring all columns ready:

```
Compute remaining auxiliaries:
  Any lazy-computed values
  Lookup multiplicities
  Accumulator columns

Verification:
  All auxiliary columns complete
  Constraints satisfied at all rows
```

## Polynomial Interpolation

### FFT-Based Interpolation

Converting columns to polynomials:

```
For each column c:
  evaluations = column_values[0..N-1]
  coefficients = IFFT(evaluations)
  polynomial = Polynomial(coefficients)

Domain:
  Evaluation domain: ω^0, ω^1, ..., ω^(N-1)
  ω is N-th root of unity

Properties:
  P(ω^i) = column_values[i]
  Degree < N
```

### Low Degree Extension

Extending to larger domain:

```
Blowup factor B:
  Extended domain size = N * B
  Typically B = 2, 4, or 8

Extension:
  coefficients = IFFT(evaluations, domain_N)
  extended = FFT(coefficients, domain_N*B)

Purpose:
  Enable FRI proximity testing
  Provide evaluation points for queries
```

## Polynomial Commitment

### Merkle Tree Construction

Committing to evaluations:

```
For extended evaluations:
  leaves = hash(extended[0]), hash(extended[1]), ...
  tree = MerkleTree(leaves)
  root = tree.root()

Commitment:
  Root hash is commitment
  Sent to verifier (or used as Fiat-Shamir input)

Opening:
  Reveal evaluation at point
  Provide Merkle path as proof
```

### Batch Commitment

Committing multiple polynomials:

```
Option 1: Separate trees
  One tree per polynomial
  Multiple roots

Option 2: Combined tree
  Interleave evaluations
  Single root

Trade-off:
  Separate: More flexible, more data
  Combined: Compact, coupled opening
```

## Constraint Evaluation

### Constraint Computation

Evaluating constraints over domain:

```
For each constraint C:
  C(x) = polynomial expression in trace polynomials

At each point x in extended domain:
  value = C(x)
  Must be zero on original domain

Composition:
  Combine constraints with random weights
  composition(x) = Σ αi * Ci(x)
```

### Quotient Polynomial

Ensuring constraint satisfaction:

```
Zero on domain:
  C(x) = 0 for x = ω^0, ..., ω^(N-1)

Divisibility:
  C(x) divisible by Z(x) = (x^N - 1)

Quotient:
  Q(x) = C(x) / Z(x)
  Q(x) is polynomial (no remainder)

Degree:
  deg(Q) = deg(C) - N
```

### Composition Polynomial

Combined quotient:

```
Composition:
  H(x) = Σ αi * Qi(x) * x^ki

Where:
  αi = random challenge weights
  ki = degree adjustments

Purpose:
  Single polynomial to prove
  Contains all constraint information
```

## FRI Protocol

### FRI Folding

Reducing polynomial degree:

```
Initial:
  f0(x) of degree < D

Round i:
  fi(x) = even(fi-1) + β * odd(fi-1)
  Degree halves each round

Final:
  Constant polynomial (degree 0)
  Reveals final value
```

### FRI Commitment

Committing to folded polynomials:

```
Each round:
  Evaluate fi over domain
  Commit via Merkle tree
  Derive next challenge βi

Sequence:
  commit(f0) → β0
  compute f1, commit(f1) → β1
  compute f2, commit(f2) → β2
  ...
  reveal final constant
```

### Query Phase

Opening at random points:

```
For each query point z:
  Open f0 at z and -z
  Open f1 at z^2
  Open f2 at z^4
  ...

Verification:
  Check folding consistency
  fi+1(z^2) = fi_even(z) + βi * fi_odd(z)

Number of queries:
  Determines security level
  Typically 20-40 queries
```

## Proof Assembly

### Proof Structure

Components of final proof:

```
Proof contents:
  - Trace commitments (Merkle roots)
  - Composition commitment
  - FRI layer commitments
  - FRI final value
  - Query responses (evaluations + paths)

Size:
  Dominated by query responses
  O(log N * num_queries) Merkle paths
```

### Serialization

Encoding the proof:

```
Format:
  Fixed header with metadata
  Commitments section
  FRI data section
  Query responses section

Encoding:
  Field elements in standard format
  Merkle paths compressed
  Deterministic ordering
```

## Pipeline Optimization

### Memory Management

Handling large data:

```
Challenges:
  Trace can be gigabytes
  Polynomials same size
  Multiple copies during processing

Strategies:
  In-place FFT when possible
  Stream processing for stages
  Memory-mapped files for large data
```

### Parallelization

Concurrent stage execution:

```
Within stages:
  Parallel FFT computation
  Parallel Merkle tree construction
  Parallel constraint evaluation

Across stages:
  Pipeline execution
  Start next stage before previous completes
  Careful dependency management
```

### Incremental Proving

Segment-by-segment:

```
Long traces:
  Prove in segments
  Aggregate segment proofs

Benefits:
  Bounded memory per segment
  Parallelizable across segments
  Resume from checkpoint
```

## Key Concepts

- **Interpolation**: Converting trace to polynomials
- **Commitment**: Cryptographic binding to data
- **Composition**: Combining constraints into one polynomial
- **FRI folding**: Degree reduction for proximity proof
- **Query response**: Openings proving consistency

## Design Considerations

### Memory vs Speed

| Low Memory | High Memory |
|------------|-------------|
| Streaming | Batch processing |
| Smaller segments | Larger segments |
| More I/O | Less I/O |
| Slower | Faster |

### Parallelism Strategy

| Stage Parallel | Pipeline Parallel |
|----------------|-------------------|
| One stage at a time | Multiple stages active |
| Simpler | More complex |
| Higher latency | Lower latency |
| Easier debugging | Harder debugging |

## Related Topics

- [Witness Generation](../01-witness-generation/01-execution-trace-generation.md) - Trace preparation
- [FRI Protocol](../../02-constraint-system/02-fri-protocol/01-fri-overview.md) - FRI details
- [Proof Compression](../../03-proof-management/03-proof-pipeline/03-proof-compression.md) - Size reduction
- [Parallel Execution](../02-execution-engine/03-parallel-execution.md) - Parallelization
