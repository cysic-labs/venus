# Testing and Debugging

## Overview

Testing and debugging zkVM programs requires strategies adapted to the proving environment. Programs must be correct both in execution logic and in the constraints they generate. A program that produces the right answer but violates constraints will fail to prove. Testing at multiple levels—unit, integration, and proof—catches different categories of bugs and builds confidence in program correctness.

Debugging zkVM programs can be challenging because the proving process abstracts away execution details. When proving fails, understanding whether the issue is in program logic, witness generation, or constraint design requires systematic investigation. This document covers testing strategies, debugging techniques, and tools for zkVM program development.

## Testing Levels

### Unit Testing

Testing individual functions:

```
Purpose:
  Verify function correctness
  Test edge cases
  Fast feedback

Environment:
  Can run on host (non-zkVM)
  Standard test framework
  Mocked I/O

Example:
  #[test]
  fn test_compute_hash() {
    let input = [1, 2, 3];
    let expected = known_hash(&input);
    let actual = compute_hash(&input);
    assert_eq!(actual, expected);
  }
```

### Integration Testing

Testing complete programs:

```
Purpose:
  End-to-end execution
  I/O handling
  Full program flow

Environment:
  Execute in zkVM emulator
  Real inputs and outputs
  No actual proving

Example:
  #[test]
  fn test_program_execution() {
    let input = prepare_input();
    let output = execute_in_emulator(program, input);
    assert_eq!(output, expected_output);
  }
```

### Proof Testing

Testing that proofs verify:

```
Purpose:
  Verify constraint satisfaction
  Complete proof generation
  Proof verification

Environment:
  Full proving pipeline
  Real proof generation
  Verification check

Example:
  #[test]
  fn test_proof_generation() {
    let input = prepare_input();
    let proof = prove(program, input);
    assert!(verify(&proof));
  }
```

## Testing Strategies

### Input Coverage

Testing with diverse inputs:

```
Categories:
  Normal inputs: Typical cases
  Edge cases: Boundaries, empty
  Invalid inputs: Error handling
  Large inputs: Scale testing

Techniques:
  Boundary value analysis
  Equivalence partitioning
  Random/fuzz testing
```

### Property-Based Testing

Testing invariants:

```
Properties:
  "For all valid inputs, output is valid"
  "Computation is deterministic"
  "Constraints are satisfied"

Tools:
  QuickCheck, proptest
  Generate random inputs
  Check property holds

Example:
  proptest! {
    #[test]
    fn test_hash_determinism(input in any::<Vec<u8>>()) {
      let h1 = compute_hash(&input);
      let h2 = compute_hash(&input);
      assert_eq!(h1, h2);
    }
  }
```

### Regression Testing

Preventing recurrence:

```
Practice:
  Save failing inputs
  Add to test suite
  Run on changes

Automation:
  CI/CD integration
  Automatic on commit
  Block on failure
```

## Debugging Techniques

### Execution Tracing

Following program flow:

```
Trace output:
  Log key values during execution
  Record state at checkpoints
  Compare expected vs actual

In zkVM:
  Debug builds with logging
  Trace written to output
  Analyze after execution
```

### Constraint Checking

Finding constraint violations:

```
Pre-proving check:
  Evaluate constraints on witness
  Find which constraint fails
  Identify problematic row

Tools:
  Constraint evaluator
  Row-by-row analysis
  Column value inspection
```

### Bisection

Finding the failing point:

```
Method:
  Reduce input/program size
  Binary search for failure
  Isolate minimal failing case

Application:
  Long execution fails: Find failing segment
  Complex logic fails: Find failing function
  Input causes failure: Find failing input part
```

### Differential Testing

Comparing implementations:

```
Method:
  Run same input on two implementations
  Compare outputs
  Investigate differences

Implementations:
  zkVM vs native execution
  Different zkVM versions
  Reference implementation
```

## Common Bugs

### Constraint Mismatches

When execution differs from constraints:

```
Symptoms:
  Proof generation fails
  Constraint evaluation fails
  Verifier rejects

Causes:
  Witness generation bug
  Constraint encoding error
  Mismatched assumptions

Fix:
  Check witness values
  Verify constraint logic
  Align execution and constraints
```

### Memory Errors

Memory access issues:

```
Symptoms:
  Wrong values loaded
  Memory consistency failure
  Address out of range

Causes:
  Buffer overflow
  Uninitialized memory
  Address calculation error

Fix:
  Check array bounds
  Initialize memory
  Validate addresses
```

### Overflow Errors

Arithmetic overflow:

```
Symptoms:
  Wrong computation result
  Wrap-around behavior
  Constraint failure

Causes:
  Multiplication overflow
  Addition overflow
  Cast truncation

Fix:
  Use wider types
  Check for overflow
  Validate ranges
```

### Determinism Issues

Non-deterministic behavior:

```
Symptoms:
  Different outputs for same input
  Proof verification fails
  Unreproducible behavior

Causes:
  Uninitialized variables
  Random without seed
  Floating-point differences

Fix:
  Initialize all variables
  Remove randomness
  Use exact arithmetic
```

## Debugging Tools

### Emulator Debugging

Using emulator features:

```
Capabilities:
  Step-by-step execution
  Register/memory inspection
  Breakpoints

Usage:
  Set breakpoint at suspect location
  Inspect state
  Compare with expected
```

### Trace Inspection

Analyzing execution traces:

```
Trace contents:
  Instruction sequence
  Register values
  Memory operations

Analysis:
  Search for unexpected values
  Compare with expected trace
  Find divergence point
```

### Constraint Profiling

Understanding constraint costs:

```
Metrics:
  Constraints per operation
  Total constraint count
  Constraint type distribution

Usage:
  Identify expensive operations
  Optimize hot spots
  Verify improvements
```

## Test Infrastructure

### CI/CD Integration

Automated testing:

```
Pipeline:
  Compile for zkVM
  Run unit tests (native)
  Run integration tests (emulator)
  Run proof tests (proving)

Configuration:
  On every commit
  Nightly full tests
  Pre-release proof tests
```

### Test Fixtures

Reusable test data:

```
Fixtures:
  Standard inputs
  Expected outputs
  Known-good proofs

Organization:
  Separate test data directory
  Version controlled
  Generated or curated
```

### Performance Benchmarks

Tracking proving performance:

```
Metrics:
  Execution time
  Proving time
  Proof size

Tracking:
  Baseline measurements
  Track over time
  Alert on regression
```

## Key Concepts

- **Testing levels**: Unit, integration, proof testing
- **Property-based testing**: Checking invariants
- **Constraint checking**: Finding constraint violations
- **Bisection**: Narrowing down failures
- **Differential testing**: Comparing implementations

## Design Considerations

### Testing Trade-offs

| Fast Tests | Thorough Tests |
|------------|----------------|
| Quick feedback | Complete coverage |
| Limited scope | Full proof |
| Many iterations | Fewer iterations |
| Development time | Release validation |

### Debug Information

| Debug Build | Release Build |
|-------------|---------------|
| More logging | Minimal logging |
| Slower | Faster |
| Easier debugging | Production ready |
| Larger binary | Smaller binary |

## Related Topics

- [Program Structure](01-program-structure.md) - Basic patterns
- [Constraint-Aware Programming](02-constraint-aware-programming.md) - Optimization
- [Error Handling](../../07-runtime-system/03-prover-runtime/03-error-handling.md) - Error patterns
- [Execution Trace Generation](../../07-runtime-system/01-witness-generation/01-execution-trace-generation.md) - Trace details
