const Expression = require("../expression.js");
const Debug = require('../debug.js');
const assert = require('../assert.js');
const Context = require('../context.js');
const SequenceBase = require('./base.js');

const MAX_VALUE_FORCED = 2n ** 64n;
module.exports = class SequenceSizeOf extends SequenceBase {
    seqList(e) {
        let size = 0;
        for(const value of e.values) {
            size += this.insideExecute(value);
        }
        return size
    }
    sequence(e) {
        if (!this.maxValue) this.maxValue = 0n;
        return this.seqList(e);
    }
    repeatSeq(e) {
        const times = this.toNumber(Context.processor.getExprNumber(e.times));
        if (Debug.active) console.log(['times', times]);
        return times  * this.insideExecute(e.value);
    }
    paddingSeq(e) {
        const size = this.insideExecute(e.value);
        return this.parent.setPaddingSize(size);
    }
    countFromTo(fromValue, toValue) {
        let res = toValue > fromValue ? toValue - fromValue: toValue - fromValue;
        res = res < 0n ? -res : res;
        return res + 1n;
    }
    rangeSeq(e) {
        // TODO review if negative, fe?
        const [fromValue, toValue, times] = this.getRangeSeqInfo(e);
        this.updateLimitsValue(fromValue);
        this.updateLimitsValue(toValue);
        let res = this.toNumber(this.countFromTo(fromValue, toValue)) *  times;
        return res;
    }
    arithSeq(e) {
        const [t1, t2, tn, times] = this.getTermSeqInfo(e);
        const delta = t2 - t1;
        this.updateLimitsValue(t1);
        this.updateLimitsValue(t2);
        if (tn !== false) {
            const distance = tn - t2;
            if ((delta > 0 && tn < t2) || (delta < 0 && tn > t2) || (distance % delta !== 0n)) {
                throw new Error(`Invalid terms of arithmetic sequence ${t1},${t2}...${tn} at ${this.debug}`);
            }
            this.updateLimitsValue(tn);
            return this.toNumber(distance/delta + 2n) * times;
        }
        else {
            this.paddingSequenceInfo = {from: t1, delta, times};
            return this.paddingSize = (2 * times);
        }
        // TODO review if negative, fe?
    }
    geomSeq(e) {
        const [t1, t2, tn, times] = this.getTermSeqInfo(e);
        this.updateLimitsValue(t1);
        if (t1 === 0n) {
            throw new Error(`Invalid terms of geometric sequence ${t1},${t2}...${tn} at ${this.debug}`);
        }
        const [count, reverse, ti, tf, ratio] = this.getGeomInfo(t1, t2, tn, times, true);

        if (tf !== false) {
            this.updateLimitsValue(tf);
        }
        if (tn !== false) {
            return count * times;
        } else {
            this.paddingSequenceInfo = {from: t1, ratio, times};
            return this.paddingSize = (2 * times);
        }
    }
    expr(e) {
        this.updateLimitsValue(e.asIntDefault(0n));
        return 1;
    }
    forceMaxValue() {
        if (this.useFieldElement()) {
            this.maxValue = Context.Fr.e(-1);
        } else {
            this.maxValue = MAX_VALUE_FORCED;
        }
    }
    updateLimitsValue(value) {
        if (this.useFieldElement()) {
            value = Context.Fr.e(value);
            if (value > this.maxValue) {
                this.maxValue = value;
            }
            return;
        }
        if (this.maxValue < value) {
            this.maxValue = value;
        }
        if (this.minValue > value) {
            this.minValue = value;
        }
    }
    getMaxValue() {
        return this.maxValue;
    }
    getMaxBytes() {
        // if (this.maxValue < 256n) return 1;
        // if (this.maxValue < 65536n) return 2;
        // if (this.maxValue < 4294967296n) return 4;
        if (this.maxValue < 0x10000000000000000n) return 8;
        return true;  // means bigdata
    }
    updateMaxSizeWithPadingSize(paddingSize) {
        const info = this.paddingSequenceInfo;
        if (!info) return;

        const count = BigInt(Math.ceil(paddingSize / info.times));

        if (info.delta) {   // arithmetic serie
            this.updateLimitsValue(info.from + info.delta * (count - 1n));
        }
        if (info.ratio) {
            // BE CAREFULL: could be a field element with a big number, but only need it to decide if
            // we need to increase, for these reason use force to use MaxValue
            this.forceMaxValue();
        }
    }
}