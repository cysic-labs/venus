//! `execute_air_template_call` extracted from processor/mod.rs to keep
//! mod.rs below the project code-size guideline. The function is the
//! largest single method in the processor and moves as a self-contained
//! `pub(super) fn` on `impl super::Processor`.

use std::collections::HashMap;

use super::air;
use super::air::AirTemplateInfo;
use super::expression::Value;
use super::ids::IdData;
use super::mod_utils::{
    collect_custom_ids_in_expr, collect_custom_ids_in_hint, is_symbolic, value_to_runtime_expr,
};
use super::references::RefType;
use super::CallStackEntry;
use super::Processor;

impl Processor {
/// Execute an air template call, creating a new air instance.
pub(super) fn execute_air_template_call(
    &mut self,
    tpl: &AirTemplateInfo,
    args: &[Value],
    name: &str,
    is_virtual: bool,
) -> Value {
    let ag_name = match &self.current_air_group {
        Some(n) => n.clone(),
        None => {
            eprintln!("error: air template call outside airgroup at {}", self.source_ref);
            return Value::Void;
        }
    };

    eprintln!(
        "\nAIR {}instance {} in airgroup {}",
        if is_virtual { "virtual " } else { "" },
        name,
        ag_name
    );
    // Push function scope and bind arguments.
    self.function_deep += 1;
    self.callstack.push(CallStackEntry {
        name: name.to_string(),
        source: self.source_ref.clone(),
    });
    self.scope.push();

    for (i, arg_def) in tpl.args.iter().enumerate() {
        let value = args
            .get(i)
            .cloned()
            .and_then(|v| if matches!(v, Value::Void) { None } else { Some(v) })
            .or_else(|| arg_def.default_value.as_ref().map(|e| self.eval_expr(e)))
            .unwrap_or(Value::Void);

        // Array parameters: when the argument is an ArrayRef (from a
        // partially-indexed array or a bare array reference), bind the
        // parameter directly to the same storage location so that
        // indexed access inside the template body works.
        if let Value::ArrayRef { ref_type, base_id, dims } = &value {
            let previous = self.references.get_direct_ref(&arg_def.name).cloned();
            self.references.declare(
                &arg_def.name,
                ref_type.clone(),
                *base_id,
                &dims.iter().map(|d| *d).collect::<Vec<u32>>(),
                arg_def.type_info.is_const,
                self.scope.deep,
                &self.source_ref,
            );
            self.scope.declare(&arg_def.name, previous);
            continue;
        }

        let previous_at = self.references.get_direct_ref(&arg_def.name).cloned();
        let store_id = self
            .ints
            .reserve(1, Some(&arg_def.name), &[], IdData::default());
        self.ints.set(store_id, value);
        self.references.declare(
            &arg_def.name,
            RefType::Int,
            store_id,
            &[],
            arg_def.type_info.is_const,
            self.scope.deep,
            &self.source_ref,
        );
        // Record in scope shadow map so that scope.pop() + apply_scope_cleanup
        // unsets or restores this binding when the airtemplate exits.
        // Without this, non-ArrayRef parameters (including Value::Array ones
        // that fall through to the fallback branch) persist in self.refs
        // as stale bindings across airtemplate boundaries, shadowing
        // container fields of the same name in deferred handlers.
        self.scope.declare(&arg_def.name, previous_at);
        // PIL2C_TRACE_LEAK hook (tag: at-bind-scalar). Emits one line
        // per scalar airtemplate-arg bind for a watched name, completing
        // the bind-site coverage that the ArrayRef branch in
        // execute_user_function starts. Paired with cleanup-unset /
        // cleanup-restore to verify airtemplate-exit cleanup actually
        // removes the binding.
        #[allow(clippy::if_same_then_else)]
        if std::env::var("PIL2C_TRACE_LEAK").is_ok() {
            let wl = &["opids","exprs_num","num_reps","mins","maxs","opids_count"];
            if wl.contains(&arg_def.name.as_str()) {
                eprintln!("[pil2c-trace] [at-bind-scalar] name={} depth={} store_id={}", arg_def.name, self.scope.deep, store_id);
            }
        }
    }

    // Determine rows from N parameter.
    let rows = self
        .references
        .get_reference("N")
        .map(|r| r.id)
        .and_then(|id| self.ints.get(id))
        .and_then(|v| v.as_int())
        .unwrap_or(0) as u64;

    // Create the air instance. Only non-virtual airs consume an
    // AIR_ID value — mirrors JS `AirGroup` where virtual helpers
    // live in a separate `virtualAirs[]` namespace and do not
    // advance the user-visible airs[] index. Global hints like
    // `virtual_table_data_global.air_ids` serialize those
    // non-virtual indices verbatim, so leaking a virtual air into
    // the sequence off-by-ones every downstream consumer.
    let air_id = if is_virtual {
        // Virtual airs reuse the last non-virtual air_id as a
        // placeholder; proto emission skips them anyway.
        self.last_air_id.max(0) as u32
    } else {
        self.last_air_id += 1;
        self.last_air_id as u32
    };
    {
        let ag = self.air_groups.get_or_create(&ag_name);
        ag.create_air(air_id, &tpl.name, name, rows, is_virtual);
    }

    let mut air = air::Air::new(air_id, 0, &tpl.name, name, rows, is_virtual);
    // Round 3 (2026-04-19 loop): persist the origin-frame-id on
    // this AIR so `proto_out` can detect foreign-origin
    // `Intermediate` refs whose local id collides with one of
    // this AIR's own slots. Save the enclosing origin for
    // restore at AIR exit so nested / virtual AIR calls cannot
    // corrupt outer-frame state (Codex Round 3 analyze called
    // this out).
    let prior_origin_frame_id = self.current_origin_frame_id;
    self.next_origin_frame_id = self.next_origin_frame_id.saturating_add(1);
    self.current_origin_frame_id = self.next_origin_frame_id;
    air.origin_frame_id = self.current_origin_frame_id;
    self.air_stack.push(air);

    // Push the expr store so air-level expressions don't mix with
    // proof-level ones. Matches JS pushAirScope()/popAirScope().
    self.exprs.push();

    // Reset the per-AIR Intermediate-ref tracker. Round 3 lift / read
    // consistency layer: AIR finalization must keep every recorded
    // slot id in `air_expression_store` even if the slot has been
    // overwritten with a non-symbolic value by then. See
    // BL-20260418-intermediate-ref-lift-consistency.
    self.intermediate_refs_emitted.clear();
    // Round 4 cross-AIR substitution map: fresh per AIR so refs minted
    // in a prior AIR's frame cannot resolve here. See
    // BL-20260418-intermediate-ref-cross-air-leak.
    self.intermediate_ref_resolution.clear();
    // The origin-frame-id counter was bumped right before
    // `self.air_stack.push(air)` above so the Air struct could
    // persist the value for later proto serialization. No second
    // bump here.

    // Snapshot the `use_aliases` stack at AIR entry so any `use`
    // added inside this AIR template body — directly, through
    // nested helpers, or via `init_air_containers_sum` /
    // `init_*` initializers — is bounded to the AIR's lifetime
    // and does not leak into sibling AIRs. Pairs with the
    // restore at AIR exit below. Matches JS pil2-compiler
    // behavior where each AIR template call starts with a clean
    // alias stack inherited from its enclosing scope only.
    let air_template_use_aliases_mark = self.references.snapshot_use_aliases();

    self.namespace_ctx.push(name);
    self.scope.push_instance_type("air");

    // Update built-in constants.
    self.set_builtin_int("BITS", self.air_stack.last().map(|a| a.bits as i128).unwrap_or(0));
    self.set_builtin_int("AIR_ID", air_id as i128);
    self.set_builtin_string("AIR_NAME", name);
    self.set_builtin_int("VIRTUAL", if is_virtual { 1 } else { 0 });
    self.set_builtin_string("AIRTEMPLATE", &tpl.name);

    // Execute template body.
    let body = tpl.body.clone();
    let extra_blocks = tpl.extra_blocks.clone();
    self.execute_statements(&body);
    for block in &extra_blocks {
        self.execute_statements(block);
    }

    // Execute deferred air-scoped calls (like piop_gprod_air,
    // piop_gsum_air) before capturing constraints/columns.
    // Mirrors JS `finalAirScope()`.
    self.call_deferred_functions("air", "final");

    let witness_count = self.witness_cols.len();
    let fixed_count = self.fixed_cols.ids.current_len();
    let constraint_count = self.constraints.len() as u32;

    eprintln!("  > Witness cols: {}", witness_count);
    eprintln!("  > Fixed cols: {}", fixed_count);
    eprintln!("  > Constraints: {}", constraint_count);

    // Build fixed column ID mappings for this AIR.
    // The map is dense: indexed relative to fc_start so that entry i
    // corresponds to absolute column ID (fc_start + i).  Temporal
    // columns get a placeholder entry to keep relative indexing
    // aligned; they are skipped during protobuf serialization.
    let fc_start = self.fixed_cols.current_start();
    let mut fixed_id_map: Vec<(char, u32)> = Vec::new();
    {
        let num_rows = self.air_stack.last().map(|a| a.rows).unwrap_or(0);
        let mut fixed_proto_idx = 0u32;
        let periodic_proto_idx = 0u32;
        let fc_end = fc_start + self.fixed_cols.ids.current_len();
        for col_id in fc_start..fc_end {
            if let Some(data) = self.fixed_cols.ids.get_data(col_id) {
                if data.temporal {
                    // Placeholder for temporal columns to keep
                    // relative indexing aligned.
                    fixed_id_map.push(('T', 0));
                    continue;
                }
            }
            // All non-temporal fixed columns are emitted as `F` (regular
            // fixed). The auto-detect-periodic-by-row-data-length heuristic
            // previously here misclassified cols whose row data was less
            // than num_rows but were declared as plain `col fixed` (not
            // explicitly periodic). The trio AIRs (SpecifiedRanges /
            // VirtualTable0 / VirtualTable1) populate `col fixed name[N]`
            // sub-columns via Tables.fill / Tables.copy: when the last
            // group's coverage is shorter than num_rows, the auto-detect
            // moved 2-8 trio sub-cols from F to P, breaking the post-Round-15
            // golden parity (59/52/73 fixed cols vs golden) and changing
            // downstream evMap / queryVerifier code shape. PIL does not
            // currently have explicit periodic declaration syntax — virtual
            // cols are marked temporal at declaration time and dropped
            // before reaching here. Without a producer-side signal that
            // the col is genuinely periodic, default to `F` and let
            // write_fixed_cols_to_file zero-pad missing rows.
            // See BL-20260420-fixed-col-auto-periodic-misclassify.
            let _ = num_rows;
            let _ = periodic_proto_idx;
            fixed_id_map.push(('F', fixed_proto_idx));
            fixed_proto_idx += 1;
        }
    }

    // Build witness column ID mappings (stage -> proto_index).
    let witness_id_map: Vec<(u32, u32)> = {
        let mut map = Vec::new();
        // Group by stage, assign per-stage indices.
        let mut stages: HashMap<u32, Vec<u32>> = HashMap::new();
        for wid in 0..self.witness_cols.len() {
            let stage = self.witness_cols.datas.get(wid as usize)
                .and_then(|d| d.stage)
                .unwrap_or(1);
            stages.entry(stage).or_default().push(wid);
        }
        let mut sorted_stages: Vec<u32> = stages.keys().cloned().collect();
        sorted_stages.sort();
        for stage in sorted_stages {
            if let Some(ids) = stages.get(&stage) {
                for (idx, &wid) in ids.iter().enumerate() {
                    while map.len() <= wid as usize {
                        map.push((1, 0));
                    }
                    map[wid as usize] = (stage, idx as u32);
                }
            }
        }
        map
    };

    // Compute stage_widths: count witness columns per stage.
    let stage_widths: Vec<u32> = {
        let mut by_stage: HashMap<u32, u32> = HashMap::new();
        for wid in 0..self.witness_cols.len() {
            let stage = self.witness_cols.datas.get(wid as usize)
                .and_then(|d| d.stage)
                .unwrap_or(1);
            *by_stage.entry(stage).or_insert(0) += 1;
        }
        if by_stage.is_empty() {
            Vec::new()
        } else {
            let max_stage = *by_stage.keys().max().unwrap();
            let mut widths = vec![0u32; max_stage as usize];
            for (stage, count) in by_stage {
                if stage > 0 && (stage as usize) <= widths.len() {
                    widths[(stage - 1) as usize] = count;
                }
            }
            widths
        }
    };

    // Build the full AIR expression store from hint-referenced
    // expressions, intermediate column expressions (expr-typed
    // variables), and constraint expressions. This mirrors the JS
    // `this.expressions` store that holds ALL expressions created
    // during AIR execution.
    //
    // Layout: [hint exprs | intermediate exprs | constraint exprs]
    // Hint ExprId values reference indices in
    // self.air_expression_store, which are placed first so that
    // hint indices remain valid without remapping.
    // Move constraint data out (zero-cost take, no clone).
    let (constraint_entries, constraint_exprs) =
        self.constraints.take_entries_and_expressions();
    let n_constraint_exprs = constraint_exprs.len();

    // Lift self.exprs slots that survived is_symbolic into the
    // per-AIR expression store, carrying provenance on each entry.
    // For array-dim'd ranges the source_label includes the offset
    // (`name[index]`) so downstream IM-symbol emission needs no
    // range lookup. Anonymous subexpressions (constraint sub-trees
    // produced directly from witness-calc / value_to_hint_value /
    // constraint expansion) stay None and are pruned naturally by
    // the consumer.
    let air_expr_store: Vec<air::AirExpressionEntry> = {
        let mut store = std::mem::take(&mut self.air_expression_store);
        // Round 4 of plan-rustify-pkgen-e2e-0420 Phase 3: replace
        // the unconditional `for eid in 0..self.exprs.len()`
        // sweep with a reachability-driven importer. JS
        // `PackedExpressions` packs expression references
        // lazily, only when
        // `expression_packer.js::referencePack` encounters an
        // `ExpressionReference` during tree walking. The Rust
        // port's old sweep lifted every symbolic `self.exprs`
        // slot regardless of reference, which inflated the
        // per-AIR arena 1.4x-7.8x above JS golden and is the
        // root cause the plan is trying to eliminate.
        //
        // New flow:
        //   1. Seed a reachable-set with refs collected from
        //      constraint expressions plus any hint-originated
        //      `air_expression_store` entries accumulated during
        //      AIR execution.
        //   2. Walk the reachable ids to fixpoint: for each
        //      reachable id, look up its stored tree in
        //      `self.exprs` (current-origin) or
        //      `global_intermediate_resolution` (foreign-origin)
        //      and collect further refs.
        //   3. Import only the reachable current-origin ids
        //      (deduped by id, preserving first-seen walker
        //      discovery order - the JS-equivalent arena
        //      insertion order).
        //   4. Retain the `proof_scope_slot_has_foreign_leaf`
        //      filter for cross-AIR custom-col leak safety.
        //   5. Keep the trimmed-slot fallback but gated on
        //      reachability.
        //
        // The Phase 2 `RuntimeExpr::ExprRef` node carries the
        // reference identity this importer walks. The importer
        // is the Phase 3 payload.
        let frame_start = self.exprs.frame_start();
        let current_origin = self.current_origin_frame_id;
        let trace_lift_breakdown = std::env::var("PIL2C_LIFT_BREAKDOWN")
            .map(|v| v == "1")
            .unwrap_or(false);
        let mut lift_proof_scope = 0usize;
        let mut lift_proof_scope_dropped_foreign = 0usize;
        let mut lift_in_frame_symbolic_labeled = 0usize;
        let mut lift_in_frame_symbolic_unlabeled = 0usize;
        let mut lift_in_frame_force_include = 0usize;
        // Round 9 per Codex Round 8 review: explicit counter
        // incremented inside the trimmed-slot fallback push
        // branch. Replaces the previous
        // `store.len() - sum_of_*` derivation, which underflowed
        // when alias dedup skipped pushes.
        let mut lift_trimmed_fallback_count = 0usize;
        let mut proof_scope_unique_trees: std::collections::HashSet<
            super::expression::RuntimeExpr,
        > = std::collections::HashSet::new();
        let mut leak_visited: std::collections::HashSet<
            *const super::expression::RuntimeExpr,
        > = std::collections::HashSet::new();

        // Build the reachable-id set via root-driven walk. The
        // helper `collect_refs_from_expr` adds every `ExprRef`
        // plus every `ColRef { col_type: Intermediate }` leaf
        // to the `reachable_order` Vec preserving first-seen
        // discovery order; `reachable_seen` dedups.
        let mut reachable_order: Vec<(Option<u32>, u32)> = Vec::new();
        let mut reachable_seen: std::collections::HashSet<(Option<u32>, u32)> =
            std::collections::HashSet::new();
        collect_refs_from_constraint_exprs(
            &constraint_exprs,
            &mut reachable_order,
            &mut reachable_seen,
        );
        for entry in &store {
            collect_refs_from_expr(
                &entry.expr,
                &mut reachable_order,
                &mut reachable_seen,
            );
        }
        // Fixpoint: expand reachable set through the stored
        // tree at each reachable id.
        let mut cursor = 0usize;
        while cursor < reachable_order.len() {
            let (origin_opt, id) = reachable_order[cursor];
            cursor += 1;
            // Same-origin id resolves through self.exprs; a
            // None-origin proof-scope id also resolves through
            // self.exprs (the slot persists across the air
            // push). Foreign-origin ids resolve through
            // `global_intermediate_resolution` so downstream
            // serialization can inline the tree; for
            // reachability purposes the foreign-origin branch
            // does NOT import into this AIR's store (the
            // serializer handles it via the resolution map).
            let is_current_origin = origin_opt.is_none()
                || origin_opt == Some(current_origin);
            let mut tree_opt: Option<std::rc::Rc<super::expression::RuntimeExpr>> =
                if is_current_origin {
                    self.exprs.get(id).and_then(|v| match v {
                        Value::RuntimeExpr(rt) => Some(rt.clone()),
                        _ => None,
                    })
                } else {
                    let key = (origin_opt.unwrap(), id);
                    self.global_intermediate_resolution.get(&key).cloned()
                };
            // Round 5 of plan-rustify-pkgen-e2e-0420: when the
            // stored value is a non-RuntimeExpr `Value::ColRef`
            // (proof-scope `const expr alias = <col>` pattern
            // after the ColRef identity fix in mod_vardecl.rs),
            // the walker must also consult the resolution maps
            // so transitive refs through the ColRef alias are
            // discovered. The resolution map was populated at
            // ref-mint time with `Rc<RuntimeExpr::ColRef>` for
            // exactly these cases.
            if tree_opt.is_none() && is_current_origin {
                let key = (current_origin, id);
                tree_opt = self
                    .intermediate_ref_resolution
                    .get(&key)
                    .cloned()
                    .or_else(|| {
                        self.global_intermediate_resolution.get(&key).cloned()
                    });
            }
            if let Some(tree) = tree_opt {
                collect_refs_from_expr(
                    tree.as_ref(),
                    &mut reachable_order,
                    &mut reachable_seen,
                );
            }
        }
        // Telemetry: count reachable current-origin ids that
        // would otherwise have been lifted (in-frame or
        // proof-scope), plus the complement set of symbolic
        // self.exprs slots that were NOT reached.
        let reachable_current_ids: std::collections::BTreeSet<u32> = reachable_order
            .iter()
            .filter_map(|(origin, id)| {
                if origin.is_none() || *origin == Some(current_origin) {
                    Some(*id)
                } else {
                    None
                }
            })
            .collect();
        let mut lift_proof_scope_reachable = 0usize;
        let mut lift_proof_scope_unused_dropped = 0usize;
        if trace_lift_breakdown {
            for eid in 0..self.exprs.len() {
                if eid >= frame_start {
                    break;
                }
                let Some(val) = self.exprs.get(eid) else {
                    continue;
                };
                if !is_symbolic(val) {
                    continue;
                }
                if reachable_current_ids.contains(&eid) {
                    lift_proof_scope_reachable += 1;
                } else {
                    lift_proof_scope_unused_dropped += 1;
                }
            }
        }
        // Round 6 of plan-rustify-pkgen-e2e-0420: import
        // reachable ids in SORTED NUMERIC id order so the per-AIR
        // arena insertion order mirrors JS
        // `Expressions.pack(container, ...)` iterating
        // `this.expressions` sequentially
        // (temp/golden_references/pil2-compiler/src/expressions.js::pack).
        //
        // Round 7 attempted to add "labeled-always import" for
        // all in-frame labeled expr ids, but that included too
        // many intermediate `expr X = ...` labels that JS does
        // not pack (JS differentiates `ExpressionReference`
        // const-declarations from runtime `expr` variables and
        // only reserves the former in `this.expressions`).
        //
        // Round 8 adds the dedicated `IdData.is_const_expr` flag
        // set at `exec_variable_declaration` reserve-time when
        // `vd.is_const && vd.vtype == TypeKind::Expr`. Round 9
        // narrows the inclusion rule per Codex Round 8 review:
        // JS `ExpressionPacker::referencePack` only calls
        // `saveAndPushExpressionReference` when pack-walking
        // reaches an `ExpressionReference` operand whose value
        // `isExpression` during the current AIR's root walk.
        // That is a reachability rule, not an unconditional
        // include. So the in-frame const-expr set participates
        // in force_include ONLY when the reachability walker
        // visited it: `reachable_const_current_ids =
        // reachable_current_ids INTERSECT
        // in_frame_const_expr_ids`. The final import set is
        // the same numeric sort of reachable current-origin
        // ids (the intersection is automatically included).
        let in_frame_const_expr_ids: std::collections::BTreeSet<u32> = (frame_start
            ..self.exprs.len())
            .filter(|&eid| {
                self.exprs
                    .ids
                    .get_data(eid)
                    .map(|d| d.is_const_expr)
                    .unwrap_or(false)
            })
            .collect();
        let reachable_const_current_ids: std::collections::BTreeSet<u32> =
            in_frame_const_expr_ids
                .iter()
                .copied()
                .filter(|eid| reachable_current_ids.contains(eid))
                .collect();
        let reachable_current_ids_sorted: Vec<u32> =
            reachable_current_ids.iter().copied().collect();
        let mut imported_ids: std::collections::HashSet<u32> =
            std::collections::HashSet::new();
        // Round 7/8 per Codex Round 6/7 reviews: canonical-owner
        // map for alias-equivalent reachable roots. Round 8
        // normalizes identity to cover BOTH live alias forms:
        //   (a) `Value::RuntimeExpr(rc)` - key by Rc pointer
        //       identity via `canonical_by_rc_ptr`.
        //   (b) `Value::ColRef { col_type: Intermediate, id:
        //       target_eid, row_offset: 0, origin_frame_id:
        //       Some(origin) }` at same-origin - resolve via
        //       `canonical_by_eid[target_eid]` (populated below
        //       for EVERY pushed entry). Intermediate alias
        //       chains (alias2 = alias_e = e) resolve
        //       transitively because alias_e's canonical_by_eid
        //       entry already points at e's position.
        // Other value shapes fall through with no dedup.
        // Matches JS `pushExpressionReference(id, rowOffset)`
        // first-seen reference-identity semantics.
        let mut canonical_by_rc_ptr: std::collections::HashMap<
            *const super::expression::RuntimeExpr,
            usize,
        > = std::collections::HashMap::new();
        let mut canonical_by_eid: std::collections::HashMap<u32, usize> =
            std::collections::HashMap::new();
        for eid in &reachable_current_ids_sorted {
            let eid = *eid;
            if !imported_ids.insert(eid) {
                continue;
            }
            let Some(val) = self.exprs.get(eid) else {
                continue;
            };
            // Round 11 per Codex Round 10 review: explicit skip for
            // reachable current-frame const-expr slots whose stored
            // value is a bare column reference (i.e.
            // `Value::ColRef{col_type != Intermediate, ..}`). These
            // are `const expr X = <bare col ref>` aliases that JS
            // `expression_packer.js::referencePack`'s
            // `defvalue.isReference` branch handles via bare
            // `pushExpressionReference(id, offset)` — a miss-no-op
            // when no saved reference exists, so no arena entry gets
            // created on first reference. Rust's `is_symbolic`
            // matches every `Value::ColRef` as symbolic and the
            // importer would otherwise lift the alias slot into the
            // per-AIR arena; skip it here so the serializer's
            // unresolved-Intermediate path rehydrates the alias via
            // `global_intermediate_resolution` at every read site.
            let is_bare_ref_const_alias = eid >= frame_start
                && self
                    .exprs
                    .ids
                    .get_data(eid)
                    .map(|d| d.is_const_expr)
                    .unwrap_or(false)
                && matches!(
                    val,
                    Value::ColRef { col_type, .. } if !matches!(col_type, super::expression::ColRefKind::Intermediate)
                );
            if is_bare_ref_const_alias {
                continue;
            }
            let force_include = eid >= frame_start
                && (self.intermediate_refs_emitted.contains(&eid)
                    || reachable_const_current_ids.contains(&eid));
            if !force_include && !is_symbolic(val) {
                continue;
            }
            if eid < frame_start {
                // Seeded proof-scope slot. Drop it if the
                // expression tree carries column leaves from a
                // different AIR's allocator.
                let rt_probe = value_to_runtime_expr(val);
                if self.proof_scope_slot_has_foreign_leaf(
                    &rt_probe,
                    &mut leak_visited,
                ) {
                    lift_proof_scope_dropped_foreign += 1;
                    continue;
                }
            }
            let rt = value_to_runtime_expr(val);
            let source_label = self.exprs.ids.label_ranges
                .to_vec()
                .iter()
                .find_map(|lr| {
                    if eid >= lr.from && eid < lr.from + lr.count {
                        let size = lr.array_dims.iter().copied().product::<u32>().max(1);
                        if size <= 1 {
                            Some(lr.label.clone())
                        } else {
                            Some(format!("{}[{}]", lr.label, eid - lr.from))
                        }
                    } else {
                        None
                    }
                });
            // Round 8 + Round 9: resolve canonical position through
            // two paths. (a) Rc pointer identity for
            // `Value::RuntimeExpr(rc)` — two reachable eids whose
            // stored value is the SAME `Rc<RuntimeExpr>` (e.g.
            // created via `Rc::clone`). (b) Intermediate-alias
            // target eid resolution for
            // `Value::ColRef{Intermediate, id: target_eid, ...}`
            // at same-origin zero row offset — the live alias
            // form produced by `mod_vardecl::get_var_ref_value`
            // when reading an in-frame symbolic `expr` slot.
            // Round 9: counters are incremented AFTER the dedup
            // check so `store.len() - sum_of_counters` stays
            // non-negative (the Round 8 arrangement underflowed
            // on aliased fixtures, panicking pil2c). Aliases do
            // not count toward any `lift_*` category since they
            // do not allocate a new arena entry.
            let rc_ptr: Option<*const super::expression::RuntimeExpr> = match val {
                Value::RuntimeExpr(rc) => {
                    Some(std::rc::Rc::as_ptr(rc) as *const _)
                }
                _ => None,
            };
            let target_alias_eid: Option<u32> = match val {
                Value::ColRef {
                    col_type: super::expression::ColRefKind::Intermediate,
                    id: target_eid,
                    row_offset,
                    origin_frame_id: Some(origin),
                } if row_offset.unwrap_or(0) == 0 && *origin == current_origin => {
                    Some(*target_eid)
                }
                _ => None,
            };
            let canonical_pos: Option<usize> = rc_ptr
                .and_then(|ptr| canonical_by_rc_ptr.get(&ptr).copied())
                .or_else(|| {
                    target_alias_eid.and_then(|t| canonical_by_eid.get(&t).copied())
                });
            if let Some(pos) = canonical_pos {
                store[pos].aliases.push(eid);
                canonical_by_eid.insert(eid, pos);
                continue;
            }
            let rt = value_to_runtime_expr(val);
            if eid < frame_start {
                lift_proof_scope += 1;
                if trace_lift_breakdown {
                    proof_scope_unique_trees.insert(rt.clone());
                }
            } else if force_include && !is_symbolic(val) {
                lift_in_frame_force_include += 1;
            } else if source_label.is_some() {
                lift_in_frame_symbolic_labeled += 1;
            } else {
                lift_in_frame_symbolic_unlabeled += 1;
            }
            let pushed_pos = store.len();
            store.push(air::AirExpressionEntry::with_source(rt, eid, source_label));
            if let Some(ptr) = rc_ptr {
                canonical_by_rc_ptr.insert(ptr, pushed_pos);
            }
            canonical_by_eid.insert(eid, pushed_pos);
        }
        // Round 4 trimmed-slot fallback: any slot id the producer
        // minted an `Intermediate` ref for, but whose value has since
        // been blanked by `trim_values_after` on a function-call
        // return, is not visible to the `self.exprs.get(eid)` loop
        // above. Pull those entries in from `intermediate_ref_resolution`
        // so the proto serializer's `source_to_pos` can still resolve
        // the ref. Without this, in-AIR constraint trees (anonymous
        // entries) that reference a trimmed slot fall through to the
        // legacy raw-id path and pil2-stark-setup panics at
        // `helpers.rs:21:19`. See
        // BL-20260418-intermediate-ref-cross-air-leak.
        {
            use std::rc::Rc;
            // Round 4 Phase 3: trimmed-slot fallback is now
            // gated on reachability. Only reachable ids whose
            // self.exprs slot was blanked by
            // `trim_values_after` get pulled from
            // `intermediate_ref_resolution`. This keeps the
            // old correctness backstop for trimmed-by-function-
            // exit slots while preventing the fallback from
            // silently reintroducing non-reachable slots the
            // new importer intends to drop.
            //
            // Round 9: trimmed-slot fallback uses the same
            // `reachable_const_current_ids` set so const-expr
            // slots recovered from `intermediate_ref_resolution`
            // still respect the JS pack-walk reachability rule.
            let mut pending_set: std::collections::BTreeSet<u32> = reachable_current_ids
                .iter()
                .copied()
                .filter(|eid| *eid >= frame_start)
                .filter(|eid| self.exprs.get(*eid).is_none())
                .filter(|eid| !imported_ids.contains(eid))
                .collect();
            for &eid in &reachable_const_current_ids {
                if self.exprs.get(eid).is_none() && !imported_ids.contains(&eid) {
                    pending_set.insert(eid);
                }
            }
            for eid in pending_set {
                // Round 11: also skip bare-ref const-expr aliases
                // in the trimmed-slot fallback. Their registered
                // `intermediate_ref_resolution` entry is a bare
                // `RuntimeExpr::ColRef{Witness / Fixed / ..}` leaf
                // that the serializer should rehydrate inline via
                // the unresolved-Intermediate path, NOT as a
                // top-level `air_expression_store` entry.
                let is_bare_ref_const_alias = self
                    .exprs
                    .ids
                    .get_data(eid)
                    .map(|d| d.is_const_expr)
                    .unwrap_or(false)
                    && matches!(
                        self
                            .intermediate_ref_resolution
                            .get(&(self.current_origin_frame_id, eid))
                            .map(|rt| rt.as_ref()),
                        Some(super::expression::RuntimeExpr::ColRef {
                            col_type,
                            ..
                        }) if !matches!(
                            col_type,
                            super::expression::ColRefKind::Intermediate
                        )
                    );
                if is_bare_ref_const_alias {
                    continue;
                }
                let rt: Rc<super::expression::RuntimeExpr> =
                    match self
                        .intermediate_ref_resolution
                        .get(&(self.current_origin_frame_id, eid))
                    {
                        Some(rt) => rt.clone(),
                        None => continue,
                    };
                // Round 9 per Codex Round 8 review: canonical-owner
                // dedup on the trimmed-slot fallback path.
                // (a) Rc pointer identity of the recovered
                // `Rc<RuntimeExpr>` from `intermediate_ref_resolution`.
                // (b) Same-origin Intermediate / ExprRef refs inside
                // the recovered tree that target an already-imported
                // eid via `canonical_by_eid`.
                let rc_ptr: *const super::expression::RuntimeExpr =
                    Rc::as_ptr(&rt);
                let target_alias_eid: Option<u32> = match rt.as_ref() {
                    super::expression::RuntimeExpr::ColRef {
                        col_type: super::expression::ColRefKind::Intermediate,
                        id: target_eid,
                        row_offset,
                        origin_frame_id: Some(origin),
                    } if row_offset.unwrap_or(0) == 0
                        && *origin == current_origin =>
                    {
                        Some(*target_eid)
                    }
                    super::expression::RuntimeExpr::ExprRef {
                        id: target_eid,
                        row_offset,
                        origin_frame_id,
                    } if row_offset.unwrap_or(0) == 0
                        && origin_frame_id
                            .map(|o| o == current_origin)
                            .unwrap_or(true) =>
                    {
                        Some(*target_eid)
                    }
                    _ => None,
                };
                let canonical_pos: Option<usize> = canonical_by_rc_ptr
                    .get(&rc_ptr)
                    .copied()
                    .or_else(|| {
                        target_alias_eid
                            .and_then(|t| canonical_by_eid.get(&t).copied())
                    });
                if let Some(pos) = canonical_pos {
                    store[pos].aliases.push(eid);
                    canonical_by_eid.insert(eid, pos);
                    imported_ids.insert(eid);
                    continue;
                }
                let source_label = self.exprs.ids.label_ranges
                    .to_vec()
                    .iter()
                    .find_map(|lr| {
                        if eid >= lr.from && eid < lr.from + lr.count {
                            let size = lr.array_dims.iter().copied().product::<u32>().max(1);
                            if size <= 1 {
                                Some(lr.label.clone())
                            } else {
                                Some(format!("{}[{}]", lr.label, eid - lr.from))
                            }
                        } else {
                            None
                        }
                    });
                imported_ids.insert(eid);
                let pushed_pos = store.len();
                store.push(air::AirExpressionEntry::with_source(
                    (*rt).clone(),
                    eid,
                    source_label,
                ));
                canonical_by_rc_ptr.insert(rc_ptr, pushed_pos);
                canonical_by_eid.insert(eid, pushed_pos);
                lift_trimmed_fallback_count += 1;
            }
        }
        let lift_constraint_count = constraint_exprs.len();
        for expr in constraint_exprs {
            store.push(air::AirExpressionEntry::anonymous(expr));
        }
        if trace_lift_breakdown {
            let air_name_trace = self
                .air_stack
                .last()
                .map(|a| a.name.clone())
                .unwrap_or_else(|| "?".to_string());
            eprintln!(
                "PIL2C_LIFT_BREAKDOWN air={}/{} frame_start={} total={} \
                 proof_scope={} proof_scope_unique_trees={} \
                 proof_scope_dropped_foreign={} \
                 proof_scope_reachable={} proof_scope_unused_dropped={} \
                 in_frame_force_include={} \
                 in_frame_symbolic_labeled={} \
                 in_frame_symbolic_unlabeled={} \
                 trimmed_fallback={} \
                 constraint_exprs={}",
                ag_name,
                air_name_trace,
                frame_start,
                store.len(),
                lift_proof_scope,
                proof_scope_unique_trees.len(),
                lift_proof_scope_dropped_foreign,
                lift_proof_scope_reachable,
                lift_proof_scope_unused_dropped,
                lift_in_frame_force_include,
                lift_in_frame_symbolic_labeled,
                lift_in_frame_symbolic_unlabeled,
                lift_trimmed_fallback_count,
                lift_constraint_count,
            );
        }
        store
    };

    // Collect every `ColRefKind::Custom` id actually referenced by this
    // AIR's expressions, constraints, and hint payloads. Used below to
    // validate the per-AIR `custom_id_map` covers every emitted
    // custom reference. Failing this invariant is what produced the
    // Round 10 `pilout_info.rs:208` panic at Mem; catching it at pilout
    // build time here surfaces the gap with an actionable diagnostic
    // instead of a downstream `index out of bounds`.
    let mut referenced_custom_ids: std::collections::BTreeSet<u32> =
        std::collections::BTreeSet::new();
    let mut visited_expr_ptrs: std::collections::HashSet<
        *const super::expression::RuntimeExpr,
    > = std::collections::HashSet::new();
    for entry in &air_expr_store {
        collect_custom_ids_in_expr(
            &entry.expr,
            &mut referenced_custom_ids,
            &mut visited_expr_ptrs,
        );
    }
    for hint in &self.air_hints {
        collect_custom_ids_in_hint(
            &hint.data,
            &mut referenced_custom_ids,
            &mut visited_expr_ptrs,
        );
    }

    // Build custom column ID mappings and custom_commits from the
    // local allocator state. Round 13 / 14 closed the upstream
    // air_expr_store leak that made cross-AIR `ColRefKind::Custom`
    // ids appear in consuming AIRs' serialized expressions: the
    // lift above now iterates every `self.exprs` slot but applies
    // a per-value filter that drops only seeded proof-scope slots
    // whose tree carries a cross-AIR custom leaf. Most referenced
    // ids should therefore be covered by `self.custom_cols`; any
    // that still reach pilout serialization through hint /
    // constraint paths degrade to `Operand::Constant(0)` at the
    // proto layer (see `pil2-compiler-rust/src/proto_out.rs`
    // ColRefKind::Custom arm). The panic below is reserved for
    // the correctness floor: an id absent from BOTH the in-AIR
    // allocator AND the cross-AIR `custom_col_meta` registry is
    // a truly-undeclared column (never reserved anywhere) and
    // must surface immediately.
    let (custom_id_map, custom_commits) = {
        let mut cid_map: Vec<(u32, u32, u32)> = Vec::new();
        let mut commits: Vec<(String, Vec<u32>, Vec<u32>)> = Vec::new();

        // Group local custom columns by commit_id.
        let mut commits_by_id: HashMap<u32, Vec<(u32, u32)>> = HashMap::new();
        let mut commit_names: HashMap<u32, String> = HashMap::new();
        let mut registered_ids: std::collections::BTreeSet<u32> =
            std::collections::BTreeSet::new();
        for col_id in 0..self.custom_cols.len() {
            if let Some(data) = self.custom_cols.get_data(col_id) {
                let cid = data.commit_id.unwrap_or(0);
                let stage = data.stage.unwrap_or(0);
                commits_by_id.entry(cid).or_default().push((col_id, stage));
                registered_ids.insert(col_id);
            }
        }
        // Map commit_id -> name from the reverse of commit_name_to_id.
        for (name, &cid) in &self.commit_name_to_id {
            commit_names.insert(cid, name.clone());
        }

        let air_name_dbg = self
            .air_stack
            .last()
            .map(|a| a.name.clone())
            .unwrap_or_else(|| "?".to_string());
        // Cross-AIR leak diagnostic. Set PIL2C_TRACE_CUSTOMCOL_LEAK=1
        // to see every AIR that emits a custom-col reference whose
        // declaring AIR is different from the current AIR. This is
        // the Round 13 tracing hook for the leak that the Round 11
        // / 12 `Operand::Constant(0)` fallback papers over.
        if std::env::var("PIL2C_TRACE_CUSTOMCOL_LEAK").is_ok() {
            let cross_air: Vec<u32> = referenced_custom_ids
                .iter()
                .copied()
                .filter(|id| {
                    !registered_ids.contains(id)
                        && self.custom_col_meta.contains_key(id)
                })
                .collect();
            if !cross_air.is_empty() {
                eprintln!(
                    "[pil2c-trace] [customcol-leak] air='{}' cross_air_ids={:?} \
                     (declaring commits: {:?})",
                    air_name_dbg,
                    cross_air,
                    cross_air
                        .iter()
                        .filter_map(|id| self.custom_col_meta.get(id).map(|(n, _, _)| n.clone()))
                        .collect::<std::collections::BTreeSet<_>>(),
                );
                for (idx, entry) in air_expr_store.iter().enumerate() {
                    let mut local_ids: std::collections::BTreeSet<u32> =
                        std::collections::BTreeSet::new();
                    let mut local_visited: std::collections::HashSet<
                        *const super::expression::RuntimeExpr,
                    > = std::collections::HashSet::new();
                    collect_custom_ids_in_expr(
                        &entry.expr,
                        &mut local_ids,
                        &mut local_visited,
                    );
                    let bad: Vec<u32> = local_ids
                        .into_iter()
                        .filter(|id| cross_air.contains(id))
                        .collect();
                    if !bad.is_empty() {
                        eprintln!(
                            "[pil2c-trace] [customcol-leak]   expr#{} \
                             (source={:?}, source_expr_id={:?}): ids={:?}",
                            idx,
                            entry.source_label,
                            entry.source_expr_id,
                            bad,
                        );
                    }
                }
            }
        }
        let unmapped: Vec<u32> = referenced_custom_ids
            .iter()
            .copied()
            .filter(|id| {
                !registered_ids.contains(id) && !self.custom_col_meta.contains_key(id)
            })
            .collect();
        if !unmapped.is_empty() {
            let mut offenders: Vec<String> = Vec::new();
            for (idx, entry) in air_expr_store.iter().enumerate() {
                let mut local_ids: std::collections::BTreeSet<u32> =
                    std::collections::BTreeSet::new();
                let mut local_visited: std::collections::HashSet<
                    *const super::expression::RuntimeExpr,
                > = std::collections::HashSet::new();
                collect_custom_ids_in_expr(
                    &entry.expr,
                    &mut local_ids,
                    &mut local_visited,
                );
                let bad: Vec<u32> = local_ids
                    .into_iter()
                    .filter(|id| unmapped.contains(id))
                    .collect();
                if !bad.is_empty() {
                    offenders.push(format!(
                        "expr#{} (source={:?}, source_expr_id={:?}): custom_ids={:?}",
                        idx,
                        entry.source_label,
                        entry.source_expr_id,
                        bad,
                    ));
                }
            }
            panic!(
                "AIR '{}' emits Operand::CustomCol references with ids {:?} \
                 that are absent from both this AIR's custom_cols allocator \
                 and the cross-AIR `custom_col_meta` registry. This indicates \
                 a custom column reference that was never declared (or whose \
                 declaration metadata was lost before reaching pilout build). \
                 Registered in-AIR ids: {:?}. Offending expression entries:\n  {}",
                air_name_dbg,
                unmapped,
                registered_ids.iter().copied().collect::<Vec<_>>(),
                offenders.join("\n  "),
            );
        }

        let mut sorted_cids: Vec<u32> = commits_by_id.keys().cloned().collect();
        sorted_cids.sort();

        for cid in sorted_cids {
            let cols = commits_by_id.get(&cid).unwrap();
            let commit_name = commit_names.get(&cid).cloned().unwrap_or_default();

            // Group by stage and build stage_widths (0-based stages
            // for custom commits, matching JS behavior).
            let mut stages_map: HashMap<u32, Vec<u32>> = HashMap::new();
            for &(col_id, stage) in cols {
                stages_map.entry(stage).or_default().push(col_id);
            }
            let max_stage = stages_map.keys().max().copied().unwrap_or(0);
            let mut sw = Vec::new();
            let mut sorted_stages: Vec<u32> = stages_map.keys().cloned().collect();
            sorted_stages.sort();
            for stage in 0..=max_stage {
                let count = stages_map.get(&stage).map(|v| v.len() as u32).unwrap_or(0);
                sw.push(count);
                if let Some(ids) = stages_map.get(&stage) {
                    for (idx, &col_id) in ids.iter().enumerate() {
                        while cid_map.len() <= col_id as usize {
                            cid_map.push((0, 0, 0));
                        }
                        cid_map[col_id as usize] = (stage, idx as u32, cid);
                    }
                }
            }
            // Get public IDs for this commit.
            let pub_ids = self.commit_publics
                .get(&commit_name)
                .cloned()
                .unwrap_or_default();
            commits.push((commit_name, sw, pub_ids));
        }

        (cid_map, commits)
    };

    // Snapshot this AIR's custom col metadata into the cross-AIR
    // registry BEFORE the post-AIR clear wipes `self.custom_cols` and
    // `self.commit_name_to_id`. Subsequent AIRs that reference these
    // ids will consult the registry via the cross-AIR branch above.
    {
        // Per-commit stage widths so cross-AIR readers can reconstruct
        // the full commit entry without iterating per-AIR allocator
        // state.
        let mut stage_width_by_commit: HashMap<String, Vec<u32>> =
            HashMap::new();
        for (col_id, commit_name, stage, col_idx) in custom_id_map
            .iter()
            .enumerate()
            .filter_map(|(id, triple)| {
                let (stage, col_idx, cid) = *triple;
                // Only snapshot entries that correspond to actual
                // declarations in this AIR (registered_ids).
                let registered: bool = self.custom_cols.get_data(id as u32).is_some();
                if !registered {
                    return None;
                }
                let commit_name = self
                    .commit_name_to_id
                    .iter()
                    .find(|(_, v)| **v == cid)
                    .map(|(k, _)| k.clone())?;
                Some((id as u32, commit_name, stage, col_idx))
            })
            .collect::<Vec<_>>()
        {
            self.custom_col_meta
                .insert(col_id, (commit_name.clone(), stage, col_idx));
            let widths = stage_width_by_commit
                .entry(commit_name.clone())
                .or_default();
            if (stage as usize) >= widths.len() {
                widths.resize(stage as usize + 1, 0);
            }
            widths[stage as usize] = widths[stage as usize].max(col_idx + 1);
        }
        for (commit_name, widths) in stage_width_by_commit {
            let pub_ids = self
                .commit_publics
                .get(&commit_name)
                .cloned()
                .unwrap_or_default();
            self.custom_commit_meta
                .insert(commit_name, (widths, pub_ids));
        }
    }

    // Build air value stages.
    let air_value_stages: Vec<u32> = {
        let mut stages = Vec::new();
        for avid in 0..self.air_values.len() {
            let stage = self.air_values.get_data(avid)
                .and_then(|d| d.stage)
                .unwrap_or(1);
            stages.push(stage);
        }
        stages
    };

    // Check if AIR has external fixed files (set by extern_fixed_file pragma).
    let has_extern_fixed = self.air_stack.last()
        .map(|a| a.has_extern_fixed)
        .unwrap_or(false);

    // Get output_fixed_file from the air stack (set by pragma).
    let output_fixed_file = self.air_stack.last()
        .and_then(|a| a.output_fixed_file.clone());

    // Collect per-AIR symbol entries from label ranges before scope
    // clearing destroys them. This mirrors the JS `setSymbolsFromLabels`
    // calls during `airGroupProtoOut`.
    let air_symbols: Vec<air::SymbolEntry> = {
        let mut syms = Vec::new();
        let _air_name = self.air_stack.last().map(|a| a.name.clone()).unwrap_or_default();

        // Witness symbols from label ranges.
        for lr in self.witness_cols.label_ranges.to_vec() {
            let src = self.witness_cols.get_data(lr.from)
                .map(|d| d.source_ref.clone())
                .unwrap_or_default();
            syms.push(air::SymbolEntry {
                name: lr.label.clone(),
                ref_type_str: "witness".to_string(),
                internal_id: lr.from,
                dim: lr.array_dims.len() as u32,
                lengths: lr.array_dims.clone(),
                source_ref: src,
            });
        }

        // Fixed symbols from non-temporal label ranges.
        for lr in self.fixed_cols.get_non_temporal_labels() {
            let src = self.fixed_cols.ids.get_data(lr.from)
                .map(|d| d.source_ref.clone())
                .unwrap_or_default();
            syms.push(air::SymbolEntry {
                name: lr.label.clone(),
                ref_type_str: "fixed".to_string(),
                internal_id: lr.from,
                dim: lr.array_dims.len() as u32,
                lengths: lr.array_dims.clone(),
                source_ref: src,
            });
        }

        // Custom column symbols from label ranges.
        for lr in self.custom_cols.label_ranges.to_vec() {
            let src = self.custom_cols.get_data(lr.from)
                .map(|d| d.source_ref.clone())
                .unwrap_or_default();
            syms.push(air::SymbolEntry {
                name: lr.label.clone(),
                ref_type_str: "customcol".to_string(),
                internal_id: lr.from,
                dim: lr.array_dims.len() as u32,
                lengths: lr.array_dims.clone(),
                source_ref: src,
            });
        }

        // Air value symbols from label ranges.
        for lr in self.air_values.label_ranges.to_vec() {
            let src = self.air_values.get_data(lr.from)
                .map(|d| d.source_ref.clone())
                .unwrap_or_default();
            syms.push(air::SymbolEntry {
                name: lr.label.clone(),
                ref_type_str: "airvalue".to_string(),
                internal_id: lr.from,
                dim: lr.array_dims.len() as u32,
                lengths: lr.array_dims.clone(),
                source_ref: src,
            });
        }

        // IM (intermediate) symbols are NOT emitted here.
        // Ownership moved to `proto_out::ProtoOutBuilder` in
        // Round 8: the packed-expression builder records
        // `(ag, air) -> packed_idx -> label` entries for the
        // first-save of each provenance key whose
        // `AirExpressionEntry::source_label` is Some, and emits
        // an IM SymbolEntry from that side table after the
        // per-air flatten loop. That gives the builder the
        // authoritative packed index for each surviving label,
        // with JS-equivalent first-save-wins semantics and the
        // natural packed-reference-survival filter that the
        // processor-side `source_label` walk could not
        // reproduce.
        syms
    };

    // Store per-AIR data (constraints, expressions, column maps) in the
    // airgroup's air entry before clearing.
    if !is_virtual {
        if let Some(air_on_stack) = self.air_stack.last() {
            let air_id = air_on_stack.id;
            if let Some(ag) = self.air_groups.get_mut(&ag_name) {
                if let Some(stored_air) = ag.airs.iter_mut().find(|a| a.id == air_id && !a.is_virtual) {
                    // Round 9: propagate the execution-frame
                    // origin-frame-id set at AIR push time onto the
                    // stored-air entry that proto_out.rs reads when
                    // initializing `current_origin_frame_id`. Without
                    // this, `flatten_air_expr`'s is_foreign check sees
                    // every same-origin ColRef{Intermediate,..} as
                    // foreign (current_origin defaults to 0 while
                    // ColRef.origin_frame_id is the actual frame id)
                    // and every Intermediate re-flattens inline via
                    // the global resolution map instead of landing
                    // as `Operand::Expression { idx }`. The bug
                    // predates Round 9 but was latent because most
                    // AIRs carried only forward references through
                    // the unresolved path, which coincidentally
                    // matched the same re-flatten behavior.
                    stored_air.origin_frame_id = air_on_stack.origin_frame_id;
                    // Constraint entries/expressions were already taken
                    // above; constraint exprs are appended at the end of
                    // air_expr_store. Pass just the count to avoid
                    // duplicating expression trees.
                    stored_air.store_constraints_owned(
                        constraint_entries,
                        n_constraint_exprs,
                    );
                    stored_air.store_air_expressions_owned(air_expr_store);
                    stored_air.fixed_id_map = fixed_id_map;
                    stored_air.fixed_col_start = fc_start;
                    stored_air.witness_id_map = witness_id_map;
                    stored_air.stage_widths = stage_widths;
                    stored_air.custom_id_map = custom_id_map;
                    stored_air.custom_commits = custom_commits;
                    stored_air.air_value_stages = air_value_stages;
                    stored_air.has_extern_fixed = has_extern_fixed;
                    stored_air.symbols = air_symbols;
                    stored_air.output_fixed_file = output_fixed_file.clone();
                    // Hint ExprId values reference indices in
                    // self.air_expression_store; since those expressions
                    // are placed first in air_expr_store, the indices
                    // are preserved and no remapping is needed.
                    stored_air.hints = std::mem::take(&mut self.air_hints);
                }
            }
        }
    }

    // Write fixed columns to binary file before clearing.
    // Skip if the AIR uses extern_fixed_file (data provided externally)
    // or if it's a virtual AIR (virtual AIRs don't produce fixed output).
    // Use output_fixed_file pragma filename if set, otherwise default
    // to "{air_name}.fixed".
    if self.config.fixed_to_file && !has_extern_fixed && !is_virtual {
        if let Some(ref output_dir) = self.config.output_dir.clone() {
            if let Some(air) = self.air_stack.last() {
                // Only write if there are non-temporal, non-external fixed
                // columns with actual data.
                let fc_s = self.fixed_cols.current_start();
                let fc_e = fc_s + self.fixed_cols.ids.current_len();
                let has_writable_cols = (fc_s..fc_e).any(|id| {
                    if let Some(data) = self.fixed_cols.ids.get_data(id) {
                        !data.temporal && !data.external
                    } else {
                        true
                    }
                });
                if has_writable_cols {
                    // Determine the output filename: use pragma-set name or default.
                    let default_name = format!("{}.fixed", air.name);
                    let fixed_filename = output_fixed_file.as_deref()
                        .unwrap_or(&default_name);
                    if let Err(e) = crate::proto_out::write_fixed_cols_to_file(
                        &self.fixed_cols,
                        air.rows,
                        output_dir,
                        fixed_filename,
                    ) {
                        eprintln!("  > Warning: failed to write fixed cols: {}", e);
                    }
                }
            }
        }
    }

    // Round 4 AIR-boundary sanitization: walk every proof-scope slot
    // in `self.exprs` (id < frame_start) and substitute any
    // `ColRef { col_type: Intermediate }` leaves whose id points at
    // an AIR-local slot with the underlying `RuntimeExpr` captured
    // at mint time. This catches values that reached a proof-scope
    // slot via a code path that bypassed `sanitize_expr_store_value`
    // (e.g. nested function calls that wrote into container_owned
    // slots with intermediate-ref arguments). After the sweep, the
    // subsequent `self.exprs.pop()` merge-back carries only ref-free
    // RuntimeExpr trees across the AIR boundary, so downstream AIRs
    // never read an `Intermediate` id their own `source_to_pos`
    // cannot resolve. See
    // BL-20260418-intermediate-ref-cross-air-leak.
    self.sanitize_proof_scope_exprs_at_air_exit();

    // Clean up air scope.
    self.air_hints.clear();
    self.air_expression_store.clear();
    // Per-AIR set of `Intermediate` refs the producer minted. Round 3
    // lift / read consistency layer (BL-20260418-intermediate-ref-lift-consistency).
    self.intermediate_refs_emitted.clear();
    // Round 4 cross-AIR substitution map
    // (BL-20260418-intermediate-ref-cross-air-leak).
    self.intermediate_ref_resolution.clear();
    // Round 3 (2026-04-19 loop): restore the enclosing AIR's
    // origin-frame-id now that this AIR's template body has
    // finished. Codex Round 3 analyze flagged nested / virtual
    // AIR calls as the corruption case if origin were not
    // restored. See BL-20260419-origin-frame-id-resolution.
    self.current_origin_frame_id = prior_origin_frame_id;
    self.constraints.clear();
    // Apply the scope cleanup for variables declared at the air-type scope depth
    // (body-direct declarations like `int acc_heights[opids_count]` in airtemplate
    // bodies run at this depth). Previously the return value was ignored, leaving
    // those refs in the flat refs map and causing stale bindings to persist across
    // airtemplate boundaries.
    let (air_type_unset, air_type_restore) = self.scope.pop_instance_type();
    self.apply_scope_cleanup(&air_type_unset, &air_type_restore);
    self.namespace_ctx.pop();
    self.air_stack.pop();

    // Update built-in constants back.
    let (bits_val, air_id_val, air_name_val) = if let Some(air) = self.air_stack.last() {
        (air.bits as i128, air.id as i128, air.name.clone())
    } else {
        (0, -1, String::new())
    };
    self.set_builtin_int("BITS", bits_val);
    self.set_builtin_int("AIR_ID", air_id_val);
    self.set_builtin_string("AIR_NAME", &air_name_val);
    if self.air_stack.is_empty() {
    }

    let (to_unset, to_restore) = self.scope.pop();
    self.apply_scope_cleanup(&to_unset, &to_restore);
    self.callstack.pop();
    self.function_deep -= 1;

    // Pop expr store to restore proof-level expressions.
    self.exprs.pop();

    // Clear air-scoped column stores and their references.
    // Mirrors JS clearAirScope() which calls clearType for each column type.
    self.fixed_cols.clear();
    self.witness_cols.clear();
    self.custom_cols.clear();
    self.air_values.clear();
    self.references.clear_type(&RefType::Fixed);
    self.references.clear_type(&RefType::Witness);
    self.references.clear_type(&RefType::CustomCol);
    self.references.clear_type(&RefType::AirValue);
    // Clear air-scoped containers (names starting with "air.").
    self.references.clear_air_containers();
    self.commit_name_to_id.clear();
    self.next_commit_id = 0;
    self.commit_publics.clear();

    // Restore the alias stack to its pre-AIR length. Any alias
    // that was added during this AIR's body (not already cleaned
    // by `clear_air_containers`) is now dropped so the next AIR
    // starts with the same alias inheritance as this one did.
    self.references.restore_use_aliases_len(air_template_use_aliases_mark);

    Value::Int(0)
}
}

