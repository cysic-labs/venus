//! Phase 1 regression for plan-rustify-pkgen-e2e-0420 lazy expression
//! reification (Round 1 repair per Codex Round 0 review).
//!
//! Compiles `minimal_lazy_expr_reification.pil` and asserts JS-style
//! lazy-packing semantics on the resulting pilout. The fixture uses
//! two instances of `LazyReifyAir` so the second instance inherits
//! proof-scope state the first instance populated through
//! `direct_global_update_proves(MARKER_UNUSED_OPID, ...)`; JS's
//! `PackedExpressions` lazy packer drops that inherited state when
//! the second instance does not reference it, while Rust's eager
//! `execute_air_template_call` bulk-lift carries it into the
//! second instance's `air_expression_store` regardless.
//!
//! On current HEAD every assertion in this file MUST FAIL loudly.
//! That failure is the baseline for the Phase 2/3 producer fixes
//! (Round 2+ adds `RuntimeExpr::ExprRef` and replaces the bulk-lift
//! with a reachability-driven importer).
//!
//! Five assertions lock the lazy-reification contract. The first
//! two encode the exact-count parity Codex Round 0 review required;
//! the next one is the graph-complete unused-marker absence check
//! that follows `Operand::Expression { idx }` through the full DAG;
//! the last two encode the alias-chain and row-offset
//! reference-identity gates.

use std::collections::{HashMap, HashSet};
use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

// Marker literal baked into the unused proof-scope payload in
// `minimal_lazy_expr_reification.pil` via
// `direct_global_update_proves(MARKER_UNUSED_OPID,
// [987654321, 0, 0, 0, 0, 0, 0, 0], ...)`. The marker coefficient is
// chosen so that no other expression in the fixture would ever
// materialize it, so any occurrence in a decoded AIR arena is proof
// that the unused proof-scope state was not pruned.
const MARKER_UNUSED: u64 = 987654321;

// Expected per-AIR `air.expressions.len()` under JS-lazy packing for
// `LazyReifyAir(N=2**4, enable_flag=ps_enable)`. Both instances of
// the airtemplate have identical bodies, so after lazy reification
// both must land on the SAME count. The first instance on current
// HEAD already reports 30 entries; JS lazy packing should produce
// this same count OR a smaller count for both. The assertion is a
// loose lower-bound floor (>= 1) combined with the exact-equality
// invariant `first.len() == second.len()`. Phase 2/3 may refine the
// numeric target if lazy reification shrinks the first-instance
// count further; for now the primary gate is count equality across
// instances plus the ceiling below.
const LAZY_REIFY_AIR_EXPRESSIONS_CEILING: usize = 30;

fn compile_fixture(tag: &str) -> Vec<u8> {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");
    let fixture = manifest
        .join("tests")
        .join("data")
        .join("minimal_lazy_expr_reification.pil");
    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    let std_pil = workspace
        .join("pil2-proofman")
        .join("pil2-components")
        .join("lib")
        .join("std")
        .join("pil");

    let out = std::env::temp_dir()
        .join(format!("pil2c_minimal_lazy_expr_reification_regression_{}.pilout", tag));
    let _ = std::fs::remove_file(&out);

    let status = Command::new(&bin)
        .arg(&fixture)
        .arg("-I")
        .arg(std_pil.to_str().unwrap())
        .arg("-o")
        .arg(&out)
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .status()
        .expect("failed to spawn pil2c");
    assert!(status.success(), "pil2c compile failed");

    std::fs::read(&out).expect("read pilout")
}

fn decode(bytes: &[u8]) -> pb::PilOut {
    pb::PilOut::decode(bytes).expect("decode pilout")
}

