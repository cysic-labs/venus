# Instruction Transpilation

## Overview

Instruction transpilation converts standard RISC-V instructions into a form optimized for zkVM execution and proving. While the zkVM executes RISC-V semantics, the internal representation may differ to improve constraint efficiency, simplify state machine design, or enable better parallelization. This translation happens either at load time or during compilation.

The transpilation process bridges the gap between programmer-friendly instruction sets and prover-friendly representations. A RISC-V binary compiled with standard tools undergoes transformation to match the zkVM's internal instruction format. Understanding this process clarifies how standard programs become provable computations.

## Transpilation Concepts

### Why Transpile

Motivations for instruction transformation:

```
Constraint efficiency:
  Some RISC-V encodings suboptimal for proving
  Restructure for fewer constraints
  Exploit zkVM-specific optimizations

Uniformity:
  Normalize instruction variants
  Reduce case analysis in state machine
  Simplify constraint design

Extension handling:
  Map complex instructions to primitives
  Handle missing extensions via emulation
  Custom instruction support
```

### Transpilation Stages

Processing pipeline:

```
Stage 1 - Binary Loading:
  Read ELF executable
  Extract code sections
  Identify instruction boundaries

Stage 2 - Decode:
  Parse RISC-V instruction encoding
  Identify opcode, operands
  Handle compressed instructions (if supported)

Stage 3 - Transform:
  Map to internal representation
  Apply optimizations
  Handle special cases

Stage 4 - Encode:
  Produce zkVM instruction format
  Prepare for ROM loading
  Generate auxiliary data
```

## Internal Instruction Format

### Normalized Representation

Unified instruction structure:

```
Internal format:
  Opcode: Operation identifier
  Operands: Source and destination specifiers
  Immediates: Constant values
  Flags: Modifier bits

Benefits:
  Fixed-width fields
  Direct constraint mapping
  Efficient state machine dispatch
```

### Operand Encoding

Handling instruction operands:

```
Register operands:
  5-bit register specifiers
  Consistent position across formats
  Zero register (x0) handling

Immediate operands:
  Sign-extended to full width
  Precomputed at transpilation
  No runtime reconstruction needed

Memory operands:
  Base register + offset
  Offset pre-computed
  Alignment information
```

### Operation Decomposition

Breaking complex operations:

```
Compound instructions:
  Some instructions do multiple things
  Decompose for simpler constraints
  May expand to multiple internal ops

Example - JALR:
  1. Compute target address
  2. Store return address
  3. Update PC
  May become separate steps internally

Example - Branches:
  1. Compare operands
  2. Conditionally update PC
  Clear separation of concerns
```

## Transformation Rules

### Arithmetic Transforms

Optimizing arithmetic:

```
Immediate handling:
  Precompute sign extension
  Store full-width immediate

Subtraction:
  SUB rd, rs1, rs2
  May map to: ADD rd, rs1, NEG(rs2)
  Or keep as distinct operation

Shifts:
  Normalize shift amounts
  Handle variable vs immediate shifts
  Mask to valid range
```

### Memory Access Transforms

Handling loads and stores:

```
Address calculation:
  Precompute base + offset if constant base
  Otherwise, mark for runtime computation

Width handling:
  Byte/halfword/word distinguished
  Sign extension encoded in opcode
  Alignment requirements captured

Memory operation encoding:
  Direction (load/store)
  Width (1/2/4 bytes)
  Sign behavior (signed/unsigned for loads)
```

### Control Flow Transforms

Branch and jump handling:

```
Branch targets:
  Compute absolute target address
  Or keep as PC-relative offset
  Depends on execution model

Conditional branches:
  Condition type encoded
  Target address computed
  Fall-through handled

Jumps:
  Direct jumps: target known
  Indirect jumps: register-based
  Return address handling
```

## Pseudo-Instruction Expansion

### Common Pseudo-Instructions

Assembly conveniences:

```
NOP (no operation):
  ADDI x0, x0, 0
  Already valid RISC-V

MV rd, rs (move):
  ADDI rd, rs, 0
  No separate move instruction

LI rd, imm (load immediate):
  May be LUI + ADDI
  Or just ADDI if small enough

LA rd, symbol (load address):
  AUIPC + ADDI
  Address calculation
```

### Expansion at Transpilation

Handling assembler constructs:

```
Process:
  Binary already has real instructions
  Pseudo-instructions expanded by assembler
  Transpiler sees actual instructions

Notes:
  No pseudo-instruction handling needed
  Work done by compiler/assembler
  Transpiler processes raw encoding
```

## Extension Handling

### Supported Extensions

Extensions the zkVM implements:

```
Base (I):
  Always supported
  Core integer operations
  Load/store, branches, jumps

Multiplication (M):
  Typically supported
  MUL, MULH, DIV, REM
  May use dedicated circuits

Others:
  A (Atomics): May simplify for single-thread
  C (Compressed): Optional support
  F/D (Floating-point): Via software or precompile
```

### Unsupported Instruction Handling

When instructions aren't native:

```
Options:
  Trap to software handler
  Emulate via multiple instructions
  Reject at load time

Floating-point example:
  No hardware FPU in zkVM
  Software emulation library
  Or dedicated precompile

Atomic example:
  Single-threaded execution
  Atomics become regular load/store
  Simpler implementation
```

## ROM Preparation

### Instruction ROM Layout

Organizing transpiled code:

```
ROM structure:
  Instructions stored sequentially
  PC indexes into ROM
  Each slot holds one instruction

Addressing:
  PC values map to ROM indices
  Word-aligned access
  Bounds checking

Metadata:
  Instruction count
  Entry point
  Section boundaries
```

### Auxiliary Data

Supporting information:

```
Immediate tables:
  Large immediates stored separately
  Referenced by instruction index
  Reduces instruction width

Branch targets:
  Target addresses pre-computed
  Stored for quick lookup
  Verification data

Debug information:
  Source mapping (optional)
  Symbol information
  For debugging, not proving
```

## Optimization Opportunities

### Constant Propagation

Compile-time evaluation:

```
Pattern:
  Instruction uses only constants
  Result is compile-time known
  Replace with result loading

Example:
  ADDI x5, x0, 10  →  Load constant 10 to x5
  Already simple, but principle applies

Limitations:
  Must not affect program semantics
  Branch targets are code, not data
```

### Instruction Fusion

Combining operations:

```
Pattern:
  Sequence of instructions
  Combined effect is simpler
  Fuse into single internal op

Example:
  LUI + ADDI for 32-bit constant
  May become single "load constant"

Considerations:
  Must preserve semantics
  May complicate decoding
  Trade-off in complexity
```

### Dead Code Elimination

Removing unused instructions:

```
Static analysis:
  Unreachable code after unconditional jumps
  Guaranteed-not-taken branches
  Provably dead code

Benefits:
  Smaller ROM
  Fewer instructions to prove
  Improved efficiency

Limitations:
  Conservative analysis
  May miss dynamic dead code
  Can't break semantics
```

## Key Concepts

- **Transpilation**: Converting RISC-V to internal format
- **Normalization**: Unified representation across variants
- **Decomposition**: Breaking complex ops into simpler parts
- **Extension handling**: Supporting or emulating ISA extensions
- **ROM preparation**: Creating provable instruction storage

## Design Considerations

### Transpilation Depth

| Minimal Transform | Deep Transform |
|-------------------|----------------|
| Close to RISC-V | Heavily optimized |
| Simpler transpiler | Complex transpiler |
| More constraint work | Less constraint work |
| Easier debugging | Harder to trace |

### Instruction Width

| Fixed Width | Variable Width |
|-------------|----------------|
| Simpler ROM access | Denser encoding |
| Aligned fetching | Complex indexing |
| Some waste | No waste |

## Related Topics

- [RISC-V Fundamentals](01-risc-v-fundamentals.md) - Source ISA
- [Register Mapping](03-register-mapping.md) - Register handling
- [Main State Machine](../02-state-machine-design/02-main-state-machine.md) - Execution engine

