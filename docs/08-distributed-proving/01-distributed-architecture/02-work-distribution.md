# Work Distribution

## Overview

Work distribution allocates proving tasks across available prover nodes to maximize throughput and minimize latency. The challenge is matching tasks to appropriate nodes while balancing load, respecting node capabilities, and handling the dynamic nature of a distributed system where nodes join, leave, and fail. Effective distribution directly impacts proving performance and cost.

Distribution strategies range from simple round-robin to sophisticated algorithms considering node capabilities, current load, data locality, and task characteristics. The right strategy depends on network size, workload patterns, and performance requirements. This document covers distribution algorithms, task decomposition, load balancing techniques, and optimization strategies.

## Distribution Strategies

### Round-Robin Distribution

Simple sequential assignment:

```
Algorithm:
  next_node = (current_node + 1) % num_nodes

Properties:
  Simple implementation
  Fair across identical nodes
  Ignores node differences
  Poor for heterogeneous clusters

Use case:
  Homogeneous nodes
  Similar task sizes
  Low complexity needs
```

### Weighted Distribution

Accounting for node capacity:

```
Algorithm:
  weight[i] = node[i].capacity
  total = sum(weights)
  select node[i] with probability weight[i]/total

Properties:
  Respects capacity differences
  More work to faster nodes
  Requires capacity estimation

Capacity factors:
  CPU/GPU power
  Memory size
  Historical performance
```

### Least-Loaded Distribution

Minimizing queue depth:

```
Algorithm:
  Select node with min(current_load)

Load metrics:
  Queue length
  Active tasks
  Estimated completion time

Properties:
  Adaptive to current state
  Balances naturally
  Requires load tracking
```

### Locality-Aware Distribution

Considering data placement:

```
Algorithm:
  Prefer nodes with required data
  Cache program binaries locally
  Minimize data transfer

Implementation:
  Track data presence on nodes
  Score by data locality
  Balance with load

Benefits:
  Reduced network transfer
  Faster task start
```

## Task Decomposition

### Single-Task Distribution

One task per proof request:

```
Simple model:
  Request → Task → Node → Proof

Properties:
  Straightforward
  Limited parallelism per request
  Good for small proofs
```

### Segment-Based Distribution

Breaking large proofs:

```
Decomposition:
  Large trace → Segments
  Each segment → Task → Node
  Aggregate segment proofs

Segment sizing:
  Based on node memory
  Balance parallelism and overhead
  Typical: 2^20 - 2^24 rows

Aggregation:
  Coordinator collects segment proofs
  Combines into final proof
```

### Stage-Based Distribution

Pipeline stage parallelism:

```
Stages:
  Witness generation
  Polynomial commitment
  Constraint evaluation
  FRI proving

Distribution:
  Different nodes for different stages
  Pipeline multiple proofs

Dependencies:
  Each stage depends on previous
  Data must flow between nodes
```

### Sub-Task Distribution

Fine-grained parallelism:

```
Sub-tasks:
  FFT on different polynomials
  Commitment for different columns
  Constraint evaluation in parallel

Granularity:
  Too fine: Overhead dominates
  Too coarse: Limited parallelism
  Balance for efficiency
```

## Load Balancing

### Static Balancing

Pre-determined distribution:

```
Approach:
  Assign based on node weights
  Fixed allocation
  Periodic rebalancing

Advantages:
  Predictable
  Low overhead
  Simple implementation

Disadvantages:
  Doesn't adapt to dynamics
  May become imbalanced
```

### Dynamic Balancing

Runtime adaptation:

```
Approach:
  Monitor node loads
  Adjust assignments continuously
  Migrate tasks if needed

Metrics:
  Current queue depth
  CPU/GPU utilization
  Memory pressure
  Recent throughput

Actions:
  Redirect new tasks
  Steal work from overloaded nodes
```

### Work Stealing

Idle nodes take work:

