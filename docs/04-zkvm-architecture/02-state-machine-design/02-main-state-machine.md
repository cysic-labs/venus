# Main State Machine

## Overview

The main state machine is the central component of the zkVM, responsible for orchestrating program execution and coordinating all other state machines. It implements the fetch-decode-execute cycle, manages control flow, and dispatches operations to specialized secondary machines. Every instruction executed by the zkVM flows through the main state machine.

The main state machine defines the primary structure of the execution trace. Its columns capture the essential state of the virtual machine at each cycle: program counter, instruction information, and the data flow for the current operation. While secondary machines handle specialized computations, the main machine ensures these computations integrate correctly into the overall execution.

This document covers the main state machine's architecture, column layout, constraint structure, and interaction with other machines.

## Architecture

### Central Role

The main machine's responsibilities:

```
Core functions:
  1. Instruction fetching from program memory
  2. Instruction decoding and dispatch
  3. Control flow management (branches, jumps)
  4. Register file access coordination
  5. Operation delegation to secondary machines
  6. Result collection and writeback

What it doesn't do:
  - Complex arithmetic (delegates to arithmetic machine)
  - Memory consistency (memory machine handles)
  - Bitwise operations (binary machine handles)
  - Cryptographic operations (precompile machines)
```

### Machine Boundaries

Interface with other machines:

```
+----------------------------------------------------------+
|                    MAIN STATE MACHINE                     |
|                                                          |
|  [Fetch] -> [Decode] -> [Dispatch] -> [Collect] -> [WB]  |
|     |          |            |             ^              |
|     v          v            v             |              |
|  +------+  +------+    +-------+     +-------+          |
|  | ROM  |  |Decode|    | Arith |---->|       |          |
|  |Table |  |Logic |    | Mach  |     |Result |          |
|  +------+  +------+    +-------+     | Coll. |          |
|                        +-------+     |       |          |
|                        |Memory |---->|       |          |
|                        | Mach  |     +-------+          |
|                        +-------+                         |
|                        +-------+                         |
|                        |Binary |---->                    |
|                        | Mach  |                         |
|                        +-------+                         |
+----------------------------------------------------------+
```

## Column Layout

### Program Counter Columns

Tracking execution position:

```
pc: Current instruction address
next_pc: Address of next instruction
pc_plus_4: PC + 4 (common next for sequential)

Constraints:
  pc_plus_4 = pc + 4
  // next_pc determined by instruction type
```

### Instruction Columns

Current instruction data:

```
instruction: 32-bit instruction word
opcode: Decoded operation type
funct3: Function modifier (3 bits)
funct7: Function modifier (7 bits)

rs1_idx: First source register index
rs2_idx: Second source register index
rd_idx: Destination register index

immediate: Sign-extended immediate value

Constraints:
  Decode constraints extract fields from instruction
  Immediate correctly sign-extended per format
```

### Selector Columns

One-hot operation indicators:

```
Instruction category selectors:
  is_r_type: Register-register operation
  is_i_type: Immediate operation
  is_s_type: Store operation
  is_b_type: Branch operation
  is_u_type: Upper immediate
  is_j_type: Jump operation

Specific instruction selectors:
  is_add, is_sub, is_and, is_or, is_xor
  is_sll, is_srl, is_sra
  is_beq, is_bne, is_blt, is_bge
  is_lw, is_sw, is_lb, is_sb
  ...

Constraints:
  Exactly one category selector is 1
  Exactly one instruction selector is 1 (per category)
  Selectors consistent with opcode/funct fields
```

### Data Flow Columns

Operand and result values:

```
rs1_value: First source register value
rs2_value: Second source register value
rd_value: Value to write to destination

alu_a: First ALU operand (may be rs1_value or PC)
alu_b: Second ALU operand (may be rs2_value or immediate)
alu_result: ALU output

mem_addr: Memory address (for loads/stores)
mem_value: Memory value (read or written)

Constraints:
  alu_a selection based on instruction type
  alu_b selection based on instruction type
  rd_value from ALU or memory
```

### Control Flow Columns

Branch and jump handling:

```
is_branch: Current instruction is branch
branch_condition: Evaluated condition (0 or 1)
branch_taken: Whether branch is taken

is_jump: Current instruction is jump (jal, jalr)
jump_target: Computed jump address

Constraints:
  branch_taken = is_branch * branch_condition
  next_pc = branch_taken * branch_target +
            (1 - branch_taken) * pc_plus_4  // simplified
```

### Interface Columns

Connection to other machines:

```
Bus columns:
  bus_op: Operation type being sent
  bus_a, bus_b: Operands
  bus_result: Result received

Lookup columns:
  lookup_value: Value to look up
  lookup_table: Which table to query

Permutation columns:
  perm_tag: Tag for permutation grouping
  perm_data: Data for permutation
```

## Constraint Structure

### Decode Constraints

Correct instruction decoding:

```
// Extract opcode
opcode = instruction[6:0]

// Field extraction (R-type)
is_r_type * (rd_idx - instruction[11:7]) = 0
is_r_type * (funct3 - instruction[14:12]) = 0
is_r_type * (rs1_idx - instruction[19:15]) = 0
is_r_type * (rs2_idx - instruction[24:20]) = 0
is_r_type * (funct7 - instruction[31:25]) = 0

// Immediate extraction (I-type)
is_i_type * (immediate - sign_extend(instruction[31:20])) = 0

// Similar for other formats...
```

