# Bus Architecture

## Overview

The data bus is the communication backbone of the zkVM, connecting the main execution state machine to auxiliary state machines that handle specialized operations. When the main state machine needs to perform a memory access, invoke a precompile, or interact with secondary components, it sends requests through the bus and receives responses. The bus architecture enables modular design where components can be developed and verified independently.

In zero-knowledge proving, the bus must be provably correct. Every message sent must be received, values must remain unchanged during transmission, and routing must follow defined rules. The bus becomes another component that generates constraints, ensuring that inter-component communication maintains computational integrity.

This document describes the bus structure, protocols, and the constraints that govern its operation.

## Bus Concepts

### Role of the Data Bus

Why a bus architecture:

```
Modularity:
  Components communicate via defined interface
  Independent development and testing
  Clear separation of concerns

Verification:
  Single point for cross-component proofs
  Consistent communication protocol
  Unified constraint model
```

### Bus Participants

Who connects to the bus:

```
Main state machine:
  Primary bus master
  Initiates most requests
  Receives responses

Secondary state machines:
  Memory state machine
  Arithmetic units
  Binary operation units

Precompiles:
  Hash functions
  Cryptographic operations
  Extended arithmetic

External interfaces:
  Input/output handlers
  Public value generation
```

### Message Types

What travels on the bus:

```
Request messages:
  Operation type
  Operands/data
  Destination identifier

Response messages:
  Result values
  Status indicators
  Source identifier

Control messages:
  Synchronization signals
  Flow control
  Error notifications
```

## Bus Structure

### Logical Organization

How the bus is arranged:

```
Star topology (conceptual):
  Main SM at center
  Other components as spokes
  All communication through center

Or: Shared bus:
  Single broadcast medium
  Arbitration for access
  All components see all messages
```

### Channel Types

Different communication paths:

```
Request channel:
  Carries operation requests
  From requester to handler

Response channel:
  Carries operation results
  From handler to requester

May be combined:
  Single bidirectional channel
  With direction indicator
```

### Addressing

Identifying bus participants:

```
Component IDs:
  Unique identifier per component
  Used for routing

Implicit addressing:
  Operation type implies destination
  Memory ops go to memory SM
  Hash ops go to hash precompile

Explicit addressing:
  Destination field in message
  More flexible routing
```

## Message Format

### Request Structure

What a request message contains:

```
Request fields:
  src_id: Source component
  dst_id: Destination component (or implicit)
  op_type: Operation being requested
  operand1, operand2, ...: Input values
  tag: Request identifier for matching

Example:
  Memory read request:
    op_type = MEM_READ
    operand1 = address
    tag = unique_id
```

### Response Structure

What a response message contains:

```
Response fields:
  src_id: Responding component
  dst_id: Original requester
  op_type: Echo of request type
  result1, result2, ...: Output values
  tag: Matching request identifier
  status: Success/error indicator

Example:
  Memory read response:
    result1 = loaded_value
    tag = matching_id
    status = OK
```

### Message Encoding

Representing messages in constraints:

```
Column representation:
  Each field is a trace column
  Bus trace has message rows

Encoding:
  Messages as tuples
  Tuple encoding for lookups
  Challenge-based aggregation
```

## Bus Operations

### Request-Response Flow

How a typical operation proceeds:

```
1. Requester sends request
   - Places on request channel
   - Records tag for matching

2. Request routed to handler
   - Based on op_type or dst_id
   - Handler receives message

3. Handler processes request
   - Performs operation
   - Generates result

4. Handler sends response
   - Places on response channel
   - Includes matching tag

5. Requester receives response
   - Matches by tag
   - Extracts result
```

### Synchronous Operations

Immediate response model:

```
Single-cycle operations:
  Request and response same cycle
  Simplest constraint model

Multi-cycle operations:
  Request in cycle N
  Response in cycle N + k
  Need temporal constraints
```

### Pipelining

Overlapping requests:

```
Pipelined bus:
  Multiple outstanding requests
  Tags distinguish requests
  Out-of-order responses possible

Constraint:
  Every request eventually gets response
  Response matches request
```

## Bus Constraints

### Message Integrity

Ensuring messages are not corrupted:

```
Constraint:
  Response values unchanged from handler
  No modification in transit

Implementation:
  Same columns for send and receive
  Or: permutation between send/receive views
```

### Send-Receive Matching

Every send has a receive:

```
Requirement:
  Messages sent = Messages received
  No lost or fabricated messages

Permutation argument:
  (src, dst, op, data, tag) tuples
  Senders and receivers same multiset
```

