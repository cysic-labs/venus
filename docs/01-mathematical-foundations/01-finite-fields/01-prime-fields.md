# Prime Fields

## Overview

Prime fields form the mathematical foundation of modern zero-knowledge proof systems. A prime field, denoted F_p or GF(p), consists of integers from 0 to p-1 with arithmetic performed modulo a prime number p. These structures provide the algebraic properties essential for encoding computations, constructing polynomials, and generating cryptographic proofs.

Understanding prime fields is crucial because every operation in a zkVM - from basic arithmetic to complex cryptographic primitives - ultimately reduces to operations in a prime field. The choice of prime affects performance, security, and compatibility with other cryptographic constructions.

This document covers the theoretical foundations of prime fields, their properties, arithmetic operations, and the considerations that guide field selection for zkVM implementations.

## Mathematical Foundation

### Definition

A prime field F_p is the set of integers {0, 1, 2, ..., p-1} equipped with two operations:

**Addition**: `(a + b) mod p`
**Multiplication**: `(a * b) mod p`

For these operations to form a field, p must be prime. This ensures that every non-zero element has a multiplicative inverse, which is essential for division.

### Field Axioms

Prime fields satisfy all field axioms:

**Closure**: For all a, b in F_p, both `a + b` and `a * b` are in F_p

**Associativity**:
- `(a + b) + c = a + (b + c)`
- `(a * b) * c = a * (b * c)`

**Commutativity**:
- `a + b = b + a`
- `a * b = b * a`

**Identity Elements**:
- Additive identity: `a + 0 = a`
- Multiplicative identity: `a * 1 = a`

**Inverse Elements**:
- Additive inverse: For every a, there exists -a such that `a + (-a) = 0`
- Multiplicative inverse: For every a != 0, there exists a^(-1) such that `a * a^(-1) = 1`

**Distributivity**: `a * (b + c) = (a * b) + (a * c)`

### Order and Characteristic

The **order** of a prime field F_p is p - the number of elements it contains.

The **characteristic** of F_p is also p - the smallest positive integer n such that adding 1 to itself n times yields 0:

```
1 + 1 + ... + 1 (p times) = 0 in F_p
```

## Basic Arithmetic Operations

### Addition and Subtraction

Addition in F_p is straightforward modular addition:

```
add(a, b) = (a + b) mod p
```

If the sum exceeds p-1, subtract p:

```python
def field_add(a, b, p):
    result = a + b
    if result >= p:
        result -= p
    return result
```

Subtraction uses the additive inverse:

```
sub(a, b) = (a - b) mod p = (a + (p - b)) mod p
```

### Multiplication

Field multiplication is modular multiplication:

```
mul(a, b) = (a * b) mod p
```

For large primes, computing `a * b` may exceed the native integer size, requiring careful handling:

```python
def field_mul(a, b, p):
    # For 64-bit primes, may need 128-bit intermediate
    return (a * b) % p
```

### Division and Multiplicative Inverse

Division is multiplication by the multiplicative inverse:

```
div(a, b) = a * b^(-1) mod p
```

The multiplicative inverse can be computed using:

**Extended Euclidean Algorithm**: Finds x such that `b * x = 1 mod p`

```python
def extended_gcd(a, b):
    if a == 0:
        return b, 0, 1
    gcd, x1, y1 = extended_gcd(b % a, a)
    x = y1 - (b // a) * x1
    y = x1
    return gcd, x, y

def field_inv(a, p):
    gcd, x, _ = extended_gcd(a % p, p)
    if gcd != 1:
        raise ValueError("Inverse doesn't exist")
    return (x % p + p) % p
```

**Fermat's Little Theorem**: For prime p and a != 0:

```
a^(p-1) = 1 mod p
```

Therefore:

```
a^(-1) = a^(p-2) mod p
```

This reduces inversion to exponentiation, which can be computed efficiently using square-and-multiply.

### Exponentiation

Computing `a^n mod p` efficiently uses the square-and-multiply algorithm:

```python
def field_pow(a, n, p):
    result = 1
    base = a % p
    while n > 0:
        if n & 1:  # n is odd
            result = (result * base) % p
        n >>= 1
        base = (base * base) % p
    return result
```

This computes the result in O(log n) multiplications.

## The Multiplicative Group

### Structure

The non-zero elements of F_p form a multiplicative group, denoted F_p^* or (Z/pZ)^*. This group has:

- Order: p - 1 (number of elements)
- Identity: 1
- Every element has a unique inverse

### Generators and Primitive Roots

A **generator** (or **primitive root**) g of F_p^* is an element whose powers generate all non-zero field elements:

```
{g^0, g^1, g^2, ..., g^(p-2)} = {1, 2, 3, ..., p-1}
```

Not every prime field element is a generator. The number of generators equals phi(p-1), where phi is Euler's totient function.

### Roots of Unity

An **n-th root of unity** is an element omega such that:

```
omega^n = 1
```

If n divides p-1, then F_p contains exactly n distinct n-th roots of unity. The **primitive n-th root of unity** generates all n-th roots:

```
{omega^0, omega^1, ..., omega^(n-1)}
```

are all the n-th roots of unity.

Roots of unity are essential for the Number Theoretic Transform (NTT), which enables efficient polynomial operations.

### Finding Roots of Unity

To find a primitive n-th root of unity when n divides p-1:

1. Find a generator g of F_p^*
2. Compute omega = g^((p-1)/n)

This omega is a primitive n-th root because:
- omega^n = g^(p-1) = 1
- omega^k != 1 for 0 < k < n (since g is primitive)

## Quadratic Residues

### Definition

An element a in F_p^* is a **quadratic residue** if there exists x such that:

```
x^2 = a mod p
```

