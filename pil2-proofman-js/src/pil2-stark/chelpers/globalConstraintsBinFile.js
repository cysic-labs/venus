const GLOBAL_CONSTRAINTS_NSECTIONS = 2;
const GLOBAL_CONSTRAINTS_SECTION = 1;
const GLOBAL_HINTS_SECTION = 2;

const { createBinFile, startWriteSection, endWriteSection } = require("@iden3/binfileutils");
const { getParserArgs } = require("./getParserArgs.js");
const { writeStringToFile } = require("./binFile.js");

module.exports.writeGlobalConstraintsBinFile = async function writeGlobalConstraintsBinFile(globalInfo, globalConstraintsInfo, globalConstraintsFilename) {    
    const globalConstraintsBin = await createBinFile(globalConstraintsFilename, "chps", 1, GLOBAL_CONSTRAINTS_NSECTIONS, 1 << 22, 1 << 24);    

    const constraintsInfo = [];

    let operations = [
        { dest_type: "dim1", src0_type: "dim1", src1_type: "dim1"}, 
        { dest_type: "dim3", src0_type: "dim3", src1_type: "dim1"}, 
        { dest_type: "dim3", src0_type: "dim3", src1_type: "dim3"},
    ];

  
    let numbers = [];

    // Get parser args for each constraint
    for(let j = 0; j < globalConstraintsInfo.constraints.length; ++j) {
        const constraintInfo = getParserArgs({}, operations, globalConstraintsInfo.constraints[j], numbers, true, false, globalInfo).expsInfo;
        constraintInfo.line = globalConstraintsInfo.constraints[j].line;
        constraintsInfo.push(constraintInfo);
    }

    const hintsInfo = globalConstraintsInfo.hints;

    await writeConstraintsSection(globalConstraintsBin, constraintsInfo, numbers, GLOBAL_CONSTRAINTS_SECTION);

    await writeHintsSection(globalConstraintsBin, hintsInfo, GLOBAL_HINTS_SECTION);

    console.log("> Writing the global constraints file finished");
    console.log("---------------------------------------------");

    await globalConstraintsBin.close();
}

async function writeConstraintsSection(globalConstraintsBin, constraintsInfo, numbersConstraints, section) {
    console.log(`··· Writing Section ${section}. CHelpers constraints debug section`);

    await startWriteSection(globalConstraintsBin, section);

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

    await globalConstraintsBin.writeULE32(opsDebug.length);
    await globalConstraintsBin.writeULE32(argsDebug.length);
    await globalConstraintsBin.writeULE32(numbersConstraints.length);

    await globalConstraintsBin.writeULE32(nConstraints);

    for(let i = 0; i < nConstraints; i++) {
        const constraintInfo = constraintsInfo[i];

        await globalConstraintsBin.writeULE32(constraintInfo.destDim);
        await globalConstraintsBin.writeULE32(constraintInfo.destId);

        await globalConstraintsBin.writeULE32(constraintInfo.nTemp1);
        await globalConstraintsBin.writeULE32(constraintInfo.nTemp3);

        await globalConstraintsBin.writeULE32(constraintInfo.ops.length);
        await globalConstraintsBin.writeULE32(opsOffsetDebug[i]);

        await globalConstraintsBin.writeULE32(constraintInfo.args.length);
        await globalConstraintsBin.writeULE32(argsOffsetDebug[i]);

        writeStringToFile(globalConstraintsBin, constraintInfo.line);
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
    
    await globalConstraintsBin.write(buffOpsDebug);
    await globalConstraintsBin.write(buffArgsDebug);
    await globalConstraintsBin.write(buffNumbersDebug);

    await endWriteSection(globalConstraintsBin);
}

async function writeHintsSection(globalConstraintsBin, hintsInfo, section) {
    console.log(`··· Writing Section ${section}. Hints section`);

    await startWriteSection(globalConstraintsBin, section);

    const nHints = hintsInfo.length;
    await globalConstraintsBin.writeULE32(nHints);

    for(let j = 0; j < nHints; j++) {
        const hint = hintsInfo[j];
        await writeStringToFile(globalConstraintsBin, hint.name);
        const nFields = hint.fields.length;
        await globalConstraintsBin.writeULE32(nFields);
        for(let k = 0; k < nFields; k++) {
            const field = hint.fields[k];
            await writeStringToFile(globalConstraintsBin, field.name);
            const nValues = field.values.length;
            await globalConstraintsBin.writeULE32(nValues);
            for(let v = 0; v < field.values.length; ++v) {
                const value = field.values[v];
                await writeStringToFile(globalConstraintsBin, value.op);
                if(value.op === "number") {
                    const buffNumber = new Uint8Array(8);
                    const buffNumberV = new DataView(buffNumber.buffer);
                    buffNumberV.setBigUint64(0, BigInt(value.value), true);
                    await globalConstraintsBin.write(buffNumber);
                } else if(value.op === "string") {
                    writeStringToFile(globalConstraintsBin, value.string);
                } else if(value.op === "airgroupvalue") {
                    await globalConstraintsBin.writeULE32(value.airgroupId);
                    await globalConstraintsBin.writeULE32(value.id);
                } else if(value.op === "tmp" || value.op === "public" || value.op === "proofvalue") {
                    await globalConstraintsBin.writeULE32(value.id);
                } else {
                    throw new Error("Unknown operand");
                }                
                await globalConstraintsBin.writeULE32(value.pos.length);
                for(let p = 0; p < value.pos.length; ++p) {
                    await globalConstraintsBin.writeULE32(value.pos[p]);
                }
            }
            
        }
    }

    await endWriteSection(globalConstraintsBin);
}