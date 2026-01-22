# Fault Recovery

## Overview

Fault recovery enables a distributed proving network to continue operating despite node failures, network partitions, and other disruptions. In a system where proof generation may take minutes and nodes may fail unexpectedly, robust recovery mechanisms prevent wasted work and ensure eventual completion. Without recovery, a single node failure could orphan tasks and delay proofs indefinitely.

Recovery strategies range from simple task reassignment to sophisticated checkpointing and state replication. The right approach depends on failure frequency, task duration, and acceptable recovery latency. This document covers failure detection, recovery mechanisms, checkpoint strategies, and consistency considerations.

## Failure Types

### Node Failures

Prover node failures:

```
Crash failure:
  Node stops unexpectedly
  In-progress tasks orphaned
  No graceful shutdown

Hang failure:
  Node becomes unresponsive
  May recover or truly failed
  Requires timeout to detect

Partial failure:
  Some components fail
  Degraded but not dead
  May produce errors
```

### Network Failures

Communication problems:

```
Network partition:
  Nodes isolated into groups
  Can't communicate across partition
  May cause split-brain

Message loss:
  Individual messages dropped
  Need acknowledgment/retry
  May cause duplicate work

Latency spike:
  Extreme delays
  May trigger false failure detection
  Performance degradation
```

### Task Failures

Proving failures:

```
Out of memory:
  Task exceeds node memory
  Need larger node or different approach

Timeout:
  Task exceeds time limit
  May be stuck or just slow

Error:
  Constraint violation
  Input error
  Bug in prover
```

## Failure Detection

### Heartbeat Mechanism

Periodic alive signals:

```
Implementation:
  Node sends heartbeat every T seconds
  Coordinator tracks last heartbeat
  Failure after K missed heartbeats

Configuration:
  T = 5 seconds (heartbeat interval)
  K = 3 (missed heartbeats for failure)
  Detection time: K * T = 15 seconds

Trade-off:
  Short interval: Fast detection, more traffic
  Long interval: Slow detection, less traffic
```

### Probe-Based Detection

Active health checking:

```
Implementation:
  Coordinator periodically probes nodes
  Probe: Request health status
  No response: Mark unhealthy

Probe types:
  Ping: Basic connectivity
  Health check: Service status
  Task probe: Processing status
```

### Failure Suspicion

Gradual failure determination:

```
States:
  Healthy → Suspected → Failed

Transitions:
  Missed heartbeat: Healthy → Suspected
  Continued silence: Suspected → Failed
  Heartbeat received: Suspected → Healthy

Benefits:
  Avoids false positives from transient issues
  Allows recovery from temporary problems
```

## Recovery Mechanisms

### Task Reassignment

Moving orphaned tasks:

```
On node failure:
  1. Identify tasks on failed node
  2. Return tasks to queue
  3. Assign to available nodes

Implementation:
  Coordinator tracks task→node mapping
  On failure: Mark tasks as pending
  Normal scheduling picks them up

Idempotency:
  Tasks may have partially completed
  Must be safe to restart
```

### Checkpoint-Based Recovery

Resuming from saved state:

```
Checkpointing:
  Periodically save progress
  Store checkpoint to durable storage
  Include all necessary state

Recovery:
  Load checkpoint on restart
  Resume from checkpoint state
  Complete remaining work

Checkpoint content:
  Execution trace (partial or complete)
  Proving state
  Polynomial commitments done
```

### Retry Policies

Handling transient failures:

```
Immediate retry:
  Retry same node immediately
  For transient errors

Delayed retry:
  Wait before retrying
  Exponential backoff

Alternate node:
  Retry on different node
  For node-specific failures

Maximum retries:
  Limit retry attempts
  Eventually fail permanently
```

## Checkpoint Strategies

### Checkpoint Granularity

What to checkpoint:

```
Coarse-grained:
  Checkpoint between major phases
  Lower overhead
  More work lost on failure

Fine-grained:
  Checkpoint frequently
  Higher overhead
  Less work lost

Adaptive:
  Adjust based on task duration
  More frequent for long tasks
```

