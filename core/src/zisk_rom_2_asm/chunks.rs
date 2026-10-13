//! Chunk start and end: the code that writes the chunk headers of the trace and lets the
//! host consume a finished chunk

use super::registers::{
    REG_ACTIVE_CHUNK, REG_ADDRESS, REG_AUX, REG_C, REG_MEM_READS_ADDRESS, REG_MEM_READS_SIZE,
    REG_PC, REG_STEP, REG_VALUE,
};
use crate::{ZiskAsmContext, ZiskRom2Asm};

impl ZiskRom2Asm {
    pub(super) fn chunk_start(ctx: &mut ZiskAsmContext, code: &mut String, id: &str) {
        if ctx.zip() {
            *code += &ctx.full_line_comment(
                "If chunk_id & 0x7 == chunk_mask then activate this chunk".to_string(),
            );
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_AUX,
                ctx.mem_chunk_id,
                ctx.comment_str("aux = chunk_id")
            );
            *code += &format!("\tinc {} {}\n", ctx.mem_chunk_id, ctx.comment_str("chunk_id++"));
            *code += &format!("\tand {}, 0x7 {}\n", REG_AUX, ctx.comment_str("aux &= mask"));
            *code += &format!(
                "\tcmp {}, {} {}\n",
                REG_AUX,
                ctx.mem_chunk_mask,
                ctx.comment_str("aux ?= chunk_mask")
            );
            *code += &format!("\tjz chunk_start_{id}_activate\n");
            *code += &format!(
                "\txor {}, {} {}\n",
                REG_ACTIVE_CHUNK,
                REG_ACTIVE_CHUNK,
                ctx.comment_str("deactivate chunk")
            );
            *code += &format!("\tjmp chunk_start_{id}_done\n");
            *code += &format!("chunk_start_{id}_activate:\n");
            *code +=
                &format!("\tmov {}, 1 {}\n", REG_ACTIVE_CHUNK, ctx.comment_str("activate chunk"));
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &ctx.full_line_comment(
                "Increment number of chunks (first position in trace)".to_string(),
            );
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_ADDRESS,
                ctx.mem_trace_address,
                ctx.comment_str("address = trace_addr")
            );
            *code += &format!(
                "\tmov {}, [{}] {}\n",
                REG_VALUE,
                REG_ADDRESS,
                ctx.comment_str("value = trace_addr")
            );
            *code += &format!("\tinc {} {}\n", REG_VALUE, ctx.comment_str("inc value"));
            *code += &format!(
                "\tmov [{}], {} {}\n",
                REG_ADDRESS,
                REG_VALUE,
                ctx.comment_str("trace_addr = value (trace_addr++)")
            );
        }

        if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
            *code += &ctx.full_line_comment("Write chunk start data".to_string());

            // Write chunk.start.pc
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_ADDRESS,
                ctx.mem_chunk_address,
                ctx.comment_str("address = chunk_address")
            );

            *code += &format!(
                "\tmov [{}], {} {}\n",
                REG_ADDRESS,
                REG_PC,
                ctx.comment_str("chunk.start.pc = value")
            );

            // Write chunk.start.sp
            *code +=
                &format!("\tmov {}, {} {}\n", REG_VALUE, ctx.mem_sp, ctx.comment_str("value = sp"));
            *code += &format!("\tadd {}, 8 {}\n", REG_ADDRESS, ctx.comment_str("address += 8"));
            *code += &format!(
                "\tmov [{}], {} {}\n",
                REG_ADDRESS,
                REG_VALUE,
                ctx.comment_str("chunk.start.sp = value = sp")
            );

            // Write chunk.start.c
            *code += &format!("\tadd {}, 8 {}\n", REG_ADDRESS, ctx.comment_str("address += 8"));
            *code += &format!(
                "\tmov [{}], {} {}\n",
                REG_ADDRESS,
                REG_C,
                ctx.comment_str("chunk.start.c = c")
            );

            // Write chunk.start.step
            *code += &format!("\tadd {}, 8 {}\n", REG_ADDRESS, ctx.comment_str("address += 8"));
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_VALUE,
                ctx.mem_step,
                ctx.comment_str("value = step")
            );
            *code += &format!(
                "\tmov [{}], {} {}\n",
                REG_ADDRESS,
                REG_VALUE,
                ctx.comment_str("chunk.start.step = value = step")
            );
            *code += &format!(
                "\tmov {}, {} {}\n",
                ctx.mem_chunk_start_step,
                REG_VALUE,
                ctx.comment_str("chunk.start.step = value = step")
            );

            // Write chunk.start.reg
            for i in 1..34 {
                Self::read_riscv_reg(ctx, code, i, REG_VALUE, "value");
                *code += &format!(
                    "\tmov [{} + {}], {} {}\n",
                    REG_ADDRESS,
                    i * 8,
                    REG_VALUE,
                    ctx.comment(format!("chunk.start.reg[{i}] = value"))
                );
            }
            *code +=
                &format!("\tadd {}, 33*8 {}\n", REG_ADDRESS, ctx.comment_str("address += 33*8"));
        }

        if ctx.minimal_trace() || ctx.main_trace() || ctx.zip() || ctx.mem_op() || ctx.mem_reads() {
            *code += &ctx.full_line_comment("Write mem reads size".to_string());
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_AUX,
                ctx.mem_chunk_address,
                ctx.comment_str("aux = chunk_size")
            );
            if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
                *code += &format!("\tadd {}, 40*8 {}\n", REG_AUX, ctx.comment_str("aux += 40*8"));
            }
            if ctx.mem_op() {
                // Skip chunk.end
                *code += &format!("\tadd {}, 8 {}\n", REG_AUX, ctx.comment_str("aux += 8"));
            }

            // Set mem reads size to all F's
            *code += &format!(
                "\tmov {}, 0xFFFFFFFFFFFFFFFF {}\n",
                REG_VALUE,
                ctx.comment_str("value = F's")
            );
            *code += &format!(
                "\tmov [{}], {} {}\n",
                REG_AUX,
                REG_VALUE,
                ctx.comment_str("mem_reads_size = value")
            );
            *code += &format!("\tadd {}, 8 {}\n", REG_AUX, ctx.comment_str("aux += 8"));
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_MEM_READS_ADDRESS,
                REG_AUX,
                ctx.comment_str("mem_reads_address = aux")
            );
            *code += &ctx.full_line_comment("Reset mem_reads size".to_string());
            *code += &format!(
                "\txor {}, {} {}\n",
                REG_MEM_READS_SIZE,
                REG_MEM_READS_SIZE,
                ctx.comment_str("mem_reads_size = 0")
            );
        }
        if ctx.zip() {
            *code += &format!("chunk_start_{id}_done:\n");
        }

        *code += &ctx.full_line_comment("Reset step count down to chunk_size".to_string());
        *code += &format!(
            "\tmov {}, chunk_size {}\n",
            REG_STEP,
            ctx.comment_str("step_count_down = chunk_size")
        );
    }

    pub(super) fn chunk_end(ctx: &mut ZiskAsmContext, code: &mut String, id: &str) {
        *code += &ctx.full_line_comment("Update total step from step count down".to_string());
        *code +=
            &format!("\tmov {}, {} {}\n", REG_VALUE, ctx.mem_step, ctx.comment_str("value = step"));
        *code += &format!(
            "\tadd {}, chunk_size {}\n",
            REG_VALUE,
            ctx.comment_str("value += chunk_size")
        );
        *code += &format!(
            "\tsub {}, {} {}\n",
            REG_VALUE,
            REG_STEP,
            ctx.comment_str("value -= step_count_down")
        );
        *code +=
            &format!("\tmov {}, {} {}\n", ctx.mem_step, REG_VALUE, ctx.comment_str("step = value"));

        if ctx.zip() {
            *code += &ctx.full_line_comment("If active_chunk == 0 skip this chunk".to_string());
            *code += &format!(
                "\ttest {}, 1 {}\n",
                REG_ACTIVE_CHUNK,
                ctx.comment_str("active_chunk ?= 0")
            );
            *code += &format!("\tjnz chunk_end_{id}_active_chunk\n");
            *code += &format!("\tjmp chunk_end_{id}_done\n");
            *code += &format!("chunk_end_{id}_active_chunk:\n");
        }

        if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
            *code += &ctx.full_line_comment("Write chunk last data".to_string());

            // Search position of chunk.last
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_ADDRESS,
                ctx.mem_chunk_address,
                ctx.comment_str("address = chunk_address")
            );
            *code += &format!(
                "\tadd {}, 37*8 {}\n",
                REG_ADDRESS,
                ctx.comment_str("address = chunk_address + 37*8")
            );

            // Write chunk.last.c
            *code += &format!(
                "\tmov [{}], {} {}\n",
                REG_ADDRESS,
                REG_C,
                ctx.comment_str("chunk.last.c = c")
            );

            *code += &ctx.full_line_comment("Write chunk end data".to_string());
            *code += &format!("\tadd {}, 8 {}\n", REG_ADDRESS, ctx.comment_str("address += 8"));

            // Write chunk.last.end
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_VALUE,
                ctx.mem_end,
                ctx.comment_str("value = end")
            );
            *code += &format!(
                "\tmov [{}], {} {}\n",
                REG_ADDRESS,
                REG_VALUE,
                ctx.comment_str("chunk.end = value = end")
            );
            *code += &format!("\tadd {}, 8 {}\n", REG_ADDRESS, ctx.comment_str("address += 8"));

            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_VALUE,
                ctx.mem_step,
                ctx.comment_str("value = step")
            );
            *code += &format!(
                "\tsub {}, {} {}\n",
                REG_VALUE,
                ctx.mem_chunk_start_step,
                ctx.comment_str("value = step_inc")
            );
            *code += &format!(
                "\tmov [{}], {} {}\n",
                REG_ADDRESS,
                REG_VALUE,
                ctx.comment_str("chunk.steps.step = value = step_inc")
            );

            // Write mem_reads_size
            *code += &format!(
                "\tadd {}, 8 {}\n",
                REG_ADDRESS,
                ctx.comment_str("address += 8 = mem_reads_size")
            ); // mem_reads_size

            *code += &format!(
                "\tmov [{}], {} {}\n",
                REG_ADDRESS,
                REG_MEM_READS_SIZE,
                ctx.comment_str("mem_reads_size = size")
            );

            // Get value = mem_reads_size*8, i.e. memory size till next chunk
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_VALUE,
                REG_MEM_READS_SIZE,
                ctx.comment_str("value = mem_reads_size")
            );
            *code += &format!("\tsal {}, 3 {}\n", REG_VALUE, ctx.comment_str("value <<= 3"));

            // Update chunk address
            *code += &format!(
                "\tadd {}, 8 {}\n",
                REG_ADDRESS,
                ctx.comment_str("address += 8 = new_chunk_address")
            );
            *code += &format!(
                "\tadd {}, {} {}\n",
                REG_ADDRESS,
                REG_VALUE,
                ctx.comment_str("address += value = mem_reads_size*8")
            ); // new chunk
            *code += &format!(
                "\tmov {}, {} {}\n",
                ctx.mem_chunk_address,
                REG_ADDRESS,
                ctx.comment_str("chunk_address = new_chunk_address")
            );
        }

        if ctx.main_trace() || ctx.mem_op() {
            // Store chunk address in reg address
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_ADDRESS,
                ctx.mem_chunk_address,
                ctx.comment_str("address = chunk_address")
            );

            // Write chunk.end
            if ctx.mem_op() {
                *code += &format!(
                    "\tmov {}, {} {}\n",
                    REG_VALUE,
                    ctx.mem_end,
                    ctx.comment_str("value = end")
                );
                *code += &format!(
                    "\tmov [{}], {} {}\n",
                    REG_ADDRESS,
                    REG_VALUE,
                    ctx.comment_str("chunk.end = value = end")
                );
                *code += &format!("\tadd {}, 8 {}\n", REG_ADDRESS, ctx.comment_str("address += 8"));
            }

            // Write chunk.mem_reads_size
            *code += &format!(
                "\tmov [{}], {} {}\n",
                REG_ADDRESS,
                REG_MEM_READS_SIZE,
                ctx.comment_str("mem_reads_size = size")
            );
            *code += &format!(
                "\tadd {}, 8 {}\n",
                REG_ADDRESS,
                ctx.comment_str("address += 8 = new_chunk_address")
            );

            // Increase chunk address
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_VALUE,
                REG_MEM_READS_SIZE,
                ctx.comment_str("value = mem_reads_size")
            );
            *code += &format!("\tsal {}, 3 {}\n", REG_VALUE, ctx.comment_str("value <<= 3"));
            *code += &format!(
                "\tadd {}, {} {}\n",
                REG_ADDRESS,
                REG_VALUE,
                ctx.comment_str("address += value = mem_reads_size*8")
            );
            *code += &format!(
                "\tmov {}, {} {}\n",
                ctx.mem_chunk_address,
                REG_ADDRESS,
                ctx.comment_str("chunk_address = new_chunk_address")
            );
        }

        if ctx.minimal_trace() || ctx.main_trace() || ctx.zip() || ctx.mem_op() || ctx.mem_reads() {
            *code += &ctx.full_line_comment("Realloc trace if threshold is passed".to_string());
            *code += &format!(
                "\tmov {}, qword {}[trace_address_threshold] {}\n",
                REG_VALUE,
                ctx.ptr,
                ctx.comment_str("value = trace_address_threshold")
            );
            *code += &format!(
                "\tcmp {}, {} {}\n",
                REG_ADDRESS,
                REG_VALUE,
                ctx.comment_str("chunk_address ? trace_address_threshold")
            );
            *code += &format!("\tjb chunk_{id}_address_below_threshold\n");
            Self::push_internal_registers(ctx, code, true);
            //Self::assert_rsp_is_aligned(ctx, code);
            *code += "\tcall _realloc_trace\n";
            if ctx.call_chunk_done {
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _chunk_done\n";
            }
            //Self::assert_rsp_is_aligned(ctx, code);
            Self::pop_internal_registers(ctx, code, true);
            *code += &format!("\tjmp chunk_{id}_address_done\n");
            *code += &format!("chunk_{id}_address_below_threshold:\n");
            if ctx.call_chunk_done {
                Self::push_internal_registers(ctx, code, true);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _chunk_done\n";
                //Self::assert_rsp_is_aligned(ctx, code);
                Self::pop_internal_registers(ctx, code, true);
            }
            *code += &format!("chunk_{id}_address_done:\n");
        } else if ctx.call_chunk_done {
            // Call the chunk_done function
            Self::push_internal_registers(ctx, code, true);
            //Self::assert_rsp_is_aligned(ctx, code);
            *code += "\tcall _chunk_done\n";
            //Self::assert_rsp_is_aligned(ctx, code);
            Self::pop_internal_registers(ctx, code, true);
        }
        if ctx.zip() {
            *code += &format!("chunk_end_{id}_done:\n");
        }
    }
}
