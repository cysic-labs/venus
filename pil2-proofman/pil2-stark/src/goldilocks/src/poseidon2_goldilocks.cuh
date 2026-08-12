#ifndef POSEIDON2_GOLDILOCKS_CUH
#define POSEIDON2_GOLDILOCKS_CUH

#include "gl64_t.cuh"
#include "gl64_tooling.cuh"
#include "cuda_utils.cuh"
#include "cuda_utils.hpp"
#include "poseidon2_goldilocks.hpp"
#include "data_layout.cuh"

#pragma once

extern __shared__ gl64_t scratchpad[];


template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__global__ void linearHashGPU(uint64_t *__restrict__ output, uint64_t *__restrict__ input, uint32_t num_cols, uint32_t num_rows);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__global__ void linearHashGPUTiles(uint64_t *__restrict__ output, uint64_t *__restrict__ input, uint32_t num_cols, uint32_t num_rows);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__global__ void linearHashGPUTiles_(uint64_t *__restrict__ output, uint64_t *__restrict__ input, uint32_t num_cols, uint32_t num_rows);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__global__ void hash_full_result_2(uint64_t * output, const uint64_t * input);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__global__ void grinding_calc_(uint64_t* nonce, uint64_t *__restrict__ nonceBlock, uint64_t *__restrict__ input, uint64_t n_bits, uint64_t hashes_per_thread, uint64_t nonces_offset);

__global__ void grinding_check_(uint64_t* indx, uint64_t *__restrict__ indxBlock, uint32_t n_blocks);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__global__ void hash_gpu_3(uint32_t nextN, uint32_t nextIndex, uint32_t pending, uint64_t *cursor);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__global__ void hash_gpu_16(uint64_t* data, int N);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__global__ void grinding_persistent_kernel( uint64_t* __restrict__ d_nonce, uint64_t* __restrict__ d_nonceBlock, const uint64_t* __restrict__ d_input, uint32_t n_bits, uint32_t hashes_per_thread, uint64_t max_iterations);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void poseidon2_store(uint64_t *__restrict__ out, uint32_t col_stride, size_t row_stride);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void poseidon2_store(gl64_t *out, uint32_t col_stride, size_t row_stride=1);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void poseidon2_hash_loop(const uint64_t *__restrict__ in, uint32_t ncols);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void poseidon2_hash_loop_blocks(const uint64_t *__restrict__ in, uint32_t num_cols, uint32_t num_rows);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__  void poseidon2_hash();

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void poseidon2_hash_with_constants(const gl64_t *GPU_C_GL, const gl64_t *GPU_D_GL);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void poseidon2_hash_shared(gl64_t *out, const gl64_t *in, const gl64_t *GPU_C_GL, const gl64_t *GPU_D_GL);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ void hash_one_2(gl64_t *state, gl64_t *const input, int tid);

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void hash_one_const(gl64_t *out, const gl64_t *input);

__device__ __forceinline__ void pow7_2(gl64_t &x);

__device__ __forceinline__ void matmul_m4_(gl64_t *x);

__device__ __forceinline__ void pow7_2(gl64_t &x)
{
    gl64_t x2 = x * x;
    gl64_t x3 = x * x2;
    gl64_t x4 = x2 * x2;
    x = x3 * x4;
}

struct gl64_linear_accum_t {
    uint64_t lo;
    uint32_t hi;
};

__device__ __forceinline__ gl64_linear_accum_t gl64_linear_accum(const gl64_t &x)
{
    return {x[0], 0};
}

__device__ __forceinline__ gl64_linear_accum_t gl64_linear_add(gl64_linear_accum_t a, const gl64_linear_accum_t &b)
{
    asm("add.cc.u64 %0, %0, %2; addc.u32 %1, %1, %3;"
        : "+l"(a.lo), "+r"(a.hi)
        : "l"(b.lo), "r"(b.hi));
    return a;
}

