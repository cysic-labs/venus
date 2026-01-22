# Inter-Component Communication

## Overview

Inter-component communication describes how the various state machines and components of the zkVM exchange data and coordinate their operations. While the bus architecture provides the physical medium for communication, this document focuses on the patterns, protocols, and constraints that govern how components interact.

Effective inter-component communication enables the modular zkVM architecture. The main state machine can delegate operations to specialized components—memory handling, arithmetic operations, cryptographic precompiles—and receive results through well-defined interfaces. Each interaction must be provably correct, adding constraints that verify data integrity across component boundaries.

This document covers communication patterns, data flow, and the constraint systems that ensure correct inter-component operation.

## Communication Patterns

### Request-Response

The dominant pattern:

```
Pattern:
  Component A sends request
  Component B processes and responds
  A receives and continues

Examples:
  Main SM → Memory SM: Load/Store
  Main SM → Arithmetic: Multiply
  Main SM → Precompile: Hash computation
```

### Producer-Consumer

Streaming data between components:

```
Pattern:
  Producer generates data stream
  Consumer processes data items
  Flow control manages rate

Examples:
  Trace generation → Witness building
  Input buffer → Execution
  Execution → Output buffer
```

### Publish-Subscribe

Broadcast notifications:

```
Pattern:
  Publisher broadcasts event
  Subscribers receive if interested
  Decoupled communication

Examples:
  State updates broadcast
  Error notifications
  Synchronization points
```

## Data Flow

### Operand Transfer

Moving values between components:

```
For operations:
  Source: Main SM register values
  Transfer: Via bus message
  Destination: Processing component

Constraint:
  Received values = Sent values
  Proven via permutation/lookup
```

### Result Return

Returning computed values:

```
For results:
  Source: Processing component
  Transfer: Via response message
  Destination: Main SM for register write

Constraint:
  Register receives correct result
  Matching via tags
```

### Bulk Data Transfer

Moving large data sets:

```
For memory regions:
  Base address + length
  Sequential transfer
  Or: batch message

For precompile inputs:
  Multiple words per invocation
  Chunked transfer
  Reassembly at destination
```

## Communication Protocols

### Handshaking

Coordinating transfers:

```
Simple handshake:
  1. Sender asserts valid
  2. Receiver asserts ready
  3. Transfer on valid AND ready

Constraint:
  Transfer only when both signals active
```

### Flow Control

Managing transfer rates:

```
Backpressure:
  Receiver signals when busy
  Sender waits until ready

Credit-based:
  Receiver provides credits
  Sender consumes credits per transfer
  Refill when receiver processes
```

### Ordering Guarantees

Message ordering properties:

```
FIFO per channel:
  Messages maintain order per source-dest pair
  Simpler reasoning

Reordering allowed:
  Messages may arrive out of order
  Tags enable matching
  More flexibility
```

## Component Interfaces

### Main State Machine Interface

Communication from/to main SM:

```
Outbound requests:
  Memory operations (load/store)
  Arithmetic operations (mul/div)
  Precompile invocations

Inbound responses:
  Load results
  Computation results
  Precompile outputs

Interface:
  Defined message formats
  Expected response timing
  Error handling
```

### Memory Component Interface

Memory SM communication:

```
Accepts:
  Read requests (address → value)
  Write requests (address, value)

Returns:
  Read values
  Write acknowledgments

Constraint:
  Consistency with memory model
  Proper value return
```

### Arithmetic Component Interface

Arithmetic unit communication:

```
Accepts:
  Operation type (mul, div, rem)
  Operands

Returns:
  Result value(s)

Constraint:
  Result = operation(operands)
  Proven by arithmetic constraints
```

### Precompile Interface

Precompile communication:

```
Accepts:
  Function identifier
  Input data (may be multi-word)

Returns:
  Output data
  Status

Constraint:
  Output = function(input)
  Proven by precompile constraints
```

## Message Routing

### Operation-Based Routing

Determining destination by operation:

```
Routing table:
  MEM_READ, MEM_WRITE → Memory SM
  MUL, DIV, REM → Arithmetic SM
  KECCAK, SHA256 → Hash precompiles
  ECADD, ECMUL → EC precompiles

Implementation:
  Decode operation type
  Route to appropriate handler
```

### Address-Based Routing

Routing based on address ranges:

