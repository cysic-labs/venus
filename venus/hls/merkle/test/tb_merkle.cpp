// C-Simulation Testbench for Merkle Tree HLS Kernel
//
// Validates bit-exact correctness against a CPU reference implementation.
// Tests:
//   1. Node count calculation
//   2. Small tree construction (9 leaves, arity=3)
//   3. Merkle proof generation and verification
//   4. Edge cases: single leaf, non-divisible leaf counts
//   5. Root extraction

#include "../merkle_tree.hpp"
#include "../merkle_proof.hpp"
#include "../merkle_config.hpp"
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <cstdint>

static const uint64_t P = 0xFFFFFFFF00000001ULL;

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

static void check_bool(const char* name, bool got, bool expected) {
    test_count++;
    if (got != expected) {
        fail_count++;
        printf("FAIL [%s]: got %s, expected %s\n",
               name, got ? "true" : "false", expected ? "true" : "false");
    }
}

// ---- CPU reference: modular arithmetic ----
static uint64_t ref_add(uint64_t a, uint64_t b) {
    __uint128_t s = (__uint128_t)a + b;
    if (s >= P) s -= P;
    return (uint64_t)s;
}

static uint64_t ref_mul(uint64_t a, uint64_t b) {
    __uint128_t prod = (__uint128_t)a * b;
    uint64_t rl = (uint64_t)prod;
    uint64_t rh = (uint64_t)(prod >> 64);
    uint32_t rhh = (uint32_t)(rh >> 32);
    uint32_t rhl = (uint32_t)rh;
    uint64_t aux1;
    if (rl >= rhh) {
        aux1 = rl - rhh;
    } else {
        aux1 = (uint64_t)((__uint128_t)rl + P - rhh);
    }
    uint64_t rhl64 = (uint64_t)rhl;
    uint64_t aux = (rhl64 << 32) - rhl64;
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
    x[0] = ref_add(t3, t5); x[1] = t5; x[2] = ref_add(t2, t4); x[3] = t4;
}

static void ref_matmul_external(uint64_t state[12]) {
    ref_matmul_m4(&state[0]);
    ref_matmul_m4(&state[4]);
    ref_matmul_m4(&state[8]);
    uint64_t stored[4];
    for (int j = 0; j < 4; j++)
        stored[j] = ref_add(ref_add(state[j], state[j+4]), state[j+8]);
    for (int i = 0; i < 12; i++)
        state[i] = ref_add(state[i], stored[i & 3]);
}

// C12 and D12 constants
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

static void ref_hash_full_result(uint64_t state[12]) {
    ref_matmul_external(state);
    for (int r = 0; r < 4; r++) {
        for (int i = 0; i < 12; i++) {
            state[i] = ref_add(state[i], REF_C12[r * 12 + i]);
            ref_pow7(state[i]);
        }
        ref_matmul_external(state);
    }
    for (int r = 0; r < 22; r++) {
        state[0] = ref_add(state[0], REF_C12[48 + r]);
        ref_pow7(state[0]);
        uint64_t sum = 0;
        for (int i = 0; i < 12; i++) sum = ref_add(sum, state[i]);
        for (int i = 0; i < 12; i++) state[i] = ref_add(ref_mul(state[i], REF_D12[i]), sum);
    }
    for (int r = 0; r < 4; r++) {
        for (int i = 0; i < 12; i++) {
            state[i] = ref_add(state[i], REF_C12[70 + r * 12 + i]);
            ref_pow7(state[i]);
        }
        ref_matmul_external(state);
    }
}

static void ref_hash(uint64_t output[4], const uint64_t input[12]) {
    uint64_t state[12];
    memcpy(state, input, 12 * sizeof(uint64_t));
    ref_hash_full_result(state);
    memcpy(output, state, 4 * sizeof(uint64_t));
}

