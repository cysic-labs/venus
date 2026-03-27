//! Fixed column computation: sequence evaluation for patterns like
//! `[0]*`, `[1,0]*`, `[1,0...]*`, etc.
//!
//! Mirrors the JS `FixedCols` and `Sequence` classes.

use crate::parser::ast::{SequenceDef, SequenceElement};
use super::expression::{Value, parse_numeric_literal};
use super::ids::{IdAllocator, IdData};

/// Extended fixed column storage: wraps an `IdAllocator` and stores per-column
/// row data (the evaluated sequence values).
#[derive(Debug, Clone)]
pub struct FixedCols {
    pub ids: IdAllocator,
    /// Per-column row data. Indexed by column ID.
    row_data: Vec<Option<Vec<i128>>>,
    /// Stack for push/pop across nested air scopes.
    stack: Vec<Vec<Option<Vec<i128>>>>,
}

impl FixedCols {
    pub fn new() -> Self {
        Self {
            ids: IdAllocator::new("fixed"),
            row_data: Vec::new(),
            stack: Vec::new(),
        }
    }

    pub fn len(&self) -> u32 {
        self.ids.len()
    }

    pub fn is_empty(&self) -> bool {
        self.ids.is_empty()
    }

    /// Reserve a new fixed column, returning its ID.
    pub fn reserve(
        &mut self,
        count: u32,
        label: Option<&str>,
        array_dims: &[u32],
        data: IdData,
    ) -> u32 {
        let id = self.ids.reserve(count, label, array_dims, data);
        while self.row_data.len() < (id + count) as usize {
            self.row_data.push(None);
        }
        id
    }

    /// Set the row data for a fixed column (the fully expanded sequence).
    pub fn set_row_data(&mut self, id: u32, data: Vec<i128>) {
        let idx = id as usize;
        if idx >= self.row_data.len() {
            self.row_data.resize(idx + 1, None);
        }
        self.row_data[idx] = Some(data);
    }

    /// Get the row data for a fixed column.
    pub fn get_row_data(&self, id: u32) -> Option<&[i128]> {
        self.row_data
            .get(id as usize)
            .and_then(|d| d.as_deref())
    }

    /// Set a single row value.
    pub fn set_row_value(&mut self, id: u32, row: usize, value: i128) {
        let idx = id as usize;
        if idx >= self.row_data.len() {
            self.row_data.resize(idx + 1, None);
        }
        if self.row_data[idx].is_none() {
            self.row_data[idx] = Some(Vec::new());
        }
        if let Some(data) = &mut self.row_data[idx] {
            if row >= data.len() {
                data.resize(row + 1, 0);
            }
            data[row] = value;
        }
    }

    /// Get a single row value.
    pub fn get_row_value(&self, id: u32, row: usize) -> Option<i128> {
        self.row_data
            .get(id as usize)
            .and_then(|d| d.as_ref())
            .and_then(|v| v.get(row).copied())
    }

    /// Clear all columns (between air instances).
    pub fn clear(&mut self) {
        self.ids.clear();
        self.row_data.clear();
    }

    /// Push state for nested air scope.
    pub fn push(&mut self) {
        self.ids.push();
        self.stack.push(std::mem::take(&mut self.row_data));
    }

    /// Pop state from nested air scope.
    pub fn pop(&mut self) {
        self.ids.pop();
        if let Some(data) = self.stack.pop() {
            self.row_data = data;
        }
    }

    /// Get non-temporal label ranges (for protobuf output).
    pub fn get_non_temporal_labels(&self) -> Vec<&super::ids::LabelRange> {
        self.ids
            .label_ranges
            .to_vec()
            .iter()
            .filter(|lr| {
                // Check if the data for this range is not marked as temporal.
                if let Some(data) = self.ids.get_data(lr.from) {
                    !data.temporal
                } else {
                    true
                }
            })
            .collect()
    }
}

