use crate::{handlers::read_field_bytes, zisklib};

use anyhow::Result;

// Processes a `MODEXP` hint.
#[inline]
pub fn modexp_hint(data: &[u64]) -> Result<Vec<u64>> {
    let mut pos = 0;
    let (base, base_len) = read_field_bytes(data, &mut pos)?;
    let (exp, exp_len) = read_field_bytes(data, &mut pos)?;
    let (modulus, modulus_len) = read_field_bytes(data, &mut pos)?;

    // Verify the data length matches: 3 length prefixes (8 bytes each) + field data,
    // converted to u64 words (rounded up for alignment).
    let expected_bytes = 24usize
        .checked_add(base_len)
        .and_then(|len| len.checked_add(exp_len))
        .and_then(|len| len.checked_add(modulus_len))
        .ok_or_else(|| anyhow::anyhow!("MODEXP hint data length overflow"))?;
    let expected_words = expected_bytes.div_ceil(8);
    if expected_words != data.len() {
        anyhow::bail!(
            "MODEXP hint data length mismatch: expected {} words, got {} words",
            expected_words,
            data.len()
        );
    }

    let mut hints = Vec::new();
    let mut result = vec![0u8; modulus_len];
    unsafe {
        zisklib::modexp_bytes_c(
            base.as_ptr(),
            base_len,
            exp.as_ptr(),
            exp_len,
            modulus.as_ptr(),
            modulus_len,
            result.as_mut_ptr(),
            &mut hints,
        );
    }

    Ok(hints)
}

#[cfg(test)]
mod tests {
    use super::modexp_hint;

    #[test]
    fn rejects_field_length_larger_than_payload() {
        assert!(modexp_hint(&[u64::MAX]).is_err());
    }
}
