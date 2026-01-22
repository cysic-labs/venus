# SIMD Optimization

## Overview

SIMD (Single Instruction, Multiple Data) optimization exploits CPU vector processing capabilities to accelerate zkVM proving. Modern CPUs include wide vector units (AVX-256, AVX-512, ARM NEON) that can perform the same operation on multiple data elements simultaneously. For field arithmetic and polynomial operations that dominate proving time, SIMD can provide 4-8x speedup over scalar code. This optimization requires careful data layout and algorithm design to fully utilize vector capabilities.

SIMD optimization complements multi-threading: threads provide task parallelism while SIMD provides data parallelism within each thread. Combined, they can approach theoretical CPU peak performance. This document covers SIMD architectures, suitable operations, implementation techniques, and optimization strategies for SIMD-accelerated proving.

## SIMD Architectures

### x86 Vector Extensions

Intel/AMD SIMD capabilities:

```
SSE (128-bit):
  4 × 32-bit operations
  2 × 64-bit operations
  Widely available

AVX/AVX2 (256-bit):
  8 × 32-bit operations
  4 × 64-bit operations
  Most modern CPUs

AVX-512 (512-bit):
  16 × 32-bit operations
  8 × 64-bit operations
  Server CPUs, some desktop
```

### ARM Vector Extensions

ARM SIMD capabilities:

```
NEON (128-bit):
  4 × 32-bit operations
  2 × 64-bit operations
  All modern ARM

SVE/SVE2 (scalable):
  Variable width (128-2048 bit)
  Scalable vector length
  Server ARM, newer mobile
```

### Vector Registers

Register resources:

```
x86:
  SSE: 16 registers (128-bit)
  AVX: 16 registers (256-bit)
  AVX-512: 32 registers (512-bit)

ARM:
  NEON: 32 registers (128-bit)
  SVE: 32 registers (scalable)

Usage:
  More registers = more in-flight data
  Avoid register spilling
  Plan register allocation
```

## Field Arithmetic

### Vectorized Addition

Parallel field addition:

```
Scalar:
  c = (a + b) mod p
  One operation at a time

Vectorized (4-way):
  c[0:3] = (a[0:3] + b[0:3]) mod p
  Four additions simultaneously

Implementation:
  Add vectors
  Subtract p where result >= p
  Conditional operation with masks
```

### Vectorized Multiplication

Parallel field multiplication:

```
Challenge:
  Field elements often 256+ bits
  SIMD operates on 32/64-bit lanes
  Need multi-precision arithmetic

Approach:
  Represent field element as vector of limbs
  Multiply limb-by-limb
  Accumulate and reduce

Montgomery form:
  Particularly SIMD-friendly
  Reduction is regular operations
```

### Vectorized Reduction

Modular reduction with SIMD:

```
Barrett reduction:
  Precomputed constants
  Multiply-subtract pattern
  SIMD-friendly

Montgomery reduction:
  SIMD-friendly multiply-add
  Regular pattern

Specialized:
  Exploit prime structure
  Mersenne-like primes: shifts
  Goldilocks: efficient reduction
```

## Polynomial Operations

### Vectorized FFT

SIMD in FFT computation:

```
Butterfly operation:
  a' = a + ω·b
  b' = a - ω·b

Vectorization:
  Process multiple butterflies
  Pack different points in vector
  Or process different polynomials

Implementation:
  Radix-2, radix-4, radix-8 butterflies
  Higher radix for more SIMD utilization
  Memory layout for coalesced access
```

### Vectorized Evaluation

Polynomial evaluation with SIMD:

```
Horner's method (scalar):
  result = a[n]
  for i in (n-1)..0:
    result = result * x + a[i]

Vectorized (4 points):
  Process 4 evaluation points
  Same polynomial, different x values
  4x throughput

Multiple polynomials:
  Process 4 polynomials at same point
  Same operations, different data
```

### Vectorized Arithmetic

Polynomial addition/multiplication:

```
Point-wise addition:
  Trivially parallel
  Add corresponding coefficients

Point-wise multiplication (evaluation form):
  Trivially parallel
  Multiply corresponding evaluations

Convolution (coefficient form):
  More complex
  Often done via FFT instead
```

## Hash Functions

### Vectorized SHA-256

SIMD SHA-256 implementation:

```
Multi-message hashing:
  Hash 4/8 messages simultaneously
  Same operations, different data

Implementation:
  Interleave message blocks
  Process all in parallel
  De-interleave results

Speedup:
  Near-linear with vector width
  4x for AVX2, 8x for AVX-512
```

### Vectorized Poseidon

SIMD-friendly hash:

```
Poseidon structure:
  S-box: x^d (exponentiation)
  Matrix multiplication
  Round constant addition

Vectorization:
  Multiple instances in parallel
  Matrix-vector as vector operations

Advantage:
  Designed with hardware in mind
  Regular, predictable operations
```

### Merkle Tree Hashing