If no such x exists, a is a **quadratic non-residue**.

### Euler's Criterion

For odd prime p and a != 0:

```
a^((p-1)/2) = 1   if a is a quadratic residue
a^((p-1)/2) = -1  if a is a quadratic non-residue
```

### Legendre Symbol

The Legendre symbol (a/p) is defined as:

```
(a/p) = 0  if a = 0
(a/p) = 1  if a is a quadratic residue
(a/p) = -1 if a is a quadratic non-residue
```

### Square Roots

When a is a quadratic residue, computing its square root depends on p mod 4:

**Case p = 3 mod 4**:
```
sqrt(a) = a^((p+1)/4) mod p
```

**Case p = 1 mod 4**:
Requires more complex algorithms like Tonelli-Shanks.

Square roots are needed for certain cryptographic operations and extension field arithmetic.

## Montgomery Representation

### Motivation

Standard modular multiplication requires division (or equivalently, remainder computation) by p. Montgomery representation replaces this expensive operation with simpler shifts and additions.

### The Representation

For a chosen R = 2^k > p (typically R = 2^64 for 64-bit fields), the Montgomery representation of a is:

```
a_mont = a * R mod p
```

### Montgomery Multiplication

To multiply two Montgomery-represented values:

```python
def mont_mul(a_mont, b_mont, p, R, p_inv):
    # p_inv = -p^(-1) mod R
    t = a_mont * b_mont
    m = ((t mod R) * p_inv) mod R
    u = (t + m * p) / R  # exact division
    if u >= p:
        u -= p
    return u  # = (a * b) * R mod p
```

The key insight is that division by R is just a right shift, which is much faster than division by p.

### Conversion

Converting to/from Montgomery form:

```
To Montgomery:   a_mont = a * R mod p = mont_mul(a, R^2 mod p)
From Montgomery: a = mont_mul(a_mont, 1)
```

When performing many field operations, the conversion overhead is amortized over multiple multiplications.

## Selecting a Prime for zkVMs

### Security Considerations

The prime must be large enough to provide cryptographic security:

- 128-bit security typically requires primes of at least 256 bits
- For STARKs, extension fields can boost security with smaller base primes
- The prime should not have known weaknesses

### Arithmetic Efficiency

Primes with special structure enable faster arithmetic:

**Pseudo-Mersenne primes**: p = 2^n - c for small c
- Reduction: `x mod p = (x mod 2^n) + c * (x / 2^n)` (approximately)
- Multiple reduction steps may be needed

**Goldilocks prime**: p = 2^64 - 2^32 + 1
- Fits in 64 bits
- Has a 2^32-order multiplicative subgroup for NTT
- Special form enables efficient reduction

**Montgomery-friendly primes**: p where p^(-1) mod 2^64 is simple

### NTT Compatibility

For efficient polynomial operations, p-1 should have large powers of 2 as factors:

```
p - 1 = 2^s * t  where s is large
```

This enables NTT over domains of size up to 2^s.

### Hardware Considerations

The prime should match target hardware:

- 64-bit primes for CPU efficiency
- Primes supporting vectorization (SIMD)
- Considerations for GPU implementation

## Implementation Patterns

### Lazy Reduction

Instead of reducing after every operation, allow values to grow slightly:

```python
def lazy_add(a, b, p):
    # Allow result up to 2p - 2
    return a + b  # Reduce later

def lazy_mul(a, b, p):
    # Reduce only when necessary
    result = a * b
    if result >= p * p:
        result %= p
    return result
```

Final reduction occurs before output or when overflow threatens.

### Parallel Field Operations

Many zkVM operations involve independent field computations that can be parallelized:

- SIMD vectorization for multiple field elements
- GPU kernels processing element arrays
- Multi-threaded batch operations

### Constant-Time Implementation

For cryptographic applications, operations should not leak timing information:

```python
def constant_time_select(condition, a, b):
    # Returns a if condition else b
    # Without branching
    mask = -condition  # All 1s if condition, all 0s otherwise
    return (a & mask) | (b & ~mask)
```

All field operations should complete in constant time regardless of operand values.

## Key Concepts

- **Prime field F_p**: Integers mod prime p with complete field arithmetic
- **Multiplicative group**: Non-zero elements form a cyclic group of order p-1
- **Generator**: Element whose powers yield all non-zero field elements
- **Root of unity**: Element omega where omega^n = 1
- **Montgomery form**: Representation enabling faster multiplication
- **Quadratic residue**: Element that has a square root in the field

## Design Considerations

### Prime Selection Trade-offs

| Property | Small Prime | Large Prime |
|----------|-------------|-------------|
| Base security | Lower (needs extension) | Higher |
| Arithmetic speed | Faster | Slower |
| Memory usage | Lower | Higher |
| NTT sizes | Limited | Flexible |

### When to Use Extensions

Extension fields may be preferable when:
- Base prime is too small for security
- Certain algebraic structures are needed
- Compatibility with elliptic curves requires it

### Montgomery vs. Standard Arithmetic

Use Montgomery when:
- Performing many multiplications in sequence
- Conversion overhead is acceptable
- Hardware supports efficient Montgomery reduction

Use standard arithmetic when:
- Operations are sparse
- Memory is severely constrained
- Simplicity is prioritized

## Related Topics

- [Goldilocks Field](02-goldilocks-field.md) - Detailed treatment of this specific prime
- [Extension Fields](03-extension-fields.md) - Building larger fields from prime fields
- [NTT and FFT](../02-polynomials/02-ntt-and-fft.md) - Using roots of unity for fast transforms
- [Polynomial Arithmetic](../02-polynomials/01-polynomial-arithmetic.md) - Operations over polynomial rings
