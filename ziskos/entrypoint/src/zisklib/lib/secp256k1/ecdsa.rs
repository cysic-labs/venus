use tiny_keccak::{Hasher, Keccak};

use crate::zisklib::{eq, fcall_secp256k1_ecdsa_verify, gt, is_zero, lt, ZERO_256};

use super::{
    constants::{IDENTITY, N_MINUS_ONE, P, P_MINUS_ONE},
    curve::{
        secp256k1_double_scalar_mul_with_g, secp256k1_is_on_curve, secp256k1_lift_x,
        secp256k1_triple_scalar_mul_with_g,
    },
    scalar::{secp256k1_fn_neg, secp256k1_fn_reduce},
};

// ECDSA verify result codes
pub const ECDSA_VERIFY_SUCCESS: u8 = 0;
pub const ECDSA_VERIFY_ERROR: u8 = 1;

/// ECDSA recover result codes
pub const ECDSA_RECOVER_SUCCESS: u8 = 0;
pub const ECDSA_RECOVER_ERR_INVALID_R: u8 = 1;
pub const ECDSA_RECOVER_ERR_INVALID_S: u8 = 2;
pub const ECDSA_RECOVER_ERR_INVALID_RECID: u8 = 3;
pub const ECDSA_RECOVER_ERR_POINT_NOT_ON_CURVE: u8 = 4;
pub const ECDSA_RECOVER_ERR_RECOVERY_FAILED: u8 = 5;

