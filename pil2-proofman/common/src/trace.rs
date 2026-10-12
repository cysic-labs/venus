use std::mem::ManuallyDrop;
use std::ops::{Deref, DerefMut};
use std::ptr::NonNull;

use crate::{ProofmanError, ProofmanResult};

pub trait Trace<F>: Send {
    fn num_rows(&self) -> usize;
    fn num_cols(&self) -> usize;
    fn airgroup_id(&self) -> usize;
    fn air_id(&self) -> usize;
    fn commit_id(&self) -> Option<usize>;
    fn get_buffer(&mut self) -> Vec<F>;
    fn is_shared_buffer(&self) -> bool;
    fn is_packed(&self) -> bool;
}

pub trait Values<F>: Send {
    fn get_buffer(&mut self) -> Vec<F>;
}

use rayon::prelude::*;

pub trait TraceRow: Copy + Default + Send {
    const ROW_SIZE: usize;
    const IS_PACKED: bool;
}

/// Rows of a trace. They live either in a row vector allocated for the trace or in place over the
/// allocation of a field vector handed to the trace; that allocation is only ever freed or returned
/// as the original field vector, never with the layout of the rows.
pub struct RowBuffer<R> {
    rows: NonNull<R>,
    len: usize,
    storage: RowStorage,
}

#[derive(Clone, Copy)]
enum RowStorage {
    /// `rows` and `len` are the parts of a `Vec<R>` with this capacity.
    Rows { capacity: usize },
    /// `rows` points to the allocation of a `Vec<F>` with these parts.
    Field { len: usize, capacity: usize, element_size: usize, element_align: usize, drop_vec: FieldVecDrop },
}

type FieldVecDrop = unsafe fn(NonNull<u8>, usize, usize);

/// # Safety
///
/// The arguments must be the parts of a `Vec<F>` that was taken apart and is no longer used.
unsafe fn drop_field_vec<F>(ptr: NonNull<u8>, len: usize, capacity: usize) {
    drop(unsafe { Vec::from_raw_parts(ptr.cast::<F>().as_ptr(), len, capacity) });
}

// SAFETY: a RowBuffer owns its rows exclusively, like the vector it was built from. Field vectors
// reused for rows hold `Copy` elements, so freeing them on another thread runs no destructor.
unsafe impl<R: Send> Send for RowBuffer<R> {}
// SAFETY: shared access only reads the rows.
unsafe impl<R: Sync> Sync for RowBuffer<R> {}

impl<R> RowBuffer<R> {
    pub fn owned(rows: Vec<R>) -> Self {
        let mut rows = ManuallyDrop::new(rows);
        let capacity = rows.capacity();
        Self { rows: non_null(rows.as_mut_ptr()), len: rows.len(), storage: RowStorage::Rows { capacity } }
    }

    /// Uses the allocation of `source` for its first `num_rows` rows.
    ///
    /// # Safety
    ///
    /// `R` must have the size of a whole number of `F` elements and the alignment of `F`, and
    /// `source` must hold at least as many elements as `num_rows` rows take.
    pub unsafe fn from_field_vec<F: Copy>(source: Vec<F>, num_rows: usize) -> Self {
        let mut source = ManuallyDrop::new(source);
        Self {
            rows: non_null(source.as_mut_ptr()).cast(),
            len: num_rows,
            storage: RowStorage::Field {
                len: source.len(),
                capacity: source.capacity(),
                element_size: std::mem::size_of::<F>(),
                element_align: std::mem::align_of::<F>(),
                drop_vec: drop_field_vec::<F>,
            },
        }
    }

    pub fn as_mut_slice(&mut self) -> &mut [R] {
        self
    }

