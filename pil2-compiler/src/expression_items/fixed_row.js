const ExpressionItem = require("./expression_item.js");

module.exports = class FixedRow extends ExpressionItem {
    constructor (col, row, options = {}) {
        super(options);
        this.col = col;
        this.row = row;
    }
    getValue() {
        return this.col.getValue(this.row);
    }
    getValueItem() {
        return this.col.getValueItem(this.row);
    }
    setValue(value) {
        return this.col.setValue(this.row, value);
    }
    cloneInstance() {
        return new FixedRow(this.col, this.row, this.options);
    }
    evalInside(options = {}) {
        return options.asItem ? this.getValueItem() : this.getValue();
    }
}
