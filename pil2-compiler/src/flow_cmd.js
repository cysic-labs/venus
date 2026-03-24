const Context = require('./context');
class FlowAbortCmd {
    static __counter = 0;
    constructor(value = false) {
        this.id = FlowAbortCmd.__counter++; 
        this.active = true;
        this.value = value;
        this.sourceRef = Context.sourceRef;
    }
    getResult() {
        // If active return self, because continue jumping throw the statements
        if (this.active) { 
            return this;
        }
        return this.value;
    }
    reset() {
        this.active = false;
        return this.value ? this.value.eval() : this.value;
    }
};
class BreakCmd extends FlowAbortCmd {};
class ContinueCmd extends FlowAbortCmd {};
class ReturnCmd extends FlowAbortCmd {
    constructor(value) { super(value); }
}

module.exports = {
    FlowAbortCmd,
    BreakCmd,
    ContinueCmd,
    ReturnCmd
}