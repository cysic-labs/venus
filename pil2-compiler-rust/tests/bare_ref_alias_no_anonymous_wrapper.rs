//! Round 13 per Codex Round 12 review: serializer regression that
//! asserts the same-origin unresolved-reference helper in
//! `pil2-compiler-rust/src/proto_out.rs` emits bare-reference
//! const-expr alias operand sites as direct leaf operands (no
//! anonymous `Add(leaf, 0)` wrapper arena entry) while still
//! letting expression-site reads land one alias-keyed wrapper
//! entry. Compiles `minimal_lazy_expr_reification.pil` and checks
//! the per-AIR arena head of both `LazyReifyAir` instances:
//!
//! 1. No arena entry before the first labeled constraint's
//!    expression carries the same `(col_idx, row_offset=+1,
//!    stage)` witness tuple twice — i.e. there is at most one
//!    `Add(WitnessCol(cx, +1), Constant(0))` wrapper that
//!    constraint[2] binds, and constraint[3]'s inline lhs does
//!    NOT consume a separate leaf-wrapper arena entry.
//! 2. constraint[3]'s top-level arena entry embeds the
//!    `shifted_cx = cx'` leaf directly via
//!    `Operand::WitnessCol { col_idx, row_offset=+1 }`, not
//!    through an `Operand::Expression { idx }` pointer.
//!
//! If a producer regression reintroduces per-operand
//! `Add(leaf, 0)` leaf-wrapper emission at operand sites, the
//! first assertion fires with an extra duplicate wrapper entry
//! and the second fires on an unexpected `Operand::Expression`.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

