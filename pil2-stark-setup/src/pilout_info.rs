use indexmap::IndexMap;

use pilout::pilout::{
    self as pb,
    constraint,
    expression as expr_mod,
    hint_field,
    operand,
    SymbolType,
};

use crate::expression::{ExprChild, Expression, ExpressionArena};

/// Constant for field extension dimension (Goldilocks cubic extension).
pub const FIELD_EXTENSION: usize = 3;

// ---------------------------------------------------------------------------
// Intermediate result types
// ---------------------------------------------------------------------------

/// A formatted constraint extracted from the protobuf.
#[derive(Debug, Clone)]
pub struct ConstraintInfo {
    pub boundary: String,
    pub e: usize,
    pub line: Option<String>,
    pub offset_min: Option<u32>,
    pub offset_max: Option<u32>,
    pub stage: Option<usize>,
    pub im_pol: bool,
}

/// A formatted symbol extracted from the protobuf.
#[derive(Debug, Clone)]
pub struct SymbolInfo {
    pub name: String,
    pub sym_type: String,
    pub stage: Option<usize>,
    pub dim: usize,
    pub id: Option<usize>,
    pub pol_id: Option<usize>,
    pub stage_id: Option<usize>,
    pub air_id: Option<usize>,
    pub airgroup_id: Option<usize>,
    pub commit_id: Option<usize>,
    pub lengths: Option<Vec<usize>>,
    pub idx: Option<usize>,
    pub stage_pos: Option<usize>,
    pub im_pol: bool,
    pub exp_id: Option<usize>,
}

/// A single hint field value (leaf or nested array).
#[derive(Debug, Clone)]
pub enum HintFieldValue {
    /// A leaf: an expression node (op="exp", op="string", etc.)
    Single(Expression),
    /// A nested array of hint field values
    Array(Vec<HintFieldValue>),
}

/// A named hint field with value(s) and optional dimension lengths.
#[derive(Debug, Clone)]
pub struct HintFieldEntry {
    pub name: String,
    pub values: Vec<HintFieldValue>,
    pub lengths: Option<Vec<usize>>,
}

/// A formatted hint.
#[derive(Debug, Clone)]
pub struct HintInfo {
    pub name: String,
    pub fields: Vec<HintFieldEntry>,
}

/// Custom commit metadata.
#[derive(Debug, Clone)]
pub struct CustomCommitInfo {
    pub name: String,
    pub stage_widths: Vec<u32>,
}

/// Aggregate result from `get_pilout_info`.
#[derive(Debug)]
pub struct SetupResult {
    pub name: String,
    pub air_id: usize,
    pub airgroup_id: usize,

    pub pil_power: u32,
    pub n_stages: usize,
    pub n_constants: usize,
    pub n_publics: usize,
    pub n_commitments: usize,

    pub cm_pols_map: Vec<SymbolInfo>,
    pub const_pols_map: Vec<SymbolInfo>,
    pub challenges_map: Vec<SymbolInfo>,
    pub publics_map: Vec<SymbolInfo>,
    pub proof_values_map: Vec<SymbolInfo>,
    pub airgroup_values_map: Vec<SymbolInfo>,
    pub air_values_map: Vec<SymbolInfo>,

    pub map_sections_n: IndexMap<String, usize>,

    pub custom_commits: Vec<CustomCommitInfo>,
    pub custom_commits_map: Vec<Vec<SymbolInfo>>,
    pub air_group_values: Vec<pb::AirGroupValue>,

    pub expressions: Vec<Expression>,
    pub constraints: Vec<ConstraintInfo>,
    pub symbols: Vec<SymbolInfo>,
    pub hints: Vec<HintInfo>,

    /// Number of witness columns in stage 1 that are not intermediate polynomials.
    pub n_commitments_stage1: usize,
    /// Intermediate polynomial expression strings: (base_field, extended_field).
    pub im_pols_info: (Vec<String>, Vec<String>),
}

// ---------------------------------------------------------------------------
// Byte buffer -> big-integer string (mirrors JS `ProtoOut.buf2bint`)
// ---------------------------------------------------------------------------

/// Convert a big-endian byte buffer to a decimal string.
fn buf_to_bigint_string(buf: &[u8]) -> String {
    if buf.is_empty() {
        return "0".to_string();
    }
    let mut value: u128 = 0;
    for &b in buf {
        value = (value << 8) | (b as u128);
    }
    value.to_string()
}

// ---------------------------------------------------------------------------
// Arena-based expression formatting context
// ---------------------------------------------------------------------------

