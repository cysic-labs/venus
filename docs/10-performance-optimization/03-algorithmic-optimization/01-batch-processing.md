# Batch Processing

## Overview

Batch processing is an optimization strategy that groups multiple independent operations together for collective processing, rather than handling each operation individually. In zero-knowledge proof systems, batch processing transforms workloads to better exploit parallelism, amortize fixed costs, and improve cache utilization.

Individual cryptographic operations incur significant overhead: function call costs, cache misses, pipeline stalls, and memory allocation. When thousands or millions of similar operations must be performed, batch processing allows these overheads to be paid once rather than repeatedly. The cumulative effect can reduce proving time by factors of 2-10x for batch-amenable workloads.

This document explores batch processing concepts, patterns, and design considerations for zkVM performance optimization.

## Batch Processing Fundamentals

### The Batch Principle

Processing items in batches amortizes overhead:

```
Individual processing:
For each item:
    overhead (setup, cache miss, function call)
    + actual work

Total cost: N * (overhead + work)

Batch processing:
Single overhead (setup, cache prime, function call)
+ work for all items

Total cost: overhead + N * work
```

When overhead is significant relative to per-item work, batching provides substantial speedup.

### Types of Overhead Amortized

**Function call overhead**:
- Stack frame setup
- Parameter passing
- Return value handling
- Reduced with fewer calls

**Cache effects**:
- Cold cache misses
- Instruction cache loading
- Data locality
- Improved with sustained access patterns

**Memory allocation**:
- Allocator calls
- Fragmentation
- System calls
- Pre-allocated batch buffers avoid per-item allocation

**Pipeline effects**:
- Branch prediction training
- Instruction prefetch
- Out-of-order setup
- Amortized over batch

**Parallelization overhead**:
- Thread spawning
- Synchronization
- Work distribution
- Single parallel dispatch for entire batch

### Batch Size Selection

Optimal batch size balances multiple factors:

```
Too small: Overhead not fully amortized
Too large: Memory pressure, latency increase

Factors:
- Cache size (batch should fit in relevant cache level)
- Parallelism (batch should saturate available cores)
- Memory budget (batch must fit in available RAM)
- Latency requirements (larger batch = longer wait)
```

## Batch Processing Patterns

### Homogeneous Batching

All items in batch undergo identical processing:

```
Examples:
- Batch of field multiplications
- Batch of hash computations
- Batch of polynomial evaluations at same point

Structure:
inputs: [item_0, item_1, item_2, ..., item_n]
operation: single_function
outputs: [result_0, result_1, result_2, ..., result_n]
```

Most efficient pattern due to maximum uniformity.

### Heterogeneous Batching

Different operations grouped together:

```
Examples:
- Multiple constraint types evaluated together
- Various state machine operations
- Mixed instruction execution

Structure:
inputs: [(item_0, op_type_a), (item_1, op_type_b), ...]
operation: dispatch_table[op_type]
outputs: [result_0, result_1, ...]
```

Less efficient but necessary when operation types vary.

### Streaming Batches

Continuous processing with rolling batches:

```
Stream: [....items arriving continuously....]
                       |
                       v
Batch Buffer: [item_i, item_i+1, ..., item_i+batch_size-1]
                       |
              (when full)
                       v
                  Process batch
                       |
                       v
Output: [result_i, result_i+1, ..., result_i+batch_size-1]
```

Balances latency and throughput.

### Hierarchical Batching

Batches of batches for multi-level optimization:

```
Level 0 (L1 cache sized): [item_0, ..., item_k]
Level 1 (L2 cache sized): [batch_0, batch_1, ..., batch_m]
Level 2 (main memory):    [super_batch_0, ...]

Processing:
- Inner batches optimized for cache size
- Outer batches optimized for parallelism
```

## Memory Organization for Batching

### Data Layout Transformation

Convert layouts for efficient batch access:

```
Array of Structures (AoS):
[(a0, b0, c0), (a1, b1, c1), (a2, b2, c2), ...]

Structure of Arrays (SoA):
a: [a0, a1, a2, ...]
b: [b0, b1, b2, ...]
c: [c0, c1, c2, ...]

SoA enables:
- Vectorized access to single field
- Better cache utilization
- Efficient SIMD processing
```

