//! Tests for the processor/evaluator extracted from mod.rs.
//!
//! Kept as its own #[cfg(test)] module so mod.rs stays under the
//! project's code-size guideline. Invoked from mod.rs via
//! `#[cfg(test)] #[path = "mod_tests.rs"] mod tests;`.

#![cfg(test)]
#![allow(unused_imports)]

use super::*;

fn make_processor() -> Processor {
    Processor::new(CompilerConfig::default())
}

#[test]
fn test_processor_creation() {
    let p = make_processor();
    assert_eq!(p.scope.deep, 0);
    assert!(p.references.is_defined("println"));
    assert!(p.references.is_defined("assert"));
    assert!(p.references.is_defined("log2"));
}

#[test]
fn test_execute_empty_program() {
    let mut p = make_processor();
    let prog = Program {
        statements: vec![],
    };
    let result = p.execute_program(&prog);
    assert!(result);
}

#[test]
fn test_eval_number() {
    let mut p = make_processor();
    let expr = Expr::Number(NumericLiteral {
        value: "42".to_string(),
        radix: NumericRadix::Decimal,
    });
    assert_eq!(p.eval_expr(&expr), Value::Int(42));
}

#[test]
fn test_eval_binary_op() {
    let mut p = make_processor();
    let expr = Expr::BinaryOp {
        op: BinOp::Add,
        left: Box::new(Expr::Number(NumericLiteral {
            value: "3".to_string(),
            radix: NumericRadix::Decimal,
        })),
        right: Box::new(Expr::Number(NumericLiteral {
            value: "4".to_string(),
            radix: NumericRadix::Decimal,
        })),
    };
    assert_eq!(p.eval_expr(&expr), Value::Int(7));
}

#[test]
fn test_eval_ternary() {
    let mut p = make_processor();
    let expr = Expr::Ternary {
        condition: Box::new(Expr::Number(NumericLiteral {
            value: "1".to_string(),
            radix: NumericRadix::Decimal,
        })),
        then_expr: Box::new(Expr::Number(NumericLiteral {
            value: "10".to_string(),
            radix: NumericRadix::Decimal,
        })),
        else_expr: Box::new(Expr::Number(NumericLiteral {
            value: "20".to_string(),
            radix: NumericRadix::Decimal,
        })),
    };
    assert_eq!(p.eval_expr(&expr), Value::Int(10));
}

#[test]
fn test_variable_declaration_and_assignment() {
    let mut p = make_processor();
    // Simulate: const int X = 42;
    let vd = VariableDeclaration {
        is_const: true,
        vtype: TypeKind::Int,
        items: vec![VarDeclItem {
            name: "X".to_string(),
            array_dims: vec![],
        }],
        init: Some(Expr::Number(NumericLiteral {
            value: "42".to_string(),
            radix: NumericRadix::Decimal,
        })),
        is_multiple: false,
    };
    p.exec_variable_declaration(&vd);
    let val = p.eval_expr(&Expr::Reference(NameId {
        path: "X".to_string(),
        indexes: vec![],
        row_offset: None,
    }));
    assert_eq!(val, Value::Int(42));
}

#[test]
fn test_for_loop() {
    let mut p = make_processor();
    // for (int i = 0; i < 5; i = i + 1) { }
    // After the loop, i is gone (scoped). We test the loop executes.
    let for_stmt = ForStmt {
        init: Box::new(Statement::VariableDeclaration(VariableDeclaration {
            is_const: false,
            vtype: TypeKind::Int,
            items: vec![VarDeclItem {
                name: "i".to_string(),
                array_dims: vec![],
            }],
            init: Some(Expr::Number(NumericLiteral {
                value: "0".to_string(),
                radix: NumericRadix::Decimal,
            })),
            is_multiple: false,
        })),
        condition: Expr::BinaryOp {
            op: BinOp::Lt,
            left: Box::new(Expr::Reference(NameId {
                path: "i".to_string(),
                indexes: vec![],
                row_offset: None,
            })),
            right: Box::new(Expr::Number(NumericLiteral {
                value: "5".to_string(),
                radix: NumericRadix::Decimal,
            })),
        },
        increment: vec![Assignment {
            target: NameId {
                path: "i".to_string(),
                indexes: vec![],
                row_offset: None,
            },
            op: AssignOp::Assign,
            value: AssignValue::Expr(Expr::BinaryOp {
                op: BinOp::Add,
                left: Box::new(Expr::Reference(NameId {
                    path: "i".to_string(),
                    indexes: vec![],
                    row_offset: None,
                })),
                right: Box::new(Expr::Number(NumericLiteral {
                    value: "1".to_string(),
                    radix: NumericRadix::Decimal,
                })),
            }),
        }],
        body: vec![],
    };
    let result = p.exec_for(&for_stmt);
    assert!(matches!(result, FlowSignal::None));
}

