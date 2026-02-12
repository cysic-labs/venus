const Variable = require("./variable.js");
const ExpressionItem = require('../expression_items/int_value.js');
const Debug = require('../debug.js');
const assert = require('../assert.js');

class IntVariable extends Variable {

    constructor (value = 0n, options) {
        if (typeof value === 'object' && typeof value.asInt === 'function') {
            value = value.asInt();
        }
        if (typeof value === 'number') {
            value = BigInt(value);
        }
        assert.typeOf(value, 'bigint');
        super(value, options);
    }
    setValue(value) {
        if (Debug.active) console.log(value);
        if (typeof value.asInt === 'function') {
            value = value.asInt();
        }
        if (typeof value === 'number') {
            value = BigInt(value);
        }
        if (typeof value !== 'bigint') {
            throw new Error(`invalid type on integer assignation of ${value} to ${this.label}`);
        }
        super.setValue(value);
    }
    clone() {
        return new IntValue(this.value);
    }
    static castTo(value) {
        if (value instanceof IntValue) {
            return value.value;
        }
    }
    getItem() {
        return new ExpressionItem(this.value);
    }
    asInt() {
        return this.value;
    }
    asNumber() {
        return Number(this.value);
    }
}
module.exports = IntVariable;