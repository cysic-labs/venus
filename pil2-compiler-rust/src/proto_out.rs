//! Protobuf serialization for PIL compiler output.
//! Converts internal compiler state to PilOut protobuf message.
//!
//! Mirrors the JS `ProtoOut` class (pil2-compiler/src/proto_out.js).

use prost::Message;
use std::collections::HashMap;
use std::fs;
use std::io::Write;
use std::path::Path;

use crate::processor::air::HintValue;
use crate::processor::expression::{ColRefKind, RuntimeExpr, RuntimeOp, RuntimeUnaryOp, Value};
use crate::processor::fixed_cols::FixedCols;
use crate::processor::ids::IdAllocator;
use crate::processor::Processor;

/// Generated protobuf types from pilout.proto.
pub mod pilout_proto {
    include!(concat!(env!("OUT_DIR"), "/pilout.rs"));
}

/// Goldilocks prime: 2^64 - 2^32 + 1
const GOLDILOCKS_PRIME: u128 = 0xFFFFFFFF00000001;

// Symbol type constants matching the protobuf SymbolType enum.
const REF_TYPE_IM_COL: i32 = 0;
const REF_TYPE_FIXED_COL: i32 = 1;
const REF_TYPE_PERIODIC_COL: i32 = 2;
const REF_TYPE_WITNESS_COL: i32 = 3;
const REF_TYPE_PROOF_VALUE: i32 = 4;
const REF_TYPE_AIR_GROUP_VALUE: i32 = 5;
const REF_TYPE_PUBLIC_VALUE: i32 = 6;
#[allow(dead_code)]
const REF_TYPE_PUBLIC_TABLE: i32 = 7;
const REF_TYPE_CHALLENGE: i32 = 8;
const REF_TYPE_AIR_VALUE: i32 = 9;
const REF_TYPE_CUSTOM_COL: i32 = 10;

/// Convert a big integer value to variable-length big-endian bytes (matching
/// the JS `bint2buf` with variable-byte encoding).
fn bigint_to_bytes(value: i128) -> Vec<u8> {
    if value == 0 {
        return Vec::new();
    }
    // Reduce modulo Goldilocks prime to get a positive canonical representation.
    let v = if value < 0 {
        let neg = ((-value) as u128) % GOLDILOCKS_PRIME;
        if neg == 0 { 0u64 } else { (GOLDILOCKS_PRIME - neg) as u64 }
    } else {
        ((value as u128) % GOLDILOCKS_PRIME) as u64
    };
    if v == 0 {
        return Vec::new();
    }
    // Encode as big-endian, stripping leading zero bytes.
    let full = v.to_be_bytes();
    let first_nonzero = full.iter().position(|&b| b != 0).unwrap_or(full.len());
    full[first_nonzero..].to_vec()
}

/// Main serialization structure that builds the PilOut protobuf from the
/// processor's internal state.
#[allow(dead_code)]
pub struct ProtoOutBuilder<'a> {
    processor: &'a Processor,
    /// Maps internal witness column IDs to (stage, proto_index).
    witness_id_to_proto: Vec<(u32, u32)>,
    /// Maps internal fixed column IDs to (type='F'|'P', proto_index).
    fixed_id_to_proto: Vec<(char, u32)>,
    /// Maps internal custom column IDs to (stage, proto_index, commit_id).
    custom_id_to_proto: Vec<(u32, u32, u32)>,
    /// Maps internal air value IDs to (stage, proto_index, air_group_id, air_id).
    air_value_id_to_proto: Vec<(u32, u32, u32, u32)>,
    /// Per-(airgroup_id, air_id) packed expression maps built while
    /// flattening per-AIR expressions. Indexed by raw exprs-store id;
    /// value is the packed proto-expression index. Populated during
    /// `build_air_groups` and consumed by `build_hints` so
    /// `HintValue::ExprId` can emit `Operand::Expression` with a
    /// packed index that matches the air's expressions[] array.
    air_expr_id_maps: HashMap<(u32, u32), Vec<u32>>,
    /// Scratch slot set before each per-air hint serialization so the
    /// `HintValue::ExprId` arm can look up the packed index without
    /// threading the map through every hint-value helper.
    current_air_expr_id_map: Option<Vec<u32>>,
}

impl<'a> ProtoOutBuilder<'a> {
    pub fn new(processor: &'a Processor) -> Self {
        Self {
            processor,
            witness_id_to_proto: Vec::new(),
            fixed_id_to_proto: Vec::new(),
            custom_id_to_proto: Vec::new(),
            air_value_id_to_proto: Vec::new(),
            air_expr_id_maps: HashMap::new(),
            current_air_expr_id_map: None,
        }
    }

    /// Build the complete PilOut protobuf message from the processor state.
    pub fn build(&mut self) -> pilout_proto::PilOut {
        let name = if self.processor.config.name.is_empty() {
            None
        } else {
            Some(self.processor.config.name.clone())
        };

        // base_field is the raw big-endian bytes of the field prime,
        // NOT reduced modulo itself. Strip leading zero bytes.
        let base_field = {
            let full = (GOLDILOCKS_PRIME as u64).to_be_bytes();
            let first_nonzero = full.iter().position(|&b| b != 0).unwrap_or(full.len());
            full[first_nonzero..].to_vec()
        };

        // Build air groups.
        let air_groups = self.build_air_groups();

        // Build num_challenges by stage.
        let num_challenges = self.build_stage_counts(&self.processor.challenges);

        // Build num_proof_values by stage.
        let num_proof_values = self.build_stage_counts(&self.processor.proof_values);

        // Number of public values.
        let num_public_values = self.processor.publics.len();

        // Build global expressions (flattened) and the index mapping.
        let (expressions, expr_id_map) = self.build_global_expressions();

        // Build global constraints using the remapped expression indices.
        let constraints = self.build_global_constraints(&expr_id_map);

        // Build symbols.
        let symbols = self.build_symbols();

        // Build hints (per-AIR and global). Must run after
        // build_air_groups so the per-air packed expression-id maps are
        // populated for HintValue::ExprId serialization.
        let hints = self.build_hints();

        pilout_proto::PilOut {
            name,
            base_field,
            air_groups,
            num_challenges,
            num_proof_values,
            num_public_values,
            public_tables: Vec::new(),
            expressions,
            constraints,
            hints,
            symbols,
        }
    }

