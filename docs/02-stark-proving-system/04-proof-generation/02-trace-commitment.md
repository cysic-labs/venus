# Polynomial Encoding

## Overview

Polynomial encoding transforms the execution trace from a table of field elements into a collection of polynomials suitable for STARK proving. Each trace column becomes a polynomial whose evaluations at roots of unity reproduce the column values. This encoding enables algebraic constraint checking - rather than verifying constraints row by row, we verify that constraint polynomials vanish on an entire domain simultaneously.

The encoding process involves interpolation (converting evaluations to coefficients), low-degree extension (evaluating on a larger domain for error detection), and commitment (creating Merkle trees of evaluations). These steps prepare the witness for constraint composition and the FRI protocol.

This document covers interpolation techniques, domain selection, commitment structures, and optimization strategies for efficient polynomial encoding.

## From Trace to Polynomials

### Basic Interpolation

Given a trace column with n values [v_0, v_1, ..., v_{n-1}], find polynomial P(X) of degree < n such that:

```
P(omega^0) = v_0
P(omega^1) = v_1
P(omega^2) = v_2
...
P(omega^{n-1}) = v_{n-1}

where omega is a primitive n-th root of unity
```

This polynomial exists and is unique (Lagrange interpolation).

### Trace Domain

The trace domain D is the set of evaluation points:

```
D = {omega^0, omega^1, omega^2, ..., omega^{n-1}}
  = {1, omega, omega^2, ..., omega^{n-1}}

Properties:
  - |D| = n (size equals trace length)
  - D is a multiplicative subgroup of F*
  - omega^n = 1 (omega is primitive n-th root)
  - D is closed under multiplication
```

### Polynomial Representation

The trace polynomial can be represented in two forms:

```
Coefficient form:
  P(X) = c_0 + c_1*X + c_2*X^2 + ... + c_{n-1}*X^{n-1}

  Useful for: Understanding degree, some arithmetic operations

Evaluation form:
  [P(omega^0), P(omega^1), ..., P(omega^{n-1})] = [v_0, v_1, ..., v_{n-1}]

  Useful for: Constraint evaluation, commitment, storage
```

### Multiple Columns

Each trace column becomes a polynomial:

```
Column 0: T_0(X) with T_0(omega^i) = trace[i][0]
Column 1: T_1(X) with T_1(omega^i) = trace[i][1]
...
Column w-1: T_{w-1}(X) with T_{w-1}(omega^i) = trace[i][w-1]

Total: w polynomials, each of degree < n
```

## NTT-Based Interpolation

### Forward and Inverse NTT

The Number Theoretic Transform (NTT) efficiently converts between forms:

```
Forward NTT (Coefficients -> Evaluations):
  Given: [c_0, c_1, ..., c_{n-1}]
  Compute: [P(omega^0), P(omega^1), ..., P(omega^{n-1})]

Inverse NTT (Evaluations -> Coefficients):
  Given: [v_0, v_1, ..., v_{n-1}]
  Compute: [c_0, c_1, ..., c_{n-1}] such that P(omega^i) = v_i

Both operations: O(n log n) complexity
```

### NTT Algorithm Outline

The Cooley-Tukey NTT:

```
NTT(values, omega, n):
  if n == 1:
    return values

  // Split into even and odd indices
  even = [values[0], values[2], values[4], ...]
  odd = [values[1], values[3], values[5], ...]

  // Recursive NTT on halves with omega^2 as root
  even_ntt = NTT(even, omega^2, n/2)
  odd_ntt = NTT(odd, omega^2, n/2)

  // Combine results
  result = new array[n]
  for k = 0 to n/2 - 1:
    twiddle = omega^k
    result[k] = even_ntt[k] + twiddle * odd_ntt[k]
    result[k + n/2] = even_ntt[k] - twiddle * odd_ntt[k]

  return result
```

### Inverse NTT

The inverse uses reciprocal root and scaling:

```
INTT(evaluations, omega, n):
  // Use omega^{-1} and scale by n^{-1}
  omega_inv = omega^{-1}
  n_inv = n^{-1} mod p

  coeffs = NTT(evaluations, omega_inv, n)

  for i = 0 to n-1:
    coeffs[i] = coeffs[i] * n_inv

  return coeffs
```

## Low-Degree Extension

### Purpose

Extend polynomial evaluations to a larger domain:

```
Trace domain D: size n
Evaluation domain E: size m = blowup * n

The polynomial P of degree < n is uniquely determined,
and can be evaluated at any point, including all of E.

This extension enables:
  - Reed-Solomon error detection
  - FRI protocol operation
  - DEEP polynomial evaluation
```

