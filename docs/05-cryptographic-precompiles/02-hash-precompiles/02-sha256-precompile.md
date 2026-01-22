# SHA-256 Precompile

## Overview

The SHA-256 precompile implements the SHA-256 hash function, one of the most widely used cryptographic hash functions. SHA-256 is used extensively in Bitcoin, TLS certificates, and many cryptographic protocols. The precompile provides efficient constraint-based verification of SHA-256 computations, enabling blockchain and cryptographic applications to run efficiently within the zkVM.

SHA-256 operates on 512-bit blocks, processing each block through 64 rounds of compression that mix the block data with an evolving 256-bit state. The algorithm uses 32-bit word operations including addition, rotation, shift, and bitwise logic. These operations require careful constraint representation for efficient proving.

This document describes the SHA-256 precompile design, constraint encoding, and optimization approaches.

## SHA-256 Algorithm Structure

### Message Format

Input processing:

```
Input:
  Arbitrary length message
  Processed in 512-bit (64-byte) blocks

Padding:
  Append 1 bit
  Append zeros until 448 bits mod 512
  Append 64-bit big-endian length
  Result: multiple of 512 bits
```

### State Representation

The working state:

```
Hash state:
  8 × 32-bit words: H[0..7]
  Also called a, b, c, d, e, f, g, h during compression

Working variables:
  A, B, C, D, E, F, G, H during round processing

Message schedule:
  W[0..63]: 64 × 32-bit words derived from block
```

### Round Operations

SHA-256 round function:

```
Sigma functions:
  Σ0(x) = ROTR(x,2) XOR ROTR(x,13) XOR ROTR(x,22)
  Σ1(x) = ROTR(x,6) XOR ROTR(x,11) XOR ROTR(x,25)
  σ0(x) = ROTR(x,7) XOR ROTR(x,18) XOR SHR(x,3)
  σ1(x) = ROTR(x,17) XOR ROTR(x,19) XOR SHR(x,10)

Choose and Majority:
  Ch(x,y,z) = (x AND y) XOR ((NOT x) AND z)
  Maj(x,y,z) = (x AND y) XOR (x AND z) XOR (y AND z)

Round:
  T1 = H + Σ1(E) + Ch(E,F,G) + K[i] + W[i]
  T2 = Σ0(A) + Maj(A,B,C)
  New values: H=G, G=F, F=E, E=D+T1, D=C, C=B, B=A, A=T1+T2
```

### Round Count

Compression function rounds:

```
Rounds per block:
  64 rounds
  Each round uses different K constant
  Message schedule expanded in first 16 rounds
```

## Constraint Representation

### Word Representation

32-bit words in constraints:

```
Options:

Single field element:
  Word as field element (if field > 32 bits)
  Simple but bitwise ops need decomposition

Bit representation:
  32 bits per word
  8 × 32 = 256 bits for state
  Direct bitwise constraint access

Limb representation:
  Split into smaller pieces
  e.g., 4 × 8-bit limbs
  Balance between extremes
```

### Rotation Constraints

Right rotation:

```
ROTR(x, n):
  Result is bit rotation
  No arithmetic, just rewiring

Constraint:
  At bit level: out[i] = in[(i+n) mod 32]
  At word level: decompose, rotate, recombine
```

### Shift Constraints

Right shift:

```
SHR(x, n):
  Upper n bits become zero
  Rest shift right

Constraint:
  out = (in - (in mod 2^(32-n))) / 2^(32-n)
  Or at bit level: out[i] = in[i+n] for i < 32-n, else 0
```

### Addition Constraints

Modular addition mod 2^32:

```
Addition:
  result = (a + b) mod 2^32

Constraint:
  a + b = result + carry × 2^32
  carry ∈ {0, 1}
  result ∈ [0, 2^32)

Multiple additions:
  Chain with intermediate carries
  Or: add multiple with multi-bit carry
```

### XOR Constraints

Bitwise XOR:

```
At bit level:
  out = a XOR b = a + b - 2*a*b

At word level:
  Decompose to bits, XOR, recombine
  Or: lookup table for chunks
```

### Choose Function Constraints

Ch(x, y, z):

```
Definition:
  Ch(x,y,z) = (x AND y) XOR ((NOT x) AND z)

Simplification:
  Ch(x,y,z) = z XOR (x AND (y XOR z))

Per-bit constraint:
  out = z + x*(y - z) (field arithmetic)
  Efficient formulation
```

### Majority Function Constraints

Maj(x, y, z):

