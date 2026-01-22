# Instruction Encoding

## Overview

Instruction encoding defines how operations are represented in binary form for the zkVM to execute. While the zkVM executes RISC-V programs, the internal encoding may differ from standard RISC-V to optimize for constraint efficiency. The encoding determines how opcodes, operands, and immediate values are packed into instruction words and how the state machine decodes these for execution.

Understanding instruction encoding is essential for grasping how the fetch-decode-execute cycle works within the zkVM. The encoding influences constraint design, trace width, and the efficiency of instruction dispatch. A well-designed encoding minimizes the constraint degree needed to select the appropriate operation while providing all necessary operand information.

This document covers both the source RISC-V encoding and any transformations applied for zkVM-internal representation.

## RISC-V Base Encoding

### Standard Instruction Formats

The six RISC-V instruction formats:

```
R-type (register-register):
  [31:25] funct7   [24:20] rs2   [19:15] rs1
  [14:12] funct3   [11:7] rd     [6:0] opcode

I-type (immediate):
  [31:20] imm[11:0]   [19:15] rs1
  [14:12] funct3      [11:7] rd   [6:0] opcode

S-type (store):
  [31:25] imm[11:5]   [24:20] rs2   [19:15] rs1
  [14:12] funct3      [11:7] imm[4:0]   [6:0] opcode

B-type (branch):
  [31] imm[12]   [30:25] imm[10:5]   [24:20] rs2   [19:15] rs1
  [14:12] funct3   [11:8] imm[4:1]   [7] imm[11]   [6:0] opcode

U-type (upper immediate):
  [31:12] imm[31:12]   [11:7] rd   [6:0] opcode

J-type (jump):
  [31] imm[20]   [30:21] imm[10:1]   [20] imm[11]
  [19:12] imm[19:12]   [11:7] rd   [6:0] opcode
```

### Field Meanings

What each field encodes:

```
opcode (7 bits):
  Primary operation category
  Distinguishes load, store, branch, ALU, etc.

funct3 (3 bits):
  Operation subtype within category
  E.g., ADD vs SUB, BEQ vs BNE

funct7 (7 bits):
  Further operation distinction
  E.g., ADD vs SUB (bit 30 differs)

rd (5 bits):
  Destination register (0-31)
  Result written here

rs1, rs2 (5 bits each):
  Source registers
  Operand values read from these

imm (variable):
  Immediate value
  Position depends on format
```

### Immediate Reconstruction

Assembling immediate values:

```
I-type immediate:
  imm = sign_extend(inst[31:20])
  12 bits, sign-extended to 32

S-type immediate:
  imm = sign_extend({inst[31:25], inst[11:7]})
  Split across two fields

B-type immediate:
  imm = sign_extend({inst[31], inst[7], inst[30:25], inst[11:8], 1'b0})
  Encodes halfword offset

U-type immediate:
  imm = {inst[31:12], 12'b0}
  Upper 20 bits, lower 12 zero

J-type immediate:
  imm = sign_extend({inst[31], inst[19:12], inst[20], inst[30:21], 1'b0})
  20-bit offset
```

## zkVM Internal Encoding

### Normalized Format

Transforming for constraint efficiency:

```
Internal representation:
  opcode_internal: Unified operation code
  rs1, rs2, rd: Register specifiers (5 bits each)
  imm: Full-width immediate (32 bits)
  flags: Modifier bits

Benefits:
  Fixed-width immediate (no reconstruction)
  Consistent field positions
  Simplified constraint design
```

### Opcode Transformation

Mapping RISC-V to internal opcodes:

```
RISC-V has:
  Combined opcode + funct3 + funct7
  Determines exact operation

Internal opcode:
  Single field encodes operation
  Direct lookup for execution
  No field combination needed

Example mapping:
  R-type ADD:  opcode=0x33, f3=0, f7=0 → internal 0x01
  R-type SUB:  opcode=0x33, f3=0, f7=0x20 → internal 0x02
  I-type ADDI: opcode=0x13, f3=0 → internal 0x03
```

### Pre-computed Values

What is computed at load time:

```
Pre-computed:
  Sign-extended immediates
  Absolute branch targets (if static)
  Combined function codes

Runtime:
  Register values
  Computed addresses
  Condition results
```

## Instruction Decoding

### Decode Process

Extracting fields from instruction:

```
Standard RISC-V decode:
  1. Read 32-bit instruction word
  2. Extract opcode (bits 6:0)
  3. Determine format from opcode
  4. Extract fields per format

zkVM decode:
  If internal format: direct field read
  If RISC-V format: format-specific extract
```

### Field Extraction Constraints

Proving correct extraction:

```
Bit extraction:
  rd = (inst >> 7) & 0x1F
  rs1 = (inst >> 15) & 0x1F
  rs2 = (inst >> 20) & 0x1F

Constraint:
  inst = (component parts combined)
  Each field in valid range
```

