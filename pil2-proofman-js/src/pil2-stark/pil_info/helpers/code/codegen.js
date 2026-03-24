const { FIELD_EXTENSION } = require("../../../../constants.js");

function pilCodeGen(ctx, symbols, expressions, expId, prime) {
    if (ctx.calculated[expId] && ctx.calculated[expId][prime]) return;

    calculateDeps(ctx, symbols, expressions, expressions[expId], prime, expId);

    let e = expressions[expId];
    
    const codeCtx = {
        expId: expId,
        tmpUsed: ctx.tmpUsed,
        calculated: ctx.calculated,
        dom: ctx.dom,
        verifierEvaluations: ctx.verifierEvaluations,
        evMap: ctx.evMap,
        airId: ctx.airId,
        airgroupId: ctx.airgroupId,
        openingPoints: ctx.openingPoints,
        stage: ctx.stage,
        code: []
    }

    const retRef = evalExp(codeCtx, symbols, expressions, e, prime);

    const r = { type: "exp", prime, id: expId, dim: e.dim };
    
    if (retRef.type === "tmp") {
        fixCommitPol(r, codeCtx, symbols);
        codeCtx.code[codeCtx.code.length-1].dest = r;
        if(r.type == "cm") codeCtx.tmpUsed--;
    } else {
        fixCommitPol(r, codeCtx, symbols);
        codeCtx.code.push({ op: "copy", dest: r, src: [ retRef ] })
    }

    ctx.code.push(...codeCtx.code);
    
    if(!ctx.calculated[expId]) ctx.calculated[expId] = {};
    ctx.calculated[expId][prime] = { cm: false, tmpId:  codeCtx.tmpUsed };

    if (codeCtx.tmpUsed > ctx.tmpUsed) ctx.tmpUsed = codeCtx.tmpUsed;
}

function evalExp(ctx, symbols, expressions, exp, prime) {
    prime = prime || 0;
    if (["add", "sub", "mul"].includes(exp.op)) {
        const values = [];
        for(let i = 0; i < exp.values.length; ++i) {
            values[i] = evalExp(ctx, symbols, expressions, exp.values[i], prime);
        }
        const r = { type: "tmp", id: ctx.tmpUsed++, dim: Math.max(...values.map(v => v.dim)) };

        ctx.code.push({
            op: exp.op,
            dest: r,
            src: values,
        });
        
        return r;
    } else if (["cm", "const", "custom"].includes(exp.op) || (exp.op === "exp" && ["cm", "const", "custom"].includes(expressions[exp.id].op))) {
        const expr = exp.op === "exp" ? expressions[exp.id] : exp;
        let p = expr.rowOffset || prime; 
        const r = { type: expr.op, id: expr.id, prime: p, dim: expr.dim };
        if(expr.op === "custom") r.commitId = expr.commitId;
        if(ctx.verifierEvaluations) fixEval(r, ctx, symbols);
        
        return r;
    } else if (exp.op === "exp") {
        let p = exp.rowOffset || prime; 
        const r = { type: exp.op, expId: exp.id, id: exp.id, prime: p, dim: exp.dim };
        fixCommitPol(r, ctx, symbols);
        return r;
    } else if (exp.op === "challenge") {
        return { type: exp.op, id: exp.id, stageId: exp.stageId, dim: exp.dim, stage: exp.stage }
    } else if (exp.op === "public") {
        return { type: exp.op, id: exp.id, dim: 1}
    } else if (exp.op === "proofvalue") {
        return { type: exp.op, id: exp.id, stage: exp.stage, dim: exp.dim}
    } else if (exp.op == "number") {
        return { type: exp.op, value: exp.value.toString(), dim: 1 }
    } else if ("eval" === exp.op) {
        return { type: exp.op, id: exp.id, dim: exp.dim}
    } else if (["airgroupvalue", "airvalue"].includes(exp.op)) {
        return { type: exp.op, id: exp.id, stage: exp.stage, dim: exp.dim, airgroupId: exp.airgroupId };
    } else if (exp.op == "xDivXSubXi") {
        return { type: exp.op, id: exp.id, opening: exp.opening, dim: FIELD_EXTENSION }
    } else if (exp.op == "Zi") {
        return { type: exp.op, boundaryId: exp.boundaryId, dim: 1 }
    } else {
        throw new Error(`Invalid op: ${exp.op}`);
    }
}