### Execution Constraints

Operation correctness:

```
// ADD instruction
is_add * (alu_a - rs1_value) = 0
is_add * (alu_b - rs2_value) = 0
is_add * (alu_result - (alu_a + alu_b)) = 0
is_add * (rd_value - alu_result) = 0

// ADDI instruction
is_addi * (alu_a - rs1_value) = 0
is_addi * (alu_b - immediate) = 0
is_addi * (alu_result - (alu_a + alu_b)) = 0
is_addi * (rd_value - alu_result) = 0

// For complex operations, delegate to secondary machine
is_mul * (bus_op - MUL_OP) = 0
is_mul * (bus_a - rs1_value) = 0
is_mul * (bus_b - rs2_value) = 0
is_mul * (rd_value - bus_result) = 0
```

### Control Flow Constraints

Branch and jump correctness:

```
// BEQ: branch if equal
is_beq * (branch_condition - (rs1_value == rs2_value)) = 0

// Branch target
is_branch * (branch_target - (pc + immediate)) = 0

// JAL: jump and link
is_jal * (rd_value - pc_plus_4) = 0
is_jal * (next_pc - (pc + immediate)) = 0

// JALR: jump and link register
is_jalr * (rd_value - pc_plus_4) = 0
is_jalr * (next_pc - ((rs1_value + immediate) & ~1)) = 0

// Sequential execution
is_sequential * (next_pc - pc_plus_4) = 0
```

### Memory Constraints

Load/store coordination:

```
// Load word
is_lw * (mem_addr - (rs1_value + immediate)) = 0
is_lw * (rd_value - mem_value) = 0
// mem_value comes from memory machine

// Store word
is_sw * (mem_addr - (rs1_value + immediate)) = 0
is_sw * (mem_value - rs2_value) = 0
// Triggers write in memory machine
```

### Transition Constraints

State persistence:

```
// PC always updates to next_pc
pc' = next_pc

// Registers persist unless written
For each register i (except x0):
  (rd_idx != i) * (reg[i]' - reg[i]) = 0
  (rd_idx == i) * (reg[i]' - rd_value) = 0

// x0 always zero
reg[0] = 0
reg[0]' = 0
```

## Secondary Machine Integration

### Delegation Pattern

Offloading to secondary machines:

```
When main machine encounters complex operation:
  1. Set up bus columns with operation and operands
  2. Secondary machine reads from bus
  3. Secondary machine computes result
  4. Secondary machine writes result to bus
  5. Main machine reads result from bus
  6. Main machine continues execution

Bus constraint ensures:
  Every send has matching receive
```

### Arithmetic Delegation

For multiply, divide:

```
Main machine:
  is_mul * (arith_bus_op - MUL) = 0
  is_mul * (arith_bus_a - rs1_value) = 0
  is_mul * (arith_bus_b - rs2_value) = 0

Arithmetic machine:
  Receives (MUL, a, b)
  Computes a * b
  Returns result

Connection:
  Permutation argument on bus columns
  Main sends = Arithmetic receives
```

### Memory Delegation

For loads and stores:

```
Main machine:
  is_load * (mem_bus_op - READ) = 0
  is_load * (mem_bus_addr - mem_addr) = 0

Memory machine:
  Receives (READ, addr)
  Looks up value at addr
  Returns value

is_store * (mem_bus_op - WRITE) = 0
is_store * (mem_bus_addr - mem_addr) = 0
is_store * (mem_bus_value - rs2_value) = 0

Memory machine:
  Receives (WRITE, addr, value)
  Updates memory state
```

## Optimization Techniques

### Instruction Batching

Group similar instructions:

```
Instead of per-instruction selector:
  Group: arithmetic, memory, branch, etc.
  First select group, then select within group

Reduces total constraint count.
```

### Column Sharing

Reuse columns across instruction types:

```
alu_a, alu_b, alu_result used by:
  - ADD, SUB, AND, OR, XOR
  - ADDI, ANDI, ORI, XORI
  - Address calculation for loads/stores

Same columns, different interpretation per instruction.
```

### Sparse Selectors

Only one instruction active:

```
Rather than checking all:
  Enumerate valid instruction
  Use lookup to verify (opcode, funct3, funct7) valid
  Single constraint per instruction type
```

## Key Concepts

- **Main state machine**: Central execution coordinator
- **Fetch-decode-execute**: Core execution loop
- **Delegation**: Offloading to secondary machines
- **Bus**: Communication channel with secondary machines
- **Transition constraints**: Linking consecutive cycles

## Design Considerations

### Complexity Distribution

| Main-Heavy | Distributed |
|------------|-------------|
| More in main machine | More in secondaries |
| Simpler interfaces | More interfaces |
| Larger main constraints | Smaller main constraints |
| Harder to parallelize | Easier to parallelize |

### Register Handling

| Explicit Registers | Implicit Registers |
|-------------------|-------------------|
| 32 columns for registers | Lookup-based access |
| Simple constraints | Complex constraints |
| More columns | Fewer columns |
| Direct access | Indirection |

## Related Topics

- [State Machine Abstraction](01-state-machine-abstraction.md) - Machine design principles
- [Arithmetic Operations](03-arithmetic-operations.md) - Arithmetic machine
- [Binary Operations](04-binary-operations.md) - Binary machine
- [Instruction Cycle](../01-execution-model/03-instruction-cycle.md) - Execution details
