// End-to-End Integration Testbench for Proof Flow
//
// Validates that transcript, FRI fold, and Merkle tree work correctly
// when chained together in the proving flow.
//
// Test cases:
//   1. Full FRI step: absorb -> challenge -> fold -> Merkle -> absorb root
//      Verifies folded polynomial matches step-by-step execution.
//   2. Transcript state consistency after full FRI step.

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <ap_int.h>

// Include all component headers for step-by-step reference
#include "../proof_flow.hpp"

// Forward declare the integration kernel
extern "C" void proof_test_kernel(
    const ap_uint<64>* input_data,
    const ap_uint<64>* friPol,
    ap_uint<64>*       output,
    ap_uint<64>*       challenge_out,
    ap_uint<64>*       state_out,
    ap_uint<64>*       tree_nodes,
    unsigned int       op,
    unsigned int       inputSize,
    unsigned int       prevBits,
    unsigned int       currentBits,
    ap_uint<64>        omega_inv_raw,
    ap_uint<64>        invShift_raw,
    ap_uint<64>        invW_raw
);

// ---- Reference: Goldilocks inverse via Fermat's little theorem ----
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

static uint64_t ref_pow(uint64_t base, uint64_t exp) {
    uint64_t result = 1;
    while (exp > 0) {
        if (exp & 1) result = ref_mul(result, base);
        base = ref_mul(base, base);
        exp >>= 1;
    }
    return result;
}

static uint64_t ref_inv(uint64_t a) {
    return ref_pow(a, REF_P - 2);
}

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

// Roots of unity
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

static const uint64_t SHIFT_VAL = 7;

// =========================================================================
// Test 1: Full FRI step - transcript -> fold -> Merkle -> transcript
//
// This is the core integration test. We run the full FRI step through
// the integration kernel, then run the same operations step-by-step
// using individual component calls, and verify they match.
// =========================================================================
static void test_fri_step_integration() {
    printf("\n--- Test 1: Full FRI step integration ---\n");

    // Parameters: prevBits=3, currentBits=2 => ratio=2, sizeFolded=4
    unsigned int prevBits = 3;
    unsigned int currentBits = 2;
    unsigned int sizePol = 1u << prevBits;       // 8
    unsigned int sizeFolded = 1u << currentBits;  // 4

    // Precompute parameters
    unsigned int logRatio = prevBits - currentBits;
    uint64_t omega_inv_val = ref_inv(ROOTS_RAW[logRatio]);
    uint64_t invShift_val = ref_inv(SHIFT_VAL);
    uint64_t invW_val = ref_inv(ROOTS_RAW[prevBits]);

    // Input data to absorb (simulated Merkle root)
    unsigned int inputSize = 4;
    ap_uint<64> input_data[4] = {0xDEAD, 0xBEEF, 0xCAFE, 0xBABE};

    // Input polynomial: 8 cubic extension elements (24 field values)
    ap_uint<64> friPol[24];
    for (unsigned int i = 0; i < 24; i++) {
        friPol[i] = (uint64_t)(i * 13 + 7) % REF_P;
    }

    // Output buffers for kernel
    ap_uint<64> output_k[12];      // Folded: 4 ext3 elements
    ap_uint<64> challenge_k[3];     // FRI challenge
    ap_uint<64> state_k[4];         // Transcript state

    // Tree nodes buffer (generous)
    unsigned int numTreeElems = mt_get_num_elements(sizeFolded, MT_DEFAULT_ARITY);
    ap_uint<64>* tree_nodes_k = (ap_uint<64>*)calloc(numTreeElems, sizeof(ap_uint<64>));

    memset(output_k, 0, sizeof(output_k));
    memset(challenge_k, 0, sizeof(challenge_k));
    memset(state_k, 0, sizeof(state_k));

    // ---- Run integration kernel ----
    proof_test_kernel(
        input_data, friPol, output_k, challenge_k, state_k, tree_nodes_k,
        0, inputSize, prevBits, currentBits,
        ap_uint<64>(omega_inv_val),
        ap_uint<64>(invShift_val),
        ap_uint<64>(invW_val)
    );

    // ---- Run step-by-step reference ----
    // Step 1: Initialize transcript and absorb
    transcript_state_t ref_tr;
    tr_reset(ref_tr);
    tr_put(ref_tr, input_data, inputSize);

    // Step 2: Get challenge
    ap_uint<64> challenge_ref[3];
    tr_get_field(ref_tr, challenge_ref);

    // Step 3: Fold
    gl64_3_t challenge{
        gl64_t(challenge_ref[0]),
        gl64_t(challenge_ref[1]),
        gl64_t(challenge_ref[2])
    };

    ap_uint<64> output_ref[12];
    memset(output_ref, 0, sizeof(output_ref));
    fri_fold_step<FRI_MAX_FOLD_RATIO>(
        friPol, output_ref, challenge,
        gl64_t(omega_inv_val), gl64_t(invShift_val), gl64_t(invW_val),
        prevBits, currentBits
    );

    // Step 4: Merkle tree over folded result
    ap_uint<64>* tree_nodes_ref = (ap_uint<64>*)calloc(numTreeElems, sizeof(ap_uint<64>));
    mt_merkelize(output_ref, tree_nodes_ref, FRI_FIELD_EXTENSION, sizeFolded);

    // Step 5: Absorb root
    ap_uint<64> root_ref[MT_HASH_SIZE];
    mt_get_root(tree_nodes_ref, root_ref, sizeFolded, MT_DEFAULT_ARITY);
    tr_put(ref_tr, root_ref, MT_HASH_SIZE);

    // Step 6: Get state
    ap_uint<64> state_ref[4];
    tr_get_state(ref_tr, state_ref);

    // ---- Compare results ----

    // Challenge match
    bool ch_ok = true;
    for (int i = 0; i < 3; i++) {
        if ((uint64_t)challenge_k[i] != (uint64_t)challenge_ref[i]) {
            printf("  Challenge mismatch [%d]: kernel=%llu ref=%llu\n",
                i, (unsigned long long)(uint64_t)challenge_k[i],
                (unsigned long long)(uint64_t)challenge_ref[i]);
            ch_ok = false;
        }
    }
    check("FRI challenge matches step-by-step", ch_ok);

    // Folded polynomial match
    bool fold_ok = true;
    for (unsigned int i = 0; i < sizeFolded * 3; i++) {
        if ((uint64_t)output_k[i] != (uint64_t)output_ref[i]) {
            printf("  Fold mismatch [%u]: kernel=%llu ref=%llu\n",
                i, (unsigned long long)(uint64_t)output_k[i],
                (unsigned long long)(uint64_t)output_ref[i]);
            fold_ok = false;
        }
    }
    check("folded polynomial matches step-by-step", fold_ok);

    // Merkle tree match (compare roots)
    ap_uint<64> root_k[MT_HASH_SIZE];
    mt_get_root(tree_nodes_k, root_k, sizeFolded, MT_DEFAULT_ARITY);
    bool tree_ok = true;
    for (int i = 0; i < (int)MT_HASH_SIZE; i++) {
        if ((uint64_t)root_k[i] != (uint64_t)root_ref[i]) {
            printf("  Tree root mismatch [%d]: kernel=%llu ref=%llu\n",
                i, (unsigned long long)(uint64_t)root_k[i],
                (unsigned long long)(uint64_t)root_ref[i]);
            tree_ok = false;
        }
    }
    check("Merkle root matches step-by-step", tree_ok);

    // Transcript state match
    bool state_ok = true;
    for (int i = 0; i < 4; i++) {
        if ((uint64_t)state_k[i] != (uint64_t)state_ref[i]) {
            printf("  State mismatch [%d]: kernel=%llu ref=%llu\n",
                i, (unsigned long long)(uint64_t)state_k[i],
                (unsigned long long)(uint64_t)state_ref[i]);
            state_ok = false;
        }
    }
    check("transcript state matches step-by-step", state_ok);

    free(tree_nodes_k);
    free(tree_nodes_ref);
}

