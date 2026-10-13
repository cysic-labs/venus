//! x86-64 registers of the generated code: the registers that hold the ZisK registers and the
//! emulation state, their save and restore around calls to external functions, and the RISC-V
//! registers, mapped to xmm registers or to memory

use crate::{ZiskAsmContext, ZiskRom2Asm};

// Regs rax, rcx, rdx, rdi, rsi, rsp, and r8-r11 are caller-save, not saved across function calls.
// Reg rax is used to store a function’s return value.
// Regs rbx, rbp, and r12-r15 are callee-save, saved across function calls.

// The caller uses registers to pass the first 6 arguments to the callee.
// Given the arguments in left-to-right order, the order of registers used is:
// rdi, rsi, rdx, rcx, r8, and r9.
// Any remaining arguments are passed on the stack in reverse order so that they can be popped off
// the stack in order.

pub(super) const REG_A: &str = "rbx";
pub(super) const REG_A_W: &str = "ebx";
pub(super) const REG_B: &str = "rax";
pub(super) const REG_B_W: &str = "eax";
pub(super) const REG_B_H: &str = "ax";
pub(super) const REG_B_B: &str = "al";
pub(super) const REG_C: &str = "r15";
pub(super) const REG_C_W: &str = "r15d";
pub(super) const REG_C_H: &str = "r15w";
pub(super) const REG_C_B: &str = "r15b";
pub(super) const REG_FLAG: &str = "rdx";
pub(super) const REG_STEP: &str = "r14";
pub(super) const REG_VALUE: &str = "r9";
pub(super) const REG_VALUE_W: &str = "r9d";
//const REG_VALUE_H: &str = "r9w";
//const REG_VALUE_B: &str = "r9b";
pub(super) const REG_ADDRESS: &str = "r10";
pub(super) const REG_MEM_READS_ADDRESS: &str = "r12";
pub(super) const REG_MEM_READS_SIZE: &str = "r13";
pub(super) const REG_AUX: &str = "r11";
pub(super) const REG_PC: &str = "r8";
pub(super) const REG_ACTIVE_CHUNK: &str = "rbp"; // Used only in Zip
pub(super) const REG_CHUNK_PLAYER_ADDRESS: &str = "rbp"; // Used only in chunk player

// not used:
//   - rbp (frame pointer, must be restored before calling other functions),
//   - rcx (overwritten during syscall)
//   - rdi
//   - rsi
//   - rsp

