//! Default-suite regression for the cross-AIR `ColRefKind::Custom`
//! metadata repair landed in Round 12.
//!
//! The fixture (`tests/data/minimal_cross_air_custom.pil`) stages a
//! two-AIR airgroup where one AIR declares a `commit stage(0)`
//! with `col <commit> X` columns, and a sibling AIR references
//! the same bus via `lookup_assumes`. The std_lookup proof-scope
//! deferred handlers reify bus operations into Horner polynomials
//! that land in every participating AIR's pilout expression store.
//! Without the Round 12 fix, the receiving AIR emits
//! `Operand::CustomCol` operands whose `id` is not in its local
//! allocator; the post-Round-11 serializer quietly papered over
//! the gap with `Constant(0)`, which kept pilout-write succeeding
//! but broke downstream consumers.
//!
//! This test walks the compiled pilout and asserts every
//! `Operand::CustomCol` everywhere (expressions, constraints, and
//! hints) has a `commit_id` that is a valid index into the emitting
//! AIR's `custom_commits` vector. The invariant fails on the
//! pre-Round-12 branch and passes after the referenced-set
//! registry lookup + per-AIR synthetic commit_id assignment land.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

#[test]
fn cross_air_custom_col_refs_have_in_range_commit_ids() {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");

    let fixture = manifest
        .join("tests")
        .join("data")
        .join("minimal_cross_air_custom.pil");
    assert!(
        fixture.is_file(),
        "missing minimal_cross_air_custom fixture at {}",
        fixture.display()
    );

    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    let std_pil = workspace
        .join("pil2-proofman")
        .join("pil2-components")
        .join("lib")
        .join("std")
        .join("pil");

    let out = std::env::temp_dir().join("pil2c_cross_air_custom_regression.pilout");
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

    assert!(
        status.success(),
        "pil2c exited non-zero on the cross-AIR CustomCol regression fixture"
    );

    let pilout_bytes = std::fs::read(&out).expect("read pilout");
    let pilout = pb::PilOut::decode(pilout_bytes.as_slice()).expect("decode pilout");

    let mut violations: Vec<String> = Vec::new();

    for (ag_idx, ag) in pilout.air_groups.iter().enumerate() {
        let ag_name = ag.name.clone().unwrap_or_else(|| format!("ag#{}", ag_idx));
        for (air_idx, air) in ag.airs.iter().enumerate() {
            let air_name = air
                .name
                .clone()
                .unwrap_or_else(|| format!("air#{}", air_idx));
            let ccl = air.custom_commits.len();
            for (eidx, expr) in air.expressions.iter().enumerate() {
                walk_expression_operands(expr, &mut |op| {
                    check_custom_operand(op, &ag_name, &air_name, ccl, eidx, "expression", &mut violations);
                });
            }
        }
    }

    for h in &pilout.hints {
        walk_hint_fields(h, &mut |op, _name| {
            if let (Some(ag_idx), Some(air_idx)) = (h.air_group_id, h.air_id) {
                let ccl = pilout
                    .air_groups
                    .get(ag_idx as usize)
                    .and_then(|g| g.airs.get(air_idx as usize))
                    .map(|a| a.custom_commits.len())
                    .unwrap_or(0);
                let ag_name = pilout
                    .air_groups
                    .get(ag_idx as usize)
                    .and_then(|g| g.name.clone())
                    .unwrap_or_else(|| format!("ag#{}", ag_idx));
                let air_name = pilout
                    .air_groups
                    .get(ag_idx as usize)
                    .and_then(|g| g.airs.get(air_idx as usize))
                    .and_then(|a| a.name.clone())
                    .unwrap_or_else(|| format!("air#{}", air_idx));
                check_custom_operand(op, &ag_name, &air_name, ccl, 0, "hint", &mut violations);
            }
        });
    }

    assert!(
        violations.is_empty(),
        "found {} Operand::CustomCol emissions with commit_id out of range: \n  {}",
        violations.len(),
        violations.iter().take(5).cloned().collect::<Vec<_>>().join("\n  ")
    );

    // ----------------------------------------------------------------
    // Round 13 tightening: pin the consumer-AIR surface explicitly.
    // ----------------------------------------------------------------
    //
    // Locate the producer (CustomProveAir, declares the `my_commit`
    // commit) and consumer (CustomAssumeAir, only emits
    // `lookup_assumes` on the same bus) by name. The pre-Round-13
    // state leaked the producer's Horner polynomial into the
    // consumer's `air_expr_store` via a proof-scope container slot
    // that survived `self.exprs.push()`. The consumer then either
    // (a) emitted `Operand::CustomCol` with out-of-range commit_id,
    // (b) crashed `venus-setup` at `pilout_info.rs:208`, or
    // (c) after the Round 11 `Operand::Constant(0)` fallback, quietly
    // downgraded the reference to `Constant(0)` at serialization.
    //
    // Post-Round-13 the consumer AIR's expression store should carry
    // **zero** `Operand::CustomCol` references — the producer's
    // custom column ids no longer cross the AIR boundary at all. The
    // producer AIR of course still emits its own in-AIR custom-col
    // operands.
    let mut producer_commits: usize = 0;
    let mut consumer_custom_ops: usize = 0;
    let mut consumer_custom_ops_in_hints: usize = 0;
    let mut consumer_expr_count: usize = 0;
    let mut producer_expr_count: usize = 0;
    let mut consumer_seen = false;
    let mut producer_seen = false;
    // Round 14: resolve the CustomAssumeAir instance to its exact
    // `(air_group_id, air_id)` tuple in the decoded pilout so the
    // hint walk below can filter by that exact tuple instead of the
    // prior "any AIR exists somewhere" check (Round 13 bug: the
    // Some-check passed for every air-scoped hint).
    let mut consumer_coords: Option<(u32, u32)> = None;
    for (ag_idx, ag) in pilout.air_groups.iter().enumerate() {
        for (air_idx, air) in ag.airs.iter().enumerate() {
            match air.name.as_deref() {
                Some("CustomProveAir") => {
                    producer_seen = true;
                    producer_commits = air.custom_commits.len();
                    producer_expr_count = air.expressions.len();
                }
                Some("CustomAssumeAir") => {
                    consumer_seen = true;
                    consumer_coords = Some((ag_idx as u32, air_idx as u32));
                    consumer_expr_count = air.expressions.len();
                    for expr in &air.expressions {
                        walk_expression_operands(expr, &mut |op| {
                            if matches!(
                                op.operand,
                                Some(pb::operand::Operand::CustomCol(_))
                            ) {
                                consumer_custom_ops += 1;
                            }
                        });
                    }
                }
                _ => {}
            }
        }
    }
    if let Some((want_ag, want_air)) = consumer_coords {
        for h in &pilout.hints {
            if h.air_group_id == Some(want_ag) && h.air_id == Some(want_air) {
                walk_hint_fields(h, &mut |op, _| {
                    if matches!(
                        op.operand,
                        Some(pb::operand::Operand::CustomCol(_))
                    ) {
                        consumer_custom_ops_in_hints += 1;
                    }
                });
            }
        }
    }
    assert!(
        producer_seen,
        "fixture did not produce a CustomProveAir instance in the decoded pilout"
    );
    assert!(
        consumer_seen,
        "fixture did not produce a CustomAssumeAir instance in the decoded pilout"
    );
    assert!(
        producer_commits >= 1,
        "CustomProveAir must retain its own custom_commits entry for `my_commit` \
         (got {}); the producer AIR should still emit its declared custom columns.",
        producer_commits,
    );
    assert_eq!(
        consumer_custom_ops, 0,
        "CustomAssumeAir emitted {} Operand::CustomCol reference(s) in its \
         expressions — this is the pre-Round-13 cross-AIR leak class. The \
         consumer AIR must not carry the producer's custom-column leaves; \
         Round 13 eliminated the leak by restricting \
         execute_air_template_call's air-expression lift to the AIR-local \
         frame range.",
        consumer_custom_ops,
    );
    assert_eq!(
        consumer_custom_ops_in_hints, 0,
        "CustomAssumeAir's air-scoped hints carry {} Operand::CustomCol \
         reference(s); same leak class.",
        consumer_custom_ops_in_hints,
    );

    // Even when the cross-AIR leak downgrades to `Operand::Constant(0)`
    // at the proto serializer (the Round 11/12 fallback), the
    // producer's Horner polynomial still lands in the consumer AIR's
    // `air.expressions` as a large expression tree. A healthy
    // consumer AIR for this minimal fixture emits only a small number
    // of expressions (own witness cols and its own bus polynomial).
    // Pre-Round-13 the consumer's expression count inflated by ~30+
    // extra entries because the proof-scope gsum container slots were
    // mirrored into its per-AIR store on exit.
    eprintln!(
        "cross_air fixture: producer_exprs={} consumer_exprs={}",
        producer_expr_count, consumer_expr_count,
    );
    assert!(
        consumer_expr_count <= 25,
        "CustomAssumeAir has {} expressions — pre-Round-13 leak class \
         would explode this count by lifting proof-scope container \
         slots (Horner polynomials etc.) into the consumer AIR's \
         air_expr_store. Post-Round-13 a consumer AIR this small \
         should carry only a handful of expressions.",
        consumer_expr_count,
    );

    let _ = std::fs::remove_file(&out);
}

