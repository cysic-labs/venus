// Testbench for expression evaluation HLS kernel.
//
// Tests the bytecode-driven expression evaluator against a CPU reference
// implementation. Covers:
//   1. Cubic extension field arithmetic (add, sub, mul, inv)
//   2. Simple dim1 expression (add two trace columns)
//   3. Mixed dim31 expression (multiply dim3 by dim1)
//   4. Expression with constants (numbers, challenges)
//   5. Multi-instruction expression with temporaries
//   6. Domain-wide evaluation

#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <cstring>
#include <cassert>

// ---- Goldilocks prime ----
static const uint64_t GL_P = 0xFFFFFFFF00000001ULL;

// ---- Reference CPU field arithmetic ----
static uint64_t ref_add(uint64_t a, uint64_t b) {
    __uint128_t s = (__uint128_t)a + b;
    return (s >= GL_P) ? (uint64_t)(s - GL_P) : (uint64_t)s;
}

static uint64_t ref_sub(uint64_t a, uint64_t b) {
    return (a >= b) ? (a - b) : (GL_P - b + a);
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
        aux1 = (uint64_t)((__uint128_t)rl + GL_P - rhh);
    }

    // aux = 0xFFFFFFFF * rhl = (rhl << 32) - rhl
    uint64_t rhl64 = (uint64_t)rhl;
    uint64_t aux = (rhl64 << 32) - rhl64;

    // result = (aux1 + aux) mod p
    __uint128_t sum = (__uint128_t)aux1 + aux;
    if (sum >= GL_P) sum -= GL_P;
    return (uint64_t)sum;
}

static uint64_t ref_neg(uint64_t a) {
    return (a == 0) ? 0 : (GL_P - a);
}

// ---- Reference cubic extension (F_p^3, x^3 - x - 1) ----
struct ref_ext3 {
    uint64_t v[3];
};

static ref_ext3 ref_ext3_add(ref_ext3 a, ref_ext3 b) {
    ref_ext3 r;
    r.v[0] = ref_add(a.v[0], b.v[0]);
    r.v[1] = ref_add(a.v[1], b.v[1]);
    r.v[2] = ref_add(a.v[2], b.v[2]);
    return r;
}

static ref_ext3 ref_ext3_sub(ref_ext3 a, ref_ext3 b) {
    ref_ext3 r;
    r.v[0] = ref_sub(a.v[0], b.v[0]);
    r.v[1] = ref_sub(a.v[1], b.v[1]);
    r.v[2] = ref_sub(a.v[2], b.v[2]);
    return r;
}

static ref_ext3 ref_ext3_mul(ref_ext3 a, ref_ext3 b) {
    // Karatsuba: 6 base muls
    uint64_t A = ref_mul(ref_add(a.v[0], a.v[1]),
                         ref_add(b.v[0], b.v[1]));
    uint64_t B = ref_mul(ref_add(a.v[0], a.v[2]),
                         ref_add(b.v[0], b.v[2]));
    uint64_t C = ref_mul(ref_add(a.v[1], a.v[2]),
                         ref_add(b.v[1], b.v[2]));
    uint64_t D = ref_mul(a.v[0], b.v[0]);
    uint64_t E = ref_mul(a.v[1], b.v[1]);
    uint64_t F = ref_mul(a.v[2], b.v[2]);
    uint64_t G = ref_sub(D, E);

    ref_ext3 r;
    r.v[0] = ref_sub(ref_add(C, G), F);
    r.v[1] = ref_sub(ref_sub(ref_sub(ref_add(A, C), E), E), D);
    r.v[2] = ref_sub(B, G);
    return r;
}

static ref_ext3 ref_ext3_mul_scalar(ref_ext3 a, uint64_t b) {
    ref_ext3 r;
    r.v[0] = ref_mul(a.v[0], b);
    r.v[1] = ref_mul(a.v[1], b);
    r.v[2] = ref_mul(a.v[2], b);
    return r;
}

// ---- Exponentiation for Fermat inverse ----
static uint64_t ref_pow(uint64_t base, uint64_t exp) {
    uint64_t result = 1;
    base = base % GL_P;
    while (exp > 0) {
        if (exp & 1) result = ref_mul(result, base);
        exp >>= 1;
        base = ref_mul(base, base);
    }
    return result;
}

static uint64_t ref_inv(uint64_t a) {
    return ref_pow(a, GL_P - 2);
}

