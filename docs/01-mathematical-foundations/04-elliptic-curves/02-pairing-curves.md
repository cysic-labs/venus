# Pairing-Friendly Elliptic Curves

## Overview

Pairing-friendly elliptic curves support a special bilinear map called a pairing, which maps pairs of curve points to elements in an extension field. This mathematical structure enables cryptographic constructions impossible with ordinary elliptic curves, including identity-based encryption, short signatures, and importantly for zkVMs, succinct non-interactive zero-knowledge proofs (SNARKs).

While STARK-based zkVMs don't fundamentally require pairings, they become essential for STARK-to-SNARK proof wrapping, recursive proof composition, and verifying certain cryptographic primitives. Understanding pairings is necessary for implementing precompiles that handle pairing checks.

This document covers the theory of pairings, common pairing-friendly curves, and their role in zero-knowledge proof systems.

## Bilinear Pairings

### Definition

A pairing is a bilinear map:

```
e: G1 x G2 -> GT
```

where G1, G2 are elliptic curve groups and GT is a multiplicative group in an extension field.

### Bilinearity Property

The defining property of pairings is bilinearity:

```
e(a*P, b*Q) = e(P, Q)^(a*b)
```

for all points P in G1, Q in G2, and scalars a, b.

Equivalently:
```
e(P1 + P2, Q) = e(P1, Q) * e(P2, Q)
e(P, Q1 + Q2) = e(P, Q1) * e(P, Q2)
```

### Non-Degeneracy

A pairing must be non-degenerate:
```
If e(P, Q) = 1 for all Q, then P = O (the identity)
```

This ensures the pairing carries meaningful information.

### Computability

The pairing must be efficiently computable. This is non-trivial - random elliptic curves don't have efficient pairings. Special "pairing-friendly" curves are constructed for this purpose.

## Types of Pairings

### Weil Pairing

The Weil pairing is defined for points in E[n] (n-torsion points):

```
e_n: E[n] x E[n] -> mu_n
```

where mu_n is the group of n-th roots of unity in the algebraic closure.

Properties:
- Alternating: e(P, P) = 1
- Non-degenerate on E[n]

### Tate Pairing

The Tate pairing is more commonly used in cryptography:

```
t_n: E[n] x E(F_{p^k}) / n*E(F_{p^k}) -> F_{p^k}* / (F_{p^k}*)^n
```

After final exponentiation to a unique representative:

```
e(P, Q) = t_n(P, Q)^((p^k - 1)/n)
```

### Ate Pairing

The Ate pairing is an optimization of the Tate pairing:
- Shorter Miller loop
- Faster computation
- Same cryptographic properties

Most implementations use variants of the Ate pairing.

## Pairing-Friendly Curve Construction

### Embedding Degree

The embedding degree k is the smallest positive integer such that:

```
n | (p^k - 1)
```

where n is the group order and p is the field characteristic.

For cryptographic pairings:
- k must be small enough for efficient computation
- k must be large enough for security in GT

### Curve Families

**BN (Barreto-Naehrig) curves**: k = 12
- Designed for 128-bit security (though recent analysis suggests ~100 bits)
- BN254 widely used in Ethereum

**BLS (Barreto-Lynn-Scott) curves**: k = 12
- BLS12-381 provides 128-bit security
- Used in newer protocols (Ethereum 2.0, Zcash Sapling)

**KSS curves**: k = 16, 18
- Higher embedding degrees for higher security

### Security Considerations

Security of pairing-based cryptography rests on:
1. Discrete log in G1 and G2 (ECDLP)
2. Discrete log in GT (finite field DLP)

The embedding degree k determines GT's size: |GT| ~ p^k. Larger k means larger GT and better security against index calculus attacks in GT.

## BN254 Curve

### Parameters

BN254 (also called alt_bn128 or bn256) is defined over F_p where:

```
p = 21888242871839275222246405745257275088696311157297823662689037894645226208583
```

### Group Structure

**G1**: Points on E(F_p) where E: y^2 = x^3 + 3
- Generator G1 specified in the standard
- Order r (large prime)

**G2**: Points on E'(F_{p^2}) (twist of E)
- Coordinates in quadratic extension F_{p^2}
- Same order r

**GT**: Subgroup of F_{p^12}*
- Order r

### Pairing

The optimal Ate pairing maps:
```
e: G1 x G2 -> GT
```

Pairing computation involves:
1. Miller loop: O(log r) curve operations
2. Final exponentiation: F_{p^12} arithmetic

### Use in Ethereum

Ethereum's precompiles (EIP-196, EIP-197) support:
- BN254 point addition (address 0x06)
- BN254 scalar multiplication (address 0x07)
- BN254 pairing check (address 0x08)

## BLS12-381 Curve

### Parameters

BLS12-381 is defined over F_p where:

```
p = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
```

This is a 381-bit prime.

### Groups

**G1**: Points on E(F_p) where E: y^2 = x^3 + 4

**G2**: Points on E'(F_{p^2}) (sextic twist)

**GT**: Subgroup of F_{p^12}*

### Security

BLS12-381 provides approximately:
- 128 bits security in G1, G2 (ECDLP)
- 128 bits security in GT (DLP in F_{p^12})

This makes it more future-proof than BN254.

### Adoption

