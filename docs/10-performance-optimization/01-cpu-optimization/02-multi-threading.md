# Multi-Threading Strategies

## Overview

Multi-threading enables concurrent execution across multiple CPU cores, dramatically reducing wall-clock time for parallelizable workloads. In zero-knowledge proof systems, where computation can span hours for large programs, effective multi-threading transforms impractical proving times into feasible ones.

Modern CPUs contain 8 to 128 cores, representing massive latent parallelism. However, realizing this parallelism requires careful algorithm design, synchronization management, and workload distribution. Proof generation naturally decomposes into parallel tasks, but achieving linear speedup with core count demands attention to thread coordination overhead, memory contention, and load balancing.

This document explores multi-threading concepts, patterns, and design considerations for zkVM performance optimization.

## Threading Fundamentals

### Threads vs. Processes

**Threads** share memory space within a process:
- Lower overhead for creation and switching
- Easy data sharing through shared memory
- Require synchronization to avoid data races

**Processes** have isolated memory:
- Stronger isolation and fault tolerance
- Higher communication overhead
- No shared-memory synchronization needed

For zkVM proving, threads are typically preferred for fine-grained parallelism, while processes suit coarse-grained workload distribution.

### Thread Lifecycle

```
Creation -> Ready -> Running -> Blocked -> Running -> Terminated
                        ^                      |
                        |______________________|
```

Thread states:
- **Ready**: Waiting for CPU time
- **Running**: Actively executing
- **Blocked**: Waiting for synchronization or I/O
- **Terminated**: Execution complete

### Hardware Threads vs. Software Threads

**Physical cores**: Actual execution units
**Hardware threads (SMT)**: Multiple thread contexts per core (e.g., Intel Hyper-Threading)
**Software threads**: Operating system scheduling entities

Optimal thread count depends on workload characteristics:
- Compute-bound: 1 thread per physical core
- Memory-bound: May benefit from SMT
- Mixed: Requires profiling to optimize

## Parallelism Patterns

### Data Parallelism

Same operation applied to different data elements:

```
Sequential:                   Parallel:
for i in 0..n:               parallel_for i in 0..n:
    result[i] = f(data[i])       result[i] = f(data[i])
```

Data parallelism is ideal when:
- No dependencies between iterations
- Uniform computation per element
- Data access patterns are regular

Examples in zkVMs:
- Polynomial evaluation at multiple points
- Independent constraint checking
- Merkle tree leaf hashing

### Task Parallelism

Different operations execute concurrently:

```
Sequential:                   Parallel:
a = task_a()                 spawn task_a -> future_a
b = task_b()                 spawn task_b -> future_b
c = combine(a, b)            a = await future_a
                             b = await future_b
                             c = combine(a, b)
```

Task parallelism suits:
- Independent computational stages
- Different algorithms on shared data
- Producer-consumer relationships

Examples in zkVMs:
- Parallel state machine proving
- Concurrent commitment computation
- Overlapped I/O and computation

### Pipeline Parallelism

Stages process different items concurrently:

```
Stage 1: [Item 4] -> [Item 3] -> [Item 2] -> [Item 1] -> Output
            ^
         Input

Time 1: Stage 1 processes Item 1
Time 2: Stage 1 processes Item 2, Stage 2 processes Item 1
Time 3: Stage 1 processes Item 3, Stage 2 processes Item 2, Stage 3 processes Item 1
```

Pipeline parallelism suits:
- Multi-stage transformations
- Streaming data processing
- When stages have similar costs

## Synchronization Mechanisms

### Mutexes

Mutexes provide mutual exclusion for shared data:

```
Critical Section Pattern:
    acquire(mutex)
    // Only one thread executes here at a time
    modify(shared_data)
    release(mutex)
```

Mutex considerations:
- **Lock contention**: Threads waiting reduce parallelism
- **Granularity**: Fine-grained locks reduce contention but increase complexity
- **Deadlocks**: Circular lock dependencies cause hangs

### Atomic Operations

Hardware-supported indivisible operations:

```
atomic_increment(counter)  // No lock needed
atomic_compare_swap(ptr, expected, new)  // Conditional update
```

Atomics are efficient for:
- Counters and accumulators
- Lock-free data structures
- Simple synchronization flags

Limitations:
- Limited to simple operations
- Memory ordering considerations
- Still cause cache contention

### Barriers

Synchronization points where all threads must arrive:

```
Thread 0: work_phase_1(); barrier.wait(); work_phase_2()
Thread 1: work_phase_1(); barrier.wait(); work_phase_2()
Thread 2: work_phase_1(); barrier.wait(); work_phase_2()
                            ^
                    All threads synchronize here
```

