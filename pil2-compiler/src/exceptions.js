const CannotBeCastToType = require('./exceptions/cannot_be_cast_to_type.js');
const ReferenceNotFound = require('./exceptions/reference_not_found.js');
const ReferenceNotVisible = require('./exceptions/reference_not_visible.js');
class OutOfBounds extends Error {};
class OutOfDims extends Error {};
class Runtime extends Error {};

const Exceptions = {
    CannotBeCastToType,
    ReferenceNotFound,
    ReferenceNotVisible,
    OutOfBounds,
    OutOfDims,
    Runtime
}
module.exports = Exceptions;
