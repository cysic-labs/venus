//! Poseidon2 round constraints of the recursive AIRs: the sponge and compression gates and the
//! full and partial rounds they are made of, with the expression caches that share their terms.

use super::*;

struct PoseidonFullRoundCache {
    t0: Vec<Option<Expr>>,
    t1: Vec<Option<Expr>>,
    t2: Vec<Option<Expr>>,
    t3: Vec<Option<Expr>>,
    mat: Vec<Option<Expr>>,
    stored: Vec<Option<Expr>>,
}

impl PoseidonFullRoundCache {
    fn new() -> Self {
        Self {
            t0: vec![None; 4],
            t1: vec![None; 4],
            t2: vec![None; 4],
            t3: vec![None; 4],
            mat: vec![None; 16],
            stored: vec![None; 4],
        }
    }
}

#[derive(Clone)]
enum PoseidonPartialNode {
    Direct(Expr),
    Intermediate(usize),
    Sum(usize),
    First(usize),
    Limb { round: usize, idx: usize },
}

struct PoseidonPartialRoundGraph<I> {
    nodes: Vec<PoseidonPartialNode>,
    values: Vec<Option<Expr>>,
    states: Vec<[usize; 16]>,
    sums: Vec<usize>,
    intermediates: Vec<usize>,
    intermediate: I,
}

impl<I> PoseidonPartialRoundGraph<I> {
    fn new(input: &[Expr], intermediate: I) -> Self {
        let mut graph = Self {
            nodes: Vec::new(),
            values: Vec::new(),
            states: Vec::with_capacity(23),
            sums: Vec::with_capacity(22),
            intermediates: Vec::with_capacity(22),
            intermediate,
        };

        let initial_state =
            std::array::from_fn(|idx| graph.push(PoseidonPartialNode::Direct(input[idx].clone())));
        graph.states.push(initial_state);

        for round in 0..22 {
            let intermediate = graph.push(PoseidonPartialNode::Intermediate(round));
            graph.intermediates.push(intermediate);
            let sum = graph.push(PoseidonPartialNode::Sum(round));
            graph.sums.push(sum);
            let next_state = std::array::from_fn(|idx| {
                if idx == 0 {
                    graph.push(PoseidonPartialNode::First(round))
                } else {
                    graph.push(PoseidonPartialNode::Limb { round, idx })
                }
            });
            graph.states.push(next_state);
        }

        graph
    }

    fn push(&mut self, node: PoseidonPartialNode) -> usize {
        let idx = self.nodes.len();
        self.nodes.push(node);
        self.values.push(None);
        idx
    }
}

impl RecursiveExpressionBuilder {
    pub(super) fn add_poseidon_constraints(&mut self) {
        let first_col = match self.kind {
            PlonkLayoutKind::Aggregation => 27,
            PlonkLayoutKind::Compressor => 36,
            PlonkLayoutKind::FinalVadcop => 33,
        };
        let input_order_out = self.array_a(first_col, 0, 16);
        let input_order_in = self.array_a(0, 0, 16);
        self.add_poseidon_input_order(
            &input_order_in,
            self.a(16),
            self.a(17),
            &input_order_out,
            self.fixed_selector(self.fixed.poseidon_sponge),
            self.fixed_selector(self.fixed.poseidon_compression),
        );

        match self.kind {
            PlonkLayoutKind::Compressor => self.add_poseidon_compressor_rounds(first_col),
            PlonkLayoutKind::Aggregation | PlonkLayoutKind::FinalVadcop => {
                self.add_poseidon_aggregation_rounds(first_col)
            }
        }
    }

