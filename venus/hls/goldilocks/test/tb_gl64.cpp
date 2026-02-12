// C-Simulation Testbench for Goldilocks Field Arithmetic
//
// Validates bit-exact correctness of gl64_t operations against known
// test vectors derived from the CPU reference implementation.
//
// Build: vitis_hls -f run_csim.tcl  (or Makefile csim target)
// Or standalone: g++ -std=c++14 -I$XILINX_HLS/include tb_gl64.cpp -o tb_gl64

#include "../gl64_t.hpp"
#include "../gl64_cubic.hpp"
#include "../gl64_constants.hpp"
#include <cstdio>
#include <cstdlib>
#include <cstdint>

static const uint64_t P = 0xFFFFFFFF00000001ULL;

// Reference CPU multiplication (from goldilocks_base_field_scalar.hpp)
static uint64_t ref_mul(uint64_t a, uint64_t b) {
    __uint128_t res = (__uint128_t)a * (__uint128_t)b;
    uint64_t rl = (uint64_t)res;
    uint64_t rh = (uint64_t)(res >> 64);
    uint64_t rhh = rh >> 32;
    uint64_t rhl = rh & 0xFFFFFFFF;

    uint64_t aux1 = rl - rhh;
    if (rhh > rl) {
        aux1 -= 0xFFFFFFFF;
    }
    uint64_t aux = (uint64_t)0xFFFFFFFF * rhl;

    // Modular add
    uint64_t sum = aux1 + aux;
    if (sum < aux1 || sum >= P) {
        sum -= P;
    }
    // Ensure canonical
    if (sum >= P) sum -= P;
    return sum;
}

// Reference CPU addition
static uint64_t ref_add(uint64_t a, uint64_t b) {
    if (a >= P) a -= P;
    uint64_t sum = a + b;
    if (sum < a || sum >= P) {
        sum -= P;
    }
    if (sum >= P) sum -= P;
    return sum;
}

