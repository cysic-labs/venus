# BLS12-381 Operations

## Overview

BLS12-381 is a pairing-friendly elliptic curve designed for security and efficiency, widely adopted in Ethereum 2.0 for BLS signatures and other cryptographic operations. The curve provides approximately 128 bits of security with a 381-bit base field, making it suitable for long-term cryptographic applications. The zkVM must support BLS12-381 operations to enable signature aggregation and proof verification.

BLS12-381 is named for its embedding degree of 12 and a 381-bit prime field. Like BN254, it supports bilinear pairings but with different security properties and performance characteristics. The curve is specifically designed to have efficient pairing computation while maintaining high security levels.

This document covers BLS12-381 curve parameters, G1 and G2 operations, pairing computation, and BLS signature support.

## Curve Parameters

### Base Field

BLS12-381 base field:

```
Field prime p:
  p = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
  381-bit prime

Special form:
  p = (x - 1)^2 * (x^4 - x^2 + 1) / 3 + x
  where x = -0xd201000000010000
```

### Curve Equations

G1 and G2 curves:

```
G1 curve over F_p:
  y^2 = x^3 + 4

G2 curve over F_p^2:
  y^2 = x^3 + 4(1 + i)
  Where i^2 = -1
```

### Group Orders

Orders and cofactors:

```
Subgroup order r:
  r = 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001
  255-bit value

Cofactors:
  h1 = (x - 1)^2 / 3 for G1
  h2 = larger value for G2
```

## Extension Fields

### F_p^2 Construction

Quadratic extension:

```
Construction:
  F_p^2 = F_p[u] / (u^2 + 1)
  Elements: a + b*u

Arithmetic:
  Same as BN254 F_p^2
  But larger base field elements
```

### F_p^12 Construction

Tower extension for GT:

```
Tower:
  F_p → F_p^2 → F_p^6 → F_p^12

F_p^6 = F_p^2[v] / (v^3 - (1 + u))
F_p^12 = F_p^6[w] / (w^2 - v)
```

### 384-bit Arithmetic

Field operations:

```
Each F_p element:
  381 bits, stored in 384 bits
  6 × 64-bit limbs typically

F_p multiplication:
  More expensive than BN254
  ~1.5x limb operations
```

## G1 Operations

### G1 Point Representation

G1 point format:

```
Affine:
  (x, y) where x, y ∈ F_p
  96 bytes total (48 per coordinate)

Compressed:
  48 bytes (x only + sign bit)
  Decompression computes y
```

### G1 Addition

Adding G1 points:

```
Same formulas as other curves:
  Chord-tangent method

Key difference:
  384-bit field arithmetic
  Larger constraints
```

### G1 Scalar Multiplication

Scalar mul optimizations:

```
Endomorphism:
  BLS12-381 has GLV endomorphism
  Decompose scalar for efficiency

Window methods:
  Standard techniques apply
  Precomputation for fixed bases
```

### Subgroup Check

Verifying G1 subgroup:

```
Check:
  Point has order r
  Not just on curve

Methods:
  Multiply by cofactor and check
  Or: verify r * P = infinity
```

## G2 Operations

### G2 Point Representation

G2 point format:

```
Affine:
  (x, y) where x, y ∈ F_p^2
  192 bytes total

Structure:
  x = x0 + x1 * u
  y = y0 + y1 * u
  Four F_p elements
```

### G2 Arithmetic

Operations in F_p^2:

```
Addition:
  Standard curve formulas
  Operations in F_p^2

Cost:
  F_p^2 multiply: ~3 F_p multiplies
  More constraints than G1
```

### G2 Subgroup Check

Verifying G2 membership:

```
Critical check:
  G2 has larger cofactor
  Must verify subgroup membership

Methods:
  Cofactor multiplication expensive
  Fast subgroup checks developed
```

## Pairing Operations

### Optimal Ate Pairing

BLS12-381 pairing:

```
Optimal ate:
  Efficient pairing algorithm
  Miller loop with specific parameter

Parameter:
  Based on curve construction parameter x
  Determines loop length
```

### Miller Loop

Computing Miller function:

```
Loop structure:
  Iterate over bits of parameter
  Accumulate line functions

Lines:
  Tangent lines (doubling)
  Chord lines (addition)
```

### Final Exponentiation

Raising to (p^12-1)/r:

```
Structure:
  Easy part: (p^6 - 1) * (p^2 + 1)
  Hard part: (p^4 - p^2 + 1) / r

Optimization:
  Frobenius for easy part
  Careful sequencing for hard part
```

## BLS Signatures

### Signature Scheme

BLS signature structure:

```
Key generation:
  sk: random scalar in [1, r)
  pk: sk * G2 (public key in G2)

Signing:
  H = hash-to-curve(message)
  σ = sk * H (signature in G1)

Verification:
  Check e(σ, G2) = e(H, pk)
```

### Hash to Curve

Mapping messages to G1:

```
Hash-to-field:
  Expand message to field elements
  Using approved XOF (like SHAKE)

Map-to-curve:
  SSWU or Icart map
  Clear cofactor
```

### Signature Aggregation

Combining signatures:

```
Aggregate:
  σ_agg = σ_1 + σ_2 + ... + σ_n

Verify:
  e(σ_agg, G2) = e(H_1, pk_1) * e(H_2, pk_2) * ...

Optimization:
  Multi-pairing for verification
```

## Constraint Formulations

### 384-bit Field Constraints

Base field operations:

```
Larger than 256-bit:
  More limbs (6 vs 4)
  More carry constraints

Multiplication:
  36 limb products vs 16
  More reduction work
```

### Extension Field Constraints

F_p^2 operations:

```
Similar to BN254:
  3 F_p multiplies per F_p^2 multiply
  But each F_p multiply larger
```

### Pairing Constraints

Full pairing cost:

```
Components:
  Many F_p^12 operations
  Miller loop iterations
  Final exponentiation

Total:
  Significantly more than BN254
  Due to larger field
```

## Optimization Strategies

### Lazy Reduction

Extended precision:

```
Strategy:
  Delay reductions in tower
  Reduce only when needed

Benefit:
  Fewer modular reductions
  Significant savings
```

### Cyclotomic Squaring

Fast squaring in GT:

```
Result of pairing:
  Element of cyclotomic subgroup
  Special squaring formulas

Benefit:
  Faster final exponentiation
  Reduced constraints
```

### Multi-Pairing

Batch verification:

```
Multiple signatures:
  Single multi-pairing
  Shared final exp

BLS aggregation:
  Natural batch structure
  Efficient verification
```

## Precompile Interface

### Input Formats

Operation inputs:

```
G1 point:
  96 bytes (uncompressed)
  Or 48 bytes (compressed)

G2 point:
  192 bytes (uncompressed)
  Or 96 bytes (compressed)

Scalar:
  32 bytes
```

### Operations

Available operations:

```
G1 add, mul
G2 add, mul
Pairing check
Multi-pairing
Hash-to-G1
```

### Output Formats

Operation results:

```
Points:
  Same format as input

Pairing check:
  Boolean result
```

## Ethereum 2.0 Usage

### Beacon Chain

BLS in Ethereum 2.0:

```
Validators:
  BLS public keys
  Sign attestations and blocks

Aggregation:
  Combine signatures
  Efficient verification
```

### Precompiles

Planned precompiles:

```
BLS12-381 operations:
  G1/G2 addition and multiplication
  Pairing check
  Hash-to-curve
```

## Key Concepts

- **BLS12-381 curve**: 381-bit pairing-friendly curve
- **G1 and G2**: Curve groups (different sizes)
- **Optimal ate pairing**: Efficient pairing algorithm
- **BLS signatures**: Aggregatable signature scheme
- **384-bit arithmetic**: Larger field operations

## Design Trade-offs

### Field Size

| 384-bit | 256-bit (BN254) |
|---------|-----------------|
| Higher security | Lower security |
| More constraints | Fewer constraints |
| Larger proofs | Smaller proofs |

### Compression

| Uncompressed | Compressed |
|--------------|------------|
| Faster processing | Smaller size |
| No sqrt needed | sqrt for decompression |
| More bytes | Fewer bytes |

## Related Topics

- [384-bit Arithmetic](../03-arithmetic-precompiles/02-384-bit-arithmetic.md) - Field arithmetic
- [BN254 Operations](02-bn254-operations.md) - Alternative pairing curve
- [Modular Arithmetic](../03-arithmetic-precompiles/03-modular-arithmetic.md) - Field operations
- [Constraint Representation](../01-precompile-design/02-constraint-representation.md) - Encoding techniques