#[test]
fn test_if_then_else() {
    let mut p = make_processor();
    // Declare result first.
    let vd = VariableDeclaration {
        is_const: false,
        vtype: TypeKind::Int,
        items: vec![VarDeclItem {
            name: "result".to_string(),
            array_dims: vec![],
        }],
        init: Some(Expr::Number(NumericLiteral {
            value: "0".to_string(),
            radix: NumericRadix::Decimal,
        })),
        is_multiple: false,
    };
    p.exec_variable_declaration(&vd);

    let if_stmt = IfStmt {
        condition: Expr::Number(NumericLiteral {
            value: "0".to_string(),
            radix: NumericRadix::Decimal,
        }),
        then_body: vec![Statement::Assignment(Assignment {
            target: NameId {
                path: "result".to_string(),
                indexes: vec![],
                row_offset: None,
            },
            op: AssignOp::Assign,
            value: AssignValue::Expr(Expr::Number(NumericLiteral {
                value: "1".to_string(),
                radix: NumericRadix::Decimal,
            })),
        })],
        elseif_clauses: vec![],
        else_body: Some(vec![Statement::Assignment(Assignment {
            target: NameId {
                path: "result".to_string(),
                indexes: vec![],
                row_offset: None,
            },
            op: AssignOp::Assign,
            value: AssignValue::Expr(Expr::Number(NumericLiteral {
                value: "2".to_string(),
                radix: NumericRadix::Decimal,
            })),
        })]),
    };
    p.exec_if(&if_stmt);

    let val = p.eval_expr(&Expr::Reference(NameId {
        path: "result".to_string(),
        indexes: vec![],
        row_offset: None,
    }));
    assert_eq!(val, Value::Int(2)); // condition was 0 (false), so else branch
}

#[test]
fn test_compute_flat_index() {
    assert_eq!(compute_flat_index(&[2, 3], &[4, 5]), 2 * 5 + 3);
    assert_eq!(compute_flat_index(&[0], &[10]), 0);
    assert_eq!(compute_flat_index(&[], &[]), 0);
}

/// Round 7 seeded lift-filter unit test. Exercises
/// `collect_air_col_ids_in_expr` directly: a RuntimeExpr
/// containing a `Witness` leaf tagged with a foreign
/// `origin_frame_id` must be collected with that origin so the
/// caller (the proof-scope lift filter in
/// `execute_air_template_call`) can reject it as cross-AIR even
/// when the numeric id is in-range for the consuming AIR.
/// Codex Round 6 review explicitly required this test.
#[test]
fn test_seeded_foreign_witness_leaf_is_tagged_by_collector() {
    use super::expression::{ColRefKind, RuntimeExpr, RuntimeOp};
    use super::mod_utils::collect_air_col_ids_in_expr;
    use std::collections::{BTreeSet, HashSet};
    use std::rc::Rc;

    let leaf_a = Rc::new(RuntimeExpr::ColRef {
        col_type: ColRefKind::Witness,
        id: 0,
        row_offset: None,
        origin_frame_id: Some(7),
    });
    let leaf_b = Rc::new(RuntimeExpr::ColRef {
        col_type: ColRefKind::Witness,
        id: 1,
        row_offset: None,
        origin_frame_id: Some(7),
    });
    let tree = Rc::new(RuntimeExpr::BinOp {
        op: RuntimeOp::Mul,
        left: leaf_a,
        right: leaf_b,
    });

    let mut out: BTreeSet<(ColRefKind, u32, Option<u32>)> = BTreeSet::new();
    let mut visited: HashSet<*const RuntimeExpr> = HashSet::new();
    collect_air_col_ids_in_expr(&tree, &mut out, &mut visited);

    assert!(
        out.contains(&(ColRefKind::Witness, 0, Some(7))),
        "foreign Witness id=0 with origin=Some(7) must survive the collector walk \
         intact; collected set: {:?}",
        out
    );
    assert!(
        out.contains(&(ColRefKind::Witness, 1, Some(7))),
        "foreign Witness id=1 with origin=Some(7) must survive the collector walk \
         intact; collected set: {:?}",
        out
    );
    let current_origin: u32 = 42;
    let has_foreign = out.iter().any(|(_, _, origin)| {
        matches!(origin, Some(o) if *o != current_origin)
    });
    assert!(
        has_foreign,
        "lift filter must detect the foreign origin=Some(7) against current_origin=42; \
         collected set: {:?}",
        out
    );
}