static void ref_linear_hash(uint64_t output[4], const uint64_t* input, unsigned int size) {
    if (size <= 4) {
        for (unsigned int i = 0; i < 4; i++)
            output[i] = (i < size) ? input[i] : 0;
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
        for (unsigned int i = 0; i < 8; i++)
            state[i] = (i < n) ? input[offset + i] : 0;
        ref_hash_full_result(state);
        remaining -= n;
    }
    memcpy(output, state, 4 * sizeof(uint64_t));
}

// CPU reference: build Merkle tree (arity=3)
static void ref_merkle_tree(uint64_t* tree, const uint64_t* source,
                            unsigned int num_cols, unsigned int num_rows) {
    // Phase 1: leaf hashing
    for (unsigned int i = 0; i < num_rows; i++) {
        ref_linear_hash(&tree[i * 4], &source[i * num_cols], num_cols);
    }

    // Phase 2: internal levels
    unsigned int pending = num_rows;
    unsigned int nextIndex = 0;
    unsigned int arity = 3;

    while (pending > 1) {
        unsigned int extraZeros = (arity - (pending % arity)) % arity;
        if (extraZeros > 0) {
            memset(&tree[(nextIndex + pending) * 4], 0,
                   extraZeros * 4 * sizeof(uint64_t));
        }
        unsigned int nextN = (pending + arity - 1) / arity;

        for (unsigned int i = 0; i < nextN; i++) {
            uint64_t input[12];
            memcpy(input, &tree[(nextIndex + i * 12 / 4) * 4],
                   12 * sizeof(uint64_t));
            // Actually: input comes from i*SPONGE_WIDTH offset
            for (unsigned int j = 0; j < 12; j++) {
                input[j] = tree[nextIndex * 4 + i * 12 + j];
            }
            uint64_t output[4];
            ref_hash(output, input);
            unsigned int parent_off = nextIndex + pending + extraZeros + i;
            memcpy(&tree[parent_off * 4], output, 4 * sizeof(uint64_t));
        }

        nextIndex += pending + extraZeros;
        pending = nextN;
    }
}

// ---- Tests ----

static void test_node_count() {
    printf("--- test_node_count ---\n");

    // arity=3, height=9: levels are 9 -> 3 -> 1
    // numNodes = 9 + 0 + 3 + 0 + 1 = 13, elements = 13 * 4 = 52
    unsigned int n = mt_get_num_elements(9, 3);
    check("nodes_9_3", n, 52);

    // arity=3, height=10: levels are 10 -> 4(+2 extra) -> 2(+1 extra) -> 1
    // numNodes = 10 + 2 + 4 + 1 + 2 (+wait, need to recalculate)
    // Level 0: 10 nodes, extraZeros=(3-10%3)%3=(3-1)%3=2, nextN=ceil(10/3)=4
    // Level 1: 4 nodes, extraZeros=(3-4%3)%3=(3-1)%3=2, nextN=ceil(4/3)=2
    // Level 2: 2 nodes, extraZeros=(3-2%3)%3=(3-2)%3=1, nextN=ceil(2/3)=1
    // numNodes = 10 + 2 + 4 + 2 + 2 + 1 + 1 = 22, elements = 22 * 4 = 88
    n = mt_get_num_elements(10, 3);
    check("nodes_10_3", n, 88);

    // arity=3, height=1: single leaf, no tree building needed
    n = mt_get_num_elements(1, 3);
    check("nodes_1_3", n, 4);

    // arity=3, height=3: 3 -> 1
    // numNodes = 3 + 0 + 1 = 4, elements = 16
    n = mt_get_num_elements(3, 3);
    check("nodes_3_3", n, 16);
}

