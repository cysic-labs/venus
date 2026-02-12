// C-Simulation Testbench for Poseidon2 HLS Kernel
//
// Validates bit-exact correctness against a CPU reference implementation.
// Tests:
//   1. matmul_m4 correctness
//   2. matmul_external correctness
//   3. pow7 (S-box) correctness
//   4. Full permutation with known input
//   5. Linear hash (sponge mode) with various sizes
//   6. Hash capacity-only output
//   7. Zero input and identity checks
//
// Build: make csim  (or standalone: g++ -std=c++14 -I$XILINX_HLS/include ...)

#include "../poseidon2_core.hpp"
#include "../poseidon2_linear_hash.hpp"
#include "../poseidon2_constants.hpp"
#include <cstdio>
#include <cstring>
#include <cstdint>

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

// ---- CPU reference implementation (matching poseidon2_goldilocks.cpp) ----
static const uint64_t P = 0xFFFFFFFF00000001ULL;

// CPU modular arithmetic for reference
static uint64_t ref_add(uint64_t a, uint64_t b) {
    __uint128_t s = (__uint128_t)a + b;
    if (s >= P) s -= P;
    return (uint64_t)s;
}

static uint64_t ref_sub(uint64_t a, uint64_t b) {
    if (a >= b) return a - b;
    return (uint64_t)((__uint128_t)a + P - b);
}

static uint64_t ref_mul(uint64_t a, uint64_t b) {
    __uint128_t prod = (__uint128_t)a * b;
    uint64_t rl = (uint64_t)prod;
    uint64_t rh = (uint64_t)(prod >> 64);
    uint32_t rhh = (uint32_t)(rh >> 32);
    uint32_t rhl = (uint32_t)rh;

    // aux1 = rl - rhh (mod p)
    uint64_t aux1;
    if (rl >= rhh) {
        aux1 = rl - rhh;
    } else {
        aux1 = (uint64_t)((__uint128_t)rl + P - rhh);
    }

    // aux = 0xFFFFFFFF * rhl = (rhl << 32) - rhl
    uint64_t rhl64 = (uint64_t)rhl;
    uint64_t aux = (rhl64 << 32) - rhl64;

    // result = (aux1 + aux) mod p
    __uint128_t sum = (__uint128_t)aux1 + aux;
    if (sum >= P) sum -= P;
    return (uint64_t)sum;
}

static void ref_pow7(uint64_t& x) {
    uint64_t x2 = ref_mul(x, x);
    uint64_t x3 = ref_mul(x, x2);
    uint64_t x4 = ref_mul(x2, x2);
    x = ref_mul(x3, x4);
}

static void ref_matmul_m4(uint64_t x[4]) {
    uint64_t t0 = ref_add(x[0], x[1]);
    uint64_t t1 = ref_add(x[2], x[3]);
    uint64_t t2 = ref_add(ref_add(x[1], x[1]), t1);
    uint64_t t3 = ref_add(ref_add(x[3], x[3]), t0);
    uint64_t t1_2 = ref_add(t1, t1);
    uint64_t t0_2 = ref_add(t0, t0);
    uint64_t t4 = ref_add(ref_add(t1_2, t1_2), t3);
    uint64_t t5 = ref_add(ref_add(t0_2, t0_2), t2);
    uint64_t t6 = ref_add(t3, t5);
    uint64_t t7 = ref_add(t2, t4);
    x[0] = t6; x[1] = t5; x[2] = t7; x[3] = t4;
}

static void ref_matmul_external(uint64_t state[12]) {
    ref_matmul_m4(&state[0]);
    ref_matmul_m4(&state[4]);
    ref_matmul_m4(&state[8]);

    uint64_t stored[4];
    for (int j = 0; j < 4; j++) {
        stored[j] = ref_add(ref_add(state[j], state[j+4]), state[j+8]);
    }
    for (int i = 0; i < 12; i++) {
        state[i] = ref_add(state[i], stored[i & 3]);
    }
}

