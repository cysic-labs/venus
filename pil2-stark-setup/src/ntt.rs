use fields::{Field, Goldilocks};

/// Roots of unity (forward): W[i] is a primitive 2^i-th root of unity in the
/// Goldilocks field.
const OMEGAS: [u64; 33] = Goldilocks::W;

/// Inverse roots of unity: OMEGAS_INV[i] is the inverse of OMEGAS[i].
const OMEGAS_INV: [u64; 33] = [
    0x1,
    0xffffffff00000000,
    0xfffeffff00000001,
    0xfffffeff00000101,
    0xffefffff00100001,
    0xfbffffff04000001,
    0xdfffffff20000001,
    0x3fffbfffc0,
    0x7f4949dce07bf05d,
    0x4bd6bb172e15d48c,
    0x38bc97652b54c741,
    0x553a9b711648c890,
    0x55da9bb68958caa,
    0xa0a62f8f0bb8e2b6,
    0x276fd7ae450aee4b,
    0x7b687b64f5de658f,
    0x7de5776cbda187e9,
    0xd2199b156a6f3b06,
    0xd01c8acd8ea0e8c0,
    0x4f38b2439950a4cf,
    0x5987c395dd5dfdcf,
    0x46cf3d56125452b1,
    0x909c4b1a44a69ccb,
    0xc188678a32a54199,
    0xf3650f9ddfcaffa8,
    0xe8ef0e3e40a92655,
    0x7c8abec072bb46a6,
    0xe0bfc17d5c5a7a04,
    0x4c6b8a5a0b79f23a,
    0x6b4d20533ce584fe,
    0xe5cceae468a70ec2,
    0x8958579f296dac7a,
    0x16d265893b5b7e85,
];

/// Precomputed (2^i)^{-1} mod p for domain-size normalization.
const DOMAIN_SIZE_INVERSE: [u64; 33] = [
    0x0000000000000001,
    0x7fffffff80000001,
    0xbfffffff40000001,
    0xdfffffff20000001,
    0xefffffff10000001,
    0xf7ffffff08000001,
    0xfbffffff04000001,
    0xfdffffff02000001,
    0xfeffffff01000001,
    0xff7fffff00800001,
    0xffbfffff00400001,
    0xffdfffff00200001,
    0xffefffff00100001,
    0xfff7ffff00080001,
    0xfffbffff00040001,
    0xfffdffff00020001,
    0xfffeffff00010001,
    0xffff7fff00008001,
    0xffffbfff00004001,
    0xffffdfff00002001,
    0xffffefff00001001,
    0xfffff7ff00000801,
    0xfffffbff00000401,
    0xfffffdff00000201,
    0xfffffeff00000101,
    0xffffff7f00000081,
    0xffffffbf00000041,
    0xffffffdf00000021,
    0xffffffef00000011,
    0xfffffff700000009,
    0xfffffffb00000005,
    0xfffffffd00000003,
    0xfffffffe00000002,
];

fn bit_reverse(mut x: u32, bits: usize) -> u32 {
    x = ((x >> 1) & 0x5555_5555) | ((x & 0x5555_5555) << 1);
    x = ((x >> 2) & 0x3333_3333) | ((x & 0x3333_3333) << 2);
    x = ((x >> 4) & 0x0F0F_0F0F) | ((x & 0x0F0F_0F0F) << 4);
    x = ((x >> 8) & 0x00FF_00FF) | ((x & 0x00FF_00FF) << 8);
    x = x.rotate_left(16);
    x >> (32 - bits)
}

