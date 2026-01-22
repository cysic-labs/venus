# Proof Recursion

## Overview

Proof recursion is the technique of verifying proofs within proofs, enabling unbounded computation verification through a fixed-size verification circuit. A recursive proof attests that another proof was valid, creating a chain where each link proves the validity of the previous one. This structure enables incrementally verifiable computation, where each step builds on the verified correctness of all prior steps.

Recursion is the foundation of many advanced zkVM applications: blockchain state transitions where each block proves the validity of all preceding blocks, verifiable computation servers that continuously prove their correct operation, and aggregation systems that combine thousands of proofs into one. Understanding recursion mechanics is essential for building practical, scalable proving systems.

This document explores recursion depth, recursive circuit design, incremental verification, and the engineering challenges of recursive proof systems.

## Recursion Fundamentals

### The Core Concept

What recursion means in proofs:

```
Non-recursive:
  Proof P proves "statement S is true"

Recursive:
  Proof P_n proves "P_{n-1} was valid AND step n was correct"

Where P_{n-1} proves "P_{n-2} was valid AND step n-1 was correct"

And so on...

The chain:
  P_0: "step 0 correct"
  P_1: "P_0 valid AND step 1 correct"
  P_2: "P_1 valid AND step 2 correct"
  ...
  P_n: "P_{n-1} valid AND step n correct"

Verifying P_n confirms ALL steps 0..n were correct!
```

### Recursion Types

Different recursive structures:

```
Linear recursion:
  Each proof verifies exactly one previous proof
  P_n = prove(verify(P_{n-1}) AND step_n)

Tree recursion:
  Each proof verifies multiple previous proofs
  P = prove(verify(P_left) AND verify(P_right) AND combine)

Parallel recursion:
  Multiple independent chains, merged periodically
  Useful when steps are independent

Folding:
  Accumulate verification work across steps
  More efficient than full recursive verification
```

### Recursion Depth

How deep recursion can go:

```
Theoretical: Unlimited
  Each recursive step is finite work
  Chain can extend indefinitely

Practical limitations:
  - Numerical precision (field size)
  - Accumulating soundness error
  - Prover time per step

Typical depths:
  - Application chains: thousands to millions of steps
  - With careful design: billions of steps possible
```

## Recursive Circuit Architecture

### Verifier in Circuit

Expressing verification as constraints:

```
STARK Verifier components:
  1. Hash computation (Fiat-Shamir, Merkle)
  2. Field arithmetic (constraint checks)
  3. Comparison and equality checks

As circuit:
  - Hash: ~10K constraints per invocation (algebraic hash)
        ~100K constraints per invocation (SHA-256)
  - Field ops: native (essentially free)
  - Comparison: few constraints per check

Total verifier circuit: 100K - 1M constraints
  Depends heavily on hash function choice
```

### Accumulator Pattern

Accumulating verification work:

```
Instead of full verification each step:
  Accumulate partial verification information

Accumulator A_n contains:
  - Hash of all commitments seen
  - Partial FRI verification state
  - Deferred checks

Each step:
  1. Extend accumulator with new proof data
  2. Perform some verification work
  3. Defer remaining to final check

Final verification:
  Complete all deferred checks
  Constant work regardless of chain length
```

### Folding Schemes

Efficient recursion via folding:

```
Nova/SuperNova pattern:
  Instead of verifying P_{n-1} completely,
  "fold" P_{n-1} with step n computation

Folded instance:
  - Combines previous proof and new step
  - Smaller than full recursive proof
  - Verification work amortized

Benefits:
  - Linear prover time in total steps
  - Constant recursive overhead
  - Smaller intermediate proofs
```

## Incremental Verification

### IVC (Incrementally Verifiable Computation)

Continuous verification model:

```
State at step n: (state_n, proof_n)

Transition:
  state_{n+1} = execute(state_n, input_n)
  proof_{n+1} = prove(
    verify(proof_n) AND
    state_{n+1} = execute(state_n, input_n)
  )

Property:
  proof_n alone proves all steps 0..n were correct
  No need to retain earlier proofs
```

### Proof Size Stability

Keeping proofs small:

```
Naive recursion:
  Each proof contains previous proof as witness
  Size grows: size(P_n) > size(P_{n-1})

Stable recursion:
  Proof size independent of chain length
  Achieved by:
    - Fixed verifier circuit
    - Compressed previous proof representation
    - Accumulator-based approach
```

### Checkpoint Verification

Periodic full verification:

```
Instead of verifying every step:
  Checkpoints at intervals (e.g., every 1000 steps)

Between checkpoints:
  Light verification only
  Accumulate deferred work

At checkpoint:
  Full verification of accumulated work
  Reset accumulator

Benefits:
  - Faster per-step proving
  - Bounded accumulator size
  - Periodic confirmation of correctness
```

## Field and Cycle Considerations

### Field Compatibility

Recursive field requirements:

