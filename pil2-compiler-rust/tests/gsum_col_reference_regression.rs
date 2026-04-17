//! Regression for `gsum_col.reference` operand class across
//! sibling AIRs in the same airgroup, AND for the Round 6
//! grammar bug that let identifiers starting with the keywords
//! `continue` / `break` / `return` be silently parsed as the
//! corresponding flow-control statement followed by leftover
//! text, aborting the surrounding airtemplate body partway
//! through.
//!
//! The fixture (`tests/data/minimal_gsum_col.pil`) declares
//! `const expr continue_seq_on_l1 = 1;` inside an
//! `airtemplate GsumProvesAir` body and uses it inside an
//! `if (continue_seq_on_l1 == 1) { ... }` block. On the
//! pre-Round-6 grammar, `continue_seq_on_l1` was parsed as
//! `Statement::Continue` (matching the `continue` literal
//! without word-boundary lookahead). The unhandled Continue
//! signal escaped the airtemplate body via `signal.is_abort()`,
//! truncating the body before `lookup_proves` ran. Without
//! `lookup_proves`, the AIR emitted no `gsum_col` hint, and
//! its sibling `GsumAssumesAir` was the only AIR producing a
//! gsum_col. The post-fix test asserts BOTH AIRs emit their
//! own gsum_col with a per-AIR non-degenerate reference operand.
//!
//! Round 5 used a weaker fixture (no control-flow body, no
//! identifiers colliding with the keyword prefix) so the test
//! could not fail on either the Round 3 alias-leak class or the
//! Round 6 parser class. This Round 6 rewrite makes the test
//! fail on `HEAD 6e2a9fa0` (pre-Round-5 alias coverage) and
//! also on `HEAD b16e0865` (post-Round-5 alias coverage but
//! still pre-Round-6 grammar fix), and pass after the grammar
//! fix lands.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

/// Walk an Operand to its leaf, following `Expression` indirections
/// through the AIR's `expressions[]` table. The leaf operand is the
/// LHS of the first `Add` / `Sub` / `Mul` we encounter, recursively.
/// Returns a clone of the leaf so the caller owns it.
fn resolve_to_leaf(
    pilout: &pb::PilOut,
    ag: u32,
    air: u32,
    op: &pb::operand::Operand,
) -> pb::operand::Operand {
    let mut current = op.clone();
    let mut depth = 0;
    loop {
        depth += 1;
        if depth > 32 {
            panic!("resolve_to_leaf exceeded depth 32 on ag={} air={}", ag, air);
        }
        match current {
            pb::operand::Operand::Expression(expr_ref) => {
                let air_msg = pilout
                    .air_groups
                    .get(ag as usize)
                    .and_then(|g| g.airs.get(air as usize))
                    .unwrap_or_else(|| {
                        panic!("ag={} air={} not present in pilout.air_groups", ag, air)
                    });
                let air_expr = air_msg
                    .expressions
                    .get(expr_ref.idx as usize)
                    .unwrap_or_else(|| {
                        panic!(
                            "ag={} air={} expressions[{}] missing",
                            ag, air, expr_ref.idx
                        )
                    });
                // Walk into the first sub-operand of the expression's
                // first arithmetic node. Mul/Add/Sub all have lhs.
                let next = match air_expr.operation.as_ref() {
                    Some(pb::expression::Operation::Add(a)) => a.lhs.as_ref(),
                    Some(pb::expression::Operation::Sub(s)) => s.lhs.as_ref(),
                    Some(pb::expression::Operation::Mul(m)) => m.lhs.as_ref(),
                    Some(pb::expression::Operation::Neg(n)) => n.value.as_ref(),
                    None => panic!("ag={} air={} expressions[{}] has no operation", ag, air, expr_ref.idx),
                };
                let next_op = next
                    .and_then(|nop| nop.operand.as_ref())
                    .unwrap_or_else(|| panic!("ag={} air={} expressions[{}] sub-operand missing", ag, air, expr_ref.idx))
                    .clone();
                current = next_op;
            }
            other => return other,
        }
    }
}

