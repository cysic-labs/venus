const fs = require("fs");
const BigBuffer = require("./big_buffer");

function generateMultiArrayIndexes(symbols, name, lengths, polId, stage, indexes = []) {
    if (indexes.length === lengths.length) {
        symbols.push({ name, lengths: indexes, id: polId, stage, });
        return polId + 1;
    }

    for (let i = 0; i < lengths[indexes.length]; i++) {
        polId = generateMultiArrayIndexes(symbols, name, lengths, polId, stage, [...indexes, i]);
    }

    return polId; 
}

function setValueMultiArray(arr, indexes, value) {
    if (indexes.length === 1) {
        arr[indexes[0]] = value;
    } else {
        const nextIndex = indexes[0];
        if (!Array.isArray(arr[nextIndex])) arr[nextIndex] = [];
        setValueMultiArray(arr[nextIndex], indexes.slice(1), value);
    } 
}
    
module.exports.generateFixedCols = function generateFixedCols(symbols, degree) {
    const fixedSymbols = [];
    const nSymbols = symbols.length;
    for (let i = 0; i < nSymbols; ++i) {
        const symbol = symbols[i];
        const name = symbol.name;
        const stage = symbol.stage;
        const id = symbol.id;
        const lengths = (symbol.lengths || []);
        if((stage !== 0 || symbol.type !== 1)) continue;
        if(!lengths.length) {
            fixedSymbols.push({name, id, stage, lengths});
        } else {
            generateMultiArrayIndexes(fixedSymbols, name, lengths, id, stage);
        }
    }
    
    const fixedCols = new ColsPil2(fixedSymbols, degree);
    return fixedCols;
}

class ColsPil2 {
    constructor(symbols, degree) {
        this.$$def = {};
        this.$$defArray = [];

        this.$$n = degree;
        this.$$nCols = symbols.length;
        this.$$buffer = [];
                    
        this.$$buffer = new BigBuffer(this.$$nCols*this.$$n);

        this.symbols = symbols;
        for(let i = 0; i < symbols.length; ++i) {
            const symbol = symbols[i];
            const name = symbol.name;
            const [nameSpace, namePol] = name.split(".");
            if (!this[nameSpace]) this[nameSpace] = {};
            if (!this.$$def[nameSpace]) this.$$def[nameSpace] = {};
            
            const polProxy = this.createArrayProxy(symbol.id);

            this.$$defArray[symbol.id] = {
            name: name,
            id: symbol.id,
            stage: symbol.stage,
            polDeg: degree,
            lengths: symbol.lengths
            };

            if (symbol.lengths.length > 0) {
                if (!this[nameSpace][namePol]) this[nameSpace][namePol] = [];
                if (!this.$$def[nameSpace][namePol]) this.$$def[nameSpace][namePol] = [];
                setValueMultiArray(this[nameSpace][namePol], symbol.lengths, polProxy);
                setValueMultiArray(this.$$def[nameSpace][namePol], symbol.lengths, this.$$defArray[symbol.id]);
            } else {
                this[nameSpace][namePol] = polProxy;
                this.$$def[nameSpace][namePol] = this.$$defArray[symbol.id];
            }
            this[symbol.id] = polProxy;
        }
    }

    createArrayProxy(symbolId) {
          
        const nCols = this.$$nCols;
        const buff = this.$$buffer;
        const N = this.$$n;

        return new Proxy([], {
            set(target, prop, value) {
                const pos = parseInt(prop, 10);
                const buffIndex = nCols * pos + symbolId;
                
                if(value < 0n) value += 0xFFFFFFFF00000001n;

                buff.setElement(buffIndex,value);
                
                target[pos] = value; // This adds the value to the array itself
                
                return true;
            },

            get(target, prop) {
                if (prop === 'length') {
                    return N; // Return the degree for 'length' property
                }
                const pos = parseInt(prop, 10);
                const buffIndex = nCols * pos + symbolId;
                return buff.getElement(buffIndex);
            }
        });
    }

    async saveToFile(fileName) {
        const fd =await fs.promises.open(fileName, "w+");

        const MaxBuffSize = 1024*1024*32;  //  256Mb
        const totalSize = this.$$nCols*this.$$n;
        const buff = new BigUint64Array(Math.min(totalSize, MaxBuffSize));

        let p=0;
        for (let i=0; i<totalSize; i++) {
            buff[p++] = (this.$$buffer.getElement(i) < 0n) ? (this.$$buffer.getElement(i) + 0xffffffff00000001n) : this.$$buffer.getElement(i);
            if (p == buff.length) {
                const buff8 = new Uint8Array(buff.buffer);
                await fd.write(buff8);
                p=0;
            }
            
        }

        if (p) {
            const buff8 = new Uint8Array(buff.buffer, 0, p*8);
            await fd.write(buff8);
        }

        await fd.close();
    }

    async loadFromFile(fileName) {

        const fd =await fs.promises.open(fileName, "r");
        
        const MaxBuffSize = 1024*1024*32;  //  256Mb
        const totalSize = this.$$nCols*this.$$n;
        const buff = new BigUint64Array(Math.min(totalSize, MaxBuffSize));
        const buff8 = new Uint8Array(buff.buffer);

        let i=0;
        let p=0;
        let n;
        for (let k=0; k<totalSize; k+= n) {
            console.log(`loading ${fileName}.. ${k/1024/1024} of ${totalSize/1024/1024}` );
            n= Math.min(buff.length, totalSize-k);
            const res = await fd.read({buffer: buff8, offset: 0, position: p, length: n*8});
            if (n*8 != res.bytesRead) console.log(`n: ${n*8} bytesRead: ${res.bytesRead} div: ${res.bytesRead/8}`);
            n = res.bytesRead/8;
            p += n*8;
            for (let l=0; l<n; l++) {
                this.$$buffer.setElement(i++, buff[l]);
            }
        }

        await fd.close();
    }

    writeToBigBuffer(buff, nCols) {
        if(!nCols) nCols = this.$$nCols;
        if (typeof buff == "undefined") {
            buff = new BigBuffer(this.$$n*nCols);
        }
        let p=0;
        for (let i=0; i<this.$$n; i++) {
            for(let j = 0; j < this.$$nCols; ++j) {
                let c = i*this.$$nCols + j;
                const value = (this.$$buffer.getElement(c) < 0n) ? (this.$$buffer.getElement(c) + 0xFFFFFFFF00000001n) : this.$$buffer.getElement(c);
                buff.setElement(p++, value);
            }
            for(let j = this.$$nCols; j < nCols; ++j) buff.setElement(p++, 0n);

        }
        return buff;
    };

    writeToBuff(buff) {
        buff = this.$$buffer;
        return buff;
    }
}



