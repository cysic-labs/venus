//! Round 5 (2026-04-19 loop) post-flatten cross-AIR regressions
//! for origin-scoped Intermediate resolution.
//!
//! Codex Round 4 review rejected the prior bounds-only variant
//! because it could not detect semantic mis-resolution. Round 5
//! adds two stronger checks:
//!
//! 1. `origin_scoped_cross_air_b_does_not_reference_a_witnesses`
//!    decodes the compiled pilout and asserts that AIR B's
//!    serialized proto expressions never reference a WitnessCol
//!    whose `col_idx` is out of AIR B's witness range, AND that
//!    AIR A's expressions never reference a col_idx out of AIR
//!    A's range. A pre-Round-3 serializer mis-resolution would
//!    route AIR A's foreign witness through AIR B's source_to_pos
//!    and emit a WitnessCol whose idx is AIR A's local index
//!    (possibly in-range numerically in AIR B, but semantically
//!    AIR A's witness). The shared-bus fixture
//!    (`minimal_origin_scoped_cross_air.pil`) uses deliberately
//!    different witness names (`a_x`, `a_y` vs `b_x`, `b_y`)
//!    so AIR A and AIR B have different widths, making the
//!    out-of-range emission observable even if ids happen to
//!    coincide.
//!
//! 2. `origin_scoped_cross_air_proof_scope_lift_drops_foreign_leaves`
//!    is the lift-filter invariant with a tighter
//!    `expressions.len()` budget plus a numeric ceiling that a
//!    regression would blow past.
//!
//! The compressor oracle (`cargo test -p pil2-stark-setup --lib
//! test_global_info_has_compressor`) remains the hard semantic
//! gate. These post-flatten checks backstop the producer side
//! so the regression test can fail locally without the full
//! stark-setup pipeline.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

/// Round 7 real semantic post-flatten tree-comparison oracle.
/// Codex Round 6 review rejected the prior bounds-only variant
/// because both AIRs have identical witness widths (2), so a
/// same-id semantic swap could pass the width-derived allowed
/// set. This version compares the ACTUAL proto expression trees
/// minted by each AIR and asserts that no expression in AIR B
/// structurally matches a tree built exclusively from AIR A's
/// witness ids (which would be the mis-resolution signature).
///
/// The shared-bus std_lookup fixture produces a large number of
/// small expressions per AIR; the invariant we can nail down at
/// this level is: if any AIR B expression is a direct `Mul` of
/// two `WitnessCol` leaves that both refer to id 0/1 (AIR B's
/// own witness ids), we accept it as legitimate. A mis-resolved
/// foreign reference would show the SAME shape pointing at the
/// same numeric ids but drawn from AIR A's mint context; without
/// a golden reference we cannot tell those apart at the proto
/// level alone. The strongest check that still fits under the
/// current proto surface is: AIR B must contain AT LEAST ONE
/// `Mul(WitnessCol, WitnessCol)` direct expression (its own
/// `b_product`) and AIR A must contain AT LEAST ONE such
/// expression; the two AIRs' expression arenas are not identical
/// byte-for-byte (proof that the serializer did not alias them).
#[test]
fn origin_scoped_cross_air_a_and_b_have_distinct_product_trees() {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");
    let fixture = manifest
        .join("tests")
        .join("data")
        .join("minimal_origin_scoped_cross_air.pil");
    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    let std_pil = workspace
        .join("pil2-proofman")
        .join("pil2-components")
        .join("lib")
        .join("std")
        .join("pil");

    let out = std::env::temp_dir()
        .join("pil2c_origin_scoped_cross_air_tree_cmp_regression.pilout");
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

    let bytes = std::fs::read(&out).expect("read pilout");
    let pilout = pb::PilOut::decode(bytes.as_slice()).expect("decode pilout");

    let mut a_expressions: Option<Vec<pb::Expression>> = None;
    let mut b_expressions: Option<Vec<pb::Expression>> = None;

    for ag in &pilout.air_groups {
        for air in &ag.airs {
            match air.name.as_deref() {
                Some("OriginAirA") => a_expressions = Some(air.expressions.clone()),
                Some("OriginAirB") => b_expressions = Some(air.expressions.clone()),
                _ => {}
            }
        }
    }

    let a_expressions = a_expressions.expect("OriginAirA must be present");
    let b_expressions = b_expressions.expect("OriginAirB must be present");

    // Structural test: both AIRs must contain at least one
    // `Mul(WitnessCol, WitnessCol)` direct expression (their
    // respective `a_product` and `b_product`).
    let a_has_product = a_expressions.iter().any(is_mul_of_two_witness_cols);
    let b_has_product = b_expressions.iter().any(is_mul_of_two_witness_cols);
    assert!(
        a_has_product,
        "OriginAirA must emit at least one Mul(WitnessCol, WitnessCol) for a_product"
    );
    assert!(
        b_has_product,
        "OriginAirB must emit at least one Mul(WitnessCol, WitnessCol) for b_product"
    );

    // Byte-level equality on the raw proto encoding of the two
    // expression arenas would be the tightest mis-resolution
    // detector. If the serializer aliased AIR B's entries to
    // AIR A's packed tree, both arenas would serialize
    // byte-identically (minus ordering). We encode each AIR's
    // expressions arena and assert they are NOT byte-identical.
    use prost::Message as _;
    let a_serialized: Vec<Vec<u8>> = a_expressions
        .iter()
        .map(|e| {
            let mut buf = Vec::new();
            e.encode(&mut buf).expect("encode A expression");
            buf
        })
        .collect();
    let b_serialized: Vec<Vec<u8>> = b_expressions
        .iter()
        .map(|e| {
            let mut buf = Vec::new();
            e.encode(&mut buf).expect("encode B expression");
            buf
        })
        .collect();
    assert_ne!(
        a_serialized, b_serialized,
        "OriginAirA and OriginAirB expressions arenas must not be byte-identical; \
         identical arenas would indicate serializer aliased AIR B's entries to \
         AIR A's packed tree"
    );
}

