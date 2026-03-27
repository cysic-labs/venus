//! Variable storage and lookup for compile-time values.
//!
//! Mirrors the JS `Variables` / `Indexable` classes. Stores typed values
//! (int, fe, string, expr) in flat arrays, supporting multi-dimensional
//! array indexing and scoped push/pop.

use std::collections::HashMap;

use super::expression::Value;
use super::ids::{IdAllocator, IdData};

/// Stores variable values by ID.  Wraps an `IdAllocator` for ID management
/// and holds the actual runtime values in a parallel vector.
#[derive(Debug, Clone)]
pub struct VariableStore {
    pub ids: IdAllocator,
    values: Vec<Option<Value>>,
    /// Stack for push/pop across air scopes.
    stack: Vec<Vec<Option<Value>>>,
}

impl VariableStore {
    pub fn new(type_name: &str) -> Self {
        Self {
            ids: IdAllocator::new(type_name),
            values: Vec::new(),
            stack: Vec::new(),
        }
    }

    pub fn type_name(&self) -> &str {
        &self.ids.type_name
    }

    pub fn len(&self) -> u32 {
        self.ids.len()
    }

    pub fn is_empty(&self) -> bool {
        self.ids.is_empty()
    }

    /// Reserve space for `count` slots, returning the first ID.
    pub fn reserve(
        &mut self,
        count: u32,
        label: Option<&str>,
        array_dims: &[u32],
        data: IdData,
    ) -> u32 {
        let id = self.ids.reserve(count, label, array_dims, data);
        // Extend values to cover newly allocated slots.
        while self.values.len() < (id + count) as usize {
            self.values.push(None);
        }
        id
    }

    /// Set the value at the given ID.
    pub fn set(&mut self, id: u32, value: Value) {
        let idx = id as usize;
        if idx >= self.values.len() {
            self.values.resize(idx + 1, None);
        }
        self.values[idx] = Some(value);
    }

    /// Get the value at the given ID.
    pub fn get(&self, id: u32) -> Option<&Value> {
        self.values.get(id as usize).and_then(|v| v.as_ref())
    }

    /// Get a mutable reference to the value at the given ID.
    pub fn get_mut(&mut self, id: u32) -> Option<&mut Value> {
        self.values
            .get_mut(id as usize)
            .and_then(|v| v.as_mut())
    }

    /// Clear all values and IDs (used when switching air contexts).
    pub fn clear(&mut self) {
        self.ids.clear();
        self.values.clear();
    }

    /// Save state for nested air scope.
    pub fn push(&mut self) {
        self.ids.push();
        self.stack.push(std::mem::take(&mut self.values));
    }

    /// Restore state from nested air scope.
    pub fn pop(&mut self) {
        self.ids.pop();
        if let Some(vals) = self.stack.pop() {
            self.values = vals;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_reserve_and_set_get() {
        let mut store = VariableStore::new("int");
        let id = store.reserve(1, Some("x"), &[], IdData::default());
        assert_eq!(id, 0);
        assert!(store.get(0).is_none());
        store.set(0, Value::Int(42));
        assert_eq!(store.get(0), Some(&Value::Int(42)));
    }

    #[test]
    fn test_push_pop() {
        let mut store = VariableStore::new("int");
        store.reserve(1, Some("a"), &[], IdData::default());
        store.set(0, Value::Int(10));
        store.push();
        assert!(store.get(0).is_none()); // pushed away
        store.reserve(1, Some("b"), &[], IdData::default());
        store.set(0, Value::Int(20));
        assert_eq!(store.get(0), Some(&Value::Int(20)));
        store.pop();
        assert_eq!(store.get(0), Some(&Value::Int(10)));
    }
}
