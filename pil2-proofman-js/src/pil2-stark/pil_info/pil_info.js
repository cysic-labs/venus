const {calculateIntermediatePolynomials, addIntermediatePolynomials} = require("./imPolsCalculation/imPolynomials");
const { FIELD_EXTENSION } = require("../../constants.js");

const { preparePil } = require("./helpers/preparePil");
const { generatePilCode } = require("./helpers/generatePilCode");
const map = require("./map");

const fs = require("fs");
const path = require("path");

const util = require('util');
const childProcess = require('child_process'); // Split into two lines for clarity

const exec = util.promisify(childProcess.exec);
const {tmpName} = require("tmp-promise");

module.exports = async function pilInfo(pil, starkStruct, options = {}) {
    const infoPil = preparePil(pil, starkStruct, options);
    
    const expressions = infoPil.expressions;
    const constraints = infoPil.constraints;
    const hints = infoPil.hints;
    const symbols = infoPil.symbols;
    const res = infoPil.res;
    
    let newExpressions = expressions;
    let maxDeg = (1 << (res.starkStruct.nBitsExt- res.starkStruct.nBits)) + 1;

    if(!options.debug || !options.skipImPols) {
        let imInfo;

        if(options.optImPols) {
            const infoPilFile = await tmpName();
            const imPolsFile = await tmpName();

            let maxDeg =  (1 << (starkStruct.nBitsExt - starkStruct.nBits)) + 1;

            const infoPilJSON = { maxDeg, cExpId: infoPil.res.cExpId, qDim: infoPil.res.qDim, ...infoPil };

            await fs.promises.writeFile(infoPilFile, JSON.stringify(infoPilJSON, null, 1), "utf8");

            const calculateImPolsPath = path.resolve(__dirname, './imPolsCalculation/calculateImPols.py');

            const { stdout } = await exec(`python3 ${calculateImPolsPath} ${infoPilFile} ${imPolsFile}`);
            console.log(stdout);

            imInfo = JSON.parse(await fs.promises.readFile(imPolsFile, "utf8"));

            fs.promises.unlink(infoPilFile); 
            fs.promises.unlink(imPolsFile);
        } else {
            imInfo = calculateIntermediatePolynomials(expressions, res.cExpId, maxDeg, res.qDim);
        }
        
        newExpressions = imInfo.newExpressions;
        addIntermediatePolynomials(res, newExpressions, constraints, symbols, imInfo.imExps, imInfo.qDeg);
    }
    
    map(res, symbols, newExpressions, constraints, options);       

    const {expressionsInfo, verifierInfo} = generatePilCode(res, symbols, constraints, newExpressions, hints, options.debug);
    
    let nCols = {};
    let summary = "";
    
    console.log("------------------------- AIR INFO -------------------------")
    let nColumnsBaseField = 0;
    let nColumns = 0;
    summary = `nBits: ${res.starkStruct.nBits} | blowUpFactor: ${res.starkStruct.nBitsExt - res.starkStruct.nBits} | maxConstraintDegree: ${res.qDeg + 1} `;
    console.log(`Columns fixed: ${res.mapSectionsN.const} -> Columns in the basefield: ${res.mapSectionsN.const}`);
    summary += `| Fixed: ${res.mapSectionsN.const} `;  
    for(let i = 1; i <= res.nStages + 1; ++i) {
        let stage = i;
        let stageDebug = i === res.nStages + 1 ? "Q" : stage;
        let stageName = "cm" + stage;
        let nColsStage = res.cmPolsMap.filter(p => p.stage == stage).length;
        nCols[stageName] = nColsStage;
        let nColsBaseField = res.mapSectionsN[stageName];
        let imPols = res.cmPolsMap.filter(p => p.stage == stage && p.imPol);
        if(i === res.nStages + 1 || (i < res.nStages && !res.imPolsStages)) {
            console.log(`Columns stage ${stageDebug}: ${nColsStage} -> Columns in the basefield: ${nColsBaseField}`);
        } else {
            console.log(`Columns stage ${stageDebug}: ${nColsStage} (${imPols.length} intermediate polynomials) -> Columns in the basefield: ${nColsBaseField} (${imPols.reduce((acc, curr) => acc + curr.dim, 0)} from intermediate polynomials)`);
        }
        if(i < res.nStages + 1) {
            summary += `| Stage${i}: ${nColsBaseField} `;  
        } else if (i == res.nStages + 1) {
            summary += `| StageQ: ${nColsBaseField} `; 
        }
        nColumns += nColsStage;
        nColumnsBaseField += nColsBaseField;
    }

    const imPols = res.cmPolsMap.filter(p => p.imPol);
    summary += `| ImPols: ${imPols.length} => ${imPols.reduce((acc, curr) => acc + curr.dim, 0)} = ${imPols.filter(i => i.dim === 1).reduce((acc, curr) => acc + curr.dim, 0)} + ${imPols.filter(i => i.dim === FIELD_EXTENSION).reduce((acc, curr) => acc + curr.dim, 0)} `;
    
    if(res.evMap) summary += `| Total: ${nColumnsBaseField} | nConstraints: ${constraints.length}`;
    if(res.openingPoints) summary += ` | nOpeningPoints: ${res.openingPoints.length}`;
    if(res.evMap) summary += ` | nEvals: ${res.evMap.length}`;
    
    console.log(`Total Columns: ${nColumns} -> Columns in the basefield: ${nColumnsBaseField}`);
    console.log(`Total Constraints: ${constraints.length}`)
    if(!options.debug) console.log(`Number of opening points: ${res.openingPoints.length}`)
    if(!options.debug) console.log(`Number of evaluations: ${res.evMap.length}`)

    let prover_memory = getProverMemory(res);
    console.log(`Prover memory: ${prover_memory} GB`);
    summary += `| Prover memory: ${prover_memory} GB`;
    console.log("------------------------------------------------------------")
    console.log(`SUMMARY | ${pil.name} | ${summary}`);
    console.log("------------------------------------------------------------")
        
    let stats = {summary, intermediatePolynomials: res.imPolsInfo};
    
    delete res.nCommitments;
    delete res.imPolsStages;
    delete res.pilPower;
    delete res.imPolsInfo;

    return {pilInfo: res, expressionsInfo, verifierInfo, stats};
}

