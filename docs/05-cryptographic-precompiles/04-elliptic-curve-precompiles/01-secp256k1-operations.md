# secp256k1 Operations

## Overview

The secp256k1 elliptic curve is the foundation of Bitcoin and Ethereum cryptography, used for digital signatures and public key derivation. The curve is defined over a 256-bit prime field and provides 128 bits of security. The zkVM must efficiently prove secp256k1 operations to support signature verification and key-related computations.

Elliptic curve operations involve point addition, point doubling, and scalar multiplication. These operations build on the field arithmetic covered in previous sections but require additional constraints for the curve equation and the geometric relationships between points. The precompile must handle edge cases like the point at infinity and adding a point to itself.

This document covers secp256k1 curve parameters, point representation, operation constraints, and optimization strategies.

## Curve Definition

### Curve Equation

The secp256k1 curve:

```
Equation: y^2 = x^3 + 7 (mod p)

Parameters:
  a = 0 (coefficient of x)
  b = 7 (constant term)

Field prime:
  p = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F
  p = 2^256 - 2^32 - 977

Special form:
  Pseudo-Mersenne prime
  Efficient reduction
```

### Curve Order

Generator and order:

```
Generator G:
  Gx = 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798
  Gy = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8

Order:
  n = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
  Number of points on curve
  Used for scalar arithmetic
```

### Cofactor

Curve cofactor:

```
Cofactor h = 1
  Every point is in main group
  No subgroup attacks
  Simpler implementation
```

## Point Representation

### Affine Coordinates

Standard representation:

```
Point P = (x, y):
  x, y are field elements
  Satisfy y^2 = x^3 + 7

Point at infinity:
  Special representation
  Identity element for addition
  Cannot be represented as (x, y)
```

### Projective Coordinates

Homogeneous representation:

```
Point P = (X : Y : Z):
  Represents (X/Z, Y/Z) in affine
  Avoids division during operations

Curve equation:
  Y^2 * Z = X^3 + 7 * Z^3

Point at infinity:
  (0 : 1 : 0) typically
```

### Jacobian Coordinates

Weighted projective:

```
Point P = (X : Y : Z):
  Represents (X/Z^2, Y/Z^3) in affine
  More efficient doubling

Curve equation:
  Y^2 = X^3 + 7 * Z^6

Benefits:
  Fewer multiplications in doubling
  Widely used for scalar multiplication
```

## Point Addition

### Affine Addition

Adding distinct points:

```
Given P = (x1, y1), Q = (x2, y2), P ≠ Q:

Slope:
  λ = (y2 - y1) / (x2 - x1)

Result R = (x3, y3):
  x3 = λ^2 - x1 - x2
  y3 = λ * (x1 - x3) - y1
```

### Affine Addition Constraints

Proving point addition:

```
Constraints:
  1. λ * (x2 - x1) = y2 - y1
  2. x3 + x1 + x2 = λ^2
  3. y3 + y1 = λ * (x1 - x3)

Plus curve membership:
  y1^2 = x1^3 + 7
  y2^2 = x2^3 + 7
  y3^2 = x3^3 + 7
```

### Projective Addition

Adding in projective:

```
More complex formulas:
  Avoid division
  More multiplications

Benefit:
  Suitable for constraints
  No field inversion needed
```

## Point Doubling

### Affine Doubling

Doubling a point:

```
Given P = (x1, y1):

Slope (tangent):
  λ = (3 * x1^2 + a) / (2 * y1)
  λ = (3 * x1^2) / (2 * y1)  (since a = 0)

Result 2P = (x3, y3):
  x3 = λ^2 - 2 * x1
  y3 = λ * (x1 - x3) - y1
```

### Doubling Constraints

Proving point doubling:

```
Constraints:
  1. λ * (2 * y1) = 3 * x1^2
  2. x3 + 2 * x1 = λ^2
  3. y3 + y1 = λ * (x1 - x3)

Curve membership implied by input validity
```

### Jacobian Doubling

Efficient doubling:

```
For P = (X1 : Y1 : Z1):

  A = Y1^2
  B = 4 * X1 * A
  C = 8 * A^2
  D = 3 * X1^2

Result:
  X3 = D^2 - 2*B
  Y3 = D*(B - X3) - C
  Z3 = 2*Y1*Z1

Fewer field operations than affine
```

## Scalar Multiplication

### Double-and-Add

Basic scalar multiplication:

```
Compute k * P for scalar k, point P:

Algorithm:
  R = infinity
  For i from n-1 downto 0:
    R = 2 * R (double)
    If bit k[i] = 1:
      R = R + P (add)
  Return R
```

