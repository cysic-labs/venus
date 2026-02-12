const fs = require('fs');
const crypto = require('crypto');
const util = require('util');
const childProcess = require('child_process'); // Split into two lines for clarity
const path = require("path");
const exec = util.promisify(childProcess.exec);
const JSONbig = require('json-bigint')({ useNativeBigInt: true, alwaysParseAsBig: true });
const log = require("../../logger.js");
const { AirOut } = require("../airout.js");

const { writeGlobalConstraintsBinFile } = require("../pil2-stark/chelpers/globalConstraintsBinFile.js");
const { starkSetup } = require('../pil2-stark/stark_setup.js');
const { generateFixedCols } = require('../pil2-stark/witness_computation/witness_calculator.js');
const { writeVerifierRustFile } = require("../pil2-stark/chelpers/binFile.js");

const { genFinalSetup } = require("../setup/generateFinalSetup.js");
const { genRecursiveSetup } = require("../setup/generateRecursiveSetup.js");
const { isCompressorNeeded } = require('../setup/is_compressor_needed.js');
const { generateStarkStruct, setAiroutInfo, log2 } = require("../setup/utils.js");
const { genFinalSnarkSetup } = require('../setup/generateFinalSnarkSetup.js');
const { readFixedPolsBin } = require('../pil2-stark/witness_computation/fixed_cols.js');
const { getFixedPolsPil2 } = require('../pil2-stark/pil_info/piloutInfo.js');


