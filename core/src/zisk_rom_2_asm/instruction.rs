//! Code of one instruction: its label, the sources of a and b, the operation, the store of c,
//! the step count and the jump to the next pc

use super::registers::{REG_ADDRESS, REG_PC, REG_STEP, REG_VALUE};
use crate::{
    zisk_ops::ZiskOp, ZiskAsmContext, ZiskInst, ZiskRom, ZiskRom2Asm, M64, ROM_ADDR, ROM_ADDR_MAX,
    ROM_ENTRY, SRC_IMM,
};

// Only used to calculate histogram position for every rom pc
const TRACE_ADDR_NUMBER: u64 = 0xd0000000 + 0x20;

impl ZiskRom2Asm {
    /// Emits the code of the instruction at position k of the sorted pc list, labeled
    /// pc_<pc_in_hex>
    pub(super) fn instruction_to_asm(
        ctx: &mut ZiskAsmContext,
        rom: &ZiskRom,
        k: usize,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        // Reset wait for prec counter and per-pc error labels
        ctx.wait_for_prec_counter = 0;
        ctx.error_labels = 0;

        // Get pc
        ctx.pc = rom.sorted_pc_list[k];

        // Call chunk_start the first time, for the first chunk
        if (ctx.minimal_trace() || ctx.main_trace() || ctx.zip() || ctx.mem_op() || ctx.mem_reads())
            && (k == 0)
        {
            // Update pc
            *code +=
                &format!("\tmov {}, 0x{:08x} {}\n", REG_PC, ctx.pc, ctx.comment_str("value = pc"));

            // Reset number of chunks
            *code += &ctx.full_line_comment(
                "Reset number of chunks to 0 (first position in trace)".to_string(),
            );
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_ADDRESS,
                ctx.mem_trace_address,
                ctx.comment_str("address = trace_addr")
            );
            *code += &format!(
                "\tmov qword {} [{}], 0 {}\n",
                ctx.ptr,
                REG_ADDRESS,
                ctx.comment_str("number of chunks = 0")
            );

            // Call chunk start
            *code += &format!(
                "\tcall chunk_start {}\n",
                ctx.comment_str("Call chunk_start the first time")
            );
        }

        ctx.next_pc =
            if (k + 1) < rom.sorted_pc_list.len() { rom.sorted_pc_list[k + 1] } else { M64 };
        let instruction = &rom.insts[&ctx.pc].i;

        // Instruction label
        *code += "\n";
        let mut instruction_comment = instruction.to_text();
        instruction_comment.remove(0);
        *code += &format!("pc_{:x}: {}\n", ctx.pc, ctx.comment(instruction_comment));

        // Self::push_internal_registers(ctx, code, false);
        // *code += &format!("\tmov rdi, {}\n", ctx.pc);
        // *code += &format!("\tmov rsi, {}\n", REG_C);
        // if ctx.chunk_player_mt_collect_mem() {
        //     *code += &format!("\tmov rdx, {}\n", REG_CHUNK_PLAYER_ADDRESS);
        // } else {
        //     *code += &format!("\tmov rdx, {}\n", REG_MEM_READS_SIZE);
        //     *code += &format!("\tshl rdx, 3\n");
        //     *code += &format!("\tadd rdx, {}\n", REG_MEM_READS_ADDRESS);
        // }
        // *code += &format!("\tcall _print_pc\n");
        // Self::pop_internal_registers(ctx, code, false);

        //println!("ZiskRom2Asm::save_to_asm() instruction={}", instruction.to_text());

        // Log instruction pc
        // *s += &format!("\tlea rdi, instruction_format\n");
        // *s += &format!("\tmov rsi, {}\n", ctx.pc);
        // *s += &format!("\tmov rax, 0\n");
        // *s += &format!("\tcall printf\n");

        // *s += "\tmov rax, 1\n";
        // *s += "\tmov rdi, 1\n";
        // *s += &format!("\tlea rsi, pc_{}_log\n", ctx.pc);
        // *s += &format!("\tmov rdx, pc_{}_log_len\n", ctx.pc);
        // *s += "\tsyscall\n\n";

        // Update the rom histogram
        if ctx.rom_histogram() {
            let address = Self::get_rom_histogram_trace_address(rom, ctx.pc);
            *code += &ctx.full_line_comment("rom histogram".to_string());
            *code += &format!("\tmov {REG_ADDRESS}, 0x{address:08x}\n");
            *code += &format!("\tinc qword {}[{}]\n", ctx.ptr, REG_ADDRESS);
        }

        Self::main_trace_op(ctx, instruction, code);

