const Function = require("../function.js");
const MultiArray = require("../multi_array.js");
const {IntValue} = require('../expression_items.js');
const Exceptions = require('../exceptions.js');
const Context = require('../context.js');

module.exports = class Defined extends Function {
    constructor (parent) {
        super(parent, {name: 'defined'});
    }
    mapArguments(s) {
        if (s.args.length !== 1) {
            throw new Error('Invalid number of parameters');
        }
        const arg0 = s.args[0];
        let value = false;
        try {
            const reference = arg0.reference;
            if (reference) {
                value = Context.references.isContainerDefined(Context.applyTemplates(reference.name));
            } 
            if (!value && arg0) {
                value = arg0.eval();
            }
        } catch (e) {
            if (e instanceof Exceptions.ReferenceNotFound || e instanceof Exceptions.ReferenceNotVisible) {
                // this case need when defined is called for a container
            } else if (e instanceof Exceptions.OutOfDims || e instanceof Exceptions.OutOfBounds) {                
                value = false;
            }
        }
        const res = new IntValue(value !== false ? 1n : 0n);
        return res;
    }
    exec(s, mapInfo) {
        return mapInfo;
    }
}
