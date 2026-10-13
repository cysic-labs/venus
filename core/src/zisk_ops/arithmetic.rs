//! Arithmetic operations: addition, subtraction, multiplication, division and remainder

use std::num::Wrapping;

use crate::{InstContext, M64};

/* ADD AND SUB operations for different data widths (i32 and u64) */

/// Adds a and b as 64-bit unsigned values, and stores the result in c (and sets flag to false)
#[inline(always)]
pub fn op_add(a: u64, b: u64) -> (u64, bool) {
    ((Wrapping(a) + Wrapping(b)).0, false)
}

/// InstContext-based wrapper over op_add()
#[inline(always)]
pub fn opc_add(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_add(ctx.a, ctx.b);
}

/// Adds a and b as 32-bit signed values, and stores the result in c (and flag to false)
#[inline(always)]
pub fn op_add_w(a: u64, b: u64) -> (u64, bool) {
    ((Wrapping(a as i32) + Wrapping(b as i32)).0 as u64, false)
}

/// InstContext-based wrapper over op_add_w()
#[inline(always)]
pub fn opc_add_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_add_w(ctx.a, ctx.b);
}

/// Subtracts a and b as 64-bit unsigned values, and stores the result in c (and sets flag to false)
#[inline(always)]
pub fn op_sub(a: u64, b: u64) -> (u64, bool) {
    ((Wrapping(a) - Wrapping(b)).0, false)
}

/// InstContext-based wrapper over op_sub()
#[inline(always)]
pub fn opc_sub(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_sub(ctx.a, ctx.b);
}

/// Subtracts a and b as 32-bit signed values, and stores the result in c (and sets flag to false)
#[inline(always)]
pub fn op_sub_w(a: u64, b: u64) -> (u64, bool) {
    ((Wrapping(a as i32) - Wrapping(b as i32)).0 as u64, false)
}

/// InstContext-based wrapper over op_sub_w()
#[inline(always)]
pub fn opc_sub_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_sub_w(ctx.a, ctx.b);
}

/* ARITHMETIC operations: div / mul / rem */

/// Sets c to a x b, as 64-bits unsigned values, and flag to false
#[inline(always)]
pub fn op_mulu(a: u64, b: u64) -> (u64, bool) {
    ((Wrapping(a) * Wrapping(b)).0, false)
}

/// InstContext-based wrapper over op_mulu()
#[inline(always)]
pub fn opc_mulu(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_mulu(ctx.a, ctx.b);
}

/// Sets c to a x b, as 64-bits signed values, and flag to false
#[inline(always)]
pub fn op_mul(a: u64, b: u64) -> (u64, bool) {
    ((Wrapping(a as i64) * Wrapping(b as i64)).0 as u64, false)
}

/// InstContext-based wrapper over op_mul()
#[inline(always)]
pub fn opc_mul(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_mul(ctx.a, ctx.b);
}

/// Sets c to a x b, as 32-bits signed values, and flag to false
#[inline(always)]
pub fn op_mul_w(a: u64, b: u64) -> (u64, bool) {
    ((Wrapping(a as i32) * Wrapping(b as i32)).0 as u64, false)
}

/// InstContext-based wrapper over op_mul_w()
#[inline(always)]
pub fn opc_mul_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_mul_w(ctx.a, ctx.b);
}

/// Sets c to the highest 64-bits of a x b, as 128-bits unsigned values, and flag to false
#[inline(always)]
pub const fn op_muluh(a: u64, b: u64) -> (u64, bool) {
    (((a as u128 * b as u128) >> 64) as u64, false)
}

/// InstContext-based wrapper over op_muluh()
#[inline(always)]
pub fn opc_muluh(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_muluh(ctx.a, ctx.b);
}

/// Sets c to the highest 64-bits of a x b, as 128-bits unsigned values, and flag to false
#[inline(always)]
pub const fn op_mulh(a: u64, b: u64) -> (u64, bool) {
    (((((a as i64) as i128) * ((b as i64) as i128)) >> 64) as u64, false)
}

/// InstContext-based wrapper over op_mulh()
#[inline(always)]
pub fn opc_mulh(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_mulh(ctx.a, ctx.b);
}

/// Sets c to the highest 64-bits of a x b, as 128-bits signed values, and flag to false
#[inline(always)]
pub const fn op_mulsuh(a: u64, b: u64) -> (u64, bool) {
    (((((a as i64) as i128) * (b as i128)) >> 64) as u64, false)
}

/// InstContext-based wrapper over op_mulsuh()
#[inline(always)]
pub fn opc_mulsuh(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_mulsuh(ctx.a, ctx.b);
}

