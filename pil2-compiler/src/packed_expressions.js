const util = require('util');
const assert = require('./assert.js');

const OPERATOR_SYMBOLS = {mul: '*', add: '+', sub:'-', neg:'-'};
const VALID_OBJ_TYPES = ['constant','challenge','airGroupValue','proofValue','publicValue','periodicCol','fixedCol','witnessCol','customCol', 'expression'];
module.exports = class PackedExpressions {

    constructor () {
        this.expressions = [];
        this.values = [];
        this.references = [];
        this.expressionLabels = [];
        this.appliesRowOffset = [];
    }
    setAppliesRowOffset(id, appliesRowOffset) {
        this.appliesRowOffset[id] = appliesRowOffset;
    }
    insert(expr) {
        return this.expressions.push(expr) - 1;
    }
    insertTop() {
        return this.insert({add: {lhs: this.pop(1)[0], rhs:{constant: {value : 0n}}}});
    }
    pop(count, operation = false) {
        if (this.values.length < count) {
            throw new Error(`Not enought elements (${this.values.length} vs ${count}) for operation ${operation}`);
        }
        return this.values.splice(-count, count);
    }
    mul() {
        const [lhs, rhs] = this.pop(2, 'mul');
        return this.insert({mul: {lhs, rhs}});
    }

    add() {
        const [lhs, rhs] = this.pop(2, 'add');
        return this.insert({add: {lhs, rhs}});
    }
    sub() {
        const [lhs, rhs] = this.pop(2, 'sub');
        return this.insert({sub: {lhs, rhs}});
    }
    neg() {
        const [value] = this.pop(1, 'neg');
        return this.insert({neg: {value}});
    }
    push(obj) {
        if (assert.isEnabled) assert.ok(VALID_OBJ_TYPES.includes(Object.keys(obj)[0]));
        this.values.push(obj);
    }
    pushConstant (value) {
        this.values.push({constant: {value}});
    }
    pushChallenge (idx, stage = 1) {
        assert.defined(idx);
        this.values.push({challenge: {stage, idx}});
    }
    pushAirGroupValue (idx, airGroupId) {
        assert.defined(idx);
        this.values.push({airGroupValue: {idx, airGroupId}});
    }
    pushAirValue (idx) {
        assert.defined(idx);
        this.values.push({airValue: {idx}});
    }
    pushProofValue (idx, stage = 1) {
        assert.defined(idx);
        this.values.push({proofValue: {stage, idx}});
    }
    pushPublicValue (idx) {
        assert.defined(idx);
        this.values.push({publicValue: {idx}});
    }
    pushPeriodicCol (idx, rowOffset = 0) {
        assert.defined(idx);
        this.values.push({periodicCol: {idx, rowOffset}});
    }
    pushFixedCol (idx, rowOffset = 0) {
        assert.defined(idx);
        this.values.push({fixedCol: {idx, rowOffset}});
    }
    pushWitnessCol (colIdx, rowOffset = 0, stage = 1) {
        assert.defined(colIdx);
        this.values.push({witnessCol: {colIdx, rowOffset, stage}});
    }
    pushCustomCol (colIdx, rowOffset = 0, stage = 0) {
        assert.defined(colIdx);
        this.values.push({customCol: {colIdx, rowOffset, stage}});
    }
    pushExpression (idx) {
        assert.defined(idx);
        this.values.push({expression: {idx}});
    }
    getReferenceKey(id, rowOffset = 0) {
        return rowOffset ? (rowOffset > 0 ? `im_${id}+${rowOffset}` : `im_${id}${rowOffset}`) : `im_${id}`;
    }
    // Returns the expression reference by id only if applies row offset, otherwise returns false.
    getExpressionReference (id) {
        let key = this.getReferenceKey(id, 0);
        if (typeof this.references[key] === 'undefined') {
            return false;
        }
        const res = this.references[key];
        return this.appliesRowOffset[id] ? res : false;
    }
    pushExpressionReference (id, rowOffset = 0) {
        let key = this.getReferenceKey(id, rowOffset);
        if (typeof this.references[key] === 'undefined') {
            return false;
        }
        this.pushExpression(this.references[key]);
        return true;
    }
    saveAndPushExpressionReference(id, rowOffset, label, res) {
        const key = this.getReferenceKey(id, rowOffset);
        if (typeof this.references[key] === 'undefined') {        
            this.references[key] = res;
            const _label = this.rowOffsetToString(rowOffset, label);
            this.expressionLabels[res] = _label;
        }
        this.pushExpression(res);
    }
    dump() {
        console.log(util.inspect(this.expressions, false, null, true /* enable colors */));
    }
    exprToString(id, options) {
        assert.typeOf(id, 'number');
        if (typeof this.expressionLabels[id] !== 'undefined') {
            return this.expressionLabels[id];
        }
        const expr = this.expressions[id];
        if (!expr) {
            console.log(expr);
            debugger;
        }
        const [op] = Object.keys(expr);
        let opes = [];
        for (const ope of Object.values(expr[op])) {
            opes.push(this.operandToString(ope, options));
        }

        if (opes.length == 1) {
            return `${OPERATOR_SYMBOLS[op]}${opes[0]}`;
        }
        return opes.join(OPERATOR_SYMBOLS[op]);
    }
    rowOffsetToString(rowOffset, e) {
        if (rowOffset < 0) {
            return (rowOffset < -1 ? `${-rowOffset}'${e}` : `'${e}`);
        }
        if (rowOffset > 0) {
            return (rowOffset > 1 ? `${e}'${-rowOffset}` : `${e}'`);
        }
        return e;
    }
    operandToString(ope, options) {
        const [type] = Object.keys(ope);
        const props = ope[type];
        switch (type) {
            case 'constant':
                return ope.constant.value;

            case 'fixedCol':
                return this.rowOffsetToString(props.rowOffset, this.getLabel('fixed', props.idx, options));

            case 'witnessCol':
                return this.rowOffsetToString(props.rowOffset, this.getLabel('witness', props.colIdx, options));

            case 'customCol':
                return this.rowOffsetToString(props.rowOffset, this.getLabel('customcol', props.colIdx, options));

            case 'publicValue':
                return this.getLabel('public', props.idx, options);

            case 'expression':
                return '('+this.exprToString(props.idx, options)+')';

            case 'challenge':
                return this.getLabel('challenge', props.idx, options);

            case 'airGroupValue':
                return this.getLabel('airgroupvalue', props.idx, options);

            case 'airValue':
                return this.getLabel('airvalue', props.idx, options);

            case 'proofValue':
                return this.getLabel('proofvalue', props.idx, options);

            default:
                console.log(ope);
                throw new Error(`Invalid type ${type}`)
        }

    }
    getLabel(type, id, options = {}) {
        const labelSources = [(options.labelsByType ?? {})[type], options.labels];
        let args = [id, options];
        for (const labels of labelSources) {
            if (labels) {
                if (typeof labels === 'function') {
                    return labels.apply(null, args);
                }
                if (typeof labels.getLabel === 'function') {
                    return labels.getLabel.apply(labels, args);
                }
            }
            args.unshift(type);
        }
        return label = `${type}@${id}`;
    }

    *[Symbol.iterator]() {
        for (let index = 0; index < this.expressions.length; ++index) {
          yield this.expressions[index];
        }
    }

}
