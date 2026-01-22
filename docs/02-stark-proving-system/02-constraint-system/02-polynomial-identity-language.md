# Polynomial Identity Language (PIL)

## Overview

Polynomial Identity Language (PIL) is a domain-specific language for expressing the constraints that define valid computations in STARK-based proof systems. PIL provides a higher-level abstraction than raw AIR specifications, enabling cleaner expression of complex constraint systems while compiling down to efficient polynomial representations.

PIL bridges the gap between human-readable constraint specifications and the low-level polynomial equations processed by the prover. It supports modularity through namespaces, reusability through macros and includes, and clarity through structured syntax for common constraint patterns.

This document covers PIL concepts, syntax patterns, and how PIL specifications translate to the underlying mathematical structures.

## PIL Fundamentals

### Purpose of PIL

PIL serves several key purposes:

1. **Abstraction**: Hide polynomial mechanics behind intuitive syntax
2. **Modularity**: Organize constraints into reusable components
3. **Verification**: Enable static analysis of constraint correctness
4. **Compilation**: Generate optimized polynomial representations

### Basic Structure

A PIL specification consists of:

```
namespace ComponentName(N) {
    // Column declarations
    pol commit column_name;
    pol constant const_name;

    // Constraint definitions
    constraint_expression = 0;
}
```

### Column Types

**Committed columns** (witness): Provided by the prover
```
pol commit a, b, c;
```

**Constant columns**: Fixed during setup, known to verifier
```
pol constant SELECTOR, ROM_VALUE;
```

**Intermediate expressions**: Named polynomials for clarity
```
pol sum = a + b;
```

## Constraint Syntax

### Equality Constraints

Basic polynomial equalities:

```
a + b - c = 0;        // c equals a + b
a * b = c;            // c equals a times b
a' = a + 1;           // next row's a equals current a plus 1
```

