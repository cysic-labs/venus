
const pilInfo = require("./pil_info/pil_info.js");
const { getOptimalFRIQueryParams } = require("../setup/security.js");
const Decimal = require("decimal.js");

module.exports.starkSetup = async function starkSetup(pil, starkStruct, options) {
    console.log("Generating STARK setup...");       
    const {pilInfo: starkInfo, expressionsInfo, verifierInfo, stats} = await pilInfo(pil, starkStruct, options);


    const params = {
        fieldSize: (2n ** 64n - 2n ** 32n + 1n) ** 3n,
        dimension: 1 << starkStruct.nBits,
        rate: new Decimal(1 / (1 << (starkStruct.nBitsExt - starkStruct.nBits))),
        nOpeningPoints: starkInfo.openingPoints.length,
        nConstraints: starkInfo.nConstraints,
        nFunctions: starkInfo.evMap.length,
        foldingFactors: starkInfo.starkStruct.steps.map((_, i, arr) => {
            if (i === arr.length - 1) return null; 
            return arr[i].nBits - arr[i + 1].nBits;
        }).filter(v => v !== null),
        maxGrindingBits: starkStruct.powBits,
        targetSecurityBits: 128,
        useMaxGrindingBits: true,
        treeArity: starkStruct.merkleTreeArity,
    };

    const fri_security = getOptimalFRIQueryParams("JBR", params);

    starkInfo.starkStruct.nQueries = fri_security.nQueries;
    starkInfo.starkStruct.powBits = fri_security.nGrindingBits;
    starkInfo.security = {
        proximityGap: fri_security.proximityGap.toNumber(),
        proximityParameter: fri_security.proximityParameter.toNumber(),
        regime: "JBR",
    };

    const res = {
        starkInfo,
        expressionsInfo,
        verifierInfo,
        stats,
    }
    
    return res;
}
