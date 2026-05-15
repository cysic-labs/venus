use anyhow::{Context, Result};
use pilout_crate::pilout::{
    constraint, expression, operand, Air, Constraint, Expression, FixedCol, Operand, Symbol,
    SymbolType,
};

use crate::recursive_setup::plonk::{FixedColumn, PlonkLayout, PlonkLayoutKind};

#[derive(Debug, Clone, PartialEq)]
pub struct RecursiveAirLayout {
    pub air: Air,
    pub symbols: Vec<Symbol>,
}

pub fn build_air_layout(
    layout: &PlonkLayout,
    airgroup_id: u32,
    air_id: u32,
    air_name: &str,
    n_publics: u32,
) -> Result<RecursiveAirLayout> {
    let n_rows = u32::try_from(layout.shape.n_rows)
        .with_context(|| format!("recursive AIR row count {} exceeds u32", layout.shape.n_rows))?;
    let witness_width = u32::try_from(layout.shape.committed_pols).with_context(|| {
        format!("recursive AIR witness width {} exceeds u32", layout.shape.committed_pols)
    })?;
    let connection_width = connection_intermediate_width(layout.shape.kind);

    let fixed_cols = layout.fixed_columns.iter().map(to_proto_fixed_col).collect();
    let air = Air {
        name: Some(air_name.to_string()),
        num_rows: Some(n_rows),
        periodic_cols: Vec::new(),
        fixed_cols,
        stage_widths: vec![witness_width, connection_width],
        expressions: Vec::new(),
        constraints: Vec::new(),
        air_values: Vec::new(),
        aggregable: false,
        custom_commits: Vec::new(),
    };

    let symbols = build_symbols(
        &layout.fixed_columns,
        layout.shape.kind,
        airgroup_id,
        air_id,
        witness_width,
        n_publics,
    )?;

    Ok(RecursiveAirLayout { air, symbols })
}

pub fn connection_intermediate_width(kind: PlonkLayoutKind) -> u32 {
    1 + connection_im_low_width(kind)
}

pub fn connection_im_low_width(kind: PlonkLayoutKind) -> u32 {
    match kind {
        PlonkLayoutKind::Aggregation => 3,
        PlonkLayoutKind::Compressor => 8,
        PlonkLayoutKind::FinalVadcop => 4,
    }
}

fn build_non_poseidon_constraints(kind: PlonkLayoutKind) -> (Vec<Expression>, Vec<Constraint>) {
    let mut builder = RecursiveExpressionBuilder::new(kind);
    builder.add_plonk_constraints();
    builder.add_cmul_constraints();
    builder.add_fft4_constraints();
    builder.add_evpol4_constraints();
    builder.add_tree_selector4_constraints();
    builder.add_select_value1_constraints();
    builder.finish()
}

fn to_proto_fixed_col(column: &FixedColumn) -> FixedCol {
    FixedCol { values: column.values.iter().map(|value| value.to_le_bytes().to_vec()).collect() }
}

fn build_symbols(
    fixed_columns: &[FixedColumn],
    kind: PlonkLayoutKind,
    airgroup_id: u32,
    air_id: u32,
    witness_width: u32,
    n_publics: u32,
) -> Result<Vec<Symbol>> {
    let mut symbols = Vec::new();
    symbols.extend(group_fixed_symbols(fixed_columns, airgroup_id, air_id)?);

    symbols.push(pol_array_symbol(
        "a",
        SymbolType::WitnessCol,
        airgroup_id,
        air_id,
        1,
        0,
        witness_width,
    ));
    symbols.push(pol_scalar_symbol("gprod", SymbolType::WitnessCol, airgroup_id, air_id, 2, 0));
    symbols.push(pol_array_symbol(
        "im_low",
        SymbolType::WitnessCol,
        airgroup_id,
        air_id,
        2,
        1,
        connection_im_low_width(kind),
    ));

    if n_publics > 0 {
        symbols.push(array_symbol(
            "publics",
            SymbolType::PublicValue,
            airgroup_id,
            air_id,
            1,
            0,
            n_publics,
        ));
    }

    symbols.push(challenge_symbol("std_alpha", 2, 0));
    symbols.push(challenge_symbol("std_gamma", 2, 1));
    Ok(symbols)
}

