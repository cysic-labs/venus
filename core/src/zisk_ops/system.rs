//! System operations: flag, copyb, pubout and halt

use crate::InstContext;

/* INTERNAL operations */

/// Sets flag to true (and c to 0)
#[inline(always)]
pub const fn op_flag(_a: u64, _b: u64) -> (u64, bool) {
    (0, true)
}

/// InstContext-based wrapper over op_flag()
#[inline(always)]
pub fn opc_flag(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_flag(ctx.a, ctx.b);
}

/// Copies register b into c (and flag to false)
#[inline(always)]
pub const fn op_copyb(_a: u64, b: u64) -> (u64, bool) {
    (b, false)
}

/// InstContext-based wrapper over op_copyb()
#[inline(always)]
pub fn opc_copyb(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_copyb(ctx.a, ctx.b);
}

/// Copies register b into c as a public output data record, where a contains the data index (and
/// sets flag to false)
#[inline(always)]
pub const fn op_pubout(a: u64, b: u64) -> (u64, bool) {
    (b, false)
}

/// InstContext-based wrapper over op_pubout()
#[inline(always)]
pub fn opc_pubout(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_pubout(ctx.a, ctx.b);
    //println!("public ${} = {:#018x}", ctx.a, ctx.b);
}

/// Implements halt
#[inline(always)]
pub fn op_halt(a: u64, b: u64) -> (u64, bool) {
    unimplemented!("op_halt() is not implemented");
}

/// InstContext-based wrapper over op_halt()
#[inline(always)]
pub fn opc_halt(ctx: &mut InstContext) {
    ctx.error = true;
    ctx.c = 0;
    ctx.flag = false;
}
