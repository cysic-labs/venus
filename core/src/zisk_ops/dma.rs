//! DMA operations: memory copy, compare and set, and input copy

use precompiles_helpers::DmaInfo;

use super::{OpStats, ZiskOp};
use crate::{EmulationMode, InstContext, EXTRA_PARAMS_ADDR, FCALL_RESULT_MAX_SIZE};

const DMA_64_ALIGNED_OPS_BY_ROW: usize = 4;

pub fn opc_dma_memcpy(ctx: &mut InstContext) {
    opc_dma_memcpys(ctx, false)
}
pub fn opc_dma_xmemcpy(ctx: &mut InstContext) {
    opc_dma_memcpys(ctx, true)
}
fn opc_dma_memcpys(ctx: &mut InstContext, extended: bool) {
    let dst = ctx.a;
    let src = ctx.b;

    match ctx.emulation_mode {
        EmulationMode::Mem => {
            let count =
                if extended { ctx.extended_arg as u64 } else { ctx.mem.read(EXTRA_PARAMS_ADDR, 8) };
            ctx.mem.memcpy(dst, src, count);
        }
        EmulationMode::GenerateMemReads => {
            // In generate mode we need to populate precompiled.input_data with
            // information needed
            let count =
                if extended { ctx.extended_arg as u64 } else { ctx.mem.read(EXTRA_PARAMS_ADDR, 8) };
            ctx.precompiled.input_data.clear();

            #[cfg(feature = "log_dma_ops")]
            println!("opc_dma_memcpy 0x{dst:08X} 0x{src:08X} {count} GMR STEP:{}", ctx.step);

            let encoded = DmaInfo::encode_memcpy(dst, src, count as usize);
            ctx.precompiled.input_data.push(encoded);

            if count > 0 {
                // read first dst unaligned part for dma-pre
                let mut data_len = 0;
                let dst64 = dst & !0x07;
                // if dst64 != dst {
                if DmaInfo::get_pre_count(encoded) > 0 {
                    let pre_data = ctx.mem.read(dst64, 8);
                    data_len += 1;
                    ctx.precompiled.input_data.push(pre_data);
                }

                // read last dst unaligned part for dma-post
                let to_dst = dst + count - 1;
                // if to_dst & 0x07 != 0x07 {
                if DmaInfo::get_post_count(encoded) > 0 {
                    let post_data = ctx.mem.read(to_dst & !0x07, 8);
                    data_len += 1;
                    // println!("ADDING_POST_DATA 0x{:08X} 0x{post_data:016X}", to_dst & !0x07);
                    ctx.precompiled.input_data.push(post_data);
                }

                // read all source 64-words
                let src64 = src & !0x07;
                let to_src64 = (src + count - 1) & !0x07;

                let src64_count = (to_src64 - src64 + 8) >> 3;
                ctx.mem.push_from_mem(&mut ctx.precompiled.input_data, src64, src64_count * 8);
                data_len += src64_count;
                #[cfg(feature = "debug_dma")]
                println!(
                    "PRECOMPILED.MEMCPY.INPUT_DATA: [{}] data_len:{data_len}",
                    ctx.precompiled
                        .input_data
                        .iter()
                        .map(|x| format!("0x{x:016X}"))
                        .collect::<Vec<_>>()
                        .join(",")
                );
                assert_eq!(data_len as usize, DmaInfo::get_data_size(encoded));

                ctx.mem.memcpy(dst, src, count);
            }
            ctx.precompiled.output_data.clear();

            ctx.precompiled.step = ctx.step;
        }
        EmulationMode::ConsumeMemReads => {
            let encoded = ctx.precompiled.input_data[0];
            let count = DmaInfo::get_count(encoded);
            #[cfg(feature = "debug_dma")]
            println!(
                "opc_dma_memcpy 0x{dst:08X} 0x{src:08X} {count} CMR STEP:{} DATA_EXT_LEN:{}",
                ctx.step,
                DmaInfo::get_data_size(encoded)
            );
            ctx.data_ext_len = DmaInfo::get_data_size(encoded);
        }
    }
    ctx.c = dst;
    ctx.flag = false;
}

/// Unimplemented.  Arith256 can only be called from the system call context via InstContext.
/// This is provided just for completeness.
#[inline(always)]
pub fn op_dma_memcpy(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_dma_memcpy() is not implemented");
}
#[inline(always)]
pub fn op_dma_xmemcpy(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_dma_xmemcpy() is not implemented");
}

