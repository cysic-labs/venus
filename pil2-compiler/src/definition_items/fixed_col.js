const ProofItem = require("./proof_item.js");
const Context = require('../context.js');
const fs = require('fs');
const IntValue = require('../expression_items/int_value.js');
const FixedFile = require('../fixed_file.js');
const ExpressionItems = require('../expression_items.js');
const TableAnalysis = require('../table_analysis.js');
const assert = require('../assert.js');

const U64_MAX = 2n**64n - 1n;

// read values[index] failing with the global row index when the row was never
// set (a hole in plain-Array storage, i.e. columns holding values wider than
// 64 bits)
function definedRowValue(values, index, label) {
    const value = values[index];
    if (value === undefined) {
        throw new Error(`Row ${index} of fixed column ${label || '(unnamed)'} is not defined at ${Context.sourceRef}`);
    }
    return value;
}

// Check, element by element over the raw stored values, that the row offset r
// really describes one window in terms of the other:
//     other[otherStart + i] == values[start + ((i + r) mod n)] + delta
// for every i, with delta fixed by the first row.
function verifyRowOffset(values, start, otherValues, otherStart, n, r) {
    const delta = BigInt(otherValues[otherStart]) - BigInt(values[start + r]);
    for (let i = 0; i < n; ++i) {
        const expected = BigInt(values[start + ((i + r) % n)]) + delta;
        if (BigInt(otherValues[otherStart + i]) !== expected) {
            return false;
        }
    }
    return true;
}

