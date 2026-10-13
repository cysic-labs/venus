const fs = require("fs");
const version = require("../package").version;

const setupSnarkCmd = require("./cmd/setup_snark_cmd");

const argv = require("yargs")
    .version(version)
    .usage("node main_setup_snark.js -b <buildDir> -p <publicsinfo.json> -w <powersoftau.ptau> [-n <snark>]")
    .alias("b", "builddir")
    .alias("p", "publicsinfo")
    .alias("w", "ptau")
    .alias("n", "snark")
    .demandOption(["builddir", "publicsinfo", "ptau"])
    .describe("b", "Build directory holding provingKey and the recursivef setup in provingKeySnark (generate-key-rs --snark)")
    .describe("p", "Path to publics info JSON file")
    .describe("w", "Path to powers of tau file")
    .describe("n", "Final snark type: 'fflonk' or 'plonk' (default: fflonk)")
    .argv;

async function run() {
    if (!argv.builddir) {
        throw new Error("Build directory must be provided");
    }

    const buildDir = argv.builddir;

    if (argv.snark && ["fflonk", "plonk"].indexOf(argv.snark) < 0) {
        throw new Error("Final snark must be 'fflonk' or 'plonk'");
    }

    const config = {
        publicsInfo: JSON.parse(await fs.promises.readFile(argv.publicsinfo, "utf8")),
        powersOfTauFile: argv.ptau,
        finalSnark: argv.snark || "fflonk",
    };

    await setupSnarkCmd(config, buildDir);

    console.log("Final snark setup files generated correctly");
}

run().then(() => {
    process.exit(0);
}, (err) => {
    console.log(err.message);
    console.log(err.stack);
    process.exit(1);
});
