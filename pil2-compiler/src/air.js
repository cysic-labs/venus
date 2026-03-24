const { log2 } = require("./utils.js");
const Context = require('./context.js');
const FixedFile = require('./fixed_file.js');
const ExternFixedFile = require('./extern_fixed_file.js');
const path = require('path');
module.exports = class Air {
    static _airnames = {};
    constructor (id, airGroup, airTemplate, rows, options = {}) {
        this.id = id;
        this.airGroup = airGroup;
        this.airTemplate = airTemplate;
        this._rows = Number(rows);
        this.rowsUsed = false;
        const bits = log2(this._rows);
        this.bits = this._rows > (2 ** bits) ? bits + 1 : bits;
        this.name = (options.name ?? airTemplate.name) ?? '';
        this.loadFixedFiles = {};
        this.virtual = options.virtual ?? false;
        const previousNameIsUsed = Air._airnames[this.name];
        if (typeof previousNameIsUsed !== 'undefined') {
            throw new Error(`Air name ${this.name} on ${Context.sourceRef} already exists on ${previousNameIsUsed}`);
        }
        Air._airnames[this.name] = Context.sourceRef;
        this.outputFixedFile = Context.config.fixedToFile ? this.name + '.fixed' : false;
        this.externFixedFiles = []; 
        this.info = {};
    }    
    setInfo(info) {
        this.info = info;
    }

    get rows () {
        if (this.rowsUsed === false) {
            this.rowsUsed = Context.sourceRef;
        }
        return this._rows;
    }
    updateRows(value) {
        if (this.rowsUsed !== false) {
            throw new Error(`Cannot update N after it has been used. N was first used at ${this.rowsUsed}, but you're attempting to modify it at ${Context.sourceRef}`);
        }
        this._rows = value;
    }
    declareAirValue(name, lengths = [], data = {}) {
        const fullname = Context.getFullName(name);
        const insideAirContainer = Context.references.getContainerScope() === 'air';
        const res = Context.references.declare(fullname, 'airvalue', lengths, data);
        return res;
    }
    setOutputFixedFile(filename) {
        if (typeof filename !== 'string') {
            throw new Error(`Invalid fixed file name ${filename} on ${Context.sourceRef}`);
        }
        this.outputFixedFile = filename;
    }
    // Unused function to define a load fixed column, to allow load all fixed file columns together
    defineLoadFixedFile(filename, col, values, label) {
        let fixedFile = this.loadFixedFiles[filename];
        if (!fixedFile) {
            fixedFile = new FixedFile([], this.rows);
            this.loadFixedFiles[filename] = fixedFile;
        }
        fixedFile.defineCol(col, values, label);
    }
    // Unused function to load all fixed file columns together
    loadFiledFiles() {
        for (const [filename, fixedFile] of Object.entries(this.loadFixedFiles)) {            
            console.log(`  > Loading fixed file ${filename} ...`);
            fixedFile.loadFromFile(filename);
        }
    }
    loadExternFixedFile(filename) {
        if (typeof filename !== 'string') {
            throw new Error(`Invalid extern fixed file name ${filename} on ${Context.sourceRef}`);
        }
        console.log(`  > Loading extern fixed file ${filename} ...`);
        this.externFixedFiles.push(new ExternFixedFile(filename, {...Context.config, fileDir: path.dirname(Context.fullFilename), basePath: Context.basePath}));
    }
    findExternFixedCol(colname) {
        let data = false;
        for (const eff of this.externFixedFiles) {
            data = eff.getColByName(colname);
            if (data !== false) break;
        }
        return data;
    }
}