    fn add_poseidon_aggregation_rounds(&mut self, first_col: u32) {
        let input_p = self.array_a(first_col, 0, 16);
        let output_p = self.array_a(first_col, 1, 16);
        let mut st0 = self.array_a(first_col + 16, 0, 16);
        st0.extend(self.array_a(18, -2, 6));

        let output_f = self.array_a(first_col + 16, 0, 16);
        let mut constants_f_values = vec![None; 16];
        let mut input_f_cache = vec![None; 16];
        self.add_poseidon_full_round_with(
            |builder, idx| {
                builder.poseidon_aggregation_pow7(
                    first_col,
                    idx,
                    false,
                    &mut constants_f_values,
                    &mut input_f_cache,
                )
            },
            |_, idx| output_f[idx].clone(),
            |builder| builder.poseidon_aggregation_full_selector(),
        );
        let mut constants_f2_values = vec![None; 16];
        let mut input_f2_cache = vec![None; 16];
        self.add_poseidon_full_round_with(
            |builder, idx| {
                builder.poseidon_aggregation_pow7(
                    first_col,
                    idx,
                    true,
                    &mut constants_f2_values,
                    &mut input_f2_cache,
                )
            },
            |builder, idx| builder.poseidon_output_f2(first_col, idx),
            |builder| builder.poseidon_aggregation_full_selector(),
        );
        let mut tail_cache = vec![None; 6];
        let partial_selector = self.fixed_selector(self.fixed.poseidon_partial_round);
        self.add_poseidon_partial_round_with(
            &input_p,
            &output_p,
            &st0,
            |builder, round| {
                if round < 16 {
                    builder.poseidon_aggregation_pow7(
                        first_col,
                        round,
                        true,
                        &mut constants_f2_values,
                        &mut input_f2_cache,
                    )
                } else {
                    builder.poseidon_tail_pow7(round - 16, -2, &mut tail_cache)
                }
            },
            partial_selector,
        );
    }

    fn add_poseidon_compressor_rounds(&mut self, first_col: u32) {
        let input_p = self.array_a(first_col, -1, 16);
        let output_p = self.array_a(first_col, 1, 16);
        let mut st0 = self.array_a(first_col, 0, 16);
        st0.extend(self.array_a(18, -5, 6));

        let mut constants_values = vec![None; 16];
        let mut input_f_cache = vec![None; 16];
        self.add_poseidon_full_round_with(
            |builder, idx| {
                builder.poseidon_compressor_pow7(
                    first_col,
                    idx,
                    &mut constants_values,
                    &mut input_f_cache,
                )
            },
            |builder, idx| builder.poseidon_output_f2(first_col, idx),
            |builder| builder.poseidon_compressor_full_selector(),
        );
        let mut tail_cache = vec![None; 6];
        let partial_selector = self.fixed_selector(self.fixed.poseidon_partial_round);
        self.add_poseidon_partial_round_with(
            &input_p,
            &output_p,
            &st0,
            |builder, round| {
                if round < 16 {
                    builder.poseidon_compressor_pow7(
                        first_col,
                        round,
                        &mut constants_values,
                        &mut input_f_cache,
                    )
                } else {
                    builder.poseidon_tail_pow7(round - 16, -5, &mut tail_cache)
                }
            },
            partial_selector,
        );
    }

    fn add_poseidon_input_order(
        &mut self,
        input: &[Expr],
        bit0: Expr,
        bit1: Expr,
        output: &[Expr],
        sponge: Expr,
        compression: Expr,
    ) {
        self.add_bool_constraint(compression.clone(), bit0.clone());
        self.add_bool_constraint(compression.clone(), bit1.clone());

        let mut mask00 = None;
        let mut mask10 = None;
        let mut mask01 = None;
        let mut mask11 = None;

        self.add_poseidon_full_round_with(
            |builder, idx| {
                builder.poseidon_ordered_input(
                    idx,
                    input,
                    &bit0,
                    &bit1,
                    &mut mask00,
                    &mut mask10,
                    &mut mask01,
                    &mut mask11,
                    &sponge,
                    &compression,
                )
            },
            |_, idx| output[idx].clone(),
            |builder| builder.add(sponge.clone(), compression.clone()),
        );
    }

    fn add_poseidon_full_round(&mut self, input: &[Expr], output: &[Expr], selector: Expr) {
        self.add_poseidon_full_round_with(
            |_, idx| input[idx].clone(),
            |_, idx| output[idx].clone(),
            |_| selector.clone(),
        );
    }

