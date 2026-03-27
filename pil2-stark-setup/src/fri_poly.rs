use std::collections::BTreeMap;

use crate::expression::Expression;
use crate::helpers::{get_exp_dim, EvMapItem};
use crate::pilout_info::{SymbolInfo, FIELD_EXTENSION};

/// Result of FRI polynomial generation.
#[derive(Debug, Clone)]
pub struct FriPolyResult {
    /// Expression index of the FRI polynomial in the expression arena.
    pub fri_exp_id: usize,
}

/// Generate the FRI polynomial expression.
///
/// Mirrors `generateFRIPolynomial` from
/// `pil2-proofman-js/src/pil2-stark/pil_info/helpers/polynomials/friPolinomial.js`.
///
/// This function:
/// 1. Creates `std_vf1` and `std_vf2` challenge symbols
/// 2. For each evaluation in ev_map, builds `sub(column, eval(i))` and
///    accumulates with vf2 per opening point
/// 3. For each opening point, multiplies by `xDivXSubXi` and accumulates
///    with vf1
pub fn generate_fri_polynomial(
    n_stages: usize,
    expressions: &mut Vec<Expression>,
    symbols: &mut Vec<SymbolInfo>,
    ev_map: &[EvMapItem],
    opening_points: &[i64],
    challenges_map: &mut Vec<ChallengeMapEntry>,
) -> FriPolyResult {
    let stage = n_stages + 3;

    // Create std_vf1 challenge
    let vf1_id = symbols
        .iter()
        .filter(|s| {
            s.sym_type == "challenge" && s.stage.map_or(false, |st| st < stage)
        })
        .count();
    let vf2_id = vf1_id + 1;

    let vf1_symbol = SymbolInfo {
        sym_type: "challenge".to_string(),
        name: "std_vf1".to_string(),
        stage: Some(stage),
        dim: FIELD_EXTENSION,
        stage_id: Some(0),
        id: Some(vf1_id),
        pol_id: None,
        air_id: None,
        airgroup_id: None,
        commit_id: None,
        lengths: None,
        idx: None,
        stage_pos: None,
        im_pol: false,
        exp_id: None,
    };
    let vf2_symbol = SymbolInfo {
        sym_type: "challenge".to_string(),
        name: "std_vf2".to_string(),
        stage: Some(stage),
        dim: FIELD_EXTENSION,
        stage_id: Some(1),
        id: Some(vf2_id),
        pol_id: None,
        air_id: None,
        airgroup_id: None,
        commit_id: None,
        lengths: None,
        idx: None,
        stage_pos: None,
        im_pol: false,
        exp_id: None,
    };

    symbols.push(vf1_symbol.clone());
    symbols.push(vf2_symbol.clone());

    // Update challenges map
    extend_challenges_map(challenges_map, vf1_id, &vf1_symbol);
    extend_challenges_map(challenges_map, vf2_id, &vf2_symbol);

    // Build vf1 and vf2 expression nodes
    let vf1_expr = Expression {
        op: "challenge".to_string(),
        value: Some("std_vf1".to_string()),
        stage,
        dim: FIELD_EXTENSION,
        stage_id: Some(0),
        id: Some(vf1_id),
        ..Default::default()
    };
    let vf1_idx = expressions.len();
    expressions.push(vf1_expr);

    let vf2_expr = Expression {
        op: "challenge".to_string(),
        value: Some("std_vf2".to_string()),
        stage,
        dim: FIELD_EXTENSION,
        stage_id: Some(1),
        id: Some(vf2_id),
        ..Default::default()
    };
    let vf2_idx = expressions.len();
    expressions.push(vf2_expr);

    // Build per-opening-point FRI sub-expressions.
    // Use BTreeMap so we iterate in sorted order of opening points.
    let mut fri_exps: BTreeMap<i64, usize> = BTreeMap::new();

    for (i, ev) in ev_map.iter().enumerate() {
        // Find the symbol matching this evaluation
        let symbol = find_symbol_for_ev(symbols, ev);

        // Build the column expression node
        let col_expr = build_column_expr(ev, &symbol);
        let col_idx = expressions.len();
        expressions.push(col_expr);

        // Build eval(i) node
        let eval_expr = Expression {
            op: "eval".to_string(),
            id: Some(i),
            dim: FIELD_EXTENSION,
            ..Default::default()
        };
        let eval_idx = expressions.len();
        expressions.push(eval_expr);

        // sub(column, eval(i))
        let sub_expr = Expression {
            op: "sub".to_string(),
            values: vec![col_idx, eval_idx],
            ..Default::default()
        };
        let sub_idx = expressions.len();
        expressions.push(sub_expr);

        if let Some(&existing_idx) = fri_exps.get(&ev.prime) {
            // acc = add(mul(existing, vf2), sub)
            let mul_expr = Expression {
                op: "mul".to_string(),
                values: vec![existing_idx, vf2_idx],
                ..Default::default()
            };
            let mul_idx = expressions.len();
            expressions.push(mul_expr);

            let add_expr = Expression {
                op: "add".to_string(),
                values: vec![mul_idx, sub_idx],
                ..Default::default()
            };
            let add_idx = expressions.len();
            expressions.push(add_expr);

            fri_exps.insert(ev.prime, add_idx);
        } else {
            fri_exps.insert(ev.prime, sub_idx);
        }
    }

    // Combine per-opening-point expressions with xDivXSubXi and vf1
    let mut fri_exp: Option<usize> = None;

    for (i, &opening) in opening_points.iter().enumerate() {
        let opening_expr_idx = *fri_exps
            .get(&opening)
            .expect("Opening point not found in fri_exps");

        // xDivXSubXi(opening, i)
        let xdiv_expr = Expression {
            op: "xDivXSubXi".to_string(),
            opening: Some(opening as usize),
            id: Some(i),
            ..Default::default()
        };
        let xdiv_idx = expressions.len();
        expressions.push(xdiv_expr);

        // mul(fri_exps[opening], xDivXSubXi)
        let mul_expr = Expression {
            op: "mul".to_string(),
            values: vec![opening_expr_idx, xdiv_idx],
            ..Default::default()
        };
        let mul_idx = expressions.len();
        expressions.push(mul_expr);

        if let Some(prev_fri_idx) = fri_exp {
            // add(mul(vf1, prev_fri), current)
            let vf1_mul = Expression {
                op: "mul".to_string(),
                values: vec![vf1_idx, prev_fri_idx],
                ..Default::default()
            };
            let vf1_mul_idx = expressions.len();
            expressions.push(vf1_mul);

            let add_expr = Expression {
                op: "add".to_string(),
                values: vec![vf1_mul_idx, mul_idx],
                ..Default::default()
            };
            let add_idx = expressions.len();
            expressions.push(add_expr);
            fri_exp = Some(add_idx);
        } else {
            fri_exp = Some(mul_idx);
        }
    }

    let fri_exp_id = fri_exp.expect("At least one opening point required");

    // Store the FRI expression at a known position and set its metadata
    let fri_final_id = expressions.len();
    let fri_final_expr = expressions[fri_exp_id].clone();
    expressions.push(fri_final_expr);

    // Set dim and stage on the final expression
    let dim = get_exp_dim(expressions, fri_final_id);
    expressions[fri_final_id].dim = dim;
    expressions[fri_final_id].stage = n_stages + 2;

    FriPolyResult {
        fri_exp_id: fri_final_id,
    }
}

