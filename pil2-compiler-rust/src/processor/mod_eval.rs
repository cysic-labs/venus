//! Expression and reference evaluation chain extracted from
//! processor/mod.rs to keep that file below the project code-size
//! guideline.
//!
//! Methods keep `pub(super)` visibility so callers in the parent
//! module resolve them through the shared `impl super::Processor`
//! namespace.

use crate::parser::ast::*;

use super::builtins;
use super::builtins::BuiltinKind;
use super::expression;
use super::expression::{ColRefKind, RuntimeExpr, Value};
use super::ids::{self, IdData};
use super::mod_utils::{
    compute_flat_index, compute_flat_index_partial, reorder_named_args, value_to_runtime_expr,
};
use super::references::RefType;
use super::CallStackEntry;
use super::FlowSignal;
use super::Processor;

impl Processor {
/// Evaluate a reference (variable or column lookup).
pub(super) fn eval_reference(&mut self, name_id: &NameId) -> Value {
    let name = &name_id.path;
    // Fast path: try direct lookup first to avoid allocating namespace
    // variants. This is a significant optimization for tight loops.
    let reference_opt = self.references.get_reference(name).cloned().or_else(|| {
        let names = self.namespace_ctx.get_names(name);
        self.references.get_reference_multi(&names).cloned()
    });
    if let Some(reference) = reference_opt {
        // Handle array indexing.
        if !name_id.indexes.is_empty() && !reference.array_dims.is_empty() {
            let indexes: Vec<i128> = name_id
                .indexes
                .iter()
                .map(|e| self.eval_expr(e).as_int().unwrap_or(0))
                .collect();
            if indexes.len() < reference.array_dims.len() {
                // Partial indexing: return ArrayRef for the sub-array.
                let flat_idx = compute_flat_index_partial(&indexes, &reference.array_dims);
                let remaining = reference.array_dims[indexes.len()..].to_vec();
                return Value::ArrayRef {
                    ref_type: reference.ref_type.clone(),
                    base_id: reference.id + flat_idx,
                    dims: remaining,
                };
            }
            let flat_idx = compute_flat_index(&indexes, &reference.array_dims);
            let id = reference.id + flat_idx;
            // Storage read for now. Round 3 attempt to flip to
            // `get_var_ref_value_by_type_and_id` plus per-AIR
            // `intermediate_refs_emitted` force-lift exposed a
            // deeper cross-AIR reference leak: proof-scope `expr`
            // values written in one AIR's frame can contain
            // `Intermediate` refs that another AIR reads inlined
            // through `get_var_value`, leaving the per-AIR
            // `source_to_pos` map without an entry for the foreign
            // id and pil2-stark-setup indexing past `expressions[]`
            // (`helpers.rs:21:19`). Round 4 plan: either embed
            // scope info into the ref (so each AIR's serializer
            // knows when to inline vs resolve) or strip
            // `Intermediate` refs at AIR boundaries when they
            // would leak. See
            // BL-20260418-intermediate-ref-lift-consistency.
            return self.get_var_value_by_type_and_id(&reference.ref_type, id);
        }
        // Bare reference to an array (no indexes): return ArrayRef so
        // that callers (function/airtemplate argument binding, further
        // ArrayIndex operations) can index into it.
        if name_id.indexes.is_empty() && !reference.array_dims.is_empty() {
            return Value::ArrayRef {
                ref_type: reference.ref_type.clone(),
                base_id: reference.id,
                dims: reference.array_dims.clone(),
            };
        }
        // Bare scalar reference: storage read for now (same Round
        // 3 cross-AIR reference leak caveat as the indexed path
        // above). Round 4 plan re-enables the ref helper after
        // closing the cross-AIR leak class.
        self.get_var_value(&reference)
    } else {
        Value::Void
    }
}

/// JS row-offset formatting: `rowOffsetToString` from
/// packed_expressions.js. Prefix form for negative offsets
/// (`'x`, `2'x`), suffix for positive (`x'`, `x'2`), bare for zero.
pub(super) fn format_row_offset(label: &str, offset: i64) -> String {
    if offset == 0 {
        return label.to_string();
    }
    if offset < 0 {
        let o = -offset;
        if o == 1 {
            format!("'{}", label)
        } else {
            format!("{}'{}", o, label)
        }
    } else if offset == 1 {
        format!("{}'", label)
    } else {
        format!("{}'{}", label, offset)
    }
}

/// Look up the declared label for a column id, applying array
/// indexing when the label range covers more than one slot.
pub(super) fn column_label(&self, col_type: &expression::ColRefKind, id: u32) -> Option<String> {
    use expression::ColRefKind;
    let ranges: &ids::LabelRanges = match col_type {
        ColRefKind::Witness => &self.witness_cols.label_ranges,
        ColRefKind::Fixed => &self.fixed_cols.ids.label_ranges,
        ColRefKind::Custom => &self.custom_cols.label_ranges,
        ColRefKind::AirValue => &self.air_values.label_ranges,
        ColRefKind::AirGroupValue => &self.air_group_values.label_ranges,
        ColRefKind::Public => &self.publics.label_ranges,
        ColRefKind::Challenge => &self.challenges.label_ranges,
        ColRefKind::ProofValue => &self.proof_values.label_ranges,
        _ => return None,
    };
    for range in ranges.to_vec().iter() {
        if id >= range.from && id < range.from + range.count {
            if range.array_dims.is_empty() {
                return Some(range.label.clone());
            }
            let offset = id - range.from;
            return Some(format!("{}[{}]", range.label, offset));
        }
    }
    None
}

/// JS-equivalent `string(expr)` cast: resolve column references to
/// their declared labels rather than the Rust `Value` debug form.
/// Mirrors the `toString({hideClass: true, hideLabel: false})`
/// path invoked from `builtin/cast.js`.
pub(super) fn value_to_label_string(&self, val: &Value) -> String {
    match val {
        Value::ColRef { col_type, id, row_offset } => {
            let label = self
                .column_label(col_type, *id)
                .unwrap_or_else(|| format!("{:?}@{}", col_type, id));
            Self::format_row_offset(&label, row_offset.unwrap_or(0))
        }
        Value::ArrayRef { ref_type, base_id, dims } => {
            use crate::processor::references::RefType;
            let col_type = match ref_type {
                RefType::Witness => Some(expression::ColRefKind::Witness),
                RefType::Fixed => Some(expression::ColRefKind::Fixed),
                RefType::CustomCol => Some(expression::ColRefKind::Custom),
                RefType::AirValue => Some(expression::ColRefKind::AirValue),
                RefType::AirGroupValue => Some(expression::ColRefKind::AirGroupValue),
                RefType::Public => Some(expression::ColRefKind::Public),
                RefType::Challenge => Some(expression::ColRefKind::Challenge),
                RefType::ProofValue => Some(expression::ColRefKind::ProofValue),
                _ => None,
            };
            if let Some(kind) = col_type {
                if let Some(label) = self.column_label(&kind, *base_id) {
                    return label;
                }
            }
            let dims_str: Vec<String> = dims.iter().map(|d| d.to_string()).collect();
            format!("{:?}@{}[{}]", ref_type, base_id, dims_str.join(","))
        }
        _ => val.to_display_string(),
    }
}

/// Replace any `Value::ColRef { col_type: Intermediate, id, .. }`
/// arg with the underlying stored value from `self.exprs[id]`.
///
/// `eval_reference` returns an `Intermediate` `ColRef` for AIR-
/// scope `RefType::Expr` reads of a stored `RuntimeExpr` so that
/// the proto serializer can dedupe later use sites via the
/// `(source_expr_id, row_offset)` provenance cache (mirroring JS
/// `pushExpressionReference`). That wrapper is meaningless to
/// compile-time consumers like `length(...)`, `degree(...)`,
/// `dim(...)`, `defined(...)`, and `is_array(...)`; without
/// dereferencing here those consumers see a single ColRef leaf
/// and return wrong shape / degree (e.g.
/// `degree(Intermediate) == 0` would skip the `<==` witness-col
/// branch in `precompiles/dma/pil/dma.pil` even when the
/// underlying expression has degree 2).
///
/// Only `Intermediate` is dereferenced; other `ColRef` kinds
/// (Witness, Fixed, Custom, etc.) are real leaves whose builtin
/// semantics are stable.
pub(super) fn dereference_intermediate_args(&self, args: &mut [Value]) {
    use super::expression::ColRefKind;
    for arg in args.iter_mut() {
        if let Value::ColRef { col_type: ColRefKind::Intermediate, id, .. } = *arg {
            if let Some(stored) = self.exprs.get(id).cloned() {
                *arg = stored;
            }
        }
    }
}

/// Get a variable value by type and ID.
pub(super) fn get_var_value_by_type_and_id(&self, ref_type: &RefType, id: u32) -> Value {
    match ref_type {
        RefType::Int => self.ints.get(id).cloned().unwrap_or(Value::Int(0)),
        RefType::Fe => self.fes.get(id).cloned().unwrap_or(Value::Fe(0)),
        RefType::Str => self
            .strings
            .get(id)
            .cloned()
            .unwrap_or(Value::Str(String::new())),
        RefType::Expr => self.exprs.get(id).cloned().unwrap_or(Value::Void),
        RefType::Fixed => Value::ColRef {
            col_type: ColRefKind::Fixed,
            id,
            row_offset: None,
        },
        RefType::Witness => Value::ColRef {
            col_type: ColRefKind::Witness,
            id,
            row_offset: None,
        },
        RefType::Public => Value::ColRef {
            col_type: ColRefKind::Public,
            id,
            row_offset: None,
        },
        RefType::Challenge => Value::ColRef {
            col_type: ColRefKind::Challenge,
            id,
            row_offset: None,
        },
        RefType::ProofValue => Value::ColRef {
            col_type: ColRefKind::ProofValue,
            id,
            row_offset: None,
        },
        RefType::AirGroupValue => Value::ColRef {
            col_type: ColRefKind::AirGroupValue,
            id,
            row_offset: None,
        },
        RefType::AirValue => Value::ColRef {
            col_type: ColRefKind::AirValue,
            id,
            row_offset: None,
        },
        RefType::CustomCol => Value::ColRef {
            col_type: ColRefKind::Custom,
            id,
            row_offset: None,
        },
        _ => Value::Void,
    }
}

/// Recursively build a dotted name from a MemberAccess chain.
/// E.g. `air.std.connect` from nested MemberAccess nodes.
pub(super) fn build_dotted_name(&self, base: &Expr, member: &str) -> Option<String> {
    let base_name = match base {
        Expr::Reference(name_id) => Some(name_id.path.clone()),
        Expr::MemberAccess {
            base: inner_base,
            member: inner_member,
        } => self.build_dotted_name(inner_base, inner_member),
        _ => None,
    };
    base_name.map(|b| format!("{}.{}", b, member))
}

/// Try to resolve a chain of ArrayIndex nodes whose innermost base is
/// either a Reference or a MemberAccess that resolves to an array
/// variable.  Returns Some(value) when successfully resolved, None
/// when the pattern does not apply (caller should fall through to the
/// normal ArrayIndex evaluation).
///
/// In expression context the parser produces
///   `ArrayIndex(ArrayIndex(Reference("name"), idx0), idx1)`
/// for `name[idx0][idx1]`, and
///   `ArrayIndex(MemberAccess(Ref("alias"), "field"), idx)`
/// for `alias.field[idx]`.
///
/// Without this helper, evaluating the innermost Reference/MemberAccess
/// returns only the scalar at the base ID, losing array dimension info,
/// so subsequent ArrayIndex operations return Void.
pub(super) fn try_resolve_indexed_reference(&mut self, expr: &Expr) -> Option<Value> {
    // Peel off ArrayIndex layers, collecting indexes outermost-first.
    let mut indexes_rev: Vec<i128> = Vec::new();
    let mut current = expr;
    loop {
        match current {
            Expr::ArrayIndex { base, index } => {
                let idx = self.eval_expr(index).as_int()?;
                indexes_rev.push(idx);
                current = base;
            }
            Expr::MemberAccess { base, member } => {
                let dotted = self.build_dotted_name(base, member)?;
                let reference = self.references.get_reference(&dotted).cloned().or_else(|| {
                    let names = self.namespace_ctx.get_names(&dotted);
                    self.references.get_reference_multi(&names).cloned()
                })?;
                if reference.array_dims.is_empty() {
                    return None;
                }
                indexes_rev.reverse();
                if indexes_rev.len() > reference.array_dims.len() {
                    return None;
                }
                return Some(self.resolve_partial_array(
                    &reference.ref_type,
                    reference.id,
                    &reference.array_dims,
                    &indexes_rev,
                ));
            }
            Expr::Reference(name_id) if name_id.indexes.is_empty() => {
                let name = &name_id.path;
                let reference = self.references.get_reference(name).cloned().or_else(|| {
                    let names = self.namespace_ctx.get_names(name);
                    self.references.get_reference_multi(&names).cloned()
                })?;
                if reference.array_dims.is_empty() {
                    return None;
                }
                indexes_rev.reverse();
                if indexes_rev.len() > reference.array_dims.len() {
                    return None;
                }
                return Some(self.resolve_partial_array(
                    &reference.ref_type,
                    reference.id,
                    &reference.array_dims,
                    &indexes_rev,
                ));
            }
            _ => return None,
        }
    }
}

/// Resolve a (possibly partial) array index.
///
/// When fully indexed (`indexes.len() == dims.len()`), returns the
/// scalar element.  When partially indexed, returns an `ArrayRef`
/// carrying the sub-array's base ID and remaining dimensions so that
/// further ArrayIndex operations or parameter binding can continue.
pub(super) fn resolve_partial_array(
    &self,
    ref_type: &RefType,
    base_id: u32,
    dims: &[u32],
    indexes: &[i128],
) -> Value {
    let flat_idx = compute_flat_index_partial(indexes, dims);
    let id = base_id + flat_idx;
    if indexes.len() == dims.len() {
        self.get_var_value_by_type_and_id(ref_type, id)
    } else {
        let remaining_dims = dims[indexes.len()..].to_vec();
        Value::ArrayRef {
            ref_type: ref_type.clone(),
            base_id: id,
            dims: remaining_dims,
        }
    }
}

/// Evaluate an expression into a RuntimeExpr (for constraints).
pub(super) fn eval_expr_to_runtime(&mut self, expr: &Expr) -> RuntimeExpr {
    let val = self.eval_expr(expr);
    value_to_runtime_expr(&val)
}

/// Evaluate a function call.
pub(super) fn eval_function_call(&mut self, fc: &FunctionCall) -> Value {
    let name = &fc.function.path;

    // Fast path for no-op builtins: skip argument evaluation entirely.
    // In the JS compiler, `log` is handled by the transpiler context and
    // is effectively a no-op during normal interpreted execution.
    if matches!(name.as_str(), "log") {
        return Value::Int(0);
    }

    // Evaluate all call arguments (values only).
    let mut raw_args: Vec<Value> = fc.args.iter().map(|a| self.eval_expr(&a.value)).collect();

    // Check for builtin (builtins don't use named args).
    if let Some(kind) = BuiltinKind::from_name(name) {
        // Compile-time builtins (length / dim / degree / defined /
        // is_array) inspect a value's shape rather than its proto-
        // serialization identity. Replace any
        // `ColRef::Intermediate { id, .. }` arg - produced by the
        // Round 2 expression-reference refactor in
        // `eval_reference` for `RefType::Expr` reads of a stored
        // `RuntimeExpr` - with the underlying stored value so
        // these consumers keep seeing the original tree they used
        // to inspect pre-refactor.
        self.dereference_intermediate_args(&mut raw_args);
        match builtins::exec_builtin(kind, &raw_args, &self.source_ref, &mut self.tests) {
            Ok(val) => return val,
            Err(msg) => {
                eprintln!("error: {} at {}", msg, self.source_ref);
                // In the JS compiler, error()/assert()/assert_eq()
                // throw exceptions that unwind the call stack. When
                // inside a user function, set a flag to short-circuit
                // statement execution in the enclosing function. At
                // proof level there is no function to unwind so we
                // just report and continue.
                self.error_count += 1;
                if self.function_deep > 0 {
                    self.error_raised = true;
                }
                return Value::Void;
            }
        }
    }

    // Helper: reorder args if any are named, matching the function
    // definition's parameter order.
    let has_named = fc.args.iter().any(|a| a.name.is_some());

    // Check for user-defined function.
    if let Some(func_def) = self.functions.get(name).cloned() {
        let args = if has_named {
            reorder_named_args(&fc.args, &raw_args, &func_def.args)
        } else {
            raw_args
        };
        return self.execute_user_function(&func_def, &args);
    }

    // Check namespace-qualified names.
    let names = self.namespace_ctx.get_names(name);
    for qualified_name in &names {
        if let Some(func_def) = self.functions.get(qualified_name).cloned() {
            let args = if has_named {
                reorder_named_args(&fc.args, &raw_args, &func_def.args)
            } else {
                raw_args.clone()
            };
            return self.execute_user_function_by_name(&func_def, &args, qualified_name);
        }
    }

    // Check for airtemplate call (creating an air instance).
    if let Some(tpl) = self.air_templates.get(name).cloned() {
        let args = if has_named {
            reorder_named_args(&fc.args, &raw_args, &tpl.args)
        } else {
            raw_args
        };
        return self.execute_air_template_call(&tpl, &args, name, false);
    }

    // Tables.* built-in functions for fixed column manipulation.
    match name.as_str() {
        "Tables.num_rows" => return self.tables_num_rows(&raw_args),
        "Tables.fill" => return self.tables_fill(&raw_args),
        "Tables.copy" => return self.tables_copy(&raw_args),
        _ => {}
    }

    Value::Void
}

/// Evaluate a function call with optional alias and virtual flag.
/// Used by exec_expr_stmt and exec_virtual_expr for airtemplate calls.
pub(super) fn eval_function_call_with_alias(
    &mut self,
    fc: &FunctionCall,
    alias: Option<&str>,
    is_virtual: bool,
) -> FlowSignal {
    let name = &fc.function.path;

    // Fast path for no-op builtins (see eval_function_call).
    if matches!(name.as_str(), "log") {
        return FlowSignal::None;
    }

    let mut raw_args: Vec<Value> = fc.args.iter().map(|a| self.eval_expr(&a.value)).collect();
    let has_named = fc.args.iter().any(|a| a.name.is_some());

    // Check for builtin (builtins can't be aliased, but handle for safety).
    if let Some(kind) = BuiltinKind::from_name(name) {
        // Same Intermediate-deref policy as the function-call form
        // above: compile-time builtins must see the underlying
        // stored tree, not the Round 2 expression-reference
        // wrapper.
        self.dereference_intermediate_args(&mut raw_args);
        match builtins::exec_builtin(kind, &raw_args, &self.source_ref, &mut self.tests) {
            Ok(_val) => return FlowSignal::None,
            Err(msg) => {
                eprintln!("error: {} at {}", msg, self.source_ref);
                self.error_count += 1;
                if self.function_deep > 0 {
                    self.error_raised = true;
                }
                return FlowSignal::None;
            }
        }
    }

    // Check for user-defined function.
    if let Some(func_def) = self.functions.get(name).cloned() {
        let args = if has_named {
            reorder_named_args(&fc.args, &raw_args, &func_def.args)
        } else {
            raw_args
        };
        self.execute_user_function(&func_def, &args);
        return FlowSignal::None;
    }

    // Check namespace-qualified names.
    let names = self.namespace_ctx.get_names(name);
    for qualified_name in &names {
        if let Some(func_def) = self.functions.get(qualified_name).cloned() {
            let args = if has_named {
                reorder_named_args(&fc.args, &raw_args, &func_def.args)
            } else {
                raw_args.clone()
            };
            self.execute_user_function_by_name(&func_def, &args, qualified_name);
            return FlowSignal::None;
        }
    }

    // Check for airtemplate call: use alias as instance name if provided.
    if let Some(tpl) = self.air_templates.get(name).cloned() {
        let args = if has_named {
            reorder_named_args(&fc.args, &raw_args, &tpl.args)
        } else {
            raw_args
        };
        let raw_instance_name = alias.unwrap_or(name);
        // Expand template strings (e.g. `VirtualTable${i}` -> `VirtualTable0`).
        let instance_name = self.expand_templates(raw_instance_name);
        self.execute_air_template_call(&tpl, &args, &instance_name, is_virtual);
        return FlowSignal::None;
    }

    FlowSignal::None
}

/// Execute a user-defined function.
pub(super) fn execute_user_function(&mut self, func: &FunctionDef, args: &[Value]) -> Value {
    let lookup_name = func.name.clone();
    self.execute_user_function_by_name(func, args, &lookup_name)
}

/// Variant of `execute_user_function` that accepts the explicit
/// lookup key used to resolve the function in `self.functions`.
/// This matters for namespaced functions: `exec_function_definition`
/// stores air-local functions under a qualified key like
/// `<air>.<func>`, and the visibility window's creation_scope lookup
/// must consult that qualified key, not the bare AST name carried in
/// `func.name`.
pub(super) fn execute_user_function_by_name(
    &mut self,
    func: &FunctionDef,
    args: &[Value],
    lookup_name: &str,
) -> Value {
    // Snapshot expression stores so we can reclaim function-local
    // expression memory after the call returns. Constraints and
    // hints capture their own copies, so function-scoped expression
    // variables are safe to drop.
    let exprs_mark = self.exprs.snapshot();
    let ints_mark = self.ints.snapshot();
    let fes_mark = self.fes.snapshot();
    let strings_mark = self.strings.snapshot();

    // Snapshot the `use_aliases` stack so any `use` statement run
    // inside this function body (directly, or transitively through
    // further calls) is lexical to the function's scope. Prior
    // behavior accumulated aliases globally across calls; for
    // example, `gsum_update_global_constraint_data` runs
    // `use proof.std.gsum;`, and without the restore the proof-scope
    // alias leaked into every subsequent AIR's template body,
    // shadowing the air-scope `use air.std.gsum;` and misresolving
    // `gsum` in `@gsum_col{reference: gsum, ...}` at
    // `std_sum.pil:694` to either a stale proof-scope binding or
    // the local `expr gsum = 0` at `std_sum.pil:176`. Matches JS
    // pil2-compiler, where `use` is function-scoped.
    let use_aliases_mark = self.references.snapshot_use_aliases();

    self.function_deep += 1;
    self.callstack.push(CallStackEntry {
        name: func.name.clone(),
        source: self.source_ref.clone(),
    });
    // Mirror JS pil2-compiler's `pushVisibilityScope(creationScope)`:
    // `visibilityScope = [Context.scope.deep, creationScope]`. The lo
    // bound is the scope depth AT call entry (after push); the hi
    // bound is the scope at which this function was declared, looked
    // up from the function's own `Reference::scope_id`. Top-level
    // definitions land at scope 0-1, so most calls resolve through
    // the global half of the window; rare nested definitions retain
    // their outer closure scope.
    let creation_scope = self
        .references
        .get_direct_ref(lookup_name)
        .map(|r| r.scope_id)
        .unwrap_or(1);
    self.scope.push();
    self.references
        .push_visibility_scope(self.scope.deep, Some(creation_scope));

    // Bind arguments.
    for (i, arg_def) in func.args.iter().enumerate() {
        let value = args
            .get(i)
            .cloned()
            .and_then(|v| if matches!(v, Value::Void) { None } else { Some(v) })
            .or_else(|| {
                arg_def
                    .default_value
                    .as_ref()
                    .map(|e| self.eval_expr(e))
            })
            .unwrap_or(Value::Void);

        // Array reference arguments: bind the parameter directly to
        // the same storage as the original array.
        if let Value::ArrayRef { ref_type, base_id, dims } = &value {
            let previous = self.references.get_direct_ref(&arg_def.name).cloned();
            self.references.declare(
                &arg_def.name,
                ref_type.clone(),
                *base_id,
                &dims.iter().copied().collect::<Vec<u32>>(),
                arg_def.type_info.is_const,
                self.scope.deep,
                &self.source_ref,
            );
            self.scope.declare(&arg_def.name, previous);
            // PIL2C_TRACE_LEAK hook (tag: uf-bind-arrayref). Emits one
            // line per ArrayRef-typed function-parameter bind for a
            // watched name, so rescue rounds can correlate declare-time
            // dims with the dims that search_definition returns later.
            if std::env::var("PIL2C_TRACE_LEAK").is_ok() {
                let wl = &["opids","exprs_num","num_reps","mins","maxs","opids_count"];
                if wl.contains(&arg_def.name.as_str()) {
                    eprintln!("[pil2c-trace] [uf-bind-arrayref] name={} depth={} dims={:?}", arg_def.name, self.scope.deep, dims);
                }
            }
            continue;
        }

        let ref_type = match &arg_def.type_info.kind {
            TypeKind::Int => RefType::Int,
            TypeKind::Fe => RefType::Fe,
            TypeKind::StringType => RefType::Str,
            TypeKind::Expr => RefType::Expr,
            _ => RefType::Int,
        };
        let store_id = match ref_type {
            RefType::Int => {
                let id = self.ints.reserve(1, Some(&arg_def.name), &[], IdData::default());
                self.ints.set(id, value);
                id
            }
            RefType::Fe => {
                let id = self.fes.reserve(1, Some(&arg_def.name), &[], IdData::default());
                self.fes.set(id, value);
                id
            }
            RefType::Str => {
                let id = self.strings.reserve(1, Some(&arg_def.name), &[], IdData::default());
                self.strings.set(id, value);
                id
            }
            RefType::Expr => {
                // Function parameter: do NOT label the underlying
                // exprs slot. JS binds the argument through the
                // local scope without naming the expression itself,
                // so emitting an IM symbol under the formal parameter
                // name is a Rust-only artifact. Without the label,
                // the IM-symbol harvester skips it entirely.
                let id = self.exprs.reserve(1, None, &[], IdData::default());
                self.exprs.set(id, value);
                id
            }
            _ => 0,
        };

        let previous = self.references.get_direct_ref(&arg_def.name).cloned();
        self.references.declare(
            &arg_def.name,
            ref_type,
            store_id,
            &[],
            arg_def.type_info.is_const,
            self.scope.deep,
            &self.source_ref,
        );
        self.scope.declare(&arg_def.name, previous);
    }

    // Execute body.
    let result = self.execute_statements(&func.body);

    // Do NOT clear error_raised here. In the JS compiler, errors
    // (thrown exceptions) propagate through all function call frames
    // (executeFunctionCall uses try/finally, not try/catch) and are
    // only caught at the statement execution level or the airtemplate
    // call boundary. Clearing here would swallow errors from nested
    // callees, allowing the caller to resume incorrectly.

    self.references.pop_visibility_scope();
    // Restore the `use_aliases` stack to its pre-call length so
    // aliases introduced inside this function body (or by nested
    // calls that ran `use`) do not leak into the caller's
    // resolution. Paired with the `snapshot_use_aliases` at
    // function entry.
    self.references.restore_use_aliases_len(use_aliases_mark);
    let (to_unset, to_restore) = self.scope.pop();
    self.apply_scope_cleanup(&to_unset, &to_restore);
    self.callstack.pop();
    self.function_deep -= 1;

    let ret = match result {
        FlowSignal::Return(val) => val,
        _ => Value::Int(0),
    };

    // Do NOT trim any store on function return. Expression slots
    // written inside a container (e.g. `air.std.gprod.*`) belong to
    // the enclosing container's lifetime, not the function's, and
    // must survive the return so deferred-final calls like
    // `piop_gprod_air()` can read them later. Trimming exprs here
    // erased those container-backed slots and dropped the `@im_col`
    // hints plus extra stage2/stage1/fixed columns from
    // `vadcop_final.pilout`. JS `executeFunctionCall` does not trim.
    // The int/fe/string stores are already preserved for the same
    // lifetime reasons (see BL-20260331-trim-container-vars).
    let _ = (exprs_mark, ints_mark, fes_mark, strings_mark);

    ret
}

// -----------------------------------------------------------------------
// Expression statement
// -----------------------------------------------------------------------

pub(super) fn exec_expr_stmt(&mut self, es: &ExprStmt) -> FlowSignal {
    // If this is a function call with an alias, handle airtemplate
    // aliasing: `Dma(enable: E_DMA_MEMCPY) alias DmaMemCpy` creates
    // an air instance named "DmaMemCpy" instead of "Dma".
    if let Expr::FunctionCall(fc) = &es.expr {
        if es.alias.is_some() || true {
            // Always go through the alias-aware path so that airtemplate
            // calls get proper naming.
            return self.eval_function_call_with_alias(fc, es.alias.as_deref(), false);
        }
    }
    self.eval_expr(&es.expr);
    FlowSignal::None
}

pub(super) fn exec_virtual_expr(&mut self, ve: &VirtualExprStmt) -> FlowSignal {
    // Virtual expressions create virtual air instances with is_virtual=true.
    if let Expr::FunctionCall(fc) = &ve.expr {
        return self.eval_function_call_with_alias(fc, ve.alias.as_deref(), true);
    }
    self.eval_expr(&ve.expr);
    FlowSignal::None
}
}
