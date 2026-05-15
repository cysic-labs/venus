use anyhow::{Context, Result};
use pilout_crate::pilout::{
    self, global_expression, global_operand, hint_field, operand, GlobalExpression, GlobalOperand,
    Hint, HintField, PilOut, Symbol, SymbolType,
};
use serde::Serialize;
use serde_json::{Map, Value};

use crate::pil_info::analysis::annotate_expressions;
use crate::pil_info::codegen::{
    generate_global_constraints_code, GlobalConstraintCodeJson, HintFieldInfoJson, HintInfoJson,
};
use crate::pil_info::format::{
    FormattedConstraint, FormattedExpression, FormattedHint, FormattedHintValue, FormattedSymbol,
    FIELD_EXTENSION,
};

#[derive(Debug, Serialize)]
pub struct GlobalConstraintsJson {
    pub constraints: Vec<GlobalConstraintCodeJson>,
    pub hints: Vec<HintInfoJson>,
}

pub fn build_global_constraints(root: &PilOut) -> Result<GlobalConstraintsJson> {
    let mut expressions = format_global_expressions(root)?;
    let constraints = format_global_constraints(root)?;
    annotate_expressions(&mut expressions, &constraints)?;
    let constraint_code = generate_global_constraints_code(&constraints, &expressions)?;

    let raw_hints = root
        .hints
        .iter()
        .filter(|hint| hint.air_group_id.is_none() && hint.air_id.is_none())
        .cloned()
        .collect::<Vec<_>>();
    let hints = format_global_hints(root, &raw_hints)?;
    let hints_info = global_hints_info(&hints)?;

    Ok(GlobalConstraintsJson { constraints: constraint_code, hints: hints_info })
}

fn format_global_expressions(root: &PilOut) -> Result<Vec<FormattedExpression>> {
    root.expressions.iter().map(|expression| format_global_expression(expression, root)).collect()
}

fn format_global_expression(
    expression: &GlobalExpression,
    root: &PilOut,
) -> Result<FormattedExpression> {
    let operation =
        expression.operation.as_ref().context("global expression is missing operation")?;
    match operation {
        global_expression::Operation::Add(add) => Ok(FormattedExpression::binary(
            "add",
            format_global_operand(
                required_global_operand(add.lhs.as_ref(), "global add.lhs")?,
                root,
            )?,
            format_global_operand(
                required_global_operand(add.rhs.as_ref(), "global add.rhs")?,
                root,
            )?,
        )),
        global_expression::Operation::Sub(sub) => Ok(FormattedExpression::binary(
            "sub",
            format_global_operand(
                required_global_operand(sub.lhs.as_ref(), "global sub.lhs")?,
                root,
            )?,
            format_global_operand(
                required_global_operand(sub.rhs.as_ref(), "global sub.rhs")?,
                root,
            )?,
        )),
        global_expression::Operation::Mul(mul) => Ok(FormattedExpression::binary(
            "mul",
            format_global_operand(
                required_global_operand(mul.lhs.as_ref(), "global mul.lhs")?,
                root,
            )?,
            format_global_operand(
                required_global_operand(mul.rhs.as_ref(), "global mul.rhs")?,
                root,
            )?,
        )),
        global_expression::Operation::Neg(neg) => Ok(FormattedExpression::unary(
            "neg",
            format_global_operand(
                required_global_operand(neg.value.as_ref(), "global neg.value")?,
                root,
            )?,
        )),
    }
}

