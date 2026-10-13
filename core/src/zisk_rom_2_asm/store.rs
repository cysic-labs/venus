//! Store of the register c of an instruction: to a register, to memory, or through an
//! indirection, including the trace of the memory accesses

use super::{
    guest_memory::GuestAccess,
    registers::{
        REG_ACTIVE_CHUNK, REG_ADDRESS, REG_C, REG_CHUNK_PLAYER_ADDRESS, REG_C_B, REG_C_H, REG_C_W,
        REG_FLAG, REG_MEM_READS_ADDRESS, REG_MEM_READS_SIZE, REG_VALUE,
    },
};
use crate::{ZiskAsmContext, ZiskInst, ZiskRom2Asm, STORE_IND, STORE_MEM, STORE_NONE, STORE_REG};

impl ZiskRom2Asm {
    /// Stores register c based on instruction store
    pub(super) fn store_c_to_asm(
        ctx: &mut ZiskAsmContext,
        instruction: &ZiskInst,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        match instruction.store {
            STORE_NONE => {
                *code += &ctx.full_line_comment("STORE_NONE".to_string());

                if ctx.main_trace() {
                    Self::clear_reg_step_ranges(ctx, code, 2);
                }
            }
            STORE_REG => {
                assert!(ctx.c.is_saved);
                assert!(instruction.store_offset >= 0);
                assert!(instruction.store_offset <= 34);

                // Copy previous reg value to main trace
                if ctx.main_trace() {
                    *code += &ctx.full_line_comment("Main[4]=prev_reg".to_string());
                    Self::read_riscv_reg(
                        ctx,
                        code,
                        instruction.store_offset as u64,
                        REG_VALUE,
                        "value",
                    );

                    *code += &format!(
                        "\tmov [{} + {}*8 + 4*8], {} {}\n",
                        REG_MEM_READS_ADDRESS,
                        REG_MEM_READS_SIZE,
                        REG_VALUE,
                        ctx.comment_str("main[@+size*8+4*8] = prev_reg")
                    );
                }

                *code +=
                    &ctx.full_line_comment(format!("STORE_REG reg={}", instruction.store_offset));

                // Store in mem[address]
                if instruction.store_pc {
                    let value = (ctx.pc as i64 + instruction.jmp_offset2) as u64;
                    Self::write_riscv_reg_constant(
                        ctx,
                        code,
                        instruction.store_offset as u64,
                        value,
                        "pc + jmp_offset2",
                    );
                } else {
                    Self::write_riscv_reg(ctx, code, instruction.store_offset as u64, REG_C, "c");
                }

                if ctx.main_trace() {
                    Self::trace_reg_access(ctx, code, instruction.store_offset as u64, 2);
                }
            }
            STORE_MEM => Self::store_c_mem_to_asm(ctx, instruction, code, unusual_code),
            STORE_IND => Self::store_c_ind_to_asm(ctx, instruction, code, unusual_code),
            _ => panic!(
                "ZiskRom2Asm::save_to_asm() Invalid store={} pc={}",
                instruction.store, ctx.pc
            ),
        }
    }

