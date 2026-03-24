const ProofItem = require("./proof_item.js");
const Context = require('../context.js');
const fs = require('fs');
const IntValue = require('../expression_items/int_value.js');
const FixedFile = require('../fixed_file.js');
const ExpressionItems = require('../expression_items.js');
const assert = require('../assert.js');

const U64_MAX = 2n**64n - 1n;

module.exports = class FixedCol extends ProofItem {
    constructor (id, data) {
        super(id);
        this.rows = data.virtual ?? 0;
        this.sequence = null;
        this.values = false;
        this.maxValue = 0;
        this.bytes = data.bytes ? 8 : false;

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
        this.rows = Context.rows;
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
            this.rows = Context.rows;
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
                this.rows = Context.rows;   
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
            return this.sequence.getIntValue(row);
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
            throw new Error(`Error getting row ${row} from fixed column ${this.id} at ${Context.sourceRef}: ${e.message}`);
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
            const max_rows = this.rows ? this.rows : Context.rows;
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
        if (src_offset + count > src.getValues().length) {
            throw new Error('Source range exceeds source length');
        }
        if (dst_offset + count > this.getValues().length) {
            throw new Error('Destination range exceeds destination length');
        }
        const srcValues = src.getValues();
        const dstValues = this.getValues();

        // Obtain the Buffer from the ArrayBuffer
        const srcBuffer = Buffer.from(srcValues.buffer);
        const dstBuffer = Buffer.from(dstValues.buffer);
        
        // Copy bytes (convert 64bits index to bytes)
        const srcByteOffset = Number(src_offset) * 8;
        const dstByteOffset = Number(dst_offset) * 8;
        const byteLength = Number(count) * 8;
        
        srcBuffer.copy(dstBuffer, dstByteOffset, srcByteOffset, srcByteOffset + byteLength);
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
}