// Reference CPU subtraction
static uint64_t ref_sub(uint64_t a, uint64_t b) {
    if (b >= P) b -= P;
    if (b <= a) {
        return a - b;
    } else {
        return P - (b - a);
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

// ---- Test: Basic identities ----
static void test_identities() {
    printf("--- test_identities ---\n");
    gl64_t a(42ULL);
    gl64_t z = gl64_t::zero();
    gl64_t o = gl64_t::one();

    check("add(a,0)==a", (a + z).val, a.val);
    check("add(0,a)==a", (z + a).val, a.val);
    check("sub(a,0)==a", (a - z).val, a.val);
    check("mul(a,1)==a", (a * o).val, a.val);
    check("mul(1,a)==a", (o * a).val, a.val);
    check("mul(a,0)==0", (a * z).val, (uint64_t)0);
    check("sub(a,a)==0", (a - a).val, (uint64_t)0);
}

// ---- Test: Boundary values ----
static void test_boundary() {
    printf("--- test_boundary ---\n");
    gl64_t pm1(P - 1);  // p-1
    gl64_t o = gl64_t::one();
    gl64_t z = gl64_t::zero();

    // p-1 + 1 = 0 (mod p)
    check("(p-1)+1==0", (pm1 + o).val, (uint64_t)0);

    // 0 - 1 = p-1
    check("0-1==p-1", (z - o).val, P - 1);

    // (p-1)*(p-1) = 1 (mod p), since (-1)*(-1) = 1
    check("(p-1)*(p-1)==1", (pm1 * pm1).val, (uint64_t)1);

    // neg(0) = 0
    check("neg(0)==0", (-z).val, (uint64_t)0);

    // neg(1) = p-1
    check("neg(1)==p-1", (-o).val, P - 1);
}

// ---- Test: Known CPU test vectors for add ----
static void test_add_vectors() {
    printf("--- test_add_vectors ---\n");
    // gl64_t requires canonical inputs in [0, p-1], so canonicalize first
    // 0xFFFFFFFF00000002 mod p = 1
    uint64_t v1 = 0xFFFFFFFF00000002ULL % P;
    gl64_t a(v1);
    check("add_wrap", (a + a).val, ref_add(v1, v1));

    // 0xFFFFFFFFFFFFFFFF mod p = 0xFFFFFFFE (= p - 2^32 - 2)
    uint64_t v2 = 0xFFFFFFFFFFFFFFFFULL % P;
    gl64_t m(v2);
    check("add_max", (m + m).val, ref_add(v2, v2));

    // Double-carry edge case from CPU test
    gl64_t a1(0xFFFFFFFF00000000ULL);
    gl64_t a2(0x00000000FFFFFFFFULL);
    gl64_t b1 = a1 + a2;
    gl64_t b2 = b1 + b1;
    uint64_t ref_b1 = ref_add(0xFFFFFFFF00000000ULL, 0x00000000FFFFFFFFULL);
    uint64_t ref_b2 = ref_add(ref_b1, ref_b1);
    check("add_double_carry", b2.val, ref_b2);
}

// ---- Test: Multiply with reference cross-check ----
static void test_mul_random() {
    printf("--- test_mul_random ---\n");
    // Deterministic "random" test values
    uint64_t test_vals[] = {
        0, 1, 2, 42, 0xFFFFFFFF, 0x100000000ULL,
        P - 1, P - 2, 0xDEADBEEFCAFEBABEULL,
        0x1234567890ABCDEFULL, 0xFEDCBA0987654321ULL,
        0xFFFFFFFF00000000ULL, 0x00000000FFFFFFFFULL,
        0x8000000000000000ULL, 0x7FFFFFFFFFFFFFFFULL,
        0xFFFFFFFEFFFFFFFFULL  // p-2
    };
    int n = sizeof(test_vals) / sizeof(test_vals[0]);

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            uint64_t a = test_vals[i] % P;  // ensure canonical
            uint64_t b = test_vals[j] % P;
            gl64_t ga(a);
            gl64_t gb(b);
            gl64_t r = ga * gb;
            uint64_t expected = ref_mul(a, b);
            char name[64];
            snprintf(name, sizeof(name), "mul[%d][%d]", i, j);
            check(name, r.val, expected);
        }
    }
}

// ---- Test: Inverse correctness (a * a^(-1) == 1) ----
static void test_inverse() {
    printf("--- test_inverse ---\n");
    uint64_t test_vals[] = {
        1, 2, 3, 7, 42, 0xFFFFFFFF,
        P - 1, P - 2, 0xDEADBEEFCAFEBABEULL % P,
        0x1234567890ABCDEFULL % P
    };
    int n = sizeof(test_vals) / sizeof(test_vals[0]);

    for (int i = 0; i < n; i++) {
        gl64_t a(test_vals[i]);
        gl64_t a_inv = a.reciprocal();
        gl64_t product = a * a_inv;
        char name[64];
        snprintf(name, sizeof(name), "inv[%d]:a*inv(a)==1", i);
        check(name, product.val, (uint64_t)1);
    }
}

// ---- Test: Algebraic properties ----
static void test_algebra() {
    printf("--- test_algebra ---\n");
    gl64_t a(0x1234567890ABCDEFULL % P);
    gl64_t b(0xFEDCBA0987654321ULL % P);
    gl64_t c(42ULL);

    // Commutativity: a+b == b+a, a*b == b*a
    check("add_comm", (a + b).val, (b + a).val);
    check("mul_comm", (a * b).val, (b * a).val);

    // Associativity: (a*b)*c == a*(b*c)
    check("mul_assoc", ((a * b) * c).val, (a * (b * c)).val);

    // Distributivity: a*(b+c) == a*b + a*c
    check("distrib", (a * (b + c)).val, ((a * b) + (a * c)).val);

    // Subtraction: a - b + b == a
    check("sub_add", ((a - b) + b).val, a.val);
}

