# ROM State Machine

## Overview

The ROM (Read-Only Memory) state machine manages the program code storage and instruction fetching within the zkVM. Unlike RAM which supports both reads and writes, ROM is immutable after initialization and contains the program instructions being executed. This immutability provides significant proving advantages: we need only verify that reads return pre-committed values, not track a history of modifications.

The ROM state machine serves as the bridge between the committed program and the executing state machine. Every instruction fetch must prove that the fetched instruction exists in the committed program at the claimed program counter address. This verification ensures that the prover cannot fabricate or modify instructions during execution.

The design of the ROM state machine balances efficient instruction access with compact proof representation, exploiting the read-only nature to simplify constraints compared to read-write memory.

## ROM Structure

### Program Representation

How the program is stored and organized:

```
ROM contents:
  Instructions stored sequentially
  Each slot contains one instruction
  Fixed-width entries (32 bits for RV32)

Addressing:
  PC values map to ROM indices
  Word-aligned access (PC divisible by 4)
  Bounded by program size

Organization:
  Entry point at known address
  Code sections contiguous
  Padding for alignment if needed
```

### ROM Layout

Logical structure of program storage:

```
Layout example:
  Address 0x1000: First instruction
  Address 0x1004: Second instruction
  ...
  Address 0x1000 + 4*N: Last instruction

Metadata:
  Program entry point
  Program size (instruction count)
  Section boundaries

Read-only guarantees:
  Contents fixed at load time
  No modification during execution
  Commitment binds all values
```

## Instruction Fetch Model

### Fetch Operation

How instructions are retrieved:

```
Fetch process:
  1. Current PC specifies address
  2. ROM lookup returns instruction
  3. Instruction decoded and executed
  4. PC updated for next fetch

Fetch constraints:
  Address must be valid (in ROM range)
  Returned instruction matches committed value
  PC properly aligned
```

### PC-to-ROM Mapping

Translating program counter to ROM access:

```
Address translation:
  ROM_index = (PC - base_address) / 4

Bounds checking:
  0 <= ROM_index < program_size

Alignment verification:
  PC mod 4 = 0
  (Or: PC & 3 = 0)
```

## Commitment Scheme

### Program Commitment

Binding the program cryptographically:

```
Commitment approach:
  Hash all ROM contents
  Or: Merkle tree over ROM
  Or: Polynomial commitment

Commitment properties:
  Unique for each program
  Binding: can't change contents
  Efficient verification
```

### Merkle Tree Structure

Tree-based ROM commitment:

```
Tree construction:
  Leaves: Individual instructions
  Internal nodes: Hash of children
  Root: ROM commitment

Verification:
  Provide instruction value
  Provide authentication path
  Verify path to committed root

Advantages:
  Compact commitment (single hash)
  Efficient membership proofs
  Standard cryptographic construction
```

### Polynomial Commitment

Alternative commitment approach:

```
Construction:
  ROM as polynomial evaluations
  ROM[i] = P(omega^i)
  Commit to polynomial P

Verification:
  Opening at claimed index
  Value matches claimed instruction

Advantages:
  Integrates with STARK proving
  Batch verification possible
  Algebraic consistency
```

## Read Verification

### ROM Read Constraints

Proving instruction fetch correctness:

```
For each instruction fetch:
  Inputs:
    PC (program counter)
    claimed_instruction

  Constraints:
    PC in valid range
    PC properly aligned
    claimed_instruction = ROM[PC]

  Using commitment:
    Prove claimed value matches committed ROM
```

### Lookup-Based Verification

Using lookup arguments for ROM:

```
Lookup approach:
  ROM contents as lookup table
  Each fetch is table lookup
  Prove (PC, instruction) in table

Table structure:
  Column 1: Address (PC values)
  Column 2: Instruction values

Lookup argument:
  Every fetch tuple exists in table
  No fabricated instructions
```

## State Machine Design

### ROM State Representation

State tracked by ROM state machine:

```
Per-access state:
  Address (PC)
  Instruction value
  Access counter (for ordering)

Global state:
  Total ROM accesses
  Current instruction pointer

No modification tracking:
  Unlike RAM, no prev_value
  No timestamps needed
  Simpler state model
```

### State Transitions

ROM state machine operation flow:

```
Transition per instruction:
  Current state:
    PC pointing to current instruction

  Operation:
    Fetch instruction at PC
    Verify against commitment

  Next state:
    PC updated (sequential or jump)
    Access counter incremented

Constraint:
  Fetched value matches committed ROM
```

## Interaction with Main State Machine

### Instruction Supply

Providing instructions to execution:

```
Interface:
  Main SM requests: PC value
  ROM SM returns: Instruction word

Coupling:
  Every main SM cycle needs instruction
  ROM access is critical path
  Must be efficient

Verification:
  Main SM receives instruction
  Operates as if correct
  ROM constraints prove correctness
```

### Control Flow Handling

Managing branches and jumps:

```
Sequential execution:
  PC advances by 4
  Next instruction at PC + 4

Branches:
  Conditional PC update
  Target still from ROM

Jumps:
  New PC from instruction or register
  Target address must be valid
  ROM lookup for target instruction
```

