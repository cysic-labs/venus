const ProofStageItem = require("./proof_stage_item.js");
const assert = require('../assert.js');
module.exports = class AirGroupValue extends ProofStageItem {
    constructor (id, data = {}) {
        super(id, data.stage);
        const airGroupId = data.airGroupId ?? false;
        assert.strictEqual(typeof data.airGroupId, 'number');
        this.airGroupId = airGroupId;
        this.aggregateType = data.aggregateType;
        this.sourceRef = data.sourceRef;
        this.label = data.label;
        this.relativeId = data.relativeId ?? false;
        this.defaultValue = data.defaultValue ?? false;
    }
    clone() {
        return new AirGroupValue(this.id, { stage: this.stage,
                                            aggregateType: this.aggregateType,
                                            sourceRef: this.sourceRef,
                                            airGroupId: this.airGroupId,
                                            relativeId: this.relativeId,
                                            defaultValue: this.defaultValue,
                                            label: (this.label && typeof this.label.clone === 'function') ? this.label.clone : this.label});
    }
}
