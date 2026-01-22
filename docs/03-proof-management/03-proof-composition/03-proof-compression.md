# Proof Compression

## Overview

Proof compression reduces the size of cryptographic proofs to minimize storage, bandwidth, and on-chain verification costs. STARK proofs, while offering transparency and post-quantum security, tend to be large (100-300 KB) compared to SNARK proofs (hundreds of bytes). Compression techniques range from simple encoding optimizations to sophisticated cryptographic transformations that wrap a large proof inside a smaller one.

The choice of compression strategy depends on the deployment context. For off-chain verification where bandwidth is cheap, minimal compression may suffice. For on-chain verification where every byte has a gas cost, aggressive compression through SNARK wrapping may be economically necessary. Understanding the trade-offs between compression ratio, computational cost, and security properties is essential for practical system design.

This document covers compression techniques from simple optimizations to SNARK wrapping, analyzing their trade-offs and appropriate use cases.

## Compression Strategies

### Strategy Overview

Compression approaches by effectiveness:

```
Level 1: Encoding optimization
  - Compact serialization formats
  - Variable-length encoding
  - Compression ratio: 10-30%

Level 2: Proof-specific compression
  - Merkle proof deduplication
  - Field element packing
  - Compression ratio: 20-50%

Level 3: SNARK wrapping
  - Verify STARK in SNARK circuit
  - Produce SNARK proof of verification
  - Compression ratio: 99%+ (KB to bytes)
```

### Trade-offs

Each approach has costs:

```
Encoding optimization:
  + No trusted setup
  + Minimal computation overhead
  + Maintains all STARK properties
  - Limited compression

Proof-specific:
  + No trusted setup
  + Moderate computation overhead
  + Maintains STARK properties
  - Moderate compression

SNARK wrapping:
  + Dramatic size reduction
  - Requires trusted setup (usually)
  - Significant computation overhead
  - Loses post-quantum security
  - Adds complexity
```

## Encoding Optimizations

### Compact Serialization

Efficient byte representation:

```
Standard representation:
  64-bit field element: 8 bytes
  256-bit hash: 32 bytes

Compact alternatives:
  Montgomery form: use reduced representation
  Canonical form: ensure single representation
  No padding: pack tightly

Example savings:
  1000 field elements: 8000 bytes standard
  With 62-bit packing: 7750 bytes (3% savings)
```

### Variable-Length Encoding

For values with known distributions:

```
Small values are common:
  Multiplicities often small
  Some field elements clustered near zero

Encoding:
  Small values: 1-2 bytes
  Large values: full representation + prefix

Example (varint-style):
  Values 0-127: 1 byte
  Values 128-16383: 2 bytes
  Values up to 2^64: up to 9 bytes

Typical savings: 10-20% on suitable data
```

### Generic Compression

Apply general-purpose compression:

```
Algorithms:
  zstd: Good compression, fast
  lz4: Moderate compression, very fast
  brotli: Better compression, slower

Results on STARK proofs:
  zstd: 15-25% size reduction
  Decompression: microseconds

Considerations:
  - Verifier must decompress
  - Added complexity
  - Good for storage/bandwidth, less for on-chain
```

## Proof-Specific Compression

### Merkle Path Optimization

Reduce Merkle proof overhead:

```
Standard: Each path independent
  Query 1: path of length L
  Query 2: path of length L
  ...
  Total: Q * L * hash_size

Shared paths: Queries may share ancestors
  Identify common path segments
  Include each segment only once
  Reference shared segments by index

Savings:
  Depends on query distribution
  Typically 10-30% of Merkle data
```

### Query Batching

Combine related queries:

```
Observations:
  Queries to same FRI layer share structure
  Paired evaluations (x, -x) related

Optimization:
  Group queries by layer
  Share common Merkle ancestors
  Compact representation of paired values

Format:
  Layer k: [query_positions, shared_path, leaf_data]
  Rather than: [query1_full, query2_full, ...]
```

### Field Element Packing

Pack multiple elements efficiently:

```
Small extension field:
  F_p^2 element: two base field elements
  Pack with single length indicator

Known-range values:
  If value in [0, 2^16), use 2 bytes
  Include range indicators in format

Structured data:
  Final polynomial: coefficients often small
  Pack with appropriate width
```

### Proof Structure Optimization

Reorganize proof layout:

```
Standard layout:
  Commitments, then all queries, then final polynomial

Optimized layout:
  Group by FRI layer
  Interleave commitments with relevant queries
  Enable streaming verification

Deduplication:
  Remove redundant data
  Reference by offset instead of repeating
```

## SNARK Wrapping

### Concept

Wrap STARK in SNARK:

```
Given: STARK proof P (~150 KB)
       STARK verifier V

SNARK circuit C:
  Input: STARK proof P (private)
  Public input: Statement S
  Constraint: V(P, S) accepts

Output: SNARK proof Q (~200-500 bytes)

Verifying Q confirms P was valid,
without seeing P.
```

### Wrapper Circuit

STARK verifier as SNARK circuit:

```
STARK verifier operations:
  1. Hash computations (Fiat-Shamir, Merkle)
  2. Field arithmetic
  3. FRI consistency checks

In SNARK (e.g., R1CS):
  - Hash: ~100K constraints per hash (for non-native)
          ~1K constraints (for SNARK-friendly hash)
  - Field arithmetic: native
  - Total: 1M - 10M constraints typical
```

