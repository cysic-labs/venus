const ExpressionItems = require('./expression_items.js');
const Context = require('./context.js');

// Detected pattern types (priority order: lower number wins when several match).
const TYPE_NOTHING = 0;         // no recognizable pattern
const TYPE_CONSTANT = 1;        // all values equal
const TYPE_SEQUENTIAL = 2;      // value[i+1] = value[i] + delta
const TYPE_PARTITIONS = 3;      // each 2^16 partition is constant (count multiple of 2^16)
const TYPE_CYCLE = 4;           // an arithmetic ramp repeated: value[i] = first + (i mod len)*delta

const PARTITION_SIZE = 65536;   // 2^16, minimum partition granularity

const MASK64 = (1n << 64n) - 1n;
const FNV_PRIME = 1099511628211n;
const FNV_OFFSET = 14695981039346656037n;

const COMPARATIVE_P = (1n << 127n) - 1n;    // Mersenne prime, big aggregation modulus

// A constant range aggregates nothing: every (v - min) is 0. Callers detect the
// constant case in their first pass and skip the aggregation altogether.
const CONSTANT_COMPARATIVE_SIGNATURE = 0n;

// Comparative signature of values[start .. start+count), given the minimum of
// the range. It is invariant to:
//   * a value shift (delta): the aggregated values are (v - min);
//   * a cyclic row rotation (row_offset): the aggregation is commutative.
//     s1 = Σ (v - min)
//     s2 = Σ (v - min)^2   -> separates multisets with an equal sum
//     s1 = Σ (v - min)   = Σv - n·min
//     s2 = Σ (v - min)^2 = Σv² - 2·min·Σv + n·min²   -> separates multisets
//                                                       with an equal sum
// Deriving both from Σv/Σv² is what lets the caller aggregate in the same pass
// that finds the minimum. The sums are exact and reduced modulo COMPARATIVE_P
// only here, once: a division per element costs far more than letting them grow.
function packComparativeSignature(min, sumV, sumV2, count) {
    const n = BigInt(count);
    const s1 = modP(sumV - n * min);
    const s2 = modP(sumV2 - 2n * min * sumV + n * min * min);
    return (s1 << 127n) | s2;
}

function modP(x) {
    const r = x % COMPARATIVE_P;
    return r < 0n ? r + COMPARATIVE_P : r;
}

function bitLength(x) {
    return x === 0n ? 0 : x.toString(2).length;
}

// Number of bits needed to represent every value in [min, max].
// Unsigned (min >= 0) -> positive count; signed (min < 0) -> negative count.
function computeBits(min, max) {
    if (min >= 0n) {
        return BigInt(Math.max(1, bitLength(max)));
    }
    let b = 1;
    while (min < -(1n << BigInt(b - 1)) || max > (1n << BigInt(b - 1)) - 1n) {
        ++b;
    }
    return BigInt(-b);
}

// Compact the raw 2^16-partition constants into the coarsest uniform (power-of-2)
// partitioning: while every adjacent pair is equal, halve the list. The caller
// knows the analyzed size, so it can infer each compacted partition's span.
function compactPartitions(partitionValues) {
    let comp = partitionValues.slice();
    while (comp.length > 1 && comp.length % 2 === 0) {
        let allPairsEqual = true;
        for (let k = 0; k < comp.length; k += 2) {
            if (comp[k] !== comp[k + 1]) { allPairsEqual = false; break; }
        }
        if (!allPairsEqual) break;
        const next = [];
        for (let k = 0; k < comp.length; k += 2) next.push(comp[k]);
        comp = next;
    }
    return comp;
}

class TableAnalysis {
    constructor() {
        this.offset = 0;
        this.size = 0;
        this.type = TYPE_NOTHING;
        this.signature = 0n;
        this.comparativeSignature = 0n;
        this.min = 0n;
        this.max = 0n;
        this.bits = 0n;
        this.constantValue = 0n;
        this.seqFirst = 0n;
        this.seqDelta = 0n;
        this.cycleFirst = 0n;
        this.cycleLen = 0;
        this.cycleReps = 0;
        this.cycleDelta = 0n;
        this.partitionValues = [];
        this.partitionsValid = false;
    }
    // [constant] | [first, delta] | [first_element] according to the type.
    getParameters() {
        switch (this.type) {
            case TYPE_CONSTANT:   return [this.constantValue];
            case TYPE_SEQUENTIAL: return [this.seqFirst, this.seqDelta];
            case TYPE_CYCLE:      return [this.cycleFirst];
            default:
                throw new Error(`get_analyzed_params is not available for analysis type ${this.type}`);
        }
    }
    getCycle() {
        if (this.type !== TYPE_CYCLE) {
            throw new Error(`get_analyzed_cycle: analysis is not a cycle (type ${this.type})`);
        }
        return [BigInt(this.cycleLen), BigInt(this.cycleReps), this.cycleDelta];
    }
    getPartitions() {
        if (this.type !== TYPE_PARTITIONS) {
            throw new Error(`get_analyzed_partitions: analysis is not constant-partitions (type ${this.type})`);
        }
        return compactPartitions(this.partitionValues);
    }
    getSize() {
        return [BigInt(this.offset), BigInt(this.size)];
    }
    getRangeValues() {
        return [this.min, this.max];
    }
}

