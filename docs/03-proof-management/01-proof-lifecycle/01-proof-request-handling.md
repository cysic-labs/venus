# Proof Request Handling

## Overview

Proof request handling is the entry point for the proving system, managing how proof generation requests are received, validated, and queued for processing. A well-designed request handling system ensures reliable proof generation, efficient resource utilization, and clear feedback to clients about proof status and progress.

The request handling layer abstracts away the complexity of distributed proving, resource allocation, and scheduling from the client perspective. Clients submit proof requests with their program and inputs, receive a request identifier, and can poll for status or await completion. The system internally handles all aspects of transforming that request into a valid proof.

This document covers request formats, validation procedures, queuing mechanisms, and the interface between request handling and proof generation.

## Request Lifecycle

### Overview

A proof request follows this lifecycle:

```
1. Submission: Client sends proof request
2. Validation: Request is checked for correctness
3. Queuing: Valid request enters processing queue
4. Scheduling: Request is assigned to proving resources
5. Execution: Program is executed and witness generated
6. Proving: STARK proof is generated
7. Completion: Proof is returned to client
```

### States

Requests transition through defined states:

```
PENDING: Request received, awaiting validation
VALIDATED: Request passed validation, in queue
SCHEDULED: Assigned to proving worker
EXECUTING: Program execution in progress
PROVING: Proof generation in progress
COMPLETED: Proof successfully generated
FAILED: Request failed with error
CANCELLED: Request cancelled by client
```

### Transitions

Valid state transitions:

```
PENDING -> VALIDATED (validation passed)
PENDING -> FAILED (validation failed)
VALIDATED -> SCHEDULED (resources available)
SCHEDULED -> EXECUTING (worker started)
EXECUTING -> PROVING (execution complete)
EXECUTING -> FAILED (execution error)
PROVING -> COMPLETED (proof generated)
PROVING -> FAILED (proving error)
Any state -> CANCELLED (client cancellation)
```

## Request Format

### Basic Request Structure

Minimal request information:

```
ProofRequest:
  program: bytes          // Compiled program (e.g., ELF binary)
  public_inputs: bytes    // Serialized public inputs
  private_inputs: bytes   // Serialized private inputs (optional)
  config: ProofConfig     // Proof generation parameters
  metadata: RequestMeta   // Tracking information
```

### Program Specification

Program can be specified in several ways:

```
Option 1: Inline binary
  program_bytes: bytes     // Full program binary

Option 2: Content-addressed reference
  program_hash: bytes32    // Hash of program
  // System fetches program from cache or storage

Option 3: Named program
  program_id: string       // Registered program identifier
  program_version: string  // Version specification
```

### Input Specification

Inputs are separated by visibility:

```
Public inputs (visible in proof):
  initial_state: bytes     // Program starting state
  public_data: bytes       // Additional public data

Private inputs (hidden in proof):
  private_data: bytes      // Secret program inputs
  oracle_data: bytes       // External data sources
```

### Configuration Options

Proof generation parameters:

```
ProofConfig:
  security_level: int      // Bits of security (e.g., 100, 128)
  proof_type: string       // "stark", "snark", "hybrid"
  max_steps: int           // Maximum execution steps
  timeout: duration        // Maximum proving time
  priority: int            // Scheduling priority
  compression: bool        // Enable proof compression
```

## Validation

### Structural Validation

Check request structure:

```
1. Required fields present
2. Field types correct
3. Sizes within limits
4. References resolvable

Errors:
  MISSING_FIELD: Required field not provided
  INVALID_TYPE: Field has wrong type
  SIZE_EXCEEDED: Field exceeds maximum size
  UNRESOLVABLE_REF: Referenced resource not found
```

### Program Validation

Verify program is acceptable:

```
1. Valid executable format (e.g., ELF structure)
2. Supported instruction set
3. Within size limits
4. Not in blocklist (if applicable)
5. Signature valid (if signed programs required)

Errors:
  INVALID_FORMAT: Program not parseable
  UNSUPPORTED_ISA: Unknown instructions
  PROGRAM_TOO_LARGE: Exceeds size limit
  BLOCKED_PROGRAM: Program not allowed
  INVALID_SIGNATURE: Signature check failed
```

