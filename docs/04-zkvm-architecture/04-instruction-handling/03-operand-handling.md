# Operand Handling

## Overview

Operand handling prepares the inputs for instruction execution by reading register values, constructing immediates, and routing data to functional units. Once an instruction is decoded and dispatched, the operands must be fetched and formatted correctly before the operation can proceed. This includes reading source registers, sign-extending immediates to the full register width, and selecting between register and immediate operands based on the instruction format.

In a zkVM, operand handling is constrained to ensure the prover correctly retrieves register values and constructs immediates. The constraints verify that register reads are consistent with the register file state, that immediates are properly sign-extended, and that the correct operand sources are selected for each instruction type.

This document covers register operand retrieval, immediate construction, operand selection, and constraint patterns for correct operand handling.

## Register Operands

### Register File Model

Conceptual register structure:

```
RISC-V registers:
  x0 (zero): Always reads as 0, writes ignored
  x1-x31: General purpose registers

Register width:
  RV32: 32-bit registers
  RV64: 64-bit registers

Register file state:
  regs[0..31] = current register values
  regs[0] = 0 always
```

### Register Read

Retrieving source operands:

```
For instruction using rs1, rs2:
  rs1_value = regs[rs1_index]
  rs2_value = regs[rs2_index]

Special case x0:
  If rs1_index == 0: rs1_value = 0
  If rs2_index == 0: rs2_value = 0

Constraint:
  (rs1_index == 0) * rs1_value = 0
  (rs1_index != 0) * (rs1_value - regs[rs1_index]) = 0
```

### Register-Trace Consistency

Ensuring correct register values:

```
Register columns in trace:
  rs1_idx: Index of first source register
  rs2_idx: Index of second source register
  rs1_val: Value of rs1
  rs2_val: Value of rs2

Consistency with register state:
  Via permutation/lookup to register file

  (cycle, rs1_idx, rs1_val) matches register file state
  (cycle, rs2_idx, rs2_val) matches register file state

Or inline register columns:
  reg_0, reg_1, ..., reg_31 columns
  rs1_val = sum(rs1_is_i * reg_i) for i in 0..31
```

### Register Selection

Multiplexing register read:

```
One-hot register selection:
  rs1_is_0, rs1_is_1, ..., rs1_is_31

Constraint:
  sum(rs1_is_i) = 1
  rs1_val = sum(rs1_is_i * reg_i)

Binary index approach:
  rs1_idx = 5-bit value
  Decompose and constrain selection

  rs1_idx = sum(rs1_idx_bit_i * 2^i)
  Use binary tree multiplexer
```

## Immediate Operands

### Immediate Types

Format-specific immediates:

```
I-type immediate (12-bit signed):
  Used by: ADDI, SLTI, ANDI, ORI, XORI, loads, JALR
  Range: -2048 to 2047

S-type immediate (12-bit signed):
  Used by: Stores (SB, SH, SW, SD)
  Range: -2048 to 2047
  Bits scattered: [31:25] and [11:7]

B-type immediate (13-bit signed, even):
  Used by: Branches (BEQ, BNE, BLT, BGE, BLTU, BGEU)
  Range: -4096 to 4094 (multiples of 2)
  Bit 0 always 0

U-type immediate (20-bit upper):
  Used by: LUI, AUIPC
  Range: Upper 20 bits of 32-bit value
  Lower 12 bits are 0

J-type immediate (21-bit signed, even):
  Used by: JAL
  Range: -1048576 to 1048574 (multiples of 2)
  Bit 0 always 0
```

### Sign Extension

Extending to register width:

```
Sign extension principle:
  Copy sign bit to fill upper bits

I-type to 32-bit:
  imm_12 = instruction[31:20]
  sign = imm_12[11]
  imm_32 = (sign ? 0xFFFFF000 : 0) | imm_12

I-type to 64-bit:
  sign = imm_12[11]
  imm_64 = (sign ? 0xFFFFFFFFFFFFF000 : 0) | imm_12

Constraint for sign extension:
  sign_bit in {0, 1}
  upper_bits = sign_bit * all_ones_upper
  extended_imm = upper_bits + raw_imm
```

### Immediate Construction

Building immediate from instruction bits:

```
I-type:
  imm = inst[31:20]
  imm_extended = sign_extend_12(imm)

S-type:
  imm_lo = inst[11:7]    // bits 4:0
  imm_hi = inst[31:25]   // bits 11:5
  imm = (imm_hi << 5) | imm_lo
  imm_extended = sign_extend_12(imm)

B-type:
  imm = (inst[31] << 12) | (inst[7] << 11)
      | (inst[30:25] << 5) | (inst[11:8] << 1)
  // Note: bit 0 is always 0
  imm_extended = sign_extend_13(imm)

U-type:
  imm = inst[31:12] << 12
  // No sign extension needed, already 32-bit

J-type:
  imm = (inst[31] << 20) | (inst[19:12] << 12)
      | (inst[20] << 11) | (inst[30:21] << 1)
  imm_extended = sign_extend_21(imm)
```

## Operand Selection

### ALU Operand Sources

Selecting ALU inputs:

```
ALU operand A:
  Usually rs1_value
  For AUIPC: current PC

  alu_a = is_auipc * pc + !is_auipc * rs1_value

ALU operand B:
  Register operand (R-type): rs2_value
  Immediate operand (I-type): immediate

  alu_b = is_r_type * rs2_value + is_i_type * immediate

Constraint:
  is_r_type + is_i_type = is_alu_op
  alu_b = is_r_type * rs2_value + is_i_type * imm_extended
```

### Memory Operand Sources

