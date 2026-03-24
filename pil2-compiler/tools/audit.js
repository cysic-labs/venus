#!/usr/bin/env node

const fs = require('fs');
const protobuf = require('protobufjs');
const util = require('util');
const { createHash } = require('node:crypto');

const argv = require("yargs")
    .usage("pilout_audit <pilout.file>")
    .option('H', { alias: 'hash', describe: 'Hash Fixed Columns' })
    .argv;

const AGGREGATION_TYPES = {
    SUM: 0,
    PROD: 1,
};

const SYMBOL_TYPES = {
    IM_COL: 0,
    FIXED_COL: 1,
    PERIODIC_COL: 2,
    WITNESS_COL: 3,
    PROOF_VALUE: 4,
    AIR_GROUP_VALUE: 5,
    PUBLIC_VALUE: 6,
    PUBLIC_TABLE: 7,
    CHALLENGE: 8,
    AIR_VALUE: 9,
    CUSTOM_COL: 10,
};

const HINT_FIELD_TYPES = {
    STRING: 0,
    OPERAND: 1,
    ARRAY: 2,
};

const airoutProto = require.resolve('../src/pilout.proto');
const log = {
            info: (tag, module) => console.log(tag + module),
        };

class AirOut {
    constructor() {
        const airoutFilename = argv._[0];
        this.color = {
            parentesis: '\x1b[36m',
            array: '\x1b[1;36m',
            operation: '\x1b[33m',
            constant: '\x1b[32m',
            intermediate: '\x1b[35m',
            off: '\x1b[0m'
        }
        this.fixedHash = {};
        this.color = false;
        this.config = {};
        this.config.hashFixed = argv.hash ?? false;
        this.uniqueSymbols = {};
        // this.color = {
        //     parentesis: '',
        //     operation: '',
        //     constant: '',
        //     intermediate: '',
        //     off: ''
        // }
        log.info("[audit]", "··· Loading airout...");

        const airoutEncoded = fs.readFileSync(airoutFilename);
        const AirOut = protobuf.loadSync(airoutProto).lookupType("PilOut");

        const decoded = AirOut.decode(airoutEncoded);
        Object.assign(this, AirOut.toObject(decoded));
        this.fixUndefinedData();

        this.preprocessAirout();
        this.checkFixed();

        this.printInfo();
        this.markDuplicatedSymbols();
        this.displaySymbols();
        this.verifyExpressions();
        this.verifyHints();
    }

    fixUndefinedData() {
        if (typeof this.airGroups === 'undefined') this.airGroups = [];
        if (typeof this.symbols === 'undefined') this.symbols = [];
        if (typeof this.hints === 'undefined') this.hints = [];
        if (typeof this.publicTables === 'undefined') this.publicTables = [];
        if (typeof this.expressions === 'undefined') this.expressions = [];
        if (typeof this.constraints === 'undefined') this.constraints = [];
    }
    preprocessAirout() {
        for(let i=0; i<this.airGroups.length; i++) {
            const airGroup = this.airGroups[i];
            airGroup.airGroupId = i;

            const subAirValues = this.getSubAirValuesByAirGroupId(i);

            for(let j=0; j<airGroup.airs.length; j++) {
                const air = airGroup.airs[j];
                air.airGroupId = i;
                air.airId = j;

                air.symbols = this.getSymbolsByAirGroupIdAirId(airGroup.airGroupId, air.airId);

                for(const subAirValue of subAirValues) {
                    air.symbols.push( { ...subAirValue, airId: j });
                }
                air.hints = this.getHintsByAirGroupIdAirId(airGroup.airGroupId, air.airId);
                air.numChallenges = this.numChallenges;
                air.aggregationTypes = airGroup.airGroupvalues;
            }
        }
    }

    hashFixed(air) {
        // air.symbols = this.getSymbolsByAirGroupIdAirId(airGroup.airGroupId, air.airId);
        let data = new BigUint64Array(8); // 64 bytes = 512 bits block of sha
        const ctx = {
                airId: air.airId,
                airGroupId: air.airGroupId,
            };
        for (let id = 0; id < air.fixedCols.length; id++) {
            const fixedCol = air.fixedCols[id];
            const symbol = this.getSymbol(ctx, id, false, SYMBOL_TYPES.FIXED_COL, false, false);
            if (!fixedCol.values) {
                console.log(`[audit]    Fixed ${symbol} without data`);
                continue;
            }
            console.log(`[audit]    Fixed ${symbol} calculating hash ....`);
            let index = 0;
            let sha256 = createHash('sha256');
            for (const value of fixedCol.values) {
                data[index] = this.buf2bint(value);
                index++;
                if (index === 8) {
                    sha256.update(Buffer.from(data.buffer));
                    index = 0;
                }
            }
            this.fixedHash[symbol] = `0x${sha256.digest('hex')}`;
        }
    }

