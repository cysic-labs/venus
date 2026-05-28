#!/usr/bin/env python3
"""
Generate optimized CUDA expression evaluators from bytecode dumps.

Reads binary dumps produced by VENUS_DUMP_EXPRS and generates straight-line
CUDA device functions with register-resident temporaries. The generated code
exactly mirrors the interpreter semantics in expressions_gpu.cu load__().

Usage:
  VENUS_DUMP_EXPRS=1 make prove   # produces /tmp/expr_dump_*.bin
  python3 tools/gen_expression_evaluator.py  # generates .cuh files
"""

import struct
import sys
import os
import glob


def read_dump(path):
    with open(path, 'rb') as f:
        data = f.read()
    off = 0
    # 10-field header: nOps, nArgs, nTemp1, nTemp3, destDim, bufferCommitSize, nStages, nCustoms, nOpenings, expId
    nOps, nArgs, nTemp1, nTemp3, destDim, bufferCommitSize, nStages, nCustoms, nOpenings, expId = struct.unpack_from('<10I', data, off)
    off += 40
    ops = list(struct.unpack_from(f'<{nOps}B', data, off))
    off += nOps
    args_raw = list(struct.unpack_from(f'<{nArgs}H', data, off))
    off += nArgs * 2
    # Read stride values
    strides = {}
    if nOpenings > 0 and off + nOpenings * 8 <= len(data):
        strides_raw = struct.unpack_from(f'<{nOpenings}q', data, off)
        off += nOpenings * 8
        for i, s in enumerate(strides_raw):
            strides[i] = s
    nNumbers, = struct.unpack_from('<I', data, off)
    off += 4
    numbers = list(struct.unpack_from(f'<{nNumbers}Q', data, off))
    return {
        'nOps': nOps, 'nArgs': nArgs, 'nTemp1': nTemp1, 'nTemp3': nTemp3,
        'destDim': destDim, 'bufferCommitSize': bufferCommitSize,
        'expId': expId, 'nStages': nStages, 'nCustoms': nCustoms, 'nOpenings': nOpenings,
        'ops': ops, 'args': args_raw, 'numbers': numbers, 'nNumbers': nNumbers,
        'strides': strides
    }


def gen_load(src_type, src_arg, src_offset, dim, dump, var_prefix):
    """Generate CUDA matching load__() semantics exactly.
    Q expressions always have domainExtended=true.
    pack256 requires stride==0 for the specific operand."""
    lines = []
    base = dump['bufferCommitSize']
    nStages = dump['nStages']
    strides = dump['strides']
    stride_val = strides.get(src_offset, 0)
    use_pack256_for_this = (stride_val == 0)  # per-operand stride check

    # Temp buffers (base+0 = tmp1, base+1 = tmp3)
    if src_type == base:
        return lines, [f'tmp1_{src_arg}', None, None]
    if src_type == base + 1:
        if dim == 1:
            return lines, [f'tmp3_{src_arg}', None, None]
        return lines, [f'tmp3_{src_arg}', f'tmp3_{src_arg + 1}', f'tmp3_{src_arg + 2}']

    # Constants/broadcasts (base+2 and above)
    if src_type >= base + 2:
        if dim == 1:
            v = f'{var_prefix}'
            lines.append(f'gl64_t {v} = *(gl64_t*)&expressions_params[{src_type}][{src_arg}];')
            return lines, [v, None, None]
        v0, v1, v2 = f'{var_prefix}_0', f'{var_prefix}_1', f'{var_prefix}_2'
        lines.append(f'gl64_t {v0} = *(gl64_t*)&expressions_params[{src_type}][{src_arg}];')
        lines.append(f'gl64_t {v1} = *(gl64_t*)&expressions_params[{src_type}][{src_arg}+1];')
        lines.append(f'gl64_t {v2} = *(gl64_t*)&expressions_params[{src_type}][{src_arg}+2];')
        return lines, [v0, v1, v2]

    # zi (type == nStages + 2, hardcoded as type 4 in GPU bytecode)
    if src_type == 4:
        v = f'{var_prefix}'
        lines.append(f'gl64_t {v} = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + ({src_arg} - 1) * domainSize + row + threadIdx.x];')
        return lines, [v, None, None]

    # Custom commits (types nStages+4 to base-1)
    if src_type >= nStages + 4 and src_type < base:
        idx = src_type - (nStages + 4)
        offset_expr = f'dExpsArgs->mapOffsetsCustomExps[{idx}]'
        ncols_expr = f'dArgs->mapSectionsNCustomFixed[{idx}]'
        if dim == 1:
            v = f'{var_prefix}'
            lines.append(f'gl64_t {v} = *(gl64_t*)&dParams->pCustomCommitsFixed[{offset_expr} + getBufferOffset(logicalRow_{src_offset}, {src_arg}, domainSize, {ncols_expr})];')
            return lines, [v, None, None]
        v0, v1, v2 = f'{var_prefix}_0', f'{var_prefix}_1', f'{var_prefix}_2'
        for d in range(3):
            lines.append(f'gl64_t {var_prefix}_{d} = *(gl64_t*)&dParams->pCustomCommitsFixed[{offset_expr} + getBufferOffset(logicalRow_{src_offset}, {src_arg}+{d}, domainSize, {ncols_expr})];')
        return lines, [v0, v1, v2]

    # constPols (type 0)
    if src_type == 0:
        ncols = 'nCols_0'
        # Q is always domainExtended=true
        baseptr = 'dParams->pConstPolsExtendedTreeAddress'
        pack_cond = f'usePack256_{src_offset}' if use_pack256_for_this else 'false'
        if dim == 1:
            v = f'{var_prefix}'
            lines.append(f'gl64_t {v} = *(gl64_t*)&{baseptr}[{pack_cond} ? getBufferOffset_pack256(chunkBase, {src_arg}, domainSize, {ncols}) : getBufferOffset(logicalRow_{src_offset}, {src_arg}, domainSize, {ncols})];')
            return lines, [v, None, None]
        v0, v1, v2 = f'{var_prefix}_0', f'{var_prefix}_1', f'{var_prefix}_2'
        for d in range(3):
            lines.append(f'gl64_t {var_prefix}_{d} = *(gl64_t*)&{baseptr}[{pack_cond} ? getBufferOffset_pack256(chunkBase, {src_arg}+{d}, domainSize, {ncols}) : getBufferOffset(logicalRow_{src_offset}, {src_arg}+{d}, domainSize, {ncols})];')
        return lines, [v0, v1, v2]

    # Trace/aux_trace (types 1-3)
    # For Q expressions, domainExtended=true always, so type 1 goes through aux_trace
    if src_type >= 1 and src_type <= 3:
        offset_expr = f'dExpsArgs->mapOffsetsExps[{src_type}]'
        ncols = f'nCols_{src_type}'
        pack_cond = f'usePack256_{src_offset}' if use_pack256_for_this else 'false'

        if dim == 1:
            v = f'{var_prefix}'
            lines.append(f'gl64_t {v} = *(gl64_t*)&dParams->aux_trace[{offset_expr} + ({pack_cond} ? getBufferOffset_pack256(chunkBase, {src_arg}, domainSize, {ncols}) : getBufferOffset(logicalRow_{src_offset}, {src_arg}, domainSize, {ncols}))];')
            return lines, [v, None, None]

        v0, v1, v2 = f'{var_prefix}_0', f'{var_prefix}_1', f'{var_prefix}_2'
        # Same-tile fast path when col % 4 <= 1
        if isinstance(src_arg, int) and (src_arg & 3) <= 1:
            lines.append(f'uint64_t {var_prefix}_pos = {offset_expr} + ({pack_cond} ? getBufferOffset_pack256(chunkBase, {src_arg}, domainSize, {ncols}) : getBufferOffset(logicalRow_{src_offset}, {src_arg}, domainSize, {ncols}));')
            lines.append(f'gl64_t {v0} = *(gl64_t*)&dParams->aux_trace[{var_prefix}_pos];')
            lines.append(f'gl64_t {v1} = *(gl64_t*)&dParams->aux_trace[{var_prefix}_pos + TILE_HEIGHT];')
            lines.append(f'gl64_t {v2} = *(gl64_t*)&dParams->aux_trace[{var_prefix}_pos + 2*TILE_HEIGHT];')
        else:
            for d in range(3):
                lines.append(f'gl64_t {var_prefix}_{d} = *(gl64_t*)&dParams->aux_trace[{offset_expr} + ({pack_cond} ? getBufferOffset_pack256(chunkBase, {src_arg}+{d}, domainSize, {ncols}) : getBufferOffset(logicalRow_{src_offset}, {src_arg}+{d}, domainSize, {ncols}))];')
        return lines, [v0, v1, v2]

    # Unknown type
    v = f'{var_prefix}'
    lines.append(f'gl64_t {v} = gl64_t(uint64_t(0)); // unknown src type {src_type}')
    return lines, [v, None, None]


