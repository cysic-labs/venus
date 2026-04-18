//! Variable-level statement handlers extracted from processor/mod.rs
//! to keep that file below the project code-size guideline.
//!
//! Covers: `exec_variable_declaration`, `exec_assignment`,
//! `get_var_value`, `set_var_value`, `set_var_value_by_type_and_id`.

use std::rc::Rc;

use crate::parser::ast::*;

use super::expression::{ColRefKind, RuntimeExpr, RuntimeOp, Value};
use super::ids::IdData;
use super::mod_utils::{
    compute_flat_index, is_literal_one, is_literal_zero, is_symbolic, value_to_rc_runtime_expr,
};
use super::references::{RefType, Reference};
use super::FlowSignal;
use super::Processor;

/// Combine `current op value` into a new Value when at least one side
/// is a symbolic (ColRef / RuntimeExpr) operand. Used by compound
/// assignments (`+=`, `-=`, `*=`) over `expr`-typed variables, where
/// JS pil2-compiler builds a fresh symbolic sum / diff / product node
/// instead of overwriting the accumulator. Applies the same identity
/// folds as `eval_expr`'s BinaryOp arm (x+0=x, 0+x=x, x-0=x, x*1=x,
/// 1*x=x).
fn combine_symbolic(current: Value, op: RuntimeOp, value: Value) -> Value {
    match op {
        RuntimeOp::Add => {
            if is_literal_zero(&value) {
                return current;
            }
            if is_literal_zero(&current) {
                return value;
            }
        }
        RuntimeOp::Sub => {
            if is_literal_zero(&value) {
                return current;
            }
        }
        RuntimeOp::Mul => {
            if is_literal_one(&value) {
                return current;
            }
            if is_literal_one(&current) {
                return value;
            }
        }
    }
    let left = value_to_rc_runtime_expr(&current);
    let right = value_to_rc_runtime_expr(&value);
    Value::RuntimeExpr(Rc::new(RuntimeExpr::BinOp { op, left, right }))
}

