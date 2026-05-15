use std::collections::HashMap;
use std::fs::File;
use std::io::{Seek, SeekFrom, Write};
use std::path::Path;

use anyhow::{Context, Result};
use serde_json::Value;

use crate::pil_info::codegen::{
    CodeBlockJson, CodeLineJson, CodeRefJson, ExpressionsInfoJson, GlobalConstraintCodeJson,
    HintInfoJson, VerifierInfoJson,
};
use crate::pil_info::format::FIELD_EXTENSION;
use crate::pil_info::global::GlobalConstraintsJson;
use crate::pil_info::stark::StarkInfoJson;
use crate::pilout_info::GlobalInfoJson;

const CHELPERS_EXPRESSIONS_SECTION: u32 = 1;
const CHELPERS_CONSTRAINTS_DEBUG_SECTION: u32 = 2;
const CHELPERS_HINTS_SECTION: u32 = 3;
const GLOBAL_CONSTRAINTS_SECTION: u32 = 1;
const GLOBAL_HINTS_SECTION: u32 = 2;

#[derive(Debug, Clone)]
struct ExpInfoBin {
    exp_id: u64,
    dest_dim: u64,
    dest_id: u64,
    stage: u64,
    n_temp1: u64,
    n_temp3: u64,
    ops: Vec<u8>,
    args: Vec<u16>,
    line: String,
    first_row: u64,
    last_row: u64,
    im_pol: u64,
}

#[derive(Debug)]
struct PreparedExpressionsBin {
    exps_info: Vec<ExpInfoBin>,
    constraints_info: Vec<ExpInfoBin>,
    hints_info: Vec<HintInfoJson>,
    numbers_exps: Vec<String>,
    numbers_constraints: Vec<String>,
    max_tmp1: u64,
    max_tmp3: u64,
    max_args: u64,
    max_ops: u64,
}

#[derive(Debug)]
struct PreparedVerifierBin {
    exps_info: Vec<ExpInfoBin>,
    numbers_exps: Vec<String>,
    max_tmp1: u64,
    max_tmp3: u64,
    max_args: u64,
    max_ops: u64,
}

#[derive(Debug, Clone, Copy)]
struct OperationShape {
    dest_dim: u64,
    src0_dim: u64,
    src1_dim: u64,
}

#[derive(Debug)]
struct ParserArgs {
    exps_info: ExpInfoBin,
}

pub fn write_expressions_bin_file(
    path: &Path,
    stark_info: &StarkInfoJson,
    expressions_info: &ExpressionsInfoJson,
) -> Result<()> {
    let prepared = prepare_expressions_bin(stark_info, expressions_info)?;
    let mut writer = BinWriter::create(path, "chps", 1, 3)?;
    write_expressions_section(
        &mut writer,
        CHELPERS_EXPRESSIONS_SECTION,
        &prepared.exps_info,
        &prepared.numbers_exps,
        prepared.max_tmp1,
        prepared.max_tmp3,
        prepared.max_args,
        prepared.max_ops,
    )?;
    write_constraints_section(
        &mut writer,
        CHELPERS_CONSTRAINTS_DEBUG_SECTION,
        &prepared.constraints_info,
        &prepared.numbers_constraints,
    )?;
    write_hints_section(&mut writer, CHELPERS_HINTS_SECTION, &prepared.hints_info)?;
    writer.close()
}

pub fn write_verifier_expressions_bin_file(
    path: &Path,
    stark_info: &StarkInfoJson,
    verifier_info: &VerifierInfoJson,
) -> Result<()> {
    let prepared = prepare_verifier_bin(stark_info, verifier_info)?;
    let mut writer = BinWriter::create(path, "chps", 1, 1)?;
    write_expressions_section(
        &mut writer,
        CHELPERS_EXPRESSIONS_SECTION,
        &prepared.exps_info,
        &prepared.numbers_exps,
        prepared.max_tmp1,
        prepared.max_tmp3,
        prepared.max_args,
        prepared.max_ops,
    )?;
    writer.close()
}

pub fn write_global_constraints_bin_file(
    path: &Path,
    global_info: &GlobalInfoJson,
    global_constraints: &GlobalConstraintsJson,
) -> Result<()> {
    let operations = default_operations();
    let mut constraints_info = Vec::with_capacity(global_constraints.constraints.len());
    let mut numbers = Vec::new();

    for constraint in &global_constraints.constraints {
        let parsed = get_parser_args_global(global_info, &operations, constraint, &mut numbers)?;
        let mut info = parsed.exps_info;
        info.line = constraint.line.clone();
        constraints_info.push(info);
    }

    let mut writer = BinWriter::create(path, "chps", 1, 2)?;
    write_global_constraints_section(
        &mut writer,
        GLOBAL_CONSTRAINTS_SECTION,
        &constraints_info,
        &numbers,
    )?;
    write_global_hints_section(&mut writer, GLOBAL_HINTS_SECTION, &global_constraints.hints)?;
    writer.close()
}

