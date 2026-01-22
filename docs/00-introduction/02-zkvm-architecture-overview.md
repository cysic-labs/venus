# zkVM Architecture Overview

## Overview

A zkVM's architecture consists of multiple interconnected subsystems that work together to execute programs and generate proofs. Understanding these components and their interactions is essential for grasping how zkVMs achieve their remarkable properties. This document presents a comprehensive view of zkVM architecture, examining each major subsystem and how they coordinate to transform program execution into verifiable proofs.

The architecture of a zkVM can be understood at multiple levels: the high-level pipeline from source code to proof, the intermediate representation of computation as constraints, and the low-level mechanics of proof generation. Each level builds upon the previous, creating a stack that transforms arbitrary computation into cryptographic certainty.

## High-Level Architecture

### The zkVM Pipeline

A complete zkVM system encompasses several stages:

```
Source Code -> Compilation -> Execution -> Witness Generation -> Proof Generation -> Verification
```

**Compilation**: Programs written in high-level languages are compiled to the zkVM's instruction set. For a RISC-V based zkVM, standard compilers like GCC or LLVM target RISC-V, producing executable binaries.

**Execution**: The zkVM executes the program, tracking every state transition. This execution may occur in multiple passes - an initial pass for determining program behavior and subsequent passes for proof-relevant data collection.

**Witness Generation**: The execution trace is transformed into a structured witness - the data needed by the proof system. This involves organizing execution data into the format expected by the constraint system.

**Proof Generation**: The prover applies the cryptographic proof system to the witness, producing a succinct proof that the execution was valid.

**Verification**: Any party can verify the proof using only the public inputs, outputs, and verification key.

### Core Components

A zkVM implementation typically includes these major components:

```
+------------------+     +------------------+     +------------------+
|    Compiler      |     |    Emulator      |     |  State Machines  |
|  (Toolchain)     | --> |  (Execution)     | --> |  (Constraints)   |
+------------------+     +------------------+     +------------------+
                                                          |
                                                          v
+------------------+     +------------------+     +------------------+
|    Verifier      | <-- |  Proof System    | <-- | Witness Builder  |
|                  |     |  (STARK/SNARK)   |     |                  |
+------------------+     +------------------+     +------------------+
```

## The Emulator

### Purpose

The emulator is the component that actually runs programs. It interprets instructions according to the ISA specification, maintaining accurate machine state throughout execution. Unlike a standard emulator, a zkVM emulator must also capture every detail needed for proof generation.

### State Management

The emulator maintains several categories of state:

**Architectural State**:
- Program counter (PC): Points to the current instruction
- General-purpose registers: Storage for operands and results
- Control/status registers: Machine configuration and flags

**Memory State**:
- RAM: Read-write storage for program data
- ROM: Read-only storage for program code
- Stack: Call stack management

**Execution Metadata**:
- Step counter: Which execution step is current
- Cycle information: Timing and sequencing data

### Two-Phase Execution

Many zkVM implementations use a two-phase execution model:

**Phase 1 - Native Execution**:
- Run the program at near-native speed
- Determine total execution length
- Identify memory access patterns
- Detect which precompiled functions are called

**Phase 2 - Trace Generation**:
- Re-execute with full state recording
- Generate minimal traces for each subsystem
- Collect data required for witness construction

This separation allows the first phase to run efficiently while the second phase focuses on collecting exactly the data needed for proving.

### Instruction Handling

Each instruction type requires specific handling:

**Arithmetic Instructions** (ADD, SUB, MUL, DIV):
- Read operand values from registers
- Perform the computation
- Write result to destination register
- Record all values for the arithmetic constraint system

**Memory Instructions** (LOAD, STORE):
- Compute effective address
- Perform memory operation
- Record address, value, and timestamp
- Feed data to memory consistency checks

**Control Flow** (JUMP, BRANCH):
- Evaluate branch conditions
- Update program counter
- Record control flow decisions

**System Calls**:
- Handle I/O operations
- Manage program inputs and outputs
- Interface with the host environment

## State Machines

### The State Machine Paradigm

zkVMs organize constraints into state machines - modular components that each handle a specific aspect of execution. This modularity provides several benefits:

- **Separation of concerns**: Each state machine has a focused responsibility
- **Optimization opportunity**: Different techniques can be applied to different machines
- **Parallel development**: Teams can work on different state machines independently
- **Composability**: State machines can be combined flexibly

### Main State Machine

The main state machine orchestrates overall execution. It:

- Decodes instructions from the program ROM
- Coordinates with other state machines for specific operations
- Manages the program counter and control flow
- Enforces instruction semantics

The main state machine's constraints ensure that:
- Each step executes a valid instruction
- Register reads and writes are consistent
- The program counter advances correctly
- Control flow follows program logic

### Arithmetic State Machine

Handles arithmetic operations that are expensive to constrain directly:

**Operations**:
- Integer multiplication and division
- Modular arithmetic
- Shift operations

**Design Rationale**:
Some operations, particularly division, are difficult to express as low-degree polynomial constraints. The arithmetic state machine uses auxiliary values (quotient, remainder) that can be efficiently verified.

### Binary State Machine

Handles bitwise operations:

**Operations**:
- AND, OR, XOR, NOT
- Bit shifts and rotations
- Byte manipulation

**Constraint Approach**:
Bitwise operations require decomposing values into individual bits, performing the operation, and recomposing. The binary state machine manages this decomposition efficiently.

### Memory State Machine

Ensures memory consistency across all operations:

**Properties Enforced**:
- Every read returns the most recently written value
- Address alignment constraints are satisfied
- Memory regions have appropriate permissions

