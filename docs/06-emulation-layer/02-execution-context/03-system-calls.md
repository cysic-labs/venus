# System Calls

## Overview

System calls provide the interface between user programs and the zkVM runtime. When a program needs services beyond basic computation—reading input, writing output, or invoking precompiles—it uses the ECALL instruction to request these services. The emulator handles system calls by dispatching to appropriate handlers and managing the interaction with the runtime environment.

Unlike traditional operating systems where system calls access hardware or kernel services, zkVM system calls typically handle I/O, precompile invocation, and execution control. Each system call must be emulated correctly and recorded in the trace for proving.

This document covers system call semantics, implementation, and integration with the proving system.

## System Call Interface

### Invocation

How programs make system calls:

```
ECALL instruction:
  Triggers system call
  No immediate operand

Arguments:
  a7 (x17): System call number
  a0-a6: Arguments

Return:
  a0: Return value
  a1: Secondary return (if needed)
```

### Call Numbers

System call identifiers:

```
Common calls:
  read_input: Read from input buffer
  write_output: Write to output buffer
  invoke_precompile: Call precompile
  exit: Terminate execution

Numbering:
  Platform-specific
  Documented in ABI
```

## Input/Output

### Reading Input

Getting data from input buffer:

```
read(buffer, length):
  Arguments:
    a0: Destination buffer address
    a1: Number of bytes to read

  Return:
    a0: Bytes actually read

  Behavior:
    Copy from input buffer to memory
    Advance input pointer
```

### Writing Output

Producing program output:

```
write(buffer, length):
  Arguments:
    a0: Source buffer address
    a1: Number of bytes to write

  Return:
    a0: Bytes written

  Behavior:
    Copy from memory to output buffer
    Advance output pointer
```

### Public Values

Writing public outputs:

```
commit_public(value):
  Arguments:
    a0: Value to make public

  Behavior:
    Record value as public output
    Part of proof public inputs
```

## Precompile Invocation

### Calling Precompiles

Invoking specialized circuits:

```
precompile(id, input, output):
  Arguments:
    a0: Precompile identifier
    a1: Input buffer address
    a2: Input length
    a3: Output buffer address

  Return:
    a0: Status (success/error)

  Behavior:
    Copy input data
    Execute precompile
    Copy result to output
```

### Precompile Examples

Available precompiles:

```
SHA256:
  Hash computation

KECCAK256:
  Ethereum hash

ECRECOVER:
  Signature recovery

BIG_INT:
  Large integer arithmetic
```

## Execution Control

### Program Exit

Terminating execution:

```
exit(code):
  Arguments:
    a0: Exit code

  Behavior:
    Mark execution complete
    Record exit status
    Stop emulation
```

### Panic/Abort

Abnormal termination:

```
panic():
  Behavior:
    Mark execution failed
    Record failure
    Stop emulation
```

## Implementation

### Dispatch

Handling ECALL:

```
On ECALL:
  1. Read syscall number from a7
  2. Read arguments from a0-a6
  3. Dispatch to handler
  4. Execute handler
  5. Place return in a0
  6. Advance PC
```

### Handlers

Individual syscall handlers:

```
Handler structure:
  Validate arguments
  Perform operation
  Update state
  Return result

Error handling:
  Return error code
  Set errno equivalent
```

## Trace Recording

### Syscall Traces

Recording system calls:

```
Per syscall:
  Call number
  Arguments
  Return value
  State changes

Memory effects:
  Reads performed
  Writes performed
```

### Input/Output Traces

I/O operation traces:

```
Input reads:
  Data provided
  Buffer address
  Length

Output writes:
  Data written
  Public values
```

## Error Handling

### Invalid Calls

Unknown system call:

```
Detection:
  Call number not recognized

Response:
  Return error code
  Or: trap handler
```

### Invalid Arguments

Bad syscall arguments:

```
Detection:
  Invalid addresses
  Bad lengths
  Permission violations

Response:
  Return error
  Or: trap
```

## Key Concepts

- **System calls**: Interface to runtime services
- **ECALL**: RISC-V instruction triggering syscalls
- **I/O operations**: Reading input, writing output
- **Precompile invocation**: Calling specialized circuits
- **Trace recording**: Capturing syscall effects

## Design Trade-offs

### Syscall Granularity

| Many Simple | Few Complex |
|-------------|-------------|
| Flexible | Simple |
| More calls | Fewer calls |
| Fine control | Coarse control |

### Error Handling

| Return Codes | Exceptions |
|--------------|------------|
| Simple | Expressive |
| Manual checking | Automatic handling |
| No stack unwinding | Stack unwinding |

## Related Topics

- [Emulator Design](../01-emulator-architecture/01-emulator-design.md) - Architecture
- [Instruction Execution](../01-emulator-architecture/02-instruction-execution.md) - ECALL handling
- [Precompile Concepts](../../05-cryptographic-precompiles/01-precompile-design/01-precompile-concepts.md) - Precompiles
- [Memory Management](02-memory-management.md) - Memory for I/O

