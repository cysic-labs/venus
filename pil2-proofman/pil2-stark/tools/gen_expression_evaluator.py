#!/usr/bin/env python3
"""
Generate optimized CUDA expression evaluator from bytecode dump.

Reads the binary dump created by the expression instrumentation and generates
a .cu file with register-resident intermediates and no interpreter overhead.

Usage: python3 gen_expression_evaluator.py /tmp/expr_dump_*.bin -o generated_eval.cuh
"""

import struct
import sys
import os
from collections import defaultdict

def read_dump(path):
    with open(path, 'rb') as f:
        data = f.read()
    off = 0
    nOps, nArgs, nTemp1, nTemp3, destDim, bufferCommitSize = struct.unpack_from('<6I', data, off)
    off += 24
    ops = list(struct.unpack_from(f'<{nOps}B', data, off))
    off += nOps
    args = list(struct.unpack_from(f'<{nArgs}H', data, off))
    off += nArgs * 2
    nNumbers, = struct.unpack_from('<I', data, off)
    off += 4
    numbers = list(struct.unpack_from(f'<{nNumbers}Q', data, off))
    return {
        'nOps': nOps, 'nArgs': nArgs, 'nTemp1': nTemp1, 'nTemp3': nTemp3,
        'destDim': destDim, 'bufferCommitSize': bufferCommitSize,
        'ops': ops, 'args': args, 'numbers': numbers, 'nNumbers': nNumbers
    }


def src_type_name(t, base):
    if t == 0: return 'constPols'
    if t == 1: return 'trace1'
    if t == 2: return 'aux_trace2'
    if t == 3: return 'aux_trace3'
    if t == 4: return 'zi'
    if t >= 5 and t < base: return f'custom{t-5}'
    if t == base: return 'tmp1'
    if t == base + 1: return 'tmp3'
    if t == base + 2: return 'publicInputs'
    if t == base + 3: return 'numbers'
    if t == base + 4: return 'airValues'
    if t == base + 5: return 'proofValues'
    if t == base + 6: return 'airgroupValues'
    if t == base + 7: return 'challenges'
    if t == base + 8: return 'evals'
    return f'unknown{t}'


def gen_load(src_type, src_arg, src_offset, dim, base, indent='    '):
    """Generate code to load a source operand into register variables."""
    name = src_type_name(src_type, base)

    # Temp buffers: direct register access
    if src_type == base:  # tmp1
        return f'tmp1_{src_arg}'
    if src_type == base + 1:  # tmp3
        if dim == 1:
            return f'tmp3_{src_arg}_0'  # Should not happen for tmp3 with dim=1
        return None  # Will handle dim3 separately

    # Constants/broadcasts (same value for all threads)
    if src_type >= base + 2:
        return None  # Will handle inline

    # Polynomial data: needs getBufferOffset
    return None  # Will handle inline


