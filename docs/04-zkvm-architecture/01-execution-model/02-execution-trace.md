# Execution Trace

## Overview

The execution trace is the complete record of a program's execution, capturing every state transition from initialization to termination. In zkVM systems, the trace serves as the witness for proof generation - it provides all the data needed to demonstrate that a computation was performed correctly. The trace structure directly determines constraint complexity, prover memory requirements, and the efficiency of the entire proving pipeline.

A well-designed trace balances completeness with efficiency. It must contain enough information to verify every aspect of execution while minimizing redundancy and enabling efficient polynomial encoding. The trace layout affects column count (memory per row), row count (trace length), and constraint patterns (proving time).

This document covers trace structure, layout strategies, and the relationship between trace design and proving efficiency.

## Trace Structure

### Basic Layout

The trace as a two-dimensional table:

```
           Column 0  Column 1  Column 2  ...  Column W-1
          +---------+---------+---------+----+---------+
Row 0     |  PC_0   | REG_0_0 | REG_1_0 | .. | FLAG_0  |
Row 1     |  PC_1   | REG_0_1 | REG_1_1 | .. | FLAG_1  |
Row 2     |  PC_2   | REG_0_2 | REG_1_2 | .. | FLAG_2  |
  ...     |   ...   |   ...   |   ...   | .. |   ...   |
Row N-1   | PC_N-1  |REG_0_N-1|REG_1_N-1| .. |FLAG_N-1 |
          +---------+---------+---------+----+---------+

Rows: One per execution cycle (time steps)
Columns: State variables (registers, flags, etc.)
Cells: Field elements representing state values
```

### Trace Dimensions

Key parameters:

```
Width (W): Number of columns
  - Determined by state variables needed
  - More columns = more memory per row
  - Typical: 100-1000 columns

Length (N): Number of rows
  - Determined by computation steps
  - Must be power of two (for FFT)
  - Typical: 2^16 to 2^24 rows

Total cells: W * N field elements
  - Memory: W * N * element_size bytes
  - Example: 500 columns * 2^20 rows * 8 bytes = 4 GB
```

### Column Types

Different columns serve different purposes:

```
State columns:
  - PC (program counter)
  - Registers (32 general-purpose)
  - Flags (zero, sign, overflow)
  - Stack pointer

Instruction columns:
  - Instruction word
  - Opcode
  - Operand indices
  - Immediate values
  - Instruction selectors

Memory columns:
  - Memory address
  - Memory value
  - Read/write indicator
  - Timestamp

Auxiliary columns:
  - Bit decompositions
  - Range check helpers
  - Lookup accumulators
  - Intermediate computations
```

## Trace Generation

### Generation Process

Creating the trace:

```
1. Initialize:
   - Set PC to entry point
   - Initialize registers (typically to zero)
   - Load program into memory
   - Prepare public/private inputs

2. Execute loop:
   For cycle = 0 to completion:
     a. Record pre-state to trace row
     b. Fetch instruction at PC
     c. Decode instruction
     d. Execute operation
     e. Record operation details
     f. Update state (registers, PC)
     g. Record memory operations

3. Finalize:
   - Record final state
   - Pad to power-of-two length
   - Compute auxiliary columns
```

### Recording Strategy

What to record and when:

```
Per cycle, record:
  Current state:
    trace[cycle].pc = pc
    trace[cycle].registers = registers.copy()

  Instruction info:
    trace[cycle].instruction = memory[pc]
    trace[cycle].opcode = decode(instruction)
    trace[cycle].rs1 = instruction.rs1_index
    trace[cycle].rs2 = instruction.rs2_index
    trace[cycle].rd = instruction.rd_index

  Execution results:
    trace[cycle].rs1_value = registers[rs1]
    trace[cycle].rs2_value = registers[rs2]
    trace[cycle].result = compute(opcode, rs1_value, rs2_value)

  Next state:
    trace[cycle].next_pc = next_pc_value
```

### Memory Operation Recording

Tracking memory accesses:

```
For each memory operation:
  trace[cycle].mem_op = operation_type  // read, write, none
  trace[cycle].mem_addr = address
  trace[cycle].mem_value = value
  trace[cycle].mem_timestamp = cycle

Memory log (separate or integrated):
  memory_trace.append({
    address: address,
    value: value,
    timestamp: cycle,
    is_write: operation_type == write
  })
```

## Trace Layout Strategies

### Register Layout

Organizing register columns:

```
Option 1: Explicit columns per register
  Columns 0-31: reg_0 through reg_31
  Simple but uses 32 columns just for registers

Option 2: Read/write ports
  rs1_idx, rs1_val: First source
  rs2_idx, rs2_val: Second source
  rd_idx, rd_val: Destination
  Uses 6 columns, requires register file constraints

Option 3: Compressed
  reg_state: Hash or commitment of register file
  Changed register value stored explicitly
  Smallest but complex constraints
```

### Instruction Layout

Organizing instruction information:

```
Minimal layout:
  instruction: Full 32-bit word
  All decoding done in constraints

Expanded layout:
  instruction: Full word
  opcode: Decoded opcode
  funct3, funct7: Function fields
  rs1_idx, rs2_idx, rd_idx: Register indices
  immediate: Sign-extended immediate
  Faster constraint evaluation, more columns

Selector layout:
  is_add, is_sub, is_and, ...: One-hot selectors
  Many columns but simple constraints per instruction
```

