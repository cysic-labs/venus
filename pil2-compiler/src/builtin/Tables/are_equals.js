const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const FixedCol = require('../../expression_items/fixed_col.js');
const assert = require('../../assert.js');

// Tables.are_equals(src1, offset1, src2, offset2, count)
//
// Returns 1 if src1[offset1 .. offset1+count) equals src2[offset2 .. offset2+count)
// value by value (over the raw stored values), 0 otherwise.
//   - if count is omitted both windows extend to the end of their column; if the
//     remaining lengths differ the windows are simply not equal (returns 0).
//   - an explicit count that exceeds either column is an error.

module.exports = class AreEquals extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.are_equals'});
    }
    mapArguments(s) {
        if (s.args.length < 4 || s.args.length > 5) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        assert.instanceOf(s.args[2], Expression);
        const src1 = s.args[0].eval().getAlone();
        const offset1 = ExpressionItem.value2bint(s.args[1]);
        const src2 = s.args[2].eval().getAlone();
        const offset2 = ExpressionItem.value2bint(s.args[3]);

        if (src1 === false || src2 === false || !(src1 instanceof FixedCol) || !(src2 instanceof FixedCol)) {
            throw new Error('Both sources must be single fixed columns');
        }

        let count;
        if (s.args.length > 4) {
            count = ExpressionItem.value2bint(s.args[4]);
        } else {
            // default: compare the remaining of both columns; different
            // remaining lengths mean the windows are simply not equal
            count = BigInt(src1.getRowCount()) - offset1;
            if (BigInt(src2.getRowCount()) - offset2 !== count) {
                return new IntValue(0n);
            }
        }

        return new IntValue(src1.areEquals(src2, offset1, offset2, count) ? 1n : 0n);
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
