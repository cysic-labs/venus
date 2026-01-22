# FRI Query and Verification

## Overview

The query phase is where FRI soundness materializes - it transforms commitments and challenges into a concrete test that catches cheating provers with high probability. During this phase, the verifier selects random positions and requests the prover to reveal polynomial evaluations at those positions across all FRI layers. The verifier then checks that the revealed values are consistent with the committed Merkle trees and that the folding relations hold between successive layers.

The query phase design balances security against efficiency. More queries provide stronger soundness guarantees but increase proof size linearly. Each query requires opening Merkle paths in all committed layers, so the total proof size is roughly (number of queries) * (number of layers) * (Merkle path size). Understanding this trade-off is essential for configuring FRI parameters appropriately.

This document details the query protocol, verification procedures, and the analysis connecting query count to soundness error.

## Query Protocol Structure

### Query Generation

After the commit phase, queries are generated deterministically:

```
Input: Final transcript (all Merkle roots and challenges)
       Number of queries q
       Initial domain size n

For i = 0 to q-1:
  seed_i = Hash(transcript || "query" || i)
  position_i = seed_i mod (n/2)

Output: Query positions {position_0, position_1, ..., position_{q-1}}
```

The division by 2 accounts for the pairing structure - each query position implicitly includes its paired element.

### Query Positions Across Layers

Each initial query position maps to positions in successive layers:

```
Layer 0: Position p_0 and paired position p_0 + n/2
         (where n is initial domain size)

Layer 1: Position p_1 = p_0 mod (n/4) and paired position
         (domain size is n/2)

Layer 2: Position p_2 = p_1 mod (n/8) and paired position
         ...

General: p_{k+1} = p_k mod (|D_{k+1}|/2)
```

### Prover's Response

For each query, the prover provides:

```
Query Response for position p:
  Layer 0:
    - Value P_0(x) where x = domain_0[p]
    - Value P_0(-x) = P_0(domain_0[p + n/2])
    - Merkle proof for both values in commitment_0

  Layer 1:
    - Value P_1(y) where y = x^2
    - Value P_1(-y)
    - Merkle proof for both values in commitment_1

  ... (all layers)

  Final Layer:
    - Polynomial coefficients (small, sent directly)
```

### Coset Query Structure

When using cosets for evaluation:

```
Trace domain: H of size n_trace
Evaluation domain: g * H_ext of size n_eval = blowup * n_trace

Query position p in evaluation domain:
- Corresponds to point g * omega_ext^p
- Paired with g * omega_ext^{p + n_eval/2} = -g * omega_ext^p
```

## Merkle Opening

### Path Structure

Each Merkle opening proves a leaf is part of the committed tree:

```
Merkle Tree for n leaves:

  Level 0 (leaves): L_0, L_1, ..., L_{n-1}
  Level 1: H(L_0 || L_1), H(L_2 || L_3), ...
  Level 2: ...
  Level log(n) (root): Single hash value

Opening for leaf L_i:
  - Sibling at each level from leaf to root
  - log(n) hash values total
```

### Batched Leaves

For efficiency, multiple field elements per leaf:

```
Leaf structure (example with 4 elements per leaf):
  Leaf_j = Hash(eval[4j] || eval[4j+1] || eval[4j+2] || eval[4j+3])

Benefits:
- Smaller tree (fewer levels)
- Smaller proofs (fewer siblings)
- Must open entire leaf even if only need one element

Trade-off: May reveal more evaluations than strictly necessary
```

### Opening Verification

Verifier checks Merkle openings:

```
Verify(root, position, value, path):
  current = Hash(value)  // Or Hash of leaf contents

  For each level from bottom to top:
    sibling = path[level]
    if position is even:
      current = Hash(current || sibling)
    else:
      current = Hash(sibling || current)
    position = position / 2

  Return current == root
```

## Folding Verification

### Single Layer Check

Verify folding between adjacent layers:

```
Given:
  - P_i values at x and -x
  - P_{i+1} value at y = x^2
  - Folding challenge alpha_i

Compute expected:
  sum = P_i(x) + P_i(-x)
  diff = P_i(x) - P_i(-x)
  two_inv = 2^{-1} mod p

  expected = sum * two_inv + alpha_i * diff * two_inv * x^{-1}

  // Alternatively:
  // p_even = sum * two_inv
  // p_odd = diff * (2 * x)^{-1}
  // expected = p_even + alpha_i * p_odd

Check: expected == P_{i+1}(y)
```

