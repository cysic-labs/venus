const { FIELD_EXTENSION } = require("../../../constants.js");

module.exports.getExpDim = function getExpDim(expressions, expId) {

    return _getExpDim(expressions[expId]);

    function _getExpDim(exp) {
        if(typeof(exp.dim) !== "undefined") {
            return exp.dim; 
        } else if(["add", "sub", "mul"].includes(exp.op)) {
            return Math.max(...exp.values.map(v => _getExpDim(v)));
        } else if (exp.op === "exp") {
            exp.dim = _getExpDim(expressions[exp.id]);
            return exp.dim;
        } else if (exp.op === "cm" || exp.op === "custom") {
            return exp.dim || 1;
        } else if (["const", "number", "public", "Zi"].includes(exp.op)) {
            return 1;
        } else if (["challenge", "eval", "xDivXSubXi"].includes(exp.op)) {
            return FIELD_EXTENSION;
        } else throw new Error("Exp op not defined: " + exp.op);
    }
}

module.exports.addInfoExpressions = function addInfoExpressions(expressions, exp) {
    if("expDeg" in exp) return;
    
    if("next" in exp) {
        exp.rowOffset = exp.next ? 1 : 0;
        delete exp.next;
    }

    if (exp.op == "exp") {
        addInfoExpressions(expressions, expressions[exp.id]);
        exp.expDeg = expressions[exp.id].expDeg;
        exp.rowsOffsets = expressions[exp.id].rowsOffsets;
        if(!exp.dim) exp.dim = expressions[exp.id].dim;
        if(!exp.stage) exp.stage = expressions[exp.id].stage;

        if(["cm", "const", "custom"].includes(expressions[exp.id].op)) {
            exp = expressions[exp.id];
        }

    } else if (["cm", "custom", "const"].includes(exp.op) || (exp.op === "Zi" && exp.boundary !== "everyRow")) {
        exp.expDeg = 1;
        if(!exp.stage || exp.op === "const") exp.stage = exp.op === "cm" ? 1 : 0;
        if(!exp.dim) exp.dim = 1; 

        if("rowOffset" in exp) {
            exp.rowsOffsets = [exp.rowOffset];
        }
    } else if(exp.op === "xDivXSubXi") {
        exp.expDeg = 1;
    } else if (["challenge", "eval"].includes(exp.op)) {
        exp.expDeg = 0;
        exp.dim = FIELD_EXTENSION;
    } else if(exp.op === "airgroupvalue" || exp.op === "proofvalue") {
        exp.expDeg = 0;
        if(!exp.dim) exp.dim = exp.stage != 1 ? FIELD_EXTENSION : 1; 
    } else if (exp.op === "airvalue") {
        exp.expDeg = 0;
        if(!exp.dim) exp.dim = exp.stage != 1 ? FIELD_EXTENSION : 1; 
    } else if (exp.op === "public") {
        exp.expDeg = 0;
        exp.stage = 1; 
        if(!exp.dim) exp.dim = 1;
    } else if (exp.op === "number" || (exp.op === "Zi" && exp.boundary === "everyRow")) {
        exp.expDeg = 0;
        exp.stage = 0; 
        if(!exp.dim) exp.dim = 1;
    } else if(["add", "sub", "mul", "neg"].includes(exp.op)) {
        if(exp.op === "neg") {
            exp.op = "mul";
            exp.values = [{op: "number", value: "18446744069414584320", expDeg: 0, stage: 0, dim: 1}, exp.values[0]];
        }
        const lhsValue = exp.values[0];
        const rhsValue = exp.values[1];
        if(["add"].includes(exp.op) && lhsValue.op === "number" && BigInt(lhsValue.value) === 0n) {
            exp.op = "mul";
            lhsValue.value = "1";
        }
        if(["add", "sub"].includes(exp.op) && rhsValue.op === "number" && BigInt(rhsValue.value) === 0n) {
            exp.op = "mul";
            rhsValue.value = "1";
        }
        addInfoExpressions(expressions, lhsValue);
        addInfoExpressions(expressions, rhsValue);

        const lhsDeg = lhsValue.expDeg;
        const rhsDeg = rhsValue.expDeg;
        exp.expDeg = exp.op === "mul" ? lhsDeg + rhsDeg : Math.max(lhsDeg, rhsDeg);

        exp.dim = Math.max(lhsValue.dim,rhsValue.dim);
        exp.stage = Math.max(lhsValue.stage,rhsValue.stage);

        const lhsRowOffsets = lhsValue.rowsOffsets || [0];
        const rhsRowOffsets = rhsValue.rowsOffsets || [0];
        exp.rowsOffsets = [...new Set([...lhsRowOffsets, ...rhsRowOffsets])];
    } else {
        throw new Error("Exp op not defined: "+ exp.op);
    }

    return;
}

module.exports.addInfoExpressionsSymbols = function addInfoExpressionsSymbols(evMap, symbols, expressions, exp) {
    if (exp.explored) return;
    if (exp.op == "exp") {
        addInfoExpressionsSymbols(evMap, symbols, expressions, expressions[exp.id]);
        exp.explored = true;
    } else if (["cm", "const", "custom"].includes(exp.op)) {
        let newItem;
        if(exp.op === "cm") {
            newItem = { type: "cm", id: exp.id, prime: exp.rowOffset };
        } else if(exp.op === "const") {
            newItem = { type: "const", id: exp.id, prime: exp.rowOffset };
        } else {
            newItem = { type: "custom", id: exp.id, prime: exp.rowOffset, commitId: exp.commitId };
        }
        
        // Check if item is already contained in evMap
        const isAlreadyContained = evMap.some(item => 
            item.type === newItem.type && 
            item.id === newItem.id && 
            item.prime === newItem.prime &&
            (newItem.commitId === undefined || item.commitId === newItem.commitId)
        );
        
        if (!isAlreadyContained) {
            evMap.push(newItem);
        }
    } else if(["add", "sub", "mul", "neg"].includes(exp.op)) {       
        addInfoExpressionsSymbols(evMap, symbols, expressions, exp.values[0]);
        addInfoExpressionsSymbols(evMap, symbols, expressions, exp.values[1]);
        exp.explored = true;
    }

    return;
}
