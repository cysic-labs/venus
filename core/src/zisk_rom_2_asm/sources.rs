//! Sources of the registers a and b of an instruction: registers, memory, constants, the step
//! and indirections, including the trace of their memory reads

use super::{
    guest_memory::GuestAccess,
    registers::{
        REG_A, REG_ACTIVE_CHUNK, REG_ADDRESS, REG_B, REG_B_W, REG_C, REG_CHUNK_PLAYER_ADDRESS,
        REG_C_W, REG_STEP,
    },
};
use crate::{
    zisk_ops::ZiskOp, ZiskAsmContext, ZiskInst, ZiskRom2Asm, FREE_INPUT_ADDR, SRC_C, SRC_IMM,
    SRC_IND, SRC_MEM, SRC_REG, SRC_STEP,
};

impl ZiskRom2Asm {
    /// Sets register b content when its source is SRC_C, before register a is set: in case a
    /// must be stored in c, it would overwrite the previous value of c
    pub(super) fn b_src_c_to_asm(
        ctx: &mut ZiskAsmContext,
        instruction: &ZiskInst,
        code: &mut String,
    ) {
        ctx.b.is_constant = false;
        ctx.b.is_saved = false;
        ctx.b.string_value = REG_B.to_string();
        if instruction.b_src == SRC_C {
            *code += &ctx.full_line_comment("b=SRC_C".to_string());
            if ctx.store_b_in_c {
                // No need to copy c to b, since we need b to be stored in c
                ctx.b.is_saved = false;
            } else {
                *code += &format!("\tmov {}, {} {}\n", REG_B, REG_C, ctx.comment_str("b = c"));
                ctx.b.is_saved = true;
            }
            if ctx.main_trace() {
                Self::clear_reg_step_ranges(ctx, code, 1);
            }
        }
    }

    /// Sets register a content based on instruction a_src
    pub(super) fn a_src_to_asm(
        ctx: &mut ZiskAsmContext,
        instruction: &ZiskInst,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        ctx.a.is_constant = false;
        ctx.a.is_saved = false;
        ctx.a.string_value = REG_A.to_string();
        match instruction.a_src {
            SRC_C => {
                *code += &ctx.full_line_comment("a=SRC_C".to_string());
                if ctx.store_a_in_c {
                    // No need to copy c to a, since we need a to be stored in c
                    ctx.a.is_saved = false;
                } else {
                    *code += &format!("\tmov {}, {} {}\n", REG_A, REG_C, ctx.comment_str("a = c"));
                    ctx.a.is_saved = true;
                }
                if ctx.main_trace() {
                    Self::clear_reg_step_ranges(ctx, code, 0);
                }
            }
            SRC_REG => {
                *code +=
                    &ctx.full_line_comment(format!("a=SRC_REG reg={}", instruction.a_offset_imm0));

                assert!(instruction.a_offset_imm0 <= 34);

                // Read from memory and store in the proper register: a or c
                let dest_reg = if ctx.store_a_in_c { REG_C } else { REG_A };
                let dest_desc = if ctx.store_a_in_c { "c" } else { "a" };
                Self::read_riscv_reg(ctx, code, instruction.a_offset_imm0, dest_reg, dest_desc);

                if ctx.main_trace() {
                    Self::trace_reg_access(ctx, code, instruction.a_offset_imm0, 0);
                }
            }
            SRC_MEM => Self::a_src_mem_to_asm(ctx, instruction, code, unusual_code),
            SRC_IMM => {
                *code += &ctx.full_line_comment("a=SRC_IMM".to_string());
                ctx.a.is_constant = true;
                ctx.a.constant_value =
                    instruction.a_offset_imm0 | (instruction.a_use_sp_imm1 << 32);
                ctx.a.string_value = format!("0x{:x}", ctx.a.constant_value);
                if ctx.store_a_in_c {
                    *code += &format!(
                        "\tmov {}, {} {}\n",
                        REG_C,
                        ctx.a.string_value,
                        ctx.comment_str("c = constant")
                    );
                    ctx.a.is_saved = false;
                } else if ctx.store_a_in_a {
                    *code += &format!(
                        "\tmov {}, {} {}\n",
                        REG_A,
                        ctx.a.string_value,
                        ctx.comment_str("a = constant")
                    );
                    ctx.a.is_saved = true;
                } else {
                    ctx.a.is_saved = false;
                }
                // DEBUG: Used only to get register traces:
                //*s += &format!("\tmov {}, {} {}\n", REG_A, ctx.a.string_value, ctx.commit_str("a = a_value"));

                if ctx.main_trace() {
                    Self::clear_reg_step_ranges(ctx, code, 0);
                }
            }
            SRC_STEP => {
                *code += &ctx.full_line_comment("a=SRC_STEP".to_string());
                let store_a_reg = if ctx.store_a_in_c { REG_C } else { REG_A };
                let store_a_reg_name = if ctx.store_a_in_c { "c" } else { "a" };
                *code += &format!(
                    "\tmov {}, {} {}\n",
                    store_a_reg,
                    ctx.mem_step,
                    ctx.comment(format!("{store_a_reg_name} = step"))
                );
                if ctx.minimal_trace()
                    || ctx.zip()
                    || ctx.chunk_player_mt_collect_mem()
                    || ctx.mem_reads()
                    || ctx.chunk_player_mem_reads_collect_main()
                {
                    *code += &format!(
                        "\tadd {}, chunk_size {}\n",
                        store_a_reg,
                        ctx.comment(format!("{store_a_reg_name} += chunk_size"))
                    );
                    *code += &format!(
                        "\tsub {}, {} {}\n",
                        store_a_reg,
                        REG_STEP,
                        ctx.comment(format!("{store_a_reg_name} -= step_count_down"))
                    );
                }
                ctx.a.is_saved = !ctx.store_a_in_c;

                if ctx.main_trace() {
                    Self::clear_reg_step_ranges(ctx, code, 0);
                }
            }
            _ => {
                panic!("ZiskRom::source_a() Invalid a_src={} pc={}", instruction.a_src, ctx.pc)
            }
        }
    }

