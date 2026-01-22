# Heap Management

## Overview

Heap management in zkVM environments governs how dynamic memory is organized, allocated, and tracked throughout program execution. While the bump allocator handles individual allocation operations, heap management encompasses the broader concerns of heap sizing, region organization, growth policies, and integration with the proving system.

Effective heap management balances the need for dynamic memory allocation against the constraints of provable execution. The heap must be large enough for program needs while not wasting precious proving resources on unused space. All heap operations must be deterministic and efficiently representable in cryptographic constraints.

This document covers heap organization, management strategies, and design considerations for zkVM heap systems.

## Heap Fundamentals

### What Is the Heap

Definition and purpose:

```
Heap definition:
  Dynamically allocated memory region
  Available during execution
  Grows as needed (within limits)
  Persists until execution ends

Purpose:
  Runtime-sized data structures
  Variable-length allocations
  Temporary computation space
  Unknown-at-compile-time needs
```

### Heap vs Other Regions

Distinguishing memory regions:

```
Stack:
  Automatic allocation/deallocation
  Fixed frame sizes
  LIFO semantics
  Fast allocation

Heap:
  Explicit allocation
  Variable sizes
  No ordering requirement
  More flexible

Static data:
  Compile-time sized
  Fixed addresses
  No allocation needed
```

## Heap Organization

### Heap Location

Where the heap resides:

```
Typical placement:
  After BSS section
  Before stack region
  Grows toward higher addresses

Address space:
  [Code][Data][BSS][Heap-->  <--Stack]

Boundaries:
  Start: End of BSS + alignment
  End: Stack limit or hard boundary
```

### Heap Sizing

Determining heap size:

```
Sizing factors:
  Program requirements
  Available address space
  Proving capacity
  Safety margins

Approaches:
  Fixed size (compile-time)
  Maximum allowed (runtime check)
  Dynamic growth (if supported)
```

### Heap Boundaries

Managing heap limits:

```
Lower bound:
  Fixed start address
  After static data
  Known at link time

Upper bound:
  Maximum heap extent
  Before stack begins
  Configurable or fixed
```

## Heap State

### State Components

What heap management tracks:

```
Essential state:
  Current allocation point
  Heap boundaries
  (Optional: allocation count)

Minimal representation:
  Single pointer for bump allocation
  Start/end addresses
```

### State Initialization

Setting up heap state:

```
Initialization:
  Set heap start address
  Set heap end boundary
  Initialize allocation pointer
  Clear any metadata

Timing:
  During boot sequence
  Before program entry
  Part of runtime init
```

### State Transitions

How state changes:

```
State changes occur:
  On each allocation
  On reset (if supported)
  Never otherwise

Properties:
  Monotonic progression
  Bounded by limits
  Deterministic updates
```

## Allocation Policies

### First-Fit (Bump)

Simplest policy:

```
First-fit/bump:
  Allocate at current position
  Move pointer forward
  Never look back

Properties:
  O(1) allocation
  No fragmentation search
  Memory never reclaimed
```

### Best-Fit

More complex alternative:

```
Best-fit:
  Find smallest suitable block
  Minimize waste
  Requires free list

In zkVM:
  Rarely used
  Complex constraints
  Overhead often not worth it
```

### Size Classes

Bucketed allocation:

```
Size class approach:
  Predefined size buckets
  Route to appropriate bucket
  Simpler than general heap

In zkVM:
  Possible optimization
  Additional complexity
  Use when beneficial
```

## Growth Management

### Growth Direction

How heap expands:

```
Upward growth:
  Start at low address
  Grow toward high
  Standard convention

Benefit:
  Natural with bump
  Simple boundary check
  Intuitive addressing
```

### Growth Limits

Preventing overallocation:

```
Limit enforcement:
  Check before allocation
  Fail if would exceed
  Return error/abort

Limit sources:
  Configured maximum
  Stack collision boundary
  Physical constraints
```

### Growth Tracking

Monitoring heap usage:

```
Tracking enables:
  Usage statistics
  Leak detection (conceptual)
  Resource monitoring

Tracking overhead:
  Minimal for bump
  More for complex allocators
  Trade-off with visibility
```

## Memory Pressure

### Exhaustion Handling

When heap is full:

```
Exhaustion scenarios:
  Single large allocation fails
  Cumulative allocations exhaust
  Alignment waste accumulates

Responses:
  Return null pointer
  Abort execution
  Trap/exception
```

### Conservation Strategies

Reducing heap pressure:

```
Conservation approaches:
  Minimize allocation sizes
  Reuse allocations (app level)
  Phase-based reset
  Careful sizing estimates
```

### Monitoring

Tracking heap health:

```
Monitoring capabilities:
  Current usage
  Peak usage
  Remaining space
  Allocation count
```

## Alignment Management

### Alignment Requirements

Why alignment matters:

