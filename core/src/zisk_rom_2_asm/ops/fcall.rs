//! Free calls: the parameters, the call and the results of a free call

use ziskos_hints::zisklib::FCALL_INPUT_READY_ID;

use crate::{
    zisk_rom_2_asm::{
        control_flow::AsmError,
        guest_memory::GuestAccess,
        program::{
            FCALL_FUNCTION_ID, FCALL_PARAMS, FCALL_PARAMS_LENGTH, FCALL_PARAMS_SIZE, FCALL_RESULT,
            FCALL_RESULT_GOT, FCALL_RESULT_SIZE,
        },
        registers::{REG_AUX, REG_C, REG_VALUE},
    },
    ZiskAsmContext, ZiskRom2Asm,
};

impl ZiskRom2Asm {
    pub(super) fn fcall_param_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        assert!(ctx.store_b_in_c);
        assert!(ctx.a.is_constant);
        *code += &ctx.full_line_comment("FcallParam".to_string());

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // The param takes a words: b itself if a is 1, or else the a words that b
            // points to
            let words = ctx.a.constant_value;
            let overflow = Self::error_label(ctx, unusual_code, AsmError::FcallOverflow);
            if words > FCALL_PARAMS_LENGTH {
                *code += &format!(
                    "\tjmp {} {}\n",
                    overflow,
                    ctx.comment_str("param longer than the params capacity")
                );
            } else {
                if words > 1 {
                    let constant_address = ctx.b.is_constant.then_some(ctx.b.constant_value);
                    Self::guest_range_check(
                        ctx,
                        code,
                        unusual_code,
                        REG_C,
                        constant_address,
                        words * 8,
                        GuestAccess::Read,
                    );
                }
                *code += &format!(
                    "\tmov {}, qword {}[{} + {}*8] {}\n",
                    REG_AUX,
                    ctx.ptr,
                    ctx.fcall_ctx,
                    FCALL_PARAMS_SIZE,
                    ctx.comment_str("aux = params size")
                );
                *code += &format!(
                    "\tcmp {}, 0x{:x} {}\n",
                    REG_AUX,
                    FCALL_PARAMS_LENGTH - words,
                    ctx.comment_str("aux ? params capacity - words")
                );
                *code += &format!("\tja {overflow}\n");
                if words == 1 {
                    *code += &format!(
                        "\tmov qword {}[{} + {}*8 + {}*8], {} {}\n",
                        ctx.ptr,
                        ctx.fcall_ctx,
                        REG_AUX,
                        FCALL_PARAMS,
                        REG_C,
                        ctx.comment_str("ctx.params[size] = b")
                    );
                } else {
                    *code += &format!(
                        "\tlea rdi, [{} + {}*8 + {}*8] {}\n",
                        ctx.fcall_ctx,
                        REG_AUX,
                        FCALL_PARAMS,
                        ctx.comment_str("rdi = &ctx.params[size]")
                    );
                    *code += &format!("\tmov rsi, {} {}\n", REG_C, ctx.comment_str("rsi = b"));
                    *code += &format!("\tmov rcx, {} {}\n", words, ctx.comment_str("rcx = words"));
                    *code += &format!(
                        "\trep movsq {}\n",
                        ctx.comment_str("ctx.params[size..size+words] = mem[b..]")
                    );
                }
                *code += &format!(
                    "\tadd qword {}[{} + {}*8], {} {}\n",
                    ctx.ptr,
                    ctx.fcall_ctx,
                    FCALL_PARAMS_SIZE,
                    words,
                    ctx.comment_str("ctx.params_size += words")
                );
            }
        }

        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn fcall_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("Fcall".to_string());

        assert!(ctx.store_b_in_c);

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get result from precompile results data
            if ctx.a.constant_value == FCALL_INPUT_READY_ID as u64 {
                Self::wait_for_input_ready(ctx, code, unusual_code);
            } else {
                // Store a (function id) in context
                assert!(ctx.a.is_constant);
                *code += &format!(
                    "\tmov qword {}[{} + {}*8], {} {}\n",
                    ctx.ptr,
                    ctx.fcall_ctx,
                    FCALL_FUNCTION_ID,
                    ctx.a.constant_value,
                    ctx.comment_str("ctx.function id = a")
                );

                // Set the fcall context address as the first parameter
                *code += &format!(
                    "\tlea rdi, {} {}\n",
                    ctx.fcall_ctx,
                    ctx.comment_str("rdi = fcall context")
                );
                // Get result from precompile results data
                if ctx.precompile_results_fcall() {
                    Self::precompile_results_fcall(ctx, code, unusual_code, "rdi");
                } else {
                    // Call the fcall function
                    Self::push_internal_registers(ctx, code, false);
                    //Self::assert_rsp_is_aligned(ctx, code);
                    *code += "\tcall _opcode_fcall\n";
                    Self::pop_internal_registers(ctx, code, false);
                    //Self::assert_rsp_is_aligned(ctx, code);
                }

                // If ctx.result_size == 0 => free_input = 0
                *code += &format!(
                    "\tmov {}, qword {}[{} + {}*8] {}\n",
                    REG_AUX,
                    ctx.ptr,
                    ctx.fcall_ctx,
                    FCALL_RESULT_SIZE,
                    ctx.comment_str("aux = ctx.result_size")
                );
                *code += &format!("\tcmp {REG_AUX}, 0\n");
                *code += &format!("\tjz pc_{:x}_fcall_result_zero\n", ctx.pc);

                // Copy ctx.result[0] to free input address
                *code += &format!(
                    "\tmov {}, qword {}[{} + {}*8] {}\n",
                    REG_VALUE,
                    ctx.ptr,
                    ctx.fcall_ctx,
                    FCALL_RESULT,
                    ctx.comment_str("value = ctx.result[0]")
                );
                *code += &format!(
                    "\tmov {}, {} {}\n",
                    ctx.mem_free_input,
                    REG_VALUE,
                    ctx.comment_str("free_input = value")
                );
                *code += &format!("\tjmp pc_{:x}_fcall_result_done\n", ctx.pc);
            }

            *code += &format!("pc_{:x}_fcall_result_zero:\n", ctx.pc);
            *code +=
                &format!("\tmov {}, 0 {}\n", ctx.mem_free_input, ctx.comment_str("free_input = 0"));
            *code += &format!("pc_{:x}_fcall_result_done:\n", ctx.pc);

            // Update fcall counters
            *code += &format!(
                "\tmov qword {}[{} + {}*8], 0 {}\n",
                ctx.ptr,
                ctx.fcall_ctx,
                FCALL_PARAMS_SIZE,
                ctx.comment_str("ctx.params_size = 0")
            );
            *code += &format!(
                "\tmov qword {}[{} + {}*8], 1 {}\n",
                ctx.ptr,
                ctx.fcall_ctx,
                FCALL_RESULT_GOT,
                ctx.comment_str("ctx.result_got = 1")
            );
        }

        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn fcall_get_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        *code += &ctx.full_line_comment("FcallGet".to_string());

        assert!(ctx.store_b_in_c);

        if !ctx.chunk_player_mt_collect_mem() && !ctx.chunk_player_mem_reads_collect_main() {
            // Get value from fcall_ctx.result[got] and store it in free input address.
            // Reading one value past the result gets 0, and reading further or reading a
            // result of size 0 stops the execution.
            let overflow = Self::error_label(ctx, unusual_code, AsmError::FcallOverflow);
            *code += &format!(
                "\tmov {}, qword {}[{} + {}*8] {}\n",
                REG_AUX,
                ctx.ptr,
                ctx.fcall_ctx,
                FCALL_RESULT_GOT,
                ctx.comment_str("aux = ctx.result_got")
            );
            *code += &format!(
                "\tcmp {}, qword {}[{} + {}*8] {}\n",
                REG_AUX,
                ctx.ptr,
                ctx.fcall_ctx,
                FCALL_RESULT_SIZE,
                ctx.comment_str("aux ? ctx.result_size")
            );
            *code += &format!("\tjae pc_{:x}_fcall_get_beyond_result\n", ctx.pc);
            *code += &format!(
                "\tmov {}, qword {}[{} + {}*8 + {}*8] {}\n",
                REG_VALUE,
                ctx.ptr,
                ctx.fcall_ctx,
                REG_AUX,
                FCALL_RESULT,
                ctx.comment_str("value = ctx.result_got")
            );
            *code += &format!("pc_{:x}_fcall_get_value_done:\n", ctx.pc);
            *unusual_code += &format!("pc_{:x}_fcall_get_beyond_result:\n", ctx.pc);
            *unusual_code += &format!("\tjne {overflow}\n");
            *unusual_code += &format!(
                "\ttest {}, {} {}\n",
                REG_AUX,
                REG_AUX,
                ctx.comment_str("result size == 0 ?")
            );
            *unusual_code += &format!("\tjz {overflow}\n");
            *unusual_code +=
                &format!("\txor {}, {} {}\n", REG_VALUE, REG_VALUE, ctx.comment_str("value = 0"));
            *unusual_code += &format!("\tjmp pc_{:x}_fcall_get_value_done\n", ctx.pc);
            *code += &format!(
                "\tmov {}, {} {}\n",
                ctx.mem_free_input,
                REG_VALUE,
                ctx.comment_str("free_input = value")
            );
            *code += &format!(
                "\tinc qword {}[{} + {}*8] {}\n",
                ctx.ptr,
                ctx.fcall_ctx,
                FCALL_RESULT_GOT,
                ctx.comment_str("inc ctx.result_got")
            );
        }

        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }
}
