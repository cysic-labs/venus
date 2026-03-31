# Spec: Complete Rust PK Generation Pipeline

## Goal
Replace all JavaScript in the proving key generation pipeline with Rust. The result must:
1. `make clean && rm -rf build/provingKey && make setup && make prove && make verify` passes
2. PK generation completes in 10-30 minutes (from 1.5 hours with JS)
3. Peak memory under 90GB (from 100+GB with JS)
4. No prove-time regression (small block <=24s, large block <=97s)
5. No cryptographic soundness regression

## Current State
- 3 Rust crates implemented: pil2-compiler-rust, pil2-stark-setup, stark-recurser-rust
- Makefile uses Rust binaries exclusively (pil2c, venus-setup)
- JS code removed from codebase (references kept in temp/references/)
- 25/35 AIRs produce byte-identical output to golden reference
- 34/35 AIRs complete non-recursive setup (Poseidon2 stalls)
- Prove/verify confirmed working (24s prove, 42ms verify) with golden keys
- 91/95 pil2-stark-setup tests pass (4 pre-existing failures)

## Remaining Work

### P0: Poseidon2 Codegen Performance (Critical Blocker)
**Root cause identified**: `fix_eval()` in codegen.rs performs O(|ev_map|) linear search per code entry. For Poseidon2 (31,554 code entries, 182 ev_map entries), this is 5.7M comparisons.

**Fix**: Build a HashMap index for ev_map keyed by (type, id, opening_pos) for O(1) lookup. Expected: 20min -> seconds.

### P1: 4 Failing Unit Tests
- fri_poly: 2 tests fail (fri_exp_id boundary)
- map: 1 test fails (empty expressions index)
- prepare_pil: 1 test fails (degree mismatch in test data)

These are test-data issues, not production logic bugs. Fix test expectations or test data.

### P2: End-to-End Validation
Run the full pipeline: `make clean && rm -rf build/provingKey && make setup && make prove && make verify`
- Small block (default INPUT)
- Large block (mainnet_24628590_478_49_zec_reth.bin)
- Record timing and peak memory

### P3: Compiler Parity for Remaining 10 AIRs
10 AIRs have different starkinfo/expressionsinfo from golden:
- ArithEq, ArithEq384, Blake2br, Sha256f, Keccakf, Rom
- SpecifiedRanges, VirtualTable0, VirtualTable1, Poseidon2

**Approach**: These diffs come from the Rust compiler (pil2c) producing different expression structures than JS. Rather than achieving byte-identical output, validate that:
1. The Rust-generated proving keys produce valid proofs
2. Prove/verify passes end-to-end
3. A soundness review confirms no security regression

If prove/verify passes, the expression structure differences are acceptable per user requirements.

### P4: Soundness Review
Audit the Rust implementation against the JS reference for any changes that could affect cryptographic soundness:
- FRI security parameters
- Constraint polynomial construction
- Merkle tree computation
- Opening point handling

## Architecture

### Pipeline Flow
```
make generate-key:
  1. cargo run --bin arith_frops_fixed_gen     (existing Rust)
  2. cargo run --bin binary_basic_frops_fixed_gen
  3. cargo run --bin binary_extension_frops_fixed_gen
  4. cargo run --bin pil2c                     (Rust compiler)
  5. cargo run --bin venus-setup               (Rust setup, parallel)
     - write_global_info (before AIR loop)
     - par_iter over 35 AIRs: pil_info -> security -> starkinfo/expr/verifier JSON -> bctree -> bin files
     - recursive setup if -r flag (circom compilation, witness libs)

make setup:
  6. cargo build --release --features gpu      (builds cargo-zisk)
  7. cargo-zisk rom-setup                      (ROM witness + Merkle)
  8. cargo-zisk check-setup                    (validation)
  9. cargo-zisk check-setup -a                 (aggregation validation)

make prove:
  10. cargo-zisk prove                         (GPU-accelerated)

make verify:
  11. cargo-zisk verify                        (CPU verification)
```

### Performance Budget
| Step | Current | Target | Notes |
|------|---------|--------|-------|
| Fixed generators | ~20s | ~20s | Already fast |
| PIL compiler (pil2c) | ~3.5min | ~3.5min | Acceptable |
| Non-recursive setup | ~90s (34 AIRs) | <2min (35 AIRs) | Poseidon2 fix needed |
| Recursive setup | ~30-60min | <15min | Circom compilation dominated |
| ROM setup + check | ~2min | ~2min | Already fast |
| **Total** | **~40-65min** | **<25min** | |

### Key Design Decisions
1. **Rayon parallelism**: All 35 AIRs processed concurrently via par_iter
2. **Arc for shared state**: witness_by_exp_id uses Arc instead of clone
3. **Move semantics**: calculated and ev_map use std::mem::take (zero-cost)
4. **Fail-fast recursive**: All recursive error paths propagate immediately
5. **Global files first**: pilout.globalInfo.json written before AIR loop

## Acceptance Criteria
1. `make clean && rm -rf build/provingKey && make setup && make prove && make verify` passes (small block)
2. Large block prove also passes without regression
3. Total PK generation time < 30 minutes
4. Peak memory < 90GB
5. All pil2-stark-setup tests pass (fix the 4 failing ones)
6. Soundness review completed (no security regression)
