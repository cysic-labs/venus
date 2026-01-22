# Register Model

## Overview

The register model defines how the emulator represents and manages CPU registers during execution. RISC-V specifies 32 general-purpose registers, with x0 hardwired to zero. The emulator must faithfully implement register semantics while efficiently supporting trace generation.

Register operations are among the most frequent in program execution, occurring in nearly every instruction. The register model must optimize for fast access while maintaining accurate state for trace capture. The design influences both emulation performance and the structure of the execution trace.

This document covers register representation, access patterns, and integration with trace capture.

## Register Architecture

### RISC-V Registers

Standard register set:

```
General-purpose:
  x0: Hardwired zero
  x1-x31: General purpose

Width:
  32 bits for RV32
  64 bits for RV64

Naming:
  x0 = zero
  x1 = ra (return address)
  x2 = sp (stack pointer)
  x8 = fp/s0 (frame pointer)
  etc.
```

### x0 Semantics

The zero register:

```
Read behavior:
  Always returns 0
  Regardless of writes

Write behavior:
  Writes are ignored
  No state change

Implementation:
  Special handling in access
  Or: always reset to 0
```

## Register Storage

### Array Representation

Simple array storage:

```
Implementation:
  uint32_t regs[32]
  Direct indexing: regs[rs1]

Benefits:
  Simple access
  Cache-friendly
  Fast updates
```

### Access Functions

Register interface:

```
Read:
  value = read_reg(idx)
  Return 0 if idx == 0

Write:
  write_reg(idx, value)
  Ignore if idx == 0

Recording:
  Capture reads/writes for trace
```

## Access Patterns

### Instruction Operands

Typical register access:

```
Per instruction:
  Read rs1 (source 1)
  Read rs2 (source 2, if R-type)
  Write rd (destination)

Example (ADD):
  op1 = read_reg(rs1)
  op2 = read_reg(rs2)
  result = op1 + op2
  write_reg(rd, result)
```

### Common Patterns

Frequent access combinations:

```
Two reads, one write:
  Most R-type instructions

One read, one write:
  I-type immediate operations

Read only:
  Branches, stores

Write only:
  LUI, AUIPC, JAL
```

## Trace Integration

### Recording Reads

Capturing source values:

```
Record:
  Register index
  Value read
  Instruction context

Per instruction:
  rs1_value = regs[rs1]
  rs2_value = regs[rs2] (if applicable)
```

### Recording Writes

Capturing destination updates:

```
Record:
  Register index
  Old value (optional)
  New value

Per instruction:
  old_rd = regs[rd]
  regs[rd] = result
  record(rd, old_rd, result)
```

### State Snapshots

Periodic full capture:

```
Snapshot:
  All 32 register values
  At segment boundaries

Use:
  Continuation creation
  Verification checkpoints
```

## Performance Optimization

### Access Speed

Fast register operations:

```
Inline access:
  Direct array indexing
  No function call overhead

x0 handling:
  Check at write, not read
  Or: always reset after write
```

### Caching

Register locality:

```
Observation:
  Same registers often accessed
  Locality in register use

Optimization:
  May cache recent accesses
  Usually array access sufficient
```

## Consistency Guarantees

### Read-After-Write

Same-instruction behavior:

```
RAW within instruction:
  Write then read same register
  Read sees new value

Implementation:
  Write to array
  Read from array
  Natural behavior
```

### Sequential Consistency

Cross-instruction ordering:

```
Requirement:
  Later instruction sees earlier writes
  Sequential execution model

Implementation:
  Direct array access
  Naturally consistent
```

## Key Concepts

- **Register model**: Representation of CPU registers
- **x0 semantics**: Always-zero register handling
- **Access patterns**: Common read/write combinations
- **Trace recording**: Capturing register operations
- **State snapshots**: Periodic full state capture

## Design Trade-offs

### Storage vs Computation

| Store All | Compute on Demand |
|-----------|-------------------|
| Fast access | Slower access |
| More memory | Less memory |
| Simple | Complex |

### Recording Granularity

| Every Access | Changed Only |
|--------------|--------------|
| Complete trace | Smaller trace |
| Higher overhead | Lower overhead |
| No reconstruction | Reconstruction needed |

## Related Topics

- [Emulator Design](../01-emulator-architecture/01-emulator-design.md) - Overall architecture
- [Register Mapping](../../04-zkvm-architecture/01-isa-integration/03-register-mapping.md) - Constraint representation
- [Memory Management](02-memory-management.md) - Memory model
- [RISC-V Fundamentals](../../04-zkvm-architecture/01-isa-integration/01-risc-v-fundamentals.md) - ISA registers

