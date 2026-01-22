# Instruction Cycle

## Overview

The instruction cycle describes the sequence of operations that occur during a single execution step of the zkVM. Each cycle transforms the machine state according to the current instruction, producing exactly one row in the execution trace. Understanding the instruction cycle is essential for constraint design, performance optimization, and debugging execution issues.

The cycle decomposes into well-defined phases: fetch, decode, read, execute, memory access, and writeback. Each phase has specific responsibilities and produces specific trace data. The constraint system mirrors this structure, with constraints verifying each phase's correctness.

This document details each phase of the instruction cycle, the data flow between phases, and how the cycle maps to constraints.

## Cycle Phases

### Phase Overview

The complete instruction cycle:

```
┌─────────────────────────────────────────────────────────────┐
│                    INSTRUCTION CYCLE                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   FETCH ──► DECODE ──► READ ──► EXECUTE ──► MEMORY ──► WB  │
│     │         │         │         │           │         │  │
│     │         │         │         │           │         │  │
│     v         v         v         v           v         v  │
│   [instr]  [opcode]  [rs_val]  [result]  [mem_op]  [rd_val]│
│            [fields]                                   [PC'] │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Fetch Phase

Retrieving the instruction:

```
Input:
  - PC: Current program counter

Process:
  instruction = memory[PC]

Output:
  - instruction: 32-bit instruction word

Trace columns:
  trace.pc = PC
  trace.instruction = instruction

Constraints:
  Instruction fetched from valid address
  Instruction matches ROM/program memory
```

### Decode Phase

Parsing instruction fields:

```
Input:
  - instruction: 32-bit word

Process:
  opcode = instruction[6:0]
  rd = instruction[11:7]
  funct3 = instruction[14:12]
  rs1 = instruction[19:15]
  rs2 = instruction[24:20]
  funct7 = instruction[31:25]
  immediate = extract_immediate(instruction, format)

Output:
  - All decoded fields
  - Instruction type selectors

Trace columns:
  trace.opcode = opcode
  trace.rd_idx = rd
  trace.rs1_idx = rs1
  trace.rs2_idx = rs2
  trace.immediate = immediate
  trace.is_add, trace.is_sub, ... = selectors
```

### Register Read Phase

Fetching source operands:

```
Input:
  - rs1_idx: First source register index
  - rs2_idx: Second source register index
  - Register file state

Process:
  rs1_value = registers[rs1_idx]
  rs2_value = registers[rs2_idx]

Output:
  - rs1_value: First source value
  - rs2_value: Second source value

Trace columns:
  trace.rs1_value = rs1_value
  trace.rs2_value = rs2_value

Constraints:
  Values match register file at given indices
  (Lookup or permutation to register state)
```

### Execute Phase

Performing the operation:

```
Input:
  - opcode: Operation type
  - rs1_value, rs2_value: Source values
  - immediate: Immediate value
  - PC: For PC-relative operations

Process:
  result = execute(opcode, rs1_value, rs2_value, immediate, PC)

  Examples:
    ADD:  result = rs1_value + rs2_value
    ADDI: result = rs1_value + immediate
    SUB:  result = rs1_value - rs2_value
    AND:  result = rs1_value & rs2_value
    SLT:  result = (signed(rs1_value) < signed(rs2_value)) ? 1 : 0
    LUI:  result = immediate << 12
    AUIPC: result = PC + (immediate << 12)

Output:
  - result: Computed value
  - branch_target: For branch/jump instructions
  - branch_taken: For conditional branches

Trace columns:
  trace.result = result
  trace.branch_target = branch_target
  trace.branch_taken = branch_taken
```

### Memory Phase

Handling load/store operations:

```
Input:
  - is_load, is_store: Operation type
  - address: Computed address (rs1_value + immediate)
  - store_value: Value to store (rs2_value)

Process:
  if is_load:
    mem_value = memory_read(address)
  elif is_store:
    memory_write(address, store_value)

Output:
  - mem_value: Loaded value (for loads)
  - Memory updated (for stores)

Trace columns:
  trace.mem_addr = address
  trace.mem_value = mem_value
  trace.is_load = is_load
  trace.is_store = is_store

Constraints:
  Memory operations consistent with memory state machine
  Address alignment (if required)
```

### Writeback Phase

Updating machine state:

```
Input:
  - rd_idx: Destination register
  - result: From execute phase
  - mem_value: From memory phase (for loads)
  - branch_taken, branch_target: Control flow

Process:
  // Determine value to write
  if is_load:
    rd_value = mem_value
  else:
    rd_value = result

  // Update register (if rd != 0)
  if rd_idx != 0:
    registers[rd_idx] = rd_value

  // Update PC
  if is_branch and branch_taken:
    next_pc = branch_target
  elif is_jump:
    next_pc = jump_target
  else:
    next_pc = PC + 4

Output:
  - Updated registers
  - Next PC

Trace columns:
  trace.rd_value = rd_value
  trace.next_pc = next_pc
```

## Data Flow

### Forward Flow

Data dependencies through phases:

```
Fetch:    instruction
              │
              ▼
Decode:   opcode, rs1_idx, rs2_idx, rd_idx, immediate
              │
              ▼
Read:     rs1_value, rs2_value
              │
              ▼
Execute:  result, branch_info
              │
              ▼
Memory:   mem_value (for loads)
              │
              ▼
Writeback: rd_value, next_pc
```

### Column Dependencies

Which columns depend on which:

```
Independent of current cycle:
  - pc (from previous cycle or initial)
  - registers (from previous cycle or initial)

