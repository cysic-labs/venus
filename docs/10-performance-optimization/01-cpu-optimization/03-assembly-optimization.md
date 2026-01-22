# Assembly Optimization

## Overview

Assembly optimization involves writing or tuning machine code directly to achieve maximum performance for critical code paths. While high-level languages and compilers handle most code adequately, the most performance-critical sections of zero-knowledge proof systems often benefit from hand-crafted assembly that exploits specific processor features beyond what compilers can automatically generate.

In zkVM implementations, field arithmetic operations execute billions of times during proof generation. A 10% improvement in field multiplication through assembly optimization can translate to hours saved on large proofs. However, assembly optimization carries significant costs in complexity, portability, and maintainability, making it a tool to be used judiciously.

This document explores assembly optimization concepts, techniques, and design considerations for performance-critical zkVM components.

## When Assembly Optimization Matters

### The Critical Path

Not all code benefits from assembly optimization. Focus areas:

**Field Arithmetic**: Modular addition, subtraction, multiplication, and reduction
**Hash Functions**: Compression function inner loops
**NTT Butterflies**: The innermost transform operations
**Memory Operations**: Optimized copying and initialization

These operations typically consume 80-95% of proving time.

### Compiler Limitations

Compilers cannot always generate optimal code due to:

**Aliasing uncertainty**: Compilers assume pointers may overlap
**Instruction selection**: Not all optimal sequences are discovered
**Register allocation**: Complex code may cause suboptimal spilling
**Vectorization barriers**: Some patterns not recognized

### Performance Gap

Typical improvements from assembly over compiled code:

| Operation | Compiled | Hand-tuned Assembly |
|-----------|----------|---------------------|
| Field multiply | 1.0x | 1.2-1.5x |
| NTT butterfly | 1.0x | 1.3-2.0x |
| Hash compression | 1.0x | 1.1-1.4x |
| Memory copy | 1.0x | 1.1-1.3x |

Gains vary significantly based on compiler quality and target architecture.

## Processor Architecture Concepts

### Instruction Pipeline

Modern processors execute instructions through stages:

```
Fetch -> Decode -> Execute -> Memory -> Writeback
  |        |         |          |          |
Inst 5   Inst 4    Inst 3    Inst 2     Inst 1
```

**Pipeline hazards** stall execution:
- **Data hazards**: Result not yet available
- **Control hazards**: Branch misprediction
- **Structural hazards**: Resource contention

### Out-of-Order Execution

Processors reorder instructions for efficiency:

```
Program Order:           Execution Order:
1. load r1, [mem1]       1. load r1, [mem1]
2. add r2, r1, 5         3. mul r4, r3, 7    (independent)
3. mul r4, r3, 7         2. add r2, r1, 5    (waits for load)
4. store [mem2], r4      4. store [mem2], r4
```

Assembly optimization exploits this by interleaving independent operations.

### Execution Units

Processors contain multiple specialized units:

```
+------------------+
| Integer ALU x4   |  - Basic arithmetic, logic
| FP/Vector x2     |  - Floating point, SIMD
| Load Unit x2     |  - Memory reads
| Store Unit x1    |  - Memory writes
| Branch Unit x1   |  - Conditional jumps
+------------------+
```

Optimal code uses all available units simultaneously.

### Register File

Limited high-speed storage within the processor:

**x86-64 General Purpose**: 16 registers (RAX-R15)
**x86-64 Vector**: 16-32 registers (XMM/YMM/ZMM)
**ARM64**: 31 general + 32 vector registers

Register pressure occurs when algorithms need more registers than available, forcing spills to memory.

## Instruction Selection

### Latency vs. Throughput

Instructions have different performance characteristics:

| Instruction | Latency (cycles) | Throughput (per cycle) |
|-------------|------------------|------------------------|
| ADD | 1 | 4 |
| IMUL | 3 | 1 |
| MULX (extended) | 4 | 1 |
| DIV | 20-90 | 0.05 |

**Latency**: Cycles until result available
**Throughput**: Operations per cycle when independent

Prefer high-throughput instructions and hide latency with parallelism.

### Instruction Fusion

Some instruction pairs execute as one:

```
CMP rax, rbx   \
JNE target     /  Fused into single operation
```

Understanding fusion rules enables more efficient code.

### Specialized Instructions

Modern processors offer specialized operations:

**MULX**: Extended multiplication without flags modification
**ADCX/ADOX**: Independent carry chains
**SHLD/SHRD**: Double-precision shifts
**PDEP/PEXT**: Parallel bit deposit/extract
**VPCLMULQDQ**: Carryless multiplication

