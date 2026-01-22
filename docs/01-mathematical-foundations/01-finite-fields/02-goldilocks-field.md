# The Goldilocks Field

## Overview

The Goldilocks field is a prime field that has become popular for zero-knowledge proof systems due to its unique combination of properties. Defined by the prime p = 2^64 - 2^32 + 1, it offers efficient 64-bit arithmetic while supporting large NTT domains necessary for polynomial-based proof systems.

The name "Goldilocks" reflects its position as "just right" - large enough for practical security when combined with extension fields, yet small enough for efficient implementation on modern 64-bit processors. This balance makes it particularly suitable for zkVM implementations where both prover performance and proof soundness are critical.

This document explores the Goldilocks field's properties, efficient arithmetic techniques, and its role in zkVM implementations.

## The Goldilocks Prime

### Definition

The Goldilocks prime is:

```
p = 2^64 - 2^32 + 1 = 18446744069414584321
```

In hexadecimal:
```
p = 0xFFFFFFFF00000001
```

### Special Form

The prime has the form 2^64 - 2^32 + 1, which can be written as:

```
p = (2^32)^2 - 2^32 + 1
```

This factors interestingly:
```
p - 1 = 2^64 - 2^32 = 2^32 * (2^32 - 1) = 2^32 * 0xFFFFFFFF
```

### Primality

Verifying that p is prime:
- p is not divisible by small primes (2, 3, 5, 7, ...)
- Miller-Rabin primality testing confirms primality
- p has been extensively verified in cryptographic literature

## Multiplicative Group Structure

### Order

The multiplicative group F_p^* has order:

```
|F_p^*| = p - 1 = 2^64 - 2^32 = 2^32 * (2^32 - 1)
```

### Factorization

The factorization of p - 1:

```
p - 1 = 2^32 * 3 * 5 * 17 * 257 * 65537
```

The factor of 2^32 is crucial - it means the field supports NTT domains of size up to 2^32, which is approximately 4 billion elements. This is sufficient for virtually any practical zkVM trace length.

### Roots of Unity

For n = 2^k where k <= 32, the field contains primitive n-th roots of unity.

To find the primitive 2^32-th root of unity:
1. Find a generator g of F_p^*
2. Compute omega_32 = g^((p-1)/2^32) = g^(2^32 - 1)

For smaller NTT sizes, compute:
```
omega_k = omega_32^(2^(32-k))  for k <= 32
```

### Generator

A generator of the multiplicative group is any element whose multiplicative order is p-1. The value 7 is commonly used:

```
g = 7 is a generator of F_p^*
```

This can be verified by checking that 7^((p-1)/q) != 1 for each prime factor q of p-1.

## Efficient Arithmetic

### Reduction Strategy

The special form of p enables efficient modular reduction. For a value x that may exceed p, reduction exploits:

```
2^64 = 2^32 - 1  (mod p)
```

Given x = x_hi * 2^64 + x_lo where x_lo < 2^64:

```
x mod p = x_lo + x_hi * (2^32 - 1) mod p
        = x_lo + x_hi * 2^32 - x_hi mod p
```

If the result exceeds p, subtract p once or twice.

### Addition

Addition of two field elements a, b < p:

```python
def goldilocks_add(a, b):
    # a, b are 64-bit values less than p
    result = a + b
    # Result could be up to 2p - 2
    if result >= GOLDILOCKS_P:
        result -= GOLDILOCKS_P
    return result
```

The conditional subtraction can be made branchless for constant-time execution.

### Subtraction

```python
def goldilocks_sub(a, b):
    if a >= b:
        return a - b
    else:
        return GOLDILOCKS_P - (b - a)
```

Or using two's complement arithmetic:
```python
def goldilocks_sub(a, b):
    result = a - b
    # If underflow occurred, add p
    mask = -(result >> 63)  # All 1s if negative
    return result + (GOLDILOCKS_P & mask)
```

### Multiplication

Multiplication produces a 128-bit intermediate result that must be reduced:

```python
def goldilocks_mul(a, b):
    # Compute 128-bit product
    product = a * b  # Needs 128-bit arithmetic

    # Split into high and low 64-bit parts
    lo = product & ((1 << 64) - 1)
    hi = product >> 64

    # Apply reduction: 2^64 = 2^32 - 1 (mod p)
    # product mod p = lo + hi * (2^32 - 1)

    hi_lo = hi & ((1 << 32) - 1)
    hi_hi = hi >> 32

    # Compute: lo + hi*2^32 - hi
    result = lo - hi
    carry = result > lo  # Underflow

    result += hi << 32
    if result < (hi << 32):  # Overflow
        carry -= 1

    # Handle carry (could be -1, 0, or 1)
    if carry > 0:
        result -= GOLDILOCKS_P
    elif carry < 0:
        result += GOLDILOCKS_P

    # Final reduction if needed
    if result >= GOLDILOCKS_P:
        result -= GOLDILOCKS_P

    return result
```

### Inversion

Using Fermat's little theorem:
```
a^(-1) = a^(p-2) mod p
```

The exponent p - 2 = 2^64 - 2^32 - 1 has a specific bit pattern that enables an optimized addition chain.

A more efficient approach uses the extended Euclidean algorithm, which requires approximately log(p) iterations.

### Square Root

Since p = 1 mod 4, computing square roots requires the Tonelli-Shanks algorithm or a variant optimized for this specific prime.

```
p - 1 = 2^32 * q where q = 2^32 - 1
```

The large power of 2 (s = 32) makes Tonelli-Shanks moderately expensive, but square roots are rarely needed in performance-critical paths.

## Field Extensions

### Why Extend?

The 64-bit Goldilocks field provides about 64 bits of security against algebraic attacks. For 128-bit security, quadratic or cubic extensions are used.