## Optimization Techniques

### Batched Verification

Amortizing ROM proof costs:

```
Batch approach:
  Collect many ROM accesses
  Single batched proof

Benefits:
  Reduced verification overhead
  Amortized commitment costs

Implementation:
  Accumulate access claims
  Batch lookup argument
  Single consistency check
```

### Caching Common Patterns

Exploiting code locality:

```
Observation:
  Loops access same instructions
  Sequential code is predictable

Optimization:
  Cache recent ROM lookups
  Reduce redundant proofs

Trade-off:
  More complex state
  But fewer constraints for repeated access
```

### Compressed Instruction Storage

Reducing ROM size:

```
Compression options:
  Dictionary encoding for common patterns
  Delta encoding for similar instructions

Challenges:
  Must maintain verifiability
  Decompression in constraints

Alternative:
  Use compressed ISA (RISC-V C extension)
  Native 16-bit instructions
  Denser code
```

## ROM Initialization

### Program Loading

Setting up ROM contents:

```
Load process:
  1. Parse program binary (ELF)
  2. Extract code sections
  3. Build ROM table
  4. Compute commitment
  5. Publish commitment as public input

Public inputs:
  ROM commitment
  Entry point address
  Program metadata
```

### Multiple Code Sections

Handling non-contiguous code:

```
Section handling:
  Map sections to address ranges
  Track valid PC ranges
  Invalid access = trap

Verification:
  Access within some valid section
  Or: unified address space with gaps
```

## Security Considerations

### Program Integrity

Ensuring correct program execution:

```
Threat model:
  Malicious prover tries to:
    Execute different instructions
    Skip or repeat instructions
    Inject code

Prevention:
  ROM commitment binds program
  Every fetch verified against commitment
  Cannot forge valid proofs for wrong code
```

### Boundary Protection

Preventing invalid accesses:

```
Valid access:
  PC within program bounds
  Aligned to instruction width

Invalid access:
  Should trigger trap/error
  Or: be provably impossible

Constraints:
  Range checks on PC
  Alignment checks
```

## Constraint Summary

### Core ROM Constraints

Essential constraints for ROM correctness:

```
1. Address validity:
   PC >= base_address
   PC < base_address + program_size * 4
   PC mod 4 = 0

2. Instruction correctness:
   fetched_instruction = ROM[(PC - base) / 4]

3. Commitment verification:
   ROM contents match commitment

4. Completeness:
   Every instruction fetch constrained
```

### Lookup Arguments

Using lookups for ROM:

```
ROM table:
  (address, instruction) pairs for all program

Fetch claims:
  (PC, claimed_instruction) for each fetch

Lookup constraint:
  All fetch claims exist in ROM table

Proof:
  Lookup argument proves membership
```

## Integration Points

### Trace Generation

How ROM affects execution traces:

```
Trace columns for ROM:
  PC value
  Fetched instruction
  ROM access indicator

Relationship to main trace:
  Every instruction row needs ROM access
  Values must be consistent

Generation:
  During execution, record all accesses
  Build ROM access trace
```

### Proof Composition

ROM in overall proof structure:

```
Components:
  Main execution proof
  ROM access proof
  Memory access proof

Linkage:
  ROM supplies instructions to main
  Main generates memory ops
  All constrained consistently

Composition:
  Separate proofs for each
  Or: unified constraint system
```

## Performance Analysis

### ROM Size Impact

How program size affects proving:

```
Scaling factors:
  Larger ROM = more commitment data
  More instructions = more fetches

Commitment costs:
  Merkle tree: O(N) build, O(log N) verify each
  Polynomial: O(N log N) commit, O(1) verify each

Optimization:
  Choose commitment matching access pattern
```

### Fetch Overhead

Cost of instruction fetching:

```
Per-fetch costs:
  Lookup argument contribution
  Commitment opening (if used)

Total fetches:
  One per instruction executed
  Dominated by program length

Amortization:
  Batch fetches where possible
  Reduce per-fetch overhead
```

## Key Concepts

- **ROM state machine**: Component managing read-only program storage
- **Program commitment**: Cryptographic binding of program contents
- **Instruction fetch**: Retrieving and verifying program instructions
- **Lookup argument**: Proving instruction membership in ROM
- **Read-only verification**: Simpler proofs without write tracking

## Design Trade-offs

### Commitment Method

| Merkle Tree | Polynomial |
|-------------|------------|
| Standard crypto | STARK-native |
| Log-sized proofs | Constant-sized opens |
| Independent of STARK | Integrated with FRI |

### Verification Strategy

| Per-Fetch Proof | Batched Proof |
|-----------------|---------------|
| Simple structure | Complex batching |
| More overhead | Amortized cost |
| Immediate verification | Delayed verification |

## Related Topics

- [State Machine Abstraction](01-state-machine-abstraction.md) - General state machine concepts
- [Main State Machine](02-main-state-machine.md) - Instruction execution
- [Instruction Encoding](../04-execution-model/01-instruction-encoding.md) - Instruction format
- [Execution Trace](../04-execution-model/02-execution-trace.md) - Trace generation

