//! Bitwise operations: sign extensions, shifts, and, or and xor

use crate::{
    zisk_rom_2_asm::registers::{REG_B, REG_B_B, REG_B_H, REG_B_W, REG_C, REG_VALUE, REG_VALUE_W},
    ZiskAsmContext, ZiskRom2Asm,
};

impl ZiskRom2Asm {
    pub(super) fn signextend_b_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_b_in_b);
        *code += &format!(
            "\tmovsx {}, {} {}\n",
            REG_C,
            REG_B_B,
            ctx.comment_str("SignExtendW: sign extend b(8b) to c(64b)")
        );
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn signextend_h_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_b_in_b);
        *code += &format!(
            "\tmovsx {}, {} {}\n",
            REG_C,
            REG_B_H,
            ctx.comment_str("SignExtendW: sign extend b(16b) to c(64b)")
        );
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn signextend_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_b_in_b);
        *code += &format!(
            "\tmovsxd {}, {} {}\n",
            REG_C,
            REG_B_W,
            ctx.comment_str("SignExtendW: sign extend b(32b) to c(64b)")
        );
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn sll_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        if ctx.b.is_constant {
            *code += &format!(
                "\tshl {}, 0x{:x} {}\n",
                REG_C,
                ctx.b.constant_value & 0x3f,
                ctx.comment_str("Sll: c = a << b")
            );
        } else {
            *code += &format!("\tmov rcx, {} {}\n", REG_B, ctx.comment_str("Sll: c = b"));
            *code +=
                &format!("\tshl {}, cl {}\n", REG_C, ctx.comment_str("Sll: c(value) = a << b"));
        }
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn sll_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_VALUE,
            ctx.a.string_value,
            ctx.comment_str("SllW: value = a")
        );
        *code += &format!("\tmov rcx, {} {}\n", ctx.b.string_value, ctx.comment_str("SllW: c = b"));
        *code +=
            &format!("\tshl {}, cl {}\n", REG_VALUE_W, ctx.comment_str("SllW: value = a << b"));
        *code += &format!(
            "\tmovsxd {}, {} {}\n",
            REG_C,
            REG_VALUE_W,
            ctx.comment_str("SllW: sign extend to quad value -> c")
        );
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn sra_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        *code +=
            &format!("\tmov rcx, {} {}\n", ctx.b.string_value, ctx.comment_str("Sra: rcx = b"));
        *code += &format!("\tsar {}, cl {}\n", REG_C, ctx.comment_str("Sra: c = c >> b(cl)"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn srl_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        if ctx.b.is_constant {
            *code += &format!(
                "\tshr {}, 0x{:x} {}\n",
                REG_C,
                ctx.b.constant_value & 0x3f,
                ctx.comment_str("Srl: c = a >> b")
            );
        } else {
            *code += &format!(
                "\tmov rcx, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("Srl: b = value ")
            );
            *code +=
                &format!("\tshr {}, cl {}\n", REG_C, ctx.comment_str("Srl: c(value) = a >> b"));
        }
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn sra_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        if ctx.b.is_constant {
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_VALUE,
                ctx.a.string_value,
                ctx.comment_str("SraW: c = a")
            );
            *code += &format!(
                "\tsar {}, 0x{:x} {}\n",
                REG_VALUE_W,
                ctx.b.constant_value & 0x3f,
                ctx.comment_str("SraW: c = a >> b")
            );
            *code += &format!(
                "\tmovsxd {}, {} {}\n",
                REG_C,
                REG_VALUE_W,
                ctx.comment_str("SraW: sign extend to quad")
            );
        } else {
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_VALUE,
                ctx.a.string_value,
                ctx.comment_str("SraW: c(value) = a")
            );
            *code += &format!("\tmov rcx, {} {}\n", REG_B, ctx.comment_str("SraW: rcx = b"));
            *code += &format!(
                "\tsar {}, cl {}\n",
                REG_VALUE_W,
                ctx.comment_str("SraW: c(value) = a >> b")
            );
            *code += &format!(
                "\tmovsxd {}, {} {}\n",
                REG_C,
                REG_VALUE_W,
                ctx.comment_str("SraW: sign extend to quad")
            );
        }
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn srl_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        if ctx.b.is_constant {
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_VALUE,
                ctx.a.string_value,
                ctx.comment_str("SrlW: c = a")
            );
            *code += &format!(
                "\tshr {}, 0x{:x} {}\n",
                REG_VALUE_W,
                ctx.b.constant_value & 0x3f,
                ctx.comment_str("SrlW: c = a >> b")
            );
            *code += &format!(
                "\tmovsxd {}, {} {}\n",
                REG_C,
                REG_VALUE_W,
                ctx.comment_str("SrlW: sign extend to quad")
            );
        } else {
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_VALUE,
                ctx.a.string_value,
                ctx.comment_str("SrlW: c = a")
            );
            *code += &format!(
                "\tmov rcx, {} {}\n",
                ctx.b.string_value,
                ctx.comment_str("SrlW: b = value")
            );
            *code += &format!(
                "\tshr {}, cl {}\n",
                REG_VALUE_W,
                ctx.comment_str("SrlW: c(value) = a >> b")
            );
            *code += &format!(
                "\tmovsxd {}, {} {}\n",
                REG_C,
                REG_VALUE_W,
                ctx.comment_str("SlrW: sign extend to quad")
            );
        }
        ctx.c.is_saved = true;
        //s += &format!("\tmov {}, {} {}\n", REG_C, REG_VALUE, ctx.comment_str("SrlW: c = value"));
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn and_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        if ctx.b.is_constant && (ctx.b.constant_value == 0xffffffffffffffff) {
            *code += &ctx.full_line_comment("And: ignoring b since b = f's".to_string());
        } else {
            *code += &format!(
                "\tand {}, {} {}\n",
                REG_C,
                ctx.b.string_value,
                ctx.comment_str("And: c = c AND b = a AND b")
            );
        }
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn or_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        if ctx.b.is_constant && (ctx.b.constant_value == 0) {
            *code += &ctx.full_line_comment("Or: ignoring b since b = 0".to_string());
        } else {
            *code += &format!(
                "\tor {}, {} {}\n",
                REG_C,
                ctx.b.string_value,
                ctx.comment_str("Or: c = c OR b = a OR b")
            );
        }
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn xor_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        if ctx.b.is_constant && (ctx.b.constant_value == 0) {
            *code += &ctx.full_line_comment("Xor: ignoring b since b = 0".to_string());
        } else {
            *code += &format!(
                "\txor {}, {} {}\n",
                REG_C,
                ctx.b.string_value,
                ctx.comment_str("Xor: c = c XOR b = a XOR b")
            );
        }
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }
}
