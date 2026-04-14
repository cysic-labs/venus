//! Compile-time expression evaluation (constant folding, array indexing).
//!
//! Mirrors the runtime evaluation portion of the JS `Expression`,
//! `ExpressionItems`, and `ExpressionOperatorMethods` modules.

use std::fmt;
use std::rc::Rc;

use crate::parser::ast::{BinOp, NumericLiteral, NumericRadix, UnaryOp};

/// Runtime value produced by compile-time expression evaluation.
///
/// The JS implementation uses a class hierarchy rooted at `ExpressionItem`
/// with subclasses `IntValue`, `FeValue`, `StringValue`, etc. We flatten
/// these into an enum for ergonomic Rust usage.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum Value {
    Int(i128),
    Fe(u64),
    Str(String),
    Bool(bool),
    Array(Vec<Value>),
    /// An opaque reference to a column or other declared entity.
    ColRef {
        col_type: ColRefKind,
        id: u32,
        row_offset: Option<i64>,
    },
    /// Expression that cannot be fully evaluated at compile time.
    /// Stored as a tree of operations for later protobuf emission.
    /// Uses Rc for sharing: mirrors JS reference semantics where
    /// expression nodes are shared objects, not deep-copied.
    RuntimeExpr(Rc<RuntimeExpr>),
    /// A reference to a (sub-)array in a VariableStore.
    ///
    /// Produced when a multi-dimensional array is partially indexed in
    /// expression context.  Carries the base ID in the store, the
    /// remaining dimensions, and the reference type so that further
    /// ArrayIndex operations (or function parameter binding) can resolve
    /// individual elements.
    ArrayRef {
        ref_type: super::references::RefType,
        base_id: u32,
        dims: Vec<u32>,
    },
    /// Void / no value (e.g. from a function returning nothing).
    Void,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum ColRefKind {
    Witness,
    Fixed,
    Public,
    Challenge,
    ProofValue,
    AirGroupValue,
    AirValue,
    Custom,
    Intermediate,
}

/// An expression node that cannot be fully folded at compile time.
/// Preserved for protobuf serialization.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum RuntimeExpr {
    Value(Value),
    BinOp {
        op: RuntimeOp,
        left: Rc<RuntimeExpr>,
        right: Rc<RuntimeExpr>,
    },
    UnaryOp {
        op: RuntimeUnaryOp,
        operand: Rc<RuntimeExpr>,
    },
    ColRef {
        col_type: ColRefKind,
        id: u32,
        row_offset: Option<i64>,
    },
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum RuntimeOp {
    Add,
    Sub,
    Mul,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum RuntimeUnaryOp {
    Neg,
}

impl Value {
    /// Try to interpret this value as an integer.
    pub fn as_int(&self) -> Option<i128> {
        match self {
            Value::Int(v) => Some(*v),
            Value::Fe(v) => Some(*v as i128),
            Value::Bool(b) => Some(if *b { 1 } else { 0 }),
            _ => None,
        }
    }

    /// Try to interpret this value as a boolean.
    pub fn as_bool(&self) -> Option<bool> {
        match self {
            Value::Bool(b) => Some(*b),
            Value::Int(v) => Some(*v != 0),
            Value::Fe(v) => Some(*v != 0),
            Value::Str(s) => Some(!s.is_empty()),
            _ => None,
        }
    }

    /// Try to interpret this value as a string.
    pub fn as_string(&self) -> Option<&str> {
        match self {
            Value::Str(s) => Some(s),
            _ => None,
        }
    }

    /// Return the number of elements if this is an array.
    pub fn array_len(&self) -> Option<usize> {
        match self {
            Value::Array(items) => Some(items.len()),
            Value::Str(s) => Some(s.len()),
            _ => None,
        }
    }

    /// True if this value is definitely zero.
    pub fn is_zero(&self) -> bool {
        match self {
            Value::Int(v) => *v == 0,
            Value::Fe(v) => *v == 0,
            _ => false,
        }
    }

    /// Convert to a display-friendly string.
    pub fn to_display_string(&self) -> String {
        match self {
            Value::Int(v) => v.to_string(),
            Value::Fe(v) => format!("0x{:x}", v),
            Value::Str(s) => s.clone(),
            Value::Bool(b) => b.to_string(),
            Value::Array(items) => {
                let inner: Vec<String> = items.iter().map(|i| i.to_display_string()).collect();
                format!("[{}]", inner.join(", "))
            }
            Value::ColRef { col_type, id, row_offset } => {
                let offset_str = match row_offset {
                    Some(o) if *o != 0 => format!("'{}", o),
                    _ => String::new(),
                };
                format!("{:?}@{}{}", col_type, id, offset_str)
            }
            Value::RuntimeExpr(_) => "<runtime-expr>".to_string(),
            Value::ArrayRef { ref_type, base_id, dims } => {
                let dims_str: Vec<String> = dims.iter().map(|d| d.to_string()).collect();
                format!("{:?}@{}[{}]", ref_type, base_id, dims_str.join(","))
            }
            Value::Void => "void".to_string(),
        }
    }
}

impl fmt::Display for Value {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.to_display_string())
    }
}

