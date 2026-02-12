// FRI Protocol HLS Testbench
//
// Tests for FRI folding, transpose, and query operations.
// Uses pure C++ reference implementations for verification.
//
// Test cases:
//   1. Bit-reversal correctness
//   2. Small INTT (ratio=2)
//   3. Small INTT (ratio=4)
//   4. FRI fold with ratio=2 (simplest case)
//   5. FRI fold with ratio=4
//   6. Transpose
//   7. Module queries
//   8. Extract query values

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <cassert>

// Include Vitis HLS types
#include <ap_int.h>

// Include FRI headers
#include "../fri_fold.hpp"
#include "../fri_query.hpp"

// ---- Reference Goldilocks arithmetic (software) ----
static const uint64_t REF_P = 0xFFFFFFFF00000001ULL;

static uint64_t ref_add(uint64_t a, uint64_t b) {
    __uint128_t s = (__uint128_t)a + b;
    if (s >= REF_P) s -= REF_P;
    return (uint64_t)s;
}

static uint64_t ref_sub(uint64_t a, uint64_t b) {
    if (a >= b) return a - b;
    return a + REF_P - b;
}

static uint64_t ref_mul(uint64_t a, uint64_t b) {
    __uint128_t prod = (__uint128_t)a * b;
    uint64_t rl = (uint64_t)prod;
    uint64_t rh = (uint64_t)(prod >> 64);
    uint32_t rhh = (uint32_t)(rh >> 32);
    uint32_t rhl = (uint32_t)rh;
    uint64_t aux1 = ref_sub(rl, (uint64_t)rhh);
    uint64_t aux = ((uint64_t)rhl << 32) - (uint64_t)rhl;
    return ref_add(aux1, aux);
}

static uint64_t ref_neg(uint64_t a) {
    if (a == 0) return 0;
    return REF_P - a;
}

// Modular exponentiation
static uint64_t ref_pow(uint64_t base, uint64_t exp) {
    uint64_t result = 1;
    base %= REF_P;
    while (exp > 0) {
        if (exp & 1) result = ref_mul(result, base);
        base = ref_mul(base, base);
        exp >>= 1;
    }
    return result;
}

// Modular inverse via Fermat
static uint64_t ref_inv(uint64_t a) {
    return ref_pow(a, REF_P - 2);
}

// ---- Reference cubic extension field arithmetic ----
struct ref_ext3 {
    uint64_t v[3];
};

static ref_ext3 ref_ext3_add(ref_ext3 a, ref_ext3 b) {
    return {ref_add(a.v[0], b.v[0]), ref_add(a.v[1], b.v[1]), ref_add(a.v[2], b.v[2])};
}

static ref_ext3 ref_ext3_sub(ref_ext3 a, ref_ext3 b) {
    return {ref_sub(a.v[0], b.v[0]), ref_sub(a.v[1], b.v[1]), ref_sub(a.v[2], b.v[2])};
}

// Karatsuba multiplication for cubic extension
// Irreducible polynomial: x^3 - x - 1
static ref_ext3 ref_ext3_mul(ref_ext3 a, ref_ext3 b) {
    uint64_t A = ref_mul(ref_add(a.v[0], a.v[1]), ref_add(b.v[0], b.v[1]));
    uint64_t B = ref_mul(ref_add(a.v[0], a.v[2]), ref_add(b.v[0], b.v[2]));
    uint64_t C = ref_mul(ref_add(a.v[1], a.v[2]), ref_add(b.v[1], b.v[2]));
    uint64_t D = ref_mul(a.v[0], b.v[0]);
    uint64_t E = ref_mul(a.v[1], b.v[1]);
    uint64_t F = ref_mul(a.v[2], b.v[2]);
    uint64_t G = ref_sub(D, E);

    return {
        ref_sub(ref_add(C, G), F),
        ref_sub(ref_sub(ref_sub(ref_add(A, C), E), E), D),
        ref_sub(B, G)
    };
}