The prime notation (') refers to the next row:
- `a` = value in current row
- `a'` = value in next row

### Conditional Constraints

Apply constraints conditionally using selectors:

```
sel * (a - b) = 0;    // When sel=1, a must equal b
```

Multiple conditions:
```
sel1 * sel2 * (expr) = 0;   // Only when both selectors are 1
```

### Range Constraints

Ensure values are within bounds:

```
// Implicit: a is decomposed into bytes
a = a_byte0 + a_byte1 * 256 + a_byte2 * 65536 + a_byte3 * 16777216;

// Each byte constrained via lookup to [0, 255]
```

### Lookup Constraints

Verify values appear in a reference table:

```
{ a, b } in { TABLE_A, TABLE_B };
```

This asserts that every (a, b) pair appears in the table defined by (TABLE_A, TABLE_B).

### Permutation Constraints

Assert two column sets are permutations of each other:

```
{ a, b } is { c, d };
```

The multiset of (a, b) values equals the multiset of (c, d) values.

### Connection Constraints

Link columns across different namespaces:

```
{ a } connect { OtherComponent.b };
```

## Namespace Organization

### Defining Namespaces

Each namespace represents a logical component:

```
namespace Arithmetic(2^20) {
    pol commit a, b, result;
    pol commit op;  // 0=add, 1=mul

    (1 - op) * (a + b - result) = 0;  // add case
    op * (a * b - result) = 0;         // mul case
}
```

The parameter (2^20) specifies the trace length.

### Cross-Namespace References

Reference columns from other namespaces:

```
namespace Main(2^20) {
    pol commit arith_a, arith_b, arith_result;

    // Connect to Arithmetic namespace
    { arith_a, arith_b, arith_result } connect
    { Arithmetic.a, Arithmetic.b, Arithmetic.result };
}
```

### Include Mechanism

Reuse definitions across files:

```
include "common_constraints.pil";
include "memory_system.pil";
```

## Advanced Patterns

### Instruction Decoding

Pattern for multi-instruction state machines:

```
namespace CPU(N) {
    pol commit opcode;
    pol commit arg1, arg2, result;

    // Selector for each instruction
    pol sel_add = (opcode - 0) * inverse_or_zero;
    pol sel_mul = (opcode - 1) * inverse_or_zero;
    pol sel_load = (opcode - 2) * inverse_or_zero;

    // Instruction-specific constraints
    sel_add * (arg1 + arg2 - result) = 0;
    sel_mul * (arg1 * arg2 - result) = 0;
    // ... more instructions
}
```

### Memory Consistency

Pattern for read-write memory:

```
namespace Memory(N) {
    pol commit addr, value, timestamp, is_write;

    // Sorted by (addr, timestamp)
    pol commit addr_sorted, value_sorted, ts_sorted, write_sorted;

    // Permutation: original equals sorted
    { addr, value, timestamp, is_write } is
    { addr_sorted, value_sorted, ts_sorted, write_sorted };

    // Consistency: reads return previous write
    (1 - write_sorted) * (addr_sorted' - addr_sorted) *
        (value_sorted - value_sorted') = 0;
}
```

### Binary Decomposition

Pattern for bitwise operations:

```
namespace Binary(N) {
    pol commit a, b, result;
    pol commit a_bits[64], b_bits[64], result_bits[64];

    // Reconstruct from bits
    a = sum(i, a_bits[i] * 2^i);
    b = sum(i, b_bits[i] * 2^i);
    result = sum(i, result_bits[i] * 2^i);

    // Each bit is binary
    for i in 0..64 {
        a_bits[i] * (1 - a_bits[i]) = 0;
        b_bits[i] * (1 - b_bits[i]) = 0;
        result_bits[i] * (1 - result_bits[i]) = 0;
    }

    // XOR: result_bit = a_bit + b_bit - 2*a_bit*b_bit
    for i in 0..64 {
        sel_xor * (result_bits[i] - a_bits[i] - b_bits[i]
                   + 2 * a_bits[i] * b_bits[i]) = 0;
    }
}
```

### Recursive Calls

Pattern for call stack:

```
namespace CallStack(N) {
    pol commit pc, return_addr, stack_depth;
    pol commit is_call, is_return;

    // On call: push return address, increment depth
    is_call * (return_addr' - (pc + 4)) = 0;
    is_call * (stack_depth' - stack_depth - 1) = 0;

    // On return: pop return address, decrement depth
    is_return * (pc' - return_addr) = 0;
    is_return * (stack_depth' - stack_depth + 1) = 0;
}
```

## Compilation Process

### From PIL to Polynomials

The PIL compiler transforms specifications into polynomial form:

```
PIL Source
    |
    v
Parse & Type Check
    |
    v
Expand Macros & Includes
    |
    v
Generate Column Layout
    |
    v
Compile Constraints to Polynomials
    |
    v
Optimize (reduce degree, merge constraints)
    |
    v
Output AIR Specification
```

### Constraint Flattening

Complex expressions are flattened:

```
PIL: a * b * c = d

Flattened:
  intermediate_1 = a * b
  intermediate_1 * c = d
```

This introduces auxiliary columns but reduces constraint degree.

### Lookup Compilation

Lookup constraints compile to logarithmic derivative arguments:

```
PIL: { a } in { TABLE }

Compiled:
  sum_i 1/(X - a_i) = sum_j multiplicity_j/(X - TABLE_j)
```

## Optimization Techniques

### Column Reuse

Minimize columns by reusing across exclusive code paths:

```
// Instead of separate columns for each instruction's intermediate:
pol commit shared_intermediate;

sel_add * (shared_intermediate - (a + b)) = 0;
sel_mul * (shared_intermediate - (a * b)) = 0;
```

### Constraint Batching

Combine similar constraints:

```
// Instead of:
constraint_1 = 0;
constraint_2 = 0;
constraint_3 = 0;

// Batch with random linear combination:
alpha * constraint_1 + alpha^2 * constraint_2 + alpha^3 * constraint_3 = 0;
```

### Selector Optimization

Efficient selector encoding:

```
// Binary selectors (2 columns for 4 options):
sel_bit0, sel_bit1

option_0 = (1 - sel_bit0) * (1 - sel_bit1)
option_1 = sel_bit0 * (1 - sel_bit1)
option_2 = (1 - sel_bit0) * sel_bit1
option_3 = sel_bit0 * sel_bit1
```

## Error Handling

### Constraint Violations

When constraints are violated:

```
Constraint: a + b - c = 0
Row 42: a=5, b=3, c=7

Violation: 5 + 3 - 7 = 1 ≠ 0
```

### Debugging Support

PIL tools provide:
- Constraint evaluation at specific rows
- Trace visualization
- Counterexample generation

### Common Errors

1. **Underconstrained**: Valid proof for invalid computation
2. **Overconstrained**: No valid proof exists for any computation
3. **Degree explosion**: Constraint degree exceeds system limits
4. **Column mismatch**: Cross-namespace references don't align

## Key Concepts

- **PIL**: Domain-specific language for constraint specification
- **Namespace**: Modular component with its own columns and constraints
- **Committed column**: Prover-provided values (witness)
- **Constant column**: Setup-time fixed values
- **Lookup**: Verify values against a table
- **Permutation**: Assert multiset equality

## Design Considerations

### Readability vs. Efficiency

| Readable PIL | Optimized PIL |
|--------------|---------------|
| Many small namespaces | Fewer merged namespaces |
| Explicit intermediate values | Minimized columns |
| Clear constraint names | Batched constraints |

### Testing Strategies

1. Unit test individual namespaces
2. Integration test cross-namespace connections
3. Fuzz test with random valid inputs
4. Negative test with intentionally invalid traces

### Version Control

PIL specifications should be:
- Tracked in version control
- Reviewed like code changes
- Tested before deployment
- Documented with comments

## Related Topics

- [Algebraic Intermediate Representation](01-algebraic-intermediate-representation.md) - Underlying AIR concepts
- [Constraint Composition](03-constraint-composition.md) - Combining constraints
- [State Machine Abstraction](../../04-zkvm-architecture/02-state-machine-design/01-state-machine-abstraction.md) - State machines in PIL
- [Lookup Arguments](../../03-proof-management/02-component-system/02-lookup-arguments.md) - Lookup implementation
- [Witness Generation](../04-proof-generation/01-witness-generation.md) - Generating valid traces
