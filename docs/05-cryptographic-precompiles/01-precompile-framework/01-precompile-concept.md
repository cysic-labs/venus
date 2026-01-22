# Precompile Concept

## Overview

Precompiles are specialized circuits optimized for specific computational tasks that would be inefficient to execute through general-purpose instruction emulation. While a zkVM can technically prove any computation by executing it instruction-by-instruction, cryptographic operations like hashing and elliptic curve arithmetic would require millions of constraints when implemented this way. Precompiles provide dedicated constraint systems for these operations, dramatically reducing proving costs.

The precompile concept mirrors the precompiled contracts in Ethereum, where certain cryptographic operations have native implementations rather than being expressed in bytecode. In a zkVM context, precompiles are constraint systems designed specifically for operations like SHA-256, Keccak-256, or elliptic curve pairings. Programs call these precompiles through a defined interface, and the zkVM proves the operation using the optimized circuit rather than general instruction execution.

This document covers the precompile abstraction, integration patterns, design principles, and trade-offs in precompile implementation.

## Motivation

### Efficiency Gap

Why precompiles are necessary:

```
SHA-256 hash via instruction emulation:
  ~100,000+ RISC-V instructions per hash
  Each instruction: 10-50 constraints
  Total: Millions of constraints per hash

SHA-256 via precompile:
  Dedicated circuit: ~25,000 constraints
  100x+ improvement

The gap widens for complex operations:
  EC pairing: Billions vs millions of constraints
  Signature verification: Thousands vs millions
```

### Common Cryptographic Operations

Operations that benefit from precompiles:

```
Hash functions:
  SHA-256: Bitcoin, general purpose
  Keccak-256: Ethereum compatibility
  Poseidon: ZK-friendly, recursive proofs
  Blake2/Blake3: High performance

Elliptic curve operations:
  Point addition and doubling
  Scalar multiplication
  Pairing computation
  Signature verification (ECDSA, EdDSA)

Modular arithmetic:
  Big integer multiplication
  Modular exponentiation
  Montgomery reduction
```

### Precompile vs Emulation

When to use each:

```
Use precompile when:
  Operation is cryptographic primitive
  Used frequently in programs
  Constraint count is prohibitive otherwise
  Standardized algorithm (SHA-256, secp256k1)

Use emulation when:
  Operation is general computation
  Rare or one-off operation
  Algorithm may change
  Precompile doesn't exist
```

## Precompile Abstraction

### Interface Definition

How programs invoke precompiles:

```
Precompile interface:
  Identifier: Unique precompile ID
  Input: Memory region with input data
  Output: Memory region for output data
  Gas/cost: Proving cost estimate

Invocation pattern:
  1. Program writes input to designated memory
  2. Program triggers precompile (special instruction)
  3. Precompile executes (in prover)
  4. Output appears in designated memory
  5. Execution continues
```

### Memory Convention

Data passing through memory:

```
Input layout:
  Base address: precompile_input_addr
  Input data: serialized parameters
  Length: known or specified

Output layout:
  Base address: precompile_output_addr
  Output data: serialized result
  Length: known or specified

Example (SHA-256):
  Input: message bytes at input_addr
  Length: message_length bytes
  Output: 32-byte hash at output_addr
```

### Precompile Registry

Catalog of available precompiles:

```
Registry structure:
  {precompile_id: (name, input_format, output_format, constraint_cost)}

Standard precompiles:
  0x01: SHA-256
  0x02: Keccak-256
  0x03: RIPEMD-160
  0x04: Identity (copy)
  0x05: Modexp (modular exponentiation)
  0x06: EC Add (elliptic curve point addition)
  0x07: EC Mul (elliptic curve scalar multiplication)
  0x08: EC Pairing (pairing check)
  ...

Custom precompiles:
  Project-specific operations
  Domain-specific accelerators
```

## Integration Model

### Precompile as State Machine

Precompile within zkVM architecture:

```
Main machine:
  Detects precompile invocation
  Records (precompile_id, input_hash, output_hash)
  Delegates to precompile machine

Precompile machine:
  Receives delegation
  Executes specialized circuit
  Returns output commitment

Connection:
  Lookup/permutation links main and precompile
  Cross-machine consistency verified
```

### Invocation Flow

Step-by-step execution:

```
Step 1: Detection
  Main machine sees precompile instruction
  Identifies precompile_id

Step 2: Input capture
  Read input from specified memory region
  Compute input hash/commitment

Step 3: Delegation
  Send (id, input) to precompile machine
  Main machine continues (or waits)

Step 4: Execution
  Precompile machine processes input
  Generates constrained output

Step 5: Output return
  Precompile returns (output, proof_data)
  Main machine receives output

Step 6: Memory update
  Output written to output memory region
  Execution continues
```

### Batched Execution

Processing multiple invocations:

```
Batching model:
  Collect all precompile calls during execution
  Process as batch in precompile machine
  Link via permutation argument

Benefits:
  Amortize fixed costs
  Optimize table lookups
  Parallelize proving

Main trace:
  Records (precompile_id, input_hash, output_hash, call_idx)

Precompile trace:
  Processes calls in potentially different order
  Indexed by call_idx for linking
```

## Design Principles

### Minimal Interface

Keep interface simple:

```
Simple interfaces:
  Fixed-size inputs when possible
  Clear serialization format
  No complex state

Example:
  Hash: input_bytes -> hash_output
  EC mul: (point, scalar) -> result_point

Avoid:
  Stateful precompiles (between calls)
  Complex parameter structures
  Variable-length outputs
```

### Deterministic Execution

No ambiguity in results:

```
Same inputs always produce same outputs:
  Essential for verifiability
  No randomness in precompile

Canonical representations:
  Points in specific encoding
  Big integers in specific format
  Clear edge case handling
```

### Efficient Constraints

Optimize for proving:

```
ZK-friendly design:
  Use field-native operations
  Minimize non-native arithmetic
  Exploit algebraic structure

Example optimizations:
  Poseidon hash: Native field operations
  EC on BLS12-381: Pairing-friendly curves
  Native field: Match proof system's field
```

## Constraint Patterns

### Input Validation

Verify inputs are valid:

```
For elliptic curve point:
  Point is on curve: y^2 = x^3 + ax + b
  Point is in correct subgroup
  Coordinates in valid range

For hash input:
  Length within bounds
  Padding applied correctly

Constraints:
  is_on_curve * (y^2 - x^3 - a*x - b) = 0
  is_in_subgroup * (subgroup_check) = 0
```

### Computation Constraints

Core operation constraints:

```
Hash compression:
  Round function constraints
  State update constraints
  Output extraction

EC addition:
  Point addition formula
  Handle special cases (infinity, doubling)
  Result is on curve
```

### Output Commitment

Link output to main machine:

```
Output hash:
  output_hash = hash(output_data)
  Committed in main machine

Constraint:
  precompile_output_hash = computed_hash(result)

Verification:
  Main machine checks output_hash matches
```

## Error Handling

### Invalid Inputs

Handling malformed inputs:

```
Detection:
  Input validation fails
  Point not on curve
  Invalid length

Response options:
  Return error code
  Trap to error handler
  Return zero/identity

Constraint:
  is_error * (output - error_value) = 0
  !is_error * (output - computed_result) = 0
```

### Edge Cases

Special case handling:

```
EC point at infinity:
  P + O = P
  O + O = O

Zero scalar:
  0 * P = O

Identity input:
  hash("") = specific value

All cases must be correctly constrained.
```

## Key Concepts

- **Precompile**: Optimized circuit for specific operation
- **Invocation**: Program triggering precompile execution
- **Delegation**: Main machine handing off to precompile
- **Input/output commitment**: Linking precompile to main execution
- **Batched execution**: Processing multiple calls together

## Design Considerations

### Precompile Granularity

| Fine-Grained | Coarse-Grained |
|--------------|----------------|
| Small operations | Complete algorithms |
| More flexibility | Less overhead |
| More invocations | Fewer invocations |
| Composable | Monolithic |

### Interface Complexity

| Simple Interface | Rich Interface |
|-----------------|----------------|
| Fixed formats | Flexible formats |
| Easier verification | Complex validation |
| Limited features | More capabilities |
| Lower overhead | Higher overhead |

## Related Topics

- [Precompile Architecture](02-precompile-architecture.md) - Implementation details
- [Hash Functions](../02-hash-functions/01-sha256-circuit.md) - Hash precompiles
- [Elliptic Curves](../03-elliptic-curves/01-curve-arithmetic.md) - EC precompiles
- [Component Composition](../../04-zkvm-architecture/05-system-integration/01-component-composition.md) - Integration patterns
