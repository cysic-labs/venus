const ProofItem = require("./proof_item.js");
const FixedRow = require('./fixed_row.js');
const Context = require('../context.js');
const IntValue = require("./int_value.js");
// const Sequence = require("../sequence.js");
module.exports = class FixedCol extends ProofItem {
    constructor (id) {
        super(id);
        this.rowOffsetApply = true;
    }
    get degree() {
        return 1;
    }
    getId() {
        return this.id;
    }
    isPeriodic() {
        return this.definition.isPeriodic();
    }
    getTag() {
        return 'fixed';
    }
    getValue(row) {
        return this.definition.getValue(row);
    }
    getValueItem(row) {
        return this.definition.getValueItem(row);
    }
    getValues() {
        return this.definition.getValues();
    }
    getRowItem(row, rowOffset) {
        return new FixedRow(this,row, rowOffset);
    }
    getRowCount() {
        return this.definition.getRowCount();
    }
    set(value) {
        this.definition.setValue(value);
    }
    cloneInstance() {
        return new FixedCol(this.id);
    }
    cloneUpdate(source) {
        super.cloneUpdate(source);
        this.definition = source.definition;
    }
    operatorEqAirValue() {
        return new IntValue(0);
    }
    eval(options) {
        if (options && typeof options.evaluateRow !== 'undefined') {
            let row = Number(options.evaluateRow);
            if (this.rowOffset) {
                const rowOffset = this.rowOffset.getValue();
                row += rowOffset; 
            }
            return this.getValueItem(row);
        }
        return this.clone();
    }
    printRowsFrom(offset, count) {
        this.definition.printRowsFrom(offset, count);
    }
    copyRowsFrom(src, src_offset, dst_offset, count) {
        this.definition.copyRowsFrom(src, src_offset, dst_offset, count);
    }
    fillRowsFrom(value, offset, count) {
        this.definition.fillRowsFrom(value, offset, count);
    }
}
