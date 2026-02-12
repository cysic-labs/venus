// FRI Polynomial Folding for AMD FPGA (Vitis HLS)
//
// Implements the FRI folding step: given polynomial evaluations of degree N
// and a verifier challenge, produce folded evaluations of degree N/ratio.
//
// Algorithm (matching GPU fold / fold_v2 in starks_gpu.cu):
//   For each output element id in [0, sizeFoldedPol):
//     1. Gather: ppar[j] = friPol[(j * sizeFoldedPol + id) * 3 + k]
//                for j in [0, ratio), k in [0,3)
//     2. Tiny INTT of size 'ratio' on ppar (converts evals -> coefficients)
//     3. Shift: sinv = invShift * invW^id
//               multiply ppar[i] *= sinv^i   (polMulAxi)
//     4. Horner: result = ppar[ratio-1]
//               for i = ratio-2 downto 0: result = result * challenge + ppar[i]
//     5. Store: output[id * 3 + k] = result[k]
//
// Reference:
//   pil2-proofman/pil2-stark/src/starkpil/starks_gpu.cu
//     fold(), fold_v2(), intt_tinny()
//   pil2-proofman/pil2-stark/src/starkpil/fri/fri.hpp
//     FRI<T>::fold(), polMulAxi(), evalPol()

#ifndef VENUS_FRI_FOLD_HPP
#define VENUS_FRI_FOLD_HPP

#include "fri_config.hpp"

// ---- Bit-reverse a value within `bits` width ----
static inline unsigned int fri_bit_reverse(unsigned int v, unsigned int bits) {
    #pragma HLS INLINE
    unsigned int r = 0;
    for (unsigned int i = 0; i < FRI_MAX_LOG_RATIO; i++) {
        #pragma HLS UNROLL
        if (i < bits) {
            r |= ((v >> i) & 1) << (bits - 1 - i);
        }
    }
    return r;
}

// ---- Tiny INTT (inverse NTT of small size) ----
// In-place DIT INTT matching the GPU's intt_tinny() exactly:
//   1. Bit-reversal permutation
//   2. Butterfly stages with omega_inv twiddles
//   3. N^{-1} scaling
//
// Each element is a cubic extension (3 base field components) stored
// as gl64_3_t.  The twiddles[] array holds omega_inv^i for the small domain.
//
// Reference: starks_gpu.cu intt_tinny(), lines 563-607
template <int MAX_RATIO>
static void fri_intt_tiny(
    gl64_3_t ppar[MAX_RATIO],
    unsigned int ratio,
    unsigned int logRatio,
    const gl64_t twiddles[MAX_RATIO / 2]
) {
    #pragma HLS INLINE off

    // Step 1: Bit-reversal permutation
    BIT_REV:
    for (unsigned int i = 0; i < MAX_RATIO; i++) {
        #pragma HLS LOOP_TRIPCOUNT min=2 max=MAX_RATIO
        if (i >= ratio) break;
        unsigned int ibr = fri_bit_reverse(i, logRatio);
        if (ibr > i) {
            gl64_3_t tmp = ppar[i];
            ppar[i] = ppar[ibr];
            ppar[ibr] = tmp;
        }
    }

    // Step 2: DIT butterfly stages
    // Matches GPU: for each stage i, half_group_size = 1 << i
    BUTTERFLY_STAGES:
    for (unsigned int stage = 0; stage < FRI_MAX_LOG_RATIO; stage++) {
        #pragma HLS LOOP_TRIPCOUNT min=1 max=FRI_MAX_LOG_RATIO
        if (stage >= logRatio) break;

        unsigned int half_group_size = 1u << stage;
        unsigned int tw_stride = ratio >> (stage + 1);

        BUTTERFLY_PAIRS:
        for (unsigned int j = 0; j < MAX_RATIO / 2; j++) {
            #pragma HLS PIPELINE II=1
            #pragma HLS LOOP_TRIPCOUNT min=1 max=MAX_RATIO/2
            if (j >= (ratio >> 1)) break;

            // GPU addressing: group = j >> i, offset = j & (half_group_size - 1)
            unsigned int group = j >> stage;
            unsigned int offset = j & (half_group_size - 1);
            unsigned int index1 = (group << (stage + 1)) + offset;
            unsigned int index2 = index1 + half_group_size;

            // Twiddle: twiddles[offset * (N >> (stage+1))]
            gl64_t factor = twiddles[offset * tw_stride];

            // DIT INTT butterfly:
            //   odd_sub = data[index2] * factor
            //   data[index2] = data[index1] - odd_sub
            //   data[index1] = data[index1] + odd_sub
            gl64_3_t odd_sub = ppar[index2] * factor;
            gl64_3_t even = ppar[index1];
            ppar[index2] = even - odd_sub;
            ppar[index1] = even + odd_sub;
        }
    }

    // Step 3: Scale by N^{-1}
    gl64_t inv_ratio = fri_domain_inv(logRatio);
    SCALE_INV:
    for (unsigned int i = 0; i < MAX_RATIO; i++) {
        #pragma HLS PIPELINE II=1
        #pragma HLS LOOP_TRIPCOUNT min=2 max=MAX_RATIO
        if (i >= ratio) break;
        ppar[i] = ppar[i] * inv_ratio;
    }
}

