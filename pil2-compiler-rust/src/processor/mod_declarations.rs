//! Column / challenge / public / proofvalue / airgroupvalue / airvalue /
//! commit declarations extracted from processor/mod.rs to keep that
//! file under the project's code-size guideline.
//!
//! Methods are attached to `super::Processor` via a separate `impl`
//! block; functions carry `pub(super)` visibility so the parent
//! module continues to call them unchanged.

use crate::parser::ast::*;

use super::air;
use super::fixed_cols;
use super::ids::IdData;
use super::js_label_for_declaration;
use super::references::RefType;
use super::FlowSignal;
use super::Processor;

impl Processor {
// -----------------------------------------------------------------------
// Column declarations
// -----------------------------------------------------------------------

pub(super) fn exec_col_declaration(&mut self, cd: &ColDeclaration) -> FlowSignal {
    for item in &cd.items {
        let full_name = self.namespace_ctx.get_full_name(&item.name);
        // JS processor routes witness / customcol through
        // `this.declare(... fullName=true)` which still passes the
        // RAW `col.name` to `declareReference`; fixed / IM go
        // through `declareFullReference` which prepends the
        // namespace before calling `declareReference`. Mirror that
        // split here: pass full_name for fixed, raw for the rest.
        let label_input = match &cd.col_type {
            ColType::Fixed => full_name.as_str(),
            _ => item.name.as_str(),
        };
        let label = js_label_for_declaration(
            label_input,
            &self.namespace_ctx.air_group_name,
            self.references.inside_container(),
        );
        let array_dims: Vec<u32> = item
            .array_dims
            .iter()
            .filter_map(|d| {
                d.as_ref()
                    .and_then(|e| self.eval_expr(e).as_int().map(|v| v as u32))
            })
            .collect();
        let size: u32 = if array_dims.is_empty() {
            1
        } else {
            array_dims.iter().product()
        };

        let mut data = IdData {
            source_ref: self.source_ref.clone(),
            ..Default::default()
        };

        match &cd.col_type {
            ColType::Witness => {
                // Extract stage from features.
                let stage = cd
                    .features
                    .iter()
                    .find(|f| f.name == "stage")
                    .and_then(|f| {
                        f.args
                            .first()
                            .and_then(|a| self.eval_expr(&a.value).as_int().map(|v| v as u32))
                    });
                data.stage = stage;
                let id = self.witness_cols.reserve(
                    size,
                    Some(&label),
                    &array_dims,
                    data,
                );
                self.references.declare(
                    &label,
                    RefType::Witness,
                    id,
                    &array_dims,
                    false,
                    self.scope.deep,
                    &self.source_ref,
                );

                // Generate witness_bits hints for columns with bits(N)
                // or bits(N, signed) features (matching JS behavior).
                // One hint per declared column item (not per array element).
                if let Some(bits_feature) = cd.features.iter().find(|f| f.name == "bits") {
                    let bits_val = bits_feature.args.first()
                        .and_then(|a| self.eval_expr(&a.value).as_int());
                    if let Some(bits) = bits_val {
                        // Check for signed/unsigned option (2nd arg).
                        // The option is a bare identifier, not an
                        // expression, so extract the name from the AST
                        // directly rather than evaluating it.
                        let is_signed = bits_feature.args.get(1)
                            .map(|a| {
                                if let Expr::Reference(ref name_id) = a.value {
                                    name_id.path == "signed"
                                } else {
                                    false
                                }
                            })
                            .unwrap_or(false);
                        // Use the short name (after last dot), matching JS behavior.
                        let short_name = full_name.rfind('.')
                            .map(|pos| &full_name[pos + 1..])
                            .unwrap_or(&full_name)
                            .to_string();
                        let mut pairs = vec![
                            ("name".to_string(), air::HintValue::Str(short_name)),
                            ("bits".to_string(), air::HintValue::Int(bits)),
                        ];
                        if is_signed {
                            pairs.push(("signed".to_string(), air::HintValue::Int(1)));
                        }
                        self.air_hints.push(air::HintEntry {
                            name: "witness_bits".to_string(),
                            data: air::HintValue::Object(pairs),
                        });
                    }
                }
            }
            ColType::Fixed => {
                if self.pragmas_next_fixed.temporal {
                    data.temporal = true;
                    self.pragmas_next_fixed.temporal = false;
                }
                if self.pragmas_next_fixed.external {
                    data.external = true;
                    self.pragmas_next_fixed.external = false;
                }
                // `col fixed virtual(N) X` carries a `virtual`
                // col_feature. JS pil2-compiler skips virtual
                // fixed columns from the per-AIR const pols map
                // because their values are copied into concrete
                // columns at compile time via Tables.copy /
                // Tables.fill; the virtual column itself is a
                // pure helper declaration that should not surface
                // in pilout. Mirror that by setting
                // `temporal=true`, which already has the "drop
                // from pilout" semantics the proto emitter
                // requires.
                if cd.features.iter().any(|f| f.name == "virtual") {
                    data.temporal = true;
                }
                // Consume fixed_load pragma if set.
                let load_from_file = self.pragmas_next_fixed.load_from_file.take();

                let id = self.fixed_cols.reserve(
                    size,
                    Some(&label),
                    &array_dims,
                    data,
                );

                if let Some((file_path, col_idx)) = load_from_file {
                    // Load fixed column data from external binary file.
                    let num_rows = self
                        .ints
                        .get(
                            self.references
                                .get_reference("N")
                                .map(|r| r.id)
                                .unwrap_or(0),
                        )
                        .and_then(|v| v.as_int())
                        .unwrap_or(0) as u64;
                    if num_rows > 0 {
                        match fixed_cols::load_fixed_from_binary(
                            &file_path, col_idx, num_rows,
                        ) {
                            Ok(data) => {
                                self.fixed_cols.set_row_data(id, data);
                            }
                            Err(e) => {
                                eprintln!(
                                    "warning: failed to load fixed col from {}: {}",
                                    file_path, e
                                );
                            }
                        }
                    }
                } else {
                    // Evaluate initialization (sequence or expression).
                    let mut loaded_from_extern = false;
                    if cd.init.is_none() {
                        // No explicit init: try loading from extern fixed file.
                        loaded_from_extern = self.try_load_extern_fixed_col(
                            &full_name, id, &array_dims,
                        );
                    }
                    if !loaded_from_extern {
                        if let Some(init) = &cd.init {
                            match init {
                                ColInit::Sequence(seq) => {
                                    let num_rows = self
                                        .ints
                                        .get(
                                            self.references
                                                .get_reference("N")
                                                .map(|r| r.id)
                                                .unwrap_or(0),
                                        )
                                        .and_then(|v| v.as_int())
                                        .unwrap_or(0) as u64;
                                    if num_rows > 0 {
                                        let resolved = self.resolve_sequence(seq);
                                        let data =
                                            fixed_cols::evaluate_sequence(&resolved, num_rows);
                                        self.fixed_cols.set_row_data(id, data);
                                    }
                                }
                                ColInit::Expression(expr) => {
                                    let _val = self.eval_expr(expr);
                                    // Expression init for fixed columns.
                                }
                            }
                        }
                    }
                }

                self.references.declare(
                    &full_name,
                    RefType::Fixed,
                    id,
                    &array_dims,
                    false,
                    self.scope.deep,
                    &self.source_ref,
                );
            }
            ColType::Custom(commit_name) => {
                // Look up the commit_id for this commit name.
                let cid = self.commit_name_to_id.get(commit_name).copied();
                data.commit_id = cid;
                let id = self.custom_cols.reserve(
                    size,
                    Some(&label),
                    &array_dims,
                    data,
                );
                self.references.declare(
                    &full_name,
                    RefType::CustomCol,
                    id,
                    &array_dims,
                    false,
                    self.scope.deep,
                    &self.source_ref,
                );
            }
        }
    }
    FlowSignal::None
}

pub(super) fn exec_challenge_declaration(&mut self, cd: &ChallengeDeclaration) -> FlowSignal {
    for item in &cd.items {
        let name = &item.name;
        let id = self.challenges.reserve(
            1,
            Some(name),
            &[],
            IdData {
                source_ref: self.source_ref.clone(),
                stage: cd.stage.map(|s| s as u32),
                ..Default::default()
            },
        );
        self.references.declare(
            name,
            RefType::Challenge,
            id,
            &[],
            false,
            self.scope.deep,
            &self.source_ref,
        );
    }
    FlowSignal::None
}

pub(super) fn exec_public_declaration(&mut self, pd: &PublicDeclaration) -> FlowSignal {
    for item in &pd.items {
        let name = &item.name;
        let array_dims: Vec<u32> = item
            .array_dims
            .iter()
            .filter_map(|d| {
                d.as_ref()
                    .and_then(|e| self.eval_expr(e).as_int().map(|v| v as u32))
            })
            .collect();
        let size: u32 = if array_dims.is_empty() {
            1
        } else {
            array_dims.iter().product()
        };
        let id = self.publics.reserve(
            size,
            Some(name),
            &array_dims,
            IdData {
                source_ref: self.source_ref.clone(),
                ..Default::default()
            },
        );
        self.references.declare(
            name,
            RefType::Public,
            id,
            &array_dims,
            false,
            self.scope.deep,
            &self.source_ref,
        );
    }
    FlowSignal::None
}

pub(super) fn exec_proof_value_declaration(&mut self, pvd: &ProofValueDeclaration) -> FlowSignal {
    for item in &pvd.items {
        let name = &item.name;
        let id = self.proof_values.reserve(
            1,
            Some(name),
            &[],
            IdData {
                source_ref: self.source_ref.clone(),
                stage: pvd.stage.map(|s| s as u32),
                ..Default::default()
            },
        );
        self.references.declare(
            name,
            RefType::ProofValue,
            id,
            &[],
            false,
            self.scope.deep,
            &self.source_ref,
        );
    }
    FlowSignal::None
}

pub(super) fn exec_air_group_value_declaration(
    &mut self,
    agvd: &AirGroupValueDeclaration,
) -> FlowSignal {
    // Determine aggregate type: 0 = SUM, 1 = PROD.
    let agg_type = match agvd.aggregate_type.as_deref() {
        Some("prod") => 1i32,
        _ => 0i32, // default to SUM
    };
    // Default stage is 2 for air group values (matches JS compiler's
    // DEFAULT_AIR_GROUP_VALUE_STAGE = 2 in pil_parser.jison).
    let stage = agvd.stage.map(|s| s as u32).unwrap_or(2);

    for item in &agvd.items {
        let name = &item.name;

        // Deduplicate: if this AGV name already exists in the current
        // airgroup, reuse the existing reference (matching JS
        // AirGroup.declareAirGroupValue which skips re-declaration).
        if self.references.get_reference(name).is_some() {
            continue;
        }

        let id = self.air_group_values.reserve(
            1,
            Some(name),
            &[],
            IdData {
                source_ref: self.source_ref.clone(),
                stage: Some(stage),
                ..Default::default()
            },
        );
        self.references.declare(
            name,
            RefType::AirGroupValue,
            id,
            &[],
            false,
            self.scope.deep,
            &self.source_ref,
        );

        // Store metadata in the current airgroup for protobuf output.
        if let Some(ref ag_name) = self.current_air_group {
            let ag_name = ag_name.clone();
            if let Some(ag) = self.air_groups.get_mut(&ag_name) {
                ag.air_group_values.push((stage, agg_type));
            }
        }
    }
    FlowSignal::None
}

pub(super) fn exec_air_value_declaration(&mut self, avd: &AirValueDeclaration) -> FlowSignal {
    for item in &avd.items {
        let full_name = self.namespace_ctx.get_full_name(&item.name);
        let label = js_label_for_declaration(
            &item.name,
            &self.namespace_ctx.air_group_name,
            self.references.inside_container(),
        );
        // Evaluate each declared array dim into an integer size.
        // `airval im_direct[num_im]` -> array_dims = [num_im];
        // for a scalar `airval x;` array_dims is empty.
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
                                "warning: airvalue array dimension for '{}' evaluated to {:?} (not int), dropping dimension",
                                item.name, val
                            );
                            None
                        }
                    }
                })
            })
            .collect();
        let count: u32 = if array_dims.is_empty() {
            1
        } else {
            array_dims.iter().product()
        };
        let id = self.air_values.reserve(
            count,
            Some(&label),
            &array_dims,
            IdData {
                source_ref: self.source_ref.clone(),
                stage: avd.stage.map(|s| s as u32),
                ..Default::default()
            },
        );
        self.references.declare(
            &full_name,
            RefType::AirValue,
            id,
            &array_dims,
            false,
            self.scope.deep,
            &self.source_ref,
        );
    }
    FlowSignal::None
}

pub(super) fn exec_commit_declaration(&mut self, cd: &CommitDeclaration) -> FlowSignal {
    // Allocate a commit_id for this commit name if not already assigned.
    let commit_name = cd.name.clone();
    if !self.commit_name_to_id.contains_key(&commit_name) {
        let cid = self.next_commit_id;
        self.next_commit_id += 1;
        self.commit_name_to_id.insert(commit_name.clone(), cid);
    }

    // Resolve public column references and store their IDs.
    let mut pub_ids = Vec::new();
    for pub_name in &cd.publics {
        let reference_opt = self.references.get_reference(pub_name).cloned().or_else(|| {
            let names = self.namespace_ctx.get_names(pub_name);
            self.references.get_reference_multi(&names).cloned()
        });
        if let Some(reference) = reference_opt {
            if reference.ref_type == RefType::Public {
                let total = reference.total_size();
                for i in 0..total {
                    pub_ids.push(reference.id + i);
                }
            }
        }
    }
    if !pub_ids.is_empty() {
        self.commit_publics
            .entry(commit_name)
            .or_insert_with(Vec::new)
            .extend(pub_ids);
    }
    FlowSignal::None
}
}
