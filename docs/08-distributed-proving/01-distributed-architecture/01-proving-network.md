# Proving Network

## Overview

A proving network distributes the computational burden of zero-knowledge proof generation across multiple machines. Single-machine proving limits throughput and creates bottlenecks; distributed proving enables parallel proof generation, fault tolerance, and elastic scaling. The network consists of coordinator nodes that manage work and prover nodes that perform the actual proof computation.

Designing a proving network involves balancing decentralization, performance, and reliability. A fully decentralized network maximizes censorship resistance but complicates coordination. A centralized approach simplifies management but creates single points of failure. Practical networks often use a hybrid model with centralized coordination but distributed execution. This document covers network architecture, node roles, communication patterns, and deployment considerations.

## Network Architecture

### Network Topology

Structure of the proving network:

```
Centralized coordinator:
  [Coordinator]
       |
  ---------------------
  |     |     |      |
[Prover][Prover][Prover][Prover]

  Simple, efficient, single point of failure

Distributed coordinators:
  [Coord-1] -- [Coord-2] -- [Coord-3]
      |            |            |
  [Provers]    [Provers]    [Provers]

  Fault tolerant, more complex

Peer-to-peer:
  [Node] -- [Node] -- [Node]
    |         |         |
  [Node] -- [Node] -- [Node]

  Fully decentralized, coordination overhead
```

### Node Types

Roles in the network:

```
Coordinator:
  Receives proof requests
  Manages work queue
  Assigns tasks to provers
  Aggregates results
  Monitors network health

Prover:
  Executes witness generation
  Performs proof computation
  Reports results and status
  May specialize (GPU, FPGA, etc.)

Gateway:
  External API endpoint
  Request validation
  Load balancing
  Result caching

Storage:
  Proof archive
  Witness data
  Program binaries
  Configuration
```

### Network Layers

Logical separation:

```
Request layer:
  Client interfaces
  API gateways
  Request validation

Coordination layer:
  Task scheduling
  Resource management
  State synchronization

Computation layer:
  Prover nodes
  Proof generation
  Hardware abstraction

Storage layer:
  Data persistence
  Caching
  Replication
```

## Node Communication

### Communication Protocols

How nodes interact:

```
RPC (Remote Procedure Call):
  Coordinator → Prover: AssignTask, GetStatus
  Prover → Coordinator: ReportResult, Heartbeat

Message queue:
  Asynchronous task distribution
  Decoupled components
  Reliable delivery

Gossip protocol:
  Peer-to-peer discovery
  State propagation
  Fault detection
```

### Message Types

Communication content:

```
Task messages:
  TaskAssignment: Work to perform
  TaskResult: Completed proof
  TaskFailed: Error report

Control messages:
  Heartbeat: Node alive signal
  Status: Node capabilities and load
  Shutdown: Graceful termination

Data messages:
  WitnessData: Execution trace
  ProofData: Generated proof
  ProgramData: Binary to execute
```

### Serialization

Data encoding:

```
Binary formats:
  Protocol Buffers: Efficient, typed
  FlatBuffers: Zero-copy access
  Custom: Optimized for specific data

Considerations:
  Size: Network bandwidth
  Speed: Serialization overhead
  Compatibility: Version handling

Example (protobuf):
  message TaskAssignment {
    bytes task_id = 1;
    bytes program = 2;
    bytes input = 3;
    TaskConfig config = 4;
  }
```

## Node Management

### Node Registration

Adding nodes to network:

```
Registration flow:
  1. Node starts, loads configuration
  2. Connects to coordinator
  3. Sends capabilities (hardware, capacity)
  4. Coordinator adds to pool
  5. Node receives acknowledgment

Capabilities:
  Hardware type (CPU, GPU, FPGA)
  Memory capacity
  Supported proof types
  Geographic location

Security:
  Authentication (keys, certificates)
  Authorization (permissions)
  Rate limiting
```

### Health Monitoring

Tracking node status:

```
Heartbeat:
  Periodic alive signal
  Includes load metrics
  Timeout indicates failure

Metrics:
  CPU/GPU utilization
  Memory usage
  Queue depth
  Proof throughput

Health states:
  Healthy: Normal operation
  Degraded: Reduced capacity
  Unhealthy: Failing or offline
  Draining: Completing work, no new tasks
```

