//! Regression guard for `Operand::CustomCol.commit_id` being
//! in-range for the emitting AIR.
//!
//! Round 10 discovered that the prior `proto_out.rs` fallback
//! for unmapped custom-column ids emitted
//! `Operand::CustomCol { commit_id: 0, ... }` regardless of
//! whether the emitting AIR actually declared any custom
//! commits. Downstream `pil2-stark-setup::pilout_info` indexed
//! into `self.custom_commits[commit_id]` and panicked with
//! `index out of bounds: the len is 0 but the index is 0` for
//! any AIR whose `custom_commits` vector was empty.
//!
//! This test walks the full Zisk pilout (env-gated on
//! `ZISK_PARITY_TEST=1` to keep default `cargo test` fast) and
//! asserts every `Operand::CustomCol` has a `commit_id` that
//! is a valid index into its AIR's `custom_commits` vector.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

#[test]
fn custom_col_commit_ids_are_in_range_for_their_air() {
    if std::env::var_os("ZISK_PARITY_TEST").is_none() {
        eprintln!(
            "skipping custom_col_commit_ids_are_in_range_for_their_air; \
             set ZISK_PARITY_TEST=1 to run the full Zisk pil2c regeneration"
        );
        return;
    }

    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");

    let zisk_pil = workspace.join("pil").join("zisk.pil");
    assert!(
        zisk_pil.is_file(),
        "zisk.pil not found at {}",
        zisk_pil.display()
    );

    let include_paths = vec![
        workspace.join("pil"),
        workspace
            .join("pil2-proofman")
            .join("pil2-components")
            .join("lib")
            .join("std")
            .join("pil"),
        workspace.join("state-machines"),
        workspace.join("precompiles"),
    ];
    let include_arg = include_paths
        .iter()
        .map(|p| p.to_string_lossy().to_string())
        .collect::<Vec<_>>()
        .join(",");

    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    let out = std::env::temp_dir().join("pil2c_customcol_commit_id_test.pilout");
    let fx_dir = std::env::temp_dir().join("pil2c_customcol_commit_id_fx");
    let _ = std::fs::remove_file(&out);
    let _ = std::fs::create_dir_all(&fx_dir);

    let _output = Command::new(&bin)
        .arg(&zisk_pil)
        .arg("-I")
        .arg(&include_arg)
        .arg("-o")
        .arg(&out)
        .arg("-u")
        .arg(&fx_dir)
        .arg("-O")
        .arg("fixed-to-file")
        .output()
        .expect("failed to spawn pil2c");
    assert!(
        out.is_file(),
        "pil2c did not produce {}",
        out.display()
    );

    let bytes = std::fs::read(&out).expect("read zisk.pilout");
    let pilout = pb::PilOut::decode(bytes.as_slice()).expect("decode zisk.pilout");

    // Walk every AIR's constraints + expressions + hints and
    // check each Operand::CustomCol has commit_id in range.
    fn check_operand(
        op: &pb::Operand,
        air_name: &str,
        custom_commits_len: usize,
        violations: &mut Vec<String>,
    ) {
        if let Some(pb::operand::Operand::CustomCol(cc)) = &op.operand {
            let commit_id = cc.commit_id as usize;
            if commit_id >= custom_commits_len {
                violations.push(format!(
                    "AIR {} emits Operand::CustomCol with commit_id={} but air.custom_commits.len()={}",
                    air_name, commit_id, custom_commits_len
                ));
            }
        }
    }

    fn walk_expression(
        expr: &pb::Expression,
        air_name: &str,
        custom_commits_len: usize,
        violations: &mut Vec<String>,
    ) {
        use pb::expression::Operation;
        match &expr.operation {
            Some(Operation::Add(a)) => {
                if let Some(op) = &a.lhs {
                    check_operand(op, air_name, custom_commits_len, violations);
                }
                if let Some(op) = &a.rhs {
                    check_operand(op, air_name, custom_commits_len, violations);
                }
            }
            Some(Operation::Sub(s)) => {
                if let Some(op) = &s.lhs {
                    check_operand(op, air_name, custom_commits_len, violations);
                }
                if let Some(op) = &s.rhs {
                    check_operand(op, air_name, custom_commits_len, violations);
                }
            }
            Some(Operation::Mul(m)) => {
                if let Some(op) = &m.lhs {
                    check_operand(op, air_name, custom_commits_len, violations);
                }
                if let Some(op) = &m.rhs {
                    check_operand(op, air_name, custom_commits_len, violations);
                }
            }
            Some(Operation::Neg(n)) => {
                if let Some(op) = &n.value {
                    check_operand(op, air_name, custom_commits_len, violations);
                }
            }
            None => {}
        }
    }

    let mut violations: Vec<String> = Vec::new();
    for ag in &pilout.air_groups {
        for air in &ag.airs {
            let air_name = air.name.as_deref().unwrap_or("?").to_string();
            let ccl = air.custom_commits.len();
            for expr in &air.expressions {
                walk_expression(expr, &air_name, ccl, &mut violations);
            }
        }
    }

    assert!(
        violations.is_empty(),
        "found {} Operand::CustomCol emissions with commit_id out of range. \
         First few: {}",
        violations.len(),
        violations.iter().take(5).cloned().collect::<Vec<_>>().join(" | ")
    );
}