fn prepare_expressions_bin(
    stark_info: &StarkInfoJson,
    expressions_info: &ExpressionsInfoJson,
) -> Result<PreparedExpressionsBin> {
    let operations = default_operations();
    let mut exps_info = Vec::new();
    let mut constraints_info = Vec::new();
    let mut numbers_exps = Vec::new();
    let mut numbers_constraints = Vec::new();
    let mut max_tmp1 = 0;
    let mut max_tmp3 = 0;
    let mut max_args = 0;
    let mut max_ops = 0;
    let n = 1u64 << stark_info.stark_struct.n_bits;

    for constraint in &expressions_info.constraints {
        let (first_row, last_row) = match constraint.boundary.as_str() {
            "everyRow" => (0, n),
            "firstRow" | "finalProof" => (0, 1),
            "lastRow" => (n - 1, n),
            "everyFrame" => (
                u64::from(constraint.offset_min.unwrap_or(0)),
                n - u64::from(constraint.offset_max.unwrap_or(0)),
            ),
            boundary => anyhow::bail!("invalid boundary: {boundary}"),
        };
        let parsed =
            get_parser_args(stark_info, &operations, &constraint.block, &mut numbers_constraints)?;
        let mut info = parsed.exps_info;
        info.stage = constraint.stage;
        info.first_row = first_row;
        info.last_row = last_row;
        info.line = constraint.line.clone();
        info.im_pol = constraint.im_pol;
        update_maxima(&info, &mut max_tmp1, &mut max_tmp3, &mut max_args, &mut max_ops);
        constraints_info.push(info);
    }

    for expression in &expressions_info.expressions_code {
        let mut expression = expression.clone();
        if expression.exp_id == stark_info.c_exp_id
            || Some(expression.exp_id) == stark_info.fri_exp_id
            || stark_info.cm_pols_map.iter().any(|pol| pol.exp_id == Some(expression.exp_id as u64))
        {
            let tmp_id = expression.block.tmp_used;
            if let Some(last) = expression.block.code.last_mut() {
                last.dest.ref_type = "tmp".to_string();
                last.dest.id = Some(tmp_id);
            }
            expression.block.tmp_used += 1;
        }
        let parsed =
            get_parser_args(stark_info, &operations, &expression.block, &mut numbers_exps)?;
        let mut info = parsed.exps_info;
        info.exp_id = expression.exp_id as u64;
        info.stage = expression.stage;
        info.line = expression.line;
        update_maxima(&info, &mut max_tmp1, &mut max_tmp3, &mut max_args, &mut max_ops);
        exps_info.push(info);
    }

    Ok(PreparedExpressionsBin {
        exps_info,
        constraints_info,
        hints_info: expressions_info.hints_info.clone(),
        numbers_exps,
        numbers_constraints,
        max_tmp1,
        max_tmp3,
        max_args,
        max_ops,
    })
}

fn prepare_verifier_bin(
    stark_info: &StarkInfoJson,
    verifier_info: &VerifierInfoJson,
) -> Result<PreparedVerifierBin> {
    let operations = default_operations();
    let mut numbers_exps = Vec::new();
    let mut max_tmp1 = 0;
    let mut max_tmp3 = 0;
    let mut max_args = 0;
    let mut max_ops = 0;

    let parsed_q = get_parser_args_verify(
        stark_info,
        &operations,
        &verifier_info.q_verifier,
        &mut numbers_exps,
        true,
    )?;
    let mut q_code = parsed_q.exps_info;
    q_code.exp_id = stark_info.c_exp_id as u64;
    q_code.stage = stark_info.n_stages as u64 + 1;
    update_maxima(&q_code, &mut max_tmp1, &mut max_tmp3, &mut max_args, &mut max_ops);

    let parsed_query = get_parser_args_verify(
        stark_info,
        &operations,
        &verifier_info.query_verifier.block,
        &mut numbers_exps,
        false,
    )?;
    let mut query_code = parsed_query.exps_info;
    query_code.exp_id = stark_info.fri_exp_id.unwrap_or_default() as u64;
    query_code.stage = stark_info.n_stages as u64 + 2;
    update_maxima(&query_code, &mut max_tmp1, &mut max_tmp3, &mut max_args, &mut max_ops);

    Ok(PreparedVerifierBin {
        exps_info: vec![q_code, query_code],
        numbers_exps,
        max_tmp1,
        max_tmp3,
        max_args,
        max_ops,
    })
}

fn get_parser_args(
    stark_info: &StarkInfoJson,
    operations: &[OperationShape],
    code_info: &CodeBlockJson,
    numbers: &mut Vec<String>,
) -> Result<ParserArgs> {
    get_parser_args_inner(stark_info, operations, code_info, numbers, false)
}

fn get_parser_args_verify(
    stark_info: &StarkInfoJson,
    operations: &[OperationShape],
    code_info: &CodeBlockJson,
    numbers: &mut Vec<String>,
    verify: bool,
) -> Result<ParserArgs> {
    get_parser_args_inner(stark_info, operations, code_info, numbers, verify)
}