// NOTE: by the moment this is a STARK setup process, it should be a generic setup process?
module.exports = async function setupCmd(proofManagerConfig, buildDir = "tmp") {
    const airout = new AirOut(proofManagerConfig.airout.airoutFilename);

    const setupOptions = {
        optImPols: (proofManagerConfig.setup && proofManagerConfig.setup.optImPols) || false,
        constTree: process.platform === 'darwin' 
            ? path.resolve(__dirname, '../setup/build/bctree_mac')
            : path.resolve(__dirname, '../setup/build/bctree'),
        binFile: process.platform === 'darwin' 
            ? path.resolve(__dirname, '../setup/build/binfile_mac')
            : path.resolve(__dirname, '../setup/build/binfile'),
        publicsInfo: proofManagerConfig.setup && proofManagerConfig.setup.publicsInfo,
        powersOfTauFile: proofManagerConfig.setup && proofManagerConfig.setup.powersOfTauFile,
        fflonkSetup: path.resolve(__dirname, '../setup/build/fflonkSetup'),
        binFiles: proofManagerConfig.setup && proofManagerConfig.setup.binFiles,
        stdPath: proofManagerConfig.setup && proofManagerConfig.setup.stdPath,
        fixedPath: proofManagerConfig.setup && proofManagerConfig.setup.fixedPath,
    };
    
    let setup = [];

    let starkStructs = [];

    let fixedInfo = {};
    if (!setupOptions.fixedPath) {
        for(let i = 0; i < setupOptions.binFiles.length; ++i) {
            await readFixedPolsBin(fixedInfo, setupOptions.binFiles[i]);
        }
    }

    await Promise.all(airout.airGroups.map(async (airgroup) => {
        setup[airgroup.airgroupId] = [];

        await Promise.all(airgroup.airs.map(async (air) => {
            log.info("[Setup Cmd]", `··· Computing setup for air '${air.name}'`);

            let settings = {};
            if (proofManagerConfig.setup && proofManagerConfig.setup.settings) {
                settings = proofManagerConfig.setup.settings[`${air.name}`]
                    || proofManagerConfig.setup.settings.default
                    || { };
            }

            if (!settings) {
                log.error(`[${this.name}]`, `No settings for air '${air.name}'${air.numRows ? ` with N=${air.numRows}` : ''}`);
                throw new Error(`[${this.name}] No settings for air '${air.name}'${air.numRows ? ` with N=${air.numRows}` : ''}`);
            }

            if (!settings.powBits) {
                settings.powBits = 16;
            }

            const filesDir = path.join(buildDir, "provingKey", airout.name, airgroup.name, "airs", `${air.name}`, "air");
            await fs.promises.mkdir(filesDir, { recursive: true });

            let starkStruct = settings.starkStruct || generateStarkStruct(settings, log2(air.numRows));
            starkStructs.push(starkStruct);

            if (!setupOptions.fixedPath) {
                const fixedPols = generateFixedCols(air.symbols.filter(s => s.airGroupId == airgroup.airgroupId), air.numRows);
                await getFixedPolsPil2(airgroup.name, air, fixedPols, fixedInfo);
                await fixedPols.saveToFile(path.join(filesDir, `${air.name}.const`));
            } else {
                await exec(`cp ${setupOptions.fixedPath}/${air.name}.fixed ${path.join(filesDir, `${air.name}.const`)}`);
            }

            setup[airgroup.airgroupId][air.airId] = await starkSetup(air, starkStruct, setupOptions);
            await fs.promises.writeFile(path.join(filesDir, `${air.name}.starkinfo.json`), JSON.stringify(setup[airgroup.airgroupId][air.airId].starkInfo, null, 1), "utf8");
            await fs.promises.writeFile(path.join(filesDir, `${air.name}.verifierinfo.json`), JSON.stringify(setup[airgroup.airgroupId][air.airId].verifierInfo, null, 1), "utf8");
            await fs.promises.writeFile(path.join(filesDir, `${air.name}.expressionsinfo.json`), JSON.stringify(setup[airgroup.airgroupId][air.airId].expressionsInfo, null, 1), "utf8");

            console.log("Computing Constant Tree...");
            const { stdout } = await exec(`${setupOptions.constTree} -c ${path.join(filesDir, `${air.name}.const`)} -s ${path.join(filesDir, `${air.name}.starkinfo.json`)} -v ${path.join(filesDir, `${air.name}.verkey.json`)}`);
            console.log(stdout);
            setup[airgroup.airgroupId][air.airId].constRoot = JSONbig.parse(await fs.promises.readFile(path.join(filesDir, `${air.name}.verkey.json`), "utf8"));
            const constRootBuffer = Buffer.alloc(32);
            for (let i = 0; i < 4; i++) {
                constRootBuffer.writeBigUInt64LE(setup[airgroup.airgroupId][air.airId].constRoot[i], i * 8);
            }
            await fs.promises.writeFile(`${filesDir}/${air.name}.verkey.bin`, constRootBuffer);

            const { stdout: stdout2 } = await exec(`${setupOptions.binFile} -s ${path.join(filesDir, `${air.name}.starkinfo.json`)} -e ${path.join(filesDir, `${air.name}.expressionsinfo.json`)} -b ${path.join(filesDir, `${air.name}.bin`)}`);
            console.log(stdout2);

            const { stdout: stdout3 } = await exec(`${setupOptions.binFile} -s ${path.join(filesDir, `${air.name}.starkinfo.json`)} -e ${path.join(filesDir, `${air.name}.verifierinfo.json`)} -b ${path.join(filesDir, `${air.name}.verifier.bin`)} --verifier`);
            console.log(stdout3);

            writeVerifierRustFile(`${filesDir}/${air.name}.verifier.rs`, setup[airgroup.airgroupId][air.airId].starkInfo, setup[airgroup.airgroupId][air.airId].verifierInfo, setup[airgroup.airgroupId][air.airId].constRoot);
        }));
    }));

    setupOptions.optImPols = false;
    
    let globalInfo;
    let globalConstraints;
    
    if(proofManagerConfig.setup && proofManagerConfig.setup.genAggregationSetup) {
        const airoutInfo = await setAiroutInfo(airout);
        globalConstraints = airoutInfo.globalConstraints;
        globalInfo = airoutInfo.vadcopInfo;
                
        let recursiveSettings =  { blowupFactor: 3, lastLevelVerification: 1 };
        if(proofManagerConfig.setup && proofManagerConfig.setup.settings && proofManagerConfig.setup.settings.recursive) {
        recursiveSettings = proofManagerConfig.setup.settings.recursive;
        }

        let recursiveBits = 17;
        let starkStructRecursive = recursiveSettings.starkStruct || generateStarkStruct(recursiveSettings, recursiveBits);

        const constRootsRecursives1 = [];

        const setupsAggregation = [];
        for(const airgroup of airout.airGroups) {
            setupsAggregation[airgroup.airgroupId] = null;
            constRootsRecursives1[airgroup.airgroupId] = [];
    
            for(const air of airgroup.airs) {
                log.info("[Setup Cmd]", `······ Checking if air '${air.name}' needs a compressor`);
                        
                const filesDir = path.join(buildDir, "provingKey", airout.name, airgroup.name, "airs", `${air.name}`, "air");

                
                let compressorNeeded = false;
                if (proofManagerConfig.setup && proofManagerConfig.setup.settings && proofManagerConfig.setup.settings[`${air.name}`] && proofManagerConfig.setup.settings[`${air.name}`].hasCompressor) {
                    compressorNeeded = true;
                } else {
                    compressorNeeded = await isCompressorNeeded(
                        setup[airgroup.airgroupId][air.airId].constRoot,
                        setup[airgroup.airgroupId][air.airId].starkInfo,
                        setup[airgroup.airgroupId][air.airId].verifierInfo,
                        path.join(filesDir, `${air.name}.starkinfo.json`),
                    );
                }
            
                let constRoot, starkInfo, verifierInfo;
                const starkStructRecursive1 = { ...starkStructRecursive };
            
                if (compressorNeeded) {
                    setup[airgroup.airgroupId][air.airId].hasCompressor = true;
                    globalInfo.airs[airgroup.airgroupId][air.airId].hasCompressor = true;
                                
                    const recursiveSetup = await genRecursiveSetup(
                        buildDir, setupOptions, "compressor", airgroup.name, airgroup.airgroupId, air.airId, globalInfo,
                        setup[airgroup.airgroupId][air.airId].constRoot, [], setup[airgroup.airgroupId][air.airId].starkInfo,
                        setup[airgroup.airgroupId][air.airId].verifierInfo, null
                    );
                    
                    constRoot = recursiveSetup.constRoot;
                    starkInfo = recursiveSetup.setupAggregation.starkInfo;
                    verifierInfo = recursiveSetup.setupAggregation.verifierInfo;
                } else {
                    constRoot = setup[airgroup.airgroupId][air.airId].constRoot;
                    starkInfo = setup[airgroup.airgroupId][air.airId].starkInfo;
                    verifierInfo = setup[airgroup.airgroupId][air.airId].verifierInfo;
                    starkStructRecursive1.hashCommits = true;
                }
            
                const setupRecursive1 = await genRecursiveSetup(
                    buildDir, setupOptions, "recursive1", airgroup.name, airgroup.airgroupId, air.airId, globalInfo,
                    constRoot, [], starkInfo, verifierInfo, starkStructRecursive,
                    setup[airgroup.airgroupId][air.airId].hasCompressor, setupsAggregation[airgroup.airgroupId]
                );

                setupsAggregation[airgroup.airgroupId] = setupRecursive1.setupAggregation;
                constRootsRecursives1[airgroup.airgroupId][air.airId] = setupRecursive1.constRoot;

            };
        };

        for(const airgroup of airout.airGroups) {
            await genRecursiveSetup(
                buildDir, setupOptions, "recursive2", airgroup.name, airgroup.airgroupId,
                undefined, globalInfo, [], constRootsRecursives1[airgroup.airgroupId],
                setupsAggregation[airgroup.airgroupId].starkInfo, setupsAggregation[airgroup.airgroupId].verifierInfo,
                starkStructRecursive, false, setupsAggregation[airgroup.airgroupId]
            );
        };
  
        let finalSettings; 
        if(!proofManagerConfig.setup.genFinalSnarkSetup) {
            finalSettings = {
                blowupFactor: 5, 
                foldingFactor: 4, 
                powBits: 22, 
                merkleTreeArity: 2,
                lastLevelVerification: 6,
                finalDegree: 9
            }
        } else {
            finalSettings = {
                blowupFactor: 6, 
                foldingFactor: 4, 
                powBits: 22,
                lastLevelVerification: 1
            }
        }
        if(proofManagerConfig.setup && proofManagerConfig.setup.settings && proofManagerConfig.setup.settings.final) {
            finalSettings = proofManagerConfig.setup.settings.final;
        }

        const {starkInfoFinal,
            constRootFinal,
            verifierInfoFinal,
        } = await genFinalSetup(buildDir, setupOptions, finalSettings, globalInfo, globalConstraints, 62);
        
        if(proofManagerConfig.setup.genFinalSnarkSetup) {
            await genFinalSnarkSetup(
                buildDir, setupOptions, globalInfo, constRootFinal, [],
                starkInfoFinal, verifierInfoFinal,
                12,
            );
        }
        
    } else {
        const airoutInfo = await setAiroutInfo(airout);
        globalInfo = airoutInfo.vadcopInfo;
        globalConstraints = airoutInfo.globalConstraints;
    }

    await fs.promises.writeFile(`${buildDir}/provingKey/pilout.globalInfo.json`, JSON.stringify(globalInfo, null, 1), "utf8");
    await fs.promises.writeFile(`${buildDir}/provingKey/pilout.globalConstraints.json`, JSON.stringify(globalConstraints, null, 1), "utf8");
    await writeGlobalConstraintsBinFile(globalInfo, globalConstraints, `${buildDir}/provingKey/pilout.globalConstraints.bin`);

    return { setup, airoutInfo: {...globalInfo, globalConstraints}, config: proofManagerConfig };
}