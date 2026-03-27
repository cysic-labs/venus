use std::collections::HashMap;

use tracing::info;

use crate::expression::Expression;
use crate::helpers::{add_info_expressions, get_exp_dim};
use crate::pilout_info::{ConstraintInfo, SymbolInfo, FIELD_EXTENSION};

// ---------------------------------------------------------------------------
// calculateExpDeg
// ---------------------------------------------------------------------------

/// Calculate the polynomial degree of an expression, treating any expression
/// whose id appears in `im_exps` as degree 1 (it will become a committed
/// intermediate polynomial).
///
/// When `cache_values` is true, computed degrees are stashed in `degree_cache`
/// and reused on subsequent calls with the same expression index.
pub fn calculate_exp_deg(
    expressions: &[Expression],
    exp_idx: usize,
    im_exps: &[usize],
    cache_values: bool,
    degree_cache: &mut HashMap<usize, i64>,
) -> i64 {
    if cache_values {
        if let Some(&cached) = degree_cache.get(&exp_idx) {
            return cached;
        }
    }
    let deg = calc_deg_inner(expressions, exp_idx, im_exps, cache_values, degree_cache);
    if cache_values {
        degree_cache.insert(exp_idx, deg);
    }
    deg
}

fn calc_deg_inner(
    expressions: &[Expression],
    idx: usize,
    im_exps: &[usize],
    cache_values: bool,
    degree_cache: &mut HashMap<usize, i64>,
) -> i64 {
    let exp = &expressions[idx];
    match exp.op.as_str() {
        "exp" => {
            let id = exp.id.unwrap_or(0);
            if im_exps.contains(&id) {
                return 1;
            }
            calculate_exp_deg(expressions, id, im_exps, cache_values, degree_cache)
        }
        "const" | "cm" | "custom" => 1,
        "Zi" => {
            if exp.boundary.as_deref() == Some("everyRow") {
                0
            } else {
                1
            }
        }
        "number" | "public" | "challenge" | "eval" | "airgroupvalue" | "airvalue"
        | "proofvalue" => 0,
        "neg" => {
            calculate_exp_deg(expressions, exp.values[0], im_exps, cache_values, degree_cache)
        }
        "add" | "sub" => {
            let lhs =
                calculate_exp_deg(expressions, exp.values[0], im_exps, cache_values, degree_cache);
            let rhs =
                calculate_exp_deg(expressions, exp.values[1], im_exps, cache_values, degree_cache);
            lhs.max(rhs)
        }
        "mul" => {
            let lhs =
                calculate_exp_deg(expressions, exp.values[0], im_exps, cache_values, degree_cache);
            let rhs =
                calculate_exp_deg(expressions, exp.values[1], im_exps, cache_values, degree_cache);
            lhs + rhs
        }
        other => panic!("Exp op not defined: {}", other),
    }
}

// ---------------------------------------------------------------------------
// calculateIntermediatePolynomials  (greedy search)
// ---------------------------------------------------------------------------

/// Result of the greedy intermediate polynomial search.
pub struct ImPolsResult {
    /// Expression IDs that should become intermediate polynomials.
    pub im_exps: Vec<usize>,
    /// The Q polynomial degree (cExp polynomial degree minus 1).
    pub q_deg: i64,
}

/// Greedy search over constraint degrees 2..=max_q_deg to find the split
/// that minimizes added base-field columns.
///
/// Returns the optimal `(im_exps, q_deg)`.
pub fn calculate_intermediate_polynomials(
    expressions: &[Expression],
    c_exp_id: usize,
    max_q_deg: usize,
    q_dim: usize,
) -> ImPolsResult {
    let mut d: usize = 2;

    info!("-------------------- POSSIBLE DEGREES ----------------------");
    let blowup = if max_q_deg > 1 {
        (max_q_deg as f64 - 1.0).log2()
    } else {
        0.0
    };
    info!(
        "Considering degrees between 2 and {} (blowup factor: {:.0})",
        max_q_deg, blowup
    );
    info!("------------------------------------------------------------");

    let c_exp = &expressions[c_exp_id];
    let (mut im_exps, mut q_deg) = calculate_im_pols(expressions, c_exp_id, c_exp, d);
    let mut added_basefield_cols =
        calculate_added_cols(d, expressions, &im_exps, q_deg, q_dim);
    d += 1;

    while !im_exps.is_empty() && d <= max_q_deg {
        info!("------------------------------------------------------------");
        let (im_exps_p, q_deg_p) = calculate_im_pols(expressions, c_exp_id, c_exp, d);
        let new_added = calculate_added_cols(d, expressions, &im_exps_p, q_deg_p, q_dim);
        d += 1;

        let should_replace = if max_q_deg > 0 {
            new_added < added_basefield_cols
        } else {
            im_exps_p.is_empty()
        };

        if should_replace {
            added_basefield_cols = new_added;
            im_exps = im_exps_p.clone();
            q_deg = q_deg_p;
        }
        if im_exps_p.is_empty() {
            break;
        }
    }

    ImPolsResult { im_exps, q_deg }
}

