# Interpreter Design

## Overview

The interpreter is the component that executes RISC-V programs instruction by instruction, implementing the semantics of each operation. In a zkVM context, the interpreter serves dual purposes: it runs the program to produce results, and it generates the witness data needed for proving. The interpreter must be faithful to the RISC-V specification while efficiently producing trace data.

A well-designed interpreter balances execution speed with trace generation overhead. It must handle all supported instructions, manage architectural state (registers, memory, PC), and record every step in a format suitable for the constraint system. This document covers interpreter architecture, instruction execution, state management, and performance considerations.

## Interpreter Architecture

### Core Components

Building blocks of the interpreter:

```
Fetch Unit:
  Reads instruction from memory
  Handles PC advancement
  Manages instruction boundaries

Decode Unit:
  Parses instruction encoding
  Extracts opcode, registers, immediates
  Determines instruction type

Execute Unit:
  Performs operation
  Computes results
  Handles special cases

State Manager:
  Maintains registers
  Interfaces with memory
  Tracks program counter

Trace Recorder:
  Captures execution state
  Formats for witness generation
  Buffers trace data
```

### Execution Loop

Main interpreter cycle:

```
def interpret(program, input):
  # Initialize
  pc = entry_point
  registers = [0] * 32
  memory = initialize_memory(program, input)
  trace = []

  while not halted:
    # Fetch
    instruction = memory.fetch_instruction(pc)

    # Decode
    decoded = decode(instruction)

    # Execute
    result = execute(decoded, registers, memory)

    # Record
    trace.append(create_trace_row(pc, instruction, decoded, result))

    # Update
    registers = update_registers(decoded, result)
    pc = update_pc(decoded, result)

  return trace, output
```

### Instruction Handler

Per-instruction execution:

```
def execute(decoded, registers, memory):
  op = decoded.opcode
  rs1_val = registers[decoded.rs1]
  rs2_val = registers[decoded.rs2]
  imm = decoded.immediate

  if op == ADD:
    return rs1_val + rs2_val
  elif op == SUB:
    return rs1_val - rs2_val
  elif op == LW:
    addr = rs1_val + imm
    return memory.read_word(addr)
  elif op == SW:
    addr = rs1_val + imm
    memory.write_word(addr, rs2_val)
    return None
  # ... other operations
```

## Instruction Decoding

### Decode Function

Parsing instruction bits:

```
def decode(instruction):
  opcode = instruction & 0x7F
  rd = (instruction >> 7) & 0x1F
  funct3 = (instruction >> 12) & 0x7
  rs1 = (instruction >> 15) & 0x1F
  rs2 = (instruction >> 20) & 0x1F
  funct7 = (instruction >> 25) & 0x7F

  # Determine format and extract immediate
  format = get_format(opcode)
  immediate = extract_immediate(instruction, format)

  return DecodedInstruction(
    opcode=opcode, rd=rd, rs1=rs1, rs2=rs2,
    funct3=funct3, funct7=funct7,
    immediate=immediate, format=format
  )
```

### Immediate Extraction

Format-specific immediate handling:

```
def extract_immediate(instruction, format):
  if format == I_TYPE:
    imm = instruction >> 20
    return sign_extend(imm, 12)

  elif format == S_TYPE:
    imm_lo = (instruction >> 7) & 0x1F
    imm_hi = instruction >> 25
    imm = (imm_hi << 5) | imm_lo
    return sign_extend(imm, 12)

  elif format == B_TYPE:
    imm_12 = (instruction >> 31) & 0x1
    imm_10_5 = (instruction >> 25) & 0x3F
    imm_4_1 = (instruction >> 8) & 0xF
    imm_11 = (instruction >> 7) & 0x1
    imm = (imm_12 << 12) | (imm_11 << 11) | (imm_10_5 << 5) | (imm_4_1 << 1)
    return sign_extend(imm, 13)

  # ... U and J types
```

### Operation Lookup

Mapping to operation type:

```
def get_operation(opcode, funct3, funct7):
  key = (opcode, funct3, funct7)

  OPERATION_TABLE = {
    (0x33, 0x0, 0x00): ADD,
    (0x33, 0x0, 0x20): SUB,
    (0x33, 0x7, 0x00): AND,
    (0x33, 0x6, 0x00): OR,
    (0x33, 0x4, 0x00): XOR,
    (0x33, 0x1, 0x00): SLL,
    (0x33, 0x5, 0x00): SRL,
    (0x33, 0x5, 0x20): SRA,
    (0x13, 0x0, None): ADDI,  # funct7 is part of immediate
    # ... more entries
  }

  return OPERATION_TABLE.get(key, UNKNOWN)
```

## State Management

### Register File

Managing 32 registers:

```
class RegisterFile:
  def __init__(self):
    self.regs = [0] * 32

  def read(self, index):
    if index == 0:
      return 0
    return self.regs[index]

  def write(self, index, value):
    if index != 0:
      self.regs[index] = value & ((1 << 64) - 1)  # Mask to 64 bits

  def snapshot(self):
    return self.regs.copy()
```

### Memory System

Memory interface:

```
class Memory:
  def __init__(self, size):
    self.data = bytearray(size)
    self.access_log = []

  def read_byte(self, addr):
    self.access_log.append((addr, self.data[addr], 'read'))
    return self.data[addr]

  def write_byte(self, addr, value):
    self.data[addr] = value & 0xFF
    self.access_log.append((addr, value & 0xFF, 'write'))

  def read_word(self, addr):
    # Read 4 bytes, combine
    bytes = [self.read_byte(addr + i) for i in range(4)]
    return bytes[0] | (bytes[1] << 8) | (bytes[2] << 16) | (bytes[3] << 24)

  def write_word(self, addr, value):
    for i in range(4):
      self.write_byte(addr + i, (value >> (i * 8)) & 0xFF)
```

### Program Counter

PC management:

```
class ProgramCounter:
  def __init__(self, initial):
    self.value = initial
    self.history = [initial]

  def advance(self, size=4):
    self.value += size
    self.history.append(self.value)

  def branch(self, target):
    self.value = target
    self.history.append(self.value)

  def get(self):
    return self.value
```

## Trace Recording

### Trace Row Creation

Capturing execution state:

```
def create_trace_row(pc, instruction, decoded, result, regs, memory_ops):
  return TraceRow(
    # Primary
    cycle=current_cycle,
    pc=pc,
    instruction=instruction,

    # Decoded
    opcode=decoded.opcode,
    rd_idx=decoded.rd,
    rs1_idx=decoded.rs1,
    rs2_idx=decoded.rs2,

    # Values
    rs1_val=regs.read(decoded.rs1),
    rs2_val=regs.read(decoded.rs2),
    immediate=decoded.immediate,

    # Result
    result=result,

    # Memory
    memory_ops=memory_ops
  )
```

### Efficient Recording

Minimizing trace overhead:

```
Buffer rows:
  Batch trace rows before writing
  Reduce I/O frequency

Lazy fields:
  Compute derived fields later
  Store minimal during execution

Streaming output:
  Write to disk as generated
  Don't hold full trace in memory
```

## Execution Handlers

### ALU Operations

Arithmetic and logic:

```
def execute_alu(op, a, b):
  if op == ADD:
    return a + b
  elif op == SUB:
    return a - b
  elif op == AND:
    return a & b
  elif op == OR:
    return a | b
  elif op == XOR:
    return a ^ b
  elif op == SLL:
    return (a << (b & 0x3F)) & ((1 << 64) - 1)
  elif op == SRL:
    return a >> (b & 0x3F)
  elif op == SRA:
    # Arithmetic right shift
    if a & (1 << 63):  # Negative
      return ((a >> (b & 0x3F)) | (~((1 << (64 - (b & 0x3F))) - 1)))
    else:
      return a >> (b & 0x3F)
```

### Memory Operations

Load and store:

```
def execute_load(op, base, offset, memory):
  addr = base + offset

  if op == LB:
    val = memory.read_byte(addr)
    return sign_extend(val, 8)
  elif op == LBU:
    return memory.read_byte(addr)
  elif op == LW:
    val = memory.read_word(addr)
    return sign_extend(val, 32)
  # ... other sizes

def execute_store(op, base, offset, value, memory):
  addr = base + offset

  if op == SB:
    memory.write_byte(addr, value & 0xFF)
  elif op == SW:
    memory.write_word(addr, value & 0xFFFFFFFF)
  # ... other sizes
```

### Branch Operations

Conditional control flow:

```
def execute_branch(op, a, b, pc, offset):
  taken = False

  if op == BEQ:
    taken = (a == b)
  elif op == BNE:
    taken = (a != b)
  elif op == BLT:
    taken = (signed(a) < signed(b))
  elif op == BGE:
    taken = (signed(a) >= signed(b))
  elif op == BLTU:
    taken = (a < b)
  elif op == BGEU:
    taken = (a >= b)

  return (pc + offset) if taken else (pc + 4), taken
```

## Performance Optimization

### Dispatch Optimization

Fast instruction dispatch:

```
Switch-based dispatch:
  Large switch statement
  Compiler optimizes to jump table

Function table:
  handlers = [handle_add, handle_sub, ...]
  handlers[op_code](args)

Threaded code:
  Direct threading for hot paths
  Reduce dispatch overhead
```

### State Caching

Reducing indirection:

```
Cache hot values:
  Local variables for PC, common registers
  Reduce memory access

Inline operations:
  Inline small functions
  Avoid call overhead
```

## Key Concepts

- **Interpreter**: Program that executes instructions
- **Fetch-decode-execute**: Classic instruction cycle
- **State management**: Registers, memory, PC
- **Trace recording**: Capturing execution for proving
- **Dispatch**: Routing to instruction handlers

## Design Considerations

### Speed vs Tracing

| Fast Interpreter | Tracing Interpreter |
|------------------|---------------------|
| Minimal overhead | Recording overhead |
| No trace output | Full trace capture |
| For normal execution | For zkVM proving |
| Optimized dispatch | Instrumented dispatch |

### State Representation

| Direct State | Logged State |
|--------------|--------------|
| Current values only | Full history |
| Lower memory | Higher memory |
| No replay | Replayable |
| Faster | Slower |

## Related Topics

- [State Caching](02-state-caching.md) - Performance optimization
- [Execution Trace Generation](../01-witness-generation/01-execution-trace-generation.md) - Trace output
- [Instruction Set Support](../../06-emulation-layer/01-risc-v-emulation/01-instruction-set-support.md) - Supported instructions
- [Register Emulation](../../06-emulation-layer/01-risc-v-emulation/02-register-emulation.md) - Register details
