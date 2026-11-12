const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const FixedCol = require('../../expression_items/fixed_col.js');
const assert = require('../../assert.js');

// Tables.is_constant(dst, offset, count)

module.exports = class IsConstant extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.is_constant'});
    }
    mapArguments(s) {
        if (s.args.length > 3 || s.args.length < 1) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        const src = s.args[0].eval().getAlone();

        if (src === false || !(src instanceof FixedCol)) {
            throw new Error('Destination must be single fixed columns');
        }

        const offset = s.args.length > 1 ? ExpressionItem.value2bint(s.args[1]) : 0n;
        const count = s.args.length > 2 ? ExpressionItem.value2bint(s.args[2]) : BigInt(src.getRowCount()) - offset;

        return new IntValue(src.isConstantRange(offset, count) ? 1n : 0n);
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
