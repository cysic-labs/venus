const fs = require('fs');
const { createBinFile,
    endWriteSection,
    startWriteSection
     } = require("@iden3/binfileutils");
const { getParserArgs } = require("./getParserArgs.js");

const CHELPERS_NSECTIONS = 3;
const CHELPERS_EXPRESSIONS_SECTION = 1;
const CHELPERS_CONSTRAINTS_DEBUG_SECTION = 2;
const CHELPERS_HINTS_SECTION = 3;

module.exports.writeStringToFile = async function writeStringToFile(fd, str) {
    let buff = new Uint8Array(str.length + 1);
    for (let i = 0; i < str.length; i++) {
        buff[i] = str.charCodeAt(i);
    }
    buff[str.length] = 0;

    await fd.write(buff);
}

module.exports.writeVerifierExpressionsBinFile = async function writeVerifierExpressionsBinFile(cHelpersFilename, starkInfo, verifierInfo) {
    console.log("> Writing the chelpers verifier file");
        
    const binFileInfo = await prepareVerifierExpressionsBin(starkInfo, verifierInfo);

    const verInfo = {};
    verInfo.expsInfo = [binFileInfo.qCode, binFileInfo.queryCode];

    const cHelpersBin = await createBinFile(cHelpersFilename, "chps", 1, 1, 1 << 22, 1 << 24);

    await writeExpressionsSection(cHelpersBin, verInfo.expsInfo, binFileInfo.numbersExps, binFileInfo.maxTmp1, binFileInfo.maxTmp3, binFileInfo.maxArgs, binFileInfo.maxOps, CHELPERS_EXPRESSIONS_SECTION);

    console.log("> Writing the chelpers file finished");
    console.log("---------------------------------------------");

    await cHelpersBin.close();
}

module.exports.writeVerifierRustFile = async function writeVerifierRustFile(verifierFilename, starkInfo, verifierInfo, verkeyRoot) {
    console.log("> Writing the chelpers verifier file");
        
    const rustVerifier = await prepareVerifierRust(starkInfo, verifierInfo, verkeyRoot);

    await fs.promises.writeFile(verifierFilename, rustVerifier, "utf8");        
}

module.exports.writeExpressionsBinFile = async function writeExpressionsBinFile(cHelpersFilename, starkInfo, expressionsInfo) {
    console.log("> Writing the chelpers file");

    const binFileInfo = await prepareExpressionsBin(starkInfo, expressionsInfo);

    const expsInfo = binFileInfo.expsInfo;
    const constraintsInfo = binFileInfo.constraintsInfo;
    const hintsInfo = binFileInfo.hintsInfo;

    const cHelpersBin = await createBinFile(cHelpersFilename, "chps", 1, CHELPERS_NSECTIONS, 1 << 22, 1 << 24);    
        
    await writeExpressionsSection(cHelpersBin, expsInfo, binFileInfo.numbersExps, binFileInfo.maxTmp1, binFileInfo.maxTmp3, binFileInfo.maxArgs, binFileInfo.maxOps, CHELPERS_EXPRESSIONS_SECTION);

    await writeConstraintsSection(cHelpersBin, constraintsInfo, binFileInfo.numbersConstraints, CHELPERS_CONSTRAINTS_DEBUG_SECTION);

    await writeHintsSection(cHelpersBin, hintsInfo, CHELPERS_HINTS_SECTION);

    console.log("> Writing the chelpers file finished");
    console.log("---------------------------------------------");

    await cHelpersBin.close();
}

