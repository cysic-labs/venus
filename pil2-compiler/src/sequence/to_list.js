const Expression = require("../expression.js");
const Debug = require('../debug.js');
const assert = require('../assert.js');
const Context = require('../context.js');
const SequenceExtend = require('./extend.js');
const ExpressionItems = require('../expression_items.js');

module.exports = class SequenceToList extends SequenceExtend {
    constructor (parent, label, options = {}) {
        super(parent, label, options);
        this.values = [];
    }
    getValues() {
        return this.values;
    }
    pushValue(value) {
        this.values.push(value);
    }
    paddingSeq(e) {
        throw new Error(`Invalid padding inside list`);
    }
    expr(e) {
        if (typeof e === 'bigint' || typeof e === 'number') this.pushValue(new ExpressionItems.IntValue(e));
        else if (e.isExpression) this.pushValue(e.instance());
        else if (e instanceof ExpressionItems.ExpressionItem) this.pushValue(e);
        else {
            console.log(e);
            throw new Error(`Invalid expression inside list`);
        }
    }
}