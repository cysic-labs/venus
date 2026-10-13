use crate::syscalls::{
    syscall_add256, syscall_arith256, SyscallAdd256Params, SyscallArith256Params,
};

use super::{rem_long, LongScratch, U256};

/// Squares a large number: out = a²
///
/// # Assumptions
/// - `len(a) > 0`
/// - `a` has no leading zeros
/// - `out` has at least `2 * len(a)` limbs
///
/// # Returns
/// The number of limbs in the result
///
/// # Note
/// Not optimal for `len(a) == 1`, use `square_short` instead
pub fn square_long(
    a: &[U256],
    out: &mut [U256],
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> usize {
    //                                        a3    a2    a1      a0
    //                                      * a3    a2    a1      a0
    //         ------------------------------------------------------- 0
    //                               Y       2*a0*a2   2*a0*a1  a0*a0
    //         ------------------------------------------------------- 1
    //               2*a1*a3+Z    2*a1*a2     a1*a1        X      0
    //         ------------------------------------------------------- 2
    //  Z   Y     2*a2*a3   a2*a2        X      X          0      0
    //         ------------------------------------------------------- 3
    //    a3*a3     X        X          X           0      0      0
    //         ------------------------------------------------------- 4
    //                          RESULT

    let len_a = a.len();
    #[cfg(debug_assertions)]
    {
        assert_ne!(len_a, 0, "Input 'a' must have at least one limb");
        if len_a > 1 {
            assert!(!a[len_a - 1].is_zero(), "Input 'a' must not have leading zeros");
        }
    }

    // Step 1: Compute all diagonal terms a[i] * a[i]
    for i in 0..len_a {
        // Compute the diagonal:
        //      a[i]·a[i] = dh·B + dl
        // and set out[2 * i] = dl and out[2 * i + 1] = dh
        let mut ai_ai = SyscallArith256Params {
            a: a[i].as_limbs(),
            b: a[i].as_limbs(),
            c: U256::ZERO.as_limbs(),
            dl: out[2 * i].as_limbs_mut(),
            dh: &mut [0, 0, 0, 0],
        };
        syscall_arith256(
            &mut ai_ai,
            #[cfg(feature = "hints")]
            hints,
        );

        out[2 * i + 1] = U256::from_u64s(ai_ai.dh);
    }

    // Step 2: Compute all cross terms 2·a[i]·a[j] for i < j
    for i in 0..len_a {
        for j in (i + 1)..len_a {
            // First compute a[i]·a[j] = h₁·B + l₁
            let mut ai_aj = SyscallArith256Params {
                a: a[i].as_limbs(),
                b: a[j].as_limbs(),
                c: U256::ZERO.as_limbs(),
                dl: &mut [0, 0, 0, 0],
                dh: &mut [0, 0, 0, 0],
            };
            syscall_arith256(
                &mut ai_aj,
                #[cfg(feature = "hints")]
                hints,
            );

            // Double the result 2·a[i]·a[j] = high·B² + mid·B + low, with high ∈ {0, 1}

            // Start by doubling the lower chunk: 2·l₁ = [1/0]·B + low
            let mut low_chunk: [u64; 4] = [0, 0, 0, 0];
            let mut dbl_low =
                SyscallAdd256Params { a: ai_aj.dl, b: ai_aj.dl, cin: 0, c: &mut low_chunk };
            let carry = syscall_add256(
                &mut dbl_low,
                #[cfg(feature = "hints")]
                hints,
            );

            // Next, double the higher chunk with the carry: 2·h₁ + [1/0] = high·B + mid
            let mut mid_chunk: [u64; 4] = [0, 0, 0, 0];
            let mut dbl_high =
                SyscallAdd256Params { a: ai_aj.dh, b: ai_aj.dh, cin: carry, c: &mut mid_chunk };
            let high_chunk = syscall_add256(
                &mut dbl_high,
                #[cfg(feature = "hints")]
                hints,
            );

            // Accumulate the chunks into out[i+j], out[i+j+1] and out[i+j+2], chaining the carries
            let k = i + j;
            let chunks = [low_chunk, mid_chunk, [high_chunk, 0, 0, 0]];
            let mut carry = 0;
            for (offset, chunk) in chunks.iter().enumerate() {
                let mut add = SyscallAdd256Params {
                    a: out[k + offset].as_limbs(),
                    b: chunk,
                    cin: carry,
                    c: &mut [0, 0, 0, 0],
                };
                carry = syscall_add256(
                    &mut add,
                    #[cfg(feature = "hints")]
                    hints,
                );
                out[k + offset] = U256::from_u64s(add.c);
            }

            // Propagate any remaining carry; the partial sum never exceeds a², so it stays in bounds
            let mut idx = k + 3;
            while carry != 0 {
                let mut add = SyscallAdd256Params {
                    a: out[idx].as_limbs(),
                    b: U256::ZERO.as_limbs(),
                    cin: carry,
                    c: &mut [0, 0, 0, 0],
                };
                carry = syscall_add256(
                    &mut add,
                    #[cfg(feature = "hints")]
                    hints,
                );
                out[idx] = U256::from_u64s(add.c);
                idx += 1;
            }
        }
    }

    if out[2 * len_a - 1].is_zero() {
        2 * len_a - 1
    } else {
        2 * len_a
    }
}

/// Squares a large number and reduces modulo a large modulus
///
/// # Assumptions
/// - `len(modulus) > 0`
/// - `modulus > 0`
/// - `modulus` has no leading zeros
///
/// # Returns
/// The remainder: a² mod modulus
pub fn square_and_reduce_long(
    a: &[U256],
    modulus: &[U256],
    scratch: &mut LongScratch,
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> Vec<U256> {
    #[cfg(debug_assertions)]
    {
        let len_m = modulus.len();
        assert_ne!(len_m, 0, "Input 'modulus' must have at least one limb");
        assert!(!modulus[len_m - 1].is_zero(), "Input 'modulus' must not have leading zeros");
    }

    let sq_len = square_long(
        a,
        &mut scratch.mul,
        #[cfg(feature = "hints")]
        hints,
    );

    rem_long(
        &scratch.mul[..sq_len],
        modulus,
        &mut scratch.rem,
        #[cfg(feature = "hints")]
        hints,
    )
}
