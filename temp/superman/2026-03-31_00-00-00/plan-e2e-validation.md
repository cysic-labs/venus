# Sub-Plan: E2E Validation + Soundness (Stage 2)

## Objective
Prove the full Rust pipeline produces valid proving keys. Run e2e flow and review soundness for all non-byte-identical AIRs.

## Prerequisites
- Stage 1 complete (35/35 AIRs finish setup)

## Steps

### Step 1: Generate Fresh Proving Keys (Rust pipeline)
```bash
make clean
rm -rf build/provingKey
/usr/bin/time -v make generate-key 2>&1 | tee temp/generate_key_baseline.log
```
Record: wall-clock time, peak RSS memory.

### Step 2: ROM Setup and Check
```bash
make setup   # includes build, rom-setup, check-setup, check-setup -a
```
All steps must pass without errors.

### Step 3: Small Block Prove + Verify
```bash
make prove 2>&1 | tee temp/e2e_small_block.log
make verify 2>&1 | tee -a temp/e2e_small_block.log
```
Record prove time. Target: <=24s (no regression).

### Step 4: Large Block Prove + Verify
```bash
INPUT=guest/zisk-eth-client/bin/guests/stateless-validator-reth/inputs/mainnet_24628590_478_49_zec_reth.bin make prove 2>&1 | tee temp/e2e_large_block.log
make verify 2>&1 | tee -a temp/e2e_large_block.log
```
Record prove time. Target: <=97s (no regression).

### Step 5: Fresh Compare Against Golden
```bash
scripts/compare_proving_key.sh golden_reference build/provingKey > temp/golden_compare.txt 2>&1
```
Document in temp/golden_compare.txt:
- Full compare counts (DIFFER, MISSING)
- 7-file subset (starkinfo.json, expressionsinfo.json, verifierinfo.json, bin, verifier.bin, verkey.json, verkey.bin)
- Per-AIR analysis: which match, which differ
- For each differing AIR: which specific files differ and why

### Step 6: Soundness Review for Non-Identical AIRs
For EACH AIR that produces different output from golden, verify:

**Structural checks:**
- nConstants matches between Rust and golden starkinfo
- nConstraints matches
- nStages matches
- openingPoints array matches (same points, same count)
- cmPolsMap has same structure (stages, positions)

**Security-critical checks:**
- FRI security parameters: nQueries, powBits, proximityGap identical
- blowUpFactor matches
- merkleTreeArity matches
- Constraint polynomial degree (qDeg) matches
- No synthetic zero verification keys (all verkey values non-zero for AIRs with constants)

**Binary output checks:**
- .bin file sizes match golden (even if content differs due to expression ordering)
- .verifier.bin file sizes match golden
- verkey root values are non-zero and consistent

Document findings in temp/soundness_review.md.

### Step 7: Targeted Checks for 10 Non-Matching AIRs
For each of the known differing AIRs (ArithEq, ArithEq384, Blake2br, Sha256f, Keccakf, Rom, SpecifiedRanges, VirtualTable0, VirtualTable1, Poseidon2):

Compare Rust vs golden starkinfo.json:
```python
import json
for air in ['ArithEq', 'ArithEq384', ...]:
    rust = json.load(open(f'build/provingKey/.../air/{air}.starkinfo.json'))
    gold = json.load(open(f'golden_reference/.../air/{air}.starkinfo.json'))
    # Compare: nConstants, nConstraints, qDeg, nQueries, powBits, openingPoints
```

### Step 8: Fix 4 Failing Unit Tests
- fri_poly: fri_exp_id=0 is valid when arena starts empty; fix test expectations
- map: add guard for empty expressions vec before index access
- prepare_pil: fix test data degree values
- Run `cargo test -p pil2-stark-setup` → 95/95 pass

## Success Criteria
1. Steps 1-4 all pass (make setup, prove, verify on both blocks)
2. Prove times show no regression (small <=24s, large <=97s)
3. Total PK gen < 30 minutes
4. Peak memory < 90GB
5. Soundness review: no security-critical differences found
6. All 95 pil2-stark-setup tests pass
7. Evidence files saved in temp/
