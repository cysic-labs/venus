use std::collections::BTreeSet;

use anyhow::{Context, Result};

use crate::pil_info::format::{FormattedConstraint, FormattedExpression, FIELD_EXTENSION};

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ExpressionInfo {
    pub exp_deg: u64,
    pub dim: u64,
    pub stage: u64,
    pub rows_offsets: Vec<i64>,
}

pub fn annotate_expressions(
    expressions: &mut [FormattedExpression],
    constraints: &[FormattedConstraint],
) -> Result<()> {
    for constraint in constraints {
        annotate_expression_id(expressions, constraint.e as usize)?;
    }

    for idx in 0..expressions.len() {
        annotate_expression_id(expressions, idx)?;
    }

    Ok(())
}

pub fn annotate_expression_id(
    expressions: &mut [FormattedExpression],
    exp_id: usize,
) -> Result<ExpressionInfo> {
    if exp_id >= expressions.len() {
        anyhow::bail!("expression {exp_id} not found");
    }

    let mut stack = vec![(exp_id, false)];
    while let Some((id, ready)) = stack.pop() {
        if id >= expressions.len() {
            anyhow::bail!("expression {id} not found");
        }
        if has_expression_info(&expressions[id]) {
            continue;
        }

        if ready {
            let info = expression_info_from_cached(expressions, &expressions[id])?;
            apply_expression_info(&mut expressions[id], &info);
            continue;
        }

        stack.push((id, true));
        let mut refs = Vec::new();
        collect_exp_refs(&expressions[id], &mut refs)?;
        for dep_id in refs.into_iter().rev() {
            if dep_id >= expressions.len() {
                anyhow::bail!("expression {dep_id} not found");
            }
            if !has_expression_info(&expressions[dep_id]) {
                stack.push((dep_id, false));
            }
        }
    }

    cached_expression_info(&expressions[exp_id])
}

pub fn expression_info(
    expressions: &[FormattedExpression],
    expression: &FormattedExpression,
) -> Result<ExpressionInfo> {
    match expression.op.as_str() {
        "exp" => {
            let id = expression.id.context("exp expression is missing id")? as usize;
            let inner =
                expressions.get(id).with_context(|| format!("expression {id} not found"))?;
            let mut info = expression_info(expressions, inner)?;
            if let Some(dim) = expression.dim {
                info.dim = dim;
            }
            if let Some(stage) = expression.stage {
                info.stage = stage;
            }
            Ok(info)
        }
        "cm" | "custom" | "const" => Ok(ExpressionInfo {
            exp_deg: 1,
            dim: expression.dim.unwrap_or(1),
            stage: expression.stage.unwrap_or(if expression.op == "const" { 0 } else { 1 }),
            rows_offsets: expression.row_offset.map_or_else(Vec::new, |offset| vec![offset]),
        }),
        "Zi" => {
            let boundary_every_row = expression.boundary.as_deref() == Some("everyRow");
            Ok(ExpressionInfo {
                exp_deg: if boundary_every_row { 0 } else { 1 },
                dim: 1,
                stage: 0,
                rows_offsets: Vec::new(),
            })
        }
        "xDivXSubXi" => Ok(ExpressionInfo {
            exp_deg: 1,
            dim: FIELD_EXTENSION,
            stage: 0,
            rows_offsets: Vec::new(),
        }),
        "challenge" | "eval" => Ok(ExpressionInfo {
            exp_deg: 0,
            dim: FIELD_EXTENSION,
            stage: expression.stage.unwrap_or(0),
            rows_offsets: Vec::new(),
        }),
        "airgroupvalue" | "airvalue" | "proofvalue" => {
            let stage = expression.stage.unwrap_or(1);
            Ok(ExpressionInfo {
                exp_deg: 0,
                dim: expression.dim.unwrap_or(if stage == 1 { 1 } else { FIELD_EXTENSION }),
                stage,
                rows_offsets: Vec::new(),
            })
        }
        "public" => Ok(ExpressionInfo { exp_deg: 0, dim: 1, stage: 1, rows_offsets: Vec::new() }),
        "number" => Ok(ExpressionInfo { exp_deg: 0, dim: 1, stage: 0, rows_offsets: Vec::new() }),
        "neg" => expression
            .values
            .first()
            .context("neg expression is missing value")
            .and_then(|value| expression_info(expressions, value)),
        "add" | "sub" | "mul" => {
            let lhs = expression
                .values
                .first()
                .context("binary expression is missing lhs")
                .and_then(|value| expression_info(expressions, value))?;
            let rhs = expression
                .values
                .get(1)
                .context("binary expression is missing rhs")
                .and_then(|value| expression_info(expressions, value))?;
            let exp_deg = if expression.op == "mul" {
                lhs.exp_deg + rhs.exp_deg
            } else {
                lhs.exp_deg.max(rhs.exp_deg)
            };
            Ok(ExpressionInfo {
                exp_deg,
                dim: lhs.dim.max(rhs.dim),
                stage: lhs.stage.max(rhs.stage),
                rows_offsets: merge_offsets(&lhs.rows_offsets, &rhs.rows_offsets),
            })
        }
        op => anyhow::bail!("expression op not supported by analyzer: {op}"),
    }
}

