const protobuf = require('protobufjs');
const {cloneDeep} = require('lodash');
const Long = require('long');
const fs = require('fs');
const util = require('util');
const assert = require('./assert.js');
const Context = require('./context.js');
const StringValue = require('./expression_items/string_value.js');
const IntValue = require('./expression_items/int_value.js');
const FixedFile = require('./fixed_file.js');

const MAX_CHALLENGE = 200;
const MAX_STAGE = 20;
const MAX_PERIODIC_COLS = 60;
const MAX_PERIODIC_ROWS = 256;
const MAX_ROWS = 2 ** 28;
const MAX_FIXED_COLS = 150;
const MAX_PUBLICS = 50;

const GLOBAL_EXPRESSIONS = 1000;
const GLOBAL_CONSTRAINTS = 100;

const REF_TYPE_IM_COL = 0;
const REF_TYPE_FIXED_COL = 1;
const REF_TYPE_PERIODIC_COL = 2;
const REF_TYPE_WITNESS_COL = 3;
const REF_TYPE_PROOF_VALUE = 4;
const REF_TYPE_AIR_GROUP_VALUE = 5;
const REF_TYPE_PUBLIC_VALUE = 6;
const REF_TYPE_PUBLIC_TABLE = 7;
const REF_TYPE_CHALLENGE = 8;
const REF_TYPE_AIR_VALUE = 9;
const REF_TYPE_CUSTOM_COL = 10;

const SPV_AGGREGATIONS = ['sum', 'prod'];