#[inline(always)]
pub fn ops_dma_memcpy(ctx: &InstContext, stats: &mut dyn OpStats) {
    ops_dma_memcpys(ctx, stats, false)
}
#[inline(always)]
pub fn ops_dma_xmemcpy(ctx: &InstContext, stats: &mut dyn OpStats) {
    ops_dma_memcpys(ctx, stats, true)
}

/// Number of whole 64-bit words a DMA operation processes between its pre and post bytes.
#[inline(always)]
fn dma_loop_count(count: u64, pre_count: u64, post_count: u64) -> usize {
    ((count - pre_count - post_count) >> 3) as usize
}

#[inline(always)]
fn ops_dma_memcpys(ctx: &InstContext, stats: &mut dyn OpStats, extended: bool) {
    let addr_a = ctx.a;
    let addr_b = ctx.b;
    let count = if extended { ctx.extended_arg as u64 } else { ctx.mem.read(EXTRA_PARAMS_ADDR, 8) };
    // pre, post, dma_align, dma_unalign
    if count == 0 {
        return;
    }

    let offset_a = addr_a & 0x07;
    let offset_b = addr_b & 0x07;
    let addr64_a = addr_a - offset_a;
    let addr64_b = addr_b - offset_b;
    let pre_count = std::cmp::min((8 - offset_a) & 0x07, count);

    if pre_count > 0 {
        stats.mem_align_read(addr64_a, 1);
        stats.mem_align_read(addr64_b, 1 + ((offset_b + pre_count) > 8) as usize);
        stats.mem_align_write(addr64_a, 1);
    }

    let post_count = (count - pre_count) & 0x07;
    let remain_b = (16 - offset_a - pre_count) & 0x07;
    let addr64_a_end = (addr_a + count - 1) & !0x07;
    let addr64_b_end = (addr_b + count - 1) & !0x07;
    if post_count > 0 {
        let extra_b = (remain_b < post_count) as u64;
        stats.mem_align_read(addr64_a_end, 1);
        stats.mem_align_read(addr64_b_end - extra_b * 8, 1 + extra_b as usize);
        stats.mem_align_write(addr64_a_end, 1);
    }

    let loop_count = dma_loop_count(count, pre_count, post_count);
    if loop_count == 0 {
        // with count < 8, there aren't 64-bits loops.
        stats.add_extras(&[
            (ZiskOp::_DMA_PRE, (pre_count > 0) as usize),
            (ZiskOp::_DMA_POST, (post_count > 0) as usize),
        ]);
    } else {
        // calculate the resources used by 64-bits loop.
        // count used are number of bytes read to demostrate memcmp(), usually count_eq + 1,
        // but if all bytes are equal count = count_eq, no need extra reads
        let first_loop_dst64 = (addr_a + pre_count) & !0x07;
        let first_loop_src64 = (addr_b + pre_count) & !0x07;

        // same alignment
        if addr_a & 0x07 == addr_b & 0x07 {
            stats.mem_align_read(first_loop_src64, loop_count);
            stats.mem_align_write(first_loop_dst64, loop_count);
            // add information about other machines to demostrate operation
            let units = loop_count.div_ceil(DMA_64_ALIGNED_OPS_BY_ROW);
            stats.add_extras(&[
                (ZiskOp::_DMA_PRE, (pre_count > 0) as usize),
                (ZiskOp::_DMA_POST, (post_count > 0) as usize),
                (ZiskOp::_DMA_64_ALIGNED, loop_count),
            ]);
        } else {
            stats.mem_align_read(first_loop_src64, loop_count + 1);
            stats.mem_align_write(first_loop_dst64, loop_count);
            // add information about other machines to demostrate operation
            stats.add_extras(&[
                (ZiskOp::_DMA_PRE, (pre_count > 0) as usize),
                (ZiskOp::_DMA_POST, (post_count > 0) as usize),
                (ZiskOp::_DMA_UNALIGNED, loop_count + 1),
            ]);
        }
    }
}

#[inline(always)]
pub fn opc_dma_memcmp(ctx: &mut InstContext) {
    opc_dma_memcmps(ctx, false)
}
#[inline(always)]
pub fn opc_dma_xmemcmp(ctx: &mut InstContext) {
    opc_dma_memcmps(ctx, true)
}

