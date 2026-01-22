# Instruction Decoding

## Overview

Instruction decoding transforms raw instruction bytes into structured components that drive execution. In a zkVM, this process must be constrained to ensure the prover cannot decode instructions incorrectly or fabricate nonexistent instructions. The decoding constraints verify that each instruction's opcode, registers, and immediates are extracted correctly from the instruction encoding.

RISC-V's instruction formats provide regularity that simplifies decoding constraints. Register specifiers occupy consistent bit positions across formats, and the opcode field always resides in the low seven bits. This regularity translates to reusable constraint patterns that apply across instruction types, reducing the constraint complexity compared to architectures with more varied encodings.

This document covers instruction decoding mechanisms, field extraction constraints, format handling, and optimization strategies for efficient decoding verification.

## RISC-V Instruction Formats

### Format Overview

RISC-V defines six base instruction formats:

```
R-type (Register-Register):
  [funct7 | rs2 | rs1 | funct3 | rd | opcode]
  [31:25] [24:20] [19:15] [14:12] [11:7] [6:0]

I-type (Immediate):
  [imm[11:0] | rs1 | funct3 | rd | opcode]
  [31:20]    [19:15] [14:12] [11:7] [6:0]

S-type (Store):
  [imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode]
  [31:25]    [24:20] [19:15] [14:12] [11:7]    [6:0]

B-type (Branch):
  [imm[12|10:5] | rs2 | rs1 | funct3 | imm[4:1|11] | opcode]
  [31:25]       [24:20] [19:15] [14:12] [11:7]       [6:0]

U-type (Upper Immediate):
  [imm[31:12] | rd | opcode]
  [31:12]     [11:7] [6:0]

J-type (Jump):
  [imm[20|10:1|11|19:12] | rd | opcode]
  [31:12]                 [11:7] [6:0]
```

### Field Positions

Common field locations:

```
Opcode (all formats):
  Bits [6:0], always present
  7 bits, 128 possible values
  Major operation class

Register destination (rd):
  Bits [11:7]
  Present in R, I, U, J formats
  Absent in S, B formats

Register source 1 (rs1):
  Bits [19:15]
  Present in R, I, S, B formats
  Absent in U, J formats

Register source 2 (rs2):
  Bits [24:20]
  Present in R, S, B formats
  Absent in I, U, J formats

funct3:
  Bits [14:12]
  Sub-operation specifier
  Present in R, I, S, B formats

funct7:
  Bits [31:25]
  Further sub-operation specifier
  Present only in R format
```

### Immediate Encoding

Immediate value construction:

```
I-type immediate:
  imm[11:0] = instruction[31:20]
  Sign-extended from bit 31

S-type immediate:
  imm[11:5] = instruction[31:25]
  imm[4:0] = instruction[11:7]
  Sign-extended from bit 31

B-type immediate:
  imm[12] = instruction[31]
  imm[10:5] = instruction[30:25]
  imm[4:1] = instruction[11:8]
  imm[11] = instruction[7]
  Sign-extended, always even (bit 0 = 0)

U-type immediate:
  imm[31:12] = instruction[31:12]
  imm[11:0] = 0
  Upper 20 bits only

J-type immediate:
  imm[20] = instruction[31]
  imm[10:1] = instruction[30:21]
  imm[11] = instruction[20]
  imm[19:12] = instruction[19:12]
  Sign-extended, always even
```

## Decoding Mechanism

### Field Extraction

Extracting fields from instruction:

```
Constraint approach:
  instruction = known 32-bit value

  // Decompose into fields
  instruction = opcode
              + rd * 2^7
              + funct3 * 2^12
              + rs1 * 2^15
              + rs2 * 2^20
              + funct7 * 2^25

Constraints:
  // Range constraints via lookup
  opcode in [0, 127]
  rd in [0, 31]
  funct3 in [0, 7]
  rs1 in [0, 31]
  rs2 in [0, 31]
  funct7 in [0, 127]

  // Reconstruction
  instruction = opcode + rd*128 + funct3*4096 + rs1*32768
              + rs2*1048576 + funct7*33554432
```

### Format Detection

Determining instruction format:

```
Format from opcode:
  opcode_class = opcode & 0x7F

  is_r_type = (opcode_class in R_TYPE_OPCODES)
  is_i_type = (opcode_class in I_TYPE_OPCODES)
  is_s_type = (opcode_class in S_TYPE_OPCODES)
  is_b_type = (opcode_class in B_TYPE_OPCODES)
  is_u_type = (opcode_class in U_TYPE_OPCODES)
  is_j_type = (opcode_class in J_TYPE_OPCODES)

Opcode classes (examples):
  0x33 (0110011): R-type (register arithmetic)
  0x13 (0010011): I-type (immediate arithmetic)
  0x23 (0100011): S-type (store)
  0x63 (1100011): B-type (branch)
  0x37 (0110111): U-type (LUI)
  0x6F (1101111): J-type (JAL)
```

### Immediate Reconstruction

Building immediate values:

```
I-type immediate extraction:
  imm_i = instruction[31:20]

  // Sign extension
  sign_bit = imm_i[11]
  extended = sign_bit ? (0xFFFFF << 12) : 0
  imm_i_signed = extended | imm_i

S-type immediate extraction:
  imm_s_lo = instruction[11:7]    // bits 4:0
  imm_s_hi = instruction[31:25]   // bits 11:5
  imm_s = (imm_s_hi << 5) | imm_s_lo

  // Sign extension
  sign_bit = imm_s_hi[6]
  imm_s_signed = sign_extend_12(imm_s)

B-type immediate extraction:
  bit_12 = instruction[31]
  bits_10_5 = instruction[30:25]
  bits_4_1 = instruction[11:8]
  bit_11 = instruction[7]

  imm_b = (bit_12 << 12) | (bit_11 << 11)
        | (bits_10_5 << 5) | (bits_4_1 << 1)
  imm_b_signed = sign_extend_13(imm_b)
```

## Constraint Structure

### Decomposition Constraints

Proving field extraction:

```
Columns for decoded fields:
  inst: Full instruction
  op: Opcode field
  rd: Destination register
  f3: funct3 field
  rs1: Source register 1
  rs2: Source register 2
  f7: funct7 field

Decomposition constraint:
  inst = op + rd*128 + f3*4096 + rs1*32768
       + rs2*1048576 + f7*33554432

Range constraints (via lookup):
  op in range_7bit
  rd in range_5bit
  f3 in range_3bit
  rs1 in range_5bit
  rs2 in range_5bit
  f7 in range_7bit
```

### Format-Specific Constraints

Handling format variations:

```
For S-type (no rd, split immediate):
  is_s_type * (rd_is_used - 0) = 0  // rd not used
  is_s_type * (imm - imm_s_computed) = 0

  imm_s_computed = imm_s_hi * 32 + imm_s_lo
  where:
    imm_s_hi = f7  // instruction[31:25]
    imm_s_lo = rd  // instruction[11:7] repurposed

For B-type (no rd, special immediate):
  is_b_type * (rd_is_used - 0) = 0
  is_b_type * (imm - imm_b_computed) = 0

  imm_b_computed requires bit manipulation
```

### Valid Instruction Check

Ensuring instruction is valid:

```
Valid opcode constraint:
  (opcode, funct3, funct7) in valid_instruction_table

  OR

  is_valid_add = is_r_type * (f3 == 0) * (f7 == 0)
  is_valid_sub = is_r_type * (f3 == 0) * (f7 == 0x20)
  ...

  is_valid = is_valid_add + is_valid_sub + ...
  is_valid = 1  // Must be valid
```

## Lookup-Based Decoding

### Instruction Table

Precomputed instruction properties:

```
Table structure:
  (opcode, funct3, funct7) -> (format, operation, properties)

Table entries (examples):
  (0x33, 0x0, 0x00) -> (R, ADD, reads_rs1_rs2_writes_rd)
  (0x33, 0x0, 0x20) -> (R, SUB, reads_rs1_rs2_writes_rd)
  (0x13, 0x0, 0x00) -> (I, ADDI, reads_rs1_writes_rd)
  (0x23, 0x2, 0x00) -> (S, SW, reads_rs1_rs2_memory_write)
  ...

Lookup:
  (opcode, funct3, funct7, format, operation) in instruction_table
```