        // Set special storage destinations for a and b registers, based on operations, in order
        // to save instructions
        let zisk_op = ZiskOp::try_from_code(instruction.op).unwrap();
        ctx.store_a_in_c = false;
        ctx.store_a_in_a = false;
        ctx.store_b_in_c = false;
        ctx.store_b_in_b = false;
        ctx.address_is_constant = false;
        Self::set_storage_destinations(ctx, instruction, zisk_op);

        Self::b_src_c_to_asm(ctx, instruction, code);

        /************/
        /* A SOURCE */
        /************/

        Self::a_src_to_asm(ctx, instruction, code, unusual_code);

        Self::main_trace_a(ctx, code);
        Self::main_trace_rom_index_and_addr1(ctx, instruction, code);

        /************/
        /* B SOURCE */
        /************/

        Self::b_src_to_asm(ctx, instruction, code, unusual_code);

        Self::main_trace_b(ctx, code);

        /*************/
        /* Operation */
        /*************/

        // Execute operation, storing result is registers c and flag
        Self::operation_to_asm(ctx, instruction, code, unusual_code);

        Self::main_trace_c(ctx, code);

        /***********/
        /* STORE C */
        /***********/

        Self::store_c_to_asm(ctx, instruction, code, unusual_code);

        // if ctx.c.is_constant && !ctx.c.string_value.eq(REG_C) {
        //     *s += &format!(
        //         "\tmov {}, {} ; STORE: make sure c=value */\n",
        //         REG_C, ctx.c.string_value
        //     );
        // }

        // Used only to get traces of registers a, b, c and flag/step
        // *s += &format!("\tpush {}\n", REG_FLAG);
        // *s += &format!("\tpush {}\n", REG_FLAG);
        // *s += &format!("\tpush {}\n", REG_C);
        // *s += &format!("\tpush {}\n", REG_B);
        // *s += &format!("\tpush {}\n", REG_A);
        // *s += &format!("\tmov rdi, {}\n", REG_A);
        // *s += &format!("\tmov rsi, {}\n", REG_B);
        // *s += &format!("\tmov rdx, {}\n", REG_C);
        // // if ctx.flag_is_always_one {
        // //     *s += &format!("\tmov rcx, 1\n");
        // // } else if ctx.flag_is_always_zero {4
        // //     *s += &format!("\tmov rcx, 0\n");
        // // } else {
        // //     *s += &format!("\tmov rcx, {}\n", REG_FLAG);
        // // }
        // *s += &format!("\tmov rcx, {}\n", MEM_STEP);
        // *s += &format!("\tmov rax, 0\n"); // NEW
        // *s += &format!("\tcall _print_abcflag\n");
        // *s += &format!("\tpop {}\n", REG_A);
        // *s += &format!("\tpop {}\n", REG_B);
        // *s += &format!("\tpop {}\n", REG_C);
        // *s += &format!("\tpop {}\n", REG_FLAG);
        // *s += &format!("\tpop {}\n", REG_FLAG);

        // Used for debugging
        // Self::push_internal_registers(ctx, code, false);
        // *code += &format!("\tmov rdi, {}\n", ctx.pc);
        // *code += &format!("\tmov rsi, {}\n", REG_C);
        // *code += &format!("\tcall _print_pc\n");
        // Self::pop_internal_registers(ctx, code, false);

        Self::main_trace_reg_steps(ctx, code);

        /********/
        /* STEP */
        /********/

        Self::step_to_asm(ctx, rom, instruction, code, unusual_code);