fn opc_dma_memcmps(ctx: &mut InstContext, extended: bool) {
    let dst = ctx.a;
    let src = ctx.b;
    let step = ctx.step;

    match ctx.emulation_mode {
        EmulationMode::Mem => {
            let count =
                if extended { ctx.extended_arg as u64 } else { ctx.mem.read(EXTRA_PARAMS_ADDR, 8) };
            let (result, effective_count) = ctx.mem.memcmp(dst, src, count);
            ctx.stats_hint = effective_count as u64;
            ctx.c = result;
        }
        EmulationMode::GenerateMemReads => {
            // In generate mode we need to populate precompiled.input_data with
            // information needed
            let count =
                if extended { ctx.extended_arg as u64 } else { ctx.mem.read(EXTRA_PARAMS_ADDR, 8) };
            ctx.precompiled.input_data.clear();

            #[cfg(feature = "log_dma_ops")]
            println!("opc_dma_memcmp 0x{dst:08X} 0x{src:08X} {count} GMR STEP:{step}");
            let (result, effective_count) = ctx.mem.memcmp(dst, src, count);

            let encoded = DmaInfo::encode_memcmp(dst, src, effective_count, result);
            ctx.precompiled.input_data.push(encoded);
            ctx.precompiled.input_data.push(count);

            if count > 0 {
                // read first dst unaligned part for dma-pre
                let mut data_len = 0;
                let dst64 = dst & !0x07;
                // if dst64 != dst {
                if DmaInfo::get_pre_count(encoded) > 0 {
                    let pre_data = ctx.mem.read(dst64, 8);
                    data_len += 1;
                    ctx.precompiled.input_data.push(pre_data);
                }

                let effective_count = effective_count as u64;
                // read last dst unaligned part for dma-post
                let to_dst = dst + effective_count - 1;
                // if to_dst & 0x07 != 0x07 {
                if DmaInfo::get_post_count(encoded) > 0 {
                    let post_data = ctx.mem.read(to_dst & !0x07, 8);
                    data_len += 1;
                    // println!("ADDING_POST_DATA 0x{:08X} 0x{post_data:016X}", to_dst & !0x07);
                    ctx.precompiled.input_data.push(post_data);
                }

                // read all source 64-words
                let src64 = src & !0x07;
                let to_src64 = (src + effective_count - 1) & !0x07;

                let src64_count = (to_src64 - src64 + 8) >> 3;
                ctx.mem.push_from_mem(&mut ctx.precompiled.input_data, src64, src64_count * 8);
                data_len += src64_count;
                #[cfg(feature = "debug_dma")]
                println!(
                    "PRECOMPILED.MEMCMP.INPUT_DATA: [{}] data_len:{data_len}",
                    ctx.precompiled
                        .input_data
                        .iter()
                        .map(|x| format!("0x{x:016X}"))
                        .collect::<Vec<_>>()
                        .join(",")
                );
                assert_eq!(data_len as usize, DmaInfo::get_data_size(encoded));
            }

            ctx.precompiled.output_data.clear();
            ctx.precompiled.step = step;
            ctx.c = result;
        }
        EmulationMode::ConsumeMemReads => {
            let encoded = ctx.precompiled.input_data[0];
            let count = DmaInfo::get_count(encoded);
            ctx.data_ext_len = DmaInfo::get_data_size(encoded);
            ctx.c = DmaInfo::get_memcmp_res_as_u64(encoded);
            #[cfg(feature = "debug_dma")]
            println!(
                "opc_dma_memcmp 0x{dst:08X} 0x{src:08X} {count} CMR 0x{:016X} STEP:{} DATA_EXT_LEN:{}",
                ctx.c,
                ctx.step,
                ctx.data_ext_len
            );
        }
    }
    ctx.flag = false;
}

/// Unimplemented. DmaMemCmp and DmaXºMemCmp can only be called from the system call context
/// via InstContext. This is provided just for completeness.
#[inline(always)]
pub fn op_dma_memcmp(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_dma_memcmp() is not implemented");
}

#[inline(always)]
pub fn op_dma_xmemcmp(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_dma_xmemcmp() is not implemented");
}

#[inline(always)]
pub fn ops_dma_memcmp(ctx: &InstContext, stats: &mut dyn OpStats) {
    ops_dma_memcmps(ctx, stats, false)
}
#[inline(always)]
pub fn ops_dma_xmemcmp(ctx: &InstContext, stats: &mut dyn OpStats) {
    ops_dma_memcmps(ctx, stats, true)
}

