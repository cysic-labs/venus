# Gas and Cost Model

## Overview

The gas and cost model quantifies the computational expense of precompile operations, enabling resource planning and fair pricing in systems where proving costs matter. Unlike traditional gas models that measure execution time, zkVM gas models must account for constraint count, proof size, and verification complexity. A precompile that executes quickly but requires millions of constraints is expensive from a proving perspective.

Understanding the cost model helps developers choose between precompiles and emulation, optimize program structure, and predict proving resource requirements. The model also informs precompile design decisions, as reducing constraint count directly reduces costs. This economic dimension influences which operations receive precompile treatment and how those precompiles are optimized.

This document covers cost factors, measurement approaches, pricing strategies, and optimization techniques for managing precompile costs.

## Cost Factors

### Constraint Count

Primary cost driver:

```
Constraint count impact:
  More constraints = More prover work
  Linear relationship to proving time
  Affects proof generation resources

Measuring constraints:
  Per-operation constraint count
  Fixed overhead + per-unit scaling

Examples:
  SHA-256: ~25,000 constraints per 512-bit block
  Keccak-256: ~150,000 constraints per 1088-bit block
  EC scalar mul: ~100,000-500,000 constraints
```

### Trace Rows

Execution trace size:

```
Row count factors:
  Algorithm iterations (rounds)
  Input size (message blocks)
  Operation complexity

Row impact:
  FFT cost: O(n log n) for n rows
  Memory: O(n * columns)
  Commitment: O(n)

Examples:
  SHA-256 block: 64 rounds = 64+ rows
  EC mul (256-bit): 256+ point operations
```

### Lookup Overhead

Table usage costs:

```
Lookup components:
  Table size: Number of entries
  Query count: Number of lookups
  Multiplicity tracking

Cost factors:
  Larger tables: More commitment work
  More queries: More accumulator updates
  Sparse usage: Wasted table entries

Optimization:
  Shared tables across precompiles
  Right-sized tables
  Efficient query batching
```

### Memory Usage

Working memory requirements:

```
Memory types:
  Trace memory: Column storage
  Intermediate memory: Computation scratch
  Table memory: Lookup tables

Prover memory:
  Must hold full trace
  All tables in memory
  Intermediate computations

Memory constraints often limit:
  Maximum trace size
  Number of concurrent precompiles
  Batching capacity
```

## Cost Measurement

### Static Analysis

Analyzing circuit structure:

```
Constraint counting:
  Count constraints per operation
  Sum across all operations
  Include overhead

Formula-based:
  SHA-256: C_fixed + C_per_block * num_blocks
  EC mul: C_fixed + C_per_bit * scalar_bits

Precomputed tables:
  Known constraint counts per precompile
  Published in documentation
```

### Dynamic Measurement

Measuring actual proving:

```
Profiling:
  Time proving with precompile
  Compare to baseline
  Extract per-call cost

Metrics:
  Wall clock time
  CPU cycles
  Memory high water mark
  Proof size contribution

Benchmarking:
  Representative inputs
  Varying input sizes
  Different batch sizes
```

### Cost Formulas

Mathematical cost models:

```
Linear model:
  Cost = a + b * input_size

Where:
  a = fixed overhead (setup, finalization)
  b = per-unit cost (per byte, per round)

SHA-256 example:
  Cost = 5000 + 400 * num_blocks
  (approximate constraint count)

EC scalar mul example:
  Cost = 10000 + 400 * num_bits
```

## Pricing Strategies

### Constraint-Based Pricing

Direct constraint cost:

```
Gas = constraint_count * gas_per_constraint

Where:
  gas_per_constraint: System-wide constant
  constraint_count: From precompile analysis

Benefits:
  Fair: Reflects actual proving work
  Predictable: Easy to compute
  Incentive-aligned: Optimizes constraint efficiency
```

### Tiered Pricing

Size-based tiers:

```
Small inputs: Base gas
Medium inputs: Base + linear component
Large inputs: Base + linear + premium

Example (hash):
  0-64 bytes: 200 gas
  65-512 bytes: 200 + 3 * num_blocks
  512+ bytes: 200 + 3 * num_blocks + 1 * excess_blocks

Rationale:
  Amortize fixed costs
  Discourage excessive sizes
  Reflect actual proving costs
```

### Batch Discounts

Reduced cost for batching:

```
Single call: Full gas
Batched calls: Discounted per call

Discount formula:
  Batch gas = N * single_gas * discount_factor(N)

Where:
  discount_factor(N) = 0.8 + 0.2/N (example)

Rationale:
  Fixed costs amortized
  Encourages efficient batching
  Reflects actual savings
```

## Cost Comparison

### Precompile vs Emulation

When precompile wins:

```
Emulation cost:
  instructions * constraints_per_instruction

Precompile cost:
  precompile_constraints

Ratio:
  emulation / precompile = efficiency_gain

Examples:
  SHA-256: 100,000+ instructions vs 25,000 constraints
  Efficiency gain: ~50-100x

  Keccak: 200,000+ instructions vs 150,000 constraints
  Efficiency gain: ~20-50x
```

### Precompile Comparison

Choosing between precompiles:

```
Hash function comparison:
  SHA-256: ~25K constraints/block, 512-bit blocks
  Keccak-256: ~150K constraints/block, 1088-bit blocks
  Poseidon: ~300 constraints/hash, field elements

For ZK applications:
  Poseidon often cheapest
  SHA-256 for Bitcoin compatibility
  Keccak for Ethereum compatibility

Selection criteria:
  Constraint efficiency
  Compatibility requirements
  Security level
```

### Input Size Scaling

How cost grows with input:

```
Linear scaling:
  Hash: Proportional to message length
  EC mul: Proportional to scalar bits

Sub-linear scaling:
  Batched operations
  Amortized setup costs

Super-linear scaling:
  Some complex operations
  Memory-intensive algorithms

Understanding scaling guides:
  Input size limits
  Batching strategies
  Algorithm selection
```

## Optimization Techniques

### Constraint Reduction

Lowering constraint count:

```
Techniques:
  Algebraic simplification
  Lookup table usage
  Efficient field representation
  Degree reduction

Example (Boolean to arithmetic):
  Bit decomposition: 64 constraints
  Lookup table: 8 constraints (byte-wise)
  Savings: 56 constraints
```

### Batching Optimization

Efficient multi-call processing:

```
Batch benefits:
  Shared table commitments
  Amortized setup
  Parallel proving

Optimal batch size:
  Balance memory vs efficiency
  Diminishing returns at large sizes
  Practical limits: 10-100 calls
```

### Lazy Evaluation

Defer expensive work:

```
Eager: Compute everything immediately
  Simple, but may waste work

Lazy: Compute when needed
  Only prove required operations
  Skip unused results

Application:
  Conditional precompile results
  Speculative execution
```

## Resource Planning

### Proving Budget

Allocating resources:

```
Total budget:
  Available proving time
  Memory capacity
  Acceptable proof size

Budget allocation:
  Main execution: X%
  Memory machine: Y%
  Precompiles: Z%

Precompile portion:
  Must fit within budget
  May limit call count
  Influences program design
```

### Capacity Planning

Estimating requirements:

```
For program with:
  N hash operations
  M EC multiplications
  K signature verifications

Estimated constraints:
  N * hash_cost + M * ecmul_cost + K * sig_cost

Resource requirements:
  Memory: Based on trace size
  Time: Based on constraint count
  Proof size: Based on proof system
```

## Key Concepts

- **Constraint count**: Primary cost metric
- **Gas model**: Economic abstraction for costs
- **Cost formula**: Mathematical cost prediction
- **Batch discount**: Reduced per-call cost in batches
- **Efficiency ratio**: Precompile vs emulation savings

## Design Considerations

### Pricing Accuracy

| Simple Model | Complex Model |
|--------------|---------------|
| Easy to compute | Accurate prediction |
| May over/under price | Fair pricing |
| Less overhead | More overhead |
| Predictable | Complex |

### Cost Transparency

| Hidden Costs | Transparent Costs |
|--------------|-------------------|
| Simpler interface | Informed decisions |
| May surprise users | Predictable budgeting |
| Less optimization | Optimization enabled |

## Related Topics

- [Precompile Concept](01-precompile-concept.md) - Precompile overview
- [Precompile Architecture](02-precompile-architecture.md) - Implementation structure
- [Proof Aggregation](../../04-zkvm-architecture/05-system-integration/04-proof-aggregation.md) - Aggregation costs
- [Performance Optimization](../../10-performance-optimization/01-prover-optimization/01-constraint-optimization.md) - Optimization techniques
