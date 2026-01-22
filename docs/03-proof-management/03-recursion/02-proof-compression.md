# Proof Compression

## Overview

Proof compression reduces the size of cryptographic proofs while maintaining their validity and security. Large proofs are expensive to store, transmit, and verify—particularly in blockchain environments where every byte costs gas. Compression techniques trade prover computation for smaller proof sizes, enabling practical deployment of proof systems that would otherwise be prohibitively expensive.

Compression operates at multiple levels: algorithmic improvements reduce the inherent proof size, recursive wrapping produces constant-size proofs, and encoding optimizations minimize the byte representation. The choice of technique depends on the target environment, acceptable prover overhead, and verification requirements.

Understanding proof compression illuminates the trade-offs in proof system design. Native STARK proofs are fast to generate but large (hundreds of kilobytes). Recursive compression can reduce this to a few kilobytes but increases proving time significantly. This document covers compression techniques, their costs and benefits, and practical implementation strategies.

## Sources of Proof Size

### What Makes Proofs Large

Understanding proof components:

```
STARK proof components:
  Polynomial commitments: Merkle roots (small)
  Opening proofs: Merkle paths (large)
  FRI proofs: Multiple rounds of commitments + openings
  Evaluations: Field elements at query points

Size breakdown (typical):
  Commitments: ~1 KB
  FRI layers: 50-100 KB
  Query responses: 50-100 KB
  Total: 100-400 KB

SNARK proof components:
  Group elements (G1, G2)
  Field elements
  Total: 128 bytes - 2 KB
```

### Security Parameter Impact

How security affects size:

```
More queries → larger proof:
  Each FRI query adds Merkle paths
  Security = 2^(-security_parameter)
  100-bit security ≈ 50-100 queries

Deeper FRI → more layers:
  Each layer has commitment
  Query paths in each layer
  Trade-off with evaluation domain size

Larger field → more bits:
  Each field element larger
  Commitments proportionally larger
```

## Algorithmic Compression

### Reducing FRI Layers

Fewer rounds, larger folding:

```
Standard FRI:
  Fold by 2 each round
  log(n) rounds
  Many commitments

Aggressive folding:
  Fold by 4 or 8 each round
  Fewer rounds
  Larger per-round computation

Trade-off:
  Fewer commitments (smaller proof)
  More computation per fold (slower prover)
  Verification complexity similar
```

### Batching Queries

Combining query responses:

```
Individual queries:
  Each query independent
  Separate Merkle paths
  Redundant path nodes

Batched queries:
  Shared Merkle path nodes
  Single tree traversal
  Compressed response

Implementation:
  Sort queries by path
  Provide unique nodes only
  Verifier reconstructs
```

### Commitment Optimization

Reducing commitment overhead:

```
Merkle tree depth:
  Depth = log(evaluation_domain_size)
  Deeper = longer paths

Options:
  Smaller domain (different parameters)
  Different tree structure (e.g., Verkle)
  Batch multiple polynomials

Polynomial batching:
  Combine polynomials into one commitment
  Single Merkle tree for multiple polys
  Challenge-based combination
```

## Recursive Compression

### STARK Wrapping

Compressing STARK with recursion:

```
Process:
  1. Generate STARK proof (large)
  2. Create recursive proof of STARK verification
  3. Recursive proof is new proof (smaller if different system)

Size reduction:
  Original: 200 KB
  After wrapping: 10-50 KB
  Multiple wrappings possible

Cost:
  Significant prover overhead
  Verification circuit is large
  Worth it for many proofs or chain submission
```

### Multi-Level Compression

Progressive compression:

```
Levels:
  Level 0: Native STARK (fast, large)
  Level 1: STARK-in-STARK (medium, medium)
  Level 2: SNARK-wrap (slow, tiny)

Selection criteria:
  Target size
  Available proving time
  Verification environment

Example pipeline:
  Generate 1000 segment proofs (STARK)
  Aggregate into 1 STARK (recursion)
  Wrap into SNARK (final compression)
```

### Compression vs Aggregation

Different goals:

```
Compression:
  Single proof → smaller single proof
  Maintains same statement
  Size optimization

Aggregation:
  Multiple proofs → single proof
  Combined statement
  Count optimization

Combined:
  Aggregate then compress
  Maximum efficiency
  Complex pipeline
```

## SNARK Wrapping

### Why SNARK for Final Proof

SNARK advantages:

```
Size:
  SNARK proofs are tiny (128-300 bytes typical)
  Orders of magnitude smaller than STARK

Verification cost:
  Pairing check is cheap
  Constant time verification
  Optimized for on-chain

Trade-off:
  Trusted setup (for some SNARKs)
  Slower proving
  Different security assumptions
```

### Wrapping Process

STARK to SNARK conversion:

```
Steps:
  1. STARK proof as SNARK witness
  2. STARK verifier as SNARK circuit
  3. Prove STARK verification in SNARK

Circuit components:
  Hash computations (expensive)
  Field arithmetic (native)
  FRI verification logic

Optimization:
  Algebraic hash critical
  Minimize STARK queries before wrap
  Specialize circuit for STARK variant
```

### SNARK Options

Different SNARK systems:

```
Groth16:
  Smallest proofs (128 bytes)
  Fastest verification
  Trusted setup per circuit
  Circuit-specific

PLONK:
  Small proofs (~300 bytes)
  Universal setup
  More flexible
  Slightly larger

Other options:
  FFLONK, HyperPLONK
  Trade-offs vary
  Ecosystem considerations
```

## Encoding Optimization

### Field Element Encoding

Efficient representation:

```
Standard encoding:
  Full field element
  64 bytes for 256-bit field

Compressed encoding:
  Remove redundant bits
  Use canonical form
  Pack multiple elements

Example:
  Goldilocks (64-bit): 8 bytes native
  Extension field: 8 bytes × degree
  Packing small values
```

### Proof Serialization

Efficient proof format:

```
Naive format:
  All elements full size
  No structure exploitation
  Maximum size

Optimized format:
  Variable-length encoding
  Shared structure factoring
  Domain-specific compression

Techniques:
  Merkle path deduplication
  Coordinate compression
  Index encoding
```

### General Compression

Standard compression algorithms:

```
Applicability:
  After proof serialization
  Exploit any redundancy
  Lossless compression

Algorithms:
  GZIP, Zstd
  Typically 10-30% reduction
  Minimal overhead

Considerations:
  Compression CPU cost
  Decompression on verify
  Often worth it for storage
```

## Verification Trade-offs

### Verification Cost vs Proof Size

Balancing factors:

```
Smaller proof → usually more verification:
  SNARK: tiny proof, pairing check
  Recursive: smaller, verify recursion layer

Larger proof → simpler verification:
  Native STARK: larger, direct FRI verify
  No recursion overhead

Selection depends on:
  Where verification happens
  Cost of verification
  Cost of storage/transmission
```

### On-Chain Considerations

Blockchain verification:

```
Factors:
  Calldata cost per byte
  Verification gas cost
  Block space limits

Optimization:
  SNARK wrapping often best
  Calldata < computation cost usually
  Chain-specific tuning

Example:
  Ethereum: SNARK wrapper essential
  High-throughput chain: maybe native STARK OK
```

## Implementation Strategies

### Compression Pipeline

Organizing compression stages:

```
Pipeline design:
  1. Generate proof (native system)
  2. Algorithmic compression (parameter tuning)
  3. Recursive compression (optional)
  4. SNARK wrapping (optional)
  5. Encoding optimization
  6. General compression

Configuration:
  Enable/disable stages
  Tune parameters per stage
  Target size/time constraints
```

### Lazy Compression

Compress only when needed:

```
Strategy:
  Store native proofs
  Compress on demand
  Cache compressed versions

Benefits:
  Flexible storage/transmission trade-off
  Amortize compression cost
  Multiple compression targets

Use cases:
  Archive native, serve compressed
  Different compression for different consumers
```

### Parallel Compression

Speeding up compression:

```
Parallelism opportunities:
  Multiple proofs independently
  Within recursive wrapping
  Aggregation tree levels

Implementation:
  Thread pool for proofs
  GPU for SNARK circuits
  Distributed compression
```

## Key Concepts

- **Proof size**: Total bytes needed to represent and transmit proof
- **Recursive compression**: Using recursion to reduce proof size
- **SNARK wrapping**: Converting STARK to compact SNARK proof
- **Encoding optimization**: Efficient binary representation
- **Compression pipeline**: Staged approach to proof size reduction

## Design Considerations

### Compression Technique Selection

| Technique | Size Reduction | Overhead | Best For |
|-----------|---------------|----------|----------|
| Algorithmic | 2-5x | Low | All cases |
| Recursive | 5-20x | High | Large original proofs |
| SNARK wrap | 50-500x | Very high | On-chain verification |
| Encoding | 1.1-1.5x | Low | Final optimization |

### Cost-Benefit Analysis

| Small Proof | Large Proof |
|-------------|-------------|
| Cheaper transmission | Expensive transmission |
| Cheaper storage | Expensive storage |
| More prover work | Less prover work |
| Complex pipeline | Simple generation |

## Related Topics

- [Recursive Proving](01-recursive-proving.md) - Recursion fundamentals
- [SNARK Wrapping](03-snark-wrapping.md) - STARK to SNARK
- [FRI Protocol](../../02-stark-proving-system/03-fri-protocol/01-fri-fundamentals.md) - STARK proof structure
- [Verification Efficiency](../../02-stark-proving-system/05-verification/02-verification-efficiency.md) - Verification costs

