const Indexable = require("./indexable.js");
const AirGroupValueItem = require("./expression_items/air_group_value.js");
const AirGroupValueDefinition = require("./definition_items/air_group_value.js");
const assert = require('./assert.js');
module.exports = class AirGroupValues extends Indexable {

    static onceLabels = [];
    constructor () {
        super('airgroupvalue', AirGroupValueDefinition, AirGroupValueItem)
    }
    getRelativeLabel(airGroupId, id, options) {
        // TODO: arrays
        const value = this.globalValues.find(x => x.relativeId == id && x.airGroupId == airGroupId);

        return value ? value.label : `airgroupvalue(${airGroupId},${id})`;
    }
    clearOnceLabels(airGroupId) {
        AirGroupValues.onceLabels[airGroupId] = [];
    }
    getOnceLabelsByAirGroupId(airGroupId, id, options) {
        const labels = this.getLabelsByAirGroupId(airGroupId, id ,options);
        const res = [];
        for (const label of labels) {
            assert.typeOf(label.from, 'number');
            if (AirGroupValues.onceLabels[airGroupId].includes(label.from)) continue;
            AirGroupValues.onceLabels[airGroupId].push(label.from);
            res.push(label);
        }
        return res;
    }
    getLabelsByAirGroupId(airGroupId, dataFields = []) {
        let labels = [];
        for (const label of this.labelRanges) {
            const value = this.globalValues[label.from];
            if (value.airGroupId != airGroupId) continue;
            let data = {};
            for (const field of dataFields) {
                data[field] = value[field];
            }
            labels.push({...label, data});
        }
        return labels;
        // return this.labelRanges.toArray().filter(x => this.values[x.from].airGroupId === airGroupId);
    }
    getEmptyValue(id, options = {}) {
        const airGroupId = options.airGroupId;
        const relativeId = this.globalValues.reduce((res, spv) => spv.airGroupId === airGroupId ? res + 1 : res, 0);
        let definition = super.getEmptyValue(id, {relativeId, ...options});
        return definition;
    }
    getDataByAirGroupId(airGroupId) {
        let result = [];
        for (let index = 0; index < this.globalValues.length; ++index) {
            if (this.globalValues[index].airGroupId != airGroupId) continue;
            result.push({id: index, ...this.globalValues[index]});
        }
        return result;
    }
    getIdsByAirGroupId(airGroupId) {
        let result = [];
        for (let index = 0; index < this.globalValues.length; ++index) {
            if (this.globalValues[index].airGroupId != airGroupId) continue;
            result.push(index);
        }
        return result;
    }
    getAggreationTypesByAirGroupId(airGroupId) {
        return this.globalValues.filter(x => x.airGroupId == airGroupId).map(x => x.aggregateType);
    }
}
