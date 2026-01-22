# State Machine Abstraction

## Overview

The state machine abstraction provides a modular framework for organizing zkVM constraints. Rather than expressing the entire computation as a monolithic constraint system, the zkVM is decomposed into multiple specialized state machines, each responsible for a specific aspect of execution. This modularity enables independent development, testing, and optimization of different computational domains.

Each state machine defines its own columns (state variables), transition constraints (how state evolves), and interfaces (how it connects to other machines). The abstraction enforces clean boundaries between components while providing mechanisms for inter-machine communication through buses, lookups, and permutation arguments.

This document covers the state machine concept, design patterns, interface conventions, and the composition of machines into a complete proving system.

## Conceptual Foundation

### What is a State Machine

A state machine in zkVM context:

```
Definition:
  A state machine M consists of:
    - Columns: Set of trace columns {c_0, c_1, ..., c_w}
    - Constraints: Set of polynomial equations {C_0, C_1, ..., C_k}
    - Interfaces: Connection points to other machines

Properties:
  - Columns store state at each cycle
  - Constraints ensure valid transitions
  - Interfaces enable composition
```

### State Machine vs. Traditional FSM

Differences from classical finite state machines:

```
Traditional FSM:
  - Finite set of named states
  - Explicit transition function
  - Deterministic or non-deterministic

zkVM State Machine:
  - State is tuple of field elements
  - Transitions via polynomial constraints
  - Witness provides actual transitions
  - Constraints verify transitions were valid

The "state machine" terminology emphasizes:
  - Sequential, step-by-step computation
  - Well-defined state at each step
  - Transition rules between steps
```

### Modularity Benefits

Why decompose into state machines:

```
Development:
  - Teams work independently on different machines
  - Clear interfaces reduce coordination
  - Isolated testing per machine

Performance:
  - Specialized optimizations per domain
  - Different blowup/padding per machine
  - Parallel proving across machines

Maintenance:
  - Bugs isolated to specific machine
  - Upgrades don't affect other machines
  - Easier to understand and audit
```

## State Machine Components

### Columns

State variables of the machine:

```
Column categories:
  State columns: Core machine state
  Input columns: Values received from outside
  Output columns: Values sent to outside
  Auxiliary columns: Helper values for constraints

Example (Arithmetic Machine):
  State: accumulator, carry
  Input: operand_a, operand_b, operation
  Output: result, overflow
  Auxiliary: intermediate_products, bit_decomposition
```

### Constraints

Rules governing state transitions:

```
Constraint types:
  Transition: Relate row i to row i+1
  Boundary: Fix values at specific rows
  Global: Span multiple rows (e.g., accumulators)

Constraint structure:
  polynomial(columns[i], columns[i+1], ...) = 0

Example constraints:
  // Transition: accumulator update
  accumulator' - accumulator - operand = 0

  // Boundary: initial state
  (row == 0) * (accumulator - initial_value) = 0
```

### Interfaces

Connection points:

```
Interface types:
  Bus interface: Send/receive messages
  Lookup interface: Query table values
  Permutation interface: Prove multiset equality

Interface specification:
  Name: Identifier for the interface
  Direction: Input, output, or bidirectional
  Columns: Which columns participate
  Protocol: How connection is established
```

## State Machine Lifecycle

### Initialization

Machine startup:

```
At trace start (row 0):
  - State columns set to initial values
  - Accumulators initialized
  - Ready to process inputs

Constraints:
  boundary_constraint: state[0] = initial_state

The initial state may be:
  - Fixed (hardcoded in constraints)
  - Public input (provided by verifier)
  - Private input (part of witness)
```

### Steady State

Normal operation:

```
For each active row:
  1. Receive inputs from interfaces
  2. Compute new state based on constraints
  3. Send outputs through interfaces
  4. Advance to next row

Constraints ensure:
  - Inputs match interface expectations
  - State transitions are valid
  - Outputs are correctly computed
```

### Termination

Machine completion:

```
At final active row:
  - Final state matches expected output
  - All pending operations complete
  - Interfaces properly closed

After termination:
  - Padding rows if needed
  - State may repeat or follow padding pattern
  - Constraints relaxed via selectors
```

## Design Patterns

### Selector Pattern

Conditional constraint activation:

```
Problem:
  Different operations have different constraints
  Not all constraints apply to all rows

Solution:
  Use selector columns (0 or 1)
  Multiply constraints by selectors

Example:
  sel_add * (result - (a + b)) = 0
  sel_mul * (result - (a * b)) = 0
  sel_add + sel_mul = 1  // Exactly one active
```

### Accumulator Pattern

Building up values across rows:

