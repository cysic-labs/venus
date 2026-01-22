# Polynomial Arithmetic

## Overview

Polynomials are the central data structure in zero-knowledge proof systems. Every computation trace, constraint, and intermediate value is ultimately represented as a polynomial or an evaluation of polynomials. Understanding polynomial arithmetic over finite fields is essential for implementing and optimizing zkVM systems.

This document covers polynomial representation, basic operations, and the algorithms that make polynomial manipulation efficient. The focus is on univariate polynomials over finite fields, though the concepts extend to multivariate settings.

Efficient polynomial arithmetic directly impacts prover performance - proof generation time scales with the cost of polynomial operations on traces that may contain billions of elements.

## Polynomial Representation

### Coefficient Form

The most natural representation of a polynomial is by its coefficients:

```
P(X) = a_0 + a_1*X + a_2*X^2 + ... + a_{n-1}*X^{n-1}
```

Stored as an array: `[a_0, a_1, a_2, ..., a_{n-1}]`

Properties:
- **Degree**: n - 1 (assuming a_{n-1} != 0)
- **Size**: n coefficients
- **Uniqueness**: Unique representation for each polynomial

### Evaluation Form

Alternatively, a polynomial of degree less than n can be represented by its values at n distinct points:

```
{(x_0, P(x_0)), (x_1, P(x_1)), ..., (x_{n-1}, P(x_{n-1}))}
```

Stored as: `[P(x_0), P(x_1), ..., P(x_{n-1})]` (assuming fixed evaluation points)

Properties:
- **Uniqueness**: n points uniquely determine a degree < n polynomial
- **Operations**: Pointwise addition/multiplication
- **Conversion**: Via interpolation and evaluation transforms

### Choosing Representation

| Operation | Coefficient Form | Evaluation Form |
|-----------|-----------------|-----------------|
| Addition | O(n) | O(n) |
| Multiplication | O(n^2) naive | O(n) pointwise |
| Evaluation at point | O(n) | Requires interpolation |
| Degree check | O(1) | O(n) |

The optimal representation depends on the operations needed. Transform between representations as appropriate.

## Basic Operations

### Addition

Addition is straightforward in both representations:

**Coefficient form**:
```python
def poly_add(p, q):
    result = [0] * max(len(p), len(q))
    for i in range(len(p)):
        result[i] = (result[i] + p[i]) % MODULUS
    for i in range(len(q)):
        result[i] = (result[i] + q[i]) % MODULUS
    return result
```

**Evaluation form**: Pointwise addition of values.

Both require O(n) field operations.

### Scalar Multiplication

Multiplying by a constant:

```python
def poly_scale(p, c):
    return [(coef * c) % MODULUS for coef in p]
```

O(n) field multiplications.

### Polynomial Multiplication

Naive multiplication is O(n^2):

```python
def poly_mul_naive(p, q):
    result = [0] * (len(p) + len(q) - 1)
    for i in range(len(p)):
        for j in range(len(q)):
            result[i + j] = (result[i + j] + p[i] * q[j]) % MODULUS
    return result
```

For large polynomials, use NTT-based multiplication in O(n log n).

In evaluation form, multiplication is pointwise:

```python
def poly_mul_eval(p_evals, q_evals):
    return [(p_evals[i] * q_evals[i]) % MODULUS for i in range(len(p_evals))]
```

Note: Product degree may exceed n-1, requiring evaluation on a larger domain.

### Division with Remainder

For polynomials P and D (D != 0), compute Q and R such that:

```
P = Q * D + R  where deg(R) < deg(D)
```

Algorithm (long division):

```python
def poly_divmod(p, d):
    # p = q * d + r
    q = [0] * (len(p) - len(d) + 1)
    r = p.copy()

    d_lead = d[-1]
    d_lead_inv = field_inv(d_lead)

    for i in range(len(p) - len(d), -1, -1):
        if len(r) > i + len(d) - 1:
            coef = (r[i + len(d) - 1] * d_lead_inv) % MODULUS
            q[i] = coef
            for j in range(len(d)):
                r[i + j] = (r[i + j] - coef * d[j]) % MODULUS

    # Trim leading zeros from r
    while r and r[-1] == 0:
        r.pop()

    return q, r
```

Complexity: O(n * m) where n = deg(P), m = deg(D).

