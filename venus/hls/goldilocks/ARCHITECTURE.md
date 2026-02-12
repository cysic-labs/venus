# Goldilocks Field Arithmetic - FPGA HLS Architecture

## 1. Overview

This document specifies the FPGA architecture for Goldilocks prime field arithmetic
(p = 2^64 - 2^32 + 1) using AMD Vitis HLS (v++ flow). This module is the foundational
building block for all STARK prover kernels (NTT, Poseidon2, Merkle, FRI, etc.).

**Target devices:**
- xcvu47p-fsvh2892-3-e (UltraScale+ VU47P, 16GB HBM)
- xcvh1782-lsva4737-3HP-e-S (Versal VH1782, 32GB HBM)

**Reference implementations:**
- GPU: `pil2-proofman/pil2-stark/src/goldilocks/src/gl64_t.cuh`
- CPU: `pil2-proofman/pil2-stark/src/goldilocks/src/goldilocks_base_field_scalar.hpp`
- Cubic extension GPU: `pil2-proofman/pil2-stark/src/goldilocks/src/goldilocks_cubic_extension.cuh`
- Cubic extension CPU: `pil2-proofman/pil2-stark/src/goldilocks/src/goldilocks_cubic_extension.hpp`

## 2. Goldilocks Prime Properties

```
p = 2^64 - 2^32 + 1 = 0xFFFFFFFF00000001
```

Key algebraic identity exploited in reduction:
```
2^64 = 2^32 - 1 (mod p)       i.e., 2^64 mod p = 0xFFFFFFFF
2^96 = -1 (mod p)              i.e., 2^96 mod p = p - 1
```

Element representation: single `ap_uint<64>`, canonical range [0, p-1].

## 3. File Structure

```
venus/hls/goldilocks/
  gl64_t.hpp            -- Base field element struct + inline arithmetic
  gl64_cubic.hpp        -- Cubic extension (F_p^3) arithmetic
  gl64_constants.hpp    -- Roots of unity, Poseidon2 round constants
  test/
    tb_gl64.cpp         -- C-simulation testbench for base field
    tb_gl64_cubic.cpp   -- C-simulation testbench for cubic extension
    gl64_test_kernel.cpp -- AXI-wrapped test kernel for hw_emu / on-board
    Makefile            -- Vitis HLS build targets (csim, csynth, cosim)
```

## 4. Base Field Element Type: `gl64_t`

### 4.1 Data Type

```cpp
#include <ap_int.h>
#include <hls_stream.h>

struct gl64_t {
    ap_uint<64> val;

    // Constructors
    gl64_t() : val(0) {}
    gl64_t(ap_uint<64> v) : val(v) {}
    gl64_t(uint64_t v) : val(v) {}

    // Constants
    static const ap_uint<64> P = 0xFFFFFFFF00000001ULL;
    static const ap_uint<64> W = 0xFFFFFFFF;  // 2^64 mod p

    // Conversion
    ap_uint<64> to_canonical() const;

    // Operators (see sections below)
    gl64_t operator+(const gl64_t& b) const;
    gl64_t operator-(const gl64_t& b) const;
    gl64_t operator*(const gl64_t& b) const;
    gl64_t operator-() const;
    bool operator==(const gl64_t& b) const;
    bool operator!=(const gl64_t& b) const;

    // Advanced operations
    gl64_t reciprocal() const;
    gl64_t square() const;
    bool is_zero() const;
    bool is_one() const;
    static gl64_t one();
    static gl64_t zero();
};
```

**Rationale:** Using a struct with operator overloading matches the GPU `gl64_t` API,
making the NTT/Poseidon2/FRI kernels a more direct port. All methods are `inline`
for HLS to synthesize them within the calling kernel's pipeline.

### 4.2 Canonical Reduction

Ensure element is in [0, p-1]:

```cpp
inline ap_uint<64> gl64_t::to_canonical() const {
    #pragma HLS INLINE
    ap_uint<65> v_ext = val;
    ap_uint<65> diff = v_ext - ap_uint<65>(P);
    return diff[64] ? val : ap_uint<64>(diff);  // if val < P, keep val
}
```

