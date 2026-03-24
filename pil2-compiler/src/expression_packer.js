const util = require('util');
const Exceptions = require('./exceptions.js');
const ExpressionItems = require('./expression_items.js');
const Context = require('./context.js');
const { DefinitionItem } = require('./definition_items.js');
const assert = require('./assert.js');

module.exports = class ExpressionPacker {
    constructor(container = false, expression = false, rowOffset = false) {
        // to define if the expression has elements which applies rowOffset
        this.appliesRowOffset = false;
        this.set(container, expression, rowOffset);
    }
    set(container, expression, rowOffset) {
        this.container = container;
        this.expression = expression;
        this.rowOffset = rowOffset || 0;
    }
    packAlone(options) {
        this.operandPack(this.expression.getAloneOperand(), 0, options);
        return this.container.pop(1)[0];
    }
    pack(options) {
        if (!this.expression.stack) console.log(this.expression);
        assert.ok(this.expression.stack.length);
        let top = this.expression.stack.length-1;
        const result = this.stackPosPack(top, options);
        // Stores whether to apply row offset when saving, to be used during reference resolution.
        // An expression with a reference that uses row offset will apply the row offset.
        this.container.setAppliesRowOffset(result, this.appliesRowOffset);
        return result;

    }
    stackPosPack(pos, options) {
        const st = this.expression.stack[pos];
        if (st.op === false) {
            this.operandPack(st.operands[0], pos, options);
            return this.container.insertTop();
        }
        for (const ope of st.operands) {
            this.operandPack(ope, pos, options);
        }
        switch (st.op) {
            case 'mul':
                return this.container.mul();

            case 'add':
                return this.container.add();

            case 'sub':
                return this.container.sub();

            case 'neg':
                return this.container.neg();

            default:
                throw new Error(`Invalid operation ${st.op} on packed expression`);
        }
    }

    operandPack(ope, pos, options) {
        if (ope instanceof ExpressionItems.ValueItem) {
            this.container.pushConstant(ope.value);
        } else if (ope instanceof ExpressionItems.ProofItem) {
            this.referencePack(ope, options);
        } else if (ope instanceof ExpressionItems.StackItem) {
            const eid = this.stackPosPack(pos-ope.getOffset(), options);
            if (eid !== false) {        // eid === false => alone operand
                this.container.pushExpression(eid);
            }
        } else {
            const opeType = ope instanceof Object ? ope.constructor.name : typeof ope;
            throw new Error(`Invalid reference ${opeType} on packed expression`);
        }

    }
    referencePack(ope, options) {
        const id = ope.getId();
        const def = Context.references.getDefinitionByItem(ope, options);
        if (typeof def === 'undefined') {
            this.expression.dump();
            throw new Error(`Definition not found for ${ope.constructor.name} ${id} ${ope.label ?? ''}`);
        }
        assert.typeOf(def, 'object')
        assert.instanceOf(def, DefinitionItem);
        if (ope instanceof ExpressionItems.WitnessCol) {
            this.container.pushWitnessCol(id, ope.getRowOffset() + this.rowOffset, def.stage);
            this.appliesRowOffset = true;

        } else if (ope instanceof ExpressionItems.FixedCol) {
            if (def.temporal) {
                throw new Error(`Reference a temporal fixed column ${ope.label}`);
            }
            this.container.pushFixedCol(id, ope.getRowOffset() + this.rowOffset);
            this.appliesRowOffset = true;

        } else if (ope instanceof ExpressionItems.CustomCol) {
            this.container.pushCustomCol(id, ope.getRowOffset() + this.rowOffset, def.stage);
            this.appliesRowOffset = true;
        } else if (ope instanceof ExpressionItems.Public) {
            this.container.pushPublicValue(id);

        } else if (ope instanceof ExpressionItems.Challenge) {
            this.container.pushChallenge(def.relativeId, def.stage);

        } else if (ope instanceof ExpressionItems.ProofValue) {
            this.container.pushProofValue(def.relativeId, def.stage);

        } else if (ope instanceof ExpressionItems.AirGroupValue) {
            const def = Context.references.getDefinitionByItem(ope);
            this.container.pushAirGroupValue(def.relativeId, def.airGroupId);
        } else if (ope instanceof ExpressionItems.AirValue) {
            const def = Context.references.getDefinitionByItem(ope);
            // no use relativeId, because air live only inside air, as witness or fixed col.
            this.container.pushAirValue(def.id);
        } else if (ope instanceof ExpressionItems.ExpressionReference) {
            const defvalue = Context.references.getDefinitionByItem(ope).getValue();

            if (defvalue.isExpression) {
                let rowOffset = (ope.rowOffset ? ope.rowOffset.value : 0) + this.rowOffset;
                if (this.container.pushExpressionReference(id, rowOffset)) {
                    return;
                }
                // return reference with rowOffset = 0
                const refRowOffsetZero = this.container.getExpressionReference(id);
                if (refRowOffsetZero !== false) {
                    // if reference with rowOffset = 0 exists, use it
                    this.container.pushExpression(refRowOffsetZero);
                    return;
                }
                const packer = new ExpressionPacker(this.container, def.getValue(), rowOffset);
                try {
                    const res = packer.pack(options);
                    if (packer.appliesRowOffset) {
                        this.appliesRowOffset = true;
                    }
                    if (typeof res === 'number') {
                        if (!packer.appliesRowOffset && rowOffset) {
                            // if rowOffset doesn't apply, store with rowOffset = 0, because rowOffset not change
                            // and it isn't necessary to duplicate expression by rowOffset application
                            rowOffset = 0;
                        }
                        this.container.saveAndPushExpressionReference(id, rowOffset, ope.label, res);
                    } else {
                        this.container.push(res);
                    }
                } catch (error) {
                    console.error(`Error packing expression reference ${id}:`, error);
                    console.log(defvalue);
                    defvalue.dump();
                    throw error;
                }
            } else if (defvalue.isReference) {
                // if is a reference, pack it as reference
                this.container.pushExpressionReference(id, ope.rowOffset + this.rowOffset);
            } else {
                this.referencePack(defvalue, options);
            }
        } else {
            throw new Error(`Invalid reference class ${ope.constructor.name} to pack`);
        }
    }
}
