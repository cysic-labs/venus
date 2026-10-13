//! Elliptic curve precompiles: point addition and doubling of secp256k1, secp256r1, bn254 and
//! bls12-381

use crate::{
    zisk_rom_2_asm::{
        guest_memory::GuestAccess,
        registers::{
            REG_ACTIVE_CHUNK, REG_ADDRESS, REG_C, REG_CHUNK_PLAYER_ADDRESS, REG_MEM_READS_ADDRESS,
            REG_MEM_READS_SIZE, REG_VALUE,
        },
    },
    ZiskAsmContext, ZiskRom2Asm,
};

impl ZiskRom2Asm {
    pub(super) fn secp256k1_add_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Secp256k1Add".to_string());

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
                *code += &format!("\tjnz pc_{:x}_secp256k1add_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_secp256k1add_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_secp256k1add_active_chunk:\n", ctx.pc);
            }
            Self::precompiled_save_mem_reads(ctx, code, 2, &[8, 8]);
            if ctx.zip() {
                *code += &format!("pc_{:x}_secp256k1add_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_precompiled_read_and_write(ctx, code, 2, &[8, 8], 0, 0, 8);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_secp256k1add() {
                *code += "\tmov rdi, [rdi]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 8);
            } else {
                // Call the secp256k1_add function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_secp256k1_add\n";
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

    pub(super) fn secp256k1_dbl_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Secp256k1Dbl".to_string());

        // Use the memory address as the first and unique parameter
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::guest_range_check(
                ctx,
                code,
                unusual_code,
                "rdi",
                None,
                8 * 8,
                GuestAccess::Write,
            );
        }

        // Copy read data into mem_reads
        if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
            // If zip, check if chunk is active
            if ctx.zip() {
                *code += &format!(
                    "\ttest {}, 1 {}\n",
                    REG_ACTIVE_CHUNK,
                    ctx.comment_str("active_chunk == 1 ?")
                );
                *code += &format!("\tjnz pc_{:x}_secp256k1dbl_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_secp256k1dbl_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_secp256k1dbl_active_chunk:\n", ctx.pc);
            }
            *code += &format!("\tmov {REG_ADDRESS}, rdi\n");
            for k in 0..8 {
                *code += &format!(
                    "\tmov {}, [{} + {}] {}\n",
                    REG_VALUE,
                    REG_ADDRESS,
                    k * 8,
                    ctx.comment(format!("value = mem[address[{k}]]"))
                );
                *code += &format!(
                    "\tmov [{} + {}*8 + {}], {} {}\n",
                    REG_MEM_READS_ADDRESS,
                    REG_MEM_READS_SIZE,
                    k * 8,
                    REG_VALUE,
                    ctx.comment(format!("mem_reads[{k}] = value"))
                );
            }

            // Increment chunk.steps.mem_reads_size in 8 units
            *code += &format!(
                "\tadd {}, 8 {}\n",
                REG_MEM_READS_SIZE,
                ctx.comment_str("mem_reads_size += 8")
            );
            if ctx.zip() {
                *code += &format!("pc_{:x}_secp256k1dbl_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_array(ctx, code, "rdi", false, 8);
            Self::mem_op_array(ctx, code, "rdi", true, 8);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_secp256k1dbl() {
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 8);
            } else {
                // Call the secp256k1_dbl function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_secp256k1_dbl\n";
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
                "\tadd {}, 8*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 8*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn secp256r1_add_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Secp256r1Add".to_string());

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
                *code += &format!("\tjnz pc_{:x}_secp256r1add_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_secp256r1add_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_secp256r1add_active_chunk:\n", ctx.pc);
            }
            Self::precompiled_save_mem_reads(ctx, code, 2, &[8, 8]);
            if ctx.zip() {
                *code += &format!("pc_{:x}_secp256r1add_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_precompiled_read_and_write(ctx, code, 2, &[8, 8], 0, 0, 8);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_secp256r1add() {
                *code += "\tmov rdi, [rdi]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 8);
            } else {
                // Call the secp256r1_add function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_secp256r1_add\n";
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

    pub(super) fn secp256r1_dbl_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Secp256r1Dbl".to_string());

        // Use the memory address as the first and unique parameter
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::guest_range_check(
                ctx,
                code,
                unusual_code,
                "rdi",
                None,
                8 * 8,
                GuestAccess::Write,
            );
        }

        // Copy read data into mem_reads
        if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
            // If zip, check if chunk is active
            if ctx.zip() {
                *code += &format!(
                    "\ttest {}, 1 {}\n",
                    REG_ACTIVE_CHUNK,
                    ctx.comment_str("active_chunk == 1 ?")
                );
                *code += &format!("\tjnz pc_{:x}_secp256r1dbl_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_secp256r1dbl_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_secp256r1dbl_active_chunk:\n", ctx.pc);
            }
            *code += &format!("\tmov {REG_ADDRESS}, rdi\n");
            for k in 0..8 {
                *code += &format!(
                    "\tmov {}, [{} + {}] {}\n",
                    REG_VALUE,
                    REG_ADDRESS,
                    k * 8,
                    ctx.comment(format!("value = mem[address[{k}]]"))
                );
                *code += &format!(
                    "\tmov [{} + {}*8 + {}], {} {}\n",
                    REG_MEM_READS_ADDRESS,
                    REG_MEM_READS_SIZE,
                    k * 8,
                    REG_VALUE,
                    ctx.comment(format!("mem_reads[{k}] = value"))
                );
            }

            // Increment chunk.steps.mem_reads_size in 8 units
            *code += &format!(
                "\tadd {}, 8 {}\n",
                REG_MEM_READS_SIZE,
                ctx.comment_str("mem_reads_size += 8")
            );
            if ctx.zip() {
                *code += &format!("pc_{:x}_secp256r1dbl_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_array(ctx, code, "rdi", false, 8);
            Self::mem_op_array(ctx, code, "rdi", true, 8);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_secp256r1dbl() {
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 8);
            } else {
                // Call the secp256r1_dbl function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_secp256r1_dbl\n";
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
                "\tadd {}, 8*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 8*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn bn254_curve_add_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Bn254CurveAdd".to_string());

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
                *code += &format!("\tjnz pc_{:x}_bn254curveadd_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_bn254curveadd_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_bn254curveadd_active_chunk:\n", ctx.pc);
            }
            Self::precompiled_save_mem_reads(ctx, code, 2, &[8, 8]);
            if ctx.zip() {
                *code += &format!("pc_{:x}_bn254curveadd_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_precompiled_read_and_write(ctx, code, 2, &[8, 8], 0, 0, 8);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_bn254curveadd() {
                *code += "\tmov rdi, [rdi]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 8);
            } else {
                // Call the bn254_curve_add function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_bn254_curve_add\n";
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

    pub(super) fn bn254_curve_dbl_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Bn254CurveDbl".to_string());

        // Use the memory address as the first and unique parameter
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::guest_range_check(
                ctx,
                code,
                unusual_code,
                "rdi",
                None,
                8 * 8,
                GuestAccess::Write,
            );
        }

        // Copy read data into mem_reads
        if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
            // If zip, check if chunk is active
            if ctx.zip() {
                *code += &format!(
                    "\ttest {}, 1 {}\n",
                    REG_ACTIVE_CHUNK,
                    ctx.comment_str("active_chunk == 1 ?")
                );
                *code += &format!("\tjnz pc_{:x}_bn254curvedbl_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_bn254curvedbl_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_bn254curvedbl_active_chunk:\n", ctx.pc);
            }
            *code += &format!("\tmov {REG_ADDRESS}, rdi\n");
            for k in 0..8 {
                *code += &format!(
                    "\tmov {}, [{} + {}] {}\n",
                    REG_VALUE,
                    REG_ADDRESS,
                    k * 8,
                    ctx.comment(format!("value = mem[address[{k}]]"))
                );
                *code += &format!(
                    "\tmov [{} + {}*8 + {}], {} {}\n",
                    REG_MEM_READS_ADDRESS,
                    REG_MEM_READS_SIZE,
                    k * 8,
                    REG_VALUE,
                    ctx.comment(format!("mem_reads[{k}] = value"))
                );
            }

            // Increment chunk.steps.mem_reads_size in 8 units
            *code += &format!(
                "\tadd {}, 8 {}\n",
                REG_MEM_READS_SIZE,
                ctx.comment_str("mem_reads_size += 8")
            );
            if ctx.zip() {
                *code += &format!("pc_{:x}_bn254curvedbl_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_array(ctx, code, "rdi", false, 8);
            Self::mem_op_array(ctx, code, "rdi", true, 8);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_bn254curvedbl() {
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 8);
            } else {
                // Call the bn254_curve_dbl function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_bn254_curve_dbl\n";
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
                "\tadd {}, 8*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 8*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn bls12_381_curve_add_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Bls12_381CurveAdd".to_string());

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
                *code += &format!("\tjnz pc_{:x}_bls12_381curveadd_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_bls12_381curveadd_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_bls12_381curveadd_active_chunk:\n", ctx.pc);
            }
            Self::precompiled_save_mem_reads(ctx, code, 2, &[12, 12]);
            if ctx.zip() {
                *code += &format!("pc_{:x}_bls12_381curveadd_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_precompiled_read_and_write(ctx, code, 2, &[12, 12], 0, 0, 12);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_bls12_381curveadd() {
                *code += "\tmov rdi, [rdi]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 12);
            } else {
                // Call the bls12_381_curve_add function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_bls12_381_curve_add\n";
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
                "\tadd {}, 22*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 22*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn bls12_381_curve_dbl_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Bls12_381CurveDbl".to_string());

        // Use the memory address as the first and unique parameter
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::guest_range_check(
                ctx,
                code,
                unusual_code,
                "rdi",
                None,
                12 * 8,
                GuestAccess::Write,
            );
        }

        // Copy read data into mem_reads
        if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
            // If zip, check if chunk is active
            if ctx.zip() {
                *code += &format!(
                    "\ttest {}, 1 {}\n",
                    REG_ACTIVE_CHUNK,
                    ctx.comment_str("active_chunk == 1 ?")
                );
                *code += &format!("\tjnz pc_{:x}_bls12_381curvedbl_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_bls12_381curvedbl_active_chunk_done\n", ctx.pc);
                *code += &format!("pc_{:x}_bls12_381curvedbl_active_chunk:\n", ctx.pc);
            }
            *code += &format!("\tmov {REG_ADDRESS}, rdi\n");
            for k in 0..12 {
                *code += &format!(
                    "\tmov {}, [{} + {}] {}\n",
                    REG_VALUE,
                    REG_ADDRESS,
                    k * 8,
                    ctx.comment(format!("value = mem[address[{k}]]"))
                );
                *code += &format!(
                    "\tmov [{} + {}*8 + {}], {} {}\n",
                    REG_MEM_READS_ADDRESS,
                    REG_MEM_READS_SIZE,
                    k * 8,
                    REG_VALUE,
                    ctx.comment(format!("mem_reads[{k}] = value"))
                );
            }

            // Increment chunk.steps.mem_reads_size in 8 units
            *code += &format!(
                "\tadd {}, 12 {}\n",
                REG_MEM_READS_SIZE,
                ctx.comment_str("mem_reads_size += 12")
            );
            if ctx.zip() {
                *code += &format!("pc_{:x}_bls12_381curvedbl_active_chunk_done:\n", ctx.pc);
            }
        }

        // Save memory operations into mem_reads
        if ctx.mem_op() {
            Self::mem_op_array(ctx, code, "rdi", false, 12);
            Self::mem_op_array(ctx, code, "rdi", true, 12);
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.precompile_results_bls12_381curvedbl() {
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 12);
            } else {
                // Call the bls12_381_curve_dbl function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_bls12_381_curve_dbl\n";
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
                "\tadd {}, 12*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 12*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }
}
