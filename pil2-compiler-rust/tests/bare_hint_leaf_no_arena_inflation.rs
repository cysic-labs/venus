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

enum CompileOutcome {
    ZiskMissing,
    Pilout(Vec<u8>),
}

/// Load the workspace's `pil/zisk.pilout` produced by the real
/// build chain (`make generate-key` or a direct `pil2c` run from
/// the workspace root). Rebuilding the pilout inside the test
/// from the `pil2-compiler-rust/` cwd triggers pre-existing
/// runtime errors (`Tables.copy: src must be a fixed column`)
/// that silently drop constraints on some AIRs, producing a
/// differently-shaped artifact than production. Reading the
/// checked-out pilout instead gives the test a stable,
/// reproducible input that matches the actual build.
fn compile_zisk() -> CompileOutcome {
    let Some((workspace, _zisk_pil, _std_pil)) = locate_workspace() else {
        return CompileOutcome::ZiskMissing;
    };
    let pilout_path = workspace.join("pil").join("zisk.pilout");
    if !pilout_path.is_file() {
        eprintln!(
            "bare_hint_leaf_no_arena_inflation: `pil/zisk.pilout` \
             not found at {}; skipping. Run `make generate-key` \
             or invoke `pil2c` from the workspace root first.",
            pilout_path.display()
        );
        return CompileOutcome::ZiskMissing;
    }
    let bytes = std::fs::read(&pilout_path).expect("read zisk.pilout");
    CompileOutcome::Pilout(bytes)
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

/// AC-P1 golden targets for trio `first_constraint.expression_idx`
/// as dictated by the golden JS build (documented in
/// `temp/plan-rustify-pkgen-e2e-0420-1.md` AC-P1 and the goal
/// tracker's Ultimate Goal). The refactor that introduces late-pack
/// parity for per-AIR hint expressions in `proto_out.rs` must bring
/// these values on current pilout in line with the golden JS build.
const GOLDEN_FIRST_CONSTRAINT_EXPR_IDX: &[(&str, u32)] = &[
    ("VirtualTable0", 16),
    ("VirtualTable1", 36),
    ("SpecifiedRanges", 8),
];

#[test]
fn trio_air_prefix_carries_no_bare_col_wrappers() {
    let pilout_bytes = match compile_zisk() {
        CompileOutcome::ZiskMissing => {
            eprintln!(
                "bare_hint_leaf_no_arena_inflation: Zisk build artifacts \
                 not present in this tree; skipping. Only runs inside \
                 the main Venus workspace."
            );
            return;
        }
        CompileOutcome::Pilout(b) => b,
    };
    let pilout =
        pb::PilOut::decode(pilout_bytes.as_slice()).expect("decode pilout");
    let trio_names: std::collections::HashSet<&'static str> =
        GOLDEN_FIRST_CONSTRAINT_EXPR_IDX.iter().map(|&(n, _)| n).collect();
    let trio_expected: std::collections::HashMap<&'static str, u32> =
        GOLDEN_FIRST_CONSTRAINT_EXPR_IDX.iter().copied().collect();
    let mut seen: std::collections::HashMap<&'static str, u32> =
        std::collections::HashMap::new();
    let mut p1_failures: Vec<String> = Vec::new();
    let mut p2_failures: Vec<String> = Vec::new();
    for ag in &pilout.air_groups {
        for air in &ag.airs {
            let Some(name) = air.name.as_deref() else { continue };
            let Some(&interned) = trio_names.get(name) else { continue };
            let Some(first_idx) = first_constraint_expression_idx(air) else {
                panic!(
                    "trio AIR `{}` has no labeled constraint (arena.len={})",
                    name,
                    air.expressions.len()
                );
            };
            seen.insert(interned, first_idx);
            // AC-P1: exact match against golden.
            if let Some(&expected) = trio_expected.get(interned) {
                if first_idx != expected {
                    p1_failures.push(format!(
                        "AC-P1 AIR `{}`: first_constraint.expression_idx cur={} gold={} \
                         (arena.len={}). The golden JS build emits this constraint \
                         root at arena position {}. Current Rust position is {}. \
                         Closing this gap is the Round 1 mainline objective: \
                         JS-parity late-pack of per-AIR hint expressions in \
                         `proto_out.rs`.",
                        name, first_idx, expected, air.expressions.len(), expected, first_idx,
                    ));
                }
            }
            // AC-P2: no Add(Col, Constant(0)) wrappers before first constraint.
            let prefix = air.expressions.iter().take(first_idx as usize);
            let mut bad_positions: Vec<usize> = Vec::new();
            for (pos, expr) in prefix.enumerate() {
                if is_bare_col_wrapper(expr) {
                    bad_positions.push(pos);
                }
            }
            if !bad_positions.is_empty() {
                p2_failures.push(format!(
                    "AC-P2 AIR `{}`: {} bare-col wrapper `Add(Col, Constant(0))` \
                     entries in prefix `[0..{})`. First offenders: {:?}. \
                     A regression at `mod_hints.rs::value_to_hint_value` air-scope \
                     bare `Value::ColRef` handling most likely reintroduced anonymous \
                     `air_expression_store` pushes for hint-arg leaves.",
                    name,
                    bad_positions.len(),
                    first_idx,
                    &bad_positions[..bad_positions.len().min(8)],
                ));
            }
        }
    }
    assert_eq!(
        seen.len(),
        3,
        "expected all three trio AIRs (VirtualTable0, VirtualTable1, \
         SpecifiedRanges) in compiled pilout; saw {:?}",
        seen.keys().collect::<Vec<_>>()
    );
    assert!(
        p2_failures.is_empty(),
        "AC-P2 violations:\n{}",
        p2_failures.join("\n")
    );
    assert!(
        p1_failures.is_empty(),
        "AC-P1 violations:\n{}",
        p1_failures.join("\n")
    );
}
