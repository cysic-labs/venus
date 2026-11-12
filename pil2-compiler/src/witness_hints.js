module.exports = class WitnessHints {
    constructor () {
        this.witnessHints = {};
        this.witnessHintsStack = [];
    }
    clear() {
        this.witnessHints = [];
    }
    add(witnessId, expressionId) {
        this.witnessHints['_'+witnessId] = expressionId;
    }
    push() {
        this.witnessHintsStack.push(this.witnessHints);
        this.clear();
    }
    pop() {
        this.witnessHints = this.witnessHintsStack.pop();
    }
}
