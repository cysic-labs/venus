const { printExpressions } = require("./utils");

module.exports = function map(res, symbols, expressions, constraints, options) {
    module.exports.mapSymbols(res, symbols);
    setStageInfoSymbols(res, symbols);

    for(let i = 0; i < constraints.length; ++i) {
        if(constraints[i].filename === `${res.name}.ImPol`) {
            constraints[i].imPol = true;
            if(!options.recursion) {
                constraints[i].line = printExpressions(res, expressions[constraints[i].e], expressions, true);
            } else {
                constraints[i].line = "";
            }  
        }
        constraints[i].line += " == 0";
    }

    console.log("----------------- INTERMEDIATE POLYNOMIALS -----------------");
    res.imPolsInfo = { baseField: [], extendedField: []};
    const imPols = res.cmPolsMap.filter(i => i.imPol === true);
    for(let i = 0; i < imPols.length; ++i) {
        if(!options.recursion) {
            const imPolExpression = printExpressions(res, expressions[imPols[i].expId], expressions);
            if(i > 0) console.log("------------------------------------------------------------");
            console.log(`Intermediate polynomial ${i} columns: ${imPols[i].dim}`);
            console.log(imPolExpression);
            if(imPols[i].dim == 1) {
                res.imPolsInfo.baseField.push(imPolExpression);
            } else {
                res.imPolsInfo.extendedField.push(imPolExpression);
            }
        }
    }
    res.nCommitmentsStage1 = res.cmPolsMap.filter(p => p.stage === "cm1" && !p.imPol).length; 
}

module.exports.mapSymbols = function mapSymbols(res, symbols) {
    for(let i = 0; i < symbols.length; ++i) {
    let symbol = symbols[i];
        if(["witness", "fixed", "custom"].includes(symbol.type)) {
            if(symbol.type === "fixed") {
                symbol.stageId = symbol.polId;
            } else {
                if(isNaN(symbol.stage) || (symbol.type === "witness" && symbol.stage === 0)) throw new Error("Invalid witness stage");
            }
            
            addPol(res, symbol);
        } else if(symbol.type === "challenge") {
            res.challengesMap[symbol.id] = {name: symbol.name, stage: symbol.stage, dim: symbol.dim, stageId: symbol.stageId};
        } else if(symbol.type === "public") {
            res.publicsMap[symbol.id] = {name: symbol.name, stage: symbol.stage};
            if(symbol.lengths) res.publicsMap[symbol.id].lengths = symbol.lengths;
        } else if(symbol.type === "airgroupvalue") {
            res.airgroupValuesMap[symbol.id] = { name: symbol.name, stage: symbol.stage };
            if(symbol.lengths) res.airgroupValuesMap[symbol.id].lengths = symbol.lengths;
        } else if(symbol.type == "airvalue") {
            res.airValuesMap[symbol.id] = { name: symbol.name, stage: symbol.stage };
            if(symbol.lengths) res.airValuesMap[symbol.id].lengths = symbol.lengths;
        } else if(symbol.type == "proofvalue") {
            res.proofValuesMap[symbol.id] = { name: symbol.name, stage: symbol.stage };
            if(symbol.lengths) res.proofValuesMap[symbol.id].lengths = symbol.lengths;
        }
    }
}

function addPol(res, symbol) {
    if(!["fixed", "witness", "custom"].includes(symbol.type)) throw new Error("Invalid symbol type " + symbol.type);
    const ref = symbol.type === "fixed" ? res.constPolsMap : symbol.type === "witness" ? res.cmPolsMap : res.customCommitsMap[symbol.commitId];
    const pos = symbol.polId;
    const stage = symbol.stage;
    const name = symbol.name;
    const dim = symbol.dim;
    ref[pos] = {stage, name, dim, polsMapId: pos};
    if(symbol.stageId >= 0) ref[pos].stageId = symbol.stageId;
    if(symbol.type === "fixed") {
        res.mapSectionsN["const"] += dim;
    } else if(symbol.type === "witness") {
        res.mapSectionsN["cm" + stage] += dim;
    } else {
        res.mapSectionsN[res.customCommits[symbol.commitId].name + stage] += dim;
    }
    if(symbol.lengths) ref[pos].lengths = symbol.lengths;
    if(symbol.imPol) {
        ref[pos].imPol = symbol.imPol;
        ref[pos].expId = symbol.expId;
    }
}

function setStageInfoSymbols(res, symbols) {
    const qStage = res.nStages + 1;
    for(let i = 0; i < symbols.length; ++i) {
        const symbol = symbols[i];
        if(!["fixed", "witness", "custom"].includes(symbol.type)) continue;
        if(symbol.type === "witness"  || symbol.type === "custom"){
            const polsMap = symbol.type === "witness" ? res["cmPolsMap"] : res["customCommitsMap"][symbol.commitId];
            const prevPolsStage = polsMap
            .filter((p, index) => p.stage === symbol.stage && index < symbol.polId);

            symbol.stagePos = prevPolsStage.reduce((acc, p) => acc + p.dim, 0);
            polsMap[symbol.polId].stagePos = symbol.stagePos;
            if(!symbol.stageId) {
                symbol.stageId = symbol.stage === qStage 
                    ? prevPolsStage.length 
                    : polsMap.filter(p => p.stage === symbol.stage).findIndex(p => p.name === symbol.name);
                    polsMap[symbol.polId].stageId = symbol.stageId;
            }
        }
    }
}
