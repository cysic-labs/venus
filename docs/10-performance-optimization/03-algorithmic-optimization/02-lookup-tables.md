# Lookup Table Optimization

## Overview

Lookup table optimization replaces computation with memory access, trading storage space for execution time. In zero-knowledge proof systems, where the same computations repeat billions of times, precomputed lookup tables can dramatically accelerate operations that would otherwise require expensive arithmetic.

The fundamental insight is that memory access is often faster than computation, especially for complex operations. A single table lookup replaces potentially dozens of arithmetic operations. When combined with proper caching, lookup tables can accelerate cryptographic primitives, field arithmetic reductions, and constraint evaluations by significant factors.

This document explores lookup table design, implementation strategies, and optimization techniques for zkVM performance.

## Lookup Table Fundamentals

### The Time-Space Tradeoff

Lookup tables embody a classic computer science tradeoff:

```
Without table:
f(x) = expensive_computation(x)  // Slow, no memory

With table:
table = [f(0), f(1), f(2), ..., f(n-1)]  // Precompute once
f(x) = table[x]  // Fast lookup, requires memory

Tradeoff factors:
- Computation cost of f(x)
- Memory access cost
- Table size
- Access frequency
```

### Table Applicability

Lookup tables work when:

```
Requirements:
1. Input domain is bounded and enumerable
2. Function is deterministic (same input -> same output)
3. Table fits in available memory
4. Lookup cost < computation cost

Good candidates:
- Fixed-width integer operations
- S-boxes in cryptographic primitives
- Small field arithmetic
- Byte-level transformations
```

### Cache Hierarchy Impact

Table location in cache hierarchy determines effectiveness:

```
L1 Cache (32 KB):
- ~4 cycle access
- Tables up to ~4K entries effective

L2 Cache (256 KB):
- ~12 cycle access
- Tables up to ~32K entries effective

L3 Cache (8+ MB):
- ~40 cycle access
- Tables up to ~1M entries effective

Main Memory:
- ~100+ cycle access
- Large tables may be slower than computation
```

## Table Design Strategies

### Direct Indexing

Simplest approach: input directly indexes table:

```
Table structure:
table[x] = f(x) for all x in domain

Access:
result = table[input]

Requirements:
- Input values contiguous (or nearly so)
- Domain size equals table size
- No index computation needed

Example:
// 8-bit multiplication table
table[a * 256 + b] = (a * b) mod 256
result = mul_table[a << 8 | b]
```

### Decomposed Tables

Split computation into multiple smaller lookups:

```
Instead of:
table[a, b] where a, b are large

Use:
table_1[a] combined with table_2[b]

Example - multiplication decomposition:
a * b = (a_hi * 256 + a_lo) * (b_hi * 256 + b_lo)
     = a_hi * b_hi * 65536
       + (a_hi * b_lo + a_lo * b_hi) * 256
       + a_lo * b_lo

4 byte-sized tables instead of one 64KB table.
```

### Hierarchical Tables

Multiple levels of lookup:

```
Level 1: Coarse-grained table
table_coarse[x >> 8] = approximate_f(x)

Level 2: Fine-grained adjustment
table_fine[x & 0xFF] = correction

Combined:
f(x) = table_coarse[x >> 8] + table_fine[x & 0xFF]

Benefits:
- Smaller individual tables
- Better cache utilization
- Acceptable precision loss in some cases
```

### Compressed Tables

Reduce storage through compression:

```
Techniques:

Run-length encoding:
[v, v, v, v, w, w] -> [(v, 4), (w, 2)]
Good for tables with repeated values

Delta encoding:
[100, 103, 105, 108] -> [100, +3, +2, +3]
Good for slowly-changing values

Sparse encoding:
Store only non-zero entries with indices
Good for mostly-zero tables
```

## Field Arithmetic Tables

### Reduction Tables

Precompute modular reductions:

```
For Goldilocks p = 2^64 - 2^32 + 1:

Reduction of high 32 bits:
reduction_table[h] = (h * 2^32) mod p

Usage:
x mod p = (x mod 2^64) + reduction_table[x >> 32]
Additional reduction step may be needed
```

### Multiplication Tables

For small fields, full multiplication tables:

```
For 16-bit field:
table_size = 2^16 * 2^16 = 2^32 entries = 8 GB (impractical)

Alternative - decomposed:
// 8-bit sub-tables
table_ll[a_lo][b_lo]  // lo * lo
table_lh[a_lo][b_hi]  // lo * hi
table_hl[a_hi][b_lo]  // hi * lo
table_hh[a_hi][b_hi]  // hi * hi

Total: 4 * 256 * 256 = 256 KB
```

### Inverse Tables

For small fields, precompute inverses:

```
inverse_table[x] = x^(-1) mod p for x != 0
inverse_table[0] = 0  // Convention

Usage:
inv = inverse_table[x]

Table size: |F| entries
Practical for fields up to 2^20 elements
```

### Exponentiation Tables

Precompute powers for fixed bases:

```
For generator g:
power_table[i] = g^i for i = 0, 1, ..., k

Usage in NTT:
omega^i = power_table[i]

Table size vs. computation:
Store 2^16 powers -> save 16 multiplications per lookup
```

## Hash Function Tables

### S-Box Tables

Substitution boxes in block ciphers:

```
AES S-box:
sbox[byte] = SubBytes(byte)

256 entries, 256 bytes total
Accessed billions of times in hashing
```

### Round Constant Tables

Precomputed round constants:

```
Keccak round constants:
rc[round] = precomputed_value

24 rounds, 24 constants
Eliminates LFSR computation each round
```

### State Transformation Tables

Combined transformation tables:

