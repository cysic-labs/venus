# System Calls

## Overview

System calls provide the interface between user programs and the zkVM environment. When a program needs to perform I/O, allocate memory, or communicate with the outside world, it invokes a system call. In a traditional operating system, system calls transfer control to the kernel. In a zkVM, system calls are handled by the proving environment, which must faithfully record the program's requests and the environment's responses.

The system call mechanism uses the RISC-V ECALL instruction to transfer control. Arguments are passed in registers following the RISC-V calling convention, and return values are placed in designated registers. The zkVM must constrain that system call handling is deterministic and verifiable, with public inputs and outputs clearly specified for the verifier.

This document covers system call semantics, common system calls, constraint patterns, and I/O handling in the zkVM context.

## System Call Mechanism

### ECALL Instruction

Triggering system calls:

```
ECALL instruction:
  Encoding: 0x00000073
  No operands in instruction itself
  Arguments in registers

Register convention (RISC-V ABI):
  a7 (x17): System call number
  a0-a5 (x10-x15): Arguments
  a0 (x10): Return value

Execution:
  Program places arguments in registers
  Executes ECALL
  Environment handles system call
  Return value placed in a0
  Execution resumes after ECALL
```

### System Call Flow

Step-by-step execution:

```
Step 1: Argument setup
  Program sets a7 = syscall_number
  Program sets a0-a5 = arguments

Step 2: ECALL execution
  CPU encounters ECALL instruction
  Transfers control to handler

Step 3: Handler processing
  zkVM environment reads arguments
  Performs requested action
  Determines return value

Step 4: Return
  Return value placed in a0
  Error code in a0 (negative for error)
  PC advanced past ECALL

Step 5: Continuation
  Program reads return value
  Continues execution
```

### Handler Implementation

zkVM system call handling:

```
Handler dispatch:
  switch (a7):
    case SYS_exit: handle_exit()
    case SYS_read: handle_read()
    case SYS_write: handle_write()
    case SYS_brk: handle_brk()
    ...

Handler responsibilities:
  Validate arguments
  Perform action (may involve external input)
  Record for proving
  Set return value
```

## Common System Calls

### Exit (SYS_exit)

Terminating execution:

```
System call: exit
  Number: 93 (Linux convention)
  Arguments: a0 = exit_code
  Return: Does not return

Semantics:
  Terminates program execution
  Exit code becomes public output
  Proving continues to completion

Constraint:
  After exit, execution halted
  No more instructions
  Exit code recorded
```

### Read (SYS_read)

Reading input data:

```
System call: read
  Number: 63
  Arguments:
    a0 = fd (file descriptor)
    a1 = buf (buffer address)
    a2 = count (bytes to read)
  Return: Bytes read, or error

File descriptors:
  0 (stdin): Primary input source

Semantics:
  Read up to count bytes from fd
  Write to memory at buf
  Return number of bytes read

zkVM handling:
  Input from public/private input stream
  Bytes written to memory
  Memory operations recorded
```

### Write (SYS_write)

Writing output data:

```
System call: write
  Number: 64
  Arguments:
    a0 = fd (file descriptor)
    a1 = buf (buffer address)
    a2 = count (bytes to write)
  Return: Bytes written, or error

File descriptors:
  1 (stdout): Standard output
  2 (stderr): Error output

Semantics:
  Read count bytes from buf in memory
  Write to fd (often becomes public output)
  Return number of bytes written

zkVM handling:
  Data read from memory
  Output becomes provable commitment
  May be public for verification
```

### Memory Allocation (SYS_brk)

Heap management:

```
System call: brk
  Number: 214
  Arguments: a0 = addr (new break)
  Return: New break address, or error

Semantics:
  Set program break (heap end)
  addr = 0: Query current break
  addr > current: Expand heap
  addr < current: Contract heap

zkVM handling:
  Track heap bounds
  Constrain memory access within bounds
  Initialize new memory to zero
```

### Memory Map (SYS_mmap)

Memory mapping:

```
System call: mmap
  Number: 222
  Arguments:
    a0 = addr (suggested address)
    a1 = length (size)
    a2 = prot (protection)
    a3 = flags
    a4 = fd
    a5 = offset
  Return: Mapped address, or error

Common use:
  Anonymous mapping (no file)
  Allocate large memory regions

zkVM handling:
  Allocate memory region
  Track valid address ranges
  Initialize as appropriate
```

## I/O Handling

### Input Streams

Providing program input:

```
Input sources:
  Public input: Known to verifier
  Private input: Known only to prover

Read system call:
  Fetches from appropriate stream
  Bytes become memory content
  Input commitment for verification

Constraint:
  Input commitment matches claimed input
  Memory correctly populated
```

### Output Streams

Capturing program output:

```
Output destinations:
  Public output: Committed in proof
  Log output: For debugging (not verified)

Write system call:
  Captures output data
  Commitment for public output
  Verifier can check output

Constraint:
  Output commitment matches written data
  Deterministic output for same input
```

### Deterministic I/O

Ensuring reproducibility:

```
Requirement:
  Same input → Same output
  No external randomness

Enforced by:
  Fixed input streams
  Deterministic syscall handling
  No clock/time access

Constraint:
  I/O operations reproducible
  Proof verifiable with same public inputs
```

## Constraint Patterns

### System Call Detection

Identifying ECALL:

```
Constraint:
  is_ecall = (instruction == 0x00000073)

When is_ecall = 1:
  Read a7 for syscall number
  Read a0-a5 for arguments
  Handle based on syscall number
```

### Syscall Dispatch

Routing to handler:

```
Selectors:
  is_exit = is_ecall * (a7 == 93)
  is_read = is_ecall * (a7 == 63)
  is_write = is_ecall * (a7 == 64)
  is_brk = is_ecall * (a7 == 214)

Constraint:
  Each handler's constraints activated by selector
```

### Return Value

Setting result:

```
For each syscall type:
  is_exit * (return not applicable)
  is_read * (a0_next = bytes_read)
  is_write * (a0_next = bytes_written)
  is_brk * (a0_next = new_break)

Error handling:
  On error: a0_next = negative error code
```

### Input/Output Commitments

Linking to public data:

```
Input commitment:
  hash(input_stream) in public inputs
  Read operations consistent with stream

Output commitment:
  hash(output_stream) in public outputs
  Write operations produce stream

Constraint:
  Stream progression matches operations
  Final commitments match claimed values
```

## Unsupported System Calls

### Handling Unknown Syscalls

When syscall not supported:

```
Options:
  1. Return error (-ENOSYS)
  2. Trap/abort
  3. Ignore (return 0)

Constraint:
  is_unknown_syscall * (a0_next = -38)  // ENOSYS

Program responsibility:
  Check return values
  Handle errors appropriately
```

### Stubbed System Calls

Minimal implementations:

```
Non-essential syscalls:
  getpid: Return fixed value (e.g., 1)
  gettid: Return fixed value
  clock_gettime: Return fixed value or error

Constraint:
  Deterministic stub return values
  No actual functionality
```

## Key Concepts

- **System call**: Interface to zkVM environment
- **ECALL**: Instruction triggering system call
- **File descriptor**: I/O stream identifier
- **Public input/output**: Verifiable I/O data
- **Determinism**: Same input produces same output

## Design Considerations

### Syscall Support

| Minimal | Comprehensive |
|---------|---------------|
| exit, read, write | Full POSIX-like |
| Simple programs | Complex programs |
| Fewer constraints | More constraints |
| Limited compatibility | High compatibility |

### I/O Model

| Public I/O | Private I/O |
|------------|-------------|
| Verifier sees data | Hidden from verifier |
| Committed in proof | Not committed |
| Transparency | Privacy |
| Larger proof | Smaller proof |

## Related Topics

- [Input/Output Handling](02-io-handling.md) - Detailed I/O mechanisms
- [Exception Handling](03-exception-handling.md) - Error processing
- [Instruction Set Support](../01-risc-v-emulation/01-instruction-set-support.md) - ECALL instruction
- [Memory Emulation](../01-risc-v-emulation/03-memory-emulation.md) - Memory for I/O buffers
