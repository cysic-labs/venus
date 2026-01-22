# Constraint Representation

## Overview

Constraint representation defines how cryptographic operations are encoded as polynomial constraints within precompiles. Each precompile must express its computation as a set of polynomial equations that the proving system can verify. The art of precompile design lies in finding constraint formulations that are both efficient (few constraints, low degree) and secure (sound encoding of the operation).

Different operations have different natural constraint representations. Arithmetic operations may translate directly to field arithmetic, while bitwise operations require decomposition into bits. Hash functions combine both, with careful optimization of the constraint structure for the specific algorithm.

This document explores the techniques for representing various cryptographic operations as constraints and the trade-offs involved.

## Constraint Fundamentals

### Polynomial Constraints

The basic building blocks:

```
Constraint form:
  P(x_1, x_2, ..., x_n) = 0
  Where P is a polynomial
  Variables are trace column values

Example:
  Addition: x + y - z = 0 (proves z = x + y)
  Multiplication: x * y - z = 0 (proves z = x * y)
  Equality: x - y = 0 (proves x = y)
```

### Constraint Degree

Polynomial degree considerations:

```
Degree definition:
  Maximum exponent sum in any term

Low degree (1-2):
  Efficient to prove
  Direct commitment
  Preferred when possible

High degree (>2):
  More expensive to prove
  May need reduction techniques
  Avoid unless necessary
```

### Constraint Count

Number of constraints:

```
Total constraints:
  Sum across all operations
  Each must be satisfied

Efficiency:
  Fewer is better
  But soundness required
  Trade-off with degree
```

## Arithmetic Representation

### Field Arithmetic

Native field operations:

```
Addition:
  a + b = c
  Single constraint

Multiplication:
  a * b = c
  Single constraint

Division (via inverse):
  a * b_inv = 1 (b_inv is inverse of b)
  a / b = c becomes a = b * c
```

### Extended Arithmetic

Operations on larger values:

```
256-bit in 64-bit limbs:
  Value = l_0 + l_1 * 2^64 + l_2 * 2^128 + l_3 * 2^192

Addition with carry:
  l_0_a + l_0_b = l_0_c + carry_0 * 2^64
  l_1_a + l_1_b + carry_0 = l_1_c + carry_1 * 2^64
  ...

Multiplication:
  Schoolbook or Karatsuba approach
  Product of limbs with carries
```

### Modular Arithmetic

Operations modulo a value:

```
Modular reduction:
  x = q * m + r (where r < m)
  Prove: q * m + r = x
  Prove: r < m (range check)

Montgomery multiplication:
  Efficient modular multiply
  Special representation
  Reduction via addition
```

## Bitwise Representation

### Bit Decomposition

Converting values to bits:

```
Decomposition:
  x = b_0 + b_1 * 2 + b_2 * 4 + ... + b_n * 2^n

Bit constraints:
  b_i * (b_i - 1) = 0 (proves b_i is 0 or 1)
  For all i in [0, n]
```

### Bitwise Operations

AND, OR, XOR in constraints:

```
XOR (for bits):
  a XOR b = a + b - 2*a*b

AND (for bits):
  a AND b = a * b

OR (for bits):
  a OR b = a + b - a * b

Constraint formulation:
  These directly become constraint equations
```

### Multi-Bit Operations

Efficient bitwise ops on words:

```
Lookup approach:
  Precompute tables for 4-bit or 8-bit chunks
  Lookup for each chunk
  Combine results

Example (8-bit XOR):
  Table: [(a, b, a XOR b) for all a, b in 0..255]
  Lookup proves XOR correctness
```

## Hash Function Representation

### Round Function Constraints

Representing hash rounds:

```
Typical round:
  Mix: combine state with round constant
  Substitute: apply S-box (nonlinear)
  Permute: rearrange state

Constraint encoding:
  Each step as constraints
  Chain through rounds
```

### Nonlinear Operations

S-boxes and similar:

```
Lookup-based:
  S-box as lookup table
  Input → Output mapping
  Prove via lookup argument

Algebraic:
  S(x) = x^d mod p (for algebraic S-boxes)
  Constraint: y = x^d
  May need intermediate variables
```

### State Representation

Hash function state in constraints:

