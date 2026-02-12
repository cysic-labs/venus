const assert = require('./assert.js');
const Context = require('./context.js');

module.exports = class Scope {
    constructor () {
        this.deep = 0;
        this.shadows = [{}];
        this.properties = [{}];
        this.labels = {};
        this.instanceType = 'air';
        this.stackInstanceTypes = [];
        this.values = {};
        this.valuesStack = [];
    }
    mark(label) {
        this.labels[label] = this.deep;
    }
    getScopeId(label = false) {
        return label === false ? this.deep : (this.labels[label] ?? false);
    }
    purgeLabels() {
        for (const label in this.labels) {
            if (this.labels[label] > this.deep) {
                // console.log(`PURGE SCOPE LABEL ${label}`);
                delete this.labels[label];
            }
        }
    }
    addToScopeProperty(property, value) {
        if (typeof this.properties[this.deep][property] === 'undefined') {
            this.properties[this.deep][property] = [value];
            return;
        }
        this.properties[this.deep][property].push(value);
    }
    setScopeProperty(property, value) {
        this.properties[this.deep][property] = value;
    }
    getScopeProperty(property, defaultValue = []) {
        return this.properties[this.deep][property] ?? defaultValue;
    }
    declare (name, type, ref, scope = false) {
        if (type === 'airgroupvalue') console.log(`[SCOPE] DECLARE ${name} scope:${scope} deep:${this.deep}`);
        if (scope === false) scope = this.deep;
        else if (typeof scope === 'string') {
            const lscope = this.labels[scope];
            if (typeof lscope === 'undefined') {
                throw new Error(`Scope ${scope} not found`);
            }
            scope = lscope;
        }
        this.shadows[scope][name] = {type, ref};
        return scope;
    }
    pop (excludeTypes = []) {
        if (this.deep < 1) {
            throw new Error('Out of scope');
        }
        const shadows = this.shadows[this.deep];
        for (const name in shadows) {
            const exclude = excludeTypes.includes(shadows[name].type);
            // if (exclude) console.log(`Excluding from this scope (${name})....`);
            // console.log(`POP ${name}`);
            // console.log(shadows[name]);
            if (shadows[name].ref === false) {
                if (!exclude) Context.references.unset(name);
            } else {
                // I could not 'update' reference name, because was an excluded type. This situation
                // was an error because could exists same name in scope linked.
                if (exclude) {
                    throw new Error(`Excluded type ${shadows[name].type} has shadow reference called ${name}`);
                }
                Context.references.restore(name, shadows[name].ref);
            }
        }
        this.shadows[this.deep] = {};
        for (const property in this.properties[this.deep]) {
            assert.typeOf(Context.references.unsetProperty, 'function', Context.references.constructor.name);
            Context.references.unsetProperty(property, this.properties[this.deep][property]);
        }
        this.properties[this.deep] = {};
        this.popValues();
        --this.deep;
        this.purgeLabels();
        // console.log(`POP ${this.deep}`)
    }
    push(label = false, visibility = true) {
        ++this.deep;
        // console.log(`PUSH ${this.deep}`)
        this.shadows[this.deep] = {};
        this.properties[this.deep] = {};
        this.pushValues();
        if (label !== false) {
            this.mark(label);
        }
        return this.deep;
    }
    setValue(name, value) {
        // set sigle value associate to current level with hiherancy
        if (typeof this.values[name] === 'undefined') {
            this.values[name] = value;
        } else if (this.valuesStack.length > 0)  {
            this.valuesStack[this.valuesStack.length - 1][name] = this.values[name];
            this.values[name] = value;
        } else {
            // empty scope stack, never recover previous value
            this.values[name] = value;              
        }
    }
    getValue(name, defaultValue = false) {
        if (typeof this.values[name] !== 'undefined') {
            return this.values[name];
        }
        return defaultValue;
    }
    popValues() {
        let values = this.valuesStack.pop();
        for (const name in values) {
            this.values[name] = values[name];
        }
    }
    pushValues() {
        this.valuesStack.push({});
    }
    getInstanceType() {
        return this.instanceType;
    }
    pushInstanceType(type) {
        this.stackInstanceTypes.push(this.instanceType);
        this.push(type);
        this.instanceType = type;
    }
    popInstanceType(excludeTypes = []) {
        this.instanceType = this.stackInstanceTypes.pop();
        this.pop(excludeTypes);
        return this.instanceType;
    }
}
