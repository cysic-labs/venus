# Keccak-f Precompile

## Overview

The Keccak-f precompile implements the Keccak permutation function used in SHA-3 and Keccak-256. Keccak-256 is particularly important in blockchain applications, being the primary hash function of Ethereum. The precompile provides efficient constraint-based verification of Keccak-f computations, dramatically reducing the cost compared to instruction-level emulation.

Keccak operates on a 1600-bit state organized as a 5×5 array of 64-bit lanes. The Keccak-f permutation applies 24 rounds of five operations: theta (θ), rho (ρ), pi (π), chi (χ), and iota (ι). Each operation has specific constraint requirements, with chi being the only nonlinear operation requiring special attention.

This document describes the Keccak-f precompile design, constraint representation, and optimization strategies.

## Keccak Algorithm Structure

### State Representation

The Keccak state format:

```
State array:
  5 × 5 × 64 = 1600 bits
  Lanes: A[x][y] where x, y ∈ {0,1,2,3,4}
  Each lane: 64-bit value

Organization:
  State as 25 lanes
  Each lane as field element(s)
  Various representations possible
```

### Round Operations

The five Keccak-f operations:

```
θ (theta):
  Column parity computation
  XOR across columns
  Linear operation

ρ (rho):
  Lane rotation
  Each lane rotated by fixed amount
  Linear operation

π (pi):
  Lane permutation
  Rearrange positions
  Linear operation

χ (chi):
  Row mixing
  Nonlinear: A[x] = A[x] XOR ((NOT A[x+1]) AND A[x+2])
  Critical for security

ι (iota):
  Round constant addition
  XOR with round constant
  Linear operation
```

### Round Count

Number of permutation rounds:

```
Keccak-f[1600]:
  24 rounds
  Each round applies all five operations
  Total: 24 × (θ + ρ + π + χ + ι)
```

## Constraint Representation

### Lane Representation

Encoding lanes in constraints:

```
Bit representation:
  Each lane as 64 bits
  Each bit as field element (0 or 1)
  1600 columns for full state

Limb representation:
  Each lane as multiple limbs
  e.g., 4 × 16-bit limbs per lane
  100 columns for state (4 limbs × 25 lanes)

Field element representation:
  Lane as single field element
  25 columns for state
  Bitwise ops via decomposition
```

### Theta Constraints

Constraining the theta operation:

```
Theta computation:
  C[x] = A[x,0] XOR A[x,1] XOR A[x,2] XOR A[x,3] XOR A[x,4]
  D[x] = C[x-1] XOR ROT(C[x+1], 1)
  A'[x,y] = A[x,y] XOR D[x]

Constraints:
  C[x] is column XOR (5 inputs)
  D[x] computed from C values
  Each lane XORed with D
  All via bit-level XOR constraints
```

### Chi Constraints

Constraining the nonlinear operation:

```
Chi computation:
  A'[x,y] = A[x,y] XOR ((NOT A[x+1,y]) AND A[x+2,y])

Per-bit constraint:
  out = in XOR ((NOT next) AND next2)
  out = in XOR ((1 - next) * next2)
  out = in XOR next2 - next * next2

Degree:
  Degree 2 per bit
  Manageable nonlinearity
```

### Round Constant Constraints

Applying iota constants:

```
Iota operation:
  A[0,0] = A[0,0] XOR RC[round]
  Only affects lane (0,0)

Constraint:
  Lane (0,0) XORed with constant
  Constant embedded in constraint
  24 different constants for 24 rounds
```

## Bit-Level Implementation

### Bit Decomposition

Converting lanes to bits:

```
Decomposition:
  lane = b_0 + b_1*2 + b_2*4 + ... + b_63*2^63

Bit constraints:
  b_i * (b_i - 1) = 0 for all i
  Ensures bits are 0 or 1
```

### XOR Implementation

Bit-level XOR:

```
Two-input XOR:
  a XOR b = a + b - 2*a*b

Multi-input XOR (theta):
  Need pairwise or tree reduction
  Intermediate variables for efficiency
```

### Rotation Implementation

Bit rotation:

```
Left rotation by r:
  ROT(lane, r) = (lane >> (64-r)) | (lane << r)

At bit level:
  out_i = in_{(i-r) mod 64}
  Just renaming/rewiring bits
  No arithmetic constraints needed
```

## Lookup-Based Implementation

### Lookup Tables for Chi

Using lookups for nonlinearity:

```
Chi on small chunks:
  Break lane into chunks (e.g., 4 bits)
  Lookup table for chi on chunk
  Combine chunk results

Table size:
  4-bit input × 3 lanes = 12 bits → 4 bits out
  4096 entries for 4-bit chi lookup
```

### XOR Lookup Tables