**Resources:** ~128 LUTs (64-bit subtractor + mux), 0 DSPs.
**Latency:** 1 cycle. **II:** 1.

### 4.3 Modular Addition

Algorithm: compute `a + b`; if sum >= p, subtract p.

```cpp
inline gl64_t gl64_t::operator+(const gl64_t& b) const {
    #pragma HLS INLINE
    ap_uint<65> sum = ap_uint<65>(val) + ap_uint<65>(b.val);
    ap_uint<65> sum_minus_p = sum - ap_uint<65>(P);
    gl64_t result;
    result.val = sum_minus_p[64] ? ap_uint<64>(sum) : ap_uint<64>(sum_minus_p);
    return result;
}
```

**Correctness proof:**
- Inputs: a, b in [0, p-1] (or [0, 2^64-1] for not-yet-reduced values)
- If both canonical: sum in [0, 2p-2]. One conditional subtract suffices.
- If one is in [0, 2^64-1]: sum in [0, 2^65-2]. We use 65-bit arithmetic.
  But consumer must ensure inputs are canonical for single-subtract correctness.

**Resources:** ~192 LUTs (two 65-bit adders + mux), 0 DSPs.
**Latency:** 1 cycle. **II:** 1.

### 4.4 Modular Subtraction

Algorithm: compute `a - b`; if result underflows (a < b), add p.

```cpp
inline gl64_t gl64_t::operator-(const gl64_t& b) const {
    #pragma HLS INLINE
    ap_uint<65> diff = ap_uint<65>(val) - ap_uint<65>(b.val);
    gl64_t result;
    result.val = diff[64] ? ap_uint<64>(diff + ap_uint<65>(P)) : ap_uint<64>(diff);
    return result;
}
```

**Resources:** ~192 LUTs (65-bit sub + conditional 65-bit add + mux), 0 DSPs.
**Latency:** 1 cycle. **II:** 1.

### 4.5 Modular Negation

```cpp
inline gl64_t gl64_t::operator-() const {
    #pragma HLS INLINE
    gl64_t z;
    z.val = 0;
    return z - *this;
}
```

### 4.6 Modular Multiplication (Critical Path)

This is the most resource-intensive and latency-critical operation. The algorithm
follows the CPU reference (goldilocks_base_field_scalar.hpp, Goldilocks::mul):

```
Given a, b in [0, p-1]:
1. prod = a * b                          (128-bit full product)
2. rl = prod[63:0], rh = prod[127:64]
3. rhh = rh[63:32], rhl = rh[31:0]
4. aux1 = rl - rhh                       (if underflow, add p)
5. aux  = 0xFFFFFFFF * rhl               (= (rhl << 32) - rhl, no DSP!)
6. result = (aux1 + aux) mod p           (single modular add)
```

**Mathematical derivation:**
```
a*b = rh * 2^64 + rl
    = rh * (2^32 - 1) + rl              (since 2^64 = 2^32 - 1 mod p)
    = (rhh*2^32 + rhl) * (2^32 - 1) + rl
    = rhh*2^64 + rhl*2^32 - rhh*2^32 - rhl + rl
    = rhh*(2^32-1) + rhl*2^32 - rhh*2^32 - rhl + rl  (reduce rhh*2^64)
    = rhl*2^32 - rhh - rhl + rl          (simplify)
    = rl - rhh + rhl*(2^32 - 1)          (regroup)
    = rl - rhh + 0xFFFFFFFF * rhl
```

