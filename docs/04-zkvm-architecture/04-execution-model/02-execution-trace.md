# Execution Trace

## Overview

The execution trace is a complete record of the zkVM's state transitions during program execution. Each row of the trace captures the machine state at one step: the current program counter, register values, memory operations, and computed results. The trace serves as the witness for the zero-knowledge proof, demonstrating that the claimed output was correctly computed from the input.

Generating a valid execution trace is the first step in proving program execution. The trace must satisfy all constraints defined by the state machine, connecting each instruction's inputs to its outputs according to RISC-V semantics. The prover commits to this trace and then proves it satisfies the required polynomial identities.

This document explains trace structure, generation, and the constraints that valid traces must satisfy.

## Trace Structure

### Tabular Representation

The trace as a table:

```
Trace dimensions:
  Rows: One per execution step (instruction)
  Columns: State components (registers, PC, etc.)

Example structure:
  | step | PC     | inst   | rs1 | rs2 | rd | op1    | op2    | result |
  |------|--------|--------|-----|-----|----|--------|--------|--------|
  | 0    | 0x1000 | ADDI   | 0   | -   | 5  | 0      | 10     | 10     |
  | 1    | 0x1004 | ADD    | 5   | 6   | 7  | 10     | 20     | 30     |
  | 2    | 0x1008 | SW     | 7   | -   | -  | 30     | 0x2000 | -      |
  ...
```

### Column Categories

Types of columns in the trace:

```
State columns:
  PC: Program counter
  Registers (or register references)
  Flags and status bits

Instruction columns:
  Opcode: Operation being performed
  Operand specifiers: rs1, rs2, rd
  Immediate value

Intermediate columns:
  ALU inputs and outputs
  Memory addresses and values
  Branch conditions

Selector columns:
  is_add, is_branch, is_load, ...
  One-hot encoding of operation type
```

### Row Semantics

What each row represents:

```
Per-row content:
  State before instruction
  Instruction being executed
  Computed values
  State changes

Transition:
  Row i → Row i+1 represents one instruction
  PC advances (or jumps)
  Registers may update
```

## Trace Generation

### Execution Recording

How the trace is built:

```
Process:
  1. Initialize machine state
  2. Fetch instruction at PC
  3. Decode and execute
  4. Record state and operation
  5. Update state for next instruction
  6. Repeat until termination

Recording:
  Each step produces one trace row
  All columns filled for that step
```

### State Capture

What state is recorded:

```
Captured per step:
  Current PC value
  Fetched instruction
  Source register values
  Computed intermediate values
  Result value
  Destination register

Derived values:
  May compute additional columns
  Selector bits from opcode
  Memory operation details
```

### Termination

Ending the trace:

```
Normal termination:
  Program executes ECALL or designated exit
  Trace ends with final state

Error termination:
  Invalid instruction
  Memory access violation
  May produce trap trace or invalid proof

Trace length:
  Determined by program execution
  Padded to power of 2 for FRI
```

## Trace Columns Detail

### Program Counter Column

Tracking instruction location:

```
PC column properties:
  Initial value: entry point
  Usually advances by 4
  Modified by branches/jumps

Constraint:
  pc' = pc + 4 (sequential)
  pc' = branch_target (taken branch)
  pc' = jump_target (jump)
```

### Instruction Columns

Encoding current operation:

```
Instruction word:
  32-bit fetched instruction
  Or: decoded opcode, operands

Derived columns:
  opcode: Operation category
  funct3, funct7: Specific operation
  rs1, rs2, rd: Register specifiers
  imm: Immediate value
```

### Operand Columns

Values used in computation:

```
Register operands:
  op1 = reg[rs1] (or 0 if rs1 = 0)
  op2 = reg[rs2] or immediate

Memory operands:
  address = op1 + offset
  load_value = memory[address]
  store_value = op2
```

### Result Columns

Computed outputs:

```
ALU result:
  Arithmetic/logic operation output

Memory result:
  Loaded value for loads
  (None for stores)

Branch result:
  Condition evaluation
  Target address if taken
```

## Constraint Satisfaction

### State Transition Constraints

Linking consecutive rows:

```
Register update:
  reg'[rd] = result (if rd != 0)
  reg'[i] = reg[i] (for i != rd)

PC update:
  pc' = next_pc (determined by instruction type)

Memory state:
  Memory consistency per memory model
```

### Instruction Execution Constraints

Correct operation:

```
Per instruction type:
  ADD: result = op1 + op2
  SUB: result = op1 - op2
  AND: result = op1 & op2
  ...

Branch constraints:
  BEQ: taken = (op1 == op2)
  BNE: taken = (op1 != op2)
  ...

Memory constraints:
  Load: result = memory[address]
  Store: memory'[address] = op2
```

### Selector Constraints

Operation dispatch:

```
One-hot selectors:
  is_add + is_sub + is_and + ... = 1
  Exactly one operation type active

Conditional constraints:
  is_add * (result - (op1 + op2)) = 0
  is_sub * (result - (op1 - op2)) = 0
  ...
```

## Trace Padding

### Power-of-Two Length

Requirement for FRI:

```
FRI requirement:
  Trace length must be power of 2
  Enables efficient FFT operations

Padding:
  Actual steps: N
  Padded length: 2^k where 2^k >= N

Padding content:
  Repeat final state
  Or: NOP instructions
  Or: designated padding rows
```

### Padding Constraints

Ensuring padding is valid:

```
Padding row constraints:
  Must satisfy all constraints
  No state change (or defined change)
  No memory operations (or special handling)

Implementation:
  is_padding selector column
  Disable real constraints for padding rows
  Or: padding rows are valid NOPs
```

## Memory Operations in Trace

### Load Operations

Recording memory reads:

```
Load columns:
  is_load: Selector
  load_addr: Address being read
  load_value: Value obtained
  load_width: Bytes read (1, 2, 4)

Constraint:
  load_value from memory at load_addr
  Properly sign-extended for signed loads
```

### Store Operations

Recording memory writes:

```
Store columns:
  is_store: Selector
  store_addr: Address being written
  store_value: Value being stored
  store_width: Bytes written

Constraint:
  Memory updated at store_addr
  Width determines bytes affected
```

### Memory Trace

Separate memory component:

```
Memory trace:
  Records all memory operations
  Links to main execution trace
  Used for memory consistency proof

Linkage:
  Permutation between main and memory traces
  Same operations in different order
```

## Register File in Trace

### Explicit Register Columns

Registers as trace columns:

```
Wide approach:
  Columns r0, r1, ..., r31
  All register values in each row
  Wide trace but simple access

Constraint:
  r0 = 0 (always)
  r_rd' = result (on write)
  r_i' = r_i (otherwise)
```

### Implicit Register Tracking

Registers via memory model:

```
Narrow approach:
  Registers as memory operations
  Read rs1, rs2 as loads
  Write rd as store

Memory trace:
  Register accesses in memory trace
  Same consistency model
```

## Trace Verification

### Local Constraints

Per-row checks:

```
Constraint types:
  Boundary: First/last row conditions
  Transition: Row i to row i+1
  Local: Within single row

Examples:
  pc >= 0 (local)
  pc' = pc + 4 (transition, if not branch)
  pc[0] = entry_point (boundary)
```

### Global Constraints

Across entire trace:

```
Examples:
  Total instruction count
  Initial and final state
  Public inputs/outputs

Verification:
  Often via aggregation
  Or: special boundary columns
```

## Trace Optimization

### Column Reduction

Minimizing trace width:

```
Techniques:
  Share columns for mutually exclusive values
  Use selectors to multiplex
  Compute derived values

Trade-off:
  Fewer columns: less memory
  More columns: simpler constraints
```

### Row Reduction

Minimizing trace length:

```
Techniques:
  Multi-instruction rows (if parallelizable)
  Skip NOPs
  Compress repetitive sequences

Trade-off:
  Fewer rows: smaller proof
  More rows: simpler logic
```

## Key Concepts

- **Execution trace**: Record of all state transitions
- **Trace columns**: State components tracked per step
- **Trace rows**: Individual execution steps
- **Constraint satisfaction**: All rows must satisfy polynomial constraints
- **Trace padding**: Extending to power-of-two length

## Design Trade-offs

### Trace Width

| Wide Trace | Narrow Trace |
|------------|--------------|
| All state explicit | State via lookups |
| Simple constraints | Complex constraints |
| More memory | Less memory |

### Column Strategy

| Dedicated Columns | Shared Columns |
|-------------------|----------------|
| Clear separation | Multiplexed use |
| Simple access | Selector overhead |
| Higher width | Lower width |

## Related Topics

- [Instruction Encoding](01-instruction-encoding.md) - Binary instruction format
- [Segmented Execution](03-segmented-execution.md) - Breaking execution into parts
- [Main State Machine](../02-state-machine-design/02-main-state-machine.md) - Execution engine
- [Witness Generation](../../02-stark-proving-system/04-proof-generation/01-witness-generation.md) - Trace to proof

