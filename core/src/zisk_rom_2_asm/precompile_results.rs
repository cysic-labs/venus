//! Precompile results: the results of precompiles and fcalls read from the buffer filled by
//! the host instead of being computed, and the wait for the input data

use super::{
    control_flow::AsmError,
    program::{FCALL_PARAMS, FCALL_RESULT, FCALL_RESULT_LENGTH, FCALL_RESULT_SIZE},
    registers::{REG_ADDRESS, REG_AUX, REG_B, REG_FLAG, REG_VALUE},
};
use crate::{ZiskAsmContext, ZiskRom2Asm, INPUT_ADDR, MAX_INPUT_SIZE};

// const PRECOMPILE_BUFFER_SIZE_IN_BYTES: u64 = 0x100000; // 1MB
const PRECOMPILE_BUFFER_SIZE_IN_BYTES: u64 = 0x400000; // 4MB
const PRECOMPILE_BUFFER_SIZE_IN_U64: u64 = PRECOMPILE_BUFFER_SIZE_IN_BYTES / 8;
const PRECOMPILE_BUFFER_SIZE_U64_MASK: u64 = PRECOMPILE_BUFFER_SIZE_IN_U64 - 1;

impl ZiskRom2Asm {
    // Copies size u64 elements from precompile_results_address to the address in reg_address,
    // and increments precompile_read by size*8
    pub(super) fn precompile_results_array(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
        reg_address: &str,
        size: u64,
    ) {
        // Wait for available precompile results data
        if ctx.call_wait_for_prec_avail() {
            Self::wait_for_prec_avail(ctx, code, unusual_code);
        }

        // Load precompile address and read index
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_ADDRESS,
            ctx.mem_precompile_results_address,
            ctx.comment_str("address = precompile_results_address")
        );
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_AUX,
            ctx.mem_precompile_read_address,
            ctx.comment_str("aux = precompile_read")
        );

        // Loop for all u64-sized elements to read
        for k in 0..size {
            // Take the read index module against the precompile buffer size in u64's
            *code += &format!(
                "\tand {}, 0x{:x} {}\n",
                REG_AUX,
                PRECOMPILE_BUFFER_SIZE_U64_MASK,
                ctx.comment_str("aux &= buffer mask")
            );

            // Copy the ui64 element from precompile_results to the destination address
            *code += &format!(
                "\tmov {}, [{} + {}*8] {}\n",
                REG_VALUE,
                REG_ADDRESS,
                REG_AUX,
                ctx.comment(format!("value = precompile_results[{}]", k))
            );
            *code += &format!(
                "\tmov [{} + {}*8], {} {}\n",
                reg_address,
                k,
                REG_VALUE,
                ctx.comment(format!("addr[{}] = value", k))
            );

            // Increase the register containing the read index
            if k != size - 1 {
                *code += &format!("\tinc {} {}\n", REG_AUX, ctx.comment_str("aux++"));
            }
        }

        // Add the read size to precompile_read
        *code += &format!(
            "\tadd {}, {} {}\n",
            ctx.mem_precompile_read_address,
            size,
            ctx.comment(format!("read += {}", size))
        );
    }

    // Copies 1 u64 element from precompile_results_address to the register reg,
    // and increments precompile_results_address by 8
    pub(super) fn precompile_results_register(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
        reg: &str,
    ) {
        // Wait for available precompile results data
        if ctx.call_wait_for_prec_avail() {
            Self::wait_for_prec_avail(ctx, code, unusual_code);
        }

        // Load precompile address and read index
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_ADDRESS,
            ctx.mem_precompile_results_address,
            ctx.comment_str("address = precompile_results_address")
        );
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_AUX,
            ctx.mem_precompile_read_address,
            ctx.comment_str("aux = precompile_read")
        );

        // Take the read index module against the precompile buffer size in u64's
        *code += &format!(
            "\tand {}, 0x{:x} {}\n",
            REG_AUX,
            PRECOMPILE_BUFFER_SIZE_U64_MASK,
            ctx.comment_str("aux &= buffer mask")
        );
        *code += &format!(
            "\tmov {}, [{} + {}*8] {}\n",
            REG_VALUE,
            REG_ADDRESS,
            REG_AUX,
            ctx.comment_str("value = precompile_results[0]")
        );

        // Copy the ui64 element from precompile_results to the destination address
        *code += &format!(
            "\tmov {}, {} {}\n",
            reg,
            REG_VALUE,
            ctx.comment_str("reg = precompile_results[0]")
        );

        // Increase precompile_read
        *code += &format!(
            "\tinc {} {}\n",
            ctx.mem_precompile_read_address,
            ctx.comment_str("precompile_read++")
        );
    }

    // Copies the fcall result size and result data to the fcall structure
    // address in reg_address,
    pub(super) fn precompile_results_fcall(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
        reg_address: &str,
    ) {
        // Wait for available precompile results data
        if ctx.call_wait_for_prec_avail() {
            Self::wait_for_prec_avail(ctx, code, unusual_code);
        }

        // Load precompile address into REG_AUX
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_AUX,
            ctx.mem_precompile_results_address,
            ctx.comment_str("aux = precompile_results_address")
        );

        // Load the destination fcall address into REG_ADDRESS
        *code += &format!("\tmov {REG_ADDRESS}, {reg_address}\n");

        // Calculate the address of the first precompile u64 value = address + read % buffer_size
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_ADDRESS,
            ctx.mem_precompile_read_address,
            ctx.comment_str("address = precompile_read")
        );
        *code += &format!(
            "\tand {}, 0x{:x} {}\n",
            REG_ADDRESS,
            PRECOMPILE_BUFFER_SIZE_U64_MASK,
            ctx.comment_str("address %= buffer size")
        );

        // Copy the result size (first u64 value) and store it in register B
        *code += &format!(
            "\tmov {}, [{} + {}*8] {}\n",
            REG_B,
            REG_AUX,
            REG_ADDRESS,
            ctx.comment_str("b = precompile_results[0]")
        );
        let overflow = Self::error_label(ctx, unusual_code, AsmError::FcallOverflow);
        *code += &format!(
            "\tcmp {}, 0x{:x} {}\n",
            REG_B,
            FCALL_RESULT_LENGTH,
            ctx.comment_str("b ? result capacity")
        );
        *code += &format!("\tja {overflow}\n");
        *code += &format!(
            "\tmov [{} + {}*8], {} {}\n",
            reg_address,
            FCALL_RESULT_SIZE,
            REG_B,
            ctx.comment_str("fcall[result_size] = b")
        );
        *code += &format!(
            "\tinc {} {}\n",
            ctx.mem_precompile_read_address,
            ctx.comment_str("precompile_read++")
        );

        // Copy data consuming REG_B u64's starting at REG_A=0, increasing REG_A until REG_A == REG_B

        // Initialize REG_A to 0
        *code += &format!("\txor {}, {} {}\n", REG_FLAG, REG_FLAG, ctx.comment_str("flag = 0"));

        // Loop start
        *code += &format!("pc_{:x}_fcall_copy_params_loop_start:\n", ctx.pc);

        // End loop when REG_A == REG_B
        *code += &format!("\tcmp {}, {} {}\n", REG_FLAG, REG_B, ctx.comment_str("flag =? b"));
        *code += &format!("\tje pc_{:x}_fcall_copy_params_loop_end\n", ctx.pc);

        // Calculate the address of the next precompile u64 value = address + read % buffer_size
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_ADDRESS,
            ctx.mem_precompile_read_address,
            ctx.comment_str("address = precompile_read")
        );
        *code += &format!(
            "\tadd {}, {} {}\n",
            REG_ADDRESS,
            REG_FLAG,
            ctx.comment_str("address += flag")
        );
        *code += &format!(
            "\tand {}, 0x{:x} {}\n",
            REG_ADDRESS,
            PRECOMPILE_BUFFER_SIZE_U64_MASK,
            ctx.comment_str("address %= buffer size")
        );

        // Copy value from precompile_results to fcall[result_data + REG_A]
        *code += &format!(
            "\tmov {}, [{} + {}*8] {}\n",
            REG_VALUE,
            REG_AUX,
            REG_ADDRESS,
            ctx.comment_str("value = precompile_results[a]")
        );
        *code += &format!(
            "\tmov [{} + {}*8 + {}*8], {} {}\n",
            reg_address,
            REG_FLAG,
            FCALL_RESULT,
            REG_VALUE,
            ctx.comment_str("addr[] = value")
        );

        // Increment REG_FLAG
        *code += &format!("\tinc {} {}\n", REG_FLAG, ctx.comment_str("flag++"));

        // Jump to loop start
        *code += &format!("\tjmp pc_{:x}_fcall_copy_params_loop_start\n", ctx.pc);

        // Loop end
        *code += &format!("pc_{:x}_fcall_copy_params_loop_end:\n", ctx.pc);

        // Update precompile_read += result_size
        *code += &format!(
            "\tadd {}, {} {}\n",
            ctx.mem_precompile_read_address,
            REG_FLAG,
            ctx.comment_str("precompile_read += fcall_result_size")
        );
    }

    fn wait_for_prec_avail(ctx: &mut ZiskAsmContext, code: &mut String, unusual_code: &mut String) {
        *code += &ctx.full_line_comment("Wait for precompile results available".to_string());

        // if precompile_written == precompile_read then call wait_for_prec_avail
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_AUX,
            ctx.mem_precompile_read_address,
            ctx.comment_str("aux = precompile_read")
        );
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_AUX,
            ctx.mem_precompile_written_address,
            ctx.comment_str("read ?= written")
        );
        *code += &format!(
            "\tjz pc_{:x}_{}_wait_for_prec_avail {}\n",
            ctx.pc,
            ctx.wait_for_prec_counter,
            ctx.comment_str("if there is data, done")
        );
        *code +=
            &format!("pc_{:x}_{}_wait_for_prec_avail_done:\n", ctx.pc, ctx.wait_for_prec_counter);

        // Call wait_for_prec_avail()
        *unusual_code +=
            &format!("pc_{:x}_{}_wait_for_prec_avail:\n", ctx.pc, ctx.wait_for_prec_counter);
        Self::push_internal_registers(ctx, unusual_code, false);
        *unusual_code += "\tcall _wait_for_prec_avail\n";
        *unusual_code += "\tcmp rax, 0\n";
        *unusual_code += "\tjne execute_pop_internal_regs_and_end\n";
        Self::pop_internal_registers(ctx, unusual_code, false);
        *unusual_code += &format!(
            "\tjmp pc_{:x}_{}_wait_for_prec_avail_done\n",
            ctx.pc, ctx.wait_for_prec_counter
        );

        // TODO:
        // else if *precompile_written_address - *precompile_read_address < threshold -> call post_prec_read

        //*code += &format!("pc_{:x}_wait_for_prec_avail_end:\n", ctx.pc,);

        // Increment wait_for_prec_counter
        ctx.wait_for_prec_counter += 1;
    }

    // Waits for the requested reg_address input address (and previous) to be available, waiting
    // if necessary address in reg_address,
    pub(super) fn wait_for_input_ready(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
        //reg_address: &str, // fcall structure address
    ) {
        *code += &ctx.full_line_comment("Wait for input data available".to_string());

        // Calculate number of bytes until the requested address from the current read address
        // required_bytes = (required_address - INPUT_ADDR - 8 + 1 + 7) & ~0x7;
        // + 1 because required_address is the address of the last required byte
        // + 7 & ~0x7 because if we require any byte of the last u64, we need to wait for the whole u64 to be available
        assert!(ctx.a.is_constant);
        *code += &format!(
            "\tmov rdi, qword {}[{} + {}*8] {}\n",
            ctx.ptr,
            ctx.fcall_ctx,
            FCALL_PARAMS,
            ctx.comment_str("rdi = params[0] = required_address")
        );
        *code += &format!(
            "\tmov {}, 0x{:x} {}\n",
            REG_AUX,
            INPUT_ADDR,
            ctx.comment_str("aux = INPUT_ADDRESS")
        );
        *code += &format!(
            "\tsub rdi, {} {}\n",
            REG_AUX,
            ctx.comment_str("rdi = required_address - INPUT_ADDRESS")
        );
        let invalid_address = Self::error_label(ctx, unusual_code, AsmError::InvalidAddress);
        *code += &format!(
            "\tcmp rdi, 0x{:x} {}\n",
            MAX_INPUT_SIZE - 1,
            ctx.comment_str("required address inside the input?")
        );
        *code += &format!("\tjae {invalid_address}\n");
        *code += &format!("\tand rdi, ~0x7 {}\n", ctx.comment_str("rdi &= 0x7"));

        // if input_written == input_ready then call wait_for_input_avail
        *code += &format!(
            "\tcmp rdi, {} {}\n",
            ctx.mem_input_written_address,
            ctx.comment_str("required <= written")
        );
        *code += &format!(
            "\tja pc_{:x}_wait_for_input_avail {}\n",
            ctx.pc,
            ctx.comment_str("if there is data, done")
        );
        *code += &format!("pc_{:x}_wait_for_input_avail_done:\n", ctx.pc);

        // Call wait_for_input_avail()
        *unusual_code += &format!("pc_{:x}_wait_for_input_avail:\n", ctx.pc);
        Self::push_internal_registers(ctx, unusual_code, false);
        *unusual_code += "\tcall _wait_for_input_avail\n";
        *unusual_code += "\tcmp rax, 0\n";
        *unusual_code += "\tjne execute_pop_internal_regs_and_end\n";
        Self::pop_internal_registers(ctx, unusual_code, false);
        *unusual_code += &format!("\tjmp pc_{:x}_wait_for_input_avail_done\n", ctx.pc);
    }
}