```
For memory:
  Register region → Register handling
  RAM region → Memory SM
  ROM region → ROM SM
  I/O region → I/O handlers
```

### Priority Routing

Handling multiple requests:

```
Arbitration:
  When multiple sources request
  Priority determines order
  Round-robin for fairness

Queue management:
  Buffer pending requests
  Serve in priority/FIFO order
```

## Constraint Systems

### Send Constraints

Proving correct message sending:

```
At sender:
  is_send * (message_content - intended_content) = 0
  is_send * (destination - correct_destination) = 0

Columns:
  is_send: Selector for send operations
  message fields: Data being sent
```

### Receive Constraints

Proving correct message reception:

```
At receiver:
  is_receive * (received_content - expected_content) = 0
  is_receive * (source - expected_source) = 0

Matching:
  Received message exists in sent messages
```

### Consistency Constraints

Ensuring coherent communication:

```
Global constraint:
  sum(sends) = sum(receives) per message type
  All sent messages received
  No extra receives
```

## Cross-Component Proofs

### Permutation Arguments

Linking component traces:

```
Approach:
  Collect all inter-component messages
  Messages from senders = messages to receivers
  Permutation proves equality

Implementation:
  Accumulator across all components
  Final accumulators match
```

### Lookup Arguments

Verifying data exists:

```
Approach:
  One component's outputs as table
  Another component's inputs lookup into table
  Proves inputs are valid outputs

Example:
  Memory SM provides (addr, value) table
  Main SM loads lookup (addr) → gets value
```

### Connection Arguments

Specialized cross-component links:

```
Approach:
  Direct connection between specific columns
  Same value in different components

Example:
  Main SM result column = Arithmetic SM output column
  For matching operation instances
```

## Error Handling

### Error Propagation

Communicating errors:

```
Error in component:
  Set error flag in response
  Include error code

At receiver:
  Check error flag
  Handle appropriately (trap, abort)

Constraint:
  Error responses properly handled
```

### Recovery Protocols

Handling errors gracefully:

```
Options:
  Retry operation
  Invoke trap handler
  Abort execution

Constraint:
  Recovery path still provable
  No constraint violations
```

## Performance Optimization

### Batching

Combining multiple operations:

```
Batch messages:
  Multiple operations in one transfer
  Amortize overhead

Example:
  Multiple memory reads batched
  Single lookup for batch
```

### Caching

Avoiding redundant communication:

```
Cache recent values:
  Don't re-request unchanged data
  Local copy reduces bus traffic

Constraint:
  Cache values still consistent
  Invalidation when needed
```

### Parallelism

Concurrent component operations:

```
Independent operations:
  Can proceed in parallel
  Different components simultaneously

Constraint:
  Ordering where required
  Independence where possible
```

## Synchronization

### Cycle Alignment

Keeping components in sync:

```
Global cycle:
  All components share cycle counter
  Messages tagged with cycle

Synchronization:
  Responses within defined cycles
  Or: explicit synchronization points
```

### Barrier Synchronization

Collective synchronization:

```
Barrier:
  All components reach point
  Proceed only when all ready

Use case:
  Segment boundaries
  Phase transitions
```

## Key Concepts

- **Inter-component communication**: Data exchange between zkVM parts
- **Request-response pattern**: Primary communication model
- **Message routing**: Directing messages to handlers
- **Cross-component proofs**: Verifying communication correctness
- **Lookup/permutation arguments**: Constraint techniques for linking

## Design Trade-offs

### Coupling Level

| Tight Coupling | Loose Coupling |
|----------------|----------------|
| Direct connections | Bus-based |
| Lower latency | More flexibility |
| Complex changes | Easier changes |

### Protocol Complexity

| Simple Protocol | Rich Protocol |
|-----------------|---------------|
| Minimal overhead | More features |
| Limited flexibility | Flow control, errors |
| Easier proofs | Complex proofs |

## Related Topics

- [Bus Architecture](01-bus-architecture.md) - Communication medium
- [Main State Machine](../02-state-machine-design/02-main-state-machine.md) - Central coordinator
- [Lookup Arguments](../../03-proof-management/02-component-system/02-lookup-arguments.md) - Verification technique
- [Permutation Arguments](../../03-proof-management/02-component-system/03-permutation-arguments.md) - Linking proofs

