#!/usr/bin/env node

const path = require("path");
const fs = require("fs");
const version = require("../package").version;
const compile = require("./compiler.js");
const ffjavascript = require("ffjavascript");
const tty = require('tty');
const assert = require('./assert.js');

const OPTIONS = {
    'chrono-proto': { describe: 'activate time measuraments of protobuf generation steps'},
    'debug': { describe: 'enable a verbose debug mode' },
    'log-compress': { describe: 'log extra information of compress mode' },
    'log-transpile': { describe: 'log transpilation code and other debug information about transpiling' },
    'log-transpiled-sequences' : { describe: 'log transpilation of sequences' },
    'log-lines': { describe: 'output the source reference that produce console.log' },
    'println-lines': { describe: 'output the source (pi) that a println/error message' },
    'log-file': { describe: 'enable log files generation' },
    'log-hint-expressions': { describe: 'log all hints expressions' },
    // TODO: log-hint (names), full log only of specified hints
    'log-hints': { describe: 'log all hints' },
    'log-fixed-resize': { describe: 'log all resizing of fixed' },
    'log-deferred-calls': { describe: 'log all deferred calls (finals)'},
    'log-redundant-deferred-calls': { describe: 'log redundant deferred calls (finals)'},
    'disable-reentrant-deferred-calls': { describe: 'disable reentrant deferred calls (final)' },
    'no-proto-fixed-data': { describe: 'no store data of fixed inside pilout' },
    'enable-periodic-cols': { describe: 'enable periodic tables' },
    'output-constraints': { describe: 'output all air and global constraints generated' },
    'output-global-constraints': { describe: 'output all global constraints generated' },
    'raw-constraints-format': { describe: 'if output constraints are enabled only in raw format' },
    'both-constraints-format': { describe: 'if output constraints are enabled show named and raw format' },
    'ignore-unknown-pragmas': { describe: 'ignore unknown pragmas' },
    'debug-fixed-cols': { describe: 'debug fixed columns' },
    'debug-witness-cols': { describe: 'debug witness columns' },
    'debug-fixed-cols-match': { describe: 'debug fixed columns match with pattern' },
    'debug-witness-cols-match': { describe: 'debug witness columns match with pattern' },
    'debug-constraints-match': { describe: 'debug constraints match with pattern' },
    'fixed-to-file': { describe: 'save fixed columns to file' },
    // TODO: option to force witness name as snake_case and air, airtemplate, airgroup in CamelCase
}

const yargs = require("yargs").version(version)
    .usage("$0 <source.pil> <options>")
    .wrap(160)
    .option('e', { alias: 'exec', describe: 'Only execute the pil file' })
    .option('u', { alias: 'outputdir', describe: 'output directory, if directory not exists it will created'})
    .option('f', { alias: 'fixed', describe: 'output fixed file directory (template), if directory not exists it will created'})
    .option('i', { alias: 'inputdir', describe: 'input base directory'})
    .option('o', { alias: 'output', describe: 'output pilout file. if filename is none, no pilout will be generated'})
    .option('n', { alias: 'name', describe: 'name of pilout (protobuf)'})
    .option('P', { alias: 'config', describe: 'pil configuration file (json format)'})
    .option('v', { alias: 'verbose', describe: 'verbose output'})
    .option('I', { alias: 'include', describe: 'include a pil (as adding a include on main pil)'})
    .option('l', { alias: 'lib', describe: 'include paths separated by ,'})
    .option('F', { alias: 'feature', describe: 'enable a pil feature (#pragma feature <name>)'})
    .option('D', { alias: 'define', describe: 'define a global int value with value if it specified, if no was declared as 1'})
    .option('asserts', { describe: 'enable asserts (more slow)'})
    .alias("h", "help")
    .option('O', { alias: 'option', describe: 'set a option options available:\n' + Object.entries(OPTIONS).map(([k,v]) => k.padEnd(30)+ ' '+v.describe).join('\n')});

const argv = yargs.argv;

Error.stackTraceLimit = Infinity;