fn calculate_added_cols(
    max_deg: usize,
    expressions: &[Expression],
    im_exps: &[usize],
    q_deg: i64,
    q_dim: usize,
) -> i64 {
    let q_cols = q_deg * q_dim as i64;
    let mut im_cols: i64 = 0;
    for &exp_id in im_exps {
        im_cols += expressions[exp_id].dim as i64;
    }
    let added_cols = q_cols + im_cols;
    info!("Max constraint degree: {}", max_deg);
    info!("Number of intermediate polynomials: {}", im_exps.len());
    info!("Polynomial Q degree: {}", q_deg);
    info!(
        "Number of columns added in the basefield: {} (Polynomial Q columns: {} + Intermediate polynomials columns: {})",
        added_cols, q_cols, im_cols
    );
    added_cols
}

// ---------------------------------------------------------------------------
// Inner recursive search (mirrors JS `_calculateImPols`)
// ---------------------------------------------------------------------------

/// Memoization key: (absolute_max, sorted list of current im_pol IDs).
type MemoKey = (usize, Vec<usize>);
/// Memoization value: (Option<im_pols_vec>, degree).
/// `None` means the search failed for this sub-tree.
type MemoVal = (Option<Vec<usize>>, i64);

fn calculate_im_pols(
    expressions: &[Expression],
    _root_id: usize,
    _c_exp: &Expression,
    max_deg: usize,
) -> (Vec<usize>, i64) {
    let absolute_max = max_deg;
    let mut abs_max_d: i64 = 0;
    let mut memo: HashMap<MemoKey, MemoVal> = HashMap::new();

    let (result_pols, rd) = calc_im_pols_inner(
        expressions,
        _root_id,
        &Vec::new(),
        max_deg,
        absolute_max,
        &mut abs_max_d,
        &mut memo,
    );

    match result_pols {
        Some(pols) => {
            let final_deg = rd.max(abs_max_d) - 1;
            (pols, final_deg)
        }
        None => (Vec::new(), rd.max(abs_max_d).max(1) - 1),
    }
}

