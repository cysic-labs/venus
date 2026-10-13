pub mod blake2b;
pub mod bls381;
pub mod bn254;
pub mod keccak256;
pub mod kzg;
pub mod modexp;
pub mod secp256k1;
pub mod secp256r1;
pub mod sha256;

/// Macro to generate size, offset, and expected length constants for hint data fields.
///
/// # Example
/// ```ignore
/// hint_fields![A: 4, B: 4, M: 4]
/// ```
/// Generates:
/// - `A_SIZE`, `B_SIZE`, `M_SIZE` constants
/// - `A_OFFSET`, `B_OFFSET`, `M_OFFSET` constants (cumulative offsets)
/// - `EXPECTED_LEN` constant (sum of all sizes)
#[macro_export]
macro_rules! hint_fields {
    ($($name:ident: $size:expr),+ $(,)?) => {
        paste::paste! {
            $(
                #[allow(dead_code)]
                const [<$name _SIZE>]: usize = $size;
            )+
        }

        hint_fields!(@offsets 0, $($name: $size),+);

        #[allow(unused)]
        const EXPECTED_LEN: usize = hint_fields!(@sum $($size),+);
    };

    (@offsets $offset:expr, $name:ident: $size:expr) => {
        paste::paste! {
            #[allow(dead_code)]
            const [<$name _OFFSET>]: usize = $offset;
        }
    };

    (@offsets $offset:expr, $name:ident: $size:expr, $($rest_name:ident: $rest_size:expr),+) => {
        paste::paste! {
            const [<$name _OFFSET>]: usize = $offset;
        }
        hint_fields!(@offsets $offset + $size, $($rest_name: $rest_size),+);
    };

    (@sum $size:expr) => { $size };
    (@sum $size:expr, $($rest:expr),+) => {
        $size + hint_fields!(@sum $($rest),+)
    };
}

// #[inline]
// fn read_field<'a>(data: &'a [u64], pos: &mut usize) -> anyhow::Result<&'a [u64]> {
//     let len =
//         *data.get(*pos).ok_or("MODEXP hint data too short").map_err(anyhow::Error::msg)? as usize;
//     *pos += 1;
//     let field = data
//         .get(*pos..*pos + len)
//         .ok_or("MODEXP hint data too short")
//         .map_err(anyhow::Error::msg)?;
//     *pos += len;
//     Ok(field)
// }

#[inline]
fn read_field_bytes<'a>(data: &'a [u64], pos: &mut usize) -> anyhow::Result<(&'a [u8], usize)> {
    // Treat the entire u64 slice as bytes
    let byte_data: &[u8] = unsafe {
        std::slice::from_raw_parts(data.as_ptr() as *const u8, std::mem::size_of_val(data))
    };

    // Make sure we have at least 8 bytes for the length header
    let len_end =
        pos.checked_add(8).ok_or_else(|| anyhow::anyhow!("MODEXP hint length offset overflow"))?;
    if len_end > byte_data.len() {
        anyhow::bail!("MODEXP hint data too short to read length");
    }

    // Read length as native-endian u64
    let len_u64 =
        u64::from_ne_bytes(byte_data[*pos..len_end].try_into().expect("slice length checked"));
    let len_bytes = usize::try_from(len_u64)
        .map_err(|_| anyhow::anyhow!("MODEXP field length does not fit in usize"))?;
    *pos = len_end;

    // Ensure there are enough bytes for the field
    let field_end = pos
        .checked_add(len_bytes)
        .ok_or_else(|| anyhow::anyhow!("MODEXP field length overflow"))?;
    if field_end > byte_data.len() {
        anyhow::bail!("MODEXP hint data too short for field");
    }

    // Get the slice
    let field = &byte_data[*pos..field_end];
    *pos = field_end;

    Ok((field, len_bytes))
}

/// Validates that the hint data has the expected length.
///
/// # Arguments
///
/// * `data` - The hint data to validate
/// * `expected_len` - The expected number of u64 values
/// * `hint_name` - The name of the hint type for error messages
///
/// # Returns
///
/// * `Ok(())` - If the length is correct
/// * `Err(anyhow::Error)` - If the length is incorrect
#[inline]
fn validate_hint_length<T>(data: &[T], expected_len: usize, hint_name: &str) -> anyhow::Result<()> {
    if data.len() != expected_len {
        anyhow::bail!(
            "Invalid {} hint length: expected {}, got {}",
            hint_name,
            expected_len,
            data.len(),
        );
    }
    Ok(())
}

/// Reads the pair count of a hint laid out as `[num_pairs, pairs...]` and checks that the data
/// holds exactly `num_pairs` pairs of `pair_words` words each. Once it does, the pairs' byte length
/// cannot overflow, since a pair takes at most `pair_words * 8` bytes.
#[inline]
fn read_num_pairs(data: &[u64], pair_words: usize, hint_name: &str) -> anyhow::Result<usize> {
    let Some(&num_pairs) = data.first() else {
        anyhow::bail!("{hint_name}: data is empty");
    };
    let expected_len = usize::try_from(num_pairs)
        .ok()
        .and_then(|num_pairs| num_pairs.checked_mul(pair_words))
        .and_then(|words| words.checked_add(1))
        .ok_or_else(|| {
            anyhow::anyhow!("{hint_name}: pair count {num_pairs} overflows the hint length")
        })?;
    validate_hint_length(data, expected_len, hint_name)?;
    Ok(num_pairs as usize)
}
