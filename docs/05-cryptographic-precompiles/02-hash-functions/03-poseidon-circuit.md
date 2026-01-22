# Poseidon Circuit

## Overview

Poseidon is a cryptographic hash function designed specifically for zero-knowledge proof systems. Unlike SHA-256 and Keccak which were designed for software efficiency and later adapted to circuits, Poseidon was built from the ground up to minimize constraint count while maintaining cryptographic security. Its algebraic structure uses field arithmetic directly, avoiding the costly bit decompositions required by traditional hash functions.

The efficiency advantage of Poseidon is dramatic: while SHA-256 requires approximately 25,000 constraints per hash and Keccak requires around 150,000, Poseidon can compute a hash in as few as 200-300 constraints. This makes Poseidon the preferred choice for ZK-native applications like Merkle trees in rollups, nullifier generation, and recursive proof composition where hash operations dominate the constraint count.

This document covers Poseidon's algebraic design, S-box construction, constraint patterns, and parameter selection for different security levels.

## Algebraic Design

### Sponge Structure

Poseidon uses a sponge construction:

```
State: t field elements
Rate: r elements (absorbed/squeezed per permutation)
Capacity: c elements (security buffer)
t = r + c

Typical configurations:
  t = 3, r = 2, c = 1 (2-to-1 hash)
  t = 5, r = 4, c = 1 (4-to-1 hash)
  t = 9, r = 8, c = 1 (8-to-1 hash)

Absorption:
  State[0:r] += input_chunk
  State = Permutation(State)

Squeezing:
  Output = State[0:output_size]
```

### Permutation Rounds

Full and partial rounds:

```
Round structure:
  R_F/2 full rounds at beginning
  R_P partial rounds in middle
  R_F/2 full rounds at end

Full round:
  All state elements through S-box
  Complexity: t S-boxes per round

Partial round:
  Only first element through S-box
  Other elements unchanged
  Complexity: 1 S-box per round

Total S-boxes:
  R_F * t + R_P
```

### S-Box Function

Nonlinear component:

```
S-box: x -> x^α

For prime field F_p:
  α = 3, 5, or 7 (common choices)
  Must be coprime with p-1

Examples:
  x^5 for many primes
  x^7 for some fields

Constraint:
  y = x^α
  For α = 5: y = x * x * x * x * x
  Or via intermediate: t = x^2, y = t^2 * x
```

### MDS Matrix

Linear diffusion layer:

```
MDS (Maximum Distance Separable) matrix:
  M is t x t matrix over F_p
  State' = M * State

Properties:
  Any t elements determine all t elements
  Maximum branch number
  Provides diffusion

Constraint:
  For each output element:
    out[i] = sum(M[i][j] * in[j]) for j in 0..t-1
  Linear constraints (degree 1)
```

## Constraint Patterns

### Full Round Constraints

Complete round transformation:

```
Full round operations:
  1. Add round constants: state[i] += RC[round][i]
  2. Apply S-box: state[i] = state[i]^α for all i
  3. Apply MDS: state = M * state

Constraints:

Add constants (linear):
  after_add[i] = before[i] + RC[round][i]

S-box (nonlinear):
  after_sbox[i] = after_add[i]^α

For α = 5:
  sq[i] = after_add[i]^2
  qt[i] = sq[i]^2
  after_sbox[i] = qt[i] * after_add[i]

MDS (linear):
  after_mds[i] = Σ M[i][j] * after_sbox[j]
```

### Partial Round Constraints

Reduced S-box application:

```
Partial round operations:
  1. Add round constants (all elements)
  2. Apply S-box to first element only
  3. Apply MDS matrix

Constraints:

Add constants:
  after_add[i] = before[i] + RC[round][i]

S-box (only element 0):
  after_sbox[0] = after_add[0]^α
  after_sbox[i] = after_add[i] for i > 0

MDS:
  after_mds[i] = Σ M[i][j] * after_sbox[j]
```

### Optimized Partial Rounds

Reduced constraint count:

```
Observation:
  MDS mixes element 0 into all elements
  Only element 0 goes through S-box

Optimization:
  Fuse round constants with MDS
  Reduce intermediate columns

Sparse MDS technique:
  Use structured MDS for faster computation
  Fewer multiplications
```

## Circuit Organization

### State Columns

Minimal column layout:

```
For state size t:
  state[0], state[1], ..., state[t-1]

Per-round columns:
  Before round: t elements
  After S-box: t elements (or just modified ones)
  After MDS: t elements (next round input)

Optimization:
  Combine rounds where possible
  Reduce intermediate storage
```

### Round Layout

Trace structure:

```
Row per round:
  Row 0: Initial state (input)
  Row 1: After round 0
  Row 2: After round 1
  ...
  Row R_F + R_P: Final state (output)

Columns:
  state[0..t-1]: Current state
  round_idx: Round number
  is_full_round: Full or partial round
  round_constants: Current RC values
```