fn group_fixed_symbols(
    fixed_columns: &[FixedColumn],
    airgroup_id: u32,
    air_id: u32,
) -> Result<Vec<Symbol>> {
    let mut symbols = Vec::new();
    let mut fixed_id = 0u32;
    let mut idx = 0usize;

    while idx < fixed_columns.len() {
        let column = &fixed_columns[idx];
        if let Some(width) = consecutive_array_width(fixed_columns, idx)? {
            symbols.push(pol_array_symbol(
                &column.name,
                SymbolType::FixedCol,
                airgroup_id,
                air_id,
                0,
                fixed_id,
                width,
            ));
            fixed_id += width;
            idx += width as usize;
        } else {
            symbols.push(pol_scalar_symbol(
                &column.name,
                SymbolType::FixedCol,
                airgroup_id,
                air_id,
                0,
                fixed_id,
            ));
            fixed_id += 1;
            idx += 1;
        }
    }

    Ok(symbols)
}

fn consecutive_array_width(columns: &[FixedColumn], start: usize) -> Result<Option<u32>> {
    let first = &columns[start];
    if first.lengths != [0] {
        return Ok(None);
    }

    let mut width = 1usize;
    while start + width < columns.len() {
        let column = &columns[start + width];
        if column.name != first.name {
            break;
        }
        if column.lengths != [width as u32] {
            break;
        }
        width += 1;
    }

    if width == 1 {
        return Ok(None);
    }
    u32::try_from(width)
        .map(Some)
        .with_context(|| format!("fixed column array {} is too wide", first.name))
}

fn pol_array_symbol(
    name: &str,
    symbol_type: SymbolType,
    airgroup_id: u32,
    air_id: u32,
    stage: u32,
    id: u32,
    len: u32,
) -> Symbol {
    array_symbol(name, symbol_type, airgroup_id, air_id, stage, id, len)
}

fn array_symbol(
    name: &str,
    symbol_type: SymbolType,
    airgroup_id: u32,
    air_id: u32,
    stage: u32,
    id: u32,
    len: u32,
) -> Symbol {
    Symbol {
        name: name.to_string(),
        air_group_id: Some(airgroup_id),
        air_id: Some(air_id),
        r#type: symbol_type as i32,
        id,
        stage: Some(stage),
        dim: 1,
        lengths: vec![len],
        commit_id: None,
        debug_line: None,
    }
}

fn pol_scalar_symbol(
    name: &str,
    symbol_type: SymbolType,
    airgroup_id: u32,
    air_id: u32,
    stage: u32,
    id: u32,
) -> Symbol {
    Symbol {
        name: name.to_string(),
        air_group_id: Some(airgroup_id),
        air_id: Some(air_id),
        r#type: symbol_type as i32,
        id,
        stage: Some(stage),
        dim: 1,
        lengths: Vec::new(),
        commit_id: None,
        debug_line: None,
    }
}

fn challenge_symbol(name: &str, stage: u32, id: u32) -> Symbol {
    Symbol {
        name: name.to_string(),
        air_group_id: None,
        air_id: None,
        r#type: SymbolType::Challenge as i32,
        id,
        stage: Some(stage),
        dim: 3,
        lengths: Vec::new(),
        commit_id: None,
        debug_line: None,
    }
}

#[derive(Debug, Clone, Copy)]
struct FixedIds {
    c_start: u32,
    poseidon_sponge: u32,
    poseidon_compression: u32,
    poseidon_partial_round: u32,
    poseidon_final: u32,
    cmul: u32,
    evpol4: u32,
    fft4: u32,
    tree_selector4: u32,
    select_value1: u32,
    plonk: u32,
}

