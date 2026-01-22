# Instruction Set Support

## Overview

Instruction set support defines which RISC-V instructions the zkVM can execute and prove. The base RISC-V instruction set (RV32I or RV64I) provides integer computation, while extensions add capabilities like multiplication (M), atomics (A), floating-point (F, D), and compressed instructions (C). Each supported instruction requires corresponding constraints in the proving system, making instruction set selection a balance between capability and proving efficiency.

A zkVM typically supports a subset of the full RISC-V specification, focusing on instructions needed by target programs while avoiding rarely-used or complex instructions. This document catalogs supported instructions, describes their semantics, explains extension handling, and details how unsupported instructions are managed.

## Base Integer Instructions

### RV32I/RV64I Core

Fundamental integer operations:

```
Arithmetic:
  ADD, SUB: Register addition/subtraction
  ADDI: Add immediate
  LUI: Load upper immediate
  AUIPC: Add upper immediate to PC

Logical:
  AND, OR, XOR: Bitwise operations
  ANDI, ORI, XORI: Immediate variants
  SLL, SRL, SRA: Shifts
  SLLI, SRLI, SRAI: Immediate shifts

Comparison:
  SLT, SLTU: Set less than (signed/unsigned)
  SLTI, SLTIU: Immediate variants

Memory:
  LB, LH, LW: Load byte/half/word
  LBU, LHU: Load unsigned
  SB, SH, SW: Store byte/half/word
  LD, SD: Load/store doubleword (RV64)

Control:
  BEQ, BNE: Branch equal/not equal
  BLT, BGE: Branch less than/greater equal
  BLTU, BGEU: Unsigned variants
  JAL: Jump and link
  JALR: Jump and link register

System:
  ECALL: Environment call
  EBREAK: Breakpoint
  FENCE: Memory fence (often no-op)
```

### Instruction Encoding

Decoding the 32-bit instruction:

```
Format determination:
  opcode = inst[6:0]

  0110011 (0x33): R-type (register-register)
  0010011 (0x13): I-type (immediate arithmetic)
  0000011 (0x03): I-type (loads)
  0100011 (0x23): S-type (stores)
  1100011 (0x63): B-type (branches)
  0110111 (0x37): U-type (LUI)
  0010111 (0x17): U-type (AUIPC)
  1101111 (0x6F): J-type (JAL)
  1100111 (0x67): I-type (JALR)
  1110011 (0x73): System (ECALL, EBREAK)

Field extraction:
  rd = inst[11:7]
  rs1 = inst[19:15]
  rs2 = inst[24:20]
  funct3 = inst[14:12]
  funct7 = inst[31:25]
```

### Instruction Semantics

Formal definitions:

```
ADD rd, rs1, rs2:
  rd = rs1 + rs2

SUB rd, rs1, rs2:
  rd = rs1 - rs2

SLT rd, rs1, rs2:
  rd = (signed(rs1) < signed(rs2)) ? 1 : 0

SLL rd, rs1, rs2:
  rd = rs1 << (rs2 & 0x3F)  // RV64
  rd = rs1 << (rs2 & 0x1F)  // RV32

LW rd, offset(rs1):
  rd = sign_extend(mem[rs1 + offset][31:0])

BEQ rs1, rs2, offset:
  if (rs1 == rs2) pc = pc + offset
  else pc = pc + 4
```

## Standard Extensions

### M Extension (Multiplication)

Integer multiply/divide:

```
Multiplication:
  MUL: Lower 64 bits of rs1 * rs2
  MULH: Upper 64 bits (signed × signed)
  MULHU: Upper 64 bits (unsigned × unsigned)
  MULHSU: Upper 64 bits (signed × unsigned)
  MULW: 32-bit multiply (RV64)

Division:
  DIV: Signed division quotient
  DIVU: Unsigned division quotient
  REM: Signed remainder
  REMU: Unsigned remainder
  DIVW, REMW: 32-bit variants (RV64)

Special cases:
  Division by zero: Returns -1 (DIV) or max value (DIVU)
  Overflow (-2^63 / -1): Returns -2^63
```

### A Extension (Atomics)

Atomic memory operations:

```
Load-reserved/Store-conditional:
  LR.W, LR.D: Load-reserved
  SC.W, SC.D: Store-conditional

Atomic memory operations:
  AMOSWAP: Atomic swap
  AMOADD: Atomic add
  AMOAND, AMOOR, AMOXOR: Atomic bitwise
  AMOMIN, AMOMAX: Atomic min/max (signed)
  AMOMINU, AMOMAXU: Atomic min/max (unsigned)

Single-threaded context:
  Atomics may simplify to regular load/store
  LR/SC pairs need reservation tracking
```

### C Extension (Compressed)

16-bit instructions:

```
Compressed instructions:
  C.ADD, C.ADDI: Compact arithmetic
  C.LW, C.SW: Compact load/store
  C.BEQZ, C.BNEZ: Compact branches
  C.J, C.JAL: Compact jumps
  C.MV: Compact move

Properties:
  16-bit encoding (half size)
  Subset of registers/immediates
  Expands to 32-bit equivalent

Handling:
  Detect via low 2 bits != 0b11
  Expand to full instruction
  Process as expanded form
```

### F/D Extensions (Floating-Point)

