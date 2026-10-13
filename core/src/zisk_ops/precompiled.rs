//! Precompile data: the load of the precompile parameters and data from memory or from the
//! mem reads, and their memory statistics

use super::OpStats;
use crate::{EmulationMode, InstContext};

#[allow(clippy::too_many_arguments)]
#[inline(always)]
pub fn precompiled_load_data(
    ctx: &mut InstContext,
    params_count: usize,
    load_indirections: usize,
    load_chunks: usize,
    load_rem: usize,
    direct_load_param_idx: Option<usize>,
    data: &mut [u64],
    title: &str,
) {
    internal_precompiled_load_data(
        ctx,
        params_count,
        load_indirections,
        load_chunks,
        load_rem,
        0,
        direct_load_param_idx,
        data,
        title,
    );
}

#[allow(clippy::too_many_arguments)]
#[inline(always)]
pub fn precompiled_load_data_with_result(
    ctx: &mut InstContext,
    params_count: usize,
    load_indirections: usize,
    load_chunks: usize,
    load_rem: usize,
    direct_load_param_idx: Option<usize>,
    data: &mut [u64],
    title: &str,
) {
    internal_precompiled_load_data(
        ctx,
        params_count,
        load_indirections,
        load_chunks,
        load_rem,
        1,
        direct_load_param_idx,
        data,
        title,
    );
}

#[allow(clippy::too_many_arguments)]
#[inline(always)]
fn internal_precompiled_load_data(
    ctx: &mut InstContext,
    params_count: usize,
    load_indirections: usize,
    load_chunks: usize,
    load_rem: usize,
    result: usize,
    direct_load_param_idx: Option<usize>, // Index of the load parameters that isn't an indirection
    data: &mut [u64],
    title: &str,
) {
    let address = ctx.b;
    if address & 0x7 != 0 {
        panic!(
            "[{title}] precompiled_check_address() found address 0x{address:08X} not aligned \
               to 8 bytes at PC:0x{:08X} STEP:{}",
            ctx.pc, ctx.step
        );
    }
    if let EmulationMode::ConsumeMemReads = ctx.emulation_mode {
        // Check input data has the expected length
        let expected_len = params_count + load_indirections * load_chunks + load_rem + result;
        if ctx.precompiled.input_data.len() != expected_len {
            panic!(
                "[{title}] ctx.precompiled.input_data.len={} != {expected_len} \
                [{params_count}+{load_indirections}*{load_chunks}+{load_rem}+{result}] at PC:0x{:08X} STEP:{}",
                ctx.precompiled.input_data.len(), ctx.pc, ctx.step,
            );
        }
        // Read data from the precompiled context
        for (i, d) in data.iter_mut().enumerate() {
            *d = ctx.precompiled.input_data[i];
        }
        // Write the input data address to the precompiled context
        // ctx.precompiled.input_data_address = address;
        return;
    }

    // Write the indirections/direct_params to data
    for (i, data) in data.iter_mut().enumerate().take(params_count) {
        let indirection = ctx.mem.read(address + (8 * i as u64), 8);
        if indirection & 0x7 != 0 && Some(i) != direct_load_param_idx {
            panic!(
                "[{title}] precompiled_check_address() found address_{i} [0x{address:08X}]=0x{indirection:08X} \
                not aligned to 8 bytes at PC:0x{:08X} STEP:{}",
                ctx.pc, ctx.step
            );
        }
        *data = indirection;
    }

    // Write the data
    let mut data_offset = params_count;
    for i in 0..load_indirections {
        let param_idx = if let Some(direct_idx) = direct_load_param_idx {
            if i >= direct_idx {
                i + 1
            } else {
                i
            }
        } else {
            i
        };

        let data_offset = i * load_chunks + data_offset;
        // if there aren't indirections, take directly from the address
        let param_address =
            if params_count == 0 { address + data_offset as u64 } else { data[param_idx] };
        for j in 0..load_chunks {
            let addr = param_address + (8 * j as u64);
            data[data_offset + j] = ctx.mem.read(addr, 8);
        }
    }

    // Process the remanent of the last chunk
    if load_rem > 0 {
        data_offset += (load_indirections - 1) * load_chunks;
        let param_address = if params_count == 0 {
            address + data_offset as u64
        } else {
            data[load_indirections - 1]
        };
        for j in load_chunks..load_chunks + load_rem {
            let addr = param_address + (8 * j as u64);
            data[data_offset + j] = ctx.mem.read(addr, 8);
        }
    }

    if let EmulationMode::GenerateMemReads = ctx.emulation_mode {
        ctx.precompiled.input_data.clear();
        for (i, d) in data.iter_mut().enumerate() {
            ctx.precompiled.input_data.push(*d);
        }
        ctx.precompiled.step = ctx.step;
    }
}

#[inline(always)]
pub fn precompiled_stats_data(
    ctx: &InstContext,
    stats: &mut dyn OpStats,
    inputs: &[u32],
    outputs: &[u32],
    inputs_reduce_count: usize,
) {
    let param_addr = ctx.b;

    stats.mem_align_read(param_addr, inputs.len() + outputs.len());
    for (index, count) in inputs.iter().enumerate() {
        if *count == 0 {
            continue;
        }
        let input_addr = ctx.mem.read(param_addr + (8 * index as u64), 8);
        stats.mem_align_read(input_addr, *count as usize);
        if index < inputs_reduce_count {
            stats.mem_align_write(input_addr, *count as usize);
        }
    }
    let index_offset = inputs.len();
    for (index, count) in outputs.iter().enumerate() {
        if *count == 0 {
            continue;
        }
        let output_addr = ctx.mem.read(param_addr + (8 * (index + index_offset) as u64), 8);
        stats.mem_align_write(output_addr, *count as usize);
    }
}

#[inline(always)]
pub fn precompiled_stats_direct_data(
    ctx: &InstContext,
    stats: &mut dyn OpStats,
    inputs: usize,
    outputs: usize,
) {
    let param_addr = ctx.b;

    stats.mem_align_read(param_addr, inputs);
    stats.mem_align_write(param_addr, outputs);
}
