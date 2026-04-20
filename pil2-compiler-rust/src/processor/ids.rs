//! ID allocation for columns, expressions, and constraints.
//!
//! Mirrors the JS `Ids` class which maintains a monotonically increasing ID
//! counter, per-ID metadata, and label-range tracking.

use std::collections::HashMap;

/// Maps a label string to the range of IDs it covers.
#[derive(Debug, Clone)]
pub struct LabelRange {
    pub label: String,
    pub from: u32,
    pub count: u32,
    pub array_dims: Vec<u32>,
}

/// Tracks label-to-ID-range associations (mirrors JS `LabelRanges`).
#[derive(Debug, Clone, Default)]
pub struct LabelRanges {
    ranges: Vec<LabelRange>,
}

impl LabelRanges {
    pub fn define(&mut self, label: &str, from: u32, array_dims: &[u32]) {
        let count = if array_dims.is_empty() {
            1
        } else {
            array_dims.iter().copied().product()
        };
        self.ranges.push(LabelRange {
            label: label.to_string(),
            from,
            count,
            array_dims: array_dims.to_vec(),
        });
    }

    pub fn get_label(&self, id: u32) -> Option<&str> {
        for range in &self.ranges {
            if id >= range.from && id < range.from + range.count {
                return Some(&range.label);
            }
        }
        None
    }

    pub fn to_vec(&self) -> &[LabelRange] {
        &self.ranges
    }
}

/// Per-ID metadata stored alongside allocated IDs.
#[derive(Debug, Clone, Default)]
pub struct IdData {
    pub source_ref: String,
    pub stage: Option<u32>,
    pub global: bool,
    pub temporal: bool,
    pub external: bool,
    /// Commit ID for custom columns (assigned by commit declaration order).
    pub commit_id: Option<u32>,
    /// Slot belongs to a container field. Container field values must
    /// persist across the function-exit `trim_values_after` boundary so
    /// that `proof.std.gsum.hint`-style accumulators and proof-scope
    /// arrays carry their stored values to deferred handlers (e.g.
    /// `piop_gsum_issue_global_debug_hints`). Set by
    /// `exec_variable_declaration` when the declaration runs inside a
    /// `container { ... }` body, consulted by
    /// `VariableStore::trim_values_after`.
    pub container_owned: bool,
    /// Slot was reserved for a `const expr X = ...` declaration. JS's
    /// `this.expressions.reserve` packs these unconditionally into the
    /// per-AIR arena regardless of reachability from the current AIR's
    /// constraint/hint roots. Set only by `exec_variable_declaration`
    /// when `vd.is_const && vd.vtype == TypeKind::Expr`; every other
    /// `IdAllocator::reserve` call leaves this at the `Default::default`
    /// value `false`. Consumed by `execute_air_template_call`'s
    /// reachability importer to seed the const-expr in-frame inclusion
    /// set and by its trimmed-slot fallback to preserve the same set.
    pub is_const_expr: bool,
    pub extra: HashMap<String, String>,
}

/// A monotonic ID allocator with metadata and label tracking.
///
/// Corresponds to the JS `Ids` class and is the foundation for
/// `Variables`, `FixedCols`, `WitnessCols`, etc.
#[derive(Debug, Clone)]
pub struct IdAllocator {
    pub type_name: String,
    next_id: u32,
    pub datas: Vec<IdData>,
    pub label_ranges: LabelRanges,
    /// Stack for push/pop (nested air scopes).
    stack: Vec<(u32, Vec<IdData>, LabelRanges, u32)>,
    /// Base ID: datas[0] corresponds to this ID. Used by
    /// `clear_metadata_only` to keep IDs globally unique.
    base_id: u32,
}

impl IdAllocator {
    pub fn new(type_name: &str) -> Self {
        Self {
            type_name: type_name.to_string(),
            next_id: 0,
            datas: Vec::new(),
            label_ranges: LabelRanges::default(),
            stack: Vec::new(),
            base_id: 0,
        }
    }

    /// Returns the total number of IDs allocated across all AIRs.
    pub fn len(&self) -> u32 {
        self.next_id
    }

