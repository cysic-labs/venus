# RISC-V Execution Model

## Overview

The RISC-V execution model defines how a zkVM interprets and executes RISC-V instructions while generating the execution trace needed for proof generation. RISC-V was chosen as the instruction set architecture (ISA) for its simplicity, open standard nature, and mature toolchain support. The execution model must faithfully implement RISC-V semantics while structuring computation in a way that enables efficient constraint generation.

A zkVM's execution model bridges two worlds: the sequential world of program execution where instructions modify state step by step, and the algebraic world of polynomial constraints where all steps must satisfy equations simultaneously. The execution model captures every state transition in a format amenable to both verification approaches.

This document covers RISC-V instruction semantics, the execution cycle, state representation, and how execution maps to the constraint system.

## RISC-V Architecture

### Register File

The RISC-V register file:

```
32 general-purpose registers: x0 through x31
  x0: Hardwired to zero (reads always return 0)
  x1 (ra): Return address (by convention)
  x2 (sp): Stack pointer (by convention)
  x3-x31: General purpose

Register width: 32 bits (RV32) or 64 bits (RV64)

Special registers:
  pc: Program counter
  Additional CSRs for privileged operations (if supported)
```

### Instruction Formats

RISC-V instruction encoding formats:

```
R-type (register-register):
  [funct7][rs2][rs1][funct3][rd][opcode]
  Example: add rd, rs1, rs2

I-type (immediate):
  [imm[11:0]][rs1][funct3][rd][opcode]
  Example: addi rd, rs1, imm

S-type (store):
  [imm[11:5]][rs2][rs1][funct3][imm[4:0]][opcode]
  Example: sw rs2, offset(rs1)

B-type (branch):
  [imm[12|10:5]][rs2][rs1][funct3][imm[4:1|11]][opcode]
  Example: beq rs1, rs2, offset

U-type (upper immediate):
  [imm[31:12]][rd][opcode]
  Example: lui rd, imm

J-type (jump):
  [imm[20|10:1|11|19:12]][rd][opcode]
  Example: jal rd, offset
```

### Base Instruction Set

Core RV32I/RV64I instructions:

```
Arithmetic:
  add, sub, addi
  slt, slti, sltu, sltiu (set less than)

Logical:
  and, or, xor, andi, ori, xori

Shift:
  sll, srl, sra (shift left/right logical/arithmetic)
  slli, srli, srai

Load/Store:
  lb, lh, lw, ld (load byte/half/word/double)
  lbu, lhu, lwu (load unsigned)
  sb, sh, sw, sd (store)

Branch:
  beq, bne (equal, not equal)
  blt, bge (less than, greater or equal)
  bltu, bgeu (unsigned variants)

Jump:
  jal (jump and link)
  jalr (jump and link register)

Upper immediate:
  lui (load upper immediate)
  auipc (add upper immediate to PC)
```

### Extensions

Common RISC-V extensions:

```
M extension (multiplication/division):
  mul, mulh, mulhsu, mulhu
  div, divu, rem, remu

A extension (atomic):
  lr.w, sc.w (load-reserved, store-conditional)
  amo* (atomic memory operations)

F/D extensions (floating-point):
  fadd, fsub, fmul, fdiv
  Load/store floating-point

C extension (compressed):
  16-bit instruction encodings
  Reduces code size
```

## Execution Cycle

### Fetch-Decode-Execute

The classic instruction cycle:

```
For each cycle:
  1. Fetch: Read instruction at PC from memory
  2. Decode: Parse opcode, extract operands
  3. Execute: Perform operation
  4. Writeback: Update destination register
  5. Update PC: Next instruction or branch target

In zkVM context:
  Each cycle produces one trace row
  All state changes recorded in trace columns
```

### Cycle State

State captured each cycle:

```
Pre-execution state:
  - Current PC
  - All register values
  - Relevant memory values

Instruction information:
  - Encoded instruction
  - Decoded opcode
  - Source register indices and values
  - Immediate value

Post-execution state:
  - Next PC
  - Modified register value
  - Memory write (if any)
```

### Control Flow

Handling branches and jumps:

```
Sequential execution:
  next_pc = pc + 4 (or +2 for compressed)

Conditional branch (e.g., beq rs1, rs2, offset):
  if registers[rs1] == registers[rs2]:
    next_pc = pc + sign_extend(offset)
  else:
    next_pc = pc + 4

Unconditional jump (jal rd, offset):
  registers[rd] = pc + 4  // Save return address
  next_pc = pc + sign_extend(offset)

Indirect jump (jalr rd, rs1, offset):
  registers[rd] = pc + 4
  next_pc = (registers[rs1] + sign_extend(offset)) & ~1
```

## State Representation

### Trace Columns

Mapping execution to trace:

```
Program counter columns:
  pc: Current instruction address
  next_pc: Address of next instruction

Register columns:
  reg[0..31]: Current register values
  rd_value: Value to write to destination

Instruction columns:
  instruction: Encoded instruction word
  opcode: Decoded operation type
  rs1_idx, rs2_idx, rd_idx: Register indices
  rs1_val, rs2_val: Source register values
  immediate: Immediate value (sign-extended)

Control columns:
  is_branch: Branch instruction flag
  branch_taken: Branch condition result
  is_jump: Jump instruction flag
  is_load: Memory load flag
  is_store: Memory store flag

Memory columns:
  mem_addr: Memory access address
  mem_value: Memory value (read or written)
```

### Register File Constraints

Ensuring register consistency:

```
Register read constraints:
  rs1_val = reg[rs1_idx]
  rs2_val = reg[rs2_idx]

Register write constraints:
  For each register i:
    reg'[i] = if (rd_idx == i and rd_idx != 0):
                rd_value
              else:
                reg[i]

x0 hardwired:
  reg[0] = 0 (always)
```

### Memory Access Constraints

Memory operation encoding:

```
Load:
  is_load = 1
  mem_addr = rs1_val + immediate
  rd_value = memory_read_value (from memory subsystem)

Store:
  is_store = 1
  mem_addr = rs1_val + immediate
  mem_value = rs2_val

Memory consistency:
  Coordinated with memory state machine
  Lookup/permutation arguments link to memory trace
```

## Instruction Constraints

### Arithmetic Instructions

Constraining arithmetic operations:

```
ADD: rd_value = rs1_val + rs2_val
SUB: rd_value = rs1_val - rs2_val
ADDI: rd_value = rs1_val + immediate

For each instruction type:
  selector * (rd_value - expected_value) = 0

Example (ADD):
  is_add * (rd_value - (rs1_val + rs2_val)) = 0
```

### Logical Instructions

Bitwise operations:

```
AND: rd_value = rs1_val & rs2_val
OR:  rd_value = rs1_val | rs2_val
XOR: rd_value = rs1_val ^ rs2_val

These require bit decomposition for efficient constraints.
Typically delegated to binary state machine.
```

### Comparison Instructions

Set-less-than operations:

```
SLT (signed):
  rd_value = 1 if signed(rs1_val) < signed(rs2_val) else 0

SLTU (unsigned):
  rd_value = 1 if rs1_val < rs2_val else 0

Comparison constraints:
  Decompose into subtraction + sign check
  Or use lookup table for common cases
```

### Branch Instructions

Branch condition evaluation:

```
BEQ: branch_taken = (rs1_val == rs2_val)
BNE: branch_taken = (rs1_val != rs2_val)
BLT: branch_taken = signed(rs1_val) < signed(rs2_val)
BGE: branch_taken = signed(rs1_val) >= signed(rs2_val)

PC update:
  is_branch * branch_taken * (next_pc - (pc + immediate)) = 0
  is_branch * (1 - branch_taken) * (next_pc - (pc + 4)) = 0
```

