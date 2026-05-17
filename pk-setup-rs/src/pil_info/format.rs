use std::collections::HashMap;

use anyhow::{Context, Result};
use pilout_crate::pilout::{
    self, constraint, expression, hint_field, operand, Air, AirGroupValue, Constraint, Expression,
    Hint, HintField, Operand, Symbol, SymbolType,
};
use serde::Serialize;

pub const FIELD_EXTENSION: u64 = 3;

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct FormattedExpression {
    pub op: String,
    #[serde(skip_serializing_if = "Vec::is_empty")]
    pub values: Vec<FormattedExpression>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub name: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub id: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub value: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub row_offset: Option<i64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub stage: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub stage_id: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub dim: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub airgroup_id: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub air_id: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub commit_id: Option<u64>,
    #[serde(rename = "expDeg", skip_serializing_if = "Option::is_none")]
    pub exp_deg: Option<u64>,
    #[serde(rename = "rowsOffsets", skip_serializing_if = "Option::is_none")]
    pub rows_offsets: Option<Vec<i64>>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub line: Option<String>,
    #[serde(skip_serializing_if = "is_false")]
    pub keep: bool,
    #[serde(rename = "imPol", skip_serializing_if = "is_false")]
    pub im_pol: bool,
    #[serde(rename = "polId", skip_serializing_if = "Option::is_none")]
    pub pol_id: Option<u64>,
    #[serde(rename = "boundaryId", skip_serializing_if = "Option::is_none")]
    pub boundary_id: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub boundary: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub opening: Option<i64>,

    #[serde(skip)]
    pub degree_cache: Option<u64>,
    #[serde(skip)]
    pub no_commit: bool,
}

impl FormattedExpression {
    pub fn new(op: &str) -> Self {
        Self {
            op: op.to_string(),
            values: Vec::new(),
            name: None,
            id: None,
            value: None,
            row_offset: None,
            stage: None,
            stage_id: None,
            dim: None,
            airgroup_id: None,
            air_id: None,
            commit_id: None,
            exp_deg: None,
            rows_offsets: None,
            line: None,
            keep: false,
            im_pol: false,
            pol_id: None,
            boundary_id: None,
            boundary: None,
            opening: None,
            degree_cache: None,
            no_commit: false,
        }
    }

    pub fn binary(op: &str, lhs: FormattedExpression, rhs: FormattedExpression) -> Self {
        let mut expr = Self::new(op);
        expr.values = vec![lhs, rhs];
        expr
    }

    pub fn unary(op: &str, value: FormattedExpression) -> Self {
        let mut expr = Self::new(op);
        expr.values = vec![value];
        expr
    }
}

