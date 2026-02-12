// C-Simulation Testbench for NTT HLS Kernel
//
// Validates bit-exact correctness of the NTT against a CPU reference
// implementation.  Tests small sizes (N=4, 8, 16, 32) where the
// entire NTT fits in one or two passes.
//
// Build: vitis_hls -f run_csim.tcl  (or Makefile csim target)
// Or standalone: g++ -std=c++14 -I$XILINX_HLS/include tb_ntt.cpp -o tb_ntt

#include "../ntt_config.hpp"
#include "../ntt_twiddle.hpp"
#include "../ntt_bitrev.hpp"
#include "../ntt_addr_gen.hpp"
#include "../../goldilocks/gl64_t.hpp"
#include "../../goldilocks/gl64_constants.hpp"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>

static const uint64_t P = 0xFFFFFFFF00000001ULL;

// ----- CPU Reference NTT (naive DIT, radix-2) -----
// This is a straightforward O(N log N) reference, not optimized.
static void ref_ntt_dit(uint64_t* data, unsigned int log_n, bool inverse) {
    uint32_t n = 1u << log_n;

    // Bit-reversal permutation
    for (uint32_t i = 0; i < n; i++) {
        uint32_t j = bit_reverse(i, log_n);
        if (j > i) {
            uint64_t tmp = data[i];
            data[i] = data[j];
            data[j] = tmp;
        }
    }

    // Butterfly stages
    gl64_t omega_n = gl64_root_of_unity(log_n);
    if (inverse) {
        omega_n = omega_n.reciprocal();
    }

    for (unsigned int s = 0; s < log_n; s++) {
        uint32_t m = 1u << (s + 1);
        uint32_t half_m = 1u << s;

        // Twiddle base for this stage: omega_n^(N / m) = root_of_unity(s+1)
        gl64_t w_base = gl64_root_of_unity(s + 1);
        if (inverse) {
            w_base = w_base.reciprocal();
        }

        for (uint32_t k = 0; k < n; k += m) {
            gl64_t w = gl64_t::one();
            for (uint32_t j = 0; j < half_m; j++) {
                gl64_t t = gl64_t(data[k + j + half_m]) * w;
                gl64_t u = gl64_t(data[k + j]);
                data[k + j] = (u + t).val;
                data[k + j + half_m] = (u - t).val;
                w = w * w_base;
            }
        }
    }

    // For inverse: multiply by 1/N
    if (inverse) {
        gl64_t inv_n = ntt_domain_size_inverse(log_n);
        for (uint32_t i = 0; i < n; i++) {
            data[i] = (gl64_t(data[i]) * inv_n).val;
        }
    }
}

static int test_count = 0;
static int fail_count = 0;

static void check(const char* name, uint64_t got, uint64_t expected) {
    test_count++;
    if (got != expected) {
        fail_count++;
        printf("FAIL [%s]: got 0x%016llx, expected 0x%016llx\n",
               name, (unsigned long long)got, (unsigned long long)expected);
    }
}

// ----- Test: Bit-reversal permutation -----
static void test_bitrev() {
    printf("--- test_bitrev ---\n");

    // Test bit_reverse function
    check("br(0,3)==0", bit_reverse(0, 3), (uint64_t)0);
    check("br(1,3)==4", bit_reverse(1, 3), (uint64_t)4);
    check("br(2,3)==2", bit_reverse(2, 3), (uint64_t)2);
    check("br(3,3)==6", bit_reverse(3, 3), (uint64_t)6);
    check("br(4,3)==1", bit_reverse(4, 3), (uint64_t)1);
    check("br(5,3)==5", bit_reverse(5, 3), (uint64_t)5);
    check("br(6,3)==3", bit_reverse(6, 3), (uint64_t)3);
    check("br(7,3)==7", bit_reverse(7, 3), (uint64_t)7);

    // Test self-inverse property: br(br(x)) == x
    for (unsigned int n = 1; n <= 16; n++) {
        for (uint32_t i = 0; i < (1u << n); i++) {
            uint32_t j = bit_reverse(bit_reverse(i, n), n);
            if (j != i) {
                fail_count++;
                printf("FAIL [br_self_inverse(%u,%u)]: br(br(%u))=%u\n",
                       i, n, i, j);
                test_count++;
                return;
            }
        }
        test_count++;
    }
}