/// Entry in the challenges map (matches JSON output format).
#[derive(Debug, Clone)]
pub struct ChallengeMapEntry {
    pub name: String,
    pub stage: usize,
    pub dim: usize,
    pub stage_id: usize,
}

/// Extend the challenges_map to accommodate an entry at a given index.
fn extend_challenges_map(
    challenges_map: &mut Vec<ChallengeMapEntry>,
    id: usize,
    symbol: &SymbolInfo,
) {
    while challenges_map.len() <= id {
        challenges_map.push(ChallengeMapEntry {
            name: String::new(),
            stage: 0,
            dim: 0,
            stage_id: 0,
        });
    }
    challenges_map[id] = ChallengeMapEntry {
        name: symbol.name.clone(),
        stage: symbol.stage.unwrap_or(0),
        dim: symbol.dim,
        stage_id: symbol.stage_id.unwrap_or(0),
    };
}

/// Find the symbol matching an evaluation map entry.
fn find_symbol_for_ev(symbols: &[SymbolInfo], ev: &EvMapItem) -> SymbolInfo {
    let sym_type_target = match ev.entry_type.as_str() {
        "const" => "fixed",
        "cm" => "witness",
        "custom" => "custom",
        other => panic!("Unknown ev type: {}", other),
    };

    symbols
        .iter()
        .find(|s| {
            s.pol_id == Some(ev.id)
                && s.sym_type == sym_type_target
                && (ev.entry_type != "custom"
                    || s.commit_id == ev.commit_id)
        })
        .unwrap_or_else(|| panic!("Symbol not found for ev type={} id={}", ev.entry_type, ev.id))
        .clone()
}