fn check_custom_operand(
    op: &pb::Operand,
    ag_name: &str,
    air_name: &str,
    custom_commits_len: usize,
    idx: usize,
    kind: &str,
    violations: &mut Vec<String>,
) {
    if let Some(pb::operand::Operand::CustomCol(cc)) = &op.operand {
        let commit_id = cc.commit_id as usize;
        if commit_id >= custom_commits_len {
            violations.push(format!(
                "AIR '{}' ({}): {} #{} emits Operand::CustomCol with \
                 commit_id={} but air.custom_commits.len()={}",
                air_name, ag_name, kind, idx, commit_id, custom_commits_len
            ));
        }
    }
}

fn walk_expression_operands<F: FnMut(&pb::Operand)>(
    expr: &pb::Expression,
    visit: &mut F,
) {
    use pb::expression::Operation;
    match &expr.operation {
        Some(Operation::Add(a)) => {
            if let Some(op) = &a.lhs {
                visit(op);
            }
            if let Some(op) = &a.rhs {
                visit(op);
            }
        }
        Some(Operation::Sub(s)) => {
            if let Some(op) = &s.lhs {
                visit(op);
            }
            if let Some(op) = &s.rhs {
                visit(op);
            }
        }
        Some(Operation::Mul(m)) => {
            if let Some(op) = &m.lhs {
                visit(op);
            }
            if let Some(op) = &m.rhs {
                visit(op);
            }
        }
        Some(Operation::Neg(n)) => {
            if let Some(op) = &n.value {
                visit(op);
            }
        }
        None => {}
    }
}

fn walk_hint_fields<F: FnMut(&pb::Operand, Option<&str>)>(
    h: &pb::Hint,
    visit: &mut F,
) {
    for hf in &h.hint_fields {
        walk_hint_field(hf, visit);
    }
}

fn walk_hint_field<F: FnMut(&pb::Operand, Option<&str>)>(
    hf: &pb::HintField,
    visit: &mut F,
) {
    match hf.value.as_ref() {
        Some(pb::hint_field::Value::Operand(op)) => {
            visit(op, hf.name.as_deref());
        }
        Some(pb::hint_field::Value::HintFieldArray(arr)) => {
            for sub in &arr.hint_fields {
                walk_hint_field(sub, visit);
            }
        }
        _ => {}
    }
}
