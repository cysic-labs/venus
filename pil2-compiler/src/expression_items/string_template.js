const RuntimeItem = require("./runtime_item.js");
const StringValue = require("./string_value.js");
const Context = require('../context.js');
const assert = require('../assert.js');
class StringTemplate extends StringValue {
    constructor (value = '') {
        assert.typeOf(value, 'string');
        super(value);
    }
    evalTemplate(options) {
        return new StringValue(Context.processor.evaluateTemplate(this.value, options));
    }
    cloneInstance() {
        return new StringTemplate(this.value);
    }
    dump(options) {
        return '`'+this.value+'`';
    }
    toString(options) {
        return this.evalTemplate(options);
    }
    getValue() {
        return this.evalTemplate();
    }
    asString() {
        return this.asStringItem().value;
    }
    asStringItem() {
        return this.evalTemplate();
    }
    evalInside(options = {}) {
        return this.evalTemplate(options);
    }
}

RuntimeItem.registerClass('StringTemplate', StringTemplate);
module.exports = StringTemplate;
