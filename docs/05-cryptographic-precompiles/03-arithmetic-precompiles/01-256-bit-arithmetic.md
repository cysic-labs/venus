# 256-bit Arithmetic

## Overview

256-bit arithmetic is fundamental to blockchain and cryptographic operations. Ethereum uses 256-bit integers for its EVM word size, and many cryptographic schemes operate on 256-bit field elements or scalars. The zkVM must efficiently prove 256-bit arithmetic operations that would require many instructions if executed on a 32-bit or 64-bit base architecture.

The 256-bit arithmetic precompile provides efficient constraint representations for addition, subtraction, multiplication, and related operations on 256-bit integers. By decomposing these large integers into limbs that fit within the proving field, the precompile can express operations with manageable constraint degrees while maintaining soundness.

This document covers limb-based 256-bit representation, constraint formulations for various operations, and optimization strategies.

## Representation

### Limb Decomposition

Breaking 256 bits into smaller pieces:

```
Limb strategies:

64-bit limbs (4 limbs):
  value = l0 + l1*2^64 + l2*2^128 + l3*2^192
  Efficient for native operations
  Limbs fit in 64-bit field

32-bit limbs (8 limbs):
  value = l0 + l1*2^32 + ... + l7*2^224
  More limbs but smaller
  Works with any field > 32 bits

16-bit limbs (16 limbs):
  Finer granularity
  More constraints but simpler per-limb
```

### Field Considerations

Matching representation to proving field:

```
Goldilocks field (64 bits):
  Can hold 64-bit limbs directly
  4 limbs for 256-bit value
  Efficient representation

Larger fields:
  Even more bits per limb possible
  Fewer constraints

Smaller fields:
  Need smaller limbs
  More decomposition
```

### Range Constraints

Ensuring limbs are valid:

```
Limb range:
  Each limb in [0, 2^w) for w-bit limbs

Constraint:
  Range check each limb
  Via decomposition or lookup

Example (64-bit limb):
  Decompose into 8-bit bytes
  Each byte in [0, 255]
```

## Addition

### Limb-wise Addition

Adding 256-bit values:

```
Addition with carries:
  For each limb i:
    sum_i = a_i + b_i + carry_{i-1}
    result_i = sum_i mod 2^w
    carry_i = sum_i / 2^w

Where:
  carry_0 = 0 (no initial carry)
  carry_i ∈ {0, 1} for addition
```

### Addition Constraints

Proving addition correct:

```
Constraints per limb:
  a_i + b_i + carry_{i-1} = result_i + carry_i * 2^w

Additional:
  carry_i is binary: carry_i * (carry_i - 1) = 0
  result_i in range [0, 2^w)

Total:
  4-8 constraints per limb depending on width
  16-32 constraints for 256-bit add
```

### Overflow Handling

When sum exceeds 256 bits:

```
Final carry:
  carry_final may be 1
  Indicates overflow

Modular addition:
  Ignore final carry for mod 2^256
  Or: constrain carry_final = 0 for no overflow
```

## Subtraction

### Limb-wise Subtraction

Subtracting 256-bit values:

```
Subtraction with borrows:
  For each limb i:
    diff_i = a_i - b_i - borrow_{i-1} + borrow_i * 2^w
    result_i = diff_i (should be in range)

Where:
  borrow_0 = 0 (no initial borrow)
  borrow_i ∈ {0, 1}
```

### Subtraction Constraints

Proving subtraction correct:

```
Constraints per limb:
  a_i - b_i - borrow_{i-1} + borrow_i * 2^w = result_i

Range:
  result_i ∈ [0, 2^w)
  borrow_i binary

Underflow:
  If a < b, final borrow = 1
  Indicates negative result (mod 2^256)
```

## Multiplication

### Schoolbook Multiplication

Basic multiplication approach:

```
Multiplication of n-limb values:
  Product has 2n limbs before reduction

For a × b:
  product[i+j] += a[i] × b[j]
  With carry propagation

Result:
  2n limbs before reduction
  Reduce to n limbs for mod 2^256
```

### Multiplication Constraints

Proving multiplication:

```
Full product constraint:
  Sum over all i, j where i + j = k:
    product[k] = Σ a[i] * b[j] + carries

Carry handling:
  product[k] = result[k] + carry[k] * 2^w

Constraint count:
  O(n^2) for n limbs
  ~16-64 constraints for 4-limb multiply
```

### Karatsuba Optimization

