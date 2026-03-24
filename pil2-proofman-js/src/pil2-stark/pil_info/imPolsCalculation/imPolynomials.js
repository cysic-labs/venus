
const ExpressionOps = require("../expressionops");
const { FIELD_EXTENSION } = require("../../../constants.js");
const { getExpDim, addInfoExpressions } = require("../helpers/helpers");

module.exports.addIntermediatePolynomials = function addIntermediatePolynomials(res, expressions, constraints, symbols, imExps, qDeg) {
    const E = new ExpressionOps();

    console.log("--------------------- SELECTED DEGREE ----------------------");
    console.log(`Constraints maximum degree: ${qDeg + 1}`);
    console.log(`Number of intermediate polynomials required: ${imExps.length}`);

    res.qDeg = qDeg;

    const dim = FIELD_EXTENSION;
    const stage = res.nStages + 1;

    const vc_id = symbols.filter(s => s.type === "challenge" && s.stage < stage).length;

    const vc = E.challenge("std_vc", stage, dim, 0, vc_id);
    vc.expDeg = 0;
    
    // const maxDegExpr = module.exports.calculateExpDeg(expressions, expressions[res.cExpId], imExps);
    // if(maxDegExpr > qDeg + 1) {
    //     throw new Error(`The maximum degree of the constraint expression has a higher degree (${maxDegExpr}) than the maximum allowed degree (${qDeg + 1})`);
    // }

    // for (let i=0; i<imExps.length; i++) {
    //     const expId = imExps[i];

    //     const imPolDeg = module.exports.calculateExpDeg(expressions, expressions[expId], imExps);
    //     if(imPolDeg > qDeg + 1) {
    //         throw new Error(`Intermediate polynomial with id: ${expId} has a higher degree (${imPolDeg}) than the maximum allowed degree (${qDeg + 1})`);
    //     }
    // }

    for (let i=0; i<imExps.length; i++) {
        const expId = imExps[i];

        const stageIm = res.imPolsStages ? expressions[expId].stage : res.nStages;
        
        const stageId = symbols.filter(s => s.type === "witness" && s.stage === stageIm).length;

        const dim = getExpDim(expressions, expId);
      
        symbols.push({ type: "witness", name: `${res.name}.ImPol`, expId, polId: res.nCommitments++, stage: stageIm, stageId, dim, imPol: true, airId: res.airId, airgroupId: res.airgroupId });    
        
        expressions[expId].imPol = true;
        expressions[expId].polId = res.nCommitments - 1;
        expressions[expId].stage = stageIm;

        let e = {
            op: "sub",
            values: [
                E.cm(res.nCommitments-1, 0, stageIm, dim),
                Object.assign({}, expressions[imExps[i]]),
            ]
        };
        expressions.push(e);
        addInfoExpressions(expressions, e);
        let constraintId = expressions.length - 1;

        constraints.push({ e: constraintId, boundary: "everyRow", filename: `${res.name}.ImPol`, stage: expressions[expId].stage });
        
        const weightedConstraint = E.mul(vc, E.exp(res.cExpId, 0, stage));
        expressions.push(weightedConstraint);
        let weightedConstraintId = expressions.length - 1;
        addInfoExpressions(expressions, weightedConstraint);

        const accumulatedConstraints = E.add(E.exp(weightedConstraintId, 0, stage), E.exp(constraintId, 0, stage));
        expressions.push(accumulatedConstraints);
        addInfoExpressions(expressions, accumulatedConstraints);
        res.cExpId = expressions.length - 1;
    }

    let q = E.mul(expressions[res.cExpId], E.zi(res.boundaries.findIndex(b => b.name === "everyRow")));
    expressions.push(q);
    addInfoExpressions(expressions, q);
    res.cExpId++;
    
    let cExpDim = getExpDim(expressions, res.cExpId);
    expressions[res.cExpId].dim = cExpDim;

    res.qDim = cExpDim;

    for (let i=0; i<res.qDeg; i++) {
        const index = res.nCommitments++;
        symbols.push({ type: "witness", name: `Q${i}`, polId: index, stage, dim: res.qDim, airId: res.airId, airgroupId: res.airgroupId });
        E.cm(index, 0, stage, res.qDim);
    }

    res.nConstraints = constraints.length;
    
}

module.exports.calculateIntermediatePolynomials = function calculateIntermediatePolynomials(expressions, cExpId, maxQDeg, qDim) {
    let d = 2;

    console.log("-------------------- POSSIBLE DEGREES ----------------------");
    console.log(`** Considering degrees between 2 and ${maxQDeg} (blowup factor: ${Math.log2(maxQDeg - 1)}) **`);
    console.log("------------------------------------------------------------");
    const cExp = expressions[cExpId];
    let [imExps, qDeg] = calculateImPols(expressions, cExp, d);
    let addedBasefieldCols = calculateAddedCols(d++, expressions, imExps, qDeg, qDim);
    while(imExps.length > 0 && d <= maxQDeg) {
        console.log("------------------------------------------------------------");
        let [imExpsP, qDegP] = calculateImPols(expressions, cExp, d);
        let newAddedBasefieldCols = calculateAddedCols(d++, expressions, imExpsP, qDegP, qDim);
        if ((maxQDeg && newAddedBasefieldCols < addedBasefieldCols) 
            || (!maxQDeg && imExpsP.length === 0)) {
            addedBasefieldCols = newAddedBasefieldCols;
            [imExps, qDeg] = [imExpsP, qDegP];
        }
        if(imExpsP.length === 0) break;
    }

    return {newExpressions: expressions, imExps, qDeg};
}

