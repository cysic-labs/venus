use zisk_core::zisk_ops::ZiskOp;

const EMPTY_OP: usize = 256;

#[derive(Debug, Clone)]
struct FrequentTable {
    table_by_op: [usize; 256],
    table_ops: Vec<Vec<[u64; 2]>>,
}

impl FrequentTable {
    fn new() -> Self {
        Self { table_by_op: [EMPTY_OP; 256], table_ops: Vec::new() }
    }

    fn add_ops(&mut self, op: u8, mut ops: Vec<[u64; 2]>) {
        let index = self.op_index(op);
        self.table_ops[index].append(&mut ops);
    }

    fn add_ops_clone(&mut self, op: u8, ops: &[[u64; 2]]) {
        let index = self.op_index(op);
        self.table_ops[index].extend_from_slice(ops);
    }

    fn op_index(&mut self, op: u8) -> usize {
        let slot = &mut self.table_by_op[op as usize];
        if *slot == EMPTY_OP {
            *slot = self.table_ops.len();
            self.table_ops.push(Vec::new());
        }
        *slot
    }

    fn offsets(&self) -> (usize, Vec<usize>) {
        let mut offsets = [0usize; 256];
        let mut size = 0usize;
        let mut start = offsets.len();
        let mut end = 0usize;
        for (op, &index) in self.table_by_op.iter().enumerate() {
            if index == EMPTY_OP {
                continue;
            }
            offsets[op] = size;
            start = start.min(op);
            end = end.max(op);
            size += self.table_ops[index].len();
        }
        (start, offsets[start..=end].to_vec())
    }

    fn into_table(self) -> Vec<(u8, u64, u64)> {
        let total = self.table_ops.iter().map(Vec::len).sum();
        let mut table = Vec::with_capacity(total);
        for (op, index) in self.table_by_op.into_iter().enumerate() {
            if index == EMPTY_OP {
                continue;
            }
            table.extend(self.table_ops[index].iter().map(|ab| (op as u8, ab[0], ab[1])));
        }
        table
    }
}

fn low_values(max_a: u64, max_b: u64) -> Vec<[u64; 2]> {
    let mut ops = Vec::with_capacity((max_a * max_b) as usize);
    for a in 0..max_a {
        for b in 0..max_b {
            ops.push([a, b]);
        }
    }
    ops
}

pub fn generate_arith_frops_table() -> Vec<(u8, u64, u64)> {
    arith::generate_table()
}

pub fn generate_binary_basic_frops_table() -> Vec<(u8, u64, u64)> {
    binary_basic::generate_table()
}

pub fn generate_binary_extension_frops_table() -> Vec<(u8, u64, u64)> {
    binary_extension::generate_table()
}

mod arith {
    use super::*;

    const OP_MULU: u8 = ZiskOp::Mulu.code();
    const OP_MULUH: u8 = ZiskOp::Muluh.code();
    const OP_MULSUH: u8 = ZiskOp::Mulsuh.code();
    const OP_MUL: u8 = ZiskOp::Mul.code();
    const OP_MULH: u8 = ZiskOp::Mulh.code();
    const OP_MULW: u8 = ZiskOp::MulW.code();
    const OP_DIVU: u8 = ZiskOp::Divu.code();
    const OP_REMU: u8 = ZiskOp::Remu.code();
    const OP_DIV: u8 = ZiskOp::Div.code();
    const OP_REM: u8 = ZiskOp::Rem.code();
    const OP_DIVUW: u8 = ZiskOp::DivuW.code();
    const OP_REMUW: u8 = ZiskOp::RemuW.code();
    const OP_DIVW: u8 = ZiskOp::DivW.code();
    const OP_REMW: u8 = ZiskOp::RemW.code();

    const LOW_VALUES_OPCODES: [u8; 14] = [
        OP_MULU, OP_MULUH, OP_MULSUH, OP_MUL, OP_MULH, OP_MULW, OP_DIVU, OP_REMU, OP_DIV, OP_REM,
        OP_DIVUW, OP_REMUW, OP_DIVW, OP_REMW,
    ];

