const ProtoOut = require("pil2-compiler/src/proto_out.js");
const { FIELD_EXTENSION } = require("../../constants.js");

const piloutTypes =  {
    FIXED_COL: 1,
    WITNESS_COL: 3,
    PROOF_VALUE: 4,
    AIRGROUP_VALUE: 5,
    PUBLIC_VALUE: 6,
    CHALLENGE: 8,
    AIR_VALUE: 9,
    CUSTOM_COL: 10,
}

module.exports.formatExpressions = function formatExpressions(pilout, global = false) {
    const symbols = [];

    const expressions = pilout.expressions.map(e => formatExpression(e, pilout, symbols, global));
    return { expressions };
}

module.exports.formatHints = function formatHints(pilout, rawHints, symbols, expressions, global = false) {
    const hints = [];

    for(let i = 0; i < rawHints.length; ++i) {
        const hint = { name: rawHints[i].name };
        const fields = rawHints[i].hintFields[0].hintFieldArray.hintFields;
        hint.fields = [];
        for(let j = 0; j < fields.length; j++) {
            const name = fields[j].name;
            const {values, lengths} = processHintField(fields[j], pilout, symbols, expressions, global);
            if(!lengths) {
                hint.fields.push({name, values: [values], lengths});
            } else {
                hint.fields.push({name, values, lengths});
            }
        }
        hints.push(hint);
    }

    return hints;
}

function processHintField(hintField, pilout, symbols, expressions, global = false) {
    let resultFields = [];
    let lengths = [];
    if (hintField.hintFieldArray) {
        const fields = hintField.hintFieldArray.hintFields;
        for (let j = 0; j < fields.length; j++) {
            const { values, lengths: subLengths } = processHintField(fields[j], pilout, symbols, expressions, global);

            resultFields.push(values);

            if (lengths.length === 0) {
                lengths.push(fields.length);
            }
            
            if (subLengths && subLengths.length > 0) {
                for (let k = 0; k < subLengths.length; k++) {
                    if (lengths[k + 1] === undefined) {
                        lengths[k + 1] = subLengths[k];
                    }
                }
            }
        }
    } else {
        let value;

        if (hintField.operand) {
            value = formatExpression(hintField.operand, pilout, symbols, global);
            if (value.op === "exp") expressions[value.id].keep = true;
        } else if (hintField.stringValue !== undefined) {
            value = { op: "string", string: hintField.stringValue };
        } else {
            throw new Error("Unknown hint field");
        }

        return { values: value };
    }

    return {values: resultFields, lengths };
}


function formatExpression(exp, pilout, symbols, global = false) {
    const P = new ProtoOut();
    
    if(exp.op) return exp;

    let op = Object.keys(exp)[0];
    
    let store = false;

    if(op === "expression") {
        const id = exp[op].idx;
        const expOp = Object.keys(pilout.expressions[id])[0];
        if(expOp != "mul" && expOp!= "neg" && Object.keys(pilout.expressions[id][expOp].lhs)[0] !== "expression" && Object.keys(pilout.expressions[id][expOp].rhs)[0] === "constant" && P.buf2bint(pilout.expressions[id][expOp].rhs.constant.value).toString() === "0") {
            return formatExpression(pilout.expressions[id][expOp].lhs, pilout, symbols, global);
        }
        exp = { op: "exp", id };
    } else if(["add", "mul", "sub"].includes(op)) {
        const lhs = formatExpression(exp[op].lhs, pilout, symbols, global);
        const rhs = formatExpression(exp[op].rhs, pilout, symbols, global);
        exp = { op, values: [lhs, rhs] };
    } else if(op === "neg") {
        const value = formatExpression(exp[op].value, pilout, symbols, global);
        exp = { op, values: [value] };
    } else if (op === "constant") {
        const value = P.buf2bint(exp.constant.value).toString();
        exp = { op: "number", value };
    } else if (op === "witnessCol" || op === "customCol") {
        const type = op === "witnessCol" ? "cm" : "custom";
        const commitId = op === "customCol" ? exp[op].commitId : undefined;
        const stageWidths = op === "witnessCol" ? pilout.stageWidths : pilout.customCommits[commitId].stageWidths;
        const stageId = exp[op].colIdx;
        const rowOffset = exp[op].rowOffset;
        const stage = exp[op].stage;
        const id = stageId + stageWidths.slice(0, stage - 1).reduce((acc, c) => acc + c, 0);
        const dim = stage <= 1 ? 1 : FIELD_EXTENSION;
        const airgroupId = exp[op].airGroupId;
        const airId = exp[op].airId;
        exp = { op: type, id, stageId, rowOffset, stage, dim, airgroupId, airId };
        if(op === "customCol") exp.commitId = commitId;
        store = true;
    } else if (op === "fixedCol") {
        const id = exp[op].idx;
        const rowOffset = exp[op].rowOffset;
        const airgroupId = exp[op].airGroupId;
        const airId = exp[op].airId;
        exp = { op: "const", id, rowOffset, stage: 0, dim: 1, airgroupId, airId };
        store = true;
    } else if (op === "publicValue") {
        const id = exp[op].idx;
        exp = { op: "public", id, stage: 1 };
        store = true;
    } else if (op === "airGroupValue") {
        const id = exp[op].idx;
        const stage = !global ? pilout.airGroupValues[id].stage : pilout.airGroups[exp[op].airGroupId].airGroupValues[id].stage;
        const dim = stage === 1 ? 1 : FIELD_EXTENSION; 
        exp = { op: "airgroupvalue", id, airgroupId: exp[op].airGroupId, dim, stage };
        store = true;
    } else if (op === "airValue") {
        const id = exp[op].idx;
        const stage = pilout.airValues[id].stage;
        const dim = stage === 1 ? 1 : FIELD_EXTENSION; 
        exp = { op: "airvalue", id, stage, dim };
        store = true;
    } else if (op === "challenge") {
        const id = exp[op].idx + pilout.numChallenges.slice(0, exp[op].stage - 1).reduce((acc, c) => acc + c, 0);
        const stageId = exp[op].idx;
        const stage = exp[op].stage;
        exp = { op: "challenge", stage, stageId, id };
        store = true;
    } else if (op === "proofValue") {
        const id = exp[op].idx;
        const stage = exp[op].stage;
        const dim = stage === 1 ? 1 : FIELD_EXTENSION; 
        exp = { op: "proofvalue", id, stage, dim};
        store = true;
    } else {
        throw new Error("Unknown op: " + op);
    }

    return exp;
}

