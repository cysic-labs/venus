const Function = require("../function.js");
const IntValue = require('../expression_items/int_value.js');
const Context = require('../context.js');
module.exports = class Println extends Function {
    constructor (parent) {
        super(parent, {name: 'println', args: [], returns: [] });
        this.nargs = false;
    }
    exec(s, mapInfo) {
        const source = Context.config.printlnLines ? '['+Context.sourceTag+'] ':'';
        const spaces = Context.scope.getInstanceType() === 'proof' ? '': '  ';
        console.log(`\x1B[36m${spaces}> ${source}${mapInfo.eargs.join(' ')}\x1B[0m`);
        return new IntValue(0);
    }
}