Floating-point operations:

```
F Extension (single precision):
  FADD.S, FSUB.S, FMUL.S, FDIV.S: Arithmetic
  FLW, FSW: Load/store
  FEQ.S, FLT.S, FLE.S: Comparison
  FCVT: Conversions

D Extension (double precision):
  Same operations with .D suffix
  FLD, FSD for 64-bit load/store

Complexity:
  IEEE 754 compliance required
  Rounding modes
  Exception flags

Typically requires dedicated precompile or emulation.
```

## Extension Detection

### Compiler Targeting

How programs indicate extensions:

```
ELF attributes:
  riscv_arch attribute specifies ISA
  Example: "rv64imac" = 64-bit + M + A + C

Compiler flags:
  -march=rv64imac
  Generates only supported instructions

Runtime detection:
  Not typically needed for zkVM
  Fixed target at compile time
```

### Unsupported Extension Handling

When encountering unsupported instructions:

```
Options:
  1. Trap: Raise illegal instruction exception
  2. Emulate: Software emulation in trap handler
  3. Fail: Abort execution

Trap approach:
  Handler interprets instruction
  Updates architectural state
  Resumes execution

Performance:
  Emulation very expensive in zkVM
  Better to avoid unsupported instructions
```

## Instruction Categories

### Compute Instructions

Pure computation (no memory/control):

```
Arithmetic: ADD, SUB, SLT, SLTU
Logical: AND, OR, XOR
Shifts: SLL, SRL, SRA
Immediate: ADDI, ANDI, ORI, XORI, SLTI, SLTIU
Upper immediate: LUI, AUIPC
Multiply: MUL, MULH, MULHU, MULHSU
Divide: DIV, DIVU, REM, REMU

Properties:
  Self-contained
  Single cycle (conceptually)
  No side effects beyond register write
```

### Memory Instructions

Load and store operations:

```
Loads:
  LB, LBU: Byte (signed/unsigned)
  LH, LHU: Halfword
  LW, LWU: Word (unsigned for RV64)
  LD: Doubleword (RV64)

Stores:
  SB: Store byte
  SH: Store halfword
  SW: Store word
  SD: Store doubleword (RV64)

Properties:
  Access memory machine
  Address alignment requirements
  Potential exceptions (misalignment, access fault)
```

### Control Instructions

Branch and jump:

```
Conditional branches:
  BEQ, BNE: Equal/not equal
  BLT, BGE: Less than/greater equal (signed)
  BLTU, BGEU: Unsigned variants

Unconditional jumps:
  JAL: Jump and link (PC-relative)
  JALR: Jump and link register

Properties:
  Modify program counter
  May skip instructions
  JAL/JALR store return address
```

### System Instructions

Privileged and system operations:

```
Environment:
  ECALL: System call to environment
  EBREAK: Debug breakpoint

Memory ordering:
  FENCE: Memory fence (ordering)
  FENCE.I: Instruction fence

CSR access:
  CSRRW, CSRRS, CSRRC: CSR read/write
  CSRRWI, CSRRSI, CSRRCI: Immediate variants

Handling:
  ECALL typically triggers I/O or termination
  FENCE often no-op in single-threaded context
  CSR access for system state
```

## Proving Considerations

### Instruction Complexity

Constraint cost by instruction type:

```
Simple (few constraints):
  ADD, SUB, AND, OR, XOR: Basic arithmetic
  Immediates: Similar to register versions

Medium (moderate constraints):
  Shifts: Bit manipulation
  Loads/Stores: Memory machine interaction
  Branches: Condition evaluation + PC update

Complex (many constraints):
  MUL, MULH: Full multiplication
  DIV, REM: Division algorithm
  Atomics: Memory ordering
  Floating-point: IEEE compliance
```

### Precompile Candidates

Instructions that benefit from precompiles:

```
Division/Remainder:
  Expensive iterative algorithm
  May use dedicated division machine

Wide multiplication:
  MULH variants compute upper bits
  Benefits from specialized circuit

Floating-point:
  Complex IEEE semantics
  Almost always precompiled
```

## Key Concepts

- **Base ISA**: RV32I/RV64I core integer instructions
- **Extension**: Additional instruction categories (M, A, C, F, D)
- **Instruction format**: Encoding pattern (R, I, S, B, U, J)
- **Trap handling**: Response to unsupported instructions
- **Proving cost**: Constraint complexity per instruction

## Design Considerations

### ISA Subset

| Minimal | Full Featured |
|---------|---------------|
| RV32I only | RV64IMAC |
| Fewer constraints | More capabilities |
| Limited programs | Broad compatibility |
| Faster proving | Slower proving |

### Extension Support

| Native Support | Emulation |
|----------------|-----------|
| Efficient constraints | Software fallback |
| Fixed at design | Flexible |
| Low overhead | High overhead |
| Complex implementation | Simple implementation |

## Related Topics

- [Instruction Decoding](../../04-zkvm-architecture/04-instruction-handling/01-instruction-decoding.md) - Decoding process
- [Register Emulation](02-register-emulation.md) - Register handling
- [Memory Emulation](03-memory-emulation.md) - Memory operations
- [Arithmetic Operations](../../04-zkvm-architecture/02-state-machine-design/03-arithmetic-operations.md) - M extension