/// Recursive core. Returns `(Option<im_pols>, degree)`.
/// `None` in the first position means the sub-problem is infeasible.
fn calc_im_pols_inner(
    expressions: &[Expression],
    idx: usize,
    im_pols: &[usize],
    max_deg: usize,
    absolute_max: usize,
    abs_max_d: &mut i64,
    memo: &mut HashMap<MemoKey, MemoVal>,
) -> (Option<Vec<usize>>, i64) {
    let exp = &expressions[idx];
    let op = exp.op.as_str();

    match op {
        "add" | "sub" => {
            let mut md: i64 = 0;
            let mut current_pols = im_pols.to_vec();
            for &child_id in &exp.values {
                let (child_pols, d) = calc_im_pols_inner(
                    expressions,
                    child_id,
                    &current_pols,
                    max_deg,
                    absolute_max,
                    abs_max_d,
                    memo,
                );
                match child_pols {
                    None => return (None, -1),
                    Some(p) => {
                        current_pols = p;
                        if d > md {
                            md = d;
                        }
                    }
                }
            }
            (Some(current_pols), md)
        }
        "mul" => {
            // If either child is a non-composite degree-0 node, skip it
            let lhs = &expressions[exp.values[0]];
            if !["add", "mul", "sub", "exp"].contains(&lhs.op.as_str()) && lhs.exp_deg == 0 {
                return calc_im_pols_inner(
                    expressions,
                    exp.values[1],
                    im_pols,
                    max_deg,
                    absolute_max,
                    abs_max_d,
                    memo,
                );
            }
            let rhs = &expressions[exp.values[1]];
            if !["add", "mul", "sub", "exp"].contains(&rhs.op.as_str()) && rhs.exp_deg == 0 {
                return calc_im_pols_inner(
                    expressions,
                    exp.values[0],
                    im_pols,
                    max_deg,
                    absolute_max,
                    abs_max_d,
                    memo,
                );
            }

            let max_deg_here = exp.exp_deg as usize;
            if max_deg_here <= max_deg {
                return (Some(im_pols.to_vec()), max_deg_here as i64);
            }

            let mut eb: Option<Vec<usize>> = None;
            let mut ed: i64 = -1;

            for l in 0..=max_deg {
                let r = max_deg - l;
                let (e1, d1) = calc_im_pols_inner(
                    expressions,
                    exp.values[0],
                    im_pols,
                    l,
                    absolute_max,
                    abs_max_d,
                    memo,
                );
                if e1.is_none() {
                    continue;
                }
                let e1_vec = e1.unwrap();
                let (e2, d2) = calc_im_pols_inner(
                    expressions,
                    exp.values[1],
                    &e1_vec,
                    r,
                    absolute_max,
                    abs_max_d,
                    memo,
                );
                if let Some(ref e2_vec) = e2 {
                    let should_replace = match &eb {
                        None => true,
                        Some(prev) => e2_vec.len() < prev.len(),
                    };
                    if should_replace {
                        eb = Some(e2_vec.clone());
                        ed = d1 + d2;
                    }
                    // Cannot do better than the starting set
                    if e2_vec.len() == im_pols.len() {
                        return (eb, ed);
                    }
                }
            }
            (eb, ed)
        }
        "exp" => {
            if max_deg < 1 {
                return (None, -1);
            }
            let id = exp.id.unwrap_or(0);
            if im_pols.contains(&id) {
                return (Some(im_pols.to_vec()), 1);
            }

            // Check memo
            let mut sorted_pols = im_pols.to_vec();
            sorted_pols.sort_unstable();
            let memo_key = (absolute_max, sorted_pols);

            let (e, d) = if let Some(cached) = memo.get(&memo_key) {
                cached.clone()
            } else {
                calc_im_pols_inner(
                    expressions,
                    id,
                    im_pols,
                    absolute_max,
                    absolute_max,
                    abs_max_d,
                    memo,
                )
            };

            match e {
                None => (None, -1),
                Some(ref e_vec) => {
                    if d > max_deg as i64 {
                        if d > *abs_max_d {
                            *abs_max_d = d;
                        }
                        let mut new_pols = e_vec.clone();
                        if !new_pols.contains(&id) {
                            new_pols.push(id);
                        }
                        (Some(new_pols), 1)
                    } else {
                        // Store in memo
                        let mut sorted_key = im_pols.to_vec();
                        sorted_key.sort_unstable();
                        memo.insert(
                            (absolute_max, sorted_key),
                            (Some(e_vec.clone()), d),
                        );
                        (Some(e_vec.clone()), d)
                    }
                }
            }
        }
        _ => {
            // Leaf nodes: number, cm, const, challenge, etc.
            if exp.exp_deg == 0 {
                (Some(im_pols.to_vec()), 0)
            } else if max_deg < 1 {
                (None, -1)
            } else {
                (Some(im_pols.to_vec()), 1)
            }
        }
    }
}

// ---------------------------------------------------------------------------
// addIntermediatePolynomials
// ---------------------------------------------------------------------------

