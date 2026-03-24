const util = require('util');
const {cloneDeep} = require('lodash');
const ExpressionOperationsInfo = require('./expression_operations_info.js');
const NonRuntimeEvaluable = require('./non_runtime_evaluable.js');
const ExpressionItems = require("./expression_items.js");
const ExpressionItem = ExpressionItems.ExpressionItem;
const ExpressionOperatorMethods = require('./expression_operator_methods.js');
const Context = require('./context.js');
const OP_VALUE = 'value';
const OP_ID_REF = 'idref';
const OP_STACK = 'stack';
const OP_RUNTIME = 'runtime';
const NATIVE_REFS = ['witness', 'fixed', 'public', 'challenge', 'airgroupvalue', 'proofvalue', 'publictable'];
const NATIVE_OPS = ['add', 'sub', 'mul', 'neg'];
const VALID_NATIVE_OPS = [false, ...NATIVE_OPS];
const Exceptions = require('./exceptions.js');
const ExpressionPacker = require('./expression_packer.js');
const ExpressionClass = require('./expression_class.js');
const ExpressionList = require('./expression_items/expression_list.js');
const Debug = require('./debug.js');
const Types = require('./types.js');
const TranslationTable = require('./expression/translation_table.js');
const assert = require('./assert.js');
// TODO: StackPos as class


class Expression extends ExpressionItem {


    // op (string)
    // operands (array)

    // op_type --> (OP_CONST, OP_NAME_REF, OP_ID_REF, OP_STACK)
    // name (string)
    // indexes (array) --> be carrefull with clone
    // value (bingint)
    // offset (number)

    static evaluatedGlobalId = 1000000;
    static operatorsToMethodCache = {};
    static operators = ExpressionOperatorMethods;
    static unitaryOperators = ExpressionOperationsInfo.getUnitaryOperations();
    static context;

    constructor (value) {
        super();
        this.stack = [];
        this.fixedRowAccess = false;
        if (assert.isEnabled) {
            this.assertIsAlone = () => assert.ok(this.isAlone());
            this.assertExpressionItem = (value, info) => this._assertExpressionItem(value, info);
        } else {
            this.assertIsAlone = () => {};
            this.assertExpressionItem = (value) => value;
        }
        if (typeof value !== 'undefined') {
            this._set(value);
        }
    }
    get degree() {
        if (this.isAlone()) {
            return this.getAloneOperand().degree;
        }
        if (this.stack.length === 0) {
            return -1;
        }
        return this.stackPosDegree(this.stack.length - 1);
    }
    get reference() {
        if (!this.isAlone()) return false;
        const operand = this.getAloneOperand();
        return operand instanceof ExpressionItems.ReferenceItem ? operand : false;
    }
    _assertExpressionItem(value, info) {
        assert.strictEqual(value instanceof ExpressionList, false);
        return assert.returnInstanceOf(value, ExpressionItem, info);
    }
    static createFrom(object) {
        const res = new Expression();
        res._set(object);
        return res;
    }
    get isExpression() {
        return true;
    }
    get name() {
        if (this.isAlone()) {
            const operand = this.getAloneOperand();
            return operand.name || false;
        }
        return false;
    }
    cloneInstance() {
        let cloned = new Expression();
        cloned.fixedRowAccess = this.fixedRowAccess;
        cloned.pushStack(this);
        return cloned;
    }
    emptyClone() {
        return new Expression();
    }

    pushStack(e) {
        assert.instanceOf(e, Expression, {e, msg:'pushStack parameter must be an Expression'});

        const count = e.stack.length;
        for (let index = 0; index < count; ++index) {
            let stackPos = e.stack[index];
            let clonedStackPos = this.cloneStackPos(stackPos);
            this.stack.push(clonedStackPos);
        }
        return count;
    }
    cloneStackPos(stackPos) {
        if (Debug.active) console.log(stackPos);
        return { op: stackPos.op,
                 operands: stackPos.operands.map(operand => this.assertExpressionItem(operand.clone()))};
    }

    applyNext(value) {
        this.stack.map(stack => stack.operands.map(operand => assert.returnInstanceOf(operand.applyNext(value), 'ExpressionItem')));
        return this;
    }

    insertStack(expressionToInsert, stackIndex) {
        assert.instanceOf(expressionToInsert, Expression);
        const delta = expressionToInsert.stack.length;

        //
        // Example1:                       Example2:
        //   Insert D on stackIndex = 0     Insert D on stackIndex = 1
        //
        //                   | C |             |   |       | C |
        //       | C |       | B |             | C |       | B |
        //       | B | ----> | A |             | B | ----> | D |
        //       | A | (D,0) | D |             | A | (D,1) | A |
        //       └───┘       └───┘             └───┘       └───┘
        //
        //
        //   length-1 ┌───────┐ ┐
        //            │       │ │ moved-block (stackIndex, length - 1)
        //            ├───────┤ ┘
        //            │       │ <--- expressionToInsert
        //            │       │        (delta positions)
        // stackIndex |───────┤ ┐
        //            │       │ │ non-moved-block (0 .. stackIndex - 1)
        //          0 └───────┘ ┘
        //

        // All stack references use relative offsets (absolute = current_pos - offset).
        // Loop over stack references of moved-block to update stack references that
        // reference an non-moved-block element. This offset must be increased in delta
        // positions (size of expression inserted)

        for (let index = stackIndex; index < this.stack.length; ++index) {
            for (const operand of this.stack[index].operands) {
                if (operand instanceof ExpressionItems.StackItem === false) continue;
                const offset = operand.getOffset();
                if ((index - offset) < stackIndex) {
                    operand.setOffset(offset + delta);
                }
            }
        }

        //
        //                           _  ┌───────┐ ┐
        //                          /   │   B   │ │ moved-block
        //                         /    ├───────┤ ┘
        //   length-1 ┌───────┐   /     │       │
        //            │   B   │  /      │       │
        // stackIndex |───────┤         |───────┤ ┐
        //            │   A   │  -----  │   A   │ │ non-moved-block
        //          0 └───────┘         └───────┘ ┘
        //

        // moving B to leave space to insert expression
        for (let index = this.stack.length - 1; index >= stackIndex; --index) {
            this.stack[index + delta] = this.stack[index];
        }

        // clone and copy stack elements of expression to insert
        for (let index = 0; index < delta; ++index) {
            this.stack[index + stackIndex] = this.cloneStackPos(expressionToInsert.stack[index]);
        }

        // TO REVIEW
        this.fixedRowAccess = this.fixedRowAccess || expressionToInsert.fixedRowAccess;
        return 1;
    }
    cloneAlone() {
        return this.assertExpressionItem(this.stack[0].operands[0].clone());
    }
    isAlone () {
        return this.stack.length === 1 && this.stack[0].op === false;
    }
    pushAloneIndex(index) {
        this.assertIsAlone();
        let operand = this.getAloneOperand().pushArrayIndex(index);
    }
    popAloneIndex() {
        this.assertIsAlone();
        return this.getAloneOperand().popArrayIndex(index);
    }

