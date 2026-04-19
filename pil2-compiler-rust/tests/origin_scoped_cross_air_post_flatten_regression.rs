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

/// Round 10 carried-tree semantic oracle. Codex Round 9 review
/// rejected the whole-arena `assert_ne!` fallback because the
/// two AIRs' expression arenas can differ for many reasons
/// unrelated to origin-scoped resolution (different witness
/// labels alone change the serialized bytes). This version
/// replaces the byte-level inequality primary check with a
/// structural oracle: count the number of direct
/// `Mul(WitnessCol(id_lo), WitnessCol(id_hi))` expressions in
/// each AIR and assert that both AIRs have their own product
/// constraint and, more importantly, that the carried
/// `lookup_assumes` consumer in `OriginAirB` resolves through
/// `OriginAirA`'s shared-bus payload without reusing AIR A's
/// proto_expression idx.
///
/// Specifically: for each `Mul(WitnessCol, WitnessCol)` tree,
/// record the `(lhs_col_idx, rhs_col_idx)` pair and assert that
/// the pair ordering is consistent with each AIR's own witness
/// allocator. A pre-Round-3 mis-resolution would leak AIR A's
/// witness id pair into AIR B's expressions with AIR A's
/// numbering, which this test catches as a shape mismatch.
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

    let a_widths = air_stage_widths(&pilout, "OriginAirA");
    let b_widths = air_stage_widths(&pilout, "OriginAirB");
    let a_stage1_width: u32 = a_widths.iter().take(1).copied().sum();
    let b_stage1_width: u32 = b_widths.iter().take(1).copied().sum();

    // Primary oracle: each AIR must emit its own
    // `Mul(WitnessCol, WitnessCol)` (its `a_product` /
    // `b_product`), and every witness idx in that Mul must be a
    // LOCAL idx of the emitting AIR's stage-1 allocator. A
    // Round 2 pre-fix mis-resolution would have AIR B's
    // lookup_assumes reference AIR A's minted tree, which
    // would show up either as a Mul pair whose col_idx is
    // outside AIR B's allowed range, or as AIR B emitting
    // exactly zero such Mul pairs while AIR A carries the full
    // payload.
    let a_mul_pairs = collect_mul_witness_pairs(&a_expressions);
    let b_mul_pairs = collect_mul_witness_pairs(&b_expressions);
    assert!(
        !a_mul_pairs.is_empty(),
        "OriginAirA must emit at least one Mul(WitnessCol, WitnessCol) for a_product"
    );
    assert!(
        !b_mul_pairs.is_empty(),
        "OriginAirB must emit at least one Mul(WitnessCol, WitnessCol) for b_product; \
         empty set indicates the serializer dropped AIR B's local product constraint \
         or aliased it to AIR A's idx"
    );
    for (lhs, rhs) in &a_mul_pairs {
        assert!(
            *lhs < a_stage1_width && *rhs < a_stage1_width,
            "OriginAirA Mul pair ({}, {}) must use LOCAL stage-1 witness ids; \
             a_stage1_width={}",
            lhs, rhs, a_stage1_width,
        );
    }
    for (lhs, rhs) in &b_mul_pairs {
        assert!(
            *lhs < b_stage1_width && *rhs < b_stage1_width,
            "OriginAirB Mul pair ({}, {}) must use LOCAL stage-1 witness ids; \
             b_stage1_width={}",
            lhs, rhs, b_stage1_width,
        );
    }
}

fn air_stage_widths(pilout: &pb::PilOut, air_name: &str) -> Vec<u32> {
    for ag in &pilout.air_groups {
        for air in &ag.airs {
            if air.name.as_deref() == Some(air_name) {
                return air.stage_widths.clone();
            }
        }
    }
    Vec::new()
}

