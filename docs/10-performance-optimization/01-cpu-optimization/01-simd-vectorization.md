# SIMD Vectorization

## Overview

Single Instruction Multiple Data (SIMD) vectorization is a parallel processing paradigm that applies the same operation to multiple data elements simultaneously. In the context of zero-knowledge virtual machines, SIMD represents one of the most impactful optimization techniques for accelerating proof generation on commodity CPUs.

Modern processors contain specialized vector registers and instruction sets capable of processing 4, 8, 16, or even 32 data elements in a single clock cycle. When properly leveraged, SIMD can deliver speedups of 4-16x for data-parallel workloads compared to scalar implementations. Given that zkVM proof generation is dominated by field arithmetic and polynomial operations that exhibit natural data parallelism, SIMD optimization is essential for practical performance.

This document explores SIMD concepts, architectures, application patterns, and design considerations relevant to zkVM implementation.

## SIMD Architecture Fundamentals

### Vector Registers

SIMD architectures extend the processor with wide registers that hold multiple data elements:

```
Scalar Register (64-bit):
+------------------+
|     Element 0    |
+------------------+

256-bit Vector Register (4 x 64-bit):
+-------+-------+-------+-------+
|  E3   |  E2   |  E1   |  E0   |
+-------+-------+-------+-------+

512-bit Vector Register (8 x 64-bit):
+-------+-------+-------+-------+-------+-------+-------+-------+
|  E7   |  E6   |  E5   |  E4   |  E3   |  E2   |  E1   |  E0   |
+-------+-------+-------+-------+-------+-------+-------+-------+
```

Each element position within the vector is called a "lane." Operations execute simultaneously across all lanes.

### SIMD Instruction Categories

SIMD instruction sets provide operations across several categories:

**Arithmetic Operations**
- Addition and subtraction across lanes
- Multiplication and division
- Fused multiply-add operations
- Absolute value and negation

**Logical Operations**
- Bitwise AND, OR, XOR, NOT
- Bit shifts (logical and arithmetic)
- Population count and leading zero count

**Comparison Operations**
- Element-wise comparisons
- Mask generation from comparisons
- Conditional selection based on masks

**Data Movement**
- Vector loads and stores
- Gather and scatter operations
- Shuffle and permute within vectors
- Broadcast scalar to all lanes

**Reduction Operations**
- Horizontal addition across lanes
- Finding maximum or minimum element
- All-true and any-true predicates

### Common SIMD Architectures

**Intel SSE (Streaming SIMD Extensions)**
- 128-bit registers (XMM0-XMM15)
- 2 x 64-bit or 4 x 32-bit elements
- Widely available on x86 processors since 2000
- Baseline for portable SIMD code

**Intel AVX (Advanced Vector Extensions)**
- 256-bit registers (YMM0-YMM15)
- 4 x 64-bit or 8 x 32-bit elements
- Available since Sandy Bridge (2011)
- Significant throughput improvement

**Intel AVX-512**
- 512-bit registers (ZMM0-ZMM31)
- 8 x 64-bit or 16 x 32-bit elements
- Powerful masking support
- Available on recent server and workstation CPUs

**ARM NEON**
- 128-bit registers (V0-V31)
- Similar capability to SSE
- Standard on ARM processors
- Important for mobile and ARM server deployments

**ARM SVE (Scalable Vector Extension)**
- Variable vector length (128-2048 bits)
- Vector-length agnostic programming
- Available on newest ARM designs
- Future-proof vectorization approach

## SIMD Application Patterns

### Vertical Operations

Vertical operations apply the same computation element-by-element across vectors:

```
Vector A:    |  A3  |  A2  |  A1  |  A0  |
             +------+------+------+------+
Operation:   |  +   |  +   |  +   |  +   |
             +------+------+------+------+
Vector B:    |  B3  |  B2  |  B1  |  B0  |
             +------+------+------+------+
             =      =      =      =
Result:      | A3+B3| A2+B2| A1+B1| A0+B0|
```

This is the most straightforward and efficient SIMD pattern, directly mapping loop iterations to vector lanes.

### Horizontal Operations

Horizontal operations combine elements within a single vector:

```
Vector A:    |  A3  |  A2  |  A1  |  A0  |
                 \     |     /     /
                  \    |    /     /
                   v   v   v     v
                   +---+---+---+
Result:            | A0+A1+A2+A3 |
```

Horizontal operations are typically slower than vertical ones because they break the parallel model. Modern SIMD provides dedicated instructions, but they should be used sparingly.

### Strided Access Patterns

When data elements are not contiguous, gather operations collect scattered elements:

```
Memory:    [0][1][2][3][4][5][6][7][8][9][A][B][C][D][E][F]
              ^        ^        ^        ^
           stride = 3

Gather Result: | M[9] | M[6] | M[3] | M[0] |
```

Scatter performs the inverse operation, distributing vector elements to non-contiguous memory locations. These operations have higher latency than contiguous loads but enable SIMD on more complex data layouts.

