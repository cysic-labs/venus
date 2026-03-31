# Sub-Plan: Fix Poseidon2 Codegen (Stage 1)

## Objective
Make Poseidon2 AIR complete non-recursive setup within 5 minutes (currently >20 min, never completes).

## Root Cause
`fix_eval()` in `pil2-stark-setup/src/codegen.rs` performs O(|ev_map|) linear search per code entry. For Poseidon2 with 31,554 code entries and 182 ev_map entries, this is ~5.7M string comparisons.

## Implementation

### Step 1: Build ev_map index in CodeGenCtx
Add a HashMap index matching the EXACT same semantics as the JS linear search: key = `(entry_type, id, opening_pos)` - NO commit_id (JS doesn't use it in findIndex).

File: `pil2-stark-setup/src/codegen.rs`

```rust
// In CodeGenCtx struct:
pub ev_map_index: HashMap<(String, usize, usize), usize>,

// Helper to rebuild index after ev_map changes:
fn rebuild_ev_map_index(ctx: &mut CodeGenCtx) {
    ctx.ev_map_index.clear();
    for (i, e) in ctx.ev_map.iter().enumerate() {
        let key = (e.entry_type.clone(), e.id, e.opening_pos);
        // First match wins (same as JS findIndex)
        ctx.ev_map_index.entry(key).or_insert(i);
    }
}
```

Note: Using `entry().or_insert()` to match JS `findIndex` semantics (returns FIRST match).

### Step 2: Replace linear search in fix_eval
File: `pil2-stark-setup/src/codegen.rs`

```rust
fn fix_eval(r: &mut CodeRef, ctx: &CodeGenCtx, _symbols: &[SymbolInfo]) {
    let prime = r.prime.unwrap_or(0);
    let opening_pos = match ctx.opening_points.iter().position(|&p| p == prime) {
        Some(pos) => pos,
        None => return, // Unknown opening point: do not remap (fail-safe)
    };
    let key = (r.ref_type.clone(), r.id, opening_pos);
    if let Some(&idx) = ctx.ev_map_index.get(&key) {
        r.prime = None;
        r.id = idx;
        r.ref_type = "eval".to_string();
        r.dim = FIELD_EXTENSION;
    }
}
```

**Change from current code**: Missing opening point now returns early instead of defaulting to position 0 (`unwrap_or(0)`). This matches the JS behavior where `findIndex` returns -1 for missing primes and the conditional `if (evalIndex !== -1)` skips the remap.

### Step 3: Rebuild index at the right points
1. After ev_map is populated and sorted in `generate_constraint_polynomial_verifier_code`
2. After ev_map is moved back from sub-context in `pil_code_gen`
3. When CodeGenCtx is created with non-empty ev_map

### Step 4: Move ev_map index with ev_map
```rust
ev_map_index: std::mem::take(&mut ctx.ev_map_index),
// ... after processing ...
ctx.ev_map_index = code_ctx.ev_map_index;
```

### Step 5: Add fix_eval unit tests
Test cases for the HashMap-based fix_eval:
- Normal eval lookup (type=cm, id=5, opening_pos=0) → found
- Custom commit eval (type=custom, id=3, opening_pos=1) → found
- Missing opening point (prime not in opening_points) → no remap (return early)
- Missing eval entry → no remap
- Duplicate key (first match wins, same as JS findIndex)

## Verification
1. `cargo test -p pil2-stark-setup` - no regression in existing tests
2. New fix_eval unit tests pass
3. Run full Rust pipeline: `make generate-key` with Rust pil2c output
4. Poseidon2 completes within timeout
5. `make prove && make verify` passes with Rust-generated keys
6. Existing Dma/Binary/Arith .bin golden tests still pass

## Risk
- Semantic equivalence: HashMap `entry().or_insert()` matches JS `findIndex` (first match)
- Index freshness: must rebuild after every ev_map mutation (sort, push, move)