Address and data selection:

```
Memory address:
  Base + offset
  base = rs1_value
  offset = immediate (I-type for loads, S-type for stores)

  mem_addr = rs1_value + imm_extended

Store data:
  rs2_value (the value to store)

Load destination:
  rd (register to write loaded value)
```

### Branch Operand Sources

Comparison operands:

```
Branch comparison:
  Compare rs1 and rs2

  cmp_a = rs1_value
  cmp_b = rs2_value

Branch target:
  PC-relative: PC + immediate (B-type)
  Register: rs1 + immediate (JALR)

  is_branch * (target - (pc + imm_b)) = 0
  is_jalr * (target - (rs1_value + imm_i)) = 0
```

## Constraint Patterns

### Register Read Constraints

Ensuring correct register retrieval:

```
Columns:
  rs1_idx, rs2_idx: 5-bit register indices
  rs1_val, rs2_val: Register values
  uses_rs1, uses_rs2: Whether registers are used

Constraints:
  // x0 always reads as 0
  (rs1_idx == 0) * rs1_val = 0
  (rs2_idx == 0) * rs2_val = 0

  // Non-x0 reads from register file
  uses_rs1 * (rs1_idx != 0) * (rs1_val - reg_file[rs1_idx]) = 0

  // Register file lookup
  (rs1_idx, rs1_val, cycle) in register_reads_table
```

### Immediate Constraints

Correct immediate formation:

```
Columns:
  imm_raw: Raw immediate bits
  imm_sign: Sign bit
  imm_extended: Sign-extended immediate
  imm_type: Immediate format (I, S, B, U, J)

I-type constraint:
  is_i_imm * (imm_raw - inst[31:20]) = 0
  is_i_imm * (imm_sign - inst[31]) = 0
  is_i_imm * (imm_extended - (imm_sign * UPPER_MASK + imm_raw)) = 0

S-type constraint:
  is_s_imm * (imm_raw - ((inst[31:25] << 5) | inst[11:7])) = 0
  is_s_imm * (imm_extended - sign_extend(imm_raw)) = 0
```

### Operand Selection Constraints

Multiplexing operand sources:

```
ALU operand B selection:
  is_reg_alu + is_imm_alu = is_alu_op

  // Operand B is either rs2 or immediate
  is_reg_alu * (alu_b - rs2_val) = 0
  is_imm_alu * (alu_b - imm_extended) = 0

Alternative (single constraint):
  is_alu_op * (alu_b - (is_reg_alu * rs2_val + is_imm_alu * imm_extended)) = 0
```

## Special Cases

### Zero Register (x0)

Handling reads and writes to x0:

```
Read from x0:
  Always returns 0
  (rs1_idx == 0) implies rs1_val = 0

Write to x0:
  Value discarded
  (rd_idx == 0) implies no state change

Constraint:
  (rd_idx == 0) * (reg_0_next - 0) = 0  // x0 stays 0
  (rd_idx != 0) * (reg_rd_next - rd_value) = 0
```

### PC as Operand

Using program counter:

```
AUIPC uses PC:
  result = PC + (imm_u)

JAL uses PC:
  rd = PC + 4 (return address)
  target = PC + imm_j

Constraint:
  is_auipc * (rd_value - (pc + imm_u)) = 0
  is_jal * (rd_value - (pc + 4)) = 0
```

### Shift Amount

Special handling for shifts:

```
Shift amount from:
  rs2[4:0] for RV32 (0-31)
  rs2[5:0] for RV64 (0-63)

Constraint:
  is_shift_op * (shift_amt - rs2_val[5:0]) = 0

Range check:
  shift_amt in [0, 63] for RV64
```

## Optimization Techniques

### Operand Caching

Reusing recently read values:

```
If same register read in consecutive cycles:
  Value unchanged if not written

Cache opportunity:
  Track last read value per register
  Skip re-read if still valid

Constraint consideration:
  Must still prove consistency
  Caching is prover optimization
```

### Common Subexpression

Sharing computed operands:

```
Address computation:
  base + offset appears in:
    Load address
    Store address
    Branch target (partially)

Share computation:
  addr_sum = rs1_val + imm

  is_load * (mem_addr - addr_sum) = 0
  is_store * (mem_addr - addr_sum) = 0
```

### Operand Forwarding

Handling data hazards:

```
If rd of previous instruction == rs of current:
  Forward result instead of reading register

In constraints:
  Forwarded value must match what register would have

  has_forward * (rs_val - prev_rd_val) = 0
  !has_forward * (rs_val - reg_file_val) = 0
```

## Key Concepts

- **Operand**: Input value to an instruction
- **Register read**: Retrieving value from register file
- **Immediate**: Constant encoded in instruction
- **Sign extension**: Extending signed value to full width
- **Operand selection**: Choosing between register and immediate

## Design Considerations

### Register Access

| Direct Columns | Lookup-Based |
|---------------|--------------|
| 32 register columns | Register table |
| Large trace width | Smaller trace |
| Fast access | Lookup overhead |
| High memory | Lower memory |

### Immediate Handling

| Per-Format Columns | Unified Column |
|-------------------|----------------|
| Separate I, S, B, U, J | Single imm column |
| Format-specific constraints | Selector-based |
| Cleaner logic | Fewer columns |
| More columns | More complex |

## Related Topics

- [Instruction Decoding](01-instruction-decoding.md) - Field extraction
- [Opcode Dispatch](02-opcode-dispatch.md) - Operation routing
- [Result Writeback](04-result-writeback.md) - Storing results
- [Memory System](../03-memory-system/01-memory-architecture.md) - Memory operands
