const ProofStageItem = require("./proof_stage_item.js");
module.exports = class Challenge extends ProofStageItem {
    constructor (id, data = {}) {
        super(id, data.stage);
        this.sourceRef = data.sourceRef;
        this.label = data.label;
        this.relativeId = data.relativeId;
    }
    clone() {
        return new Challenge(this.id, {stage: this.stage, sourceRef: this.sourceRef, relativeId: this.relativeId,
                                       label: (this.label && typeof this.label.clone === 'function') ? this.label.clone(): this.label});
    }
}
