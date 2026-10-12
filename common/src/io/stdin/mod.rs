mod file;
mod memory;
mod null;
mod zisk_stdin;

pub use file::*;
pub use memory::*;
pub use null::*;
pub use zisk_stdin::*;

use std::io::{self, Read};

/// Reads one blob written by `write_slice`: an 8-byte little-endian length, the bytes, and zero
/// padding to a multiple of 8 bytes. `available` is the number of bytes left in the source, so a
/// corrupt length is rejected before allocating.
fn read_padded_blob(reader: &mut impl Read, available: u64) -> io::Result<Vec<u8>> {
    let mut len_bytes = [0u8; 8];
    reader.read_exact(&mut len_bytes)?;
    let len = u64::from_le_bytes(len_bytes);
    let padding = (8 - len % 8) % 8;
    let fits = len.checked_add(8 + padding).is_some_and(|framed_len| framed_len <= available);
    if !fits {
        return Err(io::Error::new(
            io::ErrorKind::UnexpectedEof,
            "stdin blob length exceeds the remaining input",
        ));
    }

    let mut data = vec![0u8; len as usize];
    reader.read_exact(&mut data)?;
    reader.read_exact(&mut [0u8; 7][..padding as usize])?;
    Ok(data)
}

#[cfg(test)]
mod tests {
    use super::read_padded_blob;
    use std::io::{Cursor, ErrorKind};

    #[test]
    fn read_padded_blob_rejects_lengths_past_the_input() {
        for len in [16u64, u64::MAX] {
            let mut input = len.to_le_bytes().to_vec();
            input.extend_from_slice(&[1, 2, 3]);
            let available = input.len() as u64;

            let err = read_padded_blob(&mut Cursor::new(input), available).unwrap_err();

            assert_eq!(err.kind(), ErrorKind::UnexpectedEof);
        }
    }
}
