# Poseidon Hash Function

## Overview

Poseidon is an algebraic hash function specifically designed for zero-knowledge proof systems. It achieves a balance between security and constraint efficiency that has made it one of the most widely adopted hash functions in the zkSNARK and zkSTARK ecosystem.

The key innovation of Poseidon is its "partial rounds" optimization: rather than applying the expensive non-linear S-box to all state elements in every round, Poseidon uses full rounds at the beginning and end with partial rounds in the middle. This significantly reduces constraint count while maintaining security through careful cryptanalytic design.

This document provides a detailed examination of Poseidon's construction, security properties, and implementation considerations.

## Construction Overview

### State and Parameters

Poseidon operates on a state of t field elements. Key parameters:

- **t**: State size (typically 2 to 24)
- **d**: S-box exponent (typically 3, 5, or 7)
- **R_f**: Number of full rounds
- **R_p**: Number of partial rounds
- **p**: Field characteristic

The total number of rounds is R = R_f + R_p.

### Round Structure

Each round consists of three operations applied in sequence:

1. **Add Round Constants (ARC)**: Add round-specific constants to each state element
2. **Substitution Layer (S-box)**: Apply non-linear transformation
3. **Mix Layer (M)**: Multiply state by an MDS matrix

```
State_i+1 = M * S(State_i + RC_i)
```

### Full vs. Partial Rounds

**Full rounds**: S-box applied to all t state elements

```
S-box layer: [S(x_0), S(x_1), ..., S(x_{t-1})]
```

**Partial rounds**: S-box applied to only one state element

```
S-box layer: [S(x_0), x_1, x_2, ..., x_{t-1}]
```

### Round Configuration

The rounds are arranged as:

```
[R_f/2 full rounds] [R_p partial rounds] [R_f/2 full rounds]
```

Full rounds at the beginning and end ensure security against statistical and differential attacks. Partial rounds in the middle provide algebraic security at reduced cost.

## The S-box

### Power Map

Poseidon uses the power map as its S-box:

```
S(x) = x^d
```

### Exponent Selection

The exponent d must satisfy:
- gcd(d, p - 1) = 1 (ensures invertibility)
- d >= 3 (minimum non-linearity)
- d should be small for efficiency

Common choices:

| Field Type | Common d | Reasoning |
|------------|----------|-----------|
| Large prime | 5 | Balance of security and efficiency |
| Binary field | 3 | Sufficient for binary fields |
| Special prime | 7 | Extra security margin |

### Constraint Cost

Computing x^d requires approximately:
- x^3: 2 multiplications (x^2 * x)
- x^5: 3 multiplications (x^4 * x)
- x^7: 4 multiplications (x^4 * x^2 * x)

For a full round with t state elements: t * cost(x^d) multiplications.
For a partial round: 1 * cost(x^d) multiplications.

## The MDS Matrix

### Definition

An MDS (Maximum Distance Separable) matrix ensures optimal diffusion. An n x n matrix M over a field F is MDS if every square submatrix is non-singular.

### Construction

Common MDS construction methods:

**Cauchy matrix**:
```
M[i][j] = 1 / (x_i + y_j)

where x_i and y_j are distinct field elements
```

**Circulant matrix with MDS property**:
```
    [c_0, c_1, ..., c_{t-1}]
M = [c_{t-1}, c_0, ..., c_{t-2}]
    [...]
```

### Efficient Multiplication

For circulant matrices, state multiplication can use FFT-like techniques:

```
y = M * x  computed in O(t log t) operations
```

For small t, direct multiplication with precomputed matrix is often faster.

## Round Constants

### Generation

Round constants are generated deterministically to ensure transparency. A typical approach:

1. Start with a seed (e.g., hash of specification string)
2. Expand using a PRG or hash function
3. Convert to field elements

This provides "nothing-up-my-sleeve" constants that can be independently verified.

### Number of Constants

Total round constants needed:
- Full rounds: t constants per round for R_f rounds
- Partial rounds: 1 constant per round for R_p rounds
- Total: t * R_f + R_p constants

## Sponge Mode

### Sponge Construction

Poseidon is typically used in sponge mode:

```
State = [rate | capacity] = [r elements | c elements]

Total state size: t = r + c
```

### Absorb Phase

To absorb input:
1. Split input into r-element chunks
2. For each chunk:
   - XOR chunk into rate portion
   - Apply Poseidon permutation

```python
def absorb(state, input_chunks):
    for chunk in input_chunks:
        for i in range(len(chunk)):
            state[i] ^= chunk[i]
        state = poseidon_permutation(state)
    return state
```

### Squeeze Phase

To extract output:
1. Output rate portion
2. If more output needed, apply permutation and repeat

```python
def squeeze(state, output_length):
    output = []
    while len(output) < output_length:
        output.extend(state[:rate])
        state = poseidon_permutation(state)
    return output[:output_length]
```

### Capacity and Security

The capacity c determines collision resistance:
- c = 1: ~p/2 bits collision resistance
- c = 2: ~p bits collision resistance (if p < 2^128)

For 128-bit collision resistance with a 64-bit field, need c >= 2.

## Parameter Selection

### Security Level

Given a target security level lambda (e.g., 128 bits):

1. **Against statistical attacks**: R_f full rounds must prevent differential/linear attacks
2. **Against algebraic attacks**: Total rounds must prevent Groebner basis attacks
3. **Against interpolation attacks**: Algebraic degree must exceed p

### Recommended Parameters

Example for 128-bit security with p ~ 2^64:

| t | d | R_f | R_p | Total Rounds |
|---|---|-----|-----|--------------|
| 3 | 5 | 8 | 57 | 65 |
| 4 | 5 | 8 | 56 | 64 |
| 8 | 5 | 8 | 57 | 65 |
| 12 | 5 | 8 | 57 | 65 |

