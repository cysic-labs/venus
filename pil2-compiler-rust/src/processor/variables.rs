//! Variable storage and lookup for compile-time values.
//!
//! Mirrors the JS `Variables` / `Indexable` classes. Stores typed values
//! (int, fe, string, expr) in flat arrays, supporting multi-dimensional
//! array indexing and scoped push/pop.


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

    /// Save state for nested air scope. Container-owned slot values
    /// (e.g. `proof.std.gsum.hint.*` array elements declared inside
    /// `container { ... }` bodies) are SEEDED into the new air frame
    /// AND the IdAllocator's next_id is advanced past the highest
    /// seeded slot, so subsequent reservations inside the air frame
    /// allocate fresh IDs that do not clobber container slots.
    /// Without this advance, the new frame's `next_id = 0` after
    /// push would let new reservations grab IDs 0, 1, 2, ...
    /// overwriting the seeded container slots stored at those IDs
    /// (the container fields were originally reserved at low IDs in
    /// the first AIR's frame because air push also resets next_id
    /// to 0).
    pub fn push(&mut self) {
        // Snapshot all container_owned slot indices BEFORE push.
        let owned_indices: Vec<usize> = self
            .values
            .iter()
            .enumerate()
            .filter_map(|(idx, _)| {
                let owned = self
                    .ids
                    .datas
                    .get(idx)
                    .map(|d| d.container_owned)
                    .unwrap_or(false);
                if owned { Some(idx) } else { None }
            })
            .collect();
        let owned_writes: Vec<(usize, Value)> = owned_indices
            .iter()
            .filter_map(|&idx| self.values.get(idx).cloned().flatten().map(|v| (idx, v)))
            .collect();
        let max_owned_idx: u32 = owned_indices
            .iter()
            .map(|&i| i as u32)
            .max()
            .map(|m| m + 1)
            .unwrap_or(0);

        self.ids.push();
        self.stack.push(std::mem::take(&mut self.values));

        // Reserve the seeded slot ID range in the air frame's
        // IdAllocator so future allocations skip past it. Mark every
        // seeded slot as container_owned in the air frame's datas so
        // pop's write-back recognises them.
        if max_owned_idx > 0 {
            self.ids.advance_next_id_to(max_owned_idx);
            self.ids.datas.resize(max_owned_idx as usize, IdData::default());
            for &idx in &owned_indices {
                self.ids.datas[idx].container_owned = true;
            }
        }

        // Resize values to cover the seeded slot range, then write
        // the seeded values onto it.
        if (max_owned_idx as usize) > self.values.len() {
            self.values.resize(max_owned_idx as usize, None);
        }
        for (idx, v) in owned_writes {
            self.values[idx] = Some(v);
        }
    }

    /// Restore state from nested air scope. Container-owned slot
    /// values written (or seeded) inside the air-scope frame are
    /// merged BACK onto the restored proof-scope frame so deferred
    /// handlers at proof scope (e.g.
    /// `piop_gsum_issue_global_debug_hints`) read the latest
    /// per-call writes.
    ///
    /// The container_owned check uses the AIR-frame's IdAllocator
    /// metadata (captured BEFORE `ids.pop()` releases it). The
    /// flag is then PROPAGATED onto the restored proof-frame's
    /// IdAllocator metadata so subsequent push/pop cycles continue
    /// to recognise these slots as container-owned. Without that
    /// propagation, only the first air-scope cycle's writes would
    /// survive, because after the first pop the proof-frame
    /// IdAllocator has no record that those slots are container
    /// fields, and the next push() would skip them in the seed.
    pub fn pop(&mut self) {
        // Snapshot owned-slot writes BEFORE we pop the AIR frame's
        // datas, so the container_owned check reads the AIR frame's
        // metadata.
        let owned_indices: Vec<usize> = self
            .values
            .iter()
            .enumerate()
            .filter_map(|(idx, _)| {
                let owned = self
                    .ids
                    .datas
                    .get(idx)
                    .map(|d| d.container_owned)
                    .unwrap_or(false);
                if owned { Some(idx) } else { None }
            })
            .collect();
        let owned_writes: Vec<(usize, Value)> = owned_indices
            .iter()
            .filter_map(|&idx| self.values.get(idx).cloned().flatten().map(|v| (idx, v)))
            .collect();

        self.ids.pop();
        if let Some(mut vals) = self.stack.pop() {
            // Merge the captured air-frame container_owned writes
            // onto the restored proof-frame values, AND propagate
            // the container_owned flag onto the proof-frame's
            // IdAllocator metadata at those indices so future
            // push() seeds and pop() merges continue to recognise
            // them.
            for (idx, v) in owned_writes {
                if idx >= vals.len() {
                    vals.resize(idx + 1, None);
                }
                vals[idx] = Some(v);
            }
            // Propagate ALL container_owned flags (including those
            // for slots that did not have a Some value), so the
            // proof frame remembers them for subsequent pushes.
            for idx in owned_indices {
                if idx >= self.ids.datas.len() {
                    self.ids.datas.resize(idx + 1, IdData::default());
                }
                self.ids.datas[idx].container_owned = true;
            }
            self.values = vals;
        }
    }

    /// Return a snapshot of the current allocation high-water mark.
    /// Used to trim back after a function call returns.
    pub fn snapshot(&self) -> u32 {
        self.values.len() as u32
    }

    /// Discard values allocated after `mark`, replacing them with None.
    /// Does NOT shrink the underlying Vec (IDs remain valid but empty).
    /// This reclaims heap memory held by Value::RuntimeExpr trees while
    /// keeping the allocator state consistent.
    ///
    /// Slots whose `IdData.container_owned` flag is set are NOT blanked,
    /// because container fields (e.g. `int num_global_hints = 0;` and
    /// `const expr type_piop[ARRAY_SIZE];` inside
    /// `container proof.std.gsum.hint { ... }`) must keep their stored
    /// values across the function-exit boundary so the deferred handler
    /// (e.g. `piop_gsum_issue_global_debug_hints`) reads them back as
    /// the per-call writes left them.
    pub fn trim_values_after(&mut self, mark: u32) {
        let mark = mark as usize;
        for (idx, slot) in self.values.iter_mut().enumerate().skip(mark) {
            let container_owned = self
                .ids
                .datas
                .get(idx)
                .map(|d| d.container_owned)
                .unwrap_or(false);
            if !container_owned {
                *slot = None;
            }
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