    const MAX_A_LOW_VALUE: u64 = 386;
    const MAX_B_LOW_VALUE: u64 = 386;
    const OP_TABLE_OFFSETS_START: usize = 176;
    const OP_TABLE_OFFSETS: [usize; 16] = [
        0, 148996, 0, 297992, 446988, 595984, 744980, 0, 893976, 1042972, 1191968, 1340964,
        1489960, 1638956, 1787952, 1936948,
    ];

    pub fn generate_table() -> Vec<(u8, u64, u64)> {
        let mut table = FrequentTable::new();
        let low = low_values(MAX_A_LOW_VALUE, MAX_B_LOW_VALUE);
        for op in LOW_VALUES_OPCODES {
            table.add_ops_clone(op, &low);
        }
        assert_eq!((OP_TABLE_OFFSETS_START, OP_TABLE_OFFSETS.to_vec()), table.offsets());
        table.into_table()
    }
}

mod binary_extension {
    use super::*;

    const OP_SIGNEXTENDB: u8 = ZiskOp::SignExtendB.code();
    const OP_SIGNEXTENDH: u8 = ZiskOp::SignExtendH.code();
    const OP_SIGNEXTENDW: u8 = ZiskOp::SignExtendW.code();
    const OP_SLL: u8 = ZiskOp::Sll.code();
    const OP_SLLW: u8 = ZiskOp::SllW.code();
    const OP_SRA: u8 = ZiskOp::Sra.code();
    const OP_SRL: u8 = ZiskOp::Srl.code();
    const OP_SRAW: u8 = ZiskOp::SraW.code();
    const OP_SRLW: u8 = ZiskOp::SrlW.code();

    const LOW_VALUES_OPCODES: [u8; 9] = [
        OP_SIGNEXTENDB,
        OP_SIGNEXTENDH,
        OP_SIGNEXTENDW,
        OP_SLL,
        OP_SLLW,
        OP_SRA,
        OP_SRL,
        OP_SRAW,
        OP_SRLW,
    ];

    const MAX_A_LOW_VALUE: u64 = 386;
    const MAX_B_LOW_VALUE: u64 = 386;
    const MAX_U64: u64 = u64::MAX;
    const SLR_MASK_FROM: u64 = 0xFFFF_FFFF_FFFF_F000;
    const SLR_TO_B: u64 = 64;
    const OP_TABLE_OFFSETS_START: usize = 33;
    const OP_TABLE_OFFSETS: [usize; 9] =
        [0, 148996, 564232, 713228, 862224, 1011220, 1160216, 1309212, 1458208];

    pub fn generate_table() -> Vec<(u8, u64, u64)> {
        let mut table = FrequentTable::new();
        let low = low_values(MAX_A_LOW_VALUE, MAX_B_LOW_VALUE);
        for op in LOW_VALUES_OPCODES {
            table.add_ops_clone(op, &low);
        }

        let mut srl = Vec::with_capacity(((MAX_U64 - SLR_MASK_FROM + 1) * (SLR_TO_B + 1)) as usize);
        for a in SLR_MASK_FROM..=MAX_U64 {
            for b in 0..=SLR_TO_B {
                srl.push([a, b]);
            }
        }
        table.add_ops(OP_SRL, srl);

        assert_eq!((OP_TABLE_OFFSETS_START, OP_TABLE_OFFSETS.to_vec()), table.offsets());
        table.into_table()
    }
}

mod binary_basic {
    use super::*;