/// Evaluate a fixed-column sequence definition into a vector of values.
///
/// Given a sequence like `[1, 0]*` and a target size `num_rows`, this
/// expands the pattern to fill exactly `num_rows` entries.
pub fn evaluate_sequence(seq: &SequenceDef, num_rows: u64) -> Vec<i128> {
    let mut base_pattern = Vec::new();
    let mut padding_value: Option<i128> = None;

    for element in &seq.elements {
        match element {
            SequenceElement::Value(expr) => {
                if let Some(v) = try_const_eval_expr(expr) {
                    base_pattern.push(v);
                }
            }
            SequenceElement::Repeat { value, times } => {
                if let (Some(v), Some(t)) = (try_const_eval_expr(value), try_const_eval_expr(times))
                {
                    for _ in 0..t {
                        base_pattern.push(v);
                    }
                }
            }
            SequenceElement::Range { from, to } => {
                if let (Some(f), Some(t)) = (try_const_eval_expr(from), try_const_eval_expr(to)) {
                    if f <= t {
                        for v in f..=t {
                            base_pattern.push(v);
                        }
                    } else {
                        for v in (t..=f).rev() {
                            base_pattern.push(v);
                        }
                    }
                }
            }
            SequenceElement::Padding(inner) => {
                if let SequenceElement::Value(expr) = inner.as_ref() {
                    padding_value = try_const_eval_expr(expr);
                }
            }
            SequenceElement::SubSeq(elements) => {
                // Flatten subsequences.
                let sub = SequenceDef {
                    elements: elements.clone(),
                    is_padded: false,
                };
                let sub_vals = evaluate_sequence(&sub, num_rows);
                base_pattern.extend(sub_vals);
            }
            _ => {
                // ArithSeq, GeomSeq handled as identity for now.
            }
        }
    }

    if base_pattern.is_empty() {
        if let Some(pad) = padding_value {
            return vec![pad; num_rows as usize];
        }
        return vec![0; num_rows as usize];
    }

    let mut result = Vec::with_capacity(num_rows as usize);

    if seq.is_padded || padding_value.is_some() {
        // Repeat the base pattern to fill num_rows.
        let pattern_len = base_pattern.len();
        for i in 0..num_rows as usize {
            result.push(base_pattern[i % pattern_len]);
        }
    } else {
        // Non-padded: just use the base pattern as-is, zero-extending.
        result.extend_from_slice(&base_pattern);
        while result.len() < num_rows as usize {
            result.push(padding_value.unwrap_or(0));
        }
    }

    result.truncate(num_rows as usize);
    result
}

/// Try to evaluate an expression to a constant integer at compile time.
/// Returns None if the expression is not a simple constant.
fn try_const_eval_expr(expr: &crate::parser::ast::Expr) -> Option<i128> {
    use crate::parser::ast::Expr;
    match expr {
        Expr::Number(lit) => Some(parse_numeric_literal(lit)),
        Expr::UnaryOp {
            op: crate::parser::ast::UnaryOp::Neg,
            operand,
        } => try_const_eval_expr(operand).map(|v| -v),
        Expr::BinaryOp { op, left, right } => {
            let l = try_const_eval_expr(left)?;
            let r = try_const_eval_expr(right)?;
            match super::expression::eval_binop_int(op, l, r) {
                Value::Int(v) => Some(v),
                _ => None,
            }
        }
        _ => None,
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::parser::ast::*;

    fn num_expr(v: i128) -> Expr {
        Expr::Number(NumericLiteral {
            value: v.to_string(),
            radix: NumericRadix::Decimal,
        })
    }

    #[test]
    fn test_simple_padded_sequence() {
        // [0]* for 8 rows => [0,0,0,0,0,0,0,0]
        let seq = SequenceDef {
            elements: vec![SequenceElement::Value(num_expr(0))],
            is_padded: true,
        };
        let result = evaluate_sequence(&seq, 8);
        assert_eq!(result, vec![0; 8]);
    }

    #[test]
    fn test_alternating_padded_sequence() {
        // [1,0]* for 8 rows => [1,0,1,0,1,0,1,0]
        let seq = SequenceDef {
            elements: vec![
                SequenceElement::Value(num_expr(1)),
                SequenceElement::Value(num_expr(0)),
            ],
            is_padded: true,
        };
        let result = evaluate_sequence(&seq, 8);
        assert_eq!(result, vec![1, 0, 1, 0, 1, 0, 1, 0]);
    }

    #[test]
    fn test_range_sequence() {
        // [0..3] => [0,1,2,3] extended to 8
        let seq = SequenceDef {
            elements: vec![SequenceElement::Range {
                from: num_expr(0),
                to: num_expr(3),
            }],
            is_padded: false,
        };
        let result = evaluate_sequence(&seq, 8);
        assert_eq!(result, vec![0, 1, 2, 3, 0, 0, 0, 0]);
    }

    #[test]
    fn test_reserve_and_set_row() {
        let mut fc = FixedCols::new();
        let id = fc.reserve(1, Some("ZERO"), &[], IdData::default());
        fc.set_row_data(id, vec![0, 0, 0, 0]);
        assert_eq!(fc.get_row_value(id, 0), Some(0));
        assert_eq!(fc.get_row_value(id, 3), Some(0));
    }

    #[test]
    fn test_push_pop_fixed_cols() {
        let mut fc = FixedCols::new();
        fc.reserve(1, Some("A"), &[], IdData::default());
        fc.set_row_data(0, vec![1, 2, 3]);
        assert_eq!(fc.len(), 1);

        fc.push();
        assert_eq!(fc.len(), 0);
        fc.reserve(1, Some("B"), &[], IdData::default());
        assert_eq!(fc.len(), 1);

        fc.pop();
        assert_eq!(fc.len(), 1);
        assert_eq!(fc.get_row_value(0, 0), Some(1));
    }
}
