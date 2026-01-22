# Chunking Strategies

## Overview

Chunking strategies determine how precompiles process inputs that exceed the capacity of a single precompile invocation. Many cryptographic operations, particularly hash functions, accept variable-length inputs that must be processed in blocks or chunks. The zkVM must handle arbitrary input sizes while maintaining efficient constraint representation and proper chaining between chunks.

Effective chunking strategies balance multiple concerns: minimizing overhead per chunk, maintaining cryptographic correctness across chunk boundaries, and enabling parallel processing where possible. The strategy chosen affects both proving efficiency and the complexity of the precompile implementation.

This document explores chunking approaches, their trade-offs, and implementation considerations for zkVM precompiles.

## Chunking Fundamentals

### Why Chunk

Motivations for chunked processing:

```
Variable input sizes:
  Hash functions accept any length
  Fixed circuit can't handle arbitrary sizes
  Chunking provides flexibility

Circuit size limits:
  Single operation has max complexity
  Large inputs exceed practical limits
  Chunking bounds per-operation cost

Parallelization:
  Independent chunks can be processed in parallel
  Reduces wall-clock proving time
  Better resource utilization
```

### Chunk Definition

What constitutes a chunk:

```
Chunk properties:
  Fixed maximum size
  Contains portion of input
  Processed by single precompile call

Example (SHA-256):
  Block size: 512 bits (64 bytes)
  Each block is one chunk
  Multi-block messages: multiple chunks
```

### Chaining Requirement

Connecting chunk results:

```
Hash function chaining:
  State from chunk N feeds chunk N+1
  Final chunk produces output

Chaining constraint:
  Output state of chunk i = Input state of chunk i+1
  Proven by constraint equality
```

## Hash Function Chunking

### Block-Based Processing

Standard hash block handling:

```
SHA-256 model:
  Input: arbitrary length message
  Padding: to multiple of 512 bits
  Processing: one 512-bit block at a time

Chunk = Block:
  Natural chunking at block boundaries
  Each chunk is one compression function call
  State chains through blocks
```

### State Initialization

Starting state for first chunk:

```
Initial state:
  Defined by hash function (IV)
  Fixed value for first chunk

Constraint:
  First chunk state_in = IV
  Subsequent chunks: state_in = prev state_out
```

### Final Block Handling

Processing the last chunk:

```
Finalization:
  May include length field
  Padding rules must be followed
  Output is final hash

Constraint:
  is_final_block indicator
  Length embedded correctly
  Output state is hash result
```

### Multi-Block Message Flow

Processing complete messages:

```
Flow for N-block message:
  Chunk 0: IV → compress(block_0) → state_1
  Chunk 1: state_1 → compress(block_1) → state_2
  ...
  Chunk N-1: state_{N-1} → compress(block_{N-1}) → final_hash

Constraints:
  Each chunk: correct compression
  Chain: state outputs connect to inputs
  Final: last output is message hash
```

## Padding Strategies

### Standard Padding

Following specification:

```
SHA-256 padding:
  Append 1 bit
  Append 0 bits until 448 mod 512
  Append 64-bit length

Keccak padding:
  Append domain separator
  Append multi-rate padding

Constraint:
  Padding correctly computed
  Placed in final chunk(s)
```

### Pre-computed Padding

Handling padding before proving:

```
Approach:
  Compute padded message in preprocessing
  Chunked message ready for prover

Benefit:
  Simpler chunk constraints
  Padding logic external to circuit

Cost:
  Larger input if padding significant
  Preprocessing step required
```

### In-Circuit Padding

Computing padding in constraints:

```
Approach:
  Constraints compute padding
  Based on message length

Complexity:
  Length tracking across chunks
  Padding rules in constraints
  More flexible but more constraints
```

## Chunk State Management

### State Representation

Encoding inter-chunk state:

```
State format:
  Fixed number of words
  Matches hash internal state

SHA-256 state:
  8 words × 32 bits = 256 bits

Keccak state:
  25 lanes × 64 bits = 1600 bits
```

### State Commitment

Proving state consistency:

```
Commitment approach:
  Hash the state itself
  Commitment chains

Direct equality:
  State columns match directly
  Permutation or equality constraints
```

### State Validation

Ensuring state is valid:

```
Initial state:
  Must equal IV for first chunk
  Must equal prev output for subsequent

Final state:
  Becomes hash output for final chunk
  Or feeds next chunk
```

