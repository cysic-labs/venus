# Memory Emulation

## Overview

Memory emulation replicates the behavior of a byte-addressable memory system within the zkVM. RISC-V programs expect a flat address space where loads fetch data and stores update data persistently. The zkVM must prove that every load returns the value from the most recent store to that address, maintaining the illusion of real memory without access to actual hardware.

The memory subsystem handles various access sizes (byte, halfword, word, doubleword), alignment requirements, and address space layout. It interfaces with the main execution machine to process load/store instructions and connects to the memory consistency machine to prove correctness. This document covers memory operation semantics, access patterns, emulation mechanisms, and integration with the proving system.

## Memory Model

### Address Space

Flat memory organization:

```
Address space:
  32-bit (RV32): 4 GB addressable
  64-bit (RV64): Large virtual space

Typical layout:
  0x00000000 - 0x0FFFFFFF: Reserved/Code
  0x10000000 - 0x7FFFFFFF: Data/Heap
  0x80000000 - 0xBFFFFFFF: Stack
  0xC0000000 - 0xFFFFFFFF: I/O

Byte addressable:
  Every byte has unique address
  Multi-byte access at base address
```

### Memory Regions

Different memory types:

```
Code segment:
  Read-only (program instructions)
  Fixed at program load
  Verified against known hash

Data segment:
  Initialized data from program
  Read-write after load
  Global variables

Heap:
  Dynamic allocation (malloc, etc.)
  Initially zero
  Grows upward

Stack:
  Function call frames
  Local variables
  Grows downward

I/O region:
  Special addresses for I/O
  May have different semantics
```

### Access Granularity

Supported access sizes:

```
Byte (8 bits):
  LB: Load byte (sign-extend)
  LBU: Load byte unsigned
  SB: Store byte

Halfword (16 bits):
  LH: Load halfword (sign-extend)
  LHU: Load halfword unsigned
  SH: Store halfword

Word (32 bits):
  LW: Load word (sign-extend in RV64)
  LWU: Load word unsigned (RV64)
  SW: Store word

Doubleword (64 bits, RV64):
  LD: Load doubleword
  SD: Store doubleword
```

## Load Operations

### Load Semantics

Reading from memory:

```
LW rd, offset(rs1):
  address = rs1 + sign_extend(offset)
  value = memory[address:address+3]  // 4 bytes
  rd = sign_extend(value)  // RV64

LB rd, offset(rs1):
  address = rs1 + sign_extend(offset)
  byte = memory[address]
  rd = sign_extend(byte)  // 8-bit to 64-bit

LBU rd, offset(rs1):
  address = rs1 + sign_extend(offset)
  byte = memory[address]
  rd = zero_extend(byte)  // 8-bit to 64-bit
```

### Address Computation

Computing effective address:

```
Address formula:
  effective_address = rs1_value + immediate

Immediate types:
  I-type: 12-bit signed immediate
  Sign-extended to register width

Constraint:
  mem_addr = rs1_val + imm_i
  Range check: mem_addr in valid range
```

### Load Constraints

Proving correct load:

```
Columns:
  mem_addr: Computed address
  mem_val: Value loaded
  mem_size: Access size (1, 2, 4, 8 bytes)
  is_load: This is a load operation

Memory consistency:
  (mem_addr, mem_val, cycle, READ) in memory_trace

Sign extension:
  For LB: rd = sign_extend_8(mem_val & 0xFF)
  For LH: rd = sign_extend_16(mem_val & 0xFFFF)
  For LW (RV64): rd = sign_extend_32(mem_val & 0xFFFFFFFF)
```

## Store Operations

### Store Semantics

Writing to memory:

```
SW rs2, offset(rs1):
  address = rs1 + sign_extend(offset)
  memory[address:address+3] = rs2[31:0]

SB rs2, offset(rs1):
  address = rs1 + sign_extend(offset)
  memory[address] = rs2[7:0]

SH rs2, offset(rs1):
  address = rs1 + sign_extend(offset)
  memory[address:address+1] = rs2[15:0]
```

### Store Constraints

Proving correct store:

```
Columns:
  mem_addr: Computed address (same as load)
  mem_val: Value to store (rs2)
  mem_size: Access size
  is_store: This is a store operation

Memory update:
  (mem_addr, mem_val, cycle, WRITE) in memory_trace

Size handling:
  For SB: Store only low 8 bits of rs2
  For SH: Store only low 16 bits of rs2
  For SW: Store low 32 bits of rs2
```

### Byte/Halfword Stores

Partial word updates:

```
Storing byte to word-aligned memory:
  Read current word
  Modify specific byte
  Write back word

Constraint approach:
  Track at byte granularity
  Or handle in memory machine

Byte position:
  byte_pos = addr & 0x3  // Position in word
  byte_mask = 0xFF << (byte_pos * 8)
```