    /// Stores register c in memory, store=STORE_MEM
    fn store_c_mem_to_asm(
        ctx: &mut ZiskAsmContext,
        instruction: &ZiskInst,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        assert!(ctx.c.is_saved);
        *code += &ctx.full_line_comment("STORE_MEM".to_string());

        // Calculate memory address and store it in REG_ADDRESS
        if !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov {}, 0x{:x} {}\n",
                REG_ADDRESS,
                instruction.store_offset,
                ctx.comment_str("address = i.store_offset")
            );
            if instruction.store_use_sp {
                *code += &format!(
                    "\tadd {}, {} {}\n",
                    REG_ADDRESS,
                    ctx.mem_sp,
                    ctx.comment_str("address += sp")
                );
                ctx.address_is_constant = false;
            } else {
                ctx.address_is_constant = true;
                ctx.address_constant_value = instruction.store_offset as u64;
            }
        }

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            let constant_address = ctx.address_is_constant.then_some(ctx.address_constant_value);
            Self::guest_range_check(
                ctx,
                code,
                unusual_code,
                REG_ADDRESS,
                constant_address,
                8,
                GuestAccess::Write,
            );
        }

        // Generate mem reads
        if ctx.minimal_trace() || ctx.zip() {
            if !instruction.store_use_sp {
                if (instruction.store_offset & 0x7) != 0 {
                    // If zip, check if chunk is active
                    if ctx.zip() {
                        *code += &format!(
                            "\ttest {}, 1 {}\n",
                            REG_ACTIVE_CHUNK,
                            ctx.comment_str("active_chunk == 1 ?")
                        );
                        *code += &format!("\tjnz pc_{:x}_c_active_chunk\n", ctx.pc);
                        *code += &format!("\tjmp pc_{:x}_c_address_done\n", ctx.pc);
                        *code += &format!("pc_{:x}_c_active_chunk:\n", ctx.pc);
                    }
                    Self::c_store_mem_not_aligned(ctx, code);
                }
            } else {
                // If zip, check if chunk is active
                if ctx.zip() {
                    *code += &format!(
                        "\ttest {}, 1 {}\n",
                        REG_ACTIVE_CHUNK,
                        ctx.comment_str("active_chunk == 1 ?")
                    );
                    *code += &format!("\tjnz pc_{:x}_c_active_chunk\n", ctx.pc);
                    *code += &format!("\tjmp pc_{:x}_c_address_done\n", ctx.pc);
                    *code += &format!("pc_{:x}_c_active_chunk:\n", ctx.pc);
                }
                *code +=
                    &format!("\ttest {}, 0x7 {}\n", REG_ADDRESS, ctx.comment_str("address &= 7"));
                *code += &format!("\tjnz pc_{:x}_c_address_not_aligned\n", ctx.pc);
                *unusual_code += &format!("pc_{:x}_c_address_not_aligned:\n", ctx.pc);
                Self::c_store_mem_not_aligned(ctx, unusual_code);
                *unusual_code += &format!("\tjmp pc_{:x}_c_address_done\n", ctx.pc);
            }
            *code += &format!("pc_{:x}_c_address_done:\n", ctx.pc);
        }

        // Consume mem reads
        if ctx.chunk_player_mt_collect_mem() {
            if !instruction.store_use_sp {
                if (instruction.store_offset & 0x7) != 0 {
                    // Increment chunk player address
                    *code += &format!(
                        "\tadd {}, 16 {}\n",
                        REG_CHUNK_PLAYER_ADDRESS,
                        ctx.comment_str("chunk_address += 16")
                    );
                }
            } else {
                *code +=
                    &format!("\ttest {}, 0x7 {}\n", REG_ADDRESS, ctx.comment_str("address &= 7"));
                *code += &format!("\tjnz pc_{:x}_c_address_not_aligned\n", ctx.pc);
                *unusual_code += &format!("pc_{:x}_c_address_not_aligned:\n", ctx.pc);
                // Increment chunk player address
                *unusual_code += &format!(
                    "\tadd {}, 16 {}\n",
                    REG_CHUNK_PLAYER_ADDRESS,
                    ctx.comment_str("chunk_address += 16")
                );
                *unusual_code += &format!("\tjmp pc_{:x}_c_address_done\n", ctx.pc);
            }
            *code += &format!("pc_{:x}_c_address_done:\n", ctx.pc);
        }

        // Store mem[address] = value
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            if instruction.store_pc {
                *code += &format!(
                    "\tmov {}, 0x{:x} {}\n",
                    REG_VALUE,
                    (ctx.pc as i64 + instruction.jmp_offset2) as u64,
                    ctx.comment_str("value = pc + jmp_offset2")
                );
                *code += &format!(
                    "\tmov [{}], {} {}\n",
                    REG_ADDRESS,
                    REG_VALUE,
                    ctx.comment_str("mem[address] = value")
                );
            } else {
                *code += &format!(
                    "\tmov [{}], {} {}\n",
                    REG_ADDRESS,
                    REG_C,
                    ctx.comment_str("mem[address] = c")
                );
            }
        }

        if ctx.main_trace() {
            Self::clear_reg_step_ranges(ctx, code, 2);
        }

        if ctx.mem_op() {
            Self::c_store_mem_mem_op(ctx, code);
        }
    }

    /// Stores register c in memory through an indirection, store=STORE_IND
    fn store_c_ind_to_asm(
        ctx: &mut ZiskAsmContext,
        instruction: &ZiskInst,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        assert!(ctx.c.is_saved);
        *code += &ctx.full_line_comment(format!("STORE_IND width={}", instruction.ind_width));

        // Calculate memory address and store it in REG_ADDRESS
        if !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_ADDRESS,
                ctx.a.string_value,
                ctx.comment_str("address = a")
            );
            if instruction.store_offset != 0 {
                *code += &format!(
                    "\tadd {}, 0x{:x} {}\n",
                    REG_ADDRESS,
                    instruction.store_offset as u64,
                    ctx.comment_str("address += i.store_offset")
                );
            }
            if instruction.store_use_sp {
                *code += &format!(
                    "\tadd {}, {} {}\n",
                    REG_ADDRESS,
                    ctx.mem_sp,
                    ctx.comment_str("address += sp")
                );
            }
        }

        let address_is_constant = ctx.a.is_constant && !instruction.store_use_sp;
        let address_constant_value = if address_is_constant {
            (ctx.a.constant_value as i64 + instruction.store_offset) as u64
        } else {
            0
        };
        ctx.address_is_constant = address_is_constant;
        ctx.address_constant_value = address_constant_value;
        let address_is_aligned = address_is_constant && ((address_constant_value & 0x7) == 0);

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            Self::guest_range_check(
                ctx,
                code,
                unusual_code,
                REG_ADDRESS,
                address_is_constant.then_some(address_constant_value),
                instruction.ind_width,
                GuestAccess::Write,
            );
        }

        Self::c_store_ind_mem_reads(
            ctx,
            instruction,
            address_is_constant,
            address_is_aligned,
            code,
            unusual_code,
        );

        Self::chunk_player_c_store_ind(
            ctx,
            instruction,
            address_is_constant,
            address_is_aligned,
            code,
            unusual_code,
        );

        Self::store_c_ind_write(ctx, instruction, code);

        if ctx.main_trace() {
            Self::clear_reg_step_ranges(ctx, code, 2);
        }

        if ctx.mem_op() {
            Self::c_store_ind_mem_op(ctx, code, instruction.ind_width);
        }
    }

    /// Stores mem[address] = value, of width ind_width, at the address held in REG_ADDRESS
    fn store_c_ind_write(ctx: &mut ZiskAsmContext, instruction: &ZiskInst, code: &mut String) {
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            match instruction.ind_width {
                8 => {
                    if instruction.store_pc {
                        *code += &format!(
                            "\tmov qword {}[{}], {} {}\n",
                            ctx.ptr,
                            REG_ADDRESS,
                            (ctx.pc as i64 + instruction.jmp_offset2) as u64,
                            ctx.comment_str("width=8: mem[address] = pc + jmp_offset2")
                        );
                    } else {
                        *code += &format!(
                            "\tmov [{}], {} {}\n",
                            REG_ADDRESS,
                            REG_C,
                            ctx.comment_str("width=8: mem[address] = c")
                        );
                    }
                }
                4 => {
                    if instruction.store_pc {
                        *code += &format!(
                            "\tmov dword {}[{}], {} {}\n",
                            ctx.ptr,
                            REG_ADDRESS,
                            (ctx.pc as i64 + instruction.jmp_offset2) as u64,
                            ctx.comment_str("width=4: mem[address] = pc + jmp_offset2")
                        );
                    } else {
                        *code += &format!(
                            "\tmov [{}], {} {}\n",
                            REG_ADDRESS,
                            REG_C_W,
                            ctx.comment_str("width=4: mem[address] = c")
                        );
                    }
                }
                2 => {
                    if instruction.store_pc {
                        *code += &format!(
                            "\tmov word {}[{}], {} {}\n",
                            ctx.ptr,
                            REG_ADDRESS,
                            (ctx.pc as i64 + instruction.jmp_offset2) as u64,
                            ctx.comment_str("width=2: mem[address] = pc + jmp_offset2")
                        );
                    } else {
                        *code += &format!(
                            "\tmov [{}], {} {}\n",
                            REG_ADDRESS,
                            REG_C_H,
                            ctx.comment_str("width=2: mem[address] = c")
                        );
                    }
                }
                1 => {
                    if instruction.store_pc {
                        *code += &format!(
                            "\tmov word {}[{}], {} {}\n",
                            ctx.ptr,
                            REG_ADDRESS,
                            (ctx.pc as i64 + instruction.jmp_offset2) as u64,
                            ctx.comment_str("width=1: mem[address] = pc + jmp_offset2")
                        );
                    } else {
                        *code += &format!(
                            "\tmov [{}], {} {}\n",
                            REG_ADDRESS,
                            REG_C_B,
                            ctx.comment_str("width=1: mem[address] = c")
                        );
                    }
                    if ctx.log_output {
                        *code += &format!(
                            "\tmov {}, 0xa0000200 {}\n",
                            REG_FLAG,
                            ctx.comment_str("width=1: aux = UART")
                        );
                        *code += &format!(
                            "\tcmp {}, {} {}\n",
                            REG_ADDRESS,
                            REG_FLAG,
                            ctx.comment_str("width=1: if address = USART then print char")
                        );
                        *code += &format!(
                            "\tjne pc_{:x}_store_c_not_uart {}\n",
                            ctx.pc,
                            ctx.comment_str("width=1: continue")
                        );
                        if instruction.store_pc {
                            *code += &format!(
                                "\tmov dil, 0x{:x} {}\n",
                                (ctx.pc as i64 + instruction.jmp_offset2) as u64 as u8,
                                ctx.comment_str("width=1: rdi = value")
                            );
                        } else {
                            *code += &format!(
                                "\tmov dil, {} {}\n",
                                REG_C_B,
                                ctx.comment_str("width=1: rdi = c")
                            );
                        }
                        Self::push_internal_registers(ctx, code, false);
                        //Self::assert_rsp_is_aligned(ctx, code);
                        *code += "\tcall _print_char\n";
                        Self::pop_internal_registers(ctx, code, false);
                        //Self::assert_rsp_is_aligned(ctx, code);
                        *code += &format!("pc_{:x}_store_c_not_uart:\n", ctx.pc);
                    }
                }
                _ => panic!(
                    "ZiskRom2Asm::save_to_asm() Invalid ind_width={} pc={}",
                    instruction.ind_width, ctx.pc
                ),
            }
        }
    }
}
