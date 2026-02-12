// Goldilocks Cubic Extension Field Arithmetic for AMD FPGA (Vitis HLS)
// F_p^3 = F_p[x] / (x^3 - x - 1)
// Element (a0, a1, a2) represents a0 + a1*x + a2*x^2
//
// Reference: pil2-proofman/pil2-stark/src/goldilocks/src/goldilocks_cubic_extension.cuh (GPU)
//            pil2-proofman/pil2-stark/src/goldilocks/src/goldilocks_cubic_extension.hpp (CPU)

#ifndef VENUS_GL64_CUBIC_HPP
#define VENUS_GL64_CUBIC_HPP

#include "gl64_t.hpp"

struct gl64_3_t {
    gl64_t v[3];

    // ---- Constructors ----
    gl64_3_t() {
        #pragma HLS INLINE
        v[0] = gl64_t::zero();
        v[1] = gl64_t::zero();
        v[2] = gl64_t::zero();
    }
    gl64_3_t(gl64_t a0, gl64_t a1, gl64_t a2) {
        #pragma HLS INLINE
        v[0] = a0; v[1] = a1; v[2] = a2;
    }

    // ---- Constants ----
    static gl64_3_t zero() {
        #pragma HLS INLINE
        return gl64_3_t(gl64_t::zero(), gl64_t::zero(), gl64_t::zero());
    }
    static gl64_3_t one() {
        #pragma HLS INLINE
        return gl64_3_t(gl64_t::one(), gl64_t::zero(), gl64_t::zero());
    }

    // ---- Predicates ----
    bool is_zero() const {
        #pragma HLS INLINE
        return v[0].is_zero() && v[1].is_zero() && v[2].is_zero();
    }
    bool is_one() const {
        #pragma HLS INLINE
        return v[0].is_one() && v[1].is_zero() && v[2].is_zero();
    }

    // ---- Component-wise Addition ----
    gl64_3_t operator+(const gl64_3_t& b) const {
        #pragma HLS INLINE
        return gl64_3_t(v[0] + b.v[0], v[1] + b.v[1], v[2] + b.v[2]);
    }

    // ---- Addition with base field element (adds to component 0 only) ----
    gl64_3_t operator+(const gl64_t& b) const {
        #pragma HLS INLINE
        return gl64_3_t(v[0] + b, v[1], v[2]);
    }

    // ---- Component-wise Subtraction ----
    gl64_3_t operator-(const gl64_3_t& b) const {
        #pragma HLS INLINE
        return gl64_3_t(v[0] - b.v[0], v[1] - b.v[1], v[2] - b.v[2]);
    }

    // ---- Subtraction: base_field - cubic ----
    friend gl64_3_t operator-(const gl64_t& a, const gl64_3_t& b) {
        #pragma HLS INLINE
        return gl64_3_t(a - b.v[0], -b.v[1], -b.v[2]);
    }

    // ---- Negation ----
    gl64_3_t operator-() const {
        #pragma HLS INLINE
        return gl64_3_t(-v[0], -v[1], -v[2]);
    }

    // ---- Cubic Multiplication (Karatsuba-like, 6 base field muls) ----
    // From reference: Goldilocks3GPU::mul / Goldilocks3::mul
    //
    // A = (a0+a1)*(b0+b1)    B = (a0+a2)*(b0+b2)    C = (a1+a2)*(b1+b2)
    // D = a0*b0               E = a1*b1               F = a2*b2
    // G = D - E
    // result[0] = C + G - F
    // result[1] = A + C - 2*E - D
    // result[2] = B - G
    gl64_3_t operator*(const gl64_3_t& b) const {
        #pragma HLS INLINE
        // Prepare sums (6 adds, all independent)
        gl64_t a0_a1 = v[0] + v[1];
        gl64_t a0_a2 = v[0] + v[2];
        gl64_t a1_a2 = v[1] + v[2];
        gl64_t b0_b1 = b.v[0] + b.v[1];
        gl64_t b0_b2 = b.v[0] + b.v[2];
        gl64_t b1_b2 = b.v[1] + b.v[2];

        // 6 base field multiplications (all independent, can be parallel)
        gl64_t A = a0_a1 * b0_b1;
        gl64_t B = a0_a2 * b0_b2;
        gl64_t C = a1_a2 * b1_b2;
        gl64_t D = v[0] * b.v[0];
        gl64_t E = v[1] * b.v[1];
        gl64_t F = v[2] * b.v[2];

        // Combine (cheap add/sub)
        gl64_t G = D - E;
        return gl64_3_t(
            (C + G) - F,                       // result[0]
            ((((A + C) - E) - E) - D),          // result[1]
            B - G                               // result[2]
        );
    }

