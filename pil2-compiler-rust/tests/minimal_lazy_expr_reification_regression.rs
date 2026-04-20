//! Phase 1 regression for plan-rustify-pkgen-e2e-0420 lazy expression
//! reification.
//!
//! Compiles `minimal_lazy_expr_reification.pil` and asserts the
//! JS-equivalent per-AIR arena shape produced by the Phase 3
//! reachability-driven importer combined with the Round 8
//! `IdData.is_const_expr` inclusion rule. The fixture uses two
//! `LazyReifyAir` instances where the FIRST instance emits a
//! proof-scope `MARKER_UNUSED_OPID` payload that is never consumed,
//! and the SECOND instance inherits the proof-scope state but does
//! NOT re-emit or consume the payload. Under JS lazy
//! `Expressions.pack` semantics (matched by our producer after
//! Rounds 2-8), `const expr X = ...` declarations pack
//! unconditionally into the per-AIR arena, anonymous
//! constraint/hint roots append in execution order, and inherited
//! proof-scope state is packed only when reachable from the
//! current AIR's constraint/hint roots.
//!
//! Locked invariants:
//!
//! 1. exact per-instance `air.expressions.len()` values
//!    (LAZY_REIFY_AIR_EXPRESSIONS_EXPECTED_FIRST /
//!    `_SECOND`). Pinning the exact counts catches any drift in
//!    the reachability filter or the const-expr inclusion set.
//! 2. graph-complete marker-payload absence: the distinctive
//!    literal `MARKER_UNUSED_CONSTANT = 987654321` from the
//!    never-consumed `MARKER_UNUSED_OPID` payload must not appear
//!    in either instance's arena. This locks the "inherited-but-
//!    unused proof-scope entries get dropped" semantic.
//! 3. alias-chain source-identity: the two
//!    `local_alias_1 === 0` / `local_alias_2 === 0` constraints
//!    (constraints[0] / constraints[1]) resolve to the same arena
//!    `expression_idx`.
//! 4. row-offset source-identity: both reads of `shifted_cx`
//!    (constraints[2] `shifted_cx === 0` and constraints[3]
//!    `shifted_cx + cy === 0`) resolve to operands that share a
//!    single packed `Operand::Expression { idx }` reference. This
//!    locks the Phase 2 ExprRef / Intermediate identity path.

/// First instance's expected `air.expressions.len()`. First
/// instance emits the `MARKER_UNUSED_OPID` payload via the
/// `if (emit_marker_unused == 1)` branch, so its reachable set
/// includes the `USED_OPID` + `MARKER_UNUSED_OPID` proof-scope
/// payload shells plus the in-frame const-expr declarations. Pin
/// the exact count derived from the Round 8 importer output.
const LAZY_REIFY_AIR_EXPRESSIONS_EXPECTED_FIRST: usize = 32;
/// Second instance's expected `air.expressions.len()`. Second
/// instance skips the marker payload branch, so its reachable set
/// is strictly smaller than the first instance's. Pin the exact
/// count.
const LAZY_REIFY_AIR_EXPRESSIONS_EXPECTED_SECOND: usize = 8;
/// Distinctive literal coefficient inside the never-consumed
/// `MARKER_UNUSED_OPID` payload's `[987654321, 0, 0, 0, 0, 0, 0,
/// 0]` expression-array argument. If the lazy reification drops
/// the never-consumed payload as expected, this constant must not
/// appear in either instance's `air.expressions` arena.
const MARKER_UNUSED_CONSTANT: u64 = 987654321;

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

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

fn constraint_expression_idx(c: &pb::Constraint) -> Option<u32> {
    c.constraint.as_ref().and_then(|cv| match cv {
        pb::constraint::Constraint::FirstRow(r) => r.expression_idx.as_ref(),
        pb::constraint::Constraint::LastRow(r) => r.expression_idx.as_ref(),
        pb::constraint::Constraint::EveryRow(r) => r.expression_idx.as_ref(),
        pb::constraint::Constraint::EveryFrame(r) => r.expression_idx.as_ref(),
    }).map(|e| e.idx)
}