/// Context for converting protobuf expressions into arena-indexed Expressions.
struct FormatCtx<'a> {
    air_expressions: &'a [pb::Expression],
    stage_widths: &'a [u32],
    num_challenges: &'a [u32],
    air_values: &'a [pb::AirValue],
    air_group_values: &'a [pb::AirGroupValue],
    custom_commits: &'a [pb::CustomCommit],
    arena: Vec<Expression>,
}

impl<'a> FormatCtx<'a> {
    /// Format a protobuf Operand into an inline Expression (not pushed to arena).
    /// Matches JS behavior where child operands are inline objects.
    fn format_operand_inline(&mut self, op: &operand::Operand) -> Expression {
        match op {
            operand::Operand::Expression(expr_ref) => {
                let id = expr_ref.idx as usize;
                // Optimization: unwrap add/sub(X, 0) where LHS is not an expression ref
                if let Some(inner_expr) = self.air_expressions.get(id) {
                    if let Some(ref operation) = inner_expr.operation {
                        if let Some(unwrapped) = self.try_unwrap_zero_rhs_inline(operation) {
                            return unwrapped;
                        }
                    }
                }
                Expression {
                    op: "exp".to_string(),
                    id: Some(id),
                    ..Default::default()
                }
            }
            operand::Operand::Constant(c) => {
                let value = buf_to_bigint_string(&c.value);
                Expression {
                    op: "number".to_string(),
                    value: Some(value),
                    ..Default::default()
                }
            }
            operand::Operand::WitnessCol(wc) => {
                let stage_id = wc.col_idx as usize;
                let row_offset = wc.row_offset as i64;
                let stage = wc.stage as usize;
                let id = stage_id
                    + self.stage_widths
                        .iter()
                        .take(stage.saturating_sub(1))
                        .map(|w| *w as usize)
                        .sum::<usize>();
                let dim = if stage <= 1 { 1 } else { FIELD_EXTENSION };
                Expression {
                    op: "cm".to_string(),
                    id: Some(id),
                    stage_id: Some(stage_id),
                    row_offset: Some(row_offset),
                    stage,
                    dim,
                    ..Default::default()
                }
            }
            operand::Operand::CustomCol(cc) => {
                let commit_id = cc.commit_id as usize;
                let custom_stage_widths = &self.custom_commits[commit_id].stage_widths;
                let stage_id = cc.col_idx as usize;
                let row_offset = cc.row_offset as i64;
                let stage = cc.stage as usize;
                let id = stage_id
                    + custom_stage_widths
                        .iter()
                        .take(stage.saturating_sub(1))
                        .map(|w| *w as usize)
                        .sum::<usize>();
                let dim = if stage <= 1 { 1 } else { FIELD_EXTENSION };
                Expression {
                    op: "custom".to_string(),
                    id: Some(id),
                    stage_id: Some(stage_id),
                    row_offset: Some(row_offset),
                    stage,
                    dim,
                    commit_id: Some(commit_id),
                    ..Default::default()
                }
            }
            operand::Operand::FixedCol(fc) => {
                let id = fc.idx as usize;
                let row_offset = fc.row_offset as i64;
                Expression {
                    op: "const".to_string(),
                    id: Some(id),
                    row_offset: Some(row_offset),
                    stage: 0,
                    dim: 1,
                    ..Default::default()
                }
            }
            operand::Operand::PublicValue(pv) => {
                let id = pv.idx as usize;
                Expression {
                    op: "public".to_string(),
                    id: Some(id),
                    stage: 1,
                    ..Default::default()
                }
            }
            operand::Operand::AirGroupValue(agv) => {
                let id = agv.idx as usize;
                let stage = self.air_group_values
                    .get(id)
                    .map(|v| v.stage as usize)
                    .unwrap_or(0);
                let dim = if stage == 1 { 1 } else { FIELD_EXTENSION };
                Expression {
                    op: "airgroupvalue".to_string(),
                    id: Some(id),
                    dim,
                    stage,
                    ..Default::default()
                }
            }
            operand::Operand::AirValue(av) => {
                let id = av.idx as usize;
                let stage = self.air_values
                    .get(id)
                    .map(|v| v.stage as usize)
                    .unwrap_or(0);
                let dim = if stage == 1 { 1 } else { FIELD_EXTENSION };
                Expression {
                    op: "airvalue".to_string(),
                    id: Some(id),
                    stage,
                    dim,
                    ..Default::default()
                }
            }
            operand::Operand::Challenge(ch) => {
                let stage_id_val = ch.idx as usize;
                let stage = ch.stage as usize;
                let id = stage_id_val
                    + self.num_challenges
                        .iter()
                        .take(stage.saturating_sub(1))
                        .map(|c| *c as usize)
                        .sum::<usize>();
                Expression {
                    op: "challenge".to_string(),
                    stage,
                    stage_id: Some(stage_id_val),
                    id: Some(id),
                    ..Default::default()
                }
            }
            operand::Operand::ProofValue(pv) => {
                let id = pv.idx as usize;
                let stage = pv.stage as usize;
                let dim = if stage == 1 { 1 } else { FIELD_EXTENSION };
                Expression {
                    op: "proofvalue".to_string(),
                    id: Some(id),
                    stage,
                    dim,
                    ..Default::default()
                }
            }
            operand::Operand::PeriodicCol(pc) => {
                let id = pc.idx as usize;
                let row_offset = pc.row_offset as i64;
                Expression {
                    op: "const".to_string(),
                    id: Some(id),
                    row_offset: Some(row_offset),
                    stage: 0,
                    dim: 1,
                    ..Default::default()
                }
            }
        }
    }

