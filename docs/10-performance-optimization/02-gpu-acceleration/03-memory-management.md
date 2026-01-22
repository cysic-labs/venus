# GPU Memory Management

## Overview

GPU memory management is the discipline of efficiently allocating, transferring, and accessing data on graphics processors. In zero-knowledge proof systems, where data sets can span gigabytes and memory operations often dominate runtime, effective memory management determines whether GPU acceleration delivers its promised performance.

GPUs present a fundamentally different memory landscape than CPUs: physically separate memory spaces, different access characteristics, and a memory hierarchy optimized for throughput rather than latency. Understanding these differences and developing strategies to exploit them is essential for high-performance GPU-accelerated proving.

This document explores GPU memory concepts, transfer strategies, allocation patterns, and optimization techniques for zkVM workloads.

## GPU Memory Spaces

### Device Memory (Global Memory)

Primary GPU memory, analogous to CPU RAM:

```
Characteristics:
- Capacity: 16-80 GB on modern GPUs
- Bandwidth: 1-2 TB/s
- Latency: ~400 clock cycles
- Scope: Accessible by all threads
- Persistence: Remains across kernel launches
```

**Access patterns matter significantly**:
```
Coalesced access (efficient):
Threads 0-31 access addresses 0-31 -> Single transaction

Strided access (inefficient):
Threads 0-31 access addresses 0, 128, 256... -> 32 transactions
```

### Shared Memory

Fast on-chip memory shared within a thread block:

```
Characteristics:
- Capacity: 48-164 KB per SM
- Bandwidth: ~10 TB/s
- Latency: ~20 cycles
- Scope: Threads within same block
- Persistence: Only during block execution
```

**Shared memory as programmer-managed cache**:
```
Usage pattern:
1. Load data from global memory to shared memory (coalesced)
2. Synchronize threads
3. Process using shared memory (fast random access)
4. Synchronize threads
5. Store results to global memory (coalesced)
```

### Registers

Per-thread private storage:

```
Characteristics:
- Capacity: ~256 registers per thread (varies by architecture)
- Bandwidth: ~20 TB/s effective
- Latency: 0 additional cycles
- Scope: Single thread only
- Persistence: Thread lifetime
```

**Register pressure**: Exceeding available registers causes spilling to local memory (slow).

### Local Memory

Per-thread spillover storage:

```
Characteristics:
- Physically in global memory
- Same latency as global memory
- Automatic compiler allocation for register spills
- Should be minimized
```

### Constant Memory

Read-only memory with dedicated cache:

```
Characteristics:
- Capacity: 64 KB
- Broadcast-efficient (all threads reading same address)
- Cached per SM
- Ideal for coefficients, parameters, lookup tables
```

### Texture Memory

Read-only with spatial caching:

```
Characteristics:
- Optimized for 2D spatial access patterns
- Hardware interpolation support
- Less commonly used in zkVM applications
```

## Host-Device Memory Transfer

### Transfer Mechanisms

Moving data between CPU and GPU:

```
PCIe bandwidth limits:
- PCIe 3.0 x16: ~12 GB/s
- PCIe 4.0 x16: ~25 GB/s
- PCIe 5.0 x16: ~50 GB/s

Compare to device memory: ~2000 GB/s
Transfer is often the bottleneck.
```

### Synchronous vs. Asynchronous Transfers

**Synchronous transfer**:
```
Operation flow:
CPU: [Setup] -> [Wait for transfer] -> [Continue]
GPU:            [Transfer data]
```

**Asynchronous transfer**:
```
Operation flow:
CPU: [Setup] -> [Continue other work] -> [Check completion]
GPU:            [Transfer data]
```

Asynchronous enables overlap of transfer and computation.

### Pinned (Page-Locked) Memory

Host memory that cannot be paged out:

```
Benefits:
- Higher transfer bandwidth
- Enables asynchronous transfers
- Required for GPU direct memory access

Costs:
- Reduces available system memory
- Allocation is more expensive
- Must be explicitly freed
```

### Unified Memory

Single address space spanning CPU and GPU:

```
Programming model:
// Allocate unified memory
ptr = allocate_unified(size);

// Access from CPU
ptr[0] = value;

// Access from GPU (automatic migration)
kernel<<<grid, block>>>(ptr);
```

