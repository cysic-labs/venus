#!/usr/bin/env python3
"""
Dependency-aware round-slice extractor for the Keccak-f Q expression.

Instead of fixed-width windows, this uses def-use chains to find natural
"segment boundaries" where the set of live temporaries drops to a minimum.
Then it checks whether the resulting segments are structurally isomorphic
(same op sequence with different column offsets) - which would enable a
parameterized round evaluator.
"""
import struct
import sys
from collections import defaultdict

def read_dump(path):
    with open(path, 'rb') as f:
        data = f.read()
    off = 0
    nOps, nArgs, nTemp1, nTemp3, destDim, bufferCommitSize, nStages, nCustoms, nOpenings, expId = struct.unpack_from('<10I', data, off)
    off += 40
    ops = list(struct.unpack_from(f'<{nOps}B', data, off))
    off += nOps
    args_raw = list(struct.unpack_from(f'<{nArgs}H', data, off))
    off += nArgs * 2
    strides = {}
    if nOpenings > 0:
        strides_raw = struct.unpack_from(f'<{nOpenings}q', data, off)
        off += nOpenings * 8
        for i, s in enumerate(strides_raw): strides[i] = s
    nNumbers = struct.unpack_from('<I', data, off)[0]
    off += 4
    numbers = list(struct.unpack_from(f'<{nNumbers}Q', data, off))
    return {'nOps': nOps, 'nArgs': nArgs, 'nTemp1': nTemp1, 'nTemp3': nTemp3,
            'destDim': destDim, 'bufferCommitSize': bufferCommitSize,
            'expId': expId, 'nStages': nStages, 'nCustoms': nCustoms,
            'nOpenings': nOpenings, 'ops': ops, 'args': args_raw, 'strides': strides,
            'nNumbers': nNumbers, 'numbers': numbers}

dump = read_dump(sys.argv[1] if len(sys.argv) > 1 else "/tmp/expr_dump_80875.bin")
nOps = dump['nOps']
ops = dump['ops']
args = dump['args']
base = dump['bufferCommitSize']
TMP1 = base
TMP3 = base + 1

print(f"Expression {dump['expId']}: {nOps} ops, base={base}")

# Build def-use intervals for all temporaries
# An interval is (def_op, last_use_op, type, idx)
temp_defs = defaultdict(list)   # (type, idx) -> [def_positions]
temp_uses = defaultdict(list)   # (type, idx) -> [use_positions]

for i in range(nOps):
    b = i * 8
    op_type = ops[i]
    dest_type = TMP1 if op_type == 0 else TMP3
    dest_idx = args[b + 1]

    # Record reads first (before the write kills previous def)
    for s in range(2):
        st = args[b + 2 + s * 3]
        sa = args[b + 3 + s * 3]
        if st == TMP1 or st == TMP3:
            temp_uses[(st, sa)].append(i)

    # Record writes
    temp_defs[(dest_type, dest_idx)].append(i)
    if op_type >= 1:
        temp_defs[(dest_type, dest_idx + 1)].append(i)
        temp_defs[(dest_type, dest_idx + 2)].append(i)

# Build intervals: for each definition, find the last use before next def
intervals = []  # (start, end, type, idx)
for key in set(list(temp_defs.keys()) + list(temp_uses.keys())):
    defs = sorted(temp_defs.get(key, []))
    uses = sorted(temp_uses.get(key, []))
    if not defs or not uses:
        continue
    for di, d in enumerate(defs):
        next_d = defs[di + 1] if di + 1 < len(defs) else nOps
        last_u = -1
        for u in uses:
            if d <= u < next_d:
                last_u = u
        if last_u > d:
            intervals.append((d, last_u, key[0], key[1]))

# Compute liveness at every op boundary using sweep line
events = []
for start, end, typ, idx in intervals:
    weight = 1 if typ == TMP1 else 3
    events.append((start, +weight))
    events.append((end + 1, -weight))  # +1 because live THROUGH end

events.sort()
liveness = [0] * (nOps + 1)
current = 0
ei = 0
for i in range(nOps + 1):
    while ei < len(events) and events[ei][0] == i:
        current += events[ei][1]
        ei += 1
    liveness[i] = current

# Find natural segment boundaries: points where liveness drops to minimum
# The Q expression accumulator (tmp3) is almost always live, so minimum > 0
min_live = min(liveness[1:nOps])  # exclude boundaries 0 and nOps
print(f"\nLiveness: min={min_live}, max={max(liveness)}")

