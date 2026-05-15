use std::collections::{BTreeMap, BTreeSet, HashMap};

use anyhow::{Context, Result};
use pilout_crate::pilout::{Air, AirGroupValue, CustomCommit, Hint, Symbol};
use serde::Serialize;

use crate::pil_info::analysis::{annotate_expression_id, annotate_expressions, calculate_exp_deg};
use crate::pil_info::format::{
    format_air_constraints, format_air_expressions, format_air_hints, format_air_symbols,
    AirFormatContext, FormattedConstraint, FormattedExpression, FormattedHint, FormattedSymbol,
    FIELD_EXTENSION,
};
use crate::stark_struct::{apply_security_estimate, SecurityEstimate, StarkStruct};

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
    pub ev_map: Vec<EvMapJson>,
    #[serde(rename = "airGroupValues")]
    pub air_group_values: Vec<AirGroupValueJson>,
    #[serde(rename = "nCommitmentsStage1")]
    pub n_commitments_stage1: usize,
    pub security: SecurityInfoJson,
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

#[derive(Debug, Serialize, Clone, PartialEq, Eq)]
pub struct EvMapJson {
    #[serde(rename = "type")]
    pub ev_type: String,
    pub id: u64,
    pub prime: i64,
    #[serde(rename = "openingPos")]
    pub opening_pos: usize,
    #[serde(rename = "commitId", skip_serializing_if = "Option::is_none")]
    pub commit_id: Option<u64>,
}

#[derive(Debug, Serialize, Clone, Copy)]
#[serde(rename_all = "camelCase")]
pub struct SecurityInfoJson {
    pub proximity_parameter: f64,
    pub proximity_gap: f64,
    pub regime: &'static str,
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
    set_constraint_stages(&expressions, &mut constraints)?;
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
    let max_q_degree = (1u64 << (input.stark_struct.n_bits_ext - input.stark_struct.n_bits)) + 1;
    let (c_exp_id, q_deg, q_dim) = add_intermediate_polynomials(
        &mut expressions,
        &mut constraints,
        &mut symbols,
        c_exp_id,
        max_degree,
        max_q_degree,
        c_info.dim,
        input.num_challenges.len(),
        input.airgroup_id,
        input.air_id,
        input.air.name.as_deref().unwrap_or("Air"),
    )?;
    let c_exp_id = wrap_constraint_polynomial(&mut expressions, c_exp_id, &boundaries)?;
    annotate_expression_id(&mut expressions, c_exp_id)?;

    add_quotient_polynomials(
        &mut symbols,
        input.airgroup_id,
        input.air_id,
        input.num_challenges.len(),
        q_deg,
        q_dim,
    );
    add_xi_challenge(&mut symbols, input.num_challenges.len() + 2);
    let mut maps = map_symbols(
        &mut symbols,
        input.air.custom_commits.as_slice(),
        input.num_challenges.len() + 1,
    );
    let ev_map = build_ev_map(&expressions, &maps, c_exp_id, q_deg, &opening_points)?;
    let fri_exp_id = generate_fri_polynomial(
        &mut expressions,
        &mut symbols,
        &mut maps.challenges_map,
        &ev_map,
        &opening_points,
        input.num_challenges.len() + 3,
    )?;
    annotate_expression_id(&mut expressions, fri_exp_id)?;
    maps = map_symbols(
        &mut symbols,
        input.air.custom_commits.as_slice(),
        input.num_challenges.len() + 1,
    );

    let mut stark_struct = input.stark_struct;
    let security = format_security_estimate(apply_security_estimate(
        &mut stark_struct,
        opening_points.len(),
        constraints.len(),
        ev_map.len(),
        q_deg + 1,
    ));

