#!/usr/bin/env python3
"""
Generate multi-file chunked expression evaluators for large expressions.

Instead of putting all chunks in one file (which causes cicc to take 30+ minutes),
this generates each chunk as a separate __global__ kernel in its own .cu file.

A host-side wrapper dispatches the chunks sequentially on the same stream,
passing the cubic accumulator through global memory between chunks.
"""

import struct
import sys
import os
import hashlib

# Import from the main generator
sys.path.insert(0, os.path.dirname(__file__))
from gen_expression_evaluator import read_dump, gen_load, find_chunk_boundaries


def generate_chunk_kernel(dump, chunk_idx, chunk_start, chunk_end, fp, all_tmp3_slots,
                          stride_offsets, stage_types_used, out_path):
    """Generate a standalone .cu file for one chunk of a large expression."""
    ops = dump['ops']
    args = dump['args']
    strides = dump['strides']
    base = dump['bufferCommitSize']
    chunk_ops_count = chunk_end - chunk_start

    # Find tmp1 indices used in this chunk
    chunk_tmp1_used = set()
    for i in range(chunk_start, chunk_end):
        b = i * 8
        if ops[i] == 0:
            chunk_tmp1_used.add(args[b + 1])
        if args[b + 2] == base:
            chunk_tmp1_used.add(args[b + 3])
        if args[b + 5] == base:
            chunk_tmp1_used.add(args[b + 6])

    L = []
    L.append(f'// Auto-generated chunk {chunk_idx} for expression {dump["expId"]}')
    L.append(f'// Ops [{chunk_start}, {chunk_end}) = {chunk_ops_count} ops')
    L.append('#include "expressions_gpu.cuh"')
    L.append('#include "cuda_utils.cuh"')
    L.append('#include "cuda_utils.hpp"')
    L.append('#include "gl64_tooling.cuh"')
    L.append('#include "goldilocks_cubic_extension.cuh"')
    L.append('')

    # The chunk kernel reads/writes the cubic accumulator from a global buffer
    # acc_buf layout: [nThreads * nTmp3Slots] gl64_t values
    # Each thread accesses acc_buf[slot * blockDim.x + threadIdx.x]
    L.append(f'__global__ void chunk_{fp}_{chunk_idx}_kernel(')
    L.append('    StepsParams *d_params,')
    L.append('    DeviceArguments *d_deviceArgs,')
    L.append('    ExpsArguments *d_expsArgs,')
    L.append('    DestParamsGPU *d_destParams,')
    L.append('    Goldilocks::Element *acc_buf)')
    L.append('{')
    L.append('    int chunk_idx = blockIdx.x;')
    L.append('    uint64_t nchunks = d_expsArgs->domainSize / blockDim.x;')
    L.append('    uint32_t bufferCommitsSize = d_deviceArgs->bufferCommitSize;')
    L.append('')
    L.append('    // Setup expressions_params in shared memory')
    L.append('    extern __shared__ Goldilocks::Element scratchpad[];')
    L.append('    Goldilocks::Element **expressions_params = (Goldilocks::Element **)scratchpad;')
    L.append('    if (threadIdx.x == 0) {')
    L.append('        expressions_params[bufferCommitsSize + 2] = d_params->publicInputs;')
    L.append('        expressions_params[bufferCommitsSize + 3] = d_deviceArgs->numbers;')
    L.append('        expressions_params[bufferCommitsSize + 4] = d_params->airValues;')
    L.append('        expressions_params[bufferCommitsSize + 5] = d_params->proofValues;')
    L.append('        expressions_params[bufferCommitsSize + 6] = d_params->airgroupValues;')
    L.append('        expressions_params[bufferCommitsSize + 7] = d_params->challenges;')
    L.append('        expressions_params[bufferCommitsSize + 8] = d_params->evals;')
    L.append('    }')
    L.append('    __syncthreads();')
    L.append('')
    L.append('    uint64_t k_min_chunk = d_expsArgs->k_min / blockDim.x;')
    L.append('    uint64_t k_max_chunk = d_expsArgs->k_max / blockDim.x;')
    L.append('')
    L.append('    // Aliases for gen_load compatibility')
    L.append('    const StepsParams* __restrict__ dParams = d_params;')
    L.append('    const DeviceArguments* __restrict__ dArgs = d_deviceArgs;')
    L.append('    const ExpsArguments* __restrict__ dExpsArgs = d_expsArgs;')
    L.append('')
    L.append('    while (chunk_idx < nchunks) {')
    L.append('        uint64_t row = chunk_idx * blockDim.x;')
    L.append('        uint64_t r = row + threadIdx.x;')
    L.append('        bool isCyclic = (chunk_idx < k_min_chunk || chunk_idx >= k_max_chunk);')
    L.append('        const uint64_t domainSize = dExpsArgs->domainSize;')
    L.append('        const uint64_t chunkBase = row;')
    L.append('')

    # Declare logical rows
    for so in sorted(stride_offsets):
        sv = strides.get(so, 0)
        L.append(f'        const int64_t stride_{so} = d_expsArgs->nextStridesExps[{so}];')
    for so in sorted(stride_offsets):
        sv = strides.get(so, 0)
        L.append(f'        uint64_t logicalRow_{so} = isCyclic ? (r + stride_{so}) % domainSize : r + stride_{so};')

    # Pack256 flags
    for so in sorted(stride_offsets):
        sv = strides.get(so, 0)
        if sv == 0:
            L.append(f'        const bool usePack256_{so} = !isCyclic && blockDim.x == TILE_HEIGHT;')
        else:
            L.append(f'        const bool usePack256_{so} = false;')

    # nCols
    for st in sorted(stage_types_used):
        L.append(f'        const uint64_t nCols_{st} = d_deviceArgs->mapSectionsN[{st}];')

    L.append('')
    # Load accumulator from global buffer
    for t in sorted(all_tmp3_slots):
        L.append(f'        gl64_t tmp3_{t} = *(gl64_t*)&acc_buf[({t} * nchunks + chunk_idx) * blockDim.x + threadIdx.x];')

    # Declare local tmp1 variables
    for t in sorted(chunk_tmp1_used):
        L.append(f'        gl64_t tmp1_{t} = gl64_t(uint64_t(0));')
    L.append('')

    # Generate ops for this chunk
    for i in range(chunk_start, chunk_end):
        a = args[i*8:(i+1)*8]
        arith_op = a[0]
        dest_idx = a[1]
        src0_type, src0_arg, src0_offset = a[2], a[3], a[4]
        src1_type, src1_arg, src1_offset = a[5], a[6], a[7]
        op_type = ops[i]
        dim0 = 1 if op_type == 0 else 3
        dim1 = 1 if op_type <= 1 else 3

        if op_type == 0:
            dest_var = f'tmp1_{dest_idx}'
        else:
            dest_var = f'tmp3_{dest_idx}'

        src0_lines, src0_vars = gen_load(src0_type, src0_arg, src0_offset, dim0, dump, f's0_{i}')
        src1_lines, src1_vars = gen_load(src1_type, src1_arg, src1_offset, dim1, dump, f's1_{i}')
        for l in src0_lines:
            L.append(f'        {l}')
        for l in src1_lines:
            L.append(f'        {l}')

        if op_type == 0:
            av, bv = src0_vars[0], src1_vars[0]
            if arith_op == 0:   L.append(f'        {dest_var} = {av} + {bv};')
            elif arith_op == 1: L.append(f'        {dest_var} = {av} - {bv};')
            elif arith_op == 2: L.append(f'        {dest_var} = {av} * {bv};')
            elif arith_op == 3: L.append(f'        {dest_var} = {bv} - {av};')
        elif op_type == 1:
            a0, a1, a2 = src0_vars
            b0 = src1_vars[0]
            d0, d1, d2 = f'tmp3_{dest_idx}', f'tmp3_{dest_idx+1}', f'tmp3_{dest_idx+2}'
            if arith_op == 0:   L.append(f'        {d0} = {a0} + {b0}; {d1} = {a1}; {d2} = {a2};')
            elif arith_op == 1: L.append(f'        {d0} = {a0} - {b0}; {d1} = {a1}; {d2} = {a2};')
            elif arith_op == 2: L.append(f'        {d0} = {a0} * {b0}; {d1} = {a1} * {b0}; {d2} = {a2} * {b0};')
            elif arith_op == 3: L.append(f'        {d0} = {b0} - {a0}; {d1} = -({a1}); {d2} = -({a2});')
        elif op_type == 2:
            a0, a1, a2 = src0_vars
            b0, b1, b2 = src1_vars
            d0, d1, d2 = f'tmp3_{dest_idx}', f'tmp3_{dest_idx+1}', f'tmp3_{dest_idx+2}'
            if arith_op == 0:   L.append(f'        {d0} = {a0} + {b0}; {d1} = {a1} + {b1}; {d2} = {a2} + {b2};')
            elif arith_op == 1: L.append(f'        {d0} = {a0} - {b0}; {d1} = {a1} - {b1}; {d2} = {a2} - {b2};')
            elif arith_op == 2:
                L.append(f'        gl64_t kA{i} = ({a0} + {a1}) * ({b0} + {b1});')
                L.append(f'        gl64_t kB{i} = ({a0} + {a2}) * ({b0} + {b2});')
                L.append(f'        gl64_t kC{i} = ({a1} + {a2}) * ({b1} + {b2});')
                L.append(f'        gl64_t kD{i} = {a0} * {b0};')
                L.append(f'        gl64_t kE{i} = {a1} * {b1};')
                L.append(f'        gl64_t kF{i} = {a2} * {b2};')
                L.append(f'        gl64_t kG{i} = kD{i} - kE{i};')
                L.append(f'        {d0} = (kC{i} + kG{i}) - kF{i};')
                L.append(f'        {d1} = ((((kA{i} + kC{i}) - kE{i}) - kE{i}) - kD{i});')
                L.append(f'        {d2} = kB{i} - kG{i};')
            elif arith_op == 3:
                L.append(f'        {d0} = {b0} - {a0}; {d1} = {b1} - {a1}; {d2} = {b2} - {a2};')

    # Store accumulator back to global buffer
    L.append('')
    for t in sorted(all_tmp3_slots):
        L.append(f'        *(gl64_t*)&acc_buf[({t} * nchunks + chunk_idx) * blockDim.x + threadIdx.x] = tmp3_{t};')

    L.append('        chunk_idx += gridDim.x;')
    L.append('    }')
    L.append('}')

    with open(out_path, 'w') as f:
        f.write('\n'.join(L) + '\n')

    print(f"  Chunk {chunk_idx}: {chunk_ops_count} ops -> {out_path}")


