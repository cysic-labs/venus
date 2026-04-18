//! Free helper functions extracted from `processor/mod.rs` to keep
//! that file under the project's code-size guideline.
//!
//! Contents moved verbatim from the parent module; visibility widened
//! to `pub(super)` so the parent module continues to call them by bare
//! name via `use super::mod_utils::*;`.

use std::collections::HashMap;
use std::rc::Rc;

use crate::parser::ast::{CallArg, FunctionArg};

use super::air;
use super::expression::{RuntimeExpr, Value};

/// Compute a flat index from multi-dimensional indexes and dimensions.
pub(super) fn compute_flat_index(indexes: &[i128], dims: &[u32]) -> u32 {
    if indexes.is_empty() || dims.is_empty() {
        return 0;
    }
    let mut flat = 0u32;
    let mut stride = 1u32;
    for i in (0..indexes.len().min(dims.len())).rev() {
        flat += (indexes[i] as u32) * stride;
        stride *= dims[i];
    }
    flat
}

/// Compute a flat index for partial indexing (fewer indexes than dimensions).
///
/// When `indexes.len() < dims.len()`, the result is the offset to the first
/// element of the sub-array selected by the provided indexes.
pub(super) fn compute_flat_index_partial(indexes: &[i128], dims: &[u32]) -> u32 {
    if indexes.is_empty() {
        return 0;
    }
    let n = indexes.len().min(dims.len());
    let mut flat = 0u32;
    for i in 0..n {
        let mut stride = 1u32;
        for &d in &dims[i + 1..] {
            stride *= d;
        }
        flat += (indexes[i] as u32) * stride;
    }
    flat
}

/// Reorder arguments based on parameter names for named/positional arg mixing.
pub(super) fn reorder_named_args(
    args: &[CallArg],
    raw_args: &[Value],
    params: &[FunctionArg],
) -> Vec<Value> {
    let mut out: Vec<Value> = Vec::with_capacity(params.len());
    for (pi, param) in params.iter().enumerate() {
        let matched = args.iter().enumerate().find(|(_, a)| {
            a.name.as_deref() == Some(param.name.as_str())
        });
        let value = if let Some((ai, _)) = matched {
            raw_args.get(ai).cloned().unwrap_or(Value::Void)
        } else {
            // Positional: find the pi'th unnamed arg.
            let mut unnamed_seen = 0usize;
            let mut found: Option<Value> = None;
            for (ai, a) in args.iter().enumerate() {
                if a.name.is_none() {
                    if unnamed_seen == pi {
                        found = raw_args.get(ai).cloned();
                        break;
                    }
                    unnamed_seen += 1;
                }
            }
            found.unwrap_or(Value::Void)
        };
        out.push(value);
    }
    out
}

pub(super) fn is_literal_zero(val: &Value) -> bool {
    matches!(val, Value::Int(0) | Value::Fe(0))
}

pub(super) fn is_literal_one(val: &Value) -> bool {
    matches!(val, Value::Int(1) | Value::Fe(1))
}

pub(super) fn is_symbolic(val: &Value) -> bool {
    matches!(val, Value::ColRef { .. } | Value::RuntimeExpr(_))
}

pub(super) fn value_to_runtime_expr(val: &Value) -> RuntimeExpr {
    match val {
        Value::ColRef {
            col_type,
            id,
            row_offset,
        } => RuntimeExpr::ColRef {
            col_type: *col_type,
            id: *id,
            row_offset: *row_offset,
        },
        Value::RuntimeExpr(expr) => RuntimeExpr::clone(expr),
        _ => RuntimeExpr::Value(val.clone()),
    }
}

/// Convert a Value to a shared Rc<RuntimeExpr>. When the value is
/// already a RuntimeExpr, the Rc is cloned (cheap refcount bump)
/// instead of deep-copying the tree. This is the key optimization:
/// matches JS reference semantics where expression subtrees are shared.
pub(super) fn value_to_rc_runtime_expr(val: &Value) -> Rc<RuntimeExpr> {
    match val {
        Value::RuntimeExpr(expr) => Rc::clone(expr),
        _ => Rc::new(value_to_runtime_expr(val)),
    }
}

/// Recursively remap ExprId values in hint data using the given remap
/// table. Retained for future use when expression stores require
/// index remapping.
#[allow(dead_code)]
pub(super) fn remap_hint_expr_ids(
    data: &mut air::HintValue,
    remap: &HashMap<u32, u32>,
) {
    match data {
        air::HintValue::ExprId(ref mut id) => {
            if let Some(&new_id) = remap.get(id) {
                *id = new_id;
            }
        }
        air::HintValue::Array(items) => {
            for item in items.iter_mut() {
                remap_hint_expr_ids(item, remap);
            }
        }
        air::HintValue::Object(pairs) => {
            for (_k, v) in pairs.iter_mut() {
                remap_hint_expr_ids(v, remap);
            }
        }
        _ => {}
    }
}