    checkFixed() {
        for(let i=0; i<this.airGroups.length; i++) {
            const airGroup = this.airGroups[i];
            airGroup.airGroupId = i;

            const subAirValues = this.getSubAirValuesByAirGroupId(i);

            for(let j=0; j<airGroup.airs.length; j++) {
                const air = airGroup.airs[j];
                air.airGroupId = i;
                air.airId = j;

                if (this.config.hashFixed && air.fixedCols) {
                    this.hashFixed(air);
                }

                for(const subAirValue of subAirValues) {
                    air.symbols.push( { ...subAirValue, airId: j });
                }
                air.hints = this.getHintsByAirGroupIdAirId(airGroup.airGroupId, air.airId);
                air.numChallenges = this.numChallenges;
                air.aggregationTypes = airGroup.airGroupvalues;
            }
        }
    }

    printInfo() {
        log.info("[audit]", `··· AirOut Info`);
        log.info("[audit]", `    Name: ${this.name}`);
        log.info("[audit]", `    #AirGroups: ${this.airGroups.length}`);

        log.info("[audit]", `    #ProofValues: ${this.numProofValues}`);
        log.info("[audit]", `    #PublicValues: ${this.numPublicValues}`);

        if (this.publicTables) log.info("[audit]", `    #PublicTables: ${this.publicTables.length}`);
        if (this.expressions) log.info("[audit]", `    #Expressions: ${this.expressions.length}`);
        if (this.constraints) log.info("[audit]", `    #Constraints: ${this.constraints.length}`);
        if (this.hints) log.info("[audit]", `    #Hints: ${this.hints.length}`);
        if (this.symbols) log.info("[audit]", `    #Symbols: ${this.symbols.length}`);

        for (const airGroup of this.airGroups) this.printAirGroupInfo(airGroup);
    }

    printAirGroupInfo(airGroup) {
        log.info("[audit]", `    > AirGroup '${airGroup.name}':`);

        for(const air of airGroup.airs) this.printAirInfo(air);
    }

    printAirInfo(air) {
        log.info("[audit]", `       + Air '${air.name}'`);
        log.info("[audit]", `         NumRows:     ${air.numRows}`);
        if (air.stageWidths) log.info("[audit]", `         Stages:      ${air.stageWidths.length}`);
        if (air.customCommits) log.info("[audit]", `         Custom Commits:      ${air.customCommits.length}`);
        if (air.expressions) log.info("[audit]", `         Expressions: ${air.expressions.length}`);
        if (air.constraints) log.info("[audit]", `         Constraints: ${air.constraints.length}`);
    }

    get numAirGroups() {
        return this.airGroups === undefined ? 0 : this.airGroups.length;
    }

    get numStages() {
        return this.numChallenges?.length ?? 1;
    }
    getSymbolType(type) {
        switch (type) {
            case SYMBOL_TYPES.IM_COL: return 'IM_COL';
            case SYMBOL_TYPES.FIXED_COL: return 'FIXED_COL';
            case SYMBOL_TYPES.PERIODIC_COL: return 'PERIODIC_COL';
            case SYMBOL_TYPES.WITNESS_COL: return 'WITNESS_COL';
            case SYMBOL_TYPES.PROOF_VALUE: return 'PROOF_VALUE';
            case SYMBOL_TYPES.AIR_GROUP_VALUE: return 'AIR_GROUP_VALUE';
            case SYMBOL_TYPES.PUBLIC_VALUE: return 'PUBLIC_VALUE';
            case SYMBOL_TYPES.PUBLIC_TABLE: return 'PUBLIC_TABLE';
            case SYMBOL_TYPES.CHALLENGE: return 'CHALLENGE';
            case SYMBOL_TYPES.AIR_VALUE: return 'AIR_VALUE';
            case SYMBOL_TYPES.CUSTOM_COL: return 'CUSTOM_COL';
        }
        return `(${type})`;
    }
    getAirGroupById(airGroupId) {
        if(this.airGroups === undefined) return undefined;

        return this.airGroups[airGroupId];
    }

