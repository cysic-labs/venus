use crate::expression::Expression;
use crate::helpers::{add_info_expressions, get_exp_dim};
use crate::pilout_info::{ConstraintInfo, SymbolInfo, FIELD_EXTENSION};

/// Result of constraint polynomial generation, attached to the setup result.
#[derive(Debug, Clone)]
pub struct ConstraintPolyResult {
    /// Expression index of the accumulated constraint polynomial.
    pub c_exp_id: usize,
    /// Field dimension of the constraint polynomial.
    pub q_dim: usize,
    /// Maximum constraint degree (before intermediate polynomial optimization).
    pub initial_q_degree: i64,
}

/// Boundary entry for the result.
#[derive(Debug, Clone)]
pub struct Boundary {
    pub name: String,
    pub offset_min: Option<u32>,
    pub offset_max: Option<u32>,
}

/// Generate the constraint polynomial by combining all constraints with a
/// random linear combination challenge (`std_vc`).
///
/// Mirrors `generateConstraintPolynomial` from
/// `pil2-proofman-js/src/pil2-stark/pil_info/helpers/polynomials/constraintPolynomial.js`.
///
/// This function:
/// 1. Creates the `std_vc` challenge symbol
/// 2. For each constraint, wraps non-everyRow boundaries with Zi
/// 3. Accumulates: c_exp = c_exp * vc + next_constraint
/// 4. Creates the `std_xi` challenge symbol
/// 5. Computes the initial (pre-imPol) constraint degree
pub fn generate_constraint_polynomial(
    n_stages: usize,
    expressions: &mut Vec<Expression>,
    symbols: &mut Vec<SymbolInfo>,
    constraints: &[ConstraintInfo],
    boundaries: &mut Vec<Boundary>,
) -> ConstraintPolyResult {
    let dim = FIELD_EXTENSION;
    let stage = n_stages + 1;

    // Create std_vc challenge
    let vc_id = symbols
        .iter()
        .filter(|s| {
            s.sym_type == "challenge" && s.stage.map_or(false, |st| st < stage)
        })
        .count();

    symbols.push(SymbolInfo {
        sym_type: "challenge".to_string(),
        name: "std_vc".to_string(),
        stage: Some(stage),
        dim,
        stage_id: Some(0),
        id: Some(vc_id),
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

    // Build the vc expression node (inline, not in arena)
    let vc_expr = Expression {
        op: "challenge".to_string(),
        stage,
        dim,
        stage_id: Some(0),
        id: Some(vc_id),
        value: Some("std_vc".to_string()),
        ..Default::default()
    };
    let vc_idx = expressions.len();
    expressions.push(vc_expr);

    let mut c_exp_id: Option<usize> = None;

    for (i, constraint) in constraints.iter().enumerate() {
        let boundary = &constraint.boundary;
        if !["everyRow", "firstRow", "lastRow", "everyFrame"].contains(&boundary.as_str()) {
            panic!("Boundary {} not supported", boundary);
        }

        // Build expression reference to the constraint's expression
        let e = Expression {
            op: "exp".to_string(),
            id: Some(constraint.e),
            row_offset: Some(0),
            stage,
            ..Default::default()
        };
        let e_idx = expressions.len();
        expressions.push(e);

        let constraint_id;

        if boundary == "everyFrame" {
            let boundary_id = find_or_add_boundary_every_frame(
                boundaries,
                constraint.offset_min,
                constraint.offset_max,
            );
            let zi = Expression {
                op: "Zi".to_string(),
                boundary_id: Some(boundary_id),
                boundary: Some("everyFrame".to_string()),
                ..Default::default()
            };
            let zi_idx = expressions.len();
            expressions.push(zi);

            let mul_expr = Expression {
                op: "mul".to_string(),
                values: vec![e_idx, zi_idx],
                ..Default::default()
            };
            expressions.push(mul_expr);
            constraint_id = expressions.len() - 1;
        } else if boundary != "everyRow" {
            let boundary_id = find_or_add_boundary(boundaries, boundary);
            let zi = Expression {
                op: "Zi".to_string(),
                boundary_id: Some(boundary_id),
                boundary: Some(boundary.clone()),
                ..Default::default()
            };
            let zi_idx = expressions.len();
            expressions.push(zi);

            let mul_expr = Expression {
                op: "mul".to_string(),
                values: vec![e_idx, zi_idx],
                ..Default::default()
            };
            expressions.push(mul_expr);
            constraint_id = expressions.len() - 1;
        } else {
            constraint_id = e_idx;
        }

        if i == 0 {
            c_exp_id = Some(constraint_id);
        } else {
            let prev_c_exp_id = c_exp_id.unwrap();
            // weighted = vc * prev_c_exp
            let prev_exp_ref = Expression {
                op: "exp".to_string(),
                id: Some(prev_c_exp_id),
                row_offset: Some(0),
                stage,
                ..Default::default()
            };
            let prev_ref_idx = expressions.len();
            expressions.push(prev_exp_ref);

            let weighted = Expression {
                op: "mul".to_string(),
                values: vec![vc_idx, prev_ref_idx],
                ..Default::default()
            };
            expressions.push(weighted);
            let weighted_id = expressions.len() - 1;
            add_info_expressions(expressions, weighted_id);

            // accumulated = weighted + current constraint
            let weighted_ref = Expression {
                op: "exp".to_string(),
                id: Some(weighted_id),
                row_offset: Some(0),
                stage,
                ..Default::default()
            };
            let weighted_ref_idx = expressions.len();
            expressions.push(weighted_ref);

            let constraint_ref = Expression {
                op: "exp".to_string(),
                id: Some(constraint_id),
                row_offset: Some(0),
                stage,
                ..Default::default()
            };
            let constraint_ref_idx = expressions.len();
            expressions.push(constraint_ref);

            let accumulated = Expression {
                op: "add".to_string(),
                values: vec![weighted_ref_idx, constraint_ref_idx],
                ..Default::default()
            };
            expressions.push(accumulated);
            let accumulated_id = expressions.len() - 1;
            add_info_expressions(expressions, accumulated_id);

            c_exp_id = Some(accumulated_id);
        }
    }

    let c_exp_id = c_exp_id.expect("At least one constraint is required");
    let q_dim = get_exp_dim(expressions, c_exp_id);

    // Create std_xi challenge for evaluation
    let xi_id = symbols
        .iter()
        .filter(|s| {
            s.sym_type == "challenge" && s.stage.map_or(false, |st| st < stage + 1)
        })
        .count();

    symbols.push(SymbolInfo {
        sym_type: "challenge".to_string(),
        name: "std_xi".to_string(),
        stage: Some(stage + 1),
        dim: FIELD_EXTENSION,
        stage_id: Some(0),
        id: Some(xi_id),
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

    // Calculate initial constraint degree
    let initial_q_degree = calculate_exp_deg(expressions, c_exp_id, &[], true);

    tracing::info!(
        "The maximum constraint degree is {} (without intermediate polynomials)",
        initial_q_degree
    );

    ConstraintPolyResult {
        c_exp_id,
        q_dim,
        initial_q_degree,
    }
}

/// Calculate the degree of an expression tree.
/// Mirrors `calculateExpDeg` from `imPolynomials.js`.
pub fn calculate_exp_deg(
    expressions: &[Expression],
    idx: usize,
    im_exps: &[usize],
    _cache_values: bool,
) -> i64 {
    let exp = &expressions[idx];
    match exp.op.as_str() {
        "exp" => {
            let ref_id = exp.id.unwrap_or(0);
            if im_exps.contains(&ref_id) {
                return 1;
            }
            calculate_exp_deg(expressions, ref_id, im_exps, _cache_values)
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
            let child_idx = exp.values[0];
            calculate_exp_deg(expressions, child_idx, im_exps, _cache_values)
        }
        "add" | "sub" | "mul" => {
            let lhs_deg = calculate_exp_deg(expressions, exp.values[0], im_exps, _cache_values);
            let rhs_deg = calculate_exp_deg(expressions, exp.values[1], im_exps, _cache_values);
            if exp.op == "mul" {
                lhs_deg + rhs_deg
            } else {
                lhs_deg.max(rhs_deg)
            }
        }
        _ => panic!("Exp op not defined: {}", exp.op),
    }
}

/// Find or add a boundary by name. Returns the index.
fn find_or_add_boundary(boundaries: &mut Vec<Boundary>, name: &str) -> usize {
    if let Some(idx) = boundaries.iter().position(|b| b.name == name) {
        return idx;
    }
    boundaries.push(Boundary {
        name: name.to_string(),
        offset_min: None,
        offset_max: None,
    });
    boundaries.len() - 1
}

/// Find or add an everyFrame boundary with matching offset_min/offset_max. Returns the index.
fn find_or_add_boundary_every_frame(
    boundaries: &mut Vec<Boundary>,
    offset_min: Option<u32>,
    offset_max: Option<u32>,
) -> usize {
    if let Some(idx) = boundaries.iter().position(|b| {
        b.name == "everyFrame" && b.offset_min == offset_min && b.offset_max == offset_max
    }) {
        return idx;
    }
    boundaries.push(Boundary {
        name: "everyFrame".to_string(),
        offset_min,
        offset_max,
    });
    boundaries.len() - 1
}

#[cfg(test)]
mod tests {
    use super::*;
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

    fn make_mul(lhs: usize, rhs: usize) -> Expression {
        Expression {
            op: "mul".to_string(),
            values: vec![lhs, rhs],
            ..Default::default()
        }
    }

    #[test]
    fn test_calculate_exp_deg_leaf() {
        let exprs = vec![Expression {
            op: "number".to_string(),
            value: Some("42".to_string()),
            ..Default::default()
        }];
        assert_eq!(calculate_exp_deg(&exprs, 0, &[], false), 0);
    }

    #[test]
    fn test_calculate_exp_deg_cm() {
        let exprs = vec![make_cm(0, 1)];
        assert_eq!(calculate_exp_deg(&exprs, 0, &[], false), 1);
    }

    #[test]
    fn test_calculate_exp_deg_mul() {
        // mul(cm0, cm1) -> degree 2
        let exprs = vec![make_cm(0, 1), make_cm(1, 1), make_mul(0, 1)];
        assert_eq!(calculate_exp_deg(&exprs, 2, &[], false), 2);
    }

    #[test]
    fn test_generate_constraint_polynomial_single() {
        // Single everyRow constraint: c_exp_id should point to the exp ref
        let cm = make_cm(0, 1);
        let mut expressions = vec![cm]; // expression 0 is a cm

        let mut symbols = Vec::new();
        let constraints = vec![ConstraintInfo {
            boundary: "everyRow".to_string(),
            e: 0,
            line: None,
            offset_min: None,
            offset_max: None,
            stage: None,
            im_pol: false,
        }];
        let mut boundaries = vec![Boundary {
            name: "everyRow".to_string(),
            offset_min: None,
            offset_max: None,
        }];

        let result = generate_constraint_polynomial(
            1,
            &mut expressions,
            &mut symbols,
            &constraints,
            &mut boundaries,
        );

        // With one constraint, c_exp_id is the exp reference to constraint 0
        assert!(result.c_exp_id > 0);
        assert_eq!(result.q_dim, 1);
        assert_eq!(result.initial_q_degree, 1);

        // Should have added std_vc and std_xi
        let challenge_names: Vec<&str> = symbols
            .iter()
            .filter(|s| s.sym_type == "challenge")
            .map(|s| s.name.as_str())
            .collect();
        assert!(challenge_names.contains(&"std_vc"));
        assert!(challenge_names.contains(&"std_xi"));
    }

    #[test]
    fn test_generate_constraint_polynomial_two() {
        // Two everyRow constraints
        let cm0 = make_cm(0, 1);
        let cm1 = make_cm(1, 1);
        let mut expressions = vec![cm0, cm1];

        let mut symbols = Vec::new();
        let constraints = vec![
            ConstraintInfo {
                boundary: "everyRow".to_string(),
                e: 0,
                line: None,
                offset_min: None,
                offset_max: None,
                stage: None,
                im_pol: false,
            },
            ConstraintInfo {
                boundary: "everyRow".to_string(),
                e: 1,
                line: None,
                offset_min: None,
                offset_max: None,
                stage: None,
                im_pol: false,
            },
        ];
        let mut boundaries = vec![Boundary {
            name: "everyRow".to_string(),
            offset_min: None,
            offset_max: None,
        }];

        let result = generate_constraint_polynomial(
            1,
            &mut expressions,
            &mut symbols,
            &constraints,
            &mut boundaries,
        );

        // With two constraints, degree should still be 1 (simple cm refs combined)
        assert!(result.c_exp_id > 1);
        assert!(result.q_dim >= 1);
    }

    #[test]
    fn test_boundary_firstrow() {
        let cm0 = make_cm(0, 1);
        let mut expressions = vec![cm0];
        let mut symbols = Vec::new();
        let constraints = vec![ConstraintInfo {
            boundary: "firstRow".to_string(),
            e: 0,
            line: None,
            offset_min: None,
            offset_max: None,
            stage: None,
            im_pol: false,
        }];
        let mut boundaries = vec![Boundary {
            name: "everyRow".to_string(),
            offset_min: None,
            offset_max: None,
        }];

        let result = generate_constraint_polynomial(
            1,
            &mut expressions,
            &mut symbols,
            &constraints,
            &mut boundaries,
        );

        // Should have added "firstRow" boundary
        assert!(boundaries.iter().any(|b| b.name == "firstRow"));
        // Degree should be 2 (cm * Zi)
        assert_eq!(result.initial_q_degree, 2);
    }
}
