# Memory Optimization

## Overview

Memory optimization is critical for zkVM prover performance. Proving large programs requires manipulating polynomials with millions of coefficients, execution traces with many columns, and intermediate values during polynomial commitment. Memory bandwidth often limits prover speed more than raw computation. Optimizing memory access patterns, reducing allocations, and managing working set size can dramatically improve proving throughput.

The prover's memory usage scales with trace size (rows × columns), polynomial degree, and proof recursion depth. For large programs, memory may exceed available RAM, requiring careful management or distributed proving. This document covers memory layout, access optimization, allocation strategies, and techniques for handling memory-constrained environments.

## Memory Profiling

### Identifying Memory Costs

Understanding memory usage:

```
Major consumers:
  Execution trace: rows × columns × field_size
  Polynomial evaluations: degree × field_size
  Merkle tree: O(n) hashes
  FRI layers: decreasing sizes

Measurement:
  Peak memory usage
  Allocation frequency
  Access patterns
  Cache miss rates
```

### Profiling Tools

Measuring memory behavior:

```
System tools:
  Memory profilers (valgrind, heaptrack)
  Peak usage tracking
  Allocation traces

Application metrics:
  Count allocations
  Track sizes
  Measure lifetimes

Cache analysis:
  Cache miss counters
  Memory bandwidth usage
  NUMA effects
```

### Memory Bottlenecks

Common memory issues:

```
Allocation overhead:
  Frequent small allocations
  Fragmentation
  Allocator contention

Bandwidth limits:
  Sequential scan faster than random
  Cache line utilization
  NUMA locality

Capacity limits:
  Working set exceeds cache
  Swapping to disk
  OOM failures
```

## Data Layout

### Array of Structures vs Structure of Arrays

Layout comparison:

```
Array of Structures (AoS):
  [{a1,b1,c1}, {a2,b2,c2}, ...]
  Good for accessing all fields of one element
  Poor for accessing one field across elements

Structure of Arrays (SoA):
  {[a1,a2,...], [b1,b2,...], [c1,c2,...]}
  Good for accessing one field across elements
  Better SIMD utilization

zkVM preference:
  SoA for trace columns
  Process one column at a time
  Better cache efficiency
```

### Column-Major vs Row-Major

Trace layout:

```
Row-major:
  [row0_col0, row0_col1, ..., row1_col0, ...]
  Good for constraint evaluation per row

Column-major:
  [row0_col0, row1_col0, ..., row0_col1, ...]
  Good for polynomial operations per column
  Better for FFT on columns

Hybrid:
  Store column-major
  Process in row-batches for constraints
  Convert as needed
```

### Alignment and Padding

Memory alignment:

```
Cache line alignment:
  Align arrays to 64-byte boundaries
  Avoid false sharing between threads

SIMD alignment:
  Align for vector operations
  32/64 byte alignment for AVX

Padding:
  Pad arrays to power-of-2 size
  Enables FFT without copying
  Wastes some memory
```

## Access Pattern Optimization

### Sequential Access

Optimizing linear scans:

```
Benefits:
  Hardware prefetching effective
  Full cache line utilization
  Predictable pattern

Implementation:
  Process columns in order
  Avoid skipping elements
  Batch similar operations

Example:
  // Good: sequential
  for i in 0..n { process(data[i]); }

  // Bad: strided
  for i in (0..n).step_by(stride) { process(data[i]); }
```

### Blocking for Cache

Tiling computations:

```
Problem:
  Large arrays don't fit in cache
  Repeated scans cause cache misses

Solution:
  Process in blocks that fit in cache
  Complete all operations on block
  Move to next block

Block size:
  Fit in L2 cache
  Typically 256KB - 1MB of data
  Experiment for optimal size
```

### Prefetching

Software prefetching:

```
Strategy:
  Prefetch data before needed
  Hide memory latency

Implementation:
  Prefetch N iterations ahead
  Use non-temporal hints for write-only

Example:
  for i in 0..n {
    prefetch(data[i + AHEAD]);
    process(data[i]);
  }
```

## Allocation Strategy

### Memory Pooling

Reusing allocations:

```
Pool design:
  Pre-allocate large buffers
  Sub-allocate from pool
  Return to pool when done

Benefits:
  Avoid allocation overhead
  Reduce fragmentation
  Predictable memory usage

Implementation:
  Free list per size class
  Bump allocator for fast path
  Fallback to system allocator
```

### Arena Allocation