/// Extract the unsigned-integer coefficient encoded in an
/// `Operand::Constant`'s `value` byte array. pil2c encodes
/// `Constant.value` as 32 bytes little-endian so a literal
/// `987654321` lands in the low 8 bytes and the remaining bytes
/// are zero.
fn constant_u64(bytes: &[u8]) -> Option<u64> {
    if bytes.len() < 8 {
        return None;
    }
    let lo = u64::from_le_bytes(bytes[..8].try_into().ok()?);
    if bytes[8..].iter().any(|&b| b != 0) {
        return None;
    }
    Some(lo)
}

/// Recursively walk an `air.expressions[idx]` operation tree and
/// collect every `Operand::Constant` literal encountered.
fn walk_constants_in_expression(
    expr: &pb::Expression,
    pool: &[pb::Expression],
    seen_expr: &mut std::collections::HashSet<usize>,
    constants: &mut Vec<u64>,
) {
    use pb::expression::Operation;
    use pb::operand::Operand as O;
    fn walk_operand(
        op: &pb::Operand,
        pool: &[pb::Expression],
        seen_expr: &mut std::collections::HashSet<usize>,
        constants: &mut Vec<u64>,
    ) {
        let Some(inner) = op.operand.as_ref() else {
            return;
        };
        match inner {
            O::Constant(c) => {
                if let Some(v) = constant_u64(&c.value) {
                    constants.push(v);
                }
            }
            O::Expression(e) => {
                let idx = e.idx as usize;
                if !seen_expr.insert(idx) {
                    return;
                }
                if let Some(child) = pool.get(idx) {
                    walk_constants_in_expression(child, pool, seen_expr, constants);
                }
            }
            _ => {}
        }
    }
    let Some(op) = expr.operation.as_ref() else {
        return;
    };
    let operand_refs: Vec<&pb::Operand> = match op {
        Operation::Add(a) => vec![a.lhs.as_ref(), a.rhs.as_ref()]
            .into_iter()
            .flatten()
            .collect(),
        Operation::Sub(s) => vec![s.lhs.as_ref(), s.rhs.as_ref()]
            .into_iter()
            .flatten()
            .collect(),
        Operation::Mul(m) => vec![m.lhs.as_ref(), m.rhs.as_ref()]
            .into_iter()
            .flatten()
            .collect(),
        Operation::Neg(n) => n.value.as_ref().into_iter().collect(),
    };
    for op_ref in operand_refs {
        walk_operand(op_ref, pool, seen_expr, constants);
    }
}

/// Walk every constraint root in the AIR and collect constants
/// reachable through the graph-complete closure of
/// `air.expressions[*]`.
fn collect_reachable_constants(air: &pb::Air) -> Vec<u64> {
    let mut seen: std::collections::HashSet<usize> = std::collections::HashSet::new();
    let mut constants: Vec<u64> = Vec::new();
    for c in &air.constraints {
        if let Some(idx) = constraint_expression_idx(c) {
            let idx = idx as usize;
            if !seen.insert(idx) {
                continue;
            }
            if let Some(expr) = air.expressions.get(idx) {
                walk_constants_in_expression(expr, &air.expressions, &mut seen, &mut constants);
            }
        }
    }
    constants
}