fn get_parser_args_global(
    global_info: &GlobalInfoJson,
    operations: &[OperationShape],
    constraint: &GlobalConstraintCodeJson,
    numbers: &mut Vec<String>,
) -> Result<ParserArgs> {
    let mut ops = Vec::new();
    let mut args = Vec::new();
    let id_maps = get_id_maps(&constraint.block.code)?;

    for line in &constraint.block.code {
        let operation = get_operation(line, false)?;
        args.push(operation_type_id(&operation.op)?);
        push_args_global(&mut args, &line.dest, &id_maps, numbers, global_info, true)?;
        for src in &operation.src {
            push_args_global(&mut args, src, &id_maps, numbers, global_info, false)?;
        }
        let ops_index = operations
            .iter()
            .position(|shape| {
                shape.dest_dim == operation.dest_dim
                    && shape.src0_dim == operation.src0_dim
                    && shape.src1_dim == operation.src1_dim
            })
            .with_context(|| format!("global operation not considered: {:?}", operation))?;
        ops.push(ops_index as u8);
    }

    let dest = constraint.block.code.last().context("empty global constraint code")?.dest.clone();
    let (dest_dim, dest_id) = if dest.dim == 1 {
        (1, id_maps.id1d.get(&dest.id.unwrap_or(0)).copied().unwrap_or(0))
    } else if dest.dim == FIELD_EXTENSION {
        (FIELD_EXTENSION, id_maps.id3d.get(&dest.id.unwrap_or(0)).copied().unwrap_or(0))
    } else {
        anyhow::bail!("unknown global destination dimension {}", dest.dim);
    };

    Ok(ParserArgs {
        exps_info: ExpInfoBin {
            exp_id: 0,
            dest_dim,
            dest_id,
            stage: 0,
            n_temp1: id_maps.count1d,
            n_temp3: id_maps.count3d,
            ops,
            args,
            line: String::new(),
            first_row: 0,
            last_row: 0,
            im_pol: 0,
        },
    })
}

fn get_parser_args_inner(
    stark_info: &StarkInfoJson,
    operations: &[OperationShape],
    code_info: &CodeBlockJson,
    numbers: &mut Vec<String>,
    _verify: bool,
) -> Result<ParserArgs> {
    let mut ops = Vec::new();
    let mut args = Vec::new();
    let id_maps = get_id_maps(&code_info.code)?;

    for line in &code_info.code {
        let operation = get_operation(line, true)?;
        args.push(operation_type_id(&operation.op)?);
        push_args(stark_info, &mut args, &line.dest, &id_maps, numbers, true)?;
        for src in &operation.src {
            push_args(stark_info, &mut args, src, &id_maps, numbers, false)?;
        }
        let ops_index = operations
            .iter()
            .position(|shape| {
                shape.dest_dim == operation.dest_dim
                    && shape.src0_dim == operation.src0_dim
                    && shape.src1_dim == operation.src1_dim
            })
            .with_context(|| format!("operation not considered: {:?}", operation))?;
        ops.push(ops_index as u8);
    }

    let dest = code_info.code.last().context("empty expression code")?.dest.clone();
    let (dest_dim, dest_id) = if dest.dim == 1 {
        (1, id_maps.id1d.get(&dest.id.unwrap_or(0)).copied().unwrap_or(0))
    } else if dest.dim == FIELD_EXTENSION {
        (FIELD_EXTENSION, id_maps.id3d.get(&dest.id.unwrap_or(0)).copied().unwrap_or(0))
    } else {
        anyhow::bail!("unknown destination dimension {}", dest.dim);
    };

    Ok(ParserArgs {
        exps_info: ExpInfoBin {
            exp_id: 0,
            dest_dim,
            dest_id,
            stage: 0,
            n_temp1: id_maps.count1d,
            n_temp3: id_maps.count3d,
            ops,
            args,
            line: String::new(),
            first_row: 0,
            last_row: 0,
            im_pol: 0,
        },
    })
}

#[derive(Debug)]
struct OperationRef {
    op: String,
    src: Vec<CodeRefJson>,
    dest_dim: u64,
    src0_dim: u64,
    src1_dim: u64,
}

fn get_operation(line: &CodeLineJson, cxx_sub_swap: bool) -> Result<OperationRef> {
    let mut src = line.src.clone();
    let mut op = line.op.clone();
    src.sort_by(|lhs, rhs| {
        let op_l = operation_order(lhs).unwrap_or(0);
        let op_r = operation_order(rhs).unwrap_or(0);
        let swap = if lhs.dim != rhs.dim {
            (rhs.dim as i64) - (lhs.dim as i64)
        } else {
            (op_l as i64) - (op_r as i64)
        };
        swap.cmp(&0)
    });
    if op == "sub" && line.src.len() == 2 {
        let lhs = &line.src[0];
        let rhs = &line.src[1];
        let op_l = operation_order(lhs)?;
        let op_r = operation_order(rhs)?;
        let swap = if lhs.dim != rhs.dim {
            (rhs.dim as i64) - (lhs.dim as i64)
        } else {
            (op_l as i64) - (op_r as i64)
        };
        if (cxx_sub_swap && swap > 0) || (!cxx_sub_swap && swap < 0) {
            op = "sub_swap".to_string();
        }
    }
    let src0 = src.first().context("operation missing src0")?;
    let src1 = src.get(1).context("operation missing src1")?;
    Ok(OperationRef { op, dest_dim: line.dest.dim, src0_dim: src0.dim, src1_dim: src1.dim, src })
}

