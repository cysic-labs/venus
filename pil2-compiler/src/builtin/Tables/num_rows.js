const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const FixedCol = require('../../expression_items/fixed_col.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const assert = require('../../assert.js');

// Tables.num_rows(src)

module.exports = class NumRows extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.num_rows'});
    }
    mapArguments(s) {
        if (s.args.length !== 1) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        const src = s.args[0].eval().getAlone();
        if (!(src instanceof FixedCol)) {
            throw new Error('Source must be a single fixed column');
        }
        return new IntValue(src.getRowCount());
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
