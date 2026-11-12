const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const FixedCol = require('../../expression_items/fixed_col.js');
const assert = require('../../assert.js');

// Tables.comparative_signature(src, offset, count)
//
// Returns a signature of the range [offset, offset+count) that is invariant to:
//   * a value shift (delta): the table's minimum is subtracted first
//   * a cyclic row rotation (row_offset): values are aggregated commutatively
// Two tables can be "compatible" (equal up to some row_offset and delta) only if
// their comparative signatures match. A match is a candidate that still has to
// be confirmed row by row (and its row_offset computed).
//   - if offset is omitted it defaults to 0
//   - if count is omitted the range extends to the end of the column

module.exports = class ComparativeSignature extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.comparative_signature'});
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

        return new IntValue(src.comparativeSignature(offset, count));
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
