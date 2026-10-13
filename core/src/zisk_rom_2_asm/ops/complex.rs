//! Quadratic extension field (complex) precompiles of bn254 and bls12-381: addition,
//! subtraction and multiplication

use crate::{
    zisk_rom_2_asm::registers::{
        REG_ACTIVE_CHUNK, REG_C, REG_CHUNK_PLAYER_ADDRESS, REG_MEM_READS_ADDRESS,
        REG_MEM_READS_SIZE,
    },
    ZiskAsmContext, ZiskRom2Asm,
};

impl ZiskRom2Asm {
    pub(super) fn bn254_complex_add_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Bn254ComplexAdd".to_string());

        // Use the memory address as the first and unique parameter
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::precompiled_check_operands(ctx, code, unusual_code, 2, &[8, 8], 0, 0, 8);
        }

        // Save data into mem_reads
        if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
            // If zip, check if chunk is active
            if ctx.zip() {
                *code += &format!(
                    "\ttest {}, 1 {}\n",
                    REG_ACTIVE_CHUNK,
                    ctx.comment_str("active_chunk == 1 ?")
                );
                *code += &format!("\tjnz pc_{:x}_bn254complexadd_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_bn254complexadd_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_bn254complexadd_active_chunk:\n", ctx.pc);
            }
            Self::precompiled_save_mem_reads(ctx, code, 2, &[8, 8]);
            if ctx.zip() {
                *code += &format!("pc_{:x}_bn254complexadd_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_precompiled_read_and_write(ctx, code, 2, &[8, 8], 0, 0, 8);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_bn254complexadd() {
                *code += "\tmov rdi, [rdi]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 8);
            } else {
                // Call the bn254_complex_add function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_bn254_complex_add\n";
                Self::pop_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
            }
        }

        // Consume mem reads
        if ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov [{} + {}*8], {} {}\n",
                REG_MEM_READS_ADDRESS,
                REG_MEM_READS_SIZE,
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("Main[4] = precompiler data address")
            );
            *code +=
                &format!("\tinc {} {}\n", REG_MEM_READS_SIZE, ctx.comment_str("mem_reads_size++"));
        }
        if ctx.chunk_player_mt_collect_mem() || ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tadd {}, 18*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 18*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn bn254_complex_sub_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Bn254ComplexSub".to_string());

        // Use the memory address as the first and unique parameter
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::precompiled_check_operands(ctx, code, unusual_code, 2, &[8, 8], 0, 0, 8);
        }

        // Save data into mem_reads
        if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
            // If zip, check if chunk is active
            if ctx.zip() {
                *code += &format!(
                    "\ttest {}, 1 {}\n",
                    REG_ACTIVE_CHUNK,
                    ctx.comment_str("active_chunk == 1 ?")
                );
                *code += &format!("\tjnz pc_{:x}_bn254complexsub_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_bn254complexsub_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_bn254complexsub_active_chunk:\n", ctx.pc);
            }
            Self::precompiled_save_mem_reads(ctx, code, 2, &[8, 8]);
            if ctx.zip() {
                *code += &format!("pc_{:x}_bn254complexsub_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_precompiled_read_and_write(ctx, code, 2, &[8, 8], 0, 0, 8);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_bn254complexsub() {
                *code += "\tmov rdi, [rdi]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 8);
            } else {
                // Call the bn254_complex_sub function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_bn254_complex_sub\n";
                Self::pop_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
            }
        }

        // Consume mem reads
        if ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov [{} + {}*8], {} {}\n",
                REG_MEM_READS_ADDRESS,
                REG_MEM_READS_SIZE,
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("Main[4] = precompiler data address")
            );
            *code +=
                &format!("\tinc {} {}\n", REG_MEM_READS_SIZE, ctx.comment_str("mem_reads_size++"));
        }
        if ctx.chunk_player_mt_collect_mem() || ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tadd {}, 18*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 18*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn bn254_complex_mul_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Bn254ComplexMul".to_string());

        // Use the memory address as the first and unique parameter
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::precompiled_check_operands(ctx, code, unusual_code, 2, &[8, 8], 0, 0, 8);
        }

        // Save data into mem_reads
        if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
            // If zip, check if chunk is active
            if ctx.zip() {
                *code += &format!(
                    "\ttest {}, 1 {}\n",
                    REG_ACTIVE_CHUNK,
                    ctx.comment_str("active_chunk == 1 ?")
                );
                *code += &format!("\tjnz pc_{:x}_bn254complexmul_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_bn254complexmul_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_bn254complexmul_active_chunk:\n", ctx.pc);
            }
            Self::precompiled_save_mem_reads(ctx, code, 2, &[8, 8]);
            if ctx.zip() {
                *code += &format!("pc_{:x}_bn254complexmul_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_precompiled_read_and_write(ctx, code, 2, &[8, 8], 0, 0, 8);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_bn254complexmul() {
                *code += "\tmov rdi, [rdi]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 8);
            } else {
                // Call the bn254_complex_mul function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_bn254_complex_mul\n";
                Self::pop_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
            }
        }

        // Consume mem reads
        if ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov [{} + {}*8], {} {}\n",
                REG_MEM_READS_ADDRESS,
                REG_MEM_READS_SIZE,
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("Main[4] = precompiler data address")
            );
            *code +=
                &format!("\tinc {} {}\n", REG_MEM_READS_SIZE, ctx.comment_str("mem_reads_size++"));
        }
        if ctx.chunk_player_mt_collect_mem() || ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tadd {}, 18*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 18*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn bls12_381_complex_add_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Bls12_381ComplexAdd".to_string());

        // Use the memory address as the first and unique parameter
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::precompiled_check_operands(ctx, code, unusual_code, 2, &[12, 12], 0, 0, 12);
        }

        // Save data into mem_reads
        if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
            // If zip, check if chunk is active
            if ctx.zip() {
                *code += &format!(
                    "\ttest {}, 1 {}\n",
                    REG_ACTIVE_CHUNK,
                    ctx.comment_str("active_chunk == 1 ?")
                );
                *code += &format!("\tjnz pc_{:x}_bls12_381complexadd_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_bls12_381complexadd_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_bls12_381complexadd_active_chunk:\n", ctx.pc);
            }
            Self::precompiled_save_mem_reads(ctx, code, 2, &[12, 12]);
            if ctx.zip() {
                *code += &format!("pc_{:x}_bls12_381complexadd_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_precompiled_read_and_write(ctx, code, 2, &[12, 12], 0, 0, 12);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_bls12_381complexadd() {
                *code += "\tmov rdi, [rdi]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 12);
            } else {
                // Call the bls12_381_complex_add function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_bls12_381_complex_add\n";
                Self::pop_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
            }
        }

        // Consume mem reads
        if ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov [{} + {}*8], {} {}\n",
                REG_MEM_READS_ADDRESS,
                REG_MEM_READS_SIZE,
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("Main[4] = precompiler data address")
            );
            *code +=
                &format!("\tinc {} {}\n", REG_MEM_READS_SIZE, ctx.comment_str("mem_reads_size++"));
        }
        if ctx.chunk_player_mt_collect_mem() || ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tadd {}, 26*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 26*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn bls12_381_complex_sub_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Bls12_381ComplexSub".to_string());

        // Use the memory address as the first and unique parameter
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::precompiled_check_operands(ctx, code, unusual_code, 2, &[12, 12], 0, 0, 12);
        }

        // Save data into mem_reads
        if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
            // If zip, check if chunk is active
            if ctx.zip() {
                *code += &format!(
                    "\ttest {}, 1 {}\n",
                    REG_ACTIVE_CHUNK,
                    ctx.comment_str("active_chunk == 1 ?")
                );
                *code += &format!("\tjnz pc_{:x}_bls12_381complexsub_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_bls12_381complexsub_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_bls12_381complexsub_active_chunk:\n", ctx.pc);
            }
            Self::precompiled_save_mem_reads(ctx, code, 2, &[12, 12]);
            if ctx.zip() {
                *code += &format!("pc_{:x}_bls12_381complexsub_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_precompiled_read_and_write(ctx, code, 2, &[12, 12], 0, 0, 12);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_bls12_381complexsub() {
                *code += "\tmov rdi, [rdi]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 12);
            } else {
                // Call the bls12_381_complex_sub function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_bls12_381_complex_sub\n";
                Self::pop_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
            }
        }

        // Consume mem reads
        if ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov [{} + {}*8], {} {}\n",
                REG_MEM_READS_ADDRESS,
                REG_MEM_READS_SIZE,
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("Main[4] = precompiler data address")
            );
            *code +=
                &format!("\tinc {} {}\n", REG_MEM_READS_SIZE, ctx.comment_str("mem_reads_size++"));
        }
        if ctx.chunk_player_mt_collect_mem() || ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tadd {}, 26*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 26*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn bls12_381_complex_mul_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Bls12_381ComplexMul".to_string());

        // Use the memory address as the first and unique parameter
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::precompiled_check_operands(ctx, code, unusual_code, 2, &[12, 12], 0, 0, 12);
        }

        // Save data into mem_reads
        if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
            // If zip, check if chunk is active
            if ctx.zip() {
                *code += &format!(
                    "\ttest {}, 1 {}\n",
                    REG_ACTIVE_CHUNK,
                    ctx.comment_str("active_chunk == 1 ?")
                );
                *code += &format!("\tjnz pc_{:x}_bls12_381complexmul_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_bls12_381complexmul_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_bls12_381complexmul_active_chunk:\n", ctx.pc);
            }
            Self::precompiled_save_mem_reads(ctx, code, 2, &[12, 12]);
            if ctx.zip() {
                *code += &format!("pc_{:x}_bls12_381complexmul_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_precompiled_read_and_write(ctx, code, 2, &[12, 12], 0, 0, 12);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_bls12_381complexmul() {
                *code += "\tmov rdi, [rdi]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 12);
            } else {
                // Call the bls12_381_complex_mul function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_bls12_381_complex_mul\n";
                Self::pop_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
            }
        }

        // Consume mem reads
        if ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov [{} + {}*8], {} {}\n",
                REG_MEM_READS_ADDRESS,
                REG_MEM_READS_SIZE,
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("Main[4] = precompiler data address")
            );
            *code +=
                &format!("\tinc {} {}\n", REG_MEM_READS_SIZE, ctx.comment_str("mem_reads_size++"));
        }
        if ctx.chunk_player_mt_collect_mem() || ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tadd {}, 26*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 26*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }
}
