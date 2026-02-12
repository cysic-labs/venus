const Expression = require('./expression.js');
const Context = require('./context.js');
const assert = require('./assert.js');
module.exports = class Constraints {
    constructor (expressions = false) {
        this.constraints = [];
        this.expressions = expressions;
    }
    get length() {
        return this.constraints.length;
    }
    getExpressions() {
        return this.expressions ? this.expressions : Context.expressions;
    }
    clone() {
        let cloned = Object.assign(Object.create(Object.getPrototypeOf(this)), this);
        cloned.constraints = [];
        for (const constraint of this.constraints) {
            cloned.constraints.push({...constraint});
        }
        return cloned;
    }

    get(id) {
        return {...this.constraints[id]};
    }

    getExpr(id) {
        return this.getExpressions().get(this.constraints[id].exprId);
    }

    isDefined(id) {
        return (typeof this.constraints[id] != 'undefined');
    }

    getPackedExpressionId(id, container, options = {}) {
        const res = (options.expressions ?? this.getExpressions()).getPackedExpressionId(id, container, options);
        return res;
    }
    define(left, right, boundery, sourceRef) {
        assert.instanceOf(left, Expression);
        assert.instanceOf(right, Expression);
        if (left.isRuntime()) {
            left.dump('LEFT  CONSTRAINT');
            throw new Error(`left constraint has runtime no resolved elements`);
        }
        if (right.isRuntime()) {
            right.dump('RIGHT CONSTRAINT');
            throw new Error(`right constraint has runtime no resolved elements`);
        }
        if (left.fixedRowAccess || right.fixedRowAccess) {
            console.log('\x1B[31mWARNING: accessing fixed row acces\x1b[0m');
        }
        const id = this.constraints.length;
        if (right.asIntDefault(false) !== 0n) {
            left.insert('sub', right);
        }
        left.simplify();
        return this.defineExpressionAsConstraint(left, boundery, sourceRef);
    }
    getLastConstraintId() {
        return this.constraints.length - 1;
    }
    defineExpressionAsConstraint(e, boundery, sourceRef) {
        const exprId = this.getExpressions().insert(e);
        return this.constraints.push({exprId, sourceRef: sourceRef ?? Context.sourceTag, boundery: boundery ?? false}) - 1;
    }
    *[Symbol.iterator]() {
        for (let index = 0; index < this.constraints.length; ++index) {
          yield this.constraints[index];
        }
    }

    *values() {
        for (let value of this.constraints) {
            yield value;
        }
    }

    *keyValues() {
        for (let index = 0; index < this.constraints.length; ++index) {
            yield [index, this.constraints[index]];
        }
    }
    dump (packed) {
        for (let index = 0; index < this.constraints.length; ++index) {
            console.log(this.getDebugInfo(index, packed));
        }
    }
    getDebugInfo(index, packed, options) {
        const constraint = this.constraints[index];
        try {
            if (!packed) {
                return constraint.sourceRef;
            }
            const peid = this.getPackedExpressionId(constraint.exprId, packed, options);
            return constraint.sourceRef + ' '  + packed.exprToString(peid, {...options, labels: this.getExpressions(), hideClass: true});
        } catch (e) {
            throw new Error(`ERROR generation debug info for constraint ${constraint.sourceRef}: ${e.message}`)
        }
    }
}