#[inline(always)]
fn ops_dma_memcmps(ctx: &InstContext, stats: &mut dyn OpStats, extended: bool) {
    let addr_a = ctx.a;
    let addr_b = ctx.b;
    // let _bus_count = if extended { ctx.extended_arg as u64 } else { ctx.mem.read(EXTRA_PARAMS_ADDR, 8) };
    let count = ctx.stats_hint;

    // pre, post, dma_align, dma_unalign
    if count == 0 {
        return;
    }

    let (res, count_eq) = ctx.mem.memcmp(addr_a, addr_b, count);
    let count = if count_eq as u64 == count { count } else { count_eq as u64 + 1 };
    let offset_a = addr_a & 0x07;
    let offset_b = addr_b & 0x07;
    let addr64_a = addr_a - offset_a;
    let addr64_b = addr_b - offset_b;
    let pre_count = std::cmp::min((8 - offset_a) & 0x07, count);

    if pre_count > 0 {
        stats.mem_align_read(addr64_a, 1);
        stats.mem_align_read(addr64_b, 1 + ((offset_b + pre_count) > 8) as usize);
        stats.mem_align_read(addr64_a, 1);
    }

    let post_count = (count - pre_count) & 0x07;
    let remain_b = (16 - offset_a - pre_count) & 0x07;
    let addr64_a_end = (addr_a + count - 1) & !0x07;
    let addr64_b_end = (addr_b + count - 1) & !0x07;
    if post_count > 0 {
        let extra_b = (remain_b < post_count) as u64;
        stats.mem_align_read(addr64_a_end, 1);
        stats.mem_align_read(addr64_b_end - extra_b * 8, 1 + extra_b as usize);
        stats.mem_align_read(addr64_a_end, 1);
    }

    let loop_count = dma_loop_count(count, pre_count, post_count);
    if loop_count == 0 {
        // with count < 8, there aren't 64-bits loops.
        stats.add_extras(&[
            (ZiskOp::_DMA_PRE, (pre_count > 0) as usize),
            (ZiskOp::_DMA_POST, (post_count > 0) as usize),
        ]);
    } else {
        // calculate the resources used by 64-bits loop.
        // count used are number of bytes read to demostrate memcmp(), usually count_eq + 1,
        // but if all bytes are equal count = count_eq, no need extra reads
        let first_loop_dst64 = (addr_a + pre_count) & !0x07;
        let first_loop_src64 = (addr_b + pre_count) & !0x07;

        // same alignment
        if addr_a & 0x07 == addr_b & 0x07 {
            stats.mem_align_read(first_loop_src64, loop_count);
            stats.mem_align_read(first_loop_dst64, loop_count);
            // add information about other machines to demostrate operation
            let units = loop_count.div_ceil(DMA_64_ALIGNED_OPS_BY_ROW);
            stats.add_extras(&[
                (ZiskOp::_DMA_PRE, (pre_count > 0) as usize),
                (ZiskOp::_DMA_POST, (post_count > 0) as usize),
                (ZiskOp::_DMA_64_ALIGNED, loop_count),
            ]);
        } else {
            stats.mem_align_read(first_loop_src64, loop_count + 1);
            stats.mem_align_read(first_loop_dst64, loop_count);
            // add information about other machines to demostrate operation
            stats.add_extras(&[
                (ZiskOp::_DMA_PRE, (pre_count > 0) as usize),
                (ZiskOp::_DMA_POST, (post_count > 0) as usize),
                (ZiskOp::_DMA_UNALIGNED, loop_count + 1),
            ]);
        }
    }
}

fn read_from_input(ctx: &mut InstContext, dst: u64, count: u64) {
    // Check for consistency
    if count % 8 != 0 {
        panic!("opc_dma_inputcpy() called without invalid count {count}");
    }
    let count64 = count >> 3;
    if ctx.fcall.result_size == 0 {
        panic!("opc_dma_inputcpy() called with ctx.fcall.result_size==0");
    }
    if ctx.fcall.result_size as usize > FCALL_RESULT_MAX_SIZE {
        panic!(
            "opc_dma_inputcpy() called with ctx.fcall.result_size=={}>32",
            ctx.fcall.result_size
        );
    }
    if (ctx.fcall.result_got - 1 + count64) > ctx.fcall.result_size {
        panic!(
            "opc_dma_inputcpy() called with ctx.fcall.result_got({}) + {count64} >= ctx.fcall.result_size {}",
            ctx.fcall.result_got, ctx.fcall.result_size
        );
    }
    ctx.mem.memcpy_from_data(
        dst,
        count,
        &ctx.fcall.result,
        (ctx.fcall.result_got - 1) as usize * 8,
    );
    ctx.fcall.result_got += count64;
    if ctx.fcall.result_got > ctx.fcall.result_size {
        ctx.mem.free_input = 0;
    } else {
        ctx.mem.free_input = ctx.fcall.result[ctx.fcall.result_got as usize - 1];
    }
}

