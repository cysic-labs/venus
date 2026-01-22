# Trace to Witness

## Overview

The trace-to-witness transformation converts execution traces into the witness format required by the proving system. While the trace captures what happened during execution, the witness organizes this data into constraint-ready polynomial evaluations. This transformation is the bridge between emulation and proving.

The witness must satisfy all constraints defined by the STARK proving system. This means not just having the right values, but having them in the right format: polynomial coefficients or evaluations, properly sized and ordered. The transformation process ensures the trace data becomes valid witness data.

This document covers the transformation process, witness format requirements, and optimization strategies.

## Transformation Overview

### From Trace to Witness

What the transformation does:

```
Input:
  Execution trace (rows × columns)
  Sorted memory operations
  Auxiliary data

Output:
  Witness polynomials
  Committed values
  Proof-ready data
```

### Key Steps

Major transformation phases:

```
1. Column extraction:
   Map trace columns to witness columns

2. Padding:
   Extend to power-of-two length

3. Polynomial construction:
   Evaluations → Coefficients (if needed)

4. Commitment preparation:
   Format for Merkle/FRI commitment
```

## Trace Columns

### Execution Columns

Main computation columns:

```
From trace:
  PC values
  Instruction words
  Operand values
  Results
  Register indices

To witness:
  Same columns, formatted
  Extended to required length
```

### Memory Columns

Memory operation columns:

```
From trace:
  Addresses
  Values
  Timestamps
  Operation types

To witness:
  Sorted order
  Permutation columns
  Consistency proofs
```

### Selector Columns

Instruction type indicators:

```
Derived:
  is_add, is_sub, etc.
  From instruction decoding

Purpose:
  Enable conditional constraints
  One-hot encoding
```

## Padding

### Power-of-Two Requirement

Extending trace length:

```
Requirement:
  Trace length = 2^k
  For FRI efficiency

Process:
  If actual length N:
    Pad to 2^ceil(log2(N))
```

### Padding Values

What to use for padding:

```
Options:
  Zero padding (where valid)
  Copy last row
  NOP instruction pattern
  Explicit padding indicator

Constraint:
  Padding must satisfy constraints
  Or: constraint disabled for padding
```

### Padding Selector

Identifying padding rows:

```
Column:
  is_padding = 1 for padding rows
  is_padding = 0 for real rows

Use:
  Disable constraints for padding
  Or: ensure padding satisfies constraints
```

## Polynomial Construction

### Evaluations

Witness as evaluations:

```
Standard form:
  Witness columns are evaluations
  p(omega^i) = column[i]
  At roots of unity

Direct use:
  Many operations on evaluations
  No coefficient conversion needed
```

### Interpolation

If coefficients needed:

```
Process:
  IFFT on evaluation domain
  Produces coefficients

When:
  Some commitment schemes
  Degree checking
  Constraint evaluation
```

### Extended Domains

Evaluating on larger domain:

```
Blowup:
  Evaluate on larger domain
  For constraint evaluation

Process:
  FFT: coeffs → evaluations on larger domain
```

## Memory Witness

### Sorted Memory Table

Memory consistency witness:

```
From trace:
  Memory operations in execution order

To witness:
  Same operations, sorted by (addr, ts)
  Both views in witness
```

### Permutation Witness

Linking execution and sorted views:

```
Permutation columns:
  Accumulator values
  Prove same multiset

Construction:
  Grand product argument
  Accumulator computation
```

## Auxiliary Witness

### Lookup Witness

Lookup argument components:

```
For lookups:
  Multiplicity columns
  Accumulator columns

Construction:
  Count lookup occurrences
  Build accumulators
```

### Intermediate Columns

Helper columns:

```
Purpose:
  Reduce constraint degree
  Store intermediate results

Example:
  Product of several terms
  Used in multiple constraints
```

## Commitment Preparation

### Merkle Tree Building

Preparing for commitment:

```
Process:
  Hash witness column groups
  Build Merkle tree
  Root is commitment

Organization:
  Columns grouped for efficiency
  Batch hashing
```

### FRI Preparation

Preparing for FRI:

```
Process:
  Evaluations on domain
  Ready for folding

Format:
  Proper ordering
  Chunk organization
```

## Optimization

### Parallel Construction

Concurrent witness building:

```
Independent columns:
  Build in parallel
  Combine at end

Memory:
  Per-thread buffers
  Merge results
```

### Memory Efficiency

Reducing memory usage:

```
Streaming:
  Process columns sequentially
  Write to disk progressively

Chunking:
  Build witness in chunks
  Bounded memory per chunk
```

### Avoiding Redundancy

Computing only what's needed:

```
Lazy evaluation:
  Compute when first needed
  Cache for reuse

Derivation:
  Derive from existing columns
  When cheaper than storage
```

## Validation

### Constraint Checking

Verifying witness validity:

```
Check:
  All constraints satisfied
  For all rows

Early detection:
  Catch errors before proving
  Debug information
```

### Format Verification

Checking witness format:

```
Verify:
  Correct length (power of 2)
  Correct column count
  Proper padding
```

## Key Concepts

- **Trace-to-witness**: Converting execution trace to prover input
- **Padding**: Extending to power-of-two length
- **Polynomial construction**: Evaluations or coefficients
- **Memory witness**: Sorted view and permutation
- **Commitment preparation**: Formatting for commitment

## Design Trade-offs

### Eager vs Lazy

| Eager Construction | Lazy Construction |
|--------------------|-------------------|
| All at once | On demand |
| Higher peak memory | Lower peak memory |
| Simpler | More complex |

### Storage Format

| Evaluations | Coefficients |
|-------------|--------------|
| Direct use | Needs FFT |
| Large domain easy | Degree checking easy |
| Natural | Algebraic |

## Related Topics

- [Minimal Traces](02-minimal-traces.md) - Trace optimization
- [Two-Phase Execution](01-two-phase-execution.md) - Execution strategy
- [Witness Generation](../../02-stark-proving-system/04-proof-generation/01-witness-generation.md) - Proof witness
- [Execution Trace](../../04-zkvm-architecture/04-execution-model/02-execution-trace.md) - Trace format