static ref_ext3 ref_ext3_inv(ref_ext3 a) {
    uint64_t aa = ref_mul(a.v[0], a.v[0]);
    uint64_t ac = ref_mul(a.v[0], a.v[2]);
    uint64_t ba = ref_mul(a.v[1], a.v[0]);
    uint64_t bb = ref_mul(a.v[1], a.v[1]);
    uint64_t bc = ref_mul(a.v[1], a.v[2]);
    uint64_t cc = ref_mul(a.v[2], a.v[2]);

    uint64_t aaa = ref_mul(aa, a.v[0]);
    uint64_t aac = ref_mul(aa, a.v[2]);
    uint64_t abc = ref_mul(ba, a.v[2]);
    uint64_t abb = ref_mul(ba, a.v[1]);
    uint64_t acc = ref_mul(ac, a.v[2]);
    uint64_t bbb = ref_mul(bb, a.v[1]);
    uint64_t bcc = ref_mul(bc, a.v[2]);
    uint64_t ccc = ref_mul(cc, a.v[2]);

    // t = 3*abc + abb - aaa - 2*aac - acc - bbb + bcc - ccc
    uint64_t t = ref_add(ref_add(ref_add(abc, abc), abc), abb);
    t = ref_sub(t, aaa);
    t = ref_sub(t, aac);
    t = ref_sub(t, aac);
    t = ref_sub(t, acc);
    t = ref_sub(t, bbb);
    t = ref_add(t, bcc);
    t = ref_sub(t, ccc);

    uint64_t tinv = ref_inv(t);

    ref_ext3 r;
    // i1 = (bc + bb - aa - ac - ac - cc) * tinv
    uint64_t n1 = ref_sub(ref_sub(ref_sub(ref_add(bc, bb), aa), ac), ac);
    n1 = ref_sub(n1, cc);
    r.v[0] = ref_mul(n1, tinv);
    // i2 = (ba - cc) * tinv
    r.v[1] = ref_mul(ref_sub(ba, cc), tinv);
    // i3 = (ac + cc - bb) * tinv
    r.v[2] = ref_mul(ref_sub(ref_add(ac, cc), bb), tinv);
    return r;
}

// ---- Expression bytecode builder helper ----
struct BytecodeBuilder {
    uint8_t  ops[4096];
    uint16_t args[32768];
    unsigned int nOps;
    unsigned int nArgs;

    BytecodeBuilder() : nOps(0), nArgs(0) {}

    void addOp(uint8_t opcode, uint16_t arith_op, uint16_t dest_idx,
               uint16_t type_a, uint16_t idx_a, uint16_t off_a,
               uint16_t type_b, uint16_t idx_b, uint16_t off_b) {
        ops[nOps++] = opcode;
        args[nArgs++] = arith_op;
        args[nArgs++] = dest_idx;
        args[nArgs++] = type_a;
        args[nArgs++] = idx_a;
        args[nArgs++] = off_a;
        args[nArgs++] = type_b;
        args[nArgs++] = idx_b;
        args[nArgs++] = off_b;
    }
};

// ---- Forward declaration of HLS kernel ----
extern "C" void expr_test_kernel(
    const uint64_t* trace,
    const uint64_t* constPols,
    uint64_t*       output,
    const uint8_t*  ops_in,
    const uint16_t* args_in,
    const uint64_t* numbers_in,
    const uint64_t* challenges_in,
    const uint64_t* evals_in,
    const uint64_t* publicInputs_in,
    const uint64_t* airValues_in,
    const int*      strides_in,
    unsigned int op,
    unsigned int nOps,
    unsigned int row,
    unsigned int domainSize,
    unsigned int nTraceCols,
    unsigned int nConstCols,
    unsigned int bufferCommitSize,
    unsigned int nStages,
    unsigned int resultDim
);

static int errors = 0;

static void check_val(const char* test, uint64_t got, uint64_t exp, int idx = -1) {
    if (got != exp) {
        if (idx >= 0)
            printf("  FAIL %s[%d]: got 0x%016llx, expected 0x%016llx\n",
                   test, idx, (unsigned long long)got, (unsigned long long)exp);
        else
            printf("  FAIL %s: got 0x%016llx, expected 0x%016llx\n",
                   test, (unsigned long long)got, (unsigned long long)exp);
        errors++;
    }
}