    /// Returns the rows as a vector of `field_len` field elements. Rows that reuse a field vector
    /// give back that vector with its original length.
    ///
    /// # Safety
    ///
    /// `R` must have the size of a whole number of `F` elements and the alignment of `F`, and
    /// `field_len` must not exceed the elements held by the rows.
    pub unsafe fn into_field_vec<F>(self, field_len: usize) -> Vec<F> {
        let this = ManuallyDrop::new(self);
        let ptr = this.rows.cast::<F>().as_ptr();
        match this.storage {
            RowStorage::Rows { capacity } => {
                let field_size = std::mem::size_of::<F>();
                let capacity_bytes = capacity * std::mem::size_of::<R>();
                assert_eq!(capacity_bytes % field_size, 0, "Trace buffer capacity is not divisible by the field size");
                let field_capacity = capacity_bytes / field_size;
                assert!(
                    field_len <= field_capacity,
                    "Trace buffer was already taken or is too small: requested {field_len} fields, capacity {field_capacity}"
                );
                unsafe { Vec::from_raw_parts(ptr, field_len, field_capacity) }
            }
            RowStorage::Field { len, capacity, element_size, element_align, .. } => {
                assert!(
                    element_size == std::mem::size_of::<F>() && element_align == std::mem::align_of::<F>(),
                    "Trace buffer field type does not match the vector it was built from"
                );
                unsafe { Vec::from_raw_parts(ptr, len, capacity) }
            }
        }
    }
}

fn non_null<T>(ptr: *mut T) -> NonNull<T> {
    NonNull::new(ptr).expect("vector pointers are never null")
}

impl<R> Default for RowBuffer<R> {
    fn default() -> Self {
        Self::owned(Vec::new())
    }
}

impl<R> Deref for RowBuffer<R> {
    type Target = [R];

    fn deref(&self) -> &[R] {
        // SAFETY: `rows` points to `len` initialized rows owned by this buffer.
        unsafe { std::slice::from_raw_parts(self.rows.as_ptr(), self.len) }
    }
}

impl<R> DerefMut for RowBuffer<R> {
    fn deref_mut(&mut self) -> &mut [R] {
        // SAFETY: `rows` points to `len` initialized rows owned exclusively by this buffer.
        unsafe { std::slice::from_raw_parts_mut(self.rows.as_ptr(), self.len) }
    }
}

impl<R> Drop for RowBuffer<R> {
    fn drop(&mut self) {
        // SAFETY: the parts were taken from the vector that owns the allocation.
        match self.storage {
            RowStorage::Rows { capacity } => unsafe {
                drop(Vec::from_raw_parts(self.rows.as_ptr(), self.len, capacity));
            },
            RowStorage::Field { len, capacity, drop_vec, .. } => unsafe { drop_vec(self.rows.cast(), len, capacity) },
        }
    }
}

#[derive(Default)]
pub struct GenericTrace<
    R: TraceRow,
    const NUM_ROWS: usize,
    const AIRGROUP_ID: usize,
    const AIR_ID: usize,
    const COMMIT_ID: usize = 0,
> {
    // Buffer of rows
    pub buffer: RowBuffer<R>,

    // Whether the buffer was created from scratch (false) or over an existing Vec<F> (true) to reuse memory
    pub shared_buffer: bool,
}

