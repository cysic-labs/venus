# Bump Allocator

## Overview

A bump allocator is the simplest possible dynamic memory allocation strategy, making it ideally suited for zkVM environments. The allocator maintains a single pointer that advances through available memory with each allocation. Memory is never freed individually; instead, all allocations persist until execution completes or the entire arena is reset.

The simplicity of bump allocation translates directly to proof efficiency. Each allocation requires minimal state tracking, produces straightforward constraints, and involves only a single pointer increment. This makes bump allocation the default choice for zkVM runtimes where proving time matters more than memory flexibility.

This document covers bump allocator design, implementation considerations, and trade-offs in the zkVM context.

## Allocation Concept

### Basic Mechanism

How bump allocation works:

```
Bump allocator state:
  Current pointer (next free address)
  End boundary (allocation limit)

Allocation process:
  1. Check if space available
  2. Return current pointer
  3. Advance pointer by size
  4. (Apply alignment if needed)

No deallocation:
  Pointer only moves forward
  Memory never reclaimed
  All allocations persist
```

### Visual Representation

Memory progression:

```
Initial state:
  [----------free-----------]
   ^                        ^
   current                  end

After allocation A (16 bytes):
  [AAAAAAA|-----free-------]
          ^                ^
          current          end

After allocation B (8 bytes):
  [AAAAAAA|BBBB|---free---]
               ^          ^
               current    end

After allocation C (12 bytes):
  [AAAAAAA|BBBB|CCCCCC|free]
                      ^   ^
                      curr end
```

## Design Principles

### Simplicity

Minimal implementation complexity:

```
State requirements:
  Single pointer (current position)
  Single boundary (end limit)
  Optional: start address

Operations:
  Allocate: Compare and increment
  Reset: Set to start (if supported)
  Query: Return current position
```

### Determinism

Perfectly deterministic behavior:

```
Deterministic properties:
  Same allocation sequence = same layout
  No fragmentation variations
  Predictable addresses
  Reproducible memory state

Why it matters:
  Proof generation requires determinism
  Verification needs consistency
  No hidden state variations
```

### Efficiency

Optimal allocation performance:

```
Time complexity:
  Allocation: O(1)
  No deallocation
  No searching

Space complexity:
  Allocator state: O(1)
  No metadata per allocation
  Pure data storage
```

## Implementation Strategy

### State Management

Tracking allocator state:

```
Minimal state:
  bump_ptr: Current allocation position

Extended state:
  bump_ptr: Current position
  heap_end: Maximum boundary
  heap_start: Initial position (for reset)

State location:
  Global memory location
  Runtime data structure
  Dedicated registers (rare)
```

### Allocation Logic

Performing an allocation:

```
Allocation steps:
  1. current = bump_ptr
  2. new_ptr = current + size
  3. if new_ptr > heap_end: fail
  4. bump_ptr = new_ptr
  5. return current

With alignment:
  1. current = align_up(bump_ptr, align)
  2. new_ptr = current + size
  3. if new_ptr > heap_end: fail
  4. bump_ptr = new_ptr
  5. return current
```

### Alignment Handling

Ensuring proper alignment:

```
Alignment calculation:
  aligned = (addr + align - 1) & ~(align - 1)

Common alignments:
  1 byte: No adjustment
  4 bytes: Word alignment
  8 bytes: Double-word alignment
  16 bytes: SIMD alignment (rare)

Default strategy:
  Word-aligned (4 bytes) typical
  Larger alignment on request
```

## Memory Layout

### Heap Region

Where bump allocation occurs:

```
Heap positioning:
  After static data
  Before stack (if shared space)
  Grows upward (increasing addresses)

Heap bounds:
  Start: First available address
  End: Maximum address before stack/limit
```

### Growth Direction

Allocation progression:

```
Typical arrangement:
  Low address: Heap start
  High address: Heap end
  Growth: Low to high

Alternative:
  High address: Heap start
  Low address: Heap end
  Growth: High to low
  (Less common)
```

### Space Management

Handling limited space:

```
Space awareness:
  Track remaining bytes
  Check before allocation
  Handle exhaustion

Exhaustion handling:
  Return null/error
  Abort execution
  Platform-specific behavior
```

## Constraint Representation

### Allocation Constraints

Proving allocation correctness:

```
Constraints for allocation:
  new_ptr = old_ptr + size
  new_ptr <= heap_end
  result = old_ptr (before update)

Properties verified:
  Pointer increases correctly
  Bounds respected
  No overlap with other regions
```

### State Transition

Proving state updates:

```
State transition:
  bump_ptr_{n+1} = bump_ptr_n + size_n

Invariants:
  heap_start <= bump_ptr <= heap_end
  monotonically increasing
  never exceeds bound
```

### Simplicity Benefits

Why bump allocation proves easily:

```
Simple constraint structure:
  Single variable tracking
  Linear progression
  No complex conditions
  No fragmentation logic

Constraint count:
  Minimal per allocation
  Linear in allocation count
  No overhead for bookkeeping
```

