//! Regression for proof-scope `gsum_debug_data_global`
//! payload preservation, plus the Round 6 grammar fix that
//! lets identifiers like `continue_seq_*` parse as identifiers
//! instead of being silently re-tokenised as `Statement::Continue`
//! and aborting the surrounding airtemplate body.
//!
//! The fixture (`tests/data/minimal_proof_scope_hint.pil`)
//! drives `direct_global_update_proves` / `direct_global_update_assumes`
//! at the airgroup top level so each call increments
//! `proof.std.gsum.hint.num_global_hints` and adds one
//! body-payload `@gsum_debug_data_global` entry. The fixture's
//! airtemplate body also contains a `const expr continue_seq_check`
//! reference inside an `if`, so on the pre-Round-6 grammar the
//! airtemplate body aborted there, which dropped the registered
//! AIR's contributions and therefore the deferred handler's
//! per-call payload count and operand classes diverged.
//!
//! The test asserts the exact contract surface from the Round 6
//! contract:
//!   * `len(hints filtered to gsum_debug_data_global) == 3`
//!     (one header + 2 body entries).
//!   * Header `num_global_hints` = 2.
//!   * First body payload has `type_piop = 1`, `opids` non-empty,
//!     `num_reps.op = "proofvalue"`.
//!
//! On the pre-Round-6 grammar (HEAD `b16e0865` and earlier),
//! either the call counts collapse or the airtemplate body abort
//! corrupts the airgroup's contribution to the global stream,
//! tripping the contract assertions.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

