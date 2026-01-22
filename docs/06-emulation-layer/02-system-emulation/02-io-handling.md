# I/O Handling

## Overview

I/O handling manages the flow of data between the proven program and the external world. In a zkVM, input data must be committed in a way that the verifier can check, and output data must be cryptographically bound to the execution. This creates a provable record: given these inputs, the program produced these outputs.

The I/O model differs fundamentally from traditional systems. There's no filesystem, network, or interactive terminals. Instead, input is provided as a fixed stream before execution begins, and output is collected as execution proceeds. The prover knows all inputs; the verifier knows public inputs and can verify outputs. This document covers I/O architecture, stream management, commitment schemes, and integration patterns.

## I/O Architecture

### Input/Output Model

Fixed streams for I/O:

```
Input model:
  All input provided before execution
  No interactive input during execution
  Input treated as immutable tape

Output model:
  Output collected during execution
  Finalized after execution completes
  Output becomes part of proof

Determinism:
  Same input → Same output
  Reproducible execution
  Verifiable result
```

### Stream Types

Categories of I/O:

```
Public input:
  Known to both prover and verifier
  Part of statement being proven
  Example: Block header to verify

Private input:
  Known only to prover
  Enables selective disclosure
  Example: Secret key for signature

Public output:
  Verified output of execution
  Committed in proof
  Example: Execution result

Execution transcript:
  Internal I/O for debugging
  Not part of verification
```

### Data Flow

How data moves through system:

```
Input flow:
  Input stream → System call → Memory → Program

  1. Input prepared before execution
  2. Program requests via read()
  3. Data placed in memory buffer
  4. Program processes data

Output flow:
  Program → Memory → System call → Output stream

  1. Program computes result
  2. Result placed in buffer
  3. Program calls write()
  4. Data captured in output stream
```

## Input Handling

### Input Stream Structure

Organizing input data:

```
Stream layout:
  [length_1][data_1][length_2][data_2]...

Or simple concatenation:
  [all_data_bytes]

Program responsibility:
  Know expected format
  Parse appropriately
  Handle end-of-stream
```

### Read Operations

Processing read system calls:

```
read(fd, buf, count):
  1. Check fd is valid input stream
  2. Determine available bytes
  3. Copy min(count, available) to buf
  4. Advance stream position
  5. Return bytes read (or 0 for EOF)

Stream state:
  Current position in stream
  Total stream length
  Remaining bytes
```

### Input Commitment

Binding input to proof:

```
Public input commitment:
  hash(public_input_stream) = input_commitment
  input_commitment in public inputs

Verification:
  Verifier provides input_commitment
  Proof valid only for matching input

Private input:
  Not committed publicly
  Only prover knows content
  May be committed privately
```

### Input Validation

Ensuring correct input handling:

```
Constraint:
  Bytes read match stream content
  Stream position advances correctly
  No out-of-bounds reads

Memory consistency:
  Data written to correct addresses
  Byte values match stream

Determinism:
  Same stream position for same execution point
```

## Output Handling

### Output Stream Structure

Collecting output data:

```
Stream construction:
  Initially empty
  Grows with each write
  Finalized at program end

Stream content:
  Sequence of written bytes
  Order matches write operations
  May include metadata
```

### Write Operations

Processing write system calls:

```
write(fd, buf, count):
  1. Check fd is valid output stream
  2. Read count bytes from buf in memory
  3. Append to output stream
  4. Return count (bytes written)

Stream state:
  Current output length
  Output buffer content
```

### Output Commitment

Binding output to proof:

```
Output commitment:
  hash(output_stream) = output_commitment
  output_commitment in public outputs

Verification:
  Verifier receives output_commitment
  Can verify specific output if needed
  Proof includes output commitment

Reveal options:
  Full output: Reveal all bytes
  Commitment only: Just hash
  Selective: Merkle proof for parts
```

### Output Constraints

Proving correct output:

```
Constraint:
  Bytes in output stream match memory reads
  Write operations correctly append
  Final commitment matches stream

Order preservation:
  First write → First output bytes
  Sequence maintained
```

