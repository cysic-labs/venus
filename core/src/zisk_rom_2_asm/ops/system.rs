//! System operations: flag, copyb, pubout and halt

use crate::{
    zisk_rom_2_asm::{
        control_flow::AsmError,
        registers::{REG_AUX, REG_C},
    },
    ZiskAsmContext, ZiskRom2Asm,
};

impl ZiskRom2Asm {
    pub(super) fn flag_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("Flag: c = 0"));
        ctx.c.is_constant = true;
        ctx.c.constant_value = 0;
        ctx.c.string_value = "0".to_string();
        ctx.c.is_saved = true;
        ctx.flag_is_always_one = true;
    }

    pub(super) fn copyb_to_asm(ctx: &mut ZiskAsmContext) {
        assert!(ctx.store_b_in_c);
        ctx.c.is_constant = ctx.b.is_constant;
        ctx.c.constant_value = ctx.b.constant_value;
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn pubout_to_asm(ctx: &mut ZiskAsmContext) {
        assert!(ctx.store_b_in_c);
        ctx.c.is_constant = ctx.b.is_constant;
        ctx.c.constant_value = ctx.b.constant_value;
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn halt_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        *code += &format!(
            "\tmov {}, {} {}\n",
            ctx.mem_error,
            AsmError::Halt as u64,
            ctx.comment_str("halt: error = halt")
        );
        *code += &format!("\tmov {}, 0x{:x} {}\n", REG_AUX, ctx.pc, ctx.comment_str("aux = pc"));
        *code += &format!(
            "\tmov {}, {} {}\n",
            ctx.mem_error_pc,
            REG_AUX,
            ctx.comment_str("error pc = pc")
        );
        ctx.c.is_constant = true;
        ctx.c.constant_value = 0;
        ctx.c.string_value = "0".to_string();
        ctx.c.is_saved = true;
        ctx.flag_is_always_one = true;
    }
}