// Single-pass analysis of values[start .. start+count).
function analyzeValues(values, start, count, label = false) {
    const analysis = new TableAnalysis();
    analysis.offset = start;
    analysis.size = count;

    if (count <= 0) {
        return analysis;
    }

    const end = start + count;
    if (values[start] === undefined) {
        throw new Error(`Row ${start} of fixed column ${label || '(unnamed)'} is not defined at ${Context.sourceRef}`);
    }
    const first = BigInt(values[start]);
    let min = first, max = first;
    let sig = FNV_OFFSET;

    let constant = true;
    let seqDelta = 0n;
    let sequential = true;

    let cycleDelta = 0n;
    let cycleLen = 0;               // 0 => still in the first ramp / not found
    let cycleBroken = false;

    let partitionConst = true;
    const partitionValues = [];

    // power sums for the comparative signature. Nothing is aggregated while the
    // range still looks constant (a constant range needs no aggregation at all);
    // the skipped prefix is backfilled in O(1) on the first differing value.
    let sumV = 0n;
    let sumV2 = 0n;

    let prev = first;
    for (let i = start; i < end; ++i) {
        const rel = i - start;
        if (values[i] === undefined) {
            throw new Error(`Row ${i} of fixed column ${label || '(unnamed)'} is not defined at ${Context.sourceRef}`);
        }
        const v = BigInt(values[i]);

        if (v < min) min = v;
        if (v > max) max = v;

        // FNV-1a signature, folding 64-bit limbs to cover values wider than 64 bits
        let x = v;
        do {
            sig = ((sig ^ (x & MASK64)) * FNV_PRIME) & MASK64;
            x >>= 64n;
        } while (x > 0n);

        if (constant) {
            if (v !== first) {
                constant = false;
                // backfill the prefix: the rel values before this one were all first
                const k = BigInt(rel);
                sumV = k * first + v;
                sumV2 = k * first * first + v * v;
            }
        } else {
            sumV += v;
            sumV2 += v * v;
        }

        // partitions: record each 2^16 chunk's value and check the chunk is constant
        if (rel % PARTITION_SIZE === 0) {
            partitionValues.push(v);
        } else if (partitionConst) {
            const chunk = Math.floor(rel / PARTITION_SIZE);
            if (v !== partitionValues[chunk]) partitionConst = false;
        }

        if (rel >= 1) {
            const d = v - prev;
            if (rel === 1) {
                seqDelta = d;
                cycleDelta = d;
            } else if (d !== seqDelta) {
                sequential = false;
            }
            // cycle detection
            if (!cycleBroken) {
                if (cycleLen === 0) {
                    if (d === cycleDelta) {
                        // still ramping within the first cycle
                    } else if (v === first) {
                        cycleLen = rel;             // reset back to first -> cycle length
                    } else {
                        cycleBroken = true;
                    }
                } else {
                    const expected = BigInt(values[start + (rel % cycleLen)]);
                    if (v !== expected) cycleBroken = true;
                }
            }
        }

        prev = v;
    }

    const partitionsValid = (count % PARTITION_SIZE === 0) && partitionConst;
    const cycleValid = cycleLen > 0 && !cycleBroken && (count % cycleLen === 0);

    let type;
    if (constant) type = TYPE_CONSTANT;
    else if (sequential) type = TYPE_SEQUENTIAL;
    else if (partitionsValid) type = TYPE_PARTITIONS;
    else if (cycleValid) type = TYPE_CYCLE;
    else type = TYPE_NOTHING;

    analysis.type = type;
    analysis.signature = sig;
    analysis.comparativeSignature = constant ? CONSTANT_COMPARATIVE_SIGNATURE
                                             : packComparativeSignature(min, sumV, sumV2, count);
    analysis.min = min;
    analysis.max = max;
    analysis.bits = computeBits(min, max);
    analysis.constantValue = first;
    analysis.seqFirst = first;
    analysis.seqDelta = seqDelta;
    analysis.cycleFirst = first;
    analysis.cycleLen = cycleLen;
    analysis.cycleReps = cycleValid ? count / cycleLen : 0;
    analysis.cycleDelta = cycleDelta;
    analysis.partitionValues = partitionValues;
    analysis.partitionsValid = partitionsValid;
    return analysis;
}

// ---- registry: analyses are addressed by an integer id ----
const analyses = [];

function register(analysis) {
    analyses.push(analysis);
    return analyses.length - 1;
}

function get(id) {
    const index = Number(id);
    if (!Number.isInteger(index) || index < 0 || index >= analyses.length) {
        throw new Error(`Invalid analysis id ${id}`);
    }
    return analyses[index];
}

let tempSeq = 0;

// Return a JS array of bigints as an int[] value usable from PIL, by declaring a
// temporary const reference (same mechanism a user function returning int[] uses).
function intArrayValue(bigintValues) {
    if (bigintValues.length === 0) {
        throw new Error('cannot return an empty array');
    }
    const items = bigintValues.map(v => new ExpressionItems.IntValue(BigInt(v)));
    const list = new ExpressionItems.ExpressionList(items);
    const name = `__tables_analyzed_${tempSeq++}`;
    Context.references.declare(name, 'int', [bigintValues.length], { const: true, sourceRef: Context.sourceRef }, list);
    return Context.references.getReference(name).getItem([]);
}

module.exports = {
    TYPE_NOTHING, TYPE_CONSTANT, TYPE_SEQUENTIAL, TYPE_PARTITIONS, TYPE_CYCLE,
    PARTITION_SIZE,
    TableAnalysis, analyzeValues, compactPartitions, computeBits,
    packComparativeSignature, CONSTANT_COMPARATIVE_SIGNATURE,
    register, get, intArrayValue,
};