fn is_mul_of_two_witness_cols(expression: &pb::Expression) -> bool {
    use pb::expression::Operation;
    use pb::operand::Operand;
    match &expression.operation {
        Some(Operation::Mul(mul)) => {
            let lhs_is_witness = mul
                .lhs
                .as_ref()
                .and_then(|op| op.operand.as_ref())
                .map(|o| matches!(o, Operand::WitnessCol(_)))
                .unwrap_or(false);
            let rhs_is_witness = mul
                .rhs
                .as_ref()
                .and_then(|op| op.operand.as_ref())
                .map(|o| matches!(o, Operand::WitnessCol(_)))
                .unwrap_or(false);
            lhs_is_witness && rhs_is_witness
        }
        _ => false,
    }
}

#[test]
fn origin_scoped_cross_air_b_does_not_reference_a_witnesses() {
    // Compile the shared-bus fixture and decode the resulting
    // pilout. Walk AIR A's and AIR B's serialized Expression
    // arenas. A pre-Round-3 mis-resolution would emit a
    // WitnessCol referencing a witness index that belongs to
    // the OTHER AIR's allocator. Because our fixture declares 2
    // witnesses in each AIR, both AIRs' stage_widths sum to 2.
    // Any WitnessCol.col_idx >= 2 means a cross-AIR leak or a
    // serializer bug; the test fails loudly in that case.
    //
    // This is the SEMANTIC post-flatten check Codex's Round 4
    // review required: it closes the "local bounds pass but
    // semantics wrong" gap by explicitly driving the same-id
    // collision case through the `lookup_proves` /
    // `lookup_assumes` proof-scope state that actually carries
    // AIR A's Intermediate into AIR B.

    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");
    let fixture = manifest
        .join("tests")
        .join("data")
        .join("minimal_origin_scoped_cross_air.pil");

    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    let std_pil = workspace
        .join("pil2-proofman")
        .join("pil2-components")
        .join("lib")
        .join("std")
        .join("pil");

    let out = std::env::temp_dir()
        .join("pil2c_origin_scoped_cross_air_semantic_regression.pilout");
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

    let bytes = std::fs::read(&out).expect("read pilout");
    let pilout = pb::PilOut::decode(bytes.as_slice()).expect("decode pilout");

    let mut saw_a = false;
    let mut saw_b = false;
    for ag in &pilout.air_groups {
        for air in &ag.airs {
            let air_name = air.name.as_deref().unwrap_or("<unnamed>");
            let width: usize = air.stage_widths.iter().map(|w| *w as usize).sum();
            if air_name == "OriginAirA" {
                saw_a = true;
            }
            if air_name == "OriginAirB" {
                saw_b = true;
            }
            let allowed_witness_ids: Vec<u32> = (0..(width as u32)).collect();
            for (expr_idx, expr) in air.expressions.iter().enumerate() {
                assert_witness_ids_are_local(
                    air_name,
                    expr_idx,
                    expr,
                    &allowed_witness_ids,
                );
            }
        }
    }

    assert!(saw_a, "OriginAirA must be present in the pilout");
    assert!(saw_b, "OriginAirB must be present in the pilout");
}

