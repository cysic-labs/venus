# Memory State Machine

## Overview

The memory state machine manages all memory operations within the zkVM, ensuring that every load and store instruction produces cryptographically verifiable results. Unlike traditional processors where memory operations simply access RAM, the zkVM memory state machine must maintain a complete audit trail of all accesses and prove that reads return values consistent with previous writes.

Memory operations in zero-knowledge proving present unique challenges. Each read must demonstrably return the value from the most recent write to that address. The memory state machine achieves this through careful ordering, timestamping, and consistency constraints that together form an airtight proof of correct memory behavior.

This component sits between the main execution state machine and the actual memory values, mediating all data flow and generating the constraints necessary for memory correctness proofs.

## Memory Operation Model

### Operation Types

The memory state machine handles several distinct operation categories:

```
Read operations:
  Load word (4 bytes)
  Load halfword (2 bytes, signed/unsigned)
  Load byte (1 byte, signed/unsigned)

  Each read must prove:
    - Address validity
    - Value matches last write
    - Proper sign extension

Write operations:
  Store word (4 bytes)
  Store halfword (2 bytes)
  Store byte (1 byte)

  Each write must prove:
    - Address validity
    - Value properly masked
    - Timestamp advanced

Special operations:
  Initialization (first write to address)
  Register file access (special memory region)
  ROM access (read-only verification)
```

### Memory Regions

The state machine distinguishes between memory regions with different behaviors:

```
Region types:
  RAM: Read-write data memory
  ROM: Read-only program memory
  Registers: Special high-speed storage
  I/O: Input/output buffers

Region constraints:
  Each region may have different:
    - Access permissions
    - Timing models
    - Verification strategies
```

## State Representation

### Per-Operation State

Each memory operation creates state that must be tracked:

```
Operation record:
  Operation type: Read or Write
  Address: Memory location accessed
  Value: Data read or written
  Timestamp: Logical ordering
  Width: Bytes accessed (1, 2, or 4)

Derived values:
  Previous timestamp at address
  Previous value at address (for reads)
  Aligned address (for sub-word access)
```

### Memory Table Structure

The memory state machine maintains a logical table of all operations:

```
Memory trace columns:
  addr: Address being accessed
  val: Value involved in operation
  op: Operation type indicator
  ts: Current timestamp
  prev_ts: Previous timestamp for this address

Ordering requirement:
  Operations sorted by (addr, ts)
  Enables efficient consistency checking
  Same address operations adjacent
```

## Timestamp Mechanism

### Logical Time

Timestamps establish ordering without physical time:

```
Timestamp properties:
  Monotonically increasing globally
  Unique for each operation
  Links reads to corresponding writes

Assignment:
  Each instruction increments timestamp
  Multiple memory ops get distinct stamps
  Ordering reflects program execution
```

### Timestamp Constraints

The proving system verifies timestamp consistency:

```
Ordering constraints:
  For same address:
    ts_current > ts_previous

  For reads:
    prev_ts must match actual previous write

  For writes:
    Updates timestamp for address

Global constraint:
  All timestamps form valid total order
  No gaps in instruction sequencing
```

## Read Verification

### Read Correctness

Proving a read returns the right value:

```
Read proof requires:
  1. Address matches claimed address
  2. Timestamp valid for this instruction
  3. Value equals most recent write value
  4. Previous timestamp identifies that write

Constraint form:
  val_read = val_at_prev_ts
  prev_ts = max(ts : write to addr before current ts)
```

### First Read Handling

Reading uninitialized memory:

```
Initialization model:
  Memory starts with defined initial values
  Often zero-initialized
  Or loaded from program input

First read constraint:
  If prev_ts = 0 (no prior write):
    val_read = initial_value[addr]

  Alternative: require explicit initialization
```

## Write Verification

### Write Correctness

Proving writes update state correctly:

```
Write proof requires:
  1. Address in valid range
  2. Value properly formatted
  3. Timestamp advances correctly
  4. Width-appropriate masking

Constraint form:
  new_val = write_value
  new_ts = current_timestamp
```

### Sub-word Writes

Handling partial updates:

```
Byte store to word-aligned memory:
  addr_aligned = addr & ~3
  byte_offset = addr & 3
  mask = 0xFF << (byte_offset * 8)
  new_word = (old_word & ~mask) | ((value & 0xFF) << (byte_offset * 8))

Halfword store:
  addr_aligned = addr & ~3
  half_offset = (addr >> 1) & 1
  mask = 0xFFFF << (half_offset * 16)
  new_word = (old_word & ~mask) | ((value & 0xFFFF) << (half_offset * 16))
```

## Consistency Argument

### Permutation-Based Consistency

Proving all memory operations are consistent:

```
Approach:
  Two views of memory operations:
    Execution order (as program runs)
    Address order (grouped by location)

  Permutation argument:
    Both views contain same operations
    Just reordered differently
    Proves no fabricated or missing ops
```

### Adjacent Consistency

Checking consecutive operations to same address:

```
When sorted by (addr, ts):
  Adjacent rows with same addr:
    Later read sees earlier write value

  Constraint:
    If addr[i] = addr[i-1]:
      op[i] = READ implies val[i] = val[i-1]

  Address change:
    New address starts fresh sequence
    Prev_ts = 0 for first access
```