    getAloneOperand () {
        return this.stack[0].operands[0];
    }
    getAlone () {
        return this.isAlone() ? this.getAloneOperand() : false;
    }
    cloneAloneOperand () {
        return this.getAloneOperand().clone();
    }

    isReference () {
        // TODO: review if best place?
        // TODO: review if next/prior
        // return (this.isAlone() && this.stack[0].operands[0].type === OP_RUNTIME && this.stack[0].operands[0].op === 'reference' );
        return (this.isAlone() && this.stack[0].operands[0] instanceof ExpressionItems.ReferenceItem);
    }
    _set (operand) {
        if (this.stack.length) {
            throw new Error(`Set only could be used with empty stack`);
        }
        this.stack.push({op: false, operands: [this.assertExpressionItem(operand.clone())]});
    }
    insertOperation(op, operands) {
        if (this.stack.length) {
            throw new Error(`insertOperation only could be used with empty stack`);
        }
        // this operation doesn't clone operands
        this.stack.push({op, operands});
    }
    isRuntime () {
        return this.stack.some(st => this.isRuntimeStackPos(st));
    }
    isRuntimeStackPos(st) {
        return ((st.op !== false &&  NATIVE_OPS.indexOf(st.op) < 0) || st.operands.some(operand  => operand instanceof ExpressionItems.RuntimeItem));
    }
    insertOne (op, b = false) {
        if (Debug.active) console.log(`\x1B[44m======================== INSERT ONE (${op}) =================================\x1B[0m`);
        if (Debug.active) console.log(util.inspect(b, false, null, true));
        if (assert.isEnabled) assert.ok(b === false || b instanceof Expression);
        const aIsEmpty = this.stack.length === 0;
        const bIsEmpty = b === false || b.stack.length === 0;

        if (bIsEmpty && Expression.unitaryOperators.includes(op) === false ) {
            throw new Error(`insert without operands`);
        }
        const aIsAlone = this.isAlone();
        const bIsAlone = b === false || b.isAlone();
        if (bIsAlone) {    // aIsAlone => !aIsEmpty
            if (aIsAlone) {
                this.stack[0].op = op;
                // if b is false => unary operand, no second operand to add
                if (b !== false) {
                    this.stack[0].operands.push(b.cloneAlone());
                }
                return this;
            }
            // let operandA = aIsEmpty ? [] : [{type: OP_STACK, offset: 1}];
            // this.stack.push({op, operands: [...operandA, b.cloneAlone()]});
            let operandA = aIsEmpty ? [] : [new ExpressionItems.StackItem(1)];

            const stackPos = {op, operands: operandA};
            // if b is false => unary operand, no second operand to add
            if (b !== false) {
                stackPos.operands.push(b.cloneAlone());
            }
            this.stack.push(stackPos);
            return this;
        }

        // !aIsAlone (aIsEmpty?) && !bIsAlone
        const count = this.pushStack(b);
        if (aIsEmpty) {
            this.stack.push({op, operands: [new ExpressionItems.StackItem(1)]});
            return this;
        }
        this.stack.push({op, operands: [new ExpressionItems.StackItem(count + 1), new ExpressionItems.StackItem(1)]});
        return this;
    }

