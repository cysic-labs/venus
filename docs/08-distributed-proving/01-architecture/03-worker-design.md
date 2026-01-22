# Worker Design

## Overview

Workers are the computational engines of a distributed proving system, executing the actual proof generation operations that transform witnesses into cryptographic proofs. While the coordinator orchestrates, workers perform the mathematically intensive operations: polynomial arithmetic, FFT computations, Merkle tree construction, constraint evaluation, and FRI protocol execution.

A well-designed worker maximizes computational throughput while remaining responsive to coordinator commands. Workers must efficiently utilize available hardware—CPUs, GPUs, and memory—while handling task boundaries, intermediate state, and failure scenarios. The worker design significantly impacts system performance since workers consume the majority of cluster resources.

This document covers worker architecture, task execution models, resource management, and the optimizations that enable high-performance distributed proving. Understanding worker design is essential for building systems that fully exploit available hardware parallelism.

## Worker Responsibilities

### Task Execution

Core proving work:

```
Execution steps:
  Receive task specification
  Obtain required data
  Execute proving operations
  Generate partial proof
  Return results

Operation types:
  Witness generation
  Polynomial commitments
  Constraint evaluation
  FRI protocol steps
  Aggregation operations
```

### Resource Management

Efficient hardware utilization:

```
CPU management:
  Thread pool sizing
  NUMA-aware allocation
  Cache optimization

GPU management:
  Kernel scheduling
  Memory transfers
  Multi-GPU coordination

Memory management:
  Allocation strategies
  Buffer reuse
  Memory pressure handling
```

### Coordinator Communication

Maintaining connection:

```
Communication duties:
  Accept task assignments
  Report progress
  Send results
  Respond to status queries

Heartbeat:
  Regular liveness signal
  Resource availability updates
  Task status reports
```

### Health Reporting

Self-monitoring:

```
Health indicators:
  Resource availability
  Task queue depth
  Error rates
  Performance metrics

Reporting:
  Periodic health reports
  Alert on anomalies
  Detailed diagnostics on request
```

## Execution Models

### Synchronous Execution

Sequential task processing:

```
Pattern:
  Receive task
  Execute to completion
  Return result
  Repeat

Characteristics:
  Simple implementation
  Predictable behavior
  One task at a time

Use cases:
  Memory-constrained environments
  Simple workloads
  Debugging
```

### Asynchronous Execution

Overlapped operations:

```
Pattern:
  Multiple tasks in flight
  Overlap I/O and computation
  Return results as ready

Characteristics:
  Higher throughput
  Complex state management
  Better resource utilization

Use cases:
  I/O-bound operations
  Multi-GPU systems
  High-throughput requirements
```

### Pipeline Execution

Staged task processing:

```
Pattern:
  Task divided into stages
  Stages execute in parallel
  Assembly line processing

Example stages:
  Data fetch
  Preprocessing
  Main computation
  Result formatting
  Result transmission

Benefits:
  Continuous resource utilization
  Hidden latency
  Smooth throughput
```

## Task Lifecycle

### Task Reception

Accepting work:

```
Reception process:
  Receive task message
  Parse specification
  Validate requirements
  Queue for execution

Validation:
  Required data available
  Resources sufficient
  Task format correct

Response:
  Accept: task queued
  Reject: with reason
```

### Task Preparation

Setting up execution:

```
Preparation steps:
  Allocate resources
  Fetch required data
  Initialize state
  Prepare execution context

Data acquisition:
  From local cache
  From coordinator
  From shared storage

Optimization:
  Prefetch predictable data
  Reuse previous allocations
  Minimize setup overhead
```

### Task Execution

Performing the work:

```
Execution phases:
  Initialize computation
  Execute main algorithm
  Generate results
  Validate output

Progress tracking:
  Checkpoint creation
  Progress reporting
  Cancellation checking

Error handling:
  Catch exceptions
  Attempt recovery
  Report failures
```

### Result Delivery

Returning output:

```
Delivery process:
  Format results
  Validate completeness
  Send to coordinator
  Confirm receipt

Result types:
  Partial proofs
  Commitments
  Intermediate values
  Status information

Cleanup:
  Release resources
  Clear sensitive data
  Prepare for next task
```