    /// Try to unwrap add/sub(X, const(0)) where LHS is not an expression reference.
    /// Returns an inline Expression instead of an arena index.
    fn try_unwrap_zero_rhs_inline(&mut self, operation: &expr_mod::Operation) -> Option<Expression> {
        let (lhs_operand, rhs_operand) = match operation {
            expr_mod::Operation::Add(add) => (add.lhs.as_ref()?, add.rhs.as_ref()?),
            expr_mod::Operation::Sub(sub) => (sub.lhs.as_ref()?, sub.rhs.as_ref()?),
            _ => return None,
        };

        let lhs_op = lhs_operand.operand.as_ref()?;
        let rhs_op = rhs_operand.operand.as_ref()?;

        if matches!(lhs_op, operand::Operand::Expression(_)) {
            return None;
        }

        if let operand::Operand::Constant(c) = rhs_op {
            let val = buf_to_bigint_string(&c.value);
            if val == "0" {
                return Some(self.format_operand_inline(lhs_op));
            }
        }

        None
    }

    /// Format an `Option<&Operand>` into an inline ExprChild.
    fn format_operand_child(&mut self, operand: Option<&pb::Operand>) -> ExprChild {
        match operand.and_then(|o| o.operand.as_ref()) {
            Some(op) => ExprChild::Inline(Box::new(self.format_operand_inline(op))),
            None => ExprChild::Inline(Box::new(Expression {
                op: "number".to_string(),
                value: Some("0".to_string()),
                ..Default::default()
            })),
        }
    }

    /// Format a single top-level protobuf Expression (add/sub/mul/neg with children).
    /// Children are stored as inline ExprChild values (not pushed to arena).
    fn format_expression_node(&mut self, expr: &pb::Expression) -> Expression {
        let operation = match &expr.operation {
            Some(op) => op,
            None => {
                return Expression {
                    op: "number".to_string(),
                    value: Some("0".to_string()),
                    ..Default::default()
                };
            }
        };

        match operation {
            expr_mod::Operation::Add(add) => {
                let lhs = self.format_operand_child(add.lhs.as_ref());
                let rhs = self.format_operand_child(add.rhs.as_ref());
                Expression {
                    op: "add".to_string(),
                    values: vec![lhs, rhs],
                    ..Default::default()
                }
            }
            expr_mod::Operation::Sub(sub) => {
                let lhs = self.format_operand_child(sub.lhs.as_ref());
                let rhs = self.format_operand_child(sub.rhs.as_ref());
                Expression {
                    op: "sub".to_string(),
                    values: vec![lhs, rhs],
                    ..Default::default()
                }
            }
            expr_mod::Operation::Mul(mul) => {
                let lhs = self.format_operand_child(mul.lhs.as_ref());
                let rhs = self.format_operand_child(mul.rhs.as_ref());
                Expression {
                    op: "mul".to_string(),
                    values: vec![lhs, rhs],
                    ..Default::default()
                }
            }
            expr_mod::Operation::Neg(neg) => {
                let val = self.format_operand_child(neg.value.as_ref());
                Expression {
                    op: "neg".to_string(),
                    values: vec![val],
                    ..Default::default()
                }
            }
        }
    }
}

// ---------------------------------------------------------------------------
// format_expressions: public API
// ---------------------------------------------------------------------------

/// Format all Air-level protobuf expressions into a flat `Vec<Expression>`.
///
/// Top-level expressions occupy indices 0..N-1. Child operands are stored
/// as inline `ExprChild::Inline` values within each expression, matching
/// the JS representation where child nodes are nested objects.
pub fn format_expressions(
    air_expressions: &[pb::Expression],
    stage_widths: &[u32],
    num_challenges: &[u32],
    air_values: &[pb::AirValue],
    air_group_values: &[pb::AirGroupValue],
    custom_commits: &[pb::CustomCommit],
) -> Vec<Expression> {
    let n = air_expressions.len();

    let mut ctx = FormatCtx {
        air_expressions,
        stage_widths,
        num_challenges,
        air_values,
        air_group_values,
        custom_commits,
        arena: Vec::with_capacity(n),
    };

    // Reserve the first N slots with placeholders.
    for _ in 0..n {
        ctx.arena.push(Expression {
            op: "__placeholder__".to_string(),
            ..Default::default()
        });
    }

    // Now format each top-level expression. Children get pushed at indices >= N.
    for (i, air_expr) in air_expressions.iter().enumerate() {
        let formatted = ctx.format_expression_node(air_expr);
        ctx.arena[i] = formatted;
    }

    ctx.arena
}

