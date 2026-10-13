//! Hash precompiles: keccak, sha256, poseidon2 and blake2

use fields::{poseidon2_hash, Goldilocks, Poseidon16, PrimeField64};
use tiny_keccak::keccakf;

use super::{
    precompiled::{precompiled_load_data, precompiled_stats_data, precompiled_stats_direct_data},
    OpStats,
};
use crate::{blake2br, sha256f, EmulationMode, InstContext};

/// Performs a Keccak-f hash over a 1600-bits input state stored in memory at the address
/// specified by register A0, and stores the output state in the same memory address
#[inline(always)]
pub fn opc_keccak(ctx: &mut InstContext) {
    // Get address from b (a = step)
    let address = ctx.b;
    if address & 0x7 != 0 {
        panic!("opc_keccak() found address not aligned to 8 bytes");
    }

    // Allocate room for 25 u64 = 128 bytes = 1600 bits
    const WORDS: usize = 25;
    let mut data = [0u64; WORDS];

    // Get input data from memory or from the precompiled context
    match ctx.emulation_mode {
        EmulationMode::Mem => {
            // Read data from the memory address
            for (i, d) in data.iter_mut().enumerate() {
                *d = ctx.mem.read(address + (8 * i as u64), 8);
            }

            // Call keccakf
            keccakf(&mut data);

            // Write data to the memory address
            for (i, d) in data.iter().enumerate() {
                ctx.mem.write(address + (8 * i as u64), *d, 8);
            }
        }
        EmulationMode::GenerateMemReads => {
            // Read data from the memory address
            for (i, d) in data.iter_mut().enumerate() {
                *d = ctx.mem.read(address + (8 * i as u64), 8);
            }

            // Copy data to the precompiled context
            ctx.precompiled.input_data.clear();
            for (i, d) in data.iter_mut().enumerate() {
                ctx.precompiled.input_data.push(*d);
            }

            // Call keccakf
            keccakf(&mut data);

            // Write data to the memory address
            for (i, d) in data.iter().enumerate() {
                ctx.mem.write(address + (8 * i as u64), *d, 8);
            }

            // Write data to the precompiled context
            ctx.precompiled.output_data.clear();
            for (i, d) in data.iter_mut().enumerate() {
                ctx.precompiled.output_data.push(*d);
            }
        }
        EmulationMode::ConsumeMemReads => {
            // Check input data has the expected length
            if ctx.precompiled.input_data.len() != WORDS {
                panic!(
                    "opc_keccak() found ctx.precompiled.input_data.len={} != {}",
                    ctx.precompiled.input_data.len(),
                    WORDS
                );
            }
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Keccak can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_keccak(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_keccak() is not implemented");
}

#[inline(always)]
pub fn ops_keccak(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_direct_data(ctx, stats, 25, 25);
}

/// Performs a Sha256-f hash over a 256-bits input state and 512-bits hash state stored in memory at the address
/// specified by register A0, and stores the output state in the same memory address
#[inline(always)]
pub fn opc_sha256(ctx: &mut InstContext) {
    // Allocate room for 12 u64 = 96 bytes = 768 bits (2 extra for indirections)
    const WORDS: usize = 2 + 2 * 4 + 4;
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 2, 2, 4, 4, None, &mut data, "sha256");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // Get the state and input slices
        let (ind, rest) = data.split_at_mut(2);
        let (state_slice, input_slice) = rest.split_at_mut(4);
        let state: &mut [u64; 4] = state_slice.try_into().unwrap();
        let input: &[u64; 8] = input_slice[..8].try_into().unwrap();

        // Compute the sha output with the fastest implementation available
        sha256f(state, input);

        for (i, d) in state.iter().enumerate() {
            ctx.mem.write(ind[0] + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Sha256 can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_sha256(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_sha256() is not implemented");
}

#[inline(always)]
pub fn ops_sha256(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[4, 8], &[], 1);
}

/// Performs a Poseidon2 hash over a 16 elements stored in memory at the address
/// specified by register A0, and stores the output state in the same memory address
#[inline(always)]
pub fn opc_poseidon2(ctx: &mut InstContext) {
    // Get address from b (a = step)
    let address = ctx.b;
    if address & 0x7 != 0 {
        panic!("opc_poseidon2() found address not aligned to 8 bytes");
    }

    // Allocate room for 16 u64 = 128 bytes = 1024 bits
    const WORDS: usize = 16;
    let mut data = [0u64; WORDS];

    // Get input data from memory or from the precompiled context
    match ctx.emulation_mode {
        EmulationMode::Mem => {
            // Read data from the memory address
            for (i, d) in data.iter_mut().enumerate() {
                *d = ctx.mem.read(address + (8 * i as u64), 8);
            }

            // Call poseidon2
            let data_gl = data.map(Goldilocks::new);
            let res_gl = poseidon2_hash::<Goldilocks, Poseidon16, 16>(&data_gl);
            for (i, d) in data.iter_mut().enumerate() {
                *d = res_gl[i].as_canonical_u64();
            }

            // Write data to the memory address
            for (i, d) in data.iter().enumerate() {
                ctx.mem.write(address + (8 * i as u64), *d, 8);
            }
        }
        EmulationMode::GenerateMemReads => {
            // Read data from the memory address
            for (i, d) in data.iter_mut().enumerate() {
                *d = ctx.mem.read(address + (8 * i as u64), 8);
            }

            // Copy data to the precompiled context
            ctx.precompiled.input_data.clear();
            for (i, d) in data.iter_mut().enumerate() {
                ctx.precompiled.input_data.push(*d);
            }

            // Call poseidon2
            let data_gl = data.map(Goldilocks::new);
            let res_gl = poseidon2_hash::<Goldilocks, Poseidon16, 16>(&data_gl);
            for (i, d) in data.iter_mut().enumerate() {
                *d = res_gl[i].as_canonical_u64();
            }

            // Write data to the memory address
            for (i, d) in data.iter().enumerate() {
                ctx.mem.write(address + (8 * i as u64), *d, 8);
            }

            // Write data to the precompiled context
            ctx.precompiled.output_data.clear();
            for (i, d) in data.iter_mut().enumerate() {
                ctx.precompiled.output_data.push(*d);
            }
        }
        EmulationMode::ConsumeMemReads => {
            // Check input data has the expected length
            if ctx.precompiled.input_data.len() != WORDS {
                panic!(
                    "opc_poseidon2() found ctx.precompiled.input_data.len={} != {}",
                    ctx.precompiled.input_data.len(),
                    WORDS
                );
            }
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Poseidon2 can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_poseidon2(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_poseidon2() is not implemented");
}

#[inline(always)]
pub fn ops_poseidon2(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_direct_data(ctx, stats, 16, 16);
}

#[inline(always)]
pub fn opc_blake2(ctx: &mut InstContext) {
    const WORDS: usize = 3 + 2 * 16; // index,addr_state,addr_input,state[16],input[16]
    let mut data = [0u64; WORDS];

    precompiled_load_data(ctx, 3, 2, 16, 0, Some(0), &mut data, "blake2");

    if ctx.emulation_mode != EmulationMode::ConsumeMemReads {
        // Get the state and input slices
        // 0 - index
        // 1 - addr_state
        // 2 - addr_input
        let index = data[0];
        let (params, rest) = data.split_at_mut(3);
        let (state_slice, input_slice) = rest.split_at_mut(16);
        let state: &mut [u64; 16] = state_slice.try_into().unwrap();
        let input: &[u64; 16] = input_slice[..16].try_into().unwrap();

        // Compute the blake2br output with the fastest implementation available
        blake2br(index, state, input);

        let state_addr = params[1];
        for (i, d) in state.iter().enumerate() {
            ctx.mem.write(state_addr + (8 * i as u64), *d, 8);
        }
    }

    ctx.c = 0;
    ctx.flag = false;
}

/// Unimplemented.  Blake2 can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_blake2(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_blake2() is not implemented");
}

#[inline(always)]
pub fn ops_blake2(ctx: &InstContext, stats: &mut dyn OpStats) {
    precompiled_stats_data(ctx, stats, &[4, 8], &[], 1);
}