## Resource Utilization

### CPU Utilization

Maximizing CPU throughput:

```
Threading strategy:
  Thread pool per core
  Work queue per thread
  Lock-free where possible

Optimization:
  SIMD utilization
  Cache-friendly access
  Branch prediction

Monitoring:
  CPU utilization percentage
  Context switch rate
  Cache miss rate
```

### GPU Utilization

Leveraging GPU acceleration:

```
GPU operations:
  FFT computations
  Polynomial arithmetic
  Hash computations
  Matrix operations

Scheduling:
  Kernel overlap
  Memory transfer hiding
  Multi-stream execution

Memory management:
  GPU memory allocation
  Host-device transfers
  Memory pools
```

### Memory Utilization

Efficient memory use:

```
Memory pools:
  Pre-allocated buffers
  Size classes
  Fast allocation

Reuse strategies:
  Buffer recycling
  Cross-task reuse
  Generation-based cleanup

Pressure handling:
  Spill to storage
  Reduce parallelism
  Request more resources
```

## Data Management

### Local Storage

Worker-local data:

```
Stored data:
  Task inputs
  Intermediate results
  Cached computation
  Checkpoints

Storage types:
  In-memory cache
  Local SSD
  RAM disk

Management:
  LRU eviction
  Size limits
  Cleanup on completion
```

### Data Fetching

Obtaining remote data:

```
Fetch sources:
  Coordinator transfer
  Shared storage
  Other workers

Strategies:
  Lazy fetch on demand
  Prefetch anticipated data
  Background loading

Optimization:
  Compression
  Delta transfers
  Caching
```

### Data Sharing

Providing data to others:

```
Share scenarios:
  Coordinator requests
  Worker-to-worker
  Storage upload

Mechanisms:
  Direct transfer
  Storage upload
  Shared memory (local)

Coordination:
  Availability signaling
  Transfer prioritization
  Bandwidth management
```

## Checkpoint and Recovery

### Checkpoint Creation

Saving progress:

```
Checkpoint contents:
  Task identifier
  Progress marker
  Intermediate state
  Partial results

Triggers:
  Time interval
  Progress milestone
  Resource pressure
  Coordinator request

Storage:
  Local file system
  Shared storage
  In-memory snapshot
```

### Recovery Process

Resuming from checkpoint:

```
Recovery steps:
  Load checkpoint
  Validate integrity
  Restore state
  Resume execution

Validation:
  Checksum verification
  State consistency
  Version compatibility

Handling:
  Valid: continue from point
  Invalid: start from beginning
  Missing: full restart
```

### Failure Scenarios

Different failure types:

```
Soft failure:
  Task error
  Recoverable exception
  Handle: retry or skip

Hard failure:
  Process crash
  Machine reboot
  Handle: checkpoint recovery

Catastrophic failure:
  Data loss
  Hardware failure
  Handle: full task restart
```

## Task Types

### Witness Generation Tasks

Creating execution witnesses:

```
Inputs:
  Program segment
  Input data
  Memory state

Operations:
  Execute instructions
  Record trace
  Generate auxiliary values

Outputs:
  Execution trace
  Memory accesses
  Side effects
```

### Commitment Tasks

Computing polynomial commitments:

```
Inputs:
  Polynomial values
  Commitment parameters

Operations:
  FFT for evaluation form
  Merkle tree construction
  Root computation

Outputs:
  Commitment root
  Merkle tree structure
  Evaluation data
```

### Constraint Evaluation Tasks

Computing quotient polynomials:

```
Inputs:
  Committed polynomials
  Challenges
  Constraint definitions

Operations:
  Constraint evaluation
  Quotient computation
  Degree reduction

Outputs:
  Quotient polynomial
  Evaluation proofs
```

### FRI Tasks

FRI protocol execution:

```
Inputs:
  Polynomial commitments
  FRI challenges
  Query indices

Operations:
  Folding steps
  Query response generation
  Merkle path extraction

Outputs:
  FRI layers
  Query responses
  Opening proofs
```

## Concurrency Management

### Thread Pool Design

Managing worker threads:

```
Pool structure:
  Fixed core threads
  Dynamic expansion
  Task queue per pool

Configuration:
  Core count based sizing
  NUMA-aware placement
  Priority levels

Management:
  Thread health monitoring
  Deadlock detection
  Stack size tuning
```

### Work Scheduling

Ordering task execution:

```
Scheduling factors:
  Task priority
  Resource requirements
  Data locality
  Dependencies

Algorithms:
  FIFO for simplicity
  Priority queue for urgency
  Work stealing for balance

Optimization:
  Batch similar tasks
  Locality-aware scheduling
  Minimize context switch
```

### Synchronization

Coordinating concurrent work:

```
Synchronization needs:
  Shared data access
  Resource allocation
  Result aggregation

Mechanisms:
  Lock-free structures
  Fine-grained locks
  Wait-free operations

Avoidance:
  Partition data
  Message passing
  Copy on write
```

## Performance Optimization

### Computation Optimization

Faster algorithms:

```
Algorithmic:
  Efficient FFT implementation
  Optimized field arithmetic
  Fast hash functions

Hardware:
  SIMD vectorization
  GPU acceleration
  Memory hierarchy awareness

Caching:
  Twiddle factors
  Frequently used values
  Previous computations
```

### Memory Optimization

Reducing memory overhead:

```
Layout:
  Contiguous allocation
  Structure of arrays
  Alignment for SIMD

Access patterns:
  Sequential access
  Prefetch hints
  Cache blocking

Reduction:
  Streaming computation
  In-place operations
  Compressed representation
```

### Communication Optimization

Faster data transfer:

```
Bandwidth:
  Large message batching
  Compression
  Zero-copy where possible

Latency:
  Pipelining requests
  Prefetching data
  Parallel transfers

Overlap:
  Computation during transfer
  Async I/O
  Double buffering
```

## Monitoring and Diagnostics

### Performance Metrics

What to measure:

```
Throughput:
  Tasks per second
  Operations per second
  Bytes processed

Latency:
  Task duration
  Operation timing
  Queue wait time

Utilization:
  CPU percentage
  GPU utilization
  Memory usage
  Network bandwidth
```

### Logging

Operational visibility:

```
Log content:
  Task lifecycle events
  Performance timings
  Error details
  Resource state

Log levels:
  Error for failures
  Warn for concerns
  Info for flow
  Debug for detail
```

### Profiling

Performance analysis:

```
Profiling types:
  CPU profiling
  Memory profiling
  GPU profiling
  I/O profiling

Tools:
  Built-in metrics
  External profilers
  Trace collection

Use cases:
  Bottleneck identification
  Optimization validation
  Regression detection
```

## Key Concepts

- **Task execution**: Processing assigned proving work
- **Resource utilization**: Efficient use of CPU, GPU, memory
- **Pipeline execution**: Staged processing for throughput
- **Checkpoint recovery**: Resuming from saved state
- **Work scheduling**: Ordering concurrent tasks
- **Performance metrics**: Measuring worker effectiveness

## Design Trade-offs

### Task Granularity

| Fine-Grained | Coarse-Grained |
|--------------|----------------|
| Better load balance | Less overhead |
| More scheduling cost | Less flexibility |
| Smaller memory per task | Larger memory per task |
| More checkpoints | Fewer checkpoints |

### Execution Model

| Synchronous | Asynchronous |
|-------------|--------------|
| Simple implementation | Complex state |
| Predictable resources | Higher throughput |
| Easy debugging | Better utilization |
| Lower concurrency | Higher concurrency |

### Resource Specialization

| Generalist Workers | Specialized Workers |
|-------------------|---------------------|
| Flexible scheduling | Optimized performance |
| Simpler infrastructure | Complex routing |
| Lower utilization | Higher utilization |
| Uniform management | Heterogeneous fleet |

## Related Topics

- [Distributed Overview](01-distributed-overview.md) - System architecture context
- [Coordinator Design](02-coordinator-design.md) - Coordinator responsibilities
- [gRPC Protocol](../03-communication/01-grpc-protocol.md) - Communication details
- [Configuration](../04-deployment/01-configuration.md) - Worker configuration
- [Scaling Strategies](../04-deployment/02-scaling-strategies.md) - Worker scaling

