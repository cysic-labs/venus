//! Program level code: the data section, the external symbols, the functions called by the C
//! emulator, and the start and end of the emulation

use super::registers::{
    REG_A, REG_ACTIVE_CHUNK, REG_ADDRESS, REG_AUX, REG_B, REG_C, REG_FLAG, REG_PC, REG_STEP,
    REG_VALUE, XMM_MAPPED_REGS,
};
use crate::{ZiskAsmContext, ZiskRom, ZiskRom2Asm, FCALL_PARAMS_MAX_SIZE, FCALL_RESULT_MAX_SIZE};

// Fcall params and result lengths
// NOTE: if these parameters are update, review dma_constants.inc
pub(super) const FCALL_PARAMS_LENGTH: u64 = FCALL_PARAMS_MAX_SIZE as u64;
pub(super) const FCALL_RESULT_LENGTH: u64 = FCALL_RESULT_MAX_SIZE as u64;

// Fcall context offsets of the different fields
pub(super) const FCALL_FUNCTION_ID: u64 = 0;
const FCALL_PARAMS_CAPACITY: u64 = FCALL_FUNCTION_ID + 1;
pub(super) const FCALL_PARAMS_SIZE: u64 = FCALL_PARAMS_CAPACITY + 1;
pub(super) const FCALL_PARAMS: u64 = FCALL_PARAMS_SIZE + 1;
const FCALL_RESULT_CAPACITY: u64 = FCALL_PARAMS + FCALL_PARAMS_LENGTH;
pub(super) const FCALL_RESULT_SIZE: u64 = FCALL_RESULT_CAPACITY + 1;
pub(super) const FCALL_RESULT: u64 = FCALL_RESULT_SIZE + 1;
pub(super) const FCALL_RESULT_GOT: u64 = FCALL_RESULT + FCALL_RESULT_LENGTH;
const FCALL_LENGTH: u64 = FCALL_RESULT_GOT + 1;

impl ZiskRom2Asm {
    /// Emits the assembler preamble and the data section: the memory variables, the RISC-V
    /// registers that are not mapped to xmm registers, and the fcall context
    pub(super) fn data_section(ctx: &mut ZiskAsmContext, code: &mut String) {
        // Preamble
        *code += ".intel_syntax noprefix\n";
        *code += ".code64\n";

        // Global variables
        *code += ".section .data\n";
        *code += ".align 8\n";
        *code += ".comm MEM_STEP, 8, 8\n";
        *code += ".comm MEM_SP, 8, 8\n";
        *code += ".comm MEM_END, 8, 8\n";
        *code += ".comm MEM_ERROR, 8, 8\n";
        *code += ".comm MEM_ERROR_PC, 8, 8\n";
        *code += ".comm MEM_TRACE_ADDRESS, 8, 8\n";
        *code += ".comm MEM_CHUNK_ADDRESS, 8, 8\n";
        *code += ".comm MEM_CHUNK_START_STEP, 8, 8\n";
        *code += ".comm MEM_RSP, 8, 8\n";
        *code += ".comm MEM_FREE_INPUT, 8, 8\n";
        if ctx.precompile_results() {
            *code += ".comm MEM_PRECOMPILE_RESULTS_ADDRESS, 8, 8\n";
        }
        if ctx.zip() {
            *code += ".comm MEM_CHUNK_ID, 8, 8\n";
        }

        // Allocate space for the registers
        for r in 0u64..35u64 {
            if !XMM_MAPPED_REGS.contains(&r) {
                *code += &format!(".comm reg_{r}, 8, 8\n");
            }
        }

        if ctx.main_trace() {
            for i in 0..3 {
                *code += &format!(".comm reg_steps_{i}, 8, 8\n");
            }
            for i in 0..3 {
                *code += &format!(".comm reg_prev_steps_{i}, 8, 8\n");
            }
            for i in 0..3 {
                *code += &format!(".comm reg_step_ranges_{i}, 8, 8\n");
            }
            for i in 0..35 {
                *code += &format!(".comm first_step_uses_{i}, 8, 8\n");
            }
        }

        // fcall_context =
        //     function_id
        //     params_max_size
        //     params_size
        //     params[32]
        //     result_max_size
        //     result_size
        //     result[32]
        //     result_got
        *code += &format!(".comm fcall_ctx, 8*{}, 8\n", FCALL_LENGTH);

        // for k in 0..keys.len() {
        //     let pc = keys[k];
        //     let instruction = &rom.insts[&pc].i;
        //     *s += &format!("pc_{}_log: .ascii \"PCLOG={}\\n\"\n", pc, instruction.to_text());
        //     *s += &format!(".set pc_{}_log_len, (. - pc_{}_log)\n", pc, pc);
        // }
    }

