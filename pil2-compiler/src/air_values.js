const GlobalIndexable = require("./global_indexable.js");
const AirValueItem = require("./expression_items/air_value.js");
const AirValueDefinition = require("./definition_items/air_value.js");
module.exports = class AirValues extends GlobalIndexable {
    constructor () {
        super('airvalue', AirValueDefinition, AirValueItem)
    }
    getLabels(dataFields = []) {
        let labels = [];
        for (const label of this.labelRanges) {
            if (!this.activeIds.includes(label.from)) continue;
            const value = this.globalValues[label.from];
            let data = {};
            for (const field of dataFields) {
                data[field] = value[field];
            }
            labels.push({...label, data});
        }
        return labels;
    }    
}
