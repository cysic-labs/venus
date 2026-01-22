# Constraint-Aware Programming

## Overview

Constraint-aware programming is the practice of writing code that considers the cost of proof generation, not just execution speed. In a zkVM, every operation becomes constraints that the prover must satisfy. Some operations that are cheap in traditional execution become expensive in proving, while others remain efficient. Understanding these costs enables writing programs that prove quickly without sacrificing correctness.

The goal is not premature optimization but informed decision-making. When two approaches achieve the same result, choosing the one with lower constraint cost can dramatically reduce proving time. This document covers cost models, expensive operations, optimization patterns, and measurement techniques for constraint-aware development.

## Cost Model

### Constraint Costs

What contributes to proving cost:

```
Primary factors:
  Trace rows: Each instruction adds row(s)
  Columns: Each value tracked adds column
  Constraints: Each rule checked adds constraints

Cost hierarchy (low to high):
  1. Register-to-register: Few constraints
  2. Immediate operations: Similar to register
  3. Memory access: Memory machine overhead
  4. Division/modulo: Iterative algorithm
  5. Cryptographic: Precompile or many constraints
```

### Instruction Costs

Relative cost by instruction type:

```
Low cost:
  add, sub, and, or, xor: ~10 constraints
  immediate variants: Similar
  shifts (constant): Low

Medium cost:
  loads/stores: ~20-50 constraints + memory
  branches: ~20 constraints + condition
  shifts (variable): Higher due to decomposition

High cost:
  mul (full): ~100+ constraints
  div, rem: ~200+ constraints (iterative)

Very high cost:
  Unoptimized crypto: Thousands+
  Emulated operations: Many instructions
```

### Memory Costs

Memory access overhead:

```
Per access:
  Address computation: Few constraints
  Value load/store: Few constraints
  Memory machine: ~20+ constraints
  Consistency: Sorting overhead

Patterns:
  Sequential access: Efficient
  Random access: Same cost per access
  Repeated access: Cacheable by prover
```

## Expensive Operations

### Division and Modulo

High-cost arithmetic:

```
Cost:
  Division requires iterative algorithm
  ~200+ constraints per operation

Alternative:
  Multiply by inverse if constant divisor
  Use shifts for powers of 2
  Batch divisions if possible

Example:
  // Expensive
  let result = a / 7;

  // Cheaper (precomputed inverse)
  let inv_7 = compute_inverse(7);
  let result = a * inv_7; // Approximate, check overflow
```

### Variable Shifts

Shifting by non-constant:

```
Cost:
  Variable shift requires bit decomposition
  ~50+ constraints

Alternative:
  Use constant shifts when possible
  Precompute shift amounts

Example:
  // Variable shift (expensive)
  let result = x << amount;

  // If amount is known
  let result = x << 5; // Cheaper
```

### Large Multiplications

Wide multiplication:

```
Cost:
  32x32 → 64: Moderate
  64x64 → 128: Higher
  Arbitrary precision: Very high

Alternative:
  Use narrower types when possible
  Avoid unnecessary precision

Example:
  // Wide multiply
  let result: u128 = (a as u128) * (b as u128);

  // If range allows
  let result: u64 = a * b; // Ensure no overflow
```

### Conditional Execution

Branch overhead:

```
Reality:
  Both branches contribute to trace
  Constraints for condition evaluation
  Multiplexing for result selection

Implication:
  Expensive branches still expensive
  Can't avoid cost by branching

Pattern:
  let result = if condition { a } else { b };
  // Both a and b computed/constrained
```

## Optimization Patterns

### Precomputation

Moving work outside proving:

```
Pattern:
  Compute constants before proving
  Include as input or hard-code

Example:
  // During proving
  let hash = sha256(&constant_data);

  // Better: Precompute
  const HASH: [u8; 32] = precomputed_hash();
```

### Batching

Amortizing overhead:

```
Pattern:
  Group similar operations
  Process in batches
  Amortize fixed costs

Example:
  // Per-item division (expensive)
  for item in items {
    results.push(item / divisor);
  }

  // Batched (slightly better)
  let inv = compute_inverse(divisor);
  for item in items {
    results.push(item * inv);
  }
```