### Masked Operations

Masks enable conditional execution at the lane level:

```
Vector A:    |  A3  |  A2  |  A1  |  A0  |
Vector B:    |  B3  |  B2  |  B1  |  B0  |
Mask:        |  1   |  0   |  1   |  0   |

Result:      |  A3  |  B2  |  A1  |  B0  |
```

Masking eliminates branches in vectorized code, handling different cases per lane without divergence.

## SIMD in Field Arithmetic

### Field Addition

Field addition is the simplest operation to vectorize. For the Goldilocks field:

```
Vectorized Field Add:
a[0..3] + b[0..3]  ->  result[0..3]

Reduction needed when result >= p:
result = result >= p ? result - p : result
```

The modular reduction can be vectorized using comparison and masked subtraction.

### Field Multiplication

Field multiplication is more complex due to the reduction step. The general approach:

```
Step 1: Extended precision multiply
        64-bit x 64-bit -> 128-bit result

Step 2: Reduce modulo p
        128-bit -> 64-bit
```

SIMD optimization strategies:

**Full-width SIMD**: Some fields allow reduction using SIMD instructions throughout
**Partial SIMD**: Multiply in SIMD, reduce in scalar
**Interleaved**: Process multiple independent multiplications

### Montgomery Multiplication

Montgomery form enables efficient modular multiplication without division:

```
Mont_mul(a', b') = (a' * b' * R^-1) mod p
```

The Montgomery reduction step can be partially vectorized, particularly the multiply-accumulate operations.

### Field Extension Arithmetic

Extension field operations offer additional SIMD opportunities:

```
Goldilocks Extension (degree 2):
(a0 + a1*w) * (b0 + b1*w) = (a0*b0 + a1*b1*W) + (a0*b1 + a1*b0)*w

Four base field multiplications, easily vectorized as a batch.
```

### Vectorizing Multiple Independent Operations

Often the best SIMD strategy processes multiple independent field elements:

```
Instead of:                   Use:
for i in 0..n:               for i in 0..n step 4:
    c[i] = a[i] * b[i]           c[i:i+4] = a[i:i+4] * b[i:i+4]
```

This approach works when there are no data dependencies between iterations.

## SIMD in Polynomial Operations

### Coefficient-wise Operations

Many polynomial operations are naturally vectorized:

```
Polynomial Addition: coeffs_a + coeffs_b
Polynomial Scaling: alpha * coeffs_p
Hadamard Product: coeffs_p * coeffs_q (evaluation form)
```

Each coefficient is independent, mapping directly to SIMD lanes.

### NTT Butterfly Operations

The NTT butterfly is the core operation in polynomial transforms:

```
Basic Butterfly:
    t = w * odd
    result_even = even + t
    result_odd = even - t
```

SIMD optimization approaches:

**Multiple butterflies in parallel**: Process 4-8 butterflies simultaneously
**Staged processing**: Group butterflies by twiddle factor sharing
**Memory-optimized layouts**: Arrange data for coalesced SIMD loads

### Batch Polynomial Evaluation

When evaluating a polynomial at multiple points:

```
P(x0), P(x1), P(x2), P(x3)  computed in parallel
```

Horner's method can be vectorized across evaluation points:

```
Vectorized Horner:
result = 0
for coeff in reversed(coeffs):
    result = result * x + coeff

With SIMD, x contains 4 different evaluation points.
```

### Polynomial Interpolation

Lagrange interpolation can be vectorized:

```
L_i(x) = product over j!=i of (x - x_j) / (x_i - x_j)
P(x) = sum of y_i * L_i(x)
```

The products and sums are independent per evaluation point, enabling SIMD.

## SIMD Memory Considerations

### Alignment Requirements

Optimal SIMD performance requires aligned memory access:

```
Aligned Load (fast):    Memory address divisible by vector width
Unaligned Load (slower): Arbitrary memory address
```

Data structures should be designed with alignment in mind:

- 16-byte alignment for SSE
- 32-byte alignment for AVX
- 64-byte alignment for AVX-512

### Cache Behavior

SIMD increases memory bandwidth demands. Cache considerations:

**Spatial locality**: SIMD naturally improves spatial locality by processing consecutive elements
**Temporal locality**: May degrade if SIMD vectors span cache lines
**Prefetching**: SIMD's regular access patterns enable effective prefetch

### Memory Layout Transformations

Data layout significantly impacts SIMD efficiency:

**Array of Structures (AoS)**:
```
struct Point { float x, y, z; };
Point points[N];  // x0,y0,z0, x1,y1,z1, x2,y2,z2, ...
```

**Structure of Arrays (SoA)**:
```
struct Points {
    float x[N];
    float y[N];
    float z[N];
};  // x0,x1,x2,..., y0,y1,y2,..., z0,z1,z2,...
```

SoA layout enables efficient vertical SIMD operations on each field.

**Array of Structures of Arrays (AoSoA)**:
```
Hybrid grouping elements by SIMD width for optimal cache and vector utilization.
```