### Tag Matching

Responses match requests:

```
For each request-response pair:
  request.tag = response.tag
  request.op_type = response.op_type
  request.src = response.dst

Constraint:
  Tags unique per sender
  Responses reference valid requests
```

## Bus Protocol

### Request Protocol

Rules for sending requests:

```
Sender responsibilities:
  1. Set valid destination
  2. Provide correct operands
  3. Generate unique tag
  4. Wait for response if blocking

Protocol:
  is_request = 1
  valid_destination = 1
  operands well-formed
```

### Response Protocol

Rules for sending responses:

```
Handler responsibilities:
  1. Process request correctly
  2. Generate appropriate response
  3. Use request's tag in response
  4. Route to original sender

Protocol:
  is_response = 1
  tag matches request
  dst = request's src
```

### Error Handling

When operations fail:

```
Error response:
  status = ERROR
  error_code indicates type
  Result may be undefined

Handling:
  Requester checks status
  May propagate error
  Or: constraint failure
```

## Multi-Destination Buses

### Broadcast

Sending to all components:

```
Broadcast message:
  Received by all participants
  Each may process or ignore

Use case:
  Global state updates
  Synchronization signals
```

### Multicast

Sending to subset:

```
Multicast message:
  Set of destination IDs
  Only those receive

Use case:
  Group operations
  Subset notifications
```

### Point-to-Point

Direct component communication:

```
Unicast message:
  Single source, single destination
  Most common pattern

Efficiency:
  Minimal constraint overhead
  Clear routing
```

## Bus Efficiency

### Constraint Overhead

Cost of bus in proof:

```
Per-message costs:
  Columns for message fields
  Rows for each message
  Permutation argument

Optimization:
  Minimize message count
  Batch operations
  Efficient encoding
```

### Throughput

Messages per cycle:

```
Bandwidth:
  Bus width limits concurrent messages
  May need multiple cycles for bursts

Optimization:
  Wide bus for high-traffic paths
  Pipelining for latency hiding
```

### Latency

Cycles from request to response:

```
Factors:
  Routing delay
  Handler processing time
  Response path

Optimization:
  Fast path for common operations
  Predictable latency where possible
```

## Bus Implementation

### Trace Columns

Columns for bus representation:

```
Bus trace columns:
  cycle: Timestamp
  is_request: Request indicator
  is_response: Response indicator
  src_id: Source component
  dst_id: Destination component
  op_type: Operation type
  data_0, data_1, ...: Payload
  tag: Message identifier
```

### Permutation Structure

Linking sends and receives:

```
Send trace:
  All sent messages
  (src, dst, op, data, tag) tuples

Receive trace:
  All received messages
  Same tuple format

Permutation:
  Send trace = permutation of Receive trace
  Proves matching
```

### Lookup Arguments

Alternative to permutation:

```
Lookup approach:
  Messages as lookup table entries
  Sends lookup into table
  Receives verify in table

Benefits:
  Flexible matching
  Multiple sends/receives per message
```

## Integration with State Machines

### Main SM Bus Interface

How main SM uses bus:

```
Request generation:
  When operation needed
  Create request message
  Place on bus

Response consumption:
  Wait for matching response
  Extract result
  Continue execution
```

### Secondary SM Interface

How auxiliary SMs interact:

```
Request reception:
  Monitor bus for relevant ops
  Accept requests for this component

Response generation:
  Process request
  Generate response
  Place on bus
```

## Key Concepts

- **Data bus**: Communication backbone for zkVM components
- **Message format**: Structure of requests and responses
- **Request-response protocol**: How components communicate
- **Send-receive matching**: Proving all messages delivered
- **Tag matching**: Linking responses to requests

## Design Trade-offs

### Centralized vs Distributed

| Central Bus | Distributed Channels |
|-------------|---------------------|
| Simple routing | Complex routing |
| Single bottleneck | Multiple paths |
| Unified constraints | Per-channel constraints |

### Synchronous vs Asynchronous

| Synchronous | Asynchronous |
|-------------|--------------|
| Simple timing | Flexible timing |
| Blocking | Pipelining possible |
| Easier constraints | Complex matching |

## Related Topics

- [Inter-Component Communication](02-inter-component-communication.md) - Communication patterns
- [Main State Machine](../02-state-machine-design/02-main-state-machine.md) - Primary bus user
- [Memory State Machine](../02-state-machine-design/05-memory-state-machine.md) - Memory bus handler
- [Lookup Arguments](../../03-proof-management/02-component-system/02-lookup-arguments.md) - Bus verification technique