pub fn calculate_exp_deg(
    expressions: &[FormattedExpression],
    expression: &FormattedExpression,
    intermediate_expressions: &[usize],
) -> Result<u64> {
    if intermediate_expressions.is_empty() {
        if let Some(exp_deg) = expression.exp_deg {
            return Ok(exp_deg);
        }
        if let Some(degree_cache) = expression.degree_cache {
            return Ok(degree_cache);
        }
    }

    match expression.op.as_str() {
        "exp" => {
            let id = expression.id.context("exp expression is missing id")? as usize;
            if intermediate_expressions.contains(&id) {
                return Ok(1);
            }
            let inner =
                expressions.get(id).with_context(|| format!("expression {id} not found"))?;
            calculate_exp_deg(expressions, inner, intermediate_expressions)
        }
        "const" | "cm" | "custom" => Ok(1),
        "Zi" => Ok(if expression.boundary.as_deref() == Some("everyRow") { 0 } else { 1 }),
        "number" | "public" | "challenge" | "eval" | "airgroupvalue" | "airvalue"
        | "proofvalue" => Ok(0),
        "neg" => expression
            .values
            .first()
            .context("neg expression is missing value")
            .and_then(|value| calculate_exp_deg(expressions, value, intermediate_expressions)),
        "add" | "sub" | "mul" => {
            let lhs =
                expression.values.first().context("binary expression is missing lhs").and_then(
                    |value| calculate_exp_deg(expressions, value, intermediate_expressions),
                )?;
            let rhs =
                expression.values.get(1).context("binary expression is missing rhs").and_then(
                    |value| calculate_exp_deg(expressions, value, intermediate_expressions),
                )?;
            Ok(if expression.op == "mul" { lhs + rhs } else { lhs.max(rhs) })
        }
        op => anyhow::bail!("expression op not supported by degree calculator: {op}"),
    }
}

fn apply_expression_info(expression: &mut FormattedExpression, info: &ExpressionInfo) {
    expression.exp_deg = Some(info.exp_deg);
    expression.dim.get_or_insert(info.dim);
    expression.stage.get_or_insert(info.stage);
    expression.rows_offsets = Some(info.rows_offsets.clone());
}

fn has_expression_info(expression: &FormattedExpression) -> bool {
    expression.exp_deg.is_some()
        && expression.dim.is_some()
        && expression.stage.is_some()
        && expression.rows_offsets.is_some()
}

fn cached_expression_info(expression: &FormattedExpression) -> Result<ExpressionInfo> {
    Ok(ExpressionInfo {
        exp_deg: expression.exp_deg.context("expression is missing expDeg")?,
        dim: expression.dim.context("expression is missing dim")?,
        stage: expression.stage.context("expression is missing stage")?,
        rows_offsets: expression
            .rows_offsets
            .as_ref()
            .context("expression is missing rowsOffsets")?
            .clone(),
    })
}

