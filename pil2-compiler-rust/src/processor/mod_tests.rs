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
#[test]
fn test_proof_scope_slot_drops_foreign_witness_leaf() {
    use super::expression::{ColRefKind, RuntimeExpr, RuntimeOp};
    use std::collections::HashSet;
    use std::rc::Rc;

    let mut p = make_processor();
    // Simulate AIR entry: the helper reads
    // `self.current_origin_frame_id`. A foreign leaf is one whose
    // origin differs from this value.
    p.current_origin_frame_id = 42;

    let foreign_witness = Rc::new(RuntimeExpr::ColRef {
        col_type: ColRefKind::Witness,
        id: 0,
        row_offset: None,
        origin_frame_id: Some(7),
    });
    let mut visited: HashSet<*const RuntimeExpr> = HashSet::new();
    assert!(
        p.proof_scope_slot_has_foreign_leaf(&foreign_witness, &mut visited),
        "foreign Witness leaf must be flagged; current_origin=42, leaf_origin=Some(7)"
    );
}

#[test]
fn test_proof_scope_slot_drops_foreign_fixed_leaf() {
    use super::expression::{ColRefKind, RuntimeExpr};
    use std::collections::HashSet;
    use std::rc::Rc;

    let mut p = make_processor();
    p.current_origin_frame_id = 42;

    let foreign_fixed = Rc::new(RuntimeExpr::ColRef {
        col_type: ColRefKind::Fixed,
        id: 0,
        row_offset: None,
        origin_frame_id: Some(11),
    });
    let mut visited: HashSet<*const RuntimeExpr> = HashSet::new();
    assert!(
        p.proof_scope_slot_has_foreign_leaf(&foreign_fixed, &mut visited),
        "foreign Fixed leaf must be flagged"
    );
}

#[test]
fn test_proof_scope_slot_drops_foreign_airvalue_leaf() {
    use super::expression::{ColRefKind, RuntimeExpr};
    use std::collections::HashSet;
    use std::rc::Rc;

    let mut p = make_processor();
    p.current_origin_frame_id = 42;

    let foreign_airvalue = Rc::new(RuntimeExpr::ColRef {
        col_type: ColRefKind::AirValue,
        id: 0,
        row_offset: None,
        origin_frame_id: Some(13),
    });
    let mut visited: HashSet<*const RuntimeExpr> = HashSet::new();
    assert!(
        p.proof_scope_slot_has_foreign_leaf(&foreign_airvalue, &mut visited),
        "foreign AirValue leaf must be flagged"
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
