# Memory Layout

## Overview

Memory layout defines how the zkVM organizes its address space into regions with distinct purposes and behaviors. A well-designed layout separates code from data, provides stack and heap areas, and designates special regions for registers, input/output, and program constants. Understanding the memory layout is essential for both writing programs that execute correctly and implementing the constraint systems that prove memory operations.

The zkVM memory layout balances several concerns: compatibility with RISC-V conventions, efficiency for proving memory operations, clear boundaries for different data types, and flexibility for various program sizes. Each region has specific access patterns that influence how memory consistency proofs are structured.

This document describes the logical organization of memory, the purpose of each region, and how the layout enables efficient zero-knowledge proof generation.

## Address Space Organization

### 32-bit Address Space

The zkVM uses a 32-bit address space, providing 4 GB of addressable memory:

```
Full address space:
  0x0000_0000 to 0xFFFF_FFFF
  4,294,967,296 bytes total
  Divided into regions by address ranges

Practical usage:
  Not all addresses are valid
  Programs use much less than 4 GB
  Invalid access triggers traps
```

### Region Boundaries

Major divisions of the address space:

```
Typical layout:
  0x0000_0000 - 0x0000_007F: Registers (x0-x31)
  0x0000_1000 - 0x????_????: Program code (ROM)
  0x????_???? - 0x????_????: Static data
  0x????_???? - 0x????_????: Heap (grows up)
  0x????_???? - 0x7FFF_FFFF: Stack (grows down)
  0x8000_0000 - 0x????_????: Input buffer
  0x????_???? - 0xFFFF_FFFF: Output/special regions

Note: Exact boundaries depend on configuration
```

## Register Region

### Register Mapping

Registers as memory addresses:

```
Register addresses:
  x0:  0x0000_0000 (always reads as 0)
  x1:  0x0000_0004 (ra - return address)
  x2:  0x0000_0008 (sp - stack pointer)
  ...
  x31: 0x0000_007C

Properties:
  32 registers × 4 bytes = 128 bytes
  Word-aligned access only
  Special handling for x0
```

### Register Access Semantics

How register memory behaves:

```
Read behavior:
  Returns current register value
  x0 always returns 0
  Same as reg[N] in traditional model

Write behavior:
  Updates register value
  x0 writes ignored
  Affects subsequent reads

Timing:
  Write takes effect immediately
  Next instruction sees new value
  No write-back delay
```

## Program Code Region (ROM)

### Code Placement

Where instructions reside:

```
Code region:
  Starts at fixed base address
  Contains all program instructions
  Read-only during execution

Addressing:
  PC points into this region
  Instructions word-aligned
  Sequential layout typical
```

### Section Organization

Code structure within ROM:

```
Sections:
  .text: Executable code
  .rodata: Read-only data (constants)

Layout:
  Base address (e.g., 0x1000)
  Entry point (e.g., _start)
  Functions laid out sequentially

Read-only enforcement:
  Writes to ROM region trapped
  Or: write constraints fail
```

## Data Memory Regions

### Static Data

Initialized and uninitialized data:

```
.data section:
  Initialized global variables
  Known values at program start
  May be read and written

.bss section:
  Uninitialized globals
  Zero-initialized
  Read and written

Placement:
  After code section
  Before heap
  Fixed size per program
```

### Heap Region

Dynamic memory allocation:

```
Heap properties:
  Grows upward in memory
  Managed by allocator
  Size limited by configuration

Layout:
  Starts after static data
  Extends toward stack
  Expansion via sbrk/brk equivalent

Allocation tracking:
  Program manages heap
  Allocator in runtime library
  No hardware heap support
```

### Stack Region

Function call frames and local data:

```
Stack properties:
  Grows downward in memory
  SP (x2) tracks current position
  Frame pointer (x8) optional

Layout:
  Top of usable RAM
  Grows toward heap
  Stack overflow if meets heap

Per-call frame:
  Return address
  Saved registers
  Local variables
  Arguments (overflow)
```

## Input/Output Regions

### Input Buffer

Where program inputs reside:

```
Input region:
  Contains data provided to program
  Read-only during execution
  Size varies by input

Access pattern:
  Program reads input data
  Typically sequential
  Treated as public or private input

Proving:
  Input commitment provided
  Reads verified against commitment
```

### Output Buffer

Where program outputs are written:

```
Output region:
  Receives computation results
  Written during execution
  Becomes public output

Access pattern:
  Sequential writes typical
  Final state is output

Proving:
  Output included in proof
  Verifier checks expected output
```

### Public Values

Special output handling:

```
Public value concept:
  Specific outputs visible to verifier
  Part of proof's public interface

Implementation:
  Designated memory region
  Or: explicit output instructions

Verification:
  Public values in proof
  Verifier sees and checks
```

## Memory Initialization

### Initial State

