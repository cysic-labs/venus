# Component Composition

## Overview

Component composition is the process of combining multiple specialized state machines into a unified proving system. A zkVM consists of many components: the main execution machine, memory machine, arithmetic machine, binary machine, and others. Each handles a specific aspect of computation, but they must work together seamlessly to prove complete program execution. Composition connects these components through well-defined interfaces while maintaining the soundness of the overall proof.

The challenge of composition lies in ensuring that data passed between components is consistent. When the main machine sends an arithmetic operation to the arithmetic machine, both must agree on the operands and result. Lookup and permutation arguments provide the cryptographic glue that binds components together, ensuring that cross-component communication is correct without requiring a single monolithic constraint system.

This document covers composition patterns, interface design, consistency enforcement, and optimization strategies for efficient multi-component systems.

## Composition Architecture

### Component Types

Specialized machines in a zkVM:

```
Core components:
  Main Machine: Instruction fetch, decode, dispatch
  Memory Machine: Load/store consistency
  Register Machine: Register file state (if separate)

Arithmetic components:
  ALU Machine: Basic arithmetic (add, sub, compare)
  Multiplier Machine: Multiplication operations
  Divider Machine: Division, modulo operations

Binary components:
  Binary Machine: AND, OR, XOR, shifts
  Range Check Machine: Value range verification

Auxiliary components:
  Hash Machine: Cryptographic hashing
  Signature Machine: Signature verification
  Precompile Machines: Specialized accelerators
```

### Component Interfaces

How components communicate:

```
Interface definition:
  Input columns: Data received from other components
  Output columns: Data sent to other components
  Internal columns: Private to component

Interface example (arithmetic):
  Inputs: op_type, operand_a, operand_b
  Outputs: result, flags (overflow, zero, etc.)

Connection via lookup:
  Main machine: (op, a, b, result) in Arithmetic table
  Arithmetic machine: Contains (op, a, b, result) rows
```

### Composition Graph

Component connectivity:

```
Composition structure:
  Main Machine (hub)
    ├── Memory Machine (bidirectional)
    ├── Arithmetic Machine (request-response)
    ├── Binary Machine (request-response)
    ├── Range Check Machine (one-way lookup)
    └── Precompiles (request-response)

Data flow:
  Main -> Arithmetic: Operation request
  Arithmetic -> Main: Result response
  Main -> Memory: Read/write request
  Memory -> Main: Read response
```

## Connection Mechanisms

### Lookup Connections

Table-based component linking:

```
Producer component:
  Produces rows in a table T
  Commits to table polynomial

Consumer component:
  Queries table T for specific values
  Multiplicity column tracks query count

Lookup argument:
  Proves every query appears in table
  Proves multiplicities match

Example (range check):
  Range table: {0, 1, 2, ..., 2^16 - 1}
  Main machine: Lookups for each value to range check
  Multiplicity: How many times each value checked
```

### Permutation Connections

Multiset equality between components:

```
Component A sends:
  Set of tuples {(x1, y1), (x2, y2), ...}

Component B receives:
  Same set of tuples (possibly reordered)

Permutation argument:
  prod(z - tuple_a_i) = prod(z - tuple_b_i)

Example (memory):
  Main machine: Memory operations in execution order
  Memory machine: Same operations in address-sorted order
  Permutation proves sets are equal
```

### Bus Architecture

Shared communication channel:

```
Bus concept:
  Multiple senders, multiple receivers
  All messages on shared bus

Bus columns:
  sender_id: Which component sent
  receiver_id: Which component receives
  message_type: Type of message
  payload: Message data

Bus constraint:
  Sum of sent messages = Sum of received messages
  (via permutation argument over bus)
```

## Interface Design

### Request-Response Pattern

Operation delegation:

```
Main machine sends request:
  Columns: req_valid, req_op, req_a, req_b

Arithmetic machine processes:
  Columns: op, a, b, result
  Computes result based on op

Main machine receives response:
  Columns: resp_result

Linking:
  (req_op, req_a, req_b, resp_result) in Arithmetic table
```

### Typed Interfaces

Strong typing for safety:

```
Interface types:
  ArithOp = {ADD, SUB, MUL, DIV}
  MemOp = {READ, WRITE}
  BinOp = {AND, OR, XOR, SLL, SRL, SRA}

Type constraints:
  is_arith_op * (op_type in ArithOp) = is_arith_op
  is_mem_op * (op_type in MemOp) = is_mem_op

Prevents sending wrong operation types.
```