def find_chunk_boundaries(dump, target_chunk_size=1500):
    """Find optimal chunk boundaries minimizing live temp count.
    Returns list of (start, end) tuples for each chunk."""
    nOps = dump['nOps']
    args = dump['args']
    ops = dump['ops']
    base = dump['bufferCommitSize']
    TMP1_TYPE = base
    TMP3_TYPE = base + 1

    def src_temp_keys(op_type, src_idx):
        st = args[src_idx]
        sa = args[src_idx + 1]
        is_src0 = (src_idx % 8) == 2
        dim = 1 if (op_type == 0 or (not is_src0 and op_type == 1)) else 3
        if st == TMP1_TYPE:
            return [(st, sa)]
        if st == TMP3_TYPE:
            if dim == 1:
                return [(st, sa)]
            return [(st, sa), (st, sa + 1), (st, sa + 2)]
        return []

    # Compute per-boundary liveness using interval tracking.
    # For each temp slot, track (last_def, last_use) intervals.
    # A temp is live at boundary b if it was defined at d <= b and used at u > b.

    # Forward pass: for each temp, find all def-use intervals
    # Key insight: a definition kills the previous interval and starts a new one
    intervals = {}  # (type, idx) -> (def_op, last_use_op)

    # First pass: track definitions and last uses
    temp_defs = {}   # (type, idx) -> list of def positions
    temp_uses = {}   # (type, idx) -> list of use positions

    for i in range(nOps):
        b = i * 8
        op_type = ops[i]
        dest_type = TMP1_TYPE if op_type == 0 else TMP3_TYPE
        dest_idx = args[b + 1]

        # Record reads
        for src_idx in (b + 2, b + 5):
            for key in src_temp_keys(op_type, src_idx):
                if key not in temp_uses:
                    temp_uses[key] = []
                temp_uses[key].append(i)

        # Record writes
        keys = [(dest_type, dest_idx)]
        if op_type >= 1:
            keys.extend([(dest_type, dest_idx + 1), (dest_type, dest_idx + 2)])
        for key in keys:
            if key not in temp_defs:
                temp_defs[key] = []
            temp_defs[key].append(i)

    # Build def-use intervals: for each definition, find the last use before next def
    all_intervals = []  # list of (start, end) where temp is live from start to end
    for key in set(list(temp_defs.keys()) + list(temp_uses.keys())):
        defs = sorted(temp_defs.get(key, []))
        uses = sorted(temp_uses.get(key, []))
        if not defs or not uses:
            continue
        for di, d in enumerate(defs):
            next_d = defs[di + 1] if di + 1 < len(defs) else nOps
            # Find last use of this definition: max use in [d, next_d)
            last_u = -1
            for u in uses:
                if d <= u < next_d:
                    last_u = u
            if last_u > d:
                # tmp1 counts 1 register, tmp3 counts 3
                weight = 1 if key[0] == TMP1_TYPE else 3
                all_intervals.append((d, last_u, weight))

    # Compute liveness score at each boundary using sweep line
    # (only compute at candidate boundary positions to save time)
    def liveness_at(boundary):
        """Count live registers at boundary point (between ops boundary-1 and boundary)."""
        score = 0
        for start, end, weight in all_intervals:
            if start < boundary <= end:
                score += weight
        return score

    # Find boundaries with minimum liveness
    boundaries = []
    pos = 0
    while pos < nOps:
        end = min(pos + target_chunk_size, nOps)
        if end >= nOps:
            boundaries.append((pos, nOps))
            break
        search_start = max(pos + 1, end - 200)
        search_end = min(nOps, end + 200)
        best = end
        best_live = liveness_at(end)
        for j in range(search_start, search_end):
            live = liveness_at(j)
            if live < best_live:
                best_live = live
                best = j
                if live == 0:
                    break
        boundaries.append((pos, best))
        pos = best

    return boundaries