async function writeExpressionsSection(cHelpersBin, expressionsInfo, numbersExps, maxTmp1, maxTmp3, maxArgs, maxOps, section) {
    console.log(`··· Writing Section ${section}. CHelpers expressions section`);

    await startWriteSection(cHelpersBin, section);

    const opsExpressions = [];
    const argsExpressions = [];

    const opsExpressionsOffset = [];
    const argsExpressionsOffset = [];
    
    for(let i = 0; i < expressionsInfo.length; i++) {
        if(i == 0) {
            opsExpressionsOffset.push(0);
            argsExpressionsOffset.push(0);
        } else {
            opsExpressionsOffset.push(opsExpressionsOffset[i-1] + expressionsInfo[i-1].ops.length);
            argsExpressionsOffset.push(argsExpressionsOffset[i-1] + expressionsInfo[i-1].args.length);
        }
        for(let j = 0; j < expressionsInfo[i].ops.length; j++) {
            opsExpressions.push(expressionsInfo[i].ops[j]);
        }
        for(let j = 0; j < expressionsInfo[i].args.length; j++) {
            argsExpressions.push(expressionsInfo[i].args[j]);
        }    
    }
    
    await cHelpersBin.writeULE32(maxTmp1);
    await cHelpersBin.writeULE32(maxTmp3);
    await cHelpersBin.writeULE32(maxArgs);
    await cHelpersBin.writeULE32(maxOps);
    await cHelpersBin.writeULE32(opsExpressions.length);
    await cHelpersBin.writeULE32(argsExpressions.length);
    await cHelpersBin.writeULE32(numbersExps.length);

    const nExpressions = expressionsInfo.length;

    //Write the number of expressions
    await cHelpersBin.writeULE32(nExpressions);

    for(let i = 0; i < nExpressions; i++) {
        const expInfo = expressionsInfo[i];
        await cHelpersBin.writeULE32(expInfo.expId);
        await cHelpersBin.writeULE32(expInfo.destDim);
        await cHelpersBin.writeULE32(expInfo.destId);
        await cHelpersBin.writeULE32(expInfo.stage);
        await cHelpersBin.writeULE32(expInfo.nTemp1);
        await cHelpersBin.writeULE32(expInfo.nTemp3);

        await cHelpersBin.writeULE32(expInfo.ops.length);
        await cHelpersBin.writeULE32(opsExpressionsOffset[i]);

        await cHelpersBin.writeULE32(expInfo.args.length);
        await cHelpersBin.writeULE32(argsExpressionsOffset[i]);
        
        module.exports.writeStringToFile(cHelpersBin, expInfo.line);
    }

    const buffOpsExpressions = new Uint8Array(opsExpressions.length);
    const buffOpsExpressionsV = new DataView(buffOpsExpressions.buffer);
    for(let j = 0; j < opsExpressions.length; j++) {
        buffOpsExpressionsV.setUint8(j, opsExpressions[j]);
    }

    const buffArgsExpressions = new Uint8Array(2*argsExpressions.length);
    const buffArgsExpressionsV = new DataView(buffArgsExpressions.buffer);
    for(let j = 0; j < argsExpressions.length; j++) {
        buffArgsExpressionsV.setUint16(2*j, argsExpressions[j], true);
    }

    const buffNumbersExpressions = new Uint8Array(8*numbersExps.length);
    const buffNumbersExpressionsV = new DataView(buffNumbersExpressions.buffer);
    for(let j = 0; j < numbersExps.length; j++) {
        buffNumbersExpressionsV.setBigUint64(8*j, BigInt(numbersExps[j]), true);
    }

    await cHelpersBin.write(buffOpsExpressions);
    await cHelpersBin.write(buffArgsExpressions);
    await cHelpersBin.write(buffNumbersExpressions);

    await endWriteSection(cHelpersBin);
}