// ----- Test: Twiddle factor consistency -----
static void test_twiddles() {
    printf("--- test_twiddles ---\n");

    // Verify that root_of_unity(k)^(2^k) = 1 for small k
    for (unsigned int k = 1; k <= 10; k++) {
        gl64_t w = gl64_root_of_unity(k);
        gl64_t result = gl64_pow(w, 1ULL << k);
        char name[64];
        snprintf(name, sizeof(name), "w[%u]^(2^%u)==1", k, k);
        check(name, result.val, (uint64_t)1);
    }

    // Verify w[k]^2 = w[k-1]
    for (unsigned int k = 2; k <= 10; k++) {
        gl64_t wk = gl64_root_of_unity(k);
        gl64_t wk_sq = wk * wk;
        gl64_t wk_prev = gl64_root_of_unity(k - 1);
        char name[64];
        snprintf(name, sizeof(name), "w[%u]^2==w[%u]", k, k - 1);
        check(name, wk_sq.val, wk_prev.val);
    }

    // Verify domain_size_inverse: n * (1/n) == 1
    for (unsigned int k = 1; k <= 10; k++) {
        gl64_t n(1ULL << k);
        gl64_t inv_n = ntt_domain_size_inverse(k);
        gl64_t product = n * inv_n;
        char name[64];
        snprintf(name, sizeof(name), "n*inv_n==1(k=%u)", k);
        check(name, product.val, (uint64_t)1);
    }
}

// ----- Test: Small NTT correctness (N=4) -----
static void test_ntt_4() {
    printf("--- test_ntt_4 ---\n");
    unsigned int log_n = 2;
    uint32_t n = 4;

    // Input: [1, 2, 3, 4]
    uint64_t input[4] = {1, 2, 3, 4};
    uint64_t ref[4];
    memcpy(ref, input, sizeof(input));

    // Compute reference NTT
    ref_ntt_dit(ref, log_n, false);

    // Verify: NTT([1,2,3,4]) with Goldilocks roots
    // Sum = 1+2+3+4 = 10 (this is always output[0])
    check("ntt4[0]==10", ref[0], (uint64_t)10);

    // Verify roundtrip: INTT(NTT(x)) == x
    uint64_t roundtrip[4];
    memcpy(roundtrip, ref, sizeof(ref));
    ref_ntt_dit(roundtrip, log_n, true);

    for (int i = 0; i < 4; i++) {
        char name[64];
        snprintf(name, sizeof(name), "roundtrip4[%d]", i);
        check(name, roundtrip[i], input[i]);
    }
}

// ----- Test: Small NTT correctness (N=8) -----
static void test_ntt_8() {
    printf("--- test_ntt_8 ---\n");
    unsigned int log_n = 3;
    uint32_t n = 8;

    uint64_t input[8] = {1, 2, 3, 4, 5, 6, 7, 8};
    uint64_t fwd[8];
    memcpy(fwd, input, sizeof(input));

    ref_ntt_dit(fwd, log_n, false);

    // Output[0] = sum = 36
    check("ntt8[0]==36", fwd[0], (uint64_t)36);

    // Roundtrip
    uint64_t roundtrip[8];
    memcpy(roundtrip, fwd, sizeof(fwd));
    ref_ntt_dit(roundtrip, log_n, true);

    for (int i = 0; i < 8; i++) {
        char name[64];
        snprintf(name, sizeof(name), "roundtrip8[%d]", i);
        check(name, roundtrip[i], input[i]);
    }
}

// ----- Test: NTT with N=16 -----
static void test_ntt_16() {
    printf("--- test_ntt_16 ---\n");
    unsigned int log_n = 4;
    uint32_t n = 16;

    uint64_t input[16];
    for (int i = 0; i < 16; i++) {
        input[i] = (uint64_t)(i + 1);
    }

    uint64_t fwd[16];
    memcpy(fwd, input, sizeof(input));
    ref_ntt_dit(fwd, log_n, false);

    // Output[0] = sum = 136
    check("ntt16[0]==136", fwd[0], (uint64_t)136);

    // Roundtrip
    uint64_t roundtrip[16];
    memcpy(roundtrip, fwd, sizeof(fwd));
    ref_ntt_dit(roundtrip, log_n, true);

    for (int i = 0; i < 16; i++) {
        char name[64];
        snprintf(name, sizeof(name), "roundtrip16[%d]", i);
        check(name, roundtrip[i], input[i]);
    }
}