    const OP_ADD: u8 = ZiskOp::Add.code();
    const OP_ADDW: u8 = ZiskOp::AddW.code();
    const OP_SUB: u8 = ZiskOp::Sub.code();
    const OP_SUBW: u8 = ZiskOp::SubW.code();
    const OP_EQ: u8 = ZiskOp::Eq.code();
    const OP_EQW: u8 = ZiskOp::EqW.code();
    const OP_LTU: u8 = ZiskOp::Ltu.code();
    const OP_LT: u8 = ZiskOp::Lt.code();
    const OP_LTUW: u8 = ZiskOp::LtuW.code();
    const OP_LTW: u8 = ZiskOp::LtW.code();
    const OP_LEU: u8 = ZiskOp::Leu.code();
    const OP_LE: u8 = ZiskOp::Le.code();
    const OP_LEUW: u8 = ZiskOp::LeuW.code();
    const OP_LEW: u8 = ZiskOp::LeW.code();
    const OP_AND: u8 = ZiskOp::And.code();
    const OP_OR: u8 = ZiskOp::Or.code();
    const OP_XOR: u8 = ZiskOp::Xor.code();

    const LOW_VALUES_OPCODES: [u8; 17] = [
        OP_ADD, OP_ADDW, OP_SUB, OP_SUBW, OP_EQ, OP_EQW, OP_LTU, OP_LT, OP_LTUW, OP_LTW, OP_LEU,
        OP_LE, OP_LEUW, OP_LEW, OP_AND, OP_OR, OP_XOR,
    ];

    const MAX_A_LOW_VALUE: u64 = 386;
    const MAX_B_LOW_VALUE: u64 = 386;
    const LOW_VALUE_SIZE: usize = (MAX_A_LOW_VALUE * MAX_B_LOW_VALUE) as usize;
    const MINUS_ONE: u64 = u64::MAX;
    const MAX_U64: u64 = u64::MAX;
    const EQ_OP_B_ZERO_A_LIMIT: u64 = 0xFFFFF;
    const LTU_OP_B_LT_ONE_FROM: u64 = (-128i64) as u64;

    const LT_FROM_ADDR: u64 = 0xA010_0000;
    const LT_TO_ADDR: u64 = 0xA012_0000;
    const LT_DELTA: u64 = 8;
    const LT_LOW_DISTANCE_1: u64 = 16;
    const LT_HIGH_DISTANCE_8: u64 = 240;
    const LT_LOW_HIGH_DISTANCES: u64 = LT_LOW_DISTANCE_1 + LT_HIGH_DISTANCE_8;
    const LT_FROM_TO_SIZE: usize = ((LT_TO_ADDR - LT_FROM_ADDR) / LT_DELTA) as usize;
    const LT_ALL_FROM_TO_SIZE: usize = LT_FROM_TO_SIZE * LT_LOW_HIGH_DISTANCES as usize;
    const LT_ZERO_TO_B: u64 = 0x10000;

    const MAX_ADD_MINUS_ONE: u64 = 24628;
    const MAX_ADD_MINUS_A: u64 = 1024;
    const MAX_ADD_MINUS_B: u64 = 8;
    const ADD_ONE_FROM_ADDR: u64 = 0xA010_0000;
    const ADD_ONE_TO_ADDR: u64 = 0xA020_0000;
    const ADD_EIGHT_FROM_ADDR: u64 = 0xA010_0000;
    const ADD_EIGHT_TO_ADDR: u64 = 0xA020_0000;
    const ADD_EIGHT_FROM_CODE: u64 = 0x8000_0000;
    const ADD_EIGHT_TO_CODE: u64 = 0x8080_0000;
    const ADD_EIGHT_STEP: u64 = 8;
    const ADD_ZERO_FROM_ADDR: u64 = 0xA010_0000;
    const ADD_ZERO_TO_ADDR: u64 = 0xA020_0000;
    const ADD_ZERO_STEP: u64 = 8;