### Cost Analysis

Constraint cost for one Poseidon permutation:
- Full rounds: R_f * t * cost(S-box) + R_f * t * t (matrix multiplication)
- Partial rounds: R_p * 1 * cost(S-box) + R_p * t * t
- Round constants: (R_f * t + R_p) additions

With d = 5 and the parameters above, typical costs range from 200-600 constraints.

## Security Analysis

### Statistical Attacks

**Differential cryptanalysis**: Full rounds ensure that differential probability is negligible. With R_f/2 >= 4 full rounds on each end, the best differential has probability < 2^(-128).

**Linear cryptanalysis**: Similar analysis shows linear correlations are negligible after sufficient full rounds.

### Algebraic Attacks

**Interpolation attacks**: Require degree >= p to approximate the function. With R rounds of x^d, degree ~ d^R. For d = 5 and R = 60, degree > 2^139.

**Groebner basis attacks**: The polynomial system modeling Poseidon has high degree and many variables. Analysis shows attacks require super-polynomial time for recommended parameters.

### Invariant Subspace Attacks

The combination of full and partial rounds prevents invariant subspace attacks that might exploit the partial round structure.

## Implementation

### Basic Implementation

```python
def poseidon_permutation(state, params):
    # params contains: mds_matrix, round_constants, d, r_f, r_p
    t = len(state)
    rc_index = 0

    # First R_f/2 full rounds
    for _ in range(params.r_f // 2):
        state = add_round_constants(state, params.round_constants[rc_index:rc_index+t])
        rc_index += t
        state = full_sbox_layer(state, params.d)
        state = mds_multiply(state, params.mds_matrix)

    # R_p partial rounds
    for _ in range(params.r_p):
        state = add_round_constants(state, params.round_constants[rc_index:rc_index+t])
        rc_index += t
        state = partial_sbox_layer(state, params.d)
        state = mds_multiply(state, params.mds_matrix)

    # Last R_f/2 full rounds
    for _ in range(params.r_f // 2):
        state = add_round_constants(state, params.round_constants[rc_index:rc_index+t])
        rc_index += t
        state = full_sbox_layer(state, params.d)
        state = mds_multiply(state, params.mds_matrix)

    return state

def full_sbox_layer(state, d):
    return [pow(x, d, p) for x in state]

def partial_sbox_layer(state, d):
    state[0] = pow(state[0], d, p)
    return state

def mds_multiply(state, matrix):
    t = len(state)
    result = [0] * t
    for i in range(t):
        for j in range(t):
            result[i] = (result[i] + matrix[i][j] * state[j]) % p
    return result
```

### Optimizations

**Precomputed constants**: Store all round constants and MDS entries in arrays.

**Batch processing**: When hashing many inputs, vectorize operations across batch dimension.

**Specialized partial rounds**: Since only one S-box is computed, optimize the loop structure.

**MDS optimization**: For small t, unroll matrix multiplication completely.

## Use Cases

### Merkle Tree Hashing

Poseidon as a 2-to-1 compression function:

```
Input: left_child (1 element), right_child (1 element)
State: [left, right, 0, 0, ...] (capacity initialized to 0)
Output: Poseidon(state)[0]
```

### Transcript Hashing

For Fiat-Shamir transform:

```
challenge = Poseidon(commitment_1, commitment_2, ...)
```

All public values are absorbed into the sponge, and challenges are squeezed out.

### Record Commitment

Committing to private data:

```
commitment = Poseidon(data, randomness)
```

The randomness provides hiding.

## Comparison with Alternatives

### Poseidon vs. Rescue

| Aspect | Poseidon | Rescue |
|--------|----------|--------|
| S-box | x^d only | x^d and x^(1/d) alternating |
| Rounds | More rounds, partial optimization | Fewer rounds |
| Constraints | Generally fewer | Moderate |
| Security analysis | Extensive | Extensive |

### Poseidon vs. MiMC

| Aspect | Poseidon | MiMC |
|--------|----------|------|
| State size | Variable | Fixed (Feistel) |
| S-box | x^d | x^3 |
| Structure | SPN | Feistel |
| Efficiency | Better for multi-input | Better for few inputs |

## Key Concepts

- **Partial rounds**: S-box on one state element to reduce constraints
- **Full rounds**: S-box on all elements for statistical security
- **MDS matrix**: Provides maximum diffusion between state elements
- **Sponge mode**: Standard usage pattern for variable-length input/output
- **Power map S-box**: x^d provides algebraic non-linearity
- **Round constants**: Break symmetry and prevent structural attacks

## Design Considerations

### Choosing State Size

- Larger t: Better throughput (more data per permutation)
- Smaller t: Fewer constraints per permutation
- Balance based on typical use case (2-to-1 hash vs. long messages)

### Tuning for Your Field

- Field size affects security requirements
- Special primes may allow d optimizations
- Round count depends on field characteristic

### Native vs. Circuit Implementation

**Native**: Optimize for speed; field arithmetic dominates
**Circuit**: Optimize for constraint count; structure matters

Some implementations provide both variants.

### Parameter Validation

Before deploying:
- Verify parameters against published security analysis
- Check round constant generation matches specification
- Test against known test vectors
- Review for implementation correctness

## Related Topics

- [Algebraic Hashes](01-algebraic-hashes.md) - General algebraic hash concepts
- [Prime Fields](../01-finite-fields/01-prime-fields.md) - Underlying field arithmetic
- [Fiat-Shamir Transform](../../02-stark-proving-system/04-proof-generation/04-fiat-shamir-transform.md) - Using Poseidon for challenges
- [Trace Commitment](../../02-stark-proving-system/04-proof-generation/02-trace-commitment.md) - Poseidon in Merkle trees
