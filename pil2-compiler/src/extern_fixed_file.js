const fs = require("fs");
const path = require("path");
const MultiArray = require("./multi_array.js");
const MAX_BUFF_SIZE = 1024 * 1024 * 16; // 8 * 32Mb
const HEADER_SIGNATURE = "cnst\x01\0\0\0\x01\0\0\0\x01\0\0\0";

module.exports = class ExternFixedFile {
    constructor (filename, config = {}) {
        this.filename = filename;
        this.config = config;
        this.cols = {};
        this.rows = 0;
        this.colsByName = {};
        this.fd = false;
        this.load();
    }
    getColByName(name) {
        return this.colsByName[name] ?? false;
    }
    readString() {
        let result = '';
        const charBuffer = Buffer.alloc(1);
        
        while (true) {
            fs.readSync(this.fd, charBuffer, 0, 1, this.position++);
            const char = charBuffer[0];
            if (char === 0) break; // Null terminator
            result += String.fromCharCode(char);
        }
        return result;
    }
    // Read ULE64 (unsigned little-endian 64-bit) synchronously
    readULE64() {
        const buffer = Buffer.alloc(8);
        fs.readSync(this.fd, buffer, 0, 8, this.position);
        this.position += 8;
        return Number(buffer.readBigUInt64LE(0));
    }

    // Read ULE32 (unsigned little-endian 32-bit) synchronously
    readULE32() {
        const buffer = Buffer.alloc(4);
        fs.readSync(this.fd, buffer, 0, 4, this.position);
        this.position += 4;
        return buffer.readUInt32LE(0);
    }
    loadSignature() {
        const buff8 = new Uint8Array(HEADER_SIGNATURE.length);
        const bytesRead = fs.readSync(this.fd, buff8, {offset: 0, position: 0, length: HEADER_SIGNATURE.length});
        if (bytesRead < HEADER_SIGNATURE.length) {
            throw new Error(`Error reading fixed file header, expected to read ${HEADER_SIGNATURE.length} bytes, but got ${bytesRead}`);
        }
        const signature = String.fromCharCode(...buff8);
        if (signature !== HEADER_SIGNATURE) {
            throw new Error(`Invalid fixed file header signature ${signature}, expected ${HEADER_SIGNATURE}`);
        }
        this.position = HEADER_SIGNATURE.length;
    }
    loadHeader() {
        this.sectionSize = this.readULE64();
        this.airGroup = this.readString();
        this.air = this.readString();
        this.rows = this.readULE64();
        this.cols = this.readULE32();
        if (this.config.logFixedFile) {
            console.log(`    - Loading extern fixed file ${this.filename} => [airGroup:${this.airGroup} air:${this.air} rows:${this.rows} cols:${this.cols}]`);
        }
    }
    loadColHeader() {
        const name = this.readString();
        const dim = this.readULE32();
        let indexes = [];
        for (let idim = 0; idim < dim; ++idim) {
            indexes.push(this.readULE32());
        }  
        const size = this.rows * 8;
        if (this.config.logFixedFile) {
            console.log(`    • loading ${name}${dim === 0?'':('['+indexes.join('][')+']')}`);
        }
        
        const buffer = Buffer.alloc(size);
        const values = new BigUint64Array(buffer.buffer, 0, this.rows);
        fs.readSync(this.fd, buffer, 0, size, this.position);
        this.position += size;
        return  [name, dim === 0 ? false : indexes, values];
    } 
    getFullFilename() {
        let fullFilename = (!this.config.inputDir || this.filename.startsWith('/')) ? this.filename : path.join(this.config.inputDir, this.filename);
        if (fs.existsSync(fullFilename)) {
            return fullFilename;
        }

        if (this.config.fileDir && !this.filename.startsWith('/')) {
            let relativeFilename = path.join(this.config.fileDir, this.filename);
            if (fs.existsSync(relativeFilename)) {
                return relativeFilename;
            }
            fullFilename += ', ' + relativeFilename;
        }
        throw new Error(`Fixed file ${this.filename} (${fullFilename}) not found`);
    }
    initValuesArray(indexes, values, level = 0) {
        if (indexes.length > 1) {
            let res = new Array(indexes[0] + 1);
            res[indexes[0]] = this.initValuesArray(indexes.slice(1), values, level + 1);
            return res;
        } else {
            let res = new Array(indexes[0] + 1);
            res[indexes[0]] = values;
            return res;
        }
    }
    updateValuesArray(avalues, indexes, values, level = 0) {
        if (indexes.length > 1) {
            this.initValuesArray(avalues[indexes[0]], indexes.slice(1), values, level + 1);
        } else {
            avalues[indexes[0]] = values;
        }
    }
    load() {
        this.fullFilename = this.getFullFilename();
        try {
            this.fd = fs.openSync(this.fullFilename, "r");
            this.fileSize = fs.fstatSync(this.fd).size;
            this.loadSignature();
            this.loadHeader();
            let colsRead = 0;
            while (colsRead < this.cols) {
                const [name, indexes, values] = this.loadColHeader();
                if (indexes === false) {
                    if (this.colsByName[name]) {
                        throw new Error(`Duplicate column name ${name} in file ${this.filename}`);
                    } else {
                        this.colsByName[name] = {values, loaded: true};
                    }
                } else {
                    let sindex = indexes.join('_');
                    if (this.colsByName[name] === undefined) {
                        this.colsByName[name] = this.initValuesArray(indexes, {values, loaded: true});
                    } else {
                        this.updateValuesArray(this.colsByName[name], indexes, {values, loaded: true});
                    }
                }
                ++colsRead;
            }
        } finally {
            fs.closeSync(this.fd);
            this.fd = false;
        }
    }
}