fn push_args(
    stark_info: &StarkInfoJson,
    args: &mut Vec<u16>,
    reference: &CodeRefJson,
    id_maps: &IdMaps,
    numbers: &mut Vec<String>,
    dest: bool,
) -> Result<()> {
    if dest && reference.ref_type != "tmp" {
        anyhow::bail!("invalid destination reference type {}", reference.ref_type);
    }
    let buffer_size = 1 + stark_info.n_stages as u64 + 3 + stark_info.custom_commits.len() as u64;
    match reference.ref_type.as_str() {
        "tmp" => {
            if reference.dim == 1 {
                if !dest {
                    push_u16(args, buffer_size)?;
                }
                push_u16(args, id_maps.id1d.get(&reference.id.unwrap_or(0)).copied().unwrap_or(0))?;
            } else {
                if !dest {
                    push_u16(args, buffer_size + 1)?;
                }
                push_u16(
                    args,
                    FIELD_EXTENSION
                        * id_maps.id3d.get(&reference.id.unwrap_or(0)).copied().unwrap_or(0),
                )?;
            }
            if !dest {
                args.push(0);
            }
        }
        "const" => {
            let prime_index = opening_index(stark_info, reference.prime.unwrap_or(0))?;
            args.push(0);
            push_u16(args, reference.id.unwrap_or(0))?;
            push_u16(args, prime_index as u64)?;
        }
        "custom" => {
            let prime_index = opening_index(stark_info, reference.prime.unwrap_or(0))?;
            push_u16(args, stark_info.n_stages as u64 + 4 + reference.commit_id.unwrap_or(0))?;
            push_u16(args, reference.id.unwrap_or(0))?;
            push_u16(args, prime_index as u64)?;
        }
        "cm" => {
            let prime_index = opening_index(stark_info, reference.prime.unwrap_or(0))?;
            let pol = stark_info
                .cm_pols_map
                .get(reference.id.unwrap_or(0) as usize)
                .context("cm reference id not found")?;
            push_u16(args, pol.stage)?;
            push_u16(args, pol.stage_pos.unwrap_or(0))?;
            push_u16(args, prime_index as u64)?;
        }
        "number" => {
            let value = normalize_number(reference.value.as_deref().unwrap_or("0"))?;
            if !numbers.contains(&value) {
                numbers.push(value.clone());
            }
            push_u16(args, buffer_size + 3)?;
            push_u16(args, numbers.iter().position(|item| item == &value).unwrap() as u64)?;
            args.push(0);
        }
        "public" => {
            push_u16(args, buffer_size + 2)?;
            push_u16(args, reference.id.unwrap_or(0))?;
            args.push(0);
        }
        "eval" => {
            push_u16(args, buffer_size + 8)?;
            push_u16(args, FIELD_EXTENSION * reference.id.unwrap_or(0))?;
            args.push(0);
        }
        "airvalue" => {
            push_u16(args, buffer_size + 4)?;
            push_u16(args, value_position(reference.id.unwrap_or(0), &stark_info.air_values_map))?;
            args.push(0);
        }
        "proofvalue" => {
            push_u16(args, buffer_size + 5)?;
            push_u16(
                args,
                value_position(reference.id.unwrap_or(0), &stark_info.proof_values_map),
            )?;
            args.push(0);
        }
        "challenge" => {
            push_u16(args, buffer_size + 7)?;
            push_u16(args, FIELD_EXTENSION * reference.id.unwrap_or(0))?;
            args.push(0);
        }
        "airgroupvalue" => {
            push_u16(args, buffer_size + 6)?;
            push_u16(
                args,
                value_position(reference.id.unwrap_or(0), &stark_info.airgroup_values_map),
            )?;
            args.push(0);
        }
        "xDivXSubXi" => {
            push_u16(args, stark_info.n_stages as u64 + 3)?;
            push_u16(args, reference.id.unwrap_or(0))?;
            args.push(0);
        }
        "Zi" => {
            push_u16(args, stark_info.n_stages as u64 + 2)?;
            push_u16(args, 1 + reference.boundary_id.unwrap_or(0))?;
            args.push(0);
        }
        other => anyhow::bail!("unknown parser argument type {other}"),
    }
    Ok(())
}