### Evaluation at a Point

Horner's method evaluates P(x) efficiently:

```python
def poly_eval(p, x):
    result = 0
    for coef in reversed(p):
        result = (result * x + coef) % MODULUS
    return result
```

O(n) field operations, which is optimal for single-point evaluation.

### Multi-Point Evaluation

Evaluating at many points naively costs O(n * m) for n coefficients and m points.

Better approaches:
- **NTT**: If evaluation points form a multiplicative subgroup, O(n log n)
- **Subproduct trees**: For general points, O(n log^2 n)

## Interpolation

### Lagrange Interpolation

Given n points {(x_i, y_i)}, find the unique polynomial P of degree < n passing through all points.

The Lagrange basis polynomial for point i:

```
L_i(X) = product_{j != i} (X - x_j) / (x_i - x_j)
```

Properties:
- L_i(x_i) = 1
- L_i(x_j) = 0 for j != i

The interpolating polynomial:

```
P(X) = sum_i y_i * L_i(X)
```

### Implementation

```python
def lagrange_interpolate(points, x):
    # points = [(x_0, y_0), (x_1, y_1), ...]
    # Returns P(x) where P interpolates the points

    result = 0
    for i, (x_i, y_i) in enumerate(points):
        # Compute L_i(x)
        numer = 1
        denom = 1
        for j, (x_j, _) in enumerate(points):
            if i != j:
                numer = (numer * (x - x_j)) % MODULUS
                denom = (denom * (x_i - x_j)) % MODULUS

        L_i = (numer * field_inv(denom)) % MODULUS
        result = (result + y_i * L_i) % MODULUS

    return result
```

Naive complexity: O(n^2) field operations.

### Fast Interpolation via NTT

When evaluation points are roots of unity, interpolation is an inverse NTT:

```
coefficients = INTT(evaluations)
```

This achieves O(n log n) complexity, essential for large polynomials.

## The Vanishing Polynomial

### Definition

The vanishing polynomial for a set S = {s_0, s_1, ..., s_{n-1}} is:

```
Z_S(X) = (X - s_0)(X - s_1)...(X - s_{n-1})
```

Z_S(x) = 0 if and only if x is in S.

### Special Cases

**Roots of unity domain**: If S = {omega^0, omega^1, ..., omega^{n-1}} where omega is a primitive n-th root of unity:

```
Z_S(X) = X^n - 1
```

This simple form makes evaluation trivial and enables efficient operations.

**Coset domain**: If S = {g*omega^0, g*omega^1, ..., g*omega^{n-1}}:

```
Z_S(X) = X^n - g^n
```

### Use in Proofs

Vanishing polynomials encode constraint satisfaction:

If constraint C(trace) = 0 must hold at all points in domain S, then:
- C(X) is divisible by Z_S(X)
- Prover computes quotient Q(X) = C(X) / Z_S(X)
- Verifier checks divisibility at random points

## Quotient Polynomials

### Concept

When a polynomial P(X) equals zero at all points in set S, it must be divisible by Z_S(X):

```
P(X) = Q(X) * Z_S(X)
```

The quotient Q(X) has degree deg(P) - |S|.

### Computing Quotients

For roots of unity domain where Z(X) = X^n - 1:

```python
def compute_quotient(p_evals, omega, n):
    # p_evals are evaluations on roots of unity domain
    # Quotient: Q(X) = P(X) / (X^n - 1)

    # First, convert to coefficients
    p_coeffs = intt(p_evals)

    # Divide by (X^n - 1) = X^n - 1
    # If P(X) = sum a_i X^i, then P(X)/(X^n-1) requires P to be divisible

    # Alternative: evaluate on coset and divide pointwise by Z evaluated on coset
    ...
```

Efficient quotient computation is crucial for STARK provers.

### Coset-Based Division

A common technique:
1. Evaluate numerator polynomial on a coset (different from trace domain)
2. Evaluate vanishing polynomial on same coset
3. Divide pointwise
4. This gives quotient evaluations on the coset

```python
def quotient_on_coset(p_coeffs, coset_gen, domain_size):
    # Evaluate P on coset
    p_coset = ntt_on_coset(p_coeffs, coset_gen)

    # Vanishing polynomial: X^n - 1
    # Evaluated at coset point g*omega^i: (g*omega^i)^n - 1 = g^n - 1
    z_eval = pow(coset_gen, domain_size, MODULUS) - 1

    # Pointwise division
    z_inv = field_inv(z_eval)
    q_coset = [(p * z_inv) % MODULUS for p in p_coset]

    return q_coset
```

