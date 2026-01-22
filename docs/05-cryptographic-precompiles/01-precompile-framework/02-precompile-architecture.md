# Precompile Architecture

## Overview

Precompile architecture defines the structural components and their interactions within a precompile system. Each precompile is implemented as a specialized state machine with its own trace, constraints, and interfaces. The architecture must support efficient proving while maintaining clean integration with the main zkVM execution. This involves careful design of trace layouts, constraint systems, and cross-machine communication.

The architecture follows a modular pattern where each precompile is self-contained but adheres to standard interfaces for integration. This modularity allows new precompiles to be added without modifying the core zkVM, and enables precompiles to be optimized independently. The architecture also supports different precompile sizes and complexities, from simple hash functions to complex pairing operations.

This document covers precompile machine structure, trace organization, constraint patterns, and integration mechanisms for the precompile subsystem.

## Machine Structure

### Precompile Machine Components

Elements of a precompile machine:

```
Input handler:
  Receives input from main machine
  Deserializes input data
  Validates input format

Core computation:
  Specialized constraint system
  Algorithm-specific logic
  Intermediate state management

Output generator:
  Produces output data
  Serializes output format
  Commits to output

Linking interface:
  Lookup/permutation columns
  Accumulator columns
  Public input/output
```

### Machine Lifecycle

Precompile execution phases:

```
Phase 1: Initialization
  Receive call parameters
  Set up initial state
  Prepare input data

Phase 2: Computation
  Execute algorithm rounds
  Maintain intermediate state
  Apply round constraints

Phase 3: Finalization
  Extract final output
  Commit to result
  Signal completion

Phase 4: Linking
  Provide lookup/permutation data
  Verify cross-machine consistency
```

### State Machine Model

Precompile as finite state machine:

```
States:
  IDLE: Waiting for invocation
  LOADING: Reading input
  COMPUTING: Processing algorithm
  OUTPUTTING: Writing output
  DONE: Ready for next call

Transitions:
  IDLE -> LOADING: On invocation
  LOADING -> COMPUTING: Input complete
  COMPUTING -> COMPUTING: Round iteration
  COMPUTING -> OUTPUTTING: Computation done
  OUTPUTTING -> DONE: Output written
  DONE -> IDLE: Cleanup

State constraints:
  Valid transitions only
  Counter bounds for rounds
```

## Trace Organization

### Precompile Trace Layout

Columns for precompile machine:

```
Control columns:
  call_idx: Which invocation (for batching)
  round_idx: Current round number
  state: Current machine state
  is_active: Row has active computation

Input columns:
  input_data: Deserialized input values
  input_len: Input length
  input_hash: Input commitment

Computation columns:
  Algorithm-specific intermediates
  Round state values
  Lookup values

Output columns:
  output_data: Computed output
  output_hash: Output commitment
```

### Round-Based Layout

For iterative algorithms:

```
Hash function example (SHA-256):
  64 rounds per block

Layout option 1 (row per round):
  Row 0: Round 0 state
  Row 1: Round 1 state
  ...
  Row 63: Round 63 state
  Row 64: Next block or done

Layout option 2 (multiple rounds per row):
  Row 0: Rounds 0-7
  Row 1: Rounds 8-15
  ...
  Fewer rows, more columns

Trade-off:
  Rows vs columns
  Constraint complexity
  Parallelization
```

### Batched Trace Layout

Multiple calls in one trace:

```
Batched structure:
  Calls: [call_0, call_1, call_2, ...]

Layout:
  Rows 0-N: call_0 computation
  Rows N+1-M: call_1 computation
  ...

Call boundaries:
  is_call_start: First row of call
  is_call_end: Last row of call
  call_idx: Identifies which call
```

## Constraint System

### Round Constraints

Per-round computation:

```
For hash round i:
  state_out = round_function(state_in, message_schedule[i])

Constraints:
  // Round function applied correctly
  (state_out - expected_round_output) = 0

  // State flows between rounds
  state_in[i+1] = state_out[i]

  // Message schedule computed correctly
  w[i] = schedule_function(w[i-16], w[i-15], ...)
```

### Transition Constraints

State machine transitions:

```
Valid state progression:
  state_next = transition(state_current, inputs)

Constraints:
  // Only valid transitions
  (state, state_next) in valid_transitions

  // Round counter increments
  is_computing * (round_next - round_current - 1) = 0

  // Bounds checking
  round_current < max_rounds
```

### Finalization Constraints

Output extraction:

```
Final state to output:
  output = finalize(final_state, initial_state)

SHA-256 example:
  hash[i] = final_state[i] + initial_state[i]  (mod 2^32)

Constraint:
  is_finalizing * (output - finalize(state, init)) = 0
```