### Quadratic Extension

The quadratic extension F_p^2 is constructed as:

```
F_p^2 = F_p[X] / (X^2 - D)
```

where D is a quadratic non-residue in F_p. Elements are pairs (a, b) representing a + b*X.

Arithmetic:
- Addition: (a, b) + (c, d) = (a + c, b + d)
- Multiplication: (a, b) * (c, d) = (a*c + D*b*d, a*d + b*c)

A common choice for Goldilocks is D = 7, since 7 is a quadratic non-residue.

### Cubic Extension

For higher security or specific algebraic requirements, cubic extensions F_p^3 can be constructed using an irreducible cubic polynomial.

## NTT in Goldilocks

### Domain Structure

For an NTT of size n = 2^k (k <= 32), the domain consists of:

```
{omega^0, omega^1, omega^2, ..., omega^(n-1)}
```

where omega is a primitive n-th root of unity.

### Twiddle Factors

Twiddle factors for the NTT are powers of omega:
```
W_n^i = omega^i for i = 0, 1, ..., n/2 - 1
```

These can be precomputed and cached for repeated NTTs of the same size.

### Cosets for LDE

Low-Degree Extension (LDE) requires evaluating polynomials on cosets of the NTT domain. For a coset generator g:

```
Coset = {g*omega^0, g*omega^1, ..., g*omega^(n-1)}
```

The Goldilocks field supports many coset choices due to its large multiplicative group.

## Hardware Considerations

### 64-bit CPU Optimization

Goldilocks fits perfectly in 64-bit registers:
- All field elements use exactly one 64-bit word
- Addition/subtraction are single operations plus conditional correction
- Multiplication uses hardware 64x64->128-bit multiply

### SIMD Vectorization

Modern CPUs support SIMD operations on multiple 64-bit values:
- AVX2: 4 parallel 64-bit operations
- AVX-512: 8 parallel 64-bit operations

Goldilocks arithmetic vectorizes naturally:
```
// Pseudocode for vectorized addition
for i in parallel:
    result[i] = a[i] + b[i]
    if result[i] >= p:
        result[i] -= p
```

### GPU Implementation

Goldilocks is well-suited for GPU implementation:
- 64-bit arithmetic is native on modern GPUs
- NTT parallelizes across thousands of threads
- Memory coalescing works well with 64-bit elements

## Comparison with Other Fields

### vs. BN254 Scalar Field

| Property | Goldilocks | BN254 Scalar |
|----------|------------|--------------|
| Size | 64 bits | 254 bits |
| Base security | ~64 bits | ~128 bits |
| Multiplication | Very fast | Slower |
| NTT domain | Up to 2^32 | Limited |
| Typical use | STARK proofs | SNARK proofs |

### vs. BLS12-381 Scalar Field

| Property | Goldilocks | BLS12-381 Scalar |
|----------|------------|------------------|
| Size | 64 bits | 255 bits |
| Arithmetic speed | Faster | Slower |
| Extension needed | Yes (for security) | No |
| Pairing support | Via extension | Native |

### vs. Mersenne Prime 2^31 - 1

| Property | Goldilocks | Mersenne31 |
|----------|------------|------------|
| Size | 64 bits | 31 bits |
| Security | Higher | Lower |
| NTT domain | Up to 2^32 | Up to 2^31 |
| Integer ops | More natural | Requires masking |

## Security Analysis

### Base Field Security

Discrete logarithm in F_p with 64-bit p can be solved in approximately 2^32 operations using Pollard's rho algorithm. This is insufficient for cryptographic security.

### Extension Field Security

In F_p^2 (128-bit extension), discrete logarithm requires approximately 2^64 operations, approaching practical security levels.

In F_p^3 (192-bit extension), security exceeds 2^96 operations, providing comfortable security margins.

### STARK Security Model

STARKs rely on the hardness of finding low-degree polynomials that satisfy random constraints. Security analysis considers:
- Field size (determines collision resistance)
- Number of queries (affects soundness)
- Degree bounds (controls polynomial space)

With appropriate parameters, Goldilocks-based STARKs achieve 100+ bits of security.

## Key Concepts

- **Goldilocks prime**: p = 2^64 - 2^32 + 1, specially structured for efficiency
- **2^32 multiplicative subgroup**: Enables large NTT domains for polynomial operations
- **Fast reduction**: Special form allows efficient modular reduction
- **Extension fields**: Required for full cryptographic security
- **Hardware alignment**: Perfect fit for 64-bit CPU architectures

## Design Considerations

### Choosing Goldilocks

Goldilocks is ideal when:
- Prover performance is critical
- Large polynomial degrees are needed
- Target hardware is 64-bit CPUs or GPUs
- STARKs are the proof system
- Extension fields are acceptable for security

### Alternative Choices

Consider alternatives when:
- Native 128-bit security is required without extensions
- Pairing operations are needed
- Compatibility with existing SNARK systems is important
- 32-bit platforms are targets

### Implementation Tips

1. **Precompute twiddle factors**: NTT performance depends on fast access to roots of unity
2. **Use lazy reduction**: Delay full reduction when chaining operations
3. **Vectorize aggressively**: Goldilocks arithmetic parallelizes well
4. **Profile reduction**: The specific reduction sequence matters for performance

## Related Topics

- [Prime Fields](01-prime-fields.md) - General prime field theory
- [Extension Fields](03-extension-fields.md) - Building secure extensions
- [NTT and FFT](../02-polynomials/02-ntt-and-fft.md) - Fast polynomial transforms
- [FRI Protocol](../../02-stark-proving-system/03-fri-protocol/01-fri-fundamentals.md) - How Goldilocks enables efficient FRI