### Load/Store Instructions

Memory access size handling:

```
Load byte (LB):
  byte_value = memory[addr]
  rd_value = sign_extend_8_to_64(byte_value)

Load word (LW):
  word_value = memory[addr:addr+4]
  rd_value = sign_extend_32_to_64(word_value)

Store byte (SB):
  memory[addr] = rs2_val[7:0]

Alignment:
  May require alignment constraints
  Or handle misalignment with multiple memory ops
```

## Instruction Decoding

### Decode Logic

Extracting instruction fields:

```
Given 32-bit instruction word:
  opcode = instruction[6:0]
  rd_idx = instruction[11:7]
  funct3 = instruction[14:12]
  rs1_idx = instruction[19:15]
  rs2_idx = instruction[24:20]
  funct7 = instruction[31:25]

Immediate extraction varies by format:
  I-type: imm = sign_extend(instruction[31:20])
  S-type: imm = sign_extend(instruction[31:25] || instruction[11:7])
  B-type: imm = sign_extend(instruction[31] || instruction[7] ||
                            instruction[30:25] || instruction[11:8] || 0)
  ...
```

### Selector Generation

One-hot encoding for instruction type:

```
Based on opcode and funct3/funct7:
  is_add = (opcode == OP) and (funct3 == 0) and (funct7 == 0)
  is_sub = (opcode == OP) and (funct3 == 0) and (funct7 == 32)
  is_and = (opcode == OP) and (funct3 == 7) and (funct7 == 0)
  ...

Constraint: Exactly one selector is 1
  sum(all_selectors) = 1
```

### Instruction Validation

Ensure instruction is valid:

```
Lookup against instruction table:
  (opcode, funct3, funct7) in valid_instructions

Or enumerate valid combinations:
  sum(valid_selector_i) = 1
  Implicitly rejects invalid instructions
```

## System Interface

### Memory Interface

Connection to memory system:

```
Memory request:
  request_type: read or write
  address: mem_addr
  size: byte, half, word, double
  value: for writes, rs2_val

Memory response:
  For reads: value loaded into rd_value
  For writes: acknowledgment

Coordination via bus or permutation argument.
```

### System Calls

Handling ecall/ebreak:

```
ECALL: System call
  Behavior depends on execution environment
  May trigger special handling path
  Recorded in trace for constraint purposes

EBREAK: Debugger breakpoint
  Typically terminates execution
  Or triggers special mode
```

### Termination

Detecting program completion:

```
Termination conditions:
  - Specific exit ecall
  - Jump to designated halt address
  - Instruction limit reached

Trace padding:
  After termination, pad to power-of-two length
  Padding rows satisfy constraints (e.g., no-op or repeat state)
```

## Key Concepts

- **RISC-V ISA**: Open standard instruction set architecture
- **Execution cycle**: Fetch-decode-execute-writeback sequence
- **Trace mapping**: Recording execution state for proving
- **Instruction constraints**: Polynomial equations encoding semantics
- **Selector pattern**: One-hot encoding for instruction dispatch

## Design Considerations

### Instruction Coverage

| Full ISA | Subset ISA |
|----------|------------|
| Maximum compatibility | Simpler constraints |
| More instruction types | Fewer selectors |
| Larger circuits | Smaller circuits |
| Any program works | Programs must use subset |

### Extension Support

| With Extensions | Base Only |
|-----------------|-----------|
| Efficient crypto, math | Emulated in software |
| More constraint types | Simpler system |
| Larger proving circuits | Smaller circuits |
| Faster execution | Slower execution |

## Related Topics

- [Execution Trace](02-execution-trace.md) - Trace structure details
- [Instruction Cycle](03-instruction-cycle.md) - Cycle-level details
- [Main State Machine](../02-state-machine-design/02-main-state-machine.md) - State machine implementation
- [Memory System](../03-memory-system/01-memory-architecture.md) - Memory handling
