const ProofItem = require("./proof_item.js");
module.exports = class Challenge extends ProofItem {
    constructor (id) {
        super(id);
    }
    get degree() {
        return 0;
    }
    getTag() {
        return 'challenge';
    }
    cloneInstance() {
        return new Challenge(this.id);
    }
}
