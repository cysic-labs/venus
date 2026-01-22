# 384-bit Arithmetic

## Overview

384-bit arithmetic is required for operations on certain elliptic curves, particularly BLS12-381 which uses a 381-bit prime field. This curve is widely used in Ethereum 2.0 for aggregate signatures and other cryptographic operations. The zkVM must efficiently handle 384-bit arithmetic to support these protocols.

The 384-bit arithmetic precompile extends the techniques used for 256-bit arithmetic to handle the larger operand size. This requires more limbs, more constraints per operation, and careful attention to the interaction between the proving field size and the operand limb structure.

This document covers 384-bit representation strategies, constraint formulations, and the specific challenges of larger integer arithmetic.

## Representation

### Limb Strategies

Decomposing 384-bit values:

```
64-bit limbs (6 limbs):
  value = l0 + l1*2^64 + ... + l5*2^320
  Natural for 64-bit operations
  Moderate constraint count

48-bit limbs (8 limbs):
  Even distribution
  May align better with some fields

32-bit limbs (12 limbs):
  More limbs but smaller
  Works with any field
```

### Field Compatibility

Matching to proving field:

```
Goldilocks (64-bit):
  6 × 64-bit limbs fit well
  Each limb < field size

BN254 scalar field (~254 bits):
  Limbs must be smaller than field
  Use 48-bit or 32-bit limbs

BLS12-381 scalar (~255 bits):
  Similar constraints
  Choose limb size accordingly
```

### Range Verification

Ensuring valid limbs:

```
Per-limb range:
  Each limb in [0, 2^w)
  w = limb width

Constraint:
  Decompose or lookup
  Total: 6-12 range checks
```

## Addition and Subtraction

### 384-bit Addition

Adding with more limbs:

```
Addition structure:
  For i in 0..5 (6 limbs):
    sum_i = a_i + b_i + carry_{i-1}
    result_i = sum_i mod 2^64
    carry_i = floor(sum_i / 2^64)

Constraints:
  a_i + b_i + carry_{i-1} = result_i + carry_i * 2^64
  carry_i binary
  result_i in range
```

### 384-bit Subtraction

Subtracting with borrows:

```
Subtraction structure:
  For i in 0..5:
    diff = a_i - b_i - borrow_{i-1} + borrow_i * 2^64
    result_i = diff

Constraints:
  Similar to addition
  6 limbs instead of 4
```

### Constraint Counts

Operations on 384-bit values:

```
Per-limb: ~4 constraints
Total for add/sub: ~24 constraints
Compared to 256-bit: ~16 constraints
Approximately 1.5x overhead
```

## Multiplication

### Full Product

384-bit × 384-bit:

```
Result size:
  768-bit product (12 limbs if 64-bit)

Schoolbook:
  36 limb products (6 × 6)
  Plus carry propagation

Constraint count:
  O(36) core multiplication constraints
  Plus carry handling
  ~100-150 total constraints
```

### Karatsuba Approach

Reducing multiplication cost:

```
Three-way split:
  a = a2*2^256 + a1*2^128 + a0
  (Using 128-bit chunks)

Karatsuba:
  5 half-size multiplications instead of 9
  Recursive application

Benefit:
  Lower asymptotic complexity
  Worthwhile for large operands
```

### Partial Products

When full product not needed:

```
Low product (384 bits):
  Result mod 2^384
  Ignore high limbs

High product (384 bits):
  Result / 2^384
  For overflow detection
```

## Modular Operations

### Modular Reduction

Reducing mod 384-bit modulus:

```
For BLS12-381 prime p:
  p = (specific 381-bit prime)

Reduction:
  Given x (up to 768 bits)
  Compute x mod p

Constraint:
  x = q * p + r
  r < p
```

### Barrett Reduction

Efficient modular reduction:

```
Barrett method:
  Precompute mu = floor(2^768 / p)
  q = floor((x * mu) / 2^768)
  r = x - q * p
  Adjust if r >= p

Constraints:
  Multiplication by precomputed mu
  Quotient computation
  Final subtraction and comparison
```

### Montgomery Multiplication