// ---------------------------------------------------------------------------
// format_constraints
// ---------------------------------------------------------------------------

/// Format constraints from protobuf, mirroring JS `formatConstraints`.
pub fn format_constraints(constraints: &[pb::Constraint]) -> Vec<ConstraintInfo> {
    constraints
        .iter()
        .filter_map(|c| {
            let inner = c.constraint.as_ref()?;
            match inner {
                constraint::Constraint::FirstRow(fr) => Some(ConstraintInfo {
                    boundary: "firstRow".to_string(),
                    e: fr.expression_idx.as_ref().map(|e| e.idx as usize).unwrap_or(0),
                    line: fr.debug_line.clone(),
                    offset_min: None,
                    offset_max: None,
                    stage: None,
                    im_pol: false,
                }),
                constraint::Constraint::LastRow(lr) => Some(ConstraintInfo {
                    boundary: "lastRow".to_string(),
                    e: lr.expression_idx.as_ref().map(|e| e.idx as usize).unwrap_or(0),
                    line: lr.debug_line.clone(),
                    offset_min: None,
                    offset_max: None,
                    stage: None,
                    im_pol: false,
                }),
                constraint::Constraint::EveryRow(er) => Some(ConstraintInfo {
                    boundary: "everyRow".to_string(),
                    e: er.expression_idx.as_ref().map(|e| e.idx as usize).unwrap_or(0),
                    line: er.debug_line.clone(),
                    offset_min: None,
                    offset_max: None,
                    stage: None,
                    im_pol: false,
                }),
                constraint::Constraint::EveryFrame(ef) => Some(ConstraintInfo {
                    boundary: "everyFrame".to_string(),
                    e: ef.expression_idx.as_ref().map(|e| e.idx as usize).unwrap_or(0),
                    line: ef.debug_line.clone(),
                    offset_min: Some(ef.offset_min),
                    offset_max: Some(ef.offset_max),
                    stage: None,
                    im_pol: false,
                }),
            }
        })
        .collect()
}

// ---------------------------------------------------------------------------
// format_symbols
// ---------------------------------------------------------------------------

