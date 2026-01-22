# Memory Consistency

## Overview

Memory consistency is the property that every memory read returns the value from the most recent write to that address. In a zkVM, this must be proven cryptographically without access to the actual memory hardware. The consistency mechanism transforms the dynamic memory access pattern into static polynomial constraints that can be verified through the proof system.

The consistency proof works by showing that the execution's memory operations, when sorted by address and time, form a sequence where reads and writes alternate correctly. This sorted view enables local checking: each read can be verified against its immediately preceding write in the sorted order, rather than searching the entire trace for the matching write.

This document details the consistency mechanism, constraint construction, and edge cases in memory consistency proving.

## Consistency Model

### Sequential Consistency

Memory access ordering:

```
Within a single address:
  Operations ordered by timestamp (cycle number)
  Each read sees the most recent write
  No concurrent access (single-threaded execution)

Across addresses:
  Operations to different addresses are independent
  No cross-address ordering requirements

This matches RISC-V memory model for single-hart execution.
```

### Consistency Invariants

Properties that must hold:

```
Invariant 1: Write persistence
  Once written, value persists until overwritten
  read(a, t) returns write(a, t') where t' < t and
  no write(a, t'') exists with t' < t'' < t

Invariant 2: Read agreement
  All reads between writes return same value
  read(a, t1) = read(a, t2) if no write between them

Invariant 3: Initial values
  First read to address returns initial value
  Usually zero or preloaded data
```

### Formal Definition

Memory consistency property:

```
For any read R of address A at time T:
  Let W = most recent write to A before T
  If W exists: R.value = W.value
  If no W: R.value = initial_value(A)

"Most recent" means:
  W.timestamp < T and
  no W' with W.timestamp < W'.timestamp < T
```

## Sorted Memory Proof

### Sorting Procedure

Converting execution order to address order:

```
Input: Memory trace in execution order
  [(addr_0, val_0, op_0, time_0),
   (addr_1, val_1, op_1, time_1),
   ...]

Sort by:
  Primary: address (ascending)
  Secondary: timestamp (ascending)

Output: Memory trace in sorted order
  [(sorted_addr_0, sorted_val_0, sorted_op_0, sorted_time_0),
   ...]

Key insight: In sorted order, all ops to same address
are consecutive and time-ordered.
```

### Local Consistency Checking

Checking consecutive sorted entries:

```
Given consecutive entries in sorted trace:
  Entry i-1: (addr_{i-1}, val_{i-1}, op_{i-1}, time_{i-1})
  Entry i:   (addr_i, val_i, op_i, time_i)

Case 1: Different addresses (addr_i != addr_{i-1})
  No constraint between them
  Entry i is first access to new address

Case 2: Same address (addr_i == addr_{i-1})
  time_i > time_{i-1} (later in execution)

  If entry i is a READ:
    val_i = val_{i-1}
    (reads previous value, whether write or read)

  If entry i is a WRITE:
    val_i can be anything (new write)
```

### Permutation Proof

Proving sorted equals original:

```
Claim: Sorted trace is permutation of original trace

Method: Random linear combination product

Define tuples:
  orig_i = addr_i + r*val_i + r^2*time_i + r^3*op_i
  sort_i = sorted_addr_i + r*sorted_val_i + ...

where r is random challenge from verifier

Grand product argument:
  Z_0 = 1
  Z_i = Z_{i-1} * (orig_i + gamma) / (sort_i + gamma)
  Z_n = 1

If products cancel, multisets are equal.
```

## Constraint Construction

### Sorting Constraints

Ensuring sorted trace is correctly ordered:

```
Address ordering:
  sorted_addr[i] >= sorted_addr[i-1]

Within same address, time ordering:
  addr_same = (sorted_addr[i] == sorted_addr[i-1])
  addr_same * (sorted_time[i] - sorted_time[i-1] - 1) >= 0
  // time strictly increases when address same
```

### Value Consistency Constraints

Ensuring reads return correct values:

```
For consecutive sorted entries:

is_read = (sorted_op[i] == READ)
addr_same = (sorted_addr[i] == sorted_addr[i-1])

// Read must match previous value when same address
addr_same * is_read * (sorted_val[i] - sorted_val[i-1]) = 0
```

### First Access Constraints

Handling first access to an address:

```
is_first_access = (sorted_addr[i] != sorted_addr[i-1])
  OR i == 0

If first access is read:
  is_first_access * is_read * (sorted_val[i] - initial_val) = 0

Initial value options:
  - Zero (default)
  - From preloaded data (lookup to initial memory table)
  - From ROM (for code segment)
```

### Permutation Accumulator

Running product for permutation:

```
Columns:
  perm_acc: Permutation accumulator

Constraints:
  perm_acc[0] = (orig_tuple[0] + gamma) / (sort_tuple[0] + gamma)
  perm_acc[i] = perm_acc[i-1] * (orig_tuple[i] + gamma) / (sort_tuple[i] + gamma)
  perm_acc[n-1] = 1

Alternative (avoid division):
  Use running products for numerator and denominator separately
  Check equality at end
```

## Edge Cases

### Empty Memory

No memory accesses:

```
If program doesn't access memory:
  Memory trace is empty
  Consistency trivially holds
  No permutation argument needed
```

### Single Access

Only one memory operation:

```
Single operation at address A:
  If read: value = initial_value(A)
  If write: any value allowed

Sorted trace has one entry
No local comparison possible
Initial value constraint applies if read
```

### Repeated Writes

Multiple writes without reads:

```
write(A, 10, t=1)
write(A, 20, t=5)
write(A, 30, t=10)

All legal, sorted trace:
  (A, 10, W, 1)
  (A, 20, W, 5)
  (A, 30, W, 10)

No consistency constraint between writes.
Values can differ freely.
```

### Aliasing

Same memory, different representations:

```
If addresses can alias:
  word access vs. byte access
  Must track at finest granularity

Example:
  sw 0x1000, 0x12345678  // Write word
  lb 0x1001              // Read byte

Must decompose word write into byte effects.
```

## Implementation Patterns

### Separate Memory Trace

Memory ops in own trace:

```
Main trace: Execution without memory details
Memory trace: Only memory operations

Connection:
  Permutation: Main memory columns = Memory trace entries

Benefits:
  Memory trace can be shorter
  Specialized memory constraints
  Different padding strategies
```

### Inline Memory

Memory in main trace:

```
Main trace includes:
  mem_addr, mem_val, mem_op, mem_time columns

No separate memory trace
Sorting done on main trace subset

Benefits:
  Simpler architecture
  No cross-trace permutation

Drawback:
  Larger main trace
  Many unused memory columns for non-memory ops
```

### Batched Sorting

Sort in chunks:

```
Divide memory ops into chunks
Sort each chunk independently
Merge sorted chunks

Benefits:
  Parallelizable
  Better cache locality

Constraint adjustment needed for chunk boundaries.
```

## Key Concepts

- **Consistency**: Reads return most recent write value
- **Sorted memory**: Reordering for local checking
- **Permutation argument**: Proving equality of multisets
- **Local checking**: Comparing consecutive sorted entries
- **Initial value**: Value before first write

## Design Considerations

### Trace Size

| Compact Trace | Full Trace |
|---------------|------------|
| Only memory ops | All cycles |
| Smaller sort | Larger sort |
| Cross-trace linking | Single trace |
| More complex | Simpler |

### Sorting Cost

| Prover Sorting | Constraint Sorting |
|----------------|-------------------|
| Prover sorts witness | Constraints verify sort |
| O(n log n) work | O(n) constraints |
| Standard approach | Some schemes prove sort |

## Related Topics

- [Memory Architecture](01-memory-architecture.md) - Overall memory design
- [Range Checking](03-range-checking.md) - Address validation
- [Read-Write Memory](04-read-write-memory.md) - RAM details
- [Lookup Arguments](../../03-proof-management/02-component-system/02-lookup-arguments.md) - Permutation mechanics
