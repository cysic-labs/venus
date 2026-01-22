# FRI Fundamentals

## Overview

Fast Reed-Solomon Interactive Oracle Proof (FRI) is the core protocol that enables efficient verification of polynomial degree bounds in STARK proof systems. FRI transforms the problem of verifying that a function is a low-degree polynomial into a series of consistency checks between successively smaller polynomials. This iterative approach achieves logarithmic verification complexity while requiring no trusted setup and maintaining post-quantum security.

The fundamental insight behind FRI is that a low-degree polynomial can be "folded" into a polynomial of half the degree using a random challenge. By repeatedly folding and checking consistency, the verifier becomes convinced that the original function was indeed a low-degree polynomial. If the prover attempts to cheat with a function that deviates significantly from any low-degree polynomial, the folding process will expose inconsistencies with high probability.

FRI serves as the polynomial commitment scheme in STARK proofs, replacing pairing-based schemes like KZG. While FRI produces larger proofs than pairing-based alternatives, it offers transparency (no trusted setup) and security against quantum adversaries.

## The Low-Degree Testing Problem

### Problem Statement

Given oracle access to a function f: D -> F where D is a finite domain and F is a finite field, determine whether f agrees with a polynomial of degree less than d on most of D.

```
Input: Oracle access to f, degree bound d, domain D
Output: Accept if f is close to some polynomial P with deg(P) < d
        Reject otherwise
```

### Why Low-Degree Testing Matters

In STARK proofs, the prover commits to polynomials representing:
- Execution trace columns
- Quotient polynomials (proving constraint satisfaction)
- Composition polynomials (batched constraints)

The verifier must confirm these commitments represent actual low-degree polynomials, not arbitrary functions. Without this guarantee, a cheating prover could commit to any function and claim it represents a valid computation.

### Reed-Solomon Proximity

The distance between a function and the set of low-degree polynomials is measured by the fraction of points where they differ:

```
delta(f, P) = |{x in D : f(x) != P(x)}| / |D|
```

A function f is delta-close to degree-d if there exists a polynomial P of degree < d such that delta(f, P) <= delta.

### Rate and Distance

For a domain D of size n and polynomials of degree < k:

```
Rate = k / n (fraction of domain "used" by polynomial degree)
Distance = 1 - Rate (maximum tolerable error fraction)
```

Higher rate means more efficient encoding but less error tolerance.

## FRI Protocol Structure

### High-Level Flow

The FRI protocol proceeds in rounds, each halving the effective polynomial degree:

```
Round 0: Prover commits to polynomial P_0 of degree < d
         Verifier sends random challenge alpha_0

Round 1: Prover computes folded polynomial P_1 of degree < d/2
         Prover commits to P_1
         Verifier sends random challenge alpha_1

Round 2: Prover computes folded polynomial P_2 of degree < d/4
         Prover commits to P_2
         ...

Final: Prover sends constant polynomial directly
       Verifier performs consistency checks
```

### Commitment Phase

In each round, the prover commits to polynomial evaluations using Merkle trees:

```
1. Evaluate polynomial P_i on evaluation domain D_i
2. Group evaluations into leaves (possibly multiple per leaf)
3. Build Merkle tree over leaves
4. Send Merkle root to verifier
```

The Merkle root serves as a binding commitment that can later be opened at specific positions.

### Challenge Generation

Challenges are generated via Fiat-Shamir, hashing the transcript of all previous commitments:

```
alpha_i = Hash(root_0 || root_1 || ... || root_i || domain_separator)
```

This makes the protocol non-interactive while maintaining soundness in the random oracle model.

### Query Phase

After all commitments, the verifier checks consistency at random positions:

```
1. Sample random query position x in initial domain
2. Request openings at x and related positions in all committed layers
3. Verify Merkle proofs for all openings
4. Check folding relations between layers
```

Multiple independent queries reduce soundness error multiplicatively.

## Domain Structure

### Evaluation Domains

FRI operates over carefully chosen domains that support efficient folding:

```
Initial domain D_0: Size n = 2^k for some k
Each folding: D_{i+1} has size |D_i| / 2
Final domain: Small constant size (or single element)
```

### Multiplicative Subgroups

Domains are typically multiplicative subgroups of F*:

```
D = {g^0, g^1, g^2, ..., g^(n-1)}

where g is a generator of order n in F*
```

This structure enables:
- Efficient FFT/NTT for polynomial operations
- Natural folding where D_{i+1} = {x^2 : x in D_i}

### Coset Structure

To separate trace domain from evaluation domain, use cosets:

```
Trace domain: H = {omega^0, omega^1, ..., omega^(n-1)}
Evaluation domain: gamma * H = {gamma*omega^0, gamma*omega^1, ...}
```

where gamma is chosen so the coset doesn't intersect H.

### Domain Folding

When folding polynomial P(X) with challenge alpha:

```
Original domain D: {d_0, d_1, d_2, ..., d_{n-1}}
Folded domain D': {d_0^2, d_1^2, ...} = {e_0, e_1, ..., e_{n/2-1}}
```

Each element in D' corresponds to two elements in D (the square roots).

## Mathematical Foundation

### Polynomial Splitting

Any polynomial P(X) can be uniquely decomposed:

```
P(X) = P_even(X^2) + X * P_odd(X^2)
```

