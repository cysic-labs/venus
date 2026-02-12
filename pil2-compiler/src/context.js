const assert = require('./assert.js');

const _noContextInstance = {
    _processor: {
        sourceRef: ''
    }
};

module.exports = class Context {
    static _instance = _noContextInstance;

    constructor (Fr, processor, config = {}) {
        assert.equal(Context._instance, _noContextInstance);
        Context._instance = this;
        this.Fr = Fr;
        this._processor = processor;
        this.namespace = '';
        this.namespaceStack = [];
        this.config = {debug: {}, test: {}, ...config};
        this.uses = [];
        this.tests = {};
        this.seqCodeType = config.seqCodeType ?? 'fast';
        this._airGroupName = false;
        if (typeof this.config.test.onContextInit === 'function') {
            this.config.test.onContextInit(Context, this);
        }
    }
    static memoryUpdate() {
        this._instance._processor.memoryUpdate();
    }
    static get SeqCodeType() {
        return this._instance.seqCodeType;
    }
    static set SeqCodeType(value) {
        this._instance.seqCodeType = value;
    }
    static get rows() {
        return this._instance._processor.rows;
    }
    static get air() {
        return  this._instance._processor.airStack.at(-1) ?? false;
    }
    static get airId() {
        const air = this.air;
        return air ? air.id : false;
    }
    static get airName() {
        const air = this.air;
        return air ? air.name : '';
    }
    static get rows() {
        const air = this.air;
        return air ? air.rows : false;
    }

    static get Fr() {
        return this._instance.Fr;
    }
    static get config() {
        return this._instance.config;
    }
    static get tests() {
        return this._instance.tests;
    }
    static get airGroupName() {
        return this._instance._airGroupName;
    }
    static get expressions() {
        return this._instance._processor.expressions;
    }
    static get runtime() {
        return this._instance._processor.runtime;
    }
    static get scope() {
        return this._instance._processor.scope;
    }
    static get sourceRef() {
        return this._instance._processor.sourceRef;
    }
    static get sourceTag() {
        return this._instance._processor.sourceRef.split('/').slice(-2).join('/');
    }
    static get processor() {
        return this._instance._processor;
    }
    static get current() {
        return this._instance;
    }
    static get references() {
        return this._instance._processor.references;
    }
    static get fileDir() {
        return this.processor.compiler.fileDir;
    }
    static get basePath() {
        return this.processor.compiler.basePath;
    }
    static get fullFilename() {
        return this.processor.compiler.getFullFilename(this._instance._processor.sourceRef.split(':')[0]);
    }
    static get proofLevel() {
        if (this.airName) {
            return `AIR:${this.airName}`;
        }
        if (this._airGroupName) {
            return `AIRGROUP:${this._airGroupName}`;
        }
        return 'PROOF';
    }
    static get outputDir() {
        return Context.applyTemplates(Context._instance.config.outputDir ?? '');
    }
    static get fixedOutputDir() {

        return Context.applyTemplates(Context._instance.config.fixedOutputDir ?? 
                Context._instance.config.outputDir ?? '');
    }
    static get inputDir() {
        return Context.applyTemplates(Context._instance.config.inputDir ?? '');
    }
    static applyTemplates(value) {
        return this._instance.applyTemplates(value);
    }
    static getFullName(name, options = {}) {
        return this._instance._getFullName(name, options);
    }
    getNamespace() {
        return this.namespace;
    }
    addUses(scope) {
        this.uses.push(scope);
    }
    clearUses() {
        this.uses = [];
    }
    applyTemplates(value) {
        if (!value.includes('${')) return value;
        return this._processor.evaluateTemplate(value);
    }
    getNames(name, options = {}) {
        if (typeof name.name !== 'undefined') {
            throw new Error('Invalid name used on getNames');
        }

        let names = name;
        if (typeof name === 'string') {
            names = [name];
        }
        names = names.map(name => this.applyTemplates(name));
        if (!Array.isArray(names) || names.length !== 1) {
            return names;
        }
        name = names[0];

        // check if exists a forced name (by container, options, etc..)
        const forcedFullName = this._getForcedFullName(name, options);
        if (forcedFullName === false && this.namespaceStack.length > 0) {
            // if no forced name, add all stack namespaces (airgroup, air,...)
            for (const ns of this.namespaceStack) {
                const additionalName = ns + '.' + name;
                if (names.includes(additionalName)) continue;
                names.push(additionalName);
            }
            return names;
        }
        if (forcedFullName === false) {
            return [name];
        }
        return name === forcedFullName ? [name]:[name, forcedFullName];
    }
    decodeName(name) {
        const regex = /((?<air>\w*)::)?((?<namespace>\w*)\.)?(?<name>\w+)/gm;

        let m;

        while ((m = regex.exec(name)) !== null) {
            // This is necessary to avoid infinite loops with zero-width matches
            if (m.index === regex.lastIndex) {
                regex.lastIndex++;
            }
            return [m.groups.air, m.groups.namespace, m.groups.name];
        }
    }
    _getForcedFullName(name, options = {}) {
        if (typeof name !== 'string') {
            throw new Error(`getFullName invalid argument`);
        }
        name = this.applyTemplates(name);
        if (this._processor.references.insideContainer) {
            return name;
        }

        const parts = name.split('.');

        if (parts.length === 1 && options.namespace) {
            return options.namespace + '.' + name;
        }
        if (parts.length > 1) {
            return name;
        }
        return false;
    }
    _getFullName(name, options = {}) {
        const res = this._getForcedFullName(name, options);
        if (res !== false) {
            return res;
        }
        if (this.namespace !== false && this.namespace !== '') {
            name = this.namespace + '.' + name;
        }
        return name;
    }
    push(namespace) {
        if (namespace === false) {
            throw new Error('Invalid namespace');
        }
        this.namespaceStack.push(namespace);
        this.namespace = namespace;
    }
    pop() {
        this.namespaceStack.pop();
        this.namespace = this.namespaceStack.length ? this.namespaceStack[this.namespaceStack.length - 1] : '';
    }
}
