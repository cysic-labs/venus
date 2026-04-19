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
            origin_frame_id,
        } => RuntimeExpr::ColRef {
            col_type: *col_type,
            id: *id,
            row_offset: *row_offset,
            origin_frame_id: *origin_frame_id,
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

/// Walk a `RuntimeExpr` tree and push every `ColRefKind::Custom`
/// leaf id into `out`. Also descends into `Value::ColRef` /
/// `Value::RuntimeExpr` wrappers carried by `RuntimeExpr::Value`.
///
/// The `visited` set deduplicates shared subtrees by pointer
/// identity. Without it, recursive1-shaped AIRs (10k+ node trees
/// with heavily shared Rc subtrees) drive the walk into
/// exponential time, which blows the
/// `recursive1_pilout_under_time_budget` regression; with it the
/// walk is linear in unique-subtree count.
///
/// Paired with `collect_custom_ids_in_hint` below: together they
/// let `execute_air_template_call` verify that every
/// `Operand::CustomCol` the proto serializer will emit has
/// corresponding metadata in the emitting AIR's `custom_id_map`
/// before pilout serialization begins. Catching the mismatch at
/// build time produces an actionable "cross-AIR custom leak"
/// diagnostic instead of the downstream pil2-stark-setup
/// `pilout_info.rs` index-out-of-bounds panic class.
pub(super) fn collect_custom_ids_in_expr(
    expr: &super::expression::RuntimeExpr,
    out: &mut std::collections::BTreeSet<u32>,
    visited: &mut std::collections::HashSet<*const super::expression::RuntimeExpr>,
) {
    use super::expression::{ColRefKind, RuntimeExpr};
    let ptr = expr as *const RuntimeExpr;
    if !visited.insert(ptr) {
        return;
    }
    match expr {
        RuntimeExpr::ColRef { col_type: ColRefKind::Custom, id, .. } => {
            out.insert(*id);
        }
        RuntimeExpr::ColRef { .. } => {}
        RuntimeExpr::Value(v) => collect_custom_ids_in_value(v, out, visited),
        RuntimeExpr::BinOp { left, right, .. } => {
            collect_custom_ids_in_expr(left.as_ref(), out, visited);
            collect_custom_ids_in_expr(right.as_ref(), out, visited);
        }
        RuntimeExpr::UnaryOp { operand, .. } => {
            collect_custom_ids_in_expr(operand.as_ref(), out, visited);
        }
    }
}

fn collect_custom_ids_in_value(
    val: &super::expression::Value,
    out: &mut std::collections::BTreeSet<u32>,
    visited: &mut std::collections::HashSet<*const super::expression::RuntimeExpr>,
) {
    use super::expression::{ColRefKind, Value};
    match val {
        Value::ColRef { col_type: ColRefKind::Custom, id, .. } => {
            out.insert(*id);
        }
        Value::RuntimeExpr(rt) => collect_custom_ids_in_expr(rt.as_ref(), out, visited),
        Value::Array(items) => {
            for it in items {
                collect_custom_ids_in_value(it, out, visited);
            }
        }
        _ => {}
    }
}

/// Round 3 (2026-04-19 loop) companion to
/// `collect_custom_ids_in_expr`. Walks a `RuntimeExpr` tree and
/// collects `(col_kind, id)` pairs for every `Witness`, `Fixed`, and
/// `AirValue` leaf. Used by `execute_air_template_call`'s lift
/// filter to detect proof-scope slots whose expression tree still
/// carries leaves that belong to a different AIR's column
/// allocator (the leak class Codex's Round 3 analyze identified as
/// the likely driver of the `test_global_info_has_compressor`
/// divergence). `Custom` is handled separately by the existing
/// `collect_custom_ids_in_expr` + `custom_cols.get_data()` filter.
pub(super) fn collect_air_col_ids_in_expr(
    expr: &super::expression::RuntimeExpr,
    out: &mut std::collections::BTreeSet<(super::expression::ColRefKind, u32)>,
    visited: &mut std::collections::HashSet<*const super::expression::RuntimeExpr>,
) {
    use super::expression::{ColRefKind, RuntimeExpr};
    let ptr = expr as *const RuntimeExpr;
    if !visited.insert(ptr) {
        return;
    }
    match expr {
        RuntimeExpr::ColRef { col_type: ColRefKind::Witness, id, .. } => {
            out.insert((ColRefKind::Witness, *id));
        }
        RuntimeExpr::ColRef { col_type: ColRefKind::Fixed, id, .. } => {
            out.insert((ColRefKind::Fixed, *id));
        }
        RuntimeExpr::ColRef { col_type: ColRefKind::AirValue, id, .. } => {
            out.insert((ColRefKind::AirValue, *id));
        }
        RuntimeExpr::ColRef { .. } => {}
        RuntimeExpr::Value(v) => collect_air_col_ids_in_value(v, out, visited),
        RuntimeExpr::BinOp { left, right, .. } => {
            collect_air_col_ids_in_expr(left.as_ref(), out, visited);
            collect_air_col_ids_in_expr(right.as_ref(), out, visited);
        }
        RuntimeExpr::UnaryOp { operand, .. } => {
            collect_air_col_ids_in_expr(operand.as_ref(), out, visited);
        }
    }
}

fn collect_air_col_ids_in_value(
    val: &super::expression::Value,
    out: &mut std::collections::BTreeSet<(super::expression::ColRefKind, u32)>,
    visited: &mut std::collections::HashSet<*const super::expression::RuntimeExpr>,
) {
    use super::expression::{ColRefKind, Value};
    match val {
        Value::ColRef { col_type: ColRefKind::Witness, id, .. } => {
            out.insert((ColRefKind::Witness, *id));
        }
        Value::ColRef { col_type: ColRefKind::Fixed, id, .. } => {
            out.insert((ColRefKind::Fixed, *id));
        }
        Value::ColRef { col_type: ColRefKind::AirValue, id, .. } => {
            out.insert((ColRefKind::AirValue, *id));
        }
        Value::RuntimeExpr(rt) => collect_air_col_ids_in_expr(rt.as_ref(), out, visited),
        Value::Array(items) => {
            for it in items {
                collect_air_col_ids_in_value(it, out, visited);
            }
        }
        _ => {}
    }
}

/// Walk a `HintValue` tree and push every `ColRefKind::Custom` leaf
/// id into `out`. Hint payloads can carry bare `ColRef` leaves
/// (through `HintValue::ColRef`) as well as `ExprId` references into
/// the per-AIR expression store; the caller is responsible for
/// walking the expression store separately, so this helper only
/// needs to chase the bare-leaf path.
///
/// The `visited` set is shared with
/// `collect_custom_ids_in_expr` so that any `Value::RuntimeExpr`
/// tree we happen to re-enter from a different direction is
/// deduplicated by pointer identity.
pub(super) fn collect_custom_ids_in_hint(
    hint: &super::air::HintValue,
    out: &mut std::collections::BTreeSet<u32>,
    _visited: &mut std::collections::HashSet<*const super::expression::RuntimeExpr>,
) {
    use super::air::HintValue;
    use super::expression::ColRefKind;
    match hint {
        HintValue::ColRef { col_type: ColRefKind::Custom, id, .. } => {
            out.insert(*id);
        }
        HintValue::ColRef { .. } => {}
        HintValue::Array(items) => {
            for it in items {
                collect_custom_ids_in_hint(it, out, _visited);
            }
        }
        HintValue::Object(fields) => {
            for (_k, v) in fields {
                collect_custom_ids_in_hint(v, out, _visited);
            }
        }
        _ => {}
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