// C12 and D12 constants as raw uint64_t for CPU reference
static const uint64_t REF_C12[118] = {
    0x13dcf33aba214f46ULL, 0x30b3b654a1da6d83ULL, 0x1fc634ada6159b56ULL,
    0x937459964dc03466ULL, 0xedd2ef2ca7949924ULL, 0xede9affde0e22f68ULL,
    0x8515b9d6bac9282dULL, 0x6b5c07b4e9e900d8ULL, 0x1ec66368838c8a08ULL,
    0x9042367d80d1fbabULL, 0x400283564a3c3799ULL, 0x4a00be0466bca75eULL,
    0x7913beee58e3817fULL, 0xf545e88532237d90ULL, 0x22f8cb8736042005ULL,
    0x6f04990e247a2623ULL, 0xfe22e87ba37c38cdULL, 0xd20e32c85ffe2815ULL,
    0x117227674048fe73ULL, 0x4e9fb7ea98a6b145ULL, 0xe0866c232b8af08bULL,
    0x00bbc77916884964ULL, 0x7031c0fb990d7116ULL, 0x240a9e87cf35108fULL,
    0x2e6363a5a12244b3ULL, 0x5e1c3787d1b5011cULL, 0x4132660e2a196e8bULL,
    0x3a013b648d3d4327ULL, 0xf79839f49888ea43ULL, 0xfe85658ebafe1439ULL,
    0xb6889825a14240bdULL, 0x578453605541382bULL, 0x4508cda8f6b63ce9ULL,
    0x9c3ef35848684c91ULL, 0x0812bde23c87178cULL, 0xfe49638f7f722c14ULL,
    0x8e3f688ce885cbf5ULL, 0xb8e110acf746a87dULL, 0xb4b2e8973a6dabefULL,
    0x9e714c5da3d462ecULL, 0x6438f9033d3d0c15ULL, 0x24312f7cf1a27199ULL,
    0x23f843bb47acbf71ULL, 0x9183f11a34be9f01ULL, 0x839062fbb9d45dbfULL,
    0x24b56e7e6c2e43faULL, 0xe1683da61c962a72ULL, 0xa95c63971a19bfa7ULL,
    0x4adf842aa75d4316ULL, 0xf8fbb871aa4ab4ebULL, 0x68e85b6eb2dd6aebULL,
    0x07a0b06b2d270380ULL, 0xd94e0228bd282de4ULL, 0x8bdd91d3250c5278ULL,
    0x209c68b88bba778fULL, 0xb5e18cdab77f3877ULL, 0xb296a3e808da93faULL,
    0x8370ecbda11a327eULL, 0x3f9075283775dad8ULL, 0xb78095bb23c6aa84ULL,
    0x3f36b9fe72ad4e5fULL, 0x69bc96780b10b553ULL, 0x3f1d341f2eb7b881ULL,
    0x4e939e9815838818ULL, 0xda366b3ae2a31604ULL, 0xbc89db1e7287d509ULL,
    0x6102f411f9ef5659ULL, 0x58725c5e7ac1f0abULL, 0x0df5856c798883e7ULL,
    0xf7bb62a8da4c961bULL, 0xc68be7c94882a24dULL, 0xaf996d5d5cdaedd9ULL,
    0x9717f025e7daf6a5ULL, 0x6436679e6e7216f4ULL, 0x8a223d99047af267ULL,
    0xbb512e35a133ba9aULL, 0xfbbf44097671aa03ULL, 0xf04058ebf6811e61ULL,
    0x5cca84703fac7ffbULL, 0x9b55c7945de6469fULL, 0x8e05bf09808e934fULL,
    0x2ea900de876307d7ULL, 0x7748fff2b38dfb89ULL, 0x6b99a676dd3b5d81ULL,
    0xac4bb7c627cf7c13ULL, 0xadb6ebe5e9e2f5baULL, 0x2d33378cafa24ae3ULL,
    0x1e5b73807543f8c2ULL, 0x09208814bfebb10fULL, 0x782e64b6bb5b93ddULL,
    0xadd5a48eac90b50fULL, 0xadd4c54c736ea4b1ULL, 0xd58dbb86ed817fd8ULL,
    0x6d5ed1a533f34dddULL, 0x28686aa3e36b7cb9ULL, 0x591abd3476689f36ULL,
    0x047d766678f13875ULL, 0xa2a11112625f5b49ULL, 0x21fd10a3f8304958ULL,
    0xf9b40711443b0280ULL, 0xd2697eb8b2bde88eULL, 0x3493790b51731b3fULL,
    0x11caf9dd73764023ULL, 0x7acfb8f72878164eULL, 0x744ec4db23cefc26ULL,
    0x1e00e58f422c6340ULL, 0x21dd28d906a62ddaULL, 0xf32a46ab5f465b5fULL,
    0xbfce13201f3f7e6bULL, 0xf30d2e7adb5304e2ULL, 0xecdf4ee4abad48e9ULL,
    0xf94e82182d395019ULL, 0x4ee52e3744d887c5ULL, 0xa1341c7cac0083b2ULL,
    0x2302fb26c30c834aULL, 0xaea3c587273bf7d3ULL, 0xf798e24961823ec7ULL,
    0x962deba3e9a2cd94ULL
};

