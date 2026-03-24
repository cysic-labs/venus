const assert = require('../assert.js');
const ProofItem = require("./proof_item.js");
const Context = require('../context.js');
const Debug = require('../debug.js');
module.exports = class WitnessCol extends ProofItem {
    constructor (id) {
        assert.defined(id);
        super(id);
        this.rowOffsetApply = true;
        if (Debug.active) console.log('CONSTRUCTOR_WITNESS', id, this.id);
    }
    get degree() {
        return 1;
    }
    getTag() {
        return 'witness';
    }
    cloneInstance() {
        return new WitnessCol(this.id);
    }
}