where:
- P_even contains coefficients of even powers
- P_odd contains coefficients of odd powers
- Both have degree < deg(P)/2

### Folding Formula

Given random challenge alpha, the folded polynomial is:

```
P'(Y) = P_even(Y) + alpha * P_odd(Y)
```

This polynomial has degree < deg(P)/2 and is defined over Y = X^2.

### Folding Correctness

For any x in the original domain with y = x^2:

```
P(x) = P_even(y) + x * P_odd(y)
P(-x) = P_even(y) - x * P_odd(y)

Therefore:
P_even(y) = (P(x) + P(-x)) / 2
P_odd(y) = (P(x) - P(-x)) / (2x)

P'(y) = (P(x) + P(-x))/2 + alpha * (P(x) - P(-x))/(2x)
      = ((1 + alpha/x) * P(x) + (1 - alpha/x) * P(-x)) / 2
```

### Why Folding Works

If P is truly degree < d, then P' is degree < d/2.

If f is not degree < d but prover claims folded polynomial P' of degree < d/2:
- At random challenge alpha, P' must be consistent with f at queried points
- But incorrect folding means P' won't match the formula at many points
- With enough queries, inconsistency is detected with high probability

## Soundness Analysis

### Proximity Gap

The FRI proximity gap theorem states:

```
If f is delta-far from all polynomials of degree < d,
then after folding with random alpha,
f' is delta'-far from all polynomials of degree < d/2
where delta' >= delta / 2 (approximately)
```

### Error Amplification

Each query catches a cheating prover with probability related to delta:

```
Pr[query catches cheater] >= delta * (1 - rate)
```

With q independent queries:

```
Pr[cheater escapes all queries] <= (1 - delta * (1 - rate))^q
```

### Overall Soundness

The total soundness error combines:
- Error from random challenge selection
- Error from random query positions
- Accumulation across folding rounds

```
soundness_error <= (rate)^q + additional_terms
```

For typical parameters (rate = 1/2, q = 30), soundness error < 2^(-80).

### Batching and Combination

When multiple polynomials need FRI proofs, they can be batched:

```
Combined(X) = P_0(X) + beta * P_1(X) + beta^2 * P_2(X) + ...
```

A single FRI proof for Combined proves all individual polynomials have bounded degree.

## Relation to STARK

### Role in Proof Generation

FRI appears in STARK proofs at several points:

```
1. Commit to trace polynomials T_i(X)
2. Compute composition polynomial C(X) from constraints
3. Compute quotient Q(X) = C(X) / Z(X)
4. Use FRI to prove deg(Q) is bounded (i.e., C vanishes on trace domain)
5. Use FRI queries to verify consistency at random points
```

### DEEP-FRI Enhancement

DEEP (Domain Extension for Eliminating Pretenders) strengthens FRI:

```
1. Sample random point z outside the trace domain
2. Evaluate trace polynomials at z
3. Include these evaluations in composition
4. Build FRI polynomial incorporating z-evaluations
```

This prevents attacks where prover commits to wrong polynomial but gets lucky on in-domain queries.

### Polynomial Commitment Scheme

FRI implements a polynomial commitment scheme:

```
Commit(P): Build Merkle tree of P's evaluations, return root
Open(P, z): Provide FRI proof that P(z) = v for claimed v
Verify(root, z, v, proof): Check FRI proof and Merkle openings
```

## Comparison with Other Approaches

### FRI vs. KZG

| Property | FRI | KZG |
|----------|-----|-----|
| Proof size | O(log^2 d) | O(1) |
| Verification time | O(log^2 d) | O(1) with pairing |
| Trusted setup | No | Yes |
| Post-quantum | Yes | No |
| Prover time | O(d log d) | O(d log d) |

### FRI vs. IPA

Inner Product Argument (IPA) is another transparent option:

| Property | FRI | IPA |
|----------|-----|-----|
| Proof size | O(log^2 d) | O(log d) |
| Verification | O(log^2 d) | O(d) |
| Assumptions | Hash functions | Discrete log |

FRI offers faster verification at the cost of larger proofs.

## Key Concepts

- **FRI**: Protocol for proving a committed function is close to a low-degree polynomial
- **Folding**: Combining polynomial components with random challenge to halve degree
- **Proximity**: Measure of distance between function and polynomial space
- **Query**: Random position where verifier checks folding consistency
- **Soundness**: Probability bound on accepting invalid proofs

## Design Considerations

### Parameter Selection

Balancing efficiency and security:
- More folding rounds: Smaller final polynomial but more commitments
- More queries: Higher security but larger proofs
- Higher blowup: Better distance but larger evaluation domain

### Implementation Trade-offs

- Batch operations for GPU efficiency
- Memory-efficient streaming for large polynomials
- Parallelization across independent queries

## Related Topics

- [Folding Algorithm](02-folding-algorithm.md) - Detailed folding mechanics
- [Query and Verification](03-query-and-verification.md) - Query protocol details
- [FRI Parameters](04-fri-parameters.md) - Parameter selection guide
- [STARK Introduction](../01-stark-overview/01-stark-introduction.md) - STARK context
- [Polynomial Commitments](../../01-mathematical-foundations/03-polynomial-commitments/01-polynomial-commitment-schemes.md) - Commitment foundations
