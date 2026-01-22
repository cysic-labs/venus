# Algebraic Intermediate Representation (AIR)

## Overview

The Algebraic Intermediate Representation (AIR) is the formal framework for expressing computational constraints in STARK proof systems. An AIR defines a computation as a set of polynomial equations over an execution trace, establishing the rules that distinguish valid computations from invalid ones. Understanding AIR is essential for designing zkVM constraint systems and optimizing prover performance.

An AIR consists of two main components: a trace structure defining the columns and their semantics, and a set of polynomial constraints that must evaluate to zero for all valid executions. The elegance of AIR lies in its generality - any deterministic computation can be expressed as an AIR, making it the universal language for STARK-based proving.

This document covers AIR concepts, constraint types, design patterns, and the relationship between AIR and the underlying proof system.

## Trace Structure

### Execution Trace Definition

The execution trace is a two-dimensional table where:
- Each **row** represents a computation step (time)
- Each **column** represents a state variable or intermediate value

```
       col_0   col_1   col_2   ...   col_w
row_0:   a_00    a_01    a_02   ...   a_0w
row_1:   a_10    a_11    a_12   ...   a_1w
row_2:   a_20    a_21    a_22   ...   a_2w
  .       .       .       .     .      .
  .       .       .       .     .      .
row_n:   a_n0    a_n1    a_n2   ...   a_nw
```

### Trace Parameters

Key parameters defining an AIR trace:

- **Width (w)**: Number of columns
- **Length (n)**: Number of rows (typically a power of 2)
- **Field (F)**: The finite field containing all values

### Column Types

Different columns serve different purposes:

**State columns**: Primary computation state (registers, memory values)
**Auxiliary columns**: Helper values for constraint satisfaction
**Selector columns**: Binary flags indicating operation types
**Intermediate columns**: Decomposed values for range checks

### Trace Polynomials

Each column is encoded as a polynomial by interpolation:

```
T_i(X) such that T_i(omega^j) = trace[j][i]
```

where omega is a primitive n-th root of unity.

The degree of each trace polynomial is at most n-1.

## Constraint Types

### Transition Constraints

Transition constraints relate values in consecutive rows, expressing how state evolves:

```
C(current_row, next_row) = 0
```

In polynomial form:
```
C(T_0(X), T_1(X), ..., T_0(omega*X), T_1(omega*X), ...) = 0
```

**Example - Counter**:
```
next_counter - current_counter - 1 = 0
```

**Example - Conditional update**:
```
selector * (next_value - new_value) + (1 - selector) * (next_value - current_value) = 0
```

### Boundary Constraints

Boundary constraints fix values at specific positions:

**Initial constraints** (row 0):
```
T_i(omega^0) = initial_value
```

**Final constraints** (last row):
```
T_j(omega^{n-1}) = final_value
```

**Intermediate constraints** (specific row k):
```
T_m(omega^k) = required_value
```

### Consistency Constraints

Consistency constraints ensure global properties across the trace:

**Example - Memory consistency**:
All reads from address A return the most recently written value.

**Example - Permutation argument**:
Two columns contain the same multiset of values (possibly in different order).

### Periodic Constraints

Some constraints apply only at certain rows:

```
Constraint applies when row mod period = offset
```

This is encoded using periodic selector polynomials.

## Constraint Composition

### Combining Multiple Constraints

Multiple constraints are combined using random linear combinations:

```
C_combined(X) = alpha_0 * C_0(X) + alpha_1 * C_1(X) + ... + alpha_k * C_k(X)
```

where alpha_i are random challenges from the verifier.

This batches all constraint checks into a single polynomial.

### Degree Considerations

The composition polynomial degree affects proving cost:

- Individual constraint degree: d_i
- Trace polynomial degree: n-1
- Composition polynomial degree: max(d_i * (n-1))

Lower-degree constraints are more efficient.

### Constraint Degree Reduction

High-degree constraints can be split using auxiliary columns:

**Before** (degree 4):
```
A * B * C * D = E
```

**After** (degree 2 each):
```
A * B = intermediate_1
C * D = intermediate_2
intermediate_1 * intermediate_2 = E
```

## The Quotient Polynomial

### Definition

If constraints are satisfied, C(X) = 0 at all trace domain points. This means C(X) is divisible by the vanishing polynomial:

```
Z(X) = X^n - 1
```

The quotient polynomial is:
```
Q(X) = C(X) / Z(X)
```

### Degree Bound

If C(X) has degree d, then Q(X) has degree d - n.

The prover commits to Q(X) and proves it has this bounded degree.

### Split Quotient

For efficiency, Q(X) may be split into multiple lower-degree polynomials:

```
Q(X) = Q_0(X) + X^m * Q_1(X) + X^{2m} * Q_2(X) + ...
```

Each Q_i has degree less than m, enabling more efficient FRI.

## AIR Design Patterns

### State Machine Pattern

Model computation as a state machine:

```
State = (pc, registers, memory_ptr, ...)

Transition function:
  instruction = decode(ROM[pc])
  new_state = execute(instruction, state)
```

Each instruction type has associated constraints.

### Lookup Pattern

Use lookup arguments to verify values against a table:

```
Claim: values in column A appear in table T

Proof: Use logarithmic derivative or permutation argument
```

This is crucial for range checks and ROM consistency.

### Decomposition Pattern

Decompose large values into smaller chunks:

```
value = chunk_0 + chunk_1 * 2^16 + chunk_2 * 2^32 + chunk_3 * 2^48

Constraints:
- Reconstruction equality
- Each chunk is in range [0, 2^16)
```

### Memory Pattern

Track memory operations with timestamps:

```
Columns: address, value, timestamp, is_write

Sorted by (address, timestamp):
- Consecutive ops to same address: read gets previous write's value
- First op to address: write (or read of initial value)
```

## AIR Specification Format

### Formal Definition

An AIR is formally specified as:

```
AIR = (F, w, n, constraints, boundaries)

where:
  F         = finite field
  w         = trace width (number of columns)
  n         = trace length (power of 2)
  constraints = list of polynomial constraints
  boundaries  = list of (position, column, value) triples
```

### Constraint Specification

Each constraint specifies:

```
Constraint:
  - polynomial expression over trace columns
  - columns involved (current row and next row)
  - degree bound
  - domain (all rows, periodic, or specific)
```

### Example: Fibonacci AIR

```
AIR for Fibonacci sequence:
  Columns: [a, b]
  Length: n

  Transition constraints:
    next_a - current_b = 0
    next_b - (current_a + current_b) = 0

  Boundary constraints:
    a(0) = 1
    b(0) = 1
    a(n-1) = fib_n  (public output)
```

## Soundness Analysis

### Constraint Satisfaction

For a valid trace, all constraints evaluate to zero at all domain points.

### Cheating Detection

A cheating prover must produce polynomials that:
- Satisfy constraints at queried points
- Have bounded degree

With random challenges and sufficient queries, this is computationally infeasible.

### Soundness Error

The probability of accepting an invalid proof is bounded by:

```
soundness_error <= (degree_bound / |F|)^num_queries
```

## Optimization Strategies

### Minimize Trace Width

Fewer columns means:
- Less memory during proving
- Fewer polynomial commitments
- Faster NTT operations

Techniques:
- Reuse columns across instruction types
- Use selector-based multiplexing
- Eliminate redundant state

### Minimize Constraint Degree

Lower degree constraints:
- Reduce quotient polynomial degree
- Enable smaller blowup factors
- Speed up constraint evaluation

Techniques:
- Split high-degree constraints
- Use auxiliary columns for intermediate values
- Design constraints with degree in mind

### Batch Similar Constraints

Group constraints by structure:
- Arithmetic constraints evaluated together
- Memory constraints in dedicated subsystem
- Reduces overhead from random combinations

## Key Concepts

- **AIR**: Algebraic representation of computation as polynomial constraints
- **Trace**: Two-dimensional table of computation state
- **Transition constraint**: Relates consecutive rows
- **Boundary constraint**: Fixes values at specific positions
- **Quotient polynomial**: Proves constraint satisfaction
- **Constraint degree**: Affects proving efficiency

## Design Considerations

### Trace Width vs. Constraint Complexity

| More Columns | Fewer Columns |
|--------------|---------------|
| Simpler constraints | More complex constraints |
| More memory | Less memory |
| Potentially faster evaluation | Potentially slower |

### Proof System Compatibility

Different proof systems have different optimal AIR structures:
- STARK: Favors regular, periodic structures
- Some systems: Support custom gates

### Debugging AIR

When constraints fail:
- Check constraint at specific rows
- Verify intermediate values
- Test with known-good traces

## Related Topics

- [Polynomial Identity Language](02-polynomial-identity-language.md) - Higher-level constraint specification
- [Constraint Composition](03-constraint-composition.md) - Combining constraints efficiently
- [STARK Introduction](../01-stark-overview/01-stark-introduction.md) - How AIR fits in STARK proofs
- [State Machine Abstraction](../../04-zkvm-architecture/02-state-machine-design/01-state-machine-abstraction.md) - AIR for state machines
- [Witness Generation](../04-proof-generation/01-witness-generation.md) - Creating valid traces
