use std::cmp::Ordering;

use crate::zisklib::fcall_division;

use super::{rem_long::verify_division, U256};

/// Divides two large numbers
///
/// # Assumptions
/// - `len(a) > 0` and `len(b) > 0`
/// - `a` and `b` have no leading zeros (unless `a` being zero)
/// - `b > 0`
///
/// # Returns
/// A tuple of (quotient, remainder) where a = q·b + r
///
/// # Note
/// Not optimal for `len(b) == 1`, use `div_short` instead
pub fn div_long(
    a: &[U256],
    b: &[U256],
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> (Vec<U256>, Vec<U256>) {
    let len_a = a.len();
    let len_b = b.len();
    #[cfg(debug_assertions)]
    {
        assert_ne!(len_a, 0, "Input 'a' must have at least one limb");
        assert_ne!(len_b, 0, "Input 'b' must have at least one limb");
        assert!(!b[len_b - 1].is_zero(), "Input 'b' must not have leading zeros");
        if len_a > 1 {
            assert!(!a[len_a - 1].is_zero(), "Input 'a' must not have leading zeros");
        }
    }

    // Check if a = b, a < b or a > b
    let comp = U256::compare_slices(a, b);
    if comp == Ordering::Less {
        return (vec![U256::ZERO], a.to_vec());
    } else if comp == Ordering::Equal {
        return (vec![U256::ONE], vec![U256::ZERO]);
    }
    // We can assume a > b from here on

    // Strategy: Hint the division result and then verify it satisfies Euclid's division lemma
    let a_flat = U256::slice_to_flat(a);
    let b_flat = U256::slice_to_flat(b);

    // Hint the quotient and remainder
    let mut quo_flat = vec![0u64; len_a * 4];
    let mut rem_flat = vec![0u64; len_b * 4];
    let (limbs_quo, limbs_rem) = fcall_division(
        a_flat,
        b_flat,
        &mut quo_flat,
        &mut rem_flat,
        #[cfg(feature = "hints")]
        hints,
    );
    let quo = U256::flat_to_slice(&quo_flat[..limbs_quo]);
    let rem = U256::flat_to_slice(&rem_flat[..limbs_rem]);

    // Verify the division
    let mut q_b = vec![U256::ZERO; len_a + 1]; // The +1 is because mul_long and add_agtb are a general purpose functions
    let mut q_b_r = vec![U256::ZERO; len_a + 1];
    verify_division(
        a,
        b,
        quo,
        rem,
        &mut q_b,
        &mut q_b_r,
        #[cfg(feature = "hints")]
        hints,
    );

    (quo.to_vec(), rem.to_vec())
}
