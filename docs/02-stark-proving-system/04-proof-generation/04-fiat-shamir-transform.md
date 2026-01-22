# Fiat-Shamir Transform

## Overview

The Fiat-Shamir transform converts interactive proof protocols into non-interactive ones by replacing verifier challenges with deterministic hash outputs. In STARK proofs, where the prover and verifier would otherwise need multiple rounds of communication, Fiat-Shamir enables a single proof message that can be verified without interaction. The prover computes challenges by hashing the protocol transcript, simulating what an honest verifier would send.

This transformation is essential for practical deployment of STARK proofs. Without Fiat-Shamir, each proof would require real-time communication between prover and verifier, making batch verification, public verification, and asynchronous workflows impossible. The security of the resulting non-interactive proof relies on modeling the hash function as a random oracle - an idealized primitive that returns uniformly random outputs for each new input.

This document covers the Fiat-Shamir mechanism, transcript construction, security considerations, and implementation details for STARK proofs.

## Interactive to Non-Interactive

### Interactive Protocol Structure

A typical interactive STARK protocol:

```
Round 1:
  Prover: Commits to trace polynomials, sends Merkle root r_0
  Verifier: Sends random challenge alpha

Round 2:
  Prover: Computes composition with alpha, commits, sends root r_1
  Verifier: Sends random challenge beta

Round 3:
  Prover: Computes quotient with beta, commits, sends root r_2
  Verifier: Sends random challenge gamma for FRI

FRI Rounds:
  Prover: Commits to folded polynomials
  Verifier: Sends folding challenges

Query Round:
  Verifier: Sends random query positions
  Prover: Opens commitments at query positions

Final:
  Verifier: Checks all openings and relations
```

### Non-Interactive Transformation

Replace each verifier message with hash output:

```
Round 1:
  Prover: Commits to trace, computes r_0
  Prover: Computes alpha = Hash(r_0)

Round 2:
  Prover: Computes composition with alpha, commits to r_1
  Prover: Computes beta = Hash(r_0 || r_1)

Round 3:
  Prover: Computes quotient with beta, commits to r_2
  Prover: Computes gamma = Hash(r_0 || r_1 || r_2)

FRI Rounds:
  Each challenge = Hash(all prior commitments)

Query Round:
  Query positions = Hash(all prior data)

Final Proof:
  All commitments and openings in single message
```

### Verifier Reconstruction

Verifier regenerates challenges:

```
Given proof containing:
  - All Merkle roots (r_0, r_1, r_2, ...)
  - All openings and Merkle paths
  - Final polynomial

Verifier:
  1. Recompute alpha = Hash(r_0)
  2. Recompute beta = Hash(r_0 || r_1)
  3. Recompute gamma = Hash(r_0 || r_1 || r_2)
  ... (all challenges)
  4. Verify openings match recomputed challenges
```

## Transcript Construction

### What Goes in the Transcript

The transcript accumulates all prover messages:

```
Transcript elements (in order):
  1. Public inputs (statement being proved)
  2. First commitment (trace Merkle root)
  3. Second commitment (composition Merkle root)
  4. Third commitment (quotient Merkle root)
  5. FRI layer commitments (multiple roots)
  6. Final polynomial coefficients
  7. Query responses (implicitly via hash)
```

### Canonical Serialization

Elements must be serialized consistently:

```
Field element: Fixed-width big-endian or little-endian bytes
Hash output: Raw bytes (e.g., 32 bytes for 256-bit hash)
Array: Length prefix followed by elements
Merkle root: Hash bytes directly

Example:
  serialize(field_element) = to_bytes_le(element, 8)  // 8 bytes, little-endian
  serialize(root) = root_bytes  // 32 bytes
  serialize([a, b, c]) = serialize(3) || serialize(a) || serialize(b) || serialize(c)
```

### Domain Separation

Prevent cross-protocol attacks:

```
Include domain separator at transcript start:
  transcript = Hash("STARK-PROOF-V1" || public_inputs)

Different proof types use different separators:
  "STARK-PROOF-V1" for standard proofs
  "STARK-RECURSIVE-V1" for recursive proofs
  "STARK-AGGREGATE-V1" for aggregated proofs
```

