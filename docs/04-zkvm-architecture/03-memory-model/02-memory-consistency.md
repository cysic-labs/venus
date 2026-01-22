# Memory Consistency

## Overview

Memory consistency in a zkVM ensures that every memory read returns the value written by the most recent write to that address. While this property is trivially guaranteed in physical hardware, in zero-knowledge proofs it must be explicitly verified through constraints. The prover could otherwise claim arbitrary values for memory reads, breaking the correctness of the computation.

The memory consistency model defines how the zkVM tracks memory state across instruction executions and proves that reads and writes interact correctly. This involves ordering all memory operations, linking reads to their corresponding writes, and verifying that no operation is fabricated or omitted.

A robust consistency model is fundamental to zkVM correctness. Without it, a malicious prover could execute a completely different program by claiming incorrect memory values at crucial points.

## Consistency Requirements

### Read-After-Write

The fundamental consistency property:

```
Property:
  A read at address A returns the value
  from the most recent write to address A

Formal statement:
  read(A, t) = value where:
    value was written by write(A, v, t')
    t' < t
    No write to A between t' and t

Initial values:
  First read before any write
  Returns initialized value (often 0)
```

### Write Ordering

Writes must be properly ordered:

```
Temporal ordering:
  Writes happen at specific logical times
  Later writes supersede earlier writes

Constraint:
  For writes W1, W2 to same address:
    If time(W1) < time(W2):
      W2's value visible after W2's time
      W1's value invisible after W2's time
```

### Operation Completeness

All operations must be accounted for:

```
No fabrication:
  Cannot invent reads or writes
  Every operation from actual execution

No omission:
  Cannot hide operations
  Every execution operation in trace

Verification:
  Permutation arguments prove completeness
```

## Timestamp-Based Consistency

### Logical Timestamps

Ordering operations in logical time:

```
Timestamp assignment:
  Each instruction gets unique timestamp
  Strictly increasing through execution
  t_0 < t_1 < t_2 < ... < t_n

Per-operation timestamp:
  Memory operation inherits instruction's timestamp
  Multiple ops per instruction get distinct stamps
```

### Timestamp Constraints

How timestamps enable consistency checking:

```
For each read at time t:
  Find prev_t = max timestamp of write to same address before t
  Read value = value written at prev_t

Constraint:
  read_value[t] = write_value[prev_t]
  where prev_t < t and no write between prev_t and t
```

### Proving Timestamp Relationships

Verifying correct ordering:

```
Challenge:
  Prove prev_t is actually the most recent write

Approach:
  Sort operations by (address, timestamp)
  Adjacent same-address ops satisfy consistency
  Use permutation to link sorted and execution order
```

## Sorted Memory View

### Address-Time Sorting

Organizing operations for verification:

```
Sort key: (address, timestamp)

Result:
  Operations to same address grouped together
  Within group, ordered by time

Example:
  Addr 100, t=5: write(100, 42)
  Addr 100, t=12: read(100) -> 42
  Addr 100, t=20: write(100, 99)
  Addr 100, t=25: read(100) -> 99
```

### Adjacent Consistency

Checking consecutive operations:

```
For adjacent rows i, i+1 in sorted order:
  If addr[i] = addr[i+1]:
    // Same address, later time
    If op[i+1] is READ:
      val[i+1] = val[i]  // Must match previous value
    If op[i+1] is WRITE:
      // Value can change

  If addr[i] != addr[i+1]:
    // New address, first access
    If op[i+1] is READ:
      val[i+1] = initial_value[addr[i+1]]
```

### Boundary Conditions

Handling first and last operations:

```
First operation to address:
  If READ: returns initial value
  If WRITE: establishes first value

Last operation to address:
  No special constraint
  But final value may be output
```

## Permutation Arguments

### Linking Views

Connecting execution and sorted orders:

```
Two representations:
  Execution order: Operations as executed
  Sorted order: Operations grouped by address

Same data:
  Both contain identical operations
  Just in different orders

Permutation proof:
  Prove one is reordering of other
  No elements added or removed
```

### Permutation Construction

Building the permutation argument:

```
Elements:
  (address, value, timestamp, operation_type)

Execution trace:
  [op1, op2, op3, ..., opN] in execution order

Sorted trace:
  [ops1, ops2, ops3, ..., opsN] sorted by (addr, ts)

Permutation argument:
  Product of (x - elem_i) equal for both
  Or: accumulator-based checking
```

### Grand Product Argument

Efficient permutation verification:

```
Construction:
  acc_0 = 1
  acc_i = acc_{i-1} * (challenge + elem_i)
  Final accumulator equal for both orders

Challenge:
  Random field element
  Makes forgery exponentially unlikely

Verification:
  Check final accumulators match
  Probabilistically proves permutation
```

## Multi-Width Consistency

### Sub-Word Access

Handling byte and halfword operations:

```
Challenge:
  Write word, read byte
  Read byte, write word
  Must maintain consistency

Approach:
  Track values at word granularity
  Sub-word ops decompose to word ops
  Masks extract/insert bytes
```

### Word Decomposition

Breaking words into bytes:

```
Word structure:
  word = byte3 || byte2 || byte1 || byte0
  where || is concatenation

Byte extraction:
  byte0 = word & 0xFF
  byte1 = (word >> 8) & 0xFF
  byte2 = (word >> 16) & 0xFF
  byte3 = (word >> 24) & 0xFF

Byte insertion:
  new_word = (word & ~mask) | ((byte << shift) & mask)
```

### Read-Modify-Write

Sub-word stores as compound operations:

```
Store byte at offset 1:
  1. Read containing word
  2. Modify byte position
  3. Write updated word

Consistency:
  Read sees previous word value
  Write updates word atomically
  Subsequent reads see update
```

## Initial Memory State

### Defined Initial Values

What memory contains at start:

```
Common schemes:
  All zeros: Simple but restrictive
  Initialized data: From program
  Input data: From prover input

Proving initial state:
  Commitment to initial memory
  First reads verified against commitment
```

### Commitment to Initial Memory

Binding initial values:

```
Merkle commitment:
  Tree over initial values
  Root is public input

Polynomial commitment:
  Initial values as evaluations
  Commitment is public

Verification:
  First read proves against commitment
  Subsequent reads use normal consistency
```

## Memory Regions and Consistency

### Per-Region Consistency

Different regions may have different models:

```
Register region:
  Always consistent (simple)
  Small, heavily accessed
  Dedicated verification

ROM region:
  Read-only, simpler consistency
  Just commitment verification
  No write tracking

RAM region:
  Full read-write consistency
  Timestamp-based tracking
  Permutation arguments
```

### Cross-Region Operations

When operations span regions:

```
Typically prohibited:
  No straddling access
  Each operation in one region

If allowed:
  Decompose into per-region ops
  Maintain each region's consistency
```

## Constraint Formulation

### Core Consistency Constraints

The essential polynomial constraints:

```
Sorted order constraint:
  For adjacent rows i, i+1:
    addr[i] <= addr[i+1]
    If addr[i] = addr[i+1]: ts[i] < ts[i+1]

Read consistency:
  If op[i] = READ and addr[i] = addr[i-1]:
    val[i] = val[i-1]

First access:
  If op[i] = READ and addr[i] != addr[i-1]:
    val[i] = init[addr[i]]
```

### Degree Optimization

Keeping constraint degrees manageable:

```
Issue:
  Complex conditions increase degree

Solutions:
  Introduce selector columns
  Use decomposition
  Apply intermediate variables

Example:
  is_same_addr = 1 if addr[i] = addr[i-1] else 0
  read_constraint: is_same_addr * is_read * (val[i] - val[i-1]) = 0
```

## Verification Efficiency

### Batch Verification

Checking many operations together:

```
Approach:
  Aggregate constraints
  Single verification for many ops

Benefits:
  Amortized cost
  Smaller proof size
```

### Hierarchical Consistency

Multi-level verification:

```
Strategy:
  Group operations by address range
  Verify within groups
  Verify across groups

Benefits:
  Parallelization
  Localized constraints
  Scalable to large memory
```

## Security Properties

### Soundness

What the consistency model guarantees:

```
No false reads:
  Cannot claim arbitrary read values

No hidden writes:
  Cannot hide writes that affect reads

Complete coverage:
  All memory operations verified
```

### Attack Prevention

Attacks the model prevents:

```
Value substitution:
  Claim different value than written
  Prevented by read-write linkage

Operation injection:
  Add fake operations
  Prevented by permutation argument

Operation hiding:
  Omit real operations
  Prevented by completeness checking
```

## Key Concepts

- **Memory consistency**: Proving reads return correct values
- **Timestamp ordering**: Logical time for operation sequencing
- **Sorted view**: Operations grouped by address for verification
- **Permutation argument**: Linking execution and sorted orders
- **Read-after-write**: Fundamental consistency property

## Design Trade-offs

### Sorting Strategy

| Online Sorting | Offline Sorting |
|----------------|-----------------|
| Incremental proof | Post-execution proof |
| Higher constraint cost | Batched verification |
| Immediate consistency | Delayed verification |

### Granularity

| Word-Level | Byte-Level |
|------------|------------|
| Simpler constraints | More flexible access |
| Masking for sub-word | Direct byte tracking |
| Less columns | More columns |

## Related Topics

- [Memory Layout](01-memory-layout.md) - Address space organization
- [Aligned Access](03-aligned-access.md) - Alignment requirements
- [Memory Timestamping](04-memory-timestamping.md) - Timestamp mechanisms
- [Memory State Machine](../02-state-machine-design/05-memory-state-machine.md) - Memory operations