### Binary Ladder

Constant-time scalar multiplication:

```
Montgomery ladder:
  Always same operations regardless of scalar
  Prevents timing attacks

For zkVM:
  Constraint-level timing irrelevant
  But may affect constraint count
```

### Windowed Methods

Faster scalar multiplication:

```
Window width w:
  Precompute [1]P, [2]P, ..., [2^w - 1]P
  Process w bits at a time

Trade-off:
  More precomputation
  Fewer doublings
```

## Constraint Formulations

### Addition Constraint Set

Complete addition constraints:

```
For P + Q = R where P ≠ ±Q:

  Inputs: (x1, y1), (x2, y2)
  Output: (x3, y3)
  Auxiliary: λ

Constraints:
  λ * (x2 - x1) - (y2 - y1) = 0
  λ^2 - x1 - x2 - x3 = 0
  λ * (x1 - x3) - y1 - y3 = 0
```

### Unified Addition

Handling P = Q case:

```
Challenge:
  Different formulas for add vs double
  Need unified or selected

Approach:
  is_double selector
  Choose formula based on selector

Constraints:
  (1 - is_double) * (add constraints)
  is_double * (double constraints)
```

### Point at Infinity

Handling identity:

```
Special cases:
  P + infinity = P
  infinity + Q = Q
  P + (-P) = infinity

Constraints:
  is_infinity selectors
  Special handling when set
```

## Signature Operations

### ECDSA Verification

Signature verification:

```
Given:
  Message hash h
  Signature (r, s)
  Public key Q

Verify:
  u1 = h * s^{-1} mod n
  u2 = r * s^{-1} mod n
  R = u1 * G + u2 * Q
  Check: R.x mod n = r
```

### Verification Constraints

Proving ECDSA verification:

```
Steps in constraints:
  1. Compute s^{-1} mod n
  2. Compute u1 = h * s^{-1}
  3. Compute u2 = r * s^{-1}
  4. Compute u1 * G (scalar mul)
  5. Compute u2 * Q (scalar mul)
  6. Add results
  7. Compare x-coordinate with r
```

## Optimization Strategies

### Precomputed Tables

Using precomputation:

```
Fixed base G:
  Precompute multiples of G
  Lookup during scalar mul
  Reduce online computation

Variable base:
  Window tables during execution
  More flexible but more constraint
```

### GLV Endomorphism

secp256k1-specific optimization:

```
Endomorphism:
  φ(x, y) = (β*x, y) where β^3 = 1 mod p
  φ(P) = λ*P for some λ

Decomposition:
  k = k1 + k2*λ mod n
  k*P = k1*P + k2*φ(P)

Benefit:
  Half-size scalar multiplications
  Significant speedup
```

### Batch Verification

Verifying multiple signatures:

```
Batch approach:
  Random combination of signatures
  Single multi-scalar multiplication
  Amortized cost
```

## Precompile Interface

### Input Format

Operation inputs:

```
Point representation:
  64 bytes (32 for x, 32 for y)
  Big-endian

Scalar representation:
  32 bytes big-endian

Operations:
  Add: two points
  Double: one point
  ScalarMul: point and scalar
```

### Output Format

Operation results:

```
Point output:
  64 bytes (x, y)
  Affine coordinates

Special case:
  Point at infinity indicated specially
```

## Key Concepts

- **secp256k1 curve**: y^2 = x^3 + 7 over 256-bit prime field
- **Point representation**: Affine, projective, or Jacobian coordinates
- **Scalar multiplication**: Core operation for cryptographic protocols
- **GLV endomorphism**: secp256k1-specific optimization
- **ECDSA**: Primary signature scheme using secp256k1

## Design Trade-offs

### Coordinate System

| Affine | Projective/Jacobian |
|--------|---------------------|
| Simple | No division |
| Needs inversion | More variables |
| Clear semantics | Complex formulas |

### Scalar Mul Method

| Double-and-Add | Windowed |
|----------------|----------|
| Simple | More precomputation |
| More doublings | Fewer doublings |
| Less memory | More memory |

## Related Topics

- [256-bit Arithmetic](../03-arithmetic-precompiles/01-256-bit-arithmetic.md) - Field arithmetic
- [Modular Arithmetic](../03-arithmetic-precompiles/03-modular-arithmetic.md) - Field operations
- [BN254 Operations](02-bn254-operations.md) - Pairing curve
- [Constraint Representation](../01-precompile-design/02-constraint-representation.md) - Encoding techniques