    /// Reads register a from memory, a_src=SRC_MEM
    fn a_src_mem_to_asm(
        ctx: &mut ZiskAsmContext,
        instruction: &ZiskInst,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("a=SRC_MEM".to_string());

        // Calculate memory address
        if !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!(
                "\tmov {}, 0x{:x} {}\n",
                REG_ADDRESS,
                instruction.a_offset_imm0,
                ctx.comment_str("address = a_offset_imm0")
            );
            if instruction.a_use_sp_imm1 != 0 {
                *code += &format!(
                    "\tadd {}, {} {}\n",
                    REG_ADDRESS,
                    ctx.mem_sp,
                    ctx.comment_str("address += sp")
                );
                ctx.address_is_constant = false;
            } else {
                ctx.address_is_constant = true;
                ctx.address_constant_value = instruction.a_offset_imm0;
            }
        }

        // Read value from memory and store in the proper register: a or c
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            let constant_address = ctx.address_is_constant.then_some(ctx.address_constant_value);
            Self::guest_range_check(
                ctx,
                code,
                unusual_code,
                REG_ADDRESS,
                constant_address,
                8,
                GuestAccess::Read,
            );
            *code += &format!(
                "\tmov {}, [{}] {}\n",
                if ctx.store_a_in_c { REG_C } else { REG_A },
                REG_ADDRESS,
                ctx.comment(format!("{} = mem[address]", if ctx.store_a_in_c { "c" } else { "a" }))
            );
        }

        // Generate mem reads
        if ctx.minimal_trace() || ctx.zip() {
            // If zip, check if chunk is active
            if ctx.zip() {
                *code += &format!(
                    "\ttest {}, 1 {}\n",
                    REG_ACTIVE_CHUNK,
                    ctx.comment_str("active_chunk == 1 ?")
                );
                *code += &format!("\tjnz pc_{:x}_a_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_a_address_check_done\n", ctx.pc);
                *code += &format!("pc_{:x}_a_active_chunk:\n", ctx.pc);
            }
            // If address is constant
            if instruction.a_use_sp_imm1 == 0 {
                // If address is constant and aligned
                if (instruction.a_offset_imm0 & 0x7) == 0 {
                    Self::a_src_mem_aligned(ctx, code);
                } else {
                    Self::a_src_mem_not_aligned(ctx, code);
                }
            }
            // If address is dynamic
            else {
                // Check if address is aligned, i.e. it is a multiple of 8, or not,
                // and insert code accordingly
                *code +=
                    &format!("\ttest {}, 0x7 {}\n", REG_ADDRESS, ctx.comment_str("address &= 7"));
                *code += &format!("\tjnz pc_{:x}_a_address_not_aligned\n", ctx.pc);
                Self::a_src_mem_aligned(ctx, code);
                *unusual_code += &format!("pc_{:x}_a_address_not_aligned:\n", ctx.pc);
                Self::a_src_mem_not_aligned(ctx, unusual_code);
                *unusual_code += &format!("\tjmp pc_{:x}_a_address_check_done\n", ctx.pc);
            }
            *code += &format!("pc_{:x}_a_address_check_done:\n", ctx.pc);
        }
        if ctx.mem_reads() {
            Self::a_src_mem_aligned(ctx, code);
        }

        // Consume mem reads
        if ctx.chunk_player_mt_collect_mem() {
            let reg_to_store_value = if ctx.store_a_in_c { REG_C } else { REG_A };
            let reg_to_store_value_desc = if ctx.store_a_in_c { "c" } else { "a" };
            // If address is constant
            if instruction.a_use_sp_imm1 == 0 {
                // If address is constant and aligned
                if (instruction.a_offset_imm0 & 0x7) == 0 {
                    Self::chunk_player_mem_read_aligned(
                        ctx,
                        code,
                        reg_to_store_value,
                        reg_to_store_value_desc,
                        0,
                    );
                } else {
                    Self::chunk_player_a_src_mem_not_aligned(ctx, code);
                }
            }
            // If address is dynamic
            else {
                // Check if address is aligned, i.e. it is a multiple of 8, or not,
                // and insert code accordingly
                *code +=
                    &format!("\ttest {}, 0x7 {}\n", REG_ADDRESS, ctx.comment_str("address &= 7"));
                *code += &format!("\tjnz pc_{:x}_a_address_not_aligned\n", ctx.pc);
                Self::chunk_player_mem_read_aligned(
                    ctx,
                    code,
                    reg_to_store_value,
                    reg_to_store_value_desc,
                    0,
                );
                *unusual_code += &format!("pc_{:x}_a_address_not_aligned:\n", ctx.pc);
                Self::chunk_player_a_src_mem_not_aligned(ctx, unusual_code);
                *unusual_code += &format!("\tjmp pc_{:x}_a_address_check_done\n", ctx.pc);
            }
            *code += &format!("pc_{:x}_a_address_check_done:\n", ctx.pc);
        }
        if ctx.chunk_player_mem_reads_collect_main() {
            // Read value from mem reads and store in the proper register: a or c
            *code += &format!(
                "\tmov {}, [{}] {}\n",
                if ctx.store_a_in_c { REG_C } else { REG_A },
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment(format!(
                    "{} = mem_reads[address]",
                    if ctx.store_a_in_c { "c" } else { "a" }
                ))
            );

            // Increment chunk player address
            *code += &format!(
                "\tadd {}, 8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 8")
            );
        }

        if ctx.main_trace() {
            Self::clear_reg_step_ranges(ctx, code, 0);
        }

        if ctx.mem_op() {
            Self::src_read_mops(ctx, code);
        }

        ctx.a.is_saved = true;
    }

    /// Sets register b content based on instruction b_src, except SRC_C
    pub(super) fn b_src_to_asm(
        ctx: &mut ZiskAsmContext,
        instruction: &ZiskInst,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        match instruction.b_src {
            SRC_C => {}
            SRC_REG => {
                *code +=
                    &ctx.full_line_comment(format!("b=SRC_REG reg={}", instruction.b_offset_imm0));

                assert!(instruction.b_offset_imm0 <= 34);

                // Read from memory and store in the proper register: b or c
                let dest_reg = if ctx.store_b_in_c { REG_C } else { REG_B };
                let dest_desc = if ctx.store_b_in_c { "c" } else { "b" };
                Self::read_riscv_reg(ctx, code, instruction.b_offset_imm0, dest_reg, dest_desc);

                if ctx.main_trace() {
                    Self::trace_reg_access(ctx, code, instruction.b_offset_imm0, 1);
                }
            }
            SRC_MEM => Self::b_src_mem_to_asm(ctx, instruction, code, unusual_code),
            SRC_IMM => {
                *code += &ctx.full_line_comment("b=SRC_IMM".to_string());
                ctx.b.is_constant = true;
                ctx.b.constant_value =
                    instruction.b_offset_imm0 | (instruction.b_use_sp_imm1 << 32);
                ctx.b.string_value = format!("0x{:x}", ctx.b.constant_value);
                if ctx.store_b_in_c {
                    *code += &format!(
                        "\tmov {}, {} {}\n",
                        REG_C,
                        ctx.b.string_value,
                        ctx.comment_str("c = constant")
                    );
                    ctx.b.is_saved = false;
                } else if ctx.store_b_in_b {
                    *code += &format!(
                        "\tmov {}, {} {}\n",
                        REG_B,
                        ctx.b.string_value,
                        ctx.comment_str("b = constant")
                    );
                    ctx.b.is_saved = true;
                } else {
                    ctx.b.is_saved = false;
                }
                // DEBUG: Used only to get register traces:
                //*s += &format!("\tmov {}, {} {}\n", REG_B, ctx.b.string_value, ctx.commit_str("b = b_value"));

                if ctx.main_trace() {
                    Self::clear_reg_step_ranges(ctx, code, 1);
                }
            }
            SRC_IND => Self::b_src_ind_to_asm(ctx, instruction, code, unusual_code),
            _ => panic!(
                "ZiskRom2Asm::save_to_asm() Invalid b_src={} pc={}",
                instruction.b_src, ctx.pc
            ),
        }
    }

    /// Reads register b from memory, b_src=SRC_MEM
    fn b_src_mem_to_asm(
        ctx: &mut ZiskAsmContext,
        instruction: &ZiskInst,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("b=SRC_MEM".to_string());

        let b_is_free_input =
            (instruction.b_offset_imm0 == FREE_INPUT_ADDR) && (instruction.b_use_sp_imm1 == 0);

        if !ctx.chunk_player_mem_reads_collect_main() {
            if b_is_free_input {
                // No need to write REG_ADDRESS, as we will read from mem_free_input
                ctx.address_is_constant = true;
                ctx.address_constant_value = instruction.b_offset_imm0;
            } else {
                // Calculate memory address
                *code += &format!(
                    "\tmov {}, 0x{:x} {}\n",
                    REG_ADDRESS,
                    instruction.b_offset_imm0,
                    ctx.comment_str("address = b_offset_imm0")
                );
                if instruction.b_use_sp_imm1 != 0 {
                    *code += &format!(
                        "\tadd {}, {} {}\n",
                        REG_ADDRESS,
                        ctx.mem_sp,
                        ctx.comment_str("address += sp")
                    );
                    ctx.address_is_constant = false;
                } else {
                    ctx.address_is_constant = true;
                    ctx.address_constant_value = instruction.b_offset_imm0;
                }
            }
        }

        // Read value from memory and store in the proper register: b or c
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            if b_is_free_input {
                *code += &format!(
                    "\tmov {}, {} {}\n",
                    if ctx.store_b_in_c { REG_C } else { REG_B },
                    ctx.mem_free_input,
                    ctx.comment(format!(
                        "{} = mem_free_input",
                        if ctx.store_b_in_c { "c" } else { "b" }
                    ))
                );
            } else {
                let constant_address =
                    ctx.address_is_constant.then_some(ctx.address_constant_value);
                Self::guest_range_check(
                    ctx,
                    code,
                    unusual_code,
                    REG_ADDRESS,
                    constant_address,
                    8,
                    GuestAccess::Read,
                );
                *code += &format!(
                    "\tmov {}, [{}] {}\n",
                    if ctx.store_b_in_c { REG_C } else { REG_B },
                    REG_ADDRESS,
                    ctx.comment(format!(
                        "{} = mem[address]",
                        if ctx.store_b_in_c { "c" } else { "b" }
                    ))
                );
            }
        }

        // Generate mem reads
        if ctx.minimal_trace() || ctx.zip() {
            // If zip, check if chunk is active
            if ctx.zip() {
                *code += &format!(
                    "\ttest {}, 1 {}\n",
                    REG_ACTIVE_CHUNK,
                    ctx.comment_str("active_chunk == 1 ?")
                );
                *code += &format!("\tjnz pc_{:x}_b_active_chunk\n", ctx.pc);
                *code += &format!("\tjmp pc_{:x}_b_address_check_done\n", ctx.pc);
                *code += &format!("pc_{:x}_b_active_chunk:\n", ctx.pc);
            }
            // If address is constant
            if instruction.b_use_sp_imm1 == 0 {
                // If address is constant and aligned
                if (instruction.b_offset_imm0 & 0x7) == 0 {
                    Self::b_src_mem_aligned(ctx, code);
                } else {
                    Self::b_src_mem_not_aligned(ctx, code);
                }
            }
            // If address is dynamic
            else {
                // Check if address is aligned, i.e. it is a multiple of 8
                *code +=
                    &format!("\ttest {}, 0x7 {}\n", REG_ADDRESS, ctx.comment_str("address &= 7"));
                *code += &format!("\tjnz pc_{:x}_b_address_not_aligned\n", ctx.pc);
                Self::b_src_mem_aligned(ctx, code);
                *unusual_code += &format!("pc_{:x}_b_address_not_aligned:\n", ctx.pc);
                Self::b_src_mem_not_aligned(ctx, unusual_code);
                *unusual_code += &format!("\tjmp pc_{:x}_b_address_check_done\n", ctx.pc);
            }
            *code += &format!("pc_{:x}_b_address_check_done:\n", ctx.pc);
        }
        if ctx.mem_reads() {
            Self::b_src_mem_aligned(ctx, code);
        }

        // Consume mem reads
        if ctx.chunk_player_mt_collect_mem() {
            let reg_to_store_value = if ctx.store_b_in_c { REG_C } else { REG_B };
            let reg_to_store_value_desc = if ctx.store_b_in_c { "c" } else { "b" };

            // If address is constant
            if instruction.b_use_sp_imm1 == 0 {
                // If address is constant and aligned
                if (instruction.b_offset_imm0 & 0x7) == 0 {
                    Self::chunk_player_mem_read_aligned(
                        ctx,
                        code,
                        reg_to_store_value,
                        reg_to_store_value_desc,
                        1,
                    );
                } else {
                    Self::chunk_player_b_src_mem_not_aligned(ctx, code);
                }
            }
            // If address is dynamic
            else {
                // Check if address is aligned, i.e. it is a multiple of 8, or not,
                // and insert code accordingly
                *code +=
                    &format!("\ttest {}, 0x7 {}\n", REG_ADDRESS, ctx.comment_str("address &= 7"));
                *code += &format!("\tjnz pc_{:x}_b_address_not_aligned\n", ctx.pc);
                Self::chunk_player_mem_read_aligned(
                    ctx,
                    code,
                    reg_to_store_value,
                    reg_to_store_value_desc,
                    1,
                );
                *unusual_code += &format!("pc_{:x}_b_address_not_aligned:\n", ctx.pc);
                Self::chunk_player_b_src_mem_not_aligned(ctx, unusual_code);
                *unusual_code += &format!("\tjmp pc_{:x}_b_address_check_done\n", ctx.pc);
            }
            *code += &format!("pc_{:x}_b_address_check_done:\n", ctx.pc);
        }
        if ctx.chunk_player_mem_reads_collect_main() {
            // Read value from mem reads and store in the proper register: b or c
            *code += &format!(
                "\tmov {}, [{}] {}\n",
                if ctx.store_b_in_c { REG_C } else { REG_B },
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment(format!(
                    "{} = mem_reads[address]",
                    if ctx.store_a_in_c { "c" } else { "b" }
                ))
            );

            // Increment chunk player address
            *code += &format!(
                "\tadd {}, 8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 8")
            );
        }

        ctx.b.is_saved = !ctx.store_b_in_c;

        if ctx.main_trace() {
            Self::clear_reg_step_ranges(ctx, code, 1);
        }

        if ctx.mem_op() {
            Self::src_read_mops(ctx, code);
        }
    }

    /// Reads register b from memory through an indirection, b_src=SRC_IND
    fn b_src_ind_to_asm(
        ctx: &mut ZiskAsmContext,
        instruction: &ZiskInst,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment(format!("b=SRC_IND width={}", instruction.ind_width));

        // Make sure register a is stored in REG_A
        // However, since b's source is an indirection, a's source is normally a register
        if ctx.a.is_constant && !ctx.a.is_saved {
            *code += &format!("\tmov {}, {}\n", REG_A, ctx.a.string_value);
            ctx.a.is_saved = true;
        }

        // Use REG_A if a's value is not needed beyond the b indirection, in which case
        // we can overwirte it to build the address to read from the b value,
        // or REG_ADDRESS otherwise to preserve the value of a
        let mut reg_address: &str = REG_A;
        if instruction.op == ZiskOp::CopyB.code()
            || instruction.op == ZiskOp::SignExtendB.code()
            || instruction.op == ZiskOp::SignExtendH.code()
            || instruction.op == ZiskOp::SignExtendH.code()
        {
        } else {
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_ADDRESS,
                ctx.a.string_value,
                ctx.comment_str("address = a")
            );
            reg_address = REG_ADDRESS;
        }

        // Calculate memory address
        if !ctx.chunk_player_mem_reads_collect_main() {
            if instruction.b_offset_imm0 != 0 {
                *code += &format!(
                    "\tadd {}, 0x{:x} {}\n",
                    reg_address,
                    instruction.b_offset_imm0,
                    ctx.comment_str("address += b_offset_imm0")
                );
            }
            if instruction.b_use_sp_imm1 != 0 {
                *code += &format!(
                    "\tadd {}, {} {}\n",
                    reg_address,
                    ctx.mem_sp,
                    ctx.comment_str("address += sp")
                );
            }
        }

        // Read from memory and store in the proper register: b or c
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            let constant_address = (ctx.a.is_constant && instruction.b_use_sp_imm1 == 0)
                .then(|| ctx.a.constant_value.wrapping_add(instruction.b_offset_imm0));
            Self::guest_range_check(
                ctx,
                code,
                unusual_code,
                reg_address,
                constant_address,
                instruction.ind_width,
                GuestAccess::Read,
            );
            match instruction.ind_width {
                8 => {
                    // Read 8-bytes value from address
                    *code += &format!(
                        "\tmov {}, qword {}[{}] {}\n",
                        if ctx.store_b_in_c { REG_C } else { REG_B },
                        ctx.ptr,
                        reg_address,
                        ctx.comment(format!(
                            "{} = mem[address]",
                            if ctx.store_b_in_c { "c" } else { "b" }
                        ))
                    );
                }
                4 => {
                    // Read 4-bytes value from address
                    *code += &format!(
                        "\tmov {}, [{}] {}\n",
                        if ctx.store_b_in_c { REG_C_W } else { REG_B_W },
                        reg_address,
                        ctx.comment(format!(
                            "{} = mem[address]",
                            if ctx.store_b_in_c { "c" } else { "b" }
                        ))
                    );
                }
                2 => {
                    // Read 2-bytes value from address
                    *code += &format!(
                        "\tmovzx {}, word {}[{}] {}\n",
                        if ctx.store_b_in_c { REG_C } else { REG_B },
                        ctx.ptr,
                        reg_address,
                        ctx.comment(format!(
                            "{} = mem[address]",
                            if ctx.store_b_in_c { "c" } else { "b" }
                        ))
                    );
                }
                1 => {
                    // Read 1-bytes value from address
                    *code += &format!(
                        "\tmovzx {}, byte {}[{}] {}\n",
                        if ctx.store_b_in_c { REG_C } else { REG_B },
                        ctx.ptr,
                        reg_address,
                        ctx.comment(format!(
                            "{} = mem[address]",
                            if ctx.store_b_in_c { "c" } else { "b" }
                        ))
                    );
                }
                _ => panic!(
                    "ZiskRom2Asm::save_to_asm() Invalid ind_width={} pc={}",
                    instruction.ind_width, ctx.pc
                ),
            }
        }

        Self::b_src_ind_mem_reads(ctx, instruction, reg_address, code, unusual_code);

        if ctx.mem_reads() {
            Self::b_src_mem_aligned(ctx, code);
        }
        ctx.b.is_saved = !ctx.store_b_in_c;

        Self::chunk_player_b_src_ind(ctx, instruction, reg_address, code, unusual_code);

        if ctx.chunk_player_mem_reads_collect_main() {
            // Read value from mem reads and store in the proper register: a or c
            *code += &format!(
                "\tmov {}, [{}] {}\n",
                if ctx.store_b_in_c { REG_C } else { REG_B },
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment(format!(
                    "{} = mem_reads[address]",
                    if ctx.store_a_in_c { "c" } else { "b" }
                ))
            );

            // Increment chunk player address
            *code += &format!(
                "\tadd {}, 8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 8")
            );
        }

        if ctx.main_trace() {
            Self::clear_reg_step_ranges(ctx, code, 1);
        }

        if ctx.mem_op() {
            Self::b_src_ind_mops(ctx, code, reg_address, instruction.ind_width);
        }
    }
}
