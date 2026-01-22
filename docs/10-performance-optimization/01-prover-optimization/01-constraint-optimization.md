# Constraint Optimization

## Overview

Constraint optimization reduces the number and complexity of polynomial constraints in the proving system. Since proving time scales with constraint count and degree, minimizing these factors directly improves performance. Optimization occurs at multiple levels: algorithmic design, constraint formulation, and automated simplification. The goal is achieving the same verification guarantees with fewer, simpler constraints.

Effective constraint optimization requires understanding the cost model. Each constraint adds terms to the quotient polynomial, increases commitment size, and requires evaluation during the FRI protocol. High-degree constraints cost more than low-degree ones. Constraints sharing common sub-expressions can be factored. This document covers optimization techniques at each level of the constraint system.

## Cost Model

### Constraint Costs

Understanding what makes constraints expensive:

```
Degree impact:
  Constraint degree d:
    Quotient polynomial degree increases
    More FRI rounds needed
    Higher evaluation cost

  Cost scaling:
    Linear (d=1): Cheapest
    Quadratic (d=2): 2-4x linear
    Cubic (d=3): 4-8x linear
    Higher: Exponential increase

Term count:
  More terms in constraint:
    More field operations
    Larger intermediate values
    More memory bandwidth
```

### Trace Costs

Execution trace overhead:

```
Column costs:
  Each column:
    Full-length polynomial
    Commitment required
    Evaluation in proof

  Reducing columns:
    Fewer commitments
    Smaller proofs
    Less prover memory

Row costs:
  Each row:
    All columns evaluated
    All constraints checked

  Reducing rows:
    Shorter trace
    Faster proving
    Requires denser packing
```

### Lookup Costs

Table lookup overhead:

```
Per lookup:
  Permutation argument contribution
  Log-derivative accumulator update
  Table membership proof

Table size:
  Larger tables: More setup work
  Smaller tables: May need more lookups

Optimization:
  Batch similar lookups
  Minimize table entries
  Share tables across components
```

## Degree Reduction

### Constraint Decomposition

Breaking high-degree into low-degree:

```
Original constraint (degree 4):
  a · b · c · d = e

Decomposition:
  Introduce intermediate: t = a · b
  Constraint 1: t = a · b     (degree 2)
  Constraint 2: t · c · d = e (degree 3)

Further decomposition:
  t1 = a · b    (degree 2)
  t2 = c · d    (degree 2)
  t1 · t2 = e   (degree 2)

Trade-off:
  More columns (intermediates)
  Lower maximum degree
  Often net improvement
```

### Linearization

Converting to linear constraints:

```
Quadratic constraint:
  x · y = z

Linearization (if x is binary):
  x · y = z
  x · (1 - x) = 0  (x is 0 or 1)

  Equivalent linear:
  z ≤ y
  z ≤ x · M  (M = max value)
  z ≥ y - (1 - x) · M

Binary decomposition:
  Any value as sum of binary:
  v = Σ 2^i · b_i
  Each b_i binary
  Products become sums
```

### Degree Balancing

Distributing degree across constraints:

```
Unbalanced:
  Constraint 1: degree 5
  Constraint 2: degree 2
  Constraint 3: degree 2
  Max degree: 5

Balanced (after rewriting):
  Constraint 1a: degree 3
  Constraint 1b: degree 3
  Constraint 2: degree 3
  Max degree: 3

Benefit:
  Quotient degree determined by max
  Balanced = lower overall max
  Better FRI performance
```

## Constraint Factoring

### Common Sub-expression Elimination

Sharing repeated computations:

```
Original constraints:
  C1: (a + b) · c = d
  C2: (a + b) · e = f
  C3: (a + b) · g = h

With CSE:
  Define: t = a + b
  C1: t · c = d
  C2: t · e = f
  C3: t · g = h

Benefit:
  One column for t
  Simpler constraints
  Prover computes (a+b) once
```

### Constraint Batching

Combining related constraints:

```
Individual constraints:
  C1: selector_1 · (expr_1) = 0
  C2: selector_2 · (expr_2) = 0
  ...

Batched (if exclusive selectors):
  Combined: Σ selector_i · (expr_i) = 0

Requirements:
  Selectors mutually exclusive
  At most one active per row

Benefit:
  Single constraint instead of N
  Degree may increase (trade-off)
```

### Polynomial Factorization

Factoring constraint polynomials:

```
Constraint polynomial:
  C(X) = a·X³ + b·X² + c·X + d

If factorable:
  C(X) = (X - r₁)(X - r₂)(X - r₃)

Benefit:
  Evaluate factors separately
  Lower intermediate degree
  May simplify quotient
```

## Lookup Optimization

### Table Compression

Reducing table size:

```
Original table:
  All possible (a, b, a+b) triples
  Size: N × N entries

Compressed:
  Store only unique outputs
  Compute inputs from structure

Range tables:
  Instead of all pairs
  Use composition of ranges
```