    // ---- Scalar multiplication (cubic * base field) ----
    gl64_3_t operator*(const gl64_t& b) const {
        #pragma HLS INLINE
        return gl64_3_t(v[0] * b, v[1] * b, v[2] * b);
    }

    // ---- Scalar multiplication (base field * cubic) ----
    friend gl64_3_t operator*(const gl64_t& a, const gl64_3_t& b) {
        #pragma HLS INLINE
        return b * a;
    }

    // ---- Cubic Inverse ----
    // From reference: Goldilocks3GPU::inv / Goldilocks3::inv
    // Computes norm, inverts in base field, then reconstructs.
    // Cost: 17 base field muls + 1 base field inverse + adds/subs.
    gl64_3_t inv() const {
        #pragma HLS INLINE off
        // Quadratic terms (6 muls)
        gl64_t aa = v[0] * v[0];
        gl64_t ac = v[0] * v[2];
        gl64_t ba = v[1] * v[0];
        gl64_t bb = v[1] * v[1];
        gl64_t bc = v[1] * v[2];
        gl64_t cc = v[2] * v[2];

        // Cubic terms (8 muls)
        gl64_t aaa = aa * v[0];
        gl64_t aac = aa * v[2];
        gl64_t abc = ba * v[2];
        gl64_t abb = ba * v[1];
        gl64_t acc = ac * v[2];
        gl64_t bbb = bb * v[1];
        gl64_t bcc = bc * v[2];
        gl64_t ccc = cc * v[2];

        // Norm: t = 3*abc + abb - aaa - 2*aac - acc - bbb + bcc - ccc
        gl64_t t = abc + abc + abc + abb - aaa - aac - aac - acc
                 - bbb + bcc - ccc;

        // Single base field inversion
        gl64_t tinv = t.reciprocal();

        // Result components (3 muls with tinv)
        gl64_t i1 = (bc + bb - aa - ac - ac - cc) * tinv;
        gl64_t i2 = (ba - cc) * tinv;
        gl64_t i3 = (ac + cc - bb) * tinv;

        return gl64_3_t(i1, i2, i3);
    }

    // ---- Cubic Division ----
    gl64_3_t operator/(const gl64_3_t& b) const {
        #pragma HLS INLINE
        return *this * b.inv();
    }

    // ---- Scalar Division ----
    gl64_3_t operator/(const gl64_t& b) const {
        #pragma HLS INLINE
        gl64_t b_inv = b.reciprocal();
        return *this * b_inv;
    }

    // ---- Comparison ----
    bool operator==(const gl64_3_t& b) const {
        #pragma HLS INLINE
        return v[0] == b.v[0] && v[1] == b.v[1] && v[2] == b.v[2];
    }
    bool operator!=(const gl64_3_t& b) const {
        #pragma HLS INLINE
        return !(*this == b);
    }

    // ---- Compound assignment ----
    gl64_3_t& operator+=(const gl64_3_t& b) {
        #pragma HLS INLINE
        *this = *this + b;
        return *this;
    }
    gl64_3_t& operator-=(const gl64_3_t& b) {
        #pragma HLS INLINE
        *this = *this - b;
        return *this;
    }
    gl64_3_t& operator*=(const gl64_3_t& b) {
        #pragma HLS INLINE
        *this = *this * b;
        return *this;
    }
    gl64_3_t& operator*=(const gl64_t& b) {
        #pragma HLS INLINE
        *this = *this * b;
        return *this;
    }

    // ---- Power ----
    static gl64_3_t pow(gl64_3_t base, uint64_t exp) {
        #pragma HLS INLINE off
        gl64_3_t result = gl64_3_t::one();
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
};

#endif // VENUS_GL64_CUBIC_HPP
