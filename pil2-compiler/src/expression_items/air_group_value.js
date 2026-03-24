const ProofItem = require("./proof_item.js");
module.exports = class AirGroupValue extends ProofItem {
    constructor (id) {
        super(id);
    }
    get degree() {
        return 0;
    }
    getTag() {
        return 'airgroupvalue';
    }
    cloneInstance() {
        return new AirGroupValue(this.id);
    }
}
