const assert = require('../assert.js');
const ProofItem = require("./proof_item.js");
const Context = require('../context.js');
const Debug = require('../debug.js');
module.exports = class CustomCol extends ProofItem {
    constructor (id) {
        assert.defined(id);
        super(id);
        this.rowOffsetApply = true;
        if (Debug.active) console.log('CONSTRUCTOR_CUSTOM_COL', id, this.id);
    }
    get degree() {
        return 0;
    }
    getTag() {
        return 'customcol';
    }
    cloneInstance() {
        return new CustomCol(this.id);
    }
}