Depends on instruction:
  - opcode, funct3, funct7
  - rs1_idx, rs2_idx, rd_idx
  - immediate

Depends on decode:
  - rs1_value, rs2_value (via register file)

Depends on execute:
  - result
  - branch_taken
  - mem_addr

Depends on memory:
  - mem_value (for loads)

Depends on everything:
  - rd_value
  - next_pc
```

## Constraint Mapping

### Per-Phase Constraints

Constraints organized by phase:

```
Fetch constraints:
  instruction matches program at PC

Decode constraints:
  Fields correctly extracted from instruction
  Selectors are one-hot
  Immediate correctly sign-extended

Read constraints:
  rs1_value matches register file at rs1_idx
  rs2_value matches register file at rs2_idx

Execute constraints:
  For each instruction type:
    selector * (result - expected) = 0

Memory constraints:
  is_load * (rd_value - mem_value) = 0
  Memory address correctly computed
  Linked to memory state machine

Writeback constraints:
  Register update correct
  PC update correct
```

### Instruction-Specific Constraints

Detailed constraints per instruction:

```
ADD:
  is_add * (result - (rs1_value + rs2_value)) = 0

SUB:
  is_sub * (result - (rs1_value - rs2_value)) = 0

ADDI:
  is_addi * (result - (rs1_value + immediate)) = 0

LW (load word):
  is_lw * (mem_addr - (rs1_value + immediate)) = 0
  is_lw * (rd_value - mem_value) = 0

SW (store word):
  is_sw * (mem_addr - (rs1_value + immediate)) = 0
  is_sw * (mem_value - rs2_value) = 0

BEQ (branch equal):
  is_beq * branch_taken * (next_pc - (pc + immediate)) = 0
  is_beq * (1 - branch_taken) * (next_pc - (pc + 4)) = 0
  is_beq * (branch_taken - (rs1_value == rs2_value)) = 0
```

### Transition Constraints

Linking consecutive cycles:

```
Register persistence:
  For each register i:
    (rd_idx != i) * (reg[i]' - reg[i]) = 0
    // Register unchanged if not written

Register update:
  (rd_idx == i) * (rd_idx != 0) * (reg[i]' - rd_value) = 0
  // Register updated to rd_value if written

PC transition:
  pc' = next_pc
  // Always advances to computed next_pc
```

## Cycle Timing

### Single-Cycle Execution

All operations in one cycle:

```
Advantages:
  - Simple trace structure
  - One row per instruction
  - Direct constraint mapping

Disadvantages:
  - Complex instructions may be costly
  - All constraints active every row
  - Less flexibility

Most instructions fit single-cycle model well.
```

### Multi-Cycle Operations

Some operations span multiple cycles:

```
Examples:
  - Multiplication (if not using precompile)
  - Division
  - Complex memory operations

Approach:
  - Multiple rows per instruction
  - is_continuing flag for intermediate rows
  - Final row produces result

Constraints:
  is_mul_start * (start conditions) = 0
  is_mul_continue * (intermediate conditions) = 0
  is_mul_finish * (result - expected) = 0
```

### Precompile Delegation

Offloading to specialized circuits:

```
For complex operations:
  1. Main cycle issues operation request
  2. Precompile handles computation
  3. Result returned via bus/lookup

Main cycle:
  trace.precompile_call = 1
  trace.precompile_type = SHA256
  trace.precompile_input = input_data

Precompile:
  Separate trace with specialized constraints
  Connected via permutation argument
```

## State Machine Integration

### Main State Machine

The instruction cycle as state machine:

```
States:
  FETCH, DECODE, EXECUTE, MEMORY, WRITEBACK

Transitions:
  FETCH -> DECODE (always)
  DECODE -> EXECUTE (always)
  EXECUTE -> MEMORY (if load/store)
  EXECUTE -> WRITEBACK (if no memory op)
  MEMORY -> WRITEBACK (always)
  WRITEBACK -> FETCH (next instruction)

In single-cycle model:
  All states traversed in one trace row
  State is implicit in column semantics
```

### Auxiliary State Machines

Connected machines:

```
Memory state machine:
  Receives memory operations
  Ensures consistency
  Connected via permutation

Binary state machine:
  Handles bitwise operations
  Provides bit decompositions
  Connected via lookup

Arithmetic state machine:
  Complex arithmetic (mul, div)
  Returns results
  Connected via bus
```

## Key Concepts

- **Instruction cycle**: Sequence of phases per instruction
- **Phases**: Fetch, decode, read, execute, memory, writeback
- **Data flow**: Dependencies between phases
- **Constraints**: Polynomial equations per phase
- **Multi-cycle**: Operations spanning multiple rows

## Design Considerations

### Phase Granularity

| Coarse (Fewer Phases) | Fine (More Phases) |
|-----------------------|-------------------|
| Fewer columns | More columns |
| Complex constraints | Simpler constraints |
| Less flexibility | More flexibility |
| Harder to debug | Easier to debug |

### Single vs. Multi-Cycle

| Single-Cycle | Multi-Cycle |
|--------------|-------------|
| Uniform trace | Variable-length |
| All ops same cost | Complex ops take longer |
| Simpler design | More flexible |
| May be less efficient | Can optimize specific ops |

## Related Topics

- [RISC-V Execution](01-risc-v-execution.md) - Instruction semantics
- [Execution Trace](02-execution-trace.md) - Trace structure
- [Main State Machine](../02-state-machine-design/02-main-state-machine.md) - State machine view
- [Secondary State Machines](../../03-proof-management/02-component-system/03-secondary-state-machines.md) - Auxiliary machines
