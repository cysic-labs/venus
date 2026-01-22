# Binary Operations

## Overview

The binary operations machine handles bitwise operations that are fundamental to general-purpose computing but challenging to express efficiently in polynomial constraint systems. Operations like AND, OR, XOR, and bit shifts require reasoning about individual bits, which doesn't map naturally to field arithmetic. The binary machine solves this by decomposing values into bits, performing operations bit-by-bit, and reconstructing results.

Bitwise operations are ubiquitous in real programs: flag manipulation, masking, hashing algorithms, and cryptographic primitives all rely heavily on them. Without efficient binary operation support, the zkVM would need to emulate these operations through arithmetic, resulting in substantial overhead. The binary machine provides native-feeling bitwise operations at a reasonable proving cost.

This document covers binary machine design, bit decomposition techniques, operation implementation, and optimization strategies.

## Operation Types

### Basic Bitwise Operations

Core binary operations:

```
AND (bitwise and):
  c = a & b
  c[i] = a[i] * b[i] for each bit i

OR (bitwise or):
  c = a | b
  c[i] = a[i] + b[i] - a[i] * b[i]

XOR (bitwise exclusive or):
  c = a ^ b
  c[i] = a[i] + b[i] - 2 * a[i] * b[i]

NOT (bitwise complement):
  c = ~a
  c[i] = 1 - a[i]
```

### Shift Operations

Bit shifting:

```
Left shift (SLL):
  c = a << b
  Bits move left, zeros fill right

Logical right shift (SRL):
  c = a >> b
  Bits move right, zeros fill left

Arithmetic right shift (SRA):
  c = a >>> b
  Bits move right, sign bit fills left
```

### Rotate Operations

Circular shifts:

```
Rotate left:
  c = (a << b) | (a >> (width - b))
  Bits wrap around

Rotate right:
  c = (a >> b) | (a << (width - b))
  Bits wrap around other direction
```

### Comparison and Testing

Bit-based comparisons:

```
Equality:
  a == b iff (a XOR b) == 0

Less than (unsigned):
  Compare bit by bit from most significant

Bit testing:
  (a & (1 << i)) != 0
  Tests if bit i is set
```

## Bit Decomposition

### Basic Decomposition

Converting value to bits:

```
For n-bit value v:
  bits = [v_0, v_1, ..., v_{n-1}]

  where v = sum(bits[i] * 2^i) for i in 0..n-1

Constraints:
  // Each bit is binary
  bits[i] * (1 - bits[i]) = 0 for all i

  // Reconstruction
  v = sum(bits[i] * 2^i)
```

### Efficient Decomposition

Grouping bits:

```
Instead of individual bits, use nibbles (4 bits):
  nibbles = [n_0, n_1, ..., n_{k-1}]

  where v = sum(nibbles[i] * 16^i)

Constraints:
  // Each nibble in [0, 15]
  nibbles[i] in nibble_table

  // Reconstruction
  v = sum(nibbles[i] * 16^i)

Reduces columns from n to n/4.
Uses lookup table instead of binary constraints.
```

### Byte Decomposition

Common decomposition choice:

```
For 64-bit value:
  bytes = [b_0, b_1, ..., b_7]

  v = b_0 + b_1*256 + b_2*65536 + ... + b_7*2^56

Constraints:
  Each byte in [0, 255] via lookup
  Reconstruction correct

Columns: 8 per value (vs. 64 for bits)
```

## Machine Structure

### Column Layout

Binary machine columns:

```
Input columns:
  a, b: Input operands
  op_type: Operation selector

Decomposition columns:
  a_bits[64]: Bit decomposition of a
  b_bits[64]: Bit decomposition of b
  result_bits[64]: Result bit decomposition

  Or using bytes:
  a_bytes[8], b_bytes[8], result_bytes[8]

Auxiliary columns:
  intermediate: For complex operations
  shift_amount: For shift operations
  comparison_flags: For comparison operations

Output columns:
  result: Reconstructed result
```

### Operation Selectors

Dispatch by operation:

```
is_and: AND operation
is_or: OR operation
is_xor: XOR operation
is_not: NOT operation
is_sll: Shift left logical
is_srl: Shift right logical
is_sra: Shift right arithmetic

Constraint:
  sum(all_selectors) = 1
```

## Constraint Patterns

### AND Constraint

Bitwise AND:

```
For each bit position i:
  result_bits[i] = a_bits[i] * b_bits[i]

Full constraint:
  is_and * (result_bits[i] - a_bits[i] * b_bits[i]) = 0

Result reconstruction:
  is_and * (result - sum(result_bits[i] * 2^i)) = 0
```

### OR Constraint

Bitwise OR:

```
For each bit position i:
  result_bits[i] = a_bits[i] + b_bits[i] - a_bits[i] * b_bits[i]

Derivation:
  OR(a, b) = 1 - AND(NOT(a), NOT(b))
           = 1 - (1-a)(1-b)
           = a + b - a*b
```

