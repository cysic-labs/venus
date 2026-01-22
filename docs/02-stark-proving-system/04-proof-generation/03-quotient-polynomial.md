# Constraint Evaluation

## Overview

Constraint evaluation is the process of computing constraint polynomials over the evaluation domain and verifying they vanish on the trace domain. In STARK proofs, constraints encode the correctness rules of the computation - each constraint polynomial must equal zero at every point where the trace represents valid execution. The quotient polynomial, obtained by dividing the composition of constraints by the vanishing polynomial, proves this property holds.

The evaluation process transforms algebraic constraint definitions into concrete polynomial computations. For each point in the evaluation domain, the prover evaluates all constraints using the committed trace polynomials, combines them with random weights, and computes the quotient. This quotient's bounded degree is then verified through FRI.

This document covers constraint evaluation mechanics, quotient polynomial computation, optimization techniques, and the relationship to proof soundness.

## Constraint Types

### Transition Constraints

Transition constraints relate values in consecutive rows:

```
Constraint form:
  C(T_0(X), T_1(X), ..., T_0(omega*X), T_1(omega*X), ...) = 0

Example (counter increment):
  T_counter(omega*X) - T_counter(X) - 1 = 0

  At row i: trace[i+1].counter = trace[i].counter + 1
```

Transition constraints must hold at all trace positions except possibly the last (where there is no "next" row).

### Boundary Constraints

Boundary constraints fix values at specific positions:

```
Initial (row 0):
  T_i(1) = initial_value

  As polynomial: (T_i(X) - initial_value) must vanish at X = 1

Final (last row):
  T_j(omega^{n-1}) = final_value

Intermediate (row k):
  T_m(omega^k) = required_value
```

### Periodic Constraints

Constraints applying at regular intervals:

```
Every 4th row:
  Applies when row mod 4 = 0
  Encoded with periodic vanishing polynomial

Selector approach:
  sel_periodic = polynomial that is 1 at rows 0, 4, 8, ...
                 and 0 elsewhere

  sel_periodic(X) * constraint(X) = 0
```

### Lookup Constraints

Constraints involving table lookups (covered separately via arguments):

```
Value v must appear in table T:
  Implemented via logarithmic derivative or permutation argument
  Generates auxiliary polynomial constraints
```

## Evaluation Domain

### Domain Structure

Constraints are evaluated on an extended domain:

```
Trace domain D: {omega^0, omega^1, ..., omega^{n-1}}
  Size n, constraint polynomials must vanish here

Evaluation domain E: {g * omega_m^0, g * omega_m^1, ..., g * omega_m^{m-1}}
  Size m = blowup * n
  g is coset generator (avoids trace domain)
  omega_m is primitive m-th root of unity
```

### Why Extended Domain

Reasons for evaluating on larger domain:

```
1. Constraint degree > trace degree:
   - Trace polynomials have degree < n
   - Quadratic constraints have degree < 2n
   - Evaluation domain must support higher degrees

2. Reed-Solomon encoding:
   - More evaluations = more error detection
   - FRI requires extended domain

3. Avoid trace domain:
   - Quotient undefined on trace (0/0)
   - Coset shifts evaluation away from trace
```

### Coset Selection

Choose coset to avoid trace domain:

```
Trace domain D: omega^i where omega^n = 1
Coset: g * D where g^n != 1

Typically g is a generator of larger group:
  If domain uses 2^k-th roots,
  g can be 2^{k+1}-th root (or higher)

Multiple cosets for full extended domain:
  E = g^0 * D' union g^1 * D' union ... union g^{b-1} * D'
  where D' has size n and g^b = 1 on extended group
```

## Evaluation Process

### Single Constraint Evaluation

Evaluate one constraint at one point:

```
Given:
  Point z in evaluation domain
  Trace polynomials T_0, T_1, ..., T_{w-1}
  Constraint C(T_0, T_1, ..., T_0', T_1', ...) where T' means next-row

Compute:
  // Current row values
  for i in 0..w:
    current[i] = T_i(z)

  // Next row values (shifted by omega)
  for i in 0..w:
    next[i] = T_i(omega * z)

  // Evaluate constraint expression
  result = C.evaluate(current, next)

  // result should be 0 for points on trace domain
```

### Batch Evaluation

Evaluate all constraints at one point:

```
def evaluate_all_constraints(z, trace_evals_current, trace_evals_next):
    results = []

    for constraint in constraints:
        value = constraint.evaluate(trace_evals_current, trace_evals_next)
        results.append(value)

    return results
```

### Full Domain Evaluation

Evaluate constraints at all points:

