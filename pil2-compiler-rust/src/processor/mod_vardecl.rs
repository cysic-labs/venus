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
/// folds as `eval_expr`'s BinaryOp arm to match JS
/// `pil2-compiler/src/expression.js`'s reduce step
/// (`x+0=x`, `0+x=x`, `x-0=x`, `x*1=x`, `1*x=x`, `x*0=0`, `0*x=0`).
/// The `Mul`-by-zero folds matter for the
/// `direct_num *= (gsum_e[idx] + std_gamma)` accumulator pattern in
/// `std_sum.pil::piop_gsum_air`: when `direct_num` is initialized to
/// literal `0` and gets a `*=` update, the result must collapse to
/// the literal `0` rather than `Mul(Number(0), key)`. Without this
/// fold, the resulting pilout carries the redundant `0 * key`
/// subtree which propagates downstream into `qVerifier.code` as
/// extra `mul(number=0, ...)` ops, breaking the strict-equality
/// three-AIR shape regression.
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
            if is_literal_zero(&value) {
                return value;
            }
            if is_literal_zero(&current) {
                return current;
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
                //
                // Mark `const expr X = ...` slots with
                // `is_const_expr: true` so the Phase 3 importer in
                // `execute_air_template_call` can distinguish them
                // from runtime `expr X = ...` slots. JS's
                // `this.expressions.reserve` packs only the former
                // unconditionally into the per-AIR arena;
                // `self.exprs.ids.label_ranges` alone cannot
                // distinguish the two classes.
                let mut expr_id_data = id_data.clone();
                expr_id_data.is_const_expr = vd.is_const;
                let id = self.exprs.reserve(
                    size,
                    Some(name),
                    &array_dims,
                    expr_id_data,
                );
                if let Some(val) = &init_value {
                    if !array_dims.is_empty() {
                        if let Value::Array(items) = val {
                            for (i, item) in items.iter().enumerate() {
                                let slot = id + i as u32;
                                let sanitized =
                                    self.sanitize_expr_store_value(slot, item.clone());
                                self.exprs.set(slot, sanitized);
                            }
                        } else {
                            let sanitized =
                                self.sanitize_expr_store_value(id, val.clone());
                            self.exprs.set(id, sanitized);
                        }
                    } else {
                        let sanitized = self.sanitize_expr_store_value(id, val.clone());
                        self.exprs.set(id, sanitized);
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
                // Round 7: compound-assign accumulators use the
                // ref-helper so `sum += term` stores
                // `Intermediate(sum_slot) + term` — preserving an
                // ExpressionReference to the prior slot instead of
                // inlining the entire prior tree. JS pil_parser.js
                // case 212 + assign.js::assignTypeExpr does the
                // equivalent rewrite; Codex Round 7 analyze at
                // `.humanize/skill/2026-04-19_08-21-25-2723039-7af695b6/output.md`
                // pinned this as the likely driver of the
                // `test_global_info_has_compressor` Stage2 / ImPols
                // inflation on Add256 / Dma64Aligned* / DmaPrePost*
                // / Main.
                let current = if let Some(eid) = indexed_id {
                    self.get_var_ref_value_by_type_and_id(&reference.ref_type, eid)
                } else {
                    self.get_var_ref_value(&reference)
                };
                if let (Some(l), Some(r)) = (current.as_int(), value.as_int()) {
                    Value::Int(l + r)
                } else if is_symbolic(&current) || is_symbolic(&value) {
                    combine_symbolic(current, RuntimeOp::Add, value)
                } else {
                    value
                }
            }
            AssignOp::SubAssign => {
                let current = if let Some(eid) = indexed_id {
                    self.get_var_ref_value_by_type_and_id(&reference.ref_type, eid)
                } else {
                    self.get_var_ref_value(&reference)
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
                    self.get_var_ref_value_by_type_and_id(&reference.ref_type, eid)
                } else {
                    self.get_var_ref_value(&reference)
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

/// Get a variable's current value using its reference. This is the
/// **storage** read used by compound-assignment paths
/// (`exec_assignment`'s `+=` / `-=` / `*=` arms): it returns the
/// inlined `Value` tree from the underlying typed store, including
/// the still-growing accumulator for `RefType::Expr`. Use-site
/// reads should go through `get_var_ref_value` instead so the
/// proto serializer can dedupe them as JS-equivalent
/// `ExpressionReference(id, rowOffset)` lookups.
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
            origin_frame_id: self.maybe_air_origin_frame_id(),
        },
        RefType::Witness => Value::ColRef {
            col_type: ColRefKind::Witness,
            id: reference.id,
            row_offset: None,
            origin_frame_id: self.maybe_air_origin_frame_id(),
        },
        RefType::Public => Value::ColRef {
            col_type: ColRefKind::Public,
            id: reference.id,
            row_offset: None,
            origin_frame_id: None,
        },
        RefType::Challenge => Value::ColRef {
            col_type: ColRefKind::Challenge,
            id: reference.id,
            row_offset: None,
            origin_frame_id: None,
        },
        RefType::ProofValue => Value::ColRef {
            col_type: ColRefKind::ProofValue,
            id: reference.id,
            row_offset: None,
            origin_frame_id: None,
        },
        RefType::AirGroupValue => Value::ColRef {
            col_type: ColRefKind::AirGroupValue,
            id: reference.id,
            row_offset: None,
            origin_frame_id: None,
        },
        RefType::AirValue => Value::ColRef {
            col_type: ColRefKind::AirValue,
            id: reference.id,
            row_offset: None,
            origin_frame_id: self.maybe_air_origin_frame_id(),
        },
        RefType::CustomCol => Value::ColRef {
            col_type: ColRefKind::Custom,
            id: reference.id,
            row_offset: None,
            origin_frame_id: self.maybe_air_origin_frame_id(),
        },
        _ => Value::Void,
    }
}

/// Get a variable's value as a **reference** suitable for use in
/// expression context (`eval_reference`). For `RefType::Expr`
/// slots that hold a symbolic value (`RuntimeExpr` or `ColRef`
/// leaf), this returns
/// `Value::ColRef { col_type: Intermediate, id, .. }` so the
/// proto serializer can dedupe later references to the same
/// expr-store id via `prov_cache` keyed by `(id, row_offset)` -
/// matching JS `pushExpressionReference(id, rowOffset)` semantics
/// in `pil2-compiler/src/expression_packer.js`.
///
/// For any other stored shape (notably `Value::Array` produced
/// by binding an array literal `[a, b]` to a `const expr xs[]`
/// parameter; `Value::ColRef` produced by `expr v = some_witness`
/// scoped-witness aliases that the `<==` LHS path inspects via
/// `RuntimeExpr::ColRef` matching; compile-time `Int` / `Fe` /
/// `Str` values assigned into an expr slot via `expr v =
/// some_int_expression`; or an uninitialised `Value::Void`),
/// this falls back to inlining the stored value. The fallback
/// preserves the pre-refactor semantics that compile-time
/// consumers (`length(...)`, function argument forwarding, array
/// iteration in stdlib helpers like
/// `std_sum.pil::update_piop_sum`, the scoped-witness `<==`
/// witness_calc-hint check at `mod.rs::exec_witness_constraint`)
/// depend on. The dedup benefit is only real for compound
/// `RuntimeExpr` accumulators - bare `ColRef` leaves are already
/// caught by the `PackedKey::ColRef(kind, id, offset)` cache, so
/// not aliasing them through `Intermediate` keeps both layers
/// correct.
///
/// All non-`Expr` ref types fall through to the same per-type
/// behavior as `get_var_value`.
#[allow(dead_code)]
pub(super) fn get_var_ref_value(&mut self, reference: &Reference) -> Value {
    match reference.ref_type {
        RefType::Expr => {
            let stored = self.exprs.get(reference.id).cloned().unwrap_or(Value::Void);
            match &stored {
                Value::RuntimeExpr(rt) => {
                    // Only emit an `Intermediate` reference when the
                    // expr-store slot is within the current AIR's
                    // frame, i.e. this AIR will lift the slot into
                    // its `air_expression_store` during finalization.
                    // Proof-scope / cross-AIR slots (id < frame_start)
                    // are dropped by the per-AIR lift filter when
                    // they carry cross-AIR Custom refs, and even when
                    // kept their `source_expr_id` is the original
                    // slot id which the proto serializer's
                    // `source_to_pos` map only resolves for entries
                    // this AIR actually included. Returning the raw
                    // id outside the frame would emit a stale
                    // `Operand::Expression { idx: <large id> }` that
                    // pil2-stark-setup would index past its
                    // expressions[] vector and panic on (see
                    // `pil2-stark-setup/src/helpers.rs:21:19`).
                    // Only emit an `Intermediate` ref when we are
                    // actually inside an AIR template body. At proof
                    // scope (before the first AIR push and after the
                    // last AIR pop, e.g. during
                    // `final_proof_scope`'s deferred handlers),
                    // `frame_start` is 0 so the `id >= frame_start`
                    // gate would always pass, minting refs that no
                    // per-AIR `source_to_pos` map can ever resolve.
                    // The lifted AirExpressionStore only exists for
                    // AIR-scoped expressions, so refs into proof
                    // scope must stay inlined. See
                    // BL-20260418-intermediate-ref-cross-air-leak.
                    let in_air = !self.air_stack.is_empty();
                    let frame_start = self.exprs.frame_start();
                    if in_air && reference.id >= frame_start {
                        // Round 3 lift / read consistency: record
                        // the id so AIR finalization keeps the slot
                        // in `air_expression_store` even if the
                        // stored value is overwritten with a
                        // non-symbolic shape later in the AIR body.
                        // See BL-20260418-intermediate-ref-lift-consistency.
                        self.intermediate_refs_emitted.insert(reference.id);
                        // Round 2 (2026-04-19 loop) origin-frame-id:
                        // key both resolution maps by the composite
                        // `(origin_frame_id, local_id)`. The bare
                        // `u32` key used before this round aliased
                        // across AIRs because `IdAllocator::push`
                        // resets `next_id` to 0 per frame.
                        // See BL-20260419-origin-frame-id-resolution.
                        let origin = self.current_origin_frame_id;
                        let key = (origin, reference.id);
                        self.intermediate_ref_resolution
                            .entry(key)
                            .or_insert_with(|| rt.clone());
                        self.global_intermediate_resolution
                            .entry(key)
                            .or_insert_with(|| rt.clone());
                        Value::ColRef {
                            col_type: ColRefKind::Intermediate,
                            id: reference.id,
                            row_offset: None,
                            origin_frame_id: Some(origin),
                        }
                    } else if in_air {
                        // Round 2 of plan-rustify-pkgen-e2e-0420:
                        // symbolic proof-scope `expr` reads (in-air
                        // AND id < frame_start) mint a
                        // `RuntimeExpr::ExprRef` node so the
                        // producer preserves the JS-style by-id
                        // reference identity instead of inlining
                        // the stored tree at every use site.
                        // Register the reference in both resolution
                        // maps so the Phase 3 importer (and the
                        // current proto serializer) can resolve
                        // `(origin, id)` back to the underlying
                        // expression.
                        let origin = self.current_origin_frame_id;
                        let key = (origin, reference.id);
                        self.intermediate_ref_resolution
                            .entry(key)
                            .or_insert_with(|| rt.clone());
                        self.global_intermediate_resolution
                            .entry(key)
                            .or_insert_with(|| rt.clone());
                        Value::RuntimeExpr(Rc::new(RuntimeExpr::ExprRef {
                            id: reference.id,
                            row_offset: None,
                            origin_frame_id: Some(origin),
                        }))
                    } else {
                        stored
                    }
                }
                // Round 10 per Codex Round 9 review: split the
                // current-frame `Value::ColRef` path into the JS-
                // mirrored two-branch shape. JS
                // `expression_packer.js::referencePack` routes
                // `defvalue.isExpression` cases through
                // `saveAndPushExpressionReference` (save-path,
                // registers a packed arena idx in
                // `references[(id, rowOffset)]` for reuse across
                // references) and `defvalue.isReference` cases
                // through bare `pushExpressionReference` (no
                // resolution-map registration; the slot's own
                // packed arena entry stands alone).
                //
                // In Rust, `Value::ColRef{col_type: Intermediate,
                // ..}` stored on a const-expr slot mirrors the
                // expression-backed case (the stored value is
                // itself an intermediate reference chain). Every
                // other `Value::ColRef{col_type: Witness / Fixed /
                // Custom / AirValue / PeriodicCol / ..}` is the
                // bare-reference case. For bare-ref aliases we
                // still mint `Value::ColRef{Intermediate,
                // reference.id, ..}` and register the alias slot
                // with `intermediate_refs_emitted` so the
                // reachability importer keeps it and proto
                // `source_to_pos` resolves every read to
                // `Operand::Expression { idx }`, but we SKIP the
                // `intermediate_ref_resolution` /
                // `global_intermediate_resolution` registrations.
                // The alias slot's own imported arena entry
                // carries the stored ColRef tree; the serializer
                // never needs to fall back to the global-
                // resolution re-flatten path for same-origin
                // bare-ref aliases.
                Value::ColRef {
                    col_type,
                    id: stored_id,
                    row_offset: stored_offset,
                    origin_frame_id: stored_origin,
                } => {
                    let in_air = !self.air_stack.is_empty();
                    let frame_start = self.exprs.frame_start();
                    let is_const_expr = self
                        .exprs
                        .ids
                        .get_data(reference.id)
                        .map(|d| d.is_const_expr)
                        .unwrap_or(false);
                    if in_air
                        && reference.id >= frame_start
                        && is_const_expr
                    {
                        self.intermediate_refs_emitted.insert(reference.id);
                        let origin = self.current_origin_frame_id;
                        if matches!(col_type, ColRefKind::Intermediate) {
                            let colref_rt = RuntimeExpr::ColRef {
                                col_type: *col_type,
                                id: *stored_id,
                                row_offset: *stored_offset,
                                origin_frame_id: *stored_origin,
                            };
                            let rt_rc = Rc::new(colref_rt);
                            let key = (origin, reference.id);
                            self.intermediate_ref_resolution
                                .entry(key)
                                .or_insert_with(|| rt_rc.clone());
                            self.global_intermediate_resolution
                                .entry(key)
                                .or_insert_with(|| rt_rc);
                        }
                        Value::ColRef {
                            col_type: ColRefKind::Intermediate,
                            id: reference.id,
                            row_offset: None,
                            origin_frame_id: Some(origin),
                        }
                    } else {
                        stored
                    }
                }
                _ => stored,
            }
        }
        _ => self.get_var_value(reference),
    }
}

/// Indexed-element variant of `get_var_ref_value`. Same fallback
/// rule as the bare-scalar form: only symbolic stored values
/// produce an `Intermediate` `ColRef`, everything else inlines
/// the stored value so compile-time consumers continue working.
#[allow(dead_code)]
pub(super) fn get_var_ref_value_by_type_and_id(
    &mut self,
    ref_type: &RefType,
    id: u32,
) -> Value {
    match ref_type {
        RefType::Expr => {
            let stored = self.exprs.get(id).cloned().unwrap_or(Value::Void);
            match &stored {
                Value::RuntimeExpr(rt) => {
                    let in_air = !self.air_stack.is_empty();
                    let frame_start = self.exprs.frame_start();
                    if in_air && id >= frame_start {
                        self.intermediate_refs_emitted.insert(id);
                        let origin = self.current_origin_frame_id;
                        let key = (origin, id);
                        self.intermediate_ref_resolution
                            .entry(key)
                            .or_insert_with(|| rt.clone());
                        self.global_intermediate_resolution
                            .entry(key)
                            .or_insert_with(|| rt.clone());
                        Value::ColRef {
                            col_type: ColRefKind::Intermediate,
                            id,
                            row_offset: None,
                            origin_frame_id: Some(origin),
                        }
                    } else if in_air {
                        // See the matching branch in
                        // `get_var_ref_value` above for the full
                        // rationale. Proof-scope symbolic `expr`
                        // reads mint an `ExprRef` so the JS-style
                        // reference identity survives downstream.
                        let origin = self.current_origin_frame_id;
                        let key = (origin, id);
                        self.intermediate_ref_resolution
                            .entry(key)
                            .or_insert_with(|| rt.clone());
                        self.global_intermediate_resolution
                            .entry(key)
                            .or_insert_with(|| rt.clone());
                        Value::RuntimeExpr(Rc::new(RuntimeExpr::ExprRef {
                            id,
                            row_offset: None,
                            origin_frame_id: Some(origin),
                        }))
                    } else {
                        stored
                    }
                }
                // Round 10 per Codex Round 9 review: array-element
                // form of the JS-mirrored ColRef-alias split. See
                // the matching branch in `get_var_ref_value` for
                // the full rationale. Expression-backed aliases
                // (stored `Value::ColRef{col_type: Intermediate,
                // ..}`) go through the Round 9 save-path;
                // bare-reference aliases skip the resolution-map
                // registration and rely on the alias slot's own
                // imported arena entry via `source_to_pos`.
                Value::ColRef {
                    col_type,
                    id: stored_id,
                    row_offset: stored_offset,
                    origin_frame_id: stored_origin,
                } => {
                    let in_air = !self.air_stack.is_empty();
                    let frame_start = self.exprs.frame_start();
                    let is_const_expr = self
                        .exprs
                        .ids
                        .get_data(id)
                        .map(|d| d.is_const_expr)
                        .unwrap_or(false);
                    if in_air && id >= frame_start && is_const_expr {
                        self.intermediate_refs_emitted.insert(id);
                        let origin = self.current_origin_frame_id;
                        if matches!(col_type, ColRefKind::Intermediate) {
                            let colref_rt = RuntimeExpr::ColRef {
                                col_type: *col_type,
                                id: *stored_id,
                                row_offset: *stored_offset,
                                origin_frame_id: *stored_origin,
                            };
                            let rt_rc = Rc::new(colref_rt);
                            let key = (origin, id);
                            self.intermediate_ref_resolution
                                .entry(key)
                                .or_insert_with(|| rt_rc.clone());
                            self.global_intermediate_resolution
                                .entry(key)
                                .or_insert_with(|| rt_rc);
                        }
                        Value::ColRef {
                            col_type: ColRefKind::Intermediate,
                            id,
                            row_offset: None,
                            origin_frame_id: Some(origin),
                        }
                    } else {
                        stored
                    }
                }
                _ => stored,
            }
        }
        _ => self.get_var_value_by_type_and_id(ref_type, id),
    }
}

/// Set a variable's value using its reference.
pub(super) fn set_var_value(&mut self, reference: &Reference, value: Value) {
    match reference.ref_type {
        RefType::Int => self.ints.set(reference.id, value),
        RefType::Fe => self.fes.set(reference.id, value),
        RefType::Str => self.strings.set(reference.id, value),
        RefType::Expr => {
            let value = self.sanitize_expr_store_value(reference.id, value);
            self.refresh_intermediate_resolution_after_store(reference.id, &value);
            self.exprs.set(reference.id, value);
        }
        _ => {}
    }
}

/// Set a variable value by type and explicit ID (for indexed array writes).
pub(super) fn set_var_value_by_type_and_id(&mut self, ref_type: &RefType, id: u32, value: Value) {
    match ref_type {
        RefType::Int => self.ints.set(id, value),
        RefType::Fe => self.fes.set(id, value),
        RefType::Str => self.strings.set(id, value),
        RefType::Expr => {
            let value = self.sanitize_expr_store_value(id, value);
            self.refresh_intermediate_resolution_after_store(id, &value);
            self.exprs.set(id, value);
        }
        _ => {}
    }
}

/// If `target_id` is a proof-scope slot (below the current AIR frame
/// start, i.e. a container-owned seed that other AIRs will read back),
/// walk `value` and replace every `ColRef { col_type: Intermediate }`
/// whose id points at an AIR-local `self.exprs` slot with the
/// `RuntimeExpr` snapshot captured at mint time in
/// `intermediate_ref_resolution`. Without this substitution, the stored
/// value carries a ref whose id cannot be resolved by a different
/// AIR's per-AIR `source_to_pos` and pil2-stark-setup panics at
/// `helpers.rs:21:19`. See
/// `BL-20260418-intermediate-ref-cross-air-leak`.
///
/// For AIR-scope writes that overwrite a slot whose `Intermediate` ref
/// was previously captured into `intermediate_ref_resolution`, also
/// replace any self-reference (`Intermediate{id == target_id, origin}`)
/// inside the new value with the prior captured snapshot. Without this,
/// read-modify-write patterns like `compress_exprs`'s
/// `exprs_compressed = exprs_compressed + busid` produce a self-
/// referential stored expression whose serializer-side resolution
/// returns only the pre-store snapshot (dropping the just-added busid
/// term) and breaks SpecifiedRanges / VirtualTable0 / VirtualTable1
/// stage-2 key construction. See
/// `BL-20260419-intermediate-ref-self-ref-store`.
fn sanitize_expr_store_value(&self, target_id: u32, value: Value) -> Value {
    if self.intermediate_ref_resolution.is_empty() {
        return value;
    }
    let origin = self.current_origin_frame_id;
    if target_id < self.exprs.frame_start() {
        // Cross-AIR leak guard: substitute every AIR-local Intermediate
        // ref in the proof-scope-bound value.
        return substitute_air_local_intermediate_in_value(
            value,
            origin,
            &self.intermediate_ref_resolution,
        );
    }
    // AIR-scope write: only substitute the self-reference for `target_id`
    // (not arbitrary other Intermediate refs). The captured
    // resolution at this slot, if any, is the pre-store snapshot whose
    // semantic role is "the OLD value of this slot" — exactly what the
    // self-reference inside the read-modify-write RHS should expand to.
    if !self
        .intermediate_ref_resolution
        .contains_key(&(origin, target_id))
    {
        return value;
    }
    let mut single_entry: std::collections::HashMap<(u32, u32), Rc<RuntimeExpr>> =
        std::collections::HashMap::new();
    single_entry.insert(
        (origin, target_id),
        self.intermediate_ref_resolution[&(origin, target_id)].clone(),
    );
    substitute_air_local_intermediate_in_value(value, origin, &single_entry)
}

/// After storing a new RuntimeExpr into an AIR-scope `expr` slot whose
/// `Intermediate` ref was previously emitted (and thus captured into
/// `intermediate_ref_resolution`), refresh the resolution snapshot to
/// the just-stored value so downstream readers — including
/// proof-scope cross-AIR sanitization (`sanitize_expr_store_value`'s
/// proof-scope branch) and the proto serializer's
/// `global_intermediate_resolution` lookup — observe the post-store
/// state instead of the pre-store snapshot. The companion to the
/// AIR-scope self-ref inline at store time. Together they close
/// `BL-20260419-intermediate-ref-self-ref-store`.
fn refresh_intermediate_resolution_after_store(&mut self, target_id: u32, value: &Value) {
    if target_id < self.exprs.frame_start() {
        return;
    }
    let origin = self.current_origin_frame_id;
    let key = (origin, target_id);
    if !self.intermediate_ref_resolution.contains_key(&key) {
        return;
    }
    if let Value::RuntimeExpr(rt) = value {
        self.intermediate_ref_resolution.insert(key, rt.clone());
        self.global_intermediate_resolution.insert(key, rt.clone());
    }
}

/// Walk every proof-scope slot (`id < self.exprs.frame_start()`) and
/// substitute any `Intermediate` ref whose id points at an AIR-local
/// slot with the `RuntimeExpr` captured at ref-emission time. Called
/// once at AIR exit, just before the intermediate-ref trackers are
/// cleared and `self.exprs.pop()` merges proof-scope writes back onto
/// the restored proof frame. This is the cross-AIR backstop: even if a
/// leak path bypassed `sanitize_expr_store_value` at set time, the
/// proof-scope value never leaves the AIR with a dangling
/// `Intermediate` id. See
/// `BL-20260418-intermediate-ref-cross-air-leak`.
pub(super) fn sanitize_proof_scope_exprs_at_air_exit(&mut self) {
    let frame_start = self.exprs.frame_start();
    if self.intermediate_ref_resolution.is_empty() {
        return;
    }
    let resolution = self.intermediate_ref_resolution.clone();
    let origin = self.current_origin_frame_id;
    // Walk every slot in this AIR's `self.exprs` that may survive into
    // the proof frame via `variables::pop`'s `container_owned` merge.
    // Seeded proof-scope slots (id < frame_start) plus any slot marked
    // container_owned inside the AIR body count. Substituting in
    // within-AIR-only slots is harmless because the lift's
    // `air_expression_store` entries carry their own RuntimeExpr
    // clones, so the proto serializer keeps resolving every emitted
    // `Intermediate` ref via `source_to_pos` regardless of what we
    // overwrite on `self.exprs.values` here.
    let total_len = self.exprs.len();
    for id in 0..total_len {
        let is_proof_scope = id < frame_start;
        let is_container = self
            .exprs
            .ids
            .datas
            .get(id as usize)
            .map(|d| d.container_owned)
            .unwrap_or(false);
        if !is_proof_scope && !is_container {
            continue;
        }
        let current = match self.exprs.get(id) {
            Some(v) => v.clone(),
            None => continue,
        };
        let rewritten = substitute_air_local_intermediate_in_value(
            current,
            origin,
            &resolution,
        );
        self.exprs.set(id, rewritten);
    }
}

}

