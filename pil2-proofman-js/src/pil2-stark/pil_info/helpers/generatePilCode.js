const {generateFRIPolynomial} = require("./polynomials/friPolinomial");

const { generateConstraintPolynomialVerifierCode, generateConstraintsDebugCode, generateExpressionsCode } = require("./code/generateCode");
const { addInfoExpressions } = require("./helpers");
const { printExpressions } = require("../utils");
const { FIELD_EXTENSION } = require("../../../constants.js");

module.exports.generatePilCode = function generatePilCode(res, symbols, constraints, expressions, hints, debug) {
    
    const expressionsInfo = {};

    const verifierInfo = {};

    if(!debug) {
        generateConstraintPolynomialVerifierCode(res, verifierInfo, symbols, expressions);
        generateFRIPolynomial(res, symbols, expressions);
        addInfoExpressions(expressions, expressions[res.friExpId]);
    }

    expressionsInfo.hintsInfo = module.exports.addHintsInfo(res, expressions, hints);

    expressionsInfo.expressionsCode = generateExpressionsCode(res, symbols, expressions);

    verifierInfo.queryVerifier = expressionsInfo.expressionsCode.find(e => e.expId === res.friExpId);
    verifierInfo.queryVerifier.code[verifierInfo.queryVerifier.code.length - 1].dest = { type: "tmp", id: verifierInfo.queryVerifier.tmpUsed - 1, dim: FIELD_EXTENSION };
    
    expressionsInfo.constraints = generateConstraintsDebugCode(res, symbols, constraints, expressions);

    return {expressionsInfo, verifierInfo};
}


module.exports.addHintsInfo = function addHintsInfo(res, expressions, hints, global) {
    const hintsInfo = [];
    for(let i = 0; i < hints.length; ++i) {
        const hint = hints[i];

        const hintFields = [];
    
        for(let j = 0; j < hint.fields.length; ++j) {
            const field = hint.fields[j];
            const hintField = { 
                name: field.name,
                values: processHintFieldValue(field.values, res, expressions, global).flat(Infinity),
            };

            if(!field.lengths) hintField.values[0].pos = [];
            hintFields.push(hintField);
        }

        hintsInfo[i] = {
            name: hint.name,
            fields: hintFields,
        }
    }

    delete res.hints;

    return hintsInfo;
}

function processHintFieldValue(values, res, expressions, global, pos = []) {
    const processedFields = [];

    for (let j = 0; j < values.length; ++j) {
        const field = values[j];

        const currentPos = [...pos, j];

        if (Array.isArray(field)) {
            processedFields.push(processHintFieldValue(field, res, expressions, global, currentPos));
        } else {
            let processedField;
            if (field.op === "exp") {
                expressions[field.id].line = printExpressions(res, expressions[field.id], expressions);
                processedField = { op: "tmp", id: field.id, dim: expressions[field.id].dim, pos: currentPos };
            } else if (["cm", "custom", "const"].includes(field.op)) {
                const primeIndex = res.openingPoints.findIndex(p => p === field.rowOffset);
                processedField = { ...field, rowOffsetIndex: primeIndex, pos: currentPos };
            } else if (["challenge", "public", "airgroupvalue", "airvalue","number", "string", "proofvalue"].includes(field.op)) {
                processedField = { ...field, pos: currentPos };
            } else {
                throw new Error("Invalid hint op: " + field.op);
            }
            processedFields.push(processedField);
        }
    }
    return processedFields;
}