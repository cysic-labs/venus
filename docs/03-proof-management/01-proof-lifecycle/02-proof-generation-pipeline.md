# Proof Generation Pipeline

## Overview

The proof generation pipeline transforms a validated proof request into a cryptographically verifiable proof. This multi-stage process encompasses program execution, witness generation, polynomial encoding, constraint evaluation, FRI commitment, and proof serialization. Each stage has distinct computational characteristics, memory requirements, and parallelization opportunities.

Understanding the pipeline structure enables optimization at multiple levels: algorithmic improvements within stages, data flow optimization between stages, and resource allocation across the complete process. The pipeline design also determines how the system handles failures, checkpoints progress, and recovers from interruptions.

This document describes the pipeline stages, their interdependencies, performance characteristics, and design considerations for efficient implementation.

## Pipeline Stages

### Stage Overview

The complete proving pipeline:

```
┌─────────────────────────────────────────────────────────────┐
│                    PROOF GENERATION PIPELINE                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Request → Execution → Witness → Encoding → Composition     │
│              ↓          Gen        ↓           ↓           │
│           Trace       Aux Cols   Polynomials  Quotient     │
│                          ↓                       ↓          │
│                       Merkle  ←  Commit   ←   Combine       │
│                          ↓                                  │
│                        FRI    →   Query   →   Serialize     │
│                          ↓          ↓           ↓          │
│                       Layers    Openings    Final Proof    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Stage 1: Program Execution

Execute the program to generate raw trace:

```
Input:
  - Program binary
  - Public and private inputs

Process:
  1. Load program into emulator
  2. Initialize state from inputs
  3. Execute instructions sequentially
  4. Record state at each cycle
  5. Capture memory operations
  6. Detect termination

Output:
  - Raw execution trace
  - Memory access log
  - Final state

Characteristics:
  - Sequential (inherently)
  - Memory proportional to trace length
  - Time proportional to step count
```

### Stage 2: Witness Generation

Transform raw trace into witness format:

```
Input:
  - Raw execution trace
  - Memory access log
  - Constraint system specification

Process:
  1. Organize trace into columns
  2. Compute auxiliary columns
  3. Generate range check decompositions
  4. Sort memory for consistency arguments
  5. Compute lookup multiplicities
  6. Pad to power-of-two length

Output:
  - Structured witness (all columns)
  - Ready for polynomial encoding

Characteristics:
  - Partially parallelizable (columns independent)
  - Memory-intensive (all columns in memory)
  - Some columns depend on others (auxiliary)
```

### Stage 3: Polynomial Encoding

Convert witness columns to polynomials:

```
Input:
  - Witness columns

Process:
  1. For each column:
     a. Interpolate to polynomial (inverse NTT)
     b. Evaluate on extended domain (NTT)
  2. Organize evaluations for commitment

Output:
  - Polynomial evaluations on extended domain
  - Ready for Merkle commitment

Characteristics:
  - Highly parallelizable (columns independent)
  - NTT-dominated computation
  - Memory: O(blowup * trace_size * column_count)
```

### Stage 4: Trace Commitment

Commit to trace polynomials:

```
Input:
  - Extended evaluations

Process:
  1. Hash evaluations into leaves
  2. Build Merkle tree
  3. Extract root as commitment

Output:
  - Trace commitment (Merkle root)
  - Merkle tree stored for later queries

Characteristics:
  - Hash-dominated
  - Memory for tree proportional to domain size
  - Parallelizable tree construction
```

### Stage 5: Challenge Derivation

Generate Fiat-Shamir challenges:

```
Input:
  - Transcript state
  - Trace commitment

Process:
  1. Absorb trace commitment into transcript
  2. Squeeze challenge(s) for constraint composition

Output:
  - Alpha (and other challenges as needed)
  - Updated transcript state

Characteristics:
  - Fast (just hashing)
  - Sequential (transcript is ordered)
```

### Stage 6: Constraint Evaluation

Evaluate constraints on extended domain:

```
Input:
  - Extended trace evaluations
  - Composition challenges

Process:
  1. For each evaluation point:
     a. Gather trace values at point
     b. Evaluate all constraints
     c. Combine with alpha weights
  2. Divide by vanishing polynomial

