const MultiArray = require("./multi_array.js");
const ArrayOf = require('./expression_items/array_of.js');
const RangeIndex = require('./expression_items/range_index.js');
const IntValue = require('./expression_items/int_value.js');
const Context = require('./context.js');
const Debug = require('./debug.js');
const Exceptions = require('./exceptions.js');
const assert = require('./assert.js');

/**
 * @property {MultiArray} array
 */

class Reference {

    constructor (name, type, isReference, array, id, instance, scopeId, properties) {
        this.name = name;
        this.type = type;
        assert.typeOf(isReference, 'boolean');
        this.isReference = isReference;
        this.array = array;
        this.locator = id;
        this.scopeId = scopeId;
        this.instance = instance;
        this.initialized = false;
        for (const property in properties) {
            assert.undefined(this[property]);
            if (Debug.active) if (property === 'const') console.log(['CONST ********', properties[property]]);
            this[property] = properties[property];
        }
    }
    isValidIndexes(indexes = []) {
        // if (!Array.isArray(indexes) || indexes.length == 0) return true;
        if (!Array.isArray(indexes)) return false;
        if (indexes.length == 0) return true;
        if (!this.array) return false;
        return this.array.isValidIndexes(indexes);
    }
    markAsInitialized(indexes = []) {
        if (indexes.length === 0 || !this.array) {
            assert.strictEqual(this.initialized, false);
            this.initialized = true;
        }
        else {
            this.array.markAsInitialized(indexes);
        }
    }
    isInitialized(indexes = []) {
        return  (indexes.length === 0 || !this.array) ? this.initialized : this.array.isInitialized(indexes);
    }
    getId(indexes = []) {
        if (Debug.active) {
            console.log(`getId ${this.name} ${Array.isArray(indexes) ? '[' + indexes.join(',') + ']':indexes} ${this.array ? this.array.toDebugString():''}`);
        }
        if (indexes.length > 0 && !this.array) {
            throw new Error(`Accessing to index, but not an array ${this.name} ${Context.sourceTag}`);
        }
        // return (indexes.length > 0 || this.array) ? this.array.getLocator(this.locator, indexes) : this.locator;
        return this.array ? this.array.getLocator(this.locator, indexes) : this.locator;
    }
    set (value, indexes = [], options = {}) {
        if (Debug.active) console.log(`set(${this.name}, [${indexes.join(',')}]`);
        assert.notStrictEqual(value, null); // to detect obsolete legacy uses
        // console.log(indexes.length, this.array.dim);
        if (this.callback) {
            this.callback(value, indexes, options);
        }
        if (!this.array || this.array.isFullIndexed(indexes) || this.array.isOverIndexed(indexes)) {
            return this.setOneItem(value, indexes, options);
        }
        this.setArrayLevel(indexes.length, indexes, [], value, options);
        // At this point, it's a array initilization
    }
    /**
     * Set value for all array elements (multidimensional)
     * @param {number} level - level of reference to set, for example: a (level=0), b[2] (level=1), b[2][1] (level=2)
     * @param {number[]} indexes - current indexes of set, for example: a (indexes=[]), b[2] (indexes=[2]), b[2][1] (indexes=[2][1])
     * @param {number[]} vindexes - current indexes of value to assign, for example: a (indexes=[]), b[2] (indexes=[2]), b[2][1] (indexes=[2][1])
     * @param {ExpressionItem} value - value to set
     * @param {Object} options
     */
    setArrayLevel(level, indexes, vindexes, value, options = {}) {
        if (Debug.active) console.log(`setArrayLevel(${this.name} ${level}, [${indexes.join(',')}], [${vindexes.join(',')}]) ${Context.sourceRef}`);
        const len = this.array.lengths[level];

        // indexes is base, over it we fill all value levels.
        const isArray = Array.isArray(value);
        const valueLen = isArray ? value.length : value.getLevelLength(vindexes);

        if (len !== valueLen) {
            throw new Error(`Mismatch con array length (${len} vs ${valueLen}) on ${this.name}[${indexes.join('][')}] level:${level} at ${Context.sourceRef}`);
        }

        for (let index = 0; index < len; ++index) {
            const _indexes = [...indexes, index];
            const _vindexes = [...vindexes, index];

            // we are on final now we could set values
            if (level + 1 === this.array.dim) {
                if (isArray) {
                    this.setOneItem(value[index], _indexes, options);
                } else {
                    if (value.dump) value.dump();
                    const _item = value.getItem(_vindexes);
                    this.setOneItem(_item, _indexes, options);
                }
                continue;
            }
            // for each possible index call recursiverly up levels
            this.setArrayLevel(level+1, _indexes, _vindexes, isArray ? value[index] : value, options);
        }
    }
    // setting by only one element
    setOneItem(value, indexes, options = {}) {
        if (!this.isInitialized(indexes)) {
            return this.#doInit(value, indexes);
        } else if (options.doInit) {
            // called as doInit:true but it's initizalized before
            throw new Error('value initialized');
        }
        const [row, id] = this.getRowAndId(indexes);
        if (this.const) {
            throw new Error(`setting ${this.name} a const element on ${Context.sourceRef}`);
        }
        if (row !== false) this.instance.setRowValue(id, row, value);
        else this.instance.set(id, value);
    }
    #doInit(value, indexes) {
        const [row, id] = this.getRowAndId(indexes);
        assert.notStrictEqual(id, null);
        if (row !== false) {
            this.instance.setRowValue(id, row, value);
        } else {
            this.instance.set(id, value);
        }
        this.markAsInitialized(indexes);
    }
    init (value, indexes = [], options = {}) {
        assert.notStrictEqual(value, null); // to detect obsolete legacy uses
        this.set(value, indexes, {...options, doInit: true});
    }
    static getArrayAndSize(lengths) {
        // TODO: dynamic arrays, call to factory, who decides?
        if (lengths && lengths.length) {
            let array = new MultiArray(lengths);
            return [array, array.size];
        }
        return [false, 1];
    }
    get (indexes = []) {
        const [row, id] = this.getRowAndId(indexes);
        if (row !== false) {
            return this.instance.getRowValue(id, row);
        }
        return this.instance.get(id);
    }
    getRowAndId(indexes = []) {
        if (!this.instance.runtimeRows || indexes.length === 0) {
            return [false, this.getId(indexes)];
        }
        if (!this.array) {
            if (indexes.length === 1) {
                return [indexes[0], this.getId(indexes.slice(0, -1))];
            }
            throw new Error(`Accessing to index, but not an array ${this.name} ${Context.sourceTag}`);
        }
        if ((this.array.dim + 1) === indexes.length) {
            // return row and the id of indexes without row
            return [indexes[indexes.length - 1], this.getId(indexes.slice(0,-1))];
        }
        // other cases managed by getId because they aren't row access
        return [false, this.getId(indexes)];
    }
    evaluateIndexes(indexes, options) {
        if (!Array.isArray(indexes) || indexes.length == 0) {
            return [[], false, false];
        }

        let fromIndex = false;
        let toIndex = false;
        let evaluatedIndexes = [];
        for (let index = 0; index < indexes.length; ++index) {
            if (indexes[index].isInstanceOf && indexes[index].isInstanceOf(RangeIndex)) {
                if (index + 1 !== indexes.length) {
                    throw new Error(`Range index is valid only in last index ${Context.sourceRef}`);
                }
                const rangeIndex = indexes[index].getAloneOperand();
                fromIndex = rangeIndex.from === false ? false : Number(rangeIndex.from.asInt());
                toIndex = rangeIndex.to === false ? false : Number(rangeIndex.to.asInt());
                continue;
            }
            if (typeof indexes[index] === 'number') {
                evaluatedIndexes.push(BigInt(indexes[index]));
                continue;
            }
            if (typeof indexes[index] === 'bigint') {
                evaluatedIndexes.push(indexes[index]);
                continue;
            }
            evaluatedIndexes.push(indexes[index].asInt());
        }
        return [evaluatedIndexes, fromIndex, toIndex];
    }
    getArraySize() {
        if (!this.array) return 0;
        return this.array.size;
    }
    getNthItem(nth, options) {
        if (!this.array) {
            throw new Error('getNthItem implemented only for arrays');
        }
        if (this.instance.runtimeRow) {
            throw new Error('getNthItem not implemented for runtime rows');
        }
        const indexes = this.array.offsetToIndexes(nth);
        return this.getItem(indexes, options);
    }
    getItem(indexes, options = {}) {
        let locator = this.locator;
        let label = options.label ?? this.name;

        if (Debug.active) {
            console.log(indexes);
            console.log(this);
        }
        const [evaluatedIndexes, fromIndex, toIndex] = this.evaluateIndexes(indexes, options);

        if (evaluatedIndexes.length) {
            label = label + '['+evaluatedIndexes.join('][')+']';
        }
        // if array is defined
        let res = false;
        let runtimeRow = false;
        if (this.array) {
            // check if row access in case of fixed
            if (this.instance.runtimeRows && this.array.isFullIndexed(evaluatedIndexes.slice(0, -1))) {
                locator = this.array.locatorIndexesApply(this.locator, evaluatedIndexes.slice(0, -1));
                runtimeRow = evaluatedIndexes[evaluatedIndexes.length - 1];
            }
            else {
                if (!this.array.insideOfBounds(evaluatedIndexes)) {
                    throw new Exceptions.OutOfBounds(`Reference ${label} out of bounds`);
                }
                if (this.array.isFullIndexed(evaluatedIndexes)) {
                    // full access => result an item (non subarray)
                    locator = this.array.locatorIndexesApply(this.locator, evaluatedIndexes);
                } else if (this.array.isSubIndexed(evaluatedIndexes)) {
                    // parcial access => result a subarray
                    res = new ArrayOf(this.type, this.array.createSubArray(evaluatedIndexes, locator, fromIndex, toIndex));
                } else {
                    // overindexes, out-of-dim
                    throw new Exceptions.OutOfDims(`Reference ${label} out of dims`);
                }
            }
        } else if (evaluatedIndexes.length === 1 && this.instance.runtimeRows) {
            res = this.instance.getRowValue(locator, evaluatedIndexes[0], options.rowOffset ?? 0);
            if (typeof res === 'undefined') {
                throw Error(`ERROR: Row ${evaluatedIndexes[0]} of ${options.label} isn't initialized`);
            }
        } else if (evaluatedIndexes.length > 0) {
            console.log('C');
            console.log(evaluatedIndexes);
            console.log(this);
            throw new Error('try to access to index on non-array value');
        }
        if (typeof res === 'bigint' || typeof res === 'number') {
            res = new IntValue(res);
        }
        if (res === false) {
            res = this.const ? this.instance.getConstItem(locator, options) : this.instance.getItem(locator, options);
        }

        if (label) {
            res.setLabel(label);
        } else res.setLabel('___');

        if (runtimeRow !== false) {
            return res.getRowItem(runtimeRow, options.rowOffset ?? 0);
        }
        return res;
    }
}

module.exports = Reference;