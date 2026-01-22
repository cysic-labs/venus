# RISC-V Fundamentals

## Overview

RISC-V serves as the instruction set architecture for zkVM execution. This open-standard ISA provides a clean, modular design that maps well to zero-knowledge proving constraints. Understanding RISC-V fundamentals is essential for comprehending how programs execute within the zkVM and how that execution translates into provable constraints.

The architecture follows the Reduced Instruction Set Computing philosophy: simple instructions, regular encoding, and load-store memory access. These properties make RISC-V particularly suitable for zkVM implementation—the regularity simplifies constraint design, and the simplicity reduces the number of distinct cases the proving system must handle.

## Architecture Overview

### Design Philosophy

Core RISC-V principles:

```
Simplicity:
  Fixed instruction width (32 bits base)
  Regular instruction formats
  Orthogonal design decisions
  Minimal special cases

Modularity:
  Base integer ISA (I)
  Standard extensions (M, A, F, D, C)
  Custom extensions possible
  Pick only what's needed

Load-Store Architecture:
  Arithmetic on registers only
  Explicit load/store for memory
  No memory-to-memory operations
  Clean separation of concerns
```

### Register Set

General-purpose registers:

```
Register file:
  32 registers (x0-x31)
  x0 is hardwired to zero
  x1-x31 are general purpose
  32 bits wide (RV32) or 64 bits (RV64)

Conventions (ABI):
  x1 (ra): Return address
  x2 (sp): Stack pointer
  x8 (fp/s0): Frame pointer
  x10-x17 (a0-a7): Arguments/returns
  x5-x7, x28-x31 (t0-t6): Temporaries
  x8-x9, x18-x27 (s0-s11): Saved registers

Special behavior:
  Writes to x0 are ignored
  Reads from x0 always return 0
  Simplifies instruction encoding
```

### Program Counter

Instruction sequencing:

```
PC properties:
  Points to current instruction
  Usually advances by 4 (instruction width)
  Modified by branches and jumps
  Must be aligned (typically 4-byte)

Control flow:
  Sequential: PC += 4
  Branch: PC += offset (if condition)
  Jump: PC = target
  Call: ra = PC + 4, PC = target
```

## Instruction Formats

### R-Type Format

Register-to-register operations:

```
Bit layout:
  [31:25] funct7  - Operation variant
  [24:20] rs2     - Source register 2
  [19:15] rs1     - Source register 1
  [14:12] funct3  - Operation type
  [11:7]  rd      - Destination register
  [6:0]   opcode  - Major opcode

Examples:
  ADD rd, rs1, rs2   - Addition
  SUB rd, rs1, rs2   - Subtraction
  AND rd, rs1, rs2   - Bitwise AND
  OR rd, rs1, rs2    - Bitwise OR
  XOR rd, rs1, rs2   - Bitwise XOR
  SLL rd, rs1, rs2   - Shift left logical
  SRL rd, rs1, rs2   - Shift right logical
  SRA rd, rs1, rs2   - Shift right arithmetic
```

### I-Type Format

Immediate and load operations:

```
Bit layout:
  [31:20] imm[11:0] - 12-bit immediate
  [19:15] rs1       - Source/base register
  [14:12] funct3    - Operation type
  [11:7]  rd        - Destination register
  [6:0]   opcode    - Major opcode

Examples:
  ADDI rd, rs1, imm  - Add immediate
  LW rd, offset(rs1) - Load word
  LB rd, offset(rs1) - Load byte
  JALR rd, rs1, imm  - Jump and link register
```

### S-Type Format

Store operations:

```
Bit layout:
  [31:25] imm[11:5] - Immediate high bits
  [24:20] rs2       - Source register (data)
  [19:15] rs1       - Base register (address)
  [14:12] funct3    - Store type
  [11:7]  imm[4:0]  - Immediate low bits
  [6:0]   opcode    - Major opcode

Examples:
  SW rs2, offset(rs1) - Store word
  SH rs2, offset(rs1) - Store halfword
  SB rs2, offset(rs1) - Store byte
```

### B-Type Format

Conditional branches:

```
Bit layout:
  [31]    imm[12]   - Sign bit
  [30:25] imm[10:5] - Immediate bits
  [24:20] rs2       - Source register 2
  [19:15] rs1       - Source register 1
  [14:12] funct3    - Branch condition
  [11:8]  imm[4:1]  - Immediate bits
  [7]     imm[11]   - Immediate bit
  [6:0]   opcode    - Major opcode

Examples:
  BEQ rs1, rs2, offset  - Branch if equal
  BNE rs1, rs2, offset  - Branch if not equal
  BLT rs1, rs2, offset  - Branch if less than
  BGE rs1, rs2, offset  - Branch if greater/equal
```

### U-Type Format

Upper immediate operations:

```
Bit layout:
  [31:12] imm[31:12] - 20-bit upper immediate
  [11:7]  rd         - Destination register
  [6:0]   opcode     - Major opcode

Examples:
  LUI rd, imm    - Load upper immediate
  AUIPC rd, imm  - Add upper immediate to PC

Usage:
  Build 32-bit constants (with ADDI)
  PC-relative addressing (AUIPC)
```

### J-Type Format

Unconditional jumps:

```
Bit layout:
  [31]    imm[20]    - Sign bit
  [30:21] imm[10:1]  - Immediate bits
  [20]    imm[11]    - Immediate bit
  [19:12] imm[19:12] - Immediate bits
  [11:7]  rd         - Destination (return addr)
  [6:0]   opcode     - Major opcode

Example:
  JAL rd, offset - Jump and link
```

## Base Integer Instructions

