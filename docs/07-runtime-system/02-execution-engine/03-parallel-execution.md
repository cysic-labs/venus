# Parallel Execution

## Overview

Parallel execution leverages multiple CPU cores to accelerate witness generation and proving. While the RISC-V program itself executes sequentially, many aspects of zkVM operation can be parallelized: multiple programs can be proven concurrently, trace generation can be split across segments, auxiliary computations can run in parallel, and polynomial operations benefit greatly from parallelization.

The degree of available parallelism varies across different stages of the proving pipeline. Execution is inherently sequential, but once the trace is generated, many computations become embarrassingly parallel. Understanding where parallelism helps and where it doesn't guides effective system design. This document covers parallelization opportunities, implementation strategies, and performance considerations.

## Parallelization Opportunities

### Segment Parallelism

Dividing execution into segments:

```
Concept:
  Split long execution into segments
  Process segments in parallel (partially)
  Merge results

Execution phase:
  Sequential (must execute in order)
  But can speculatively execute branches

Trace generation:
  Segment traces generated after execution
  Can parallelize auxiliary computation

Proving phase:
  Each segment proved independently
  Results aggregated/composed
```

### Program Parallelism

Multiple independent programs:

```
Batch proving:
  Multiple programs in queue
  Each assigned to different core/machine

Scheduling:
  Work-stealing for load balancing
  Priority queue for important proofs

Resource allocation:
  Memory per program
  Core allocation strategies
```

### Data Parallelism

Same operation on multiple data:

```
Polynomial evaluation:
  Evaluate polynomial at multiple points
  Each evaluation independent

FFT computation:
  Parallel butterfly operations
  Well-known parallel FFT algorithms

Hash computation:
  Multiple independent hashes
  Merkle tree levels in parallel
```

### Pipeline Parallelism

Overlapping stages:

```
Stages:
  Execution -> Trace gen -> Commitment -> Proving

Pipeline:
  While proving segment N
  Generate trace for segment N+1
  Execute segment N+2 (if speculative)

Benefits:
  Overlap computation
  Hide latencies
```

## Parallel Trace Generation

### Parallel Auxiliary Computation

Computing helper values in parallel:

```
After primary execution:
  Trace has primary columns
  Auxiliary columns needed

Parallel computation:
  Partition rows among threads
  Each thread computes aux for its rows
  No dependencies between rows

Implementation:
  parallel_for(rows, [](row) {
    row.bytes = decompose(row.value);
    row.inverse = compute_inverse(row.value);
    // ...
  });
```

### Parallel Memory Trace

Constructing memory trace in parallel:

```
Collection phase (sequential):
  Collect memory operations during execution

Sorting phase (parallel):
  Parallel merge sort by (addr, cycle)
  Each partition sorted independently
  Merge sorted partitions

Auxiliary phase (parallel):
  Compute is_first_access, addr_changed in parallel
  Each row computation independent
```

### Parallel Table Population

Building lookup tables:

```
Multiple tables:
  Range table, operation tables, etc.
  Each table built independently

Parallel construction:
  Thread 1: Build range table
  Thread 2: Build XOR table
  Thread 3: Build operation table

Join:
  Wait for all tables complete
  Proceed to lookup preparation
```

## Parallel Proving

### Parallel Polynomial Commitment

Committing to polynomials:

```
Multiple trace columns:
  Each column is a polynomial
  Commitment independent per column

Parallel commitment:
  Assign columns to threads
  Each thread commits its columns
  Collect commitments

MSM parallelization:
  Multi-scalar multiplication is parallelizable
  Use parallel curve arithmetic
```

### Parallel FFT

Fast Fourier Transform:

```
FFT structure:
  Recursive divide-and-conquer
  Butterfly operations at each level

Parallel FFT:
  Partition coefficients
  Each thread handles partition
  Synchronize at each level

Implementation:
  Use parallel FFT library
  Or custom parallel implementation
```

### Parallel Constraint Evaluation

Evaluating constraints:

```
Constraint independence:
  Each constraint evaluated independently
  At each row, multiple constraints

Row-parallel:
  Different threads evaluate different rows
  Same constraints, different data

Constraint-parallel:
  Different threads evaluate different constraints
  Same row, different constraints

Hybrid:
  Combine row and constraint parallelism
```

