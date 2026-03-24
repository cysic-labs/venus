const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const FixedCol = require('../../expression_items/fixed_col.js');
const assert = require('../../assert.js');

// Tables.copy(src, src_offset, dst, dst_offset, count)

module.exports = class Copy extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.copy'});
    }
    mapArguments(s) {
        if (s.args.length < 4 || s.args.length > 5) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        assert.instanceOf(s.args[1], Expression);
        const src = s.args[0].eval().getAlone();
        const src_offset = ExpressionItem.value2bint(s.args[1]);
        const dst = s.args[2].eval().getAlone();
        const dst_offset = ExpressionItem.value2bint(s.args[3]);
        const count = ExpressionItem.value2bint(s.args[4]);

        if (src === false || dst === false || !(src instanceof FixedCol) || !(dst instanceof FixedCol)) {
            throw new Error('Source and destination must be single fixed columns');
        }    
        return new IntValue(dst.copyRowsFrom(src, src_offset, dst_offset, count));
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