    /// Starts the text section, declaring the external symbols used by the generated code
    pub(super) fn text_section_externs(ctx: &mut ZiskAsmContext, code: &mut String) {
        *code += ".section .text\n";
        *code += ".extern print_abcflag\n";
        *code += ".extern print_char\n";
        *code += ".extern print_step\n";
        *code += ".extern opcode_keccak\n";
        *code += ".extern opcode_sha256\n";
        *code += ".extern opcode_poseidon2\n";
        *code += ".extern opcode_arith256\n";
        *code += ".extern opcode_arith256_mod\n";
        *code += ".extern opcode_secp256k1_add\n";
        *code += ".extern opcode_secp256k1_dbl\n";
        *code += ".extern opcode_secp256r1_add\n";
        *code += ".extern opcode_secp256r1_dbl\n";
        *code += ".extern opcode_fcall\n";
        *code += ".extern opcode_bn254_curve_add\n";
        *code += ".extern opcode_bn254_curve_dbl\n";
        *code += ".extern opcode_bn254_complex_add\n";
        *code += ".extern opcode_bn254_complex_sub\n";
        *code += ".extern opcode_bn254_complex_mul\n";
        *code += ".extern opcode_arith384_mod\n";
        *code += ".extern opcode_bls12_381_curve_add\n";
        *code += ".extern opcode_bls12_381_curve_dbl\n";
        *code += ".extern opcode_bls12_381_complex_add\n";
        *code += ".extern opcode_bls12_381_complex_sub\n";
        *code += ".extern opcode_bls12_381_complex_mul\n";
        *code += ".extern opcode_add256\n";
        *code += ".extern opcode_blake2\n";
        *code += ".extern chunk_done\n";
        *code += ".extern print_fcall_ctx\n";
        *code += ".extern print_pc\n";
        *code += ".extern realloc_trace\n";
        if ctx.precompile_results() {
            *code += ".extern wait_for_prec_avail\n\n";
        }

        if ctx.minimal_trace()
            || ctx.main_trace()
            || ctx.zip()
            || ctx.mem_op()
            || ctx.chunk_player_mt_collect_mem()
            || ctx.mem_reads()
            || ctx.chunk_player_mem_reads_collect_main()
        {
            *code += ".extern max_steps\n";
            *code += ".extern chunk_size\n";
            *code += ".extern trace_address\n\n";
            *code += ".extern trace_address_threshold\n\n";
            if ctx.precompile_results() {
                *code += ".extern precompile_result_address\n";
                *code += ".extern precompile_written_address\n";
                *code += ".extern precompile_read_address\n\n";
            }
        }

        if ctx.zip() {
            *code += ".extern chunk_mask\n";
        }

        if ctx.chunk_player_mt_collect_mem() || ctx.chunk_player_mem_reads_collect_main() {
            *code += ".extern chunk_player_address\n";
        }
    }

    /// Emits the chunk_start, chunk_end and chunk_end_and_start functions, called at the chunk
    /// boundaries by the generation methods that split the execution in chunks
    pub(super) fn chunk_functions(ctx: &mut ZiskAsmContext, code: &mut String) {
        if ctx.chunks()
            || ctx.minimal_trace()
            || ctx.main_trace()
            || ctx.zip()
            || ctx.mem_op()
            || ctx.mem_reads()
        {
            // Chunk start
            *code += "chunk_start:\n";
            Self::chunk_start(ctx, code, "start");
            *code += "\tret\n\n";

            // Chunk end
            *code += "chunk_end:\n";
            Self::chunk_end(ctx, code, "end");
            *code += "\tret\n\n";

            // Chunk end and start
            *code += "chunk_end_and_start:\n";
            Self::chunk_end(ctx, code, "end_and_start");
            *code += "\n";
            Self::chunk_start(ctx, code, "end_and_start");
            *code += "\tret\n\n";
        }
    }