    /// Returns the number of IDs allocated for the current AIR scope
    /// (i.e. since the last `clear_metadata_only` call).
    pub fn current_len(&self) -> u32 {
        self.next_id - self.base_id
    }

    pub fn is_empty(&self) -> bool {
        self.next_id == 0
    }

    /// Reserve `count` consecutive IDs, optionally associating them with a
    /// label and array dimensions. Returns the first allocated ID.
    pub fn reserve(
        &mut self,
        count: u32,
        label: Option<&str>,
        array_dims: &[u32],
        data: IdData,
    ) -> u32 {
        let id = self.next_id;
        self.next_id += count;
        // Extend datas to cover all newly allocated slots.
        for i in 0..count {
            let d = data.clone();
            if i > 0 {
                // Only the first slot gets the full data; rest are copies.
            }
            self.datas.push(d);
        }
        if let Some(lbl) = label {
            self.label_ranges.define(lbl, id, array_dims);
        }
        id
    }

    pub fn get_data(&self, id: u32) -> Option<&IdData> {
        if id < self.base_id {
            return None;
        }
        self.datas.get((id - self.base_id) as usize)
    }

    pub fn is_defined(&self, id: u32) -> bool {
        id >= self.base_id && id < self.next_id
    }

    /// Clear all allocations (used when switching air contexts).
    pub fn clear(&mut self) {
        self.next_id = 0;
        self.base_id = 0;
        self.datas.clear();
        self.label_ranges = LabelRanges::default();
    }

    /// Return the next ID that would be allocated (but don't allocate it).
    pub fn peek_next_id(&self) -> u32 {
        self.next_id
    }

    /// Bump `next_id` to at least `target` so subsequent reservations
    /// allocate IDs at or above `target`. Used by
    /// `VariableStore::push` to reserve the seeded container-owned
    /// slot range in the new air-scope frame.
    pub fn advance_next_id_to(&mut self, target: u32) {
        if self.next_id < target {
            self.next_id = target;
        }
    }

    /// Clear metadata (datas, label_ranges) but preserve the ID counter
    /// at `start_id` so subsequent allocations get globally unique IDs.
    /// The base_id is set to start_id so get_data(new_id) works correctly.
    pub fn clear_metadata_only(&mut self, start_id: u32) {
        self.next_id = start_id;
        self.base_id = start_id;
        self.datas.clear();
        self.label_ranges = LabelRanges::default();
    }

    /// Push current state onto an internal stack (for nested air scopes).
    pub fn push(&mut self) {
        self.stack.push((
            self.next_id,
            std::mem::take(&mut self.datas),
            std::mem::take(&mut self.label_ranges),
            self.base_id,
        ));
        self.next_id = 0;
        self.base_id = 0;
    }

    /// Restore previously pushed state.
    pub fn pop(&mut self) {
        if let Some((id, datas, lr, base)) = self.stack.pop() {
            self.next_id = id;
            self.datas = datas;
            self.label_ranges = lr;
            self.base_id = base;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_reserve_and_lookup() {
        let mut alloc = IdAllocator::new("test");
        let id0 = alloc.reserve(1, Some("alpha"), &[], IdData::default());
        assert_eq!(id0, 0);
        let id1 = alloc.reserve(3, Some("beta"), &[3], IdData::default());
        assert_eq!(id1, 1);
        assert_eq!(alloc.len(), 4);
        assert_eq!(alloc.label_ranges.get_label(0), Some("alpha"));
        assert_eq!(alloc.label_ranges.get_label(1), Some("beta"));
        assert_eq!(alloc.label_ranges.get_label(3), Some("beta"));
        assert_eq!(alloc.label_ranges.get_label(4), None);
    }

    #[test]
    fn test_push_pop() {
        let mut alloc = IdAllocator::new("test");
        alloc.reserve(2, Some("a"), &[], IdData::default());
        assert_eq!(alloc.len(), 2);
        alloc.push();
        assert_eq!(alloc.len(), 0);
        alloc.reserve(1, Some("b"), &[], IdData::default());
        assert_eq!(alloc.len(), 1);
        alloc.pop();
        assert_eq!(alloc.len(), 2);
    }
}
