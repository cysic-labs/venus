const ExpressionItems = require('./expression_items.js');
const Expression = require('./expression.js');
const Context = require('./context.js');
const utils = require('./utils.js');
const vm = require('node:vm');
const Performance = require('perf_hooks').performance;
const beautify = require('js-beautify').js;
const fs = require('fs');
const units = require('./units.js');

// TODO:
// - scopes calls pop/up for inside variables
// - external functions with limitations, used for built-in and user functions, currently only support error and println
// - dynamic references, to be resolved in transpilation execution
module.exports = class Transpiler {
    constructor(config = {}) {
        this.processor = config.processor;
        this.config = config;
        this.currentScope = {};
        this.scopes = [];
        this.referenceIndex = 0;
        this.context = {error: (msg) => console.log('ERROR: '+msg),
                        println: function () { console.log(...Object.values(arguments));}
                    };
    }
    static dumpCode(code, cond = true) {
        const lines = code.split('\n');
        const nlines = lines.map((line, index) => `\x1B[35m${(index + 1).toString(10).padStart(4,'0')}:\x1B[0m ${line}`);
        console.log(`  > Transpiled code ${Context.sourceTag}`);
        if (cond) {
            console.log('\n'+ nlines.join('\n'));
        }
    }
    transpile(st, options = {}) {
        const logfile = options.logfile ?? false;
        let _log = false;
        if (logfile && Context.config.logFile) {
            const bufsize = options.bufsize ?? 16*1024*1024; // 10MB
            const logfd = fs.openSync(logfile, 'w');
            _log = { size: 0, fd: logfd, bufsize: bufsize, buffer: Buffer.alloc(bufsize), bufpos: 0, logfile };
            this.context._log = _log;
            this.context.fs = fs;
            this.context.log = function () {
                const data = Object.values(arguments).join(' ')+'\n';
                const datalen = data.length;
                if ((_log.bufpos - _log.bufsize) < (datalen + 1024)) {
                    const bytes = fs.writeSync(_log.fd, _log.buffer, 0, _log.bufpos);
                    _log.size += bytes;
                    _log.bufpos = 0;
                }
                const bytes = _log.buffer.write(data, _log.bufpos, 'utf8');
                _log.bufpos += bytes;
            }
        } else {
            this.context.log = (msg) => {};
        }
        this.declared = {};
        const code = this.#transpile(st);
        const _format_code = beautify(code, {wrap_line_length: 160});

        this.constructor.dumpCode(_format_code, Context.config.logTranspile ?? false);

        const t1 = Performance.now();
        vm.createContext(this.context);
        vm.runInContext(options.debug ? _format_code : code, this.context);
        const t2 = Performance.now();
        console.log('  > Traspilation execution time: ' + units.getHumanTime(t2-t1));

        if (_log !== false) {
            if (_log.bufpos > 0) {
                const bytes = fs.writeSync(_log.fd, _log.buffer, 0, _log.bufpos);
                _log.size += bytes;
            }
            fs.closeSync(_log.fd);
            console.log(`  > written ${_log.size} bytes to ${_log.logfile}`);
        }
    }
    #transpile(st) {
        // console.log(st);
        switch(st.type) {
            case 'for': return this.#transpileFor(st);
            case 'break': return this.#transpileBreak(st);
            case 'code': return this.#transpile(st.statements);
            case 'variable_declaration': return this.#transpileVariableDeclaration(st);
            case 'scope_definition': return this.#transpileScopeDefinition(st);
            case 'expr': return this.#transpileExpr(st);
            case 'switch': return this.#transpileSwitchCase(st);
            case 'assign': return this.#transpileAssign(st);
            case 'if': return this.#transpileIf(st);
        }
        throw new Error(`not known how transpile ${st.type}`);
    }
    #transpileBreak(st) {
        return 'break;'
    }
    #transpileIf(st) {
        let code = '';
        let first = true;
        // debugger;
        // console.log(util.inspect(st.conditions, { maxArrayLength: null }));
        // for (const cond of st.conditions) {
        //     console.log(JSON.stringify(cond, (key, value) => typeof value === 'bigint' ? value.toString() : value));
        // }
        for (const cond of st.conditions) {
            if (cond.type === 'if') {
                if (first) code += 'if (';
                else code += ' else if (';
                code += this.#toString(cond.expression) + ')';
            } else if (cond.type === 'else') {
                code += ' else ';
            } else {
                EXIT_HERE;
            }
            code += this.#braces(this.#transpile(cond.statements));
            first = false;
        }
        return code;
    }
    #braces(code) {
        if (code.startsWith('{')) {
            return code;
        }
        return '{'+code+'}';
    }
    #toString(obj, options = {}) {
        return obj.toString({...options, allParentheses: true, intsuffix: 'n', map: (operand, options) => this.#mapping(operand, options)});
    }
    #transpileSwitchCase(st) {
        let code = 'switch ('+this.#toString(st.value)+') {\n';
        let ccases = [];
        for (const _case of st.cases) {
            // console.log(_case);
            if (_case.condition) {
                let cvalues = [];
                for (const cvalue of _case.condition.values) {
                    cvalues.push(this.#toString(cvalue));
                }
                code += '\ncase '+cvalues.join(':\ncase ')+':';
            } else if (_case.default) {
                code += '\ndefault:';
            } else {
                console.log(_case);
                EXIT_HERE;
            }
            code += this.#transpile(_case.statements)+';break;';
        }
        code += '}';
        return code;
    }
    #transpileExpr(st) {
        return this.#toString(st.expr);
    }
    #transpileFor(st) {
        let code = '';
        const inits = Array.isArray(st.init) ? st.init : [st.init];
        const cinits = [];
        for (const init of inits) {
            cinits.push(this.#transpile(init));
        }
        const cincrements = [];
        for (const increment of st.increment) {
            cincrements.push(this.#transpile(increment));
        }
        code += 'for ('+cinits.join()+';'+this.#toString(st.condition)+';'+cincrements.join()+')';
        code += this.#braces(this.#transpile(st.statements));
        return code;
    }
    #transpileVariableDeclaration(st) {
        let code = '';
        if (st.vtype !== 'string' && st.vtype !== 'int') {
            throw new Error(`declaration type ${st.vtype} not supported on transpilation`);
        }
        // console.log(st.items);
        // console.log(st.init);
        code += st.const ? 'const ':'let ';
        if (st.init) {
            // console.log(st.init instanceof ExpressionItems.ExpressionList);
            const initlen = st.init instanceof ExpressionItems.ExpressionList ? st.init.length : 1;
            if (st.items.length !== initlen) {
                console.log(st.items);
                console.log(st.init.stack);
                throw new Error(`mistmatch lengths ${st.items.length} vs ${initlen}`);
            }
        }

        this.declareInsideTranspilation(st.items.map(x => x.name));
        if (st.items.length === 1) {
            code += st.items[0].name;
        } else {
            code += '[' + st.items.map(x => x.name).join() + ']';
        }
        if (st.init) {
            // console.log(st.init);
            if (st.init.length === 1) {
                code += `=${this.#toString(st.init[0])}`;
            } else if (st.init instanceof ExpressionItems.ExpressionList) {
                const inits = [];
                // console.log(st.init);
                for (const init of st.init.items) {
                    inits.push(this.#toString(init));
                }
                code += '=['+inits.join()+']';
            } else if (st.init instanceof Expression) {
                code += `=${this.#toString(st.init)}`;
            } else {
                EXIT_HERE;
            }
        }
        return code;
    }
    #transpileAssign(st) {
        const ref = st.name;
        const name = ref.name;
        const value = this.#toString(st.value);
        let code = name;
        if (ref.dim) {
            const cindexes = [];
            for (const index of ref.indexes) {
                cindexes.push(this.#toString(index));
            }
            code = code + '['+ cindexes.join('][')+']';
        }
        if (!this.isDeclaredInsideTranspilation(name)) {
            const reference = Context.references.getReference(name, false);
            if (reference) {
                return this.#mappingSetReference(name, reference, code, ref.dim ?? 0, value);
            }
        }
        return code + '=' + value;
    }
    #transpileVariableIncrement(st) {
        if (!st.dim) {
            if (st.pre === 1n) {
                return '++'+st.name;
            }
            if (st.post === 1n) {
                return st.name+'++';
            }
        }
        throw new Error(`Traspilation not supported by pre:${st.pre}, post:${st.post}, dim:${dim}`);
    }
    #transpileScopeDefinition(st) {
        let codes = [];
        for (const statement of st.statements) {
            codes.push(this.#transpile(statement));
        }
        return '{'+codes.join(';\n')+'}';
    }
    declareInsideTranspilation(names) {
        for (const name of names) {
            this.currentScope[name] = true;
        }
    }
    pushScope() {
        this.scopes.push(this.currentScope);
        this.currentScope = {};
    }
    popScope() {
        this.currentScope = this.scopes[this.scopes.length-1];
        this.scopes.pop();
    }
    isDeclaredInsideTranspilation(name) {
        // console.log(`\x1B[42m ${name} \x1B[0m`);
        if (typeof this.currentScope[name] !== 'undefined') {
            return true;
        }
        for (const scope of this.scopes) {
            if (typeof scope[name] !== 'undefined') {
                return true;
            }
        }
        return false;
    }
    #mapping(operand, options) {
        const name = operand.name;
        const dim = operand.indexes ? operand.indexes.length : 0;
        if (operand instanceof ExpressionItems.StringTemplate) {
            return '`'+ operand.value + '`';
        }
        if (this.isDeclaredInsideTranspilation(operand.name)) {
            // TODO: indexes
            return name;
        }
        const result = operand.toString(options);
        if (operand instanceof ExpressionItems.ReferenceItem) {
            // console.log(`\x1B[41m OPERAND \x1B[0m ${name}`, operand, result);
            if (this.isDeclaredInsideTranspilation(operand.name)) {
                // TODO: indexes
                return result;
            }
            const reference = Context.references.getReference(name, false);
            if (reference) {
                return this.#mappingGetReference(name, reference, result, dim);
            }
            // console.log(reference);
        }
        return result;
    }
    createTranspiledObjectReference(type, name, obj) {
        // TODO: create arrays of references for arrays
        const id = `___ref_${type}_${name}__`;
        if (typeof this.context[id] === 'undefined') {
            this.context[id] = obj;
        }
        return id;
    }
    #mappingGetReference(name, reference, result, dim) {
        return this.#mappingReference(name, reference, result, dim, false);
    }
    #mappingReference(name, reference, result, dim, isSet, value) {
        if (isSet && typeof value === 'undefined') {
            throw new Error(`value not defined for set reference ${name}`);
        }
        const action = isSet ? 'set':'get';
        const isFixed = reference.instance.type === 'fixed';
        const optionalValue = isSet ? value :'';
        const extraArgValue = isSet ? `,${value}`:'';
        if (isFixed) {
            const indexes = this.#extractIndexes(result);
            if (dim == 1) {
                let tref = this.createTranspiledObjectReference('fixed', name, reference.instance.getItem(reference.locator).definition);
                return tref+`.${action}RowValue(Number(${indexes[0]})${extraArgValue})`;
                // return `getFixed('${name}'`+ (indexes === false ? ')':`,${indexes})`);
            } if (dim == 2) {
                if (typeof indexes[0] === 'number') {
                    let tref = this.createTranspiledObjectReference('fixed', `${name}__${indexes[0]}__`, reference.getItem([indexes[0]]).definition);
                    return tref+`.${action}RowValue(Number(${indexes[1]})${extraArgValue})`;
                } else {
                    const lindex = reference.array.getLength(0);
                    if (lindex <= 32) {
                        let references = [];
                        for (let index = 0; index < lindex; ++index) {
                            references.push(reference.getItem([index]).definition);
                        }
                        let tref = this.createTranspiledObjectReference('fixed', name, references);
                        return tref+`[${indexes[0]}].${action}RowValue(Number(${indexes[1]})${extraArgValue})`;
                    }
                }

                return `${action}FixedRow('${name}',${indexes[1]})[${indexes[2]}]`;
            }
        } else {
            const type = reference.instance.type;
            const isInt = type === 'int';
            if (!isFixed && !isInt) {
                throw new Error(`not supported (get) reference type ${reference.instance.type}`);
            }

            if (isInt && (reference.const || reference.name === 'N')) {
                return reference.instance.get(reference.locator).getValue() + 'n';
            }
            if (dim == 0) {
                const definition = reference.instance.getDefinition(reference.locator);
                let tref = this.createTranspiledObjectReference(type, name, definition);
                const _tmp = reference.getItem([]);
                return tref+`.${action}Value(${optionalValue})`;
                // return `getFixed('${name}'`+ (indexes === false ? ')':`,${indexes})`);
            } if (dim == 1) {
                if (typeof indexes[0] === 'number') {
                    const definition = reference.getItem([indexes[0]]).definition;
                    let tref = this.createTranspiledObjectReference(type, `${name}__${indexes[0]}__`, definition);
                    return tref+`.${action}Value(${optionalValue})`;
                } else {
                    const lindex = reference.array.getLength(0);
                    if (lindex <= 32) {
                        let references = [];
                        for (let index = 0; index < lindex; ++index) {
                            references.push(reference.getItem([index]).definition);
                        }
                        let tref = this.createTranspiledObjectReference(type, name, references);
                        return tref+`[${indexes[0]}].${action}Value(${optionalValue})`;
                    }
                }
            }
        }
        // TODO: implement dynamicReference to resolve in traspilation execution
        return `${action}DynamicReference('${name}','${reference.instance.type}',${reference.locator}${extraArgValue})`;
    }
    #mappingSetReference(name, reference, result, dim, value) {
        return this.#mappingReference(name, reference, result, dim, true, value);
    }
    #parseIndex(v) {
        if (v.endsWith('n')) {
            const _v = v.slice(0,-1);
            if (!isNaN(_v)) {
                return Number(_v);
            }
        }
        return isNaN(v) ? v : Number(v);
    }
    #extractIndexes(s) {
        const pos = s.indexOf('[');
        if (pos === -1) {
            return [s, []];
        }
        const name = s.substring(0, pos);
        const indexes = [...s.substring(pos).matchAll(/\[([^\[]+)\]/g)].map(match => this.#parseIndex(match[1]));
        if (indexes.length === 0) return false;
        return indexes;
    }
}