// Scalar multiply: ext3 * base
static ref_ext3 ref_ext3_smul(ref_ext3 a, uint64_t s) {
    return {ref_mul(a.v[0], s), ref_mul(a.v[1], s), ref_mul(a.v[2], s)};
}

static ref_ext3 ref_ext3_zero() {
    return {0, 0, 0};
}

// ---- Roots of unity table ----
static const uint64_t ROOTS_RAW[33] = {
    0x0000000000000001ULL, 0xFFFFFFFF00000000ULL, 0x0001000000000000ULL,
    0x0000000001000000ULL, 0x0000000000001000ULL, 0x0000000000000040ULL,
    0x0000000000000008ULL, 0x000001FFFDFFFE00ULL, 0x3D212E8CBC8A1ED3ULL,
    0x594C6B9EF1635CA5ULL, 0x3B0D463D6552A871ULL, 0x7E785A6E2821983EULL,
    0x3C713933C4EB986BULL, 0x3BCAB9C3F9DDE835ULL, 0x62E4B94776C81AAAULL,
    0x1A0037386D98CA5EULL, 0x71578C3FD9199C53ULL, 0x4F5AAFC1370CC51AULL,
    0x2F57BB2F67816280ULL, 0x7CA80B47BA4B38BDULL, 0x1B5C0AD6B72DB3A1ULL,
    0x5AF3327DEA3A8CB9ULL, 0x70C12BC56D66855CULL, 0x5262AEE151C7655EULL,
    0x259B60F3625BAE63ULL, 0x7B3336E748AC4576ULL, 0x3425B3E207B557BFULL,
    0x44F8E4C2E7CBB309ULL, 0x1DCC93E918DECF53ULL, 0x231E5F6A3F50A6BBULL,
    0x1A708F62D4C6586BULL, 0x30EAA905858B619FULL, 0x64FDD1A46201E246ULL,
};

// Domain size inverses
static const uint64_t DOMAIN_INV_RAW[5] = {
    0x0000000000000001ULL, 0x7FFFFFFF80000001ULL,
    0xBFFFFFFF40000001ULL, 0xDFFFFFFF20000001ULL,
    0xEFFFFFFF10000001ULL,
};

static const uint64_t SHIFT_VAL = 7;

// ---- Reference bit-reverse ----
static unsigned int ref_bit_reverse(unsigned int v, unsigned int bits) {
    unsigned int r = 0;
    for (unsigned int i = 0; i < bits; i++) {
        r |= ((v >> i) & 1) << (bits - 1 - i);
    }
    return r;
}

// ---- Reference small INTT ----
// Matches GPU intt_tinny: bit-reverse, DIT butterflies, N^{-1} scaling
static void ref_intt_tiny(ref_ext3* data, unsigned int N, unsigned int logN) {
    // omega_inv for domain of size N
    uint64_t omega_inv = ref_inv(ROOTS_RAW[logN]);

    // Compute twiddles: omega_inv^i
    uint64_t* twiddles = new uint64_t[N / 2];
    twiddles[0] = 1;
    for (unsigned int i = 1; i < N / 2; i++) {
        twiddles[i] = ref_mul(twiddles[i - 1], omega_inv);
    }

    // Bit-reversal
    for (unsigned int i = 0; i < N; i++) {
        unsigned int ibr = ref_bit_reverse(i, logN);
        if (ibr > i) {
            ref_ext3 tmp = data[i];
            data[i] = data[ibr];
            data[ibr] = tmp;
        }
    }

    // DIT butterflies
    for (unsigned int stage = 0; stage < logN; stage++) {
        unsigned int half_group_size = 1u << stage;
        unsigned int tw_stride = N >> (stage + 1);
        for (unsigned int j = 0; j < N / 2; j++) {
            unsigned int group = j >> stage;
            unsigned int offset = j & (half_group_size - 1);
            unsigned int index1 = (group << (stage + 1)) + offset;
            unsigned int index2 = index1 + half_group_size;
            uint64_t factor = twiddles[offset * tw_stride];

            ref_ext3 odd_sub = ref_ext3_smul(data[index2], factor);
            ref_ext3 even = data[index1];
            data[index2] = ref_ext3_sub(even, odd_sub);
            data[index1] = ref_ext3_add(even, odd_sub);
        }
    }

    // Scale by N^{-1}
    uint64_t inv_n = DOMAIN_INV_RAW[logN];
    for (unsigned int i = 0; i < N; i++) {
        data[i] = ref_ext3_smul(data[i], inv_n);
    }

    delete[] twiddles;
}

