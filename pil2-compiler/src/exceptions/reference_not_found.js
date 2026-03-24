module.exports = class ReferenceNotFound extends Error {
    constructor (name, options) {
        if (options.sourceTag) {
            super('Error reference '+name+' not found at '+options.sourceTag);
        } else {
            super('Error reference '+name+' not found');
        }
    }
}