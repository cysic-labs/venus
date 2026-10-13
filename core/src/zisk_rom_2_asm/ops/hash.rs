//! Hash precompiles: keccak, sha256, blake2 and poseidon2

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
    pub(super) fn keccak_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        // Use the memory address as the first and unique parameter
        *code += &ctx.full_line_comment("Keccak: rdi = A0".to_string());

        // Generate mem reads
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Use the memory address as the first and unique parameter
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
                25 * 8,
                GuestAccess::Write,
            );

            // Copy read data into mem_reads_address and advance it
            if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
                // If zip, check if chunk is active
                if ctx.zip() {
                    *code += &format!(
                        "\ttest {}, 1 {}\n",
                        REG_ACTIVE_CHUNK,
                        ctx.comment_str("active_chunk == 1 ?")
                    );
                    *code += &format!("\tjnz pc_{:x}_keccak_active_chunk\n", ctx.pc);
                    *code += &format!("\tjmp pc_{:x}_keccak_active_chunk_done\n", ctx.pc);
                    *code += &format!("pc_{:x}_keccak_active_chunk:\n", ctx.pc);
                }
                *code += &format!("\tmov {REG_ADDRESS}, rdi\n");
                for k in 0..25 {
                    *code += &format!(
                        "\tmov {}, [{} + {}] {}\n",
                        REG_VALUE,
                        REG_ADDRESS,
                        k * 8,
                        ctx.comment(format!("value = mem[keccak_address[{k}]]"))
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

                // Increment chunk.steps.mem_reads_size in 25 units
                *code += &format!(
                    "\tadd {}, 25 {}\n",
                    REG_MEM_READS_SIZE,
                    ctx.comment_str("mem_reads_size += 25")
                );

                if ctx.zip() {
                    *code += &format!("pc_{:x}_keccak_active_chunk_done:\n", ctx.pc);
                }
            }

            // Trace 25 memory read operations
            if ctx.mem_op() {
                *code += &format!("\tmov {REG_ADDRESS}, rdi\n");
                Self::mem_op_array(ctx, code, REG_ADDRESS, false, 25);
                Self::mem_op_array(ctx, code, REG_ADDRESS, true, 25);
            }

            // Get result from precompile results data
            if ctx.precompile_results_keccak() {
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 25);
            } else {
                // Call the keccak function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_keccak\n";
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
                "\tadd {}, 25*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 25*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("Keccak: c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn sha256_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        // Use the memory address as the first and unique parameter
        *code += &ctx.full_line_comment("SHA256: rdi = b".to_string());

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Use the memory address as the first and unique parameter
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::precompiled_check_operands(ctx, code, unusual_code, 2, &[4, 8], 0, 0, 4);

            // Save data into mem_reads
            if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
                // If zip, check if chunk is active
                if ctx.zip() {
                    *code += &format!(
                        "\ttest {}, 1 {}\n",
                        REG_ACTIVE_CHUNK,
                        ctx.comment_str("active_chunk == 1 ?")
                    );
                    *code += &format!("\tjnz pc_{:x}_sha256_active_chunk\n", ctx.pc);
                    *code += &format!("\tjmp pc_{:x}_sha256_active_chunk_done\n", ctx.pc);
                    *code += &format!("pc_{:x}_sha256_active_chunk:\n", ctx.pc);
                }
                Self::precompiled_save_mem_reads(ctx, code, 2, &[4, 8]);
                if ctx.zip() {
                    *code += &format!("pc_{:x}_sha256_active_chunk_done:\n", ctx.pc);
                }
            }

            // Save memory operations into mem_reads
            if ctx.mem_op() {
                Self::mem_op_precompiled_read_and_write(ctx, code, 2, &[4, 8], 0, 0, 4);
            }

            // Get result from precompile results data
            if ctx.precompile_results_sha256() {
                *code += "\tmov rdi, [rdi]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 4);
            } else {
                // Call the SHA256 function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_sha256\n";
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
                "\tadd {}, 14*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 12*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("SHA256: c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn blake2_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        // Use the memory address as the first and unique parameter
        *code += &ctx.full_line_comment("Blake2: rdi = b".to_string());

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Use the memory address as the first and unique parameter
            *code += &format!(
                "\tmov rdi, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("rdi = b = address")
            );
            Self::precompiled_check_operands(ctx, code, unusual_code, 3, &[0, 16, 16], 1, 1, 16);

            // Save data into mem_reads
            if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
                // If zip, check if chunk is active
                if ctx.zip() {
                    *code += &format!(
                        "\ttest {}, 1 {}\n",
                        REG_ACTIVE_CHUNK,
                        ctx.comment_str("active_chunk == 1 ?")
                    );
                    *code += &format!("\tjnz pc_{:x}_blake2_active_chunk\n", ctx.pc);
                    *code += &format!("\tjmp pc_{:x}_blake2_active_chunk_done\n", ctx.pc);
                    *code += &format!("pc_{:x}_blake2_active_chunk:\n", ctx.pc);
                }
                Self::precompiled_save_mem_reads(ctx, code, 3, &[0, 16, 16]);
                if ctx.zip() {
                    *code += &format!("pc_{:x}_blake2_active_chunk_done:\n", ctx.pc);
                }
            }

            // Save memory operations into mem_reads
            if ctx.mem_op() {
                Self::mem_op_precompiled_read_and_write(ctx, code, 3, &[0, 16, 16], 1, 1, 16);
            }

            // Get result from precompile results data
            if ctx.precompile_results_blake2() {
                *code += "\tmov rdi, [rdi+8]\n";
                Self::precompile_results_array(ctx, code, unusual_code, "rdi", 16);
            } else {
                // Call the Blake2 function
                Self::push_internal_registers(ctx, code, false);
                //Self::assert_rsp_is_aligned(ctx, code);
                *code += "\tcall _opcode_blake2\n";
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
                "\tadd {}, 35*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 35*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("Blake2: c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn poseidon2_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        // Use the memory address as the first and unique parameter
        *code += &ctx.full_line_comment("Poseidon2: rdi = A0".to_string());

        // Generate mem reads
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Use the memory address as the first and unique parameter
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
                16 * 8,
                GuestAccess::Write,
            );

            // Copy read data into mem_reads_address and advance it
            if ctx.minimal_trace() || ctx.zip() || ctx.mem_reads() {
                // If zip, check if chunk is active
                if ctx.zip() {
                    *code += &format!(
                        "\ttest {}, 1 {}\n",
                        REG_ACTIVE_CHUNK,
                        ctx.comment_str("active_chunk == 1 ?")
                    );
                    *code += &format!("\tjnz pc_{:x}_poseidon2_active_chunk\n", ctx.pc);
                    *code += &format!("\tjmp pc_{:x}_poseidon2_active_chunk_done\n", ctx.pc);
                    *code += &format!("pc_{:x}_poseidon2_active_chunk:\n", ctx.pc);
                }
                *code += &format!("\tmov {REG_ADDRESS}, rdi\n");
                for k in 0..16 {
                    *code += &format!(
                        "\tmov {}, [{} + {}] {}\n",
                        REG_VALUE,
                        REG_ADDRESS,
                        k * 8,
                        ctx.comment(format!("value = mem[poseidon2_address[{k}]]"))
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

                // Increment chunk.steps.mem_reads_size in 16 units
                *code += &format!(
                    "\tadd {}, 16 {}\n",
                    REG_MEM_READS_SIZE,
                    ctx.comment_str("mem_reads_size += 16")
                );

                if ctx.zip() {
                    *code += &format!("pc_{:x}_poseidon2_active_chunk_done:\n", ctx.pc);
                }
            }

            // Trace 16 memory read operations
            if ctx.mem_op() {
                *code += &format!("\tmov {REG_ADDRESS}, rdi\n");
                Self::mem_op_array(ctx, code, REG_ADDRESS, false, 16);
                Self::mem_op_array(ctx, code, REG_ADDRESS, true, 16);
            }

            // Call the poseidon2 function
            Self::push_internal_registers(ctx, code, false);
            //Self::assert_rsp_is_aligned(ctx, code);
            *code += "\tcall _opcode_poseidon2\n";
            Self::pop_internal_registers(ctx, code, false);
            //Self::assert_rsp_is_aligned(ctx, code);
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
                "\tadd {}, 16*8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 16*8")
            );
        }

        // Set result
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("Poseidon2: c = 0"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }
}
