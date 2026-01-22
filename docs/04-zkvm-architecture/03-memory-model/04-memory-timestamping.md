# Memory Timestamping

## Overview

Memory timestamping assigns logical time values to memory operations, enabling the zkVM to prove that reads return values from the correct prior writes. Without timestamps, there would be no way to establish which write should supply the value for a given read. Timestamps create a total ordering of all memory operations, making it possible to identify the most recent write to any address at any point in execution.

The timestamp mechanism is fundamental to memory consistency proofs. By sorting operations by (address, timestamp), the zkVM can verify consistency through local checks between adjacent entries. This transforms a global problem (finding the most recent write anywhere in execution) into a local one (checking the immediately preceding entry for the same address).

This document explains how timestamps are assigned, how they enable consistency verification, and the constraints that govern their behavior.

## Timestamp Fundamentals

### Logical Time

Timestamps represent logical, not physical, time:

```
Properties:
  Monotonically increasing
  Unique for each operation
  Sequential through execution

Assignment:
  First instruction: t = 1
  Second instruction: t = 2
  ...continues...

Physical time irrelevant:
  Execution may pause, resume
  Timestamps still sequential
  Order is what matters
```

### Timestamp as Ordering

Using timestamps to sequence operations:

```
Total ordering:
  All operations can be compared by timestamp
  t1 < t2 means op1 happened before op2

Per-address ordering:
  Operations to same address also ordered
  Enables finding "most recent write"

Constraint basis:
  Timestamps enable consistency checks
  Later reads see earlier writes
```

## Timestamp Assignment

### Per-Instruction Timestamps

Each instruction gets a timestamp:

```
Simple model:
  One timestamp per instruction
  Instruction count = timestamp

Example:
  Instruction 1: t = 1
  Instruction 2: t = 2
  Instruction 3: t = 3
  ...

Memory operations inherit:
  Load at instruction 5: t = 5
  Store at instruction 7: t = 7
```

### Multiple Operations Per Instruction

When one instruction has multiple memory operations:

```
Scenario:
  Some instructions access memory twice
  E.g., load-modify-store patterns
  Or register reads + memory access

Solutions:
  A) Sub-timestamps: 5.1, 5.2, 5.3
  B) Separate counters per operation type
  C) Expand to multiple trace rows

Common approach:
  Memory counter separate from instruction counter
  Each memory op gets unique memory timestamp
```

### Timestamp Counter

Maintaining the timestamp:

```
Counter state:
  ts_current: Current timestamp value

Increment rule:
  After each memory operation:
    ts_current := ts_current + 1

Constraint:
  ts[i] = ts[i-1] + 1 (for memory ops)
  Or: ts strictly increasing
```

## Timestamp in Memory Operations

### Read Operations

Timestamps for loads:

```
Read record:
  address: Location being read
  value: Data returned
  timestamp: When read occurs
  previous_timestamp: When value was written

Constraint:
  value = value at previous_timestamp
  No write to address between previous_timestamp and timestamp
```

### Write Operations

Timestamps for stores:

```
Write record:
  address: Location being written
  value: Data being stored
  timestamp: When write occurs

Effect:
  Establishes new value at address
  Future reads (higher timestamps) see this value
```

### Previous Timestamp

Linking reads to writes:

```
prev_ts field:
  For each read, identifies the write it reads from
  Value: timestamp of that write

Requirement:
  prev_ts < current_ts
  No write to address between prev_ts and current_ts

Verification:
  Sorting by (address, timestamp) enables checking
```

## Sorted Order Verification

### Sorting by Address and Time

Organizing operations for verification:

```
Sort key: (address, timestamp)

Primary: address (ascending)
Secondary: timestamp (ascending)

Result:
  Same-address operations grouped
  Within group, chronological order
```

### Adjacent Pair Checking

Verifying consistency between neighbors:

```
For sorted rows i and i+1:

Case 1: Same address
  addr[i] = addr[i+1]
  ts[i+1] > ts[i]  (time progresses)

  If op[i+1] is READ:
    val[i+1] = val[i]  (reads previous value)

  If op[i+1] is WRITE:
    val[i+1] can differ (new value written)

Case 2: Different address
  addr[i] < addr[i+1]
  First access to new address
```

### First Access Handling

Initial access to an address:

```
Detection:
  addr[i] != addr[i-1] in sorted order
  This is first access to addr[i]

Constraint:
  If op[i] is READ:
    val[i] = initial_value[addr[i]]
  If op[i] is WRITE:
    val[i] = written value (no constraint from prev)
```

## Permutation Linking

### Two Views of Operations

Connecting execution and sorted orders:

```
Execution order:
  Operations as they occur
  Timestamps naturally sequential

Sorted order:
  Same operations, different arrangement
  Grouped by address, then time

Both views:
  Contain identical (addr, val, ts, op) tuples
  Just in different sequences
```

### Permutation Argument Construction

Proving the reordering is valid:

```
Accumulator method:
  challenge: random field element (Fiat-Shamir)

  acc_exec[0] = 1
  acc_exec[i] = acc_exec[i-1] * (challenge - encode(row_i))

  acc_sort[0] = 1
  acc_sort[i] = acc_sort[i-1] * (challenge - encode(row_i))

  Final: acc_exec[n] = acc_sort[n]

This proves both contain same multiset of operations
```

### Encoding Operations

How operations become field elements:

```
Encoding:
  encode(addr, val, ts, op) =
    addr * a1 + val * a2 + ts * a3 + op * a4

Where a1, a2, a3, a4 are distinct powers of challenge

Uniqueness:
  Distinct operations give distinct encodings
  With overwhelming probability
```

## Timestamp Constraints

### Ordering Constraint

Timestamps must increase:

```
Global ordering:
  In execution order: ts[i+1] = ts[i] + 1
  (Or: ts[i+1] > ts[i] if gaps allowed)

Constraint formulation:
  delta = ts[i+1] - ts[i]
  delta > 0
  (Or: delta = 1 for strict increment)
```

### Sorted Order Timestamp Constraint

Within same address group:

```
Constraint:
  If addr[i] = addr[i+1]:
    ts[i+1] > ts[i]

Implementation:
  is_same_addr * (ts[i+1] - ts[i] - diff) = 0
  diff > 0 (range-checked)
```

### Range Constraints

Bounding timestamp values:

```
Range:
  0 < ts <= max_instructions

Proof:
  ts fits in required bit width
  E.g., ts < 2^32 for up to 4B instructions

Implementation:
  Range check on ts
  Or: natural bound from counter
```

## Handling Previous Timestamp

### Storing prev_ts

Each read tracks its source write:

```
Column:
  prev_ts: Timestamp of write being read

Constraint (in sorted order):
  For reads: prev_ts = ts of previous row (if same address)
  For first access: prev_ts = 0 (initial)
```

### Verifying prev_ts Correctness

Ensuring prev_ts is accurate:

```
In sorted order:
  Adjacent same-address check gives:
    If current is read, prev value matches

This implicitly verifies prev_ts:
  Sorted by (addr, ts)
  Previous same-address row is at prev_ts
```

### Optimizing prev_ts

Reducing overhead:

```
Observation:
  In sorted order, prev_ts is implied
  Don't need to store explicitly

Approach:
  Derive prev_ts from sorted structure
  Only check value consistency

Result:
  Fewer columns needed
  Same security guarantees
```

## Multi-Region Timestamps

### Global vs Per-Region Timestamps

Timestamp scope options:

```
Global timestamps:
  Single counter for all memory
  Total ordering across regions
  Simple but coarse

Per-region timestamps:
  Separate counter per region
  Region-local ordering only
  Finer grained
```

### Consistency Across Regions

When operations span regions:

```
With global timestamps:
  Ordering natural across regions

With per-region timestamps:
  May need cross-region ordering
  Or: regions truly independent

Choice depends on:
  Memory model requirements
  Complexity trade-offs
```

## Initial Timestamps

### Program Start

Timestamps at beginning:

```
Before first instruction:
  ts = 0 (or minimal value)

Initial memory state:
  Considered to have ts = 0
  First reads see values from ts = 0

Constraint:
  All prev_ts for initial reads = 0
```

### Resets and Segments

If execution has segments:

```
Segment boundaries:
  May reset timestamp within segment
  Or: continue from previous segment

Segment-local timestamps:
  Each segment starts at t = 1
  No ordering across segments

Global timestamps:
  Segments have non-overlapping ranges
  Segment 1: t in [1, N1]
  Segment 2: t in [N1+1, N2]
```

## Performance Considerations

### Timestamp Width

Bits needed for timestamps:

```
Typical:
  32-bit timestamps: 4B instructions
  64-bit timestamps: 16 exaops

Trade-off:
  Wider: more instructions supported
  Narrower: smaller constraints

Choice:
  Usually 32 bits sufficient
  Matches instruction count limits
```

### Constraint Complexity

Cost of timestamp constraints:

```
Per-operation costs:
  Increment check: low degree
  Range check: may need decomposition
  Ordering: comparison constraint

Optimization:
  Batch range checks
  Use efficient comparisons
  Minimize per-row overhead
```

## Security Properties

### Ordering Integrity

What timestamps guarantee:

```
No reordering attacks:
  Cannot claim read happened before write
  Timestamps prove temporal relationship

No skipping:
  Cannot omit operations
  Gap in timestamps detectable
  (If strict increment required)
```

### Consistency Guarantee

How timestamps enable consistency:

```
Property:
  Read returns value from prev_ts
  prev_ts is most recent write

Proof:
  Sorted order shows all same-address ops
  Adjacent check verifies values
  Permutation ensures completeness
```

## Key Concepts

- **Logical timestamp**: Ordering value for memory operations
- **Monotonic increment**: Timestamps always increase
- **Previous timestamp**: Links reads to source writes
- **Sorted order**: Operations arranged by (address, timestamp)
- **Permutation argument**: Proves execution and sorted views match

## Design Trade-offs

### Increment Strategy

| Strict Increment | Loose Ordering |
|------------------|----------------|
| Detects gaps | More flexibility |
| Simpler checking | Complex verification |
| Higher constraint | Lower constraint |

### Timestamp Scope

| Global Timestamp | Per-Region Timestamp |
|------------------|---------------------|
| Total ordering | Regional ordering |
| Simple model | Complex composition |
| Cross-region easy | Cross-region hard |

## Related Topics

- [Memory Consistency](02-memory-consistency.md) - Overall consistency model
- [Memory Layout](01-memory-layout.md) - Address space organization
- [Aligned Access](03-aligned-access.md) - Access requirements
- [Memory State Machine](../02-state-machine-design/05-memory-state-machine.md) - Memory operations