## Polynomial Composition

### Definition

Composition of P with Q:

```
(P compose Q)(X) = P(Q(X))
```

### Direct Computation

Naive composition is expensive:

```python
def poly_compose_naive(p, q):
    # Compute P(Q(X))
    result = [p[0]]

    q_power = q  # Q(X)^1
    for i in range(1, len(p)):
        # Add p[i] * Q(X)^i
        scaled = poly_scale(q_power, p[i])
        result = poly_add(result, scaled)
        q_power = poly_mul(q_power, q)  # Q(X)^(i+1)

    return result
```

Complexity: O(n^2 * m) where n = deg(P), m = deg(Q).

### Applications

Composition appears in:
- Constraint system transformations
- Polynomial commitment opening
- Recursive proof constructions

## Sparse Polynomials

### Representation

Sparse polynomials have few non-zero coefficients:

```python
# Dense: [0, 0, 3, 0, 0, 0, 5, 0, 0, 2]
# Sparse: [(2, 3), (6, 5), (9, 2)]  # (index, coefficient) pairs
```

### Efficient Operations

Sparse operations exploit the structure:

```python
def sparse_eval(terms, x):
    # terms = [(exp_0, coef_0), (exp_1, coef_1), ...]
    result = 0
    for exp, coef in terms:
        result = (result + coef * pow(x, exp, MODULUS)) % MODULUS
    return result
```

Complexity: O(k * log(d)) where k = number of terms, d = max degree.

### Vanishing Polynomial Example

Z(X) = X^n - 1 has only 2 terms regardless of n:
- Evaluation: O(log n) for any point
- Multiplication: O(k) where k = terms in other polynomial

## Polynomial Batching

### Motivation

Proof systems often require operations on many polynomials simultaneously. Batching amortizes overhead.

### Random Linear Combinations

Combine polynomials P_1, ..., P_k with random challenges alpha:

```
B(X) = P_1(X) + alpha * P_2(X) + alpha^2 * P_3(X) + ... + alpha^{k-1} * P_k(X)
```

If all P_i equal zero at a point, so does B with high probability.

### Batch Evaluation

To evaluate k polynomials at point z:
1. Compute B(X) as above
2. Evaluate B(z)
3. Open commitment to B at z

Single opening proves k evaluations (with soundness depending on field size).

## Key Concepts

- **Coefficient form**: Standard representation as list of coefficients
- **Evaluation form**: Representation as values at specified points
- **Lagrange interpolation**: Recover polynomial from evaluation points
- **Vanishing polynomial**: Z(X) that equals zero exactly on a specified set
- **Quotient polynomial**: Result of dividing by vanishing polynomial
- **Sparse polynomials**: Efficient when few coefficients are non-zero

## Design Considerations

### Representation Selection

Choose coefficient form when:
- Degree bounds must be checked
- Coefficients are naturally given
- Division or modular operations are needed

Choose evaluation form when:
- Many pointwise multiplications
- Working with NTT-friendly domains
- Polynomial products are composed

### Memory vs. Computation

Storing both representations doubles memory but avoids repeated transforms:
- Prover often needs both forms at different stages
- Cache and reuse expensive computations
- Consider streaming for very large polynomials

### Precision and Field Size

All arithmetic is exact in finite fields - no floating-point issues.

Field size affects:
- Security (larger = more secure)
- Arithmetic cost (larger = slower)
- Memory (larger = more space)

### Parallelization

Most polynomial operations parallelize well:
- Pointwise operations: trivially parallel
- NTT: logarithmic parallel depth
- Interpolation: parallelizable with preprocessing

## Related Topics

- [NTT and FFT](02-ntt-and-fft.md) - Fast polynomial transforms
- [Polynomial Commitments](03-polynomial-commitments.md) - Committing to polynomials
- [Prime Fields](../01-finite-fields/01-prime-fields.md) - Underlying field arithmetic
- [Witness Generation](../../02-stark-proving-system/04-proof-generation/01-witness-generation.md) - Polynomials encoding execution traces
