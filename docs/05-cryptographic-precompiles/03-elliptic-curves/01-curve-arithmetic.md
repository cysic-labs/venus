# Curve Arithmetic

## Overview

Elliptic curve arithmetic forms the foundation of modern public-key cryptography, enabling digital signatures, key exchange, and identity verification. In a zkVM context, proving correct curve operations allows verification of signatures, proof aggregation, and interoperability with blockchain systems. The challenge lies in implementing curve operations over large prime fields within the constraint system of a finite-field-based proof system.

Elliptic curve operations involve computing point additions, doublings, and scalar multiplications on curves defined over prime fields. When the curve's base field differs from the proof system's native field, arithmetic becomes more complex, requiring techniques like non-native field arithmetic. This document covers fundamental curve operations, constraint representations, and implementation strategies for efficient curve arithmetic in circuits.

## Elliptic Curve Basics

### Curve Definition

Short Weierstrass form:

```
Curve equation:
  y^2 = x^3 + ax + b (mod p)

Parameters:
  p: Prime field modulus
  a, b: Curve coefficients
  G: Generator point
  n: Order of G (number of points in subgroup)

Common curves:
  secp256k1 (Bitcoin): y^2 = x^3 + 7
  BN254: Pairing-friendly curve
  BLS12-381: Pairing-friendly curve
```

### Point Representation

How points are encoded:

```
Affine coordinates:
  Point P = (x, y)
  Satisfies curve equation

Point at infinity:
  O = identity element
  P + O = P for any P
  Represented specially (flag or projective)

Projective coordinates:
  P = (X : Y : Z)
  Affine: (X/Z, Y/Z) or (X/Z^2, Y/Z^3)
  Avoids division in formulas
```

### Group Operations

Point addition and scalar multiplication:

```
Point addition:
  P + Q = R
  Computes third point on line through P and Q

Point doubling:
  2P = P + P
  Special case when P = Q

Scalar multiplication:
  kP = P + P + ... + P (k times)
  Core operation for signatures

Identity:
  P + O = P
  P + (-P) = O
  -P = (x, -y)
```

## Point Addition

### Affine Addition Formula

Adding distinct points:

```
Given P = (x1, y1), Q = (x2, y2), P ≠ Q:

Slope:
  λ = (y2 - y1) / (x2 - x1)

Result R = (x3, y3):
  x3 = λ^2 - x1 - x2
  y3 = λ(x1 - x3) - y1

Requires:
  1 inversion (for division)
  2 multiplications
  Several additions
```

### Affine Doubling Formula

Doubling a point:

```
Given P = (x1, y1):

Slope:
  λ = (3x1^2 + a) / (2y1)

Result 2P = (x3, y3):
  x3 = λ^2 - 2x1
  y3 = λ(x1 - x3) - y1

Requires:
  1 inversion
  2-3 multiplications
```

### Projective Coordinates

Avoiding inversions:

```
Jacobian projective: (X : Y : Z)
  Affine: (X/Z^2, Y/Z^3)

Addition (mixed affine + Jacobian):
  More complex formulas
  No inversions needed

Doubling (Jacobian):
  ~10 multiplications
  No inversions

Convert to affine only at end:
  Single inversion per scalar multiplication
  Major efficiency gain
```

## Constraint Representation

### Point on Curve

Verifying point validity:

```
Constraint:
  y^2 = x^3 + a*x + b (mod p)

In circuit:
  If p = native field:
    Direct constraint
  If p ≠ native field:
    Non-native arithmetic required
```

### Addition Constraints

Constraining addition correctness:

```
For P + Q = R where P ≠ Q:

Slope computation:
  λ * (x2 - x1) = y2 - y1

X coordinate:
  x3 = λ^2 - x1 - x2

Y coordinate:
  y3 + y1 = λ * (x1 - x3)

Constraints (native field):
  λ * (x2 - x1) - (y2 - y1) = 0
  x3 - λ^2 + x1 + x2 = 0
  y3 + y1 - λ * (x1 - x3) = 0

Auxiliary column:
  λ = prover-computed slope
```

### Doubling Constraints

Constraining doubling:

```
For 2P = R:

Slope computation:
  λ * (2 * y1) = 3 * x1^2 + a

Coordinates:
  x3 = λ^2 - 2 * x1
  y3 = λ * (x1 - x3) - y1

Constraints:
  2 * y1 * λ - 3 * x1^2 - a = 0
  x3 - λ^2 + 2 * x1 = 0
  y3 + y1 - λ * (x1 - x3) = 0
```

### Special Cases

Handling edge cases:

```
P = O (point at infinity):
  P + Q = Q
  Need flag for infinity

P = -Q (vertical line):
  P + Q = O
  Result is infinity

P = Q (doubling):
  Use doubling formula instead
  Different slope computation

Constraints must handle all cases:
  Selector for case type
  Appropriate formula for each
```

## Non-Native Arithmetic

### Field Mismatch

When curve field ≠ proof field:

```
Example:
  Curve: secp256k1 over 256-bit prime
  Proof system: BN254 scalar field (254 bits)

Challenge:
  256-bit values don't fit in 254-bit field
  Need to represent and compute in chunks

Approach:
  Limb decomposition
  Carry handling
  Range proofs on limbs
```

### Limb Representation

Breaking big integers into limbs:

```
For 256-bit value v:
  v = l0 + l1*2^64 + l2*2^128 + l3*2^192

Each limb li < 2^64 fits in native field.

Operations:
  Addition: Add limbs with carry
  Multiplication: Schoolbook or Karatsuba
  Reduction: Mod p using special structure
```

### Non-Native Multiplication

Multiplying big integers:

```
a = Σ ai * 2^(64i)
b = Σ bj * 2^(64j)

Product:
  c = a * b = Σ Σ ai * bj * 2^(64(i+j))

Then reduce mod p:
  c mod p using curve's prime structure

Constraint count:
  ~16 native multiplications per non-native multiplication
  Plus carry handling
```

### Range Proofs

Ensuring limbs are in range:

```
Each limb must be < 2^64:
  Range check required
  Lookup or bit decomposition

Carry values in range:
  Intermediate carries bounded
  Additional range checks
```

## Scalar Multiplication

### Double-and-Add

Basic algorithm:

```
Input: scalar k, point P
Output: kP

Algorithm:
  R = O (identity)
  for bit in bits_of_k (high to low):
    R = 2R
    if bit == 1:
      R = R + P
  return R

Constraint count:
  ~256 doublings
  ~128 additions (on average)
```

### Windowed Methods

Reducing additions:

```
Window size w:
  Precompute: P, 2P, 3P, ..., (2^w - 1)P

Process k in w-bit windows:
  For each window value v:
    R = 2^w * R + v*P (from table)

Benefits:
  Fewer additions
  Trade-off: Larger precomputed table
```

### Endomorphism Optimization

For curves with efficient endomorphism:

```
secp256k1 has endomorphism φ:
  φ(P) = λ * P for special λ
  Can compute φ(P) cheaply

GLV decomposition:
  k = k1 + k2 * λ (mod n)
  kP = k1*P + k2*φ(P)

Half-length scalar multiplications:
  Two 128-bit muls instead of one 256-bit
  Faster overall
```

## Circuit Organization

### Operation Layout

Columns for EC operations:

```
Point columns:
  x1, y1: First input point
  x2, y2: Second input point (for add)
  x3, y3: Output point

Auxiliary columns:
  lambda: Slope value
  temp values for computation

Selector columns:
  is_add: Point addition
  is_double: Point doubling
  is_infinity: Result is O
```

### Scalar Multiplication Layout

Multi-row scalar mul:

```
For 256-bit scalar:
  256 rows for double-and-add
  Each row: one bit of scalar

Columns per row:
  R_x, R_y: Current accumulator point
  bit: Current scalar bit
  intermediate values

Constraints:
  Accumulator updates correctly
  Bit is 0 or 1
  Final result matches expected
```

## Key Concepts

- **Elliptic curve**: Algebraic curve for cryptography
- **Point addition**: Group operation on curve points
- **Scalar multiplication**: Repeated point addition
- **Projective coordinates**: Division-free point representation
- **Non-native arithmetic**: Computing in non-native field

## Design Considerations

### Coordinate System

| Affine | Projective |
|--------|------------|
| Smaller state | Larger state |
| Division needed | No division |
| Simpler formulas | Complex formulas |
| Slower | Faster |

### Field Representation

| Native Field | Non-Native Field |
|--------------|------------------|
| Direct arithmetic | Limb arithmetic |
| Few constraints | Many constraints |
| Limited curves | Any curve |
| Fast | Slow |

## Related Topics

- [Signature Verification](02-signature-verification.md) - EC signature circuits
- [Pairing Operations](03-pairing-operations.md) - Advanced EC operations
- [Arithmetic Operations](../../04-zkvm-architecture/02-state-machine-design/03-arithmetic-operations.md) - Field arithmetic
- [Range Checking](../../04-zkvm-architecture/03-memory-system/03-range-checking.md) - Limb range proofs