    getAirByAirGroupIdAirId(airGroupId, airId) {
        if(this.airGroups === undefined) return undefined;
        if(this.airGroups[airGroupId].airs === undefined) return undefined;

        const air = this.airGroups[airGroupId].airs[airId];
        air.airGroupId = airGroupId;
        air.airId = airId;
        return air;
    }

    getNumChallenges(stageId) {
        if(this.numChallenges === undefined) return 0;

        return this.numChallenges[stageId - 1];
    }

    //TODO access to AirOut numPublicValues ?

    //TODO access to AirOut AirOutPublicTables ?

    getExpressionById(expressionId) {
        if(this.expressions === undefined) return undefined;

        return this.expressions[expressionId];
    }

    getSymbolById(symbolId) {
        if(this.symbols === undefined) return undefined;

        return this.symbols.find(symbol => symbol.id === symbolId);
    }

    getSymbolByName(name) {
        if(this.symbols === undefined) return undefined;

        return this.symbols.find(symbol => symbol.name === name);
    }

    getSymbolsByAirGroupId(airGroupId) {
        if(this.symbols === undefined) return [];

        return this.symbols.filter(symbol => symbol.airGroupId === airGroupId);
    }

    getSubAirValuesByAirGroupId(airGroupId) {
        if(this.symbols === undefined) return [];

        return this.symbols.filter(symbol => symbol.airGroupId === airGroupId && symbol.type === SYMBOL_TYPES.AIR_GROUP_VALUE && symbol.airId === undefined);
    }

    getSymbolsByAirId(airId) {
        if(this.symbols === undefined) return [];

        return this.symbols.filter(symbol => symbol.airId === airId);
    }

    getSymbolsByAirGroupIdAirId(airGroupId, airId) {
        if(this.symbols === undefined) return [];

        return this.symbols.filter(
            (symbol) => (symbol.airGroupId === undefined) || (symbol.airGroupId === airGroupId && symbol.airId === airId));
    }

    getSymbolsByStage(airGroupId, airId, stageId, symbolType) {
        if (this.symbols === undefined) return [];

        const symbols = this.symbols.filter(symbol =>
            symbol.airGroupId === airGroupId &&
            symbol.airId === airId &&
            symbol.stage === stageId &&
            (symbolType === undefined || symbol.type === symbolType)
        );

        return symbols.sort((a, b) => a.id - b.id);
    }

    getColsByAirGroupIdAirId(airGroupId, airId) {
        if (this.symbols === undefined) return [];

        const symbols = this.symbols.filter(symbol =>
            symbol.airGroupId === airGroupId &&
            symbol.airId === airId &&
            ([1, 2, 3].includes(symbol.type))
        );

        return symbols.sort((a, b) => a.id - b.id);
    }

    getWitnessSymbolsByStage(airGroupId, airId, stageId) {
        return this.getSymbolsByStage(airGroupId, airId, stageId, SYMBOL_TYPES.WITNESS_COL);
    }

    getSymbolByName(name) {
        if(this.symbols === undefined) return undefined;

        return this.symbols.find(symbol => symbol.name === name);
    }
    getIntermediatesByAir(airGroupId, airId) {
        if(this.symbols === undefined) return undefined;

        return this.symbols.filter(symbol => symbol.type === SYMBOL_TYPES.IM_COL && symbol.airGroupId === airGroupId && symbol.airId === airId);
    }

    getHintById(hintId) {
        if(this.hints === undefined) return undefined;

        return this.hints[hintId];
    }

    getHintsByAirGroupId(airGroupId) {
        if(this.hints === undefined) return [];

        return this.hints.filter(hint => hint.airGroupId === airGroupId);
    }

    getHintsByAirId(airId) {
        if(this.hints === undefined) return [];

        return this.hints.filter(hint => hint.airId === airId);
    }

