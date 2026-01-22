# Polynomial Optimization

## Overview

Polynomial optimization improves the efficiency of polynomial operations that dominate zkVM proving time. The prover performs millions of polynomial evaluations, interpolations, and multiplications. Optimizing these operations yields direct performance improvements. Techniques span algorithmic improvements (better asymptotic complexity), implementation optimizations (cache efficiency, parallelism), and representation choices (coefficient vs evaluation form).

The polynomial layer sits between constraint definitions and cryptographic commitments. Constraints define polynomial relationships; the prover instantiates these as concrete polynomials, manipulates them, and commits to results. Understanding polynomial costs guides constraint system design and prover implementation. This document covers polynomial representation, efficient algorithms, and optimization strategies.

## Polynomial Representation

### Coefficient Form

Standard polynomial representation:

```
Polynomial:
  P(X) = a₀ + a₁X + a₂X² + ... + aₙXⁿ

Storage:
  Array of coefficients [a₀, a₁, ..., aₙ]
  n+1 field elements for degree n

Operations:
  Addition: O(n) - add corresponding coefficients
  Evaluation: O(n) - Horner's method
  Multiplication: O(n²) naive, O(n log n) FFT
```

### Evaluation Form

Polynomial as evaluations:

```
Representation:
  Values at fixed points: [P(ω⁰), P(ω¹), ..., P(ωⁿ⁻¹)]
  ω = primitive n-th root of unity

Storage:
  n evaluations
  Same space as coefficients

Operations:
  Addition: O(n) - add corresponding evaluations
  Multiplication: O(n) - multiply corresponding evaluations
  Evaluation at arbitrary point: O(n) - barycentric formula
```

### Choosing Representation

When to use each:

```
Coefficient form better for:
  Division by vanishing polynomial
  Degree checking
  Sparse polynomials

Evaluation form better for:
  Polynomial multiplication
  Constraint evaluation
  Composition operations

Typical workflow:
  Store in evaluation form
  Convert for specific operations
  Convert back after
```

## FFT Optimization

### FFT Fundamentals

Fast Fourier Transform basics:

```
Purpose:
  Convert between coefficient and evaluation forms
  O(n log n) instead of O(n²)

Algorithm:
  Divide and conquer
  Split into even/odd terms
  Recursive combination

Complexity:
  Standard: O(n log n) operations
  Memory: O(n) additional space
```

### FFT Implementation

Efficient FFT implementation:

```
Iterative vs recursive:
  Recursive: Clear but overhead
  Iterative: Faster, in-place

Bit-reversal:
  Precompute permutation
  Apply once at start
  Enables in-place computation

Twiddle factors:
  Powers of ω: [1, ω, ω², ...]
  Precompute and cache
  Avoid redundant exponentiation
```

### Multi-threaded FFT

Parallel FFT execution:

```
Parallelization strategy:
  Split into independent sub-FFTs
  Each thread handles portion
  Combine results

Data layout:
  Contiguous per-thread data
  Minimize sharing
  Avoid false sharing on cache lines

Scaling:
  Near-linear to ~8-16 threads
  Limited by memory bandwidth beyond
```

### FFT Batching

Processing multiple polynomials:

```
Individual FFTs:
  FFT(P₁), FFT(P₂), ..., FFT(Pₖ)
  k separate passes over memory

Batched FFT:
  Process multiple polynomials together
  Single pass through memory
  Better cache utilization

Implementation:
  Interleaved data layout
  SIMD across polynomials
  Significant speedup for small k
```

## Polynomial Arithmetic

### Efficient Addition

Adding polynomials:

```
Same domain:
  Point-wise addition
  O(n) operations
  Trivially parallel

Different domains:
  Convert to common domain
  Then add
  FFT overhead

Sparse addition:
  Track non-zero terms
  Merge sorted lists
  O(k) for k non-zeros
```

### Efficient Multiplication

Multiplying polynomials:

```
Evaluation form:
  Point-wise multiplication
  O(n) operations
  Must handle degree increase

Coefficient form via FFT:
  Pad to 2n points
  FFT both polynomials
  Point-wise multiply
  Inverse FFT
  O(n log n) total

Karatsuba (moderate n):
  O(n^1.585) complexity
  Better than naive for n < FFT threshold
```

### Division

Polynomial division:

```
Exact division by known polynomial:
  P(X) / Z(X) where Z divides P
  Compute in evaluation form
  Verify division is exact

General division:
  Quotient and remainder
  More complex algorithm
  O(n log n) with FFT

Division by vanishing polynomial:
  Z_H(X) = X^n - 1
  Special structure exploitable
  Efficient for constraint quotients
```

## Evaluation Optimization

### Single Point Evaluation

Evaluating P(z):