def gen_src_code(src_type, src_arg, src_offset, dim, base, var_prefix, is_cyclic_var):
    """Generate code to load a source operand. Returns (code_lines, var_names)."""
    lines = []

    if src_type == base:  # tmp1
        return lines, [f'tmp1_{src_arg}', None, None]

    if src_type == base + 1:  # tmp3
        if dim == 1:
            return lines, [f'tmp3_{src_arg}_0', None, None]
        return lines, [f'tmp3_{src_arg}_0', f'tmp3_{src_arg}_1', f'tmp3_{src_arg}_2']

    if src_type >= base + 2:  # broadcast constants
        type_idx = src_type
        if dim == 1:
            v = f'{var_prefix}'
            lines.append(f'gl64_t {v} = *(gl64_t*)&expressions_params[{type_idx}][{src_arg}];')
            return lines, [v, None, None]
        else:
            v0, v1, v2 = f'{var_prefix}_0', f'{var_prefix}_1', f'{var_prefix}_2'
            lines.append(f'gl64_t {v0} = *(gl64_t*)&expressions_params[{type_idx}][{src_arg}];')
            lines.append(f'gl64_t {v1} = *(gl64_t*)&expressions_params[{type_idx}][{src_arg}+1];')
            lines.append(f'gl64_t {v2} = *(gl64_t*)&expressions_params[{type_idx}][{src_arg}+2];')
            return lines, [v0, v1, v2]

    # Polynomial data types
    if src_type == 0:  # constPols
        ptr_expr = 'dExpsArgs->domainExtended ? dParams->pConstPolsExtendedTreeAddress : dParams->pConstPolsAddress'
        ncols_expr = 'dArgs->mapSectionsN[0]'
    elif src_type == 4:  # zi
        v = f'{var_prefix}'
        lines.append(f'gl64_t {v} = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + ({src_arg} - 1) * domainSize + row + threadIdx.x];')
        return lines, [v, None, None]
    elif src_type >= 1 and src_type <= 3:  # trace / aux_trace
        stage = src_type
        if stage == 1 and not True:  # Non-extended case handled below
            pass
        ncols_expr = f'dArgs->mapSectionsN[{stage}]'
        if stage == 1:
            ptr_base = 'dParams->trace'
            offset_expr = '0'
        else:
            ptr_base = 'dParams->aux_trace'
            offset_expr = f'mapOffsetsExps[{stage}]'
    else:
        # Custom commits
        idx = src_type - 4  # approximate
        v = f'{var_prefix}'
        lines.append(f'// custom commit type {src_type} not optimized')
        lines.append(f'gl64_t {v}; // TODO')
        return lines, [v, None, None]

    # Generate getBufferOffset-based load
    if src_type == 0:  # constPols
        if dim == 1:
            v = f'{var_prefix}'
            lines.append(f'gl64_t {v} = *(gl64_t*)&({ptr_expr})[usePack256 ? getBufferOffset_pack256(chunkBase, {src_arg}, domainSize, {ncols_expr}) : getBufferOffset(logicalRow_{src_offset}, {src_arg}, domainSize, {ncols_expr})];')
            return lines, [v, None, None]
        else:
            v0, v1, v2 = f'{var_prefix}_0', f'{var_prefix}_1', f'{var_prefix}_2'
            lines.append(f'{{')
            lines.append(f'  const Goldilocks::Element* basePtr = {ptr_expr};')
            lines.append(f'  uint64_t nCols = {ncols_expr};')
            for d in range(3):
                lines.append(f'  gl64_t {var_prefix}_{d} = *(gl64_t*)&basePtr[usePack256 ? getBufferOffset_pack256(chunkBase, {src_arg}+{d}, domainSize, nCols) : getBufferOffset(logicalRow_{src_offset}, {src_arg}+{d}, domainSize, nCols)];')
            lines.append(f'}}')
            return lines, [v0, v1, v2]
    elif src_type >= 1 and src_type <= 3:
        if src_type == 1:
            if dim == 1:
                v = f'{var_prefix}'
                lines.append(f'gl64_t {v} = *(gl64_t*)&dParams->trace[usePack256 ? getBufferOffset_pack256(chunkBase, {src_arg}, domainSize, {ncols_expr}) : getBufferOffset(logicalRow_{src_offset}, {src_arg}, domainSize, {ncols_expr})];')
                return lines, [v, None, None]
            else:
                v0, v1, v2 = f'{var_prefix}_0', f'{var_prefix}_1', f'{var_prefix}_2'
                lines.append(f'{{')
                lines.append(f'  uint64_t nCols = {ncols_expr};')
                for d in range(3):
                    lines.append(f'  gl64_t {var_prefix}_{d} = *(gl64_t*)&dParams->trace[usePack256 ? getBufferOffset_pack256(chunkBase, {src_arg}+{d}, domainSize, nCols) : getBufferOffset(logicalRow_{src_offset}, {src_arg}+{d}, domainSize, nCols)];')
                lines.append(f'}}')
                return lines, [v0, v1, v2]
        else:  # stage 2 or 3
            stage = src_type
            if dim == 1:
                v = f'{var_prefix}'
                lines.append(f'gl64_t {v} = *(gl64_t*)&dParams->aux_trace[mapOffsetsExps[{stage}] + (usePack256 ? getBufferOffset_pack256(chunkBase, {src_arg}, domainSize, {ncols_expr}) : getBufferOffset(logicalRow_{src_offset}, {src_arg}, domainSize, {ncols_expr}))];')
                return lines, [v, None, None]
            else:
                v0, v1, v2 = f'{var_prefix}_0', f'{var_prefix}_1', f'{var_prefix}_2'
                lines.append(f'{{')
                lines.append(f'  uint64_t offset = mapOffsetsExps[{stage}];')
                lines.append(f'  uint64_t nCols = {ncols_expr};')
                # Use same-tile fast path when possible
                lines.append(f'  uint64_t pos0 = usePack256 ? getBufferOffset_pack256(chunkBase, {src_arg}, domainSize, nCols) : getBufferOffset(logicalRow_{src_offset}, {src_arg}, domainSize, nCols);')
                if src_arg is not None and isinstance(src_arg, int) and (src_arg & 3) <= 1:
                    lines.append(f'  gl64_t {var_prefix}_0 = *(gl64_t*)&dParams->aux_trace[offset + pos0];')
                    lines.append(f'  gl64_t {var_prefix}_1 = *(gl64_t*)&dParams->aux_trace[offset + pos0 + TILE_HEIGHT];')
                    lines.append(f'  gl64_t {var_prefix}_2 = *(gl64_t*)&dParams->aux_trace[offset + pos0 + 2*TILE_HEIGHT];')
                else:
                    for d in range(3):
                        lines.append(f'  uint64_t pos{d} = usePack256 ? getBufferOffset_pack256(chunkBase, {src_arg}+{d}, domainSize, nCols) : getBufferOffset(logicalRow_{src_offset}, {src_arg}+{d}, domainSize, nCols);')
                    for d in range(3):
                        lines.append(f'  gl64_t {var_prefix}_{d} = *(gl64_t*)&dParams->aux_trace[offset + pos{d}];')
                lines.append(f'}}')
                return lines, [v0, v1, v2]
    return lines, [f'{var_prefix}', None, None]