impl<R: TraceRow, const NUM_ROWS: usize, const AIRGROUP_ID: usize, const AIR_ID: usize, const COMMIT_ID: usize>
    GenericTrace<R, NUM_ROWS, AIRGROUP_ID, AIR_ID, COMMIT_ID>
{
    pub const NUM_ROWS: usize = NUM_ROWS;
    pub const AIRGROUP_ID: usize = AIRGROUP_ID;
    pub const AIR_ID: usize = AIR_ID;
    pub const COMMIT_ID: usize = COMMIT_ID;
    pub const ROW_SIZE: usize = R::ROW_SIZE;

    pub fn new() -> Self {
        GenericTrace::with_capacity(NUM_ROWS)
    }
    pub fn new_zeroes() -> Self {
        let num_rows = NUM_ROWS;

        debug_assert!(num_rows >= 2);
        debug_assert!(num_rows & (num_rows - 1) == 0);

        let buffer: Vec<R> = vec![R::default(); num_rows];

        Self { buffer: RowBuffer::owned(buffer), shared_buffer: false }
    }

    pub fn with_capacity(num_rows: usize) -> Self {
        debug_assert!(num_rows >= 2);
        debug_assert!(num_rows & (num_rows - 1) == 0);

        #[allow(unused_mut)]
        let mut buffer: Vec<R> = vec![R::default(); num_rows];

        #[cfg(feature = "diagnostic")]
        unsafe {
            let mut ptr = buffer.as_mut_ptr() as *mut u64;
            let expected_len = num_rows;
            for _ in 0..expected_len * R::ROW_SIZE {
                ptr.write(u64::MAX - 1);
                ptr = ptr.add(1);
            }
        }

        Self { buffer: RowBuffer::owned(buffer), shared_buffer: false }
    }

    /// Checks that a row is exactly `ROW_SIZE` elements of `F`, so rows and field vectors can
    /// share one allocation.
    fn validate_row_layout<F>() -> ProofmanResult<()> {
        let row_bytes = std::mem::size_of::<R>();
        let field_bytes = std::mem::size_of::<F>();
        if field_bytes == 0
            || R::ROW_SIZE.checked_mul(field_bytes) != Some(row_bytes)
            || std::mem::align_of::<R>() != std::mem::align_of::<F>()
        {
            return Err(ProofmanError::InvalidParameters(format!(
                "Trace row {} ({row_bytes} bytes, align {}) is not ROW_SIZE={} elements of {} ({field_bytes} bytes, align {})",
                std::any::type_name::<R>(),
                std::mem::align_of::<R>(),
                R::ROW_SIZE,
                std::any::type_name::<F>(),
                std::mem::align_of::<F>()
            )));
        }
        Ok(())
    }

    fn used_len() -> ProofmanResult<usize> {
        NUM_ROWS
            .checked_mul(R::ROW_SIZE)
            .ok_or_else(|| ProofmanError::InvalidParameters("Trace buffer length overflows usize".to_string()))
    }

    pub fn new_from_vec_zeroes<F: Default + Copy + Send>(mut buffer: Vec<F>) -> ProofmanResult<Self> {
        Self::validate_row_layout::<F>()?;
        let used_len = Self::used_len()?;

        if buffer.len() < used_len {
            return Err(ProofmanError::InvalidParameters(format!(
                "Provided buffer too small: got {}, expected at least {}",
                buffer.len(),
                used_len
            )));
        }
        buffer[..used_len].par_iter_mut().for_each(|x| {
            *x = <F>::default();
        });

        // SAFETY: the row layout was validated and the buffer holds `NUM_ROWS` rows.
        let buffer = unsafe { RowBuffer::from_field_vec(buffer, NUM_ROWS) };
        Ok(Self { buffer, shared_buffer: true })
    }

    pub fn new_from_vec<F: Copy>(mut buffer: Vec<F>) -> ProofmanResult<Self> {
        Self::validate_row_layout::<F>()?;
        let num_rows = NUM_ROWS;
        let expected_len = Self::used_len()?;

        if buffer.len() < expected_len {
            return Err(ProofmanError::InvalidParameters(format!(
                "Provided buffer too small: got {}, expected at least {}",
                buffer.len(),
                expected_len
            )));
        }

        debug_assert!(num_rows >= 2);
        debug_assert!(num_rows & (num_rows - 1) == 0);

        if cfg!(feature = "diagnostic") {
            unsafe {
                let mut ptr = buffer.as_mut_ptr() as *mut u64;
                for _ in 0..expected_len {
                    ptr.write(u64::MAX - 1);
                    ptr = ptr.add(1);
                }
            }
        }

        // SAFETY: the row layout was validated and the buffer holds `NUM_ROWS` rows.
        let buffer = unsafe { RowBuffer::from_field_vec(buffer, num_rows) };
        Ok(Self { buffer, shared_buffer: true })
    }

    pub fn par_iter_mut_chunks(&mut self, n: usize) -> impl IndexedParallelIterator<Item = &mut [R]> {
        debug_assert!(n > 0 && (n & (n - 1)) == 0, "n must be a power of two");
        debug_assert!(n <= NUM_ROWS, "n must be less than or equal to NUM_ROWS");
        let chunk_size = NUM_ROWS / n;
        debug_assert!(chunk_size > 0, "Chunk size must be greater than zero");
        self.buffer.par_chunks_mut(chunk_size)
    }

    pub fn get_buffer<F>(&mut self) -> Vec<F> {
        if let Err(err) = Self::validate_row_layout::<F>() {
            panic!("{err}");
        }
        let len = Self::used_len().unwrap_or_else(|err| panic!("{err}"));
        // SAFETY: the row layout was validated and the rows hold `len` field elements.
        unsafe { std::mem::take(&mut self.buffer).into_field_vec(len) }
    }

    pub fn is_shared_buffer(&self) -> bool {
        self.shared_buffer
    }

    pub const fn num_rows(&self) -> usize {
        NUM_ROWS
    }

    pub const fn airgroup_id(&self) -> usize {
        AIRGROUP_ID
    }

    pub const fn air_id(&self) -> usize {
        AIR_ID
    }

    pub const fn row_size(&self) -> usize {
        R::ROW_SIZE
    }

    pub const fn num_cols(&self) -> usize {
        R::ROW_SIZE
    }

    pub const fn commit_id(&self) -> Option<usize> {
        // Return the commit ID if it's not zero
        if COMMIT_ID == 0 {
            None
        } else {
            Some(COMMIT_ID)
        }
    }
}