// ---- Test 1: Cubic extension field arithmetic ----
static void test_cubic_extension() {
    printf("Test 1: Cubic extension field arithmetic\n");

    // Test values
    ref_ext3 a = {{3, 7, 11}};
    ref_ext3 b = {{5, 13, 17}};

    // Add
    ref_ext3 sum = ref_ext3_add(a, b);
    check_val("ext3_add", sum.v[0], 8, 0);
    check_val("ext3_add", sum.v[1], 20, 1);
    check_val("ext3_add", sum.v[2], 28, 2);

    // Sub
    ref_ext3 diff = ref_ext3_sub(b, a);
    check_val("ext3_sub", diff.v[0], 2, 0);
    check_val("ext3_sub", diff.v[1], 6, 1);
    check_val("ext3_sub", diff.v[2], 6, 2);

    // Mul
    ref_ext3 prod = ref_ext3_mul(a, b);
    // Verify: a*b, then a*b*inv(a*b) = 1
    ref_ext3 prod_inv = ref_ext3_inv(prod);
    ref_ext3 should_be_one = ref_ext3_mul(prod, prod_inv);
    check_val("ext3_mul_inv", should_be_one.v[0], 1, 0);
    check_val("ext3_mul_inv", should_be_one.v[1], 0, 1);
    check_val("ext3_mul_inv", should_be_one.v[2], 0, 2);

    // Mul scalar
    uint64_t s = 42;
    ref_ext3 scaled = ref_ext3_mul_scalar(a, s);
    check_val("ext3_mul_scalar", scaled.v[0], ref_mul(3, 42), 0);
    check_val("ext3_mul_scalar", scaled.v[1], ref_mul(7, 42), 1);
    check_val("ext3_mul_scalar", scaled.v[2], ref_mul(11, 42), 2);

    printf("  Done.\n");
}

// ---- Test 2: Simple dim1 expression (trace[row][0] + trace[row][1]) ----
static void test_dim1_add() {
    printf("Test 2: dim1 expression - add two trace columns\n");

    const unsigned int N = 8;
    const unsigned int nCols = 4;

    // Build trace: row-major, nCols columns
    uint64_t trace[N * nCols];
    for (unsigned int r = 0; r < N; r++) {
        for (unsigned int c = 0; c < nCols; c++) {
            trace[r * nCols + c] = (r + 1) * 100 + c;
        }
    }

    uint64_t constPols[N * 2];
    memset(constPols, 0, sizeof(constPols));

    // bufferCommitSize = 1 + nStages + 3 + nCustomCommits
    // For test: nStages=1, nCustomCommits=0 => B = 1+1+3+0 = 5
    unsigned int B = 5;
    unsigned int nStages = 1;

    // Bytecode: one instruction
    // opcode=0 (dim1), arith=0 (add)
    // src_a: type=1 (trace), idx=0 (col 0), off=0
    // src_b: type=1 (trace), idx=1 (col 1), off=0
    BytecodeBuilder bc;
    bc.addOp(0, 0, 0,
             1, 0, 0,    // A: trace col 0
             1, 1, 0);   // B: trace col 1

    uint64_t numbers[1024] = {0};
    uint64_t challenges[128] = {0};
    uint64_t evals[256] = {0};
    uint64_t publicInputs[64] = {0};
    uint64_t airValues[64] = {0};
    int      strides[16] = {0};  // opening stride 0 = 0

    uint64_t output[4] = {0};

    // Test each row
    for (unsigned int r = 0; r < N; r++) {
        expr_test_kernel(
            trace, constPols, output,
            bc.ops, bc.args,
            numbers, challenges, evals, publicInputs, airValues, strides,
            0,  // op=0 (single row)
            bc.nOps, r, N, nCols, 2, B, nStages, 1  // resultDim=1
        );

        uint64_t expected = ref_add(trace[r * nCols + 0], trace[r * nCols + 1]);
        check_val("dim1_add", output[0], expected, r);
    }

    printf("  Done.\n");
}

