const { readR1cs } = require("r1csfile");
const fs = require("fs");
const path = require('path');
const pil2circom = require("stark-recurser/src/pil2circom/pil2circom.js");
const { getCompressorConstraints } = require("stark-recurser/src/circom2pil/aggregation/aggregation_setup.js");

const util = require('util');
const { exec } = require('child_process');
const { log2 } = require("./utils");
const execPromise = util.promisify(exec);
const tmp = require('os').tmpdir();


module.exports.isCompressorNeeded = async function isCompressorNeeded(constRoot, starkInfo, verifierInfo, starkInfoFile) {

    const tempDir = await fs.promises.mkdtemp(path.join(tmp, 'compressor-'));

    let verifierCircomTemplate = await pil2circom(
        constRoot,
        starkInfo,
        verifierInfo,
        { skipMain: true }
    );

    verifierCircomTemplate +=
        `\n\ncomponent main = StarkVerifier${starkInfo.airgroupId}();\n\n`;
    
    const tmpCircomFilename = path.join(tempDir, "verifier.circom");
    const tmpR1csFilename = path.join(tempDir, "verifier.r1cs");

    await fs.promises.writeFile(
        tmpCircomFilename,
        verifierCircomTemplate,
        "utf8"
    );
    
    const circuitsGLPath = path.resolve(__dirname, '../../', 'node_modules/stark-recurser/src/pil2circom/circuits.gl');
    const circomExecutable = process.platform === 'darwin' ? 'circom/circom_mac' : 'circom/circom';
    const circomExecFile = path.resolve(__dirname, circomExecutable);
    const compileRecursiveCommand = `${circomExecFile} --O1 --r1cs --prime goldilocks -l ${circuitsGLPath} ${tmpCircomFilename} -o ${tempDir}`;
    console.log(compileRecursiveCommand);
    await execPromise(compileRecursiveCommand, { cwd: tempDir });
    
    const r1cs = await readR1cs(tmpR1csFilename);

    const {NUsed} = getCompressorConstraints(r1cs, 59);
    
    console.log("Number of rows used", NUsed);

    let nBits = log2(NUsed - 1) + 1;

    await fs.promises.rm(tempDir, { recursive: true, force: true });
    
    let recursiveBits = 17;

    if(nBits > recursiveBits) {
        return true;
    } else if(nBits === recursiveBits) {
        return false;
    } else {
        const nRowsPerFri = NUsed / starkInfo.starkStruct.nQueries;
        const minimumQueriesRequired = Math.ceil((2**(recursiveBits - 1) + 2**12) / nRowsPerFri);
        
        starkInfo.starkStruct.nQueries = minimumQueriesRequired;
        await fs.promises.writeFile(starkInfoFile, JSON.stringify(starkInfo, null, 1), "utf8");

        return false;
    }
    
}