    const ADD_MINUS_ONE_SIZE: usize = MAX_ADD_MINUS_ONE as usize;
    const ADD_MINUS_A_B_SIZE: usize = (MAX_ADD_MINUS_A * MAX_ADD_MINUS_B) as usize;
    const ADD_ONE_ADDR_SIZE: usize = (ADD_ONE_TO_ADDR - ADD_ONE_FROM_ADDR) as usize;
    const ADD_EIGHT_ADDR_SIZE: usize =
        ((ADD_EIGHT_TO_ADDR - ADD_EIGHT_FROM_ADDR) / ADD_EIGHT_STEP) as usize;
    const ADD_EIGHT_CODE_SIZE: usize =
        ((ADD_EIGHT_TO_CODE - ADD_EIGHT_FROM_CODE) / ADD_EIGHT_STEP) as usize;
    const ADD_ZERO_ADDR_SIZE: usize =
        ((ADD_ZERO_TO_ADDR - ADD_ZERO_FROM_ADDR) / ADD_ZERO_STEP) as usize;

    const ADD_MINUS_ONE_OFFSET: usize = LOW_VALUE_SIZE;
    const ADD_MINUS_A_B_OFFSET: usize = ADD_MINUS_ONE_OFFSET + ADD_MINUS_ONE_SIZE;
    const ADD_ONE_ADDR_OFFSET: usize = ADD_MINUS_A_B_OFFSET + ADD_MINUS_A_B_SIZE;
    const ADD_EIGHT_ADDR_OFFSET: usize = ADD_ONE_ADDR_OFFSET + ADD_ONE_ADDR_SIZE;
    const ADD_EIGHT_CODE_OFFSET: usize = ADD_EIGHT_ADDR_OFFSET + ADD_EIGHT_ADDR_SIZE;
    const ADD_ZERO_ADDR_OFFSET: usize = ADD_EIGHT_CODE_OFFSET + ADD_EIGHT_CODE_SIZE;

    const AND_CODE_ADDR_FROM: u64 = 0x8000_0000;
    const AND_CODE_ADDR_TO: u64 = 0x8090_0000;
    const AND_CODE_ADDR_STEP: u64 = 4;
    const AND_CODE_ADDR_MASK: u64 = 0xFFFF_FFFF_FFFF_FFFC;
    const AND_RESET_LAST_THREE_BITS_B: u64 = 0xFFFF_FFFF_FFFF_FFF8;
    const AND_RESET_LAST_THREE_BITS_A_TO: u64 = 1024;
    const AND_GET_LAST_THREE_BITS_B: u64 = 0x7;
    const AND_GET_LAST_THREE_BITS_FROM: u64 = 0xA010_0000;
    const AND_GET_LAST_THREE_BITS_TO: u64 = 0xA020_0000;
    const AND_GET_LAST_THREE_BITS_STEP: u64 = 8;

    const AND_CODE_ADDR_OFFSET: usize = LOW_VALUE_SIZE;
    const AND_CODE_ADDR_SIZE: usize =
        ((AND_CODE_ADDR_TO - AND_CODE_ADDR_FROM) / AND_CODE_ADDR_STEP) as usize;
    const AND_RESET_LAST_THREE_BITS_OFFSET: usize = AND_CODE_ADDR_OFFSET + AND_CODE_ADDR_SIZE;
    const AND_RESET_LAST_THREE_BITS_SIZE: usize = AND_RESET_LAST_THREE_BITS_A_TO as usize;
    const AND_GET_LAST_THREE_BITS_OFFSET: usize =
        AND_RESET_LAST_THREE_BITS_OFFSET + AND_RESET_LAST_THREE_BITS_SIZE;
    const AND_GET_LAST_THREE_BITS_SIZE: usize = ((AND_GET_LAST_THREE_BITS_TO
        - AND_GET_LAST_THREE_BITS_FROM)
        / AND_GET_LAST_THREE_BITS_STEP) as usize;

    const OR_TO_A: u64 = 0x1000;
    const OR_TO_B: u64 = 16;
    const SUB_W_ADDR_FROM: u64 = 0xA010_0000;
    const SUB_W_ADDR_TO: u64 = 0xA020_0000;
    const SUB_W_ADDR_STEP: u64 = 4;
    const SUB_TO_A: u64 = 4192;
    const SUB_TO_B: u64 = 8;