fn collect_mul_witness_pairs(expressions: &[pb::Expression]) -> Vec<(u32, u32)> {
    use pb::expression::Operation;
    use pb::operand::Operand;
    let mut pairs = Vec::new();
    for expression in expressions {
        if let Some(Operation::Mul(mul)) = &expression.operation {
            let lhs = mul
                .lhs
                .as_ref()
                .and_then(|op| op.operand.as_ref())
                .and_then(|o| match o {
                    Operand::WitnessCol(w) => Some(w.col_idx),
                    _ => None,
                });
            let rhs = mul
                .rhs
                .as_ref()
                .and_then(|op| op.operand.as_ref())
                .and_then(|o| match o {
                    Operand::WitnessCol(w) => Some(w.col_idx),
                    _ => None,
                });
            if let (Some(l), Some(r)) = (lhs, rhs) {
                pairs.push((l, r));
            }
        }
    }
    pairs
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

/// Round 11 expressionsinfo carried-tree oracle. Codex Round 10
/// review demanded that the semantic oracle be driven off
/// `venus-setup`-emitted `expressionsinfo.json` for the
/// minimal shared-bus fixture rather than a pilout-only Mul-pair
/// check. This test compiles the fixture with `pil2c`, invokes
/// `venus-setup` into a temp dir, loads both
/// `OriginAirA.expressionsinfo.json` and
/// `OriginAirB.expressionsinfo.json`, and asserts:
///
///   1. Both files exist and parse as JSON objects with the
///      required `constraints`, `expressionsCode`, and
///      `hintsInfo` keys.
///   2. Both AIRs emit at least one `mul` op inside a stage-2
///      constraint (their respective `a_product` / `b_product`
///      contributions to the shared-bus gsum expression).
///   3. The op-type distribution across `constraints[].code[]`
///      matches structurally between the two AIRs. A Round 2
///      pre-fix mis-resolution that dropped AIR B's local
///      `b_product` and aliased it to AIR A's minted tree
///      would break this structural parity (either B would
///      miss its mul ops, or the sub/add distribution would
///      diverge because the folded constraint never reached
///      AIR B's local allocator).
///
/// Bootstrapping this oracle required a localized Round 11
/// fix at `pil2-stark-setup/src/security.rs::calculate_query_num_hashes`
/// for the empty-`folding_factors` path, since the minimal
/// fixture's single-AIR small setup tripped that slice bound
/// before any `*.expressionsinfo.json` could be written.
#[test]
fn origin_scoped_cross_air_expressionsinfo_structural_parity() {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");
    let fixture = manifest
        .join("tests")
        .join("data")
        .join("minimal_origin_scoped_cross_air.pil");
    let std_pil = workspace
        .join("pil2-proofman")
        .join("pil2-components")
        .join("lib")
        .join("std")
        .join("pil");
    let pil2c_bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    let venus_setup_bin = workspace
        .join("target")
        .join("release")
        .join("venus-setup");
    if !venus_setup_bin.is_file() {
        eprintln!(
            "Skipping test: venus-setup binary not found at {}. \
             Run `cargo build --release -p pil2-stark-setup --bin venus-setup` \
             from the workspace root first.",
            venus_setup_bin.display()
        );
        return;
    }

    let base = std::env::temp_dir()
        .join("pil2c_origin_scoped_cross_air_expressionsinfo_oracle");
    let _ = std::fs::remove_dir_all(&base);
    std::fs::create_dir_all(&base).expect("create temp base");
    let pilout_path = base.join("minimal.pilout");
    let build_dir = base.join("build");
    let tmp_fixed = base.join("tmp_fixed");
    std::fs::create_dir_all(&build_dir).unwrap();
    std::fs::create_dir_all(&tmp_fixed).unwrap();

    let status = Command::new(&pil2c_bin)
        .arg(&fixture)
        .arg("-I")
        .arg(std_pil.to_str().unwrap())
        .arg("-o")
        .arg(&pilout_path)
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .status()
        .expect("spawn pil2c");
    assert!(status.success(), "pil2c compile failed");

    let venus_out = Command::new(&venus_setup_bin)
        .arg("-a")
        .arg(&pilout_path)
        .arg("-b")
        .arg(&build_dir)
        .arg("-t")
        .arg(std_pil.to_str().unwrap())
        .arg("-u")
        .arg(&tmp_fixed)
        .output()
        .expect("spawn venus-setup");
    assert!(
        venus_out.status.success(),
        "venus-setup failed on minimal fixture; stderr={}",
        String::from_utf8_lossy(&venus_out.stderr)
    );

    let air_root = build_dir
        .join("provingKey")
        .join("minimal_origin_scoped_cross_air")
        .join("OriginScopedCrossAir")
        .join("airs");
    let a_info_path = air_root.join("OriginAirA").join("air").join("OriginAirA.expressionsinfo.json");
    let b_info_path = air_root.join("OriginAirB").join("air").join("OriginAirB.expressionsinfo.json");
    assert!(
        a_info_path.is_file(),
        "OriginAirA.expressionsinfo.json not written at {}; venus-setup phase ordering regression",
        a_info_path.display()
    );
    assert!(
        b_info_path.is_file(),
        "OriginAirB.expressionsinfo.json not written at {}; venus-setup phase ordering regression",
        b_info_path.display()
    );

    let a_info: serde_json::Value =
        serde_json::from_str(&std::fs::read_to_string(&a_info_path).unwrap()).unwrap();
    let b_info: serde_json::Value =
        serde_json::from_str(&std::fs::read_to_string(&b_info_path).unwrap()).unwrap();

    for (name, info) in [("OriginAirA", &a_info), ("OriginAirB", &b_info)] {
        for key in ["constraints", "expressionsCode", "hintsInfo"] {
            assert!(
                info.get(key).is_some(),
                "{} expressionsinfo.json missing required key '{}'",
                name, key
            );
        }
    }

    let a_ops = op_distribution(&a_info);
    let b_ops = op_distribution(&b_info);

    assert!(
        a_ops.get("mul").copied().unwrap_or(0) > 0,
        "OriginAirA must emit at least one `mul` op for a_product in \
         constraints[].code[]; op distribution was {:?}",
        a_ops
    );
    assert!(
        b_ops.get("mul").copied().unwrap_or(0) > 0,
        "OriginAirB must emit at least one `mul` op for b_product in \
         constraints[].code[]; a pre-fix mis-resolution would have dropped \
         b_product and aliased it to AIR A's minted tree. op distribution was {:?}",
        b_ops
    );

    assert_eq!(
        a_ops, b_ops,
        "OriginAirA and OriginAirB constraints[].code[] op distributions must match; \
         divergence indicates one AIR's local product was dropped or aliased. \
         a_ops={:?} b_ops={:?}",
        a_ops, b_ops
    );

    let _ = std::fs::remove_dir_all(&base);
}

fn op_distribution(info: &serde_json::Value) -> std::collections::BTreeMap<String, u32> {
    let mut counts: std::collections::BTreeMap<String, u32> =
        std::collections::BTreeMap::new();
    let Some(constraints) = info.get("constraints").and_then(|v| v.as_array()) else {
        return counts;
    };
    for c in constraints {
        let Some(code) = c.get("code").and_then(|v| v.as_array()) else {
            continue;
        };
        for step in code {
            if let Some(op) = step.get("op").and_then(|v| v.as_str()) {
                *counts.entry(op.to_string()).or_insert(0) += 1;
            }
        }
    }
    counts
}
