# Aligned Access

## Overview

Aligned access refers to the requirement that memory operations access addresses that are multiples of the access size. A word (4-byte) access must occur at an address divisible by 4, a halfword (2-byte) access at an address divisible by 2, and byte accesses can occur at any address. Alignment simplifies memory subsystem design and, critically for zkVMs, reduces the complexity of memory consistency constraints.

In traditional processors, misaligned access may be supported through hardware that performs multiple aligned accesses and combines the results. This flexibility comes at a cost in complexity and timing. For zkVMs, where every operation must be proven, misaligned access would significantly complicate the constraint system by requiring decomposition of single logical operations into multiple physical operations.

This document explains alignment requirements, their implications for program design, and how the zkVM handles alignment in its constraint system.

## Alignment Fundamentals

### Natural Alignment

The basic alignment principle:

```
Alignment rules:
  1-byte access: Any address (always aligned)
  2-byte access: Address mod 2 = 0
  4-byte access: Address mod 4 = 0
  8-byte access: Address mod 8 = 0 (for 64-bit)

Natural alignment:
  Access aligned if address divisible by access size
  This is the standard requirement
```

### Address Bit Patterns

How alignment appears in binary:

```
4-byte aligned addresses:
  Binary ends in 00
  0x0000, 0x0004, 0x0008, ...

2-byte aligned addresses:
  Binary ends in 0
  0x0000, 0x0002, 0x0004, ...

Any address (byte):
  No restriction on low bits
  0x0000, 0x0001, 0x0002, ...

Alignment check:
  addr & (size - 1) == 0
```

### Memory Word Structure

How bytes are organized in words:

```
Word at address A (little-endian):
  Byte 0 at address A
  Byte 1 at address A+1
  Byte 2 at address A+2
  Byte 3 at address A+3

Word value:
  word = byte3 << 24 | byte2 << 16 | byte1 << 8 | byte0

Aligned access reads/writes entire word atomically
```

## RISC-V Alignment Model

### Base ISA Requirements

What RISC-V specifies:

```
Standard requirements:
  LW/SW: Word-aligned (addr mod 4 = 0)
  LH/LHU/SH: Halfword-aligned (addr mod 2 = 0)
  LB/LBU/SB: No alignment requirement

Violation behavior:
  May raise address-misaligned exception
  Or may handle in hardware (extension)
  Implementation-defined
```

### zkVM Alignment Policy

How the zkVM handles alignment:

```
Strict alignment:
  Require natural alignment for all multi-byte accesses
  Misaligned access causes trap or constraint failure

Rationale:
  Simpler memory constraints
  Deterministic behavior
  Compiler typically ensures alignment

Trade-off:
  Some RISC-V code may need modification
  Benefit: simpler, more efficient proving
```

## Aligned Access Constraints

### Alignment Verification

Constraint for checking alignment:

```
For word access at address A:
  Constraint: A mod 4 = 0
  Equivalent: A & 3 = 0
  Equivalent: A[1:0] = 00 (binary)

For halfword access at address A:
  Constraint: A mod 2 = 0
  Equivalent: A & 1 = 0
  Equivalent: A[0] = 0 (binary)

Constraint form:
  is_word * (addr & 3) = 0
  is_half * (addr & 1) = 0
```

### Extracting Alignment Bits

Checking low-order bits:

```
Low bit extraction:
  bit_0 = addr - (addr >> 1) * 2
  bit_1 = (addr >> 1) - (addr >> 2) * 2

Alternatively:
  Use lookup table for small values
  Or range check decomposition

Alignment constraint:
  is_word * (bit_0 + bit_1 * 2) = 0
```

## Sub-Word Access Handling

### Byte Load Operations

Loading a single byte:

```
LB/LBU instruction:
  Address: A (any value)
  Word address: A_word = A & ~3
  Byte offset: offset = A & 3

Operation:
  word = memory[A_word]
  byte = (word >> (offset * 8)) & 0xFF

Sign extension (LB):
  If byte[7] = 1: result = 0xFFFFFF00 | byte
  If byte[7] = 0: result = byte

Unsigned (LBU):
  result = byte
```

### Byte Store Operations

Storing a single byte:

```
SB instruction:
  Address: A
  Value: V (byte to store)

Operation:
  A_word = A & ~3
  offset = A & 3
  mask = 0xFF << (offset * 8)
  old_word = memory[A_word]
  new_word = (old_word & ~mask) | ((V & 0xFF) << (offset * 8))
  memory[A_word] = new_word
```

### Halfword Operations

Loading and storing halfwords:

```
LH/LHU at address A:
  A_word = A & ~3
  half_offset = (A >> 1) & 1
  word = memory[A_word]
  half = (word >> (half_offset * 16)) & 0xFFFF
  Sign extend or zero extend based on instruction

SH at address A, value V:
  A_word = A & ~3
  half_offset = (A >> 1) & 1
  mask = 0xFFFF << (half_offset * 16)
  old_word = memory[A_word]
  new_word = (old_word & ~mask) | ((V & 0xFFFF) << (half_offset * 16))
  memory[A_word] = new_word
```

## Constraint Formulation

### Word Access Constraints

Proving word load/store:

```
Word load at aligned address:
  value_loaded = memory[addr]
  addr & 3 = 0

Constraint columns:
  addr: Address accessed
  value: Data loaded/stored
  is_word: Selector for word operation

Constraints:
  is_word * (addr[1:0]) = 0
  is_word * (value - memory_value) = 0
```

### Sub-Word Access Constraints

Proving byte/halfword operations:

```
Additional columns:
  word_addr: Aligned word address
  offset: Byte offset within word
  word_value: Full word from memory
  extracted: Extracted sub-word value

Constraints:
  word_addr = addr - offset
  offset < 4
  extracted correctly computed from word_value and offset
```