Phase-based allocation:

```
Pattern:
  Allocate during phase
  Free all at phase end
  No individual frees

Implementation:
  Bump pointer allocation
  Reset pointer at phase end
  Very fast allocation

Application:
  Witness generation phase
  Polynomial construction phase
  Each FRI round
```

### Large Page Support

Using huge pages:

```
Benefits:
  Fewer TLB misses
  Better for large allocations
  Reduced page table overhead

Implementation:
  mmap with MAP_HUGETLB
  Transparent huge pages
  Explicit huge page allocation

Considerations:
  May increase memory usage
  Not always available
  Best for long-lived allocations
```

## Memory Reuse

### In-Place Operations

Avoiding extra allocations:

```
In-place FFT:
  Transform array directly
  No additional buffer

In-place arithmetic:
  a += b instead of c = a + b
  Reuse input storage

Considerations:
  May need original value later
  More complex code
  Worth for large arrays
```

### Buffer Recycling

Reusing temporary buffers:

```
Pattern:
  Operation needs temporary buffer
  After operation, buffer unused
  Next operation reuses buffer

Implementation:
  Thread-local buffer cache
  Size-indexed availability
  Grow but don't shrink
```

### Copy Elimination

Avoiding unnecessary copies:

```
View instead of copy:
  Reference existing data
  Same memory, different interpretation

Move semantics:
  Transfer ownership
  No data copying

Lazy copying:
  Copy-on-write semantics
  Only copy if modified
```

## Memory-Constrained Proving

### Streaming Prover

Processing without full trace:

```
Concept:
  Generate trace incrementally
  Process and discard
  Never hold full trace

Challenges:
  Some operations need full trace
  Random access patterns
  Complex implementation

Applicability:
  Witness generation (streamable)
  Constraint evaluation (row by row)
  Commitment (chunk by chunk)
```

### Chunked Processing

Dividing into manageable pieces:

```
Strategy:
  Split trace into chunks
  Process each chunk
  Combine results

Implementation:
  Memory-mapped files for overflow
  LRU cache for active chunks
  Parallel chunk processing

Trade-off:
  More I/O overhead
  Enables larger traces
  Complexity increase
```

### Out-of-Core Algorithms

Disk-backed computation:

```
Memory-mapped files:
  Let OS manage paging
  Transparent to algorithm
  May be slow

Explicit I/O:
  Application controls I/O
  Optimize access patterns
  More control, more complexity

Compression:
  Compress cold data
  Decompress on access
  Trade CPU for memory
```

## NUMA Considerations

### NUMA-Aware Allocation

Multi-socket memory:

```
NUMA topology:
  Multiple memory controllers
  Local vs remote memory
  Different access latencies

Allocation strategy:
  Allocate on local NUMA node
  First-touch policy
  Explicit NUMA placement

Thread binding:
  Pin threads to NUMA nodes
  Keep data and threads together
```

### NUMA Data Distribution

Distributing across nodes:

```
Partitioning:
  Divide data by NUMA node
  Each thread processes local data

Replication:
  Copy read-only data to all nodes
  Avoid cross-node reads

Trade-off:
  Memory usage vs access speed
  Depends on access patterns
```

## Key Concepts

- **Data layout**: SoA vs AoS, column-major for polynomial operations
- **Access patterns**: Sequential preferred, blocking for cache
- **Allocation strategy**: Pooling, arena allocation, huge pages
- **Memory reuse**: In-place operations, buffer recycling
- **Memory-constrained**: Streaming, chunking, out-of-core

## Design Considerations

### Memory vs Speed

| Lower Memory | Higher Speed |
|--------------|--------------|
| In-place operations | Extra buffers |
| Streaming | Full materialization |
| Compression | Direct access |
| Sequential | Random access |

### Allocation Strategy

| Pooling | Arena | System |
|---------|-------|--------|
| Reusable buffers | Phase-based | General |
| Medium overhead | Lowest overhead | Highest overhead |
| Flexible lifetime | Bulk free | Individual free |
| Fragmentation risk | No fragmentation | Fragmentation |

## Related Topics

- [Polynomial Optimization](02-polynomial-optimization.md) - Polynomial memory usage
- [Parallel Proving](04-parallel-proving.md) - Multi-threaded memory
- [Memory Management](../../07-runtime-system/03-prover-runtime/02-memory-management.md) - Runtime memory
- [GPU Proving](../02-hardware-acceleration/01-gpu-proving.md) - GPU memory

