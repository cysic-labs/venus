# Global Constraints

## Overview

Global constraints are polynomial equations that must hold across the entire execution trace, connecting values from different state machines and ensuring system-wide consistency. While local constraints govern individual state machines, global constraints bind the system together, ensuring that operations delegated between machines are executed correctly and that shared resources like memory maintain consistency.

The global constraint layer is where the modular architecture of the zkVM comes together. Individual state machines may be designed and tested independently, but global constraints establish the contracts between them. Violations of global constraints indicate either bugs in the constraint system design or attempts by a malicious prover to forge proofs.

This document covers global constraint types, their role in system integrity, and design patterns for effective global constraint systems.

## Types of Global Constraints

### Cross-Machine Constraints

Constraints linking different state machines:

```
Purpose:
  Ensure operations delegated from main machine to secondary
  machines are computed correctly.

Example (multiplication):
  Main machine: result = a * b
  Arithmetic machine: mul_result = mul_a * mul_b

  Global constraint (via permutation):
    (a, b, result) from main is permutation of
    (mul_a, mul_b, mul_result) from arithmetic

This ensures every multiplication in main has corresponding
correct computation in arithmetic machine.
```

### Memory Consistency

Global memory constraint:

```
Purpose:
  Every memory read returns the value from the most recent write.

Components:
  Main machine: issues reads and writes
  Memory machine: sorts operations, checks consistency

Global constraints:
  1. Permutation: main memory ops = memory machine ops
  2. Sorting: memory machine sorted by (addr, timestamp)
  3. Consistency: in sorted order, read values match writes
```

### Instruction Integrity

Program execution constraints:

```
Purpose:
  Instructions executed match the actual program.

Components:
  Main machine: fetches and executes instructions
  ROM/Program table: contains actual program

Global constraints:
  1. Lookup: every instruction fetch in ROM table
  2. Sequential: PC increments correctly (or valid jump)
  3. Termination: program ends at valid exit point
```

### Bus Constraints

Communication bus consistency:

```
Purpose:
  All bus transactions are balanced (send = receive).

Constraint form:
  sum over all machines of bus contribution = 0

Or equivalently:
  Random linear combination of sends = combination of receives
```

## Constraint Categories

### Equality Constraints

Direct value matching:

```
Simple form:
  value_in_machine_A = value_in_machine_B

Example:
  Register value written to memory must equal
  value read back from memory.

  main.store_value = memory.written_value
```

### Permutation Constraints

Multiset equality:

```
Form:
  Multiset of tuples in A = multiset of tuples in B

Implementation:
  Grand product argument:
    prod(r - tuple_A[i]) = prod(r - tuple_B[i])

  Running product columns track accumulation.
```

### Inclusion Constraints

Subset relationships:

```
Form:
  All values in V appear in table T

Implementation:
  Lookup argument:
    sum(1/(r - v_i)) = sum(m_j/(r - t_j))
```

### Sum Constraints

Aggregate properties:

```
Form:
  sum of values across rows = expected total

Example:
  Total gas used = sum of per-instruction gas

  sum(gas_per_instruction) = total_gas
```

## Implementation Patterns

### Grand Product Accumulator

For permutation constraints:

```
Columns:
  Z: running product accumulator

Constraint:
  Z[0] = 1 (initial)
  Z[i+1] = Z[i] * (r - tuple[i]) / (r - tuple_sorted[i])
  Z[n-1] = 1 (final)

The accumulator starts at 1, multiplies by elements from
one set and divides by elements from other set.
If sets are equal, product returns to 1.
```

### Running Sum Accumulator

For lookup constraints:

```
Columns:
  acc: running sum accumulator

Constraint:
  acc[0] = 0 (initial)
  acc[i+1] = acc[i] + 1/(r - v[i])
  acc[n-1] = table_sum (final)

Sum of reciprocals for looked-up values equals
sum for table (weighted by multiplicities).
```

### Cross-Trace Polynomials

Polynomials spanning traces:

```
When constraints span multiple traces:
  Trace A: columns A_0, A_1, ...
  Trace B: columns B_0, B_1, ...

Global polynomial:
  G(X) = combination(A_i(X), B_j(X), ...)

Must vanish on intersection of relevant domains.
```

## Boundary Constraints

### Initial State

Constraints at trace start:

```
At row 0:
  PC = entry_point
  Registers = initial_values
  Memory initialized correctly
  Accumulators = initial (1 for product, 0 for sum)
```

### Final State

Constraints at trace end:

```
At row n-1:
  PC = exit_point (or in valid termination state)
  Outputs match public outputs
  Accumulators = expected final values
  All pending operations complete
```

