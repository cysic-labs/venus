const ProofItem = require("./proof_item.js");
module.exports = class AirValue extends ProofItem {
    constructor (id) {
        super(id);
    }
    get degree() {
        return 0;
    }
    getTag() {
        return 'airvalue';
    }
    cloneInstance() {
        return new AirValue(this.id);
    }
}
