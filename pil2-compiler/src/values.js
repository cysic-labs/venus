module.exports = class Values {
    #values;
    #mutable;
    #bytes;
    #buffer;
    #rows;
    constructor (bytes, rows, create = true) {
        this.#bytes = bytes;
        this.#rows = rows;
        if (create) {
            this.createBuffer();
        } else {
            this.#buffer = false;
            this.#values = false;
        }
    }
    get mutable() {
        return this.#mutable;
    }
    set mutable(value) {
        let _value = Boolean(value);
        if (_value === this.#mutable) {
            return;
        }
        if (value && !this.#values !== false) {
            this.cloneValues();
        }
        this.#mutable = value;
    }
    clone(cloneValues = false, cloneEachValue = true) {
        let cloned = new Values();
        cloned.#values = this.#values;
        if (this.#mutable || cloneValues) {
            if (this.#values !== false) cloned.cloneValues(cloneEachValue);
        } else {
            cloned.#mutable = false;
        }
        return cloned;
    }
    cloneValues(cloneEachValue = true) {
        console.log('\x1B[1;33m************** CLONEVALUES *****************\x1B[0m');
        let _values = this.#values;
        this.#values = [];
        for(const _value of _values) {
            this.#values.push((cloneEachValue && _value && typeof _value.clone === 'function') ?_value.clone() : _value);
        }
    }
    initValues() {
        if (this.#values !== false) return;
        this.createBuffer();
    }
    createBuffer() {
        if (this.#bytes === true) {
            this.#values = new Array(this.#rows);
        }
        this.#buffer = Buffer.alloc(this.#rows * this.#bytes);
        switch (this.#bytes) {
            case 1: this.#values = new Uint8Array(this.#buffer.buffer, 0, this.#rows); break;
            case 2: this.#values = new Uint16Array(this.#buffer.buffer, 0, this.#rows); break;
            case 4: this.#values = new Uint32Array(this.#buffer.buffer, 0, this.#rows); break;
            case 8: this.#values = new BigUint64Array(this.#buffer.buffer, 0, this.#rows); break;
        }
    }
    setValue(irow, value) {
        if (!this.#mutable) {
            throw new Error(`modifying an inmutable values irow = ${irow} and value = ${value}`);
        }
        this.__setValue(irow, value);
    }
    __setValue(irow, value) {
        this.initValues();
        if (this.#bytes === 8) this.#values[irow] = Context.Fr.e(value);
        else this.#values[irow] = Number(value);
    }
    getValue(irow) {
        const res = this.#values === false ? 0n : BigInt(this.#values[irow]);
        return res;
    }
    getValues() {
        return this.#values;
    }
    toString() {
        return this.#values === false ? '' :  this.#values.join();
    }
    __setValues(buffer, values) {
        this.#buffer = buffer;
        this.#values = values;
    }
    getBuffer() {
        return this.#buffer;
    }
}
