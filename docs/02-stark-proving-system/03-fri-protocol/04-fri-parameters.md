# FRI Parameters

## Overview

FRI parameter selection is a critical aspect of STARK proof system design, directly affecting proof size, verification time, prover performance, and security guarantees. The main parameters include the blowup factor (expansion rate), number of queries, folding factor, hash function choice, and final polynomial degree. These parameters are interdependent, and optimizing one often requires adjusting others.

Understanding parameter trade-offs enables system designers to configure FRI for specific use cases - from high-security financial applications requiring conservative parameters to experimental settings where proof size is paramount. This document provides guidance on parameter selection, analysis of trade-offs, and concrete recommendations for common scenarios.

## Core Parameters

### Blowup Factor

The blowup factor (also called expansion factor or rate inverse) determines the ratio between evaluation domain size and polynomial degree:

```
blowup_factor = |evaluation_domain| / degree_bound

Equivalently: rate = 1 / blowup_factor = degree_bound / |domain|
```

Common values and their implications:

| Blowup Factor | Rate | Implications |
|---------------|------|--------------|
| 2 | 0.5 | Minimum practical, highest risk |
| 4 | 0.25 | Common for optimized systems |
| 8 | 0.125 | Good security margin |
| 16 | 0.0625 | Conservative choice |
| 32 | 0.03125 | Very conservative |

### Effect of Blowup Factor

Higher blowup factor:
- Larger evaluation domain requires more prover memory
- More FRI layers (larger domain to fold down)
- Better error detection (more redundancy in encoding)
- Lower soundness error per query

Lower blowup factor:
- Smaller proofs (fewer layers, smaller domain)
- Faster prover (less evaluation work)
- Requires more queries for same security
- Relies more heavily on soundness conjectures

### Number of Queries

The query count q directly affects soundness error:

```
soundness_error ≈ rate^q (conjectured)
soundness_error ≤ (constant * rate)^q (proven, looser)
```

Security level in bits:

```
For rate = 0.25 and target 128-bit security:
  rate^q = 2^(-128)
  0.25^q = 2^(-128)
  q * log2(0.25) = -128
  q * (-2) = -128
  q = 64 queries
```

### Query Count Table

Queries needed for various security levels (using rate = 1/blowup):

| Blowup | Rate | 80-bit | 100-bit | 128-bit |
|--------|------|--------|---------|---------|
| 2 | 0.5 | 80 | 100 | 128 |
| 4 | 0.25 | 40 | 50 | 64 |
| 8 | 0.125 | 27 | 34 | 43 |
| 16 | 0.0625 | 20 | 25 | 32 |

Note: Conservative proven bounds may require 50-100% more queries.

### Folding Factor

Standard FRI folds by factor of 2 (halving degree each round). Some implementations use larger folding factors:

```
Folding factor 2:
  - Degree d -> d/2 -> d/4 -> ... -> d_final
  - log2(d / d_final) rounds

Folding factor 4:
  - Degree d -> d/4 -> d/16 -> ... -> d_final
  - log4(d / d_final) rounds
  - Requires two challenges per round
  - Fewer commitments, but larger verification work per round
```

### Folding Factor Trade-offs

| Folding Factor | Advantages | Disadvantages |
|----------------|------------|---------------|
| 2 | Simplest, well-analyzed | Most layers |
| 4 | Fewer layers, smaller proofs | More complex folding |
| 8 | Even fewer layers | Increased per-layer verification |

### Final Polynomial Degree

The degree at which FRI stops folding and sends coefficients directly:

```
Typical choices: 1, 2, 4, 8, 16, 32

Lower d_final:
  - More folding rounds
  - Smaller final polynomial to send
  - Verification evaluates smaller polynomial

Higher d_final:
  - Fewer folding rounds
  - Larger final polynomial to send
  - May amortize some commitment overhead
```

### Hash Function Selection

FRI relies on hash functions for:
1. Merkle tree construction
2. Fiat-Shamir challenge generation

Common choices:

| Hash | Output Size | Performance | Security |
|------|-------------|-------------|----------|
| Blake2b | 256 bits | Very fast | Well-analyzed |
| Blake3 | 256 bits | Fastest | Newer, good |
| SHA-256 | 256 bits | Fast (HW) | Standard |
| Poseidon | ~256 bits | Slower | ZK-friendly |
| Keccak-256 | 256 bits | Moderate | Standard |

