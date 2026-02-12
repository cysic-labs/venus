module.exports = class Temporal {
    static config = {
        minArgs: 1,
        maxArgs: 1,
        types: ['fixed'],
        args: [{type: 'num', minValue: 0, maxValue: 2**32-1, defaultValue: 0 }],
        directArg: true,
    }
}