fn format_global_operand(operand: &GlobalOperand, root: &PilOut) -> Result<FormattedExpression> {
    let operand = operand.operand.as_ref().context("global operand is missing value")?;
    match operand {
        global_operand::Operand::Constant(constant) => {
            let mut expr = FormattedExpression::new("number");
            expr.value = Some(le_bytes_to_u64(&constant.value)?.to_string());
            Ok(expr)
        }
        global_operand::Operand::Challenge(challenge) => {
            let id = challenge.idx
                + root
                    .num_challenges
                    .iter()
                    .take(challenge.stage.saturating_sub(1) as usize)
                    .sum::<u32>();
            let mut expr = FormattedExpression::new("challenge");
            expr.id = Some(id as u64);
            expr.stage = Some(challenge.stage as u64);
            expr.stage_id = Some(challenge.idx as u64);
            expr.dim = Some(FIELD_EXTENSION);
            Ok(expr)
        }
        global_operand::Operand::ProofValue(proof_value) => {
            let mut expr = FormattedExpression::new("proofvalue");
            expr.id = Some(proof_value.idx as u64);
            expr.stage = Some(proof_value.stage as u64);
            expr.dim = Some(if proof_value.stage == 1 { 1 } else { FIELD_EXTENSION });
            Ok(expr)
        }
        global_operand::Operand::AirGroupValue(air_group_value) => {
            let stage = root
                .air_groups
                .get(air_group_value.air_group_id as usize)
                .with_context(|| format!("airgroup {} not found", air_group_value.air_group_id))?
                .air_group_values
                .get(air_group_value.idx as usize)
                .with_context(|| {
                    format!(
                        "airgroup value {}:{} not found",
                        air_group_value.air_group_id, air_group_value.idx
                    )
                })?
                .stage;
            let mut expr = FormattedExpression::new("airgroupvalue");
            expr.id = Some(air_group_value.idx as u64);
            expr.airgroup_id = Some(air_group_value.air_group_id as u64);
            expr.stage = Some(stage as u64);
            expr.dim = Some(if stage == 1 { 1 } else { FIELD_EXTENSION });
            Ok(expr)
        }
        global_operand::Operand::PublicValue(public_value) => {
            let mut expr = FormattedExpression::new("public");
            expr.id = Some(public_value.idx as u64);
            expr.stage = Some(1);
            expr.dim = Some(1);
            Ok(expr)
        }
        global_operand::Operand::Expression(expression) => {
            if let Some(inlined) = simplified_global_expression_reference(expression.idx, root)? {
                return Ok(inlined);
            }
            let mut expr = FormattedExpression::new("exp");
            expr.id = Some(expression.idx as u64);
            Ok(expr)
        }
        global_operand::Operand::PublicTableAggregatedValue(value) => {
            anyhow::bail!("public table aggregated value {} is not supported yet", value.idx)
        }
        global_operand::Operand::PublicTableColumn(column) => {
            anyhow::bail!(
                "public table column {}:{} is not supported yet",
                column.idx,
                column.col_idx
            )
        }
    }
}

fn simplified_global_expression_reference(
    idx: u32,
    root: &PilOut,
) -> Result<Option<FormattedExpression>> {
    let Some(expression) = root.expressions.get(idx as usize) else {
        anyhow::bail!("global expression {idx} not found");
    };
    let Some(operation) = expression.operation.as_ref() else {
        return Ok(None);
    };
    let (lhs, rhs) = match operation {
        global_expression::Operation::Add(add) => (add.lhs.as_ref(), add.rhs.as_ref()),
        global_expression::Operation::Sub(sub) => (sub.lhs.as_ref(), sub.rhs.as_ref()),
        global_expression::Operation::Mul(_) | global_expression::Operation::Neg(_) => {
            return Ok(None);
        }
    };
    let Some(lhs) = lhs else {
        return Ok(None);
    };
    let Some(rhs) = rhs else {
        return Ok(None);
    };
    if matches!(lhs.operand.as_ref(), Some(global_operand::Operand::Expression(_))) {
        return Ok(None);
    }
    if !is_zero_global_operand(rhs)? {
        return Ok(None);
    }
    Ok(Some(format_global_operand(lhs, root)?))
}

fn is_zero_global_operand(operand: &GlobalOperand) -> Result<bool> {
    match operand.operand.as_ref() {
        Some(global_operand::Operand::Constant(constant)) => {
            Ok(le_bytes_to_u64(&constant.value)? == 0)
        }
        _ => Ok(false),
    }
}

fn format_global_constraints(root: &PilOut) -> Result<Vec<FormattedConstraint>> {
    root.constraints
        .iter()
        .map(|constraint| {
            let expression = constraint
                .expression_idx
                .as_ref()
                .context("global constraint is missing expressionIdx")?;
            Ok(FormattedConstraint {
                boundary: "finalProof".to_string(),
                e: expression.idx as u64,
                line: constraint.debug_line.clone(),
                im_pol: false,
                stage: None,
                offset_min: None,
                offset_max: None,
            })
        })
        .collect()
}

pub fn format_global_symbols(root: &PilOut) -> Result<Vec<FormattedSymbol>> {
    format_symbols(&root.symbols, root)
}