impl FixedIds {
    fn for_kind(kind: PlonkLayoutKind) -> Self {
        let connection_cols = match kind {
            PlonkLayoutKind::Aggregation => 27,
            PlonkLayoutKind::Compressor => 36,
            PlonkLayoutKind::FinalVadcop => 33,
        };
        let c_start = connection_cols;
        let flags_start = c_start + 10;
        Self {
            c_start,
            poseidon_sponge: flags_start,
            poseidon_compression: flags_start + 1,
            poseidon_partial_round: flags_start + 2,
            poseidon_final: flags_start + 3,
            cmul: flags_start + 4,
            evpol4: flags_start + 5,
            fft4: flags_start + 6,
            tree_selector4: flags_start + 7,
            select_value1: flags_start + 8,
            plonk: flags_start + 9,
        }
    }
}

#[derive(Debug, Clone)]
struct Expr {
    operand: Operand,
}

struct RecursiveExpressionBuilder {
    kind: PlonkLayoutKind,
    fixed: FixedIds,
    expressions: Vec<Expression>,
    constraints: Vec<Constraint>,
}

impl RecursiveExpressionBuilder {
    fn new(kind: PlonkLayoutKind) -> Self {
        Self {
            kind,
            fixed: FixedIds::for_kind(kind),
            expressions: Vec::new(),
            constraints: Vec::new(),
        }
    }

    fn finish(self) -> (Vec<Expression>, Vec<Constraint>) {
        (self.expressions, self.constraints)
    }

    fn add_plonk_constraints(&mut self) {
        for slot in self.plonk_slots() {
            let a = [self.a(slot.start), self.a(slot.start + 1), self.a(slot.start + 2)];
            let q = [
                self.c(slot.c_offset),
                self.c(slot.c_offset + 1),
                self.c(slot.c_offset + 2),
                self.c(slot.c_offset + 3),
                self.c(slot.c_offset + 4),
            ];
            let mut selector = self.check_plonk_selector();
            for extra in slot.extra_selectors {
                selector = self.add(selector, self.fixed_selector(extra));
            }
            self.add_plonk_gate(&a, &q, selector);
        }
    }

    fn add_plonk_gate(&mut self, a: &[Expr; 3], c: &[Expr; 5], selector: Expr) {
        let mul = self.mul(a[0].clone(), a[1].clone());
        let qm = self.mul(c[0].clone(), mul);
        let ql = self.mul(c[1].clone(), a[0].clone());
        let qr = self.mul(c[2].clone(), a[1].clone());
        let qo = self.mul(c[3].clone(), a[2].clone());
        let terms = vec![qm, ql, qr, qo, c[4].clone()];
        let body = self.sum(terms);
        let constraint = self.mul(selector, body);
        self.assert_zero(constraint);
    }

    fn add_cmul_constraints(&mut self) {
        let slots = match self.kind {
            PlonkLayoutKind::Compressor => {
                [[0, 3, 6], [9, 12, 15], [18, 21, 24], [27, 30, 33]].as_slice()
            }
            _ => [[0, 3, 6], [9, 12, 15], [18, 21, 24]].as_slice(),
        };
        let selector = self.fixed_selector(self.fixed.cmul);
        for [a_start, b_start, out_start] in slots {
            let a = self.ext3(*a_start);
            let b = self.ext3(*b_start);
            let out = self.ext3(*out_start);
            self.add_cmul_gate(&a, &b, &out, selector.clone());
        }
    }

    fn add_cmul_gate(&mut self, a: &[Expr; 3], b: &[Expr; 3], out: &[Expr; 3], selector: Expr) {
        let expected = self.ext3_mul(a, b);
        for (expected, actual) in expected.into_iter().zip(out.iter()) {
            let diff = self.sub(actual.clone(), expected);
            let constraint = self.mul(selector.clone(), diff);
            self.assert_zero(constraint);
        }
    }