// ---- Test 3: dim1 expression with multiply ----
static void test_dim1_mul() {
    printf("Test 3: dim1 expression - multiply trace col 0 * col 1\n");

    const unsigned int N = 8;
    const unsigned int nCols = 4;

    uint64_t trace[N * nCols];
    for (unsigned int r = 0; r < N; r++) {
        trace[r * nCols + 0] = r + 2;
        trace[r * nCols + 1] = r + 3;
        trace[r * nCols + 2] = 0;
        trace[r * nCols + 3] = 0;
    }

    uint64_t constPols[N * 2] = {0};
    unsigned int B = 5;
    unsigned int nStages = 1;

    BytecodeBuilder bc;
    bc.addOp(0, 2, 0,   // opcode=0 (dim1), arith=2 (mul)
             1, 0, 0,   // A: trace col 0
             1, 1, 0);  // B: trace col 1

    uint64_t numbers[1024] = {0};
    uint64_t challenges[128] = {0};
    uint64_t evals[256] = {0};
    uint64_t publicInputs[64] = {0};
    uint64_t airValues[64] = {0};
    int      strides[16] = {0};

    uint64_t output[4] = {0};

    for (unsigned int r = 0; r < N; r++) {
        expr_test_kernel(
            trace, constPols, output,
            bc.ops, bc.args,
            numbers, challenges, evals, publicInputs, airValues, strides,
            0, bc.nOps, r, N, nCols, 2, B, nStages, 1
        );

        uint64_t expected = ref_mul(trace[r * nCols + 0], trace[r * nCols + 1]);
        check_val("dim1_mul", output[0], expected, r);
    }

    printf("  Done.\n");
}

// ---- Test 4: Expression with constants (numbers pool) ----
static void test_with_constants() {
    printf("Test 4: dim1 expression - trace[r][0] + number[0]\n");

    const unsigned int N = 4;
    const unsigned int nCols = 2;

    uint64_t trace[N * nCols];
    for (unsigned int r = 0; r < N; r++) {
        trace[r * nCols + 0] = r + 100;
        trace[r * nCols + 1] = 0;
    }

    uint64_t constPols[N * 2] = {0};
    unsigned int B = 5;
    unsigned int nStages = 1;

    // number[0] = 42
    uint64_t numbers[1024] = {0};
    numbers[0] = 42;

    // Bytecode: trace[r][0] + numbers[0]
    // numbers = type B+3 = 8
    BytecodeBuilder bc;
    bc.addOp(0, 0, 0,
             1, 0, 0,     // A: trace col 0
             B + 3, 0, 0); // B: numbers[0]

    uint64_t challenges[128] = {0};
    uint64_t evals[256] = {0};
    uint64_t publicInputs[64] = {0};
    uint64_t airValues[64] = {0};
    int      strides[16] = {0};

    uint64_t output[4] = {0};

    for (unsigned int r = 0; r < N; r++) {
        expr_test_kernel(
            trace, constPols, output,
            bc.ops, bc.args,
            numbers, challenges, evals, publicInputs, airValues, strides,
            0, bc.nOps, r, N, nCols, 2, B, nStages, 1
        );

        uint64_t expected = ref_add(trace[r * nCols + 0], 42);
        check_val("const_add", output[0], expected, r);
    }

    printf("  Done.\n");
}

// ---- Test 5: Multi-instruction expression with temporaries ----
// Compute: (trace[r][0] + trace[r][1]) * trace[r][2]
// Instruction 0: tmp1[0] = trace[r][0] + trace[r][1]  (dim1, add)
// Instruction 1: result  = tmp1[0] * trace[r][2]       (dim1, mul)
static void test_multi_instruction() {
    printf("Test 5: Multi-instruction expression with temps\n");

    const unsigned int N = 4;
    const unsigned int nCols = 4;

    uint64_t trace[N * nCols];
    for (unsigned int r = 0; r < N; r++) {
        trace[r * nCols + 0] = r + 5;
        trace[r * nCols + 1] = r + 10;
        trace[r * nCols + 2] = r + 2;
        trace[r * nCols + 3] = 0;
    }

    uint64_t constPols[N * 2] = {0};
    unsigned int B = 5;
    unsigned int nStages = 1;

    BytecodeBuilder bc;
    // Op 0: tmp1[0] = trace[0] + trace[1]
    bc.addOp(0, 0, 0,
             1, 0, 0,    // A: trace col 0
             1, 1, 0);   // B: trace col 1
    // Op 1: result = tmp1[0] * trace[2]
    bc.addOp(0, 2, 0,
             B, 0, 0,    // A: tmp1[0]
             1, 2, 0);   // B: trace col 2

    uint64_t numbers[1024] = {0};
    uint64_t challenges[128] = {0};
    uint64_t evals[256] = {0};
    uint64_t publicInputs[64] = {0};
    uint64_t airValues[64] = {0};
    int      strides[16] = {0};

    uint64_t output[4] = {0};

    for (unsigned int r = 0; r < N; r++) {
        expr_test_kernel(
            trace, constPols, output,
            bc.ops, bc.args,
            numbers, challenges, evals, publicInputs, airValues, strides,
            0, bc.nOps, r, N, nCols, 2, B, nStages, 1
        );

        uint64_t sum = ref_add(trace[r * nCols + 0], trace[r * nCols + 1]);
        uint64_t expected = ref_mul(sum, trace[r * nCols + 2]);
        check_val("multi_inst", output[0], expected, r);
    }

    printf("  Done.\n");
}

