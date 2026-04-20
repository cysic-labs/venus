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

    // Per Codex Round 27 review: also assert the emitted .fixed
    // file zero-fills the rows past the populated source. The
    // fixture populates `src` rows 0..3 with the literal 7 (via
    // `Tables.fill(7, src, 0, 4)`), then runs
    // `Tables.copy(src, 0, dst, 0, 10)` — copy count 10 exceeds
    // the 4 populated source rows by 6, so dst should hold
    // [7, 7, 7, 7] in rows 0..3 and 0 in rows 4..9. The remainder
    // of the fixed file (rows 10..N) is also zero (no writes
    // beyond the copy range).
    let outdir = PathBuf::from(env!("CARGO_TARGET_TMPDIR"));
    let fixed_file = outdir
        .join("minimal_tables_copy_warning_fixed")
        .join("TablesCopyWarningAir.fixed");
    let bytes = std::fs::read(&fixed_file).expect("fixed file read failed");
    // Layout is row-major: for each row r, write 8 bytes per
    // non-temporal-non-external fixed col in column order. The
    // fixture has 2 non-temporal cols: src (col 0) and dst
    // (col 1). Each row is 16 bytes total.
    let row_stride: usize = 16;
    assert!(
        bytes.len() >= row_stride * 10,
        "fixed file too small ({} bytes); expected at least {} for 10 rows",
        bytes.len(),
        row_stride * 10
    );
    for row in 0..4 {
        let dst_offset = row * row_stride + 8;
        let val = u64::from_le_bytes(bytes[dst_offset..dst_offset + 8].try_into().unwrap());
        assert_eq!(
            val, 7,
            "row {} of dst col should be 7 (Tables.copy from src[0..3] which were \
             populated to 7 by Tables.fill); got {}. The Tables.copy missing-source \
             warning fired but the populated source rows must still be copied correctly.",
            row, val
        );
    }
    for row in 4..10 {
        let dst_offset = row * row_stride + 8;
        let val = u64::from_le_bytes(bytes[dst_offset..dst_offset + 8].try_into().unwrap());
        assert_eq!(
            val, 0,
            "row {} of dst col should be 0 (Tables.copy zero-fills past the populated \
             source rows; src had rows 0..3 only); got {}. A non-zero here means the \
             missing source row was filled with something other than the literal 0 \
             that Tables.copy substitutes via `unwrap_or(0)`.",
            row, val
        );
    }
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
