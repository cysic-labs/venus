# Register Emulation

## Overview

Register emulation replicates the behavior of RISC-V's general-purpose registers within the zkVM proving system. RISC-V provides 32 integer registers (x0-x31), where x0 is hardwired to zero and the remaining 31 are general-purpose. The zkVM must track register state across instruction execution and generate constraints ensuring that register reads and writes are consistent with program semantics.

The challenge is efficiently representing 32 64-bit registers within the constraint system. Options range from dedicating trace columns to each register (simple but wide) to using lookup-based register files (compact but complex). This document covers register representation strategies, read/write constraint patterns, and optimization techniques for efficient register emulation.

## RISC-V Register Model

### Register Set

The standard register file:

```
x0 (zero): Always contains 0
x1 (ra): Return address
x2 (sp): Stack pointer
x3 (gp): Global pointer
x4 (tp): Thread pointer
x5-x7 (t0-t2): Temporaries
x8 (s0/fp): Saved register / Frame pointer
x9 (s1): Saved register
x10-x11 (a0-a1): Function arguments / Return values
x12-x17 (a2-a7): Function arguments
x18-x27 (s2-s11): Saved registers
x28-x31 (t3-t6): Temporaries

Width:
  RV32: 32 bits
  RV64: 64 bits
```

### Register Operations

Types of register access:

```
Read:
  Value fetched from register
  x0 always reads as 0
  Used as source operand

Write:
  Value stored to register
  x0 writes are discarded
  Used as destination

Per instruction:
  Up to 2 source registers (rs1, rs2)
  Up to 1 destination register (rd)
  Some instructions don't use all
```

### Register Conventions

ABI usage patterns:

```
Caller-saved (temporaries):
  t0-t6, a0-a7
  May be overwritten by calls
  Save before call if needed

Callee-saved (preserved):
  s0-s11, sp, ra
  Function must preserve
  Restore before return

Special:
  sp: Stack pointer (maintained by convention)
  ra: Return address (from JAL/JALR)
  zero: Constant zero
```

## Representation Strategies

### Full Column Representation

One column per register:

```
Trace columns:
  r0, r1, r2, ..., r31: Current register values
  r0_next, r1_next, ..., r31_next: Next values

Properties:
  Direct access to any register
  Wide trace (64+ columns just for registers)
  Simple constraints

Constraints:
  r0 = 0 (always)
  r0_next = 0 (always)
  For each non-destination:
    ri_next = ri
  For destination rd:
    rd_next = computed_value
```

### Indexed Representation

Register index and value columns:

```
Columns:
  rs1_idx, rs1_val: Source 1
  rs2_idx, rs2_val: Source 2
  rd_idx, rd_val: Destination

Lookup to register table:
  (cycle, reg_idx, reg_val) in register_table

Benefits:
  Fewer columns
  Variable register access
  Lookup overhead

Constraints:
  (cycle, rs1_idx, rs1_val) lookup
  (cycle, rs2_idx, rs2_val) lookup
  (cycle+1, rd_idx, rd_val) lookup with new value
```

### Hybrid Representation

Mix of direct and indexed:

```
Hot registers (direct):
  sp, ra, a0-a1: Frequently accessed
  Dedicated columns

Cold registers (indexed):
  Less frequently used
  Via lookup table

Selection:
  If accessing hot register: Use direct column
  Otherwise: Use lookup

Balance:
  Reduced column count
  Fast access to common registers
```

## Read Operations

### Source Register Read

Fetching rs1 and rs2:

```
Instruction needs rs1 value:
  Decode: rs1_idx = inst[19:15]
  Read: rs1_val = registers[rs1_idx]

Constraint:
  // Register read consistency
  (cycle, rs1_idx, rs1_val) in register_file

  // Zero register special case
  (rs1_idx == 0) implies rs1_val = 0

For full column representation:
  rs1_val = Σ (rs1_is_i * ri) for i in 0..31
  where rs1_is_i = (rs1_idx == i)
```

### Zero Register

Ensuring x0 always reads zero:

```
Hardwired zero:
  x0 contains 0 regardless of writes
  Reading x0 always returns 0

Constraint approaches:

Approach 1 (always zero):
  r0 = 0
  r0_next = 0

Approach 2 (conditional):
  (rs1_idx == 0) * (rs1_val) = 0
  (rs2_idx == 0) * (rs2_val) = 0

Approach 3 (via table):
  Register table entry for x0 always has value 0
```

### Multiple Reads

Reading both source registers:

```
Most instructions read two sources:
  ADD rd, rs1, rs2

Both reads must be consistent:
  rs1_val from register file at rs1_idx
  rs2_val from register file at rs2_idx

Parallel constraint:
  Both lookups in same cycle
  Or both direct column reads

Edge case:
  rs1_idx == rs2_idx: Both should read same value
```

