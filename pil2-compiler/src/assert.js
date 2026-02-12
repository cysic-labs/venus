function equal(actual, expected, message) {
    if (actual == expected) return;
    _message(message, `${actual} not equal ${expected}`, actual);
}

function notEqual(actual, expected, message) {
    if (actual != expected) return;
    _message(message, `${actual} is equal ${expected}`, actual);
}

function strictEqual(actual, expected, message) {
    if (actual === expected) return;
    _message(message, `${actual} not strict equal ${expected}`, actual);
}

function notStrictEqual(actual, expected, message) {
    if (actual !== expected) return;
    _message(message, `${actual} is strict equal ${expected}`, actual);
}

function returnInstanceOf(actual, cls, message) {
    if (actual instanceof cls) return actual;
    if (actual && actual.constructor) {
        return _message(`value(${actual.constructor.name}) isn't an instance of ${cls.name}`, actual);
    }
    _message(message, `value (${typeof actual}) isn't an instance of ${cls.name ?? cls}`, actual);
}

function returnNotInstanceOf(actual, cls, message) {
    if ((actual instanceof cls) === false) return actual;
    if (actual && actual.constructor) {
        return _message(`value(${actual.constructor.name}) is instance of ${cls}`, actual);
    }
    _message(message, `value is an instance of ${cls}`, actual);
}

function returnTypesOf(actual, typename, message) {
    if (!Array.isArray(actual)) {
        _message(message, `value type ${typeof actual} isn't array`, actual);
    }
    if (actual.every((value) => typeof actual === typename)) return actual;
    _message(message, `any value type [${actual.map((value) => typeof value).join()}] isn't type ${typename}`, actual);
}

function returnTypeOf(actual, typename, message) {
    if (typeof actual === typename) return actual;
    _message(message, `value type ${typeof actual} isn't type ${typename}`, actual);
}

function returnNotTypeOf(actual, typename, message) {
    if (typeof actual !== typename) return actual;
    _message(message, `value type ${typeof actual} is type ${typename}`, actual);
}

function typeOf(actual, typename, message) {
    if (typeof actual === typename) return actual;
    _message(message,`value type ${typeof actual} isn't type ${typename}`, actual);
}

function notTypeOf(actual, typename, message) {
    if (typeof actual !== typename) return actual;
    _message(message, `value type ${typeof actual} is type ${typename}`, actual);
}

function _message(message, defaultmsg = false, value = false) {
    if (typeof value === 'object' && (!value || typeof value.toString !== 'function')) {
        console.log(value);
    }
    if (typeof message === 'object') {
        console.log(message);
        debugger;
        throw new Error('ASSERT:' + defaultmsg);
    }
    debugger;
    throw new Error('ASSERT:' + (message ?? defaultmsg));
}

function defined(value, message) {
    if (typeof value !== 'undefined') return true;
    _message(message, 'not defined value', value);
}

function _undefined(value, message) {
    if (typeof value === 'undefined') return true;
    _message(message, `defined value ${value}`, value);
}

function ok(value, message) {
    if (value) return true;
    _message(message, `defined value ${value}`);
}

const _exports = {
    enable,
    disable,
    isEnabled : false,
    equal : () => {},
    notEqual : () => {},
    strictEqual : () => {},
    notStrictEqual : () => {},
    defined : () => {},
    undefined : () => {},
    returnInstanceOf : (value) => value,
    instanceOf : () => {},
    returnNotInstanceOf : (value) => value,
    notInstanceOf : () => {},
    typeOf : () => {},
    notTypeOf : () => {},
    returnTypeOf : (value) => value,
    returnTypesOf : (value) => value,
    returnNotTypeOf : (value) => value,
    ok : () => {},
}

function enable(value = true) {
    if (!value) return disable();

    _exports.isEnabled = true;
    _exports.equal = equal;
    _exports.notEqual = notEqual;
    _exports.strictEqual = strictEqual;
    _exports.notStrictEqual = notStrictEqual;
    _exports.defined = defined;
    _exports.undefined = _undefined;
    _exports.returnInstanceOf = returnInstanceOf;
    _exports.instanceOf = returnInstanceOf;
    _exports.returnNotInstanceOf = returnNotInstanceOf;
    _exports.notInstanceOf = returnNotInstanceOf;
    _exports.typeOf = typeOf;
    _exports.notTypeOf = notTypeOf;
    _exports.ok = ok;
    _exports.returnTypeOf = returnTypeOf;
    _exports.returnTypesOf = returnTypesOf;
    _exports.returnNotTypeOf = returnNotTypeOf;
    _showState();
}

function disable() {
    _exports.isEnabled = false;
    _exports.equal = () => {};
    _exports.notEqual = () => {};
    _exports.strictEqual = () => {};
    _exports.notStrictEqual = () => {};
    _exports.defined = () => {};
    _exports.undefined = () => {};
    _exports.returnInstanceOf = (value) => value;
    _exports.instanceOf = () => {};
    _exports.returnNotInstanceOf = (value) => value;
    _exports.notInstanceOf = () => {};
    _exports.typeOf = () => {};
    _exports.notTypeOf = () => {};
    _exports.ok = () => {};
    _exports.returnTypeOf = (value) => value;
    _exports.returnTypesOf = (value) => value;
    _exports.returnNotTypeOf = (value) => value;
    _showState();
}

function _showState() {
    console.log('ASSERT STATE: '+(_exports.isEnabled ? '\x1B[1;32mON':'\x1B[1;31mOFF')+'\x1B[0m');
}

module.exports = _exports;