### Decoding Lookup

Single lookup for full decode:

```
Combined decode table:
  Entry: (instruction_pattern, decoded_info)

  instruction_pattern captures relevant bits
  decoded_info includes:
    - format type
    - operation code
    - which registers used
    - immediate type
    - memory operation flag
    - branch flag

Constraint:
  (inst_key, format, op_code, uses_rd, uses_rs1, uses_rs2,
   imm_type, is_mem, is_branch) in decode_table

Benefits:
  Single lookup replaces multiple constraints
  Prover fills decode columns from table
  Constraint just checks table membership
```

### Compressed Instruction Decoding

For RVC (compressed) extension:

```
16-bit instruction detection:
  is_compressed = (inst[1:0] != 0b11)

Compressed format expansion:
  Full instruction derived from 16-bit encoding
  More complex bit shuffling

Constraint pattern:
  is_compressed * (expanded_inst - expand(compressed_inst)) = 0
  !is_compressed * (expanded_inst - inst) = 0
```

## Optimization Techniques

### Shared Field Extraction

Reusing field positions:

```
Register fields are consistent across formats:
  rs1 always at bits [19:15]
  rs2 always at bits [24:20]
  rd always at bits [11:7] (when present)

Single extraction for all formats:
  Extract once, use based on format

Format selector determines which fields are meaningful:
  is_r_type: rd, rs1, rs2 all meaningful
  is_i_type: rd, rs1 meaningful (rs2 is part of immediate)
  is_u_type: only rd meaningful
```

### Batched Decoding

Decode multiple instructions:

```
If multiple instructions decoded per row:
  inst_0, inst_1, inst_2, ...

  Parallel decomposition:
  Each instruction decomposed independently
  Share lookup table for all

Memory program trace:
  Multiple instructions per trace row
  Reduces per-instruction overhead
```

### Constant Instruction Optimization

For known instruction sequences:

```
If instruction is constant (e.g., program ROM):
  Decode can be precomputed
  Only verify instruction matches expected

Constraint:
  inst = expected_inst  // Single equality

  Decoded fields from precomputation
  No decomposition needed at prove time
```

## Error Handling

### Invalid Instruction Detection

Catching illegal instructions:

```
Invalid instruction cases:
  Opcode not recognized
  funct3/funct7 combination invalid
  Reserved encoding used

Detection:
  is_valid lookup fails
  OR explicit invalid check

Handling:
  Trap to exception handler
  Record exception cause
  Invalid instruction exception (cause = 2)
```

### Alignment Verification

Instruction address alignment:

```
32-bit instructions:
  Address must be 4-byte aligned
  pc[1:0] = 0

16-bit compressed:
  Address must be 2-byte aligned
  pc[0] = 0

Constraint:
  is_compressed * pc[0] = 0
  !is_compressed * (pc[1:0]) = 0

Misalignment:
  Instruction address misaligned exception
```

## Key Concepts

- **Instruction format**: Template for field layout in instruction
- **Field extraction**: Isolating opcode, registers, immediates
- **Format detection**: Determining which format applies
- **Immediate reconstruction**: Building full immediate from scattered bits
- **Decode table**: Lookup-based instruction interpretation

## Design Considerations

### Decomposition Approach

| Constraint-Based | Lookup-Based |
|-----------------|--------------|
| Explicit field math | Table contains decoded info |
| More constraints | Fewer constraints |
| No table overhead | Table commitment cost |
| Flexible | Fixed instruction set |

### Field Granularity

| Individual Bits | Grouped Fields |
|-----------------|----------------|
| Maximum flexibility | Natural boundaries |
| Many columns | Fewer columns |
| Bit-level operations | Field-level operations |
| Slower | Faster |

## Related Topics

- [RISC-V Execution](../01-execution-model/01-risc-v-execution.md) - Execution context
- [Opcode Dispatch](02-opcode-dispatch.md) - Post-decode routing
- [Operand Handling](03-operand-handling.md) - Using decoded fields
- [Main State Machine](../02-state-machine-design/02-main-state-machine.md) - Decode integration
