# Witness Generation

## Overview

Witness generation is the process of producing the execution trace and auxiliary data that serves as the private input to the STARK prover. The witness includes all intermediate values computed during program execution, structured according to the constraint system's requirements. A correctly generated witness satisfies all constraints and can be transformed into a valid proof; an incorrect witness leads to constraint violations that prevent proof generation.

The witness generation process bridges the gap between program execution and cryptographic proving. The emulator executes the program while recording every state transition, memory operation, and intermediate computation. This raw trace is then transformed into the structured columnar format required by the AIR (Algebraic Intermediate Representation), with additional auxiliary columns computed to support lookup arguments and other constraint types.

This document covers witness structure, generation algorithms, validation techniques, and optimization strategies for efficient witness production.

## Witness Structure

### Execution Trace Format

The witness centers on the execution trace - a two-dimensional table:

```
Trace Structure:
  Rows: One per computation step (cycle)
  Columns: State variables and intermediate values

  +--------+--------+--------+--------+-----+--------+
  |  PC    |  REG_0 |  REG_1 | OPCODE | ... | MEM_OP |
  +--------+--------+--------+--------+-----+--------+
  | 0x1000 |   0    |   0    |  ADDI  | ... |   -    |
  | 0x1004 |   5    |   0    |  LOAD  | ... |   R    |
  | 0x1008 |   5    |  42    |  ADD   | ... |   -    |
  | ...    |  ...   |  ...   |  ...   | ... |  ...   |
  +--------+--------+--------+--------+-----+--------+
```

### Column Categories

Witness columns serve different purposes:

```
Main state columns:
  - Program counter (PC)
  - General-purpose registers (32 for RISC-V)
  - Stack pointer
  - Status flags

Instruction columns:
  - Opcode
  - Operand selectors
  - Immediate values
  - Instruction format indicators

Memory columns:
  - Memory address
  - Memory value
  - Read/write flag
  - Timestamp

Auxiliary columns:
  - Range check decompositions
  - Lookup argument helpers
  - Permutation argument accumulators
  - Bit decompositions for bitwise operations
```

### Committed vs. Auxiliary Columns

Different column types have different generation timing:

```
Committed columns (Stage 1):
  - Generated directly from execution
  - Known before any random challenges
  - Include main state and instruction info

Auxiliary columns (Stage 2):
  - Generated after receiving random challenges
  - Support lookup and permutation arguments
  - Include running products, sums, accumulators

Extended columns (Stage 3):
  - Generated after composition challenges
  - Support DEEP quotient and composition
```

## Generation Process

### High-Level Flow

Witness generation follows this pipeline:

```
1. Program Loading
   - Parse ELF or other executable format
   - Initialize memory with program code and data
   - Set up initial register state

2. Execution Simulation
   - Step through instructions
   - Record state at each cycle
   - Track memory operations

3. Trace Construction
   - Organize recorded state into columns
   - Pad to power-of-two length
   - Apply any necessary transformations

4. Auxiliary Computation
   - Compute range check decompositions
   - Build sorted copies for lookups
   - Calculate running products/sums

5. Validation
   - Check all constraints satisfied
   - Verify consistency across columns
   - Report any errors
```

### Step-by-Step Execution

The core execution loop:

```
Initialize:
  PC = entry_point
  Registers = initial_values
  Memory = program_memory

For cycle = 0, 1, 2, ..., until termination:
  1. Fetch instruction at Memory[PC]
  2. Decode opcode and operands
  3. Record pre-execution state:
     trace[cycle] = {PC, Registers, Memory_op, ...}
  4. Execute instruction:
     - Compute result
     - Update registers
     - Perform memory operations
  5. Update PC (branch or sequential)
  6. Check termination condition

Finalize:
  Record final state
  Pad trace to power of two
```

### Memory Operation Recording

Memory operations require special handling:

```
For each memory access:
  Record:
    - Address
    - Value (before and after if write)
    - Operation type (read/write)
    - Timestamp (cycle number)

Memory trace format:
  +----------+----------+------+----------+
  |  Address |  Value   | Type | Timestamp|
  +----------+----------+------+----------+
  |  0x4000  |   42     |   R  |    5     |
  |  0x4004  |   17     |   W  |    7     |
  |  0x4000  |   42     |   R  |   12     |
  +----------+----------+------+----------+

This trace enables memory consistency checking via sorting and permutation arguments.
```

### Auxiliary Column Computation

After main trace generation:

```
Range check decomposition:
  For each value requiring range check:
    Decompose into bytes or smaller chunks
    Add decomposition to auxiliary columns
    Example: value = b0 + b1*256 + b2*65536 + b3*16777216

Lookup arguments:
  Sort trace by lookup keys
  Compute multiplicities (how often each value appears)
  Generate running product columns with random challenge

Permutation arguments:
  Generate random linear combination of tuple elements
  Compute running products for original and permuted orderings
  Verify products match at final row

Bit decomposition:
  For bitwise operations (AND, OR, XOR):
    Decompose operands into individual bits
    Compute operation on each bit
    Reconstruct result
```

## Memory Consistency

### The Memory Problem

Memory must be consistent across the execution:

```
Property: Every read returns the value from the most recent write to that address.

Challenge: Memory accesses are out of order in the trace.
           Consecutive rows may access completely different addresses.

Solution: Permutation argument showing memory operations
          are consistent with a time-ordered view.
```

### Time-Ordered Memory

Construct a secondary view of memory:

```
Original trace (by cycle):
  Cycle 5:  Read  addr=0x100, value=42
  Cycle 7:  Write addr=0x200, value=17
  Cycle 9:  Read  addr=0x100, value=42
  Cycle 12: Write addr=0x100, value=99
  Cycle 15: Read  addr=0x100, value=99

Sorted trace (by address, then timestamp):
  addr=0x100, time=5,  Read,  value=42
  addr=0x100, time=9,  Read,  value=42
  addr=0x100, time=12, Write, value=99
  addr=0x100, time=15, Read,  value=99
  addr=0x200, time=7,  Write, value=17
```

### Consistency Constraints

On sorted trace:

```
For consecutive operations to same address:
  If both reads: values must match
  If write then read: values must match
  If read then write: no constraint (write updates)
  If both writes: no constraint

For change of address:
  No constraint between last op on old address
  and first op on new address

First access to address:
  Must be write, or read of initial value (e.g., zero)
```

### Permutation Argument Witness

Witness for permutation argument:

```
For each row i:
  Original tuple: (addr_i, value_i, type_i, time_i)
  Sorted tuple: (addr'_i, value'_i, type'_i, time'_i)

Random challenge: alpha

Linear combination:
  orig_i = addr_i + alpha*value_i + alpha^2*type_i + alpha^3*time_i
  sort_i = addr'_i + alpha*value'_i + alpha^2*type'_i + alpha^3*time'_i

Running products:
  prod_orig[i] = prod_orig[i-1] * (orig_i - beta)
  prod_sort[i] = prod_sort[i-1] * (sort_i - beta)

  where beta is another random challenge

Final check: prod_orig[n-1] = prod_sort[n-1]
```

## Range Checks and Lookups

### Range Check Witness

Values must be within valid ranges:

```
For a value v that must be in [0, 2^16):
  Decompose: v = lo + hi * 256, where lo, hi in [0, 256)

  Witness columns:
    value_lo = v mod 256
    value_hi = v // 256

  Lookup: Both lo and hi must appear in byte table [0..255]
```

### Lookup Argument Witness

Lookup tables verified via logarithmic derivatives:

```
Table T with entries {t_0, t_1, ..., t_m}
Values to look up: {v_0, v_1, ..., v_n}

Multiplicity: mult[j] = count of how many v_i equal t_j

Witness columns:
  For looked-up values: column containing v_i
  For table: column containing t_j
  For multiplicities: column containing mult[j]

Random challenge: gamma

Check (using logarithmic derivative sums):
  Sum over looked-up values: sum_i 1/(gamma - v_i)
  Sum over table: sum_j mult[j]/(gamma - t_j)

These sums must be equal (accumulated via running sum columns)
```

### Bit Decomposition Witness

For bitwise operations:

```
Inputs: a = 64-bit value, b = 64-bit value
Operation: c = a XOR b

Witness:
  a_bits[0..63]: Individual bits of a
  b_bits[0..63]: Individual bits of b
  c_bits[0..63]: Individual bits of c

  For each i: c_bits[i] = a_bits[i] + b_bits[i] - 2*a_bits[i]*b_bits[i]

Additional constraints:
  Each bit is binary: bit * (1 - bit) = 0
  Reconstruction: a = sum(a_bits[i] * 2^i)
```

## Padding and Layout

### Power-of-Two Padding

Trace length must be power of two for FFT:

```
Actual execution length: n_exec
Padded length: n = 2^k where 2^k >= n_exec

Padding strategies:
  1. Repeat final state (simple, may not satisfy constraints)
  2. No-op padding (execute NOPs until padded length)
  3. Loop padding (execution wraps to a loop)
  4. Special padding rows (with selector columns)

Example with selector:
  Row 0 to n_exec-1: active = 1 (real execution)
  Row n_exec to n-1: active = 0 (padding)

  Constraints multiplied by active selector:
    active * (constraint_expr) = 0
```

### Column Layout Optimization

Organize columns for efficiency:

```
Strategies:
  1. Group related columns (all register columns together)
  2. Place frequently accessed columns in low-degree positions
  3. Align memory access patterns for cache efficiency
  4. Consider constraint evaluation order

Example layout:
  Columns 0-31: Registers r0-r31
  Columns 32-35: PC, next_PC, SP, flags
  Columns 36-39: Opcode, operand selectors
  Columns 40-50: Memory operation fields
  Columns 51+: Auxiliary columns
```

### Multi-Trace Structure

For large computations, use multiple traces:

```
Main trace: Core execution state
Secondary traces: Specialized operations
  - Arithmetic sub-trace (MUL, DIV details)
  - Memory sub-trace (sorted memory operations)
  - Binary sub-trace (bit decompositions)
  - Crypto sub-trace (hash computations)

Connection via permutation/lookup arguments
```

## Optimization Techniques

### Lazy Computation

Defer expensive computations:

```
Instead of computing all auxiliary columns upfront:
  1. Generate main trace fully
  2. Compute auxiliary columns on demand per region
  3. Stream results to constraint evaluation

Benefits:
  - Lower peak memory usage
  - Better cache utilization
  - Can parallelize by region
```

### Parallel Witness Generation

Execution is sequential, but post-processing parallelizes:

```
Sequential (must be in order):
  - Instruction execution
  - State updates
  - Memory operations

Parallel (independent by column):
  - Range check decompositions
  - Bit decompositions
  - Different auxiliary column computations

Parallel (independent by region):
  - Constraint validation
  - NTT of columns
  - Merkle tree construction
```

### Memory-Efficient Generation

For large traces:

```
Streaming approach:
  1. Execute and write trace rows to disk in chunks
  2. Build Merkle tree incrementally
  3. Compute auxiliary columns chunk by chunk
  4. Never hold entire trace in memory

Trade-off: More I/O, less memory
```

## Validation

### Constraint Checking

Verify witness before proving:

```
For each constraint C:
  For each applicable row i:
    Evaluate C(row[i], row[i+1], ...)
    If result != 0:
      Report: "Constraint C violated at row i"
      Include: Column values involved

Early detection saves expensive proving work
```

### Consistency Checks

Verify internal consistency:

```
1. Value range: All field elements within valid range
2. Binary columns: Values are only 0 or 1
3. Decomposition: Reconstructed values match originals
4. Memory: All reads return expected values
5. Padding: Padding rows satisfy constraints
6. Length: Trace is correct power of two
```

### Debug Output

Helpful debugging information:

```
On constraint failure:
  - Which constraint
  - Which row
  - Values of all columns in that constraint
  - Expected vs. actual evaluation

On consistency failure:
  - Which check failed
  - Specific values causing failure
  - Suggested fix if determinable
```

## Key Concepts

- **Witness**: Complete execution trace plus auxiliary data for proving
- **Execution trace**: Table of state values at each computation step
- **Auxiliary columns**: Helper columns for lookups, range checks, etc.
- **Memory consistency**: Ensuring reads return correct values
- **Padding**: Extending trace to power-of-two length

## Design Considerations

### Trace Width vs. Length

| Wider Trace | Narrower Trace |
|-------------|----------------|
| More columns, fewer rows | Fewer columns, more rows |
| Lower constraint degree | Higher constraint degree |
| More memory per row | Less memory per row |

### Witness Generation vs. Proving

Witness generation is often faster than proving, but:
- Memory requirements can be limiting
- I/O can be bottleneck for large traces
- Validation catches errors early

## Related Topics

- [Algebraic Intermediate Representation](../02-constraint-system/01-algebraic-intermediate-representation.md) - Trace structure
- [Polynomial Encoding](02-polynomial-encoding.md) - Converting trace to polynomials
- [Constraint Evaluation](03-constraint-evaluation.md) - Checking constraints
- [Execution Trace](../../04-zkvm-architecture/01-execution-model/02-execution-trace.md) - zkVM trace details
