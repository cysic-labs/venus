const MultiArray = require("./multi_array.js");
const Expression = require("./expression.js");
const {ExpressionItem, ArrayOf} = require("./expression_items.js");
const Reference = require('./reference.js');
const Containers = require('./containers.js');
const Context = require('./context.js');
const Exceptions = require('./exceptions.js');
const Debug = require('./debug.js');
const assert = require('./assert.js');
module.exports = class References {

    constructor () {
        this.references = {};
        this.types = {};
        this.visibilityScope = [0,false];
        this.visibilityStack = [];
        this.containers = new Containers(this);
        this.referencesStack = [];
    }
    isContainerDefined(name) {
        return this.containers.isDefined(name);
    }
    get insideContainer() {
        return this.containers.getCurrent() !== false;
    }
    getContainerScope() {
        return this.containers.getCurrentScope();
    }
    getLabelByItem(item, options = {}) {
        const instance = this.getInstanceByItem(item, options);
        if (instance === null) {
            return false;
        }
        return instance.getLabel(item.id, options);
    }
    getInstanceByItem(item, options = {}) {
        let instance = null;
        const instances = [...(options.instances ?? []), ...Object.values(this.types).map(x => x.instance)];
        for (const _instance of instances) {
            if (Debug.active) console.log(_instance);
            const _constructor = item.constructor;
            if (_instance.expressionItemClass === _constructor || _instance.expressionItemConstClass === _constructor || _instance.definitionClass == _constructor) {
                instance = _instance;
                break;
            }
        }
        if (instance === null && item.constructor.name === 'ExpressionReference') {
            instance = this.types.expr.instance;
        }
        return instance;
    }
    getDefinitionByItem(item, options = {}) {
        const instance = this.getInstanceByItem(item, options);

        if (Debug.active) console.log(instance, item.constructor.name, item.id, Object.keys(this.types),Object.values(this.types).map(x => x.instance.expressionItemClass));
        const res = instance.get ? instance.get(item.id): false;
        if (Debug.active) console.log(res);
        return res;
    }
/*    getDefinition(name, indexes) {
        const reference = this.getReference(name);
        const id = reference.getId(indexes);
    }*/
    getArray(name, indexes) {
        const reference = this.getReference(name);
        if (!reference.array) {
            return false;
        }
        return reference.array.applyIndexes(reference, indexes);
    }
    getNameScope(name) {
        const nameInfo = this.decodeName(name);
        return nameInfo.scope;
    }
    createContainer(name, alias = false) {
        return this.containers.create(name, alias);
    }
    closeContainer() {
        this.containers.close();
    }
    pushVisibilityScope(creationScope = false) {
        this.visibilityStack.push(this.visibilityScope);
        this.visibilityScope = [Context.scope.deep, creationScope];
    }
    popVisibilityScope() {
        if (this.visibilityStack.length < 1) {
            throw new Error(`invalid popVisibilitScope`);
        }
        this.visibilityScope = this.visibilityStack.pop()
    }
    register(type, instance, options) {
        if (typeof this.types[type] !== 'undefined') {
            throw new Error(`type ${type} already registered`);
        }
        this.types[type] = {
            options: options || {},
            instance
        }
    }
    clearType(type, label) {
        const typeInfo = this.types[type];
        if (typeof typeInfo === 'undefined') {
            throw new Error(`type ${type} not registered`);
        }
        typeInfo.instance.clear(label);
        // TODO: remove references
        for (const name in this.references) {
            if (this.references[name].type !== type) continue;
            delete this.references[name];
        }
    }
    pushType(type, label) {
        const typeInfo = this.types[type];
        if (typeof typeInfo === 'undefined') {
            throw new Error(`type ${type} not registered`);
        }
        typeInfo.instance.push(label);

        let stackReferences = {};
        for (const name in this.references) {
            if (this.references[name].type !== type) continue;
            stackReferences[name] = this.references[name];
            delete this.references[name];
        }
        this.referencesStack.push(stackReferences);
    }
    popType(type, label) {
        const typeInfo = this.types[type];
        if (typeof typeInfo === 'undefined') {
            throw new Error(`type ${type} not registered`);
        }
        typeInfo.instance.pop(label);
        let stackReferences = this.referencesStack.pop();
        for (const name in stackReferences) {
            if (this.references[name]!== undefined) {
                throw new Error(`Reference ${name} already defined when restoring references at ${Context.sourceRef}`);
            }
            this.references[name] = stackReferences[name];
        }
    }
    clearScope(proofScope) {
        this.containers.clearScope(proofScope);
    }
    pushScope(proofScope) {
        this.containers.pushScope(proofScope);
    }
    popScope() {
        this.containers.popScope();
    }
    isReferencedType(type) {
        return type.at(0) === '&'
    }
    getReferencedType(type) {
        return this.isReferencedType(type) ? type.substring(1):type;
    }
    getTypeDefinition(type) {
        const typedef = this.types[type] ?? null;
        if (typedef === null) {
            throw new Error(`Invalid or unregistered type ${type}`);
        }
        return typedef;
    }
    getTypeInstance(type) {
        const typedef = this.types[type] ?? null;
        if (typedef === null) {
            throw new Error(`Invalid or unregistered type ${type}`);
        }
        return typedef.instance;
    }
    decodeName (name) {
        assert.typeOf(name, 'string');
        const parts = name.split('.');
        let scope = false;
        if (parts.length === 1) {
            return {scope, name, parts};
        }
        const isProofScope = parts[0] === 'proof';
        const isAirGroupScope = parts[0] === 'airgroup';
        const isAirScope = parts[0] === 'air';
        const absoluteScope = isProofScope || isAirGroupScope || isAirScope;
        let res = {isProofScope, isAirGroupScope, isAirScope, absoluteScope, parts};
        if (absoluteScope) {
            // if absolute scope (proof, airgroup or air) and has more than 2 parts, means at least 3 parts,
            // the middle part was container.
            if (parts.length > 2) {
                return {isStatic: false, ...res, scope: parts[0], name: parts.slice(-1), container: parts.slice(0, -1).join('.')};
            }
            // if absolute, but only 2 or less parts, no container specified.
            return {...res, scope: parts[0], isStatic: true, name: parts.slice(1).join('.')};
        }
        // if no absolute scope, could be an alias if it has 2 parts.
        return {isStatic: false, ...res, scope, name};
    }
    normalizeType(type) {
        if (this.isReferencedType(type)) {
            return [true, this.getReferencedType(type)];
        }
        return [false, type];
    }
    getGlobalScope(name, useCurrentContainer = true) {
        const res = this.decodeName(name);
        if (res.absoluteScope) {
            if (res.isProofScope) return 'proof';
            if (res.isAirGroupScope) return 'airgroup';
            if (res.isAirScope) return 'air';
        }
        if (useCurrentContainer) {
            return this.containers.getCurrent();
        }
        return false;
    }
    checkAndGetContainer(nameInfo){
        const container = this.containers.getCurrent();
        if (container && nameInfo.scope !== false) {
            throw new Error(`Static reference ${nameInfo.name} inside container not allowed`);
        }
        // containers are scope-free.
        return container;
    }
    isStaticDeclaredPreviously(nameInfo, existingReference) {
        if (!nameInfo.isStatic) return false;
            // only created and init once
        if (existingReference) {
            if (existingReference.isStatic) {
                return true;
            }
            throw new Error(`Static reference ${nameInfo.name} has been defined on non-static scope`);
        }
        return false;
    }
    prepareScope(nameInfo, type, existingReference) {
        if (nameInfo.isStatic) {
            return [Context.scope.declare(nameInfo.name, type, false, nameInfo.scope), nameInfo.scope];
        }

        const scopeId = this.hasScope(type) ? Context.scope.declare(nameInfo.name, type, existingReference, false) : 0;
        if (existingReference !== false && this.isVisible(existingReference)) {
            if  (existingReference.scopeId === scopeId || scopeId === false) { // existingReference.scope === false
                console.log(existingReference);
                console.log([existingReference.scopeId,scopeId])
                throw new Error(`At ${Context.sourceRef} is defined ${nameInfo.name}, but ${existingReference.name} as ${existingReference.type} was defined previously on ${existingReference.data.sourceRef}`)
            }
        }
        return [scopeId, false];
    }
    declare(name, type, lengths = [], options = {}, initValue = null) {
        if (assert.isEnabled) {
            assert.typeOf(name, 'string');
            assert.ok(!name.includes('::object'));
            assert.ok(!name.includes('.object'));
        }

        let nameInfo = this.decodeName(name);

        let [array, size] = Reference.getArrayAndSize(lengths);
        if (Debug.active) console.log(name, lengths, array, size);

        let refname = nameInfo.name;
        let internalReference = false;
        if (nameInfo.absoluteScope === false && nameInfo.parts.length === 2) {
            const _ref = this.references[nameInfo.parts[1]] ?? false;
            internalReference = _ref;
        }
        const existingReference = this.references[nameInfo.name] ?? internalReference;
        // When reference is reference to other reference, caller put & before type name (ex: &int)

        const [isReference, finalType] = this.normalizeType(type);

        let scopeId = 0;
        let scope = false;

        const container = this.checkAndGetContainer(nameInfo);
        if (!container) {
            if (this.isStaticDeclaredPreviously(nameInfo, existingReference)) {
                return existingReference.getId();
            }
            [scopeId, scope] = this.prepareScope(nameInfo, finalType, existingReference);
        }

        const instance = this.getTypeInstance(finalType);

        /* take constant property from options, the rest is data information */
        const constProperty = options.const ?? false;
        let data = {...options};
        delete data.const;

        const label = (!container || nameInfo.parts.length > 1) ? nameInfo.name : `${Context.airGroupName}.${nameInfo.name}`;
        const refProperties = {container, scope, isStatic: nameInfo.isStatic, data, const: constProperty, label};

        // TODO: reserve need array for labels?
        const id = isReference ? null : instance.reserve(size, label, array, data);

        const reference = new Reference(nameInfo.name, type, isReference, array, id, instance, scopeId, refProperties);

        if (container) {
            this.containers.addReference(nameInfo.name, reference);
        } else {
            this.references[nameInfo.name] = reference;
        }
        if (typeof options.globalReference === 'string') {
            if (typeof this.references[options.globalReference] !== 'undefined') {
                throw new Error(`Global reference ${options.globalReference} already defined at ${Context.sourceRef}`);
            }
            this.references[options.globalReference] = reference;
        }

        if (initValue !== null) {
            if (Debug.active) {
                if (initValue && typeof initValue.toString === 'function') console.log(initValue.toString());
                else console.log(initValue);
            }
            reference.init(initValue);
        }
        return id;
    }
    isDefined(name, indexes = []) {
        const reference = this.getReference(name, false);
        if (!reference) return false;
        return reference.isValidIndexes(indexes);
    }
    hasScope(type) {
        // TODO: inside function ??
        return ['public', 'proofvalue', 'challenge', 'airgroupvalue', 'publictable'].includes(type) === false;
    }

    get (name, indexes = [], options = {}) {
        assert.typeOf(name, 'string');
        if (Debug.active) console.log('GET', name, indexes);

        // getReference produce an exception if name not found
        return this.getReference(name, undefined, options).get(indexes);
    }
    getIdRefValue(type, id) {
        return this.getTypeDefinition(type).instance.getItem(id);
    }
    getLabel(type, id, options) {
        return this.getTypeDefinition(type).instance.getLabel(id, {type, ...options});
    }
    getTypeR(name, indexes, options) {
        const reference = this.getReference(name);
        const item = reference.getItem(indexes);
        return [item, reference.isReference];
    }
    getItem(name, indexes, options) {

        if (assert.isEnabled) assert.ok(typeof name === 'string' || (Array.isArray(name) && name.length > 0));

        if (Debug.active) console.log(indexes);
        indexes = indexes ?? [];
        options = options ?? {};

        const reference = this.getReference(name);
        const item = reference.getItem(indexes, {...options, label: reference.label ? reference.label : reference.name });

        if (options.preDelta) {
            EXIT_HERE;
            console.log(typeof tvalue.value);
            if (assert.isEnabled) assert.ok(typeof tvalue.value === 'number' || typeof tvalue.value === 'bigint');
            tvalue.value += options.preDelta;
            instance.set(info.locator + info.offset, tvalue.value);
        }
        if (options.postDelta) {
            EXIT_HERE;
            if (assert.isEnabled) assert.ok(typeof tvalue.value === 'number' || typeof tvalue.value === 'bigint');
            instance.set(info.locator + info.offset, tvalue.value + options.postDelta);
        }
        return item;
    }
    _getTypedValue (name, indexes, options) {
        indexes = indexes ?? [];
        options = options ?? {};

        if (typeof indexes === 'undefined') indexes = [];

        const [instance, info, def] = this._getInstanceAndLocator(name, indexes);
        let tvalue;
        if (info.array) {
            // array info, could not be resolved
            console.log('***** ARRAY ******');
            tvalue = new ArrayOf(instance.cls, info.locator + info.offset, info.type ?? def.type, instance);
        } else {
            // no array could be resolved
            console.log([instance.constructor.name, info.type]);
            tvalue = instance.getTypedValue(info.locator + info.offset, 0, info.type);
        }
        // TODO: review
        if (info.type !== 'function') {
            assert.instanceOf(tvalue, ExpressionItem, {name, infotype: info.type, tvalue});
        }
        if (typeof info.row !== 'undefined') {
            tvalue.row = info.row;
        }
        if (!info.array) {
            tvalue.id = info.locator;
        }
        if (options.full) {
            tvalue.locator = info.locator;
            tvalue.instance = instance;
            tvalue.offset = info.offset;
        }
        if (info.dim) {
            tvalue.dim = info.dim;
//            tvalue.arrayType = info.arrayType;
            tvalue.lengths = info.lengths;
        }
        if (info.array) {
            tvalue.dim = 'DEPRECATED';
            tvalue.lengths = 'DEPRECATED';
            tvalue.array = info.array;
        }
        if (options.preDelta) {
            if (Debug.active) console.log(typeof tvalue.value);
            if (assert.isEnabled) assert.ok(typeof tvalue.value === 'number' || typeof tvalue.value === 'bigint');
            tvalue.value += options.preDelta;
            instance.set(info.locator + info.offset, tvalue.value);
        }
        if (options.postDelta) {
            if (assert.isEnabled) assert.ok(typeof tvalue.value === 'number' || typeof tvalue.value === 'bigint');
            instance.set(info.locator + info.offset, tvalue.value + options.postDelta);
        }
        return tvalue;
    }
    getTypeInfo (name, indexes = []) {
        return this._getInstanceAndLocator(name, indexes);
    }
    addUse(name, alias = false) {
        this.containers.addUse(name, alias);
    }
    searchDefinition(name) {
        const subnames = name.split('.');
        const explicitContainer = subnames.length > 1 ? subnames.slice(0, -1).join('.') : false;
        const lname = subnames[subnames.length - 1];

        let reference = false;
        if (!explicitContainer) {
            reference = this.containers.getReferenceInsideCurrent(lname, false);
        } else {
            if (['proof', 'airgroup', 'air'].includes(explicitContainer)) {
                const scopeId = Context.scope.getScopeId(explicitContainer);
                if (scopeId === false) {
                    throw new Error(`not found scope ${explicitContainer}`);
                }
                reference = this.references[lname];
                if (explicitContainer === 'air' && !reference) {
                    reference = this.references[Context.airName+'.'+lname];
                }
                if (reference && reference.scopeId !== scopeId) {
                    const accessToAirArguments = explicitContainer === 'air' && (scopeId - reference.scopeId) === 1;
                    if (!accessToAirArguments) {
                        throw new Error(`Not match declaration scope and accessing scope (${explicitContainer}) of ${name}`);
                    }
                }
            }
            if (!reference && this.containers.isDefined(explicitContainer)) {
                reference = this.containers.getReferenceInside(explicitContainer, lname, false);
            }
        }
        if (!reference) {
            reference = this.references[name] ?? false;
        }
        if (!reference) {
            reference = this.containers.getReference(name, false);
        }
        return reference;
    }
    getNextVisibilityScope(scopeId) {
        let index = 0;
        while (index < this.visibilityStack.length) {
            this.visibilityStack[index]
        }
    }
    isVisible(def) {
        if (Debug.active) console.log('ISVISIBLE', (def.constructor ?? {name: '_'}).name, def);
        const res = !def.scopeId || def.scopeId === 1 || !this.hasScope(def.type) || def.type === 'function' ||
                    def.scopeId >= this.visibilityScope[0] || (this.visibilityScope[1] !== false && def.scopeId <= this.visibilityScope[1]);
        return res;
    }
    /**
     *
     * @param {string|string[]} name
     * @param {*} defaultValue
     * @param {Object} debug
     * @returns {Reference}
     */
    getReference(name, defaultValue, options = {}) {
        // if more than one name is sent, use the first one (mainName). Always first name it's directly
        // name defined on source code, second optionally could be name with airgroup, because as symbol is
        // stored with full name.
        const mainName = Array.isArray(name) ? name[0]:Context.applyTemplates(name);
        const nameInfo = this.decodeName(mainName);
        let names = false;
        if (nameInfo.scope !== false) {
            // if scope is specified on mainName, the other names don't make sense
            names = [mainName];
        } else if (!nameInfo.absoluteScope && nameInfo.parts.length == 2) {
            // absoluteScope means that first scope was proof, airgroup or air. If a non absolute
            // scope is defined perhaps was an alias.
            const container = this.containers.getFromAlias(nameInfo.parts[0], false);
            if (container) {
                // if it's an alias associated with container, replace alias with
                // container associated.
                names = [container + '.' + nameInfo.parts.slice(1).join('.')];
            }
        }

        if (Debug.active) console.log(names);
        if (!names) {
            names = Context.current.getNames(name);
        }
        
        if (nameInfo.scope === false && options.insideName && !names.includes(options.insideName)) {
            names.unshift(options.insideName);
        }
        if (Debug.active) console.log(names);
        // console.log(`getReference(${name}) on ${this.context.sourceRef} = [${names.join(', ')}]`);
        let reference = false;

        for (const name of names) {
            reference = this.searchDefinition(name);
            if (reference) break;
        }
        if (!reference) {
            if (typeof defaultValue !== 'undefined') return defaultValue;
            throw new Exceptions.ReferenceNotFound(names.join(','));
        }

        // constants are visible inside functions
        if (!nameInfo.absoluteScope && this.isVisible(reference) === false) {
            if (typeof defaultValue !== 'undefined') return defaultValue;
            throw new Exceptions.ReferenceNotVisible(names.join(','));
        }
        return reference;
    }
    _getInstanceAndLocator (name, indexes) {
        const def = this.getReference(name);
        // TODO: partial access !!!
        // TODO: control array vs indexes
        const tdata = this._getRegisteredType(def.type);
        if (def.array !== false) {
            // TODO ROW ACCESS
            const typedOffset = def.array.getIndexesTypedOffset(indexes);
            let res = {locator: def.locator, ...typedOffset};

            // if instance doesn't support offset, add offset inside locator
            // and set offset = false
            if (res.offset) {
                res.locator += res.offset;
            }
            res.offset = 0;
            return [tdata.instance, res, def];
        }
        const indexLengthLimit = tdata.instance.rows ? 1 : 0;
        if (indexes.length > indexLengthLimit) {
            throw new Error(`Invalid array or row access, too many array levels`);
        }
        let extraInfo = {type: def.type, offset: 0, reference: def.reference, referencedType: def.referencedType};
        if (indexes.length > 0) {
            extraInfo.row = indexes[0];
        }
        return [tdata.instance, {locator: def.locator, ...extraInfo}, def];
    }
    getReferenceType (name) {
        return this.getReference(name, {type: false}).type;
    }
    setReference (name, value) {
        let reference = this.getReference(name);
        // TODO: reference not knows operand types
        if (value instanceof Expression) {
            value = value.getAloneOperand();
            if (value instanceof ReferenceItem) {
                if (assert.isEnabled) {
                    assert.ok(!value.next);
                    assert.ok(!value.array);
                }
                const src = this.getReference(value.name);
                if (src.array) {
                    const __array = src.array.getIndexesTypedOffset(value.__indexes);
                    reference.array = __array.array;
                    reference.locator = src.locator + __array.offset;

                } else {
                    reference.array = false;
                    reference.locator = src.locator;
                }
                reference.type = src.type;
                reference.scope = src.scope;
                reference.scopeId = src.scopeId;
            } else if (value instanceof ProofItem) {
                reference.locator = value.id;
                reference.type = value.refType;
                reference.scope = false;
                reference.scopeId = false;
                reference.array = value.array;
            }
        } else if (value instanceof ProofItem) {
            assert.ok(!value.__next);
            reference.locator = value.id;
            reference.type = value.refType;
        } else {
            throw new Error(`Invalid reference`);
        }
    }
    restore (name, reference) {
        this.references[name] = reference;
    }
    set (name, indexes, value) {
        if (Debug.active) console.log('SET', name, indexes, value);
        assert.notStrictEqual(value, null); // to detect obsolete legacy uses

        // getReference produce an exception if name not found
        const reference = this.getReference(name);
        reference.set(value, indexes);
    }
    unset(name) {
        let def = this.references[name];
        if (def.array) delete def.array;
        delete this.references[name];
    }
    unsetProperty(property, values) {
        this.containers.unsetProperty(property, values);
    }
    *[Symbol.iterator]() {
        for (let index in this.references) {
          yield index;
        }
    }

    *keyValuesOfTypes(types) {
        for (let index in this.references) {
            const def = this.references[index];
            if (!types.includes(def.type)) continue;
            yield [index, def];
        }
    }

    *values() {
        for (let index in this.references) {
            yield this.references[index];
        }
    }

    *keyValues() {
        for (let index in this.references) {
            yield [index, this.references[index]];
        }
    }
    dump () {
        for (let name in this.references) {
            const def = this.references[index];
            const indexes = def.array === false ? '': def.multiarray.getLengths().join(',');
        }
    }
}