// ---- Test: Cubic extension multiplication ----
static void test_cubic_mul() {
    printf("--- test_cubic_mul ---\n");
    gl64_3_t a(gl64_t(1ULL), gl64_t(2ULL), gl64_t(3ULL));
    gl64_3_t b(gl64_t(4ULL), gl64_t(5ULL), gl64_t(6ULL));
    gl64_3_t r = a * b;

    // Cross-check with CPU reference Goldilocks3::mul:
    // A = (1+2)*(4+5) = 27
    // B = (1+3)*(4+6) = 40
    // C = (2+3)*(5+6) = 55
    // D = 1*4 = 4
    // E = 2*5 = 10
    // F = 3*6 = 18
    // G = D - E = -6 (mod p) = P - 6
    // result[0] = C + G - F = 55 + (P-6) - 18 = P + 31 = 31 (mod p)
    // result[1] = A + C - E - E - D = 27 + 55 - 10 - 10 - 4 = 58
    // result[2] = B - G = 40 - (P-6) = 46 (mod p)
    check("cubic_mul[0]", r.v[0].val, (uint64_t)31);
    check("cubic_mul[1]", r.v[1].val, (uint64_t)58);
    check("cubic_mul[2]", r.v[2].val, (uint64_t)46);
}

// ---- Test: Cubic extension inverse ----
static void test_cubic_inv() {
    printf("--- test_cubic_inv ---\n");
    gl64_3_t a(gl64_t(7ULL), gl64_t(13ULL), gl64_t(19ULL));
    gl64_3_t a_inv = a.inv();
    gl64_3_t product = a * a_inv;

    check("cubic_inv[0]==1", product.v[0].val, (uint64_t)1);
    check("cubic_inv[1]==0", product.v[1].val, (uint64_t)0);
    check("cubic_inv[2]==0", product.v[2].val, (uint64_t)0);
}

// ---- Test: Cubic scalar multiply ----
static void test_cubic_scalar() {
    printf("--- test_cubic_scalar ---\n");
    gl64_3_t a(gl64_t(10ULL), gl64_t(20ULL), gl64_t(30ULL));
    gl64_t s(5ULL);
    gl64_3_t r = a * s;

    check("cubic_scalar[0]", r.v[0].val, (uint64_t)50);
    check("cubic_scalar[1]", r.v[1].val, (uint64_t)100);
    check("cubic_scalar[2]", r.v[2].val, (uint64_t)150);
}

// ---- Test: Roots of unity consistency ----
static void test_roots() {
    printf("--- test_roots ---\n");
    // w[1]^2 = 1 (w[1] = -1, (-1)^2 = 1)
    gl64_t w1 = gl64_root_of_unity(1);
    check("w1_is_neg1", w1.val, P - 1);
    check("w1^2==1", (w1 * w1).val, (uint64_t)1);

    // w[k]^2 = w[k-1] for all k
    for (int k = 2; k <= 6; k++) {
        gl64_t wk = gl64_root_of_unity(k);
        gl64_t wk_sq = wk * wk;
        gl64_t wk_prev = gl64_root_of_unity(k - 1);
        char name[64];
        snprintf(name, sizeof(name), "w[%d]^2==w[%d]", k, k - 1);
        check(name, wk_sq.val, wk_prev.val);
    }
}

int main() {
    printf("Goldilocks Field Arithmetic HLS Testbench\n");
    printf("p = 0x%016llx\n\n", (unsigned long long)P);

    test_identities();
    test_boundary();
    test_add_vectors();
    test_mul_random();
    test_inverse();
    test_algebra();
    test_cubic_mul();
    test_cubic_inv();
    test_cubic_scalar();
    test_roots();

    printf("\n========================================\n");
    printf("Total tests: %d\n", test_count);
    printf("Passed:      %d\n", test_count - fail_count);
    printf("Failed:      %d\n", fail_count);
    printf("========================================\n");

    return fail_count > 0 ? 1 : 0;
}
