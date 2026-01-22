# Exception Handling

## Overview

Exception handling manages abnormal conditions that arise during program execution. When an invalid instruction is encountered, memory access fails, or an arithmetic error occurs, the zkVM must handle the exception in a defined, provable manner. Unlike traditional processors that transfer control to operating system handlers, a zkVM typically terminates execution with an error code or triggers a program-level handler.

The exception model affects both correctness and security. Exceptions must be detected reliably—missing a division by zero would produce incorrect proofs. Exception handling must be deterministic—the same error condition must always produce the same result. This document covers exception types, detection mechanisms, handling strategies, and constraint patterns for exception-safe execution.

## Exception Categories

### Instruction Exceptions

Invalid instruction conditions:

```
Illegal instruction:
  Unrecognized opcode
  Invalid encoding
  Unsupported extension

Examples:
  Opcode not in instruction set
  funct3/funct7 combination undefined
  Reserved bits nonzero

Exception code: 2 (Illegal instruction)
```

### Memory Exceptions

Memory access failures:

```
Load address misaligned:
  Unaligned address for access size
  Exception code: 4

Load access fault:
  Address out of valid range
  Permission violation
  Exception code: 5

Store address misaligned:
  Unaligned store address
  Exception code: 6

Store access fault:
  Invalid store address
  Write to read-only memory
  Exception code: 7
```

### Arithmetic Exceptions

Computation errors:

```
Division by zero:
  DIV or REM with divisor = 0
  RISC-V: Returns defined value (not exception)
  zkVM may choose to exception

Overflow:
  Signed arithmetic overflow
  RISC-V: Wraps (no exception)
  zkVM typically follows RISC-V

Note: RISC-V defines results for edge cases
      rather than raising exceptions
```

### Environment Exceptions

System-level conditions:

```
Environment call (ECALL):
  Not an error, but transfers control
  Exception code: 8 (from U-mode)
  Handled as system call

Breakpoint (EBREAK):
  Debug breakpoint
  Exception code: 3
  Typically terminates or ignores
```

## Detection Mechanisms

### Instruction Validation

Checking instruction legality:

```
Decode-time checks:
  Opcode in valid set
  funct3 valid for opcode
  funct7 valid for opcode/funct3

Table-based:
  (opcode, funct3, funct7) in valid_instruction_table
  If not in table: illegal instruction

Constraint:
  is_valid_instruction = lookup succeeds
  !is_valid_instruction implies exception
```

### Address Validation

Checking memory access:

```
Range check:
  addr >= VALID_MEM_START
  addr < VALID_MEM_END

Alignment check:
  (access_size == 2) implies addr[0] == 0
  (access_size == 4) implies addr[1:0] == 0
  (access_size == 8) implies addr[2:0] == 0

Constraint:
  is_valid_addr = in_range AND aligned
  !is_valid_addr implies exception
```

### Arithmetic Validation

Checking computation validity:

```
Division by zero:
  is_div_by_zero = is_div_op AND (divisor == 0)

RISC-V behavior:
  DIV by zero: Returns -1 (all ones)
  DIVU by zero: Returns MAX_UINT
  REM by zero: Returns dividend
  REMU by zero: Returns dividend

Constraint:
  If following RISC-V: Set defined result
  If exception model: Trigger exception
```

## Handling Strategies

### Termination Model

Exception stops execution:

```
On exception:
  Halt execution immediately
  Record exception code
  Final state includes error

Proof includes:
  Exception occurred
  Exception type/code
  State at exception

Verification:
  Verifier sees execution ended with error
  Can determine failure reason
```

### Result Model

Exception returns error value:

```
On exception:
  Computation returns error code
  Execution may continue
  Error propagated to caller

Example:
  Division by zero returns MAX_INT
  Program checks and handles

RISC-V compatible:
  Follows RISC-V specification
  No actual exceptions for arithmetic
```

### Handler Model

Program-level handler:

```
On exception:
  Transfer to exception handler address
  Handler examines cause
  Handler decides action

Implementation:
  Exception cause in CSR (or equivalent)
  Handler address in mtvec (or equivalent)
  Complex but flexible
```

## Constraint Patterns

### Exception Detection Constraint

Identifying exception conditions:

```
Columns:
  is_exception: Exception detected
  exception_code: Type of exception

Detection constraints:
  is_illegal_inst = !valid_instruction
  is_load_misalign = is_load * !aligned
  is_store_fault = is_store * !valid_addr

Aggregation:
  is_exception = is_illegal_inst OR is_load_misalign OR ...

Code assignment:
  exception_code = 2 * is_illegal_inst +
                   4 * is_load_misalign +
                   ...
```

### Exception Handling Constraint

Responding to exceptions:

```
Termination model:
  is_exception implies:
    halted_next = 1
    exception_code recorded
    no further execution

Continuation model:
  is_exception implies:
    defined result assigned
    execution continues
    no side effects from failed operation
```

### State Preservation

Maintaining state on exception:

```
On exception:
  Registers unchanged (or partially updated)
  Memory unchanged (or consistent)
  PC points to faulting instruction

Constraint:
  is_exception implies:
    regs_next = regs_current (for termination)
    mem unchanged
    pc_next = pc_current (or handler)
```

## Error Propagation

### Error Codes

Standard exception codes:

```
RISC-V exception codes:
  0: Instruction address misaligned
  1: Instruction access fault
  2: Illegal instruction
  3: Breakpoint
  4: Load address misaligned
  5: Load access fault
  6: Store address misaligned
  7: Store access fault
  8: Environment call from U-mode
  ...

zkVM may use subset:
  Focus on likely errors
  Omit unused codes
```

### Error Context

Information about the error:

```
Exception context:
  exception_code: What happened
  exception_pc: Where it happened
  exception_value: Related value (e.g., bad address)

In proof:
  Context recorded for verification
  Helpful for debugging
  Not always needed by verifier
```

### Error Recovery

Options after exception:

```
Terminate:
  No recovery
  Proof shows error
  Most common approach

Retry:
  Fix condition
  Re-execute instruction
  Rare in zkVM

Skip:
  Continue past error
  Potentially dangerous
  Only for specific cases
```

## Exception-Safe Execution

### Atomic Operations

All-or-nothing semantics:

```
Instruction execution:
  Either completes fully
  Or has no effect (exception)

Constraint:
  is_exception implies no state change
  !is_exception implies normal state change

Memory stores:
  Check validity before storing
  Exception prevents store
```

### Consistent State

Maintaining invariants:

```
Invariants:
  x0 always zero
  Valid memory ranges
  PC alignment

On exception:
  Invariants preserved
  State consistent
  Can report error
```

## Key Concepts

- **Exception**: Abnormal condition during execution
- **Exception code**: Numeric identifier for exception type
- **Detection**: Recognizing exception conditions
- **Handling**: Response to exception
- **Termination**: Ending execution on exception

## Design Considerations

### Exception Model

| Termination | Continuation |
|-------------|--------------|
| Simple | Complex |
| Clear failure | Graceful handling |
| Easy to prove | More constraints |
| Less flexible | More flexible |

### RISC-V Compatibility

| Strict RISC-V | Simplified |
|---------------|------------|
| All edge cases | Common cases |
| More complex | Simpler |
| Higher compatibility | Lower compatibility |
| More constraints | Fewer constraints |

## Related Topics

- [System Calls](01-system-calls.md) - ECALL handling
- [I/O Handling](02-io-handling.md) - I/O errors
- [Instruction Set Support](../01-risc-v-emulation/01-instruction-set-support.md) - Valid instructions
- [Memory Emulation](../01-risc-v-emulation/03-memory-emulation.md) - Memory faults
