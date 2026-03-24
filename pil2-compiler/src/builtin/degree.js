const Function = require("../function.js");
const Context = require('../context.js');
const Expression = require('../expression.js');
const ExpressionItems = require('../expression_items.js');
const { map } = require("lodash");

module.exports = class Degree extends Function {
    constructor (parent) {
        super(parent, {name: 'degree'});
    }
    exec(s, mapInfo) {
        if (typeof mapInfo.eargs[0].degree === 'number') {
            return new ExpressionItems.IntValue(mapInfo.eargs[0].degree);
        }
        return new ExpressionItems.IntValue(-1);
    }
}
