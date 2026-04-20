//! Regression for the producer invariant that air-scope bare hint
//! column references do NOT push anonymous `Add(leaf, Constant(0))`
//! wrappers into the per-AIR expressions arena (AC-P2).
//!
//! Background: pil2-compiler-rust historically routed air-scope
//! bare `Value::ColRef` hint arguments through a catch-all arm in
//! `mod_hints.rs::value_to_hint_value` that pushed the leaf into
//! `air_expression_store` as an anonymous wrapper and returned
//! `HintValue::ExprId(idx)`. That behavior inflated the first 48+
//! positions of the trio AIRs' per-AIR `expressions` arena with
//! canonical `Add(Col, Constant(0))` wrappers, shifting
//! `expressionsCode[0].expId` far above golden and keeping the
//! three-AIR shape gate RED on `pil2-stark-setup`.
//!
//! The current producer routes air-scope bare `Value::ColRef`
//! directly to `HintValue::ColRef`, which the per-AIR serializer
//! resolves through an origin-aware resolver that consults either
//! the current AIR's translation maps (same-origin) or an
//! `origin_registry` keyed by `origin_frame_id` (foreign-origin).
//!
//! This test asserts that, after compiling the full Zisk PIL, the
//! three named trio AIRs (`VirtualTable0`, `VirtualTable1`,
//! `SpecifiedRanges`) carry ZERO `Add(Col, Constant(0))`
//! wrapper-shape entries in the prefix
//! `[0..first_labeled_constraint.expression_idx)` of their per-AIR
//! `expressions[]` arena. A regression that reintroduces anonymous
//! hint-leaf wrapping at `mod_hints.rs:134` fires the assertion
//! immediately.
//!
//! The test is skipped when `pil/zisk.pil` is not present or the
//! standard PIL include root is missing, so it cannot create false
//! positives in tree shapes that do not carry the Zisk build.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

fn locate_workspace() -> Option<(PathBuf, PathBuf, PathBuf)> {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent()?.to_path_buf();
    let zisk_pil = workspace.join("pil").join("zisk.pil");
    let std_pil = workspace
        .join("pil2-proofman")
        .join("pil2-components")
        .join("lib")
        .join("std")
        .join("pil");
    if zisk_pil.is_file() && std_pil.is_dir() {
        Some((workspace, zisk_pil, std_pil))
    } else {
        None
    }
}

fn compile_zisk() -> Option<Vec<u8>> {
    let (workspace, zisk_pil, std_pil) = locate_workspace()?;
    let includes = format!(
        "{},{},{},{}",
        workspace.join("pil").display(),
        std_pil.display(),
        workspace.join("state-machines").display(),
        workspace.join("precompiles").display(),
    );
    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    let out = std::env::temp_dir().join("pil2c_bare_hint_leaf_no_arena_inflation.pilout");
    let fixed_dir = std::env::temp_dir().join("pil2c_bare_hint_leaf_no_arena_inflation_fixed");
    let _ = std::fs::remove_file(&out);
    let _ = std::fs::remove_dir_all(&fixed_dir);
    std::fs::create_dir_all(&fixed_dir).ok()?;
    let status = Command::new(&bin)
        .arg(&zisk_pil)
        .arg("-I")
        .arg(&includes)
        .arg("-o")
        .arg(&out)
        .arg("-u")
        .arg(&fixed_dir)
        .arg("-O")
        .arg("fixed-to-file")
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .status()
        .ok()?;
    if !status.success() {
        return None;
    }
    std::fs::read(&out).ok()
}

fn is_bare_col_wrapper(expr: &pb::Expression) -> bool {
    use pb::expression::Operation;
    use pb::operand::Operand as O;
    let Some(Operation::Add(add)) = expr.operation.as_ref() else {
        return false;
    };
    let rhs_is_zero = add
        .rhs
        .as_ref()
        .and_then(|r| r.operand.as_ref())
        .map(|o| matches!(o, O::Constant(c) if c.value.iter().all(|&b| b == 0)))
        .unwrap_or(false);
    if !rhs_is_zero {
        return false;
    }
    matches!(
        add.lhs.as_ref().and_then(|l| l.operand.as_ref()),
        Some(O::WitnessCol(_))
            | Some(O::FixedCol(_))
            | Some(O::PeriodicCol(_))
            | Some(O::AirValue(_))
            | Some(O::CustomCol(_))
    )
}

fn first_constraint_expression_idx(air: &pb::Air) -> Option<u32> {
    air.constraints
        .first()
        .and_then(|c| c.constraint.as_ref())
        .and_then(|cv| match cv {
            pb::constraint::Constraint::EveryRow(r) => r.expression_idx.as_ref(),
            pb::constraint::Constraint::FirstRow(r) => r.expression_idx.as_ref(),
            pb::constraint::Constraint::LastRow(r) => r.expression_idx.as_ref(),
            pb::constraint::Constraint::EveryFrame(r) => r.expression_idx.as_ref(),
        })
        .map(|e| e.idx)
}

#[test]
fn trio_air_prefix_carries_no_bare_col_wrappers() {
    let Some(pilout_bytes) = compile_zisk() else {
        eprintln!(
            "bare_hint_leaf_no_arena_inflation: Zisk build artifacts \
             not present in this tree; skipping. This test only runs \
             inside the main Venus workspace."
        );
        return;
    };
    let pilout =
        pb::PilOut::decode(pilout_bytes.as_slice()).expect("decode pilout");
    let trio = ["VirtualTable0", "VirtualTable1", "SpecifiedRanges"];
    let mut seen: std::collections::HashSet<&str> = std::collections::HashSet::new();
    for ag in &pilout.air_groups {
        for air in &ag.airs {
            let Some(name) = air.name.as_deref() else { continue };
            if !trio.contains(&name) {
                continue;
            }
            seen.insert(name);
            let Some(first_idx) = first_constraint_expression_idx(air) else {
                panic!(
                    "trio AIR `{}` has no labeled constraint (arena.len={})",
                    name,
                    air.expressions.len()
                );
            };
            let prefix = air
                .expressions
                .iter()
                .take(first_idx as usize);
            let mut bad_positions: Vec<usize> = Vec::new();
            for (pos, expr) in prefix.enumerate() {
                if is_bare_col_wrapper(expr) {
                    bad_positions.push(pos);
                }
            }
            assert!(
                bad_positions.is_empty(),
                "AIR `{}`: found {} bare-col wrapper `Add(Col, Constant(0))` \
                 entries in the prefix `[0..{})`. First offenders: {:?}. \
                 A regression at `mod_hints.rs::value_to_hint_value` air-\
                 scope bare `Value::ColRef` handling most likely \
                 reintroduced anonymous `air_expression_store` pushes for \
                 hint-arg leaves. The invariant this test guards is that \
                 bare hint leaves must NOT inflate the per-AIR \
                 expressions arena; they resolve directly through \
                 `hint_colref_to_operand` in `proto_out.rs`.",
                name,
                bad_positions.len(),
                first_idx,
                &bad_positions[..bad_positions.len().min(8)],
            );
        }
    }
    assert_eq!(
        seen.len(),
        3,
        "expected all three trio AIRs (VirtualTable0, VirtualTable1, \
         SpecifiedRanges) in the compiled pilout; saw {:?}",
        seen
    );
}