// ---- Reference FRI fold for one element ----
static ref_ext3 ref_fold_single(
    const uint64_t* friPol,  // flat array, [idx * 3 + k]
    unsigned int g,
    unsigned int sizeFoldedPol,
    unsigned int ratio,
    unsigned int logRatio,
    uint64_t invShift,
    uint64_t invW,
    ref_ext3 challenge
) {
    // Gather
    ref_ext3* ppar = new ref_ext3[ratio];
    for (unsigned int i = 0; i < ratio; i++) {
        unsigned int base = (i * sizeFoldedPol + g) * 3;
        ppar[i] = {friPol[base], friPol[base + 1], friPol[base + 2]};
    }

    // INTT
    ref_intt_tiny(ppar, ratio, logRatio);

    // polMulAxi: multiply by powers of sinv
    // sinv = invShift * invW^g
    uint64_t sinv = invShift;
    {
        uint64_t base = invW;
        unsigned int exp = g;
        while (exp > 0) {
            if (exp & 1) sinv = ref_mul(sinv, base);
            base = ref_mul(base, base);
            exp >>= 1;
        }
    }
    uint64_t r = 1;
    for (unsigned int i = 0; i < ratio; i++) {
        ppar[i] = ref_ext3_smul(ppar[i], r);
        r = ref_mul(r, sinv);
    }

    // Horner evaluation
    ref_ext3 result;
    if (ratio == 0) {
        result = ref_ext3_zero();
    } else {
        result = ppar[ratio - 1];
        for (int i = (int)ratio - 2; i >= 0; i--) {
            ref_ext3 aux = ref_ext3_mul(result, challenge);
            result = ref_ext3_add(aux, ppar[i]);
        }
    }

    delete[] ppar;
    return result;
}

// ---- Kernel declaration ----
extern "C" void fri_test_kernel(
    ap_uint<64>*       friPol,
    ap_uint<64>*       output,
    const ap_uint<64>* challenge_in,
    unsigned int*      queries,
    unsigned int       op,
    unsigned int       prevBits,
    unsigned int       currentBits,
    unsigned int       nextBits,
    unsigned int       nQueries,
    ap_uint<64>        omega_inv_raw,
    ap_uint<64>        invShift_raw,
    ap_uint<64>        invW_raw,
    unsigned int       treeWidth
);

// ---- Test helpers ----
static int g_pass = 0, g_fail = 0;

static void check(const char* name, bool ok) {
    if (ok) {
        printf("  PASS: %s\n", name);
        g_pass++;
    } else {
        printf("  FAIL: %s\n", name);
        g_fail++;
    }
}

static bool eq64(ap_uint<64> a, uint64_t b) {
    return (uint64_t)a == b;
}

// =========================================================================
// Test 1: Bit-reversal
// =========================================================================
static void test_bit_reverse() {
    printf("\n--- Test 1: Bit-reversal ---\n");

    // 2-bit reversal: 0->0, 1->2, 2->1, 3->3
    check("bitrev(0,2)==0", fri_bit_reverse(0, 2) == 0);
    check("bitrev(1,2)==2", fri_bit_reverse(1, 2) == 2);
    check("bitrev(2,2)==1", fri_bit_reverse(2, 2) == 1);
    check("bitrev(3,2)==3", fri_bit_reverse(3, 2) == 3);

    // 3-bit reversal
    check("bitrev(1,3)==4", fri_bit_reverse(1, 3) == 4);
    check("bitrev(3,3)==6", fri_bit_reverse(3, 3) == 6);
    check("bitrev(5,3)==5", fri_bit_reverse(5, 3) == 5);
}

