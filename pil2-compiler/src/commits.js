const { identity } = require("lodash");
const Definitions = require("./definitions.js");

module.exports = class Commits extends Definitions {
    constructor () {
        super();
        this.publics = [];
        this.closed = [];
    }
    define(name, value, msg) {
        const duplicated = value.publics.filter(p => this.publics.includes(p.id));
        if (duplicated.length > 0) {
            console.log(duplicated);
            throw new Error(`Publics ${duplicated.map(p => p.label).join()} already used in other commit`);
        }
        super.define(name, value, msg);
        this.publics.push.apply(this.publics, value.publics.map(p => p.id));
    }
    clearAir() {
        for (const name in this.definitions) {
            if (this.definitions[name].scope === 'air') {
                this.closed.push(this.definitions[name]);
                delete this.definitions[name];
            }
        }
    }
}
