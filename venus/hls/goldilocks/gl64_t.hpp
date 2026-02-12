// Goldilocks Prime Field Arithmetic for AMD FPGA (Vitis HLS)
// p = 2^64 - 2^32 + 1 = 0xFFFFFFFF00000001
//
// Reference: pil2-proofman/pil2-stark/src/goldilocks/src/gl64_t.cuh (GPU)
//            pil2-proofman/pil2-stark/src/goldilocks/src/goldilocks_base_field_scalar.hpp (CPU)
//
// All operations produce canonical results in [0, p-1].
// Designed for II=1 pipelining when used inside HLS loops.

#ifndef VENUS_GL64_T_HPP
#define VENUS_GL64_T_HPP

#include <ap_int.h>
#include <cstdint>

// Goldilocks prime constant
static const ap_uint<64> GL64_P = ap_uint<64>(0xFFFFFFFF00000001ULL);

struct gl64_t {
    ap_uint<64> val;

    // ---- Constructors ----
    gl64_t() : val(0) {}
    gl64_t(ap_uint<64> v) : val(v) {}
    gl64_t(uint64_t v) : val(ap_uint<64>(v)) {}

    // ---- Constants ----
    static gl64_t zero() {
        #pragma HLS INLINE
        return gl64_t(ap_uint<64>(0));
    }
    static gl64_t one() {
        #pragma HLS INLINE
        return gl64_t(ap_uint<64>(1));
    }

    // ---- Predicates ----
    bool is_zero() const {
        #pragma HLS INLINE
        return val == 0;
    }
    bool is_one() const {
        #pragma HLS INLINE
        return val == 1;
    }

    // ---- Canonical reduction: ensure val in [0, p-1] ----
    gl64_t to_canonical() const {
        #pragma HLS INLINE
        ap_uint<65> v_ext = ap_uint<65>(val);
        ap_uint<65> diff = v_ext - ap_uint<65>(GL64_P);
        gl64_t r;
        r.val = diff[64] ? val : ap_uint<64>(diff);
        return r;
    }

    // ---- Modular Addition ----
    // Inputs must be in [0, p-1]. Result in [0, p-1].
    gl64_t operator+(const gl64_t& b) const {
        #pragma HLS INLINE
        ap_uint<65> sum = ap_uint<65>(val) + ap_uint<65>(b.val);
        ap_uint<65> sum_minus_p = sum - ap_uint<65>(GL64_P);
        gl64_t r;
        r.val = sum_minus_p[64] ? ap_uint<64>(sum) : ap_uint<64>(sum_minus_p);
        return r;
    }

    // ---- Modular Subtraction ----
    // Inputs must be in [0, p-1]. Result in [0, p-1].
    gl64_t operator-(const gl64_t& b) const {
        #pragma HLS INLINE
        ap_uint<65> diff = ap_uint<65>(val) - ap_uint<65>(b.val);
        gl64_t r;
        // If underflow (diff negative as unsigned), add p
        r.val = diff[64] ? ap_uint<64>(diff + ap_uint<65>(GL64_P))
                         : ap_uint<64>(diff);
        return r;
    }

    // ---- Modular Negation ----
    gl64_t operator-() const {
        #pragma HLS INLINE
        return gl64_t::zero() - *this;
    }

    // ---- Modular Multiplication ----
    // Uses Goldilocks-specific reduction:
    //   a*b mod p = (rl - rhh + 0xFFFFFFFF * rhl) mod p
    // where prod = rh:rl, rh = rhh:rhl (32-bit halves)
    //
    // Key optimization: 0xFFFFFFFF * rhl = (rhl << 32) - rhl (no DSP!)
    gl64_t operator*(const gl64_t& b) const {
        #pragma HLS INLINE
        // Full 128-bit product
        ap_uint<128> prod = ap_uint<128>(val) * ap_uint<128>(b.val);

        // Split product into 64-bit halves
        ap_uint<64> rl = prod(63, 0);
        ap_uint<64> rh = prod(127, 64);

        // Split high word into 32-bit halves
        ap_uint<32> rhh = rh(63, 32);
        ap_uint<32> rhl = rh(31, 0);

        // Step 1: aux1 = rl - rhh (mod p)
        // Use 65-bit to detect underflow cleanly
        ap_uint<65> aux1_wide = ap_uint<65>(rl) - ap_uint<65>(rhh);
        if (aux1_wide[64]) {
            // Underflow: add p to correct
            aux1_wide += ap_uint<65>(GL64_P);
        }
        ap_uint<64> aux1 = aux1_wide(63, 0);

        // Step 2: aux = 0xFFFFFFFF * rhl = (rhl << 32) - rhl
        // Avoids DSP multiply entirely!
        ap_uint<64> rhl_ext = ap_uint<64>(rhl);
        ap_uint<64> aux = (rhl_ext << 32) - rhl_ext;

        // Step 3: modular add (sum can be at most 2p-2)
        ap_uint<65> sum = ap_uint<65>(aux1) + ap_uint<65>(aux);
        ap_uint<65> sum_minus_p = sum - ap_uint<65>(GL64_P);
        gl64_t r;
        r.val = sum_minus_p[64] ? ap_uint<64>(sum)
                                : ap_uint<64>(sum_minus_p);
        return r;
    }