fn read_and_get_from_input(ctx: &mut InstContext, dst: u64, count: u64) -> Vec<u64> {
    // Check for consistency
    if count % 8 != 0 {
        panic!("opc_dma_inputcpy() called at 0x{:08x} without invalid count {count}", ctx.pc);
    }
    let count64 = count >> 3;
    if ctx.fcall.result_size == 0 {
        panic!("opc_dma_inputcpy() called at 0x{:08x} with ctx.fcall.result_size==0", ctx.pc);
    }
    if ctx.fcall.result_size as usize > FCALL_RESULT_MAX_SIZE {
        panic!(
            "opc_dma_inputcpy() called at 0x{:08x} with ctx.fcall.result_size=={}>32",
            ctx.pc, ctx.fcall.result_size
        );
    }
    if (ctx.fcall.result_got - 1 + count64) > ctx.fcall.result_size {
        panic!(
            "opc_dma_inputcpy() called at 0x{:08x} with ctx.fcall.result_got({}) + {count64} >= ctx.fcall.result_size {}",
            ctx.pc, ctx.fcall.result_got, ctx.fcall.result_size
        );
    }

    ctx.mem.memcpy_from_data(
        dst,
        count,
        &ctx.fcall.result,
        (ctx.fcall.result_got - 1) as usize * 8,
    );

    let offset = (dst & 0x07) as usize;
    let start_index = (ctx.fcall.result_got - 1) as usize;
    let mut qwords_added = 0;
    let mut input_data = Vec::new();

    if offset == 0 {
        // Fast path: aligned, direct copy
        for i in 0..count64 as usize {
            input_data.push(ctx.fcall.result[start_index + i]);
            qwords_added += 1;
        }
    } else {
        // Slow path: unaligned, need to shift and merge words
        // When unaligned, we need count64 + 1 output words
        let shift_bits = (offset * 8) as u32;
        let shift_bits_comp = 64 - shift_bits;

        // First word: padding zeros in lower bytes, first data bytes in upper bytes
        let first_word = ctx.fcall.result[start_index] << shift_bits;
        input_data.push(first_word);
        qwords_added += 1;

        // Middle words: merge parts of consecutive data words
        for i in 0..(count64 as usize - 1) {
            let low_part = ctx.fcall.result[start_index + i] >> shift_bits_comp;
            let high_part = ctx.fcall.result[start_index + i + 1] << shift_bits;
            input_data.push(low_part | high_part);
            qwords_added += 1;
        }

        // Last word: remaining bytes from last data word
        if count64 > 0 {
            let last_word = ctx.fcall.result[start_index + count64 as usize - 1] >> shift_bits_comp;
            input_data.push(last_word);
            qwords_added += 1;
        }
    }

    ctx.fcall.result_got += count64;
    if ctx.fcall.result_got > ctx.fcall.result_size {
        ctx.mem.free_input = 0;
    } else {
        ctx.mem.free_input = ctx.fcall.result[ctx.fcall.result_got as usize - 1];
    }

    input_data
}

