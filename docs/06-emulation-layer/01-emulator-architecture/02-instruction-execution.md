# Instruction Execution

## Overview

Instruction execution is the core function of the emulator, transforming RISC-V instructions into state changes. Each instruction type has specific execution semantics that must be precisely implemented. The emulator must handle all supported instructions correctly while generating the trace data needed for subsequent proving.

The execution process follows the standard fetch-decode-execute-writeback pattern but with additional recording at each stage. Understanding instruction execution helps clarify how program behavior translates into provable state transitions.

This document covers the execution of different instruction categories, operand handling, and result generation.

## Execution Pipeline

### Pipeline Stages

Standard execution stages:

```
Fetch:
  Read instruction at PC
  Increment PC (tentatively)

Decode:
  Parse instruction format
  Extract operands

Execute:
  Compute result
  Evaluate conditions

Memory (if applicable):
  Load or store data

Writeback:
  Update destination register
  Finalize PC update
```

### Stage Implementation

How stages are realized:

```
Sequential execution:
  Each stage completes before next
  Simple state management

Pipelined (optional):
  Overlap stages for throughput
  More complex but faster
```

## ALU Operations

### Arithmetic Instructions

ADD, SUB, and variants:

```
ADD rd, rs1, rs2:
  result = regs[rs1] + regs[rs2]
  regs[rd] = result

SUB rd, rs1, rs2:
  result = regs[rs1] - regs[rs2]
  regs[rd] = result

ADDI rd, rs1, imm:
  result = regs[rs1] + sign_extend(imm)
  regs[rd] = result

Overflow:
  Wrap at 32 bits
  No exception on overflow
```

### Logical Instructions

AND, OR, XOR:

```
AND rd, rs1, rs2:
  result = regs[rs1] & regs[rs2]
  regs[rd] = result

OR rd, rs1, rs2:
  result = regs[rs1] | regs[rs2]
  regs[rd] = result

XOR rd, rs1, rs2:
  result = regs[rs1] ^ regs[rs2]
  regs[rd] = result

Immediate variants:
  Same with sign-extended immediate
```

### Shift Instructions

SLL, SRL, SRA:

```
SLL rd, rs1, rs2:
  shamt = regs[rs2] & 0x1F
  result = regs[rs1] << shamt
  regs[rd] = result

SRL rd, rs1, rs2:
  shamt = regs[rs2] & 0x1F
  result = regs[rs1] >>> shamt (logical)
  regs[rd] = result

SRA rd, rs1, rs2:
  shamt = regs[rs2] & 0x1F
  result = regs[rs1] >> shamt (arithmetic)
  regs[rd] = result
```

### Comparison Instructions

SLT, SLTU:

```
SLT rd, rs1, rs2:
  if signed(regs[rs1]) < signed(regs[rs2]):
    regs[rd] = 1
  else:
    regs[rd] = 0

SLTU rd, rs1, rs2:
  if unsigned(regs[rs1]) < unsigned(regs[rs2]):
    regs[rd] = 1
  else:
    regs[rd] = 0
```

## Memory Operations

### Load Instructions

Reading from memory:

```
LW rd, offset(rs1):
  addr = regs[rs1] + sign_extend(offset)
  check_alignment(addr, 4)
  regs[rd] = memory[addr:addr+4]

LH rd, offset(rs1):
  addr = regs[rs1] + sign_extend(offset)
  check_alignment(addr, 2)
  value = memory[addr:addr+2]
  regs[rd] = sign_extend_16(value)

LB rd, offset(rs1):
  addr = regs[rs1] + sign_extend(offset)
  value = memory[addr]
  regs[rd] = sign_extend_8(value)

Unsigned variants:
  LHU, LBU: zero-extend instead
```

### Store Instructions

Writing to memory:

```
SW rs2, offset(rs1):
  addr = regs[rs1] + sign_extend(offset)
  check_alignment(addr, 4)
  memory[addr:addr+4] = regs[rs2]

SH rs2, offset(rs1):
  addr = regs[rs1] + sign_extend(offset)
  check_alignment(addr, 2)
  memory[addr:addr+2] = regs[rs2] & 0xFFFF

SB rs2, offset(rs1):
  addr = regs[rs1] + sign_extend(offset)
  memory[addr] = regs[rs2] & 0xFF
```

## Control Flow

### Branch Instructions

Conditional branches:

```
BEQ rs1, rs2, offset:
  if regs[rs1] == regs[rs2]:
    PC = PC + sign_extend(offset)
  else:
    PC = PC + 4

BNE rs1, rs2, offset:
  if regs[rs1] != regs[rs2]:
    PC = PC + sign_extend(offset)
  else:
    PC = PC + 4

BLT, BGE, BLTU, BGEU:
  Similar with appropriate comparisons
```

### Jump Instructions

Unconditional jumps:

```
JAL rd, offset:
  regs[rd] = PC + 4
  PC = PC + sign_extend(offset)

JALR rd, rs1, offset:
  target = (regs[rs1] + sign_extend(offset)) & ~1
  regs[rd] = PC + 4
  PC = target
```

### Upper Immediate

LUI and AUIPC:

```
LUI rd, imm:
  regs[rd] = imm << 12

AUIPC rd, imm:
  regs[rd] = PC + (imm << 12)
```

## M Extension

### Multiplication

MUL and variants:

```
MUL rd, rs1, rs2:
  result = (regs[rs1] * regs[rs2]) & 0xFFFFFFFF
  regs[rd] = result (low 32 bits)

MULH rd, rs1, rs2:
  result = signed(regs[rs1]) * signed(regs[rs2])
  regs[rd] = result >> 32 (high 32 bits)

MULHU rd, rs1, rs2:
  result = unsigned(regs[rs1]) * unsigned(regs[rs2])
  regs[rd] = result >> 32

MULHSU rd, rs1, rs2:
  result = signed(regs[rs1]) * unsigned(regs[rs2])
  regs[rd] = result >> 32
```

### Division

DIV and variants:

```
DIV rd, rs1, rs2:
  if regs[rs2] == 0:
    regs[rd] = -1
  else:
    regs[rd] = signed(regs[rs1]) / signed(regs[rs2])

DIVU rd, rs1, rs2:
  if regs[rs2] == 0:
    regs[rd] = 0xFFFFFFFF
  else:
    regs[rd] = unsigned(regs[rs1]) / unsigned(regs[rs2])

REM, REMU:
  Similar for remainder
```

## System Instructions

### ECALL

Environment call:

```
ECALL:
  Invoke system call
  Arguments in a0-a7
  Return in a0

Handling:
  Dispatch to syscall handler
  Execute and return
```

### EBREAK

Breakpoint:

```
EBREAK:
  Debugging breakpoint
  May halt or continue
```

### Fence

Memory fence:

```
FENCE:
  Memory ordering barrier
  In single-threaded: no-op
```

## Error Handling

### Invalid Instructions

Handling undefined opcodes:

```
Detection:
  Opcode not in valid set
  Reserved encoding

Response:
  Trap or halt
  Record error
```

### Alignment Errors

Misaligned access:

```
Detection:
  Address not aligned to access size

Response:
  Exception (if strict)
  Or: handle via multiple accesses
```

### Memory Errors

Out-of-bounds access:

```
Detection:
  Address outside valid regions

Response:
  Trap
  Record violation
```

## Recording for Trace

### Per-Instruction Recording

What to capture:

```
Record:
  PC before execution
  Instruction word
  Source operand values
  Result value
  Memory operations

Format:
  Structured for prover
  Efficient encoding
```

### State Deltas

Minimal state changes:

```
Delta recording:
  Only changed register
  Only modified memory

Benefits:
  Smaller trace
  Faster generation
```

## Key Concepts

- **Instruction execution**: Transforming instructions to state changes
- **Pipeline stages**: Fetch, decode, execute, writeback
- **ALU operations**: Arithmetic and logical computations
- **Memory operations**: Loads and stores
- **Control flow**: Branches and jumps

## Design Trade-offs

### Execution Speed

| Interpreter | JIT |
|-------------|-----|
| Simple | Complex |
| Portable | Fast |
| Predictable | Variable |

### Recording Detail

| Minimal | Complete |
|---------|----------|
| Smaller traces | Larger traces |
| Less overhead | More overhead |
| Derived state | Direct access |

## Related Topics

- [Emulator Design](01-emulator-design.md) - Overall architecture
- [Trace Capture](03-trace-capture.md) - Recording execution
- [RISC-V Fundamentals](../../04-zkvm-architecture/01-isa-integration/01-risc-v-fundamentals.md) - ISA details
- [Instruction Encoding](../../04-zkvm-architecture/04-execution-model/01-instruction-encoding.md) - Encoding format

