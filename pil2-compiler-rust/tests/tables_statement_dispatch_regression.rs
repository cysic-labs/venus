//! Regression for statement-level Tables.fill / Tables.copy dispatch.
//!
//! `eval_function_call` (the expression-level path) dispatches
//! `Tables.fill` / `Tables.copy` / `Tables.num_rows` correctly,
//! but `eval_function_call_with_alias` (used by
//! `exec_expr_stmt` for statement-form calls) was missing the
//! dispatcher entirely. PIL source patterns like `Tables.fill(opid,
//! OPID[current_group], row_offset, h);` (used by
//! `std_range_check.pil` and `std_virtual_table.pil` to populate
//! `col fixed name[N]` arrays) flow through the statement path and
//! were silently dropped — leaving the trio AIRs (SpecifiedRanges
//! / VirtualTable0 / VirtualTable1) with entirely zero-filled
//! `.fixed` files. The basic prover then committed to all-zero
//! fixed cols and the recursive1 verifier rejected the basic
//! proof at `VerifyEvaluations0`.
//!
//! This test compiles a single-AIR fixture that invokes
//! `Tables.fill(42, F, 0, 4);` as a statement on a `col fixed F`
//! declaration. The post-fix `.fixed` file must contain the
//! literal value 42 at the first 4 rows.

use std::path::PathBuf;
use std::process::Command;

#[test]
fn tables_fill_statement_form_populates_fixed_file() {
    let fixture = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("tests")
        .join("data")
        .join("minimal_tables_statement_dispatch.pil");

    let outdir = PathBuf::from(env!("CARGO_TARGET_TMPDIR"));
    let pilout_path = outdir.join("tables_statement_dispatch.pilout");
    let fixed_dir = outdir.join("tables_statement_dispatch_fixed");
    let _ = std::fs::remove_dir_all(&fixed_dir);
    std::fs::create_dir_all(&fixed_dir).unwrap();

    let bin = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
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

    let out = Command::new(&bin)
        .arg(&fixture)
        .arg("-o")
        .arg(&pilout_path)
        .arg("-u")
        .arg(&fixed_dir)
        .arg("-O")
        .arg("fixed-to-file")
        .output()
        .expect("pil2c spawn failed");
    assert!(
        out.status.success(),
        "pil2c failed: stdout={} stderr={}",
        String::from_utf8_lossy(&out.stdout),
        String::from_utf8_lossy(&out.stderr)
    );

    let fixed_file = fixed_dir.join("TablesStatementDispatchAir.fixed");
    assert!(
        fixed_file.is_file(),
        "TablesStatementDispatchAir.fixed not generated at {}",
        fixed_file.display()
    );

    let bytes = std::fs::read(&fixed_file).expect("fixed file read failed");
    assert!(
        bytes.len() >= 32,
        "fixed file too small ({} bytes); expected at least 32 bytes for 4 rows of 1 col at 8 bytes per value",
        bytes.len()
    );

    // Each row is one u64 (col x row layout, single col).
    // Row 0 should be the literal 42.
    let row0_bytes: [u8; 8] = bytes[..8].try_into().unwrap();
    let row0 = u64::from_le_bytes(row0_bytes);
    assert_eq!(
        row0, 42,
        "row 0 of fixed col F should be 42 (set by statement-form `Tables.fill(42, F, 0, 4);`); \
         got {}. A zero here means the Tables.fill statement was silently dropped because \
         eval_function_call_with_alias does not dispatch Tables.* builtins.",
        row0
    );

    // Rows 1..3 should also be 42.
    for row in 1..4 {
        let bytes_at = &bytes[row * 8..(row + 1) * 8];
        let val = u64::from_le_bytes(bytes_at.try_into().unwrap());
        assert_eq!(
            val, 42,
            "row {} of fixed col F should be 42; got {}",
            row, val
        );
    }
}