```cpp
inline gl64_t gl64_t::operator*(const gl64_t& b) const {
    #pragma HLS INLINE
    const ap_uint<64> P_LOCAL = 0xFFFFFFFF00000001ULL;

    // Step 1: Full 128-bit multiply
    ap_uint<128> prod = ap_uint<128>(val) * ap_uint<128>(b.val);

    // Step 2: Split product
    ap_uint<64> rl = prod(63, 0);
    ap_uint<64> rh = prod(127, 64);
    ap_uint<32> rhh = rh(63, 32);
    ap_uint<32> rhl = rh(31, 0);

    // Step 3: aux1 = rl - rhh (mod p)
    // Use 65 bits to detect underflow
    ap_uint<65> aux1_wide = ap_uint<65>(rl) - ap_uint<65>(rhh);
    if (aux1_wide[64]) {  // underflow
        aux1_wide += ap_uint<65>(P_LOCAL);
    }
    ap_uint<64> aux1 = aux1_wide(63, 0);

    // Step 4: aux = 0xFFFFFFFF * rhl = (rhl << 32) - rhl
    // KEY OPTIMIZATION: avoids a DSP multiply entirely!
    ap_uint<64> aux = (ap_uint<64>(rhl) << 32) - ap_uint<64>(rhl);

    // Step 5: Modular add (aux1 + aux may be up to 2p-2)
    ap_uint<65> sum = ap_uint<65>(aux1) + ap_uint<65>(aux);
    ap_uint<65> sum_minus_p = sum - ap_uint<65>(P_LOCAL);
    gl64_t result;
    result.val = sum_minus_p[64] ? ap_uint<64>(sum) : ap_uint<64>(sum_minus_p);
    return result;
}
```

**Resource estimate (per multiplier instance):**
- 64x64 -> 128 multiply: ~9-16 DSP48E2 (Vitis HLS auto-decomposes into 27x18 partials)
- 0xFFFFFFFF * rhl: 0 DSPs (shift-subtract)
- Adders/subtractors: ~400-500 LUTs
- Total per mul: **~12 DSP48E2 + ~500 LUTs**

**Timing:**
- **Latency:** 5-8 cycles (DSP cascade for multiply + reduction logic)
- **II (Initiation Interval):** 1 (new multiply every clock cycle)
- **Target frequency:** 300 MHz (UltraScale+), 500 MHz (Versal)

**DSP budget analysis:**
- VU47P: 9024 DSP48E2 -> ~560-750 simultaneous multipliers
- VH1782: ~9000 DSP48E2 -> similar capacity

### 4.7 Squaring

Squaring is a special case of multiplication (a * a). Could be optimized
(requires only (n^2+n)/2 = 6 partial products instead of n^2 = 8 for 4-limb),
but for HLS the compiler may already detect this pattern. Initially we just
call multiply:

```cpp
inline gl64_t gl64_t::square() const {
    #pragma HLS INLINE
    return *this * *this;
}
```

Future optimization: dedicated squarer saving ~25% DSPs. Add when profiling
shows it matters.

### 4.8 Modular Inverse (Reciprocal) via Fermat's Little Theorem

```
a^(-1) = a^(p-2) mod p
p-2 = 0xFFFFFFFF00000001 - 2 = 0xFFFFFFFEFFFFFFFF
Binary: 1111111111111111111111111111111011111111111111111111111111111111
```

The GPU uses an optimized addition chain (gl64_t.cuh:reciprocal). We replicate
the exact same chain for bit-exact equivalence:

```cpp
inline gl64_t gl64_t::reciprocal() const {
    #pragma HLS INLINE off  // Do NOT inline - save area, called rarely
    gl64_t t0, t1;

    // sqr_n_mul(x, n, m): square x n times, then multiply by m
    t1 = sqr_n_mul(*this, 1, *this);   // x^3           = 0b11
    t0 = sqr_n_mul(t1, 2, t1);         // x^15          = 0b1111
    t0 = sqr_n_mul(t0, 2, t1);         // x^63          = 0b111111
    t1 = sqr_n_mul(t0, 6, t0);         // x^(2^12-1)
    t1 = sqr_n_mul(t1, 12, t1);        // x^(2^24-1)
    t1 = sqr_n_mul(t1, 6, t0);         // x^(2^30-1)
    t1 = sqr_n_mul(t1, 1, *this);      // x^(2^31-1)
    t1 = sqr_n_mul(t1, 32, t1);        // see GPU chain
    t1 = sqr_n_mul(t1, 1, *this);      // final step
    return t1;
}
```

