const ProtoOut = require("pil2-compiler/src/proto_out.js");
const { formatExpressions, formatConstraints, formatSymbols, formatHints } = require("./utils");

module.exports.getPiloutInfo = function getPiloutInfo(res, pilout) {
    res.airId = pilout.airId;
    res.airgroupId = pilout.airgroupId;
    
    const constraints = formatConstraints(pilout);
    
    let expressions, symbols;
    const e = formatExpressions(pilout);
    expressions = e.expressions;
    symbols = formatSymbols(pilout);

    symbols = symbols.filter(s => !["witness", "fixed"].includes(s.type) || s.airId === res.airId && s.airgroupId === res.airgroupId);

    const airGroupValues = pilout.airGroupValues || [];
    res.pilPower = Math.log2(pilout.numRows);
    res.nCommitments = symbols.filter(s => s.type === "witness" && s.airId === res.airId && s.airgroupId === res.airgroupId).length;
    res.nConstants = symbols.filter(s => s.type === "fixed" && s.airId === res.airId && s.airgroupId === res.airgroupId).length;
    res.nPublics = symbols.filter(s => s.type === "public").length;
    res.airGroupValues = airGroupValues;
    if(pilout.numChallenges) {
        res.nStages = pilout.numChallenges.length;
    } else {
        const numChallenges = symbols.length > 0 ? new Array(Math.max(...symbols.map(s => s.stage || 0))).fill(0) : [];
        res.nStages = numChallenges.length;
    }
    
    const airHints = pilout.hints?.filter(h => h.airId === res.airId && h.airGroupId === res.airgroupId) || [];
    const hints = formatHints(pilout, airHints, symbols, expressions);

    res.customCommits = pilout.customCommits || [];
    res.customCommitsMap = [];
    for(let i = 0; i < res.customCommits.length; ++i) {
        res.customCommitsMap[i] = [];
        for(let j = 0; j < res.customCommits[i].stageWidths.length; ++j) {
            if(res.customCommits[i].stageWidths[j] > 0) {
                res.mapSectionsN[res.customCommits[i].name + j] = 0;
            }
        }
    }

    return {expressions, hints, constraints, symbols};
}

module.exports.getFixedPolsPil2 = function getFixedPolsPil2(airgroupName, pil, cnstPols, cnstPolsBinFilesInfo) {        
    const P = new ProtoOut();

    for(let i = 0; i < cnstPols.$$defArray.length; ++i) {
        const def = cnstPols.$$defArray[i];
        const id = def.id;
        const deg = def.polDeg;
        const fixedCols = pil.fixedCols[i];
        const constPol = cnstPols[id];
        if(Object.keys(fixedCols).length === 0) {
            const fixedPolsInfo = cnstPolsBinFilesInfo[`${airgroupName}_${pil.name}`];
            if (!fixedPolsInfo) {
                throw new Error(`Fixed polynomials info for airgroup ${airgroupName} and air ${pil.name} not found`);
            }
            if(!fixedPolsInfo[def.name]) {
                throw new Error(`Fixed polynomial ${def.name} not found`);
            }
            let fixed = fixedPolsInfo[def.name].find(e => JSON.stringify(e.lengths) === JSON.stringify(def.lengths));
            if(!fixed) {
                throw new Error(`Fixed polynomial ${def.name} with lenghts ${def.lengths} not found`);
            }
            let values = fixed.values;
            for(let j = 0; j < deg; ++j) {
                constPol[j] = BigInt(values[j]);
            }
        } else {
            for(let j = 0; j < deg; ++j) {
                constPol[j] = P.buf2bint(fixedCols.values[j]);
            }
        }        
    }
}
    