    const OP_TABLE_OFFSETS_START: usize = 6;
    const OP_TABLE_OFFSETS: [usize; 24] = [
        0, 149124, 0, 4557574, 5755146, 8296258, 8479508, 8628504, 8777500, 11417888, 11629954, 0,
        0, 0, 0, 0, 11778952, 11927948, 0, 12076944, 12225940, 12374936, 12786076, 12935072,
    ];

    pub fn generate_table() -> Vec<(u8, u64, u64)> {
        let mut table = FrequentTable::new();
        let low = low_values(MAX_A_LOW_VALUE, MAX_B_LOW_VALUE);
        for op in LOW_VALUES_OPCODES {
            table.add_ops_clone(op, &low);
        }
        build_eq_zero(&mut table);
        build_ltu_one(&mut table);
        build_lt(&mut table);
        build_add(&mut table);
        build_and(&mut table);
        build_or(&mut table);
        build_sub_w(&mut table);
        build_xor(&mut table);
        build_sub(&mut table);

        assert_eq!((OP_TABLE_OFFSETS_START, OP_TABLE_OFFSETS.to_vec()), table.offsets());
        table.into_table()
    }

    fn build_eq_zero(table: &mut FrequentTable) {
        let mut ops = Vec::with_capacity(EQ_OP_B_ZERO_A_LIMIT as usize + 1);
        for a in 0..=EQ_OP_B_ZERO_A_LIMIT {
            ops.push([a, 0]);
        }
        table.add_ops(OP_EQ, ops);
    }

    fn build_ltu_one(table: &mut FrequentTable) {
        let mut ops = Vec::with_capacity(128);
        for a in LTU_OP_B_LT_ONE_FROM..=MAX_U64 {
            ops.push([a, 1]);
        }
        table.add_ops(OP_LTU, ops);
    }

    fn build_lt(table: &mut FrequentTable) {
        let mut ops = Vec::with_capacity(LT_ALL_FROM_TO_SIZE + (LT_ZERO_TO_B as usize));
        let mut i = LT_FROM_ADDR;
        while i < LT_TO_ADDR {
            for j in 0..LT_LOW_DISTANCE_1 {
                ops.push([i - j, i]);
            }
            for j in 0..LT_HIGH_DISTANCE_8 {
                ops.push([i - j * 8 - 16, i]);
            }
            i += LT_DELTA;
        }
        for i in MAX_B_LOW_VALUE..LT_ZERO_TO_B {
            ops.push([0, i]);
        }
        table.add_ops(OP_LT, ops);
    }

    fn build_add(table: &mut FrequentTable) {
        let mut ops = Vec::with_capacity(
            ADD_MINUS_ONE_SIZE
                + ADD_MINUS_A_B_SIZE
                + ADD_ONE_ADDR_SIZE
                + ADD_EIGHT_ADDR_SIZE
                + ADD_EIGHT_CODE_SIZE
                + ADD_ZERO_ADDR_SIZE,
        );
        for a in 0..MAX_ADD_MINUS_ONE {
            ops.push([a, MINUS_ONE]);
        }
        for a in 0..MAX_ADD_MINUS_A {
            for j in 1..=MAX_ADD_MINUS_B {
                ops.push([a, MAX_U64 - j]);
            }
        }
        for a in ADD_ONE_FROM_ADDR..ADD_ONE_TO_ADDR {
            ops.push([a, 1]);
        }
        for a in (ADD_EIGHT_FROM_ADDR..ADD_EIGHT_TO_ADDR).step_by(ADD_EIGHT_STEP as usize) {
            ops.push([a, 8]);
        }
        for a in (ADD_EIGHT_FROM_CODE..ADD_EIGHT_TO_CODE).step_by(ADD_EIGHT_STEP as usize) {
            ops.push([a, 8]);
        }
        for a in (ADD_ZERO_FROM_ADDR..ADD_ZERO_TO_ADDR).step_by(ADD_ZERO_STEP as usize) {
            ops.push([a, 0]);
        }

        debug_assert_eq!(ADD_MINUS_A_B_OFFSET, ADD_MINUS_ONE_OFFSET + ADD_MINUS_ONE_SIZE);
        debug_assert_eq!(ADD_ONE_ADDR_OFFSET, ADD_MINUS_A_B_OFFSET + ADD_MINUS_A_B_SIZE);
        debug_assert_eq!(ADD_EIGHT_ADDR_OFFSET, ADD_ONE_ADDR_OFFSET + ADD_ONE_ADDR_SIZE);
        debug_assert_eq!(ADD_EIGHT_CODE_OFFSET, ADD_EIGHT_ADDR_OFFSET + ADD_EIGHT_ADDR_SIZE);
        debug_assert_eq!(ADD_ZERO_ADDR_OFFSET, ADD_EIGHT_CODE_OFFSET + ADD_EIGHT_CODE_SIZE);
        table.add_ops(OP_ADD, ops);
    }