def generate_evaluator(dump, out_path):
    nOps = dump['nOps']
    nTemp1 = dump['nTemp1']
    nTemp3 = dump['nTemp3']
    destDim = dump['destDim']
    base = dump['bufferCommitSize']
    ops = dump['ops']
    args = dump['args']

    # Collect all unique stride offsets used
    stride_offsets = set()
    for i in range(nOps):
        a = args[i*8:(i+1)*8]
        stride_offsets.add(a[4])
        stride_offsets.add(a[7])

    lines = []
    lines.append('// Auto-generated expression evaluator')
    lines.append('// Keeps all temporaries in registers for maximum performance')
    lines.append('')
    lines.append('template<bool IsCyclic>')
    lines.append('__device__ __forceinline__ void eval_expression_generated_(')
    lines.append('    StepsParams *dParams, DeviceArguments *dArgs, ExpsArguments *dExpsArgs,')
    lines.append('    Goldilocks::Element **expressions_params,')
    lines.append(f'    uint32_t bufferCommitsSize, uint64_t row)')
    lines.append('{')
    lines.append('    const uint64_t domainSize = dExpsArgs->domainSize;')
    lines.append('    const uint64_t r = row + threadIdx.x;')
    lines.append('    const bool usePack256 = !IsCyclic && blockDim.x == TILE_HEIGHT;')
    lines.append('    const uint64_t chunkBase = row;')
    lines.append('')

    # Declare stride-dependent logical rows
    for so in sorted(stride_offsets):
        lines.append(f'    uint64_t logicalRow_{so};')
    lines.append('    if constexpr (IsCyclic) {')
    for so in sorted(stride_offsets):
        lines.append(f'        logicalRow_{so} = (r + dExpsArgs->nextStridesExps[{so}]) % domainSize;')
    lines.append('    } else {')
    for so in sorted(stride_offsets):
        lines.append(f'        logicalRow_{so} = r + dExpsArgs->nextStridesExps[{so}];')
    lines.append('    }')

    # Cache mapOffsetsExps values needed
    stage_types_used = set()
    for i in range(nOps):
        a = args[i*8:(i+1)*8]
        for st in [a[2], a[5]]:
            if st >= 2 and st <= 3:
                stage_types_used.add(st)
    if stage_types_used:
        lines.append('')
        lines.append('    // Cache mapOffsetsExps')
        for st in sorted(stage_types_used):
            lines.append(f'    uint64_t mapOffsetsExps[{max(stage_types_used)+1}];')
            break
        for st in sorted(stage_types_used):
            lines.append(f'    mapOffsetsExps[{st}] = dExpsArgs->mapOffsetsExps[{st}];')

    lines.append('')
    lines.append('    // Register-resident temporaries')
    for t in range(nTemp1):
        lines.append(f'    gl64_t tmp1_{t} = gl64_t(uint64_t(0));')
    for t in range(nTemp3):
        lines.append(f'    gl64_t tmp3_{t}_0 = gl64_t(uint64_t(0)), tmp3_{t}_1 = gl64_t(uint64_t(0)), tmp3_{t}_2 = gl64_t(uint64_t(0));')

    lines.append('')
    lines.append('    // Generated straight-line evaluation')

    # Track which temp was last written to know the final result
    last_dest_type = None
    last_dest_idx = None

    for i in range(nOps):
        a = args[i*8:(i+1)*8]
        arith_op = a[0]
        dest_idx = a[1]
        src0_type, src0_arg, src0_offset = a[2], a[3], a[4]
        src1_type, src1_arg, src1_offset = a[5], a[6], a[7]
        op_type = ops[i]  # 0=dim1x1, 1=dim3x1, 2=dim3x3

        arith_names = {0: 'add', 1: 'sub', 2: 'mul', 3: 'sub_swap'}
        dim0 = 1 if op_type == 0 else 3
        dim1 = 1 if op_type <= 1 else 3

        is_last = (i == nOps - 1)

        # Determine destination
        if is_last:
            # Last op writes to output - still use a temp for now
            pass

        if op_type == 0:
            dest_var = f'tmp1_{dest_idx}'
            last_dest_type = 'tmp1'
        else:
            dest_var = f'tmp3_{dest_idx}'
            last_dest_type = 'tmp3'
        last_dest_idx = dest_idx

        lines.append(f'    // Op {i}: {["dim1x1","dim3x1","dim3x3"][op_type]} {arith_names[arith_op]}')

        # Generate source loads
        src0_lines, src0_vars = gen_src_code(src0_type, src0_arg, src0_offset, dim0, base, f's0_{i}', 'IsCyclic')
        src1_lines, src1_vars = gen_src_code(src1_type, src1_arg, src1_offset, 1 if op_type <= 1 else 3, base, f's1_{i}', 'IsCyclic')

        for l in src0_lines:
            lines.append(f'    {l}')
        for l in src1_lines:
            lines.append(f'    {l}')

        # Generate arithmetic
        if op_type == 0:  # dim1x1
            a_var = src0_vars[0]
            b_var = src1_vars[0]
            if arith_op == 0:
                lines.append(f'    {dest_var} = {a_var} + {b_var};')
            elif arith_op == 1:
                lines.append(f'    {dest_var} = {a_var} - {b_var};')
            elif arith_op == 2:
                lines.append(f'    {dest_var} = {a_var} * {b_var};')
            elif arith_op == 3:
                lines.append(f'    {dest_var} = {b_var} - {a_var};')

        elif op_type == 1:  # dim3x1
            a0, a1, a2 = src0_vars
            b0 = src1_vars[0]
            d0, d1, d2 = f'{dest_var}_0', f'{dest_var}_1', f'{dest_var}_2'
            if arith_op == 0:
                lines.append(f'    {d0} = {a0} + {b0}; {d1} = {a1}; {d2} = {a2};')
            elif arith_op == 1:
                lines.append(f'    {d0} = {a0} - {b0}; {d1} = {a1}; {d2} = {a2};')
            elif arith_op == 2:
                lines.append(f'    {d0} = {a0} * {b0}; {d1} = {a1} * {b0}; {d2} = {a2} * {b0};')
            elif arith_op == 3:
                lines.append(f'    {d0} = {b0} - {a0}; {d1} = -({a1}); {d2} = -({a2});')

        elif op_type == 2:  # dim3x3
            a0, a1, a2 = src0_vars
            b0, b1, b2 = src1_vars
            d0, d1, d2 = f'{dest_var}_0', f'{dest_var}_1', f'{dest_var}_2'
            if arith_op == 0:
                lines.append(f'    {d0} = {a0} + {b0}; {d1} = {a1} + {b1}; {d2} = {a2} + {b2};')
            elif arith_op == 1:
                lines.append(f'    {d0} = {a0} - {b0}; {d1} = {a1} - {b1}; {d2} = {a2} - {b2};')
            elif arith_op == 2:
                # Karatsuba-like cubic extension multiply
                lines.append(f'    {{')
                lines.append(f'        gl64_t A_ = ({a0} + {a1}) * ({b0} + {b1});')
                lines.append(f'        gl64_t B_ = ({a0} + {a2}) * ({b0} + {b2});')
                lines.append(f'        gl64_t C_ = ({a1} + {a2}) * ({b1} + {b2});')
                lines.append(f'        gl64_t D_ = {a0} * {b0};')
                lines.append(f'        gl64_t E_ = {a1} * {b1};')
                lines.append(f'        gl64_t F_ = {a2} * {b2};')
                lines.append(f'        gl64_t G_ = D_ - E_;')
                lines.append(f'        {d0} = (C_ + G_) - F_;')
                lines.append(f'        {d1} = ((((A_ + C_) - E_) - E_) - D_);')
                lines.append(f'        {d2} = B_ - G_;')
                lines.append(f'    }}')
            elif arith_op == 3:
                lines.append(f'    {d0} = {b0} - {a0}; {d1} = {b1} - {a1}; {d2} = {b2} - {a2};')

    # Write result to destination (shared memory for storePolynomial__)
    lines.append('')
    lines.append('    // Write final result to shared mem dest for storePolynomial__')
    if last_dest_type == 'tmp3':
        lines.append(f'    expressions_params[bufferCommitsSize + 1][{last_dest_idx} * blockDim.x * 3 + threadIdx.x] = (Goldilocks::Element)tmp3_{last_dest_idx}_0;')
        lines.append(f'    expressions_params[bufferCommitsSize + 1][{last_dest_idx} * blockDim.x * 3 + blockDim.x + threadIdx.x] = (Goldilocks::Element)tmp3_{last_dest_idx}_1;')
        lines.append(f'    expressions_params[bufferCommitsSize + 1][{last_dest_idx} * blockDim.x * 3 + 2*blockDim.x + threadIdx.x] = (Goldilocks::Element)tmp3_{last_dest_idx}_2;')
    elif last_dest_type == 'tmp1':
        lines.append(f'    expressions_params[bufferCommitsSize][{last_dest_idx} * blockDim.x + threadIdx.x] = (Goldilocks::Element)tmp1_{last_dest_idx};')
    lines.append('}')

    with open(out_path, 'w') as f:
        f.write('\n'.join(lines))
        f.write('\n')

    print(f"Generated evaluator: {nOps} ops, {nTemp1} tmp1 + {nTemp3} tmp3 regs -> {out_path}")


if __name__ == '__main__':
    import glob
    dump_files = glob.glob('/tmp/expr_dump_*.bin')
    if not dump_files:
        print("No dump files found. Run prove first.")
        sys.exit(1)

    for path in dump_files:
        dump = read_dump(path)
        expId = os.path.basename(path).replace('expr_dump_', '').replace('.bin', '')
        out = f'/tmp/generated_eval_{expId}.cuh'
        generate_evaluator(dump, out)
