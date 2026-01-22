# Register Mapping

## Overview

Register mapping defines how RISC-V architectural registers correspond to state within the zkVM's constraint system. The 32 general-purpose registers must be tracked across instruction execution, with each read and write properly constrained. The mapping strategy affects proof efficiency, memory usage, and the complexity of register-related constraints.

The zkVM must maintain register state consistency across instructions while enabling efficient constraint evaluation. Different approaches trade off between explicit register storage, memory-based register files, and hybrid schemes. Understanding register mapping illuminates how architectural state becomes provable computation state.

## Register Architecture

### RISC-V Register Set

Architectural registers:

```
General-purpose registers:
  x0: Hardwired zero
  x1-x31: General purpose
  Width: 32 bits (RV32) or 64 bits (RV64)

Special semantics:
  x0 always reads as zero
  Writes to x0 are discarded
  No other special registers in base ISA

Program counter:
  Not a general register
  Implicit in instruction sequencing
  Modified by control flow
```

### Register State in Traces

Capturing register values:

```
Per-instruction state:
  Register values before instruction
  Register values after instruction
  Which registers modified

Trace columns:
  May have dedicated register columns
  Or reference memory-mapped registers
  Trade-off in trace width
```

## Mapping Strategies

### Dedicated Columns

Registers as trace columns:

```
Approach:
  One or more columns per register
  Values directly in trace
  Constraints reference columns directly

Advantages:
  Fast access (no memory lookup)
  Direct constraint formulation
  Clear state representation

Disadvantages:
  Wide trace (32+ columns just for registers)
  Most registers unchanged most instructions
  Sparse utilization
```

### Memory-Mapped Registers

Registers in memory:

```
Approach:
  Registers stored at fixed memory addresses
  Register access is memory access
  Unified memory model

Advantages:
  Narrower trace
  Uniform access mechanism
  Scales to more registers

Disadvantages:
  Memory overhead per access
  More constraints for simple operations
  Indirection complexity
```

### Hybrid Approach

Combining strategies:

```
Approach:
  Frequently-used registers in columns
  Others memory-mapped
  Or: current instruction's registers in columns

Example:
  Source registers (rs1, rs2) in dedicated columns
  Destination register (rd) in dedicated column
  Other registers via memory

Benefits:
  Balance width and efficiency
  Optimize for common patterns
```

## Register Read Handling

### Reading Source Registers

Obtaining operand values:

```
Process:
  Instruction specifies rs1, rs2
  Retrieve values from register state
  Use in computation

Constraint requirements:
  Value matches register state
  Zero register handled correctly
  Timing consistent (read before write)

Zero register special case:
  If rs1 == x0, value must be 0
  Constraint: (rs1 == 0) → (rs1_value == 0)
  Or: register_value = (rs1 != 0) ? reg_file[rs1] : 0
```

### Read Multiplexing

Selecting the right register:

```
Challenge:
  Need value from one of 32 registers
  Determined by 5-bit register specifier
  Must constrain correct selection

Approaches:
  Lookup table for register file
  Multiplexer constraint
  Memory access with address check

Lookup approach:
  Register file as lookup table
  Prove value exists at correct index
```

## Register Write Handling

### Writing Destination Register

Updating register state:

```
Process:
  Instruction computes result
  Write to rd if rd != x0
  Update register state for next instruction

Constraint requirements:
  New value correctly computed
  Written to correct register
  Other registers unchanged
  x0 writes ignored

State transition:
  reg_state' = write(reg_state, rd, value)
  If rd == x0: reg_state' = reg_state
```

### Write Consistency

Ensuring correct updates:

```
Transition constraint:
  For each register r:
    If r == rd AND rd != 0:
      reg'[r] = computed_value
    Else:
      reg'[r] = reg[r]

Efficiency:
  Many unchanged registers
  Can optimize "unchanged" case
  Focus constraints on modified register
```

## State Machine Integration

### Register State per Cycle