def generate_wrapper_kernel(dump, fp, nChunks, all_tmp3_slots, out_path):
    """Generate the wrapper kernel that stores the final result."""
    expId = dump['expId']
    last_op_idx = dump['nOps'] - 1
    last_op_type = dump['ops'][last_op_idx]
    last_dest_idx = dump['args'][last_op_idx * 8 + 1]

    L = []
    L.append(f'// Wrapper kernel for chunked expression {expId}')
    L.append(f'// Dispatches {nChunks} chunk kernels then stores the final result')
    L.append('#include "expressions_gpu.cuh"')
    L.append('#include "cuda_utils.cuh"')
    L.append('#include "cuda_utils.hpp"')
    L.append('#include "gl64_tooling.cuh"')
    L.append('#include "goldilocks_cubic_extension.cuh"')
    L.append('')

    # Declare external chunk kernels
    for ci in range(nChunks):
        L.append(f'extern __global__ void chunk_{fp}_{ci}_kernel(StepsParams*, DeviceArguments*, ExpsArguments*, DestParamsGPU*, Goldilocks::Element*);')
    L.append('')

    # Store kernel: reads accumulator and writes to destination via storePolynomial__
    L.append('__device__ __noinline__ static void storePolynomial__(ExpsArguments *d_expsArgs, Goldilocks::Element *destVals, uint64_t row)')
    L.append('{')
    L.append('    #pragma unroll')
    L.append('    for (uint32_t i = 0; i < d_expsArgs->dest_dim; i++) {')
    L.append('        if (!d_expsArgs->dest_expr) {')
    L.append('            uint64_t col = d_expsArgs->dest_stagePos + i;')
    L.append('            uint64_t nRows = d_expsArgs->dest_domainSize;')
    L.append('            uint64_t nCols = d_expsArgs->dest_stageCols;')
    L.append('            uint64_t idx = getBufferOffset(row + threadIdx.x, col, nRows, nCols);')
    L.append('            d_expsArgs->dest_gpu[idx] = destVals[i * blockDim.x + threadIdx.x];')
    L.append('        } else {')
    L.append('            d_expsArgs->dest_gpu[(row + threadIdx.x) * d_expsArgs->dest_dim + i] = destVals[i * blockDim.x + threadIdx.x];')
    L.append('        }')
    L.append('    }')
    L.append('}')
    L.append('')

    # Final store kernel: reads accumulator from global buf, writes to destination
    nTmp3 = max(all_tmp3_slots) + 1 if all_tmp3_slots else 0
    L.append(f'__global__ void store_{fp}_kernel(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams, Goldilocks::Element *acc_buf)')
    L.append('{')
    L.append('    int chunk_idx = blockIdx.x;')
    L.append('    uint64_t nchunks = d_expsArgs->domainSize / blockDim.x;')
    L.append('    uint32_t bufferCommitsSize = d_deviceArgs->bufferCommitSize;')
    L.append('    extern __shared__ Goldilocks::Element scratchpad[];')
    L.append('    Goldilocks::Element **expressions_params = (Goldilocks::Element **)scratchpad;')
    L.append('    Goldilocks::Element *smem_after_ptrs = scratchpad + 32;')
    L.append('    uint64_t tmpTotal = d_expsArgs->maxTemp1Size + d_expsArgs->maxTemp3Size;')
    L.append('    bool useTmpSmem = tmpTotal > 0 && tmpTotal <= 5120;')
    L.append('    if (threadIdx.x == 0) {')
    L.append('        if (useTmpSmem) {')
    L.append('            expressions_params[bufferCommitsSize + 0] = smem_after_ptrs;')
    L.append('            expressions_params[bufferCommitsSize + 1] = smem_after_ptrs + d_expsArgs->maxTemp1Size;')
    L.append('        } else {')
    L.append('            expressions_params[bufferCommitsSize + 0] = (&d_params->aux_trace[d_expsArgs->offsetTmp1 + blockIdx.x * d_expsArgs->maxTemp1Size]);')
    L.append('            expressions_params[bufferCommitsSize + 1] = (&d_params->aux_trace[d_expsArgs->offsetTmp3 + blockIdx.x * d_expsArgs->maxTemp3Size]);')
    L.append('        }')
    L.append('    }')
    L.append('    __syncthreads();')
    L.append('    while (chunk_idx < nchunks) {')
    L.append('        uint64_t row = chunk_idx * blockDim.x;')

    # Read final accumulator
    L.append(f'        gl64_t tmp3_{last_dest_idx} = *(gl64_t*)&acc_buf[({last_dest_idx} * nchunks + chunk_idx) * blockDim.x + threadIdx.x];')
    L.append(f'        gl64_t tmp3_{last_dest_idx+1} = *(gl64_t*)&acc_buf[({last_dest_idx+1} * nchunks + chunk_idx) * blockDim.x + threadIdx.x];')
    L.append(f'        gl64_t tmp3_{last_dest_idx+2} = *(gl64_t*)&acc_buf[({last_dest_idx+2} * nchunks + chunk_idx) * blockDim.x + threadIdx.x];')

    # Write to shared mem and store
    L.append(f'        *(gl64_t*)&expressions_params[bufferCommitsSize + 1][{last_dest_idx} * blockDim.x + threadIdx.x] = tmp3_{last_dest_idx};')
    L.append(f'        *(gl64_t*)&expressions_params[bufferCommitsSize + 1][{last_dest_idx+1} * blockDim.x + threadIdx.x] = tmp3_{last_dest_idx+1};')
    L.append(f'        *(gl64_t*)&expressions_params[bufferCommitsSize + 1][{last_dest_idx+2} * blockDim.x + threadIdx.x] = tmp3_{last_dest_idx+2};')
    L.append(f'        storePolynomial__((ExpsArguments*)d_expsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][{last_dest_idx} * blockDim.x], row);')

    L.append('        chunk_idx += gridDim.x;')
    L.append('    }')
    L.append('}')

    with open(out_path, 'w') as f:
        f.write('\n'.join(L) + '\n')