fn collect_exp_refs(expression: &FormattedExpression, refs: &mut Vec<usize>) -> Result<()> {
    let mut stack = vec![expression];
    while let Some(expr) = stack.pop() {
        if expr.op == "exp" {
            refs.push(expr.id.context("exp expression is missing id")? as usize);
        }
        stack.extend(expr.values.iter());
    }
    Ok(())
}

fn expression_info_from_cached(
    expressions: &[FormattedExpression],
    expression: &FormattedExpression,
) -> Result<ExpressionInfo> {
    match expression.op.as_str() {
        "exp" => {
            let id = expression.id.context("exp expression is missing id")? as usize;
            let mut info = cached_expression_info(
                expressions.get(id).with_context(|| format!("expression {id} not found"))?,
            )?;
            if let Some(dim) = expression.dim {
                info.dim = dim;
            }
            if let Some(stage) = expression.stage {
                info.stage = stage;
            }
            Ok(info)
        }
        "cm" | "custom" | "const" => Ok(ExpressionInfo {
            exp_deg: 1,
            dim: expression.dim.unwrap_or(1),
            stage: expression.stage.unwrap_or(if expression.op == "const" { 0 } else { 1 }),
            rows_offsets: expression.row_offset.map_or_else(Vec::new, |offset| vec![offset]),
        }),
        "Zi" => {
            let boundary_every_row = expression.boundary.as_deref() == Some("everyRow");
            Ok(ExpressionInfo {
                exp_deg: if boundary_every_row { 0 } else { 1 },
                dim: 1,
                stage: 0,
                rows_offsets: Vec::new(),
            })
        }
        "xDivXSubXi" => Ok(ExpressionInfo {
            exp_deg: 1,
            dim: FIELD_EXTENSION,
            stage: 0,
            rows_offsets: Vec::new(),
        }),
        "challenge" | "eval" => Ok(ExpressionInfo {
            exp_deg: 0,
            dim: FIELD_EXTENSION,
            stage: expression.stage.unwrap_or(0),
            rows_offsets: Vec::new(),
        }),
        "airgroupvalue" | "airvalue" | "proofvalue" => {
            let stage = expression.stage.unwrap_or(1);
            Ok(ExpressionInfo {
                exp_deg: 0,
                dim: expression.dim.unwrap_or(if stage == 1 { 1 } else { FIELD_EXTENSION }),
                stage,
                rows_offsets: Vec::new(),
            })
        }
        "public" => Ok(ExpressionInfo { exp_deg: 0, dim: 1, stage: 1, rows_offsets: Vec::new() }),
        "number" => Ok(ExpressionInfo { exp_deg: 0, dim: 1, stage: 0, rows_offsets: Vec::new() }),
        "neg" => expression
            .values
            .first()
            .context("neg expression is missing value")
            .and_then(|value| expression_info_from_cached(expressions, value)),
        "add" | "sub" | "mul" => {
            let lhs = expression
                .values
                .first()
                .context("binary expression is missing lhs")
                .and_then(|value| expression_info_from_cached(expressions, value))?;
            let rhs = expression
                .values
                .get(1)
                .context("binary expression is missing rhs")
                .and_then(|value| expression_info_from_cached(expressions, value))?;
            let exp_deg = if expression.op == "mul" {
                lhs.exp_deg + rhs.exp_deg
            } else {
                lhs.exp_deg.max(rhs.exp_deg)
            };
            Ok(ExpressionInfo {
                exp_deg,
                dim: lhs.dim.max(rhs.dim),
                stage: lhs.stage.max(rhs.stage),
                rows_offsets: merge_offsets(&lhs.rows_offsets, &rhs.rows_offsets),
            })
        }
        op => anyhow::bail!("expression op not supported by analyzer: {op}"),
    }
}

fn merge_offsets(lhs: &[i64], rhs: &[i64]) -> Vec<i64> {
    let mut offsets = BTreeSet::new();
    if lhs.is_empty() {
        offsets.insert(0);
    } else {
        offsets.extend(lhs.iter().copied());
    }
    if rhs.is_empty() {
        offsets.insert(0);
    } else {
        offsets.extend(rhs.iter().copied());
    }
    offsets.into_iter().collect()
}
