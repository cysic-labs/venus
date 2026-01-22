# Number Theoretic Transform and Fast Fourier Transform

## Overview

The Number Theoretic Transform (NTT) is the finite field analog of the Fast Fourier Transform (FFT). It enables polynomial evaluation and interpolation in O(n log n) time instead of O(n^2), making it one of the most critical algorithms for zkVM performance.

In proof systems that process traces with millions or billions of elements, the difference between O(n^2) and O(n log n) is the difference between impractical and practical. The NTT underlies virtually every polynomial operation in modern STARK implementations.

This document covers the theory behind NTT, its implementation, optimizations, and applications in zero-knowledge proofs.

## Mathematical Foundation

### Discrete Fourier Transform Concept

The Discrete Fourier Transform (DFT) evaluates a polynomial at n equally-spaced points on the unit circle. In finite fields, these points are roots of unity.

For a polynomial P(X) = sum_{i=0}^{n-1} a_i * X^i, the NTT computes:

```
P_j = P(omega^j) = sum_{i=0}^{n-1} a_i * omega^(i*j)  for j = 0, 1, ..., n-1
```

where omega is a primitive n-th root of unity.

### Roots of Unity

An n-th root of unity omega satisfies:
- omega^n = 1
- omega^k != 1 for 0 < k < n (primitive)

The set {omega^0, omega^1, ..., omega^(n-1)} forms a cyclic group of order n.

### Why Roots of Unity?

The structure of roots of unity enables the divide-and-conquer strategy:

**Key Property**: If omega is an n-th root of unity, then omega^2 is an (n/2)-th root of unity.

This allows recursively splitting the problem:
```
{omega^0, omega^1, ..., omega^(n-1)} splits into
{omega^0, omega^2, omega^4, ...} and {omega^1, omega^3, omega^5, ...}
```

## The Cooley-Tukey Algorithm

### Algorithm Structure

The FFT/NTT algorithm splits the polynomial into even and odd coefficient polynomials:

```
P(X) = P_even(X^2) + X * P_odd(X^2)
```

where:
- P_even has coefficients a_0, a_2, a_4, ...
- P_odd has coefficients a_1, a_3, a_5, ...

### Butterfly Operation

The core operation combines results from recursive calls:

```
For j = 0 to n/2 - 1:
    t = omega^j * odd[j]
    result[j] = even[j] + t
    result[j + n/2] = even[j] - t
```

This is called a "butterfly" due to its shape in data flow diagrams:

```
even[j]  ----+----> result[j]
              \  /
               \/
               /\
              /  \
odd[j]*w ----+----> result[j + n/2]
```

### Recursive Implementation

```python
def ntt_recursive(a, omega, p):
    n = len(a)
    if n == 1:
        return a

    # Split into even and odd
    a_even = a[0::2]
    a_odd = a[1::2]

    # Recurse with omega^2 (n/2-th root of unity)
    omega_sq = (omega * omega) % p
    y_even = ntt_recursive(a_even, omega_sq, p)
    y_odd = ntt_recursive(a_odd, omega_sq, p)

    # Combine with butterfly
    y = [0] * n
    w = 1
    for j in range(n // 2):
        t = (w * y_odd[j]) % p
        y[j] = (y_even[j] + t) % p
        y[j + n // 2] = (y_even[j] - t) % p
        w = (w * omega) % p

    return y
```

### Iterative Implementation

Iterative NTT avoids recursion overhead:

```python
def ntt_iterative(a, omega, p):
    n = len(a)

    # Bit-reversal permutation
    j = 0
    for i in range(1, n):
        bit = n >> 1
        while j & bit:
            j ^= bit
            bit >>= 1
        j ^= bit
        if i < j:
            a[i], a[j] = a[j], a[i]

    # Butterfly stages
    length = 2
    while length <= n:
        w_len = pow(omega, n // length, p)
        for i in range(0, n, length):
            w = 1
            for j in range(length // 2):
                t = (w * a[i + j + length // 2]) % p
                a[i + j + length // 2] = (a[i + j] - t) % p
                a[i + j] = (a[i + j] + t) % p
                w = (w * w_len) % p
        length *= 2

    return a
```

## Inverse NTT

### Definition

The inverse NTT (INTT) converts evaluations back to coefficients:

```
a_i = (1/n) * sum_{j=0}^{n-1} P_j * omega^(-i*j)
```

### Implementation

