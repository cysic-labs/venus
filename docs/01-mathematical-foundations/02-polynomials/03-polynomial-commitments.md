# Polynomial Commitments

## Overview

Polynomial commitment schemes are cryptographic protocols that allow a prover to commit to a polynomial and later prove evaluations of that polynomial at chosen points. They are foundational to modern zero-knowledge proof systems, serving as the bridge between algebraic constraints and cryptographic proofs.

A polynomial commitment binds the prover to a specific polynomial without revealing it. Later, the prover can open the commitment at any point, proving that a particular value is indeed the polynomial's evaluation at that point. The verifier can check this opening efficiently without knowing the full polynomial.

This document covers the concepts, constructions, and trade-offs of polynomial commitment schemes used in zkVM implementations.

## The Commitment Paradigm

### Definition

A polynomial commitment scheme consists of three algorithms:

**Commit(P)**: Given a polynomial P, output a commitment C that binds the prover to P.

**Open(P, z, C)**: Given polynomial P, point z, and commitment C, output a proof pi that P(z) = y for some y.

**Verify(C, z, y, pi)**: Given commitment C, point z, claimed value y, and proof pi, return true if P(z) = y where P is the committed polynomial.

### Security Properties

**Binding**: After committing, the prover cannot open to a different polynomial. Formally, it's computationally infeasible to find two different polynomials that produce the same commitment.

**Hiding** (optional): The commitment reveals nothing about the polynomial. This is necessary for zero-knowledge but not for soundness.

**Evaluation Binding**: The prover cannot produce valid opening proofs for incorrect evaluations.

### Efficiency Metrics

| Metric | Description |
|--------|-------------|
| Commitment size | Space to store/transmit commitment |
| Opening proof size | Space for evaluation proof |
| Commit time | Prover computation for commitment |
| Open time | Prover computation for opening |
| Verify time | Verifier computation to check opening |

## FRI-Based Commitments

### Overview

FRI (Fast Reed-Solomon Interactive Oracle Proof) provides polynomial commitments using only hash functions. It's the foundation of STARK proofs and is transparent (no trusted setup).

### Core Idea

The key insight is that low-degree polynomials have specific structure when evaluated on multiplicative subgroups. FRI proves that a committed function is close to a low-degree polynomial through iterative "folding."

### Commitment Phase

To commit to polynomial P(X) of degree < n:

1. Evaluate P on a domain D of size m > n (typically m = 2n to 8n)
2. Build a Merkle tree over the evaluations
3. The commitment is the Merkle root

```
P(X) -> [P(d_0), P(d_1), ..., P(d_{m-1})] -> Merkle_Tree -> Root
```

### FRI Folding

The core of FRI is the folding operation. Given polynomial P(X) and random challenge alpha:

```
P(X) = P_even(X^2) + X * P_odd(X^2)

Folded polynomial: P'(X) = P_even(X) + alpha * P_odd(X)
```

The folded polynomial has half the degree.

### FRI Protocol

1. **Commit phase**: Build Merkle tree for initial polynomial evaluations
2. **Folding rounds**: For each round:
   - Receive random challenge alpha
   - Compute folded polynomial
   - Commit to folded evaluations
3. **Final round**: When degree is small, send coefficients directly
4. **Query phase**: Verifier makes random queries; prover provides Merkle paths and consistency proofs

### Opening a Point

To prove P(z) = y:

1. Quotient approach: Compute Q(X) = (P(X) - y) / (X - z)
2. Prove Q is a polynomial (via FRI)
3. If Q is a polynomial, then P(z) = y (since division is exact)

### Properties of FRI Commitments

| Property | FRI |
|----------|-----|
| Trusted setup | None required |
| Post-quantum | Yes (hash-based) |
| Commitment size | ~32 bytes (hash) |
| Opening proof size | O(log^2 n) hashes |
| Verify time | O(log^2 n) hash calls |

## KZG Commitments

### Overview

Kate-Zaverucha-Goldberg (KZG) commitments use elliptic curve pairings to achieve extremely compact proofs. A single group element commits to a polynomial, and a single group element proves an evaluation.

### Setup

KZG requires a structured reference string (SRS) from a trusted setup:

```
SRS = (G, tau*G, tau^2*G, ..., tau^n*G, H, tau*H)
```

where:
- G, H are generators of pairing-friendly groups
- tau is a secret that must be destroyed
- n is the maximum polynomial degree

### Commitment

To commit to P(X) = sum_{i=0}^{d} a_i * X^i:

```
C = sum_{i=0}^{d} a_i * (tau^i * G) = P(tau) * G
```

The commitment is a single elliptic curve point.

### Opening

To prove P(z) = y, compute the quotient polynomial:

```
Q(X) = (P(X) - y) / (X - z)
```

This is exact if P(z) = y. The opening proof is:

```
pi = Q(tau) * G = sum_{i} q_i * (tau^i * G)
```

### Verification

The verifier checks using a pairing:

```
e(C - y*G, H) = e(pi, tau*H - z*H)
```

This equation holds if and only if P(z) = y.

### Properties of KZG Commitments

| Property | KZG |
|----------|-----|
| Trusted setup | Required |
| Post-quantum | No |
| Commitment size | 48-96 bytes (1 group element) |
| Opening proof size | 48-96 bytes (1 group element) |
| Verify time | 2 pairings |

## Comparison: FRI vs KZG

### When to Use FRI

- No trusted setup available or acceptable
- Post-quantum security required
- Large batch openings (amortized cost)
- STARK-based systems