module.exports = class FixedCol extends ProofItem {
    constructor (id, data) {
        super(id);
        // virtual(n)/temporal(n) declare their own row count; the pragma
        // fixed_tmp sets data.temporal = true (no row count)
        this.rows = data.virtual ?? (typeof data.temporal === 'number' ? data.temporal : 0);
        this.sequence = null;
        this.values = false;
        this.maxValue = 0;
        this.bytes = data.bytes ? data.bytes : false;

        this.temporal = Boolean(data.temporal || data.virtual)
        this.external = data.external ?? false;
        this.label = data.label ?? false;
        this.size = 0;
        this.maxRow = -1;
        this.fullFilled = false;
        this.buffer = null;
        this.converter = x => x;
        this.currentSetRowValue = this.#setRowValue;
        if (data.loadFromFile) {
            this.fromFile = data.loadFromFile;
            this.loaded = false;
        } else {
            this.fromFile = false;
            this.loaded = true;
        }        
        // TODO: more faster option, change function that call
        // for each value to avoid verify if value is bigger than bytes specified
    }
    initDefaultValues() {
        if (this.bytes === false) {
            this.bytes = 8;
        }
        [this.buffer, this.values, this.converter] = this.createBuffer(this.rows, this.bytes);
        this.updateSize();
        this.updateSetRowValue(); 
    }
    loadFromFile() {
        this.rows = Number(Context.rows);
        this.initDefaultValues();
        FixedFile.loadColumnFromFile(this.fromFile.filename, this.fromFile.col, this.rows, this.values, this.label);
        this.loaded = true;
    }
    getRowCount() {
        return this.getValues().length;
    }   
    getId() {
        return this.id;
    }
    isPeriodic() {
        return false;
    }
    getValue(row, rowOffset = 0)  {
        return this.getRowValue(row, rowOffset);
    }
    getValueItem(row, rowOffset = 0) {
        return this.getRowItem(row, rowOffset);
    }
    setValue(value) {
        // TODO: review
        this.set(value);
    }
    valueToBytes(value) {
        if (value < 256n) return 1;
        if (value < 65536n) return 2;
        if (value < 4294967296n) return 4;
        if (value <= U64_MAX) return 8;
        return true; // big int
    }
    createBuffer(rows, bytes) {
        if (bytes === true) {
            return [false, new Array(rows), x => x];
        }
        const buffer = new Buffer.alloc(rows * bytes);
        switch (bytes) {
            case 1: return [buffer, new Uint8Array(buffer.buffer, 0, rows), x => Number(x)];
            case 2: return [buffer, new Uint16Array(buffer.buffer, 0, rows), x => Number(x)];
            case 4: return [buffer, new Uint32Array(buffer.buffer, 0, rows), x => Number(x)];
            case 8: return [buffer, new BigUint64Array(buffer.buffer, 0, rows), x => x];
            case BIG_INT: return [buffer, new Array(rows), x => x];
        }
        throw new Error(`invalid number of bytes ${bytes}`);
    }
    checkIfResize(row, value) {
        if (this.bytes === true) return;

        switch (this.bytes) {
            case 1: if (value >= 256n) this.resizeValues(row, value); break;
            case 2: if (value >= 65536n) this.resizeValues(row, value); break;
            case 4: if (value >= 4294967296n) this.resizeValues(row, value); break;
            case 8: if (value > U64_MAX) this.resizeValues(row, value); break;
        }
    }
    setRowValue(row, value) {
        if (this.sequence) {
            throw new Error(`setting a row value but assigned a sequence previously ${Context.sourceTag}`);
        }
        if (this.fromFile) {
            throw new Error(`Cannot assign a value to a fixed column that is loaded from file ${this.fromFile} at ${Context.sourceRef}`);
        }
        if (value && typeof value.asInt === 'function') {
            value = value.asInt();
        }
        this.currentSetRowValue(row, value);
    }
    updateSize() {
        if (typeof this.bytes === 'boolean') {
            this.size = false;
            return;
        }

        this.size = this.rows * this.bytes;
        return;
    }
    #setRowValue(row, value) {
        value = Context.Fr.e(value);
        if (this.values === false){
            this.rows = Number(Context.rows);
            if (this.bytes === false) {
                this.bytes = 8;
                // this.bytes = this.valueToBytes(value);
            }
            [this.buffer, this.values, this.converter] = this.createBuffer(this.rows, this.bytes);
            this.updateSize();
            this.updateSetRowValue();
        } else {
            this.checkIfResize(row, value);
        }
        if (row > this.maxRow) this.maxRow = row;
        this.values[row] = this.converter(value);
    }
    getValues() {
        if (this.sequence) {
            return this.sequence.getValues();
        }
        if (!this.loaded) {
            throw new Error(`Data of fixed column ${this.label} not loaded/found`);
        }
        if (this.values === false) {
            if (this.rows === 0) {
                this.rows = Number(Context.rows);   
            }
            this.initDefaultValues();
        }
        return this.values;
    }
    #fastSetRowValue(row, value) {
        value = Context.Fr.e(value);
        this.values[row] = this.converter(value);
    }
    #ultraFastSetRowValue(row, value) {
        value = Context.Fr.e(value);
        this.values[row] = value;
    }
    resizeValues(row, value) {
        let _bytes = this.valueToBytes(value);
        let [_buffer, _values, _converter] = this.createBuffer(this.rows, _bytes);
        const _resizeConvert = !this.useBigIntValue() && this.useBigIntValue(_bytes) ? (x) => BigInt(x) : (x) => x;
        for (let i = 0; i <= this.maxRow; ++i) {
            _values[i] = _resizeConvert(this.values[i]);
        }
        if (this.maxRow > 128) {
            console.log(`  > \x1B[33mWARNING: fixed RESIZE from ${this.bytes} bytes to ${_bytes} on row ${row}/${this.maxRow} at ${Context.sourceRef}\x1B[0m`);
            console.log(`  > \x1B[33muse #pragma fixed_bytes ${_bytes} to force initial size\x1B[0m`);
        } else if (Context.config.logFixedResize) {
            console.log(`  > resize fixed size from ${this.bytes} bytes to ${_bytes} on row ${row} at ${Context.sourceRef}`);
        }
        this.values = _values;
        this.bytes = _bytes;
        this.buffer = _buffer;
        this.converter = _converter;
        this.size = this.bytes === true ? false : this.rows * this.bytes;
        this.updateSetRowValue();
    }
    useBigIntValue(bytes) {
        const _bytes = bytes ?? this.bytes;
        return _bytes >= 8 || _bytes === true;
    }
    updateSetRowValue() {
        const maxSizeValue = 2n ** BigInt(this.bytes * 8);
        if (maxSizeValue >= Context.Fr.p ) {
            this.currentSetRowValue = this.useBigIntValue() ? this.#ultraFastSetRowValue : this.#fastSetRowValue;
        }
    }
    getRowValue(row, rowOffset = 0) {
        if (this.sequence) {
            if (rowOffset) {
                const rows  = BigInt(this.rows);
                return this.sequence.getIntValue((BigInt(row) + BigInt(rowOffset) + rows) % rows);
            }
            try {           
                return this.sequence.getIntValue(row);
            } catch (e) {
                throw new Error(`Error getting row ${row} from fixed column ${this.label}(id:${this.id}) assigned to sequence at ${Context.sourceRef}: ${e.message}`);
            }
        }
        if (!this.loaded) {
            this.loadFromFile();
        }
        if (row >= this.size) {
            throw new Error(`Out-of-bounds on fixed, to access to row ${row} valid indexs [0..${this.size}] N=${Context.rows} in ${Context.references.getLabelByItem(this)}`);
        }
        if (rowOffset) {
            const rows  = BigInt(this.rows);
            row = Number((BigInt(row) + BigInt(rowOffset) + rows) % rows);
        }
        try {
            return BigInt(this.values[row]);
        } catch (e) {
            throw new Error(`Error getting row ${row} from fixed column ${this.label}(id:${this.id}) at ${Context.sourceRef}: ${e.message}`);
        }
    }
    getRowItem(row, rowOffset = 0) {
        return new IntValue(this.getRowValue(row, rowOffset));
    }
    set(value) {
        if ((value instanceof Object) === false) {
            throw new Error('Invalid assignation', value)
        }
        if (this.sequence !== null) {
            this.sequence.dump();
            throw new Error('Double sequence assignation');
        }
        if (this.values.length > 0) {
            throw new Error('Assign a sequence when has values');
        }
        if (value.isSequence) {
            const max_rows = this.rows ? this.rows : Number(Context.rows);
            if (value.size > max_rows) {
                throw new Error(`Invalid sequence size, sequence is too large, it has size of ${value.size} but number of rows is ${max_rows}, size exceeds in ${value.size - max_rows}`);
            }
            this.sequence = value;
            this.rows = this.sequence.size;
            return;
        }
        if (value.arrayInfo) {
            throw new Error('Extern fixed for arrays not implemented yet');
        }

        if (value.isExpression) {
            value = value.eval().getAlone();
            if (value === false) {
                throw new Error('Invalid value for fixed column');
            }

            const values = value.getValues();
            if (values instanceof BigUint64Array) {
                this.values = new BigUint64Array(values);
            } else if (Array.isArray(values)) {
                this.values = [...values];
            } else {
                this.values = values.slice();
            }
    
            this.buffer = value.buffer;
            this.converter = value.converter;
            this.rows = value.rows;
            this.bytes = value.bytes;
            this.fullFilled = value.fullFilled;
            this.label = value.label;
            this.bytes = value.bytes ?? 8;
            this.updateSize();
            this.updateSetRowValue();
            this.loaded = true;
            return;
        }

        if (value instanceof ExpressionItems.FixedCol) {
            this.copyRowsFrom(value, 0, 0, value.getRowCount());
            this.loaded = true;
            return;
        }

        if (value && value.loaded) {
            console.log(`  > Fixed ${this.label} loaded from file`);
            this.bytes = 8;
            this.buffer = value.values.buffer;
            this.values = value.values;
            this.converter = x => x;
            this.rows = value.values.length;
            this.updateSize();
            this.updateSetRowValue();        
            this.loaded = true;
            return;
        }
        throw new Error(`Invalid value for fixed column ${this.id} at ${Context.sourceTag}, expected a sequence or an expression, got ${value.constructor.name}`);
    }
    clone() {
        console.log('\x1B[41mWARING: clonning a FixedCol\x1B[0m');
        let cloned = new FixedCol(this.id);
        cloned.rows = this.rows;
        cloned.values = [...this.values];
        cloned.fullFilled = this.fullFilled;
        cloned.label = this.label;
        if (this.sequence) {
            cloned.sequence = this.sequence.clone();
        }
        return cloned;
    }
    dumpToFile(filename) {
        console.log(`Dumping ${this.id} to ${filename} ......`);
        const buffer = this.sequence ? this.sequence.getBuffer() : this.values;
        if (buffer === false) {
            throw new Error('This sequence cannot be saved to file');
        }
        fs.writeFileSync(filename, buffer, (err) => {
            if (err) {
                console.log(err);
                throw new Error(`Error saving file ${filename}: ${err}`);
            }});
    }

    printRowsFrom(offset, count) {
        if (offset < 0 || count < 0) {
            throw new Error('Invalid copy parameters');
        }
        if (offset + count > this.getValues().length) {
            throw new Error('Source range exceeds source length');
        }
        let _values = [];
        for (let index = 0n; index < count; index++) {
            const value = this.getValue(offset + index);
            _values.push(value);
        }
        // TODO: use println sytle, common code 
        const source = Context.config.printlnLines ? '['+Context.sourceTag+'] ':'';
        const spaces = Context.scope.getInstanceType() === 'proof' ? '': '  ';
        console.log(`\x1B[36m${spaces}> ${source}[${offset}..${offset+count-1n}] ${_values.join(' ')}\x1B[0m`);
    }
    copyRowsFrom(src, src_offset, dst_offset, count) {
        if (src_offset < 0 || dst_offset < 0 || count < 0) {
            throw new Error('Invalid copy parameters');
        }
        const srcValues = src.getValues();
        const dstValues = this.getValues();
        if (src_offset + count > srcValues.length) {
            throw new Error('Source range exceeds source length');
        }
        if (dst_offset + count > dstValues.length) {
            throw new Error('Destination range exceeds destination length');
        }
        const srcStart = Number(src_offset);
        const dstStart = Number(dst_offset);
        const n = Number(count);

        // fast path: both sides use the same typed-array element width, copy as
        // a single block (set() handles overlapping ranges of the same buffer)
        const srcBytes = srcValues.BYTES_PER_ELEMENT ?? false;
        const dstBytes = dstValues.BYTES_PER_ELEMENT ?? false;
        if (srcBytes !== false && srcBytes === dstBytes) {
            dstValues.set(srcValues.subarray(srcStart, srcStart + n), dstStart);
        } else {
            // different storage widths: copy element by element through
            // setRowValue, which converts and resizes the destination if needed
            const srcLabel = src.definition?.label ?? src.label ?? false;
            for (let index = 0; index < n; ++index) {
                this.setRowValue(dstStart + index, definedRowValue(srcValues, srcStart + index, srcLabel));
            }
        }
        // block copies (and the fast setRowValue variants) don't track maxRow,
        // but resizeValues only preserves rows up to maxRow
        const lastRow = dstStart + n - 1;
        if (n > 0 && lastRow > this.maxRow) this.maxRow = lastRow;
    }
    fillRowsFrom(value, offset, count) {
        if (offset < 0 || count < 0) {
            throw new Error('Invalid copy parameters');
        }
        if (offset + count > this.getValues().length) {
            throw new Error('Destination range exceeds destination length');
        }
        const values = this.getValues();
        values.fill(value, Number(offset), Number(offset + count));
    }    
    // NOTE: named *Range (not isConstant/isSequence) on purpose: `isSequence` is
    // an established truthy protocol property (Sequence.isSequence, checked by
    // set()), so a method with that name would shadow it
    isConstantRange(offset, count) {
        if (offset < 0 || count < 0) {
            throw new Error('Invalid isConstant parameters');
        }
        const values = this.getValues();
        if (offset + count > values.length) {
            throw new Error('isConstant range exceeds source length');
        }
        const start = Number(offset);
        const end = Number(offset + count);
        // an empty range (or a single value) is trivially constant
        if (end - start <= 1) {
            return true;
        }
        const first = definedRowValue(values, start, this.label);
        for (let index = start + 1; index < end; ++index) {
            if (definedRowValue(values, index, this.label) !== first) {
                return false;
            }
        }
        return true;
    }
    isSequenceRange(offset, count, delta) {
        if (offset < 0 || count < 0) {
            throw new Error('Invalid isSequence parameters');
        }
        const values = this.getValues();
        if (offset + count > values.length) {
            throw new Error('isSequence range exceeds source length');
        }
        const start = Number(offset);
        const end = Number(offset + count);
        // an empty range (or a single value) is trivially a sequence
        if (end - start <= 1) {
            return true;
        }
        // values may be a typed array (Number) or a BigInt array; normalize
        // everything to BigInt so the comparison and the delta share one type
        let prev = BigInt(definedRowValue(values, start, this.label));
        // if delta isn't given, infer it from the first two values
        const step = (delta === undefined || delta === null) ? BigInt(definedRowValue(values, start + 1, this.label)) - prev : BigInt(delta);
        for (let index = start + 1; index < end; ++index) {
            const current = BigInt(definedRowValue(values, index, this.label));
            if (current !== prev + step) {
                return false;
            }
            prev = current;
        }
        return true;
    }
    signature(offset, count) {
        if (offset < 0 || count < 0) {
            throw new Error('Invalid signature parameters');
        }
        const values = this.getValues();
        if (offset + count > values.length) {
            throw new Error('signature range exceeds source length');
        }
        const start = Number(offset);
        const end = Number(offset + count);
        // Non-cryptographic 64-bit FNV-1a rolling hash over the raw stored
        // values. It's order- and length-sensitive, so two ranges hash equal
        // iff they hold the same values in the same order. Only meant to
        // compare tables cheaply, not for any security purpose.
        const MASK = (1n << 64n) - 1n;
        const PRIME = 1099511628211n;      // FNV-1a 64-bit prime
        let h = 14695981039346656037n;     // FNV-1a 64-bit offset basis
        for (let index = start; index < end; ++index) {
            let v = BigInt(definedRowValue(values, index, this.label));
            // fold the value in 64-bit limbs so values wider than 64 bits
            // (big-int columns) still contribute all of their bits
            do {
                h = ((h ^ (v & MASK)) * PRIME) & MASK;
                v >>= 64n;
            } while (v > 0n);
        }
        return h;
    }
    areEquals(other, offset, otherOffset, count) {
        if (offset < 0 || otherOffset < 0 || count < 0) {
            throw new Error('Invalid areEquals parameters');
        }
        const values = this.getValues();
        const otherValues = other.getValues();
        if (offset + count > values.length) {
            throw new Error('areEquals range exceeds source length');
        }
        if (otherOffset + count > otherValues.length) {
            throw new Error('areEquals range exceeds the other source length');
        }
        const start = Number(offset);
        const otherStart = Number(otherOffset);
        const n = Number(count);
        // normalize both sides to BigInt so columns with different byte widths
        // (Number vs BigInt storage) compare by value, not by JS type
        const otherLabel = other.definition?.label ?? other.label ?? false;
        for (let index = 0; index < n; ++index) {
            if (BigInt(definedRowValue(values, start + index, this.label)) !==
                BigInt(definedRowValue(otherValues, otherStart + index, otherLabel))) {
                return false;
            }
        }
        return true;
    }
    comparativeSignature(offset, count) {
        if (offset < 0 || count < 0) {
            throw new Error('Invalid comparativeSignature parameters');
        }
        const values = this.getValues();
        if (offset + count > values.length) {
            throw new Error('comparativeSignature range exceeds source length');
        }
        const start = Number(offset);
        const end = Number(offset + count);
        if (end <= start) {
            return 0n;
        }
        // Signature invariant to a value shift (delta) and to a cyclic row
        // rotation (row_offset). Two tables can be "compatible" (equal up to
        // some row_offset and delta) only if they share this signature; a match
        // still has to be confirmed row by row and its actual row_offset
        // computed with compatibleOffset(), because the aggregation is
        // permutation-invariant (looser than rotation-invariant).
        // One pass: minimum, constant check and the power sums. Nothing is
        // aggregated while the range still looks constant (a constant range
        // needs no aggregation at all); the skipped prefix is backfilled in O(1)
        // on the first differing value. The packing is shared with
        // Tables.analyze, so both always return the same signature.
        const first = BigInt(definedRowValue(values, start, this.label));
        let min = first;
        let constant = true;
        let sumV = 0n;
        let sumV2 = 0n;
        for (let index = start; index < end; ++index) {
            const v = BigInt(definedRowValue(values, index, this.label));
            if (v < min) min = v;
            if (constant) {
                if (v !== first) {
                    constant = false;
                    const k = BigInt(index - start);
                    sumV = k * first + v;
                    sumV2 = k * first * first + v * v;
                }
            } else {
                sumV += v;
                sumV2 += v * v;
            }
        }
        if (constant) {
            return TableAnalysis.CONSTANT_COMPARATIVE_SIGNATURE;
        }
        return TableAnalysis.packComparativeSignature(min, sumV, sumV2, end - start);
    }
    compatibleOffset(other, offset, otherOffset, count) {
        if (offset < 0 || otherOffset < 0 || count < 0) {
            throw new Error('Invalid compatibleOffset parameters');
        }
        const values = this.getValues();
        const otherValues = other.getValues();
        if (offset + count > values.length) {
            throw new Error('compatibleOffset range exceeds source length');
        }
        if (otherOffset + count > otherValues.length) {
            throw new Error('compatibleOffset range exceeds the other source length');
        }
        const start = Number(offset);
        const otherStart = Number(otherOffset);
        const n = Number(count);
        if (n === 0) {
            return 0n;
        }
        // Normalize each window by subtracting its own minimum so a constant
        // value shift (delta) between the tables cancels out. After this, the
        // two tables are compatible iff the "other" window (b) is a cyclic
        // rotation of this window (a). The returned r is defined so that:
        //     other[otherOffset + i] == this[offset + ((i + r) mod count)] + delta
        // and the caller can then get delta = other[otherOffset] - this[offset + r].
        const a = new Array(n);
        const b = new Array(n);
        const otherLabel = other.definition?.label ?? other.label ?? false;
        let baseA = BigInt(definedRowValue(values, start, this.label));
        let baseB = BigInt(definedRowValue(otherValues, otherStart, otherLabel));
        for (let i = 1; i < n; ++i) {
            const va = BigInt(definedRowValue(values, start + i, this.label));
            if (va < baseA) baseA = va;
            const vb = BigInt(definedRowValue(otherValues, otherStart + i, otherLabel));
            if (vb < baseB) baseB = vb;
        }
        // every index was validated by the min scan above
        for (let i = 0; i < n; ++i) {
            a[i] = BigInt(values[start + i]) - baseA;
            b[i] = BigInt(otherValues[otherStart + i]) - baseB;
        }
        // Find the smallest r in [0, n) with a[(i+r) mod n] == b[i] for all i,
        // i.e. the pattern b occurs in the doubled text a+a at position r. KMP.
        const lps = new Int32Array(n);
        for (let i = 1, len = 0; i < n; ) {
            if (b[i] === b[len]) {
                lps[i++] = ++len;
            } else if (len > 0) {
                len = lps[len - 1];
            } else {
                lps[i++] = 0;
            }
        }
        for (let j = 0, k = 0; j < 2 * n; ) {
            if (a[j % n] === b[k]) {
                ++j; ++k;
                if (k === n) {
                    // candidate offset: the start position of the match
                    const r = j - n;
                    // KMP matched all n normalized values, but confirm the raw
                    // relation row by row (the same element-by-element check
                    // areEquals does) before reporting the offset
                    if (verifyRowOffset(values, start, otherValues, otherStart, n, r)) {
                        return BigInt(r);
                    }
                    return -1n;
                }
            } else if (k > 0) {
                k = lps[k - 1];
            } else {
                ++j;
            }
        }
        return -1n;
    }
    analyze(offset, count) {
        if (offset < 0 || count < 0) {
            throw new Error('Invalid analyze parameters');
        }
        const values = this.getValues();
        if (offset + count > values.length) {
            throw new Error('analyze range exceeds source length');
        }
        return TableAnalysis.analyzeValues(values, Number(offset), Number(count), this.label);
    }
}
