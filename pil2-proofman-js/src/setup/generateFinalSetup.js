const util = require('util');
const exec = util.promisify(require('child_process').exec);
const JSONbig = require('json-bigint')({ useNativeBigInt: true, alwaysParseAsBig: true });
const fs = require('fs');
const ffjavascript = require("ffjavascript");

const { plonk2pil } = require('stark-recurser/src/circom2pil/plonk2pil.js');
const { genCircom } = require('stark-recurser/src/gencircom.js');
const { generateStarkStruct } = require("./utils");
const path = require("path");
const { runWitnessLibraryGeneration, witnessLibraryGenerationAwait } = require("./generateWitness");
const { writeVerifierRustFile } = require("../pil2-stark/chelpers/binFile.js");

const {starkSetup} = require("../pil2-stark/stark_setup");
const { AirOut } = require('../airout.js');
const compilePil2 = require("pil2-compiler/src/compiler.js");
const { generateFixedCols } = require('../pil2-stark/witness_computation/witness_calculator.js');
const { getFixedPolsPil2 } = require('../pil2-stark/pil_info/piloutInfo.js');
const { writeFixedPolsBin, readFixedPolsBin } = require('../pil2-stark/witness_computation/fixed_cols.js');

module.exports.genFinalSetup = async function genFinalSetup(buildDir, setupOptions, finalSettings, globalInfo, globalConstraints, compressorCols) {
    const starkInfos = [];
    const verifierInfos = [];
    const aggregatedKeysRecursive2 = [];
    const basicKeysRecursive1 = [];
    const verifierNames = [];

    const nameFilename = "vadcop_final";
    const finalFilename = `${buildDir}/circom/${nameFilename}.circom`;

    for(let i = 0; i < globalInfo.aggTypes.length; i++) {
        const starkInfo = JSON.parse(await fs.promises.readFile(`${buildDir}/provingKey/${globalInfo.name}/${globalInfo.air_groups[i]}/recursive2/recursive2.starkinfo.json`, "utf8"));
        const verifierInfo = JSON.parse(await fs.promises.readFile(`${buildDir}/provingKey/${globalInfo.name}/${globalInfo.air_groups[i]}/recursive2/recursive2.verifierinfo.json`, "utf8"));
        const verificationKeys = JSONbig.parse(await fs.promises.readFile(`${buildDir}/provingKey/${globalInfo.name}/${globalInfo.air_groups[i]}/recursive2/recursive2.vks.json`, "utf8"));

        starkInfos.push(starkInfo);
        verifierInfos.push(verifierInfo);
        aggregatedKeysRecursive2.push(verificationKeys.rootCRecursive2);
        basicKeysRecursive1.push(verificationKeys.rootCRecursives1);
        verifierNames.push( `${globalInfo.air_groups[i]}_recursive2.verifier.circom`);
    }
        
    const filesDir = `${buildDir}/provingKey/${globalInfo.name}/${nameFilename}`;
    await fs.promises.mkdir(filesDir, { recursive: true });

    let templateFilename = path.resolve(__dirname, "../..", `node_modules/stark-recurser/src/vadcop/templates/final.circom.ejs`);

    // Generate final circom
    const finalVerifier = await genCircom(templateFilename, starkInfos, {...globalInfo, globalConstraints: globalConstraints.constraints }, verifierNames, basicKeysRecursive1, aggregatedKeysRecursive2);
    await fs.promises.writeFile(finalFilename, finalVerifier, "utf8");


    const circuitsGLPath = path.resolve(__dirname, '../../', 'node_modules/stark-recurser/src/pil2circom/circuits.gl');
    const starkRecurserCircuits = path.resolve(__dirname, '../../', 'node_modules/stark-recurser/src/vadcop/helpers/circuits');

    // Compile circom
    console.log("Compiling " + finalFilename + "...");
    const circomExecutable = process.platform === 'darwin' ? 'circom/circom_mac' : 'circom/circom';
    const circomExecFile = path.resolve(__dirname, circomExecutable);
    const compileFinalCommand = `${circomExecFile} --O1 --r1cs --prime goldilocks --c --verbose -l ${starkRecurserCircuits} -l ${circuitsGLPath} ${finalFilename} -o ${buildDir}/build`;
    const execCompile = await exec(compileFinalCommand);
    console.log(execCompile.stdout);
    
    console.log("Copying circom files...");
    fs.copyFile(`${buildDir}/build/${nameFilename}_cpp/${nameFilename}.dat`, `${buildDir}/provingKey/${globalInfo.name}/${nameFilename}/${nameFilename}.dat`, (err) => { if(err) throw err; });
    
    runWitnessLibraryGeneration(buildDir, filesDir, nameFilename, nameFilename);

    // Generate setup
    const finalR1csFile = `${buildDir}/build/${nameFilename}.r1cs`;
    const {exec: execBuff, pilStr, nBits, fixedPols, airgroupName, airName } = await plonk2pil(finalR1csFile, "final_vadcop", compressorCols);

    await writeFixedPolsBin(`${buildDir}/build/${nameFilename}.fixed.bin`, airgroupName, airName, 1 << nBits, fixedPols);

    const pilFilename = `${buildDir}/pil/${nameFilename}.pil`;
    await fs.promises.writeFile(pilFilename, pilStr, "utf8");

    let pilFile = `${buildDir}/build/${nameFilename}.pilout`;
    let pilConfig = { outputFile: pilFile, includePaths: [setupOptions.stdPath, path.resolve(__dirname, '../../', 'node_modules/stark-recurser/src/circom2pil/pil')] };
    const F = new ffjavascript.F1Field((1n<<64n)-(1n<<32n)+1n );
    compilePil2(F, pilFilename, null, pilConfig);

    const fd =await fs.promises.open(`${filesDir}/${nameFilename}.exec`, "w+");
    await fd.write(execBuff);
    await fd.close();


    if(finalSettings.starkStruct && finalSettings.starkStruct.nBits !== nBits) {
        throw new Error("Final starkStruct nBits does not match with vadcop final circuit size");
    };

    let starkStructFinal = finalSettings.starkStruct || generateStarkStruct(finalSettings, nBits);
    
    // Build stark info
    const airout = new AirOut(pilFile);
    let air = airout.airGroups[0].airs[0];

    let fixedInfo = {};
    await readFixedPolsBin(fixedInfo, `${buildDir}/build/${nameFilename}.fixed.bin`);
    const fixedCols = generateFixedCols(air.symbols.filter(s => s.airGroupId == 0), air.numRows);
    await getFixedPolsPil2(airout.airGroups[0].name, air, fixedCols, fixedInfo);

    await fixedCols.saveToFile(`${filesDir}/${nameFilename}.const`);

    const setup = await starkSetup(air, starkStructFinal, {...setupOptions, airgroupId: 0, airId: 0});

    await fs.promises.writeFile(`${filesDir}/${nameFilename}.starkinfo.json`, JSON.stringify(setup.starkInfo, null, 1), "utf8");

    await fs.promises.writeFile(`${filesDir}/${nameFilename}.expressionsinfo.json`, JSON.stringify(setup.expressionsInfo, null, 1), "utf8");

    await fs.promises.writeFile(`${filesDir}/${nameFilename}.verifierinfo.json`, JSON.stringify(setup.verifierInfo, null, 1), "utf8");
    
    console.log("Computing Constant Tree...");
    const {stdout} = await exec(`${setupOptions.constTree} -c ${filesDir}/${nameFilename}.const -s ${filesDir}/${nameFilename}.starkinfo.json -v ${filesDir}/${nameFilename}.verkey.json`);
    setup.constRoot = JSONbig.parse(await fs.promises.readFile(`${filesDir}/${nameFilename}.verkey.json`, "utf8"));

    const constRootBuffer = Buffer.alloc(32);
    for (let i = 0; i < 4; i++) {
        constRootBuffer.writeBigUInt64LE(setup.constRoot[i], i * 8);
    }
    await fs.promises.writeFile(`${filesDir}/${nameFilename}.verkey.bin`, constRootBuffer);

    const { stdout: stdout2 } = await exec(`${setupOptions.binFile} -s ${filesDir}/${nameFilename}.starkinfo.json -e ${filesDir}/${nameFilename}.expressionsinfo.json -b ${filesDir}/${nameFilename}.bin`);
    console.log(stdout2);

    const { stdout: stdout3 } = await exec(`${setupOptions.binFile} -s ${filesDir}/${nameFilename}.starkinfo.json -e ${filesDir}/${nameFilename}.verifierinfo.json -b ${filesDir}/${nameFilename}.verifier.bin --verifier`);
    console.log(stdout3);

    writeVerifierRustFile(`${filesDir}/${nameFilename}.verifier.rs`, setup.starkInfo, setup.verifierInfo, setup.constRoot);

    if(!setupOptions.powersOfTauFile) {
        await witnessLibraryGenerationAwait();
    }

    return {starkInfoFinal: setup.starkInfo, verifierInfoFinal: setup.verifierInfo, constRootFinal: setup.constRoot, nBitsFinal: nBits};
}