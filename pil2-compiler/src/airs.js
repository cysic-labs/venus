const Definitions = require("./definitions.js");

module.exports = class Airs extends Definitions {
    constructor (airGroup) {
        super();
        this.airGroup = airGroup;
    }
}