static void test_small_tree() {
    printf("--- test_small_tree ---\n");

    // 9 leaves, 4 columns each (size <= RATE, single hash per leaf)
    const unsigned int NUM_ROWS = 9;
    const unsigned int NUM_COLS = 4;
    const unsigned int ARITY = 3;

    // Create source data
    uint64_t source[NUM_ROWS * NUM_COLS];
    for (unsigned int i = 0; i < NUM_ROWS * NUM_COLS; i++) {
        source[i] = i + 1;
    }

    // Compute reference tree
    unsigned int numElements = mt_get_num_elements(NUM_ROWS, ARITY);
    uint64_t* ref_tree = (uint64_t*)calloc(numElements, sizeof(uint64_t));
    ref_merkle_tree(ref_tree, source, NUM_COLS, NUM_ROWS);

    // Compute HLS tree
    ap_uint<64>* hls_source = (ap_uint<64>*)malloc(NUM_ROWS * NUM_COLS * sizeof(ap_uint<64>));
    ap_uint<64>* hls_tree = (ap_uint<64>*)calloc(numElements, sizeof(ap_uint<64>));

    for (unsigned int i = 0; i < NUM_ROWS * NUM_COLS; i++) {
        hls_source[i] = ap_uint<64>(source[i]);
    }

    mt_merkelize(hls_source, hls_tree, NUM_COLS, NUM_ROWS);

    // Compare leaf hashes
    for (unsigned int i = 0; i < NUM_ROWS * 4; i++) {
        char name[64];
        snprintf(name, sizeof(name), "leaf[%u]", i);
        check(name, (uint64_t)hls_tree[i], ref_tree[i]);
    }

    // Compare all tree nodes
    for (unsigned int i = NUM_ROWS * 4; i < numElements; i++) {
        char name[64];
        snprintf(name, sizeof(name), "node[%u]", i);
        check(name, (uint64_t)hls_tree[i], ref_tree[i]);
    }

    // Verify root matches
    ap_uint<64> hls_root[4];
    mt_get_root(hls_tree, hls_root, NUM_ROWS, ARITY);
    uint64_t ref_root[4];
    memcpy(ref_root, &ref_tree[numElements - 4], 4 * sizeof(uint64_t));

    for (int i = 0; i < 4; i++) {
        char name[64];
        snprintf(name, sizeof(name), "root[%d]", i);
        check(name, (uint64_t)hls_root[i], ref_root[i]);
    }

    free(ref_tree);
    free(hls_source);
    free(hls_tree);
}

static void test_merkle_proof() {
    printf("--- test_merkle_proof ---\n");

    // Build a small tree and generate/verify proofs
    const unsigned int NUM_ROWS = 9;
    const unsigned int NUM_COLS = 4;
    const unsigned int ARITY = 3;

    uint64_t source[NUM_ROWS * NUM_COLS];
    for (unsigned int i = 0; i < NUM_ROWS * NUM_COLS; i++) {
        source[i] = i * 7 + 3;
    }

    unsigned int numElements = mt_get_num_elements(NUM_ROWS, ARITY);
    ap_uint<64>* hls_source = (ap_uint<64>*)malloc(NUM_ROWS * NUM_COLS * sizeof(ap_uint<64>));
    ap_uint<64>* hls_tree = (ap_uint<64>*)calloc(numElements, sizeof(ap_uint<64>));

    for (unsigned int i = 0; i < NUM_ROWS * NUM_COLS; i++) {
        hls_source[i] = ap_uint<64>(source[i]);
    }

    mt_merkelize(hls_source, hls_tree, NUM_COLS, NUM_ROWS);

    // Get root
    gl64_t root[4];
    for (int i = 0; i < 4; i++) {
        root[i] = gl64_t(hls_tree[numElements - 4 + i]);
    }

    // Proof size for arity=3, height=9: 2 levels * 2 siblings * 4 = 16
    unsigned int proof_size = mt_proof_size(NUM_ROWS, ARITY);
    ap_uint<64>* hls_proof = (ap_uint<64>*)calloc(proof_size, sizeof(ap_uint<64>));

    // Test proof for each leaf
    for (unsigned int leaf = 0; leaf < NUM_ROWS; leaf++) {
        mt_gen_proof(hls_tree, hls_proof, leaf, NUM_ROWS, ARITY);

        // Get leaf hash
        gl64_t leaf_hash[4];
        for (int i = 0; i < 4; i++) {
            leaf_hash[i] = gl64_t(hls_tree[leaf * 4 + i]);
        }

        // Convert proof to gl64_t
        gl64_t* proof_gl = (gl64_t*)malloc(proof_size * sizeof(gl64_t));
        for (unsigned int i = 0; i < proof_size; i++) {
            proof_gl[i] = gl64_t(hls_proof[i]);
        }

        bool valid = mt_verify_proof(leaf_hash, proof_gl, leaf,
                                     NUM_ROWS, ARITY, root);

        char name[64];
        snprintf(name, sizeof(name), "proof_leaf_%u", leaf);
        check_bool(name, valid, true);

        free(proof_gl);
    }

    free(hls_proof);
    free(hls_source);
    free(hls_tree);
}