#[inline(always)]
pub(super) fn opc_dma_inputcpy(ctx: &mut InstContext) {
    let dst: u64 = ctx.a;
    let count = ctx.b;

    match ctx.emulation_mode {
        EmulationMode::Mem => {
            read_from_input(ctx, dst, count);
        }
        EmulationMode::GenerateMemReads => {
            // In generate mode we need to populate precompiled.input_data with
            // information needed
            ctx.precompiled.input_data.clear();

            #[cfg(feature = "log_dma_ops")]
            println!("opc_dma_inputcpy 0x{dst:08X} {count} GMR STEP:{}", ctx.step);

            let encoded = DmaInfo::encode_inputcpy(dst, count as usize);
            ctx.precompiled.input_data.push(encoded);

            if count > 0 {
                // read first dst unaligned part for dma-pre
                let mut data_len = 0;
                let dst64 = dst & !0x07;
                // if dst64 != dst {
                if DmaInfo::get_pre_count(encoded) > 0 {
                    let pre_data = ctx.mem.read(dst64, 8);
                    data_len += 1;
                    ctx.precompiled.input_data.push(pre_data);
                }

                // read last dst unaligned part for dma-post
                let to_dst = dst + count - 1;
                // if to_dst & 0x07 != 0x07 {
                if DmaInfo::get_post_count(encoded) > 0 {
                    let post_data = ctx.mem.read(to_dst & !0x07, 8);
                    data_len += 1;
                    ctx.precompiled.input_data.push(post_data);
                }
                #[cfg(feature = "debug_dma")]
                println!(
                    "PRECOMPILED.INPUTCPY.INPUT_DATA: [{}] data_len:{data_len}",
                    ctx.precompiled
                        .input_data
                        .iter()
                        .map(|x| format!("0x{x:016X}"))
                        .collect::<Vec<_>>()
                        .join(",")
                );

                let input_data = read_and_get_from_input(ctx, dst, count);
                data_len += input_data.len();

                assert_eq!(data_len, DmaInfo::get_data_size(encoded));

                ctx.precompiled.input_data.extend(input_data);
            }
            ctx.precompiled.output_data.clear();
            ctx.precompiled.step = ctx.step;
        }
        EmulationMode::ConsumeMemReads => {
            let encoded = ctx.precompiled.input_data[0];
            let count = DmaInfo::get_count(encoded);
            #[cfg(feature = "debug_dma")]
            println!(
                "opc_dma_inputcpy 0x{dst:08X} {count} CMR STEP:{} DATA_EXT_LEN:{}",
                ctx.step,
                DmaInfo::get_data_size(encoded)
            );
            ctx.data_ext_len = DmaInfo::get_data_size(encoded);
        }
    }
    ctx.c = dst;
    ctx.flag = false;
}

#[inline(always)]
pub fn op_dma_inputcpy(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_dma_inputcpy() is not implemented");
}

#[inline(always)]
pub fn ops_dma_inputcpy(ctx: &InstContext, stats: &mut dyn OpStats) {
    let addr_a = ctx.a;
    let count = ctx.b;

    // pre, post, dma_align, dma_unalign
    if count == 0 {
        return;
    }

    let offset_a = addr_a & 0x07;
    let addr64_a = addr_a - offset_a;
    let pre_count = std::cmp::min((8 - offset_a) & 0x07, count);

    if pre_count > 0 {
        stats.mem_align_read(addr64_a, 1);
        stats.mem_align_write(addr64_a, 1);
    }

    let post_count = (count - pre_count) & 0x07;
    let addr64_a_end = (addr_a + count - 1) & !0x07;
    if post_count > 0 {
        stats.mem_align_read(addr64_a_end, 1);
        stats.mem_align_write(addr64_a_end, 1);
    }

    let loop_count = dma_loop_count(count, pre_count, post_count);
    if loop_count == 0 {
        // with count < 8, there aren't 64-bits loops.
        stats.add_extras(&[
            (ZiskOp::_DMA_PRE, (pre_count > 0) as usize),
            (ZiskOp::_DMA_POST, (post_count > 0) as usize),
        ]);
    } else {
        // calculate the resources used by 64-bits loop.
        // count used are number of bytes read to demostrate memcmp(), usually count_eq + 1,
        // but if all bytes are equal count = count_eq, no need extra reads
        let first_loop_dst64 = (addr_a + pre_count) & !0x07;

        stats.mem_align_write(first_loop_dst64, loop_count);
        stats.add_extras(&[
            (ZiskOp::_DMA_PRE, (pre_count > 0) as usize),
            (ZiskOp::_DMA_POST, (post_count > 0) as usize),
            (ZiskOp::_DMA_64_ALIGNED, loop_count),
        ]);
    }
}