module.exports.printExpressions = function printExpressions(res, exp, expressions, isConstraint = false) {
    if(exp.op === "exp") {
        if(!exp.line) exp.line = printExpressions(res, expressions[exp.id], expressions, isConstraint);
        return exp.line;
    } else if(["add", "mul", "sub"].includes(exp.op)) {
        const lhs = printExpressions(res, exp.values[0], expressions, isConstraint);
        const rhs = printExpressions(res, exp.values[1], expressions, isConstraint);
        const op = exp.op === "add" ? " + " : exp.op === "sub" ? " - " : " * ";
        return "(" + lhs + op + rhs + ")";
    } else if(exp.op === "neg") {
        return printExpressions(res, exp.values[0], expressions, isConstraint);
    } else if (exp.op === "number") {
        return exp.value;
    } else if (exp.op === "const" || exp.op === "cm" || exp.op === "custom") {
        const col = exp.op === "const" ? res.constPolsMap[exp.id] : exp.op === "cm" ? res.cmPolsMap[exp.id] : res.customCommitsMap[exp.commitId][exp.id];
        if(col.imPol && !isConstraint) {
            return printExpressions(res, expressions[col.expId], expressions, false);
        }
        let name = col.name;
        if(col.lengths) name += col.lengths.map(len => `[${len}]`).join('');
        if(col.imPol) name += res.cmPolsMap.filter((w, i) => i < exp.id && w.imPol).length;
        if(exp.rowOffset) {
            if(exp.rowOffset > 0) {
                name += "'";
                if(exp.rowOffset > 1) name += exp.rowOffset;
            } else {
                name = "'" + name;
                if(exp.rowOffset < -1) name = Math.abs(exp.rowOffset) + name;
            }
        }
        return name;
    } else if (exp.op === "public") {
        return res.publicsMap[exp.id].name;
    } else if (exp.op === "airvalue") {
        return res.airValuesMap[exp.id].name;    
    } else if (exp.op === "airgroupvalue") {
        return res.airgroupValuesMap[exp.id].name; 
    } else if (exp.op === "challenge") {
        return res.challengesMap[exp.id].name;
    } else if (exp.op === "Zi") {
        return "zh";
    } else if (exp.op === "proofvalue") {
        return res.proofValuesMap[exp.id].name;
    } else throw new Error("Unknown op: " + exp.op);
}

module.exports.formatConstraints = function formatConstraints(pilout) {
    const constraints = pilout.constraints.map(c => {
        let boundary = Object.keys(c)[0];
        let constraint = {
            boundary,
            e: c[boundary].expressionIdx.idx,
            line: c[boundary].debugLine,
        }

        if(boundary === "everyFrame") {
            constraint.offsetMin = c[boundary].offsetMin;
            constraint.offsetMax = c[boundary].offsetMax;
        }
        return constraint;
    });

    return constraints;
}

