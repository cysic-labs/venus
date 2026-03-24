const chai = require("chai");
const { F1Field } = require("ffjavascript");
const assert = chai.assert;
const compile = require("../../src/compiler.js");

const testCycle = function (name, col, expected, times = 1, N = 2**7) {

    assert.equal(col.length, N, `${name} length`);
    for (let index = 0; index < N; ++index) {
        const eindex = Math.floor(index / times) % expected.length;
        assert.strictEqual(col[index], BigInt(expected[eindex]), `${name}[${index}]`);
    }
}

describe("Expressions Test", async function () {

    const F = new F1Field(0xffffffff00000001n);
    this.timeout(10000000);

    it("Test Expressions", async () => {
        const processor = await compile(F, __dirname + "/expr.pil", null, { processorTest: true, proto: false });

        const N = 2 ** 7;
        const empty = new Array(N).fill(0);

    });

});
