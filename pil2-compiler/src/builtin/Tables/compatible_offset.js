const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const FixedCol = require('../../expression_items/fixed_col.js');
const assert = require('../../assert.js');

// Tables.compatible_offset(src1, offset1, src2, offset2, count)
//
// Returns the row_offset r that makes src2 a shifted copy of src1, or -1 if
// they are not compatible. When r >= 0:
//     src2[offset2 + i] == src1[offset1 + ((i + r) mod count)] + delta
// so the caller can recover delta trivially:
//     delta = src2[offset2] - src1[offset1 + r]
// The comparison is done on the raw stored values (a constant value shift is
// cancelled internally by subtracting each window's minimum).
//   - if count is omitted it extends to the end of src1 (src1.rows - offset1)

module.exports = class CompatibleOffset extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.compatible_offset'});
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

        const count = s.args.length > 4 ? ExpressionItem.value2bint(s.args[4]) : BigInt(src1.getRowCount()) - offset1;

        return new IntValue(src1.compatibleOffset(src2, offset1, offset2, count));
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