function calculateDeps(ctx, symbols, expressions, exp, prime, expId, evMap) {
    if (exp.op == "exp") {
        let p = exp.rowOffset || prime;
        pilCodeGen(ctx, symbols, expressions, exp.id, p, evMap);
    } else if (["add", "sub", "mul"].includes(exp.op)) {
        exp.values.map(v => calculateDeps(ctx, symbols, expressions, v, prime, expId, evMap));
    }
}

function fixExpression(r, ctx) {
    const prime = r.prime || 0;
    if (!ctx.expMap[prime]) ctx.expMap[prime] = {};
    if (typeof ctx.expMap[prime][r.id] === "undefined") {
        ctx.expMap[prime][r.id] = ctx.tmpUsed++;
    }

    r.type= "tmp";
    r.id= ctx.expMap[prime][r.id];
}

function fixDimensionsVerifier(ctx) {
    const tmpDim = [];

    for (let i=0; i<ctx.code.length; i++) {
        if (!["add", "sub", "mul", "copy"].includes(ctx.code[i].op)) throw new Error("Invalid op:"+ ctx.code[i].op);
        if (ctx.code[i].dest.type !== "tmp") throw new Error("Invalid dest type:"+ ctx.code[i].dest.type);
        let newDim = Math.max(...ctx.code[i].src.map(s => getDim(s)));
        tmpDim[ctx.code[i].dest.id] = newDim;
        ctx.code[i].dest.dim = newDim;
    }

    function getDim(r) {
        let d = r.type === "tmp" ? tmpDim[r.id] : r.type === "Zi" ? FIELD_EXTENSION : r.dim;
        r.dim = d;
        return d;
    }

}

function fixCommitPol(r, ctx, symbols) {
    const symbol = symbols.find(s => s.type === "witness" && s.expId === r.id && s.airId === ctx.airId && s.airgroupId === ctx.airgroupId);
    if(!symbol) return;
    if(symbol.imPol && (ctx.dom === "ext" || (symbol.stage <= ctx.stage && ctx.calculated[r.id] && ctx.calculated[r.id][r.prime] && ctx.calculated[r.id][r.prime].cm))) {
        r.type = "cm";
        r.id = symbol.polId;
        r.dim = symbol.dim;
        if(ctx.verifierEvaluations) fixEval(r, ctx);
    } else if(!ctx.verifierEvaluations && ctx.dom === "n" && ctx.calculated[r.id] && ctx.calculated[r.id][r.prime] && ctx.calculated[r.id][r.prime].cm) {
        r.type = "cm";
        r.id = symbol.polId;
        r.dim = symbol.dim;
    }
}

function fixEval(r, ctx) {
    const prime = r.prime || 0;
    let openingPos = ctx.openingPoints.findIndex(p => p === prime);
    let evalIndex = ctx.evMap.findIndex(e => e.type === r.type && e.id === r.id && e.openingPos === openingPos);
    delete r.prime;
    r.id = evalIndex;
    r.type = "eval";
    r.dim = FIELD_EXTENSION;
    return r;
}

function buildCode(ctx) {
    ctx.expMap = [];
    for(let i = 0; i < ctx.code.length; i++) {
        for(let j = 0; j < ctx.code[i].src.length; j++) {
            if(ctx.code[i].src[j].type === "exp") fixExpression(ctx.code[i].src[j], ctx);
        }
        if(ctx.code[i].dest.type === "exp") fixExpression(ctx.code[i].dest, ctx);
    }

    if(ctx.verifierEvaluations) fixDimensionsVerifier(ctx);

    let code = { tmpUsed: ctx.tmpUsed, code: ctx.code };
    
    ctx.code = [];
    ctx.calculated = [];
    ctx.tmpUsed = 0;

    return code;
}

module.exports.pilCodeGen = pilCodeGen;
module.exports.buildCode  = buildCode;