## Write Operations

### Destination Register Write

Storing result to rd:

```
After computation:
  rd_next = computed_result

Constraint:
  writes_rd * (rd_idx != 0) * (rd_next - result) = 0
  !writes_rd * (rd_next - rd_current) = 0

For full columns:
  For each register i:
    is_dest_i = (rd_idx == i) * writes_rd
    ri_next = is_dest_i * result + !is_dest_i * ri
```

### Write to Zero Register

Discarding writes to x0:

```
Write to x0 is valid but ignored:
  ADD x0, x1, x2  // Computes but discards

Constraint:
  r0_next = 0  // Always zero

Or:
  (rd_idx == 0) implies write has no effect
  Only write to register file if rd_idx != 0
```

### Write Consistency

Ensuring writes propagate:

```
After write at cycle T:
  Register value changes
  Subsequent reads see new value

Constraint:
  If rd written at cycle T:
    reg[rd] at cycle T+1 = written_value

State transition:
  reg_next[i] = (is_dest_i) ? result : reg[i]
```

## Register File Machine

### Separate Register Machine

Dedicated state machine for registers:

```
Register machine trace:
  (cycle, reg_idx, value, is_write)

Main machine sends:
  Read requests
  Write requests

Consistency:
  Permutation between main and register machine
  All reads/writes match

Benefits:
  Cleaner separation
  Potentially smaller main trace
```

### Inline Register State

Registers in main trace:

```
Main trace includes:
  r0, r1, ..., r31 columns
  r0_next, r1_next, ..., r31_next columns

Or just:
  r0, r1, ..., r31 (next row is next state)

State machine transition:
  Current row state → Next row state
  Constraints enforce correct updates
```

### Register Lookup Table

Table-based register file:

```
Table structure:
  (cycle, reg_idx, reg_value)

Read lookup:
  Query (cycle, rs1_idx, ?) returns rs1_val

Write update:
  Insert (cycle+1, rd_idx, new_value)

Sorted by (cycle, reg_idx):
  Efficient lookup
  Sequential consistency
```

## Optimization Techniques

### Register Caching

Exploit locality:

```
Observation:
  Many instructions access same registers
  Loop variables in fixed registers

Optimization:
  Cache recent register values
  Skip lookup if cached

Constraint:
  Still prove correctness via lookup
  Caching is prover optimization
```

### Sparse Updates

Most registers unchanged:

```
Observation:
  Only 1 register changes per instruction
  31 registers stay the same

Optimization:
  Track only changed register per cycle
  Assume others unchanged

Constraint:
  rd_next = new_value
  For i != rd: ri_next = ri (implicitly)
```

### Register Renaming

Eliminate read-after-write dependencies:

```
Concept:
  Map logical registers to physical
  Avoid unnecessary constraints

Application:
  If register written then immediately read
  Forward result directly
  Skip register file round-trip
```

## Error Handling

### Invalid Register Index

Malformed instruction:

```
Valid indices: 0-31 (5 bits)
Constraint:
  rs1_idx < 32
  rs2_idx < 32
  rd_idx < 32

Via range check:
  5-bit values automatically in range
  No explicit constraint needed if decoded correctly
```

### Uninitialized Registers

Reading before writing:

```
Initial state:
  All registers initialized (usually to 0)
  Or from program entry state

Constraint:
  Cycle 0: All registers have initial values
  Subsequent: Derived from previous state

No "undefined" concept:
  All registers have defined values
  Even if program doesn't initialize
```

## Key Concepts

- **Register file**: 32 general-purpose registers
- **Zero register (x0)**: Hardwired to zero
- **Read operation**: Fetching register value
- **Write operation**: Storing result to register
- **State transition**: Register values from cycle to cycle

## Design Considerations

### Representation Trade-offs

| Full Columns | Indexed Lookup |
|--------------|----------------|
| 32+ columns | Few columns |
| Direct access | Lookup overhead |
| Simple constraints | Complex constraints |
| Wide trace | Narrow trace |

### Machine Organization

| Inline | Separate Machine |
|--------|------------------|
| Simpler architecture | Cleaner separation |
| Wider main trace | Smaller main trace |
| Direct constraints | Cross-machine linking |
| No lookup needed | Lookup/permutation needed |

## Related Topics

- [Instruction Set Support](01-instruction-set-support.md) - Register usage
- [Memory Emulation](03-memory-emulation.md) - Memory operations
- [Operand Handling](../../04-zkvm-architecture/04-instruction-handling/03-operand-handling.md) - Register operands
- [Result Writeback](../../04-zkvm-architecture/04-instruction-handling/04-result-writeback.md) - Register writes
