use crate::{
    syscalls::{syscall_arith256_mod, SyscallArith256ModParams},
    zisklib::{fcall_secp256k1_fp_sqrt, lt},
};

use super::constants::{NQR, P};

pub fn secp256k1_fp_add(
    x: &[u64; 4],
    y: &[u64; 4],
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> [u64; 4] {
    // x·1 + y
    let mut params =
        SyscallArith256ModParams { a: x, b: &[1, 0, 0, 0], c: y, module: &P, d: &mut [0, 0, 0, 0] };
    syscall_arith256_mod(
        &mut params,
        #[cfg(feature = "hints")]
        hints,
    );
    *params.d
}

pub fn secp256k1_fp_mul(
    x: &[u64; 4],
    y: &[u64; 4],
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> [u64; 4] {
    // x·y + 0
    let mut params =
        SyscallArith256ModParams { a: x, b: y, c: &[0, 0, 0, 0], module: &P, d: &mut [0, 0, 0, 0] };
    syscall_arith256_mod(
        &mut params,
        #[cfg(feature = "hints")]
        hints,
    );
    *params.d
}

pub fn secp256k1_fp_square(
    x: &[u64; 4],
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> [u64; 4] {
    // x·x + 0
    let mut params =
        SyscallArith256ModParams { a: x, b: x, c: &[0, 0, 0, 0], module: &P, d: &mut [0, 0, 0, 0] };
    syscall_arith256_mod(
        &mut params,
        #[cfg(feature = "hints")]
        hints,
    );
    *params.d
}

pub fn secp256k1_fp_sqrt(
    x: &[u64; 4],
    parity: u64,
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> ([u64; 4], bool) {
    // Hint the sqrt
    let hint = fcall_secp256k1_fp_sqrt(
        x,
        parity,
        #[cfg(feature = "hints")]
        hints,
    );
    secp256k1_validate_fp_sqrt(
        x,
        &hint,
        #[cfg(feature = "hints")]
        hints,
    )
}

fn secp256k1_validate_fp_sqrt(
    x: &[u64; 4],
    hint: &[u64; 5],
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> ([u64; 4], bool) {
    let is_qr = hint[0] == 1;
    let sqrt: [u64; 4] = hint[1..5].try_into().unwrap();

    // A prover controls fcall output. Reject equivalent non-canonical representatives.
    assert!(lt(&sqrt, &P), "secp256k1 sqrt is not canonical");

    // Compute sqrt * sqrt
    let mut params = SyscallArith256ModParams {
        a: &sqrt,
        b: &sqrt,
        c: &[0, 0, 0, 0],
        module: &P,
        d: &mut [0, 0, 0, 0],
    };
    syscall_arith256_mod(
        &mut params,
        #[cfg(feature = "hints")]
        hints,
    );

    if is_qr {
        // Check that sqrt * sqrt == x
        assert_eq!(*params.d, *x);
        (sqrt, true)
    } else {
        // Check that sqrt * sqrt == x * NQR
        let nqr = secp256k1_fp_mul(
            x,
            &NQR,
            #[cfg(feature = "hints")]
            hints,
        );
        assert_eq!(*params.d, nqr);
        (sqrt, false)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn validate_sqrt(x: &[u64; 4], hint: &[u64; 5]) -> ([u64; 4], bool) {
        #[cfg(feature = "hints")]
        let mut hints = Vec::new();
        secp256k1_validate_fp_sqrt(
            x,
            hint,
            #[cfg(feature = "hints")]
            &mut hints,
        )
    }

    #[test]
    fn rejects_noncanonical_sqrt_hint() {
        let mut p_plus_one = P;
        p_plus_one[0] += 1;
        let hint = [1, p_plus_one[0], p_plus_one[1], p_plus_one[2], p_plus_one[3]];
        assert!(std::panic::catch_unwind(|| validate_sqrt(&[1, 0, 0, 0], &hint)).is_err());
    }
}
