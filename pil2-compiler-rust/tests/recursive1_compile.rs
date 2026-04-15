//! Regression test for the recursive1 PIL compile path in pil2c.
//!
//! The aggregator-shaped recursive1 PIL produced by
//! `circom2pil/pil/aggregator.pil` used to hang the compiler inside
//! `proto_out::ProtoOutBuilder::build()` for many minutes. Root cause
//! was a `HashMap<RuntimeExpr, _>` dedup cache whose Hash/Eq walked
//! the entire Rc-linked expression tree on every probe, turning the
//! per-air flatten loop into effectively quadratic work for the
//! 10k+-node recursive trees. Bounding the cache to small subtrees
//! brought the same compile from `>600 s` (never finishing) down to
//! ~90 ms.
//!
//! This test pins that performance floor: it shells out to the
//! test-built `pil2c` binary, points it at a small repo-checked
//! recursive1 fixture, and asserts the compile finishes inside 30 s
//! and produces a non-empty pilout. Any reintroduced quadratic
//! regression will blow the timeout long before the full E2E does.

use std::path::PathBuf;
use std::process::Command;
use std::time::{Duration, Instant};

#[test]
fn recursive1_pilout_under_time_budget() {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest has a parent dir");

    let fixture = manifest
        .join("tests")
        .join("data")
        .join("recursive1_aggregator.pil");
    assert!(
        fixture.is_file(),
        "missing recursive1 fixture at {}; this fixture is repo-checked",
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

    let recurser_pil = workspace.join("circom2pil").join("pil");
    assert!(
        recurser_pil.is_dir(),
        "missing recurser pil include dir at {}",
        recurser_pil.display()
    );

    let include_arg = format!("{},{}", std_pil.display(), recurser_pil.display());
    let out = std::env::temp_dir().join("pil2c_recursive1_regression.pilout");
    let _ = std::fs::remove_file(&out);

    let start = Instant::now();
    let status = Command::new(&bin)
        .arg(&fixture)
        .arg("-I")
        .arg(&include_arg)
        .arg("-o")
        .arg(&out)
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .status()
        .expect("failed to spawn pil2c");
    let elapsed = start.elapsed();

    assert!(
        status.success(),
        "pil2c exited non-zero on the recursive1 regression fixture"
    );
    assert!(
        out.is_file(),
        "pil2c did not produce expected output file at {}",
        out.display()
    );
    let metadata = std::fs::metadata(&out).expect("stat pilout");
    assert!(metadata.len() > 0, "recursive1 pilout is empty");
    assert!(
        elapsed < Duration::from_secs(30),
        "recursive1 pil2c took {:?}, expected < 30s (quadratic regression suspected)",
        elapsed
    );

    eprintln!(
        "recursive1_pilout_under_time_budget: {:?}, {} bytes",
        elapsed,
        metadata.len()
    );
}
