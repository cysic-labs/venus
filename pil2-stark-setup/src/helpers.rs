use crate::expression::Expression;
use crate::pilout_info::FIELD_EXTENSION;

/// Goldilocks field negation of 1: p - 1 = 2^64 - 2^32 + 1 - 1 = 18446744069414584320
const NEG_ONE: &str = "18446744069414584320";

// ---------------------------------------------------------------------------
// add_info_expressions
// ---------------------------------------------------------------------------

/// Recursively walk expression trees computing `exp_deg`, `dim`, `stage`,
/// and `rows_offsets`. Mirrors the JS `addInfoExpressions` from helpers.js.
///
/// The `expressions` slice must be the flat expression array (indexed by ID).
/// This function mutates expressions in-place.
pub fn add_info_expressions(expressions: &mut Vec<Expression>, idx: usize) {
    // Guard: already processed
    if expressions[idx].exp_deg != 0 || is_info_computed(expressions, idx) {
        return;
    }

    let op = expressions[idx].op.clone();

    match op.as_str() {
        "exp" => {
            let ref_id = expressions[idx].id.unwrap_or(0);
            add_info_expressions(expressions, ref_id);

            let exp_deg = expressions[ref_id].exp_deg;
            let rows_offsets = expressions[ref_id].rows_offsets.clone();
            let ref_dim = expressions[ref_id].dim;
            let ref_stage = expressions[ref_id].stage;

            expressions[idx].exp_deg = exp_deg;
            expressions[idx].rows_offsets = rows_offsets;
            if expressions[idx].dim <= 1 {
                expressions[idx].dim = ref_dim;
            }
            if expressions[idx].stage == 0 {
                expressions[idx].stage = ref_stage;
            }
        }
        "cm" | "custom" | "const" => {
            expressions[idx].exp_deg = 1;
            if expressions[idx].stage == 0 || op == "const" {
                expressions[idx].stage = if op == "cm" { 1 } else { 0 };
            }
            if expressions[idx].dim == 0 || expressions[idx].dim == 1 {
                expressions[idx].dim = 1;
            }
            if let Some(row_off) = expressions[idx].row_offset {
                expressions[idx].rows_offsets = vec![row_off];
            }
        }
        "Zi" => {
            let boundary = expressions[idx].boundary.clone();
            if boundary.as_deref() != Some("everyRow") {
                expressions[idx].exp_deg = 1;
            } else {
                // everyRow Zi
                expressions[idx].exp_deg = 0;
                expressions[idx].stage = 0;
                if expressions[idx].dim <= 1 {
                    expressions[idx].dim = 1;
                }
            }
        }
        "xDivXSubXi" => {
            expressions[idx].exp_deg = 1;
        }
        "challenge" | "eval" => {
            expressions[idx].exp_deg = 0;
            expressions[idx].dim = FIELD_EXTENSION;
        }
        "airgroupvalue" | "proofvalue" => {
            expressions[idx].exp_deg = 0;
            if expressions[idx].dim <= 1 {
                expressions[idx].dim = if expressions[idx].stage != 1 {
                    FIELD_EXTENSION
                } else {
                    1
                };
            }
        }
        "airvalue" => {
            expressions[idx].exp_deg = 0;
            if expressions[idx].dim <= 1 {
                expressions[idx].dim = if expressions[idx].stage != 1 {
                    FIELD_EXTENSION
                } else {
                    1
                };
            }
        }
        "public" => {
            expressions[idx].exp_deg = 0;
            expressions[idx].stage = 1;
            if expressions[idx].dim <= 1 {
                expressions[idx].dim = 1;
            }
        }
        "number" => {
            expressions[idx].exp_deg = 0;
            expressions[idx].stage = 0;
            if expressions[idx].dim <= 1 {
                expressions[idx].dim = 1;
            }
        }
        "add" | "sub" | "mul" | "neg" => {
            handle_binary_or_neg(expressions, idx);
        }
        _ => {
            panic!("Exp op not defined: {}", op);
        }
    }
}

/// Check if info is already computed for a given expression.
/// For leaf nodes, exp_deg == 0 is the default but also a valid computed value,
/// so we need an additional check.
fn is_info_computed(expressions: &[Expression], idx: usize) -> bool {
    let e = &expressions[idx];
    if e.exp_deg != 0 {
        return true;
    }
    // For leaves that have exp_deg=0 as their final value, check if
    // stage/dim have been meaningfully set.
    match e.op.as_str() {
        "number" | "public" | "challenge" | "eval" | "airgroupvalue" | "proofvalue"
        | "airvalue" => {
            // These all have exp_deg=0 as their target. Check if dim
            // has been set above the default.
            e.dim > 1
                || e.stage > 0
                || e.op == "number"
                    && e.dim == 1
                    && !e.rows_offsets.is_empty()
        }
        "exp" => {
            // An exp ref is computed if it has rows_offsets populated
            !e.rows_offsets.is_empty() || e.dim > 1 || e.stage > 0
        }
        _ => false,
    }
}