### Incremental Hashing

Build transcript incrementally:

```
class Transcript:
  def __init__(self, domain_separator):
    self.state = Hash(domain_separator)

  def append(self, data):
    self.state = Hash(self.state || data)

  def challenge(self, label):
    result = Hash(self.state || label)
    self.state = Hash(self.state || result)  // Chain for next challenge
    return result
```

## Challenge Generation

### Field Element Challenges

Most challenges are field elements:

```
def challenge_field_element(transcript, label):
    bytes = transcript.challenge(label)
    // Reduce to field element
    value = int.from_bytes(bytes, 'little')
    return value mod p
```

### Extension Field Challenges

For stronger security, use extension field:

```
def challenge_extension_element(transcript, label):
    // For F_p^2, need two base field elements
    bytes = transcript.challenge(label)
    c0 = int.from_bytes(bytes[0:32], 'little') mod p
    c1 = int.from_bytes(bytes[32:64], 'little') mod p
    return (c0, c1)  // Element of F_p^2
```

### Query Position Challenges

Generate random indices:

```
def challenge_query_positions(transcript, label, num_queries, domain_size):
    positions = []
    counter = 0

    while len(positions) < num_queries:
        bytes = transcript.challenge(label || counter)
        candidate = int.from_bytes(bytes, 'little') mod domain_size

        if candidate not in positions:  // Avoid duplicates
            positions.append(candidate)

        counter += 1

    return positions
```

### Challenge Ordering

Challenges must be generated in correct order:

```
Correct order (matching interactive protocol):
  1. Commit to trace
  2. Get alpha challenge
  3. Commit to composition (uses alpha)
  4. Get beta challenge
  5. Commit to quotient (uses beta)
  6. Get FRI challenges
  7. Get query positions

Wrong order breaks soundness:
  - Cannot get challenge before corresponding commitment
  - Prover could influence challenge by modifying commitment
```

## Security Analysis

### Random Oracle Model

Fiat-Shamir security assumes random oracle:

```
Random Oracle Model:
  - Hash function H behaves as truly random function
  - For each new input x, H(x) is uniformly random
  - Same input always gives same output

In practice:
  - Real hash functions are not random oracles
  - Security proofs in ROM may not transfer
  - Use hash functions with no known weaknesses
```

### Soundness Preservation

Fiat-Shamir preserves soundness with caveats:

```
Interactive soundness: epsilon
Non-interactive soundness: epsilon + adversary_advantage

Where adversary_advantage is negligible if:
  - Hash function is collision-resistant
  - Hash output is large enough (e.g., 256 bits)
  - Transcript includes all prover messages
```

### Potential Attacks

Attacks that Fiat-Shamir must prevent:

```
1. Challenge prediction:
   Attacker guesses challenge before committing
   Prevention: Challenge depends on commitment

2. Selective commitment:
   Attacker tries many commitments to find favorable challenge
   Prevention: Exponentially many attempts needed

3. Transcript manipulation:
   Attacker modifies transcript after generating challenges
   Prevention: Verifier recomputes challenges from transcript

4. Weak randomness:
   Hash output is biased or predictable
   Prevention: Use cryptographic hash with sufficient output size
```

### Sufficient Hash Output Size

Hash output must be large enough:

```
For security level lambda:
  Hash output >= 2 * lambda bits

  128-bit security: Need >= 256-bit hash
  256-bit security: Need >= 512-bit hash

Reasoning:
  - Birthday attacks reduce effective bits by half
  - Want collision resistance and preimage resistance
```

## Implementation Details

### Hash Function Selection

Common choices for STARK proofs:

```
Blake2b-256:
  - Fast on CPU
  - Well-analyzed
  - 256-bit output

Blake3:
  - Very fast
  - Newer but gaining trust
  - Arbitrary output length

SHA3-256 (Keccak):
  - NIST standard
  - Different structure from SHA2
  - Moderate speed

Poseidon:
  - Algebraic hash
  - ZK-friendly but slower
  - Used when hash is proved in ZK
```

