//! Elliptic curve precompiles: point addition and doubling of secp256k1, secp256r1, bn254 and
//! bls12-381

use super::{
    precompiled::{precompiled_load_data, precompiled_stats_data, precompiled_stats_direct_data},
    OpStats,
};
use crate::{EmulationMode, InstContext};

#[inline(always)]
pub fn opc_secp256k1_add(ctx: &mut InstContext) {
    const WORDS: usize = 2 + 2 * 8;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 2, 2, 8, 0, None, &mut data, "secp256k1_add");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // ignore 2 indirections
        let (_, rest) = data.split_at(2);
        let (p1, p2) = rest.split_at(8);

        let p1: &[u64; 8] = p1.try_into().expect("opc_secp256k1_add: p1.len != 8");
        let p2: &[u64; 8] = p2.try_into().expect("opc_secp256k1_add: p2.len != 8");
        let mut p3 = [0u64; 8];

        precompiles_helpers::secp256k1_add(p1, p2, &mut p3);

        // [0:p1,p2]
        for (i, d) in p3.iter().enumerate() {
            ctx.mem.write(data[0] + (8 * i as u64), *d, 8);
        }
    }
    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Secp256k1Add can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_secp256k1_add(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_secp256k1_add() is not implemented");
}

#[inline(always)]
pub fn ops_secp256k1_add(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[8, 8], &[], 1);
}

#[inline(always)]
pub fn opc_secp256k1_dbl(ctx: &mut InstContext) {
    const WORDS: usize = 8; // one input of 8 64-bit words
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 0, 1, 8, 0, None, &mut data, "secp256k1_dbl");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        let p1: &[u64; 8] = &data;
        let mut p3 = [0u64; 8];

        precompiles_helpers::secp256k1_dbl(p1, &mut p3);

        for (i, d) in p3.iter().enumerate() {
            ctx.mem.write(ctx.b + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Secp256k1Dbl can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_secp256k1_dbl(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_secp256k1_dbl() is not implemented");
}

#[inline(always)]
pub fn ops_secp256k1_dbl(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_direct_data(ctx, stats, 8, 8);
}

#[inline(always)]
pub fn opc_secp256r1_add(ctx: &mut InstContext) {
    const WORDS: usize = 2 + 2 * 8;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 2, 2, 8, 0, None, &mut data, "secp256r1_add");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // ignore 2 indirections
        let (_, rest) = data.split_at(2);
        let (p1, p2) = rest.split_at(8);

        let p1: &[u64; 8] = p1.try_into().expect("opc_secp256r1_add: p1.len != 8");
        let p2: &[u64; 8] = p2.try_into().expect("opc_secp256r1_add: p2.len != 8");
        let mut p3 = [0u64; 8];

        precompiles_helpers::secp256r1_add(p1, p2, &mut p3);

        // [0:p1,p2]
        for (i, d) in p3.iter().enumerate() {
            ctx.mem.write(data[0] + (8 * i as u64), *d, 8);
        }
    }
    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Secp256r1Add can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_secp256r1_add(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_secp256r1_add() is not implemented");
}

#[inline(always)]
pub fn ops_secp256r1_add(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[8, 8], &[], 1);
}

#[inline(always)]
pub fn opc_secp256r1_dbl(ctx: &mut InstContext) {
    const WORDS: usize = 8; // one input of 8 64-bit words
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 0, 1, 8, 0, None, &mut data, "secp256r1_dbl");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        let p1: &[u64; 8] = &data;
        let mut p3 = [0u64; 8];

        precompiles_helpers::secp256r1_dbl(p1, &mut p3);

        for (i, d) in p3.iter().enumerate() {
            ctx.mem.write(ctx.b + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Secp256r1Dbl can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_secp256r1_dbl(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_secp256r1_dbl() is not implemented");
}

#[inline(always)]
pub fn ops_secp256r1_dbl(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_direct_data(ctx, stats, 8, 8);
}

#[inline(always)]
pub fn opc_bn254_curve_add(ctx: &mut InstContext) {
    const WORDS: usize = 2 + 2 * 8;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 2, 2, 8, 0, None, &mut data, "bn254_curve_add");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // ignore 2 indirections
        let (_, rest) = data.split_at(2);
        let (p1, p2) = rest.split_at(8);

        let p1: &[u64; 8] = p1.try_into().expect("opc_bn254_curve_add: p1.len != 8");
        let p2: &[u64; 8] = p2.try_into().expect("opc_bn254_curve_add: p2.len != 8");
        let mut p3 = [0u64; 8];

        precompiles_helpers::bn254_curve_add(p1, p2, &mut p3);

        // [0:p1,p2]
        for (i, d) in p3.iter().enumerate() {
            ctx.mem.write(data[0] + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Bn254CurveAdd can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_bn254_curve_add(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_bn254_curve_add() is not implemented");
}

#[inline(always)]
pub fn ops_bn254_curve_add(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[8, 8], &[], 1);
}

#[inline(always)]
pub fn opc_bn254_curve_dbl(ctx: &mut InstContext) {
    const WORDS: usize = 8; // one input of 8 64-bit words
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 0, 1, 8, 0, None, &mut data, "bn254_curve_dbl");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        let p1: &[u64; 8] = &data;
        let mut p3 = [0u64; 8];

        precompiles_helpers::bn254_curve_dbl(p1, &mut p3);

        for (i, d) in p3.iter().enumerate() {
            ctx.mem.write(ctx.b + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Bn254CurveDbl can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_bn254_curve_dbl(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_bn254_curve_dbl() is not implemented");
}

#[inline(always)]
pub fn ops_bn254_curve_dbl(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_direct_data(ctx, stats, 8, 8);
}

#[inline(always)]
pub fn opc_bls12_381_curve_add(ctx: &mut InstContext) {
    const WORDS: usize = 2 + 2 * 12;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 2, 2, 12, 0, None, &mut data, "bls12_381_curve_add");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // ignore 2 indirections
        let (_, rest) = data.split_at(2);
        let (p1, p2) = rest.split_at(12);

        let p1: &[u64; 12] = p1.try_into().expect("opc_bls12_381_curve_add: p1.len != 12");
        let p2: &[u64; 12] = p2.try_into().expect("opc_bls12_381_curve_add: p2.len != 12");
        let mut p3 = [0u64; 12];

        precompiles_helpers::bls12_381_curve_add(p1, p2, &mut p3);

        // [0:p1,p2]
        for (i, d) in p3.iter().enumerate() {
            ctx.mem.write(data[0] + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Bls12_381CurveAdd can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_bls12_381_curve_add(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_bls12_381_curve_add() is not implemented");
}

#[inline(always)]
pub fn ops_bls12_381_curve_add(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[12, 12], &[], 1);
}

#[inline(always)]
pub fn opc_bls12_381_curve_dbl(ctx: &mut InstContext) {
    const WORDS: usize = 12;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 0, 1, 12, 0, None, &mut data, "bls12_381_curve_dbl");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        let p1: &[u64; 12] = &data;
        let mut p3 = [0u64; 12];

        precompiles_helpers::bls12_381_curve_dbl(p1, &mut p3);

        for (i, d) in p3.iter().enumerate() {
            ctx.mem.write(ctx.b + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Bls12_381CurveDbl can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_bls12_381_curve_dbl(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_bls12_381_curve_dbl() is not implemented");
}

#[inline(always)]
pub fn ops_bls12_381_curve_dbl(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_direct_data(ctx, stats, 12, 12);
}
