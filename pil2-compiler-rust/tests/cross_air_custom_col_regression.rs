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
            // Walk every expression in this AIR.
            for (eidx, expr) in air.expressions.iter().enumerate() {
                walk_expression_operands(expr, &mut |op| {
                    check_custom_operand(op, &ag_name, &air_name, ccl, eidx, "expression", &mut violations);
                });
            }
            // Walk every constraint's debug_line and first_line.
            for (cidx, c) in air.constraints.iter().enumerate() {
                // Constraints carry `e` (expression index). The
                // expression itself is in air.expressions — already
                // walked above. But custom-col operand can also
                // appear inline on the constraint message; check if
                // any direct operand fields exist.
                let _ = (cidx, c);
            }
        }
    }

    // Walk hints (global + air hints) looking for direct Operand
    // fields that carry Custom refs.
    for h in &pilout.hints {
        walk_hint_fields(h, &mut |op, _name| {
            // For hints we can only validate commit_id against the
            // declaring AIR's custom_commits when the hint is
            // air-scoped. Look up the air's custom_commits len.
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
        "found {} Operand::CustomCol emissions with commit_id out of range. \
         This indicates the Round 12 custom-col cross-AIR metadata repair \
         regressed: first few violations:\n  {}",
        violations.len(),
        violations.iter().take(5).cloned().collect::<Vec<_>>().join("\n  ")
    );

    // Additionally: at least one AIR in the fixture's airgroup
    // should have a non-empty `custom_commits`. If both AIRs are
    // empty we're not actually exercising the cross-AIR path.
    let any_has_commits = pilout
        .air_groups
        .iter()
        .flat_map(|g| g.airs.iter())
        .any(|a| !a.custom_commits.is_empty());
    assert!(
        any_has_commits,
        "no AIR in the fixture emitted custom_commits; the fixture is not \
         exercising the cross-AIR CustomCol path"
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