    /// Emits the functions to let C know about ASM generation
    pub(super) fn generation_info_functions(
        ctx: &mut ZiskAsmContext,
        rom: &ZiskRom,
        code: &mut String,
    ) {
        // get_max_bios_pc() returns the maximum bios pc used in the ROM
        *code += ".global get_max_bios_pc\n";
        *code += "get_max_bios_pc:\n";
        *code += &format!("\tmov rax, 0x{:08x}\n", rom.max_bios_pc);
        *code += "\tret\n\n";

        // get_max_program_pc() returns the maximum program pc used in the ROM
        *code += ".global get_max_program_pc\n";
        *code += "get_max_program_pc:\n";
        *code += &format!("\tmov rax, 0x{:08x}\n", rom.max_program_pc);
        *code += "\tret\n\n";

        // get_gen_method() returns the generation method used to generate the assembly
        // It must match the one used to call the assembly emulator
        *code += ".global get_gen_method\n";
        *code += "get_gen_method:\n";
        if ctx.fast() {
            *code += "\tmov rax, 0\n";
        } else if ctx.minimal_trace() {
            *code += "\tmov rax, 1\n";
        } else if ctx.rom_histogram() {
            *code += "\tmov rax, 2\n";
        } else if ctx.main_trace() {
            *code += "\tmov rax, 3\n";
        } else if ctx.chunks() {
            *code += "\tmov rax, 4\n";
        } else if ctx.zip() {
            *code += "\tmov rax, 6\n";
        } else if ctx.mem_op() {
            *code += "\tmov rax, 7\n";
        } else if ctx.chunk_player_mt_collect_mem() {
            *code += "\tmov rax, 8\n";
        } else if ctx.mem_reads() {
            *code += "\tmov rax, 9\n";
        } else if ctx.chunk_player_mem_reads_collect_main() {
            *code += "\tmov rax, 10\n";
        } else {
            panic!("ZiskRom2Asm::save_to_asm() invalid generation method");
        }
        *code += "\tret\n\n";

        // get_gen_method() returns the generation method used to generate the assembly
        // It must match the one used to call the assembly emulator
        *code += ".global get_precompile_results\n";
        *code += "get_precompile_results:\n";
        if ctx.precompile_results() {
            *code += "\tmov rax, 1\n";
        } else {
            *code += "\tmov rax, 0\n";
        }
        *code += "\tret\n\n";
    }

    /// Emits the start of the externally callable emulator_start function, which initializes
    /// the registers, the memory variables and the fcall context before the first instruction
    pub(super) fn emulator_start(ctx: &mut ZiskAsmContext, code: &mut String) {
        // Externally callable function label
        *code += ".global emulator_start\n";
        *code += "emulator_start:\n";

        Self::push_external_registers(ctx, code);

        Self::zisk_registers_init(ctx, code);
        Self::asm_memory_init(ctx, code);
        Self::fcall_context_init(ctx, code);

        if ctx.chunk_player_mt_collect_mem() || ctx.chunk_player_mem_reads_collect_main() {
            Self::chunk_player_start(ctx, code);
        }
    }

