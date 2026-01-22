# Secondary State Machines

## Overview

Secondary state machines extend the capabilities of the main zkVM execution state machine by handling specialized operations that would be inefficient or impractical to implement in the main circuit. These auxiliary machines handle operations like arithmetic with specialized constraints, memory operations with consistency proofs, and cryptographic primitives with optimized circuits.

The separation between main and secondary state machines follows the principle of modularity - each machine focuses on a specific domain of operations with tailored constraint structures. The main state machine coordinates execution flow and delegates operations to secondary machines, which process requests and return results. This architecture enables specialized optimizations and allows independent development of different computational domains.

This document covers secondary state machine design, communication patterns, and common secondary machine types.

## Architecture

### Main vs. Secondary Machines

Role distinction:

```
Main State Machine:
  - Instruction fetch and decode
  - Program counter management
  - Register file operations
  - Control flow decisions
  - Delegation to secondary machines

Secondary State Machines:
  - Specialized computation
  - Domain-specific constraints
  - Optimized for particular operations
  - Return results to main machine
```

### Communication Model

How machines interact:

```
Request/Response Pattern:
  1. Main machine prepares operation request
  2. Request written to shared columns/bus
  3. Secondary machine processes request
  4. Result written back to shared columns/bus
  5. Main machine reads result

Timing:
  - Synchronous: Same cycle request/response
  - Asynchronous: Response on later cycle
  - Batched: Multiple requests, batch response
```

### Bus Architecture

Communication infrastructure:

```
Operation Bus:
  - Request columns: op_type, operand1, operand2, ...
  - Response columns: result, status, ...
  - Address columns: which machine, request ID

Multiple buses for different operation types:
  - Arithmetic bus
  - Memory bus
  - Crypto bus
```

## Common Secondary Machines

### Arithmetic Machine

Handles complex arithmetic:

```
Operations:
  - Multiplication (especially wide multiply)
  - Division and modular reduction
  - Extended precision arithmetic
  - Modular exponentiation (if supported)

Columns:
  - Operands: a, b
  - Operation selector: mul, div, mod, ...
  - Result: result_lo, result_hi
  - Auxiliary: quotient, remainder, carries

Constraints:
  - a * b = result (for multiplication)
  - a = b * quotient + remainder (for division)
  - Range checks on all values
```

### Memory Machine

Handles memory consistency:

```
Operations:
  - Memory read
  - Memory write
  - Batch operations

Columns:
  - Address
  - Value (read or written)
  - Timestamp (for ordering)
  - Operation type (read/write)
  - Sorted copies for permutation

Constraints:
  - Permutation: original equals sorted
  - Sorted by (address, timestamp)
  - Read consistency: reads return last write
  - Initial values: first access to address
```

### Binary Machine

Handles bitwise operations:

```
Operations:
  - AND, OR, XOR, NOT
  - Shift left, shift right
  - Rotate
  - Bit extraction

Columns:
  - Operands: a, b
  - Bit decompositions: a_bits[64], b_bits[64]
  - Result bits: result_bits[64]
  - Operation selector

Constraints:
  - Binary: each bit in {0, 1}
  - Reconstruction: a = sum(a_bits[i] * 2^i)
  - Operation: result_bits = f(a_bits, b_bits)
```

### Comparison Machine

Handles comparison operations:

```
Operations:
  - Less than
  - Greater than
  - Equality
  - Signed comparisons

Columns:
  - Operands: a, b
  - Difference: a - b (or b - a)
  - Sign/borrow indicators
  - Result: boolean

Constraints:
  - Difference computation correct
  - Sign correctly determined
  - Result matches comparison
```

### Hashing Machine

Handles cryptographic hashes:

```
Operations:
  - Hash computation (SHA-256, Keccak, etc.)
  - Incremental hashing
  - HMAC (if supported)

Columns:
  - Input words
  - Round state
  - Round constants
  - Output words

Constraints:
  - Round function correct
  - Padding correct
  - State transitions valid
  - Final output correct
```

### Signature Machine

Handles signature verification:

```
Operations:
  - ECDSA verify
  - EdDSA verify
  - Schnorr verify

Columns:
  - Public key coordinates
  - Signature components
  - Message hash
  - Intermediate curve points
  - Verification result

Constraints:
  - Scalar multiplication correct
  - Point addition correct
  - Final equation satisfied
```

## Design Patterns

### Operation Dispatch

Routing operations to machines:

```
Dispatch logic in main machine:
  if op_type in [ADD, SUB]:
    // Handle in main machine
  elif op_type in [MUL, DIV]:
    dispatch_to(arithmetic_machine, op, operands)
  elif op_type in [AND, OR, XOR]:
    dispatch_to(binary_machine, op, operands)
  elif op_type == LOAD:
    dispatch_to(memory_machine, READ, address)
  ...
```

### Result Collection

Gathering results:

