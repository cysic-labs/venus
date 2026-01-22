# Signature Verification

## Overview

Signature verification is among the most common cryptographic operations in blockchain systems, authenticating every transaction and message. In a zkVM, verifying signatures within the proof enables privacy-preserving authentication and trustless verification of external data. The circuit must prove that a given signature is valid for a message and public key, without revealing the private key.

The two dominant signature schemes in blockchain are ECDSA (used by Bitcoin and Ethereum) and EdDSA (used by many newer systems). Both rely on elliptic curve arithmetic but differ in their structure and verification equations. This document covers the verification circuits for both schemes, including the specific constraints and optimizations for efficient proving.

## ECDSA Verification

### ECDSA Overview

Signature structure and verification:

```
Signature components:
  r: x-coordinate of random point R
  s: Scalar satisfying s = k^(-1)(z + rd) mod n
  v: Recovery id (optional, for public key recovery)

Verification inputs:
  Message hash: z (typically 256 bits)
  Public key: Q = (Qx, Qy)
  Signature: (r, s)

Verification equation:
  R = (z/s)G + (r/s)Q
  Check: Rx mod n == r

Where:
  G: Curve generator
  n: Curve order
```

### Verification Steps

Breaking down verification:

```
Step 1: Compute scalar inverses
  s_inv = s^(-1) mod n

Step 2: Compute scalars
  u1 = z * s_inv mod n
  u2 = r * s_inv mod n

Step 3: Compute point
  R = u1*G + u2*Q

Step 4: Verify
  R.x mod n == r
```

### ECDSA Constraints

Circuit constraints:

```
Modular inverse of s:
  s * s_inv = 1 (mod n)
  s_inv * s - 1 = k * n (for some k)

Scalar computations:
  u1 = z * s_inv (mod n)
  u2 = r * s_inv (mod n)

Scalar multiplications:
  P1 = u1 * G
  P2 = u2 * Q

Point addition:
  R = P1 + P2

Final check:
  R.x mod n = r
  (Handle R.x >= n case)
```

### ECDSA Optimizations

Reducing constraint count:

```
Precomputed tables for G:
  G is fixed, precompute multiples
  Reduces u1*G cost

Shamir's trick:
  Compute u1*G + u2*Q simultaneously
  Single pass through bits

Non-native arithmetic:
  For secp256k1 with BN254 proof field
  Optimized limb representation
```

## EdDSA Verification

### EdDSA Overview

Edwards curve signatures:

```
Curve: Twisted Edwards curve
  -x^2 + y^2 = 1 + dx^2y^2

Common curve: Ed25519
  Base field: 2^255 - 19
  Generator: G (standard point)

Signature components:
  R: Point (encoded)
  S: Scalar

Verification inputs:
  Message: M
  Public key: A (point)
  Signature: (R, S)
```

### Verification Equation

EdDSA verification:

```
Compute hash:
  h = H(R || A || M)

Verification:
  S * G = R + h * A

Equivalently:
  8 * S * G = 8 * R + 8 * h * A
  (Cofactor multiplication for security)

Check:
  Left side equals right side
```

### EdDSA Constraints

Circuit constraints:

```
Hash computation:
  h = SHA-512(R || A || M) (for Ed25519)
  Reduce mod curve order

Left side:
  LHS = S * G
  Scalar multiplication

Right side:
  temp = h * A
  RHS = R + temp
  Scalar mul + point add

Equality:
  LHS.x = RHS.x
  LHS.y = RHS.y
```

### EdDSA Advantages

Why EdDSA is circuit-friendly:

```
No modular inverse:
  ECDSA needs s^(-1)
  EdDSA just multiplies

Deterministic:
  No random nonce k
  Easier to verify

Faster point operations:
  Edwards curves have unified formulas
  No special cases for add vs double
```

## Circuit Organization

### Signature Verification Machine

Precompile structure:

```
Input:
  Message hash (or message + hash precompile)
  Public key (x, y coordinates)
  Signature (r, s for ECDSA; R, S for EdDSA)

Output:
  is_valid: 1 if signature valid, 0 otherwise

Internal:
  Scalar multiplication sub-circuit
  Point addition sub-circuit
  Field/scalar arithmetic
```

### Column Layout

Verification circuit columns:

```
Input columns:
  msg_hash: Message hash (possibly limbed)
  pk_x, pk_y: Public key coordinates
  sig_r, sig_s: Signature components

Intermediate columns:
  s_inv: Inverse of s (ECDSA)
  u1, u2: Computed scalars (ECDSA)
  h: Hash value (EdDSA)

Point computation columns:
  P1_x, P1_y: First scalar mul result
  P2_x, P2_y: Second scalar mul result
  R_x, R_y: Final point

Output columns:
  is_valid: Verification result
```

