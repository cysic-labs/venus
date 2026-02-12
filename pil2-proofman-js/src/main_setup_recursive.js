const fs = require("fs");
const version = require("../package").version;
const path = require("path");

const { genRecursiveSetupTest } = require("./setup/generateRecursiveSetup");

const argv = require("yargs")
    .version(version)
    .usage("node main_setup_recursive.js -b <buildDir> -c <circomPath> -n <circomName>")
    .alias("b", "builddir")
    .alias("c", "circomPath")
    .alias("n", "circomName")
    .alias("p", "stdPath")
    .alias("t", "type")
        .argv;

async function run() {

    const buildDir = argv.builddir || "tmp";
     // if circompath not defined, error
    if (!argv.circomPath || !argv.circomName) {
        throw new Error("Circom path and name must be provided");
    }

    const circomPath = argv.circomPath;
    const circomName = argv.circomName;
    
    // Validate and set type
    const type = typeof(argv.type) === "string" ? argv.type.trim() : "aggregation";
    if (type != "compressor" && type !== "aggregation" && type !== "final_vadcop" && type !== "light") {
        throw new Error("type must be either aggregation, final_vadcop or light");
    }

    await fs.promises.mkdir(buildDir, { recursive: true });

    if (!argv.stdPath) {
        throw new Error("Std path name must be provided");
    }

    const setupOptions = {
        constTree: process.platform === 'darwin' 
                ? path.resolve(__dirname, 'setup/build/bctree_mac')
                : path.resolve(__dirname, 'setup/build/bctree'),
        binFile: process.platform === 'darwin' 
                ? path.resolve(__dirname, 'setup/build/binfile_mac')
                : path.resolve(__dirname, 'setup/build/binfile'),
        stdPath: argv.stdPath,
    };

    await genRecursiveSetupTest(buildDir, setupOptions, circomPath, circomName, type);

    console.log("files Generated Correctly");
}

run().then(()=> {
    process.exit(0);
}, (err) => {
    console.log(err.message);
    console.log(err.stack);
    process.exit(1);
});