/// Handle add/sub/mul/neg operations in add_info_expressions.
/// Mirrors the JS logic including neg->mul transformation and
/// zero-constant optimizations.
fn handle_binary_or_neg(expressions: &mut Vec<Expression>, idx: usize) {
    let op = expressions[idx].op.clone();

    // neg -> mul by NEG_ONE
    if op == "neg" {
        expressions[idx].op = "mul".to_string();
        // Insert NEG_ONE as lhs, existing value becomes rhs
        let neg_one = Expression {
            op: "number".to_string(),
            value: Some(NEG_ONE.to_string()),
            exp_deg: 0,
            stage: 0,
            dim: 1,
            ..Default::default()
        };
        // The neg has values = [child_idx]. We need to restructure:
        // values becomes [neg_one_inline_idx, child_idx]
        // But since our arena stores inline Expression objects in `values`
        // as indices, and the neg case stores children as ExprId indices,
        // we need to handle this carefully.
        //
        // In our representation, values[] are ExprId indices into the arena.
        // We push the neg_one expression into the arena and use its index.
        let neg_one_id = expressions.len();
        expressions.push(neg_one);
        let existing_values = expressions[idx].values.clone();
        expressions[idx].values = vec![neg_one_id, existing_values[0]];
    }

    let current_op = expressions[idx].op.clone();

    // For add where LHS is number(0), convert to mul with LHS=1
    if current_op == "add" {
        let lhs_idx = expressions[idx].values[0];
        if expressions[lhs_idx].op == "number" {
            if let Some(ref val) = expressions[lhs_idx].value {
                if val == "0" {
                    expressions[idx].op = "mul".to_string();
                    expressions[lhs_idx].value = Some("1".to_string());
                }
            }
        }
    }

    // For add/sub where RHS is number(0), convert to mul with RHS=1
    let current_op = expressions[idx].op.clone();
    if current_op == "add" || current_op == "sub" {
        let rhs_idx = expressions[idx].values[1];
        if expressions[rhs_idx].op == "number" {
            if let Some(ref val) = expressions[rhs_idx].value {
                if val == "0" {
                    expressions[idx].op = "mul".to_string();
                    expressions[rhs_idx].value = Some("1".to_string());
                }
            }
        }
    }

    let lhs_idx = expressions[idx].values[0];
    let rhs_idx = expressions[idx].values[1];

    add_info_expressions(expressions, lhs_idx);
    add_info_expressions(expressions, rhs_idx);

    let lhs_deg = expressions[lhs_idx].exp_deg;
    let rhs_deg = expressions[rhs_idx].exp_deg;

    let final_op = expressions[idx].op.clone();
    expressions[idx].exp_deg = if final_op == "mul" {
        lhs_deg + rhs_deg
    } else {
        lhs_deg.max(rhs_deg)
    };

    expressions[idx].dim = expressions[lhs_idx].dim.max(expressions[rhs_idx].dim);
    expressions[idx].stage = expressions[lhs_idx].stage.max(expressions[rhs_idx].stage);

    // Merge rows_offsets
    let lhs_offsets = if expressions[lhs_idx].rows_offsets.is_empty() {
        vec![0]
    } else {
        expressions[lhs_idx].rows_offsets.clone()
    };
    let rhs_offsets = if expressions[rhs_idx].rows_offsets.is_empty() {
        vec![0]
    } else {
        expressions[rhs_idx].rows_offsets.clone()
    };

    let mut merged: Vec<i64> = lhs_offsets;
    for o in rhs_offsets {
        if !merged.contains(&o) {
            merged.push(o);
        }
    }
    expressions[idx].rows_offsets = merged;
}

// ---------------------------------------------------------------------------
// get_exp_dim
// ---------------------------------------------------------------------------

/// Get the field dimension of an expression, mirroring JS `getExpDim`.
pub fn get_exp_dim(expressions: &[Expression], exp_id: usize) -> usize {
    get_exp_dim_inner(expressions, &expressions[exp_id])
}

fn get_exp_dim_inner(expressions: &[Expression], exp: &Expression) -> usize {
    if exp.dim > 0 && exp.op != "add" && exp.op != "sub" && exp.op != "mul" {
        return exp.dim;
    }

    match exp.op.as_str() {
        "add" | "sub" | "mul" => {
            let mut max_dim = 0;
            for &child_id in &exp.values {
                let child_dim = get_exp_dim_inner(expressions, &expressions[child_id]);
                if child_dim > max_dim {
                    max_dim = child_dim;
                }
            }
            max_dim
        }
        "exp" => {
            let id = exp.id.unwrap_or(0);
            get_exp_dim_inner(expressions, &expressions[id])
        }
        "cm" | "custom" => {
            if exp.dim > 0 { exp.dim } else { 1 }
        }
        "const" | "number" | "public" | "Zi" => 1,
        "challenge" | "eval" | "xDivXSubXi" => FIELD_EXTENSION,
        _ => panic!("Exp op not defined: {}", exp.op),
    }
}

