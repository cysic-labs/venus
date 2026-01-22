# Compiler Integration

## Overview

Compiler integration enables standard programming languages to target the zkVM. Developers write code in familiar languages like Rust or C, and the compiler produces RISC-V binaries suitable for zkVM execution. This approach leverages existing compiler infrastructure, language ecosystems, and developer expertise while abstracting the complexities of the underlying proving system.

The toolchain typically involves multiple stages: language-specific frontend compilation, LLVM-based code generation targeting RISC-V, linking with zkVM-specific runtime libraries, and final binary preparation. Understanding this pipeline helps developers configure their build systems, debug compilation issues, and optimize output for proving. This document covers compiler toolchains, configuration, and integration patterns.

## Toolchain Components

### Language Frontend

Initial compilation stage:

```
Rust:
  rustc: Rust compiler
  Generates LLVM IR
  Applies Rust-specific optimizations

C/C++:
  clang: Clang compiler
  Generates LLVM IR
  C/C++ semantics

Other languages:
  Any language with LLVM backend
  Or direct RISC-V target
```

### LLVM Backend

Code generation:

```
LLVM components:
  Middle-end optimization
  Target-specific lowering
  RISC-V code generation

Target triple:
  riscv32-unknown-elf (32-bit)
  riscv64-unknown-elf (64-bit)

Output:
  RISC-V object files
  Assembly (optional)
```

### Linker

Combining objects:

```
Linker:
  lld or riscv-ld
  Combines object files
  Resolves symbols

Output:
  ELF executable
  Bare-metal or with runtime
```

### zkVM Runtime

Execution support:

```
Runtime components:
  Entry point (_start)
  System call interface
  I/O wrappers
  Memory allocator

Linking:
  Statically linked with program
  Provides zkVM integration
```

## Build Configuration

### Rust Configuration

Setting up Rust for zkVM:

```
Target setup:
  rustup target add riscv32im-unknown-none-elf

Cargo configuration (.cargo/config.toml):
  [build]
  target = "riscv32im-unknown-none-elf"

  [target.riscv32im-unknown-none-elf]
  rustflags = [
    "-C", "link-arg=-Tlink.ld",
    "-C", "target-feature=+m"
  ]
```

### Compiler Flags

Optimization and features:

```
Optimization:
  -O2: Balanced optimization
  -Os: Size optimization
  -O3: Maximum optimization

Features:
  +m: Multiply extension
  +a: Atomic extension (if needed)
  +c: Compressed instructions

No-std:
  #![no_std]
  Removes standard library
  Uses core library only
```

### Linker Script

Memory layout:

```
Linker script (link.ld):
  ENTRY(_start)

  MEMORY {
    RAM : ORIGIN = 0x10000000, LENGTH = 256M
  }

  SECTIONS {
    .text : { *(.text*) } > RAM
    .rodata : { *(.rodata*) } > RAM
    .data : { *(.data*) } > RAM
    .bss : { *(.bss*) } > RAM
    .heap : { ... } > RAM
    .stack : { ... } > RAM
  }
```

## Compilation Pipeline

### Source to Object

First compilation stage:

```
Source file:
  main.rs / main.c

Compilation:
  rustc --target riscv32im-unknown-none-elf main.rs
  # or
  clang --target=riscv32 -c main.c

Output:
  main.o (object file)
```

### Object to Executable

Linking stage:

```
Input:
  main.o + runtime.o + libraries

Linking:
  riscv32-unknown-elf-ld -T link.ld main.o runtime.o -o program.elf

Output:
  program.elf (executable)
```

### Executable to zkVM Input

Final preparation:

```
Processing:
  Extract loadable sections
  Prepare memory image
  Include metadata

Output:
  Binary for zkVM execution
  Entry point address
  Memory layout information
```

## Runtime Integration

### Entry Point

Program start:

```
Runtime entry (_start):
  Initialize stack
  Initialize heap
  Clear BSS
  Call main()
  Handle return (exit syscall)

Assembly:
  _start:
    la sp, __stack_top
    call __init_heap
    call main
    li a7, SYS_exit
    ecall
```

### System Calls

zkVM interface:

```
System call wrapper:
  fn syscall(num: usize, args: ...) -> usize {
    // a7 = syscall number
    // a0-a5 = arguments
    // ecall
    // a0 = return value
  }

Common syscalls:
  read(), write(), exit()
  Implemented in runtime library
```

### Memory Allocator

Heap management:

```
Allocator:
  Track heap pointer
  Simple bump allocator
  Or more sophisticated

Integration:
  Global allocator trait (Rust)
  malloc/free implementation (C)

Example:
  #[global_allocator]
  static ALLOCATOR: BumpAllocator = BumpAllocator::new();
```

## Optimization

### Size Optimization

Reducing binary size:

```
Flags:
  -Os: Optimize for size
  LTO: Link-time optimization
  Strip: Remove symbols

Rust:
  [profile.release]
  opt-level = 's'
  lto = true
  strip = true

Effect:
  Smaller binary
  Fewer instructions
  Faster proving
```

### Instruction Selection

Efficient code generation:

```
Considerations:
  Avoid expensive instructions when possible
  Use strength reduction
  Prefer simpler alternatives

Compiler usually handles:
  Division to multiplication
  Shift for power-of-2 multiply
  Branch optimization
```

### Inlining

Function call overhead:

```
Inlining benefits:
  Reduces call overhead
  Enables cross-function optimization
  May increase code size

Control:
  #[inline(always)]
  #[inline(never)]
  LTO for cross-module
```

## Debugging Support

### Debug Symbols

Including debug info:

```
Generation:
  -g flag during compilation
  DWARF debug information

Usage:
  GDB with RISC-V support
  Source-level debugging
  Stack traces

Trade-off:
  Larger binary
  Slower compilation
  Essential for development
```

### Disassembly

Inspecting generated code:

```
Tools:
  objdump -d program.elf
  riscv32-unknown-elf-objdump

Output:
  Assembly instructions
  Addresses
  Symbol information

Usage:
  Verify compilation
  Identify hot spots
  Debug low-level issues
```

## Cross-Compilation

### Host vs Target

Development environment:

```
Host:
  Development machine (x86, ARM)
  Runs compiler, tools
  Development environment

Target:
  RISC-V (zkVM)
  Runs compiled program
  Execution environment

Cross-compilation:
  Compile on host
  Execute on target
  Different architectures
```

### Sysroot

Target libraries:

```
Sysroot contents:
  Target libraries
  Header files
  Runtime support

Configuration:
  --sysroot=/path/to/riscv-sysroot
  Points to target libraries
```

## Key Concepts

- **Toolchain**: Compiler, linker, runtime
- **Target triple**: Architecture specification
- **Linker script**: Memory layout definition
- **Runtime**: Execution support library
- **Cross-compilation**: Host to target compilation

## Design Considerations

### Optimization Level

| Debug | Release |
|-------|---------|
| -O0 | -O2/-O3 |
| Fast compile | Slow compile |
| Large binary | Small binary |
| Easy debugging | Hard debugging |

### Standard Library

| std | no_std |
|-----|--------|
| Full library | Core only |
| Easier | More work |
| May not work | Compatible |
| Familiar | Restricted |

## Related Topics

- [Build System](02-build-system.md) - Build automation
- [Program Structure](../01-programming-model/01-program-structure.md) - Program patterns
- [Instruction Set Support](../../06-emulation-layer/01-risc-v-emulation/01-instruction-set-support.md) - Target ISA
- [Testing and Debugging](../01-programming-model/03-testing-and-debugging.md) - Debug workflow
