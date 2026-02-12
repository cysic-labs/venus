const Context = require('./context.js');
const ExpressionItems = require('./expression_items.js');
const assert = require('./assert.js');
module.exports = class Commit {
    constructor (name, defaultStage = false, publics = [], options = {}) {
        this.name = name;
        this.publics = publics
        this.defaultStage = defaultStage;
        this.scope = options.scope ?? Context.defaultScope;
        this.sourceRef = options.sourceRef ?? '';
    }
}
