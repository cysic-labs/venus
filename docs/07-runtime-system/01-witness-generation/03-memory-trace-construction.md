# Memory Trace Construction

## Overview

Memory trace construction builds the specialized trace that proves memory consistency. While the main execution trace records that memory operations occurred, the memory trace proves that reads return correct values—specifically, the value from the most recent write to each address. This requires sorting operations by address and time, then verifying local consistency between consecutive operations.

The memory trace is typically separate from the main execution trace, connected via permutation arguments. The construction process collects all memory operations, sorts them appropriately, computes consistency-checking columns, and prepares the data for the memory state machine's constraints. This document covers memory trace structure, construction algorithms, and optimization techniques.

## Memory Trace Structure

### Trace Columns

Memory trace layout:

```
Primary columns:
  addr: Memory address
  value: Value read or written
  op_type: 0 = read, 1 = write
  cycle: Execution cycle when operation occurred

Sorted columns:
  sorted_addr: Address in sorted order
  sorted_value: Value in sorted order
  sorted_op_type: Operation type in sorted order
  sorted_cycle: Cycle in sorted order

Auxiliary columns:
  is_first_access: First operation to this address
  addr_changed: Address differs from previous row
  value_unchanged: Value same as previous (for reads)
```

### Row Structure

One row per memory operation:

```
Row content:
  Original (execution order):
    (addr_i, value_i, op_i, cycle_i)

  Sorted (consistency checking):
    (sorted_addr_i, sorted_value_i, sorted_op_i, sorted_cycle_i)

Relationship:
  Sorted trace is permutation of original
  Permutation argument proves equality
```

### Access Granularity

Memory access sizes:

```
Byte-level tracking:
  Each byte address tracked separately
  Finest granularity, most operations

Word-level tracking:
  Track 4-byte (or 8-byte) words
  Byte accesses decomposed
  Fewer operations, more complex

Hybrid:
  Track at word level internally
  Handle byte accesses specially
```

## Construction Algorithm

### Operation Collection

Gathering memory operations:

```
During execution:
  memory_ops = []

  for each instruction:
    if is_load:
      addr = compute_address()
      value = memory[addr]
      memory_ops.append({
        'addr': addr,
        'value': value,
        'op': READ,
        'cycle': current_cycle
      })

    if is_store:
      addr = compute_address()
      value = store_value
      memory_ops.append({
        'addr': addr,
        'value': value,
        'op': WRITE,
        'cycle': current_cycle
      })
```

### Sorting

Ordering for consistency:

```
Sort criteria:
  Primary: Address (ascending)
  Secondary: Cycle (ascending)

sorted_ops = sort(memory_ops, key=lambda op: (op.addr, op.cycle))

Result:
  All operations to same address are consecutive
  Within address, ordered by time
```

### Auxiliary Column Computation

Computing helper values:

```
For i in range(len(sorted_ops)):
  current = sorted_ops[i]
  prev = sorted_ops[i-1] if i > 0 else None

  # Address change detection
  if prev is None or current.addr != prev.addr:
    current.is_first_access = 1
    current.addr_changed = 1
  else:
    current.is_first_access = 0
    current.addr_changed = 0

  # Value consistency (for reads)
  if current.op == READ and not current.is_first_access:
    current.value_unchanged = (current.value == prev.value)
  else:
    current.value_unchanged = 0
```

## Permutation Data

### Tuple Encoding

Encoding for permutation argument:

```
Encoding:
  tuple = addr + r*value + r^2*cycle + r^3*op_type

Where r is random challenge

Original tuples:
  orig[i] = encode(memory_ops[i])

Sorted tuples:
  sort[i] = encode(sorted_ops[i])

Permutation check:
  product(z - orig[i]) = product(z - sort[i])
```

### Accumulator Computation

Running product for permutation:

```
Original accumulator:
  acc_orig[0] = (z - orig[0])
  acc_orig[i] = acc_orig[i-1] * (z - orig[i])

Sorted accumulator:
  acc_sort[0] = (z - sort[0])
  acc_sort[i] = acc_sort[i-1] * (z - sort[i])

Final check:
  acc_orig[n-1] == acc_sort[n-1]
```

## Consistency Checking

### Local Consistency

Checking consecutive operations:

```
For consecutive sorted operations:
  prev = sorted_ops[i-1]
  curr = sorted_ops[i]

  if curr.addr == prev.addr:
    # Same address, check consistency
    if curr.op == READ:
      assert curr.value == prev.value
      # Read returns previous value

    if curr.op == WRITE:
      # Write can set any value
      pass

  else:
    # Different address, no constraint
    pass
```