Parallel leaf hashing:

```
Leaf level:
  All leaves independent
  Hash multiple leaves with SIMD

Internal levels:
  Each level depends on children
  But nodes within level independent
  Vectorize within level
```

## Data Layout

### Structure of Arrays

SIMD-friendly layout:

```
Array of Structures (bad for SIMD):
  struct { a, b, c } arr[n]
  Scattered access for single field

Structure of Arrays (good for SIMD):
  struct { a[n], b[n], c[n] }
  Contiguous access for single field
  Perfect for vector loads
```

### Alignment

Memory alignment for SIMD:

```
Requirement:
  AVX: 32-byte alignment
  AVX-512: 64-byte alignment
  Unaligned access slower

Implementation:
  Align arrays to vector width
  Use aligned allocation
  Pad if necessary
```

### Padding

Handling non-multiple sizes:

```
Problem:
  Array size not multiple of vector width
  Cannot vectorize last elements

Solutions:
  Pad array to vector width multiple
  Process remainder with scalar code
  Use masked operations (AVX-512)
```

## Implementation Techniques

### Intrinsics

Direct SIMD instruction access:

```
Example (AVX2):
  __m256i a = _mm256_load_si256(ptr_a);
  __m256i b = _mm256_load_si256(ptr_b);
  __m256i c = _mm256_add_epi64(a, b);
  _mm256_store_si256(ptr_c, c);

Pros:
  Full control
  Predictable performance

Cons:
  Architecture-specific
  Verbose code
  Manual optimization
```

### Compiler Autovectorization

Letting compiler vectorize:

```
Requirements:
  Simple loop structure
  No dependencies between iterations
  Known trip count helpful

Hints:
  #pragma omp simd
  restrict pointers
  -march=native flag

Limitations:
  May miss opportunities
  Unpredictable results
  Check assembly output
```

### SIMD Libraries

High-level SIMD programming:

```
Libraries:
  Highway (Google)
  XSIMD
  std::simd (C++23)

Benefits:
  Portable across architectures
  Cleaner code
  Tested implementations

Trade-off:
  May not be optimal
  Abstraction overhead
```

## Optimization Strategies

### Instruction-Level Parallelism

Keeping pipeline full:

```
Strategy:
  Interleave independent operations
  Hide latency with parallelism

Example:
  // Latency hiding
  a1 = mul(x1, y1);  // Start mul 1
  a2 = mul(x2, y2);  // Start mul 2 (mul 1 in flight)
  a3 = mul(x3, y3);  // Start mul 3
  // Results available after latency
```

### Register Blocking

Maximizing register use:

```
Approach:
  Load multiple vectors into registers
  Perform all operations
  Store results
  Minimize memory round-trips

Block size:
  Limited by register count
  Larger = better reuse
  Too large = register spilling
```

### Memory Prefetching

Hiding memory latency:

```
Software prefetch:
  Load data into cache early
  Compute while loading

Example:
  prefetch(data + ahead);
  compute(data);

Distance:
  Far enough to hide latency
  Not so far it's evicted
  Tune for cache size
```

## Performance Analysis

### Roofline Model

Understanding limits:

```
Compute bound:
  Limited by FLOPS/s
  Increase arithmetic intensity

Memory bound:
  Limited by bandwidth
  Improve locality
  Reduce memory traffic

Operational intensity:
  FLOPS per byte transferred
  Determines which bound applies
```

### Profiling SIMD Code

Measuring SIMD efficiency:

```
Metrics:
  Vector operations vs scalar
  Port utilization
  Cache hit rates

Tools:
  Intel VTune
  AMD uprof
  perf events

Analysis:
  Compare to theoretical peak
  Identify bottlenecks
```

## Key Concepts

- **Vector extensions**: SSE, AVX, AVX-512, NEON
- **Data parallelism**: Same operation on multiple data
- **Data layout**: Structure of Arrays for SIMD
- **Intrinsics vs autovectorization**: Control vs convenience
- **Optimization**: ILP, register blocking, prefetching

## Design Considerations

### Implementation Approach

| Intrinsics | Autovectorization |
|------------|-------------------|
| Full control | Compiler decides |
| Maximum performance | Good-enough performance |
| Architecture-specific | More portable |
| More development effort | Less effort |

### Portability vs Performance

| Portable | Architecture-Specific |
|----------|----------------------|
| Works everywhere | Works on target |
| May be slower | Optimal performance |
| Easier maintenance | Harder maintenance |
| Library-based | Intrinsics-based |

## Related Topics

- [Parallel Proving](../01-prover-optimization/04-parallel-proving.md) - Thread-level parallelism
- [GPU Proving](01-gpu-proving.md) - GPU SIMT parallelism
- [Polynomial Optimization](../01-prover-optimization/02-polynomial-optimization.md) - FFT optimization
- [Memory Optimization](../01-prover-optimization/03-memory-optimization.md) - Memory access patterns

