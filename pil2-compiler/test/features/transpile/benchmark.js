let N = 2 ** 22;
let A = [];
let B = [];
let CIN = [];
let LAST = [];
let USE_CARRY = [];
let OP = [];

const CIN_CYCLE_P1 = 11 * 2 * (2 ** 16) * 2;
const CIN_CYCLE_P2 = 4 * (2 ** 17);
const CIN_CYCLE = CIN_CYCLE_P1 + CIN_CYCLE_P2;

const LAST_CYCLE_P1 = 11 * (2 ** 17) * 2;
const LAST_CYCLE_P2 = 4 * (2 ** 17);
const LAST_CYCLE = LAST_CYCLE_P1 + LAST_CYCLE_P2;

const USE_CARRY_CYCLE_P1 = (2 ** 18) * 2;
const USE_CARRY_CYCLE_P2 = 9 * (2 ** 17) * 2;
const USE_CARRY_CYCLE_P3 = 4 * (2 ** 17);
const USE_CARRY_CYCLE = USE_CARRY_CYCLE_P1 + USE_CARRY_CYCLE_P2 + USE_CARRY_CYCLE_P3;

const OP_CYCLE_P1 = 11 * (2 ** 18);
const OP_CYCLE_P2 = 4 * (2 ** 17);
const OP_CYCLE = OP_CYCLE_P1 + OP_CYCLE_P2;

/*
    col fixed A = [0..255]...;                        // Input A    (8 bits)

    col fixed B = [0:P2_8..255:P2_8]...;              // Input B    (8 bits)

    col fixed CIN = [[0:P2_16,1:P2_16]:(11*2),
                      0:(P2_17*4)]...;

    col fixed LAST = [[0:P2_17, 1:P2_17]:11,
                      [0:P2_16, 1:P2_16]:4]...;       // Last byte  (1 bits)

    col fixed USE_CARRY = [0:(P2_18*2),              // USE_CARRY(ADD,SUB) = 0
                          [0:P2_17, 1:P2_17]:9,      // USE_CARRY(LTU,LT,LEU,LE,EQ,MINU,MIN,MAXU,MAX) = LAST (i.e., only when LAST == 1)
                           0:(P2_17*4)]...;          // USE_CARRY(AND,OR,XOR,EXT_32) = 0

    col fixed OP = [2:P2_18..12:P2_18,
                    32:P2_17..35:P2_17]...;
*/

for (let index = 0; index < N; ++index) {
    const _index = BigInt(index);
    A[index] = _index & 0xFFn;
    B[index] = (_index >> 8n) & 0xFFn;

    const _cin_index = index % CIN_CYCLE;
    CIN[index] = BigInt(_cin_index < CIN_CYCLE_P1 ? (_cin_index >> 16) & 0x1 : 0);

    const _last_index = index % LAST_CYCLE;
    LAST[index] = BigInt(_last_index < LAST_CYCLE_P1 ? (_last_index >> 17) & 0x1 : 0);

    const _use_carry_index = index % USE_CARRY_CYCLE;
    USE_CARRY[index] = BigInt((_use_carry_index < USE_CARRY_CYCLE_P1 || _use_carry_index >= USE_CARRY_CYCLE_P3) ? 0 : (_last_index >> 17) & 0x1);

    const _op_index = index % OP_CYCLE;
    OP[index] = BigInt(_op_index < OP_CYCLE_P1 ? 2 + (_op_index >> 18) : (32 + ((_op_index - OP_CYCLE_P1) >> 17)));
    if (OP[index] > 35) {
        console.log([_op_index, OP_CYCLE, OP_CYCLE_P1, OP_CYCLE_P2, OP[index]]);
    }
}