#[test]
fn test_seeded_origin_less_witness_leaf_is_not_foreign() {
    use super::expression::{ColRefKind, RuntimeExpr};
    use super::mod_utils::collect_air_col_ids_in_expr;
    use std::collections::{BTreeSet, HashSet};
    use std::rc::Rc;

    let leaf = Rc::new(RuntimeExpr::ColRef {
        col_type: ColRefKind::Witness,
        id: 3,
        row_offset: None,
        origin_frame_id: None,
    });

    let mut out: BTreeSet<(ColRefKind, u32, Option<u32>)> = BTreeSet::new();
    let mut visited: HashSet<*const RuntimeExpr> = HashSet::new();
    collect_air_col_ids_in_expr(&leaf, &mut out, &mut visited);

    assert!(out.contains(&(ColRefKind::Witness, 3, None)));
    let current_origin: u32 = 42;
    let has_foreign_origin = out.iter().any(|(_, _, origin)| {
        matches!(origin, Some(o) if *o != current_origin)
    });
    assert!(
        !has_foreign_origin,
        "origin-less leaves must NOT be flagged foreign; the filter defers to \
         bounds-only checks for them"
    );
}

/// Round 8 seeded lift-filter regression. Drives the new
/// `Processor::proof_scope_slot_has_foreign_leaf` helper
/// directly with synthetic proof-scope slot trees that carry
/// foreign `Witness` / `Fixed` / `AirValue` leaves. Codex
/// Round 7 review required proof that the lift filter actually
/// drops foreign leaves before serialization; prior seeded
/// tests only exercised the collector, not the drop decision.
/// Round 9 (strengthened): Codex Round 8 review caught that the
/// prior version of these tests reserved no in-range slots, so
/// `id: 0` tripped the bounds-only fallback (`id >=
/// witness_cols.len() == 0`) and the tests would still pass even
/// if the origin-mismatch branch were removed. Round 9 reserves
/// one in-range Witness / Fixed / AirValue slot per test so the
/// bounds check passes and the foreign-origin branch is the
/// ONLY reason the helper flags the leaf.
#[test]
fn test_proof_scope_slot_drops_foreign_witness_leaf() {
    use super::expression::{ColRefKind, RuntimeExpr};
    use std::collections::HashSet;
    use std::rc::Rc;

    let mut p = make_processor();
    p.current_origin_frame_id = 42;
    // Reserve witness id=0 so the bounds-only fallback (id >=
    // witness_cols.len()) does NOT fire for id=0. The origin
    // mismatch is now the only reason the helper can flag.
    p.witness_cols.reserve(1, None, &[], Default::default());

    let foreign_witness = Rc::new(RuntimeExpr::ColRef {
        col_type: ColRefKind::Witness,
        id: 0,
        row_offset: None,
        origin_frame_id: Some(7),
    });
    let mut visited: HashSet<*const RuntimeExpr> = HashSet::new();
    assert!(
        p.proof_scope_slot_has_foreign_leaf(&foreign_witness, &mut visited),
        "foreign-origin Witness leaf must be flagged EVEN when id is in range; \
         current_origin=42, leaf_origin=Some(7), witness_cols.len=1"
    );

    // Matching-origin control: same in-range id, same slot, but
    // origin matches the current AIR. Helper must NOT flag.
    let matching_witness = Rc::new(RuntimeExpr::ColRef {
        col_type: ColRefKind::Witness,
        id: 0,
        row_offset: None,
        origin_frame_id: Some(42),
    });
    let mut visited: HashSet<*const RuntimeExpr> = HashSet::new();
    assert!(
        !p.proof_scope_slot_has_foreign_leaf(&matching_witness, &mut visited),
        "matching-origin Witness leaf in range must NOT be flagged"
    );
}