/// Build a column expression node for an evaluation entry.
fn build_column_expr(ev: &EvMapItem, symbol: &SymbolInfo) -> Expression {
    Expression {
        op: ev.entry_type.clone(),
        id: Some(ev.id),
        row_offset: Some(0),
        stage: symbol.stage.unwrap_or(0),
        dim: symbol.dim,
        commit_id: symbol.commit_id,
        ..Default::default()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn make_witness_symbol(name: &str, pol_id: usize, stage: usize) -> SymbolInfo {
        SymbolInfo {
            name: name.to_string(),
            sym_type: "witness".to_string(),
            stage: Some(stage),
            dim: 1,
            pol_id: Some(pol_id),
            stage_id: Some(0),
            id: Some(pol_id),
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

    fn make_fixed_symbol(name: &str, pol_id: usize) -> SymbolInfo {
        SymbolInfo {
            name: name.to_string(),
            sym_type: "fixed".to_string(),
            stage: Some(0),
            dim: 1,
            pol_id: Some(pol_id),
            stage_id: Some(0),
            id: Some(pol_id),
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

    #[test]
    fn test_generate_fri_polynomial_basic() {
        let mut expressions: Vec<Expression> = Vec::new();
        let mut symbols = vec![
            make_witness_symbol("w0", 0, 1),
            make_fixed_symbol("f0", 0),
        ];
        let ev_map = vec![
            EvMapItem {
                entry_type: "cm".to_string(),
                id: 0,
                prime: 0,
                commit_id: None,
            },
            EvMapItem {
                entry_type: "const".to_string(),
                id: 0,
                prime: 0,
                commit_id: None,
            },
        ];
        let opening_points = vec![0];
        let mut challenges_map = Vec::new();

        let result = generate_fri_polynomial(
            1,
            &mut expressions,
            &mut symbols,
            &ev_map,
            &opening_points,
            &mut challenges_map,
        );

        assert!(result.fri_exp_id > 0);

        // Should have added std_vf1 and std_vf2
        let challenge_names: Vec<&str> = symbols
            .iter()
            .filter(|s| s.sym_type == "challenge")
            .map(|s| s.name.as_str())
            .collect();
        assert!(challenge_names.contains(&"std_vf1"));
        assert!(challenge_names.contains(&"std_vf2"));
        assert_eq!(challenges_map.len(), challenge_names.len());
    }

    #[test]
    fn test_generate_fri_polynomial_multiple_openings() {
        let mut expressions: Vec<Expression> = Vec::new();
        let mut symbols = vec![
            make_witness_symbol("w0", 0, 1),
            make_witness_symbol("w1", 1, 1),
        ];
        let ev_map = vec![
            EvMapItem {
                entry_type: "cm".to_string(),
                id: 0,
                prime: 0,
                commit_id: None,
            },
            EvMapItem {
                entry_type: "cm".to_string(),
                id: 1,
                prime: 1,
                commit_id: None,
            },
        ];
        let opening_points = vec![0, 1];
        let mut challenges_map = Vec::new();

        let result = generate_fri_polynomial(
            1,
            &mut expressions,
            &mut symbols,
            &ev_map,
            &opening_points,
            &mut challenges_map,
        );

        assert!(result.fri_exp_id > 0);
        // The final expression should exist
        assert!(result.fri_exp_id < expressions.len());
    }
}
