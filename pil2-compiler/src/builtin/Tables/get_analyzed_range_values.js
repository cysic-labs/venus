const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const TableAnalysis = require('../../table_analysis.js');
const assert = require('../../assert.js');

// Tables.get_analyzed_range_values(analysis_id) -> int[2] = [min, max]

module.exports = class GetAnalyzedRangeValues extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.get_analyzed_range_values'});
    }
    mapArguments(s) {
        if (s.args.length !== 1) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        const analysis = TableAnalysis.get(ExpressionItem.value2bint(s.args[0]));
        return TableAnalysis.intArrayValue(analysis.getRangeValues());
    }
    exec(s, mapInfo) {
        return mapInfo;
    }
}