    fn add_fft4_constraints(&mut self) {
        let selector = self.fixed_selector(self.fixed.fft4);
        let input = (0..12).map(|idx| self.a(idx)).collect::<Vec<_>>();
        let output = (12..24).map(|idx| self.a(idx)).collect::<Vec<_>>();
        let c = (0..9).map(|idx| self.c(idx)).collect::<Vec<_>>();
        let specs = [
            (0, [(0, 0, 1), (1, 3, 1), (2, 6, 1), (3, 9, 1), (6, 0, 1), (7, 3, 1)]),
            (1, [(0, 1, 1), (1, 4, 1), (2, 7, 1), (3, 10, 1), (6, 1, 1), (7, 4, 1)]),
            (2, [(0, 2, 1), (1, 5, 1), (2, 8, 1), (3, 11, 1), (6, 2, 1), (7, 5, 1)]),
            (3, [(0, 0, 1), (1, 3, -1), (4, 6, 1), (5, 9, -1), (6, 0, 1), (7, 3, -1)]),
            (4, [(0, 1, 1), (1, 4, -1), (4, 7, 1), (5, 10, -1), (6, 1, 1), (7, 4, -1)]),
            (5, [(0, 2, 1), (1, 5, -1), (4, 8, 1), (5, 11, -1), (6, 2, 1), (7, 5, -1)]),
            (6, [(0, 0, 1), (1, 3, 1), (2, 6, -1), (3, 9, -1), (6, 6, 1), (8, 9, 1)]),
            (7, [(0, 1, 1), (1, 4, 1), (2, 7, -1), (3, 10, -1), (6, 7, 1), (8, 10, 1)]),
            (8, [(0, 2, 1), (1, 5, 1), (2, 8, -1), (3, 11, -1), (6, 8, 1), (8, 11, 1)]),
            (9, [(0, 0, 1), (1, 3, -1), (4, 6, -1), (5, 9, 1), (6, 6, 1), (8, 9, -1)]),
            (10, [(0, 1, 1), (1, 4, -1), (4, 7, -1), (5, 10, 1), (6, 7, 1), (8, 10, -1)]),
            (11, [(0, 2, 1), (1, 5, -1), (4, 8, -1), (5, 11, 1), (6, 8, 1), (8, 11, -1)]),
        ];

        for (out_idx, terms) in specs {
            let mut rhs_terms = Vec::with_capacity(terms.len());
            for (c_idx, input_idx, sign) in terms {
                let term = self.mul(c[c_idx].clone(), input[input_idx].clone());
                rhs_terms.push(if sign < 0 { self.neg(term) } else { term });
            }
            let rhs = self.sum(rhs_terms);
            let diff = self.sub(output[out_idx].clone(), rhs);
            let constraint = self.mul(selector.clone(), diff);
            self.assert_zero(constraint);
        }
    }

    fn add_evpol4_constraints(&mut self) {
        let selector = self.fixed_selector(self.fixed.evpol4);
        let coefs = [self.ext3(12), self.ext3(9), self.ext3(6), self.ext3(3), self.ext3(0)];
        let x = self.ext3(15);
        let out = self.ext3(18);
        let mut acc = coefs[0].clone();
        for coef in coefs.iter().skip(1) {
            let mul = self.ext3_mul(&acc, &x);
            acc = [
                self.add(mul[0].clone(), coef[0].clone()),
                self.add(mul[1].clone(), coef[1].clone()),
                self.add(mul[2].clone(), coef[2].clone()),
            ];
        }
        for (lhs, rhs) in acc.into_iter().zip(out.into_iter()) {
            let diff = self.sub(lhs, rhs);
            let constraint = self.mul(selector.clone(), diff);
            self.assert_zero(constraint);
        }
    }

    fn add_tree_selector4_constraints(&mut self) {
        let selector = self.fixed_selector(self.fixed.tree_selector4);
        self.add_select_constraints(selector, 3);
    }

    fn add_select_value1_constraints(&mut self) {
        let selector = self.fixed_selector(self.fixed.select_value1);
        self.add_select_constraints(selector, 4);
    }

