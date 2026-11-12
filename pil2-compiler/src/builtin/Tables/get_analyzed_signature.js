const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const TableAnalysis = require('../../table_analysis.js');
const assert = require('../../assert.js');

// Tables.get_analyzed_signature(analysis_id)
// Returns the (non-cryptographic) content signature of the analyzed range.

module.exports = class GetAnalyzedSignature extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.get_analyzed_signature'});
    }
    mapArguments(s) {
        if (s.args.length !== 1) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        const analysis = TableAnalysis.get(ExpressionItem.value2bint(s.args[0]));
        return new IntValue(analysis.signature);
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
