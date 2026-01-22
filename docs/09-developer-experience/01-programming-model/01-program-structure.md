# Program Structure

## Overview

Programs for a zkVM follow specific structural patterns that enable efficient proving. Unlike traditional programs optimized for execution speed, zkVM programs must consider constraint complexity, memory access patterns, and provable I/O. Understanding these patterns helps developers write programs that prove efficiently while remaining correct and maintainable.

A zkVM program is compiled from standard source code (typically Rust or C) to RISC-V binary, then executed in the zkVM environment. The program structure reflects this toolchain: standard main function entry, library-based I/O, and awareness of the proving context. This document covers program organization, entry points, I/O handling, and best practices for zkVM development.

## Program Organization

### Entry Point

Program entry:

```
Standard main function:
  fn main() {
    // Read inputs
    // Perform computation
    // Write outputs
  }

No return value:
  Exit via system call
  Output via write system call

Entry requirements:
  No arguments (inputs via I/O)
  No return value (outputs via I/O)
  Clean termination
```

### Program Sections

Logical organization:

```
Input section:
  Read all inputs at start
  Parse and validate
  Store in local variables

Computation section:
  Core program logic
  Deterministic operations
  No additional I/O

Output section:
  Format results
  Write all outputs
  Terminate cleanly
```

### Memory Layout

How memory is used:

```
Code segment:
  Program instructions (read-only)
  Fixed at load time

Data segment:
  Initialized global data
  String literals, constants

BSS segment:
  Zero-initialized globals
  Static variables

Heap:
  Dynamic allocation
  Grows upward

Stack:
  Local variables
  Call frames
  Grows downward
```

## I/O Model

### Input Reading

Receiving program inputs:

```
Public input:
  Known to verifier
  Part of proof statement
  Read via input stream

Private input:
  Known only to prover
  Not revealed in proof
  Same read mechanism

Reading API:
  let data: Vec<u8> = zkvm::read();
  let value: u32 = zkvm::read();

Structured input:
  Deserialize complex types
  Use serde or similar
```

### Output Writing

Producing program outputs:

```
Public output:
  Committed in proof
  Verifier checks
  Write via output stream

Writing API:
  zkvm::write(&result);
  zkvm::commit(&hash);

Structured output:
  Serialize complex types
  Deterministic format
```

### I/O Order

Sequencing I/O:

```
Order matters:
  Inputs read in order
  Outputs written in order
  Deterministic sequence

Pattern:
  Read all inputs first
  Process
  Write all outputs last

Avoid:
  Interleaved I/O
  Conditional I/O order
  Non-deterministic sequences
```

## Computation Patterns

### Deterministic Execution

Ensuring reproducibility:

```
Requirements:
  Same input → Same output
  No randomness
  No external state

Avoid:
  Random number generation (unless seeded deterministically)
  Time-based operations
  External calls
  Floating-point (unless carefully handled)
```

### Loop Structures

Efficient loop patterns:

```
Bounded loops:
  for i in 0..FIXED_COUNT { ... }
  Known iteration count
  Predictable trace size

Avoid unbounded:
  while condition { ... }
  May run indefinitely
  Trace size unknown

Data-dependent iteration:
  for item in data { ... }
  Length known from input
  Acceptable if input bounded
```

### Conditional Execution

Branching in zkVM:

```
Both branches execute:
  if condition { a } else { b }
  Constraint system covers both paths
  Only one contributes to result

Implication:
  Can't hide which branch taken (in trace)
  Both branches' constraints satisfied
  Use multiplexing pattern
```

## Memory Management

### Stack Allocation

Local variables:

```
Preferred for:
  Small, fixed-size data
  Temporary variables
  Function-local scope

Example:
  let buffer: [u8; 256] = [0; 256];
  let value: u32 = compute();

Benefits:
  No allocation overhead
  Predictable location
  Fast access
```

### Heap Allocation

Dynamic allocation:

```
Use for:
  Variable-size data
  Data exceeding stack
  Long-lived data

Example:
  let data: Vec<u8> = vec![0; size];
  let boxed: Box<LargeStruct> = Box::new(large);

Considerations:
  Allocation has overhead
  May fragment heap
  Increases memory trace
```

### Avoiding Allocation

Reducing dynamic allocation:

```
Pre-allocate:
  Allocate once, reuse
  Size based on known bounds

Use arrays:
  Fixed-size arrays when possible
  Avoid Vec for known sizes

Minimize allocations:
  Each allocation is memory operation
  More operations = more constraints
```

## Library Usage

### Standard Library

Using std in zkVM:

```
Available:
  Core data structures
  String handling
  Some algorithms

Unavailable:
  File I/O (use zkVM I/O)
  Networking
  Threading
  Time

zkVM-specific:
  Use zkVM I/O library
  Special precompile calls
```

### Cryptographic Libraries

Using crypto in zkVM:

```
Precompile-backed:
  SHA-256, Keccak-256
  EC operations
  Use precompile wrapper

Pure computation:
  May be inefficient
  Consider constraint cost
  Only for unsupported operations

Example:
  let hash = zkvm::sha256(&data);  // Precompile
  // vs
  let hash = pure_sha256(&data);   // Many constraints
```

### External Dependencies

Managing dependencies:

```
Compatible crates:
  Pure Rust, no_std compatible
  No system calls
  No unsupported features

Checking compatibility:
  Test compilation to RISC-V
  Test in zkVM environment
  Review constraint impact
```

## Error Handling

### Panic Behavior

When programs panic:

```
Panic in zkVM:
  Execution terminates
  No proof generated
  Error reported

Causes:
  Assertion failure
  Array bounds
  Unwrap on None/Err
  Explicit panic!()

Handling:
  Validate inputs
  Use checked operations
  Graceful error handling
```

### Result Handling

Using Result type:

```
Pattern:
  fn compute() -> Result<Output, Error> {
    let input = read_input()?;
    let processed = process(input)?;
    Ok(processed)
  }

In main:
  fn main() {
    match compute() {
      Ok(result) => zkvm::write(&result),
      Err(e) => zkvm::write(&ErrorResult::from(e)),
    }
  }
```

### Input Validation

Checking inputs:

```
Validate early:
  Check input format
  Verify bounds
  Reject invalid

Example:
  let data = zkvm::read::<Vec<u8>>();
  if data.len() > MAX_SIZE {
    zkvm::write(&Error::InputTooLarge);
    return;
  }
```

## Key Concepts

- **Entry point**: Main function as program start
- **I/O model**: Read inputs, compute, write outputs
- **Determinism**: Same input always produces same output
- **Memory layout**: Code, data, heap, stack
- **Panic behavior**: Terminates proving on panic

## Design Considerations

### Program Size

| Small Program | Large Program |
|---------------|---------------|
| Fewer constraints | More constraints |
| Faster proving | Slower proving |
| Simpler | More features |
| Easier debugging | Complex debugging |

### Memory Strategy

| Stack-Heavy | Heap-Heavy |
|-------------|------------|
| Fixed sizes | Dynamic sizes |
| Less allocation | More allocation |
| Limited flexibility | High flexibility |
| Smaller memory trace | Larger memory trace |

## Related Topics

- [Constraint-Aware Programming](02-constraint-aware-programming.md) - Optimization
- [Testing and Debugging](03-testing-and-debugging.md) - Development workflow
- [I/O Handling](../../06-emulation-layer/02-system-emulation/02-io-handling.md) - I/O details
- [Instruction Set Support](../../06-emulation-layer/01-risc-v-emulation/01-instruction-set-support.md) - Supported operations
