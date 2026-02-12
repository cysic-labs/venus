const assert = require('../assert.js');
const RuntimeItem = require("./runtime_item.js");
class StringValue extends RuntimeItem {
    constructor (value = '') {
        super();
        assert.typeOf(value, 'string');
        this.value = value;
    }
    get isString() {
        return true;
    }
    get isBaseType () {
        return true;
    }
    toString(options) {
        return this.value;
    }
    dump(options) {
        return '"'+this.value+'"';
    }
    getValue() {
        return this.value;
    }
    setValue(value) {
        assert.typeOf(value, 'string');
        this.value = value;
        return this.value;
    }    
    asString() {
        return this.value;
    }
    asStringItem() {
        return this.clone();
    }
    asBool() {
        return this.value !== "";
    }
    cloneInstance() {
        return new StringValue(this.value);
    }
    operatorEq(valueB) {
        return new RuntimeItem.IntValue(this.asString() === valueB.asString() ? 1:0);
    }
    operatorNe(valueB) {
        return new RuntimeItem.IntValue(this.asString() === valueB.asString() ? 0:1);
    }
    operatorAdd(valueB) {
        return new StringValue(this.asString() + valueB.asString());
    }
    evalInside(options = {}) {
        return this.clone();
    }
    equals(value) {
        return this.constructor.name === value.constructor.name && this.value === value.value;
    }
}

RuntimeItem.registerClass('StringValue', StringValue);
module.exports = StringValue;