    /// Sets the ZisK and RISC-V registers to zero, unless a chunk player restores them
    fn zisk_registers_init(ctx: &mut ZiskAsmContext, code: &mut String) {
        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            *code += &format!("\n{}\n", ctx.comment_str("ZisK registers initialization"));
            *code += &format!("\txor {}, {} {}\n", REG_A, REG_A, ctx.comment_str("a = 0"));
            *code += &format!("\txor {}, {} {}\n", REG_B, REG_B, ctx.comment_str("b = 0"));
            *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
            *code += &format!("\txor {}, {} {}\n", REG_FLAG, REG_FLAG, ctx.comment_str("flag = 0"));
            *code += &format!("\txor {}, {} {}\n", REG_PC, REG_PC, ctx.comment_str("pc = 0"));
            *code += &format!("\txor {}, {} {}\n", REG_STEP, REG_STEP, ctx.comment_str("step = 0"));

            // Initialize registers to zero
            *code += &ctx.full_line_comment("Set RISC-V registers to zero".to_string());

            for r in 0u64..35u64 {
                if !XMM_MAPPED_REGS.contains(&r) {
                    *code += &format!("\tmov qword {}[reg_{}], 0\n", ctx.ptr, r);
                }
            }
            for r in 0..16 {
                *code += &format!("\tpxor xmm{r}, xmm{r}\n");
            }
        }
    }

    /// Initializes the memory variables of the generated code
    fn asm_memory_init(ctx: &mut ZiskAsmContext, code: &mut String) {
        *code += &format!("\n{}\n", ctx.comment_str("ASM memory initialization"));
        *code += &format!("\tmov {}, 0 {}\n", ctx.mem_end, ctx.comment_str("end = 0"));
        *code += &format!("\tmov {}, 0 {}\n", ctx.mem_error, ctx.comment_str("error = 0"));
        *code += &format!("\tmov {}, 0 {}\n", ctx.mem_error_pc, ctx.comment_str("error pc = 0"));
        if ctx.fast()
            || ctx.minimal_trace()
            || ctx.rom_histogram()
            || ctx.main_trace()
            || ctx.chunks()
            || ctx.zip()
            || ctx.mem_op()
            || ctx.mem_reads()
        {
            *code += &format!("\tmov {}, 0 {}\n", ctx.mem_step, ctx.comment_str("step = 0"));
            *code += &format!("\tmov {}, 0 {}\n", ctx.mem_sp, ctx.comment_str("sp = 0"));
            if ctx.zip() {
                *code +=
                    &format!("\tmov {}, 0 {}\n", ctx.mem_chunk_id, ctx.comment_str("chunk_id = 0"));
                *code += &format!(
                    "\txor {}, {} {}\n",
                    REG_ACTIVE_CHUNK,
                    REG_ACTIVE_CHUNK,
                    ctx.comment_str("active_chunk = 0")
                );
            }
            *code +=
                &format!("\tmov {}, 0 {}\n", ctx.mem_free_input, ctx.comment_str("free_input = 0"));
        }
        if ctx.minimal_trace()
            || ctx.main_trace()
            || ctx.zip()
            || ctx.mem_op()
            || ctx.chunk_player_mt_collect_mem()
            || ctx.mem_reads()
            || ctx.chunk_player_mem_reads_collect_main()
        {
            *code += &format!(
                "\tmov {}, qword {}[trace_address] {}\n",
                REG_VALUE,
                ctx.ptr,
                ctx.comment_str("value = trace address")
            );
            *code += &format!("\tadd {}, 0x20 {}\n", REG_VALUE, ctx.comment_str("value += 32"));
            *code += &format!(
                "\tmov {}, {} {}\n",
                ctx.mem_trace_address,
                REG_VALUE,
                ctx.comment_str("trace_address = value")
            );
            if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
                // Skip number of chunks
                *code += &format!("\tadd {}, 8 {}\n", REG_VALUE, ctx.comment_str("value+=8"));
            }
            *code += &format!(
                "\tmov {}, {} {}\n\n",
                ctx.mem_chunk_address,
                REG_VALUE,
                ctx.comment_str("chunk_address = value = TRACE_ADDR+8")
            );
            *code += &format!(
                "\tmov {}, 0 {}\n",
                ctx.mem_chunk_start_step,
                ctx.comment_str("chunk_start_step = 0")
            );
        }
        if ctx.precompile_results() {
            *code += &format!(
                "\tmov {}, precompile_results_address {}\n",
                REG_AUX,
                ctx.comment_str("aux = precompile_results_address")
            );
            *code += &format!(
                "\tmov {}, {} {}\n",
                ctx.mem_precompile_results_address,
                REG_AUX,
                ctx.comment_str("mem_precompile_results_counter = precompile_results_address")
            );

            *code += &format!(
                "\tmov {}, 0 {}\n",
                ctx.mem_precompile_read_address,
                ctx.comment_str("precompile_read = 0")
            );
        }
    }

    /// Initializes the capacities and sizes of the fcall context
    fn fcall_context_init(ctx: &mut ZiskAsmContext, code: &mut String) {
        *code += &ctx.full_line_comment("fcall_context initialization".to_string());
        *code += &format!(
            "\tlea {}, {} {}\n",
            REG_ADDRESS,
            ctx.fcall_ctx,
            ctx.comment_str("address = fcall context")
        );
        // for i in 0..FCALL_LENGTH {
        //     if i == FCALL_PARAMS_CAPACITY {
        //         *code += &format!(
        //             "\tmov qword {}[{} + {}*8], {}\n",
        //             ctx.ptr, REG_ADDRESS, i, FCALL_PARAMS_LENGTH
        //         );
        //     } else if i == FCALL_RESULT_CAPACITY {
        //         *code += &format!(
        //             "\tmov qword {}[{} + {}*8], {}\n",
        //             ctx.ptr, REG_ADDRESS, i, FCALL_RESULT_LENGTH
        //         );
        //     } else {
        //         *code += &format!("\tmov qword {}[{} + {}*8], 0\n", ctx.ptr, REG_ADDRESS, i);
        //     }
        // }
        *code += &format!(
            "\tmov qword {}[{} + {}*8], {} {}\n",
            ctx.ptr,
            REG_ADDRESS,
            FCALL_PARAMS_CAPACITY,
            FCALL_PARAMS_LENGTH,
            ctx.comment(format!("fcall_ctx.params_capacity = {}", FCALL_PARAMS_LENGTH))
        );
        *code += &format!(
            "\tmov qword {}[{} + {}*8], 0 {}\n",
            ctx.ptr,
            REG_ADDRESS,
            FCALL_PARAMS_SIZE,
            ctx.comment_str("fcall_ctx.params_size = 0")
        );
        *code += &format!(
            "\tmov qword {}[{} + {}*8], {} {}\n",
            ctx.ptr,
            REG_ADDRESS,
            FCALL_RESULT_CAPACITY,
            FCALL_RESULT_LENGTH,
            ctx.comment(format!("fcall_ctx.result_capacity = {}", FCALL_RESULT_LENGTH))
        );
        *code += &format!(
            "\tmov qword {}[{} + {}*8], 0 {}\n",
            ctx.ptr,
            REG_ADDRESS,
            FCALL_RESULT_SIZE,
            ctx.comment_str("fcall_ctx.result_size = 0")
        );
        *code += &format!(
            "\tmov qword {}[{} + {}*8], 0 {}\n",
            ctx.ptr,
            REG_ADDRESS,
            FCALL_RESULT_GOT,
            ctx.comment_str("fcall_ctx.result_got = 0")
        );
    }

    /// Emits the end of emulator_start, reached when the execution ends, which saves the step
    /// and restores the caller registers
    pub(super) fn emulator_end(ctx: &mut ZiskAsmContext, code: &mut String) {
        *code += "\n";

        *code += "execute_pop_internal_regs_and_end:\n";
        Self::pop_internal_registers(ctx, code, false);
        *code += "\n";

        *code += "execute_end:\n";

        // Update step memory variable with the content of the step register, to make it accessible
        // to the caller
        if ctx.fast() || ctx.rom_histogram() || ctx.main_trace() {
            *code += &format!(
                "\tmov {}, {} {}\n",
                ctx.mem_step,
                REG_STEP,
                ctx.comment_str("update step variable")
            );
        }

        if ctx.chunk_player_mt_collect_mem() || ctx.chunk_player_mem_reads_collect_main() {
            Self::chunk_player_end(ctx, code);
        }

        Self::pop_external_registers(ctx, code);

        // Used only to get the last log of step
        // *s += &format!("\tpush {}\n", REG_VALUE);
        // *s += &format!("\tmov rdi, {}\n", MEM_STEP);
        // *s += "\tcall _print_step\n";
        // *s += &format!("\tpop {}\n", REG_VALUE);

        // *s += "\tmov rax, 60\n";
        // *s += "\tmov rdi, 0\n";
        // *s += "\tsyscall\n\n";

        *code += "\tret\n\n";
    }

    /// Prints the size and line counts of the generated code
    #[cfg(debug_assertions)]
    pub(super) fn log_statistics(ctx: &ZiskAsmContext, rom: &ZiskRom, code: &str) {
        let mut lines = code.lines();
        let mut map_label_lines_counter = 0u64;
        let mut pc_label_lines_counter = 0u64;
        let mut comment_lines_counter = 0u64;
        let mut code_lines_counter = 0u64;

        loop {
            let line_option = lines.next();
            if line_option.is_none() {
                break;
            }
            let line = line_option.unwrap();
            if line.is_empty() {
                continue;
            }
            if line.starts_with("map_pc_") {
                map_label_lines_counter += 1;
                continue;
            }
            if line.starts_with("pc_") {
                pc_label_lines_counter += 1;
                continue;
            }
            if line.starts_with("\t/*") {
                comment_lines_counter += 1;
                continue;
            }
            code_lines_counter += 1;
        }

        println!(
            "ZiskRom2Asm::save_to_asm() {} bytes, {} instructions, {:02} bytes/inst, {} map lines, {} label lines, {} comment lines, {} code lines, {:02} code lines/inst, precompile_results={:?}",                code.len(),
            rom.sorted_pc_list.len(),
            code.len() as f64 / rom.sorted_pc_list.len() as f64,
            map_label_lines_counter,
            pc_label_lines_counter,
            comment_lines_counter,
            code_lines_counter,
            code_lines_counter as f64 / rom.sorted_pc_list.len() as f64,
            ctx.precompile_results
        );
    }
}