/// Parse a numeric literal (from the AST) into an i128.
pub fn parse_numeric_literal(lit: &NumericLiteral) -> i128 {
    match lit.radix {
        NumericRadix::Decimal => lit.value.parse::<i128>().unwrap_or(0),
        NumericRadix::Hex => {
            let hex_str = lit.value.trim_start_matches("0x").trim_start_matches("0X");
            i128::from_str_radix(hex_str, 16).unwrap_or(0)
        }
        NumericRadix::Binary => {
            let bin_str = lit.value.trim_start_matches("0b").trim_start_matches("0B");
            i128::from_str_radix(bin_str, 2).unwrap_or(0)
        }
    }
}

/// Evaluate a binary operation on two integer values.
pub fn eval_binop_int(op: &BinOp, left: i128, right: i128) -> Value {
    match op {
        BinOp::Add => Value::Int(left.wrapping_add(right)),
        BinOp::Sub => Value::Int(left.wrapping_sub(right)),
        BinOp::Mul => Value::Int(left.wrapping_mul(right)),
        BinOp::Div => {
            if right == 0 {
                Value::Int(0)
            } else {
                Value::Int(left / right)
            }
        }
        BinOp::IntDiv => {
            if right == 0 {
                Value::Int(0)
            } else {
                Value::Int(left / right)
            }
        }
        BinOp::Mod => {
            if right == 0 {
                Value::Int(0)
            } else {
                Value::Int(left % right)
            }
        }
        BinOp::Pow => {
            if right < 0 {
                Value::Int(0)
            } else {
                Value::Int(checked_pow(left, right as u64))
            }
        }
        BinOp::Eq => Value::Bool(left == right),
        BinOp::Ne => Value::Bool(left != right),
        BinOp::Lt => Value::Bool(left < right),
        BinOp::Gt => Value::Bool(left > right),
        BinOp::Le => Value::Bool(left <= right),
        BinOp::Ge => Value::Bool(left >= right),
        BinOp::And => Value::Bool(left != 0 && right != 0),
        BinOp::Or => Value::Bool(left != 0 || right != 0),
        BinOp::BitAnd => Value::Int(left & right),
        BinOp::BitOr => Value::Int(left | right),
        BinOp::BitXor => Value::Int(left ^ right),
        BinOp::Shl => {
            if right < 0 || right > 127 {
                Value::Int(0)
            } else {
                Value::Int(left.wrapping_shl(right as u32))
            }
        }
        BinOp::Shr => {
            if right < 0 || right > 127 {
                Value::Int(0)
            } else {
                Value::Int(left.wrapping_shr(right as u32))
            }
        }
        BinOp::In => {
            // `In` is not meaningful for plain integers.
            Value::Bool(false)
        }
    }
}

