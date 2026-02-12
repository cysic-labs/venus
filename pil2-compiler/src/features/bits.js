module.exports = class Bits {
    static config = {
        minArgs: 1,
        maxArgs: 2,
        types: ['witness'],
        args: [{type: 'num', minValue: 1, maxValue: 64}, {type: 'option',values: ['unsigned', 'signed'], defaultValue: 'unsigned'}],
    }
}
