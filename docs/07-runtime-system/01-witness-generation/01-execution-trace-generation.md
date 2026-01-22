# Execution Trace Generation

## Overview

Execution trace generation is the process of running a program and recording every computational step in a format suitable for proving. The trace captures the complete execution history: every instruction executed, every register state, every memory access. This detailed record becomes the witness that the prover uses to construct the zero-knowledge proof.

The trace generator acts as both an interpreter executing the program and a recorder capturing the execution. It must faithfully implement RISC-V semantics while populating trace columns according to the constraint system's expectations. Any mismatch between execution and trace structure will cause constraint violations during proving. This document covers trace generation architecture, column population strategies, and optimization techniques for efficient trace creation.

## Trace Generation Architecture

### Generator Components

Building blocks of trace generation:

```
Interpreter:
  Executes RISC-V instructions
  Maintains architectural state
  Advances program counter

State Tracker:
  Records register values
  Tracks memory operations
  Logs control flow

Trace Writer:
  Formats data for trace columns
  Handles column layout
  Manages trace buffers

Auxiliary Generator:
  Computes helper values
  Generates lookup data
  Prepares proof-specific columns
```

### Generation Pipeline

Flow from program to trace:

```
Input:
  Program binary (ELF or raw)
  Input data (public + private)
  Configuration parameters

Processing:
  1. Load program into memory
  2. Initialize registers and state
  3. Execute instructions
  4. Record each step in trace
  5. Populate auxiliary columns

Output:
  Execution trace (column matrix)
  Memory trace
  Lookup tables
  Public outputs
```

### Execution Loop

Core generation loop:

```
while not halted:
  # Fetch
  instruction = memory[pc]

  # Decode
  (opcode, rd, rs1, rs2, imm) = decode(instruction)

  # Record pre-state
  trace_row = new_row()
  trace_row.pc = pc
  trace_row.instruction = instruction
  trace_row.rs1_val = registers[rs1]
  trace_row.rs2_val = registers[rs2]

  # Execute
  result = execute(opcode, rs1_val, rs2_val, imm)

  # Record result
  trace_row.result = result
  trace_row.rd_val = result

  # Update state
  registers[rd] = result
  pc = next_pc(opcode, result)

  # Write row
  trace.append(trace_row)
```

## Column Population

### Primary Columns

Core execution state:

```
Per-row population:
  row.cycle = current_cycle
  row.pc = program_counter
  row.instruction = fetched_instruction
  row.opcode = instruction[6:0]
  row.rd_idx = instruction[11:7]
  row.rs1_idx = instruction[19:15]
  row.rs2_idx = instruction[24:20]

Values:
  row.rs1_val = registers[rs1_idx]
  row.rs2_val = registers[rs2_idx]
  row.imm = compute_immediate(instruction)
```

### Selector Columns

Operation type indicators:

```
Derive from opcode:
  row.is_add = (opcode == 0x33) and (funct3 == 0) and (funct7 == 0)
  row.is_sub = (opcode == 0x33) and (funct3 == 0) and (funct7 == 0x20)
  row.is_load = (opcode == 0x03)
  row.is_store = (opcode == 0x23)
  row.is_branch = (opcode == 0x63)
  row.is_jal = (opcode == 0x6F)

Binary selectors:
  Exactly one operation selector = 1
  All others = 0
```

### Result Columns

Computation outputs:

```
Based on operation:
  if is_alu_op:
    row.alu_result = compute_alu(opcode, rs1_val, rs2_val, imm)

  if is_load:
    row.mem_addr = rs1_val + imm
    row.mem_val = memory[mem_addr]

  if is_branch:
    row.branch_target = pc + imm
    row.branch_taken = evaluate_condition(rs1_val, rs2_val)

  if is_jal or is_jalr:
    row.link_val = pc + 4
```

### Auxiliary Columns

Helper values for constraints:

```
Decompositions:
  row.result_bytes = byte_decompose(result)
  row.addr_bytes = byte_decompose(mem_addr)

Comparison helpers:
  row.is_zero = (result == 0)
  row.is_negative = (result < 0)
  row.diff = rs1_val - rs2_val
  row.diff_inv = inverse(diff) if diff != 0 else 0

Carry/overflow:
  row.carry = (rs1_val + rs2_val) >> 64
  row.overflow = detect_overflow(rs1_val, rs2_val, result)
```

## Memory Trace

### Memory Operation Recording

Capturing memory accesses:

```
For each load/store:
  mem_trace.append({
    'addr': effective_address,
    'value': data_value,
    'op': 'read' or 'write',
    'cycle': current_cycle,
    'size': access_size
  })

Memory trace separate from execution trace:
  Linked via permutation/lookup
  Sorted for consistency checking
```

