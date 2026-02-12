const ProofStageItem = require("./proof_stage_item.js");
const CustomColItem = require('../expression_items/custom_col.js')
const Debug = require('../debug.js');
const assert = require('../assert.js');

module.exports = class CustomCol extends ProofStageItem {
    constructor (id, commit, stage = false) {
        assert.defined(typeof id);
        super(id, stage ?? commit.defaultStage);
        this.commit = commit;
    }
    clone() {
        let cloned = new CustomCol(this.id, this.commit, this.stage);
        return cloned;
    }
    getCommitName() {
        return this.commit.name;
    }
    getCommitId() {
        console.log(this);
        return this.commit.id;
    }
    get value () {
        return new CustomColItem(this.id);
    }
}