// =========================================================================
// Test 2: Small INTT with ratio=2
// =========================================================================
static void test_intt_ratio2() {
    printf("\n--- Test 2: Small INTT (ratio=2) ---\n");

    // Create test data: two cubic extension elements
    // INTT of size 2: bit-reverse (swap if needed), one butterfly, scale by 1/2
    ref_ext3 ref_data[2] = {
        {3, 0, 0},
        {7, 0, 0}
    };
    ref_intt_tiny(ref_data, 2, 1);

    // Run HLS version
    gl64_3_t hls_data[16];
    hls_data[0] = gl64_3_t(gl64_t(3ULL), gl64_t(0ULL), gl64_t(0ULL));
    hls_data[1] = gl64_3_t(gl64_t(7ULL), gl64_t(0ULL), gl64_t(0ULL));

    // Compute twiddles for ratio=2
    uint64_t omega_inv_val = ref_inv(ROOTS_RAW[1]);
    gl64_t twiddles[8];
    twiddles[0] = gl64_t::one();

    fri_intt_tiny<16>(hls_data, 2, 1, twiddles);

    bool ok = true;
    for (int k = 0; k < 3; k++) {
        if ((uint64_t)hls_data[0].v[k].val != ref_data[0].v[k]) ok = false;
        if ((uint64_t)hls_data[1].v[k].val != ref_data[1].v[k]) ok = false;
    }
    check("INTT ratio=2 matches reference", ok);

    printf("  HLS:  [%llu, %llu] [%llu, %llu]\n",
        (unsigned long long)(uint64_t)hls_data[0].v[0].val,
        (unsigned long long)(uint64_t)hls_data[0].v[1].val,
        (unsigned long long)(uint64_t)hls_data[1].v[0].val,
        (unsigned long long)(uint64_t)hls_data[1].v[1].val);
    printf("  Ref:  [%llu, %llu] [%llu, %llu]\n",
        (unsigned long long)ref_data[0].v[0],
        (unsigned long long)ref_data[0].v[1],
        (unsigned long long)ref_data[1].v[0],
        (unsigned long long)ref_data[1].v[1]);
}

// =========================================================================
// Test 3: Small INTT with ratio=4
// =========================================================================
static void test_intt_ratio4() {
    printf("\n--- Test 3: Small INTT (ratio=4) ---\n");

    ref_ext3 ref_data[4] = {
        {10, 0, 0}, {20, 0, 0}, {30, 0, 0}, {40, 0, 0}
    };
    ref_intt_tiny(ref_data, 4, 2);

    gl64_3_t hls_data[16];
    hls_data[0] = gl64_3_t(gl64_t(10ULL), gl64_t(0ULL), gl64_t(0ULL));
    hls_data[1] = gl64_3_t(gl64_t(20ULL), gl64_t(0ULL), gl64_t(0ULL));
    hls_data[2] = gl64_3_t(gl64_t(30ULL), gl64_t(0ULL), gl64_t(0ULL));
    hls_data[3] = gl64_3_t(gl64_t(40ULL), gl64_t(0ULL), gl64_t(0ULL));

    // Compute twiddles for ratio=4: omega_inv = inv(root[2]) = inv(2^48)
    uint64_t omega_inv_val = ref_inv(ROOTS_RAW[2]);
    gl64_t twiddles[8];
    twiddles[0] = gl64_t::one();
    twiddles[1] = gl64_t(omega_inv_val);

    fri_intt_tiny<16>(hls_data, 4, 2, twiddles);

    bool ok = true;
    for (unsigned int i = 0; i < 4; i++) {
        for (int k = 0; k < 3; k++) {
            if ((uint64_t)hls_data[i].v[k].val != ref_data[i].v[k]) ok = false;
        }
    }
    check("INTT ratio=4 matches reference", ok);

    for (unsigned int i = 0; i < 4; i++) {
        printf("  [%u] HLS=%llu,%llu,%llu  ref=%llu,%llu,%llu\n", i,
            (unsigned long long)(uint64_t)hls_data[i].v[0].val,
            (unsigned long long)(uint64_t)hls_data[i].v[1].val,
            (unsigned long long)(uint64_t)hls_data[i].v[2].val,
            (unsigned long long)ref_data[i].v[0],
            (unsigned long long)ref_data[i].v[1],
            (unsigned long long)ref_data[i].v[2]);
    }
}