    fn build_and(table: &mut FrequentTable) {
        let mut ops = Vec::with_capacity(
            AND_CODE_ADDR_SIZE + AND_RESET_LAST_THREE_BITS_SIZE + AND_GET_LAST_THREE_BITS_SIZE,
        );
        for b in (AND_CODE_ADDR_FROM..AND_CODE_ADDR_TO).step_by(AND_CODE_ADDR_STEP as usize) {
            ops.push([AND_CODE_ADDR_MASK, b]);
        }
        for a in 0..AND_RESET_LAST_THREE_BITS_A_TO {
            ops.push([a, AND_RESET_LAST_THREE_BITS_B]);
        }
        for a in (AND_GET_LAST_THREE_BITS_FROM..AND_GET_LAST_THREE_BITS_TO)
            .step_by(AND_GET_LAST_THREE_BITS_STEP as usize)
        {
            ops.push([a, AND_GET_LAST_THREE_BITS_B]);
        }

        debug_assert_eq!(
            AND_RESET_LAST_THREE_BITS_OFFSET,
            AND_CODE_ADDR_OFFSET + AND_CODE_ADDR_SIZE
        );
        debug_assert_eq!(
            AND_GET_LAST_THREE_BITS_OFFSET,
            AND_RESET_LAST_THREE_BITS_OFFSET + AND_RESET_LAST_THREE_BITS_SIZE
        );
        table.add_ops(OP_AND, ops);
    }

    fn build_or(table: &mut FrequentTable) {
        let mut ops = Vec::with_capacity(((OR_TO_A - MAX_A_LOW_VALUE) * (OR_TO_B + 1)) as usize);
        for a in MAX_A_LOW_VALUE..OR_TO_A {
            for b in 0..=OR_TO_B {
                ops.push([a, b]);
            }
        }
        table.add_ops(OP_OR, ops);
    }

    fn build_sub_w(table: &mut FrequentTable) {
        let mut ops =
            Vec::with_capacity(((SUB_W_ADDR_TO - SUB_W_ADDR_FROM) / SUB_W_ADDR_STEP) as usize);
        for b in (SUB_W_ADDR_FROM..SUB_W_ADDR_TO).step_by(SUB_W_ADDR_STEP as usize) {
            ops.push([0, b]);
        }
        table.add_ops(OP_SUBW, ops);
    }

    fn build_xor(table: &mut FrequentTable) {
        table.add_ops(OP_XOR, vec![[0, MAX_U64], [1, MAX_U64]]);
    }

    fn build_sub(table: &mut FrequentTable) {
        let mut ops = Vec::with_capacity(((SUB_TO_A - MAX_A_LOW_VALUE) * (SUB_TO_B + 1)) as usize);
        for a in MAX_A_LOW_VALUE..SUB_TO_A {
            for b in 0..=SUB_TO_B {
                ops.push([a, b]);
            }
        }
        table.add_ops(OP_SUB, ops);
    }
}