    fn add_select_constraints(&mut self, selector: Expr, value_width: u32) {
        let key0 = self.a(4 * value_width);
        let key1 = self.a(4 * value_width + 1);
        let masks = self.select_masks(key0.clone(), key1.clone());
        let out_start = 4 * value_width + 2;
        for (value_idx, mask) in masks.into_iter().enumerate() {
            for limb in 0..value_width {
                let value = self.a(value_idx as u32 * value_width + limb);
                let out = self.a(out_start + limb);
                let diff = self.sub(value, out);
                let selected = self.mul(mask.clone(), diff);
                let constraint = self.mul(selector.clone(), selected);
                self.assert_zero(constraint);
            }
        }
        self.add_bool_constraint(selector.clone(), key0);
        self.add_bool_constraint(selector, key1);
    }

    fn add_bool_constraint(&mut self, selector: Expr, value: Expr) {
        let one_minus = self.sub(self.one(), value.clone());
        let body = self.mul(value, one_minus);
        let constraint = self.mul(selector, body);
        self.assert_zero(constraint);
    }

    fn ext3_mul(&mut self, a: &[Expr; 3], b: &[Expr; 3]) -> [Expr; 3] {
        let r0_t0 = self.mul(a[0].clone(), b[0].clone());
        let r0_t1 = self.mul(a[1].clone(), b[2].clone());
        let r0_t2 = self.mul(a[2].clone(), b[1].clone());
        let r0 = self.sum(vec![r0_t0, r0_t1, r0_t2]);

        let r1_t0 = self.mul(a[0].clone(), b[1].clone());
        let r1_t1 = self.mul(a[1].clone(), b[0].clone());
        let r1_t2 = self.mul(a[1].clone(), b[2].clone());
        let r1_t3 = self.mul(a[2].clone(), b[1].clone());
        let r1_t4 = self.mul(a[2].clone(), b[2].clone());
        let r1 = self.sum(vec![r1_t0, r1_t1, r1_t2, r1_t3, r1_t4]);

        let r2_t0 = self.mul(a[0].clone(), b[2].clone());
        let r2_t1 = self.mul(a[2].clone(), b[2].clone());
        let r2_t2 = self.mul(a[2].clone(), b[0].clone());
        let r2_t3 = self.mul(a[1].clone(), b[1].clone());
        let r2 = self.sum(vec![r2_t0, r2_t1, r2_t2, r2_t3]);
        [r0, r1, r2]
    }

    fn select_masks(&mut self, key0: Expr, key1: Expr) -> [Expr; 4] {
        let not_key0 = self.sub(self.one(), key0.clone());
        let not_key1 = self.sub(self.one(), key1.clone());
        [
            self.mul(not_key0.clone(), not_key1.clone()),
            self.mul(key0.clone(), not_key1),
            self.mul(not_key0, key1.clone()),
            self.mul(key0, key1),
        ]
    }

