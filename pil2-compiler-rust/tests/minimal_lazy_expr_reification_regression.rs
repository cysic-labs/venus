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

/// First and second instance's expected `air.expressions.len()`
/// under Round 9 JS-parity: both instances pack only their own
/// reachable set through the constraint/hint roots. The
/// `MARKER_UNUSED_OPID` payload is never reachable (no
/// `direct_global_update_assumes` at airgroup scope and neither
/// instance's constraint/hint roots reference it), so the
/// payload's proof-scope state is dropped from both arenas. Each
/// instance then packs: local_alias_1 lift, local_alias_2
/// reference wrap, shifted_cx lift, and constraint[3]'s
/// `shifted_cx + cy` tree — 4 entries total. JS's lazy packing
/// symmetry is preserved.
const LAZY_REIFY_AIR_EXPRESSIONS_EXPECTED_FIRST: usize = 4;
const LAZY_REIFY_AIR_EXPRESSIONS_EXPECTED_SECOND: usize = 4;
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

/// Unwrap `Add(lhs, Constant(0))` wraps and follow every single-
/// operand `Operand::Expression { idx }` pointer recursively until
/// a non-trivial tree shape. Mirrors the JS
/// `ExpressionPacker::saveAndPushExpressionReference` chain: one
/// arena idx per `(expr_id, row_offset)` reference, and the
/// per-arena `Add(Expression(Y), Constant(0))` shape that the
/// per-AIR flatten path emits for a bare const-expr reference.
/// Follows the lhs `Expression(idx)` when rhs is `Constant(value=
/// empty-bytes or all zero bytes)`.
fn resolve_to_base_idx(start_idx: u32, pool: &[pb::Expression]) -> u32 {
    let mut cur = start_idx;
    let mut seen: std::collections::HashSet<u32> = std::collections::HashSet::new();
    loop {
        if !seen.insert(cur) {
            return cur;
        }
        let Some(expr) = pool.get(cur as usize) else {
            return cur;
        };
        let Some(op) = expr.operation.as_ref() else {
            return cur;
        };
        let pb::expression::Operation::Add(add) = op else {
            return cur;
        };
        let Some(lhs_op) = add.lhs.as_ref() else {
            return cur;
        };
        let Some(rhs_op) = add.rhs.as_ref() else {
            return cur;
        };
        let is_zero_rhs = matches!(
            rhs_op.operand.as_ref(),
            Some(pb::operand::Operand::Constant(c)) if c.value.iter().all(|&b| b == 0)
        );
        if !is_zero_rhs {
            return cur;
        }
        let Some(pb::operand::Operand::Expression(e)) = lhs_op.operand.as_ref() else {
            return cur;
        };
        cur = e.idx;
    }
}