def collect_live_temps_at_boundary(dump, boundary_op):
    """Determine which tmp indices are live at a chunk boundary.
    A temp is live if it was defined before the boundary and used after it
    WITHOUT being redefined before the use."""
    nOps = dump['nOps']
    args = dump['args']
    ops = dump['ops']
    base = dump['bufferCommitSize']
    TMP1_TYPE = base
    TMP3_TYPE = base + 1

    def src_temp_keys(op_type, src_idx):
        st = args[src_idx]
        sa = args[src_idx + 1]
        is_src0 = (src_idx % 8) == 2
        dim = 1 if (op_type == 0 or (not is_src0 and op_type == 1)) else 3
        if st == TMP1_TYPE:
            return [(st, sa)]
        if st == TMP3_TYPE:
            if dim == 1:
                return [(st, sa)]
            return [(st, sa), (st, sa + 1), (st, sa + 2)]
        return []

    # Find the LAST definition of each temp slot before boundary
    last_def_before = {}  # (type, idx) -> op index
    for i in range(boundary_op):
        b = i * 8
        dest_idx = args[b + 1]
        op_type = ops[i]
        dest_type = TMP1_TYPE if op_type == 0 else TMP3_TYPE
        last_def_before[(dest_type, dest_idx)] = i
        if op_type >= 1:
            last_def_before[(dest_type, dest_idx + 1)] = i
            last_def_before[(dest_type, dest_idx + 2)] = i

    # For each temp with a definition before boundary, check if it's used
    # after boundary before being redefined
    live = set()
    for key, def_op in last_def_before.items():
        for i in range(boundary_op, nOps):
            b = i * 8
            # Check if this op uses the temp
            op_type = ops[i]
            for src_idx in (b + 2, b + 5):
                if key in src_temp_keys(op_type, src_idx):
                    live.add(key)
                    break
            if key in live:
                break
            # Check if this op redefines the temp (kills it)
            dest_idx = args[b + 1]
            op_type = ops[i]
            dest_type = TMP1_TYPE if op_type == 0 else TMP3_TYPE
            kill_keys = [(dest_type, dest_idx)]
            if op_type >= 1:
                kill_keys.extend([(dest_type, dest_idx + 1), (dest_type, dest_idx + 2)])
            if key in kill_keys:
                break  # Redefined before use -> not live

    return live