fn format_symbols(symbols: &[Symbol], root: &PilOut) -> Result<Vec<FormattedSymbol>> {
    let mut out = Vec::new();
    for symbol in symbols {
        let Some(symbol_type) = SymbolType::try_from(symbol.r#type).ok() else {
            continue;
        };
        if matches!(
            symbol_type,
            SymbolType::ImCol
                | SymbolType::AirValue
                | SymbolType::CustomCol
                | SymbolType::FixedCol
                | SymbolType::WitnessCol
                | SymbolType::PeriodicCol
                | SymbolType::PublicTable
        ) {
            continue;
        }

        match symbol_type {
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
                    .air_group_id
                    .and_then(|airgroup_id| root.air_groups.get(airgroup_id as usize))
                    .and_then(|airgroup| airgroup.air_group_values.get(symbol.id as usize))
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
            _ => {}
        }
    }
    Ok(out)
}

fn format_global_hints(root: &PilOut, raw_hints: &[Hint]) -> Result<Vec<FormattedHint>> {
    raw_hints
        .iter()
        .map(|hint| {
            let fields = hint
                .hint_fields
                .first()
                .and_then(|field| match field.value.as_ref() {
                    Some(hint_field::Value::HintFieldArray(array)) => {
                        Some(array.hint_fields.as_slice())
                    }
                    _ => None,
                })
                .unwrap_or(&[]);

            let mut formatted_fields = Vec::with_capacity(fields.len());
            for field in fields {
                let name = field.name.clone().unwrap_or_default();
                let (value, lengths) = format_global_hint_field(field, root)?;
                let values = match (&value, &lengths) {
                    (Value::Array(values), Some(_)) => values.clone(),
                    _ => vec![value],
                };
                formatted_fields.push(FormattedHintValue { name, values, lengths });
            }
            Ok(FormattedHint { name: hint.name.clone(), fields: formatted_fields })
        })
        .collect()
}

fn format_global_hint_field(
    field: &HintField,
    root: &PilOut,
) -> Result<(Value, Option<Vec<usize>>)> {
    match field.value.as_ref() {
        Some(hint_field::Value::StringValue(value)) => {
            Ok((serde_json::json!({ "op": "string", "string": value }), None))
        }
        Some(hint_field::Value::Operand(operand)) => {
            let formatted = format_global_hint_operand(operand, root)?;
            Ok((serde_json::to_value(formatted)?, None))
        }
        Some(hint_field::Value::HintFieldArray(array)) => {
            let mut values = Vec::with_capacity(array.hint_fields.len());
            let mut lengths = vec![array.hint_fields.len()];
            for subfield in &array.hint_fields {
                let (subvalue, sublengths) = format_global_hint_field(subfield, root)?;
                values.push(subvalue);
                if let Some(sublengths) = sublengths {
                    for (idx, length) in sublengths.into_iter().enumerate() {
                        if lengths.len() <= idx + 1 {
                            lengths.push(length);
                        }
                    }
                }
            }
            Ok((Value::Array(values), Some(lengths)))
        }
        None => Ok((Value::Null, None)),
    }
}

fn format_global_hint_operand(
    operand: &pilout::Operand,
    root: &PilOut,
) -> Result<FormattedExpression> {
    let operand = operand.operand.as_ref().context("global hint operand is missing value")?;
    match operand {
        operand::Operand::Constant(constant) => {
            let mut expr = FormattedExpression::new("number");
            expr.value = Some(le_bytes_to_u64(&constant.value)?.to_string());
            Ok(expr)
        }
        operand::Operand::Challenge(challenge) => {
            let id = challenge.idx
                + root
                    .num_challenges
                    .iter()
                    .take(challenge.stage.saturating_sub(1) as usize)
                    .sum::<u32>();
            let mut expr = FormattedExpression::new("challenge");
            expr.id = Some(id as u64);
            expr.stage = Some(challenge.stage as u64);
            expr.stage_id = Some(challenge.idx as u64);
            expr.dim = Some(FIELD_EXTENSION);
            Ok(expr)
        }
        operand::Operand::ProofValue(proof_value) => {
            let mut expr = FormattedExpression::new("proofvalue");
            expr.id = Some(proof_value.idx as u64);
            expr.stage = Some(proof_value.stage as u64);
            expr.dim = Some(if proof_value.stage == 1 { 1 } else { FIELD_EXTENSION });
            Ok(expr)
        }
        operand::Operand::PublicValue(public_value) => {
            let mut expr = FormattedExpression::new("public");
            expr.id = Some(public_value.idx as u64);
            expr.stage = Some(1);
            Ok(expr)
        }
        operand::Operand::Expression(expression) => {
            if let Some(inlined) = simplified_global_expression_reference(expression.idx, root)? {
                return Ok(inlined);
            }
            let mut expr = FormattedExpression::new("exp");
            expr.id = Some(expression.idx as u64);
            Ok(expr)
        }
        operand::Operand::AirGroupValue(value) => {
            anyhow::bail!("global hint airgroup value {} does not carry an airgroup id", value.idx)
        }
        operand::Operand::AirValue(value) => {
            anyhow::bail!("global hint air value {} is not valid", value.idx)
        }
        operand::Operand::PeriodicCol(value) => {
            anyhow::bail!("global hint periodic column {} is not valid", value.idx)
        }
        operand::Operand::FixedCol(value) => {
            anyhow::bail!("global hint fixed column {} is not valid", value.idx)
        }
        operand::Operand::WitnessCol(_) | operand::Operand::CustomCol(_) => {
            anyhow::bail!("global hints cannot reference local witness/custom columns")
        }
    }
}