```
Horner's method:
  P(z) = a₀ + z(a₁ + z(a₂ + ... + z·aₙ))
  O(n) multiplications
  O(n) additions

From evaluation form:
  Barycentric interpolation
  O(n) operations
  Precompute denominators
```

### Multi-Point Evaluation

Evaluating at many points:

```
Individual evaluations:
  n points × O(d) per point = O(nd)

Fast multi-point evaluation:
  Build evaluation tree
  O(n log² n) complexity
  Better for large n

Batched with structure:
  If points have structure (cosets)
  FFT-like optimization
  O(n log n)
```

### Coset Evaluation

Evaluation on shifted domains:

```
Standard FFT:
  Evaluates on {1, ω, ω², ...}

Coset evaluation:
  Evaluate on {g, g·ω, g·ω², ...}
  Multiply coefficients by g^i first
  Then standard FFT

Application:
  Quotient polynomial on larger domain
  Avoids division by zero
```

## Memory Efficiency

### In-Place Algorithms

Minimizing memory allocation:

```
In-place FFT:
  Modify array directly
  No additional allocation
  Bit-reversal permutation in-place

In-place multiplication:
  Requires careful ordering
  May need small buffer

Benefit:
  Lower memory footprint
  Better cache usage
  Enables larger polynomials
```

### Streaming Computation

Processing without full storage:

```
Streaming evaluation:
  Compute evaluations incrementally
  Don't store all coefficients

Streaming commitment:
  Hash chunks as computed
  Don't accumulate full polynomial

Application:
  Very large polynomials
  Memory-constrained environments
```

### Memory Pooling

Reusing allocations:

```
Pool management:
  Pre-allocate polynomial buffers
  Reuse across operations
  Avoid allocation overhead

Size classes:
  Common polynomial sizes
  Pool per size class
  Quick allocation/deallocation

Thread-local pools:
  Per-thread to avoid contention
  Periodic rebalancing
```

## Special Polynomial Handling

### Sparse Polynomials

Few non-zero coefficients:

```
Representation:
  List of (index, coefficient) pairs
  Sorted by index

Operations:
  Addition: Merge sorted lists
  Multiplication: Convolution of sparse
  Evaluation: Sum of terms

When beneficial:
  Selector polynomials (few 1s)
  Incremental differences
  Structured constraints
```

### Structured Polynomials

Polynomials with special form:

```
Vanishing polynomial:
  Z_H(X) = X^n - 1
  Two terms, special handling

Lagrange basis:
  L_i(X) evaluated at ωⁱ = 1
  Precompute and cache

Composition structure:
  P(Q(X)) where Q is simple
  Evaluate Q, then P
  May avoid full expansion
```

### Constant Polynomials

Handling constant and zero:

```
Constant polynomial:
  All evaluations equal
  Trivial FFT
  Special-case detection

Zero polynomial:
  All zeros
  Skip operations entirely

Near-constant:
  Few non-constant terms
  Sparse representation
```

## Batch Operations

### Batch Polynomial Commitment

Committing multiple polynomials:

```
Individual commits:
  Commit(P₁), Commit(P₂), ...
  k operations

Batched commit:
  Random linear combination
  Single commitment operation
  Verify with same combination

Optimization:
  Share computation across polynomials
  Single MSM for multiple polynomials
```

### Batch Evaluation Proof

Proving multiple evaluations:

```
Individual proofs:
  Prove P₁(z₁), P₂(z₂), ...
  k separate proofs

Batched proof:
  Combine with random challenge
  Single evaluation proof
  Verify combined statement
```

## Key Concepts

- **FFT optimization**: Fast conversion between representations
- **Evaluation vs coefficient form**: Trade-offs for different operations
- **In-place algorithms**: Minimizing memory overhead
- **Batch operations**: Amortizing overhead across polynomials
- **Sparse handling**: Exploiting structure for efficiency

## Design Considerations

### Representation Choice

| Coefficient Form | Evaluation Form |
|------------------|-----------------|
| Natural for division | Natural for multiplication |
| Sparse representation | Dense representation |
| Degree explicit | Degree implicit |
| FFT to convert | IFFT to convert |

### Optimization Priority

| Algorithm | Implementation |
|-----------|----------------|
| Better asymptotic | Better constants |
| Fundamental improvement | Engineering effort |
| Once-designed | Continuous tuning |
| Clear benefit | Measured improvement |

## Related Topics

- [Constraint Optimization](01-constraint-optimization.md) - Constraint-level optimization
- [Memory Optimization](03-memory-optimization.md) - Memory efficiency
- [Polynomial Commitment](../../03-stark-proving-system/01-polynomial-iop/02-polynomial-commitment.md) - Commitment schemes
- [FRI Protocol](../../03-stark-proving-system/02-fri-protocol/01-fri-overview.md) - FRI operations