Efficient modular multiply:

```
Montgomery form:
  x_mont = x * R mod p
  where R = 2^384

Montgomery multiply:
  (a_mont * b_mont * R^{-1}) mod p
  Avoids division by p

Constraints:
  Modified multiplication
  Reduction via addition
```

## Division

### 384-bit Division

Integer division:

```
For a / b:
  a = q * b + r
  0 <= r < b

Challenge:
  Proving q * b + r = a for 384-bit values
  Large multiplication in constraint
```

### Division Constraints

Proving correctness:

```
Main constraint:
  q * b + r = a

Sub-constraints:
  q * b multiplication (384 × 384)
  Addition of r
  Range check on r < b
```

## Comparison

### 384-bit Comparison

Comparing large values:

```
a < b:
  Compute b - a
  Check sign/borrow

Limb-by-limb:
  Start from high limb
  Compare until difference found
```

### Equality Testing

384-bit equality:

```
a = b:
  All 6 limbs equal

Constraint:
  Product of (1 - (a_i - b_i) * inv_i) = 1
  Where inv_i is inverse if a_i != b_i
```

## Optimization Strategies

### Limb Grouping

Combining limb operations:

```
Strategy:
  Process multiple limbs together
  Reduce constraint overhead

Example:
  128-bit operations (2 limbs)
  Then combine 128-bit results
```

### Lazy Carry Propagation

Deferring normalization:

```
Standard:
  Propagate carries after each op

Lazy:
  Allow oversized limbs temporarily
  Reduce at end or when necessary

Benefit:
  Fewer constraints for chained ops
```

### Specialized Moduli

Exploiting modulus structure:

```
Special primes:
  p = 2^n - c for small c
  Reduction by addition

BLS12-381 prime:
  Has some special structure
  Can optimize reduction
```

## Use Cases

### BLS12-381 Field

Primary use case:

```
Field size:
  381-bit prime field
  Requires 384-bit container

Operations:
  Field addition, subtraction
  Field multiplication
  Field inversion
```

### Cryptographic Protocols

Where 384-bit appears:

```
BLS signatures:
  Field elements in 381 bits
  Pairing computations

Other curves:
  Curves with ~384-bit primes
  secp384r1 (NIST P-384)
```

## Precompile Interface

### Input Format

Providing 384-bit operands:

```
Input:
  Two 48-byte values
  Operation code

Format:
  Big-endian convention
  Padded to 48 bytes
```

### Output Format

Receiving results:

```
Output:
  48-byte result (384 bits)
  Or 96 bytes for full product
  Status flags if applicable
```

## Performance Considerations

### Constraint Overhead

Compared to 256-bit:

```
Scaling:
  Addition: 1.5x constraints
  Multiplication: 2.25x constraints
  Due to limb count increase
```

### Memory Usage

Trace width:

```
Per operation:
  6 limbs × 2 operands + intermediates
  Wider trace than 256-bit
```

## Key Concepts

- **384-bit representation**: 6 limbs for 64-bit limb width
- **Extended carry chains**: More limbs mean more carries
- **Montgomery form**: Efficient modular multiplication
- **Barrett reduction**: Efficient modular reduction
- **BLS12-381 support**: Primary application

## Design Trade-offs

### Limb Count

| 6 × 64-bit | 12 × 32-bit |
|------------|-------------|
| Fewer constraints | More constraints |
| Needs 64-bit field | Works with smaller fields |
| Simpler structure | More operations |

### Reduction Method

| Barrett | Montgomery |
|---------|------------|
| One-time reduction | Repeated multiply |
| Needs large multiply | Avoids division |
| Good for few ops | Good for many ops |

## Related Topics

- [256-bit Arithmetic](01-256-bit-arithmetic.md) - Smaller integer operations
- [Modular Arithmetic](03-modular-arithmetic.md) - General modular operations
- [BLS12-381 Operations](../04-elliptic-curve-precompiles/03-bls12-381-operations.md) - Curve using 384-bit field
- [Constraint Representation](../01-precompile-design/02-constraint-representation.md) - Encoding techniques