### Complete Query Verification

Full verification for one query:

```
VerifyQuery(position, response, commitments, challenges):
  x = initial_domain[position]

  For layer = 0 to num_layers - 2:
    // Verify Merkle openings
    if not VerifyMerkle(commitments[layer],
                        position_in_layer,
                        (response[layer].value_pos, response[layer].value_neg),
                        response[layer].merkle_proof):
      return REJECT

    // Verify folding relation
    expected_next = ComputeFolded(response[layer].value_pos,
                                   response[layer].value_neg,
                                   x,
                                   challenges[layer])

    if expected_next != response[layer + 1].value_at_y:
      return REJECT

    // Update for next layer
    x = x^2
    position_in_layer = position_in_layer mod (domain_size[layer+1] / 2)

  // Verify final polynomial
  if not VerifyFinalPolynomial(response[final],
                               commitments[final],
                               x):
    return REJECT

  return ACCEPT
```

### Final Layer Verification

The final polynomial is sent directly (small enough):

```
Final polynomial P_final of degree < d_final

Verifier checks:
1. Degree of P_final is less than d_final
2. P_final(y) matches the claimed folded value
   where y is the query position mapped to final domain
```

## Soundness Analysis

### Query Soundness

Each query catches a cheating prover with probability related to the deviation:

```
If committed function f is delta-far from all degree < d polynomials:
  Pr[single query detects cheating] >= delta * (1 - rate)

  where rate = d / |domain|
```

### Multiple Query Soundness

With q independent queries:

```
Pr[cheater escapes all queries] <= (1 - delta * (1 - rate))^q

For delta = 0.5 (50% of points wrong) and rate = 0.5:
  Pr[escape] <= 0.75^q

  For q = 30: Pr[escape] <= 0.75^30 < 2^{-12}
  For q = 80: Pr[escape] < 2^{-32}
```

### Conjecture vs. Proven Bounds

FRI soundness involves:
- Proven bounds: Guaranteed security but potentially loose
- Conjectured bounds: Tighter estimates based on analysis

```
Proven: soundness_error <= (some_constant * rate)^q
Conjectured: soundness_error <= rate^q (much tighter)
```

Conservative implementations use proven bounds; optimized ones may use conjectures.

### Proximity Gap

The key theoretical result:

```
Proximity Gap Theorem (simplified):
If function f has delta > sqrt(rate) distance from degree-d polynomials,
then with high probability over random challenge alpha,
the folded function has delta' > some_function(delta, rate) distance
from degree-d/2 polynomials.
```

This ensures cheating doesn't become easier through folding.

## Proof Size Analysis

### Components of Proof Size

FRI proof consists of:

```
1. Commitments: One Merkle root per FRI layer
   Size: num_layers * hash_size

2. Query responses: For each query, each layer
   Size: q * num_layers * (2 * field_element_size + merkle_path_size)

3. Final polynomial: Coefficients of small polynomial
   Size: d_final * field_element_size
```

### Concrete Size Calculation

Example with typical parameters:

```
Parameters:
  Initial degree d = 2^20
  Blowup factor = 8
  Domain size n = 8 * 2^20 = 2^23
  Number of FRI layers = 20 (folding to degree 8)
  Queries q = 30
  Field element = 64 bits = 8 bytes
  Hash = 256 bits = 32 bytes
  Elements per leaf = 8

Merkle path size (per layer):
  Tree height = log2(2^23 / 8) = 20 levels
  Path size = 20 * 32 bytes = 640 bytes

Query response size (per query):
  20 layers * (2 * 8 bytes + 640 bytes) ≈ 20 * 656 = 13,120 bytes

Total query responses: 30 * 13,120 ≈ 394 KB

Commitments: 20 * 32 = 640 bytes

Final polynomial: 8 * 8 = 64 bytes

Total proof size: ~395 KB
```

### Optimization Strategies

Reduce proof size:

```
1. Fewer queries (lower security)
2. More elements per Merkle leaf (reveals more data)
3. Smaller hash (lower security)
4. Higher rate / smaller blowup (lower security margin)
5. Proof batching (amortize across multiple proofs)
```

