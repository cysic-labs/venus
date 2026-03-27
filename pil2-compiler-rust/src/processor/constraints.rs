//! Constraint collection: polynomial identity, lookup, permutation, connection.
//!
//! Mirrors the JS `Constraints` class. Collects constraint expressions
//! during compilation and stores them for later protobuf serialization.

use super::expression::{RuntimeExpr, Value};

/// A single constraint: an expression that must evaluate to zero.
#[derive(Debug, Clone)]
pub struct ConstraintEntry {
    /// Index into the expression store.
    pub expr_id: u32,
    /// Source reference for error reporting.
    pub source_ref: String,
    /// Optional boundary specifier.
    pub boundary: Option<String>,
}

/// Collection of constraints within a scope (air or proof).
///
/// Mirrors the JS `Constraints` class.
#[derive(Debug, Clone)]
pub struct Constraints {
    entries: Vec<ConstraintEntry>,
    /// Expression store for this constraint set. Each expression is stored
    /// as a `RuntimeExpr` that can later be packed for protobuf output.
    expressions: Vec<RuntimeExpr>,
}

impl Constraints {
    pub fn new() -> Self {
        Self {
            entries: Vec::new(),
            expressions: Vec::new(),
        }
    }

    pub fn len(&self) -> usize {
        self.entries.len()
    }

    pub fn is_empty(&self) -> bool {
        self.entries.is_empty()
    }

    /// Insert an expression and return its ID.
    pub fn insert_expression(&mut self, expr: RuntimeExpr) -> u32 {
        let id = self.expressions.len() as u32;
        self.expressions.push(expr);
        id
    }

    /// Get the expression at the given ID.
    pub fn get_expression(&self, id: u32) -> Option<&RuntimeExpr> {
        self.expressions.get(id as usize)
    }

    /// Define a constraint from a left and right expression.
    /// If right is non-zero, we compute left - right.
    pub fn define(
        &mut self,
        left: RuntimeExpr,
        right: RuntimeExpr,
        boundary: Option<String>,
        source_ref: &str,
    ) -> u32 {
        // If right is zero, the constraint is simply left === 0.
        let combined = if is_zero_expr(&right) {
            left
        } else {
            RuntimeExpr::BinOp {
                op: super::expression::RuntimeOp::Sub,
                left: Box::new(left),
                right: Box::new(right),
            }
        };

        let expr_id = self.insert_expression(combined);
        let id = self.entries.len() as u32;
        self.entries.push(ConstraintEntry {
            expr_id,
            source_ref: source_ref.to_string(),
            boundary,
        });
        id
    }

    /// Define a constraint directly from a single expression (already
    /// representing `expr === 0`).
    pub fn define_expression_as_constraint(
        &mut self,
        expr: RuntimeExpr,
        source_ref: &str,
    ) -> u32 {
        self.define(expr, RuntimeExpr::Value(Value::Int(0)), None, source_ref)
    }

    /// Get the last constraint ID (for logging/display).
    pub fn last_constraint_id(&self) -> Option<u32> {
        if self.entries.is_empty() {
            None
        } else {
            Some(self.entries.len() as u32 - 1)
        }
    }

    /// Iterate over all constraint entries.
    pub fn iter(&self) -> impl Iterator<Item = &ConstraintEntry> {
        self.entries.iter()
    }

    /// Iterate over (index, constraint) pairs.
    pub fn iter_indexed(&self) -> impl Iterator<Item = (usize, &ConstraintEntry)> {
        self.entries.iter().enumerate()
    }

    /// Get a constraint by index.
    pub fn get(&self, index: usize) -> Option<&ConstraintEntry> {
        self.entries.get(index)
    }

    /// Get all expressions (for protobuf packing).
    pub fn all_expressions(&self) -> &[RuntimeExpr] {
        &self.expressions
    }

    /// Clear all constraints and expressions (used between airs).
    pub fn clear(&mut self) {
        self.entries.clear();
        self.expressions.clear();
    }
}

/// Check if a RuntimeExpr represents zero.
fn is_zero_expr(expr: &RuntimeExpr) -> bool {
    matches!(expr, RuntimeExpr::Value(Value::Int(0)))
}

#[cfg(test)]
mod tests {
    use super::*;
    use super::super::expression::RuntimeOp;

    #[test]
    fn test_define_simple_constraint() {
        let mut c = Constraints::new();
        let left = RuntimeExpr::Value(Value::Int(42));
        let right = RuntimeExpr::Value(Value::Int(0));
        let id = c.define(left, right, None, "test:1");
        assert_eq!(id, 0);
        assert_eq!(c.len(), 1);
    }

    #[test]
    fn test_define_subtraction_constraint() {
        let mut c = Constraints::new();
        let left = RuntimeExpr::Value(Value::Int(10));
        let right = RuntimeExpr::Value(Value::Int(5));
        let id = c.define(left, right, None, "test:1");
        assert_eq!(id, 0);
        // The stored expression should be a subtraction.
        match c.get_expression(c.get(0).unwrap().expr_id) {
            Some(RuntimeExpr::BinOp { op: RuntimeOp::Sub, .. }) => {}
            other => panic!("expected Sub, got {:?}", other),
        }
    }

    #[test]
    fn test_clear() {
        let mut c = Constraints::new();
        c.define(
            RuntimeExpr::Value(Value::Int(1)),
            RuntimeExpr::Value(Value::Int(0)),
            None,
            "test:1",
        );
        assert_eq!(c.len(), 1);
        c.clear();
        assert_eq!(c.len(), 0);
    }
}