For FRI specifically, non-algebraic hashes (Blake, SHA) are typically preferred as they're faster and FRI doesn't require algebraic structure.

## Parameter Interactions

### Blowup vs. Queries

These are the primary trade-off:

```
Higher blowup + fewer queries = Similar security
Lower blowup + more queries = Similar security

But proof size differs:
- Blowup affects: domain size, number of layers, Merkle tree size
- Queries affect: number of openings, linear in query count

For many configurations:
  More blowup -> smaller proofs (despite larger trees)
  Because fewer queries -> fewer Merkle paths
```

### Domain Size Constraints

Domain size must satisfy:

```
|domain| = blowup * degree_bound
|domain| must be power of 2 (for FFT)
|domain| divides (p - 1) for prime field F_p (for roots of unity)
```

This may force adjustments:

```
Example:
  degree_bound = 2^20
  desired blowup = 6
  required domain = 6 * 2^20 = 3 * 2^21 (not power of 2)

  Options:
    - Use blowup = 8, domain = 2^23
    - Use blowup = 4, domain = 2^22
    - Use blowup = 6 with non-power-of-2 FFT (slower)
```

### Layers and Proof Size

Number of FRI layers:

```
num_layers = log2(degree_bound / d_final)

Example:
  degree_bound = 2^20, d_final = 4
  layers = log2(2^20 / 4) = log2(2^18) = 18
```

Proof size contribution from layers:

```
Per query:
  - 2 field elements per layer (paired evaluations)
  - Merkle path per layer

Approximate: q * num_layers * (2 * element_size + path_size)
```

### Memory Requirements

Prover memory scales with domain size:

```
Evaluation domain storage:
  domain_size * element_size = blowup * degree_bound * element_size

For 64-bit field elements:
  blowup = 8, degree = 2^20
  Memory = 8 * 2^20 * 8 bytes = 64 MB (for one polynomial)

With trace of 100 columns:
  Memory = 6.4 GB just for evaluations
```

## Security Analysis

### Conjectured vs. Proven Bounds

FRI security relies on:

```
Conjectured bound (tighter):
  soundness_error ≤ rate^q

Proven bound (looser):
  soundness_error ≤ (O(1) * rate^{1/2})^q

The gap can be significant:
  rate = 0.25, q = 60
  Conjectured: 0.25^60 ≈ 2^{-120}
  Proven: (0.5)^60 ≈ 2^{-60} (half the security bits!)
```

### Conservative Parameterization

For high-security applications:

```
Use proven bounds for parameter selection
Add security margin (e.g., target 160-bit for 128-bit requirement)
Increase blowup factor (improves proven bounds)
Increase query count (directly improves security)
```

### Field Size Requirements

The base field must be large enough:

```
Field size |F| > soundness_error^{-1}

For 128-bit security: |F| > 2^128

Goldilocks field (p = 2^64 - 2^32 + 1):
  |F| = 2^64, provides at most 64 bits from field size alone
  Must rely on hash security and query count for full security

Solution: Use extension field or accumulate security from multiple sources
```

### Extension Field Usage

To increase field size cheaply:

```
Base field: F_p with |F_p| = 2^64
Extension: F_p^2 with |F_p^2| = 2^128

Challenges drawn from extension field:
- Higher security from random challenge
- Cost: Extension field arithmetic for folding verification
- Prover can work mostly in base field
```

## Optimization Strategies

### Minimize Proof Size

For smallest proofs:

```
1. Higher blowup factor (4-8) to reduce query count
2. Query count set for exact security target
3. Batched Merkle leaves (8-16 elements per leaf)
4. Optimized hash (Blake3)
5. Consider folding factor 4 for fewer layers
```

### Minimize Prover Time

For fastest proving:

```
1. Lower blowup factor (2-4) for smaller evaluation domain
2. Batch polynomial operations (NTT, hashing)
3. Parallelize across cores/GPUs
4. Stream processing for memory efficiency
5. Precompute domain and twiddle factors
```

### Minimize Verification Time