### Transcript State Management

Maintain transcript state correctly:

```
Stateful approach:
  transcript = Transcript()
  transcript.append(public_inputs)
  transcript.append(trace_commitment)
  alpha = transcript.challenge("alpha")
  transcript.append(composition_commitment)
  beta = transcript.challenge("beta")
  ...

Pitfalls:
  - Forgetting to append something
  - Appending in wrong order
  - Using wrong labels
```

### Absorb-Squeeze Pattern

Sponge construction pattern:

```
Absorb phase:
  Feed data into hash state

Squeeze phase:
  Extract challenge from hash state

class SpongeTranscript:
  def absorb(self, data):
    self.update_state(data)

  def squeeze(self, output_size):
    result = self.extract(output_size)
    self.update_state(result)  // Prevent reuse
    return result
```

### Debugging Transcript Issues

Common debugging approaches:

```
1. Log transcript state at each step:
   print(f"After appending {label}: state = {state.hex()}")

2. Compare prover and verifier transcripts:
   Both should produce identical challenges

3. Deterministic testing:
   Fixed inputs should give fixed challenges

4. Cross-implementation testing:
   Different implementations should match
```

## Optimizations

### Lazy Hashing

Defer hashing until challenge needed:

```
class LazyTranscript:
  def __init__(self):
    self.pending = []
    self.base_state = initial_state

  def append(self, data):
    self.pending.append(data)

  def challenge(self, label):
    if self.pending:
      combined = join(self.pending)
      self.base_state = Hash(self.base_state || combined)
      self.pending = []

    return Hash(self.base_state || label)
```

### Parallel Challenge Generation

When multiple independent challenges needed:

```
// Need alpha_0, alpha_1, ..., alpha_k
// Can generate in parallel if using counter mode

base = transcript.get_state()
for i in 0..k:
  alpha[i] = Hash(base || "alpha" || i)
```

### Precomputation

Precompute when possible:

```
If public inputs are known in advance:
  precomputed_state = Hash(domain_separator || public_inputs)

Verification can start from precomputed_state
```

## Variations

### Strong Fiat-Shamir

Include more data in transcript:

```
Standard: Hash of prover messages only
Strong: Hash of prover messages + public statement + verifier's public key

Provides stronger binding and non-malleability.
```

### Fiat-Shamir with Aborts

Handle proof generation that may fail:

```
Some protocols allow prover to abort and retry.
Each attempt needs fresh randomness.

Include attempt counter in transcript:
  challenge = Hash(transcript || attempt_number)

Ensures different challenges on retry.
```

### Multi-Round Fiat-Shamir

For complex protocols with nested structure:

```
Outer protocol: Generates outer challenges
Inner protocol: Generates inner challenges (nested transcript)

Ensure inner challenges bind to outer context:
  inner_transcript.absorb(outer_transcript.state)
```

## Key Concepts

- **Fiat-Shamir transform**: Converting interactive proofs to non-interactive
- **Transcript**: Accumulated prover messages used for challenge derivation
- **Random oracle model**: Security assumption treating hash as random function
- **Domain separation**: Preventing cross-protocol attacks
- **Challenge generation**: Deriving verifier challenges from transcript

## Design Considerations

### Security vs. Efficiency

| Conservative | Aggressive |
|--------------|------------|
| Larger hash output | Smaller hash output |
| More transcript elements | Fewer elements |
| Domain separation everywhere | Minimal separation |
| Extension field challenges | Base field challenges |

### Interoperability

For cross-implementation compatibility:

```
Specify precisely:
  - Hash function and configuration
  - Serialization format (endianness, padding)
  - Domain separator string
  - Challenge derivation procedure
  - Order of transcript elements
```

## Related Topics

- [Constraint Evaluation](03-constraint-evaluation.md) - Uses Fiat-Shamir challenges
- [FRI Parameters](../03-fri-protocol/04-fri-parameters.md) - Challenge usage in FRI
- [Security Model](../01-stark-overview/02-security-model.md) - Overall security framework
- [Proof Structure](../01-stark-overview/03-proof-structure.md) - Proof organization