    fn add_poseidon_full_round_with<F, O, S>(
        &mut self,
        mut input: F,
        mut output: O,
        mut selector: S,
    ) where
        F: FnMut(&mut Self, usize) -> Expr,
        O: FnMut(&mut Self, usize) -> Expr,
        S: FnMut(&mut Self) -> Expr,
    {
        let mut cache = PoseidonFullRoundCache::new();

        for idx in 0..16 {
            let selector = selector(self);
            let output = output(self, idx);
            let mat = self.poseidon_full_mat(idx, &mut input, &mut cache);
            let stored = self.poseidon_full_stored(idx % 4, &mut input, &mut cache);
            let rhs = self.add(mat, stored);
            let diff = self.sub(output, rhs);
            let constraint = self.mul(selector, diff);
            self.assert_zero(constraint);
        }
    }

    fn poseidon_aggregation_full_selector(&mut self) -> Expr {
        self.sum(vec![
            self.fixed_selector(self.fixed.poseidon_sponge),
            self.fixed_selector(self.fixed.poseidon_compression),
            self.fixed_selector_offset(self.fixed.poseidon_partial_round, 1),
            self.fixed_selector_offset(self.fixed.poseidon_final, 1),
            self.fixed_selector(self.fixed.poseidon_final),
        ])
    }

    fn poseidon_compressor_full_selector(&mut self) -> Expr {
        self.sum(vec![
            self.fixed_selector(self.fixed.poseidon_sponge),
            self.fixed_selector(self.fixed.poseidon_compression),
            self.fixed_selector_offset(self.fixed.poseidon_sponge, -1),
            self.fixed_selector_offset(self.fixed.poseidon_compression, -1),
            self.fixed_selector_offset(self.fixed.poseidon_sponge, -2),
            self.fixed_selector_offset(self.fixed.poseidon_compression, -2),
            self.fixed_selector_offset(self.fixed.poseidon_partial_round, 2),
            self.fixed_selector_offset(self.fixed.poseidon_partial_round, -1),
            self.fixed_selector_offset(self.fixed.poseidon_final, 2),
            self.fixed_selector_offset(self.fixed.poseidon_final, 1),
            self.fixed_selector(self.fixed.poseidon_final),
        ])
    }

    fn poseidon_full_stored<F>(
        &mut self,
        idx: usize,
        input: &mut F,
        cache: &mut PoseidonFullRoundCache,
    ) -> Expr
    where
        F: FnMut(&mut Self, usize) -> Expr,
    {
        if let Some(value) = &cache.stored[idx] {
            return value.clone();
        }
        let mut acc = self.poseidon_full_mat(idx, input, cache);
        for group in 1..4 {
            let value = self.poseidon_full_mat(group * 4 + idx, input, cache);
            acc = self.add(acc, value);
        }
        cache.stored[idx] = Some(acc.clone());
        acc
    }

    fn poseidon_full_mat<F>(
        &mut self,
        idx: usize,
        input: &mut F,
        cache: &mut PoseidonFullRoundCache,
    ) -> Expr
    where
        F: FnMut(&mut Self, usize) -> Expr,
    {
        if let Some(value) = &cache.mat[idx] {
            return value.clone();
        }
        let group = idx / 4;
        let value = match idx % 4 {
            0 => {
                let t3 = self.poseidon_full_t3(group, input, cache);
                let mat1 = self.poseidon_full_mat(group * 4 + 1, input, cache);
                self.add(t3, mat1)
            }
            1 => {
                let t0 = self.poseidon_full_t0(group, input, cache);
                let four_t0 = self.mul(self.number(4), t0);
                let t2 = self.poseidon_full_t2(group, input, cache);
                self.add(four_t0, t2)
            }
            2 => {
                let t2 = self.poseidon_full_t2(group, input, cache);
                let mat3 = self.poseidon_full_mat(group * 4 + 3, input, cache);
                self.add(t2, mat3)
            }
            3 => {
                let t1 = self.poseidon_full_t1(group, input, cache);
                let four_t1 = self.mul(self.number(4), t1);
                let t3 = self.poseidon_full_t3(group, input, cache);
                self.add(four_t1, t3)
            }
            _ => unreachable!(),
        };
        cache.mat[idx] = Some(value.clone());
        value
    }

