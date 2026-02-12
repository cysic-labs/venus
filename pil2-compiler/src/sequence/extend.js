const Expression = require("../expression.js");
const Debug = require('../debug.js');
const assert = require('../assert.js');
const Context = require('../context.js');
const SequenceBase = require('./base.js');

module.exports = class SequenceExtend extends SequenceBase {
    constructor (parent, label, options = {}) {
        super(parent, label, options);
        this.extendPos = 0;
    }
    arithSeq(e) {
        const [t1, t2, tn, times] = this.getTermSeqInfo(e);
        const delta = t2 - t1;
        /* console.log({tag: 'XXXX-', t1, t2, delta, tn, paddingSize: this.paddingSize});
        const tfinal = tn === false ? t1 + delta * BigInt(this.paddingSize): tn + delta;
        console.log({tag: 'XXXXX', tn, tfinal, paddingSize: this.paddingSize});
        let value = t1;*/
        const count = tn === false ? this.paddingSize : times * (this.toNumber(((tn - t1) / delta)) + 1);
        const finalExtendPos = this.extendPos + count;
        // console.log({t1, t2, delta, tn, extendPos: this.extendPos, count, finalExtendPos, paddingSize: this.paddingSize});
        let value = t1;
        while (this.extendPos < finalExtendPos) {
            for (let itimes = 0; itimes < times && this.extendPos < finalExtendPos; ++itimes) {
                this.pushValue(value);
            }
            value = value + delta;
        }
        return count;
    }
    geomSeq(e) {        
        const [t1, t2, _tn, times] = this.getTermSeqInfo(e);
        const [_count, reverse, ti, tf, ratio] = this.getGeomInfo(t1, t2, _tn, times);

        const padding = _tn === false;
        const tn = padding ? t1 * (ratio ** BigInt(this.paddingSize - 1)) : _tn;
        let value = ti;
        const count = padding ? this.paddingSize : _count * times;
        this.extendPos = this.extendPos + (reverse ? (count - 1):0);
        const initialPos = this.extendPos;

        let itimes = reverse && padding && count % times ? count % times :times;
        // console.log({t1,t2,_tn,times,_count, count, value, reverse, ti, tf, ratio, paddingSize: this.paddingSize,
        //             extendPos: this.extendPos, itimes});
        let remaingValues = count;
        while (remaingValues > 0) {
            while (remaingValues > 0 && itimes > 0)  {
                --remaingValues;
                --itimes;
                this.set(this.extendPos, value);
                this.extendPos = this.extendPos + (reverse ? -1:1);
            }
            itimes = times;
            value = value * ratio;
        }
        if (reverse) {
            this.extendPos = initialPos + 1;
        }
        // console.log({tn, _tn, _count, count});
        return count;
    }
    rangeSeq(e) {
        const [fromValue, toValue, times] = this.getRangeSeqInfo(e);
        return this.extendRangeSeq(fromValue, toValue, times, fromValue > toValue ? -1n:1n);
    }
    extendRangeSeq(fromValue, toValue, times, delta = 1n, ratio = 1n) {
        const initialExtendPos = this.extendPos;
        let value = fromValue;
        assert.ok(times > 0);
        while (value <= toValue) {
            for (let itimes = 0; itimes < times; ++itimes) {
                this.pushValue(value);
            }
            value = (value + delta) * ratio;
        }
        return this.extendPos - initialExtendPos;
    }
    seqList(e) {
        let count = 0;
        for(const value of e.values) {
            count += this.insideExecute(value);
        }
        return count;
    }
    sequence(e) {
        return this.seqList(e);
    }
    pushValue(value) {
        this.set(this.extendPos++, value);
    }
    paddingSeq(e) {        
        let from = this.extendPos;
        let seqSize = this.insideExecute(e.value);
        let remaingValues = this.paddingSize - seqSize;
        if (remaingValues < 0) {
            throw new Error(`In padding range must be space at least for one time sequence at ${this.debug}`);
        }
        if (seqSize < 1) {
            console.log(e.value);
            throw new Error(`Sequence must be at least one element at ${this.debug}`);
        }
        // console.log('SETTING REMAING_VALUES '+remaingValues+' '+seqSize);
        // console.log({remaingValues, seqSize});
        while (remaingValues > 0) {
            let upto = remaingValues >= seqSize ? seqSize : remaingValues;
            // console.log(`SETTING UPTO ${upto} ${remaingValues} ${seqSize}`);
            for (let index = 0; index < upto; ++index) {
                this.pushValue(this.get(from + index));
            }
            remaingValues = remaingValues - upto;
        }
        return this.paddingSize;
    }
    expr(e) {        
        const num = this.e2num(e);
        this.pushValue(num);
        return 1;
    }
    repeatSeq(e) {
        let count = 0;
        const times = this.e2num(e.times);
        for (let itime = 0; itime < times; ++itime) {
            count += this.insideExecute(e.value);
        }
        return count;
    }
}