### Auxiliary Layout

Placing helper columns:

```
Bit decomposition columns:
  For 64-bit value, may need 64 bit columns
  Or grouped (bytes, nibbles)

Range check columns:
  value_byte_0, value_byte_1, ...: Decomposed value
  Each byte range-checked via lookup

Accumulator columns:
  lookup_acc: Running sum for lookups
  perm_acc: Running product for permutations

Intermediate values:
  temp_1, temp_2: Computation intermediates
  Reduce constraint degree
```

## Padding

### Why Padding

Trace length must be power of two:

```
Actual execution: N_exec steps
Required length: N = 2^k >= N_exec

Padding needed: N - N_exec rows

Why power of two:
  - FFT/NTT requires it
  - Vanishing polynomial X^N - 1 factors nicely
  - Roots of unity form multiplicative group
```

### Padding Strategies

How to fill padding rows:

```
Strategy 1: No-op padding
  Continue execution with no-op instructions
  Constraints naturally satisfied
  Requires no-op to be valid instruction

Strategy 2: State repetition
  Repeat final state in padding rows
  Needs selector to disable transition constraints
  is_padding * transition_constraint = 0

Strategy 3: Special padding mode
  Padding rows have special structure
  Minimal constraints for padding
  Selector-based activation
```

### Padding Constraints

Ensuring padding is valid:

```
Padding selector:
  is_active[i] = 1 if i < N_exec else 0

Or computed:
  is_padding[i] = 1 if i >= N_exec else 0

Modified constraints:
  Original: next_pc = pc + 4
  With padding: is_active * (next_pc - pc - 4) = 0

Padding rows don't contribute to constraint violations.
```

## Multi-Trace Organization

### Trace Separation

Splitting into multiple traces:

```
Main trace:
  Core execution state
  Instruction flow
  Register operations

Memory trace:
  Memory operations sorted by address
  Consistency verification
  Separate polynomial encoding

Binary trace:
  Bit decompositions
  Bitwise operations
  Can have different length

Crypto trace:
  Hash computations
  Signature verifications
  Specialized constraints
```

### Trace Connection

Linking separate traces:

```
Permutation arguments:
  Main trace memory ops = Memory trace ops (as multiset)
  Proved via grand product

Lookup arguments:
  Values in main trace appear in lookup tables
  Proved via logarithmic derivative

Connection columns:
  Shared challenge columns
  Cross-trace accumulators
```

### Row Alignment

Managing different-length traces:

```
Same-length approach:
  All traces have same row count
  Padding as needed
  Simpler cross-trace constraints

Variable-length approach:
  Each trace sized to content
  More complex connection
  Lower total proving work
```

## Optimization Techniques

### Column Reuse

Sharing columns across instruction types:

```
Exclusive columns:
  If is_add active, use temp columns for add
  If is_mul active, use same temp columns for mul
  Never both active simultaneously

Constraint:
  is_add * (temp - (a + b)) = 0
  is_mul * (temp - (a * b)) = 0

Reduces total column count.
```

### Sparse Columns

Columns that are mostly zero:

```
Example: Immediate value
  Only I-type, S-type, etc. have immediates
  Many rows have immediate = 0

Optimization:
  Use lookup for non-zero immediates
  Or conditional column structure
```

### Compressed Representation

Reducing storage:

```
Hash-based:
  Store hash of full state, not all values
  Expand when needed for constraints

Delta encoding:
  Store changes from previous row
  Most registers don't change each cycle

Run-length:
  Compress repeated patterns
  Useful for loops
```

## Trace Validation

### Pre-proving Checks

Verify trace before expensive proving:

```
Structural checks:
  - Correct number of rows/columns
  - Power-of-two length
  - Field element ranges valid

Semantic checks:
  - PC transitions valid
  - Register updates correct
  - Memory operations consistent

Constraint pre-check:
  - Evaluate sample constraints
  - Catch errors early
```

### Debug Information

Helpful for development:

```
For each row, maintain:
  - Original instruction (assembly)
  - Source line number (if available)
  - Call stack depth
  - Loop iteration count

On constraint failure:
  - Report failing constraint
  - Show row context
  - Display column values
```

## Key Concepts

- **Execution trace**: Complete record of computation steps
- **Trace dimensions**: Width (columns) x Length (rows)
- **Column types**: State, instruction, memory, auxiliary
- **Padding**: Extending to power-of-two length
- **Multi-trace**: Separating concerns into linked traces

## Design Considerations

### Width vs. Length Trade-offs

| Wider Trace | Narrower Trace |
|-------------|----------------|
| More columns | Fewer columns |
| Simpler per-column constraints | More complex constraints |
| Higher memory per row | Lower memory per row |
| May encode more per cycle | More cycles needed |

### Memory vs. Proving Time

| Store Everything | Compute On-Demand |
|------------------|-------------------|
| Larger trace | Smaller trace |
| Faster constraint evaluation | Slower evaluation |
| More memory | Less memory |
| Simpler constraints | More complex constraints |

## Related Topics

- [RISC-V Execution](01-risc-v-execution.md) - Execution model
- [Instruction Cycle](03-instruction-cycle.md) - Per-cycle details
- [Witness Generation](../../02-stark-proving-system/04-proof-generation/01-witness-generation.md) - Trace to witness
- [Polynomial Encoding](../../02-stark-proving-system/04-proof-generation/02-polynomial-encoding.md) - Trace to polynomials
