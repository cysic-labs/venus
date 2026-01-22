# Opcode Dispatch

## Overview

Opcode dispatch routes decoded instructions to the appropriate execution logic. After decoding extracts the opcode, registers, and immediates, dispatch determines which operation to perform and activates the corresponding constraints. This is analogous to a hardware multiplexer that selects between different functional units, but implemented through polynomial constraints that enable exactly one execution path per instruction.

The dispatch mechanism must handle the full RISC-V instruction set while maintaining constraint efficiency. Rather than having separate constraint systems for each instruction, dispatch uses selector polynomials that activate specific constraint subsets. This allows a unified trace structure where different instructions share columns but apply different constraints based on the active selector.

This document covers dispatch mechanisms, selector design, constraint activation patterns, and optimization strategies for efficient opcode routing.

## Dispatch Architecture

### Dispatch Flow

From decode to execution:

```
Instruction lifecycle:
  1. Fetch: Read instruction from PC
  2. Decode: Extract opcode, fields
  3. Dispatch: Determine operation type
  4. Execute: Perform operation
  5. Writeback: Store result

Dispatch role:
  Input: Decoded opcode, funct3, funct7
  Output: Operation selector, execution path

  Maps instruction encoding to execution logic
```

### Selector Hierarchy

Multi-level dispatch:

```
Level 1 - Major category:
  is_alu: Arithmetic/logic operations
  is_mem: Memory operations
  is_branch: Branch/jump operations
  is_system: System operations

Level 2 - Operation type:
  Within is_alu:
    is_add, is_sub, is_and, is_or, is_xor, ...
  Within is_mem:
    is_load, is_store
  Within is_branch:
    is_beq, is_bne, is_blt, is_bge, is_jal, is_jalr

Level 3 - Specific variant:
  Within is_load:
    is_lb, is_lh, is_lw, is_lbu, is_lhu, ...
  Within is_add:
    is_add_reg, is_add_imm
```

### Selector Computation

Deriving selectors from opcode:

```
From decoded fields (opcode, funct3, funct7):

// Major category
is_alu = (opcode == 0x33) OR (opcode == 0x13) OR ...
is_mem = (opcode == 0x03) OR (opcode == 0x23)
is_branch = (opcode == 0x63) OR (opcode == 0x6F) OR (opcode == 0x67)

// Specific operation
is_add = is_alu * (funct3 == 0) * (funct7 == 0 OR opcode == 0x13)
is_sub = is_alu * (funct3 == 0) * (funct7 == 0x20) * (opcode == 0x33)

// Memory operations
is_lb = is_mem * (opcode == 0x03) * (funct3 == 0)
is_sw = is_mem * (opcode == 0x23) * (funct3 == 2)
```

## Selector Design

### Binary Selectors

One-hot encoding:

```
Selector properties:
  Each selector is 0 or 1
  Exactly one selector active per instruction

Constraints:
  // Binary
  sel_i * (1 - sel_i) = 0 for all i

  // Mutual exclusion
  sum(all_selectors) = 1

Example selectors:
  is_add, is_sub, is_and, is_or, is_xor,
  is_sll, is_srl, is_sra, is_slt, is_sltu,
  is_lb, is_lh, is_lw, is_sb, is_sh, is_sw,
  is_beq, is_bne, is_blt, is_bge, is_bltu, is_bgeu,
  is_jal, is_jalr, ...
```

### Grouped Selectors

Hierarchical structure:

```
Top-level groups:
  is_alu_op = sum(arithmetic/logic selectors)
  is_mem_op = sum(memory selectors)
  is_branch_op = sum(branch selectors)

Group constraints:
  is_alu_op + is_mem_op + is_branch_op + is_system_op = 1

Within group:
  is_alu_op = is_add + is_sub + is_and + is_or + ...

Benefits:
  Group-level constraints apply uniformly
  Reduces constraint duplication
```

### Computed Selectors

Deriving selectors from lookup:

```
Decode table provides selectors directly:
  (opcode, funct3, funct7) -> (sel_add, sel_sub, ...)

Lookup-based:
  All selectors from single table lookup
  No explicit computation needed

Constraint:
  (opcode, funct3, funct7, sel_0, sel_1, ..., sel_n) in decode_table
```

## Constraint Activation

### Selector-Guarded Constraints

Enabling constraints conditionally:

```
General pattern:
  selector * (constraint_expression) = 0

Example - ADD operation:
  is_add * (rd_value - (rs1_value + rs2_value)) = 0

When is_add = 1:
  rd_value = rs1_value + rs2_value

When is_add = 0:
  Constraint satisfied regardless of values
```

### Multi-Selector Constraints

Shared constraints across operations:

```
All ALU operations write to rd:
  is_alu_op * (rd_write_enable - 1) = 0

All branches don't write rd:
  is_branch_op * rd_write_enable = 0

All loads perform memory read:
  is_load * (mem_read_enable - 1) = 0

Reduces constraint count vs. per-operation.
```

### Exclusive Constraint Sets

Non-overlapping constraint groups:

```
Memory address computation:
  // Loads: address = rs1 + imm_i
  is_load * (mem_addr - (rs1_value + imm_i)) = 0

  // Stores: address = rs1 + imm_s
  is_store * (mem_addr - (rs1_value + imm_s)) = 0

Result source:
  // ALU: result from ALU output
  is_alu_op * (rd_next - alu_result) = 0

  // Load: result from memory
  is_load * (rd_next - mem_value) = 0

  // JAL: result is PC + 4
  is_jal * (rd_next - (pc + 4)) = 0
```

## Dispatch Table

### Table Structure

Precomputed dispatch information:

