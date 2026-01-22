# Result Writeback

## Overview

Result writeback is the final stage of instruction execution, where computed results are stored to their destinations. For most instructions, this means writing to a destination register. Memory store instructions write to memory instead. Branch and jump instructions update the program counter. The writeback stage must ensure that state changes are correctly recorded and that the next instruction sees the updated state.

In a zkVM, writeback constraints verify that the correct values are stored to the correct destinations, and that the register file (and memory) evolve correctly from cycle to cycle. These constraints connect the output of execution to the input of the next instruction, maintaining program state consistency throughout the trace.

This document covers writeback mechanisms, register update constraints, memory store handling, and program counter updates.

## Register Writeback

### Destination Register Selection

Determining where to write:

```
Destination from decode:
  rd_idx = instruction[11:7]  // 5-bit register index

Not all instructions write registers:
  R-type, I-type (arithmetic): Write to rd
  Load instructions: Write to rd
  U-type (LUI, AUIPC): Write to rd
  J-type (JAL), JALR: Write to rd
  S-type (stores): No register write
  B-type (branches): No register write

Selector:
  writes_rd = !is_store * !is_branch
```

### Register Write Constraint

Ensuring correct register update:

```
State transition:
  reg_next[i] = new value for register i

For destination register rd:
  writes_rd * (rd_idx != 0) * (reg_next[rd_idx] - result) = 0

For x0 (always zero):
  reg_next[0] = 0

For other registers (not rd):
  (i != rd_idx) * (reg_next[i] - reg_current[i]) = 0
```

### Propagating Unchanged Registers

Registers not written stay the same:

```
Each register has a next-state column:
  reg_0_next, reg_1_next, ..., reg_31_next

Constraints:
  reg_0_next = 0  // Always

  For i in 1..31:
    is_rd_i = (rd_idx == i) * writes_rd

    // If writing to i, use result; otherwise keep current
    is_rd_i * (reg_i_next - result) = 0
    !is_rd_i * (reg_i_next - reg_i_current) = 0

Simplified (using selector):
  reg_i_next = is_rd_i * result + !is_rd_i * reg_i_current
```

### Result Sources

What value gets written:

```
Result depends on instruction type:

ALU operations:
  result = alu_output (add, sub, and, or, xor, shifts, comparisons)

Load operations:
  result = memory_read_value

LUI:
  result = imm_u (upper immediate, lower 12 bits zero)

AUIPC:
  result = pc + imm_u

JAL/JALR:
  result = pc + 4 (return address)

Selector-based:
  result = is_alu * alu_out
         + is_load * mem_val
         + is_lui * imm_u
         + is_auipc * (pc + imm_u)
         + is_jal_or_jalr * (pc + 4)
```

## Memory Writeback

### Store Operations

Writing to memory:

```
Store instructions:
  SB: Store byte
  SH: Store halfword (2 bytes)
  SW: Store word (4 bytes)
  SD: Store doubleword (8 bytes, RV64)

Store data:
  mem_write_value = rs2_value

Store address:
  mem_addr = rs1_value + imm_s
```

### Byte/Halfword Stores

Partial word writes:

```
SB (store byte):
  Writes only 1 byte at address
  Other bytes at same word address unchanged

Constraint approach:
  Decompose word into bytes
  Replace specific byte

  byte_position = addr[1:0]  // Which byte in word
  new_word = old_word with byte_position replaced

SH (store halfword):
  Writes 2 bytes
  half_position = addr[1]  // Which half
```

### Memory State Update

Tracking memory changes:

```
Memory machine receives:
  (addr, value, is_write, timestamp)

For stores:
  is_write = 1
  value = rs2_value (or extracted bytes)
  timestamp = current_cycle

Memory consistency:
  Future reads return stored value
  Until next write to same address
```

## Program Counter Update

### Sequential Execution

Normal PC advancement:

```
For most instructions:
  pc_next = pc + 4  (32-bit instructions)

  OR

  pc_next = pc + 2  (16-bit compressed, if RVC enabled)

Constraint:
  is_sequential * (pc_next - (pc + instruction_size)) = 0
```

### Branch Updates

Conditional PC change:

```
Branch taken:
  pc_next = pc + imm_b (branch offset)

Branch not taken:
  pc_next = pc + 4

Constraint:
  is_branch * branch_taken * (pc_next - (pc + imm_b)) = 0
  is_branch * !branch_taken * (pc_next - (pc + 4)) = 0

Combined:
  is_branch * (pc_next - (pc + branch_taken * imm_b + !branch_taken * 4)) = 0
```

### Jump Updates

Unconditional PC change:

```
JAL:
  pc_next = pc + imm_j

JALR:
  pc_next = (rs1_value + imm_i) & ~1  // Clear low bit

Constraints:
  is_jal * (pc_next - (pc + imm_j)) = 0
  is_jalr * (pc_next - ((rs1_val + imm_i) & MASK)) = 0
```

## Multi-Destination Writeback

### Link Register + PC

JAL and JALR write both:

```
JAL/JALR write to rd and update PC:
  rd = pc + 4 (return address)
  pc_next = target

Both must be constrained:
  is_jal * (rd_value - (pc + 4)) = 0
  is_jal * (pc_next - (pc + imm_j)) = 0
```

### System Instructions

Special state updates:

```
CSR instructions (CSRRW, CSRRS, etc.):
  Read CSR to rd
  Write new value to CSR

  rd = csr_read_value
  csr_next = computed_value

Trap handling:
  Save PC to CSR
  Update privilege level
  Jump to trap handler
```

## Constraint Structure

### Writeback Columns

Trace columns for writeback:

```
Result columns:
  result: Computed result value
  result_source: Which unit produced result

Register columns:
  rd_idx: Destination register index
  writes_rd: Whether writing to rd
  reg_next[0..31]: Next register values

Memory columns:
  mem_write: Is this a store?
  mem_addr: Store address
  mem_value: Store value

PC columns:
  pc_next: Next program counter value
```

### Result Selection Constraint

Choosing result source:

```
Multiple result sources:
  alu_result: From ALU operations
  mem_result: From load operations
  pc_plus_4: For JAL/JALR
  upper_imm: For LUI
  pc_plus_upper: For AUIPC

Selection constraint:
  result = is_alu * alu_result
         + is_load * mem_result
         + is_link * pc_plus_4
         + is_lui * upper_imm
         + is_auipc * pc_plus_upper

Ensure exactly one source:
  is_alu + is_load + is_link + is_lui + is_auipc = writes_rd
```

### Register File Update

Complete register state transition:

```
For each register i:
  updating_i = (rd_idx == i) * writes_rd * (i != 0)

  reg_next[i] = updating_i * result
              + (1 - updating_i) * reg_current[i]

Constraint form:
  updating_i * (reg_next[i] - result) = 0
  (1 - updating_i) * (reg_next[i] - reg_current[i]) = 0
```

## Optimization Techniques

### Sparse Register Updates

Only one register changes:

```
Instead of 32 constraints:
  One constraint for rd
  One constraint for all others (via accumulator)

  rd_value_correct = (reg_next[rd_idx] == result)
  others_unchanged = prod((reg_next[i] - reg_current[i]) for i != rd_idx)

Or via permutation/lookup of unchanged registers.
```

### Deferred Writeback

Batch register updates:

```
If proving multiple instructions per row:
  Track intermediate register states
  Batch final writeback

Only need consistency at row boundaries.
```

### Result Caching

Reuse result across constraints:

```
Result used in:
  Register writeback constraint
  Next instruction operand (if forwarded)
  Memory store (sometimes)

Single result column, multiple uses.
```

## Error Cases

### Write to x0

Handling writes to zero register:

```
Write to x0 is allowed but has no effect:
  rd_idx = 0, writes_rd = 1

  reg_next[0] = 0 (always)
  result is discarded

Constraint handles naturally:
  (rd_idx == 0) implies reg_next[0] = 0
  Result doesn't matter for x0
```

### Invalid Addresses

Memory write to invalid address:

```
Address out of bounds:
  Trigger store access fault exception

Misaligned address:
  Trigger store address misaligned exception

Constraint:
  is_store * !valid_addr * (exception - STORE_FAULT) = 0
```

## Key Concepts

- **Writeback**: Storing execution results to destinations
- **Destination register**: rd field specifying write target
- **Result source**: Which functional unit produces result
- **State transition**: Register file update from current to next
- **PC update**: Program counter change for control flow

## Design Considerations

### Register Representation

| All Registers | Active Register Only |
|--------------|---------------------|
| 32 columns | Single result column |
| Direct state | Lookup-based state |
| High memory | Lower memory |
| Simple constraints | Complex tracking |

### Multi-Write Handling

| Separate Constraints | Unified Constraint |
|---------------------|-------------------|
| One per destination | Combined logic |
| Clear separation | Single complex constraint |
| More constraints | Fewer constraints |
| Easier debugging | Harder to trace |

## Related Topics

- [Operand Handling](03-operand-handling.md) - Input sources
- [Opcode Dispatch](02-opcode-dispatch.md) - Execution routing
- [Main State Machine](../02-state-machine-design/02-main-state-machine.md) - State transitions
- [Memory System](../03-memory-system/01-memory-architecture.md) - Memory writes