Reducing multiplication cost:

```
Karatsuba for 2 parts:
  a = a_hi * 2^128 + a_lo
  b = b_hi * 2^128 + b_lo

  z0 = a_lo × b_lo
  z2 = a_hi × b_hi
  z1 = (a_lo + a_hi) × (b_lo + b_hi) - z0 - z2

  product = z2 * 2^256 + z1 * 2^128 + z0

Benefits:
  3 half-size multiplications instead of 4
  Recursive application possible
```

### High/Low Products

Separate product results:

```
MUL (low 256 bits):
  product mod 2^256
  Standard result

MULHI (high 256 bits):
  product / 2^256
  For detecting overflow

Constraint:
  full_product = low + high * 2^256
```

## Division

### Division Algorithm

Integer division:

```
For a / b:
  Find q, r such that:
    a = b × q + r
    0 <= r < b

Constraint:
  Prove q × b + r = a
  Prove r < b
```

### Division Constraints

Proving division correct:

```
Main constraint:
  a = q × b + r

Range constraints:
  r < b (comparison)
  r >= 0

Quotient constraints:
  q in expected range

Comparison:
  Subtraction-based: b - r - 1 >= 0
```

### Division by Zero

Handling zero divisor:

```
Options:
  Undefined (constraint failure)
  Defined result (e.g., max value)
  Error flag output

Implementation:
  Check b != 0
  Or: accept any q, r when b = 0
```

## Comparison

### Less Than

Comparing 256-bit values:

```
a < b:
  Subtract: diff = b - a
  If no borrow: a < b (diff > 0)
  If borrow: a >= b

Constraint:
  Compute b - a
  Check borrow flag
```

### Equality

Testing equality:

```
a = b:
  All limbs equal: a_i = b_i for all i

Constraint:
  Sum of (a_i - b_i)^2 = 0
  Or: product of challenges
```

## Bitwise Operations

### AND/OR/XOR

Bitwise operations on 256-bit values:

```
Approach:
  Decompose to bits
  Apply operation per bit
  Recombine

Optimization:
  Use lookup tables for chunks
  8-bit lookups common
```

### Shifts

Shifting 256-bit values:

```
Left shift by k:
  Multiply by 2^k, take low 256 bits

Right shift by k:
  Divide by 2^k, take quotient

Constraint:
  shifted = original × 2^k mod 2^256
  Or: bit-level shift
```

## Optimization Techniques

### Lazy Reduction

Deferring carry propagation:

```
Standard:
  Reduce carries after each operation

Lazy:
  Accumulate without reduction
  Reduce once at end
  Fewer constraints for multiple ops
```

### Batched Operations

Combining multiple operations:

```
Example:
  Compute a × b + c × d
  Single reduction for sum
  Instead of reducing each product
```

### Table Lookups

Precomputed results:

```
Small operand tables:
  For 8-bit or 16-bit chunks
  Lookup multiplication results
  Reduce constraint count
```

## Precompile Interface

### Input Format

Providing operands:

```
Input:
  Two 256-bit values (32 bytes each)
  Operation selector

Format:
  Big-endian or little-endian per convention
```

### Output Format

Receiving results:

```
Output:
  256-bit result (32 bytes)
  Possibly 512 bits for multiplication
  Status/carry flags if needed
```

## Key Concepts

- **Limb decomposition**: Breaking 256 bits into manageable pieces
- **Carry propagation**: Handling overflow between limbs
- **Range constraints**: Ensuring limbs are valid
- **Full product**: 512-bit multiplication result
- **Modular reduction**: Taking result mod 2^256

## Design Trade-offs

### Limb Width

| 64-bit Limbs | 32-bit Limbs |
|--------------|--------------|
| 4 limbs | 8 limbs |
| Fewer constraints | More constraints |
| Needs 64-bit field | Works with smaller fields |

### Reduction Strategy

| Eager Reduction | Lazy Reduction |
|-----------------|----------------|
| Simple | Complex tracking |
| More constraints | Fewer constraints |
| Smaller intermediates | Larger intermediates |

## Related Topics

- [Precompile Concepts](../01-precompile-design/01-precompile-concepts.md) - Precompile overview
- [384-bit Arithmetic](02-384-bit-arithmetic.md) - Larger integer operations
- [Modular Arithmetic](03-modular-arithmetic.md) - Operations modulo prime
- [Constraint Representation](../01-precompile-design/02-constraint-representation.md) - Encoding techniques

