# Compilation Target

## Overview

A compilation target defines the characteristics of the system for which code is compiled. For zkVM environments, the compilation target specifies how programs should be built to execute correctly within the virtual machine and produce provable execution traces. Unlike traditional targets that describe physical hardware, a zkVM target describes a virtual execution environment optimized for proof generation.

The compilation target encompasses processor architecture, memory model, calling conventions, and execution constraints. Compilers use this information to generate appropriate machine code, make optimization decisions, and structure program output. A well-defined target enables standard programming languages and tools to produce zkVM-compatible programs.

This document covers compilation target concepts, zkVM-specific considerations, and how targets influence program compilation for provable execution.

## Target Fundamentals

### What Defines a Target

Target specification components:

```
Target components:
  Architecture: Instruction set family
  Data model: Integer sizes
  Endianness: Byte ordering
  ABI: Calling conventions
  Features: Available extensions
```

### Target Triple

Standard target identification:

```
Triple format:
  architecture-vendor-operating_system

zkVM example components:
  Architecture: RISC-V variant
  Vendor: Platform identifier
  OS: Runtime/bare-metal
```

### Target vs Host

Distinguishing compilation contexts:

```
Host: Where compiler runs
  Developer machine
  Standard operating system
  Native toolchain

Target: Where code executes
  zkVM environment
  Emulator or prover
  Constrained resources
```

## Architecture Specification

### Instruction Set

Base instruction set selection:

```
ISA considerations:
  Base instruction set (e.g., RV32I)
  Available extensions
  Instruction encoding
  Register count

zkVM factors:
  Constraint-friendly instructions
  Extension support cost
  Transpilation requirements
```

### Word Size

Native integer width:

```
Word size options:
  32-bit: Smaller state, limited range
  64-bit: Larger state, more capable

Trade-offs:
  Smaller: Fewer constraints per operation
  Larger: More expressive, wider values
```

### Endianness

Byte ordering:

```
Endianness:
  Little-endian: LSB at lowest address
  Big-endian: MSB at lowest address

Standard choice:
  Little-endian most common
  Match expected conventions
  Consistent with hardware targets
```

## Memory Model

### Address Space

Memory addressing characteristics:

```
Address space:
  32-bit: 4GB addressable
  64-bit: Much larger range

zkVM considerations:
  Actual memory much smaller
  Address space mostly unused
  Virtual addresses
```

### Memory Regions

Expected memory layout:

```
Standard regions:
  Code/text segment
  Read-only data
  Initialized data
  Uninitialized data (BSS)
  Heap
  Stack
```

### Alignment Requirements

Data alignment rules:

```
Alignment rules:
  Natural alignment preferred
  Word alignment for efficiency
  Stricter for some operations

Enforcement:
  Compiler generates aligned access
  Runtime may check
  Constraints verify
```

## Calling Convention

### Register Usage

How registers are allocated:

```
Register roles:
  Argument registers
  Return value registers
  Caller-saved registers
  Callee-saved registers
  Special-purpose registers
```

### Parameter Passing

How arguments are passed:

```
Passing mechanisms:
  First N arguments in registers
  Additional arguments on stack
  Large values by reference

Convention compliance:
  Must match runtime expectations
  Library interoperability
```

### Return Convention

How values are returned:

```
Return mechanisms:
  Small values in registers
  Large values via pointer
  Multiple values handled

Consistency:
  All code follows same convention
  Enables linking
```

## ABI Specification

### Application Binary Interface

Complete interface specification:

```
ABI includes:
  Calling convention
  Data type sizes and alignment
  System call interface
  Object file format
  Debug information format
```

### Data Type Sizes

Size of fundamental types:

```
Typical sizes:
  char: 1 byte
  short: 2 bytes
  int: 4 bytes
  long: 4 or 8 bytes
  pointer: 4 or 8 bytes
```

### Structure Layout

How structures are organized:

```
Layout rules:
  Member alignment
  Padding between members
  Total structure alignment
  Bit field handling
```

## Feature Selection

### Extension Selection

Choosing ISA extensions:

```
Extension considerations:
  Standard extensions available
  Cost of supporting each
  Benefit for programs

Common choices:
  M extension: Integer multiply/divide
  A extension: Atomics (maybe)
  F/D extension: Floating-point (maybe)
```