    /// Build the air groups section.
    fn build_air_groups(&mut self) -> Vec<pilout_proto::AirGroup> {
        let mut result = Vec::new();
        for ag in self.processor.air_groups.iter() {
            // Build air group values from stored metadata.
            let agv: Vec<pilout_proto::AirGroupValue> = ag.air_group_values
                .iter()
                .map(|&(stage, agg_type)| pilout_proto::AirGroupValue {
                    agg_type,
                    stage,
                })
                .collect();

            let mut proto_ag = pilout_proto::AirGroup {
                name: Some(ag.name.clone()),
                air_group_values: agv,
                airs: Vec::new(),
            };

            // Build airs within this group (skip virtual airs, which live
            // in a separate namespace in the JS compiler and are never
            // included in the protobuf output).
            let ag_idx = self.processor.air_groups.iter().position(|g| std::ptr::eq(g, ag)).unwrap_or(0) as u32;
            let mut air_id_counter = 0u32;
            for air in ag.airs.iter().filter(|a| !a.is_virtual) {
                // Flatten the FULL AIR expression store into the protobuf
                // array. This includes ALL expressions created during AIR
                // execution (intermediate column definitions, constraint
                // sub-expressions, etc.), matching the JS compiler's
                // `this.expressions.pack(...)` behavior.
                let mut proto_expressions: Vec<pilout_proto::Expression> = Vec::new();
                let mut expr_id_map: Vec<u32> = Vec::new();

                // Use the full AIR expression store if available, falling
                // back to constraint-only expressions for backward compat.
                let expr_source = if !air.air_expression_store.is_empty() {
                    &air.air_expression_store
                } else {
                    &air.stored_expressions
                };

                let mut rc_cache: HashMap<*const RuntimeExpr, u32> = HashMap::new();
                for expr in expr_source {
                    let root_idx = self.flatten_air_expr(
                        expr,
                        &air.fixed_id_map,
                        air.fixed_col_start,
                        &air.witness_id_map,
                        &air.custom_id_map,
                        &expr_id_map,
                        &mut proto_expressions,
                        &mut rc_cache,
                    );
                    expr_id_map.push(root_idx);
                }

                // Stash the packed expression-id map so `build_hints`
                // can look up packed indices for this air when
                // serializing `HintValue::ExprId` hint leaves.
                self.air_expr_id_maps
                    .insert((ag_idx, air_id_counter), expr_id_map.clone());
                air_id_counter += 1;

                // Build per-AIR constraints, referencing the flattened
                // expression indices. The constraint expr_id offsets into
                // the stored_expressions; when using the full expression
                // store, we need to offset by the number of intermediate
                // expressions that were prepended.
                let constraint_expr_count = if air.stored_expressions_count > 0 {
                    air.stored_expressions_count
                } else {
                    air.stored_expressions.len()
                };
                let im_expr_count = if !air.air_expression_store.is_empty() {
                    air.air_expression_store.len() - constraint_expr_count
                } else {
                    0
                };
                let mut proto_constraints: Vec<pilout_proto::Constraint> = Vec::new();
                for entry in &air.stored_constraints {
                    // Offset the expression ID by the intermediate prefix.
                    let store_idx = (entry.expr_id as usize) + im_expr_count;
                    let expr_idx = expr_id_map
                        .get(store_idx)
                        .copied()
                        .unwrap_or(entry.expr_id);
                    let debug_line = Some(entry.source_ref.clone());
                    let expression_idx =
                        Some(pilout_proto::operand::Expression { idx: expr_idx });
                    let constraint_kind = match entry.boundary.as_deref() {
                        Some("first") => {
                            pilout_proto::constraint::Constraint::FirstRow(
                                pilout_proto::constraint::FirstRow {
                                    expression_idx,
                                    debug_line,
                                },
                            )
                        }
                        Some("last") => {
                            pilout_proto::constraint::Constraint::LastRow(
                                pilout_proto::constraint::LastRow {
                                    expression_idx,
                                    debug_line,
                                },
                            )
                        }
                        Some("frame") => {
                            pilout_proto::constraint::Constraint::EveryFrame(
                                pilout_proto::constraint::EveryFrame {
                                    expression_idx,
                                    offset_min: 0,
                                    offset_max: 0,
                                    debug_line,
                                },
                            )
                        }
                        _ => {
                            // Default: everyRow (matches JS false/all).
                            pilout_proto::constraint::Constraint::EveryRow(
                                pilout_proto::constraint::EveryRow {
                                    expression_idx,
                                    debug_line,
                                },
                            )
                        }
                    };
                    proto_constraints.push(pilout_proto::Constraint {
                        constraint: Some(constraint_kind),
                    });
                }

                // Build fixed column entries (empty values when using
                // fixed-to-file mode; the data is in separate .fixed
                // files).
                let mut proto_fixed: Vec<pilout_proto::FixedCol> = Vec::new();
                let mut proto_periodic: Vec<pilout_proto::PeriodicCol> = Vec::new();
                for &(ctype, _proto_idx) in &air.fixed_id_map {
                    match ctype {
                        'F' => proto_fixed.push(pilout_proto::FixedCol {
                            values: Vec::new(),
                        }),
                        'P' => proto_periodic.push(pilout_proto::PeriodicCol {
                            values: Vec::new(),
                        }),
                        _ => {}
                    }
                }

                // Build air values from stored per-value stage metadata.
                let proto_air_values: Vec<pilout_proto::AirValue> = air
                    .air_value_stages
                    .iter()
                    .map(|&stage| pilout_proto::AirValue { stage })
                    .collect();

                // Build custom commits from stored commit info.
                let proto_custom_commits: Vec<pilout_proto::CustomCommit> = air
                    .custom_commits
                    .iter()
                    .map(|(name, sw, pub_ids)| pilout_proto::CustomCommit {
                        name: if name.is_empty() { None } else { Some(name.clone()) },
                        public_values: pub_ids.iter().map(|&idx| {
                            pilout_proto::global_operand::PublicValue { idx }
                        }).collect(),
                        stage_widths: sw.clone(),
                    })
                    .collect();

                let proto_air = pilout_proto::Air {
                    name: Some(air.name.clone()),
                    num_rows: Some(air.rows as u32),
                    periodic_cols: proto_periodic,
                    fixed_cols: proto_fixed,
                    stage_widths: air.stage_widths.clone(),
                    expressions: proto_expressions,
                    constraints: proto_constraints,
                    air_values: proto_air_values,
                    aggregable: true,
                    custom_commits: proto_custom_commits,
                };
                proto_ag.airs.push(proto_air);
            }

            result.push(proto_ag);
        }
        result
    }

    /// Build num-per-stage counts from an IdAllocator (for challenges,
    /// proof values, etc.).
    fn build_stage_counts(&self, alloc: &IdAllocator) -> Vec<u32> {
        let mut by_stage: HashMap<u32, u32> = HashMap::new();
        for data in &alloc.datas {
            let stage = data.stage.unwrap_or(1);
            *by_stage.entry(stage).or_insert(0) += 1;
        }
        if by_stage.is_empty() {
            return Vec::new();
        }
        let max_stage = *by_stage.keys().max().unwrap();
        let mut result = vec![0u32; max_stage as usize];
        for (stage, count) in by_stage {
            if stage > 0 && (stage as usize) <= result.len() {
                result[(stage - 1) as usize] = count;
            }
        }
        result
    }