/// Add intermediate polynomial witness columns and Q polynomial columns.
///
/// `c_exp_id` is the constraint expression ID, updated in-place.
/// Returns the final `(q_deg, q_dim, c_exp_id)` to be stored in the output.
pub fn add_im_polynomials(
    expressions: &mut Vec<Expression>,
    constraints: &mut Vec<ConstraintInfo>,
    symbols: &mut Vec<SymbolInfo>,
    name: &str,
    air_id: usize,
    airgroup_id: usize,
    n_stages: usize,
    n_commitments: &mut usize,
    c_exp_id: &mut usize,
    im_exps: &[usize],
    q_deg: i64,
    im_pols_stages: bool,
    boundaries: &[(String, Option<i64>, Option<i64>)],
) -> usize {
    let dim = FIELD_EXTENSION;
    let stage = n_stages + 1;

    // Count existing challenges before this stage for vc_id
    let vc_id = symbols
        .iter()
        .filter(|s| s.sym_type == "challenge" && s.stage.map_or(false, |st| st < stage))
        .count();

    // Create virtual challenge node
    let vc_idx = expressions.len();
    expressions.push(Expression {
        op: "challenge".to_string(),
        id: Some(vc_id),
        dim,
        stage,
        stage_id: Some(0),
        exp_deg: 0,
        ..Default::default()
    });

    for &exp_id in im_exps {
        let stage_im = if im_pols_stages {
            expressions[exp_id].stage
        } else {
            n_stages
        };

        let stage_id = symbols
            .iter()
            .filter(|s| s.sym_type == "witness" && s.stage == Some(stage_im))
            .count();

        let exp_dim = get_exp_dim(expressions, exp_id);

        let pol_id = *n_commitments;
        *n_commitments += 1;

        symbols.push(SymbolInfo {
            sym_type: "witness".to_string(),
            name: format!("{}.ImPol", name),
            id: Some(exp_id),
            pol_id: Some(pol_id),
            stage: Some(stage_im),
            stage_id: Some(stage_id),
            dim: exp_dim,
            air_id: Some(air_id),
            airgroup_id: Some(airgroup_id),
            ..Default::default()
        });

        expressions[exp_id].im_pol = true;
        expressions[exp_id].pol_id = Some(pol_id);
        expressions[exp_id].stage = stage_im;

        // Create sub-constraint: cm - imExpr
        // LHS: cm node for the new witness
        let cm_idx = expressions.len();
        expressions.push(Expression {
            op: "cm".to_string(),
            id: Some(pol_id),
            row_offset: Some(0),
            stage: stage_im,
            dim: exp_dim,
            ..Default::default()
        });

        // RHS: copy of the im expression (reference via "exp" node)
        let exp_ref_idx = expressions.len();
        expressions.push(Expression {
            op: "exp".to_string(),
            id: Some(exp_id),
            row_offset: Some(0),
            stage: expressions[exp_id].stage,
            ..Default::default()
        });

        // sub node: cm - exp
        let sub_idx = expressions.len();
        expressions.push(Expression {
            op: "sub".to_string(),
            values: vec![cm_idx, exp_ref_idx],
            ..Default::default()
        });
        add_info_expressions(expressions, sub_idx);
        let constraint_id = sub_idx;

        constraints.push(ConstraintInfo {
            e: constraint_id,
            boundary: "everyRow".to_string(),
            line: Some(format!("{}.ImPol", name)),
            stage: Some(expressions[exp_id].stage),
            offset_min: None,
            offset_max: None,
            im_pol: false,
        });

        // Weighted constraint: vc * exp(cExpId)
        let c_exp_ref = expressions.len();
        expressions.push(Expression {
            op: "exp".to_string(),
            id: Some(*c_exp_id),
            row_offset: Some(0),
            stage,
            ..Default::default()
        });

        let weighted_idx = expressions.len();
        expressions.push(Expression {
            op: "mul".to_string(),
            values: vec![vc_idx, c_exp_ref],
            ..Default::default()
        });
        add_info_expressions(expressions, weighted_idx);

        // Accumulated: weighted + constraint
        let constraint_ref = expressions.len();
        expressions.push(Expression {
            op: "exp".to_string(),
            id: Some(constraint_id),
            row_offset: Some(0),
            stage,
            ..Default::default()
        });

        let weighted_ref = expressions.len();
        expressions.push(Expression {
            op: "exp".to_string(),
            id: Some(weighted_idx),
            row_offset: Some(0),
            stage,
            ..Default::default()
        });

        let accum_idx = expressions.len();
        expressions.push(Expression {
            op: "add".to_string(),
            values: vec![weighted_ref, constraint_ref],
            ..Default::default()
        });
        add_info_expressions(expressions, accum_idx);
        *c_exp_id = accum_idx;
    }

    // Q polynomial: cExp * zi(everyRow)
    let every_row_idx = boundaries
        .iter()
        .position(|(bname, _, _)| bname == "everyRow")
        .unwrap_or(0);

    let c_exp_ref = expressions.len();
    expressions.push(Expression {
        op: "exp".to_string(),
        id: Some(*c_exp_id),
        row_offset: Some(0),
        stage,
        ..Default::default()
    });

    let zi_idx = expressions.len();
    expressions.push(Expression {
        op: "Zi".to_string(),
        boundary_id: Some(every_row_idx),
        boundary: Some("everyRow".to_string()),
        ..Default::default()
    });

    let q_idx = expressions.len();
    expressions.push(Expression {
        op: "mul".to_string(),
        values: vec![c_exp_ref, zi_idx],
        ..Default::default()
    });
    add_info_expressions(expressions, q_idx);
    *c_exp_id = q_idx;

    let c_exp_dim = get_exp_dim(expressions, *c_exp_id);
    expressions[*c_exp_id].dim = c_exp_dim;

    let q_dim = c_exp_dim;

    // Create Q polynomial witness symbols
    for i in 0..q_deg {
        let index = *n_commitments;
        *n_commitments += 1;
        symbols.push(SymbolInfo {
            sym_type: "witness".to_string(),
            name: format!("Q{}", i),
            pol_id: Some(index),
            stage: Some(stage),
            dim: q_dim,
            air_id: Some(air_id),
            airgroup_id: Some(airgroup_id),
            ..Default::default()
        });
    }

    q_dim
}