module.exports = class ProtoOut {
    constructor (Fr, options = {}) {
        this.version = 2;
        this.avoidAirsWithSameName = true;
        this.Fr = Fr;
        this.root = protobuf.loadSync(__dirname + '/pilout.proto');
        this.constants = false;
        this.debug = false;
        this.symbols = true;
        this.varbytes = true;
        this.airs = [];
        this.currentAir = null;
        this.currentAirGroup = null;
        this.witnessId2ProtoId = [];
        this.fixedId2ProtoId = [];
        this.customId2ProtoId = [];
        this.options = options;
        this.bigIntType = options.bigIntType ?? 'Buffer';
        this.toBaseField = this.mapBigIntType();
        this.airStack = [];
        this.buildTypes();
    }
    mapBigIntType() {
        switch (this.bigIntType) {
            case 'Buffer': return this.bint2buf;
            case 'BigInt': return this.bint2bint;
            case 'uint8':
                this.uint8size = this.options.uint8size ?? 8;
                return this.bint2uint8;
        }
        throw new Error(`Invalid bigIntType ${this.bigIntType} on ProtoOut`);
    }
    buildTypes() {
        this.PilOut = this.root.lookupType('PilOut');
        this.AirGroup = this.root.lookupType('AirGroup');
        this.Air = this.root.lookupType('Air');
        this.PublicTable = this.root.lookupType('PublicTable');
        this.GlobalExpression = this.root.lookupType('GlobalExpression');
        this.GlobalConstraint = this.root.lookupType('GlobalConstraint');
        this.Symbol = this.root.lookupType('Symbol');
        this.GlobalOperand = this.root.lookupType('GlobalOperand');
        this.GlobalExpression_Add = this.root.lookupType('GlobalExpression.Add');
        this.GlobalExpression_Sub = this.root.lookupType('GlobalExpression.Sub');
        this.GlobalExpression_Mul = this.root.lookupType('GlobalExpression.Mul');
        this.GlobalExpression_Neg = this.root.lookupType('GlobalExpression.Neg');
        this.GlobalOperand_Constant = this.root.lookupType('GlobalOperand.Constant');
        this.GlobalOperand_Challenge = this.root.lookupType('GlobalOperand.Challenge');
        this.GlobalOperand_AirGroupValue = this.root.lookupType('GlobalOperand.AirGroupValue');
        this.GlobalOperand_ProofValue = this.root.lookupType('GlobalOperand.ProofValue');
        this.GlobalOperand_PublicValue = this.root.lookupType('GlobalOperand.PublicValue');
        this.GlobalOperand_PublicTableAggregateValue = this.root.lookupType('GlobalOperand.PublicTableAggregatedValue');
        this.GlobalOperand_PublicTableColumn = this.root.lookupType('GlobalOperand.PublicTableColumn');
        this.GlobalOperand_Expression = this.root.lookupType('GlobalOperand.Expression');
        this.PeriodicCol = this.root.lookupType('PeriodicCol');
        this.FixedCol = this.root.lookupType('FixedCol');
        this.Expression = this.root.lookupType('Expression');
        this.Constraint = this.root.lookupType('Constraint');
        this.Operand_Expression = this.root.lookupType('Operand.Expression');
        this.Constraint_FirstRow = this.root.lookupType('Constraint.FirstRow');
        this.Constraint_LastRow = this.root.lookupType('Constraint.LastRow');
        this.Constraint_EveryRow = this.root.lookupType('Constraint.EveryRow');
        this.Constraint_EveryFrame = this.root.lookupType('Constraint.EveryFrame');
        this.Operand_Constant = this.root.lookupType('Operand.Constant');
        this.Operand_Challenge = this.root.lookupType('Operand.Challenge');
        this.Operand_AirGropValue = this.root.lookupType('Operand.AirGroupValue');
        this.Operand_AirValue = this.root.lookupType('Operand.AirValue');
        this.Operand_ProofValue = this.root.lookupType('Operand.ProofValue');
        this.Operand_PublicValue = this.root.lookupType('Operand.PublicValue');
        this.Operand_PeriodicCol = this.root.lookupType('Operand.PeriodicCol');
        this.Operand_FixedCol = this.root.lookupType('Operand.FixedCol');
        this.Operand_WitnessCol = this.root.lookupType('Operand.WitnessCol');
        this.Expression_Add = this.root.lookupType('Expression.Add');
        this.Expression_Sub = this.root.lookupType('Expression.Sub');
        this.Expression_Mul = this.root.lookupType('Expression.Mul');
        this.Expression_Neg = this.root.lookupType('Expression.Neg');

        // FrontEndField not used

        this.HintField = this.root.lookupType('HintField');
        this.HintFieldArray = this.root.lookupType('HintFieldArray');
        this.Hint = this.root.lookupType('Hint');
    }
    setupPilOut(name) {
        console.log('> set pilout name \x1B[38;5;208m' + name + '\x1B[0m');
        console.log('> set prime field \x1B[38;5;208m0x' + this.Fr.p.toString(16) + '\x1B[0m');
        this.pilOut = {
            name,
            baseField: this.toBaseField(this.Fr.p, 0, false),
            blowupFactor: 3,
            airGroups: [],
            numChallenges: [],
            numProofValues: [],
            numPublicValues: 0,
            publicTables: [],
            expressions: [],
            constraints: [],
            hints: [],
            symbols: []
        }
    }
    encode() {
        Context.memoryUpdate();
        // fs.writeFileSync('tmp/pilout.pre.log', util.inspect(this.pilOut, false, null, false));
        let message = this.PilOut.fromObject(this.pilOut);
        // fs.writeFileSync('tmp/pilout.log', util.inspect(this.pilOut, false, null, false));
        Context.memoryUpdate();
        this.data = this.PilOut.encode(message).finish();
        Context.memoryUpdate();
        return this.data;
    }
    saveToFile(filename) {
        fs.writeFileSync(filename, this.data);
    }
    pushAir(airId, name, rows, aggregable = true) {
        assert.equal(airId, this.currentAirGroup.airs.length);
        if (this.currentAir !== null) {
            this.airStack.push(this.currentAir);
        }
        this.currentAir = {name, numRows: Number(rows), airId};
        this.currentAir.aggregable = aggregable;
        if (this.avoidAirsWithSameName && this.currentAirGroup.airs.some(x => x.name === name)) {
            this.currentAir.name = `${this.currentAir.name}_${airId}`;
        }
        this.currentAirGroup.airs.push(this.currentAir);
    }
    popAir() {
        if (this.airStack.length) {
            this.currentAir = this.airStack.pop();
        } else {
            this.currentAir = null;
        }
    }
    useAirGroup(airGroupId) { // TODO: Add airgroup value
        // check if exist a airgroup with this name, if not create it.
        const airGroup = this.pilOut.airGroups.find(sp => sp.airGroupId === airGroupId);
        if (typeof airGroup === 'undefined') {
            throw new Error(`Using airGroupId ${airGroupId} not found on proto`);
        }
        this.currentAirGroup = airGroup;
    }
    setAirGroup(airGroupId, name) { // TODO: Add air group value
        // check if exist a air group with this name, if not create it.
        assert.equal(airGroupId, this.pilOut.airGroups.length);
        this.currentAirGroup = {name, airs: [], airGroupId };
        this.pilOut.airGroups.push(this.currentAirGroup);
    }
    setAirGroupValues(airGroupValues) {
        this.currentAirGroup.airGroupValues = [];
        for (let index = 0; index < airGroupValues.length; ++index) {
            const airGroupValue = airGroupValues[index];
            const stage = airGroupValue.stage;

            const aggType = SPV_AGGREGATIONS.indexOf(airGroupValue.aggregateType);
            if (aggType < 0) {
                console.log(airGroupValue);
                throw new Error(`Invalid aggregation type ${airGroupValue.aggregateType} on ${Context.sourceRef}`);
            }
            this.currentAirGroup.airGroupValues.push({aggType, stage});
        }
    }
    setAirValues(airValues) {
        this.currentAir.airValues = [];
        this.airValueId2ProtoId = [];
        this.getRelative(airValues, this.airValueId2ProtoId, [this.currentAirGroup.airGroupId, this.currentAir.airId]);
        for (let index = 0; index < airValues.length; ++index) {
            const stage = airValues[index].stage;
            this.currentAir.airValues.push({stage});
        }
    }
    setGlobalSymbols(symbols) {
        this._setSymbols(symbols.keyValuesOfTypes(['public', 'proofvalue', 'challenge', 'publictable']));
    }
    // if a prefix should be applied to the name, if original name has a negative row offset, move the row offset before the prefix.
    applyPrefixNameToSymbol(name, prefix = false) {
        if (prefix === false || typeof prefix === 'undefined' || prefix === '') {
            return name;
        }
        const primaRegExp = new RegExp('[0-9]*\'(?=[A-Za-z_])', 'gm');
        const matches = primaRegExp.exec(name)??false;
        if (matches === false) {
            return prefix + name;
        } else {
            return matches[0] + prefix + name.substring(matches[0].length);
        }
    }
    setSymbolsFromLabels(labels, type, data = {}) {
        let symbols = [];
        for (const label of labels) {
            const name = this.applyPrefixNameToSymbol(label.label, data.namePrefix);
            symbols.push([name, {type, locator: label.from, array: label.multiarray, data: {}, ...(label.data ?? {})}]);
        }
        this._setSymbols(symbols, data);
    }
    _setSymbols(symbols, data = {}) {
        for(const [name, ref] of symbols) {
            try {
                const arrayInfo = ref.array ? ref.array : {dim: 0, lengths: []};
                const sym2proto = this.symbolType2Proto(ref.type, ref.locator, {...ref, data: {...ref.data, ...data}});
                let payout = {
                    name,
                    dim: arrayInfo.dim,
                    lengths: arrayInfo.lengths,
                    debugLine: (ref.data ?? {}).sourceRef ?? '',
                    ...data,
                    ...sym2proto
                };
                this.pilOut.symbols.push(payout);
            } catch (e) {
                console.log(e.stack)
                throw new Error(`ERROR exporting proto symbol ${name}: ` + e.message);
            }
        }
    }

    symbolType2Proto(type, id, ref) {
        switch(type) {
            case 'im':
                return {type: REF_TYPE_IM_COL, id};

            case 'fixed': {
                const [ftype, protoId] = this.fixedId2ProtoId[id];
                if (ftype === 'P') return {type: REF_TYPE_PERIODIC_COL, id: protoId};
                return {type: REF_TYPE_FIXED_COL, id: protoId, stage: 0};
            }

            case 'witness': {
                const [stage, protoId] = this.witnessId2ProtoId[id];
                return {type: REF_TYPE_WITNESS_COL, id: protoId, stage};
            }
            case 'customcol': {
                const [stage, protoId, commitId] = this.customId2ProtoId[id];
                return {type: REF_TYPE_CUSTOM_COL, id: protoId, stage, commitId};
            }
            case 'airgroupvalue': {
                const stage = assert.returnTypeOf(ref.stage, 'number');
                const airGroupId = assert.returnTypeOf(ref.data.airGroupId, 'number');
                const relativeId = assert.returnTypeOf(ref.relativeId, 'number');
                return {type: REF_TYPE_AIR_GROUP_VALUE, id: relativeId, airGroupId, stage};
            }
            case 'airvalue': {
                const [stage, protoId, airGroupId, airId] = this.airValueId2ProtoId[id];
                return {type: REF_TYPE_AIR_VALUE, id: protoId, airId, airGroupId, stage};
            }
            case 'proofvalue':
                const def = ref.instance.getDefinition(id);
                const stage = assert.returnTypeOf(def.stage, 'number');
                const relativeId = assert.returnTypeOf(def.relativeId, 'number');
                return {type: REF_TYPE_PROOF_VALUE, id: relativeId, stage};

            case 'public':
                return {type: REF_TYPE_PUBLIC_VALUE, id};

            case 'challenge': {
                const def = ref.instance.getDefinition(id);
                const stage = assert.returnTypeOf(def.stage, 'number');
                const relativeId = assert.returnTypeOf(def.relativeId, 'number');
                return {type: REF_TYPE_CHALLENGE, id: relativeId, stage};
            }

        }
        throw new Error(`Invalid symbol type ${type}`);
    }

    setPublics(publics) {
        this.pilOut.numPublicValues = publics.length;
    }
    getNumByStage(values) {
        const _values = values.getPropertyValues(['id', 'stage']);
        const valuesSortedByStageAndId = _values.sort((a,b) => (a[1] > b[1] || (a[1] == b[1] && a[0] > b[0])) ? 1 : -1);
        let countByStage = [];
        for (const [id, stage] of valuesSortedByStageAndId) {
            assert.ok(stage > 0);
            countByStage[stage-1] = (countByStage[stage-1] ?? 0) + 1;
        }
        return Array.from(countByStage, x => x ?? 0);
    }
    setProofValues(proofvalues) {
        this.pilOut.numProofValues = this.getNumByStage(proofvalues);
    }
    setFixedCols(fixedCols) {
        this.setConstantCols(fixedCols, this.currentAir.numRows, false);
    }
    setPeriodicCols(periodicCols) {
        this.setConstantCols(periodicCols, this.currentAir.numRows, true);
    }
    setFixedColsToFile(fixedCols, filename) {
        return this.saveFixedColsToFile(fixedCols, this.currentAir.numRows, filename);
    }
    setChallenges(challenges) {
        this.pilOut.numChallenges = this.getNumByStage(challenges);
    }
    setConstantCols(cols, rows, periodic) {
        const property = periodic ? 'periodicCols':'fixedCols';
        const airCols = this.setupAirProperty(property);

        const colType = periodic ? 'P':'F';
        for (const col of cols) {
            const colIsPeriodic = col.isPeriodic() && col.rows < rows;
            if (colIsPeriodic !== periodic) continue;
            if (colIsPeriodic && !Context.config.enablePeriodicCols) {
                throw new Error(`Periodic cols not enabled, but ${col.label} defined at ${Context.sourceRef} has size of ${col.rows} but air has ${rows}`);
            }
            if (col.temporal) continue; // ignore temporal columns, only use to help to create other fixed columns
            this.fixedId2ProtoId[col.id] = [colType, airCols.length];
            let values = [];
            if (!Context.config.noProtoFixedData) {
                if (Context.config.compressFixedCols && col.isCompressed) {
                    values = this.setCompressedConstantsCols(col);
                } else if (!col.external) {
                    const _rows = periodic ? col.rows : rows;
                    console.log(`  > Proto setting ${periodic?'periodic':'fixed'} col ${col.id} ${_rows} ....`);
                    values = this.setRegularConstantsCols(col, _rows);
                }
            }
            airCols.push({values});
        }
    }
    saveFixedColsToFile(cols, rows, filename) {
        const airCols = this.setupAirProperty('fixedCols');
        for (const col of cols) {
            if (col.temporal) continue; // ignore temporal columns, only use to help to create other fixed columns
            this.fixedId2ProtoId[col.id] = ['F', airCols.length];
            let values = [];
            airCols.push({values});
        }
        let values = [];
        let colnames = [];
        for (const col of cols) {
            if (col.temporal || col.external) continue; // ignore temporal and external columns
            values.push(col.getValues());
            colnames.push(col.label);
        }
        const fixedFile = new FixedFile(values, rows, colnames);
        return fixedFile.saveToFile(filename);
    }
    setRegularConstantsCols(col, rows) {
        let values = [];
        for (let irow = 0; irow < rows; ++irow) {
            const _value = col.getValue(irow);
            if (typeof _value === 'undefined') {
                console.log(irow, col);
                throw new Error(`Error ${col.constructor.name} on row ${irow}`);
            }
            values.push(this.toBaseField(_value));
        }
        return values;
    }
    setCompressedConstantsCols(col) {
        throw new Error('UNIMPLEMENTED: setCompressedConstantsCols');
    }
    setWitnessCols(cols) {
        const stageWidths = this.setupAirProperty('stageWidths');
        this.witnessId2ProtoId = [];
        this.getRelativeStageWidths(cols, this.witnessId2ProtoId, stageWidths, 1);
        // sort by stage
    }
    getRelative(cols, translationTable, extraCols = []) {
        let index = 0;
        for (const col of cols) {
            translationTable[col.id] = [col.stage ?? 0, index++, ...extraCols];
        }
    }
    getRelativeStageWidths(cols, translationTable, stageWidths, initialStage, extraCols = []) {
        let stages = [];
        for (const col of cols) {
            if (col.stage < initialStage) {
                throw new Error(`Invalid stage ${col.stage}`);
            }
            const stageIndex = col.stage - initialStage;
            if (typeof stages[stageIndex] === 'undefined') {
                stages[stageIndex] = [];
            }
            stages[stageIndex].push(col.id);
        }
        let stageId = initialStage;
        for (const _stage of stages) {
            const stage = _stage ?? []; // stages without elements

            stageWidths.push(stage.length);

            // colIdx must be relative stage
            let index = 0;
            for (const id of stage) {
                translationTable[id] = [stageId, index++, ...extraCols];
            }
            ++stageId;
        }
    }
    setCustomCommit(commit, stageWidths, publics = []) {
        return {
                name: commit.name,
                publicValues: publics,
                stageWidths,
            };
    }
    setCustomCols(cols) {
        const customCommits = this.setupAirProperty('customCommits');
        const commits = cols.getCommits();
        this.customId2ProtoId = [];
        for (const commit of commits) {
            const commitCols = cols.getColsByCommit(commit);
            let stageWidths = [];
            const commitId = customCommits.length;
            this.getRelativeStageWidths(commitCols, this.customId2ProtoId, stageWidths, 0, [commitId]);
            customCommits.push(this.setCustomCommit(commit, stageWidths, commit.publics.map(x => { return {idx: x.id} })));
        }
    }
    setExpressions(packedExpressions) {
        const expressions = this.setupAirProperty('expressions');
        this._setExpressions(expressions, packedExpressions);
    }
    setGlobalExpressions(packedExpressions) {
        this._setExpressions(this.pilOut.expressions, packedExpressions);
    }
    _setExpressions(expressions, packedExpressions) {
        for (const packedExpression of packedExpressions) {
            const e = cloneDeep(packedExpression);
            const [op] = Object.keys(e);
            switch (op) {
                case 'mul':
                case 'add':
                case 'sub':
                    this.translate(e[op].lhs);
                    this.translate(e[op].rhs);
                    break;
                case 'neg':
                    this.translate(e[op].value);
                    break;
                default:
                    throw new Error(`Invalid operation ${op} on packedExpression`);
            }
            expressions.push(e);
        }
        console.log(`  > Proto expressions: ${expressions.length}`);
    }
    translate(ope) {
        const [key] = Object.keys(ope);
        switch (key) {
            case 'fixedCol': {
                    // inside pil all fixed columns are equal, after that detect periodic cols
                    // and it implies change index number and type if finally is a periodic col.
                    const [type, protoId] = this.fixedId2ProtoId[ope.fixedCol.idx] ?? [false,false];
                    if (protoId === false) {
                        throw new Error(`Translate: Found invalid fixedColId ${ope.fixedCol.idx}`);
                    }
                    ope.fixedCol.idx = protoId;
                    if (type === 'P') {
                        ope.periodicCol = ope.fixedCol;
                        delete(ope.fixedCol);
                    }
                }
                break;

            case 'witnessCol': {
                    // translate index of witness because witness cols must be order by stage and
                    // it implies change index number.
                    const [stage, protoId] = this.witnessId2ProtoId[ope.witnessCol.colIdx] ?? [false, false];
                    // console.log(`TRANSLATE witnessCol colIdx:${ope.witnessCol.colIdx}=>${protoId} rowOffset:${ope.witnessCol.rowOffset} stage:${ope.witnessCol.stage}=>${stage}`);
                    if (protoId === false) {
                        throw new Error(`Translate: Found invalid witnessColId ${ope.witnessCol.colIdx}`);
                    }
                    ope.witnessCol.colIdx = protoId;
                    ope.witnessCol.stage = stage;
                }
                break;
            // case 'proofValue': idx is relativeId when pushed in packer.
            // case 'challenge': idx is relativeId when pushed in packer.
            case 'customCol': {
                    const [stage, protoId, commitId] = this.customId2ProtoId[ope.customCol.colIdx] ?? [false, false];
                    // console.log(`TRANSLATE customCol colIdx:${ope.customCol.colIdx}=>${protoId} rowOffset:${ope.customCol.rowOffset} stage:${ope.customCol.stage}=>${stage}`);
                    if (protoId === false) {
                        throw new Error(`Translate: Found invalid customCol ${ope.customCol.colIdx}`);
                    }
                    ope.customCol.commitId = commitId;
                    ope.customCol.colIdx = protoId;
                    ope.customCol.stage = stage;
                }
                break;
            // airGroupValue not need to translate or to add extra information
            case 'airValue': {
                    // translate index of airvalue because compiler use global ids
                    const [stage, protoId, airGroupId, airId] = this.airValueId2ProtoId[ope.airValue.idx] ?? [false, false, false, false];
                    // // console.log(`TRANSLATE witnessCol colIdx:${ope.witnessCol.colIdx}=>${protoId} rowOffset:${ope.witnessCol.rowOffset} stage:${ope.witnessCol.stage}=>${stage}`);
                    if (protoId === false) {
                        throw new Error(`Translate: Found invalid airValueId ${ope.airValue.idx}`);
                    }
                    ope.airValue.idx = protoId;
                }
                break;
            // challenge not need to translate or to add extra information
            case 'constant':
                ope.constant.value = this.toBaseField(ope.constant.value);
                break;
        }
    }
    setupAirProperty(propname, init = []) {
        if (this.currentAir === null) {
            throw new Error('Current air not defined');
        }
        if (typeof this.currentAir[propname] !== 'undefined') {
            throw new Error(`Property ${propname} already defined on current air ${this.currentAir.name || 'unnamed'}`);
        }
        this.currentAir[propname] = init;
        return this.currentAir[propname];
    }
    setGlobalConstraints(constraints, packed) {
        for (const [index, constraint] of constraints.keyValues()) {
            const packedExpressionId = constraints.getPackedExpressionId(constraint.exprId, packed);
            let payload = { expressionIdx: { idx: packedExpressionId },
                            debugLine: constraints.getDebugInfo(index, packed) };
            this.pilOut.constraints.push(payload);
        }
    }
    addAirGroupValueDefaultValueConstraint(airId, airGroupId, airGroupValueId, defaultValue) {
        const airGroup = this.pilOut.airGroups[airGroupId] ?? this.currentAirGroup;
        const air = airGroup.airs[airId];
        const expressionPayload = {
            sub: {
                lhs: { airGroupValue: { idx: airGroupValueId, airGroupId } },
                rhs: { constant: { value: this.toBaseField(defaultValue) } }
            }
        }
        const exprId = air.expressions.push(expressionPayload) - 1;
        const constraintPayload = {
            everyRow: {
                expressionIdx: { idx: exprId },
                debugLine: `airgroup default value (${defaultValue}) constraint`
            }
        };
        air.constraints.push(constraintPayload);
    }
    setConstraints(constraints, packed, options = {}) {
        let airConstraints = this.setupAirProperty('constraints');
        for (const [index, constraint] of constraints.keyValues()) {
            let payload;
            const debugLine = constraints.getDebugInfo(index, packed, options);
            const packedExpressionId = constraints.getPackedExpressionId(constraint.exprId, packed, options);
            switch (constraint.boundery) {
                case false:
                case 'all':
                    payload = { everyRow: { expressionIdx: { idx: packedExpressionId }, debugLine}};
                    break;

                case 'first':
                    payload = { firstRow: { expressionIdx: { idx: packedExpressionId }, debugLine}};
                    break;

                case 'last':
                    payload = { lastRow: { expressionIdx: { idx: packedExpressionId }, debugLine}};
                    break;

                case 'frame':
                    payload = { everyFrame: { expressionIdx: { idx: packedExpressionId }, offsetMin: 0, offsetMax:0, debugLine}};
                    break;

                default:
                    throw new Error(`Invalid constraint boundery '${constraint.boundery}'`);

            }
            airConstraints.push(payload);
        }
    }
    addHints(hints, packed, options) {
        const airGroupId = options.airGroupId ?? false;
        const airId = options.airId ?? false;
        for (const hint of hints) {
            let payload = {name: hint.name};
            if (airGroupId !== false) {
                payload.airGroupId = airGroupId;
                payload.airId = airId;
            }
            const res = this.toHintField(hint.data, {...options, hints, packed})
            payload.hintFields = Array.isArray(res) ? res: [res];

            // TODO
            // const debugLine = hints.getDebugInfo(hint, packed, options);
            this.pilOut.hints.push(payload);
        }
    }
    toHintField(hdata, options = {}) {
        const path = options.path ?? '';
        // check if an alone expression to use and translate its single operand
        if (hdata && hdata.isArray) {
            hdata = hdata.getAloneOperand().toArrays();
        }
        if (Array.isArray(hdata)) {
            let result = [];
            for (let index = 0; index < hdata.length; ++index) {
                result.push(this.toHintField(hdata[index], {...options, path: path + '[' + index + ']'}));
            }
            return { hintFieldArray: { hintFields: Array.isArray(result) ? result : [result] }};
        }
        if (hdata && typeof hdata.pack === 'function') {
            // console.log('HINT', typeof hdata.toString == 'function' ? hdata.constructor.name + ' ==> ' + hdata.toString() : hdata);
            if (typeof hdata.evalAsValue === 'function') {
                const value = hdata.evalAsValue();
                if (value.isString) {
                    return { stringValue: value.asString() };
                }
                if (value instanceof IntValue) {
                    return { operand: {constant: { value: this.bint2buf(value.asInt())}} }
                }
            }
            const expressionId = hdata.pack(options.packed, options);
            return { operand: { expression: { idx: expressionId } }};
        }
        if (typeof hdata === 'object' && hdata.constructor.name === 'ExpressionId') {
            const expressionId = options.hints.getPackedExpressionId(hdata.id, options.packed, options);
            if (expressionId === false) {
                const expr = options.hints.expressions.get(hdata.id);
                options.hints.getPackedExpressionId(hdata.id, options.packed, options);
            }
            return { operand: { expression: { idx: expressionId } }};
        }
        if (typeof hdata === 'bigint' || typeof hdata === 'number') {
            return { operand: {constant: { value: this.bint2buf(BigInt(hdata))}} }
        }
        if (hdata instanceof IntValue) {
            return { operand: {constant: { value: this.bint2buf(hdata.asInt())}} }
        }
        if (typeof hdata === 'string') {
            return { stringValue: hdata };
        }
        if (hdata instanceof StringValue) {
            return { stringValue: hdata.asString() };
        }
        if (typeof hdata === 'object' && hdata.constructor.name === 'Object') {
            let result = [];
            for (const name in hdata) {
                const value = this.toHintField(hdata[name], {...options, path: path + '.' + name});
                result.push({...value, name});
            }
            return { hintFieldArray: { hintFields: Array.isArray(result) ? result : [result] }};
        }
        throw new Error(`Invalid hint-data (type:${typeof hdata}/${(hdata.constructor ?? {name:''}).name}) on cloneHint of ${path}`);
    }
    bint2uint8(value, bytes = 0) {
        let result = new Uint8Array(this.uint8size);
        for (let index = 0; index < this.uint8size; ++index) {
            result[this.uint8size - index - 1] = value & 0xFF;
            value = value >> 8;
        }
        assert.strictEqual(value, 0n);
        return result;
    }
    bint2bint(value, bytes = 0) {
        return BigInt(value);
    }
    bint2buf(value, bytes = 0, useFr = true) {
        if (value && typeof value.asInt === 'function') {
            value = value.asInt();
        }
        if (this.bigIntType === 'bigint') {
            return BigInt(value);
        }
        if (value === 0n && bytes === 0) {
            return Buffer.alloc(0);
        }

        if (typeof value !== 'bigint') {
            if (value && value.dump) {
                value.dump();
            }
        }
        if (useFr) {
            value = Context.Fr.e(value);
        }

        // first divide in chunks to calculate how many chunks in
        // big endian are used.
        let chunks = [];
        while (value > 0n) {
            chunks.push(value & 0xFFFFFFFFFFFFFFFFn)
            value = value >> 64n;
        }
        if (chunks.length === 0) {
            chunks.push(0n);
        }

        // write precalculated chunks
        const buf = Buffer.alloc(chunks.length * 8);
        const lastIndex = chunks.length - 1;
        for (let index = 0; index <= lastIndex; ++index) {
            buf.writeBigUInt64BE(chunks[lastIndex - index], index);
        }
        if (bytes === 0 && this.varbytes) {
            let index = 0;
            if (buf[0] == 0) {
                while (buf[++index] == 0 && index < 32);
            }
            return buf.subarray(index);
        }
        if (bytes !== 0) {
            return buf.subarray(32-bytes);
        }
        return buf;
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
    exportToFile() {
        /*
        let pilout = {
            name: 'myname',
            baseField:
        }
        const root = await protobuf.load(__dirname + '/pilout.proto');

        const PilOut = root.lookupType('pilout.PilOut');
        console.log(PilOut);
        */
    }
}

let pout = new module.exports();