// ---- Test 6: dim33 expression (cubic extension multiply) ----
// Compute: challenges[0..2] * evals[0..2]  (both dim3)
static void test_dim33_mul() {
    printf("Test 6: dim33 expression - cubic extension multiply\n");

    const unsigned int N = 4;
    const unsigned int nCols = 2;

    uint64_t trace[N * nCols] = {0};
    uint64_t constPols[N * 2] = {0};
    unsigned int B = 5;
    unsigned int nStages = 1;

    // challenges = type B+7 = 12
    // evals = type B+8 = 13
    uint64_t challenges[128] = {0};
    challenges[0] = 3;
    challenges[1] = 7;
    challenges[2] = 11;

    uint64_t evals[256] = {0};
    evals[0] = 5;
    evals[1] = 13;
    evals[2] = 17;

    uint64_t numbers[1024] = {0};
    uint64_t publicInputs[64] = {0};
    uint64_t airValues[64] = {0};
    int      strides[16] = {0};

    // Bytecode: one dim33 instruction
    // opcode=2 (dim3x3), arith=2 (mul)
    BytecodeBuilder bc;
    bc.addOp(2, 2, 0,
             B + 7, 0, 0,    // A: challenges[0..2]
             B + 8, 0, 0);   // B: evals[0..2]

    uint64_t output[4] = {0};

    expr_test_kernel(
        trace, constPols, output,
        bc.ops, bc.args,
        numbers, challenges, evals, publicInputs, airValues, strides,
        0, bc.nOps, 0, N, nCols, 2, B, nStages, 3  // resultDim=3
    );

    // Reference
    ref_ext3 a = {{3, 7, 11}};
    ref_ext3 b = {{5, 13, 17}};
    ref_ext3 expected = ref_ext3_mul(a, b);

    check_val("dim33_mul", output[0], expected.v[0], 0);
    check_val("dim33_mul", output[1], expected.v[1], 1);
    check_val("dim33_mul", output[2], expected.v[2], 2);

    printf("  Done.\n");
}

// ---- Test 7: dim31 expression (cubic * scalar) ----
// Compute: challenges[0..2] * trace[r][0]
static void test_dim31_mul() {
    printf("Test 7: dim31 expression - cubic extension * base field\n");

    const unsigned int N = 4;
    const unsigned int nCols = 2;

    uint64_t trace[N * nCols];
    for (unsigned int r = 0; r < N; r++) {
        trace[r * nCols + 0] = r + 5;
        trace[r * nCols + 1] = 0;
    }

    uint64_t constPols[N * 2] = {0};
    unsigned int B = 5;
    unsigned int nStages = 1;

    uint64_t challenges[128] = {0};
    challenges[0] = 100;
    challenges[1] = 200;
    challenges[2] = 300;

    uint64_t numbers[1024] = {0};
    uint64_t evals[256] = {0};
    uint64_t publicInputs[64] = {0};
    uint64_t airValues[64] = {0};
    int      strides[16] = {0};

    // opcode=1 (dim3x1), arith=2 (mul)
    BytecodeBuilder bc;
    bc.addOp(1, 2, 0,
             B + 7, 0, 0,    // A: challenges[0..2] (dim3)
             1, 0, 0);       // B: trace col 0 (dim1)

    uint64_t output[4] = {0};

    for (unsigned int r = 0; r < N; r++) {
        expr_test_kernel(
            trace, constPols, output,
            bc.ops, bc.args,
            numbers, challenges, evals, publicInputs, airValues, strides,
            0, bc.nOps, r, N, nCols, 2, B, nStages, 3
        );

        ref_ext3 a = {{100, 200, 300}};
        uint64_t s = trace[r * nCols + 0];
        ref_ext3 expected = ref_ext3_mul_scalar(a, s);

        check_val("dim31_mul", output[0], expected.v[0], r * 3 + 0);
        check_val("dim31_mul", output[1], expected.v[1], r * 3 + 1);
        check_val("dim31_mul", output[2], expected.v[2], r * 3 + 2);
    }

    printf("  Done.\n");
}

