# BN254 Operations

## Overview

BN254 (also known as alt_bn128 or bn128) is a pairing-friendly elliptic curve widely used in Ethereum for precompiles supporting zkSNARK verification. The curve enables efficient bilinear pairings, which are essential for many zero-knowledge proof systems. The zkVM must support BN254 operations to enable verification of external proofs and pairing-based cryptographic protocols.

BN254 consists of two groups: G1 (points on the base curve) and G2 (points on a twisted curve over an extension field). Pairing operations map pairs of points (one from each group) to elements of a target group GT. These operations require field arithmetic in both the base field and its extensions.

This document covers BN254 curve structure, G1 and G2 operations, pairing computation, and constraint considerations.

## Curve Parameters

### Base Field

BN254 base field:

```
Field prime:
  p = 21888242871839275222246405745257275088696311157297823662689037894645226208583
  254-bit prime

Field structure:
  F_p - base field
  F_p^2 - quadratic extension for G2
  F_p^12 - extension for pairing target
```

### Curve Equation

G1 curve:

```
Equation: y^2 = x^3 + 3 (mod p)

Generator G1:
  x = 1
  y = 2
```

### G2 Curve

Twisted curve for G2:

```
Over F_p^2:
  Twist: y^2 = x^3 + 3/(9+i)
  Where i^2 = -1 in F_p^2

Generator G2:
  More complex coordinates
  In extension field
```

### Curve Order

Group orders:

```
Order n:
  n = 21888242871839275222246405745257275088548364400416034343698204186575808495617
  254-bit value

Both G1 and G2:
  Have order n
  Same for pairing
```

## Extension Fields

### F_p^2 Construction

Quadratic extension:

```
Construction:
  F_p^2 = F_p[u] / (u^2 + 1)
  Elements: a + b*u where a, b ∈ F_p

Operations:
  Addition: (a1 + b1*u) + (a2 + b2*u) = (a1+a2) + (b1+b2)*u
  Multiplication: uses u^2 = -1
```

### F_p^12 Construction

Tower extension:

```
Construction:
  F_p^2 → F_p^6 → F_p^12

F_p^6:
  F_p^2[v] / (v^3 - (9+u))

F_p^12:
  F_p^6[w] / (w^2 - v)

Used for pairing target GT
```

## G1 Operations

### G1 Point Addition

Adding G1 points:

```
Standard elliptic curve addition:
  Same as secp256k1 formulas
  But different curve equation (b = 3)

Constraints:
  Same structure as generic curve
  Field operations in F_p
```

### G1 Scalar Multiplication

Scalar multiplication:

```
k * P for k scalar, P ∈ G1

Methods:
  Double-and-add
  Window methods
  Similar to secp256k1
```

### G1 Membership

Verifying G1 membership:

```
Check:
  Point satisfies y^2 = x^3 + 3
  Point is on curve

Constraint:
  y^2 - x^3 - 3 = 0 (mod p)
```

## G2 Operations

### G2 Point Representation

Points in extension field:

```
G2 point:
  (x, y) where x, y ∈ F_p^2
  Each coordinate is pair (a, b)

Total:
  4 F_p elements per point
```

### G2 Point Addition

Adding G2 points:

```
Same formulas as G1:
  But all operations in F_p^2

Extension field operations:
  More constraints per operation
  F_p^2 multiplication involves 3 F_p multiplications
```

### G2 Membership

Verifying G2 membership:

```
Checks:
  Satisfies twisted curve equation
  Has correct order (subgroup check)

Subgroup check:
  Multiply by cofactor
  Verify non-zero
```

## Pairing Operations

### Pairing Definition

The bilinear pairing:

```
e: G1 × G2 → GT

Properties:
  Bilinearity: e(aP, bQ) = e(P, Q)^{ab}
  Non-degeneracy: e(G1, G2) ≠ 1
```

### Miller Loop

Core pairing computation:

```
Miller loop:
  Compute line functions
  Accumulate in F_p^12

For f_{r,Q}(P):
  Evaluate lines through Q at P
  r is the curve order
```

### Final Exponentiation

