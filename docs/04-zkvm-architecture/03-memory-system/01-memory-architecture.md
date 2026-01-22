# Memory Architecture

## Overview

The memory architecture defines how the zkVM handles memory operations, ensuring that loads and stores behave correctly while generating constraints that can be efficiently verified. Memory presents unique challenges for zkVMs: unlike registers which are explicit columns, memory is a large, sparsely-accessed space where consistency must be proven without materializing the entire memory state in the trace.

The key insight is that memory correctness can be verified by proving that the sequence of memory operations is internally consistent, rather than by tracking the full memory state. This is achieved through permutation and lookup arguments that connect memory accesses across the trace, ensuring every read returns the value from the most recent write to that address.

This document covers memory system design, consistency mechanisms, and optimization strategies for efficient memory proving.

## Memory Model

### Address Space

zkVM memory organization:

```
Address space:
  32-bit or 64-bit addresses
  Byte-addressable
  Segmented into regions

Memory regions:
  Code segment: Read-only program instructions
  Data segment: Initialized data
  Heap: Dynamic allocation
  Stack: Function call frames
  I/O region: External communication

Address layout (example):
  0x00000000 - 0x0FFFFFFF: Code (256 MB)
  0x10000000 - 0x7FFFFFFF: Data/Heap
  0x80000000 - 0xBFFFFFFF: Stack
  0xC0000000 - 0xFFFFFFFF: I/O
```

### Access Granularity

Supported access sizes:

```
Byte (8 bits): lb, lbu, sb
Halfword (16 bits): lh, lhu, sh
Word (32 bits): lw, lwu, sw
Doubleword (64 bits): ld, sd (RV64)

Alignment requirements:
  Natural alignment preferred
  Misaligned access may require multiple operations
```

### Memory Operations

Types of memory access:

```
Read (load):
  value = memory[address]
  Must return most recent write

Write (store):
  memory[address] = value
  Overwrites previous value

Initial read:
  First read before any write
  Returns initial value (e.g., zero or loaded data)
```

## Consistency Mechanism

### The Consistency Problem

Why memory is hard for zkVMs:

```
Challenge:
  Memory accesses occur in arbitrary order
  Read at cycle 100 may need write from cycle 5
  Can't track full memory state each cycle

Example:
  Cycle 5:  write(0x1000, 42)
  Cycle 20: write(0x2000, 17)
  Cycle 35: read(0x1000) -> must return 42
  Cycle 50: write(0x1000, 99)
  Cycle 60: read(0x1000) -> must return 99

Must prove reads return correct values without
storing entire memory state per cycle.
```

### Sorted Memory Approach

Reorder operations for consistency checking:

```
Original trace (by time):
  (cycle=5,  addr=0x1000, op=W, val=42)
  (cycle=20, addr=0x2000, op=W, val=17)
  (cycle=35, addr=0x1000, op=R, val=42)
  (cycle=50, addr=0x1000, op=W, val=99)
  (cycle=60, addr=0x1000, op=R, val=99)

Sorted trace (by address, then time):
  (cycle=5,  addr=0x1000, op=W, val=42)
  (cycle=35, addr=0x1000, op=R, val=42)  <- same value as previous
  (cycle=50, addr=0x1000, op=W, val=99)
  (cycle=60, addr=0x1000, op=R, val=99)  <- same value as previous
  (cycle=20, addr=0x2000, op=W, val=17)

In sorted order, consecutive ops to same address
can be checked locally.
```

### Permutation Argument

Proving sorted = original:

```
Claim:
  Sorted trace is permutation of original trace

Proof:
  Use grand product argument
  Random linear combination of columns

For each row i:
  orig_tuple_i = addr + r*val + r^2*cycle + r^3*op_type
  sort_tuple_i = sorted_addr + r*sorted_val + ...

Grand products:
  prod_i (z - orig_tuple_i) = prod_i (z - sort_tuple_i)

If products equal, multisets are equal.
```

### Consistency Constraints

Checking sorted trace:

```
For consecutive rows in sorted trace:

Same address case:
  If addr[i] == addr[i-1]:
    If op[i-1] == WRITE or op[i] == READ:
      val[i] == val[i-1]  // Read gets previous value

Different address case:
  If addr[i] != addr[i-1]:
    No value constraint (different memory location)

First access to address:
  If first access is READ:
    Value must be initial value (e.g., zero)
  OR value comes from preloaded data
```

## Memory Machine Structure

### Column Layout

Memory machine columns:

