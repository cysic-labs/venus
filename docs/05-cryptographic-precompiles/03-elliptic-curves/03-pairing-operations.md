# Pairing Operations

## Overview

Pairing operations are bilinear maps between elliptic curve groups that enable advanced cryptographic protocols. A pairing takes two curve points and produces a field element, with the special property that e(aP, bQ) = e(P, Q)^(ab). This bilinearity enables applications impossible with standard elliptic curve arithmetic: BLS signatures, identity-based encryption, and most importantly for zkVMs, the verification of other zero-knowledge proofs.

Pairing operations are computationally expensive, involving operations in extension fields and complex algorithms like Miller's loop and final exponentiation. Implementing pairings as a zkVM precompile enables on-chain verification of SNARK proofs, aggregation of multiple proofs, and cross-chain bridges that verify external chain state. This document covers pairing mathematics, circuit implementation, and optimization strategies.

## Pairing Mathematics

### Bilinear Map Definition

Pairing properties:

```
Groups:
  G1: Subgroup of E(Fp)
  G2: Subgroup of E'(Fp^k) or E(Fp^k)
  GT: Multiplicative group of Fp^k

Pairing:
  e: G1 × G2 → GT

Properties:
  Bilinearity: e(aP, bQ) = e(P, Q)^(ab)
  Non-degeneracy: e(G1, G2) ≠ 1 for generators
  Computability: Efficient algorithm exists
```

### Common Pairing Curves

Pairing-friendly curves:

```
BN254 (alt_bn128):
  k = 12 (embedding degree)
  ~254-bit base field
  Used by Ethereum

BLS12-381:
  k = 12
  ~381-bit base field
  Used by many newer systems

Parameter meanings:
  k: Extension degree for pairing target
  Fp^k: Target field (large)
```

### Extension Fields

Tower of field extensions:

```
BN254 extension tower:
  Fp → Fp^2 → Fp^6 → Fp^12

Construction:
  Fp^2 = Fp[u] / (u^2 + 1)
  Fp^6 = Fp^2[v] / (v^3 - (9 + u))
  Fp^12 = Fp^6[w] / (w^2 - v)

Elements:
  Fp^2: a + bu where a, b in Fp
  Fp^12: Sum of basis elements
  Operations: Schoolbook with reductions
```

## Pairing Algorithm

### Miller's Loop

Computing the pairing:

```
Input: P in G1, Q in G2
Output: Intermediate result for pairing

Algorithm:
  f = 1 (in Fp^k)
  T = Q

  for bit in bits_of_r (high to low, skip first):
    f = f^2 * l_{T,T}(P)
    T = 2T

    if bit == 1:
      f = f * l_{T,Q}(P)
      T = T + Q

  return f

Where:
  l_{T,T}(P): Line through T, T evaluated at P
  l_{T,Q}(P): Line through T, Q evaluated at P
  r: Curve parameter
```

### Line Functions

Evaluating lines at points:

```
Tangent line (for doubling):
  l = (3*Tx^2 + a) / (2*Ty) * (x - Tx) - (y - Ty)
  Evaluated at P = (Px, Py)

Chord line (for addition):
  l = (Qy - Ty) / (Qx - Tx) * (x - Tx) - (y - Ty)
  Evaluated at P = (Px, Py)

Result in Fp^k:
  Sparse element (few nonzero coefficients)
  Efficient multiplication
```

### Final Exponentiation

Converting to GT element:

```
After Miller loop:
  f in Fp^k (not in GT yet)

Final exponentiation:
  e(P, Q) = f^((p^k - 1) / r)

Decomposition:
  (p^k - 1) / r = (p^k - 1) / Φ_k(p) * Φ_k(p) / r

Easy part:
  f^(p^(k/2) - 1) - cheap Frobenius
  f^((p^(k/2) + 1) / ...) - more Frobenius

Hard part:
  Exponentiation by curve-specific factor
  Multi-exponentiation techniques
```

## Circuit Implementation

### Extension Field Arithmetic

Constraining Fp^k operations:

```
Fp^2 multiplication:
  (a + bu)(c + du) = (ac - bd) + (ad + bc)u

Constraints:
  e = a * c
  f = b * d
  g = (a + b) * (c + d)
  real = e - f
  imag = g - e - f

Higher extensions:
  Build on Fp^2 operations
  Karatsuba for efficiency
```

### Miller Loop Constraints

Per-iteration constraints:

```
Doubling step:
  T' = 2T (point doubling in G2)
  l_double = line function value
  f' = f^2 * l_double

Addition step (when bit = 1):
  T' = T + Q (point addition)
  l_add = line function value
  f' = f * l_add

Constraints per iteration:
  Point operation in G2 (extension field)
  Line evaluation (sparse Fp^12)
  Fp^12 multiplication
```

### Final Exponentiation Constraints