module.exports.formatSymbols = function formatSymbols(pilout, global = false) {
    const symbols = pilout.symbols
        .filter(s => s.type !== 0 && (!global || ![piloutTypes.AIR_VALUE, piloutTypes.CUSTOM_COL, piloutTypes.FIXED_COL, piloutTypes.WITNESS_COL].includes(s.type)))
        .flatMap(s => {
        if(s.type === piloutTypes.CUSTOM_COL && s.stage !== 0) throw new Error("Invalid stage " + s.stage + "for a custom commit");
        if([piloutTypes.FIXED_COL, piloutTypes.WITNESS_COL, piloutTypes.CUSTOM_COL].includes(s.type)) {
            const dim = ([0,1].includes(s.stage)) ? 1 : FIELD_EXTENSION;
            const type = s.type === piloutTypes.FIXED_COL ? "fixed" : s.type === piloutTypes.CUSTOM_COL ? "custom" : "witness";
            const previousPols = pilout.symbols.filter(si => si.type === s.type 
                && si.airId === s.airId && si.airGroupId === s.airGroupId
                && ((si.stage < s.stage) || (si.stage === s.stage && si.id < s.id))
                && (s.type !== piloutTypes.CUSTOM_COL || s.commitId === si.commitId));

            let polId = 0;
            for(let i = 0; i < previousPols.length; ++i) {
                if (!previousPols[i].dim) {
                    polId++;
                } else {
                    polId += previousPols[i].lengths.reduce((acc, l) => acc * l, 1);
                }
            };
            if(!s.dim) {
                const stageId = s.id;
                const symbol = {
                    name: s.name,
                    stage: s.stage,
                    type,
                    polId,
                    stageId,
                    dim,
                    airId: s.airId,
                    airgroupId: s.airGroupId,
                }
                if(s.type === piloutTypes.CUSTOM_COL) symbol.commitId = s.commitId;
                return symbol;
            } else {
                const multiArraySymbols = [];
                generateMultiArraySymbols(multiArraySymbols, [], s, type, s.stage, dim, polId, 0);
                return multiArraySymbols;
            }
        } else if(s.type === piloutTypes.PROOF_VALUE) {
            const dim = s.stage === 1 ? 1 : FIELD_EXTENSION; 
            if(!s.dim) {
                return {
                    name: s.name,
                    type: "proofvalue",
                    stage: s.stage,
                    dim,
                    id: s.id,
                }
            } else {
                const multiArraySymbols = [];
                generateMultiArraySymbols(multiArraySymbols, [], s, "proofvalue", s.stage, dim, s.id, 0);
                return multiArraySymbols;
            }
        } else if(s.type === piloutTypes.CHALLENGE) {
            const id = pilout.symbols.filter(si => si.type === piloutTypes.CHALLENGE && ((si.stage < s.stage) || (si.stage === s.stage && si.id < s.id))).length;
            return {
                name: s.name,
                type: "challenge",
                stageId: s.id,
                id,
                stage: s.stage,
                dim: FIELD_EXTENSION,
            }
        } else if(s.type === piloutTypes.PUBLIC_VALUE) {
            if(!s.dim) {
                return {
                    name: s.name,
                    stage: 1,
                    type: "public",
                    dim: 1,
                    id: s.id,
                }
            } else {
                const multiArraySymbols = [];
                generateMultiArraySymbols(multiArraySymbols, [], s, "public", 1, 1, s.id, 0);
                return multiArraySymbols;
            }
        } else if(s.type === piloutTypes.AIRGROUP_VALUE) {
            const stage = !global ? pilout.airGroupValues[s.id].stage : undefined;
            if(!s.dim) {
                const airgroupValue = {
                    name: s.name,
                    type: "airgroupvalue",
                    id: s.id,
                    airgroupId: s.airGroupId,
                    dim: FIELD_EXTENSION,
                }
                if(stage) airgroupValue.stage = stage;
                return airgroupValue;
            } else {
                const multiArraySymbols = [];
                generateMultiArraySymbols(multiArraySymbols, [], s, "airgroupvalue", stage, FIELD_EXTENSION, s.id, 0);
                return multiArraySymbols;
            }
        } else if(s.type === piloutTypes.AIR_VALUE) {
            const stage = pilout.airValues[s.id].stage;
            const dim = stage != 1 ? FIELD_EXTENSION : 1
            if(!s.dim) {
                return {
                    name: s.name,
                    type: "airvalue",
                    id: s.id,
                    airgroupId: s.airGroupId,
                    stage,
                    dim,
                }
            } else {
                const multiArraySymbols = [];
                generateMultiArraySymbols(multiArraySymbols, [], s, "airvalue", stage, dim, s.id, 0);
                return multiArraySymbols;
            }
            
        } else {
            throw new Error("Invalid type " + s.type);
        }
    });

    return symbols;
}

function generateMultiArraySymbols(symbols, indexes, sym, type, stage, dim, polId, shift) {
    if (indexes.length === sym.lengths.length) {

        const symbol = {
            name: sym.name,
            lengths: indexes,
            idx: shift,
            type,
            polId: polId + shift,
            id: polId + shift,
            stageId: sym.id + shift,
            stage,
            dim,
        }

        if(sym.hasOwnProperty("airId")) symbol.airId = sym.airId;
        if(sym.hasOwnProperty("airGroupId")) symbol.airgroupId = sym.airGroupId;
        if(sym.hasOwnProperty("commitId")) symbol.commitId = sym.commitId;
    
        symbols.push(symbol);
        return shift + 1;
    }

    for (let i = 0; i < sym.lengths[indexes.length]; i++) {
        shift = generateMultiArraySymbols(symbols, [...indexes, i], sym, type, stage, dim, polId, shift);
    }

    return shift;
}