    fn poseidon_full_t0<F>(
        &mut self,
        group: usize,
        input: &mut F,
        cache: &mut PoseidonFullRoundCache,
    ) -> Expr
    where
        F: FnMut(&mut Self, usize) -> Expr,
    {
        if let Some(value) = &cache.t0[group] {
            return value.clone();
        }
        let base = group * 4;
        let input0 = input(self, base);
        let input1 = input(self, base + 1);
        let value = self.add(input0, input1);
        cache.t0[group] = Some(value.clone());
        value
    }

    fn poseidon_full_t1<F>(
        &mut self,
        group: usize,
        input: &mut F,
        cache: &mut PoseidonFullRoundCache,
    ) -> Expr
    where
        F: FnMut(&mut Self, usize) -> Expr,
    {
        if let Some(value) = &cache.t1[group] {
            return value.clone();
        }
        let base = group * 4;
        let input2 = input(self, base + 2);
        let input3 = input(self, base + 3);
        let value = self.add(input2, input3);
        cache.t1[group] = Some(value.clone());
        value
    }

    fn poseidon_full_t2<F>(
        &mut self,
        group: usize,
        input: &mut F,
        cache: &mut PoseidonFullRoundCache,
    ) -> Expr
    where
        F: FnMut(&mut Self, usize) -> Expr,
    {
        if let Some(value) = &cache.t2[group] {
            return value.clone();
        }
        let base = group * 4;
        let input1 = input(self, base + 1);
        let twice_1 = self.mul(self.number(2), input1);
        let t1 = self.poseidon_full_t1(group, input, cache);
        let value = self.add(twice_1, t1);
        cache.t2[group] = Some(value.clone());
        value
    }

    fn poseidon_full_t3<F>(
        &mut self,
        group: usize,
        input: &mut F,
        cache: &mut PoseidonFullRoundCache,
    ) -> Expr
    where
        F: FnMut(&mut Self, usize) -> Expr,
    {
        if let Some(value) = &cache.t3[group] {
            return value.clone();
        }
        let base = group * 4;
        let input3 = input(self, base + 3);
        let twice_3 = self.mul(self.number(2), input3);
        let t0 = self.poseidon_full_t0(group, input, cache);
        let value = self.add(twice_3, t0);
        cache.t3[group] = Some(value.clone());
        value
    }

    #[allow(clippy::too_many_arguments)]
    fn poseidon_ordered_input(
        &mut self,
        idx: usize,
        input: &[Expr],
        bit0: &Expr,
        bit1: &Expr,
        mask00: &mut Option<Expr>,
        mask10: &mut Option<Expr>,
        mask01: &mut Option<Expr>,
        mask11: &mut Option<Expr>,
        sponge: &Expr,
        compression: &Expr,
    ) -> Expr {
        let mask00 = self.poseidon_mask00(bit0, bit1, mask00);
        let compressed = if idx < 4 {
            let term0 = self.mul(mask00, input[idx].clone());
            let mask10 = self.poseidon_mask10(bit0, bit1, mask10);
            let mask01 = self.poseidon_mask01(bit0, bit1, mask01);
            let partial = self.add(mask10, mask01);
            let mask11 = self.poseidon_mask11(bit0, bit1, mask11);
            let non_zero = self.add(partial, mask11);
            let term1 = self.mul(non_zero, input[idx + 4].clone());
            self.add(term0, term1)
        } else if idx < 8 {
            let term0 = self.mul(mask00, input[idx].clone());
            let mask10 = self.poseidon_mask10(bit0, bit1, mask10);
            let term1 = self.mul(mask10, input[idx - 4].clone());
            let partial = self.add(term0, term1);
            let mask01 = self.poseidon_mask01(bit0, bit1, mask01);
            let mask11 = self.poseidon_mask11(bit0, bit1, mask11);
            let upper = self.add(mask01, mask11);
            let term2 = self.mul(upper, input[idx + 4].clone());
            self.add(partial, term2)
        } else if idx < 12 {
            let mask10 = self.poseidon_mask10(bit0, bit1, mask10);
            let same = self.add(mask00, mask10);
            let mask01 = self.poseidon_mask01(bit0, bit1, mask01);
            let mask11 = self.poseidon_mask11(bit0, bit1, mask11);
            let term0 = self.mul(same, input[idx].clone());
            let term1 = self.mul(mask01, input[idx - 8].clone());
            let partial = self.add(term0, term1);
            let term2 = self.mul(mask11, input[idx + 4].clone());
            self.add(partial, term2)
        } else {
            let mask10 = self.poseidon_mask10(bit0, bit1, mask10);
            let same = self.add(mask00, mask10);
            let mask01 = self.poseidon_mask01(bit0, bit1, mask01);
            let same = self.add(same, mask01);
            let mask11 = self.poseidon_mask11(bit0, bit1, mask11);
            let term0 = self.mul(same, input[idx].clone());
            let term1 = self.mul(mask11, input[idx - 12].clone());
            self.add(term0, term1)
        };
        let compressed_value = self.mul(compression.clone(), compressed);
        let sponge_value = self.mul(sponge.clone(), input[idx].clone());
        self.add(compressed_value, sponge_value)
    }