### Node Lifecycle

States and transitions:

```
States:
  Starting → Registering → Ready → Working
                 ↓             ↓
              Failed ←     Stopping → Stopped

Transitions:
  Starting: Initializing, loading
  Registering: Joining network
  Ready: Accepting tasks
  Working: Processing task
  Stopping: Graceful shutdown
  Failed: Error state
```

## Load Balancing

### Task Distribution

Assigning work to provers:

```
Round-robin:
  Simple, fair
  Ignores capacity differences

Weighted:
  Based on node capabilities
  More powerful nodes get more work

Least-loaded:
  Track current load
  Assign to least busy node

Locality-aware:
  Prefer nodes with cached data
  Reduce data transfer
```

### Queue Management

Handling pending work:

```
Priority queue:
  Higher priority tasks first
  Prevents starvation of low priority

Fair queue:
  Per-client fairness
  Prevent single client from monopolizing

Deadline-aware:
  Tasks with deadlines prioritized
  Drop or reschedule overdue tasks
```

### Backpressure

Handling overload:

```
Signals:
  Queue length threshold
  Response time degradation
  Memory pressure

Responses:
  Reject new requests
  Slow down submission
  Scale up resources

Implementation:
  Rate limiting at gateway
  Queue size limits
  Circuit breakers
```

## Fault Tolerance

### Failure Detection

Identifying failures:

```
Heartbeat timeout:
  No heartbeat for threshold period
  Mark node as suspect, then failed

Task timeout:
  Task not completed in expected time
  Potentially stuck or crashed

Health check failure:
  Active probing fails
  Node unreachable
```

### Failure Handling

Responding to failures:

```
Node failure:
  Reassign in-progress tasks
  Remove from active pool
  Attempt reconnection

Task failure:
  Retry on another node
  Report if persistent
  Log for analysis

Coordinator failure:
  Failover to standby
  Or distributed coordination
```

### Redundancy

Ensuring availability:

```
Node redundancy:
  Multiple provers per task type
  No single node is critical

Coordinator redundancy:
  Primary/standby setup
  Or consensus-based coordination

Data redundancy:
  Replicated storage
  Distributed caching
```

## Security

### Authentication

Verifying node identity:

```
Methods:
  API keys
  TLS certificates
  Signed tokens

Node authentication:
  Prover authenticates to coordinator
  Mutual TLS for bidirectional

Client authentication:
  Request submitters verified
  Rate limits per identity
```

### Authorization

Controlling access:

```
Permissions:
  Submit tasks
  Query status
  Administer network

Role-based:
  Prover: Execute tasks
  Operator: Manage nodes
  Admin: Full access
```

### Data Protection

Securing sensitive data:

```
In transit:
  TLS encryption
  Encrypted channels

At rest:
  Encrypted storage
  Key management

Witness privacy:
  May contain private input
  Limit access, encrypt
```

## Key Concepts

- **Proving network**: Distributed system for proof generation
- **Coordinator**: Node managing task distribution
- **Prover**: Node performing proof computation
- **Heartbeat**: Alive signal for health monitoring
- **Fault tolerance**: Handling node and task failures

## Design Considerations

### Centralization Trade-offs

| Centralized | Decentralized |
|-------------|---------------|
| Simple coordination | Complex coordination |
| Single point of failure | Fault tolerant |
| Efficient | Overhead |
| Easier management | Harder management |

### Scaling Strategy

| Vertical | Horizontal |
|----------|------------|
| Bigger machines | More machines |
| Limited by hardware | Limited by coordination |
| Simple | Complex |
| Expensive at scale | Cost-effective at scale |

## Related Topics

- [Work Distribution](02-work-distribution.md) - Task assignment details
- [Fault Recovery](03-fault-recovery.md) - Failure handling
- [Proof Coordination](../02-proof-coordination/01-task-scheduling.md) - Scheduling
- [Parallel Execution](../../07-runtime-system/02-execution-engine/03-parallel-execution.md) - Node-level parallelism