impl Processor {
// -----------------------------------------------------------------------
// Variable declarations
// -----------------------------------------------------------------------

pub(super) fn exec_variable_declaration(&mut self, vd: &VariableDeclaration) -> FlowSignal {
    // Evaluate the RHS once. When `is_multiple` is true (destructuring
    // like `const int [a, b, c] = [1, 2, 3]`), the init evaluates to an
    // Array and each element is assigned to the corresponding variable.
    let full_init = vd.init.as_ref().map(|e| self.eval_expr(e));

    for (index, item) in vd.items.iter().enumerate() {
        let name = &item.name;
        let array_dims: Vec<u32> = item
            .array_dims
            .iter()
            .filter_map(|d| {
                d.as_ref().and_then(|e| {
                    let val = self.eval_expr(e);
                    match val.as_int() {
                        Some(v) => Some(v as u32),
                        None => {
                            eprintln!(
                                "warning: array dimension for '{}' evaluated to {:?} (not int), dropping dimension",
                                name, val
                            );
                            None
                        }
                    }
                })
            })
            .collect();
        let size: u32 = if array_dims.is_empty() {
            1
        } else {
            array_dims.iter().product()
        };

        // Per-element init: for destructuring, extract element `index`
        // from the array; otherwise use the full init value for all items.
        let init_value = if vd.is_multiple {
            full_init.as_ref().and_then(|v| {
                if let Value::Array(items) = v {
                    items.get(index).cloned()
                } else {
                    Some(v.clone())
                }
            })
        } else {
            full_init.clone()
        };

        // Mark slots as container-owned when this declaration runs
        // inside a `container { ... }` body, so their values survive
        // the function-exit `trim_values_after` boundary. Container
        // fields (e.g. `int num_global_hints = 0;`,
        // `const expr type_piop[ARRAY_SIZE];`,
        // `int opids[ARRAY_SIZE][64];` declared inside
        // `container proof.std.gsum.hint { ... }`) must persist
        // their per-call writes to the deferred handler that reads
        // them back at proof-final time.
        let container_owned = self.references.inside_container();
        let id_data = IdData {
            source_ref: self.source_ref.clone(),
            container_owned,
            ..Default::default()
        };

        let (ref_type, store_id) = match &vd.vtype {
            TypeKind::Int => {
                let id = self.ints.reserve(
                    size,
                    Some(name),
                    &array_dims,
                    id_data.clone(),
                );
                if let Some(val) = &init_value {
                    // Distribute Array values across element IDs.
                    if !array_dims.is_empty() {
                        if let Value::Array(items) = val {
                            for (i, item) in items.iter().enumerate() {
                                self.ints.set(id + i as u32, item.clone());
                            }
                        } else {
                            self.ints.set(id, val.clone());
                        }
                    } else {
                        self.ints.set(id, val.clone());
                    }
                }
                (RefType::Int, id)
            }
            TypeKind::Fe => {
                let id = self.fes.reserve(
                    size,
                    Some(name),
                    &array_dims,
                    id_data.clone(),
                );
                if let Some(val) = &init_value {
                    if !array_dims.is_empty() {
                        if let Value::Array(items) = val {
                            for (i, item) in items.iter().enumerate() {
                                self.fes.set(id + i as u32, item.clone());
                            }
                        } else {
                            self.fes.set(id, val.clone());
                        }
                    } else {
                        self.fes.set(id, val.clone());
                    }
                }
                (RefType::Fe, id)
            }
            TypeKind::StringType => {
                let id = self.strings.reserve(
                    size,
                    Some(name),
                    &array_dims,
                    id_data.clone(),
                );
                if let Some(val) = &init_value {
                    if !array_dims.is_empty() {
                        if let Value::Array(items) = val {
                            for (i, item) in items.iter().enumerate() {
                                self.strings.set(id + i as u32, item.clone());
                            }
                        } else {
                            self.strings.set(id, val.clone());
                        }
                    } else {
                        self.strings.set(id, val.clone());
                    }
                }
                (RefType::Str, id)
            }
            TypeKind::Expr => {
                // Preserve the declaration label unconditionally,
                // including inside helper function bodies. IM
                // symbol emission is now owned by the proto_out
                // packed-expression builder: a label becomes an
                // IM symbol only when the builder first saves a
                // packed reference keyed by the declaration's
                // source_expr_id, and the resulting Symbol.id is
                // the packed index the builder assigned. Labels
                // that never reach the packed-reference path
                // (helper-local scratch like L1, numerator,
                // exprs_compressed, etc.) do not surface as an
                // IM even though their labels are recorded at
                // declaration time, matching JS
                // saveAndPushExpressionReference semantics.
                let id = self.exprs.reserve(
                    size,
                    Some(name),
                    &array_dims,
                    id_data.clone(),
                );
                if let Some(val) = &init_value {
                    if !array_dims.is_empty() {
                        if let Value::Array(items) = val {
                            for (i, item) in items.iter().enumerate() {
                                self.exprs.set(id + i as u32, item.clone());
                            }
                        } else {
                            self.exprs.set(id, val.clone());
                        }
                    } else {
                        self.exprs.set(id, val.clone());
                    }
                }
                (RefType::Expr, id)
            }
            _ => {
                // Other types not handled as simple variables.
                return FlowSignal::None;
            }
        };

        // When inside a re-opened container, skip re-declaration of
        // variables that already exist. This matches the JS behavior
        // where container variable initializers only run the first
        // time the container is created.
        if self.references.inside_container() {
            if self.references.container_has_var(name) {
                continue;
            }
        }

        // Check for an existing binding to save for scope restore.
        // Skip the scope-level shadow tracking for container variables:
        // a `container proof.std.foo { int air_ids[N]; }` declaration is
        // owned by the container's lifetime, not by the surrounding
        // function scope, and the container body itself is only run on
        // the first create_container() call. Letting the function scope
        // restore-on-pop the bare-name binding leaks the captured
        // shadow target into the top-level `refs` map, where a later
        // bare lookup (e.g. `air_ids` inside
        // `issue_virtual_table_data_global` after `use proof.std.vt;`)
        // hits the leaked entry directly and bypasses the
        // use-aliased-container LIFO scan, picking up the wrong-sized
        // sibling array (proof.std.gsum.air_ids[ARRAY_SIZE=750]
        // instead of proof.std.vt.air_ids[num_virtual_tables=2]).
        let inside_container = self.references.inside_container();
        // A leading scope prefix (`air.`, `airgroup.`, `proof.`) on a
        // declared name means "declare this symbol at the named scope",
        // not at the current lexical scope. PIL writes
        //   const expr air.sel_memcpy = 0
        // inside an `if` body to register `sel_memcpy` at AIR scope so
        // the later constraint-time lookup of bare `sel_memcpy`
        // resolves after the `if` body has exited. Two concrete
        // consequences for the Rust producer:
        //   1. Strip the scope prefix from the reference's storage key
        //      so bare-name lookup from the same AIR / airgroup / proof
        //      scope succeeds.
        //   2. Do NOT tie the declaration to the current scope's
        //      shadow ledger; if we did, `scope.pop` at the end of
        //      the enclosing `if` / `for` / code-block body would
        //      remove the declaration before the constraint site
        //      reads it.
        // Mirrors JS pil2-compiler's handling of the scope-qualified
        // declaration form.
        let has_scope_prefix = !inside_container
            && (name.starts_with("air.")
                || name.starts_with("airgroup.")
                || name.starts_with("proof."));
        let stored_name: &str = if inside_container {
            name
        } else if has_scope_prefix {
            name.strip_prefix("air.")
                .or_else(|| name.strip_prefix("airgroup."))
                .or_else(|| name.strip_prefix("proof."))
                .unwrap_or(name.as_str())
        } else {
            name
        };
        let previous = if inside_container || has_scope_prefix {
            None
        } else {
            self.references.get_direct_ref(stored_name).cloned()
        };
        self.references.declare(
            stored_name,
            ref_type,
            store_id,
            &array_dims,
            vd.is_const,
            self.scope.deep,
            &self.source_ref,
        );
        // Record in scope so that pop() can unset or restore.
        // Scope-prefixed declarations are deliberately skipped here:
        // they outlive the enclosing control-flow scope.
        if !inside_container && !has_scope_prefix {
            self.scope.declare(stored_name, previous);
        }
    }
    FlowSignal::None
}

// -----------------------------------------------------------------------
// Assignment
// -----------------------------------------------------------------------

pub(super) fn exec_assignment(&mut self, a: &Assignment) -> FlowSignal {
    let value = match &a.value {
        AssignValue::Expr(e) => self.eval_expr(e),
        AssignValue::Sequence(_seq) => {
            // Sequence assignment for fixed columns.
            Value::Void
        }
    };

    let name = &a.target.path;
    // Try namespace-qualified resolution first, then fall back to
    // direct lookup so that columns inside airtemplates are found.
    let names = self.namespace_ctx.get_names(name);
    let reference = self
        .references
        .get_reference_multi(&names)
        .or_else(|| self.references.get_reference(name))
        .cloned();

    if let Some(reference) = reference {
        // Evaluate target indexes (e.g. C[i] has one index expression).
        let target_indexes: Vec<i128> = a
            .target
            .indexes
            .iter()
            .map(|e| self.eval_expr(e).as_int().unwrap_or(0))
            .collect();

        // For compound assignments (+=, -=, *=), we need to read the
        // current value from the correct indexed element, not from the
        // base reference.  Resolve the effective ID once so all branches
        // can reuse it.
        let indexed_id = if !target_indexes.is_empty()
            && !reference.array_dims.is_empty()
        {
            let flat = compute_flat_index(&target_indexes, &reference.array_dims);
            Some(reference.id + flat)
        } else {
            None
        };

        let final_value = match a.op {
            AssignOp::Assign => value,
            AssignOp::AddAssign => {
                let current = if let Some(eid) = indexed_id {
                    self.get_var_value_by_type_and_id(&reference.ref_type, eid)
                } else {
                    self.get_var_value(&reference)
                };
                if let (Some(l), Some(r)) = (current.as_int(), value.as_int()) {
                    Value::Int(l + r)
                } else if is_symbolic(&current) || is_symbolic(&value) {
                    // `expr`-typed accumulator: build a fresh Add node
                    // so repeated `sum += term` in a for-loop body
                    // produces a running sum instead of overwriting
                    // the previous iteration's value.
                    combine_symbolic(current, RuntimeOp::Add, value)
                } else {
                    value
                }
            }
            AssignOp::SubAssign => {
                let current = if let Some(eid) = indexed_id {
                    self.get_var_value_by_type_and_id(&reference.ref_type, eid)
                } else {
                    self.get_var_value(&reference)
                };
                if let (Some(l), Some(r)) = (current.as_int(), value.as_int()) {
                    Value::Int(l - r)
                } else if is_symbolic(&current) || is_symbolic(&value) {
                    combine_symbolic(current, RuntimeOp::Sub, value)
                } else {
                    value
                }
            }
            AssignOp::MulAssign => {
                let current = if let Some(eid) = indexed_id {
                    self.get_var_value_by_type_and_id(&reference.ref_type, eid)
                } else {
                    self.get_var_value(&reference)
                };
                if let (Some(l), Some(r)) = (current.as_int(), value.as_int()) {
                    Value::Int(l * r)
                } else if is_symbolic(&current) || is_symbolic(&value) {
                    combine_symbolic(current, RuntimeOp::Mul, value)
                } else {
                    value
                }
            }
        };

        // Handle column writes with row indexes (e.g. C[i] = expr).
        if !target_indexes.is_empty() && matches!(reference.ref_type, RefType::Fixed) {
            let col_id = if !reference.array_dims.is_empty() && target_indexes.len() > 1 {
                // Multi-dimensional column array: split last index as
                // row, earlier indexes select the sub-column.
                let dim_indexes = &target_indexes[..target_indexes.len() - 1];
                let flat = compute_flat_index(dim_indexes, &reference.array_dims);
                reference.id + flat
            } else {
                reference.id
            };
            let row = *target_indexes.last().unwrap() as usize;
            if let Some(v) = final_value.as_int() {
                self.fixed_cols.set_row_value(col_id, row, v);
            }
        } else if !target_indexes.is_empty()
            && !reference.array_dims.is_empty()
        {
            // Array variable: compute the flat offset and write to the
            // element at that position.
            let flat = compute_flat_index(&target_indexes, &reference.array_dims);
            let id = reference.id + flat;
            self.set_var_value_by_type_and_id(&reference.ref_type, id, final_value);
        } else {
            self.set_var_value(&reference, final_value);
        }
    }
    FlowSignal::None
}

/// Get a variable's current value using its reference.
pub(super) fn get_var_value(&self, reference: &Reference) -> Value {
    match reference.ref_type {
        RefType::Int => self.ints.get(reference.id).cloned().unwrap_or(Value::Int(0)),
        RefType::Fe => self.fes.get(reference.id).cloned().unwrap_or(Value::Fe(0)),
        RefType::Str => self
            .strings
            .get(reference.id)
            .cloned()
            .unwrap_or(Value::Str(String::new())),
        RefType::Expr => self
            .exprs
            .get(reference.id)
            .cloned()
            .unwrap_or(Value::Void),
        RefType::Fixed => Value::ColRef {
            col_type: ColRefKind::Fixed,
            id: reference.id,
            row_offset: None,
        },
        RefType::Witness => Value::ColRef {
            col_type: ColRefKind::Witness,
            id: reference.id,
            row_offset: None,
        },
        RefType::Public => Value::ColRef {
            col_type: ColRefKind::Public,
            id: reference.id,
            row_offset: None,
        },
        RefType::Challenge => Value::ColRef {
            col_type: ColRefKind::Challenge,
            id: reference.id,
            row_offset: None,
        },
        RefType::ProofValue => Value::ColRef {
            col_type: ColRefKind::ProofValue,
            id: reference.id,
            row_offset: None,
        },
        RefType::AirGroupValue => Value::ColRef {
            col_type: ColRefKind::AirGroupValue,
            id: reference.id,
            row_offset: None,
        },
        RefType::AirValue => Value::ColRef {
            col_type: ColRefKind::AirValue,
            id: reference.id,
            row_offset: None,
        },
        RefType::CustomCol => Value::ColRef {
            col_type: ColRefKind::Custom,
            id: reference.id,
            row_offset: None,
        },
        _ => Value::Void,
    }
}

/// Set a variable's value using its reference.
pub(super) fn set_var_value(&mut self, reference: &Reference, value: Value) {
    match reference.ref_type {
        RefType::Int => self.ints.set(reference.id, value),
        RefType::Fe => self.fes.set(reference.id, value),
        RefType::Str => self.strings.set(reference.id, value),
        RefType::Expr => self.exprs.set(reference.id, value),
        _ => {}
    }
}

/// Set a variable value by type and explicit ID (for indexed array writes).
pub(super) fn set_var_value_by_type_and_id(&mut self, ref_type: &RefType, id: u32, value: Value) {
    match ref_type {
        RefType::Int => self.ints.set(id, value),
        RefType::Fe => self.fes.set(id, value),
        RefType::Str => self.strings.set(id, value),
        RefType::Expr => self.exprs.set(id, value),
        _ => {}
    }
}

}