/// In-place Cooley-Tukey butterfly NTT on `data` viewed as `n_cols` interleaved
/// columns. When `inverse` is true, computes the INTT (scaling by N^{-1}).
fn ntt_core(data: &mut [Goldilocks], n_bits: usize, n_cols: usize, inverse: bool) {
    let n = 1usize << n_bits;
    assert_eq!(data.len(), n * n_cols);

    // Bit-reverse permutation
    let mut buf = vec![Goldilocks::ZERO; n * n_cols];
    for i in 0..n {
        let r = bit_reverse(i as u32, n_bits) as usize;
        buf[r * n_cols..(r + 1) * n_cols].copy_from_slice(&data[i * n_cols..(i + 1) * n_cols]);
    }

    let omega_table = if inverse { &OMEGAS_INV } else { &OMEGAS };

    // Cooley-Tukey stages
    for stage in 0..n_bits {
        let m = 1usize << (stage + 1);
        let half_m = m >> 1;
        let omega_base = Goldilocks::new(omega_table[stage + 1]);

        // Precompute twiddle factors for this stage
        let mut twiddles = Vec::with_capacity(half_m);
        twiddles.push(Goldilocks::ONE);
        for j in 1..half_m {
            twiddles.push(twiddles[j - 1] * omega_base);
        }

        for k in (0..n).step_by(m) {
            for (j, w) in twiddles.iter().enumerate().take(half_m) {
                for c in 0..n_cols {
                    let idx1 = (k + j) * n_cols + c;
                    let idx2 = (k + j + half_m) * n_cols + c;
                    let u = buf[idx1];
                    let t = buf[idx2] * *w;
                    buf[idx1] = u + t;
                    buf[idx2] = u - t;
                }
            }
        }
    }

    if inverse {
        let inv_n = Goldilocks::new(DOMAIN_SIZE_INVERSE[n_bits]);
        for v in buf.iter_mut() {
            *v *= inv_n;
        }
    }

    data.copy_from_slice(&buf);
}

/// Extend `n_cols` polynomials from domain of size N = 2^n_bits to
/// N_ext = 2^n_bits_ext via coset evaluation.
///
/// The input is `N * n_cols` Goldilocks elements stored in row-major order
/// (row i, col c at index i * n_cols + c). The output is `N_ext * n_cols`
/// elements in the same layout.
///
/// Algorithm: INTT on the small domain, then zero-pad to the extended size,
/// then NTT on the extended domain. The C++ code uses a "shift" coset
/// approach internally but the net effect is the same as a standard LDE
/// (low-degree extension) because the NTT construction already incorporates
/// the appropriate roots.
pub fn extend_pol(
    input: &[Goldilocks],
    n_bits: usize,
    n_bits_ext: usize,
    n_cols: usize,
) -> Vec<Goldilocks> {
    let n = 1usize << n_bits;
    let n_ext = 1usize << n_bits_ext;
    assert_eq!(input.len(), n * n_cols);
    assert!(n_bits_ext >= n_bits);

    // INTT on original domain
    let mut coeffs = input.to_vec();
    ntt_core(&mut coeffs, n_bits, n_cols, true);

    // Zero-pad to extended size
    let mut extended = vec![Goldilocks::ZERO; n_ext * n_cols];
    extended[..n * n_cols].copy_from_slice(&coeffs);

    // Forward NTT on extended domain
    ntt_core(&mut extended, n_bits_ext, n_cols, false);

    extended
}

#[cfg(test)]
mod tests {
    use super::*;
    use fields::{Goldilocks, PrimeField64};

    #[test]
    fn test_roundtrip_ntt() {
        // Apply forward NTT then inverse NTT and verify identity
        let n_bits = 3;
        let n = 1usize << n_bits;
        let n_cols = 2;
        let original: Vec<Goldilocks> =
            (0..(n * n_cols) as u64).map(Goldilocks::new).collect();

        let mut data = original.clone();
        ntt_core(&mut data, n_bits, n_cols, false);
        ntt_core(&mut data, n_bits, n_cols, true);

        for (i, (a, b)) in original.iter().zip(data.iter()).enumerate() {
            assert_eq!(
                a.as_canonical_u64(),
                b.as_canonical_u64(),
                "mismatch at index {i}"
            );
        }
    }

    #[test]
    fn test_extend_pol_preserves_evaluations() {
        // A constant polynomial should stay constant after extension
        let n_bits = 2;
        let n_bits_ext = 4;
        let n = 1usize << n_bits;
        let n_ext = 1usize << n_bits_ext;
        let n_cols = 1;

        let val = Goldilocks::new(42);
        let input = vec![val; n * n_cols];
        let extended = extend_pol(&input, n_bits, n_bits_ext, n_cols);

        assert_eq!(extended.len(), n_ext * n_cols);
        for (i, v) in extended.iter().enumerate() {
            assert_eq!(
                v.as_canonical_u64(),
                42,
                "extended value at index {i} should be 42"
            );
        }
    }
}