## Trade-offs

### Memory Efficiency

Memory utilization concerns:

```
No reclamation:
  Freed objects stay allocated
  Memory only grows
  May exhaust heap

Mitigation:
  Appropriate heap sizing
  Arena-style reset (if supported)
  Different patterns for different phases
```

### Fragmentation

Fragmentation characteristics:

```
Internal fragmentation:
  Alignment padding
  Usually minimal

External fragmentation:
  None (continuous allocation)
  No holes between allocations
```

### Flexibility Limitations

What bump allocation cannot do:

```
Not supported:
  Individual deallocation
  Reallocation in place
  Memory reclamation

Workarounds:
  Arena reset (batch free)
  Multiple allocators
  Phase-based allocation
```

## Advanced Techniques

### Arena Reset

Batch deallocation:

```
Arena reset concept:
  Reset pointer to start
  All allocations invalidated
  Memory reusable

Use cases:
  Phase-based computation
  Temporary allocations
  Scratch space

In zkVM context:
  May not be needed
  Single-use execution typical
```

### Multiple Arenas

Separate allocation regions:

```
Multi-arena approach:
  Different purposes
  Independent lifetimes
  Separate bump pointers

Examples:
  Temporary computation arena
  Long-lived data arena
  Output construction arena
```

### Stack Allocation

Combining with stack:

```
Stack-like bump:
  Save position (mark)
  Allocate normally
  Reset to mark (release)

Benefits:
  Reclamation possible
  Nested scopes
  More flexible

Complexity:
  Mark/release overhead
  Discipline required
```

## Performance Characteristics

### Allocation Speed

Time per allocation:

```
Operations required:
  Load bump pointer
  Add size
  Store new pointer
  Return old pointer

Cycle count:
  Typically 3-5 cycles
  Plus alignment if needed
  Constant time always
```

### Memory Overhead

Space for allocator:

```
Allocator overhead:
  1-3 words for state
  No per-allocation metadata
  Zero fragmentation overhead

Compare to malloc:
  Malloc: Header per allocation
  Bump: No headers needed
  Significant space savings
```

### Proving Overhead

Constraint cost:

```
Per allocation:
  Few constraints
  Simple arithmetic
  No complex logic

Total overhead:
  Proportional to allocation count
  Minimal constraint complexity
  Efficient to prove
```

## Use Cases in zkVM

### Typical Allocations

What gets bump-allocated:

```
Common allocations:
  Dynamic data structures
  Temporary buffers
  Computation workspace
  Output construction

Characteristics:
  Known lifetime
  No need for free
  Size varies
```

### Allocation Patterns

How programs use bump allocation:

```
Common patterns:
  Allocate once, use throughout
  Build data incrementally
  Construct output structure
  Phase-local temporaries
```

### Best Practices

Effective bump allocation usage:

```
Best practices:
  Know total memory needs
  Allocate early if possible
  Avoid excessive small allocations
  Consider alignment requirements
```

## Alternatives and Extensions

### When Bump Is Insufficient

Scenarios needing more:

```
Challenging scenarios:
  Long-running programs
  Memory-intensive computation
  Variable-lifetime objects

Solutions:
  Larger heap
  Application-level pooling
  Phase-based reset
```

### Hybrid Approaches

Combining strategies:

```
Hybrid allocator:
  Bump for most allocations
  Special handling for specific cases
  Application-aware management

Trade-off:
  More complexity
  Better memory utilization
  More constraints
```

## Key Concepts

- **Bump allocation**: Single-pointer advancing allocation
- **No deallocation**: Memory never individually freed
- **Alignment**: Ensuring addresses meet requirements
- **Arena**: Region managed by bump allocator
- **Monotonic growth**: Pointer only increases
- **Constraint efficiency**: Simple proof representation

## Design Trade-offs

### Simplicity vs Flexibility

| Bump Allocator | General Allocator |
|----------------|-------------------|
| One pointer | Complex structures |
| O(1) always | Variable time |
| No free | Individual free |
| Simple proofs | Complex proofs |

### Memory vs Complexity

| No Reclamation | With Reclamation |
|----------------|------------------|
| Wastes memory | Reuses memory |
| Simple | Complex |
| Fast | Slower |
| Fewer constraints | More constraints |

### Single vs Multiple Arenas

| Single Arena | Multiple Arenas |
|--------------|-----------------|
| Simplest | More flexible |
| One lifetime | Multiple lifetimes |
| One pointer | Multiple pointers |
| Less control | Fine-grained control |

## Related Topics

- [Heap Management](02-heap-management.md) - Overall heap strategy
- [Runtime Architecture](../01-operating-system/01-runtime-architecture.md) - Runtime overview
- [Memory Layout](../../04-zkvm-architecture/03-memory-model/01-memory-layout.md) - Address space organization
- [Memory Management](../../06-emulation-layer/02-execution-context/02-memory-management.md) - Emulator memory handling