fn substitute_air_local_intermediate_in_value(
    value: Value,
    origin_frame_id: u32,
    resolution: &std::collections::HashMap<(u32, u32), Rc<RuntimeExpr>>,
) -> Value {
    match value {
        Value::ColRef {
            col_type: ColRefKind::Intermediate,
            id,
            row_offset: _,
            origin_frame_id: Some(ref_origin),
        } if ref_origin == origin_frame_id =>
        {
            if let Some(rt) = resolution.get(&(ref_origin, id)) {
                let rewritten = substitute_air_local_intermediate_in_rt(
                    rt.clone(),
                    origin_frame_id,
                    resolution,
                );
                Value::RuntimeExpr(rewritten)
            } else {
                Value::ColRef {
                    col_type: ColRefKind::Intermediate,
                    id,
                    row_offset: None,
                    origin_frame_id: Some(ref_origin),
                }
            }
        }
        Value::RuntimeExpr(rt) => Value::RuntimeExpr(
            substitute_air_local_intermediate_in_rt(rt, origin_frame_id, resolution),
        ),
        Value::Array(items) => Value::Array(
            items
                .into_iter()
                .map(|v| substitute_air_local_intermediate_in_value(v, origin_frame_id, resolution))
                .collect(),
        ),
        other => other,
    }
}