function calculateAddedCols(maxDeg, expressions, imExps, qDeg, qDim) {
    let qCols = qDeg * qDim;
    let imCols = 0;
    for(let i = 0; i < imExps.length; i++) {
       imCols += expressions[imExps[i]].dim;
    }
    let addedCols = qCols + imCols;
    console.log(`Max constraint degree: ${maxDeg}`);
    console.log(`Number of intermediate polynomials: ${imExps.length}`);
    console.log(`Polynomial Q degree: ${qDeg}`);
    console.log(`Number of columns added in the basefield: ${addedCols} (Polynomial Q columns: ${qCols} + Intermediate polynomials columns: ${imCols})`);

    return addedCols;
}

function calculateImPols(expressions, _exp, maxDeg) {

    const imPols = [];
    const absoluteMax = maxDeg;
    let absMaxD = 0;

    [re, rd] = _calculateImPols(expressions, _exp, imPols, maxDeg);

    return [re, Math.max(rd, absMaxD) - 1];  // We divide the exp polynomial by 1.

    function _calculateImPols(expressions, exp, imPols, maxDeg) {
        if (imPols === false) {
            return [false, -1];
        }

        if (["add", "sub"].indexOf(exp.op) >=0 ) {
            let md = 0;
            for (let i=0; i<exp.values.length; i++) {
                [imPols , d] = _calculateImPols(expressions, exp.values[i], imPols, maxDeg);
                if (d>md) md = d;
            }
            return [imPols, md];
        } else if (exp.op == "mul") {
            let eb = false;
            let ed = -1;
            if(!["add", "mul", "sub", "exp"].includes(exp.values[0].op) && exp.values[0].expDeg === 0) { 
                return _calculateImPols(expressions, exp.values[1], imPols, maxDeg);
            }
            if(!["add", "mul", "sub", "exp"].includes(exp.values[1].op) && exp.values[1].expDeg === 0) { 
                return _calculateImPols(expressions, exp.values[0], imPols, maxDeg);
            }
            const maxDegHere = exp.expDeg;
            if (maxDegHere <= maxDeg) {
                return [imPols, maxDegHere];
            }
            for (let l=0; l<=maxDeg; l++) {
                let r = maxDeg-l;
                const [e1, d1] = _calculateImPols(expressions, exp.values[0], imPols, l);
                const [e2, d2] = _calculateImPols(expressions, exp.values[1], e1, r );
                if(e2 !== false && (eb === false || e2.length < eb.length)) {
                    eb = e2;
                    ed = d1+d2;
                } 
            
                if (eb !== false && eb.length == imPols.length) return [eb, ed];  // Cannot do it better.
            }
            return [eb, ed];
        } else if (exp.op == "exp") {
            if (maxDeg < 1) {
                return [false, -1];
            }
            if (imPols.findIndex(im => im === exp.id) !== -1) return [imPols, 1];
            let e,d;
            if(exp.res && exp.res[absoluteMax] && exp.res[absoluteMax][JSON.stringify(imPols)]) {
                [e,d] = exp.res[absoluteMax][JSON.stringify(imPols)];
            } else {
                [e,d] = _calculateImPols(expressions, expressions[exp.id], imPols, absoluteMax);
            }
            if (e === false) {
                return [false, -1];
            }
            if (d > maxDeg) {
                if (d>absMaxD) absMaxD = d;
                return [[...e, exp.id], 1];
            } else {
                if(!exp.res) exp.res = {};
                if(!exp.res[absoluteMax]) exp.res[absoluteMax] = {};
                exp.res[absoluteMax][JSON.stringify(imPols)] = [e, d];
                return exp.res[absoluteMax][JSON.stringify(imPols)];
            }
        } else {
            if(exp.expDeg === 0) {
                return [imPols, 0];
            } else if (maxDeg < 1) {
                return [false, -1];
            } else {
                return [imPols, 1];
            }
        }
    }
}

module.exports.calculateExpDeg = function calculateExpDeg(expressions, exp, imExps = [], cacheValues = false) {
    if(cacheValues && exp.degree_) return exp.degree_;
    if (exp.op == "exp") {
        if (imExps.includes(exp.id)) return 1;
        let deg = calculateExpDeg(expressions, expressions[exp.id], imExps, cacheValues);
        if(cacheValues) exp.degree_= deg;
        return deg;
    } else if (["const", "cm", "custom"].includes(exp.op) || (exp.op === "Zi" && exp.boundary !== "everyRow")) {
        return 1;
    } else if (["number", "public", "challenge", "eval", "airgroupvalue", "airvalue", "proofvalue"].includes(exp.op) || (exp.op === "Zi" && exp.boundary === "everyRow")) {
        return 0;
    } else if(exp.op === "neg") {
        return calculateExpDeg(expressions, exp.values[0], imExps, cacheValues);
    } else if(["add", "sub", "mul"].includes(exp.op)) {
        const lhsDeg = calculateExpDeg(expressions, exp.values[0], imExps, cacheValues);
        const rhsDeg = calculateExpDeg(expressions, exp.values[1], imExps, cacheValues);
        let deg = exp.op === "mul" ? lhsDeg + rhsDeg : Math.max(lhsDeg, rhsDeg);
        if(cacheValues) exp.degree_= deg;
        return deg;
    } else {
        throw new Error("Exp op not defined: "+ exp.op);
    }
}