    let air_name = input.air.name.clone().context("air is missing name")?;
    let stark_info = StarkInfoJson {
        name: air_name,
        airgroup_id: input.airgroup_id,
        air_id: input.air_id,
        stark_struct,
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
        fri_exp_id: Some(fri_exp_id),
        map_sections_n: maps.map_sections_n,
        n_constraints: constraints.len(),
        ev_map,
        air_group_values: input.airgroup_values.iter().map(format_airgroup_value).collect(),
        n_commitments_stage1: symbols
            .iter()
            .filter(|symbol| {
                symbol.symbol_type == "witness" && symbol.stage == Some(1) && !symbol.im_pol
            })
            .count(),
        security,
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

fn set_constraint_stages(
    expressions: &[FormattedExpression],
    constraints: &mut [FormattedConstraint],
) -> Result<()> {
    for constraint in constraints {
        let expression = expressions
            .get(constraint.e as usize)
            .with_context(|| format!("constraint expression {} not found", constraint.e))?;
        constraint.stage = expression.stage;
    }
    Ok(())
}

#[allow(clippy::too_many_arguments)]
fn add_intermediate_polynomials(
    expressions: &mut Vec<FormattedExpression>,
    constraints: &mut Vec<FormattedConstraint>,
    symbols: &mut Vec<FormattedSymbol>,
    c_exp_id: usize,
    max_degree: u64,
    max_q_degree: u64,
    q_dim: u64,
    n_stages: usize,
    airgroup_id: u32,
    air_id: u32,
    air_name: &str,
) -> Result<(usize, u64, u64)> {
    if max_degree < max_q_degree || (max_degree == max_q_degree && expressions.len() > 1_000) {
        return Ok((c_exp_id, max_degree.saturating_sub(1), q_dim));
    }

    let (im_exps, q_deg) =
        calculate_intermediate_polynomials(expressions, c_exp_id, max_q_degree, q_dim)?;
    if im_exps.is_empty() {
        return Ok((c_exp_id, q_deg.min(max_degree.saturating_sub(1)), q_dim));
    }

    let stage = n_stages as u64 + 1;
    let im_stage = n_stages as u64;
    let vc_id = symbols
        .iter()
        .filter(|symbol| symbol.symbol_type == "challenge" && symbol.stage.unwrap_or(0) < stage)
        .count() as u64;
    let vc = challenge("std_vc", stage, 0, vc_id);
    let mut current_c_exp_id = c_exp_id;
    let mut next_pol_id = symbols
        .iter()
        .filter(|symbol| symbol.symbol_type == "witness")
        .filter_map(|symbol| symbol.pol_id)
        .max()
        .map_or(0, |id| id + 1);

    for exp_id in im_exps {
        let dim = expressions.get(exp_id).and_then(|expression| expression.dim).unwrap_or(1);
        let stage_id = symbols
            .iter()
            .filter(|symbol| symbol.symbol_type == "witness" && symbol.stage == Some(im_stage))
            .count() as u64;
        let pol_id = next_pol_id;
        next_pol_id += 1;

        symbols.push(FormattedSymbol {
            name: format!("{air_name}.ImPol"),
            symbol_type: "witness".to_string(),
            pol_id: Some(pol_id),
            id: None,
            stage: Some(im_stage),
            stage_id: Some(stage_id),
            dim,
            airgroup_id: Some(airgroup_id as u64),
            air_id: Some(air_id as u64),
            commit_id: None,
            lengths: Vec::new(),
            stage_pos: None,
            exp_id: Some(exp_id as u64),
            im_pol: true,
        });

        let expression = expressions
            .get_mut(exp_id)
            .with_context(|| format!("intermediate expression {exp_id} not found"))?;
        expression.im_pol = true;
        expression.pol_id = Some(pol_id);
        expression.stage = Some(im_stage);

        let constraint_expr = FormattedExpression::binary(
            "sub",
            cm_ref(pol_id, im_stage, dim),
            exp_ref_no_commit(exp_id as u64, im_stage),
        );
        expressions.push(constraint_expr);
        let constraint_id = expressions.len() - 1;
        annotate_expression_id(expressions, constraint_id)?;
        constraints.push(FormattedConstraint {
            boundary: "everyRow".to_string(),
            e: constraint_id as u64,
            line: None,
            im_pol: true,
            stage: Some(im_stage),
            offset_min: None,
            offset_max: None,
        });

        let weighted =
            FormattedExpression::binary("mul", vc.clone(), exp_ref(current_c_exp_id as u64, stage));
        expressions.push(weighted);
        let weighted_id = expressions.len() - 1;
        annotate_expression_id(expressions, weighted_id)?;
        let accumulated = FormattedExpression::binary(
            "add",
            exp_ref(weighted_id as u64, stage),
            exp_ref(constraint_id as u64, stage),
        );
        expressions.push(accumulated);
        current_c_exp_id = expressions.len() - 1;
        annotate_expression_id(expressions, current_c_exp_id)?;
    }

    let info = annotate_expression_id(expressions, current_c_exp_id)?;
    Ok((current_c_exp_id, q_deg, info.dim))
}

fn calculate_intermediate_polynomials(
    expressions: &[FormattedExpression],
    c_exp_id: usize,
    max_q_degree: u64,
    q_dim: u64,
) -> Result<(Vec<usize>, u64)> {
    let c_exp = expressions
        .get(c_exp_id)
        .with_context(|| format!("constraint expression {c_exp_id} not found"))?;
    let mut candidate_degree = 2;
    let (mut im_exps, mut q_deg) = calculate_im_pols(expressions, c_exp, candidate_degree)?;
    let mut added_cols = calculate_added_cols(expressions, &im_exps, q_deg, q_dim);
    candidate_degree += 1;

    while !im_exps.is_empty() && candidate_degree <= max_q_degree {
        let (candidate_im_exps, candidate_q_deg) =
            calculate_im_pols(expressions, c_exp, candidate_degree)?;
        let candidate_added_cols =
            calculate_added_cols(expressions, &candidate_im_exps, candidate_q_deg, q_dim);
        if candidate_added_cols < added_cols {
            added_cols = candidate_added_cols;
            im_exps = candidate_im_exps;
            q_deg = candidate_q_deg;
        }
        if im_exps.is_empty() {
            break;
        }
        candidate_degree += 1;
    }

    Ok((im_exps, q_deg))
}

fn calculate_added_cols(
    expressions: &[FormattedExpression],
    im_exps: &[usize],
    q_deg: u64,
    q_dim: u64,
) -> u64 {
    let q_cols = q_deg * q_dim;
    let im_cols = im_exps
        .iter()
        .map(|exp_id| expressions.get(*exp_id).and_then(|expression| expression.dim).unwrap_or(1))
        .sum::<u64>();
    q_cols + im_cols
}

fn calculate_im_pols(
    expressions: &[FormattedExpression],
    expression: &FormattedExpression,
    max_degree: u64,
) -> Result<(Vec<usize>, u64)> {
    let mut absolute_max_degree = 0;
    let mut memo = ImPolMemo::default();
    let result = calculate_im_pols_inner(
        expressions,
        expression,
        Vec::new(),
        max_degree,
        max_degree,
        &mut absolute_max_degree,
        &mut memo,
    )?
    .context("failed to calculate intermediate polynomials")?;
    Ok((result.0, result.1.max(absolute_max_degree).saturating_sub(1)))
}

type ImPolMemo = HashMap<(usize, u64, Vec<usize>), Option<(Vec<usize>, u64)>>;

fn calculate_im_pols_inner(
    expressions: &[FormattedExpression],
    expression: &FormattedExpression,
    im_pols: Vec<usize>,
    max_degree: u64,
    absolute_max_degree: u64,
    observed_absolute_max: &mut u64,
    memo: &mut ImPolMemo,
) -> Result<Option<(Vec<usize>, u64)>> {
    match expression.op.as_str() {
        "add" | "sub" => {
            let mut current = im_pols;
            let mut max_child_degree = 0;
            for value in &expression.values {
                let Some((next, degree)) = calculate_im_pols_inner(
                    expressions,
                    value,
                    current,
                    max_degree,
                    absolute_max_degree,
                    observed_absolute_max,
                    memo,
                )?
                else {
                    return Ok(None);
                };
                current = next;
                max_child_degree = max_child_degree.max(degree);
            }
            Ok(Some((current, max_child_degree)))
        }
        "mul" => {
            let lhs = expression.values.first().context("mul expression is missing lhs")?;
            let rhs = expression.values.get(1).context("mul expression is missing rhs")?;
            if !is_compound_or_exp(lhs) && expression_degree(expressions, lhs)? == 0 {
                return calculate_im_pols_inner(
                    expressions,
                    rhs,
                    im_pols,
                    max_degree,
                    absolute_max_degree,
                    observed_absolute_max,
                    memo,
                );
            }
            if !is_compound_or_exp(rhs) && expression_degree(expressions, rhs)? == 0 {
                return calculate_im_pols_inner(
                    expressions,
                    lhs,
                    im_pols,
                    max_degree,
                    absolute_max_degree,
                    observed_absolute_max,
                    memo,
                );
            }

            let degree_here = expression_degree(expressions, expression)?;
            if degree_here <= max_degree {
                return Ok(Some((im_pols, degree_here)));
            }

            let mut best: Option<(Vec<usize>, u64)> = None;
            for lhs_degree in 0..=max_degree {
                let rhs_degree = max_degree - lhs_degree;
                let Some((lhs_im_pols, lhs_result_degree)) = calculate_im_pols_inner(
                    expressions,
                    lhs,
                    im_pols.clone(),
                    lhs_degree,
                    absolute_max_degree,
                    observed_absolute_max,
                    memo,
                )?
                else {
                    continue;
                };
                let Some((rhs_im_pols, rhs_result_degree)) = calculate_im_pols_inner(
                    expressions,
                    rhs,
                    lhs_im_pols,
                    rhs_degree,
                    absolute_max_degree,
                    observed_absolute_max,
                    memo,
                )?
                else {
                    continue;
                };
                let result_degree = lhs_result_degree + rhs_result_degree;
                if best
                    .as_ref()
                    .is_none_or(|(best_im_pols, _)| rhs_im_pols.len() < best_im_pols.len())
                {
                    best = Some((rhs_im_pols, result_degree));
                }
                if best
                    .as_ref()
                    .is_some_and(|(best_im_pols, _)| best_im_pols.len() == im_pols.len())
                {
                    break;
                }
            }
            Ok(best)
        }
        "exp" => {
            if max_degree < 1 {
                return Ok(None);
            }
            let id = expression.id.context("exp expression is missing id")? as usize;
            if im_pols.contains(&id) {
                return Ok(Some((im_pols, 1)));
            }
            let key = (id, absolute_max_degree, im_pols.clone());
            let candidate = if let Some(cached) = memo.get(&key) {
                cached.clone()
            } else {
                let calculated = calculate_im_pols_inner(
                    expressions,
                    expressions.get(id).with_context(|| format!("expression {id} not found"))?,
                    im_pols,
                    absolute_max_degree,
                    absolute_max_degree,
                    observed_absolute_max,
                    memo,
                )?;
                memo.insert(key, calculated.clone());
                calculated
            };
            let Some((mut candidate_im_pols, degree)) = candidate else {
                return Ok(None);
            };
            if degree > max_degree {
                *observed_absolute_max = (*observed_absolute_max).max(degree);
                if !candidate_im_pols.contains(&id) {
                    candidate_im_pols.push(id);
                }
                Ok(Some((candidate_im_pols, 1)))
            } else {
                Ok(Some((candidate_im_pols, degree)))
            }
        }
        _ => {
            let degree = expression_degree(expressions, expression)?;
            if degree == 0 {
                Ok(Some((im_pols, 0)))
            } else if max_degree < 1 {
                Ok(None)
            } else {
                Ok(Some((im_pols, 1)))
            }
        }
    }
}

fn is_compound_or_exp(expression: &FormattedExpression) -> bool {
    matches!(expression.op.as_str(), "add" | "sub" | "mul" | "exp")
}

fn expression_degree(
    expressions: &[FormattedExpression],
    expression: &FormattedExpression,
) -> Result<u64> {
    if let Some(exp_deg) = expression.exp_deg {
        return Ok(exp_deg);
    }
    calculate_exp_deg(expressions, expression, &[])
}

fn wrap_constraint_polynomial(
    expressions: &mut Vec<FormattedExpression>,
    c_exp_id: usize,
    boundaries: &[BoundaryJson],
) -> Result<usize> {
    let every_row = boundaries
        .iter()
        .position(|boundary| boundary.name == "everyRow")
        .context("everyRow boundary not found")? as u64;
    let stage = expressions.get(c_exp_id).and_then(|expr| expr.stage).unwrap_or(0);
    let wrapped =
        FormattedExpression::binary("mul", exp_ref(c_exp_id as u64, stage), zi(every_row));
    expressions.push(wrapped);
    Ok(expressions.len() - 1)
}

fn add_xi_challenge(symbols: &mut Vec<FormattedSymbol>, stage: usize) {
    let stage = stage as u64;
    let xi_id = symbols
        .iter()
        .filter(|symbol| symbol.symbol_type == "challenge" && symbol.stage.unwrap_or(0) < stage)
        .count() as u64;
    symbols.push(FormattedSymbol {
        name: "std_xi".to_string(),
        symbol_type: "challenge".to_string(),
        pol_id: None,
        id: Some(xi_id),
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
}

fn build_ev_map(
    expressions: &[FormattedExpression],
    maps: &SymbolMaps,
    c_exp_id: usize,
    q_deg: u64,
    opening_points: &[i64],
) -> Result<Vec<EvMapJson>> {
    let mut ev_map = Vec::new();
    let mut visited_expressions = BTreeSet::new();
    let mut stack = vec![expressions
        .get(c_exp_id)
        .with_context(|| format!("constraint expression {c_exp_id} not found"))?];

    while let Some(expression) = stack.pop() {
        match expression.op.as_str() {
            "exp" => {
                let id = expression.id.context("exp expression is missing id")? as usize;
                if visited_expressions.insert(id) {
                    stack.push(
                        expressions
                            .get(id)
                            .with_context(|| format!("expression {id} not found"))?,
                    );
                }
            }
            "cm" | "const" | "custom" => {
                let prime = expression.row_offset.unwrap_or(0);
                let opening_pos = opening_points
                    .iter()
                    .position(|opening| *opening == prime)
                    .with_context(|| format!("opening point {prime} not found"))?;
                let item = EvMapJson {
                    ev_type: if expression.op == "const" {
                        "const".to_string()
                    } else if expression.op == "custom" {
                        "custom".to_string()
                    } else {
                        "cm".to_string()
                    },
                    id: expression.id.context("evaluation expression is missing id")?,
                    prime,
                    opening_pos,
                    commit_id: expression.commit_id,
                };
                if !ev_map.contains(&item) {
                    ev_map.push(item);
                }
            }
            "add" | "sub" | "mul" | "neg" => stack.extend(expression.values.iter()),
            _ => {}
        }
    }

    let q_index = maps
        .cm_pols_map
        .iter()
        .position(|pol| pol.name == "Q0" && pol.stage_id == Some(0))
        .or_else(|| {
            maps.cm_pols_map.iter().position(|pol| {
                pol.stage == (maps.challenges_map.len().saturating_sub(1)) as u64
                    && pol.stage_id == Some(0)
            })
        })
        .context("quotient polynomial Q0 not found")? as u64;
    let opening_pos = opening_points.iter().position(|opening| *opening == 0).unwrap_or(0);
    for idx in 0..q_deg {
        ev_map.push(EvMapJson {
            ev_type: "cm".to_string(),
            id: q_index + idx,
            prime: 0,
            opening_pos,
            commit_id: None,
        });
    }

    ev_map.sort_by(|lhs, rhs| {
        lhs.opening_pos
            .cmp(&rhs.opening_pos)
            .then_with(|| type_order(rhs).cmp(&type_order(lhs)))
            .then_with(|| lhs.id.cmp(&rhs.id))
            .then_with(|| lhs.prime.cmp(&rhs.prime))
    });
    Ok(ev_map)
}

fn type_order(ev: &EvMapJson) -> u64 {
    match ev.ev_type.as_str() {
        "cm" => 0,
        "const" => 1,
        "custom" => ev.commit_id.unwrap_or(0) + 2,
        _ => 0,
    }
}

fn generate_fri_polynomial(
    expressions: &mut Vec<FormattedExpression>,
    symbols: &mut Vec<FormattedSymbol>,
    challenges_map: &mut Vec<ChallengeMapJson>,
    ev_map: &[EvMapJson],
    opening_points: &[i64],
    stage: usize,
) -> Result<usize> {
    let stage = stage as u64;
    let vf1_id = symbols
        .iter()
        .filter(|symbol| symbol.symbol_type == "challenge" && symbol.stage.unwrap_or(0) < stage)
        .count() as u64;
    let vf2_id = vf1_id + 1;
    let vf1_symbol = FormattedSymbol {
        name: "std_vf1".to_string(),
        symbol_type: "challenge".to_string(),
        pol_id: None,
        id: Some(vf1_id),
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
    };
    let vf2_symbol = FormattedSymbol {
        name: "std_vf2".to_string(),
        symbol_type: "challenge".to_string(),
        pol_id: None,
        id: Some(vf2_id),
        stage: Some(stage),
        stage_id: Some(1),
        dim: FIELD_EXTENSION,
        airgroup_id: None,
        air_id: None,
        commit_id: None,
        lengths: Vec::new(),
        stage_pos: None,
        exp_id: None,
        im_pol: false,
    };
    set_sparse(
        challenges_map,
        vf1_id as usize,
        ChallengeMapJson {
            name: vf1_symbol.name.clone(),
            stage,
            dim: FIELD_EXTENSION,
            stage_id: 0,
        },
    );
    set_sparse(
        challenges_map,
        vf2_id as usize,
        ChallengeMapJson {
            name: vf2_symbol.name.clone(),
            stage,
            dim: FIELD_EXTENSION,
            stage_id: 1,
        },
    );
    symbols.push(vf1_symbol);
    symbols.push(vf2_symbol);

    let vf1 = challenge("std_vf1", stage, 0, vf1_id);
    let vf2 = challenge("std_vf2", stage, 1, vf2_id);
    let mut fri_by_opening = BTreeMap::<i64, usize>::new();

    for (idx, ev) in ev_map.iter().enumerate() {
        let symbol = find_eval_symbol(symbols, ev).with_context(|| {
            format!("symbol for evMap entry {}:{} not found", ev.ev_type, ev.id)
        })?;
        let value = match ev.ev_type.as_str() {
            "const" => {
                let mut expr = FormattedExpression::new("const");
                expr.id = Some(ev.id);
                expr.row_offset = Some(0);
                expr.stage = Some(0);
                expr.dim = Some(symbol.dim);
                expr
            }
            "cm" => {
                let mut expr = FormattedExpression::new("cm");
                expr.id = Some(ev.id);
                expr.row_offset = Some(0);
                expr.stage = symbol.stage;
                expr.dim = Some(symbol.dim);
                expr.airgroup_id = symbol.airgroup_id;
                expr.air_id = symbol.air_id;
                expr
            }
            "custom" => {
                let mut expr = FormattedExpression::new("custom");
                expr.id = Some(ev.id);
                expr.row_offset = Some(0);
                expr.stage = symbol.stage;
                expr.dim = Some(symbol.dim);
                expr.airgroup_id = symbol.airgroup_id;
                expr.air_id = symbol.air_id;
                expr.commit_id = ev.commit_id;
                expr
            }
            _ => anyhow::bail!("unsupported evMap type {}", ev.ev_type),
        };
        let mut eval = FormattedExpression::new("eval");
        eval.id = Some(idx as u64);
        eval.dim = Some(FIELD_EXTENSION);
        let term = FormattedExpression::binary("sub", value, eval);
        expressions.push(term);
        let term_id = expressions.len() - 1;
        if let Some(current_id) = fri_by_opening.get_mut(&ev.prime) {
            let weighted =
                FormattedExpression::binary("mul", exp_ref(*current_id as u64, stage), vf2.clone());
            expressions.push(weighted);
            let weighted_id = expressions.len() - 1;
            let accumulated = FormattedExpression::binary(
                "add",
                exp_ref(weighted_id as u64, stage),
                exp_ref(term_id as u64, stage),
            );
            expressions.push(accumulated);
            *current_id = expressions.len() - 1;
        } else {
            fri_by_opening.insert(ev.prime, term_id);
        }
    }

    let mut fri_exp_id = None;
    for (opening_idx, opening) in opening_points.iter().enumerate() {
        let expr_id = fri_by_opening
            .remove(opening)
            .with_context(|| format!("FRI expression for opening point {opening} not found"))?;
        let weighted = FormattedExpression::binary(
            "mul",
            exp_ref(expr_id as u64, stage),
            x_div_x_sub_xi(*opening, opening_idx),
        );
        expressions.push(weighted);
        let weighted_id = expressions.len() - 1;
        fri_exp_id = Some(if let Some(previous_id) = fri_exp_id {
            let previous =
                FormattedExpression::binary("mul", vf1.clone(), exp_ref(previous_id as u64, stage));
            expressions.push(previous);
            let previous_weighted_id = expressions.len() - 1;
            let accumulated = FormattedExpression::binary(
                "add",
                exp_ref(previous_weighted_id as u64, stage),
                exp_ref(weighted_id as u64, stage),
            );
            expressions.push(accumulated);
            expressions.len() - 1
        } else {
            weighted_id
        });
    }

    let fri_exp_id = fri_exp_id.context("FRI polynomial has no expressions")?;
    expressions[fri_exp_id].stage = Some(stage - 1);
    Ok(fri_exp_id)
}

fn find_eval_symbol<'a>(
    symbols: &'a [FormattedSymbol],
    ev: &EvMapJson,
) -> Option<&'a FormattedSymbol> {
    symbols.iter().find(|symbol| match ev.ev_type.as_str() {
        "const" => symbol.symbol_type == "fixed" && symbol.pol_id == Some(ev.id),
        "cm" => symbol.symbol_type == "witness" && symbol.pol_id == Some(ev.id),
        "custom" => {
            symbol.symbol_type == "custom"
                && symbol.pol_id == Some(ev.id)
                && symbol.commit_id == ev.commit_id
        }
        _ => false,
    })
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
    custom_section_names: Vec<Vec<Option<String>>>,
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
    maps.custom_section_names = vec![Vec::new(); custom_commits.len()];
    for (commit_id, commit) in custom_commits.iter().enumerate() {
        maps.custom_section_names[commit_id] = vec![None; commit.stage_widths.len()];
        for (stage, width) in commit.stage_widths.iter().enumerate() {
            if *width > 0 {
                let section = format!("{}{}", commit.name.as_deref().unwrap_or("custom"), stage);
                maps.custom_section_names[commit_id][stage] = Some(section.clone());
                maps.map_sections_n.insert(section, 0);
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
            let section = maps
                .custom_section_names
                .get(commit_id)
                .and_then(|stages| stages.get(stage as usize))
                .and_then(|section| section.clone())
                .unwrap_or_else(|| format!("custom{commit_id}{stage}"));
            *maps.map_sections_n.entry(section).or_default() += symbol.dim;
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
    let mut offsets = offsets.into_iter().collect::<Vec<_>>();
    offsets.sort_by_key(|offset| offset.to_string());
    Ok(offsets)
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

fn exp_ref_no_commit(id: u64, stage: u64) -> FormattedExpression {
    let mut expr = exp_ref(id, stage);
    expr.no_commit = true;
    expr
}

fn cm_ref(id: u64, stage: u64, dim: u64) -> FormattedExpression {
    let mut expr = FormattedExpression::new("cm");
    expr.id = Some(id);
    expr.row_offset = Some(0);
    expr.stage = Some(stage);
    expr.dim = Some(dim);
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

fn x_div_x_sub_xi(opening: i64, id: usize) -> FormattedExpression {
    let mut expr = FormattedExpression::new("xDivXSubXi");
    expr.id = Some(id as u64);
    expr.opening = Some(opening);
    expr.dim = Some(FIELD_EXTENSION);
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

fn format_security_estimate(estimate: SecurityEstimate) -> SecurityInfoJson {
    SecurityInfoJson {
        proximity_parameter: estimate.proximity_parameter,
        proximity_gap: estimate.proximity_gap,
        regime: "JBR",
    }
}

fn is_false(value: &bool) -> bool {
    !*value
}