    fn poseidon_mask00(&mut self, bit0: &Expr, bit1: &Expr, cache: &mut Option<Expr>) -> Expr {
        if let Some(mask) = cache {
            return mask.clone();
        }
        let not_b0 = self.sub(self.one(), bit0.clone());
        let not_b1 = self.sub(self.one(), bit1.clone());
        let mask = self.mul(not_b0, not_b1);
        *cache = Some(mask.clone());
        mask
    }

    fn poseidon_mask10(&mut self, bit0: &Expr, bit1: &Expr, cache: &mut Option<Expr>) -> Expr {
        if let Some(mask) = cache {
            return mask.clone();
        }
        let not_b1 = self.sub(self.one(), bit1.clone());
        let mask = self.mul(bit0.clone(), not_b1);
        *cache = Some(mask.clone());
        mask
    }

    fn poseidon_mask01(&mut self, bit0: &Expr, bit1: &Expr, cache: &mut Option<Expr>) -> Expr {
        if let Some(mask) = cache {
            return mask.clone();
        }
        let not_b0 = self.sub(self.one(), bit0.clone());
        let mask = self.mul(not_b0, bit1.clone());
        *cache = Some(mask.clone());
        mask
    }

    fn poseidon_mask11(&mut self, bit0: &Expr, bit1: &Expr, cache: &mut Option<Expr>) -> Expr {
        if let Some(mask) = cache {
            return mask.clone();
        }
        let mask = self.mul(bit0.clone(), bit1.clone());
        *cache = Some(mask.clone());
        mask
    }

    fn add_poseidon_partial_round_with<I>(
        &mut self,
        input: &[Expr],
        output: &[Expr],
        st0: &[Expr],
        intermediate: I,
        selector: Expr,
    ) where
        I: FnMut(&mut Self, usize) -> Expr,
    {
        let mut graph = PoseidonPartialRoundGraph::new(input, intermediate);
        for round in 0..22 {
            let state0_id = graph.states[round][0];
            let state0 = self.eval_poseidon_partial_node(&mut graph, state0_id);
            let diff = self.sub(st0[round].clone(), state0);
            let constraint = self.mul(selector.clone(), diff);
            self.assert_zero(constraint);
        }

        for idx in 0..16 {
            let state_id = graph.states[22][idx];
            let state = self.eval_poseidon_partial_node(&mut graph, state_id);
            let diff = self.sub(output[idx].clone(), state);
            let constraint = self.mul(selector.clone(), diff);
            self.assert_zero(constraint);
        }
    }