**Benefits**:
- Simplified programming
- Automatic data migration
- Handles oversubscription

**Costs**:
- Page fault overhead
- Less predictable performance
- May not achieve peak bandwidth

## Memory Allocation Strategies

### Pre-allocation

Allocate all needed memory before computation:

```
Benefits:
- No allocation during computation
- Predictable memory usage
- Enables memory reuse

Pattern:
1. Calculate total memory needs
2. Allocate all buffers
3. Execute computation phases
4. Free all buffers
```

### Memory Pools

Reusable memory allocation:

```
Pool structure:
+------------------------------------------+
| [Free Block] [Used] [Used] [Free Block]  |
+------------------------------------------+

Allocation: Find suitable free block
Deallocation: Mark block as free

Benefits:
- Fast allocation/deallocation
- Reduced fragmentation
- Predictable performance
```

### Double Buffering

Two buffers for overlapping transfer and compute:

```
Time step 1:
Buffer A: [Processing on GPU]
Buffer B: [Transferring from CPU]

Time step 2:
Buffer A: [Transferring results to CPU]
Buffer B: [Processing on GPU]

Continuous pipeline:
Transfer -> Compute -> Transfer -> Compute -> ...
```

### Memory Mapping

Map device memory to host address space:

```
Use cases:
- Accessing GPU memory directly from CPU
- Zero-copy operations for small data
- Unified memory programming model
```

## Memory Access Optimization

### Coalescing Strategies

Ensuring efficient global memory access:

```
Structure of Arrays (SoA) - coalesce-friendly:
x: [x0, x1, x2, x3, ...]
y: [y0, y1, y2, y3, ...]
z: [z0, z1, z2, z3, ...]

Array of Structures (AoS) - not coalesce-friendly:
[(x0,y0,z0), (x1,y1,z1), (x2,y2,z2), ...]

SoA enables coalesced access when threads process same field.
```

### Shared Memory Optimization

Avoiding bank conflicts:

```
32 banks, 4-byte granularity

Conflict-free patterns:
- Sequential access: thread i accesses word i
- Strided by odd number: thread i accesses word (i * odd)

Conflict patterns:
- Strided by power of 2: thread i accesses word (i * 32)
  All threads hit bank 0

Resolution:
- Padding: Add extra elements to shift bank alignment
- Access reordering: Change which thread accesses which element
```

### Memory Alignment

Ensuring aligned access:

```
Requirements:
- 32-bit access aligned to 4 bytes
- 64-bit access aligned to 8 bytes
- 128-bit access aligned to 16 bytes
- Vector access aligned to vector size

Benefits of alignment:
- Single memory transaction
- No hardware splitting of access
- Better cache behavior
```

### Caching Behavior

Understanding and exploiting caches:

```
L1 Cache (per SM):
- Small, fast
- Configurable size (vs. shared memory)
- Automatic caching of global memory

L2 Cache (global):
- Larger, shared across SMs
- Caches all global memory access
- Important for data reuse across blocks

Cache-friendly patterns:
- Temporal locality: Reuse data soon after loading
- Spatial locality: Access nearby addresses
```

## Memory-Bound Optimization

### Arithmetic Intensity

Ratio of computation to memory access:

```
Arithmetic Intensity = FLOPs / Bytes Transferred

Low intensity (memory-bound):
output[i] = input[i] + 1;  // 1 op, 8+ bytes

High intensity (compute-bound):
for (int j = 0; j < N; j++)
    result += data[j] * coeffs[j];  // N ops, few bytes
```

**Roofline model**: Performance limited by memory bandwidth until arithmetic intensity exceeds certain threshold.

### Increasing Reuse

Strategies to improve arithmetic intensity:

```
Tiling:
Process data in blocks that fit in fast memory.
Reuse loaded data for multiple computations.

Kernel fusion:
Combine multiple operations into single kernel.
Intermediate results stay in registers/shared memory.

Redundant computation:
Sometimes faster to recompute than to store and reload.
```

### Compression

Reducing data transfer volume:

```
Approaches:
- Delta encoding for slowly-changing data
- Sparse representations for mostly-zero data
- Domain-specific encoding

Trade-off: Compression/decompression vs. transfer time
```

