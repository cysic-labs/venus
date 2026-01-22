# Keccak Circuit

## Overview

Keccak is the cryptographic hash function underlying SHA-3 and the hash function used by Ethereum (Keccak-256). Unlike SHA-256's Merkle-Damgard construction, Keccak uses a sponge construction with a permutation-based design. The algorithm operates on a 5x5 grid of 64-bit lanes (1600 bits total), applying 24 rounds of the Keccak-f permutation.

Implementing Keccak as a circuit presents different challenges than SHA-256. The larger state (1600 bits vs 256 bits) and 64-bit operations require more columns. However, the simpler algebraic structure of Keccak's operations (primarily XOR and rotations) can lead to efficient constraint formulations. The circuit must balance state representation, round function implementation, and lookup table usage.

This document covers Keccak algorithm structure, sponge construction, round function constraints, and circuit optimization techniques.

## Algorithm Structure

### Sponge Construction

Keccak's absorption and squeezing:

```
Sponge parameters:
  State: 1600 bits
  Rate r: Bits absorbed per block
  Capacity c: Reserved bits (security)
  r + c = 1600

For Keccak-256:
  r = 1088 bits (136 bytes)
  c = 512 bits
  Output: 256 bits

Absorption:
  For each r-bit message block:
    State[0:r] XOR= block
    State = Keccak-f(State)

Squeezing:
  Output State[0:output_bits]
  Apply Keccak-f if more output needed
```

### State Organization

5x5x64 bit structure:

```
State array: A[x][y] for x, y in 0..4
Each A[x][y] is a 64-bit lane

Total: 25 lanes x 64 bits = 1600 bits

Indexing:
  A[x][y][z] = bit z of lane at (x, y)
  Lane: A[x][y] = 64-bit word

Memory layout:
  Linear: A[0][0], A[1][0], ..., A[4][4]
  Or by plane/sheet for operations
```

### Keccak-f Permutation

24 rounds of 5 operations:

```
For each round r in 0..23:
  θ (theta):  Column parity mixing
  ρ (rho):    Lane rotations
  π (pi):     Lane permutation
  χ (chi):    Row-wise nonlinear mixing
  ι (iota):   Round constant addition

Each operation transforms the state.
Applied in sequence for each round.
```

## Round Operations

### Theta (θ)

Column parity mixing:

```
Algorithm:
  C[x] = A[x][0] XOR A[x][1] XOR A[x][2] XOR A[x][3] XOR A[x][4]
  D[x] = C[x-1] XOR ROT(C[x+1], 1)
  A'[x][y] = A[x][y] XOR D[x]

Effect:
  Each lane XORed with parity of neighbors
  Linear operation (only XOR and rotation)

Constraint pattern:
  Compute 5 column parities C[0..4]
  Compute 5 D values
  Update all 25 lanes
```

### Rho (ρ)

Lane rotation:

```
Algorithm:
  A'[x][y] = ROT(A[x][y], r[x][y])

Rotation amounts r[x][y]:
  Fixed per position
  0, 1, 3, 6, 10, 15, 21, 28, 36, 45, 55, 2, 14, 27, 41, 56, 8, 25, 43, 62, 18, 39, 61, 20, 44

Effect:
  Each of 25 lanes rotated by fixed amount
  No interaction between lanes

Constraint pattern:
  For each lane: rotation constraint
  Amount known at circuit design time
```

### Pi (π)

Lane permutation:

```
Algorithm:
  A'[y][2x+3y mod 5] = A[x][y]

Effect:
  Lanes move to new positions
  No modification to lane values
  Just reindexing

Constraint pattern:
  Wire routing, not computation
  Lane at new position equals lane at old position
```

### Chi (χ)

Nonlinear row mixing:

```
Algorithm:
  A'[x][y] = A[x][y] XOR ((NOT A[x+1][y]) AND A[x+2][y])

Effect:
  Only nonlinear operation
  Operates on rows (y fixed)
  Mixes 3 adjacent lanes in each row

Constraint pattern:
  For each row (5 lanes):
    Compute NOT, AND, XOR
    Bitwise or via lookup tables
```

### Iota (ι)

Round constant addition:

```
Algorithm:
  A'[0][0] = A[0][0] XOR RC[r]

Round constants RC[r]:
  24 different 64-bit values
  Only affects lane (0,0)

Effect:
  Breaks symmetry
  Different each round

Constraint pattern:
  Lookup for round constant
  XOR with lane (0,0)
```

## Constraint Patterns

### Lane Representation

64-bit lane as field elements:

```
Option 1: Full 64-bit value
  If field > 2^64, lane fits in one element
  Direct arithmetic possible

Option 2: Byte decomposition
  8 bytes per lane
  25 lanes = 200 bytes
  Each byte in [0, 255]

Option 3: 4-bit nibble decomposition
  16 nibbles per lane
  Useful for some lookup patterns
```

### XOR Constraints

Pervasive XOR operations:

```
Lane XOR:
  C = A XOR B

Byte-wise:
  For each byte position i:
    (A_byte[i], B_byte[i], C_byte[i]) in xor_table

Total: 8 lookups per lane XOR

Optimization:
  Larger tables (16-bit chunks): 4 lookups per lane
  Trade memory for fewer lookups
```

### Rotation Constraints

ROT(x, n) for 64-bit lanes:

```
Byte-aligned rotation (n multiple of 8):
  Just reorder bytes
  No constraint needed, wiring only

General rotation:
  Split n = 8*q + r
  Byte rotation + bit shift within bytes

Bit shift within byte:
  (byte_in, shift, byte_out) in rotation_table
  Or bit decomposition + reconstruct
```

### Chi Nonlinear Constraint

Row mixing:

```
For row y, lane x:
  out[x] = in[x] XOR ((NOT in[x+1]) AND in[x+2])

Decompose to:
  not_next = NOT in[x+1]
  and_term = not_next AND in[x+2]
  out[x] = in[x] XOR and_term

Byte-level:
  not_byte in not_table (or compute)
  (not_byte, other_byte, and_byte) in and_table
  (in_byte, and_byte, out_byte) in xor_table
```

## Circuit Organization

### State Columns

Representing 1600-bit state:

```
Full state:
  25 lanes x 8 bytes = 200 byte columns

Alternative:
  25 lanes as 25 columns (if field large enough)

Per-round columns:
  State before round
  State after each operation (or just final)
  Intermediate values as needed
```

### Round Structure

Per-round layout:

```
Option 1: All operations in one row
  One row per round
  24 rows per block + overhead
  Many columns for intermediates

Option 2: Multiple rows per round
  Row per operation (5 rows per round)
  120 rows per block
  Fewer columns per row

Trade-off:
  Row count vs column count
  Constraint complexity
```

### Multi-Block Processing

Handling long messages:

```
Each 136-byte block:
  XOR into state (absorption)
  Apply 24 rounds of Keccak-f

Multi-block layout:
  Block 0: Rows 0-N
  Block 1: Rows N+1-2N
  ...

State continuity:
  Final state of block i = Initial state of block i+1
  Constraint at block boundaries
```

## Lookup Tables

### Theta Tables

Column parity computation:

```
5-way XOR table:
  (a, b, c, d, e, a XOR b XOR c XOR d XOR e)
  Size: 256^5 = Too large!

Alternative: Chain XORs
  (a, b, ab) in xor_table
  (ab, c, abc) in xor_table
  (abc, d, abcd) in xor_table
  (abcd, e, abcde) in xor_table
  4 lookups per column per byte
```

### Chi Tables

Nonlinear operation:

```
Chi function per byte:
  out = x XOR ((NOT y) AND z)

Table approach:
  (x, y, z, chi_out) table
  Size: 256^3 = 16 million entries (too large)

Decomposed approach:
  NOT lookup or constraint
  AND table
  XOR table
  3 operations per byte position
```

### Round Constants

Iota operation:

```
Table: {(round, RC_bytes[round])}

For each round r:
  (r, rc_byte_0, rc_byte_1, ..., rc_byte_7)

Only 24 entries per byte position.
Very small table.
```

## Optimization Techniques

### Bit-Sliced Representation

Alternative representation:

```
Instead of 25 lanes:
  64 slices, each containing 25 bits

Slice[z] = {A[x][y][z] : x, y in 0..4}

Benefits:
  Theta and chi operate on slices
  Natural for some operations

In constraints:
  Represent slice as single field element
  Operations on slices
```

### Lazy State Representation

Defer materialization:

```
Not all intermediate states needed:
  Only constrain final output
  Derive intermediates as needed

Apply:
  After theta: Full state
  After rho-pi: Can be computed
  After chi: Full state (nonlinear)
  After iota: Full state
```

### Sparse Keccak

For special use cases:

```
If input is mostly zeros:
  Track only nonzero elements
  Skip operations on zeros

Not always applicable:
  Depends on input patterns
  Helps for certain applications
```

## Key Concepts

- **Sponge construction**: Absorption and squeezing phases
- **Keccak-f permutation**: 24 rounds of 5 operations
- **Lane**: 64-bit element of 5x5 state array
- **Chi**: Only nonlinear operation (row mixing)
- **Round constant**: Symmetry-breaking in iota step

## Design Considerations

### State Representation

| Full State | Partial State |
|------------|---------------|
| 200 columns | Fewer columns |
| Direct access | Computed access |
| More memory | Less memory |
| Simpler constraints | Complex tracking |

### Round Layout

| One Row/Round | Multiple Rows/Round |
|---------------|---------------------|
| Wide rows | Narrower rows |
| 24 rows/block | 120+ rows/block |
| More columns | Fewer columns |
| Higher degree | Lower degree |

## Related Topics

- [SHA-256 Circuit](01-sha256-circuit.md) - Comparison hash
- [Poseidon Circuit](03-poseidon-circuit.md) - ZK-native alternative
- [Binary Operations](../../04-zkvm-architecture/02-state-machine-design/04-binary-operations.md) - Bitwise operations
- [Precompile Architecture](../01-precompile-framework/02-precompile-architecture.md) - Framework context