// =========================================================================
// Test 4: FRI fold with ratio=2 via kernel
// =========================================================================
static void test_fold_ratio2() {
    printf("\n--- Test 4: FRI fold (ratio=2, 4 -> 2 elements) ---\n");

    // prevBits=2, currentBits=1 => ratio=2, sizeFoldedPol=2
    unsigned int prevBits = 2;
    unsigned int currentBits = 1;
    unsigned int sizePol = 1u << prevBits;     // 4
    unsigned int sizeFoldedPol = 1u << currentBits; // 2
    unsigned int ratio = sizePol / sizeFoldedPol;   // 2

    // Input polynomial: 4 cubic extension elements
    // Layout: friPol[(i * sizeFoldedPol + g) * 3 + k]
    // For ratio=2, sizeFoldedPol=2:
    //   g=0: friPol[0*3..2], friPol[2*3..8]  (i=0 at idx 0, i=1 at idx 2)
    //   g=1: friPol[1*3..5], friPol[3*3..11] (i=0 at idx 1, i=1 at idx 3)
    uint64_t pol_flat[12]; // 4 elements * 3 components
    for (unsigned int i = 0; i < 12; i++) {
        pol_flat[i] = (i + 1) * 100;  // simple test values
    }

    ap_uint<64> friPol[12], output[6], challenge_in[3];
    for (int i = 0; i < 12; i++) friPol[i] = pol_flat[i];

    // Challenge: (5, 0, 0) - simple base field challenge
    uint64_t ch_vals[3] = {5, 0, 0};
    challenge_in[0] = ch_vals[0];
    challenge_in[1] = ch_vals[1];
    challenge_in[2] = ch_vals[2];

    // Precompute parameters
    // nBitsExt = prevBits for step > 0 (first fold)
    uint64_t nBitsExt = prevBits;
    uint64_t invShift_val = ref_inv(SHIFT_VAL);
    // invShift = (1/shift)^(2^(nBitsExt - prevBits)) = (1/shift)^1 = invShift
    for (unsigned int j = 0; j < nBitsExt - prevBits; j++) {
        invShift_val = ref_mul(invShift_val, invShift_val);
    }
    uint64_t invW_val = ref_inv(ROOTS_RAW[prevBits]);
    unsigned int logRatio = prevBits - currentBits;
    uint64_t omega_inv_val = ref_inv(ROOTS_RAW[logRatio]);

    unsigned int queries_dummy[1] = {0};

    // Run kernel
    fri_test_kernel(
        friPol, output, challenge_in, queries_dummy,
        0, // op=fold
        prevBits, currentBits, 0, 0,
        ap_uint<64>(omega_inv_val),
        ap_uint<64>(invShift_val),
        ap_uint<64>(invW_val),
        0
    );

    // Reference fold
    ref_ext3 challenge_ref = {ch_vals[0], ch_vals[1], ch_vals[2]};
    bool ok = true;
    for (unsigned int g = 0; g < sizeFoldedPol; g++) {
        ref_ext3 ref = ref_fold_single(pol_flat, g, sizeFoldedPol, ratio, logRatio,
                                        invShift_val, invW_val, challenge_ref);
        for (int k = 0; k < 3; k++) {
            if (!eq64(output[g * 3 + k], ref.v[k])) {
                printf("  Mismatch at g=%u k=%d: HLS=%llu ref=%llu\n",
                    g, k, (unsigned long long)(uint64_t)output[g * 3 + k],
                    (unsigned long long)ref.v[k]);
                ok = false;
            }
        }
    }
    check("fold ratio=2 matches reference", ok);
}