## Multi-GPU Memory

### Memory Distribution

Partitioning data across GPUs:

```
Strategies:

Replication: Same data on all GPUs
- Simplest programming model
- Wastes memory
- Good for read-only data

Partitioning: Different data on each GPU
- Efficient memory use
- Requires coordination
- Good for independent processing

Hybrid: Some replicated, some partitioned
- Balance of simplicity and efficiency
- Most common in practice
```

### Inter-GPU Communication

Moving data between GPUs:

```
Methods (fastest to slowest):
1. NVLink direct transfer: 300-600 GB/s
2. PCIe peer-to-peer: 16-25 GB/s
3. Through host memory: 12-25 GB/s (two transfers)

Considerations:
- Topology affects available paths
- Not all GPU pairs can peer directly
- Unified memory handles automatically but with overhead
```

### Memory Pool Sharing

Coordinated allocation across GPUs:

```
Challenges:
- Each GPU has separate memory space
- Allocation must be coordinated
- Deallocation must be synchronized

Solutions:
- Central coordinator tracks all allocations
- Each GPU maintains local pool
- Cross-GPU requests go through coordinator
```

## zkVM Memory Patterns

### Polynomial Storage

Polynomials are primary data structures:

```
Storage requirements:
- Coefficient form: N field elements
- Evaluation form: N field elements
- Extended (LDE): 2N-8N field elements

Memory layout:
[poly0_coeffs | poly0_evals | poly1_coeffs | poly1_evals | ...]

Optimization:
- In-place transformation when possible
- Overlap coefficient and evaluation storage
```

### Merkle Tree Memory

Tree construction requires careful memory management:

```
Memory for tree with N leaves:
- Leaves: N * digest_size
- Internal nodes: (N-1) * digest_size
- Total: ~2N * digest_size

Access pattern:
- Leaves: highly parallel, sequential access
- Higher levels: less parallel, different access pattern
```

### Witness and Trace Storage

Execution trace memory:

```
Trace dimensions:
- Width: Number of columns (registers, memory, etc.)
- Height: Number of execution steps

Storage: width * height * field_element_size

Optimization:
- Columnar storage for NTT processing
- Batched access patterns
```

## Key Concepts

- **Coalescing**: Memory access pattern enabling efficient transactions
- **Bank conflict**: Shared memory serialization from same-bank access
- **Pinned memory**: Page-locked host memory for fast transfers
- **Unified memory**: Single address space across CPU and GPU
- **Memory pool**: Pre-allocated reusable memory
- **Double buffering**: Overlapping transfer and compute
- **Arithmetic intensity**: Ratio of computation to memory access
- **Register spilling**: Overflow from registers to slow local memory

## Design Trade-offs

### Memory Space Selection

| Memory Type | Capacity | Speed | Sharing | Best For |
|-------------|----------|-------|---------|----------|
| Global | Large | Slow | All threads | Primary data storage |
| Shared | Small | Fast | Block | Cooperative data |
| Registers | Tiny | Fastest | Thread | Temporaries |
| Constant | Small | Fast (cached) | All threads | Read-only params |

### Transfer Strategy

| Strategy | Throughput | Latency | Complexity |
|----------|------------|---------|------------|
| Synchronous | Lower | Higher | Simple |
| Asynchronous | Higher | Hidden | Moderate |
| Unified memory | Variable | Hidden | Simple |
| Pinned + async | Highest | Hidden | Complex |

### Allocation Strategy

| Strategy | Allocation Speed | Fragmentation | Predictability |
|----------|------------------|---------------|----------------|
| On-demand | Slow | High | Low |
| Pre-allocation | N/A (upfront) | None | High |
| Memory pool | Fast | Low | High |

## Related Topics

- [CUDA Architecture](01-cuda-architecture.md) - GPU hardware fundamentals
- [GPU Kernel Design](02-kernel-design.md) - Using memory in kernels
- [Multi-Threading](../01-cpu-optimization/02-multi-threading.md) - CPU memory considerations
- [Batch Processing](../03-algorithmic-optimization/01-batch-processing.md) - Organizing data for transfer
- [Trace Commitment](../../02-stark-proving-system/04-proof-generation/02-trace-commitment.md) - Memory-intensive operation
