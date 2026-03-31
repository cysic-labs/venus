# Master Plan: Complete Rust PK Generation Pipeline

## Stages and Dependencies

```
Stage 1: Fix Poseidon2 Codegen (P0)
    └── plan-fix-poseidon2.md
    
Stage 2: E2E Validation + Soundness (P1+P2)
    ├── plan-e2e-validation.md
    └── depends on: Stage 1 (all 35 AIRs must complete)
    
Stage 3: Compiler Parity (Conditional P3)
    ├── plan-compiler-parity.md (only if Stage 2 reveals failures)
    └── depends on: Stage 2 results
    
Stage 4: Test Hardening (P4)
    ├── plan-test-cleanup.md
    └── depends on: Stage 2 passes
```

## Parallelism
- Stage 1 is a single focused fix (no parallelism needed)
- Stage 2 sub-tasks can run sequentially (setup then prove then verify)
- Stage 3 may be skipped entirely if prove/verify passes
- Stage 4 is independent cleanup

## Milestones
- M1: Poseidon2 completes setup in <5 minutes → 35/35 AIRs
- M2: `make clean && rm -rf build/provingKey && make setup && make prove && make verify` passes (small block)
- M3: Large block prove passes without regression
- M4: Total PK gen time < 30 minutes
- M5: Soundness review completed
- M6: All tests pass (optional cleanup)

## Stage Checkpoint Protocol
After each stage, verify locally and invoke Codex review before proceeding.
