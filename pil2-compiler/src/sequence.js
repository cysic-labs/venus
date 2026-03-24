const Expression = require("./expression.js");
const Values = require('./values.js');
const Debug = require('./debug.js');
const vm = require('vm');
const assert = require('./assert.js');
const Context = require('./context.js');
const SequenceSizeOf = require('./sequence/size_of.js');
const SequenceCodeGen = require('./sequence/code_gen.js');
const SequenceFastCodeGen = require('./sequence/fast_code_gen.js');
const SequenceExtend = require('./sequence/extend.js');
const SequenceToList = require('./sequence/to_list.js');
const SequenceTypeOf = require('./sequence/type_of.js');
const SequenceCompression = require('./sequence/compression.js');
const IntValue = require('./expression_items/int_value.js');
const ExpressionList = require('./expression_items/expression_list.js');
const beautify = require('js-beautify').js;
const Transpiler = require('./transpiler.js');

const MAX_ELEMS_GEOMETRIC_SEQUENCE = 300;
class SequencePadding {
    constructor (value, size) {
        this.value = value;
        this.size = size;
    }
}
module.exports = class Sequence {
    #values;

    static cacheGeomN = [];
    // TODO: Review compiler estructures
    // TODO: iterator of values without "extend"
    // TODO: check repetitive sequences (times must be same)
    // TODO: check arith_seq/geom_seq with repetitive

    constructor (expression, options = {}) {
        this.options = options;
        this.padding = false;
        this.fieldElement = options.fieldElement ?? true;
        this.expression = expression;

        this.maxSize = Number(options.maxSize ?? Context.rows);
        this.paddingCycleSize = false;
        this.paddingSize = 0;
        this.extendPos = 0;
        this.debug = '';
        this.valueCounter = 0;
        this.varIndex = 0;
        this.bytes = 8;         // by default
        const defaultEngineOptions = {set: (index, value) => this.#setValue(index, value),
                                      get: (index) => this.#values[index]};
        this.engines = {
            sizeOf: new SequenceSizeOf(this, 'sizeOf'),
            codeGen: new SequenceFastCodeGen(this, 'codeGen'),
                                                    // : new SequenceCodeGen(this, 'codeGen'),
            extend: new SequenceExtend(this, 'extend', defaultEngineOptions),
            toList: new SequenceToList(this, 'toList', defaultEngineOptions),
            typeOf: new SequenceTypeOf(this, 'typeOf'),
            compression: new SequenceCompression(this, 'compression')
        };
        this.engines.typeOf.execute(this.expression);
        this.sizeOf(this.expression);
        this.#values = new Values(this.bytes, this.size);
    }
    get isSequence () {
        return this.engines.typeOf.isSequence;
    }
    get isList () {
        return this.engines.typeOf.isList;
    }
    clone() {
        let cloned = new Sequence(this.expression, this.options);
        if (Debug.active) console.log(['CLONED', this.options]);
        this.#values.mutable = false;
        cloned.#values = this.#values.clone();
        return cloned;
    }
    getIntValue(index) {
        return this.#values.getValue(index);
    }
    getValue(index) {
        return new IntValue(this.#values.getValue(index));
    }
    #setValue(index, value) {
        ++this.valueCounter;
        return this.#values.__setValue(index, value);
    }
    setValue(index, value) {
        if ((index >= 0 && (this.maxSize === false || index < this.maxSize) === false)) {
            console.log(`\x1B[31m  > ERROR Invalid value of extendPos:${index} maxSize:${this.maxSize}  ${this.debug}\x1B[0m`);
        }
        if (typeof this.#values.getValue(index) !== 'undefined') {
            console.log(`\x1B[31m  > ERROR Rewrite index position:${index} ${this.debug}\x1B[0m`);
        }
        ++this.valueCounter;
        return this.#values.setValue(index, value);
    }
    sizeOf(e) {
        this.paddingCycleSize = false;
        this.paddingSize = 0;
        const size = this.engines.sizeOf.execute(e);
        assert.ok(size >= this.paddingCycleSize, `size(${size}) < paddingCycleSize(${this.paddingCycleSize})`);
        if (Debug.active) {
            console.log(`Sequence(sizeOf) size:${size} maxSize:${this.maxSize} paddingCycleSize:${this.paddingCycleSize} paddingSize:${this.paddingSize}`);
        }
        if (this.paddingCycleSize) {
            this.paddingSize = this.maxSize - (size - this.paddingCycleSize);
            this.size = size - this.paddingCycleSize + this.paddingSize;
        } else {
            this.size = size;
        }
        this.engines.sizeOf.updateMaxSizeWithPadingSize(this.paddingSize);
        this.bytes = 8; // this.engines.sizeOf.getMaxBytes();
        return this.size;
    }
    toList() {
        this.engines.toList.execute(this.expression);
        return new ExpressionList(this.engines.toList.getValues());
    }
    setPaddingSize(size) {
        if (this.maxSize === false) {
            throw new Error(`Invalid padding sequence without maxSize at ${Context.sourceTag}`);
        }
        if (this.paddingCycleSize !== false) {
            throw new Error(`Invalid padding sequence, previous padding sequence already has been specified at ${Context.sourceTag}`);
        }
        this.paddingCycleSize = size;
        return this.paddingCycleSize;
    }
    extend() {
        if (Debug.active) console.log(this.size);
        if (Context.config.logCompress) {
            console.log(this.engines.compression.execute(this.expression)[0]);
        }
        this.extendPos = 0;
        let [code, count] = this.engines.codeGen.execute(this.expression);
        if (Context.config.logTranspiledSequences) {
            code = beautify(code, {wrap_line_length: 160});
            code = `// bytes:${this.bytes === true ? 'bigint':this.bytes} at ${Context.sourceTag}\n` + code;
            Transpiler.dumpCode(code);
        }
        const context = {...this.engines.codeGen.genContext(), __log: function () { console.log.apply(null, arguments)}};
        vm.createContext(context);
        vm.runInContext(code, context);
        this.#values.__setValues(context.__dbuf, context.__data);
        this.#values.mutable = false;
    }
    verify() {
        if (!assert.isEnabled) return;

        if (Debug.active) {
            console.log(this.toString());
            console.log([this.extendPos, this.size]);
            console.log(['SIZE', this.size]);
        }
        assert.strictEqual(this.valueCounter, this.size);
        for (let index = 0; index < size; ++index) {
            assert.typeOf(this.values[index], 'bigint', `type of index ${index} not bigint (${typeof this.values[index]}) ${value}`);
        }
    }
    toString() {
        return this.#values.toString();
    }
    getValues() {
        return this.#values.getValues();
    }
    getBuffer() {
        return this.#values.getBuffer();
    }
}