const {assert} = require('chai');
const ExpressionItems = require('../src/expression_items.js');

module.exports = class CompilerTest {
    onContextInit(context) {    
        this.context = context;
    }
    onProcessorInit(processor) {
        this.processor = processor;
        this.it = this.processor.constraints[Symbol.iterator]();
    }
    verifyNextConstraint (sconstraint, rconstraint) {
        let c = this.it.next().value;
        const expr = this.processor.constraints.getExpr(c.exprId);
        const _sconstraint = expr.toString({hideClass: true});
        const _rconstraint = expr.toString({hideClass: true, hideLabel: true});
        assert.equal(_rconstraint, rconstraint);
        assert.equal(_sconstraint, sconstraint);
    }
    verifyEndConstraint() {    
        assert.strictEqual(this.it.next().done, true);
    }
    verifyFixedCycle (names, expected, times = 1, N = 2**7) {
        // assert.equal(col.length, N, `${name} length`);
        names = Array.isArray(names) ? names:[names];
        for (const name of names) {
            const reference = this.context.references.getReference(name);
            for (let index = 0; index < N; ++index) {
                const eindex = Math.floor(index / times) % expected.length;
                assert.strictEqual(this.context.references.getItem(name, [index]).asInt(), BigInt(expected[eindex]), `${name}[${index}]`);
            }
        }
    }
    onSubProofStart() {
    }
    onSubProofEnd() {
    }
}
