# Two-Phase Execution

## Overview

Two-phase execution separates the emulation process into a fast execution phase followed by a detailed trace generation phase. The first phase runs quickly to determine program behavior and collect minimal state information. The second phase uses this information to generate the full witness needed for proving. This approach optimizes for total proving time by avoiding unnecessary work.

The key insight is that some witness data can be computed more efficiently with foreknowledge of the execution path. For example, memory consistency proofs require knowing all memory accesses, which is only fully known after execution completes. Two-phase execution enables optimizations that would be impossible in a single-pass approach.

This document explains the two-phase strategy, what each phase accomplishes, and how they work together.

## Phase Overview

### Phase 1: Execution

Fast initial execution:

```
Goals:
  Determine execution path
  Collect essential state
  Identify segment boundaries

Captures:
  Instruction sequence
  Memory access addresses
  Branch outcomes
  Segment points
```

### Phase 2: Witness Generation

Detailed trace building:

```
Goals:
  Generate full witness
  Compute all intermediate values
  Build constraint-ready data

Uses:
  Phase 1 execution log
  Program code
  Initial state
```

### Why Two Phases

Benefits of separation:

```
Optimization opportunities:
  Sort memory accesses (phase 2)
  Batch similar operations
  Parallel generation
  Memory efficiency

Single-pass limitations:
  Must generate everything inline
  No global optimizations
  Higher memory pressure
```

## Phase 1: Execution

### Execution Goals

What Phase 1 accomplishes:

```
Primary outputs:
  Execution log (minimal)
  Segment boundaries
  Total instruction count

Secondary outputs:
  Memory access log
  Branch decisions
  Precompile invocations
```

### Minimal Recording

Light-weight capture:

```
Per instruction:
  PC (compressed)
  Modified register (if any)
  Memory address (if memory op)

Not captured (deferred):
  Full operand values
  Intermediate computations
  Trace column values
```

### Segment Detection

Identifying segment boundaries:

```
Triggers:
  Fixed instruction count
  Memory pressure
  Explicit checkpoint

Output:
  List of segment endpoints
  State at each boundary
```

### Phase 1 Speed

Optimizing execution:

```
Focus:
  Fast interpretation
  Minimal recording
  Low memory use

Result:
  Near-native emulation speed
  Small execution log
```

## Phase 2: Witness Generation

### Generation Goals

What Phase 2 accomplishes:

```
Outputs:
  Full execution trace
  Memory consistency data
  Sorted memory operations
  Commitment-ready witness
```

### Using Execution Log

Leveraging Phase 1 data:

```
Process:
  Replay execution
  Fill in details
  Compute all values

Efficiency:
  Knows path (no speculation)
  Can optimize ordering
  Batch operations
```

### Full Trace Building

Generating complete trace:

```
Per instruction:
  All operand values
  Intermediate computations
  Result values
  Memory operations (full detail)

Columns:
  All trace columns populated
```

### Memory Sorting

Organizing memory operations:

```
Process:
  Collect all memory ops from Phase 1
  Sort by (address, timestamp)
  Build consistency proof data

Benefit:
  Single sort over all operations
  Optimal ordering
  Efficient proof structure
```

## Data Flow

### Phase 1 to Phase 2

What passes between phases:

```
Execution log:
  Instruction sequence summary
  Memory addresses touched
  Branch outcomes
  Segment boundaries

State snapshots:
  At segment boundaries
  Initial and final state
```

### Parallel Processing

Concurrent Phase 2 work:

```
With execution log:
  Different segments independent
  Parallel witness generation
  Memory ops sortable in parallel
```

## Segment Handling

### Per-Segment Phases

Two phases per segment:

```
Option A: Global then local
  Phase 1: Entire program
  Phase 2: Per segment, parallel

Option B: Segment by segment
  Phase 1 + 2 for segment 1
  Then segment 2, etc.
```

### Segment Independence

Parallel segment processing:

```
After Phase 1:
  All segments known
  Boundaries defined
  States captured

Phase 2:
  Each segment independent
  Parallel generation
```

## Memory Optimization

### Phase 1 Memory

Low memory during execution:

```
Usage:
  Minimal execution log
  No full trace storage
  Streaming to disk if needed

Scale:
  O(log_size) not O(trace_size)
```

### Phase 2 Memory

Controlled memory in generation:

```
Usage:
  Per-segment buffers
  Streaming output
  Bounded by segment size

Scale:
  O(segment_size)
  Bounded per segment
```

## Implementation Strategy

### Execution Log Format

Compact execution record:

```
Format options:
  Delta-encoded PC sequence
  Compressed memory addresses
  Bit-packed branch outcomes

Goal:
  Small enough to hold in memory
  Or: stream to disk efficiently
```

### Replay Mechanism

Re-executing in Phase 2:

```
Approach:
  Use execution log as guide
  Recompute values
  Generate full trace

Validation:
  Computed values match expected
  Detects Phase 1/2 mismatch
```

## Key Concepts

- **Two-phase execution**: Separate fast execution from witness generation
- **Phase 1**: Light-weight execution with minimal recording
- **Phase 2**: Full witness generation using execution log
- **Execution log**: Compact record of execution path
- **Parallel generation**: Independent segment processing

## Design Trade-offs

### Single vs Two Phase

| Single Phase | Two Phase |
|--------------|-----------|
| Simple | Complex |
| Inline generation | Deferred generation |
| No global optimization | Global optimization |

### Log Detail Level

| Minimal Log | Detailed Log |
|-------------|--------------|
| Smaller | Larger |
| More Phase 2 work | Less Phase 2 work |
| Full replay needed | Partial replay |

## Related Topics

- [Emulator Design](../01-emulator-architecture/01-emulator-design.md) - Emulator architecture
- [Trace Capture](../01-emulator-architecture/03-trace-capture.md) - Recording mechanisms
- [Minimal Traces](02-minimal-traces.md) - Trace optimization
- [Witness Generation](../../02-stark-proving-system/04-proof-generation/01-witness-generation.md) - Proof witness