```
Purpose:
  Aggregate information over many rows
  Verify global properties

Structure:
  acc[0] = initial_value
  acc[i+1] = f(acc[i], row_data[i])
  acc[N-1] = expected_final_value

Applications:
  - Lookup argument sums
  - Permutation products
  - Hash computations
```

### Lookup Pattern

Verifying values against a table:

```
Purpose:
  Check that column values appear in table
  More efficient than explicit constraints

Structure:
  Table T with entries {t_0, t_1, ..., t_m}
  Values V = {v_0, v_1, ...}
  Prove: Every v_i is in T

Implementation:
  Logarithmic derivative argument
  Running sum columns
  Final equality check
```

### Bus Pattern

Inter-machine communication:

```
Purpose:
  Send messages between machines
  Balance sends and receives

Structure:
  Sender machine: Outputs (type, data)
  Receiver machine: Inputs (type, data)
  Bus constraint: Sum of sends = Sum of receives

Implementation:
  Random linear combination
  Running sum on both sides
  Final equality check
```

## Machine Categories

### Main State Machine

Central orchestrator:

```
Responsibilities:
  - Instruction fetch and decode
  - Control flow management
  - Coordinate other machines
  - Maintain program counter

Columns:
  pc, instruction, opcode, selectors
  reg_file or reg_access columns
  Bus/interface columns

Constraints:
  Instruction decode correct
  Control flow valid
  Proper delegation to other machines
```

### Arithmetic Machines

Numerical operations:

```
Types:
  - Basic: add, subtract
  - Multiplication: wide multiply
  - Division: quotient, remainder
  - Modular: modular reduction

Columns:
  operands, result, intermediate values
  Range check columns

Constraints:
  Arithmetic correctness
  Range bounds
  Overflow handling
```

### Memory Machine

Memory operations:

```
Responsibilities:
  - Track memory reads/writes
  - Ensure consistency
  - Handle different sizes

Columns:
  address, value, timestamp, operation_type
  Sorted copies for permutation

Constraints:
  Permutation: sorted = original
  Consistency: reads return last write
```

### Binary Machine

Bitwise operations:

```
Responsibilities:
  - AND, OR, XOR, NOT
  - Shifts and rotates
  - Bit extraction

Columns:
  operands as bits, result as bits
  Reconstructed values

Constraints:
  Bit decomposition correct
  Bitwise operation correct
  Reconstruction matches
```

### Cryptographic Machines

Specialized crypto operations:

```
Types:
  - Hash machine (SHA, Keccak, Poseidon)
  - Signature machine (ECDSA, EdDSA)
  - Pairing machine (BN254, BLS)

Columns:
  Algorithm-specific state
  Input/output buffers

Constraints:
  Algorithm rounds correct
  Final output matches expected
```

## Machine Composition

### Vertical Composition

Machines share columns:

```
Machine A uses columns 0-99
Machine B uses columns 100-199
Same trace rows for both

Connection:
  Shared columns or explicit copy
  Same row = same cycle

Use case:
  Tightly coupled machines
  Same-cycle communication
```

### Horizontal Composition

Machines in separate traces:

```
Machine A has its own trace
Machine B has its own trace
Different row counts possible

Connection:
  Permutation arguments
  Lookup arguments
  Asynchronous communication

Use case:
  Loosely coupled machines
  Different operation frequencies
```

### Hierarchical Composition

Machines contain sub-machines:

```
Parent machine orchestrates
Child machines handle details

Example:
  Main machine contains:
    - ALU sub-machine
    - Memory sub-machine
    - Branch sub-machine

Organization:
  Parent's constraints invoke children
  Children may have own column regions
```

## Key Concepts

- **State machine**: Modular unit with columns, constraints, interfaces
- **Columns**: State variables stored per row
- **Constraints**: Polynomial equations for valid transitions
- **Interface**: Connection point to other machines
- **Composition**: Combining machines into complete system

## Design Considerations

### Granularity

| Coarse (Few Machines) | Fine (Many Machines) |
|-----------------------|---------------------|
| Simpler composition | Complex composition |
| Larger per-machine | Smaller per-machine |
| Fewer interfaces | Many interfaces |
| Harder to optimize | Easier to optimize |

### Column Allocation

| Static Allocation | Dynamic Allocation |
|-------------------|-------------------|
| Predictable layout | Flexible layout |
| Simpler constraints | Complex management |
| May waste columns | Better utilization |
| Easier to debug | Harder to debug |

## Related Topics

- [Main State Machine](02-main-state-machine.md) - Central execution machine
- [Arithmetic Operations](03-arithmetic-operations.md) - Arithmetic machine design
- [Binary Operations](04-binary-operations.md) - Bitwise machine design
- [Secondary State Machines](../../03-proof-management/02-component-system/03-secondary-state-machines.md) - Auxiliary machines