impl<
        F: Default + Clone + Copy + Send,
        R: TraceRow,
        const NUM_ROWS: usize,
        const AIRGROUP_ID: usize,
        const AIR_ID: usize,
        const COMMIT_ID: usize,
    > crate::trace::Trace<F> for GenericTrace<R, NUM_ROWS, AIRGROUP_ID, AIR_ID, COMMIT_ID>
{
    fn num_rows(&self) -> usize {
        NUM_ROWS
    }

    fn num_cols(&self) -> usize {
        R::ROW_SIZE
    }

    fn airgroup_id(&self) -> usize {
        AIRGROUP_ID
    }

    fn air_id(&self) -> usize {
        AIR_ID
    }

    fn commit_id(&self) -> Option<usize> {
        self.commit_id()
    }

    fn get_buffer(&mut self) -> Vec<F> {
        self.get_buffer()
    }

    fn is_shared_buffer(&self) -> bool {
        self.shared_buffer
    }

    fn is_packed(&self) -> bool {
        R::IS_PACKED
    }
}

impl<R: TraceRow, const NUM_ROWS: usize, const AIRGROUP_ID: usize, const AIR_ID: usize, const COMMIT_ID: usize>
    std::ops::Index<usize> for GenericTrace<R, NUM_ROWS, AIRGROUP_ID, AIR_ID, COMMIT_ID>
{
    type Output = R;

    fn index(&self, index: usize) -> &Self::Output {
        &self.buffer[index]
    }
}