```
Table columns:
  opcode: 7-bit opcode field
  funct3: 3-bit function field
  funct7: 7-bit function field (or relevant bits)
  operation_id: Unique operation identifier
  category: ALU, MEM, BRANCH, SYSTEM
  uses_rd: Does operation write rd?
  uses_rs1: Does operation read rs1?
  uses_rs2: Does operation read rs2?
  uses_imm: Does operation use immediate?
  imm_type: Which immediate format?
  is_signed: Signed operation?
  mem_size: Memory access size (for loads/stores)
  branch_type: Branch condition type

Table size:
  ~100-200 entries for base ISA
  Plus extensions (M, A, F, D, ...)
```

### Table Usage

Lookup for dispatch:

```
Constraint:
  (opcode, funct3, funct7, op_id, category, uses_rd,
   uses_rs1, uses_rs2, uses_imm, imm_type, is_signed,
   mem_size, branch_type) in dispatch_table

Selector derivation:
  is_add = (op_id == ADD_OP_ID)
  is_sub = (op_id == SUB_OP_ID)
  ...

Or encode selectors directly in table.
```

### Extension Tables

Handling ISA extensions:

```
Base table: RV32I/RV64I instructions
M extension: Multiply/divide
A extension: Atomics
F/D extension: Floating point

Combined table:
  Union of all extension tables
  Extension selector enables relevant subset

is_m_ext_enabled * (m_ext_op_valid) = is_m_ext_enabled
```

## Functional Unit Routing

### ALU Dispatch

Routing to arithmetic unit:

```
ALU operations:
  ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU

ALU inputs:
  alu_a = rs1_value
  alu_b = is_reg_op * rs2_value + is_imm_op * immediate

ALU operation selector:
  alu_op = op_id (subset for ALU)

ALU output:
  alu_result = computed based on alu_op
```

### Memory Unit Dispatch

Routing to memory:

```
Memory operations:
  Loads: LB, LH, LW, LBU, LHU (RV32) + LD, LWU (RV64)
  Stores: SB, SH, SW (RV32) + SD (RV64)

Memory unit inputs:
  mem_addr = rs1_value + imm
  mem_data = rs2_value (for stores)
  mem_size = size from dispatch table
  mem_signed = signed from dispatch table
  mem_is_write = is_store

Memory unit output:
  mem_read_value = loaded data (for loads)
```

### Branch Unit Dispatch

Routing to branch logic:

```
Branch operations:
  Conditional: BEQ, BNE, BLT, BGE, BLTU, BGEU
  Unconditional: JAL, JALR

Branch unit inputs:
  branch_a = rs1_value
  branch_b = rs2_value
  branch_type = condition type
  branch_target = computed target

Branch unit output:
  branch_taken = condition result (0 or 1)
  next_pc = taken ? target : pc + 4
```

## Optimization Strategies

### Selector Compression

Reducing selector columns:

```
Instead of one column per instruction:
  Use operation ID column (log2(num_ops) bits)

  op_id in [0, 63] for 64 operations
  6-bit column instead of 64 columns

Decompose op_id for constraints:
  op_id_bits = bit decomposition
  is_add = (op_id == 0)  // via equality check
```

### Constraint Factoring

Sharing common constraint parts:

```
Many instructions share patterns:
  rd = rs1 OP rs2  (most R-type)
  rd = rs1 OP imm  (most I-type)

Factor common structure:
  is_rs1_rs2_rd * (rd_value - f(rs1, rs2)) = 0
  is_rs1_imm_rd * (rd_value - g(rs1, imm)) = 0

Where f, g vary by specific operation.
```

### Dispatch Caching

For repeated instruction patterns:

```
Same instruction executed multiple times:
  Loop body with consistent opcodes

Caching opportunity:
  Dispatch result same for same instruction
  Precompute selector values

For hot loops:
  Selector columns may be constant across iterations
```

## Error Cases

### Invalid Opcode

Handling unknown instructions:

```
Invalid opcode detection:
  (opcode, funct3, funct7) not in dispatch_table

Response:
  Trigger illegal instruction trap
  is_invalid_opcode = 1

Constraint:
  is_invalid_opcode * (exception_code - ILLEGAL_INSTRUCTION) = 0
  is_invalid_opcode * (next_pc - trap_handler_addr) = 0
```

### Privileged Instructions

Handling privilege violations:

```
System instructions may require privilege:
  MRET, SRET, WFI, SFENCE.VMA, ...

Check:
  required_privilege <= current_privilege

Violation:
  is_privilege_violation = (required > current)
  Trigger exception
```

## Key Concepts

- **Dispatch**: Routing decoded instruction to execution logic
- **Selector**: Binary column enabling specific constraints
- **One-hot**: Exactly one selector active per instruction
- **Dispatch table**: Lookup for instruction properties
- **Constraint activation**: Selector-guarded constraint application

## Design Considerations

### Selector Organization

| Flat Selectors | Hierarchical Selectors |
|----------------|----------------------|
| One per instruction | Grouped by category |
| Many columns | Fewer columns |
| Direct activation | Multi-level dispatch |
| Simple | Complex but efficient |

### Dispatch Method

| Computed | Table Lookup |
|----------|--------------|
| Constraints derive selectors | Table provides selectors |
| No table overhead | Table commitment cost |
| Flexible changes | Fixed at setup |
| More constraints | Fewer constraints |

## Related Topics

- [Instruction Decoding](01-instruction-decoding.md) - Pre-dispatch decoding
- [Operand Handling](03-operand-handling.md) - Post-dispatch operands
- [Result Writeback](04-result-writeback.md) - Post-execution results
- [Main State Machine](../02-state-machine-design/02-main-state-machine.md) - Dispatch integration