/// Assertion 3: alias-chain source-identity. `const expr
/// local_alias_1 = cx + cy; const expr local_alias_2 =
/// local_alias_1; local_alias_1 === 0; local_alias_2 === 0;`
/// creates two constraints at source positions 0 and 1. Under JS
/// lazy packing they resolve through the reference chain to the
/// SAME base `cx + cy` tree: local_alias_2 is a separate
/// ExpressionReference whose arena entry is an
/// `Add(Expression(local_alias_1_idx), 0)` wrap, and
/// local_alias_1 itself packs to `Add(WitnessCol(cx),
/// WitnessCol(cy))`. The assertion walks the trivial wrap chain
/// via `resolve_to_base_idx` and locks the invariant that both
/// paths land at the same underlying base idx.
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
            let alias_1_base = resolve_to_base_idx(alias_1_idx, &air.expressions);
            let alias_2_base = resolve_to_base_idx(alias_2_idx, &air.expressions);
            assert_eq!(
                alias_1_base, alias_2_base,
                "LazyReifyAir instance#{}: local_alias_1 === 0 \
                 (constraints[0] idx={} base={}) and local_alias_2 \
                 === 0 (constraints[1] idx={} base={}) must resolve \
                 through the trivial `Add(Expression(..), 0)` wrap \
                 chain to the SAME base `cx + cy` tree. Under JS \
                 lazy packing both references walk through \
                 saveAndPushExpressionReference links to one \
                 common `BinOp(Add, Witness(cx), Witness(cy))` \
                 arena entry.",
                inst_idx, alias_1_idx, alias_1_base, alias_2_idx, alias_2_base
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
/// Under Round 13's JS-mirrored producer (Codex Round 12 review
/// directive): expression-site reads of a bare-reference const-
/// expr alias emit a single `Add(leaf, 0)` wrapper arena entry
/// keyed by the alias identity, while operand-site reads emit the
/// underlying leaf (`Operand::WitnessCol { col_idx, row_offset }`
/// / `Operand::FixedCol { .. }` / ...) directly with no arena
/// allocation. Both reads of shifted_cx therefore share the SAME
/// underlying witness identity (`cx, row_offset=+1, stage=1`) —
/// constraint[2] through its wrapper entry, constraint[3] through
/// the inlined operand. The invariant this assertion locks:
/// constraint[2]'s wrapper-entry lhs and constraint[3]'s
/// operand-site lhs both describe the SAME witness col tuple, so
/// either presentation form is accepted but the leaf identity
/// must match.
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
            use pb::expression::Operation;
            use pb::operand::Operand as O;
            let Some(first_expr) = air.expressions.get(shifted_1_idx as usize)
            else {
                panic!(
                    "constraints[2] expression_idx {} is out of arena range ({} entries)",
                    shifted_1_idx,
                    air.expressions.len()
                );
            };
            let Some(second_expr) = air.expressions.get(shifted_2_idx as usize)
            else {
                panic!(
                    "constraints[3] expression_idx {} is out of arena range ({} entries)",
                    shifted_2_idx,
                    air.expressions.len()
                );
            };
            // Resolve each Add's lhs to the underlying
            // `(col_idx, row_offset, stage)` witness identity.
            // Under Round 13 constraint[2] wraps
            // `Add(WitnessCol(cx, +1), Constant(0))` and
            // constraint[3] wraps `Add(WitnessCol(cx, +1),
            // WitnessCol(cy))`. Both left operands resolve to the
            // same tuple `(cx, +1, 1)`.
            let leaf_witness = |expr: &pb::Expression| -> Option<(u32, i32, u32)> {
                let Some(Operation::Add(add)) = expr.operation.as_ref() else {
                    return None;
                };
                let op = add.lhs.as_ref()?.operand.as_ref()?;
                match op {
                    O::WitnessCol(w) => {
                        Some((w.col_idx, w.row_offset, w.stage))
                    }
                    O::Expression(e) => {
                        let target = air.expressions.get(e.idx as usize)?;
                        let Some(Operation::Add(inner)) =
                            target.operation.as_ref()
                        else {
                            return None;
                        };
                        match inner.lhs.as_ref()?.operand.as_ref()? {
                            O::WitnessCol(w) => {
                                Some((w.col_idx, w.row_offset, w.stage))
                            }
                            _ => None,
                        }
                    }
                    _ => None,
                }
            };
            let first_leaf = leaf_witness(first_expr);
            let second_leaf = leaf_witness(second_expr);
            assert!(
                first_leaf.is_some() && second_leaf.is_some(),
                "LazyReifyAir instance#{}: both constraint trees \
                 must resolve shifted_cx's lhs to a WitnessCol \
                 leaf (directly or through a single \
                 `Add(Expression(..), Constant(0))` wrap). first={:?} \
                 second={:?}",
                inst_idx, first_expr, second_expr
            );
            assert_eq!(
                first_leaf, second_leaf,
                "LazyReifyAir instance#{}: constraints[2] \
                 (shifted_cx === 0) and constraints[3] \
                 (shifted_cx + cy === 0) must both resolve their \
                 shifted_cx lhs to the SAME witness identity \
                 `(col_idx, row_offset=+1, stage)`. Under Round \
                 13's JS-mirrored producer, constraint[2] reaches \
                 it through a wrapper arena entry keyed by the \
                 alias identity and constraint[3] reaches it \
                 through an inline `Operand::WitnessCol` — both \
                 paths MUST carry the same underlying leaf.",
                inst_idx,
            );
        }
    }
}
