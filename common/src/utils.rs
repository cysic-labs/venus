use std::fs::File;
use std::io::{self, Read};
use std::mem::MaybeUninit;
use std::path::Path;
use std::sync::atomic::AtomicU64;

use bytemuck::Pod;

pub fn create_atomic_vec(size: usize) -> Vec<AtomicU64> {
    std::iter::repeat_with(|| AtomicU64::new(0)).take(size).collect()
}

#[inline(always)]
pub fn uninit_array<const N: usize>() -> MaybeUninit<[u64; N]> {
    MaybeUninit::uninit()
}

#[macro_export]
macro_rules! trace_file {
    ($($arg:tt)*) => {
        tracing::trace!(target: "screen_and_file", $($arg)*);
    };
}

#[macro_export]
macro_rules! debug_file {
    ($($arg:tt)*) => {
        tracing::debug!(target: "screen_and_file", $($arg)*);
    };
}

#[macro_export]
macro_rules! info_file {
    ($($arg:tt)*) => {
        tracing::info!(target: "screen_and_file", $($arg)*);
    };
}

#[macro_export]
macro_rules! warn_file {
    ($($arg:tt)*) => {
        tracing::warn!(target: "screen_and_file", $($arg)*);
    };
}

#[macro_export]
macro_rules! error_file {
    ($($arg:tt)*) => {
        tracing::error!(target: "screen_and_file", $($arg)*);
    };
}

/// Copies the bytes of a `Vec<T>` into a new `Vec<U>`.
///
/// If the byte length is not a multiple of `size_of::<U>()`, the last element of the result is
/// zero-padded. The result has its own allocation, so it is freed with the layout of `U`.
///
/// # Returns
/// * `Ok(Vec<U>)` - A vector holding the bytes of `v`
/// * `Err` - If `T` or `U` is zero-sized
pub fn reinterpret_vec<T: Pod, U: Pod>(v: Vec<T>) -> anyhow::Result<Vec<U>> {
    let size_u = std::mem::size_of::<U>();
    if std::mem::size_of::<T>() == 0 || size_u == 0 {
        return Err(anyhow::anyhow!("zero-sized types cannot be reinterpreted"));
    }

    let bytes: &[u8] = bytemuck::cast_slice(&v);
    let mut out = vec![U::zeroed(); bytes.len().div_ceil(size_u)];
    bytemuck::cast_slice_mut::<U, u8>(&mut out)[..bytes.len()].copy_from_slice(bytes);
    Ok(out)
}

/// Reads the whole file at `path`, failing with `InvalidData` if it holds more than `max_bytes`.
///
/// The size is checked before allocating and enforced again while reading, so a file that grows
/// in between still cannot exceed the limit.
pub(crate) fn read_file_limited(path: &Path, max_bytes: u64) -> io::Result<Vec<u8>> {
    let too_large = || {
        io::Error::new(
            io::ErrorKind::InvalidData,
            format!("{} exceeds the size limit of {max_bytes} bytes", path.display()),
        )
    };

    let file = File::open(path)?;
    let len = file.metadata()?.len();
    if len > max_bytes {
        return Err(too_large());
    }

    let mut data = Vec::with_capacity(len as usize);
    file.take(max_bytes.saturating_add(1)).read_to_end(&mut data)?;
    if data.len() as u64 > max_bytes {
        return Err(too_large());
    }
    Ok(data)
}

#[cfg(test)]
mod tests {
    use super::reinterpret_vec;

    #[test]
    fn reinterpret_vec_zero_pads_from_length_not_capacity() {
        let mut bytes = Vec::with_capacity(1024);
        bytes.extend_from_slice(&[1u8, 2, 3, 4, 5, 6, 7, 8, 9]);

        let words: Vec<u64> = reinterpret_vec(bytes).unwrap();

        assert_eq!(
            words,
            [
                u64::from_ne_bytes([1, 2, 3, 4, 5, 6, 7, 8]),
                u64::from_ne_bytes([9, 0, 0, 0, 0, 0, 0, 0])
            ]
        );
    }
}
