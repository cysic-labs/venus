const { assert } = require('chai');
const { execFileSync } = require('child_process');
const path = require('path');

// Runs the .pil through the CLI in an isolated subprocess (Context is a
// per-process singleton). The .pil uses `#pragma test` + assert_eq, so we
// validate the printed summary.
describe("Tables analyze builtins", function () {
    this.timeout(120000);

    it("table_analyze.pil: all assert_eq pass", () => {
        const pil = path.join(__dirname, 'features', 'table_analyze.pil');
        const cli = path.join(__dirname, '..', 'src', 'pil.js');
        let out;
        try {
            out = execFileSync(process.execPath, [cli, pil, '-e', '--asserts'], { encoding: 'utf8' });
        } catch (e) {
            throw new Error('pil2com failed to run:\n' + ((e.stdout || '') + (e.stderr || '')));
        }
        assert.notInclude(out, 'tests FAIL', 'some assert_eq failed:\n' + out);
        assert.include(out, 'All tests passed', 'expected all tests to pass:\n' + out);
    });
});