Output:
  - Quotient polynomial evaluations

Characteristics:
  - Highly parallelizable (points independent)
  - Compute-intensive per point
  - Memory access patterns important
```

### Stage 7: Quotient Commitment

Commit to quotient polynomial:

```
Input:
  - Quotient evaluations

Process:
  1. Possibly split quotient if high degree
  2. Build Merkle tree over evaluations
  3. Extract commitment

Output:
  - Quotient commitment(s)

Characteristics:
  - Similar to trace commitment
  - May have multiple parts if quotient split
```

### Stage 8: FRI Protocol

Prove quotient polynomial degree:

```
Input:
  - Quotient polynomial (coefficients or evaluations)
  - FRI challenges (from transcript)

Process:
  For each FRI layer:
    1. Fold polynomial with challenge
    2. Commit to folded evaluations
    3. Update transcript for next challenge

Output:
  - FRI layer commitments
  - Final polynomial

Characteristics:
  - Iterative (layers sequential)
  - Each layer parallelizable internally
  - Memory halves each layer
```

### Stage 9: Query Phase

Open commitments at query positions:

```
Input:
  - All Merkle trees (trace, quotient, FRI)
  - Query positions (from transcript)

Process:
  For each query:
    1. Retrieve evaluations at query point
    2. Generate Merkle authentication paths

Output:
  - Query responses (values + paths)

Characteristics:
  - Parallelizable across queries
  - Random access to Merkle trees
  - I/O can be bottleneck
```

### Stage 10: Proof Serialization

Assemble final proof:

```
Input:
  - All commitments
  - Query responses
  - Final polynomial

Process:
  1. Serialize in specified format
  2. Apply any compression
  3. Compute proof checksum

Output:
  - Complete proof bytes

Characteristics:
  - Sequential (serialization order matters)
  - Compression may be compute-intensive
  - Final proof size is key metric
```

## Data Flow

### Between Stages

Data dependencies between stages:

```
Execution -> Witness: Raw trace becomes structured columns
Witness -> Encoding: Columns become polynomials
Encoding -> Commitment: Evaluations become Merkle tree
Commitment -> Challenges: Root influences random values
Challenges -> Constraint Eval: Alphas determine combination
Constraint Eval -> Quotient: Quotient polynomial formed
Quotient -> FRI: Degree bound proved
FRI -> Queries: Commitments opened
Queries -> Serialization: All data assembled
```

### Memory Considerations

Peak memory usage by stage:

```
Stage              | Memory Usage
-------------------|------------------
Execution          | O(trace_length) for state history
Witness Gen        | O(columns * trace_length)
Polynomial Encode  | O(columns * blowup * trace_length)
Merkle Trees       | O(blowup * trace_length)
FRI                | Decreasing each layer

Peak typically at polynomial encoding / commitment phase.
```

### Streaming Opportunities

Where streaming can reduce memory:

```
Execution: Stream trace to disk, process in chunks
Witness Gen: Compute auxiliary columns on-the-fly
Encoding: Process columns independently
Commitment: Build tree in streaming fashion
FRI: Each layer processes independently

Full streaming reduces memory from O(n) to O(sqrt(n)) or O(log n).
```

## Parallelization

### Within-Stage Parallelism

Parallel opportunities in each stage:

```
Execution: Minimal (inherently sequential)
Witness Gen: Parallel across columns
Encoding: Parallel NTTs (columns and within NTT)
Commitment: Parallel tree layers
Constraint Eval: Parallel across evaluation points
FRI: Parallel within layers, sequential across
Queries: Parallel across query positions
```

### GPU Acceleration Points

Where GPUs help most:

```
NTT/INTT: Highly parallel, regular memory access
Hash computation: Parallel for independent hashes
Constraint evaluation: Many identical operations
FRI folding: Parallel across points

GPU less effective for:
- Execution (control-dependent, sequential)
- Merkle path generation (random access)
- Serialization (sequential)
```

### Multi-Worker Distribution

Splitting across workers:

```
Approach 1: Stage parallelism
  - Different workers handle different stages
  - Pipelined execution for multiple proofs

Approach 2: Data parallelism
  - Same stage across workers
  - Each handles portion of data