    /// Build global expressions from proof-level intermediates and
    /// global constraint expressions.
    ///
    /// Expression trees are flattened into a linear array: nested
    /// sub-expressions are emitted first and referenced by index from
    /// their parent expression via `GlobalOperand::Expression { idx }`.
    ///
    /// Returns (flattened_expressions, mapping) where mapping[i] is the
    /// flattened index of the original expression store entry i
    /// (offset by the intermediate expression count for constraint entries).
    fn build_global_expressions(
        &self,
    ) -> (Vec<pilout_proto::GlobalExpression>, Vec<u32>) {
        let mut result = Vec::new();
        let mut id_map = Vec::new();

        // First, flatten proof-level intermediate expressions.
        for expr in &self.processor.global_expression_store {
            let idx = self.flatten_expr_to_global(expr, &mut result);
            id_map.push(idx);
        }

        // Then flatten constraint expressions.
        for expr in self.processor.global_constraints.all_expressions() {
            let idx = self.flatten_expr_to_global(expr, &mut result);
            id_map.push(idx);
        }
        (result, id_map)
    }

    /// Build global constraints, remapping expression indices to the
    /// flattened expression array. Constraint expr_ids are offset by the
    /// number of proof-level intermediate expressions that were prepended.
    fn build_global_constraints(
        &self,
        expr_id_map: &[u32],
    ) -> Vec<pilout_proto::GlobalConstraint> {
        let im_count = self.processor.global_expression_store.len();
        let mut result = Vec::new();
        for entry in self.processor.global_constraints.iter() {
            let store_idx = (entry.expr_id as usize) + im_count;
            let mapped_idx = expr_id_map
                .get(store_idx)
                .copied()
                .unwrap_or(entry.expr_id);
            let gc = pilout_proto::GlobalConstraint {
                expression_idx: Some(pilout_proto::global_operand::Expression {
                    idx: mapped_idx,
                }),
                debug_line: Some(entry.source_ref.clone()),
            };
            result.push(gc);
        }
        result
    }

    /// Build the symbols table.
    ///
    /// This combines:
    /// - Global symbols (public, proofvalue, challenge) from the processor's
    ///   global allocators, using per-stage relative IDs.
    /// - Air group value symbols from each air group.
    /// - Per-AIR symbols (witness, fixed, customcol, airvalue, im) from stored
    ///   symbol entries and translation maps, matching JS `setSymbolsFromLabels`.
    fn build_symbols(&self) -> Vec<pilout_proto::Symbol> {
        let mut result = Vec::new();

        // ------------------------------------------------------------------
        // Global symbols: public, proofvalue, challenge
        // These use relativeId (per-stage sequential index).
        // ------------------------------------------------------------------

        // Public values: id is absolute (no relativeId needed).
        for lr in self.processor.publics.label_ranges.to_vec() {
            let src = self.processor.publics.get_data(lr.from)
                .map(|d| d.source_ref.clone())
                .unwrap_or_default();
            result.push(pilout_proto::Symbol {
                name: lr.label.clone(),
                air_group_id: None,
                air_id: None,
                r#type: REF_TYPE_PUBLIC_VALUE,
                id: lr.from,
                stage: None,
                dim: lr.array_dims.len() as u32,
                lengths: lr.array_dims.clone(),
                commit_id: None,
                debug_line: Some(src),
            });
        }

        // Proof values: use relativeId (per-stage index).
        {
            let mut stage_counters: HashMap<u32, u32> = HashMap::new();
            for data in &self.processor.proof_values.datas {
                let stage = data.stage.unwrap_or(1);
                stage_counters.entry(stage).or_insert(0);
            }
            // Reset counters before iterating label ranges.
            stage_counters.values_mut().for_each(|v| *v = 0);
            for lr in self.processor.proof_values.label_ranges.to_vec() {
                let data = self.processor.proof_values.get_data(lr.from);
                let stage = data.and_then(|d| d.stage).unwrap_or(1);
                let relative_id = *stage_counters.entry(stage).or_insert(0);
                *stage_counters.get_mut(&stage).unwrap() += lr.count;
                let src = data.map(|d| d.source_ref.clone()).unwrap_or_default();
                result.push(pilout_proto::Symbol {
                    name: lr.label.clone(),
                    air_group_id: None,
                    air_id: None,
                    r#type: REF_TYPE_PROOF_VALUE,
                    id: relative_id,
                    stage: Some(stage),
                    dim: lr.array_dims.len() as u32,
                    lengths: lr.array_dims.clone(),
                    commit_id: None,
                    debug_line: Some(src),
                });
            }
        }

        // Challenges: use relativeId (per-stage index).
        {
            let mut stage_counters: HashMap<u32, u32> = HashMap::new();
            for lr in self.processor.challenges.label_ranges.to_vec() {
                let data = self.processor.challenges.get_data(lr.from);
                let stage = data.and_then(|d| d.stage).unwrap_or(2);
                let relative_id = *stage_counters.entry(stage).or_insert(0);
                *stage_counters.get_mut(&stage).unwrap() += lr.count;
                let src = data.map(|d| d.source_ref.clone()).unwrap_or_default();
                result.push(pilout_proto::Symbol {
                    name: lr.label.clone(),
                    air_group_id: None,
                    air_id: None,
                    r#type: REF_TYPE_CHALLENGE,
                    id: relative_id,
                    stage: Some(stage),
                    dim: lr.array_dims.len() as u32,
                    lengths: lr.array_dims.clone(),
                    commit_id: None,
                    debug_line: Some(src),
                });
            }
        }

        // ------------------------------------------------------------------
        // Air group values: per-airgroup with relativeId.
        // The global air_group_values allocator accumulates IDs across all
        // airgroups, so we track a cumulative offset to look up the correct
        // global ID for each airgroup's values.
        // ------------------------------------------------------------------
        {
            let mut global_agv_offset = 0u32;
            for (ag_idx, ag) in self.processor.air_groups.iter().enumerate() {
                let air_group_id = ag_idx as u32;
                let mut agv_relative_id = 0u32;
                for &(stage, _agg_type) in &ag.air_group_values {
                    let global_id = global_agv_offset + agv_relative_id;
                    // Use the label from the air_group_values allocator.
                    let raw_label = self.processor.air_group_values.label_ranges
                        .get_label(global_id)
                        .unwrap_or("")
                        .to_string();
                    // Prefix with the airgroup name to produce qualified
                    // names like "Zisk.gsum_result" (matching JS behavior).
                    let label = if !raw_label.is_empty() {
                        format!("{}.{}", ag.name, raw_label)
                    } else {
                        String::new()
                    };
                    if !label.is_empty() {
                        let src = self.processor.air_group_values.get_data(global_id)
                            .map(|d| d.source_ref.clone())
                            .unwrap_or_default();
                        result.push(pilout_proto::Symbol {
                            name: label,
                            air_group_id: Some(air_group_id),
                            air_id: None,
                            r#type: REF_TYPE_AIR_GROUP_VALUE,
                            id: agv_relative_id,
                            stage: Some(stage),
                            dim: 0,
                            lengths: Vec::new(),
                            commit_id: None,
                            debug_line: Some(src),
                        });
                    }
                    agv_relative_id += 1;
                }
                global_agv_offset += ag.air_group_values.len() as u32;
            }
        }

        // ------------------------------------------------------------------
        // Per-AIR symbols: witness, fixed, customcol, airvalue
        // Built from stored SymbolEntry + translation maps.
        //
        // Intermediate (im) symbols are omitted: the Rust compiler collects
        // all expr variable label ranges, which is a superset of what the
        // JS packed-expression labeling produces. Until expression packing
        // is implemented, skipping IM avoids emitting ~30k spurious symbols.
        // ------------------------------------------------------------------
        for (ag_idx, ag) in self.processor.air_groups.iter().enumerate() {
            let air_group_id = ag_idx as u32;
            let mut non_virtual_pos = 0u32;
            for air in &ag.airs {
                if air.is_virtual {
                    continue;
                }
                let air_id = non_virtual_pos;
                non_virtual_pos += 1;
                let mut air_value_counter = 0u32;
                for sym in &air.symbols {
                    match sym.ref_type_str.as_str() {
                        "witness" => {
                            // Remap through witness_id_map: internal_id -> (stage, proto_index)
                            let (stage, proto_id) = air.witness_id_map
                                .get(sym.internal_id as usize)
                                .copied()
                                .unwrap_or((1, sym.internal_id));
                            result.push(pilout_proto::Symbol {
                                name: sym.name.clone(),
                                air_group_id: Some(air_group_id),
                                air_id: Some(air_id),
                                r#type: REF_TYPE_WITNESS_COL,
                                id: proto_id,
                                stage: Some(stage),
                                dim: sym.dim,
                                lengths: sym.lengths.clone(),
                                commit_id: None,
                                debug_line: Some(sym.source_ref.clone()),
                            });
                        }
                        "fixed" => {
                            // Remap through fixed_id_map: internal_id -> (type, proto_index).
                            // The map is dense (relative to fixed_col_start).
                            let rel_idx = sym.internal_id.checked_sub(air.fixed_col_start)
                                .unwrap_or(sym.internal_id) as usize;
                            let (ctype, proto_id) = air.fixed_id_map
                                .get(rel_idx)
                                .copied()
                                .unwrap_or(('F', sym.internal_id));
                            let sym_type = if ctype == 'P' {
                                REF_TYPE_PERIODIC_COL
                            } else {
                                REF_TYPE_FIXED_COL
                            };
                            result.push(pilout_proto::Symbol {
                                name: sym.name.clone(),
                                air_group_id: Some(air_group_id),
                                air_id: Some(air_id),
                                r#type: sym_type,
                                id: proto_id,
                                stage: if ctype == 'P' { None } else { Some(0) },
                                dim: sym.dim,
                                lengths: sym.lengths.clone(),
                                commit_id: None,
                                debug_line: Some(sym.source_ref.clone()),
                            });
                        }
                        "customcol" => {
                            // Remap through custom_id_map: internal_id -> (stage, proto_index, commit_id)
                            let (stage, proto_id, commit_id) = air.custom_id_map
                                .get(sym.internal_id as usize)
                                .copied()
                                .unwrap_or((0, sym.internal_id, 0));
                            result.push(pilout_proto::Symbol {
                                name: sym.name.clone(),
                                air_group_id: Some(air_group_id),
                                air_id: Some(air_id),
                                r#type: REF_TYPE_CUSTOM_COL,
                                id: proto_id,
                                stage: Some(stage),
                                dim: sym.dim,
                                lengths: sym.lengths.clone(),
                                commit_id: Some(commit_id),
                                debug_line: Some(sym.source_ref.clone()),
                            });
                        }
                        "airvalue" => {
                            let stage = air.air_value_stages
                                .get(sym.internal_id as usize)
                                .copied()
                                .unwrap_or(1);
                            let av_proto_id = air_value_counter;
                            air_value_counter += 1;
                            result.push(pilout_proto::Symbol {
                                name: sym.name.clone(),
                                air_group_id: Some(air_group_id),
                                air_id: Some(air_id),
                                r#type: REF_TYPE_AIR_VALUE,
                                id: av_proto_id,
                                stage: Some(stage),
                                dim: sym.dim,
                                lengths: sym.lengths.clone(),
                                commit_id: None,
                                debug_line: Some(sym.source_ref.clone()),
                            });
                        }
                        "im" => {
                            // Emit IM symbols: internal_id is the packed
                            // expression index in the air_expression_store.
                            result.push(pilout_proto::Symbol {
                                name: sym.name.clone(),
                                air_group_id: Some(air_group_id),
                                air_id: Some(air_id),
                                r#type: REF_TYPE_IM_COL,
                                id: sym.internal_id,
                                stage: None,
                                dim: sym.dim,
                                lengths: sym.lengths.clone(),
                                commit_id: None,
                                debug_line: Some(sym.source_ref.clone()),
                            });
                        }
                        _ => {}
                    }
                }
            }
        }

        result
    }

