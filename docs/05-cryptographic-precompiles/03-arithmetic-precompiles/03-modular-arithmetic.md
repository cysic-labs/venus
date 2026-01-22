# Modular Arithmetic

## Overview

Modular arithmetic forms the foundation of elliptic curve cryptography and many other cryptographic operations. Operations are performed modulo a prime p, ensuring results remain within a finite field. The zkVM must efficiently prove modular addition, subtraction, multiplication, and inversion for various prime moduli.

Unlike integer arithmetic where results can grow arbitrarily large, modular arithmetic constrains results to a fixed range. This requires proving not just that an operation was performed correctly, but that the result was properly reduced modulo the prime. The choice of reduction method significantly impacts constraint efficiency.

This document covers modular arithmetic representations, reduction techniques, and constraint formulations for field operations.

## Modular Fundamentals

### Field Definition

Working in a prime field:

```
Prime field F_p:
  Elements: {0, 1, 2, ..., p-1}
  Operations: +, -, ×, ÷ (mod p)

Properties:
  Closed under operations
  Unique inverses for non-zero elements
  Characteristic p
```

### Common Moduli

Important primes in cryptography:

```
secp256k1 field prime:
  p = 2^256 - 2^32 - 977

BN254 base field:
  p = 21888242871839275222246405745257275088696311157297823662689037894645226208583

BLS12-381 base field:
  p = (381-bit prime)

Goldilocks:
  p = 2^64 - 2^32 + 1
```

## Modular Addition

### Addition with Reduction

Adding mod p:

```
a + b mod p:
  sum = a + b
  If sum >= p: result = sum - p
  Else: result = sum

Since a, b < p:
  sum < 2p
  At most one subtraction needed
```

### Addition Constraints

Proving modular addition:

```
Constraint approach:
  result = a + b - reduce * p

Where:
  reduce ∈ {0, 1}
  If reduce = 0: a + b < p
  If reduce = 1: a + b >= p

Range constraints:
  result ∈ [0, p)
  Proves correct reduction
```

### Efficient Reduction Check

Determining if reduction needed:

```
Comparison constraint:
  If a + b >= p, then a + b - p < p

Constraint:
  a + b = result + reduce * p
  reduce is binary
  result < p
```

## Modular Subtraction

### Subtraction with Borrowing

Subtracting mod p:

```
a - b mod p:
  If a >= b: result = a - b
  If a < b: result = a - b + p = p - (b - a)

Single addition of p may be needed
```

### Subtraction Constraints

Proving modular subtraction:

```
Constraint:
  result = a - b + borrow * p

Where:
  borrow ∈ {0, 1}
  If borrow = 0: a >= b
  If borrow = 1: a < b

Range:
  result ∈ [0, p)
```

## Modular Multiplication

### Multiplication with Reduction

Multiplying mod p:

```
a × b mod p:
  product = a × b (up to 2n bits for n-bit operands)
  result = product mod p

Reduction:
  product = q × p + result
  Where 0 <= result < p
```

### Direct Reduction

Proving multiplication with reduction:

```
Constraints:
  product = a × b (in extended width)
  product = q × p + result
  result < p

Where:
  product needs 2n-bit representation
  q is quotient
  result is reduced value
```

### Montgomery Multiplication

Efficient repeated multiplication:

```
Montgomery form:
  x' = x × R mod p
  Where R = 2^n for n-bit modulus

Montgomery multiply:
  MonMul(a', b') = a × b × R mod p = (a × b)' / R × R = ...
  Result is in Montgomery form

Benefit:
  Avoids explicit reduction by p
  Reduction via addition
```

### Montgomery Reduction

The REDC operation:

```
REDC(T):
  m = (T mod R) × p' mod R
  t = (T + m × p) / R
  If t >= p: return t - p
  Else: return t

Where:
  p' = -p^{-1} mod R
  T is up to 2n-bit value
```

### Montgomery Constraints

Proving Montgomery multiplication:

```
For MonMul(a, b):
  T = a × b
  m = (T mod R) × p' mod R
  t = (T + m × p) / R
  result = t - reduce × p

Constraints:
  Multiplication for T
  Lower limbs for m
  Division by R (shift)
  Conditional subtraction
```

## Modular Inversion

### Extended Euclidean Algorithm

Computing a^{-1} mod p:

```
Find x such that:
  a × x ≡ 1 (mod p)

Approach:
  Extended GCD of a and p
  Finds x, y where ax + py = gcd(a,p) = 1
  So ax ≡ 1 (mod p)
```

### Inversion Constraint

Proving inversion correct:

```
For a^{-1} mod p:
  Claim: inv is inverse of a

Constraint:
  a × inv ≡ 1 (mod p)
  a × inv = k × p + 1 for some k

Verification:
  Multiply and reduce
  Check result is 1
```

### Fermat's Little Theorem

Alternative inversion:

```
For prime p:
  a^{-1} = a^{p-2} mod p

Implementation:
  Exponentiation
  Square-and-multiply
  Many multiplications
```

## Special Modulus Optimization

### Mersenne-Like Primes

Primes with special structure:

```
Form: p = 2^n - c for small c

Reduction:
  For x < 2^{2n}:
  x = x_hi × 2^n + x_lo
  x mod p = x_lo + x_hi × c (approximately)
  May need one more reduction

Example:
  Goldilocks: p = 2^64 - 2^32 + 1
  Fast reduction possible
```

### Pseudo-Mersenne

Primes near powers of two:

```
secp256k1: p = 2^256 - 2^32 - 977

Reduction:
  Overflow × (2^32 + 977)
  Efficient computation
```

### General Primes

No special structure:

```
Barrett reduction:
  Precompute mu = floor(2^{2n} / p)
  q ≈ floor((x × mu) / 2^{2n})
  r = x - q × p
  Adjust if needed
```

## Field Operations

### Field Addition

Complete field addition:

```
F_p.add(a, b):
  Precondition: a, b ∈ [0, p)
  result = a + b mod p
  Postcondition: result ∈ [0, p)
```

### Field Subtraction

Complete field subtraction:

```
F_p.sub(a, b):
  Precondition: a, b ∈ [0, p)
  result = a - b mod p
  Postcondition: result ∈ [0, p)
```

### Field Multiplication

Complete field multiplication:

```
F_p.mul(a, b):
  Precondition: a, b ∈ [0, p)
  result = a × b mod p
  Postcondition: result ∈ [0, p)
```

### Field Division

Complete field division:

```
F_p.div(a, b):
  Precondition: a, b ∈ [0, p), b ≠ 0
  result = a × b^{-1} mod p
  Postcondition: result ∈ [0, p)
```

## Constraint Optimization

### Lazy Reduction

Deferring reduction:

```
Strategy:
  Perform multiple adds without reduction
  Reduce once at end
  If sum < k × p, can add k times

Benefit:
  Fewer reduction constraints
  Batch reductions
```

### Combined Operations

Fusing operations:

```
a × b + c × d mod p:
  Compute products
  Add (may exceed p)
  Single reduction at end

Constraint:
  a × b + c × d = q × p + result
```

### Precomputed Tables

Lookup for common operations:

```
Tables:
  Reduction constants
  Common multiplications
  Inversion for small values
```

## Precompile Interface

### Input Specification

Field operation inputs:

```
Inputs:
  Field elements a, b
  Modulus p (or implicit)
  Operation type

Format:
  Elements as big integers
  Reduced mod p
```

### Output Specification

Field operation outputs:

```
Output:
  Field element result
  In [0, p)

Format:
  Same as input format
```

## Key Concepts

- **Modular reduction**: Constraining results to [0, p)
- **Montgomery form**: Efficient multiplication representation
- **Lazy reduction**: Deferring reduction for efficiency
- **Special moduli**: Exploiting prime structure
- **Field operations**: Complete arithmetic in F_p

## Design Trade-offs

### Reduction Method

| Direct | Montgomery |
|--------|------------|
| Simple | Complex setup |
| Per-operation | Amortized |
| Good for few ops | Good for many ops |

### Modulus Handling

| Fixed Modulus | Variable Modulus |
|---------------|------------------|
| Optimized circuit | General circuit |
| No flexibility | Full flexibility |
| Lower constraints | Higher constraints |

## Related Topics

- [256-bit Arithmetic](01-256-bit-arithmetic.md) - Integer operations
- [384-bit Arithmetic](02-384-bit-arithmetic.md) - Larger integers
- [secp256k1 Operations](../04-elliptic-curve-precompiles/01-secp256k1-operations.md) - Curve field
- [Constraint Representation](../01-precompile-design/02-constraint-representation.md) - Encoding techniques