Where `sqr_n_mul` is a helper:
```cpp
static gl64_t sqr_n_mul(gl64_t s, uint32_t n, const gl64_t& m) {
    #pragma HLS INLINE off
    for (uint32_t i = 0; i < n; i++) {
        #pragma HLS PIPELINE II=1
        s = s.square();
    }
    return s * m;
}
```

**Operation count:** 63 squarings + 9 multiplications = 72 field multiplies total.

**Latency per inverse:** ~72 * mul_latency cycles = ~72 * 6 = ~432 cycles (serial).
This is acceptable for single inversions. For bulk inversions, use Montgomery
batch inversion (1 inverse + 3N multiplies for N elements).

### 4.9 Batch Inverse (Montgomery's Trick)

For bulk inversion (common in STARK provers), convert N inversions into
1 inversion + ~3N multiplications:

```cpp
static void gl64_batch_inverse(gl64_t* result, const gl64_t* input, uint32_t n) {
    // Phase 1: prefix products
    gl64_t tmp[MAX_BATCH];  // Or dynamically allocated in BRAM
    tmp[0] = input[0];
    for (uint32_t i = 1; i < n; i++) {
        #pragma HLS PIPELINE II=1
        tmp[i] = tmp[i-1] * input[i];
    }

    // Phase 2: single inversion
    gl64_t z = tmp[n-1].reciprocal();

    // Phase 3: backward pass
    for (uint32_t i = n-1; i > 0; i--) {
        #pragma HLS PIPELINE II=1
        gl64_t z2 = z * input[i];
        result[i] = z * tmp[i-1];
        z = z2;
    }
    result[0] = z;
}
```

**Cost:** 1 inverse + 3*(N-1) multiplies instead of N inverses.
For N=1024: 3069 muls vs 73728 muls. ~24x speedup.

## 5. Cubic Extension Field: `gl64_3_t`

The cubic extension is F_p[x] / (x^3 - x - 1), representing elements as
(a0, a1, a2) meaning a0 + a1*x + a2*x^2.

### 5.1 Data Type

```cpp
struct gl64_3_t {
    gl64_t v[3];

    gl64_3_t() { v[0] = gl64_t(0); v[1] = gl64_t(0); v[2] = gl64_t(0); }
    gl64_3_t(gl64_t a0, gl64_t a1, gl64_t a2) { v[0]=a0; v[1]=a1; v[2]=a2; }

    gl64_3_t operator+(const gl64_3_t& b) const;
    gl64_3_t operator-(const gl64_3_t& b) const;
    gl64_3_t operator*(const gl64_3_t& b) const;
    gl64_3_t operator*(const gl64_t& b) const;  // scalar multiply
    gl64_3_t inv() const;

    static gl64_3_t zero();
    static gl64_3_t one();
};
```

### 5.2 Cubic Addition/Subtraction

Component-wise:
```cpp
inline gl64_3_t gl64_3_t::operator+(const gl64_3_t& b) const {
    #pragma HLS INLINE
    return gl64_3_t(v[0]+b.v[0], v[1]+b.v[1], v[2]+b.v[2]);
}
```

**Resources:** 3x base field add. **Latency:** 1 cycle. **II:** 1.

### 5.3 Cubic Multiplication (Karatsuba-like)

From the reference (goldilocks_cubic_extension.cuh, Goldilocks3GPU::mul):

```
Given a=(a0,a1,a2), b=(b0,b1,b2):

A = (a0+a1) * (b0+b1)     -- 6 independent base field multiplies
B = (a0+a2) * (b0+b2)
C = (a1+a2) * (b1+b2)
D = a0 * b0
E = a1 * b1
F = a2 * b2

G = D - E

result[0] = C + G - F     = C + D - E - F
result[1] = A + C - 2*E - D
result[2] = B - G          = B - D + E
```

