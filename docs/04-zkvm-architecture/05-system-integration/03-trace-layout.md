# Trace Layout

## Overview

Trace layout defines how columns are organized within the execution trace matrix. Each row represents a computational step, and columns hold the values at that step: register contents, memory addresses, operation selectors, intermediate results, and accumulator states. The layout significantly impacts proving efficiency, as column count affects polynomial commitment costs and constraint evaluation complexity.

A well-designed trace layout minimizes redundancy while ensuring all necessary values are accessible for constraint checking. Related values are grouped together, auxiliary columns are positioned strategically, and the layout accommodates both execution columns and consistency-checking columns. This organization must balance the competing demands of constraint expressiveness and proving efficiency.

This document covers trace organization principles, column categorization, layout strategies, and optimization techniques for efficient trace design.

## Trace Structure

### Matrix Organization

Trace as a two-dimensional matrix:

```
Trace dimensions:
  Rows: N (power of 2 for FFT efficiency)
  Columns: M (number of distinct values per row)

  trace[row][column] = field element

Row interpretation:
  Each row is one computational step
  Or multiple instructions per row (superscalar)

Column interpretation:
  Each column is a time series of values
  Polynomial interpolates column values
```

### Column Types

Categories of columns:

```
Primary columns:
  pc: Program counter
  instruction: Current instruction word
  registers: reg_0, reg_1, ..., reg_31

Selector columns:
  is_add, is_sub, is_load, ...
  Boolean (0 or 1)

Immediate columns:
  imm_i, imm_s, imm_b, imm_u, imm_j
  Instruction immediates

Auxiliary columns:
  For intermediate computations
  Required by constraint structure

Accumulator columns:
  perm_acc: Permutation accumulator
  lookup_acc: Lookup accumulator
  For cross-component linking
```

### Layout Example

Typical column arrangement:

```
Main execution columns (0-50):
  [0-3]:   pc, next_pc, instruction, cycle
  [4-7]:   opcode, funct3, funct7, rd_idx
  [8-12]:  rs1_idx, rs2_idx, rs1_val, rs2_val, rd_val
  [13-20]: immediates (I, S, B, U, J types, extended)
  [21-40]: selectors (operation type indicators)
  [41-50]: ALU inputs/outputs, memory addr/val

Register columns (51-82):
  [51-82]: reg_0 through reg_31

Auxiliary columns (83-100):
  [83-90]: decomposition columns
  [91-95]: comparison helpers
  [96-100]: overflow/carry flags

Accumulator columns (101-110):
  [101-105]: permutation accumulators
  [106-110]: lookup accumulators
```

## Column Categories

### Execution Columns

Core computational state:

```
Program state:
  pc: Current program counter
  next_pc: Next program counter
  cycle: Execution cycle number
  halted: Execution completed flag

Instruction fields:
  inst: Raw instruction bits
  op, f3, f7: Decoded fields
  rd, rs1, rs2: Register indices

Operand values:
  rs1_val, rs2_val: Source register values
  imm: Immediate value (selected format)
  alu_a, alu_b: ALU inputs
```

### Result Columns

Computation outputs:

```
ALU results:
  alu_result: Arithmetic/logic result
  alu_zero: Result is zero
  alu_negative: Result is negative

Memory results:
  mem_read_val: Value loaded from memory
  mem_addr: Computed address

Branch results:
  branch_taken: Branch condition result
  branch_target: Computed target address

Final result:
  rd_next_val: Value to write to rd
```

### Selector Columns

Operation indicators:

```
Major categories:
  is_alu_op: ALU operation
  is_mem_op: Memory operation
  is_branch: Branch/jump
  is_system: System operation

Specific operations:
  is_add, is_sub, is_and, is_or, ...
  is_lb, is_lh, is_lw, is_sb, ...
  is_beq, is_bne, is_blt, is_jal, ...

Properties:
  Binary (0 or 1)
  Exactly one operation selector per row
```

### Auxiliary Columns

Supporting computations:

```
Decomposition:
  byte_0, ..., byte_7: Byte decomposition
  bit_0, ..., bit_63: Bit decomposition

Comparison helpers:
  a_lt_b: a less than b
  a_eq_b: a equals b
  diff: a - b
  diff_inv: Inverse of diff (if nonzero)

Carry/borrow:
  carry: Overflow indicator
  borrow: Underflow indicator
```

## Layout Strategies

### Grouped Layout

Related columns together:

```
Register group:
  All 32 registers adjacent
  Easy iteration in constraints
  Cache-friendly access

Selector group:
  All selectors together
  Efficient sum constraint
  Clear separation

Accumulator group:
  All accumulators at end
  Don't interfere with execution logic
```

### Interleaved Layout

Mix for constraint efficiency:

```
Pairs that appear in same constraint:
  Place adjacent for cache locality

Example:
  alu_a, alu_b, alu_result together
  rs1_idx, rs1_val together
  mem_addr, mem_val together
```

### Sparse Layout

Handle mostly-zero columns:

```
Columns rarely used:
  Exception handling columns
  Extension instruction columns

Strategy:
  Group sparse columns
  Consider conditional activation
  May use separate trace for rare operations
```

## Multi-Machine Layout

### Main Machine Layout

Central execution trace:

```
Execution core:
  pc, instruction, cycle
  opcode, selectors
  operands, results

Inter-machine columns:
  mem_addr, mem_val, mem_op
  arith_op, arith_a, arith_b, arith_result
  binary_op, binary_a, binary_b, binary_result

Linking columns:
  mem_perm_acc: Memory permutation accumulator
  arith_lookup_acc: Arithmetic lookup accumulator
```

### Sub-Machine Layout

Specialized component traces:

```
Memory machine:
  addr, value, op_type, timestamp
  sorted_addr, sorted_value, sorted_time
  is_first_access, addr_changed
  perm_acc

Arithmetic machine:
  op_type, operand_a, operand_b
  result, flags
  intermediate computations
  lookup columns

Each machine has own trace, linked to main.
```

### Aligned Rows

Coordination between machines:

```
Option 1: Same row count
  All machines have N rows
  Padding as needed
  Simple indexing

Option 2: Different row counts
  Main: N rows
  Memory: M rows (M <= N)
  Arithmetic: K rows (K <= N)
  Requires index translation
```

## Optimization Techniques

### Column Sharing

Reuse columns when possible:

```
Mutually exclusive values:
  imm_i only used for I-type
  imm_s only used for S-type

Shared column:
  Single immediate column
  Format-dependent interpretation

Constraint:
  is_i_type * (imm - imm_i_value) = 0
  is_s_type * (imm - imm_s_value) = 0
```

### Bit Packing

Combine small values:

```
Multiple booleans:
  is_add, is_sub, is_and, ...
  Each is 0 or 1

Packed column:
  packed_selectors = is_add + 2*is_sub + 4*is_and + ...

Extraction:
  is_add = packed_selectors & 1
  is_sub = (packed_selectors >> 1) & 1
  ...

Trade-off:
  Fewer columns
  More complex constraints
```

### Lazy Columns

Compute only when needed:

```
Expensive intermediate:
  Only compute for specific operations

Conditional column:
  inv_diff = 1/(a - b) when a != b

Strategy:
  Only constrain when selector active
  is_comparison * (inv_diff * (a - b) - 1) = 0
```

### Column Elimination

Remove redundant columns:

```
Derived values:
  If c = a + b always, don't need column for c
  Compute inline in constraints

Analysis:
  Identify columns that are always computed
  Replace column with expression
  Reduces column count
```

## Row Optimization

### Row Packing

Multiple operations per row:

```
Single instruction per row:
  Simple, clear
  Many rows for programs

Multiple instructions per row:
  More complex layout
  Fewer total rows
  Reduced proving cost

Example:
  inst_0, inst_1 in same row
  Separate columns for each
  Double instruction throughput
```

### Padding Strategy

Filling unused rows:

```
Trace must be power of 2:
  Actual execution: 12345 rows
  Padded to: 16384 rows

Padding rows:
  Copy final state (registers, PC)
  Mark as halted
  No active operations

Constraint:
  is_halted * (state_unchanged) = 0
  is_halted * (no_operation) = 0
```

### Row Compression

Reduce total rows:

```
Repeated patterns:
  Loops execute same instruction sequence
  Can potentially compress

Approach:
  Identify repetitive sections
  Use iteration counter
  Fewer rows for loops
```

## Key Concepts

- **Trace layout**: Column organization in execution trace
- **Column category**: Type of data stored (execution, selector, auxiliary)
- **Grouped layout**: Related columns positioned together
- **Column sharing**: Reusing columns for mutually exclusive data
- **Row packing**: Multiple operations per trace row

## Design Considerations

### Column Count Trade-offs

| Few Columns | Many Columns |
|-------------|--------------|
| Lower commitment cost | Higher commitment cost |
| Complex constraints | Simple constraints |
| Harder debugging | Easier debugging |
| More sharing needed | Less sharing |

### Row Count Trade-offs

| Few Rows | Many Rows |
|----------|-----------|
| Higher parallel cost | Lower parallel cost |
| More complex rows | Simpler rows |
| Less padding waste | More padding waste |
| Faster FFT | Slower FFT |

## Related Topics

- [Component Composition](01-component-composition.md) - Multi-machine structure
- [Cross-Machine Consistency](02-cross-machine-consistency.md) - Inter-machine linking
- [Proof Aggregation](04-proof-aggregation.md) - Combining proofs
- [Main State Machine](../02-state-machine-design/02-main-state-machine.md) - Main machine layout