/// Verifies the signature (r, s) over the message hash z using the public key pk
///
/// # Returns
/// - 0 = valid signature
/// - 1 = public key not on curve
/// - 2 = invalid signature
pub fn secp256k1_ecdsa_verify(
    pk: &[u64; 8],
    z: &[u64; 4],
    r: &[u64; 4],
    s: &[u64; 4],
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> bool {
    if is_zero(r) || gt(r, &N_MINUS_ONE) {
        return false;
    }
    if is_zero(s) || gt(s, &N_MINUS_ONE) {
        return false;
    }
    if eq(pk, &IDENTITY) {
        return false;
    }

    let pk_x = [pk[0], pk[1], pk[2], pk[3]];
    let pk_y = [pk[4], pk[5], pk[6], pk[7]];
    if gt(&pk_x, &P_MINUS_ONE) || gt(&pk_y, &P_MINUS_ONE) {
        return false;
    }
    if !secp256k1_is_on_curve(
        pk,
        #[cfg(feature = "hints")]
        hints,
    ) {
        return false;
    }

    // Ecdsa verification computes (x, y) = [z·s⁻¹ (mod n)]G + [r·s⁻¹ (mod n)]PK
    // and checks that (x, y) != 𝒪 and x ≡ r (mod n)
    // We can equivalently hint (x,y), bind it through
    //   [z]G + [r]PK + [-s](x,y) == 𝒪,
    // and ensure that x ≡ r (mod n), saving us from expensive fn arithmetic

    // Hint the result
    let point = fcall_secp256k1_ecdsa_verify(
        pk,
        z,
        r,
        s,
        #[cfg(feature = "hints")]
        hints,
    );

    // Bind the hint to (x, y), which is the identity exactly when (x, y) = 𝒪 (an invalid signature)
    let neg_s = secp256k1_fn_neg(
        s,
        #[cfg(feature = "hints")]
        hints,
    );
    let Some(point) = secp256k1_bind_hinted_point(
        z,
        r,
        &neg_s,
        pk,
        &point,
        #[cfg(feature = "hints")]
        hints,
    ) else {
        return false;
    };

    // Check that x ≡ r (mod n)
    let point_x: [u64; 4] = [point[0], point[1], point[2], point[3]];
    eq(
        &secp256k1_fn_reduce(
            &point_x,
            #[cfg(feature = "hints")]
            hints,
        ),
        r,
    )
}

/// Recover the public key point from an ECDSA signature (r, s) over the message hash z and recovery id recid
///
/// # Returns
/// - 0 = success
/// - 1 = invalid r (not in [1, N))
/// - 2 = invalid s (not in [1, N))
/// - 3 = invalid recid (not 0 or 1)
/// - 4 = point not on curve
/// - 5 = recovery failed
pub fn secp256k1_ecdsa_recover(
    r: &[u64; 4],
    s: &[u64; 4],
    z: &[u64; 4],
    recid: u8,
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> Result<[u64; 8], u8> {
    // Validate r
    if *r == ZERO_256 || gt(r, &N_MINUS_ONE) {
        return Err(ECDSA_RECOVER_ERR_INVALID_R);
    }

    // Validate s
    if *s == ZERO_256 || gt(s, &N_MINUS_ONE) {
        return Err(ECDSA_RECOVER_ERR_INVALID_S);
    }

    // Validate recid
    if recid > 1 {
        return Err(ECDSA_RECOVER_ERR_INVALID_RECID);
    }

    // Ecdsa recovery computes R = (x,y) and
    //   (xQ, yQ) = [-z·r⁻¹ (mod n)]G + [s·r⁻¹ (mod n)]R
    // We can equivalently compute R, hint (xQ,yQ) and verify that
    //   [z]G + [-s]R + [r](xQ,yQ) == 𝒪,
    // saving us from expensive fn arithmetic

    // Determine the x-coordinate of R
    let x = *r;

    // Compute the y-coordinate from x and the parity bit
    let y_is_odd = (recid & 1) == 1;
    let r_point = secp256k1_lift_x(
        &x,
        y_is_odd,
        #[cfg(feature = "hints")]
        hints,
    )
    .map_err(|_| ECDSA_RECOVER_ERR_POINT_NOT_ON_CURVE)?;

    // Check that [z]G + [-s]R + [r](xQ,yQ) == 𝒪

    // Hint the result
    // The following functions hints (x,y) satisfying
    //    (x, y) == [s⁻¹·z (mod n)]G + [s⁻¹·r (mod n)]R iff  [z]G + [r]R + [-s](x, y) == 𝒪
    // We can use it by flipping the signs of r and s and its order
    let neg_s = secp256k1_fn_neg(
        s,
        #[cfg(feature = "hints")]
        hints,
    );
    let neg_r = secp256k1_fn_neg(
        r,
        #[cfg(feature = "hints")]
        hints,
    );
    let point = fcall_secp256k1_ecdsa_verify(
        &r_point,
        z,
        &neg_s,
        &neg_r,
        #[cfg(feature = "hints")]
        hints,
    );

    // Bind the hint through [z]G + [-s]R + [r](xQ,yQ) == 𝒪; the recovery fails exactly when
    // the recovered point is the identity
    secp256k1_bind_hinted_point(
        z,
        &neg_s,
        r,
        &r_point,
        &point,
        #[cfg(feature = "hints")]
        hints,
    )
    .ok_or(ECDSA_RECOVER_ERR_RECOVERY_FAILED)
}

/// Binds the hinted point `q` to the unique point satisfying [a]G + [b]P + [c]Q == 𝒪, where `c` is
/// invertible modulo n, and returns it, or `None` when that point is the identity.
///
/// The hint is prover-chosen, so any other value panics: a wrong hint must not be reported as an
/// invalid signature.
fn secp256k1_bind_hinted_point(
    a: &[u64; 4],
    b: &[u64; 4],
    c: &[u64; 4],
    p: &[u64; 8],
    q: &[u64; 8],
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> Option<[u64; 8]> {
    if eq(q, &IDENTITY) {
        // Q = 𝒪 holds iff [a]G + [b]P == 𝒪
        assert!(
            secp256k1_double_scalar_mul_with_g(
                a,
                b,
                p,
                #[cfg(feature = "hints")]
                hints,
            )
            .is_none(),
            "Hinted identity does not satisfy the ECDSA relation"
        );
        return None;
    }

    let x = [q[0], q[1], q[2], q[3]];
    let y = [q[4], q[5], q[6], q[7]];
    assert!(lt(&x, &P) && lt(&y, &P), "Hinted point is not canonical");
    assert!(
        secp256k1_is_on_curve(
            q,
            #[cfg(feature = "hints")]
            hints,
        ),
        "Hinted point is not on the curve"
    );
    assert!(
        secp256k1_triple_scalar_mul_with_g(
            a,
            b,
            c,
            p,
            q,
            #[cfg(feature = "hints")]
            hints,
        )
        .is_none(),
        "Hinted point does not satisfy the ECDSA relation"
    );
    Some(*q)
}

// ==================== C FFI Functions ====================

/// C-compatible wrapper for secp256k1_ecdsa_verify and address recovery
///
/// # Safety
/// - `sig` must point to at least 64 bytes (r || s, big-endian)
/// - `msg` must point to at least 32 bytes (message hash, big-endian)
/// - `pk` must point to at least 64 bytes (x || y, big-endian)
/// - `output` must point to a writable buffer of at least 32 bytes
///
/// # Arguments
/// - `sig` - 64 bytes: r (32 bytes) || s (32 bytes), big-endian
/// - `msg` - 32 bytes message hash, big-endian
/// - `pk` - 64 bytes: x (32 bytes) || y (32 bytes), big-endian
/// - `output` - Output buffer for the recovered address (32 bytes)
///
/// # Returns
/// - `Ok([u8; 32])` - Recovered address if signature is valid
/// - `Err(u8)` - Error code
#[cfg_attr(not(feature = "hints"), no_mangle)]
#[cfg_attr(feature = "hints", export_name = "hints_secp256k1_ecdsa_verify_and_address_recover_c")]
pub unsafe extern "C" fn secp256k1_ecdsa_verify_and_address_recover_c(
    sig: *const u8,
    msg: *const u8,
    pk: *const u8,
    output: *mut u8,
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> u8 {
    let sig_bytes: &[u8; 64] = &*(sig as *const [u8; 64]);
    let msg_bytes: &[u8; 32] = &*(msg as *const [u8; 32]);
    let pk_bytes: &[u8; 64] = &*(pk as *const [u8; 64]);
    let output_bytes: &mut [u8; 32] = &mut *(output as *mut [u8; 32]);

    // Parse r, s from big-endian bytes
    let r_bytes: [u8; 32] = sig_bytes[0..32].try_into().unwrap();
    let s_bytes: [u8; 32] = sig_bytes[32..64].try_into().unwrap();

    // Parse pk_x, pk_y from big-endian bytes
    let pk_x_bytes: [u8; 32] = pk_bytes[0..32].try_into().unwrap();
    let pk_y_bytes: [u8; 32] = pk_bytes[32..64].try_into().unwrap();

    // Convert to little-endian u64 limbs
    let r = bytes_be_to_u64_le(&r_bytes);
    let s = bytes_be_to_u64_le(&s_bytes);
    let z = bytes_be_to_u64_le(msg_bytes);
    let pk_x = bytes_be_to_u64_le(&pk_x_bytes);
    let pk_y = bytes_be_to_u64_le(&pk_y_bytes);

    let pk_arr: [u64; 8] = [pk_x[0], pk_x[1], pk_x[2], pk_x[3], pk_y[0], pk_y[1], pk_y[2], pk_y[3]];
    if secp256k1_ecdsa_verify(
        &pk_arr,
        &z,
        &r,
        &s,
        #[cfg(feature = "hints")]
        hints,
    ) {
        // Signature is valid - compute and return the address from the public key
        let address = pubkey_to_address(&pk_arr);
        output_bytes.copy_from_slice(&address);
        ECDSA_VERIFY_SUCCESS
    } else {
        ECDSA_VERIFY_ERROR
    }
}

/// C-compatible wrapper for secp256k1_ecdsa_recover
///
/// # Safety
/// - `sig` must point to at least 64 bytes (r || s, big-endian)
/// - `msg` must point to at least 32 bytes (message hash, big-endian)
/// - `output` must point to a writable buffer of at least 32 bytes
///
/// # Arguments
/// - `sig` - 64 bytes: r (32 bytes) || s (32 bytes), big-endian
/// - `recid` - Recovery ID (0 or 1)
/// - `msg` - 32 bytes message hash, big-endian
/// - `output` - Output buffer for the recovered address (32 bytes)
///
/// # Returns
/// - `Ok([u32; 8])` - Recovered address if recovery is successful
/// - `Err(u8)` - Error code
#[cfg_attr(not(feature = "hints"), no_mangle)]
#[cfg_attr(feature = "hints", export_name = "hints_secp256k1_ecdsa_address_recover_c")]
pub unsafe extern "C" fn secp256k1_ecdsa_address_recover_c(
    sig: *const u8,
    recid: u8,
    msg: *const u8,
    output: *mut u8,
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> u8 {
    let sig_bytes: &[u8; 64] = &*(sig as *const [u8; 64]);
    let msg_bytes: &[u8; 32] = &*(msg as *const [u8; 32]);
    let output_bytes: &mut [u8; 32] = &mut *(output as *mut [u8; 32]);

    // Parse r, s, z from big-endian bytes
    let r_bytes: [u8; 32] = sig_bytes[0..32].try_into().unwrap();
    let s_bytes: [u8; 32] = sig_bytes[32..64].try_into().unwrap();

    let r = bytes_be_to_u64_le(&r_bytes);
    let s = bytes_be_to_u64_le(&s_bytes);
    let z = bytes_be_to_u64_le(msg_bytes);

    // Perform ecrecover
    match secp256k1_ecdsa_recover(
        &r,
        &s,
        &z,
        recid,
        #[cfg(feature = "hints")]
        hints,
    ) {
        Ok(pk) => {
            let result = pubkey_to_address(&pk);
            output_bytes.copy_from_slice(&result);
            ECDSA_RECOVER_SUCCESS
        }
        Err(code) => code,
    }
}

/// Convert big-endian bytes to little-endian u64 limbs (32 bytes -> [u64; 4])
fn bytes_be_to_u64_le(bytes: &[u8; 32]) -> [u64; 4] {
    let mut result = [0u64; 4];
    for i in 0..4 {
        for j in 0..8 {
            result[3 - i] |= (bytes[i * 8 + j] as u64) << (8 * (7 - j));
        }
    }
    result
}

fn u64_le_to_bytes_be(limbs: &[u64; 4]) -> [u8; 32] {
    let mut result = [0u8; 32];
    for i in 0..4 {
        for j in 0..8 {
            result[i * 8 + j] = ((limbs[3 - i] >> (8 * (7 - j))) & 0xff) as u8;
        }
    }
    result
}

fn pubkey_to_address(pk: &[u64; 8]) -> [u8; 32] {
    let x = [pk[0], pk[1], pk[2], pk[3]];
    let y = [pk[4], pk[5], pk[6], pk[7]];

    let x_bytes = u64_le_to_bytes_be(&x);
    let y_bytes = u64_le_to_bytes_be(&y);

    // Concatenate x and y
    let mut pk_bytes = [0u8; 64];
    pk_bytes[0..32].copy_from_slice(&x_bytes);
    pk_bytes[32..64].copy_from_slice(&y_bytes);

    // Hash with keccak256
    let mut hasher = Keccak::v256();
    hasher.update(&pk_bytes);
    let mut hash = [0u8; 32];
    hasher.finalize(&mut hash);

    // Ethereum address is last 20 bytes
    let mut result = [0u8; 32];
    result[12..32].copy_from_slice(&hash[12..32]);

    result
}

#[cfg(test)]
mod tests {
    use super::super::constants::{G, G_X, N, P};
    use super::*;

    fn signature_for_private_key_and_nonce_one() -> ([u64; 4], [u64; 4], [u64; 4]) {
        let z = [1, 0, 0, 0];
        let r = G_X;
        let mut s = r;
        s[0] += 1;
        (z, r, s)
    }

    fn verify(pk: &[u64; 8], z: &[u64; 4], r: &[u64; 4], s: &[u64; 4]) -> bool {
        #[cfg(feature = "hints")]
        let mut hints = Vec::new();
        secp256k1_ecdsa_verify(
            pk,
            z,
            r,
            s,
            #[cfg(feature = "hints")]
            &mut hints,
        )
    }

    fn recover(r: &[u64; 4], s: &[u64; 4], z: &[u64; 4], recid: u8) -> Result<[u64; 8], u8> {
        #[cfg(feature = "hints")]
        let mut hints = Vec::new();
        secp256k1_ecdsa_recover(
            r,
            s,
            z,
            recid,
            #[cfg(feature = "hints")]
            &mut hints,
        )
    }

    fn lift(x: &[u64; 4], odd: bool) -> Result<[u64; 8], bool> {
        #[cfg(feature = "hints")]
        let mut hints = Vec::new();
        secp256k1_lift_x(
            x,
            odd,
            #[cfg(feature = "hints")]
            &mut hints,
        )
    }

    #[test]
    fn verifies_and_recovers_known_algebraic_vector() {
        let (z, r, s) = signature_for_private_key_and_nonce_one();
        assert!(verify(&G, &z, &r, &s));
        assert_eq!(recover(&r, &s, &z, 0), Ok(G));
    }

    #[test]
    fn rejects_noncanonical_signature_and_public_key_inputs() {
        let (z, r, s) = signature_for_private_key_and_nonce_one();
        let zero = [0u64; 4];
        let mut n_plus_one = N;
        n_plus_one[0] += 1;

        assert!(!verify(&G, &z, &zero, &s));
        assert!(!verify(&G, &z, &N, &s));
        assert!(!verify(&G, &z, &n_plus_one, &s));
        assert!(!verify(&G, &z, &r, &zero));
        assert!(!verify(&G, &z, &r, &N));
        assert!(!verify(&G, &z, &r, &n_plus_one));
        assert!(!verify(&[0; 8], &z, &r, &s));

        let mut noncanonical_pk = G;
        noncanonical_pk[0..4].copy_from_slice(&P);
        assert!(!verify(&noncanonical_pk, &z, &r, &s));

        let mut noncanonical_y = G;
        noncanonical_y[4..8].copy_from_slice(&P);
        assert!(!verify(&noncanonical_y, &z, &r, &s));

        let mut equivalent_x = lift(&[1, 0, 0, 0], false).unwrap();
        let mut p_plus_one = P;
        p_plus_one[0] += 1;
        equivalent_x[0..4].copy_from_slice(&p_plus_one);
        assert!(!verify(&equivalent_x, &z, &r, &s));

        assert_eq!(recover(&zero, &s, &z, 0), Err(ECDSA_RECOVER_ERR_INVALID_R));
        assert_eq!(recover(&r, &zero, &z, 0), Err(ECDSA_RECOVER_ERR_INVALID_S));
    }

    fn sub(a: &[u64; 4], b: &[u64; 4]) -> [u64; 4] {
        let mut out = [0u64; 4];
        let mut borrow = false;
        for i in 0..4 {
            let (d, b1) = a[i].overflowing_sub(b[i]);
            let (d, b2) = d.overflowing_sub(borrow as u64);
            out[i] = d;
            borrow = b1 || b2;
        }
        assert!(!borrow);
        out
    }

    fn bind(
        a: &[u64; 4],
        b: &[u64; 4],
        c: &[u64; 4],
        p: &[u64; 8],
        q: &[u64; 8],
    ) -> Option<[u64; 8]> {
        #[cfg(feature = "hints")]
        let mut hints = Vec::new();
        secp256k1_bind_hinted_point(
            a,
            b,
            c,
            p,
            q,
            #[cfg(feature = "hints")]
            &mut hints,
        )
    }

    #[test]
    fn rejects_point_hints_that_would_invalidate_a_signature() {
        // With private key 1 and nonce 1, R = G satisfies [z]G + [r]PK + [-s]R == 𝒪
        let (z, r, s) = signature_for_private_key_and_nonce_one();
        let neg_s = sub(&N, &s);
        assert_eq!(bind(&z, &r, &neg_s, &G, &G), Some(G));

        // Another point or the identity must abort the proof instead of yielding `false`
        let mut neg_g = G;
        neg_g[4..8].copy_from_slice(&sub(&P, &G[4..8].try_into().unwrap()));
        assert!(std::panic::catch_unwind(|| bind(&z, &r, &neg_s, &G, &neg_g)).is_err());
        assert!(std::panic::catch_unwind(|| bind(&z, &r, &neg_s, &G, &IDENTITY)).is_err());

        // When [z]G + [r]PK == 𝒪, R is the identity and the signature is invalid
        let z_cancel = sub(&N, &r);
        assert_eq!(bind(&z_cancel, &r, &neg_s, &G, &IDENTITY), None);
        assert!(!verify(&G, &z_cancel, &r, &s));
    }

    #[test]
    fn handles_scalars_whose_top_bit_is_bit_zero() {
        // With z = 0, r = 1 and s = n - 1 every scalar of the checked relations is at most 1
        let (zero, one) = ([0u64; 4], [1u64, 0, 0, 0]);
        let n_minus_one = sub(&N, &one);
        assert!(!verify(&G, &zero, &one, &n_minus_one));

        // The recovered key is [s/r]R = -R for R = (1, y)
        let r_point = lift(&one, false).unwrap();
        let mut neg_r_point = r_point;
        neg_r_point[4..8].copy_from_slice(&sub(&P, &r_point[4..8].try_into().unwrap()));
        assert_eq!(recover(&one, &n_minus_one, &zero, 0), Ok(neg_r_point));
    }
}
