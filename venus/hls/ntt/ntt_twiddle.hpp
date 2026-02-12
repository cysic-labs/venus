// NTT Twiddle Factor Management for AMD FPGA (Vitis HLS)
//
// Provides twiddle factor computation and ROM-based lookup for the
// on-chip butterfly stages.  Matches the GPU twiddle indexing:
//   twiddles[k * (2^maxLogN >> (stage + 1))]
//
// Reference: ntt_goldilocks.cu eval_twiddle_factors, omegas[], omegas_inv[]

#ifndef VENUS_NTT_TWIDDLE_HPP
#define VENUS_NTT_TWIDDLE_HPP

#include "../goldilocks/gl64_t.hpp"
#include "../goldilocks/gl64_constants.hpp"
#include "ntt_config.hpp"

// Compute omega^exp mod p using square-and-multiply.
// Used at init time to fill twiddle tables.
inline gl64_t gl64_pow(gl64_t base, uint64_t exp) {
    #pragma HLS INLINE off
    gl64_t result = gl64_t::one();
    while (exp > 0) {
        #pragma HLS PIPELINE off
        if (exp & 1) {
            result = result * base;
        }
        base = base * base;
        exp >>= 1;
    }
    return result;
}

// Fill a twiddle factor table for a given domain size.
// Table has domain_size/2 entries:
//   fwd[i] = omega^i  (for i = 0 .. domain_size/2 - 1)
//   inv[i] = omega_inv^i
// where omega = root_of_unity(log_domain_size).
//
// The GPU accesses this table with stride:
//   twiddle_for_stage_s_butterfly_k = table[k * (domain_size >> (s+1))]
//
// For on-chip use, we extract just the subset needed for BATCH_LOG stages.
inline void ntt_fill_twiddle_table(
    gl64_t fwd_table[],
    gl64_t inv_table[],
    unsigned int log_domain_size
) {
    #pragma HLS INLINE off

    uint64_t half_n = 1ULL << (log_domain_size - 1);
    gl64_t omega = gl64_root_of_unity(log_domain_size);
    gl64_t omega_inv = omega.reciprocal();

    fwd_table[0] = gl64_t::one();
    inv_table[0] = gl64_t::one();

    for (uint64_t i = 1; i < half_n; i++) {
        fwd_table[i] = fwd_table[i - 1] * omega;
        inv_table[i] = inv_table[i - 1] * omega_inv;
    }
}

// Extract twiddle factors for a single on-chip butterfly stage.
//
// For global stage `global_stage` within an NTT of size 2^log_n:
// The butterfly at position k (0 <= k < group_size) uses:
//   twiddle = master_table[k * (2^(log_n - 1) >> global_stage)]
//         = master_table[k << (log_n - 1 - global_stage)]
//
// For the local batch, we need at most 2^(local_stage) twiddle values.
// local_stage = global_stage - base_step, where base_step = pass * BATCH_LOG.
//
// The batch_id determines which subset of twiddles to use (the "group offset").
inline gl64_t ntt_get_twiddle(
    const gl64_t master_table[],
    unsigned int log_n,
    unsigned int global_stage,
    unsigned int butterfly_k
) {
    #pragma HLS INLINE
    uint64_t stride = 1ULL << (log_n - 1 - global_stage);
    return master_table[butterfly_k * stride];
}

// Compute a single twiddle factor on-the-fly (no table lookup).
// twiddle = omega^(k * 2^(log_n - 1 - stage))
// Useful when the master table doesn't fit on-chip.
inline gl64_t ntt_compute_twiddle(
    unsigned int log_n,
    unsigned int global_stage,
    unsigned int butterfly_k,
    bool inverse
) {
    #pragma HLS INLINE off
    gl64_t omega = inverse
        ? gl64_root_of_unity(log_n).reciprocal()
        : gl64_root_of_unity(log_n);
    uint64_t exp = (uint64_t)butterfly_k << (log_n - 1 - global_stage);
    return gl64_pow(omega, exp);
}

// Fill the LDE shift factor table: r[i] = shift^i mod p
// where shift = 7 (the multiplicative generator).
// Used in INTT with extend=true.
//
// Reference: ntt_goldilocks.cu eval_r, ntt_goldilocks.hpp computeR
inline void ntt_fill_r_table(
    gl64_t r_table[],
    unsigned int log_domain_size
) {
    #pragma HLS INLINE off
    uint64_t n = 1ULL << log_domain_size;
    gl64_t shift = gl64_shift();
    r_table[0] = gl64_t::one();
    for (uint64_t i = 1; i < n; i++) {
        r_table[i] = r_table[i - 1] * shift;
    }
}

// Domain size inverse table: inv_n[k] = (2^k)^(-1) mod p
// Used in INTT final scaling.
inline gl64_t ntt_domain_size_inverse(unsigned int log_n) {
    #pragma HLS INLINE
    gl64_t n(1ULL << log_n);
    return n.reciprocal();
}

#endif // VENUS_NTT_TWIDDLE_HPP
