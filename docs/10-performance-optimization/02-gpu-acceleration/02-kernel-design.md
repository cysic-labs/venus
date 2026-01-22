# GPU Kernel Design

## Overview

GPU kernel design is the art of structuring computations to exploit GPU architecture effectively. A kernel is a function executed in parallel across thousands of GPU threads, and its design determines whether the GPU achieves a fraction or the majority of its theoretical performance.

Well-designed kernels match the GPU's execution model, maximize parallelism, minimize memory latency, and avoid bottlenecks. Poorly designed kernels may perform worse than CPU implementations despite the GPU's raw computational power. For zkVM proof generation, where the same kernels execute billions of times, kernel design quality directly translates to proving time.

This document explores kernel design principles, patterns, and optimization strategies for zero-knowledge workloads.

## Kernel Structure Fundamentals

### Thread Organization

Kernels specify their parallel structure through launch configuration:

```
Kernel Launch:
kernel<<<grid_dim, block_dim>>>(arguments)

grid_dim: Number of blocks
block_dim: Threads per block

Total threads = grid_dim * block_dim
```

Each thread receives unique identifiers:

```
Thread identification:
blockIdx.x, blockIdx.y, blockIdx.z    // Block position in grid
threadIdx.x, threadIdx.y, threadIdx.z  // Thread position in block
blockDim.x, blockDim.y, blockDim.z     // Block dimensions
gridDim.x, gridDim.y, gridDim.z        // Grid dimensions

Global thread ID (1D case):
global_id = blockIdx.x * blockDim.x + threadIdx.x
```

### Work Mapping Strategies

How threads map to data elements:

**One thread per element**:
```
Thread 0 -> Element 0
Thread 1 -> Element 1
...
Simple but requires enough elements for full GPU utilization.
```

**One thread per multiple elements**:
```
Thread 0 -> Elements 0, 1024, 2048, ...
Thread 1 -> Elements 1, 1025, 2049, ...
...
Handles larger data with fixed thread count.
```

**Collaborative processing**:
```
Multiple threads cooperate on one complex element.
Example: Warp cooperates on single large integer multiplication.
```

### Block Size Selection

Block size affects performance significantly:

**Factors to consider**:
- Multiple of warp size (32) for efficiency
- Enough threads to hide latency (typically 128-512)
- Resource constraints (registers, shared memory)
- Problem-specific requirements

**Common choices**:
```
256 threads: Good default, balances occupancy and resources
512 threads: More parallelism, higher shared memory potential
128 threads: When needing more registers per thread
64 threads: Special cases with very high register pressure
```

## Memory Access Patterns

### Coalesced Global Memory Access

Critical for global memory performance:

```
Coalesced (efficient):
Thread 0 reads address 0x1000
Thread 1 reads address 0x1004
Thread 2 reads address 0x1008
...
Consecutive threads access consecutive addresses.
Single memory transaction serves entire warp.

Non-coalesced (inefficient):
Thread 0 reads address 0x1000
Thread 1 reads address 0x2000
Thread 2 reads address 0x3000
...
Each thread requires separate transaction.
```

**Achieving coalescing**:
```
Good: output[threadIdx.x] = input[threadIdx.x]
Bad: output[threadIdx.x] = input[threadIdx.x * stride]
```

### Shared Memory Usage

Using shared memory effectively:

```
Pattern: Load globally, process locally, store globally

__shared__ float tile[BLOCK_SIZE];

// Collaborative load (coalesced)
tile[threadIdx.x] = global_input[global_id];
__syncthreads();

// Local processing (fast, potentially non-coalesced patterns OK)
result = process(tile, threadIdx.x);
__syncthreads();

// Store (coalesced)
global_output[global_id] = result;
```

### Avoiding Bank Conflicts

Shared memory is organized in banks:

```
32 banks, 4-byte words in consecutive banks

Bank assignment:
Address % 128 / 4 = bank number

No conflict:
tile[threadIdx.x]  // Consecutive, different banks

2-way conflict:
tile[threadIdx.x * 2]  // Threads 0,16 hit bank 0

Broadcast (no conflict):
tile[0]  // All threads read same address
```

**Padding technique**:
```
// Original (conflicts)
__shared__ float tile[32][32];
tile[threadIdx.y][threadIdx.x];  // Column access has conflicts

// Padded (no conflicts)
__shared__ float tile[32][33];   // Extra column padding
tile[threadIdx.y][threadIdx.x];  // Column access conflict-free
```

### Register Optimization

Managing register usage:

```
Techniques:
- Reuse variables rather than creating new ones
- Break complex expressions into reusable parts
- Explicitly control unrolling
- Consider trading registers for shared memory
```

## Control Flow Design

### Minimizing Warp Divergence

Warp divergence serializes execution:

```
Divergent (slow):
if (threadIdx.x % 2 == 0) {
    result = expensive_a();
} else {
    result = expensive_b();
}
// Half threads wait during each branch

Non-divergent (fast):
// All threads in warp take same path
if (threadIdx.x < warpSize) {
    result = expensive_a();
}
```

**Restructuring for convergence**:
```
// Instead of per-thread condition
for (int i = 0; i < variable_count[threadIdx.x]; i++) {...}

// Process in waves where all threads have same iteration count
int max_count = warp_max(variable_count[threadIdx.x]);
for (int i = 0; i < max_count; i++) {
    if (i < variable_count[threadIdx.x]) {...}
}
```

### Predication vs. Branching

Short conditional code can use predication:

```
Branching (divergent):
if (condition) {
    x = a;
} else {
    x = b;
}

Predicated (non-divergent):
x = condition ? a : b;
// Compiler generates predicated instructions, no divergence
```

### Early Exit Patterns

Handling threads that finish early:

```
Pattern: Mask inactive threads
while (active) {
    // Work
    active = check_condition();
    // Inactive threads still loop but do no work
}

Alternative: Return early (causes divergence until all exit)
while (true) {
    if (!check_condition()) return;
    // Work
}
```

## Synchronization Patterns

### Block-Level Synchronization

Ensuring all threads reach a point:

```
// Load phase
shared_data[threadIdx.x] = global_data[global_id];
__syncthreads();  // All threads must complete load

// Compute phase (can access any shared_data element)
result = compute(shared_data);
__syncthreads();  // Ensure computation complete before next iteration
```

### Warp-Level Operations

Efficient communication within a warp:

```
// Shuffle: exchange data between warp threads
int partner_value = __shfl_xor_sync(0xffffffff, my_value, 1);
// Thread i exchanges with thread i^1

// Reduction: sum across warp
int warp_sum = my_value;
warp_sum += __shfl_xor_sync(0xffffffff, warp_sum, 16);
warp_sum += __shfl_xor_sync(0xffffffff, warp_sum, 8);
warp_sum += __shfl_xor_sync(0xffffffff, warp_sum, 4);
warp_sum += __shfl_xor_sync(0xffffffff, warp_sum, 2);
warp_sum += __shfl_xor_sync(0xffffffff, warp_sum, 1);
```

### Atomic Operations

Thread-safe updates to shared state:

```
// Atomic increment
atomicAdd(&counter, 1);

// Compare and swap
atomicCAS(&value, expected, new_value);

// Custom atomic using CAS
while (true) {
    old = value;
    new = custom_operation(old);
    if (atomicCAS(&value, old, new) == old) break;
}
```

Atomics serialize access but enable lock-free coordination.

## Common Kernel Patterns

### Map Pattern

Apply function to each element:

```
__global__ void map_kernel(float* output, float* input, int n) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < n) {
        output[idx] = function(input[idx]);
    }
}
```

### Reduce Pattern

Combine elements to single result:

```
__global__ void reduce_kernel(float* output, float* input, int n) {
    __shared__ float sdata[BLOCK_SIZE];

    int tid = threadIdx.x;
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    // Load and first reduction
    sdata[tid] = (idx < n) ? input[idx] : 0;
    __syncthreads();

    // Tree reduction in shared memory
    for (int s = blockDim.x / 2; s > 0; s >>= 1) {
        if (tid < s) {
            sdata[tid] += sdata[tid + s];
        }
        __syncthreads();
    }

    // Write block result
    if (tid == 0) output[blockIdx.x] = sdata[0];
}
```

### Scan (Prefix Sum) Pattern

Compute running totals:

```
Each output[i] = sum of input[0..i]

Parallel scan algorithm:
1. Up-sweep: reduce to get partial sums
2. Down-sweep: distribute partial sums
```

### Stencil Pattern

Each output depends on neighborhood of inputs:

```
__global__ void stencil_kernel(float* output, float* input, int n) {
    __shared__ float tile[BLOCK_SIZE + 2 * RADIUS];

    int gid = blockIdx.x * blockDim.x + threadIdx.x;
    int lid = threadIdx.x + RADIUS;

    // Load center
    tile[lid] = input[gid];

    // Load halo
    if (threadIdx.x < RADIUS) {
        tile[lid - RADIUS] = input[gid - RADIUS];
        tile[lid + BLOCK_SIZE] = input[gid + BLOCK_SIZE];
    }
    __syncthreads();

    // Apply stencil
    float result = 0;
    for (int i = -RADIUS; i <= RADIUS; i++) {
        result += tile[lid + i] * weights[i + RADIUS];
    }
    output[gid] = result;
}
```