#[test]
fn gsum_col_reference_emits_non_degenerate_operand_per_air() {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");

    let fixture = manifest
        .join("tests")
        .join("data")
        .join("minimal_gsum_col.pil");
    assert!(
        fixture.is_file(),
        "missing minimal_gsum_col fixture at {}; this fixture is repo-checked",
        fixture.display()
    );

    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    assert!(
        bin.is_file(),
        "CARGO_BIN_EXE_pil2c does not point at a real file: {}",
        bin.display()
    );

    let std_pil = workspace
        .join("pil2-proofman")
        .join("pil2-components")
        .join("lib")
        .join("std")
        .join("pil");
    assert!(
        std_pil.is_dir(),
        "missing std pil include dir at {}",
        std_pil.display()
    );

    let out = std::env::temp_dir().join("pil2c_gsum_col_regression.pilout");
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
        "pil2c exited non-zero on the gsum_col regression fixture"
    );
    assert!(
        out.is_file(),
        "pil2c did not produce expected output file at {}",
        out.display()
    );

    let pilout_bytes = std::fs::read(&out).expect("read pilout");
    let pilout = pb::PilOut::decode(pilout_bytes.as_slice()).expect("decode pilout");

    // Collect every gsum_col hint and assert exactly one per AIR
    // in the fixture's airgroup. The fixture has two AIRs in a
    // single airgroup; both must produce their own air-scoped
    // gsum_col hint. On the pre-Round-6 broken parser,
    // `GsumProvesAir` aborts before reaching `lookup_proves`,
    // so its gsum_col is missing entirely.
    let mut per_air: std::collections::BTreeMap<(u32, u32), &pb::Hint> =
        std::collections::BTreeMap::new();
    for h in &pilout.hints {
        if h.name != "gsum_col" {
            continue;
        }
        let ag = h.air_group_id.expect("gsum_col must be air-scoped");
        let air = h.air_id.expect("gsum_col must be air-scoped");
        per_air.insert((ag, air), h);
    }
    assert_eq!(
        per_air.len(),
        2,
        "expected gsum_col emitted for both AIRs in fixture; got {} ({:?}). \
         A count of 1 indicates the pre-Round-6 grammar bug truncated \
         GsumProvesAir's airtemplate body before lookup_proves ran.",
        per_air.len(),
        per_air.keys().collect::<Vec<_>>()
    );

    for (&(ag, air), h) in &per_air {
        let top = h
            .hint_fields
            .first()
            .unwrap_or_else(|| panic!("gsum_col ag={} air={} had no hint_fields", ag, air));
        let arr = match top.value.as_ref() {
            Some(pb::hint_field::Value::HintFieldArray(a)) => a,
            other => panic!(
                "gsum_col ag={} air={} top must be HintFieldArray, got {:?}",
                ag, air, other
            ),
        };
        let reference = arr
            .hint_fields
            .iter()
            .find(|f| f.name.as_deref() == Some("reference"))
            .unwrap_or_else(|| {
                panic!("gsum_col ag={} air={} missing 'reference' sub-field", ag, air)
            });
        let operand = match reference.value.as_ref() {
            Some(pb::hint_field::Value::Operand(op)) => op,
            other => panic!(
                "gsum_col ag={} air={} reference must wrap an Operand, got {:?}",
                ag, air, other
            ),
        };
        let inner = operand.operand.as_ref().unwrap_or_else(|| {
            panic!(
                "gsum_col ag={} air={} reference Operand had no inner",
                ag, air
            )
        });

        // Resolve the reference to its leaf operand. Round 6
        // contract requires the leaf to be a stage-2 WitnessCol
        // (`cm` stage 2). The reference may wrap that WitnessCol
        // inside an air-scope `Expression`, so recursively walk
        // any `Expression` indirections through the AIR's
        // `expressions[]` table until we reach a leaf operand.
        let leaf = resolve_to_leaf(&pilout, ag, air, inner);
        match leaf {
            pb::operand::Operand::WitnessCol(wc) => {
                assert_eq!(
                    wc.stage, 2,
                    "gsum_col.reference for ag={} air={} resolved to WitnessCol \
                     stage={} (expected stage 2). Pre-fix alias-leak class \
                     surfaced as wrong-stage cm or other operand.",
                    ag, air, wc.stage
                );
            }
            pb::operand::Operand::Constant(c) => {
                panic!(
                    "gsum_col.reference for ag={} air={} collapsed to Constant({:?}); \
                     this is the alias-leak failure mode (golden emits a stage-2 cm \
                     or an Expression wrapping it).",
                    ag, air, c.value
                );
            }
            other => panic!(
                "gsum_col.reference for ag={} air={} resolved to leaf operand {:?}; \
                 expected stage-2 WitnessCol",
                ag, air, other
            ),
        }
    }

    let _ = std::fs::remove_file(&out);
}