```
State format:
  Multiple words or lanes
  Each as field element or limbs

Example (Keccak):
  25 lanes of 64 bits each
  Each lane: multiple limbs or bits
```

## Elliptic Curve Representation

### Point Representation

Curve points in constraints:

```
Affine coordinates:
  Point = (x, y) where y^2 = x^3 + ax + b

Projective coordinates:
  Point = (X : Y : Z) where y = Y/Z, x = X/Z
  Avoids division

Jacobian coordinates:
  Point = (X : Y : Z) where y = Y/Z^3, x = X/Z^2
  Efficient doubling
```

### Point Addition Constraints

Adding curve points:

```
Affine addition (P + Q = R):
  lambda = (y_Q - y_P) / (x_Q - x_P)
  x_R = lambda^2 - x_P - x_Q
  y_R = lambda * (x_P - x_R) - y_P

Constraints:
  (y_Q - y_P) = lambda * (x_Q - x_P)
  x_R + x_P + x_Q = lambda^2
  y_R + y_P = lambda * (x_P - x_R)
```

### Scalar Multiplication

Point times scalar:

```
Double-and-add:
  Decompose scalar to bits
  For each bit: double, conditionally add

Constraints:
  Each doubling step
  Each addition step
  Bit decomposition of scalar
```

## Lookup-Based Representation

### Table Definition

Creating lookup tables:

```
Table structure:
  Columns: input(s), output(s)
  Rows: all valid combinations

Example (8-bit AND):
  (a, b, a AND b) for all a, b in [0, 255]
  65,536 rows
```

### Lookup Arguments

Proving value is in table:

```
Lookup constraint:
  (x, y, z) is in table T

Implementation:
  Accumulator-based argument
  Proves inclusion without showing position
```

### Table Composition

Combining table lookups:

```
Example:
  32-bit XOR via four 8-bit lookups
  Split operands into bytes
  Lookup each byte pair
  Combine results
```

## Constraint Optimization

### Degree Reduction

Lowering constraint degree:

```
Technique:
  Introduce intermediate variable
  High-degree constraint becomes multiple low-degree

Example:
  x^4 = y becomes:
  x^2 = t (degree 2)
  t^2 = y (degree 2)
```

### Common Subexpression Elimination

Reusing computations:

```
Technique:
  Identify repeated expressions
  Compute once, reuse via intermediate variable

Benefit:
  Fewer total constraints
  More efficient proving
```

### Algebraic Reformulation

Finding equivalent cheaper forms:

```
Example:
  Checking x in [0, 2^n):

  Expensive: n bit constraints
  Cheaper: lookup in range table

  Or: polynomial identity if structured
```

## Trace Layout

### Column Assignment

Mapping operations to columns:

```
Column types:
  Input columns: precompile inputs
  State columns: intermediate values
  Output columns: precompile outputs

Layout:
  Arrange for minimal constraint degree
  Group related values
  Optimize for locality
```

### Row Utilization

Using trace rows efficiently:

```
Single-row operations:
  Simple operations fit one row
  All values in same row

Multi-row operations:
  Complex operations span rows
  State transitions between rows
  Iteration constraints
```

## Key Concepts

- **Constraint representation**: Encoding operations as polynomial equations
- **Constraint degree**: Polynomial degree affects proving cost
- **Bit decomposition**: Converting values for bitwise operations
- **Lookup arguments**: Proving values exist in precomputed tables
- **Optimization**: Reducing constraint count and degree

## Design Trade-offs

### Degree vs Constraint Count

| Low Degree | Low Constraint Count |
|------------|---------------------|
| More constraints | Fewer constraints |
| Efficient verification | Higher degree |
| Standard techniques | May need reduction |

### Native vs Lookup

| Native Constraints | Lookup Tables |
|-------------------|---------------|
| No table overhead | Table commitment cost |
| May be high degree | Fixed low degree |
| Flexible | Requires precomputation |

## Related Topics

- [Precompile Concepts](01-precompile-concepts.md) - Overview of precompiles
- [Chunking Strategies](03-chunking-strategies.md) - Handling large inputs
- [Lookup Arguments](../../03-proof-management/02-component-system/02-lookup-arguments.md) - Lookup proof details
- [Algebraic Intermediate Representation](../../02-stark-proving-system/02-constraint-system/01-algebraic-intermediate-representation.md) - Constraint system