function getMultiOptions(options, fcall) {
    if (typeof options === 'undefined') return;

    const _options = Array.isArray(options) ? options : [options];
    let res = {};
    for (const option of _options) {
        const posEqual = option.indexOf('=');
        const key = (posEqual > 0) ? option.substr(0, posEqual) : option;
        const value = (posEqual > 0) ? option.substr(posEqual + 1) : true;
        if (typeof fcall === 'function') {
            const [_key,_value] = fcall(key, value);
            res[_key] = _value;
        }
        else res[key] = value;
    }
    return res;
}


async function run() {
    let inputFile;
    if (argv._.length == 0) {
        console.log("You need to specify a source file");
        process.exit(1);
    } else if (argv._.length == 1) {
        inputFile = argv._[0];
    } else  {
        console.log("Only one pil at a time is permited");
        process.exit(1);
    }

    const fullFileName = path.resolve(process.cwd(), inputFile);
    const fileName = path.basename(fullFileName, ".pil");

    let config = typeof(argv.config) === "string" ? JSON.parse(fs.readFileSync(argv.config.trim())) : {};

    if (argv.output) {
        config.outputFile = argv.output;
    } else if (typeof config.outputFile === 'undefined') {
        config.outputFile = fileName + ".pilout";
    }

    if (argv.name) {
        config.name = argv.name;
    } else if (typeof config.name === 'undefined') {
        config.name = path.parse(config.outputFile).name;
    }

    if (argv.verbose) {
        config.verbose = true;
        if (typeof config.color === 'undefined') {
            config.color = tty.isatty(process.stdout.fd);
        }
    }
    if (argv.nofixed) {
        config.fixed = false;
    }
    // only execute
    if (argv.exec || argv.output === 'none') {
        config.protoOut = false;
    }
    const F = new ffjavascript.F1Field((1n<<64n)-(1n<<32n)+1n );

    if (argv.lib) {
        config.includes = argv.lib.split(',');
    }
    if (argv.include) {
        config.includePaths = argv.include.split(',');
    }
    if (argv.outputdir) {
        config.outputDir = argv.outputdir.trim();
    }
    if (argv.fixed) {
        config.fixedOutputDir = argv.fixed.trim();
        config.fixedToFile = true;
    }
    if (argv.inputdir) {
        config.inputDir = argv.inputdir.trim();
    }
    if (argv.asserts) {
        assert.enable(true);
    }

    if (argv.includePathFirst) {
        config.includePathFirst = true;
    }

    Object.assign(config, getMultiOptions(argv.option, (key, value) => {
            const camelCaseKey = key.replace(/-([a-z])/g, (m, chr) => chr.toUpperCase());
            if (typeof OPTIONS[key] === 'undefined') {
                console.log(`\x1B[1;31mERROR:\x1B[0;31m Unknown option \x1B[1m${key}\x1B[0;31m (config.${camelCaseKey})\n       try use -h or --help to see all options\x1B[0m`);
                process.exit(1);
            }
            return [camelCaseKey, value];
        }));

    config.defines = config.defines || {};
    Object.assign(config.defines, getMultiOptions(argv.define, (key, value) => {
            try {
                return [key, BigInt(value)];
            } catch (e) {
                console.log(`\x1B[1;31mERROR:\x1B[0;31m On define \x1B[1m${key}\x1B[0;31m with value \x1B[1m${value}\x1B[0;31m (only numbers are supported in defines)\x1B[0m`);
                process.exit(1);
            }
        }));

    config.features = config.features || {};
    Object.assign(config.features, getMultiOptions(argv.feature, (key, value) => {
            if (value !== true) {
                console.log(`\x1B[1;31mERROR:\x1B[0;31m Pragma feature \x1B[1m${key}\x1B[0;31m has value \x1B[1m${value}\x1B[0;31m, but pragma features can only enable.\x1B[0m`);
                process.exit(1);
            }
            return [key, value];
        }));

    return compile(F, fullFileName, null, config);
}

run().then(res => {
    process.exitCode = res ? 0 : 1;
}, (err) => {
    console.log(err.stack);
    if (err.pos) {
        console.error(`ERROR at ${err.errFile}:${err.pos.first_line},${err.pos.first_column}-${err.pos.last_line},${err.pos.last_column}   ${err.errStr}`);
    } else {
        console.log(err.message);
    }
    process.exitCode = 1;
});