### Hash Function Choice

Critical for wrapper efficiency:

```
STARK uses:           SNARK-friendly alternative:
  Blake3                Poseidon
  Keccak                Rescue
  SHA-256               Griffin

Trade-offs:
  - SNARK-friendly: efficient in circuit but slower raw
  - Standard hashes: fast raw but huge in circuit

Hybrid approach:
  Use Poseidon in STARK for recursion-friendly design
  Slightly slower STARK, much smaller wrapper
```

### Trusted Setup Considerations

SNARK wrapping typically needs trusted setup:

```
Options:
  1. Ceremony-based setup (Groth16, etc.)
     - One-time trusted ceremony
     - Universal if using PLONK/Marlin

  2. Transparent SNARK
     - No trusted setup
     - Larger proofs than Groth16
     - Examples: Spartan, Brakedown

  3. Accept STARK size
     - No wrapper, no setup
     - Larger proofs

For most applications:
  Groth16 wrapper with ceremony is practical choice
  ~200-300 byte final proofs
```

## Compression Pipeline

### End-to-End Flow

Complete compression pipeline:

```
1. Generate STARK proof
   Output: ~150 KB proof

2. Apply proof-specific compression
   - Merkle deduplication
   - Field packing
   Output: ~100 KB compressed proof

3. Apply generic compression (optional)
   Output: ~80 KB compressed proof

4. For on-chain: SNARK wrapping
   Output: ~300 byte SNARK proof
```

### Compression for Different Uses

Match compression to use case:

```
Off-chain storage:
  Level 1-2 compression sufficient
  Fast decompression
  No trusted setup

Off-chain verification:
  Minimal compression
  Direct STARK verification
  Fastest end-to-end

On-chain verification:
  Maximum compression (SNARK wrap)
  Worth the prover overhead
  Minimize gas cost
```

### Verification After Compression

Verifying compressed proofs:

```
Level 1-2 compression:
  Decompress to standard format
  Normal STARK verification

SNARK wrapped:
  SNARK verification only
  Much faster than STARK verification
  Different security assumptions
```

## Performance Analysis

### Compression Ratios

Typical compression achieved:

```
Technique           | Ratio  | Final Size
--------------------|--------|------------
Uncompressed        | 1x     | 150 KB
Encoding optimization| 0.85x  | 127 KB
Proof-specific      | 0.70x  | 105 KB
Generic (zstd)      | 0.60x  | 90 KB
Combined (no SNARK) | 0.50x  | 75 KB
SNARK wrapped       | 0.002x | 300 bytes
```

### Computation Overhead

Time cost of compression:

```
Encoding optimization: Negligible (<1ms)
Merkle deduplication: O(Q * log N) operations (~10ms)
Generic compression: ~10-100ms
SNARK wrapping: 10-60 seconds

For comparison:
  STARK generation: 10-60 seconds
  SNARK wrap adds similar time
```

### Verification Time

Verify compressed vs. uncompressed:

```
STARK verification: ~10-50 ms
Decompression overhead: <1 ms
Total with compression: ~10-50 ms

SNARK verification: ~1-10 ms
  (Depends on SNARK type)

On-chain (Ethereum):
  STARK: Impractical (too expensive)
  SNARK: ~200-300K gas
```

## Implementation Considerations

### Format Specification

Compressed proof format:

```
Header:
  version: 1 byte
  compression_flags: 1 byte
  original_size: 4 bytes

Body:
  compressed_data: variable

Footer:
  checksum: 4 bytes

Flags indicate:
  - Which compression levels applied
  - Whether SNARK wrapped
  - Decompression parameters
```

### Streaming Decompression

For memory-constrained verifiers:

```
Don't decompress entire proof at once:
  1. Stream header, extract metadata
  2. Stream each layer as needed
  3. Verify incrementally
  4. Discard processed data

Memory usage:
  O(layer_size) instead of O(proof_size)
```

### Error Handling

Handling corrupted compressed proofs:

```
Checksums:
  Detect transmission errors
  Reject before expensive verification

Validation:
  Check format before decompression
  Verify lengths match expectations
  Fail fast on malformed data
```

## Key Concepts

- **Encoding optimization**: Compact byte representation
- **Proof-specific compression**: Exploit proof structure
- **SNARK wrapping**: Verify STARK inside SNARK
- **Compression ratio**: Size reduction achieved
- **Verification overhead**: Cost of decompression/verification

## Design Considerations

### Compression vs. Compatibility

| Standard Format | Custom Compression |
|-----------------|-------------------|
| Widely compatible | Specific to system |
| Larger size | Smaller size |
| Easier debugging | Harder to inspect |
| More implementations | Single implementation |

### When to SNARK Wrap

| Wrap | Don't Wrap |
|------|-----------|
| On-chain verification | Off-chain verification |
| Size is critical | Size is acceptable |
| Trusted setup OK | Must be transparent |
| Post-quantum not required | Need post-quantum |

## Related Topics

- [Proof Aggregation](01-proof-aggregation.md) - Combining proofs
- [Proof Recursion](02-proof-recursion.md) - Recursive structures
- [Verification Complexity](../../02-stark-proving-system/05-verification/02-verification-complexity.md) - Verification costs
- [Proof Structure](../../02-stark-proving-system/01-stark-overview/03-proof-structure.md) - What gets compressed
