# Expression Compilation

## Overview

Expression compilation transforms high-level mathematical expressions into optimized low-level code for efficient evaluation. In zero-knowledge proof systems, constraint expressions and polynomial computations must be evaluated billions of times, making expression compilation a critical optimization that can reduce proving time by orders of magnitude.

The gap between naive expression evaluation and optimized compiled code is substantial. Naive interpreters perform redundant computations, suffer from branch mispredictions, and fail to exploit parallelism. Compiled expressions eliminate interpretation overhead, share common subexpressions, schedule operations for hardware efficiency, and generate vectorized code. The result is evaluation speeds approaching hardware limits.

This document explores expression compilation concepts, optimization techniques, and design considerations for zkVM performance.

## Expression Representation

### Abstract Syntax Trees

Expressions naturally form tree structures:

```
Expression: (a + b) * c + (a + b) * d

Tree representation:
        [+]
       /   \
    [*]     [*]
   /   \   /   \
 [+]   c [+]   d
 / \     / \
a   b   a   b

Observations:
- (a + b) appears twice
- Tree structure shows dependencies
- Leaves are inputs, internal nodes are operations
```

### Directed Acyclic Graphs

Share common subexpressions:

```
Same expression as DAG:
        [+]
       /   \
    [*]     [*]
   /   \   /   \
 [+]   c [+]   d
   \     /
    [+]        <- Shared node
    / \
   a   b

Benefits:
- Eliminates redundant computation
- Reduces memory for representation
- Reveals optimization opportunities
```

### Three-Address Code

Linearized representation:

```
Expression: (a + b) * c + (a + b) * d

Three-address form:
t1 = a + b
t2 = t1 * c
t3 = t1 * d     // Reuses t1
t4 = t2 + t3

Properties:
- Sequential operations
- Explicit temporaries
- Natural for code generation
```

### Static Single Assignment

Each variable assigned exactly once:

```
Standard form:
x = a + b
x = x * c      // x redefined

SSA form:
x1 = a + b
x2 = x1 * c    // New variable

Benefits:
- Simplifies dataflow analysis
- Enables optimization algorithms
- Natural for functional transforms
```

## Common Subexpression Elimination

### Identification

Finding repeated subexpressions:

```
Process:
1. Hash each expression node
2. Group nodes with same hash
3. Verify structural equality
4. Merge duplicate nodes

Example:
Expression: a*b + c + a*b
Before: [+] [+] [*] [*] a b c
After:  [+] [+] [*] a b c     // One [*] serves both uses
```

### Value Numbering

Assign numbers to equivalent values:

```
Algorithm:
1. Assign unique number to each input
2. For each operation, compute result number
3. Operations with same input numbers get same result number

Example:
a -> #1, b -> #2, c -> #3
a + b -> #4
c + a -> #5
a + b -> #4 (same as before, reused)
```

### Scope Considerations

Where subexpressions can be shared:

```
Global CSE:
Share across entire expression
Maximum elimination, may increase live ranges

Local CSE:
Share within basic blocks
Limited scope, simpler analysis

Loop-aware CSE:
Hoist invariant computations out of loops
Reduces per-iteration work
```

## Algebraic Optimization

### Strength Reduction

Replace expensive operations with cheaper ones:

```
Transformations:
x * 2 -> x + x                    // Multiply to add
x * 4 -> x << 2                   // Multiply to shift
x / 8 -> x >> 3                   // Divide to shift (unsigned)
x * 3 -> (x << 1) + x             // Multiply to shift+add
x^2 -> x * x                      // Power to multiply
```

### Identity Elimination

Remove unnecessary operations:

```
Identities:
x + 0 -> x
x * 1 -> x
x * 0 -> 0
x - 0 -> x
x ^ 0 -> 1 (exponentiation)
x & 0xFFFFFFFF -> x (32-bit)
```

### Constant Folding

Evaluate constant expressions at compile time:

```
Before:
result = (3 + 4) * x + 7 * 2

After constant folding:
result = 7 * x + 14

Further optimization:
result = (x << 3) - x + 14    // 7*x = 8*x - x
```

### Reassociation

Reorder operations for optimization:

```
Original: (a + b) + (c + d)
Reassociated: ((a + c) + b) + d

Benefits:
- May enable CSE with other expressions
- May reduce critical path
- May improve register allocation
```

