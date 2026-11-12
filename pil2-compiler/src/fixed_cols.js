const GlobalIndexable = require("./global_indexable.js");
const FixedColItem = require("./expression_items/fixed_col.js");
const FixedCol = require("./definition_items/fixed_col.js");
const Context = require('./context.js');
const assert = require('./assert.js');
const { ContinueCmd } = require("./flow_cmd.js");
const fs = require('fs');
const path = require('path');
const COLORS = require("./colors.js");
module.exports = class FixedCols extends GlobalIndexable {

    constructor () {
        super('fixed', FixedCol, FixedColItem);
    }
    getEmptyValue(id, data) {
        return new FixedCol(id, data);
    }
    setRowValue(id, row, value) {
        const item = this.get(id);
        if (assert.isEnabled) assert.ok(item, {type: this.type, definition: this.definitionClass, id, item});
        if (typeof item.setRowValue !== 'function') {
            console.log({type: this.type, definition: this.definitionClass, id, item});
            throw new Error(`Invalid assignation at ${Context.sourceTag}`);
        }
        item.setRowValue(row, value);
        if (this.debug) {
            console.log(`SET ${this.constructor.name}.${this.type} @${id} ${value}`);
        }
    }
    getRowValue(id, row, rowOffset = 0) {
        const item = this.get(id);
        if (assert.isEnabled) assert.ok(item, {type: this.type, definition: this.definitionClass, id, item});
        if (typeof item.getRowValue !== 'function') {
            console.log({type: this.type, definition: this.definitionClass, id, item});
            throw new Error(`Invalid access at ${Context.sourceTag}`);
        }
        return item.getRowValue(row, rowOffset);
    }
    getNonTemporalLabelRanges() {
        let res = [];
        for (const range of this.labelRanges) {
            const from = range.from;
            if (!this.activeIds.includes(from)) continue;
            if (this.globalValues[from].temporal) continue;
            res.push(range);
        }
        return res;
    }
    exportToTxt(filename) {
        let cols = [];
        for (const id of this.activeIds) {
            let col = this.get(id);
            if (col.temporal) continue;
            cols.push(this.get(id));
        }
        
        if (cols.length === 0) return;
        // Get number of rows
        const numRows = cols[0].rows;
        
        // Create header: row; followed by column labels
        let header = 'row';
        for (const col of cols) {
            header += ';' + (col.label || col.id);
        }
        header += '\n';
        
        const _filename = (!Context.fixedOutputDir || filename.startsWith('/')) ? filename : path.join(Context.fixedOutputDir, filename);
        const dirname = path.dirname(_filename);
        console.log(`  > Exporting fixed to ${COLORS.filename(_filename)} ...`);
        if (!fs.existsSync(dirname)) {
            fs.mkdirSync(dirname, { recursive: true });
        }
        const fd = fs.openSync(_filename, "w+");

        // Write header
        fs.writeSync(fd, header);
        
        // Write data lines row by row
        for (let row = 0; row < numRows; row++) {
            let line = row.toString();
            for (const col of cols) {
                const value = col.getRowValue(row);
                line += ';' + value;
            }
            line += '\n';
            fs.writeSync(fd, line);
        }
        
        // Close file
        fs.closeSync(fd);
    }
}
