const Function = require("../function.js");
const Context = require('../context.js');
const ExpressionItems = require('../expression_items.js')

module.exports = class Assert extends Function {
    constructor (parent) {
        super(parent, {name: 'assert'});
    }
    mapArguments(s) {
        if (s.args.length < 1 || s.args.length > 2) {
            throw new Error('Invalid number of parameters');
        }
        const sourceRef = Context.sourceRef;
        const arg0 = s.args[0].asBool();
        if (!arg0) {
            const msg = (s.args[1] ? s.args[1].toString() + '\n' : '') + `Assert fails ${arg0} at ${sourceRef}`;
            if (Context.tests.active) {
                Context.tests.fail += 1;
                Context.tests.msgs.push(msg);
            } else {
                throw new Error(msg);
            }
        } else if (Context.tests.active) {
            Context.tests.ok += 1;
        }
        return new ExpressionItems.IntValue(0n);
    }
    exec(s, mapInfo) {
        return mapInfo;
    }
}
