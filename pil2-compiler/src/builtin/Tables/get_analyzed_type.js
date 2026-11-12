const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const TableAnalysis = require('../../table_analysis.js');
const assert = require('../../assert.js');

// Tables.get_analyzed_type(analysis_id)
// Returns the detected pattern type:
//   0: nothing, 1: constant, 2: sequential, 3: constant-partitions, 4: cycle

module.exports = class GetAnalyzedType extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.get_analyzed_type'});
    }
    mapArguments(s) {
        if (s.args.length !== 1) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        const analysis = TableAnalysis.get(ExpressionItem.value2bint(s.args[0]));
        return new IntValue(BigInt(analysis.type));
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