# Find all boundaries where liveness == min_live
min_boundaries = [i for i in range(1, nOps) if liveness[i] == min_live]
print(f"Boundaries at minimum liveness ({min_live}): {len(min_boundaries)} points")

if min_boundaries:
    # Show spacing between consecutive minimum-liveness points
    spacings = [min_boundaries[i+1] - min_boundaries[i]
                for i in range(len(min_boundaries)-1)]
    spacing_freq = defaultdict(int)
    for s in spacings:
        spacing_freq[s] += 1
    print(f"\nSpacing frequencies between min-liveness boundaries:")
    for s, c in sorted(spacing_freq.items(), key=lambda x: -x[1])[:15]:
        print(f"  spacing={s}: {c} times")

    # Identify candidate round boundaries: consecutive min-liveness points
    # spaced ~3002 apart (24 Keccak rounds in 72055 ops)
    round_candidates = [0]
    for b in min_boundaries:
        if b - round_candidates[-1] >= 2500:
            round_candidates.append(b)
    round_candidates.append(nOps)
    print(f"\nCandidate round boundaries (spacing >= 2500): {len(round_candidates) - 1} segments")
    for i in range(len(round_candidates) - 1):
        start, end = round_candidates[i], round_candidates[i + 1]
        print(f"  Segment {i}: ops [{start}, {end}), size={end-start}, liveness_at_start={liveness[start]}")

    # Check structural isomorphism between segments
    print(f"\n=== Structural Isomorphism Check ===")
    segments = [(round_candidates[i], round_candidates[i+1]) for i in range(len(round_candidates)-1)]

    def segment_signature(start, end):
        """Create a structural signature: (op_types, arith_ops, src_types) but NOT column indices."""
        sig = []
        for i in range(start, end):
            b = i * 8
            op_type = ops[i]
            arith = args[b]
            s0t = args[b + 2]
            s1t = args[b + 5]
            sig.append((op_type, arith, s0t, s1t))
        return tuple(sig)

    def segment_column_offsets(start, end):
        """Extract the column indices used (for parameterization check)."""
        cols = []
        for i in range(start, end):
            b = i * 8
            for s in range(2):
                st = args[b + 2 + s * 3]
                sa = args[b + 3 + s * 3]
                if st < TMP1:  # External source (not temp)
                    cols.append((st, sa))
        return cols

    # Compare all pairs of segments
    sigs = [segment_signature(s, e) for s, e in segments]
    sizes = [e - s for s, e in segments]

    print(f"\nSegment sizes: {sizes}")

    # Group by signature
    sig_groups = defaultdict(list)
    for i, sig in enumerate(sigs):
        sig_groups[sig].append(i)

    print(f"\nSignature groups (segments with identical structure):")
    for sig, indices in sorted(sig_groups.items(), key=lambda x: -len(x[1])):
        if len(indices) > 1:
            seg_sizes = [sizes[i] for i in indices]
            print(f"  Group of {len(indices)} segments (size={seg_sizes[0]}): segments {indices}")

            # Check if column offsets differ by a constant shift
            cols_0 = segment_column_offsets(*segments[indices[0]])
            cols_1 = segment_column_offsets(*segments[indices[1]])
            if len(cols_0) == len(cols_1):
                shifts = set()
                for (t0, c0), (t1, c1) in zip(cols_0, cols_1):
                    if t0 == t1:
                        shifts.add(c1 - c0)
                print(f"    Column shifts between segments {indices[0]} and {indices[1]}: {len(shifts)} unique shifts")
                if len(shifts) <= 5:
                    print(f"    Shifts: {sorted(shifts)}")
        else:
            print(f"  Unique segment {indices[0]} (size={sizes[indices[0]]})")

    # Final verdict
    max_group = max(len(v) for v in sig_groups.values())
    total_segments = len(segments)
    print(f"\n=== VERDICT ===")
    print(f"Total segments: {total_segments}")
    print(f"Largest group of structurally identical segments: {max_group}")
    if max_group >= 20:
        print(f"FEASIBLE: {max_group} isomorphic segments found. Round-aware evaluator possible.")
    elif max_group >= 10:
        print(f"PARTIALLY FEASIBLE: {max_group} isomorphic segments. Partial round extraction possible.")
    else:
        print(f"INFEASIBLE: No group of >= 10 isomorphic segments. Expression lacks round periodicity.")
        print(f"The PIL constraint compilation has flattened the Keccak round structure.")