### Extension Process

Computing the low-degree extension:

```
1. Start with trace values on D: [P(omega^0), ..., P(omega^{n-1})]

2. Convert to coefficients: INTT to get [c_0, c_1, ..., c_{n-1}]

3. Pad with zeros: [c_0, ..., c_{n-1}, 0, 0, ..., 0] (m - n zeros)

4. Evaluate on larger domain: NTT with primitive m-th root

Result: [P(omega_m^0), P(omega_m^1), ..., P(omega_m^{m-1})]

where omega_m is primitive m-th root of unity
```

### Coset Extension

Avoid overlap with trace domain by using a coset:

```
Trace domain D: {omega^0, omega^1, ..., omega^{n-1}}
Coset C = g * D: {g*omega^0, g*omega^1, ..., g*omega^{n-1}}

where g is not an n-th root of unity

For full evaluation domain with blowup factor b:
  E = D union C_1 union C_2 union ... union C_{b-1}

Each coset C_j = g^j * D
```

### Coset Evaluation

Efficient coset evaluation:

```
To evaluate P on coset g*D:

1. Multiply coefficients by powers of g:
   c'_i = c_i * g^i

2. Perform NTT on modified coefficients:
   NTT([c'_0, c'_1, ..., c'_{n-1}])

This gives [P(g*omega^0), P(g*omega^1), ..., P(g*omega^{n-1})]
```

## Commitment Structures

### Merkle Tree Commitment

Commit to polynomial evaluations:

```
Evaluations: [P(e_0), P(e_1), ..., P(e_{m-1})]

Build Merkle tree:
  Leaves: Hash(P(e_0)), Hash(P(e_1)), ...
    or grouped: Hash(P(e_0) || P(e_1)), ...

  Internal nodes: Hash(left_child || right_child)

  Root: Single hash committing to all evaluations

The root is the commitment to polynomial P.
```

### Batched Commitments

Commit to multiple polynomials in one tree:

```
Polynomials: T_0, T_1, ..., T_{w-1}

Option 1 (Column-interleaved):
  Leaf_i = Hash(T_0(e_i) || T_1(e_i) || ... || T_{w-1}(e_i))

Option 2 (Separate trees):
  Tree_0 for T_0, Tree_1 for T_1, ...

Column-interleaved is more common:
  - Single Merkle proof opens all columns at once
  - Better for constraint evaluation (needs all columns at each point)
```

### Leaf Batching

Group multiple points per leaf:

```
Instead of one evaluation per leaf:
  Leaf_j = Hash(P(e_{8j}) || P(e_{8j+1}) || ... || P(e_{8j+7}))

Benefits:
  - Smaller tree (fewer leaves)
  - Shorter Merkle paths
  - When opening, get 8 evaluations for price of one path

Trade-off:
  - Must reveal all values in a leaf, even if only need one
```

## Domain Selection

### Root of Unity Requirements

The field must support the required roots:

```
For domain size n = 2^k:
  Need primitive n-th root of unity in field F_p
  Requires: n | (p - 1)

Example (Goldilocks field p = 2^64 - 2^32 + 1):
  p - 1 = 2^64 - 2^32 = 2^32 * (2^32 - 1)

  Maximum 2-power subgroup: 2^32
  Can use n up to 2^32 rows
```

### Domain for Constraint Evaluation

Constraints have higher degree than trace:

```
Trace polynomial degree: n - 1
Constraint degree (e.g., quadratic): 2n - 2 or higher

Constraint evaluation needs larger domain:
  Evaluate constraints on domain of size at least constraint_degree + 1

Typically: Evaluate on full blowup domain (b * n points)
```

### Choosing Blowup Factor

The blowup factor affects multiple aspects:

```
Blowup factor b:
  - Evaluation domain size: b * n
  - FRI rate: 1/b
  - Soundness: Higher b gives better proven bounds
  - Memory: Proportional to b * n
  - Prover time: Proportional to b * n * log(b * n)

Common choices: b = 2, 4, 8, 16
```

## Encoding Workflow

### Complete Encoding Pipeline

From trace to committed polynomials:

```
Input: Trace table T[n][w] (n rows, w columns)

1. For each column c:
   a. Extract column: values = [T[0][c], T[1][c], ..., T[n-1][c]]
   b. Interpolate: coeffs = INTT(values, omega, n)
   c. Store coefficients (or keep evaluations)

2. Compute low-degree extension:
   For each column c:
     For each coset g^j (j = 0 to b-1):
       lde[c][j*n : (j+1)*n] = EvaluateOnCoset(coeffs[c], g^j)

3. Build commitment:
   For each evaluation point i:
     leaf_data = [lde[0][i], lde[1][i], ..., lde[w-1][i]]
     leaves[i] = Hash(leaf_data)

   merkle_root = BuildMerkleTree(leaves)

Output: merkle_root (commitment), lde (extended evaluations)
```