Approach 3: Proof parallelism
  - Each worker handles complete proofs
  - Simpler but coarser granularity
```

## Error Handling

### Stage Failures

Types of failures by stage:

```
Execution failures:
  - Illegal instruction
  - Invalid memory access
  - Infinite loop (step limit)
  - Assertion failure

Witness generation failures:
  - Constraint violation detected
  - Invalid decomposition
  - Sorting failure

Proving failures:
  - Memory exhaustion
  - Numerical error
  - Timeout
```

### Recovery Strategies

How to handle failures:

```
Fail-fast: Detect errors early, fail immediately
  - Check constraints during witness generation
  - Validate intermediate results

Checkpointing: Save intermediate state
  - Checkpoint after major stages
  - Resume from last checkpoint on failure

Retry: Automatic retry for transient failures
  - Worker crashes
  - Temporary resource exhaustion
```

### Checkpointing

What to checkpoint:

```
After execution:
  - Complete raw trace
  - Memory state

After witness generation:
  - All witness columns

After encoding:
  - Extended evaluations

After commitments:
  - Merkle roots and trees
  - Transcript state

Checkpoints enable resume without re-executing.
```

## Pipeline Configuration

### Parameter Selection

Configurable pipeline parameters:

```
Execution:
  - Step limit
  - Memory limit
  - Timeout

Witness generation:
  - Validation level
  - Parallelism

Encoding:
  - Blowup factor
  - NTT algorithm

FRI:
  - Number of queries
  - Folding factor
  - Final polynomial degree

Commitment:
  - Hash function
  - Leaf batch size
```

### Resource Allocation

Allocating resources across stages:

```
CPU cores:
  - Reserve cores for parallel stages
  - Balance between throughput and latency

Memory:
  - Budget per stage
  - Release memory between stages

GPU:
  - Schedule GPU-intensive stages
  - Manage GPU memory
```

## Performance Profiling

### Timing Breakdown

Typical time distribution:

```
Stage              | Typical %
-------------------|----------
Execution          | 5-20%
Witness Gen        | 10-20%
Polynomial Encode  | 20-30%
Constraint Eval    | 10-20%
FRI                | 20-40%
Queries/Serialize  | 5-10%
```

### Bottleneck Identification

Finding performance bottlenecks:

```
Metrics per stage:
  - Wall clock time
  - CPU utilization
  - Memory bandwidth utilization
  - I/O wait time

Common bottlenecks:
  - NTT for large traces (memory bandwidth)
  - Hash computation (CPU)
  - Memory allocation (system)
  - Disk I/O (for large proofs)
```

### Optimization Priorities

Where to focus optimization:

```
1. NTT/FFT (largest compute component)
   - Algorithm selection
   - Cache optimization
   - GPU offload

2. Hash computation (Merkle trees + FRI)
   - Fast hash function
   - Parallel hashing
   - Batching

3. Memory management
   - Reduce allocations
   - Improve locality
   - Enable streaming
```

## Key Concepts

- **Pipeline**: Multi-stage transformation from request to proof
- **Data flow**: Dependencies and data passing between stages
- **Parallelism**: Opportunities for parallel execution
- **Checkpointing**: Saving state for recovery
- **Bottleneck**: Stage limiting overall performance

## Design Considerations

### Latency vs. Throughput

| Optimize Latency | Optimize Throughput |
|------------------|---------------------|
| Parallelize within proof | Pipeline across proofs |
| Minimize stage handoff | Batch stage processing |
| Keep data in memory | Stream to disk |
| Larger resource per proof | More proofs in parallel |

### Flexibility vs. Performance

| Flexible Design | Optimized Design |
|-----------------|------------------|
| Configurable stages | Hardcoded pipeline |
| General constraints | Specialized circuits |
| Multiple backends | Single optimized path |
| Easier development | Higher performance |

## Related Topics

- [Proof Request Handling](01-proof-request-handling.md) - Request entry point
- [Proof Delivery](03-proof-delivery.md) - Returning completed proofs
- [Witness Generation](../../02-stark-proving-system/04-proof-generation/01-witness-generation.md) - Witness stage details
- [FRI Fundamentals](../../02-stark-proving-system/03-fri-protocol/01-fri-fundamentals.md) - FRI stage details