### Public Input/Output

Connecting to public values:

```
Public inputs (initial state):
  public_input[i] = trace[0].input_column[i]

Public outputs (final state):
  public_output[j] = trace[n-1].output_column[j]

These connect the trace to the statement being proved.
```

## Challenge-Derived Constraints

### Random Linear Combinations

Combining multiple constraints:

```
Individual global constraints: G_0, G_1, ..., G_k

Combined:
  G_combined = G_0 + alpha*G_1 + alpha^2*G_2 + ...

Where alpha is a random challenge from Fiat-Shamir.
```

### Lookup Challenges

Random elements for lookup arguments:

```
Table and lookup combination:
  combined_value = col_0 + r*col_1 + r^2*col_2 + ...

Where r is derived from transcript after commitments.
```

### Permutation Challenges

For permutation arguments:

```
Tuple combination:
  combined_tuple = tuple_0 + gamma*tuple_1 + gamma^2*tuple_2 + ...

Grand product over combined values.
```

## Verification of Global Constraints

### What Verifier Checks

Verifier's global constraint checks:

```
For each query point z:
  1. Verify permutation accumulator transitions correctly
  2. Verify lookup sums match
  3. Verify bus balances
  4. Verify boundary values match public inputs/outputs

The FRI proof confirms these constraints hold everywhere.
```

### Constraint Evaluation

At query points:

```
Evaluating global constraint at z:
  1. Get trace values from openings
  2. Get accumulator values
  3. Compute constraint polynomial value
  4. Include in composition check
```

## Design Principles

### Modularity

Keep constraints modular:

```
Good: Each global constraint has clear purpose
  - Memory consistency constraint
  - Arithmetic correctness constraint
  - Bus balance constraint

Bad: Monolithic constraint mixing concerns
  - Harder to debug
  - Harder to modify
  - Harder to verify correctness
```

### Completeness

Ensure all connections are constrained:

```
For every cross-machine operation:
  - Constrain inputs match
  - Constrain outputs match
  - Constrain operation was performed correctly

Missing constraints = soundness holes
```

### Efficiency

Minimize global constraint overhead:

```
Strategies:
  - Batch similar constraints
  - Use efficient accumulator patterns
  - Minimize auxiliary columns
  - Leverage sparsity when possible
```

## Common Issues

### Underconstrained Systems

Missing global constraints:

```
Symptom:
  Prover can produce valid-looking proofs for
  computations that aren't actually correct.

Example:
  Forgot to constrain memory read values
  Prover can read any value from any address

Fix:
  Systematic review of all cross-machine interactions
  Ensure every communication is constrained
```

### Overconstrained Systems

Too many or conflicting constraints:

```
Symptom:
  No valid trace exists even for correct computations.

Example:
  Conflicting constraints on accumulator values
  Impossible to satisfy both simultaneously

Fix:
  Check constraint compatibility
  Test with known-good traces
```

### Performance Issues

Inefficient global constraints:

```
Symptom:
  Proving time dominated by global constraint evaluation.

Causes:
  - Too many accumulator columns
  - High-degree global constraints
  - Inefficient lookup structures

Fix:
  - Combine accumulators where possible
  - Factor high-degree constraints
  - Optimize lookup table design
```

## Key Concepts

- **Global constraint**: Constraint spanning multiple components
- **Permutation**: Proving two multisets are equal
- **Accumulator**: Running product or sum for batch verification
- **Boundary constraint**: Fixing values at trace endpoints
- **Bus balance**: Ensuring send/receive match on communication bus

## Design Considerations

### Constraint Complexity

| Simple Constraints | Complex Constraints |
|-------------------|---------------------|
| Easy to verify correct | Harder to audit |
| May need more constraints | Fewer total constraints |
| Lower degree | Higher degree |
| Easier to debug | Harder to debug |

### System Integrity

| Thorough Constraints | Minimal Constraints |
|---------------------|---------------------|
| Higher security | Potential soundness gaps |
| More prover work | Less prover work |
| More verification work | Faster verification |
| Complete coverage | Requires careful analysis |

## Related Topics

- [Constraint Composition](../../02-stark-proving-system/02-constraint-system/03-constraint-composition.md) - Combining constraints
- [Secondary State Machines](03-secondary-state-machines.md) - Machine connections
- [Lookup Arguments](02-lookup-arguments.md) - Lookup constraints
- [Polynomial Identity Language](../../02-stark-proving-system/02-constraint-system/02-polynomial-identity-language.md) - Constraint specification
