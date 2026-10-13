//! Bitwise operations: sign extensions, shifts, and, or and xor

use std::num::Wrapping;

use crate::InstContext;

/* SIGN EXTEND operations for different data widths (i8, i16 and i32) --> i64 --> u64 */

/// Sign extends an i8.
///
/// Converts b from a signed 8-bits number in the range [-128, +127] into a signed 64-bit number of
/// the same value, adding 0xFFFFFFFFFFFFFF00 if negative, and stores the result in c as a u64 (and
/// sets flag to false)
#[inline(always)]
pub const fn op_signextend_b(_a: u64, b: u64) -> (u64, bool) {
    ((b as i8) as u64, false)
}

/// InstContext-based wrapper over op_signextend_b()
#[inline(always)]
pub fn opc_signextend_b(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_signextend_b(ctx.a, ctx.b);
}

/// Sign extends an i16.
///
/// Converts b from a signed 16-bits number in the range [-32768, 32767] into a signed 64-bit number
/// of the same value, adding 0xFFFFFFFFFFFF0000 if negative, and stores the result in c as a u64
/// (and sets flag to false)
#[inline(always)]
pub const fn op_signextend_h(_a: u64, b: u64) -> (u64, bool) {
    ((b as i16) as u64, false)
}

/// InstContext-based wrapper over op_signextend_h()
#[inline(always)]
pub fn opc_signextend_h(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_signextend_h(ctx.a, ctx.b);
}

/// Sign extends an i32.
///
/// Converts b from a signed 32-bits number in the range [-2147483648, 2147483647] into a signed
/// 64-bit number of the same value, adding 0xFFFFFFFF00000000 if negative  and stores the result in
/// c as a u64 (and sets flag to false)
#[inline(always)]
pub const fn op_signextend_w(_a: u64, b: u64) -> (u64, bool) {
    ((b as i32) as u64, false)
}

/// InstContext-based wrapper over op_signextend_w()
#[inline(always)]
pub fn opc_signextend_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_signextend_w(ctx.a, ctx.b);
}

/* SHIFT operations */

/// Shifts a as a 64-bits unsigned value to the left b mod 64 bits, and stores the result in c (and
/// sets flag to false)
#[inline(always)]
pub const fn op_sll(a: u64, b: u64) -> (u64, bool) {
    (a << (b & 0x3f), false)
}

/// InstContext-based wrapper over op_sll()
#[inline(always)]
pub fn opc_sll(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_sll(ctx.a, ctx.b);
}

/// Shifts a as a 32-bits unsigned value to the left b mod 64 bits, and stores the result in c (and
/// sets flag to false)
#[inline(always)]
pub fn op_sll_w(a: u64, b: u64) -> (u64, bool) {
    (((Wrapping(a as u32) << (b & 0x3f) as usize).0 as i32) as u64, false)
}

/// InstContext-based wrapper over op_sll_w()
#[inline(always)]
pub fn opc_sll_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_sll_w(ctx.a, ctx.b);
}

/// Shifts a as a 64-bits signed value to the right b mod 64 bits, and stores the result in c (and
/// sets flag to false)
#[inline(always)]
pub const fn op_sra(a: u64, b: u64) -> (u64, bool) {
    (((a as i64) >> (b & 0x3f)) as u64, false)
}

/// InstContext-based wrapper over op_sra()
#[inline(always)]
pub fn opc_sra(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_sra(ctx.a, ctx.b);
}

/// Shifts a as a 64-bits unsigned value to the right b mod 64 bits, and stores the result in c (and
/// sets flag to false)
#[inline(always)]
pub const fn op_srl(a: u64, b: u64) -> (u64, bool) {
    (a >> (b & 0x3f), false)
}

/// InstContext-based wrapper over op_srl()
#[inline(always)]
pub fn opc_srl(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_srl(ctx.a, ctx.b);
}

/// Shifts a as a 32-bits signed value to the right b mod 64 bits, and stores the result in c (and
/// sets flag to false)
#[inline(always)]
pub fn op_sra_w(a: u64, b: u64) -> (u64, bool) {
    ((Wrapping(a as i32) >> (b & 0x3f) as usize).0 as u64, false)
}

/// InstContext-based wrapper over op_sra_w()
#[inline(always)]
pub fn opc_sra_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_sra_w(ctx.a, ctx.b);
}

/// Shifts a as a 32-bits unsigned value to the right b mod 64 bits, and stores the result in c (and
/// sets flag to false)
#[inline(always)]
pub fn op_srl_w(a: u64, b: u64) -> (u64, bool) {
    (((Wrapping(a as u32) >> (b & 0x3f) as usize).0 as i32) as u64, false)
}

/// InstContext-based wrapper over op_srl_w()
#[inline(always)]
pub fn opc_srl_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_srl_w(ctx.a, ctx.b);
}

/* LOGICAL operations */

/// Sets c to a AND b, and flag to false
#[inline(always)]
pub const fn op_and(a: u64, b: u64) -> (u64, bool) {
    (a & b, false)
}

/// InstContext-based wrapper over op_and()
#[inline(always)]
pub fn opc_and(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_and(ctx.a, ctx.b);
}

/// Sets c to a OR b, and flag to false
#[inline(always)]
pub const fn op_or(a: u64, b: u64) -> (u64, bool) {
    (a | b, false)
}

/// InstContext-based wrapper over op_or()
#[inline(always)]
pub fn opc_or(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_or(ctx.a, ctx.b);
}

/// Sets c to a XOR b, and flag to false
#[inline(always)]
pub const fn op_xor(a: u64, b: u64) -> (u64, bool) {
    (a ^ b, false)
}

/// InstContext-based wrapper over op_xor()
#[inline(always)]
pub fn opc_xor(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_xor(ctx.a, ctx.b);
}