Barriers suit:
- Iterative algorithms with phases
- Ensuring all threads complete before proceeding
- Fork-join parallelism

### Condition Variables

Allow threads to wait for specific conditions:

```
Producer:                     Consumer:
    lock(mutex)                  lock(mutex)
    produce(item)                while (queue.empty()):
    signal(condition)                wait(condition, mutex)
    unlock(mutex)                item = consume()
                                 unlock(mutex)
```

Used for:
- Producer-consumer patterns
- Work queues
- Event-driven coordination

## Work Distribution Strategies

### Static Partitioning

Divide work evenly at start:

```
Thread 0: items[0 .. n/4]
Thread 1: items[n/4 .. n/2]
Thread 2: items[n/2 .. 3n/4]
Thread 3: items[3n/4 .. n]
```

Advantages:
- Zero runtime coordination overhead
- Predictable memory access patterns
- Optimal for uniform work items

Disadvantages:
- Poor load balance with variable work items
- Cannot adapt to dynamic conditions

### Dynamic Scheduling

Threads claim work from shared pool:

```
Work Queue: [Task 1, Task 2, Task 3, ..., Task N]

Thread 0: claim Task 1, execute, claim Task 4, ...
Thread 1: claim Task 2, execute, claim Task 5, ...
Thread 2: claim Task 3, execute, claim Task 6, ...
```

Advantages:
- Automatic load balancing
- Handles variable task sizes
- Adapts to heterogeneous cores

Disadvantages:
- Queue access overhead
- Cache locality disruption
- Potential contention on queue

### Work Stealing

Threads steal from others when idle:

```
Thread 0: [own queue: Task A, Task B]
Thread 1: [own queue: empty] -> steals Task B from Thread 0
```

Combines benefits of static and dynamic:
- Local work has low overhead
- Stealing handles imbalance
- Good cache behavior for local work

### Guided Self-Scheduling

Decreasing chunk sizes over time:

```
Early: Thread 0 takes 25% of remaining
       Thread 1 takes 25% of remaining (now smaller)
Later: Threads take small fixed chunks
```

Balances:
- Low overhead for bulk work
- Fine balancing near completion

## Memory Considerations

### False Sharing

Different threads access adjacent cache lines:

```
Cache Line (64 bytes):
[counter_0, counter_1, counter_2, counter_3]
   ^            ^
Thread 0     Thread 1

Even though accessing different data, cache line bounces between cores.
```

Solutions:
- Padding between per-thread data
- Aligning per-thread structures to cache lines
- Using thread-local storage

### NUMA Awareness

Non-Uniform Memory Access architectures:

```
Node 0: [CPUs 0-15] <-> [Local Memory 0]
                             |
                    Interconnect (slower)
                             |
Node 1: [CPUs 16-31] <-> [Local Memory 1]
```

Strategies:
- Allocate memory near computing threads
- Pin threads to NUMA nodes
- Partition work by NUMA topology

### Memory Allocation

Thread-safe allocation considerations:

**Global allocator contention**: Multiple threads competing for heap
**Thread-local pools**: Per-thread allocation reduces contention
**Arena allocation**: Pre-allocate large regions

For zkVM proving:
- Pre-allocate trace buffers
- Use per-thread scratch space
- Minimize dynamic allocation in hot loops

## Thread Pool Patterns

### Basic Thread Pool

Fixed number of worker threads processing a task queue:

```
Task Queue -> [Worker 0] [Worker 1] [Worker 2] [Worker 3]
                 |          |          |          |
                 v          v          v          v
              Results accumulated
```

Components:
- Task queue (thread-safe)
- Worker threads (persistent)
- Synchronization for completion

### Fork-Join Pattern

Recursive parallel decomposition:

```
        [Main Task]
       /     |     \
   [Sub 1] [Sub 2] [Sub 3]
   /    \
[A]    [B]
   \    /
   [Join]
      |
   [Join All]
```

Particularly suited for:
- Divide-and-conquer algorithms
- Tree-structured computations
- Recursive parallelism

### Asynchronous Task Graphs

Express dependencies between tasks:

```
    [Task A]    [Task B]
         \      /
          v    v
         [Task C]
             |
             v
         [Task D]
```

Scheduler executes tasks when dependencies satisfied:
- Maximum parallelism automatically extracted
- Handles complex dependency structures
- Runtime adapts to available resources

## Parallel Algorithms in zkVMs

### Parallel NTT

Number Theoretic Transform parallelizes at multiple levels:

```
Level 1: Independent butterflies within a stage
Level 2: Independent NTTs on different polynomials
Level 3: Pipelined stages with producer-consumer
```

Typical approach:
- Coarse parallelism for small NTTs (parallelize across polynomials)
- Fine parallelism for large NTTs (parallelize within)

### Parallel Merkle Trees

Tree construction parallelizes naturally:

```
Leaves:   [H0] [H1] [H2] [H3] [H4] [H5] [H6] [H7]   <- Parallel
             \  /      \  /      \  /      \  /
Layer 1:    [H01]    [H23]    [H45]    [H67]        <- Parallel
               \      /          \      /
Layer 2:      [H0123]            [H4567]            <- Parallel
                    \            /
Root:              [H01234567]                      <- Serial
```

Parallelism decreases toward root but leaves dominate cost.

### Parallel Constraint Evaluation

Constraints evaluated independently per row:

```
Row 0: Check constraint_0, constraint_1, ..., constraint_k
Row 1: Check constraint_0, constraint_1, ..., constraint_k
...
Row n: Check constraint_0, constraint_1, ..., constraint_k
```

All rows can execute in parallel, with each thread processing a chunk.

### Parallel State Machine Execution

Multiple state machine instances can prove concurrently:

```
Main SM: [proving]
Arith SM: [proving]     <- Parallel
Binary SM: [proving]    <- Parallel
Memory SM: [proving]    <- Parallel
```

Dependencies managed through coordinator.

## Performance Analysis

### Amdahl's Law

Maximum speedup limited by serial fraction:

```
Speedup = 1 / ((1 - P) + P/N)

P = parallel fraction
N = number of processors
```

Example: 95% parallel code on 32 cores:
```
Speedup = 1 / (0.05 + 0.95/32) = 1 / 0.0797 = 12.5x
```

Even with infinite cores, maximum speedup is 1/(1-P) = 20x.

### Gustafson's Law

Alternative view: scale problem size with processors:

```
Scaled Speedup = N + (1 - N) * S

N = number of processors
S = serial fraction
```

More optimistic for larger problems.

### Overhead Sources

Parallel speedup reduced by:

| Overhead Type | Description | Mitigation |
|---------------|-------------|------------|
| Thread creation | Starting threads | Thread pools |
| Synchronization | Locks, barriers | Lock-free designs |
| Load imbalance | Uneven work | Dynamic scheduling |
| Communication | Data exchange | Locality optimization |
| False sharing | Cache contention | Padding, alignment |

## Key Concepts

- **Data parallelism**: Same operation on different data
- **Task parallelism**: Different operations concurrently
- **Critical section**: Code requiring mutual exclusion
- **Race condition**: Outcome depends on thread timing
- **Deadlock**: Circular wait preventing progress
- **Load balancing**: Even work distribution across threads
- **False sharing**: Cache line contention on logically independent data
- **NUMA**: Non-Uniform Memory Access architecture

## Design Trade-offs

### Granularity Selection

| Granularity | Parallelism | Overhead | Load Balance |
|-------------|-------------|----------|--------------|
| Very fine | High | High | Good |
| Fine | Good | Moderate | Good |
| Coarse | Limited | Low | Variable |
| Very coarse | Minimal | Minimal | Poor |

Optimal granularity depends on:
- Task size relative to synchronization cost
- Variability in task execution time
- Number of available cores

### Static vs. Dynamic Scheduling

| Aspect | Static | Dynamic |
|--------|--------|---------|
| Overhead | Minimal | Per-task |
| Locality | Optimal | Variable |
| Balance | Fixed | Adaptive |
| Predictability | High | Lower |

Choose based on:
- Work item uniformity
- Performance requirements
- Predictability needs

### Thread Count Selection

General guidelines:

| Workload Type | Thread Count |
|---------------|--------------|
| CPU-bound | 1 per physical core |
| Memory-bound | 1 per physical core |
| Mixed | 1-2 per physical core |
| I/O-bound | Higher than core count |

For zkVM proving (typically CPU/memory-bound): match physical core count.

## Related Topics

- [SIMD Vectorization](01-simd-vectorization.md) - Combining SIMD with multi-threading
- [Assembly Optimization](03-assembly-optimization.md) - Low-level parallel optimizations
- [GPU Acceleration](../02-gpu-acceleration/01-cuda-architecture.md) - Alternative massive parallelism
- [Batch Processing](../03-algorithmic-optimization/01-batch-processing.md) - Structuring work for parallelism
- [Multi-Stage Proving](../../03-proof-management/01-proof-orchestration/01-multi-stage-proving.md) - Parallel proof generation