```
Algorithm:
  When node becomes idle:
    Pick random peer (or most loaded)
    Request task from peer's queue
    Process stolen task

Properties:
  Self-balancing
  Minimal coordination
  Handles uneven task sizes
```

### Task Migration

Moving in-progress work:

```
When to migrate:
  Node becoming overloaded
  Node failing
  Better placement available

Migration process:
  Checkpoint task state
  Transfer to new node
  Resume from checkpoint

Costs:
  State transfer overhead
  Restart overhead
  Complexity
```

## Scheduling Policies

### FIFO Scheduling

First-come, first-served:

```
Properties:
  Fair in order
  Simple
  No starvation

Limitations:
  No priority support
  Long tasks block short ones
```

### Priority Scheduling

Higher priority first:

```
Priority factors:
  Customer tier
  Task urgency
  Payment amount

Implementation:
  Priority queue
  Multiple priority levels
  Prevent starvation of low priority
```

### Deadline Scheduling

Meeting time constraints:

```
Algorithm:
  Earliest deadline first
  Reject if deadline impossible

Admission control:
  Estimate completion time
  Only accept if achievable
  Reserve capacity for deadlines
```

### Fair Scheduling

Equal treatment:

```
Per-customer fairness:
  Track usage per customer
  Balance over time

Implementation:
  Virtual time scheduling
  Weighted fair queuing
  Deficit round-robin
```

## Optimization Techniques

### Batching

Grouping similar tasks:

```
Batch benefits:
  Amortize setup overhead
  Better resource utilization
  Reduced coordination

Batch formation:
  Same program, different inputs
  Similar task sizes
  Time window collection
```

### Speculation

Redundant execution:

```
Approach:
  Run same task on multiple nodes
  Use first completion
  Cancel duplicates

Use cases:
  Critical latency tasks
  Unreliable nodes
  Tail latency reduction

Cost:
  Wasted computation
  Increased resource use
```

### Prefetching

Anticipating data needs:

```
Data prefetch:
  Push program binaries before tasks
  Cache frequently used data
  Reduce task start latency

Predictive:
  Based on historical patterns
  Likely next programs
```

### Affinity

Repeated assignment:

```
Node affinity:
  Assign related tasks to same node
  Leverage cached data
  Warm caches

Task affinity:
  Sequential segments to same node
  Maintain state between segments
```

## Monitoring

### Distribution Metrics

Tracking distribution quality:

```
Metrics:
  Tasks per node (balance)
  Queue depths (backlog)
  Assignment latency (overhead)
  Utilization (efficiency)

Alerts:
  Imbalance threshold
  Queue overflow
  Node starvation
```

### Performance Analysis

Understanding distribution impact:

```
Analysis:
  Completion time distribution
  Load variance across nodes
  Bottleneck identification

Visualization:
  Node load heatmaps
  Queue depth over time
  Task assignment patterns
```

## Key Concepts

- **Work distribution**: Allocating tasks to prover nodes
- **Load balancing**: Equalizing work across nodes
- **Task decomposition**: Breaking work into distributable units
- **Work stealing**: Idle nodes taking work from busy nodes
- **Affinity**: Preferring specific nodes for related tasks

## Design Considerations

### Distribution Granularity

| Coarse | Fine |
|--------|------|
| Whole proofs | Sub-tasks |
| Low overhead | High overhead |
| Limited parallelism | High parallelism |
| Simple | Complex |

### Balancing Approach

| Static | Dynamic |
|--------|---------|
| Pre-planned | Runtime |
| Predictable | Adaptive |
| Low overhead | Higher overhead |
| May imbalance | Self-correcting |

## Related Topics

- [Proving Network](01-proving-network.md) - Network architecture
- [Fault Recovery](03-fault-recovery.md) - Handling failures
- [Task Scheduling](../02-proof-coordination/01-task-scheduling.md) - Scheduling details
- [Parallel Execution](../../07-runtime-system/02-execution-engine/03-parallel-execution.md) - Node-level parallelism