## Width Handling

### Multi-Width Operations

Supporting different access sizes:

```
Word operations (4 bytes):
  Access aligned 32-bit value
  No masking needed
  Direct value transfer

Halfword operations (2 bytes):
  Extract 16 bits from word
  Sign extend for signed loads
  Mask for stores

Byte operations (1 byte):
  Extract 8 bits from word
  Sign extend for signed loads
  Mask for stores
```

### Width Decomposition

Breaking operations into aligned accesses:

```
Strategy A - Native width columns:
  Separate columns for each width
  Complex but flexible

Strategy B - Word-based with masking:
  All operations on aligned words
  Masks select/update bytes
  Simpler memory model

Strategy C - Byte-level tracking:
  Track each byte independently
  Most flexible
  Highest overhead
```

## State Machine Transitions

### Operation Processing

State machine flow for memory operations:

```
Input from main SM:
  Operation request (load/store)
  Address
  Value (for stores)
  Width

Processing steps:
  1. Compute aligned address
  2. Look up previous value/timestamp
  3. For loads: return value
  4. For stores: compute new value
  5. Update timestamp
  6. Generate constraints

Output to main SM:
  Value (for loads)
  Completion signal
```

### Pipelining

Handling operation throughput:

```
Constraint generation:
  May lag actual operation
  Batched for efficiency

Parallel operations:
  Independent addresses can proceed
  Same-address operations serialize

Optimization:
  Group same-address accesses
  Reduce lookup overhead
```

## Register File Integration

### Registers as Memory

Treating registers as special memory:

```
Register addresses:
  x0 at address 0 (special: always zero)
  x1-x31 at addresses 1-31
  Separate from data memory

Register constraints:
  Same consistency rules as memory
  But accessed every instruction
  Optimized handling

x0 special case:
  Reads always return 0
  Writes ignored
  Constraint: val = 0 when addr = 0
```

### High-Frequency Access

Optimizing for register access patterns:

```
Every instruction:
  May read two registers (rs1, rs2)
  May write one register (rd)
  3 potential operations

Optimization approaches:
  Dedicated register columns
  Cached recent values
  Reduced lookup overhead
```

## Constraints Summary

### Core Constraints

The memory state machine enforces:

```
1. Timestamp ordering:
   ts[i] > ts[i-1] globally

2. Read-after-write consistency:
   For reads: val = val_at_prev_ts

3. Address validity:
   addr in valid memory range

4. Width correctness:
   Access matches instruction width

5. Permutation validity:
   Execution view = Address view (reordered)
```

### Constraint Degrees

Polynomial degree considerations:

```
Simple constraints (degree 1-2):
  Timestamp increment
  Value equality for same address

Higher degree constraints:
  Width-based masking
  Conditional logic

Optimization:
  Use intermediate columns
  Reduce max constraint degree
  Balance width vs. degree
```

## Interaction with Other Components

### Main State Machine

Primary interface for memory operations:

```
Requests from main SM:
  Memory operation type
  Address and value
  Instruction context

Responses to main SM:
  Loaded values
  Completion status

Constraint linkage:
  Permutation connects views
  Values must match exactly
```

### Data Bus

Communication pathway:

```
Bus operations:
  Memory SM as bus participant
  Sends and receives values
  Tagged with operation info

Bus constraints:
  Memory operations on bus
  Values correctly routed
  No message corruption
```

## Performance Considerations

### Trace Size

Memory operations impact proof size:

```
Factors:
  Number of memory operations
  Columns per operation
  Sorting overhead

Optimization:
  Minimize memory accesses in program
  Batch related accesses
  Efficient encoding
```

### Proving Cost

Computational requirements:

```
Major costs:
  Sorting operations by address
  Computing permutation arguments
  Evaluating consistency constraints

Strategies:
  Parallel processing by address range
  Efficient sorting algorithms
  Optimized polynomial operations
```

## Key Concepts

- **Memory state machine**: Component managing all memory operations with proofs
- **Timestamp ordering**: Logical time establishing operation sequence
- **Read-after-write consistency**: Proving reads return correct values
- **Permutation argument**: Linking execution and address-ordered views
- **Width handling**: Supporting byte, halfword, and word operations

## Design Trade-offs

### Sorting Strategy

| Sort by Address | Sort by Time |
|-----------------|--------------|
| Adjacent consistency easy | Matches execution order |
| Requires permutation | Needs lookup for prev_ts |
| Better for many accesses | Better for few accesses |

### Width Representation

| Native Widths | Word-Based | Byte-Level |
|---------------|------------|------------|
| Complex logic | Masking overhead | Maximum flexibility |
| Fewer constraints | Moderate complexity | Many columns |
| Limited flexibility | Good balance | Highest accuracy |

## Related Topics

- [State Machine Abstraction](01-state-machine-abstraction.md) - General SM concepts
- [Main State Machine](02-main-state-machine.md) - Instruction execution
- [Memory Consistency](../03-memory-model/02-memory-consistency.md) - Consistency model
- [Memory Timestamping](../03-memory-model/04-memory-timestamping.md) - Timestamp details