def generate_host_dispatch(dump, fp, nChunks, all_tmp3_slots, out_path):
    """Generate the host-side dispatch function that launches all chunk kernels."""
    expId = dump['expId']
    nTmp3 = max(all_tmp3_slots) + 1 if all_tmp3_slots else 0

    L = []
    L.append(f'// Host-side dispatch for chunked expression {expId}')
    L.append(f'// Launches {nChunks} chunk kernels + 1 store kernel sequentially')
    L.append('')

    # Declare chunk kernels
    for ci in range(nChunks):
        L.append(f'__global__ void chunk_{fp}_{ci}_kernel(StepsParams*, DeviceArguments*, ExpsArguments*, DestParamsGPU*, Goldilocks::Element*);')
    L.append(f'__global__ void store_{fp}_kernel(StepsParams*, DeviceArguments*, ExpsArguments*, DestParamsGPU*, Goldilocks::Element*);')
    L.append('')

    L.append(f'inline bool dispatchChunkedKernel_{expId}(dim3 nBlocks, dim3 nThreads, size_t sharedMem, cudaStream_t stream,')
    L.append(f'    StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams,')
    L.append(f'    Goldilocks::Element *acc_buf) {{')

    for ci in range(nChunks):
        L.append(f'    chunk_{fp}_{ci}_kernel<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams, acc_buf);')
    L.append(f'    store_{fp}_kernel<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams, acc_buf);')
    L.append('    return true;')
    L.append('}')

    with open(out_path, 'w') as f:
        f.write('\n'.join(L) + '\n')