async function writeConstraintsSection(cHelpersBin, constraintsInfo, numbersConstraints, section) {
    console.log(`··· Writing Section ${section}. CHelpers constraints debug section`);

    await startWriteSection(cHelpersBin, section);

    const opsDebug = [];
    const argsDebug = [];

    const opsOffsetDebug = [];
    const argsOffsetDebug = [];

    const nConstraints = constraintsInfo.length;

    for(let i = 0; i < nConstraints; i++) {
        if(i == 0) {
            opsOffsetDebug.push(0);
            argsOffsetDebug.push(0);
        } else {
            opsOffsetDebug.push(opsOffsetDebug[i-1] + constraintsInfo[i-1].ops.length);
            argsOffsetDebug.push(argsOffsetDebug[i-1] + constraintsInfo[i-1].args.length);
        }
        for(let j = 0; j < constraintsInfo[i].ops.length; j++) {
            opsDebug.push(constraintsInfo[i].ops[j]);
        }
        for(let j = 0; j < constraintsInfo[i].args.length; j++) {
            argsDebug.push(constraintsInfo[i].args[j]);
        }
    }

    await cHelpersBin.writeULE32(opsDebug.length);
    await cHelpersBin.writeULE32(argsDebug.length);
    await cHelpersBin.writeULE32(numbersConstraints.length);
    
    await cHelpersBin.writeULE32(nConstraints);

    for(let i = 0; i < nConstraints; i++) {
        const constraintInfo = constraintsInfo[i];

        await cHelpersBin.writeULE32(constraintInfo.stage);

        await cHelpersBin.writeULE32(constraintInfo.destDim);
        await cHelpersBin.writeULE32(constraintInfo.destId);

        await cHelpersBin.writeULE32(constraintInfo.firstRow);
        await cHelpersBin.writeULE32(constraintInfo.lastRow);
        await cHelpersBin.writeULE32(constraintInfo.nTemp1);
        await cHelpersBin.writeULE32(constraintInfo.nTemp3);

        await cHelpersBin.writeULE32(constraintInfo.ops.length);
        await cHelpersBin.writeULE32(opsOffsetDebug[i]);

        await cHelpersBin.writeULE32(constraintInfo.args.length);
        await cHelpersBin.writeULE32(argsOffsetDebug[i]);
        
        await cHelpersBin.writeULE32(constraintInfo.imPol);
        module.exports.writeStringToFile(cHelpersBin, constraintInfo.line);
    }

    const buffOpsDebug = new Uint8Array(opsDebug.length);
    const buffOpsDebugV = new DataView(buffOpsDebug.buffer);
    for(let j = 0; j < opsDebug.length; j++) {
        buffOpsDebugV.setUint8(j, opsDebug[j]);
    }

    const buffArgsDebug = new Uint8Array(2*argsDebug.length);
    const buffArgsDebugV = new DataView(buffArgsDebug.buffer);
    for(let j = 0; j < argsDebug.length; j++) {
        buffArgsDebugV.setUint16(2*j, argsDebug[j], true);
    }

    const buffNumbersDebug = new Uint8Array(8*numbersConstraints.length);
    const buffNumbersDebugV = new DataView(buffNumbersDebug.buffer);
    for(let j = 0; j < numbersConstraints.length; j++) {
        buffNumbersDebugV.setBigUint64(8*j, BigInt(numbersConstraints[j]), true);
    }
 
    await cHelpersBin.write(buffOpsDebug);
    await cHelpersBin.write(buffArgsDebug);
    await cHelpersBin.write(buffNumbersDebug);

    await endWriteSection(cHelpersBin);
}

async function writeHintsSection(cHelpersBin, hintsInfo, section) {
    console.log(`··· Writing Section ${section}. Hints section`);

    await startWriteSection(cHelpersBin, section);

    const nHints = hintsInfo.length;
    await cHelpersBin.writeULE32(nHints);

    for(let j = 0; j < nHints; j++) {
        const hint = hintsInfo[j];
        await module.exports.writeStringToFile(cHelpersBin, hint.name);
        const nFields = hint.fields.length;
        await cHelpersBin.writeULE32(nFields);
        for(let k = 0; k < nFields; k++) {
            const field = hint.fields[k];
            await module.exports.writeStringToFile(cHelpersBin, field.name);
            const nValues = field.values.length;
            await cHelpersBin.writeULE32(nValues);
            for(let v = 0; v < field.values.length; ++v) {
                const value = field.values[v];
                await module.exports.writeStringToFile(cHelpersBin, value.op);
                if(value.op === "number") {
                    const buffNumber = new Uint8Array(8);
                    const buffNumberV = new DataView(buffNumber.buffer);
                    buffNumberV.setBigUint64(0, BigInt(value.value), true);
                    await cHelpersBin.write(buffNumber);
                } else if(value.op === "string") {
                    module.exports.writeStringToFile(cHelpersBin, value.string);
                } else {
                    await cHelpersBin.writeULE32(value.id);
                }
                if(value.op === "custom" || value.op === "const" || value.op === "cm") await cHelpersBin.writeULE32(value.rowOffsetIndex);
                if(value.op === "tmp") await cHelpersBin.writeULE32(value.dim);
                if(value.op === "custom") await cHelpersBin.writeULE32(value.commitId);

                await cHelpersBin.writeULE32(value.pos.length);
                for(let p = 0; p < value.pos.length; ++p) {
                    await cHelpersBin.writeULE32(value.pos[p]);
                }
            }
            
        }
    }

    await endWriteSection(cHelpersBin);
}

