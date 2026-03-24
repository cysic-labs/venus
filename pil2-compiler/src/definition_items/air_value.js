const ProofStageItem = require("./proof_stage_item.js");
const AirValueItem = require('../expression_items/air_value.js')
const Context = require('../context.js');

const assert = require('../assert.js');
module.exports = class AirValue extends ProofStageItem {
    constructor (id, data = {}) {
        super(id, data.stage);
        const airId = data.airId ?? Context.airId;
        assert.typeOf(airId, 'number');
        this.airId = airId;
        this.sourceRef = data.sourceRef;
        this.label = data.label;
    }
    clone() {
        return new AirValue(this.id, {  stage: this.stage,
                                        sourceRef: this.sourceRef,
                                        airId: this.airId,
                                        label: (this.label && typeof this.label.clone === 'function') ? this.label.clone : this.label});
    }
    get value () {
        return new AirValueItem(this.id);
    }
}
