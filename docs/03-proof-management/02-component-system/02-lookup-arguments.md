# Lookup Arguments

## Overview

Lookup arguments are a fundamental technique for proving that values in a computation appear in a predefined table. Instead of constraining values directly through polynomial equations, lookups verify membership in a table - enabling efficient range checks, operation tables, and cross-component communication. This approach dramatically reduces constraint complexity for operations that would otherwise require many polynomial constraints.

In zkVM implementations, lookup arguments are pervasive. Every range check, every memory access validation, every instruction decoding, and every precomputed operation relies on lookups. The efficiency of lookup argument implementation directly impacts overall prover performance, making this a critical area for optimization.

This document covers lookup argument theory, implementation approaches, table design, and optimization strategies.

## Lookup Problem

### Definition

The lookup problem:

```
Given:
  - Table T = {t_0, t_1, ..., t_{m-1}} (fixed, known values)
  - Values V = {v_0, v_1, ..., v_{n-1}} (prover's values)

Prove:
  Every v_i appears in T
  (Possibly with different multiplicities)
```

### Why Lookups Matter

Operations well-suited to lookups:

```
Range checks:
  - Prove v is in [0, 255]
  - Table: {0, 1, 2, ..., 255}
  - Single lookup vs. 8 bit decomposition constraints

Operation tables:
  - Prove c = a XOR b for 8-bit values
  - Table: {(a, b, a XOR b) for all 8-bit a, b}
  - Single lookup vs. bit-by-bit XOR constraints

Memory consistency:
  - Prove read returns written value
  - Table: all (address, value, timestamp) tuples
  - Lookup to verify consistency
```

### Lookup vs. Direct Constraints

Comparison of approaches:

```
Direct constraint for range [0, 255]:
  - Decompose into 8 bits
  - 8 binary constraints: b_i * (1 - b_i) = 0
  - 1 reconstruction: v = sum(b_i * 2^i)
  - Total: 9 constraints per value

Lookup for range [0, 255]:
  - Table of 256 entries
  - 1 lookup argument per value
  - Amortized cost much lower for many values
```

## Logarithmic Derivative Approach

### Core Idea

Use logarithmic derivatives to batch membership checks:

```
If all v_i are in T, then:
  sum_i 1/(X - v_i) = sum_j m_j/(X - t_j)

where m_j is the multiplicity of t_j (how many v_i equal t_j)

At random evaluation point r:
  sum_i 1/(r - v_i) = sum_j m_j/(r - t_j)

This is a single equation checking all lookups.
```

### Running Sum Formulation

Compute sums as running accumulations:

```
For looked-up values:
  acc_v[0] = 0
  acc_v[i] = acc_v[i-1] + 1/(r - v_i)

For table with multiplicities:
  acc_t[0] = 0
  acc_t[j] = acc_t[j-1] + m_j/(r - t_j)

Final check:
  acc_v[n-1] = acc_t[m-1]
```

### Constraint Form

As polynomial constraints:

```
Columns:
  v: values to look up
  t: table values
  m: multiplicities
  acc_v: running sum for values
  acc_t: running sum for table

Constraints:
  // Running sum for values
  acc_v' = acc_v + 1/(r - v)

  // Running sum for table (non-zero multiplicity)
  (m != 0) * (acc_t' = acc_t + m/(r - t))

  // Final equality
  acc_v[last] = acc_t[last]
```

### Avoiding Division

Handle division through auxiliary columns:

```
Instead of: acc' = acc + 1/(r - v)

Use: (acc' - acc) * (r - v) = 1

Column r_minus_v = r - v (computed, not inverted)

Constraint: (acc' - acc) * r_minus_v = 1

Or batch inversions and include inverse as witness.
```

## Permutation-Based Lookups

### Grand Product Approach

Alternative using products instead of sums:

```
For values V and table T with multiplicities:
  prod_i (r - v_i) = prod_j (r - t_j)^{m_j}

In running product form:
  Z[0] = 1
  Z[i+1] = Z[i] * (r - v_i) / (r - t_i)^{m_i}
  Z[last] = 1

This shows V is a sub-multiset of T.
```

### Plookup Protocol

Specific permutation-based protocol:

```
Setup:
  Sort table T
  Compute differences between consecutive entries

Prover:
  Sort values V
  Interleave V into T to create combined sorted list
  Generate permutation argument proving interleaving valid

Constraints:
  Sorted property
  Interleaving correctness
  Permutation grand product
```

## Table Types

### Fixed Tables

Tables known at setup time:

```
Examples:
  - Range tables: [0..255], [0..65535]
  - XOR tables: {(a, b, a XOR b)}
  - AND tables: {(a, b, a AND b)}
  - Multiplication tables: {(a, b, a*b mod 2^k)}

Properties:
  - Can be precomputed
  - Evaluations known to verifier
  - No prover work for table itself
```

### Dynamic Tables

Tables depending on computation:

