const ProofItem = require("./proof_item.js");

module.exports = class ProofValue extends ProofItem {
    constructor (id) {
        super(id);
    }
    get degree() {
        return 0;
    }
    getTag() {
        return 'proofvalue';
    }
    cloneInstance() {
        return new ProofValue(this.id);
    }
}
