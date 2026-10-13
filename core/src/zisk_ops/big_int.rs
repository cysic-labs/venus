//! Big integer precompiles: 256-bit addition, and 256-bit and 384-bit modular arithmetic

use super::{
    precompiled::{
        precompiled_load_data, precompiled_load_data_with_result, precompiled_stats_data,
    },
    OpStats,
};
use crate::{EmulationMode, InstContext};

pub fn opc_add256(ctx: &mut InstContext) {
    const WORDS: usize = 4 + 1 + 2 * 4;
    let mut data = [0u64; WORDS];

    precompiled_load_data_with_result(ctx, 4, 2, 4, 0, Some(2), &mut data, "add256");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // ignore 3 indirections
        // 0 - addr_a
        // 1 - addr_b
        // 2 - cin
        // 3 - addr_c
        let cin = data[2];
        let (params, rest) = data.split_at(4); // params(4)
        let (a, rest) = rest.split_at(4);
        let (b, _) = rest.split_at(4);

        let a: &[u64; 4] = a.try_into().expect("opc_add256: a.len != 4");
        let b: &[u64; 4] = b.try_into().expect("opc_add256: b.len != 4");
        let mut c = [0u64; 4];
        let cout = precompiles_helpers::add256(a, b, cin, &mut c);

        let c_addr = params[3];
        for (i, c_item) in c.iter().enumerate() {
            ctx.mem.write(c_addr + (8 * i as u64), *c_item, 8);
        }
        if let EmulationMode::GenerateMemReads = ctx.emulation_mode {
            ctx.precompiled.input_data[4 + 2 * 4] = cout;
        }
        ctx.c = cout;
        ctx.flag = false;
    } else {
        assert!(data[4 + 2 * 4] <= 1, "opc_add256: cout > 1");
        ctx.c = data[4 + 2 * 4];
        ctx.flag = false;
    }
}

/// Unimplemented.  Arith256 can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_add256(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_add256() is not implemented");
}

#[inline(always)]
pub fn ops_add256(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[4, 4, 0], &[4], 0);
}

#[inline(always)]
pub fn opc_arith256(ctx: &mut InstContext) {
    const WORDS: usize = 5 + 3 * 4;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 5, 3, 4, 0, None, &mut data, "arith256");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // ignore 5 indirections
        let (_, rest) = data.split_at(5);
        let (a, rest) = rest.split_at(4);
        let (b, c) = rest.split_at(4);

        let a: &[u64; 4] = a.try_into().expect("opc_arith256: a.len != 4");
        let b: &[u64; 4] = b.try_into().expect("opc_arith256: b.len != 4");
        let c: &[u64; 4] = c.try_into().expect("opc_arith256: c.len != 4");

        let mut dl = [0u64; 4];
        let mut dh = [0u64; 4];

        precompiles_helpers::arith256(a, b, c, &mut dl, &mut dh);

        // [a,b,c,3:dl,4:dh]
        for (i, dl_item) in dl.iter().enumerate() {
            ctx.mem.write(data[3] + (8 * i as u64), *dl_item, 8);
        }
        for (i, dh_item) in dh.iter().enumerate() {
            ctx.mem.write(data[4] + (8 * i as u64), *dh_item, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Arith256 can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_arith256(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_arith256() is not implemented");
}

#[inline(always)]
pub fn ops_arith256(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[4, 4, 4], &[4, 4], 0);
}

#[inline(always)]
pub fn opc_arith256_mod(ctx: &mut InstContext) {
    const WORDS: usize = 5 + 4 * 4;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 5, 4, 4, 0, None, &mut data, "arith256_mod");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // ignore 5 indirections
        let (_, rest) = data.split_at(5);
        let (a, rest) = rest.split_at(4);
        let (b, rest) = rest.split_at(4);
        let (c, module) = rest.split_at(4);
        let mut d = [0u64; 4];

        let a: &[u64; 4] = a.try_into().expect("opc_arith256_mod: a.len != 4");
        let b: &[u64; 4] = b.try_into().expect("opc_arith256_mod: b.len != 4");
        let c: &[u64; 4] = c.try_into().expect("opc_arith256_mod: c.len != 4");
        let module: &[u64; 4] = module.try_into().expect("opc_arith256_mod: module.len != 4");

        let mut d = [0u64; 4];

        precompiles_helpers::arith256_mod(a, b, c, module, &mut d);

        // [a,b,c,module,4:d]
        for (i, d) in d.iter().enumerate() {
            ctx.mem.write(data[4] + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Arith256Mod can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_arith256_mod(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_arith256_mod() is not implemented");
}

#[inline(always)]
pub fn ops_arith256_mod(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[4, 4, 4, 4], &[4], 0);
}

#[inline(always)]
pub fn opc_arith384_mod(ctx: &mut InstContext) {
    const WORDS: usize = 5 + 4 * 6;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 5, 4, 6, 0, None, &mut data, "arith384_mod");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // ignore 5 indirections
        let (_, rest) = data.split_at(5);
        let (a, rest) = rest.split_at(6);
        let (b, rest) = rest.split_at(6);
        let (c, module) = rest.split_at(6);
        let mut d = [0u64; 6];

        let a: &[u64; 6] = a.try_into().expect("opc_arith384_mod: a.len != 6");
        let b: &[u64; 6] = b.try_into().expect("opc_arith384_mod: b.len != 6");
        let c: &[u64; 6] = c.try_into().expect("opc_arith384_mod: c.len != 6");
        let module: &[u64; 6] = module.try_into().expect("opc_arith384_mod: module.len != 6");

        let mut d = [0u64; 6];

        precompiles_helpers::arith384_mod(a, b, c, module, &mut d);

        // [a,b,c,module,4:d]
        for (i, d) in d.iter().enumerate() {
            ctx.mem.write(data[4] + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Arith384Mod can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_arith384_mod(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_arith384_mod() is not implemented");
}

#[inline(always)]
pub fn ops_arith384_mod(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[6, 6, 6, 6], &[6], 0);
}