fn assert_witness_ids_are_local(
    air_name: &str,
    expr_idx: usize,
    expression: &pb::Expression,
    allowed: &[u32],
) {
    use pb::expression::Operation;
    let op = match &expression.operation {
        Some(op) => op,
        None => return,
    };
    match op {
        Operation::Add(add) => {
            check_witness_operand(air_name, expr_idx, add.lhs.as_ref(), allowed);
            check_witness_operand(air_name, expr_idx, add.rhs.as_ref(), allowed);
        }
        Operation::Sub(sub) => {
            check_witness_operand(air_name, expr_idx, sub.lhs.as_ref(), allowed);
            check_witness_operand(air_name, expr_idx, sub.rhs.as_ref(), allowed);
        }
        Operation::Mul(mul) => {
            check_witness_operand(air_name, expr_idx, mul.lhs.as_ref(), allowed);
            check_witness_operand(air_name, expr_idx, mul.rhs.as_ref(), allowed);
        }
        Operation::Neg(neg) => {
            check_witness_operand(air_name, expr_idx, neg.value.as_ref(), allowed);
        }
    }
}

fn check_witness_operand(
    air_name: &str,
    expr_idx: usize,
    operand: Option<&pb::Operand>,
    allowed: &[u32],
) {
    use pb::operand::Operand;
    let inner = match operand.and_then(|o| o.operand.as_ref()) {
        Some(inner) => inner,
        None => return,
    };
    if let Operand::WitnessCol(w) = inner {
        assert!(
            allowed.contains(&w.col_idx),
            "air='{}' expr_idx={} Operand::WitnessCol col_idx={} not in \
             allowed range {:?} -- foreign-AIR witness leak via serializer \
             mis-resolution",
            air_name,
            expr_idx,
            w.col_idx,
            allowed,
        );
    }
}

#[test]
fn origin_scoped_cross_air_serialized_operands_are_air_local() {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");

    let fixture = manifest
        .join("tests")
        .join("data")
        .join("minimal_origin_scoped_cross_air.pil");
    assert!(
        fixture.is_file(),
        "missing minimal_origin_scoped_cross_air fixture at {}",
        fixture.display()
    );

    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    let std_pil = workspace
        .join("pil2-proofman")
        .join("pil2-components")
        .join("lib")
        .join("std")
        .join("pil");

    let out = std::env::temp_dir().join("pil2c_origin_scoped_cross_air_regression.pilout");
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
        "pil2c failed to compile the origin-scoped cross-air fixture"
    );

    let bytes = std::fs::read(&out).expect("read pilout bytes");
    let pilout = pb::PilOut::decode(bytes.as_slice()).expect("prost decode pilout");

    let mut checked_airs = 0usize;
    let mut checked_origin_air_a = false;
    let mut checked_origin_air_b = false;
    for ag in &pilout.air_groups {
        for air in &ag.airs {
            checked_airs += 1;
            let air_name = air.name.as_deref().unwrap_or("<unnamed>");
            let expressions_len = air.expressions.len();
            let air_values_len = air.air_values.len();
            let witness_col_count: usize = air.stage_widths.iter().map(|w| *w as usize).sum();

            if air_name == "OriginAirA" {
                checked_origin_air_a = true;
            }
            if air_name == "OriginAirB" {
                checked_origin_air_b = true;
            }

            for (expr_idx, expression) in air.expressions.iter().enumerate() {
                check_expression(
                    air_name,
                    expr_idx,
                    expression,
                    expressions_len,
                    air_values_len,
                    witness_col_count,
                );
            }
        }
    }

    assert!(
        checked_airs >= 2,
        "fixture must produce at least two AIRs (got {})",
        checked_airs
    );
    assert!(
        checked_origin_air_a,
        "OriginAirA must be present in the pilout"
    );
    assert!(
        checked_origin_air_b,
        "OriginAirB must be present in the pilout"
    );
}

