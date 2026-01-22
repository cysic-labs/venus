# SHA-256 Circuit

## Overview

SHA-256 is one of the most widely used cryptographic hash functions, serving as the foundation for Bitcoin, SSL certificates, and countless security protocols. Implementing SHA-256 as a zkVM precompile requires translating its bitwise operations into polynomial constraints. The algorithm processes 512-bit message blocks through 64 rounds of mixing, producing a 256-bit digest.

The challenge in circuit implementation lies in the heavy use of 32-bit arithmetic and bitwise operations, which are not native to finite field arithmetic. The circuit must decompose words into bits or bytes, perform operations in this decomposed form, and reconstruct results. Despite this overhead, a well-optimized SHA-256 circuit achieves orders of magnitude improvement over instruction-by-instruction emulation.

This document covers SHA-256 algorithm structure, constraint patterns for each operation, optimization techniques, and complete circuit organization.

## Algorithm Structure

### SHA-256 Overview

High-level algorithm:

```
Input: Message M of arbitrary length
Output: 256-bit hash H

Steps:
1. Pad message to multiple of 512 bits
2. Initialize 8 working variables (H0-H7)
3. Process each 512-bit block:
   a. Prepare message schedule W[0..63]
   b. Execute 64 rounds of compression
   c. Add compressed output to H
4. Concatenate H0-H7 as output

State:
  8 x 32-bit words (H0-H7)
  Working variables: a, b, c, d, e, f, g, h
```

### Message Padding

Preparing the message:

```
Padding rules:
  1. Append bit '1' to message
  2. Append zeros until length ≡ 448 (mod 512)
  3. Append original length as 64-bit big-endian

Example (message "abc"):
  Original: 24 bits
  After '1' bit: 25 bits
  Zeros added: 423 bits
  Length field: 64 bits
  Total: 512 bits (one block)

In circuit:
  Padding typically handled outside circuit
  Circuit receives padded message
```

### Message Schedule

Expanding message to 64 words:

```
For block input W[0..15] (16 x 32-bit words):

W[i] = M[i] for i in 0..15

W[i] = σ1(W[i-2]) + W[i-7] + σ0(W[i-15]) + W[i-16]
       for i in 16..63

Where:
  σ0(x) = ROTR(x, 7) XOR ROTR(x, 18) XOR (x >> 3)
  σ1(x) = ROTR(x, 17) XOR ROTR(x, 19) XOR (x >> 10)

  ROTR = rotate right (circular shift)
```

### Compression Function

64 rounds of state transformation:

```
Initialize:
  a, b, c, d, e, f, g, h = H0, H1, H2, H3, H4, H5, H6, H7

For round i in 0..63:
  T1 = h + Σ1(e) + Ch(e,f,g) + K[i] + W[i]
  T2 = Σ0(a) + Maj(a,b,c)

  h = g
  g = f
  f = e
  e = d + T1
  d = c
  c = b
  b = a
  a = T1 + T2

Where:
  Σ0(x) = ROTR(x, 2) XOR ROTR(x, 13) XOR ROTR(x, 22)
  Σ1(x) = ROTR(x, 6) XOR ROTR(x, 11) XOR ROTR(x, 25)
  Ch(x,y,z) = (x AND y) XOR (NOT x AND z)
  Maj(x,y,z) = (x AND y) XOR (x AND z) XOR (y AND z)
  K[i] = round constants (64 predefined 32-bit values)

Final:
  H0 += a, H1 += b, ..., H7 += h  (all mod 2^32)
```

## Constraint Patterns

### 32-bit Word Representation

Representing words in field:

```
Options:
  1. Full word as field element (if field large enough)
  2. Byte decomposition: 4 bytes per word
  3. Bit decomposition: 32 bits per word

Byte approach (typical):
  word = b0 + b1*256 + b2*65536 + b3*16777216
  Each byte in [0, 255]

Constraints:
  // Decomposition
  word = b0 + b1*2^8 + b2*2^16 + b3*2^24

  // Range check (via lookup)
  (b0, b1, b2, b3) each in byte_table
```

### Rotation Constraints

ROTR(x, n) in circuit:

```
ROTR(x, n) = (x >> n) | (x << (32-n))

Byte-level rotation when n is multiple of 8:
  ROTR(x, 8): Rotate bytes
  [b0, b1, b2, b3] -> [b1, b2, b3, b0]

General rotation:
  Need bit decomposition
  Or combination of shifts
```

### XOR Constraints

Bitwise XOR:

```
For bits:
  c = a XOR b
  c = a + b - 2*a*b

For bytes (using lookup):
  (a_byte, b_byte, c_byte) in xor_table
  Table size: 256 * 256 = 65536 entries

For words:
  XOR each byte
  4 lookups per word XOR
```

### Addition Constraints

32-bit addition mod 2^32:

```
a + b = sum (mod 2^32)

Constraint approach:
  a + b = sum + carry * 2^32
  carry in {0, 1}
  sum in [0, 2^32)

Decomposition:
  sum_bytes = decompose(sum)
  Each byte in [0, 255]
  Reconstruction check
```

### Ch and Maj Functions

Boolean functions:

```
Ch(x,y,z) = (x AND y) XOR (NOT x AND z)
          = z XOR (x AND (y XOR z))

Maj(x,y,z) = (x AND y) XOR (x AND z) XOR (y AND z)
           = (x AND y) OR (x AND z) OR (y AND z)
           = median of (x, y, z)

Byte-level constraints:
  Use lookup tables for byte operations
  (x_byte, y_byte, z_byte, ch_byte) in ch_table
  (x_byte, y_byte, z_byte, maj_byte) in maj_table
```

## Circuit Organization

### Round Layout

Per-round columns:

```
State columns (8 words, 32 bytes total):
  a_bytes[4], b_bytes[4], ..., h_bytes[4]

Schedule columns:
  w_bytes[4]: Current W[i]

Intermediate columns:
  t1_bytes[4], t2_bytes[4]
  sigma0_bytes[4], sigma1_bytes[4]
  ch_bytes[4], maj_bytes[4]

Control columns:
  round_idx: Current round (0-63)
  is_final: Is this the last round
```

### State Transition

Round-to-round flow:

```
Constraint: State flows correctly

  a_next = t1 + t2
  b_next = a_current
  c_next = b_current
  d_next = c_current
  e_next = d_current + t1
  f_next = e_current
  g_next = f_current
  h_next = g_current

Shifted register pattern:
  Most values just shift
  a and e are computed
```

### Message Schedule Constraints

W[i] computation:

```
For i < 16:
  W[i] = input block word i

For i >= 16:
  W[i] = σ1(W[i-2]) + W[i-7] + σ0(W[i-15]) + W[i-16]

Constraint columns:
  w_current: Current W[i]
  w_delayed: Previous W values for schedule

Rolling window:
  Keep last 16 W values accessible
  Shift as rounds progress
```

## Lookup Tables

### Byte Range Table

Standard byte range:

```
Table: {0, 1, 2, ..., 255}

Usage:
  All byte decompositions
  Shared across SHA-256 and other circuits
```

### XOR Table

Byte-wise XOR:

```
Table: {(a, b, a XOR b) : a, b in 0..255}
Size: 65,536 entries

Usage:
  All XOR operations
  σ0, σ1, Σ0, Σ1 functions
```

### Ch and Maj Tables

Boolean function tables:

```
Ch table: {(x, y, z, Ch(x,y,z)) : x, y, z in 0..255}
Size: 16,777,216 entries (may be too large)

Alternative: Decompose into simpler operations
  Ch(x,y,z) = (x AND y) XOR (NOT_x AND z)

  Use:
    AND table: (a, b, a AND b)
    XOR table: (a, b, a XOR b)
    NOT lookup or constraint
```

### Round Constants

K[i] values:

```
Table: {(i, K[i]) : i in 0..63}

K values are fixed constants:
  K[0] = 0x428a2f98
  K[1] = 0x71374491
  ...
  K[63] = 0xc67178f2

Lookup:
  (round_idx, k_word) in constants_table
```

## Optimization Techniques

### Precomputed Rotations

Rotation as byte reordering:

```
ROTR(x, 8):
  [b0, b1, b2, b3] -> [b1, b2, b3, b0]
  No computation needed, just index shift

ROTR(x, 16):
  [b0, b1, b2, b3] -> [b2, b3, b0, b1]

General ROTR(x, n):
  Split n = 8*q + r
  Byte rotation + bit shift of r positions
```

### Combined Function Tables

Merge operations:

```
Instead of:
  T1 = Σ1 + Ch + h + K + W  (5 additions)

Combine:
  (Σ1 + Ch + constant_part) precomputed where possible

Trade-off:
  Larger tables vs fewer operations
  Find optimal combination
```

### Carry Propagation

Efficient addition chains:

```
Multiple additions:
  T1 = a + b + c + d + e

Sequential:
  tmp1 = a + b
  tmp2 = tmp1 + c
  tmp3 = tmp2 + d
  result = tmp3 + e

Parallel (with multi-input adder):
  result = (a + b + c + d + e) mod 2^32
  Single constraint with larger carry
```

## Key Concepts

- **Message schedule**: Expanding 16 input words to 64 words
- **Compression function**: 64 rounds of state transformation
- **Byte decomposition**: Representing 32-bit words as 4 bytes
- **Round constants**: Fixed values K[0..63]
- **Bitwise operations**: XOR, rotate, shift as constraints

## Design Considerations

### Decomposition Granularity

| Bit-Level | Byte-Level |
|-----------|------------|
| Native bitwise | Lookup-based |
| More columns | Fewer columns |
| Simpler constraints | Table overhead |
| Slower | Faster |

### Table Size Trade-offs

| Small Tables | Large Tables |
|--------------|--------------|
| Less memory | More memory |
| More lookups | Fewer lookups |
| Simpler | Complex |
| Composable | Specialized |

## Related Topics

- [Keccak Circuit](02-keccak-circuit.md) - Alternative hash
- [Poseidon Circuit](03-poseidon-circuit.md) - ZK-native hash
- [Precompile Architecture](../01-precompile-framework/02-precompile-architecture.md) - Framework integration
- [Binary Operations](../../04-zkvm-architecture/02-state-machine-design/04-binary-operations.md) - Bitwise constraints