## Alignment Handling

### Natural Alignment

Alignment requirements:

```
RISC-V requirements:
  Default: Misaligned access allowed (may be slow)
  Some implementations: Trap on misalignment

Natural alignment:
  Halfword: addr[0] = 0
  Word: addr[1:0] = 0
  Doubleword: addr[2:0] = 0

zkVM choice:
  Often require natural alignment
  Simplifies constraints
  Matches most compiled code
```

### Alignment Constraints

Enforcing alignment:

```
Word alignment constraint:
  is_word_access * (mem_addr & 0x3) = 0

Halfword alignment:
  is_half_access * (mem_addr & 0x1) = 0

Doubleword alignment:
  is_dword_access * (mem_addr & 0x7) = 0

Violation handling:
  Exception: Misaligned access fault
  Or: Decompose into aligned accesses
```

### Misaligned Access Emulation

If misalignment is supported:

```
Misaligned word load:
  Split into multiple byte loads
  Combine bytes into word

Example (misaligned LW at addr 0x1001):
  byte0 = mem[0x1001]
  byte1 = mem[0x1002]
  byte2 = mem[0x1003]
  byte3 = mem[0x1004]
  word = byte0 | (byte1 << 8) | (byte2 << 16) | (byte3 << 24)

Constraint cost:
  4 memory operations instead of 1
  Much more expensive
```

## Memory Machine Integration

### Memory Operations Interface

Connecting to memory machine:

```
Main machine sends:
  (addr, value, size, op_type, cycle)

Memory machine receives:
  Same tuple via permutation

Consistency:
  Permutation proves operations match
  Memory machine proves consistency
```

### Read-After-Write Consistency

Ensuring correct values:

```
If store at cycle T:
  memory[addr] = value

If load at cycle T' > T (no intervening store):
  memory[addr] must return value

Memory machine:
  Sorts operations by (addr, cycle)
  Checks read follows write
```

### Initial Memory State

Starting values:

```
Code segment:
  Initialized from program
  Known values (from hash)

Data segment:
  Initialized data sections
  From program loading

Zero-initialized:
  BSS segment
  Heap (initially)

Constraint:
  First read to address returns initial value
  Or zero if not initialized
```

## Optimization Techniques

### Memory Access Caching

Exploit locality:

```
Recent accesses:
  Cache last N memory operations
  Skip memory machine lookup if cached

Validity:
  Cache valid if no intervening store
  Invalidate on store to same address
```

### Word-Level Tracking

Reduce granularity:

```
Track at word level instead of byte:
  Fewer memory operations
  Simpler consistency

Byte access:
  Load word containing byte
  Extract byte from word

Trade-off:
  Simpler memory machine
  More complex load/store logic
```

### Batch Memory Operations

Group memory accesses:

```
Multiple accesses per cycle:
  Instruction fetch + data access
  Batch into memory machine

Batch constraints:
  All operations in batch linked
  Memory machine handles batch
```

## Error Handling

### Access Violations

Invalid memory access:

```
Out of bounds:
  Address not in valid memory range
  Trigger access fault

Invalid permissions:
  Write to read-only memory
  Execute from non-executable

Constraint:
  is_invalid_access = address out of range
  is_invalid_access implies exception
```

### Alignment Faults

Misalignment exceptions:

```
If misalignment not supported:
  Detect misaligned access
  Trigger alignment exception

Exception code:
  Load address misaligned: 4
  Store address misaligned: 6

Constraint:
  is_misaligned * is_aligned_required implies exception
```

## Key Concepts

- **Memory emulation**: Simulating byte-addressable memory
- **Load operation**: Reading value from memory
- **Store operation**: Writing value to memory
- **Alignment**: Address divisibility requirements
- **Memory consistency**: Reads return correct values

## Design Considerations

### Access Granularity

| Byte Level | Word Level |
|------------|------------|
| Fine-grained | Coarse-grained |
| More operations | Fewer operations |
| Complex consistency | Simpler consistency |
| Larger memory trace | Smaller memory trace |

### Alignment Policy

| Require Alignment | Allow Misaligned |
|-------------------|------------------|
| Simpler constraints | Complex handling |
| Faster proving | Slower proving |
| Less compatible | More compatible |
| Exception on violation | Split accesses |

## Related Topics

- [Instruction Set Support](01-instruction-set-support.md) - Load/store instructions
- [Register Emulation](02-register-emulation.md) - Operand sources
- [Memory Architecture](../../04-zkvm-architecture/03-memory-system/01-memory-architecture.md) - Memory proving
- [Memory Consistency](../../04-zkvm-architecture/03-memory-system/02-memory-consistency.md) - Consistency mechanism