/// Format symbols from pilout, mirroring JS `formatSymbols`.
pub fn format_symbols(
    all_symbols: &[pb::Symbol],
    _num_challenges: &[u32],
    air_group_values: &[pb::AirGroupValue],
    air_values: &[pb::AirValue],
) -> Vec<SymbolInfo> {
    let mut result = Vec::new();

    for s in all_symbols {
        let stype = s.r#type;
        // Skip IM_COL (type 0)
        if stype == SymbolType::ImCol as i32 {
            continue;
        }

        if stype == SymbolType::FixedCol as i32
            || stype == SymbolType::WitnessCol as i32
            || stype == SymbolType::CustomCol as i32
        {
            let stage = s.stage.unwrap_or(0) as usize;
            if stype == SymbolType::CustomCol as i32 && stage != 0 {
                panic!("Invalid stage {} for a custom commit", stage);
            }

            let type_str = if stype == SymbolType::FixedCol as i32 {
                "fixed"
            } else if stype == SymbolType::CustomCol as i32 {
                "custom"
            } else {
                "witness"
            };

            let dim = if stage <= 1 { 1 } else { FIELD_EXTENSION };
            let pol_id = compute_pol_id(all_symbols, s);

            if s.dim == 0 {
                let mut sym = SymbolInfo {
                    name: s.name.clone(),
                    sym_type: type_str.to_string(),
                    stage: Some(stage),
                    dim,
                    pol_id: Some(pol_id),
                    stage_id: Some(s.id as usize),
                    air_id: s.air_id.map(|v| v as usize),
                    airgroup_id: s.air_group_id.map(|v| v as usize),
                    id: None,
                    commit_id: None,
                    lengths: None,
                    idx: None,
                    stage_pos: None,
                    im_pol: false,
                    exp_id: None,
                };
                if stype == SymbolType::CustomCol as i32 {
                    sym.commit_id = s.commit_id.map(|v| v as usize);
                }
                result.push(sym);
            } else {
                generate_multi_array_symbols(
                    &mut result, &[], s, type_str, stage, dim, pol_id, 0,
                );
            }
        } else if stype == SymbolType::ProofValue as i32 {
            let stage = s.stage.unwrap_or(1) as usize;
            let dim = if stage == 1 { 1 } else { FIELD_EXTENSION };

            if s.dim == 0 {
                result.push(SymbolInfo {
                    name: s.name.clone(),
                    sym_type: "proofvalue".to_string(),
                    stage: Some(stage),
                    dim,
                    id: Some(s.id as usize),
                    pol_id: None,
                    stage_id: None,
                    air_id: None,
                    airgroup_id: None,
                    commit_id: None,
                    lengths: None,
                    idx: None,
                    stage_pos: None,
                    im_pol: false,
                    exp_id: None,
                });
            } else {
                generate_multi_array_symbols(
                    &mut result, &[], s, "proofvalue", stage, dim, s.id as usize, 0,
                );
            }
        } else if stype == SymbolType::Challenge as i32 {
            let stage = s.stage.unwrap_or(1) as usize;
            let id = all_symbols
                .iter()
                .filter(|si| {
                    si.r#type == SymbolType::Challenge as i32 && {
                        let si_stage = si.stage.unwrap_or(0) as usize;
                        si_stage < stage || (si_stage == stage && si.id < s.id)
                    }
                })
                .count();

            result.push(SymbolInfo {
                name: s.name.clone(),
                sym_type: "challenge".to_string(),
                stage: Some(stage),
                dim: FIELD_EXTENSION,
                id: Some(id),
                stage_id: Some(s.id as usize),
                pol_id: None,
                air_id: None,
                airgroup_id: None,
                commit_id: None,
                lengths: None,
                idx: None,
                stage_pos: None,
                im_pol: false,
                exp_id: None,
            });
        } else if stype == SymbolType::PublicValue as i32 {
            if s.dim == 0 {
                result.push(SymbolInfo {
                    name: s.name.clone(),
                    sym_type: "public".to_string(),
                    stage: Some(1),
                    dim: 1,
                    id: Some(s.id as usize),
                    pol_id: None,
                    stage_id: None,
                    air_id: None,
                    airgroup_id: None,
                    commit_id: None,
                    lengths: None,
                    idx: None,
                    stage_pos: None,
                    im_pol: false,
                    exp_id: None,
                });
            } else {
                generate_multi_array_symbols(
                    &mut result, &[], s, "public", 1, 1, s.id as usize, 0,
                );
            }
        } else if stype == SymbolType::AirGroupValue as i32 {
            let stage = air_group_values
                .get(s.id as usize)
                .map(|v| v.stage as usize);

            if s.dim == 0 {
                let mut sym = SymbolInfo {
                    name: s.name.clone(),
                    sym_type: "airgroupvalue".to_string(),
                    stage,
                    dim: FIELD_EXTENSION,
                    id: Some(s.id as usize),
                    airgroup_id: s.air_group_id.map(|v| v as usize),
                    pol_id: None,
                    stage_id: None,
                    air_id: None,
                    commit_id: None,
                    lengths: None,
                    idx: None,
                    stage_pos: None,
                    im_pol: false,
                    exp_id: None,
                };
                if stage.is_none() || stage == Some(0) {
                    sym.stage = None;
                }
                result.push(sym);
            } else {
                generate_multi_array_symbols(
                    &mut result, &[], s, "airgroupvalue",
                    stage.unwrap_or(0), FIELD_EXTENSION, s.id as usize, 0,
                );
            }
        } else if stype == SymbolType::AirValue as i32 {
            let stage = air_values
                .get(s.id as usize)
                .map(|v| v.stage as usize)
                .unwrap_or(0);
            let dim = if stage != 1 { FIELD_EXTENSION } else { 1 };

            if s.dim == 0 {
                result.push(SymbolInfo {
                    name: s.name.clone(),
                    sym_type: "airvalue".to_string(),
                    stage: Some(stage),
                    dim,
                    id: Some(s.id as usize),
                    airgroup_id: s.air_group_id.map(|v| v as usize),
                    pol_id: None,
                    stage_id: None,
                    air_id: None,
                    commit_id: None,
                    lengths: None,
                    idx: None,
                    stage_pos: None,
                    im_pol: false,
                    exp_id: None,
                });
            } else {
                generate_multi_array_symbols(
                    &mut result, &[], s, "airvalue", stage, dim, s.id as usize, 0,
                );
            }
        }
        // Other types (PeriodicCol, PublicTable) are skipped
    }

    result
}

