const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const TableAnalysis = require('../../table_analysis.js');
const assert = require('../../assert.js');

// Tables.get_analyzed_params(analysis_id)
// Returns the minimal parameters that describe the detected pattern:
//   type 1 (constant):   [constant_value]
//   type 2 (sequential): [first_value, delta]
//   type 4 (cycle):      [first_element]
// Errors for type 0 (nothing) and type 3 (constant-partitions).

module.exports = class GetAnalyzedParams extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.get_analyzed_params'});
    }
    mapArguments(s) {
        if (s.args.length !== 1) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        const analysis = TableAnalysis.get(ExpressionItem.value2bint(s.args[0]));
        return TableAnalysis.intArrayValue(analysis.getParameters());
    }
    exec(s, mapInfo) {
        return mapInfo;
    }
}
