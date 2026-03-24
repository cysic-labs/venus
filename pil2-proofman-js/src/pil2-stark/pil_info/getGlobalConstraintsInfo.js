const { pilCodeGen, buildCode } = require("./helpers/code/codegen");
const { addHintsInfo } = require("./helpers/generatePilCode");
const { addInfoExpressions } = require("./helpers/helpers");
const { formatHints } = require("./utils");
const { formatExpressions, formatSymbols } = require("./utils");

module.exports.getGlobalConstraintsInfo = function getGlobalConstraintsInfo(res, pilout) {
    
    let expressions, symbols;

    let constraintsCode = [];
    let hintsCode = [];
    if(pilout.constraints) {
        const constraints = pilout.constraints.map(c => {  return { e: c.expressionIdx.idx, boundary: "finalProof", line: c.debugLine } });
        
        const e = formatExpressions(pilout, true);
        expressions = e.expressions;
        symbols = formatSymbols(pilout, true);
    
        for(let i = 0; i < constraints.length; ++i) {
            addInfoExpressions(expressions, expressions[constraints[i].e]);
        }
       
        const ctx = {
            calculated: {},
            tmpUsed: 0,
            code: [],
            dom: "n",
        };
        
        for(let j = 0; j < constraints.length; ++j) {
            pilCodeGen(ctx, symbols, expressions, constraints[j].e, 0);
            let code = buildCode(ctx, expressions);
            ctx.tmpUsed = code.tmpUsed;
            code.boundary = constraints[j].boundary;
            code.line = constraints[j].line;
    
            constraintsCode.push(code);
        }     
    }

    const globalHints = pilout.hints ? pilout.hints.filter(h => h.airId === undefined && h.airgroupId === undefined) : [];

    if(globalHints) {
        const hints = formatHints(pilout, globalHints, symbols, expressions, true);
        hintsCode = addHintsInfo(res, expressions, hints, true);
    }
    return {constraints: constraintsCode, hints: hintsCode };
}