static const uint64_t REF_D12[12] = {
    0xc3b6c08e23ba9300ULL, 0xd84b5de94a324fb6ULL, 0x0d0c371c5b35b84fULL,
    0x7964f570e7188037ULL, 0x5daf18bbd996604bULL, 0x6743bc47b9595257ULL,
    0x5528b9362c59bb70ULL, 0xac45e25b7127b68bULL, 0xa2077d7dfbb606b5ULL,
    0xf3faac6faee378aeULL, 0x0c6388b51545e883ULL, 0xd27dbb6944917b60ULL
};

// Full CPU reference Poseidon2 permutation
static void ref_hash_full_result(uint64_t state[12]) {
    ref_matmul_external(state);

    // First 4 full rounds
    for (int r = 0; r < 4; r++) {
        for (int i = 0; i < 12; i++) {
            state[i] = ref_add(state[i], REF_C12[r * 12 + i]);
            ref_pow7(state[i]);
        }
        ref_matmul_external(state);
    }

    // 22 partial rounds
    for (int r = 0; r < 22; r++) {
        state[0] = ref_add(state[0], REF_C12[4 * 12 + r]);
        ref_pow7(state[0]);
        uint64_t sum = 0;
        for (int i = 0; i < 12; i++) {
            sum = ref_add(sum, state[i]);
        }
        for (int i = 0; i < 12; i++) {
            state[i] = ref_add(ref_mul(state[i], REF_D12[i]), sum);
        }
    }

    // Last 4 full rounds
    for (int r = 0; r < 4; r++) {
        for (int i = 0; i < 12; i++) {
            state[i] = ref_add(state[i], REF_C12[4 * 12 + 22 + r * 12 + i]);
            ref_pow7(state[i]);
        }
        ref_matmul_external(state);
    }
}

// CPU reference linear hash
static void ref_linear_hash(uint64_t output[4], const uint64_t* input, unsigned int size) {
    if (size <= 4) {
        for (unsigned int i = 0; i < 4; i++) {
            output[i] = (i < size) ? input[i] : 0;
        }
        return;
    }

    uint64_t state[12];
    unsigned int remaining = size;
    bool first = true;

    while (remaining > 0) {
        if (first) {
            memset(&state[8], 0, 4 * sizeof(uint64_t));
            first = false;
        } else {
            memcpy(&state[8], &state[0], 4 * sizeof(uint64_t));
        }

        unsigned int n = (remaining < 8) ? remaining : 8;
        unsigned int offset = size - remaining;

        for (unsigned int i = 0; i < 8; i++) {
            state[i] = (i < n) ? input[offset + i] : 0;
        }

        ref_hash_full_result(state);
        remaining -= n;
    }

    memcpy(output, state, 4 * sizeof(uint64_t));
}