let C = [];                                      // Output C   (8 bits)
let COUT = [];                                  // CarryOut   (1 bits)
let FLAGS = [];
for (let i = 0; i < N; i++) {
    let [plast, op, a, b, cin, c, cout] = [LAST[i], OP[i], A[i], B[i], CIN[i], 0n, 0n];
    switch (Number(op)) {
        case 0x02: // ADD,ADD_W
            c = (cin + a + b) & 0xFFn;
            cout = (cin + a + b) >> 8n;
            break;

        case 0x3: // SUB,SUB_W
            cout = (a - cin) >= b ? 0n : 1n;
            c = 256n * cout + a - cin - b;
            break;

        case 0x04:
        case 0x05: // LTU,LTU_W,LT,LT_W
            if (a < b) {
                cout = 1n;
                c = plast;
            } else if (a == b) {
                cout = cin;
                c = plast * cin;
            }

            // If the chunk is signed, then the result is the sign of a
            if (op == 0x05n && plast && (a & 0x80n) != (b & 0x80n)) {
                c = (a & 0x80n) ? 1n : 0n;
                cout = c;
            }
            break;

        case 0x06:
        case 0x07: // LEU,LEU_W,LE,LE_W
            if (a <= b) {
                cout = 1n;
                c = plast;
            }
            if (op == 0x07n && plast && (a & 0x80n) != (b & 0x80n)) {
                c = (a & 0x80n) ? 1n : 0n;
                cout = c;
            }
            break;

        case 0x08: // EQ,EQ_W
            if (a == b && !cin) c = plast;
            else cout = 1n;
            cout = plast ? (1n - cout) : cout;
            break;

        case 0x09:
        case 0x0a: // MINU,MINU_W,MIN,MIN_W
            if (a <= b) {
                cout = 1n;
                c = plast ? a : b;
            } else {
                c = b;
            }
            if (op == 0x0an && plast && (a & 0x80n) != (b & 0x80n)) {
                c = (a & 0x80n) ? a : b;
                cout = (a & 0x80n) ? 1n : 0n;
            }
            break;

        case 0x0b:
        case 0x0c: // MAXU,MAXU_W,MAX,MAX_W
            if (a >= b) {
                cout = 1n;
                c = plast ? a : b;
            } else {
                c = b;
            }
            if (op == 0x0cn && plast && (a & 0x80n) != (b & 0x80n)) {
                c = (a & 0x80n) ? b : a;
                cout = (a & 0x80n) ? 0n : 1n;
            }
            break;

        case 0x20: // AND
            c = a & b;
            break;

        case 0x21: // OR
            c = a | b;
            break;

        case 0x22: // XOR
            c = a ^ b;
            break;

        case 0x23: // EXT_32
            c = (a & 0x80n) ? 0xFFn : 0x00n;
            break;

        default:
            throw new Error(`Invalid operation ${op}`);
    }
    C[i] = c;
    COUT[i] = cout;
    if (typeof cout !== 'bigint') {
        console.log([cout, USE_CARRY[i]])
    }
    FLAGS[i] = cout + 2n * USE_CARRY[i];
}
/*
let N = 2 ** 22;
let A = [];
let B = [];
let OFFSET = [];
let OP = [];

for (let index = 0; index < N; ++index) {
    const _index = BigInt(index);
    A[index] = _index & 0xFFn;
    const B_cycle = (_index % 401408n);
    B[index] = B_cycle >= 393216n ? 0n : ((B_cycle >> 8n) % 64n) ;
    const OFFSET_cycle = (_index % 401408n);
    OFFSET[index] = Math.floor(Math.random() * 4);
    OP[index] = Math.floor(Math.random() * 16); 
}


let C0 = []                                           // Output C0  (32 bits)
let C1 = []                                           // Output C1  (32 bits)
for (let i = 0; i < N; i++) {
    let [op, offset, a, b] = [OP[i], OFFSET[i], A[i], B[i]];
    let _out = 0;
    switch (op) {
        case 0x0d: // SLL,SLL_W
            _out = a << b;
            _out = _out << 8*offset;

        case 0x0e: // SRL,SRL_W
            _out = a << 8*offset;
            _out = _out >> b;

        case 0x0f: // SRA,SRA_W
            // Compute two's complement
            _out = a & 0x80 ? a - 0x100 : a;

            // Compute the shift
            _out = _out << 8*offset;
            _out = _out >> b;

            // Convert back to two's complement
            _out = _out < 0 ? ((_out & (P2_63 - 1)) + P2_63) : _out;

        case 0x24: // SE_B
            if (offset == 0) {
                _out = a & P2_7 ? (P2_7 | (a & (P2_7-1))) : (a & (P2_7-1));
            } else {
                _out = a & P2_7 ? 0xFF00 << (8*(offset - 1)) : 0;
            }

        case 0x25: // SE_H
            if (offset == 0) {
                _out = a
            } else if (offset == 1) {
                _out = a & P2_7 ? (P2_7 | (a & (P2_7-1))) : (a & (P2_7-1));
                _out = _out << 8;
            } else {
                _out = a & P2_7 ? 0xFF0000 << (8*(offset - 2)) : 0;
            }

        case 0x26: // SE_W
            if (offset < 3) {
                _out = a << (8*offset);
            } else if (offset == 3) {
                _out = a & P2_7 ? (P2_7 | (a & (P2_7-1))) : (a & (P2_7-1));
                _out = _out << 24;
            } else {
                _out = a & P2_7 ? 0xFF00000000 << (8*(offset - 4)) : 0;
            }

        case 0x27: // EXT
            _out = (a & 0x80) ? 0xFF : 0x00;
            _out = _out << 8*offset;

        default:
            error(`Invalid operation ${op}`);
    }

    C0[i] = _out & (P2_32-1);
    C1[i] = _out >> 32;
}*/