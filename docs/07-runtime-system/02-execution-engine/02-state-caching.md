# State Caching

## Overview

State caching optimizes execution and witness generation by storing and reusing computed values. The interpreter and trace generator frequently access the same data: register values are read multiple times, memory addresses are computed repeatedly, and auxiliary values may be needed in multiple contexts. Caching reduces redundant computation and memory access, improving overall performance.

Effective caching requires understanding access patterns and balancing memory usage against computation savings. Too little caching results in redundant work; too much caching consumes excessive memory and may cause cache misses that harm performance. This document covers caching strategies, cache designs, and performance considerations for zkVM execution.

## Caching Strategies

### Register Caching

Fast access to register values:

```
Register access patterns:
  Same register read multiple times per instruction
  Recent registers likely to be accessed again
  x0 always zero (trivial cache)

Caching approach:
  Keep all 32 registers in fast memory
  Direct array access (no hash lookup)
  Update on write, read anytime

Implementation:
  uint64_t reg_cache[32];
  reg_cache[0] = 0;  // Always zero

  uint64_t read_reg(int idx) {
    return reg_cache[idx];
  }

  void write_reg(int idx, uint64_t val) {
    if (idx != 0) reg_cache[idx] = val;
  }
```

### Memory Caching

Recently accessed memory:

```
Memory access patterns:
  Spatial locality: Adjacent addresses
  Temporal locality: Recent addresses
  Stack operations: Push/pop patterns

Cache structure:
  Line-based cache (like CPU cache)
  Hash map for random access
  LRU eviction for bounded size

Implementation:
  struct CacheLine {
    uint64_t tag;
    uint8_t data[64];  // 64-byte line
    bool valid;
    bool dirty;
  };

  CacheLine cache[NUM_LINES];

  // Access: Check cache, fallback to main memory
```

### Instruction Caching

Recently decoded instructions:

```
Instruction access patterns:
  Loops execute same instructions
  Small hot code sections
  Decode is expensive

Cache structure:
  PC -> Decoded instruction
  Fixed-size LRU cache
  Invalidate on self-modifying code (rare)

Benefits:
  Skip decode for repeated instructions
  Significant for tight loops
```

## Cache Designs

### Direct-Mapped Cache

Simple, fast cache:

```
Structure:
  index = address % cache_size
  One entry per index

Lookup:
  line = cache[addr % size]
  if line.tag == addr // size:
    return line.data
  else:
    miss, load from memory

Properties:
  Fast (no search)
  Conflict misses possible
  Simple implementation
```

### Set-Associative Cache

Reduced conflicts:

```
Structure:
  set = address % num_sets
  ways_per_set entries to check

Lookup:
  set = cache_sets[addr % num_sets]
  for way in set:
    if way.tag == addr_tag:
      return way.data
  miss, load and evict LRU

Properties:
  Fewer conflicts than direct-mapped
  More complex lookup
  Better hit rate
```

### Fully Associative Cache

Maximum flexibility:

```
Structure:
  Any entry can hold any address
  Search all entries on lookup

Lookup:
  for entry in cache:
    if entry.tag == addr:
      return entry.data
  miss

Properties:
  No conflicts
  Expensive lookup (unless small)
  Used for small, specialized caches
```

## Value Caching

### Computed Value Cache

Caching expensive computations:

```
Expensive operations:
  Modular inverse
  Large multiplications
  Hash computations

Cache approach:
  input -> output mapping
  Check cache before computing
  Store result after computing

Example:
  inverse_cache = {}

  def cached_inverse(val, p):
    if val in inverse_cache:
      return inverse_cache[val]
    inv = pow(val, p-2, p)
    inverse_cache[val] = inv
    return inv
```

### Auxiliary Value Cache

Caching trace auxiliaries:

```
Auxiliary patterns:
  Same decomposition multiple times
  Repeated comparisons
  Common intermediate values

Cache structure:
  (value, aux_type) -> aux_value
  Bounded size with eviction

Example:
  byte_decomp_cache = {}

  def cached_byte_decompose(val):
    if val in byte_decomp_cache:
      return byte_decomp_cache[val]
    bytes = [val >> (i*8) & 0xFF for i in range(8)]
    byte_decomp_cache[val] = bytes
    return bytes
```

### Address Translation Cache

Memory address mappings:

```
Translation patterns:
  Virtual to physical (if applicable)
  Address to memory region
  Address to trace row index

TLB-like cache:
  page_number -> frame_info
  Fast lookup for common pages

Example:
  region_cache = {}

  def get_memory_region(addr):
    page = addr >> 12
    if page in region_cache:
      return region_cache[page]
    region = compute_region(addr)
    region_cache[page] = region
    return region
```

## Cache Management

### Cache Invalidation

Keeping cache consistent:

```
When to invalidate:
  Memory write: Invalidate affected cache lines
  Register write: Update register cache
  State rollback: Clear relevant caches

Strategies:
  Write-through: Update cache and backing store
  Write-back: Update cache, mark dirty, flush later
  Invalidate: Remove from cache on write

Example:
  def write_memory(addr, val):
    cache_line = get_cache_line(addr)
    if cache_line:
      cache_line.invalidate()
    memory[addr] = val
```

### Cache Sizing

Choosing cache size:

```
Factors:
  Available memory
  Working set size
  Hit rate targets

Trade-offs:
  Larger cache: Higher hit rate, more memory
  Smaller cache: Lower hit rate, less memory

Sizing heuristics:
  Register cache: Always 32 entries
  Instruction cache: Cover main loop
  Memory cache: Fraction of working set
```

### Eviction Policies

Choosing what to evict:

```
LRU (Least Recently Used):
  Evict oldest accessed entry
  Good general policy
  Requires tracking access order

FIFO (First In First Out):
  Evict oldest added entry
  Simpler than LRU
  May evict frequently used items

Random:
  Evict random entry
  Simplest implementation
  Surprisingly effective sometimes
```

## Performance Considerations

### Hit Rate Analysis

Measuring cache effectiveness:

```
Metrics:
  Hit rate = hits / (hits + misses)
  Miss rate = 1 - hit rate
  Average access time = hit_time + miss_rate * miss_penalty

Monitoring:
  Count hits and misses
  Log cache statistics
  Identify hot spots

Tuning:
  Increase size if miss rate high
  Decrease if memory constrained
```

### Cache Coherence

Maintaining consistency:

```
Single-threaded:
  No coherence issues
  Simple invalidation sufficient

Multi-threaded (if applicable):
  Need coherence protocol
  Or per-thread caches
  Or shared cache with locking
```

### Prefetching

Anticipating access:

```
Patterns:
  Sequential memory access
  Stride patterns
  Loop-based access

Prefetch strategy:
  Fetch next line on access
  Prefetch based on stride
  Speculative prefetch

Benefits:
  Hide memory latency
  Improve throughput
```

## Integration with Witness Generation

### Trace Caching

Caching trace data:

```
Pattern:
  Recent trace rows accessed multiple times
  Auxiliary computation references previous rows

Cache:
  Last N trace rows in memory
  Quick access for back-references

Implementation:
  circular_buffer<TraceRow> recent_rows;

  void add_row(TraceRow row) {
    recent_rows.push(row);
  }

  TraceRow& get_recent(int offset) {
    return recent_rows[current - offset];
  }
```

### Lookup Table Caching

Caching table access:

```
Lookup patterns:
  Same lookup repeated (range checks)
  Sequential table access
  Hot table entries

Cache:
  Recent lookup results
  Entry index -> result

Benefits:
  Reduce table access overhead
  Faster witness generation
```

## Key Concepts

- **State caching**: Storing values for reuse
- **Cache hit/miss**: Found or not found in cache
- **Eviction policy**: Choosing what to remove
- **Cache coherence**: Keeping cache consistent
- **Prefetching**: Anticipating future access

## Design Considerations

### Cache Granularity

| Fine-Grained | Coarse-Grained |
|--------------|----------------|
| Individual values | Blocks/pages |
| Higher overhead | Lower overhead |
| Better precision | Potential waste |
| More complex | Simpler |

### Memory Trade-offs

| Large Cache | Small Cache |
|-------------|-------------|
| Higher hit rate | Lower hit rate |
| More memory | Less memory |
| Potentially slower lookup | Faster lookup |
| Better for large working sets | Better for small working sets |

## Related Topics

- [Interpreter Design](01-interpreter-design.md) - Execution context
- [Execution Trace Generation](../01-witness-generation/01-execution-trace-generation.md) - Trace production
- [Memory Emulation](../../06-emulation-layer/01-risc-v-emulation/03-memory-emulation.md) - Memory access
- [Constraint Optimization](../../10-performance-optimization/01-prover-optimization/01-constraint-optimization.md) - Performance