#[test]
fn gsum_debug_data_global_preserves_contract_payload() {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");

    let fixture = manifest
        .join("tests")
        .join("data")
        .join("minimal_proof_scope_hint.pil");
    assert!(
        fixture.is_file(),
        "missing minimal_proof_scope_hint fixture at {}; this fixture is repo-checked",
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

    let out = std::env::temp_dir().join("pil2c_proof_scope_regression.pilout");
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
        "pil2c exited non-zero on the proof-scope regression fixture"
    );
    assert!(
        out.is_file(),
        "pil2c did not produce expected output file at {}",
        out.display()
    );

    let pilout_bytes = std::fs::read(&out).expect("read pilout");
    let pilout = pb::PilOut::decode(pilout_bytes.as_slice()).expect("decode pilout");

    // Filter to proof-scope `gsum_debug_data_global` entries.
    // Header entry (only `num_global_hints`) plus one body entry
    // per registered direct_global_update_* call.
    let entries: Vec<&pb::Hint> = pilout
        .hints
        .iter()
        .filter(|h| h.name == "gsum_debug_data_global"
                  && h.air_group_id.is_none()
                  && h.air_id.is_none())
        .collect();

    // The fixture has exactly two direct_global_update_* calls,
    // so we expect 1 header + 2 body entries = 3 entries. On
    // the pre-Round-6 grammar bug, the airtemplate body abort
    // path would either drop one of the proof-scope calls or
    // corrupt the deferred handler's iteration count.
    assert_eq!(
        entries.len(),
        3,
        "expected 3 gsum_debug_data_global entries (1 header + 2 body); got {}. \
         A different count indicates either the proof-scope `direct_global_update_*` \
         dispatch off-by-one regression OR the per-call `num_global_hints` counter \
         drifted.",
        entries.len()
    );

    // Helper: walk an entry's named sub-fields.
    fn named_fields(h: &pb::Hint) -> Vec<&pb::HintField> {
        let top = match h.hint_fields.first() {
            Some(t) => t,
            None => return Vec::new(),
        };
        match top.value.as_ref() {
            Some(pb::hint_field::Value::HintFieldArray(arr)) => {
                arr.hint_fields.iter().filter(|f| f.name.is_some()).collect()
            }
            _ => Vec::new(),
        }
    }
    fn lookup<'a>(fields: &[&'a pb::HintField], name: &str) -> &'a pb::HintField {
        fields
            .iter()
            .find(|f| f.name.as_deref() == Some(name))
            .copied()
            .unwrap_or_else(|| panic!("missing field '{}' in entry", name))
    }
    fn operand_inner(hf: &pb::HintField) -> &pb::operand::Operand {
        let op = match hf.value.as_ref() {
            Some(pb::hint_field::Value::Operand(op)) => op,
            other => panic!(
                "field {:?} should wrap Operand, got {:?}",
                hf.name, other
            ),
        };
        op.operand.as_ref().expect("Operand had no inner")
    }

    // Header entry: num_global_hints = 2.
    let header_fields = named_fields(entries[0]);
    let header_count = lookup(&header_fields, "num_global_hints");
    let count_inner = operand_inner(header_count);
    let count_bytes = match count_inner {
        pb::operand::Operand::Constant(c) => c.value.clone(),
        other => panic!(
            "header num_global_hints must be Constant; got {:?}. \
             A non-Constant operand here means the deferred handler is reading \
             the counter through the wrong scope.",
            other
        ),
    };
    let count_value = if count_bytes.is_empty() { 0u64 } else { count_bytes[0] as u64 };
    assert_eq!(
        count_value, 2,
        "header num_global_hints must equal 2 for the fixture's two \
         direct_global_update_* calls; got {}. A different value indicates \
         the proof-scope dispatch off-by-one regression.",
        count_value
    );

    // First body entry (entries[1]): the contract requires
    // type_piop = 1, opids non-empty, num_reps.op = "proofvalue".
    let body_fields = named_fields(entries[1]);

    // type_piop must be a non-zero Constant matching the first
    // call's type tag (proves -> SUM_TYPE_PROVES = 1).
    let type_piop = lookup(&body_fields, "type_piop");
    let type_inner = operand_inner(type_piop);
    if let pb::operand::Operand::Constant(c) = type_inner {
        let v = if c.value.is_empty() { 0u64 } else { c.value[0] as u64 };
        assert_eq!(
            v, 1,
            "first gsum_debug_data_global.type_piop must equal 1 (SUM_TYPE_PROVES); \
             got {}. A zero value here is the pre-fix payload-collapse class \
             where the deferred handler reads type_piop from an unpopulated slot.",
            v
        );
    } else {
        panic!(
            "first gsum_debug_data_global.type_piop must be Constant; got {:?}",
            type_inner
        );
    }

    // opids must be a HintFieldArray with at least one populated
    // element. Pre-fix bug collapsed it to an empty array.
    let opids = lookup(&body_fields, "opids");
    let opids_arr = match opids.value.as_ref() {
        Some(pb::hint_field::Value::HintFieldArray(a)) => a,
        other => panic!(
            "first gsum_debug_data_global.opids must be HintFieldArray; got {:?}. \
             A scalar here is the pre-fix array-collapse failure mode.",
            other
        ),
    };
    let first_opid = opids_arr
        .hint_fields
        .first()
        .expect("opids HintFieldArray must have at least one element");
    let first_opid_inner = operand_inner(first_opid);
    let first_opid_bytes = match first_opid_inner {
        pb::operand::Operand::Constant(c) => c.value.clone(),
        other => panic!("opids[0] must be Constant; got {:?}", other),
    };
    assert!(
        !first_opid_bytes.is_empty(),
        "first gsum_debug_data_global.opids[0] must be a populated Constant \
         (Round 6 contract requires `opids` non-empty for the first body entry); \
         got empty bytes which is the pre-fix payload-collapse failure mode."
    );

    // num_reps must be a ProofValue operand. The fixture passes
    // `sel: ps_enable` where `ps_enable` is a `proofval`, which
    // mirrors golden Zisk's `enable_*` proofvals fed to
    // direct_global_update_proves at airgroup top level.
    let num_reps = lookup(&body_fields, "num_reps");
    let num_reps_inner = operand_inner(num_reps);
    match num_reps_inner {
        pb::operand::Operand::ProofValue(_) => {}
        other => panic!(
            "first gsum_debug_data_global.num_reps must be a ProofValue operand \
             (Round 6 contract: num_reps.op == \"proofvalue\"); got {:?}. \
             A Constant here is the pre-fix proof-scope ColRef-as-empty-Constant \
             failure mode.",
            other
        ),
    }

    let _ = std::fs::remove_file(&out);
}
