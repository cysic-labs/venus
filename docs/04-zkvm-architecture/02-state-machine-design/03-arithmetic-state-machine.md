# Arithmetic Operations

## Overview

The arithmetic operations machine handles mathematical computations that would be inefficient to implement directly in the main state machine. This includes multiplication, division, modular arithmetic, and extended precision operations. By concentrating these operations in a specialized machine, the zkVM can apply optimized constraint structures tailored to arithmetic correctness.

Arithmetic operations present unique challenges for constraint systems. Simple operations like addition are native to finite field arithmetic, but multiplication of large values requires careful decomposition to avoid field overflow. Division requires computing quotients and remainders with range constraints. The arithmetic machine provides efficient, reusable constraint patterns for these operations.

This document covers the design of arithmetic state machines, constraint patterns for various operations, and optimization techniques.

## Operation Categories

### Native Operations

Operations directly expressible in field:

```
Addition:
  c = a + b (mod p)
  Constraint: c - a - b = 0
  No decomposition needed

Subtraction:
  c = a - b (mod p)
  Constraint: c - a + b = 0

Small multiplication:
  c = a * b where a, b small enough
  Constraint: c - a * b = 0
  Works if product < p
```

### Wide Multiplication

Multiplying values larger than field handles directly:

```
Problem:
  64-bit values: a, b up to 2^64
  Product a * b up to 2^128
  Field size: p ≈ 2^64
  Product doesn't fit in single field element

Solution:
  Decompose product into parts
  Constrain parts to combine correctly

Approach:
  result_lo = (a * b) mod 2^64
  result_hi = (a * b) / 2^64
  Constraint: a * b = result_hi * 2^64 + result_lo
```

### Division

Integer division with remainder:

```
Division: a = b * q + r, where 0 <= r < b

Columns:
  a: dividend
  b: divisor
  q: quotient
  r: remainder

Constraints:
  a = b * q + r
  r < b (range constraint)
  q in valid range
```

### Modular Arithmetic

Reduction modulo a value:

```
Modular reduction: c = a mod m

Columns:
  a: input value
  m: modulus
  q: quotient (a / m)
  c: result (a mod m)

Constraints:
  a = m * q + c
  c < m (range constraint)
```

## Constraint Patterns

### Multiplication Decomposition

Breaking wide multiply into parts:

```
For 64-bit inputs a, b producing 128-bit result:

Decompose into 32-bit limbs:
  a = a_lo + a_hi * 2^32
  b = b_lo + b_hi * 2^32

Partial products:
  p0 = a_lo * b_lo          // 64 bits max
  p1 = a_lo * b_hi          // 64 bits max
  p2 = a_hi * b_lo          // 64 bits max
  p3 = a_hi * b_hi          // 64 bits max

Full product:
  a * b = p0 + (p1 + p2) * 2^32 + p3 * 2^64

Carry handling:
  Propagate carries between limbs
  Final result in result_lo, result_hi
```

### Division Constraint

Verifying division result:

```
Given: dividend a, divisor b, quotient q, remainder r

Multiplication check:
  b * q + r = a

Range checks:
  r < b   (remainder less than divisor)
  q >= 0  (quotient non-negative)

For signed division:
  Additional sign handling
  Quotient rounding rules
```

### Carry Propagation

Handling carries in multi-limb arithmetic:

```
Adding two 64-bit numbers as 32-bit limbs:
  a = a_lo + a_hi * 2^32
  b = b_lo + b_hi * 2^32

  sum_lo_full = a_lo + b_lo  // May exceed 32 bits
  carry_0 = sum_lo_full >> 32  // 0 or 1
  result_lo = sum_lo_full mod 2^32

  sum_hi_full = a_hi + b_hi + carry_0
  carry_1 = sum_hi_full >> 32
  result_hi = sum_hi_full mod 2^32

Constraints:
  sum_lo_full = a_lo + b_lo
  result_lo + carry_0 * 2^32 = sum_lo_full
  carry_0 in {0, 1}
  // Similar for high part
```

### Range Constraints

Ensuring values are within bounds:

```
Value v must be in [0, 2^k):

Decomposition approach:
  v = sum(bits[i] * 2^i) for i in 0..k-1
  Each bit in {0, 1}: bits[i] * (1 - bits[i]) = 0

Lookup approach:
  Decompose into bytes: v = b0 + b1*256 + b2*65536 + ...
  Each byte in lookup table [0..255]

More efficient for common ranges.
```

## Machine Structure

### Column Layout

Arithmetic machine columns:

```
Operation columns:
  op_type: Operation selector
  a, b: Input operands
  result: Output result

Decomposition columns:
  a_limbs[4]: a decomposed into 16-bit parts
  b_limbs[4]: b decomposed
  result_limbs[4]: result decomposed

Intermediate columns:
  partial_products[10]: For multiplication
  carries[4]: Carry bits
  quotient, remainder: For division

Auxiliary columns:
  range_check_vals: Values for range lookup
  lookup_acc: Lookup accumulator
```

### Operation Selectors

Dispatch by operation type:

```
Selector columns:
  is_add: Addition operation
  is_sub: Subtraction operation
  is_mul: Multiplication operation
  is_div: Division operation
  is_mod: Modular reduction

Constraint:
  is_add + is_sub + is_mul + is_div + is_mod = 1

Each operation has its constraints activated by selector.
```

### Constraint Application

Conditional constraints:

```
// Addition
is_add * (result - a - b) = 0

// Subtraction
is_sub * (result - a + b) = 0

// Multiplication (simplified)
is_mul * (result_lo - (a * b mod 2^64)) = 0
is_mul * (result_hi - (a * b / 2^64)) = 0

// Division
is_div * (a - b * quotient - remainder) = 0
is_div * range_check(remainder < b)
```

## Extended Precision

### Multi-Word Arithmetic

Operating on numbers larger than field:

```
256-bit addition:
  Input: a[4], b[4] (four 64-bit limbs each)
  Output: result[4], carry_out

  For i = 0 to 3:
    sum[i] = a[i] + b[i] + carry[i-1]
    result[i] = sum[i] mod 2^64
    carry[i] = sum[i] / 2^64

Constraints at each stage ensure correctness.
```

### Montgomery Multiplication

Efficient modular multiplication:

```
Montgomery form: a' = a * R mod N
where R = 2^k for some k

Montgomery multiplication:
  Input: a', b' (in Montgomery form)
  Output: (a' * b' * R^{-1}) mod N = (a * b)' (in Montgomery form)

Algorithm:
  t = a' * b'
  u = (t * N') mod R  // N' = -N^{-1} mod R
  result = (t + u * N) / R

Constraints verify each step.
```

### Modular Exponentiation

For cryptographic operations:

```
Square-and-multiply:
  For each bit of exponent:
    Square current result
    If bit is 1, multiply by base

Constraint approach:
  Trace each squaring and multiplication
  Verify each step
  Many rows for large exponents

Optimization:
  Window methods reduce steps
  Precomputation tables
```

## Lookup Integration

### Range Check Lookups

Efficient range verification:

```
Table: All values 0 to 2^16 - 1

For value v that must be 16-bit:
  v in range_table

For 64-bit value decomposed into limbs:
  limb_0 in range_table
  limb_1 in range_table
  limb_2 in range_table
  limb_3 in range_table
```

### Operation Tables

Precomputed results:

```
Small multiplication table:
  {(a, b, a*b) : a, b in 0..255}

Use for byte-level operations.
Larger tables for efficiency vs. memory trade-off.
```

## Performance Considerations

### Constraint Degree

Balancing degree and count:

```
Lower degree (2):
  More constraints
  Smaller quotient polynomial
  More auxiliary columns

Higher degree (3-4):
  Fewer constraints
  Larger quotient polynomial
  Fewer auxiliary columns

Arithmetic operations often degree 2 naturally:
  a + b, a * b are degree 2 in trace polynomials
```

### Column Count

Minimizing columns:

```
Reuse columns:
  Same columns for different operation types
  Mutually exclusive usage via selectors

Lazy decomposition:
  Only decompose when needed
  Skip for simple operations
```

### Batching

Processing multiple operations:

```
Batch similar operations:
  Group multiplications together
  Amortize fixed costs

Instruction scheduling:
  Reorder for better batching
  Pipeline consecutive operations
```

## Key Concepts

- **Arithmetic machine**: Specialized state machine for math operations
- **Decomposition**: Breaking large values into smaller parts
- **Carry propagation**: Handling overflow between parts
- **Range constraints**: Ensuring values within bounds
- **Extended precision**: Multi-limb arithmetic

## Design Considerations

### Precision vs. Efficiency

| Full Precision | Limited Precision |
|----------------|-------------------|
| Handle any size values | Fixed size limits |
| More columns | Fewer columns |
| More complex constraints | Simpler constraints |
| Universal | Application-specific |

### Native vs. Emulated

| Field-Native Ops | Emulated Ops |
|------------------|--------------|
| Direct constraints | Decomposed constraints |
| Fast | Slower |
| Limited range | Full range |
| Simple | Complex |

## Related Topics

- [State Machine Abstraction](01-state-machine-abstraction.md) - Machine design
- [Main State Machine](02-main-state-machine.md) - Integration with main
- [Binary Operations](04-binary-operations.md) - Bitwise operations
- [Lookup Arguments](../../03-proof-management/02-component-system/02-lookup-arguments.md) - Range checks
