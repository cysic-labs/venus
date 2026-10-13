//! Pairing over BN254

use crate::zisklib::lib::utils::{eq, is_one, lt};

use super::{
    constants::{G1_IDENTITY, G2_IDENTITY, P},
    curve::{g1_bytes_be_to_u64_le_bn254, is_on_curve_bn254},
    final_exp::final_exp_bn254,
    miller_loop::miller_loop_batch_bn254,
    twist::{g2_bytes_be_to_u64_le_bn254, is_on_curve_twist_bn254, is_on_subgroup_twist_bn254},
};

/// Pairing check result codes
const PAIRING_CHECK_SUCCESS: u8 = 0;
const PAIRING_CHECK_FAILED: u8 = 1;
const PAIRING_CHECK_ERR_G1_NOT_IN_FIELD: u8 = 2;
const PAIRING_CHECK_ERR_G1_NOT_ON_CURVE: u8 = 3;
const PAIRING_CHECK_ERR_G2_NOT_IN_FIELD: u8 = 4;
const PAIRING_CHECK_ERR_G2_NOT_ON_CURVE: u8 = 5;
const PAIRING_CHECK_ERR_G2_NOT_IN_SUBGROUP: u8 = 6;

/// Computes the optimal Ate pairing for a batch of G1 and G2 points over the BN254 curve
/// and multiplies the results together, i.e.:
///     e(P₁, Q₁) · e(P₂, Q₂) · ... · e(Pₙ, Qₙ) ∈ GT
///
/// The points are not validated: they must have canonical coordinates, be on their curves and,
/// for G2, be in the subgroup, as checked by [`pairing_check_bn254`]
pub(crate) fn pairing_batch_bn254(
    g1_points: &[[u64; 8]],
    g2_points: &[[u64; 16]],
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> [u64; 48] {
    // Since each e(Pi, Qi) := FinalExp(MillerLoop(Pi, Qi))
    // We have:
    //  e(P₁, Q₁) · e(P₂, Q₂) · ... · e(Pₙ, Qₙ) = FinalExp(MillerLoop(P₁, Q₁) · MillerLoop(P₂, Q₂) · ... · MillerLoop(Pₙ, Qₙ))
    // We can compute the Miller loop for each pair, multiplying the results together
    // and then just do the final exponentiation once at the end.

    let num_points = g1_points.len();
    assert_eq!(num_points, g2_points.len(), "Number of G1 and G2 points must be equal");

    // Miller loop and multiplication
    let mut g1_points_ml = Vec::with_capacity(num_points);
    let mut g2_points_ml = Vec::with_capacity(num_points);
    for (p, q) in g1_points.iter().zip(g2_points.iter()) {
        // Is p = 𝒪 or q = 𝒪?
        if *p == G1_IDENTITY || *q == G2_IDENTITY {
            // MillerLoop(P, 𝒪) = MillerLoop(𝒪, Q) = 1; we can skip
            continue;
        }

        g1_points_ml.push(*p);
        g2_points_ml.push(*q);
    }

    if g1_points_ml.is_empty() {
        // If all pairing computations were skipped, return 1
        let mut one = [0; 48];
        one[0] = 1;
        return one;
    }

    // Compute the Miller loop for the batch
    let miller_loop = miller_loop_batch_bn254(
        &g1_points_ml,
        &g2_points_ml,
        #[cfg(feature = "hints")]
        hints,
    );

    // Final exponentiation
    final_exp_bn254(
        &miller_loop,
        #[cfg(feature = "hints")]
        hints,
    )
}

/// BN254 pairing check with validation.
///
/// Validates all points have canonical field elements, are on curve, and G2 points are in subgroup.
///
/// # Arguments
/// * `g1_points` - Slice of G1 points as [u64; 8]
/// * `g2_points` - Slice of G2 points as [u64; 16]
///
/// # Returns
/// * `Ok(true)` - Pairing check passed (product of pairings == 1)
/// * `Ok(false)` - Pairing check failed (product of pairings != 1)
/// * `Err(PAIRING_CHECK_ERR_G1_NOT_IN_FIELD)` - G1 field element not canonical (>= P)
/// * `Err(PAIRING_CHECK_ERR_G1_NOT_ON_CURVE)` - G1 point not on curve
/// * `Err(PAIRING_CHECK_ERR_G2_NOT_IN_FIELD)` - G2 field element not canonical (>= P)
/// * `Err(PAIRING_CHECK_ERR_G2_NOT_ON_CURVE)` - G2 point not on twist curve
/// * `Err(PAIRING_CHECK_ERR_G2_NOT_IN_SUBGROUP)` - G2 point not in subgroup
pub fn pairing_check_bn254(
    g1_points: &[[u64; 8]],
    g2_points: &[[u64; 16]],
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> Result<bool, u8> {
    assert_eq!(g1_points.len(), g2_points.len(), "Number of G1 and G2 points must be equal");

    // Validate every point, including those paired with 𝒪
    for (g1, g2) in g1_points.iter().zip(g2_points.iter()) {
        // Validate G1 point field elements
        let x1: [u64; 4] = g1[0..4].try_into().unwrap();
        let y1: [u64; 4] = g1[4..8].try_into().unwrap();
        if !lt(&x1, &P) || !lt(&y1, &P) {
            return Err(PAIRING_CHECK_ERR_G1_NOT_IN_FIELD);
        }

        // Verify G1 point is on curve
        if !eq(g1, &G1_IDENTITY)
            && !is_on_curve_bn254(
                g1,
                #[cfg(feature = "hints")]
                hints,
            )
        {
            return Err(PAIRING_CHECK_ERR_G1_NOT_ON_CURVE);
        }

        // Validate G2 point field elements
        let x2_r: [u64; 4] = g2[0..4].try_into().unwrap();
        let x2_i: [u64; 4] = g2[4..8].try_into().unwrap();
        let y2_r: [u64; 4] = g2[8..12].try_into().unwrap();
        let y2_i: [u64; 4] = g2[12..16].try_into().unwrap();
        if !lt(&x2_r, &P) || !lt(&x2_i, &P) || !lt(&y2_r, &P) || !lt(&y2_i, &P) {
            return Err(PAIRING_CHECK_ERR_G2_NOT_IN_FIELD);
        }

        if !eq(g2, &G2_IDENTITY) {
            // Verify G2 point is on twist curve
            if !is_on_curve_twist_bn254(
                g2,
                #[cfg(feature = "hints")]
                hints,
            ) {
                return Err(PAIRING_CHECK_ERR_G2_NOT_ON_CURVE);
            }

            // Verify G2 point is in subgroup
            if !is_on_subgroup_twist_bn254(
                g2,
                #[cfg(feature = "hints")]
                hints,
            ) {
                return Err(PAIRING_CHECK_ERR_G2_NOT_IN_SUBGROUP);
            }
        }
    }

    // Compute the batch pairing, which skips the pairs with 𝒪, and check if the result is 1
    Ok(is_one(&pairing_batch_bn254(
        g1_points,
        g2_points,
        #[cfg(feature = "hints")]
        hints,
    )))
}

/// BN254 pairing check with big-endian byte format
///
/// # Safety
/// - `pairs` must point to an array of `num_pairs * 192` bytes
///   Each pair is: 64 bytes G1 point + 128 bytes G2 point
///
/// # Returns
/// - 0 = pairing check passed
/// - 1 = pairing check failed
/// - 2 = G1 field element invalid
/// - 3 = G1 point not on curve
/// - 4 = G2 field element invalid
/// - 5 = G2 point not on curve
/// - 6 = G2 point not in subgroup
#[cfg_attr(not(feature = "hints"), no_mangle)]
#[cfg_attr(feature = "hints", export_name = "hints_bn254_pairing_check_c")]
pub unsafe extern "C" fn bn254_pairing_check_c(
    pairs: *const u8,
    num_pairs: usize,
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> u8 {
    // Parse all pairs
    let mut g1_points: Vec<[u64; 8]> = Vec::with_capacity(num_pairs);
    let mut g2_points: Vec<[u64; 16]> = Vec::with_capacity(num_pairs);

    for i in 0..num_pairs {
        let pair_ptr = pairs.add(i * 192);

        let g1_bytes: &[u8; 64] = &*(pair_ptr as *const [u8; 64]);
        let g2_bytes: &[u8; 128] = &*(pair_ptr.add(64) as *const [u8; 128]);

        g1_points.push(g1_bytes_be_to_u64_le_bn254(g1_bytes));
        g2_points.push(g2_bytes_be_to_u64_le_bn254(g2_bytes));
    }

    // Perform pairing check with validation
    match pairing_check_bn254(
        &g1_points,
        &g2_points,
        #[cfg(feature = "hints")]
        hints,
    ) {
        Ok(true) => PAIRING_CHECK_SUCCESS,
        Ok(false) => PAIRING_CHECK_FAILED,
        Err(code) => code,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const G1_GENERATOR: [u64; 8] = [1, 0, 0, 0, 2, 0, 0, 0];
    const G2_GENERATOR: [u64; 16] = [
        0x46debd5cd992f6ed,
        0x674322d4f75edadd,
        0x426a00665e5c4479,
        0x1800deef121f1e76,
        0x97e485b7aef312c2,
        0xf1aa493335a9e712,
        0x7260bfb731fb5d25,
        0x198e9393920d483a,
        0x4ce6cc0166fa7daa,
        0xe3d1e7690c43d37b,
        0x4aab71808dcb408f,
        0x12c85ea5db8c6deb,
        0x55acdadcd122975b,
        0xbc4b313370b38ef3,
        0xec9e99ad690c3395,
        0x090689d0585ff075,
    ];

    fn check(g1_points: &[[u64; 8]], g2_points: &[[u64; 16]]) -> Result<bool, u8> {
        #[cfg(feature = "hints")]
        let mut hints = Vec::new();
        pairing_check_bn254(
            g1_points,
            g2_points,
            #[cfg(feature = "hints")]
            &mut hints,
        )
    }

    #[test]
    fn pairing_check_accepts_the_inverse_pair() {
        let mut neg_g1 = G1_GENERATOR;
        neg_g1[4..8].copy_from_slice(&[P[0] - 2, P[1], P[2], P[3]]);
        assert_eq!(check(&[G1_GENERATOR, neg_g1], &[G2_GENERATOR, G2_GENERATOR]), Ok(true));
        assert_eq!(check(&[G1_GENERATOR], &[G2_GENERATOR]), Ok(false));
    }

    #[test]
    fn pairing_check_rejects_non_canonical_points_paired_with_infinity() {
        // x + p is the same field element as x, but EIP-197 rejects coordinates >= p
        let mut g1_x_plus_p = G1_GENERATOR;
        g1_x_plus_p[0..4].copy_from_slice(&[P[0] + 1, P[1], P[2], P[3]]);
        assert_eq!(check(&[g1_x_plus_p], &[G2_IDENTITY]), Err(PAIRING_CHECK_ERR_G1_NOT_IN_FIELD));

        let mut g2_y_plus_p = G2_GENERATOR;
        let y_plus_p = (0..4).fold((0u128, [0u64; 4]), |(carry, mut out), i| {
            let sum = G2_GENERATOR[8 + i] as u128 + P[i] as u128 + carry;
            out[i] = sum as u64;
            (sum >> 64, out)
        });
        assert_eq!(y_plus_p.0, 0);
        g2_y_plus_p[8..12].copy_from_slice(&y_plus_p.1);
        assert_eq!(check(&[G1_IDENTITY], &[g2_y_plus_p]), Err(PAIRING_CHECK_ERR_G2_NOT_IN_FIELD));
    }
}