// ---- Tests ----

static void test_matmul_m4() {
    printf("--- test_matmul_m4 ---\n");

    // Test with simple input
    gl64_t hls_x[4] = {gl64_t(1ULL), gl64_t(2ULL), gl64_t(3ULL), gl64_t(4ULL)};
    uint64_t ref_x[4] = {1, 2, 3, 4};

    p2_matmul_m4(hls_x);
    ref_matmul_m4(ref_x);

    for (int i = 0; i < 4; i++) {
        char name[64];
        snprintf(name, sizeof(name), "m4[%d]", i);
        check(name, (uint64_t)hls_x[i].val, ref_x[i]);
    }

    // Test with large field elements
    gl64_t hls_y[4] = {
        gl64_t(0xABCDEF0123456789ULL),
        gl64_t(0x1234567890ABCDEFULL),
        gl64_t(0xFEDCBA9876543210ULL),
        gl64_t(0x0123456789ABCDEFULL)
    };
    uint64_t ref_y[4] = {
        0xABCDEF0123456789ULL,
        0x1234567890ABCDEFULL,
        0xFEDCBA9876543210ULL,
        0x0123456789ABCDEFULL
    };

    p2_matmul_m4(hls_y);
    ref_matmul_m4(ref_y);

    for (int i = 0; i < 4; i++) {
        char name[64];
        snprintf(name, sizeof(name), "m4_large[%d]", i);
        check(name, (uint64_t)hls_y[i].val, ref_y[i]);
    }
}

static void test_matmul_external() {
    printf("--- test_matmul_external ---\n");

    gl64_t hls_state[12];
    uint64_t ref_state[12];
    for (int i = 0; i < 12; i++) {
        hls_state[i] = gl64_t((uint64_t)(i + 1));
        ref_state[i] = (uint64_t)(i + 1);
    }

    p2_matmul_external(hls_state);
    ref_matmul_external(ref_state);

    for (int i = 0; i < 12; i++) {
        char name[64];
        snprintf(name, sizeof(name), "ext[%d]", i);
        check(name, (uint64_t)hls_state[i].val, ref_state[i]);
    }
}

static void test_pow7() {
    printf("--- test_pow7 ---\n");

    // Test x^7 for several values
    uint64_t test_vals[] = {0, 1, 2, 3, 7, 42, 0x123456789ABCDEFULL};
    int n_vals = sizeof(test_vals) / sizeof(test_vals[0]);

    for (int t = 0; t < n_vals; t++) {
        gl64_t hls_x(test_vals[t]);
        uint64_t ref_x = test_vals[t];

        p2_pow7(hls_x);
        ref_pow7(ref_x);

        char name[64];
        snprintf(name, sizeof(name), "pow7(%llu)", (unsigned long long)test_vals[t]);
        check(name, (uint64_t)hls_x.val, ref_x);
    }
}

static void test_full_permutation() {
    printf("--- test_full_permutation ---\n");

    // Test 1: Sequential input [0, 1, 2, ..., 11]
    gl64_t hls_state[12];
    uint64_t ref_state[12];
    for (int i = 0; i < 12; i++) {
        hls_state[i] = gl64_t((uint64_t)i);
        ref_state[i] = (uint64_t)i;
    }

    p2_hash_full_result(hls_state);
    ref_hash_full_result(ref_state);

    for (int i = 0; i < 12; i++) {
        char name[64];
        snprintf(name, sizeof(name), "perm_seq[%d]", i);
        check(name, (uint64_t)hls_state[i].val, ref_state[i]);
    }

    // Test 2: All-ones input
    for (int i = 0; i < 12; i++) {
        hls_state[i] = gl64_t(1ULL);
        ref_state[i] = 1;
    }

    p2_hash_full_result(hls_state);
    ref_hash_full_result(ref_state);

    for (int i = 0; i < 12; i++) {
        char name[64];
        snprintf(name, sizeof(name), "perm_ones[%d]", i);
        check(name, (uint64_t)hls_state[i].val, ref_state[i]);
    }

    // Test 3: All-zeros input
    for (int i = 0; i < 12; i++) {
        hls_state[i] = gl64_t::zero();
        ref_state[i] = 0;
    }

    p2_hash_full_result(hls_state);
    ref_hash_full_result(ref_state);

    for (int i = 0; i < 12; i++) {
        char name[64];
        snprintf(name, sizeof(name), "perm_zeros[%d]", i);
        check(name, (uint64_t)hls_state[i].val, ref_state[i]);
    }

    // Test 4: Large field elements
    for (int i = 0; i < 12; i++) {
        uint64_t v = 0xFFFFFFFF00000000ULL + i; // near p
        hls_state[i] = gl64_t(v);
        ref_state[i] = v;
    }

    p2_hash_full_result(hls_state);
    ref_hash_full_result(ref_state);

    for (int i = 0; i < 12; i++) {
        char name[64];
        snprintf(name, sizeof(name), "perm_large[%d]", i);
        check(name, (uint64_t)hls_state[i].val, ref_state[i]);
    }
}

