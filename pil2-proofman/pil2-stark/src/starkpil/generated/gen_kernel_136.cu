// Standalone generated kernel for expression 136
// Compiled in its own CU for optimal register allocation
#include "expressions_gpu.cuh"
#include "cuda_utils.cuh"
#include "cuda_utils.hpp"
#include "gl64_tooling.cuh"
#include "goldilocks_cubic_extension.cuh"

extern __shared__ Goldilocks::Element scratchpad[];

// Local storePolynomial__
__device__ __noinline__ static void storePolynomial__(ExpsArguments *d_expsArgs, Goldilocks::Element *destVals, uint64_t row)
{
    #pragma unroll
    for (uint32_t i = 0; i < d_expsArgs->dest_dim; i++) {
        if (!d_expsArgs->dest_expr) {
            uint64_t col = d_expsArgs->dest_stagePos + i;
            uint64_t nRows = d_expsArgs->dest_domainSize;
            uint64_t nCols = d_expsArgs->dest_stageCols;
            uint64_t idx = getBufferOffset(row + threadIdx.x, col, nRows, nCols);
            d_expsArgs->dest_gpu[idx] = destVals[i * blockDim.x + threadIdx.x];
        } else {
            d_expsArgs->dest_gpu[(row + threadIdx.x) * d_expsArgs->dest_dim + i] = destVals[i * blockDim.x + threadIdx.x];
        }
    }
}

#include "gen_eval_136.cuh"

__global__ void computeExpression_gen_136_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams)
{
    int chunk_idx = blockIdx.x;
    uint64_t nchunks = d_expsArgs->domainSize / blockDim.x;
    uint32_t bufferCommitsSize = d_deviceArgs->bufferCommitSize;
    Goldilocks::Element **expressions_params = (Goldilocks::Element **)scratchpad;
    Goldilocks::Element *smem_after_ptrs = scratchpad + 32;
    uint64_t tmpTotal = d_expsArgs->maxTemp1Size + d_expsArgs->maxTemp3Size;
    bool useTmpSmem = tmpTotal > 0 && tmpTotal <= 5120;
    if (threadIdx.x == 0) {
        if (useTmpSmem) {
            expressions_params[bufferCommitsSize + 0] = smem_after_ptrs;
            expressions_params[bufferCommitsSize + 1] = smem_after_ptrs + d_expsArgs->maxTemp1Size;
        } else {
            expressions_params[bufferCommitsSize + 0] = (&d_params->aux_trace[d_expsArgs->offsetTmp1 + blockIdx.x * d_expsArgs->maxTemp1Size]);
            expressions_params[bufferCommitsSize + 1] = (&d_params->aux_trace[d_expsArgs->offsetTmp3 + blockIdx.x * d_expsArgs->maxTemp3Size]);
        }
        expressions_params[bufferCommitsSize + 2] = d_params->publicInputs;
        expressions_params[bufferCommitsSize + 3] = d_deviceArgs->numbers;
        expressions_params[bufferCommitsSize + 4] = d_params->airValues;
        expressions_params[bufferCommitsSize + 5] = d_params->proofValues;
        expressions_params[bufferCommitsSize + 6] = d_params->airgroupValues;
        expressions_params[bufferCommitsSize + 7] = d_params->challenges;
        expressions_params[bufferCommitsSize + 8] = d_params->evals;
    }
    __syncthreads();
    uint64_t k_min_chunk = d_expsArgs->k_min / blockDim.x;
    uint64_t k_max_chunk = d_expsArgs->k_max / blockDim.x;
    while (chunk_idx < nchunks) {
        uint64_t i = chunk_idx * blockDim.x;
        if (chunk_idx < k_min_chunk || chunk_idx >= k_max_chunk) {
            eval_expr_b2412d29<true>(d_params, d_deviceArgs, d_expsArgs, expressions_params, bufferCommitsSize, i);
        } else {
            eval_expr_b2412d29<false>(d_params, d_deviceArgs, d_expsArgs, expressions_params, bufferCommitsSize, i);
        }
        chunk_idx += gridDim.x;
    }
}
