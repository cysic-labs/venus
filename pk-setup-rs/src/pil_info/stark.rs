use std::collections::{BTreeMap, BTreeSet};

use anyhow::{Context, Result};
use pilout_crate::pilout::{Air, AirGroupValue, CustomCommit, Hint, Symbol};
use serde::Serialize;

use crate::pil_info::analysis::{annotate_expression_id, annotate_expressions, calculate_exp_deg};
use crate::pil_info::format::{
    format_air_constraints, format_air_expressions, format_air_hints, format_air_symbols,
    AirFormatContext, FormattedConstraint, FormattedExpression, FormattedHint, FormattedSymbol,
    FIELD_EXTENSION,
};
use crate::stark_struct::StarkStruct;

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct StarkInfoJson {
    pub name: String,
    #[serde(rename = "airgroupId")]
    pub airgroup_id: u32,
    #[serde(rename = "airId")]
    pub air_id: u32,
    #[serde(rename = "starkStruct")]
    pub stark_struct: StarkStruct,
    #[serde(rename = "nPublics")]
    pub n_publics: usize,
    #[serde(rename = "nConstants")]
    pub n_constants: usize,
    #[serde(rename = "nStages")]
    pub n_stages: usize,
    #[serde(rename = "constPolsMap")]
    pub const_pols_map: Vec<PolMapJson>,
    #[serde(rename = "cmPolsMap")]
    pub cm_pols_map: Vec<PolMapJson>,
    #[serde(rename = "publicsMap")]
    pub publics_map: Vec<NamedMapJson>,
    #[serde(rename = "proofValuesMap")]
    pub proof_values_map: Vec<NamedMapJson>,
    #[serde(rename = "airgroupValuesMap")]
    pub airgroup_values_map: Vec<NamedMapJson>,
    #[serde(rename = "airValuesMap")]
    pub air_values_map: Vec<NamedMapJson>,
    #[serde(rename = "challengesMap")]
    pub challenges_map: Vec<ChallengeMapJson>,
    #[serde(rename = "customCommitsMap")]
    pub custom_commits_map: Vec<Vec<PolMapJson>>,
    #[serde(rename = "customCommits")]
    pub custom_commits: Vec<CustomCommitJson>,
    #[serde(rename = "openingPoints")]
    pub opening_points: Vec<i64>,
    pub boundaries: Vec<BoundaryJson>,
    #[serde(rename = "qDeg")]
    pub q_deg: u64,
    #[serde(rename = "qDim")]
    pub q_dim: u64,
    #[serde(rename = "cExpId")]
    pub c_exp_id: usize,
    #[serde(rename = "friExpId")]
    pub fri_exp_id: Option<usize>,
    #[serde(rename = "mapSectionsN")]
    pub map_sections_n: BTreeMap<String, u64>,
    #[serde(rename = "nConstraints")]
    pub n_constraints: usize,
    #[serde(rename = "evMap")]
    pub ev_map: Vec<serde_json::Value>,
    #[serde(rename = "airGroupValues")]
    pub air_group_values: Vec<AirGroupValueJson>,
    #[serde(rename = "nCommitmentsStage1")]
    pub n_commitments_stage1: usize,
}

#[derive(Debug, Serialize, Clone)]
pub struct PolMapJson {
    pub name: String,
    pub stage: u64,
    pub dim: u64,
    #[serde(rename = "polsMapId")]
    pub pols_map_id: u64,
    #[serde(rename = "stageId", skip_serializing_if = "Option::is_none")]
    pub stage_id: Option<u64>,
    #[serde(rename = "stagePos", skip_serializing_if = "Option::is_none")]
    pub stage_pos: Option<u64>,
    #[serde(skip_serializing_if = "Vec::is_empty")]
    pub lengths: Vec<u32>,
    #[serde(rename = "imPol", skip_serializing_if = "is_false")]
    pub im_pol: bool,
    #[serde(rename = "expId", skip_serializing_if = "Option::is_none")]
    pub exp_id: Option<u64>,
}

#[derive(Debug, Serialize, Clone)]
pub struct NamedMapJson {
    pub name: String,
    pub stage: u64,
    #[serde(skip_serializing_if = "Vec::is_empty")]
    pub lengths: Vec<u32>,
}