```
Problem:
  Inner proof uses field F_inner
  Outer circuit uses field F_outer

If F_inner != F_outer:
  Must emulate F_inner arithmetic in F_outer
  Very expensive (many constraints per operation)

Solution approaches:
  1. Same field: F_inner = F_outer (ideal)
  2. Cycle of curves: alternating compatible fields
  3. Field emulation (expensive but flexible)
```

### Cycle of Curves

For elliptic curve-based systems:

```
Curve 1: defined over F_p, order n
Curve 2: defined over F_n, order p

Alternating proofs:
  P_even on Curve 1
  P_odd on Curve 2

Each curve's scalar field is other's base field.
Native arithmetic for verification in either direction.
```

### STARK Field Choice

For STARK recursion:

```
Common approach:
  Use same field throughout
  Goldilocks (2^64 - 2^32 + 1) popular choice

Extension field:
  Base field for main computation
  Extension field for challenges
  Both usable in recursive verification
```

## Performance Characteristics

### Per-Step Overhead

Cost of each recursive step:

```
Verification circuit size: V constraints
Computation circuit size: C constraints

Total per step: V + C constraints

Example:
  V = 500,000 (verifier)
  C = 100,000 (one step of computation)
  Total = 600,000 constraints per recursive step

Proving time:
  ~1-10 seconds per step with optimization
```

### Prover Memory

Memory requirements:

```
Per recursive step:
  - Previous proof data: ~100-200 KB
  - Current witness: proportional to V + C
  - Polynomial storage: O((V + C) * blowup)

Typical:
  - 1-10 GB per recursive step
  - Dominated by polynomial operations
```

### Parallelization

Parallel recursive proving:

```
Linear recursion:
  Strictly sequential
  P_n requires P_{n-1}

Tree parallelism:
  Parallel branches
  Merge at higher levels

Speculation:
  Speculatively compute P_n assuming P_{n-1} valid
  Discard if P_{n-1} fails
```

## Design Patterns

### Continuation Pattern

Long computations in chunks:

```
Full computation: C steps total

Divide into chunks of K steps:
  Chunk 0: steps 0 to K-1
  Chunk 1: steps K to 2K-1
  ...

Each chunk proof:
  Verifies previous chunk proof
  Proves K steps of computation

Benefits:
  - Bounded per-chunk proving time
  - Resume from any chunk
  - Parallel chunk proving (speculation)
```

### State Commitment Pattern

Compressing state between steps:

```
Full state S might be large (e.g., megabytes)

State commitment:
  H(S) is small fixed size (32 bytes)

Recursive proof:
  Proves transition from H(S_n) to H(S_{n+1})
  Actual state passed as witness
  Constraint: hash(witness_state) = H(S_n)
```

### Deferred Verification Pattern

Batch expensive checks:

```
Per step:
  Record data for expensive check
  Don't perform check yet

Periodically:
  Batch all recorded checks
  Amortize fixed costs
  Perform batched verification

Example:
  Signature checks per transaction
  Batch EC operations across transactions
```

## Advanced Recursion

### Multi-Level Recursion

Different recursion at different levels:

```
Level 0: Execution proofs (detailed, high constraint)
Level 1: Batch proofs (verify N level-0 proofs)
Level 2: Epoch proofs (verify M level-1 proofs)
Level 3: Era proofs (verify K level-2 proofs)

Each level optimized for its purpose:
  - Lower levels: fast generation
  - Higher levels: compact proofs
```

### Cross-VM Recursion

Verifying proofs from different VMs:

```
VM_A produces proof P_A
VM_B produces proof P_B

Aggregator:
  Verifies P_A using VM_A's verifier
  Verifies P_B using VM_B's verifier
  Produces combined proof

Requires:
  - Verifier circuits for each VM
  - Compatible field/curve
```

### Infinite State Machines

Recursive proofs for ongoing computation:

```
State machine runs forever:
  State S_t at time t
  Transition: S_{t+1} = f(S_t, input_t)

Recursive proof:
  At any time t, proof P_t proves
  "Starting from S_0, correct execution to S_t"

No end condition:
  Machine runs indefinitely
  Proof updates continuously
```

## Key Concepts

- **Recursion**: Proving proof validity inside another proof
- **IVC**: Incrementally verifiable computation
- **Folding**: Efficient recursion by combining proofs
- **Accumulator**: Deferred verification state
- **Continuation**: Breaking computation into chunks

## Design Considerations

### Recursion Strategy

| Full Verification | Folding/Accumulation |
|-------------------|----------------------|
| Simpler circuit | More complex circuit |
| Higher per-step cost | Lower per-step cost |
| Immediate correctness | Deferred verification |
| Standard proofs | Specialized protocols |

### Depth vs. Breadth

| Deep Chain | Wide Tree |
|------------|-----------|
| Sequential steps | Parallel steps |
| Simple structure | Complex merging |
| Unbounded depth | Bounded depth |
| Linear latency | Logarithmic latency |

## Related Topics

- [Proof Aggregation](01-proof-aggregation.md) - Combining multiple proofs
- [Proof Compression](03-proof-compression.md) - Reducing proof size
- [Verification Algorithm](../../02-stark-proving-system/05-verification/01-verification-algorithm.md) - What gets proved recursively