fn push_args_global(
    args: &mut Vec<u16>,
    reference: &CodeRefJson,
    id_maps: &IdMaps,
    numbers: &mut Vec<String>,
    global_info: &GlobalInfoJson,
    dest: bool,
) -> Result<()> {
    if dest && reference.ref_type != "tmp" {
        anyhow::bail!("invalid global destination reference type {}", reference.ref_type);
    }
    match reference.ref_type.as_str() {
        "tmp" => {
            if reference.dim == 1 {
                if !dest {
                    args.push(0);
                }
                push_u16(args, id_maps.id1d.get(&reference.id.unwrap_or(0)).copied().unwrap_or(0))?;
            } else if reference.dim == FIELD_EXTENSION {
                if !dest {
                    args.push(4);
                }
                push_u16(
                    args,
                    FIELD_EXTENSION
                        * id_maps.id3d.get(&reference.id.unwrap_or(0)).copied().unwrap_or(0),
                )?;
            } else {
                anyhow::bail!("invalid global tmp dimension {}", reference.dim);
            }
        }
        "number" => {
            let value = normalize_number(reference.value.as_deref().unwrap_or("0"))?;
            if !numbers.contains(&value) {
                numbers.push(value.clone());
            }
            args.push(2);
            push_u16(args, numbers.iter().position(|item| item == &value).unwrap() as u64)?;
        }
        "public" => {
            args.push(1);
            push_u16(args, reference.id.unwrap_or(0))?;
        }
        "proofvalue" => {
            args.push(3);
            push_u16(args, global_proof_value_position(reference.id.unwrap_or(0), global_info))?;
        }
        "airgroupvalue" => {
            args.push(5);
            let airgroup_id = reference
                .airgroup_id
                .context("global airgroupvalue reference missing airgroupId")?;
            let offset = global_info
                .agg_types
                .iter()
                .take(airgroup_id as usize)
                .map(|values| FIELD_EXTENSION * values.len() as u64)
                .sum::<u64>();
            push_u16(args, offset + FIELD_EXTENSION * reference.id.unwrap_or(0))?;
        }
        "challenge" => {
            args.push(6);
            push_u16(args, FIELD_EXTENSION * reference.id.unwrap_or(0))?;
        }
        other => anyhow::bail!("unknown global parser argument type {other}"),
    }
    Ok(())
}

fn global_proof_value_position(id: u64, global_info: &GlobalInfoJson) -> u64 {
    global_info
        .proof_values_map
        .iter()
        .take(id as usize)
        .map(|value| if value.stage == 1 { 1 } else { FIELD_EXTENSION })
        .sum()
}

fn value_position(id: u64, values: &[crate::pil_info::stark::NamedMapJson]) -> u64 {
    values
        .iter()
        .take(id as usize)
        .map(|value| if value.stage == 1 { 1 } else { FIELD_EXTENSION })
        .sum()
}

fn opening_index(stark_info: &StarkInfoJson, prime: i64) -> Result<usize> {
    stark_info
        .opening_points
        .iter()
        .position(|opening| *opening == prime)
        .with_context(|| format!("opening point {prime} not found"))
}

fn push_u16(args: &mut Vec<u16>, value: u64) -> Result<()> {
    args.push(value.try_into().with_context(|| format!("parser arg {value} overflows u16"))?);
    Ok(())
}

fn operation_type_id(op: &str) -> Result<u16> {
    match op {
        "add" => Ok(0),
        "sub" => Ok(1),
        "mul" => Ok(2),
        "sub_swap" => Ok(3),
        other => anyhow::bail!("unsupported operation type {other}"),
    }
}

fn operation_order(reference: &CodeRefJson) -> Result<u64> {
    let key = match reference.ref_type.as_str() {
        "cm" => format!("commit{}", reference.dim),
        "airvalue" | "proofvalue" | "tmp" | "custom" => {
            format!("{}{}", reference.ref_type, reference.dim)
        }
        other => other.to_string(),
    };
    match key.as_str() {
        "commit1" | "Zi" | "const" | "custom1" => Ok(0),
        "tmp1" => Ok(1),
        "public" => Ok(2),
        "number" => Ok(3),
        "airvalue1" => Ok(4),
        "proofvalue1" => Ok(5),
        "custom3" | "commit3" | "xDivXSubXi" => Ok(6),
        "tmp3" => Ok(7),
        "airvalue3" => Ok(8),
        "airgroupvalue" => Ok(9),
        "proofvalue" | "proofvalue3" => Ok(10),
        "challenge" => Ok(11),
        "eval" => Ok(12),
        other => anyhow::bail!("unknown operation order type {other}"),
    }
}

fn default_operations() -> Vec<OperationShape> {
    vec![
        OperationShape { dest_dim: 1, src0_dim: 1, src1_dim: 1 },
        OperationShape { dest_dim: FIELD_EXTENSION, src0_dim: FIELD_EXTENSION, src1_dim: 1 },
        OperationShape {
            dest_dim: FIELD_EXTENSION,
            src0_dim: FIELD_EXTENSION,
            src1_dim: FIELD_EXTENSION,
        },
    ]
}

#[derive(Default)]
struct IdMaps {
    id1d: HashMap<u64, u64>,
    id3d: HashMap<u64, u64>,
    count1d: u64,
    count3d: u64,
}

#[derive(Debug, Clone, Copy)]
struct Segment {
    start: usize,
    end: usize,
    id: u64,
}

fn get_id_maps(code: &[CodeLineJson]) -> Result<IdMaps> {
    let mut ini1d = HashMap::<u64, usize>::new();
    let mut end1d = HashMap::<u64, usize>::new();
    let mut ini3d = HashMap::<u64, usize>::new();
    let mut end3d = HashMap::<u64, usize>::new();

    for (idx, line) in code.iter().enumerate() {
        visit_tmp(&line.dest, idx, &mut ini1d, &mut end1d, &mut ini3d, &mut end3d)?;
        for src in &line.src {
            visit_tmp(src, idx, &mut ini1d, &mut end1d, &mut ini3d, &mut end3d)?;
        }
    }

    let segments1d = collect_segments(&ini1d, &end1d);
    let segments3d = collect_segments(&ini3d, &end3d);
    let mut maps = IdMaps::default();
    assign_segments(&segments1d, &mut maps.id1d, &mut maps.count1d);
    assign_segments(&segments3d, &mut maps.id3d, &mut maps.count3d);
    Ok(maps)
}