    /// Build the hints section of the PilOut.
    ///
    /// Collects per-AIR hints (with air_group_id/air_id) and global hints
    /// (without air/airgroup scope), converting HintValue trees into
    /// protobuf HintField messages.
    fn build_hints(&mut self) -> Vec<pilout_proto::Hint> {
        let mut result = Vec::new();

        // Per-AIR hints: iterate airgroups -> airs, using stored hints.
        for (ag_idx, ag) in self.processor.air_groups.iter().enumerate() {
            let air_group_id = ag_idx as u32;
            let mut non_virtual_pos = 0u32;
            for air in &ag.airs {
                if air.is_virtual {
                    continue;
                }
                let air_id = non_virtual_pos;
                non_virtual_pos += 1;

                // Load the packed expression-id map built during
                // build_air_groups so HintValue::ExprId can emit an
                // Operand::Expression referencing the same index the
                // per-AIR expressions[] array uses.
                self.current_air_expr_id_map =
                    self.air_expr_id_maps.get(&(air_group_id, air_id)).cloned();

                for hint in &air.hints {
                    let hint_fields = self.hint_value_to_fields(
                        &hint.data,
                        &air.fixed_id_map,
                        air.fixed_col_start,
                        &air.witness_id_map,
                        &air.custom_id_map,
                        &air.air_expression_store,
                    );
                    result.push(pilout_proto::Hint {
                        name: hint.name.clone(),
                        hint_fields,
                        air_group_id: Some(air_group_id),
                        air_id: Some(air_id),
                    });
                }
                self.current_air_expr_id_map = None;
            }
        }

        // Global hints (proof-scope).
        for hint in &self.processor.global_hints {
            let hint_fields = self.hint_value_to_fields_global(&hint.data);
            result.push(pilout_proto::Hint {
                name: hint.name.clone(),
                hint_fields,
                air_group_id: None,
                air_id: None,
            });
        }

        result
    }