// ---------------------------------------------------------------------------
// Default for SymbolInfo (needed for the `..Default::default()` above)
// ---------------------------------------------------------------------------

impl Default for SymbolInfo {
    fn default() -> Self {
        Self {
            name: String::new(),
            sym_type: String::new(),
            stage: None,
            dim: 1,
            id: None,
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
        }
    }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

#[cfg(test)]
mod tests {
    use super::*;
    use crate::expression::Expression;

    /// Helper: create a number expression
    fn make_number(val: &str) -> Expression {
        Expression {
            op: "number".to_string(),
            value: Some(val.to_string()),
            exp_deg: 0,
            dim: 1,
            ..Default::default()
        }
    }

    /// Helper: create a committed polynomial (witness) node
    fn make_cm(id: usize, stage: usize) -> Expression {
        Expression {
            op: "cm".to_string(),
            id: Some(id),
            stage,
            dim: 1,
            exp_deg: 1,
            row_offset: Some(0),
            ..Default::default()
        }
    }

    /// Helper: create an "exp" reference node
    fn make_exp_ref(id: usize) -> Expression {
        Expression {
            op: "exp".to_string(),
            id: Some(id),
            ..Default::default()
        }
    }

    /// Helper: create a mul node
    fn make_mul(lhs: usize, rhs: usize, deg: i64) -> Expression {
        Expression {
            op: "mul".to_string(),
            values: vec![lhs, rhs],
            exp_deg: deg,
            ..Default::default()
        }
    }

    // -----------------------------------------------------------------------
    // calculate_exp_deg tests
    // -----------------------------------------------------------------------

    #[test]
    fn test_calc_exp_deg_leaf() {
        let exprs = vec![make_cm(0, 1)];
        let mut cache = HashMap::new();
        assert_eq!(calculate_exp_deg(&exprs, 0, &[], false, &mut cache), 1);
    }

    #[test]
    fn test_calc_exp_deg_mul() {
        // exprs[0] = cm, exprs[1] = cm, exprs[2] = mul(0,1)
        let exprs = vec![
            make_cm(0, 1),
            make_cm(1, 1),
            make_mul(0, 1, 2),
        ];
        let mut cache = HashMap::new();
        assert_eq!(calculate_exp_deg(&exprs, 2, &[], false, &mut cache), 2);
    }

