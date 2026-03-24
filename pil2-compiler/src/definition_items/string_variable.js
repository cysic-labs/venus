const Variable = require("./variable.js");
const StringValueItem = require("../expression_items/string_value.js");
const assert = require('../assert.js');

class StringVariable extends Variable {
    constructor (id, properties) {
        super(id, properties);
        const value = properties.value ?? '';
        assert.typeOf(value, 'string');
        this.value = value;
    }
    getValue() {
        return this.value;
    }
    setValue(value) {
        if (typeof value.asString === 'function') {
            value = value.asString();
        }
        assert.typeOf(value, 'string');
        this.value = value;
        return this.value;
    }
    clone() {
        let cloned = new StringValue(this.id);
        this.cloneProperties(cloned);
    }
    cloneProperties(cloned) {
        super.cloneProperties(cloned);
        cloned.value = this.value;
    }
    getItem() {
        return new StringValueItem(this.value);
    }
}

module.exports = StringVariable;