```cpp
inline gl64_3_t gl64_3_t::operator*(const gl64_3_t& b) const {
    #pragma HLS INLINE
    // 6 additions for operand preparation (can be parallel)
    gl64_t a0_plus_a1 = v[0] + v[1];
    gl64_t a0_plus_a2 = v[0] + v[2];
    gl64_t a1_plus_a2 = v[1] + v[2];
    gl64_t b0_plus_b1 = b.v[0] + b.v[1];
    gl64_t b0_plus_b2 = b.v[0] + b.v[2];
    gl64_t b1_plus_b2 = b.v[1] + b.v[2];

    // 6 base field multiplies (all independent - can be parallel!)
    gl64_t A = a0_plus_a1 * b0_plus_b1;
    gl64_t B = a0_plus_a2 * b0_plus_b2;
    gl64_t C = a1_plus_a2 * b1_plus_b2;
    gl64_t D = v[0] * b.v[0];
    gl64_t E = v[1] * b.v[1];
    gl64_t F = v[2] * b.v[2];

    // Final combination (cheap adds/subs)
    gl64_t G = D - E;
    return gl64_3_t(
        (C + G) - F,                     // result[0]
        ((((A + C) - E) - E) - D),        // result[1]
        B - G                              // result[2]
    );
}
```

**Resources:** 6 base field multipliers + ~18 adders.
If all 6 muls instantiated in parallel: ~72-96 DSPs + ~3000 LUTs.
If serialized through 1 multiplier: ~12-16 DSPs but 6x slower.

**Parallelism strategy:**
For throughput-critical paths (NTT butterfly, expression eval), instantiate
all 6 multipliers in parallel. For area-constrained paths, serialize.
Use `#pragma HLS ALLOCATION` to control.

**Latency (parallel):** mul_latency + ~2 add cycles = ~8 cycles.
**II (parallel):** 1.

### 5.4 Cubic Scalar Multiply

```cpp
inline gl64_3_t gl64_3_t::operator*(const gl64_t& b) const {
    #pragma HLS INLINE
    return gl64_3_t(v[0]*b, v[1]*b, v[2]*b);
}
```

**Resources:** 3 base field multipliers. **Latency:** mul_latency. **II:** 1.

### 5.5 Cubic Inverse

From reference (goldilocks_cubic_extension.cuh, Goldilocks3GPU::inv):

Uses the norm computation followed by base field inversion.

```cpp
inline gl64_3_t gl64_3_t::inv() const {
    #pragma HLS INLINE off
    // 6 quadratic terms
    gl64_t aa = v[0] * v[0];
    gl64_t ac = v[0] * v[2];
    gl64_t ba = v[1] * v[0];
    gl64_t bb = v[1] * v[1];
    gl64_t bc = v[1] * v[2];
    gl64_t cc = v[2] * v[2];

    // 8 cubic terms
    gl64_t aaa = aa * v[0];
    gl64_t aac = aa * v[2];
    gl64_t abc = ba * v[2];
    gl64_t abb = ba * v[1];
    gl64_t acc = ac * v[2];
    gl64_t bbb = bb * v[1];
    gl64_t bcc = bc * v[2];
    gl64_t ccc = cc * v[2];

    // Norm (1 inversion target)
    gl64_t t = abc + abc + abc + abb - aaa - aac - aac - acc - bbb + bcc - ccc;
    gl64_t tinv = t.reciprocal();

    // 3 result components (3 muls each)
    gl64_t i1 = (bc + bb - aa - ac - ac - cc) * tinv;
    gl64_t i2 = (ba - cc) * tinv;
    gl64_t i3 = (ac + cc - bb) * tinv;

    return gl64_3_t(i1, i2, i3);
}
```

**Operation count:** 6 + 8 + 3 = 17 base field multiplies + 1 base field inverse
+ several additions/subtractions.

**Total cost:** ~17 muls + 72 muls (for inverse) = ~89 muls.

## 6. Constants

### 6.1 Roots of Unity

The NTT requires roots of unity. Goldilocks supports up to 2^32-order NTT.
The principal 2^k-th root of unity w_k is stored in a table:

```cpp
// gl64_constants.hpp
static const uint64_t GL64_ROOTS[33] = {
    0x0000000000000001ULL,  // w_0 = 1
    0xFFFFFFFF00000000ULL,  // w_1 = p-1 = -1
    0x0001000000000000ULL,  // w_2
    0x0000000001000000ULL,  // w_3
    // ... (from goldilocks_base_field.cpp)
    0x7277203076849721926ULL // w_32
};
```

Storage: 33 * 8 = 264 bytes. Fits in a single BRAM18K or in registers.
For NTT kernels, twiddle factors derived from these roots will be stored
in BRAM/URAM lookup tables.

## 7. Memory Hierarchy

The Goldilocks field arithmetic itself is pure compute with no significant
memory footprint. Memory considerations for higher-level kernels:

| Resource     | Usage for field ops                                |
|-------------|---------------------------------------------------|
| Registers   | Intermediate values in mul pipeline                |
| BRAM18K     | Roots of unity table (1 BRAM18K for 33 entries)   |
| URAM        | Not needed for field ops alone                     |
| HBM         | Input/output data arrays (managed by caller)       |
| DSP48E2     | Multiplier cores (~12 per base field mul)          |

## 8. Pipeline and Parallelism Strategy

### 8.1 Single-Element Pipeline (Default)

For operations within a loop body (NTT butterfly, hash round):
```
#pragma HLS PIPELINE II=1
```
All field operations are fully inlined and pipelined. A multiply has latency ~6
cycles but accepts new operands every cycle.

### 8.2 Data-Parallel (Multiple Elements)

For bulk operations (e.g., element-wise multiply of two arrays):
```cpp
void gl64_mul_array(gl64_t* c, const gl64_t* a, const gl64_t* b, uint32_t n) {
    #pragma HLS INTERFACE m_axi port=a bundle=gmem0 offset=slave
    #pragma HLS INTERFACE m_axi port=b bundle=gmem1 offset=slave
    #pragma HLS INTERFACE m_axi port=c bundle=gmem2 offset=slave
    #pragma HLS INTERFACE s_axilite port=n
    #pragma HLS INTERFACE s_axilite port=return

    for (uint32_t i = 0; i < n; i++) {
        #pragma HLS PIPELINE II=1
        c[i] = a[i] * b[i];
    }
}
```

With 512-bit AXI-MM and 64-bit elements: 8 elements per burst beat.
At 300 MHz with II=1: 300M elements/sec throughput (limited by compute).
With HBM (460 GB/s aggregate): memory bandwidth supports ~28.75G element
reads per second across all pseudo-channels, far exceeding compute rate
for a single kernel.

### 8.3 Unrolled Parallel (Multiple Compute Units)

For maximum throughput, unroll the loop body:
```cpp
for (uint32_t i = 0; i < n; i += UNROLL_FACTOR) {
    #pragma HLS PIPELINE II=1
    #pragma HLS UNROLL factor=UNROLL_FACTOR
    for (uint32_t j = 0; j < UNROLL_FACTOR; j++) {
        c[i+j] = a[i+j] * b[i+j];
    }
}
```

UNROLL_FACTOR = 4 or 8 depending on DSP budget. With factor=8:
~96-128 DSPs, throughput = 8 * 300M = 2.4G elements/sec.

## 9. Test Plan

### 9.1 C-Simulation Tests (tb_gl64.cpp)

Validate bit-exact correctness against CPU reference. Test cases:

1. **Identity tests:**
   - add(a, 0) == a, mul(a, 1) == a, sub(a, 0) == a
   - add(0, 0) == 0, mul(0, a) == 0

2. **Boundary tests:**
   - a = p-1: add(p-1, 1) == 0, mul(p-1, p-1) == 1
   - a = 0: sub(0, 1) == p-1, neg(0) == 0

3. **Wrap-around tests (critical for reduction correctness):**
   - Products that exercise rhh > rl (underflow path in multiply)
   - a = 0xFFFFFFFF00000000, b = 0xFFFFFFFF (double-carry in add)
   - a = b = 0xFFFFFFFEFFFFFFFF (near-max multiply)