### Versioned Interfaces

Extensibility:

```
Interface versioning:
  Version field in messages
  Different versions may have different layouts

Upgrade path:
  New components understand old interfaces
  Graceful extension

Constraint:
  (version, format) in valid_formats
```

## Consistency Enforcement

### Cross-Component Consistency

Ensuring agreement:

```
Main machine claims:
  ADD(5, 3) = 8

Arithmetic machine confirms:
  Row exists: (ADD, 5, 3, 8)

Consistency:
  Lookup proves main's claim in arith's table
  If claim false, lookup fails

No way to forge computation:
  Prover can't claim wrong result
  Tables must match across components
```

### Timestamp Consistency

Ordering across components:

```
Global timestamp:
  Each component row has timestamp
  Timestamps increase monotonically

Cross-component ordering:
  Operation at time T in main
  Same operation at time T in sub-component

Constraint:
  main_timestamp = sub_timestamp for linked operations
```

### Multiplicity Consistency

Counting cross-references:

```
Each lookup has multiplicity:
  How many times value is looked up

Multiplicity balance:
  Sum of lookup multiplicities = Sum of table multiplicities
  No "extra" lookups or table entries

Constraint:
  Σ lookup_mult[i] = Σ table_mult[j]
```

## Composition Patterns

### Hub-and-Spoke

Central coordinator:

```
Main machine as hub:
  All other components connect to main
  No direct component-to-component links

Benefits:
  Simple topology
  Clear data flow
  Easy to reason about

Main ──┬── Memory
       ├── Arithmetic
       ├── Binary
       └── RangeCheck
```

### Hierarchical

Nested composition:

```
Component groups:
  Execution group (Main + Registers)
  Memory group (Memory + Cache)
  Crypto group (Hash + Signature)

Hierarchy:
  Top level: Links between groups
  Group level: Links within group

Main─┬──MemoryGroup─┬──Memory
     │              └──Cache
     └──CryptoGroup─┬──Hash
                    └──Signature
```

### Pipeline

Sequential processing:

```
Components in pipeline:
  Fetch → Decode → Execute → Writeback

Each stage:
  Takes input from previous
  Produces output for next

Composition:
  Adjacent stages linked by permutation
  Full pipeline verified end-to-end
```

## Optimization Strategies

### Batched Communication

Reduce connection overhead:

```
Instead of per-operation linking:
  Batch multiple operations together

Batch structure:
  Group related operations
  Single lookup for batch

Example:
  Multiple memory reads to same page
  Batch into single page access
```

### Lazy Evaluation

Defer sub-component work:

```
Main machine:
  Record operation to be processed
  Don't immediately delegate

Sub-component:
  Process all operations at end
  Batch processing more efficient

Constraint:
  All recorded operations eventually processed
  Permutation between recorded and processed
```

### Component Inlining

Merge small components:

```
If sub-component is simple:
  Inline its constraints into main
  Avoid composition overhead

Trade-off:
  Fewer components, simpler linking
  Larger main machine, more constraints

Inline when:
  Sub-component is small
  Frequently used
  Simple interface
```

## Key Concepts

- **Composition**: Combining multiple state machines
- **Interface**: Data exchange specification between components
- **Lookup connection**: Table-based cross-component verification
- **Permutation connection**: Multiset equality enforcement
- **Bus**: Shared communication channel

## Design Considerations

### Composition Granularity

| Many Components | Few Components |
|-----------------|----------------|
| Specialized | General-purpose |
| More connections | Fewer connections |
| Smaller tables | Larger tables |
| Higher overhead | Lower overhead |

### Interface Complexity

| Simple Interface | Rich Interface |
|-----------------|----------------|
| Few fields | Many fields |
| Limited operations | Comprehensive |
| Lower overhead | Higher overhead |
| Less flexible | More flexible |

## Related Topics

- [Lookup Arguments](../../02-constraint-system/03-proof-generation/01-witness-generation.md) - Lookup mechanics
- [Cross-Machine Consistency](02-cross-machine-consistency.md) - Consistency details
- [Trace Layout](03-trace-layout.md) - Column organization
- [Main State Machine](../02-state-machine-design/02-main-state-machine.md) - Central component