static void test_hash_capacity() {
    printf("--- test_hash_capacity ---\n");

    // p2_hash should return only capacity (first 4 elements)
    gl64_t input[12];
    for (int i = 0; i < 12; i++) {
        input[i] = gl64_t((uint64_t)(i * 100 + 42));
    }

    gl64_t hls_out[4];
    p2_hash(hls_out, input);

    // Compare against full permutation
    gl64_t full_state[12];
    for (int i = 0; i < 12; i++) {
        full_state[i] = gl64_t((uint64_t)(i * 100 + 42));
    }
    p2_hash_full_result(full_state);

    for (int i = 0; i < 4; i++) {
        char name[64];
        snprintf(name, sizeof(name), "cap[%d]", i);
        check(name, (uint64_t)hls_out[i].val, (uint64_t)full_state[i].val);
    }
}

static void test_linear_hash() {
    printf("--- test_linear_hash ---\n");

    // Test 1: Short input (size <= CAPACITY = 4)
    {
        gl64_t input[3] = {gl64_t(10ULL), gl64_t(20ULL), gl64_t(30ULL)};
        uint64_t ref_in[3] = {10, 20, 30};
        gl64_t hls_out[4];
        uint64_t ref_out[4];

        p2_linear_hash<16>(hls_out, input, 3);
        ref_linear_hash(ref_out, ref_in, 3);

        for (int i = 0; i < 4; i++) {
            char name[64];
            snprintf(name, sizeof(name), "lh_short[%d]", i);
            check(name, (uint64_t)hls_out[i].val, ref_out[i]);
        }
    }

    // Test 2: Exactly RATE=8 elements (one permutation)
    {
        gl64_t input[8];
        uint64_t ref_in[8];
        for (int i = 0; i < 8; i++) {
            input[i] = gl64_t((uint64_t)(i + 1));
            ref_in[i] = (uint64_t)(i + 1);
        }

        gl64_t hls_out[4];
        uint64_t ref_out[4];

        p2_linear_hash<16>(hls_out, input, 8);
        ref_linear_hash(ref_out, ref_in, 8);

        for (int i = 0; i < 4; i++) {
            char name[64];
            snprintf(name, sizeof(name), "lh_rate[%d]", i);
            check(name, (uint64_t)hls_out[i].val, ref_out[i]);
        }
    }

    // Test 3: 12 elements (needs 2 permutations: 8 + 4)
    {
        gl64_t input[12];
        uint64_t ref_in[12];
        for (int i = 0; i < 12; i++) {
            input[i] = gl64_t((uint64_t)(i * 7 + 3));
            ref_in[i] = (uint64_t)(i * 7 + 3);
        }

        gl64_t hls_out[4];
        uint64_t ref_out[4];

        p2_linear_hash<16>(hls_out, input, 12);
        ref_linear_hash(ref_out, ref_in, 12);

        for (int i = 0; i < 4; i++) {
            char name[64];
            snprintf(name, sizeof(name), "lh_12[%d]", i);
            check(name, (uint64_t)hls_out[i].val, ref_out[i]);
        }
    }

    // Test 4: 20 elements (needs 3 permutations: 8 + 8 + 4)
    {
        gl64_t input[20];
        uint64_t ref_in[20];
        for (int i = 0; i < 20; i++) {
            input[i] = gl64_t((uint64_t)(i * 13 + 5));
            ref_in[i] = (uint64_t)(i * 13 + 5);
        }

        gl64_t hls_out[4];
        uint64_t ref_out[4];

        p2_linear_hash<32>(hls_out, input, 20);
        ref_linear_hash(ref_out, ref_in, 20);

        for (int i = 0; i < 4; i++) {
            char name[64];
            snprintf(name, sizeof(name), "lh_20[%d]", i);
            check(name, (uint64_t)hls_out[i].val, ref_out[i]);
        }
    }

    // Test 5: Exactly 4 elements (boundary: size == CAPACITY)
    {
        gl64_t input[4] = {gl64_t(100ULL), gl64_t(200ULL), gl64_t(300ULL), gl64_t(400ULL)};
        uint64_t ref_in[4] = {100, 200, 300, 400};
        gl64_t hls_out[4];
        uint64_t ref_out[4];

        p2_linear_hash<16>(hls_out, input, 4);
        ref_linear_hash(ref_out, ref_in, 4);

        for (int i = 0; i < 4; i++) {
            char name[64];
            snprintf(name, sizeof(name), "lh_4[%d]", i);
            check(name, (uint64_t)hls_out[i].val, ref_out[i]);
        }
    }

    // Test 6: 5 elements (just over CAPACITY, needs hash)
    {
        gl64_t input[5] = {
            gl64_t(10ULL), gl64_t(20ULL), gl64_t(30ULL),
            gl64_t(40ULL), gl64_t(50ULL)
        };
        uint64_t ref_in[5] = {10, 20, 30, 40, 50};
        gl64_t hls_out[4];
        uint64_t ref_out[4];

        p2_linear_hash<16>(hls_out, input, 5);
        ref_linear_hash(ref_out, ref_in, 5);

        for (int i = 0; i < 4; i++) {
            char name[64];
            snprintf(name, sizeof(name), "lh_5[%d]", i);
            check(name, (uint64_t)hls_out[i].val, ref_out[i]);
        }
    }
}

