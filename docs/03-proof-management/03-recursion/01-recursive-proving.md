# Recursive Proving

## Overview

Recursive proving is a technique where a proof system verifies other proofs as part of its computation. The prover creates a proof that attests not only to a direct computation but also to the validity of previously generated proofs. This enables proof composition, aggregation, and incrementally verifiable computation. Recursion is the key technique for compressing many proofs into a single constant-size proof.

The power of recursion comes from encoding the verification algorithm as a circuit. If verification can be expressed as an arithmetic circuit (which it can for all modern proof systems), then the prover can prove "I ran the verifier on proof P, and it accepted." This creates a proof about a proof. By chaining this construction, arbitrarily long computation histories can be compressed into a single proof.

Understanding recursive proving unlocks advanced proof system capabilities. It enables proof aggregation (combining many proofs into one), incremental verification (adding new computation to an existing proof), and cross-system interoperability (verifying proofs from one system inside another). This document covers recursion fundamentals, verification circuits, and practical applications.

## Recursion Fundamentals

### What is Recursive Proving

The core concept:

```
Standard proving:
  Prover has witness w
  Proves: "C(w) = true"
  Verifier checks proof

Recursive proving:
  Prover has witness w AND proof π
  Proves: "C(w) = true AND Verify(π) = accept"
  Verifier checks composite proof

Chaining:
  Proof π_n attests to:
    Direct statement S_n
    Validity of π_{n-1}
  Single proof for all statements S_1..S_n
```

### Why Recursion Works

Mathematical foundation:

```
Verifier as circuit:
  Verification is an algorithm
  Can express as arithmetic circuit V
  V(proof, public_inputs) → {0, 1}

Proving verification:
  Prove: "V(π, pub) = 1"
  This is just another statement
  Any proof system can prove it

The recursion:
  Proof π_inner proves statement S
  Proof π_outer proves V(π_inner, S) = 1
  Verifying π_outer → confident about S
```

### Recursion Depth

Levels of nesting:

```
Depth 1:
  Prove verification of one proof
  Simple composition

Depth k:
  Prove verification of depth k-1 proof
  Each level adds overhead

Constant depth:
  Single proof verifies single inner proof
  Repeated for sequence
  IVC pattern

Logarithmic depth:
  Tree aggregation
  N proofs → log(N) depth
  Parallelizable
```

## Verification Circuits

### Circuit Structure

Encoding verifier as circuit:

```
Verifier algorithm:
  1. Parse proof structure
  2. Verify commitments
  3. Check polynomial evaluations
  4. Verify FRI/opening proofs
  5. Check challenge derivation

As circuit:
  Each step → constraints
  Hash computations → hash constraints
  Field arithmetic → native constraints
  Random challenges → from transcript

Circuit size:
  Dominated by hash computations
  Merkle path verifications
  FRI query checks
```

### Hash in Circuits

The main cost of recursion:

```
Hash operations needed:
  Commitment verification (Merkle roots)
  Challenge derivation (Fiat-Shamir)
  FRI layer commitments

Standard hashes (SHA-256):
  Many constraints per hash
  Expensive in arithmetic circuits
  ~30,000+ constraints per hash

Algebraic hashes (Poseidon):
  Few constraints per hash
  Native to field arithmetic
  ~300 constraints per hash

Impact:
  Hash choice dominates circuit size
  Orders of magnitude difference
  Design for recursion → algebraic hash
```

### Optimizing Verification Circuits

Reducing circuit size:

```
Techniques:
  Minimize hash operations
  Batch verifications
  Share common sub-computations
  Use prover-assisted hints

Examples:
  Batch Merkle paths with shared roots
  Precompute repeated values
  Decompose verifier steps

Trade-offs:
  Smaller circuit → faster proving
  May need more hints/witnesses
  Complexity in circuit design
```

## Incremental Verifiable Computation

### IVC Pattern

Incrementally adding computation:

```
Concept:
  Long computation: f(f(f(...f(x)...)))
  After each step, update proof
  Proof attests to all previous steps

State:
  S_i = (current_state, proof_i)
  proof_i attests: f^i(x) = current_state

Step:
  Given S_i
  Compute new_state = f(current_state)
  Create proof_{i+1} proving:
    f(current_state) = new_state
    proof_i is valid

Result:
  Proof size constant
  Verifies arbitrary many steps
```

### Folding Schemes

Alternative to full recursion:

```
Folding (Nova-style):
  Instead of proving verification
  Fold two instances into one
  Accumulate relaxed instance

Process:
  Instance I_1, I_2
  Fold to I_12 (single instance)
  I_12 is "accumulator"

Benefits:
  Folding cheaper than proving
  Accumulator constant size
  Final proof once at end

Trade-off:
  More complex commitment
  Different accumulator management
  Weaker intermediate verification
```

## Proof Aggregation

### Tree Aggregation

Combining proofs in tree:

```
Structure:
  Leaves: individual proofs P_1..P_n
  Level 1: Agg(P_1, P_2), Agg(P_3, P_4), ...
  Level 2: Agg(Agg_12, Agg_34), ...
  Root: Single aggregated proof

Verification circuit:
  Takes 2 proofs as input
  Proves both verify
  Produces single proof

Properties:
  Depth: O(log n)
  Work: O(n) proving, O(1) verification
  Parallelizable at each level
```

