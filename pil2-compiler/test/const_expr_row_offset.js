const { assert } = require('chai');
const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const protobuf = require('protobufjs');

// A row offset applied to a `const expr` is only visible in the generated
// pilout: the reference carries it and the packer has to emit an instance of the
// expression shifted by it. Running the .pil with `-e` never reaches the packer,
// so this spec compiles it and reads the emitted constraints back.

const PIL = path.join(__dirname, 'bug', 'const_expr_row_offset.pil');
const PILOUT = path.join(__dirname, '..', 'tmp', 'const_expr_row_offset.pilout');

function compile() {
    const compiler = path.join(__dirname, '..', 'src', 'pil.js');
    fs.mkdirSync(path.dirname(PILOUT), { recursive: true });
    try {
        execFileSync(process.execPath, [compiler, PIL, '-o', PILOUT], { encoding: 'utf8' });
    } catch (error) {
        throw new Error(`compiling ${PIL} failed:\n${(error.stdout || '') + (error.stderr || '')}`);
    }
}

function loadPilout() {
    const proto = path.join(__dirname, '..', 'src', 'pilout.proto');
    const PilOut = protobuf.loadSync(proto).lookupType('PilOut');
    return PilOut.toObject(PilOut.decode(fs.readFileSync(PILOUT)));
}

/** Every column an expression reads, with the row offset it reads it at. */
function columnsByRowOffset(expressions, idx, seen = new Set()) {
    if (seen.has(idx)) {
        throw new Error(`circular reference on expression ${idx}`);
    }
    seen.add(idx);
    const expression = expressions[idx];
    const operation = Object.keys(expression)[0];
    const data = expression[operation];
    const operands = operation === 'neg' ? [data.value] : [data.lhs, data.rhs];
    const counts = {};
    for (const operand of operands) {
        const kind = Object.keys(operand)[0];
        if (kind === 'expression') {
            // an intermediate: inline it, its leaves are the ones that count
            const inner = columnsByRowOffset(expressions, operand.expression.idx, seen);
            for (const [offset, count] of Object.entries(inner)) {
                counts[offset] = (counts[offset] ?? 0) + count;
            }
        } else if (['witnessCol', 'fixedCol', 'periodicCol', 'customCol'].includes(kind)) {
            const offset = operand[kind].rowOffset ?? 0;
            counts[offset] = (counts[offset] ?? 0) + 1;
        }
    }
    seen.delete(idx);
    return counts;
}

function airColumnsByRowOffset(pilout, airName) {
    for (const airGroup of pilout.airGroups ?? []) {
        for (const air of airGroup.airs ?? []) {
            if (air.name !== airName) continue;
            assert.lengthOf(air.constraints ?? [], 1, `${airName} should hold a single constraint`);
            const constraint = air.constraints[0];
            const kind = Object.keys(constraint)[0];
            return columnsByRowOffset(air.expressions, constraint[kind].expressionIdx.idx);
        }
    }
    throw new Error(`air ${airName} not found in the pilout`);
}

describe("A row offset on a const expr reaches the pilout", function () {
    this.timeout(120000);

    let pilout;
    before(() => {
        compile();
        pilout = loadPilout();
    });

    it("keeps the shifted copy of `s - 's`", () => {
        // 2 columns read at the current row, the same 2 read at the previous one
        assert.deepEqual(airColumnsByRowOffset(pilout, 'OneLevel'), { 0: 2, '-1': 2 });
    });

    it("shifts a const expr nested inside another one", () => {
        // `outer` reads 4 columns, so `'outer` has to read the same 4 shifted:
        // leaving the nested `inner` unshifted would show up as 6 and 2
        assert.deepEqual(airColumnsByRowOffset(pilout, 'Nested'), { 0: 4, '-1': 4 });
    });

    // This is the case that regressed: before the fix the packer reused the
    // unshifted instance for every offset, so all six reads landed on row 0.
    it("keeps one instance per offset of `(i)'g`", () => {
        assert.deepEqual(airColumnsByRowOffset(pilout, 'A_NoFactor'), { 0: 2, '-1': 2, '-2': 2 });
    });
});