```
Alignment needs:
  Hardware efficiency
  Correctness for some types
  Platform conventions

Common alignments:
  4 bytes: words
  8 bytes: double words
  Platform-specific maximums
```

### Alignment Strategies

Meeting alignment requirements:

```
Per-allocation alignment:
  Align start address
  May waste some bytes
  Ensures type safety

Global alignment:
  All allocations aligned
  Simpler but may waste more
  Consistent behavior
```

### Alignment Overhead

Cost of alignment:

```
Padding waste:
  Up to (alignment - 1) bytes
  Per allocation potentially
  Cumulative impact

Minimizing waste:
  Order allocations by size
  Larger alignments first
  Application responsibility
```

## Constraint Integration

### Heap in Proofs

How heap appears in proofs:

```
Proven aspects:
  Allocation pointer updates
  Boundary respect
  Address validity

Constraint structure:
  State transitions
  Bound checks
  Correctness properties
```

### Constraint Efficiency

Efficient heap constraints:

```
Efficient patterns:
  Single pointer tracking
  Simple comparisons
  Linear updates

Inefficient patterns:
  Complex data structures
  Searching operations
  Multiple pointer management
```

### Memory Consistency

Heap and memory proofs:

```
Consistency requirements:
  Allocated memory is valid
  Addresses are unique
  No overlapping allocations

Proven via:
  Memory timestamp system
  Address range tracking
  Allocation sequencing
```

## Heap Initialization

### Bootstrap Process

Setting up the heap:

```
Bootstrap steps:
  1. Determine heap bounds
  2. Initialize allocation pointer
  3. Clear metadata (if any)
  4. Ready for allocation

Timing:
  Early in boot sequence
  Before any dynamic allocation
  After memory layout fixed
```

### Initial State

Heap at program start:

```
Initial heap state:
  Allocation pointer at start
  Full space available
  No allocations yet
  Clean state
```

### Heap Commitment

Committing heap state:

```
State commitment:
  Hash of heap state
  Used in proofs
  Enables verification

Commitment contents:
  Allocation pointer
  Boundaries
  Configuration
```

## Advanced Patterns

### Arena Patterns

Multiple heap regions:

```
Multi-arena approach:
  Separate heaps for purposes
  Independent management
  Different policies possible

Use cases:
  Temporary vs permanent
  Different phases
  Isolation of concerns
```

### Hybrid Management

Combining strategies:

```
Hybrid heap:
  Bump for most allocations
  Special handling for specific patterns
  Application-aware optimization

Benefits:
  Flexibility where needed
  Simplicity where sufficient
```

### Phase-Based Allocation

Allocation by execution phase:

```
Phase-based approach:
  Different heaps per phase
  Reset between phases
  Reclaim memory at boundaries

Benefits:
  Memory reuse
  Still simple
  Natural for many algorithms
```

## Debugging and Diagnostics

### Allocation Tracking

Tracking allocations:

```
Tracking information:
  Allocation sites (development)
  Sizes requested
  Cumulative statistics

Use:
  Debugging memory issues
  Optimization
  Development only typically
```

### Heap Dumps

Examining heap state:

```
Heap dump contents:
  Current state
  Allocation history
  Memory layout

Purpose:
  Debugging
  Analysis
  Not for production proofs
```

### Usage Analysis

Understanding heap usage:

```
Analysis metrics:
  Peak usage
  Average allocation size
  Allocation frequency
  Utilization efficiency
```

## Key Concepts

- **Heap region**: Dynamically allocated memory area
- **Heap boundaries**: Start and end of heap space
- **Growth management**: Controlling heap expansion
- **Memory pressure**: Approaching heap limits
- **Alignment management**: Meeting address requirements
- **Arena pattern**: Multiple independent heaps

## Design Trade-offs

### Size vs Safety

| Large Heap | Small Heap |
|------------|------------|
| More room | Less room |
| Handles spikes | May exhaust |
| More constraints | Fewer constraints |
| Resource waste | Efficient |

### Simplicity vs Features

| Simple Bump | Complex Allocator |
|-------------|-------------------|
| One pointer | Multiple structures |
| Fast | Slower |
| No free | Individual free |
| Less flexible | More flexible |

### Static vs Dynamic Sizing

| Static Size | Dynamic Growth |
|-------------|----------------|
| Known bounds | Flexible |
| Simpler proof | Complex proof |
| May under/over size | Adapts to needs |
| Predictable | Variable |

## Related Topics

- [Bump Allocator](01-bump-allocator.md) - Allocation mechanism
- [Memory Layout](../../04-zkvm-architecture/03-memory-model/01-memory-layout.md) - Address space
- [Memory Consistency](../../04-zkvm-architecture/03-memory-model/02-memory-consistency.md) - Consistency model
- [Runtime Architecture](../01-operating-system/01-runtime-architecture.md) - Runtime design

