//! Regression for scoped witness / const-expr declarations
//! resolving through bare names (e.g. `sel_a`, `loop_b`) after
//! being declared as `col witness air.sel_a` or
//! `const expr air.sel_a = 0`.
//!
//! Pre-Round-6 pil2-compiler-rust stored both kinds of
//! declarations under the prefixed full_name (`air.sel_a`) in
//! `References::refs`. Bare-name lookups from the airtemplate
//! body fell through to `Value::Void`; chained expressions like
//! `src * (sel_a + sel_b)` then carried a `Value::Void` sub-node,
//! `degree(_loop_b)` returned -1 / degreeNotFound, and the outer
//! `if (degree(_loop_b) > 1)` branch did not execute. The
//! intermediate witness column `loop_b` and its `witness_calc`
//! hint were silently dropped.
//!
//! Post-Round-6 the producer strips the scope prefix (`air.`,
//! `airgroup.`, `proof.`) from the declared name before storing
//! it so bare references resolve, `degree()` computes correctly,
//! and the conditional witness declaration lands. This test
//! compiles a minimal fixture that reproduces the same pattern
//! (three airtemplate instances: both flags on, only the `a`
//! flag on, only the `b` flag on) and asserts every AIR has
//! exactly one `loop_b` witness column and one matching
//! `witness_calc` hint.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

#[test]
fn dma_scoped_witness_emits_witness_calc_for_all_aliases() {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));

    let fixture = manifest
        .join("tests")
        .join("data")
        .join("dma_scoped_witness_regression.pil");
    assert!(
        fixture.is_file(),
        "missing dma_scoped_witness_regression fixture at {}",
        fixture.display()
    );

    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    assert!(
        bin.is_file(),
        "CARGO_BIN_EXE_pil2c missing at {}",
        bin.display()
    );

    let out = std::env::temp_dir().join("pil2c_dma_scoped_witness_regression.pilout");
    let _ = std::fs::remove_file(&out);

    let status = Command::new(&bin)
        .arg(&fixture)
        .arg("-o")
        .arg(&out)
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .status()
        .expect("failed to spawn pil2c");
    assert!(status.success(), "pil2c exited non-zero on fixture");
    assert!(
        out.is_file(),
        "pil2c did not produce output at {}",
        out.display()
    );

    let bytes = std::fs::read(&out).expect("read pilout");
    let pilout = pb::PilOut::decode(bytes.as_slice()).expect("decode pilout");

    // Exactly one air group in the fixture, with three airs.
    assert_eq!(pilout.air_groups.len(), 1, "expected 1 air group");
    let ag = &pilout.air_groups[0];
    assert_eq!(ag.airs.len(), 3, "expected 3 airs in the air group");

    // For every AIR, assert:
    //   1. There is exactly one witness column whose symbol label
    //      ends in ".loop_b" (the scoped witness declared under
    //      `col witness air.loop_b`).
    //   2. There is exactly one `witness_calc` hint scoped to that
    //      AIR.
    // Pre-fix failure mode: zero for both.
    for (idx, _air) in ag.airs.iter().enumerate() {
        let air_id = idx as u32;
        let ag_id: u32 = 0;

        let loop_b_syms: Vec<_> = pilout
            .symbols
            .iter()
            .filter(|s| {
                s.r#type == pb::SymbolType::WitnessCol as i32
                    && s.air_group_id == Some(ag_id)
                    && s.air_id == Some(air_id)
                    && (s.name == "loop_b" || s.name.ends_with(".loop_b"))
            })
            .collect();
        assert_eq!(
            loop_b_syms.len(),
            1,
            "ag={} air={} expected exactly one loop_b witness column; \
             got {}. If zero, the scoped-witness bug class is back — \
             bare `loop_b` LHS lookup returned Void and the `<==` \
             constraint was silently skipped.",
            ag_id,
            air_id,
            loop_b_syms.len()
        );

        let wc_hints: Vec<_> = pilout
            .hints
            .iter()
            .filter(|h| {
                h.name == "witness_calc"
                    && h.air_group_id == Some(ag_id)
                    && h.air_id == Some(air_id)
            })
            .collect();
        assert_eq!(
            wc_hints.len(),
            1,
            "ag={} air={} expected exactly one witness_calc hint; \
             got {}. Zero means the loop_b <== _loop_b hint emission \
             path skipped because the LHS bare-name resolution fell \
             through to Value::Void. See Round 6 fix in \
             exec_variable_declaration scope-prefix strip.",
            ag_id,
            air_id,
            wc_hints.len()
        );
    }

    let _ = std::fs::remove_file(&out);
}
