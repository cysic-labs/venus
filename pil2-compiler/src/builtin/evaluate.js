const Function = require("../function.js");
const Context = require('../context.js');
const Expression = require('../expression.js');
const ExpressionItems = require('../expression_items.js');
const Exceptions = require('../exceptions.js');
const { map } = require("lodash");

module.exports = class Evaluate extends Function {
    constructor (parent) {
        super(parent, {name: 'evaluate'});
    }
    mapArguments(s) {
        if (s.args.length !== 2) {
            throw new Error('Invalid number of parameters for evaluate, expected 2 (row, expression), got ' + s.args.length);
        }
        let row = false;
        const arg0 = s.args[0];
        if (typeof arg0 === 'number' || arg0 instanceof BigInt) {
            row = arg0;
        } else if (typeof arg0.asInt === 'function') {
            row = arg0.asInt();
        } else {
            console.log(arg0);
            throw new Exceptions.Runtime('First argument of evaluate must be a number');
        }
        return s.args[1].eval({evaluateRow: Number(arg0), unroll: true, instance: true});
    }
    exec(s, mapInfo) {
        return mapInfo;
    }
}