    insert (op, bs) {
        if (Debug.active) console.log(`\x1B[41m======================== INSERT (${op}) =================================\x1B[0m`);
        if (Debug.active) this.dump();
        if (Debug.active) console.log(util.inspect(bs, false, null, true));
        if (!Array.isArray(bs)) {
            const res = this.insertOne(op, bs);
            if (Debug.active) res.dump();
            return res;
        }
        if (bs.length === 1) {
            const res = this.insertOne(op, bs[0]);
            if (Debug.active) res.dump();
            return res;
        }
        // verify that all bs are expressions
        if (assert.isEnabled) {
            assert.ok(bs.reduce((isExpression, b) => isExpression && b instanceof Expression, true));
        }

        // console.log(bs);
        const anyEmptyB = bs.some((b) => b.stack.length === 0);
        const aIsEmpty = this.stack.length === 0;

        // this.runtime = this.runtime || NATIVE_OPS.indexOf(op) < 0 || bs.some((b) => b.runtime);

        if (anyEmptyB) {
            throw new Error(`insert without operands`);
        }
        const aIsAlone = this.isAlone();
        const allBsAreAlone = bs.reduce((res, b) => res && b.isAlone(), true);

        let elem = {op, operands: []};
        if (aIsAlone && allBsAreAlone) {
            this.stack[0].op = op;
            for (const b of bs) {
                this.stack[0].operands.push(b.cloneAlone());
            }
            return this;
        }

        // calculate array with rows added for each operand
        let stackRows = [];
        let baseStackOffset = 0;
        for (const b of bs) {
            const count = b.isAlone() ? 0 : this.pushStack(b);
            stackRows.push(count);
            baseStackOffset += count;
        }

        // The previous top of stack has offset = baseStackOffset + 1
        if (!aIsEmpty) {
            elem = {op, operands: [new ExpressionItems.StackItem(baseStackOffset+1)]};
        }

        // calculate relative offsets using baseStackOffset and elements added for
        // each operator, added 1 because first offset is 1 (position -1)
        let stackOffsets = [];
        for (let index = 0; index < stackRows.length; ++index) {
            stackOffsets[index] = baseStackOffset - stackRows[index] + 1;
            baseStackOffset -= stackRows[index];
        }

        let index = 0;
        for (const b of bs) {
            elem.operands.push(b.isAlone() ? b.cloneAlone() : new ExpressionItems.StackItem(stackOffsets[index]));
            ++index;
        }
        this.stack.push(elem);
        return this;
    }
    evaluateAloneReference() {
        if (Debug.active) this.dump();
        this.assertIsAlone();
        let operand = this.getAloneOperand();
        if (operand instanceof ExpressionItems.RuntimeItem || operand instanceof ExpressionItems.ReferenceItem) {
            if (Debug.active) console.log(operand);
            const res = operand.eval();
            if (Debug.active) {
                console.log(res);
                console.log(operand.toString());
                console.log(this.toString());
            }
            return res;
        }
        return operand;
    }
    evaluateRuntime(op, deeply = false) {
        let res = Context.expressions.evalRuntime(op, this, deeply);
        return res;
    }
    getReference() {
        if (!this.isAlone()) {
            throw new Error(`Invalid expression by reference`);
        }
        let dope = this.cloneAloneOperand();
        if (dope.next || dope.prior) {
            throw new Error(`Invalid expression by reference`);
        }
        this.evaluateIndexes(dope);
        return dope;
    }
    get isArray() {
        // only a reference could be and array.
        if (!this.isAlone()) return false;
        const operand = this.getAloneOperand();
        if (operand.rowOffset) return false;
        return operand.isArray;
    }
    // stackResults[pos][0] contains result of this stack position,
    // in stackResults[pos][1] contains a results array of this stack position operands
    instance(options) {
        assert.ok(this.stack.length > 0);
        let cloned = this.clone();
        options = {...options, instance: true}
        let stackResults = options.stackResults ?? cloned.evaluateOperands(options);
        // cloned.extendExpressions(options);
        cloned.evaluateFullStack(stackResults, options);
        if (Debug.active) cloned.dump('PRE-SIMPLIFY');
        cloned.simplify();
        if (Debug.active) cloned.dump('POST-SIMPLIFY');
        // next lines was commented at 21/03/2024
        if (options.unroll) {
            return cloned.unroll();
        }
        if (options.unpackItem && cloned.isAlone()) {
            const operand = cloned.getAloneOperand();
            if (operand instanceof ExpressionItem) {
                return operand;
            }
        }
        // console.log(stackResults);
        // cloned.dumpStackResults(stackResults, '');
        return cloned;
    }
    isInstanceOf(cls) {
        if (!this.isAlone()) return false;

        const operand = this.getAloneOperand();
        return (operand instanceof cls);
    }
    unroll(options) {
        if (!this.isAlone()) return this;

        const operand = this.getAloneOperand();
        if (operand instanceof ExpressionItems.ArrayOf === false) return this;

        return operand.toArrays();
    }
    evalAsValue(options) {
        let res = this.eval(options);
        if (res.isAlone()) {
            res = res.getAloneOperand();
        }
        return (res instanceof ExpressionItems.ValueItem || res instanceof ExpressionItems.StringValue) ? res : ExpressionItems.NonRuntimeEvaluableItem.get();
    }
    eval(options = {}) {
        assert.ok(this.stack.length > 0);
        if (this.stack.length === 0) {
            return this;
        }
        let stackResults = this.evaluateOperands(options);
        this.evaluateFullStack(stackResults, options);
        const res = stackResults[this.stack.length-1][0];
        if (!options.onlyAsValue && res instanceof ExpressionItems.NonRuntimeEvaluableItem) {
            return this.instance({...options, stackResults});
        }
        return res;
    }
    stackResultsToString(stackResults) {
        return stackResults.map((x, index) => `#${index} ${x[0] ?? 'null'} ${x[1].map(o => o ? o.toString() : o).join(',')}`).reverse().join('\n');
    }
    evaluateFullStack(stackResults, options) {
        assert.ok(this.stack.length > 0);
        const evaluateId = Expression.evaluatedGlobalId++;
        if (Debug.active) this.dump(`evaluateFullStack #${evaluateId} MIDDLE`);
        this.evaluateStackPos(stackResults, this.stack.length - 1, {...options, evaluateId});
        if (Debug.active) this.dump(`evaluateFullStack #${evaluateId} END`);
    }
    evaluateStackPos(stackResults, stackIndex, options = {}) {
        assert.ok(stackIndex < this.stack.length);
        const st = this.stack[stackIndex];
        const results = stackResults[stackIndex];
        const _debugLabel = `#${options.evaluateId ?? 0} S${stackIndex}(${st.op})`;

        // if stackResult is evaluated return value;
        if (results[0] !== null) {
            if (Debug.active) console.log(`evaluateStackPos ${_debugLabel}`, results[0]);
            return results[0];
        }

        let values = results[1].slice(0, st.operands.length);
        for (let operandIndex = 0; operandIndex < st.operands.length; ++operandIndex) {
            const _operandDebugLabel = `${_debugLabel} ${operandIndex}]`;
            // console.log(_operandDebugLabel, operandIndex, st.operands)
            const operand = st.operands[operandIndex];
            if (assert.isEnabled) {
                assert.instanceOf(operand, ExpressionItem, [st.op, st.operands.length, operand]);
            }
            const resultAvailable = (values[operandIndex] ?? null) != null;
            if (resultAvailable) {
                if (Debug.active) console.log(`evaluateStackPos ${_operandDebugLabel} ${values[operandIndex]}`)
                continue;
            }

            if (operand instanceof ExpressionItems.StackItem) {
                values[operandIndex] = this.evaluateStackPos(stackResults, stackIndex - operand.getOffset());
                if (Debug.active) console.log(`evaluateStackPos STACK ${_operandDebugLabel} ${values[operandIndex]} ${stackIndex - operand.getOffset()}`, stackResults);
            } else {
                values[operandIndex] = operand.eval(options);
                if (Debug.active) console.log(`evaluateStackPos NO-STACK ${_operandDebugLabel} ${values[operandIndex]}`, operand);
            }
        }
        if (Debug.active) this.dump(`evaluateStackPos #${stackIndex} #${options.evaluateId ?? 0}`);
        let value = null;
        let branch = 0;
        if (values.some(value => value instanceof ExpressionItems.NonRuntimeEvaluableItem))  {
            branch = 1;
            value = this.evalNonRuntimeOperands(st.op, values);
        } else if (values.some(value => value === null))  {
            branch = 2;
            value = null;
            this.dump('value=null '+Context.sourceRef);
        } else if (st.op === false) {
            branch = 3;
            value = values[0];
        } else if (values.some(value => value.isRuntimeEvaluable() === false)) {
            branch = 4;
            value = this.evalNonRuntimeOperands(st.op, values);
        } else {
            branch = 5;
            // values.forEach(x => {if (x.dump) x.dump()});
            value = this.applyOperation(st.op, values);
        }

        assert.notTypeOf(value, 'undefined', `invalid value undefined with branch ${branch}`);

        if (value !== null && !(value instanceof ExpressionItems.NonRuntimeEvaluableItem)) {
            if (value instanceof Expression && !value.isAlone()) {
                value = ExpressionItems.NonRuntimeEvaluableItem.get();
            } else {
                if (typeof value.getAloneOperand !== 'function') {
                    console.log(value.getAloneOperand);
                }
                value = this.assertExpressionItem(value.getAloneOperand());
                if (options.instance) {
                    st.op = false;
                    st.operands = [value];
                }
            }
        }
        return (results[0] = value);
    }
    evalNonRuntimeOperands(operation, values) {
        // a runtime-evaluable item was always different of non-runtime-evaluable on compilation-time
        // check if at least one value is runtime-evaluable.
        if (operation === 'eq' || operation === 'ne') {
            if (values.some(value => value.isRuntimeEvaluable())) {
                return new ExpressionItems.IntValue(operation === 'ne' ? 1n:0n);
            }
            return this.applyOperation(operation, values);

        }
        return ExpressionItems.NonRuntimeEvaluableItem.get();
    }
    /**
     * get method name used to calculate an operation between types.
     * @param {string} operation - operation to apply on operators
     * @param {string[]|false} types - types of operators
     * */
    operatorToMethod(operation, types = false) {
        const key = 'operator_' + operation + (types === false ? '' : '_' +types.slice(1).join('_'));
        let method = Expression.operatorsToMethodCache[key];
        if (!method) {
            method = key.replace(/(\_\w)/g, x => x[1].toUpperCase());
            Expression.operatorsToMethodCache[key] = method;
        }
        return method;
    }
    /**
     * apply operation over operands values
     * @param {string} operation - operation to apply on operators
     * @param {string[]|false} values - array of ExpressionItems
     * */
    applyOperation(operation, values, options = {}) {
        let _values = values;
        if (Debug.active) console.log([operation, ..._values]);
        if (operation === 'if') {
            return this.applyOperationIf(_values);
        }

        const operationInfo = ExpressionOperationsInfo.get(operation);

        if (operationInfo === false) {
            console.log(_values);
            throw new Error(`Operation ${operation} not was defined`);
        }

        if (operationInfo.args !== _values.length) {
            throw new Error(`Invalid number of arguments on operation ${operation}, received ${_values.length} values but was expected ${operationInfo.args}`);
        }


        let types = [];
        let methods = [];
        for (let round = 0; round < 2; ++round) {
            if (round === 1) {
                _values = _values.map(value => this.assertExpressionItem(value.eval({unroll: true})));
                /* TODO: detect value not change after unroll
                const _types = types;
                types = values.map(x => x.constructor.name);
                if (types.every((t,i) => _types[i] === t)) {
                    continue;
                }
                */
            }
            // assert all values must be an ExpressionItem
            if (assert.isEnabled) {
                _values.forEach(value => assert.instanceOf(value, ExpressionItem));
            }

            types = _values.map(x => x.constructor.name);

            // if number of values was less than 2 (means 1, always was equals)
            const equals = _values.length < 2 ? true : types.every(x => x === types[0]);
            let reversed = false;
            const onlyOneLoop = equals || !operationInfo.commutative || operationInfo.args != 2;

            // In this block try to found and operator method using types without transformations.
            // First search on class of first operand, if not found search on class of second operand (*)
            // (*) only if two operands and operation is commutative

            while (true) {
                const method = this.operatorToMethod(operation,  (equals ? false : types));
                methods.push(`#${round} ${types[0]}.${method}`);
                const [executed, result] = this.applyOperatorMethod(method, _values);
                if (executed) {
                    return result;
                }
                if (onlyOneLoop) {
                    break;
                }
                // onlyOneLoop === false => two loops, on second loop applies reverse again to
                // restore original values and types, also restore value of reversed
                _values = _values.reverse();
                types = types.reverse();
                reversed = !reversed;
                if (reversed == false) {
                    break;
                }
            }

            // If not equals, in this block try to cast second operand to class of first operand, after that
            // First search on class of first operand, if not found, try to cast first operand to class of second
            // operand and search on class of second operand (*)
            // (*) only if two operands and operation is commutative
            let iarg = 0;
            while (!equals && operationInfo.args == 2 && iarg < operationInfo.args) {
                const casting = this.castingItemMethod(types[iarg]);
                methods.push(casting);
                const icasting = iarg ? 0:1;
                if (typeof _values[icasting][casting] === 'function') {
                    const method = this.operatorToMethod(operation);
                    methods.push(`> ${types[iarg]}.${method}`);
                    try {
                        const [executed, result] = this.applyOperatorMethod(method, _values.map((x, index) => index === icasting ? x[casting](): x));
                        if (executed) {
                            return result;
                        }
                    }
                    catch (e) {
                        if (e instanceof Exceptions.CannotBeCastToType === false) {
                            throw e;
                        }
                    }
                }
                ++iarg;
            }
        }
        const labels = _values.map(x => x.label ?? '').join(',');
        throw new Error(`Operation ${operation} for (${labels}) not was defined by types ${types.join(',')} [${methods.join(', ')}] at ${Context.sourceRef}`);
    }
    applyOperationIf(values) {
        if (values.length !== 3) {
            throw new Error(`Invalid number of arguments on operation if, received ${values.length} values but was expected 3`);
        }
        const cond = values[0].asBool();
        return values[cond ? 1 : 2].eval();
    }
    castingItemMethod(type) {
        if (type === 'StringValue' || type === 'IntValue') {
            type = type.slice(0, -5);
        }
        return 'as'+type+'Item';
    }
    applyOperatorMethod (method, values) {
        let res = null;
        // console.log(`\x1B[1;36m########### (${values[0].constructor.name}) METHOD ${method} ###########\x1B[0m`);
        if (typeof values[0][method] === 'function') {
            // instance call, first value (operand) is "this", arguments rest of values (operands)
            res = values[0][method](...values.slice(1));
            if (res !== null) return [true, res];
        }
        if (values[0].constructor.operators && typeof values[0].constructor.operators[method] === 'function') {
            // static call with all values (operands)
            res = values[0].constructor.operators[method](...values);
            if (res !== null) return [true, res];
        }
        return [false, false];
    }
    evaluateValue(value, options) {
        if (Debug.active) console.log(value);
        if (typeof value === 'undefined') {
            return options ? options.default ?? 0n : 0n;
        }
        // stack references not replaced
        // expression references not extended (inserted)
        /* console.log([typeof value, value]);
        if (value instanceof Expression) {
            value.dump();
        }*/
        assert.instanceOf(value, ExpressionItems.ExpressionItem);
        if (value instanceof ExpressionItems.StackItem) {
            return value;
        } else if (value instanceof ExpressionItems.ValueItem) {
            return value;
        } else if (value instanceof ExpressionItems.ProofItem) {
            return ExpressionItems.NonRuntimeEvaluableItem.get();
        } else if (value instanceof ExpressionItems.ReferenceItem) {
            const res = Context.runtime.eval(value, {});
            return res;
        } else if (value instanceof ExpressionItems.FunctionCall) {
            const res = value.eval();
            return res;
        } else {
            console.log(value);
            return value;
            EXIT_HERE;
        }
        return value;
    }
    evaluateValues(values, options) {
        // do array of evaluates, for example to evaluate
        // indexes o call arguments, this method call n times
        // evaluations
        if (typeof values === 'undefined') {
            return 0;
        }
        assert.ok3(Array.isArray(values));
        let result = [];
        for (const value of values) {
            result.push(this.evaluateValue(value, options));
        }
        return result;
    }
    evalAsInt(options = {}) {
        let value = this.evalAsValue(options);
        if (value instanceof ExpressionItems.NonRuntimeEvaluableItem) {
            value = this.evalAsValue(options);
        }
        if (Debug.active) {
            console.log(value);
            console.log(this.dump());
        }
        const res = typeof value.asIntDefault === 'function' ? value.asIntDefault(false) : false;
        if (res === false) {
            console.log(value);
            throw new Error(this.toString() + " cannot evaluated as a integer");
        }
        return res;
    }
    evalAsBool(options = {}) {
        return this.evalAsInt(options) ? true : false;
    }
    evalAsItem(options) {
        const res = this.eval(options);
        return res.isAlone() && typeof res.cloneAloneOperand === 'function' ? res.cloneAloneOperand() : res;
    }
    getArrayResult(results, indexes, options) {
        if (Debug.active) {
            console.log(results);
            console.log(indexes);
        }
        // TODO
        return results;
        // this method take one of results using indexes
    }
    evaluateOperand(operand, options){
        const _options = {...options, unroll: true};

        let result = operand.eval(_options);
        let updated = true;
        while (result && updated && !result.const) {
            updated = false;
            while (result && result.isReferencedType && !result.const) {
                result = result.eval();
                updated = true;
            }
            while (result && result instanceof Expression && result.isAlone() && !result.const) {
                result = result.getAloneOperand();
                updated = true;
            }
        }

        if (typeof result === 'undefined') {
            throw new Error(`Invalid result of operand ${operand}`);
        }
        return result;
    }
    evaluateOperands(options) {
        // evaluation must be from left to right (l2r) operands, inside operand
        // also evaluation is l2r: prior, value, arguments (l2r), indexes (l2r)
        // at end of this operand evaluation, must manage increment/decrement
        // options.

        // stackResults is used to store operand evaluations needed by full stack
        // evaluation.

        let stackResults = [];
        for (let stpos = 0; stpos < this.stack.length; ++stpos) {
            let results = [null, []];
            const st = this.stack[stpos];
            stackResults.push(results);
            let operandResults = results[1];
            // console.log(st.operands);
            for (let operandIndex = 0; operandIndex < st.operands.length; ++operandIndex) {
                const operand = this.assertExpressionItem(st.operands[operandIndex]);

                // when evaluates single operands, StackItem is a reference to stack position
                // and it could be evaluated when all operands are left-to-right evaluated
                if (operand instanceof ExpressionItems.StackItem) {
                    operandResults.push(null);
                    continue;
                }
                // optimization to get stackResults, to avoid calculate two times when
                // insert into stack the expression (1)
                const result = this.evaluateOperand(operand, options);
                operandResults.push(result);

                if (options.instance && result !== null) {
                    if (Debug.active) this.dump(`AAAA.IN stpos:${stpos}`);
                    if (result instanceof Expression) {
                        // result must not be an alone expression because in this case it has been simplied by content of
                        // this expression (the alone operator)
                        assert.equal(result.isAlone(), false);

                        // insert expression below current position
                        this.insertStack(result, stpos);

                        st.operands[operandIndex] = new ExpressionItems.StackItem(1);

                        // evaluate result, optimization (1), and after insert it
                        let stackResultToInsert = result.evaluateOperands(options);
                        // stackResults.unshift(...stackResultToInsert);
                        stackResults = stackResultToInsert.concat(stackResults);
                        // assert.equal(stackResultToInsert.length, result.stack.length);

                        // at this moment position was increased because some elements
                        // are added on below positions.
                        stpos += result.stack.length;
                        if (Debug.active) this.dump('AAAA.OUT1');
                    } else {
                        st.operands[operandIndex] = this.assertExpressionItem(result);
                        if (Debug.active) this.dump('AAAA.OUT2');
                    }
                }
            }
        }
        return stackResults;
    }
    _calculate(st, pos, stackResults) {
        if (st.op === false) {
            return stackResults[pos][0];
        }

        if (stackResults[pos][1].some(x => !(x instanceof ExpressionItems.IntValue))) {
            return ExpressionItem.NonRuntimeEvaluableItem.get();
        }

        stackResults[pos][0] = this.applyOperation(st.op, stackResults[pos][1]);
        return stackResults[pos][0];
    }
    isRuntimeCalculable(e) {
        const te = typeof e;
        if (te === 'string' || te === 'number' || te === 'bigint' /* || te === 'fe' */) {
            return true;
        }
        if (te === 'object' && e.type) {
            if (e.type === 'witness' && e.type === 'fixed') return false;
        }
    }
    simplify() {
        let loop = 0;
        while (this.stack.length > 0) {
            let updated = false;
            if (Debug.active) this.dump('PRE-SIMPLIFY-OPERATION');
            for (const st of this.stack) {
                updated = this.simplifyOperation(st) || updated;
            }
            if (Debug.active) this.dump('POST-SIMPLIFY-OPERATION');
            this.compactStack();
            if (Debug.active) this.dump('POST-COMPACT');
            if (!updated) break;
        }
    }

