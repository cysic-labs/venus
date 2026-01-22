# Constraint Composition

## Overview

Constraint composition is the process of combining multiple polynomial constraints into a unified structure that can be efficiently verified. In STARK proofs, individual constraints for different aspects of computation - arithmetic operations, memory consistency, control flow - must be aggregated into a single proof. The composition technique directly affects proof size, verification time, and prover efficiency.

The key insight behind constraint composition is that verifying many constraints can be reduced to verifying a single randomly-weighted combination. If all original constraints evaluate to zero, so does any linear combination. Conversely, if any original constraint is non-zero, a random combination will be non-zero with high probability.

This document covers composition techniques, optimization strategies, and the relationship between composition and the overall proof structure.

## The Composition Challenge

### Multiple Constraints Problem

A typical zkVM has thousands of constraints:

```
Arithmetic: a + b = c, a * b = d, ...
Memory: read_value = stored_value, ...
Control: next_pc = branch_target or pc + 4, ...
Bitwise: decomposition valid, operation correct, ...
```

Each constraint is a polynomial that must equal zero on the execution domain.

### Naive Approach

Verify each constraint separately:

```
For each constraint C_i:
    Commit to quotient Q_i = C_i / Z
    FRI prove Q_i has correct degree
    Answer queries for C_i
```

**Problems**:
- Proof size proportional to constraint count
- Verification time proportional to constraint count
- Redundant work across constraints

### Composition Approach

Combine all constraints, verify once:

```
Combined = alpha_0*C_0 + alpha_1*C_1 + ... + alpha_k*C_k
Commit to quotient Q = Combined / Z
FRI prove Q has correct degree
Answer queries for Combined
```

**Benefits**:
- Proof size independent of constraint count
- Verification work largely independent of constraint count
- Single FRI proof covers all constraints

## Random Linear Combinations

### Mathematical Basis

If C_0, C_1, ..., C_k all equal zero at point x, then:

```
alpha_0*C_0(x) + alpha_1*C_1(x) + ... + alpha_k*C_k(x) = 0
```

for any choice of alpha values.

Conversely, if some C_i(x) ≠ 0, then the combination equals zero only if the alphas satisfy a specific linear equation - probability 1/|F| for random alphas from field F.

### Soundness Analysis

With random challenges from field F of size |F|:

```
Pr[combination = 0 | some C_i ≠ 0] ≤ k / |F|
```

For k = 1000 constraints and |F| = 2^64:

```
Pr[false positive] ≤ 1000 / 2^64 ≈ 0 (negligible)
```

### Challenge Generation

Challenges are derived via Fiat-Shamir:

```
transcript = Hash(all_prior_commitments)
alpha_0 = Hash(transcript || 0)
alpha_1 = Hash(transcript || 1)
...
```

The prover cannot predict challenges before committing.

## Composition Polynomial Construction

### Basic Construction

Given constraints C_0(X), C_1(X), ..., C_k(X):

```
Composition(X) = sum_i alpha_i * C_i(X)
```

### Degree Management

Each constraint C_i has some degree d_i. The composition polynomial has degree:

```
deg(Composition) = max(d_i)
```

If constraints have different degrees, pad lower-degree constraints conceptually.

### Quotient Polynomial

The composition must vanish on the trace domain D:

```
Composition(X) = Q(X) * Z_D(X)
```

where Z_D(X) = X^n - 1 is the vanishing polynomial.

The quotient Q(X) has degree:

```
deg(Q) = deg(Composition) - n
```

### Split Quotient

For large quotient degrees, split into chunks:

```
Q(X) = Q_0(X) + X^m * Q_1(X) + X^(2m) * Q_2(X) + ...
```

Each Q_i has degree less than m, enabling separate commitments.

## Constraint Grouping Strategies

### By Degree

Group constraints by polynomial degree:

```
Group 0 (degree 2): {C_0, C_1, C_5, C_8, ...}
Group 1 (degree 3): {C_2, C_3, C_6, ...}
Group 2 (degree 4): {C_4, C_7, ...}
```

Compose within groups, then combine groups.

**Benefit**: Optimizes quotient polynomial structure.

### By Domain

Some constraints apply to all rows, others to subsets:

```
Global constraints: Apply at all n rows
Periodic constraints: Apply at rows where (row mod period = offset)
Boundary constraints: Apply at specific rows
```

Use different vanishing polynomials for each domain.

### By Component

Group constraints by logical component:

```
Main state machine constraints
Arithmetic constraints
Memory constraints
Binary constraints
```

Each component can have its own composition polynomial.

## Multi-Stage Composition

### Stage Structure

Complex proofs use multiple composition stages:

```
Stage 0: Commit to trace polynomials
         Generate challenge alpha

Stage 1: Compose constraints using alpha
         Commit to composition polynomial
         Generate challenge beta

Stage 2: Compose quotient parts using beta
         Commit to split quotient
         Generate challenge gamma

Stage 3: FRI with challenge gamma
```

