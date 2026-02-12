module.exports = class Stage {
    static config = {
        minArgs: 1,
        maxArgs: 1,      
        types: ['fixed', 'witness', 'custom'],  
        args: [{type: 'num', minValue: 0, maxValue: 100, defaultValue: 0 }],
        directArg: true,
    }
}