### Offset Computation

Computing byte position:

```
Offset extraction:
  offset = addr mod 4 = addr - word_addr
  word_addr = addr - offset

Constraint:
  addr = word_addr + offset
  word_addr & 3 = 0  (aligned)
  offset in {0, 1, 2, 3}

For halfword:
  half_offset = (addr >> 1) & 1
  addr & 1 = 0 (halfword aligned)
```

## Shift and Mask Operations

### Byte Selection

Extracting bytes from words:

```
Byte selection by offset:
  offset 0: byte = word & 0xFF
  offset 1: byte = (word >> 8) & 0xFF
  offset 2: byte = (word >> 16) & 0xFF
  offset 3: byte = (word >> 24) & 0xFF

General formula:
  byte = (word >> (offset * 8)) & 0xFF
```

### Byte Insertion

Updating bytes in words:

```
Byte insertion by offset:
  mask = 0xFF << (offset * 8)
  cleared = word & ~mask
  inserted = (byte << (offset * 8)) & mask
  result = cleared | inserted

Per-offset expansion:
  offset 0: (word & 0xFFFFFF00) | byte
  offset 1: (word & 0xFFFF00FF) | (byte << 8)
  offset 2: (word & 0xFF00FFFF) | (byte << 16)
  offset 3: (word & 0x00FFFFFF) | (byte << 24)
```

### Constraint for Shifts

Proving shift operations:

```
Challenge:
  Variable shift amount in constraints

Approaches:
  Case split by offset value
  Lookup table for shift results
  Decomposition into fixed operations

Selector approach:
  is_offset_0, is_offset_1, is_offset_2, is_offset_3
  Exactly one is 1
  Use selectors to pick correct formula
```

## Sign Extension

### Byte Sign Extension

Extending signed bytes to words:

```
LB instruction:
  Load byte, sign extend to 32 bits

Mechanism:
  If byte[7] = 1 (negative):
    result = byte | 0xFFFFFF00
  If byte[7] = 0 (positive):
    result = byte

Constraint:
  sign_bit = (byte >> 7) & 1
  result = byte | (sign_bit * 0xFFFFFF00)
```

### Halfword Sign Extension

Extending signed halfwords:

```
LH instruction:
  Load halfword, sign extend to 32 bits

Mechanism:
  If half[15] = 1:
    result = half | 0xFFFF0000
  If half[15] = 0:
    result = half

Constraint:
  sign_bit = (half >> 15) & 1
  result = half | (sign_bit * 0xFFFF0000)
```

## Misaligned Access Handling

### Detection

Identifying misaligned access:

```
Detection logic:
  is_misaligned_word = (addr & 3) != 0 when is_word
  is_misaligned_half = (addr & 1) != 0 when is_half

Response:
  Trigger trap
  Or: constraint failure (proof invalid)
```

### Trap Generation

When misalignment causes exception:

```
Trap behavior:
  Record exception type
  Save offending address
  Transfer to trap handler
  Handler may emulate or abort

zkVM approach:
  Typically disallow misaligned
  No trap handling overhead
  Compiler ensures alignment
```

### Software Emulation

If misaligned access needed:

```
Emulation approach:
  Compiler or runtime handles misalignment
  Multiple aligned accesses
  Combine results in software

Example - misaligned word load:
  Load two aligned words
  Shift and combine
  Higher overhead but compatible
```

## Performance Implications

### Proof Efficiency

How alignment affects proving:

```
Aligned access:
  Single memory operation
  Simple constraints
  Efficient proving

Misaligned (if allowed):
  Multiple operations
  Complex combining logic
  Higher constraint count
```

### Memory System Design

Alignment simplifies memory:

```
Word-aligned memory:
  Single port per access
  No shifting hardware needed
  Simpler address decoding

Sub-word access:
  Still requires masking
  But based on offset, not alignment
  Predictable structure
```

## Programming Considerations

### Compiler Support

How compilers handle alignment:

```
Stack variables:
  Compiler aligns to natural boundaries
  4-byte alignment for words
  Padding added as needed

Structure layout:
  Fields aligned within structures
  Overall structure aligned
  Padding between fields

Global variables:
  Linker places at aligned addresses
  Section alignment specified
```

### Manual Alignment

When programmer controls layout:

```
Array alignment:
  Ensure base address aligned
  Element size determines stride

Packed structures:
  May create misalignment
  Avoid or handle carefully

Buffer alignment:
  Allocator provides alignment
  Request sufficient alignment
```

## Key Concepts

- **Natural alignment**: Address divisible by access size
- **Word alignment**: 4-byte boundary for 32-bit access
- **Sub-word access**: Byte/halfword operations within words
- **Sign extension**: Expanding signed values to full width
- **Offset computation**: Determining position within aligned word

## Design Trade-offs

### Strict vs Relaxed Alignment

| Strict Alignment | Relaxed Alignment |
|------------------|-------------------|
| Simple constraints | Complex constraints |
| Less flexibility | Full compatibility |
| Better efficiency | Higher overhead |

### Sub-Word Strategy

| Word-Based with Masking | Byte-Level Tracking |
|-------------------------|---------------------|
| Fewer memory operations | More granular |
| Masking overhead | Simpler extraction |
| Good for word-heavy code | Good for byte-heavy code |

## Related Topics

- [Memory Layout](01-memory-layout.md) - Address space organization
- [Memory Consistency](02-memory-consistency.md) - Consistency model
- [Memory Timestamping](04-memory-timestamping.md) - Operation ordering
- [Memory State Machine](../02-state-machine-design/05-memory-state-machine.md) - Operation handling

