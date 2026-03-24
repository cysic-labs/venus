#!/usr/bin/env node

const fs = require('fs');
const util = require('util');
const ExternFixedFile = require('../src/extern_fixed_file.js');

const argv = require("yargs")
    .usage("load_extern_file <extern_file>")
    .argv;


class LoadExternFile {
    constructor() {        
        const filename = argv._[0];
        this.externFile = new ExternFixedFile(filename);
    }

}

const loadExternFile = new LoadExternFile();