def generate_evaluator(dump, out_path):
    nOps = dump['nOps']
    nTemp1 = dump['nTemp1']
    nTemp3 = dump['nTemp3']
    base = dump['bufferCommitSize']
    ops = dump['ops']
    args = dump['args']
    strides = dump['strides']

    # Collect unique stride offsets and stage types used
    stride_offsets = set()
    stage_types_used = set()
    for i in range(nOps):
        a = args[i*8:(i+1)*8]
        stride_offsets.add(a[4])
        stride_offsets.add(a[7])
        for st in [a[2], a[5]]:
            if st >= 0 and st <= 3:
                stage_types_used.add(st)

    L = []
    L.append('// Auto-generated expression evaluator - matches load__() semantics exactly')
    L.append('// Q expressions: domainExtended=true always, type 1 goes through aux_trace')
    L.append('')
    # Use fingerprint based on nOps+nTemp1+nTemp3+first 16 args for unique name
    import hashlib
    fp_data = struct.pack('<IIII', nOps, nTemp1, nTemp3, dump['destDim'])
    fp_data += bytes(ops[:min(16, len(ops))])
    fp_data += struct.pack(f'<{min(32, len(args))}H', *args[:min(32, len(args))])
    fp = hashlib.md5(fp_data).hexdigest()[:8]
    func_name = f'eval_expr_{fp}'

    L.append(f'// Fingerprint: {fp}  nOps={nOps} nTemp1={nTemp1} nTemp3={nTemp3}')
    L.append(f'#define GENERATED_EVAL_NOPS_{fp} {nOps}')
    L.append(f'#define GENERATED_EVAL_NTEMP1_{fp} {nTemp1}')
    L.append(f'#define GENERATED_EVAL_NTEMP3_{fp} {nTemp3}')
    L.append('')
    L.append('template<bool IsCyclic>')
    L.append(f'__device__ __forceinline__ void {func_name}(')
    L.append('    const StepsParams* __restrict__ dParams,')
    L.append('    const DeviceArguments* __restrict__ dArgs,')
    L.append('    const ExpsArguments* __restrict__ dExpsArgs,')
    L.append('    Goldilocks::Element **expressions_params,')
    L.append(f'    uint32_t bufferCommitsSize, uint64_t row)')
    L.append('{')
    L.append('    const uint64_t domainSize = dExpsArgs->domainSize;')
    L.append('    const uint64_t r = row + threadIdx.x;')
    L.append('    const uint64_t chunkBase = row;')
    L.append('')

    # Declare logical rows for each stride offset
    for so in sorted(stride_offsets):
        sv = strides.get(so, 0)
        L.append(f'    // stride[{so}] = {sv}')
        L.append(f'    const int64_t stride_{so} = dExpsArgs->nextStridesExps[{so}];')
        L.append(f'    uint64_t logicalRow_{so};')
    L.append('    if constexpr (IsCyclic) {')
    for so in sorted(stride_offsets):
        L.append(f'        logicalRow_{so} = (r + stride_{so}) % domainSize;')
    L.append('    } else {')
    for so in sorted(stride_offsets):
        L.append(f'        logicalRow_{so} = r + stride_{so};')
    L.append('    }')
    L.append('')

    # Per-operand pack256 eligibility (stride==0 AND !IsCyclic AND blockDim==TILE_HEIGHT)
    for so in sorted(stride_offsets):
        sv = strides.get(so, 0)
        if sv == 0:
            L.append(f'    const bool usePack256_{so} = !IsCyclic && blockDim.x == TILE_HEIGHT;')
        else:
            L.append(f'    const bool usePack256_{so} = false; // stride={sv} != 0')

    # Cache nCols for used stage types
    L.append('')
    for st in sorted(stage_types_used):
        L.append(f'    const uint64_t nCols_{st} = dArgs->mapSectionsN[{st}];')

    # Register-resident temporaries
    # tmp1 has nTemp1 slots; tmp3 has nTemp3*FIELD_EXTENSION slots
    # dest_idx is a RAW buffer index, not a tuple index
    nTmp1Slots = nTemp1
    nTmp3Slots = nTemp3 * 3  # FIELD_EXTENSION = 3
    L.append('')
    L.append(f'    // Register-resident temporaries: {nTmp1Slots} tmp1 + {nTmp3Slots} tmp3 slots')
    for t in range(nTmp1Slots):
        L.append(f'    gl64_t tmp1_{t} = gl64_t(uint64_t(0));')
    for t in range(nTmp3Slots):
        L.append(f'    gl64_t tmp3_{t} = gl64_t(uint64_t(0));')

    L.append('')
    last_dest_type = None
    last_dest_idx = None

    for i in range(nOps):
        a = args[i*8:(i+1)*8]
        arith_op = a[0]
        dest_idx = a[1]
        src0_type, src0_arg, src0_offset = a[2], a[3], a[4]
        src1_type, src1_arg, src1_offset = a[5], a[6], a[7]
        op_type = ops[i]
        dim0 = 1 if op_type == 0 else 3
        dim1 = 1 if op_type <= 1 else 3
        arith_names = {0: 'add', 1: 'sub', 2: 'mul', 3: 'sub_swap'}

        if op_type == 0:
            dest_var = f'tmp1_{dest_idx}'
            last_dest_type = 'tmp1'
            last_dest_idx = dest_idx
        else:
            # dim3 ops use 3 consecutive raw slots: dest_idx, dest_idx+1, dest_idx+2
            dest_var = f'tmp3_{dest_idx}'
            last_dest_type = 'tmp3'
            last_dest_idx = dest_idx

        L.append(f'    // Op {i}: {["dim1x1","dim3x1","dim3x3"][op_type]} {arith_names[arith_op]}')

        src0_lines, src0_vars = gen_load(src0_type, src0_arg, src0_offset, dim0, dump, f's0_{i}')
        src1_lines, src1_vars = gen_load(src1_type, src1_arg, src1_offset, dim1, dump, f's1_{i}')
        for l in src0_lines:
            L.append(f'    {l}')
        for l in src1_lines:
            L.append(f'    {l}')

        if op_type == 0:
            av, bv = src0_vars[0], src1_vars[0]
            if arith_op == 0:   L.append(f'    {dest_var} = {av} + {bv};')
            elif arith_op == 1: L.append(f'    {dest_var} = {av} - {bv};')
            elif arith_op == 2: L.append(f'    {dest_var} = {av} * {bv};')
            elif arith_op == 3: L.append(f'    {dest_var} = {bv} - {av};')
        elif op_type == 1:
            a0, a1, a2 = src0_vars
            b0 = src1_vars[0]
            d0 = f'tmp3_{dest_idx}'
            d1 = f'tmp3_{dest_idx + 1}'
            d2 = f'tmp3_{dest_idx + 2}'
            if arith_op == 0:   L.append(f'    {d0} = {a0} + {b0}; {d1} = {a1}; {d2} = {a2};')
            elif arith_op == 1: L.append(f'    {d0} = {a0} - {b0}; {d1} = {a1}; {d2} = {a2};')
            elif arith_op == 2: L.append(f'    {d0} = {a0} * {b0}; {d1} = {a1} * {b0}; {d2} = {a2} * {b0};')
            elif arith_op == 3: L.append(f'    {d0} = {b0} - {a0}; {d1} = -({a1}); {d2} = -({a2});')
        elif op_type == 2:
            a0, a1, a2 = src0_vars
            b0, b1, b2 = src1_vars
            d0 = f'tmp3_{dest_idx}'
            d1 = f'tmp3_{dest_idx + 1}'
            d2 = f'tmp3_{dest_idx + 2}'
            if arith_op == 0:   L.append(f'    {d0} = {a0} + {b0}; {d1} = {a1} + {b1}; {d2} = {a2} + {b2};')
            elif arith_op == 1: L.append(f'    {d0} = {a0} - {b0}; {d1} = {a1} - {b1}; {d2} = {a2} - {b2};')
            elif arith_op == 2:
                # Karatsuba-like cubic extension multiply
                # ALL intermediates computed BEFORE any dest writes (src/dest may alias)
                L.append(f'    gl64_t kA{i} = ({a0} + {a1}) * ({b0} + {b1});')
                L.append(f'    gl64_t kB{i} = ({a0} + {a2}) * ({b0} + {b2});')
                L.append(f'    gl64_t kC{i} = ({a1} + {a2}) * ({b1} + {b2});')
                L.append(f'    gl64_t kD{i} = {a0} * {b0};')
                L.append(f'    gl64_t kE{i} = {a1} * {b1};')
                L.append(f'    gl64_t kF{i} = {a2} * {b2};')
                L.append(f'    gl64_t kG{i} = kD{i} - kE{i};')
                L.append(f'    {d0} = (kC{i} + kG{i}) - kF{i};')
                L.append(f'    {d1} = ((((kA{i} + kC{i}) - kE{i}) - kE{i}) - kD{i});')
                L.append(f'    {d2} = kB{i} - kG{i};')
            elif arith_op == 3:
                L.append(f'    {d0} = {b0} - {a0}; {d1} = {b1} - {a1}; {d2} = {b2} - {a2};')

    # Write result to shared memory and call storePolynomial__ directly
    L.append('')
    L.append('    // Write final result to shared memory and store to output')
    if last_dest_type == 'tmp3':
        L.append(f'    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][{last_dest_idx} * blockDim.x + threadIdx.x] = tmp3_{last_dest_idx};')
        L.append(f'    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][{last_dest_idx + 1} * blockDim.x + threadIdx.x] = tmp3_{last_dest_idx + 1};')
        L.append(f'    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][{last_dest_idx + 2} * blockDim.x + threadIdx.x] = tmp3_{last_dest_idx + 2};')
        L.append(f'    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][{last_dest_idx} * blockDim.x], row);')
    elif last_dest_type == 'tmp1':
        L.append(f'    *(gl64_t*)&expressions_params[bufferCommitsSize][{last_dest_idx} * blockDim.x + threadIdx.x] = tmp1_{last_dest_idx};')
        L.append(f'    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize][{last_dest_idx} * blockDim.x], row);')
    L.append('}')

    with open(out_path, 'w') as f:
        f.write('\n'.join(L) + '\n')

    print(f"Generated: {nOps} ops, {nTemp1} tmp1 + {nTemp3} tmp3 regs -> {out_path}")
    return True


