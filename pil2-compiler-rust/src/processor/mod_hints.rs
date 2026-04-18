//! Hint-statement handlers extracted from processor/mod.rs to keep
//! that file below the project code-size guideline.
//!
//! Covers: `exec_hint`, `process_hint_data`, `value_to_hint_value`,
//! `materialize_array_ref_as_hint`.

use crate::parser::ast::*;

use super::air;
use super::expression::Value;
use super::mod_utils::value_to_runtime_expr;
use super::references::RefType;
use super::FlowSignal;
use super::Processor;

impl Processor {
// -----------------------------------------------------------------------
// Hint handling
// -----------------------------------------------------------------------

pub(super) fn exec_hint(&mut self, h: &HintStmt) -> FlowSignal {
    let name = h.name.clone();
    let data = self.process_hint_data(&h.data);
    let scope_type = self.scope.get_instance_type().to_string();
    if scope_type == "proof" {
        self.global_hints.push(air::HintEntry { name, data });
    } else if scope_type == "air" {
        self.air_hints.push(air::HintEntry { name, data });
    }
    FlowSignal::None
}

/// Recursively evaluate hint data AST into HintValue, inserting
/// expression references into the current expression store.
pub(super) fn process_hint_data(&mut self, hdata: &HintData) -> air::HintValue {
    match hdata {
        HintData::Expr(expr) => {
            let val = self.eval_expr(expr);
            self.value_to_hint_value(&val)
        }
        HintData::Array(items) => {
            let vals: Vec<air::HintValue> = items.iter()
                .map(|e| {
                    let val = self.eval_expr(e);
                    self.value_to_hint_value(&val)
                })
                .collect();
            air::HintValue::Array(vals)
        }
        HintData::Object(fields) => {
            let pairs: Vec<(String, air::HintValue)> = fields.iter()
                .map(|(k, e)| {
                    let val = self.eval_expr(e);
                    (k.clone(), self.value_to_hint_value(&val))
                })
                .collect();
            air::HintValue::Object(pairs)
        }
    }
}

/// Convert a compile-time Value to a HintValue. Symbolic values
/// (column references, runtime expressions) are inserted into the
/// active expression store and referenced by index.
///
/// Scope discipline:
/// - **air scope**: symbolic values route through
///   `air_expression_store`; bare `ColRef` leaves become
///   `HintValue::ColRef` so the per-air serializer can emit a
///   direct `Operand::WitnessCol` / `Operand::AirValue` and
///   downstream chelpers does not classify them as `opType::tmp`
///   (the Round 0/1 calculateExprGPU guard failure).
/// - **proof scope**: symbolic values must NEVER be pushed into
///   `air_expression_store` because proof-scope hints are
///   serialized against the GLOBAL expression store indices.
///   Pushing a proof-scope value into the air store returned an
///   `ExprId` whose integer did not match any global expression,
///   which caused `gsum_debug_data_global.num_reps` to fall back
///   to `{op: "number", value: "0"}` in Rust
///   (`build/provingKey/pilout.globalConstraints.json`), vs
///   `{op: "proofvalue", ...}` in golden. The downstream
///   `GENERATING_INNER_PROOFS` guard at
///   `pil2-proofman/pil2-stark/src/starkpil/global_constraints.hpp`
///   then aborted with `[ERROR]: Only committed pols and
///   airgroupvalues can be set`. Proof-scope leaves therefore emit
///   `HintValue::ColRef` directly; proof-scope runtime
///   expressions are routed through the global-expression path
///   below.
pub(super) fn value_to_hint_value(&mut self, val: &Value) -> air::HintValue {
    let is_proof_scope =
        self.scope.get_instance_type() == "proof";
    match val {
        Value::Int(v) => air::HintValue::Int(*v),
        Value::Fe(v) => air::HintValue::Int(*v as i128),
        Value::Str(s) => air::HintValue::Str(s.clone()),
        Value::Bool(b) => air::HintValue::Int(if *b { 1 } else { 0 }),
        Value::Array(arr) => {
            let vals: Vec<air::HintValue> = arr.iter()
                .map(|v| self.value_to_hint_value(v))
                .collect();
            air::HintValue::Array(vals)
        }
        Value::ColRef { col_type, id, row_offset } if is_proof_scope => {
            // Bare leaf in proof scope: serialize as the matching
            // proof-scope operand directly
            // (ProofValue / AirGroupValue / PublicValue /
            // Challenge / WitnessCol / AirValue). The global
            // serializer at
            // `pil2-compiler-rust/src/proto_out.rs::hint_value_to_single_field_global`
            // handles each kind explicitly.
            air::HintValue::ColRef {
                col_type: *col_type,
                id: *id,
                row_offset: *row_offset,
            }
        }
        Value::RuntimeExpr(_) if is_proof_scope => {
            // Non-leaf symbolic expression in proof scope: push
            // into the global expression store (which is the
            // source for `pilout.expressions`, what global
            // `Operand::Expression(idx)` references). The index
            // returned by `ExprId` here is interpreted by the
            // global serializer as a direct global
            // `Operand::Expression`, matching JS
            // `pil2-compiler/src/proto_out.js` behavior where
            // hint-field expressions in proof scope pack into
            // the global expression pool.
            let rt = value_to_runtime_expr(val);
            let idx = self.global_expression_store.len() as u32;
            self.global_expression_store.push(rt);
            air::HintValue::ExprId(idx)
        }
        Value::ColRef { .. } | Value::RuntimeExpr(_) => {
            let rt = value_to_runtime_expr(val);
            let idx = self.air_expression_store.len() as u32;
            self.air_expression_store.push(air::AirExpressionEntry::anonymous(rt));
            air::HintValue::ExprId(idx)
        }
        Value::ArrayRef { ref_type, base_id, dims } => {
            // Materialize the referenced slice element-by-element,
            // preserving element type. Without this, int/string/expr
            // array-backed hint arguments (e.g. `int opids[1] = [opid]`
            // or `string name_exprs[exprs_num]` in std_prod.pil) collapse
            // to scalar Int(0), and downstream consumers (the prover's
            // get_hint_field_m) reject the flattened shape. Mirrors how
            // the JS compiler emits HintFieldArray recursively when the
            // argument is a container array.
            self.materialize_array_ref_as_hint(ref_type, *base_id, dims)
        }
        Value::Void => air::HintValue::Int(0),
    }
}

/// Recursively resolve an `ArrayRef` into a `HintValue::Array` of the
/// referenced slice, preserving leaf element types. Scalar slots become
/// `Int` / `Str` / `ExprId` as appropriate; nested dims become nested
/// `HintValue::Array`s.
pub(super) fn materialize_array_ref_as_hint(
    &mut self,
    ref_type: &RefType,
    base_id: u32,
    dims: &[u32],
) -> air::HintValue {
    if dims.is_empty() {
        let v = self.get_var_value_by_type_and_id(ref_type, base_id);
        return self.value_to_hint_value(&v);
    }
    let head_dim = dims[0] as u32;
    let rest = &dims[1..];
    let stride: u32 = rest.iter().copied().product::<u32>().max(1);
    let mut out: Vec<air::HintValue> = Vec::with_capacity(head_dim as usize);
    for i in 0..head_dim {
        let child_base = base_id + i * stride;
        let hv = if rest.is_empty() {
            let v = self.get_var_value_by_type_and_id(ref_type, child_base);
            self.value_to_hint_value(&v)
        } else {
            self.materialize_array_ref_as_hint(ref_type, child_base, rest)
        };
        out.push(hv);
    }
    air::HintValue::Array(out)
}
}