async function prepareExpressionsBin(starkInfo, expressionsInfo) {
    
    const expsInfo = [];
    const constraintsInfo = [];
    const numbersExps = [];
    const numbersConstraints = [];

    let operations = [
        { dest_type: "dim1", src0_type: "dim1", src1_type: "dim1"}, 
        { dest_type: "dim3", src0_type: "dim3", src1_type: "dim1"}, 
        { dest_type: "dim3", src0_type: "dim3", src1_type: "dim3"},
    ];

    const N = 1 << (starkInfo.starkStruct.nBits);

    let maxTmp1 = 0;
    let maxTmp3 = 0;
    let maxArgs = 0;
    let maxOps = 0;

    // Get parser args for each constraint
    for(let j = 0; j < expressionsInfo.constraints.length; ++j) {
        const constraintCode = expressionsInfo.constraints[j];
        let firstRow;
        let lastRow;

        if(constraintCode.boundary === "everyRow") {
            firstRow = 0;
            lastRow = N;
        } else if(constraintCode.boundary === "firstRow" || constraintCode.boundary === "finalProof") {
            firstRow = 0;
            lastRow = 1;
        } else if(constraintCode.boundary === "lastRow") {
            firstRow = N-1;
            lastRow = N;
        } else if(constraintCode.boundary === "everyFrame") {
            firstRow = constraintCode.offsetMin;
            lastRow = N - constraintCode.offsetMax;
        } else throw new Error("Invalid boundary: " + constraintCode.boundary);

        const {expsInfo: constraintInfo} = getParserArgs(starkInfo, operations, constraintCode, numbersConstraints);

        constraintInfo.stage = constraintCode.stage;
        constraintInfo.firstRow = firstRow;
        constraintInfo.lastRow = lastRow;
        constraintInfo.line = constraintCode.line;
        constraintInfo.imPol = constraintCode.imPol;
        constraintsInfo.push(constraintInfo);

        if(constraintInfo.nTemp1 > maxTmp1) maxTmp1 = constraintInfo.nTemp1;
        if(constraintInfo.nTemp3 > maxTmp3) maxTmp3 = constraintInfo.nTemp3;
        if(constraintInfo.args.length > maxArgs) maxArgs = constraintInfo.args.length;
        if(constraintInfo.ops.length > maxOps) maxOps = constraintInfo.ops.length;
    }

    // Get parser args for each expression
    for(let i = 0; i < expressionsInfo.expressionsCode.length; ++i) {
        const expCode = JSON.parse(JSON.stringify(expressionsInfo.expressionsCode[i]));
        if(!expCode) continue;
        if(expCode.expId === starkInfo.cExpId || expCode.expId === starkInfo.friExpId || starkInfo.cmPolsMap.find(c => c.expId === expCode.expId)) {
                expCode.code[expCode.code.length - 1].dest.type = "tmp";
                expCode.code[expCode.code.length - 1].dest.id = expCode.tmpUsed++;
        }
        const {expsInfo: expInfo} = getParserArgs(starkInfo, operations, expCode, numbersExps);
        expInfo.expId = expCode.expId;
        expInfo.stage = expCode.stage;
        expInfo.line = expCode.line;
        expsInfo.push(expInfo);

        if(expInfo.nTemp1 > maxTmp1) maxTmp1 = expInfo.nTemp1;
        if(expInfo.nTemp3 > maxTmp3) maxTmp3 = expInfo.nTemp3;
        if(expInfo.args.length > maxArgs) maxArgs = expInfo.args.length;
        if(expInfo.ops.length > maxOps) maxOps = expInfo.ops.length;
    }
    
    const res = {
        expsInfo, constraintsInfo, hintsInfo: expressionsInfo.hintsInfo, numbersExps, numbersConstraints, maxTmp1, maxTmp3, maxArgs, maxOps
    };

    return res;
}

