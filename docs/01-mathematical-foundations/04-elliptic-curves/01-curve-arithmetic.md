# Elliptic Curve Arithmetic

## Overview

Elliptic curves are algebraic structures that provide the foundation for many cryptographic systems, including digital signatures, key exchange, and certain zero-knowledge proof constructions. While zkVMs based on STARKs primarily use polynomial techniques, elliptic curve operations frequently appear as precompiled functions for verifying signatures and supporting SNARK-based recursive composition.

Understanding elliptic curve arithmetic is essential for implementing efficient precompiles that handle operations like ECDSA signature verification (secp256k1) or BN254 pairing checks. This document covers the mathematical foundations and efficient algorithms for elliptic curve operations.

## Mathematical Foundation

### Curve Definition

An elliptic curve E over a field F is defined by the Weierstrass equation:

```
E: y^2 = x^3 + a*x + b
```

where a, b are elements of F satisfying the non-singularity condition:

```
4a^3 + 27b^2 != 0
```

This condition ensures the curve has no cusps or self-intersections.

### Points on the Curve

A point P = (x, y) is on the curve if it satisfies the equation. The set of all such points, together with a special "point at infinity" O, forms an abelian group.

```
E(F) = {(x, y) in F x F : y^2 = x^3 + a*x + b} union {O}
```

### The Point at Infinity

The point at infinity O serves as the identity element:
- P + O = P for any point P
- P + (-P) = O

Geometrically, O is where all vertical lines "meet" at infinity.

### Curve Order

The number of points on the curve E(F) is denoted #E(F). For a prime field F_p, Hasse's theorem bounds this:

```
|#E(F_p) - (p + 1)| <= 2*sqrt(p)
```

Cryptographic curves are chosen so that #E(F_p) has a large prime factor.

## Point Addition

### Geometric Interpretation

The group law on elliptic curves has a beautiful geometric interpretation:

To add P and Q:
1. Draw the line through P and Q
2. This line intersects the curve at a third point R'
3. Reflect R' over the x-axis to get R = P + Q

### Algebraic Formulas

For P = (x1, y1) and Q = (x2, y2):

**Case 1: P != Q (general addition)**

```
lambda = (y2 - y1) / (x2 - x1)
x3 = lambda^2 - x1 - x2
y3 = lambda * (x1 - x3) - y1
```

**Case 2: P = Q (point doubling)**

```
lambda = (3*x1^2 + a) / (2*y1)
x3 = lambda^2 - 2*x1
y3 = lambda * (x1 - x3) - y1
```

**Case 3: P = -Q (inverse points)**

```
P + Q = O
```

### Implementation

```python
def point_add(P, Q, a, p):
    if P is None:  # O
        return Q
    if Q is None:
        return P

    x1, y1 = P
    x2, y2 = Q

    if x1 == x2:
        if (y1 + y2) % p == 0:
            return None  # P + (-P) = O
        # Point doubling
        lam = (3 * x1 * x1 + a) * mod_inv(2 * y1, p) % p
    else:
        lam = (y2 - y1) * mod_inv(x2 - x1, p) % p

    x3 = (lam * lam - x1 - x2) % p
    y3 = (lam * (x1 - x3) - y1) % p

    return (x3, y3)
```

## Point Doubling

Point doubling (P + P = 2P) is the most frequent operation in scalar multiplication. It deserves special attention.

### Optimized Doubling

Direct formula:
```
lambda = (3*x^2 + a) / (2*y)
x_new = lambda^2 - 2*x
y_new = lambda * (x - x_new) - y
```

This requires:
- 1 field inversion (expensive!)
- Several multiplications and additions

### Avoiding Inversions

Inversions are much more expensive than multiplications. Projective coordinates (discussed below) eliminate most inversions.

## Scalar Multiplication

### Definition

Scalar multiplication computes:
```
k * P = P + P + ... + P  (k times)
```

