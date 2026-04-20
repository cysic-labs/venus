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
//! This test compiles a single-AIR fixture that invokes BOTH
//! `Tables.fill(42, F, 0, 4)` AND `Tables.copy(src, 0, G, 0, 2)`
//! as statements on `col fixed F` and `col fixed G` declarations.
//! The post-fix `.fixed` file must contain the Tables.fill literal
//! value 42 at row 0 of column F, and the Tables.copy source
//! value 7 at row 0 of column G. Strengthens the Round 24 lock to
//! cover both `Tables.*` surfaces used by the trio AIRs.

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
        "fixed file too small ({} bytes); expected at least 32 bytes for the populated rows",
        bytes.len()
    );

    // Layout is row-major (per write_fixed_cols_to_file): for each
    // row r in 0..N, write 8 bytes per non-temporal-non-external
    // fixed col in column order. F is column 0, G is column 1
    // (declaration order in the fixture).
    // Row 0 col 0 is at offset 0; row 0 col 1 is at offset 8.
    let f_row0 = u64::from_le_bytes(bytes[0..8].try_into().unwrap());
    let g_row0 = u64::from_le_bytes(bytes[8..16].try_into().unwrap());

    assert_eq!(
        f_row0, 42,
        "row 0 of fixed col F should be 42 (set by statement-form \
         `Tables.fill(42, F, 0, 4);`); got {}. A zero here means the \
         Tables.fill statement was silently dropped because \
         eval_function_call_with_alias does not dispatch Tables.* \
         builtins.",
        f_row0
    );
    assert_eq!(
        g_row0, 7,
        "row 0 of fixed col G should be 7 (copied from src=[7,11] by \
         statement-form `Tables.copy(src, 0, G, 0, 2);`); got {}. A \
         zero here means the Tables.copy statement was silently \
         dropped (Tables.* dispatcher missing in \
         eval_function_call_with_alias). This Tables.copy surface is \
         the one std_range_check.pil's VALS-fill loop uses for the \
         trio AIRs (SpecifiedRanges / VirtualTable0 / VirtualTable1).",
        g_row0
    );

    // Row 1: col F still 42 (Tables.fill writes 4 rows), col G should be 11.
    let f_row1 = u64::from_le_bytes(bytes[16..24].try_into().unwrap());
    let g_row1 = u64::from_le_bytes(bytes[24..32].try_into().unwrap());
    assert_eq!(f_row1, 42, "row 1 col F: expected 42, got {}", f_row1);
    assert_eq!(g_row1, 11, "row 1 col G (Tables.copy 2nd source row): expected 11, got {}", g_row1);
}