#[inline(always)]
pub fn opc_dma_xmemset(ctx: &mut InstContext) {
    let dst = ctx.a;
    let count = ctx.b;
    let fill_byte = ctx.extended_arg as u8;

    match ctx.emulation_mode {
        EmulationMode::Mem => {
            ctx.mem.memset(dst, count, fill_byte);
        }
        EmulationMode::GenerateMemReads => {
            // In generate mode we need to populate precompiled.input_data with
            // information needed
            ctx.precompiled.input_data.clear();

            #[cfg(feature = "log_dma_ops")]
            println!(
                "opc_dma_memset 0x{dst:08X} 0x{fill_byte:02X} {count} GMR STEP:{} PC:0x{:08x}",
                ctx.step, ctx.pc
            );

            let encoded = DmaInfo::encode_memset(dst, count as usize, fill_byte);
            ctx.precompiled.input_data.push(encoded);

            if count > 0 {
                // read first dst unaligned part for dma-pre
                let mut data_len = 0;
                let dst64 = dst & !0x07;
                // if dst64 != dst {
                if DmaInfo::get_pre_count(encoded) > 0 {
                    let pre_data = ctx.mem.read(dst64, 8);
                    data_len += 1;
                    ctx.precompiled.input_data.push(pre_data);
                }

                // read last dst unaligned part for dma-post
                let to_dst = dst + count - 1;
                // if to_dst & 0x07 != 0x07 {
                if DmaInfo::get_post_count(encoded) > 0 {
                    let post_data = ctx.mem.read(to_dst & !0x07, 8);
                    data_len += 1;
                    ctx.precompiled.input_data.push(post_data);
                }
                #[cfg(feature = "log_dma_ops")]
                println!(
                    "PRECOMPILED.MEMSET.INPUT_DATA: [{}] data_len:{data_len}",
                    ctx.precompiled
                        .input_data
                        .iter()
                        .map(|x| format!("0x{x:016X}"))
                        .collect::<Vec<_>>()
                        .join(",")
                );
                assert_eq!(data_len as usize, DmaInfo::get_pre_writes(encoded));
                ctx.mem.memset(dst, count, fill_byte);
            }
            ctx.precompiled.output_data.clear();
            ctx.precompiled.step = ctx.step;
        }
        EmulationMode::ConsumeMemReads => {
            let encoded = ctx.precompiled.input_data[0];
            let count = DmaInfo::get_count(encoded);
            #[cfg(feature = "debug_dma")]
            println!(
                "opc_dma_memset 0x{dst:08X} 0x{fill_byte:02X} {count} CMR STEP:{} DATA_EXT_LEN:{}",
                ctx.step,
                DmaInfo::get_data_size(encoded)
            );
            ctx.data_ext_len = DmaInfo::get_pre_writes(encoded);
        }
    }
    ctx.c = dst;
    ctx.flag = false;
}

#[inline(always)]
pub fn op_dma_xmemset(_a: u64, _b: u64) -> (u64, bool) {
    unimplemented!("op_dma_memset() is not implemented");
}

#[inline(always)]
pub fn ops_dma_xmemset(ctx: &InstContext, stats: &mut dyn OpStats) {
    let addr_a = ctx.a;
    let count = ctx.b;

    // pre, post, dma_align, dma_unalign
    if count == 0 {
        return;
    }

    let offset_a = addr_a & 0x07;
    let addr64_a = addr_a - offset_a;
    let pre_count = std::cmp::min((8 - offset_a) & 0x07, count);

    if pre_count > 0 {
        stats.mem_align_read(addr64_a, 1);
        stats.mem_align_write(addr64_a, 1);
    }

    let post_count = (count - pre_count) & 0x07;
    let addr64_a_end = (addr_a + count - 1) & !0x07;
    if post_count > 0 {
        stats.mem_align_read(addr64_a_end, 1);
        stats.mem_align_write(addr64_a_end, 1);
    }

    let loop_count = dma_loop_count(count, pre_count, post_count);
    if loop_count == 0 {
        // with count < 8, there aren't 64-bits loops.
        stats.add_extras(&[
            (ZiskOp::_DMA_PRE, (pre_count > 0) as usize),
            (ZiskOp::_DMA_POST, (post_count > 0) as usize),
        ]);
    } else {
        // calculate the resources used by 64-bits loop.
        // count used are number of bytes read to demostrate memcmp(), usually count_eq + 1,
        // but if all bytes are equal count = count_eq, no need extra reads
        let first_loop_dst64 = (addr_a + pre_count) & !0x07;

        stats.mem_align_write(first_loop_dst64, loop_count);
        // add information about other machines to demostrate operation
        stats.add_extras(&[
            (ZiskOp::_DMA_PRE, (pre_count > 0) as usize),
            (ZiskOp::_DMA_POST, (post_count > 0) as usize),
            (ZiskOp::_DMA_64_ALIGNED, loop_count),
        ]);
    }
}