    getHintsByAirGroupIdAirId(airGroupId, airId) {
        if(this.hints === undefined) return [];

        return this.hints.filter(
            (hint) => (hint.airGroupId === undefined) || ( hint.airGroupId === airGroupId && hint.airId === airId));
    }
    verifyExpressions() {
        for (let airGroupId = 0; airGroupId < this.airGroups.length; ++airGroupId) {
            for (let airId = 0; airId < this.airGroups[airGroupId].airs.length; ++airId) {
                this.verifyAirExpressions(airGroupId, airId);
                this.verifyAirConstraints(airGroupId, airId);
                this.showAirIntermediates(airGroupId, airId);
            }
        }
        this.verifyGlobalConstraints();
    }
    verifyHints() {
        console.log('#### HINTS ####');
        for (let hintId = 0; hintId < this.hints.length; ++hintId) {
            const hint = this.hints[hintId];
            const name = hint.name;
            const airGroupId = hint.airGroupId ?? false;
            const airId = hint.airId ?? false;
            const expressions = airGroupId === false && airId === false ? this.expressions : this.airGroups[airGroupId].airs[airId].expressions;
            let referenced = new Array(expressions.length).fill(false);
            let ctx = {path: '', airGroupId, airId, expressions, referenced};
            let res = [];
            for (let hintFieldId = 0; hintFieldId < hint.hintFields.length; ++hintFieldId) {
                ctx.path = `[S:${airGroupId} A:${airId}] ${name} [${hintFieldId}]`;                
                res.push(this.verifyHintField(ctx, hintFieldId, hint.hintFields[hintFieldId]));
            }
            if (res.length === 1) {
                console.log(`@${name}${res[0]}`);
            } else {
                console.log(`@${name}{${res.join(", ")}}`);
            }
        }
    }
    verifyHintField(ctx, index, hintField) {
        const name = (hintField.name ?? '#noname#') + '[' + index + ']';
        const cls = Object.keys(hintField).filter(x => x !== 'name')[0];
        const data = hintField[cls];
        const _ctxpath = ctx.path;
        let res = (hintField.name === undefined ? '' : hintField.name + ':');
        switch (cls) {
            case 'stringValue':
                res += `"${data}"`;
                break;
            case 'operand':
                ctx.path = `${_ctxpath}${name}`;
                this.verifyExpressionOperand(ctx, data);
                res += this.operandToString(ctx, false, data).trim();
                break;
            case 'hintFieldArray': {
                let lres = [];
                for (let hintFieldIndex = 0; hintFieldIndex < data.hintFields.length; ++hintFieldIndex) {
                    ctx.path = `${_ctxpath}${name}[${hintFieldIndex}]`;
                    lres.push(this.verifyHintField(ctx, hintFieldIndex, data.hintFields[hintFieldIndex]).trim());
                }
                res += '{' + lres.join(', ') + '}';
                break;
            }
            default:
                throw new Error(`${_ctxpath} @${name} invalid cls:${cls}`);
        }
        ctx.path = _ctxpath;
        return res;
    }
    colorString(text, color) {
        if (this.color) {
            return `\x1B[${color}${text}\x1B[0m`;
        } else {
            return text;
        }
    }
    log(msg, color = '') {
        console.log(this.colorString(msg, color));
    }
    verifyAirExpressions(airGroupId, airId) {
        const air = this.airGroups[airGroupId].airs[airId];
        const expressions = air.expressions ?? [];
        const expressionsCount = expressions.length;
        // TODO: detect circular dependencies
        let referenced = new Array(expressionsCount).fill(false);
        let ctx = {path: `[airGroup:${airGroupId} air:${airId}]`, air: air.name, referenced, expressions, airGroupId, airId};
        this.log(`##### AIR: ${air.name} (expressions:${expressionsCount}) #####`,'1;36m');
        for (let expressionId = 0; expressionId < expressionsCount; ++expressionId) {
            if (expressionId % 1000 === 0 && expressionId) {
                console.log(`verify expression air:${airId} ${expressionId}/${expressionsCount}....`);
            }
            ctx.referenced[expressionId] = true;
            this.verifyExpression(ctx, expressionId, expressions[expressionId]);
            ctx.referenced[expressionId] = false;
        }
    }
    clearCacheDegree() {
        this.cacheDegree = {};
    }
    verifyAirConstraints(airGroupId, airId) {
        const air = this.airGroups[airGroupId].airs[airId];
        const expressions = air.expressions ?? [];
        const constraints = air.constraints ?? [];
        const expressionsCount = expressions.length;
        // TODO: detect circular dependencies
        let referenced = new Array(expressionsCount).fill(false);
        let ctx = {path: `[airGroup:${airGroupId} air:${airId}]`, air: air.name, referenced, expressions, airGroupId, airId};
        this.log(`##### AIR: ${air.name} (constraints:${constraints.length}) #####`, '1;36m');
        this.clearCacheDegree();
        for (let constraintId = 0; constraintId < constraints.length; ++constraintId) {
            const constraint = constraints[constraintId];
            const frame = Object.keys(constraint)[0];
            const constraintData = constraint[frame];
            const expressionId = constraintData.expressionIdx.idx;
            this.log(`‣ constraint ${constraintId} => ${constraintData.debugLine}`, '38;2;192;255;2m');
            ctx.referenced[expressionId] = true;
            const res = this.expressionToString(ctx, expressionId, expressions[expressionId]);
            const degree = this.expressionDegree(ctx, expressionId, expressions[expressionId]);
            console.log(`CONSTRAINT.${constraintId} [${(degree > 3 && this.color) ? '\x1B[1;31m' + degree + '\x1B[0m' : degree}] ${res}`);
            ctx.referenced[expressionId] = false;
        }
    }
    showAirIntermediates(airGroupId, airId) {
        const air = this.airGroups[airGroupId].airs[airId];
        const expressions = air.expressions ?? [];
        const intermediates = this.getIntermediatesByAir(airGroupId, airId);
        const expressionsCount = expressions.length;
        let referenced = new Array(expressionsCount).fill(false);
        let ctx = {path: `[airGroup:${airGroupId} air:${airId}]`, air: air.name, referenced, expressions, airGroupId, airId};
        this.log(`##### AIR: ${air.name} (intermediates:${intermediates.length}) #####`, '1;36m');

        for (let index = 0; index < intermediates.length; ++index) {
            const intermediate = intermediates[index];
            const expressionId = intermediate.id;
            ctx.referenced[expressionId] = true;
            console.log(intermediate.name + '@' + intermediate.id +': ' + this.expressionToString(ctx, expressionId, expressions[expressionId]));
            ctx.referenced[expressionId] = false;
        }
    }
    verifyGlobalConstraints() {
        const expressions = this.expressions ?? [];
        const constraints = this.constraints ?? [];
        const expressionsCount = expressions.length;
        // TODO: detect circular dependencies
        let referenced = new Array(expressionsCount).fill(false);
        let ctx = {path: `[global]`, referenced, expressions};
        this.log(`##### GLOBAL  #####`, '1;36m');
        for (let constraintId = 0; constraintId < constraints.length; ++constraintId) {
            console.log(`--- constraint ${constraintId+1}/${constraints.length} ---`);
            const constraint = constraints[constraintId];
            const expressionId = constraint.expressionIdx.idx;
            ctx.referenced[expressionId] = true;
            const res = this.expressionToString(ctx, expressionId, expressions[expressionId]);
            const degree = this.expressionDegree(ctx, expressionId, expressions[expressionId]);
            console.log(`CONSTRAINT.${constraintId} [${(this.color && degree > 3) ? '\x1B[1;31m' + degree + '\x1B[0m' : degree}] ${res}`);
            ctx.referenced[expressionId] = false;
        }
    }
    verifyExpression(ctx, idx, expression) {
        const cls = Object.keys(expression)[0];
        const data = expression[cls];
        const _ctxpath = ctx.path;
        switch (cls) {
            case 'add':
            case 'sub':
            case 'mul':
                ctx.path = _ctxpath + `[@${idx} ${cls} lhs]`;
                this.verifyExpressionOperand(ctx, data.lhs);
                ctx.path = _ctxpath + `[@${idx} ${cls} rhs]`;
                this.verifyExpressionOperand(ctx, data.rhs);
                break;
            case 'neg':
                ctx.path = _ctxpath + `[@${idx} ${cls} value]`;
                this.verifyExpressionOperand(ctx, data.value);
                break;
            default:
                throw new Error(`${_ctxpath} @${idx} invalid cls:${cls}`);
        }
        ctx.path = _ctxpath;
    }
    verifyExpressionOperand(ctx, operand) {
        const cls = Object.keys(operand)[0];
        const data = operand[cls];
        switch (cls) {
            case 'constant':
                break;
            case 'challenge':
                // TODO: verify challenge
                break;
            case 'proofValue':
                // TODO: verify proofValue
                break;
            case 'airGroupValue':
                // TODO: verify airGroupValue
                break;
            case 'airValue':
                // TODO: verify airGroupValue
                break;
            case 'publicValue':
                // TODO: verify publicValue
                break;
            case 'periodicCol':
                // TODO: verify periodicCol
                break;
            case 'fixedCol':
                // TODO: verify fixedCol
                break;
            case 'witnessCol':
                // TODO: verify witnessCol
                break;
            case 'customCol':
                // TODO: verify customCol
                break;
            case 'expression': {
                    const idx = data.idx;
                    if (idx >= ctx.expressions.length) {
                        throw new Error(`${ctx.path} invalid expression idx:${idx}`);
                    }
                    if (ctx.referenced[idx]) {
                        throw new Error(`${ctx.path} circular reference idx:${idx}`);
                    }
                    ctx.referenced[idx] = true;
                    this.verifyExpression(ctx, idx, ctx.expressions[idx]);
                    ctx.referenced[idx] = false;
                    return this.expressionToString(ctx, idx, ctx.expressions[idx]);
                }
                break;
            default:
                throw new Error(`invalid cls:${cls}`);
        }
        return '';
    }