/// Evaluate a unary operation on an integer value.
pub fn eval_unaryop_int(op: &UnaryOp, operand: i128) -> Value {
    match op {
        UnaryOp::Neg => Value::Int(-operand),
        UnaryOp::Not => Value::Bool(operand == 0),
    }
}

/// Safe exponentiation that does not panic.
fn checked_pow(base: i128, exp: u64) -> i128 {
    if exp == 0 {
        return 1;
    }
    let mut result: i128 = 1;
    let mut b = base;
    let mut e = exp;
    while e > 0 {
        if e & 1 == 1 {
            result = result.wrapping_mul(b);
        }
        b = b.wrapping_mul(b);
        e >>= 1;
    }
    result
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_int_arithmetic() {
        assert_eq!(eval_binop_int(&BinOp::Add, 3, 4), Value::Int(7));
        assert_eq!(eval_binop_int(&BinOp::Sub, 10, 3), Value::Int(7));
        assert_eq!(eval_binop_int(&BinOp::Mul, 6, 7), Value::Int(42));
        assert_eq!(eval_binop_int(&BinOp::Div, 10, 3), Value::Int(3));
        assert_eq!(eval_binop_int(&BinOp::Mod, 10, 3), Value::Int(1));
        assert_eq!(eval_binop_int(&BinOp::Pow, 2, 10), Value::Int(1024));
    }

    #[test]
    fn test_comparisons() {
        assert_eq!(eval_binop_int(&BinOp::Eq, 5, 5), Value::Bool(true));
        assert_eq!(eval_binop_int(&BinOp::Ne, 5, 5), Value::Bool(false));
        assert_eq!(eval_binop_int(&BinOp::Lt, 3, 5), Value::Bool(true));
        assert_eq!(eval_binop_int(&BinOp::Gt, 3, 5), Value::Bool(false));
    }

    #[test]
    fn test_bitwise() {
        assert_eq!(eval_binop_int(&BinOp::BitAnd, 0xFF, 0x0F), Value::Int(0x0F));
        assert_eq!(eval_binop_int(&BinOp::BitOr, 0xF0, 0x0F), Value::Int(0xFF));
        assert_eq!(eval_binop_int(&BinOp::Shl, 1, 10), Value::Int(1024));
    }

    #[test]
    fn test_unary() {
        assert_eq!(eval_unaryop_int(&UnaryOp::Neg, 42), Value::Int(-42));
        assert_eq!(eval_unaryop_int(&UnaryOp::Not, 0), Value::Bool(true));
        assert_eq!(eval_unaryop_int(&UnaryOp::Not, 5), Value::Bool(false));
    }

    #[test]
    fn test_value_as_bool() {
        assert_eq!(Value::Int(0).as_bool(), Some(false));
        assert_eq!(Value::Int(1).as_bool(), Some(true));
        assert_eq!(Value::Bool(true).as_bool(), Some(true));
        assert_eq!(Value::Str("hello".into()).as_bool(), Some(true));
        assert_eq!(Value::Str("".into()).as_bool(), Some(false));
    }

    #[test]
    fn test_parse_numeric_decimal() {
        let lit = NumericLiteral {
            value: "1024".to_string(),
            radix: NumericRadix::Decimal,
        };
        assert_eq!(parse_numeric_literal(&lit), 1024);
    }

    #[test]
    fn test_parse_numeric_hex() {
        let lit = NumericLiteral {
            value: "0xFF".to_string(),
            radix: NumericRadix::Hex,
        };
        assert_eq!(parse_numeric_literal(&lit), 255);
    }

    #[test]
    fn test_div_by_zero() {
        assert_eq!(eval_binop_int(&BinOp::Div, 10, 0), Value::Int(0));
        assert_eq!(eval_binop_int(&BinOp::Mod, 10, 0), Value::Int(0));
    }
}