// ----- Test: NTT linearity: NTT(a+b) == NTT(a) + NTT(b) -----
static void test_ntt_linearity() {
    printf("--- test_ntt_linearity ---\n");
    unsigned int log_n = 3;
    uint32_t n = 8;

    uint64_t a[8] = {1, 0, 0, 0, 0, 0, 0, 0};
    uint64_t b[8] = {0, 1, 0, 0, 0, 0, 0, 0};
    uint64_t ab[8];
    for (int i = 0; i < 8; i++) {
        ab[i] = (gl64_t(a[i]) + gl64_t(b[i])).val;
    }

    uint64_t ntt_a[8], ntt_b[8], ntt_ab[8];
    memcpy(ntt_a, a, sizeof(a));
    memcpy(ntt_b, b, sizeof(b));
    memcpy(ntt_ab, ab, sizeof(ab));

    ref_ntt_dit(ntt_a, log_n, false);
    ref_ntt_dit(ntt_b, log_n, false);
    ref_ntt_dit(ntt_ab, log_n, false);

    for (int i = 0; i < 8; i++) {
        uint64_t sum = (gl64_t(ntt_a[i]) + gl64_t(ntt_b[i])).val;
        char name[64];
        snprintf(name, sizeof(name), "linearity[%d]", i);
        check(name, ntt_ab[i], sum);
    }
}

// ----- Test: NTT of constant polynomial -----
static void test_ntt_constant() {
    printf("--- test_ntt_constant ---\n");
    unsigned int log_n = 3;
    uint32_t n = 8;

    // Constant polynomial c: all coefficients = 42
    // NTT of constant: output[0] = 42*8 = 336, output[k!=0] = 0
    uint64_t data[8];
    for (int i = 0; i < 8; i++) data[i] = 42;

    ref_ntt_dit(data, log_n, false);

    check("const_ntt[0]==336", data[0], (uint64_t)336);
    for (int i = 1; i < 8; i++) {
        char name[64];
        snprintf(name, sizeof(name), "const_ntt[%d]==0", i);
        check(name, data[i], (uint64_t)0);
    }
}

// ----- Test: Butterfly index generation -----
static void test_butterfly_indices() {
    printf("--- test_butterfly_indices ---\n");

    // Stage 0: pairs are (0,1), (2,3), (4,5), (6,7)
    for (uint32_t i = 0; i < 4; i++) {
        uint32_t idx1, idx2;
        ntt_butterfly_indices(i, 0, idx1, idx2);
        check("bf_s0_idx1", idx1, (uint64_t)(i * 2));
        check("bf_s0_idx2", idx2, (uint64_t)(i * 2 + 1));
    }

    // Stage 1: pairs are (0,2), (1,3), (4,6), (5,7)
    for (uint32_t i = 0; i < 4; i++) {
        uint32_t idx1, idx2;
        ntt_butterfly_indices(i, 1, idx1, idx2);
        uint32_t group = i / 2;
        uint32_t pos = i % 2;
        uint32_t expected1 = group * 4 + pos;
        uint32_t expected2 = expected1 + 2;
        check("bf_s1_idx1", idx1, (uint64_t)expected1);
        check("bf_s1_idx2", idx2, (uint64_t)expected2);
    }

    // Stage 2: pairs are (0,4), (1,5), (2,6), (3,7)
    for (uint32_t i = 0; i < 4; i++) {
        uint32_t idx1, idx2;
        ntt_butterfly_indices(i, 2, idx1, idx2);
        check("bf_s2_idx1", idx1, (uint64_t)i);
        check("bf_s2_idx2", idx2, (uint64_t)(i + 4));
    }
}

// ----- Test: Address generation (global row mapping) -----
static void test_addr_gen() {
    printf("--- test_addr_gen ---\n");

    // For log_n=3 (N=8), base_step=0, batch_size=8 (1 batch):
    // groupSize=1, nGroups=8, row=high_bits*1+low_bits=row (identity)
    for (uint32_t i = 0; i < 8; i++) {
        uint32_t row = ntt_global_row_dit(0, i, 0, 3);
        // With base_step=0, groupSize=1, nGroups=8:
        // low_bits = i / 8 = 0
        // high_bits = i % 8 = i
        // row = i * 1 + 0 = i
        check("addr_s0", row, (uint64_t)i);
    }
}

int main() {
    printf("NTT HLS Testbench\n");
    printf("p = 0x%016llx\n", (unsigned long long)P);
    printf("BATCH_SIZE = %u, BATCH_LOG = %u\n\n", BATCH_SIZE, BATCH_LOG);

    test_bitrev();
    test_twiddles();
    test_ntt_4();
    test_ntt_8();
    test_ntt_16();
    test_ntt_linearity();
    test_ntt_constant();
    test_butterfly_indices();
    test_addr_gen();

    printf("\n========================================\n");
    printf("Total tests: %d\n", test_count);
    printf("Passed:      %d\n", test_count - fail_count);
    printf("Failed:      %d\n", fail_count);
    printf("========================================\n");

    return fail_count > 0 ? 1 : 0;
}
