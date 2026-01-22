# System Services

## Overview

System services in a zkVM provide essential functionality that programs need beyond basic computation. These services bridge the gap between the raw execution environment and the capabilities programs expect. Unlike traditional operating systems with hundreds of system calls, a zkVM offers a minimal set of services focused on I/O, memory management, and program lifecycle.

The design of system services significantly impacts proving efficiency. Each service invocation becomes part of the execution trace and must be represented in constraints. Services must balance functionality with constraint complexity, providing what programs need without unnecessary overhead.

This document covers the available system services in zkVM runtimes, their interfaces, and implementation considerations.

## Service Philosophy

### Minimalism

Only essential services:

```
Essential services:
  Program exit
  Input reading
  Output writing
  Memory allocation

Explicitly excluded:
  File system access
  Network operations
  Process management
  Time/clock access
  Random number generation
```

### Determinism

All services must be deterministic:

```
Deterministic properties:
  Same inputs yield same results
  No external dependencies
  No timing variations
  Reproducible behavior

Non-deterministic operations:
  Not available as services
  Must be handled externally
  Input provided before execution
```

### Provability

Services must be constraint-representable:

```
Provable service requirements:
  Bounded operations
  Clear state transitions
  Defined side effects
  Verifiable outcomes
```

## Service Interface

### System Call Mechanism

How programs access services:

```
System call pattern:
  Place request code in register
  Place arguments in registers
  Execute special instruction
  Result returned in register

Interface properties:
  Synchronous execution
  No blocking operations
  Immediate result
```

### Request Codes

Identifying service requests:

```
Request code structure:
  Numeric identifier
  Unique per service
  Platform-defined

Example codes:
  0: Exit program
  1: Read input
  2: Write output
  3: Allocate memory
```

### Argument Passing

Providing service parameters:

```
Argument convention:
  Arguments in registers
  Order defined per service
  Limited number (typically 4-6)

Return values:
  Result in designated register
  Status/error in another
```

## Core Services

### Exit Service

Terminating program execution:

```
Exit service:
  Request code: 0
  Argument: exit status
  Effect: Ends execution

Behavior:
  Stops instruction execution
  Records final state
  Captures exit code
  Enables output collection
```

### Input Read Service

Reading from input buffer:

```
Read service:
  Request code: 1
  Arguments: buffer address, length
  Result: bytes read

Behavior:
  Copies from input buffer
  Advances read pointer
  Returns actual bytes read
  Zero at end of input
```

### Output Write Service

Writing to output buffer:

```
Write service:
  Request code: 2
  Arguments: buffer address, length
  Result: bytes written

Behavior:
  Copies to output buffer
  Advances write pointer
  Returns bytes written
  May fail if buffer full
```

### Memory Allocation Service

Requesting heap memory:

```
Allocation service:
  Request code: 3
  Argument: size in bytes
  Result: address or null

Behavior:
  Finds available space
  Updates allocator state
  Returns allocated address
  Null on failure
```

## I/O Services

### Sequential Read

Reading input sequentially:

```
Sequential read:
  Maintains read position
  Returns data in order
  Tracks bytes consumed

Properties:
  No random access
  Forward only
  EOF detection
```

### Bulk Read

Reading large amounts:

```
Bulk read:
  Read into memory buffer
  Specify maximum length
  Receive actual length

Use cases:
  Loading data structures
  Reading variable content
  Batch processing
```

### Sequential Write

Writing output sequentially:

```
Sequential write:
  Appends to output
  Maintains write position
  Tracks bytes written

Properties:
  Append only
  No modification
  Order preserved
```

### Bulk Write

Writing large amounts:

```
Bulk write:
  Write from memory buffer
  Specify length
  Atomic operation

Use cases:
  Outputting results
  Writing data structures
  Batch output
```

## Memory Services

### Simple Allocation

Basic memory allocation:

```
Simple allocator service:
  Request size
  Receive address
  No deallocation

Properties:
  Fast allocation
  Simple implementation
  Memory not reclaimed
```

### Sized Allocation

Allocation with alignment:

```
Aligned allocation:
  Request size and alignment
  Receive aligned address
  Alignment guaranteed

Use cases:
  Data structure alignment
  Performance optimization
```

### Memory Query

Querying memory state:

```
Memory queries:
  Available heap space
  Current allocation point
  Memory region boundaries

Use cases:
  Resource management
  Allocation decisions
```

## Error Handling Services

### Error Reporting

Reporting execution errors:

```
Error report service:
  Error code argument
  Optional message location
  Execution may continue or stop

Behavior:
  Records error information
  Available in output/trace
  Program controls response
```

### Assertion Failure

Handling failed assertions:

```
Assert service:
  Condition already failed
  Reports assertion info
  Terminates execution

Behavior:
  Records failure state
  Terminates program
  Distinguishes from normal exit
```

### Panic Handling

Unrecoverable errors:

```
Panic service:
  Signals fatal error
  May include message
  Always terminates

Behavior:
  Immediate termination
  Error state recorded
  No recovery possible
```

## Hint Services

### Private Hints

Non-proven auxiliary data:

```
Hint mechanism:
  Program requests hint
  Runtime provides data
  Data not part of public proof

Use cases:
  Optimization hints
  Computation shortcuts
  Witness generation aids
```

### Hint Reading

Consuming hint data:

```
Hint read service:
  Similar to input read
  From hint buffer
  Private to prover

Properties:
  Not publicly verifiable
  Enables optimizations
  Separate from main input
```

## Debug Services

### Print Service

Development-time output:

```
Print service:
  Outputs text for debugging
  Not included in production
  Helps development

Behavior:
  Writes to debug console
  Not part of proof
  Development only
```

### Trace Service

Execution tracing:

```
Trace service:
  Records debug information
  Captures state snapshots
  Development aid

Properties:
  High overhead
  Detailed information
  Disabled in production
```

## Service Implementation

### Instruction Mapping

How services map to execution:

```
Implementation options:
  Special instruction opcode
  Reserved instruction pattern
  Emulated instruction

Execution:
  Detected by emulator
  Handled specially
  Result provided
```

### State Updates

How services affect state:

```
State changes:
  Register updates (result)
  Memory updates (I/O)
  Internal state (positions)

Tracing:
  All changes recorded
  Part of execution trace
  Proven in constraints
```

### Constraint Representation

Proving service correctness:

```
Constraint aspects:
  Correct service dispatch
  Proper argument handling
  Valid state updates
  Correct result production

Complexity:
  Simple services = few constraints
  Complex services = more constraints
```

## Service Patterns

### Streaming I/O

Efficient data transfer:

```
Streaming pattern:
  Read/write in chunks
  Process incrementally
  Avoid large buffers

Benefits:
  Memory efficiency
  Natural for proofs
  Matches common patterns
```

### Buffered Operations

Batching service calls:

```
Buffering pattern:
  Collect operations
  Execute in batch
  Reduce overhead

Trade-offs:
  Fewer service calls
  More complex logic
  Delayed effects
```

### Error Checking

Handling service failures:

```
Error checking pattern:
  Check return values
  Handle errors explicitly
  Graceful degradation

Important because:
  No exceptions
  Manual error handling
  Explicit control flow
```

## Service Limitations

### No Blocking

Services return immediately:

```
Non-blocking design:
  All services synchronous
  No waiting for events
  Immediate results

Implication:
  All data available upfront
  No interactive I/O
  Batch processing model
```

### No External Access

Services are self-contained:

```
Contained execution:
  No file system
  No network
  No inter-process communication
  No hardware access

Reason:
  Determinism required
  Proof isolation
  Verifiable execution
```

### Limited State

Minimal service state:

```
State limitations:
  Only essential tracking
  No complex structures
  Bounded state size

Design:
  Stateless when possible
  Minimal state when needed
```

## Key Concepts

- **System service**: Runtime-provided functionality
- **Service interface**: Mechanism for accessing services
- **Core services**: Essential services (exit, I/O, allocation)
- **Deterministic services**: Reproducible service behavior
- **Constraint representation**: How services appear in proofs
- **Service limitations**: What services cannot do

## Design Trade-offs

### Functionality vs Complexity

| Rich Services | Minimal Services |
|---------------|------------------|
| More capability | Less capability |
| More constraints | Fewer constraints |
| Slower proving | Faster proving |
| Easier programming | More manual work |

### Generality vs Efficiency

| General Services | Specialized Services |
|-----------------|---------------------|
| Flexible use | Specific use cases |
| Higher overhead | Lower overhead |
| Fewer services | More services |
| Learning curve | Optimized paths |

### Safety vs Performance

| Safe Services | Fast Services |
|---------------|---------------|
| Bounds checking | No checking |
| Error handling | Assume success |
| Validated inputs | Trust inputs |
| More constraints | Fewer constraints |

## Related Topics

- [Runtime Architecture](01-runtime-architecture.md) - Overall runtime design
- [Boot Sequence](02-boot-sequence.md) - Initialization
- [Input Processing](../03-io-handling/01-input-processing.md) - I/O details
- [Bump Allocator](../02-memory-allocation/01-bump-allocator.md) - Memory allocation
- [System Calls](../../06-emulation-layer/02-execution-context/03-system-calls.md) - Call implementation