## Threading Models

### Thread Pool

Reusable worker threads:

```
Structure:
  Fixed number of worker threads
  Task queue
  Workers pull tasks from queue

Benefits:
  Avoid thread creation overhead
  Bounded resource usage
  Load balancing

Implementation:
  ThreadPool pool(num_cores);
  pool.submit(task1);
  pool.submit(task2);
  pool.wait_all();
```

### Work Stealing

Dynamic load balancing:

```
Concept:
  Each thread has local queue
  Idle threads steal from others

Benefits:
  Automatic load balancing
  Handles uneven work distribution

Implementation:
  Use work-stealing scheduler
  Or library (e.g., Rayon in Rust)
```

### Fork-Join

Recursive parallelism:

```
Pattern:
  Fork: Split work into subtasks
  Process subtasks (possibly in parallel)
  Join: Combine results

Example:
  def parallel_compute(data):
    if len(data) < threshold:
      return sequential_compute(data)
    left, right = split(data)
    future_left = fork(parallel_compute, left)
    result_right = parallel_compute(right)
    result_left = future_left.join()
    return combine(result_left, result_right)
```

## Synchronization

### Data Dependencies

Managing dependencies:

```
Dependency types:
  RAW: Read after write
  WAR: Write after read
  WAW: Write after write

Handling:
  Execution: Sequential (dependencies everywhere)
  Trace gen: Few dependencies after primary
  Proving: Mostly independent
```

### Synchronization Primitives

Coordinating threads:

```
Barriers:
  Wait for all threads to reach point
  Synchronize between phases

Mutexes:
  Protect shared data
  Minimize critical sections

Atomics:
  Lock-free counters and flags
  For simple coordination
```

### Avoiding Contention

Reducing synchronization overhead:

```
Partition data:
  Each thread owns its data
  No sharing, no contention

Batch updates:
  Accumulate locally
  Merge at end

Read-mostly structures:
  Multiple readers OK
  Rare writes with locking
```

## Performance Optimization

### Scaling Analysis

Understanding parallelization limits:

```
Amdahl's Law:
  Speedup = 1 / (S + P/N)
  S = sequential fraction
  P = parallel fraction (1 - S)
  N = number of processors

Example:
  If 10% sequential (S = 0.1):
  Max speedup = 10x (as N -> infinity)

Implication:
  Focus on reducing sequential fraction
```

### Granularity Tuning

Task size optimization:

```
Too fine-grained:
  High overhead
  Synchronization dominates

Too coarse-grained:
  Load imbalance
  Cores sit idle

Tuning:
  Measure with different granularities
  Find sweet spot for workload
```

### Memory Considerations

Parallel memory access:

```
Cache effects:
  False sharing (different threads, same cache line)
  Cache thrashing with large working sets

NUMA awareness:
  Access local memory when possible
  Partition data by NUMA node

Allocation:
  Pre-allocate to avoid contention
  Thread-local allocators
```

## Key Concepts

- **Segment parallelism**: Splitting execution for parallel proving
- **Data parallelism**: Same operation on multiple data
- **Pipeline parallelism**: Overlapping stages
- **Thread pool**: Reusable worker threads
- **Work stealing**: Dynamic load balancing

## Design Considerations

### Parallelism Strategy

| Coarse-Grained | Fine-Grained |
|----------------|--------------|
| Larger tasks | Smaller tasks |
| Less overhead | More overhead |
| Potential imbalance | Better balance |
| Simpler | More complex |

### Scaling Characteristics

| CPU-Bound | Memory-Bound |
|-----------|--------------|
| Scales with cores | Limited by bandwidth |
| Compute-intensive | Memory-intensive |
| Good parallelization | May not scale |
| FFT, arithmetic | Large trace access |

## Related Topics

- [Interpreter Design](01-interpreter-design.md) - Sequential execution
- [State Caching](02-state-caching.md) - Reducing redundant work
- [Distributed Proving](../../08-distributed-proving/01-distributed-architecture/01-proving-network.md) - Multi-machine parallelism
- [Hardware Acceleration](../../10-performance-optimization/02-hardware-acceleration/01-gpu-proving.md) - GPU parallelism