async function prepareVerifierExpressionsBin(starkInfo, verifierInfo) {
    
    let operations = [
        { dest_type: "dim1", src0_type: "dim1", src1_type: "dim1"}, 
        { dest_type: "dim3", src0_type: "dim3", src1_type: "dim1"}, 
        { dest_type: "dim3", src0_type: "dim3", src1_type: "dim3"},
    ];


    let maxTmp1 = 0;
    let maxTmp3 = 0;
    let maxArgs = 0;
    let maxOps = 0;
    let numbersExps = [];
    let {expsInfo: qCode} = getParserArgs(starkInfo, operations, verifierInfo.qVerifier, numbersExps, false, true, true);
    qCode.expId = starkInfo.cExpId;
    qCode.line = "";
    if (qCode.nTemp1 > maxTmp1) maxTmp1 = qCode.nTemp1;
    if (qCode.nTemp3 > maxTmp3) maxTmp3 = qCode.nTemp3;
    if (qCode.args.length > maxArgs) maxArgs = qCode.args.length;
    if (qCode.ops.length > maxOps) maxOps = qCode.ops.length;
    let {expsInfo: queryCode} = getParserArgs(starkInfo, operations, verifierInfo.queryVerifier, numbersExps, false, true);
    queryCode.expId = starkInfo.friExpId;
    queryCode.line = "";
    if (queryCode.nTemp1 > maxTmp1) maxTmp1 = queryCode.nTemp1;
    if (queryCode.nTemp3 > maxTmp3) maxTmp3 = queryCode.nTemp3;
    if (queryCode.args.length > maxArgs) maxArgs = queryCode.args.length;
    if (queryCode.ops.length > maxOps) maxOps = queryCode.ops.length;

    return {qCode, queryCode, numbersExps, maxTmp1, maxTmp3, maxArgs, maxOps};
}


