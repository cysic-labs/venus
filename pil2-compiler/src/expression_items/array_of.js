const util = require('util');
const LabelRanges = require("../label_ranges.js");
const RuntimeItem = require("./runtime_item.js");
const MultiArray = require('../multi_array.js');
const Context = require('../context.js');
const Types = require('../types.js');
const assert = require('../assert.js');

module.exports = class ArrayOf extends RuntimeItem {
    constructor (instanceType, array, unrollLevels = 0) {
        super();
        assert.instanceOf(array, MultiArray);
        this._array = array.clone();
        this.unrollLevels = unrollLevels;
//        console.log(`ARRAYOF(${instanceType})[${array.lengths.map(x => x.toString(10)).join('],[')}] D${this.dim}`);
        this.instanceType = instanceType;
    }
    set rowOffset(value) {
        throw new Error('rowOffset is not supported in ArrayOf');
    }
    get isArray() {
        return true;
    }
    toString(options) {
        return super.toString(options)+'['+this._array.lengths.join('][')+`] D${this.dim}`;
    }
    get dim() {
        return this._array.dim;
    }
    get array() {
        assert.notStrictEqual(this._array, false, 'try to access to array, but array lengths not defined');
        return this._array;
    }
    set array(value) {
        if (this._array !== false) {
            throw new Error();
        }
        this._array = value;
    }
    get instance() {
        return Context.references.getTypeInstance(this.instanceType);
    }
    cloneInstance() {
        let cloned =  new ArrayOf(this.instanceType, this._array, this.unrollLevels, this.row);
        if (typeof this.rowOffset !== 'undefined' && this.rowOffset !== false) {
            cloned.rowOffset = this.rowOffset.clone();
        }
        return cloned;
    }
    evalInside() {
        return this.clone();
    }
    getItem(indexes) {
        const offset = this._array.indexesToOffset(indexes);
        return this.instance.getItem(offset);
    }
    getValue(indexes) {
        return this.getItem(indexes).getValue();
    }
    getLevelLength(indexes) {
        return this._array.getLevelLength(indexes);
    }
    toOneArray(indexes = []) {
        return this.#toArrays(indexes, false);
    }
    toArrays(indexes = []) {
        return this.#toArrays(indexes, true);
    }
    #toArrays(indexes = [], multidim = true) {
        let level = indexes.length;
        if (level >= this._array.dim) {
            return this.getItem(indexes);
        }
        let nextLevelLen = this._array.lengths[level];
        let res = [];
        for (let nextLevelIndex = 0; nextLevelIndex < nextLevelLen; ++nextLevelIndex) {
            const _indexes = [...indexes, nextLevelIndex];
            const dres = this.toArrays(_indexes);
            if (multidim || Array.isArray(dres) === false) { res.push(dres); }
            else { res.push.apply(res, dres); }
        }
        return res;
    }
    static getType() {
        return this.instanceType;
    }
    operatorSpread() {
        return new ArrayOf(this.instanceType, this._array, this.unrollLevels + 1);
    }
    isUnrolled() {
        return this.unrollLevels > 0;
    }
    unroll() {
        assert.strictEqual(this.unrollLevels, 1);

        if (this._array.dim > 1) {
            // TODO: implement array of arrays of
            EXIT_HERE;
        }
        let len = this._array.lengths[0];
        let res = [];
        for (let index = 0; index < len; ++index) {
            res.push(this.getItem([index]));
        }
        return res;
    }
}