```
Access columns:
  addr: Memory address
  value: Value read or written
  op_type: Read (0) or Write (1)
  timestamp: Cycle number of access

Sorted columns:
  sorted_addr: Address in sorted order
  sorted_value: Value in sorted order
  sorted_timestamp: Timestamp in sorted order
  sorted_op_type: Operation in sorted order

Auxiliary columns:
  addr_changed: 1 if addr differs from previous row
  is_first_access: 1 if first access to this address
  perm_acc: Permutation accumulator
```

### Operation Recording

Main machine records memory ops:

```
For load instruction:
  mem_addr = rs1_value + immediate
  mem_value = <value to be loaded>
  mem_op_type = READ
  mem_timestamp = current_cycle

For store instruction:
  mem_addr = rs1_value + immediate
  mem_value = rs2_value
  mem_op_type = WRITE
  mem_timestamp = current_cycle

These columns feed into memory machine.
```

### Sorting Verification

Proving correct sort order:

```
Constraints for sorted trace:

// Address non-decreasing
(sorted_addr[i] >= sorted_addr[i-1])

// When address same, timestamp non-decreasing
(sorted_addr[i] == sorted_addr[i-1]) implies
  (sorted_timestamp[i] >= sorted_timestamp[i-1])

Helper columns:
  addr_unchanged = (sorted_addr[i] == sorted_addr[i-1])
  addr_lt = (sorted_addr[i] > sorted_addr[i-1])

Constraints:
  addr_unchanged + addr_lt = 1  // One must be true
  addr_unchanged * (sorted_timestamp[i] >= sorted_timestamp[i-1]) = addr_unchanged
```

## Memory Types

### Read-Only Memory (ROM)

For program code:

```
Properties:
  Contents fixed at setup time
  Only read operations
  Address -> value is deterministic

Implementation:
  Table of (address, value) pairs
  Lookup argument for reads
  No write handling needed

Simpler than read-write memory.
```

### Read-Write Memory (RAM)

General-purpose memory:

```
Properties:
  Initially zero (or preloaded)
  Read and write operations
  Value changes over time

Implementation:
  Full sorted memory approach
  Permutation + consistency constraints
  Most complex memory type
```

### Initial Memory

Handling preloaded data:

```
Program data, initialized variables:
  Preloaded into memory before execution
  First read returns preloaded value

Implementation options:
  1. Treat as writes at timestamp 0
  2. Separate initial memory table
  3. Include in program ROM
```

## Optimization Techniques

### Memory Paging

Divide memory into pages:

```
Page size: 4KB (typical)
Page number: addr >> 12
Page offset: addr & 0xFFF

Benefits:
  Only track accessed pages
  Smaller sorted memory trace
  Locality exploitation
```

### Access Batching

Group memory accesses:

```
Instead of per-cycle memory columns:
  Batch multiple accesses
  Reduce memory trace rows

Example:
  Main trace row may have 0-2 memory ops
  Memory trace has one row per op
  Separate traces linked by permutation
```

### Merkle Tree Memory

For very large memory:

```
Memory as Merkle tree:
  Each leaf is memory page
  Root commits to entire memory

Read proof:
  Path from leaf to root
  Proves value at address

Write proof:
  Old path, new path
  Proves valid update

Trade-off: More constraints per access
Benefit: Sublinear in memory size
```

### Memory Segmentation

Separate handling by region:

```
Code memory (ROM):
  Read-only, simpler constraints
  Separate lookup table

Stack memory:
  Sequential access pattern
  Optimized for push/pop

Heap memory:
  Random access
  Full memory machine treatment
```

## Key Concepts

- **Memory consistency**: Reads return correct values
- **Sorted memory**: Reordering for local checking
- **Permutation argument**: Proving sorted = original
- **Timestamp**: Ordering operations in time
- **Memory machine**: State machine for memory ops

## Design Considerations

### Trace Overhead

| Full Memory Trace | Sparse Memory |
|-------------------|---------------|
| Row per access | Row per unique access |
| Simple constraints | Complex tracking |
| More proving work | Less proving work |
| Works for all patterns | Exploits locality |

### Memory Size

| Bounded Memory | Large Memory |
|----------------|--------------|
| Fixed address space | Arbitrary size |
| Simple implementation | Merkle tree needed |
| Enough for most programs | Needed for large data |

## Related Topics

- [Memory Consistency](02-memory-consistency.md) - Consistency details
- [Range Checking](03-range-checking.md) - Address validation
- [Read-Write Memory](04-read-write-memory.md) - RAM implementation
- [Main State Machine](../02-state-machine-design/02-main-state-machine.md) - Memory integration
