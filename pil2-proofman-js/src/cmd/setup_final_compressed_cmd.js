const fs = require('fs');
const path = require("path");
const JSONbig = require('json-bigint')({ useNativeBigInt: true, alwaysParseAsBig: true });
const log = require("../../logger.js");
const { genCompressedFinalSetup } = require('../setup/generateCompressedFinalSetup.js');

module.exports = async function setupFinalCompressedCmd(proofManagerConfig, buildDir = "tmp") {
    const provingKeyPath = `${buildDir}/provingKey/`;
    
    const setupOptions = {
        constTree: process.platform === 'darwin' 
            ? path.resolve(__dirname, '../setup/build/bctree_mac')
            : path.resolve(__dirname, '../setup/build/bctree'),
        binFile: process.platform === 'darwin' 
            ? path.resolve(__dirname, '../setup/build/binfile_mac')
            : path.resolve(__dirname, '../setup/build/binfile'),
        stdPath: proofManagerConfig.stdPath,
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

    log.info("[Setup Final Compressed Cmd]", `Reading vadcop_final setup files from ${vadcopFinalDir}`);
    
    const constRootFinalSnark = JSONbig.parse(await fs.promises.readFile(constRootPath, "utf8"));
    const starkInfoFinalSnark = JSON.parse(await fs.promises.readFile(starkInfoPath, "utf8"));
    const verifierInfoFinalSnark = JSON.parse(await fs.promises.readFile(verifierInfoPath, "utf8"));

    log.info("[Setup Final Compressed Cmd]", `Generating final compressed setup for '${globalInfo.name}'`);

    await genCompressedFinalSetup(
        buildDir, globalInfo.name, setupOptions, constRootFinalSnark, [],
        starkInfoFinalSnark, verifierInfoFinalSnark
    );

    log.info("[Setup Final Compressed Cmd]", "Final compressed setup completed successfully");

}