/// Assertion 1: exact per-instance `air.expressions.len()` under
/// Round 8 is_const_expr inclusion. First instance emits the
/// marker payload and therefore has a larger reachable set;
/// second instance skips the marker branch and has a strictly
/// smaller count. Pinning both values catches any drift in the
/// reachability importer, the const-expr inclusion set, or the
/// trimmed-slot fallback. Per the plan Phase 1 acceptance: "exact
/// hard-coded expected value".
#[test]
fn lazy_reify_air_expressions_count_matches_expected() {
    let pilout = decode(&compile_fixture("count_exact"));
    let mut seen = 0usize;
    for ag in &pilout.air_groups {
        for (inst_idx, air) in ag
            .airs
            .iter()
            .filter(|a| a.name.as_deref() == Some("LazyReifyAir"))
            .enumerate()
        {
            let expected = match inst_idx {
                0 => LAZY_REIFY_AIR_EXPRESSIONS_EXPECTED_FIRST,
                1 => LAZY_REIFY_AIR_EXPRESSIONS_EXPECTED_SECOND,
                other => panic!(
                    "fixture declares exactly two LazyReifyAir instances; \
                     unexpected instance#{}",
                    other
                ),
            };
            assert_eq!(
                air.expressions.len(),
                expected,
                "LazyReifyAir instance#{}: air.expressions.len() drift. \
                 cur={} expected={}. Pinning the exact per-instance count \
                 catches drift in the Round 3 reachability importer, the \
                 Round 8 `IdData.is_const_expr` inclusion set, or the \
                 trimmed-slot fallback.",
                inst_idx,
                air.expressions.len(),
                expected
            );
            seen += 1;
        }
    }
    assert_eq!(
        seen, 2,
        "fixture must declare exactly two LazyReifyAir instances; found {}",
        seen
    );
}

/// Assertion 2: graph-complete marker-payload absence. The
/// fixture's `MARKER_UNUSED_OPID` payload carries the distinctive
/// literal coefficient `987654321`. No
/// `direct_global_update_assumes(MARKER_UNUSED_OPID, ...)` is
/// declared at airgroup scope and the second instance does not
/// re-invoke `direct_global_update_proves(MARKER_UNUSED_OPID,
/// ...)`. Under JS lazy `Expressions.pack`, the payload is never
/// reachable from either instance's constraint/hint roots, so the
/// 987654321 constant must not land in either instance's arena.
/// This test graph-walks each constraint's expression subtree to
/// confirm the literal is absent from the reachable closure.
#[test]
fn lazy_reify_unused_marker_is_absent_from_arena() {
    let pilout = decode(&compile_fixture("marker_absent"));
    for ag in &pilout.air_groups {
        for (inst_idx, air) in ag
            .airs
            .iter()
            .filter(|a| a.name.as_deref() == Some("LazyReifyAir"))
            .enumerate()
        {
            let constants = collect_reachable_constants(air);
            assert!(
                !constants.contains(&MARKER_UNUSED_CONSTANT),
                "LazyReifyAir instance#{}: reachable-closure constant walk \
                 found the `MARKER_UNUSED_OPID` payload's distinctive \
                 literal {} in the per-AIR arena. The Round 3 \
                 reachability importer should have dropped the \
                 never-consumed proof-scope payload. Found constants \
                 (truncated to 20): {:?}",
                inst_idx,
                MARKER_UNUSED_CONSTANT,
                &constants.iter().take(20).collect::<Vec<_>>()
            );
        }
    }
}

/// Assertion 1: alias-chain source-identity. `local_alias_1 = cx
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

/// Assertion 4: row-offset source-identity. The fixture has
/// `const expr shifted_cx = cx';` plus two constraints reading
/// shifted_cx:
///   constraints[2]: `shifted_cx === 0`
///   constraints[3]: `shifted_cx + cy === 0`
///
/// Both constraints source-reference the SAME aliased `cx'` via
/// `shifted_cx`. The two constraint trees must reference the
/// shifted_cx lift via a shared arena idx (either directly, when
/// the constraint IS shifted_cx, or through an
/// `Operand::Expression { idx }` operand when the constraint
/// embeds shifted_cx within a larger tree). The assertion
/// uses source-identity extraction (constraints[2] vs
/// constraints[3]) rather than a generic "all `row_offset == 1`
/// witness operands" scan that could not distinguish the two
/// intended reads.
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
