const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const FixedCol = require('../../expression_items/fixed_col.js');
const assert = require('../../assert.js');

// Tables.is_sequence(dst, offset, count, delta)
//
// Checks that in the range [offset, offset+count) every value equals the
// previous one plus delta (an arithmetic progression).
//   - if offset is omitted it defaults to 0
//   - if count is omitted the range extends to the end of the column
//   - if delta is omitted it's inferred from the first two values of the range

module.exports = class IsSequence extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.is_sequence'});
    }
    mapArguments(s) {
        if (s.args.length > 4 || s.args.length < 1) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        const src = s.args[0].eval().getAlone();

        if (src === false || !(src instanceof FixedCol)) {
            throw new Error('Destination must be single fixed columns');
        }

        const offset = s.args.length > 1 ? ExpressionItem.value2bint(s.args[1]) : 0n;
        const count = s.args.length > 2 ? ExpressionItem.value2bint(s.args[2]) : BigInt(src.getRowCount()) - offset;
        const delta = s.args.length > 3 ? ExpressionItem.value2bint(s.args[3]) : undefined;

        return new IntValue(src.isSequenceRange(offset, count, delta) ? 1n : 0n);
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