This is the core operation for cryptographic applications.

### Double-and-Add Algorithm

Similar to square-and-multiply for exponentiation:

```python
def scalar_mul(k, P, a, p):
    result = None  # Point at infinity
    addend = P

    while k > 0:
        if k & 1:
            result = point_add(result, addend, a, p)
        addend = point_add(addend, addend, a, p)  # Double
        k >>= 1

    return result
```

Complexity: O(log k) point additions/doublings.

### Window Methods

For faster scalar multiplication, precompute small multiples of P:

**NAF (Non-Adjacent Form)**:
Represent k with digits in {-1, 0, 1}, no two consecutive non-zero digits.

**Windowed NAF**:
Use larger windows, precompute {P, 3P, 5P, ..., (2^w - 1)P}.

**Sliding window**:
Combine windowing with efficient bit scanning.

### Constant-Time Implementation

For cryptographic security, scalar multiplication must be constant-time:
- No branching based on secret values
- No memory access patterns that reveal secrets

```python
def constant_time_scalar_mul(k, P, a, p):
    R0 = None  # O
    R1 = P

    for i in range(bit_length(k) - 1, -1, -1):
        bit = (k >> i) & 1

        # Always do both operations
        R0_double = point_add(R0, R0, a, p)
        R0_add = point_add(R0, R1, a, p)

        # Constant-time select based on bit
        R0 = select(bit, R0_add, R0_double)

        R1_double = point_add(R1, R1, a, p)
        R1_add = point_add(R0_backup, R1, a, p)

        # ... (full Montgomery ladder)

    return R0
```

## Projective Coordinates

### Motivation

Affine coordinates (x, y) require a field inversion for each addition. Inversions are 20-100x slower than multiplications.

Projective coordinates represent points as (X : Y : Z) where:
```
x = X/Z,  y = Y/Z  (for standard projective)
```
or
```
x = X/Z^2,  y = Y/Z^3  (for Jacobian)
```

### Jacobian Coordinates

Jacobian coordinates are common for curves with a = 0 or a = -3:

Point (X, Y, Z) represents affine point (X/Z^2, Y/Z^3).

**Doubling formula** (for a = 0):
```
A = Y^2
B = 4*X*A
C = 8*A^2
D = 3*X^2
X' = D^2 - 2*B
Y' = D*(B - X') - C
Z' = 2*Y*Z
```

Cost: 1S + 8M (S = squaring, M = multiplication)

**Mixed addition** (Jacobian + Affine):
Adding affine point to Jacobian is cheaper than Jacobian + Jacobian.

### Coordinate Comparison

| Coordinate System | Doubling Cost | Addition Cost | Memory |
|-------------------|---------------|---------------|--------|
| Affine | 1I + 2M + 2S | 1I + 2M + 1S | 2 elements |
| Projective | 5M + 6S | 12M + 2S | 3 elements |
| Jacobian | 4M + 4S | 11M + 5S | 3 elements |

I = Inversion, M = Multiplication, S = Squaring

## Common Curves

### secp256k1

Used in Bitcoin and Ethereum for ECDSA signatures.

Parameters:
- Field: F_p where p = 2^256 - 2^32 - 977
- Equation: y^2 = x^3 + 7 (a = 0, b = 7)
- Order: n = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
- Generator: G = (0x79BE667..., 0x483ADA77...)

Special property: a = 0 enables efficient doubling formulas.

### BN254 (alt_bn128)

Used for Ethereum precompiles supporting pairing operations.

Parameters:
- Field: F_p where p ~ 2^254
- Curve for G1: y^2 = x^3 + 3
- Has efficient pairing e: G1 x G2 -> GT

### BLS12-381

Modern pairing-friendly curve with higher security.

Parameters:
- Field: F_p where p ~ 2^381
- 128-bit security level
- Larger but more secure than BN254

## Multi-Scalar Multiplication (MSM)

### Definition