/// Sets c to a / b, as 64-bits unsigned values, and flag to false.
/// If b=0 (divide by zero) it sets c to 2^64 - 1, and sets flag to true.
#[inline(always)]
pub const fn op_divu(a: u64, b: u64) -> (u64, bool) {
    if b == 0 {
        return (M64, true);
    }

    (a / b, false)
}

/// InstContext-based wrapper over op_divu()
#[inline(always)]
pub fn opc_divu(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_divu(ctx.a, ctx.b);
}

/// Sets c to a / b, as 64-bits signed values, and flag to false.
///
/// If b=0 (divide by zero) it sets c to 2^64 - 1, and sets flag to true.
/// If a=0x8000000000000000 (MIN_I64) and b=0xFFFFFFFFFFFFFFFF (-1) the result should be -MIN_I64,
/// which cannot be represented with 64 bits (overflow) and it returns c=a.
#[inline(always)]
pub const fn op_div(a: u64, b: u64) -> (u64, bool) {
    if b == 0 {
        return (M64, true);
    }
    ((((a as i64) as i128) / ((b as i64) as i128)) as u64, false)
}

/// InstContext-based wrapper over op_div()
#[inline(always)]
pub fn opc_div(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_div(ctx.a, ctx.b);
}

/// Sets c to a / b, as 32-bits unsigned values, and flag to false.
/// If b=0 (divide by zero) it sets c to 2^64 - 1, and sets flag to true.
#[inline(always)]
pub const fn op_divu_w(a: u64, b: u64) -> (u64, bool) {
    if b as u32 == 0 {
        return (M64, true);
    }

    (((a as u32 / b as u32) as i32) as u64, false)
}

/// InstContext-based wrapper over op_divu_w()
#[inline(always)]
pub fn opc_divu_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_divu_w(ctx.a, ctx.b);
}

/// Sets c to a / b, as 32-bits signed values sign-extended to 64 bits, and flag to false.
/// If b=0 (divide by zero) it sets c to 2^64 - 1, and sets flag to true.
/// If a=0x80000000 (MIN_I32) and b=0xFFFFFFFF (-1) the quotient overflows 32 bits and c is
/// MIN_I32 sign-extended, i.e. 0xFFFFFFFF80000000.
#[inline(always)]
pub const fn op_div_w(a: u64, b: u64) -> (u64, bool) {
    if b as i32 == 0 {
        return (M64, true);
    }

    let quotient = ((a as i32) as i64) / ((b as i32) as i64);
    ((quotient as i32) as u64, false)
}

/// InstContext-based wrapper over op_div_w()
#[inline(always)]
pub fn opc_div_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_div_w(ctx.a, ctx.b);
}

/// Sets c to a mod b, as 64-bits unsigned values, and flag to false.
/// If b=0 (divide by zero) it sets c to a, and sets flag to true.
#[inline(always)]
pub const fn op_remu(a: u64, b: u64) -> (u64, bool) {
    if b == 0 {
        return (a, true);
    }

    (a % b, false)
}

/// InstContext-based wrapper over op_remu()
#[inline(always)]
pub fn opc_remu(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_remu(ctx.a, ctx.b);
}

/// Sets c to a mod b, as 64-bits signed values, and flag to false.
/// If b=0 (divide by zero) it sets c to a, and sets flag to true.
#[inline(always)]
pub const fn op_rem(a: u64, b: u64) -> (u64, bool) {
    if b == 0 {
        return (a, true);
    }

    ((((a as i64) as i128) % ((b as i64) as i128)) as u64, false)
}

/// InstContext-based wrapper over op_rem()
#[inline(always)]
pub fn opc_rem(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_rem(ctx.a, ctx.b);
}

/// Sets c to a mod b, as 32-bits unsigned values, and flag to false.
/// If b=0 (divide by zero) it sets c to a, and sets flag to true.
#[inline(always)]
pub const fn op_remu_w(a: u64, b: u64) -> (u64, bool) {
    if (b as u32) == 0 {
        return ((a as i32) as u64, true);
    }

    ((((a as u32) % (b as u32)) as i32) as u64, false)
}

/// InstContext-based wrapper over op_remu_w()
#[inline(always)]
pub fn opc_remu_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_remu_w(ctx.a, ctx.b);
}

/// Sets c to a mod b, as 32-bits signed values, and flag to false.
/// If b=0 (divide by zero) it sets c to a, and sets flag to true.
#[inline(always)]
pub const fn op_rem_w(a: u64, b: u64) -> (u64, bool) {
    if (b as i32) == 0 {
        return ((a as i32) as u64, true);
    }

    ((((a as i32) as i64) % ((b as i32) as i64)) as u64, false)
}

/// InstContext-based wrapper over op_rem_w()
#[inline(always)]
pub fn opc_rem_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_rem_w(ctx.a, ctx.b);
}