#[derive(Debug, Serialize, Clone)]
pub struct ChallengeMapJson {
    pub name: String,
    pub stage: u64,
    pub dim: u64,
    #[serde(rename = "stageId")]
    pub stage_id: u64,
}

#[derive(Debug, Serialize, Clone)]
pub struct BoundaryJson {
    pub name: String,
    #[serde(rename = "offsetMin", skip_serializing_if = "Option::is_none")]
    pub offset_min: Option<u32>,
    #[serde(rename = "offsetMax", skip_serializing_if = "Option::is_none")]
    pub offset_max: Option<u32>,
}

#[derive(Debug, Serialize, Clone)]
#[serde(rename_all = "camelCase")]
pub struct CustomCommitJson {
    pub name: String,
    pub stage_widths: Vec<u32>,
    pub public_values: Vec<PublicValueJson>,
}

#[derive(Debug, Serialize, Clone)]
pub struct PublicValueJson {
    pub idx: u32,
}

#[derive(Debug, Serialize, Clone)]
#[serde(rename_all = "camelCase")]
pub struct AirGroupValueJson {
    pub agg_type: i32,
    pub stage: u32,
}

pub struct AirStarkDraft {
    pub stark_info: StarkInfoJson,
    pub expressions: Vec<FormattedExpression>,
    pub constraints: Vec<FormattedConstraint>,
    pub symbols: Vec<FormattedSymbol>,
    pub hints: Vec<FormattedHint>,
}

pub struct AirInput<'a> {
    pub airgroup_id: u32,
    pub air_id: u32,
    pub airgroup_values: &'a [AirGroupValue],
    pub all_symbols: &'a [Symbol],
    pub all_hints: &'a [Hint],
    pub num_challenges: &'a [u32],
    pub air: &'a Air,
    pub stark_struct: StarkStruct,
}

pub fn build_air_stark_draft(input: AirInput<'_>) -> Result<AirStarkDraft> {
    let ctx = AirFormatContext {
        airgroup_id: input.airgroup_id,
        air_id: input.air_id,
        air: input.air,
        air_group_values: input.airgroup_values,
        all_symbols: input.all_symbols,
        all_hints: input.all_hints,
        num_challenges: input.num_challenges,
        global: false,
    };

    let mut expressions = format_air_expressions(&ctx)?;
    let mut constraints = format_air_constraints(&ctx)?;
    let mut symbols = format_air_symbols(&ctx)?;
    let hints = format_air_hints(&ctx, &expressions, &symbols)?;

    annotate_expressions(&mut expressions, &constraints)?;
    let mut boundaries =
        vec![BoundaryJson { name: "everyRow".to_string(), offset_min: None, offset_max: None }];
    let opening_points = collect_opening_points(&expressions, &constraints)?;
    let c_exp_id = generate_constraint_polynomial(
        &mut expressions,
        &mut constraints,
        &mut symbols,
        &mut boundaries,
    )?;

    let c_info = annotate_expression_id(&mut expressions, c_exp_id)?;
    let max_degree = calculate_exp_deg(&expressions, &expressions[c_exp_id], &[])?;
    let q_deg = max_degree.saturating_sub(1);
    let q_dim = c_info.dim;

    add_quotient_polynomials(
        &mut symbols,
        input.airgroup_id,
        input.air_id,
        input.num_challenges.len(),
        q_deg,
        q_dim,
    );
    let maps = map_symbols(
        &mut symbols,
        input.air.custom_commits.as_slice(),
        input.num_challenges.len() + 1,
    );

    let air_name = input.air.name.clone().context("air is missing name")?;
    let stark_info = StarkInfoJson {
        name: air_name,
        airgroup_id: input.airgroup_id,
        air_id: input.air_id,
        stark_struct: input.stark_struct,
        n_publics: maps.publics_map.len(),
        n_constants: maps.const_pols_map.len(),
        n_stages: input.num_challenges.len(),
        const_pols_map: maps.const_pols_map,
        cm_pols_map: maps.cm_pols_map,
        publics_map: maps.publics_map,
        proof_values_map: maps.proof_values_map,
        airgroup_values_map: maps.airgroup_values_map,
        air_values_map: maps.air_values_map,
        challenges_map: maps.challenges_map,
        custom_commits_map: maps.custom_commits_map,
        custom_commits: input.air.custom_commits.iter().map(format_custom_commit).collect(),
        opening_points,
        boundaries,
        q_deg,
        q_dim,
        c_exp_id,
        fri_exp_id: None,
        map_sections_n: maps.map_sections_n,
        n_constraints: constraints.len(),
        ev_map: Vec::new(),
        air_group_values: input.airgroup_values.iter().map(format_airgroup_value).collect(),
        n_commitments_stage1: symbols
            .iter()
            .filter(|symbol| {
                symbol.symbol_type == "witness" && symbol.stage == Some(1) && !symbol.im_pol
            })
            .count(),
    };

    Ok(AirStarkDraft { stark_info, expressions, constraints, symbols, hints })
}