async function prepareVerifierRust(starkInfo, verifierInfo, verkeyRoot) {
    
    let operations = [
        { dest_type: "dim1", src0_type: "dim1", src1_type: "dim1"}, 
        { dest_type: "dim3", src0_type: "dim3", src1_type: "dim1"}, 
        { dest_type: "dim3", src0_type: "dim3", src1_type: "dim3"},
    ];


 
    let {verifyRust: verifyQRust} = getParserArgs(starkInfo, operations, verifierInfo.qVerifier, [], false, true, true);
    let {verifyRust: verifyFRIRust} = getParserArgs(starkInfo, operations, verifierInfo.queryVerifier, [], false, true);
 
    let verifierRust = [];
    verifierRust.push(`use fields::{Goldilocks, CubicExtensionField, Field, Poseidon${starkInfo.starkStruct.merkleTreeArity * 4}};`);
    verifierRust.push("use crate::{Boundary, VerifierInfo, stark_verify};\n");
    verifyQRust.unshift("fn q_verify(challenges: &[CubicExtensionField<Goldilocks>], evals: &[CubicExtensionField<Goldilocks>], _publics: &[Goldilocks], zi: &[CubicExtensionField<Goldilocks>]) -> CubicExtensionField<Goldilocks> {");
    verifyQRust.unshift("#[allow(clippy::all)]");
    verifyQRust.unshift("#[rustfmt::skip]");
    verifyQRust.push("}");
    verifierRust.push(...verifyQRust);
    verifierRust.push("\n");
    verifyFRIRust.unshift("fn query_verify(challenges: &[CubicExtensionField<Goldilocks>], evals: &[CubicExtensionField<Goldilocks>], vals: &[Vec<Goldilocks>], xdivxsub: &[CubicExtensionField<Goldilocks>]) -> CubicExtensionField<Goldilocks> {");
    verifyFRIRust.unshift("#[allow(clippy::all)]");
    verifyFRIRust.unshift("#[rustfmt::skip]")
    verifyFRIRust.push("}\n");
    verifierRust.push(...verifyFRIRust);
    let verify = [];
    verify.push("#[rustfmt::skip]")
    verify.push("fn verifier_info() -> VerifierInfo {");
    verify.push("    VerifierInfo {");
    verify.push("        n_stages: " + starkInfo.nStages + ",");
    verify.push("        n_constants: " + starkInfo.nConstants + ",");
    verify.push("        n_evals: " + starkInfo.evMap.length + ",");
    verify.push("        n_bits: " + starkInfo.starkStruct.nBits + ",");
    verify.push("        n_bits_ext: " + starkInfo.starkStruct.nBitsExt + ",");
    verify.push("        arity: " + starkInfo.starkStruct.merkleTreeArity + ",");
    verify.push("        n_fri_queries: " + starkInfo.starkStruct.nQueries + ",");
    verify.push("        n_fri_steps: " + starkInfo.starkStruct.steps.length + ",");
    verify.push("        n_challenges: " + starkInfo.challengesMap.length + ",");
    verify.push("        n_challenges_total: " + (starkInfo.challengesMap.length + starkInfo.starkStruct.steps.length + 1) + ",");
    verify.push("        fri_steps: vec![" + starkInfo.starkStruct.steps.map(s => s.nBits).join(", ") + "],");
    verify.push("        hash_commits: " + starkInfo.starkStruct.hashCommits + ",");
    verify.push("        last_level_verification: " + starkInfo.starkStruct.lastLevelVerification + ",");
    verify.push("        pow_bits: " + starkInfo.starkStruct.powBits + ",");
    let num_vals = [];
    for(let i = 0; i < starkInfo.nStages + 1; ++i) {
        num_vals.push(starkInfo.mapSectionsN[`cm${i + 1}`]);
    }
    verify.push("        num_vals: vec![" + num_vals.join(", ") + "],");
    verify.push("        opening_points: vec![" + starkInfo.openingPoints.map(p => p.toString()).join(", ") + "],");
    let boundaries = [];
    for(let i = 0; i < starkInfo.boundaries.length; ++i) {
        const b = starkInfo.boundaries[i];
        const name      = b.name      ?? "None";
        const offsetMin = b.offsetMin ?? "None";
        const offsetMax = b.offsetMax ?? "None";
        boundaries.push(
            `Boundary { name: "${name}".to_string(), offset_min: ${offsetMin}, offset_max: ${offsetMax} }`
        );
    }
    verify.push("        boundaries: vec![" + boundaries.join(", ") + "],");
    verify.push("        q_deg: " + starkInfo.qDeg + ",");
    let qIndex = starkInfo.cmPolsMap.findIndex(p => p.stage === starkInfo.nStages + 1 && p.stageId === 0);
    let qEvIndex = starkInfo.evMap.findIndex(ev => ev.type === "cm" && ev.id === qIndex);
    verify.push("        q_index: " + qEvIndex + ",");
    verify.push("    }");
    verify.push("}\n");
    verify.push("pub fn verify(proof: &[u8], vk: &[u8]) -> bool {");
    verify.push(`    stark_verify::<Poseidon${starkInfo.starkStruct.merkleTreeArity * 4}, ${starkInfo.starkStruct.merkleTreeArity * 4}>(proof, vk, &verifier_info(), q_verify, query_verify)`);
    verify.push("}\n");

    verifierRust.push(...verify);
    let rustVerifier = verifierRust.join("\n");
    return rustVerifier;
}