// =========================================================================
// Test 2: Constant polynomial FRI step
//
// A constant polynomial should remain constant after folding.
// This validates the integration with a simple invariant.
// =========================================================================
static void test_constant_fold_integration() {
    printf("\n--- Test 2: Constant polynomial FRI step ---\n");

    unsigned int prevBits = 2;
    unsigned int currentBits = 1;
    unsigned int sizePol = 1u << prevBits;       // 4
    unsigned int sizeFolded = 1u << currentBits;  // 2

    unsigned int logRatio = prevBits - currentBits;
    uint64_t omega_inv_val = ref_inv(ROOTS_RAW[logRatio]);

    // Trivial shift for constant test
    uint64_t invShift_val = 1;
    uint64_t invW_val = 1;

    // Input: simulated root
    ap_uint<64> input_data[4] = {42, 0, 0, 0};

    // Constant polynomial: all elements = (7, 0, 0)
    ap_uint<64> friPol[12];
    for (unsigned int i = 0; i < 4; i++) {
        friPol[i * 3 + 0] = 7;
        friPol[i * 3 + 1] = 0;
        friPol[i * 3 + 2] = 0;
    }

    ap_uint<64> output[6], challenge[3], state[4];
    unsigned int numTreeElems = mt_get_num_elements(sizeFolded, MT_DEFAULT_ARITY);
    ap_uint<64>* tree = (ap_uint<64>*)calloc(numTreeElems, sizeof(ap_uint<64>));

    memset(output, 0, sizeof(output));

    proof_test_kernel(
        input_data, friPol, output, challenge, state, tree,
        0, 4, prevBits, currentBits,
        ap_uint<64>(omega_inv_val),
        ap_uint<64>(invShift_val),
        ap_uint<64>(invW_val)
    );

    // Constant polynomial should fold to same constant
    bool ok = true;
    for (unsigned int i = 0; i < sizeFolded; i++) {
        if ((uint64_t)output[i * 3 + 0] != 7 ||
            (uint64_t)output[i * 3 + 1] != 0 ||
            (uint64_t)output[i * 3 + 2] != 0) {
            printf("  Element %u: (%llu, %llu, %llu) expected (7, 0, 0)\n",
                i, (unsigned long long)(uint64_t)output[i * 3 + 0],
                (unsigned long long)(uint64_t)output[i * 3 + 1],
                (unsigned long long)(uint64_t)output[i * 3 + 2]);
            ok = false;
        }
    }
    check("constant polynomial preserved through FRI step", ok);

    // Challenge should be non-zero (transcript produced a real challenge)
    bool ch_nonzero = (uint64_t)challenge[0] != 0 ||
                      (uint64_t)challenge[1] != 0 ||
                      (uint64_t)challenge[2] != 0;
    check("transcript produced non-zero challenge", ch_nonzero);

    // State should be non-zero
    bool st_nonzero = false;
    for (int i = 0; i < 4; i++) {
        if ((uint64_t)state[i] != 0) st_nonzero = true;
    }
    check("final transcript state is non-zero", st_nonzero);

    free(tree);
}

// =========================================================================
// Main
// =========================================================================
int main() {
    printf("===== Proof Flow Integration Testbench =====\n");

    test_fri_step_integration();
    test_constant_fold_integration();

    printf("\n===== Results: %d passed, %d failed =====\n", g_pass, g_fail);
    return g_fail > 0 ? 1 : 0;
}
