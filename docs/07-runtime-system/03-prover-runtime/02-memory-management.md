# Memory Management

## Overview

Memory management is critical for zkVM proving performance, as proof generation involves processing large amounts of data. Execution traces can span gigabytes, polynomials must be stored in multiple representations, and intermediate computations require substantial working memory. Poor memory management leads to cache misses, swapping, and failed proofs due to out-of-memory conditions.

Effective memory management involves understanding data sizes, planning memory layout, minimizing allocations, and streaming data when possible. The prover must balance keeping data in memory for speed against the reality of finite resources. This document covers memory requirements, allocation strategies, and optimization techniques for memory-efficient proving.

## Memory Requirements

### Trace Memory

Storage for execution trace:

```
Trace dimensions:
  Rows: N (typically 2^20 to 2^26)
  Columns: M (typically 50-200)

Per-element:
  Field element: 8-32 bytes
  Typical: 8 bytes (64-bit)

Total trace memory:
  N * M * 8 bytes

Examples:
  2^20 rows, 100 columns: ~800 MB
  2^24 rows, 100 columns: ~13 GB
  2^26 rows, 100 columns: ~53 GB
```

### Polynomial Memory

Polynomial representations:

```
Coefficient form:
  N coefficients per polynomial
  Same size as one trace column

Evaluation form:
  N or N*blowup evaluations
  Larger with extension

Multiple representations:
  May need both forms simultaneously
  Double memory during conversion

Total:
  Columns * (1 + blowup) * N * element_size
```

### Working Memory

Intermediate computations:

```
FFT workspace:
  Additional arrays for in-place FFT
  Or temporary arrays for out-of-place

Merkle trees:
  Interior nodes: ~2N hashes
  Hash size: 32 bytes typical

Constraint evaluation:
  Temporary storage for evaluations
  Combined composition polynomial

FRI layers:
  Decreasing size each round
  Total ~2N elements
```

## Allocation Strategies

### Pre-allocation

Allocating memory upfront:

```
Benefits:
  Avoid allocation during proving
  Predictable memory usage
  Fail early if insufficient

Strategy:
  Calculate total memory needed
  Allocate large buffers at start
  Sub-allocate from buffers

Example:
  size_t trace_size = N * M * sizeof(FieldElement);
  void* trace_buffer = malloc(trace_size);
  if (!trace_buffer) {
    fail("Insufficient memory for trace");
  }
```

### Pool Allocation

Reusable memory pools:

```
Pool concept:
  Pre-allocate blocks of memory
  Hand out from pool, return to pool
  Avoid malloc/free overhead

Implementation:
  Fixed-size pools for common sizes
  Variable-size pool with free list

Usage:
  FieldElement* get_temp_array(size_t n) {
    return pool.allocate(n * sizeof(FieldElement));
  }

  void release_temp_array(FieldElement* ptr) {
    pool.deallocate(ptr);
  }
```

### Arena Allocation

Phase-based memory:

```
Arena concept:
  Allocate from arena
  Free entire arena at once
  No individual frees

Phases:
  Arena for trace generation
  Arena for commitment phase
  Arena for FRI phase

Benefits:
  Very fast allocation
  No fragmentation within phase
  Simple cleanup
```

## Data Layout

### Column-Major vs Row-Major

Organizing trace in memory:

```
Row-major:
  row0: [col0, col1, col2, ...]
  row1: [col0, col1, col2, ...]
  Good for: Row-wise access

Column-major:
  col0: [row0, row1, row2, ...]
  col1: [row0, row1, row2, ...]
  Good for: FFT on columns, constraint evaluation

Choice:
  Column-major preferred for proving
  FFT operates on columns
  Constraint evaluation sweeps columns
```

### Cache-Friendly Layout

Optimizing for cache:

```
Cache line:
  64 bytes typically
  8 field elements (8 bytes each)

Access patterns:
  Sequential access: Good cache utilization
  Strided access: Cache misses

Optimization:
  Process data in cache-line units
  Prefetch next data during processing
  Avoid random access when possible
```

### NUMA Awareness

Multi-socket memory:

```
NUMA architecture:
  Memory local to each CPU socket
  Remote memory access slower

Awareness:
  Allocate on socket that will use data
  Pin threads to CPUs near their data

Implementation:
  Use numa_alloc_onnode()
  Set thread affinity
```

## Memory Optimization

### In-Place Operations

Avoiding extra copies:

```
In-place FFT:
  Overwrites input with output
  No additional array needed

In-place operations:
  Many polynomial ops can be in-place
  Careful with aliasing

Example:
  // In-place FFT
  void fft_in_place(FieldElement* data, size_t n);

  // Avoid this:
  FieldElement* temp = malloc(n * sizeof(FieldElement));
  fft(data, temp, n);
  memcpy(data, temp, n * sizeof(FieldElement));
  free(temp);
```

### Streaming Processing

Processing without full storage:

```
Concept:
  Process data as it arrives
  Don't store entire dataset

Applicable to:
  Merkle tree construction (level by level)
  Constraint evaluation (row by row)
  Some hash computations

Example:
  for each row:
    evaluate constraints
    accumulate to composition
  // Never store full constraint evaluations
```

### Memory Reuse

Using same memory for different purposes:

```
Sequential phases:
  Phase 1: Use buffer for trace
  Phase 2: Repurpose for polynomials
  Phase 3: Repurpose for FRI

Implementation:
  Union of buffers
  Or explicit reallocation

Caution:
  Clear sensitive data
  Verify no overlap in usage
```

## Large Trace Handling

### Segmentation

Breaking trace into segments:

```
Approach:
  Divide N-row trace into K segments
  Each segment: N/K rows

Processing:
  Prove each segment
  Aggregate segment proofs

Memory per segment:
  (N/K) * M * element_size
  Much smaller than full trace
```

### Out-of-Core Processing

Using disk for excess data:

```
Concept:
  Keep working set in memory
  Swap other data to disk

Implementation:
  Memory-mapped files
  Explicit read/write

Trade-off:
  Enables larger traces
  Much slower than in-memory
```

### Compressed Storage

Reducing memory footprint:

```
Techniques:
  Compress cold data
  Store differences instead of absolutes
  Use smaller representations when possible

Example:
  Store trace in compressed form
  Decompress segment when processing
  Compress result and proceed
```

## Monitoring and Debugging

### Memory Tracking

Monitoring usage:

```
Metrics:
  Peak memory usage
  Current allocation
  Fragmentation

Tools:
  Memory profilers (Valgrind, Heaptrack)
  Custom allocation tracking

Logging:
  Log major allocations
  Track phase-by-phase usage
```

### Leak Detection

Finding memory leaks:

```
Symptoms:
  Growing memory over time
  OOM on long-running provers

Detection:
  Use Valgrind or ASan
  Track allocation/deallocation counts

Prevention:
  RAII in C++
  Scope-based arena allocation
  Clear ownership rules
```

## Key Concepts

- **Trace memory**: Storage for execution trace
- **Pre-allocation**: Allocating memory upfront
- **Pool allocation**: Reusable memory pools
- **In-place operations**: Avoiding extra copies
- **Segmentation**: Breaking large data into pieces

## Design Considerations

### Memory Strategy

| Pre-allocate | Dynamic |
|--------------|---------|
| Predictable | Flexible |
| Fail early | Fail late |
| May waste | Efficient use |
| Fast allocation | Allocation overhead |

### Data Layout

| Row-Major | Column-Major |
|-----------|--------------|
| Row access fast | Column access fast |
| Random column slow | Random row slow |
| Intuitive | Better for FFT |
| Witness gen friendly | Proving friendly |

## Related Topics

- [Proof Generation Pipeline](01-proof-generation-pipeline.md) - Pipeline context
- [Parallel Execution](../02-execution-engine/03-parallel-execution.md) - Threading and memory
- [Execution Trace Generation](../01-witness-generation/01-execution-trace-generation.md) - Trace creation
- [Hardware Acceleration](../../10-performance-optimization/02-hardware-acceleration/01-gpu-proving.md) - GPU memory