fn generate_constraint_polynomial(
    expressions: &mut Vec<FormattedExpression>,
    constraints: &mut [FormattedConstraint],
    symbols: &mut Vec<FormattedSymbol>,
    boundaries: &mut Vec<BoundaryJson>,
) -> Result<usize> {
    let stage = symbols.iter().filter_map(|symbol| symbol.stage).max().unwrap_or(1) + 1;
    let vc_id = symbols
        .iter()
        .filter(|symbol| symbol.symbol_type == "challenge" && symbol.stage.unwrap_or(0) < stage)
        .count() as u64;
    symbols.push(FormattedSymbol {
        name: "std_vc".to_string(),
        symbol_type: "challenge".to_string(),
        pol_id: None,
        id: Some(vc_id),
        stage: Some(stage),
        stage_id: Some(0),
        dim: FIELD_EXTENSION,
        airgroup_id: None,
        air_id: None,
        commit_id: None,
        lengths: Vec::new(),
        stage_pos: None,
        exp_id: None,
        im_pol: false,
    });

    let vc = challenge("std_vc", stage, 0, vc_id);
    let mut c_exp_id = None;

    for constraint in constraints.iter() {
        let mut constraint_expr = exp_ref(constraint.e, stage);
        let mut constraint_id = constraint.e as usize;
        if constraint.boundary == "everyFrame" {
            let boundary_id = find_or_add_boundary(
                boundaries,
                BoundaryJson {
                    name: "everyFrame".to_string(),
                    offset_min: constraint.offset_min,
                    offset_max: constraint.offset_max,
                },
            );
            constraint_expr = FormattedExpression::binary("mul", constraint_expr, zi(boundary_id));
            expressions.push(constraint_expr);
            constraint_id = expressions.len() - 1;
        } else if constraint.boundary != "everyRow" {
            let boundary_id = find_or_add_boundary(
                boundaries,
                BoundaryJson {
                    name: constraint.boundary.clone(),
                    offset_min: None,
                    offset_max: None,
                },
            );
            constraint_expr = FormattedExpression::binary("mul", constraint_expr, zi(boundary_id));
            expressions.push(constraint_expr);
            constraint_id = expressions.len() - 1;
        }

        if let Some(previous_id) = c_exp_id {
            let weighted =
                FormattedExpression::binary("mul", vc.clone(), exp_ref(previous_id as u64, stage));
            expressions.push(weighted);
            let weighted_id = expressions.len() - 1;
            let accumulated = FormattedExpression::binary(
                "add",
                exp_ref(weighted_id as u64, stage),
                exp_ref(constraint_id as u64, stage),
            );
            expressions.push(accumulated);
            c_exp_id = Some(expressions.len() - 1);
        } else {
            c_exp_id = Some(constraint_id);
        }
    }

    c_exp_id.context("AIR has no constraints")
}

fn add_quotient_polynomials(
    symbols: &mut Vec<FormattedSymbol>,
    airgroup_id: u32,
    air_id: u32,
    n_stages: usize,
    q_deg: u64,
    q_dim: u64,
) {
    let stage = n_stages as u64 + 1;
    let mut next_pol_id = symbols
        .iter()
        .filter(|symbol| symbol.symbol_type == "witness")
        .filter_map(|symbol| symbol.pol_id)
        .max()
        .map_or(0, |id| id + 1);
    for idx in 0..q_deg {
        symbols.push(FormattedSymbol {
            name: format!("Q{idx}"),
            symbol_type: "witness".to_string(),
            pol_id: Some(next_pol_id),
            id: None,
            stage: Some(stage),
            stage_id: Some(idx),
            dim: q_dim,
            airgroup_id: Some(airgroup_id as u64),
            air_id: Some(air_id as u64),
            commit_id: None,
            lengths: Vec::new(),
            stage_pos: None,
            exp_id: None,
            im_pol: false,
        });
        next_pol_id += 1;
    }
}

