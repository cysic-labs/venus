const Performance = require('perf_hooks').performance;
let data, a32, b8;
function test0() {
    let __dbuf = Buffer.alloc(2**22);
    let __dindex = 0;
    let __data = new Uint8Array(__dbuf.buffer, 0, 2**22);
    for(let _v1=0n;_v1<=255n;_v1=_v1+1n) {
        __data[__dindex++] = Number(_v1);
        __dbuf.fill(__dbuf.subarray(__dindex - 1, __dindex), __dindex, __dindex + 255);
        __dindex = __dindex + 255;
    }
    __dbuf.fill(__dbuf.subarray(__dindex - 65536, __dindex), __dindex, __dindex + 4128768);
}
function init(n) {
    data = Buffer.alloc(4 * n);
    a32 = new Uint32Array(data.buffer, 0, n);
    b8 = new Uint8Array(data.buffer, 0, 4 * n);
}
function test1()
{
    init(100000);
    const t1 = Performance.now();
    for (let i = 0; i < 100000; i++) {
        a32[i] = (i + 1);
    }   
    const t2 = Performance.now();
    for (let i = 0; i < 100000; i++) {
        data.writeUInt32BE(i + 2, i * 4);
    }   
    const t3 = Performance.now();
    for (let i = 0; i < 100000; i++) {
        data.writeUInt32LE(i + 3, i * 4);
    }   
    const t4 = Performance.now();
    console.log(t2-t1);
    console.log(t3-t2);
    console.log(t4-t3);
}

function test2()
{
    init(100000);
    const t1 = Performance.now();
    for (let i = 0; i < 400000; i++) {
        b8[i] = (i + 1) & 0xFF;
    }   
    const t2 = Performance.now();
    for (let i = 0; i < 400000; i++) {
        data.writeUInt8((i + 2) & 0xFF, i);
    }   
    const t3 = Performance.now();
    console.log(t2-t1);
    console.log(t3-t2);
}

test0();
/*
test1();
test2();
console.log('b8', b8.length, data.length, b8);

const t1 = Performance.now();
data.fill(data.slice(3, 9), 9, 9 + 50000 * 6);
const t2 = Performance.now();
*/
/*for (i = 0; i < 50000; ++i) {
    data.copy(data, 9 + i * 6, 3, 9);   
}
const t3 = Performance.now();*/
// console.log(t2-t1);
// console.log(t3-t2);

// console.log('b8', b8.length, data.length, b8);
// data.fill()
// console.log('b8', b8.length, data.length, b8);
/*
// Crear un Buffer con datos iniciales (trozo que deseas repetir)
const chunk = Buffer.from([1, 2, 3, 4, 5]);

// Crear un nuevo Buffer que contendrá el trozo repetido n veces
const n = 3;
const repeatedPattern = Buffer.alloc(chunk.length * n);

// Crear un patrón con varias repeticiones
repeatedPattern.fill(chunk);

console.log(repeatedPattern); */
/*
console.log('a32',a32.length, data.length, a32);
console.log('b8',b8.length, data.length, b8);
data.fill(255,2,4);
console.log('a32',a32.length, data.length, a32);
console.log('b8',b8.length, data.length, b8);
*/