### Lookup Tables

Trading memory for constraints:

```
Pattern:
  Precompute table of results
  Look up instead of compute

Example:
  // Compute each time
  let value = expensive_function(index);

  // Table lookup (if small domain)
  static TABLE: [u32; 256] = precompute_table();
  let value = TABLE[index];
```

### Algebraic Optimization

Using mathematical properties:

```
Pattern:
  Exploit algebraic structure
  Simplify expressions
  Reduce operations

Example:
  // Multiple operations
  let result = (a * b) / c + (a * d) / c;

  // Factor out
  let result = a * (b + d) / c;
  // One less multiplication
```

## Memory Optimization

### Access Patterns

Efficient memory usage:

```
Sequential access:
  Predictable, cache-friendly
  Memory machine sorted efficiently

Random access:
  Same constraint cost per access
  But harder to optimize

Recommendation:
  Process data sequentially when possible
  Group related accesses
```

### Reducing Memory Operations

Fewer loads/stores:

```
Pattern:
  Keep values in registers
  Minimize memory round-trips

Example:
  // Many loads
  for i in 0..n {
    sum += data[i];
  }

  // Compiler usually optimizes, but be aware
```

### Working Set

Limiting active data:

```
Pattern:
  Smaller working set
  Less memory trace
  Better proving performance

Application:
  Process in chunks
  Don't load all data at once
  Release data when done
```

## Measurement

### Instruction Counting

Measuring program size:

```
Approach:
  Count RISC-V instructions
  Profile instruction types
  Identify hot spots

Tools:
  Execution profiler
  Instruction histogram
  Trace analysis
```

### Constraint Estimation

Predicting constraint count:

```
Approach:
  instructions × constraints/instruction
  + memory ops × memory overhead
  + special ops × special cost

Formula:
  Total ≈ Σ (instruction_i × cost_i)
```

### Proving Time

Actual measurement:

```
Approach:
  Prove program
  Measure wall clock time
  Compare variants

Iteration:
  Modify program
  Measure again
  Track improvements
```

## Anti-Patterns

### Unnecessary Computation

Doing more than needed:

```
Anti-pattern:
  Compute unused values
  Over-precise calculations
  Redundant checks

Fix:
  Remove dead code
  Use appropriate precision
  Optimize validation
```

### Crypto in Loops

Expensive operations repeated:

```
Anti-pattern:
  for item in items {
    let hash = sha256(&item);
    // ...
  }

Better:
  // Batch if possible
  // Or use Merkle tree for many items
```

### Complex Data Structures

Overhead of fancy structures:

```
Anti-pattern:
  HashMap with many lookups
  Complex tree traversal
  Dynamic structure manipulation

Better:
  Arrays when possible
  Sequential access
  Simpler structures
```

## Key Concepts

- **Constraint cost**: Proving expense of operations
- **Expensive operations**: Division, variable shifts, wide multiply
- **Precomputation**: Moving work outside proving
- **Batching**: Amortizing overhead across operations
- **Measurement**: Profiling instruction and constraint counts

## Design Considerations

### Optimization Priority

| Correctness | Performance |
|-------------|-------------|
| Must be correct | Then optimize |
| Clear code | Efficient code |
| Validate first | Prove fast |
| Readable | Maintainable |

### Trade-offs

| Simpler Code | Faster Proving |
|--------------|----------------|
| Easier maintenance | Harder to read |
| Clearer logic | Optimized patterns |
| Portable | zkVM-specific |
| Good default | When needed |

## Related Topics

- [Program Structure](01-program-structure.md) - Basic patterns
- [Testing and Debugging](03-testing-and-debugging.md) - Verification
- [Constraint Optimization](../../10-performance-optimization/01-prover-optimization/01-constraint-optimization.md) - Detailed optimization
- [Gas and Cost Model](../../05-cryptographic-precompiles/01-precompile-framework/03-gas-and-cost-model.md) - Cost modeling
