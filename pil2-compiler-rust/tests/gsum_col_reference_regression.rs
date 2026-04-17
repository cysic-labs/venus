//! Regression for `gsum_col.reference` operand class across
//! sibling AIRs in the same airgroup.
//!
//! Round 3 of the 2026-04-16 pk-gen-e2e-recovery loop traced the
//! cross-AIR `gsum_col.reference` corruption to a leaked
//! `use proof.std.gsum;` overwriting subsequent AIRs' bare-name
//! resolution. Round 5 finished the lexical alias snapshot/restore
//! coverage by wiring the control-flow scoped-body runners
//! (`Statement::Block`, `exec_if`, `exec_for`, `exec_while`,
//! `exec_switch`, `exec_air_group`) so a `use` run inside any of
//! those bodies cannot leak into a later AIR template.
//!
//! Per Round 4 contract: this test compiles a checked-in
//! alias-heavy fixture and asserts that the emitted
//! `gsum_col.reference` field does NOT collapse to the
//! pre-fix failure modes (`Constant` zero / empty
//! `Constant` / fall-through default operand). On the broken
//! state the operand serialised as `Operand::Constant` with an
//! empty value buffer or a numeric zero, tripping the
//! downstream `[ERROR]: Only committed pols and airgroupvalues
//! can be set` guard during prove. The post-fix operand must be
//! either a direct `WitnessCol`, an `AirValue`, or an
//! `Expression` wrapping the air-scope expression for the
//! reference column.
//!
//! Each AIR in the fixture must emit its own gsum_col hint with
//! a non-degenerate reference operand. Per-AIR independence is
//! the property the cross-AIR alias leak violated.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

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

    // Collect every gsum_col hint and assert (a) at least one per
    // air_id in the fixture's airgroup, (b) the reference
    // sub-field is a non-degenerate operand. The fixture has
    // two AIRs in a single airgroup; both must produce their
    // own air-scoped gsum_col hint.
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
        "expected gsum_col emitted for both AIRs in fixture; got {} ({:?})",
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

        // Pre-fix failure modes (alias leak): the reference
        // collapses to a Constant (often empty buffer or a single
        // zero byte), or to a stale Number / fall-through default
        // operand pointing at the wrong column class. The
        // post-fix operand is one of the structural classes
        // below.
        match inner {
            pb::operand::Operand::WitnessCol(_)
            | pb::operand::Operand::AirValue(_)
            | pb::operand::Operand::Expression(_) => {}
            pb::operand::Operand::Constant(c) => {
                panic!(
                    "gsum_col.reference for ag={} air={} collapsed to Constant({:?}); \
                     this is the alias-leak failure mode (golden emits a stage-2 cm or \
                     an Expression wrapping it).",
                    ag, air, c.value
                );
            }
            other => panic!(
                "gsum_col.reference for ag={} air={} resolved to unexpected operand class {:?}; \
                 expected WitnessCol / AirValue / Expression",
                ag, air, other
            ),
        }
    }

    let _ = std::fs::remove_file(&out);
}
