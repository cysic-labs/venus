const fs = require("fs");
const version = require("../package").version;

const setupFinalCompressedCmd = require("./cmd/setup_final_compressed_cmd");

const argv = require("yargs")
    .version(version)
    .usage("node main_setup_final_compressed.js -t <stdPath> -b <buildDir>")
    .alias("k", "provingkey")
    .alias("b", "builddir")
    .alias("t", "stdPath")
    .demandOption(["stdPath", "builddir"])
    .describe("b", "Build directory for output files")
    .describe("t", "Path to PIL2 std library")
    .argv;

async function run() {
    if (!argv.stdPath) {
        throw new Error("Std path must be provided");
    }

    if (!argv.builddir) {
        throw new Error("Build directory must be provided");
    }

    const buildDir = argv.builddir;

    const config = {
        stdPath: argv.stdPath,
    };

    await setupFinalCompressedCmd(config, buildDir);

    console.log("Vadcop Final compressed setup files generated correctly");
}

run().then(() => {
    process.exit(0);
}, (err) => {
    console.log(err.message);
    console.log(err.stack);
    process.exit(1);
});
