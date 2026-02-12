const Function = require("../../function.js");
const Expression = require('../../expression.js');
const Context = require('../../context.js');
const IntValue = require('../../expression_items/int_value.js');
const ExpressionItem = require('../../expression_items/expression_item.js');
const assert = require('../../assert.js');

// Tables.print_rows(src, from, count)

module.exports = class Print extends Function {
    constructor (parent) {
        super(parent, {name: 'Tables.print'});
    }
    mapArguments(s) {
        if (s.args.length != 3) {
            throw new Error('Invalid number of parameters');
        }
        const src = s.args[0].eval().getAlone();
        const offset = ExpressionItem.value2bint(s.args[1]);
        const count = ExpressionItem.value2bint(s.args[2]);

        if (src === false) {
            throw new Error('Source must be a single fixed column');
        }
        
        return new IntValue(src.printRowsFrom(offset, count));
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }
}
