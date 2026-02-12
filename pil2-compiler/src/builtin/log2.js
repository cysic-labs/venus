const Function = require("../function.js");
const IntValue = require('../expression_items/int_value.js');

module.exports = class Log2 extends Function {
    constructor (parent) {
        super(parent, {name: 'log2'});
    }
    mapArguments(s) {
        if (s.args.length !== 1) {
            throw new Error('Invalid number of parameters');
        }
        const arg0 = s.args[0];
        const item = arg0.eval();
        if (!(item instanceof IntValue)) {
            throw new Error(`Invalid type of argument for log2 function. Expected integer but got ${item.getTag()}`);
        }

        if (item.value === 0n) return {result: 0n};

        if (item.value < 0n) item.value = -item.value;

        let result = 0n;
        while (item.value > 1n) {
            item.value >>= 1n;
            result++;
        }

        return {result};
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo.result);
    }
}
