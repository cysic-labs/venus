#[cfg(all(not(all(target_os = "zkvm", target_vendor = "zisk")), zisk_hints_debug))]
use std::os::raw::c_char;

#[cfg(all(target_os = "zkvm", target_vendor = "zisk"))]
extern "C" {
    pub fn sha256_c(input: *const u8, input_len: usize, output: *mut u8);

    pub fn bn254_g1_add_c(p1: *const u8, p2: *const u8, ret: *mut u8) -> u8;

    pub fn bn254_g1_mul_c(point: *const u8, scalar: *const u8, ret: *mut u8) -> u8;

    pub fn bn254_pairing_check_c(pairs: *const u8, num_pairs: usize) -> u8;

    pub fn secp256k1_ecdsa_verify_and_address_recover_c(
        sig: *const u8,
        msg: *const u8,
        pk: *const u8,
        output: *mut u8,
    ) -> u8;

    pub fn secp256k1_ecdsa_address_recover_c(
        sig: *const u8,
        recid: u8,
        msg: *const u8,
        output: *mut u8,
    ) -> u8;

    pub fn modexp_bytes_c(
        base_ptr: *const u8,
        base_len: usize,
        exp_ptr: *const u8,
        exp_len: usize,
        modulus_ptr: *const u8,
        modulus_len: usize,
        ret_ptr: *mut u8,
    ) -> usize;

    pub fn blake2b_compress_c(rounds: u32, h: *mut u64, m: *const u64, t: *const u64, f: u8);

    pub fn secp256r1_ecdsa_verify_c(msg: *const u8, sig: *const u8, pk: *const u8) -> bool;

    pub fn verify_kzg_proof_c(
        z: *const u8,
        y: *const u8,
        commitment: *const u8,
        proof: *const u8,
    ) -> bool;

    pub fn bls12_381_g1_add_c(ret: *mut u8, a: *const u8, b: *const u8) -> u8;

    pub fn bls12_381_g1_msm_c(ret: *mut u8, pairs: *const u8, num_pairs: usize) -> u8;

    pub fn bls12_381_g2_add_c(ret: *mut u8, a: *const u8, b: *const u8) -> u8;

    pub fn bls12_381_g2_msm_c(ret: *mut u8, pairs: *const u8, num_pairs: usize) -> u8;

    pub fn bls12_381_pairing_check_c(pairs: *const u8, num_pairs: usize) -> u8;

    pub fn bls12_381_fp_to_g1_c(ret: *mut u8, fp: *const u8) -> u8;

    pub fn bls12_381_fp2_to_g2_c(ret: *mut u8, fp2: *const u8) -> u8;
}

#[cfg(all(not(all(target_os = "zkvm", target_vendor = "zisk")), zisk_hints))]
extern "C" {
    pub fn hint_sha256(f: *const u8, len: usize);

    pub fn hint_bn254_g1_add(p1: *const u8, p2: *const u8);

    pub fn hint_bn254_g1_mul(point: *const u8, scalar: *const u8);

    pub fn hint_bls12_381_g1_add(a: *const u8, b: *const u8);

    pub fn hint_bls12_381_g2_add(a: *const u8, b: *const u8);

    pub fn hint_secp256k1_ecdsa_verify_and_address_recover(
        sig: *const u8,
        msg: *const u8,
        pk: *const u8,
    );

    pub fn hint_secp256k1_ecdsa_address_recover(sig: *const u8, recid: *const u8, msg: *const u8);

    pub fn hint_modexp_bytes(
        base_ptr: *const u8,
        base_len: usize,
        exp_ptr: *const u8,
        exp_len: usize,
        modulus_ptr: *const u8,
        modulus_len: usize,
    );

    pub fn hint_blake2b_compress(rounds: u32, h: *mut u64, m: *const u64, t: *const u64, f: u8);

    pub fn hint_secp256r1_ecdsa_verify(msg: *const u8, sig: *const u8, pk: *const u8);

    pub fn hint_verify_kzg_proof(
        z: *const u8,
        y: *const u8,
        commitment: *const u8,
        proof: *const u8,
    );

    pub fn hint_bn254_pairing_check(pairs: *const u8, num_pairs: usize);

    pub fn hint_bls12_381_g1_msm(pairs: *const u8, num_pairs: usize);

    pub fn hint_bls12_381_g2_msm(pairs: *const u8, num_pairs: usize);

    pub fn hint_bls12_381_pairing_check(pairs: *const u8, num_pairs: usize);

    pub fn hint_bls12_381_fp_to_g1(fp: *const u8);

    pub fn hint_bls12_381_fp2_to_g2(fp2: *const u8);

    pub fn pause_hints() -> bool;

    pub fn resume_hints();
}

#[cfg(all(not(all(target_os = "zkvm", target_vendor = "zisk")), zisk_hints_debug))]
extern "C" {
    pub fn hint_log_c(msg: *const c_char);
}
