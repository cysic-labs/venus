const util = require('util');
const {cloneDeep} = require('lodash');
const {FlowAbortCmd, BreakCmd, ContinueCmd, ReturnCmd} = require("./flow_cmd.js");
const Expression = require("./expression.js");
const ExpressionItems = require("./expression_items.js");
const List = require("./list.js");
const Context = require('./context.js');
const Debug = require('./debug.js');
const Types = require('./types.js');
const {ArrayOf} = require('./expression_items.js')
const assert = require('./assert.js');
module.exports = class Function {
    constructor (id, data = {}) {
        this.id = id;
        this.initialized = [data.args, data.returns, data.statements, data.name].some(x => typeof x !== 'undefined');
        this.name = data.name;
        this.creationScope = data.creationScope ?? [];
        this.nargs = 0;
        
        if (data.args) {
            this.defineArguments(data.args);
        } else {
            this.argnames = [];
        }
        this.returns = data.returns ?? []
        this.statements = data.statements ?? [];
        this.sourceRef = data.sourceRef;
        this.isBridge = false;
        this.isVirtualizable = false;
        this.package = data.package ?? false;  
    }
    setValue(value) {
        if (Debug.active) {
            console.log(`FUNCTION.setValue ${value.name}`, value.args);
        }
        if (this.initialized) {
            throw new Error(`function it's initialized again`);
        }
        if (value instanceof Function === false) {
            throw new Error(`Invalid value to setValue of function`);
        }
        this.initialized = value.initialized;
        this.name = value.name;
        // TODO: clone return types
        this.args = {...value.args};
        if (Debug.active) {
            console.log(`FUNCTION.setValue2 ${value.name}`, this.args);
        }
        this.returns = value.returns && Array.isArray(value.returns) ? [...value.returns] : value.returns;
        this.statements = value.statements;
    }
    defineArguments(args) {        
        this.args = {};
        let iarg = 0;
        for (const arg of args) {
            const name = arg.name;
            if (name === '') throw new Error('Invalid argument name');
            if (name in this.args) throw new Error(`Duplicated argument ${name}`);

            // default values must be defined when define function
            const defaultValue = typeof arg.defaultValue === 'undefined' ? arg.defaultValue : arg.defaultValue.instance();
            this.args[name] = {type: arg.type, dim: arg.dim, defaultValue, index: iarg};
            ++iarg;
        }
        this.nargs = iarg;
        this.argnames = Object.keys(this.args);
    }
    checkNumberOfArguments(args) {
        if (this.nargs === false) return;
        const argslen = args.length ?? 0;
        if (argslen < this.nargs) {
            console.log(this.args);
            throw new Error(`Invalid number of arguments calling ${this.name} function, called with ${argslen} arguments, but defined with ${this.nargs} arguments at ${Context.sourceRef}`);
        }
    }
    // instance all called arguments on call scope before
    // scope changes. Instance, not evaluate because arguments become from compiler
    buildCallArguments(args, namedargs = []) {
        let eargs = [];
        let argslen = args.length ?? 0;
        let _namedargs = [];
        let iarg = 0;

        // loop for first non namedargs
        while (iarg < argslen && (namedargs[iarg] === false || typeof namedargs[iarg] === 'undefined')) {
            // instance when check type
            eargs.push(args[iarg]);
            _namedargs.push(false);
            ++iarg;
        }
        // how many first n arguments are indexed-args, they aren't namedargs.
        const indexedArgs = iarg;

        // console.log(iarg, namedargs, args);
        while (iarg < argslen) {
            const name = namedargs[iarg] ?? false;
            if (name === false) {
                throw new Error(`Used a non-namedarg on position #${iarg} calling ${this.name}`);
            }
            const arg = this.args[name];
            if (typeof arg === 'undefined') {
                throw new Error(`Not found argument named ${name} on position #${iarg} calling ${this.name}`);                
            }
            if (arg.index < indexedArgs) {
                throw new Error(`Argument ${name} on position #${iarg} is called with and without name calling ${this.name}`);                
            }
            if (typeof _namedargs[arg.index] !== 'undefined') {
                throw new Error(`Argument ${name} is used more than once (position #${iarg}) calling ${this.name}`);                
            }
            _namedargs[arg.index] = name;
            eargs[arg.index] = args[iarg];
            ++iarg;
        }
        return [_namedargs, eargs];
    }
    // mapArgument was called before enter on function visibility scope because
    // inside function args "values" aren't visible.
    mapArguments(s) {
        const [namedargs, eargs] = this.buildCallArguments(s.args, s.namedargs);
        const scall = this.callToString(namedargs, eargs);
        this.instanceArgumentsTypes(eargs);
        return {eargs, scall};
    }
    // calculate a string to debug, with function name and list of arguments
    // with its values
    callToString(namedargs, eargs) {
        let textArgs = [];
        for (let iarg = 0; iarg < eargs.length; ++iarg) {
            const namedarg = namedargs[iarg] ?? false;
            const value = eargs[iarg];
            textArgs.push((namedarg !== false ? `${namedarg}:` : '') + ((value && typeof value.toString === 'function') ? value.toString():''));
        }
        return this.name + '(' + textArgs.join(', ') + ')';
    }

    // to instance and check arguments used in call, checks if its types and dimensions match with
    // the arguments defined on function
    instanceArgumentsTypes(eargs) {
        for (let iarg = 0; iarg < eargs.length; ++iarg) {
            // default values are ignored
            if (typeof eargs[iarg] === 'undefined') continue;
            eargs[iarg] = eargs[iarg].instance({unroll: true});
            // TODO: checking types and dims
            /*
            if (Array.isArray(args[iarg])) {
                for (const arg of args[iarg]) {
                    arg.dump();
                }
            } else {
                args[iarg].dump();
            }*/
        }
    }
    declareAndInitializeArguments(eargs) {        
        // Context.processor.sourceRef = this.sourceRef;
        let iarg = 0;
        Context.initializingFunctionCall = true;
        for (const name in this.args) {
            if (typeof eargs[iarg] === 'undefined') {
                if (typeof this.args[name].defaultValue === 'undefined') { 
                    throw new Error(`Argument ${name} without default value isn't specified in call of function ${this.name}`);
                }
                this.setDefaultArgument(name);
            } else {
                this.setArgument(name, eargs[iarg]);
            }
            ++iarg;
        }
        Context.initializingFunctionCall = false;
    }
    setDefaultArgument(name) {
        this.setArgument(name, this.args[name].defaultValue);
    }
    setArgument(name, value) {
        const arg = this.args[name];
        if (Debug.active) {
            console.log(name);
            console.log(arg);
            console.log(value.dim);
            let values = Array.isArray(value) ? value : [value];
            for (const v of values) {
                if (typeof v.dump === 'function') v.dump(`${this.name}(...${name}...) ${Context.sourceRef}`);
                else console.log(v);
            }
        }
        if (typeof value === 'undefined') { 
            throw new Error(`Invalid value for argument ${name} on function ${this.name}`);
        }
        if (value instanceof Expression && value.isAlone()) {
            value = value.getAloneOperand();
        }
        let lengths = [];
        if (value.array) {            
            lengths = value.array.lengths;
        } else if (Array.isArray(value)) {
            lengths = [];
            let values = value;
            // TODO: happy path implementation
            while (values.length) {            
                lengths.push(values.length);
                values = values[0];
            }
        }

        // REVIEW: use arg.type, but perphaps we need to do a casting
        if (lengths.length !== arg.dim) {        
            console.log(arg);
            console.log(value.dim);
            throw new Error(`Invalid match dimensions on call ${this.name} and parameter ${name} (${lengths.length} !== ${arg.dim})`);
        }
        this.declareArgument(name, arg.type, lengths, {sourceRef: Context.sourceRef}, value);
        return false;
    }
    declareArgument(name, type, lengths, options, value) {
        Context.references.declare(name, type, lengths, options, value);
    }
    exec(callInfo, mapInfo) {
        this.declareAndInitializeArguments(mapInfo.eargs);
        if (Debug.active) console.log(Context.constructor.name);
        let res = Context.processor.execute(this.statements, `FUNCTION ${this.name}`);
        if (res instanceof FlowAbortCmd) {
            if (!(res instanceof ReturnCmd)) {
                throw new Error(`Invalid type of flow-abort ${res.constructor.name} as function return at ${res.sourceRef}`);
            }   
            Context.processor.traceLog('[TRACE-BROKE-RETURN]', '38;5;75;48;5;16');
            res = res.reset();
        }
        return res === false ? new ExpressionItems.IntValue(0) : res;
    }
    toString() {
        return `[Function ${this.name}${this.args ? '(' + Object.keys(this.args).join(',') + ')': ''}]`;
    }
}
