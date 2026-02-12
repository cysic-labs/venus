const RuntimeItem = require("./runtime_item.js");
const Context = require('../context.js');
const RowOffset = require('./row_offset.js');
const ExpressionItem = require('./expression_item.js');
const ExpressionReference = require('./expression_reference.js');
const Debug = require('../debug.js');
const util = require('util');
const assert = require('../assert.js');
module.exports = class ReferenceItem extends RuntimeItem {
    constructor (name, indexes = [], rowOffset) {
        super();
        this.name = name;
        try {
            this.indexes = indexes.map(index => index.clone());
        } catch (e) {
            console.log(indexes);
            throw e;
        }
        this.rowOffset = RowOffset.factory(rowOffset);
    }
    get isReferencedType() {
        return true;
    }
    set locator (value) {
        throw new Error(`setting locator on reference ${this.name} ${this.indexes.length}`);
    }
    dump(options) {
        return 'ReferenceItem('+this.toString(options)+')';
    }
    toString(options) {
        const [pre,post] = this.getRowOffsetStrings();
        const _indexes = [];
        if (this.indexes.length) {
            for (const index of this.indexes) {
                _indexes.push(index.toString(options));
            }
        }
        return `${pre}${this.name}${this.indexes.length > 0 ? '['+_indexes.join('][')+']':''}${post}`;
    }
    cloneInstance() {
        let cloned = new ReferenceItem(this.name, this.indexes, this.rowOffset);
        return cloned;
    }
    evalInside(options = {}) {
        return this.evalInsideExtra().result;
    }

    evalInsideExtra(options = {}) {
        const rowOffset = (this.rowOffset ? this.rowOffset.getValue() : 0) + (options.rowOffset ?? 0);
        const item = Context.references.getItem(this.name, this.indexes, {rowOffset});
        if (item.isEmpty()) {
            throw new Error(`accessing to ${item.label} before his initialization at ${Context.sourceRef}`);
        }
        // ExpressionItems also evaluate rowOffset, we need to ignore if previously the rowOffset was applied.
        const isExpression = item instanceof ExpressionItem || item instanceof ExpressionReference;
        if (this.rowOffset && !this.rowOffset.isZero()) {
            if (!options.ignoreRowOffset  || !isExpression) {
                assert.ok(this.isClone(options));
                const rowOffset = this.rowOffset.getValue();
                item.applyNext(rowOffset, options);
            }
        }
        if (Debug.active) {
            console.log(`REFERENCE ${this.name} [${this.indexes.join('][')}]`)
            console.log(item);
        }
        const result = item.eval(options);
        return {result, isExpression};
    }
}