## Algorithm Integration

### Generic Algorithm Interface

Common pattern for all algorithms:

```
Interface:
  initialize(input) -> initial_state
  round(state, round_data) -> new_state
  finalize(state) -> output

Constraint pattern:
  is_init * (state - initialize(input)) = 0
  is_round * (state_next - round(state, round_data)) = 0
  is_final * (output - finalize(state)) = 0
```

### Algorithm-Specific Optimization

Tailoring to specific algorithms:

```
SHA-256 optimizations:
  Precomputed constants table
  Efficient bit rotation circuits
  Optimized addition chain for Boolean functions

Keccak optimizations:
  5x5 state representation
  Lane-based computation
  Optimized permutation constraints

EC optimizations:
  Projective coordinates (avoid division)
  Windowed scalar multiplication
  Precomputed point tables
```

### Lookup Tables

Precomputed values for efficiency:

```
Common tables:
  Round constants: {(round_idx, constant_value)}
  Bit operations: {(a, b, a XOR b)}
  Byte operations: {(byte, transformed_byte)}

Usage:
  (round_idx, k) in round_constants_table
  (x, y, x_xor_y) in xor_table

Benefits:
  Reduce constraint complexity
  Amortize across all calls
```

## Cross-Machine Integration

### Input Connection

Receiving from main machine:

```
Main machine columns:
  precompile_id: Which precompile
  input_ptr: Memory address of input
  input_len: Input length
  input_hash: Commitment to input

Precompile receives:
  Via lookup or permutation
  (call_idx, input_hash) matches main's claim

Constraint:
  (call_idx, input_hash, output_hash) in precompile_results
```

### Output Connection

Returning to main machine:

```
Precompile produces:
  output_data: Computed result
  output_hash: Commitment to output

Main machine receives:
  Via lookup from precompile results table
  Writes output to memory

Memory update:
  Main machine handles memory write
  Precompile only provides value
```

### Batching and Ordering

Handling call order:

```
Execution order (main machine):
  call_0 at cycle 100
  call_1 at cycle 500
  call_2 at cycle 800

Processing order (precompile):
  May differ from execution order
  Sorted for efficiency

Linking:
  call_idx identifies each call
  Permutation proves same set of calls
```

## Memory Handling

### Input Deserialization

Reading input data:

```
Input in memory:
  bytes at address input_ptr
  length input_len

Deserialization:
  Convert bytes to field elements
  Parse structured data
  Validate format

Constraint:
  Serialization constraints
  Format validity
```

### Output Serialization

Writing output data:

```
Computed output:
  Field elements or structured data

Serialization:
  Convert to bytes
  Pack into memory format

Memory write:
  Handled by main machine
  Precompile provides values
```

## Error Handling

### Input Validation

Checking input validity:

```
Validation checks:
  Length within bounds
  Format correct
  Values in valid range

For EC operations:
  Point on curve
  Point in correct subgroup
  Scalars in valid range

Constraint:
  is_valid_input = validation_checks_pass
  !is_valid_input implies error_output
```

### Error Signaling

Communicating errors:

```
Error indicators:
  is_error: Error occurred
  error_code: Which error

Error handling:
  is_error * (output - error_value) = 0
  !is_error * (normal_output_constraints)

Main machine:
  Checks error status
  Takes appropriate action
```

## Key Concepts

- **Precompile machine**: Specialized state machine for specific operation
- **Round constraints**: Per-iteration computation rules
- **Transition constraints**: State progression rules
- **Input/output connection**: Cross-machine linking
- **Batched execution**: Processing multiple calls together

## Design Considerations

### Trace Size

| Small Trace | Large Trace |
|-------------|-------------|
| Few columns | Many columns |
| Many rows | Fewer rows |
| Lower memory | Higher memory |
| Different trade-offs | Different trade-offs |

### Constraint Complexity

| Simple Constraints | Complex Constraints |
|-------------------|---------------------|
| More rows | Fewer rows |
| Lower degree | Higher degree |
| Easier debugging | Harder debugging |
| More lookups | Fewer lookups |

## Related Topics

- [Precompile Concept](01-precompile-concept.md) - Motivation and abstraction
- [SHA-256 Circuit](../02-hash-functions/01-sha256-circuit.md) - Hash precompile example
- [Curve Arithmetic](../03-elliptic-curves/01-curve-arithmetic.md) - EC precompile example
- [Cross-Machine Consistency](../../04-zkvm-architecture/05-system-integration/02-cross-machine-consistency.md) - Integration details
