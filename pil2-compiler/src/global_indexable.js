const LabelRanges = require("./label_ranges.js");
const {cloneDeep} = require('lodash');
const ExpressionItem = require('./expression_items/expression_item.js');
const Debug = require('./debug.js');
const Context = require('./context.js');
const assert = require('./assert.js');
const Indexable = require('./indexable.js');
module.exports = class GlobalIndexable extends Indexable {
    constructor (type, definitionClass, expressionItemClass, options = {}) {
        super(type, definitionClass, expressionItemClass, options);
        this.activeIdsStack = [];
        this.activeIds = [];
    }
    get length() {
        return this.activeIds.length;
    }
    clone() {
        throw new Error('Clone method is not implemented for Indexable');
    }
    push() {
        this.activeIdsStack.push(this.activeIds);
        this.activeIds = [];
    }
    pop() {
        this.activeIds = this.activeIdsStack.pop();
    }
    clear(label = '') {
        this.activeIds = [];
    }
    reserve(count, label, multiarray, data) {
        const id = this.getNextId();
        for (let rindex = 0; rindex < count; ++rindex) {
            const index = id + rindex;
            const _label = label + (multiarray ? multiarray.offsetToIndexesString(rindex) : '');
            const initialValue = this.const ? null : this.getEmptyValue(index, {...data, label: _label});
            this.globalValues[index] = initialValue;
            this.activeIds.push(index);
            if (initialValue !== null) {
                initialValue.sourceRef = Context.sourceRef;
            }
            if (this.debug) {
                console.log(`INIT ${this.constructor.name}.${this.type} @${index} (${rindex}) ${this.globalValues[index]} LABEL:${label}`);
            }
        }
        if (label) {
            this.labelRanges.define(label, id, multiarray);
        }
        return id;
    }
    isDefined(id) {
        return (typeof this.globalValues[id] !== 'undefined' && (!this.const || this.globalValues[id] !== null));
    }

    define(id, value) {
        if (this.isDefined(id)) {
            throw new Error(`${id} already defined on ....`)
        }
        this.set(id, value);
    }
    getLastId() {
        return this.globalValues.length === 0 ? false : this.globalValues.length - 1;
    }
    getNextId() {
        return this.globalValues.length;
    }
    set(id, value) {
        const defined = this.isDefined(id);
        if (defined && this.const) {
            throw new Error(`Invalid assignation at ${Context.sourceRef} to const indexable element [${id}]`);
        }
        if (!defined && this.const) {
            this.globalValues[id] = value;
            return;
        }
        const item = this.get(id);
        if (assert.isEnabled) assert.ok(item, {type: this.type, definition: this.definitionClass, id, item});
        if (typeof item.setValue !== 'function') {
            throw new Error(`Invalid assignation at ${Context.sourceRef}`);
        }
        item.setValue(value);
        if (this.debug) {
            console.log(`SET ${this.constructor.name}.${this.type} @${id} ${value}`);
        }
    }

    unset(id) {
        throw new Error('Unset method is not implemented for GlobalIndexable');
    }

    *[Symbol.iterator]() {
        for (let index = 0; index < this.activeIds.length; ++index) {
          yield this.get(this.activeIds[index]);
        }
    }
    getValues() {
        return this.activeIds.map(id => this.globalValues[id]);
    }
    *values() {
        for (let index = 0; index < this.activeIds.length; ++index) {
          yield this.globalValues[this.activeIds[index]];
        }
    }
    *keyValues() {
        for (let index = 0; index < this.activeIds.length; ++index) {
            yield [this.activeIds[index], this.globalValues[this.activeIds[index]]];
        }
    }
    dump () {
        console.log(`DUMP ${this.type} #:${this.globalValues.length}`);
        for (let index = 0; index < this.globalValues.length; ++index) {
            const value = this.globalValues[index];
            console.log(`${index}: ${this.globalValues[index]}`);
        }
    }
    countByProperty(property) {
        let res = {};
        for (let index = 0; index < this.activeIds.length; ++index) {
            const value = this.get(this.activeIds[index]);
            const key = value[property];
            res[key] = (res[key] ?? 0) + 1;
        }
        return res;
    }
    getPropertyValues(property) {
        let res = [];
        let isArray = Array.isArray(property);
        const properties = isArray ? property : [property];
        for (let index = 0; index < this.activeIds.length; ++index) {
            let value;
            let pvalues = [];
            for (const _property of properties) {
                const definition = this.get(this.activeIds[index]);
                if (Debug.active) console.log(definition);
                value = _property === 'id' ? definition.id ?? index : definition[_property];
                if (isArray) {
                    pvalues.push(value);
                }
            }
            res.push(isArray ? pvalues : value);
        }
        return res;
    }
    getPropertiesString(properties, options = {}) {
        let res = [];
        for (let index = 0; index < this.activeIds.length; ++index) {
            const definition = this.get(this.activeIds[index]);
            let propValues = [];
            for (const property of properties) {
                propValues.push(definition[property] ?? '');
            }
            res.push(this.getLabel(this.activeIds[index])+'@'+this.activeIds[index]+':'+propValues.join(','));
        }
        return res.join('#');
    }
    getLabelRanges() {
        let res = [];
        for (const range of this.labelRanges) {
            const from = range.from;
            if (!this.activeIds.includes(from)) continue;
            res.push(range);
        }
        return res;
    }
}