def generate_chunked_evaluator(dump, out_path):
    """Generate a chunked evaluator for large expressions (>2100 ops).
    Splits into smaller chunk functions that are called sequentially."""
    import hashlib

    nOps = dump['nOps']
    nTemp1 = dump['nTemp1']
    nTemp3 = dump['nTemp3']
    base = dump['bufferCommitSize']
    ops = dump['ops']
    args = dump['args']
    strides = dump['strides']

    # Keep chunks small enough for nvcc/cicc to compile large generated
    # expressions predictably. Device-call overhead is paid once per row tile,
    # while very large straight-line chunks can spend minutes in the compiler.
    target_size = min(int(os.environ.get('VENUS_GEN_EXPR_CHUNK_SIZE', '1800')), nOps)
    boundaries = find_chunk_boundaries(dump, target_chunk_size=target_size)
    nChunks = len(boundaries)

    # Collect global info
    stride_offsets = set()
    stage_types_used = set()
    for i in range(nOps):
        a = args[i*8:(i+1)*8]
        stride_offsets.add(a[4])
        stride_offsets.add(a[7])
        for st in [a[2], a[5]]:
            if st >= 0 and st <= 3:
                stage_types_used.add(st)

    # Compute fingerprint
    fp_data = struct.pack('<IIII', nOps, nTemp1, nTemp3, dump['destDim'])
    fp_data += bytes(ops[:min(16, len(ops))])
    fp_data += struct.pack(f'<{min(32, len(args))}H', *args[:min(32, len(args))])
    fp = hashlib.md5(fp_data).hexdigest()[:8]

    TMP1_TYPE = base
    TMP3_TYPE = base + 1

    # Compute live temps at each chunk boundary for correct state threading
    boundary_live_sets = {}  # boundary_op -> set of (type, idx)
    for _, chunk_end in boundaries:
        if chunk_end < nOps:
            live = collect_live_temps_at_boundary(dump, chunk_end)
            boundary_live_sets[chunk_end] = live
            print(f"  Boundary at op {chunk_end}: {len(live)} live temps "
                  f"({sum(1 for t,_ in live if t==TMP1_TYPE)} tmp1, "
                  f"{sum(1 for t,_ in live if t==TMP3_TYPE)} tmp3)")

    # Collect ALL tmp slots that are ever live at ANY boundary
    all_live_tmp1 = set()
    all_live_tmp3 = set()
    for live_set in boundary_live_sets.values():
        for typ, idx in live_set:
            if typ == TMP1_TYPE:
                all_live_tmp1.add(idx)
            elif typ == TMP3_TYPE:
                all_live_tmp3.add(idx)

    # The final result is consumed by the wrapper after the last chunk, so it
    # must be threaded as state even when there is only one chunk and no
    # cross-boundary liveness.
    last_op_type = ops[nOps - 1]
    last_dest_idx = args[(nOps - 1) * 8 + 1]
    if last_op_type == 0:
        all_live_tmp1.add(last_dest_idx)
    else:
        all_live_tmp3.update((last_dest_idx, last_dest_idx + 1, last_dest_idx + 2))

    all_live_tmp1 = sorted(all_live_tmp1)
    all_live_tmp3 = sorted(all_live_tmp3)
    print(f"  Total cross-boundary state: {len(all_live_tmp1)} tmp1 + {len(all_live_tmp3)} tmp3 slots")

    L = []
    L.append(f'// Auto-generated CHUNKED expression evaluator for {nOps}-op expression')
    L.append(f'// Split into {nChunks} chunks for optimal register allocation')
    L.append(f'// Fingerprint: {fp}  nOps={nOps} nTemp1={nTemp1} nTemp3={nTemp3}')
    L.append(f'#define GENERATED_EVAL_NOPS_{fp} {nOps}')
    L.append(f'#define GENERATED_EVAL_NTEMP1_{fp} {nTemp1}')
    L.append(f'#define GENERATED_EVAL_NTEMP3_{fp} {nTemp3}')
    L.append('')

    # Generate common setup as a macro or inline section
    # Each chunk function needs logical rows, pack256 flags, nCols constants
    # To avoid code duplication, generate a struct with precomputed values
    L.append('struct ChunkedEvalContext {')
    for so in sorted(stride_offsets):
        L.append(f'    uint64_t logicalRow_{so};')
    for so in sorted(stride_offsets):
        L.append(f'    bool usePack256_{so};')
    for st in sorted(stage_types_used):
        L.append(f'    uint64_t nCols_{st};')
    L.append('    uint64_t domainSize;')
    L.append('    uint64_t chunkBase;')
    L.append('    uint64_t row;')
    L.append('};')
    L.append('')

    # Generate each chunk function
    for chunk_idx, (chunk_start, chunk_end) in enumerate(boundaries):
        chunk_ops_count = chunk_end - chunk_start

        # Find tmp1 indices used in this chunk
        chunk_tmp1_used = set()
        chunk_tmp3_used = set()
        for i in range(chunk_start, chunk_end):
            b = i * 8
            if ops[i] == 0:
                chunk_tmp1_used.add(args[b + 1])
            else:
                chunk_tmp3_used.update((args[b + 1], args[b + 1] + 1, args[b + 1] + 2))
            if args[b + 2] == base:
                chunk_tmp1_used.add(args[b + 3])
            if args[b + 5] == base:
                chunk_tmp1_used.add(args[b + 6])
            if args[b + 2] == base + 1:
                chunk_tmp3_used.update((args[b + 3], args[b + 3] + 1, args[b + 3] + 2))
            if args[b + 5] == base + 1:
                chunk_tmp3_used.update((args[b + 6], args[b + 6] + 1, args[b + 6] + 2))

        L.append(f'// Chunk {chunk_idx}: ops [{chunk_start}, {chunk_end}) = {chunk_ops_count} ops')
        L.append(f'__device__ __noinline__ static void chunk_{fp}_{chunk_idx}(')
        L.append('    const StepsParams* __restrict__ dParams,')
        L.append('    const DeviceArguments* __restrict__ dArgs,')
        L.append('    const ExpsArguments* __restrict__ dExpsArgs,')
        L.append('    Goldilocks::Element **expressions_params,')
        L.append('    uint32_t bufferCommitsSize,')
        L.append('    const ChunkedEvalContext& ctx,')
        # Pass ALL cross-boundary live state (tmp1 + tmp3)
        for t in all_live_tmp1:
            L.append(f'    gl64_t& tmp1_{t},')
        for t in all_live_tmp3:
            L.append(f'    gl64_t& tmp3_{t},')
        # Remove trailing comma from last param
        if L[-1].endswith(','):
            L[-1] = L[-1].rstrip(',')
        L.append(')')
        L.append('{')

        # Unpack context into local refs for code compatibility
        L.append('    const uint64_t domainSize = ctx.domainSize;')
        L.append('    const uint64_t chunkBase = ctx.chunkBase;')
        L.append('    const uint64_t row = ctx.row;')
        for so in sorted(stride_offsets):
            L.append(f'    const uint64_t logicalRow_{so} = ctx.logicalRow_{so};')
            L.append(f'    const bool usePack256_{so} = ctx.usePack256_{so};')
        for st in sorted(stage_types_used):
            L.append(f'    const uint64_t nCols_{st} = ctx.nCols_{st};')

        # Declare LOCAL tmp1 variables (those not passed as cross-boundary state)
        local_tmp1 = sorted(chunk_tmp1_used - set(all_live_tmp1))
        for t in local_tmp1:
            L.append(f'    gl64_t tmp1_{t} = gl64_t(uint64_t(0));')
        local_tmp3 = sorted(chunk_tmp3_used - set(all_live_tmp3))
        for t in local_tmp3:
            L.append(f'    gl64_t tmp3_{t} = gl64_t(uint64_t(0));')
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
                L.append(f'    {l}')
            for l in src1_lines:
                L.append(f'    {l}')

            if op_type == 0:
                av, bv = src0_vars[0], src1_vars[0]
                if arith_op == 0:   L.append(f'    {dest_var} = {av} + {bv};')
                elif arith_op == 1: L.append(f'    {dest_var} = {av} - {bv};')
                elif arith_op == 2: L.append(f'    {dest_var} = {av} * {bv};')
                elif arith_op == 3: L.append(f'    {dest_var} = {bv} - {av};')
            elif op_type == 1:
                a0, a1, a2 = src0_vars
                b0 = src1_vars[0]
                d0, d1, d2 = f'tmp3_{dest_idx}', f'tmp3_{dest_idx+1}', f'tmp3_{dest_idx+2}'
                if arith_op == 0:   L.append(f'    {d0} = {a0} + {b0}; {d1} = {a1}; {d2} = {a2};')
                elif arith_op == 1: L.append(f'    {d0} = {a0} - {b0}; {d1} = {a1}; {d2} = {a2};')
                elif arith_op == 2: L.append(f'    {d0} = {a0} * {b0}; {d1} = {a1} * {b0}; {d2} = {a2} * {b0};')
                elif arith_op == 3: L.append(f'    {d0} = {b0} - {a0}; {d1} = -({a1}); {d2} = -({a2});')
            elif op_type == 2:
                a0, a1, a2 = src0_vars
                b0, b1, b2 = src1_vars
                d0, d1, d2 = f'tmp3_{dest_idx}', f'tmp3_{dest_idx+1}', f'tmp3_{dest_idx+2}'
                if arith_op == 0:   L.append(f'    {d0} = {a0} + {b0}; {d1} = {a1} + {b1}; {d2} = {a2} + {b2};')
                elif arith_op == 1: L.append(f'    {d0} = {a0} - {b0}; {d1} = {a1} - {b1}; {d2} = {a2} - {b2};')
                elif arith_op == 2:
                    L.append(f'    gl64_t kA{i} = ({a0} + {a1}) * ({b0} + {b1});')
                    L.append(f'    gl64_t kB{i} = ({a0} + {a2}) * ({b0} + {b2});')
                    L.append(f'    gl64_t kC{i} = ({a1} + {a2}) * ({b1} + {b2});')
                    L.append(f'    gl64_t kD{i} = {a0} * {b0};')
                    L.append(f'    gl64_t kE{i} = {a1} * {b1};')
                    L.append(f'    gl64_t kF{i} = {a2} * {b2};')
                    L.append(f'    gl64_t kG{i} = kD{i} - kE{i};')
                    L.append(f'    {d0} = (kC{i} + kG{i}) - kF{i};')
                    L.append(f'    {d1} = ((((kA{i} + kC{i}) - kE{i}) - kE{i}) - kD{i});')
                    L.append(f'    {d2} = kB{i} - kG{i};')
                elif arith_op == 3:
                    L.append(f'    {d0} = {b0} - {a0}; {d1} = {b1} - {a1}; {d2} = {b2} - {a2};')

        L.append('}')
        L.append('')

    # Generate the main wrapper function (same interface as regular evaluators)
    func_name = f'eval_expr_{fp}'
    L.append('template<bool IsCyclic>')
    L.append(f'__device__ __forceinline__ void {func_name}(')
    L.append('    const StepsParams* __restrict__ dParams,')
    L.append('    const DeviceArguments* __restrict__ dArgs,')
    L.append('    const ExpsArguments* __restrict__ dExpsArgs,')
    L.append('    Goldilocks::Element **expressions_params,')
    L.append(f'    uint32_t bufferCommitsSize, uint64_t row)')
    L.append('{')
    L.append('    const uint64_t domainSize = dExpsArgs->domainSize;')
    L.append('    const uint64_t r = row + threadIdx.x;')
    L.append('')
    L.append('    ChunkedEvalContext ctx;')
    L.append('    ctx.domainSize = domainSize;')
    L.append('    ctx.chunkBase = row;')
    L.append('    ctx.row = row;')

    for so in sorted(stride_offsets):
        sv = strides.get(so, 0)
        L.append(f'    const int64_t stride_{so} = dExpsArgs->nextStridesExps[{so}];')
    L.append('    if constexpr (IsCyclic) {')
    for so in sorted(stride_offsets):
        L.append(f'        ctx.logicalRow_{so} = (r + stride_{so}) % domainSize;')
    L.append('    } else {')
    for so in sorted(stride_offsets):
        L.append(f'        ctx.logicalRow_{so} = r + stride_{so};')
    L.append('    }')

    for so in sorted(stride_offsets):
        sv = strides.get(so, 0)
        if sv == 0:
            L.append(f'    ctx.usePack256_{so} = !IsCyclic && blockDim.x == TILE_HEIGHT;')
        else:
            L.append(f'    ctx.usePack256_{so} = false;')

    for st in sorted(stage_types_used):
        L.append(f'    ctx.nCols_{st} = dArgs->mapSectionsN[{st}];')

    # Initialize ALL cross-boundary state (tmp1 + tmp3)
    for t in all_live_tmp1:
        L.append(f'    gl64_t tmp1_{t} = gl64_t(uint64_t(0));')
    for t in all_live_tmp3:
        L.append(f'    gl64_t tmp3_{t} = gl64_t(uint64_t(0));')

    # Call each chunk, passing all cross-boundary state
    L.append('')
    state_args = ', '.join([f'tmp1_{t}' for t in all_live_tmp1] +
                           [f'tmp3_{t}' for t in all_live_tmp3])
    for chunk_idx in range(nChunks):
        if state_args:
            L.append(f'    chunk_{fp}_{chunk_idx}(dParams, dArgs, dExpsArgs, expressions_params, bufferCommitsSize, ctx, {state_args});')
        else:
            L.append(f'    chunk_{fp}_{chunk_idx}(dParams, dArgs, dExpsArgs, expressions_params, bufferCommitsSize, ctx);')

    # Determine the last dest from the final op
    last_op_idx = nOps - 1
    last_op_type = ops[last_op_idx]
    last_dest_idx = args[last_op_idx * 8 + 1]

    # Write result to shared memory and store to output
    L.append('')
    L.append('    // Write final result and store')
    if last_op_type >= 1:  # dim3 result
        L.append(f'    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][{last_dest_idx} * blockDim.x + threadIdx.x] = tmp3_{last_dest_idx};')
        L.append(f'    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][{last_dest_idx + 1} * blockDim.x + threadIdx.x] = tmp3_{last_dest_idx + 1};')
        L.append(f'    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][{last_dest_idx + 2} * blockDim.x + threadIdx.x] = tmp3_{last_dest_idx + 2};')
        L.append(f'    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][{last_dest_idx} * blockDim.x], row);')
    else:
        L.append(f'    // ERROR: last op is dim1 which is unexpected for Q expression')

    L.append('}')

    with open(out_path, 'w') as f:
        f.write('\n'.join(L) + '\n')

    print(f"Generated CHUNKED: {nOps} ops, {nChunks} chunks, {nTemp1} tmp1 + {nTemp3} tmp3 -> {out_path}")
    return True