MSM computes:
```
sum_{i=1}^{n} k_i * P_i
```

This is common in KZG commitments and SNARK verification.

### Pippenger's Algorithm

For large n, Pippenger's algorithm is optimal:

1. Divide scalars into windows of w bits
2. For each window position:
   - Bucket points by their w-bit window value
   - Sum buckets using a clever scheme
3. Combine window results

Complexity: O(n / log n) point additions.

### Parallelization

MSM parallelizes well:
- Bucket accumulation is independent per bucket
- Final summation is a reduction

GPU implementations achieve massive speedups for large MSM.

## Endomorphisms

### GLV Endomorphism

For certain curves, an efficiently computable endomorphism speeds up scalar multiplication.

For secp256k1, there exists an endomorphism phi such that:
- phi(P) is computable with just field operations (no point operations)
- phi has eigenvalue lambda where lambda^2 + lambda + 1 = 0 mod n

This allows decomposing k into k = k1 + k2*lambda with small k1, k2, enabling 2x speedup.

### Implementation

```python
def scalar_mul_glv(k, P):
    # Decompose k = k1 + k2 * lambda mod n
    k1, k2 = decompose(k)

    # Compute phi(P) cheaply
    P2 = endomorphism(P)

    # Multi-scalar multiplication with half-size scalars
    return multi_scalar_mul([k1, k2], [P, P2])
```

## Point Compression

### Compression

An elliptic curve point (x, y) can be compressed to x plus one bit indicating y's sign.

```python
def compress(P):
    x, y = P
    sign_bit = y & 1  # Parity of y
    return (x, sign_bit)
```

### Decompression

To decompress:
1. Compute y^2 = x^3 + a*x + b
2. Compute y = sqrt(y^2)
3. Select correct y based on sign bit

```python
def decompress(x, sign_bit, a, b, p):
    y_squared = (x**3 + a*x + b) % p
    y = tonelli_shanks(y_squared, p)  # Square root
    if y & 1 != sign_bit:
        y = p - y
    return (x, y)
```

### Storage Savings

Compression halves point storage:
- Uncompressed: 2 * field_size bits
- Compressed: field_size + 1 bits

## Key Concepts

- **Elliptic curve group**: Points on the curve with addition operation
- **Point at infinity**: Identity element of the group
- **Scalar multiplication**: k * P, the core cryptographic operation
- **Projective coordinates**: Avoid inversions during computation
- **MSM**: Multi-scalar multiplication for batch operations
- **GLV endomorphism**: Speedup using curve-specific endomorphisms

## Design Considerations

### Curve Selection for Precompiles

When designing zkVM precompiles:
- Match curves to application needs (secp256k1 for Ethereum compatibility)
- Consider constraint cost vs. native cost trade-offs
- Pairing curves enable more operations but are more complex

### Constraint Representation

Expressing EC operations as constraints:
- Each field operation becomes constraints
- Inversion particularly expensive in circuits
- Use projective coordinates to minimize inversions

### Optimization Priorities

| Context | Priority |
|---------|----------|
| Native execution | Minimize wall-clock time |
| Inside circuit | Minimize constraint count |
| Signature verification | Optimize scalar multiplication |
| MSM | Optimize parallel bucket accumulation |

### Security Considerations

- Constant-time for secret scalars
- Point validation (verify points are on curve)
- Cofactor clearing for curves with cofactor > 1

## Related Topics

- [Pairing Curves](02-pairing-curves.md) - Curves with bilinear pairings
- [256-bit Arithmetic](../../05-cryptographic-precompiles/03-arithmetic-precompiles/01-256-bit-arithmetic.md) - Big integer operations for EC
- [secp256k1 Operations](../../05-cryptographic-precompiles/04-elliptic-curve-precompiles/01-secp256k1-operations.md) - Precompile design
- [Prime Fields](../01-finite-fields/01-prime-fields.md) - Underlying field arithmetic