fn is_false(value: &bool) -> bool {
    !*value
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct FormattedSymbol {
    pub name: String,
    #[serde(rename = "type")]
    pub symbol_type: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub pol_id: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub id: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub stage: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub stage_id: Option<u64>,
    pub dim: u64,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub airgroup_id: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub air_id: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub commit_id: Option<u64>,
    #[serde(skip_serializing_if = "Vec::is_empty")]
    pub lengths: Vec<u32>,
    #[serde(rename = "stagePos", skip_serializing_if = "Option::is_none")]
    pub stage_pos: Option<u64>,
    #[serde(rename = "expId", skip_serializing_if = "Option::is_none")]
    pub exp_id: Option<u64>,
    #[serde(rename = "imPol", skip_serializing_if = "is_false")]
    pub im_pol: bool,
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct FormattedConstraint {
    pub boundary: String,
    pub e: u64,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub line: Option<String>,
    #[serde(rename = "imPol", skip_serializing_if = "is_false")]
    pub im_pol: bool,
    #[serde(skip)]
    pub stage: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub offset_min: Option<u32>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub offset_max: Option<u32>,
}

#[derive(Debug, Clone, Serialize)]
pub struct FormattedHint {
    pub name: String,
    pub fields: Vec<FormattedHintValue>,
}

#[derive(Debug, Clone, Serialize)]
pub struct FormattedHintValue {
    pub name: String,
    pub values: Vec<serde_json::Value>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub lengths: Option<Vec<usize>>,
}

#[derive(Debug)]
pub struct AirFormatContext<'a> {
    pub airgroup_id: u32,
    pub air_id: u32,
    pub air: &'a Air,
    pub air_group_values: &'a [AirGroupValue],
    pub all_symbols: &'a [Symbol],
    pub all_hints: &'a [Hint],
    pub num_challenges: &'a [u32],
    pub global: bool,
}

#[derive(Debug, Clone)]
struct StageWidths {
    witness: Vec<u32>,
    custom: HashMap<u32, Vec<u32>>,
}

pub fn format_air_expressions(ctx: &AirFormatContext<'_>) -> Result<Vec<FormattedExpression>> {
    let stage_widths = StageWidths::new(ctx.air);
    ctx.air.expressions.iter().map(|expr| format_expression(expr, ctx, &stage_widths)).collect()
}

pub fn format_air_constraints(ctx: &AirFormatContext<'_>) -> Result<Vec<FormattedConstraint>> {
    ctx.air.constraints.iter().map(format_constraint).collect::<Result<Vec<_>>>()
}

pub fn format_air_symbols(ctx: &AirFormatContext<'_>) -> Result<Vec<FormattedSymbol>> {
    let mut scoped_symbols = ctx
        .all_symbols
        .iter()
        .filter(|symbol| {
            symbol.air_group_id.is_none()
                || (symbol.air_group_id == Some(ctx.airgroup_id)
                    && symbol.air_id == Some(ctx.air_id))
                || (symbol.air_group_id == Some(ctx.airgroup_id)
                    && symbol.air_id.is_none()
                    && symbol.r#type == SymbolType::AirGroupValue as i32)
        })
        .cloned()
        .collect::<Vec<_>>();

    for symbol in &mut scoped_symbols {
        if symbol.r#type == SymbolType::AirGroupValue as i32 && symbol.air_id.is_none() {
            symbol.air_id = Some(ctx.air_id);
        }
    }

    format_symbols(&scoped_symbols, ctx)
}

pub fn format_air_hints(
    ctx: &AirFormatContext<'_>,
    expressions: &[FormattedExpression],
    symbols: &[FormattedSymbol],
) -> Result<Vec<FormattedHint>> {
    ctx.all_hints
        .iter()
        .filter(|hint| {
            hint.air_group_id == Some(ctx.airgroup_id) && hint.air_id == Some(ctx.air_id)
        })
        .map(|hint| format_hint(hint, ctx, expressions, symbols))
        .collect()
}

fn format_expression(
    expr: &Expression,
    ctx: &AirFormatContext<'_>,
    stage_widths: &StageWidths,
) -> Result<FormattedExpression> {
    let operation = expr.operation.as_ref().context("expression is missing operation")?;
    match operation {
        expression::Operation::Add(add) => Ok(FormattedExpression::binary(
            "add",
            format_operand(required_operand(add.lhs.as_ref(), "add.lhs")?, ctx, stage_widths)?,
            format_operand(required_operand(add.rhs.as_ref(), "add.rhs")?, ctx, stage_widths)?,
        )),
        expression::Operation::Sub(sub) => Ok(FormattedExpression::binary(
            "sub",
            format_operand(required_operand(sub.lhs.as_ref(), "sub.lhs")?, ctx, stage_widths)?,
            format_operand(required_operand(sub.rhs.as_ref(), "sub.rhs")?, ctx, stage_widths)?,
        )),
        expression::Operation::Mul(mul) => Ok(FormattedExpression::binary(
            "mul",
            format_operand(required_operand(mul.lhs.as_ref(), "mul.lhs")?, ctx, stage_widths)?,
            format_operand(required_operand(mul.rhs.as_ref(), "mul.rhs")?, ctx, stage_widths)?,
        )),
        expression::Operation::Neg(neg) => Ok(FormattedExpression::unary(
            "neg",
            format_operand(required_operand(neg.value.as_ref(), "neg.value")?, ctx, stage_widths)?,
        )),
    }
}

fn format_operand(
    operand: &Operand,
    ctx: &AirFormatContext<'_>,
    stage_widths: &StageWidths,
) -> Result<FormattedExpression> {
    let operand = operand.operand.as_ref().context("operand is missing value")?;
    match operand {
        operand::Operand::Constant(constant) => {
            let mut expr = FormattedExpression::new("number");
            expr.value = Some(decode_field_element(&constant.value)?.to_string());
            Ok(expr)
        }
        operand::Operand::Challenge(challenge) => {
            let id = challenge.idx
                + ctx
                    .num_challenges
                    .iter()
                    .take(challenge.stage.saturating_sub(1) as usize)
                    .sum::<u32>();
            let mut expr = FormattedExpression::new("challenge");
            expr.id = Some(id as u64);
            expr.stage = Some(challenge.stage as u64);
            expr.stage_id = Some(challenge.idx as u64);
            Ok(expr)
        }
        operand::Operand::ProofValue(proof_value) => {
            let mut expr = FormattedExpression::new("proofvalue");
            expr.id = Some(proof_value.idx as u64);
            expr.stage = Some(proof_value.stage as u64);
            expr.dim = Some(if proof_value.stage == 1 { 1 } else { FIELD_EXTENSION });
            Ok(expr)
        }
        operand::Operand::AirGroupValue(air_group_value) => {
            let stage = if ctx.global {
                ctx.air_group_values
                    .get(air_group_value.idx as usize)
                    .map(|value| value.stage)
                    .unwrap_or(1)
            } else {
                ctx.air_group_values
                    .get(air_group_value.idx as usize)
                    .with_context(|| format!("airgroup value {} not found", air_group_value.idx))?
                    .stage
            };
            let mut expr = FormattedExpression::new("airgroupvalue");
            expr.id = Some(air_group_value.idx as u64);
            expr.airgroup_id = Some(ctx.airgroup_id as u64);
            expr.stage = Some(stage as u64);
            expr.dim = Some(if stage == 1 { 1 } else { FIELD_EXTENSION });
            Ok(expr)
        }
        operand::Operand::AirValue(air_value) => {
            let stage = ctx
                .air
                .air_values
                .get(air_value.idx as usize)
                .with_context(|| format!("air value {} not found", air_value.idx))?
                .stage;
            let mut expr = FormattedExpression::new("airvalue");
            expr.id = Some(air_value.idx as u64);
            expr.stage = Some(stage as u64);
            expr.dim = Some(if stage == 1 { 1 } else { FIELD_EXTENSION });
            Ok(expr)
        }
        operand::Operand::PublicValue(public_value) => {
            let mut expr = FormattedExpression::new("public");
            expr.id = Some(public_value.idx as u64);
            expr.stage = Some(1);
            Ok(expr)
        }
        operand::Operand::FixedCol(fixed_col) => {
            let mut expr = FormattedExpression::new("const");
            expr.id = Some(fixed_col.idx as u64);
            expr.row_offset = Some(fixed_col.row_offset as i64);
            expr.stage = Some(0);
            expr.dim = Some(1);
            Ok(expr)
        }
        operand::Operand::WitnessCol(witness_col) => {
            let id = witness_col.col_idx
                + stage_widths
                    .witness
                    .iter()
                    .take(witness_col.stage.saturating_sub(1) as usize)
                    .sum::<u32>();
            let mut expr = FormattedExpression::new("cm");
            expr.id = Some(id as u64);
            expr.stage_id = Some(witness_col.col_idx as u64);
            expr.row_offset = Some(witness_col.row_offset as i64);
            expr.stage = Some(witness_col.stage as u64);
            expr.dim = Some(if witness_col.stage <= 1 { 1 } else { FIELD_EXTENSION });
            expr.airgroup_id = Some(ctx.airgroup_id as u64);
            expr.air_id = Some(ctx.air_id as u64);
            Ok(expr)
        }
        operand::Operand::CustomCol(custom_col) => {
            let widths = stage_widths
                .custom
                .get(&custom_col.commit_id)
                .with_context(|| format!("custom commit {} not found", custom_col.commit_id))?;
            let id = custom_col.col_idx
                + widths.iter().take(custom_col.stage.saturating_sub(1) as usize).sum::<u32>();
            let mut expr = FormattedExpression::new("custom");
            expr.id = Some(id as u64);
            expr.stage_id = Some(custom_col.col_idx as u64);
            expr.row_offset = Some(custom_col.row_offset as i64);
            expr.stage = Some(custom_col.stage as u64);
            expr.dim = Some(if custom_col.stage <= 1 { 1 } else { FIELD_EXTENSION });
            expr.airgroup_id = Some(ctx.airgroup_id as u64);
            expr.air_id = Some(ctx.air_id as u64);
            expr.commit_id = Some(custom_col.commit_id as u64);
            Ok(expr)
        }
        operand::Operand::Expression(expression) => {
            let mut expr = FormattedExpression::new("exp");
            expr.id = Some(expression.idx as u64);
            Ok(expr)
        }
        operand::Operand::PeriodicCol(periodic_col) => {
            anyhow::bail!(
                "periodic columns are not supported by native setup formatter yet: {}",
                periodic_col.idx
            )
        }
    }
}

fn simplify_expression_operand(
    idx: u32,
    ctx: &AirFormatContext<'_>,
    stage_widths: &StageWidths,
) -> Result<Option<FormattedExpression>> {
    let Some(expression) = ctx.air.expressions.get(idx as usize) else {
        return Ok(None);
    };
    let Some(operation) = expression.operation.as_ref() else {
        return Ok(None);
    };

    let (lhs, rhs) = match operation {
        expression::Operation::Add(add) => (
            required_operand(add.lhs.as_ref(), "add.lhs")?,
            required_operand(add.rhs.as_ref(), "add.rhs")?,
        ),
        expression::Operation::Sub(sub) => (
            required_operand(sub.lhs.as_ref(), "sub.lhs")?,
            required_operand(sub.rhs.as_ref(), "sub.rhs")?,
        ),
        expression::Operation::Mul(_) | expression::Operation::Neg(_) => return Ok(None),
    };

    if !is_expression_operand(lhs) && constant_operand_is_zero(rhs)? {
        return format_operand(lhs, ctx, stage_widths).map(Some);
    }

    Ok(None)
}

fn is_expression_operand(operand: &Operand) -> bool {
    matches!(operand.operand, Some(operand::Operand::Expression(_)))
}

fn constant_operand_is_zero(operand: &Operand) -> Result<bool> {
    let Some(operand::Operand::Constant(constant)) = operand.operand.as_ref() else {
        return Ok(false);
    };
    Ok(decode_field_element(&constant.value)? == 0)
}

fn format_constraint(constraint: &Constraint) -> Result<FormattedConstraint> {
    let constraint = constraint.constraint.as_ref().context("constraint is missing value")?;
    match constraint {
        constraint::Constraint::FirstRow(first) => Ok(FormattedConstraint {
            boundary: "firstRow".to_string(),
            e: required_expression_idx(first.expression_idx.as_ref(), "firstRow")? as u64,
            line: first.debug_line.clone(),
            im_pol: false,
            stage: None,
            offset_min: None,
            offset_max: None,
        }),
        constraint::Constraint::LastRow(last) => Ok(FormattedConstraint {
            boundary: "lastRow".to_string(),
            e: required_expression_idx(last.expression_idx.as_ref(), "lastRow")? as u64,
            line: last.debug_line.clone(),
            im_pol: false,
            stage: None,
            offset_min: None,
            offset_max: None,
        }),
        constraint::Constraint::EveryRow(every) => Ok(FormattedConstraint {
            boundary: "everyRow".to_string(),
            e: required_expression_idx(every.expression_idx.as_ref(), "everyRow")? as u64,
            line: every.debug_line.clone(),
            im_pol: false,
            stage: None,
            offset_min: None,
            offset_max: None,
        }),
        constraint::Constraint::EveryFrame(frame) => Ok(FormattedConstraint {
            boundary: "everyFrame".to_string(),
            e: required_expression_idx(frame.expression_idx.as_ref(), "everyFrame")? as u64,
            line: frame.debug_line.clone(),
            im_pol: false,
            stage: None,
            offset_min: Some(frame.offset_min),
            offset_max: Some(frame.offset_max),
        }),
    }
}

fn format_symbols(symbols: &[Symbol], ctx: &AirFormatContext<'_>) -> Result<Vec<FormattedSymbol>> {
    let mut out = Vec::new();
    for symbol in symbols {
        let Some(symbol_type) = SymbolType::try_from(symbol.r#type).ok() else {
            continue;
        };
        if symbol_type == SymbolType::ImCol {
            continue;
        }
        if ctx.global
            && matches!(
                symbol_type,
                SymbolType::AirValue
                    | SymbolType::CustomCol
                    | SymbolType::FixedCol
                    | SymbolType::WitnessCol
            )
        {
            continue;
        }

        match symbol_type {
            SymbolType::FixedCol | SymbolType::WitnessCol | SymbolType::CustomCol => {
                let stage = symbol.stage.unwrap_or(0);
                let dim = if stage <= 1 { 1 } else { FIELD_EXTENSION };
                let symbol_type_name = match symbol_type {
                    SymbolType::FixedCol => "fixed",
                    SymbolType::WitnessCol => "witness",
                    SymbolType::CustomCol => "custom",
                    _ => unreachable!(),
                };
                let pol_id = previous_pol_count(symbols, symbol, symbol_type);
                expand_symbol(symbol, symbol_type_name, pol_id, symbol.id, stage, dim, &mut out);
            }
            SymbolType::ProofValue => {
                let stage = symbol.stage.unwrap_or(1);
                let dim = if stage == 1 { 1 } else { FIELD_EXTENSION };
                expand_symbol(symbol, "proofvalue", symbol.id, symbol.id, stage, dim, &mut out);
            }
            SymbolType::Challenge => {
                let stage = symbol.stage.unwrap_or(1);
                let id = symbols
                    .iter()
                    .filter(|other| {
                        other.r#type == SymbolType::Challenge as i32
                            && ((other.stage.unwrap_or(0) < stage)
                                || (other.stage.unwrap_or(0) == stage && other.id < symbol.id))
                    })
                    .count() as u32;
                out.push(FormattedSymbol {
                    name: symbol.name.clone(),
                    symbol_type: "challenge".to_string(),
                    pol_id: None,
                    id: Some(id as u64),
                    stage: Some(stage as u64),
                    stage_id: Some(symbol.id as u64),
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
            SymbolType::PublicValue => {
                expand_symbol(symbol, "public", symbol.id, symbol.id, 1, 1, &mut out)
            }
            SymbolType::AirGroupValue => {
                let stage = symbol
                    .id
                    .try_into()
                    .ok()
                    .and_then(|idx: usize| ctx.air_group_values.get(idx))
                    .map(|value| value.stage);
                expand_symbol(
                    symbol,
                    "airgroupvalue",
                    symbol.id,
                    symbol.id,
                    stage.unwrap_or(1),
                    FIELD_EXTENSION,
                    &mut out,
                );
            }
            SymbolType::AirValue => {
                let stage = symbol
                    .id
                    .try_into()
                    .ok()
                    .and_then(|idx: usize| ctx.air.air_values.get(idx))
                    .map(|value| value.stage)
                    .unwrap_or(1);
                let dim = if stage == 1 { 1 } else { FIELD_EXTENSION };
                expand_symbol(symbol, "airvalue", symbol.id, symbol.id, stage, dim, &mut out);
            }
            SymbolType::ImCol | SymbolType::PeriodicCol | SymbolType::PublicTable => {}
        }
    }
    Ok(out)
}

fn expand_symbol(
    symbol: &Symbol,
    symbol_type_name: &str,
    base_id: u32,
    base_stage_id: u32,
    stage: u32,
    dim: u64,
    out: &mut Vec<FormattedSymbol>,
) {
    if symbol.dim == 0 || symbol.lengths.is_empty() {
        out.push(make_symbol(
            symbol,
            symbol_type_name,
            base_id,
            base_stage_id,
            stage,
            dim,
            Vec::new(),
        ));
        return;
    }

    let mut indexes = Vec::new();
    expand_array_symbol(
        symbol,
        symbol_type_name,
        base_id,
        base_stage_id,
        stage,
        dim,
        &mut indexes,
        out,
    );
}

fn expand_array_symbol(
    symbol: &Symbol,
    symbol_type_name: &str,
    base_id: u32,
    base_stage_id: u32,
    stage: u32,
    dim: u64,
    indexes: &mut Vec<u32>,
    out: &mut Vec<FormattedSymbol>,
) {
    if indexes.len() == symbol.lengths.len() {
        let shift = linear_offset(&symbol.lengths, indexes);
        out.push(make_symbol(
            symbol,
            symbol_type_name,
            base_id + shift,
            base_stage_id + shift,
            stage,
            dim,
            indexes.clone(),
        ));
        return;
    }

    for index in 0..symbol.lengths[indexes.len()] {
        indexes.push(index);
        expand_array_symbol(
            symbol,
            symbol_type_name,
            base_id,
            base_stage_id,
            stage,
            dim,
            indexes,
            out,
        );
        indexes.pop();
    }
}

fn make_symbol(
    symbol: &Symbol,
    symbol_type_name: &str,
    id: u32,
    stage_id: u32,
    stage: u32,
    dim: u64,
    lengths: Vec<u32>,
) -> FormattedSymbol {
    let is_pol = matches!(symbol_type_name, "fixed" | "witness" | "custom");
    FormattedSymbol {
        name: symbol.name.clone(),
        symbol_type: symbol_type_name.to_string(),
        pol_id: is_pol.then_some(id as u64),
        id: (!is_pol).then_some(id as u64),
        stage: Some(stage as u64),
        stage_id: is_pol.then_some(stage_id as u64),
        dim,
        airgroup_id: symbol.air_group_id.map(u64::from),
        air_id: symbol.air_id.map(u64::from),
        commit_id: symbol.commit_id.map(u64::from),
        lengths,
        stage_pos: None,
        exp_id: None,
        im_pol: false,
    }
}

fn previous_pol_count(symbols: &[Symbol], symbol: &Symbol, symbol_type: SymbolType) -> u32 {
    symbols
        .iter()
        .filter(|other| {
            other.r#type == symbol_type as i32
                && other.air_id == symbol.air_id
                && other.air_group_id == symbol.air_group_id
                && (symbol_type != SymbolType::CustomCol || other.commit_id == symbol.commit_id)
                && ((other.stage.unwrap_or(0) < symbol.stage.unwrap_or(0))
                    || (other.stage == symbol.stage && other.id < symbol.id))
        })
        .map(symbol_width)
        .sum()
}

fn symbol_width(symbol: &Symbol) -> u32 {
    if symbol.dim == 0 || symbol.lengths.is_empty() {
        1
    } else {
        symbol.lengths.iter().product()
    }
}

fn format_hint(
    hint: &Hint,
    ctx: &AirFormatContext<'_>,
    _expressions: &[FormattedExpression],
    _symbols: &[FormattedSymbol],
) -> Result<FormattedHint> {
    let stage_widths = StageWidths::new(ctx.air);
    let fields = hint
        .hint_fields
        .first()
        .and_then(|field| match field.value.as_ref() {
            Some(hint_field::Value::HintFieldArray(array)) => Some(array.hint_fields.as_slice()),
            _ => None,
        })
        .unwrap_or(&[]);

    let mut formatted_fields = Vec::with_capacity(fields.len());
    for field in fields {
        let name = field.name.clone().unwrap_or_default();
        let (value, lengths) = format_hint_field(field, ctx, &stage_widths)?;
        let values = match (&value, &lengths) {
            (serde_json::Value::Array(values), Some(_)) => values.clone(),
            _ => vec![value],
        };
        formatted_fields.push(FormattedHintValue { name, values, lengths });
    }
    Ok(FormattedHint { name: hint.name.clone(), fields: formatted_fields })
}

fn format_hint_field(
    field: &HintField,
    ctx: &AirFormatContext<'_>,
    stage_widths: &StageWidths,
) -> Result<(serde_json::Value, Option<Vec<usize>>)> {
    match field.value.as_ref() {
        Some(hint_field::Value::StringValue(value)) => {
            Ok((serde_json::json!({ "op": "string", "string": value }), None))
        }
        Some(hint_field::Value::Operand(operand)) => {
            if let Some(operand::Operand::Expression(expression)) = operand.operand.as_ref() {
                if let Some(simplified) =
                    simplify_expression_operand(expression.idx, ctx, stage_widths)?
                {
                    return Ok((serde_json::to_value(simplified)?, None));
                }
            }
            let formatted = format_operand(operand, ctx, stage_widths)?;
            Ok((serde_json::to_value(formatted)?, None))
        }
        Some(hint_field::Value::HintFieldArray(array)) => {
            let mut values = Vec::with_capacity(array.hint_fields.len());
            let mut lengths = vec![array.hint_fields.len()];
            for subfield in &array.hint_fields {
                let (subvalue, sublengths) = format_hint_field(subfield, ctx, stage_widths)?;
                values.push(subvalue);
                if let Some(sublengths) = sublengths {
                    for (idx, length) in sublengths.into_iter().enumerate() {
                        if lengths.len() <= idx + 1 {
                            lengths.push(length);
                        }
                    }
                }
            }
            Ok((serde_json::Value::Array(values), Some(lengths)))
        }
        None => Ok((serde_json::Value::Null, None)),
    }
}

fn required_operand<'a>(operand: Option<&'a Operand>, label: &str) -> Result<&'a Operand> {
    operand.with_context(|| format!("{label} is missing operand"))
}

fn required_expression_idx(
    expression: Option<&pilout::operand::Expression>,
    label: &str,
) -> Result<u32> {
    expression
        .map(|expression| expression.idx)
        .with_context(|| format!("{label} is missing expressionIdx"))
}

fn decode_field_element(bytes: &[u8]) -> Result<u64> {
    if bytes.len() > 8 {
        anyhow::bail!("field element is wider than u64: {} bytes", bytes.len());
    }
    let mut buf = [0u8; 8];
    buf[8 - bytes.len()..].copy_from_slice(bytes);
    Ok(u64::from_be_bytes(buf))
}

fn linear_offset(lengths: &[u32], indexes: &[u32]) -> u32 {
    let mut offset = 0;
    let mut stride = 1;
    for (length, index) in lengths.iter().rev().zip(indexes.iter().rev()) {
        offset += index * stride;
        stride *= length;
    }
    offset
}

impl StageWidths {
    fn new(air: &Air) -> Self {
        let custom = air
            .custom_commits
            .iter()
            .enumerate()
            .map(|(idx, commit)| (idx as u32, commit.stage_widths.clone()))
            .collect();
        Self { witness: air.stage_widths.clone(), custom }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn decodes_compiler_constant_bytes_as_big_endian() -> Result<()> {
        assert_eq!(decode_field_element(&[1])?, 1);
        assert_eq!(decode_field_element(&[0x01, 0x4b])?, 331);
        assert_eq!(
            decode_field_element(&0x0102_0304_0506_0708u64.to_be_bytes())?,
            0x0102_0304_0506_0708
        );
        Ok(())
    }
}