fn global_hints_info(hints: &[FormattedHint]) -> Result<Vec<HintInfoJson>> {
    let mut out = Vec::with_capacity(hints.len());
    for hint in hints {
        let mut fields = Vec::with_capacity(hint.fields.len());
        for field in &hint.fields {
            let mut values = Vec::new();
            process_global_hint_values(&field.values, &mut Vec::new(), &mut values)?;
            if field.lengths.is_none() {
                if let Some(Value::Object(first)) = values.first_mut() {
                    first.insert("pos".to_string(), Value::Array(Vec::new()));
                }
            }
            fields.push(HintFieldInfoJson { name: field.name.clone(), values });
        }
        out.push(HintInfoJson { name: hint.name.clone(), fields });
    }
    Ok(out)
}

fn process_global_hint_values(
    values: &[Value],
    pos: &mut Vec<usize>,
    out: &mut Vec<Value>,
) -> Result<()> {
    for (idx, value) in values.iter().enumerate() {
        pos.push(idx);
        match value {
            Value::Array(values) => process_global_hint_values(values, pos, out)?,
            Value::Object(object) => out.push(process_global_hint_object(object, pos)?),
            Value::Null => {}
            _ => anyhow::bail!("invalid global hint value {value}"),
        }
        pos.pop();
    }
    Ok(())
}

fn process_global_hint_object(object: &Map<String, Value>, pos: &[usize]) -> Result<Value> {
    let op = object.get("op").and_then(Value::as_str).context("global hint value is missing op")?;
    if op == "exp" {
        anyhow::bail!("global expression hints are not supported yet");
    }
    if !matches!(op, "challenge" | "public" | "number" | "string" | "proofvalue") {
        anyhow::bail!("invalid global hint op: {op}");
    }
    let mut processed = object.clone();
    processed.insert(
        "pos".to_string(),
        Value::Array(pos.iter().map(|idx| Value::from(*idx as u64)).collect()),
    );
    Ok(Value::Object(processed))
}

fn required_global_operand<'a>(
    operand: Option<&'a GlobalOperand>,
    label: &str,
) -> Result<&'a GlobalOperand> {
    operand.with_context(|| format!("{label} is missing operand"))
}

fn le_bytes_to_u64(bytes: &[u8]) -> Result<u64> {
    if bytes.len() > 8 {
        anyhow::bail!("field element is wider than u64: {} bytes", bytes.len());
    }
    let mut buf = [0u8; 8];
    buf[8 - bytes.len()..].copy_from_slice(bytes);
    Ok(u64::from_be_bytes(buf))
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
    FormattedSymbol {
        name: symbol.name.clone(),
        symbol_type: symbol_type_name.to_string(),
        pol_id: None,
        id: Some(id as u64),
        stage: Some(stage as u64),
        stage_id: Some(stage_id as u64),
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

fn linear_offset(lengths: &[u32], indexes: &[u32]) -> u32 {
    let mut offset = 0;
    let mut stride = 1;
    for (length, index) in lengths.iter().rev().zip(indexes.iter().rev()) {
        offset += index * stride;
        stride *= length;
    }
    offset
}
