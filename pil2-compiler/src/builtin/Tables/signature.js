const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const FixedCol = require('../../expression_items/fixed_col.js');
const assert = require('../../assert.js');

// Tables.signature(dst, offset, count)
//
// Returns a non-cryptographic 64-bit hash of the raw values in the range
// [offset, offset+count). It's meant to cheaply compare two tables: equal
// ranges produce the same signature; different ranges almost certainly don't.
//   - if offset is omitted it defaults to 0
//   - if count is omitted the range extends to the end of the column

module.exports = class Signature extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.signature'});
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

        return new IntValue(src.signature(offset, count));
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