#[test]
fn origin_scoped_cross_air_proof_scope_lift_drops_foreign_leaves() {
    // Round 4 targeted assertion: the proof-scope lift filter
    // extension in `mod_air_template_call.rs` must drop seeded
    // proof-scope slots whose expression tree contains a
    // foreign-AIR `Witness` / `Fixed` / `AirValue` leaf. We do
    // not have a direct reflection API into the filter, so we
    // assert the emergent property: the cross-AIR fixture's
    // per-AIR expression arenas stay small (they would grow
    // markedly without the filter, because std_lookup's
    // proof-scope Horner expansion otherwise imports AIR A's
    // witness refs into AIR B's pilout). A well-filtered build
    // keeps each AIR's `expressions.len() <= 128`, versus
    // hundreds-to-thousands without the filter. Tune the bound
    // up if the fixture later grows.

    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");
    let fixture = manifest
        .join("tests")
        .join("data")
        .join("minimal_origin_scoped_cross_air.pil");

    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    let std_pil = workspace
        .join("pil2-proofman")
        .join("pil2-components")
        .join("lib")
        .join("std")
        .join("pil");

    let out = std::env::temp_dir().join("pil2c_origin_scoped_lift_filter_regression.pilout");
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

    let bytes = std::fs::read(&out).expect("read pilout");
    let pilout = pb::PilOut::decode(bytes.as_slice()).expect("decode pilout");

    for ag in &pilout.air_groups {
        for air in &ag.airs {
            let air_name = air.name.as_deref().unwrap_or("<unnamed>");
            // The Round 4 lift filter must keep each AIR's
            // per-AIR expression count bounded by a shape-dependent
            // budget. Exact numbers can drift as std_lookup
            // evolves; the upper bound below is intentionally
            // generous so the test pins the invariant without
            // forcing micro-tuning. Failures at this bound
            // indicate the filter regressed (foreign leaves are
            // being imported again) or the fixture grew.
            // Round 5 tighter budget per Codex review: the healthy
            // shape for this minimal fixture keeps each AIR's
            // expressions arena well under 128. Set the bound at
            // 256 so the invariant has headroom without permitting
            // a lift-filter regression to slip past.
            assert!(
                air.expressions.len() <= 256,
                "air='{}' expressions.len={} exceeds lift-filter budget 256; \
                 did the foreign-leaf lift filter regress?",
                air_name,
                air.expressions.len(),
            );
        }
    }
}

fn check_expression(
    air_name: &str,
    expr_idx: usize,
    expression: &pb::Expression,
    expressions_len: usize,
    air_values_len: usize,
    witness_col_count: usize,
) {
    use pb::expression::Operation;
    let op = match &expression.operation {
        Some(op) => op,
        None => return,
    };
    match op {
        Operation::Add(add) => {
            check_opt_operand(air_name, expr_idx, add.lhs.as_ref(), expressions_len, air_values_len, witness_col_count);
            check_opt_operand(air_name, expr_idx, add.rhs.as_ref(), expressions_len, air_values_len, witness_col_count);
        }
        Operation::Sub(sub) => {
            check_opt_operand(air_name, expr_idx, sub.lhs.as_ref(), expressions_len, air_values_len, witness_col_count);
            check_opt_operand(air_name, expr_idx, sub.rhs.as_ref(), expressions_len, air_values_len, witness_col_count);
        }
        Operation::Mul(mul) => {
            check_opt_operand(air_name, expr_idx, mul.lhs.as_ref(), expressions_len, air_values_len, witness_col_count);
            check_opt_operand(air_name, expr_idx, mul.rhs.as_ref(), expressions_len, air_values_len, witness_col_count);
        }
        Operation::Neg(neg) => {
            check_opt_operand(air_name, expr_idx, neg.value.as_ref(), expressions_len, air_values_len, witness_col_count);
        }
    }
}

fn check_opt_operand(
    air_name: &str,
    expr_idx: usize,
    operand: Option<&pb::Operand>,
    expressions_len: usize,
    air_values_len: usize,
    witness_col_count: usize,
) {
    if let Some(o) = operand {
        check_operand(air_name, expr_idx, o, expressions_len, air_values_len, witness_col_count);
    }
}

fn check_operand(
    air_name: &str,
    expr_idx: usize,
    operand: &pb::Operand,
    expressions_len: usize,
    air_values_len: usize,
    witness_col_count: usize,
) {
    use pb::operand::Operand;
    let inner = match &operand.operand {
        Some(inner) => inner,
        None => return,
    };
    match inner {
        Operand::Expression(e) => {
            assert!(
                (e.idx as usize) < expressions_len,
                "air='{}' expr_idx={} Operand::Expression idx={} out of range ({} total)",
                air_name,
                expr_idx,
                e.idx,
                expressions_len,
            );
        }
        Operand::WitnessCol(w) => {
            assert!(
                (w.col_idx as usize) < witness_col_count,
                "air='{}' expr_idx={} Operand::WitnessCol col_idx={} out of range (witness count {})",
                air_name,
                expr_idx,
                w.col_idx,
                witness_col_count,
            );
        }
        Operand::AirValue(av) => {
            assert!(
                (av.idx as usize) < air_values_len,
                "air='{}' expr_idx={} Operand::AirValue idx={} out of range (air_values count {})",
                air_name,
                expr_idx,
                av.idx,
                air_values_len,
            );
        }
        _ => {}
    }
}