For fastest verification:

```
1. Fewer queries (balance with security)
2. Efficient hash (hardware-accelerated SHA-256 or Blake3)
3. Batch inversions for folding verification
4. Parallel query verification
5. Small final polynomial
```

### Balance for General Use

A balanced configuration:

```
Parameters:
  - Blowup factor: 8
  - Query count: 50 (approximately 100-bit security, conjectured)
  - Folding factor: 2
  - Final polynomial degree: 8
  - Hash: Blake3
  - Merkle leaf size: 8 elements

Trade-offs:
  - Moderate proof size (~200-400 KB typical)
  - Good prover performance
  - Fast verification
  - Reasonable security margin
```

## Common Configurations

### High Security Configuration

For financial applications, long-term security:

```
Blowup: 16
Queries: 80
Security: ~160-bit (proven bounds)
Folding: 2
Final degree: 4
Hash: SHA-256 or Blake2b

Proof size: Larger
Prover time: Slower
Verification: Moderate
```

### Optimized Size Configuration

For blockchain where proof size matters:

```
Blowup: 4
Queries: 50
Security: ~100-bit (conjectured)
Folding: 4
Final degree: 16
Hash: Blake3
Leaf size: 16

Proof size: Smaller
Prover time: Faster
Verification: Fast
```

### Research/Testing Configuration

For development and testing:

```
Blowup: 2
Queries: 20
Security: ~40-bit (intentionally low)
Folding: 2
Final degree: 8
Hash: Blake3

Proof size: Minimal
Prover time: Very fast
Verification: Very fast

Note: NOT for production use
```

## Parameter Validation

### Consistency Checks

Before use, validate parameters:

```
1. degree_bound is power of 2
2. domain_size = blowup * degree_bound is power of 2
3. domain_size divides field multiplicative group order
4. d_final divides degree_bound / 2^{layers}
5. query_count provides target security level
6. hash output size >= 2 * security_level
```

### Common Mistakes

Avoid these errors:

```
1. Using conjectured bounds for security-critical application
2. Forgetting extension field needs for small base fields
3. Ignoring Merkle tree security (hash collisions)
4. Not accounting for all soundness error sources
5. Mismatched parameters between prover and verifier
```

## Benchmarking Guidelines

### Measuring Prover Performance

Key metrics:

```
1. Total proving time
2. Peak memory usage
3. Time breakdown:
   - NTT/polynomial operations
   - Merkle tree construction
   - Hash computations

Test with:
  - Various polynomial degrees (2^16 to 2^24)
  - Different blowup factors
  - Real-world constraint systems
```

### Measuring Verification Performance

Key metrics:

```
1. Total verification time
2. Time breakdown:
   - Hash verification (Merkle)
   - Field arithmetic (folding)
   - Final polynomial check

Test with:
  - Various query counts
  - Different proof sizes
  - Parallel vs. sequential
```

## Key Concepts

- **Blowup factor**: Ratio of evaluation domain to polynomial degree
- **Query count**: Number of random positions verified
- **Folding factor**: Degree reduction per FRI round
- **Soundness error**: Probability of accepting invalid proof
- **Rate**: Inverse of blowup factor, affects security

## Design Considerations

### Application-Specific Tuning

Match parameters to application:

| Application | Priority | Configuration |
|-------------|----------|---------------|
| Blockchain rollup | Proof size | Moderate blowup, fewer queries |
| Financial system | Security | High blowup, many queries |
| Gaming/entertainment | Speed | Low blowup, minimal queries |
| Research prototype | Flexibility | Easy to adjust |

### Future-Proofing

Consider:
- Quantum threats (FRI is post-quantum secure)
- Improved attacks (use conservative bounds)
- Hardware advances (may enable larger parameters)
- Protocol upgrades (design for parameter flexibility)

## Related Topics

- [FRI Fundamentals](01-fri-fundamentals.md) - Protocol basics
- [Folding Algorithm](02-folding-algorithm.md) - Folding details
- [Query and Verification](03-query-and-verification.md) - Query mechanics
- [Security Analysis](../01-stark-overview/02-security-model.md) - STARK security
- [Proof Structure](../01-stark-overview/03-proof-structure.md) - Overall proof layout