function getNumNodesMT(height, starkStruct) {
    let numNodes = height;
    let nodesLevel = height;

    while (nodesLevel > 1) {
        let extraZeros = (starkStruct.merkleTreeArity - (nodesLevel % starkStruct.merkleTreeArity)) % starkStruct.merkleTreeArity;
        numNodes += extraZeros;
        let nextN = (nodesLevel + (starkStruct.merkleTreeArity - 1))/starkStruct.merkleTreeArity;
        numNodes += nextN;
        nodesLevel = nextN;
    }

    return numNodes * 4;
}

function getProverMemory(res) {
    let prover_memory = 0;
    
    let n_extended = 1 << res.starkStruct.nBitsExt;
    let n = 1 << res.starkStruct.nBits;

    let num_nodes = getNumNodesMT(n_extended, res.starkStruct);
    

    for (let i = 0; i < res.customCommits.length; ++i) {
        if (res.customCommits[i].stageWidths[0] > 0) {
            prover_memory += res.customCommits[i].stageWidths[0] * (n + n_extended) + num_nodes;
        }
    }
    
    prover_memory += 2 + n_extended * res.nConstants + num_nodes;

    if (((res.nConstants * n * 8) / (1024 * 1024)) < 512) {
        prover_memory += n * res.nConstants;
    }

    let offset_traces = 0;
    for(let i = 1; i <= res.nStages + 1; ++i) {
        if (i == 2) {
            offset_traces = prover_memory;
        }
        prover_memory += res.mapSectionsN["cm" + i] * (1 << res.starkStruct.nBitsExt) + num_nodes;
    }

    for(let i = res.nStages; i >= 1; --i) {
        offset_traces += res.mapSectionsN["cm" + i] * n;
    }

    if (offset_traces > prover_memory) {
        prover_memory = offset_traces;
    }

    prover_memory += (FIELD_EXTENSION + FIELD_EXTENSION + res.boundaries.length) * n_extended;
    
    for(let i = 0; i < res.starkStruct.steps.length - 1; ++i) {
        let height = 1 << res.starkStruct.steps[i + 1].nBits;
        let width = ((1 << res.starkStruct.steps[i].nBits) / height) * FIELD_EXTENSION;
        prover_memory += height * width + getNumNodesMT(height, res.starkStruct);
    }

    return (prover_memory * 8 / (1024 * 1024 * 1024)).toFixed(2);
}
