# Algebraic Hash Functions

## Overview

Algebraic hash functions are cryptographic hash functions designed specifically for use within zero-knowledge proof systems. Unlike traditional hash functions such as SHA-256 or Keccak that operate on bits with complex bitwise operations, algebraic hashes are built from operations native to finite fields: addition, multiplication, and exponentiation.

This design choice dramatically reduces the constraint complexity when hashing must be proven inside a zero-knowledge circuit. A SHA-256 hash might require tens of thousands of constraints, while an algebraic hash achieving similar security can be expressed in a few hundred field operations.

This document explores the motivation, design principles, and security considerations of algebraic hash functions.

## Why Algebraic Hashes?

### The Constraint Cost Problem

In zero-knowledge proofs, every computation must be expressed as polynomial constraints over a finite field. Traditional hash functions pose challenges:

**Bitwise Operations**: AND, OR, XOR require decomposing field elements into bits. A 64-bit value needs 64 binary constraints just for representation.

**Non-Native Arithmetic**: SHA-256 uses 32-bit modular arithmetic, which doesn't align with proof system field sizes. Emulating mod 2^32 is expensive.

**Complex Round Functions**: Traditional hashes have intricate round structures optimized for hardware, not for algebraic representation.

### Constraint Comparison

| Hash Function | Approximate Constraints per Hash |
|---------------|----------------------------------|
| SHA-256 | ~25,000 - 30,000 |
| Keccak-256 | ~50,000 - 70,000 |
| Poseidon | ~200 - 500 |
| Rescue | ~300 - 600 |

Algebraic hashes provide 100x+ improvement in constraint efficiency.

### Use Cases

Algebraic hashes are essential when:
- Hashing occurs inside the proven computation
- Merkle trees are verified within the proof
- Fiat-Shamir challenges are computed in-circuit
- Recursive proofs verify inner proof hashes

## Design Principles

### Native Field Operations

Algebraic hashes use only:
- Field addition: a + b
- Field multiplication: a * b
- Fixed exponentiations: a^d for small d

These operations map directly to low-degree polynomial constraints.

### Sponge Construction

Most algebraic hashes use the sponge construction:

```
State: [r bits rate | c bits capacity]

Absorb: XOR input into rate portion, then apply permutation
Squeeze: Output rate portion, apply permutation, repeat if needed
```

The permutation is where algebraic design focuses.

### Security from Algebraic Hardness

Security relies on problems like:
- Finding low-degree relations among outputs
- Distinguishing the permutation from random
- Algebraic attacks exploiting the field structure

Rather than relying on bit-mixing confusion.

### Substitution-Permutation Networks

The common structure is an SPN (Substitution-Permutation Network):

```
For each round:
    1. Add round constants
    2. Apply S-box (non-linear substitution)
    3. Apply linear mixing layer
```

The S-box provides non-linearity; the mixing layer provides diffusion.

## The S-box: Source of Non-linearity

### Power Map S-boxes

The most common algebraic S-box is the power map:

```
S(x) = x^d
```

where d is chosen for:
- **Security**: Low-degree polynomial attacks should be infeasible
- **Efficiency**: d should allow fast computation

### Choosing the Exponent

Common choices for d:

**d = 3 (cubing)**: Minimal degree, maximum efficiency. Requires high round count for security.

**d = 5 (fifth power)**: Slightly higher security per round. x^5 = x^4 * x uses one squaring and one multiplication.

**d = 7**: Higher security margin, more expensive.

**Inverse**: S(x) = x^(-1) = x^(p-2). Very non-linear but expensive.

### Security Considerations

The S-box must resist:

**Interpolation attacks**: Finding low-degree polynomial approximations
**Differential attacks**: Exploiting predictable differences through the S-box
**Algebraic attacks**: Solving equation systems involving S-box outputs

Higher exponents generally provide more resistance but cost more constraints.

## Linear Layer

### Purpose

The linear layer mixes S-box outputs so that:
- Each output bit depends on all input bits
- Local changes propagate globally
- Combined with S-box iterations, security accumulates

### MDS Matrices

Maximum Distance Separable (MDS) matrices provide optimal diffusion:

```
y = M * x

where M is an MDS matrix over the field
```

For an n x n MDS matrix, any n inputs determine all outputs - no information is lost.

### Circulant Matrices

Efficient linear layers use structured matrices:

```
    [c0, c1, c2, ..., c_{n-1}]
M = [c_{n-1}, c0, c1, ..., c_{n-2}]
    [...]
```

Multiplication requires only O(n) field operations using FFT-like techniques.

## Round Constants

### Purpose

Round constants break symmetry and prevent:
- Slide attacks: Using round similarity to find shortcuts
- Fixed-point attacks: Finding inputs that don't change

### Generation

Round constants are typically generated from:
- Expansion of mathematical constants (pi, e)
- Hash of the algorithm specification
- Linear feedback shift registers

The generation must be deterministic and publicly verifiable (nothing-up-my-sleeve).

## Security Analysis

### Algebraic Degree

After r rounds with S-box degree d, the algebraic degree is bounded by:

```
degree <= d^r
```

For security, this should exceed the field size:

```
d^r >= p (field characteristic)
```

With d = 3 and p ~ 2^64, need r >= 40.5.

### Groebner Basis Attacks

Attackers can model the hash as a system of polynomial equations and apply Groebner basis algorithms. Defense:

- Ensure the system has high degree
- Make intermediate values underdetermined
- Use sufficient rounds

### Statistical Attacks

Even algebraic hashes need statistical security:
- Outputs should be indistinguishable from random
- Small input changes cause large output changes
- No detectable biases or correlations

### Concrete Security

Well-designed algebraic hashes target:
- 128-bit security against collision
- 256-bit security against preimage
- Resistance to known algebraic attacks

## Comparison of Algebraic Hash Designs

### Poseidon

- **S-box**: x^5 (or x^3 in some variants)
- **Linear layer**: MDS matrix multiplication
- **Rounds**: Full rounds + partial rounds (optimization)
- **Design**: Optimized specifically for SNARK/STARK constraint systems

### Rescue/Rescue-Prime

- **S-box**: Alternates x^d and x^(1/d) (power and inverse)
- **Linear layer**: MDS matrix
- **Rounds**: Fewer rounds due to stronger S-box
- **Design**: Higher per-round security, balanced cost

### Griffin

- **S-box**: Mixed power maps with different exponents
- **Linear layer**: Optimized circulant matrices
- **Rounds**: Designed for specific field characteristics
- **Design**: Newer, optimized for modern proof systems

### Vision/Anemoi

- **S-box**: More complex non-linear functions
- **Linear layer**: Field-specific optimizations
- **Design**: Cutting-edge research directions

## Implementation Considerations

### Constraint Optimization

Minimize constraint count:
- Reuse intermediate values
- Choose S-box exponent for minimal multiplications
- Optimize linear layer representation

For x^5:
```
t = x^2       (1 multiplication)
u = t^2       (1 multiplication: x^4)
y = u * x     (1 multiplication: x^5)
Total: 3 multiplications
```

### Batching

When hashing multiple values:
- Process in parallel through sponge
- Share round constant computation
- Vectorize field operations

### Partial Rounds Optimization

Some designs use "partial rounds" where only part of the state goes through the S-box:

```
Full round: S-box on all state elements
Partial round: S-box on one element, linear layer on all
```

This reduces constraints while maintaining security through careful analysis.

### Native vs. In-Circuit

**Native (outside circuit)**: Use optimized field arithmetic, no constraint concerns.

**In-circuit (inside proof)**: Every operation becomes a constraint; minimize operations.

Designs may differ depending on context.

## Use in Proof Systems

### Merkle Trees

Algebraic hashes enable efficient Merkle trees inside proofs:

```
Verify Merkle path:
    for each sibling hash:
        current = AlgebraicHash(current, sibling)
    check current == root
```

With Poseidon, this costs ~400 constraints per tree level.

### Fiat-Shamir in Circuit

Recursive proofs must compute Fiat-Shamir challenges:

```
challenge = AlgebraicHash(commitment_1, commitment_2, ...)
```

The hash binds the challenge to prior messages.

### Commitment Schemes

Hash-based commitments for small values:

```
Commit(v, r) = AlgebraicHash(v || r)

where r is random blinding factor
```

Efficient commitment/opening inside circuits.

## Key Concepts

- **Algebraic hash**: Hash function using only field-native operations
- **S-box**: Non-linear substitution, typically x^d
- **MDS matrix**: Maximum diffusion linear layer
- **Sponge construction**: Standard mode for variable-length hashing
- **Round constants**: Symmetry-breaking additions per round
- **Constraint efficiency**: Orders of magnitude fewer constraints than traditional hashes

## Design Considerations

### Security vs. Efficiency Trade-off

| More Rounds | Higher Exponent | Larger State |
|-------------|-----------------|--------------|
| More secure | More secure | More secure |
| More constraints | More multiplications | More state to manage |
| Linear cost | Per-round cost | Diffusion complexity |

### Field Characteristics

Hash designs depend on the field:
- Prime field vs. binary field
- Field size (affects degree requirements)
- Available roots of unity (for FFT optimizations)

### Standardization

Unlike traditional hashes with decades of analysis, algebraic hashes are newer:
- Less cryptanalysis available
- Designs evolve rapidly
- Conservative parameter choices recommended

### Attack Surface

Algebraic structure provides attack opportunities:
- Groebner basis methods
- Linearization attacks
- Field-specific shortcuts

Designs must account for these algebraic attack vectors.

## Related Topics

- [Poseidon Hash](02-poseidon-hash.md) - Detailed treatment of the Poseidon construction
- [Prime Fields](../01-finite-fields/01-prime-fields.md) - Underlying field arithmetic
- [Polynomial Commitments](../02-polynomials/03-polynomial-commitments.md) - Hashes in commitment schemes
- [Fiat-Shamir Transform](../../02-stark-proving-system/04-proof-generation/04-fiat-shamir-transform.md) - Non-interactive proofs via hashing