fn visit_tmp(
    reference: &CodeRefJson,
    idx: usize,
    ini1d: &mut HashMap<u64, usize>,
    end1d: &mut HashMap<u64, usize>,
    ini3d: &mut HashMap<u64, usize>,
    end3d: &mut HashMap<u64, usize>,
) -> Result<()> {
    if reference.ref_type != "tmp" {
        return Ok(());
    }
    let id = reference.id.context("tmp reference missing id")?;
    let (ini, end) = if reference.dim == 1 {
        (ini1d, end1d)
    } else if reference.dim == FIELD_EXTENSION {
        (ini3d, end3d)
    } else {
        anyhow::bail!("invalid tmp dimension {}", reference.dim);
    };
    ini.entry(id).or_insert(idx);
    end.insert(id, idx);
    Ok(())
}

fn collect_segments(ini: &HashMap<u64, usize>, end: &HashMap<u64, usize>) -> Vec<Segment> {
    ini.iter()
        .filter_map(|(id, start)| {
            end.get(id).map(|end| Segment { start: *start, end: *end, id: *id })
        })
        .collect()
}

fn assign_segments(segments: &[Segment], ids: &mut HashMap<u64, u64>, count: &mut u64) {
    let mut segments = segments.to_vec();
    segments.sort_by_key(|segment| (segment.end, segment.id));
    let mut subsets: Vec<Vec<Segment>> = Vec::new();
    for segment in segments {
        let mut closest = None;
        let mut min_distance = usize::MAX;
        for (idx, subset) in subsets.iter().enumerate() {
            let last = subset.last().copied().expect("subset is not empty");
            if is_intersecting(segment, last) {
                continue;
            }
            let distance = last.end.abs_diff(segment.start);
            if distance < min_distance {
                min_distance = distance;
                closest = Some(idx);
            }
        }
        if let Some(idx) = closest {
            subsets[idx].push(segment);
        } else {
            subsets.push(vec![segment]);
        }
    }
    for subset in subsets {
        for segment in subset {
            ids.insert(segment.id, *count);
        }
        *count += 1;
    }
}

fn is_intersecting(lhs: Segment, rhs: Segment) -> bool {
    rhs.start < lhs.end && lhs.start < rhs.end
}

fn update_maxima(
    info: &ExpInfoBin,
    max_tmp1: &mut u64,
    max_tmp3: &mut u64,
    max_args: &mut u64,
    max_ops: &mut u64,
) {
    *max_tmp1 = (*max_tmp1).max(info.n_temp1);
    *max_tmp3 = (*max_tmp3).max(info.n_temp3);
    *max_args = (*max_args).max(info.args.len() as u64);
    *max_ops = (*max_ops).max(info.ops.len() as u64);
}

fn normalize_number(value: &str) -> Result<String> {
    let parsed = value.parse::<i128>().with_context(|| format!("invalid number {value}"))?;
    if parsed < 0 {
        Ok((parsed + 0xFFFF_FFFF_0000_0001u128 as i128).to_string())
    } else {
        Ok(parsed.to_string())
    }
}

fn write_expressions_section(
    writer: &mut BinWriter,
    section: u32,
    expressions_info: &[ExpInfoBin],
    numbers_exps: &[String],
    max_tmp1: u64,
    max_tmp3: u64,
    max_args: u64,
    max_ops: u64,
) -> Result<()> {
    writer.start_section(section)?;
    let mut ops_expressions = Vec::new();
    let mut args_expressions = Vec::new();
    let mut ops_offsets = Vec::new();
    let mut args_offsets = Vec::new();

    for info in expressions_info {
        ops_offsets.push(ops_expressions.len() as u64);
        args_offsets.push(args_expressions.len() as u64);
        ops_expressions.extend(info.ops.iter().copied());
        args_expressions.extend(info.args.iter().copied());
    }

    writer.write_u32(max_tmp1)?;
    writer.write_u32(max_tmp3)?;
    writer.write_u32(max_args)?;
    writer.write_u32(max_ops)?;
    writer.write_u32(ops_expressions.len() as u64)?;
    writer.write_u32(args_expressions.len() as u64)?;
    writer.write_u32(numbers_exps.len() as u64)?;
    writer.write_u32(expressions_info.len() as u64)?;

    for (idx, info) in expressions_info.iter().enumerate() {
        writer.write_u32(info.exp_id)?;
        writer.write_u32(info.dest_dim)?;
        writer.write_u32(info.dest_id)?;
        writer.write_u32(info.stage)?;
        writer.write_u32(info.n_temp1)?;
        writer.write_u32(info.n_temp3)?;
        writer.write_u32(info.ops.len() as u64)?;
        writer.write_u32(ops_offsets[idx])?;
        writer.write_u32(info.args.len() as u64)?;
        writer.write_u32(args_offsets[idx])?;
        writer.write_string(&info.line)?;
    }

    for op in ops_expressions {
        writer.write_u8(op)?;
    }
    for arg in args_expressions {
        writer.write_u16(arg)?;
    }
    for number in numbers_exps {
        writer.write_u64(number.parse::<u64>()?)?;
    }
    writer.end_section()
}