    fn eval_poseidon_partial_node<I>(
        &mut self,
        graph: &mut PoseidonPartialRoundGraph<I>,
        node_id: usize,
    ) -> Expr
    where
        I: FnMut(&mut Self, usize) -> Expr,
    {
        let cache_value = !matches!(graph.nodes[node_id], PoseidonPartialNode::Intermediate(round) if round >= 16);
        if cache_value {
            if let Some(value) = &graph.values[node_id] {
                return value.clone();
            }
        }

        let node = graph.nodes[node_id].clone();
        let value = match node {
            PoseidonPartialNode::Direct(value) => value,
            PoseidonPartialNode::Intermediate(round) => (graph.intermediate)(self, round),
            PoseidonPartialNode::Sum(round) => {
                let intermediate_id = graph.intermediates[round];
                let mut acc = self.eval_poseidon_partial_node(graph, intermediate_id);
                for idx in 1..16 {
                    let state_id = graph.states[round][idx];
                    let state = self.eval_poseidon_partial_node(graph, state_id);
                    acc = self.add(acc, state);
                }
                acc
            }
            PoseidonPartialNode::First(round) => {
                let intermediate_id = graph.intermediates[round];
                let intermediate = self.eval_poseidon_partial_node(graph, intermediate_id);
                let first_scaled = self.mul(intermediate, self.number(Poseidon16::DIAG[0]));
                let sum_id = graph.sums[round];
                let partial_sum = self.eval_poseidon_partial_node(graph, sum_id);
                self.add(first_scaled, partial_sum)
            }
            PoseidonPartialNode::Limb { round, idx } => {
                let state_id = graph.states[round][idx];
                let state = self.eval_poseidon_partial_node(graph, state_id);
                let scaled = self.mul(state, self.number(Poseidon16::DIAG[idx]));
                let sum_id = graph.sums[round];
                let partial_sum = self.eval_poseidon_partial_node(graph, sum_id);
                self.add(scaled, partial_sum)
            }
        };

        if cache_value {
            graph.values[node_id] = Some(value.clone());
        }
        value
    }

    fn poseidon_tail_pow7(
        &mut self,
        tail_idx: usize,
        offset: i32,
        tail_cache: &mut [Option<Expr>],
    ) -> Expr {
        self.pow7_cached_top(&mut tail_cache[tail_idx], |builder| {
            let value = builder.a_offset(18 + tail_idx as u32, offset);
            let constant = builder.number(Poseidon16::RC[80 + tail_idx]);
            builder.add(value, constant)
        })
    }

    fn poseidon_aggregation_constant(&mut self, idx: usize, second_half: bool) -> Expr {
        let base = if second_half { 16 } else { 0 };
        let sponge_or_compression = self.add(
            self.fixed_selector(self.fixed.poseidon_sponge),
            self.fixed_selector(self.fixed.poseidon_compression),
        );
        let mut acc = self.mul(sponge_or_compression, self.number(Poseidon16::RC[idx + base]));
        let term = self.mul(
            self.fixed_selector_offset(self.fixed.poseidon_partial_round, 1),
            self.number(Poseidon16::RC[idx + if second_half { 48 } else { 32 }]),
        );
        acc = self.add(acc, term);
        let term = self.mul(
            self.fixed_selector_offset(self.fixed.poseidon_final, 1),
            self.number(Poseidon16::RC[idx + if second_half { 102 } else { 86 }]),
        );
        acc = self.add(acc, term);
        let term = self.mul(
            self.fixed_selector(self.fixed.poseidon_final),
            self.number(Poseidon16::RC[idx + if second_half { 134 } else { 118 }]),
        );
        acc = self.add(acc, term);
        if second_half {
            let term = self.mul(
                self.fixed_selector(self.fixed.poseidon_partial_round),
                self.number(Poseidon16::RC[idx + 64]),
            );
            acc = self.add(acc, term);
        }
        acc
    }

    fn poseidon_aggregation_constant_cached(
        &mut self,
        idx: usize,
        second_half: bool,
        cache: &mut [Option<Expr>],
    ) -> Expr {
        if let Some(value) = &cache[idx] {
            return value.clone();
        }
        let value = self.poseidon_aggregation_constant(idx, second_half);
        cache[idx] = Some(value.clone());
        value
    }