### Input Validation

Verify inputs are acceptable:

```
1. Inputs deserializable
2. Sizes within limits
3. Format matches program expectations

Note: Semantic validation (do inputs make sense for program)
      happens during execution, not request validation.
```

### Resource Validation

Check resource availability:

```
1. Estimated execution within step limit
2. Estimated memory within available capacity
3. Queue capacity available
4. Account has sufficient quota (if applicable)

Errors:
  STEP_LIMIT_EXCEEDED: Estimated steps too high
  MEMORY_LIMIT_EXCEEDED: Estimated memory too high
  QUEUE_FULL: System at capacity
  QUOTA_EXCEEDED: Account limits reached
```

## Queuing System

### Queue Structure

Requests are organized in queues:

```
Priority Queues:
  - High priority: Time-sensitive requests
  - Normal priority: Standard requests
  - Low priority: Background/batch requests

Per-Account Queues (optional):
  - Isolate accounts from each other
  - Prevent one account monopolizing resources

Topic Queues (optional):
  - Separate by program type
  - Different resource requirements
```

### Queue Ordering

Requests ordered by multiple factors:

```
Primary: Priority level
Secondary: Arrival time (FIFO within priority)
Tertiary: Estimated resource usage (smaller first, optionally)

Example ordering:
  1. High priority, arrived first
  2. High priority, arrived second
  3. Normal priority, arrived first, small job
  4. Normal priority, arrived first, large job
  ...
```

### Queue Management

Operations on queues:

```
Enqueue(request):
  1. Validate request
  2. Assign to appropriate queue
  3. Trigger scheduling check

Dequeue() -> request:
  1. Select highest priority non-empty queue
  2. Remove and return first request
  3. Update queue statistics

Cancel(request_id):
  1. Find request in queues
  2. Mark as cancelled
  3. Remove from queue
  4. Notify client
```

### Persistence

Queue durability options:

```
In-memory only:
  - Fastest
  - Lost on restart
  - Suitable for ephemeral requests

Persistent:
  - Survives restarts
  - Higher latency
  - Required for critical workloads

Hybrid:
  - Hot queue in memory
  - Persist on enqueue
  - Recover on restart
```

## Scheduling

### Scheduler Responsibilities

The scheduler assigns requests to workers:

```
1. Monitor available workers
2. Match requests to suitable workers
3. Balance load across workers
4. Handle worker failures
5. Track assignment status
```

### Worker Selection

Choosing a worker for a request:

```
Criteria:
  - Worker has required capabilities
  - Worker has sufficient capacity
  - Worker is healthy
  - Load balancing across workers

Selection strategies:
  - Round-robin (simple, fair)
  - Least-loaded (balance utilization)
  - Affinity (reuse cached data)
  - Random (simple, stateless)
```

### Scheduling Policies

Different scheduling approaches:

```
Immediate:
  - Assign as soon as worker available
  - Lowest latency
  - May not optimize globally

Batching:
  - Collect requests before scheduling
  - Better optimization opportunities
  - Higher latency

Speculative:
  - Start on multiple workers
  - Use first completion
  - Higher resource use, lower latency
```

### Failure Handling

When assignments fail:

```
Worker failure:
  1. Detect failure (timeout, health check)
  2. Requeue request (if idempotent)
  3. Assign to different worker

Request failure:
  1. Capture error information
  2. Update request status to FAILED
  3. Notify client
  4. Log for debugging
```

## Client Interface

### Synchronous API

Blocking request/response:

```
// Client waits for proof
proof = prove(program, inputs, config)

Advantages:
  - Simple programming model
  - No polling needed

Disadvantages:
  - Ties up client resources
  - Timeout management complex
```

### Asynchronous API

Non-blocking with status polling:

```
// Submit request
request_id = submit_proof_request(program, inputs, config)

// Poll for status
status = get_request_status(request_id)

// Retrieve completed proof
if status == COMPLETED:
  proof = get_proof(request_id)

Advantages:
  - Client can do other work
  - Better for long proofs

Disadvantages:
  - More complex client code
  - Need to manage request IDs
```

### Webhook/Callback API

Server pushes completion:

```
// Submit with callback URL
submit_proof_request(
  program, inputs, config,
  callback_url="https://client/webhook/proof-complete"
)

// Server calls webhook when done
POST https://client/webhook/proof-complete
Body: { request_id, status, proof_or_error }

Advantages:
  - No polling overhead
  - Real-time notification

Disadvantages:
  - Client needs webhook endpoint
  - Delivery reliability concerns
```

### Streaming API

Real-time progress updates:

```
// Open stream
stream = stream_proof_request(program, inputs, config)

// Receive updates
for update in stream:
  if update.type == PROGRESS:
    display_progress(update.progress)
  elif update.type == COMPLETED:
    proof = update.proof
    break
  elif update.type == ERROR:
    handle_error(update.error)
```

## Error Handling

### Error Categories

Types of errors that can occur:

```
Validation errors:
  - Malformed request
  - Invalid program
  - Missing inputs

Execution errors:
  - Program crash
  - Step limit exceeded
  - Invalid memory access

Proving errors:
  - Constraint violation
  - Memory exhaustion
  - Timeout

System errors:
  - Worker failure
  - Network error
  - Storage error
```

### Error Response Format

Structured error information:

```
ErrorResponse:
  code: string           // Machine-readable error code
  message: string        // Human-readable description
  category: string       // Error category
  details: object        // Additional context
  request_id: string     // Original request identifier
  timestamp: datetime    // When error occurred
  recoverable: bool      // Can request be retried
```

### Retry Policies

When to retry failed requests:

```
Automatically retry:
  - Transient worker failures
  - Network timeouts
  - Temporary resource exhaustion

Do not retry:
  - Validation failures
  - Execution errors
  - Deterministic failures

Retry with backoff:
  - Rate limiting
  - System overload
```

## Monitoring and Observability

### Metrics

Key metrics to track:

```
Request metrics:
  - Requests received per second
  - Requests by status
  - Request latency (submission to completion)
  - Queue depth

Validation metrics:
  - Validation success/failure rate
  - Validation latency
  - Failure reasons distribution

Scheduling metrics:
  - Time in queue
  - Worker utilization
  - Assignment failures
```

### Logging

What to log:

```
Request events:
  - Submission (request_id, program_hash, timestamp)
  - Validation (request_id, result, errors)
  - Scheduling (request_id, worker_id)
  - Completion (request_id, duration, proof_size)
  - Errors (request_id, error_code, details)
```

### Tracing

Distributed tracing for request flow:

```
Trace spans:
  - Total request handling
    - Validation span
    - Queue wait span
    - Execution span
    - Proving span
  - Individual worker operations
```

## Key Concepts

- **Request lifecycle**: States from submission to completion
- **Validation**: Checking request correctness before processing
- **Queuing**: Managing pending requests for processing
- **Scheduling**: Assigning requests to proving resources
- **Error handling**: Managing failures gracefully

## Design Considerations

### Scalability vs. Simplicity

| Scalable Design | Simple Design |
|-----------------|---------------|
| Distributed queues | Single queue |
| Complex scheduling | FIFO processing |
| Horizontal scaling | Vertical scaling |
| More operational complexity | Easier to debug |

### Reliability Trade-offs

| High Reliability | Lower Overhead |
|------------------|----------------|
| Persistent queues | In-memory queues |
| Request journaling | No journaling |
| Redundant workers | Single workers |
| Higher latency | Lower latency |

## Related Topics

- [Proof Generation Pipeline](02-proof-generation-pipeline.md) - Proof creation process
- [Proof Delivery](03-proof-delivery.md) - Returning proofs to clients
- [Component Registry](../02-component-system/01-component-registry.md) - Managing proof components
- [Resource Allocation](../../08-distributed-proving/02-work-distribution/01-task-partitioning.md) - Worker management
