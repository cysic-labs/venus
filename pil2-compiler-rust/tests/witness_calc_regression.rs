//! Regression for the `witness_calc` hint's `reference` field.
//!
//! Round R1 (2026-04-16_15-30-57 loop) traced the
//! `make prove` abort
//! `[ERROR]: Only committed pols and airvalues can be set`
//! at `pil2-proofman/pil2-stark/src/starkpil/hints.cpp`
//! calculateExpr guard back to `witness_calc.reference` being
//! emitted as `Operand::Expression` (which the chelpers pipeline
//! classifies as `opType::tmp`) instead of a direct witness-col
//! operand. JS `pil2-compiler/src/processor.js:2018-2022`
//! validates the LHS is always a bare `WitnessCol` or
//! `AirValue`; the fix at
//! `pil2-compiler-rust/src/processor/mod.rs::exec_constraint`
//! short-circuits that bare-leaf case into a new
//! `HintValue::ColRef` variant that the proto serializer emits
//! as `Operand::WitnessCol` / `Operand::AirValue`.
//!
//! This test compiles a tiny fixture with
//! `env!("CARGO_BIN_EXE_pil2c")` and decodes the resulting
//! pilout to assert the reference field emits `WitnessCol`
//! directly. Any regression that reverts to
//! `Operand::Expression` for bare witness constraints will fail
//! here before `make prove` does.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

#[test]
fn witness_calc_reference_emits_witness_col_operand() {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");

    let fixture = manifest
        .join("tests")
        .join("data")
        .join("minimal_witness_calc.pil");
    assert!(
        fixture.is_file(),
        "missing minimal_witness_calc fixture at {}; this fixture is repo-checked",
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

    let out = std::env::temp_dir().join("pil2c_witness_calc_regression.pilout");
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
        "pil2c exited non-zero on the witness_calc regression fixture"
    );
    assert!(
        out.is_file(),
        "pil2c did not produce expected output file at {}",
        out.display()
    );

    let pilout_bytes = std::fs::read(&out).expect("read pilout");
    let pilout = pb::PilOut::decode(pilout_bytes.as_slice()).expect("decode pilout");

    // witness_calc is air-scoped; hints live at pilout.hints with
    // airGroupId + airId set.
    let mut checked = 0usize;
    for hint in &pilout.hints {
        if hint.name != "witness_calc" {
            continue;
        }
        // The reference field is the top-level HintField with
        // name=None wrapping a HintFieldArray whose first named
        // sub-field is "reference".
        let top = hint
            .hint_fields
            .first()
            .expect("witness_calc should have at least one hint_field");
        let arr = match top.value.as_ref() {
            Some(pb::hint_field::Value::HintFieldArray(a)) => a,
            other => panic!(
                "witness_calc top field must be HintFieldArray, got {:?}",
                other
            ),
        };
        let reference = arr
            .hint_fields
            .iter()
            .find(|f| f.name.as_deref() == Some("reference"))
            .expect("witness_calc must have a reference sub-field");

        let operand = match reference.value.as_ref() {
            Some(pb::hint_field::Value::Operand(op)) => op,
            other => panic!(
                "reference field must be an Operand, got {:?}",
                other
            ),
        };
        let inner = operand
            .operand
            .as_ref()
            .expect("reference Operand must have an inner operand");

        // The C++ guard at `hints.cpp:499-511` only accepts cm or
        // airvalue. WitnessCol maps to cm; AirValue maps to airvalue.
        // Operand::Expression would map to tmp and fail the guard.
        match inner {
            pb::operand::Operand::WitnessCol(_) => {}
            pb::operand::Operand::AirValue(_) => {}
            other => panic!(
                "witness_calc.reference must be WitnessCol or AirValue \
                 (cm/airvalue on the C++ consumer side), got {:?} — \
                 this will fail calculateExpr guard in make prove.",
                other
            ),
        }
        checked += 1;
    }
    assert!(
        checked > 0,
        "fixture compiled without emitting any witness_calc hint; \
         the <== constraint should have generated one"
    );

    let _ = std::fs::remove_file(&out);
}