### Contiguous Allocation

Batch data in continuous memory:

```
Scattered allocation (poor):
item_0 at address 0x1000
item_1 at address 0x5000
item_2 at address 0x3000

Contiguous allocation (good):
item_0 at address 0x1000
item_1 at address 0x1040
item_2 at address 0x1080

Benefits:
- Sequential memory access
- Effective prefetching
- Reduced TLB misses
```

### Buffer Reuse

Preallocate and reuse batch buffers:

```
Pattern:
// Allocate once
batch_buffer = allocate(batch_size * item_size)

// Reuse for multiple batches
for batch in batches:
    fill(batch_buffer, batch)
    process(batch_buffer)
    extract_results(batch_buffer)

// Free once
deallocate(batch_buffer)
```

### Alignment Considerations

Align batch buffers for hardware efficiency:

```
Alignment requirements:
- SIMD operations: 16/32/64 byte alignment
- GPU access: 128+ byte alignment
- Cache lines: 64 byte alignment

Ensure:
- Buffer start aligned
- Individual items aligned
- Padding as needed between items
```

## Batch Processing in Field Arithmetic

### Batch Field Addition

Multiple additions processed together:

```
Individual:
for i in 0..n:
    c[i] = field_add(a[i], b[i])

Batched with SIMD:
for i in 0..n step SIMD_WIDTH:
    c[i:i+SIMD_WIDTH] = simd_field_add(a[i:i+SIMD_WIDTH], b[i:i+SIMD_WIDTH])

Batch benefits:
- SIMD utilization
- Loop overhead amortization
- Cache efficiency
```

### Batch Field Multiplication

Multiple multiplications with shared reduction:

```
Montgomery batch multiplication:
1. Compute all extended products (parallel)
2. Reduce all products (parallel)

Batch enables:
- Interleaved computation hiding latency
- Shared twiddle factor computation
- Optimized memory access patterns
```

### Batch Modular Inverse

Multiple inversions using Montgomery's trick:

```
Given: [a_0, a_1, ..., a_n] to invert

Step 1: Compute running products
products[0] = a_0
products[1] = a_0 * a_1
products[2] = a_0 * a_1 * a_2
...
products[n] = a_0 * a_1 * ... * a_n

Step 2: Single inversion
inv_all = products[n]^(-1)

Step 3: Recover individual inverses
inv[n] = inv_all * products[n-1]
inv[n-1] = inv_all * a_n * products[n-2]
...

Cost: 3n multiplications + 1 inversion
vs: n inversions individually

Speedup: ~50x (inversion much costlier than multiplication)
```

## Batch Processing in Polynomial Operations

### Batch NTT

Multiple NTTs processed together:

```
Individual NTTs:
for poly in polynomials:
    ntt(poly)

Batched approach 1 - Interleaved:
[poly0_coeff0, poly1_coeff0, poly2_coeff0, ...]
[poly0_coeff1, poly1_coeff1, poly2_coeff1, ...]
...
Process all polynomials in each butterfly stage

Batched approach 2 - Parallel:
Assign different polynomials to different threads
Share twiddle factors

Benefits:
- Twiddle factor reuse
- Better cache utilization
- GPU-friendly structure
```

### Batch Polynomial Evaluation

Evaluate polynomial at multiple points:

```
P(x) at points [x_0, x_1, ..., x_m]

Batched Horner's method:
result = [0, 0, 0, ...0]  // m results
for coeff in reversed(P.coefficients):
    result = result * [x_0, x_1, ...x_m] + coeff

SIMD processes multiple evaluation points per iteration.
```

### Batch Polynomial Commitment

Commit to multiple polynomials:

```
Merkle tree commitment:
1. Evaluate all polynomials on domain (batch NTT)
2. Hash leaves (batch hashing)
3. Build tree (level-by-level batching)

Each phase processes all polynomials together.
```

## Batch Processing in Hash Functions

### Batch Merkle Hashing