// =========================================================================
// Test 5: FRI fold with ratio=4 via kernel
// =========================================================================
static void test_fold_ratio4() {
    printf("\n--- Test 5: FRI fold (ratio=4, 16 -> 4 elements) ---\n");

    unsigned int prevBits = 4;
    unsigned int currentBits = 2;
    unsigned int sizePol = 1u << prevBits;     // 16
    unsigned int sizeFoldedPol = 1u << currentBits; // 4
    unsigned int ratio = sizePol / sizeFoldedPol;   // 4

    // Input polynomial: 16 cubic extension elements (48 field elements)
    uint64_t pol_flat[48];
    for (unsigned int i = 0; i < 48; i++) {
        pol_flat[i] = ((uint64_t)i * 17 + 3) % REF_P;
    }

    ap_uint<64> friPol[48], output[12], challenge_in[3];
    for (int i = 0; i < 48; i++) friPol[i] = pol_flat[i];

    // Cubic extension challenge
    uint64_t ch_vals[3] = {0x123456789ABCULL, 0xFEDCBA987654ULL, 42};
    challenge_in[0] = ch_vals[0];
    challenge_in[1] = ch_vals[1];
    challenge_in[2] = ch_vals[2];

    uint64_t nBitsExt = prevBits;
    uint64_t invShift_val = ref_inv(SHIFT_VAL);
    for (unsigned int j = 0; j < nBitsExt - prevBits; j++) {
        invShift_val = ref_mul(invShift_val, invShift_val);
    }
    uint64_t invW_val = ref_inv(ROOTS_RAW[prevBits]);
    unsigned int logRatio = prevBits - currentBits;
    uint64_t omega_inv_val = ref_inv(ROOTS_RAW[logRatio]);

    unsigned int queries_dummy[1] = {0};

    fri_test_kernel(
        friPol, output, challenge_in, queries_dummy,
        0, prevBits, currentBits, 0, 0,
        ap_uint<64>(omega_inv_val),
        ap_uint<64>(invShift_val),
        ap_uint<64>(invW_val),
        0
    );

    ref_ext3 challenge_ref = {ch_vals[0], ch_vals[1], ch_vals[2]};
    bool ok = true;
    for (unsigned int g = 0; g < sizeFoldedPol; g++) {
        ref_ext3 ref = ref_fold_single(pol_flat, g, sizeFoldedPol, ratio, logRatio,
                                        invShift_val, invW_val, challenge_ref);
        for (int k = 0; k < 3; k++) {
            if (!eq64(output[g * 3 + k], ref.v[k])) {
                printf("  Mismatch at g=%u k=%d: HLS=%llu ref=%llu\n",
                    g, k, (unsigned long long)(uint64_t)output[g * 3 + k],
                    (unsigned long long)ref.v[k]);
                ok = false;
            }
        }
    }
    check("fold ratio=4 matches reference", ok);
}

