//! Artifact-level regression for the producer-side
//! `virtual_table_data_global` hint emitted from
//! `std_virtual_table.pil`.
//!
//! Round 4 closed an upstream bug in which a container-declared
//! variable (`int air_ids[num_virtual_tables]` inside
//! `container proof.std.vt`) leaked into top-level refs via
//! function-scope restore-on-pop, so bare `air_ids` resolved to
//! `proof.std.gsum.air_ids[ARRAY_SIZE = 750]` and the emitted
//! `virtual_table_data_global.air_ids` carried 750 bogus entries.
//! The unit test for the `References` leak already landed; this
//! integration test is the contract-required artifact-level guard:
//! it compiles a checked-in minimal fixture with the same `pil2c`
//! binary `cargo test` built, decodes the resulting pilout, and
//! asserts that the `virtual_table_data_global` hint is well-formed
//! and that per-AIR `virtual_table_data` hints cover exactly the
//! airs listed in the global hint.
//!
//! Any regression that re-introduces the container-leak, or that
//! misaligns per-AIR coverage with the global hint, fails here
//! long before `make prove` would trip `std_virtual_table.rs:67`.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

#[test]
fn virtual_table_data_global_matches_fixture_airs() {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");

    let fixture = manifest
        .join("tests")
        .join("data")
        .join("minimal_virtual_table.pil");
    assert!(
        fixture.is_file(),
        "missing minimal_virtual_table fixture at {}; this fixture is repo-checked",
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

    let out = std::env::temp_dir().join("pil2c_virtual_table_regression.pilout");
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
        "pil2c exited non-zero on the virtual-table regression fixture"
    );
    assert!(
        out.is_file(),
        "pil2c did not produce expected output file at {}",
        out.display()
    );

    let pilout_bytes = std::fs::read(&out).expect("read pilout");
    let pilout = pb::PilOut::decode(pilout_bytes.as_slice()).expect("decode pilout");

    // Collect virtual_table_data_global airgroup_ids and air_ids.
    // Hints are stored at the top level; per-AIR hints carry both
    // `airGroupId` and `airId`, while global hints carry neither.
    let vtd_global = pilout
        .hints
        .iter()
        .find(|h| h.name == "virtual_table_data_global")
        .expect("virtual_table_data_global hint must be present");
    assert!(
        vtd_global.air_group_id.is_none() && vtd_global.air_id.is_none(),
        "virtual_table_data_global must be a global hint (unscoped), got ag={:?} air={:?}",
        vtd_global.air_group_id,
        vtd_global.air_id
    );

    let bytes_to_u64 = |bytes: &[u8]| -> u64 {
        // Basefield element is variable-length little-endian encoded.
        let mut v: u64 = 0;
        for (i, b) in bytes.iter().take(8).enumerate() {
            v |= (*b as u64) << (8 * i);
        }
        v
    };

    // Named fields may be at the top level of the hint, or nested
    // one layer inside a wrapping HintFieldArray (depending on how
    // the compiler emits the structure). Walk both.
    let mut top_named: Vec<&pb::HintField> = Vec::new();
    for hf in &vtd_global.hint_fields {
        if hf.name.is_some() {
            top_named.push(hf);
            continue;
        }
        if let Some(pb::hint_field::Value::HintFieldArray(arr)) = hf.value.as_ref() {
            for inner in &arr.hint_fields {
                if inner.name.is_some() {
                    top_named.push(inner);
                }
            }
        }
    }
    assert!(
        !top_named.is_empty(),
        "virtual_table_data_global exposed no named sub-fields; dump: {:#?}",
        vtd_global
    );

    let extract_field = |name: &str| -> Vec<u64> {
        let field = top_named
            .iter()
            .find(|f| f.name.as_deref() == Some(name))
            .copied()
            .unwrap_or_else(|| panic!("field {} missing from virtual_table_data_global", name));
        let arr = match field.value.as_ref() {
            Some(pb::hint_field::Value::HintFieldArray(a)) => a,
            other => panic!(
                "field {} must be a HintFieldArray, got {:?}",
                name, other
            ),
        };
        arr.hint_fields
            .iter()
            .map(|elem| match elem.value.as_ref() {
                Some(pb::hint_field::Value::Operand(op)) => match op.operand.as_ref() {
                    Some(pb::operand::Operand::Constant(c)) => bytes_to_u64(&c.value),
                    other => panic!(
                        "field {} element must be a constant operand, got {:?}",
                        name, other
                    ),
                },
                other => panic!(
                    "field {} element must be an Operand, got {:?}",
                    name, other
                ),
            })
            .collect()
    };

    let airgroup_ids = extract_field("airgroup_ids");
    let air_ids = extract_field("air_ids");

    assert_eq!(
        airgroup_ids.len(),
        air_ids.len(),
        "airgroup_ids ({}) and air_ids ({}) arrays must be the same length",
        airgroup_ids.len(),
        air_ids.len()
    );
    assert!(
        !air_ids.is_empty(),
        "virtual_table_data_global.air_ids must be non-empty (Round 4 leak emitted 750 entries; empty is another kind of regression)"
    );
    assert!(
        air_ids.len() < 10,
        "virtual_table_data_global.air_ids grew unexpectedly to {} entries; \
         the Round 4 container leak produced 750. Any regression that pushes \
         this past the fixture's actual virtual-table count is the same class \
         of bug.",
        air_ids.len()
    );

    // Sanity: all airgroup_ids point at the single airgroup in the
    // fixture, and all air_ids point at a real AIR position in that
    // airgroup.
    let n_airgroups = pilout.air_groups.len() as u64;
    for (i, ag) in airgroup_ids.iter().enumerate() {
        assert!(
            *ag < n_airgroups,
            "airgroup_ids[{}] = {} is out of range (n_airgroups = {})",
            i, ag, n_airgroups
        );
    }

    // Per-AIR `virtual_table_data` hints must cover exactly the
    // (airgroup_id, air_id) pairs listed in the global hint.
    let expected: std::collections::BTreeSet<(u64, u64)> = airgroup_ids
        .iter()
        .zip(air_ids.iter())
        .map(|(&ag, &a)| (ag, a))
        .collect();
    let mut per_air: std::collections::BTreeSet<(u64, u64)> =
        std::collections::BTreeSet::new();
    for hint in &pilout.hints {
        if hint.name != "virtual_table_data" {
            continue;
        }
        if let (Some(ag), Some(a)) = (hint.air_group_id, hint.air_id) {
            per_air.insert((ag as u64, a as u64));
        }
    }
    assert_eq!(
        per_air, expected,
        "per-AIR virtual_table_data hints must cover exactly the \
         (airgroup_id, air_id) pairs in the global hint; expected {:?}, got {:?}",
        expected, per_air
    );

    let _ = std::fs::remove_file(&out);
}
