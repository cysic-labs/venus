const GlobalIndexable = require("./global_indexable.js");
const WitnessColItem = require("./expression_items/witness_col.js");
const WitnessCol = require("./definition_items/witness_col.js");
module.exports = class WitnessCols extends GlobalIndexable {

    constructor () {
        super('witness', WitnessCol, WitnessColItem);
    }
    getEmptyValue(id, options) {
        let _options = options ?? {};
        return new WitnessCol(id, _options.stage ?? 1);
    }
    countByStage(initialStage = 1) {
        let stages = this.countByProperty('stage');
        let maxStage = Object.keys(stages).reduce((maxStage, state) => Math.max(maxStage, state), initialStage);
        let res = [];
        for (let istage = initialStage; istage <= maxStage; ++istage) {
            res.push(stages[istage] ?? 0);
        }
        return res;
    }
}
