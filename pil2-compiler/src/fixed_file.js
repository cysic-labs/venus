const fs = require("fs");
const path = require("path");
const Context = require("./context.js");
const { type } = require("os");
const MAX_BUFF_SIZE = 1024 * 1024 * 16; // 8 * 32Mb
const HEADER_SIGNATURE = "cnst\x01\0\0\0\x01\0\0\0\x01\0\0\0";

module.exports = class FixedFile {
    constructor (valuesList, rows, labels = []) {
        this.valuesList = valuesList;
        this.loaded = valuesList.map(() => false);
        this.rows = rows;
        this.labels = labels;
    }
    defineCol(col, values, label) {
        if (this.valuesList[col] !== undefined) {
            throw new Error(`Column ${col} already defined in fixed file`);
        }
        this.valuesList[col] = values;
        this.labels[col] = label;
    }
    saveToFile(filename) {
        const _filename = (!Context.fixedOutputDir || filename.startsWith('/')) ? filename : path.join(Context.fixedOutputDir, filename);
        const dirname = path.dirname(_filename);
        console.log(`  > Saving fixed file ${_filename} ...`);
        if (!fs.existsSync(dirname)) {
            fs.mkdirSync(dirname, { recursive: true });
        }
        const fd = fs.openSync(_filename, "w+");

        const cols = this.valuesList.length;
        const maxBuffSize = MAX_BUFF_SIZE;
        const totalSize = cols * this.rows;
        const buff = new BigUint64Array(Math.min(totalSize, maxBuffSize));

        let p=0;
        let irow = 0;
        let icol = 0;
        try {
            for (irow = 0; irow < this.rows; irow++) {
                for (icol = 0; icol < cols; ++icol) {
                    let value = BigInt(this.valuesList[icol][irow]);
                    // improvements if no negative 
                    if (value < 0n) {
                        // value += Context.Prime;                
                        value += 0xFFFF_FFFF_0000_0001n;
                    }
                    // assert(value >= 0n, `Negative value ${value} at row ${irow} and column ${icol}`);
                    buff[p++] = value;
                    if (p == buff.length) {
                        const buff8 = new Uint8Array(buff.buffer);
                        fs.writeSync(fd, buff8);
                        p=0;
                    }
                }
                
            }
        } catch (error) {
            throw new Error(`Error saving file ${filename}: ${this.labels[icol]??'?'} [col:${icol} row:${irow}/${this.rows}] ${error.message}`);
        }

        if (p) {
            const buff8 = new Uint8Array(buff.buffer, 0, p*8);
            fs.writeSync(fd, buff8);
        }

        fs.closeSync(fd);
        return _filename;
    }    
}