### Feature Trade-offs

Balancing features:

```
Trade-off factors:
  More features: More capable
  More features: More constraint complexity
  Fewer features: Simpler proving
  Fewer features: Less compatibility
```

## Runtime Expectations

### Entry Point

Program start requirements:

```
Entry point:
  Known start symbol
  Initial state expectations
  Stack setup done
  Arguments available
```

### Runtime Support

Expected runtime services:

```
Runtime provides:
  Memory allocation
  I/O operations
  Exit mechanism

Program assumes:
  Services available
  Known interface
```

### Standard Library

Library availability:

```
Library considerations:
  Full standard library?
  Subset available?
  Custom implementations?

zkVM typical:
  Minimal runtime
  No system calls to OS
  Specialized libraries
```

## Optimization Levels

### Optimization Goals

What optimizations target:

```
Traditional goals:
  Execution speed
  Code size
  Memory usage

zkVM goals:
  Constraint count
  Trace size
  Proving time
  Still correct execution
```

### Size Optimization

Minimizing code:

```
Size optimization:
  Smaller binaries
  Less ROM needed
  Fewer instruction bytes

Techniques:
  Code compression
  Function merging
  Dead code elimination
```

### Constraint-Aware Optimization

Optimizing for proofs:

```
Constraint optimization:
  Prefer simple operations
  Avoid constraint-heavy patterns
  Consider proving cost

Examples:
  Prefer shifts over division
  Avoid unaligned access
  Minimize memory operations
```

## Bare-Metal Considerations

### No Operating System

Bare-metal execution:

```
No OS means:
  No kernel services
  Direct hardware (VM) access
  Custom runtime only
  No dynamic linking
```

### Startup Requirements

Bare-metal startup:

```
Startup responsibilities:
  Initialize runtime state
  Set up stack
  Clear BSS
  Call main

No OS assistance:
  Startup code explicit
  Everything visible
```

### Resource Management

Self-managed resources:

```
Managed by program:
  Memory allocation
  I/O buffers
  Any state

No OS to help:
  No lazy allocation
  No memory protection (soft)
  Explicit management
```

## Cross-Compilation

### Build Environment

Cross-compilation setup:

```
Cross-compilation:
  Build on host system
  Target different architecture
  Specialized toolchain

Requirements:
  Target-aware compiler
  Target libraries
  Linker for target
```

### Toolchain Components

Cross-toolchain parts:

```
Components:
  Compiler (generates target code)
  Assembler (assembles target asm)
  Linker (links target objects)
  Libraries (for target)
```

### Build Configuration

Configuring builds:

```
Configuration aspects:
  Target specification
  Include paths
  Library paths
  Compiler flags
```

## Key Concepts

- **Compilation target**: Specification of target system
- **Target triple**: Standard target identification
- **ABI**: Application binary interface
- **Calling convention**: How functions communicate
- **Bare-metal**: Execution without OS
- **Cross-compilation**: Building for different target

## Design Trade-offs

### Compatibility vs Simplicity

| Compatible Target | Simple Target |
|-------------------|---------------|
| Standard conventions | Custom conventions |
| Existing tools work | May need custom tools |
| More complexity | Less complexity |
| Broader applicability | Specific use cases |

### Features vs Constraint Cost

| Feature-Rich | Minimal Features |
|--------------|-----------------|
| More capable | More limited |
| More constraints | Fewer constraints |
| Easier programming | More manual work |
| Slower proving | Faster proving |

### Standard vs Custom ABI

| Standard ABI | Custom ABI |
|--------------|------------|
| Tool compatibility | Custom tools needed |
| Known conventions | Optimized conventions |
| Library reuse | Custom libraries |
| Wider ecosystem | Specific optimization |

## Related Topics

- [Linker Scripts](02-linker-scripts.md) - Memory layout control
- [Build Process](03-build-process.md) - Compilation workflow
- [RISC-V Fundamentals](../../04-zkvm-architecture/01-isa-integration/01-risc-v-fundamentals.md) - Base architecture
- [Memory Layout](../../04-zkvm-architecture/03-memory-model/01-memory-layout.md) - Address space organization