/// Compute the polId for a fixed/witness/custom column symbol.
fn compute_pol_id(all_symbols: &[pb::Symbol], s: &pb::Symbol) -> usize {
    let mut pol_id: usize = 0;
    for si in all_symbols {
        if si.r#type != s.r#type
            || si.air_id != s.air_id
            || si.air_group_id != s.air_group_id
        {
            continue;
        }
        let si_stage = si.stage.unwrap_or(0);
        let s_stage = s.stage.unwrap_or(0);
        if !(si_stage < s_stage || (si_stage == s_stage && si.id < s.id)) {
            continue;
        }
        if s.r#type == SymbolType::CustomCol as i32 && s.commit_id != si.commit_id {
            continue;
        }
        if si.dim == 0 {
            pol_id += 1;
        } else {
            pol_id += si.lengths.iter().map(|l| *l as usize).product::<usize>();
        }
    }
    pol_id
}

/// Recursively generate symbols for multi-dimensional arrays.
fn generate_multi_array_symbols(
    symbols: &mut Vec<SymbolInfo>,
    indexes: &[usize],
    sym: &pb::Symbol,
    type_str: &str,
    stage: usize,
    dim: usize,
    pol_id: usize,
    shift: usize,
) -> usize {
    if indexes.len() == sym.lengths.len() {
        let mut symbol = SymbolInfo {
            name: sym.name.clone(),
            lengths: Some(indexes.to_vec()),
            idx: Some(shift),
            sym_type: type_str.to_string(),
            pol_id: Some(pol_id + shift),
            id: Some(pol_id + shift),
            stage_id: Some(sym.id as usize + shift),
            stage: Some(stage),
            dim,
            air_id: sym.air_id.map(|v| v as usize),
            airgroup_id: sym.air_group_id.map(|v| v as usize),
            commit_id: None,
            stage_pos: None,
            im_pol: false,
            exp_id: None,
        };
        if sym.commit_id.is_some() {
            symbol.commit_id = sym.commit_id.map(|v| v as usize);
        }
        symbols.push(symbol);
        return shift + 1;
    }

    let len = sym.lengths[indexes.len()] as usize;
    let mut current_shift = shift;
    for i in 0..len {
        let mut new_indexes = indexes.to_vec();
        new_indexes.push(i);
        current_shift = generate_multi_array_symbols(
            symbols, &new_indexes, sym, type_str, stage, dim, pol_id, current_shift,
        );
    }
    current_shift
}

// ---------------------------------------------------------------------------
// format_hints
// ---------------------------------------------------------------------------

/// Format hints from protobuf, mirroring JS `formatHints`.
pub fn format_hints(
    raw_hints: &[pb::Hint],
    air_expressions: &[pb::Expression],
    stage_widths: &[u32],
    num_challenges: &[u32],
    air_values: &[pb::AirValue],
    air_group_values: &[pb::AirGroupValue],
    custom_commits: &[pb::CustomCommit],
    expressions: &mut [Expression],
) -> Vec<HintInfo> {
    let mut hints = Vec::new();

    for raw_hint in raw_hints {
        let hint_name = raw_hint.name.clone();

        // JS: rawHints[i].hintFields[0].hintFieldArray.hintFields
        let inner_fields = if let Some(first_hf) = raw_hint.hint_fields.first() {
            if let Some(hint_field::Value::HintFieldArray(arr)) = &first_hf.value {
                &arr.hint_fields[..]
            } else {
                &raw_hint.hint_fields[..]
            }
        } else {
            continue;
        };

        let mut fields = Vec::new();
        for field in inner_fields {
            let name = field.name.clone().unwrap_or_default();
            let (values, lengths) = process_hint_field(
                field,
                air_expressions,
                stage_widths,
                num_challenges,
                air_values,
                air_group_values,
                custom_commits,
                expressions,
            );
            let entry = if lengths.is_none() {
                HintFieldEntry {
                    name,
                    values: vec![values],
                    lengths: None,
                }
            } else {
                HintFieldEntry {
                    name,
                    values: match values {
                        HintFieldValue::Array(arr) => arr,
                        single => vec![single],
                    },
                    lengths,
                }
            };
            fields.push(entry);
        }
        hints.push(HintInfo {
            name: hint_name,
            fields,
        });
    }

    hints
}

