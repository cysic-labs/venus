const util = require('util');

module.exports = class TranslationTable {
    constructor () {
        this.values = [];
    }
    initWithAllToPurge(originalLength, purge) {        
        let nextNewPos = 0;
        for (let pos = 0; pos < originalLength; ++pos) {
            if (purge[pos]) this.savePurge(pos);
            else this.translate(pos, nextNewPos++);
        }
    }
    translate(pos, newPos) {
        this.values[pos] = {newPos, operand: false, purge: false};
    }
    savePurge(pos, operand = false) {
        this.values[pos] = {newPos: false, operand, purge: true};
    }
    copyPurge(pos, sourcePos) {
        this.values[pos] = {...this.values[sourcePos], purge: true};
    }
    getTranslation(pos) {
        if (typeof this.values[pos] === 'undefined') {
            return false;
        }
        return this.values[pos].newPos;
    }
    getSaved(pos) {
        if (typeof this.values[pos] === 'undefined' || this.values[pos].operand === false) {
            this.dump();
            throw new Error(`Accessing to non-saved value on position ${pos}`);
        }
        return this.values[pos].operand;
    }
    getPurge(pos) {
        if (typeof this.values[pos] === 'undefined') {
            return false;
        }
        return this.values[pos].purge;
    }
    dump(title, expression) {
        console.log(title ?? 'TranslationTable');
        for (let i = this.values.length-1; i >= 0; --i) {
            const extra = expression ? expression.stringStackPos(i) : '';
            console.log(`T ${i} => ${this.values[i] ? this.values[i].newPos : '·'} ${(this.values[i] && this.values[i].purge)?'(P)':''}`.padEnd(17)+extra)
        }
    }
}