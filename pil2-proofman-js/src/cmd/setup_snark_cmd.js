const fs = require('fs');
const path = require("path");
const JSONbig = require('json-bigint')({ useNativeBigInt: true, alwaysParseAsBig: true });
const log = require("../../logger.js");
const { genFinalSnarkSetup } = require('../setup/generateFinalSnarkSetup.js');

module.exports = async function setupSnarkCmd(proofManagerConfig, buildDir = "tmp") {
    const provingKeyPath = `${buildDir}/provingKey/`;
    
    const setupOptions = {
        constTree: process.platform === 'darwin' 
            ? path.resolve(__dirname, '../setup/build/bctree_mac')
            : path.resolve(__dirname, '../setup/build/bctree'),
        binFile: process.platform === 'darwin' 
            ? path.resolve(__dirname, '../setup/build/binfile_mac')
            : path.resolve(__dirname, '../setup/build/binfile'),
        publicsInfo: proofManagerConfig.publicsInfo,
        powersOfTauFile: proofManagerConfig.powersOfTauFile,
        fflonkSetup: path.resolve(__dirname, '../setup/build/fflonkSetup'),
        plonkSetup: path.resolve(__dirname, '../setup/build/plonkSetup'),
        stdPath: proofManagerConfig.stdPath,
        finalSnark: proofManagerConfig.finalSnark || "fflonk",
        onlyRecursiveFinal: proofManagerConfig.onlyRecursiveFinal || false
    };

    // Read global info to get the name
    const globalInfoPath = path.join(provingKeyPath, "pilout.globalInfo.json");
    if (!fs.existsSync(globalInfoPath)) {
        throw new Error(`Global info file not found: ${globalInfoPath}`);
    }
    const globalInfo = JSON.parse(await fs.promises.readFile(globalInfoPath, "utf8"));

    // Read the vadcop_final setup files
    const vadcopFinalDir = path.join(provingKeyPath, globalInfo.name, "vadcop_final");
    
    const constRootPath = path.join(vadcopFinalDir, "vadcop_final.verkey.json");
    const starkInfoPath = path.join(vadcopFinalDir, "vadcop_final.starkinfo.json");
    const verifierInfoPath = path.join(vadcopFinalDir, "vadcop_final.verifierinfo.json");

    if (!fs.existsSync(constRootPath)) {
        throw new Error(`Const root file not found: ${constRootPath}. Make sure you have run the regular setup first.`);
    }
    if (!fs.existsSync(starkInfoPath)) {
        throw new Error(`Stark info file not found: ${starkInfoPath}. Make sure you have run the regular setup first.`);
    }
    if (!fs.existsSync(verifierInfoPath)) {
        throw new Error(`Verifier info file not found: ${verifierInfoPath}. Make sure you have run the regular setup first.`);
    }

    log.info("[Setup Snark Cmd]", `Reading vadcop_final setup files from ${vadcopFinalDir}`);
    
    const constRootFinal = JSONbig.parse(await fs.promises.readFile(constRootPath, "utf8"));
    const starkInfoFinal = JSON.parse(await fs.promises.readFile(starkInfoPath, "utf8"));
    const verifierInfoFinal = JSON.parse(await fs.promises.readFile(verifierInfoPath, "utf8"));

    log.info("[Setup Snark Cmd]", `Generating final snark setup for '${globalInfo.name}'`);

    await fs.promises.mkdir(`${buildDir}/provingKeySnark`, { recursive: true });

    await genFinalSnarkSetup(
        buildDir, globalInfo.name, setupOptions, constRootFinal,
        starkInfoFinal, verifierInfoFinal
    );

    log.info("[Setup Snark Cmd]", "Final snark setup completed successfully");

    return { globalInfo };
}