Completing the pairing:

```
After Miller loop:
  f = miller(P, Q)
  result = f^{(p^12 - 1) / n}

Optimization:
  Easy part: (p^6 - 1)(p^2 + 1)
  Hard part: (p^4 - p^2 + 1) / n
```

## Constraint Formulations

### Extension Field Constraints

F_p^2 operations:

```
Multiplication (a + bu)(c + du):
  Real part: ac - bd
  Imag part: ad + bc

Constraints:
  ac - bd = e (real result)
  ad + bc = f (imag result)

Karatsuba optimization:
  3 multiplications instead of 4
```

### Pairing Constraints

Proving pairing computation:

```
Components:
  Line function evaluations
  F_p^12 multiplications
  Final exponentiation

Total:
  Large number of constraints
  Optimizations critical
```

### Verification Check

Common pairing check:

```
Check e(A, B) = e(C, D):
  Equivalent to e(A, B) * e(C, -D) = 1
  Single pairing computation

Groth16 verification:
  e(A, B) = e(αG1, βG2) * e(L, γG2) * e(C, δG2)
```

## Optimization Strategies

### Lazy Reduction

Deferring field reduction:

```
In extension fields:
  Coefficients may exceed p
  Reduce only when necessary
  Fewer reduction constraints
```

### Precomputation

Fixed point optimization:

```
For fixed G2:
  Precompute Miller loop values
  Lookup during verification

Benefit:
  Major constraint reduction
  Common in SNARK verification
```

### Multi-Pairing

Batch pairing:

```
Multi-pairing:
  e(P1,Q1) * e(P2,Q2) * ... * e(Pn,Qn)
  Shared final exponentiation

Savings:
  One final exp instead of n
  Significant for verification
```

## Precompile Interface

### G1 Operations

G1 precompile inputs:

```
Point addition:
  Two G1 points (128 bytes each)
  Output: G1 point

Scalar multiplication:
  G1 point + 32-byte scalar
  Output: G1 point
```

### G2 Operations

G2 precompile inputs:

```
Point addition:
  Two G2 points (256 bytes each)
  Output: G2 point

Scalar multiplication:
  G2 point + 32-byte scalar
  Output: G2 point
```

### Pairing Check

Pairing precompile:

```
Input:
  List of (G1, G2) pairs
  (P1, Q1), (P2, Q2), ...

Output:
  Boolean: product of pairings = 1

Used for:
  Groth16 verification
  Other pairing checks
```

## Ethereum Compatibility

### Ethereum Precompiles

EIP-196 and EIP-197:

```
ecAdd (0x06):
  G1 point addition

ecMul (0x07):
  G1 scalar multiplication

ecPairing (0x08):
  Multi-pairing check
```

### Gas Costs

Ethereum gas model:

```
Current costs:
  ecAdd: 150 gas
  ecMul: 6000 gas
  ecPairing: 45000 + 34000 per pair
```

## Key Concepts

- **BN254 curve**: Pairing-friendly curve for zkSNARK
- **G1 and G2**: Two curve groups for pairing
- **Extension fields**: F_p^2, F_p^12 for operations
- **Miller loop**: Core pairing algorithm
- **Final exponentiation**: Completing pairing computation

## Design Trade-offs

### Field Representation

| Native F_p | Lazy Reduction |
|------------|----------------|
| Simple | Complex tracking |
| More reductions | Fewer reductions |
| Smaller intermediates | Larger intermediates |

### Pairing Strategy

| Full Pairing | Pairing Check Only |
|--------------|-------------------|
| Returns GT element | Returns boolean |
| More general | Common case optimized |
| Higher cost | Lower cost |

## Related Topics

- [256-bit Arithmetic](../03-arithmetic-precompiles/01-256-bit-arithmetic.md) - Field arithmetic
- [secp256k1 Operations](01-secp256k1-operations.md) - Non-pairing curve
- [BLS12-381 Operations](03-bls12-381-operations.md) - Alternative pairing curve
- [Constraint Representation](../01-precompile-design/02-constraint-representation.md) - Encoding techniques