## Field Arithmetic Optimization

### Delayed Reduction

Accumulate before reducing:

```
Naive:
t1 = (a + b) mod p
t2 = (t1 + c) mod p
t3 = (t2 + d) mod p      // 3 reductions

Delayed reduction:
t = a + b + c + d        // No overflow in 128-bit
result = t mod p         // 1 reduction

Requirements:
- Track maximum value of accumulator
- Reduce before overflow
- Know when final result needed
```

### Lazy Montgomery Form

Defer conversion to/from Montgomery form:

```
Montgomery multiplication:
Mont(x, y) = x * y * R^(-1) mod p

Conversions:
To Mont: x' = x * R mod p
From Mont: x = x' * 1 mod p (using Mont mul)

Optimization:
Keep values in Montgomery form as long as possible
Convert only at expression boundaries
```

### Specialized Reductions

Use field-specific reduction:

```
Goldilocks: p = 2^64 - 2^32 + 1
Reduction exploits: 2^64 = 2^32 - 1 (mod p)

Mersenne-like: p = 2^k - c
Reduction: (h * 2^k + l) mod p = l + h * c (mod p)

Barrett: Precomputed inverse
General fields, predictable performance
```

## Polynomial Expression Optimization

### Horner's Method

Optimal evaluation order:

```
Standard:
P(x) = a_n*x^n + a_{n-1}*x^{n-1} + ... + a_1*x + a_0
Requires: n additions, (n^2+n)/2 multiplications

Horner's:
P(x) = (((a_n*x + a_{n-1})*x + a_{n-2})*x + ...)*x + a_0
Requires: n additions, n multiplications
```

### Multi-Point Evaluation

Evaluate at multiple points efficiently:

```
Naive:
For each point x_i:
    P(x_i) = Horner(P, x_i)    // O(n) per point
Total: O(n * m) for m points

Divide and conquer:
Split P into P_even(x^2) + x*P_odd(x^2)
Evaluate both at x^2 values
Combine results
Total: O(n log n + m log m)
```

### Constraint Composition

Combine constraints efficiently:

```
Individual evaluation:
c1 = constraint_1(trace_row)
c2 = constraint_2(trace_row)
...
combined = alpha * c1 + alpha^2 * c2 + ...

Fused evaluation:
Interleave constraint computations
Share common column accesses
Accumulate result directly
```

## Code Generation

### Instruction Selection

Map operations to machine instructions:

```
Expression operation -> Candidate instructions

ADD:
- add (register-register)
- add (register-immediate)
- lea (add with shift)

MUL:
- imul (signed multiply)
- mul (unsigned multiply)
- mulx (extended multiply, no flags)

Selection criteria:
- Operation semantics
- Operand types
- Side effects (flags)
```

### Register Allocation

Assign variables to registers:

```
Strategies:

Linear scan:
Process in order, allocate next available register
Fast, good for JIT

Graph coloring:
Build interference graph, color with K registers
Optimal quality, slower

Spilling:
When registers exhausted, store to memory
Preferentially spill values with long live ranges
```

### Instruction Scheduling

Order instructions for pipeline efficiency:

```
Original:
load r1, [mem1]
mul r2, r1, r1    // Stalls waiting for load
load r3, [mem2]
mul r4, r3, r3    // Stalls waiting for load

Scheduled:
load r1, [mem1]
load r3, [mem2]   // Issue while r1 loading
mul r2, r1, r1    // r1 now available
mul r4, r3, r3    // r3 now available
```

### Loop Optimization

Optimize repeated evaluation:

```
Loop hoisting:
Move invariant computations outside loop

Loop unrolling:
Reduce loop overhead, increase ILP

Software pipelining:
Overlap iterations for continuous execution

Vectorization:
Use SIMD for parallel iterations
```

## Just-In-Time Compilation

### Runtime Code Generation

Generate code during execution:

```
Workflow:
1. Receive expression specification
2. Apply optimizations
3. Generate machine code
4. Execute compiled code

Benefits:
- Adapt to runtime information
- Specialize for specific inputs
- Avoid interpretation overhead
```

### Specialization

Customize code for specific cases:

```
Generic:
result = base ^ exponent    // Variable exponent

Specialized (exponent = 5):
result = base * base        // base^2
result = result * result    // base^4
result = result * base      // base^5

Specialization triggers:
- Known constants
- Frequent values
- Performance-critical paths
```

### Caching Compiled Code

Reuse previously compiled expressions:

```
Cache structure:
expression_hash -> compiled_function_pointer

Workflow:
1. Hash incoming expression
2. Check cache for existing compilation
3. If hit: use cached code
4. If miss: compile, cache, use

Cache management:
- LRU eviction for size limits
- Invalidation on expression changes
```

## Vectorized Expression Evaluation

### Data-Parallel Compilation

Generate SIMD code:

```
Scalar expression:
result = a * b + c

Vectorized (4-wide):
result[0:4] = a[0:4] * b[0:4] + c[0:4]

Code generation:
- Use vector load/store
- Use vector arithmetic
- Handle remainders
```

### Horizontal Operations

Reduce across vector lanes:

```
Sum reduction:
v = [a, b, c, d]
sum = a + b + c + d

Compiled sequence:
hadd v, v        // [a+b, c+d, ...]
hadd v, v        // [a+b+c+d, ...]
extract r, v, 0  // Get sum
```

### Gather/Scatter Patterns

Non-contiguous vector access:

```
Indexed access:
for i in 0..4:
    result[i] = table[index[i]]

Compiled:
indices = load(index)
gathered = gather(table, indices)
store(result, gathered)
```

## Performance Considerations

### Compile Time vs. Runtime

Balance compilation cost against execution benefit:

```
Compile time: T_compile
Runtime per evaluation: T_eval
Number of evaluations: N

Total time = T_compile + N * T_eval

Break-even:
N_break_even = T_compile / (T_eval_interpreted - T_eval_compiled)

For N > N_break_even, compilation is beneficial.
```

### Optimization Levels

Trade compilation time for code quality:

```
Level 0 (minimal):
- Direct translation
- No optimization
- Fast compilation

Level 1 (basic):
- CSE
- Constant folding
- Moderate compilation time

Level 2 (full):
- All optimizations
- Instruction scheduling
- Slower compilation, best code
```

### Memory Pressure

Code cache considerations:

```
Many compiled expressions:
- May exceed instruction cache
- Causes cache thrashing
- Consider code compaction

Strategies:
- Limit compiled code size
- Share common code sequences
- Interpret rarely-used expressions
```

## Key Concepts

- **Common subexpression elimination (CSE)**: Computing shared subexpressions once
- **Strength reduction**: Replacing expensive operations with cheaper equivalents
- **Constant folding**: Evaluating constants at compile time
- **Register allocation**: Assigning variables to processor registers
- **Instruction scheduling**: Ordering operations for pipeline efficiency
- **JIT compilation**: Generating code at runtime
- **Specialization**: Customizing code for specific inputs

## Design Trade-offs

### Compile Time vs. Code Quality

| Optimization Level | Compile Time | Code Quality | Best For |
|--------------------|--------------|--------------|----------|
| None | Instant | Baseline | Debugging |
| Basic | Fast | Good | Moderate reuse |
| Full | Slow | Optimal | Heavy reuse |

### Interpretation vs. Compilation

| Approach | Setup Cost | Per-eval Cost | Best For |
|----------|------------|---------------|----------|
| Interpretation | Zero | High | Few evaluations |
| JIT compilation | Moderate | Low | Many evaluations |
| AOT compilation | High | Lowest | Production deployment |

### Specialization Degree

| Strategy | Flexibility | Performance | Code Size |
|----------|-------------|-------------|-----------|
| Fully generic | Maximum | Baseline | Minimal |
| Partially specialized | Good | Better | Moderate |
| Fully specialized | Minimal | Best | Large |

## Related Topics

- [Batch Processing](01-batch-processing.md) - Evaluating compiled expressions in batches
- [Lookup Tables](02-lookup-tables.md) - Alternative to compiled arithmetic
- [SIMD Vectorization](../01-cpu-optimization/01-simd-vectorization.md) - Vectorized expression evaluation
- [Polynomial Identity Language](../../02-stark-proving-system/02-constraint-system/02-polynomial-identity-language.md) - Source expressions
- [Constraint Composition](../../02-stark-proving-system/02-constraint-system/03-constraint-composition.md) - Constraint expression optimization