### Memory Layout

Efficient memory organization:

```
Option 1 (Column-major):
  lde[column][point] - Column evaluations contiguous
  Good for: Column-wise operations, NTT

Option 2 (Row-major):
  lde[point][column] - Row evaluations contiguous
  Good for: Constraint evaluation, Merkle building

Option 3 (Hybrid):
  Chunk columns together, chunk points together
  Balance between NTT efficiency and constraint evaluation
```

### Streaming Encoding

For very large traces:

```
1. Process trace in chunks:
   - Read N rows at a time
   - Partial NTT within chunk
   - Accumulate results

2. Streaming Merkle tree:
   - Build tree bottom-up
   - Write lower levels to disk
   - Keep upper levels in memory

3. Output:
   - Write evaluations to disk
   - Return only root
```

## Optimization Techniques

### Parallel NTT

NTT parallelizes well:

```
Four-step NTT for large n:
  1. View data as sqrt(n) x sqrt(n) matrix
  2. NTT each column (parallelizable)
  3. Multiply by twiddle factors
  4. NTT each row (parallelizable)

GPU acceleration:
  - Batch many small NTTs
  - Memory bandwidth is bottleneck
  - Coalesce memory accesses
```

### In-Place NTT

Memory-efficient NTT:

```
Bit-reversal permutation:
  Reorder input so output is in-place

Standard radix-2 butterfly:
  For each stage:
    For each butterfly:
      a, b = data[i], data[j]
      data[i] = a + twiddle * b
      data[j] = a - twiddle * b

No additional memory beyond twiddle factors.
```

### Precomputation

Precompute and store:

```
Twiddle factors:
  powers_of_omega = [omega^0, omega^1, ..., omega^{n/2-1}]
  For each needed NTT size

Coset factors:
  coset_powers = [g^0, g^1, ..., g^{n-1}]
  For each coset generator

Domain elements:
  domain = [omega^0, omega^1, ..., omega^{n-1}]
  Extended_domain = [omega_m^0, ..., omega_m^{m-1}]
```

### Montgomery Form

Use Montgomery representation for faster multiplication:

```
Standard multiplication: (a * b) mod p
Montgomery multiplication: MontMul(a', b') where a' = a * R mod p

Conversion cost amortized over many operations.
Useful when same values used repeatedly (twiddle factors).
```

## Validation

### Degree Check

Verify polynomial has correct degree:

```
After interpolation, polynomial P should have degree < n.

Check: Evaluate at random point z (outside domain)
       P(z) should match direct computation from coefficients

Or: Verify highest coefficients are zero if padding was added
```

### Reconstruction Check

Verify encoding is reversible:

```
From evaluations, recompute original trace:
  original = INTT(evaluations[0:n])

Compare with stored trace values.
```

### Commitment Integrity

Verify Merkle tree is correct:

```
For random sample of positions:
  - Recompute leaf hash from evaluations
  - Verify against stored Merkle tree
  - Check path to root
```

## Key Concepts

- **Interpolation**: Finding polynomial from evaluations
- **NTT**: Fast algorithm for polynomial evaluation/interpolation
- **Low-degree extension**: Evaluating on larger domain
- **Coset**: Shifted copy of trace domain
- **Commitment**: Merkle tree over polynomial evaluations

## Design Considerations

### Space vs. Time

| Store Coefficients | Store Evaluations |
|-------------------|-------------------|
| Compact (n values) | Large (b*n values) |
| Expensive to open at points | Fast opening |
| Convert to evaluations when needed | Already extended |

### Encoding Order

Encode all columns, then build tree, or interleave?

| All at Once | Interleaved |
|-------------|-------------|
| Simpler logic | Lower peak memory |
| Better for parallel NTT | Streaming possible |
| Need all columns in memory | Process column by column |

## Related Topics

- [NTT and FFT](../../01-mathematical-foundations/02-polynomial-arithmetic/02-ntt-and-fft.md) - Transform details
- [Witness Generation](01-witness-generation.md) - Creating the trace
- [Constraint Evaluation](03-constraint-evaluation.md) - Using encoded polynomials
- [FRI Fundamentals](../03-fri-protocol/01-fri-fundamentals.md) - Commitment verification