    #[test]
    fn test_calc_exp_deg_with_im_pol() {
        // exprs[0] = cm*cm => deg 2 normally
        // exprs[1] = exp ref to 0
        // If 0 is in im_exps, the exp ref should return 1
        let exprs = vec![
            make_mul(0, 0, 2), // placeholder, not used directly
            make_cm(0, 1),
            make_cm(1, 1),
            make_mul(1, 2, 2), // exprs[3] = cm*cm, deg 2
            make_exp_ref(3),   // exprs[4] = exp ref to 3
        ];
        let mut cache = HashMap::new();
        // Without imPol
        assert_eq!(calculate_exp_deg(&exprs, 4, &[], false, &mut cache), 2);
        // With imPol on expr 3
        assert_eq!(calculate_exp_deg(&exprs, 4, &[3], false, &mut cache), 1);
    }

    #[test]
    fn test_calc_exp_deg_number() {
        let exprs = vec![make_number("42")];
        let mut cache = HashMap::new();
        assert_eq!(calculate_exp_deg(&exprs, 0, &[], false, &mut cache), 0);
    }

    // -----------------------------------------------------------------------
    // calculate_intermediate_polynomials tests
    // -----------------------------------------------------------------------

    #[test]
    fn test_no_im_pols_needed() {
        // Simple degree-2 expression: cm * cm
        // With maxQDeg=2, no intermediate polynomials needed (qDeg = 2-1 = 1)
        let exprs = vec![
            make_cm(0, 1),     // 0
            make_cm(1, 1),     // 1
            make_mul(0, 1, 2), // 2: deg 2
        ];
        let result = calculate_intermediate_polynomials(&exprs, 2, 3, 1);
        assert!(
            result.im_exps.is_empty(),
            "No intermediate polynomials should be needed for degree-2 expr with maxQDeg=3"
        );
        assert_eq!(result.q_deg, 1); // deg 2 - 1
    }

    #[test]
    fn test_im_pols_needed_for_high_degree() {
        // Build a degree-4 expression tree:
        //   exprs[0] = cm_a (deg 1)
        //   exprs[1] = cm_b (deg 1)
        //   exprs[2] = mul(0,1) => deg 2
        //   exprs[3] = exp ref to 2 => deg 2
        //   exprs[4] = cm_c (deg 1)
        //   exprs[5] = cm_d (deg 1)
        //   exprs[6] = mul(4,5) => deg 2
        //   exprs[7] = exp ref to 6 => deg 2
        //   exprs[8] = mul(3,7) => deg 4
        //
        // With maxQDeg=2 (max constraint deg=2), we need imPols.
        let exprs = vec![
            make_cm(0, 1),     // 0
            make_cm(1, 1),     // 1
            make_mul(0, 1, 2), // 2: cm_a * cm_b, deg 2
            make_exp_ref(2),   // 3: ref to expr 2, deg 2
            make_cm(2, 1),     // 4
            make_cm(3, 1),     // 5
            make_mul(4, 5, 2), // 6: cm_c * cm_d, deg 2
            make_exp_ref(6),   // 7: ref to expr 6, deg 2
            make_mul(3, 7, 4), // 8: (cm_a*cm_b) * (cm_c*cm_d), deg 4
        ];
        // Set exp_deg on exp refs
        let mut exprs = exprs;
        exprs[3].exp_deg = 2;
        exprs[7].exp_deg = 2;

        let result = calculate_intermediate_polynomials(&exprs, 8, 2, 1);
        // At maxQDeg=2, the algorithm should mark at least one sub-expression
        // as an intermediate polynomial to bring the degree down.
        assert!(
            !result.im_exps.is_empty(),
            "Intermediate polynomials should be needed for degree-4 expr with maxQDeg=2"
        );
    }

