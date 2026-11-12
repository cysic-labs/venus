const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const TableAnalysis = require('../../table_analysis.js');
const assert = require('../../assert.js');

// Tables.get_analyzed_bits(analysis_id)
// Returns the number of bits needed to represent every analyzed value.
// If the values are signed (min < 0) the returned bit count is negative.

module.exports = class GetAnalyzedBits extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.get_analyzed_bits'});
    }
    mapArguments(s) {
        if (s.args.length !== 1) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        const analysis = TableAnalysis.get(ExpressionItem.value2bint(s.args[0]));
        return new IntValue(analysis.bits);
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