## Stream Management

### Stream Identification

File descriptor mapping:

```
Standard streams:
  fd 0 (stdin): Primary input stream
  fd 1 (stdout): Primary output stream
  fd 2 (stderr): Error output (may be same as stdout)

Additional streams:
  fd 3+: Additional I/O channels
  Each with own position/content

Constraint:
  fd used in syscall maps to correct stream
```

### Position Tracking

Stream state management:

```
Per-stream state:
  position: Current read/write position
  length: Total stream length (input) or current length (output)
  content: Stream data (or commitment)

State updates:
  read: position += bytes_read
  write: length += bytes_written

Constraint:
  Position/length updates consistent
  No position beyond length (input)
```

### End-of-Stream

Handling stream termination:

```
Input EOF:
  position == length
  Further reads return 0 bytes
  Program should handle gracefully

Output completion:
  Final stream state at program exit
  Commitment computed
  Included in proof
```

## Commitment Schemes

### Hash-Based Commitment

Simple commitment:

```
Commitment:
  C = H(stream_content)

Properties:
  Collision-resistant
  One-way
  Deterministic

Usage:
  input_hash = SHA256(input)
  output_hash = SHA256(output)
```

### Merkle Commitment

Tree-based for partial reveals:

```
Structure:
  Leaf: H(chunk_i) for each data chunk
  Interior: H(left_child || right_child)
  Root: Overall commitment

Partial reveal:
  Reveal specific chunks
  Provide Merkle path
  Verifier checks inclusion

Useful for:
  Large outputs
  Selective verification
  Efficient proofs of parts
```

### Incremental Commitment

Streaming commitment:

```
For output stream:
  Commit as data arrives
  No need to buffer all

Sponge construction:
  state = initial
  For each chunk: state = update(state, chunk)
  commitment = finalize(state)

Benefits:
  Constant memory
  Streaming operation
```

## Integration Patterns

### Program I/O Interface

How programs perform I/O:

```
Low-level:
  Assembly system calls
  Direct register manipulation

Library wrapper:
  read_input(buf, len)
  write_output(buf, len)
  Handles syscall details

High-level:
  serde for structured data
  Automatic serialization
```

### Prover I/O Interface

How prover provides I/O:

```
Input preparation:
  Serialize all inputs
  Compute commitment
  Provide to zkVM

Output collection:
  Capture all outputs
  Compute commitment
  Include in proof

API example:
  zkvm.set_input(input_bytes)
  proof = zkvm.prove(program)
  output = zkvm.get_output()
```

### Verifier I/O Interface

How verifier handles I/O:

```
Verification inputs:
  Public input commitment
  Expected output (or commitment)
  Proof

Verification:
  Check proof validity
  Confirm public inputs match
  Confirm output matches

API example:
  valid = verify(proof, public_inputs, output_commitment)
```

## Key Concepts

- **I/O stream**: Sequential data channel
- **Input commitment**: Hash binding input to proof
- **Output commitment**: Hash binding output to proof
- **Public vs private**: Visibility to verifier
- **Deterministic I/O**: Reproducible data flow

## Design Considerations

### Stream Model

| Fixed Streams | Dynamic Streams |
|---------------|-----------------|
| Simple fd mapping | File-like interface |
| Limited flexibility | More capabilities |
| Lower complexity | Higher complexity |
| Sufficient for most | For complex I/O |

### Commitment Granularity

| Full Hash | Merkle Tree |
|-----------|-------------|
| Simple | Complex |
| All-or-nothing | Partial reveals |
| Smaller proof | Larger structure |
| Common case | Special needs |

## Related Topics

- [System Calls](01-system-calls.md) - Syscall interface
- [Exception Handling](03-exception-handling.md) - Error cases
- [Memory Emulation](../01-risc-v-emulation/03-memory-emulation.md) - I/O buffers
- [Proof Verification](../../02-constraint-system/04-verification/01-verification-protocol.md) - Output verification