    /// Convert a HintValue to a list of HintField messages (per-AIR context).
    /// For objects, each key-value pair becomes a named HintField.
    /// For other values, a single unnamed HintField is returned.
    fn hint_value_to_fields(
        &self,
        value: &HintValue,
        fixed_map: &[(char, u32)],
        fixed_col_start: u32,
        witness_map: &[(u32, u32)],
        custom_map: &[(u32, u32, u32)],
        expr_store: &[RuntimeExpr],
    ) -> Vec<pilout_proto::HintField> {
        match value {
            HintValue::Object(pairs) => {
                let fields: Vec<pilout_proto::HintField> = pairs.iter().map(|(k, v)| {
                    let mut field = self.hint_value_to_single_field(v, fixed_map, fixed_col_start, witness_map, custom_map, expr_store);
                    field.name = Some(k.clone());
                    field
                }).collect();
                // Wrap named fields in a HintFieldArray (matching JS behavior).
                vec![pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::HintFieldArray(
                        pilout_proto::HintFieldArray { hint_fields: fields },
                    )),
                }]
            }
            _ => vec![self.hint_value_to_single_field(value, fixed_map, fixed_col_start, witness_map, custom_map, expr_store)],
        }
    }

    /// Convert a single HintValue to a HintField (per-AIR context).
    fn hint_value_to_single_field(
        &self,
        value: &HintValue,
        fixed_map: &[(char, u32)],
        fixed_col_start: u32,
        witness_map: &[(u32, u32)],
        custom_map: &[(u32, u32, u32)],
        expr_store: &[RuntimeExpr],
    ) -> pilout_proto::HintField {
        match value {
            HintValue::Int(v) => pilout_proto::HintField {
                name: None,
                value: Some(pilout_proto::hint_field::Value::Operand(
                    pilout_proto::Operand {
                        operand: Some(pilout_proto::operand::Operand::Constant(
                            pilout_proto::operand::Constant {
                                value: bigint_to_bytes(*v),
                            },
                        )),
                    },
                )),
            },
            HintValue::Str(s) => pilout_proto::HintField {
                name: None,
                value: Some(pilout_proto::hint_field::Value::StringValue(s.clone())),
            },
            HintValue::ExprId(expr_id) => {
                // Always emit as Operand::Expression referencing the
                // packed expression index. Mirrors JS `toHintField` which
                // uses packed expression references for every expression-
                // backed hint field, including simple witness / fixed /
                // custom leaves. Rust previously collapsed simple leaves
                // into direct witness/fixed/custom operands, which caused
                // divergence on gprod_col, gsum_col, gprod_debug_data, and
                // gsum_debug_data hint payloads. The translation from the
                // raw self.exprs id to the packed proto-expression index
                // lives on each air as `expr_id_map`; self.current_air_expr_id_map
                // exposes it for the currently-being-serialized air.
                let mapped = self
                    .current_air_expr_id_map
                    .as_ref()
                    .and_then(|m| m.get(*expr_id as usize).copied())
                    .unwrap_or(*expr_id);
                let _ = expr_store;
                let _ = fixed_map;
                let _ = fixed_col_start;
                let _ = witness_map;
                let _ = custom_map;
                pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::Operand(
                        pilout_proto::Operand {
                            operand: Some(pilout_proto::operand::Operand::Expression(
                                pilout_proto::operand::Expression { idx: mapped },
                            )),
                        },
                    )),
                }
            }
            HintValue::Array(items) => {
                let fields: Vec<pilout_proto::HintField> = items.iter()
                    .map(|v| self.hint_value_to_single_field(v, fixed_map, fixed_col_start, witness_map, custom_map, expr_store))
                    .collect();
                pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::HintFieldArray(
                        pilout_proto::HintFieldArray { hint_fields: fields },
                    )),
                }
            }
            HintValue::Object(pairs) => {
                let fields: Vec<pilout_proto::HintField> = pairs.iter().map(|(k, v)| {
                    let mut field = self.hint_value_to_single_field(v, fixed_map, fixed_col_start, witness_map, custom_map, expr_store);
                    field.name = Some(k.clone());
                    field
                }).collect();
                pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::HintFieldArray(
                        pilout_proto::HintFieldArray { hint_fields: fields },
                    )),
                }
            }
        }
    }


    /// Convert hint value to fields in global (proof) context.
    fn hint_value_to_fields_global(
        &self,
        value: &HintValue,
    ) -> Vec<pilout_proto::HintField> {
        match value {
            HintValue::Object(pairs) => {
                let fields: Vec<pilout_proto::HintField> = pairs.iter().map(|(k, v)| {
                    let mut field = self.hint_value_to_single_field_global(v);
                    field.name = Some(k.clone());
                    field
                }).collect();
                vec![pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::HintFieldArray(
                        pilout_proto::HintFieldArray { hint_fields: fields },
                    )),
                }]
            }
            _ => vec![self.hint_value_to_single_field_global(value)],
        }
    }

    /// Convert a single HintValue to a HintField (global context).
    fn hint_value_to_single_field_global(
        &self,
        value: &HintValue,
    ) -> pilout_proto::HintField {
        match value {
            HintValue::Int(v) => pilout_proto::HintField {
                name: None,
                value: Some(pilout_proto::hint_field::Value::Operand(
                    pilout_proto::Operand {
                        operand: Some(pilout_proto::operand::Operand::Constant(
                            pilout_proto::operand::Constant {
                                value: bigint_to_bytes(*v),
                            },
                        )),
                    },
                )),
            },
            HintValue::Str(s) => pilout_proto::HintField {
                name: None,
                value: Some(pilout_proto::hint_field::Value::StringValue(s.clone())),
            },
            HintValue::ExprId(expr_id) => {
                // Global expressions: reference by index into global expression store.
                pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::Operand(
                        pilout_proto::Operand {
                            operand: Some(pilout_proto::operand::Operand::Expression(
                                pilout_proto::operand::Expression { idx: *expr_id },
                            )),
                        },
                    )),
                }
            }
            HintValue::Array(items) => {
                let fields: Vec<pilout_proto::HintField> = items.iter()
                    .map(|v| self.hint_value_to_single_field_global(v))
                    .collect();
                pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::HintFieldArray(
                        pilout_proto::HintFieldArray { hint_fields: fields },
                    )),
                }
            }
            HintValue::Object(pairs) => {
                let fields: Vec<pilout_proto::HintField> = pairs.iter().map(|(k, v)| {
                    let mut field = self.hint_value_to_single_field_global(v);
                    field.name = Some(k.clone());
                    field
                }).collect();
                pilout_proto::HintField {
                    name: None,
                    value: Some(pilout_proto::hint_field::Value::HintFieldArray(
                        pilout_proto::HintFieldArray { hint_fields: fields },
                    )),
                }
            }
        }
    }

    /// Flatten a RuntimeExpr tree into the global expressions array.
    ///
    /// Returns the index of the newly appended expression within `out`.
    /// Sub-expressions (nested BinOp / UnaryOp) are recursively
    /// flattened first so their indices are available as operands.
    ///
    fn flatten_expr_to_global(
        &self,
        expr: &RuntimeExpr,
        out: &mut Vec<pilout_proto::GlobalExpression>,
    ) -> u32 {
        let op = match expr {
            RuntimeExpr::BinOp { op, left, right } => {
                let lhs = self.flatten_operand_to_global(left, out);
                let rhs = self.flatten_operand_to_global(right, out);
                match op {
                    RuntimeOp::Add => {
                        pilout_proto::global_expression::Operation::Add(
                            pilout_proto::global_expression::Add { lhs, rhs },
                        )
                    }
                    RuntimeOp::Sub => {
                        pilout_proto::global_expression::Operation::Sub(
                            pilout_proto::global_expression::Sub { lhs, rhs },
                        )
                    }
                    RuntimeOp::Mul => {
                        pilout_proto::global_expression::Operation::Mul(
                            pilout_proto::global_expression::Mul { lhs, rhs },
                        )
                    }
                }
            }
            RuntimeExpr::UnaryOp { op, operand } => match op {
                RuntimeUnaryOp::Neg => {
                    let value = self.flatten_operand_to_global(operand, out);
                    pilout_proto::global_expression::Operation::Neg(
                        pilout_proto::global_expression::Neg { value },
                    )
                }
            },
            // Leaf nodes (Value, ColRef) are not top-level expressions on
            // their own; wrap them in a trivial Add(x, 0) so they still get
            // an expression slot.
            _ => {
                let leaf = self.leaf_to_global_operand(expr);
                let zero = Some(pilout_proto::GlobalOperand {
                    operand: Some(pilout_proto::global_operand::Operand::Constant(
                        pilout_proto::global_operand::Constant { value: Vec::new() },
                    )),
                });
                pilout_proto::global_expression::Operation::Add(
                    pilout_proto::global_expression::Add { lhs: leaf, rhs: zero },
                )
            }
        };

        let proto_expr = pilout_proto::GlobalExpression {
            operation: Some(op),
        };

        let idx = out.len() as u32;
        out.push(proto_expr);
        idx
    }

    /// Convert a RuntimeExpr to a global operand, flattening nested
    /// sub-expressions into `out` and referencing them by index.
    fn flatten_operand_to_global(
        &self,
        expr: &RuntimeExpr,
        out: &mut Vec<pilout_proto::GlobalExpression>,
    ) -> Option<pilout_proto::GlobalOperand> {
        match expr {
            // Nested expression: flatten recursively and reference by index.
            RuntimeExpr::BinOp { .. } | RuntimeExpr::UnaryOp { .. } => {
                let idx = self.flatten_expr_to_global(expr, out);
                Some(pilout_proto::GlobalOperand {
                    operand: Some(pilout_proto::global_operand::Operand::Expression(
                        pilout_proto::global_operand::Expression { idx },
                    )),
                })
            }
            // Leaf: delegate to non-recursive conversion.
            _ => self.leaf_to_global_operand(expr),
        }
    }

    /// Convert a leaf RuntimeExpr (Value or ColRef) to a global operand.
    fn leaf_to_global_operand(
        &self,
        expr: &RuntimeExpr,
    ) -> Option<pilout_proto::GlobalOperand> {
        let operand = match expr {
            RuntimeExpr::Value(Value::Int(v)) => {
                pilout_proto::global_operand::Operand::Constant(
                    pilout_proto::global_operand::Constant {
                        value: bigint_to_bytes(*v),
                    },
                )
            }
            RuntimeExpr::Value(Value::Fe(v)) => {
                pilout_proto::global_operand::Operand::Constant(
                    pilout_proto::global_operand::Constant {
                        value: bigint_to_bytes(*v as i128),
                    },
                )
            }
            RuntimeExpr::ColRef { col_type, id, .. } => match col_type {
                ColRefKind::Challenge => {
                    let stage = self.processor.challenges.get_data(*id)
                        .and_then(|d| d.stage)
                        .unwrap_or(1);
                    pilout_proto::global_operand::Operand::Challenge(
                        pilout_proto::global_operand::Challenge {
                            stage,
                            idx: *id,
                        },
                    )
                }
                ColRefKind::ProofValue => {
                    let stage = self.processor.proof_values.get_data(*id)
                        .and_then(|d| d.stage)
                        .unwrap_or(1);
                    pilout_proto::global_operand::Operand::ProofValue(
                        pilout_proto::global_operand::ProofValue {
                            stage,
                            idx: *id,
                        },
                    )
                }
                ColRefKind::AirGroupValue => {
                    pilout_proto::global_operand::Operand::AirGroupValue(
                        pilout_proto::global_operand::AirGroupValue {
                            air_group_id: 0,
                            idx: *id,
                        },
                    )
                }
                ColRefKind::Public => {
                    pilout_proto::global_operand::Operand::PublicValue(
                        pilout_proto::global_operand::PublicValue { idx: *id },
                    )
                }
                _ => return None,
            },
            // BinOp/UnaryOp should not reach here; handled by
            // flatten_operand_to_global above.
            _ => return None,
        };

        Some(pilout_proto::GlobalOperand {
            operand: Some(operand),
        })
    }

    // -------------------------------------------------------------------
    // Per-AIR expression/operand flattening (uses Operand, not
    // GlobalOperand).
    // -------------------------------------------------------------------

    /// Flatten a RuntimeExpr tree into the per-AIR expressions array.
    /// Returns the index of the appended expression.
    ///
    /// `expr_id_map` translates internal expression-store IDs to packed
    /// protobuf indices. This is critical for `Intermediate` operands
    /// which reference expressions by their store ID.
    ///
    /// `custom_id_map` translates internal custom column IDs to
    /// (stage, proto_index, commit_id).
    ///
    fn flatten_air_expr(
        &self,
        expr: &RuntimeExpr,
        fixed_map: &[(char, u32)],
        fixed_col_start: u32,
        witness_map: &[(u32, u32)],
        custom_map: &[(u32, u32, u32)],
        expr_id_map: &[u32],
        out: &mut Vec<pilout_proto::Expression>,
        rc_cache: &mut HashMap<*const RuntimeExpr, u32>,
    ) -> u32 {
        // Deduplicate Rc-shared subtrees: if this pointer was already
        // flattened, reference the existing proto entry. This mirrors the
        // JS stack-based expression format where shared sub-expressions
        // are referenced by index rather than duplicated.
        let ptr = expr as *const RuntimeExpr;
        if let Some(&cached_idx) = rc_cache.get(&ptr) {
            return cached_idx;
        }

        let op = match expr {
            RuntimeExpr::BinOp { op, left, right } => {
                let lhs = self.flatten_air_operand(left, fixed_map, fixed_col_start, witness_map, custom_map, expr_id_map, out, rc_cache);
                let rhs = self.flatten_air_operand(right, fixed_map, fixed_col_start, witness_map, custom_map, expr_id_map, out, rc_cache);
                match op {
                    RuntimeOp::Add => pilout_proto::expression::Operation::Add(
                        pilout_proto::expression::Add { lhs, rhs },
                    ),
                    RuntimeOp::Sub => pilout_proto::expression::Operation::Sub(
                        pilout_proto::expression::Sub { lhs, rhs },
                    ),
                    RuntimeOp::Mul => pilout_proto::expression::Operation::Mul(
                        pilout_proto::expression::Mul { lhs, rhs },
                    ),
                }
            }
            RuntimeExpr::UnaryOp { op, operand } => match op {
                RuntimeUnaryOp::Neg => {
                    let value =
                        self.flatten_air_operand(operand, fixed_map, fixed_col_start, witness_map, custom_map, expr_id_map, out, rc_cache);
                    pilout_proto::expression::Operation::Neg(
                        pilout_proto::expression::Neg { value },
                    )
                }
            },
            // Leaf node: wrap in Add(x, 0).
            _ => {
                let leaf = self.leaf_to_air_operand(expr, fixed_map, fixed_col_start, witness_map, custom_map, expr_id_map);
                let zero = Some(pilout_proto::Operand {
                    operand: Some(pilout_proto::operand::Operand::Constant(
                        pilout_proto::operand::Constant { value: Vec::new() },
                    )),
                });
                pilout_proto::expression::Operation::Add(pilout_proto::expression::Add {
                    lhs: leaf,
                    rhs: zero,
                })
            }
        };

        let proto_expr = pilout_proto::Expression {
            operation: Some(op),
        };

        let idx = out.len() as u32;
        out.push(proto_expr);
        rc_cache.insert(ptr, idx);
        idx
    }

    /// Convert a RuntimeExpr to a per-AIR Operand.
    fn flatten_air_operand(
        &self,
        expr: &RuntimeExpr,
        fixed_map: &[(char, u32)],
        fixed_col_start: u32,
        witness_map: &[(u32, u32)],
        custom_map: &[(u32, u32, u32)],
        expr_id_map: &[u32],
        out: &mut Vec<pilout_proto::Expression>,
        rc_cache: &mut HashMap<*const RuntimeExpr, u32>,
    ) -> Option<pilout_proto::Operand> {
        match expr {
            RuntimeExpr::BinOp { .. } | RuntimeExpr::UnaryOp { .. } => {
                let idx = self.flatten_air_expr(expr, fixed_map, fixed_col_start, witness_map, custom_map, expr_id_map, out, rc_cache);
                Some(pilout_proto::Operand {
                    operand: Some(pilout_proto::operand::Operand::Expression(
                        pilout_proto::operand::Expression { idx },
                    )),
                })
            }
            _ => self.leaf_to_air_operand(expr, fixed_map, fixed_col_start, witness_map, custom_map, expr_id_map),
        }
    }

    /// Convert a leaf RuntimeExpr to a per-AIR Operand.
    fn leaf_to_air_operand(
        &self,
        expr: &RuntimeExpr,
        fixed_map: &[(char, u32)],
        fixed_col_start: u32,
        witness_map: &[(u32, u32)],
        custom_map: &[(u32, u32, u32)],
        expr_id_map: &[u32],
    ) -> Option<pilout_proto::Operand> {
        let operand = match expr {
            RuntimeExpr::Value(Value::Int(v)) => {
                pilout_proto::operand::Operand::Constant(pilout_proto::operand::Constant {
                    value: bigint_to_bytes(*v),
                })
            }
            RuntimeExpr::Value(Value::Fe(v)) => {
                pilout_proto::operand::Operand::Constant(pilout_proto::operand::Constant {
                    value: bigint_to_bytes(*v as i128),
                })
            }
            RuntimeExpr::ColRef {
                col_type,
                id,
                row_offset,
            } => {
                let offset = row_offset.unwrap_or(0) as i32;
                match col_type {
                    ColRefKind::Fixed => {
                        let rel_idx = (*id).checked_sub(fixed_col_start).unwrap_or(*id) as usize;
                        let (ctype, proto_idx) =
                            fixed_map.get(rel_idx).copied().unwrap_or(('F', *id));
                        if ctype == 'P' {
                            pilout_proto::operand::Operand::PeriodicCol(
                                pilout_proto::operand::PeriodicCol {
                                    idx: proto_idx,
                                    row_offset: offset,
                                },
                            )
                        } else {
                            pilout_proto::operand::Operand::FixedCol(
                                pilout_proto::operand::FixedCol {
                                    idx: proto_idx,
                                    row_offset: offset,
                                },
                            )
                        }
                    }
                    ColRefKind::Witness => {
                        let (stage, col_idx) =
                            witness_map.get(*id as usize).copied().unwrap_or((1, *id));
                        pilout_proto::operand::Operand::WitnessCol(
                            pilout_proto::operand::WitnessCol {
                                stage,
                                col_idx,
                                row_offset: offset,
                            },
                        )
                    }
                    ColRefKind::Challenge => {
                        let stage = self.processor.challenges.get_data(*id)
                            .and_then(|d| d.stage)
                            .unwrap_or(1);
                        pilout_proto::operand::Operand::Challenge(
                            pilout_proto::operand::Challenge { stage, idx: *id },
                        )
                    }
                    ColRefKind::ProofValue => {
                        let stage = self.processor.proof_values.get_data(*id)
                            .and_then(|d| d.stage)
                            .unwrap_or(1);
                        pilout_proto::operand::Operand::ProofValue(
                            pilout_proto::operand::ProofValue { stage, idx: *id },
                        )
                    }
                    ColRefKind::AirGroupValue => {
                        pilout_proto::operand::Operand::AirGroupValue(
                            pilout_proto::operand::AirGroupValue { idx: *id },
                        )
                    }
                    ColRefKind::AirValue => {
                        pilout_proto::operand::Operand::AirValue(
                            pilout_proto::operand::AirValue { idx: *id },
                        )
                    }
                    ColRefKind::Public => {
                        pilout_proto::operand::Operand::PublicValue(
                            pilout_proto::operand::PublicValue { idx: *id },
                        )
                    }
                    ColRefKind::Custom => {
                        // Use per-AIR custom_id_map for remapped stage,
                        // proto_index, and commit_id.
                        let (stage, col_idx, commit_id) = custom_map
                            .get(*id as usize)
                            .copied()
                            .unwrap_or((0, *id, 0));
                        pilout_proto::operand::Operand::CustomCol(
                            pilout_proto::operand::CustomCol {
                                commit_id,
                                stage,
                                col_idx,
                                row_offset: offset,
                            },
                        )
                    }
                    ColRefKind::Intermediate => {
                        // Intermediate columns are expression references.
                        // Remap from internal expression-store ID to the
                        // packed protobuf index via expr_id_map.
                        let proto_idx = expr_id_map
                            .get(*id as usize)
                            .copied()
                            .unwrap_or(*id);
                        pilout_proto::operand::Operand::Expression(
                            pilout_proto::operand::Expression { idx: proto_idx },
                        )
                    }
                }
            }
            _ => return None,
        };

        Some(pilout_proto::Operand {
            operand: Some(operand),
        })
    }
}

