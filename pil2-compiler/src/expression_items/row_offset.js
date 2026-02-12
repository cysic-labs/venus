
const assert = require('../assert.js');
const Context = require('../context.js');
class RowOffset {
    static Zero;
    constructor (index = 0, prior = false) {
        assert.typeOf(index.prior, 'undefined');
        this.index = (typeof index === 'object' && typeof index.clone === 'function') ? index.clone() : index;
        assert.typeOf(prior, 'boolean');
        this.prior = prior;
    }
    get value() {
        return this.getValue();
    }
    getValue(options = {}) {
        if (typeof this.index === 'number') {
            return this.prior ? -this.index : this.index;
        }
        const indexValue = Number(this.index.asInt());
        if (options.instance) {
            this.index = indexValue;
        }
        return this.prior ? -indexValue:indexValue;
    }
    static factory(index, prior = false) {
        if (typeof index === 'undefined') {
            return RowOffset.Zero;
        }
        if (index instanceof RowOffset) {
            return index.clone();
        }
        assert.typeOf(index.prior, 'undefined');
        return new RowOffset(index, prior);
    }
    isPriorRows() {
        return this.prior && this.value !== 0;
    }
    isNextRows() {
        return !this.prior && this.value !== 0;
    }
    isZero() {
        return this.value == 0;
    }
    clone(options = {}) {
        return new RowOffset(this.index, this.prior);
    }
    cloneInstance (options = {}) {
        const clone = new RowOffset();
        clone.setAsInt(this.getValue());
        return clone;
    }
    getStrings() {
        const value = this.value;
        if (!value) {
            return ['',''];
        }
        return [value < 0 ? `${value < -1 ? -value : ''}'`: '', value > 0 ? `'${value > 1 ? value : ''}`:''];
    }
    setAsInt(value) {
        if (value >= 0) {
            this.index = value;
            this.prior = false;
        }
        else if (value < 0) {
            this.index = -value;
            this.prior = true;
        }
    }
    add(rowOffset) {
        if (rowOffset instanceof RowOffset) {
            this.setAsInt(this.getValue() + rowOffset.getValue());
        } else {
            this.setAsInt(this.getValue() + rowOffset);
        }
    }
}

RowOffset.Zero = new RowOffset(0, false);
Object.freeze(RowOffset.Zero);

module.exports = RowOffset;