    expressionToString(ctx, id, expression) {
        let res = this._expressionToString(ctx, id, expression);
        res = res.replace(/\s+/g, ' ')
                .replace(/\(\s+\(/g, '((')
                .replace(/\)\s+\)/g, '))')
                .replace(/\(\s+/g, '(')
                .replace(/\s+\)/g, ')');
        if (this.color) {
            res = res.replace(/([\[\]])/g, this.color.array + '$1' + this.color.off)
                     .replace(/(?<![@A-Za-z_0-9])([0-9]+)(\W)/g, this.color.constant + '$1' + this.color.off + '$2')
                     .replace(/([\(\)]+)/g, this.color.parentesis + '$1' + this.color.off)
                     .replace(/([\+\*\-]+)/g, this.color.operation + '$1' + this.color.off);
        }
        return res;
    }

    _expressionToString(ctx, id, expression, parentOperation = false) {
        const cls = Object.keys(expression)[0];
        const data = expression[cls];
        const OP2CLS = {add: '+', sub: '-', mul: '*', neg: '-'};
        const op = OP2CLS[cls] ?? '???';
        switch (cls) {
            case 'add':
            case 'sub':
            case 'mul': {
                const lhs = this.operandToString(ctx, id, data.lhs, cls);
                const rhs = this.operandToString(ctx, id, data.rhs, cls);
                if (typeof lhs === 'undefined' || typeof rhs === 'undefined') {
                    console.log(util.inspect(expression, true, null, true));
                    EXIT_HERE;
                }
                const noParentesis = parentOperation === false ||
                                     (parentOperation == 'add' && cls == 'add') || (parentOperation == 'mul' && cls == 'mul');
                                     (parentOperation == 'add' && cls == 'mul') || (parentOperation == 'sub' && cls == 'mul');
                return `${noParentesis ? ' ':'('}${lhs} ${op} ${rhs}${noParentesis ? ' ':')'}`;
            }
            case 'neg': {
                const value = this.operandToString(ctx, id, data.value, cls);
                if (typeof value === 'undefined') {
                    console.log(util.inspect(data, true, null, true));
                    throw new Error(`${_ctxpath} @${idx} invalid negation operand`);
                }
                return `-(${value})`;
            }
            default:
                throw new Error(`${_ctxpath} @${idx} invalid cls:${cls}`);
        }
        // ctx.path = _ctxpath;
    }
    displaySymbol(symbol) {
        let name = symbol.name;
        if (symbol.dim || symbol.lengths) {
            let dim = symbol.dim ?? 0;
            if (symbol.lengths && symbol.lengths.length > dim) {
                dim = symbol.lengths.length;
            }
            if (dim) {
                let indexes = [];
                for (let idim = 0; idim < dim; ++idim) {
                    const length = symbol.lengths ? (symbol.lengths[idim] ?? 0) : 0;
                    if (idim < dim) indexes.push(length);
                    else indexes.push(`*${length}`);
                }
                name += '[' + indexes.join('][') + ']';
            }
        }
        let text;
        try {
            text = name.padEnd(40) + '|' + symbol.id.toString().padStart(5) + '|' + this.getSymbolType(symbol.type).padEnd(20) + '|' + (symbol.stage ?? '').toString().padStart(5) +
                    '|' + (symbol.airGroupId ?? '').toString().padStart(5) + '|' + (symbol.airId ?? '').toString().padStart(4) + '|' + (symbol.commitId ?? '').toString().padStart(6)+ '|' + (symbol.type === SYMBOL_TYPES.FIXED_COL ? (this.fixedHash[name] ?? '' )+' ':'') + symbol.debugLine;
        } catch(e) {
            console.log(symbol);
            throw e;
        }
        console.log(text);

    }
    markDuplicatedSymbols() {
        for (let index = 0; index < this.symbols.length; ++index) {
            const key = this.symbols[index].name + '___' + this.symbols[index].airGroupId + '___' + this.symbols[index].airId;
            if (typeof this.uniqueSymbols[key] === 'undefined') {
                this.uniqueSymbols[key] = 0;
            } else {         
                ++this.uniqueSymbols[key];
            }
        }
    }
    displaySymbols() {
        console.log('\n\x1B[44mname                                    |   id|type                |stage|group| air|commit|debug                                                                   \x1B[0m');
        for (let index = 0; index < this.symbols.length; ++index) {
            this.displaySymbol(this.symbols[index]);
        }
    }
    getUniqueSymbolName(ctx, symbol, id) {
        const key = symbol.name + '___' + symbol.airGroupId + '___' + symbol.airId;
        return this.uniqueSymbols[key] > 0 ? `${symbol.name}@${id}` : symbol.name;
    }
    getSymbol(ctx, id, stage, type, commitId, defaultResult) {
        // TODO: row_offset
        if (typeof type === 'undefined') {
            console.log(id, stage, type);
            EXIT_HERE;
        }
        let res = defaultResult;
        const _commitId = commitId ?? false;
        const _stage = stage ?? false;
        for (let index = 0; index < this.symbols.length; ++index) {
            let symbol = this.symbols[index];
            if (symbol.type !== type) continue;
            if (typeof symbol.airGroupId !== 'undefined' && symbol.airGroupId !== ctx.airGroupId) continue;
            if (typeof symbol.airId !== 'undefined' && symbol.airId !== ctx.airId) continue;
            // stage is optional
            if (typeof symbol.stage !== 'undefined' && _stage !== false && symbol.stage !== stage) continue;
            if (typeof symbol.commitId !== 'undefined' && _commitId !== false && symbol.commitId !== commitId) continue;
            if (symbol.dim) {
                if (id < symbol.id) continue;
                this.initOffsets(symbol);
                if (id >= (symbol.id + symbol._size)) continue;
                const name = this.getUniqueSymbolName(ctx, symbol, id);
                res = name + this.offsetToIndexesString(id - symbol.id, symbol);
                break;
            } else if (id == symbol.id) {
                res = this.getUniqueSymbolName(ctx, symbol, id);
                break;
            }
        }
        if (typeof res !== 'undefined') {
            if (typeof res === 'string' && res.startsWith(ctx.air + '.')) {
                return res.substring(ctx.air.length + 1);
            }
            return res;
        }

        throw new Error(`NOT FOUND SYMBOL g:${ctx.airGroupId} a:${ctx.airId} s:${stage} t:${this.getSymbolType(type)} id:${id})`);
    }
    buf2bint(buf) {
        let value = 0n;
        let offset = 0;
        while ((buf.length - offset) >= 8) {
            value = (value << 64n) + buf.readBigUInt64BE(offset);
            offset += 8;
        }
        while ((buf.length - offset) >= 4) {
            value = (value << 32n) + BigInt(buf.readUInt32BE(offset));
            offset += 4;
        }
        while ((buf.length - offset) >= 2) {
            value = (value << 16n) + BigInt(buf.readUInt16BE(offset));
            offset += 2;
        }
        while ((buf.length - offset) >= 1) {
            value = (value << 8n) + BigInt(buf.readUInt8(offset));
            offset += 1;
        }
        return value;
    }
    operandToString(ctx, id, operand, parentOperation = false) {
        let res = this._operandToString(ctx, id, operand, parentOperation);
        const cls = Object.keys(operand)[0];
        const rowOffset = operand[cls].rowOffset ?? false;
        if (rowOffset) {
            if (rowOffset > 0) {
                res = `${res}'${rowOffset == 1 ? '':rowOffset}`;
            } else {
                res = `${rowOffset == -1 ? '':-rowOffset}'${res}` ;
            }
        }
        return res;
    }
    _operandToString(ctx, id, operand, parentOperation = false) {
        const cls = Object.keys(operand)[0];
        const data = operand[cls];
        switch (cls) {
            case 'constant':
                if (data.value instanceof Buffer) {
                    return this.buf2bint(data.value).toString();
                }
                EXIT_HERE;
                return data.value.toString();
            case 'challenge':
                return this.getSymbol(ctx, data.idx, data.stage, SYMBOL_TYPES.CHALLENGE);
            case 'proofValue':
                return this.getSymbol(ctx, data.idx, data.stage, SYMBOL_TYPES.PROOF_VALUE);
            case 'airGroupValue':
                return this.getSymbol({airGroupId: data.airGroupId, ...ctx}, data.idx, false, SYMBOL_TYPES.AIR_GROUP_VALUE);
            case 'airValue':
                return this.getSymbol(ctx, data.idx, data.stage, SYMBOL_TYPES.AIR_VALUE);
            case 'publicValue':
                return this.getSymbol(ctx, data.idx, data.stage, SYMBOL_TYPES.PUBLIC_VALUE);
            case 'periodicCol':
                return this.getSymbol(ctx, data.idx, data.stage, SYMBOL_TYPES.PERIODIC_COL);
            case 'witnessCol':
                return this.getSymbol(ctx, data.colIdx, data.stage, SYMBOL_TYPES.WITNESS_COL);
            case 'customCol':
                return this.getSymbol(ctx, data.colIdx, data.stage, SYMBOL_TYPES.CUSTOM_COL, data.commitId);
            case 'fixedCol':
                return this.getSymbol(ctx, data.idx, 0, SYMBOL_TYPES.FIXED_COL);
            case 'expression': {
                    const idx = data.idx;
                    const intermediate = this.getSymbol(ctx, data.idx, 0, SYMBOL_TYPES.IM_COL, false, false);
                    if (intermediate !==  false) {
                        return intermediate;
                    }
                    if (idx >= ctx.expressions.length) {
                        console.log(cls, idx, data);
                        throw new Error(`${ctx.path} invalid expression idx:${idx}`);
                        // console.log(`ERROR !!! ${ctx.path} invalid expression idx:${idx} [max:${ctx.expressions.length - 1}]`);
                        // break;
                    }
                    if (ctx.referenced[idx]) {
                        console.log(cls, idx, data);
                        throw new Error(`${ctx.path} circular reference idx:${idx}`);
                    }
                    ctx.referenced[idx] = true;
                    const res = this._expressionToString(ctx, idx, ctx.expressions[idx], parentOperation);
                    ctx.referenced[idx] = false;
                    return res;
                }
                break;
            default:
                throw new Error(`invalid cls:${cls}`);
        }
    }