    // this method simplify trivial operations as 0 + x or 1 * x, also
    // simplify operations between values, not only direct values also
    // referenced and solved values (as runtime variable)

    simplifyOperation(st) {
        if (st.op === false) {
            return false;
        }

        // this.simplifyRuntimeToValue(st);
        const firstValue = st.operands[0] instanceof ExpressionItems.ValueItem ? st.operands[0].getValue() : false;
        const secondValue = (st.operands.length > 1 && st.operands[1] instanceof ExpressionItems.ValueItem) ? st.operands[1].getValue() : false;

        // [op,v1,v2] ==> [v1 op v2]
        if (firstValue !== false && secondValue !== false) {
            assert.ok(!firstValue || !firstValue.rowOffset);
            assert.ok(!secondValue || !secondValue.rowOffset);
            const res = this.applyOperation(st.op, st.operands);
            st.operands = [this.assertExpressionItem(res)];
            st.op = false;
            return true;
        }

        // [neg,value] ==> [false,-value]
        if (st.op === 'neg' && firstValue !== false) {
            assert.ok(!firstValue.rowOffset);
            st.op = false;
            st.operands[0].setValue(-st.operands[0].getValue());
            assert.instanceOf(st.operands[0], ExpressionItem);
            return true;
        }

        const firstZero = firstValue === 0n;

        if (firstZero || secondValue === 0n) {
            // [mul, 0, x] ==> [0]
            // [mul, x, 0] ==> [0]
            if (st.op === 'mul') {
                st.op = false;
                // firstZero => st.operands[0] = 0
                // !firstZero => second = 0 ==> st.operands[1] = 0
                st.operands = [st.operands[firstZero ? 0:1]];
                return true;
            }
            // [add, 0, x] ==> [x]
            // [add, x, 0] ==> [x]
            if (st.op === 'add') {
                st.op = false;
                st.operands = [st.operands[firstZero ? 1:0]];
                return true;
            }

            // [sub, x, 0] ==> [x]
            if (st.op === 'sub' && !firstZero) {
                st.op = false;
                return true;
            }
        }

        const firstOne = firstValue === 1n;

        // [mul, 1, x] ==> [x]
        // [mul, x, 1] ==> [x]
        if (st.op === 'mul' && (firstOne || secondValue === 1n)) {
            st.op = false;
            st.operands = [st.operands[firstOne ? 1:0]];
            return true;
        }

        if (st.op === 'sub' && secondValue !== false && secondValue < 0n) {
            st.op = 'add';
            st.operands[1] = new ExpressionItems.IntValue(-secondValue);
            return true;
        }

        if (st.op === 'if' && firstValue !== false) {
            st.op = false;
            st.operands = [st.operands[firstValue ? 1:2]];
            return true;
        }

        // TODO: be carrefull with next, prior, inc, dec
        // x - x = 0 ???
        // (x - (- y)) = x + y
        // (x + (- y)) = x - y
        // v1 * x + v2 * x = (v1+v2) * x
        // v1 * x - v2 * x = (v1-v2) * x

        // TODO: binary cols optimizations, each kind of optimization has a key to enable/disable
        // this specific optimization.
        // BC(y) ==> y * x + (1 - y) * z = y * (z - x) + x


        // TODO: evaluate all expressions with different prime values (valid values as binary constraints 🤔)
        // detect same expressions (as bigints or as fe, bigints same implies fe same 🤔).
        // After, check matchs with other 100% sure method.

        return false;
    }
    cleanOrphanFromStack() {
        const stackLen = this.stack.length;
        if (stackLen === 0) return;

        // array with index the stack position and value to purge or not;
        let purge = new Array(stackLen).fill(true);
        let pending = [stackLen - 1];
        let purgeCount = stackLen - 1;

        // this block mark position to purge
        while (pending.length > 0) {
            const istack = pending.pop();
            const st = this.stack[istack];
            purge[istack] = false;
            purgeCount--;
            st.operands.filter(operand => operand instanceof ExpressionItems.StackItem).forEach(operand => {
                const absPos = operand.getAbsolutePos(istack);
                if (purge[absPos] !== true || pending.includes(absPos)) return;
                pending.push(absPos);
            });
        }

        let translate = [];
        let freeStackPos = 0;

        for (let istack = 0; istack < stackLen; ++istack) {
            if (purge[istack]) {
                translate[istack] = false;
                continue;
            }
            const newPos = freeStackPos++;
            translate[istack] = newPos
            this.stack[newPos] = this.stack[istack];
            this.stack[newPos].operands.filter(x => x instanceof ExpressionItems.StackItem).forEach(operand => {
                const newAbsolutePos = translate[operand.getAbsolutePos(istack)];
                // assert newAbsolutePos(>0)
                operand.setOffset(newPos - newAbsolutePos);
            });
        }
        this.stack.splice(freeStackPos);
    }
    // this method compact stack positions with one element where operation
    // was false, replace reference of this stack operation by directly value
    compactStack() {
        if (Debug.active) this.dump('PRE-CLEAN');
        this.cleanOrphanFromStack();
        if (Debug.active) this.dump('POST-CLEAN');

        let tt = new TranslationTable();
        let newStackIndex = 0;
        let stackLen = this.stack.length;
        if (Debug.active) this.dump('PRE-COMPACTSTACK');


        // mark alone stack positions to purge and renumerate no purged positions
        // CAUTION: when exists a ternary operation, could be some stack positions to
        // ignore. To avoid this, first of all need to clean non "orphan"
        for (let istack = 0; istack < stackLen; ++istack) {
            const st = this.stack[istack];
            if (st.op === false) {
                const ope = st.operands[0];
                // two situations for alone:
                //    1 - stack reference, use its reference and purge
                //    2 - single operand, use index and purge
                //        TODO: if this single operand exists (duplicated), reference it.
                if (ope instanceof ExpressionItems.StackItem) {
                    tt.copyPurge(istack, ope.getAbsolutePos(istack));
                } else {
                    tt.savePurge(istack, ope); // ==> purge:true
                }
                continue;
            }

            tt.translate(istack, newStackIndex++); // ==> purge:false
            // foreach operand if it's a stack reference, must be replaced by
            // new reference or by copy of reference if it was alone (no operation)
            for (let iope = 0; iope < st.operands.length; ++iope) {
                if ((st.operands[iope] instanceof ExpressionItems.StackItem) === false) continue;
                const absolutePos = st.operands[iope].getAbsolutePos(istack);
                // cases new absolute pos:
                // - exists and will not be purged
                // - exists but will be purged ==> is a alone position ==> need to copy final content
                assert.ok(absolutePos < istack);
                const newAbsolutePos = tt.getTranslation(absolutePos);
                if (newAbsolutePos === false) {
                    // CASE: new absolute pos exists and will not be purged
                    // if purge and referenced position was alone, it is copied (duplicated)
                    const savedOperand = tt.getSaved(absolutePos)
                    if (Debug.active) this.dump(`XXXX #${istack}/${iope} ${absolutePos} ${savedOperand.toString()}`);
                    this.stack[istack].operands[iope] = this.assertExpressionItem(savedOperand.clone());
                    if (Debug.active) this.dump('YYYY');
                } else {
                    // CASE: new absolute pos exists and will not be purged
                    // newStackIndex - 1 is new really istack after clear simplified stack positions
                    // calculate relative position (offset)
                    const newOffset = (newStackIndex - 1) - newAbsolutePos;
                    assert.ok(newOffset > 0, `newOffset:${newOffset} newStackIndex:${newStackIndex} istack:${istack} newAbsolutePos:${newAbsolutePos}`);
                    this.stack[istack].operands[iope].setOffset(newOffset);
                }
            }

        }
        if (Debug.active) tt.dump();

        // special case if top of stack is alone operator, it means
        // that this is the result of expression.
        const topStack = this.stack[stackLen - 1];
        if (topStack.op === false && (topStack.operands[0] instanceof ExpressionItems.StackItem) === false) {
            this.stack = [this.stack[stackLen - 1]];
            return true;
        }
        // DEBUG:
        // translationTable.forEach((value, index) => console.log(`#${index} => ${value}`));

        // move stackpositions to definitive positions, from end to begin to avoid
        // overwriting, updating last position used to remove rest of stack positions
        let lastPosUsed = false;
        let _nextPosition = 0;
        for (let istack = 0; istack < stackLen; ++istack) {
            if (tt.getPurge(istack)) continue;

            const newAbsPos = tt.getTranslation(istack);
            assert.strictEqual(newAbsPos, _nextPosition);
            this.stack[newAbsPos] = this.stack[istack];
            lastPosUsed = newAbsPos;
            ++_nextPosition;
        }
        if (lastPosUsed !== false) {
            this.stack.splice(lastPosUsed + 1);
        } else {
            // all stack positions must be removed, but at least need position #0
            this.stack.splice(1);
        }

        // return if expression was updated
        return stackLen > this.stack.length;
    }
    getCaller(stackLevels = 4) {
        let caller = '';
        try {
            throw new Error();
        } catch (e) {
            caller = e.stack.split('\n')[stackLevels].trim().substring(3);
        }
        return caller;
    }
    static dumpScope = null;
    dump(title) {
        const previousDumpScope = Expression.dumpScope;
        Expression.dumpScope = Expression.dumpScope === null ? '' : Expression.dumpScope + '    ';
        const res = this.dumpStack(`DUMP (${title ?? ''})`, this.stack);
        Expression.dumpScope = previousDumpScope;
        return res;
    }
    dumpItem(options) {
        return 'Expression('+this.toString(options)+')';
    }
    dumpStackResults(stackResults, title = '') {
        return this.dumpStack(`STACK RESULTS (${title ?? ''})`, stackResults, {stackProperty: 0, operandsProperty: 1});
    }
    dumpStack(title, stack, options = {} ) {
        title = title + ' ' + this.getCaller();
        console.log((Expression.dumpScope ?? '') + `\x1B[38;5;214m|==========> ${title} <==========|\x1B[0m`);
        for (let index = stack.length-1; index >=0; --index) {
            this.dumpStackPos(index, options);
        }
    }
    dumpStackPos(index, options = {}) {
        console.log(this.stringStackPos(index, options));
    }
    stringStackPos(index = false, options = {}) {
        const stackPos = this.stack[index];
        const stackProperty = options.stackProperty ?? 'op';
        const operandsProperty = options.operandsProperty ?? 'operands';
        const stackValue = stackPos[stackProperty];
        const operationInfo = (stackValue && typeof stackValue.dump === 'function') ? stackValue.dump() : stackValue;
        let info = (Expression.dumpScope ?? '') + `\x1B[38;5;214m#${index === false?'':index} ${stackValue}`;
        for (const operand of stackPos[operandsProperty]) {
            const operandInfo = this.dumpOperand(operand, index, options);
            info = info + ' [\x1B[38;5;76m' + operandInfo +'\x1B[38;5;214m]';
        }
        return info+'\x1B[0m';
    }
    dumpOperand(op, pos, options = {}) {
        const cType = '\x1B[38;5;76m';
        const cProp = '\x1B[38;5;250m';
        const cValue = '\x1B[38;5;40m';
        if (op instanceof ExpressionItem) {
            return op.dumpItem({...options, cType, cProp, cValue, pos});
        }
        if (op === null) return 'null';
        if (Array.isArray(op)) {
            return '['+op.map(x => this.dumpOperand(x, pos, options)).join()+']'
        }
        EXIT_HERE;
    }
    toString(options) {
        let top = this.stack.length-1;
        if (top < 0) {
            return '(Expression => String)';
        }
        const res = this.stackPosToString(top ,0, {...options, dumpToString: true});
        return res;
    }
    stackPosDegree(pos, options) {
        const st = this.stack[pos];
        if (st.op === false) {
            return st.operands[0].degree ?? -1;
        }
        switch (st.op) {
            case 'add':
            case 'sub': {
                const degree1 = this.operandDegree(st.operands[0], pos);
                const degree2 = this.operandDegree(st.operands[1], pos);
                return (degree1 == -1 || degree2 == -1) ? -1 : (degree1 > degree2 ? degree1 : degree2);
            }
            case 'mul': {
                const degree1 = this.operandDegree(st.operands[0], pos);
                const degree2 = this.operandDegree(st.operands[1], pos);
                return (degree1 == -1 || degree2 == -1) ? -1 : degree1 + degree2;
            }
            case 'neg': {
                return this.operandDegree(st.operands[0], pos);
            }
        }
        this.degreeNotFound(st.op);
        return -1;
    }
    operandDegree(operand, pos, options) {
        if (operand instanceof ExpressionItems.StackItem) {
            const absolutePos = operand.getAbsolutePos(pos);
            return this.stackPosDegree(absolutePos, options);
        }
        if (typeof operand.degree === 'number') {
            return operand.degree;
        }
        this.degreeNotFound(operand);
        return -1;
    }
    degreeNotFound(operand) {
        const typename = ((operand ?? {}).constructor ?? {}).name ?? '¿?';
        const label = (operand ?? {}).label ?? '';
        console.log(`degree not defined for ${label} with type ${typename}`);
    }
    stackPosToString(pos, parentOperation, options) {
        const st = this.stack[pos];
        if (typeof st === 'undefined') {
            console.log(pos);
            console.log(this.stack);
        }
        const parentPrecedence = ExpressionOperationsInfo.get(parentOperation).precedence;
        if (st.op === false) {
            return this.operandToString(st.operands[0], pos, st.op, options);
        }
        const operationInfo = ExpressionOperationsInfo.get(st.op);
        const operationLabel = operationInfo.label;
        let res;
        if (st.operands.length === 1) {
            res = operationLabel + this.operandToString(st.operands[0], pos, st.op, options);

        } else if (st.operands.length === 2) {
            res = this.operandToString(st.operands[0], pos, st.op, options) + ' ' + operationLabel + ' ' +
                  this.operandToString(st.operands[1], pos, st.op, options);
        } else if (st.operands.length === 3 && st.op === 'if') {
            res = '(' + this.operandToString(st.operands[0], pos, st.op, options) + ')?('+
                  this.operandToString(st.operands[1], pos, st.op, options) + '):(' +
                  this.operandToString(st.operands[2], pos, st.op, options) + ')';
        } else {
            console.log(st);
            TODO_EXIT
        }
        if (options.allParentheses || parentPrecedence > operationInfo.precedence || (parentOperation === 'sub' && st.op !== 'mul')) {
            res = '(' + res + ')';
        }
        return res;
    }
    operandToString(ope, pos, parentOperation, options) {
        if (ope instanceof ExpressionItems.StackItem) {
            return this.stackPosToString(pos-ope.offset, parentOperation, options);
        }
        // return options.map ? options.map(ope, options) : `[${ope.constructor.name}]`+ope.toString(options);
        return options.map ? options.map(ope, options) : ope.toString(options);
    }
    pack(container, options) {
        const packer = new ExpressionPacker(container, this);
        if (Debug.active) this.dump('PRE-PACK');
        return packer.pack(options);
    }
    resolve() {
        const res = this.eval();
        if (res instanceof Expression) {
            return res.instance({simplify: true});
        }
        return res;
    }
    isEmpty() {
        return this.stack.length === 0;
    }
    asBool() {
        let value = this.evalAsValue();
        // check if empty expression
        if (this.isEmpty()) {
            return false;
        }
        assert.notInstanceOf(value, Expression);
        if (typeof value.asBool === 'function') {
            return value.asBool();
        }
        if (typeof value.asInt === 'function') {
            const ivalue = value.asInt();
            assert.strictEqual(typeof ivalue, 'bigint');
            return ivalue !== 0n;
        }
        throw new Exceptions.CannotBeCastToType('bool');
    }
    asIntItem() {
        return new ExpressionItems.IntValue(this.asInt());
    }
    asInt() {
        let value = this.evalAsValue();
        // check if empty expression
        if (this.isEmpty()) {
            return 0n;
        }
        assert.notInstanceOf(value, Expression);
        if (typeof value.asInt === 'function') {
            return value.asInt();
        }
        throw new Exceptions.CannotBeCastToType('int');
    }
    asIntDefault(defaultValue = false) {
        return this._asDefault(this.asInt, defaultValue);
    }
    asIntItemDefault(defaultValue = false) {
        return this._asDefault(this.asIntItem, defaultValue);
    }
    asString() {
        const value = this.evalAsValue();
        if (this.isEmpty()) {
            return '';
        }
        assert.notInstanceOf(value, Expression, value);
        if (typeof value.asString === 'function') {
            return value.asString();
        }
        throw new Exceptions.CannotBeCastToType('string');
    }
    asStringItem() {
        return new ExpressionItems.StringValue(this.asString());
    }
    asStringDefault(defaultValue = false) {
        return this._asDefault(this.asString, defaultValue);
    }
    asStringItemDefault(defaultValue = false) {
        return this._asDefault(this.asStringItem, defaultValue);
    }
    getValue() {
        return this.eval();
    }
    hasRuntimes() {
        return this.stack.some(stackPos => stackPos.operands.some(operand => operand.isRuntime()));
    }
    static getType() {
        return 'expr';
    }
    isRuntimeEvaluable() {
        return this.stack.every(stackPos => stackPos.operands.every(operand => operand.isRuntimeEvaluable()));
    }
}

ExpressionItem.registerClass('Expression', Expression);
ExpressionClass.set(Expression);
Types.register('expr', Expression);
module.exports = Expression;
