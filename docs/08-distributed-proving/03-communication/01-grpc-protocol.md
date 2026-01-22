# gRPC Protocol

## Overview

gRPC serves as a foundational communication layer for distributed proving systems, providing structured, efficient, and language-agnostic remote procedure calls between coordinators and workers. Unlike raw TCP or HTTP/REST, gRPC offers strong typing through Protocol Buffers, bidirectional streaming, and built-in features for load balancing, authentication, and deadline management that align well with the requirements of distributed proof generation.

The choice of gRPC reflects the communication patterns in distributed proving: request-response for task assignment and result collection, server streaming for progress updates, client streaming for partial result submission, and bidirectional streaming for interactive protocols. gRPC's HTTP/2 foundation provides multiplexing and header compression that reduce overhead when managing many concurrent worker connections.

This document covers gRPC usage concepts in distributed proving, message design principles, connection management patterns, and the operational characteristics that influence system performance and reliability. Understanding gRPC patterns is essential for building robust distributed proving infrastructure.

## gRPC Fundamentals

### Why gRPC for Distributed Proving

Advantages for this domain:

```
Strong typing:
  Service contracts defined clearly
  Compile-time checking
  Cross-language compatibility

Efficiency:
  Binary Protocol Buffers
  Smaller than JSON
  Faster serialization

Streaming:
  Native streaming support
  Progress updates
  Large data transfer

Features:
  Deadline propagation
  Cancellation
  Interceptors for cross-cutting
```

### Communication Patterns

Four gRPC patterns:

```
Unary (request-response):
  Client sends one message
  Server responds with one message
  Simplest pattern

Server streaming:
  Client sends one message
  Server responds with stream
  Progress updates, logs

Client streaming:
  Client sends stream
  Server responds once
  Aggregating multiple inputs

Bidirectional streaming:
  Both sides stream
  Interactive protocols
  Complex coordination
```

### Protocol Buffers

Message definition:

```
Concepts:
  Messages define data structures
  Services define RPC methods
  Strongly typed contracts

Benefits:
  Schema evolution
  Compact binary format
  Code generation

Design principles:
  Clear message boundaries
  Versioning support
  Self-documenting
```

## Service Design

### Coordinator Service Interface

Services the coordinator provides:

```
Registration service:
  Worker announces presence
  Receives configuration
  Establishes connection

Task service:
  Request task assignment
  Receive task specification
  Report completion

Status service:
  Query proof status
  Get system state
  Health checks
```

### Worker Service Interface

Services workers may provide:

```
Execution service:
  Receive task push
  Accept task parameters
  Execute and respond

Health service:
  Report health status
  Resource availability
  Performance metrics

Data service:
  Provide partial results
  Accept data requests
  Intermediate state queries
```

### Service Composition

Combining services:

```
Modular design:
  Separate services by concern
  Independent evolution
  Clear responsibilities

Example composition:
  TaskService: task assignment
  StatusService: monitoring
  DataService: large transfers
  HealthService: liveness

Benefits:
  Fine-grained access control
  Selective deployment
  Easier testing
```

## Message Design

### Task Messages

Messages for task handling:

```
Task request:
  Task identifier
  Task type
  Parameters
  Dependencies
  Resources required

Task response:
  Accept/reject
  Estimated duration
  Resource allocation

Task result:
  Task identifier
  Status (success/failure)
  Result data or error
  Timing information
```

### Data Messages

Large data transfer:

```
Chunked transfer:
  Split large data
  Stream chunks
  Reassemble at receiver

Chunk message:
  Sequence number
  Total chunks
  Chunk data
  Checksum

Metadata:
  Total size
  Content type
  Compression applied
```

### Status Messages

Progress and health:

```
Progress update:
  Task identifier
  Completion percentage
  Current phase
  Estimated remaining

Health status:
  Worker identifier
  Resource levels
  Active tasks
  Error counts

System status:
  Overall progress
  Worker summary
  Queue depths
```

