# Continuations

## Overview

Continuations represent captured execution state that allows computation to be suspended and resumed. In the zkVM context, continuations enable segmented execution by packaging all state needed to continue execution from a specific point. When a segment completes, its continuation captures the exact machine state, which becomes the starting point for the next segment.

The continuation mechanism is fundamental to scaling zkVM execution beyond memory limits. By serializing and deserializing execution state at segment boundaries, the zkVM can prove arbitrarily long computations through a series of finite segments. Each segment's proof verifies correct execution from one continuation to the next.

This document explains continuation structure, creation, verification, and their role in enabling scalable zero-knowledge computation.

## Continuation Concepts

### What Is a Continuation

The captured state for resumption:

```
Continuation contents:
  Program counter: Where to resume
  Register file: All register values
  Memory state: Committed memory snapshot
  Execution metadata: Segment info, counters

Purpose:
  Complete specification of machine state
  Sufficient to continue execution
  Compact representation for proving
```

### Continuation Points

Where continuations are created:

```
Automatic points:
  Segment boundaries (every N steps)
  Memory pressure thresholds
  Prover-determined splits

Explicit points:
  Designated program locations
  System call boundaries
  Transaction boundaries
```

### Continuation Types

Different kinds of continuations:

```
Initial continuation:
  Program entry state
  Input loaded
  Memory initialized

Intermediate continuation:
  Mid-execution state
  Between segments
  Execution in progress

Terminal continuation:
  Program completed
  Final output produced
  No further execution
```

## Continuation Structure

### State Components

What a continuation contains:

```
Core state:
  pc: Program counter (32 bits)
  registers: x0-x31 values (32 × 32 bits)

Memory state:
  memory_root: Merkle root of memory
  Or: full memory snapshot
  Or: delta from base

Metadata:
  segment_id: Which segment this follows
  step_count: Total steps so far
  input_commitment: Hash of program input
```

### Serialization Format

How continuations are represented:

```
Binary format:
  [4 bytes: pc]
  [128 bytes: registers]
  [32 bytes: memory_root]
  [metadata...]

Commitment form:
  continuation_hash = Hash(pc, reg_commitment, memory_root, metadata)
  Single compact identifier
```

### Commitment Scheme

Creating verifiable continuation references:

```
Register commitment:
  reg_commit = Hash(x0 || x1 || ... || x31)

Memory commitment:
  mem_commit = MerkleRoot(memory_pages)

Full commitment:
  cont_commit = Hash(pc || reg_commit || mem_commit || metadata)
```

## Creating Continuations

### State Capture

Gathering state for continuation:

```
At continuation point:
  1. Record current PC
  2. Capture all register values
  3. Compute memory commitment
  4. Bundle metadata

Output:
  Complete continuation object
  Or: continuation commitment
```

### Memory Snapshot

Capturing memory state efficiently:

```
Full snapshot:
  Copy all memory
  High storage cost
  Simple but expensive

Merkle approach:
  Compute tree over memory
  Store only root (32 bytes)
  Pages retrievable via proofs

Delta approach:
  Record changes since last continuation
  Smaller for similar states
  Requires base state reference
```

### Continuation Commitment

Creating compact reference:

```
Process:
  Gather all state components
  Apply commitment scheme
  Produce single hash

Properties:
  Binding: Can't change state and keep hash
  Hiding: Optional, if state should be private
  Compact: Fixed size regardless of state size
```

## Using Continuations

### Segment Entry

Starting execution from continuation:

```
Initialization:
  1. Load continuation data
  2. Restore PC
  3. Restore registers
  4. Load/verify memory state
  5. Resume execution

Verification:
  Restored state matches continuation commitment
```

### Segment Exit

Creating next continuation:

```
At segment end:
  1. Halt execution
  2. Capture current state
  3. Create continuation
  4. Store for next segment

Constraint:
  Segment proof includes exit continuation
```

### Continuation Chaining

Linking segments via continuations:

```
Execution flow:
  C0 → Segment 0 → C1 → Segment 1 → C2 → ...

Verification:
  C0 is valid initial state
  Each segment transforms Ci to Ci+1
  Final Cn is terminal
```

## Continuation Verification

### State Validity

Checking continuation correctness:

```
Validity checks:
  PC in valid code range
  Registers properly formatted
  Memory commitment valid structure
  Metadata consistent
```

### Matching Verification

Ensuring continuations align:

```
At boundary:
  exit_continuation[segment_n] = entry_continuation[segment_n+1]

Proof:
  Commitments are equal
  Or: full states match
```

### Public Input Connection

Linking to proof public inputs:

```
Initial continuation:
  May derive from public input
  input_commitment embedded

Final continuation:
  Final state part of output
  output_commitment from terminal continuation
```

## Continuation in Constraints

### Entry Constraints

Constraining segment start:

```
Constraints:
  pc[0] = continuation.pc
  registers[0] = continuation.registers
  memory[0] consistent with continuation.memory_root

Boundary constraint:
  First row matches continuation state
```

### Exit Constraints

Constraining segment end:

```
Constraints:
  exit_pc = pc[last]
  exit_registers = registers[last]
  exit_memory_root = computed from trace

Output:
  Exit continuation from final row
```

### Transition Proof

Proving correct transformation:

```
Segment proof shows:
  Given entry continuation C_in
  Execution produces exit continuation C_out
  All intermediate steps valid
```

## Memory Continuations

### Memory Root Computation

Creating memory commitment:

```
Merkle tree:
  Leaves: memory values (by address)
  Internal nodes: hashes of children
  Root: memory_root in continuation

Computation:
  Build tree from memory state
  Extract root
```

### Memory Delta Continuations

Tracking changes only:

```
Delta format:
  [(addr1, old1, new1), (addr2, old2, new2), ...]
  Only modified locations

Continuation:
  base_continuation: Reference to prior state
  delta: Changes since base

Application:
  new_state = apply(base_state, delta)
```

### Memory Proof Integration

Proving memory at continuation:

```
For reads:
  Provide Merkle path from continuation root
  Prove value at address

For writes:
  Prove old value existed
  Prove new root includes new value
```

## Register Continuations

### Register State Capture

Handling register values:

```
Capture:
  r[0..31] = current register values
  r[0] always 0 (by definition)

Commitment:
  reg_hash = Hash(r[0] || r[1] || ... || r[31])

Verification:
  Restore registers, verify hash matches
```

### Register Initialization

Setting up registers from continuation:

```
At segment start:
  Load register values from continuation
  Set trace column initial values
  Constrain: trace_reg[0] = continuation_reg
```

## Advanced Continuation Patterns

### Checkpoint Continuations

Saving state for potential rollback:

```
Use case:
  Speculative execution
  Transaction processing
  Error recovery

Implementation:
  Save continuation at checkpoint
  Continue execution
  On failure: restore and retry/abort
```

### Branching Continuations

Multiple possible next states:

```
Scenario:
  Conditional computation paths
  Different continuations per branch

Handling:
  Create continuation for each path
  Prove taken path
  Unused continuations discarded
```

### Continuation Compression

Reducing continuation size:

```
Techniques:
  Deduplication of common data
  Compression of registers (if sparse)
  Incremental memory representation

Trade-off:
  Smaller storage
  More complex restoration
```

## Performance Considerations

### Creation Cost

Overhead of making continuations:

```
Costs:
  Memory commitment computation
  State serialization
  Commitment hashing

Optimization:
  Incremental Merkle updates
  Lazy evaluation where possible
  Cache intermediate results
```

### Storage Requirements

Space for continuations:

```
Per continuation:
  PC: 4 bytes
  Registers: 128 bytes
  Memory root: 32 bytes
  Metadata: variable

Total:
  ~200 bytes per continuation (compact)
  More if deltas/snapshots included
```

### Restoration Cost

Overhead of resuming from continuation:

```
Costs:
  Load and verify state
  Reconstruct memory view
  Initialize segment execution

Optimization:
  Cached memory pages
  Lazy loading of memory
  Parallel initialization
```

## Key Concepts

- **Continuation**: Captured execution state for resumption
- **Continuation commitment**: Compact hash of continuation state
- **Continuation chaining**: Linking segments via matching continuations
- **Memory continuation**: Memory state representation in continuation
- **Terminal continuation**: Final state indicating completion

## Design Trade-offs

### State Representation

| Full State | Incremental/Delta |
|------------|-------------------|
| Self-contained | Compact storage |
| Fast restoration | Needs base state |
| Higher storage | Lower storage |

### Commitment Granularity

| Single Hash | Structured Commitment |
|-------------|----------------------|
| Simple verification | Component access |
| All-or-nothing | Partial proofs |
| Minimal size | Slightly larger |

## Related Topics

- [Segmented Execution](03-segmented-execution.md) - Execution division strategy
- [Execution Trace](02-execution-trace.md) - Per-segment trace structure
- [Memory Consistency](../03-memory-model/02-memory-consistency.md) - Memory verification
- [Proof Aggregation](../../03-proof-management/01-proof-orchestration/03-proof-aggregation.md) - Combining segment proofs