## Parallel Chunk Processing

### Independent Chunks

When chunks can be parallel:

```
Scenario:
  Multiple independent messages
  Each message's chunks sequential
  Different messages parallel

Benefit:
  Parallel proving
  Better throughput
```

### Merkle Tree Hashing

Parallelizing tree structures:

```
Approach:
  Hash leaves in parallel
  Combine in tree structure
  Each level more parallelism

Chunking:
  Each leaf hash is independent
  Interior nodes depend on children
  Level-by-level processing
```

### Chunk Scheduling

Ordering chunk processing:

```
Sequential chunks:
  Same message chunks in order
  State dependency requires order

Batch processing:
  Collect multiple messages
  Schedule for maximum parallelism
```

## Large Input Handling

### Streaming Inputs

Processing very large inputs:

```
Challenge:
  Input may exceed memory
  Can't hold entire message

Solution:
  Stream chunks through prover
  Process and discard
  Maintain only active state
```

### Chunk Accumulation

Combining results across chunks:

```
Accumulator:
  Running state through chunks
  Final accumulator is output

Constraint:
  Correct accumulation at each step
  No information lost
```

### Memory Efficiency

Minimizing memory usage:

```
Strategy:
  Fixed memory per chunk
  Release after chunk complete
  Bounded regardless of input size

Implementation:
  State buffer: O(state_size)
  Chunk buffer: O(chunk_size)
  Total: O(1) relative to input
```

## Chunk Verification

### Per-Chunk Constraints

Constraints for each chunk:

```
Core constraints:
  Correct operation (compression, etc.)
  Input format valid
  State transition correct

Interface constraints:
  Input matches expected
  Output formatted correctly
```

### Cross-Chunk Constraints

Linking chunks together:

```
Chain constraints:
  state_out[i] = state_in[i+1]

Ordering constraints:
  Chunk i processed before chunk i+1
  Or: permutation-based linking
```

### Final Output Constraint

Extracting final result:

```
For last chunk:
  is_final = 1
  output = state_out (transformed if needed)

Public output:
  Hash result becomes public
  Part of proof interface
```

## Optimization Techniques

### Chunk Size Tuning

Choosing optimal chunk size:

```
Trade-offs:
  Larger chunks: less overhead, more constraints per chunk
  Smaller chunks: more overhead, better parallelism

Optimization:
  Match to hardware capabilities
  Consider common input sizes
  Balance proving time
```

### Batched Processing

Processing multiple messages:

```
Approach:
  Collect messages
  Interleave chunks
  Share constraints where possible

Benefit:
  Amortized overhead
  Better constraint utilization
```

### Caching Intermediate States

Reusing common computations:

```
Scenario:
  Multiple messages with common prefix
  Same initial chunks

Optimization:
  Cache intermediate state
  Resume from cached point
  Reduces redundant proving
```

## Error Handling

### Invalid Chunks

Handling malformed inputs:

```
Detection:
  Chunk validation constraints
  Format checking

Response:
  Constraint failure for invalid input
  Or: defined error output
```

### Missing Chunks

Ensuring completeness:

```
Verification:
  All expected chunks present
  No gaps in sequence
  Proper termination
```

## Key Concepts

- **Chunking**: Dividing large inputs into fixed-size pieces
- **State chaining**: Connecting chunk outputs to inputs
- **Block-based processing**: Chunks align with algorithm blocks
- **Padding handling**: Correct termination of input
- **Parallel chunks**: Independent processing for throughput

## Design Trade-offs

### Chunk Size

| Large Chunks | Small Chunks |
|--------------|--------------|
| Less overhead | More overhead |
| Higher peak memory | Lower peak memory |
| Less parallelism | More parallelism |

### Padding Location

| Pre-computed Padding | In-Circuit Padding |
|---------------------|-------------------|
| Simpler constraints | Complex constraints |
| Larger input | Flexible |
| External logic | Self-contained |

## Related Topics

- [Precompile Concepts](01-precompile-concepts.md) - Precompile overview
- [Constraint Representation](02-constraint-representation.md) - Encoding operations
- [Keccak Precompile](../02-hash-precompiles/01-keccak-f-precompile.md) - Hash chunking example
- [SHA-256 Precompile](../02-hash-precompiles/02-sha256-precompile.md) - Block processing example

