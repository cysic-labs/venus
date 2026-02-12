const { addInfoExpressionsSymbols } = require("../helpers");
const { pilCodeGen, buildCode } = require("./codegen");
const { FIELD_EXTENSION } = require("../../../../constants.js");


module.exports.generateExpressionsCode = function generateExpressionsCode(res, symbols, expressions) {
    const expressionsCode = [];
    for(let j = 0; j < expressions.length; ++j) {
        const exp = expressions[j];
        if(!exp.keep && !exp.imPol && ![res.cExpId, res.friExpId].includes(j)) continue;
        const dom = (j === res.cExpId || j === res.friExpId) ? "ext" : "n";
        const ctx = {
            stage: exp.stage,
            calculated: {},
            tmpUsed: 0,
            code: [],
            dom,
            airId: res.airId,
            airgroupId: res.airgroupId,
        };

        if(j === res.friExpId) ctx.openingPoints = res.openingPoints;
        if(j === res.cExpId) {
            for(let i = 0; i < symbols.length; i++) {
                if(!symbols[i].imPol) continue;
                const expId = symbols[i].expId;
                ctx.calculated[expId] = {};
                for(let i = 0; i < res.openingPoints.length; ++i) {
                    const openingPoint = res.openingPoints[i];
                    ctx.calculated[expId][openingPoint] = { cm: true };
                }
            }
        }
        let exprDest;
        if(exp.imPol) {
            const symbolDest = symbols.find(s => s.expId === j);
            exprDest = { op: "cm", stage: symbolDest.stage, stageId: symbolDest.stageId, id: symbolDest.polId};
        }

        pilCodeGen(ctx, symbols, expressions, j, 0);
        const expInfo = buildCode(ctx);
        
        if(j == res.cExpId) {
            expInfo.code[expInfo.code.length-1].dest = { type: "q", id: 0, dim: res.qDim };
        }

        if(j == res.friExpId) {
            expInfo.code[expInfo.code.length-1].dest = { type: "f", id: 0, dim: FIELD_EXTENSION };
        }

        expInfo.expId = j;
        expInfo.stage = exp.stage || 0;
        expInfo.dest = exprDest;
        expInfo.line = exp.line || "";       

        expressionsCode.push(expInfo);
    }

    return expressionsCode;
}

module.exports.generateConstraintsDebugCode = function generateConstraintsDebugCode(res, symbols, constraints, expressions) {
    const constraintsCode = [];
    for(let j = 0; j < constraints.length; ++j) {
        const ctx = {
            stage: res.nStages,
            calculated: {},
            tmpUsed: 0,
            code: [],
            dom: "n",
            airId: res.airId,
            airgroupId: res.airgroupId,
        };    

        for(let i = 0; i < symbols.length; i++) {
            if(!symbols[i].imPol) continue;
            const expId = symbols[i].expId;
            ctx.calculated[expId] = {};
            for(let i = 0; i < res.openingPoints.length; ++i) {
                const openingPoint = res.openingPoints[i];
                ctx.calculated[expId][openingPoint] = { cm: true };
            }
        }
        pilCodeGen(ctx, symbols, expressions, constraints[j].e, 0);
        const constraint = buildCode(ctx);
        constraint.boundary = constraints[j].boundary;
        constraint.line = constraints[j].line;
        constraint.imPol = constraints[j].imPol ? 1 : 0;
        constraint.stage = constraints[j].stage === 0 ? 1 : constraints[j].stage;
        if(constraints[j].boundary === "everyFrame") {
            constraint.offsetMin = constraints[j].offsetMin;
            constraint.offsetMax = constraints[j].offsetMax;
        }
        constraintsCode[j] = constraint;
    }
    return constraintsCode;
}

module.exports.generateConstraintPolynomialVerifierCode = function generateConstraintPolynomialVerifierCode(res, verifierInfo, symbols, expressions) {       

    let ctx = {
        stage: res.nStages + 1,
        calculated: {},
        tmpUsed: 0,
        code: [],
        evMap: [],
        dom: "n",
        airId: res.airId,
        airgroupId: res.airgroupId,
        openingPoints: res.openingPoints,
        verifierEvaluations: true,
    };

    for(let i = 0; i < symbols.length; i++) {
        if(!symbols[i].imPol) continue;
        const expId = symbols[i].expId;
        ctx.calculated[expId] = {};
        for(let i = 0; i < res.openingPoints.length; ++i) {
            const openingPoint = res.openingPoints[i];
            ctx.calculated[expId][openingPoint] = { cm: true };
        }
    }

    const evals = [];
    addInfoExpressionsSymbols(evals, symbols, expressions, expressions[res.cExpId]);

    for(let k = 0; k < evals.length; k++) {
        const prime = evals[k].prime;
        const openingPos = res.openingPoints.findIndex(p => p === prime);
        const rf = { type: evals[k].type, id: evals[k].id, prime, openingPos };
        if(evals[k].type === "custom") rf.commitId = evals[k].commitId;
        ctx.evMap.push(rf);
    }

    let qIndex = res.cmPolsMap.findIndex(p => p.stage === res.nStages + 1 && p.stageId === 0);
    let openingPos = res.openingPoints.findIndex(p => p === 0);
    for (let i = 0; i < res.qDeg; i++) {
        ctx.evMap.push({ type: "cm", id: qIndex + i, prime: 0, openingPos });
    }

    const typeOrder = { "cm": 0, "const": 1 };
    for(let i = 0; i < res.customCommits.length; ++i) {
        typeOrder[`custom${i}`] = i + 2;
    }
    ctx.evMap.sort((a, b) => {
        const a_type = ["const", "cm"].includes(a.type) ? a.type : `custom${a.commitId}`;
        const b_type = ["const", "cm"].includes(b.type) ? b.type : `custom${b.commitId}`;
        if(a.openingPos != b.openingPos) {
            return a.openingPos - b.openingPos;
        } else if(typeOrder[a_type] !== typeOrder[b_type]) {
            return typeOrder[b_type] - typeOrder[a_type];
        } else if(a.id !== b.id) {
            return a.id - b.id;
        } else {
            return a.prime - b.prime;
        }
    })

    pilCodeGen(ctx, symbols, expressions, res.cExpId, 0);
    verifierInfo.qVerifier = buildCode(ctx, expressions);
    verifierInfo.qVerifier.line = "";

    res.evMap = ctx.evMap;
}