    fn plonk_slots(&self) -> Vec<PlonkSlot> {
        match self.kind {
            PlonkLayoutKind::Aggregation => vec![
                PlonkSlot::new(0, 0, &[]),
                PlonkSlot::new(3, 0, &[]),
                PlonkSlot::new(6, 5, &[]),
                PlonkSlot::new(9, 5, &[]),
                PlonkSlot::new(12, 5, &[]),
                PlonkSlot::new(15, 5, &[]),
                PlonkSlot::new(18, 5, &[self.fixed.poseidon_final, self.fixed.tree_selector4]),
                PlonkSlot::new(
                    21,
                    5,
                    &[self.fixed.poseidon_final, self.fixed.tree_selector4, self.fixed.evpol4],
                ),
                PlonkSlot::new(
                    24,
                    5,
                    &[
                        self.fixed.poseidon_final,
                        self.fixed.tree_selector4,
                        self.fixed.evpol4,
                        self.fixed.poseidon_sponge,
                        self.fixed.poseidon_compression,
                        self.fixed.select_value1,
                    ],
                ),
            ],
            PlonkLayoutKind::Compressor => vec![
                PlonkSlot::new(0, 0, &[]),
                PlonkSlot::new(3, 0, &[]),
                PlonkSlot::new(6, 0, &[]),
                PlonkSlot::new(9, 0, &[]),
                PlonkSlot::new(12, 0, &[]),
                PlonkSlot::new(15, 0, &[]),
                PlonkSlot::new(18, 5, &[self.fixed.tree_selector4, self.fixed.poseidon_final]),
                PlonkSlot::new(
                    21,
                    5,
                    &[self.fixed.tree_selector4, self.fixed.poseidon_final, self.fixed.evpol4],
                ),
                PlonkSlot::new(
                    24,
                    5,
                    &[
                        self.fixed.tree_selector4,
                        self.fixed.poseidon_final,
                        self.fixed.evpol4,
                        self.fixed.select_value1,
                        self.fixed.poseidon_sponge,
                        self.fixed.poseidon_compression,
                    ],
                ),
                PlonkSlot::new(
                    27,
                    5,
                    &[
                        self.fixed.tree_selector4,
                        self.fixed.poseidon_final,
                        self.fixed.evpol4,
                        self.fixed.select_value1,
                        self.fixed.poseidon_sponge,
                        self.fixed.poseidon_compression,
                    ],
                ),
                PlonkSlot::new(
                    30,
                    5,
                    &[
                        self.fixed.tree_selector4,
                        self.fixed.poseidon_final,
                        self.fixed.evpol4,
                        self.fixed.select_value1,
                        self.fixed.poseidon_sponge,
                        self.fixed.poseidon_compression,
                    ],
                ),
                PlonkSlot::new(
                    33,
                    5,
                    &[
                        self.fixed.tree_selector4,
                        self.fixed.poseidon_final,
                        self.fixed.evpol4,
                        self.fixed.select_value1,
                        self.fixed.poseidon_sponge,
                        self.fixed.poseidon_compression,
                    ],
                ),
            ],
            PlonkLayoutKind::FinalVadcop => vec![
                PlonkSlot::new(0, 0, &[]),
                PlonkSlot::new(3, 0, &[]),
                PlonkSlot::new(6, 5, &[]),
                PlonkSlot::new(9, 5, &[]),
                PlonkSlot::new(12, 5, &[]),
                PlonkSlot::new(15, 5, &[]),
                PlonkSlot::new(18, 5, &[self.fixed.poseidon_final, self.fixed.tree_selector4]),
                PlonkSlot::new(
                    21,
                    5,
                    &[self.fixed.poseidon_final, self.fixed.tree_selector4, self.fixed.evpol4],
                ),
                PlonkSlot::new(
                    24,
                    5,
                    &[
                        self.fixed.poseidon_final,
                        self.fixed.tree_selector4,
                        self.fixed.evpol4,
                        self.fixed.poseidon_sponge,
                        self.fixed.poseidon_compression,
                        self.fixed.select_value1,
                    ],
                ),
                PlonkSlot::new(
                    27,
                    5,
                    &[
                        self.fixed.poseidon_final,
                        self.fixed.tree_selector4,
                        self.fixed.evpol4,
                        self.fixed.poseidon_sponge,
                        self.fixed.poseidon_compression,
                        self.fixed.select_value1,
                    ],
                ),
                PlonkSlot::new(
                    30,
                    5,
                    &[
                        self.fixed.poseidon_final,
                        self.fixed.tree_selector4,
                        self.fixed.evpol4,
                        self.fixed.poseidon_sponge,
                        self.fixed.poseidon_compression,
                        self.fixed.select_value1,
                    ],
                ),
            ],
        }
    }

