const util = require('util');
const {FlowAbortCmd, BreakCmd, ContinueCmd, ReturnCmd} = require("./flow_cmd.js");
const Expression = require("./expression.js");
const ExpressionItems = require("./expression_items.js");
const Function = require("./function.js");
const Context = require('./context.js');
const Debug = require('./debug.js');

module.exports = class AirTemplateFunction extends Function {
    constructor (id, data = {}) {
        super(id, data);
        this.airTemplate = data.instance;
        this.isBridge = true;
        this.isVirtualizable = false;
    }
    prepare(callInfo, mapInfo) {
        this.declareAndInitializeArguments(mapInfo.eargs);
    }

    exec(callInfo, mapInfo = {}, options = {}) {
        const res = Context.processor.executeAirTemplate(this.airTemplate, this, callInfo, options);
        return res === false ? new ExpressionItems.IntValue(0) : res;
    }    
    declareArgument(name, type, lengths, options, value) {
        if (name !== 'N') {
            return super.declareArgument(name, type, lengths, options, value);
        }
        Context.references.set('N', [], value);
    }
    toString() {
        return `[airgroup(func) ${this.name}${this.args ? '(' + Object.keys(this.args).join(',') + ')': ''}]`;
    }
}
