const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const FixedCol = require('../../expression_items/fixed_col.js');
const assert = require('../../assert.js');

// Tables.get_value(table, index)
//
// Returns the value stored at row <index> of a fixed column.

module.exports = class GetValue extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.get_value'});
    }
    mapArguments(s) {
        if (s.args.length !== 2) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        const src = s.args[0].eval().getAlone();

        if (src === false || !(src instanceof FixedCol)) {
            throw new Error('Table must be a single fixed column');
        }

        const index = ExpressionItem.value2bint(s.args[1]);
        if (index === false) {
            throw new Error('Invalid index for Tables.get_value');
        }
        const rows = BigInt(src.getRowCount());
        if (index < 0n || index >= rows) {
            throw new Error(`Out-of-bounds on Tables.get_value, row ${index} of a fixed column with ${rows} rows at ${Context.sourceRef}`);
        }

        return new IntValue(src.getValue(Number(index)));
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