## Connection Management

### Connection Establishment

Setting up connections:

```
Worker initialization:
  Connect to coordinator
  Authenticate if required
  Register capabilities
  Receive configuration

Keep-alive:
  Periodic pings
  Detect dead connections
  Reconnect on failure

Configuration:
  Connection timeout
  Retry policy
  Keep-alive interval
```

### Connection Pooling

Managing multiple connections:

```
Pool characteristics:
  Fixed or dynamic size
  Per-destination pools
  Connection reuse

Benefits:
  Reduced connection overhead
  Better resource utilization
  Predictable behavior

Management:
  Idle connection timeout
  Maximum lifetime
  Health checking
```

### Connection Recovery

Handling disconnections:

```
Detection:
  Keep-alive timeout
  Failed RPC
  Connection reset

Recovery:
  Automatic reconnect
  Exponential backoff
  Circuit breaker

State recovery:
  Re-register with coordinator
  Resume pending tasks
  Sync state if needed
```

## Streaming Patterns

### Progress Streaming

Server-side streaming for updates:

```
Pattern:
  Client requests task execution
  Server streams progress updates
  Final message indicates completion

Benefits:
  Real-time visibility
  Early error detection
  Continuous feedback

Implementation:
  Long-lived stream
  Periodic updates
  Flow control for slow clients
```

### Data Streaming

Large data transfer:

```
Pattern:
  Split data into chunks
  Stream chunks sequentially
  Acknowledge completion

Flow control:
  Backpressure handling
  Buffer management
  Rate limiting

Reliability:
  Chunk sequencing
  Error detection
  Retry failed chunks
```

### Interactive Streaming

Bidirectional for protocols:

```
Pattern:
  Both sides send messages
  Interleaved communication
  Request-response within stream

Use cases:
  Challenge-response protocols
  Interactive verification
  Real-time coordination

Complexity:
  State management both sides
  Message ordering
  Error handling mid-stream
```

## Error Handling

### Error Categories

Types of gRPC errors:

```
Transport errors:
  Connection failures
  Timeout
  Network issues

Application errors:
  Task failure
  Invalid request
  Resource unavailable

Protocol errors:
  Invalid message
  Version mismatch
  Contract violation
```

### Error Propagation

Communicating errors:

```
Status codes:
  Standard gRPC codes
  Appropriate code selection
  Descriptive messages

Rich errors:
  Error details
  Structured metadata
  Recovery hints

Client handling:
  Retry vs abort decision
  Error logging
  User notification
```

### Retry Strategies

Handling transient failures:

```
Retry policies:
  Maximum attempts
  Backoff strategy
  Retryable errors

Backoff:
  Exponential with jitter
  Maximum delay cap
  Reset on success

Idempotency:
  Retry-safe operations
  Idempotency keys
  Duplicate detection
```

## Performance Considerations

### Serialization Efficiency

Fast message encoding:

```
Protocol Buffer efficiency:
  Binary format
  Compact representation
  Fast encode/decode

Optimization:
  Avoid large strings
  Use appropriate types
  Consider message size

Comparison:
  PB vs JSON: 3-10x smaller
  PB vs JSON: 2-5x faster
  Worth the complexity
```

### Network Efficiency

Reducing network overhead:

```
HTTP/2 features:
  Header compression
  Multiplexing
  Server push (limited use)

Message optimization:
  Batch small messages
  Compress large payloads
  Stream vs multiple calls

Connection reuse:
  Avoid connection churn
  Pool connections
  Persistent connections
```

### Concurrency

Handling many simultaneous calls:

```
Server concurrency:
  Thread pool sizing
  Async handlers
  Resource limits

Client concurrency:
  Parallel calls
  Connection sharing
  Request pipelining

Bottlenecks:
  Serialization CPU
  Network bandwidth
  Server processing
```

## Security Considerations