Used in:
- Ethereum 2.0 consensus layer
- Zcash Sapling
- Filecoin
- Many newer protocols

## Miller's Algorithm

### Overview

Miller's algorithm computes the Tate (or Ate) pairing through iterative line function evaluations.

### Line Functions

For points P, Q, R on the curve, the line function l_{P,Q}(R) evaluates the line through P and Q at point R.

### Algorithm Structure

```python
def miller_loop(P, Q, r):
    # r is the order, in binary
    f = 1  # Accumulator in F_{p^k}
    T = P  # Running point

    for bit in binary(r)[1:]:  # Skip leading 1
        # Double step
        f = f * f * line_function(T, T, Q)
        T = 2 * T

        if bit == 1:
            # Add step
            f = f * line_function(T, P, Q)
            T = T + P

    return f
```

### Ate Pairing Optimization

The Ate pairing uses a shorter loop:
- Loop length is |t - 1| where t is the trace of Frobenius
- For BN curves, this is roughly p^(1/4) instead of p
- Significant speedup over basic Tate

## Final Exponentiation

### Purpose

The Miller loop output is not in the correct subgroup of F_{p^k}*. Final exponentiation maps it to the r-th roots of unity.

### Computation

```
e(P, Q) = f^((p^k - 1) / r)
```

where f is the Miller loop output.

### Optimization

The exponent (p^k - 1)/r factors into:
- Easy part: (p^k - 1) / phi_k(p) using Frobenius
- Hard part: phi_k(p) / r using specialized addition chains

For k = 12:
```
(p^12 - 1) / r = (p^6 - 1) * (p^2 + 1) * (p^4 - p^2 + 1) / r
```

## Applications in Zero-Knowledge Proofs

### Groth16 Verification

The Groth16 SNARK verification checks:

```
e(A, B) = e(alpha, beta) * e(L, gamma) * e(C, delta)
```

where A, B, C are proof elements and alpha, beta, gamma, delta are verification key elements.

This single pairing equation verifies the entire SNARK.

### KZG Polynomial Commitments

KZG commitments use pairings for verification:

```
e(C - y*G1, G2) = e(pi, tau*G2 - z*G2)
```

This checks that polynomial P satisfies P(z) = y.

### SNARK Aggregation

Multiple SNARKs can be aggregated using pairing-based techniques, reducing verification cost.

### STARK-to-SNARK Wrapping

A STARK proof can be verified inside a SNARK circuit:
1. STARK verifier becomes the SNARK statement
2. SNARK proof is compact (constant size)
3. On-chain verification uses pairing checks

## Pairing Computation in zkVMs

### As a Precompile

zkVMs typically provide pairing as a precompile because:
- Native pairing is complex (many field operations)
- Proving pairing in-circuit is extremely expensive
- Precompile provides efficient verification

### Constraint Cost

Representing a BN254 pairing in constraints:
- Without precompile: ~1,000,000+ constraints
- With precompile: ~100-1000 constraints (just for input/output handling)

### Input Validation

Pairing precompiles must validate:
- Points are on the correct curve
- Points are in the correct subgroup
- Scalars are within range

### Batch Pairing

Multiple pairing checks can be batched:

```
e(P1, Q1) * e(P2, Q2) * ... * e(Pn, Qn) = 1
```

This uses a single Miller loop with multiple accumulations, then one final exponentiation.

## Key Concepts

- **Bilinear pairing**: Map e(P, Q) with e(aP, bQ) = e(P, Q)^(ab)
- **Embedding degree**: Determines extension field size for GT
- **G1, G2, GT**: Three groups related by the pairing
- **Miller's algorithm**: Iterative computation of pairing
- **Final exponentiation**: Projects to correct subgroup
- **BN254, BLS12-381**: Common pairing-friendly curves

## Design Considerations

### Curve Selection

| Curve | Security | Performance | Adoption |
|-------|----------|-------------|----------|
| BN254 | ~100 bits | Faster | Ethereum, legacy |
| BLS12-381 | 128 bits | Slower | Modern protocols |

### Implementation Complexity

Pairing implementation requires:
- Extension field arithmetic (F_{p^2}, F_{p^6}, F_{p^12})
- Twist curve operations
- Miller loop with line functions
- Optimized final exponentiation

### Precompile Design

When designing pairing precompiles:
- Define clear input/output formats
- Handle edge cases (identity points, invalid inputs)
- Optimize for common use cases (single pairing, batch pairing)
- Consider gas/constraint costs

### Security Margins

Recent cryptanalysis has improved attacks on BN254:
- Tower NFS attacks reduce effective security
- Consider BLS12-381 for long-term security
- Monitor cryptographic literature for updates

## Related Topics

- [Curve Arithmetic](01-curve-arithmetic.md) - Basic elliptic curve operations
- [Extension Fields](../01-finite-fields/03-extension-fields.md) - Field extensions for GT
- [BN254 Operations](../../05-cryptographic-precompiles/04-elliptic-curve-precompiles/02-bn254-operations.md) - BN254 precompile design
- [Polynomial Commitments](../02-polynomials/03-polynomial-commitments.md) - KZG uses pairings
- [Recursive Proving](../../03-proof-management/03-recursion/01-recursive-proving.md) - SNARK wrapping of STARKs