### Batched Verification

Multiple signatures:

```
Batch verification benefits:
  Amortize table lookups
  Share common computations

For n signatures:
  Individual: n * cost_per_sig
  Batched: n * cost_per_sig * efficiency_factor

Randomized batching:
  Combine signatures with random weights
  Single equation check
  Probabilistic soundness
```

## Non-Native Field Handling

### secp256k1 in BN254

Common mismatch:

```
secp256k1 base field: ~2^256
BN254 scalar field: ~2^254

Representation:
  4 limbs of 64 bits each
  Each limb fits in native field

Operations:
  Addition: Add limbs with carry
  Multiplication: 16 native muls
  Reduction: Mod p using Barrett or Montgomery
```

### Ed25519 in Various Fields

Edwards curve handling:

```
Ed25519 field: 2^255 - 19

Representation:
  5 limbs of 51 bits, or
  4 limbs of 64 bits

Reduction:
  Special form allows fast reduction
  2^255 ≡ 19 (mod p)
```

### Constraint Cost

Non-native overhead:

```
Native field multiplication: 1 constraint
Non-native multiplication: ~100+ constraints

Total verification cost:
  ECDSA (secp256k1): ~100,000-500,000 constraints
  EdDSA (Ed25519): ~50,000-200,000 constraints

Dominated by:
  Scalar multiplications
  Non-native field arithmetic
```

## Public Key Recovery

### ECDSA Recovery

Recovering public key from signature:

```
Given (r, s, v) and message hash z:

Recover R:
  R.x = r (or r + n if v indicates)
  R.y = computed from curve equation (v gives sign)

Recover Q:
  Q = r^(-1) * (s*R - z*G)

Verification:
  Recovered Q matches claimed public key
```

### Recovery Constraints

Circuit for recovery:

```
Point recovery:
  R.x = r (mod p)
  R.y^2 = R.x^3 + 7 (secp256k1)
  y_sign from v parameter

Scalar computations:
  r_inv = r^(-1) (mod n)
  s' = s * r_inv
  z' = z * r_inv

Point computation:
  Q_recovered = s' * R - z' * G

Verification:
  Q_recovered == Q_claimed
```

## Optimization Techniques

### Precomputation

Fixed-base optimizations:

```
Generator G is fixed:
  Precompute multiples of G
  Store as lookup table

Window method:
  Precompute {0, G, 2G, ..., (2^w-1)G}
  Process scalar in windows

In circuit:
  Lookup into precomputed table
  Reduces scalar mul cost
```

### Endomorphism

Curve-specific speedups:

```
secp256k1 endomorphism:
  φ(x, y) = (βx, y) where β^3 = 1
  Efficiently computable

GLV method:
  Split scalar: k = k1 + k2*λ
  k1, k2 are ~128 bits each

Two half-size scalar muls:
  ~2x speedup
```

### Batch Verification

Amortized verification:

```
Multiple signatures {(Ri, Si, Qi)}:

Standard: Verify each independently
  Cost: n * single_verify_cost

Batched: Random linear combination
  Σ ci * Si * G = Σ ci * Ri + Σ ci * hi * Qi
  Random weights ci

Cost: Roughly single_verify_cost + small overhead
Invalid signature detected with high probability
```

## Key Concepts

- **ECDSA**: Signature scheme used by Bitcoin/Ethereum
- **EdDSA**: Modern signature scheme with simpler verification
- **Scalar multiplication**: Core expensive operation
- **Public key recovery**: Deriving key from signature
- **Batch verification**: Amortizing verification cost

## Design Considerations

### Scheme Choice

| ECDSA | EdDSA |
|-------|-------|
| Widely deployed | Modern design |
| Needs inverse | No inverse |
| Malleable | Non-malleable |
| More constraints | Fewer constraints |

### Optimization Trade-offs

| No Precomputation | With Precomputation |
|-------------------|---------------------|
| Smaller circuit | Larger tables |
| Slower | Faster |
| Flexible | Fixed curve |
| Dynamic | Static setup |

## Related Topics

- [Curve Arithmetic](01-curve-arithmetic.md) - Underlying EC operations
- [Pairing Operations](03-pairing-operations.md) - Advanced signatures
- [SHA-256 Circuit](../02-hash-functions/01-sha256-circuit.md) - Message hashing
- [Keccak Circuit](../02-hash-functions/02-keccak-circuit.md) - Ethereum hashing