        // Jump to new pc, if not the next one
        if instruction.end {
            *code += "\tjmp execute_end\n";
        } else if !ctx.jump_to_static_pc.is_empty() {
            *code += ctx.jump_to_static_pc.as_str();
        } else if ctx.jump_to_dynamic_pc {
            Self::jumpt_to_dynamic_pc(ctx, code);
        }
    }

    /// Sets the storage destinations of the a and b registers for the operation
    fn set_storage_destinations(ctx: &mut ZiskAsmContext, instruction: &ZiskInst, zisk_op: ZiskOp) {
        match zisk_op {
            ZiskOp::CopyB
            | ZiskOp::PubOut
            | ZiskOp::FcallParam
            | ZiskOp::Fcall
            | ZiskOp::FcallGet => ctx.store_b_in_c = true,
            ZiskOp::Xor
            | ZiskOp::And
            | ZiskOp::Or
            | ZiskOp::Sll
            | ZiskOp::Srl
            | ZiskOp::Sra
            | ZiskOp::Sub
            | ZiskOp::Min
            | ZiskOp::Minu
            | ZiskOp::Max
            | ZiskOp::Maxu => ctx.store_a_in_c = true,
            ZiskOp::MinuW | ZiskOp::MinW | ZiskOp::MaxuW | ZiskOp::MaxW => {
                ctx.store_a_in_c = true;
                ctx.store_b_in_b = true;
            }
            ZiskOp::SignExtendB | ZiskOp::SignExtendH | ZiskOp::SignExtendW | ZiskOp::AddW => {
                ctx.store_b_in_b = true
            }
            ZiskOp::SubW
            | ZiskOp::Eq
            | ZiskOp::Ltu
            | ZiskOp::Lt
            | ZiskOp::LtuW
            | ZiskOp::LtW
            | ZiskOp::Leu
            | ZiskOp::Le
            | ZiskOp::LeuW
            | ZiskOp::LeW => ctx.store_a_in_a = true,
            ZiskOp::Mulu
            | ZiskOp::Muluh
            | ZiskOp::Mulsuh
            | ZiskOp::Mul
            | ZiskOp::Mulh
            | ZiskOp::MulW
            | ZiskOp::Div
            | ZiskOp::Rem
            | ZiskOp::DivuW
            | ZiskOp::RemuW
            | ZiskOp::DivW
            | ZiskOp::RemW => {
                ctx.store_a_in_a = true;
                ctx.store_b_in_b = true;
            }
            ZiskOp::Divu | ZiskOp::Remu => {
                ctx.store_b_in_b = true;
            }
            ZiskOp::Add => {
                if (instruction.a_src == SRC_IMM)
                    && (instruction.a_offset_imm0 == 0)
                    && (instruction.a_use_sp_imm1 == 0)
                {
                    ctx.store_b_in_c = true;
                } else {
                    ctx.store_a_in_c = true;
                }
            }
            _ => {}
        };

        // Make sure we don't store two registers in the same register
        assert!(!(ctx.store_a_in_c && ctx.store_b_in_c));
        assert!(!(ctx.store_a_in_c && ctx.store_a_in_a));
        assert!(!(ctx.store_b_in_c && ctx.store_b_in_b));
    }

    /// Counts the step and, at the end of a chunk or of the program, calls the chunk and end
    /// handlers, setting the next pc
    fn step_to_asm(
        ctx: &mut ZiskAsmContext,
        rom: &ZiskRom,
        instruction: &ZiskInst,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        // Decrement step counter
        *code += &ctx.full_line_comment("STEP".to_string());
        if ctx.fast() || ctx.rom_histogram() {
            *code += &format!("\tinc {} {}\n", REG_STEP, ctx.comment_str("increment step"));
        }
        if ctx.chunks()
            || ctx.minimal_trace()
            || ctx.main_trace()
            || ctx.zip()
            || ctx.mem_op()
            || ctx.chunk_player_mt_collect_mem()
            || ctx.mem_reads()
            || ctx.chunk_player_mem_reads_collect_main()
        {
            *code +=
                &format!("\tdec {} {}\n", REG_STEP, ctx.comment_str("decrement step count down"));
            if instruction.end {
                *code += &format!("\tmov {}, 1 {}\n", ctx.mem_end, ctx.comment_str("end = 1"));
                *code += &format!(
                    "\tmov {}, 0x{:08x} {}\n",
                    REG_PC,
                    ctx.pc,
                    ctx.comment_str("value = pc")
                );
                if ctx.chunk_player_mt_collect_mem() || ctx.chunk_player_mem_reads_collect_main() {
                    *code += "\tjz execute_end\n";
                } else {
                    *code += "\tcall chunk_end\n";
                }
            } else if ctx.chunk_player_mt_collect_mem() || ctx.chunk_player_mem_reads_collect_main()
            {
                *code += "\tjz execute_end\n";
                Self::set_pc(ctx, instruction, code, "nz", rom);
            } else {
                *code += &format!("\tjz pc_{:x}_step_zero\n", ctx.pc);
                *unusual_code += &format!("pc_{:x}_step_zero:\n", ctx.pc);
                Self::set_pc(ctx, instruction, unusual_code, "z", rom);
                *unusual_code += "\tcall chunk_end_and_start\n";
                *unusual_code += &format!(
                    "\tmov {}, {} {}\n",
                    REG_VALUE,
                    ctx.mem_step,
                    ctx.comment_str("value = step")
                );
                *unusual_code += &format!(
                    "\tcmp {}, qword ptr [max_steps] {}\n",
                    REG_VALUE,
                    ctx.comment_str("step ?= max_steps")
                );
                *unusual_code += "\tjae execute_end\n";
                *unusual_code += &format!("\tjmp pc_{:x}_step_done\n", ctx.pc);
                Self::set_pc(ctx, instruction, code, "nz", rom);
                *code += &format!("pc_{:x}_step_done:\n", ctx.pc);
            }
        }
        if ctx.fast() || ctx.rom_histogram() {
            if instruction.end {
                *code += &format!("\tmov {}, 1 {}\n", ctx.mem_end, ctx.comment_str("end = 1"));
            }
            Self::set_pc(ctx, instruction, code, "nz", rom);
        }

        // Used only to get logs of step
        // *s += &format!("\tmov {}, {} ; value = step */\n", REG_VALUE, MEM_STEP);
        // *s += &format!("\tand {}, 0xfffff ; value = step */\n", REG_VALUE);
        // *s += &format!("\tcmp {}, 0 ; value = step */\n", REG_VALUE);
        // *s += &format!("\tjne  pc_{:x}_inc_step_done ; value = step */\n", ctx.pc);
        // *s += &format!("\tpush {}\n", REG_VALUE);
        // *s += &format!("\tmov rdi, {}\n", MEM_STEP);

        // *s += "\tpush rax\n";
        // *s += "\tpush rcx\n";
        // *s += "\tpush rdx\n";
        // // *s += "\tpush rdi\n";
        // // *s += "\tpush rsi\n";
        // // *s += "\tpush rsp\n";
        // // *s += "\tpush r8\n";
        // *s += "\tpush r9\n";
        // *s += "\tpush r10\n";
        // //*s += "\tpush r11\n";
        // *s += &format!("\tcall _print_step\n");

        // //*s += "\tpop r11\n";
        // *s += "\tpop r10\n";
        // *s += "\tpop r9\n";
        // // *s += "\tpop r8\n";
        // // *s += "\tpop rsp\n";
        // // *s += "\tpop rsi\n";
        // // *s += "\tpop rdi\n";
        // *s += "\tpop rdx\n";
        // *s += "\tpop rcx\n";
        // *s += "\tpop rax\n";

        // *s += &format!("\tpop {}\n", REG_VALUE);
        // *s += &format!("pc_{:x}_inc_step_done:\n", ctx.pc);

        // If step % K == 0 then store data
        // *s += &format!("\tmov {}, {} ; copy step into value */\n", REG_VALUE, MEM_STEP);
        // *s += &format!("\tand {}, 0xffff ; value &= k */\n", REG_VALUE);
        // *s += &format!(
        //     "\tjnz pc_{:x}_no_store_data ; skip if storing is not required */\n",
        //     ctx.pc
        // );
        // *s += &format!("\t; Store data */\n");
        // *s += &format!("pc_{:x}_no_store_data:\n", ctx.pc);
    }

    /*****************/
    /* ROM HISTOGRAM */
    /*****************/

    /// This function calculates the address of the rom histogram for the provided pc
    ///
    /// ROM histogram structure:
    ///
    /// ROM trace control:
    ///     [8B] version
    ///     [8B] exit_code (0=success, 1=not completed)
    ///     [8B] allocated_size = xxx (bytes)
    ///     [8B] used_size = xxx (bytes)
    /// BIOS histogram: (TRACE_ADDR_NUMBER)
    ///     [8B] multiplicity_size = B
    ///     [8B] multiplicity[0] → 4096
    ///     [8B] multiplicity[1] → 4096 + 4
    ///     …
    ///     [8B] multiplicity[B-1] → 4096 + 4*(B-1)
    /// Program histogram:
    ///     [8B] multiplicity_size = P
    ///     [8B] multiplicity[0] → 0x80000000
    ///     [8B] multiplicity[1] → 0x80000000 + 1
    ///     …
    ///     [8B] multiplicity[P-1] → 0x80000000 + (P-1)
    ///
    fn get_rom_histogram_trace_address(rom: &ZiskRom, pc: u64) -> u64 {
        assert!(rom.max_bios_pc >= ROM_ENTRY);
        assert!(rom.max_bios_pc < ROM_ADDR);
        assert!(rom.max_program_pc >= ROM_ADDR);
        assert!(rom.max_program_pc <= ROM_ADDR_MAX);
        if pc < ROM_ADDR {
            TRACE_ADDR_NUMBER + (1 + ((pc - ROM_ENTRY) >> 2)) * 8
        } else {
            TRACE_ADDR_NUMBER
                + (1 + ((rom.max_bios_pc - ROM_ENTRY) >> 2) + 1 + 1 + pc - ROM_ADDR) * 8
        }
    }
}
