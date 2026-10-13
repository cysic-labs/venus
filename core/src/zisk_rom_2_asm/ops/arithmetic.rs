//! Arithmetic operations: addition, subtraction, multiplication, division and remainder

use crate::{
    zisk_rom_2_asm::registers::{
        REG_A, REG_A_W, REG_B, REG_B_W, REG_C, REG_FLAG, REG_VALUE, REG_VALUE_W,
    },
    ZiskAsmContext, ZiskRom2Asm,
};

impl ZiskRom2Asm {
    pub(super) fn add_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        if ctx.a.is_constant && (ctx.a.constant_value == 0) {
            assert!(ctx.store_b_in_c);
            *code += &ctx.full_line_comment("Add: c = a(0) + b = b".to_string());
        } else if ctx.b.is_constant && (ctx.b.constant_value == 0) {
            assert!(ctx.store_a_in_c);
            *code += &ctx.full_line_comment("Add: c = a + b(0) = a".to_string());
        } else {
            assert!(ctx.store_a_in_c);
            *code += &ctx.full_line_comment("Add: c = a".to_string());
            *code += &format!(
                "\tadd {}, {} {}\n",
                REG_C,
                ctx.b.string_value,
                ctx.comment_str("Add: c = c + b = a + b")
            );
        }
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn add_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_b_in_b);
        // DEBUG: Used only to preserve b value
        // s +=
        //     &format!("\tmov {}, {} {}\n", REG_VALUE, ctx.b.string_value, ctx.comment_str("AddW: value = b"));
        if ctx.a.is_constant && (ctx.a.constant_value == 0) {
            *code += &ctx.full_line_comment("AddW: ignoring a since a = 0".to_string());
        } else {
            *code += &format!(
                "\tadd {}, {} {}\n",
                REG_B,
                ctx.a.string_value,
                ctx.comment_str("AddW: b += a")
            );
        }
        *code += &format!("\tcdqe {}\n", ctx.comment_str("AddW: trunk b"));
        *code += &format!("\tmov {}, {} {}\n", REG_C, REG_B, ctx.comment_str("AddW: c = b"));
        ctx.c.is_saved = true;
        // DEBUG: Used only to preserve b value
        //s += &format!("\tmov {}, {} {}\n", REG_B, REG_VALUE, ctx.comment_str("AddW: b = value"));
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn sub_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_c);
        if ctx.b.is_constant && (ctx.b.constant_value == 0) {
            *code += &ctx.full_line_comment("Sub: ignoring b since b = 0".to_string());
        } else {
            *code += &format!(
                "\tsub {}, {} {}\n",
                REG_C,
                ctx.b.string_value,
                ctx.comment_str("Sub: c = c - b = a - b")
            );
        }
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn sub_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        // DEBUG: Used only to preserve b value
        // s += &format!(
        //     "\tmov {}, {} {}\n",
        //     REG_ADDRESS, ctx.a.string_value,
        //     ctx.commit_str("SubW: address = a")
        // );
        // s +=
        //     &format!("\tmov {}, {} {}\n", REG_VALUE, ctx.b.string_value, ctx.comment_str("SubW: value = b"));
        if ctx.b.is_constant && (ctx.b.constant_value == 0) {
            *code += &ctx.full_line_comment("SubW: ignoring b since b = 0".to_string());
        } else {
            *code += &format!(
                "\tsub {}, {} {}\n",
                REG_A,
                ctx.b.string_value,
                ctx.comment_str("SubW: a -= b")
            );
        }
        *code +=
            &format!("\tmov {}, {} {}\n", REG_B, REG_A, ctx.comment_str("SubW: b = a = a - b"));
        *code += &format!("\tcdqe {}\n", ctx.comment_str("SubW: trunk b"));
        *code += &format!("\tmov {}, {} {}\n", REG_C, REG_B, ctx.comment_str("SubW: c = b"));
        ctx.c.is_saved = true;
        // DEBUG: Used only to preserver a,b values
        // s += &format!("\tmov {}, {} {}\n", REG_A, REG_ADDRESS, ctx.comment_str("SubW: a = address"));
        // s += &format!("\tmov {}, {} {}\n", REG_B, REG_VALUE, ctx.comment_str("SubW: b = value"));
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn mulu_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        assert!(ctx.store_b_in_b);
        // RDX:RAX := RAX ∗ r/m64
        *code += &format!("\tmul {} {}\n", REG_A, ctx.comment_str("Mulu: rax*reg -> rdx:rax"));
        *code += &format!("\tmov {}, rax {}\n", REG_C, ctx.comment_str("Mulu: c = result(rax)"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn muluh_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        assert!(ctx.store_b_in_b);
        // RDX:RAX := RAX ∗ r/m64
        *code += &format!("\tmul {} {}\n", REG_A, ctx.comment_str("Muluh: rax*reg -> rdx:rax"));
        *code +=
            &format!("\tmov {}, rdx {}\n", REG_C, ctx.comment_str("Muluh: c = high result(rdx)"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn mulsuh_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        assert!(ctx.store_b_in_b);
        // RDX:RAX := RAX ∗ r/m64
        *code += &format!("\tmov rsi, {} {}\n", REG_B, ctx.comment_str("Mulsuh: rsi = b"));
        *code += &format!("\tmov rax, {} {}\n", REG_A, ctx.comment_str("Mulsuh: rax = a"));
        *code += &format!("\tmov {}, rax {}\n", REG_VALUE, ctx.comment_str("Mulsuh: value = a"));
        *code += &format!(
            "\tsar {}, 63 {}\n",
            REG_VALUE,
            ctx.comment_str("Mulsuh: value = a>>63 = a_bit_63")
        );
        *code += &format!("\tmov rdx, 0 {}\n", ctx.comment_str("Mulsuh: rdx=0, rdx:rax=a"));
        *code += &format!("\tmul rsi {}\n", ctx.comment_str("Mulsuh: rdx:rax = a*b (unsigned)"));
        *code += &format!("\tmov rcx, rax {}\n", ctx.comment_str("Mulsuh: rax = a"));
        *code +=
            &format!("\tmov rax, {} {}\n", REG_VALUE, ctx.comment_str("Mulsuh: rax = a_bit_63"));
        *code +=
            &format!("\timul rax, rsi {}\n", ctx.comment_str("Mulsuh: rax = rax*b = a_bit_63*b"));
        *code += &format!("\tadd rdx, rax {}\n", ctx.comment_str("Mulsuh: rdx=rdx+a_bit_63*b"));
        *code +=
            &format!("\tmov {}, rdx {}\n", REG_C, ctx.comment_str("Mulsuh: c = high result(rdx)"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn mul_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        assert!(ctx.store_b_in_b);
        // RDX:RAX := RAX ∗ r/m64
        *code += &format!("\timul {} {}\n", REG_A, ctx.comment_str("Mul: rax*reg -> rdx:rax"));
        *code += &format!("\tmov {}, rax {}\n", REG_C, ctx.comment_str("Mul: c = result(rax)"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn mulh_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        assert!(ctx.store_b_in_b);
        // RDX:RAX := RAX ∗ r/m64
        *code += &format!("\timul {} {}\n", REG_A, ctx.comment_str("Mulh: rax*reg -> rdx:rax"));
        *code +=
            &format!("\tmov {}, rdx {}\n", REG_C, ctx.comment_str("Mulh: c = high result(rdx)"));
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn mul_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        assert!(ctx.store_b_in_b);
        // RDX:RAX := RAX ∗ r/m64
        *code += &format!("\tmul {} {}\n", REG_A_W, ctx.comment_str("MulW: rax*reg -> rdx:rax"));
        *code += &format!(
            "\tmovsxd {}, {} {}\n",
            REG_C,
            REG_B_W,
            ctx.comment_str("MulW: sign extend to quad")
        );
        ctx.c.is_saved = true;
        ctx.flag_is_always_zero = true;
    }

    pub(super) fn divu_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_b_in_b);
        // Unsigned divide RDX:RAX by r/m64, with result stored in RAX := Quotient, RDX :=
        // Remainder
        // If b==0 return 0xffffffffffffffff
        *code += &format!("\tcmp {}, 0 {}\n", REG_B, ctx.comment_str("Divu: if b == 0 return f's"));
        *code += &format!(
            "\tjne pc_{:x}_divu_b_is_not_zero {}\n",
            ctx.pc,
            ctx.comment_str("Divu: if b is not zero, divide")
        );
        *code += &format!(
            "\tmov {}, 0xffffffffffffffff {}\n",
            REG_C,
            ctx.comment_str("Divu: set result to f's")
        );
        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("\tjmp pc_{:x}_divu_done\n", ctx.pc);
        *code += &format!("pc_{:x}_divu_b_is_not_zero:\n", ctx.pc);

        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_VALUE,
            REG_B,
            ctx.comment_str("Divu: value = b backup")
        );
        *code += &format!("\tmov rdx, 0 {}\n", ctx.comment_str("Divu: rdx = 0"));
        *code +=
            &format!("\tmov rax, {} {}\n", ctx.a.string_value, ctx.comment_str("Divu: rax = a"));
        *code += &format!(
            "\tdiv {} {}\n",
            REG_VALUE,
            ctx.comment_str("Divu: rdx:rax / value(b backup) -> rax (rdx remainder)")
        );
        *code += &format!("\tmov {}, rax {}\n", REG_C, ctx.comment_str("Divu: c = quotient(rax)"));
        *code += &format!("\tmov {}, 0 {}\n", REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("pc_{:x}_divu_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn remu_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_b_in_b);
        // Unsigned divide RDX:RAX by r/m64, with result stored in RAX := Quotient, RDX :=
        // Remainder
        // If b==0 return a
        *code += &format!("\tcmp {}, 0 {}\n", REG_B, ctx.comment_str("Remu: if b == 0 return a"));
        *code += &format!(
            "\tjne pc_{:x}_remu_b_is_not_zero {}\n",
            ctx.pc,
            ctx.comment_str("Remu: if b is not zero, divide")
        );
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_C,
            ctx.a.string_value,
            ctx.comment_str("Remu: set result to f's")
        );
        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("\tjmp pc_{:x}_remu_done\n", ctx.pc);
        *code += &format!("pc_{:x}_remu_b_is_not_zero:\n", ctx.pc);

        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_VALUE,
            REG_B,
            ctx.comment_str("Remu: value = b backup")
        );
        *code += &format!("\tmov rdx, 0 {}\n", ctx.comment_str("Remu: rdx = 0"));
        *code +=
            &format!("\tmov rax, {} {}\n", ctx.a.string_value, ctx.comment_str("Remu: rax = a"));
        *code += &format!(
            "\tdiv {} {}\n",
            REG_VALUE,
            ctx.comment_str("Remu: rdx:rax / value(b backup) -> rax (rdx remainder)")
        );
        *code += &format!("\tmov {}, rdx {}\n", REG_C, ctx.comment_str("Remu: c = remainder(rdx)"));
        *code += &format!("\tmov {}, 0 {}\n", REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("pc_{:x}_remu_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn div_to_asm(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        assert!(ctx.store_a_in_a);
        assert!(ctx.store_b_in_b);
        // If b=0 (divide by zero) it sets c to 2^64 - 1, and sets flag to true.
        // If a=0x8000000000000000 (MIN_I64) and b=0xFFFFFFFFFFFFFFFF (-1) the result should
        // be -MIN_I64, which cannot be represented with 64 bits (overflow)
        // and it returns c=a.

        // Unsigned divide RDX:RAX by r/m64, with result stored in RAX := Quotient, RDX :=
        // Remainder

        // Check divide by zero:
        // If b==0 return 0xffffffffffffffff
        *code += &format!("\tcmp {}, 0 {}\n", REG_B, ctx.comment_str("Div: if b == 0 return f's"));
        *code += &format!(
            "\tje pc_{:x}_div_by_zero {}\n",
            ctx.pc,
            ctx.comment_str("Div: if b is zero, jump")
        );
        *unusual_code += &format!("pc_{:x}_div_by_zero:\n", ctx.pc);
        *unusual_code += &format!(
            "\tmov {}, 0xffffffffffffffff {}\n",
            REG_C,
            ctx.comment_str("Div: set result to f's")
        );

        *unusual_code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *unusual_code += &format!("\tjmp pc_{:x}_div_done\n", ctx.pc);

        // Check underflow:
        // If a==0x8000000000000000 && b==0xffffffffffffffff then c=a
        *code += &format!(
            "\tmov {}, 0x8000000000000000 {}\n",
            REG_VALUE,
            ctx.comment_str("Div: value == 0x8000000000000000")
        );
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_A,
            REG_VALUE,
            ctx.comment_str("Div: if a == value(0x8000000000000000), then check b")
        );
        *code += &format!(
            "\tjne pc_{:x}_div_divide {}\n",
            ctx.pc,
            ctx.comment_str("Div: if a is not 0x8000000000000000, then divide")
        );
        *code += &format!(
            "\tmov {}, 0xffffffffffffffff {}\n",
            REG_VALUE,
            ctx.comment_str("Div: value == 0xffffffffffffffff")
        );
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_B,
            REG_VALUE,
            ctx.comment_str("Div: if b == 0xffffffffffffffff, then return a")
        );
        *code += &format!(
            "\tjne pc_{:x}_div_divide {}\n",
            ctx.pc,
            ctx.comment_str("Div: if b is not 0xffffffffffffffff, divide")
        );
        *code +=
            &format!("\tmov {}, {} {}\n", REG_C, REG_A, ctx.comment_str("Div: set result to a"));

        *code += &format!("\tmov {}, 0 {}\n", REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("\tjmp pc_{:x}_div_done\n", ctx.pc);

        // Divide
        *code += &format!("pc_{:x}_div_divide:\n", ctx.pc);
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_VALUE,
            REG_B,
            ctx.comment_str("Div: value = b backup")
        );
        *code += &format!("\tmov rax, {} {}\n", REG_A, ctx.comment_str("Div: rax = a"));
        *code += &format!("\tbt rax, 63 {}\n", ctx.comment_str("Div: is a negative?"));
        *code += &format!("\tjnc pc_{:x}_a_is_positive\n", ctx.pc);
        *code += &format!(
            "\tmov rdx, 0xffffffffffffffff {}\n",
            ctx.comment_str("Div: a is negative, rdx = f's")
        );
        *code += &format!("\tjmp pc_{:x}_a_done\n", ctx.pc);
        *code += &format!("pc_{:x}_a_is_positive:\n", ctx.pc);
        *code += &format!("\tmov rdx, 0 {}\n", ctx.comment_str("Div: a is positive, rdx = 0"));
        *code += &format!("pc_{:x}_a_done:\n", ctx.pc);

        *code += &format!(
            "\tidiv {} {}\n",
            REG_VALUE,
            ctx.comment_str("Div: rdx:rax / value(b backup) -> rax (rdx remainder)")
        );
        *code += &format!("\tmov {}, rax {}\n", REG_C, ctx.comment_str("Div: c = quotient(rax)"));
        *code += &format!("\tmov {}, 0 {}\n", REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("pc_{:x}_div_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn rem_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        assert!(ctx.store_b_in_b);
        // If b=0 (divide by zero) it sets c to 2^64 - 1, and sets flag to true.
        // If a=0x8000000000000000 (MIN_I64) and b=0xFFFFFFFFFFFFFFFF (-1) the result should
        // be -MIN_I64, which cannot be represented with 64 bits (overflow)
        // and it returns c=a.

        // Unsigned divide RDX:RAX by r/m64, with result stored in RAX := Quotient, RDX :=
        // Remainder

        // Check divide by zero:
        // If b==0 return 0xffffffffffffffff
        *code += &format!("\tcmp {}, 0 {}\n", REG_B, ctx.comment_str("Rem: if b == 0 return f's"));
        *code += &format!(
            "\tjne pc_{:x}_rem_check_underflow {}\n",
            ctx.pc,
            ctx.comment_str("Rem: if b is not zero, check underflow")
        );
        *code +=
            &format!("\tmov {}, {} {}\n", REG_C, REG_A, ctx.comment_str("Rem: set result to a"));

        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("\tjmp pc_{:x}_rem_done\n", ctx.pc);

        // Check underflow:
        *code += &format!("pc_{:x}_rem_check_underflow:\n", ctx.pc);
        // If a==0x8000000000000000 && b==0xffffffffffffffff then c=a
        *code += &format!(
            "\tmov {}, 0x8000000000000000 {}\n",
            REG_VALUE,
            ctx.comment_str("Rem: value == 0x8000000000000000")
        );
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_A,
            REG_VALUE,
            ctx.comment_str("Rem: if a == value(0x8000000000000000), then check b")
        );
        *code += &format!(
            "\tjne pc_{:x}_rem_divide {}\n",
            ctx.pc,
            ctx.comment_str("Rem: if a is not 0x8000000000000000, then divide")
        );
        *code += &format!(
            "\tmov {}, 0xffffffffffffffff {}\n",
            REG_VALUE,
            ctx.comment_str("Rem: value == 0xffffffffffffffff")
        );
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_B,
            REG_VALUE,
            ctx.comment_str("Rem: if b == 0xffffffffffffffff, then return a")
        );
        *code += &format!(
            "\tjne pc_{:x}_rem_divide {}\n",
            ctx.pc,
            ctx.comment_str("Rem: if b is not 0xffffffffffffffff, divide")
        );
        *code +=
            &format!("\txor {}, {} {}\n", REG_C, REG_C, ctx.comment_str("Rem: set result to 0"));

        *code += &format!("\tmov {}, 0 {}\n", REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("\tjmp pc_{:x}_rem_done\n", ctx.pc);

        // Divide
        *code += &format!("pc_{:x}_rem_divide:\n", ctx.pc);
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_VALUE,
            REG_B,
            ctx.comment_str("Rem: value = b backup")
        );
        *code += &format!("\tmov rax, {} {}\n", REG_A, ctx.comment_str("Rem: rax = a"));
        *code += &format!("\tbt rax, 63 {}\n", ctx.comment_str("Rem: is a negative?"));
        *code += &format!("\tjnc pc_{:x}_a_is_positive\n", ctx.pc);
        *code += &format!(
            "\tmov rdx, 0xffffffffffffffff {}\n",
            ctx.comment_str("Rem: a is negative, rdx = f's")
        );
        *code += &format!("\tjmp pc_{:x}_a_done\n", ctx.pc);
        *code += &format!("pc_{:x}_a_is_positive:\n", ctx.pc);
        *code += &format!("\tmov rdx, 0 {}\n", ctx.comment_str("Rem: a is positive, rdx = 0"));
        *code += &format!("pc_{:x}_a_done:\n", ctx.pc);

        *code += &format!(
            "\tidiv {} {}\n",
            REG_VALUE,
            ctx.comment_str("Rem: rdx:rax / value(b backup) -> rax (rdx remainder)")
        );
        *code += &format!("\tmov {}, rdx {}\n", REG_C, ctx.comment_str("Rem: c = remainder(rdx)"));
        *code += &format!("\tmov {}, 0 {}\n", REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("pc_{:x}_rem_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn divu_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        assert!(ctx.store_b_in_b);
        *code += &format!(
            "\tcmp {}, 0 {}\n",
            REG_B_W,
            ctx.comment_str("DivuW: if b==0 then return all f's")
        );
        *code += &format!(
            "\tjne pc_{:x}_divuw_b_is_not_zero {}\n",
            ctx.pc,
            ctx.comment_str("DivuW: if b is not zero, divide")
        );
        *code += &format!(
            "\tmov {}, 0xffffffffffffffff {}\n",
            REG_C,
            ctx.comment_str("DivuW: set result to f's")
        );
        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("\tjmp pc_{:x}_divuw_done\n", ctx.pc);
        *code += &format!("pc_{:x}_divuw_b_is_not_zero:\n", ctx.pc);

        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_VALUE_W,
            REG_B_W,
            ctx.comment_str("DivuW: value = b backup")
        );
        *code += &format!("\tmov rdx, 0 {}\n", ctx.comment_str("DivuW: rdx = 0"));
        *code += &format!("\tmov eax, {} {}\n", REG_A_W, ctx.comment_str("DivuW: rax = a"));
        *code += &format!(
            "\tdiv {} {}\n",
            REG_VALUE_W,
            ctx.comment_str("DivuW: rdx:rax / value(b backup) -> rax (rdx remainder)")
        );
        *code += &format!(
            "\tmovsxd {}, eax {}\n",
            REG_C,
            ctx.comment_str("DivuW: sign extend 32 to 64 bits")
        );
        *code += &format!("\tmov {}, 0 {}\n", REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("pc_{:x}_divuw_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn remu_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        assert!(ctx.store_b_in_b);
        *code +=
            &format!("\tcmp {}, 0 {}\n", REG_B_W, ctx.comment_str("RemuW: if b==0 then return a"));
        *code += &format!("\tjne pc_{:x}_remuw_b_is_not_zero\n", ctx.pc);
        *code += &format!(
            "\tmovsxd {}, {} {}\n",
            REG_C,
            REG_A_W,
            ctx.comment_str("RemuW: return a, sign extend 32 to 64 bits")
        );
        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("\tjmp pc_{:x}_remuw_done\n", ctx.pc);
        *code += &format!("pc_{:x}_remuw_b_is_not_zero:\n", ctx.pc);

        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_VALUE_W,
            REG_B_W,
            ctx.comment_str("RemuW: value = b backup")
        );
        *code += &format!("\tmov rdx, 0 {}\n", ctx.comment_str("RemuW: rdx = 0"));
        *code += &format!("\tmov eax, {} {}\n", REG_A_W, ctx.comment_str("RemuW: rax = a"));
        *code += &format!(
            "\tdiv {} {}\n",
            REG_VALUE_W,
            ctx.comment_str("RemuW: rdx:rax / value(b backup) -> rax (rdx remainder)")
        );
        *code += &format!(
            "\tmovsxd {}, edx {}\n",
            REG_C,
            ctx.comment_str("RemuW: sign extend 32 to 64 bits")
        );
        *code += &format!("\tmov {}, 0 {}\n", REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("pc_{:x}_remuw_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn div_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        assert!(ctx.store_b_in_b);
        // If b=0 (divide by zero) it sets c to 2^64 - 1, and sets flag to true.
        // Unsigned divide RDX:RAX by r/m64, with result stored in RAX := Quotient, RDX :=
        // Remainder

        // Check divide by zero:
        // If b==0 return 0xffffffffffffffff
        *code +=
            &format!("\tcmp {}, 0 {}\n", REG_B_W, ctx.comment_str("DivW: if b == 0 return f's"));
        *code += &format!(
            "\tjne pc_{:x}_divw_divide {}\n",
            ctx.pc,
            ctx.comment_str("DivW: if b is not zero, divide")
        );
        *code += &format!(
            "\tmov {}, 0xffffffffffffffff {}\n",
            REG_C,
            ctx.comment_str("DivW: set result to f's")
        );

        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("\tjmp pc_{:x}_divw_done\n", ctx.pc);

        // Check overflow: INT32_MIN / -1 returns INT32_MIN sign-extended, and must not
        // execute x86 idiv, which faults on it.
        *code += &format!("pc_{:x}_divw_divide:\n", ctx.pc);
        *code += &format!(
            "\tmov {}, 0x80000000 {}\n",
            REG_VALUE_W,
            ctx.comment_str("DivW: value == 0x80000000")
        );
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_A_W,
            REG_VALUE_W,
            ctx.comment_str("DivW: if a == 0x80000000, then check b")
        );
        *code += &format!(
            "\tjne pc_{:x}_divw_do_divide {}\n",
            ctx.pc,
            ctx.comment_str("DivW: if a is not 0x80000000, divide")
        );
        *code += &format!(
            "\tmov {}, 0xffffffff {}\n",
            REG_VALUE_W,
            ctx.comment_str("DivW: value == 0xffffffff")
        );
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_B_W,
            REG_VALUE_W,
            ctx.comment_str("DivW: if b == 0xffffffff, return a")
        );
        *code += &format!(
            "\tjne pc_{:x}_divw_do_divide {}\n",
            ctx.pc,
            ctx.comment_str("DivW: if b is not 0xffffffff, divide")
        );
        *code += &format!(
            "\tmovsxd {}, {} {}\n",
            REG_C,
            REG_A_W,
            ctx.comment_str("DivW: overflow result is sign-extended a")
        );
        *code += &format!("\tmov {}, 0 {}\n", REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("\tjmp pc_{:x}_divw_done\n", ctx.pc);

        // Divide
        *code += &format!("pc_{:x}_divw_do_divide:\n", ctx.pc);
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_VALUE_W,
            REG_B_W,
            ctx.comment_str("DivW: value = b backup")
        );
        *code += &format!("\tmov eax, {} {}\n", REG_A_W, ctx.comment_str("DivW: rax = a"));
        *code += &format!("\tcdq {}\n", ctx.comment_str("DivW: EDX:EAX := sign-extend of EAX"));
        *code += &format!(
            "\tidiv {} {}\n",
            REG_VALUE_W,
            ctx.comment_str("DivW: edx:eax / value(b backup) -> eax (edx remainder)")
        );
        *code +=
            &format!("\tmovsx {}, eax {}\n", REG_C, ctx.comment_str("DivW: c = quotient(rax)"));
        *code += &format!("\tmov {}, 0 {}\n", REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("pc_{:x}_divw_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }

    pub(super) fn rem_w_to_asm(ctx: &mut ZiskAsmContext, code: &mut String) {
        assert!(ctx.store_a_in_a);
        assert!(ctx.store_b_in_b);
        // If b=0 (divide by zero) it sets c to 2^64 - 1, and sets flag to true.
        // Unsigned divide RDX:RAX by r/m64, with result stored in RAX := Quotient, RDX :=
        // Remainder.

        // Check divide by zero:
        // If b==0 return a
        *code +=
            &format!("\tcmp {}, 0 {}\n", REG_B_W, ctx.comment_str("RemW: if b == 0 return f's"));
        *code += &format!(
            "\tjne pc_{:x}_remw_divide {}\n",
            ctx.pc,
            ctx.comment_str("RemW: if b is not zero, divide")
        );
        *code += &format!(
            "\tmovsx {}, {} {}\n",
            REG_C,
            REG_A_W,
            ctx.comment_str("RemW: set result to a")
        );

        *code += &format!("\tmov {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag = 1"));
        *code += &format!("\tjmp pc_{:x}_remw_done\n", ctx.pc);

        // Check overflow: INT32_MIN % -1 returns 0, and must not execute x86 idiv, which
        // faults on it.
        *code += &format!("pc_{:x}_remw_divide:\n", ctx.pc);
        *code += &format!(
            "\tmov {}, 0x80000000 {}\n",
            REG_VALUE_W,
            ctx.comment_str("RemW: value == 0x80000000")
        );
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_A_W,
            REG_VALUE_W,
            ctx.comment_str("RemW: if a == 0x80000000, then check b")
        );
        *code += &format!(
            "\tjne pc_{:x}_remw_do_divide {}\n",
            ctx.pc,
            ctx.comment_str("RemW: if a is not 0x80000000, divide")
        );
        *code += &format!(
            "\tmov {}, 0xffffffff {}\n",
            REG_VALUE_W,
            ctx.comment_str("RemW: value == 0xffffffff")
        );
        *code += &format!(
            "\tcmp {}, {} {}\n",
            REG_B_W,
            REG_VALUE_W,
            ctx.comment_str("RemW: if b == 0xffffffff, return zero")
        );
        *code += &format!(
            "\tjne pc_{:x}_remw_do_divide {}\n",
            ctx.pc,
            ctx.comment_str("RemW: if b is not 0xffffffff, divide")
        );
        *code += &format!(
            "\txor {}, {} {}\n",
            REG_C,
            REG_C,
            ctx.comment_str("RemW: overflow remainder is zero")
        );
        *code += &format!("\tmov {}, 0 {}\n", REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("\tjmp pc_{:x}_remw_done\n", ctx.pc);

        // Divide
        *code += &format!("pc_{:x}_remw_do_divide:\n", ctx.pc);
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_VALUE_W,
            REG_B_W,
            ctx.comment_str("RemW: value = b backup ")
        );
        *code += &format!("\tmov eax, {} {}\n", REG_A_W, ctx.comment_str("RemW: rax = a"));
        *code += &format!("\tcdq {}\n", ctx.comment_str("RemW: EDX:EAX := sign-extend of EAX"));
        *code += &format!(
            "\tidiv {} {}\n",
            REG_VALUE_W,
            ctx.comment_str("RemW: edx:eax / value(b backup) -> eax (edx remainder)")
        );
        *code +=
            &format!("\tmovsx {}, edx {}\n", REG_C, ctx.comment_str("RemW: c = remainder(edx)"));
        *code += &format!("\tmov {}, 0 {}\n", REG_FLAG, ctx.comment_str("flag = 0"));
        *code += &format!("pc_{:x}_remw_done:\n", ctx.pc);
        ctx.c.is_saved = true;
    }
}
