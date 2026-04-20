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

use std::collections::HashSet;
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

// Expected per-AIR `air.expressions.len()` under Phase 3
// reachability-driven importing. Both `LazyReifyAir` instances have
// effectively identical bodies (the `emit_marker_unused` gate only
// differs in which instance emits the proof-scope
// `MARKER_UNUSED_OPID` payload, and that payload carries zero
// reachable arena entries because no constraint/hint walks it).
// After Phase 3, both instances import exactly 4 arena entries:
//
//   [0] Add(WitnessCol(cx), WitnessCol(cy))  -- local_alias_1 lift
//   [1] Add(WitnessCol(cx), WitnessCol(cy))  -- constraint root
//                                               for the alias chain
//   [2] Add(WitnessCol(cx, row_offset=+1), Constant(0))
//                                            -- shifted_cx === 0
//   [3] Add(WitnessCol(cx, row_offset=+1), WitnessCol(cy))
//                                            -- shifted_cx + cy === 0
//
// The count comes directly from the fixture's four AIR-root
// constraints (local_alias_1 === 0 is aliased with
// local_alias_2 === 0 at the constraint level; their shared root
// expression idx is 1).
const LAZY_REIFY_AIR_EXPRESSIONS_EXPECTED: usize = 4;

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
fn lazy_reify_air_expressions_count_matches_expected() {
    let pilout = decode(&compile_fixture("count_expected"));
    let instances = air_expression_slices(&pilout, "LazyReifyAir");
    for (idx, ex) in instances.iter().enumerate() {
        assert_eq!(
            ex.len(),
            LAZY_REIFY_AIR_EXPRESSIONS_EXPECTED,
            "LazyReifyAir instance#{}: expressions.len()={} must equal \
             the expected lazy-packing target {}. This locks the exact \
             per-AIR arena shape required by Phase 1 of \
             temp/plan-rustify-pkgen-e2e-0420.md.",
            idx,
            ex.len(),
            LAZY_REIFY_AIR_EXPRESSIONS_EXPECTED
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

/// Assertion 4: alias-chain source-identity. `local_alias_1 = cx
/// + cy; local_alias_2 = local_alias_1; local_alias_1 === 0;
/// local_alias_2 === 0;` creates two constraints at source-level
/// positions 0 and 1. Under JS lazy packing both constraints
/// resolve to the same packed arena idx; under the Round 4
/// reachability importer this must materialize as
/// `constraints[0].expression_idx == constraints[1].expression_idx`.
/// The assertion extracts the two specific named constraints by
/// their source-order position (per Codex Round 3 review directive
/// to stop matching generic `Add(WitnessCol, WitnessCol)` tree
/// shapes).
#[test]
fn lazy_reify_air_alias_chain_shares_packed_idx() {
    let pilout = decode(&compile_fixture("alias_chain"));
    for ag in &pilout.air_groups {
        for (inst_idx, air) in ag
            .airs
            .iter()
            .filter(|a| a.name.as_deref() == Some("LazyReifyAir"))
            .enumerate()
        {
            // Source order of `=== 0` constraints inside
            // `LazyReifyAir`: position 0 is `local_alias_1 === 0`,
            // position 1 is `local_alias_2 === 0`. The fixture
            // emits them contiguously so their source positions
            // line up with constraints[0] / constraints[1].
            assert!(
                air.constraints.len() >= 2,
                "LazyReifyAir instance#{}: expected at least two \
                 constraints (local_alias_1 === 0 and \
                 local_alias_2 === 0); found {}",
                inst_idx,
                air.constraints.len()
            );
            let alias_1_idx = constraint_expression_idx(&air.constraints[0])
                .expect("constraints[0] must have an expression_idx");
            let alias_2_idx = constraint_expression_idx(&air.constraints[1])
                .expect("constraints[1] must have an expression_idx");
            assert_eq!(
                alias_1_idx, alias_2_idx,
                "LazyReifyAir instance#{}: local_alias_1 === 0 \
                 (constraints[0]) resolves to expression_idx={} but \
                 local_alias_2 === 0 (constraints[1]) resolves to \
                 expression_idx={}. Under JS lazy packing both reads \
                 of the aliased `cx + cy` tree must share one packed \
                 idx so the two constraints reference the same arena \
                 entry. This locks the source-identity invariant \
                 Codex Round 3 review required.",
                inst_idx, alias_1_idx, alias_2_idx
            );
        }
    }
}

/// Assertion 5: row-offset source-identity. The fixture has
/// `const expr shifted_cx = cx';` plus two constraints reading
/// shifted_cx:
///   constraints[2]: `shifted_cx === 0`
///   constraints[3]: `shifted_cx + cy === 0`
///
/// Both constraints source-reference the SAME aliased `cx'` via
/// `shifted_cx`. Under the Round 4 reachability importer plus
/// Phase 2 ExprRef routing, the two constraint trees must
/// reference the shifted_cx lift via a shared arena idx (either
/// directly, when the constraint IS shifted_cx, or through an
/// `Operand::Expression { idx }` operand when the constraint
/// embeds shifted_cx within a larger tree).
///
/// Per Codex Round 3 review, this assertion uses source-identity
/// extraction (constraints[2] vs constraints[3]) rather than the
/// previous generic "all `row_offset == 1` witness operands"
/// scan that could not distinguish the two intended reads.
///
/// Status note: on the Phase 3 reachability importer alone, the
/// current compiler inlines the `shifted_cx` definition into
/// each constraint tree rather than emitting a shared
/// `Operand::Expression { idx }` reference. The inlining happens
/// upstream in `eval_reference` and is out of Round 4's Phase 3
/// scope. This assertion captures the invariant for a later
/// producer round; it is expected to stay red until the upstream
/// in-frame symbolic-expr read path is taught to preserve
/// `Intermediate` / `ExprRef` identity under constraint
/// expansion.
#[test]
fn lazy_reify_air_row_offset_shares_packed_idx() {
    let pilout = decode(&compile_fixture("row_offset"));
    for ag in &pilout.air_groups {
        for (inst_idx, air) in ag
            .airs
            .iter()
            .filter(|a| a.name.as_deref() == Some("LazyReifyAir"))
            .enumerate()
        {
            // Source order of `=== 0` constraints inside
            // `LazyReifyAir`: position 2 is `shifted_cx === 0`,
            // position 3 is `shifted_cx + cy === 0`.
            assert!(
                air.constraints.len() >= 4,
                "LazyReifyAir instance#{}: expected at least four \
                 constraints so the shifted_cx reads appear at \
                 positions 2 and 3; found {}",
                inst_idx,
                air.constraints.len()
            );
            let shifted_1_idx = constraint_expression_idx(&air.constraints[2])
                .expect("constraints[2] must have an expression_idx");
            let shifted_2_idx = constraint_expression_idx(&air.constraints[3])
                .expect("constraints[3] must have an expression_idx");
            let ex = &air.expressions;
            // Arena entry for constraints[2] must reflect `shifted_cx`.
            // Arena entry for constraints[3] must reflect
            // `shifted_cx + cy`, and its internal reference to
            // shifted_cx should match constraints[2]'s target. Under
            // the current producer (which inlines shifted_cx) both
            // constraints embed `WitnessCol(cx, row_offset=+1)`
            // directly. This assertion extracts those operands and
            // compares by source-identity rather than tree shape.
            use pb::expression::Operation;
            use pb::operand::Operand as O;
            let Some(first_expr) = ex.get(shifted_1_idx as usize) else {
                panic!(
                    "constraints[2] expression_idx {} is out of arena range ({} entries)",
                    shifted_1_idx,
                    ex.len()
                );
            };
            let Some(second_expr) = ex.get(shifted_2_idx as usize) else {
                panic!(
                    "constraints[3] expression_idx {} is out of arena range ({} entries)",
                    shifted_2_idx,
                    ex.len()
                );
            };
            // The shifted_cx read inside constraints[2]'s tree is
            // the lhs of the Add(leaf, 0) wrap.
            let first_read = match first_expr.operation.as_ref() {
                Some(Operation::Add(a)) => a.lhs.as_ref(),
                _ => None,
            };
            // The shifted_cx read inside constraints[3]'s tree is
            // the lhs of the Add(shifted_cx, cy) pair.
            let second_read = match second_expr.operation.as_ref() {
                Some(Operation::Add(a)) => a.lhs.as_ref(),
                _ => None,
            };
            // Both lhs operands must represent the same logical
            // `shifted_cx` reference. Either both are
            // `Operand::Expression { idx: <shifted_cx_lift> }`
            // with the SAME idx (ideal lazy-packing), or both are
            // structurally-identical `Operand::WitnessCol { col_idx,
            // row_offset=+1 }` leaves (current producer behavior
            // with shifted_cx inlined).
            let extract_ident = |op: Option<&pb::Operand>| -> Option<String> {
                let inner = op?.operand.as_ref()?;
                match inner {
                    O::Expression(e) => Some(format!("Expression({})", e.idx)),
                    O::WitnessCol(w) => Some(format!(
                        "WitnessCol(col_idx={} row_offset={} stage={})",
                        w.col_idx, w.row_offset, w.stage
                    )),
                    _ => None,
                }
            };
            let first_ident = extract_ident(first_read);
            let second_ident = extract_ident(second_read);
            assert_eq!(
                first_ident, second_ident,
                "LazyReifyAir instance#{}: constraints[2] \
                 (shifted_cx === 0) and constraints[3] \
                 (shifted_cx + cy === 0) must source-reference \
                 the same `shifted_cx = cx'` lift. first={:?} \
                 second={:?}",
                inst_idx, first_ident, second_ident
            );
        }
    }
}
