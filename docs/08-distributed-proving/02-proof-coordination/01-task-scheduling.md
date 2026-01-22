# Task Scheduling

## Overview

Task scheduling determines when and where proving tasks execute within the distributed network. The scheduler manages a queue of pending tasks, matches tasks to available provers based on requirements and capabilities, and ensures fair and efficient resource utilization. Good scheduling minimizes latency for individual requests while maximizing overall system throughput.

Scheduling decisions involve multiple factors: task priority, resource requirements, prover capabilities, current load, and service level objectives. The scheduler must balance competing goals—low latency for urgent requests versus high throughput for batch workloads—while handling the dynamic nature of a distributed system. This document covers scheduling algorithms, priority mechanisms, resource matching, and optimization strategies.

## Scheduling Model

### Task Representation

What the scheduler manages:

```
Task attributes:
  task_id: Unique identifier
  program_hash: Program to execute
  input_data: Input for execution
  priority: Urgency level
  deadline: Optional completion time
  requirements: Resource needs
  status: pending/running/completed/failed

Resource requirements:
  memory_gb: Minimum memory
  gpu_required: Needs GPU
  estimated_time: Expected duration
  specialized_hw: Specific hardware
```

### Scheduler State

Information the scheduler tracks:

```
State components:
  task_queue: Pending tasks by priority
  running_tasks: Currently executing
  prover_pool: Available provers
  prover_status: Current state of each prover
  metrics: Performance statistics

Prover information:
  prover_id: Unique identifier
  capabilities: What it can run
  current_load: Tasks in progress
  queue_depth: Pending tasks
  last_heartbeat: Health indicator
```

### Scheduling Cycle

How scheduling proceeds:

```
Cycle:
  1. Check for new tasks
  2. Update prover status
  3. Match tasks to provers
  4. Dispatch assigned tasks
  5. Handle completions/failures
  6. Repeat

Frequency:
  Event-driven: On task arrival or completion
  Periodic: Every N milliseconds
  Hybrid: Events with periodic cleanup
```

## Scheduling Algorithms

### FIFO Scheduling

First-come, first-served:

```
Algorithm:
  Tasks ordered by arrival time
  Next task goes to first available prover

Properties:
  Simple and fair
  No priority support
  Predictable latency under light load
  Convoy effect under heavy load

Implementation:
  queue = FIFO queue
  on task_arrival: queue.push(task)
  on prover_available: dispatch(queue.pop(), prover)
```

### Priority Scheduling

Higher priority first:

```
Algorithm:
  Tasks ordered by priority, then arrival
  Highest priority gets next prover

Priority levels:
  Critical: System-essential
  High: Paid/SLA customers
  Normal: Standard requests
  Low: Background/batch

Implementation:
  priority_queues = [critical, high, normal, low]
  on dispatch: Select from highest non-empty queue
```

### Shortest Job First

Minimize average latency:

```
Algorithm:
  Estimate task duration
  Schedule shortest tasks first

Estimation:
  Program size heuristic
  Historical data
  Client-provided estimate

Properties:
  Optimal for average latency
  May starve long tasks
  Requires duration estimates
```

### Deadline Scheduling

Meeting time constraints:

```
Algorithm:
  Order by deadline (earliest first)
  Skip tasks that can't meet deadline

Admission control:
  Estimate completion time
  Reject if deadline impossible
  Reserve capacity

Implementation:
  deadline_queue = sorted by deadline
  on arrival:
    if can_meet_deadline(task):
      admit(task)
    else:
      reject(task)
```

## Resource Matching

### Capability Matching

Matching task needs to prover abilities:

```
Task requirements:
  memory_gb >= 16
  gpu_required = true
  specialized = "BN254"

Prover capabilities:
  memory_gb = 32
  has_gpu = true
  supported_curves = ["BN254", "BLS12"]

Matching:
  Prover satisfies task requirements
  Select capable prover with best fit
```

### Constraint Satisfaction

Complex matching rules:

```
Constraints:
  Hard: Must satisfy (memory, GPU)
  Soft: Prefer to satisfy (locality, affinity)

Algorithm:
  Filter by hard constraints
  Score by soft constraints
  Select highest scoring
```

### Load-Aware Matching

