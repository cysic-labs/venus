const Expression = require("../expression.js");
const Context = require('../context.js');
const assert = require('../assert.js');
const { FeValue } = require("../expression_items.js");

module.exports = class SequenceBase {
    static cacheGeomN = {};

    constructor (parent, label, options = {}) {
        this.parent = parent;
        this.get = options.get;
        this.set = options.set;
        this.label = label;
    }
    checkTimes(times) {
        if (times < 1) throw new Error(`Invalid times ${times} in sequence at ${Context.sourceTag}`);
    }
    useFieldElement() {
        return this.parent.fieldElement;
    }
    useBigInt() {
        return this.bytes === 8 || this.bytes === true;
    }
    codeConvert(something, forceBigInt = false) {
        if (this.useFieldElement()) {
            something = `Fr.e(${something})`;
        }
        if (this.useBigInt() || forceBigInt) {
            return something;
        }
        return `Number(${something})`;
    }
    codeFieldElement(value) {
        return value + 'n';
    }
    codeValue(value, forceBigInt = false) {
        if (this.useFieldElement()) {
            value = Context.Fr.e(value);
        }
        if (this.useBigInt() || forceBigInt) {
            return value.toString() + 'n';
        }
        return value.toString();
    }
    get paddingSize() {
        return this.parent.paddingSize;
    }
    set paddingSize(value) {
        this.parent.setPaddingSize(value);
    }
    get bytes() {
        return this.parent.bytes;
    }
    get size() {
        return this.parent.size;
    }
    execute(e) {
        this.beginExecution();
        const res = this.insideExecute(e);
        return this.endExecution(res);
    }
    beginExecution(e) {
    }
    endExecution(res) {
        return res;
    }
    insideExecute(e) {
        const type = e instanceof Expression ? 'expr': e.type;
        switch (type) {
            case 'expr': return this.expr(e);
            case 'sequence': return this.sequence(e);
            case 'padding_seq': return this.paddingSeq(e);
            case 'seq_list': return this.seqList(e);
            case 'repeat_seq': return this.repeatSeq(e);
            case 'range_seq': return this.rangeSeq(e);
            case 'arith_seq': return this.arithSeq(e);
            case 'geom_seq': return this.geomSeq(e);
        }
        throw new Error(`Invalid sequence type ${e.type} ${this.label}`);
    }
    expr(e){
        throw new Error(`Sequence type:expr not implemented for ${this.label}`);
    }
    sequence(e){
        throw new Error(`Sequence type:sequence not implemented for ${this.label}`);
    }
    paddingSeq(e){
        throw new Error(`Sequence type:paddingSeq not implemented for ${this.label}`);
    }
    seqList(e){
        throw new Error(`Sequence type:seqList not implemented for ${this.label}`);
    }
    repeatSeq(e){
        throw new Error(`Sequence type:repeatSeq not implemented for ${this.label}`);
    }
    rangeSeq(e){
        throw new Error(`Sequence type:rangeSeq not implemented for ${this.label}`);
    }
    arithSeq(e){
        throw new Error(`Sequence type:arithSeq not implemented for ${this.label}`);
    }
    geomSeq(e){
        throw new Error(`Sequence type:geomSeq not implemented for ${this.label}`);
    }
    e2num(e) {
        if (typeof e === 'bigint' || typeof e === 'number') {
            return e;
        }
        return e.asInt();
    }
    toNumber(value) {
        let nvalue = Number(value);
        if (nvalue === NaN || isNaN(nvalue)) {
            throw new Error(`Invalid number ${value}`);
        }
        return nvalue;
    }
    getRangeSeqInfo(e) {
        const fromTimes = e.times ? this.toNumber(this.e2num(e.times)): 1;
        const toTimes = e.toTimes ? this.toNumber(this.e2num(e.toTimes)): fromTimes;
        if (fromTimes !== toTimes) {
            throw new Error(`In range sequence, from(${fromTimes}) and to(${toTimes}) must be same`);
        }
        return [this.e2num(e.from), this.e2num(e.to), fromTimes];
    }
    getTermSeqInfo(e) {
        const t1Times = e.t1.times ? this.toNumber(this.e2num(e.t1.times)): 1;
        const t2Times = e.t2.times ? this.toNumber(this.e2num(e.t2.times)): 1;
        const tnTimes = e.tn.times === false ? false : (e.tn.times ? this.toNumber(this.e2num(e.t2.times)): 1);
        if (t1Times !== t2Times && (tnTimes === false || tnTimes === t2Times)) {
            throw new Error(`In term sequence, t1(${t1Times}), t2(${t2Times})`+
                        (tnTimes === false ? '':` and tn(${tbTimes}`)+'must be same');
        }
        const t1 = this.e2num(e.t1 instanceof Expression ? e.t1 : e.t1.value);
        const t2 = this.e2num(e.t2 instanceof Expression ? e.t2 : e.t2.value);
        const tn = e.tn === false ? false : this.e2num(e.tn instanceof Expression ? e.tn : e.tn.value);
        if (t1 === t2) {
            throw new Error(`In term sequence, t1(${t1}), t2(${t2}) must be different`);
        }
        return [t1, t2, tn, t1Times];
    }
    calculateGeomN(ratio, ti, tf) {
        const ratioAsNum = this.toNumber(ratio);
        const rn = tf/ti;

        if (rn <= Number.MAX_SAFE_INTEGER) {
            return BigInt(Math.round(Math.log(this.toNumber(rn))/Math.log(ratioAsNum)));
        }

        const key = [ratio, rn].join('_');
        let res = SequenceBase.cacheGeomN[key];
        if (typeof res !== 'undefined') {
            return res;
        }

        // Path if rn is too big to use Math.log
        let n = BigInt(Math.floor(Math.log(Number.MAX_SAFE_INTEGER)/Math.log(ratioAsNum)));

        let value = rn;
        let chunks = [n];
        let chunkValue = ratio ** n;
        let chunkValues = [chunkValue];
        while (chunkValue < rn) {
            chunkValue = chunkValue * chunkValue;
            n = n * 2n;
            chunkValues.push(chunkValue);
            chunks.push(n);
        }
        n = 0n;
        for (let index = chunks.lenght - 2; index >= 0; --index) {
            if (value < chunkValues[index]) continue;
            value = value / chunkValues[index];
            n = n + chunks[index];
        }
        n = n + BigInt(Math.round(Math.log(this.toNumber(value))/Math.log(ratioAsNum)));
        SequenceBase.cacheGeomN[key] = n;
        return n;
    }
    geomCount(fromValue, toValue, ratio) {
        let count = 1;
        let value = fromValue;
        if (this.useFieldElement()) {
            while (value < toValue) {
                value = Context.Fr.e(value * ratio);
                ++count;
            }
        } else {
            while (value < toValue) {
                value *= ratio;
                ++count;
            }
        }
        if (value !== toValue) {
            throw new Error(`Invalid geometric parameters (from: ${fromValue}, to: ${toValue}, ratio: ${ratio} finalValue: ${value}) at ${Context.sourceTag}`);
        }
        return count;
    }
    calculateToValue(fromValue, delta, times, operation) {
        const size = Math.ceil(this.parent.paddingSize / times);
        switch (operation) {
            case '+': return fromValue + BigInt(size - 1) * delta;
            case '-': return fromValue - BigInt(size - 1) * delta;
            case '*': return fromValue * (delta ** BigInt(size - 1));
            case '/': return fromValue / (delta ** BigInt(size - 1));
        }
        throw new Error(`Invalid sequence operation ${operation}`);
    }
    calculateSingleCount(fromValue, toValue, delta, operation) {
        switch (operation) {
            case '+': return Number((toValue - fromValue) / delta) + 1;
            case '-': return Number((fromValue - toValue) / delta) + 1;
            case '*': return this.geomCount(fromValue, toValue, delta);
            case '/': return this.geomCount(fromValue, toValue, delta);
        }
        throw new Error(`Invalid sequence operation ${operation}`);
    }
    getGeomInfo(t1, t2, tn, times, calculateSize = false) {
        // TODO: negative values ?
        const reverse = t1 > t2;
        const ratio = reverse ? t1/t2 : t2/t1;

        if ((reverse ? t2:t1) === 0n) {
            // console.log({tf, ti, mod:tf % ti, reverse, t1, t2, tn});
            return [false, false, false, false, false];
        }

        let n = 0;
        let padding = tn === false;
        if (padding) {
            if (calculateSize) {
                return [this.paddingSize, reverse, 0n, 0n, ratio];
            }
            n = BigInt(Math.floor(this.paddingSize / times));
            if (!reverse) {
                tn = t1 * (ratio ** n);
            } else {
                // console.log({tn, t1, ratio, n, paddingSize: this.paddingSize});
                tn = t1 / (ratio ** n);
                if (tn === 0n) {
                    throw new Error(`Invalid geometric sequence must specify last element, implicit last element is < 1 ${this.debug}`)
                }
            }
        }
        // console.log({calculateSize, n});
        // TODO: review case tn !== false and reverse
        const tf = reverse ? t1 : tn;
        const ti = reverse ? tn : t1;
        if ((reverse && tn > t2) || (!reverse && tn < t2)) {
            return [false, false, false, false, false];
        }
        if (n == 0) {
            n = this.calculateGeomN(ratio, ti, tf);
            // console.log({_: 'calculateGeomN', n, ratio, ti, tf});
        }
        if (tf !== (ti * (ratio ** BigInt(n)))) {
            throw new Error(`ERROR geometric seq calculation ${tf} !== ${ti} * (${ratio} ** ${BigInt(n)})`);
        }
        return [this.toNumber(n) + 1, reverse, ti, tf, ratio];
    }
    flush() {
    }
}