//! Round 7 per Codex Round 6 review: alias-owner dedup
//! regression. The reachable-root importer in
//! `mod_air_template_call::execute_air_template_call` collapses
//! multiple `eid`s whose `Value::RuntimeExpr(Rc)` shares the
//! same Rc pointer (e.g. `const expr B = A;`) into a single
//! `AirExpressionEntry` with an `aliases: Vec<u32>` list of
//! extra source-expr ids. The proto serializer's
//! `source_to_pos` fan-out maps every alias `eid` back to the
//! canonical store position so all reads resolve to the same
//! packed `Operand::Expression(idx)`.
//!
//! The fixture `minimal_alias_expr.pil` declares `const expr e
//! = x + y;` plus `const expr alias_e = e;` and constrains
//! `e === alias_e`. Before Round 7 the importer pushed two
//! distinct arena entries for `e` and `alias_e` even though
//! they share the same `Rc<RuntimeExpr>`. Post-Round-7 there
//! is ONE non-bare-ref intermediate arena entry that the
//! constraint references on both sides.

use std::path::PathBuf;
use std::process::Command;

use pil2_compiler_rust::proto_out::pilout_proto as pb;
use prost::Message;

fn compile_fixture() -> Vec<u8> {
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let workspace = manifest.parent().expect("manifest parent");
    let fixture = manifest
        .join("tests")
        .join("data")
        .join("minimal_alias_expr.pil");
    let bin = PathBuf::from(env!("CARGO_BIN_EXE_pil2c"));
    let std_pil = workspace
        .join("pil2-proofman")
        .join("pil2-components")
        .join("lib")
        .join("std")
        .join("pil");
    let out = std::env::temp_dir()
        .join("pil2c_alias_expr_imports_to_single_packed_root.pilout");
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
        .expect("spawn pil2c");
    assert!(
        status.success(),
        "pil2c exited non-zero on minimal_alias_expr fixture"
    );
    std::fs::read(&out).expect("read pilout")
}

#[test]
fn alias_expr_imports_to_single_packed_root() {
    let bytes = compile_fixture();
    let pilout = pb::PilOut::decode(bytes.as_slice()).expect("decode pilout");
    // Exactly one AIR group and one non-virtual AIR.
    assert_eq!(pilout.air_groups.len(), 1, "expected one air group");
    let ag = &pilout.air_groups[0];
    let airs: Vec<&pb::Air> = ag.airs.iter().collect();
    assert_eq!(airs.len(), 1, "expected one AIR under MinimalAlias");
    let air = airs[0];
    assert_eq!(
        air.name.as_deref(),
        Some("AliasAir"),
        "expected AliasAir instance"
    );
    // The constraint `e === alias_e` serializes as a
    // subtraction of two operands. Both operands must resolve
    // to the SAME `Operand::Expression(idx)` when alias dedup
    // fires.
    assert!(
        !air.constraints.is_empty(),
        "expected at least one constraint",
    );
    let constraint = &air.constraints[0];
    let Some(constraint_expr_idx) = constraint
        .constraint
        .as_ref()
        .and_then(|cv| match cv {
            pb::constraint::Constraint::EveryRow(r) => r.expression_idx.as_ref(),
            pb::constraint::Constraint::FirstRow(r) => r.expression_idx.as_ref(),
            pb::constraint::Constraint::LastRow(r) => r.expression_idx.as_ref(),
            pb::constraint::Constraint::EveryFrame(r) => r.expression_idx.as_ref(),
        })
        .map(|e| e.idx)
    else {
        panic!("constraint has no expression_idx");
    };
    let constraint_expr = air
        .expressions
        .get(constraint_expr_idx as usize)
        .expect("constraint expression in arena");
    use pb::expression::Operation;
    use pb::operand::Operand as O;
    let Some(Operation::Sub(sub)) = constraint_expr.operation.as_ref() else {
        panic!(
            "expected constraint to be Sub(e, alias_e); got {:?}",
            constraint_expr
        );
    };
    let lhs = sub.lhs.as_ref().and_then(|o| o.operand.as_ref());
    let rhs = sub.rhs.as_ref().and_then(|o| o.operand.as_ref());
    let (l_idx, r_idx) = match (lhs, rhs) {
        (Some(O::Expression(l)), Some(O::Expression(r))) => (l.idx, r.idx),
        other => panic!(
            "expected Sub(Expression(l), Expression(r)); got {:?}",
            other
        ),
    };
    assert_eq!(
        l_idx, r_idx,
        "alias dedup failed: `e` and `alias_e` resolved to \
         different packed arena positions ({} vs {}). Round 7 \
         importer must collapse aliased eids into a single \
         canonical AirExpressionEntry with the alias list \
         populated; proto serializer must fan out source_to_pos \
         to all alias eids.",
        l_idx, r_idx
    );
}
