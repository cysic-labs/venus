# Minimal Traces

## Overview

Minimal traces contain only the essential information needed for proof generation, avoiding redundant or derivable data. By carefully selecting what to record, the zkVM can reduce trace size, memory usage, and I/O overhead without sacrificing the ability to generate valid proofs. This optimization is crucial for handling large computations efficiently.

The principle behind minimal traces is that much trace data can be reconstructed from a smaller core dataset plus the program code. If a value can be computed from already-recorded information, it need not be stored explicitly. This leads to traces that are much smaller than naive full-state captures.

This document covers trace minimization strategies, what must be recorded versus derived, and the trade-offs involved.

## Minimization Principles

### Core Data

What cannot be omitted:

```
Essential records:
  Execution path (which instructions)
  Memory access addresses
  External inputs
  Non-deterministic choices

Without these:
  Cannot reconstruct execution
  Proof generation impossible
```

### Derivable Data

What can be computed:

```
Derivable from program:
  Instruction encodings
  Immediate values
  Static addresses

Derivable from execution:
  ALU results (from operands)
  Register states (from deltas)
  Memory states (from operations)
```

### Minimization Goal

Target trace content:

```
Minimal trace:
  Execution path
  Non-derivable values only

Reconstruction:
  Replay with program
  Compute derivable values
  Produce full trace
```

## Trace Components

### Execution Path

Recording instruction sequence:

```
Options:
  Full PC sequence
  Delta-encoded PCs
  Branch-only recording

Minimal:
  Branches and jumps record target
  Sequential flow implied
```

### Register Values

Recording register state:

```
Full state:
  All 32 registers per instruction
  Highly redundant

Delta state:
  Only changed register per instruction
  Much smaller

Derivable:
  Given initial state + deltas
  Any intermediate state computable
```

### Memory Operations

Recording memory accesses:

```
Per operation:
  Address (required)
  Value (for writes: required; for reads: may derive)
  Timestamp (required for ordering)

Optimization:
  Read values derivable from prior writes
  Only store first write to address
```

### Intermediate Values

ALU and temporary results:

```
Standard:
  Record all intermediate values
  Large trace

Minimal:
  Derive from operands
  Only operands needed

Reconstruction:
  Recompute in Phase 2
```

## Recording Strategies

### Delta Recording

Capturing changes only:

```
Registers:
  (index, new_value) per instruction
  Skip unchanged registers

Memory:
  (address, old_value, new_value) per write
  Skip unchanged locations
```

### Checkpoint + Deltas

Periodic full state:

```
Structure:
  Full state every N instructions
  Deltas between checkpoints

Benefits:
  Random access to any point
  Bounded reconstruction cost
```

### Branch Recording

Minimal control flow:

```
Record:
  Taken/not-taken for conditionals
  Target addresses for indirect jumps

Derive:
  Sequential PCs from previous PC
  Direct branch targets from instruction
```

## Reconstruction Process

### Replay Strategy

Rebuilding full trace:

```
Process:
  Load initial state
  For each recorded instruction:
    Fetch instruction (from program)
    Read operands (from state)
    Execute (compute result)
    Apply delta (from minimal trace)
    Record full row

Output:
  Complete trace columns
```

### Parallelization

Concurrent reconstruction:

```
With checkpoints:
  Each segment independent
  Parallel reconstruction
  Combine results
```

## Size Reduction

### Comparison

Trace sizes:

```
Full trace:
  ~200 bytes per instruction
  PC, instruction, operands, result, memory

Minimal trace:
  ~20 bytes per instruction
  Deltas, branches, non-derivable values

Reduction:
  10x or more
```

### Storage Benefits

Smaller traces mean:

```
Benefits:
  Less disk I/O
  Lower memory pressure
  Faster transfer
  More in cache
```

## Trade-offs

### Reconstruction Cost

Cost of deriving values:

```
Phase 2 work:
  Must recompute derivable values
  Adds to generation time

Balance:
  Smaller trace vs more compute
  Depends on I/O vs CPU bottleneck
```

### Completeness vs Size

What to include:

```
More complete:
  Faster reconstruction
  Larger trace

More minimal:
  Slower reconstruction
  Smaller trace

Optimization:
  Profile to find balance
```

## Implementation

### Minimal Recorder

Recording minimal data:

```
Design:
  Only record essential
  Compress where possible
  Stream to output

Interface:
  record_branch(taken)
  record_reg_delta(idx, value)
  record_mem_write(addr, value)
```

### Reconstruction Engine

Rebuilding traces:

```
Design:
  Load program
  Load minimal trace
  Replay with full generation

Output:
  Full trace for prover
```

## Key Concepts

- **Minimal traces**: Recording only essential data
- **Derivable data**: Values computable from core data
- **Delta recording**: Capturing changes only
- **Reconstruction**: Rebuilding full trace from minimal
- **Size reduction**: 10x or more trace size reduction

## Design Trade-offs

### Minimality Level

| More Recording | Less Recording |
|----------------|----------------|
| Larger traces | Smaller traces |
| Faster reconstruction | Slower reconstruction |
| Simpler | Complex |

### Checkpoint Frequency

| Frequent | Infrequent |
|----------|------------|
| Random access | Sequential access |
| Larger trace | Smaller trace |
| Parallel friendly | Less parallel |

## Related Topics

- [Two-Phase Execution](01-two-phase-execution.md) - Execution strategy
- [Trace Capture](../01-emulator-architecture/03-trace-capture.md) - Recording mechanisms
- [Trace to Witness](03-trace-to-witness.md) - Witness building
- [Execution Trace](../../04-zkvm-architecture/04-execution-model/02-execution-trace.md) - Trace format

