# Segmented Execution

## Overview

Segmented execution divides a long program execution into smaller, independently provable segments. Instead of generating a single massive proof for an entire computation, the zkVM proves each segment separately and combines the proofs. This approach enables parallelization, reduces memory requirements, and allows proving of arbitrarily long computations.

A segment contains a fixed number of execution steps (instructions), with carefully defined boundaries that capture the complete state needed to resume execution. The segment's proof demonstrates correct execution from the initial state to the final state, and segments chain together through matching boundary states.

Segmentation is essential for practical zkVM operation. Without it, proving long computations would require prohibitive memory and time. With segmentation, multiple provers can work in parallel, and each segment's proof can be generated independently.

## Segmentation Concepts

### Why Segment

Motivations for dividing execution:

```
Memory constraints:
  Trace tables grow with execution length
  Cannot fit billion-step trace in memory
  Segments bound memory usage

Parallelization:
  Independent segments proved in parallel
  Linear speedup with prover count
  Better hardware utilization

Incremental proving:
  Prove as execution proceeds
  Don't wait for full execution
  Stream proofs for long computations
```

### Segment Definition

What constitutes a segment:

```
Segment properties:
  Fixed maximum step count
  Complete initial state
  Complete final state
  Self-contained execution

Content:
  Consecutive instructions
  All state transitions between them
  Memory operations performed
```

### Segment Size

Determining segment length:

```
Trade-offs:
  Smaller segments:
    Less memory per segment
    More segments total
    More aggregation work

  Larger segments:
    More memory per segment
    Fewer segments
    Less aggregation

Typical sizes:
  2^20 to 2^24 steps per segment
  Depends on hardware capabilities
```

## Segment Boundaries

### Boundary State

What state is captured at segment edges:

```
Initial state (entry):
  Program counter
  All register values
  Memory commitment or snapshot

Final state (exit):
  Updated program counter
  Updated register values
  Memory state changes

Continuation info:
  Next segment ID (if any)
  Execution metadata
```

### State Commitment

Compactly representing boundary state:

```
Register commitment:
  Hash of all 32 register values
  Compact single value

Memory commitment:
  Merkle root of memory state
  Or: delta from previous segment

Combined commitment:
  Hash(PC, reg_commit, mem_commit)
  Single boundary state hash
```

### Boundary Matching

Connecting adjacent segments:

```
Requirement:
  Segment N final state = Segment N+1 initial state

Verification:
  boundary_hash_N_end = boundary_hash_N+1_start

Constraint:
  Part of aggregation proof
  Or: verified by coordinator
```

## Segment Creation

### Determining Boundaries

Where to split execution:

```
Simple approach:
  Fixed interval (every 2^20 steps)
  Predictable boundaries
  Easy parallelization

Adaptive approach:
  Split at convenient points
  Memory transaction boundaries
  Function call boundaries

Trade-off:
  Fixed: simpler, predictable
  Adaptive: potentially more efficient
```

### Handling Mid-Instruction Splits

When segment boundary falls mid-operation:

```
Prevention:
  Ensure boundaries at instruction boundaries
  Segment size in instructions, not cycles

Multi-cycle instructions:
  Complete instruction before boundary
  Or: include all cycles in one segment

Memory transactions:
  Include all related operations
  Avoid splitting atomic sequences
```

### Segment Metadata

Information attached to each segment:

```
Segment record:
  Segment ID (sequential)
  Start PC
  End PC
  Step count
  Initial state hash
  Final state hash
  Parent segment (for branches)

Execution context:
  Input commitment (if applicable)
  Output produced (if any)
  Memory delta summary
```

## Segment Proving

### Independent Proofs

Each segment proved separately:

```
Segment proof:
  Demonstrates correct execution
  From initial state to final state
  Per-segment witness (trace)

Public inputs:
  Initial state commitment
  Final state commitment
  Segment metadata

Verification:
  Proof valid for this segment
  States match expected values
```

### Parallel Proving

Multiple segments simultaneously:

```
Execution phase:
  Run full program, record segments
  Capture boundary states

Prove phase:
  Distribute segments to provers
  Each prover works independently
  No communication during proving

Collection:
  Gather all segment proofs
  Verify and aggregate
```

### Segment Dependencies

What segments depend on:

```
Primary dependency:
  Initial state from previous segment
  Must know boundary state

Resolution:
  Execute sequentially to find boundaries
  Prove in parallel afterward

Alternative:
  Speculative execution
  Prove multiple possible paths
```

## State Continuation

### Register Continuation

Passing register state between segments:

```
At segment end:
  Capture all 32 register values
  Commit to register vector

At segment start:
  Load register values
  Verify against commitment

Constraint:
  reg_values match commitment
```

### Memory Continuation

Passing memory state:

```
Approaches:

Full memory commitment:
  Merkle root of entire memory
  Heavy to compute
  Complete state capture

Delta approach:
  Only changed locations
  Smaller representation
  Requires base state reference

Hybrid:
  Merkle root for touched pages
  Delta for changes
```

### PC Continuation

Passing program counter:

```
Straightforward:
  PC is single value
  Directly included in boundary

Validation:
  Final PC of segment N
  = Initial PC of segment N+1
  Unless segment N is terminal
```

## Segment Aggregation

### Proof Composition

Combining segment proofs:

```
Goal:
  Single proof for entire execution
  From initial input to final output

Method:
  Verify all segment proofs
  Verify boundary matching
  Produce aggregate proof
```

### Boundary Verification

Checking segment connections:

```
For adjacent segments N, N+1:
  final_state[N] = initial_state[N+1]

Proof:
  Include in aggregation circuit
  Or: separate verification layer
```

### Recursive Aggregation

Hierarchical proof combination:

```
Tree structure:
  Leaf: individual segment proofs
  Internal: aggregates of children
  Root: final combined proof

Benefits:
  Logarithmic depth
  Parallel aggregation
  Constant final proof size
```

## Memory Handling Across Segments

### Memory Checkpointing

Capturing memory state at boundaries:

```
Checkpoint content:
  Snapshot of modified memory
  Or: Merkle root of memory tree

Creation:
  At segment end
  Include dirty pages/locations

Use:
  Initialize next segment
  Verify memory consistency
```

### Memory Delta

Tracking changes within segment:

```
Delta record:
  (address, old_value, new_value)
  For each memory modification

Segment proof:
  Proves delta correctly applied
  From initial to final memory

Continuation:
  Apply delta to get next initial state
```

### Cross-Segment Memory Consistency

Ensuring global memory correctness:

```
Local consistency:
  Each segment internally consistent

Global consistency:
  Deltas chain correctly
  Final memory matches expected

Verification:
  Part of aggregation
  Or: separate memory proof
```

## Performance Optimization

### Segment Size Tuning

Optimizing for performance:

```
Factors:
  Prover memory capacity
  Proof generation time
  Aggregation overhead

Optimization:
  Larger segments: less overhead
  Smaller segments: better parallelism
  Find balance for target system
```

### Parallelization Efficiency

Maximizing parallel utilization:

```
Load balancing:
  Segments may differ in complexity
  Distribute for even work

Pipeline:
  Execute → Prove → Aggregate
  Overlap stages

Hardware matching:
  Segment size to prover capacity
  Minimize idle time
```

### Memory Management

Efficient memory use:

```
Strategies:
  Release segment data after proving
  Stream checkpoints to disk
  Compress delta records

Memory bound:
  Per-segment memory independent of total execution
  Enables arbitrarily long computations
```

## Segment Verification

### Per-Segment Verification

Checking individual segment proofs:

```
Verification inputs:
  Segment proof
  Initial state commitment
  Final state commitment
  Public parameters

Check:
  Proof valid for claimed transition
```

### Aggregate Verification

Checking combined proof:

```
Verification inputs:
  Aggregate proof
  Overall initial state
  Overall final state
  Public inputs/outputs

Check:
  Aggregate proof valid
  Much cheaper than verifying all segments
```

## Edge Cases

### Single Segment Execution

When program fits in one segment:

```
Behavior:
  No segmentation overhead
  Single proof generated
  No aggregation needed

Threshold:
  If steps < segment_size:
    Run as single segment
```

### Very Long Execution

When execution spans many segments:

```
Handling:
  Streaming execution
  Incremental proving
  Hierarchical aggregation

Limits:
  No theoretical limit on length
  Practical limits from time/cost
```

### Branching Execution

Programs with varying paths:

```
Challenge:
  Path length may vary
  Segment count depends on input

Approach:
  Segment during execution
  Actual path determines segments
  Prove realized path
```

## Key Concepts

- **Segmented execution**: Dividing computation into provable chunks
- **Segment boundary**: State captured between segments
- **Boundary matching**: Ensuring adjacent segments connect
- **Parallel proving**: Independent proof generation per segment
- **Proof aggregation**: Combining segment proofs

## Design Trade-offs

### Segment Size

| Small Segments | Large Segments |
|----------------|----------------|
| Low memory | High memory |
| High parallelism | Less parallelism |
| More aggregation | Less aggregation |

### Boundary Representation

| Full State | Delta State |
|------------|-------------|
| Self-contained | Compact |
| Easy verification | Complex chaining |
| Higher overhead | Lower overhead |

## Related Topics

- [Execution Trace](02-execution-trace.md) - Per-segment trace structure
- [Continuations](04-continuations.md) - State passing mechanism
- [Proof Aggregation](../../03-proof-management/01-proof-orchestration/03-proof-aggregation.md) - Combining proofs
- [Recursive Proving](../../03-proof-management/03-recursion/01-recursive-proving.md) - Hierarchical proofs

