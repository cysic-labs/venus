
const ExpressionOps = require("../expressionops");
const { FIELD_EXTENSION } = require("../../../constants.js");
const { getExpDim, addInfoExpressions } = require("../helpers/helpers");
const map = require("../map");
const { generateConstraintPolynomialVerifierCode } = require("../helpers/code/generateCode");
const { getOptimalFRIQueryParams } = require("../../../setup/security.js");
const Decimal = require("decimal.js");

const DEFAULT_GPU_COST_MODEL = Object.freeze({
    weights: Object.freeze({
        ntt: 1.0,
        merkle: 1.25,
        expression: 0.35,
        fri: 0.1,
    }),
    normalizers: Object.freeze({
        ntt: 1e6,
        merkle: 1e6,
        expression: 1e6,
        fri: 1e3,
    }),
});

module.exports.addIntermediatePolynomials = function addIntermediatePolynomials(res, expressions, constraints, symbols, imExps, qDeg, options = {}) {
    const E = new ExpressionOps();

    if(!options.silent) {
        console.log("--------------------- SELECTED DEGREE ----------------------");
        console.log(`Constraints maximum degree: ${qDeg + 1}`);
        console.log(`Number of intermediate polynomials required: ${imExps.length}`);
    }

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

module.exports.calculateIntermediatePolynomials = function calculateIntermediatePolynomials(expressions, cExpId, maxQDeg, qDim, context = {}) {
    let d = 2;
    // This selector now optimizes a GPU-time proxy, but it still evaluates the
    // existing "best decomposition per maxDeg" search space produced by calculateImPols().

    console.log("-------------------- POSSIBLE DEGREES ----------------------");
    console.log(`** Considering degrees between 2 and ${maxQDeg} (blowup factor: ${Math.log2(maxQDeg - 1)}) **`);
    console.log("------------------------------------------------------------");
    const cExp = expressions[cExpId];
    let [imExps, qDeg] = calculateImPols(expressions, cExp, d);
    let bestCost = calculateCandidateCost(d++, expressions, cExpId, imExps, qDeg, qDim, context);
    while(imExps.length > 0 && d <= maxQDeg) {
        console.log("------------------------------------------------------------");
        let [imExpsP, qDegP] = calculateImPols(expressions, cExp, d);
        let newCandidateCost = calculateCandidateCost(d++, expressions, cExpId, imExpsP, qDegP, qDim, context);
        if ((maxQDeg && isBetterCandidate(newCandidateCost, bestCost))
            || (!maxQDeg && imExpsP.length === 0)) {
            bestCost = newCandidateCost;
            [imExps, qDeg] = [imExpsP, qDegP];
        }
        if(imExpsP.length === 0) break;
    }

    console.log("------------------------------------------------------------");
    console.log(`Selected GPU score: ${bestCost.score.toFixed(3)} (NTT ${bestCost.components.ntt.toFixed(3)} + Merkle ${bestCost.components.merkle.toFixed(3)} + Expr ${bestCost.components.expression.toFixed(3)} + FRI ${bestCost.components.fri.toFixed(3)})`);

    return {newExpressions: expressions, imExps, qDeg, costModel: bestCost};
}

function calculateAddedCols(expressions, imExps, qDeg, qDim) {
    let qCols = qDeg * qDim;
    let imCols = 0;
    for(let i = 0; i < imExps.length; i++) {
       imCols += expressions[imExps[i]].dim;
    }
    return { addedCols: qCols + imCols, qCols, imCols };
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

function calculateCandidateCost(maxDeg, expressions, cExpId, imExps, qDeg, qDim, context) {
    const addedColsInfo = calculateAddedCols(expressions, imExps, qDeg, qDim);
    console.log(`Max constraint degree: ${maxDeg}`);
    console.log(`Number of intermediate polynomials: ${imExps.length}`);
    console.log(`Polynomial Q degree: ${qDeg}`);
    console.log(`Number of columns added in the basefield: ${addedColsInfo.addedCols} (Polynomial Q columns: ${addedColsInfo.qCols} + Intermediate polynomials columns: ${addedColsInfo.imCols})`);

    if(!canEstimateGpuCost(context)) {
        return {
            score: addedColsInfo.addedCols,
            components: { ntt: addedColsInfo.addedCols, merkle: 0, expression: 0, fri: 0 },
            metrics: { ...addedColsInfo },
        };
    }

    const costModel = mergeCostModel(context.options?.imPolsCostModel);
    const stageImCols = getStageImCols(expressions, imExps, context.res);
    const simulated = simulateCandidate(expressions, cExpId, imExps, qDeg, context);

    const n = 1 << context.res.starkStruct.nBits;
    const nExtended = 1 << context.res.starkStruct.nBitsExt;
    const qCols = qDeg * qDim;
    const totalImCols = Object.values(stageImCols).reduce((acc, cols) => acc + cols, 0);
    const totalAddedCols = totalImCols + qCols;

    const imPolExprOps = imExps.reduce((acc, expId) => acc + countExpressionOps(simulated.expressions, simulated.expressions[expId]), 0);
    const quotientExprOps = countExpressionOps(simulated.expressions, simulated.expressions[simulated.res.cExpId]);

    const nttWork = (
        totalImCols * (n * context.res.starkStruct.nBits + nExtended * context.res.starkStruct.nBitsExt) +
        qDim * nExtended * context.res.starkStruct.nBitsExt +
        qCols * nExtended * context.res.starkStruct.nBitsExt
    ) / costModel.normalizers.ntt;

    const merkleWork = (nExtended * totalAddedCols) / costModel.normalizers.merkle;

    const expressionWork = (
        imPolExprOps * n +
        quotientExprOps * nExtended
    ) / costModel.normalizers.expression;

    const friMetrics = estimateFriWork(simulated.res, totalAddedCols);
    const friWork = friMetrics.work / costModel.normalizers.fri;

    const components = {
        ntt: costModel.weights.ntt * nttWork,
        merkle: costModel.weights.merkle * merkleWork,
        expression: costModel.weights.expression * expressionWork,
        fri: costModel.weights.fri * friWork,
    };

    const score = components.ntt + components.merkle + components.expression + components.fri;

    console.log(`Estimated GPU score: ${score.toFixed(3)} (NTT ${components.ntt.toFixed(3)} + Merkle ${components.merkle.toFixed(3)} + Expr ${components.expression.toFixed(3)} + FRI ${components.fri.toFixed(3)})`);

    return {
        score,
        components,
        metrics: {
            ...addedColsInfo,
            stageImCols,
            nFunctions: simulated.res.evMap.length,
            nQueries: friMetrics.nQueries,
            quotientExprOps,
            imPolExprOps,
        },
    };
}

function canEstimateGpuCost(context) {
    return Boolean(
        context
        && context.res
        && context.constraints
        && context.symbols
        && context.res.starkStruct
        && Number.isInteger(context.res.starkStruct.nBits)
        && Number.isInteger(context.res.starkStruct.nBitsExt)
        && Array.isArray(context.res.starkStruct.steps)
        && context.res.starkStruct.steps.length > 0
    );
}

function mergeCostModel(model = {}) {
    return {
        weights: {
            ...DEFAULT_GPU_COST_MODEL.weights,
            ...(model.weights || {}),
        },
        normalizers: {
            ...DEFAULT_GPU_COST_MODEL.normalizers,
            ...(model.normalizers || {}),
        },
    };
}

function getStageImCols(expressions, imExps, res) {
    return imExps.reduce((acc, expId) => {
        const stage = res.imPolsStages ? expressions[expId].stage : res.nStages;
        acc[stage] = (acc[stage] || 0) + (expressions[expId].dim || 1);
        return acc;
    }, {});
}

function simulateCandidate(expressions, cExpId, imExps, qDeg, context) {
    const clonedExpressions = cloneValue(expressions);
    const clonedConstraints = cloneValue(context.constraints);
    const clonedSymbols = cloneValue(context.symbols);
    const clonedRes = cloneValue(context.res);

    clearMappedState(clonedRes);
    module.exports.addIntermediatePolynomials(clonedRes, clonedExpressions, clonedConstraints, clonedSymbols, imExps, qDeg, { silent: true });
    map.mapSymbols(clonedRes, clonedSymbols);
    generateConstraintPolynomialVerifierCode(clonedRes, {}, clonedSymbols, clonedExpressions);

    return { res: clonedRes, expressions: clonedExpressions, constraints: clonedConstraints, symbols: clonedSymbols };
}

function clearMappedState(res) {
    res.cmPolsMap = [];
    res.constPolsMap = [];
    res.challengesMap = [];
    res.publicsMap = [];
    res.proofValuesMap = [];
    res.airgroupValuesMap = [];
    res.airValuesMap = [];

    if(res.mapSectionsN) {
        for(const key of Object.keys(res.mapSectionsN)) {
            res.mapSectionsN[key] = 0;
        }
    }
}

function cloneValue(value) {
    if(typeof structuredClone === "function") {
        return structuredClone(value);
    }

    return JSON.parse(JSON.stringify(value));
}

function countExpressionOps(expressions, exp, cache = new WeakMap()) {
    if(!exp) return 0;
    if(cache.has(exp)) return cache.get(exp);

    let cost;
    if(exp.op === "exp") {
        const referenced = expressions[exp.id];
        cost = referenced?.imPol ? 0 : countExpressionOps(expressions, referenced, cache);
    } else if(["number", "public", "challenge", "eval", "airgroupvalue", "airvalue", "proofvalue", "cm", "const", "custom", "Zi", "xDivXSubXi"].includes(exp.op)) {
        cost = 0;
    } else if(exp.op === "neg") {
        cost = getNodeOpWeight(exp) + countExpressionOps(expressions, exp.values[0], cache);
    } else if(["add", "sub", "mul"].includes(exp.op)) {
        cost = getNodeOpWeight(exp)
            + countExpressionOps(expressions, exp.values[0], cache)
            + countExpressionOps(expressions, exp.values[1], cache);
    } else {
        cost = 0;
    }

    cache.set(exp, cost);
    return cost;
}

function getNodeOpWeight(exp) {
    const dim = exp.dim || FIELD_EXTENSION;
    if(exp.op === "mul") return 2 * dim;
    if(["add", "sub", "neg"].includes(exp.op)) return dim;
    return 0;
}

function estimateFriWork(res, totalAddedCols) {
    const nFunctions = res.evMap.length;
    const nQueries = estimateFriQueries(res, nFunctions);
    const hashesPerQuery = calculateHashesPerQuery(res);
    const nOpeningPoints = res.openingPoints.length;

    return {
        nQueries,
        work: nQueries * (hashesPerQuery + totalAddedCols) + nFunctions * nOpeningPoints,
    };
}

function estimateFriQueries(res, nFunctions) {
    const params = {
        fieldSize: (2n ** 64n - 2n ** 32n + 1n) ** 3n,
        dimension: 1 << res.starkStruct.nBits,
        rate: new Decimal(1 / (1 << (res.starkStruct.nBitsExt - res.starkStruct.nBits))),
        nOpeningPoints: res.openingPoints.length,
        nConstraints: res.nConstraints,
        nFunctions,
        foldingFactors: res.starkStruct.steps.map((_, i, arr) => {
            if (i === arr.length - 1) return null;
            return arr[i].nBits - arr[i + 1].nBits;
        }).filter(v => v !== null),
        maxGrindingBits: res.starkStruct.powBits ?? 0,
        targetSecurityBits: 128,
        useMaxGrindingBits: true,
        treeArity: res.starkStruct.merkleTreeArity,
    };

    return getOptimalFRIQueryParams("JBR", params).nQueries;
}

function calculateHashesPerQuery(res) {
    const arity = res.starkStruct.merkleTreeArity;
    const foldingFactors = res.starkStruct.steps.map((_, i, arr) => {
        if (i === arr.length - 1) return null;
        return arr[i].nBits - arr[i + 1].nBits;
    }).filter(v => v !== null);
    if(foldingFactors.length === 0) return 0;

    let accFoldingFactor = 1;
    let totalHashes = 0;
    const codewordLength = 1 << res.starkStruct.nBitsExt;
    for (let j = 0; j < foldingFactors.length - 1; j++) {
        const nLeafs = codewordLength / accFoldingFactor;
        totalHashes += foldingFactors[j] * calculateMerklePathHashes(nLeafs, arity);
        accFoldingFactor *= foldingFactors[j];
    }

    totalHashes += foldingFactors[0] * calculateMerklePathHashes(codewordLength, arity);
    return totalHashes;
}

function calculateMerklePathHashes(nLeafs, arity) {
    return (arity - 1) * Math.ceil(Math.log2(nLeafs) / Math.log2(arity));
}

function isBetterCandidate(candidate, current) {
    if(candidate.score !== current.score) {
        return candidate.score < current.score;
    }

    if(candidate.metrics.qCols !== current.metrics.qCols) {
        return candidate.metrics.qCols < current.metrics.qCols;
    }

    return candidate.metrics.addedCols < current.metrics.addedCols;
}