Constraining exponentiation:

```
Easy part:
  Frobenius maps: f^(p^i)
  Computed via coefficient permutation
  Low constraint cost

Hard part:
  Multi-exponentiation
  Chain of squarings and multiplications
  Most expensive part

Total constraints:
  ~100,000-500,000 for one pairing
```

## Pairing Check

### Verification Equation

Common usage pattern:

```
Pairing check (not full pairing):
  e(P1, Q1) * e(P2, Q2) * ... * e(Pn, Qn) = 1

Or equivalently:
  e(P1, Q1) = e(P2, Q2)

Product of pairings:
  Miller loops can be combined
  Single final exponentiation

Efficiency:
  Multiple pairings cheaper than sum of individuals
```

### SNARK Verification

Verifying Groth16 proofs:

```
Groth16 verification:
  e(A, B) = e(α, β) * e(L, γ) * e(C, δ)

Where:
  (A, B, C): Proof elements
  (α, β, γ, δ): Verification key
  L: Public input linear combination

Pairing check:
  e(A, B) * e(-α, β) * e(-L, γ) * e(-C, δ) = 1

4 pairings, combined for efficiency.
```

### BLS Signature Verification

Aggregate signatures:

```
BLS signature verification:
  e(σ, G2) = e(H(m), pk)

Where:
  σ: Signature in G1
  pk: Public key in G2
  H(m): Hash-to-curve of message

Aggregate verification:
  e(σ_agg, G2) = Π e(H(m_i), pk_i)

Single signature in G1, multiple message/key pairs.
```

## Optimization Techniques

### Sparse Multiplication

Exploiting structure:

```
Line function result is sparse:
  Only certain Fp^12 coefficients nonzero

Sparse × dense multiplication:
  Skip zero coefficient products
  Reduce from ~54 to ~13 Fp^2 muls

Significant savings:
  Each Miller loop iteration benefits
```

### Precomputation

Fixed-point optimizations:

```
For fixed Q (common in SNARK verify):
  Precompute all line coefficients
  Store as part of verification key

Precomputed pairing:
  Miller loop with lookups
  No G2 arithmetic during verification
```

### Multi-Pairing

Combining multiple pairings:

```
Instead of:
  f1 = miller(P1, Q1)
  f2 = miller(P2, Q2)
  result = final_exp(f1 * f2)

Compute:
  Combined miller loop
  Single final exponentiation

Final exponentiation dominates:
  Save ~50% for 2 pairings
  More savings for more pairings
```

## Circuit Organization

### Pairing Machine Structure

Precompile layout:

```
Input:
  G1 points: P1, P2, ..., Pn
  G2 points: Q1, Q2, ..., Qn

Processing:
  Miller loop for each pair
  Combine intermediate results
  Final exponentiation

Output:
  Pairing check result (1 = valid, 0 = invalid)
```

### Column Layout

Trace columns:

```
G1 point columns:
  P_x, P_y (possibly limbed)

G2 point columns:
  Q_x0, Q_x1, Q_y0, Q_y1 (Fp^2 coordinates)

Miller loop columns:
  f_coefficients (Fp^12 as 12 Fp elements)
  T_coordinates (current G2 point)
  line_coefficients

Control columns:
  loop_idx, bit, step_type
```

### Row Structure

Per-step layout:

```
Option 1: One row per Miller step
  ~256-512 rows per pairing
  Wide rows for Fp^12 state

Option 2: Multiple rows per step
  Decompose complex operations
  Narrower rows

Final exponentiation:
  Additional rows for exponentiation chain
  Depends on curve and optimization
```

## Key Concepts

- **Bilinear pairing**: Map from G1 × G2 to GT with bilinearity
- **Miller's loop**: Core pairing computation algorithm
- **Final exponentiation**: Converting Miller output to GT
- **Extension fields**: Fp^k arithmetic for pairing target
- **Pairing check**: Verifying product of pairings equals 1

## Design Considerations

### Curve Selection

| BN254 | BLS12-381 |
|-------|-----------|
| Smaller field | Larger field |
| Faster operations | Slower operations |
| Lower security margin | Higher security |
| Ethereum compatible | Modern standard |

### Implementation Trade-offs

| Full Pairing | Pairing Check Only |
|--------------|-------------------|
| Outputs GT element | Outputs boolean |
| Can chain operations | Single check |
| More expensive | Optimized |
| Flexible | Specific use case |

## Related Topics

- [Curve Arithmetic](01-curve-arithmetic.md) - Underlying EC operations
- [Signature Verification](02-signature-verification.md) - BLS signatures
- [Proof Recursion](../../03-proof-management/03-proof-pipeline/02-proof-recursion.md) - SNARK verification
- [Non-Native Arithmetic](01-curve-arithmetic.md#non-native-arithmetic) - Extension field implementation
