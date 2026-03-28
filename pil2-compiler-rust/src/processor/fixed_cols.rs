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
    evaluate_sequence_impl(seq, num_rows, &try_const_eval_expr)
}

/// Shared implementation for sequence evaluation, parameterized over the
/// expression evaluator function.
fn evaluate_sequence_impl<F>(seq: &SequenceDef, num_rows: u64, eval_fn: &F) -> Vec<i128>
where
    F: Fn(&crate::parser::ast::Expr) -> Option<i128>,
{
    let mut base_pattern = Vec::new();
    let mut padding_value: Option<i128> = None;

    for element in &seq.elements {
        match element {
            SequenceElement::Value(expr) => {
                if let Some(v) = eval_fn(expr) {
                    base_pattern.push(v);
                }
            }
            SequenceElement::Repeat { value, times } => {
                if let (Some(v), Some(t)) = (eval_fn(value), eval_fn(times))
                {
                    for _ in 0..t {
                        base_pattern.push(v);
                    }
                }
            }
            SequenceElement::Range { from, to, from_times, to_times } => {
                if let (Some(f), Some(t)) = (eval_fn(from), eval_fn(to)) {
                    let ft = from_times.as_ref().and_then(|e| eval_fn(e)).unwrap_or(1);
                    let tt = to_times.as_ref().and_then(|e| eval_fn(e)).unwrap_or(ft);
                    if f <= t {
                        for v in f..=t {
                            let rep = if v == f { ft } else if v == t { tt } else { ft.min(tt).max(1) };
                            for _ in 0..rep {
                                base_pattern.push(v);
                            }
                        }
                    } else {
                        for v in (t..=f).rev() {
                            let rep = if v == f { ft } else if v == t { tt } else { ft.min(tt).max(1) };
                            for _ in 0..rep {
                                base_pattern.push(v);
                            }
                        }
                    }
                }
            }
            SequenceElement::Padding(inner) => {
                if let SequenceElement::Value(expr) = inner.as_ref() {
                    padding_value = eval_fn(expr);
                }
            }
            SequenceElement::SubSeq(elements) => {
                // Flatten subsequences.
                let sub = SequenceDef {
                    elements: elements.clone(),
                    is_padded: false,
                };
                let sub_vals = evaluate_sequence_impl(&sub, num_rows, eval_fn);
                base_pattern.extend(sub_vals);
            }
            SequenceElement::ArithSeq { t1, t2, tn } => {
                let (v1, times1) = extract_seq_value_and_times(t1, eval_fn);
                let (v2, _times2) = extract_seq_value_and_times(t2, eval_fn);
                if let (Some(t1_val), Some(t2_val)) = (v1, v2) {
                    let delta = t2_val - t1_val;
                    let times = times1.unwrap_or(1) as usize;
                    let tn_val = tn.as_ref().and_then(|e| {
                        let (v, _) = extract_seq_value_and_times(e, eval_fn);
                        v
                    });
                    // Determine how many distinct values to produce.
                    let count = if let Some(tn_v) = tn_val {
                        // Bounded: from t1 to tn (inclusive) stepping by delta.
                        if delta != 0 {
                            (((tn_v - t1_val) / delta) + 1) as usize * times
                        } else {
                            1
                        }
                    } else {
                        // Open-ended: fill remaining rows (padding_size).
                        let remaining = num_rows as usize - base_pattern.len();
                        remaining
                    };
                    let mut value = t1_val;
                    let mut produced = 0usize;
                    while produced < count {
                        for _ in 0..times {
                            if produced >= count { break; }
                            base_pattern.push(value);
                            produced += 1;
                        }
                        value += delta;
                    }
                }
            }
            SequenceElement::GeomSeq { t1, t2, tn } => {
                let (v1, times1) = extract_seq_value_and_times(t1, eval_fn);
                let (v2, _times2) = extract_seq_value_and_times(t2, eval_fn);
                if let (Some(t1_val), Some(t2_val)) = (v1, v2) {
                    let times = times1.unwrap_or(1) as usize;
                    if t1_val == 0 || t2_val == 0 {
                        // Degenerate: just push zeros.
                        let remaining = num_rows as usize - base_pattern.len();
                        for _ in 0..remaining {
                            base_pattern.push(0);
                        }
                    } else {
                        let reverse = t1_val > t2_val;
                        let ratio = if reverse { t1_val / t2_val } else { t2_val / t1_val };
                        let tn_val = tn.as_ref().and_then(|e| {
                            let (v, _) = extract_seq_value_and_times(e, eval_fn);
                            v
                        });
                        // Determine count.
                        let count = if let Some(tn_v) = tn_val {
                            // Bounded geometric: count values from t1 to tn.
                            let ti = if reverse { tn_v } else { t1_val };
                            let tf = if reverse { t1_val } else { tn_v };
                            let mut n = 0usize;
                            let mut v = ti;
                            while v <= tf {
                                n += 1;
                                v *= ratio;
                            }
                            n * times
                        } else {
                            // Open-ended: fill remaining rows.
                            let remaining = num_rows as usize - base_pattern.len();
                            remaining
                        };
                        // Determine start and end values.
                        let ti = if reverse {
                            // For reverse, calculate the smallest value.
                            let n = if count > 0 { (count / times).saturating_sub(1) } else { 0 };
                            let mut v = t1_val;
                            for _ in 0..n {
                                v /= ratio;
                            }
                            v
                        } else {
                            t1_val
                        };
                        // Build the sequence values.
                        let mut values_forward = Vec::new();
                        let mut v = ti;
                        let target_distinct = if count > 0 { (count + times - 1) / times } else { 0 };
                        for _ in 0..target_distinct {
                            for _ in 0..times {
                                values_forward.push(v);
                            }
                            v *= ratio;
                        }
                        if reverse {
                            values_forward.reverse();
                        }
                        // Truncate to exact count.
                        values_forward.truncate(count);
                        base_pattern.extend(values_forward);
                    }
                }
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

/// Extract the constant value and optional repeat times from a SequenceElement
/// inside an ArithSeq/GeomSeq (which wraps either Value(expr) or Repeat{value, times}).
fn extract_seq_value_and_times<F>(
    elem: &SequenceElement,
    eval_fn: &F,
) -> (Option<i128>, Option<i128>)
where
    F: Fn(&crate::parser::ast::Expr) -> Option<i128>,
{
    match elem {
        SequenceElement::Value(expr) => (eval_fn(expr), None),
        SequenceElement::Repeat { value, times } => {
            (eval_fn(value), eval_fn(times))
        }
        _ => (None, None),
    }
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
                from_times: None,
                to_times: None,
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