### Checkpoint Storage

Where to store checkpoints:

```
Local disk:
  Fast write
  Lost if node fails
  Good for crash recovery

Shared storage:
  Accessible from any node
  Survives node failure
  Network overhead

Replicated storage:
  Multiple copies
  High durability
  Higher overhead
```

### Checkpoint Triggers

When to checkpoint:

```
Time-based:
  Every T minutes
  Predictable overhead

Progress-based:
  After N rows processed
  Proportional to progress

Phase-based:
  At natural boundaries
  Between proving stages
```

## Coordinator Recovery

### Coordinator Failure

Handling coordinator crash:

```
Single coordinator:
  Network non-functional until restart
  Tasks may need reassignment

Standby coordinator:
  Passive backup takes over
  Requires state replication
  Faster failover
```

### State Replication

Maintaining coordinator state:

```
State to replicate:
  Active nodes
  Task assignments
  Queue contents
  Configuration

Replication methods:
  Synchronous: All replicas updated before ack
  Asynchronous: Primary updates first, replicas follow

Consistency:
  Strong: All replicas agree
  Eventual: May temporarily differ
```

### Leader Election

Choosing new coordinator:

```
On coordinator failure:
  Remaining coordinators elect leader
  Leader takes over coordination

Algorithms:
  Raft: Strong consistency
  Paxos: Theoretical foundation
  Simple: Designated primary/secondary
```

## Consistency Considerations

### Exactly-Once Execution

Avoiding duplicate or missing proofs:

```
Challenge:
  Task may have been completed but not reported
  Don't want duplicate work

Solutions:
  Idempotent tasks: Safe to re-execute
  Deduplication: Check before outputting
  Two-phase commit: Coordinate completion
```

### Ordering

Handling task order:

```
Segment ordering:
  Segments may complete out of order
  Aggregation needs all segments
  Wait for complete set

Result ordering:
  Proofs may finish out of order
  Client may need specific order
  Queue and reorder if needed
```

### Split-Brain

Handling network partitions:

```
Problem:
  Two groups think they're the system
  May assign same task twice
  May produce conflicting results

Prevention:
  Quorum: Need majority to operate
  Fencing: Only one side can write
  Tokens: Exclusive access
```

## Operational Recovery

### Graceful Shutdown

Planned node removal:

```
Process:
  1. Stop accepting new tasks
  2. Complete in-progress tasks
  3. Drain connections
  4. Shutdown

Implementation:
  Node enters "draining" state
  Coordinator stops assigning
  Wait for completion
  Clean shutdown
```

### Rolling Upgrades

Upgrading without downtime:

```
Process:
  1. Drain subset of nodes
  2. Upgrade drained nodes
  3. Return to service
  4. Repeat for remaining nodes

Considerations:
  Maintain minimum capacity
  Version compatibility
  Feature flags for new functionality
```

## Key Concepts

- **Failure detection**: Identifying failed nodes or tasks
- **Task reassignment**: Moving orphaned tasks
- **Checkpoint**: Saved progress for recovery
- **Leader election**: Choosing coordinator after failure
- **Split-brain**: Network partition causing dual masters

## Design Considerations

### Recovery Speed vs Overhead

| Fast Recovery | Low Overhead |
|---------------|--------------|
| Frequent checkpoints | Rare checkpoints |
| More storage | Less storage |
| Less work lost | More work lost |
| Higher cost | Lower cost |

### Consistency vs Availability

| Strong Consistency | High Availability |
|-------------------|-------------------|
| All agree | May diverge |
| May block on failure | Continues despite failure |
| Simpler reasoning | Complex reconciliation |
| Lower throughput | Higher throughput |

## Related Topics

- [Proving Network](01-proving-network.md) - Network architecture
- [Work Distribution](02-work-distribution.md) - Task assignment
- [Task Scheduling](../02-proof-coordination/01-task-scheduling.md) - Scheduling
- [Error Handling](../../07-runtime-system/03-prover-runtime/03-error-handling.md) - Node-level errors