/// Recursively process a hint field.
fn process_hint_field(
    hint_field: &pb::HintField,
    air_expressions: &[pb::Expression],
    stage_widths: &[u32],
    num_challenges: &[u32],
    air_values: &[pb::AirValue],
    air_group_values: &[pb::AirGroupValue],
    custom_commits: &[pb::CustomCommit],
    expressions: &mut [Expression],
) -> (HintFieldValue, Option<Vec<usize>>) {
    match &hint_field.value {
        Some(hint_field::Value::HintFieldArray(arr)) => {
            let fields = &arr.hint_fields;
            let mut result_fields = Vec::new();
            let mut lengths: Vec<usize> = Vec::new();

            for field in fields {
                let (values, sub_lengths) = process_hint_field(
                    field,
                    air_expressions,
                    stage_widths,
                    num_challenges,
                    air_values,
                    air_group_values,
                    custom_commits,
                    expressions,
                );
                result_fields.push(values);

                if lengths.is_empty() {
                    lengths.push(fields.len());
                }

                if let Some(sub) = sub_lengths {
                    for (k, &sub_len) in sub.iter().enumerate() {
                        if k + 1 >= lengths.len() {
                            lengths.resize(k + 2, 0);
                        }
                        if lengths[k + 1] == 0 {
                            lengths[k + 1] = sub_len;
                        }
                    }
                }
            }

            (HintFieldValue::Array(result_fields), Some(lengths))
        }
        Some(hint_field::Value::Operand(operand)) => {
            if let Some(ref op) = operand.operand {
                // Build a temporary FormatCtx just for this operand.
                // Hint field operands produce standalone Expression objects
                // (they are not inserted into the main expression arena).
                let mut ctx = FormatCtx {
                    air_expressions,
                    stage_widths,
                    num_challenges,
                    air_values,
                    air_group_values,
                    custom_commits,
                    arena: Vec::new(),
                };
                let value = ctx.format_operand_inline(op);

                // If the value is an "exp" reference, mark keep=true
                if value.op == "exp" {
                    if let Some(id) = value.id {
                        if id < expressions.len() {
                            expressions[id].keep = Some(true);
                        }
                    }
                }
                (HintFieldValue::Single(value), None)
            } else {
                (
                    HintFieldValue::Single(Expression {
                        op: "number".to_string(),
                        value: Some("0".to_string()),
                        ..Default::default()
                    }),
                    None,
                )
            }
        }
        Some(hint_field::Value::StringValue(s)) => (
            HintFieldValue::Single(Expression {
                op: "string".to_string(),
                value: Some(s.clone()),
                ..Default::default()
            }),
            None,
        ),
        None => panic!("Unknown hint field"),
    }
}

// ---------------------------------------------------------------------------
// get_pilout_info: main orchestrator
// ---------------------------------------------------------------------------

/// Extract pilout info for a single air, mirroring JS `getPiloutInfo`.
pub fn get_pilout_info(
    pilout: &pb::PilOut,
    airgroup_id: usize,
    air_id: usize,
) -> SetupResult {
    let airgroup = &pilout.air_groups[airgroup_id];
    let air = &airgroup.airs[air_id];

    let air_name = air.name.clone().unwrap_or_default();
    let num_rows = air.num_rows.unwrap_or(0);
    let pil_power = if num_rows > 0 { (num_rows as f64).log2() as u32 } else { 0 };

    let constraints = format_constraints(&air.constraints);

    let mut expressions = format_expressions(
        &air.expressions,
        &air.stage_widths,
        &pilout.num_challenges,
        &air.air_values,
        &airgroup.air_group_values,
        &air.custom_commits,
    );

    // Gather symbols for this air from the global pilout symbols list
    let air_symbols: Vec<pb::Symbol> = pilout
        .symbols
        .iter()
        .filter(|sym| {
            sym.air_group_id.is_none()
                || (sym.air_group_id == Some(airgroup_id as u32)
                    && (sym.air_id.is_none() || sym.air_id == Some(air_id as u32)))
        })
        .cloned()
        .collect();

    let mut all_symbols = format_symbols(
        &air_symbols,
        &pilout.num_challenges,
        &airgroup.air_group_values,
        &air.air_values,
    );

    // Filter: keep only witness/fixed that match this air
    all_symbols.retain(|s| {
        if s.sym_type == "witness" || s.sym_type == "fixed" {
            s.air_id == Some(air_id) && s.airgroup_id == Some(airgroup_id)
        } else {
            true
        }
    });

    let n_commitments = all_symbols
        .iter()
        .filter(|s| {
            s.sym_type == "witness"
                && s.air_id == Some(air_id)
                && s.airgroup_id == Some(airgroup_id)
        })
        .count();

    let n_constants = all_symbols
        .iter()
        .filter(|s| {
            s.sym_type == "fixed"
                && s.air_id == Some(air_id)
                && s.airgroup_id == Some(airgroup_id)
        })
        .count();

    let n_publics = all_symbols
        .iter()
        .filter(|s| s.sym_type == "public")
        .count();

    let n_stages = if !pilout.num_challenges.is_empty() {
        pilout.num_challenges.len()
    } else {
        all_symbols
            .iter()
            .filter_map(|s| s.stage)
            .max()
            .unwrap_or(0)
    };

    // Filter hints for this air (strict match, same as JS)
    let air_hints: Vec<pb::Hint> = pilout
        .hints
        .iter()
        .filter(|h| {
            h.air_id == Some(air_id as u32)
                && h.air_group_id == Some(airgroup_id as u32)
        })
        .cloned()
        .collect();

    let hints = format_hints(
        &air_hints,
        &air.expressions,
        &air.stage_widths,
        &pilout.num_challenges,
        &air.air_values,
        &airgroup.air_group_values,
        &air.custom_commits,
        &mut expressions,
    );

    // Build custom commits info
    let mut map_sections_n = IndexMap::new();
    map_sections_n.insert("const".to_string(), 0);

    let mut custom_commits_info = Vec::new();
    let mut custom_commits_map: Vec<Vec<SymbolInfo>> = Vec::new();

    for cc in &air.custom_commits {
        let cc_name = cc.name.clone().unwrap_or_default();
        custom_commits_info.push(CustomCommitInfo {
            name: cc_name.clone(),
            stage_widths: cc.stage_widths.clone(),
        });
        custom_commits_map.push(Vec::new());

        for (j, &width) in cc.stage_widths.iter().enumerate() {
            if width > 0 {
                map_sections_n.insert(format!("{}{}", cc_name, j), 0);
            }
        }
    }

    SetupResult {
        name: air_name,
        air_id,
        airgroup_id,
        pil_power,
        n_stages,
        n_constants,
        n_publics,
        n_commitments,
        cm_pols_map: Vec::new(),
        const_pols_map: Vec::new(),
        challenges_map: Vec::new(),
        publics_map: Vec::new(),
        proof_values_map: Vec::new(),
        airgroup_values_map: Vec::new(),
        air_values_map: Vec::new(),
        map_sections_n,
        custom_commits: custom_commits_info,
        custom_commits_map,
        air_group_values: airgroup.air_group_values.clone(),
        expressions,
        constraints,
        symbols: all_symbols,
        hints,
        n_commitments_stage1: 0,
        im_pols_info: (Vec::new(), Vec::new()),
    }
}

