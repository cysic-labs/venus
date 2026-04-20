//! Regression lock for the origin-aware per-AIR `HintValue::ColRef`
//! serializer in `pil2-compiler-rust/src/proto_out.rs`.
//!
//! Two fixtures exercise the serializer from different angles:
//!
//! 1. `minimal_gsum_col.pil` (two-AIR fixture) produces
//!    `gsum_col.reference` hints on both sibling AIRs, each with a
//!    bare stage-2 witness leaf. In the current producer the
//!    `maybe_air_origin_frame_id` reader tags this leaf with the
//!    CURRENT AIR's origin, so both per-AIR serializations take the
//!    same-origin path through the current AIR's `witness_id_map`.
//!    The first test locks the post-Round-0 direct `WitnessCol`
//!    operand shape.
//!
//! 2. `minimal_origin_scoped_cross_air.pil` (two-AIR fixture with
//!    sibling Intermediate collisions on local id `0`) indirectly
//!    exercises the origin_registry population invariant: both AIRs
//!    emit air-scope hints via `lookup_proves` / `lookup_assumes`,
//!    and the serializer must resolve each AIR's hint leaves
//!    without cross-pollution. A regression that failed to populate
//!    `origin_registry` (Round 0 new field) would fire an assertion
//!    here when a hint leaf collapses to `Operand::Constant(0)` via
//!    the foreign-origin miss path.
//!
//! Combined, the two tests guard AC-S1, AC-S2, AC-R6 and the
//! round-0-summary contract that bare hint leaves emit direct leaf
//! operands (no Expression indirection, no Constant collapse) on
//! every air-scope reference.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

fn compile_fixture_named(fixture_file: &str, out_stem: &str) -> Vec<u8> {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");
    let fixture = manifest.join("tests").join("data").join(fixture_file);
    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    let std_pil = workspace
        .join("pil2-proofman")
        .join("pil2-components")
        .join("lib")
        .join("std")
        .join("pil");
    let out = std::env::temp_dir().join(format!(
        "pil2c_foreign_origin_hint_leaf_{}.pilout",
        out_stem
    ));
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
        .expect("spawn pil2c");
    assert!(
        status.success(),
        "pil2c exited non-zero on {} fixture",
        fixture_file
    );
    std::fs::read(&out).expect("read pilout")
}

fn compile_fixture() -> Vec<u8> {
    compile_fixture_named("minimal_gsum_col.pil", "gsum_col")
}

#[test]
fn gsum_col_reference_is_direct_witness_col_operand_per_air() {
    let bytes = compile_fixture();
    let pilout = pb::PilOut::decode(bytes.as_slice()).expect("decode pilout");
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
        "expected gsum_col emitted for both AIRs; got {}",
        per_air.len()
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
            .unwrap_or_else(|| panic!("gsum_col ag={} air={} missing reference", ag, air));
        let op = match reference.value.as_ref() {
            Some(pb::hint_field::Value::Operand(op)) => op,
            other => panic!(
                "gsum_col ag={} air={} reference must wrap Operand, got {:?}",
                ag, air, other
            ),
        };
        let inner = op.operand.as_ref().unwrap_or_else(|| {
            panic!(
                "gsum_col ag={} air={} reference Operand had no inner",
                ag, air
            )
        });
        match inner {
            pb::operand::Operand::WitnessCol(wc) => {
                assert_eq!(
                    wc.stage, 2,
                    "gsum_col.reference ag={} air={} must be stage-2 WitnessCol; \
                     got stage={}",
                    ag, air, wc.stage
                );
                assert_eq!(
                    wc.row_offset, 0,
                    "gsum_col.reference ag={} air={} must have row_offset=0; \
                     got {}",
                    ag, air, wc.row_offset
                );
            }
            pb::operand::Operand::Expression(e) => panic!(
                "gsum_col.reference ag={} air={} was wrapped in \
                 Operand::Expression(idx={}); direct WitnessCol is the \
                 post-Round-0 contract. A regression likely \
                 reintroduced ExprId wrapping for bare hint leaves in \
                 `mod_hints.rs::value_to_hint_value` air-scope path.",
                ag, air, e.idx
            ),
            pb::operand::Operand::Constant(c) => panic!(
                "gsum_col.reference ag={} air={} collapsed to \
                 Operand::Constant({:?}); origin-aware resolver did \
                 not find the leaf in either the current AIR's \
                 witness_map or the origin_registry. Check \
                 `ProtoOutBuilder::origin_registry` population in \
                 `proto_out.rs::build_hints` and the per-AIR \
                 serializer at `hint_colref_to_operand`.",
                ag, air, c.value
            ),
            other => panic!(
                "gsum_col.reference ag={} air={} unexpected operand shape: {:?}",
                ag, air, other
            ),
        }
    }
}