```
AES T-tables:
T0[a] = S(a) * [02, 01, 01, 03]
T1[a] = S(a) * [03, 02, 01, 01]
T2[a] = S(a) * [01, 03, 02, 01]
T3[a] = S(a) * [01, 01, 03, 02]

Combines S-box and MixColumns:
4 lookups + 3 XORs per column instead of
multiple multiplications and additions
```

## NTT Twiddle Factor Tables

### Full Precomputation

Store all needed twiddle factors:

```
For NTT of size N:
twiddles[i] = omega^i for i = 0, 1, ..., N/2 - 1

Storage: N/2 field elements
Access: Direct indexing in butterfly
```

### Partial Precomputation

Store subset, compute others:

```
Store: twiddles[i] for i = 0, 1, ..., sqrt(N)
Compute: twiddles[i*j] = twiddles[i] * twiddles[j]

Storage: O(sqrt(N))
Computation: One multiplication per access

Hybrid:
Store powers of 2: twiddles[2^k]
Compute others via multiplication
```

### Per-Stage Tables

Separate table for each NTT stage:

```
Stage 0: [omega^0]
Stage 1: [omega^0, omega^(N/4)]
Stage 2: [omega^0, omega^(N/8), omega^(2N/8), omega^(3N/8)]
...

Benefits:
- Smaller active working set per stage
- Better cache utilization
- Sequential access pattern
```

## Constraint Evaluation Tables

### Operation Result Tables

Precompute operation results:

```
For fixed-width operations:
add_table[a][b] = (a + b) mod 2^w
mul_table[a][b] = (a * b) mod 2^w
and_table[a][b] = a & b

Used in constraint checking:
result_constraint = (output == add_table[input_a][input_b])
```

### Range Tables

Validate value ranges:

```
For range [0, 2^16):
in_range[x] = 1 if x < 2^16 else 0

Table size: 2^16 entries, 1 bit each = 8 KB

Alternative encoding:
decomposition_valid[byte] = 1 for all bytes
Check: all bytes of x are in decomposition_valid
```

### Lookup Argument Tables

Tables used in lookup argument protocols:

```
Lookup table T contains valid (input, output) pairs.
Prover demonstrates all actual pairs appear in T.

Table organization affects proof efficiency:
- Sorted tables enable efficient range proofs
- Grouped tables reduce lookup overhead
- Sparse tables need special handling
```

## Cache Optimization

### Table Alignment

Align tables to cache line boundaries:

```
Cache line = 64 bytes

Poor alignment:
table starts at address 0x1020  // Crosses cache lines

Good alignment:
table starts at address 0x1000  // Cache line aligned

Benefits:
- Single cache line per access
- Predictable prefetching
- No split access penalty
```

### Access Pattern Optimization

Structure accesses for cache efficiency:

```
Poor pattern - random access:
for i in random_order:
    result = table[random_index[i]]

Good pattern - sequential:
for i in 0..n:
    result = table[i]  // Sequential, prefetch-friendly

Better pattern - blocked:
for block in blocks:
    for i in block:
        result = table[i]  // Locality within block
```

### Table Clustering

Group related tables together:

```
Memory layout:
[table_a][padding][table_b][padding][unrelated_data]

Better layout:
[table_a][table_b][table_c]  // Related tables adjacent

Benefits:
- Prefetch loads multiple tables
- Related tables share cache lines
- Better spatial locality
```

### Prefetching

Hint processor about upcoming accesses:

```
Pattern:
for i in 0..n:
    prefetch(table + next_index[i+PREFETCH_DISTANCE])
    result = table[index[i]]

Prefetch distance depends on:
- Memory latency
- Computation per iteration
- Access predictability
```

## Key Concepts

- **Lookup table**: Precomputed array mapping inputs to outputs
- **Time-space tradeoff**: Trading memory for computation time
- **Direct indexing**: Input directly indexes table entry
- **Table decomposition**: Splitting large table into smaller ones
- **S-box**: Substitution box in cryptographic contexts
- **Twiddle factor**: Precomputed root of unity power for NTT
- **Cache locality**: Keeping accessed data in fast cache

## Design Trade-offs

### Table Size vs. Performance

| Table Size | Cache Level | Access Time | Benefit |
|------------|-------------|-------------|---------|
| < 32 KB | L1 | ~4 cycles | Very high |
| 32-256 KB | L2 | ~12 cycles | High |
| 256 KB - 8 MB | L3 | ~40 cycles | Moderate |
| > 8 MB | Memory | ~100+ cycles | Often negative |

### Direct vs. Computed Indexing

| Approach | Table Size | Index Cost | Best For |
|----------|------------|------------|----------|
| Direct | Large | Zero | Contiguous inputs |
| Computed | Smaller | Some | Sparse/structured inputs |
| Hybrid | Medium | Minimal | Decomposable inputs |

### Precision vs. Storage

| Strategy | Precision | Storage | Use Case |
|----------|-----------|---------|----------|
| Exact values | Perfect | Maximum | Cryptographic |
| Rounded values | Approximate | Reduced | Numerical |
| Delta encoding | Perfect | Reduced | Smooth functions |

## Related Topics

- [Batch Processing](01-batch-processing.md) - Processing multiple table lookups
- [SIMD Vectorization](../01-cpu-optimization/01-simd-vectorization.md) - Vectorized table lookups
- [NTT and FFT](../../01-mathematical-foundations/02-polynomials/02-ntt-and-fft.md) - Twiddle factor tables
- [Lookup Arguments](../../03-proof-management/02-component-system/02-lookup-arguments.md) - Proving table membership
- [GPU Memory Management](../02-gpu-acceleration/03-memory-management.md) - GPU table storage