```
For each point z_i in evaluation domain E:
    1. Look up or compute T_j(z_i) for all columns j
    2. Look up or compute T_j(omega * z_i) for next-row access
    3. Evaluate all constraints at z_i
    4. Store constraint values for composition

Output: For each constraint, evaluations at all m points
```

## Composition Polynomial

### Random Linear Combination

Combine constraints with random weights:

```
Constraints: C_0, C_1, ..., C_k
Random challenge: alpha (from Fiat-Shamir)

Composition:
  Comp(X) = C_0(X) + alpha * C_1(X) + alpha^2 * C_2(X) + ... + alpha^k * C_k(X)

Property: If all C_i vanish on D, so does Comp
          If any C_i != 0 somewhere, Comp != 0 with high probability
```

### Degree Handling

Constraints may have different degrees:

```
Constraint degrees: d_0, d_1, ..., d_k
Composition degree: max(d_i)

For uniform treatment:
  Pad lower-degree constraints:
    C'_i(X) = C_i(X) * X^{max_degree - d_i}

  Or use degree-aware combination:
    Group by degree, combine each group, then combine groups
```

### Batching by Type

Organize constraint combination:

```
Transition constraints:
  Trans(X) = sum(alpha^i * transition_i(X))

Boundary constraints:
  Bound(X) = sum(beta^i * boundary_i(X))

Combined:
  Comp(X) = Trans(X) + gamma * Bound(X)

Benefits: Different vanishing polynomials per type
```

## Quotient Polynomial

### Definition

The quotient proves constraints vanish on trace domain:

```
If Comp(X) = 0 for all X in D, then:
  Comp(X) is divisible by vanishing polynomial Z_D(X) = X^n - 1

  Q(X) = Comp(X) / Z_D(X)

  Q is the quotient polynomial
```

### Degree Bound

Quotient degree determines FRI requirements:

```
Composition degree: max_constraint_degree * (n - 1)
Vanishing polynomial degree: n

Quotient degree: max_constraint_degree * (n - 1) - n
                = n * (max_constraint_degree - 1) - 1

For quadratic constraints (degree 2):
  Quotient degree = n - 1
```

### Computing the Quotient

Evaluate quotient on extended domain:

```
For each point z in evaluation domain E (avoiding D):
    comp_z = Composition(z)
    vanish_z = Z_D(z) = z^n - 1

    // z is not in D, so vanish_z != 0
    quotient_z = comp_z / vanish_z

Division is valid because z is in coset, not trace domain.
```

### Quotient Splitting

For FRI, split high-degree quotient:

```
Quotient Q(X) of degree d

Split into chunks of degree < m:
  Q(X) = Q_0(X) + X^m * Q_1(X) + X^{2m} * Q_2(X) + ...

Each Q_i has degree < m.

Combine chunks with random challenge:
  Q_combined(X) = Q_0(X) + delta * Q_1(X) + delta^2 * Q_2(X) + ...

FRI proves deg(Q_combined) < m.
```

## Optimization Techniques

### Precomputation

Precompute frequently used values:

```
Domain elements:
  eval_domain = [z_0, z_1, ..., z_{m-1}]
  next_domain = [omega * z_0, omega * z_1, ...]  // for next-row access

Vanishing polynomial values:
  vanish_values = [z_i^n - 1 for z_i in eval_domain]
  vanish_inv = [1 / (z_i^n - 1) for z_i in eval_domain]  // batch inverse

Powers of alpha:
  alpha_powers = [1, alpha, alpha^2, ..., alpha^k]
```

### Batch Inverse

Compute many inverses efficiently:

```
Need: 1/a_0, 1/a_1, ..., 1/a_{m-1}

Algorithm:
  products = [a_0, a_0*a_1, a_0*a_1*a_2, ...]
  all_inv = 1 / products[-1]  // single expensive inversion

  // Work backwards
  inverses[m-1] = all_inv * products[m-2]
  inverses[m-2] = inverses[m-1] * a_{m-1} / a_{m-2}
  ...

Cost: 3(m-1) multiplications + 1 inversion
  vs: m inversions without batching
```

### Parallel Evaluation

Parallelize across evaluation points:

```
Divide domain into chunks:
  Chunk 0: Points 0 to m/p - 1
  Chunk 1: Points m/p to 2m/p - 1
  ...
  Chunk p-1: Points (p-1)*m/p to m - 1

Each thread/core handles one chunk:
  - Independent evaluation
  - No synchronization needed within chunk
  - Combine results at end
```

### Vectorization

SIMD operations for constraint evaluation:

```
Evaluate same constraint at multiple points simultaneously:

  z_vec = [z_0, z_1, z_2, z_3]  // 4 points
  t0_vec = [T_0(z_0), T_0(z_1), T_0(z_2), T_0(z_3)]
  t1_vec = [T_1(z_0), T_1(z_1), T_1(z_2), T_1(z_3)]

  // Constraint: T_0 + T_1 - T_2 = 0
  result_vec = t0_vec + t1_vec - t2_vec  // Vector operations
```

