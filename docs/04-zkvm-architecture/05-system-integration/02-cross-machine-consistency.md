# Cross-Machine Consistency

## Overview

Cross-machine consistency ensures that data exchanged between state machines matches perfectly. When the main machine claims it performed a multiplication and received a certain result, the multiplier machine must have a corresponding entry confirming that same computation. Without this consistency, a malicious prover could fabricate results by making inconsistent claims in different machines.

The consistency mechanism relies on cryptographic arguments that bind machines together. Lookup arguments verify that every claimed value appears in the appropriate table. Permutation arguments prove that two machines process the same set of operations, just in different orders. These arguments compose to create a unified proof where any inconsistency between machines would cause verification to fail.

This document covers consistency requirements, verification mechanisms, constraint patterns, and debugging strategies for cross-machine consistency.

## Consistency Requirements

### Data Matching

Values must agree across boundaries:

```
When main machine sends (op, a, b):
  Sub-machine must have row with same (op, a, b)

When sub-machine returns result:
  Main machine must receive same result

No modification allowed:
  Data cannot change during transfer
  Same bytes, same interpretation
```

### Count Matching

Operation counts must balance:

```
If main sends N arithmetic operations:
  Arithmetic machine must have N entries

If memory machine has M operations:
  Main machine must have generated M operations

Balance equation:
  Σ (main sends) = Σ (sub-machine receives)
```

### Order Considerations

Order may or may not matter:

```
Order-independent (typical):
  Set of operations matches
  Order can differ between machines
  Permutation argument sufficient

Order-dependent (special cases):
  Operations must be in specific order
  Additional ordering constraints needed
  Timestamp fields enforce order
```

## Verification Mechanisms

### Lookup Verification

Table membership checking:

```
Main machine has:
  Operation: (MUL, 7, 5, 35)

Multiplier table contains:
  Entry: (MUL, 7, 5, 35)

Verification:
  Lookup argument proves main's tuple is in table
  If (MUL, 7, 5, 34) claimed, lookup fails

Logarithmic derivative form:
  Σ 1/(γ - main_tuple[i]) = Σ mult[j]/(γ - table_tuple[j])
```

### Permutation Verification

Multiset equality:

```
Main machine operations:
  {(A, op1), (B, op2), (C, op3)}

Sub-machine operations:
  {(B, op2), (C, op3), (A, op1)}  // Same set, different order

Grand product:
  Π (z - main_tuple[i]) = Π (z - sub_tuple[j])

If sets differ:
  Products differ with overwhelming probability
  Verification fails
```

### Accumulator Verification

Running product approach:

```
Accumulator columns:
  acc_main[i] = acc_main[i-1] * (z - main_tuple[i])
  acc_sub[i] = acc_sub[i-1] * (z - sub_tuple[i])

Initial:
  acc_main[0] = 1
  acc_sub[0] = 1

Final check:
  acc_main[N-1] = acc_sub[M-1]

Constraint:
  Polynomial identity for accumulator update
  Final equality check
```

## Constraint Patterns

### Tuple Encoding

Combining fields into single value:

```
Tuple: (op_type, operand_a, operand_b, result)

Encoding with random challenge r:
  encoded = op_type + r*operand_a + r^2*operand_b + r^3*result

Properties:
  Collision-resistant (with high probability)
  Linear in components
  Efficient to compute
```

### Selector-Guarded Connections

Only active rows participate:

```
Not every row has cross-machine operation:
  is_cross_op: Selector for active rows

Contribution:
  is_cross_op * (encoded_tuple) contributes to product
  (1 - is_cross_op) * 1 contributes to product

Constraint:
  acc[i] = acc[i-1] * (is_cross_op[i] * (z - tuple[i])
                     + (1 - is_cross_op[i]) * 1)

Simplified:
  acc[i] = acc[i-1] * (is_cross_op[i] * (z - tuple[i] - 1) + 1)
```

### Multi-Table Connections

Component connects to multiple tables:

```
Main machine connects to:
  Arithmetic table (arith operations)
  Memory table (memory operations)
  Binary table (bitwise operations)

Separate accumulators:
  arith_acc, mem_acc, binary_acc

Each with own constraint set:
  arith_acc tracks arithmetic lookups
  mem_acc tracks memory lookups
  binary_acc tracks binary lookups
```

## Consistency Patterns

### Request-Response Consistency

Matched pairs:

```
Main machine:
  Request: (req_id, op, a, b)
  Response: (req_id, result)

Sub-machine:
  Entry: (req_id, op, a, b, result)

Consistency:
  Request tuple in sub-machine
  Response matches sub-machine result

Constraint:
  (req_id, op, a, b) lookup to sub-machine
  result equals sub-machine's computed result
```

### Timestamp Consistency

Temporal ordering:

```
Global clock:
  Each operation has timestamp

Main machine:
  (op, a, b, result, t_main)

Sub-machine:
  (op, a, b, result, t_sub)

Consistency:
  t_main = t_sub for paired operations
  OR
  t_sub in valid range for t_main
```

### State Consistency

Register/memory state agreement:

```
Main machine at cycle T:
  Register x5 = 42

Register machine at cycle T:
  Register x5 = 42

Consistency:
  State snapshots must match
  Lookup or permutation verifies
```

## Error Detection

### Mismatch Detection

When consistency fails:

```
Lookup failure:
  Claimed tuple not in table
  Verifier rejects proof

Permutation failure:
  Products don't match
  Verifier rejects proof

Multiplicity failure:
  Count mismatch
  Verifier rejects proof
```

### Debugging Approach

Finding consistency bugs:

```
Step 1: Identify failing constraint
  Which accumulator mismatch?
  Which lookup failed?

Step 2: Trace to specific row
  Which row has incorrect tuple?
  What should the correct value be?

Step 3: Root cause
  Witness generation bug?
  Constraint bug?
  Interface mismatch?
```

### Common Issues

Frequent consistency problems:

```
Field mismatch:
  Main uses 32-bit, sub uses 64-bit
  Truncation causes mismatch

Sign extension:
  Signed vs unsigned interpretation
  Different bit patterns

Ordering:
  Fields in wrong order in tuple
  (a, b, op) vs (op, a, b)

Selector bugs:
  Wrong rows marked as active
  Missing operations
```

## Optimization Techniques

### Batched Verification

Combine multiple checks:

```
Instead of separate accumulators:
  Combined accumulator for all connections

Random linear combination:
  combined = α*arith_tuple + α^2*mem_tuple + α^3*binary_tuple

Single grand product for all connections.

Benefit:
  Fewer columns
  Faster verification
```

### Sparse Connections

Exploit sparsity:

```
If few rows have cross-machine ops:
  Compact representation
  Only store active entries

Sparse accumulator:
  Skip non-active rows
  Index active rows explicitly
```

### Lazy Consistency

Defer to end:

```
Accumulate throughout trace:
  Each row contributes to running product

Single final check:
  Compare products at trace end
  No per-row equality checks

Reduces constraint count.
```

## Multi-Component Consistency

### Transitive Consistency

Chain of components:

```
A → B → C

A consistent with B (A-B link)
B consistent with C (B-C link)

Implies A consistent with C:
  Data flows correctly end-to-end
```

### Cycle Detection

Avoiding circular dependencies:

```
A sends to B
B sends to C
C sends to A?

Circular dependencies:
  Make consistency harder
  Ordering becomes complex

Prefer acyclic graphs:
  Clear dependency order
  Simpler verification
```

### Global Consistency

System-wide verification:

```
All component pairs consistent:
  Main ↔ Memory
  Main ↔ Arithmetic
  Main ↔ Binary
  ...

Composed verification:
  Product of all accumulators matches
  OR separate checks per pair
```

## Key Concepts

- **Cross-machine consistency**: Data agreement between components
- **Lookup verification**: Table membership checking
- **Permutation verification**: Multiset equality checking
- **Tuple encoding**: Combining fields for comparison
- **Accumulator**: Running product for consistency

## Design Considerations

### Verification Granularity

| Per-Operation | Batched |
|--------------|---------|
| Immediate detection | End detection |
| More constraints | Fewer constraints |
| Easier debugging | Harder debugging |
| Higher overhead | Lower overhead |

### Encoding Trade-offs

| Single Field | Multiple Fields |
|-------------|-----------------|
| Simple lookup | Complex lookup |
| Collision risk | No collision |
| Smaller | Larger |
| Faster | Slower |

## Related Topics

- [Component Composition](01-component-composition.md) - Composition overview
- [Trace Layout](03-trace-layout.md) - Column organization
- [Lookup Arguments](../../02-constraint-system/02-fri-protocol/01-fri-overview.md) - Lookup mechanics
- [Permutation Arguments](../../03-proof-management/02-component-system/02-lookup-arguments.md) - Permutation details