fn write_constraints_section(
    writer: &mut BinWriter,
    section: u32,
    constraints_info: &[ExpInfoBin],
    numbers_constraints: &[String],
) -> Result<()> {
    writer.start_section(section)?;
    let mut ops_debug = Vec::new();
    let mut args_debug = Vec::new();
    let mut ops_offsets = Vec::new();
    let mut args_offsets = Vec::new();

    for info in constraints_info {
        ops_offsets.push(ops_debug.len() as u64);
        args_offsets.push(args_debug.len() as u64);
        ops_debug.extend(info.ops.iter().copied());
        args_debug.extend(info.args.iter().copied());
    }

    writer.write_u32(ops_debug.len() as u64)?;
    writer.write_u32(args_debug.len() as u64)?;
    writer.write_u32(numbers_constraints.len() as u64)?;
    writer.write_u32(constraints_info.len() as u64)?;

    for (idx, info) in constraints_info.iter().enumerate() {
        writer.write_u32(info.stage)?;
        writer.write_u32(info.dest_dim)?;
        writer.write_u32(info.dest_id)?;
        writer.write_u32(info.first_row)?;
        writer.write_u32(info.last_row)?;
        writer.write_u32(info.n_temp1)?;
        writer.write_u32(info.n_temp3)?;
        writer.write_u32(info.ops.len() as u64)?;
        writer.write_u32(ops_offsets[idx])?;
        writer.write_u32(info.args.len() as u64)?;
        writer.write_u32(args_offsets[idx])?;
        writer.write_u32(info.im_pol)?;
        writer.write_string(&info.line)?;
    }

    for op in ops_debug {
        writer.write_u8(op)?;
    }
    for arg in args_debug {
        writer.write_u16(arg)?;
    }
    for number in numbers_constraints {
        writer.write_u64(number.parse::<u64>()?)?;
    }
    writer.end_section()
}

fn write_global_constraints_section(
    writer: &mut BinWriter,
    section: u32,
    constraints_info: &[ExpInfoBin],
    numbers_constraints: &[String],
) -> Result<()> {
    writer.start_section(section)?;
    let mut ops_debug = Vec::new();
    let mut args_debug = Vec::new();
    let mut ops_offsets = Vec::new();
    let mut args_offsets = Vec::new();

    for info in constraints_info {
        ops_offsets.push(ops_debug.len() as u64);
        args_offsets.push(args_debug.len() as u64);
        ops_debug.extend(info.ops.iter().copied());
        args_debug.extend(info.args.iter().copied());
    }

    writer.write_u32(ops_debug.len() as u64)?;
    writer.write_u32(args_debug.len() as u64)?;
    writer.write_u32(numbers_constraints.len() as u64)?;
    writer.write_u32(constraints_info.len() as u64)?;

    for (idx, info) in constraints_info.iter().enumerate() {
        writer.write_u32(info.dest_dim)?;
        writer.write_u32(info.dest_id)?;
        writer.write_u32(info.n_temp1)?;
        writer.write_u32(info.n_temp3)?;
        writer.write_u32(info.ops.len() as u64)?;
        writer.write_u32(ops_offsets[idx])?;
        writer.write_u32(info.args.len() as u64)?;
        writer.write_u32(args_offsets[idx])?;
        writer.write_string(&info.line)?;
    }

    for op in ops_debug {
        writer.write_u8(op)?;
    }
    for arg in args_debug {
        writer.write_u16(arg)?;
    }
    for number in numbers_constraints {
        writer.write_u64(number.parse::<u64>()?)?;
    }
    writer.end_section()
}

fn write_hints_section(
    writer: &mut BinWriter,
    section: u32,
    hints_info: &[HintInfoJson],
) -> Result<()> {
    writer.start_section(section)?;
    writer.write_u32(hints_info.len() as u64)?;
    for hint in hints_info {
        writer.write_string(&hint.name)?;
        writer.write_u32(hint.fields.len() as u64)?;
        for field in &hint.fields {
            writer.write_string(&field.name)?;
            writer.write_u32(field.values.len() as u64)?;
            for value in &field.values {
                write_hint_value(writer, value)?;
            }
        }
    }
    writer.end_section()
}

