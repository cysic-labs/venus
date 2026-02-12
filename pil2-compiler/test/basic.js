const chai = require("chai");
const { F1Field } = require("ffjavascript");
const assert = chai.assert;
const compile = require("../src/compiler.js");
const CompilerTest = require('./compiler_test.js');
const debugConsole = require('../src/debug_console.js').init();

class ExpressionCompilerTest extends CompilerTest {
    onSubproofEnd() {
    }
}

describe("Sequences tests", async function () {

    const F = new F1Field(0xffffffff00000001n);
    this.timeout(10000000);

    it("Test Sequence.pil", async () => {
        const compilerTest = new ExpressionCompilerTest();
        compile(F, __dirname + '/basic.pil', null, { test: compilerTest, compileFromString: false});
//        compile(F, 'subproof Main(2**23) {\nexpr cols[3];col witness a;col witness b;col witness c;\ncols[0] = a;\ncols[1] = b;\ncols[2] = c;\n'+
//                   'cols[0] * (1 - cols[0]) === 0;\n'+
//                   'cols[0] * (1 - cols[0]) * (2 - cols[0]) === 0;\n}' , null, { test: compilerTest, compileFromString: true });
//        compile(F, 'subproof Main(2**23) {\ncol witness a;col witness b;\n'+
//                   'expr res = 0;\n#pragma dump res\n;res = res + 2 * a;\n#pragma dump res\nres = res + 4 * b;\n#pragma dump res\nres === 0\n;#pragma dump res\n;}' , null, { test: compilerTest, compileFromString: true});
    });

});
