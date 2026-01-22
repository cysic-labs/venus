# Emulator Design

## Overview

The emulator is the component that executes RISC-V programs and generates the execution traces needed for proof generation. Unlike a traditional CPU emulator focused on performance, the zkVM emulator prioritizes accurate state recording and deterministic execution. Every register access, memory operation, and computational step must be captured in a form suitable for constraint verification.

The emulator design balances execution speed with traceability. While emulation is much faster than proving, it still represents a significant portion of end-to-end proving time. The architecture must enable efficient trace generation while maintaining the precision needed for correct proof construction.

This document covers the emulator's architectural design, execution model, and interface with the proving system.

## Design Goals

### Primary Objectives

What the emulator must achieve:

```
Correctness:
  Faithful RISC-V semantics
  Precise state tracking
  Deterministic execution

Traceability:
  Complete state capture
  Efficient trace format
  Minimal overhead

Performance:
  Fast emulation
  Low memory footprint
  Scalable to large programs
```

### Non-Goals

What the emulator does not optimize for:

```
Not prioritized:
  Real-time performance
  Hardware compatibility
  Full system emulation
  Debug features (unless needed)
```

## Architecture Overview

### Component Structure

Major emulator components:

```
Core components:
  Instruction fetch unit
  Decode unit
  Execution unit
  Register file
  Memory subsystem

Tracing components:
  State recorder
  Trace buffer
  Commitment generator

Control:
  Execution controller
  Segment manager
  Termination handler
```

### Data Flow

How data moves through the emulator:

```
Execution flow:
  1. Fetch instruction from ROM
  2. Decode instruction fields
  3. Read source registers
  4. Execute operation
  5. Write result register
  6. Record state change
  7. Advance PC

Trace flow:
  State changes → Recorder → Buffer → Output
```

## Execution Model

### Instruction Cycle

Single instruction execution:

```
Cycle phases:
  Fetch: Load instruction at PC
  Decode: Parse opcode, operands
  Execute: Perform operation
  Writeback: Update registers/memory
  Record: Capture for trace

Timing:
  All phases for each instruction
  Sequential processing typical
```

### State Management

Tracking machine state:

```
State components:
  PC: Current instruction address
  Registers: x0-x31 values
  Memory: Address-value mappings
  Flags: Execution status

State capture:
  Before and after each instruction
  Minimal delta recording
  Efficient representation
```

### Determinism

Ensuring reproducible execution:

```
Requirements:
  Same input → Same trace
  No external randomness
  Defined undefined behavior

Challenges:
  Uninitialized memory
  Undefined operations
  External inputs
```

## Memory Architecture

### Memory Model

How memory is organized:

```
Regions:
  ROM: Program code
  RAM: Data memory
  Registers: CPU registers
  I/O: Input/output buffers

Access:
  Word-aligned for performance
  Sub-word via masking
  Bounds checking
```

### Address Translation

Mapping addresses to storage:

```
Simple model:
  Direct mapping
  No virtual memory
  Physical addresses only

Bounds:
  Valid address ranges
  Region-based access control
```

### Memory Recording

Capturing memory operations:

```
Per operation:
  Operation type (read/write)
  Address
  Value (before/after)
  Timestamp

Optimization:
  Only record changes
  Coalesce adjacent accesses
```

## Register File

### Register Implementation

32 general-purpose registers:

```
Register array:
  x0-x31 storage
  32-bit values (RV32)
  x0 hardwired to zero

Access:
  Two reads per instruction typical
  One write per instruction
  Same-cycle read-after-write
```

### Register Recording

Capturing register state:

```
Per instruction:
  Source register values
  Destination register update
  Complete state optional

Optimization:
  Record only changed register
  Derive full state from deltas
```

## Instruction Processing

### Fetch Unit

Retrieving instructions:

```
Fetch process:
  Read 32 bits at PC
  Handle alignment
  Check bounds

ROM interface:
  Indexed by PC
  Returns instruction word
```

### Decode Unit

Parsing instructions:

```
Decode process:
  Extract opcode (bits 6:0)
  Determine format
  Extract operands per format

Output:
  Opcode identifier
  Source registers
  Destination register
  Immediate value
```

### Execution Unit

Performing operations:

```
Operation types:
  ALU operations
  Memory operations
  Control flow

Implementation:
  Switch on opcode
  Call specific handler
  Return result
```

## Trace Generation

### Trace Format

How traces are structured:

```
Per-instruction record:
  PC value
  Instruction word
  Operand values
  Result value
  Memory operations
```

### Buffering

Managing trace data:

```
Buffer structure:
  Fixed-size chunks
  Flush when full
  Sequential writes

Memory management:
  Bounded buffer size
  Stream to disk if needed
```

### Compression

Reducing trace size:

```
Techniques:
  Delta encoding
  Value compression
  Omit unchanged state

Trade-off:
  Smaller traces
  More processing
```

## Interface Design

### Input Interface

Providing input to emulator:

```
Inputs:
  Program binary (ELF)
  Input data
  Configuration

Loading:
  Parse ELF sections
  Initialize memory
  Set entry point
```

### Output Interface

Retrieving results:

```
Outputs:
  Execution trace
  Final state
  Program output

Format:
  Trace for prover
  State for verification
  Output for user
```

### Control Interface

Managing execution:

```
Controls:
  Start/stop execution
  Step mode
  Breakpoints (debug)

Queries:
  Current state
  Execution statistics
```

## Performance Optimization

### Interpretation Techniques

Fast instruction execution:

```
Direct interpretation:
  Switch-case dispatch
  Simple but branchy

Threaded interpretation:
  Computed goto
  Better branch prediction

JIT compilation:
  Compile hot paths
  Complex implementation
```

### Memory Optimization

Efficient memory handling:

```
Techniques:
  Page-based allocation
  Copy-on-write
  Sparse arrays

Caching:
  Recently accessed values
  Decode cache
```

### Trace Optimization

Efficient trace generation:

```
Techniques:
  Lazy state capture
  Batched writes
  Parallel recording
```

## Key Concepts

- **Emulator**: Software executing RISC-V for trace generation
- **Deterministic execution**: Same inputs always produce same trace
- **State recording**: Capturing all state changes
- **Trace generation**: Producing prover-ready execution record
- **Segment management**: Dividing long executions

## Design Trade-offs

### Speed vs Traceability

| Fast Execution | Full Tracing |
|----------------|--------------|
| Skip recording | Record everything |
| Limited debug | Complete visibility |
| Higher throughput | Lower throughput |

### Memory vs Disk

| In-Memory | Streaming |
|-----------|-----------|
| Fast access | Bounded memory |
| Size limited | Disk I/O overhead |
| Simple | Complex |

## Related Topics

- [Instruction Execution](02-instruction-execution.md) - Executing operations
- [Trace Capture](03-trace-capture.md) - Recording execution
- [Two-Phase Execution](../03-witness-generation/01-two-phase-execution.md) - Execution strategy
- [Execution Trace](../../04-zkvm-architecture/04-execution-model/02-execution-trace.md) - Trace format

