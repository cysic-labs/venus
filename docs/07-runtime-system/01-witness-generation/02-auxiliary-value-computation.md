# Auxiliary Value Computation

## Overview

Auxiliary values are helper columns in the execution trace that support constraint verification but aren't directly part of the program's execution state. These include bit decompositions, inverse elements, carry values, comparison flags, and lookup indices. Without auxiliary values, many constraints would require high-degree polynomials or wouldn't be expressible at all.

The computation of auxiliary values happens during witness generation, after the primary execution data is known. The prover computes these values to satisfy constraints—they're not verified independently but must be correct for constraints to hold. This document covers types of auxiliary values, computation strategies, and optimization techniques for efficient auxiliary column generation.

## Types of Auxiliary Values

### Decomposition Values

Breaking values into parts:

```
Bit decomposition:
  value = Σ bit[i] * 2^i
  bits[0..63] for 64-bit value

Byte decomposition:
  value = b0 + b1*256 + b2*65536 + ...
  bytes[0..7] for 64-bit value

Limb decomposition:
  value = l0 + l1*2^32
  Two 32-bit limbs

Purpose:
  Enable bit-level operations
  Support range checking
  Allow lookup table access
```

### Inverse Values

Multiplicative inverses:

```
When needed:
  Division: a/b requires b^(-1)
  Non-zero check: (a != 0) iff exists a^(-1)
  Comparison: (a - b)^(-1) for a != b

Computation:
  inv = modular_inverse(value, field_modulus)
  If value == 0: inv = 0 (by convention)

Constraint pattern:
  value * inv = 1 (if value != 0)
  value * is_zero = 0
  (1 - is_zero) * (value * inv - 1) = 0
```

### Carry and Overflow

Arithmetic helper values:

```
Addition carry:
  a + b = result + carry * 2^64
  carry in {0, 1}

Subtraction borrow:
  a - b = result + borrow * 2^64
  borrow in {0, 1}

Multiplication overflow:
  a * b = low + high * 2^64
  Captures full product

Division quotient/remainder:
  a = b * quotient + remainder
  remainder < b
```

### Comparison Flags

Comparison result indicators:

```
Less than (lt):
  lt = 1 if a < b, else 0

Equality (eq):
  eq = 1 if a == b, else 0

Greater than (gt):
  gt = 1 if a > b, else 0

Signed comparisons:
  Account for sign bit
  Different logic than unsigned
```

### Lookup Indices

Table access helpers:

```
Table index:
  Which row in lookup table
  For range check: value itself
  For operation table: (op, a, b)

Multiplicity:
  How many times value looked up
  Aggregated per table entry

Address translation:
  Memory address to memory table row
  Register index to register table row
```

## Computation Strategies

### On-the-Fly Computation

Computing during execution:

```
During execution loop:
  # After computing result
  row.result_bytes = byte_decompose(result)
  row.result_inv = modular_inverse(result)
  row.is_zero = (result == 0)

Advantages:
  Single pass
  Data available immediately

Disadvantages:
  Larger memory during execution
  Some values depend on future state
```

### Post-Execution Computation

Computing after primary trace:

```
After execution complete:
  for row in trace:
    row.aux_1 = compute_aux_1(row)
    row.aux_2 = compute_aux_2(row)

Advantages:
  All primary data available
  Can parallelize
  Lower peak memory

Disadvantages:
  Two passes over data
  Slightly slower overall
```

### Lazy Computation

Computing only when needed:

```
Defer computation:
  Store primary values
  Compute auxiliary when accessed

Implementation:
  Use properties or getters
  Cache computed values

Advantages:
  Skip unused computations
  Memory efficient

Disadvantages:
  More complex code
  Potential recomputation
```

## Specific Computations

### Byte Decomposition

Extracting bytes from value:

```
def byte_decompose(value, num_bytes=8):
  bytes = []
  for i in range(num_bytes):
    bytes.append(value & 0xFF)
    value >>= 8
  return bytes

Verification:
  sum(bytes[i] * 256^i) == original_value
  Each byte in [0, 255]
```

### Modular Inverse

Computing multiplicative inverse:

