//! Regression lock for the origin-aware per-AIR `HintValue::ColRef`
//! serializer in `pil2-compiler-rust/src/proto_out.rs`.
//!
//! After `mod_hints.rs::value_to_hint_value` was split so air-scope
//! bare `Value::ColRef` emits `HintValue::ColRef` directly (the
//! Round-0 change that closed the trio arena-head offset), the
//! per-AIR serializer became responsible for resolving the leaf
//! against the correct translation maps. For proof-scope container
//! witnesses (e.g. `proof.std.gsum.gsum`) referenced via hint
//! from a consuming AIR, the serializer resolves the leaf through
//! the current AIR's `witness_id_map` when the leaf's
//! `origin_frame_id` matches the current AIR's origin; otherwise
//! it consults the `origin_registry` keyed by `origin_frame_id`.
//!
//! This test compiles the minimal_gsum_col fixture and asserts
//! that both sibling AIRs' `gsum_col.reference` hint field is a
//! DIRECT `Operand::WitnessCol { stage: 2, row_offset: 0 }` — no
//! Expression indirection. Before the Round-0 change, the same
//! field was an Expression pointing at an anonymous
//! `Add(WitnessCol, Constant(0))` wrapper entry in the per-AIR
//! arena; after the change the wrapper is gone and the hint carries
//! the resolved leaf operand directly.
//!
//! A regression that reverts the split (reintroduces ExprId
//! wrapping for bare hint leaves) fires assertion #1 by surfacing
//! an `Operand::Expression` instead of `Operand::WitnessCol`. A
//! regression that breaks origin-aware resolution fires assertion
//! #2 by collapsing the operand to `Operand::Constant(0)`.

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
        .join("minimal_gsum_col.pil");
    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    let std_pil = workspace
        .join("pil2-proofman")
        .join("pil2-components")
        .join("lib")
        .join("std")
        .join("pil");
    let out = std::env::temp_dir()
        .join("pil2c_foreign_origin_hint_leaf_resolves_through_registry.pilout");
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
        "pil2c exited non-zero on minimal_gsum_col fixture"
    );
    std::fs::read(&out).expect("read pilout")
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
