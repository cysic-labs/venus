const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const FixedCol = require('../../expression_items/fixed_col.js');
const assert = require('../../assert.js');

// Tables.fill(value, dst, offset, count)

module.exports = class Fill extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.fill'});
    }
    mapArguments(s) {
        if (s.args.length != 4) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        assert.instanceOf(s.args[1], Expression);
        const value = ExpressionItem.value2bint(s.args[0]);
        const dst = s.args[1].eval().getAlone();
        const offset = ExpressionItem.value2bint(s.args[2]);
        const count = ExpressionItem.value2bint(s.args[3]);

        if (dst === false || !(dst instanceof FixedCol)) {
            throw new Error('Destination must be single fixed columns');
        }    
        return new IntValue(dst.fillRowsFrom(value, offset, count));
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