### Address Calculation

Computing effective addresses:

```
Load: addr = rs1_val + sign_extend(imm_i)
Store: addr = rs1_val + sign_extend(imm_s)

Size handling:
  LB/SB: 1 byte at addr
  LH/SH: 2 bytes at addr
  LW/SW: 4 bytes at addr
  LD/SD: 8 bytes at addr

Alignment:
  Check addr alignment for size
  Handle misalignment if supported
```

### Value Extraction

Reading/writing memory:

```
Load value:
  raw = memory[addr:addr+size]
  extended = sign_extend(raw) or zero_extend(raw)
  row.load_val = extended

Store value:
  raw = rs2_val[0:size*8]
  memory[addr:addr+size] = raw
  row.store_val = raw
```

## State Management

### Register State

Tracking register file:

```
Register array:
  registers[0..31]
  registers[0] = 0 (always)

Per-instruction update:
  if writes_rd and rd != 0:
    registers[rd] = result

State in trace:
  Option 1: All registers per row (wide)
  Option 2: Only accessed registers (narrow)
  Option 3: Separate register trace
```

### Program Counter

PC advancement:

```
Sequential:
  next_pc = pc + 4 (32-bit instruction)
  next_pc = pc + 2 (compressed instruction)

Branch taken:
  next_pc = pc + branch_offset

Jump:
  JAL: next_pc = pc + jump_offset
  JALR: next_pc = (rs1_val + offset) & ~1

Record in trace:
  row.pc = current_pc
  row.next_pc = next_pc
```

### Halt Detection

Detecting execution end:

```
Halt conditions:
  ECALL with exit syscall
  EBREAK instruction
  Invalid instruction (optional)
  Maximum cycles reached

Recording:
  row.is_halted = halt_detected
  Subsequent rows: padding

Exit value:
  From register a0 on exit syscall
  Recorded in trace
```

## Optimization Techniques

### Lazy Column Computation

Defer expensive computations:

```
Eager:
  Compute all auxiliary columns during execution
  Memory intensive

Lazy:
  Store minimal state during execution
  Compute auxiliary columns in second pass

Implementation:
  Pass 1: Core execution, store essential state
  Pass 2: Compute decompositions, comparisons, etc.
```

### Parallel Trace Generation

Multi-threaded generation:

```
Approach 1: Segment parallelism
  Split execution into segments
  Generate traces in parallel
  Merge results

Approach 2: Column parallelism
  Generate primary columns first
  Compute auxiliary columns in parallel

Challenges:
  Dependencies between segments
  Consistent state at boundaries
```

### Memory-Efficient Generation

Reducing memory footprint:

```
Streaming:
  Write rows to disk as generated
  Don't hold full trace in memory

Compression:
  Compress completed rows
  Decompress for proving

Incremental:
  Generate and prove in chunks
  Suitable for very long executions
```

## Validation

### Consistency Checks

Verifying trace correctness:

```
State consistency:
  row[i].rd_next == row[i+1].rs_current (where applicable)
  row[i].next_pc == row[i+1].pc

Value consistency:
  Decompositions reconstruct originals
  Selectors are mutually exclusive

Memory consistency:
  Memory trace matches execution memory ops
```

### Constraint Pre-check

Early error detection:

```
Before full proving:
  Evaluate constraints on sample rows
  Catch obvious errors early

Check:
  Selector exclusivity
  Arithmetic correctness
  Range validity

Benefits:
  Faster debugging
  Reduced wasted proving time
```

## Key Concepts

- **Execution trace**: Matrix recording all computation steps
- **Column population**: Filling trace columns with execution data
- **Primary columns**: Core execution state (PC, instruction, values)
- **Auxiliary columns**: Helper values for constraints
- **Memory trace**: Record of memory operations

## Design Considerations

### Column Width

| Few Columns | Many Columns |
|-------------|--------------|
| Complex constraints | Simple constraints |
| More computation | More storage |
| Smaller footprint | Larger footprint |
| Harder to debug | Easier to debug |

### Generation Strategy

| Single Pass | Multi Pass |
|-------------|------------|
| Simpler | More complex |
| Higher memory | Lower memory |
| Faster for small | Better for large |
| All-at-once | Incremental |

## Related Topics

- [Auxiliary Value Computation](02-auxiliary-value-computation.md) - Helper columns
- [Memory Trace Construction](03-memory-trace-construction.md) - Memory specifics
- [Execution Engine](../02-execution-engine/01-interpreter-design.md) - Execution details
- [Trace Layout](../../04-zkvm-architecture/05-system-integration/03-trace-layout.md) - Column organization