    fn check_plonk_selector(&mut self) -> Expr {
        match self.kind {
            PlonkLayoutKind::Compressor => self.sum(vec![
                self.fixed_selector(self.fixed.plonk),
                self.fixed_selector_offset(self.fixed.poseidon_sponge, -1),
                self.fixed_selector_offset(self.fixed.poseidon_compression, -1),
                self.fixed_selector_offset(self.fixed.poseidon_sponge, -2),
                self.fixed_selector_offset(self.fixed.poseidon_compression, -2),
                self.fixed_selector_offset(self.fixed.poseidon_partial_round, -2),
                self.fixed_selector_offset(self.fixed.poseidon_partial_round, -1),
                self.fixed_selector(self.fixed.poseidon_partial_round),
                self.fixed_selector_offset(self.fixed.poseidon_partial_round, 1),
                self.fixed_selector_offset(self.fixed.poseidon_final, -2),
                self.fixed_selector_offset(self.fixed.poseidon_final, -1),
            ]),
            PlonkLayoutKind::Aggregation | PlonkLayoutKind::FinalVadcop => self.sum(vec![
                self.fixed_selector(self.fixed.plonk),
                self.fixed_selector_offset(self.fixed.poseidon_partial_round, 1),
                self.fixed_selector(self.fixed.poseidon_partial_round),
                self.fixed_selector_offset(self.fixed.poseidon_final, 1),
            ]),
        }
    }

    fn ext3(&self, start: u32) -> [Expr; 3] {
        [self.a(start), self.a(start + 1), self.a(start + 2)]
    }

    fn fixed_selector(&self, id: u32) -> Expr {
        self.fixed_selector_offset(id, 0)
    }

    fn fixed_selector_offset(&self, id: u32, offset: i32) -> Expr {
        Expr {
            operand: Operand {
                operand: Some(operand::Operand::FixedCol(operand::FixedCol {
                    idx: id,
                    row_offset: offset,
                })),
            },
        }
    }

    fn c(&self, offset: u32) -> Expr {
        self.fixed_selector(self.fixed.c_start + offset)
    }

    fn a(&self, idx: u32) -> Expr {
        Expr {
            operand: Operand {
                operand: Some(operand::Operand::WitnessCol(operand::WitnessCol {
                    stage: 1,
                    col_idx: idx,
                    row_offset: 0,
                })),
            },
        }
    }

    fn number(&self, value: u64) -> Expr {
        Expr {
            operand: Operand {
                operand: Some(operand::Operand::Constant(operand::Constant {
                    value: value.to_le_bytes().to_vec(),
                })),
            },
        }
    }

    fn zero(&self) -> Expr {
        self.number(0)
    }

    fn one(&self) -> Expr {
        self.number(1)
    }

    fn add(&mut self, lhs: Expr, rhs: Expr) -> Expr {
        self.push(expression::Operation::Add(expression::Add {
            lhs: Some(lhs.operand),
            rhs: Some(rhs.operand),
        }))
    }

    fn sub(&mut self, lhs: Expr, rhs: Expr) -> Expr {
        self.push(expression::Operation::Sub(expression::Sub {
            lhs: Some(lhs.operand),
            rhs: Some(rhs.operand),
        }))
    }

    fn mul(&mut self, lhs: Expr, rhs: Expr) -> Expr {
        self.push(expression::Operation::Mul(expression::Mul {
            lhs: Some(lhs.operand),
            rhs: Some(rhs.operand),
        }))
    }

    fn neg(&mut self, value: Expr) -> Expr {
        self.push(expression::Operation::Neg(expression::Neg { value: Some(value.operand) }))
    }

    fn sum(&mut self, mut terms: Vec<Expr>) -> Expr {
        if terms.is_empty() {
            return self.zero();
        }
        let mut acc = terms.remove(0);
        for term in terms {
            acc = self.add(acc, term);
        }
        acc
    }

    fn push(&mut self, operation: expression::Operation) -> Expr {
        let idx = self.expressions.len() as u32;
        self.expressions.push(Expression { operation: Some(operation) });
        Expr {
            operand: Operand {
                operand: Some(operand::Operand::Expression(operand::Expression { idx })),
            },
        }
    }

    fn assert_zero(&mut self, expr: Expr) {
        let idx = match expr.operand.operand {
            Some(operand::Operand::Expression(expression)) => expression.idx,
            _ => {
                let wrapped = self.add(expr, self.zero());
                match wrapped.operand.operand {
                    Some(operand::Operand::Expression(expression)) => expression.idx,
                    _ => unreachable!("wrapped expression must be an expression operand"),
                }
            }
        };
        self.constraints.push(Constraint {
            constraint: Some(constraint::Constraint::EveryRow(constraint::EveryRow {
                expression_idx: Some(operand::Expression { idx }),
                debug_line: None,
            })),
        });
    }
}