// ---------------------------------------------------------------------------
// Expression arena helpers
// ---------------------------------------------------------------------------

/// Convert a flat `Vec<Expression>` into an `ExpressionArena`.
pub fn build_arena(exprs: Vec<Expression>) -> ExpressionArena {
    let mut arena = ExpressionArena::new();
    for e in exprs {
        arena.push(e);
    }
    arena
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

#[cfg(test)]
mod tests {
    use super::*;
    use pilout::pilout::PilOut;
    use prost::Message;
    use std::fs;
    use std::path::Path;

    #[test]
    fn test_buf_to_bigint_string() {
        assert_eq!(buf_to_bigint_string(&[]), "0");
        assert_eq!(buf_to_bigint_string(&[0]), "0");
        assert_eq!(buf_to_bigint_string(&[1]), "1");
        assert_eq!(buf_to_bigint_string(&[0, 0, 0, 0, 0, 0, 0, 42]), "42");
        assert_eq!(buf_to_bigint_string(&[1, 0]), "256");
    }

    #[test]
    fn test_format_constraints_empty() {
        let constraints = format_constraints(&[]);
        assert!(constraints.is_empty());
    }

    #[test]
    fn test_load_zisk_pilout() {
        let pilout_path = "/data/eric/venus/pil/zisk.pilout";
        if !Path::new(pilout_path).exists() {
            eprintln!("Skipping test: {} not found", pilout_path);
            return;
        }

        let data = fs::read(pilout_path).expect("Failed to read pilout");
        let pilout = PilOut::decode(data.as_slice()).expect("Failed to decode pilout");

        assert!(
            !pilout.air_groups.is_empty(),
            "pilout should have at least one airgroup"
        );

        let airgroup = &pilout.air_groups[0];
        assert!(
            !airgroup.airs.is_empty(),
            "first airgroup should have at least one air"
        );

        let result = get_pilout_info(&pilout, 0, 0);

        assert!(!result.name.is_empty(), "air name should not be empty");
        assert!(result.pil_power > 0, "pil_power should be positive");
        assert!(
            !result.constraints.is_empty(),
            "should have at least one constraint"
        );
        assert!(
            !result.expressions.is_empty(),
            "should have at least one expression"
        );

        eprintln!(
            "Loaded air '{}': power={}, stages={}, consts={}, commits={}, publics={}, exprs={}, constraints={}, symbols={}, hints={}",
            result.name,
            result.pil_power,
            result.n_stages,
            result.n_constants,
            result.n_commitments,
            result.n_publics,
            result.expressions.len(),
            result.constraints.len(),
            result.symbols.len(),
            result.hints.len(),
        );
    }
}