### Arithmetic Operations

Integer computation:

```
Register-register:
  ADD  - Addition
  SUB  - Subtraction
  SLT  - Set if less than (signed)
  SLTU - Set if less than (unsigned)

Register-immediate:
  ADDI  - Add immediate
  SLTI  - Set if less than immediate
  SLTIU - Set if less than immediate unsigned

No SUB immediate:
  Use ADDI with negative value
  Simplifies hardware
```

### Logical Operations

Bitwise operations:

```
Register-register:
  AND - Bitwise AND
  OR  - Bitwise OR
  XOR - Bitwise XOR

Register-immediate:
  ANDI - AND with immediate
  ORI  - OR with immediate
  XORI - XOR with immediate

Notes:
  No NOT instruction
  Use XORI with -1 (all ones)
```

### Shift Operations

Bit shifting:

```
Register-register:
  SLL - Shift left logical
  SRL - Shift right logical
  SRA - Shift right arithmetic

Register-immediate:
  SLLI - Shift left logical immediate
  SRLI - Shift right logical immediate
  SRAI - Shift right arithmetic immediate

Shift amount:
  Bottom 5 bits of rs2 (RV32)
  Bottom 6 bits of rs2 (RV64)
```

### Load and Store

Memory access:

```
Loads:
  LW  - Load word (32 bits)
  LH  - Load halfword (16 bits, sign-extend)
  LHU - Load halfword unsigned
  LB  - Load byte (8 bits, sign-extend)
  LBU - Load byte unsigned

Stores:
  SW - Store word
  SH - Store halfword
  SB - Store byte

Address calculation:
  Effective address = rs1 + sign_extend(offset)
```

### Control Flow

Branching and jumping:

```
Conditional branches:
  BEQ  - Branch if equal
  BNE  - Branch if not equal
  BLT  - Branch if less than (signed)
  BGE  - Branch if greater or equal (signed)
  BLTU - Branch if less than (unsigned)
  BGEU - Branch if greater or equal (unsigned)

Unconditional jumps:
  JAL  - Jump and link (direct)
  JALR - Jump and link register (indirect)

PC update:
  Branches: PC + offset (if condition)
  JAL: PC + offset (always)
  JALR: (rs1 + offset) & ~1
```

## Standard Extensions

### M Extension (Multiplication)

Multiply and divide:

```
Multiplication:
  MUL    - Multiply (low 32 bits of result)
  MULH   - Multiply high (signed × signed)
  MULHU  - Multiply high (unsigned × unsigned)
  MULHSU - Multiply high (signed × unsigned)

Division:
  DIV  - Divide (signed)
  DIVU - Divide (unsigned)
  REM  - Remainder (signed)
  REMU - Remainder (unsigned)

zkVM consideration:
  Division is expensive to prove
  May use precomputation strategies
```

### A Extension (Atomics)

Atomic operations:

```
Load-reserved/Store-conditional:
  LR.W  - Load reserved word
  SC.W  - Store conditional word

Atomic memory operations:
  AMOSWAP - Atomic swap
  AMOADD  - Atomic add
  AMOAND  - Atomic AND
  AMOOR   - Atomic OR
  AMOXOR  - Atomic XOR
  AMOMIN  - Atomic minimum
  AMOMAX  - Atomic maximum

zkVM consideration:
  Single-threaded execution
  Atomics may be simplified
```

### C Extension (Compressed)

16-bit instructions:

```
Purpose:
  Reduce code size
  Same functionality as base
  Subset of common operations

Mapping:
  Each 16-bit instruction maps to 32-bit
  Hardware expands before execution

zkVM consideration:
  May or may not support
  Complicates instruction decoding
```

## Memory Model

### Address Space

Memory organization:

```
Flat address space:
  Single linear address space
  No segmentation
  32-bit or 64-bit addresses

Regions (typical):
  Code: Executable instructions
  Data: Global variables
  Heap: Dynamic allocation
  Stack: Local variables, call frames
```

### Alignment

Access alignment requirements:

```
Natural alignment:
  Word (4 bytes): Address divisible by 4
  Halfword (2 bytes): Address divisible by 2
  Byte: Any address

Misaligned access:
  May cause exception
  Or may be handled in hardware/software
  zkVM typically requires alignment
```

### Memory Ordering

Order of memory operations:

```
RISC-V memory model:
  RVWMO (RISC-V Weak Memory Ordering)
  Relaxed by default

Fence instructions:
  FENCE - Memory barrier
  FENCE.I - Instruction barrier

zkVM context:
  Single-threaded simplifies ordering
  Sequential consistency sufficient
```

## Key Concepts

- **RISC philosophy**: Simple, regular instruction set
- **Register file**: 32 general-purpose registers
- **Instruction formats**: Six regular formats (R, I, S, B, U, J)
- **Load-store architecture**: Memory access via dedicated instructions
- **Modular extensions**: Add capabilities as needed

## Design Considerations

### Format Regularity

| Benefit | Trade-off |
|---------|-----------|
| Simpler decoding | Some encoding waste |
| Easier constraints | Less instruction density |
| Predictable layout | Fixed-width instructions |

### Extension Selection

| More Extensions | Fewer Extensions |
|-----------------|------------------|
| More functionality | Simpler implementation |
| Larger circuits | Smaller proof size |
| Compatibility | Custom programs |

## Related Topics

- [Instruction Transpilation](02-instruction-transpilation.md) - Converting to zkVM format
- [Register Mapping](03-register-mapping.md) - Register handling in zkVM
- [State Machine Abstraction](../02-state-machine-design/01-state-machine-abstraction.md) - Execution model

