const ProofStageItem = require("./proof_stage_item.js");
const WitnessColItem = require('../expression_items/witness_col.js')
const Debug = require('../debug.js');
const assert = require('../assert.js');

module.exports = class WitnessCol extends ProofStageItem {
    constructor (id, stage = 1) {
        assert.defined(typeof id);
        super(id, stage);
        if (Debug.active) console.log('CONSTRUCTOR_WITNESS', id, this.id);
    }
    clone() {
        let cloned = new WitnessCol(this.id, this.stage);
        if (Debug.active) console.log('CLONE_WITNESS:', this, cloned);
        return cloned;
    }
    get value () {
        return new WitnessColItem(this.id);
    }
}
