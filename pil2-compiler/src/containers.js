const assert = require('./assert.js');
const Context = require('./context.js');
module.exports = class Containers {
    constructor (parent) {
        this.parent = parent;
        this.containers = {};
        this.current = false;
        this.uses = [];
        this.aliases = [];
        this.airGroupContainers = [];
        this.containersStack = [];
    }
    addScopeAlias(alias, value) {
        // NOTE: there is no need to check for aliases because by grammatical definition,
        // aliases must be an identifier

        if (this.aliases[alias]) {
            throw new Error(`Alias ${alias} already defined on ${this.aliases[alias].sourceRef}`);
        }

        Context.scope.addToScopeProperty('aliases', alias);
        this.aliases[alias] = {container: value, sourceRef: Context.sourceRef};
    }
    getAlias(alias, defaultValue) {
        return this.aliases[alias] ?? defaultValue;
    }
    getFromAlias(alias, defaultValue) {
        return this.getAlias(alias, {container: defaultValue}).container;
    }
    unsetAlias(aliases) {
        for (const alias of aliases) {
            assert.defined(this.aliases[alias]);
            delete this.aliases[alias];
        }
    }
    unsetUses(uses) {
        let count = uses.length;
        while (count > 0) {
            const use1 = this.uses.pop();
            const use2 = uses.pop();
            assert.equal(use1, use2);
            --count;
        }
    }
    unsetProperty(property, values) {
        switch (property) {
            case 'aliases': return this.unsetAlias(values);
            case 'uses': return this.unsetUses(values);
        }
        throw new Error(`unsetProperty was called with invalid property ${property}`);
    }
    clearScope(proofScope) {
        // const previousScopes = Object.keys(this.containers).map(name => `${name}(${this.containers[name].scope})`).join();
        this.containers = Object.keys(this.containers)
            .filter(name => this.containers[name].scope !== proofScope)
            .reduce((containers, name) => { containers[name] = this.containers[name]; return containers; }, {});
        // console.log(`clearScope(Container) ${proofScope}: ` + _containers.filter(c => typeof this.containers[c[0]] === 'undefined').map(c => `${c[0]}(${c[1]})`).join(', '));
    }
    pushScope(proofScope) {
        const [remain, save] = Object.entries(this.containers)
            .reduce((res, [name, value]) => { res[value.scope !== proofScope ? 0:1][name] = value; return res }, [{}, {}]);
        this.containers = remain;
        this.containersStack.push(save);
    }    
    popScope() {
        const saved = this.containersStack.pop();
        if (!saved) {
            throw new Error(`No saved containers to pop`);
        }
        for (const [name, value] of Object.entries(saved)) {
            this.containers[name] = value;
        }
    }    
    create(name, alias = false)
    {
        if (this.current !== false) {
            throw new Error(`Container ${this.current} is open, must be closed before start new container`);
        }

        // console.log(`createContainer(${name},${alias}) at ${Context.sourceRef}`);
        // if container is defined, contents is ignored but alias must be defined
        if (alias) {
            this.addScopeAlias(alias, name);
        }        
        
        if (this.isAirGroupContainer(name)) {
            const airGroupId = Context.airGroupId;
            if (typeof this.airGroupContainers[airGroupId] === 'undefined') {
                this.airGroupContainers[airGroupId] = {};
            }
            if (this.airGroupContainers[airGroupId][name]) {
                return false;
            }
            this.airGroupContainers[airGroupId][name] = {scope: this.parent.getNameScope(name), alias, airGroupId: airGroupId, references: {}};            
        } else {
            // console.log(`CREATE CONTAINER ${name}`);
            // if container is defined, contents is ignored
            if (this.containers[name]) {
                return false;
            }

            // const nameInfo = this.decodeName(name).scope;    
            this.containers[name] = {scope: this.parent.getNameScope(name), alias, airGroupId: false, references: {}};
            // console.log(this.containers[name]);
        }
        this.current = name;
        return true;
    }
    isAirGroupContainer(name) {
        return name.startsWith('airgroup.');
    }
    inside() {
        return this.current;
    }
    getCurrent() {
        return this.current;
    }
    getCurrentScope() {
        if (this.current === false) {
            return false;
        }
        return this.get(this.current).scope ?? false;
    }
    close(){
        this.current = false;
    }
    isDefined(name) {
        return this.get(name) !== false;
    }
    get (name) {
        if (this.isAirGroupContainer(name)) {
            const airGroupId = Context.airGroupId;
            return this.airGroupContainers[airGroupId] ? (this.airGroupContainers[airGroupId][name] ?? false) : false;
        }
        return this.containers[name] ?? false;
    }
    addReference(name, reference) {
        if (this.current === false) {
            throw new Error(`Could add reference ${name} to closed container`);
        }
        const container = this.get(this.current);
        // console.log(this.containers);
        // console.log(this.current);
        if (container.references[name]) {
            throw new Error(`Reference ${name} was declared previously on scope ${this.current}`);
        }
        container.references[name] = reference;
    }
    addUse(name, alias = false) {
        if (!this.isDefined(name)) {
            // TODO: defined must be check containers
            throw new Error(`Use not created container ${name}`);
        }
        if (alias !== false && this.getAlias(alias, false)) {
            throw new Error(`Use not created container ${name} with duplicated alias ${alias}`);
        }
        if (alias === false) {
            Context.scope.addToScopeProperty('uses', name);
            this.uses.push(name);
        } else {
            this.addScopeAlias(alias, name);
        }
    }
    getReferenceInside(container, name, defaultValue) {
        return this.#getReference(name, defaultValue, container, false);
    }
    getReferenceInsideCurrent(name, defaultValue) {
        return this.#getReference(name, defaultValue, this.current, false);

    }
    getReference(name, defaultValue) {
        return this.#getReference(name, defaultValue, this.current, true);
    }
    #getReference(name, defaultValue, containerName, uses) {
        // first search on specific container
        let reference = false;
        let container = containerName ? this.get(containerName) : false;
        if (container) {
            return container.references[name] ?? defaultValue;
        }
        if (!uses) return defaultValue; 

        // if not found check other counters indicate with use
        let usesIndex = this.uses.length;
        while (!reference && usesIndex > 0) {
            --usesIndex;
            container = this.get(this.uses[usesIndex]);
            reference = container ? (container.references[name] ?? false) : false;
        }
        return reference ? reference : defaultValue;
    }
    *[Symbol.iterator]() {
        for (let name in this.containers) {
          yield name;
        }
        const airGroupId = Context.airGroupId;
        if (this.airGroupContainers[airGroupId]) {
            for (let name in this.airGroupContainers[airGroupId]) {
                yield name;
            }
        }
    }
}