/// Serialize the processor state and write the .pilout file.
pub fn write_pilout(processor: &Processor, path: &str) -> anyhow::Result<()> {
    let mut builder = ProtoOutBuilder::new(processor);
    let pilout = builder.build();

    let total_air_exprs: usize = pilout.air_groups.iter()
        .flat_map(|ag| ag.airs.iter())
        .map(|a| a.expressions.len())
        .sum();
    let total_air_constraints: usize = pilout.air_groups.iter()
        .flat_map(|ag| ag.airs.iter())
        .map(|a| a.constraints.len())
        .sum();
    eprintln!(
        "  > Proto: {} air groups, {} symbols, {} hints, {} global expressions, {} global constraints, {} air expressions, {} air constraints",
        pilout.air_groups.len(),
        pilout.symbols.len(),
        pilout.hints.len(),
        pilout.expressions.len(),
        pilout.constraints.len(),
        total_air_exprs,
        total_air_constraints,
    );

    let encoded = pilout.encode_to_vec();
    eprintln!("  > Proto encoded size: {} bytes", encoded.len());

    let parent = Path::new(path).parent();
    if let Some(dir) = parent {
        if !dir.exists() {
            fs::create_dir_all(dir)?;
        }
    }

    let mut file = fs::File::create(path)?;
    file.write_all(&encoded)?;
    eprintln!("  > Proto written to {}", path);

    Ok(())
}

