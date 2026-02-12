const Expression = require("../expression.js");
const Debug = require('../debug.js');
const assert = require('../assert.js');
const Context = require('../context.js');
const SequenceBase = require('./base.js');

module.exports = class SequenceTypeOf extends SequenceBase {
    constructor (parent, label, options = {}) {
        super(parent, label, options);
        this.extendPos = 0;
        this.isSequence = true;
        this.isList = true;        
    }
    arithSeq(e) {
        // all value must be numerics, no sense arithSeq with "non-numeric" values
        let values = [e.t1 instanceof Expression ? e.t1 : e.t1.value, e.t2 instanceof Expression ? e.t2 : e.t2.value];
        if (e.tn) {
            values.push(e.tn instanceof Expression ? e.tn : e.tn.value);
            if (e.tn.times) values.push(e.tn.times);
        }
        if (e.t1.times) values.push(e.t1.times);
        if (e.t2.times) values.push(e.t2.times);
        return this.checkNumericValues(values);
    }
    checkNumericValues(values) {
        for (const value of values) {
            if (typeof value === 'bigint' || typeof value === 'number') continue;
            if (!value || typeof value.asInt !== 'function') {
            }
            if (value.asInt(false) === false) { 
                this.isSequence = false;
                this.isList = false;
                return false;
            }
        }
        return this.isSequence || this.isList;
    }
    geomSeq(e) {
        // to calculate type, it's same arith and geo sequences
        return this.arithSeq(e);
    }
    rangeSeq(e) {
        let values = [e.from, e.to];
        if (e.times) values.push(e.times);
        if (e.toTimes) values.push(e.toTimes);
        return this.checkNumericValues(values);
    }
    seqList(e) {
        for (const value of e.values) {
            if (!this.insideExecute(value)) return false;
        }
        return this.isSequence || this.isList;
    }
    sequence(e) {
        return this.seqList(e);
    }
    paddingSeq(e) {       
        // a padding implies a sequence because padding wasn't compatible with list
        this.isList = false;
        return this.insideExecute(e.value);
    }
    expr(e) {
        if (typeof e !== 'bigint' && typeof e !== 'number' && e.asIntDefault(false) === false) {
            this.isSequence = false;
            return this.isList;
        }
        return this.isSequence || this.isList;
    }
    repeatSeq(e) {
        this.checkNumericValues([e.times]);
        const times = this.e2num(e.times);
        // how it's a repeat, all element and types are equal for all repetitions. 
        if (!this.insideExecute(e.value)) return false; 
        return this.isSequence || this.isList;
    }    
}