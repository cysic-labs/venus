//! Regression for Round 26 zero-fill diagnostics
//! (`BL-20260420-tables-copy-zerofill-diagnostic`).
//!
//! Two surfaces in the producer / serializer previously
//! substituted `0` silently for missing data:
//!
//! 1. `tables_copy` in `mod.rs`: missing source rows became
//!    literal 0 via `unwrap_or(0)` on `get_row_value`.
//! 2. `write_fixed_cols_to_file` in `proto_out.rs`: cols with
//!    no row data became all-zero serialized blobs without any
//!    warning.
//!
//! Both surfaces now emit `eprintln!` warnings. These tests
//! lock that behavior by spawning `pil2c` on small fixtures
//! that intentionally trip each surface and asserting the
//! stderr output contains the new warning string.

use std::path::PathBuf;
use std::process::Command;

fn run_pil2c(fixture_name: &str) -> std::process::Output {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let fixture = manifest.join("tests").join("data").join(fixture_name);
    let outdir = PathBuf::from(env!("CARGO_TARGET_TMPDIR"));
    let stem = fixture
        .file_stem()
        .and_then(|s| s.to_str())
        .unwrap_or("zero_fill_test");
    let pilout_path = outdir.join(format!("{}.pilout", stem));
    let fixed_dir = outdir.join(format!("{}_fixed", stem));
    let _ = std::fs::remove_dir_all(&fixed_dir);
    std::fs::create_dir_all(&fixed_dir).unwrap();

    let bin = manifest
        .parent()
        .unwrap()
        .join("target")
        .join("release")
        .join("pil2c");
    assert!(
        bin.exists(),
        "pil2c binary not built at {}; run cargo build --release first",
        bin.display()
    );

    Command::new(&bin)
        .arg(&fixture)
        .arg("-o")
        .arg(&pilout_path)
        .arg("-u")
        .arg(&fixed_dir)
        .arg("-O")
        .arg("fixed-to-file")
        .output()
        .expect("pil2c spawn failed")
}

#[test]
fn tables_copy_warns_on_missing_source_rows() {
    let out = run_pil2c("minimal_tables_copy_warning.pil");
    assert!(
        out.status.success(),
        "pil2c failed: stdout={} stderr={}",
        String::from_utf8_lossy(&out.stdout),
        String::from_utf8_lossy(&out.stderr)
    );

    let stderr = String::from_utf8_lossy(&out.stderr);
    assert!(
        stderr.contains("warning: Tables.copy"),
        "stderr should contain `warning: Tables.copy` warning; \
         got stderr:\n{}",
        stderr
    );
    assert!(
        stderr.contains("source rows were missing"),
        "stderr should describe missing source rows; got stderr:\n{}",
        stderr
    );
}

#[test]
fn write_fixed_cols_warns_on_empty_col_data() {
    let out = run_pil2c("minimal_empty_fixed_col_warning.pil");
    assert!(
        out.status.success(),
        "pil2c failed: stdout={} stderr={}",
        String::from_utf8_lossy(&out.stdout),
        String::from_utf8_lossy(&out.stderr)
    );

    let stderr = String::from_utf8_lossy(&out.stderr);
    assert!(
        stderr.contains("warning: write_fixed_cols_to_file"),
        "stderr should contain `warning: write_fixed_cols_to_file` \
         warning; got stderr:\n{}",
        stderr
    );
    assert!(
        stderr.contains("non-temporal fixed cols have NO row data"),
        "stderr should describe non-temporal cols with no row data; \
         got stderr:\n{}",
        stderr
    );
}
