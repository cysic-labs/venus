const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const FixedCol = require('../../expression_items/fixed_col.js');
const TableAnalysis = require('../../table_analysis.js');
const assert = require('../../assert.js');

// Tables.analyze(table, offset, count)
//
// Analyzes a fixed column range in a single pass and returns an analysis id.
// The id is passed to the get_analyzed_* builtins to read the results.
//   - if offset is omitted it defaults to 0
//   - if count is omitted the range extends to the end of the column

module.exports = class Analyze extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.analyze'});
    }
    mapArguments(s) {
        if (s.args.length > 3 || s.args.length < 1) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        const src = s.args[0].eval().getAlone();

        if (src === false || !(src instanceof FixedCol)) {
            throw new Error('Table must be a single fixed column');
        }

        const offset = s.args.length > 1 ? ExpressionItem.value2bint(s.args[1]) : 0n;
        const count = s.args.length > 2 ? ExpressionItem.value2bint(s.args[2]) : BigInt(src.getRowCount()) - offset;

        const analysis = src.analyze(offset, count);
        return new IntValue(TableAnalysis.register(analysis));
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
