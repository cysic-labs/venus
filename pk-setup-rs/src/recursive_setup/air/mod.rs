use anyhow::{Context, Result};
use fields::{Poseidon16, Poseidon2Constants};
use pilout_crate::pilout::{
    constraint, expression, hint_field, operand, Air, Constraint, Expression, FixedCol, Hint,
    HintField, HintFieldArray, Operand, Symbol, SymbolType,
};

use crate::recursive_setup::plonk::{
    connection_columns, public_row_bit, public_signal_position, FixedColumn, PlonkLayout,
    PlonkLayoutKind, PlonkLayoutShape,
};

mod poseidon;

const GOLDILOCKS_MODULUS: u128 = 18_446_744_069_414_584_321;
const GOLDILOCKS_K: u64 = 12_275_445_934_081_160_404;

#[derive(Debug, Clone, PartialEq)]
pub struct RecursiveAirLayout {
    pub air: Air,
    pub symbols: Vec<Symbol>,
    pub hints: Vec<Hint>,
}

pub fn build_air_layout(
    layout: &PlonkLayout,
    airgroup_id: u32,
    air_id: u32,
    air_name: &str,
) -> Result<RecursiveAirLayout> {
    let n_rows = u32::try_from(layout.shape.n_rows)
        .with_context(|| format!("recursive AIR row count {} exceeds u32", layout.shape.n_rows))?;
    let witness_width = u32::try_from(layout.shape.committed_pols).with_context(|| {
        format!("recursive AIR witness width {} exceeds u32", layout.shape.committed_pols)
    })?;
    let connection_width = connection_intermediate_width(layout.shape.kind);

    let (expressions, constraints, hints) = build_recursive_constraints(
        &layout.shape,
        airgroup_id,
        air_id,
        fixed_namespace(&layout.fixed_columns).as_deref(),
    );

    let fixed_cols = layout.fixed_columns.iter().map(to_proto_fixed_col).collect();
    let air = Air {
        name: Some(air_name.to_string()),
        num_rows: Some(n_rows),
        periodic_cols: Vec::new(),
        fixed_cols,
        stage_widths: vec![witness_width, connection_width],
        expressions,
        constraints,
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
        layout.shape.n_publics,
    )?;

    Ok(RecursiveAirLayout { air, symbols, hints })
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

fn build_recursive_constraints(
    shape: &PlonkLayoutShape,
    airgroup_id: u32,
    air_id: u32,
    namespace: Option<&str>,
) -> (Vec<Expression>, Vec<Constraint>, Vec<Hint>) {
    let mut builder = RecursiveExpressionBuilder::new(shape.kind);
    builder.add_plonk_constraints();
    builder.add_poseidon_constraints();
    builder.add_cmul_constraints();
    builder.add_fft4_constraints();
    builder.add_evpol4_constraints();
    builder.add_tree_selector4_constraints();
    builder.add_select_value1_constraints();
    builder.add_public_constraints(shape.n_publics, shape.n_public_rows, shape.n_public_row_bits);
    let hints = builder.add_connection_constraints(airgroup_id, air_id, namespace);
    let (expressions, constraints) = builder.finish();
    (expressions, constraints, hints)
}

fn to_proto_fixed_col(column: &FixedColumn) -> FixedCol {
    FixedCol { values: column.values.iter().map(|value| value.to_le_bytes().to_vec()).collect() }
}

fn fixed_namespace(fixed_columns: &[FixedColumn]) -> Option<String> {
    let first = fixed_columns.first()?;
    first.name.rsplit_once('.').map(|(namespace, _)| namespace.to_string())
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
    connection_cols: u32,
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
    id: u32,
    l1: u32,
    public_row_bit_start: u32,
}

impl FixedIds {
    fn for_kind(kind: PlonkLayoutKind) -> Self {
        let connection_cols = connection_columns(kind) as u32;
        let c_start = connection_cols;
        let flags_start = c_start + 10;
        Self {
            connection_cols,
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
            id: flags_start + 10,
            l1: flags_start + 11,
            public_row_bit_start: flags_start + 12,
        }
    }
}

fn connection_constraint_degree(kind: PlonkLayoutKind) -> usize {
    match kind {
        PlonkLayoutKind::Aggregation | PlonkLayoutKind::FinalVadcop => 8,
        PlonkLayoutKind::Compressor => 5,
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

    /// Binds every public input to its trace cell. With `sel[r]` the selector of public row `r`
    /// (a product of `PUBLIC_ROW_BIT` factors) and `pub[r][c] = publics[r * W + c]`, where W is the
    /// number of connection columns, each connection column `c` gets
    /// `(sum_r sel[r]) * a[c] - sum_r sel[r] * pub[r][c] === 0`. On public row `r` only `sel[r]` is
    /// 1, so the constraint forces `a[c] = pub[r][c]` (or 0 past the last public); elsewhere every
    /// selector is 0. Without these constraints the publics would only be absorbed into the
    /// transcript and a prover could claim arbitrary public values.
    fn add_public_constraints(&mut self, n_publics: u32, n_public_rows: usize, n_bits: usize) {
        if n_public_rows == 0 {
            return;
        }
        let connection_cols = self.fixed.connection_cols as usize;
        let selectors: Vec<Expr> = (0..n_public_rows)
            .map(|public_row| {
                let factors = (0..n_bits)
                    .map(|bit| {
                        let column =
                            self.fixed_selector(self.fixed.public_row_bit_start + bit as u32);
                        if public_row_bit(public_row, bit) {
                            column
                        } else {
                            self.sub(self.one(), column)
                        }
                    })
                    .collect();
                self.product(factors)
            })
            .collect();
        let public_row = self.sum(selectors.clone());
        let mut bound_terms = vec![Vec::new(); connection_cols];
        for k in 0..n_publics as usize {
            let (col, row) = public_signal_position(k, 0, connection_cols);
            let public = self.public(k as u32);
            let term = self.mul(selectors[row].clone(), public);
            bound_terms[col].push(term);
        }
        for (col, terms) in bound_terms.into_iter().enumerate() {
            let bound = self.sum(terms);
            let cell = self.mul(public_row.clone(), self.a(col as u32));
            let constraint = self.sub(cell, bound);
            self.assert_zero(constraint);
        }
    }

    fn add_plonk_constraints(&mut self) {
        let base_selector = self.check_plonk_selector();
        for slot in self.plonk_slots() {
            let a = [self.a(slot.start), self.a(slot.start + 1), self.a(slot.start + 2)];
            let q = [
                self.c(slot.c_offset),
                self.c(slot.c_offset + 1),
                self.c(slot.c_offset + 2),
                self.c(slot.c_offset + 3),
                self.c(slot.c_offset + 4),
            ];
            let mut selector = base_selector.clone();
            for extra in slot.extra_selectors {
                selector = self.add(selector, self.fixed_selector(extra));
            }
            self.add_plonk_gate(&a, &q, selector);
        }
    }

    fn add_plonk_gate(&mut self, a: &[Expr; 3], c: &[Expr; 5], selector: Expr) {
        let mul = self.mul(a[0].clone(), a[1].clone());
        let mut body = self.mul(c[0].clone(), mul);
        let ql = self.mul(c[1].clone(), a[0].clone());
        body = self.add(body, ql);
        let qr = self.mul(c[2].clone(), a[1].clone());
        body = self.add(body, qr);
        let qo = self.mul(c[3].clone(), a[2].clone());
        body = self.add(body, qo);
        body = self.add(body, c[4].clone());
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
        let expected0 = self.ext3_mul_limb0(a, b);
        let diff = self.sub(out[0].clone(), expected0);
        let constraint = self.mul(selector.clone(), diff);
        self.assert_zero(constraint);

        let expected1 = self.ext3_mul_limb1(a, b);
        let diff = self.sub(out[1].clone(), expected1);
        let constraint = self.mul(selector.clone(), diff);
        self.assert_zero(constraint);

        let expected2 = self.ext3_mul_limb2(a, b);
        let diff = self.sub(out[2].clone(), expected2);
        let constraint = self.mul(selector, diff);
        self.assert_zero(constraint);
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
            let mut rhs = None;
            for (c_idx, input_idx, sign) in terms {
                let term = self.mul(c[c_idx].clone(), input[input_idx].clone());
                rhs = Some(match rhs {
                    Some(current) if sign < 0 => self.sub(current, term),
                    Some(current) => self.add(current, term),
                    None if sign < 0 => self.neg(term),
                    None => term,
                });
            }
            let rhs = rhs.expect("FFT constraint has at least one term");
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
            let mul0 = self.ext3_mul_limb0(&acc, &x);
            let acc0 = self.add(mul0, coef[0].clone());
            let mul1 = self.ext3_mul_limb1(&acc, &x);
            let acc1 = self.add(mul1, coef[1].clone());
            let mul2 = self.ext3_mul_limb2(&acc, &x);
            let acc2 = self.add(mul2, coef[2].clone());
            acc = [acc0, acc1, acc2];
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

    fn add_connection_constraints(
        &mut self,
        airgroup_id: u32,
        air_id: u32,
        namespace: Option<&str>,
    ) -> Vec<Hint> {
        let terms = self.connection_terms();
        let groups = connection_groups(terms.len(), connection_constraint_degree(self.kind));

        let mut hints = Vec::new();
        self.add_connection_debug_hints(&mut hints, airgroup_id, air_id, namespace, &terms);

        let mut offset_num = 0usize;
        let mut offset_den = 0usize;
        let mut previous_im = None::<Expr>;
        let max_degree = connection_constraint_degree(self.kind);

        for (im_idx, _) in groups.iter().enumerate() {
            let mut rhs_terms = Vec::new();
            let mut rhs_degree = 0usize;
            if let Some(previous) = previous_im.clone() {
                rhs_terms.push(previous);
                rhs_degree = 1;
            }
            while offset_num < terms.len() {
                let next_degree = usize::from(offset_num + 1 < terms.len());
                if rhs_degree + next_degree > max_degree {
                    break;
                }
                rhs_terms.push(terms[offset_num].proves.clone());
                rhs_degree += 1;
                offset_num += 1;
            }
            let rhs = self.product(rhs_terms);

            let mut lhs_terms = Vec::new();
            let mut lhs_degree = 0usize;
            while offset_den < terms.len() {
                let next_degree = usize::from(offset_den + 1 < terms.len());
                if lhs_degree + next_degree >= max_degree {
                    break;
                }
                lhs_terms.push(terms[offset_den].assumes.clone());
                lhs_degree += 1;
                offset_den += 1;
            }
            let lhs = self.product(lhs_terms);

            let im = self.im_low(im_idx as u32);
            let im_times_lhs = self.mul(im.clone(), lhs.clone());
            let constraint = self.sub(im_times_lhs, rhs.clone());
            self.assert_zero(constraint);
            hints.push(im_col_hint(airgroup_id, air_id, im.clone(), rhs, lhs));
            previous_im = Some(im);
        }

        let mut numerator_terms = Vec::new();
        if let Some(previous) = previous_im {
            numerator_terms.push(previous);
        }
        numerator_terms.extend(terms[offset_num..].iter().map(|term| term.proves.clone()));
        let numerator = self.product(numerator_terms);
        let denominator =
            self.product(terms[offset_den..].iter().map(|term| term.assumes.clone()).collect());

        let lhs = self.mul(self.gprod(), denominator.clone());
        let one_minus_l1 = self.sub(self.one(), self.l1());
        let previous_gprod = self.mul(self.gprod_offset(-1), one_minus_l1);
        let previous_or_one = self.add(previous_gprod, self.l1());
        let rhs = self.mul(previous_or_one, numerator.clone());
        let recurrence = self.sub(lhs, rhs);
        self.assert_zero(recurrence);

        let boundary_body = self.sub(self.one(), self.gprod());
        let boundary = self.mul(self.l1_offset(1), boundary_body);
        self.assert_zero(boundary);

        hints.push(gprod_col_hint(
            airgroup_id,
            air_id,
            self.gprod(),
            numerator,
            denominator,
            self.one(),
            self.one(),
            self.one(),
        ));

        hints
    }

    fn add_connection_debug_hints(
        &self,
        hints: &mut Vec<Hint>,
        airgroup_id: u32,
        air_id: u32,
        namespace: Option<&str>,
        terms: &[ConnectionTerm],
    ) {
        let namespace = namespace.unwrap_or("Recursive");
        for (idx, term) in terms.iter().enumerate() {
            let witness_name = format!("a[{idx}]");
            let assumes_name = if idx == 0 {
                format!("{namespace}.ID")
            } else {
                format!("{} * {namespace}.ID", connection_k(idx as u32))
            };
            hints.push(gprod_debug_hint(
                airgroup_id,
                air_id,
                0,
                &[witness_name.clone(), assumes_name],
                &[term.value.clone(), term.assume_target.clone()],
            ));

            let proves_name = format!("{namespace}.S[{idx}]");
            hints.push(gprod_debug_hint(
                airgroup_id,
                air_id,
                1,
                &[witness_name, proves_name],
                &[term.value.clone(), term.prove_target.clone()],
            ));
        }
    }

    fn connection_terms(&mut self) -> Vec<ConnectionTerm> {
        let mut terms = Vec::with_capacity(self.fixed.connection_cols as usize);
        for idx in 0..self.fixed.connection_cols {
            let value = self.a(idx);
            let assume_target = self.connection_assume_target(idx);
            let prove_target = self.fixed_selector(idx);
            let assumes = self.connection_product_term(value.clone(), assume_target.clone());
            let proves = self.connection_product_term(value.clone(), prove_target.clone());
            terms.push(ConnectionTerm { value, assume_target, prove_target, assumes, proves });
        }
        terms
    }

    fn connection_assume_target(&mut self, idx: u32) -> Expr {
        let id = self.fixed_selector(self.fixed.id);
        if idx == 0 {
            id
        } else {
            self.mul(self.number(connection_k(idx)), id)
        }
    }

    fn connection_product_term(&mut self, value: Expr, target: Expr) -> Expr {
        let alpha = self.challenge(2, 0);
        let compressed = self.mul(target, alpha.clone());
        let compressed = self.add(compressed, value);
        let compressed = self.mul(compressed, alpha);
        let compressed = self.add(compressed, self.one());
        let with_gamma = self.add(compressed, self.challenge(2, 1));
        let minus_one = self.sub(with_gamma, self.one());
        self.add(minus_one, self.one())
    }

    fn add_select_constraints(&mut self, selector: Expr, value_width: u32) {
        let key0 = self.a(4 * value_width);
        let key1 = self.a(4 * value_width + 1);
        let masks = self.select_masks(key0.clone(), key1.clone());
        let out_start = 4 * value_width + 2;
        for (value_idx, mask) in masks.into_iter().enumerate() {
            for limb in 0..value_width {
                let selected_selector = self.mul(selector.clone(), mask.clone());
                let value = self.a(value_idx as u32 * value_width + limb);
                let out = self.a(out_start + limb);
                let diff = self.sub(value, out);
                let constraint = self.mul(selected_selector, diff);
                self.assert_zero(constraint);
            }
        }
        self.add_select_bool_constraint(selector.clone(), key0);
        self.add_select_bool_constraint(selector, key1);
    }

    fn add_bool_constraint(&mut self, selector: Expr, value: Expr) {
        let selected = self.mul(selector, value.clone());
        let value_minus_one = self.sub(value, self.one());
        let constraint = self.mul(selected, value_minus_one);
        self.assert_zero(constraint);
    }

    fn add_select_bool_constraint(&mut self, selector: Expr, value: Expr) {
        let one_minus = self.sub(self.one(), value.clone());
        let body = self.mul(value, one_minus);
        let constraint = self.mul(selector, body);
        self.assert_zero(constraint);
    }

    fn ext3_mul(&mut self, a: &[Expr; 3], b: &[Expr; 3]) -> [Expr; 3] {
        [self.ext3_mul_limb0(a, b), self.ext3_mul_limb1(a, b), self.ext3_mul_limb2(a, b)]
    }

    fn ext3_mul_limb0(&mut self, a: &[Expr; 3], b: &[Expr; 3]) -> Expr {
        let mut acc = self.mul(a[0].clone(), b[0].clone());
        let term = self.mul(a[1].clone(), b[2].clone());
        acc = self.add(acc, term);
        let term = self.mul(a[2].clone(), b[1].clone());
        self.add(acc, term)
    }

    fn ext3_mul_limb1(&mut self, a: &[Expr; 3], b: &[Expr; 3]) -> Expr {
        let mut acc = self.mul(a[0].clone(), b[1].clone());
        let term = self.mul(a[1].clone(), b[0].clone());
        acc = self.add(acc, term);
        let term = self.mul(a[1].clone(), b[2].clone());
        acc = self.add(acc, term);
        let term = self.mul(a[2].clone(), b[1].clone());
        acc = self.add(acc, term);
        let term = self.mul(a[2].clone(), b[2].clone());
        self.add(acc, term)
    }

    fn ext3_mul_limb2(&mut self, a: &[Expr; 3], b: &[Expr; 3]) -> Expr {
        let mut acc = self.mul(a[0].clone(), b[2].clone());
        let term = self.mul(a[2].clone(), b[2].clone());
        acc = self.add(acc, term);
        let term = self.mul(a[2].clone(), b[0].clone());
        acc = self.add(acc, term);
        let term = self.mul(a[1].clone(), b[1].clone());
        self.add(acc, term)
    }

    fn select_masks(&mut self, key0: Expr, key1: Expr) -> [Expr; 4] {
        let not_key0 = self.sub(self.one(), key0.clone());
        let not_key1 = self.sub(self.one(), key1.clone());
        let key00 = self.mul(not_key0, not_key1);
        let not_key1 = self.sub(self.one(), key1.clone());
        let key10 = self.mul(key0.clone(), not_key1);
        let not_key0 = self.sub(self.one(), key0.clone());
        let key01 = self.mul(not_key0, key1.clone());
        let key11 = self.mul(key0, key1);
        [key00, key10, key01, key11]
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
                self.fixed_selector_offset(self.fixed.poseidon_partial_round, 2),
                self.fixed_selector_offset(self.fixed.poseidon_partial_round, 1),
                self.fixed_selector(self.fixed.poseidon_partial_round),
                self.fixed_selector_offset(self.fixed.poseidon_partial_round, -1),
                self.fixed_selector_offset(self.fixed.poseidon_final, 2),
                self.fixed_selector_offset(self.fixed.poseidon_final, 1),
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

    fn l1(&self) -> Expr {
        self.l1_offset(0)
    }

    fn l1_offset(&self, offset: i32) -> Expr {
        self.fixed_selector_offset(self.fixed.l1, offset)
    }

    fn c(&self, offset: u32) -> Expr {
        self.fixed_selector(self.fixed.c_start + offset)
    }

    fn a(&self, idx: u32) -> Expr {
        self.a_offset(idx, 0)
    }

    fn a_offset(&self, idx: u32, offset: i32) -> Expr {
        Expr {
            operand: Operand {
                operand: Some(operand::Operand::WitnessCol(operand::WitnessCol {
                    stage: 1,
                    col_idx: idx,
                    row_offset: offset,
                })),
            },
        }
    }

    fn gprod(&self) -> Expr {
        self.gprod_offset(0)
    }

    fn gprod_offset(&self, offset: i32) -> Expr {
        Expr {
            operand: Operand {
                operand: Some(operand::Operand::WitnessCol(operand::WitnessCol {
                    stage: 2,
                    col_idx: 0,
                    row_offset: offset,
                })),
            },
        }
    }

    fn im_low(&self, idx: u32) -> Expr {
        Expr {
            operand: Operand {
                operand: Some(operand::Operand::WitnessCol(operand::WitnessCol {
                    stage: 2,
                    col_idx: 1 + idx,
                    row_offset: 0,
                })),
            },
        }
    }

    fn array_a(&self, start: u32, offset: i32, len: u32) -> Vec<Expr> {
        (0..len).map(|idx| self.a_offset(start + idx, offset)).collect()
    }

    fn public(&self, idx: u32) -> Expr {
        Expr {
            operand: Operand {
                operand: Some(operand::Operand::PublicValue(operand::PublicValue { idx })),
            },
        }
    }

    fn challenge(&self, stage: u32, idx: u32) -> Expr {
        Expr {
            operand: Operand {
                operand: Some(operand::Operand::Challenge(operand::Challenge { stage, idx })),
            },
        }
    }

    fn pow7(&mut self, input: Expr) -> Expr {
        let input2 = self.mul(input.clone(), input.clone());
        let input4 = self.mul(input2.clone(), input2.clone());
        let input6 = self.mul(input4, input2);
        self.mul(input6, input)
    }

    fn pow7_inline<F>(&mut self, mut input: F) -> Expr
    where
        F: FnMut(&mut Self) -> Expr,
    {
        let input2 = {
            let lhs = input(self);
            let rhs = input(self);
            self.mul(lhs, rhs)
        };
        let input4 = self.mul(input2.clone(), input2.clone());
        let input6 = self.mul(input4, input2);
        let input = input(self);
        self.mul(input6, input)
    }

    fn pow7_cached_top<F>(&mut self, input6: &mut Option<Expr>, mut input: F) -> Expr
    where
        F: FnMut(&mut Self) -> Expr,
    {
        if input6.is_none() {
            let input2 = {
                let lhs = input(self);
                let rhs = input(self);
                self.mul(lhs, rhs)
            };
            let input4 = self.mul(input2.clone(), input2.clone());
            *input6 = Some(self.mul(input4, input2));
        }
        let input6 = input6.clone().expect("input6 was just initialized");
        let input = input(self);
        self.mul(input6, input)
    }

    fn number(&self, value: u64) -> Expr {
        Expr {
            operand: Operand {
                operand: Some(operand::Operand::Constant(operand::Constant {
                    value: field_element_bytes(value),
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

    fn product(&mut self, mut terms: Vec<Expr>) -> Expr {
        if terms.is_empty() {
            return self.one();
        }
        let mut acc = terms.remove(0);
        for term in terms {
            acc = self.mul(acc, term);
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
struct ConnectionTerm {
    value: Expr,
    assume_target: Expr,
    prove_target: Expr,
    assumes: Expr,
    proves: Expr,
}

fn connection_groups(term_count: usize, max_degree: usize) -> Vec<usize> {
    let mut groups = Vec::new();
    let mut offset_num = 0usize;
    let mut offset_den = 0usize;
    let mut acc_num = 0usize;
    let mut acc_den = 0usize;

    while offset_num < term_count || offset_den < term_count {
        while offset_num < term_count {
            acc_num += 1;
            offset_num += 1;
            let next_degree = usize::from(offset_num < term_count);
            if acc_num + next_degree > max_degree {
                break;
            }
        }
        while offset_den < term_count {
            acc_den += 1;
            offset_den += 1;
            let next_degree = usize::from(offset_den < term_count);
            if acc_den + next_degree > max_degree {
                break;
            }
        }

        if !groups.is_empty()
            && offset_num == term_count
            && offset_den == term_count
            && acc_num < max_degree
            && acc_den < max_degree
        {
            break;
        }

        if acc_num == max_degree && acc_den == max_degree {
            offset_den -= 1;
            groups.push(0);
            acc_num = 1;
            acc_den = 0;
        } else if acc_num == max_degree {
            groups.push(0);
            acc_num = 1;
            acc_den = 0;
        } else if acc_den == max_degree {
            groups.push(1);
            acc_num = 0;
            acc_den = 1;
        } else {
            groups.push(0);
            acc_num = 1;
            acc_den = 0;
        }
    }

    groups
}

fn connection_k(idx: u32) -> u64 {
    let mut value = 1u64;
    for _ in 0..idx {
        value = goldilocks_mul(value, GOLDILOCKS_K);
    }
    value
}

fn goldilocks_mul(lhs: u64, rhs: u64) -> u64 {
    ((lhs as u128 * rhs as u128) % GOLDILOCKS_MODULUS) as u64
}

fn im_col_hint(
    airgroup_id: u32,
    air_id: u32,
    reference: Expr,
    numerator: Expr,
    denominator: Expr,
) -> Hint {
    hint(
        "im_col",
        airgroup_id,
        air_id,
        vec![
            operand_field("reference", reference),
            operand_field("numerator", numerator),
            operand_field("denominator", denominator),
        ],
    )
}

fn gprod_col_hint(
    airgroup_id: u32,
    air_id: u32,
    reference: Expr,
    numerator_air: Expr,
    denominator_air: Expr,
    numerator_direct: Expr,
    denominator_direct: Expr,
    result: Expr,
) -> Hint {
    hint(
        "gprod_col",
        airgroup_id,
        air_id,
        vec![
            operand_field("reference", reference),
            operand_field("numerator_air", numerator_air),
            operand_field("denominator_air", denominator_air),
            operand_field("numerator_direct", numerator_direct),
            operand_field("denominator_direct", denominator_direct),
            operand_field("result", result),
        ],
    )
}

fn gprod_debug_hint(
    airgroup_id: u32,
    air_id: u32,
    type_piop: u64,
    name_exprs: &[String],
    expressions: &[Expr],
) -> Hint {
    hint(
        "gprod_debug_data",
        airgroup_id,
        air_id,
        vec![
            string_field("name_piop", "Connection"),
            number_field("type_piop", type_piop),
            array_field("opids", vec![unnamed_number_field(1)]),
            number_field("busid", 1),
            number_field("num_reps", 1),
            array_field(
                "name_exprs",
                name_exprs.iter().map(|name| unnamed_string_field(name)).collect(),
            ),
            array_field(
                "expressions",
                expressions.iter().cloned().map(unnamed_operand_field).collect(),
            ),
            number_field("len_expressions", expressions.len() as u64),
            number_field("deg_expr", 1),
            number_field("deg_sel", 0),
        ],
    )
}

fn hint(name: &str, airgroup_id: u32, air_id: u32, fields: Vec<HintField>) -> Hint {
    Hint {
        name: name.to_string(),
        hint_fields: vec![HintField {
            name: None,
            value: Some(hint_field::Value::HintFieldArray(HintFieldArray { hint_fields: fields })),
        }],
        air_group_id: Some(airgroup_id),
        air_id: Some(air_id),
    }
}

fn string_field(name: &str, value: &str) -> HintField {
    HintField {
        name: Some(name.to_string()),
        value: Some(hint_field::Value::StringValue(value.to_string())),
    }
}

fn unnamed_string_field(value: &str) -> HintField {
    HintField { name: None, value: Some(hint_field::Value::StringValue(value.to_string())) }
}

fn number_field(name: &str, value: u64) -> HintField {
    HintField {
        name: Some(name.to_string()),
        value: Some(hint_field::Value::Operand(number_operand(value))),
    }
}

fn unnamed_number_field(value: u64) -> HintField {
    HintField { name: None, value: Some(hint_field::Value::Operand(number_operand(value))) }
}

fn operand_field(name: &str, value: Expr) -> HintField {
    HintField {
        name: Some(name.to_string()),
        value: Some(hint_field::Value::Operand(value.operand)),
    }
}

fn unnamed_operand_field(value: Expr) -> HintField {
    HintField { name: None, value: Some(hint_field::Value::Operand(value.operand)) }
}

fn array_field(name: &str, values: Vec<HintField>) -> HintField {
    HintField {
        name: Some(name.to_string()),
        value: Some(hint_field::Value::HintFieldArray(HintFieldArray { hint_fields: values })),
    }
}

fn number_operand(value: u64) -> Operand {
    Operand {
        operand: Some(operand::Operand::Constant(operand::Constant {
            value: field_element_bytes(value),
        })),
    }
}

fn field_element_bytes(value: u64) -> Vec<u8> {
    let bytes = value.to_be_bytes();
    let start = bytes.iter().position(|&byte| byte != 0).unwrap_or(bytes.len() - 1);
    bytes[start..].to_vec()
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
    use crate::pil_info::stark::{build_air_stark_draft, AirInput};
    use crate::recursive_setup::plonk::{build_layout, PlonkLayoutKind};
    use crate::recursive_setup::r1cs::{R1cs, R1csConstraint, GOLDILOCKS_P};
    use crate::stark_struct::{generate_stark_struct, StarkSettings};

    #[test]
    fn builds_aggregation_air_column_schema() -> Result<()> {
        let layout = build_layout(
            &one_constraint_r1cs_with_publics(473),
            PlonkLayoutKind::Aggregation,
            "Recursive2",
        )?;
        let air = build_air_layout(&layout, 0, 0, "recursive2")?;

        // 49 base fixed columns plus the 5 bits that index the ceil(473 / 27) = 18 public rows.
        assert_eq!(layout.shape.n_public_rows, 18);
        assert_eq!(air.air.name.as_deref(), Some("recursive2"));
        assert_eq!(air.air.fixed_cols.len(), 49 + 5);
        assert_eq!(air.air.stage_widths, vec![59, 4]);
        // 158 gate/connection constraints plus one public binding constraint per connection column.
        assert_eq!(air.air.constraints.len(), 158 + 27);
        assert!(air.symbols.iter().any(|symbol| {
            symbol.name == "Recursive2.PUBLIC_ROW_BIT"
                && symbol.r#type == SymbolType::FixedCol as i32
                && symbol.lengths == [5]
        }));
        assert_eq!(air.hints.iter().filter(|hint| hint.name == "im_col").count(), 3);
        assert_eq!(air.hints.iter().filter(|hint| hint.name == "gprod_col").count(), 1);
        assert_eq!(air.hints.iter().filter(|hint| hint.name == "gprod_debug_data").count(), 54);
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
    fn records_connection_grouping_like_legacy_std_prod() {
        assert_eq!(connection_groups(27, 8).len(), 3);
        assert_eq!(connection_groups(33, 8).len(), 4);
        assert_eq!(connection_groups(36, 5).len(), 8);
    }

    #[test]
    fn formats_connection_hints_for_stark_codegen() -> Result<()> {
        let layout = build_layout(
            &one_constraint_r1cs_with_publics(473),
            PlonkLayoutKind::Aggregation,
            "Recursive2",
        )?;
        let recursive = build_air_layout(&layout, 0, 0, "recursive2")?;
        let settings = StarkSettings { blowup_factor: Some(3), ..Default::default() };
        let stark_struct = generate_stark_struct(&settings, layout.shape.n_bits as u64)?;
        let draft = build_air_stark_draft(AirInput {
            airgroup_id: 0,
            air_id: 0,
            airgroup_values: &[],
            all_symbols: &recursive.symbols,
            all_hints: &recursive.hints,
            num_challenges: &[0, 2],
            air: &recursive.air,
            stark_struct,
        })?;

        assert_eq!(draft.hints.iter().filter(|hint| hint.name == "im_col").count(), 3);
        assert_eq!(draft.hints.iter().filter(|hint| hint.name == "gprod_col").count(), 1);
        assert!(draft.stark_info.opening_points.contains(&-1));
        assert!(draft.stark_info.opening_points.contains(&1));
        Ok(())
    }

    #[test]
    fn binds_every_public_to_its_trace_cell() -> Result<()> {
        for (kind, width) in [
            (PlonkLayoutKind::Aggregation, 27usize),
            (PlonkLayoutKind::Compressor, 36),
            (PlonkLayoutKind::FinalVadcop, 33),
        ] {
            let n_publics = 70u32;
            let layout = build_layout(&one_constraint_r1cs_with_publics(n_publics), kind, "Rec")?;
            let air = build_air_layout(&layout, 0, 0, "rec")?;
            let shape = &layout.shape;
            let public_start = shape.n_used_rows - shape.n_public_rows;
            assert_eq!(shape.n_public_rows, (n_publics as usize).div_ceil(width));
            for k in 0..n_publics as usize {
                assert_eq!(layout.signal_map[k % width][public_start + k / width], 1 + k as u32);
            }

            // The selector of a public row, a product of PUBLIC_ROW_BIT factors, is 1 exactly on
            // that row and 0 on every other row of the trace.
            let bit_start = FixedIds::for_kind(kind).public_row_bit_start as usize;
            let bits = &layout.fixed_columns[bit_start..bit_start + shape.n_public_row_bits];
            for public_row in 0..shape.n_public_rows {
                for row in 0..shape.n_rows {
                    let selected = bits.iter().enumerate().all(|(bit, column)| {
                        column.values[row] == u64::from(public_row_bit(public_row, bit))
                    });
                    assert_eq!(selected, row == public_start + public_row);
                }
            }

            // Every public is weighted by the selector of its row exactly once.
            let public_refs = air
                .air
                .expressions
                .iter()
                .filter(|expression| {
                    matches!(
                        &expression.operation,
                        Some(expression::Operation::Mul(expression::Mul {
                            rhs: Some(Operand { operand: Some(operand::Operand::PublicValue(_)) }),
                            ..
                        }))
                    )
                })
                .count();
            assert_eq!(public_refs, n_publics as usize);
        }
        Ok(())
    }

    fn one_constraint_r1cs_with_publics(n_publics: u32) -> R1cs {
        let mut r1cs = one_constraint_r1cs();
        r1cs.n_outputs = n_publics;
        r1cs.n_vars += n_publics;
        r1cs
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
