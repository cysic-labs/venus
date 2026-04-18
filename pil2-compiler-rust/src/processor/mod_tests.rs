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