/// Walk a `RuntimeExpr` tree and record every by-id reference as
/// `(origin_frame_id, id)` in `out`, preserving first-seen order.
/// Used by the Phase 3 reachability importer in
/// `execute_air_template_call` to seed its root set.
///
/// Both `RuntimeExpr::ColRef { col_type: Intermediate, .. }` and
/// `RuntimeExpr::ExprRef { .. }` contribute. Other `ColRef` kinds
/// (Witness / Fixed / AirValue / Custom / Public / Challenge /
/// ProofValue / AirGroupValue) do not carry by-id expression
/// references. `Value` and `ColRef { non-Intermediate }` leaves
/// short-circuit.
pub(super) fn collect_refs_from_expr(
    expr: &super::expression::RuntimeExpr,
    out: &mut Vec<(Option<u32>, u32)>,
    seen: &mut std::collections::HashSet<(Option<u32>, u32)>,
) {
    use super::expression::{ColRefKind, RuntimeExpr};
    match expr {
        RuntimeExpr::ColRef {
            col_type: ColRefKind::Intermediate,
            id,
            origin_frame_id,
            ..
        } => {
            let key = (*origin_frame_id, *id);
            if seen.insert(key) {
                out.push(key);
            }
        }
        RuntimeExpr::ExprRef { id, origin_frame_id, .. } => {
            let key = (*origin_frame_id, *id);
            if seen.insert(key) {
                out.push(key);
            }
        }
        RuntimeExpr::BinOp { left, right, .. } => {
            collect_refs_from_expr(left.as_ref(), out, seen);
            collect_refs_from_expr(right.as_ref(), out, seen);
        }
        RuntimeExpr::UnaryOp { operand, .. } => {
            collect_refs_from_expr(operand.as_ref(), out, seen);
        }
        // ColRef (non-Intermediate) and bare Value leaves carry
        // no by-id expression reference.
        RuntimeExpr::ColRef { .. } | RuntimeExpr::Value(_) => {}
    }
}

/// Walk a slice of top-level constraint expressions and seed the
/// reachability set. Mirrors the JS `expressions.js::pack`
/// entry where each AIR root expression is packed; `ExprRef`
/// discovery happens lazily during the pack walk, not via a
/// self.exprs sweep. Phase 3 of plan-rustify-pkgen-e2e-0420.
pub(super) fn collect_refs_from_constraint_exprs(
    constraint_exprs: &[super::expression::RuntimeExpr],
    out: &mut Vec<(Option<u32>, u32)>,
    seen: &mut std::collections::HashSet<(Option<u32>, u32)>,
) {
    for expr in constraint_exprs {
        collect_refs_from_expr(expr, out, seen);
    }
}