### Immediate Sign Extension

Extending short immediates:

```
12-bit to 32-bit:
  sign_bit = imm12[11]
  extended = (sign_bit ? 0xFFFFF000 : 0) | imm12

Constraint:
  extended[31:12] = all same as extended[11]
  extended[11:0] = imm12
```

## Encoding for Constraint Efficiency

### Operation Selection

Using opcode for operation dispatch:

```
Selector columns:
  is_add, is_sub, is_and, is_or, ...
  One active per instruction

Computation:
  result = is_add * add_result +
           is_sub * sub_result +
           is_and * and_result + ...

Constraint degree:
  Each selector multiplied by result
  Total degree depends on structure
```

### Operand Access

Providing operands for computation:

```
Source operands:
  op1 = register_file[rs1]
  op2 = is_immediate ? imm : register_file[rs2]

Constraint:
  op1 correct from register lookup
  op2 selected appropriately
```

### Result Routing

Directing results correctly:

```
Destination:
  rd specifies target register
  Result written to register_file[rd]
  Unless rd = 0 (discard)

Constraint:
  register_file'[rd] = result (if rd != 0)
  register_file'[i] = register_file[i] (for i != rd)
```

## Compressed Instructions (C Extension)

### 16-bit Encodings

Optional compressed instruction support:

```
C extension:
  Common instructions in 16 bits
  Reduces code size
  Expands to 32-bit equivalent

Encoding:
  Bits 1:0 not equal to 11 indicates compressed
  Different formats for compact representation
```

### Handling in zkVM

Options for compressed instructions:

```
Option A - Expansion:
  At load time, expand to 32-bit
  ROM stores expanded instructions
  Uniform execution

Option B - Dual decode:
  Detect instruction width
  Separate decode paths
  More complex but space-efficient

Option C - No support:
  Require non-compressed binaries
  Simpler implementation
```

## Instruction Categories

### ALU Operations

Arithmetic and logic encoding:

```
Register-register:
  ADD, SUB, AND, OR, XOR, SLL, SRL, SRA
  SLT, SLTU
  Use R-type format

Register-immediate:
  ADDI, ANDI, ORI, XORI, SLLI, SRLI, SRAI
  SLTI, SLTIU
  Use I-type format
```

### Memory Operations

Load and store encoding:

```
Loads (I-type):
  LW, LH, LHU, LB, LBU
  Address = rs1 + imm

Stores (S-type):
  SW, SH, SB
  Address = rs1 + imm
  Data from rs2
```

### Control Flow

Branch and jump encoding:

```
Branches (B-type):
  BEQ, BNE, BLT, BGE, BLTU, BGEU
  Compare rs1, rs2
  Target = PC + imm

Jumps:
  JAL (J-type): target = PC + imm, rd = PC + 4
  JALR (I-type): target = rs1 + imm, rd = PC + 4
```

### Special Instructions

Upper immediate and system:

```
Upper immediate (U-type):
  LUI: rd = imm << 12
  AUIPC: rd = PC + (imm << 12)

System:
  ECALL, EBREAK
  Fence operations
```

## Encoding Validation

### Valid Instruction Check

Ensuring instruction is legitimate:

```
Validation:
  Opcode in valid set
  Fields in range
  Reserved bits as expected

Constraint:
  is_valid_instruction = 1
  Or: trap on invalid
```

### Reserved Encoding Handling

Undefined instruction patterns:

```
Behavior options:
  Trap to handler
  Constraint failure (invalid proof)
  Defined behavior (implementation choice)

zkVM approach:
  Typically constraint failure
  Invalid instructions not provable
```

## Key Concepts

- **Instruction encoding**: Binary representation of operations
- **Field extraction**: Obtaining opcodes, registers, immediates
- **Format types**: R, I, S, B, U, J formats in RISC-V
- **Internal format**: Normalized representation for zkVM
- **Immediate reconstruction**: Assembling scattered immediate bits

## Design Trade-offs

### Native vs Normalized Encoding

| Native RISC-V | Normalized Internal |
|---------------|---------------------|
| Standard binary | Custom format |
| Complex decode | Simple decode |
| Direct ROM use | ROM transformation |

### Compressed Instruction Support

| With C Extension | Without C Extension |
|------------------|---------------------|
| Smaller programs | Uniform 32-bit |
| Complex decode | Simple decode |
| Variable width | Fixed width |

## Related Topics

- [Execution Trace](02-execution-trace.md) - How instructions form traces
- [RISC-V Fundamentals](../01-isa-integration/01-risc-v-fundamentals.md) - ISA basics
- [Instruction Transpilation](../01-isa-integration/02-instruction-transpilation.md) - Format conversion
- [Main State Machine](../02-state-machine-design/02-main-state-machine.md) - Execution engine

