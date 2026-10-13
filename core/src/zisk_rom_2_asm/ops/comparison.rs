//! Comparisons: equal, less than, less or equal, minimum and maximum

use crate::{
    zisk_rom_2_asm::registers::{REG_A, REG_A_W, REG_B, REG_B_W, REG_C, REG_C_W, REG_FLAG},
    ZiskAsmContext, ZiskRom2Asm, P2_32,
};

impl ZiskRom2Asm {
    pub(super) fn eq_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_A,
            ctx.b.string_value,
            ctx.comment_str("Eq: a == b ?")
        );
        *code += &format!("\tje pc_{:x}_equal_true\n", ctx.pc);
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        *code += &format!("\txor {}, {} {}\n", REG_FLAG, REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("\tjmp pc_{:x}_equal_done\n", ctx.pc);
        *code += &format!("pc_{:x}_equal_true:\n", ctx.pc);
        *code += &format!("\tmov {}, 1 {}\n", REG_C, ctx.comment_str("c = 1"));
        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("pc_{:x}_equal_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn eq_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        // Make sure a is in REG_A to compare it against b (constant, expression or reg)
        if ctx.a.is_constant {
            *code += &format!(
                "\tmov {}, 0x{:x} {}\n",
                REG_A,
                ctx.a.constant_value & 0xffffffff,
                ctx.comment_str("EqW: a = constant")
            );
        }
        // Compare against b, either as a numeric constant or as a register
        if ctx.b.is_constant {
            *code += &format!(
                "\tcmp {}, 0x{:x} {}\n",
                REG_A_W,
                ctx.b.constant_value & 0xffffffff,
                ctx.comment_str("EqW: a == b ?")
            );
        } else {
            *code +=
                &format!("\tcmp {}, {} {}\n", REG_A_W, REG_B_W, ctx.comment_str("EqW: a == b ?"));
        }
        *code += &format!("\tje pc_{:x}_equal_w_true\n", ctx.pc);
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        *code += &format!("\txor {}, {} {}\n", REG_FLAG, REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("\tjmp pc_{:x}_equal_w_done\n", ctx.pc);
        *code += &format!("pc_{:x}_equal_true:\n", ctx.pc);
        *code += &format!("\tmov {}, 1 {}\n", REG_C, ctx.comment_str("c = 1"));
        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("pc_{:x}_equal_w_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn ltu_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_A,
            ctx.b.string_value,
            ctx.comment_str("Ltu: a == b ?")
        );
        *code += &format!("\tjb pc_{:x}_ltu_true\n", ctx.pc);
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        *code += &format!("\txor {}, {} {}\n", REG_FLAG, REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("\tjmp pc_{:x}_ltu_done\n", ctx.pc);
        *code += &format!("pc_{:x}_ltu_true:\n", ctx.pc);
        *code += &format!("\tmov {}, 1 {}\n", REG_C, ctx.comment_str("c = 1"));
        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("pc_{:x}_ltu_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn lt_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        // If b is constant and too big, move it to its register
        if ctx.b.is_constant && (ctx.b.constant_value >= P2_32) {
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_B,
                ctx.b.string_value,
                ctx.comment_str("Lt: b = constant")
            );
            ctx.b.is_constant = false;
            ctx.b.string_value = REG_B.to_string();
        }
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_A,
            ctx.b.string_value,
            ctx.comment_str("Lt: a == b ?")
        );
        *code += &format!("\tjl pc_{:x}_lt_true\n", ctx.pc);
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        *code += &format!("\txor {}, {} {}\n", REG_FLAG, REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("\tjmp pc_{:x}_lt_done\n", ctx.pc);
        *code += &format!("pc_{:x}_lt_true:\n", ctx.pc);
        *code += &format!("\tmov {}, 1 {}\n", REG_C, ctx.comment_str("c = 1"));
        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("pc_{:x}_lt_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn ltu_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        // Compare against b, either as a numeric constant or as a register
        if ctx.b.is_constant {
            *code += &format!(
                "\tcmp {}, 0x{:x} {}\n",
                REG_A_W,
                ctx.b.constant_value & 0xffffffff,
                ctx.comment_str("LtuW: a == b ?")
            );
        } else {
            *code +=
                &format!("\tcmp {}, {} {}\n", REG_A_W, REG_B_W, ctx.comment_str("LtuW: a == b ?"));
        }
        *code += &format!("\tjb pc_{:x}_ltuw_true\n", ctx.pc);
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        *code += &format!("\txor {}, {} {}\n", REG_FLAG, REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("\tjmp pc_{:x}_ltuw_done\n", ctx.pc);
        *code += &format!("pc_{:x}_ltuw_true:\n", ctx.pc);
        *code += &format!("\tmov {}, 1 {}\n", REG_C, ctx.comment_str("c = 1"));
        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("pc_{:x}_ltuw_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn lt_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        // Compare against b, either as a numeric constant or as a register
        if ctx.b.is_constant {
            *code += &format!(
                "\tcmp {}, 0x{:x} {}\n",
                REG_A_W,
                ctx.b.constant_value & 0xffffffff,
                ctx.comment_str("LtW: a == b ?")
            );
        } else {
            *code +=
                &format!("\tcmp {}, {} {}\n", REG_A_W, REG_B_W, ctx.comment_str("LtW: a == b"));
        }
        *code += &format!("\tjl pc_{:x}_ltw_true\n", ctx.pc);
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        *code += &format!("\txor {}, {} {}\n", REG_FLAG, REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("\tjmp pc_{:x}_ltw_done\n", ctx.pc);
        *code += &format!("pc_{:x}_ltw_true:\n", ctx.pc);
        *code += &format!("\tmov {}, 1 {}\n", REG_C, ctx.comment_str("c = 1"));
        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("pc_{:x}_ltw_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn leu_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        // If b is constant and too big, move it to its register
        if ctx.b.is_constant && (ctx.b.constant_value >= P2_32) {
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_B,
                ctx.b.string_value,
                ctx.comment_str("Leu: b = const_value")
            );
            ctx.b.is_constant = false;
            ctx.b.string_value = REG_B.to_string();
        }
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_A,
            ctx.b.string_value,
            ctx.comment_str("Leu: a == b ?")
        );
        *code += &format!("\tpc_{:x}_jbe leu_true\n", ctx.pc);
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        *code += &format!("\txor {}, {} {}\n", REG_FLAG, REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("\tpc_{:x}_jmp leu_done\n", ctx.pc);
        *code += &format!("pc_{:x}_leu_true:\n", ctx.pc);
        *code += &format!("\tmov {}, 1 {}\n", REG_C, ctx.comment_str("c = 1"));
        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("pc_{:x}_leu_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn le_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        // If b is constant and too big, move it to its register
        if ctx.b.is_constant && (ctx.b.constant_value >= P2_32) {
            *code += &format!(
                "\tmov {}, {} {}\n",
                REG_B,
                ctx.b.string_value,
                ctx.comment_str("Le: b = const_value")
            );
            ctx.b.is_constant = false;
            ctx.b.string_value = REG_B.to_string();
        }
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_A,
            ctx.b.string_value,
            ctx.comment_str("Le: a == b ?")
        );
        *code += &format!("\tjle pc_{:x}_lte_true\n", ctx.pc);
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        *code += &format!("\txor {}, {} {}\n", REG_FLAG, REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("\tjmp pc_{:x}_lte_done\n", ctx.pc);
        *code += &format!("pc_{:x}_lte_true:\n", ctx.pc);
        *code += &format!("\tmov {}, 1 {}\n", REG_C, ctx.comment_str("c = 1"));
        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("pc_{:x}_lte_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn leu_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        // Compare against b, either as a numeric constant or as a register
        if ctx.b.is_constant {
            *code += &format!(
                "\tcmp {}, 0x{:x} {}\n",
                REG_A_W,
                ctx.b.constant_value & 0xffffffff,
                ctx.comment_str("LeuW: a == b ?")
            );
        } else {
            *code +=
                &format!("\tcmp {}, {} {}\n", REG_A_W, REG_B_W, ctx.comment_str("LeuW: a == b ?"));
        }
        *code += &format!("\tjbe pc_{:x}_leuw_true\n", ctx.pc);
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        *code += &format!("\txor {}, {} {}\n", REG_FLAG, REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("\tjmp pc_{:x}_leuw_done\n", ctx.pc);
        *code += &format!("pc_{:x}_leuw_true:\n", ctx.pc);
        *code += &format!("\tmov {}, 1 {}\n", REG_C, ctx.comment_str("c = 1"));
        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("pc_{:x}_leuw_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn le_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        // Compare against b, either as a numeric constant or as a register
        if ctx.b.is_constant {
            *code += &format!(
                "\tcmp {}, 0x{:x} {}\n",
                REG_A_W,
                ctx.b.constant_value & 0xffffffff,
                ctx.comment_str("LeW: a == b ?")
            );
        } else {
            *code +=
                &format!("\tcmp {}, {} {}\n", REG_A_W, REG_B_W, ctx.comment_str("LeW: a == b ?"));
        }
        *code += &format!("\tjle pc_{:x}_lew_true\n", ctx.pc);
        *code += &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("c = 0"));
        *code += &format!("\txor {}, {} {}\n", REG_FLAG, REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("\tjmp pc_{:x}_lew_done\n", ctx.pc);
        *code += &format!("pc_{:x}_lew_true:\n", ctx.pc);
        *code += &format!("\tmov {}, 1 {}\n", REG_C, ctx.comment_str("c = 1"));
        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("pc_{:x}_lew_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn minu_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_C,
            ctx.b.string_value,
            ctx.comment_str("Minu: compare a and b")
        );
        *code += &format!("\tjb pc_{:x}_minu_a_is_below_b\n", ctx.pc);
        *code += &format!("\tmov {}, {} {}\n", REG_C, ctx.b.string_value, ctx.comment_str("c = b"));
        *code += &format!("pc_{:x}_minu_a_is_below_b:\n", ctx.pc);
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn min_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_C,
            ctx.b.string_value,
            ctx.comment_str("Min: compare a and b")
        );
        *code += &format!("\tjl pc_{:x}_min_a_is_below_b\n", ctx.pc);
        *code += &format!("\tmov {}, {} {}\n", REG_C, ctx.b.string_value, ctx.comment_str("c = b"));
        *code += &format!("pc_{:x}_min_a_is_below_b:\n", ctx.pc);
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn minu_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        assert!(ctx.store_b_in_b);
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_C_W,
            REG_B_W,
            ctx.comment_str("MinuW: compare a and b")
        );
        *code += &format!("\tjb pc_{:x}_minuw_a_is_below_b\n", ctx.pc);
        *code += &format!("\tmov {}, {} {}\n", REG_C, REG_B, ctx.comment_str("MinuW: c = b "));
        *code += &format!("pc_{:x}_minuw_a_is_below_b:\n", ctx.pc);
        // The result is the chosen 32-bit value sign-extended, as in op_minu_w
        *code += &format!(
            "\tmovsxd {}, {} {}\n",
            REG_C,
            REG_C_W,
            ctx.comment_str("MinuW: c = sign extend c(32b)")
        );
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn min_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        assert!(ctx.store_b_in_b);
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_C_W,
            REG_B_W,
            ctx.comment_str("MinW: compare a and b")
        );
        *code += &format!("\tjl pc_{:x}_minw_a_is_below_b\n", ctx.pc);
        *code += &format!("\tmov {}, {} {}\n", REG_C, REG_B, ctx.comment_str("MinW: c = b"));
        *code += &format!("pc_{:x}_minw_a_is_below_b:\n", ctx.pc);
        // The result is the chosen 32-bit value sign-extended, as in op_min_w
        *code += &format!(
            "\tmovsxd {}, {} {}\n",
            REG_C,
            REG_C_W,
            ctx.comment_str("MinW: c = sign extend c(32b)")
        );
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn maxu_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_C,
            ctx.b.string_value,
            ctx.comment_str("Maxu: compare a and b")
        );
        *code += &format!("\tja pc_{:x}_maxu_a_is_above_b\n", ctx.pc);
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_C,
            ctx.b.string_value,
            ctx.comment_str("Maxu: c = b")
        );
        *code += &format!("pc_{:x}_maxu_a_is_above_b:\n", ctx.pc);
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn max_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_C,
            ctx.b.string_value,
            ctx.comment_str("Max: compare a and b")
        );
        *code += &format!("\tjg pc_{:x}_max_a_is_above_b\n", ctx.pc);
        *code +=
            &format!("\tmov {}, {} {}\n", REG_C, ctx.b.string_value, ctx.comment_str("Max: c = b"));
        *code += &format!("pc_{:x}_max_a_is_above_b:\n", ctx.pc);
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn maxu_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        assert!(ctx.store_b_in_b);
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_C_W,
            REG_B_W,
            ctx.comment_str("MaxuW: compare a and b")
        );
        *code += &format!("\tja pc_{:x}_maxuw_a_is_above_b\n", ctx.pc);
        *code += &format!("\tmov {}, {} {}\n", REG_C, REG_B, ctx.comment_str("MaxuW: c = b"));
        *code += &format!("pc_{:x}_maxuw_a_is_above_b:\n", ctx.pc);
        // The result is the chosen 32-bit value sign-extended, as in op_maxu_w
        *code += &format!(
            "\tmovsxd {}, {} {}\n",
            REG_C,
            REG_C_W,
            ctx.comment_str("MaxuW: c = sign extend c(32b)")
        );
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn max_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        assert!(ctx.store_b_in_b);
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_C_W,
            REG_B_W,
            ctx.comment_str("MaxW: compare a and b")
        );
        *code += &format!("\tjg pc_{:x}_maxw_a_is_above_b\n", ctx.pc);
        *code += &format!("\tmov {}, {} {}\n", REG_C, REG_B, ctx.comment_str("MaxW: c = b"));
        *code += &format!("pc_{:x}_maxw_a_is_above_b:\n", ctx.pc);
        // The result is the chosen 32-bit value sign-extended, as in op_max_w
        *code += &format!(
            "\tmovsxd {}, {} {}\n",
            REG_C,
            REG_C_W,
            ctx.comment_str("MaxW: c = sign extend c(32b)")
        );
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }
}