```
Result integration:
  1. Main machine records expected result location
  2. Secondary machine computes and stores result
  3. Main machine reads from result location
  4. Lookup/permutation proves connection

Or with dedicated result columns:
  result = mux(
    arith_result if arith_active,
    binary_result if binary_active,
    memory_result if memory_active,
    ...
  )
```

### Batching Operations

Processing multiple operations:

```
Batch approach:
  1. Accumulate operations during execution
  2. Sort by type
  3. Process each type in dedicated rows
  4. Link back to original positions

Benefits:
  - Better locality in secondary machines
  - Reduced context switching overhead
  - Enables specialized optimizations
```

## Connection Mechanisms

### Permutation Arguments

Linking main and secondary:

```
Main machine columns:
  request_id, op_type, operand1, operand2, expected_result

Secondary machine columns:
  request_id, op_type, input1, input2, computed_result

Permutation constraint:
  (request_id, op_type, operand1, operand2, expected_result)
  is permutation of
  (request_id, op_type, input1, input2, computed_result)
```

### Lookup Arguments

Table-based connection:

```
Secondary machine defines table:
  {(op, input1, input2, output) : valid operations}

Main machine performs lookups:
  (op_type, operand1, operand2, result) in operation_table
```

### Bus Systems

Shared bus architecture:

```
Bus columns shared across machines:
  bus_active: is this row a bus transaction?
  bus_type: operation type
  bus_data_0, bus_data_1, ...: operation data

Each machine:
  - Reads from bus when transaction for it
  - Writes results back to bus
  - Constraint: sum of bus contributions = 0 (balanced)
```

## Resource Allocation

### Column Allocation

Distributing columns:

```
Total columns: 1000 (example)

Main machine: 200 columns
  - Registers, PC, flags, instruction decode

Arithmetic machine: 100 columns
  - Wide multiplication decomposition

Memory machine: 150 columns
  - Address, value, timestamp, sorted copies

Binary machine: 200 columns
  - 64-bit decompositions

Hashing machine: 300 columns
  - Internal hash state

Remaining: 50 columns
  - Bus, auxiliary, future expansion
```

### Row Utilization

Efficient row usage:

```
Not all machines active every row:
  Main machine: active every row
  Arithmetic machine: active on MUL/DIV rows
  Memory machine: active on LOAD/STORE rows
  Binary machine: active on bitwise rows

Packing approach:
  - Multiple secondary operations per row if independent
  - Or dedicated row regions per machine
```

### Dynamic Allocation

Adapting to workload:

```
Static allocation:
  - Fixed columns per machine
  - Simpler, predictable

Dynamic allocation:
  - Columns assigned based on operation mix
  - More complex, better utilization
  - Requires knowing workload ahead
```

## Optimization Strategies

### Specialization

Custom constraints per operation:

```
Instead of general-purpose:
  Specialized multiplication machine for common sizes
  Specialized memory machine for sequential access
  Specialized hash machine for specific algorithms

Trade-offs:
  - More constraint sets to manage
  - Better performance for target operations
  - Larger overall system complexity
```

### Caching

Reusing computation:

```
Cache within secondary machine:
  - Store recent computations
  - Check cache before computing
  - Especially useful for repeated operations

Cross-machine caching:
  - Hash results for same inputs
  - Memory values for same addresses
```

### Lazy Evaluation

Defer secondary computation:

```
Approach:
  1. Main machine records operations
  2. All main execution completes
  3. Secondary machines process in batch
  4. Connection proofs link results

Benefits:
  - Better batching opportunities
  - Secondary machines process in order
  - Simplified control flow
```

## Key Concepts

- **Secondary state machine**: Specialized processor for specific operations
- **Bus**: Communication channel between machines
- **Dispatch**: Routing operations to appropriate machine
- **Connection**: Proving consistency between machines
- **Batching**: Processing multiple operations together

## Design Considerations

### Monolithic vs. Modular

| Monolithic (All-in-One) | Modular (Many Machines) |
|-------------------------|-------------------------|
| Simpler connection | Complex connection |
| Less flexible | Highly flexible |
| Harder to optimize | Targeted optimization |
| One constraint system | Many constraint systems |

### Generality vs. Specialization

| General Machine | Specialized Machine |
|-----------------|---------------------|
| Handles many operations | Handles one well |
| Average efficiency | Optimal efficiency |
| Simpler system | More components |
| Easier maintenance | More expertise needed |

## Related Topics

- [Component Registry](01-component-registry.md) - Managing machine components
- [Lookup Arguments](02-lookup-arguments.md) - Connection mechanism
- [State Machine Abstraction](../../04-zkvm-architecture/02-state-machine-design/01-state-machine-abstraction.md) - Machine design principles
- [Main State Machine](../../04-zkvm-architecture/02-state-machine-design/02-main-state-machine.md) - Primary execution machine
