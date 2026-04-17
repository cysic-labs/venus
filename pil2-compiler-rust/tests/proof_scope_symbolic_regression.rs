//! Regression for proof-scope hint payload preservation.
//!
//! Round 2 of the 2026-04-16 pk-gen-e2e-recovery loop traced
//! `make prove` aborts at
//! `pil2-proofman/pil2-stark/src/starkpil/global_constraints.hpp`
//! to two coupled producer-side gaps that collapsed every
//! proof-scope symbolic operand to a scalar fallback:
//!   * `value_to_hint_value` unconditionally routed
//!     `Value::ColRef` and `Value::RuntimeExpr` through
//!     `air_expression_store` regardless of scope, so a
//!     proof-scope `HintValue::ExprId` indexed the wrong pool
//!     downstream.
//!   * `hint_value_to_single_field_global` handled
//!     `HintValue::ColRef` by returning an empty `Constant`
//!     fallback, discarding every bare proof-scope leaf
//!     (ProofValue / AirGroupValue / WitnessCol / AirValue /
//!     PublicValue / Challenge).
//!
//! Both fixes landed (commit `dae4de4f`); this test is the
//! contract-required integration-level guard. It compiles a
//! checked-in fixture that drives `std_sum`'s `on final proof`
//! handler `piop_gsum_issue_global_hints` and asserts the
//! emitted `@std_sum_users` proof-scope hint preserves
//! non-degenerate operand classes for its named fields.
//!
//! Pre-fix failure modes the test pins:
//!   * `num_users` collapsing to an empty `Constant` (no value
//!     bytes) instead of a populated `Constant`.
//!   * `airgroup_ids` / `air_ids` collapsing to a top-level
//!     scalar `Constant` instead of a populated
//!     `HintFieldArray`.
//!   * Any per-element operand in those arrays collapsing to
//!     an unexpected non-`Operand` form, which would crash the
//!     C++ chelpers consumer the same way the original bug did.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

#[test]
fn std_sum_users_global_hint_preserves_symbolic_operands() {
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

    let users = pilout
        .hints
        .iter()
        .find(|h| h.name == "std_sum_users" && h.air_group_id.is_none() && h.air_id.is_none())
        .expect(
            "std_sum_users proof-scope hint must be present; \
             std_sum's `on final proof piop_gsum_issue_global_hints` should have emitted it.",
        );

    // Walk to the named sub-fields. The hint's top entry is an
    // unnamed wrapper around a HintFieldArray of named fields.
    let top = users
        .hint_fields
        .first()
        .expect("std_sum_users must have at least one hint_field wrapping the named map");
    let named_fields: Vec<&pb::HintField> = match top.value.as_ref() {
        Some(pb::hint_field::Value::HintFieldArray(arr)) => {
            arr.hint_fields.iter().filter(|f| f.name.is_some()).collect()
        }
        other => panic!(
            "std_sum_users top hint_field must be HintFieldArray, got {:?}",
            other
        ),
    };
    assert!(
        !named_fields.is_empty(),
        "std_sum_users exposed no named sub-fields; dump: {:#?}",
        users
    );

    let lookup = |name: &str| -> &pb::HintField {
        named_fields
            .iter()
            .find(|f| f.name.as_deref() == Some(name))
            .copied()
            .unwrap_or_else(|| panic!("std_sum_users missing field '{}'", name))
    };

    // num_users is a scalar Operand. Pre-fix bug: collapsed to
    // empty Constant {value: []}. Post-fix: populated Constant
    // (or any non-empty operand class).
    let num_users = lookup("num_users");
    let num_users_op = match num_users.value.as_ref() {
        Some(pb::hint_field::Value::Operand(op)) => op,
        other => panic!(
            "std_sum_users.num_users must be Operand; got {:?}",
            other
        ),
    };
    let num_users_inner = num_users_op
        .operand
        .as_ref()
        .expect("std_sum_users.num_users Operand had no inner");
    if let pb::operand::Operand::Constant(c) = num_users_inner {
        assert!(
            !c.value.is_empty(),
            "std_sum_users.num_users collapsed to empty Constant; \
             this is the pre-fix proof-scope ColRef-as-empty-Constant failure mode."
        );
    }

    // airgroup_ids and air_ids are arrays-of-Operand. Pre-fix
    // failure mode: the entire field collapsed to a top-level
    // Constant or an empty HintFieldArray, dropping every per-
    // user element. Post-fix: HintFieldArray with one Operand
    // per registered user (the fixture has two AIR users).
    for field_name in ["airgroup_ids", "air_ids"] {
        let field = lookup(field_name);
        let arr = match field.value.as_ref() {
            Some(pb::hint_field::Value::HintFieldArray(a)) => a,
            other => panic!(
                "std_sum_users.{} must be HintFieldArray (preserves per-user element \
                 operands); got {:?} — this is the pre-fix array-collapse failure mode.",
                field_name, other
            ),
        };
        assert!(
            !arr.hint_fields.is_empty(),
            "std_sum_users.{} HintFieldArray is empty; expected at least one per-user element \
             for the fixture's two AIR users.",
            field_name
        );
        for (i, elem) in arr.hint_fields.iter().enumerate() {
            let op = match elem.value.as_ref() {
                Some(pb::hint_field::Value::Operand(o)) => o,
                other => panic!(
                    "std_sum_users.{}[{}] must wrap an Operand (preserves the symbolic \
                     class); got {:?}",
                    field_name, i, other
                ),
            };
            assert!(
                op.operand.is_some(),
                "std_sum_users.{}[{}] Operand had no inner; this is the pre-fix \
                 ColRef-as-empty-Constant failure mode.",
                field_name,
                i
            );
        }
    }

    let _ = std::fs::remove_file(&out);
}