### Transport Security

Secure communication:

```
TLS:
  Encrypt all traffic
  Certificate validation
  Mutual TLS option

Configuration:
  Certificate management
  Cipher suite selection
  Protocol versions

Mutual TLS:
  Both sides present certs
  Stronger authentication
  Certificate distribution
```

### Authentication

Verifying identity:

```
Token-based:
  API keys
  JWT tokens
  OAuth tokens

Certificate-based:
  Client certificates
  mTLS authentication
  Certificate authority

Integration:
  Interceptors for auth
  Metadata for tokens
  Channel credentials
```

### Authorization

Access control:

```
Method-level:
  Control per RPC method
  Role-based access
  Operation permissions

Resource-level:
  Access to specific tasks
  Worker-to-task mapping
  Data access control

Implementation:
  Interceptors check auth
  Policy enforcement
  Audit logging
```

## Operational Patterns

### Health Checking

Verifying service health:

```
gRPC health protocol:
  Standard health service
  Per-service status
  Load balancer integration

Implementation:
  Serve health endpoint
  Report service status
  Check dependencies

Usage:
  Load balancer probes
  Coordinator monitoring
  Auto-recovery triggers
```

### Load Balancing

Distributing requests:

```
Client-side:
  Client chooses server
  Round-robin, weighted
  Health-aware

Server-side (proxy):
  External load balancer
  gRPC-aware proxy
  Connection-level or request-level

Strategies:
  Round-robin: simple
  Least-connections: load-aware
  Custom: application-specific
```

### Observability

Monitoring gRPC services:

```
Metrics:
  Request count
  Latency distribution
  Error rates

Tracing:
  Distributed tracing
  Request context propagation
  Cross-service visibility

Logging:
  Request/response logging
  Error details
  Performance timing
```

## Integration Patterns

### Coordinator Integration

gRPC in coordinator:

```
Server role:
  Accept worker connections
  Handle task requests
  Serve status queries

Client role:
  Push tasks to workers (optional)
  Query worker status
  Data retrieval

Patterns:
  Long-lived connections
  Streaming for updates
  Unary for discrete operations
```

### Worker Integration

gRPC in workers:

```
Client role:
  Connect to coordinator
  Request tasks
  Report results

Server role (optional):
  Accept pushed tasks
  Serve data requests
  Health endpoints

Patterns:
  Persistent connection
  Streaming for progress
  Chunked data transfer
```

## Key Concepts

- **Service definition**: Structured RPC contracts via Protocol Buffers
- **Streaming patterns**: Support for various communication patterns
- **Connection management**: Persistent, multiplexed connections
- **Error handling**: Structured errors with retry strategies
- **Transport security**: TLS and authentication options
- **Load balancing**: Distributing requests across workers

## Design Trade-offs

### Unary vs Streaming

| Unary | Streaming |
|-------|-----------|
| Simple semantics | Continuous data |
| Request-response | Progress updates |
| Easy error handling | Complex state |
| Connection per call | Long-lived connection |

### Client vs Server Push

| Client Pull | Server Push |
|-------------|-------------|
| Worker controls timing | Coordinator controls |
| Simpler worker | Simpler coordinator |
| Polling overhead | Push overhead |
| Worker-initiated | Coordinator-initiated |

### Synchronous vs Asynchronous

| Synchronous | Asynchronous |
|-------------|--------------|
| Simple programming model | Higher throughput |
| Blocking calls | Non-blocking |
| Easy debugging | Complex state |
| Lower throughput | Better resource use |

## Related Topics

- [Coordinator Design](../01-architecture/02-coordinator-design.md) - Coordinator communication
- [Worker Design](../01-architecture/03-worker-design.md) - Worker communication
- [MPI Integration](02-mpi-integration.md) - Alternative communication
- [State Management](03-state-management.md) - Distributed state
- [Configuration](../04-deployment/01-configuration.md) - Communication configuration