impl<R: TraceRow, const NUM_ROWS: usize, const AIRGROUP_ID: usize, const AIR_ID: usize, const COMMIT_ID: usize>
    std::ops::IndexMut<usize> for GenericTrace<R, NUM_ROWS, AIRGROUP_ID, AIR_ID, COMMIT_ID>
{
    fn index_mut(&mut self, index: usize) -> &mut Self::Output {
        &mut self.buffer[index]
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use proofman_macros::trace;
    use crate as common;

    // A simple TraceRow implementation for tests
    #[repr(C)]
    #[derive(Copy, Clone, Default)]
    struct SampleTestRow {
        values: [u64; 4],
    }
    impl TraceRow for SampleTestRow {
        const ROW_SIZE: usize = 4;
        const IS_PACKED: bool = false;
    }

    // Helper to build a flat buffer of F (u64 here) with sequential numbers
    fn make_buffer(len: usize) -> Vec<u64> {
        (0..len as u64).collect()
    }

    type SampleTrace = GenericTrace<SampleTestRow, 16, 2, 7>; // 16 rows, row_size 4 => flat 64 elements

    #[test]
    fn new_zeroes_initializes_rows() {
        let t = SampleTrace::new_zeroes();

        assert_eq!(t.num_rows(), 16);
        assert_eq!(t.row_size(), SampleTestRow::ROW_SIZE);
        assert!(!t.is_shared_buffer());
        assert_eq!(t.buffer.len(), 16);
    }

    #[test]
    fn with_capacity_uninitialized_layout() {
        let t = SampleTrace::new();
        assert_eq!(t.buffer.len(), 16);
    }

    #[test]
    fn new_from_vec_zeroes_sets_all_zero_and_marks_shared() {
        // Provide larger buffer than needed to ensure slicing works
        let buf = vec![123u64; 16 * SampleTestRow::ROW_SIZE + 10];
        let mut t = GenericTrace::<SampleTestRow, 16, 0, 0>::new_from_vec_zeroes(buf.clone()).unwrap();
        assert!(t.is_shared_buffer());
        assert_eq!(t.buffer.len(), 16);
        // Convert back to flat representation safely via get_buffer()
        let flat: Vec<u64> = t.get_buffer();
        // get_buffer() returns the original buffer with original length (74 elements)
        assert_eq!(flat.len(), 16 * SampleTestRow::ROW_SIZE + 10);
        // Only the first 64 elements (used portion) should be zeroed
        assert!(
            flat[..16 * SampleTestRow::ROW_SIZE].iter().all(|&x| x == 0),
            "expected used portion to be zeroed after zero-initialization"
        );
        // The remaining elements should retain original values (123)
        assert!(
            flat[16 * SampleTestRow::ROW_SIZE..].iter().all(|&x| x == 123),
            "expected unused portion to retain original values"
        );
    }

    #[test]
    fn new_from_vec_keeps_shared_flag() {
        let flat_len = 16 * SampleTestRow::ROW_SIZE;
        let buf = make_buffer(flat_len);
        let t = GenericTrace::<SampleTestRow, 16, 2, 7>::new_from_vec(buf).unwrap();
        assert!(t.is_shared_buffer());
        assert_eq!(t.airgroup_id(), 2);
        assert_eq!(t.air_id(), 7);
        assert_eq!(t.commit_id(), None);
    }

    #[test]
    fn from_vec_alias() {
        let flat_len = 16 * SampleTestRow::ROW_SIZE;
        let buf = make_buffer(flat_len);
        let t = GenericTrace::<SampleTestRow, 16, 0, 0>::new_from_vec(buf).unwrap();
        assert!(t.is_shared_buffer());
    }

    #[test]
    fn par_iter_mut_chunks_power_of_two_partitions() {
        let mut t = SampleTrace::new_zeroes();
        // Write distinct sentinel per chunk using 4 chunks
        t.par_iter_mut_chunks(4).enumerate().for_each(|(i, chunk)| {
            assert!(!chunk.is_empty());
            for row in chunk.iter_mut() {
                row.values = [i as u64; 4];
            }
        });
        for row in 0..16 {
            assert_eq!(t[row].values, [(row / 4) as u64; 4]);
        }
    }

    #[test]
    #[should_panic]
    fn par_iter_mut_chunks_panics_non_power_of_two() {
        let mut t = SampleTrace::new_zeroes();
        let _ = t.par_iter_mut_chunks(3); // not power of two
    }

    #[test]
    #[should_panic]
    fn par_iter_mut_chunks_panics_too_large() {
        let mut t = SampleTrace::new_zeroes();
        let _ = t.par_iter_mut_chunks(32); // greater than NUM_ROWS
    }

    #[test]
    fn get_buffer_converts_back_to_flat() {
        let flat_len = 16 * SampleTestRow::ROW_SIZE;
        let buf = make_buffer(flat_len);
        let mut t = GenericTrace::<SampleTestRow, 16, 0, 0>::new_from_vec(buf.clone()).unwrap();
        let recovered: Vec<u64> = t.get_buffer();
        assert_eq!(recovered.len(), flat_len);
        // We can't guarantee ordering semantics without knowing row representation layout, but we can at least
        // check capacity/length match expectation.
        assert_eq!(recovered.capacity(), flat_len);
    }

    #[test]
    fn check() {
        trace!(TraceRow, MyTrace<F> { a: F, b:F}, 0, 0, 8, 0);

        assert_eq!(TraceRow::<usize>::ROW_SIZE, 2);

        let mut trace = MyTrace::new();
        let num_rows = trace.num_rows();

        // Set values
        for i in 0..num_rows {
            trace[i].a = i;
            trace[i].b = i * 10;
        }

        // Check values
        for i in 0..num_rows {
            assert_eq!(trace[i].a, i);
            assert_eq!(trace[i].b, i * 10);
        }
    }

    #[test]
    fn check_array() {
        trace!(TraceRow, MyTrace<F> { a: F, b: [F; 3], c: F }, 0, 0, 8, 0);

        assert_eq!(TraceRow::<usize>::ROW_SIZE, 5);
        let mut trace = MyTrace::new();
        let num_rows = trace.num_rows();

        // Set values
        for i in 0..num_rows {
            trace[i].a = i;
            trace[i].b[0] = i * 10;
            trace[i].b[1] = i * 20;
            trace[i].b[2] = i * 30;
            trace[i].c = i * 40;
        }

        let buffer = trace.get_buffer();

        // Check values
        for i in 0..num_rows {
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE], i);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 1], i * 10);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 2], i * 20);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 3], i * 30);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 4], i * 40);
        }
    }

    #[test]
    fn check_multi_array() {
        trace!(TraceRow, MyTrace<F> { a: [[F;3]; 2], b: F }, 0, 0, 8, 0);

        assert_eq!(TraceRow::<usize>::ROW_SIZE, 7);

        let mut trace = MyTrace::new();
        let num_rows = trace.num_rows();

        // Set values
        for i in 0..num_rows {
            trace[i].a[0][0] = i;
            trace[i].a[0][1] = i * 10;
            trace[i].a[0][2] = i * 20;
            trace[i].a[1][0] = i * 30;
            trace[i].a[1][1] = i * 40;
            trace[i].a[1][2] = i * 50;
            trace[i].b = i + 3;
        }

        let buffer = trace.get_buffer();

        // Check values
        for i in 0..num_rows {
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE], i);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 1], i * 10);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 2], i * 20);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 3], i * 30);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 4], i * 40);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 5], i * 50);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 6], i + 3);
        }
    }

    #[test]
    fn check_multi_array_2() {
        trace!(TraceRow, MyTrace<F> { a: [[F;3]; 2], b: F, c: [F; 2] }, 0, 0, 8, 0);

        assert_eq!(TraceRow::<usize>::ROW_SIZE, 9);

        let mut trace = MyTrace::new();
        let num_rows = trace.num_rows();

        // Set values
        for i in 0..num_rows {
            trace[i].a[0][0] = i;
            trace[i].a[0][1] = i * 10;
            trace[i].a[0][2] = i * 20;
            trace[i].a[1][0] = i * 30;
            trace[i].a[1][1] = i * 40;
            trace[i].a[1][2] = i * 50;
            trace[i].b = i + 3;
            trace[i].c[0] = i + 9;
            trace[i].c[1] = i + 2;
        }

        let buffer = trace.get_buffer();

        // Check values
        for i in 0..num_rows {
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE], i);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 1], i * 10);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 2], i * 20);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 3], i * 30);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 4], i * 40);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 5], i * 50);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 6], i + 3);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 7], i + 9);
            assert_eq!(buffer[i * TraceRow::<usize>::ROW_SIZE + 8], i + 2);
        }
    }
}
