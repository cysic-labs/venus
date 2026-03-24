const fs = require("fs");
const version = require("../package").version;

const setupCmd = require("./cmd/setup_cmd");

const setupFinalCompressedCmd = require("./cmd/setup_final_compressed_cmd");

const argv = require("yargs")
    .version(version)
    .usage("node main_gensetup.js -a <airout.ptb> -s <starkstructs.json> -b <buildDir> ")
    .alias("a", "airout")
    .alias("b", "builddir")
    .alias("i", "binfiles").array("i")
    .alias("s", "starkstructs")
    .alias("t", "stdPath")
    .alias("r", "recursive")
    .alias("m", "impols")
    .alias("u", "fixed")
        .argv;

async function run() {

    const buildDir = argv.builddir || "tmp";
    await fs.promises.mkdir(buildDir, { recursive: true });

    if(argv.recursive) {
        if (!argv.stdPath) {
            throw new Error("Std path and name must be provided");
        }
    }

    let piloutPath = argv.airout;

    let starkStructsInfo = argv.starkstructs ? JSON.parse(await fs.promises.readFile(argv.starkstructs, "utf8")) : {};
    
    const binFiles = argv.binfiles || [];

    const config = {
        airout: {
            airoutFilename: piloutPath,
        },
        setup: {
            settings: starkStructsInfo,
            genAggregationSetup: argv.recursive || false,
            optImPols: argv.impols || false,
            binFiles,
            stdPath: argv.stdPath,
            fixedPath: argv.fixed,
        }
    }

    await setupCmd(config, buildDir);

    console.log("files Generated Correctly");
}

run().then(()=> {
    process.exit(0);
}, (err) => {
    console.log(err.message);
    console.log(err.stack);
    process.exit(1);
});