#[derive(Debug, Clone)]
struct PlonkSlot {
    start: u32,
    c_offset: u32,
    extra_selectors: Vec<u32>,
}

impl PlonkSlot {
    fn new(start: u32, c_offset: u32, extra_selectors: &[u32]) -> Self {
        Self { start, c_offset, extra_selectors: extra_selectors.to_vec() }
    }
}

#[cfg(test)]
mod tests {
    use anyhow::Result;

    use super::*;
    use crate::recursive_setup::plonk::{build_layout, PlonkLayoutKind};
    use crate::recursive_setup::r1cs::{R1cs, R1csConstraint, GOLDILOCKS_P};

    #[test]
    fn builds_aggregation_air_column_schema() -> Result<()> {
        let layout =
            build_layout(&one_constraint_r1cs(), PlonkLayoutKind::Aggregation, "Recursive2")?;
        let air = build_air_layout(&layout, 0, 0, "recursive2", 473)?;

        assert_eq!(air.air.name.as_deref(), Some("recursive2"));
        assert_eq!(air.air.fixed_cols.len(), 49);
        assert_eq!(air.air.stage_widths, vec![59, 4]);
        assert!(air.symbols.iter().any(|symbol| {
            symbol.name == "Recursive2.S"
                && symbol.r#type == SymbolType::FixedCol as i32
                && symbol.lengths == [27]
        }));
        assert!(air.symbols.iter().any(|symbol| {
            symbol.name == "Recursive2.C"
                && symbol.r#type == SymbolType::FixedCol as i32
                && symbol.lengths == [10]
        }));
        assert!(air.symbols.iter().any(|symbol| {
            symbol.name == "a"
                && symbol.r#type == SymbolType::WitnessCol as i32
                && symbol.stage == Some(1)
                && symbol.lengths == [59]
        }));
        assert!(air.symbols.iter().any(|symbol| {
            symbol.name == "im_low"
                && symbol.r#type == SymbolType::WitnessCol as i32
                && symbol.stage == Some(2)
                && symbol.id == 1
                && symbol.lengths == [3]
        }));
        assert!(air.symbols.iter().any(|symbol| {
            symbol.name == "publics"
                && symbol.r#type == SymbolType::PublicValue as i32
                && symbol.lengths == [473]
        }));
        Ok(())
    }

    #[test]
    fn records_kind_specific_connection_widths() {
        assert_eq!(connection_intermediate_width(PlonkLayoutKind::Aggregation), 4);
        assert_eq!(connection_intermediate_width(PlonkLayoutKind::Compressor), 9);
        assert_eq!(connection_intermediate_width(PlonkLayoutKind::FinalVadcop), 5);
    }

    #[test]
    fn builds_non_poseidon_constraint_groups() {
        let (_, aggregation) = build_non_poseidon_constraints(PlonkLayoutKind::Aggregation);
        let (_, compressor) = build_non_poseidon_constraints(PlonkLayoutKind::Compressor);
        let (_, final_vadcop) = build_non_poseidon_constraints(PlonkLayoutKind::FinalVadcop);

        assert_eq!(aggregation.len(), 65);
        assert_eq!(compressor.len(), 71);
        assert_eq!(final_vadcop.len(), 67);
    }

    fn one_constraint_r1cs() -> R1cs {
        R1cs {
            n8: 8,
            prime: GOLDILOCKS_P,
            n_vars: 5,
            n_outputs: 0,
            n_pub_inputs: 0,
            n_prv_inputs: 0,
            n_labels: 0,
            n_constraints: 1,
            constraints: vec![R1csConstraint {
                a: [(1, 2)].into_iter().collect(),
                b: [(2, 3)].into_iter().collect(),
                c: [(3, 4)].into_iter().collect(),
            }],
            wire_map: Vec::new(),
            custom_gates: Vec::new(),
            custom_gate_uses: Vec::new(),
        }
    }
}