## zkVM-Specific Kernels

### NTT Butterfly Kernel

Core transform operation:

```
Design considerations:
- Process multiple butterflies per thread
- Use shared memory for stage-local data
- Coalesce global memory access at stage boundaries
- Handle twiddle factors efficiently

Structure:
1. Load polynomial segment to shared memory
2. Perform multiple butterfly stages locally
3. Store results, synchronized for next stage
```

### Field Multiplication Kernel

Modular arithmetic in parallel:

```
Design considerations:
- 64-bit multiplication producing 128-bit result
- Montgomery reduction for efficiency
- Goldilocks-specific fast reduction possible
- Balance between threads and elements per thread

Structure:
1. Load operands (coalesced)
2. Multiply to extended precision
3. Reduce modulo prime
4. Store results (coalesced)
```

### Hash Function Kernel

Parallel hashing for Merkle trees:

```
Design considerations:
- Each hash independent (perfect parallelism)
- Internal state fits in registers
- Input loading must be coalesced
- May process multiple hashes per thread

Structure:
1. Load message blocks
2. Initialize hash state
3. Process rounds
4. Output digest
```

### Polynomial Evaluation Kernel

Evaluate at multiple points:

```
Design considerations:
- Each evaluation point independent
- Horner's method for efficiency
- Coefficient access pattern
- Balance between points and coefficients

Structure:
1. Load coefficients to shared memory
2. Each thread handles one evaluation point
3. Horner iteration through coefficients
4. Store results
```

## Performance Tuning

### Occupancy Optimization

Achieving high SM utilization:

```
Analyze resource usage:
- Registers per thread: Check compiler output
- Shared memory per block: Sum of declarations
- Threads per block: Launch configuration

Tools:
- CUDA Occupancy Calculator
- Nsight Compute profiling
```

### Memory Throughput

Maximizing memory bandwidth:

```
Profiling questions:
- What is achieved vs. peak bandwidth?
- Are accesses coalesced?
- Is there bank conflict in shared memory?
- Could data be reused more?

Techniques:
- Adjust data layout for coalescing
- Pad shared memory to avoid conflicts
- Increase arithmetic intensity
```

### Instruction Throughput

Saturating compute units:

```
Profiling questions:
- What is IPC (instructions per cycle)?
- Which execution units are bottleneck?
- Is there instruction-level parallelism?

Techniques:
- Unroll loops for more ILP
- Use FMA (fused multiply-add)
- Avoid special functions in hot loops
```

## Key Concepts

- **Kernel**: GPU function executed in parallel across threads
- **Launch configuration**: Grid and block dimensions
- **Coalescing**: Memory access pattern enabling efficient transfer
- **Bank conflict**: Shared memory access serialization
- **Warp divergence**: Threads in warp taking different paths
- **Occupancy**: Active warps relative to maximum
- **Predication**: Conditional without branching
- **Shuffle**: Data exchange within warp

## Design Trade-offs

### Block Size Selection

| Block Size | Pros | Cons |
|------------|------|------|
| Small (64-128) | More registers/thread, more blocks | Less shared memory utility |
| Medium (256) | Balanced | General purpose |
| Large (512-1024) | More shared memory, less launch overhead | Register pressure, lower occupancy |

### Shared Memory vs. Registers

| Approach | Benefits | Costs |
|----------|----------|-------|
| Heavy shared memory | Data reuse, flexible access | Lower occupancy, sync overhead |
| Heavy registers | Fastest access, no sync | Limited, no sharing between threads |

### Kernel Fusion vs. Separation

| Strategy | Benefits | Costs |
|----------|----------|-------|
| Fused kernels | Less launch overhead, data in registers | Complexity, register pressure |
| Separate kernels | Simpler, modular | Launch overhead, memory traffic |

## Related Topics

- [CUDA Architecture](01-cuda-architecture.md) - GPU hardware fundamentals
- [GPU Memory Management](03-memory-management.md) - Memory optimization strategies
- [NTT and FFT](../../01-mathematical-foundations/02-polynomials/02-ntt-and-fft.md) - Key algorithm for GPU acceleration
- [Batch Processing](../03-algorithmic-optimization/01-batch-processing.md) - Structuring work for GPU
- [SIMD Vectorization](../01-cpu-optimization/01-simd-vectorization.md) - CPU parallel comparison