fn compile_fixture() -> Vec<u8> {
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
    let out = std::env::temp_dir().join("pil2c_bare_ref_alias_no_anonymous_wrapper.pilout");
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

/// Walk an arena entry and, if it is the canonical single-leaf
/// wrapper `Add(WitnessCol { col_idx, row_offset, stage },
/// Constant(zero))`, return the witness tuple. Otherwise return
/// None.
fn wrapper_witness_tuple(
    expr: &pb::Expression,
) -> Option<(u32, i32, u32)> {
    use pb::expression::Operation;
    use pb::operand::Operand as O;
    let Some(Operation::Add(add)) = expr.operation.as_ref() else {
        return None;
    };
    let is_zero = matches!(
        add.rhs.as_ref()?.operand.as_ref()?,
        O::Constant(c) if c.value.iter().all(|&b| b == 0)
    );
    if !is_zero {
        return None;
    }
    match add.lhs.as_ref()?.operand.as_ref()? {
        O::WitnessCol(w) => Some((w.col_idx, w.row_offset, w.stage)),
        _ => None,
    }
}

/// Assertion 1: a bare-reference const-expr alias generates at
/// most one `Add(WitnessCol { col, +1, stage }, 0)` wrapper
/// arena entry per instance — not one per operand-site reference.
/// Under Round 13's producer the operand-site optimization routes
/// references via `leaf_to_air_operand(...)` directly, so
/// constraint[3]'s `shifted_cx + cy` does NOT consume an extra
/// leaf-wrapper slot.
#[test]
fn bare_ref_alias_emits_single_wrapper_per_instance() {
    let bytes = compile_fixture();
    let pilout = pb::PilOut::decode(bytes.as_slice()).expect("decode pilout");
    for ag in &pilout.air_groups {
        for (inst_idx, air) in ag
            .airs
            .iter()
            .filter(|a| a.name.as_deref() == Some("LazyReifyAir"))
            .enumerate()
        {
            // Collect every arena entry that is the canonical
            // `Add(WitnessCol { col_idx=0, row_offset=+1,
            // stage=1 }, Constant(0))` wrapper — the shape
            // produced by a shifted_cx alias wrapper.
            let mut count_shifted_cx_wrappers = 0;
            for expr in &air.expressions {
                if let Some((col_idx, row_offset, stage)) =
                    wrapper_witness_tuple(expr)
                {
                    if col_idx == 0 && row_offset == 1 && stage == 1 {
                        count_shifted_cx_wrappers += 1;
                    }
                }
            }
            assert!(
                count_shifted_cx_wrappers <= 1,
                "LazyReifyAir instance#{}: expected at most ONE \
                 `Add(WitnessCol(cx, +1), Constant(0))` wrapper \
                 arena entry (from constraint[2]'s expression-site \
                 shifted_cx read); found {} such wrappers. Round \
                 13 routes operand-site bare-ref alias references \
                 through `leaf_to_air_operand` directly so \
                 constraint[3]'s lhs no longer consumes a \
                 duplicate wrapper entry.",
                inst_idx, count_shifted_cx_wrappers,
            );
        }
    }
}

/// Assertion 2: constraint[3]'s top-level arena entry embeds the
/// `shifted_cx = cx'` leaf directly via `Operand::WitnessCol {
/// col_idx, row_offset=+1, stage }` on the Add's lhs. A silent
/// regression that reintroduces per-operand `Add(leaf, 0)`
/// wrapping would show up as an `Operand::Expression { idx }`
/// pointing at a leaf-wrapper arena entry.
#[test]
fn bare_ref_alias_compound_operand_emits_direct_leaf() {
    let bytes = compile_fixture();
    let pilout = pb::PilOut::decode(bytes.as_slice()).expect("decode pilout");
    use pb::expression::Operation;
    use pb::operand::Operand as O;
    for ag in &pilout.air_groups {
        for (inst_idx, air) in ag
            .airs
            .iter()
            .filter(|a| a.name.as_deref() == Some("LazyReifyAir"))
            .enumerate()
        {
            assert!(
                air.constraints.len() >= 4,
                "LazyReifyAir instance#{}: expected >= 4 constraints",
                inst_idx
            );
            let c3_idx = air.constraints[3]
                .constraint
                .as_ref()
                .and_then(|cv| match cv {
                    pb::constraint::Constraint::EveryRow(r) => {
                        r.expression_idx.as_ref()
                    }
                    pb::constraint::Constraint::FirstRow(r) => {
                        r.expression_idx.as_ref()
                    }
                    pb::constraint::Constraint::LastRow(r) => {
                        r.expression_idx.as_ref()
                    }
                    pb::constraint::Constraint::EveryFrame(r) => {
                        r.expression_idx.as_ref()
                    }
                })
                .expect("constraint[3] must have expression_idx")
                .idx;
            let c3_expr = air
                .expressions
                .get(c3_idx as usize)
                .expect("constraint[3] expression in arena");
            let Some(Operation::Add(add)) = c3_expr.operation.as_ref() else {
                panic!(
                    "LazyReifyAir instance#{}: constraint[3] expr is not an Add: {:?}",
                    inst_idx, c3_expr
                );
            };
            let lhs = add
                .lhs
                .as_ref()
                .and_then(|op| op.operand.as_ref())
                .expect("Add.lhs present");
            match lhs {
                O::WitnessCol(w) => {
                    assert_eq!(
                        (w.col_idx, w.row_offset, w.stage),
                        (0u32, 1i32, 1u32),
                        "LazyReifyAir instance#{}: constraint[3] lhs \
                         must be WitnessCol(cx, row_offset=+1, \
                         stage=1); got WitnessCol(col_idx={}, \
                         row_offset={}, stage={}).",
                        inst_idx, w.col_idx, w.row_offset, w.stage
                    );
                }
                O::Expression(e) => {
                    panic!(
                        "LazyReifyAir instance#{}: constraint[3] lhs \
                         is Operand::Expression {{ idx: {} }} — a \
                         leaf-wrapper arena entry. Round 13 operand-\
                         site bare-ref alias path must emit direct \
                         Operand::WitnessCol, not a wrapper idx.",
                        inst_idx, e.idx
                    );
                }
                other => panic!(
                    "LazyReifyAir instance#{}: constraint[3] lhs \
                     unexpected operand shape: {:?}",
                    inst_idx, other
                ),
            }
        }
    }
}