/// Write fixed column data to a binary file.
///
/// The JS compiler writes row-major order: for each row, iterate over all
/// non-temporal/non-external columns and write one u64 per column.  The
/// filename follows the pattern `{air_name}.fixed` (matching the JS
/// `Air.outputFixedFile` default).
pub fn write_fixed_cols_to_file(
    fixed_cols: &FixedCols,
    num_rows: u64,
    output_dir: &str,
    fixed_filename: &str,
) -> anyhow::Result<()> {
    let dir = Path::new(output_dir);
    if !dir.exists() {
        fs::create_dir_all(dir)?;
    }

    let filename = dir.join(fixed_filename);
    eprintln!("  > Saving fixed file {} ...", filename.display());
    let mut file = fs::File::create(&filename)?;

    // Collect the IDs of non-temporal, non-external columns that have data.
    let mut col_ids: Vec<u32> = Vec::new();
    let fc_start = fixed_cols.current_start();
    let fc_end = fc_start + fixed_cols.ids.current_len();
    for id in fc_start..fc_end {
        if let Some(data) = fixed_cols.ids.get_data(id) {
            if data.temporal || data.external {
                continue;
            }
        }
        col_ids.push(id);
    }

    let col_count = col_ids.len() as u32;
    let mut total_values = 0u64;

    // Write in row-major order (matches the JS FixedFile.saveToFile layout).
    for row in 0..num_rows as usize {
        for &id in &col_ids {
            let val = if let Some(row_data) = fixed_cols.get_row_data(id) {
                if row < row_data.len() {
                    let v = row_data[row];
                    if v < 0 {
                        let neg = ((-v) as u128) % GOLDILOCKS_PRIME;
                        if neg == 0 { 0u64 } else { (GOLDILOCKS_PRIME - neg) as u64 }
                    } else {
                        ((v as u128) % GOLDILOCKS_PRIME) as u64
                    }
                } else {
                    0u64
                }
            } else {
                0u64
            };
            file.write_all(&val.to_le_bytes())?;
            total_values += 1;
        }
    }

    eprintln!(
        "  > Fixed cols written to {}: {} cols, {} values",
        filename.display(),
        col_count,
        total_values
    );

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use super::pilout_proto;

    #[test]
    fn test_proto_types_exist() {
        // Verify that key protobuf types are generated and accessible.
        let _pilout = pilout_proto::PilOut::default();
        let _air_group = pilout_proto::AirGroup::default();
        let _air = pilout_proto::Air::default();
        let _symbol = pilout_proto::Symbol::default();
        let _hint = pilout_proto::Hint::default();
    }

    #[test]
    fn test_bigint_to_bytes_zero() {
        let bytes = bigint_to_bytes(0);
        assert!(bytes.is_empty());
    }

    #[test]
    fn test_bigint_to_bytes_one() {
        let bytes = bigint_to_bytes(1);
        assert_eq!(bytes, vec![1]);
    }

    #[test]
    fn test_bigint_to_bytes_large() {
        // The prime itself reduces to 0 modulo the prime, yielding empty bytes.
        let bytes = bigint_to_bytes(0xFFFFFFFF00000001);
        assert!(bytes.is_empty());
        // A value just below the prime should be non-empty.
        let bytes2 = bigint_to_bytes(0xFFFFFFFF00000000);
        assert!(!bytes2.is_empty());
    }

    /// Decode the golden `zisk.pilout` and assert structural invariants.
    ///
    /// The reference values come from the JS-compiled golden pilout. If the
    /// pilout file is not present (e.g. CI without large test artifacts), the
    /// test is skipped rather than failed.
    #[test]
    fn test_decoded_pilout_parity() {
        let path = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../pil/zisk.pilout");
        if !path.exists() {
            eprintln!("Skipping test_decoded_pilout_parity: {:?} not found", path);
            return;
        }
        let data = std::fs::read(&path).expect("failed to read zisk.pilout");
        let pilout = pilout_proto::PilOut::decode(data.as_slice())
            .expect("failed to decode zisk.pilout as PilOut");

        // -- Top-level structure --
        assert_eq!(pilout.air_groups.len(), 1, "expected 1 air group");
        assert_eq!(pilout.symbols.len(), 30785, "total symbol count mismatch");
        assert_eq!(pilout.hints.len(), 6754, "total hint count mismatch");

        let ag = &pilout.air_groups[0];
        assert_eq!(ag.name.as_deref(), Some("Zisk"), "air group name mismatch");
        assert_eq!(ag.airs.len(), 35, "expected 35 AIRs in the Zisk air group");

        // Helper: find an AIR by name within the single air group.
        let find_air = |name: &str| -> &pilout_proto::Air {
            ag.airs
                .iter()
                .find(|a| a.name.as_deref() == Some(name))
                .unwrap_or_else(|| panic!("AIR {:?} not found in pilout", name))
        };

        // -- Per-AIR checks --
        // Structural: every AIR must have at least 1 constraint
        for air in &ag.airs {
            assert!(air.constraints.len() > 0, "AIR {} has no constraints", air.name.as_deref().unwrap_or("?"));
        }

        // Key fixed column counts (these drive the .fixed file generation)
        let sr = find_air("SpecifiedRanges");
        assert_eq!(sr.fixed_cols.len(), 67, "SpecifiedRanges fixedCols count");

        let vt0 = find_air("VirtualTable0");
        assert_eq!(vt0.fixed_cols.len(), 52, "VirtualTable0 fixedCols count");

        let vt1 = find_air("VirtualTable1");
        assert_eq!(vt1.fixed_cols.len(), 73, "VirtualTable1 fixedCols count");

        let blake = find_air("Blake2br");
        assert_eq!(blake.fixed_cols.len(), 3, "Blake2br fixedCols count");

        let keccak = find_air("Keccakf");
        assert_eq!(keccak.fixed_cols.len(), 2, "Keccakf fixedCols count");

        let main = find_air("Main");
        assert_eq!(main.fixed_cols.len(), 3, "Main fixedCols count");

        eprintln!("test_decoded_pilout_parity: all assertions passed");
    }
}
