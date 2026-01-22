# Error Handling

## Overview

Error handling in the prover runtime addresses failures that occur during witness generation and proof construction. Unlike the program being proven (which has its own exception handling), prover errors indicate problems with the proving process itself: out-of-memory conditions, constraint violations, numerical issues, or system failures. Robust error handling enables diagnosis, recovery, and graceful degradation.

Prover errors fall into several categories: resource exhaustion (memory, time), constraint satisfaction failures (bugs in witness generation), and system errors (I/O failures, hardware problems). Each requires different handling strategies. This document covers error types, detection mechanisms, handling strategies, and recovery options for the prover runtime.

## Error Categories

### Resource Errors

Exhausting available resources:

```
Out of memory:
  Trace too large
  Insufficient system RAM
  Memory leak

Timeout:
  Proving takes too long
  Deadlock or infinite loop
  Underestimated complexity

Disk space:
  Temporary files exhausted
  Output file can't be written
  Log files full
```

### Constraint Errors

Proof-related failures:

```
Constraint violation:
  Witness doesn't satisfy constraints
  Bug in witness generation
  Trace corruption

Invalid witness:
  Values out of range
  Inconsistent state
  Missing columns

Polynomial error:
  Division by zero polynomial
  Degree overflow
  Domain mismatch
```

### System Errors

Infrastructure failures:

```
I/O error:
  File read/write failure
  Network error (distributed)
  Disk corruption

Hardware error:
  CPU/GPU failure
  Memory corruption (bit flip)
  Power interruption

Software error:
  Library bug
  Assertion failure
  Undefined behavior
```

### Input Errors

Invalid inputs to prover:

```
Invalid program:
  Malformed binary
  Unsupported instructions
  Missing entry point

Invalid input data:
  Wrong format
  Size mismatch
  Encoding error

Configuration error:
  Invalid parameters
  Incompatible options
  Missing configuration
```

## Error Detection

### Pre-Flight Checks

Catching errors early:

```
Before execution:
  Check program validity
  Verify input format
  Estimate memory requirements

Before proving:
  Verify trace dimensions
  Check column types
  Validate auxiliary values

def preflight_check(program, input, config):
  if not is_valid_elf(program):
    raise InvalidProgramError("Malformed ELF")

  mem_required = estimate_memory(program, input)
  if mem_required > available_memory():
    raise ResourceError(f"Need {mem_required}, have {available_memory()}")

  # ... more checks
```

### Runtime Detection

Catching errors during execution:

```
Constraint checking:
  Periodically evaluate constraints
  Detect violations early
  Stop before wasted work

Resource monitoring:
  Track memory usage
  Monitor elapsed time
  Check disk space

def prove_with_monitoring(trace):
  for row in trace:
    if memory_usage() > threshold:
      raise MemoryError("Memory limit exceeded")

    if elapsed_time() > timeout:
      raise TimeoutError("Proving timeout")

    # Continue proving
```

### Post-Verification

Checking results:

```
After proof generation:
  Verify proof locally
  Check output format
  Validate commitments

def finalize_proof(proof):
  if not verify_proof(proof):
    raise ProofError("Generated proof is invalid")

  if not valid_format(proof):
    raise FormatError("Proof format invalid")

  return proof
```

## Error Handling Strategies

### Fail Fast

Stopping immediately on error:

```
Philosophy:
  Don't waste resources on doomed proof
  Report error quickly
  Preserve error context

Implementation:
  Exception on first error
  No recovery attempt
  Log and exit

if not constraint_satisfied(row):
  raise ConstraintError(f"Constraint failed at row {row.index}")
```

### Graceful Degradation

Continuing with reduced capability:

```
Philosophy:
  Try to produce something useful
  Degrade quality rather than fail
  Complete if possible

Implementation:
  Catch non-fatal errors
  Adjust parameters
  Log warnings

try:
  result = optimized_proof()
except MemoryError:
  logging.warning("Falling back to low-memory mode")
  result = low_memory_proof()
```

### Retry with Backoff

Retrying transient failures:

```
Philosophy:
  Some errors are transient
  Retry may succeed
  Limit retry attempts

Implementation:
  Exponential backoff
  Maximum retries
  Different strategies per error type

def prove_with_retry(trace, max_retries=3):
  for attempt in range(max_retries):
    try:
      return generate_proof(trace)
    except TransientError as e:
      wait_time = 2 ** attempt
      logging.warning(f"Attempt {attempt} failed, retrying in {wait_time}s")
      time.sleep(wait_time)
  raise ProofError("All retries exhausted")
```

### Checkpoint and Resume

Saving progress for recovery:

```
Philosophy:
  Long proofs should be resumable
  Don't lose partial work
  Enable recovery from crashes

Implementation:
  Periodic checkpoints
  Resume from checkpoint
  Verify checkpoint integrity

def prove_with_checkpoints(trace, checkpoint_interval=1000):
  for i, segment in enumerate(trace.segments()):
    prove_segment(segment)

    if i % checkpoint_interval == 0:
      save_checkpoint(i, current_state)

  return finalize()

def resume_from_checkpoint(checkpoint_file):
  state = load_checkpoint(checkpoint_file)
  return continue_proving(state)
```

## Error Reporting

### Error Context

Providing useful information:

```
Context includes:
  Error type and code
  Location (phase, row, column)
  Relevant values
  Stack trace

class ProverError(Exception):
  def __init__(self, message, context=None):
    self.message = message
    self.context = context or {}
    self.timestamp = time.time()

  def __str__(self):
    return f"{self.message}\nContext: {self.context}"

raise ConstraintError(
  "Division by zero",
  context={
    "phase": "constraint_evaluation",
    "row": 12345,
    "column": "divisor",
    "value": 0
  }
)
```

### Logging

Recording error information:

```
Log levels:
  ERROR: Failures requiring attention
  WARNING: Potential issues
  INFO: Progress information
  DEBUG: Detailed diagnostics

Structure:
  Timestamp, level, component, message
  Structured data for parsing
  Correlation IDs for tracing

logging.error(
  "Constraint violation",
  extra={
    "row": row_index,
    "constraint": constraint_name,
    "expected": 0,
    "actual": computed_value
  }
)
```

### Error Codes

Standardized error identification:

```
Error code structure:
  Category (2 digits)
  Specific error (3 digits)

Categories:
  10xxx: Resource errors
  20xxx: Constraint errors
  30xxx: System errors
  40xxx: Input errors

Example codes:
  10001: Out of memory
  10002: Timeout
  20001: Constraint violation
  20002: Invalid witness
  30001: I/O error
  40001: Invalid program
```

## Recovery Mechanisms

### Partial Results

Saving what's possible:

```
When proof fails:
  Save execution trace
  Save partial proof
  Record failure point

Usage:
  Debug with partial data
  Retry from failure point
  Analyze failure cause
```

### Rollback

Reverting to known state:

```
On error during phase:
  Rollback to phase start
  Retry with different parameters
  Or report phase failure

Transaction-like:
  Begin phase
  On error: Rollback
  On success: Commit
```

### Cleanup

Resource release on error:

```
Ensure cleanup:
  Free allocated memory
  Close file handles
  Release locks

Implementation:
  RAII in C++
  Context managers in Python
  Finally blocks

try:
  buffer = allocate_large_buffer()
  # ... use buffer
finally:
  free_buffer(buffer)
```

## Key Concepts

- **Error category**: Type of failure (resource, constraint, system, input)
- **Detection**: Identifying when errors occur
- **Handling strategy**: How to respond to errors
- **Error context**: Information about the failure
- **Recovery**: Continuing or resuming after error

## Design Considerations

### Error Philosophy

| Fail Fast | Resilient |
|-----------|-----------|
| Stop on first error | Try to recover |
| Simple | Complex |
| Clear failure | May hide issues |
| Easier debugging | Better uptime |

### Error Granularity

| Coarse Errors | Fine Errors |
|---------------|-------------|
| Few error types | Many error types |
| Simple handling | Precise handling |
| Less information | More information |
| Easier API | Complex API |

## Related Topics

- [Proof Generation Pipeline](01-proof-generation-pipeline.md) - Where errors occur
- [Memory Management](02-memory-management.md) - Resource errors
- [Exception Handling](../../06-emulation-layer/02-system-emulation/03-exception-handling.md) - Program exceptions
- [Distributed Proving](../../08-distributed-proving/01-distributed-architecture/02-work-distribution.md) - Distributed errors