/// Track which columns (cm, const, custom) are referenced by an expression tree.
/// Mirrors JS `addInfoExpressionsSymbols`.
///
/// `ev_map` accumulates unique (type, id, prime, commitId) entries.
#[derive(Debug, Clone, PartialEq)]
pub struct EvMapItem {
    pub entry_type: String,
    pub id: usize,
    pub prime: i64,
    pub commit_id: Option<usize>,
}

pub fn add_info_expressions_symbols(
    ev_map: &mut Vec<EvMapItem>,
    expressions: &[Expression],
    idx: usize,
    explored: &mut Vec<bool>,
) {
    if explored[idx] {
        return;
    }

    let op = expressions[idx].op.clone();

    match op.as_str() {
        "exp" => {
            let ref_id = expressions[idx].id.unwrap_or(0);
            add_info_expressions_symbols(ev_map, expressions, ref_id, explored);
            explored[idx] = true;
        }
        "cm" | "const" | "custom" => {
            let id = expressions[idx].id.unwrap_or(0);
            let prime = expressions[idx].row_offset.unwrap_or(0);
            let commit_id = expressions[idx].commit_id;

            let new_item = EvMapItem {
                entry_type: op.clone(),
                id,
                prime,
                commit_id,
            };

            let already_present = ev_map.iter().any(|item| {
                item.entry_type == new_item.entry_type
                    && item.id == new_item.id
                    && item.prime == new_item.prime
                    && (new_item.commit_id.is_none()
                        || item.commit_id == new_item.commit_id)
            });

            if !already_present {
                ev_map.push(new_item);
            }
        }
        "add" | "sub" | "mul" | "neg" => {
            for &child_id in &expressions[idx].values {
                add_info_expressions_symbols(ev_map, expressions, child_id, explored);
            }
            explored[idx] = true;
        }
        _ => {}
    }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

#[cfg(test)]
mod tests {
    use super::*;

    fn make_number(val: &str) -> Expression {
        Expression {
            op: "number".to_string(),
            value: Some(val.to_string()),
            ..Default::default()
        }
    }

    fn make_cm(id: usize, stage: usize) -> Expression {
        Expression {
            op: "cm".to_string(),
            id: Some(id),
            stage,
            dim: 1,
            row_offset: Some(0),
            ..Default::default()
        }
    }

    #[test]
    fn test_add_info_number() {
        let mut exprs = vec![make_number("42")];
        add_info_expressions(&mut exprs, 0);
        assert_eq!(exprs[0].exp_deg, 0);
        assert_eq!(exprs[0].dim, 1);
        assert_eq!(exprs[0].stage, 0);
    }

    #[test]
    fn test_add_info_cm() {
        let mut exprs = vec![make_cm(0, 1)];
        add_info_expressions(&mut exprs, 0);
        assert_eq!(exprs[0].exp_deg, 1);
        assert_eq!(exprs[0].dim, 1);
        assert_eq!(exprs[0].stage, 1);
    }

    #[test]
    fn test_add_info_mul() {
        // mul(cm, cm) => exp_deg = 2
        let cm1 = make_cm(0, 1);
        let cm2 = make_cm(1, 1);
        let mul_expr = Expression {
            op: "mul".to_string(),
            values: vec![0, 1],
            ..Default::default()
        };
        let mut exprs = vec![cm1, cm2, mul_expr];
        add_info_expressions(&mut exprs, 2);
        assert_eq!(exprs[2].exp_deg, 2);
        assert_eq!(exprs[2].dim, 1);
        assert_eq!(exprs[2].stage, 1);
    }

    #[test]
    fn test_get_exp_dim_number() {
        let exprs = vec![Expression {
            op: "number".to_string(),
            value: Some("1".to_string()),
            dim: 1,
            ..Default::default()
        }];
        assert_eq!(get_exp_dim(&exprs, 0), 1);
    }

    #[test]
    fn test_get_exp_dim_challenge() {
        let exprs = vec![Expression {
            op: "challenge".to_string(),
            dim: FIELD_EXTENSION,
            ..Default::default()
        }];
        assert_eq!(get_exp_dim(&exprs, 0), FIELD_EXTENSION);
    }

    #[test]
    fn test_ev_map_dedup() {
        let exprs = vec![
            make_cm(0, 1),
            make_cm(0, 1),
            Expression {
                op: "add".to_string(),
                values: vec![0, 1],
                ..Default::default()
            },
        ];
        let mut ev_map = Vec::new();
        let mut explored = vec![false; exprs.len()];
        add_info_expressions_symbols(&mut ev_map, &exprs, 2, &mut explored);
        // Both children reference cm id=0 prime=0, so dedup should give 1 entry
        assert_eq!(ev_map.len(), 1);
    }
}