Constructing Merkle trees efficiently:

```
Leaves: [h_0, h_1, h_2, h_3, h_4, h_5, h_6, h_7]
         \  /      \  /      \  /      \  /
Level 1: [h_01]   [h_23]   [h_45]   [h_67]   <- 4 hashes in batch
           \      /           \      /
Level 2:  [h_0123]           [h_4567]        <- 2 hashes in batch
                \            /
Root:           [h_01234567]                 <- 1 hash

Process each level as a batch:
- Load all inputs for level
- Hash in parallel
- Store all outputs
```

### Multi-Message Hashing

Hash multiple messages simultaneously:

```
Messages: [m_0, m_1, m_2, m_3]

Parallel hashing:
- Initialize 4 hash states
- Process blocks from all messages in lockstep
- Finalize all states

SIMD implementation:
- State variables become vectors
- Single instruction updates all states
```

### Incremental Hashing with Batching

Accumulate data then hash in batches:

```
Incremental pattern:
buffer = empty
for data_chunk in stream:
    buffer.append(data_chunk)
    if buffer.size >= batch_threshold:
        batch_hash(buffer)
        buffer = empty
```

## Performance Analysis

### Speedup Model

Theoretical batch processing speedup:

```
T_individual = n * (O + W)
T_batch = O + n * W + B

O = overhead per operation (amortized in batch)
W = work per operation
B = batch coordination overhead
n = number of operations

Speedup = T_individual / T_batch
        = n * (O + W) / (O + n * W + B)

For large n:
Speedup approaches (O + W) / W = 1 + O/W
```

### Diminishing Returns

Batch size beyond optimal provides no benefit:

```
Speedup vs. batch size:
                                    ___________
                              _____/
                         ____/
                    ____/
               ____/
          ____/
     ____/
____/
|_____|_____|_____|_____|_____|
   16    64   256  1024  4096

Optimal batch size depends on:
- Cache sizes (L1, L2, L3)
- Memory bandwidth
- Parallelism available
```

### Profiling Batch Efficiency

Measuring batch benefits:

```
Metrics:
- Throughput: operations per second
- Latency: time for single operation
- Cache hit rate: improved with batching
- Memory bandwidth utilization

Compare:
- Individual processing baseline
- Various batch sizes
- Identify optimal batch size
```

## Key Concepts

- **Batch**: Collection of similar items processed together
- **Amortization**: Spreading fixed costs across multiple items
- **Montgomery's trick**: Batch inversion using products
- **SoA layout**: Structure of Arrays for efficient batch access
- **Streaming batch**: Continuous processing with rolling windows
- **Hierarchical batching**: Multi-level batch organization

## Design Trade-offs

### Batch Size vs. Latency

| Batch Size | Throughput | Latency | Memory |
|------------|------------|---------|--------|
| Small (16-64) | Lower | Low | Low |
| Medium (256-1024) | Good | Moderate | Moderate |
| Large (4K-16K) | Highest | High | High |

### Memory vs. Computation

| Strategy | Memory Use | Computation | Best For |
|----------|------------|-------------|----------|
| Compute each item | Minimal | More total | Memory-limited |
| Materialize batch | More | Less total | Compute-limited |
| Streaming | Bounded | Balanced | Continuous data |

### Complexity vs. Performance

| Approach | Implementation | Performance | Maintenance |
|----------|----------------|-------------|-------------|
| Simple loops | Easy | Baseline | Easy |
| Basic batching | Moderate | 2-3x | Moderate |
| Optimized batching | Complex | 5-10x | Difficult |

## Related Topics

- [SIMD Vectorization](../01-cpu-optimization/01-simd-vectorization.md) - Batch processing with SIMD
- [Multi-Threading](../01-cpu-optimization/02-multi-threading.md) - Parallel batch processing
- [GPU Kernel Design](../02-gpu-acceleration/02-kernel-design.md) - GPU batch processing
- [Lookup Tables](02-lookup-tables.md) - Batched table lookups
- [NTT and FFT](../../01-mathematical-foundations/02-polynomials/02-ntt-and-fft.md) - Batch polynomial operations