Tracking through execution:

```
Execution cycle:
  1. Read rs1 from current state
  2. Read rs2 from current state
  3. Compute result
  4. Write to rd in next state
  5. Advance to next instruction

State representation:
  Registers at cycle i
  Operations during cycle i
  Registers at cycle i+1

Constraints link:
  Input state → computation → output state
```

### Cross-Cycle Consistency

Linking instruction states:

```
Requirement:
  Cycle N output = Cycle N+1 input
  For all registers
  Continuity across execution

Implementation:
  Permutation between adjacent rows
  Or: explicit equality constraints
  Or: memory consistency for reg file
```

## Optimization Techniques

### Register Caching

Avoiding redundant lookups:

```
Pattern:
  Same register read multiple times
  Cache value, constrain once
  Reuse cached value

Example:
  ADD followed by ADD using same source
  Second read can reference first read's value
  Reduces lookup operations
```

### Speculative Read

Pre-fetching register values:

```
Pattern:
  Read both possible source registers
  Select based on instruction
  Parallel reads for efficiency

Implementation:
  Columns for rs1_value, rs2_value
  Constrain these match register file
  Use in instruction execution
```

### Write Combining

Handling multiple writes:

```
Scenario:
  Typically one write per instruction
  But consider instruction sequences
  May optimize write patterns

zkVM context:
  Usually single write per instruction
  Simpler model
  No complex combining needed
```

## Special Register Handling

### Zero Register (x0)

Hardwired zero:

```
Read behavior:
  Always returns 0
  Regardless of previous writes
  Used for discarding results

Write behavior:
  Writes have no effect
  Instruction completes normally
  State unchanged

Constraint:
  reg_value(x0) = 0 always
  write(x0, v) = no-op
```

### Return Address (x1/ra)

Function call support:

```
Convention:
  JAL/JALR write return address to x1
  Standard calling convention
  Not architecturally special

zkVM handling:
  Treated as normal register
  JALR writes PC+4 to rd (often x1)
  No special constraints
```

### Stack Pointer (x2/sp)

Stack management:

```
Convention:
  Conventionally used for stack
  Adjusted on function entry/exit
  Not architecturally special

zkVM handling:
  Treated as normal register
  Software manages stack correctly
  No hardware enforcement
```

## Memory-Based Register File

### Register File as Memory

Unified memory model:

```
Design:
  Registers at fixed memory addresses
  Address 0-31 for x0-x31
  Standard memory operations

Operations:
  Read register: memory load from address
  Write register: memory store to address
  Same memory consistency rules

Advantages:
  Unified constraint system
  Simpler state machine
  Natural register-memory operations
```

### Address Assignment

Mapping registers to addresses:

```
Simple mapping:
  reg_addr(xN) = N
  Or: reg_addr(xN) = BASE + N * 4

Isolation:
  Register addresses separate from data memory
  Different memory regions
  No overlap
```

## Key Concepts

- **Register mapping**: Correspondence between architectural and proving state
- **Dedicated columns**: Registers as explicit trace columns
- **Memory-mapped**: Registers as memory locations
- **Read multiplexing**: Selecting correct register value
- **Write consistency**: Ensuring proper state updates

## Design Considerations

### Mapping Strategy

| Dedicated Columns | Memory-Mapped |
|-------------------|---------------|
| Fast access | Unified model |
| Wide trace | Narrow trace |
| Simple constraints | Memory constraints |
| Good for hot registers | Scales to more state |

### Trace Width Trade-off

| Narrow Trace | Wide Trace |
|--------------|------------|
| Less memory | More memory |
| More constraints | Direct access |
| Complex mapping | Simple mapping |

## Related Topics

- [RISC-V Fundamentals](01-risc-v-fundamentals.md) - Register architecture
- [Instruction Transpilation](02-instruction-transpilation.md) - Instruction handling
- [Memory Model](../03-memory-model/01-memory-layout.md) - Memory system