```
def modular_inverse(a, p):
  if a == 0:
    return 0  # Convention
  return pow(a, p - 2, p)  # Fermat's little theorem

Alternative (extended Euclidean):
  def extended_gcd(a, b):
    if a == 0:
      return (b, 0, 1)
    gcd, x, y = extended_gcd(b % a, a)
    return (gcd, y - (b // a) * x, x)

  gcd, x, _ = extended_gcd(a % p, p)
  return x % p
```

### Comparison Computation

Determining order:

```
Unsigned comparison:
  lt = 1 if a < b else 0
  eq = 1 if a == b else 0
  gt = 1 if a > b else 0

Signed comparison (two's complement):
  a_sign = a >> 63
  b_sign = b >> 63
  if a_sign != b_sign:
    lt = a_sign  # Negative is less
  else:
    lt = 1 if a < b else 0

Difference approach:
  diff = b - a
  lt = diff > 0 (with wrap-around handling)
```

### Range Check Decomposition

For lookup-based range checking:

```
16-bit range check:
  For value v < 2^32:
    low_16 = v & 0xFFFF
    high_16 = v >> 16

  Constraint:
    v = low_16 + high_16 * 65536
    low_16 in [0, 65535]
    high_16 in [0, 65535]
```

## Optimization Techniques

### Batch Computation

Computing many values at once:

```
Batch inverses:
  values = [v1, v2, v3, ...]
  inverses = batch_modular_inverse(values, p)

Montgomery batch inversion:
  products[0] = values[0]
  for i in 1..n:
    products[i] = products[i-1] * values[i]

  inv_all = inverse(products[n-1])

  for i in n-1..0:
    inverses[i] = products[i-1] * inv_all
    inv_all = inv_all * values[i]

Saves: n-1 inversions (just 1 instead of n)
```

### Vectorized Decomposition

Using SIMD for decompositions:

```
Vectorized byte extraction:
  Use SIMD instructions
  Process 4-8 values at once

Parallel bit decomposition:
  Multiple values in parallel
  Exploit instruction-level parallelism
```

### Caching Common Values

Reusing repeated computations:

```
Common patterns:
  Same value decomposed multiple times
  Inverse of common values (1, 2, etc.)

Caching:
  Store computed auxiliaries
  Look up before recomputing

Implementation:
  Hash map for complex values
  Direct array for small integers
```

## Validation

### Reconstruction Check

Verifying decompositions:

```
For byte decomposition:
  reconstructed = sum(bytes[i] * 256^i)
  assert reconstructed == original

For any decomposition:
  Verify parts reconstruct whole
  Catch computation errors early
```

### Inverse Verification

Checking inverse correctness:

```
For inverse:
  if value != 0:
    assert (value * inverse) % p == 1

  if value == 0:
    assert inverse == 0
```

### Range Verification

Checking value bounds:

```
For bytes:
  assert all(0 <= b <= 255 for b in bytes)

For bits:
  assert all(b in {0, 1} for b in bits)

For carries:
  assert carry in {0, 1}
```

## Key Concepts

- **Auxiliary value**: Helper column for constraint satisfaction
- **Decomposition**: Breaking value into smaller parts
- **Inverse**: Multiplicative inverse for division/comparison
- **Carry/borrow**: Overflow handling in arithmetic
- **Batch computation**: Processing multiple values efficiently

## Design Considerations

### Computation Timing

| During Execution | Post-Execution |
|------------------|----------------|
| Single pass | Two passes |
| Immediate availability | Delayed availability |
| Higher peak memory | Lower peak memory |
| Simpler control flow | More complex |

### Decomposition Granularity

| Fine (bits) | Coarse (bytes) |
|-------------|----------------|
| Maximum flexibility | Less flexibility |
| Many columns | Fewer columns |
| Larger trace | Smaller trace |
| Native bit ops | Lookup-based |

## Related Topics

- [Execution Trace Generation](01-execution-trace-generation.md) - Primary trace
- [Memory Trace Construction](03-memory-trace-construction.md) - Memory auxiliaries
- [Range Checking](../../04-zkvm-architecture/03-memory-system/03-range-checking.md) - Range decomposition
- [Binary Operations](../../04-zkvm-architecture/02-state-machine-design/04-binary-operations.md) - Bit operations
