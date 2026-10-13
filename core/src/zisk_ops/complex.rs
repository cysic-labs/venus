//! Quadratic extension field (complex) precompiles of bn254 and bls12-381: addition,
//! subtraction and multiplication

use super::{
    precompiled::{precompiled_load_data, precompiled_stats_data},
    OpStats,
};
use crate::{EmulationMode, InstContext};

#[inline(always)]
pub fn opc_bn254_complex_add(ctx: &mut InstContext) {
    const WORDS: usize = 2 + 2 * 8;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 2, 2, 8, 0, None, &mut data, "bn254_complex_add");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // ignore 2 indirections
        let (_, rest) = data.split_at(2);
        let (f1, f2) = rest.split_at(8);

        let f1: &[u64; 8] = f1.try_into().expect("opc_bn254_complex_add: f1.len != 8");
        let f2: &[u64; 8] = f2.try_into().expect("opc_bn254_complex_add: f2.len != 8");
        let mut f3 = [0u64; 8];

        precompiles_helpers::bn254_complex_add(f1, f2, &mut f3);

        // [0:f1,f2]
        for (i, d) in f3.iter().enumerate() {
            ctx.mem.write(data[0] + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Bn254ComplexAdd can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_bn254_complex_add(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_bn254_complex_add() is not implemented");
}

#[inline(always)]
pub fn ops_bn254_complex_add(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[8, 8], &[], 1);
}

#[inline(always)]
pub fn opc_bn254_complex_sub(ctx: &mut InstContext) {
    const WORDS: usize = 2 + 2 * 8;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 2, 2, 8, 0, None, &mut data, "bn254_complex_sub");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // ignore 2 indirections
        let (_, rest) = data.split_at(2);
        let (f1, f2) = rest.split_at(8);

        let f1: &[u64; 8] = f1.try_into().expect("opc_bn254_complex_sub: f1.len != 8");
        let f2: &[u64; 8] = f2.try_into().expect("opc_bn254_complex_sub: f2.len != 8");
        let mut f3 = [0u64; 8];

        precompiles_helpers::bn254_complex_sub(f1, f2, &mut f3);

        // [0:f1,f2]
        for (i, d) in f3.iter().enumerate() {
            ctx.mem.write(data[0] + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Bn254ComplexSub can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_bn254_complex_sub(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_bn254_complex_sub() is not implemented");
}

#[inline(always)]
pub fn ops_bn254_complex_sub(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[8, 8], &[], 1);
}

#[inline(always)]
pub fn opc_bn254_complex_mul(ctx: &mut InstContext) {
    const WORDS: usize = 2 + 2 * 8;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 2, 2, 8, 0, None, &mut data, "bn254_complex_mul");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // ignore 2 indirections
        let (_, rest) = data.split_at(2);
        let (f1, f2) = rest.split_at(8);

        let f1: &[u64; 8] = f1.try_into().expect("opc_bn254_complex_mul: f1.len != 8");
        let f2: &[u64; 8] = f2.try_into().expect("opc_bn254_complex_mul: f2.len != 8");
        let mut f3 = [0u64; 8];

        precompiles_helpers::bn254_complex_mul(f1, f2, &mut f3);

        // [0:f1,f2]
        for (i, d) in f3.iter().enumerate() {
            ctx.mem.write(data[0] + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Bn254ComplexMul can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_bn254_complex_mul(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_bn254_complex_mul() is not implemented");
}

#[inline(always)]
pub fn ops_bn254_complex_mul(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[8, 8], &[], 1);
}

#[inline(always)]
pub fn opc_bls12_381_complex_add(ctx: &mut InstContext) {
    const WORDS: usize = 2 + 2 * 12;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 2, 2, 12, 0, None, &mut data, "bls12_381_complex_add");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // ignore 2 indirections
        let (_, rest) = data.split_at(2);
        let (f1, f2) = rest.split_at(12);

        let f1: &[u64; 12] = f1.try_into().expect("opc_bls12_381_complex_add: f1.len != 12");
        let f2: &[u64; 12] = f2.try_into().expect("opc_bls12_381_complex_add: f2.len != 12");
        let mut f3 = [0u64; 12];

        precompiles_helpers::bls12_381_complex_add(f1, f2, &mut f3);

        // [0:f1,f2]
        for (i, d) in f3.iter().enumerate() {
            ctx.mem.write(data[0] + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Bls12_381ComplexAdd can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_bls12_381_complex_add(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_bls12_381_complex_add() is not implemented");
}

#[inline(always)]
pub fn ops_bls12_381_complex_add(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[12, 12], &[], 1);
}

#[inline(always)]
pub fn opc_bls12_381_complex_sub(ctx: &mut InstContext) {
    const WORDS: usize = 2 + 2 * 12;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 2, 2, 12, 0, None, &mut data, "bls12_381_complex_sub");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // ignore 2 indirections
        let (_, rest) = data.split_at(2);
        let (f1, f2) = rest.split_at(12);

        let f1: &[u64; 12] = f1.try_into().expect("opc_bls12_381_complex_sub: f1.len != 12");
        let f2: &[u64; 12] = f2.try_into().expect("opc_bls12_381_complex_sub: f2.len != 12");
        let mut f3 = [0u64; 12];

        precompiles_helpers::bls12_381_complex_sub(f1, f2, &mut f3);

        // [0:f1,f2]
        for (i, d) in f3.iter().enumerate() {
            ctx.mem.write(data[0] + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Bls12_381ComplexSub can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_bls12_381_complex_sub(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_bls12_381_complex_sub() is not implemented");
}

#[inline(always)]
pub fn ops_bls12_381_complex_sub(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[12, 12], &[], 1);
}

#[inline(always)]
pub fn opc_bls12_381_complex_mul(ctx: &mut InstContext) {
    const WORDS: usize = 2 + 2 * 12;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 2, 2, 12, 0, None, &mut data, "bls12_381_complex_mul");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // ignore 2 indirections
        let (_, rest) = data.split_at(2);
        let (f1, f2) = rest.split_at(12);

        let f1: &[u64; 12] = f1.try_into().expect("opc_bls12_381_complex_mul: f1.len != 12");
        let f2: &[u64; 12] = f2.try_into().expect("opc_bls12_381_complex_mul: f2.len != 12");
        let mut f3 = [0u64; 12];

        precompiles_helpers::bls12_381_complex_mul(f1, f2, &mut f3);

        // [0:f1,f2]
        for (i, d) in f3.iter().enumerate() {
            ctx.mem.write(data[0] + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Bls12_381ComplexMul can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_bls12_381_complex_mul(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_bls12_381_complex_mul() is not implemented");
}

pub fn ops_bls12_381_complex_mul(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[12, 12], &[], 1);
}
