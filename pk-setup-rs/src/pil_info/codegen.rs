use std::cell::RefCell;
use std::collections::HashMap;
use std::rc::Rc;

use anyhow::{Context, Result};
use serde::Serialize;
use serde_json::{Map, Value};

use crate::pil_info::format::{
    FormattedConstraint, FormattedExpression, FormattedHint, FormattedSymbol, FIELD_EXTENSION,
};
use crate::pil_info::stark::{EvMapJson, StarkInfoJson};

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ExpressionsInfoJson {
    #[serde(rename = "hintsInfo")]
    pub hints_info: Vec<HintInfoJson>,
    #[serde(rename = "expressionsCode")]
    pub expressions_code: Vec<ExpressionCodeJson>,
    pub constraints: Vec<ConstraintCodeJson>,
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct VerifierInfoJson {
    #[serde(rename = "qVerifier")]
    pub q_verifier: CodeBlockJson,
    #[serde(rename = "queryVerifier")]
    pub query_verifier: ExpressionCodeJson,
}

#[derive(Debug, Clone, Serialize)]
pub struct HintInfoJson {
    pub name: String,
    pub fields: Vec<HintFieldInfoJson>,
}

#[derive(Debug, Clone, Serialize)]
pub struct HintFieldInfoJson {
    pub name: String,
    pub values: Vec<Value>,
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ExpressionCodeJson {
    #[serde(flatten)]
    pub block: CodeBlockJson,
    #[serde(rename = "expId")]
    pub exp_id: usize,
    pub stage: u64,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub dest: Option<ExpressionDestJson>,
    pub line: String,
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ConstraintCodeJson {
    #[serde(flatten)]
    pub block: CodeBlockJson,
    pub boundary: String,
    pub line: String,
    #[serde(rename = "imPol")]
    pub im_pol: u64,
    pub stage: u64,
    #[serde(rename = "offsetMin", skip_serializing_if = "Option::is_none")]
    pub offset_min: Option<u32>,
    #[serde(rename = "offsetMax", skip_serializing_if = "Option::is_none")]
    pub offset_max: Option<u32>,
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct CodeBlockJson {
    #[serde(rename = "tmpUsed")]
    pub tmp_used: u64,
    pub code: Vec<CodeLineJson>,
    #[serde(skip_serializing_if = "String::is_empty")]
    pub line: String,
}

#[derive(Debug, Clone, Serialize)]
pub struct CodeLineJson {
    pub op: String,
    pub dest: CodeRefJson,
    pub src: Vec<CodeRefJson>,
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct CodeRefJson {
    #[serde(rename = "type")]
    pub ref_type: String,
    #[serde(rename = "expId", skip_serializing_if = "Option::is_none")]
    pub exp_id: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub id: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub prime: Option<i64>,
    pub dim: u64,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub stage: Option<u64>,
    #[serde(rename = "stageId", skip_serializing_if = "Option::is_none")]
    pub stage_id: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub value: Option<String>,
    #[serde(rename = "boundaryId", skip_serializing_if = "Option::is_none")]
    pub boundary_id: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub opening: Option<i64>,
    #[serde(rename = "commitId", skip_serializing_if = "Option::is_none")]
    pub commit_id: Option<u64>,
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ExpressionDestJson {
    pub op: String,
    pub stage: u64,
    #[serde(rename = "stageId")]
    pub stage_id: u64,
    pub id: u64,
}

#[derive(Debug, Clone, Copy, Default)]
struct Calculated {
    cm: bool,
}

#[derive(Debug, Clone)]
struct CodegenContext {
    stage: u64,
    calculated: Rc<RefCell<CalculatedMap>>,
    tmp_used: u64,
    code: Vec<CodeLineJson>,
    dom: Domain,
    air_id: u32,
    airgroup_id: u32,
    opening_points: Vec<i64>,
    verifier_evaluations: bool,
    ev_map: Vec<EvMapJson>,
}

type CalculatedMap = HashMap<usize, HashMap<i64, Calculated>>;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Domain {
    N,
    Ext,
}

pub fn generate_pil_code(
    stark_info: &StarkInfoJson,
    symbols: &[FormattedSymbol],
    constraints: &[FormattedConstraint],
    expressions: &mut [FormattedExpression],
    hints: &[FormattedHint],
    debug: bool,
) -> Result<(ExpressionsInfoJson, VerifierInfoJson)> {
    mark_hint_keeps(expressions, hints)?;

    let q_verifier = if debug {
        CodeBlockJson { tmp_used: 0, code: Vec::new(), line: String::new() }
    } else {
        generate_constraint_polynomial_verifier_code(stark_info, symbols, expressions)?
    };

    let hints_info = add_hints_info(stark_info, expressions, hints)?;
    let expressions_code = generate_expressions_code(stark_info, symbols, expressions)?;
    let mut query_verifier = expressions_code
        .iter()
        .find(|code| Some(code.exp_id) == stark_info.fri_exp_id)
        .cloned()
        .context("FRI expression code not generated")?;
    if let Some(last) = query_verifier.block.code.last_mut() {
        last.dest.ref_type = "tmp".to_string();
        last.dest.id = Some(query_verifier.block.tmp_used.saturating_sub(1));
        last.dest.dim = FIELD_EXTENSION;
    }

    let constraints = generate_constraints_debug_code(stark_info, symbols, constraints, expressions)?;
    let expressions_info = ExpressionsInfoJson { hints_info, expressions_code, constraints };
    let verifier_info = VerifierInfoJson { q_verifier, query_verifier };
    Ok((expressions_info, verifier_info))
}

fn generate_expressions_code(
    stark_info: &StarkInfoJson,
    symbols: &[FormattedSymbol],
    expressions: &[FormattedExpression],
) -> Result<Vec<ExpressionCodeJson>> {
    let mut expressions_code = Vec::new();
    let fri_exp_id = stark_info.fri_exp_id.context("missing FRI expression id")?;
    for exp_id in 0..expressions.len() {
        let exp = &expressions[exp_id];
        if !exp.keep && !exp.im_pol && exp_id != stark_info.c_exp_id && exp_id != fri_exp_id {
            continue;
        }

        let dom =
            if exp_id == stark_info.c_exp_id || exp_id == fri_exp_id { Domain::Ext } else { Domain::N };
        let mut ctx = CodegenContext::new(stark_info, exp.stage.unwrap_or(0), dom, false);
        if exp_id == fri_exp_id {
            ctx.opening_points = stark_info.opening_points.clone();
        }
        if exp_id == stark_info.c_exp_id {
            seed_intermediate_calculations(&mut ctx, symbols, stark_info);
        }

        let dest = if exp.im_pol {
            let symbol = symbols
                .iter()
                .find(|symbol| symbol.symbol_type == "witness" && symbol.exp_id == Some(exp_id as u64))
                .with_context(|| format!("intermediate symbol for expression {exp_id} not found"))?;
            Some(ExpressionDestJson {
                op: "cm".to_string(),
                stage: symbol.stage.unwrap_or(0),
                stage_id: symbol.stage_id.unwrap_or(0),
                id: symbol.pol_id.unwrap_or(0),
            })
        } else {
            None
        };

        pil_code_gen(&mut ctx, symbols, expressions, exp_id, 0)?;
        let mut block = build_code(ctx)?;
        if exp_id == stark_info.c_exp_id {
            if let Some(last) = block.code.last_mut() {
                last.dest.ref_type = "q".to_string();
                last.dest.id = Some(0);
                last.dest.dim = stark_info.q_dim;
            }
        }
        if exp_id == fri_exp_id {
            if let Some(last) = block.code.last_mut() {
                last.dest.ref_type = "f".to_string();
                last.dest.id = Some(0);
                last.dest.dim = FIELD_EXTENSION;
            }
        }

        expressions_code.push(ExpressionCodeJson {
            block,
            exp_id,
            stage: exp.stage.unwrap_or(0),
            dest,
            line: exp.line.clone().unwrap_or_default(),
        });
    }
    Ok(expressions_code)
}

fn generate_constraints_debug_code(
    stark_info: &StarkInfoJson,
    symbols: &[FormattedSymbol],
    constraints: &[FormattedConstraint],
    expressions: &[FormattedExpression],
) -> Result<Vec<ConstraintCodeJson>> {
    let mut out = Vec::with_capacity(constraints.len());
    for constraint in constraints {
        let mut ctx = CodegenContext::new(stark_info, stark_info.n_stages as u64, Domain::N, false);
        seed_intermediate_calculations(&mut ctx, symbols, stark_info);
        pil_code_gen(&mut ctx, symbols, expressions, constraint.e as usize, 0)?;
        let block = build_code(ctx)?;
        let stage = match constraint.stage {
            Some(0) => 1,
            Some(stage) => stage,
            None => 0,
        };
        out.push(ConstraintCodeJson {
            block,
            boundary: constraint.boundary.clone(),
            line: constraint.line.clone().unwrap_or_default(),
            im_pol: 0,
            stage,
            offset_min: (constraint.boundary == "everyFrame").then_some(constraint.offset_min).flatten(),
            offset_max: (constraint.boundary == "everyFrame").then_some(constraint.offset_max).flatten(),
        });
    }
    Ok(out)
}

fn generate_constraint_polynomial_verifier_code(
    stark_info: &StarkInfoJson,
    symbols: &[FormattedSymbol],
    expressions: &[FormattedExpression],
) -> Result<CodeBlockJson> {
    let mut ctx = CodegenContext::new(
        stark_info,
        stark_info.n_stages as u64 + 1,
        Domain::N,
        true,
    );
    ctx.ev_map = stark_info.ev_map.clone();
    seed_intermediate_calculations(&mut ctx, symbols, stark_info);
    pil_code_gen(&mut ctx, symbols, expressions, stark_info.c_exp_id, 0)?;
    let mut block = build_code(ctx)?;
    block.line.clear();
    Ok(block)
}

fn pil_code_gen(
    ctx: &mut CodegenContext,
    symbols: &[FormattedSymbol],
    expressions: &[FormattedExpression],
    exp_id: usize,
    prime: i64,
) -> Result<()> {
    pil_code_gen_inner(ctx, symbols, expressions, exp_id, prime, false)
}

fn pil_code_gen_inner(
    ctx: &mut CodegenContext,
    symbols: &[FormattedSymbol],
    expressions: &[FormattedExpression],
    exp_id: usize,
    prime: i64,
    force: bool,
) -> Result<()> {
    if !force
        && ctx
        .calculated
        .borrow()
        .get(&exp_id)
        .and_then(|by_prime| by_prime.get(&prime))
        .is_some()
    {
        return Ok(());
    }

    let exp = expressions
        .get(exp_id)
        .with_context(|| format!("expression {exp_id} not found"))?;
    calculate_deps(ctx, symbols, expressions, exp, prime)?;

    let mut code_ctx = ctx.fork_for_expression();
    let ret_ref = eval_exp(&mut code_ctx, symbols, expressions, exp, prime)?;
    let mut result = CodeRefJson::new("exp", exp.dim.unwrap_or(1));
    result.id = Some(exp_id as u64);
    result.prime = Some(prime);

    if ret_ref.ref_type == "tmp" {
        if !force {
            fix_commit_pol(&mut result, &code_ctx, symbols)?;
        }
        if let Some(last) = code_ctx.code.last_mut() {
            last.dest = result.clone();
        }
        if result.ref_type == "cm" {
            code_ctx.tmp_used = code_ctx.tmp_used.saturating_sub(1);
        }
    } else {
        if !force {
            fix_commit_pol(&mut result, &code_ctx, symbols)?;
        }
        code_ctx.code.push(CodeLineJson {
            op: "copy".to_string(),
            dest: result,
            src: vec![ret_ref],
        });
    }

    ctx.code.extend(code_ctx.code);
    ctx.calculated
        .borrow_mut()
        .entry(exp_id)
        .or_default()
        .insert(prime, Calculated { cm: false });
    if code_ctx.tmp_used > ctx.tmp_used {
        ctx.tmp_used = code_ctx.tmp_used;
    }
    Ok(())
}

fn eval_exp(
    ctx: &mut CodegenContext,
    symbols: &[FormattedSymbol],
    expressions: &[FormattedExpression],
    exp: &FormattedExpression,
    prime: i64,
) -> Result<CodeRefJson> {
    match exp.op.as_str() {
        "add" | "sub" | "mul" => {
            let mut values = Vec::with_capacity(exp.values.len());
            for value in &exp.values {
                values.push(eval_exp(ctx, symbols, expressions, value, prime)?);
            }
            let dim = values.iter().map(|value| value.dim).max().unwrap_or(1);
            let result = CodeRefJson::tmp(ctx.tmp_used, dim);
            ctx.tmp_used += 1;
            ctx.code.push(CodeLineJson {
                op: exp.op.clone(),
                dest: result.clone(),
                src: values,
            });
            Ok(result)
        }
        "neg" => {
            let zero = CodeRefJson::number("0");
            let value = eval_exp(ctx, symbols, expressions, exp.values.first().context("neg missing value")?, prime)?;
            let dim = value.dim;
            let result = CodeRefJson::tmp(ctx.tmp_used, dim);
            ctx.tmp_used += 1;
            ctx.code.push(CodeLineJson {
                op: "sub".to_string(),
                dest: result.clone(),
                src: vec![zero, value],
            });
            Ok(result)
        }
        "cm" | "const" | "custom" => direct_column_ref(ctx, exp, prime),
        "exp" => {
            let id = exp.id.context("exp expression is missing id")? as usize;
            let inner = expressions.get(id).with_context(|| format!("expression {id} not found"))?;
            if matches!(inner.op.as_str(), "cm" | "const" | "custom") {
                direct_column_ref(ctx, inner, prime_for(exp, prime))
            } else {
                let mut result = CodeRefJson::new("exp", exp.dim.unwrap_or(inner.dim.unwrap_or(1)));
                result.exp_id = Some(id as u64);
                result.id = Some(id as u64);
                result.prime = Some(prime_for(exp, prime));
                if !exp.no_commit {
                    fix_commit_pol(&mut result, ctx, symbols)?;
                }
                Ok(result)
            }
        }
        "challenge" => {
            let mut result = CodeRefJson::new("challenge", exp.dim.unwrap_or(FIELD_EXTENSION));
            result.id = exp.id;
            result.stage = exp.stage;
            result.stage_id = exp.stage_id;
            Ok(result)
        }
        "public" => {
            let mut result = CodeRefJson::new("public", 1);
            result.id = exp.id;
            Ok(result)
        }
        "proofvalue" => {
            let mut result = CodeRefJson::new("proofvalue", exp.dim.unwrap_or(1));
            result.id = exp.id;
            result.stage = exp.stage;
            Ok(result)
        }
        "number" => Ok(CodeRefJson::number(exp.value.as_deref().unwrap_or("0"))),
        "eval" => {
            let mut result = CodeRefJson::new("eval", exp.dim.unwrap_or(FIELD_EXTENSION));
            result.id = exp.id;
            Ok(result)
        }
        "airgroupvalue" | "airvalue" => {
            let mut result = CodeRefJson::new(&exp.op, exp.dim.unwrap_or(1));
            result.id = exp.id;
            result.stage = exp.stage;
            Ok(result)
        }
        "xDivXSubXi" => {
            let mut result = CodeRefJson::new("xDivXSubXi", FIELD_EXTENSION);
            result.id = exp.id;
            result.opening = exp.opening;
            Ok(result)
        }
        "Zi" => {
            let mut result = CodeRefJson::new("Zi", 1);
            result.boundary_id = exp.boundary_id;
            Ok(result)
        }
        op => anyhow::bail!("invalid expression op for codegen: {op}"),
    }
}

fn direct_column_ref(
    ctx: &CodegenContext,
    exp: &FormattedExpression,
    prime: i64,
) -> Result<CodeRefJson> {
    let mut result = CodeRefJson::new(&exp.op, exp.dim.unwrap_or(1));
    result.id = exp.id;
    result.prime = Some(prime_for(exp, prime));
    result.commit_id = exp.commit_id;
    if ctx.verifier_evaluations {
        fix_eval(&mut result, ctx)?;
    }
    Ok(result)
}

fn calculate_deps(
    ctx: &mut CodegenContext,
    symbols: &[FormattedSymbol],
    expressions: &[FormattedExpression],
    exp: &FormattedExpression,
    prime: i64,
) -> Result<()> {
    match exp.op.as_str() {
        "exp" => {
            let id = exp.id.context("dependency expression is missing id")? as usize;
            pil_code_gen_inner(
                ctx,
                symbols,
                expressions,
                id,
                prime_for(exp, prime),
                exp.no_commit,
            )?;
        }
        "add" | "sub" | "mul" | "neg" => {
            for value in &exp.values {
                calculate_deps(ctx, symbols, expressions, value, prime)?;
            }
        }
        _ => {}
    }
    Ok(())
}

fn fix_commit_pol(
    reference: &mut CodeRefJson,
    ctx: &CodegenContext,
    symbols: &[FormattedSymbol],
) -> Result<()> {
    let Some(exp_id) = reference.id.map(|id| id as usize) else {
        return Ok(());
    };
    let Some(symbol) = symbols.iter().find(|symbol| {
        symbol.symbol_type == "witness"
            && symbol.exp_id == Some(exp_id as u64)
            && symbol.air_id == Some(ctx.air_id as u64)
            && symbol.airgroup_id == Some(ctx.airgroup_id as u64)
    }) else {
        return Ok(());
    };

    let prime = reference.prime.unwrap_or(0);
    let calculated_cm = ctx
        .calculated
        .borrow()
        .get(&exp_id)
        .and_then(|by_prime| by_prime.get(&prime))
        .is_some_and(|calculated| calculated.cm);

    let use_commit = if symbol.im_pol {
        ctx.dom == Domain::Ext || (symbol.stage.unwrap_or(0) <= ctx.stage && calculated_cm)
    } else {
        !ctx.verifier_evaluations && ctx.dom == Domain::N && calculated_cm
    };

    if use_commit {
        reference.ref_type = "cm".to_string();
        reference.id = symbol.pol_id;
        reference.dim = symbol.dim;
        if ctx.verifier_evaluations {
            fix_eval(reference, ctx)?;
        }
    }
    Ok(())
}

fn fix_eval(reference: &mut CodeRefJson, ctx: &CodegenContext) -> Result<()> {
    let prime = reference.prime.unwrap_or(0);
    let opening_pos = ctx
        .opening_points
        .iter()
        .position(|opening| *opening == prime)
        .with_context(|| format!("opening point {prime} not found"))?;
    let id = reference.id.context("evaluation reference is missing id")?;
    let eval_index = ctx
        .ev_map
        .iter()
        .position(|ev| ev.ev_type == reference.ref_type && ev.id == id && ev.opening_pos == opening_pos)
        .with_context(|| {
            format!(
                "evaluation map entry not found for {} id={} opening={opening_pos}",
                reference.ref_type, id
            )
        })?;
    reference.ref_type = "eval".to_string();
    reference.id = Some(eval_index as u64);
    reference.prime = None;
    reference.dim = FIELD_EXTENSION;
    Ok(())
}

fn build_code(mut ctx: CodegenContext) -> Result<CodeBlockJson> {
    let mut exp_map = HashMap::<(i64, u64), u64>::new();
    let mut tmp_used = ctx.tmp_used;
    for line in &mut ctx.code {
        for src in &mut line.src {
            fix_expression_ref(src, &mut exp_map, &mut tmp_used)?;
        }
        fix_expression_ref(&mut line.dest, &mut exp_map, &mut tmp_used)?;
    }
    ctx.tmp_used = tmp_used;

    if ctx.verifier_evaluations {
        fix_dimensions_verifier(&mut ctx.code)?;
    }

    Ok(CodeBlockJson { tmp_used: ctx.tmp_used, code: ctx.code, line: String::new() })
}

fn fix_expression_ref(
    reference: &mut CodeRefJson,
    exp_map: &mut HashMap<(i64, u64), u64>,
    tmp_used: &mut u64,
) -> Result<()> {
    if reference.ref_type != "exp" {
        return Ok(());
    }
    let prime = reference.prime.unwrap_or(0);
    let id = reference.id.context("expression reference is missing id")?;
    let tmp_id = *exp_map.entry((prime, id)).or_insert_with(|| {
        let id = *tmp_used;
        *tmp_used += 1;
        id
    });
    reference.ref_type = "tmp".to_string();
    reference.id = Some(tmp_id);
    Ok(())
}

fn fix_dimensions_verifier(code: &mut [CodeLineJson]) -> Result<()> {
    let mut tmp_dim = HashMap::<u64, u64>::new();
    for line in code {
        if !matches!(line.op.as_str(), "add" | "sub" | "mul" | "copy") {
            anyhow::bail!("invalid verifier op {}", line.op);
        }
        if line.dest.ref_type != "tmp" {
            anyhow::bail!("invalid verifier destination type {}", line.dest.ref_type);
        }
        let mut dim = 1;
        for src in &mut line.src {
            let src_dim = if src.ref_type == "tmp" {
                src.id.and_then(|id| tmp_dim.get(&id).copied()).unwrap_or(src.dim)
            } else if src.ref_type == "Zi" {
                FIELD_EXTENSION
            } else {
                src.dim
            };
            src.dim = src_dim;
            dim = dim.max(src_dim);
        }
        line.dest.dim = dim;
        if let Some(id) = line.dest.id {
            tmp_dim.insert(id, dim);
        }
    }
    Ok(())
}

fn seed_intermediate_calculations(
    ctx: &mut CodegenContext,
    symbols: &[FormattedSymbol],
    stark_info: &StarkInfoJson,
) {
    for symbol in symbols.iter().filter(|symbol| symbol.im_pol) {
        if let Some(exp_id) = symbol.exp_id {
            let mut calculated = ctx.calculated.borrow_mut();
            let by_prime = calculated.entry(exp_id as usize).or_default();
            for opening in &stark_info.opening_points {
                by_prime.insert(*opening, Calculated { cm: true });
            }
        }
    }
}

fn add_hints_info(
    stark_info: &StarkInfoJson,
    expressions: &mut [FormattedExpression],
    hints: &[FormattedHint],
) -> Result<Vec<HintInfoJson>> {
    let mut out = Vec::with_capacity(hints.len());
    for hint in hints {
        let mut fields = Vec::with_capacity(hint.fields.len());
        for field in &hint.fields {
            let mut values = Vec::new();
            process_hint_values(
                &field.values,
                stark_info,
                expressions,
                &mut Vec::new(),
                &mut values,
            )?;
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

fn process_hint_values(
    values: &[Value],
    stark_info: &StarkInfoJson,
    expressions: &mut [FormattedExpression],
    pos: &mut Vec<usize>,
    out: &mut Vec<Value>,
) -> Result<()> {
    for (idx, value) in values.iter().enumerate() {
        pos.push(idx);
        match value {
            Value::Array(values) => {
                process_hint_values(values, stark_info, expressions, pos, out)?;
            }
            Value::Object(object) => {
                out.push(process_hint_object(object, stark_info, expressions, pos)?);
            }
            Value::Null => {}
            _ => anyhow::bail!("invalid hint value {value}"),
        }
        pos.pop();
    }
    Ok(())
}

fn process_hint_object(
    object: &Map<String, Value>,
    stark_info: &StarkInfoJson,
    expressions: &mut [FormattedExpression],
    pos: &[usize],
) -> Result<Value> {
    let op = object.get("op").and_then(Value::as_str).context("hint value is missing op")?;
    let mut processed = object.clone();
    match op {
        "exp" => {
            let id = object.get("id").and_then(Value::as_u64).context("hint exp missing id")? as usize;
            let line = print_expression(stark_info, expressions, id, false)?;
            let dim = expressions.get(id).and_then(|expression| expression.dim).unwrap_or(1);
            if let Some(expression) = expressions.get_mut(id) {
                expression.line = Some(line);
            }
            processed.clear();
            processed.insert("op".to_string(), Value::String("tmp".to_string()));
            processed.insert("id".to_string(), Value::from(id as u64));
            processed.insert("dim".to_string(), Value::from(dim));
        }
        "cm" | "custom" | "const" => {
            let row_offset = object.get("rowOffset").and_then(Value::as_i64).unwrap_or(0);
            let opening_pos = stark_info
                .opening_points
                .iter()
                .position(|opening| *opening == row_offset)
                .with_context(|| format!("hint opening point {row_offset} not found"))?;
            processed.insert("rowOffsetIndex".to_string(), Value::from(opening_pos as u64));
        }
        "challenge" | "public" | "airgroupvalue" | "airvalue" | "number" | "string"
        | "proofvalue" => {}
        _ => anyhow::bail!("invalid hint op: {op}"),
    }
    processed.insert(
        "pos".to_string(),
        Value::Array(pos.iter().map(|idx| Value::from(*idx as u64)).collect()),
    );
    Ok(Value::Object(processed))
}

fn mark_hint_keeps(expressions: &mut [FormattedExpression], hints: &[FormattedHint]) -> Result<()> {
    for hint in hints {
        for field in &hint.fields {
            mark_hint_value_keeps(expressions, &field.values)?;
        }
    }
    Ok(())
}

fn mark_hint_value_keeps(expressions: &mut [FormattedExpression], values: &[Value]) -> Result<()> {
    for value in values {
        match value {
            Value::Array(values) => mark_hint_value_keeps(expressions, values)?,
            Value::Object(object) => {
                if object.get("op").and_then(Value::as_str) == Some("exp") {
                    let id = object
                        .get("id")
                        .and_then(Value::as_u64)
                        .context("hint exp missing id")? as usize;
                    if let Some(expression) = expressions.get_mut(id) {
                        expression.keep = true;
                    }
                }
            }
            Value::Null => {}
            _ => {}
        }
    }
    Ok(())
}

fn print_expression(
    stark_info: &StarkInfoJson,
    expressions: &[FormattedExpression],
    exp_id: usize,
    is_constraint: bool,
) -> Result<String> {
    let expression =
        expressions.get(exp_id).with_context(|| format!("expression {exp_id} not found"))?;
    print_expression_value(stark_info, expressions, expression, is_constraint)
}

fn print_expression_value(
    stark_info: &StarkInfoJson,
    expressions: &[FormattedExpression],
    expression: &FormattedExpression,
    is_constraint: bool,
) -> Result<String> {
    match expression.op.as_str() {
        "exp" => print_expression(
            stark_info,
            expressions,
            expression.id.context("print exp missing id")? as usize,
            is_constraint,
        ),
        "add" | "sub" | "mul" => {
            let lhs = print_expression_value(
                stark_info,
                expressions,
                expression.values.first().context("print binary missing lhs")?,
                is_constraint,
            )?;
            let rhs = print_expression_value(
                stark_info,
                expressions,
                expression.values.get(1).context("print binary missing rhs")?,
                is_constraint,
            )?;
            let op = match expression.op.as_str() {
                "add" => " + ",
                "sub" => " - ",
                _ => " * ",
            };
            Ok(format!("({lhs}{op}{rhs})"))
        }
        "neg" => print_expression_value(
            stark_info,
            expressions,
            expression.values.first().context("print neg missing value")?,
            is_constraint,
        ),
        "number" => Ok(expression.value.clone().unwrap_or_else(|| "0".to_string())),
        "const" | "cm" | "custom" => print_column(stark_info, expressions, expression, is_constraint),
        "public" => map_name(&stark_info.publics_map, expression.id, "public"),
        "airvalue" => map_name(&stark_info.air_values_map, expression.id, "airvalue"),
        "airgroupvalue" => map_name(&stark_info.airgroup_values_map, expression.id, "airgroupvalue"),
        "challenge" => stark_info
            .challenges_map
            .get(expression.id.unwrap_or(0) as usize)
            .map(|item| item.name.clone())
            .context("challenge name not found"),
        "Zi" => Ok("zh".to_string()),
        "proofvalue" => map_name(&stark_info.proof_values_map, expression.id, "proofvalue"),
        op => anyhow::bail!("unknown expression op for printing: {op}"),
    }
}

fn print_column(
    stark_info: &StarkInfoJson,
    expressions: &[FormattedExpression],
    expression: &FormattedExpression,
    is_constraint: bool,
) -> Result<String> {
    let id = expression.id.context("column expression missing id")? as usize;
    let pol = match expression.op.as_str() {
        "const" => stark_info.const_pols_map.get(id),
        "cm" => stark_info.cm_pols_map.get(id),
        "custom" => expression
            .commit_id
            .and_then(|commit_id| stark_info.custom_commits_map.get(commit_id as usize))
            .and_then(|commit| commit.get(id)),
        _ => None,
    }
    .with_context(|| format!("{} column {id} not found", expression.op))?;

    if pol.im_pol && !is_constraint {
        if let Some(exp_id) = pol.exp_id {
            return print_expression(stark_info, expressions, exp_id as usize, false);
        }
    }

    let mut name = pol.name.clone();
    for index in &pol.lengths {
        name.push_str(&format!("[{index}]"));
    }
    if pol.im_pol {
        let im_index = stark_info
            .cm_pols_map
            .iter()
            .take(id)
            .filter(|pol| pol.im_pol)
            .count();
        name.push_str(&im_index.to_string());
    }
    if let Some(row_offset) = expression.row_offset.filter(|offset| *offset != 0) {
        if row_offset > 0 {
            name.push('\'');
            if row_offset > 1 {
                name.push_str(&row_offset.to_string());
            }
        } else {
            name = format!("'{name}");
            if row_offset < -1 {
                name = format!("{}{name}", row_offset.abs());
            }
        }
    }
    Ok(name)
}

fn map_name(
    values: &[crate::pil_info::stark::NamedMapJson],
    id: Option<u64>,
    label: &str,
) -> Result<String> {
    values
        .get(id.unwrap_or(0) as usize)
        .map(|item| item.name.clone())
        .with_context(|| format!("{label} name not found"))
}

impl CodegenContext {
    fn new(
        stark_info: &StarkInfoJson,
        stage: u64,
        dom: Domain,
        verifier_evaluations: bool,
    ) -> Self {
        Self {
            stage,
            calculated: Rc::new(RefCell::new(HashMap::new())),
            tmp_used: 0,
            code: Vec::new(),
            dom,
            air_id: stark_info.air_id,
            airgroup_id: stark_info.airgroup_id,
            opening_points: stark_info.opening_points.clone(),
            verifier_evaluations,
            ev_map: stark_info.ev_map.clone(),
        }
    }

    fn fork_for_expression(&self) -> Self {
        Self {
            stage: self.stage,
            calculated: Rc::clone(&self.calculated),
            tmp_used: self.tmp_used,
            code: Vec::new(),
            dom: self.dom,
            air_id: self.air_id,
            airgroup_id: self.airgroup_id,
            opening_points: self.opening_points.clone(),
            verifier_evaluations: self.verifier_evaluations,
            ev_map: self.ev_map.clone(),
        }
    }
}

impl CodeRefJson {
    fn new(ref_type: &str, dim: u64) -> Self {
        Self {
            ref_type: ref_type.to_string(),
            exp_id: None,
            id: None,
            prime: None,
            dim,
            stage: None,
            stage_id: None,
            value: None,
            boundary_id: None,
            opening: None,
            commit_id: None,
        }
    }

    fn tmp(id: u64, dim: u64) -> Self {
        let mut result = Self::new("tmp", dim);
        result.id = Some(id);
        result
    }

    fn number(value: &str) -> Self {
        let mut result = Self::new("number", 1);
        result.value = Some(value.to_string());
        result
    }
}

fn prime_for(expression: &FormattedExpression, prime: i64) -> i64 {
    match expression.row_offset {
        Some(0) | None => prime,
        Some(offset) => offset,
    }
}