```
Definition:
  Maj(x,y,z) = (x AND y) XOR (x AND z) XOR (y AND z)

Alternative:
  Maj = bit that appears at least twice
  Maj = xy + xz + yz - 2xyz

Per-bit constraint:
  out = x*y + x*z + y*z - 2*x*y*z
  Degree 3, may need reduction
```

## Message Schedule

### Initial Words

Loading block into schedule:

```
W[0..15]:
  Directly from message block
  16 × 32-bit words
  Big-endian byte order
```

### Schedule Expansion

Computing W[16..63]:

```
Formula:
  W[i] = σ1(W[i-2]) + W[i-7] + σ0(W[i-15]) + W[i-16]

Constraints:
  σ0 and σ1 computations
  Four additions (mod 2^32)
  48 schedule words to compute
```

## Round Processing

### Single Round

Constraints for one round:

```
Computations:
  Σ1(E): 3 rotations, 2 XORs
  Ch(E,F,G): choose function
  T1 = H + Σ1(E) + Ch(E,F,G) + K[i] + W[i]: 4 additions
  Σ0(A): 3 rotations, 2 XORs
  Maj(A,B,C): majority function
  T2 = Σ0(A) + Maj(A,B,C): 1 addition
  A' = T1 + T2: 1 addition
  E' = D + T1: 1 addition

State update:
  Shift: H=G, G=F, F=E, D=C, C=B, B=A
  Compute: E=D+T1, A=T1+T2
```

### Multi-Round Processing

64 rounds per block:

```
Approach:
  Chain rounds together
  Round i output = Round i+1 input

Total constraints per block:
  64 rounds × constraints_per_round
  Plus message schedule
  ~10,000-20,000 constraints typical
```

## Block Processing

### Initialization

Starting compression:

```
First block:
  Use standard IV (initial hash values)
  H[0..7] = defined constants

Subsequent blocks:
  Use previous block's output
  Chaining value
```

### Finalization

Completing block:

```
After 64 rounds:
  Add working variables to input state
  H'[i] = H[i] + working[i] (mod 2^32)

For each of 8 words:
  Addition constraint
```

### Multi-Block Messages

Processing long messages:

```
Chaining:
  Block 0: IV → compress → H1
  Block 1: H1 → compress → H2
  ...
  Block n: Hn → compress → final hash

Constraints:
  Per-block: compression function
  Between blocks: state equality
```

## Optimization Techniques

### Lookup Tables

Using lookups for efficiency:

```
Sigma functions:
  Precompute for small chunks
  Lookup σ0, σ1, Σ0, Σ1 on chunks

Choose/Majority:
  Lookup tables for 4-8 bit chunks
  Combine chunk results

Benefit:
  Lower constraint degree
  Fewer constraints for nonlinear ops
```

### Constraint Batching

Grouping operations:

```
Approach:
  Combine related constraints
  Evaluate together

Example:
  T1 involves 4 additions
  Batch into single multi-add constraint
  Fewer intermediate variables
```

### Column Reuse

Efficient trace layout:

```
Strategy:
  Reuse columns across rounds
  State columns cycle through rounds
  Minimize total column count
```

## Precompile Interface

### Input Specification

Providing data to SHA-256:

```
Input:
  Message bytes (variable length)
  Or: pre-padded 512-bit blocks

Format:
  Byte array
  Length as parameter or padded
```

### Output Specification

Receiving hash result:

```
Output:
  256-bit hash value
  As 32 bytes
  Big-endian per SHA-256 spec
```

### Invocation Model

Calling the precompile:

```
Steps:
  1. Write message to input buffer
  2. Invoke SHA-256 precompile
  3. Read 32-byte hash from output
```

## Key Concepts

- **SHA-256 compression**: 64-round block processing
- **Message schedule**: Expanding 16 words to 64
- **Sigma functions**: Rotation and shift combinations
- **Choose and Majority**: Nonlinear mixing functions
- **Modular addition**: Core arithmetic in SHA-256

## Design Trade-offs

### Bit vs Lookup

| Bit-Level | Lookup-Based |
|-----------|--------------|
| Direct constraints | Table overhead |
| Higher constraint count | Lower constraint count |
| Flexible | Fixed chunk sizes |

### Round Unrolling

| Unrolled | Iterative |
|----------|-----------|
| 64 round copies | Reuse round circuit |
| Larger but faster | Smaller but more calls |
| One invocation | Multiple invocations |

## Related Topics

- [Precompile Concepts](../01-precompile-design/01-precompile-concepts.md) - Precompile overview
- [Constraint Representation](../01-precompile-design/02-constraint-representation.md) - Encoding operations
- [Keccak Precompile](01-keccak-f-precompile.md) - Alternative hash
- [Chunking Strategies](../01-precompile-design/03-chunking-strategies.md) - Block processing

