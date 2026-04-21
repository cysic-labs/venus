//! Round 7/8 per Codex Round 6/7 reviews: alias-owner dedup
//! regression. The reachable-root importer in
//! `mod_air_template_call::execute_air_template_call`
//! collapses multiple reachable eids that resolve to the same
//! canonical identity into a single `AirExpressionEntry` with
//! an `aliases: Vec<u32>` list of extra source-expr ids. The
//! canonical identity covers BOTH:
//!   (a) `Value::RuntimeExpr(rc)` matched by `Rc::as_ptr(rc)`.
//!   (b) `Value::ColRef{Intermediate, id: target_eid, ...}`
//!       at same-origin zero row offset, resolved via
//!       canonical_by_eid[target_eid] — the live form of
//!       `const expr alias_e = e;` as produced by
//!       `mod_vardecl::get_var_ref_value`.
//!
//! The proto serializer's `source_to_pos` fan-out maps every
//! alias eid back to the canonical store position so all
//! reads resolve to the same packed `Operand::Expression(idx)`.
//!
//! The Round 8 rewrite strengthens the regression to assert
//! the ACTUAL IMPORTER BEHAVIOR, not just downstream reuse.
//! The fixture declares
//! ```
//! const expr e = x + y;
//! const expr alias_e = e;
//! e === alias_e;
//! ```
//! Under the importer alias-owner path, only ONE arena entry
//! should materialize for the `Add(x, y)` expression; both
//! `e` and `alias_e` source-expr-ids resolve to that single
//! packed position. Before Round 7/8, the importer pushed two
//! distinct entries.

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

/// Shape-match an arena entry against the
/// `Add(WitnessCol { col_idx: a }, WitnessCol { col_idx: b })`
/// pattern. Used to count how many times the fixture's
/// `x + y` expression was materialized in the arena.
fn is_add_witness_pair(expr: &pb::Expression) -> bool {
    use pb::expression::Operation;
    use pb::operand::Operand as O;
    let Some(Operation::Add(add)) = expr.operation.as_ref() else {
        return false;
    };
    let lhs_is_wc = matches!(
        add.lhs.as_ref().and_then(|o| o.operand.as_ref()),
        Some(O::WitnessCol(_))
    );
    let rhs_is_wc = matches!(
        add.rhs.as_ref().and_then(|o| o.operand.as_ref()),
        Some(O::WitnessCol(_))
    );
    lhs_is_wc && rhs_is_wc
}

#[test]
fn alias_expr_imports_to_single_packed_root() {
    let bytes = compile_fixture();
    let pilout = pb::PilOut::decode(bytes.as_slice()).expect("decode pilout");
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

    // Assertion #1 (new Round 8): the aliased `x + y`
    // expression must appear EXACTLY ONCE in the arena. If
    // the importer fails to dedup the alias_e eid against
    // e's eid, two distinct `Add(WitnessCol, WitnessCol)`
    // entries would land in the arena. This is the primary
    // evidence that the importer alias-owner path fires,
    // not just downstream source_to_pos caching.
    let add_witness_count = air
        .expressions
        .iter()
        .filter(|expr| is_add_witness_pair(expr))
        .count();
    assert_eq!(
        add_witness_count,
        1,
        "importer alias-owner dedup failed: expected exactly \
         ONE `Add(WitnessCol, WitnessCol)` arena entry (the \
         shared `x + y` expression), found {}. This proves the \
         importer pushed `alias_e` as a second distinct \
         AirExpressionEntry instead of appending its eid to \
         the canonical owner's aliases list.",
        add_witness_count,
    );

    // Assertion #2 (new Round 8): the per-AIR arena contains
    // the expected minimal count. The fixture produces
    // exactly one non-bare intermediate (`x + y`) plus the
    // constraint's subtraction wrapper.
    assert_eq!(
        air.expressions.len(),
        2,
        "expected arena.len() = 2 for the minimal alias \
         fixture (one `Add(x, y)` intermediate plus the \
         constraint's `Sub(E_alias_e, E_e)`); got {}. Arena \
         contents: {:?}",
        air.expressions.len(),
        air.expressions
            .iter()
            .map(|e| format!("{:?}", e))
            .collect::<Vec<_>>()
            .join("\n  "),
    );

    // Assertion #3 (carry-over): the constraint must wrap the
    // Sub operation with both operands resolving to the SAME
    // packed arena idx (further confirmation that the
    // source_to_pos fan-out routes both eids to the canonical
    // position).
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
        "source_to_pos fan-out failed: `e` and `alias_e` \
         resolved to different packed arena positions ({} vs \
         {}). The Round 7 source_to_pos fan-out should map \
         every alias eid back to the canonical store position.",
        l_idx, r_idx
    );
}