These enable algorithms impossible to express efficiently in high-level code.

## Field Arithmetic in Assembly

### 64-bit Multiplication with 128-bit Result

Core operation for modular multiplication:

```
; Input: rax, rbx (64-bit values)
; Output: rdx:rax (128-bit product)

mul rbx        ; rax * rbx -> rdx:rax
```

The result spans two registers, enabling extended precision arithmetic.

### Multi-word Arithmetic

For large integers (256-bit, 384-bit):

```
; 256-bit addition: a + b -> result
; a in [r8-r11], b in [r12-r15]

add r8, r12    ; Low word
adc r9, r13    ; Propagate carry
adc r10, r14   ; Propagate carry
adc r11, r15   ; High word with final carry
```

Carry-propagating chains require sequential execution.

### Montgomery Reduction

Efficient modular reduction without division:

```
Montgomery Reduction Concept:
Given: N (modulus), R (power of 2 > N)
Precompute: N' such that N * N' = -1 (mod R)

To reduce T:
1. m = (T mod R) * N' mod R
2. t = (T + m * N) / R
3. if t >= N: t = t - N
```

Assembly implementation exploits:
- MULX for multiplication without flag clobbering
- ADCX/ADOX for parallel carry chains
- Careful register allocation

### Goldilocks Field Optimization

The Goldilocks prime p = 2^64 - 2^32 + 1 enables special reduction:

```
Given 128-bit product h:l (high:low words):

Step 1: Split h into h1:h0 (high 32 bits : low 32 bits)
Step 2: result = l - h0 + (h1 << 32) + h1

This exploits: 2^64 = 2^32 - 1 (mod p)
```

Assembly can perform this reduction in approximately 5 instructions.

## Memory Access Optimization

### Prefetching

Anticipate memory needs:

```
prefetch [future_address]   ; Hint to cache
; ... other work ...
mov rax, [future_address]   ; Now fast, already in cache
```

Effective prefetch distance depends on memory latency and intervening work.

### Alignment

Aligned access is faster:

```
; Aligned load (16-byte boundary)
movdqa xmm0, [aligned_ptr]

; Unaligned load (any address)
movdqu xmm0, [unaligned_ptr]   ; Historically slower
```

Modern processors handle unaligned access well but alignment still helps.

### Non-temporal Stores

Bypass cache for write-once data:

```
movntdq [dest], xmm0   ; Write directly to memory, skip cache
```

Useful when:
- Data won't be read soon
- Want to preserve cache contents
- Writing large contiguous regions

### Memory Layout

Structure data for access patterns:

```
Poor layout (causes cache misses):
[used][unused][unused][unused][used][unused]...

Good layout (sequential access):
[used][used][used][used][used][used]...
```

## SIMD in Assembly

### Vector Register Usage

Direct control over vector operations:

```
; Load 4 field elements (256 bits total)
vmovdqu ymm0, [src]

; Add vectors element-wise
vpaddq ymm2, ymm0, ymm1

; Store result
vmovdqu [dst], ymm2
```

### Complex SIMD Operations

Some algorithms require intricate shuffles:

```
; Transpose 4x4 matrix in AVX registers
vunpcklps ymm4, ymm0, ymm1
vunpckhps ymm5, ymm0, ymm1
vunpcklps ymm6, ymm2, ymm3
vunpckhps ymm7, ymm2, ymm3
; ... additional shuffle operations ...
```

These sequences are difficult for compilers to generate.

### Masking with AVX-512

Conditional operations per element:

```
; k1 = comparison mask
vpcmpq k1, zmm0, zmm1, 1    ; k1[i] = (zmm0[i] < zmm1[i])

; Conditional operation
vpaddq zmm2{k1}, zmm3, zmm4  ; Only add where k1 is set
```

Enables branchless conditional code.

## Loop Optimization

### Unrolling

Process multiple iterations per loop cycle:

```
; Original loop
loop_start:
    process(item[i])
    inc i
    cmp i, n
    jl loop_start

; Unrolled 4x
loop_start:
    process(item[i])
    process(item[i+1])
    process(item[i+2])
    process(item[i+3])
    add i, 4
    cmp i, n
    jl loop_start
```

Benefits:
- Reduced loop overhead
- More instruction-level parallelism
- Better prefetch opportunities

Costs:
- Code size increase
- Complexity for cleanup handling

### Software Pipelining

Overlap iterations:

```
; Pipelined structure:
; Iteration N:   Load | Compute | Store
; Iteration N+1:      | Load    | Compute | Store
; Iteration N+2:             | Load    | Compute | ...

prefetch [src + 64]    ; Start next iteration load
compute(current)       ; Process current
store(previous)        ; Complete previous iteration
```

Hides memory latency within computation.

### Branch Elimination

Convert branches to arithmetic:

```
; With branch:
cmp a, b
jl label
mov result, x
jmp done
label:
mov result, y
done:

; Branchless:
cmp a, b
cmovl result, y    ; Conditional move
cmovge result, x
```

Eliminates branch misprediction penalties.

## Performance Analysis

### Performance Counters

Hardware counters measure execution characteristics:

| Counter | Meaning | Target |
|---------|---------|--------|
| Instructions retired | Completed instructions | Maximize |
| Cycles | Clock cycles elapsed | Minimize |
| IPC | Instructions per cycle | Maximize (theoretical max ~4-6) |
| Cache misses | L1/L2/L3 misses | Minimize |
| Branch mispredicts | Wrong predictions | Minimize |

### Microbenchmarking

Isolate and measure specific operations:

```
Methodology:
1. Warm up caches
2. Execute operation N times
3. Measure total cycles
4. Compute average cycles per operation
5. Account for loop overhead
```

Pitfalls:
- Unrepresentative cache state
- Compiler optimization affecting measurement
- Timer resolution limits

### Instruction Throughput Analysis

Calculate theoretical limits:

```
For NTT butterfly (per butterfly):
- 1 multiplication (throughput 1/cycle)
- 2 additions (throughput 4/cycle)
- Loads and stores as needed

Theoretical: ~1 butterfly per cycle if multiplication-bound
Practical: Often 1.5-3 cycles due to other factors
```

## Portability Considerations

### Platform-Specific Versions

Maintain multiple implementations:

```
Assembly versions:
- x86_64_avx512.S    ; Intel/AMD with AVX-512
- x86_64_avx2.S      ; Intel/AMD with AVX2
- aarch64_neon.S     ; ARM64 with NEON

Runtime selection based on CPUID/feature detection.
```

### Inline Assembly

Embed assembly in higher-level code:

```
Benefits:
- Compiler manages surrounding code
- Easier register allocation
- Simpler build process

Drawbacks:
- Syntax varies by compiler
- Less control over code generation
- Debugging more difficult
```

### Intrinsics as Middle Ground

Compiler-provided functions mapping to instructions:

```
Advantages:
- More portable than raw assembly
- Compiler handles register allocation
- Easier debugging

Disadvantages:
- Less control than pure assembly
- Compiler may not optimize perfectly
- Still architecture-specific
```

## Key Concepts

- **Instruction latency**: Cycles until result available
- **Instruction throughput**: Operations completable per cycle
- **Pipeline hazard**: Condition causing pipeline stall
- **Register pressure**: Demand exceeding available registers
- **Cache prefetch**: Preloading data before needed
- **Branch misprediction**: Processor guessing wrong branch direction
- **Loop unrolling**: Processing multiple iterations per loop cycle
- **Software pipelining**: Overlapping successive loop iterations

## Design Trade-offs

### Performance vs. Maintainability

| Approach | Performance | Maintainability | Portability |
|----------|-------------|-----------------|-------------|
| High-level language | Good | Excellent | Excellent |
| Intrinsics | Better | Good | Good |
| Inline assembly | Better | Fair | Fair |
| Standalone assembly | Best | Poor | Poor |

### When to Use Assembly

Assembly is justified when:
- Operation is on critical path
- Compiler misses significant optimization
- Specialized instructions needed
- Performance gain exceeds maintenance cost

Assembly is not justified when:
- Code is not performance-critical
- Compiler generates near-optimal code
- Portability is paramount
- Development time is limited

### Verification Strategy

Assembly code requires thorough verification:

```
Verification layers:
1. Unit tests against reference implementation
2. Randomized testing with many inputs
3. Edge case testing (zero, max, overflow boundaries)
4. Integration testing in full system
5. Performance regression testing
```

## Related Topics

- [SIMD Vectorization](01-simd-vectorization.md) - Vector operations in assembly
- [Multi-Threading](02-multi-threading.md) - Assembly in parallel contexts
- [Goldilocks Field](../../01-mathematical-foundations/01-finite-fields/02-goldilocks-field.md) - Field requiring optimized assembly
- [NTT and FFT](../../01-mathematical-foundations/02-polynomials/02-ntt-and-fft.md) - Primary assembly optimization target
- [GPU Kernel Design](../02-gpu-acceleration/02-kernel-design.md) - Alternative to CPU assembly