#[test]
fn test_proof_scope_slot_drops_foreign_fixed_leaf() {
    use super::expression::{ColRefKind, RuntimeExpr};
    use std::collections::HashSet;
    use std::rc::Rc;

    let mut p = make_processor();
    p.current_origin_frame_id = 42;
    // Reserve one Fixed slot so fixed_col_start..current_len
    // covers id=0 and the bounds check does NOT fire on its own.
    p.fixed_cols.reserve(1, None, &[], Default::default());

    let foreign_fixed = Rc::new(RuntimeExpr::ColRef {
        col_type: ColRefKind::Fixed,
        id: 0,
        row_offset: None,
        origin_frame_id: Some(11),
    });
    let mut visited: HashSet<*const RuntimeExpr> = HashSet::new();
    assert!(
        p.proof_scope_slot_has_foreign_leaf(&foreign_fixed, &mut visited),
        "foreign-origin Fixed leaf must be flagged EVEN when id is in range; \
         fixed_cols.current_len=1, current_origin=42, leaf_origin=Some(11)"
    );

    let matching_fixed = Rc::new(RuntimeExpr::ColRef {
        col_type: ColRefKind::Fixed,
        id: 0,
        row_offset: None,
        origin_frame_id: Some(42),
    });
    let mut visited: HashSet<*const RuntimeExpr> = HashSet::new();
    assert!(
        !p.proof_scope_slot_has_foreign_leaf(&matching_fixed, &mut visited),
        "matching-origin Fixed leaf in range must NOT be flagged"
    );
}

#[test]
fn test_proof_scope_slot_drops_foreign_airvalue_leaf() {
    use super::expression::{ColRefKind, RuntimeExpr};
    use std::collections::HashSet;
    use std::rc::Rc;

    let mut p = make_processor();
    p.current_origin_frame_id = 42;
    // Reserve airvalue id=0.
    p.air_values.reserve(1, None, &[], Default::default());

    let foreign_airvalue = Rc::new(RuntimeExpr::ColRef {
        col_type: ColRefKind::AirValue,
        id: 0,
        row_offset: None,
        origin_frame_id: Some(13),
    });
    let mut visited: HashSet<*const RuntimeExpr> = HashSet::new();
    assert!(
        p.proof_scope_slot_has_foreign_leaf(&foreign_airvalue, &mut visited),
        "foreign-origin AirValue leaf must be flagged EVEN when id is in range; \
         air_values.len=1, current_origin=42, leaf_origin=Some(13)"
    );

    let matching_airvalue = Rc::new(RuntimeExpr::ColRef {
        col_type: ColRefKind::AirValue,
        id: 0,
        row_offset: None,
        origin_frame_id: Some(42),
    });
    let mut visited: HashSet<*const RuntimeExpr> = HashSet::new();
    assert!(
        !p.proof_scope_slot_has_foreign_leaf(&matching_airvalue, &mut visited),
        "matching-origin AirValue leaf in range must NOT be flagged"
    );
}

#[test]
fn test_proof_scope_slot_keeps_origin_less_leaves() {
    use super::expression::{ColRefKind, RuntimeExpr};
    use std::collections::HashSet;
    use std::rc::Rc;

    let mut p = make_processor();
    p.current_origin_frame_id = 42;
    // Make sure the AIR has at least one witness / air_value slot
    // so the bounds-only fallback does not reject id=0 as
    // out-of-range.
    p.witness_cols.reserve(1, None, &[], Default::default());
    p.air_values.reserve(1, None, &[], Default::default());

    let origin_less_witness = Rc::new(RuntimeExpr::ColRef {
        col_type: ColRefKind::Witness,
        id: 0,
        row_offset: None,
        origin_frame_id: None,
    });
    let mut visited: HashSet<*const RuntimeExpr> = HashSet::new();
    assert!(
        !p.proof_scope_slot_has_foreign_leaf(&origin_less_witness, &mut visited),
        "origin-less Witness leaf within bounds must NOT be flagged foreign"
    );
}