def generate_standalone_kernel(expId, func_name, out_path):
    """Generate a standalone __global__ kernel .cu file for an expression."""
    lines = []
    lines.append(f'// Standalone generated kernel for expression {expId}')
    lines.append('// Compiled in its own CU for optimal register allocation')
    lines.append('#include "expressions_gpu.cuh"')
    lines.append('#include "cuda_utils.cuh"')
    lines.append('#include "cuda_utils.hpp"')
    lines.append('#include "gl64_tooling.cuh"')
    lines.append('#include "goldilocks_cubic_extension.cuh"')
    lines.append('')
    lines.append('extern __shared__ Goldilocks::Element scratchpad[];')
    lines.append('')
    lines.append('// Local storePolynomial__')
    lines.append('__device__ __noinline__ static void storePolynomial__(ExpsArguments *d_expsArgs, Goldilocks::Element *destVals, uint64_t row)')
    lines.append('{')
    lines.append('    #pragma unroll')
    lines.append('    for (uint32_t i = 0; i < d_expsArgs->dest_dim; i++) {')
    lines.append('        if (!d_expsArgs->dest_expr) {')
    lines.append('            uint64_t col = d_expsArgs->dest_stagePos + i;')
    lines.append('            uint64_t nRows = d_expsArgs->dest_domainSize;')
    lines.append('            uint64_t nCols = d_expsArgs->dest_stageCols;')
    lines.append('            uint64_t idx = getBufferOffset(row + threadIdx.x, col, nRows, nCols);')
    lines.append('            d_expsArgs->dest_gpu[idx] = destVals[i * blockDim.x + threadIdx.x];')
    lines.append('        } else {')
    lines.append('            d_expsArgs->dest_gpu[(row + threadIdx.x) * d_expsArgs->dest_dim + i] = destVals[i * blockDim.x + threadIdx.x];')
    lines.append('        }')
    lines.append('    }')
    lines.append('}')
    lines.append('')
    lines.append(f'#include "gen_eval_{expId}.cuh"')
    lines.append('')
    lines.append(f'__global__ void computeExpression_gen_{expId}_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams)')
    lines.append('{')
    lines.append('    int chunk_idx = blockIdx.x;')
    lines.append('    uint64_t nchunks = d_expsArgs->domainSize / blockDim.x;')
    lines.append('    uint32_t bufferCommitsSize = d_deviceArgs->bufferCommitSize;')
    lines.append('    Goldilocks::Element **expressions_params = (Goldilocks::Element **)scratchpad;')
    lines.append('    Goldilocks::Element *smem_after_ptrs = scratchpad + 32;')
    lines.append('    uint64_t tmpTotal = d_expsArgs->maxTemp1Size + d_expsArgs->maxTemp3Size;')
    lines.append('    bool useTmpSmem = tmpTotal > 0 && tmpTotal <= 5120;')
    lines.append('    if (threadIdx.x == 0) {')
    lines.append('        if (useTmpSmem) {')
    lines.append('            expressions_params[bufferCommitsSize + 0] = smem_after_ptrs;')
    lines.append('            expressions_params[bufferCommitsSize + 1] = smem_after_ptrs + d_expsArgs->maxTemp1Size;')
    lines.append('        } else {')
    lines.append('            expressions_params[bufferCommitsSize + 0] = (&d_params->aux_trace[d_expsArgs->offsetTmp1 + blockIdx.x * d_expsArgs->maxTemp1Size]);')
    lines.append('            expressions_params[bufferCommitsSize + 1] = (&d_params->aux_trace[d_expsArgs->offsetTmp3 + blockIdx.x * d_expsArgs->maxTemp3Size]);')
    lines.append('        }')
    lines.append('        expressions_params[bufferCommitsSize + 2] = d_params->publicInputs;')
    lines.append('        expressions_params[bufferCommitsSize + 3] = d_deviceArgs->numbers;')
    lines.append('        expressions_params[bufferCommitsSize + 4] = d_params->airValues;')
    lines.append('        expressions_params[bufferCommitsSize + 5] = d_params->proofValues;')
    lines.append('        expressions_params[bufferCommitsSize + 6] = d_params->airgroupValues;')
    lines.append('        expressions_params[bufferCommitsSize + 7] = d_params->challenges;')
    lines.append('        expressions_params[bufferCommitsSize + 8] = d_params->evals;')
    lines.append('    }')
    lines.append('    __syncthreads();')
    lines.append('    uint64_t k_min_chunk = d_expsArgs->k_min / blockDim.x;')
    lines.append('    uint64_t k_max_chunk = d_expsArgs->k_max / blockDim.x;')
    lines.append('    while (chunk_idx < nchunks) {')
    lines.append('        uint64_t i = chunk_idx * blockDim.x;')
    lines.append('        if (chunk_idx < k_min_chunk || chunk_idx >= k_max_chunk) {')
    lines.append(f'            {func_name}<true>(d_params, d_deviceArgs, d_expsArgs, expressions_params, bufferCommitsSize, i);')
    lines.append('        } else {')
    lines.append(f'            {func_name}<false>(d_params, d_deviceArgs, d_expsArgs, expressions_params, bufferCommitsSize, i);')
    lines.append('        }')
    lines.append('        chunk_idx += gridDim.x;')
    lines.append('    }')
    lines.append('}')

    with open(out_path, 'w') as f:
        f.write('\n'.join(lines) + '\n')


