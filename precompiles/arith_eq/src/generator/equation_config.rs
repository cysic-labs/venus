use crate::arith_eq_constants::{ARITH_EQ_CHUNKS, ARITH_EQ_CHUNK_BITS, ARITH_EQ_ROWS_BY_OP};

#[derive(Clone, Debug)]
pub struct EquationConfig {
    pub chunks: usize,
    pub chunk_bits: usize,
    pub terms_by_clock: usize,
    pub comment_col: usize,
    /// Clocks of an operation cycle. The PIL chunk equations of an operation must fit in
    /// `clocks * terms_by_clock` terms, otherwise they would spill into the next cycle.
    pub clocks: usize,
    /// Emit the chunk terms beyond the cycle as `<name>_zero_chunks`, to be constrained to zero
    /// directly (without carry) instead of failing the generation.
    pub force_extra_clocks_zero: bool,
}

impl Default for EquationConfig {
    fn default() -> Self {
        Self {
            chunks: ARITH_EQ_CHUNKS,
            chunk_bits: ARITH_EQ_CHUNK_BITS,
            terms_by_clock: 2,
            comment_col: 30,
            clocks: ARITH_EQ_ROWS_BY_OP,
            force_extra_clocks_zero: false,
        }
    }
}