Memory state at program start:

```
Initialization:
  Registers: x0 = 0, others as specified
  Code: loaded from program binary
  Data: .data initialized, .bss zeroed
  Heap: empty (or initialized)
  Stack: SP set to stack top
  Input: loaded from provided input

Commitment:
  Initial state committed
  Forms basis for proof
```

### Runtime Initialization

Setup before main program:

```
Boot sequence:
  Set up stack pointer
  Initialize global pointer
  Copy .data if needed
  Clear .bss
  Call main/entry point

Runtime code:
  Minimal startup code
  May be in ROM
  Executes before user code
```

## Alignment Requirements

### Word Alignment

Basic alignment rules:

```
Word access (4 bytes):
  Address mod 4 = 0
  Addresses: 0, 4, 8, 12, ...

Halfword access (2 bytes):
  Address mod 2 = 0
  Addresses: 0, 2, 4, 6, ...

Byte access (1 byte):
  Any address valid
  No alignment requirement
```

### Misalignment Handling

When alignment is violated:

```
Options:
  Hardware trap
  Software emulation
  Constraint failure

zkVM approach:
  Typically require alignment
  Simplifies memory constraints
  Compiler ensures alignment
```

## Boundary Protection

### Region Access Rights

What operations each region allows:

```
Access matrix:
  Region     | Read | Write | Execute
  -----------|------|-------|--------
  Registers  |  Y   |  Y    |    N
  ROM        |  Y   |  N    |    Y
  RAM (.data)|  Y   |  Y    |    N
  Heap       |  Y   |  Y    |    N
  Stack      |  Y   |  Y    |    N
  Input      |  Y   |  N    |    N
  Output     |  Y   |  Y    |    N
```

### Bounds Checking

Validating memory accesses:

```
Checks:
  Address within valid region
  Access type permitted
  Alignment satisfied

Enforcement:
  Constraint violation for invalid access
  Or: trap handler invoked

Proving:
  Range constraints on addresses
  Access type constraints
```

## Memory for State Machines

### Region Separation for Proving

How layout aids proof construction:

```
Separate handling:
  Registers: high-frequency, dedicated columns
  ROM: read-only, commitment-based
  RAM: read-write, full consistency

Optimization:
  Different proof techniques per region
  Exploit read-only nature of ROM
  Dedicated register handling
```

### Address Discrimination

Distinguishing regions by address:

```
Region identification:
  Check address range
  Dispatch to appropriate handler

Constraint approach:
  is_register = (addr < 0x80)
  is_rom = (addr >= 0x1000) AND (addr < code_end)
  is_ram = (addr >= data_start) AND (addr < heap_end)

Mutually exclusive:
  Address in exactly one region
  Or: invalid access
```

## Memory Layout Configuration

### Configurable Parameters

What can be adjusted:

```
Configuration options:
  Code base address
  Stack size
  Heap size limit
  Input/output buffer sizes

Determined by:
  Program requirements
  Prover constraints
  Maximum proof size
```

### Layout Computation

How boundaries are determined:

```
At load time:
  Parse program size
  Determine data sizes
  Calculate region boundaries
  Set stack pointer

Result:
  Specific addresses for this program
  Memory map for proving
```

## Virtual vs Physical Memory

### Single Address Space

No virtualization in base zkVM:

```
Simple model:
  Virtual = Physical
  No page tables
  No address translation

Benefits:
  Simpler proving
  Less overhead
  Direct memory model
```

### Implications

What this means for programs:

```
No memory protection between processes:
  Single program execution
  No process isolation needed

No demand paging:
  All memory allocated upfront
  No page faults

No kernel/user distinction:
  Single privilege level
  All memory accessible
```

## Key Concepts

- **Memory layout**: Organization of address space into regions
- **Register region**: Memory-mapped CPU registers
- **ROM**: Read-only program code storage
- **RAM**: Read-write data memory (heap, stack, data)
- **I/O regions**: Input and output buffer areas
- **Alignment**: Access size determining valid addresses

## Design Trade-offs

### Fixed vs Dynamic Layout

| Fixed Layout | Dynamic Layout |
|--------------|----------------|
| Simpler proofs | Flexible sizing |
| Predictable addresses | Per-program optimization |
| Less configuration | More overhead |

### Region Granularity

| Few Large Regions | Many Small Regions |
|-------------------|--------------------|
| Simpler constraints | Fine-grained control |
| Less flexibility | More complex proofs |
| Easier management | Better optimization |

## Related Topics

- [Memory Consistency](02-memory-consistency.md) - Proving correct memory behavior
- [Aligned Access](03-aligned-access.md) - Alignment requirements and handling
- [Memory Timestamping](04-memory-timestamping.md) - Ordering memory operations
- [Memory State Machine](../02-state-machine-design/05-memory-state-machine.md) - Memory operation handling