fn write_hint_value(writer: &mut BinWriter, value: &Value) -> Result<()> {
    let object = value.as_object().context("hint value must be object")?;
    let op = object.get("op").and_then(Value::as_str).context("hint value missing op")?;
    writer.write_string(op)?;
    match op {
        "number" => {
            let number =
                object.get("value").and_then(Value::as_str).context("number hint missing value")?;
            writer.write_u64(normalize_number(number)?.parse::<u64>()?)?;
        }
        "string" => {
            let string = object.get("string").and_then(Value::as_str).unwrap_or_default();
            writer.write_string(string)?;
        }
        _ => writer.write_u32(object.get("id").and_then(Value::as_u64).unwrap_or(0))?,
    }
    if matches!(op, "custom" | "const" | "cm") {
        writer.write_u32(object.get("rowOffsetIndex").and_then(Value::as_u64).unwrap_or(0))?;
    }
    if op == "tmp" {
        writer.write_u32(object.get("dim").and_then(Value::as_u64).unwrap_or(1))?;
    }
    if op == "custom" {
        writer.write_u32(object.get("commitId").and_then(Value::as_u64).unwrap_or(0))?;
    }
    let pos = object.get("pos").and_then(Value::as_array).map(Vec::as_slice).unwrap_or(&[]);
    writer.write_u32(pos.len() as u64)?;
    for value in pos {
        writer.write_u32(value.as_u64().unwrap_or(0))?;
    }
    Ok(())
}

fn write_global_hints_section(
    writer: &mut BinWriter,
    section: u32,
    hints_info: &[HintInfoJson],
) -> Result<()> {
    writer.start_section(section)?;
    writer.write_u32(hints_info.len() as u64)?;
    for hint in hints_info {
        writer.write_string(&hint.name)?;
        writer.write_u32(hint.fields.len() as u64)?;
        for field in &hint.fields {
            writer.write_string(&field.name)?;
            writer.write_u32(field.values.len() as u64)?;
            for value in &field.values {
                write_global_hint_value(writer, value)?;
            }
        }
    }
    writer.end_section()
}

fn write_global_hint_value(writer: &mut BinWriter, value: &Value) -> Result<()> {
    let object = value.as_object().context("global hint value must be object")?;
    let op = object.get("op").and_then(Value::as_str).context("global hint value missing op")?;
    writer.write_string(op)?;
    match op {
        "number" => {
            let number = object
                .get("value")
                .and_then(Value::as_str)
                .context("number global hint missing value")?;
            writer.write_u64(normalize_number(number)?.parse::<u64>()?)?;
        }
        "string" => {
            let string = object.get("string").and_then(Value::as_str).unwrap_or_default();
            writer.write_string(string)?;
        }
        "airgroupvalue" => {
            writer.write_u32(object.get("airgroupId").and_then(Value::as_u64).unwrap_or(0))?;
            writer.write_u32(object.get("id").and_then(Value::as_u64).unwrap_or(0))?;
        }
        "tmp" | "public" | "proofvalue" => {
            writer.write_u32(object.get("id").and_then(Value::as_u64).unwrap_or(0))?;
        }
        other => anyhow::bail!("unknown global hint operand {other}"),
    }
    let pos = object.get("pos").and_then(Value::as_array).map(Vec::as_slice).unwrap_or(&[]);
    writer.write_u32(pos.len() as u64)?;
    for value in pos {
        writer.write_u32(value.as_u64().unwrap_or(0))?;
    }
    Ok(())
}

struct BinWriter {
    file: File,
    section_start: Option<u64>,
}

impl BinWriter {
    fn create(path: &Path, file_type: &str, version: u32, n_sections: u32) -> Result<Self> {
        let mut file =
            File::create(path).with_context(|| format!("failed to create {}", path.display()))?;
        let bytes = file_type.as_bytes();
        if bytes.len() != 4 {
            anyhow::bail!("bin file type must be 4 bytes");
        }
        file.write_all(bytes)?;
        file.write_all(&version.to_le_bytes())?;
        file.write_all(&n_sections.to_le_bytes())?;
        Ok(Self { file, section_start: None })
    }

    fn start_section(&mut self, section: u32) -> Result<()> {
        if self.section_start.is_some() {
            anyhow::bail!("already writing a section");
        }
        let start = self.file.stream_position()?;
        self.section_start = Some(start);
        self.file.write_all(&section.to_le_bytes())?;
        self.file.write_all(&0u64.to_le_bytes())?;
        Ok(())
    }

    fn end_section(&mut self) -> Result<()> {
        let start = self.section_start.take().context("not writing a section")?;
        let current = self.file.stream_position()?;
        let size = current - start - 12;
        self.file.seek(SeekFrom::Start(start + 4))?;
        self.file.write_all(&size.to_le_bytes())?;
        self.file.seek(SeekFrom::Start(current))?;
        Ok(())
    }

    fn close(mut self) -> Result<()> {
        self.file.flush()?;
        Ok(())
    }

    fn write_u8(&mut self, value: u8) -> Result<()> {
        self.file.write_all(&[value])?;
        Ok(())
    }

    fn write_u16(&mut self, value: u16) -> Result<()> {
        self.file.write_all(&value.to_le_bytes())?;
        Ok(())
    }

    fn write_u32(&mut self, value: u64) -> Result<()> {
        let value: u32 = value.try_into().with_context(|| format!("{value} overflows u32"))?;
        self.file.write_all(&value.to_le_bytes())?;
        Ok(())
    }

    fn write_u64(&mut self, value: u64) -> Result<()> {
        self.file.write_all(&value.to_le_bytes())?;
        Ok(())
    }

    fn write_string(&mut self, value: &str) -> Result<()> {
        self.file.write_all(value.as_bytes())?;
        self.file.write_all(&[0])?;
        Ok(())
    }
}
