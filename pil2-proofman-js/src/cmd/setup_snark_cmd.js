const fs = require('fs');
const path = require("path");
const JSONbig = require('json-bigint')({ useNativeBigInt: true, alwaysParseAsBig: true });
const log = require("../../logger.js");
const { genFinalSnarkSetup } = require('../setup/generateFinalSnarkSetup.js');

module.exports = async function setupSnarkCmd(proofManagerConfig, buildDir = "tmp") {
    const provingKeyPath = `${buildDir}/provingKey/`;
    
    const setupOptions = {
        publicsInfo: proofManagerConfig.publicsInfo,
        powersOfTauFile: proofManagerConfig.powersOfTauFile,
        fflonkSetup: path.resolve(__dirname, '../setup/build/fflonkSetup'),
        plonkSetup: path.resolve(__dirname, '../setup/build/plonkSetup'),
        finalSnark: proofManagerConfig.finalSnark || "fflonk",
    };

    // Read global info to get the name
    const globalInfoPath = path.join(provingKeyPath, "pilout.globalInfo.json");
    if (!fs.existsSync(globalInfoPath)) {
        throw new Error(`Global info file not found: ${globalInfoPath}`);
    }
    const globalInfo = JSON.parse(await fs.promises.readFile(globalInfoPath, "utf8"));

    // The Solidity verifier embeds the vadcop_final verification key
    const constRootPath = path.join(provingKeyPath, globalInfo.name, "vadcop_final", "vadcop_final.verkey.json");
    if (!fs.existsSync(constRootPath)) {
        throw new Error(`Const root file not found: ${constRootPath}. Make sure you have run the regular setup first.`);
    }
    const constRootFinal = JSONbig.parse(await fs.promises.readFile(constRootPath, "utf8"));

    log.info("[Setup Snark Cmd]", `Generating final snark setup for '${globalInfo.name}'`);

    await genFinalSnarkSetup(buildDir, globalInfo.name, setupOptions, constRootFinal);

    log.info("[Setup Snark Cmd]", "Final snark setup completed successfully");

    return { globalInfo };
}