// =========================================================================
// Test 6: Transpose
// =========================================================================
static void test_transpose() {
    printf("\n--- Test 6: Transpose ---\n");

    // degree=8, width=4 => height=2
    // Input: 8 cubic extension elements (24 field elements)
    // Transposed layout: col * height + row
    unsigned int degree = 8;
    unsigned int width = 4;
    unsigned int height = degree / width; // 2

    ap_uint<64> pol[24], aux[24];
    for (unsigned int i = 0; i < 24; i++) {
        pol[i] = i + 100;
    }

    unsigned int queries_dummy[1] = {0};
    ap_uint<64> challenge_dummy[3] = {0, 0, 0};

    // op=1: transpose, currentBits=3 (degree=8), nextBits=2 (width=4)
    fri_test_kernel(
        pol, aux, challenge_dummy, queries_dummy,
        1, // op=transpose
        0, 3, 2, 0,
        ap_uint<64>(0), ap_uint<64>(0), ap_uint<64>(0), 0
    );

    // Verify: aux[col * height + row] should equal pol[row * width + col]
    // Each element is 3 field values
    bool ok = true;
    for (unsigned int row = 0; row < height; row++) {
        for (unsigned int col = 0; col < width; col++) {
            for (unsigned int k = 0; k < 3; k++) {
                unsigned int fi = (row * width + col) * 3 + k;
                unsigned int di = (col * height + row) * 3 + k;
                if ((uint64_t)aux[di] != (uint64_t)pol[fi]) {
                    printf("  Mismatch at row=%u col=%u k=%u: aux[%u]=%llu pol[%u]=%llu\n",
                        row, col, k, di, (unsigned long long)(uint64_t)aux[di],
                        fi, (unsigned long long)(uint64_t)pol[fi]);
                    ok = false;
                }
            }
        }
    }
    check("transpose correctness", ok);
}

// =========================================================================
// Test 7: Module queries
// =========================================================================
static void test_module_queries() {
    printf("\n--- Test 7: Module queries ---\n");

    unsigned int queries[4] = {17, 35, 100, 255};
    unsigned int currentBits = 3; // mask = 7

    ap_uint<64> pol_dummy[1] = {0};
    ap_uint<64> out_dummy[1] = {0};
    ap_uint<64> ch_dummy[3] = {0, 0, 0};

    fri_test_kernel(
        pol_dummy, out_dummy, ch_dummy, queries,
        3, // op=module queries
        0, currentBits, 0, 4,
        ap_uint<64>(0), ap_uint<64>(0), ap_uint<64>(0), 0
    );

    check("query[0]=17%%8==1", queries[0] == 1);
    check("query[1]=35%%8==3", queries[1] == 3);
    check("query[2]=100%%8==4", queries[2] == 4);
    check("query[3]=255%%8==7", queries[3] == 7);
}

// =========================================================================
// Test 8: Extract query values
// =========================================================================
static void test_extract_query() {
    printf("\n--- Test 8: Extract query values ---\n");

    // Simulate a transposed polynomial source with treeWidth=6 (2 ext3 elements)
    unsigned int treeWidth = 6;
    unsigned int nRows = 4;
    ap_uint<64> tree_source[24]; // 4 rows * 6 elements
    for (unsigned int i = 0; i < 24; i++) {
        tree_source[i] = i * 1000 + 7;
    }

    ap_uint<64> output[6];
    unsigned int queries[1] = {2}; // extract row 2
    ap_uint<64> ch_dummy[3] = {0, 0, 0};

    fri_test_kernel(
        tree_source, output, ch_dummy, queries,
        2, // op=extract query
        0, 0, 0, 1,
        ap_uint<64>(0), ap_uint<64>(0), ap_uint<64>(0), treeWidth
    );

    // Row 2 starts at index 2 * 6 = 12
    bool ok = true;
    for (unsigned int i = 0; i < treeWidth; i++) {
        uint64_t expected = (12 + i) * 1000 + 7;
        if ((uint64_t)output[i] != expected) {
            printf("  Mismatch at i=%u: got %llu expected %llu\n",
                i, (unsigned long long)(uint64_t)output[i],
                (unsigned long long)expected);
            ok = false;
        }
    }
    check("extract query row=2", ok);
}

// =========================================================================
// Main
// =========================================================================
int main() {
    printf("===== FRI Protocol HLS Testbench =====\n");

    test_bit_reverse();
    test_intt_ratio2();
    test_intt_ratio4();
    test_fold_ratio2();
    test_fold_ratio4();
    test_transpose();
    test_module_queries();
    test_extract_query();

    printf("\n===== Results: %d passed, %d failed =====\n", g_pass, g_fail);
    return g_fail > 0 ? 1 : 0;
}