INTT is nearly identical to NTT:
1. Use omega^(-1) instead of omega
2. Scale result by n^(-1)

```python
def intt(y, omega, p):
    n = len(y)
    omega_inv = pow(omega, p - 2, p)  # omega^(-1) mod p
    n_inv = pow(n, p - 2, p)  # n^(-1) mod p

    # Forward NTT with inverse omega
    a = ntt_iterative(y.copy(), omega_inv, p)

    # Scale by 1/n
    return [(x * n_inv) % p for x in a]
```

### Verification

NTT and INTT are inverses:
```
INTT(NTT(a)) = a
NTT(INTT(y)) = y
```

## Complexity Analysis

### Time Complexity

The NTT has O(n log n) complexity:
- log n levels of recursion/iteration
- O(n) work per level
- Total: O(n log n) field operations

Each field operation involves:
- 2 additions (or subtractions)
- 1 multiplication
- Per butterfly operation

### Space Complexity

In-place NTT: O(1) extra space (modifying input array)
Out-of-place NTT: O(n) space for output

### Comparison with Naive Evaluation

| Method | Evaluation | Interpolation |
|--------|-----------|---------------|
| Naive | O(n^2) | O(n^2) |
| NTT-based | O(n log n) | O(n log n) |

For n = 2^20 (about 1 million points):
- Naive: ~10^12 operations
- NTT: ~20 million operations
- Speedup: ~50,000x

## Twiddle Factors

### Definition

Twiddle factors are the powers of omega used in butterfly operations:

```
W_n^k = omega^k for k = 0, 1, ..., n/2 - 1
```

### Precomputation

Computing twiddle factors on-the-fly is expensive. Precompute and store them:

```python
def precompute_twiddles(omega, n, p):
    twiddles = [1]
    w = omega
    for _ in range(n // 2 - 1):
        twiddles.append(w)
        w = (w * omega) % p
    return twiddles
```

### Memory-Computation Trade-off

| Strategy | Memory | Computation |
|----------|--------|-------------|
| Full precompute | O(n) | Fastest |
| Partial precompute | O(sqrt(n)) | Moderate |
| On-the-fly | O(1) | Slowest |

For large NTTs, a hybrid approach often works best.

## Coset NTT

### Motivation

Sometimes evaluation is needed not on {omega^0, ..., omega^(n-1)} but on a coset {g*omega^0, ..., g*omega^(n-1)}.

### Implementation

Coset NTT can be computed by:
1. Multiply coefficients by powers of g
2. Perform standard NTT

```python
def ntt_coset(a, omega, g, p):
    n = len(a)
    # Multiply by g^i
    g_power = 1
    a_shifted = []
    for i in range(n):
        a_shifted.append((a[i] * g_power) % p)
        g_power = (g_power * g) % p

    # Standard NTT
    return ntt(a_shifted, omega, p)
```

### Inverse Coset NTT

```python
def intt_coset(y, omega, g, p):
    n = len(y)
    # Standard INTT
    a_shifted = intt(y, omega, p)

    # Divide by g^i (multiply by g^(-i))
    g_inv = pow(g, p - 2, p)
    g_power = 1
    a = []
    for i in range(n):
        a.append((a_shifted[i] * g_power) % p)
        g_power = (g_power * g_inv) % p

    return a
```

## Polynomial Multiplication via NTT

### Algorithm

To multiply polynomials P and Q of degree < n:

```python
def poly_mul_ntt(p, q, omega, p_mod):
    # Pad to length 2n (product has degree up to 2n-2)
    n = 1
    while n < len(p) + len(q):
        n *= 2

    p_padded = p + [0] * (n - len(p))
    q_padded = q + [0] * (n - len(q))

    # Find appropriate root of unity for size n
    omega_n = pow(omega, original_n // n, p_mod)

    # Transform to evaluation form
    p_evals = ntt(p_padded, omega_n, p_mod)
    q_evals = ntt(q_padded, omega_n, p_mod)

    # Pointwise multiply
    r_evals = [(p_evals[i] * q_evals[i]) % p_mod for i in range(n)]

    # Transform back to coefficient form
    return intt(r_evals, omega_n, p_mod)
```

### Complexity

- 3 NTTs of size 2n: O(n log n)
- n pointwise multiplications: O(n)
- Total: O(n log n)

Compared to O(n^2) naive multiplication.

## Low Degree Extension (LDE)

### Concept

Low Degree Extension extends a polynomial's evaluation domain:
- Given evaluations on domain D of size n
- Compute evaluations on larger domain D' of size m > n