// ----------------------------------------------------------------
// Round 3 of plan-rustify-pkgen-e2e-0420 compile-time
// `RuntimeExpr::ExprRef` identity regressions. Codex Round 2
// review required replacing the serializer-cache-probe-based
// regression with one that inspects the Processor's runtime-
// expression shape directly. These tests exercise
// `mod_vardecl.rs::get_var_ref_value_by_type_and_id` under a
// synthetic proof-scope setup (id < frame_start AND in_air) and
// lock the invariants documented in
// `temp/plan-rustify-pkgen-e2e-0420.md` Phase 2:
//
// 1. Symbolic proof-scope reads mint `Value::RuntimeExpr(Rc<RuntimeExpr::ExprRef>)`,
//    NOT an inlined clone of the stored tree.
// 2. Repeated reads of the same slot produce `ExprRef` nodes with
//    equal `(id, row_offset, origin_frame_id)` tuples.
// 3. `Expr::RowOffset` composes onto the `ExprRef.row_offset` so
//    `expr'` and `expr` carry distinct row offsets while sharing
//    the same id.
// ----------------------------------------------------------------

fn seed_proof_scope_expr_slot(p: &mut Processor) -> u32 {
    use super::ids::IdData;
    // Reserve one container-owned slot at id=0 in the current
    // (proof-scope) frame, then push an air scope so frame_start
    // advances past it. After push, id=0 is a proof-scope symbolic
    // slot that the `get_var_ref_value*` ExprRef branch should
    // match (`in_air && id < frame_start`).
    let data = IdData { container_owned: true, ..Default::default() };
    let id = p.exprs.reserve(1, Some("ps_expr"), &[], data);
    // Populate with a symbolic RuntimeExpr (Add of two witness
    // col refs) so the inline / ExprRef branch sees a symbolic
    // value rather than a folded constant.
    let tree = RuntimeExpr::BinOp {
        op: RuntimeOp::Add,
        left: std::rc::Rc::new(RuntimeExpr::ColRef {
            col_type: ColRefKind::Witness,
            id: 0,
            row_offset: None,
            origin_frame_id: Some(0),
        }),
        right: std::rc::Rc::new(RuntimeExpr::ColRef {
            col_type: ColRefKind::Witness,
            id: 1,
            row_offset: None,
            origin_frame_id: Some(0),
        }),
    };
    p.exprs.set(id, Value::RuntimeExpr(std::rc::Rc::new(tree)));
    // Push an air-scope so frame_start advances past id=0. The
    // new frame inherits the seeded slot as container_owned.
    p.exprs.push();
    p.ints.push();
    p.fes.push();
    p.strings.push();
    // Simulate being inside an air body by parking a fake Air on
    // the stack. `get_var_ref_value*` only reads `!self.air_stack.is_empty()`.
    p.air_stack.push(super::air::Air::new(0, 0, "template", "air", 16, false));
    p.next_origin_frame_id = p.next_origin_frame_id.saturating_add(1);
    p.current_origin_frame_id = p.next_origin_frame_id;
    id
}

#[test]
fn expr_ref_proof_scope_read_produces_exprref_variant() {
    let mut p = make_processor();
    let slot_id = seed_proof_scope_expr_slot(&mut p);
    assert!(
        slot_id < p.exprs.frame_start(),
        "seeded slot must be below frame_start; got id={} frame_start={}",
        slot_id,
        p.exprs.frame_start()
    );

    let v = p.get_var_ref_value_by_type_and_id(
        &super::references::RefType::Expr,
        slot_id,
    );
    match v {
        Value::RuntimeExpr(rc) => match rc.as_ref() {
            RuntimeExpr::ExprRef { id, row_offset, origin_frame_id } => {
                assert_eq!(*id, slot_id, "ExprRef.id must be the slot id");
                assert_eq!(
                    *row_offset, None,
                    "scalar proof-scope read must have row_offset=None"
                );
                assert_eq!(
                    *origin_frame_id,
                    Some(p.current_origin_frame_id),
                    "ExprRef.origin_frame_id must be the current frame"
                );
            }
            other => panic!(
                "proof-scope symbolic expr read must mint RuntimeExpr::ExprRef; \
                 got {:?}",
                other
            ),
        },
        other => panic!(
            "proof-scope symbolic expr read must return Value::RuntimeExpr; \
             got {:?}",
            other
        ),
    }
}