def generate_all(dump_dir, out_dir):
    """Generate evaluators for all dumps and a dispatch header."""
    import hashlib
    dump_files = sorted(glob.glob(os.path.join(dump_dir, 'expr_dump_*.bin')))
    if not dump_files:
        print(f"No dump files in {dump_dir}. Run: VENUS_DUMP_EXPRS=1 make prove")
        return False

    os.makedirs(out_dir, exist_ok=True)
    entries = []  # (fingerprint, nOps, nTemp1, nTemp3, destDim, filename)

    for path in dump_files:
        dump = read_dump(path)
        # Large expressions use chunked generation
        if dump['nOps'] > 2100:
            expId = os.path.basename(path).replace('expr_dump_', '').replace('.bin', '')
            fname = f'gen_eval_{expId}.cuh'
            gen_out_path = os.path.join(out_dir, fname)
            generate_chunked_evaluator(dump, gen_out_path)
            nOps_d, nTemp1_d, nTemp3_d = dump['nOps'], dump['nTemp1'], dump['nTemp3']
            ops_d, args_d = dump['ops'], dump['args']
            fp_data = struct.pack('<IIII', nOps_d, nTemp1_d, nTemp3_d, dump['destDim'])
            fp_data += bytes(ops_d[:min(16, len(ops_d))])
            fp_data += struct.pack(f'<{min(32, len(args_d))}H', *args_d[:min(32, len(args_d))])
            fp = hashlib.md5(fp_data).hexdigest()[:8]
            entries.append((fp, nOps_d, nTemp1_d, nTemp3_d, dump['destDim'], fname))
            continue
        if dump['nTemp1'] > 30:
            print(f"Skipped {path}: nOps={dump['nOps']} nTemp1={dump['nTemp1']} exceeds limits")
            continue
        expId = os.path.basename(path).replace('expr_dump_', '').replace('.bin', '')
        fname = f'gen_eval_{expId}.cuh'
        out_path = os.path.join(out_dir, fname)
        generate_evaluator(dump, out_path)

        # Compute same fingerprint as the generator
        nOps, nTemp1, nTemp3 = dump['nOps'], dump['nTemp1'], dump['nTemp3']
        ops, args = dump['ops'], dump['args']
        fp_data = struct.pack('<IIII', nOps, nTemp1, nTemp3, dump['destDim'])
        fp_data += bytes(ops[:min(16, len(ops))])
        fp_data += struct.pack(f'<{min(32, len(args))}H', *args[:min(32, len(args))])
        fp = hashlib.md5(fp_data).hexdigest()[:8]
        entries.append((fp, nOps, nTemp1, nTemp3, dump['destDim'], fname))

    # Generate dispatch header
    dispatch_path = os.path.join(out_dir, 'generated_dispatch.cuh')
    with open(dispatch_path, 'w') as f:
        f.write('// Auto-generated dispatch header for expression evaluators\n')
        f.write('// Include all generated evaluator files\n\n')
        for _, _, _, _, _, fname in entries:
            f.write(f'#include "{fname}"\n')
        f.write('\n// Dispatch function: tries generated evaluator, returns false if no match\n')
        f.write('template<bool IsCyclic>\n')
        f.write('__device__ __forceinline__ bool dispatch_generated_eval(\n')
        f.write('    const StepsParams* __restrict__ dParams,\n')
        f.write('    const DeviceArguments* __restrict__ dArgs,\n')
        f.write('    const ExpsArguments* __restrict__ dExpsArgs,\n')
        f.write('    Goldilocks::Element **expressions_params,\n')
        f.write('    uint32_t bufferCommitsSize, uint64_t row,\n')
        f.write('    uint32_t nOps, uint32_t nTemp1, uint32_t nTemp3)\n')
        f.write('{\n')
        for fp, nOps, nTemp1, nTemp3, _, _ in entries:
            f.write(f'    if (nOps == {nOps} && nTemp1 == {nTemp1} && nTemp3 == {nTemp3}) {{\n')
            f.write(f'        eval_expr_{fp}<IsCyclic>(dParams, dArgs, dExpsArgs, expressions_params, bufferCommitsSize, row);\n')
            f.write(f'        return true;\n')
            f.write(f'    }}\n')
        f.write('    return false;\n')
        f.write('}\n')

    # Generate standalone kernel .cu files
    for fp, nOps, nTemp1, nTemp3, destDim, fname in entries:
        expId_str = fname.replace('gen_eval_', '').replace('.cuh', '')
        kernel_path = os.path.join(out_dir, f'gen_kernel_{expId_str}.cu')
        generate_standalone_kernel(expId_str, f'eval_expr_{fp}', kernel_path)
        print(f"  Standalone kernel: gen_kernel_{expId_str}.cu")

    # Generate host-side dispatch header (declarations only)
    host_dispatch_path = os.path.join(out_dir, 'generated_kernels.cuh')
    with open(host_dispatch_path, 'w') as f:
        f.write('// Auto-generated kernel declarations for host-side dispatch\n')
        f.write('// Each kernel is compiled in its own .cu file for optimal register allocation\n\n')
        for fp, nOps, nTemp1, nTemp3, destDim, fname in entries:
            expId_str = fname.replace('gen_eval_', '').replace('.cuh', '')
            f.write(f'// expId={expId_str} nOps={nOps} nTemp1={nTemp1} nTemp3={nTemp3}\n')
            f.write(f'__global__ void computeExpression_gen_{expId_str}_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);\n\n')
        # Dispatch function for host code
        f.write('// Host-side dispatch by expId\n')
        f.write('inline bool dispatchGeneratedKernel(uint64_t expId, dim3 nBlocks, dim3 nThreads, size_t sharedMem, cudaStream_t stream,\n')
        f.write('    StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams) {\n')
        f.write('    switch (expId) {\n')
        for fp, nOps, nTemp1, nTemp3, destDim, fname in entries:
            expId_str = fname.replace('gen_eval_', '').replace('.cuh', '')
            f.write(f'    case {expId_str}: computeExpression_gen_{expId_str}_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;\n')
        f.write('    default: return false;\n')
        f.write('    }\n')
        f.write('}\n')

    print(f"Generated {len(entries)} evaluators + {len(entries)} standalone kernels + host dispatch -> {out_dir}")
    return True


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--dump-dir', default='/tmp', help='Directory with expr_dump_*.bin files')
    parser.add_argument('--out-dir', default=None, help='Output directory for .cuh files')
    args = parser.parse_args()

    out_dir = args.out_dir or '/tmp/generated_evals'
    generate_all(args.dump_dir, out_dir)