/// Find every AIR named `air_name` in the airgroup and return a
/// vector of each instance's `&[pb::Expression]` slice preserving
/// declaration order. Both `LazyReifyAir` instances appear under the
/// single `LazyReify` airgroup, so the returned vector has two
/// entries for our fixture.
fn air_expression_slices<'a>(
    pilout: &'a pb::PilOut,
    air_name: &str,
) -> Vec<&'a [pb::Expression]> {
    let mut out = Vec::new();
    for ag in &pilout.air_groups {
        for air in &ag.airs {
            if air.name.as_deref() == Some(air_name) {
                out.push(&air.expressions[..]);
            }
        }
    }
    assert!(
        !out.is_empty(),
        "AIR {} not found in any airgroup",
        air_name
    );
    out
}

fn constant_bytes_equal_u64(bytes: &[u8], target: u64) -> bool {
    if bytes.is_empty() {
        return target == 0;
    }
    let mut value: u128 = 0;
    for &b in bytes {
        value = (value << 8) | (b as u128);
        if value > u64::MAX as u128 {
            return false;
        }
    }
    value == target as u128
}

/// DAG-complete walker: for each root index in `roots`, follow every
/// `Operand::Expression { idx }` recursively and inspect every
/// `Operand::Constant` along the way. Returns the set of
/// `(arena_idx, constant_bytes)` occurrences. Uses a `HashSet` to
/// avoid re-walking shared subtrees.
fn walk_constants_from_roots(
    expressions: &[pb::Expression],
    roots: &[u32],
) -> Vec<(u32, Vec<u8>)> {
    use pb::expression::Operation;
    use pb::operand::Operand as O;
    let mut visited: HashSet<u32> = HashSet::new();
    let mut stack: Vec<u32> = roots.to_vec();
    let mut constants: Vec<(u32, Vec<u8>)> = Vec::new();
    while let Some(idx) = stack.pop() {
        if !visited.insert(idx) {
            continue;
        }
        let Some(expr) = expressions.get(idx as usize) else {
            continue;
        };
        let mut operands: Vec<&pb::Operand> = Vec::new();
        match expr.operation.as_ref() {
            Some(Operation::Add(a)) => {
                if let Some(l) = a.lhs.as_ref() {
                    operands.push(l);
                }
                if let Some(r) = a.rhs.as_ref() {
                    operands.push(r);
                }
            }
            Some(Operation::Sub(s)) => {
                if let Some(l) = s.lhs.as_ref() {
                    operands.push(l);
                }
                if let Some(r) = s.rhs.as_ref() {
                    operands.push(r);
                }
            }
            Some(Operation::Mul(m)) => {
                if let Some(l) = m.lhs.as_ref() {
                    operands.push(l);
                }
                if let Some(r) = m.rhs.as_ref() {
                    operands.push(r);
                }
            }
            Some(Operation::Neg(n)) => {
                if let Some(v) = n.value.as_ref() {
                    operands.push(v);
                }
            }
            None => {}
        }
        for op in operands {
            match op.operand.as_ref() {
                Some(O::Constant(c)) => constants.push((idx, c.value.clone())),
                Some(O::Expression(e)) => stack.push(e.idx),
                _ => {}
            }
        }
    }
    constants
}

fn constraint_expression_idx(c: &pb::Constraint) -> Option<u32> {
    c.constraint.as_ref().and_then(|cv| match cv {
        pb::constraint::Constraint::FirstRow(r) => r.expression_idx.as_ref(),
        pb::constraint::Constraint::LastRow(r) => r.expression_idx.as_ref(),
        pb::constraint::Constraint::EveryRow(r) => r.expression_idx.as_ref(),
        pb::constraint::Constraint::EveryFrame(r) => r.expression_idx.as_ref(),
    }).map(|e| e.idx)
}

