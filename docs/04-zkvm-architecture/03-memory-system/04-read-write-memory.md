# Read-Write Memory (RAM)

## Overview

Read-write memory (RAM) is the general-purpose memory system that supports both load and store operations. Unlike read-only memory (ROM) which holds fixed program code, RAM stores dynamic data that changes during execution: local variables, heap allocations, stack frames, and data structures. Proving RAM correctness requires demonstrating that every read returns the value from the most recent write to that address.

The RAM implementation combines the sorted memory approach with careful handling of initial values, memory sizes, and access patterns. This document covers the complete RAM implementation, from witness generation through constraint construction, including practical optimizations for efficient proving.

## RAM Model

### RAM Operations

Supported operations:

```
Read (Load):
  Input: address
  Output: value at address
  Effect: None on memory state

Write (Store):
  Input: address, value
  Output: None
  Effect: Updates memory at address

Operation encoding:
  op_type = 0: Read
  op_type = 1: Write
```

### RAM State

Conceptual memory state:

```
Memory as function:
  mem: Address -> Value

Initial state:
  mem_0(addr) = initial_value(addr)
  Often: initial_value(addr) = 0

After operations:
  mem_t = apply(mem_{t-1}, op_t)

Where apply:
  If op_t is write(addr, val): mem_t(addr) = val
  If op_t is read(addr): mem_t = mem_{t-1} (unchanged)
```

### Memory Regions

RAM segments:

```
Stack:
  Grows downward from high addresses
  Function call frames
  Local variables

Heap:
  Grows upward from lower addresses
  Dynamic allocations
  Global data

Each region may have:
  Base address
  Size limit
  Access permissions
```

## RAM Machine Structure

### Column Layout

RAM-specific columns:

```
Access columns:
  ram_addr: Memory address accessed
  ram_value: Value read or written
  ram_op: Operation type (0=read, 1=write)
  ram_time: Timestamp (cycle number)

Sorted columns:
  sorted_addr: Address in sorted order
  sorted_value: Value in sorted order
  sorted_op: Operation in sorted order
  sorted_time: Timestamp in sorted order

Control columns:
  is_ram_op: Row has RAM operation
  is_first_at_addr: First access to this address
  addr_unchanged: Same address as previous row

Accumulator columns:
  perm_num: Permutation numerator product
  perm_den: Permutation denominator product
```

### Witness Generation

Populating RAM columns:

```
During execution:
  For each memory operation:
    ram_trace.append({
      addr: op.address,
      value: op.value,
      op: op.type,
      time: current_cycle
    })

After execution:
  sorted_trace = sort(ram_trace, key=(addr, time))

  For each entry in sorted_trace:
    Populate sorted columns
    Compute is_first_at_addr, addr_unchanged
```

## Constraint Construction

### Sorting Constraints

Proving correct sort order:

```
Address non-decreasing:
  For each row i > 0:
    sorted_addr[i] >= sorted_addr[i-1]

Time ordering within address:
  addr_unchanged = (sorted_addr[i] == sorted_addr[i-1])
  addr_unchanged * (sorted_time[i] > sorted_time[i-1]) = addr_unchanged

Alternative (with helper):
  addr_diff = sorted_addr[i] - sorted_addr[i-1]
  time_diff = sorted_time[i] - sorted_time[i-1]

  addr_diff >= 0
  (addr_diff == 0) implies (time_diff > 0)
```

### Read Consistency

Reads return previous value:

```
For consecutive sorted rows:
  is_read = (sorted_op[i] == 0)
  prev_same_addr = (sorted_addr[i] == sorted_addr[i-1])

Constraint:
  prev_same_addr * is_read * (sorted_value[i] - sorted_value[i-1]) = 0

Meaning:
  If reading from same address as previous row,
  value must match previous value.
```

### Initial Value Handling

First access to an address:

```
is_first = (sorted_addr[i] != sorted_addr[i-1]) OR (i == 0)

For first reads:
  is_first * is_read * (sorted_value[i] - initial_value) = 0

Where initial_value:
  = 0 (zero-initialized memory)
  = lookup(sorted_addr[i]) (preloaded data)
```

### Permutation Constraints

Proving sorted equals original:

```
Random challenges: r, gamma

Tuple encoding:
  orig_tuple = ram_addr + r*ram_value + r^2*ram_time + r^3*ram_op
  sort_tuple = sorted_addr + r*sorted_value + r^2*sorted_time + r^3*sorted_op

Running products:
  perm_num[0] = is_ram_op[0] * (orig_tuple[0] + gamma) + (1 - is_ram_op[0])
  perm_num[i] = perm_num[i-1] * (is_ram_op[i] * (orig_tuple[i] + gamma) + (1 - is_ram_op[i]))

  perm_den[0] = (sort_tuple[0] + gamma)
  perm_den[i] = perm_den[i-1] * (sort_tuple[i] + gamma)

Final check:
  perm_num[n-1] = perm_den[m-1]  // n = main trace, m = sorted trace

If some rows don't have RAM ops:
  Use is_ram_op selector to skip
```

## Initial Memory

### Zero Initialization

Default approach:

```
Memory starts as all zeros:
  initial_value(addr) = 0 for all addr

First read to any address returns 0.

Simple constraint:
  is_first_read * sorted_value = 0
```

### Preloaded Data

Program data in memory:

```
Initial memory table:
  {(addr_0, val_0), (addr_1, val_1), ...}

For first read to addr:
  If addr in initial_table:
    value = initial_table[addr]
  Else:
    value = 0

Implementation:
  Lookup to initial memory table
  Default to 0 if not found
```

### Initialization Trace

Alternative approach:

```
Treat preloaded data as writes at t=0:
  For each (addr, val) in initial_data:
    Insert (addr, val, WRITE, 0) into RAM trace

Regular consistency then handles everything.

Downside:
  Larger RAM trace
  More sorting
```

## Optimization Techniques

### Memory Paging

Reduce sorting scope:

```
Divide address space into pages:
  page_num = addr >> PAGE_BITS
  page_offset = addr & PAGE_MASK

Separate sorting per page:
  Only sort accesses within each page
  Reduces sort cost when locality is good

Cross-page consistency:
  Each page independently consistent
  Pages don't affect each other
```

### Sparse Memory

Handle large address spaces:

```
Only track accessed addresses:
  Don't materialize full memory

Sparse representation:
  Map of addr -> value
  Only entries for written addresses

Sorting only includes accessed addresses.
```

### Access Coalescing

Combine adjacent accesses:

```
Multiple byte accesses to same word:
  lb 0x1000, lb 0x1001, lb 0x1002, lb 0x1003

Coalesce to single word access:
  lw 0x1000, then extract bytes

Reduces number of RAM operations.
```

### Read Caching

Skip redundant read tracking:

```
If reading same address as recent read:
  Value known, no RAM machine needed

Prover optimization:
  Cache recent reads
  Use cached value if available
  Still must prove consistency
```

## Integration Points

### Main Machine Connection

Linking execution to RAM:

```
Main machine columns:
  mem_op_active: Is this a memory operation?
  mem_addr: Address being accessed
  mem_value: Value read or written
  mem_is_write: Is this a write?
  mem_cycle: Current cycle

RAM machine receives:
  Via permutation from main machine
  Only active memory operations
```

### Memory Size Enforcement

Bounds checking:

```
Valid address range:
  MEM_START <= addr < MEM_END

Constraint:
  is_ram_op * (ram_addr >= MEM_START) = is_ram_op
  is_ram_op * (ram_addr < MEM_END) = is_ram_op

Or via range check:
  ram_addr - MEM_START in [0, MEM_SIZE)
```

## Key Concepts

- **RAM**: Read-write memory supporting loads and stores
- **Sorted trace**: RAM operations sorted by (address, time)
- **Read consistency**: Reads return most recent write value
- **Initial value**: Value before first write (often zero)
- **Permutation**: Proving sorted equals original

## Design Considerations

### Trace Size

| Compact RAM Trace | Inline RAM |
|-------------------|------------|
| Only memory ops | All cycles |
| Separate machine | Integrated |
| Smaller sort | Larger sort |
| More connections | Simpler |

### Initialization

| Zero Init | Preloaded |
|-----------|-----------|
| Simple constraint | Lookup table |
| No setup data | Requires initial data |
| Slower for loaded data | Faster for loaded data |

## Related Topics

- [Memory Architecture](01-memory-architecture.md) - Overall design
- [Memory Consistency](02-memory-consistency.md) - Consistency mechanism
- [Range Checking](03-range-checking.md) - Address bounds
- [Main State Machine](../02-state-machine-design/02-main-state-machine.md) - Integration
