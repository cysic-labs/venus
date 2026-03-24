const util = require('util');
const exec = util.promisify(require('child_process').exec);
const JSONbig = require('json-bigint')({ useNativeBigInt: true, alwaysParseAsBig: true });
const fs = require('fs');
const ffjavascript = require("ffjavascript");

const { getFixedPolsPil2 } = require('../pil2-stark/pil_info/piloutInfo.js');
const { plonk2pil } = require('stark-recurser/src/circom2pil/plonk2pil.js');
const { genCircom } = require('stark-recurser/src/gencircom.js');
const { genSolidity } = require('stark-recurser/src/gensolidity.js');
const pil2circom = require('stark-recurser/src/pil2circom/pil2circom.js');
const path = require("path");
const snarkjs = require("snarkjs");

const {starkSetup} = require("../pil2-stark/stark_setup.js");
const { generateStarkStruct } = require('./utils.js');
const { runFinalSnarkWitnessLibraryGenerationAwait, witnessLibraryGenerationAwait, runWitnessLibraryGeneration } = require('./generateWitness.js');
const { AirOut } = require('../airout.js');
const compilePil2 = require("pil2-compiler/src/compiler.js");
const { generateFixedCols } = require('../pil2-stark/witness_computation/witness_calculator.js');
const { writeFixedPolsBin, readFixedPolsBin } = require('../pil2-stark/witness_computation/fixed_cols.js');


