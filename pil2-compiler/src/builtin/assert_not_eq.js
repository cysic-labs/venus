const Function = require("../function.js");
const Expression = require('../expression.js');
const Context = require('../context.js');
const IntValue = require('../expression_items/int_value.js');
const assert = require('../assert.js');

module.exports = class AssertNotEq extends Function {
    constructor (parent) {
        super(parent, {name: 'assert_not_eq'});
    }
    mapArguments(s) {
        if (s.args.length !== 2) {
            throw new Error('Invalid number of parameters');
        }
        const sourceRef = Context.sourceRef;
        assert.instanceOf(s.args[0], Expression);
        assert.instanceOf(s.args[1], Expression);
        const arg0 = s.args[0].eval();
        const arg1 = s.args[1].eval();
        if (arg0.equals(arg1)) {

            const msg = (s.args[2] ? s.args[2].toString() + '\n' : '') + `Assert fails (${arg0} !== ${arg1}) at ${sourceRef}`;
            if (Context.tests.active) {
                Context.tests.fail += 1;
                Context.tests.msgs.push(msg);
            } else {
                throw new Error(msg);
            }
        } else if (Context.tests.active) {
            Context.tests.ok += 1;
        }
        return 0n;
    }
    exec(s, mapInfo) {
        return new IntValue(mapInfo);
    }

}
