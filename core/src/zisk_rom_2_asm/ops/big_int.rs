//! Big integer precompiles: 256-bit and 384-bit modular arithmetic and 256-bit addition

use crate::{
    zisk_rom_2_asm::registers::{
        REG_ACTIVE_CHUNK, REG_C, REG_CHUNK_PLAYER_ADDRESS, REG_FLAG, REG_MEM_READS_ADDRESS,
        REG_MEM_READS_SIZE,
    },
    ZiskAsmContext, ZiskRom2Asm,
};

impl ZiskRom2Asm {
    pub(super) fn arith256_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Arith256".to_string());

        // Use the memory address as the first and unique parameter
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::precompiled_check_operands(ctx, code, unusual_code, 5, &[4, 4, 4], 3, 4, 4);
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
                *code += &format!("\tjnz pc_{:x}_arith256_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_arith256_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_arith256_active_chunk:\n", ctx.pc);
            }
            Self::precompiled_save_mem_reads(ctx, code, 5, &[4, 4, 4]);
            if ctx.zip() {
                *code += &format!("pc_{:x}_arith256_active_chunk_done:\n", ctx.pc);
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
                "\tadd {}, 17*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 17*8")
            );
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_precompiled_read_and_write(ctx, code, 5, &[4, 4, 4], 3, 4, 4);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_arith256() {
                *code += &format!("\tmov {REG_FLAG}, [rdi+3*8]\n");
                Self::precompile_results_array(ctx, code, unusual_code, REG_FLAG, 4);
                *code += &format!("\tmov {REG_FLAG}, [rdi+4*8]\n");
                Self::precompile_results_array(ctx, code, unusual_code, REG_FLAG, 4);
                *code += &format!("\tmov {REG_FLAG}, 0\n"); // Is this needed?
            } else {
                // Call the arith256 function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_arith256\n";
                Self::pop_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
            }
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn arith256_mod_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Arith256Mod".to_string());

        // Use the memory address as the first and unique parameter
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::precompiled_check_operands(ctx, code, unusual_code, 5, &[4, 4, 4, 4], 4, 4, 4);
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
                *code += &format!("\tjnz pc_{:x}_arith256mod_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_arith256mod_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_arith256mod_active_chunk:\n", ctx.pc);
            }
            Self::precompiled_save_mem_reads(ctx, code, 5, &[4, 4, 4, 4]);
            if ctx.zip() {
                *code += &format!("pc_{:x}_arith256mod_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_precompiled_read_and_write(ctx, code, 5, &[4, 4, 4, 4], 4, 4, 4);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_arith256mod() {
                *code += "\tmov rdi, [rdi + 4*8]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 4);
            } else {
                // Call the arith256_mod function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_arith256_mod\n";
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
                "\tadd {}, 21*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 21*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn arith384_mod_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Arith384Mod".to_string());

        // Use the memory address as the first and unique parameter
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::precompiled_check_operands(ctx, code, unusual_code, 5, &[6, 6, 6, 6], 4, 4, 6);
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
                *code += &format!("\tjnz pc_{:x}_arith384mod_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_arith384mod_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_arith384mod_active_chunk:\n", ctx.pc);
            }
            Self::precompiled_save_mem_reads(ctx, code, 5, &[6, 6, 6, 6]);
            if ctx.zip() {
                *code += &format!("pc_{:x}_arith384mod_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_precompiled_read_and_write(ctx, code, 5, &[6, 6, 6, 6], 4, 4, 6);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_arith384mod() {
                *code += "\tmov rdi, [rdi + 4*8]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 6);
            } else {
                // Call the arith384_mod function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_arith384_mod\n";
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
                "\tadd {}, 29*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 29*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn add256_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Add256".to_string());

        // Use the memory address as the first and unique parameter
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::precompiled_check_operands(ctx, code, unusual_code, 4, &[4, 4], 3, 3, 4);
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
                *code += &format!("\tjnz pc_{:x}_add256_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_add256_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_add256_active_chunk:\n", ctx.pc);
            }
            Self::precompiled_save_mem_reads(ctx, code, 4, &[4, 4]);
            if ctx.zip() {
                *code += &format!("pc_{:x}_add256_active_chunk_done:\n", ctx.pc);
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
                "\tadd {}, 13*8 {}\n", // 13 = @a, @b, cin, @c, a[0..4], b[0..4], cout
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 13*8")
            );
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_precompiled_read_and_write(ctx, code, 4, &[4, 4], 3, 3, 4);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_add256() {
                *code += "\tmov rdi, [rdi+3*8]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 4);
                Self::precompile_results_register(ctx, code, unusual_code, REG_C);
            } else {
                // Call the add256 function
                Self::push_internal_registers_except_c_and_flag(ctx, code, false);
                // Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_add256\n";
                *code += &format!("\tmov {}, rax {}\n", REG_C, ctx.comment_str("c = rax"));
                Self::pop_internal_registers_except_c_and_flag(ctx, code, false);
            }

            // this precompiles store the result in minimal trace
            if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
                Self::precompiled_save_result(ctx, code);
            }
            // Self::assert_rsp_is_aligned(ctx, code);
        } else {
            // Set REG_C, REG_FLAGS from last value of mt
            Self::mem_op_precompiled_restore_c_and_flags(ctx, code);
        }

        // Set result
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }
}
