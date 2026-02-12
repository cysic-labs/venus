const Function = require("../function.js");
const StringValue = require('../expression_items/string_value.js');
const IntValue = require('../expression_items/int_value.js');
const util = require('util');
module.exports = class Dim extends Function {
    constructor (parent) {
        super(parent, {name: 'dim'});
    }
    mapArguments(s) {
        if (s.args.length !== 1) {
            throw new Error('Invalid number of parameters');
        }
        const arg0 = s.args[0];
        const item = arg0.evalAsItem();
        if (item instanceof StringValue) {
            return {result: BigInt(1)};
        }
        if (item && item.array) {
            return {result: item.array ? BigInt(item.array.getDim(0)) : 0n};
        }
        return {result: 0n};
    }
    exec(s, mapInfo) {
        const res = new IntValue(mapInfo.result);
        return res;
    }
}
