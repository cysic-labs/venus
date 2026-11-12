const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const TableAnalysis = require('../../table_analysis.js');
const assert = require('../../assert.js');

// Tables.get_analyzed_partitions(analysis_id)
// Returns the constant of each partition, compacted to the minimum number of
// uniform partitions (partitions are computed on 2^16 chunks, then merged while
// adjacent partitions share the same constant). Only valid for type 3.

module.exports = class GetAnalyzedPartitions extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.get_analyzed_partitions'});
    }
    mapArguments(s) {
        if (s.args.length !== 1) {
            throw new Error('Invalid number of parameters');
        }
        assert.instanceOf(s.args[0], Expression);
        const analysis = TableAnalysis.get(ExpressionItem.value2bint(s.args[0]));
        return TableAnalysis.intArrayValue(analysis.getPartitions());
    }
    exec(s, mapInfo) {
        return mapInfo;
    }
}
