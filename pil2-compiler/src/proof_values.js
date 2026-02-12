const Indexable = require("./indexable.js");
const ProofValueItem = require("./expression_items/proof_value.js");
const ProofValueDefinition = require("./definition_items/proof_value.js");
module.exports = class ProofValues extends Indexable {
    static #relativeIds = [];
    constructor () {
        super('proofvalue', ProofValueDefinition, ProofValueItem)
    }
    getEmptyValue(id, data = {}) {
        const stage = data.stage ?? 1;
        const relativeId = this.globalValues.reduce((rid, v) => v.stage === stage ? rid + 1 : rid, 0);
        let definition = super.getEmptyValue(id, {relativeId, ...data});
        return definition;
    }
}