## Verification Complexity

### Operation Count

Verifier operations per query:

```
Per query:
  - Hash computations: num_layers * tree_height
  - Field multiplications: O(num_layers)
  - Field additions: O(num_layers)
  - Field inversions: O(num_layers) (can batch)

Total: O(q * num_layers * log(domain_size)) hash operations
       O(q * num_layers) field operations
```

### Concrete Verification Time

With parameters from size example:

```
Per query:
  - Merkle verification: 20 layers * 20 hashes = 400 hashes
  - Folding checks: 20 field operations

Total: 30 queries * (400 hashes + 20 field ops)
     = 12,000 hashes + 600 field operations

At ~100 hashes/microsecond: ~120 microseconds for hashing
Field operations negligible: ~1 microsecond

Total verification: ~0.2 milliseconds (not counting I/O)
```

### Parallelization

Verification parallelizes across queries:

```
Each query is independent:
  - Separate Merkle paths
  - Separate folding checks

Parallelize: q threads, each handling one query
Speedup: Up to q (perfect parallelism)
```

## Error Handling

### Malformed Proofs

Verifier must handle:

```
Potential issues:
1. Wrong Merkle path length
2. Values outside field
3. Inconsistent position mappings
4. Final polynomial wrong degree

Response: Reject immediately on any structural error
```

### Computation Errors

Defend against:

```
1. Integer overflow: Use proper field arithmetic
2. Division by zero: Check x != 0 before computing x^{-1}
3. Index out of bounds: Validate positions against domain size
```

### Timing Side Channels

For sensitive applications:

```
Ensure constant-time operations:
- Field comparison (for accept/reject)
- Merkle path traversal
- Challenge generation

Avoid early exits that leak query position information
```

## Query Optimization

### Query Deduplication

Queries may share sub-paths in later layers:

```
Query positions 0 and n/4 in layer 0:
  After one fold, both map to position 0 in layer 1
  Can share Merkle opening from layer 1 onwards

Optimization:
  Identify shared paths
  Include each Merkle path only once
  Verifier reconstructs which queries share which paths
```

### Interleaved Verification

Verify while receiving proof (streaming):

```
As prover sends:
1. Receive commitment_0 -> store
2. Receive query response for layer 0 -> verify opening
3. Receive commitment_1 -> store
4. Receive query response for layer 1 -> verify opening + folding
...

Benefits:
- Fail fast on cheating prover
- Lower memory for verifier
- Reduced latency (pipeline effect)
```

### Batched Inverse

Compute all needed inverses at once:

```
Need inverses of: x_0, x_1, ..., x_{q-1} (query positions)

Batch algorithm:
1. Compute prefix products: p_i = x_0 * x_1 * ... * x_i
2. Compute single inverse: inv_all = p_{q-1}^{-1}
3. Derive individual inverses:
   x_{q-1}^{-1} = inv_all * p_{q-2}
   x_{q-2}^{-1} = (x_{q-1}^{-1} * x_{q-1}) * p_{q-3} / p_{q-2}
   ...

Total: 3(q-1) multiplications + 1 inversion
vs. q inversions without batching
```

## Key Concepts

- **Query**: Random position where verifier checks consistency
- **Merkle opening**: Proof that a value belongs to committed tree
- **Folding verification**: Checking algebraic relation between layers
- **Soundness error**: Probability of accepting invalid proof
- **Query count**: Number of independent positions checked

## Design Considerations

### Security vs. Efficiency

| More Queries | Fewer Queries |
|--------------|---------------|
| Higher security | Lower security |
| Larger proofs | Smaller proofs |
| Slower verification | Faster verification |
| More reliable | May need analysis updates |

### Implementation Robustness

- Validate all inputs before processing
- Use constant-time comparisons for security
- Handle edge cases (empty proofs, malformed data)
- Test with adversarial inputs

## Related Topics

- [FRI Fundamentals](01-fri-fundamentals.md) - Protocol overview
- [Folding Algorithm](02-folding-algorithm.md) - Folding mechanics
- [FRI Parameters](04-fri-parameters.md) - Parameter selection
- [Proof Structure](../01-stark-overview/03-proof-structure.md) - Where FRI fits in STARK