/// Assertion 1: both instances of `LazyReifyAir` have IDENTICAL
/// `air.expressions.len()`. The two instances share an identical
/// airtemplate body; JS lazy reification produces the same per-AIR
/// container for both. Current Rust bulk-lift violates this because
/// the second instance inherits proof-scope state from the first.
#[test]
fn lazy_reify_air_expressions_count_is_identical_across_instances() {
    let pilout = decode(&compile_fixture("count_identity"));
    let instances = air_expression_slices(&pilout, "LazyReifyAir");
    assert!(
        instances.len() >= 2,
        "LazyReifyAir must have two instances; found {}",
        instances.len()
    );
    let first = instances[0].len();
    let second = instances[1].len();
    assert_eq!(
        first, second,
        "LazyReifyAir instance counts must be equal under JS-lazy \
         packing. Both instances share an identical airtemplate body, \
         so their per-AIR `air.expressions` arenas must match. \
         Observed first={} second={}. The second instance inherits \
         proof-scope state from the first via `direct_global_update_*`; \
         current Rust bulk-lift carries that state into the second \
         instance's arena, inflating its count. JS lazy packing drops \
         unreferenced inherited state. Phase 2/3 of \
         temp/plan-rustify-pkgen-e2e-0420.md closes this.",
        first,
        second
    );
}

/// Assertion 2: each instance's arena is bounded by the
/// first-instance ceiling. Phase 2/3 may refine this numeric target
/// if lazy reification shrinks the first-instance count further.
#[test]
fn lazy_reify_air_expressions_count_matches_ceiling() {
    let pilout = decode(&compile_fixture("count_ceiling"));
    let instances = air_expression_slices(&pilout, "LazyReifyAir");
    for (idx, ex) in instances.iter().enumerate() {
        assert_eq!(
            ex.len(),
            LAZY_REIFY_AIR_EXPRESSIONS_CEILING,
            "LazyReifyAir instance#{}: expressions.len()={} must equal \
             the expected lazy-packing target {}. This locks the exact \
             per-AIR arena shape required by Phase 1 of \
             temp/plan-rustify-pkgen-e2e-0420.md.",
            idx,
            ex.len(),
            LAZY_REIFY_AIR_EXPRESSIONS_CEILING
        );
    }
}

/// Assertion 3: graph-complete unused-marker absence. For each
/// `LazyReifyAir` instance, walk EVERY arena entry (not just those
/// reachable from constraint roots) and assert no `Operand::Constant`
/// anywhere encodes `MARKER_UNUSED = 987654321`. This catches both
/// the root-reachable case (marker referenced by a constraint) AND
/// the orphan-arena-entry case (marker lifted into the arena without
/// any constraint referencing it - exactly what current Rust
/// bulk-lift produces). The marker is baked into the
/// MARKER_UNUSED_OPID payload that the first instance's
/// `direct_global_update_proves` writes to proof-scope; JS lazy
/// reification drops this payload from both instances' arenas
/// because no airgroup-level `direct_global_update_assumes(MARKER
/// _UNUSED_OPID, ...)` balances it. Current Rust bulk-lift keeps
/// the payload as orphan arena entries.
#[test]
fn lazy_reify_unused_marker_is_absent_from_arena() {
    let pilout = decode(&compile_fixture("marker_dag"));
    let instances = air_expression_slices(&pilout, "LazyReifyAir");
    // Walk every arena entry (graph-complete), following
    // `Operand::Expression { idx }` to cover multi-level
    // references, but starting from every arena entry so orphan
    // entries cannot hide the marker.
    for (idx, expressions) in instances.iter().enumerate() {
        let all_roots: Vec<u32> = (0..expressions.len() as u32).collect();
        let constants = walk_constants_from_roots(expressions, &all_roots);
        let marker_hits: Vec<_> = constants
            .iter()
            .filter(|(_, bytes)| constant_bytes_equal_u64(bytes, MARKER_UNUSED))
            .collect();
        assert!(
            marker_hits.is_empty(),
            "LazyReifyAir instance#{}: marker coefficient {} found \
             in the arena at entries {:?}. `marker_unused` proof-scope \
             payload (direct_global_update_proves(MARKER_UNUSED_OPID, \
             [987654321, ...])) is never balanced by an airgroup-level \
             `direct_global_update_assumes(MARKER_UNUSED_OPID, ...)`. \
             JS lazy packing drops the inherited state because no AIR \
             root references it. Current Rust bulk-lift keeps it as \
             orphan arena entries. Phase 2/3 of \
             temp/plan-rustify-pkgen-e2e-0420.md closes this via \
             reachability-driven importing.",
            idx,
            MARKER_UNUSED,
            marker_hits
        );
    }
}