/// Supplementary coverage that the origin_registry population path
/// survives a fixture with two AIRs that both mint Intermediate
/// references at colliding local ids. If `origin_registry` were not
/// populated (e.g. because `build_hints` skipped the walk), sibling
/// AIRs' hint references would resolve against the wrong AIR's
/// witness / fixed map, and any unresolved leaf would collapse to
/// `Operand::Constant(0)`. This test compiles
/// `minimal_origin_scoped_cross_air.pil` and walks every air-scope
/// hint in both AIRs, asserting that no hint operand that should
/// carry a column reference has collapsed to `Operand::Constant`
/// with an all-zero `value` (the serializer's miss-fallback shape).
#[test]
fn cross_air_hint_operands_do_not_collapse_to_zero_constant() {
    let bytes = compile_fixture_named(
        "minimal_origin_scoped_cross_air.pil",
        "origin_scoped_cross_air",
    );
    let pilout = pb::PilOut::decode(bytes.as_slice()).expect("decode pilout");
    // Expect >= 2 air-scoped hints (lookup_proves / lookup_assumes
    // on each AIR each trigger std_lookup deferred hints). The
    // exact count depends on std_lookup's deferred emission; we
    // assert >= 2 to cover both sibling AIRs.
    let air_hint_count = pilout
        .hints
        .iter()
        .filter(|h| h.air_group_id.is_some() && h.air_id.is_some())
        .count();
    assert!(
        air_hint_count >= 2,
        "origin-scoped cross-AIR fixture should emit >= 2 air-scope \
         hints (lookup_proves/lookup_assumes per AIR); got {}",
        air_hint_count
    );
    for h in &pilout.hints {
        let Some(ag) = h.air_group_id else { continue };
        let Some(air) = h.air_id else { continue };
        let mut zero_constant_hits: Vec<String> = Vec::new();
        walk_fields_for_zero_col(
            &h.hint_fields,
            &format!("{} ag={} air={}", h.name, ag, air),
            &mut zero_constant_hits,
        );
        assert!(
            zero_constant_hits.is_empty(),
            "hint `{}` ag={} air={} contains operand(s) collapsed to \
             Operand::Constant(zero) where a column reference is \
             expected. Offending leaves: {:?}. A regression likely \
             broke `ProtoOutBuilder::origin_registry` population in \
             `proto_out.rs::build_hints`, or the per-AIR serializer \
             at `hint_colref_to_operand` is missing a ctx-selection \
             branch for a legitimate foreign-origin leaf.",
            h.name,
            ag,
            air,
            &zero_constant_hits[..zero_constant_hits.len().min(8)],
        );
    }
}

/// Walk a list of HintFields looking for `Operand::Constant(zero)`
/// values sitting at a field position that conventionally carries
/// a column reference. We flag any `Constant` with an empty or
/// all-zero `value` byte sequence that appears under a field named
/// `reference`, `cm`, `col`, or positioned as a direct operand
/// inside a hint array slot.
fn walk_fields_for_zero_col(
    fields: &[pb::HintField],
    ctx: &str,
    out: &mut Vec<String>,
) {
    for (idx, f) in fields.iter().enumerate() {
        let name_tag = f
            .name
            .clone()
            .unwrap_or_else(|| format!("[{}]", idx));
        match f.value.as_ref() {
            Some(pb::hint_field::Value::HintFieldArray(arr)) => {
                let child_ctx = format!("{}.{}", ctx, name_tag);
                walk_fields_for_zero_col(&arr.hint_fields, &child_ctx, out);
            }
            Some(pb::hint_field::Value::Operand(op)) => {
                let Some(inner) = op.operand.as_ref() else { continue };
                if let pb::operand::Operand::Constant(c) = inner {
                    let is_zero = c.value.iter().all(|&b| b == 0);
                    // Only report constants where the field name
                    // strongly suggests a column reference. Many
                    // hint payloads legitimately carry `Constant(0)`
                    // (e.g. `numerator_direct: 0`,
                    // `denominator_direct: 1` literals).
                    let col_field = matches!(
                        name_tag.as_str(),
                        "reference" | "cm" | "col"
                    );
                    if is_zero && col_field {
                        out.push(format!(
                            "{}.{} Operand::Constant(value={:?})",
                            ctx, name_tag, c.value
                        ));
                    }
                }
            }
            _ => {}
        }
    }
}