### Algorithm

```python
def low_degree_extend(evals, omega_n, omega_m, m, p):
    n = len(evals)

    # Convert to coefficients (degree < n polynomial)
    coeffs = intt(evals, omega_n, p)

    # Pad with zeros to length m
    coeffs_extended = coeffs + [0] * (m - n)

    # Evaluate on larger domain
    return ntt(coeffs_extended, omega_m, p)
```

### Use in Proofs

LDE is crucial for:
- Computing constraint polynomials on extended domains
- Generating FRI query responses
- Ensuring sufficient "randomness" in evaluation points

## Optimizations

### Mixed-Radix NTT

For n not a power of 2, use mixed-radix factorization:

If n = n_1 * n_2:
1. View input as n_1 x n_2 matrix
2. Apply NTT of size n_2 to each row
3. Multiply by twiddle factors
4. Apply NTT of size n_1 to each column

Enables NTT for any n with smooth factorization.

### Unrolling and SIMD

Modern implementations heavily optimize inner loops:

```c
// Pseudocode for SIMD butterfly
void butterfly_simd(field_t* a, field_t* b, field_t w, int count) {
    for (int i = 0; i < count; i += SIMD_WIDTH) {
        vec_t va = load_vec(&a[i]);
        vec_t vb = load_vec(&b[i]);
        vec_t vw = broadcast(w);

        vec_t t = field_mul_vec(vb, vw);
        store_vec(&a[i], field_add_vec(va, t));
        store_vec(&b[i], field_sub_vec(va, t));
    }
}
```

### Cache-Friendly Access

NTT access patterns can cause cache misses. Techniques:
- **Four-step NTT**: Restructure for sequential access
- **Bailey's algorithm**: Cache-oblivious approach
- **Blocking**: Process cache-sized chunks together

### GPU Implementation

NTTs parallelize well on GPUs:
- Each butterfly is independent within a stage
- High parallelism at each level
- Memory bandwidth often the bottleneck

## Applications in zkVMs

### Trace Polynomial Operations

Execution traces are encoded as polynomials:
- Trace values -> NTT -> Polynomial coefficients
- Constraint evaluation uses NTT on extended domains

### Commitment Computation

Merkle tree leaves are often polynomial evaluations:
- Evaluate trace polynomials on LDE domain via NTT
- Hash evaluations to form Merkle tree

### FRI Protocol

FRI repeatedly folds polynomials:
- Each fold involves NTT/INTT operations
- Efficiency crucial for prover performance

### Quotient Polynomial

Computing C(X) / Z(X):
- Evaluate C on coset via coset NTT
- Divide by Z (constant on coset)
- Get quotient evaluations

## Key Concepts

- **NTT**: O(n log n) polynomial evaluation at roots of unity
- **INTT**: Inverse transform, recovers coefficients from evaluations
- **Butterfly**: Basic combining operation in NTT algorithm
- **Twiddle factors**: Powers of omega used in butterflies
- **Coset NTT**: Evaluation on shifted domain
- **LDE**: Extending evaluations to larger domain

## Design Considerations

### Domain Size Selection

Choose n as power of 2 for simplest implementation:
- Trace length rounded up to power of 2
- LDE factor typically 2-8x
- Balance between proof size and prover cost

### Root of Unity Availability

Field must support required NTT sizes:
- p - 1 must be divisible by largest needed n
- Goldilocks: supports up to n = 2^32
- BN254 scalar: limited 2-adic subgroup

### Memory vs Speed

| Approach | Memory | Speed |
|----------|--------|-------|
| Store all twiddles | O(n) | Fastest |
| Compute on-the-fly | O(1) | Slower |
| Cache hierarchically | O(sqrt(n)) | Balanced |

### Parallelization Strategy

- **Fine-grained**: Parallelize individual butterflies
- **Coarse-grained**: Parallelize independent NTTs
- **Hybrid**: Both levels of parallelism

## Related Topics

- [Polynomial Arithmetic](01-polynomial-arithmetic.md) - Basic polynomial operations
- [Polynomial Commitments](03-polynomial-commitments.md) - Committing via polynomial evaluations
- [Goldilocks Field](../01-finite-fields/02-goldilocks-field.md) - Field supporting large NTT domains
- [FRI Fundamentals](../../02-stark-proving-system/03-fri-protocol/01-fri-fundamentals.md) - Heavy NTT user
