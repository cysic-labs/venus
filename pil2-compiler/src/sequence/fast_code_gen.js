const Expression = require("../expression.js");
const Debug = require('../debug.js');
const assert = require('../assert.js');
const Context = require('../context.js');
const SequenceBase = require('./base.js');

module.exports = class SequenceFastCodeGen extends SequenceBase {
    fromTo(fromValue, toValue, delta, times, operation = '+') {
        let count = 0;
        let forceBigInt = false;
        if (toValue === false) {
            count = this.paddingSize;
        } else {
            if (operation === '+' || operation === '-') {
                count = this.calculateSingleCount(fromValue, toValue, delta, operation) * times;
            } else {
                // ratio = delta;
                count = operation === '/' ? this.geomCount(toValue, fromValue, delta):
                                            this.geomCount(fromValue, toValue, delta);
                if (this.useFieldElement() && operation === '/') {
                    operation = '*';
                    forceBigInt = true;
                    console.log(delta);
                    delta = Context.Fr.inv(delta);
                    console.log(delta, fromValue, Context.Fr.e(fromValue * delta));
                }
                count = count * times;
            }
        }

        // count % times !== 0
        // this implies no complete loop, loop has two parts if times > 1, part to set value
        // and part to repeat this value. To solve this problematic, most performance solution
        // was make all "complete loops" and after make partial parts of loop, but out of loop
        //
        // partialLoop: this is partial loops, means at least at end need to store value
        // partialRepeat: if times == 1 or remain == 1 no repeats, only sets.

        //                if remain > 1 means that repeat remain times.

        const partialLoop = (times > 1 && count % times) ? true:false;
        const partialRepeat = (times > 1 && (count % times) > 1) ? (count % times) - 1:0;
        const v = this.createCodeVariable('_vkp');

        // if partialSet only complete loops, need to remove the last loop of times elements.
        const loopCount = partialLoop ? count - times : count;

        let code = `// bytes: ${this.bytes} count:${count}\nlet ${v}=` + this.codeValue(fromValue, forceBigInt) + ';\n';
        if (loopCount > 0) {
            const it = this.createCodeVariable('_it');
            const tmp = this.createCodeVariable('_tmp');
            code += `for(let ${it}=0;${it} < ${loopCount};${it}=${it} + ${times}){`;
            // in this case codeConvert without forceBigInt to avoid number conversion
            code += `  ${tmp} = ` + ((forceBigInt && !this.useBigInt()) ? `Number(${v})`:v) + ';';
            code += `  __data[__dindex] = ${tmp};`
            code += `  if (__data[__dindex++] !== ${tmp}) throw new Error(`+'`conversion problem __data[${__dindex-1}](${__data[__dindex-1]}) !== ${'+tmp+'})`);\n';
            if (times > 1) {
                const _code = this.#getCodeRepeatLastElements(1, (times - 1));
                code += _code;
            }
            code += `  ${v} = ` + this.codeConvert(`${v} ${operation} ` + this.codeValue(delta, forceBigInt), forceBigInt) + ';';
            code += '}\n';
        }
        if (partialLoop) {
            code += `  __data[__dindex++] = ${v};`
        }
        if (partialRepeat) {
            code += this.#getCodeRepeatLastElements(1, partialRepeat);
        }
        return [code, count];
    }

    // TODO: integrate this version with change order to do divisions in the other function used, be carrefull
    // with ranges witho
    fromToGeom(fromValue, toValue, ratio, times, reverse = false) {
        // TODO: times = 0 check
        let count;
        if (toValue === false) {
            if (times !== 1 && this.paddingSize % times) {
                throw new Error(`Invalid parameters to geometric serie (from:${fromValue} paddingSize:${this.paddingSize} ratio:${ratio} times:${times}) at ${Context.sourceTag}`)
            }
            count = this.paddingSize / times;
        } else {
            count = reverse ? this.geomCount(toValue, fromValue, ratio):
                              this.geomCount(fromValue, toValue, ratio);
        }
        const v = this.createCodeVariable('_v');
        const it = this.createCodeVariable('_it');
        let code = `let ${v} = ${this.codeValue(reverse?toValue:fromValue)};`;
        const _reverse = reverse && count > 1;
        if (_reverse) {
            // put in last position, ready to write last position and repetitons
            code += `__dindex += ${(count-1) * times};`
        }
        code += `for(let ${it}=0;${it}<${count};++${it}){`;
        code += `  __data[__dindex++] = ${v}; ${v} = ` + this.codeConvert(`${v} * ${this.codeValue(ratio)}`) +';'
        if (times > 1) {
            const _code = this.#getCodeRepeatLastElements(1, times - 1);
            code += _code;
        }
        if (_reverse) {
            // go back, last block of values wrotten, and one more block of values
            // to be write in next loop.
            code += `__dindex -= ${2 * times};`
        }
        code += '}\n';
        if (_reverse) {
            // when exit of the loop are in position "-1", because write position 0 and
            // go back one position
            code += `__dindex += ${(count + 1) * times};`
        }
        return [code, count * times];
    }

    rangeSeq(e) {
        const [fromValue, toValue, times] = this.getRangeSeqInfo(e);
        const delta = fromValue > toValue ? -1n:1n;
        return this.fromTo(fromValue, toValue, delta, times);
    }
    arithSeq(e) {
        const [t1, t2, tn, times] = this.getTermSeqInfo(e);
        this.checkTimes(times);
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
        this.checkTimes(times);
        if (t1 > t2) {
            if (t1 % t2) {
                throw new Error(`Invalid geometric parameters t1:${t1} t2:${t2} tn:${tn} times:${times}`);
            }
            console.log({t1,tn,t2,ratio: t1/t2, times});
            if (this.useFieldElement()) return this.fromTo(t1, tn, t1/t2, times, '/');
            else return this.fromToGeom(t1, tn, t1/t2, times, true);
        }
        if (t2 % t1) {
            throw new Error(`Invalid geometric parameters t1:${t1} t2:${t2} tn:${tn} times:${times}`);
        }
        return this.fromTo(t1, tn, Context.Fr.e(t2/t1), times, '*');
    }
    seqList(e) {
        let count = 0;
        let code = e.values.length > 1 ? '{' : '';
        for(const value of e.values) {
            const [_code, _count] = this.insideExecute(value);
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
        const [_code, seqSize] = this.insideExecute(e.value);
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
            code += this.#getCodeRepeatLastElements(seqSize, remaingValues);
        }
        code += '}\n';
        return [code, seqSize + remaingValues];
    }
    expr(e) {
        // no cache
        const num = Context.Fr.e(this.e2num(e));
        const type = this.bytes === 8 ? 'n' :''
        return [`__data[__dindex++] = ${num}${type};\n`, 1];
    }
    createCodeVariable(prefix = '_i') {
        const index = (this.varIndex ?? 0) + 1;
        this.varIndex = index;
        return prefix + index;
    }
    byBytes(value) {
        if (this.bytes === 1) return value;
        return `(${value}) * ${this.bytes}`
    }
    #getCodeRepeatLastElements(count, rlen) {
        // count is the number of elements sequence to repeat
        // rlen is the number of elements to repeteat (ex: rlen = count * times)
        // data.fill(data.slice(3, 9), 9, 9 + 50000 * 6);
        if (this.bytes === true) {
            let rep = this.createCodeVariable('__rep');
            return `{ for(let ${rep}=0;${rep}<${rlen};++${rep}){__data[__dindex] = __data[__dindex - ${count}]; ++__dindex;}}`;
            // return `__data.splice(__dindex, ${rlen},...__data.slice(__dindex - ${count}, __dindex)); __dindex += ${rlen};`;
        }
        if (this.bytes === 1) {
            return `__dbuf.fill(__dbuf.slice(__dindex - ${count}, __dindex), __dindex, __dindex + ${rlen}); __dindex += ${rlen};`;
        }
        return `__dbuf.fill(__dbuf.slice((__dindex - ${count})*${this.bytes}, __dindex*${this.bytes}),`+
               ` __dindex*${this.bytes}, (__dindex + ${rlen})*${this.bytes}); __dindex += ${rlen};`;
    }
    repeatSeq(e) {
        // TODO, review cache problems.
        // if (!e.__cache) {
        const times = Number(this.e2num(e.times));
        const [_code, _count] = this.insideExecute(e.value);
        if (times === 1) {
            return [_code, _count];
        }
        const v = this.createCodeVariable();
        const code = '{' + _code +';'+this.#getCodeRepeatLastElements(_count, (times-1) * _count) + '}';
        const count = _count * times;
        return [code, count];
        //     e.__cache = [code, count];
        // }
        // return e.__cache;
    }
    genContext() {
        let __dbuf = Buffer.alloc(this.size * this.bytes)
        let context = {__dbuf, __dindex: 0, Fr: Context.Fr};
        switch (this.bytes) {
            case 1: context.__data = new Uint8Array(__dbuf.buffer, 0, this.size); break;
            case 2: context.__data = new Uint16Array(__dbuf.buffer, 0, this.size); break;
            case 4: context.__data = new Uint32Array(__dbuf.buffer, 0, this.size); break;
            case 8: context.__data = new BigUint64Array(__dbuf.buffer, 0, this.size); break;
            default: context.__data = []; break;
        }
        return context;
    }
}