4. **Algebraic tests:**
   - a * a^(-1) == 1 (for random a != 0)
   - (a * b) * c == a * (b * c) (associativity)
   - a * (b + c) == a*b + a*c (distributivity)
   - Batch inverse consistency: batch_inv(a)[i] == inv(a[i])

5. **Known-answer tests (from CPU reference test suite):**
   - add(0xFFFFFFFF00000002, 0xFFFFFFFF00000002) == 2 (mod p)
   - add(0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF) == 0x1FFFFFFFC (mod p)
   - Specific multiply/inverse test vectors generated by running
     the CPU reference code

6. **Cubic extension tests:**
   - (a * b) component-wise matches CPU Goldilocks3::mul reference output
   - a * inv(a) == (1, 0, 0) for random nonzero a
   - Scalar multiply consistency: a * gl64_t(k) == (a0*k, a1*k, a2*k)

### 9.2 C-Synthesis (csynth)

Verify:
- All operations achieve II=1 (check HLS synthesis report)
- DSP count per multiplier matches estimate (~12-16)
- No unresolved dependencies or scheduling issues
- Clock frequency target met (300 MHz for UltraScale+, 500 MHz for Versal)

### 9.3 Co-simulation (cosim)

Run the C-simulation testbench against RTL simulation to verify:
- Bit-exact match between C model and synthesized RTL
- Correct AXI handshaking for test kernel
- No RTL-level timing issues

### 9.4 Hardware Emulation (hw_emu)

Test the AXI-wrapped test kernel in hardware emulation:
- Verify correct data flow through AXI-MM interfaces
- Validate against CPU reference for 1000+ random test vectors
- Measure actual achieved II and latency

### 9.5 Cross-Validation with CPU Reference

Generate test vectors by running the CPU reference:
```bash
# Build and run CPU Goldilocks tests
cd pil2-proofman/pil2-stark && make test-goldilocks
```
Extract specific test vectors and compare FPGA results byte-for-byte.

## 10. Resource Summary (Estimated per Instance)

| Operation      | DSP48E2 | LUTs  | BRAM18K | Latency (cycles) | II |
|---------------|---------|-------|---------|-------------------|----|
| gl64_add       | 0       | ~200  | 0       | 1                 | 1  |
| gl64_sub       | 0       | ~200  | 0       | 1                 | 1  |
| gl64_mul       | ~12     | ~500  | 0       | 5-8               | 1  |
| gl64_reciprocal| ~12     | ~800  | 0       | ~432              | N/A|
| gl64_3_add     | 0       | ~600  | 0       | 1                 | 1  |
| gl64_3_mul (parallel) | ~72 | ~3000 | 0   | ~8                | 1  |
| gl64_3_mul (serial)   | ~12 | ~800  | 0   | ~48               | ~6 |
| gl64_3_inv     | ~12     | ~800  | 0       | ~534              | N/A|

## 11. Open Design Decisions

1. **Squaring optimization:** Dedicated squarer circuit could save ~25% DSPs
   compared to generic multiply. Defer until NTT profiling shows benefit.

2. **Montgomery form:** Some FPGA implementations use Montgomery representation
   for Goldilocks. However, since 2^64 mod p = 0xFFFFFFFF, the natural
   representation with direct reduction is already efficient. Montgomery adds
   complexity without clear benefit for this specific prime. Decision: use
   natural representation (matching CPU/GPU reference).

3. **ap_uint<64> vs uint64_t:** Using `ap_uint<64>` gives precise bit-width
   control and avoids HLS inferring wider datapaths. If synthesis shows
   overhead, can switch to `unsigned long long` with explicit bit ops.

4. **Partially reduced form:** The GPU supports a "partially reduced" mode
   (GL64_PARTIALLY_REDUCED) where elements may be in [0, 2^64) instead of
   [0, p). This saves a reduction step in add but requires reduction before
   comparison. For FPGA, start with fully reduced (canonical) form for
   correctness, optimize later if add/sub become bottleneck.