Efficient XOR via lookup:

```
Multi-input XOR table:
  Precompute XOR for small inputs
  8-bit chunks: 256 × 256 table

Usage:
  Chunk lanes into bytes
  Lookup byte-level XOR
  Chain for full result
```

### Trade-offs

Lookup vs native constraints:

```
Lookup advantages:
  Lower constraint degree
  Uniform structure
  Batching benefits

Native advantages:
  No table commitment
  Direct constraint
  May be simpler for small ops
```

## Round Processing

### Single Round Circuit

Constraints for one round:

```
Round structure:
  Input: 25 lanes (state_in)
  Output: 25 lanes (state_out)

Steps:
  1. Apply theta
  2. Apply rho + pi (can combine)
  3. Apply chi
  4. Apply iota (round r)

Total constraints per round:
  Depends on implementation
  ~5000-10000 typical
```

### Multi-Round Processing

Handling 24 rounds:

```
Approach A - Unrolled:
  All 24 rounds as constraints
  Large circuit but single invocation
  ~120,000-240,000 constraints

Approach B - Iterated:
  One round circuit, iterate 24 times
  Smaller per-round, more invocations
  State chains between invocations

Approach C - Hybrid:
  Group rounds (e.g., 4 at a time)
  Balance size and invocations
```

### State Transition

Connecting rounds:

```
Between rounds:
  state_out[round_i] = state_in[round_{i+1}]

Constraint:
  Equality of state lanes
  Or permutation argument if rows differ
```

## Keccak Sponge Construction

### Absorbing Phase

Processing input blocks:

```
Sponge absorb:
  XOR input block with rate portion of state
  Apply Keccak-f permutation
  Repeat for each block

Rate:
  Keccak-256: 1088 bits (136 bytes)
  Portion of state for input

Constraint:
  Input XORed into state correctly
  Permutation applied after
```

### Squeezing Phase

Producing output:

```
Sponge squeeze:
  Extract rate bits as output
  For Keccak-256: 256 bits needed
  Single squeeze sufficient (256 < 1088)

Output:
  First 256 bits of state after final permutation
```

### Padding

Input padding rules:

```
Keccak padding:
  Append 0x01 (domain separator for Keccak-256)
  Append zeros
  Append 0x80 (multi-rate padding)

Constraint:
  Padding correctly applied
  Rate boundary respected
```

## Optimization Strategies

### Constraint Reduction

Minimizing constraint count:

```
Techniques:
  Combine linear operations (rho, pi)
  Efficient XOR trees
  Lookup tables for nonlinear ops

Result:
  Target: ~5000 constraints per round
  Total: ~120,000 for 24 rounds
```

### Parallelization

Exploiting independence:

```
Within round:
  Theta columns independent
  Chi rows independent
  Lane operations parallel

Across hashes:
  Independent messages fully parallel
```

### Memory Efficiency

Managing state:

```
State size:
  1600 bits core
  Intermediate values for constraints

Optimization:
  Reuse columns across rounds
  Minimize simultaneous state
```

## Precompile Interface

### Input Format

Data provided to precompile:

```
Input:
  Message to hash (variable length)
  Or: pre-padded blocks

Format:
  Byte-aligned input
  Length specified or padded
```

### Output Format

Result from precompile:

```
Output:
  256-bit hash (Keccak-256)
  As 32 bytes or 4 field elements

Format:
  Big-endian or little-endian per spec
```

### Invocation

Calling the precompile:

```
Interface:
  Write input to designated buffer
  Invoke precompile
  Read hash from output buffer
```

## Key Concepts

- **Keccak-f permutation**: Core 24-round transformation
- **Sponge construction**: Absorb input, squeeze output
- **Chi operation**: Only nonlinear step, degree-2 constraints
- **Lane-based state**: 5×5×64-bit organization
- **Bit-level vs lookup**: Trade-off in constraint approach

## Design Trade-offs

### Implementation Style

| Bit-Level | Lookup-Based |
|-----------|--------------|
| More constraints | Fewer constraints |
| No table overhead | Table commitment |
| Direct implementation | Chunked processing |

### Round Unrolling

| Fully Unrolled | Iterative |
|----------------|-----------|
| Larger circuit | Smaller circuit |
| Single invocation | 24 invocations |
| More parallelism | Less parallelism |

## Related Topics

- [Precompile Concepts](../01-precompile-design/01-precompile-concepts.md) - Precompile overview
- [Constraint Representation](../01-precompile-design/02-constraint-representation.md) - Encoding operations
- [SHA-256 Precompile](02-sha256-precompile.md) - Alternative hash precompile
- [Chunking Strategies](../01-precompile-design/03-chunking-strategies.md) - Block processing