### Lazy Evaluation

Compute constraint values on demand:

```
Instead of:
  1. Evaluate all constraints at all points
  2. Store huge matrix
  3. Combine

Do:
  1. For each point z:
     a. Compute needed trace values
     b. Evaluate constraints
     c. Accumulate weighted combination
     d. Compute quotient value

Memory: O(w) per point vs O(k * m) total
```

## Handling Special Cases

### Boundary Points

Constraints may not apply at all rows:

```
Transition constraints: Row 0 to n-2 (not last row)
  Vanishing polynomial: (X^n - 1) / (X - omega^{n-1})

Initial constraints: Only row 0
  Vanishing polynomial: (X - 1)

Final constraints: Only last row
  Vanishing polynomial: (X - omega^{n-1})
```

### Zero Vanishing Values

On trace domain, quotient is 0/0:

```
Problem: At z = omega^i (trace point):
  Composition(z) = 0 (constraints satisfied)
  Vanish(z) = z^n - 1 = omega^{in} - 1 = 1 - 1 = 0

Solution: Evaluate only on coset (not trace domain)
  All evaluation domain points avoid trace
  z^n != 1 for all z in evaluation domain
```

### Numerical Stability

No floating-point issues in finite fields, but:

```
Avoid unnecessary reductions:
  Accumulate partial sums before reducing mod p

Handle large intermediate values:
  Use 128-bit intermediates for 64-bit field

Verify no overflow:
  Check constraint evaluation doesn't exceed field size
```

## Verification Context

### Verifier's Constraint Check

At query points, verifier checks:

```
Given:
  - Query point z (from FRI)
  - Claimed trace values T_i(z)
  - Claimed quotient value Q(z)
  - Random challenges alpha, beta, ...

Verifier computes:
  1. Evaluate constraints at z using claimed T_i(z)
  2. Combine with alpha weights
  3. Compute vanish(z) = z^n - 1
  4. Check: Composition(z) == Q(z) * vanish(z)
```

### DEEP Polynomial

For stronger soundness, include out-of-domain point:

```
Sample random z outside both trace and evaluation domains.

Prover provides:
  - T_i(z) for all trace columns
  - Q(z) for quotient

Verifier checks constraint relation at z.

DEEP polynomial combines:
  - Claimed evaluations
  - Commitment consistency
  - Constraint satisfaction
```

## Debugging Constraint Violations

### Identifying Failures

When constraints don't evaluate to zero:

```
For each constraint C:
  For each trace row i:
    value = C.evaluate(trace[i], trace[i+1])
    if value != 0:
      print(f"Constraint {C.name} violated at row {i}")
      print(f"  Current row: {trace[i]}")
      print(f"  Next row: {trace[i+1]}")
      print(f"  Constraint value: {value}")
```

### Common Issues

Typical constraint evaluation problems:

```
1. Off-by-one errors:
   - Wrong row for next-row access
   - Boundary at wrong position

2. Missing selectors:
   - Constraint applies when it shouldn't
   - Selector logic incorrect

3. Field arithmetic errors:
   - Overflow in computation
   - Wrong modular reduction

4. Witness generation bugs:
   - Trace values incorrect
   - Auxiliary columns wrong
```

## Key Concepts

- **Constraint evaluation**: Computing constraint polynomials on evaluation domain
- **Composition polynomial**: Weighted sum of all constraints
- **Quotient polynomial**: Proves constraints vanish on trace domain
- **Vanishing polynomial**: X^n - 1, zero on trace domain
- **Coset evaluation**: Avoiding trace domain for valid division

## Design Considerations

### Evaluation Order

| Row-by-Row | Point-by-Point |
|------------|----------------|
| Evaluate all constraints at row i, then row i+1 | Evaluate constraint C at all points, then next constraint |
| Natural for sequential processing | Better for parallelization |
| Good cache locality for trace access | Good for SIMD vectorization |

### Memory vs. Computation

| Store All Evaluations | Recompute as Needed |
|----------------------|---------------------|
| Large memory for constraint values | Low memory |
| Fast quotient computation | Slower quotient |
| Enables debugging/inspection | Harder to debug |

## Related Topics

- [Constraint Composition](../02-constraint-system/03-constraint-composition.md) - Combining constraints
- [Polynomial Encoding](02-polynomial-encoding.md) - Trace polynomials
- [Fiat-Shamir Transform](04-fiat-shamir-transform.md) - Challenge generation
- [FRI Fundamentals](../03-fri-protocol/01-fri-fundamentals.md) - Quotient verification
