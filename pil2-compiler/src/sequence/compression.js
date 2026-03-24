const Expression = require("../expression.js");
const Debug = require('../debug.js');
const assert = require('../assert.js');
const Context = require('../context.js');
const SequenceBase = require('./base.js');

/*
    4 bytes: magic + (be) bytes_x_element + (bs) bytes_x_size + type + h_size (2 byte)
    4 bytes: total_size (2+4 = 2^48=256TB)

    FROM_TO|from|to|delta|times
    FROM_TO_GEOM|from|to|ratio|times
    PUT|n|value1|value2|...|valuen
    REPEAT|last_elements|elements_repeated

    # SHORTS

    FROM_TO_DELTA_1|from|to|times
    FROM_TO_TIMES_1|from|to|delta
    FROM_TO_DELTA_TIMES_1|from|to

    PUT1|value1
    PUT2|value1|value2
    :
    PUT16|value1|value2|...|valuek

    REPEAT1|elements_repeated
 */

module.exports = class SequenceCompression extends SequenceBase {
    #stack;
    constructor (parent, label, options = {}) { 
        super(parent, label, options);
        this.#stack = [];
        this.short = options.short ?? false;
    }
    beginExecution() {
        this.pos = 0;
    }
    endExecution(res) {
        if (this.#stack.length === 0) {
            return res;
        }
        return [res[0]  + this.flushStack(), res[1]];
    }
    put(op, values, flushStack = true) {
        let code = '';
        if (flushStack && this.#stack.length > 0) {
            code += this.flushStack();
        }
        // const res = code + op + `#${this.pos++}|` + values.join('|') + '\n';
        return code + op + '|' + values.join('|') + '\n';
    }
    flushStack() {
        let code = '';
        const count = this.#stack.length;
        for(const value of this.#stack) {
            code += '|' + value;
        }
        this.#stack = [];
        if (this.short && count <= 16) {
            return `PUT${count}`+code+'\n';
        }
        return `PUT|${count}` + code + '\n';
    }
    fromTo(fromValue, toValue, delta, times, operation = '+') {
        let count = 0;
        if (toValue === false) {            
            toValue = this.calculateToValue(fromValue, delta, times, operation);
            count = this.paddingSize;
        } else {
            count = this.calculateSingleCount(fromValue, toValue, delta, operation);
        }
        const isGeometric = operation === '*' || operation === '/'; 
        count = times * count;
        if (isGeometric) {
            return [this.put('FROM_TO_GEOM', [fromValue, toValue, delta, times]), count];
        }
        const defaultDelta = this.short && (delta !== 1n || delta !== -1n);
        const defaultTimes = this.short && times === 1n;
        if (defaultDelta) {
            if (defaultTimes) {
                return [this.put('FROM_TO_DELTA_TIMES_1', [fromValue, toValue]), count];
            }
            return [this.put('FROM_TO_DELTA_1', [fromValue, toValue, times]), count];
        } else if (defaultTimes) {
            return [this.put('FROM_TO_TIMES_1', [fromValue, toValue, delta]), count];
        }
        return [this.put('FROM_TO', [fromValue, toValue, delta, times]), count];
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
        let code = '';
        for(const value of e.values) {
            const [_code, _count] = this.insideExecute(value);
            count += _count;
            code += _code;
        }
        return [code, count];
    }
    sequence(e) {
        return this.seqList(e);
    }
    paddingSeq(e) {        
        // TODO: if last element it's a padding, not need to fill and after when access to
        // a position applies an module over index.
        const [code, seqSize] = this.insideExecute(e.value);        
        let remaingValues = this.paddingSize - seqSize;
        if (remaingValues < 0) {
            throw new Error(`In padding range must be space at least for one time sequence [paddingSize(${this.paddingSize}) - seqSize(${seqSize}) = ${remaingValues}] at ${this.debug}`);
        }
        if (seqSize < 1) {
            throw new Error(`Sequence must be at least one element at ${this.debug}`);
        }
        if (remaingValues === 0) {
            return [code, seqSize];
        }
        return [code + (remaingValues > 0 ? this.#getCodeRepeatLastElements(seqSize, remaingValues): ''),
                seqSize + remaingValues];
    }
    #pushElement(value) {
        this.#stack.push(value);
    }
    expr(e) {        
        this.#pushElement(this.e2num(e));
        return ['', 1];
    }
    #getCodeRepeatLastElements(count, rlen) {
        // count is the number of elements sequence to repeat
        // rlen is the number of elements to repeteat (ex: rlen = count * times)
        if (this.short && count === 1) {
            return this.put('REPEAT1', [rlen]);
        }
        return this.put('REPEAT',[count,rlen]);
    }
    repeatSeq(e) {
        const times = Number(this.e2num(e.times));
        const [_code, _count] = this.insideExecute(e.value);
        if (times === 1) {
            return [_code, _count];
        }
        const code = _code + this.#getCodeRepeatLastElements(_count, (times-1) * _count);
        const count = _count * times;
        return [code, count];
    }
}