static void test_proof_length() {
    printf("--- test_proof_length ---\n");

    // arity=3, height=9: 9->3->1 = 2 levels
    check("plen_9_3", mt_proof_length(9, 3), 2);

    // arity=3, height=27: 27->9->3->1 = 3 levels
    check("plen_27_3", mt_proof_length(27, 3), 3);

    // arity=3, height=10: 10->4->2->1 = 3 levels
    check("plen_10_3", mt_proof_length(10, 3), 3);

    // arity=3, height=1: 0 levels
    check("plen_1_3", mt_proof_length(1, 3), 0);

    // arity=3, height=3: 3->1 = 1 level
    check("plen_3_3", mt_proof_length(3, 3), 1);

    // Proof sizes (arity=3: 2 siblings per level, 4 elements each)
    check("psize_9_3", mt_proof_size(9, 3), 2 * 2 * 4);
    check("psize_27_3", mt_proof_size(27, 3), 3 * 2 * 4);
}

static void test_single_leaf() {
    printf("--- test_single_leaf ---\n");

    // Single leaf: tree = just the leaf hash, no internal nodes
    const unsigned int NUM_ROWS = 1;
    const unsigned int NUM_COLS = 8;

    uint64_t source[NUM_COLS];
    for (unsigned int i = 0; i < NUM_COLS; i++) {
        source[i] = (i + 1) * 100;
    }

    unsigned int numElements = mt_get_num_elements(NUM_ROWS, 3);
    // numElements should be 1*4=4
    check("single_leaf_elements", numElements, 4);

    ap_uint<64>* hls_source = (ap_uint<64>*)malloc(NUM_COLS * sizeof(ap_uint<64>));
    ap_uint<64>* hls_tree = (ap_uint<64>*)calloc(numElements, sizeof(ap_uint<64>));

    for (unsigned int i = 0; i < NUM_COLS; i++) {
        hls_source[i] = ap_uint<64>(source[i]);
    }

    mt_merkelize(hls_source, hls_tree, NUM_COLS, NUM_ROWS);

    // Compare with CPU linearHash
    uint64_t ref_hash[4];
    ref_linear_hash(ref_hash, source, NUM_COLS);

    for (int i = 0; i < 4; i++) {
        char name[64];
        snprintf(name, sizeof(name), "single_leaf[%d]", i);
        check(name, (uint64_t)hls_tree[i], ref_hash[i]);
    }

    free(hls_source);
    free(hls_tree);
}

int main() {
    printf("Merkle Tree HLS Testbench\n");
    printf("HASH_SIZE=%u, DEFAULT_ARITY=%u\n\n", MT_HASH_SIZE, MT_DEFAULT_ARITY);

    test_node_count();
    test_proof_length();
    test_single_leaf();
    test_small_tree();
    test_merkle_proof();

    printf("\n========================================\n");
    printf("Total tests: %d\n", test_count);
    printf("Passed:      %d\n", test_count - fail_count);
    printf("Failed:      %d\n", fail_count);
    printf("========================================\n");

    return fail_count > 0 ? 1 : 0;
}