module.exports.genFinalSnarkSetup = async function genFinalSnarkSetup(buildDir, name, setupOptions, constRoot, starkInfo, verifierInfo) {
    let template = "recursivef";
    let verifierName = "vadcop_final.verifier.circom";
    let templateFilename = path.resolve(__dirname,"../../", `node_modules/stark-recurser/src/recursion/templates/recursivef.circom.ejs`);
    let filesDir = `${buildDir}/provingKeySnark/${template}`;
    
    await fs.promises.writeFile(
        `${buildDir}/provingKeySnark/vadcop_final.verkey.json`,
        JSONbig.stringify(constRoot, null, 2),
        "utf8"
    );

    await fs.promises.mkdir(filesDir, { recursive: true });

    const options = { skipMain: true, verkeyInput: true, enableInput: false, hasRecursion: false }
        
    //Generate circom
    const verifierCircomTemplate = await pil2circom(constRoot, starkInfo, verifierInfo, options);
    await fs.promises.writeFile(`${buildDir}/circom/${verifierName}`, verifierCircomTemplate, "utf8");

    const recursiveVerifier = await genCircom(templateFilename, [starkInfo], undefined, [verifierName], [constRoot], [], [], options);
    await fs.promises.writeFile(`${buildDir}/circom/${template}.circom`, recursiveVerifier, "utf8");
 
    const circuitsGLPath = path.resolve(__dirname, '../../', 'node_modules/stark-recurser/src/pil2circom/circuits.gl');
    const starkRecurserCircuits = path.resolve(__dirname, '../../', 'node_modules/stark-recurser/src/recursion/helpers/circuits');
 
    // Compile circom
    console.log("Compiling " + template + "...");
    const circomExecutable = process.platform === 'darwin' ? 'circom/circom_mac' : 'circom/circom';
    const circomExecFile = path.resolve(__dirname, circomExecutable);
    const compileRecursiveCommand = `${circomExecFile} --O1 --r1cs --prime goldilocks --c --verbose -l ${starkRecurserCircuits} -l ${circuitsGLPath} ${buildDir}/circom/${template}.circom -o ${buildDir}/build`;
    await exec(compileRecursiveCommand);
 
    console.log("Copying circom files...");
    fs.copyFile(`${buildDir}/build/${template}_cpp/${template}.dat`, `${filesDir}/${template}.dat`, (err) => { if(err) throw err; });
     
    // Generate witness library
    runWitnessLibraryGeneration(buildDir, filesDir, template, template);
 
    // Generate setup
    const {exec: execBuff, pilStr, nBits, fixedPols, airgroupName, airName } = await plonk2pil(`${buildDir}/build/${template}.r1cs`, "aggregation");
    
    await writeFixedPolsBin(`${buildDir}/build/${template}.fixed.bin`, airgroupName, airName, 1 << nBits, fixedPols);

    const pilFilename = `${buildDir}/pil/${template}.pil`;
    await fs.promises.writeFile(pilFilename, pilStr, "utf8");
    
    let pilFile = `${buildDir}/build/${template}.pilout`;
    let pilConfig = { outputFile: pilFile, includePaths: [setupOptions.stdPath, path.resolve(__dirname, '../../', 'node_modules/stark-recurser/src/circom2pil/pil')] };
    const F = new ffjavascript.F1Field((1n<<64n)-(1n<<32n)+1n );
    compilePil2(F, pilFilename, null, pilConfig);

    const fd =await fs.promises.open(`${filesDir}/${template}.exec`, "w+");
    await fd.write(execBuff);
    await fd.close();

    const starkStructSettings = { blowupFactor: 6, verificationHashType: "BN128", merkleTreeArity: 4, merkleTreeCustom: false, lastLevelVerification: 0, powBits:17 };
    const starkStructRecursiveF = generateStarkStruct(starkStructSettings, nBits);

    const airout = new AirOut(pilFile);
    let air = airout.airGroups[0].airs[0];

    let fixedInfo = {};
    await readFixedPolsBin(fixedInfo, `${buildDir}/build/${template}.fixed.bin`);
    const fixedCols = generateFixedCols(air.symbols.filter(s => s.airGroupId == 0), air.numRows);
    await getFixedPolsPil2(airout.airGroups[0].name, air, fixedCols, fixedInfo);

    await fixedCols.saveToFile(`${filesDir}/${template}.const`);
    
    const setupRecursiveF = await starkSetup(air, starkStructRecursiveF, {...setupOptions, airgroupId: 0, airId: 0});

    await fs.promises.writeFile(`${filesDir}/${template}.starkinfo.json`, JSON.stringify(setupRecursiveF.starkInfo, null, 1), "utf8");

    await fs.promises.writeFile(`${filesDir}/${template}.verifierinfo.json`, JSON.stringify(setupRecursiveF.verifierInfo, null, 1), "utf8");

    await fs.promises.writeFile(`${filesDir}/${template}.expressionsinfo.json`, JSON.stringify(setupRecursiveF.expressionsInfo, null, 1), "utf8");

    console.log("Computing Constant Tree...");
    await exec(`${setupOptions.constTree} -c ${filesDir}/${template}.const -s ${filesDir}/${template}.starkinfo.json -v ${filesDir}/${template}.verkey.json`);
    setupRecursiveF.constRoot = JSONbig.parse(await fs.promises.readFile(`${filesDir}/${template}.verkey.json`, "utf8"));
    
    const { stdout: stdout2 } = await exec(`${setupOptions.binFile} -s ${filesDir}/${template}.starkinfo.json -e ${filesDir}/${template}.expressionsinfo.json -b ${filesDir}/${template}.bin`);
    console.log(stdout2);

    const { stdout: stdout3 } = await exec(`${setupOptions.binFile} -s ${filesDir}/${template}.starkinfo.json -e ${filesDir}/${template}.verifierinfo.json -b ${filesDir}/${template}.verifier.bin --verifier`);
    console.log(stdout3);

    if (setupOptions.onlyRecursiveFinal) {
        console.log("Skipping final snark setup generation...");
        await witnessLibraryGenerationAwait();
        return;
    }
    
    template = "final";
    verifierName = "recursivef.verifier.circom";
    templateFilename = path.resolve(__dirname,"../../", `node_modules/stark-recurser/src/recursion/templates/final.circom.ejs`);
    filesDir = `${buildDir}/provingKeySnark/${template}`;
    
    await fs.promises.mkdir(filesDir, { recursive: true });

    const optionsFinal = { skipMain: true, verkeyInput: false, enableInput: false, addAggregatorAddr: false }
        
    //Generate circom
    const verifierFinalCircomTemplate = await pil2circom(setupRecursiveF.constRoot, setupRecursiveF.starkInfo, setupRecursiveF.verifierInfo, optionsFinal);
    await fs.promises.writeFile(`${buildDir}/circom/${verifierName}`, verifierFinalCircomTemplate, "utf8");

    const publicsHashFinal = setupOptions.publicsInfo ? setupOptions.publicsInfo : undefined;
    const recursiveFinalVerifier = await genCircom(templateFilename, [setupRecursiveF.starkInfo], undefined, [verifierName], [], [], [publicsHashFinal], optionsFinal);
    await fs.promises.writeFile(`${buildDir}/circom/${template}.circom`, recursiveFinalVerifier, "utf8");
  
    const circuitsBN128Path = path.resolve(__dirname, '../../', 'node_modules/stark-recurser/src/pil2circom/circuits.bn128');

    const circuitsCircomLib = path.resolve(__dirname, '../../', 'node_modules/circomlib/circuits');

    // Compile circom
    console.log("Compiling " + template + "...");
    const circomExecutableFinal = process.platform === 'darwin' ? 'circom/circom_mac' : 'circom/circom';
    const circomExecFinalFile = path.resolve(__dirname, circomExecutableFinal);
    const compileFinalRecursiveCommand = `${circomExecFinalFile} --O1 --r1cs --inspect --wasm --c --verbose -l ${starkRecurserCircuits} -l ${circuitsBN128Path} -l ${circuitsCircomLib} ${buildDir}/circom/${template}.circom -o ${buildDir}/build`;
    console.log(compileFinalRecursiveCommand);
    const stdoutCircom = await exec(compileFinalRecursiveCommand);
    console.log(stdoutCircom.stdout);

    console.log("Copying circom files...");
    fs.copyFile(`${buildDir}/build/${template}_cpp/${template}.dat`, `${filesDir}/${template}.dat`, (err) => { if(err) throw err; });

    await runFinalSnarkWitnessLibraryGenerationAwait(buildDir, filesDir, template, template);
    console.log(`Computing ${setupOptions.finalSnark} setup...`);
    const snarkExec = setupOptions.finalSnark == "fflonk" ? setupOptions.fflonkSetup : setupOptions.plonkSetup;
    const {stdout} = await exec(`${snarkExec} ${buildDir}/build/${template}.r1cs ${setupOptions.powersOfTauFile} ${filesDir}/${template}.zkey`);
    console.log(stdout);

    console.log(`Writing ${setupOptions.finalSnark} verification key...`);
    const verkey = await snarkjs.zKey.exportVerificationKey(`${filesDir}/${template}.zkey`);
    await fs.promises.writeFile(`${filesDir}/${template}.verkey.json`, JSON.stringify(verkey), "utf8");

    console.log(`Writing solidity ${setupOptions.finalSnark} verifier...`);
    const templateSolidity = setupOptions.finalSnark == "fflonk" 
        ? {fflonk: fs.readFileSync(path.join(__dirname, `../../node_modules/snarkjs/templates/verifier_${setupOptions.finalSnark}.sol.ejs`), "utf8") }
        : {plonk: fs.readFileSync(path.join(__dirname, `../../node_modules/snarkjs/templates/verifier_${setupOptions.finalSnark}.sol.ejs`), "utf8") };
    const snarkVerifier = await snarkjs.zKey.exportSolidityVerifier(`${filesDir}/${template}.zkey`, templateSolidity);
    const snarkVerifierSolidity = setupOptions.finalSnark == "fflonk" ? "FflonkVerifier" : "PlonkVerifier";
    await fs.promises.writeFile(`${filesDir}/${snarkVerifierSolidity}.sol`, snarkVerifier, "utf8");
    
    const camelCaseName = name.charAt(0).toUpperCase() + name.slice(1);
    const {solidityVerifier, solidityVerifierInterface} = await genSolidity(name, constRoot, publicsHashFinal, setupOptions.finalSnark == "fflonk");
    await fs.promises.writeFile(`${filesDir}/${camelCaseName}Verifier.sol`, solidityVerifier, "utf8");
    await fs.promises.writeFile(`${filesDir}/I${camelCaseName}Verifier.sol`, solidityVerifierInterface, "utf8");
    await witnessLibraryGenerationAwait();

    await fs.promises.writeFile(`${buildDir}/provingKeySnark/publics_info.json`, JSON.stringify(setupOptions.publicsInfo, null, 1), "utf8");

    console.log("All files were generated correctly");

    return;
}