### Lookup Batching

Combining multiple lookups:

```
Individual lookups:
  Lookup 1: (a, b, c) in T1
  Lookup 2: (d, e, f) in T2
  Lookup 3: (g, h, i) in T3

Batched (if same table structure):
  Combined table with type tag
  Single permutation argument

Log-derivative batching:
  Sum contributions: Σ 1/(X - entry_i)
  Single random challenge
```

### Cached Lookups

Reusing lookup results:

```
Pattern:
  Same lookup repeated across rows
  Store result in column
  Reference instead of re-lookup

Example:
  Row 1: lookup(x) → y, store y
  Row 2: use stored y
  Row 3: lookup different value

Benefit:
  Fewer lookup operations
  More columns (trade-off)
```

## Memory Optimization

### Column Packing

Fitting more data per column:

```
Unpacked:
  Column 1: 8-bit value a
  Column 2: 8-bit value b
  Column 3: 8-bit value c

Packed:
  Column 1: a | (b << 8) | (c << 16)

Constraints:
  Extract with masks and shifts
  Range check packed value

Trade-off:
  Fewer columns
  More complex extraction
```

### Trace Compression

Reducing trace length:

```
Sparse trace:
  Many rows mostly zeros
  Wasted space

Compression:
  Pack multiple logical rows
  Skip empty sections
  Use run-length encoding

Dense packing:
  Multiple operations per row
  If independent
  Complex selectors
```

### Working Set Reduction

Minimizing active data:

```
Strategy:
  Process in chunks
  Release completed data
  Reuse memory

Implementation:
  Stream through trace
  Commit and discard
  Incremental proving

Benefit:
  Bounded memory usage
  Larger traces possible
  Better cache utilization
```

## Algorithmic Optimization

### State Machine Design

Efficient state machine structure:

```
Minimize states:
  Fewer states = simpler transitions
  Combine similar states
  Use parameterized states

Transition optimization:
  Direct transitions when possible
  Avoid multi-step sequences
  Parallel state machines

Column efficiency:
  Share columns across states
  Reuse when semantics allow
```

### Operation Ordering

Sequencing for efficiency:

```
Constraint-aware ordering:
  Group similar operations
  Minimize selector switches
  Batch memory accesses

Example:
  Original: add, load, add, load, add
  Reordered: add, add, add, load, load

  Benefit: Same selector active longer
```

### Precomputation

Moving work outside proving:

```
Precomputable:
  Constant expressions
  Lookup tables
  Fixed polynomials

At prove time:
  Reference precomputed values
  Skip redundant work

Example:
  Powers of generator: g, g², g³, ...
  Precompute once, use everywhere
```

## Automated Optimization

### Constraint Compiler

Automatic optimization pass:

```
Input:
  High-level constraints

Passes:
  1. Degree analysis
  2. CSE identification
  3. Constraint rewriting
  4. Column allocation

Output:
  Optimized constraint system
  Column mapping
  Evaluation order
```

### Cost Estimation

Predicting optimization impact:

```
Metrics:
  Total constraints
  Maximum degree
  Column count
  Estimated prover time

Profiling:
  Measure actual proving
  Compare to estimates
  Refine cost model
```

### Search-Based Optimization

Exploring optimization space:

```
Approach:
  Multiple rewriting strategies
  Evaluate each
  Select best

Techniques:
  Greedy local search
  Simulated annealing
  Genetic algorithms

Constraints:
  Preserve correctness
  Bounded search time
```

## Key Concepts

- **Degree reduction**: Lowering maximum constraint degree
- **Common sub-expression elimination**: Sharing repeated computations
- **Lookup optimization**: Efficient table usage
- **Column packing**: Fitting more data per trace column
- **Automated optimization**: Compiler-based constraint improvement

## Design Considerations

### Optimization Trade-offs

| Fewer Columns | Lower Degree |
|---------------|--------------|
| Smaller proof | Faster FRI |
| Denser packing | More columns for intermediates |
| Complex constraints | Simpler constraints |
| Memory efficient | Computation efficient |

### Manual vs Automatic

| Manual Optimization | Automatic Optimization |
|---------------------|------------------------|
| Domain-specific insight | General techniques |
| Optimal for specific case | Broadly applicable |
| High effort | Low effort |
| May miss opportunities | May miss domain tricks |

## Related Topics

- [Polynomial Optimization](02-polynomial-optimization.md) - Polynomial-level optimization
- [Constraint-Aware Programming](../../09-developer-experience/01-programming-model/02-constraint-aware-programming.md) - Writing efficient programs
- [Constraint Design](../../04-zkvm-architecture/01-constraint-system/02-constraint-design.md) - Constraint fundamentals
- [FRI Protocol](../../03-stark-proving-system/02-fri-protocol/01-fri-overview.md) - Proof generation