### Linear Aggregation

Sequential proof combination:

```
Structure:
  Start with P_1
  Aggregate with P_2 → A_12
  Aggregate A_12 with P_3 → A_123
  Continue...

Suitable for:
  Streaming proofs
  Unknown total count
  Simple implementation

Trade-off:
  Sequential dependency
  No parallelism
  Same final result
```

### Selective Aggregation

Combining proofs of different types:

```
Scenario:
  Proofs from different circuits
  Different public input structures
  Need unified verification

Approach:
  Wrapper circuit for each type
  Unified output format
  Aggregate wrapped proofs

Applications:
  Multi-component systems
  Cross-chain verification
  Heterogeneous proofs
```

## Cross-System Recursion

### Verifying External Proofs

Proofs from other systems:

```
Scenario:
  System A proof
  System B verifier
  Prove validity in System B

Requirements:
  Encode System A verifier in System B
  Handle different fields/curves
  May need field emulation

Challenges:
  Different algebraic structures
  Efficiency loss
  Complexity of foreign verifier
```

### STARK to SNARK

Common pattern:

```
Why:
  STARK: large proofs, fast proving
  SNARK: small proofs, slow proving
  Best of both worlds

Process:
  Prove computation with STARK
  Wrap STARK proof with SNARK
  Final proof is small SNARK

Implementation:
  STARK verifier as SNARK circuit
  Hash-heavy (STARK uses hashes)
  Algebraic hash critical for efficiency
```

### Field Compatibility

Handling different fields:

```
Same field:
  Native recursion
  Efficient
  Direct implementation

Different fields:
  Non-native arithmetic
  Field emulation
  Significant overhead

Solutions:
  Choose compatible fields
  Use multi-scalar techniques
  Cycle of curves (for pairing-based)
```

## Practical Considerations

### Circuit Size Limits

Managing verifier circuit:

```
Constraints:
  Larger circuit → more proving time
  Memory limits
  May need circuit splitting

STARK verifier:
  Hash-heavy → many constraints
  FRI queries → scaling with security

Optimization:
  Reduce FRI queries if recursing
  Algebraic hash mandatory
  Careful parameter selection
```

### Proving Overhead

Cost of recursive proof:

```
Overhead factors:
  Verification circuit size
  Proof system overhead
  Witness generation

Typical overhead:
  5-50x vs non-recursive proof
  Depends heavily on hash choice
  Amortizes over many inner proofs

Trade-off analysis:
  When does recursion pay off?
  Depends on aggregation count
  Compare: N × verify vs 1 × recursive
```

### Memory Requirements

Resources for recursive proving:

```
Memory needs:
  Inner proof storage
  Verification circuit
  Witness for recursive proof

Peak memory:
  Usually during recursive proving
  Multiple proof representations
  May need streaming

Optimization:
  Discard intermediate values
  Compress inner proofs
  Careful allocation
```

## Applications

### Blockchain Scaling

Proof compression for L2:

```
Pattern:
  Many transactions → many proofs
  Aggregate into single proof
  Post single proof to L1

Benefits:
  Amortized verification cost
  Reduced chain data
  Scalable throughput

Implementation:
  Batch transactions
  Recursive aggregation
  Periodic settlement
```

### Long Computations

Proving extensive execution:

```
Pattern:
  Computation too large for single proof
  Split into segments
  Prove segments, chain recursively

IVC application:
  Each step updates proof
  Final proof for entire computation
  Constant proof size
```

### Cross-Chain Verification

Verifying proofs across chains:

```
Pattern:
  Chain A generates proof
  Chain B needs to verify
  Different proof systems

Solution:
  Wrap Chain A proof
  Verify in Chain B native system
  Bridge with recursive proofs
```

## Key Concepts

- **Recursive proving**: Proving the validity of other proofs
- **Verification circuit**: Encoding verifier as arithmetic circuit
- **IVC**: Incrementally verifiable computation through recursion
- **Folding**: Accumulating instances without full verification
- **Cross-system recursion**: Verifying proofs from different systems

## Design Considerations

### Recursion Strategy

| Full Recursion | Folding |
|----------------|---------|
| Complete verification each step | Deferred verification |
| Higher overhead per step | Lower overhead per step |
| Strong intermediate guarantees | Weaker until final |
| Any proof system | Specific schemes |

### Hash Function Choice

| Standard Hash | Algebraic Hash |
|---------------|----------------|
| SHA-256, BLAKE3 | Poseidon, Rescue |
| Many constraints | Few constraints |
| Well-analyzed | Newer |
| Slow recursion | Fast recursion |

## Related Topics

- [Proof Compression](02-proof-compression.md) - Making proofs smaller
- [SNARK Wrapping](03-snark-wrapping.md) - STARK to SNARK conversion
- [Proof Aggregation](../01-proof-orchestration/03-proof-aggregation.md) - Combining proofs
- [FRI Protocol](../../02-stark-proving-system/03-fri-protocol/01-fri-fundamentals.md) - STARK verification