### XOR Constraint

Bitwise XOR:

```
For each bit position i:
  result_bits[i] = a_bits[i] + b_bits[i] - 2 * a_bits[i] * b_bits[i]

Derivation:
  XOR(a, b) = OR(AND(a, NOT(b)), AND(NOT(a), b))
            = a(1-b) + (1-a)b
            = a + b - 2ab

Alternative (using field arithmetic):
  result_bits[i] = a_bits[i] + b_bits[i] (mod 2)
  But requires mod 2 in field, which is messy
```

### Shift Constraints

Left shift by constant:

```
Left shift by k positions:
  result_bits[i] = a_bits[i-k] if i >= k else 0

Constraint form:
  For i < k: result_bits[i] = 0
  For i >= k: result_bits[i] = a_bits[i-k]
```

Variable shift:

```
Shift amount in shift_amount column
Need to handle any shift from 0 to width-1

Approach 1: Decompose shift amount, use multiplexer
Approach 2: Lookup table for small shifts
Approach 3: Multiple stages (shift by 1, 2, 4, 8, ...)
```

### Comparison Constraints

Less than comparison:

```
a < b (unsigned):

Approach:
  Compute diff = b - a
  If diff > 0 and < 2^63, then a < b

Or bit-by-bit:
  Find first bit where they differ
  If a_bit = 0 and b_bit = 1, then a < b
```

## Lookup Tables

### Byte Operation Tables

Precomputed byte-level operations:

```
XOR table: {(a, b, a XOR b) : a, b in 0..255}
AND table: {(a, b, a AND b) : a, b in 0..255}
OR table: {(a, b, a OR b) : a, b in 0..255}

Size: 256 * 256 = 65536 entries per table
```

### Using Byte Tables

Byte-wise operation:

```
For 64-bit XOR:
  For each byte position i:
    (a_bytes[i], b_bytes[i], result_bytes[i]) in XOR_table

8 lookups instead of 64 bit constraints.
Much more efficient.
```

### Nibble Tables

Even smaller tables:

```
Table size: 16 * 16 = 256 entries
16 lookups for 64-bit operation

Trade-off:
  Smaller table: Less memory
  More lookups: More lookup overhead
```

## Optimization Techniques

### Lazy Decomposition

Only decompose when needed:

```
If operation is XOR on bytes:
  Decompose to bytes, not bits
  Use byte XOR table

If operation is shift by 8:
  Just reorder bytes
  No bit decomposition needed

If operation is AND with mask 0xFF:
  Extract lowest byte
  Single lookup
```

### Batched Operations

Process similar operations together:

```
All XOR operations in consecutive rows:
  Share table lookups
  Amortize commitment overhead

Group by operation type:
  XOR batch, AND batch, shift batch
  Separate regions in trace
```

### Constant Folding

Optimize operations with constants:

```
If one operand is constant:
  Precompute partial result
  Simpler constraints

Example: AND with mask
  Mask = 0x0F (keep low nibble)
  Only need to constrain low 4 bits
  High bits known to be 0
```

## Integration Patterns

### Main Machine Connection

Binary machine receives operations:

```
Main machine:
  is_xor_op * (binary_bus_op - XOR) = 0
  is_xor_op * (binary_bus_a - rs1_value) = 0
  is_xor_op * (binary_bus_b - rs2_value) = 0
  is_xor_op * (rd_value - binary_bus_result) = 0

Binary machine:
  Processes (XOR, a, b)
  Decomposes, operates, reconstructs
  Returns result via bus
```

### Permutation Connection

Linking main and binary traces:

```
Main trace sends: (op_type, operand_a, operand_b, result)
Binary trace receives: (op_type, operand_a, operand_b, result)

Permutation argument:
  Multiset of main sends = Multiset of binary receives
```

## Key Concepts

- **Binary machine**: State machine for bitwise operations
- **Bit decomposition**: Converting values to individual bits
- **Byte tables**: Precomputed byte-level operation results
- **Reconstruction**: Combining bits/bytes back to value
- **Variable shift**: Handling shift by non-constant amount

## Design Considerations

### Decomposition Granularity

| Bit-Level | Byte-Level |
|-----------|------------|
| More columns | Fewer columns |
| Native constraints | Lookup-based |
| Slower | Faster |
| More flexible | Less flexible |

### Table Size Trade-offs

| Small Tables | Large Tables |
|--------------|--------------|
| Less memory | More memory |
| More lookups | Fewer lookups |
| Finer granularity | Coarser granularity |

## Related Topics

- [State Machine Abstraction](01-state-machine-abstraction.md) - Machine design
- [Main State Machine](02-main-state-machine.md) - Integration point
- [Arithmetic Operations](03-arithmetic-operations.md) - Complementary machine
- [Lookup Arguments](../../03-proof-management/02-component-system/02-lookup-arguments.md) - Table lookups