fn substitute_air_local_intermediate_in_rt(
    rt: Rc<RuntimeExpr>,
    origin_frame_id: u32,
    resolution: &std::collections::HashMap<(u32, u32), Rc<RuntimeExpr>>,
) -> Rc<RuntimeExpr> {
    match &*rt {
        RuntimeExpr::ColRef {
            col_type: ColRefKind::Intermediate,
            id,
            row_offset: _,
            origin_frame_id: Some(ref_origin),
        } if *ref_origin == origin_frame_id =>
        {
            if let Some(replacement) = resolution.get(&(*ref_origin, *id)) {
                substitute_air_local_intermediate_in_rt(
                    replacement.clone(),
                    origin_frame_id,
                    resolution,
                )
            } else {
                rt
            }
        }
        RuntimeExpr::BinOp { op, left, right } => {
            let new_left = substitute_air_local_intermediate_in_rt(
                left.clone(),
                origin_frame_id,
                resolution,
            );
            let new_right = substitute_air_local_intermediate_in_rt(
                right.clone(),
                origin_frame_id,
                resolution,
            );
            if Rc::ptr_eq(&new_left, left) && Rc::ptr_eq(&new_right, right) {
                rt
            } else {
                Rc::new(RuntimeExpr::BinOp {
                    op: *op,
                    left: new_left,
                    right: new_right,
                })
            }
        }
        RuntimeExpr::UnaryOp { op, operand } => {
            let new_operand = substitute_air_local_intermediate_in_rt(
                operand.clone(),
                origin_frame_id,
                resolution,
            );
            if Rc::ptr_eq(&new_operand, operand) {
                rt
            } else {
                Rc::new(RuntimeExpr::UnaryOp { op: *op, operand: new_operand })
            }
        }
        RuntimeExpr::Value(inner) => {
            let rewritten = substitute_air_local_intermediate_in_value(
                inner.clone(),
                origin_frame_id,
                resolution,
            );
            match rewritten {
                Value::RuntimeExpr(inner_rt) => inner_rt,
                other => Rc::new(RuntimeExpr::Value(other)),
            }
        }
        RuntimeExpr::ColRef { .. } => rt,
        // The substitute pass targets Intermediate `ColRef`s only.
        // An ExprRef is a deliberate by-id indirection; resolving
        // it here would defeat the Phase 2 design. Keep the node
        // intact and let the proto serializer / Phase 3 importer
        // resolve it through `global_intermediate_resolution`.
        RuntimeExpr::ExprRef { .. } => rt,
    }
}
