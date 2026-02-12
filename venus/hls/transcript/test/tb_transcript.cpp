// Transcript (Fiat-Shamir) HLS Testbench
//
// Tests for the Poseidon2-based sponge transcript.
// Uses a reference implementation of the sponge to verify correctness.
//
// Test cases:
//   1. Put 4 elements + getField (no sponge overflow)
//   2. Put 8 elements + getField (exact rate fill)
//   3. Put 12 elements + getField (rate overflow)
//   4. getState after absorption
//   5. Multi-round: put, getField, put, getField
//   6. getPermutations (query generation)
//   7. Empty put + getField (immediate squeeze)

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <cmath>

#include <ap_int.h>

#include "../transcript.hpp"

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

// ---- Reference Poseidon2 (reuse HLS implementation directly) ----
// We test by running both the HLS transcript and a manual reference
// using the same Poseidon2 core, so the test validates the sponge
// logic (state management, padding, cursor tracking) rather than
// re-implementing Poseidon2 in software.
//
// The reference transcript operates on gl64_t directly.

struct ref_transcript {
    gl64_t state[12];
    gl64_t pending[8];
    gl64_t out[12];
    unsigned int pending_cursor;
    unsigned int out_cursor;
};

static void ref_reset(ref_transcript& tr) {
    for (int i = 0; i < 12; i++) {
        tr.state[i] = gl64_t::zero();
        tr.out[i] = gl64_t::zero();
    }
    for (int i = 0; i < 8; i++) tr.pending[i] = gl64_t::zero();
    tr.pending_cursor = 0;
    tr.out_cursor = 0;
}

static void ref_update_state(ref_transcript& tr) {
    // Pad pending
    while (tr.pending_cursor < 8) {
        tr.pending[tr.pending_cursor] = gl64_t::zero();
        tr.pending_cursor++;
    }

    // Build input: pending[0:7] || state[0:3]
    gl64_t inputs[12];
    for (int i = 0; i < 8; i++) inputs[i] = tr.pending[i];
    for (int i = 0; i < 4; i++) inputs[8 + i] = tr.state[i];

    // Poseidon2 full hash (in-place)
    p2_hash_full_result(inputs);

    // Update
    for (int i = 0; i < 12; i++) {
        tr.out[i] = inputs[i];
        tr.state[i] = inputs[i];
    }
    tr.out_cursor = 12;
    tr.pending_cursor = 0;
    for (int i = 0; i < 8; i++) tr.pending[i] = gl64_t::zero();
}

static void ref_add1(ref_transcript& tr, gl64_t input) {
    tr.pending[tr.pending_cursor] = input;
    tr.pending_cursor++;
    tr.out_cursor = 0;
    if (tr.pending_cursor == 8) {
        ref_update_state(tr);
    }
}

static void ref_put(ref_transcript& tr, const uint64_t* vals, unsigned int n) {
    for (unsigned int i = 0; i < n; i++) {
        ref_add1(tr, gl64_t(vals[i]));
    }
}

static gl64_t ref_get_field1(ref_transcript& tr) {
    if (tr.out_cursor == 0) {
        ref_update_state(tr);
    }
    gl64_t res = tr.out[(12 - tr.out_cursor) % 12];
    tr.out_cursor--;
    return res;
}

static void ref_get_field(ref_transcript& tr, uint64_t output[3]) {
    for (int i = 0; i < 3; i++) {
        output[i] = (uint64_t)ref_get_field1(tr).val;
    }
}

static void ref_get_state(ref_transcript& tr, uint64_t output[4]) {
    if (tr.pending_cursor > 0) {
        ref_update_state(tr);
    }
    for (int i = 0; i < 4; i++) {
        output[i] = (uint64_t)tr.state[i].val;
    }
}

static void ref_get_permutations(ref_transcript& tr, unsigned int* queries,
                                  unsigned int nQueries, unsigned int nBits) {
    unsigned int totalBits = nQueries * nBits;
    unsigned int nFields = (totalBits > 0) ? ((totalBits - 1) / 63 + 1) : 0;

    uint64_t fields[64];
    for (unsigned int i = 0; i < nFields; i++) {
        fields[i] = (uint64_t)ref_get_field1(tr).val;
    }

    unsigned int curField = 0;
    unsigned int curBit = 0;
    for (unsigned int i = 0; i < nQueries; i++) {
        unsigned int a = 0;
        for (unsigned int j = 0; j < nBits; j++) {
            unsigned int bit = (fields[curField] >> curBit) & 1;
            if (bit) a |= (1u << j);
            curBit++;
            if (curBit == 63) {
                curBit = 0;
                curField++;
            }
        }
        queries[i] = a;
    }
}