    #[test]
    fn test_degree_fits_without_im_pols() {
        // Build an expression tree using exp references (as in real pilout):
        //   exprs[0] = cm_a (deg 1)
        //   exprs[1] = cm_b (deg 1)
        //   exprs[2] = mul(0,1) => deg 2, this is the "definition" of sub-expr 2
        //   exprs[3] = exp ref to 2 => deg 2
        //   exprs[4] = cm_c (deg 1)
        //   exprs[5] = mul(3,4) => deg 3
        //
        // With maxQDeg=3, degree 3 fits directly via d=2 (if the tree cooperates).
        // But since the root mul has no exp refs at top level, the algorithm
        // cannot split -- it returns no imPols and the caller must handle the
        // resulting qDeg accordingly.
        //
        // Use a tree that fits at d=2:
        //   exprs[0] = cm_a
        //   exprs[1] = cm_b
        //   exprs[2] = mul(0,1) => deg 2
        // With maxQDeg=2, the mul node fits directly.
        let exprs = vec![
            make_cm(0, 1),     // 0
            make_cm(1, 1),     // 1
            make_mul(0, 1, 2), // 2: deg 2
        ];
        let result = calculate_intermediate_polynomials(&exprs, 2, 3, 1);
        assert!(result.im_exps.is_empty());
        assert_eq!(result.q_deg, 1); // 2 - 1
    }

    // -----------------------------------------------------------------------
    // add_im_polynomials tests
    // -----------------------------------------------------------------------

    #[test]
    fn test_add_im_pols_creates_q_symbols() {
        // Minimal setup: a degree-2 expression, no im_exps, q_deg=1
        let mut expressions = vec![
            make_cm(0, 1),     // 0
            make_cm(1, 1),     // 1
            make_mul(0, 1, 2), // 2: cExp
        ];
        let mut constraints = Vec::new();
        let mut symbols = Vec::new();
        let mut n_commitments: usize = 2;
        let mut c_exp_id: usize = 2;
        let boundaries = vec![("everyRow".to_string(), None, None)];

        let q_dim = add_im_polynomials(
            &mut expressions,
            &mut constraints,
            &mut symbols,
            "test_air",
            0,
            0,
            1,
            &mut n_commitments,
            &mut c_exp_id,
            &[],
            1, // q_deg
            false,
            &boundaries,
        );

        // Should have added 1 Q polynomial witness symbol
        let q_symbols: Vec<_> = symbols.iter().filter(|s| s.name.starts_with("Q")).collect();
        assert_eq!(q_symbols.len(), 1);
        assert_eq!(q_symbols[0].sym_type, "witness");
        assert!(q_dim >= 1);
    }

    #[test]
    fn test_add_im_pols_with_im_exp() {
        // Setup with one intermediate polynomial
        let mut expressions = vec![
            make_cm(0, 1),     // 0: cm_a
            make_cm(1, 1),     // 1: cm_b
            make_mul(0, 1, 2), // 2: cm_a * cm_b (will be im_pol)
            make_cm(2, 1),     // 3: cm_c
            {
                // 4: exp ref to expr 2
                let mut e = make_exp_ref(2);
                e.exp_deg = 2;
                e
            },
            make_mul(4, 3, 3), // 5: ref(cm_a*cm_b) * cm_c, deg 3 (cExp)
        ];
        let mut constraints = Vec::new();
        let mut symbols = Vec::new();
        let mut n_commitments: usize = 3;
        let mut c_exp_id: usize = 5;
        let boundaries = vec![("everyRow".to_string(), None, None)];

        let _q_dim = add_im_polynomials(
            &mut expressions,
            &mut constraints,
            &mut symbols,
            "test_air",
            0,
            0,
            1,
            &mut n_commitments,
            &mut c_exp_id,
            &[2], // expr 2 is the intermediate polynomial
            1,
            false,
            &boundaries,
        );

        // Should have: 1 ImPol witness + 1 Q witness = 2 symbols
        let im_symbols: Vec<_> = symbols
            .iter()
            .filter(|s| s.name.contains("ImPol"))
            .collect();
        assert_eq!(im_symbols.len(), 1);
        assert_eq!(im_symbols[0].sym_type, "witness");

        let q_symbols: Vec<_> = symbols.iter().filter(|s| s.name.starts_with("Q")).collect();
        assert_eq!(q_symbols.len(), 1);

        // Should have added one constraint for the im polynomial
        assert_eq!(constraints.len(), 1);
        assert_eq!(constraints[0].boundary, "everyRow");

        // Expression for im_pol should be marked
        assert!(expressions[2].im_pol);
        assert!(expressions[2].pol_id.is_some());
    }
}
