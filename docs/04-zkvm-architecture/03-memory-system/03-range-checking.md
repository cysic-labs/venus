# Range Checking

## Overview

Range checking verifies that values fall within specified bounds, a fundamental operation throughout the zkVM. Addresses must be within valid memory regions, byte decompositions must be in [0, 255], shift amounts must be valid for the register width, and many other values have range constraints. Without efficient range checking, these bounds would require expensive bit-by-bit decomposition for every constrained value.

The lookup-based approach to range checking amortizes the cost across many values. Rather than constraining each value independently, all values share a single range table, and lookup arguments prove that each value appears in the table. This transforms range checking from a per-value cost to a per-table cost plus a constant per value.

This document covers range checking techniques, lookup integration, and optimization strategies for efficient range verification.

## Range Check Problem

### Definition

What range checking proves:

```
Given: Value v, lower bound L, upper bound U
Prove: L <= v <= U

Common cases:
  v in [0, 2^8)   - byte range
  v in [0, 2^16)  - 16-bit range
  v in [0, 2^32)  - 32-bit range
  v in [0, N)     - arbitrary bound N
```

### Why Range Checking Matters

Where range checks appear:

```
Memory addresses:
  Address must be in valid memory range
  Prevents out-of-bounds access

Byte decomposition:
  When decomposing 64-bit value into bytes
  Each byte must be in [0, 255]

Shift amounts:
  Shift by 0-63 for 64-bit values
  Larger shifts are undefined or special

Comparison results:
  Boolean results must be 0 or 1

Field arithmetic:
  Results must be in field range
  Prevent overflow/underflow
```

### Naive Approach

Bit decomposition:

```
To prove v in [0, 2^k):
  Decompose: v = b_0 + 2*b_1 + 4*b_2 + ... + 2^{k-1}*b_{k-1}

Constraints:
  For each bit b_i:
    b_i * (1 - b_i) = 0  // Binary constraint

  Reconstruction:
    v = sum(b_i * 2^i)

Cost: k columns, k+1 constraints per value
For k=64: 65 constraints per value
Very expensive for many values.
```

## Lookup-Based Range Checking

### Range Table

Precomputed table of valid values:

```
For range [0, 2^16):
  Table T = {0, 1, 2, ..., 65535}

For range [0, 2^8):
  Table T = {0, 1, 2, ..., 255}

Table as column:
  table_col[0] = 0
  table_col[1] = 1
  ...
  table_col[N-1] = N-1
```

### Lookup Argument

Proving values are in table:

```
Values to check: v_0, v_1, v_2, ..., v_n
Table: T = {t_0, t_1, ..., t_m}

Lookup claim:
  Every v_i appears in T

Logarithmic derivative approach:
  sum_i 1/(r - v_i) = sum_j mult_j/(r - t_j)

where mult_j = count of v_i equal to t_j
```

### Multiplicity Column

Tracking table usage:

```
For each table entry t_j:
  mult[j] = number of values equal to t_j

Computed during witness generation:
  Initialize mult[j] = 0 for all j
  For each value v_i:
    j = index where t_j == v_i
    mult[j] += 1

Constraint:
  sum(mult[j]) = n  // Total lookups equals values checked
```

## Range Check Patterns

### Byte Range Check

Most common range:

```
Table: {0, 1, 2, ..., 255}
Size: 256 entries

Usage:
  For 64-bit value v:
    v = b_0 + b_1*256 + b_2*65536 + ... + b_7*2^56

  Range check: b_i in byte_table for i = 0..7

8 lookups instead of 64 bit constraints.
```

### 16-bit Range Check

Larger range:

```
Table: {0, 1, 2, ..., 65535}
Size: 65536 entries

Usage:
  For 64-bit value v:
    v = h_0 + h_1*65536 + h_2*2^32 + h_3*2^48

  Range check: h_i in halfword_table for i = 0..3

4 lookups for 64-bit value.
Larger table, fewer lookups.
```

### Custom Range Check

Arbitrary range [0, N):

```
Option 1: Table of size N
  If N is small, create table {0, 1, ..., N-1}
  Direct lookup

Option 2: Decomposition + constraint
  Decompose into known ranges
  Add constraint for top limb

Example: Range [0, 1000):
  v = lo + 256*hi
  lo in [0, 255]  // byte lookup
  hi in [0, 3]    // small table or constraint
  hi == 3 implies lo < 232  // additional constraint
```

