const Performance = require('perf_hooks').performance;
const path = require("path");
const Scope = require("./scope.js");
const Expressions = require("./expressions.js");
const Expression = require("./expression.js");
const Definitions = require("./definitions.js");
const References = require("./references.js");
const Indexable = require("./indexable.js");
const Ids = require("./ids.js");
const Constraints = require("./constraints.js");
const Commit = require("./commit.js")
const Commits = require("./commits.js");
const AirGroup = require("./air_group.js");
const AirGroups = require("./air_groups.js");
const AirTemplate = require("./air_template.js");
const AirTemplates = require("./air_templates.js");
const Air = require("./air.js");
const Airs = require("./airs.js");
const Variables = require("./variables.js");
const Sequence = require("./sequence.js");
const List = require("./list.js");
const Assign = require("./assign.js");
const Function = require("./function.js");
const AirTemplateFunction = require("./air_template_function.js");
const PackedExpressions = require("./packed_expressions.js");
const ProtoOut = require("./proto_out.js");
const FixedCols = require("./fixed_cols.js");
const WitnessCols = require("./witness_cols.js");
const CustomCols = require("./custom_cols.js");
const ProofValues = require("./proof_values.js");
const Challenges = require("./challenges.js");
const AirValues = require("./air_values.js");
const AirGroupValues = require("./air_group_values.js");
const Iterator = require("./iterator.js");
const Context = require("./context.js");
const Runtime = require("./runtime.js");
const Exceptions = require('./exceptions.js');
const {FlowAbortCmd, BreakCmd, ContinueCmd, ReturnCmd} = require("./flow_cmd.js")
const ExpressionItems = require("./expression_items.js");
const ExpressionItem = ExpressionItems.ExpressionItem;
const DefinitionItems = require("./definition_items.js");
const Features = require("./features.js");
const fs = require('fs');
const { log2, getKs, getRoots } = require("./utils.js");
const Hints = require('./hints.js');
const util = require('util');
const Debug = require('./debug.js');
const Transpiler = require('./transpiler.js');
const assert = require('./assert.js');
const { performance } = require('perf_hooks');
const utils = require('./utils.js')
const Chrono = require('./chrono.js');
const units = require('./units.js');