// ---- Compute twiddle factors for small INTT ----
// twiddles[i] = omega_inv^i for i in [0, halfRatio)
// omega_inv is the inverse of the primitive 2^logRatio-th root of unity.
//
// Reference: GPU fold() shared memory setup, lines 614-620
template <int MAX_HALF>
static void fri_compute_twiddles(
    gl64_t twiddles[MAX_HALF],
    gl64_t omega_inv,
    unsigned int halfRatio
) {
    #pragma HLS INLINE off
    twiddles[0] = gl64_t::one();
    TWIDDLE_GEN:
    for (unsigned int i = 1; i < MAX_HALF; i++) {
        #pragma HLS PIPELINE II=1
        #pragma HLS LOOP_TRIPCOUNT min=1 max=MAX_HALF
        if (i >= halfRatio) break;
        twiddles[i] = twiddles[i - 1] * omega_inv;
    }
}

// ---- Compute sinv for a given element index ----
// sinv = invShift * invW^id
// Uses binary exponentiation.
//
// Reference: GPU fold() kernel, lines 644-656
static gl64_t fri_compute_sinv(gl64_t invShift, gl64_t invW, unsigned int id) {
    #pragma HLS INLINE off

    gl64_t sinv = invShift;
    gl64_t base = invW;
    unsigned int exp = id;

    BINARY_EXP:
    while (exp > 0) {
        #pragma HLS PIPELINE off
        #pragma HLS LOOP_TRIPCOUNT min=0 max=27
        if (exp & 1) {
            sinv = sinv * base;
        }
        base = base * base;
        exp >>= 1;
    }

    return sinv;
}

// ---- Single FRI fold step ----
// Folds a polynomial from 2^prevBits evaluations to 2^currentBits evaluations.
//
// Parameters:
//   friPol:       input polynomial (cubic extension, AXI-MM)
//                 Layout: friPol[(i * sizeFoldedPol + id) * 3 + k]
//   output:       output folded polynomial (cubic extension, AXI-MM)
//                 Layout: output[id * 3 + k]
//   challenge:    FRI challenge (cubic extension, 3 elements)
//   omega_inv_val: inverse of primitive 2^logRatio-th root of unity
//   invShift:     precomputed (1/shift)^(2^(nBitsExt - prevBits))
//   invW:         precomputed 1/omega(prevBits)
//   prevBits:     log2 of input polynomial size
//   currentBits:  log2 of output polynomial size
template <int MAX_RATIO>
static void fri_fold_step(
    const ap_uint<64>* friPol,
    ap_uint<64>* output,
    const gl64_3_t& challenge,
    gl64_t omega_inv_val,
    gl64_t invShift,
    gl64_t invW,
    unsigned int prevBits,
    unsigned int currentBits
) {
    #pragma HLS INLINE off

    unsigned int ratio = 1u << (prevBits - currentBits);
    unsigned int logRatio = prevBits - currentBits;
    unsigned int sizeFoldedPol = 1u << currentBits;

    // Precompute omega_inv twiddle factors for tiny INTT
    gl64_t twiddles[MAX_RATIO / 2];
    #pragma HLS ARRAY_PARTITION variable=twiddles complete
    fri_compute_twiddles<MAX_RATIO / 2>(twiddles, omega_inv_val, ratio / 2);

    // Process each output element
    FOLD_LOOP:
    for (unsigned int id = 0; id < sizeFoldedPol; id++) {
        #pragma HLS LOOP_TRIPCOUNT min=8 max=1048576

        // 1. Gather: collect 'ratio' cubic extension elements
        gl64_3_t ppar[MAX_RATIO];
        #pragma HLS ARRAY_PARTITION variable=ppar complete

        GATHER:
        for (unsigned int i = 0; i < MAX_RATIO; i++) {
            #pragma HLS PIPELINE II=1
            #pragma HLS LOOP_TRIPCOUNT min=2 max=MAX_RATIO
            if (i >= ratio) break;
            unsigned int base_idx = (i * sizeFoldedPol + id) * FRI_FIELD_EXTENSION;
            ppar[i].v[0] = gl64_t(friPol[base_idx + 0]);
            ppar[i].v[1] = gl64_t(friPol[base_idx + 1]);
            ppar[i].v[2] = gl64_t(friPol[base_idx + 2]);
        }

        // 2. Tiny INTT: convert evaluations to coefficients
        fri_intt_tiny<MAX_RATIO>(ppar, ratio, logRatio, twiddles);

        // 3. polMulAxi: multiply ppar[i] by sinv^i
        //    sinv = invShift * invW^id
        gl64_t sinv = fri_compute_sinv(invShift, invW, id);
        gl64_t r = gl64_t::one();
        POLMULAXI:
        for (unsigned int i = 0; i < MAX_RATIO; i++) {
            #pragma HLS PIPELINE off
            #pragma HLS LOOP_TRIPCOUNT min=2 max=MAX_RATIO
            if (i >= ratio) break;
            ppar[i] = ppar[i] * r;
            r = r * sinv;
        }

        // 4. Horner evaluation at challenge
        gl64_3_t result;
        if (ratio == 0) {
            result = gl64_3_t::zero();
        } else {
            result = ppar[ratio - 1];
            HORNER:
            for (int i = (int)ratio - 2; i >= 0; i--) {
                #pragma HLS PIPELINE off
                #pragma HLS LOOP_TRIPCOUNT min=1 max=MAX_RATIO
                result = result * challenge + ppar[i];
            }
        }

        // 5. Store folded result
        unsigned int out_idx = id * FRI_FIELD_EXTENSION;
        output[out_idx + 0] = result.v[0].val;
        output[out_idx + 1] = result.v[1].val;
        output[out_idx + 2] = result.v[2].val;
    }
}

#endif // VENUS_FRI_FOLD_HPP