    offsetToIndexesString(offset, info) {
        return '['+this.offsetToIndexes(offset, info).join('][')+']';
    }
    offsetToIndexes(offset, info) {
        let level = 0;
        let indexes = [];
        while (level < info.dim) {
            info._size = info._offsets[level];
            indexes.push(Math.floor(offset/info._size));
            offset = offset % info._size;
            ++level;
        }
        return indexes;
    }
    initOffsets(info) {
        if (!info.dim || typeof info._offset !== 'undefined') return;
        info._offsets = [1];
        let size = 1;
        for (let idim = info.dim - 1; idim > 0; --idim) {
            size = size * info.lengths[idim];
            info._offsets.unshift(size);
        }
        // for size multiplies first offset by length of first dimension
        info._size = size * info.lengths[0];
    }
    expressionDegree(ctx, id, expression) {
        const cls = Object.keys(expression)[0];
        const data = expression[cls];
        switch (cls) {
            case 'add':
            case 'sub':
            case 'mul':
                const lhs = this.operandDegree(ctx, id, data.lhs);
                const rhs = this.operandDegree(ctx, id, data.rhs);
                if (cls === 'mul') return lhs + rhs;
                return lhs > rhs ? lhs : rhs;
            case 'neg':
                return this.operandDegree(ctx, id, data.value);
            default:
                throw new Error(`${_ctxpath} @${idx} invalid cls:${cls}`);
        }
    }
    operandDegree(ctx, id, operand) {
        const cls = Object.keys(operand)[0];
        const data = operand[cls];
        switch (cls) {
            case 'constant':
            case 'challenge':
            case 'proofValue':
            case 'airGroupValue':
            case 'airValue':
            case 'publicValue':
                return 0;
            case 'periodicCol':
            case 'witnessCol':
            case 'fixedCol':
            case 'customCol':
                return 1;
            case 'expression': {
                    const idx = data.idx;
                    let res = this.cacheDegree[idx];
                    if (typeof res !== 'undefined') {
                        return res;
                    }
                    if (ctx.referenced[idx]) {
                        console.log(cls, idx, data);
                        throw new Error(`${ctx.path} circular reference idx:${idx}`);
                    }
                    ctx.referenced[idx] = true;
                    res = this.expressionDegree(ctx, idx, ctx.expressions[idx]);
                    this.cacheDegree[idx] = res;
                    ctx.referenced[idx] = false;
                    return res;
                }
            default:
                throw new Error(`invalid cls:${cls}`);
        }
    }

}

module.exports = {
    AirOut,
    AGGREGATION_TYPES,
    SYMBOL_TYPES,
    HINT_FIELD_TYPES,
};

const airOut = new AirOut();
