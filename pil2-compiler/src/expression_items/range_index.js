const RuntimeItem = require("./runtime_item.js");
const Context = require('../context.js');
module.exports = class RangeIndex extends RuntimeItem {
    constructor (from, to) {
        super();
        this.from = from !== false ? from.clone() : false;
        this.to = to !== false ? to.clone(): false;
    }
    cloneInstance() {
        return new RangeIndex(this.from, this.to);
    }
    evalInside() {
        return this.clone();
    }
}