    // ---- Squaring ----
    gl64_t square() const {
        #pragma HLS INLINE
        return *this * *this;
    }

    // ---- Comparison ----
    bool operator==(const gl64_t& b) const {
        #pragma HLS INLINE
        return val == b.val;
    }
    bool operator!=(const gl64_t& b) const {
        #pragma HLS INLINE
        return val != b.val;
    }

    // ---- Compound assignment ----
    gl64_t& operator+=(const gl64_t& b) {
        #pragma HLS INLINE
        *this = *this + b;
        return *this;
    }
    gl64_t& operator-=(const gl64_t& b) {
        #pragma HLS INLINE
        *this = *this - b;
        return *this;
    }
    gl64_t& operator*=(const gl64_t& b) {
        #pragma HLS INLINE
        *this = *this * b;
        return *this;
    }

    // ---- Helper: square n times then multiply by m ----
    // Used in the Fermat inverse addition chain.
    static gl64_t sqr_n_mul(gl64_t s, unsigned int n, const gl64_t& m) {
        #pragma HLS INLINE off
        for (unsigned int i = 0; i < n; i++) {
            #pragma HLS PIPELINE II=1
            #pragma HLS LOOP_TRIPCOUNT min=1 max=32
            s = s.square();
        }
        return s * m;
    }

    // ---- Modular Inverse via Fermat's Little Theorem ----
    // a^(-1) = a^(p-2) mod p
    // Uses the exact same addition chain as the GPU (gl64_t.cuh:reciprocal)
    // for bit-exact equivalence.
    // Total: 63 squarings + 9 multiplications = 72 field multiplies.
    gl64_t reciprocal() const {
        #pragma HLS INLINE off
        gl64_t t0, t1;

        t1 = sqr_n_mul(*this, 1, *this);   // x^3             = 0b11
        t0 = sqr_n_mul(t1, 2, t1);         // x^15            = 0b1111
        t0 = sqr_n_mul(t0, 2, t1);         // x^63            = 0b111111
        t1 = sqr_n_mul(t0, 6, t0);         // x^(2^12 - 1)
        t1 = sqr_n_mul(t1, 12, t1);        // x^(2^24 - 1)
        t1 = sqr_n_mul(t1, 6, t0);         // x^(2^30 - 1)
        t1 = sqr_n_mul(t1, 1, *this);      // x^(2^31 - 1)
        t1 = sqr_n_mul(t1, 32, t1);        // x^((2^31-1)*2^32 + 2^31-1)
        t1 = sqr_n_mul(t1, 1, *this);      // x^(p-2)

        return t1;
    }

    // ---- Convenience: division ----
    gl64_t operator/(const gl64_t& b) const {
        #pragma HLS INLINE
        return *this * b.reciprocal();
    }
};

// ---- Batch Inverse (Montgomery's trick) ----
// Converts N inversions into 1 inversion + ~3N multiplications.
// result and input may NOT alias. Both arrays must have size >= n.
template <int MAX_N>
void gl64_batch_inverse(gl64_t* result, const gl64_t* input, unsigned int n) {
    #pragma HLS INLINE off
    gl64_t tmp[MAX_N];
    #pragma HLS ARRAY_PARTITION variable=tmp type=complete dim=0

    // Forward pass: prefix products
    tmp[0] = input[0];
    for (unsigned int i = 1; i < n; i++) {
        #pragma HLS PIPELINE II=1
        #pragma HLS LOOP_TRIPCOUNT min=1 max=MAX_N
        tmp[i] = tmp[i - 1] * input[i];
    }

    // Single inversion
    gl64_t z = tmp[n - 1].reciprocal();

    // Backward pass
    for (unsigned int i = n - 1; i > 0; i--) {
        #pragma HLS PIPELINE II=1
        #pragma HLS LOOP_TRIPCOUNT min=1 max=MAX_N
        gl64_t z2 = z * input[i];
        result[i] = z * tmp[i - 1];
        z = z2;
    }
    result[0] = z;
}

#endif // VENUS_GL64_T_HPP