const MAX_SWITCH_CASE_RANGE = 512;
module.exports = class Processor {
    constructor (Fr, parent, config = {}) {
        this.totalProtoTime = 0;
        this.memoryInfo = {maxMemory: 0};
        this.lastMs = Math.floor(performance.now());
        this.sourceRef = '(processor constructor)';
        this.compiler = parent;
        this.trace = true;
        this.Fr = Fr;
        this.prime = Fr.p;
        this.references = new References();
        this.scope = new Scope();
        this.runtime = new Runtime();
        this.context = new Context(this.Fr, this, config);
        this.pragmas = { nextStatement: {},
                         nextFixed: {}};
        this.loadedRequire = {};
        this.globalScopeTypes = []; // 'witness', 'fixed', 'airgroupvalue', 'challenge', 'proofvalue', 'public'];

        this.scope.mark('proof');
        this.deferredCalls = {};
        this.timers = {};
        this.memory = {};
        this.includeStack = [];

        this.lastAirGroupId = -1;
        this.lastAirId = -1;
        this.airGroupId = 0;
        this.package = false;

        this.ints = new Variables('int', DefinitionItems.IntVariable, ExpressionItems.IntValue);
        this.references.register('int', this.ints);

        this.fes = new Variables('fe', DefinitionItems.FeVariable, ExpressionItems.FeValue);
        this.references.register('fe', this.fes);

        this.strings = new Variables('string', DefinitionItems.StringVariable, ExpressionItems.StringValue);
        this.references.register('string', this.strings);

        this.exprs = new Variables('expr', DefinitionItems.ExpressionVariable, Expression, {constClass: ExpressionItems.ExpressionReference});
        this.references.register('expr', this.exprs);

        this.fixeds = new FixedCols();
        ExpressionItem.setManager(ExpressionItems.FixedCol, this.fixeds);
        this.fixeds.runtimeRows = true;
        this.references.register('fixed', this.fixeds);

        this.witness = new WitnessCols();
        ExpressionItem.setManager(ExpressionItems.WitnessCol, this.witness);
        this.references.register('witness', this.witness);

        this.customCols = new CustomCols();
        ExpressionItem.setManager(ExpressionItems.CustomCol, this.customCols);
        this.references.register('customcol', this.customCols);

        this.publics = new Indexable('public', DefinitionItems.Public, ExpressionItems.Public);
        ExpressionItem.setManager(ExpressionItems.Public, this.publics);
        this.references.register('public', this.publics);

        this.challenges = new Challenges();
        ExpressionItem.setManager(ExpressionItems.Challenge, this.challenges);
        this.references.register('challenge', this.challenges);

        this.proofValues = new ProofValues();
        ExpressionItem.setManager(ExpressionItems.ProofValue, this.proofValues);
        this.references.register('proofvalue', this.proofValues);

        this.airGroupValues = new AirGroupValues();
        ExpressionItem.setManager(ExpressionItems.AirGroupValue, this.airGroupValues);
        this.references.register('airgroupvalue', this.airGroupValues);

        this.airValues = new AirValues();
        ExpressionItem.setManager(ExpressionItems.AirValue, this.airValues);
        this.references.register('airvalue', this.airValues);

        this.functions = new Indexable('function', Function, ExpressionItems.FunctionCall, {const: true});
        ExpressionItem.setManager(ExpressionItems.FunctionCall, this.functions);
        this.references.register('function', this.functions);

        this.commits = new Commits();
        this.airGroups = new AirGroups();
        this.airTemplates = new AirTemplates();

        this.expressions = new Expressions('air');
        this.globalExpressions = new Expressions('proof');

        this.constraints = new Constraints();
        this.globalConstraints = new Constraints(this.globalExpressions);

        this.assign = new Assign(Fr, this, this.context, this.references, this.expressions);
        this.hints = new Hints(this.expressions);
        this.globalHints = new Hints(this.globalExpressions);

        this.executeCounter = 0;
        this.executeStatementCounter = 0;
        this.functionDeep = 0;
        this.callstack = []; // TODO
        this.breakpoints = ['expr.pil:26'];
        this.sourceRef = '(built-in-class)';
        this.loadConfigDefines();
        this.loadBuiltInClass();
        this.scopeType = 'proof';
        this.currentAir = false;

        this.currentAirGroup = false;
        this.airGroupStack = [];

        this.airStack = [];

        this.sourceRef = '(init)';

        if (config.protoOut === false) {
            this.proto = false;
        } else {
            this.proto = new ProtoOut(this.Fr);
            this.proto.setupPilOut(Context.config.name ?? 'noname');
        }

        if (typeof Context.config.test === 'object' && typeof Context.config.test.onProcessorInit === 'function') {
            Context.config.test.onProcessorInit(this);
        }
        this.memoryUpdate();
    }
    memoryUpdate() {
        const mem = process.memoryUsage().rss;
        if (mem > this.memoryInfo.maxMemory) {
            this.memoryInfo.maxMemory = mem;
        }
    }
    loadConfigDefines() {
        const defines = Context.config.defines ?? {};
        for (const name in defines) {
            console.log(`> define const int \x1B[38;5;208m${name}\x1B[0m = ${defines[name]}`)
            const initValue = new ExpressionItems.IntValue(Context.config.defines === true ? 1n : BigInt(defines[name]));
            this.references.declare(name, 'int', [], { scope: false, sourceRef: '(defines)', const: true }, initValue);
        }
    }
    loadBuiltInClass() {
        const filenames = fs.readdirSync(__dirname + '/builtin', {recursive: true});
        this.builtIn = {};
        for (const filename of filenames) {
            if (!filename.endsWith('.js')) continue;
            if (Context.config.debug.builtInLoad) {
                console.log(`Loading builtin ${filename}.....`);
            }
            if (Debug.active) console.log(filename);
            const builtInCls = require(__dirname + '/builtin/'+ filename);
            const builtInObj = new builtInCls(this);
            this.builtIn[builtInObj.name] = builtInObj;
            this.references.declare(builtInObj.name, 'function', [], {}, builtInObj);
        }
    }
    insideFunction() {
        return this.functionDeep > 0;
    }
    declareBuiltInConstants() {
        this.references.declare('PRIME', 'int', [], { global: true, sourceRef: this.sourceRef, const: true }, this.prime);
        this.references.declare('N', 'int', [], { global: true, sourceRef: this.sourceRef });
        this.references.declare('BITS', 'int', [], { global: true, sourceRef: this.sourceRef });
        this.references.declare('AIRGROUP', 'string', [], { global: true, sourceRef: this.sourceRef });
        this.references.declare('AIRGROUP_ID', 'int', [], { global: true, sourceRef: this.sourceRef }, new ExpressionItems.IntValue(-1));
        this.references.declare('AIR_ID', 'int', [], { global: true, sourceRef: this.sourceRef }, new ExpressionItems.IntValue(-1));
        this.references.declare('AIR_NAME', 'string', [], { global: true, sourceRef: this.sourceRef }, new ExpressionItems.StringValue(''));
        this.references.declare('AIRTEMPLATE', 'string', [], { global: true, sourceRef: this.sourceRef }, new ExpressionItems.StringValue(''));
        this.references.declare('VIRTUAL', 'int', [], { global: true, sourceRef: this.sourceRef }, new ExpressionItems.IntValue(0));
    }
    startExecution(program) {
        const t1 = performance.now();
        const statements = program.statements;

        this.sourceRef = '(start-execution)';

        this.declareBuiltInConstants();
        this.scope.pushInstanceType('proof');
        this.sourceRef = '(execution)';
        this.execute(statements);
        this.sourceRef = '(airgroup-execution)';
        this.finalClosingAirGroups();
        this.finalProofScope();
        this.scope.popInstanceType();
        this.testSummary();
        if (this.proto) {
            this.memoryUpdate();
            console.log(`\nGenerating pilout (protobuf) ${Context.config.outputFile} .....`)
            const t1 = performance.now();
            this.generateProtoOut();
            this.memoryUpdate();
            const t2 = performance.now();
            if (fs.existsSync(Context.config.outputFile)) {
                const stats = fs.statSync(Context.config.outputFile);
                console.log('  > Proto size: ' + units.getHumanSize(stats.size));
            }
            this.totalProtoTime += (t2-t1);
            console.log('  > Proto time: ' + units.getHumanTime(t2-t1));
        }
        const t2 = performance.now();
        this.memoryUpdate();
        const compilationTime = t2 - t1;
        console.log('  > Total proto time ('+(Math.round((this.totalProtoTime * 10000)/compilationTime)/100)+'%): ' + units.getHumanTime(this.totalProtoTime));
        console.log('  > Memory: ' + units.getHumanSize(this.memoryInfo.maxMemory));
        console.log('  > Total compilation: ' + units.getHumanTime(compilationTime));
        return Context.tests.active ? Context.tests.fail === 0 : true;
    }
    testSummary() {
        if (!Context.tests.active) return;
        if (Context.tests.fail > 0) {
            console.log(`> tests OK: ${Context.tests.ok}`);
            console.log(`> tests FAIL: ${Context.tests.fail} => \x1B[31mSome tests fails!!\x1B[0m`);
            Context.tests.msgs.forEach(msg => { const lines = msg.split('\n');
                lines.forEach(line => console.log('  - '+line));
            });
        } else {
            console.log(`> tests OK: ${Context.tests.ok} => \x1B[32mAll tests passed\x1B[0m`);
        }
    }
    generateProtoOut()
    {
        if (Context.config.protoOut === false) return;
        this.memoryUpdate();
        this.proto.setPublics(this.publics);
        this.proto.setProofValues(this.proofValues);
        this.proto.setChallenges(this.challenges);
        let packed = new PackedExpressions();
        this.globalExpressions.pack(packed);
        const imSymbols = packed.expressionLabels.map((label, index) => typeof label === 'undefined' ? value : {label, from:index}).filter(x => typeof x !== 'undefined')
        this.proto.setSymbolsFromLabels(imSymbols, 'im');
        console.log(`  > Proto intermediates: ${imSymbols.length}`);
        this.proto.setGlobalConstraints(this.globalConstraints, packed);
        this.proto.addHints(this.globalHints, packed, {airGroupId: false });
        this.proto.setGlobalExpressions(packed);
        this.proto.setGlobalSymbols(this.references);
        this.proto.encode();
        this.memoryUpdate();
        console.log(`  > Saving fixed to file ${Context.config.outputFile} ...`);
        this.proto.saveToFile(Context.config.outputFile);
        this.memoryUpdate();
    }
    traceLog(text, color = '') {
        if (!this.trace) return;
        if (Debug.active) {
            console.log([Expression.constructor.name]);
            if (color) console.log(`\x1B[${color}m${text}\x1B[0m`);
            else console.log(text);
        }
    }
    execute(statements, label = '') {
        const __executeCounter = this.executeCounter++;
        statements = statements ?? [];
        const lstatements = Array.isArray(statements) ? statements : [statements];
        // console.log(`\x1B[45m====> ${lstatements[0].type}\x1B[0m`);
        const firstBlockStatement = lstatements.length > 0 ? lstatements[0] : {debug:''};
        let __label = label ? label : (firstBlockStatement.debug ?? '');
        this.traceLog(`[TRACE-BLOCK] #${__executeCounter} ${__label} (DEEP:${this.scope.deep})`, '38;5;51');
        for (const st of lstatements) {
            const result = this.executeStatement(st);
            if (result instanceof FlowAbortCmd) {
                __label = label ? label : (st.debug ?? '');
                this.traceLog(`[TRACE-ABORT::${result.constructor.name}#${result.id}] #${__executeCounter} ${__label} (DEEP:${this.scope.deep})`,'38;5;51;48;5;16');
                return result;
            }
        }
        return false;
    }
    getDirectStatement(st) {
        if (st.type === 'code') {
            return this.getDirectStatement(st.statements);
        }
        return st.type;
    }
    executeStatement(st) {
        const __executeStatementCounter = this.executeStatementCounter++;
        let ignoreStatement = this.pragmas.nextStatement.ignore ?? false;
        let activeTranspile = this.pragmas.nextStatement.transpile ?? false;
        let statementIsPragma = (ignoreStatement || activeTranspile) && this.getDirectStatement(st) === 'pragma';

        if (!statementIsPragma) {
            if (activeTranspile) {
                this.transpile = true;
            }
            // clean for next statement
            this.pragmas.nextStatement = {};
        } else {
            // clean ignore, need to wait to next, because current statement is pragma
            ignoreStatement = false;
        }

        let res = new ExpressionItems.IntValue(0); // default value if ignore
        if (!ignoreStatement) {
            this.traceLog(`[TRACE] #${__executeStatementCounter} ${st.debug ?? ''} (DEEP:${this.scope.deep})`, '38;5;75');

            this.sourceRef = st.debug ? (st.debug.split(':').slice(0,2).join(':') ?? ''):'';
            // if (st instanceof ExpressionItem) {
            //     const res = st.instance();
            //     return res;
            // }
            if (typeof st.type === 'undefined') {
                console.log(st);
                this.error(st, `Invalid statement (without type)`);
            }
            const method = ('exec_'+st.type).replace(/[-_][a-z]/g, (group) => group.slice(-1).toUpperCase());
            if (Debug.active) console.log(`## DEBUG ## ${this.executeCounter}.${this.executeStatementCounter} ${method} ${st.debug}` );
            if (!(method in this)) {
                console.log('==== ERROR ====');
                this.error(st, `Invalid statement type: ${st.type}`);
            }
            try {
                if (this.breakpoints.includes(st.debug)) {
                    debugger;
                }
                if (this.transpile) {
                    this.transpile = false;
                    const transpiler = new Transpiler({processor: this});
                    const res = transpiler.transpile(st, this.transpileOptions);
                    this.transpileOptions = {};
                    return res;
                } else {
                    res = this[method](st);
                }
            } catch (e) {
                this.dumpExceptionInfo({method, st, e});
                if (activeTranspile) {
                    this.transpile = false;
                    throw e;
                }
            }
        }
        if (activeTranspile) {
            this.transpile = false;
        }
        return res;
    }
    dumpExceptionInfo(info) {
        let deep = this.callstack.length;
        let index = deep - 1;
        let tag = Context.sourceTag;
        let lines = [];
        if (info.e.message.includes(tag)) {
            lines.push('   0 '+info.e.message);
        } else {
            lines.push('   0 '+info.e.message+` at ${Context.sourceTag}`);
        }
        while (index >= 0) {
            const cinfo = this.callstack[index];
            lines.push(`  ${String(deep-index).padStart(2)} ${cinfo.call.padEnd(80)} [${cinfo.source}]` );
            --index;
        }
        console.log(lines.join('\n'));
        if (Context.config.verbose) {
            throw info.e;
        }
        process.exit(1);
    }
    getPragmaStringTemplateParam(param, defaultValue) {
        if (typeof param === 'undefined') {
            return defaultValue ?? false;
        }
        param = typeof param === 'string' ? param.trim() : String(param);
        if (param.startsWith('"') || param.startsWith("'") || param.startsWith('`')) {
            if (param.length < 2 || param[0] !== param[param.length-1]) {
                throw new Error(`Invalid string template param parameter ${param} at ${Context.sourceRef}`);
            }
            const isTemplate = param[0] === '`';
            param = param.slice(1, -1);
            if (isTemplate) {
                param = this.expandTemplates(param);
            }
        }
        return param;
    }
    execPragma(st) {
        let params = st.value.split(/\s+/);
        const instr = params[0] ?? false;
        switch (instr) {
            case 'message':
                const ms = Math.floor(performance.now());
                console.log(`\x1B[46m${st.value.slice(8)} (${ms}ms +${ms-this.lastMs}ms)\x1B[0m`);
                this.lastMs = ms;
                break;
            case 'debug':
                if (params[1] === 'on') {
                    Debug.active = true;
                    console.log('##############');
                    console.log('## DEBUG ON ##');
                    console.log('##############');
                }
                else if (params[1] === 'off') Debug.active = false;
                break;
            case 'profile':
                if (params[1] === 'on') {
                    console.profile();
                }
                else if (params[1] === 'off') {
                    console.profileEnd();
                }
                break;
            case 'exit':
                EXIT_HERE;
                break;
            case 'timer': {
                const name = params[1] ?? false;
                const action = params[2] ?? 'start';
                if (action === 'start')  {
                    this.timers[name] = Performance.now();
                    // this.timers[name] = process.hrtime();
                } else if (action === 'end') {
                    // const now = process.hrtime();
                    const now = Performance.now();
                    const start = this.timers[name] ?? now;
                    // const milliseconds = (now[0] - start[0]) * 1000 + Math.floor((now[1] - start[1])/1000000);
                    const milliseconds = (now - start);
                    console.log(`  \x1B[36m> Timer ${name} ${Math.round(milliseconds * 100)/100.0} ms\x1B[0m`);
                }
                break;
            }
            case 'memory': {
                const mem = process.memoryUsage();
                if (params[1] === 'print') {
                    return this.showMemory(mem);
                }
                const name = params[1] ?? false;
                const action = params[2] ?? 'start';
                if (action === 'start')  {
                    this.memory[name] = mem;
                } else if (action === 'end') {
                    const start = this.memory[name] ?? mem;
                    return this.showMemory(start, mem);
                } else {
                    throw new Error(`Invalid action ${action} on pragma memory`);
                }
                break;
            }
            case 'fixed_dump':{
                const [name, indexes] = utils.extractNameAndNumIndexes(params[1]);
                const filename = params[2] ?? false;
                const bytes = {byte: 1, word: 2, dword: 4, lword: 4}[params[3]] ?? false;
                console.log('dumping.....');
                console.log(name, indexes, filename, bytes);
                Context.references.getItem(name, indexes).definition.dumpToFile(filename, bytes);
                break;
            }
            case 'fixed_bytes':
            case 'fixed_size':{
                const bytes = {byte: 1, word: 2, dword: 4, lword: 4}[params[1]] ?? params[1];
                if (bytes != 1 && bytes != 2 && bytes != 4 && bytes != 8) {
                    throw new Error(`Invalid bytes ${params[1]} on pragma fixed_size (valid values: bytes, word, dword, lword) at ${Context.sourceRef}`);
                }
                this.pragmas.nextFixed.bytes = Number(bytes);
                break;
            }
            case 'fixed_tmp':{
                this.pragmas.nextFixed.temporal = true;
                break;
            }
            case 'fixed_external': {
                this.pragmas.nextFixed.external = this.getPragmaStringTemplateParam(params[1], true);
                break;
            }
            case 'extern_fixed_file': {
                this.currentAir.loadExternFixedFile(this.getPragmaStringTemplateParam(params[1], true));
                break;
            } 
            case 'fixed_load': {
                if (typeof params[1] === 'undefined') {
                    if (typeof this.currentAir.fixedLoadFromFile === 'undefined') {
                        throw new Error(`Pragma fixed_load without filename at ${Context.sourceRef}`);
                    } 
                    params[1] = this.currentAir.fixedLoadFromFile.filename;
                    ++this.currentAir.fixedLoadFromFile.col;
                    params[2] = this.currentAir.fixedLoadFromFile.col;
                } else if (typeof params[2] === 'undefined' && typeof this.currentAir.fixedLoadFromFile !== 'undefined') {
                    ++this.currentAir.fixedLoadFromFile.col;
                    params[2] = this.currentAir.fixedLoadFromFile.col;
                } else {
                    this.currentAir.fixedLoadFromFile = {filename: params[1], col: this.value2num(params[2] ?? 0)};
                }
                this.pragmas.nextFixed.loadFromFile = {filename: this.getPragmaStringTemplateParam(params[1], true), col: this.value2num(params[2] ?? 0)};
                break;
            }
            case 'output_fixed_file': {
                Context.air.setOutputFixedFile(this.getPragmaStringTemplateParam(params[1], Context.airName+'.fixed'));
                break;
            }
            case 'debugger':
                debugger;
                break;
            case 'feature': {
                this.pragmas.nextStatement.ignore = !(Context.config.features[params[1]] ?? false);
                break;
            }
            case 'transpile':
                this.transpileOptions = {};
                this.pragmas.nextStatement.transpile = true;
                for (let i = 1; i < params.length; ++i) {
                    const pos = params[i].indexOf(':');
                    if (pos < 0) {
                        this.transpileOptions[params[i]] = true;
                    } else {
                        const key = params[i].substr(0, pos);
                        const value = params[i].substr(pos+1);
                        this.transpileOptions[key] = value;
                    }
                }
                break;
            case 'dump': {
                const value = this.references.get(params[1]).value;
                value.dump('*************** PRAGMA '+Context.sourceRef+' ***************');
                break;
            }
            case 'test': {
                Context.tests.active = true;
                Context.tests.fail = Context.tests.fail ?? 0;
                Context.tests.ok = Context.tests.ok ?? 0;
                Context.tests.msgs = Context.tests.msgs ?? [];
                break;
            }
            default:
                throw new Error(`Prama ${instr} not implemented`);
        }

    }
    showMemory(m1, m2 = false) {
        const concept = m2 === false ? 'use' : 'increment';
        const _m2 = m2 === false ? {} : m2;
        console.log(`\x1B[36m  > Memory ${concept}: ${units.getMB(m1.rss, m2.rss)} MB\x1B[0m`);
    }
    execProof(st) {
        this.scope.pushInstanceType('proof');
        this.execute(st.statements);
        this.scope.popInstanceType();
    }
    prepareFunctionCall(func, callinfo) {
        const mapInfo = func.mapArguments(callinfo);
        // console.log(mapInfo);
        // console.log(func.constructor.name);
        // callinfo.dumpArgs(mapInfo.eargs, 'CALLINFO');
        this.callstack.push({call: mapInfo.scall ?? func.name, source: Context.sourceTag});
        ++this.functionDeep;
        this.scope.push();
        return mapInfo;
    }
    finishFunctionCall(func) {
        this.scope.pop();
        --this.functionDeep;
        this.callstack.pop();
        if (Debug.active) console.log(`END CALL ${func.name}`);
    }
    checkNoVirtual(callinfo) {
        if (callinfo.virtual) {
            throw new Error(`[${Context.sourceRef}] Invalid use of virtual, only to create virtual instances`);
        }
    }
    executeFunctionCall(name, callinfo, options = {}) {
        const previousPackage = this.package;
        let res = false;
        try {
            let func;
            if (this.builtIn[name] !== undefined) {
                this.checkNoVirtual(callinfo);
                func = this.builtIn[name];
            } else if (this.package !== false) {
                func = this.references.get(name, [], {insideName: `${this.package}.${name}`});
            } else {
                func = this.references.get(name);
            }
            
            if (Debug.active) {
                console.log(`CALL ${name}`);
                console.log(callinfo);
            }

            if (!func) {
                this.error({}, `Undefined function ${name}`);
            }
            if (func.package) {
                this.package = func.package;
            }
            if (func.isBridge) {
                if (callinfo.virtual) {
                    func.virtual = true;
                }
                return func.exec(callinfo, {}, options);
            } else if (options.alias) {
                throw new Error(`Alias can not be used on function calls at ${Context.sourceRef}`);
            }
            this.checkNoVirtual(callinfo);


            const mapInfo = this.prepareFunctionCall(func, callinfo);
            this.references.pushVisibilityScope(func.creationScope);
            res = func.exec(callinfo, mapInfo);
            this.references.popVisibilityScope();
            this.finishFunctionCall(func);
        } finally {
            this.package = previousPackage;
        }
        return (res === false || typeof res === 'undefined') ? new ExpressionItems.IntValue() : res;
    }
    execCall(st) {
        const name = st.function.name;
        if (Debug.active) console.log(`CALL (EXEC) ${name}`);
        const res = this.executeFunctionCall(name, st);
        if (Debug.active) console.log(`END CALL (EXEC) ${name}`);
        return res;
    }
    execAssign(st) {
        // type: number(int), fe, string, col, challenge, public, prover,
        // dimensions:
        // TODO: move to assign class
        const indexes = this.decodeIndexes(st.name.indexes)
        const names = this.context.getNames(st.name.name);
        let assignedValue = false;
        if (st.value instanceof ExpressionItems.ExpressionList) {
            const sequence = new Sequence(st.value, ExpressionItems.IntValue.castTo(this.references.get('N')));
            sequence.extend();
            if (Debug.active) console.log(sequence.size);
            if (Debug.active) console.log(sequence.toString());
            assignedValue = st.value.instance();
        } else if (st.sequence) {
            assignedValue = new Sequence(st.sequence, ExpressionItems.IntValue.castTo(this.references.get('N')));
            if (assignedValue.isList) {
                assignedValue = assignedValue.toList();
            } else {
                assignedValue.extend();
            }
        } else {
            assignedValue = st.value.instance();
        }
        this.assign.assign(names, indexes, assignedValue);
        if (Debug.active) console.log(`ASSIGN ${st.name.name} = ${assignedValue.toString()} \x1B[0;90m[${Context.sourceTag}]\x1B[0m`);
    }
    execHint(s) {
        const name = s.name;
        if (Debug.active) console.log(util.inspect(s.data, false, null, true));
        const res = this.processHintData(s.data);
        if (Debug.active) console.log(util.inspect(res, false, null, true));
        const scopeType = this.scope.getInstanceType();
        if (scopeType === 'proof') {
            if (Context.config.logHints) console.log(`  > define global hint \x1B[38;5;208m${name}\x1B[0m`)
            this.globalHints.define(name, res);
        }
        else if (scopeType === 'air') {
            if (Context.config.logHints || Context.config.logGlobalHints) {
                console.log(`  > define hint \x1B[38;5;208m${name}\x1B[0m`)
            }
            this.hints.define(name, res);
        } else {
            throw new Error(`Hint definition on invalid scope (${scopeType}) ${Context.sourceTag}`);
        }
    }
    processHintData(hdata) {
        if (hdata instanceof Expression) {
            const value = hdata.eval();
            if (typeof value === 'bigint') return value;
            const res = hdata.instance();
            if (Context.config.logHintExpressions) console.log('  > Hint expression: ' + res.toString());
            return res;
        }
        if (hdata.type === 'array') {
            let result = [];
            for (const item of hdata.data) {
                result.push(this.processHintData(item));
            }
            return result;
        }
        if (hdata.type === 'object') {
            let result = {};
            for (const key in hdata.data) {
                // TODO: key no exists
                result[key] = this.processHintData(hdata.data[key]);
            }
            return result;
        }
        if (Debug.active) console.log(hdata);
        throw new Error('Invalid hint data');
    }
    execIf(s) {
        for (let icond = 0; icond < s.conditions.length; ++icond) {
            const cond = s.conditions[icond];
            if ((icond === 0) !== (cond.type === 'if')) {
                throw new Error('first position must be an if, and if only could be on first position');
            }
            if (cond.type === 'else' && icond !== (s.conditions.length-1)) {
                throw new Error('else only could be on last position');
            }
            if (Debug.active) console.log(cond);

            if (typeof cond.expression !== 'undefined') {
                if (cond.expression.evalAsBool() !== true) {
                    continue;
                }
            }
            this.scope.push();
            const res = this.execute(cond.statements, `IF ${this.sourceRef}`);
            this.scope.pop();
            return res;
        }
    }
    prepareSwitchCase(s) {
        let values = {};
        // s.cases.map((x,i) => {console.log(`#### CASE ${i} ####`); console.log(util.inspect(x.statements, false, 2000, true))});
        for (let index = 0; index < s.cases.length; ++index) {
            const _case = s.cases[index];
            if (_case.condition && _case.condition.values) {
                for (const value of _case.condition.values) {
                    if (value instanceof Expression) {
                        const _key = value.asInt();
                        if (typeof values[_key] !== 'undefined') {
                            throw new Error(`Switch-case value ${_key} duplicated`);
                        }
                        values[_key] = index;
                    } else if (value.from && value.to && value.from instanceof Expression && value.to instanceof Expression) {
                        const _from = value.from.asInt();
                        const _to = value.to.asInt();
                        if ((_to - _from) < MAX_SWITCH_CASE_RANGE) {
                            while (_from <= _to) {
                                if (typeof values[_from] !== 'undefined') {
                                    throw new Error(`Switch-case value ${_from} duplicated`);
                                }
                                values[_from] = index;
                                ++_from;
                            }
                        } else {
                            throw new Error(`Switch-case range too big ${from}..${to} (${_to-_from}) max: ${MAX_SWITCH_CASE_RANGE}`);
                        }
                    } else {
                        console.log(value);
                        EXIT_HERE;
                    }
                }
                _case.__cached_values = values;
            } else if (_case.default) {
                if (typeof values[false] !== 'undefined') {
                    throw new Error(`Switch-case DEFAULT duplicated`);
                }
                values[false] = index;
            } else {
                console.log(_case);
                EXIT_HERE;
            }
        }
        s.__cached_values = values;
    }
    execSwitch(s) {
        // switch must cases value must be constant values
        // TODO: check no constant variable values
        let res = false;
        if (!s.__cached_values) {
            this.prepareSwitchCase(s);
        }
        assert.instanceOf(s.value, Expression);
        const value = s.value.asInt();
        let caseIndex = false;
        if (typeof s.__cached_values[value] !== 'undefined') {
            caseIndex = s.__cached_values[value];
        } else if (typeof s.__cached_values[false] !== 'undefined') {
            caseIndex = s.__cached_values[false];
        }
        if (caseIndex !== false) {
            this.scope.push();
            res = this.execute(s.cases[caseIndex].statements, `SWITCH CASE ${value} ${this.sourceRef}`);
            this.scope.pop();
        }
        return res;
    }
    execWhile(s) {
        let index = 0;
        let result = false;
        while (true) {
            this.scope.push();
            const whileCond = s.condition.eval().asBool();
            if (!whileCond) {
                this.scope.pop();
                break;
            }
            result = this.execute(s.statements, `WHILE ${this.sourceRef} I:${index}`);
            ++index;
            this.scope.pop();
            if (this.abortInsideLoop(result)) {
                result = result.getResult();
                break;
            }
        }
        return this.clearLoopAbort(result);
    }
    execUse(s) {
        const name = this.expandTemplates(s.name);
        const alias = s.alias ? this.expandTemplates(s.alias) : false;
        this.references.addUse(name, alias);
    }
    execContainer(s) {
        const name = this.expandTemplates(s.name);
        if (this.references.createContainer(name, s.alias)) {
            const result = this.execute(s.statements, `SCOPE ${this.sourceRef}`);
            this.references.closeContainer();
        }
    }
    execScopeDefinition(s) {
        this.scope.push();
        const result = this.execute(s.statements, `SCOPE ${this.sourceRef}`);
        this.scope.pop(this.globalScopeTypes);
        return result;
    }
    execPackageBlock(s) {
        this.scope.push();
        this.scope.setValue('package', s.name);
        const result = this.execute(s.statements, `PACKAGE  ${this.name} ${this.sourceRef}`);
        this.scope.pop(this.globalScopeTypes);
        return result;
    }
    execFor(s) {
        if (Debug.active) console.log('EXEC-FOR');
        let result;
        this.scope.push();
        this.execute(s.init, `FOR ${this.sourceRef} INIT`);
        let index = 0;
        // while (this.expressions.e2bool(s.condition)) {
        let ttotal = 0;
        let tcount = 0;
        let mesure = true;
        let t = [0,0,0,0];
        let large = false;
        const tmark = performance.now();
        let loop_mark = tmark;
        while (true) {
            if (index % 10000 === 0 && index) {
                large = true;
                let loop_mark2 = performance.now();
                const ms = loop_mark2 - tmark;
                ttotal += ms;
                tcount += 1;
                console.log(`  > inside loop ${Context.sourceTag} index:${index} time(ms):${Math.trunc(loop_mark2-loop_mark)} avg(ms):${Math.trunc(ttotal/tcount)} total(s):${Math.trunc(ttotal/1000)}`);
                loop_mark = loop_mark2;
            }
            const loopCond = s.condition.eval().asBool();
            if (Debug.active) console.log('FOR.CONDITION', loopCond, s.condition.toString(), s.condition);
            if (!loopCond) break;
            // if only one statement, scope will not create.
            // if more than one statement, means a scope_definition => scope creation
            // if (mesure) { t[2] = performance.now(); }
            result = this.execute(s.statements, `FOR ${this.sourceRef} I:${index}`);
            ++index;
            // if (mesure) { t[3] = performance.now(); }
            if (this.abortInsideLoop(result)) {
                result = result.getResult();
                break;
            }
            if (Debug.active) console.log('INCREMENT', s.increment);
            this.execute(s.increment);
            //if (mesure) {
            //    t[4] = performance.now();
            //    console.log(`PARTIAL TIMES T0:${t[1]-t[0]}ms T1:${t[2]-t[1]}ms T2:${t[3]-t[2]}ms T3:${t[4]-t[3]}ms`);
            //    mesure = false;
            //}
        }
        if (large) {
            const tend = performance.now();
            console.log(`  > total loop ${Context.sourceTag} ${Math.round((tend-tmark) * 100)/100.0} ms`);
        }
        this.scope.pop();
        const tmark2 = performance.now();
        return this.clearLoopAbort(result);
    }
    clearLoopAbort(result) {
        if (result instanceof BreakCmd || result instanceof ContinueCmd) {
            return false;
        }
        return result;
    }
    abortInsideLoop(result) {
        // continue not need to do anything, because produce an
        // exit of statements inside for.
        if (result instanceof BreakCmd) {
            // reset FlowAbortCmd because we arrive on loop
            result.reset();
            return true;
        }
        if (result instanceof ReturnCmd) {
            return true;
        }
        return false;
    }
    execForIn(s) {
        if (Debug.active) console.log(s);
        if (s.list && s.list instanceof ExpressionItems.ExpressionList) {
            return this.execForInList(s);
        }
        return this.execForInExpression(s);
    }
    execForInList(s) {
        let result = false;
        this.scope.push();
        this.execute(s.init, `FOR-IN-LIST ${this.sourceRef} INIT`);
        // if (s.init.items[0].reference) {
        //     this.execForInListReferences(s);
        // } else {
        //     this.execForInListValues(s);
        // }
        const reference = s.init.items[0].reference === true;
        const list = new List(this, s.list, reference);
        const name = s.init.items[0].name;
        let index = 0;
        for (const value of list.values) {
            if (reference) {
                this.assign.assignReference(name, value);
            } else {
                this.assign.assign(name, [], value);
            }
            // if only one statement, scope will not create.
            // if more than one statement, means a scope_definition => scope creation
            result = this.execute(s.statements, `FOR-IN-LIST ${this.sourceRef} I:${index}`);
            ++index;
            if (this.abortInsideLoop(result)) {
                result = result.getResult();
                break;
            }
        }
        this.scope.pop();
        return this.clearLoopAbort(result);
    }
    execForInListValues(s) {
        let result = false;
        this.scope.push();
        const list = new List(this, s.list);
        let index = 0;
        for (const value of list.values) {
            // console.log(s.init.items[0]);
            this.assign.assign(s.init.items[0].name, [], value);
            // if only one statement, scope will not create.
            // if more than one statement, means a scope_definition => scope creation
            result = this.execute(s.statements,`FOR-IN-LIST-VALUES ${this.sourceRef} I:${index}`);
            ++index;
            if (this.abortInsideLoop(result)) {
                result = result.getResult();
                break;
            }
        }
        this.scope.pop();
        return this.clearLoopAbort(result);
    }
    execForInListReferences(s) {
        let result = false;
        this.scope.push();
        const name = s.init.items[0].name;
        assert.ok(!s.init.items[0].indexes);
        let index = 0;
        for (const value of s.list) {
            // console.log(s.init.items[0]);
            this.assign.assignReference(name, value);
            // if only one statement, scope will not create.
            // if more than one statement, means a scope_definition => scope creation
            result = this.execute(s.statements,`FOR-IN-LIST-REFERENCES ${this.sourceRef} I:${index}`);
            ++index;
            if (this.abortInsideLoop(result)) {
                result = result.getResult();
                break;
            }
        }
        this.scope.pop();
        return this.clearLoopAbort(result);
    }
    execForInExpression(s) {
        // s.list.expr.dump();
        if (Debug.active) console.log(s);
        if (Debug.active) console.log(s.list);
        let it = new Iterator(s.list);
        this.scope.push();
        this.execute(s.init,`FOR-IN-EXPRESSION ${this.sourceRef} INIT`);
        let result = false;
        let index = 0;
        const isReference = s.init.items[0].reference ?? false;
        const name = s.init.items[0].name;
        for (const value of it) {
            if (isReference) this.assign.assignReference(name, value);
            else {
                let expr = new Expression();
                expr._set(value);
                this.assign.assign(name, [], expr);
            }
            result = this.execute(s.statements,`FOR-IN-EXPRESSION ${this.sourceRef} I:${index}`);
            ++index;
            if (this.abortInsideLoop(result)) {
                result = result.getResult();
                break;
            }
        }
        this.scope.pop();
        return this.clearLoopAbort(result);

        // this.decodeArrayReference(s.list);
        // [ref, indexs, length] = this.references.getArrayReference(s.list.expr)
        //
    }
    decodeArrayReference(slist) {
        // slist.expr.dump();
        const [name, indexes, legth] = slist.getRuntimeReference();
    }
    execBreak(s) {
        return new BreakCmd();
    }
    execContinue(s) {
        return new ContinueCmd();
    }
    error(s, msg) {
        console.log(s);
        throw new Error(msg);
    }
    executeIncludeRequire(s, isInclude = true) {
        const requireId = s.file.asString();
        let res = true;
        if (!s.contents && (isInclude  || !this.loadedRequire[requireId])) {
            // to support dynamic includes, add some internal statements need to compile inside airgroup
            // but after take compiled statements. TODO: analyze use current airgroup name
            const lastPath = this.getLastInclude();
            const paths = lastPath ? [lastPath]:[];
            const sts = this.compiler.loadInclude(s.file.asString(), {paths, preSrc: 'airtemplate __(int N=2**2) {\n', postSrc: '\n};\n'});
            if (sts === false) {
                throw new Error(`ERROR loading ${isInclude ? 'include':'require'} ${s.file.asString()}`);
            }
            // take only statements inside preSrc/postSrc
            sts.statements = sts.statements[0].statements;
            s.contents = sts;
        }
        if (isInclude || !this.loadedRequire[requireId]) {
            this.loadedRequire[requireId] = true;
            if (s.contents !== true) {
                this.pushInclude(s.contents.fileDir);
                const res = this.execute(s.contents.statements);
                this.popInclude();
                return res;
            }
        }
        return true;
    }
    execInclude(s) {
        return this.executeIncludeRequire(s, true);
    }
    execRequire(s) {
        return this.executeIncludeRequire(s, false);
    }
    execFunctionDefinition(s) {
        if (Debug.active) console.log('FUNCTION '+s.name);
        let name = s.name;
        let options = {};
        if (Context.air) {
            name = `${Context.air.name}.${name}`;
        } else {
            const _package = Context.scope.getValue('package');
            if (_package !== false) {
                options = {declare: {globalReference: `${_package}.${name}`}, func: {package: _package}};
            }
        }
        this.defineFunction(name, s, options);
    }
    defineFunction(name, s, options = {}) {
        const doptions = {...(options.declare ?? {}), sourceRef: Context.sourceRef};
        const id = this.references.declare(name, 'function', [], doptions);

        const foptions = {...s, ...(options.func ?? {}), name, creationScope: Context.scope.deep};
        let func = new Function(id, foptions);
        this.references.set(func.name, [], func);
        return func;
    }
    getExprNumber(expr, s, title) {
        if (Debug.active) {
            console.log(s);
            expr.dump();
        }
        const se = ExpressionItems.IntValue.castTo(expr.eval());
        if (typeof se !== 'bigint') {
//        if (se.op !== 'number') {
            console.log('ERROR');
            console.log(se);
            this.error(s, title + ' is not constant expression (1)');
        }
//        return Number(se.value);
        return se;
    }
    resolveExpr(expr, s, title) {
        return this.expressions.eval(expr);
    }
    evalExpressionList(e) {
        assert.strictEqual(e.type, 'expression_list');
        let values = [];
        for (const value of e.values) {
            values.push(value.evalAsInt());
        }
        return values;
    }
    log2_32bits(value) {
            return (  (( value & 0xFFFF0000 ) !== 0 ? ( value &= 0xFFFF0000, 16 ) :0 )
                    | (( value & 0xFF00FF00 ) !== 0 ? ( value &= 0xFF00FF00, 8  ) :0 )
                    | (( value & 0xF0F0F0F0 ) !== 0 ? ( value &= 0xF0F0F0F0, 4  ) :0 )
                    | (( value & 0xCCCCCCCC ) !== 0 ? ( value &= 0xCCCCCCCC, 2  ) :0 )
                    | (( value & 0xAAAAAAAA ) !== 0 ? 1: 0 ) );
    }
    log2(value) {
        let base = 0;
        value = BigInt(value);
        while (value > 0xFFFFFFFFn) {
            base += 32;
            value = value >> 32n;
        }

        return base + this.log2_32bits(Number(value));
    }
    checkRows(rows) {
        if (2n ** BigInt(this.log2(rows)) !== BigInt(rows)) {
            throw new Error(`Invalid N ${rows}. N must be a power of 2`);
        }
    }
    execAirTemplateDefinition(s) {
        const name = s.name ?? false;
        if (name === false) {
            this.error(s, `airtemplate not defined correctly`);
        }

        const methods = this.extractAirTemplateMethods(s.statements).map(m => this.defineFunction(`${name}.${m.name}`, m));
        const instance = new AirTemplate(name, s.statements, methods, this.getLastInclude());
        this.airTemplates.define(name, instance, `airgroup ${name} has been defined previously on ${Context.sourceRef}`);

        const id = this.references.declare(name, 'function', [], {sourceRef: Context.sourceRef});
        const func = new AirTemplateFunction(id, {args: s.args, name, instance, sourceRef: Context.sourceRef});
        this.references.set(name, [], func);
    }
    execAirTemplateBlock(s) {
        // TODO: support change include path
        const name = s.name ?? false;
        if (name === false) {
            this.error(s, `airtemplate not defined correctly`);
        }
        const airtemplate = this.airTemplates.get(name);
        if (!airtemplate) {
            throw new Error(`airtemplate definition ${name} hasn't been defined before air block`);
        }
        airtemplate.addBlock(s.statements);
    }
    execAirGroup(s) {
        const name = s.name ?? false;
        if (name === false) {
            this.error(s, `airgroup not defined correctly`);
        }

        let airGroup = this.airGroups.get(name);
        if (!airGroup) {
            airGroup = new AirGroup(name, [], true);
            this.airGroups.define(name, airGroup);
        }
        this.openAirGroup(airGroup);
        this.execute(s.statements);
        this.suspendCurrentAirGroup();
    }
    setAirGroupBuiltIntConstants(airGroup) {
        this.references.set('AIRGROUP', [], airGroup ? airGroup.name : '');
        this.references.set('AIRGROUP_ID', [], new ExpressionItems.IntValue(airGroup ? airGroup.id : -1));
    }
    /**
     * method to return id of airgroup, if this id not defined yet, use lastAirGroupId to set it
     * @param {AirGroup} airGroup
     * @returns {number}
     */
    getAirGroupId(airGroup) {
        const id = airGroup.getId();
        if (id !== false) {
            if (this.proto) {
                this.proto.useAirGroup(id);
            }
            return id;
        }
        ++this.lastAirGroupId;
        airGroup.setId(this.lastAirGroupId);
        if (this.proto) {
            this.proto.setAirGroup(this.lastAirGroupId, airGroup.name);
        }
        return this.lastAirGroupId;
    }
    /**
     * Open or reopen a airgroup with name airGroupName, this means that
     * start to executing inside airgroup scope
     * @param {string} airGroupName
     * @param {AirGroup} airGroup
     */
    openAirGroup(airGroup) {
        this.airGroupStack.push(this.currentAirGroup);
        this.currentAirGroup = airGroup;
        this.scope.pushInstanceType('airgroup');
        this.context.push(airGroup.name);
        this.context._airGroupName = airGroup.name;
        this.airGroupId = this.getAirGroupId(airGroup);
        Context.airGroupId = this.airGroupId;
        this.setAirGroupBuiltIntConstants(airGroup);
    }
    /**
    * close current airgroup and call defered funcions, clear scope of airgroup
    */
    closeCurrentAirGroup() {
        // get airGroupId because during closing process this.airGroupId is set to false
        const airGroupId = this.airGroupId;
        const summaryInfo = this.prepareAirGroupSummary(airGroupId);
        this.finalAirGroupScope();
        this.currentAirGroup.end();
        if (this.proto) {
            this.proto.setAirGroupValues(this.airGroupValues.getDataByAirGroupId(airGroupId),
                                         this.airGroupValues.getAggreationTypesByAirGroupId(airGroupId));
            // airGroupValues symbols was generated at end of proof data symbols
        }
        this.suspendCurrentAirGroup();

        this.references.clearScope('airgroup');
        this.showAirGroupSummary(summaryInfo);
    }
    prepareAirGroupSummary(airGroupId) {
        return {name: this.currentAirGroup.name,
                agvs: this.airGroupValues.getDataByAirGroupId(airGroupId).map(agv => { return {name: agv.label, aggregateType: agv.aggregateType, stage: agv.stage, default: agv.defaultValue}}),
                airs: this.currentAirGroup.airs.map(air => { return {name: air.name, template: air.airTemplate.name, bits: air.bits}})};
    }
    showAirGroupSummary(info) {
        const agvNameMaxWidth = info.agvs.reduce((max, agv) => agv.name.length > max ? agv.name.length : max, 0);
        const airNameMaxWidth = info.airs.reduce((max, air) => air.name.length > max ? air.name.length : max, 0);
        console.log(`\nAIRGROUP \x1B[38;5;208m${info.name}\x1B[0m summary\n  > AirGroupValues:`);
        for (const agv of info.agvs) {
            console.log(`    · \x1B[38;5;208m${agv.name.padEnd(agvNameMaxWidth)}\x1B[0m aggregate:\x1B[38;5;208m${agv.aggregateType.padEnd(4)}\x1B[0m stage:\x1B[38;5;208m${agv.stage}\x1B[0m default:\x1B[38;5;208m${agv.default === false ? '(none)':agv.default}\x1B[0m`);
        }
        console.log(`  > Airs:`);
        for (const air of info.airs) {
            console.log(`    · \x1B[38;5;208m${air.name.padEnd(airNameMaxWidth)}\x1B[0m rows:\x1B[38;5;208m2^${air.bits.toString().padEnd(2)}\x1B[0m template:\x1B[38;5;208m${air.template}\x1B[0m`);
        }
    }
    /**
    * "suspend" current because this airgroup could be opened again
    */
    suspendCurrentAirGroup() {
        this.scope.popInstanceType();
        this.currentAirGroup = this.airGroupStack[this.airGroupStack.length - 1];
        this.airGroupId = this.currentAirGroup ? this.currentAirGroup.getId() : false;
        this.airGroupStack.pop();
        this.context.pop();
        Context.airGroupId = this.airGroupId;
        this.setAirGroupBuiltIntConstants(this.currentAirGroup);
    }
    /**
    * create a new air on current airgroup, take number of rows of N parameter of airgroup
    * if this parameter doesn't exists an error was produced
    */
    createAir(airGroup, airTemplate, options = {}) {
        const item = this.references.isDefined('N') ? this.references.getItem('N') : false;
        if (!(item instanceof ExpressionItems.IntValue)) {
            throw new Error(`an int parameter N must be declared as airGroup argument`);
        }
        const rows = item.asInt();
        if (!options.virtual) {
            this.checkRows(rows);
        }
        const air = airGroup.createAir(airTemplate, rows, options);
        this.airStack.push(air);
        this.updateAir();

        if (!air.virtual) {
            if (this.proto) this.proto.pushAir(air.id, air.name, air.rows);
        }
        return air;
    }
    closeAir() {
        const air = this.airStack.pop();
        if (!air.virtual) {
            if (this.proto) this.proto.popAir();
        }

        this.commits.clearAir();
        this.updateAir();
    }
    setBuiltInConstants(airGroup, air) {
        // create built-in constants
        this.setAirGroupBuiltIntConstants(airGroup);
        this.setAirBuiltInConstants(air);
    }
    updateAir() {
        this.setAirBuiltInConstants(Context.air);
    }
    setAirBuiltInConstants(air) {
        this.references.set('BITS', [], air.bits ?? 0);
        this.references.set('AIR_ID', [], new ExpressionItems.IntValue(air.id ?? -1));
        this.references.set('AIR_NAME', [], new ExpressionItems.StringValue(air.name ?? ''));
        this.references.set('VIRTUAL', [], new ExpressionItems.IntValue(air.virtual ? 1 : 0));
        this.references.set('AIRTEMPLATE', [], new ExpressionItems.StringValue(air.airTemplate ? (air.airTemplate.name.name ?? ''):''));
    }
    executeAirTemplate(airTemplate, airTemplateFunc, callinfo, options = {}) {
        const name = options.alias ? options.alias : airTemplate.name;
        const airGroup = this.currentAirGroup;
        if (!airGroup) {
            throw new Exceptions.Runtime(`Instance airtemplate ${name} out of airgroup`);
        }
        const template = name === airTemplate.name ? '' : `(${airGroup.name})`
        const title = 'AIR ' + (callinfo.virtual ? 'virtual ' : '') + 'instance';
        console.log(`\n${title} \x1B[38;5;208m${name}${template}\x1B[0m in airgroup \x1B[38;5;208m${airGroup.name}\x1B[0m`);
        const ti1 = performance.now();
        // airgroup was a function derivated class
        const mapinfo = this.prepareFunctionCall(airTemplateFunc, callinfo);
        airTemplateFunc.prepare(callinfo, mapinfo);

        const air = this.createAir(this.currentAirGroup, airTemplate, {...options, name});
        const nestedAir = this.currentAir !== false;
        this.currentAir = air;

        const hasAlias = name != airTemplate.name;
        if (hasAlias) {
            this.context.push(airTemplate.name);
        }
        this.context.push(name);
        if (nestedAir) {            
            this.pushAirScope();
        }
        this.scope.pushInstanceType('air');

        airGroup.airStart(air.id);
        this.memoryUpdate();
        const bdir = airTemplate.getBaseDir();
        this.pushInclude(bdir);
        let res = airTemplate.exec(air.name ,callinfo);
        this.popInclude();
        this.memoryUpdate();
        this.finalAirScope();
        if (typeof Context.config.test === 'object' && typeof Context.config.test.onAirEnd === 'function') {
            Context.config.test.onAirEnd(this);
        }
        const witnessCols = this.witness.length;
        const fixedCols = this.fixeds.length;
        const customCols = this.customCols.length
        const constraints = this.constraints.length;
        const N = this.rows;
        airGroup.airEnd(air.id, air.virtual ?? false);
        const ti2 = performance.now();
        console.log('  > Witness cols: ' + witnessCols + ' from stage 1 (' + this.witness.countByStage(1).join() + ')');
        console.log('  > Fixed cols: ' + fixedCols);
        if (customCols) {
            const commitNames = this.customCols.getCommitNames().join(',');
            console.log(`  > Custom cols (${commitNames}): ` + customCols);
        }
        console.log('  > Constraints: ' + constraints);
        console.log('  > Execution time: ' + units.getHumanTime(ti2-ti1));

        if (this.proto && !air.virtual) {
            const t1 = performance.now();
            this.memoryUpdate();
            this.airGroupProtoOut(this.currentAirGroup.id, air.id);
            this.memoryUpdate();
            const t2 = performance.now();
            this.totalProtoTime += (t2-t1);
            console.log('  > Proto time: ' + units.getHumanTime(t2-t1));
        }

        if (air.virtual && this.constraints.length > 0) {
            throw new Exceptions.Runtime(`Virtual air ${air.name} has constraints, this is not allowed`);
        }

        this.debugAirInfo();
        this.constraints = new Constraints();

        const t1 = performance.now();
        if (nestedAir) {
            this.popAirScope();
        } else {
            this.clearAirScope(air.name);
        }
        this.scope.popInstanceType(['witness', 'fixed', 'customcol', 'im', 'airvalue']);
        this.context.pop();
        if (hasAlias) {
            this.context.pop();
        }
        this.closeAir(air);
        this.currentAir = false;

        // closing airgroup but no closing final
        // this.suspendCurrentAirGroup(false);

        this.finishFunctionCall(airTemplate);
        this.memoryUpdate();

        const t2 = performance.now();
        console.log('  > Closing time: ' + units.getHumanTime(t2-t1));
        console.log('  > Total time: ' + units.getHumanTime(t2-ti1));

        return (res === false || typeof res === 'undefined') ? new ExpressionItems.IntValue() : res;
    }
    debugAirInfo() {
        let labels;
        const debugWitness = Context.config.debugWitnessColsMatch ?? (Context.config.debugWitnessCols ?? false);
        if (debugWitness !== false) {
            if (typeof debugWitness === 'string') {
                const re = new RegExp(debugWitness);
                labels = this.witness.labelRanges.toArray().filter(x => re.test(x.label));
            } else {
                labels = this.witness.labelRanges.toArray();
            }
            for (const label of labels) {
                const def = this.witness.getDefinition(label.from);
                const extra = label.multiarray ? label.multiarray.toDebugString():'';
                console.log(`    \x1B[38;5;142m[witness] ${label.label}${extra} stage:${def.stage} at:${def.sourceRef}\x1B[0m`);
            }
        }
        const debugFixed = Context.config.debugFixedColsMatch ?? (Context.config.debugFixedCols ?? false);
        if (debugFixed !== false) {
            if (typeof debugFixed === 'string') {
                const re = new RegExp(debugFixed);
                labels = this.fixeds.labelRanges.toArray().filter(x => re.test(x.label));
            } else {
                labels = this.fixeds.labelRanges.toArray();
            }
            for (const label of labels) {
                const def = this.fixeds.getDefinition(label.from);
                const extra = label.multiarray ? label.multiarray.toDebugString():'';
                console.log(`    \x1B[38;5;136m[fixed] ${label.label}${extra} at:${def.sourceRef}\x1B[0m`);
            }
        }

        const debugConstraints = Context.config.debugConstraintsMatch ?? false;
        if (debugConstraints !== false) {
            let re;
            if (typeof debugConstraints === 'string') {
                re = new RegExp(debugConstraints);
            } else {
                re = {test: () => true};
            }
            for (const constraint of this.constraints.constraints) {
                const text = this.constraints.getExpr(constraint.exprId).toString({hideClass: true});
                if (!re.test(text)) continue;
                console.log(`    \x1B[38;5;064m[constraint] ${text} at:${constraint.sourceRef}\x1B[0m`);
            }
        }
    }
    finalClosingAirGroups() {
        this.callDeferredFunctions('airgroup', 'final');
        let airGroupIdsClosed = [];

        // use newAirGroups to detect if new airgroups appers in last loop, only
        // exit of these loop when all airgroups are previously processed.
        let newAirGroups = true;
        while (newAirGroups) {
            newAirGroups = false;
            for (const airGroup of this.airGroups.values()) {
                const id = airGroup.id;
                if (id === false) continue;
                if (airGroupIdsClosed.includes(id)) continue;
                newAirGroups = true;
                airGroupIdsClosed.push(id);
                this.openAirGroup(airGroup);
                this.closeCurrentAirGroup();
            }
        }
    }
    airGroupProtoOut(airGroupId, airId) {
        if (Context.config.protoOut === false) return;

        let packed = new PackedExpressions();
        let chrono = new Chrono(Context.config.chronoProto ?? false);

        chrono.start();

        if (Context.air.outputFixedFile) {
            const t1 = performance.now();

            const filename = this.proto.setFixedColsToFile(this.fixeds, Context.air.outputFixedFile);
            chrono.step('PROTO-AIRGROUP-OUT-BEGIN-SET-FIXED-COLS');
            const t2 = performance.now();
            console.log(`  > Fixed File time: ${units.getHumanTime(t2-t1)} (${filename})`);
        } else {
            this.proto.setFixedCols(this.fixeds);
            chrono.step('PROTO-AIRGROUP-OUT-BEGIN-SET-FIXED-COLS');

            this.proto.setPeriodicCols(this.fixeds);
            chrono.step('PROTO-AIRGROUP-OUT-BEGIN-SET-PERIODIC-COLS');
        }
        this.proto.setWitnessCols(this.witness);
        chrono.step('PROTO-AIRGROUP-OUT-BEGIN-SET-WITNESS-COLS');

        this.proto.setCustomCols(this.customCols);
        chrono.step('PROTO-AIRGROUP-OUT-BEGIN-SET-CUSTOM-COLS');


        this.proto.setAirGroupValues(this.airGroupValues.getDataByAirGroupId(this.airGroupId),
                                     this.airGroupValues.getAggreationTypesByAirGroupId(this.airGroupId));

        this.proto.setAirValues(this.airValues.getValues());

        // this.expressions.pack(packed, {instances: [air.fixeds, air.witness]});
        this.expressions.pack(packed, {instances: [this.fixeds, this.witness, this.customCols]});
        chrono.step('PROTO-AIRGROUP-OUT-BEGIN-EXPRESSIONS-PACK');

        this.proto.setConstraints(this.constraints, packed,
            {
                labelsByType: {
                    witness: this.witness.labelRanges,
                    fixed: this.fixeds.labelRanges,
                    customCols: this.customCols.labelRanges,
                    airgroup: (id, options) => this.airGroupValues.getRelativeLabel(airGroupId, id, options)
                },
                expressions: this.expressions
            });
        chrono.step('PROTO-AIRGROUP-OUT-BEGIN-CONSTRAINTS');

        const info = {airId, airGroupId};
        this.proto.setSymbolsFromLabels(this.witness.getLabelRanges(), 'witness', info);
        this.proto.setSymbolsFromLabels(this.fixeds.getNonTemporalLabelRanges(), 'fixed', info);
        this.proto.setSymbolsFromLabels(this.customCols.getLabelRanges(), 'customcol', info);

        if (airId == 0) {
            this.airGroupValues.clearOnceLabels(airGroupId);
        }
        this.proto.setSymbolsFromLabels(this.airGroupValues.getOnceLabelsByAirGroupId(airGroupId, ['stage', 'relativeId']), 'airgroupvalue', {airGroupId});
        chrono.step('PROTO-AIRGROUP-OUT-BEGIN-SYMBOLS');

        this.proto.setSymbolsFromLabels(this.airValues.getLabels(['stage']), 'airvalue', info);

        const imSymbols = packed.expressionLabels.map((label, index) => typeof label === 'undefined' ? value : {label, from:index}).filter(x => typeof x !== 'undefined')
        this.proto.setSymbolsFromLabels(imSymbols, 'im', {...info, namePrefix: Context.airName + '.'});
        console.log(`  > Proto intermediates: ${imSymbols.length}`);

        this.proto.addHints(this.hints, packed, {
                airGroupId,
                airId
            });
        chrono.step('PROTO-AIRGROUP-OUT-BEGIN-HINTS');
        this.proto.setExpressions(packed);
        chrono.step('PROTO-AIRGROUP-OUT-BEGIN-EXPRESSIONS');
        chrono.end('PROTO-AIRGROUP-OUT-END');
    }
    finalAirScope() {
        this.callDeferredFunctions('air', 'final');
    }
    clearAirScope(label = '') {
        this.references.clearType('fixed', label);
        this.references.clearType('witness', label);
        this.references.clearType('customcol', label);
        this.references.clearType('airvalue', label);
        this.references.clearScope('air');
        this.expressions.clear(label);
        this.hints.clear();
    }
    pushAirScope(label = '') {
        this.references.pushType('fixed', label);
        this.references.pushType('witness', label);
        this.references.pushType('customcol', label);
        this.references.pushType('airvalue', label);
        this.references.pushScope('air');
        this.expressions.push(label);
        this.hints.push();
    }
    popAirScope(label = '') {
        this.references.popType('fixed', label);
        this.references.popType('witness', label);
        this.references.popType('customcol', label);
        this.references.popType('airvalue', label);
        this.references.popScope('air');
        this.expressions.pop(label);
        this.hints.pop();
    }
    finalAirGroupScope() {
        this.callDeferredFunctions('airgroup', 'final');
    }
    finalProofScope() {
        this.callDeferredFunctions('proof', 'final');
    }

    getDeferredScope(scope) {
        const airGroupId = Context.airGroupId === false || typeof Context.airGroupId === 'undefined' ? '':Context.airGroupId;
        return scope === 'airgroup' ? `airgroup#${airGroupId}` : scope;
    }
    callDeferredFunctions(scope, event) {
        const _scope = this.getDeferredScope(scope);
        const reentrantEnabled = !Context.config.disableReentrantDeferredCalls;
        let first = true;
        let processed = {};
        let previousDeferredCalls = [];
        let deferredCalls = false;
        let executedSomething = false;
        do {
            deferredCalls = this.deferredCalls[_scope] ? (this.deferredCalls[_scope][event] ?? false) : false;
            if (deferredCalls !== false) {
                deferredCalls = Object.entries(deferredCalls).map(([key, value]) => { return {...value, fname: key}}).sort((a, b) => Number(b.priority) - Number(a.priority));
            }
            if (first && deferredCalls && Context.config.logDeferredCalls) {
                if (deferredCalls === false) console.log(`  > [deferred call] no deferred calls \x1B[38;5;208m${scope}@${event}\x1B[0m`);
                else console.log(`  > [deferred call] execute ${first?'reentrant ':''}deferred calls \x1B[38;5;208m${scope}@${event}\x1B[0m  => [${deferredCalls ? deferredCalls.map(x => '\x1B[38;5;208m'+x.fname+(x.priority !== false ? '('+x.priority+')':'')+'\x1B[0m').join(','):''}]`);
            }
            if (deferredCalls === false) {
                break;
            }

            if (Context.config.logDeferredCalls) {
                if (!first && previousDeferredCalls.length !== deferredCalls.length) {
                    for (const deferredCall of deferredCalls) {
                        if (previousDeferredCalls.includes(deferredCall.fname)) continue;
                        console.log(`  > [deferred call] added a reentrant call \x1B[38;5;208m${deferredCall.fname+(deferredCall.priority !== false ? '('+deferredCall.priority+')':'')}\x1B[0m`);
                    }
                }
                previousDeferredCalls = deferredCalls.map(x => x.fname);
            }

            executedSomething = false;
            for (const deferredCall of deferredCalls) {
                const fname = deferredCall.fname;
                const priority = deferredCall.priority ?? false;
                if (processed[fname]) {
                    continue;
                }
                executedSomething = true;
                processed[fname] = true;
                if (Context.config.logDeferredCalls) {
                    console.log(`  > [deferred call] execute \x1B[38;5;208m${fname+(priority !== false ? '('+priority+')':'')}\x1B[0m`);
                }
                this.execCall({ op: 'call', function: {name: fname}, args: [] });
                if (reentrantEnabled) break;
            }
            first = false;
        } while (reentrantEnabled && executedSomething);
        if (deferredCalls !== false) {
            delete this.deferredCalls[_scope][event];
        }
    }
    execWitnessColDeclaration(s) {
        const features = Features.extractFeatures('witness', s.features, {stage: true});
        let res = this.declare(s, 'witness', false, true, features);
        if (features.bits !== undefined) {          
            for (let [name, id] of res) {
                let lastNameIndex = name.lastIndexOf('.');
                if (lastNameIndex !== -1) {
                    name = name.substring(lastNameIndex + 1);
                }
                let hint ={name, bits: features.bits[0]};
                if (features.bits[1] == 'signed') {
                    hint.signed = 1;
                }
                this.hints.define('witness_bits', hint);
            }
        }
    }
    execCustomColDeclaration(s) {
        let commit = this.commits.get(s.commit);
        if (!commit) {
            throw new Error(`Creating a custom column with commit "${s.commit}", but this commit "${s.commit}" doesn't found`);
        }
        const stage = typeof s.stage === 'string' ? Number(s.stage): commit.defaultStage;
        if (stage === false) {
            throw new Error(`Custom column for commit "${s.commit}" haven't defaul stage, need be specified for each custom column`);
        }
        this.declare(s, 'customcol', false, true, {stage: stage, commit });
    }
    execFixedColDeclaration(s) {
        const global = s.global ?? false;
        const features = Features.extractFeatures('fixed', s.features);
        for (const col of s.items) {
            const colname = Context.getFullName(col.name);
            const lengths = this.decodeLengths(col);
            let init = s.sequence ?? null;
            let initValue = null;
            if (init) {
                initValue = new Sequence(init, {maxSize: ExpressionItems.IntValue.castTo(this.references.get('N'))});
                if (Context.config.fixed !== false) initValue.extend();
            } else if (s.init) {
                initValue = s.init.instance();
            }
            let data = {...features, global};
            if (this.pragmas.nextFixed.bytes !== false) {
                data.bytes = this.pragmas.nextFixed.bytes;
                this.pragmas.nextFixed.bytes = false;
            }
            if (this.pragmas.nextFixed.temporal) {
                data.temporal = true;
                this.pragmas.nextFixed.temporal = false;
            }
            if (this.pragmas.nextFixed.external) {
                data.external = true;
                this.pragmas.nextFixed.external = false;
            }
            if (this.pragmas.nextFixed.loadFromFile) {
                data.loadFromFile = this.pragmas.nextFixed.loadFromFile;
                this.pragmas.nextFixed.loadFromFile = false;
            }
            if (initValue === null) {
                const loadData = this.currentAir.findExternFixedCol(colname);
                if (loadData !== false) {
                    initValue = loadData;
                }
            }
            this.declareFullReference(colname, 'fixed', lengths, data, initValue);
        }
    }
    execDebugger(s) {
        debugger;
    }
    execColDeclaration(s) {
        // intermediate column
        const global = s.global ?? false;
        for (const col of s.items) {
            const lengths = this.decodeLengths(col);
            const id = this.declareFullReference(col.name, col.reference ? '&im' : 'im', lengths, {global});

            let init = s.init;
            if (!init || !init || typeof init.instance !== 'function') {
                continue;
            }
            if (col.reference) {
                this.references.setReference(col.name, s.init.instance());
            } else {
                init = init.instance();
                this.expressions.set(id, init);
            }
        }
    }
    execPublicDeclaration(s) {
        this.declare(s, 'public', true, false);
        // TODO: initialization
        // TODO: verification defined
    }
    execCommitDeclaration(s) {
        const name = s.name;
        let commit = this.commits.get(name);
        // TODO: two scope
        if (commit) {
            throw new Error(`commit ${name} already defined on ${commit.sourceRef}`);
        }
        const scopeType = this.scope.getInstanceType();
        let publics = [];
        for (const cpublic of s.publics ?? []) {
            const ref = this.references.getReference(cpublic.name, false);
            if (ref === false) {
                throw new Error(`Not found reference ${cpublic.name} used on commit ${name}`);
            }
            if (ref.type !== 'public') {
                throw new Error(`Referenced ${cpublic.name} used on commit ${name} is a ${ref.type} not a public`);
            }
            const indexes = cpublic.indexes ? this.decodeIndexes(cpublic.indexes) : [];
            const value = ref.getItem(indexes);
            if (value instanceof ExpressionItems.ArrayOf) {
                publics.push.apply(publics, value.toOneArray());
            } else {
                publics.push(value);
            }
        }
        const stage = typeof s.stage === 'string' ? Number(s.stage): false;
        commit = new Commit(name, stage, publics, {sourceRef: Context.sourceTag, scope: scopeType});
        this.commits.define(name, commit);
    }
    execProofValueDeclaration(s) {
        this.declare(s, 'proofvalue', true, false, {stage: Number(s.stage)});
    }
    execAirGroupValueDeclaration(s) {
        const name = s.items[0].name ?? '';

        const scopeType = this.scope.getInstanceType();

        if (scopeType !== 'air') {
            throw new Error(`airgroupvalue ${name} must be declared inside air scope (current scope: ${scopeType})`);
        }

        if (s.aggregateType === false) {
            throw new Error(`airgroupvalue ${name} without aggregation type, aggregation type is mandatory`);
        }

        // resolve compiler expression
        const stage = this.value2num(s.stage, 'stage');

        const defaultValue = s.defaultValue ? this.value2num(s.defaultValue, 'defaultValue') : false;

        for (const value of s.items) {
            const lengths = this.decodeLengths(value);
            const data = {aggregateType: s.aggregateType, airGroupId: this.airGroupId, sourceRef: this.sourceRef, stage, defaultValue};
            const res = this.currentAirGroup.declareAirGroupValue(value.name, lengths, data, this.currentAir.id);
        }
    }
    value2num(value, label) {
        const res = ExpressionItem.value2num(value);
        if (res === false) {
            throw new Error(`Invalid value ${value} for ${label} on ${Context.sourceRef}`);
        }
        return res; 
    }
    value2bint(value, label) {
        const res = ExpressionItem.value2bint(value);
        if (res === false) {
            throw new Error(`Invalid value ${value} for ${label} on ${Context.sourceRef}`);
        }
        return res; 
    }
    execAirValueDeclaration(s) {
        const name = s.items[0].name ?? '';

        if (this.currentAir === false) {
            throw new Error(`airvalue ${name} must be declared inside airtemplate`);
        }
        for (const value of s.items) {
            const lengths = this.decodeLengths(value);
            const stage = s.stage;
            const res = this.currentAir.declareAirValue(value.name, lengths, {sourceRef: this.sourceRef, stage});
        }
    }
    execChallengeDeclaration(s) {
        this.declare(s, 'challenge', true, false, {stage: s.stage ? Number(s.stage):0});
        // TODO: initialization
        // TODO: verification defined
    }
    execDeferredFunctionCall(s) {
        const scope = s.scope;
        const fname = s.function.name;
        const event = s.event;
        const priority = s.priority === false ? false : s.priority.evalAsInt();
        if (s.args.length > 0) {
            throw new Error('deferred function call arguments are not yet supported');
        }
        if (event !== 'final') {
            throw new Error(`deferred function call event ${event} no supported`);
        }
        if (['proof', 'airgroup', 'air'].includes(scope) === false) {
            throw new Error(`deferred function call scope ${scope} no supported`);
        }

        const _scope = this.getDeferredScope(scope);
        if (typeof this.deferredCalls[_scope] === 'undefined') {
            this.deferredCalls[_scope] = {};
        }
        if (typeof this.deferredCalls[_scope][event] === 'undefined') {
            this.deferredCalls[_scope][event] = {};
        }
        const redundant = typeof this.deferredCalls[_scope][event][fname] !== 'undefined'
        if (!redundant) {
            this.deferredCalls[_scope][event][fname] = {priority: false, sourceRefs: []};
        }
        if (Context.config.logDeferredCalls && !redundant || Context.config.logRedundantDeferredCalls) {
            console.log(`  > [deferred call] ${redundant?'redundant ':''}register \x1B[38;5;208m${fname}\x1B[0m at ${Context.sourceTag} ${priority === false?'':('(priority:'+priority+') ')}on \x1B[38;5;208m${scope}@${event}\x1B[0m`);
        }
        this.deferredCalls[_scope][event][fname].sourceRefs.push(Context.sourceRef);
        const currentPriority = this.deferredCalls[_scope][event][fname].priority;
        if (priority !== false && (currentPriority === false || currentPriority < priority)) {
            this.deferredCalls[_scope][event][fname].priority = priority;
        }
    }
    checkVirtual(s) {
        if (!s.virtual) return;
        if (!s.expr.isAlone()) {
            throw new Error(`[${Context.sourceTag}] Invalid use of virtual, only to create virtual instances`);
        }
        const fcall = s.expr.getAloneOperand();
        if (!fcall instanceof ExpressionItems.FunctionCall) {
            throw new Error(`[${Context.sourceTag}]  Invalid use of virtual, only to create virtual instances`);
        }
        fcall.virtual = true;
        // check if function call is virtual is done his evaluation
    }
    execExpr(s) {
        let options = {};
        this.checkVirtual(s);
        if (s.alias) {
            options.alias = this.getAsString(s.alias);
        }
        s.expr.eval(options);
        // this.expressions.eval(s.expr);
    }
    decodeNameAndLengths(s) {
        return [s.name, this.decodeLengths(s)];
    }
    decodeIndexes(indexes) {
        let values = [];
        if (indexes) {
            for (const index of indexes) {
                values.push(Number(index.evalAsInt()));
            }
        }
        return values;
    }
    decodeLengths(s) {
        return this.decodeIndexes(s.lengths);
    }
    declare(s, type, ignoreInit, fullName = true, data = {}) {
        let res = [];
        for (const col of s.items) {
            const lengths = this.decodeLengths(col);
            let init = s.init;
            if (init && typeof init.instance === 'function') {
                init = init.instance();
            }
            let name = col.name;
            if (fullName) {
                name = Context.getFullName(col.name);
            }
            let id = this.declareReference(col.name, type, lengths, data, ignoreInit ? null : init);
            res.push([name, id]);
        }
        return res;
    }
    declareFullReference(name, type, lengths = [], data = {}, initValue = null) {
        const _name = Context.getFullName(name);
        return this.declareReference(_name, type, lengths, data, initValue);
    }
    declareReference(name, type, lengths = [], data = {}, initValue = null) {
        if (!data.sourceRef) {
            data.sourceRef = this.sourceRef;
        }
        const res = this.references.declare(name, type, lengths, data);
        if (initValue !== null) {
            this.references.set(name, [], initValue);
        }
        return res;
    }
    execCode(s) {
        return this.execute(s.statements,`CODE ${this.sourceRef}`);
    }
    addAirGroupValueDefaultValueConstraint(airId, airGroupValue, defaultValue) {
        if (airId === Context.airId) {
            const item = airGroupValue.reference.getItem();
            let expr = new Expression();
            expr.insertOperation('sub', [item, new ExpressionItems.FeValue(defaultValue)]);
            this.constraints.defineExpressionAsConstraint(expr);
        } else if (this.proto) {
            // adding directly to proto, becaused in this version all constraints of air was
            // cleared after stored in proto.
            this.proto.addAirGroupValueDefaultValueConstraint(airId, airGroupValue.data.airGroupId, airGroupValue.definition.relativeId, defaultValue);
        }
    }
    execConstraint(s) {
        const scopeType = this.scope.getInstanceType();

        assert.instanceOf(s.left, Expression);
        assert.instanceOf(s.right, Expression);

        if (Debug.active) s.left.dump('LEFT-CONSTRAINT 1');
        // s.right.dump('RIGHT-CONSTRAINT 1');
        const left = s.left.instance();
        // const right = s.right.instance();
        if (Debug.active) left.dump('LEFT-CONSTRAINT 2');
        // right.dump('RIGHT-CONSTRAINT 2');
        const _left = s.left.instance({simplify: true})
        const _right = s.right.instance({simplify: true});
        if (Debug.active) _left.dump('LEFT-CONSTRAINT 3');
        if (Debug.active) _right.dump('RIGHT-CONSTRAINT 3');
        let global = (scopeType === 'proof');

        const sourceTag = s.debug ?? Context.sourceRef;
        if (!global && scopeType !== 'air') {
            throw new Error(`Constraint definition on invalid scope (${scopeType}) ${sourceTag}`);
        }
        const constraints = global ? this.globalConstraints : this.constraints;
        const constraintId = constraints.getLastConstraintId();
        const id = constraints.define(_left, _right,false, sourceTag);

        if (Context.config.outputConstraints || (Context.config.outputGlobalConstraints && scopeType === 'proof')) {
            const prompt = global ? '> ': '  > ';
            const color = global ? '\x1B[38;2;93;240;0m': '\x1B[38;2;192;255;2m';
            const expr = constraints.getExpr(id);
            // draw constraint +1 to match with verify constraints message
            const prefix = `${prompt}${global ? 'Global ' : ''}Constraint #${constraintId+1} [${Context.proofLevel}]`;
            if (Context.config.bothConstraintsFormat || !Context.config.rawConstraintsFormat) {
                console.log(`${prefix} > ${color}${expr.toString({hideClass:true, hideLabel:false})} === 0\x1B[0m (${sourceTag})`);
            }
            if (Context.config.bothConstraintsFormat || Context.config.rawConstraintsFormat) {
                console.log(`${prefix} (RAW) > ${color}${expr.toString({hideClass:true, hideLabel:true})} === 0\x1B[0m (${sourceTag})`);
            }
        }
    }
    execVariableDeclaration(s) {
        if (Debug.active) console.log('VARIABLE DECLARATION '+Context.sourceRef+' init:'+s.init);
        const initialization = typeof s.init !== 'undefined';
        const count = s.items.length;

        if (s.multiple && s.init.length !== count) {
            this.error(s, `Mismatch between len of variables (${count}) and len of their inits (${inits.length})`);
        }

        for (let index = 0; index < count; ++index) {
            const [name, lengths] = this.decodeNameAndLengths(s.items[index]);
            const sourceRef = s.debug ?? this.sourceRef;
            const scope = s.scope ?? false;
            let initValue = null;
            if (initialization) {
                const init = s.multiple ? s.init.getItem([index]) : s.init;
                if (init instanceof ExpressionItems.ExpressionList) {
                    initValue = init.eval();
                } else {
                    if (Debug.active) console.log(name, s.vtype, Context.sourceRef);
                    switch (s.vtype) {
                        case 'expr':
                            initValue = init.instance().eval();
                            // initValue = init.eval();
                            break;
                        case 'int':
                            initValue = (s.multiple ? init.eval() : init.instance()).asIntItem();
                            // if (initValue.dump) initValue.dump(); else console.log(initValue);
                            break;
                        case 'string':
                            initValue = init.eval().asStringItem();
                            break;
                        default:
                            throw new Error(`Invalid variable type ${s.vtype} on ${Context.sourceRef}`);
                    }
                    if (Debug.active) console.log(name, s.vtype, initValue.toString ? initValue.toString() : initValue);
                }
            }            
            this.references.declare(name, s.vtype, lengths, { scope, sourceRef, const: s.const ?? false}, initValue);
            if (initValue !== null) {
                const initValueText = typeof initValue.toString === 'function' ? initValue.toString() : initValue;
                if (Debug.active) console.log(`ASSIGN(DECL) ${name} = ${initValueText} \x1B[0;90m[${Context.sourceTag}]\x1B[0m`);
                // this.references.set(name, [], initValue);
            }
        }
    }
    getAsString(s) {
        if (typeof s === 'string') return s;
        if (s.type === 'string') {
            if (!s.template) return s.value;
            return this.expandTemplates(s.value);
        }
        console.log(s);
        throw new Error('Invalid value to getAsString');
    }
    expandTemplates(text) {
        if (!text.includes('${')) {
            return text;
        }
        return this.evaluateTemplate(text);
    }

    evaluateTemplate(template, options = {}) {
        const regex = /\${[^}]*}/gm;
        let m;
        let tags = [];
        let lindex = 0;
        while ((m = regex.exec(template)) !== null) {
            if (m.index === regex.lastIndex) {
                regex.lastIndex++;
            }
            tags.push({pre: m.input.substring(lindex, m.index), expr: m[0].substring(2,m[0].length-1)});
            lindex = m.index + m[0].length;
        }
        const lastS = template.substring(lindex);

        // create a tag for each substitution string
        const codeTags = tags.map((x, index) => 'expr ____'+index+' = '+x.expr+";").join("\n");

        // this expressions aren't executed, only compiled for this reason
        // we don't need create a context.
        const compiledTags = this.compiler.parseExpression(codeTags);

        // evaluating different init of each tag
        const stringTags = compiledTags.map(e => e.statements.init.eval({unroll: true}).toString());

        // replace on string each tag for its value
        const evaluatedTemplate = stringTags.map((s, index) => tags[index].pre + s).join('')+lastS;
        if (Debug.active) console.log(`TEMPLATE "${template}" ==> "${evaluatedTemplate}"`);
        return evaluatedTemplate;
    }
    evaluateExpression(e){
        throw new Error('Not implemented');
    }
    execReturn(s) {
        const sourceRef = this.sourceRef;
        this.traceLog(`[RETURN.BEGIN ${sourceRef}] ${this.scope.deep}`);
        if (!this.insideFunction()) {
            throw new Error('Return is called out of function scope');
        }
        const res = (typeof s.value === 'undefined' || s.value === null) ? new ExpressionItems.IntValue() : s.value.instance();
        if (Debug.active) {
            console.log(res);
            console.log(res.eval());
        }
        this.traceLog(`[RETURN.END  ${sourceRef}] ${this.scope.deep}`);
        return new ReturnCmd(res);
    }
    e2value(e, s, title) {
        return e.evalAsValue();
    }
    pushInclude(dirname) {
        this.includeStack.push(dirname);
    }
    popInclude() {
        this.includeStack.pop();
    }
    getLastInclude() {
        return this.includeStack[this.includeStack.length - 1] ?? false;
    }
    extractAirTemplateMethods(statements) {
        let methods = [];
        let index = 0;
        while (index < statements.length) {
            if (statements[index].type === 'function_definition') {
                methods.push(statements.splice(index, 1)[0]);
            } else {
                index++;
            }
        }
        return methods;
    }
}
