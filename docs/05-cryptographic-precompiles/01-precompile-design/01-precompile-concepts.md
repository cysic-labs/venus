# Precompile Concepts

## Overview

Precompiles are specialized circuits within the zkVM that efficiently compute cryptographic operations that would be prohibitively expensive to execute instruction-by-instruction. Rather than proving thousands of RISC-V instructions to compute a SHA-256 hash, the zkVM invokes a dedicated SHA-256 precompile that directly proves the hash computation using optimized constraints.

The precompile concept bridges the gap between general-purpose virtual machine execution and specialized cryptographic hardware. Just as traditional processors include hardware accelerators for common operations, the zkVM includes precompiled circuits for common cryptographic primitives. This dramatically reduces proving costs for cryptography-heavy applications.

This document introduces precompile fundamentals, their role in zkVM architecture, and the principles that guide their design.

## Why Precompiles

### The Efficiency Problem

Cryptographic operations in base VM:

```
Consider SHA-256:
  ~10,000 RISC-V instructions per block
  Each instruction: ~100 constraints
  Total: ~1,000,000 constraints per hash

Compare to precompile:
  ~5,000 specialized constraints per hash
  200x improvement in constraint count

Impact:
  Faster proof generation
  Smaller proofs
  Lower verification cost
```

### Common Cryptographic Patterns

Operations that benefit from precompiles:

```
Hash functions:
  SHA-256, Keccak-256, Poseidon
  Block cipher structures
  Compression functions

Elliptic curve operations:
  Point addition and doubling
  Scalar multiplication
  Pairing computations

Big integer arithmetic:
  256-bit, 384-bit operations
  Modular arithmetic
  Field operations
```

### Design Philosophy

Principles guiding precompile design:

```
Efficiency:
  Minimize constraint count
  Optimize for common operations
  Exploit algebraic structure

Modularity:
  Self-contained circuits
  Well-defined interfaces
  Composable with other components

Security:
  Correct implementation
  No side-channel leakage in constraints
  Sound constraint system
```

## Precompile Interface

### Invocation Model

How programs call precompiles:

```
Interface:
  Designated memory regions for input
  Special instruction or syscall to invoke
  Output written to designated region

From program perspective:
  1. Write input data to input buffer
  2. Trigger precompile execution
  3. Read result from output buffer
```

### Input Specification

Providing data to precompiles:

```
Input format:
  Fixed or variable size depending on operation
  Specific layout expected
  Documented per precompile

Example (SHA-256):
  Input: message bytes
  Length: variable (with padding)
  Format: standard message format
```

### Output Specification

Receiving results:

```
Output format:
  Operation-specific result
  Fixed size for most operations
  Status indicator if applicable

Example (SHA-256):
  Output: 32-byte digest
  Format: big-endian bytes
```

## Precompile Categories

### Hash Precompiles

Cryptographic hash functions:

```
Common hashes:
  SHA-256: Widely used, NIST standard
  Keccak-256: Ethereum standard
  Poseidon: zk-friendly hash

Characteristics:
  Block-oriented processing
  Compression function iterations
  Deterministic output
```

### Arithmetic Precompiles

Extended arithmetic operations:

```
Big integers:
  256-bit multiplication/division
  384-bit operations for larger fields
  Modular reduction

Field operations:
  Field-specific arithmetic
  Montgomery multiplication
  Modular inversion
```

### Elliptic Curve Precompiles

Curve operations:

```
Point operations:
  Addition of curve points
  Scalar multiplication
  Validity checking

Pairing operations:
  Bilinear pairing computation
  Miller loop and final exponentiation
  Multi-pairing optimization
```

## Precompile Lifecycle

### Registration

Making precompiles available:

```
At setup:
  Define precompile circuits
  Assign identifiers
  Publish interfaces

Runtime:
  Precompiles loaded with VM
  Available for invocation
  Part of proving circuit
```

### Invocation

Calling a precompile:

```
Execution flow:
  1. Main SM encounters precompile call
  2. Input data prepared
  3. Precompile circuit activated
  4. Computation performed
  5. Result returned to main SM
```

### Verification

Proving precompile execution:

```
Constraint integration:
  Precompile constraints part of overall proof
  Inputs and outputs constrained
  Correctness proven alongside main execution
```

## Cost Model

### Constraint Costs

Measuring precompile efficiency:

```
Metrics:
  Constraint count per operation
  Trace rows consumed
  Lookup table usage

Comparison:
  Precompile cost vs instruction cost
  Breakeven analysis
  Optimization targets
```

### Invocation Overhead

Fixed costs of precompile calls:

```
Overhead:
  Interface constraints
  Data routing
  State machine transitions

Amortization:
  Single invocation: overhead matters
  Batched invocations: overhead amortized
```

### Gas-Like Pricing

Resource accounting:

```
Pricing model:
  Assign cost units to precompiles
  Proportional to proving cost
  Predictable for users

Usage:
  Programs budget precompile calls
  Optimization trade-offs visible
```

## Security Considerations

### Correctness Requirements

Precompiles must compute correctly:

```
Soundness:
  Constraints accurately encode operation
  No invalid inputs accepted
  No incorrect outputs producible

Completeness:
  All valid inputs handled
  Correct outputs always producible
  No false rejections
```

### Malicious Input Handling

Defending against adversarial inputs:

```
Edge cases:
  Empty inputs
  Maximum-length inputs
  Malformed data

Response:
  Defined behavior for all inputs
  Error reporting where appropriate
  No constraint violations
```

### Side-Channel Resistance

Constraint-level security:

```
Consideration:
  Constraint structure reveals patterns
  Timing through constraint count
  Data-dependent operations

Mitigation:
  Uniform constraint count where possible
  Avoid branching on secret data
  Constant-time constraint patterns
```

## Precompile Architecture

### Circuit Structure

Internal organization:

```
Components:
  Input parsing and validation
  Core computation logic
  Output formatting
  Constraint generation

Flow:
  Input → Validation → Compute → Format → Output
```

### State Machine Integration

Connecting to main execution:

```
Integration:
  Bus interface for data transfer
  Selector for precompile activation
  Result routing back to registers/memory

Constraints:
  Input matches requested
  Output correctly used
  Invocation properly recorded
```

### Modular Design

Reusable components:

```
Shared elements:
  Field arithmetic primitives
  Bit manipulation
  Range checking

Benefits:
  Consistent implementation
  Amortized verification
  Easier auditing
```

## Key Concepts

- **Precompile**: Specialized circuit for efficient cryptographic operations
- **Invocation interface**: How programs call precompiles
- **Constraint efficiency**: Fewer constraints than instruction-by-instruction
- **Security requirements**: Correctness and side-channel resistance
- **Cost model**: Resource accounting for precompile usage

## Design Trade-offs

### Generality vs Efficiency

| General Purpose | Specialized |
|-----------------|-------------|
| Flexible | Fast |
| Higher constraints | Lower constraints |
| Easier updates | Harder updates |

### Precompile Granularity

| Coarse Operations | Fine Operations |
|-------------------|-----------------|
| Full hash function | Individual rounds |
| Less flexibility | More composability |
| Lower overhead | Higher overhead |

## Related Topics

- [Constraint Representation](02-constraint-representation.md) - How precompiles encode operations
- [Chunking Strategies](03-chunking-strategies.md) - Processing large inputs
- [Keccak Precompile](../02-hash-precompiles/01-keccak-f-precompile.md) - Hash precompile example
- [Bus Architecture](../../04-zkvm-architecture/05-data-bus/01-bus-architecture.md) - Precompile communication