pub(super) const XMM_MAPPED_REGS: [u64; 16] =
    [1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
//const XMM_MAPPED_REGS: [u64; 0] = []; // Used for debugging

impl ZiskRom2Asm {
    /**********************/
    /* REGISTERS PUSH/POP */
    /**********************/

    fn push_xmm_regs(ctx: &mut ZiskAsmContext, code: &mut String, extra_8: bool) {
        *code += &format!(
            "\tsub rsp, 16*16 + {} {}\n",
            if extra_8 { "8" } else { "0" },
            ctx.comment_str("push 16 xmm registers")
        );
        *code += "\tmovaps [rsp + 0*16], xmm0\n";
        *code += "\tmovaps [rsp + 1*16], xmm1\n";
        *code += "\tmovaps [rsp + 2*16], xmm2\n";
        *code += "\tmovaps [rsp + 3*16], xmm3\n";
        *code += "\tmovaps [rsp + 4*16], xmm4\n";
        *code += "\tmovaps [rsp + 5*16], xmm5\n";
        *code += "\tmovaps [rsp + 6*16], xmm6\n";
        *code += "\tmovaps [rsp + 7*16], xmm7\n";
        *code += "\tmovaps [rsp + 8*16], xmm8\n";
        *code += "\tmovaps [rsp + 9*16], xmm9\n";
        *code += "\tmovaps [rsp + 10*16], xmm10\n";
        *code += "\tmovaps [rsp + 11*16], xmm11\n";
        *code += "\tmovaps [rsp + 12*16], xmm12\n";
        *code += "\tmovaps [rsp + 13*16], xmm13\n";
        *code += "\tmovaps [rsp + 14*16], xmm14\n";
        *code += "\tmovaps [rsp + 15*16], xmm15\n";
    }

    fn pop_xmm_regs(ctx: &mut ZiskAsmContext, code: &mut String, extra_8: bool) {
        *code += "\tmovaps xmm0, [rsp + 0*16]\n";
        *code += "\tmovaps xmm1, [rsp + 1*16]\n";
        *code += "\tmovaps xmm2, [rsp + 2*16]\n";
        *code += "\tmovaps xmm3, [rsp + 3*16]\n";
        *code += "\tmovaps xmm4, [rsp + 4*16]\n";
        *code += "\tmovaps xmm5, [rsp + 5*16]\n";
        *code += "\tmovaps xmm6, [rsp + 6*16]\n";
        *code += "\tmovaps xmm7, [rsp + 7*16]\n";
        *code += "\tmovaps xmm8, [rsp + 8*16]\n";
        *code += "\tmovaps xmm9, [rsp + 9*16]\n";
        *code += "\tmovaps xmm10, [rsp + 10*16]\n";
        *code += "\tmovaps xmm11, [rsp + 11*16]\n";
        *code += "\tmovaps xmm12, [rsp + 12*16]\n";
        *code += "\tmovaps xmm13, [rsp + 13*16]\n";
        *code += "\tmovaps xmm14, [rsp + 14*16]\n";
        *code += "\tmovaps xmm15, [rsp + 15*16]\n";
        *code += &format!(
            "\tadd rsp, 16*16 + {} {}\n",
            if extra_8 { "8" } else { "0" },
            ctx.comment_str("pop 16 xmm registers")
        );
    }

    // fn assert_rsp_is_aligned(ctx: &mut ZiskAsmContext, code: &mut String) {
    //     *code += "\ttest rsp, 0xf\n";
    //     *code += &format!("\tjz pc_{:x}_{}_rsp_aligned\n", ctx.pc, ctx.assert_rsp_counter);
    //     *code += "\tint3\n";
    //     *code += &format!("pc_{:x}_{}_rsp_aligned:\n", ctx.pc, ctx.assert_rsp_counter);
    //     ctx.assert_rsp_counter += 1;
    // }

    pub(super) fn push_external_registers(ctx: &mut ZiskAsmContext, code: &mut String) {
        *code += &format!("\tmov {}, rsp {}\n", ctx.mem_rsp, ctx.comment_str("backup rsp"));
        //*code += "\tpush rsp\n";
        *code += "\tpush rbx\n";
        *code += "\tpush rbp\n";
        *code += "\tpush r12\n";
        *code += "\tpush r13\n";
        *code += "\tpush r14\n";
        *code += "\tpush r15\n";
        Self::push_xmm_regs(ctx, code, true);
    }

    pub(super) fn pop_external_registers(ctx: &mut ZiskAsmContext, code: &mut String) {
        Self::pop_xmm_regs(ctx, code, true);
        *code += "\tpop r15\n";
        *code += "\tpop r14\n";
        *code += "\tpop r13\n";
        *code += "\tpop r12\n";
        *code += "\tpop rbp\n";
        *code += "\tpop rbx\n";
        //*code += "\tpop rsp\n";
        *code += &format!("\tmov rsp, {} {}\n", ctx.mem_rsp, ctx.comment_str("restore rsp"));
    }

    pub(super) fn push_internal_registers(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        extra_8: bool,
    ) {
        *code += "\tpush rax\n";
        *code += "\tpush rcx\n";
        *code += "\tpush rdx\n";
        *code += "\tpush rdi\n";
        // *code += "\tpush rsi\n";
        // *code += "\tpush rsp\n";
        *code += "\tpush r8\n";
        *code += "\tpush r9\n";
        *code += "\tpush r10\n";
        *code += "\tpush r11\n";
        Self::push_xmm_regs(ctx, code, extra_8);
    }

    pub(super) fn pop_internal_registers(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        extra_8: bool,
    ) {
        Self::pop_xmm_regs(ctx, code, extra_8);
        *code += "\tpop r11\n";
        *code += "\tpop r10\n";
        *code += "\tpop r9\n";
        *code += "\tpop r8\n";
        // *code += "\tpop rsp\n";
        // *code += "\tpop rsi\n";
        *code += "\tpop rdi\n";
        *code += "\tpop rdx\n";
        *code += "\tpop rcx\n";
        *code += "\tpop rax\n";
    }

    pub(super) fn push_internal_registers_except_c_and_flag(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        extra_8: bool,
    ) {
        *code += "\tpush rax\n";
        *code += "\tpush rcx\n";
        //*code += "\tpush rdi\n";
        // *code += "\tpush rsi\n";
        // *code += "\tpush rsp\n";
        *code += "\tpush r8\n";
        *code += "\tpush r9\n";
        *code += "\tpush r10\n";
        *code += "\tpush r11\n";
        Self::push_xmm_regs(ctx, code, extra_8);
    }

    pub(super) fn pop_internal_registers_except_c_and_flag(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        extra_8: bool,
    ) {
        Self::pop_xmm_regs(ctx, code, extra_8);
        *code += "\tpop r11\n";
        *code += "\tpop r10\n";
        *code += "\tpop r9\n";
        *code += "\tpop r8\n";
        // *code += "\tpop rsp\n";
        // *code += "\tpop rsi\n";
        //*code += "\tpop rdi\n";
        *code += "\tpop rcx\n";
        *code += "\tpop rax\n";
    }

    /*************/
    /* REGISTERS */
    /*************/

    fn reg_to_xmm_index(reg: u64) -> u64 {
        match reg {
            1 => 0,
            2 => 1,
            5 => 2,
            6 => 3,
            7 => 4,
            8 => 5,
            9 => 6,
            10 => 7,
            11 => 8,
            12 => 9,
            13 => 10,
            14 => 11,
            15 => 12,
            16 => 13,
            17 => 14,
            18 => 15,
            _ => {
                panic!("ZiskRom2Asm::reg_to_xmm_index() found invalid source slot={reg}");
            }
        }
    }

    // fn reg_to_rsp_index(reg: u64) -> u64 {
    //     match reg {
    //         0 => 0,
    //         3 => 1,
    //         4 => 2,
    //         19 => 3,
    //         20 => 4,
    //         21 => 5,
    //         22 => 6,
    //         23 => 7,
    //         24 => 8,
    //         25 => 9,
    //         26 => 10,
    //         27 => 11,
    //         28 => 12,
    //         29 => 13,
    //         30 => 14,
    //         31 => 15,
    //         32 => 16,
    //         33 => 17,
    //         34 => 18,
    //         _ => {
    //             panic!("ZiskRom2Asm::reg_to_rsp_index() found invalid source slot={}", reg);
    //         }
    //     }
    // }

    pub(super) fn read_riscv_reg(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        src_slot: u64,
        dest_reg: &str,
        dest_desc: &str,
    ) {
        if XMM_MAPPED_REGS.contains(&src_slot) {
            let xmm_index = Self::reg_to_xmm_index(src_slot);
            *code += &format!(
                "\tmovq {}, xmm{} {}\n",
                dest_reg,
                xmm_index,
                ctx.comment(format!("{dest_desc} = reg[{src_slot}]"))
            );
        } else {
            *code += &format!(
                "\tmov {}, qword {}[reg_{}] {}\n",
                dest_reg,
                ctx.ptr,
                src_slot,
                ctx.comment(format!("{dest_desc} = reg[{src_slot}]"))
            );
        }
    }

    pub(super) fn write_riscv_reg(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        dest_slot: u64,
        src_reg: &str,
        src_desc: &str,
    ) {
        let comment = format!("reg[{dest_slot}]={src_desc}");
        if XMM_MAPPED_REGS.contains(&dest_slot) {
            let xmm_index = Self::reg_to_xmm_index(dest_slot);
            *code += &format!("\tmovq xmm{}, {} {}\n", xmm_index, src_reg, ctx.comment(comment));
        } else {
            *code += &format!(
                "\tmov qword {}[reg_{}], {} {}\n",
                ctx.ptr,
                dest_slot,
                src_reg,
                ctx.comment(comment)
            );
        }
    }

    pub(super) fn write_riscv_reg_constant(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        dest_slot: u64,
        value: u64,
        value_desc: &str,
    ) {
        let comment = format!("reg[{dest_slot}]={value_desc}");
        if XMM_MAPPED_REGS.contains(&dest_slot) {
            let xmm_index = Self::reg_to_xmm_index(dest_slot);
            *code += &format!("\tmov {REG_AUX}, 0x{value:x}\n");

            *code += &format!("\tmovq xmm{}, {} {}\n", xmm_index, REG_AUX, ctx.comment(comment));
        } else {
            *code += &format!("\tmov {REG_AUX}, 0x{value:x}\n");
            *code += &format!(
                "\tmov qword {}[reg_{}], {} {}\n",
                ctx.ptr,
                dest_slot,
                REG_AUX,
                ctx.comment(comment)
            );
        }
    }
}