Considering current load:

```
Factors:
  Queue depth
  Running tasks
  Memory utilization
  CPU/GPU utilization

Selection:
  Among capable provers
  Prefer less loaded
  Balance across cluster
```

## Fairness

### Client Fairness

Equal treatment of clients:

```
Mechanisms:
  Per-client quotas
  Fair share of resources
  Rate limiting

Implementation:
  Track usage per client
  Weight scheduling by usage
  Throttle over-using clients
```

### Task Fairness

Preventing starvation:

```
Aging:
  Increase priority over time
  Old tasks eventually run

Reservation:
  Reserve capacity for each priority
  Ensure all levels get service

Maximum wait:
  Force scheduling after threshold
```

### Resource Fairness

Balanced resource consumption:

```
Memory fairness:
  Don't let few tasks consume all memory
  Reserve for diverse workload

Prover fairness:
  Don't overload specific provers
  Spread work evenly
```

## Queue Management

### Queue Structure

Organizing pending tasks:

```
Single queue:
  Simple, FIFO or sorted
  Limited flexibility

Multiple queues:
  Per-priority queues
  Per-client queues
  Per-resource queues

Hierarchical:
  Priority within client
  Client within pool
```

### Admission Control

Accepting new tasks:

```
Criteria:
  Resource availability
  Queue depth limits
  Client quotas

Actions:
  Accept: Add to queue
  Reject: Immediate error
  Defer: Request retry later
  Throttle: Slow down submission
```

### Queue Limits

Bounding queue size:

```
Limits:
  Global queue max
  Per-client queue max
  Per-priority queue max

Overflow handling:
  Reject new tasks
  Drop old tasks
  Spill to persistent storage
```

## Optimization

### Batch Scheduling

Grouping related tasks:

```
Batching criteria:
  Same program
  Similar size
  Close arrival time

Benefits:
  Amortize setup
  Better locality
  Simplified coordination
```

### Preemption

Interrupting running tasks:

```
When to preempt:
  Higher priority task arrives
  Resource urgently needed
  Task taking too long

Preemption cost:
  Lost work
  Checkpoint overhead
  Context switch

Policy:
  Only preempt for critical tasks
  Checkpoint before preemption
  Minimize preemption frequency
```

### Speculation

Redundant execution:

```
Speculative execution:
  Run task on multiple provers
  Use first completion
  Cancel duplicates

When to speculate:
  Latency-critical tasks
  Unreliable provers
  Tail latency issues
```

## Monitoring

### Scheduler Metrics

Tracking scheduler performance:

```
Latency metrics:
  Queue wait time
  Scheduling decision time
  End-to-end latency

Throughput metrics:
  Tasks completed per second
  Provers utilized
  Queue depth over time

Fairness metrics:
  Per-client statistics
  Priority level service rates
```

### Alerting

Detecting problems:

```
Alerts:
  Queue depth excessive
  Average wait time high
  Prover utilization low
  Failed task rate high

Actions:
  Page on-call
  Auto-scale resources
  Adjust scheduling parameters
```

## Key Concepts

- **Task scheduling**: Deciding when/where tasks run
- **Priority**: Urgency level affecting order
- **Resource matching**: Matching requirements to capabilities
- **Fairness**: Equitable treatment of clients/tasks
- **Admission control**: Accepting or rejecting tasks

## Design Considerations

### Scheduling Complexity

| Simple | Complex |
|--------|---------|
| FIFO | Multi-factor optimization |
| Low overhead | Higher overhead |
| Limited features | Rich features |
| Easy to understand | Hard to tune |

### Fairness vs Efficiency

| Fair | Efficient |
|------|-----------|
| Equal service | Optimize throughput |
| May waste capacity | May be unfair |
| Predictable | Variable |
| Required for SLA | Required for performance |

## Related Topics

- [Work Distribution](../01-distributed-architecture/02-work-distribution.md) - Distribution algorithms
- [Fault Recovery](../01-distributed-architecture/03-fault-recovery.md) - Handling failures
- [Result Aggregation](02-result-aggregation.md) - Collecting results
- [Proof Aggregation](../../04-zkvm-architecture/05-system-integration/04-proof-aggregation.md) - Combining proofs