### First Access Handling

Initial values:

```
First access to address:
  if curr.is_first_access:
    if curr.op == READ:
      # Must read initial value
      curr.value == initial_value(addr)

    if curr.op == WRITE:
      # Can write any value
      pass

Initial values:
  Zero for uninitialized memory
  Preloaded data for initialized segments
```

### Timestamp Ordering

Ensuring correct time order:

```
Within same address:
  curr.cycle > prev.cycle

Constraint:
  if curr.addr == prev.addr:
    assert curr.cycle > prev.cycle
    # Later operations have higher cycle

This ensures we check against most recent write.
```

## Handling Access Sizes

### Byte Access

Single byte operations:

```
Byte load (LB):
  addr = computed_address
  value = memory[addr] (1 byte)
  Record: (addr, value, READ, cycle)

Byte store (SB):
  addr = computed_address
  value = store_value & 0xFF
  Record: (addr, value, WRITE, cycle)
```

### Word Access

Multi-byte operations:

```
Option 1: Expand to bytes
  Word load at addr:
    (addr, byte0, READ, cycle)
    (addr+1, byte1, READ, cycle)
    (addr+2, byte2, READ, cycle)
    (addr+3, byte3, READ, cycle)

Option 2: Track at word level
  Word load at addr (word-aligned):
    (addr, word_value, READ, cycle)

  Byte access: Extract from word or handle specially
```

### Mixed Access Handling

Combining byte and word:

```
Word-level with byte extraction:
  Store word at addr:
    (addr, word, WRITE, cycle)

  Load byte at addr+2:
    (addr, word, READ, cycle)
    Result: (word >> 16) & 0xFF

Constraint:
  Byte value matches word component
```

## Optimization Techniques

### Sparse Memory

Only tracking accessed addresses:

```
Observation:
  Most of address space never accessed
  Only track actual operations

Implementation:
  Hash map: addr -> operations
  No allocation for untouched memory

Memory trace size:
  Proportional to operations, not address space
```

### Incremental Sorting

Sort as operations collected:

```
Maintain sorted structure:
  Balanced tree or sorted list
  Insert each operation in order

Benefits:
  Final sort already done
  Incremental work

Trade-off:
  O(log n) per insert vs O(n log n) final sort
  Better cache behavior with final sort
```

### Parallel Sorting

Multi-threaded sort:

```
Parallel merge sort:
  Divide operations into chunks
  Sort each chunk in parallel
  Merge sorted chunks

Radix sort (if addresses are integers):
  Sort by address bytes
  Highly parallelizable
```

### Memory-Efficient Construction

Reducing peak memory:

```
Streaming construction:
  Write operations to disk during execution
  Sort using external merge sort
  Process sorted data in chunks

Benefits:
  Handles very large traces
  Bounded memory usage

Trade-off:
  Disk I/O overhead
```

## Validation

### Permutation Check

Verifying trace equality:

```
After construction:
  Verify product equality
  Check tuple counts match

Early detection:
  Count operations before and after sort
  Must be equal
```

### Consistency Verification

Pre-proving checks:

```
For each consecutive pair in sorted trace:
  if same address:
    if read: verify value matches previous
    verify cycle strictly increases

For first access:
  if read: verify matches initial value
```

## Key Concepts

- **Memory trace**: Record of all memory operations
- **Sorted trace**: Operations ordered by (address, cycle)
- **Permutation**: Proof that sorted equals original
- **Local consistency**: Checking consecutive operations
- **First access**: Handling initial reads

## Design Considerations

### Trace Separation

| Inline | Separate Trace |
|--------|----------------|
| Memory in main trace | Dedicated memory trace |
| Wider main trace | Narrower main trace |
| Direct access | Cross-trace linking |
| Simpler | More modular |

### Access Granularity

| Byte Level | Word Level |
|------------|------------|
| Fine-grained | Coarse-grained |
| More operations | Fewer operations |
| Simple consistency | Complex byte handling |
| Larger trace | Smaller trace |

## Related Topics

- [Execution Trace Generation](01-execution-trace-generation.md) - Main trace construction
- [Auxiliary Value Computation](02-auxiliary-value-computation.md) - Helper columns
- [Memory Consistency](../../04-zkvm-architecture/03-memory-system/02-memory-consistency.md) - Consistency mechanism
- [Read-Write Memory](../../04-zkvm-architecture/03-memory-system/04-read-write-memory.md) - RAM machine