def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('dump_file', help='Path to expr_dump_*.bin file')
    parser.add_argument('--out-dir', required=True, help='Output directory')
    parser.add_argument('--chunk-size', type=int, default=7000, help='Target ops per chunk')
    args = parser.parse_args()

    dump = read_dump(args.dump_file)
    expId = dump['expId']
    nOps = dump['nOps']
    base = dump['bufferCommitSize']
    ops = dump['ops']
    ar = dump['args']
    strides = dump['strides']

    print(f"Expression {expId}: {nOps} ops")

    # Find boundaries
    boundaries = find_chunk_boundaries(dump, target_chunk_size=args.chunk_size)
    nChunks = len(boundaries)
    print(f"Split into {nChunks} chunks")

    # Collect global info
    stride_offsets = set()
    stage_types_used = set()
    for i in range(nOps):
        a = ar[i*8:(i+1)*8]
        stride_offsets.add(a[4])
        stride_offsets.add(a[7])
        for st in [a[2], a[5]]:
            if st >= 0 and st <= 3:
                stage_types_used.add(st)

    # Find all tmp3 slots used
    TMP3_TYPE = base + 1
    all_tmp3_written = set()
    all_tmp3_read = set()
    for i in range(nOps):
        b = i * 8
        op_type = ops[i]
        if op_type >= 1:
            all_tmp3_written.add(ar[b + 1])
            all_tmp3_written.add(ar[b + 1] + 1)
            all_tmp3_written.add(ar[b + 1] + 2)
        for s in range(2):
            if ar[b + 2 + s*3] == TMP3_TYPE:
                all_tmp3_read.add(ar[b + 3 + s*3])
    all_tmp3_slots = sorted(all_tmp3_written | all_tmp3_read)

    # Compute fingerprint
    fp_data = struct.pack('<IIII', nOps, dump['nTemp1'], dump['nTemp3'], dump['destDim'])
    fp_data += bytes(ops[:min(16, len(ops))])
    fp_data += struct.pack(f'<{min(32, len(ar))}H', *ar[:min(32, len(ar))])
    fp = hashlib.md5(fp_data).hexdigest()[:8]

    os.makedirs(args.out_dir, exist_ok=True)

    # Generate each chunk as a separate .cu file
    for ci, (cs, ce) in enumerate(boundaries):
        chunk_path = os.path.join(args.out_dir, f'gen_chunk_{expId}_{ci}.cu')
        generate_chunk_kernel(dump, ci, cs, ce, fp, all_tmp3_slots,
                             stride_offsets, stage_types_used, chunk_path)

    # Generate wrapper/store kernel
    wrapper_path = os.path.join(args.out_dir, f'gen_chunk_{expId}_store.cu')
    generate_wrapper_kernel(dump, fp, nChunks, all_tmp3_slots, wrapper_path)

    # Generate host dispatch header
    dispatch_path = os.path.join(args.out_dir, f'gen_chunk_{expId}_dispatch.cuh')
    generate_host_dispatch(dump, fp, nChunks, all_tmp3_slots, dispatch_path)

    print(f"Generated {nChunks} chunk .cu files + store + dispatch in {args.out_dir}")


if __name__ == '__main__':
    main()