// ---- Test 8: Domain-wide evaluation ----
static void test_domain_eval() {
    printf("Test 8: Domain-wide evaluation\n");

    const unsigned int N = 16;
    const unsigned int nCols = 2;

    uint64_t trace[N * nCols];
    for (unsigned int r = 0; r < N; r++) {
        trace[r * nCols + 0] = r + 1;
        trace[r * nCols + 1] = r + 100;
    }

    uint64_t constPols[N * 2] = {0};
    unsigned int B = 5;
    unsigned int nStages = 1;

    // trace[r][0] * trace[r][1]
    BytecodeBuilder bc;
    bc.addOp(0, 2, 0,
             1, 0, 0,
             1, 1, 0);

    uint64_t numbers[1024] = {0};
    uint64_t challenges[128] = {0};
    uint64_t evals[256] = {0};
    uint64_t publicInputs[64] = {0};
    uint64_t airValues[64] = {0};
    int      strides[16] = {0};

    uint64_t output[N] = {0};

    expr_test_kernel(
        trace, constPols, output,
        bc.ops, bc.args,
        numbers, challenges, evals, publicInputs, airValues, strides,
        1,  // op=1 (domain eval)
        bc.nOps, 0, N, nCols, 2, B, nStages, 1
    );

    for (unsigned int r = 0; r < N; r++) {
        uint64_t expected = ref_mul(trace[r * nCols + 0], trace[r * nCols + 1]);
        check_val("domain_eval", output[r], expected, r);
    }

    printf("  Done.\n");
}

// ---- Test 9: Constant polynomial access ----
static void test_const_pols() {
    printf("Test 9: Constant polynomial access\n");

    const unsigned int N = 8;
    const unsigned int nTraceCols = 2;
    const unsigned int nConstCols = 2;

    uint64_t trace[N * nTraceCols];
    for (unsigned int r = 0; r < N; r++) {
        trace[r * nTraceCols + 0] = r + 10;
        trace[r * nTraceCols + 1] = 0;
    }

    uint64_t constPols[N * nConstCols];
    for (unsigned int r = 0; r < N; r++) {
        constPols[r * nConstCols + 0] = (r + 1) * 1000;
        constPols[r * nConstCols + 1] = 0;
    }

    unsigned int B = 5;
    unsigned int nStages = 1;

    // trace[r][0] + constPols[r][0]
    // constPols = type 0
    BytecodeBuilder bc;
    bc.addOp(0, 0, 0,
             1, 0, 0,    // A: trace col 0
             0, 0, 0);   // B: constPol col 0

    uint64_t numbers[1024] = {0};
    uint64_t challenges[128] = {0};
    uint64_t evals[256] = {0};
    uint64_t publicInputs[64] = {0};
    uint64_t airValues[64] = {0};
    int      strides[16] = {0};

    uint64_t output[4] = {0};

    for (unsigned int r = 0; r < N; r++) {
        expr_test_kernel(
            trace, constPols, output,
            bc.ops, bc.args,
            numbers, challenges, evals, publicInputs, airValues, strides,
            0, bc.nOps, r, N, nTraceCols, nConstCols, B, nStages, 1
        );

        uint64_t expected = ref_add(trace[r * nTraceCols + 0],
                                     constPols[r * nConstCols + 0]);
        check_val("const_pol", output[0], expected, r);
    }

    printf("  Done.\n");
}

int main() {
    printf("=== Expression Evaluation HLS Testbench ===\n\n");

    test_cubic_extension();
    test_dim1_add();
    test_dim1_mul();
    test_with_constants();
    test_multi_instruction();
    test_dim33_mul();
    test_dim31_mul();
    test_domain_eval();
    test_const_pols();

    printf("\n=== Results: %d error(s) ===\n", errors);
    return errors ? 1 : 0;
}