## Performance Analysis

### Theoretical Speedup

Amdahl's Law limits SIMD speedup:

```
Speedup = 1 / ((1 - P) + P/N)

P = fraction of code that's vectorizable
N = SIMD width (number of lanes)
```

For 4-wide SIMD with 90% vectorizable code:
```
Speedup = 1 / (0.1 + 0.9/4) = 1 / 0.325 = 3.08x
```

### Real-World Factors

Practical speedup is affected by:

**Memory bandwidth**: SIMD may saturate memory before compute
**Instruction mix**: Not all operations vectorize equally well
**Register pressure**: Complex algorithms may spill to memory
**Startup overhead**: Small loops don't amortize setup costs
**Branching**: Data-dependent branches limit vectorization

### Profiling SIMD Code

Key metrics for SIMD performance:

```
Vector utilization: fraction of vector lanes active
Memory bandwidth utilization: achieved vs peak bandwidth
Port utilization: use of available execution units
Cache hit rate: memory access efficiency
```

## Design Trade-offs

### Portability vs. Performance

**Highly portable code**:
- Works across all platforms
- May leave performance on table
- Easier to maintain

**Platform-specific code**:
- Maximum performance per platform
- Multiple code paths needed
- Higher maintenance burden

**Recommended approach**: Portable algorithms with platform-specific hot paths.

### Vector Width Selection

Wider vectors offer more parallelism but have trade-offs:

| Vector Width | Parallelism | Frequency Impact | Code Complexity |
|--------------|-------------|------------------|-----------------|
| 128-bit (SSE) | 2-4x | None | Low |
| 256-bit (AVX) | 4-8x | Slight | Medium |
| 512-bit (AVX-512) | 8-16x | Significant | High |

AVX-512 in particular can cause frequency scaling that reduces single-threaded performance.

### Scalar Fallback

Production code needs scalar fallbacks for:

- Processors without SIMD support
- Debugging and verification
- Handling data sizes not divisible by vector width

### Code Maintainability

SIMD code is inherently more complex. Strategies:

**Abstraction layers**: Wrap SIMD intrinsics in portable types
**Code generation**: Generate SIMD from higher-level descriptions
**Verification**: Extensive testing against scalar reference

## SIMD in zkVM Proving

### Trace Polynomial Computation

Execution traces contain millions of field elements. SIMD accelerates:

- Trace column polynomial interpolation
- Constraint polynomial evaluation
- Boundary constraint checking

### Commitment Generation

Merkle tree construction involves hashing many leaves:

- Multiple hash digests computed in parallel
- Vectorized compression functions
- Parallel tree level construction

### FRI Operations

FRI protocol operations are highly parallelizable:

- Folding operations across polynomial evaluations
- Query response generation
- Consistency checking

### Witness Generation

Even witness generation benefits from SIMD:

- Batch instruction simulation
- Memory access pattern analysis
- Constraint evaluation during debugging

## Key Concepts

- **SIMD**: Single Instruction Multiple Data parallel execution
- **Vector register**: Wide register holding multiple data elements
- **Lane**: Single element position within a vector register
- **Vertical operation**: Same operation applied element-wise across vectors
- **Horizontal operation**: Combining elements within a single vector
- **Gather/Scatter**: Collecting or distributing non-contiguous elements
- **Masking**: Per-lane conditional execution
- **Twiddle factor**: Precomputed values for NTT butterfly operations

## Design Trade-offs

### Performance vs. Complexity

| Approach | Performance | Complexity | Portability |
|----------|-------------|------------|-------------|
| Scalar baseline | 1x | Low | High |
| Auto-vectorized | 2-3x | Low | High |
| Intrinsic-based | 4-8x | High | Medium |
| Assembly | 6-10x | Very High | Low |

### Memory vs. Compute Balance

SIMD shifts bottlenecks:

| Workload Type | Scalar Bottleneck | SIMD Bottleneck |
|---------------|-------------------|-----------------|
| Dense arithmetic | Compute | Memory bandwidth |
| Sparse operations | Compute | Gather latency |
| Hash functions | Compute | Often still compute |

### Development Approach Recommendation

For zkVM development:

1. Start with correct scalar implementation
2. Profile to identify hot spots (usually NTT, field arithmetic)
3. Apply SIMD to identified hot spots
4. Validate against scalar reference
5. Iterate based on profiling

## Related Topics

- [Multi-Threading](02-multi-threading.md) - Combining SIMD with thread-level parallelism
- [Assembly Optimization](03-assembly-optimization.md) - Low-level SIMD tuning
- [NTT and FFT](../../01-mathematical-foundations/02-polynomials/02-ntt-and-fft.md) - Primary SIMD application
- [Goldilocks Field](../../01-mathematical-foundations/01-finite-fields/02-goldilocks-field.md) - Field arithmetic vectorization
- [GPU Kernel Design](../02-gpu-acceleration/02-kernel-design.md) - Alternative massively parallel approach