static void test_constants() {
    printf("--- test_constants ---\n");

    // Verify HLS constants match reference
    for (int i = 0; i < 118; i++) {
        char name[64];
        snprintf(name, sizeof(name), "C12[%d]", i);
        check(name, (uint64_t)P2_C12[i].val, REF_C12[i]);
    }

    for (int i = 0; i < 12; i++) {
        char name[64];
        snprintf(name, sizeof(name), "D12[%d]", i);
        check(name, (uint64_t)P2_D12[i].val, REF_D12[i]);
    }
}

int main() {
    printf("Poseidon2 HLS Testbench\n");
    printf("SPONGE_WIDTH=%u, CAPACITY=%u, RATE=%u\n",
           P2_SPONGE_WIDTH, P2_CAPACITY, P2_RATE);
    printf("FULL_ROUNDS=%u, PARTIAL_ROUNDS=%u, TOTAL=%u\n",
           P2_FULL_ROUNDS_TOTAL, P2_PARTIAL_ROUNDS, P2_TOTAL_ROUNDS);
    printf("NUM_C=%u\n\n", P2_NUM_C);

    test_constants();
    test_matmul_m4();
    test_matmul_external();
    test_pow7();
    test_full_permutation();
    test_hash_capacity();
    test_linear_hash();

    printf("\n========================================\n");
    printf("Total tests: %d\n", test_count);
    printf("Passed:      %d\n", test_count - fail_count);
    printf("Failed:      %d\n", fail_count);
    printf("========================================\n");

    return fail_count > 0 ? 1 : 0;
}