### Batched Hashing

Multiple hashes in one trace:

```
Sequential batching:
  Hash 0: Rows 0 to R
  Hash 1: Rows R+1 to 2R
  ...

Parallel columns:
  Multiple state columns for parallel hashes
  Same MDS and constants shared

Constraint:
  Each hash independent
  Shared lookup tables
```

## Parameter Selection

### Security Parameters

Choosing safe parameters:

```
Security level s:
  Target: s bits of security
  Typical: s = 128 or s = 256

Round numbers:
  R_F (full rounds): For algebraic attacks
  R_P (partial rounds): For statistical attacks

Conservative choices:
  t = 3: R_F = 8, R_P = 56
  t = 5: R_F = 8, R_P = 57
  t = 9: R_F = 8, R_P = 57

Field-dependent:
  Different primes may need adjustment
  Consult Poseidon paper/implementation
```

### Field Selection

Prime field considerations:

```
Native field:
  Use proof system's native field
  No field conversion overhead

Common fields:
  BN254 scalar field
  BLS12-381 scalar field
  Goldilocks (2^64 - 2^32 + 1)

S-box exponent:
  Must be coprime to p-1
  α = 5 works for most fields
```

### MDS Matrix Construction

Generating secure matrices:

```
Cauchy matrix construction:
  M[i][j] = 1 / (x[i] - y[j])
  Where x, y are distinct field elements

Circulant matrix:
  M[i][j] = c[(j-i) mod t]
  Efficient to apply

Security requirement:
  All minors nonzero (MDS property)
  Verified during parameter generation
```

## Optimization Techniques

### Constraint Minimization

Reducing constraint count:

```
S-box optimization:
  x^5 = x * x^4 = x * (x^2)^2
  Only 2 intermediate multiplications

Constant folding:
  Precompute RC values
  Include in MDS if beneficial

Round combining:
  Fuse linear operations across rounds
  Reduce intermediate columns
```

### Partial Round Optimization

Exploiting partial round structure:

```
Most work in partial rounds:
  Only 1 S-box vs t S-boxes

Partial round chain:
  State transformation mostly linear
  Only element 0 is nonlinear

Optimization:
  Express partial rounds compactly
  Fewer constraints for partial section
```

### Lookup Table Usage

When tables help:

```
For S-box:
  If α is large, lookup may help
  (x, x^α) table

For small fields:
  Full S-box table feasible
  Reduce constraint degree

Trade-off:
  Table commitment vs constraints
  Usually constraints cheaper for Poseidon
```

## Comparison with Other Hashes

### Constraint Count Comparison

Side-by-side analysis:

```
SHA-256:
  ~25,000 constraints per 512-bit block
  32-bit word operations, many bit decompositions

Keccak-256:
  ~150,000 constraints per block
  64-bit operations, larger state

Poseidon (t=3):
  ~300 constraints per 2-element hash
  Native field arithmetic

For Merkle tree of depth 20:
  SHA-256: ~500,000 constraints
  Poseidon: ~6,000 constraints
  80x improvement
```

### Use Case Suitability

When to use each:

```
Poseidon:
  ZK-native applications
  Merkle trees, nullifiers
  Recursive proof composition
  Internal ZK computations

SHA-256:
  Bitcoin compatibility
  External verification
  Interop with non-ZK systems

Keccak:
  Ethereum compatibility
  Smart contract integration
  EVM precompile matching
```

## Key Concepts

- **Poseidon**: ZK-optimized hash using field arithmetic
- **S-box**: Nonlinear x^α transformation
- **MDS matrix**: Maximum diffusion mixing layer
- **Full/partial rounds**: Different S-box application patterns
- **Native field**: Direct field operations without bit decomposition

## Design Considerations

### Width vs Efficiency

| Narrow State (t=3) | Wide State (t=9) |
|-------------------|------------------|
| Fewer constraints | More constraints |
| 2-to-1 hash | 8-to-1 hash |
| More rounds for tree | Fewer tree levels |
| Lower throughput | Higher throughput |

### Security vs Performance

| Conservative | Aggressive |
|--------------|------------|
| More rounds | Fewer rounds |
| Higher security margin | Lower margin |
| More constraints | Fewer constraints |
| Standard parameters | Optimized parameters |

## Related Topics

- [SHA-256 Circuit](01-sha256-circuit.md) - Traditional hash comparison
- [Keccak Circuit](02-keccak-circuit.md) - Ethereum-compatible hash
- [Arithmetic Operations](../../04-zkvm-architecture/02-state-machine-design/03-arithmetic-operations.md) - Field arithmetic
- [Proof Recursion](../../03-proof-management/03-proof-pipeline/02-proof-recursion.md) - Recursive hashing use case
