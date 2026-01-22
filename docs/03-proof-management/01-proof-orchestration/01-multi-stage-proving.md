# Multi-Stage Proving

## Overview

Multi-stage proving organizes the proof generation process into sequential phases where each stage produces commitments that become inputs for subsequent stages. This architectural pattern enables the prover to generate verifier challenges based on committed values, implementing the Fiat-Shamir transformation correctly while supporting complex constraint systems that require multiple rounds of interaction.

The staging model reflects the mathematical structure of modern proof systems. In a single-stage approach, the prover would commit to all values simultaneously, but this prevents the use of challenges derived from committed data within constraint evaluation. Multi-stage proving solves this by allowing the prover to commit, receive challenges, compute challenge-dependent values, commit again, and continue this pattern until all proof components are generated.

Understanding multi-stage proving is essential for implementing efficient proof systems. The number of stages affects proof generation time, memory usage, and the expressiveness of constraints. Designers must balance the need for challenge-dependent computation against the overhead of additional commitment rounds. This document covers stage structure, inter-stage communication, and orchestration patterns.

## Stage Fundamentals

### Stage Definition

What constitutes a proving stage:

```
Stage components:
  Input: Values from previous stages (or initial witness)
  Computation: Generate new values using inputs and challenges
  Output: Commitments to computed values
  Challenge: Verifier randomness derived from commitments

Stage boundary:
  Marked by commitment to new polynomials
  Challenge generation from transcript
  State checkpoint for resumability

Properties:
  Deterministic given inputs
  Produces verifiable commitments
  Enables challenge-based computation
```

### Stage Dependencies

How stages relate to each other:

```
Forward dependencies:
  Stage N+1 receives:
    All commitments from stages 0..N
    All challenges from stages 0..N
    Selected witness values

Challenge derivation:
  challenge_N = Hash(transcript || commitment_N)
  Fiat-Shamir: deterministic from public data
  Verifier can recompute all challenges

Backward references:
  Later stages may reference earlier polynomials
  Constraint evaluation spans all stages
  Final quotient combines all constraints
```

### Stage Artifacts

What each stage produces:

```
Polynomial commitments:
  Merkle roots of evaluations
  Opening proofs (generated later)

Transcript updates:
  Append commitment hashes
  Record stage metadata

Intermediate values:
  Challenge-dependent polynomials
  Accumulated sums for arguments
  Lookup/permutation accumulators
```

## Stage Structure

### Witness Stage

Initial stage with execution trace:

```
Inputs:
  Program execution result
  Public inputs
  Private witness values

Computations:
  Organize into trace columns
  Compute derived witness values
  Prepare for polynomial encoding

Outputs:
  Trace polynomial commitments
  Column structure metadata

Characteristics:
  Largest data volume
  No challenge dependencies
  Foundation for all later stages
```

### Permutation Stage

Stage for permutation arguments:

```
Inputs:
  Witness polynomials from stage 0
  Permutation challenge (beta, gamma)

Computations:
  Z(X) = accumulator polynomial
  Z(ω^i) = Z(ω^(i-1)) * ratio(i)
  Where ratio involves permuted values

Outputs:
  Permutation accumulator commitment
  Grand product final value (should be 1)

Purpose:
  Proves column relationships
  Enables copy constraints
  Verifies wiring between cells
```

### Lookup Stage

Stage for lookup arguments:

```
Inputs:
  Witness polynomials
  Table polynomials
  Lookup challenge (alpha, beta)

Computations:
  Log-derivative accumulator
  Sum of 1/(challenge - value) terms
  Table and witness sides separately

Outputs:
  Lookup accumulator commitments
  Final sum equality (should match)

Purpose:
  Proves values exist in tables
  Efficient range checks
  Complex operation verification
```

### Quotient Stage

Final computational stage:

```
Inputs:
  All previous commitments
  All challenges
  Constraint evaluation point

Computations:
  Evaluate all constraints
  Combine with challenge powers
  Divide by vanishing polynomial
  Split into degree-bounded parts

Outputs:
  Quotient polynomial commitments
  Degree verification data

Characteristics:
  Most complex computation
  Combines all constraint types
  Enables soundness verification
```

## Orchestration Patterns

### Sequential Orchestration

Simple stage-by-stage execution:

```
Pattern:
  for stage in stages:
    inputs = gather_inputs(stage)
    values = compute_stage(stage, inputs)
    commitment = commit(values)
    challenge = derive_challenge(commitment)

Advantages:
  Simple implementation
  Predictable memory usage
  Easy debugging

Disadvantages:
  No parallelism across stages
  Blocking on commitment completion
  Higher latency
```

### Pipelined Orchestration

Overlapping stage computation:

```
Pattern:
  while not all_complete:
    # Start next stage if inputs ready
    if can_start_stage(next_stage):
      start_async(next_stage)

    # Complete stages in order
    complete_pending_stages()

Advantages:
  Better resource utilization
  Reduced total latency
  Commitment overlap with computation

Constraints:
  Must maintain stage ordering
  Challenges still sequential
  Memory for multiple stages
```

### Checkpoint-Based Orchestration

Resumable proving:

```
Checkpoint structure:
  Stage number
  Committed values
  Current transcript
  Intermediate state

Save points:
  After each stage completion
  Periodic within long stages
  Before expensive operations

Recovery:
  Load checkpoint
  Verify transcript consistency
  Resume from stage

Use cases:
  Long proofs
  Unreliable environments
  Distributed proving
```

## Inter-Stage Communication

### Transcript Management

Maintaining Fiat-Shamir transcript:

```
Transcript operations:
  append(commitment): Add to transcript
  challenge(): Derive challenge from state
  fork(): Create sub-transcript for recursion

Consistency:
  Prover and verifier same operations
  Deterministic challenge derivation
  No hidden state

Implementation:
  Hash-based (absorb-squeeze)
  Append-only for security
  Serialization must match exactly
```

### Data Passing

Moving values between stages:

```
Direct passing:
  Keep polynomials in memory
  Fast access
  High memory usage

Commitment-based:
  Store commitments only
  Re-evaluate when needed
  Lower memory, more computation

Hybrid:
  Keep frequently accessed values
  Commit and store large/rare values

Selection criteria:
  Stage computation patterns
  Memory constraints
  Access frequency
```

### Challenge Distribution

Propagating verifier randomness:

```
Challenge sources:
  Main transcript challenges
  Sub-challenges for batching
  Domain-specific challenges

Distribution pattern:
  Single source of truth
  Pass to all components needing it
  Verify consistent usage

Challenge types:
  Field element challenges
  Boolean challenges (query bits)
  Structured challenges (evaluation points)
```

## Stage Optimization

### Stage Merging

Combining related stages:

```
When to merge:
  No challenge dependency between stages
  Shared computation benefits
  Memory allows combined processing

Merge candidates:
  Multiple permutation arguments
  Independent lookup arguments
  Non-interacting constraint groups

Benefits:
  Fewer commitment rounds
  Reduced transcript overhead
  Better parallelism within stage
```

### Stage Splitting

Dividing large stages:

```
When to split:
  Stage exceeds memory limits
  Parallelization opportunities
  Checkpoint granularity needed

Split strategies:
  By polynomial group
  By constraint type
  By trace segment

Coordination:
  Partial commitments
  Deferred challenge if possible
  Careful dependency tracking
```

### Lazy Computation

Deferring work until needed:

```
Lazy patterns:
  Compute polynomial only when committed
  Derive values on query
  Cache intermediate results

Benefits:
  Lower peak memory
  Skip unused computations
  Better cache utilization

Implementation:
  Thunk-based representation
  Memoization of results
  Careful invalidation
```

## Memory Management

### Per-Stage Allocation

Managing memory across stages:

```
Allocation strategy:
  Pool per stage
  Reuse across stages where possible
  Release early when committed

Peak memory:
  Sum of concurrent stage needs
  Commitment data persistent
  Temporary computation buffers

Reduction techniques:
  Stream large polynomials
  Incremental commitment
  External storage for checkpoints
```

### Polynomial Lifecycle

Tracking polynomial lifetimes:

```
Lifecycle phases:
  1. Creation (witness generation)
  2. Commitment (compute and store root)
  3. Reference (used in constraints)
  4. Query (opening proof generation)
  5. Release (no longer needed)

Optimization:
  Early release when possible
  Share storage for non-overlapping
  Reference counting for sharing
```

## Error Handling

### Stage Failures

Handling errors during proving:

```
Failure types:
  Constraint violation detected
  Memory exhaustion
  Timeout during computation

Recovery options:
  Retry from checkpoint
  Report stage of failure
  Partial result for debugging

Diagnostics:
  Which stage failed
  Which constraint violated
  Resource usage at failure
```

### Consistency Verification

Ensuring stage correctness:

```
Checks:
  Commitment format valid
  Challenge derivation correct
  Accumulator final values match

When to verify:
  After each stage (debug mode)
  At critical checkpoints
  Before final proof assembly

Cost:
  Additional computation
  Enable only when needed
  Separate from production path
```

## Key Concepts

- **Stage**: Unit of proof generation with inputs, computation, and commitment output
- **Transcript**: Accumulator of commitments for challenge derivation
- **Orchestration**: Pattern for executing stages in order
- **Checkpoint**: Saved state for resumable proving
- **Stage dependency**: How later stages use earlier commitments and challenges

## Design Considerations

### Stage Count Trade-offs

| Fewer Stages | More Stages |
|--------------|-------------|
| Faster overall | More flexibility |
| Less transcript overhead | Finer checkpoints |
| Higher memory per stage | Lower memory per stage |
| Less challenge interaction | More challenge-dependent constraints |

### Memory vs Latency

| Low Memory | Low Latency |
|------------|-------------|
| Sequential stages | Pipelined stages |
| Stream polynomials | Buffer in memory |
| Recompute values | Cache everything |
| More checkpoints | Fewer checkpoints |

## Related Topics

- [Challenge Generation](02-challenge-generation.md) - How challenges are derived
- [Proof Aggregation](03-proof-aggregation.md) - Combining proofs
- [FRI Protocol](../../02-stark-proving-system/03-fri-protocol/01-fri-fundamentals.md) - Low-degree testing
- [Fiat-Shamir Transform](../../02-stark-proving-system/04-proof-generation/04-fiat-shamir-transform.md) - Non-interactive challenges

