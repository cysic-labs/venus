const chai = require("chai");
const { F1Field } = require("ffjavascript");
const assert = chai.assert;
const compile = require("../../src/compiler.js");
const CompilerTest = require('../compiler_test.js');

class SequencesCompilerTest extends CompilerTest {
    onAirEnd(processor) {
        const N = 2 ** 7;
        const empty = new Array(N).fill(0);

        this.verifyFixedCycle('BASIC2',[1,2,2,3,3,3,4,4,4,4,5,5,5,5,5]);

        // col fixed BYTE_C4096 = [0:3..13:3]...;
        this.verifyFixedCycle('BYTE_C4096', [0,1,2,3,4,5,6,7,8,9,10,11,12,13], 3);

        // col fixed ODDS = [23,15,13..+..9]...;
        this.verifyFixedCycle('ODDS', [23,15,13,11,9]);

        // col fixed X__ = [13,39..*..1053]...;
        this.verifyFixedCycle('X__', [13,39,13*(3**2),13*(3**3),13*(3**4)]);

        // col fixed X__2 = [13,39..*..(13*3**31)]...;
        this.verifyFixedCycle('X__2', [13,39,13*(3**2),13*(3**3),13*(3**4),13*(3**5),13*(3**6),13*(3**7),13*(3**8),13*(3**9),
                    13*(3**10),13*(3**11),13*(3**12),13*(3**13),13*(3**14),13*(3**15),13*(3**16),13*(3**17),
                    13*(3**18),13*(3**19),13*(3**20),13*(3**21),13*(3**22),13*(3**23),13*(3**24),13*(3**25),
                    13*(3**26),13*(3**27),13*(3**28),13*(3**29),13*(3**30),13*(3**31)]);

        // col fixed FACTOR = [1,2..*..512]...;
        this.verifyFixedCycle('FACTOR', [1,2,4,8,16,32,64,128,256,512]);

        // col fixed ODDS_F = [1,3..+..];
        this.verifyFixedCycle('ODDS_F', empty.map((x, index) => 1n + 2n*BigInt(index)));

        // col fixed FACTOR_F = [1,2..*..];
        this.verifyFixedCycle('FACTOR_F', empty.map((x, index) => 2n ** BigInt(index)));

        // col fixed ODDS_R = [1:10,3:10..+..13:10]...;
        this.verifyFixedCycle('ODDS_R', [1,3,5,7,9,11,13],10);

        // col fixed FACTOR_R = [1:2,2:2..*..16:2]...;
        this.verifyFixedCycle('FACTOR_R', [1,2,4,8,16],2);

        // col fixed FACTOR_R2 = [1:10,2:10..*..512:10]...;
        this.verifyFixedCycle('FACTOR_R2', [1,2,4,8,16,32,64,128,256,512], 10);

        // col fixed ODDS_RF = [1:10,3:10..+..];
        this.verifyFixedCycle('ODDS_RF', empty.map((x, index) => 1n + 2n * BigInt(index)), 10);

        // col fixed FACTOR_RF = [1:10,2:10..*..];
        this.verifyFixedCycle('FACTOR_RF', empty.map((x, index) => 2n ** BigInt(index)), 10);

        // col fixed R_FACTOR_R = [16:2,8:2..*..1:2]...;
        this.verifyFixedCycle('R_FACTOR_R', [16,8,4,2,1], 2);

        // col fixed R_FACTOR_R1 = [16,8..*..1]:16...;
        this.verifyFixedCycle('R_FACTOR_R1', [16,8,4,2,1]);

        // col fixed R_FACTOR_R2 = [16:2,8:2..*..1:2]:10...;
        this.verifyFixedCycle('R_FACTOR_R2', [16,8,4,2,1], 2);

        // col fixed R_FACTOR_RF = [8192:10,4096:10..*..];
        this.verifyFixedCycle('R_FACTOR_RF', [8192,4096,2048,1024,512,256,128,64,32,16,8,4,2,1], 10);
    }
}

describe("Sequences tests", async function () {

    const F = new F1Field(0xffffffff00000001n);
    this.timeout(10000000);

    it("Test Sequence.pil", async () => {
        const compilerTest = new SequencesCompilerTest();
        compile(F, __dirname + "/sequence.pil", null, { test: compilerTest });

        const N = 2 ** 7;
        const empty = new Array(N).fill(0);

        // col fixed BASIC = [1:1,2:2,3:3,4:4,5:5];

        /*const BASIC = processor.fixeds.values[0].sequence.values;
        assert.equal(BASIC.length, 15);
        assert.equal(BASIC.toString(), "1,2,2,3,3,3,4,4,4,4,5,5,5,5,5");*/

        //  col fixed BASIC2 = [1:1,2:2,3:3,4:4,5:5]...;
    });

});
