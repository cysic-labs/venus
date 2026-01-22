# RISC-V F/D Extension

## Overview

The RISC-V F and D extensions add single-precision (F) and double-precision (D) floating-point support to the base RISC-V instruction set. These extensions define dedicated floating-point registers, arithmetic instructions, memory operations, and conversion instructions. Supporting these extensions in a zkVM enables execution of programs that use standard floating-point operations.

In zkVM contexts, the F and D extensions present unique challenges. The instructions must be emulated in software and represented in constraints, even though RISC-V defines them assuming hardware support. The emulation layer translates these instructions into provable operations while maintaining IEEE 754 semantics expected by compiled programs.

This document covers the F and D extension specifications, their role in zkVM execution, and implementation considerations for supporting floating-point RISC-V programs.

## Extension Overview

### F Extension (RV32F/RV64F)

Single-precision floating-point:

```
F extension provides:
  32 floating-point registers (f0-f31)
  Single-precision arithmetic
  Memory load/store operations
  Conversion instructions
  Comparison instructions

Precision:
  32-bit IEEE 754 binary32
  24-bit significand precision
```

### D Extension (RV32D/RV64D)

Double-precision floating-point:

```
D extension provides:
  Extended floating-point registers
  Double-precision arithmetic
  Memory load/store operations
  Conversion instructions
  Comparison instructions

Precision:
  64-bit IEEE 754 binary64
  53-bit significand precision

Dependency:
  D requires F extension
  F registers widened to 64 bits
```

### Register File

Floating-point registers:

```
Floating-point register file:
  f0 through f31
  32 registers total
  Width: 32 bits (F only) or 64 bits (F+D)

Properties:
  Separate from integer registers
  No hardwired zero register
  All registers read-write
```

## Instruction Categories

### Load Instructions

Loading floating-point values:

```
Single-precision load:
  FLW: Load word to float register
  Address: base + offset

Double-precision load:
  FLD: Load double to float register
  Address: base + offset

Properties:
  Memory to FP register
  Aligned access required
```

### Store Instructions

Storing floating-point values:

```
Single-precision store:
  FSW: Store word from float register
  Address: base + offset

Double-precision store:
  FSD: Store double from float register
  Address: base + offset

Properties:
  FP register to memory
  Aligned access required
```

### Arithmetic Instructions

Computational operations:

```
Single-precision arithmetic:
  FADD.S: Addition
  FSUB.S: Subtraction
  FMUL.S: Multiplication
  FDIV.S: Division
  FSQRT.S: Square root

Double-precision arithmetic:
  FADD.D, FSUB.D, FMUL.D
  FDIV.D, FSQRT.D

Common properties:
  Three-operand format
  Destination and two sources
  Rounding mode specifiable
```

### Fused Multiply-Add

Combined operations:

```
Single-precision FMA:
  FMADD.S: d = (s1 * s2) + s3
  FMSUB.S: d = (s1 * s2) - s3
  FNMADD.S: d = -(s1 * s2) - s3
  FNMSUB.S: d = -(s1 * s2) + s3

Double-precision FMA:
  FMADD.D, FMSUB.D
  FNMADD.D, FNMSUB.D

Properties:
  Single rounding
  Higher accuracy than separate ops
  Common in numerical code
```

### Sign Manipulation

Sign-altering operations:

```
Sign manipulation:
  FSGNJ: Copy sign from second operand
  FSGNJN: Copy negated sign
  FSGNJX: XOR signs

Uses:
  Absolute value
  Negation
  Sign copying
  No rounding needed
```

### Comparison Instructions

Comparing floating-point values:

```
Comparison instructions:
  FEQ: Equal comparison
  FLT: Less than comparison
  FLE: Less or equal comparison

Properties:
  Result in integer register
  Result is 0 or 1
  NaN comparisons return 0
```

### Conversion Instructions

Type conversions:

```
Integer to float:
  FCVT.S.W: Signed int to single
  FCVT.S.WU: Unsigned int to single
  FCVT.D.W: Signed int to double
  FCVT.D.WU: Unsigned int to double

Float to integer:
  FCVT.W.S: Single to signed int
  FCVT.WU.S: Single to unsigned int
  FCVT.W.D: Double to signed int
  FCVT.WU.D: Double to unsigned int

Float precision conversion:
  FCVT.S.D: Double to single
  FCVT.D.S: Single to double
```

### Move Instructions

Register transfer:

```
Between register files:
  FMV.X.W: FP to integer (bitwise)
  FMV.W.X: Integer to FP (bitwise)

Properties:
  No conversion
  Bit pattern preserved
  Useful for bit manipulation
```

### Classification

Value classification:

```
Classification instruction:
  FCLASS: Classify floating-point value

Returns bit mask indicating:
  Negative infinity
  Negative normal
  Negative denormal
  Negative zero
  Positive zero
  Positive denormal
  Positive normal
  Positive infinity
  Signaling NaN
  Quiet NaN
```

## Rounding Mode

### Rounding Mode Specification

How rounding is controlled:

```
Rounding modes:
  RNE: Round to nearest, ties to even
  RTZ: Round toward zero
  RDN: Round toward negative infinity
  RUP: Round toward positive infinity
  RMM: Round to nearest, ties to max magnitude
  DYN: Use dynamic rounding mode

Instruction encoding:
  3-bit field in instruction
  Specifies mode for that operation
```

### Dynamic Rounding

Runtime rounding mode:

```
Dynamic mode:
  Instruction specifies DYN
  Actual mode from FCSR register
  Allows runtime control

CSR register:
  fcsr: Floating-point control/status
  Contains rounding mode
  Contains exception flags
```

## Control and Status

### FCSR Register

Floating-point status register:

```
FCSR contents:
  fflags: Exception flags (5 bits)
  frm: Rounding mode (3 bits)

Exception flags:
  NV: Invalid operation
  DZ: Divide by zero
  OF: Overflow
  UF: Underflow
  NX: Inexact
```

### Status Access

Reading and writing status:

```
CSR instructions:
  FRCSR: Read full FCSR
  FSCSR: Swap FCSR
  FRRM: Read rounding mode
  FSRM: Swap rounding mode
  FRFLAGS: Read exception flags
  FSFLAGS: Swap exception flags

Properties:
  Standard CSR access
  Affects FP behavior
```

## zkVM Implementation

### Emulation Strategy

How F/D instructions are handled:

```
Emulation approach:
  Decode F/D instruction
  Map to software implementation
  Execute using integer operations
  Produce IEEE 754 result

No actual FPU:
  All software emulated
  Using integer arithmetic
  Following IEEE 754 rules
```

### Register Mapping

Mapping FP registers:

```
FP register representation:
  Dedicated memory locations
  Or extended register file
  Separate from integer registers

State tracking:
  FP register values
  FCSR state
  All recorded in trace
```

### Instruction Handling

Processing FP instructions:

```
Instruction processing:
  1. Decode identifies F/D instruction
  2. Load operands from FP registers
  3. Perform software FP operation
  4. Store result to FP register
  5. Update FCSR if needed
  6. Record state changes
```

### Constraint Representation

Proving FP operations:

```
Constraint aspects:
  Register access constraints
  Operation correctness constraints
  Rounding constraints
  Exception flag constraints

Complexity:
  FP operations are expensive
  Many constraints per operation
  Consider optimization
```

## Special Considerations

### NaN Handling

Managing NaN values:

```
RISC-V NaN rules:
  Canonical NaN defined
  Operations produce canonical NaN
  NaN payload may be preserved

Implementation:
  Must match RISC-V semantics
  Canonical NaN when applicable
  Consistent behavior
```

### Denormalized Numbers

Handling denormals:

```
RISC-V denormal support:
  Full denormal support required
  Gradual underflow
  No flush-to-zero option

Implementation:
  Must handle denormals
  Added complexity
  More constraints
```

### Exception Behavior

Exception handling in RISC-V:

```
RISC-V exception model:
  Flags set in FCSR
  No trapping by default
  Trapping optional

Implementation:
  Set appropriate flags
  Continue execution
  Flag checking available
```

## Optimization Opportunities

### Common Operations

Optimizing frequent operations:

```
Common operations:
  Basic arithmetic (add, mul)
  Comparisons
  Conversions

Optimization:
  Specialized constraint sets
  Lookup tables for common cases
  Batched operations
```

### Instruction Patterns

Recognizing patterns:

```
Patterns to optimize:
  Repeated operations
  Common sequences
  Idioms (abs, negate)

Approach:
  Pattern matching
  Specialized handling
  Reduced constraints
```

### Precision Selection

Choosing precision level:

```
Precision trade-off:
  Single: Less constraint overhead
  Double: More constraint overhead

Strategy:
  Use single when sufficient
  Optimize common cases
  Full double when needed
```

## Compatibility

### Compiler Expectations

What compilers assume:

```
Compiler assumptions:
  F/D instructions available
  IEEE 754 semantics
  FCSR accessible
  Standard behavior

Implication:
  Must match expectations
  Or restrict compilation
```

### Library Support

Floating-point libraries:

```
Library considerations:
  Math libraries use F/D
  May need soft-float version
  Or F/D emulation sufficient

Options:
  Compile with soft-float
  Emulate F/D instructions
  Provide compatible library
```

## Key Concepts

- **F extension**: Single-precision floating-point instructions
- **D extension**: Double-precision floating-point instructions
- **FP register file**: Separate floating-point registers
- **Rounding modes**: IEEE 754 rounding control
- **FCSR**: Floating-point control and status register
- **Software emulation**: Implementing F/D without hardware FPU

## Design Trade-offs

### Full vs Partial Support

| Full F/D Support | Partial Support |
|------------------|-----------------|
| All instructions | Common subset |
| All modes | Single mode |
| Full compatibility | Limited compatibility |
| High overhead | Lower overhead |

### Emulation vs Soft-Float

| F/D Emulation | Soft-Float Compilation |
|---------------|------------------------|
| Runs standard binaries | Requires recompilation |
| Higher runtime cost | Optimized for no-FPU |
| Transparent to code | Code aware of soft-float |
| More general | More efficient |

### Accuracy vs Speed

| Full IEEE 754 | Relaxed IEEE 754 |
|---------------|-----------------|
| Correct rounding | Approximate |
| All special cases | Common cases |
| Standard-compliant | Non-compliant |
| Slower proving | Faster proving |

## Related Topics

- [Software Float Emulation](01-software-float-emulation.md) - Emulation implementation
- [IEEE754 Implementation](02-ieee754-implementation.md) - Standard details
- [RISC-V Fundamentals](../../04-zkvm-architecture/01-isa-integration/01-risc-v-fundamentals.md) - Base ISA
- [Instruction Execution](../../06-emulation-layer/01-emulator-architecture/02-instruction-execution.md) - Execution model