    fn poseidon_aggregation_pow7(
        &mut self,
        first_col: u32,
        idx: usize,
        second_half: bool,
        constants_cache: &mut [Option<Expr>],
        input6_cache: &mut [Option<Expr>],
    ) -> Expr {
        let col = first_col + idx as u32 + if second_half { 16 } else { 0 };
        self.pow7_cached_top(&mut input6_cache[idx], |builder| {
            let value = builder.a(col);
            let constant =
                builder.poseidon_aggregation_constant_cached(idx, second_half, constants_cache);
            builder.add(value, constant)
        })
    }

    fn poseidon_compressor_constant(&mut self, idx: usize) -> Expr {
        let r0 = self.add(
            self.fixed_selector(self.fixed.poseidon_sponge),
            self.fixed_selector(self.fixed.poseidon_compression),
        );
        let mut acc = self.mul(r0, self.number(Poseidon16::RC[idx]));

        let r1 = self.add(
            self.fixed_selector_offset(self.fixed.poseidon_sponge, -1),
            self.fixed_selector_offset(self.fixed.poseidon_compression, -1),
        );
        let term = self.mul(r1, self.number(Poseidon16::RC[idx + 16]));
        acc = self.add(acc, term);

        let r2 = self.add(
            self.fixed_selector_offset(self.fixed.poseidon_sponge, -2),
            self.fixed_selector_offset(self.fixed.poseidon_compression, -2),
        );
        let term = self.mul(r2, self.number(Poseidon16::RC[idx + 32]));
        acc = self.add(acc, term);

        let term = self.mul(
            self.fixed_selector_offset(self.fixed.poseidon_partial_round, 2),
            self.number(Poseidon16::RC[idx + 48]),
        );
        acc = self.add(acc, term);
        let term = self.mul(
            self.fixed_selector(self.fixed.poseidon_partial_round),
            self.number(Poseidon16::RC[idx + 64]),
        );
        acc = self.add(acc, term);
        let term = self.mul(
            self.fixed_selector_offset(self.fixed.poseidon_partial_round, -1),
            self.number(Poseidon16::RC[idx + 86]),
        );
        acc = self.add(acc, term);
        let term = self.mul(
            self.fixed_selector_offset(self.fixed.poseidon_final, 2),
            self.number(Poseidon16::RC[idx + 102]),
        );
        acc = self.add(acc, term);
        let term = self.mul(
            self.fixed_selector_offset(self.fixed.poseidon_final, 1),
            self.number(Poseidon16::RC[idx + 118]),
        );
        acc = self.add(acc, term);
        let term = self.mul(
            self.fixed_selector(self.fixed.poseidon_final),
            self.number(Poseidon16::RC[idx + 134]),
        );
        self.add(acc, term)
    }

    fn poseidon_compressor_constant_cached(
        &mut self,
        idx: usize,
        cache: &mut [Option<Expr>],
    ) -> Expr {
        if let Some(value) = &cache[idx] {
            return value.clone();
        }
        let value = self.poseidon_compressor_constant(idx);
        cache[idx] = Some(value.clone());
        value
    }

    fn poseidon_compressor_pow7(
        &mut self,
        first_col: u32,
        idx: usize,
        constants_cache: &mut [Option<Expr>],
        input6_cache: &mut [Option<Expr>],
    ) -> Expr {
        let col = first_col + idx as u32;
        self.pow7_cached_top(&mut input6_cache[idx], |builder| {
            let value = builder.a(col);
            let constant = builder.poseidon_compressor_constant_cached(idx, constants_cache);
            builder.add(value, constant)
        })
    }

    fn poseidon_output_f2(&mut self, first_col: u32, idx: usize) -> Expr {
        let idx = idx as u32;
        let final_selector = self.fixed_selector(self.fixed.poseidon_final);
        let final_out = self.mul(final_selector, self.a(idx));
        let non_final_selector =
            self.sub(self.one(), self.fixed_selector(self.fixed.poseidon_final));
        let non_final = self.mul(non_final_selector, self.a_offset(first_col + idx, 1));
        self.add(final_out, non_final)
    }
}