#[derive(Default)]
struct SymbolMaps {
    const_pols_map: Vec<PolMapJson>,
    cm_pols_map: Vec<PolMapJson>,
    publics_map: Vec<NamedMapJson>,
    proof_values_map: Vec<NamedMapJson>,
    airgroup_values_map: Vec<NamedMapJson>,
    air_values_map: Vec<NamedMapJson>,
    challenges_map: Vec<ChallengeMapJson>,
    custom_commits_map: Vec<Vec<PolMapJson>>,
    map_sections_n: BTreeMap<String, u64>,
}

fn map_symbols(
    symbols: &mut [FormattedSymbol],
    custom_commits: &[CustomCommit],
    q_stage: usize,
) -> SymbolMaps {
    let mut maps = SymbolMaps::default();
    maps.map_sections_n.insert("const".to_string(), 0);
    for stage in 1..=q_stage {
        maps.map_sections_n.insert(format!("cm{stage}"), 0);
    }
    maps.custom_commits_map = vec![Vec::new(); custom_commits.len()];
    for commit in custom_commits {
        for (stage, width) in commit.stage_widths.iter().enumerate() {
            if *width > 0 {
                maps.map_sections_n
                    .insert(format!("{}{}", commit.name.as_deref().unwrap_or("custom"), stage), 0);
            }
        }
    }

    for idx in 0..symbols.len() {
        let symbol = symbols[idx].clone();
        match symbol.symbol_type.as_str() {
            "fixed" | "witness" | "custom" => add_pol(&mut maps, &symbol),
            "challenge" => set_sparse(
                &mut maps.challenges_map,
                symbol.id.unwrap_or(0) as usize,
                ChallengeMapJson {
                    name: symbol.name,
                    stage: symbol.stage.unwrap_or(1),
                    dim: symbol.dim,
                    stage_id: symbol.stage_id.unwrap_or(0),
                },
            ),
            "public" => set_sparse(
                &mut maps.publics_map,
                symbol.id.unwrap_or(0) as usize,
                NamedMapJson {
                    name: symbol.name,
                    stage: symbol.stage.unwrap_or(1),
                    lengths: symbol.lengths,
                },
            ),
            "proofvalue" => set_sparse(
                &mut maps.proof_values_map,
                symbol.id.unwrap_or(0) as usize,
                NamedMapJson {
                    name: symbol.name,
                    stage: symbol.stage.unwrap_or(1),
                    lengths: symbol.lengths,
                },
            ),
            "airgroupvalue" => set_sparse(
                &mut maps.airgroup_values_map,
                symbol.id.unwrap_or(0) as usize,
                NamedMapJson {
                    name: symbol.name,
                    stage: symbol.stage.unwrap_or(1),
                    lengths: symbol.lengths,
                },
            ),
            "airvalue" => set_sparse(
                &mut maps.air_values_map,
                symbol.id.unwrap_or(0) as usize,
                NamedMapJson {
                    name: symbol.name,
                    stage: symbol.stage.unwrap_or(1),
                    lengths: symbol.lengths,
                },
            ),
            _ => {}
        }
    }

    set_stage_positions(&mut maps.cm_pols_map);
    for commit_map in &mut maps.custom_commits_map {
        set_stage_positions(commit_map);
    }

    maps
}

fn add_pol(maps: &mut SymbolMaps, symbol: &FormattedSymbol) {
    let pol_id = symbol.pol_id.unwrap_or(0);
    let stage = symbol.stage.unwrap_or(0);
    let pol = PolMapJson {
        name: symbol.name.clone(),
        stage,
        dim: symbol.dim,
        pols_map_id: pol_id,
        stage_id: symbol.stage_id,
        stage_pos: None,
        lengths: symbol.lengths.clone(),
        im_pol: symbol.im_pol,
        exp_id: symbol.exp_id,
    };
    match symbol.symbol_type.as_str() {
        "fixed" => {
            set_sparse(&mut maps.const_pols_map, pol_id as usize, pol);
            *maps.map_sections_n.entry("const".to_string()).or_default() += symbol.dim;
        }
        "witness" => {
            set_sparse(&mut maps.cm_pols_map, pol_id as usize, pol);
            *maps.map_sections_n.entry(format!("cm{stage}")).or_default() += symbol.dim;
        }
        "custom" => {
            let commit_id = symbol.commit_id.unwrap_or(0) as usize;
            if maps.custom_commits_map.len() <= commit_id {
                maps.custom_commits_map.resize_with(commit_id + 1, Vec::new);
            }
            set_sparse(&mut maps.custom_commits_map[commit_id], pol_id as usize, pol);
            *maps.map_sections_n.entry(format!("custom{commit_id}{stage}")).or_default() +=
                symbol.dim;
        }
        _ => {}
    }
}