// ---- Kernel declaration ----
extern "C" void transcript_test_kernel(
    const ap_uint<64>* input,
    ap_uint<64>*       output,
    unsigned int*      queries,
    unsigned int       op,
    unsigned int       inputSize,
    unsigned int       nQueries,
    unsigned int       nBits,
    unsigned int       inputSize2
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

// =========================================================================
// Test 1: Put 4 elements + getField
// =========================================================================
static void test_put4_getfield() {
    printf("\n--- Test 1: Put 4 elements + getField ---\n");

    uint64_t vals[4] = {1, 2, 3, 4};
    ap_uint<64> input[4], output[3];
    for (int i = 0; i < 4; i++) input[i] = vals[i];
    unsigned int queries_dummy[1] = {0};

    transcript_test_kernel(input, output, queries_dummy, 0, 4, 0, 0, 0);

    // Reference
    ref_transcript ref;
    ref_reset(ref);
    ref_put(ref, vals, 4);
    uint64_t ref_out[3];
    ref_get_field(ref, ref_out);

    bool ok = true;
    for (int i = 0; i < 3; i++) {
        if ((uint64_t)output[i] != ref_out[i]) {
            printf("  Mismatch at [%d]: HLS=%llu ref=%llu\n",
                i, (unsigned long long)(uint64_t)output[i],
                (unsigned long long)ref_out[i]);
            ok = false;
        }
    }
    check("put(4) + getField", ok);
}

// =========================================================================
// Test 2: Put 8 elements (exact rate) + getField
// =========================================================================
static void test_put8_getfield() {
    printf("\n--- Test 2: Put 8 elements (exact rate) + getField ---\n");

    uint64_t vals[8] = {10, 20, 30, 40, 50, 60, 70, 80};
    ap_uint<64> input[8], output[3];
    for (int i = 0; i < 8; i++) input[i] = vals[i];
    unsigned int queries_dummy[1] = {0};

    transcript_test_kernel(input, output, queries_dummy, 0, 8, 0, 0, 0);

    ref_transcript ref;
    ref_reset(ref);
    ref_put(ref, vals, 8);
    uint64_t ref_out[3];
    ref_get_field(ref, ref_out);

    bool ok = true;
    for (int i = 0; i < 3; i++) {
        if ((uint64_t)output[i] != ref_out[i]) {
            printf("  Mismatch at [%d]: HLS=%llu ref=%llu\n",
                i, (unsigned long long)(uint64_t)output[i],
                (unsigned long long)ref_out[i]);
            ok = false;
        }
    }
    check("put(8) + getField", ok);
}

// =========================================================================
// Test 3: Put 12 elements (rate overflow) + getField
// =========================================================================
static void test_put12_getfield() {
    printf("\n--- Test 3: Put 12 elements (rate overflow) + getField ---\n");

    uint64_t vals[12];
    for (int i = 0; i < 12; i++) vals[i] = (i + 1) * 100;
    ap_uint<64> input[12], output[3];
    for (int i = 0; i < 12; i++) input[i] = vals[i];
    unsigned int queries_dummy[1] = {0};

    transcript_test_kernel(input, output, queries_dummy, 0, 12, 0, 0, 0);

    ref_transcript ref;
    ref_reset(ref);
    ref_put(ref, vals, 12);
    uint64_t ref_out[3];
    ref_get_field(ref, ref_out);

    bool ok = true;
    for (int i = 0; i < 3; i++) {
        if ((uint64_t)output[i] != ref_out[i]) {
            printf("  Mismatch at [%d]: HLS=%llu ref=%llu\n",
                i, (unsigned long long)(uint64_t)output[i],
                (unsigned long long)ref_out[i]);
            ok = false;
        }
    }
    check("put(12) + getField", ok);
}

// =========================================================================
// Test 4: getState after absorption
// =========================================================================
static void test_getstate() {
    printf("\n--- Test 4: getState after absorption ---\n");

    uint64_t vals[4] = {0xABCDEF, 0x123456, 0x789ABC, 0xDEF012};
    ap_uint<64> input[4], output[4];
    for (int i = 0; i < 4; i++) input[i] = vals[i];
    unsigned int queries_dummy[1] = {0};

    transcript_test_kernel(input, output, queries_dummy, 1, 4, 0, 0, 0);

    ref_transcript ref;
    ref_reset(ref);
    ref_put(ref, vals, 4);
    uint64_t ref_out[4];
    ref_get_state(ref, ref_out);

    bool ok = true;
    for (int i = 0; i < 4; i++) {
        if ((uint64_t)output[i] != ref_out[i]) {
            printf("  Mismatch at [%d]: HLS=%llu ref=%llu\n",
                i, (unsigned long long)(uint64_t)output[i],
                (unsigned long long)ref_out[i]);
            ok = false;
        }
    }
    check("put(4) + getState", ok);
}

// =========================================================================
// Test 5: Multi-round: put, getField, put, getField
// =========================================================================
static void test_multiround() {
    printf("\n--- Test 5: Multi-round transcript ---\n");

    // First round: absorb 4 elements
    // Second round: absorb 3 more elements
    uint64_t vals[7] = {11, 22, 33, 44, 55, 66, 77};
    ap_uint<64> input[7], output[6];
    for (int i = 0; i < 7; i++) input[i] = vals[i];
    unsigned int queries_dummy[1] = {0};

    // op=3: put(input[0:3]), getField -> output[0:2]
    //       put(input[4:6]), getField -> output[3:5]
    transcript_test_kernel(input, output, queries_dummy, 3, 4, 0, 0, 3);

    // Reference
    ref_transcript ref;
    ref_reset(ref);
    ref_put(ref, &vals[0], 4);
    uint64_t ref_out1[3];
    ref_get_field(ref, ref_out1);
    ref_put(ref, &vals[4], 3);
    uint64_t ref_out2[3];
    ref_get_field(ref, ref_out2);

    bool ok = true;
    for (int i = 0; i < 3; i++) {
        if ((uint64_t)output[i] != ref_out1[i]) {
            printf("  Mismatch round1 [%d]: HLS=%llu ref=%llu\n",
                i, (unsigned long long)(uint64_t)output[i],
                (unsigned long long)ref_out1[i]);
            ok = false;
        }
        if ((uint64_t)output[3 + i] != ref_out2[i]) {
            printf("  Mismatch round2 [%d]: HLS=%llu ref=%llu\n",
                i, (unsigned long long)(uint64_t)output[3 + i],
                (unsigned long long)ref_out2[i]);
            ok = false;
        }
    }
    check("multi-round put+getField", ok);
}

// =========================================================================
// Test 6: getPermutations
// =========================================================================
static void test_permutations() {
    printf("\n--- Test 6: getPermutations ---\n");

    uint64_t vals[4] = {0xDEADBEEF, 0xCAFEBABE, 42, 7};
    ap_uint<64> input[4], output_dummy[1] = {0};
    for (int i = 0; i < 4; i++) input[i] = vals[i];

    unsigned int nQueries = 8;
    unsigned int nBits = 4;
    unsigned int hls_queries[8];

    transcript_test_kernel(input, output_dummy, hls_queries, 2, 4, nQueries, nBits, 0);

    // Reference
    ref_transcript ref;
    ref_reset(ref);
    ref_put(ref, vals, 4);
    unsigned int ref_queries[8];
    ref_get_permutations(ref, ref_queries, nQueries, nBits);

    bool ok = true;
    for (unsigned int i = 0; i < nQueries; i++) {
        if (hls_queries[i] != ref_queries[i]) {
            printf("  Mismatch query[%u]: HLS=%u ref=%u\n",
                i, hls_queries[i], ref_queries[i]);
            ok = false;
        }
        // All queries should be < 2^nBits
        if (hls_queries[i] >= (1u << nBits)) {
            printf("  Query[%u]=%u exceeds range 2^%u=%u\n",
                i, hls_queries[i], nBits, 1u << nBits);
            ok = false;
        }
    }
    check("getPermutations(8 queries, 4 bits)", ok);
}

// =========================================================================
// Test 7: Empty put + getField (immediate squeeze)
// =========================================================================
static void test_empty_getfield() {
    printf("\n--- Test 7: Empty put + getField ---\n");

    ap_uint<64> input_dummy[1] = {0};
    ap_uint<64> output[3];
    unsigned int queries_dummy[1] = {0};

    // op=0 with inputSize=0: no absorption, just squeeze
    transcript_test_kernel(input_dummy, output, queries_dummy, 0, 0, 0, 0, 0);

    // Reference
    ref_transcript ref;
    ref_reset(ref);
    // put 0 elements
    uint64_t ref_out[3];
    ref_get_field(ref, ref_out);

    bool ok = true;
    for (int i = 0; i < 3; i++) {
        if ((uint64_t)output[i] != ref_out[i]) {
            printf("  Mismatch [%d]: HLS=%llu ref=%llu\n",
                i, (unsigned long long)(uint64_t)output[i],
                (unsigned long long)ref_out[i]);
            ok = false;
        }
    }
    check("empty put + getField", ok);
}

// =========================================================================
// Main
// =========================================================================
int main() {
    printf("===== Transcript (Fiat-Shamir) HLS Testbench =====\n");

    test_put4_getfield();
    test_put8_getfield();
    test_put12_getfield();
    test_getstate();
    test_multiround();
    test_permutations();
    test_empty_getfield();

    printf("\n===== Results: %d passed, %d failed =====\n", g_pass, g_fail);
    return g_fail > 0 ? 1 : 0;
}