## Decomposition Strategies

### Byte Decomposition

Standard approach:

```
Value v (64-bit):
  v = b_0 + b_1*2^8 + b_2*2^16 + ... + b_7*2^56

Columns:
  v: Original value
  b_0, b_1, ..., b_7: Bytes

Constraints:
  Reconstruction: v = sum(b_i * 2^{8i})
  Range: Each b_i in byte_table
```

### Limb Decomposition

Larger chunks:

```
Value v (64-bit) with 16-bit limbs:
  v = l_0 + l_1*2^16 + l_2*2^32 + l_3*2^48

Trade-off:
  Byte (8-bit): 8 lookups, 256-entry table
  Halfword (16-bit): 4 lookups, 65536-entry table
  Nibble (4-bit): 16 lookups, 16-entry table
```

### Hybrid Decomposition

Mix chunk sizes:

```
For value with known structure:
  If v < 2^32: Decompose into 4 bytes
  If v < 2^16: Decompose into 2 bytes

Selector-based:
  is_small * (small decomposition) +
  (1-is_small) * (full decomposition)
```

## Integration with Constraints

### Inline Range Checks

Range check within other constraints:

```
Memory address:
  mem_addr = base + offset
  mem_addr_bytes = decompose(mem_addr)
  // Lookup: each byte in range

Register value after shift:
  result = a << shift_amount
  shift_amount in [0, 63]
  // Lookup: shift_amount in shift_table
```

### Batched Range Checks

Collect and batch:

```
All values needing range check:
  Collect into range_check_column

Single lookup argument:
  range_check_column values in range_table

More efficient than per-constraint lookups.
```

### Deferred Range Checks

Range check at specific rows:

```
Not every row has range check:
  is_range_check = 1 on rows with values to check

Conditional lookup:
  is_range_check * (v in table) = is_range_check

Only count lookup for active rows.
```

## Optimization Techniques

### Table Size Selection

Choosing table granularity:

```
Smaller table (e.g., 2^4 = 16):
  More lookups per value
  Smaller table commitment
  Less memory

Larger table (e.g., 2^16 = 65536):
  Fewer lookups per value
  Larger table commitment
  More memory

Optimal depends on:
  Number of values to check
  Available memory
  Constraint degree budget
```

### Sparse Range Checks

When few values need checking:

```
If only a few values need range check:
  Direct bit decomposition may be cheaper
  Avoids table overhead

Break-even point:
  Lookup: table_cost + n * lookup_cost
  Bits: n * bit_decomp_cost

Use lookup when n is large enough.
```

### Combined Tables

Multiple ranges in one table:

```
Byte range [0, 255] and nibble [0, 15]:
  Nibble values are subset of byte values
  Single byte table serves both

Tag-based multi-table:
  (tag, value) lookups
  tag=0: byte range
  tag=1: different range
```

### Lazy Range Checking

Defer until needed:

```
Don't range check every value:
  Only check values that could be out of range
  Trust internal computations

Example:
  a, b are known to be bytes
  a + b is at most 510
  If result used as byte, must range check
  If result used as larger, may not need check
```

## Key Concepts

- **Range checking**: Proving values within bounds
- **Range table**: Precomputed valid values
- **Lookup argument**: Efficient batch verification
- **Decomposition**: Breaking value into rangeable parts
- **Multiplicity**: Count of table entry usage

## Design Considerations

### Table Trade-offs

| Small Table | Large Table |
|-------------|-------------|
| Less memory | More memory |
| More lookups | Fewer lookups |
| Finer granularity | Coarser granularity |
| Lower table cost | Higher table cost |

### Decomposition Trade-offs

| Fine Decomposition | Coarse Decomposition |
|-------------------|---------------------|
| Small range per part | Large range per part |
| More parts | Fewer parts |
| More columns | Fewer columns |
| More lookups | Fewer lookups |

## Related Topics

- [Memory Architecture](01-memory-architecture.md) - Memory address ranges
- [Memory Consistency](02-memory-consistency.md) - Range in memory ops
- [Lookup Arguments](../../03-proof-management/02-component-system/02-lookup-arguments.md) - Lookup mechanics
- [Binary Operations](../02-state-machine-design/04-binary-operations.md) - Bit decomposition