#[test]
fn expr_ref_proof_scope_repeated_reads_share_identity_tuple() {
    let mut p = make_processor();
    let slot_id = seed_proof_scope_expr_slot(&mut p);

    let first = p.get_var_ref_value_by_type_and_id(
        &super::references::RefType::Expr,
        slot_id,
    );
    let second = p.get_var_ref_value_by_type_and_id(
        &super::references::RefType::Expr,
        slot_id,
    );

    let (first_id, first_offset, first_origin) = match &first {
        Value::RuntimeExpr(rc) => match rc.as_ref() {
            RuntimeExpr::ExprRef { id, row_offset, origin_frame_id } => {
                (*id, *row_offset, *origin_frame_id)
            }
            other => panic!("first read must be ExprRef; got {:?}", other),
        },
        other => panic!("first read must be Value::RuntimeExpr; got {:?}", other),
    };
    let (second_id, second_offset, second_origin) = match &second {
        Value::RuntimeExpr(rc) => match rc.as_ref() {
            RuntimeExpr::ExprRef { id, row_offset, origin_frame_id } => {
                (*id, *row_offset, *origin_frame_id)
            }
            other => panic!("second read must be ExprRef; got {:?}", other),
        },
        other => panic!("second read must be Value::RuntimeExpr; got {:?}", other),
    };
    assert_eq!(
        (first_id, first_offset, first_origin),
        (second_id, second_offset, second_origin),
        "repeated proof-scope reads must share the same ExprRef tuple"
    );
}

#[test]
fn expr_ref_row_offset_composes_on_proof_scope_ref() {
    let mut p = make_processor();
    let slot_id = seed_proof_scope_expr_slot(&mut p);

    // Build an `Expr::RowOffset { base: Reference, offset: 2,
    // prior: false }`. We need a Reference for `ps_expr`. Since
    // the slot was reserved with label `ps_expr`, we register a
    // matching `Reference` so the evaluator can find it.
    p.references.declare(
        "ps_expr",
        super::references::RefType::Expr,
        slot_id,
        &[],
        true,
        0,
        "",
    );

    use crate::parser::ast::{Expr, NameId, NumericLiteral, NumericRadix};
    let shifted = Expr::RowOffset {
        base: Box::new(Expr::Reference(NameId {
            path: "ps_expr".to_string(),
            indexes: vec![],
            row_offset: None,
        })),
        offset: Box::new(Expr::Number(NumericLiteral {
            value: "2".to_string(),
            radix: NumericRadix::Decimal,
        })),
        prior: false,
    };
    let v = p.eval_expr(&shifted);
    match v {
        Value::RuntimeExpr(rc) => match rc.as_ref() {
            RuntimeExpr::ExprRef { id, row_offset, .. } => {
                assert_eq!(*id, slot_id);
                assert_eq!(
                    *row_offset,
                    Some(2),
                    "Expr::RowOffset must compose onto ExprRef.row_offset"
                );
            }
            other => panic!(
                "expr' on proof-scope symbolic expr must preserve \
                 ExprRef with composed row_offset; got {:?}",
                other
            ),
        },
        other => panic!(
            "expr' on proof-scope symbolic expr must return \
             Value::RuntimeExpr; got {:?}",
            other
        ),
    }
}

#[test]
fn test_expand_templates() {
    let mut p = make_processor();
    // Declare a variable N = 16.
    let vd = VariableDeclaration {
        is_const: false,
        vtype: TypeKind::Int,
        items: vec![VarDeclItem {
            name: "MY_VAR".to_string(),
            array_dims: vec![],
        }],
        init: Some(Expr::Number(NumericLiteral {
            value: "16".to_string(),
            radix: NumericRadix::Decimal,
        })),
        is_multiple: false,
    };
    p.exec_variable_declaration(&vd);
    let result = p.expand_templates("size_${MY_VAR}");
    assert_eq!(result, "size_16");
}
