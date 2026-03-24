const Indexable = require("./indexable.js");
const ChallengeItem = require("./expression_items/challenge.js");
const ChallengeDefinition = require("./definition_items/challenge.js");
module.exports = class Challenges extends Indexable {
    constructor () {
        super('challenge', ChallengeDefinition, ChallengeItem);
    }
    getEmptyValue(id, data = {}) {
        const stage = data.stage ?? 2;
        const relativeId = this.globalValues.reduce((rid, val) => val.stage === stage ? rid + 1 : rid, 0);
        let definition = super.getEmptyValue(id, {relativeId, ...data});
        return definition;
    }
}
