use std::path::Path;

use fields::PrimeField64;
use proofman_starks_lib_c::write_custom_commit_c;

use crate::trace::Trace;
use crate::ProofCtx;
use crate::{ProofmanError, ProofmanResult};

const MAX_CUSTOM_COMMIT_N_BITS_EXT: u64 = 32;

fn custom_commit_domain_bits(num_rows: usize, blowup_factor: u64) -> ProofmanResult<(u64, u64)> {
    let n = u64::try_from(num_rows)
        .map_err(|_| ProofmanError::InvalidSetup("custom commit row count is too large".to_string()))?;
    if n == 0 || !n.is_power_of_two() {
        return Err(ProofmanError::InvalidSetup("custom commit row count must be a nonzero power of two".to_string()));
    }
    if blowup_factor == 0 || !blowup_factor.is_power_of_two() {
        return Err(ProofmanError::InvalidSetup(
            "custom commit blowup factor must be a nonzero power of two".to_string(),
        ));
    }
    let n_extended = blowup_factor
        .checked_mul(n)
        .ok_or_else(|| ProofmanError::InvalidSetup("custom commit extended domain overflows".to_string()))?;
    if n_extended == 0 || !n_extended.is_power_of_two() {
        return Err(ProofmanError::InvalidSetup(
            "custom commit extended domain must be a nonzero power of two".to_string(),
        ));
    }

    let n_bits = n.trailing_zeros() as u64;
    let n_bits_ext = n_extended.trailing_zeros() as u64;
    if n_bits_ext > MAX_CUSTOM_COMMIT_N_BITS_EXT {
        return Err(ProofmanError::InvalidSetup("custom commit extended domain exceeds supported size".to_string()));
    }

    Ok((n_bits, n_bits_ext))
}

pub fn write_custom_commit_trace<F: PrimeField64>(
    pctx: &ProofCtx<F>,
    custom_trace: &mut dyn Trace<F>,
    blowup_factor: u64,
    merkle_tree_arity: u64,
    file_name: &Path,
) -> ProofmanResult<Vec<F>> {
    let buffer = custom_trace.get_buffer();
    let arity = merkle_tree_arity;
    let num_rows = custom_trace.num_rows();
    let num_cols = custom_trace.num_cols();
    let (n_bits, n_bits_ext) = custom_commit_domain_bits(num_rows, blowup_factor)?;
    // The C writer reads `num_rows * num_cols` field elements from the buffer.
    let fits = num_cols != 0 && num_rows.checked_mul(num_cols).is_some_and(|len| buffer.len() >= len);
    if !fits {
        return Err(ProofmanError::InvalidParameters(format!(
            "custom commit trace buffer of {} field elements does not hold {num_rows} rows of {num_cols} columns",
            buffer.len()
        )));
    }
    let n_cols = num_cols as u64;
    let mut root = vec![F::ZERO, F::ZERO, F::ZERO, F::ZERO];

    write_custom_commit_c(
        root.as_mut_ptr() as *mut u8,
        arity,
        n_bits,
        n_bits_ext,
        n_cols,
        pctx.get_device_buffers_ptr(),
        buffer.as_ptr() as *mut u8,
        file_name.to_str().expect("Invalid file name"),
    );

    Ok(root)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn custom_commit_domain_bits_rejects_overflow() {
        let err = custom_commit_domain_bits(1usize << 20, 1u64 << 63).unwrap_err();
        assert!(matches!(err, ProofmanError::InvalidSetup(_)));
    }

    #[test]
    fn custom_commit_domain_bits_rejects_non_power_of_two() {
        let err = custom_commit_domain_bits(3, 2).unwrap_err();
        assert!(matches!(err, ProofmanError::InvalidSetup(_)));
    }

    #[test]
    fn custom_commit_domain_bits_rejects_unsupported_domain() {
        let err = custom_commit_domain_bits(1, 1u64 << 63).unwrap_err();
        assert!(matches!(err, ProofmanError::InvalidSetup(_)));
    }

    #[test]
    fn custom_commit_domain_bits_accepts_valid_domain() {
        assert_eq!(custom_commit_domain_bits(1usize << 22, 2).unwrap(), (22, 23));
    }
}