```
Examples:
  - Memory table: (addr, value, timestamp) from execution
  - Instruction table: decoded instructions
  - Call stack: return addresses

Properties:
  - Generated during witness generation
  - Prover commits to table
  - Table itself is part of witness
```

### Multi-Column Tables

Tables with tuple entries:

```
Table entry: (a, b, c, ...)
Lookup: (v_a, v_b, v_c, ...) in Table

Combine columns with random linear combination:
  combined = v_a + r*v_b + r^2*v_c + ...
  table_combined = a + r*b + r^2*c + ...

Single-column lookup on combined values.
```

## Multiplicity Handling

### Multiplicity Column

Track how many times each table entry is used:

```
For each table row j:
  m[j] = count of values v_i equal to t[j]

Properties:
  - m[j] >= 0 for all j
  - sum(m[j]) = n (total lookups)
  - m[j] can be large if entry heavily used
```

### Computing Multiplicities

During witness generation:

```
Algorithm:
  Initialize m[j] = 0 for all j
  For each lookup value v_i:
    Find j such that t[j] = v_i
    m[j] += 1

Optimization:
  Build hash map of table entries to indices
  O(n) time for all multiplicities
```

### Sparse Multiplicities

When most table entries unused:

```
Problem:
  Table size m, but only k << m entries used
  Full multiplicity column wastes space

Solution:
  Only include non-zero multiplicities
  Use lookup argument for active entries
  Or use sparse representation
```

## Optimization Techniques

### Batched Lookups

Combine multiple lookup arguments:

```
Multiple tables: T_1, T_2, ..., T_k
Multiple value sets: V_1, V_2, ..., V_k

Combine with random weights:
  sum_i sum_j 1/(r - V_i[j]) = sum_i sum_l m_i[l]/(r - T_i[l])

With different random combinations for each table.
```

### Table Compression

Reduce table size:

```
Technique 1: Factoring
  Instead of full XOR table (2^16 entries for 8-bit),
  Use two 4-bit XOR tables (2 * 16 = 32 entries)
  Additional constraints to combine results

Technique 2: Lazy evaluation
  Only include table entries that are actually used
  Prover proves completeness of included entries
```

### Caching

Reuse lookup computations:

```
Same table used multiple times:
  - Compute table polynomial once
  - Cache table evaluations
  - Reuse for multiple lookup arguments

Same values looked up multiple times:
  - Deduplicate lookups
  - Single lookup for unique values
  - Track multiplicities for repeated values
```

## Implementation Patterns

### Lookup Column Layout

Organizing lookup-related columns:

```
Columns for single lookup argument:
  v: value column (what we're looking up)
  t: table column (padded if needed)
  m: multiplicity column
  acc: running sum/product accumulator
  helper: inverse or other helper values
```

### Constraint Integration

Integrating lookups with other constraints:

```
Main state machine has values to verify:
  result = a + b

Lookup verifies result is in range:
  result in [0, 2^32)

Integration:
  1. Include result in lookup value column
  2. Connect via permutation argument
  3. Or use inline lookup constraint
```

### Cross-Component Lookups

Lookups between different components:

```
Component A produces values V
Component B provides table T

Connection:
  1. Both include lookup interface columns
  2. Permutation argument links them
  3. Grand product spans both components

Constraint:
  A.lookup_out = B.lookup_in (via permutation)
```

## Security Considerations

### Soundness

Lookup argument security:

```
If prover uses value not in table:
  sum_i 1/(r - v_i) != sum_j m_j/(r - t_j)

At random r, equality holds with probability:
  ~ max(n, m) / |F|

With extension field and large |F|, this is negligible.
```

### Table Integrity

Ensuring table correctness:

```
Fixed tables:
  - Verifier knows table
  - Can check table polynomial matches expectation

Dynamic tables:
  - Table is committed by prover
  - Must prove table is correctly constructed
  - Additional constraints for table validity
```

## Key Concepts

- **Lookup argument**: Proving values appear in a table
- **Logarithmic derivative**: Sum-based lookup technique
- **Multiplicity**: Count of how often each table entry is used
- **Running sum**: Accumulator for batch verification
- **Table**: Set of valid values for lookups

## Design Considerations

### Table Size Trade-offs

| Large Table | Small Table |
|-------------|-------------|
| Fewer lookups needed | More lookups needed |
| More memory | Less memory |
| Single lookup for complex ops | Multiple lookups for complex ops |
| Higher setup cost | Lower setup cost |

### Lookup Approach Selection

| Logarithmic Derivative | Permutation |
|------------------------|-------------|
| Simpler constraints | More complex |
| Division required | No division |
| Good for many tables | Good for few tables |
| Lower degree constraints | Higher degree |

## Related Topics

- [Component Registry](01-component-registry.md) - Managing lookup tables
- [Constraint Composition](../../02-stark-proving-system/02-constraint-system/03-constraint-composition.md) - Integrating lookups
- [Range Checking](../../04-zkvm-architecture/03-memory-system/02-range-checking.md) - Range check lookups
