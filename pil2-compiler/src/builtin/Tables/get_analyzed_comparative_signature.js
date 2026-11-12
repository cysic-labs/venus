const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const TableAnalysis = require('../../table_analysis.js');
const assert = require('../../assert.js');

// Tables.get_analyzed_comparative_signature(analysis_id)
// Returns the comparative signature of the analyzed range: a signature that is
// invariant to a value shift (delta) and to a cyclic row rotation (row_offset).
// Same value as Tables.comparative_signature() over the same range, but taken
// from the single analysis pass.

module.exports = class GetAnalyzedComparativeSignature extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.get_analyzed_comparative_signature'});
    }
    mapArguments(s) {
        if (s.args.length !== 1) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        const analysis = TableAnalysis.get(ExpressionItem.value2bint(s.args[0]));
        return new IntValue(analysis.comparativeSignature);
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