**Technique**:
Memory operations are sorted by address and timestamp. Constraints verify that consecutive operations to the same address maintain consistency.

### ROM State Machine

Manages read-only program code:

**Responsibilities**:
- Store the program binary
- Return correct instructions for each address
- Verify instruction fetches are valid

**Properties**:
- Contents are fixed at setup time
- All reads return the same value for a given address

## Constraint System Design

### Polynomial Constraints

All state machine rules are expressed as polynomial constraints. If `P(x)` is a polynomial representing a constraint, then for all valid executions:

```
P(trace values) = 0
```

Constraints come in several types:

**Boundary Constraints**: Fix values at specific points
- Initial register values
- Final output values
- Program entry point

**Transition Constraints**: Relate consecutive steps
- Next PC = Current PC + 4 (for sequential execution)
- Destination register = Source1 + Source2 (for ADD)

**Consistency Constraints**: Ensure global properties
- Memory consistency across all operations
- ROM consistency for instruction fetches

### Algebraic Intermediate Representation (AIR)

The constraint system is typically expressed as an AIR - a set of polynomial identity checks that must hold across the entire execution trace. The AIR specifies:

- **Trace columns**: Named values at each execution step
- **Constraints**: Polynomial equations involving trace columns
- **Periodicity**: Which constraints apply at which steps

### Degree and Complexity

Constraint polynomial degree directly impacts proving cost. Lower-degree constraints are faster to prove but may require more columns or auxiliary values. zkVM designers balance:

- Constraint degree
- Number of trace columns
- Overall proof size
- Prover time

## The Proof System

### Role of the Proof System

The proof system is the cryptographic engine that transforms the constraint system and witness into a proof. For zkVMs, STARK (Scalable Transparent ARgument of Knowledge) is a common choice due to its:

- **Transparency**: No trusted setup required
- **Scalability**: Proving time nearly linear in computation size
- **Post-quantum security**: Based on hash functions, not elliptic curves

### Proof Generation Steps

1. **Trace Commitment**: The execution trace is committed using a Merkle tree or similar structure. This binds the prover to specific trace values.

2. **Constraint Evaluation**: The prover computes constraint polynomials evaluated over the trace domain.

3. **FRI Protocol**: The Fast Reed-Solomon Interactive Oracle Proof (FRI) verifies that committed polynomials are low-degree, establishing that constraints are satisfied.

4. **Query Phase**: The verifier makes random queries, and the prover opens the commitments at those points.

5. **Aggregation**: Multiple constraint checks are combined into a single proof.

### Verification

Verification is significantly faster than proving:

1. Check that commitments are well-formed
2. Verify FRI protocol responses
3. Check queried values against opened commitments
4. Validate that constraint evaluations are consistent

## Inter-Component Communication

### Data Bus Architecture

State machines must exchange data - for example, the main state machine sends multiplication requests to the arithmetic state machine. A data bus provides this communication:

```
Main SM <---> Arithmetic SM
    |
    +------> Memory SM
    |
    +------> Binary SM
```

### Lookup Arguments

Lookups allow one state machine to verify that values appear in another. For instance, the main state machine can look up instruction encodings in the ROM state machine.

### Permutation Arguments

When data must be reorganized (e.g., sorting memory operations by address), permutation arguments prove that two lists contain the same elements in different orders.

### Connection Arguments

More general relationships between columns in different (or the same) state machine are established through connection arguments.

## Execution Segmentation

### Why Segment?

Long-running programs may have traces too large to prove in a single pass. Segmentation divides execution into manageable chunks:

- Each segment proves a portion of execution
- Segments can be proven in parallel
- Segments are joined to form a complete proof

### Continuation State

When segmenting, the ending state of segment N must match the starting state of segment N+1. This includes:

- Register values
- Memory contents
- Program counter
- Any other architectural state

### Aggregation

Individual segment proofs are combined through recursive proving or proof aggregation, producing a single proof that attests to the entire execution.

## Key Concepts

- **Pipeline**: Source code flows through compilation, execution, witness generation, proving, and verification
- **State machines**: Modular constraint systems that each handle specific aspects of computation
- **Emulator**: Executes programs and generates execution traces
- **Constraint system**: Polynomial equations that are satisfied if and only if execution is valid
- **Data bus**: Communication mechanism between state machines
- **Segmentation**: Dividing large computations into provable chunks

## Design Considerations

### Modularity vs. Integration

More modular designs (many small state machines) offer flexibility but incur communication overhead. More integrated designs (fewer, larger state machines) reduce overhead but are harder to optimize individually.

### Trace Width vs. Length

Wider traces (more columns) can reduce trace length by packing more information per row. However, wider traces increase memory requirements. Designers must balance width and length for optimal performance.

### Prover Resources

Proof generation is resource-intensive. Architecture choices affect:
- Peak memory usage
- Parallelization potential
- GPU acceleration opportunity
- Network distribution feasibility

### Verification Targets

Proofs may need verification in different contexts:
- On-chain verification (minimize gas cost)
- Client-side verification (minimize proof size)
- Recursive composition (optimize for further proving)

## Related Topics

- [What is a zkVM?](01-what-is-zkvm.md) - Foundational concepts
- [Building Blocks](03-building-blocks.md) - Underlying cryptographic primitives
- [State Machine Abstraction](../04-zkvm-architecture/02-state-machine-design/01-state-machine-abstraction.md) - Detailed state machine design
- [Constraint System](../02-stark-proving-system/02-constraint-system/01-algebraic-intermediate-representation.md) - AIR and constraint formulation
