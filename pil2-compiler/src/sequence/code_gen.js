const Expression = require("../expression.js");
const Debug = require('../debug.js');
const assert = require('../assert.js');
const Context = require('../context.js');
const SequenceBase = require('./base.js');

module.exports = class SequenceCodeGen extends SequenceBase {
    fromTo(fromValue, toValue, delta, times, operation = '+') {
        let count = 0;
        if (toValue === false) {
            toValue = this.calculateToValue(fromValue, delta, times, operation);
            count = this.paddingSize;
        } else {
            count = this.calculateSingleCount(fromValue, toValue, delta, operation);
        }
        count = times * count;
        const v = this.createCodeVariable('_v');
        const comparator = ((operation === '+' || operation === '*') && delta > 0n) ? '<=':'>=';
        let code = `for(let ${v}=${fromValue}n;${v}${comparator}${toValue}n;${v}=${v}${delta > 0n? operation+delta:delta}n){`;
        if (times === 1) {
            code += `__values.push(${v});}\n`;
        } else {
            const v2 = this.createCodeVariable();
            code += `for(let ${v2}=0;${v2}<${times};++${v2}){__values.push(${v})}}\n;`;
        }
        return [code, count];
    }

    rangeSeq(e) {
        const [fromValue, toValue, times] = this.getRangeSeqInfo(e);
        const delta = fromValue > toValue ? -1n:1n;
        return this.fromTo(fromValue, toValue, delta, times);
    }
    arithSeq(e) {
        const [t1, t2, tn, times] = this.getTermSeqInfo(e);
        if (t1 === t2) {
            throw new Error(`Invalid arithmetic parameters t1:${t1} t2:${t2} tn:${tn} times:${times}`);
        }
        if (t1 > t2) {
            return this.fromTo(t1, tn, t1-t2, times, '-');
        }
        return this.fromTo(t1, tn, t2-t1, times, '+');
    }
    geomSeq(e) {
        const [t1, t2, tn, times] = this.getTermSeqInfo(e);
        if (t1 > t2) {
            if (t1 % t2) {
                throw new Error(`Invalid geometric parameters t1:${t1} t2:${t2} tn:${tn} times:${times}`);
            }
            return this.fromTo(t1, tn, t1/t2, times, '/');
        }
        if (t2 % t1) {
            throw new Error(`Invalid geometric parameters t1:${t1} t2:${t2} tn:${tn} times:${times}`);
        }
        return this.fromTo(t1, tn, t2/t1, times, '*');
    }
    seqList(e) {
        let count = 0;
        let code = e.values.length > 1 ? '{' : '';
        for(const value of e.values) {
            const [_code, _count] = this.execute(value);
            count += _count;
            code += _code;
        }
        return [code + (e.values.length > 1 ? '}' : ''), count];
    }
    sequence(e) {
        return this.seqList(e);
    }
    paddingSeq(e) {
        // TODO: if last element it's a padding, not need to fill and after when access to
        // a position applies an module over index.
        const [_code, seqSize] = this.execute(e.value);
        let remaingValues = this.paddingSize - seqSize;
        if (remaingValues < 0) {
            throw new Error(`In padding range must be space at least for one time sequence [paddingSize(${this.paddingSize}) - seqSize(${seqSize}) = ${remaingValues}] at ${this.debug}`);
        }
        if (seqSize < 1) {
            throw new Error(`Sequence must be at least one element at ${this.debug}`);
        }
        if (remaingValues === 0) {
            return [_code, seqSize];
        }
        let code = `{${_code}`;
        if (remaingValues > 0) {
            const v1 = this.createCodeVariable();
            const base = this.createCodeVariable('_b');
            code += `let ${base}=__values.length-${seqSize};for (let ${v1}=0;${v1}<${remaingValues};++${v1}){__values.push(__values[${base}+${v1}]);}`;
        }
        code += '}\n';
        return [code, seqSize + remaingValues];
    }
    expr(e) {
        // no cache
        const num = this.e2num(e);
        return [`__values.push(${num}n);\n`, 1];
    }
    createCodeVariable(prefix = '_i') {
        const index = (this.varIndex ?? 0) + 1;
        this.varIndex = index;
        return prefix + index;
    }
    repeatSeq(e) {
        if (!e.__cache) {
            const times = this.e2num(e.times);
            const [_code, _count] = this.execute(e.value);
            const v = this.createCodeVariable();
            const code = `for (let ${v}=0;${v}<${times};++${v}){${_code}}`;
            const count = _count * Number(times);
            e.__cache = [code, count];
        }
        return e.__cache;
    }
}