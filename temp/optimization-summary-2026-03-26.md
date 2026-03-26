# Keccak-f Optimization Summary

Date: 2026-03-26

## Overall Baseline (before any optimization)
- Small block: 38.5s (first run), ~23s (warm)
- Large block: 96.2s

## Final Performance (after all work)
- No performance-improving changes retained
- All attempted optimizations either regressed or were infeasible
- Baseline performance preserved (both blocks pass prove + verify)

## Per-Task Breakdown

### Task 1: Profiling (completed)
- Finding: Keccak-f is only 4.7% of GPU time (5.08s/107.6s)
- Main (36%), Dma+recursive (32%), Mem (11%) dominate
- Keccak-f Q expression eval: 1.231s across 32 instances
- Impact: Informed all subsequent decisions

### Task 2: Column Reduction Analysis (completed via Codex)
- Finding: Max 1.1-1.9s saving (1-1.8%) for HIGH risk
- Lookup chunk size already maxed (145^3 < 2^23)
- Byte-sliced AIR is effectively a new AIR
- Decision: Not recommended for production

### Task 3: Round-Aware Q Expression Evaluator (completed, no retained change)
- Round-aware analysis: 0.6% op-type match between 3002-op windows - NOT 24 identical rounds
- Chunked generator correctness fixed: proper liveness analysis shows 361 tmp1 + 4 tmp3 live at boundaries
- Single-file compilation: 200K lines, 30+ min cicc compile time (impractical)
- Multi-kernel approach: +2s regression from global memory accumulator overhead
- Conclusion: bytecode interpreter is already efficient for this expression

### Task 4: Fused imPol Expression Evaluation (completed, reverted)
- cudaGraph already eliminates kernel launch overhead
- CALCULATE_IM_POLS: 2.1s total across all AIR types (actual computation, not overhead)
- Batched kernel launch attempted but caused destVals buffer overflow
- Independent store mode infrastructure added (assertion relaxed, per-param store path)
- Decision: No performance benefit after cudaGraph optimization

### Task 5: nBits Instance Consolidation (completed via Codex)
- powBits=23 is for grinding security, not trace size constraint
- nBits=18 requires full AIR/PILOUT/setup rebuild
- Breakeven analysis: net -0.08 to -0.14s (slightly worse)
- Decision: Not recommended

## Total Improvement
0% - no retained performance improvements. The fundamental finding is that Keccak-f optimization has very limited ROI (4.7% of GPU time).

## Final Benchmarks (Round 2, GPU mode)
- Small block: 24.1s prove + verify pass (baseline ~23s)
- Large block: 97.2s prove + verify pass (baseline 96.2s)
- No statistically significant change from baseline

## Commits
- f9da7824: Chunked code generation for large CUDA expression evaluators
- be030f48: Generator liveness fix, imPol batch infrastructure
- (pending): Round 2 - proper imPol batching, structural analysis, safety fixes