__device__ __forceinline__ gl64_t gl64_linear_fold(gl64_linear_accum_t a)
{
    uint64_t folded = (uint64_t(a.hi) << 32) - uint64_t(a.hi);
    uint32_t carry;
    asm("add.cc.u64 %0, %0, %2; addc.u32 %1, 0, 0;"
        : "+l"(a.lo), "=r"(carry)
        : "l"(folded));
    if (carry) {
        asm("add.u64 %0, %0, %1;"
            : "+l"(a.lo)
            : "l"(uint64_t(0xffffffffULL)));
    }
    gl64_t out;
    out[0] = a.lo;
    return out;
}

__device__ __forceinline__ gl64_t gl64_mul_add(const gl64_t &a, const gl64_t &b, const gl64_t &c)
{
    const uint64_t av = a[0];
    const uint64_t bv = b[0];
    const uint64_t cv = c[0];
    const uint32_t a0 = uint32_t(av);
    const uint32_t a1 = uint32_t(av >> 32);
    const uint32_t b0 = uint32_t(bv);
    const uint32_t b1 = uint32_t(bv >> 32);
    const uint32_t c0 = uint32_t(cv);
    const uint32_t c1 = uint32_t(cv >> 32);
    uint32_t temp[4];

    asm("mul.lo.u32 %0, %2, %3; mul.hi.u32 %1, %2, %3;"
        : "=r"(temp[0]), "=r"(temp[1])
        : "r"(a0), "r"(b0));
    asm("mul.lo.u32 %0, %2, %3; mul.hi.u32 %1, %2, %3;"
        : "=r"(temp[2]), "=r"(temp[3])
        : "r"(a1), "r"(b1));

    uint32_t carry;
    asm("mad.lo.cc.u32 %0, %3, %4, %0; madc.hi.cc.u32 %1, %3, %4, %1; addc.u32 %2, 0, 0;"
        : "+r"(temp[1]), "+r"(temp[2]), "=r"(carry)
        : "r"(a0), "r"(b1));
    asm("mad.lo.cc.u32 %0, %3, %4, %0; madc.hi.cc.u32 %1, %3, %4, %1; addc.u32 %2, %2, %5;"
        : "+r"(temp[1]), "+r"(temp[2]), "+r"(temp[3])
        : "r"(a1), "r"(b0), "r"(carry));

    asm("add.cc.u32 %0, %0, %4; addc.cc.u32 %1, %1, %5; addc.cc.u32 %2, %2, 0; addc.u32 %3, %3, 0;"
        : "+r"(temp[0]), "+r"(temp[1]), "+r"(temp[2]), "+r"(temp[3])
        : "r"(c0), "r"(c1));

#if __CUDA_ARCH__ >= 700
    asm("mad.lo.cc.u32 %0, %2, %3, %0; madc.hi.cc.u32 %1, %2, %3, %1; addc.u32 %2, 0, 0;"
        : "+r"(temp[0]), "+r"(temp[1]), "+r"(temp[2])
        : "r"(gl64_device::W));
#else
    uint32_t r0, r1;

    asm("sub.cc.u32 %0, 0, %2; subc.u32 %1, %2, 0;"
        : "=r"(r0), "=r"(r1)
        : "r"(temp[2]));
    asm("add.cc.u32 %0, %0, %3; addc.cc.u32 %1, %1, %4; addc.u32 %2, 0, 0;"
        : "+r"(temp[0]), "+r"(temp[1]), "=r"(temp[2])
        : "r"(r0), "r"(r1));
#endif
    asm("sub.cc.u32 %0, %0, %3; subc.cc.u32 %1, %1, 0; subc.u32 %2, %2, 0;"
        : "+r"(temp[0]), "+r"(temp[1]), "+r"(temp[2])
        : "r"(temp[3]));

    asm("sub.cc.u32 %0, %0, %2; subc.u32 %1, %1, %3;"
        : "+r"(temp[0]), "+r"(temp[1])
        : "r"(temp[2]), "r"(-(int)temp[2] >> 1));

    gl64_t out;
    uint64_t val;
    asm("mov.b64 %0, {%1, %2};" : "=l"(val) : "r"(temp[0]), "r"(temp[1]));
    out[0] = val;
    out.to();
    return out;
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void add_2(gl64_t *x, const gl64_t C[SPONGE_WIDTH_T])
{
#pragma unroll
    for (int i = 0; i < SPONGE_WIDTH_T; ++i)
    {
        x[0] = x[0] + C[i];
    }
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void prod_2(gl64_t *x, const gl64_t alpha, const gl64_t C[SPONGE_WIDTH_T])
{
#pragma unroll
    for (int i = 0; i < SPONGE_WIDTH_T; ++i)
    {
        x[i] = alpha * C[i];
    }
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void pow7add_2(gl64_t *x, const gl64_t C[SPONGE_WIDTH_T])
{
    
#pragma unroll
    for (int i = 0; i < SPONGE_WIDTH_T; ++i)
    {
        gl64_t xi = x[i] + C[i];
        gl64_t x2 = xi * xi;
        gl64_t x3 = xi * x2;
        gl64_t x4 = x2 * x2;
        x[i] = x3 * x4;
    }
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void matmul_external_(gl64_t *x)
{
#pragma unroll
    for(int i=0; i<SPONGE_WIDTH_T; i+=4)
        matmul_m4_(&x[i]);

    if( SPONGE_WIDTH_T > 4 ){
        gl64_linear_accum_t stored[4]={
            {uint64_t(0), 0},
            {uint64_t(0), 0},
            {uint64_t(0), 0},
            {uint64_t(0), 0}
        };
        for(int i=0; i<SPONGE_WIDTH_T; i+=4){
            stored[0] = gl64_linear_add(stored[0], gl64_linear_accum(x[i + 0]));
            stored[1] = gl64_linear_add(stored[1], gl64_linear_accum(x[i + 1]));
            stored[2] = gl64_linear_add(stored[2], gl64_linear_accum(x[i + 2]));
            stored[3] = gl64_linear_add(stored[3], gl64_linear_accum(x[i + 3]));
        }
    #pragma unroll
        for (int i = 0; i < SPONGE_WIDTH_T; ++i)
        {
            x[i] = gl64_linear_fold(gl64_linear_add(gl64_linear_accum(x[i]), stored[i & 3]));
        }
    }
}

__device__ __forceinline__ void matmul_m4_(gl64_t *x)
{
    gl64_linear_accum_t x0 = gl64_linear_accum(x[0]);
    gl64_linear_accum_t x1 = gl64_linear_accum(x[1]);
    gl64_linear_accum_t x2 = gl64_linear_accum(x[2]);
    gl64_linear_accum_t x3 = gl64_linear_accum(x[3]);

    gl64_linear_accum_t t0 = gl64_linear_add(x0, x1);
    gl64_linear_accum_t t1 = gl64_linear_add(x2, x3);
    gl64_linear_accum_t t2 = gl64_linear_add(gl64_linear_add(x1, x1), t1);
    gl64_linear_accum_t t3 = gl64_linear_add(gl64_linear_add(x3, x3), t0);
    gl64_linear_accum_t t1_2 = gl64_linear_add(t1, t1);
    gl64_linear_accum_t t0_2 = gl64_linear_add(t0, t0);
    gl64_linear_accum_t t4 = gl64_linear_add(gl64_linear_add(t1_2, t1_2), t3);
    gl64_linear_accum_t t5 = gl64_linear_add(gl64_linear_add(t0_2, t0_2), t2);
    gl64_linear_accum_t t6 = gl64_linear_add(t3, t5);
    gl64_linear_accum_t t7 = gl64_linear_add(t2, t4);

    x[0] = gl64_linear_fold(t6);
    x[1] = gl64_linear_fold(t5);
    x[2] = gl64_linear_fold(t7);
    x[3] = gl64_linear_fold(t4);
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void prodadd_(gl64_t *x, const gl64_t D[SPONGE_WIDTH_T], const gl64_t &sum)
{
#pragma unroll
    for (int i = 0; i < SPONGE_WIDTH_T; ++i)
    {
        x[i] = gl64_mul_add(x[i], D[i], sum);
    }
}

template<uint32_t SPONGE_WIDTH_T>
__device__ __forceinline__ gl64_t sum_state_(const gl64_t *state)
{
    gl64_linear_accum_t sum = gl64_linear_accum(state[0]);
#pragma unroll
    for (int i = 1; i < SPONGE_WIDTH_T; ++i)
    {
        sum = gl64_linear_add(sum, gl64_linear_accum(state[i]));
    }
    return gl64_linear_fold(sum);
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void hash_full_result_seq_2(gl64_t *state, const gl64_t *input, const gl64_t *GPU_C_GL, const gl64_t *GPU_D_GL)
{
    mymemcpy((uint64_t *)state, (uint64_t *)input, SPONGE_WIDTH_T);
    
    matmul_external_<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(state);

    for (int r = 0; r < (N_FULL_ROUNDS_TOTAL_T>>1); r++)
    {
        pow7add_2<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(state, &(GPU_C_GL[r * SPONGE_WIDTH_T]));
        matmul_external_<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T> (state);
    }

    for (int r = 0; r < N_PARTIAL_ROUNDS_T; r++)
    {
        state[0] = state[0] + GPU_C_GL[(N_FULL_ROUNDS_TOTAL_T>>1) * SPONGE_WIDTH_T + r];
        pow7_2(state[0]);
        gl64_t sum_ = sum_state_<SPONGE_WIDTH_T>(state);
        prodadd_<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(state, GPU_D_GL, sum_);
    }

    for (int r = 0; r < (N_FULL_ROUNDS_TOTAL_T>>1); r++)
    {
        pow7add_2<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(state, &(GPU_C_GL[(N_FULL_ROUNDS_TOTAL_T>>1) * SPONGE_WIDTH_T + N_PARTIAL_ROUNDS_T + r * SPONGE_WIDTH_T]));
        matmul_external_<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(state);
    }
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void hash_full_result_seq_2_(gl64_t *state, const gl64_t *GPU_C_GL, const gl64_t *GPU_D_GL)
{
    
    
    matmul_external_<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(state);

    for (int r = 0; r < (N_FULL_ROUNDS_TOTAL_T>>1); r++)
    {
        pow7add_2<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(state, &(GPU_C_GL[r * SPONGE_WIDTH_T]));
        matmul_external_<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T> (state);
    }

    for (int r = 0; r < N_PARTIAL_ROUNDS_T; r++)
    {
        state[0] = state[0] + GPU_C_GL[(N_FULL_ROUNDS_TOTAL_T>>1) * SPONGE_WIDTH_T + r];
        pow7_2(state[0]);
        gl64_t sum_ = sum_state_<SPONGE_WIDTH_T>(state);
        prodadd_<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(state, GPU_D_GL, sum_);
    }

    for (int r = 0; r < (N_FULL_ROUNDS_TOTAL_T>>1); r++)
    {
        pow7add_2<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(state, &(GPU_C_GL[(N_FULL_ROUNDS_TOTAL_T>>1) * SPONGE_WIDTH_T + N_PARTIAL_ROUNDS_T + r * SPONGE_WIDTH_T]));
        matmul_external_<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(state);
    }
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void add_state_2(gl64_t *x)
{
    gl64_linear_accum_t sum = gl64_linear_accum(x[0]);
#pragma unroll
    for (uint32_t i = 0; i < SPONGE_WIDTH_T; i++)
       sum = gl64_linear_add(sum, gl64_linear_accum(scratchpad[i * blockDim.x + threadIdx.x]));
    x[0] = gl64_linear_fold(sum);
}

__device__ __forceinline__ void matmul_m4_state_(uint32_t offset)
{
    
    gl64_t t0 = scratchpad[(offset + 0) * blockDim.x + threadIdx.x] + scratchpad[(offset + 1) * blockDim.x + threadIdx.x];
    gl64_t t1 = scratchpad[(offset + 2) * blockDim.x + threadIdx.x] + scratchpad[(offset + 3) * blockDim.x + threadIdx.x];
    gl64_t t2 = scratchpad[(offset + 1) * blockDim.x + threadIdx.x] + scratchpad[(offset + 1) * blockDim.x + threadIdx.x] + t1;
    gl64_t t3 = scratchpad[(offset + 3) * blockDim.x + threadIdx.x] + scratchpad[(offset + 3) * blockDim.x + threadIdx.x] + t0;
    gl64_t t1_2 = t1 + t1;
    gl64_t t0_2 = t0 + t0;
    gl64_t t4 = t1_2 + t1_2 + t3;
    gl64_t t5 = t0_2 + t0_2 + t2;
    gl64_t t6 = t3 + t5;
    gl64_t t7 = t2 + t4;

    scratchpad[(offset + 0) * blockDim.x + threadIdx.x] = t6;
    scratchpad[(offset + 1) * blockDim.x + threadIdx.x] = t5;
    scratchpad[(offset + 2) * blockDim.x + threadIdx.x] = t7;
    scratchpad[(offset + 3) * blockDim.x + threadIdx.x] = t4;

}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void matmul_external_state_()
{

#pragma unroll
    for(int i=0; i<SPONGE_WIDTH_T; i+=4){
        matmul_m4_state_(i);
    }
    if(SPONGE_WIDTH_T > 4){
        gl64_t stored[4]={gl64_t(uint64_t(0)), gl64_t(uint64_t(0)), gl64_t(uint64_t(0)), gl64_t(uint64_t(0))};
        for(int i=0; i<SPONGE_WIDTH_T; i+=4){
            stored[0] = stored[0] + scratchpad[(i + 0) * blockDim.x + threadIdx.x];
            stored[1] = stored[1] + scratchpad[(i + 1) * blockDim.x + threadIdx.x];
            stored[2] = stored[2] + scratchpad[(i + 2) * blockDim.x + threadIdx.x];
            stored[3] = stored[3] + scratchpad[(i + 3) * blockDim.x + threadIdx.x];
        }
    #pragma unroll
        for (int i = 0; i < SPONGE_WIDTH_T; ++i)
        {
            scratchpad[i * blockDim.x + threadIdx.x] = scratchpad[i * blockDim.x + threadIdx.x] + stored[i & 3];
        }
    }
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void pow7add_state_(const gl64_t C[SPONGE_WIDTH_T])
{
    
#pragma unroll
    for (int i = 0; i < SPONGE_WIDTH_T; ++i)
    {
        gl64_t xi = scratchpad[i * blockDim.x + threadIdx.x] + C[i];
        gl64_t x2 = xi * xi;
        gl64_t x3 = xi * x2;
        gl64_t x4 = x2 * x2;
        scratchpad[i * blockDim.x + threadIdx.x] = x3 * x4;
    }
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void prodadd_state_(const gl64_t D[SPONGE_WIDTH_T], const gl64_t &sum)
{
#pragma unroll
    for (int i = 0; i < SPONGE_WIDTH_T; ++i)
    {
        scratchpad[i * blockDim.x + threadIdx.x] = scratchpad[i * blockDim.x + threadIdx.x] * D[i] + sum;
    }
}


template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void poseidon2_hash_with_constants(const gl64_t *GPU_C_GL, const gl64_t *GPU_D_GL)
{
    matmul_external_state_<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>();
    for (int r = 0; r < (N_FULL_ROUNDS_TOTAL_T>>1); r++)
    {
        pow7add_state_<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(&(GPU_C_GL[r * SPONGE_WIDTH_T]));
        matmul_external_state_<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>();
    }

    for(int r = 0; r < N_PARTIAL_ROUNDS_T; r++)
    {
        scratchpad[threadIdx.x] = scratchpad[threadIdx.x] + GPU_C_GL[(N_FULL_ROUNDS_TOTAL_T>>1) * SPONGE_WIDTH_T + r];
        pow7_2(scratchpad[threadIdx.x]);
        gl64_t sum_;
        sum_ = gl64_t(uint64_t(0));
        add_state_2<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(&sum_);
        prodadd_state_<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(GPU_D_GL, sum_);
    }

    for (int r = 0; r < (N_FULL_ROUNDS_TOTAL_T>>1); r++)
    {
        pow7add_state_<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(&(GPU_C_GL[(N_FULL_ROUNDS_TOTAL_T>>1) * SPONGE_WIDTH_T + N_PARTIAL_ROUNDS_T + r * SPONGE_WIDTH_T]));
        matmul_external_state_<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>();
    }
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void poseidon2_hash_shared(gl64_t *out, const gl64_t *in, const gl64_t *GPU_C_GL, const gl64_t *GPU_D_GL)
{
    for (int i = 0; i < SPONGE_WIDTH_T; i++) {
        scratchpad[i * blockDim.x + threadIdx.x] = in[i];
    }

    poseidon2_hash_with_constants<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(GPU_C_GL, GPU_D_GL);
    
    for (int i = 0; i < SPONGE_WIDTH_T; i++) {
        out[i] = scratchpad[i * blockDim.x + threadIdx.x];
    }
}

template<uint32_t SPONGE_WIDTH_T>
class Poseidon2GoldilocksGPU  {
public:
    static_assert(SPONGE_WIDTH_T == 4 || SPONGE_WIDTH_T == 8 || SPONGE_WIDTH_T == 12 || SPONGE_WIDTH_T == 16, "SPONGE_WIDTH_T must be 4, 8, 12, or 16");
    static constexpr uint32_t RATE = SPONGE_WIDTH_T-4;
    static constexpr uint32_t CAPACITY = 4;
    static constexpr uint32_t SPONGE_WIDTH = SPONGE_WIDTH_T;
    static constexpr uint32_t N_FULL_ROUNDS_TOTAL = 8;
    static constexpr uint32_t HALF_N_FULL_ROUNDS = N_FULL_ROUNDS_TOTAL / 2;
    static constexpr uint32_t N_PARTIAL_ROUNDS = SPONGE_WIDTH_T == 4 ? 21 : 22;
    static constexpr uint32_t N_ROUNDS = N_FULL_ROUNDS_TOTAL + N_PARTIAL_ROUNDS;
   
    void static initPoseidon2GPUConstants(uint32_t* gpu_ids, uint32_t num_gpu_ids);

    void static linearHashCoalescedBlocks(uint64_t * d_hash_output, uint64_t * d_trace, uint64_t num_cols, uint64_t num_rows, cudaStream_t stream);

    void static merkletreeCoalesced(uint32_t arity, uint64_t *d_tree, uint64_t *d_input, uint64_t num_cols, uint64_t num_rows, cudaStream_t stream, int nThreads = 0, uint64_t dim = 1);

    void static merkletreeCoalescedBlocks(uint32_t arity, uint64_t *d_tree, uint64_t *d_input, uint64_t num_cols, uint64_t num_rows, cudaStream_t stream, int nThreads = 0, uint64_t dim = 1);

    // Hash from blocked-row-major layout (NTT output) without requiring tiled transpose first
    void static merkletreeRowMajor(uint32_t arity, uint64_t *d_tree, uint64_t *d_input, uint64_t num_cols, uint64_t num_rows, cudaStream_t stream);


    void static hashFullResult(uint64_t * output, const uint64_t * input);

    void static grinding(uint64_t * d_nonce, uint64_t *d_nonceBlock, const uint64_t * d_in, const uint32_t n_bits, cudaStream_t stream);
    
};

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void poseidon2_load(const uint64_t *in, uint32_t initial_col, uint32_t ncols,
                                               uint32_t col_stride, size_t row_stride = 1)
{
    gl64_t r[RATE_T];

    const size_t tid = threadIdx.x + blockDim.x * (size_t)blockIdx.x;
    in += tid * col_stride + initial_col * row_stride;

#pragma unroll
    for (uint32_t i = 0; i < RATE_T; i++, in += row_stride)
        if (i < ncols){
            r[i] = __ldcv((uint64_t *)in);
        }

    __syncwarp();

    for (uint32_t i = 0; i < RATE_T; i++)
        scratchpad[i * blockDim.x + threadIdx.x] = r[i];

    __syncwarp();
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ void poseidon2_load_blocks(const uint64_t *in, uint64_t num_rows, uint64_t num_cols, uint32_t initial_col, uint32_t ncols)
{
    gl64_t r[RATE_T];

    uint32_t row = blockIdx.x * blockDim.x + threadIdx.x;

#pragma unroll
    for (uint32_t i = 0; i < RATE_T; i++) {
        if (i < ncols){
            uint32_t col = initial_col + i;
            uint64_t idx = getBufferOffset(row, col, num_rows, num_cols);
            r[i] = in[idx];
        }
    }

    __syncwarp();

    for (uint32_t i = 0; i < RATE_T; i++)
        scratchpad[i * blockDim.x + threadIdx.x] = r[i];

    __syncwarp();
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void poseidon2_store(uint64_t *__restrict__ out, uint32_t col_stride, size_t row_stride)
{
    gl64_t r[CAPACITY_T];

    __syncwarp();

#pragma unroll
    for (uint32_t i = 0; i < CAPACITY_T; i++)
        r[i] = scratchpad[i * blockDim.x + threadIdx.x];

    __syncwarp();

    const size_t tid = threadIdx.x + blockDim.x * (size_t)blockIdx.x;
    out += tid * col_stride;

#pragma unroll
    for (uint32_t i = 0; i < CAPACITY_T; i++, out++)
        *(uint64_t *)out = r[i];
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void poseidon2_hash_loop(const uint64_t *__restrict__ in, uint32_t ncols)
{
    for (uint32_t col = 0;;)
    {
        uint32_t delta = min(ncols - col, RATE_T);
        poseidon2_load<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(in, col, delta, ncols);
        if (delta < RATE_T)
        {
            for (uint32_t i = delta; i < RATE_T; i++)
            {
                scratchpad[i * blockDim.x + threadIdx.x] = gl64_t(uint64_t(0)); 
            }
        }

        poseidon2_hash<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>();

        if ((col += RATE_T) >= ncols)
            break;

        gl64_t tmp[CAPACITY_T];

#pragma unroll
        for (uint32_t i = 0; i < CAPACITY_T; i++)
            tmp[i] = scratchpad[i * blockDim.x + threadIdx.x];
        __syncwarp();

#pragma unroll

        for (uint32_t i = 0; i < CAPACITY_T; i++)
            scratchpad[(i + RATE_T) * blockDim.x + threadIdx.x] = tmp[i];
        __syncwarp();
    }
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__device__ __forceinline__ void poseidon2_hash_loop_blocks(const uint64_t *__restrict__ in, uint32_t num_cols, uint32_t num_rows)
{
    for (uint32_t col = 0;;)
    {
        uint32_t delta = min(num_cols - col, RATE_T);
        poseidon2_load_blocks<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T >(in, num_rows, num_cols, col, delta);
        if (delta < RATE_T)
        {
            for (uint32_t i = delta; i < RATE_T; i++)
            {
                scratchpad[i * blockDim.x + threadIdx.x] = gl64_t(uint64_t(0)); 
            }
        }
        poseidon2_hash<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>();

        if ((col += RATE_T) >= num_cols)
            break;

        gl64_t tmp[CAPACITY_T];

#pragma unroll
        for (uint32_t i = 0; i < CAPACITY_T; i++)
            tmp[i] = scratchpad[i * blockDim.x + threadIdx.x];
        __syncwarp();

#pragma unroll

        for (uint32_t i = 0; i < CAPACITY_T; i++)
            scratchpad[(i + RATE_T) * blockDim.x + threadIdx.x] = tmp[i];
        __syncwarp();
    }
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__global__ void hash_full_result_2(uint64_t * output, const uint64_t * input){
    for (uint32_t i = 0; i < SPONGE_WIDTH_T; i++){
        scratchpad[i * blockDim.x + threadIdx.x] = input[i * blockDim.x + threadIdx.x];
    }
    __syncwarp();
    poseidon2_hash<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>();
    for (uint32_t i = 0; i < SPONGE_WIDTH_T; i++){
        output[i * blockDim.x + threadIdx.x] = scratchpad[i * blockDim.x + threadIdx.x];
    }
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__global__ void linearHashGPU(uint64_t *__restrict__ output, uint64_t *__restrict__ input, uint32_t num_cols, uint32_t num_rows)
{
#pragma unroll
    for (uint32_t i = 0; i < CAPACITY_T; i++)
        scratchpad[(i + RATE_T) * blockDim.x + threadIdx.x] = gl64_t(uint64_t(0)); 

    poseidon2_hash_loop<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(input, num_cols);
    poseidon2_store<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(output, CAPACITY_T, 1);
}

// Leaf hash reading from blocked-row-major layout (getBufferOffsetRowMajor).
// This matches NTT output layout, allowing Merkle hashing BEFORE the tiled transpose.
template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__global__ void linearHashGPURowMajor(uint64_t *__restrict__ output, uint64_t *__restrict__ input, uint32_t num_cols, uint32_t num_rows)
{
#pragma unroll
    for (uint32_t i = 0; i < CAPACITY_T; i++)
        scratchpad[(i + RATE_T) * blockDim.x + threadIdx.x] = gl64_t(uint64_t(0));

    uint32_t row = blockIdx.x * blockDim.x + threadIdx.x;
    for (uint32_t col = 0;;)
    {
        uint32_t delta = min(num_cols - col, RATE_T);
        gl64_t r[RATE_T];
        #pragma unroll
        for (uint32_t i = 0; i < RATE_T; i++) {
            if (i < delta && row < num_rows) {
                r[i] = input[getBufferOffsetRowMajor(row, col + i, num_rows, num_cols)];
            } else {
                r[i] = gl64_t(uint64_t(0));
            }
        }
        __syncwarp();
        for (uint32_t i = 0; i < RATE_T; i++)
            scratchpad[i * blockDim.x + threadIdx.x] = r[i];
        __syncwarp();
        poseidon2_hash<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>();
        if ((col += RATE_T) >= num_cols)
            break;
        gl64_t tmp[CAPACITY_T];
        #pragma unroll
        for (uint32_t i = 0; i < CAPACITY_T; i++)
            tmp[i] = scratchpad[i * blockDim.x + threadIdx.x];
        __syncwarp();
        #pragma unroll
        for (uint32_t i = 0; i < CAPACITY_T; i++)
            scratchpad[(i + RATE_T) * blockDim.x + threadIdx.x] = tmp[i];
        __syncwarp();
    }
    poseidon2_store<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(output, CAPACITY_T, 1);
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__global__ void linearHashGPUTiles(uint64_t *__restrict__ output, uint64_t *__restrict__ input, uint32_t num_cols, uint32_t num_rows)
{
#pragma unroll
    for (uint32_t i = 0; i < CAPACITY_T; i++)
        scratchpad[(i + RATE_T) * blockDim.x + threadIdx.x] = gl64_t(uint64_t(0));

    poseidon2_hash_loop_blocks<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(input, num_cols, num_rows);
    poseidon2_store<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(output, CAPACITY_T, 1);
}

template<uint32_t RATE_T, uint32_t CAPACITY_T, uint32_t SPONGE_WIDTH_T, uint32_t N_FULL_ROUNDS_TOTAL_T, uint32_t N_PARTIAL_ROUNDS_T>
__global__ void __launch_bounds__(128, 7) hash_gpu_3(uint32_t nextN, uint32_t nextIndex, uint32_t pending, uint64_t *cursor)
{
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if (tid >= nextN)
        return;

    gl64_t* pol_input = (gl64_t *)(&cursor[nextIndex + tid * SPONGE_WIDTH_T]);
    gl64_t* pol_output = (gl64_t *)(&cursor[nextIndex + (pending + tid) * CAPACITY_T]);
    
    hash_one_const<RATE_T, CAPACITY_T, SPONGE_WIDTH_T, N_FULL_ROUNDS_TOTAL_T, N_PARTIAL_ROUNDS_T>(pol_output, pol_input);
}


using Poseidon2GoldilocksGPUGrinding = Poseidon2GoldilocksGPU<4>;  // SPONGE_WIDTH = 4

#endif
