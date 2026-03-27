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
    stack: Vec<(u32, Vec<IdData>, LabelRanges)>,
}

impl IdAllocator {
    pub fn new(type_name: &str) -> Self {
        Self {
            type_name: type_name.to_string(),
            next_id: 0,
            datas: Vec::new(),
            label_ranges: LabelRanges::default(),
            stack: Vec::new(),
        }
    }

    pub fn len(&self) -> u32 {
        self.next_id
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
            let mut d = data.clone();
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
        self.datas.get(id as usize)
    }

    pub fn is_defined(&self, id: u32) -> bool {
        id < self.next_id
    }

    /// Clear all allocations (used when switching air contexts).
    pub fn clear(&mut self) {
        self.next_id = 0;
        self.datas.clear();
        self.label_ranges = LabelRanges::default();
    }

    /// Push current state onto an internal stack (for nested air scopes).
    pub fn push(&mut self) {
        self.stack.push((
            self.next_id,
            std::mem::take(&mut self.datas),
            std::mem::take(&mut self.label_ranges),
        ));
        self.next_id = 0;
    }

    /// Restore previously pushed state.
    pub fn pop(&mut self) {
        if let Some((id, datas, lr)) = self.stack.pop() {
            self.next_id = id;
            self.datas = datas;
            self.label_ranges = lr;
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