fn set_stage_positions(pols: &mut [PolMapJson]) {
    let mut offsets = BTreeMap::<u64, u64>::new();
    for pol in pols.iter_mut() {
        let offset = offsets.entry(pol.stage).or_default();
        pol.stage_pos = Some(*offset);
        *offset += pol.dim;
    }
}

fn set_sparse<T: Clone + Default>(values: &mut Vec<T>, idx: usize, value: T) {
    if values.len() <= idx {
        values.resize(idx + 1, T::default());
    }
    values[idx] = value;
}

impl Default for PolMapJson {
    fn default() -> Self {
        Self {
            name: String::new(),
            stage: 0,
            dim: 0,
            pols_map_id: 0,
            stage_id: None,
            stage_pos: None,
            lengths: Vec::new(),
            im_pol: false,
            exp_id: None,
        }
    }
}

impl Default for NamedMapJson {
    fn default() -> Self {
        Self { name: String::new(), stage: 0, lengths: Vec::new() }
    }
}

impl Default for ChallengeMapJson {
    fn default() -> Self {
        Self { name: String::new(), stage: 0, dim: 0, stage_id: 0 }
    }
}

fn collect_opening_points(
    expressions: &[FormattedExpression],
    constraints: &[FormattedConstraint],
) -> Result<Vec<i64>> {
    let mut offsets = BTreeSet::new();
    for constraint in constraints {
        let expression = expressions
            .get(constraint.e as usize)
            .with_context(|| format!("constraint expression {} not found", constraint.e))?;
        if let Some(rows_offsets) = &expression.rows_offsets {
            offsets.extend(rows_offsets.iter().copied());
        } else {
            offsets.insert(0);
        }
    }
    Ok(offsets.into_iter().collect())
}

fn find_or_add_boundary(boundaries: &mut Vec<BoundaryJson>, boundary: BoundaryJson) -> u64 {
    if let Some(idx) = boundaries.iter().position(|candidate| {
        candidate.name == boundary.name
            && candidate.offset_min == boundary.offset_min
            && candidate.offset_max == boundary.offset_max
    }) {
        idx as u64
    } else {
        boundaries.push(boundary);
        (boundaries.len() - 1) as u64
    }
}

fn exp_ref(id: u64, stage: u64) -> FormattedExpression {
    let mut expr = FormattedExpression::new("exp");
    expr.id = Some(id);
    expr.row_offset = Some(0);
    expr.stage = Some(stage);
    expr
}

fn challenge(name: &str, stage: u64, stage_id: u64, id: u64) -> FormattedExpression {
    let mut expr = FormattedExpression::new("challenge");
    expr.name = Some(name.to_string());
    expr.stage = Some(stage);
    expr.stage_id = Some(stage_id);
    expr.id = Some(id);
    expr.dim = Some(FIELD_EXTENSION);
    expr
}

fn zi(boundary_id: u64) -> FormattedExpression {
    let mut expr = FormattedExpression::new("Zi");
    expr.boundary_id = Some(boundary_id);
    expr
}

fn format_custom_commit(commit: &CustomCommit) -> CustomCommitJson {
    CustomCommitJson {
        name: commit.name.clone().unwrap_or_default(),
        stage_widths: commit.stage_widths.clone(),
        public_values: commit
            .public_values
            .iter()
            .map(|value| PublicValueJson { idx: value.idx })
            .collect(),
    }
}

fn format_airgroup_value(value: &AirGroupValue) -> AirGroupValueJson {
    AirGroupValueJson { agg_type: value.agg_type, stage: value.stage }
}

fn is_false(value: &bool) -> bool {
    !*value
}