### When to Use KZG

- Minimal proof size critical (e.g., on-chain verification)
- Trusted setup is acceptable
- Single-point openings dominate
- SNARK-based systems or STARK-to-SNARK wrapping

### Quantitative Comparison

For a polynomial of degree d = 2^20:

| Metric | FRI | KZG |
|--------|-----|-----|
| Setup | None | O(d) group elements |
| Commitment | 32 bytes | 48 bytes |
| Single opening | ~100 KB | 48 bytes |
| Batch n openings | ~100 KB (amortized) | 48n bytes |
| Verify (single) | ~100 ms | ~5 ms |

## Batch Openings

### Motivation

Often, many polynomials need opening at the same point, or one polynomial at many points. Batching amortizes costs.

### Same Point, Multiple Polynomials

To open P_1, P_2, ..., P_k at point z:

1. Verifier provides random challenge gamma
2. Prover computes combined polynomial: B = P_1 + gamma*P_2 + gamma^2*P_3 + ...
3. Open B at z with a single proof
4. Verifier checks: B(z) = P_1(z) + gamma*P_2(z) + ...

One opening proves k evaluations.

### Multiple Points, One Polynomial

To open P at points z_1, z_2, ..., z_k:

1. Compute vanishing polynomial Z(X) = (X - z_1)(X - z_2)...(X - z_k)
2. Compute quotient Q(X) = (P(X) - I(X)) / Z(X) where I interpolates the claimed values
3. Prove Q is a polynomial

### Batch Opening in FRI

FRI naturally supports batching:
- Multiple polynomials share the same Merkle tree structure
- Query responses include all relevant evaluations
- Verification checks are combined

## Commitment Composition

### Multi-Polynomial Commitments

Commit to multiple polynomials with a single commitment:

```
C = Commit(P_1) + r*Commit(P_2) + r^2*Commit(P_3) + ...
```

where r is a random challenge. This creates a commitment to the "virtual" polynomial:

```
P_batch = P_1 + r*P_2 + r^2*P_3 + ...
```

### Tree-Based Composition

For many polynomials, build a Merkle tree of individual commitments:

```
         Root
        /    \
    Hash      Hash
    /  \      /  \
  C_1  C_2  C_3  C_4
```

Opening any subset requires O(log k) path elements plus individual opening proofs.

## Implementation Considerations

### Commitment Storage

For large polynomial counts:
- Store commitments in batches
- Use lazy evaluation where possible
- Consider commitment compression techniques

### Parallelization

Polynomial commitment operations parallelize well:
- **Commit**: Evaluations and Merkle tree construction
- **Open**: Quotient polynomial computation
- **Verify**: Independent query checks

### Memory Management

FRI proofs can be large:
- Stream proof generation to avoid memory spikes
- Compress Merkle paths (path pruning)
- Use memory-mapped files for very large proofs

### Fiat-Shamir Considerations

When making interactive protocols non-interactive:
- Hash all prior messages to generate challenges
- Use domain separation for different challenge types
- Include commitment values in the transcript

## Applications in zkVMs

### Trace Commitment

The execution trace is committed using polynomial commitments:
- Each trace column becomes a polynomial
- Commitment binds prover to trace values
- Later openings prove specific trace values

### Constraint Satisfaction

To prove constraints hold:
1. Commit to constraint polynomials
2. Prove they're divisible by vanishing polynomial
3. Quotient polynomial commitment demonstrates this

### FRI in STARK Proofs

FRI serves dual purposes:
1. Commits to trace and constraint polynomials
2. Proves degree bounds (low-degree test)

### Recursive Proof Composition

When verifying proofs within proofs:
- Inner proof commitments are inputs to outer proof
- Commitment schemes must be recursion-friendly
- KZG's small size helps with in-circuit verification

## Key Concepts

- **Polynomial commitment**: Cryptographic binding to a polynomial
- **Opening**: Proof that committed polynomial evaluates to a specific value
- **FRI**: Hash-based commitment scheme with no trusted setup
- **KZG**: Pairing-based commitment with minimal proof size
- **Batching**: Amortizing costs over multiple openings
- **Composition**: Combining multiple commitments efficiently

## Design Considerations

### Security vs Efficiency

| Approach | Security Assumption | Efficiency |
|----------|---------------------|------------|
| FRI | Hash collision resistance | Large proofs |
| KZG | Discrete log + pairings | Small proofs |
| Bulletproofs | Discrete log | Medium proofs |

### Degree Bounds

The commitment scheme must handle the expected polynomial degrees:
- FRI: Degree affects number of folding rounds
- KZG: SRS must be generated for max degree

### Verification Context

Where will proofs be verified?
- On-chain: KZG or compressed FRI preferred
- Client-side: FRI acceptable
- Recursive: KZG easier in circuits

### Prover Resources

Commitment computation can be expensive:
- FRI: NTT-dominated
- KZG: Multi-scalar multiplication (MSM)
- Both benefit from parallelization

## Related Topics

- [FRI Fundamentals](../../02-stark-proving-system/03-fri-protocol/01-fri-fundamentals.md) - Detailed FRI protocol
- [Polynomial Arithmetic](01-polynomial-arithmetic.md) - Operations on committed polynomials
- [NTT and FFT](02-ntt-and-fft.md) - Efficient evaluation for commitments
- [Pairing Curves](../04-elliptic-curves/02-pairing-curves.md) - Curves for KZG
- [Trace Commitment](../../02-stark-proving-system/04-proof-generation/02-trace-commitment.md) - Committing execution traces