/// Assertion 4: alias-chain reference identity. `local_alias_1 = cx
/// + cy; local_alias_2 = local_alias_1; local_alias_1 === 0;
/// local_alias_2 === 0;` creates two constraints that read the same
/// logical expression. Under JS lazy packing both constraints
/// resolve to the same packed arena idx. Under current Rust
/// bulk-lift the alias is materialized as a fresh entry, so the
/// two constraints resolve to different arena indices.
///
/// The assertion walks the AIR's constraint list for constraints
/// whose expression index directly contains `cx + cy` (a 2-operand
/// Add of two distinct witness cols) and asserts they all point to
/// the same arena idx (either directly or via a single-hop
/// `Operand::Expression { idx }`).
#[test]
fn lazy_reify_air_alias_chain_shares_packed_idx() {
    let pilout = decode(&compile_fixture("alias_chain"));
    let instances = air_expression_slices(&pilout, "LazyReifyAir");
    for (inst_idx, ex) in instances.iter().enumerate() {
        // For each constraint expression, resolve to the underlying
        // tree through at most one leaf-wrap indirection, then check
        // whether the tree's root op is `Add` with two witness-col
        // leaves (cx + cy). Record the arena idx at which the
        // `Add(WitnessCol, WitnessCol)` lives.
        use pb::expression::Operation;
        use pb::operand::Operand as O;
        let pilout_ref = &pilout;
        let Some(ag) = pilout_ref.air_groups.first() else {
            panic!("no airgroup");
        };
        let air = ag
            .airs
            .iter()
            .filter(|a| a.name.as_deref() == Some("LazyReifyAir"))
            .nth(inst_idx)
            .expect("LazyReifyAir instance");
        let mut cx_cy_constraint_roots: Vec<u32> = Vec::new();
        for constraint in &air.constraints {
            let Some(root_idx) = constraint_expression_idx(constraint) else {
                continue;
            };
            let Some(expr) = ex.get(root_idx as usize) else {
                continue;
            };
            // Follow Add(leaf, 0) leaf-wrap exactly one hop.
            let target_idx = match expr.operation.as_ref() {
                Some(Operation::Add(a)) => {
                    let rhs_is_zero = matches!(
                        a.rhs.as_ref().and_then(|o| o.operand.as_ref()),
                        Some(O::Constant(c)) if c.value.is_empty()
                    );
                    if rhs_is_zero {
                        if let Some(O::Expression(e)) =
                            a.lhs.as_ref().and_then(|o| o.operand.as_ref())
                        {
                            Some(e.idx)
                        } else {
                            None
                        }
                    } else {
                        Some(root_idx)
                    }
                }
                _ => Some(root_idx),
            };
            let Some(idx) = target_idx else {
                continue;
            };
            let Some(target_expr) = ex.get(idx as usize) else {
                continue;
            };
            let Some(Operation::Add(a)) = target_expr.operation.as_ref() else {
                continue;
            };
            let lhs_is_witness = matches!(
                a.lhs.as_ref().and_then(|o| o.operand.as_ref()),
                Some(O::WitnessCol(_))
            );
            let rhs_is_witness = matches!(
                a.rhs.as_ref().and_then(|o| o.operand.as_ref()),
                Some(O::WitnessCol(_))
            );
            if lhs_is_witness && rhs_is_witness {
                cx_cy_constraint_roots.push(idx);
            }
        }
        assert!(
            cx_cy_constraint_roots.len() >= 2,
            "LazyReifyAir instance#{}: expected at least two \
             constraints whose root expression is Add(WitnessCol, \
             WitnessCol) (the alias-chain reads of `local_alias_1` \
             / `local_alias_2`), but found {} such constraints. The \
             fixture may not be exercising the alias-chain case.",
            inst_idx,
            cx_cy_constraint_roots.len()
        );
        let canonical = cx_cy_constraint_roots[0];
        for (i, idx) in cx_cy_constraint_roots.iter().enumerate().skip(1) {
            assert_eq!(
                *idx, canonical,
                "LazyReifyAir instance#{}: alias-chain read #{} \
                 resolves to arena idx {} but alias-chain read #0 \
                 resolves to arena idx {}. Under JS lazy packing both \
                 reads of `local_alias_1` / `local_alias_2` must share \
                 one packed idx.",
                inst_idx, i, idx, canonical
            );
        }
    }
}