### Challenge Hierarchy

Challenges form a hierarchy:

```
alpha: Combines constraints into composition
beta: Combines composition parts
gamma: FRI folding challenges
zeta: OOD evaluation point
```

Each stage's challenges depend on previous commitments.

### Extending Trace Columns

Some columns are derived from challenges:

```
Stage 0: Base trace columns (prover's computation)
Stage 1: After alpha, add challenge-dependent columns
Stage 2: After beta, finalize composition
```

This supports constructions like lookup arguments.

## Efficient Evaluation

### Constraint Evaluation Domain

Constraints are evaluated on an extended domain (coset):

```
Trace domain: {omega^0, omega^1, ..., omega^(n-1)}
Evaluation domain: {g*omega^0, g*omega^1, ..., g*omega^(n-1)}
```

where g is a generator not in the trace domain.

### Batch Evaluation

Evaluate all constraints at each point simultaneously:

```python
def evaluate_all_constraints(point, trace_evals, alphas):
    result = 0
    for i, constraint in enumerate(constraints):
        c_eval = constraint.evaluate(point, trace_evals)
        result += alphas[i] * c_eval
    return result
```

### Parallelization

Constraint evaluation parallelizes across points:

```
Point 0: Worker 0 evaluates Composition(g*omega^0)
Point 1: Worker 1 evaluates Composition(g*omega^1)
...
Point n-1: Worker n-1 evaluates Composition(g*omega^(n-1))
```

## Deep Composition

### Out-of-Domain Sampling

DEEP (Domain Extension for Eliminating Pretenders) adds out-of-domain evaluation:

```
Sample point z outside the trace domain
Evaluate all trace polynomials at z
Include evaluations in composition
```

### DEEP Polynomial

The DEEP composition polynomial proves consistency between:
- Committed trace evaluations
- Claimed out-of-domain evaluations
- Constraint satisfaction

```
DEEP(X) = [Trace(X) - Trace(z)] / (X - z) + alpha * [Composition(X) - Composition(z)] / (X - z)
```

### Soundness Improvement

DEEP improves soundness by:
- Sampling outside prover-controlled domain
- Linking trace to constraints at random point
- Preventing certain algebraic attacks

## Implementation Considerations

### Memory Efficiency

Constraint evaluation can be memory-intensive:

```
Strategy 1: Evaluate all constraints, accumulate
  - Memory: O(1) beyond trace
  - Computation: One pass through constraints

Strategy 2: Evaluate in chunks, combine
  - Memory: O(chunk_size)
  - Computation: Multiple passes, but streamable
```

### Numerical Stability

In finite fields, no floating-point issues. However:
- Avoid unnecessary intermediate reductions
- Use Montgomery form for faster multiplication
- Batch inversions where possible

### Verification Optimization

Verifier checks composition at query points:

```python
def verify_composition_at_point(point, claimed_value, alphas, trace_openings):
    expected = 0
    for i, constraint in enumerate(constraints):
        c_eval = constraint.evaluate(point, trace_openings)
        expected += alphas[i] * c_eval
    return expected == claimed_value
```

Most verification work is in opening commitments, not evaluating constraints.

## Key Concepts

- **Random linear combination**: Batches multiple constraints with random weights
- **Composition polynomial**: Single polynomial representing all constraints
- **Quotient polynomial**: Proves composition vanishes on trace domain
- **Split quotient**: Divides high-degree quotient into manageable pieces
- **DEEP composition**: Adds out-of-domain evaluation for stronger soundness
- **Multi-stage**: Sequential composition with interleaved challenges

## Design Considerations

### Constraint Count vs. Degree

| More Constraints | Higher Degree |
|------------------|---------------|
| More combinations needed | Larger quotient |
| Random combination overhead | More FRI layers |
| Composition still efficient | Can split quotient |

### Extension Field Challenges

For stronger soundness, draw challenges from extension field:

```
alpha from F_p^2 instead of F_p
Increases soundness by extension degree
Costs: Extension field arithmetic
```

### Profiling Composition

Profile to identify bottlenecks:
- Constraint evaluation time
- NTT for quotient computation
- Merkle tree building

## Related Topics

- [Algebraic Intermediate Representation](01-algebraic-intermediate-representation.md) - Individual constraint structure
- [Polynomial Identity Language](02-polynomial-identity-language.md) - Constraint specification
- [FRI Fundamentals](../03-fri-protocol/01-fri-fundamentals.md) - Proving quotient degree
- [Proof Structure](../01-stark-overview/03-proof-structure.md) - Where composition fits in proof
- [Fiat-Shamir Transform](../04-proof-generation/04-fiat-shamir-transform.md) - Challenge generation