/// Assertion 5: row-offset reference identity. The fixture has
/// `shifted_cx = cx'` (aliased constraint `shifted_cx === 0`) plus an
/// inline `cx' + cy === 0` constraint. Both reads of `cx'` at
/// `(col_idx_of_cx, row_offset=+1)` must resolve to the same packed
/// witness-col operand embedded in the same arena entry.
#[test]
fn lazy_reify_air_row_offset_shares_packed_idx() {
    let pilout = decode(&compile_fixture("row_offset"));
    let instances = air_expression_slices(&pilout, "LazyReifyAir");
    use pb::expression::Operation;
    use pb::operand::Operand as O;
    for (inst_idx, ex) in instances.iter().enumerate() {
        // Collect every (col_idx, row_offset, stage) = (?, +1, 1) reference from
        // every arena entry's direct operands.
        let mut cx_shift_refs: HashMap<(u32, i32, u32), Vec<u32>> =
            HashMap::new();
        for (arena_idx, expr) in ex.iter().enumerate() {
            let mut operands: Vec<&pb::Operand> = Vec::new();
            match expr.operation.as_ref() {
                Some(Operation::Add(a)) => {
                    if let Some(l) = a.lhs.as_ref() {
                        operands.push(l);
                    }
                    if let Some(r) = a.rhs.as_ref() {
                        operands.push(r);
                    }
                }
                Some(Operation::Sub(s)) => {
                    if let Some(l) = s.lhs.as_ref() {
                        operands.push(l);
                    }
                    if let Some(r) = s.rhs.as_ref() {
                        operands.push(r);
                    }
                }
                Some(Operation::Mul(m)) => {
                    if let Some(l) = m.lhs.as_ref() {
                        operands.push(l);
                    }
                    if let Some(r) = m.rhs.as_ref() {
                        operands.push(r);
                    }
                }
                Some(Operation::Neg(n)) => {
                    if let Some(v) = n.value.as_ref() {
                        operands.push(v);
                    }
                }
                None => {}
            }
            for op in operands {
                if let Some(O::WitnessCol(w)) = op.operand.as_ref() {
                    if w.row_offset == 1 {
                        cx_shift_refs
                            .entry((w.col_idx, w.row_offset, w.stage))
                            .or_default()
                            .push(arena_idx as u32);
                    }
                }
            }
        }
        // Every (col_idx, row_offset, stage) triple that appears more
        // than once must share the SAME arena entry (we measure this
        // as: all occurrences point to the same arena idx).
        for (tuple, occurrences) in &cx_shift_refs {
            let first = occurrences[0];
            for (i, idx) in occurrences.iter().enumerate().skip(1) {
                assert_eq!(
                    *idx, first,
                    "LazyReifyAir instance#{}: witness ref {:?} \
                     occurrence #{} lives in arena idx {} but \
                     occurrence #0 lives in arena idx {}. Under \
                     JS-lazy `(expr_id, row_offset)` packed-reference \
                     reuse semantics both occurrences must sit in the \
                     same arena entry.",
                    inst_idx, tuple, i, idx, first
                );
            }
        }
    }
}
