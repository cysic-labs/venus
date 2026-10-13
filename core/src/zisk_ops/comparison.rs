//! Comparisons: equal, less than, less or equal, minimum and maximum

use crate::InstContext;

/* COMPARISON operations */

/// If a and b are equal, it returns c=1, flag=true; otherwise it returns c=0, flag=false
#[inline(always)]
pub const fn op_eq(a: u64, b: u64) -> (u64, bool) {
    if a == b {
        (1, true)
    } else {
        (0, false)
    }
}

/// InstContext-based wrapper over op_eq()
#[inline(always)]
pub fn opc_eq(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_eq(ctx.a, ctx.b);
}

/// If a and b as 32-bit signed values are equal, as 64-bit unsigned values, it returns c=1,
/// flag=true; otherwise it returns c=0, flag=false
#[inline(always)]
pub const fn op_eq_w(a: u64, b: u64) -> (u64, bool) {
    if (a as i32) == (b as i32) {
        (1, true)
    } else {
        (0, false)
    }
}

/// InstContext-based wrapper over op_eq_w()
#[inline(always)]
pub fn opc_eq_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_eq_w(ctx.a, ctx.b);
}

/// If a is strictly less than b, as 64-bit unsigned values, it returns c=1, flag=true; otherwise it
/// returns c=0, flag=false
#[inline(always)]
pub const fn op_ltu(a: u64, b: u64) -> (u64, bool) {
    if a < b {
        (1, true)
    } else {
        (0, false)
    }
}

/// InstContext-based wrapper over op_ltu()
#[inline(always)]
pub fn opc_ltu(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_ltu(ctx.a, ctx.b);
}

/// If a is strictly less than b, as 64-bit signed values, it returns c=1, flag=true; otherwise it
/// returns c=0, flag=false
#[inline(always)]
pub const fn op_lt(a: u64, b: u64) -> (u64, bool) {
    if (a as i64) < (b as i64) {
        (1, true)
    } else {
        (0, false)
    }
}

/// InstContext-based wrapper over op_lt()
#[inline(always)]
pub fn opc_lt(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_lt(ctx.a, ctx.b);
}

/// If a is strictly less than b, as 32-bit unsigned values, it returns c=1, flag=true; otherwise it
/// returns c=0, flag=false
#[inline(always)]
pub const fn op_ltu_w(a: u64, b: u64) -> (u64, bool) {
    if (a as u32) < (b as u32) {
        (1, true)
    } else {
        (0, false)
    }
}

/// InstContext-based wrapper over op_ltu_w()
#[inline(always)]
pub fn opc_ltu_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_ltu_w(ctx.a, ctx.b);
}

/// If a is strictly less than b, as 32-bit signed values, it returns c=1, flag=true; otherwise it
/// returns c=0, flag=false
#[inline(always)]
pub const fn op_lt_w(a: u64, b: u64) -> (u64, bool) {
    if (a as i32) < (b as i32) {
        (1, true)
    } else {
        (0, false)
    }
}

/// InstContext-based wrapper over op_lt_w()
#[inline(always)]
pub fn opc_lt_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_lt_w(ctx.a, ctx.b);
}

/// If a is less than or equal to b, as 64-bit unsigned values, it returns c=1, flag=true; otherwise
/// it returns c=0, flag=false
#[inline(always)]
pub const fn op_leu(a: u64, b: u64) -> (u64, bool) {
    if a <= b {
        (1, true)
    } else {
        (0, false)
    }
}

/// InstContext-based wrapper over op_leu()
#[inline(always)]
pub fn opc_leu(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_leu(ctx.a, ctx.b);
}

/// If a is less than or equal to b, as 64-bit signed values, it returns c=1, flag=true; otherwise
/// it returns c=0, flag=false
#[inline(always)]
pub const fn op_le(a: u64, b: u64) -> (u64, bool) {
    if (a as i64) <= (b as i64) {
        (1, true)
    } else {
        (0, false)
    }
}

/// InstContext-based wrapper over op_le()
#[inline(always)]
pub fn opc_le(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_le(ctx.a, ctx.b);
}

/// If a is less than or equal to b, as 32-bit unsigned values, it returns c=1, flag=true; otherwise
/// it returns c=0, flag=false
#[inline(always)]
pub const fn op_leu_w(a: u64, b: u64) -> (u64, bool) {
    if (a as u32) <= (b as u32) {
        (1, true)
    } else {
        (0, false)
    }
}

/// InstContext-based wrapper over op_leu_w()
#[inline(always)]
pub fn opc_leu_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_leu_w(ctx.a, ctx.b);
}

/// If a is less than or equal to b, as 32-bit signed values, it returns c=1, flag=true; otherwise
/// it returns c=0, flag=false
#[inline(always)]
pub const fn op_le_w(a: u64, b: u64) -> (u64, bool) {
    if (a as i32) <= (b as i32) {
        (1, true)
    } else {
        (0, false)
    }
}

/// InstContext-based wrapper over op_le_w()
#[inline(always)]
pub fn opc_le_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_le_w(ctx.a, ctx.b);
}

/* MIN / MAX operations */

/// Sets c to the minimum of a and b as 64-bits unsigned values (and flag to false)
#[inline(always)]
pub const fn op_minu(a: u64, b: u64) -> (u64, bool) {
    if a < b {
        (a, false)
    } else {
        (b, false)
    }
}

/// InstContext-based wrapper over op_minu()
#[inline(always)]
pub fn opc_minu(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_minu(ctx.a, ctx.b);
}

/// Sets c to the minimum of a and b as 64-bits signed values (and flag to false)
#[inline(always)]
pub const fn op_min(a: u64, b: u64) -> (u64, bool) {
    if (a as i64) < (b as i64) {
        (a, false)
    } else {
        (b, false)
    }
}

/// InstContext-based wrapper over op_min()
#[inline(always)]
pub fn opc_min(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_min(ctx.a, ctx.b);
}

/// Sets c to the minimum of a and b as 32-bits unsigned values (and flag to false)
#[inline(always)]
pub const fn op_minu_w(a: u64, b: u64) -> (u64, bool) {
    if (a as u32) < (b as u32) {
        (a as i32 as i64 as u64, false)
    } else {
        (b as i32 as i64 as u64, false)
    }
}

/// InstContext-based wrapper over op_minu_w()
#[inline(always)]
pub fn opc_minu_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_minu_w(ctx.a, ctx.b);
}

/// Sets c to the minimum of a and b as 32-bits signed values (and flag to false)
#[inline(always)]
pub const fn op_min_w(a: u64, b: u64) -> (u64, bool) {
    if (a as i32) < (b as i32) {
        (a as i32 as i64 as u64, false)
    } else {
        (b as i32 as i64 as u64, false)
    }
}

/// InstContext-based wrapper over op_min_w()
#[inline(always)]
pub fn opc_min_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_min_w(ctx.a, ctx.b);
}

/// Sets c to the maximum of a and b as 64-bits unsigned values (and flag to false)
#[inline(always)]
pub const fn op_maxu(a: u64, b: u64) -> (u64, bool) {
    if a > b {
        (a, false)
    } else {
        (b, false)
    }
}

/// InstContext-based wrapper over op_maxu()
#[inline(always)]
pub fn opc_maxu(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_maxu(ctx.a, ctx.b);
}

/// Sets c to the maximum of a and b as 64-bits signed values (and flag to false)
#[inline(always)]
pub const fn op_max(a: u64, b: u64) -> (u64, bool) {
    if (a as i64) > (b as i64) {
        (a, false)
    } else {
        (b, false)
    }
}

/// InstContext-based wrapper over op_max()
#[inline(always)]
pub fn opc_max(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_max(ctx.a, ctx.b);
}

/// Sets c to the maximum of a and b as 32-bits unsigned values (and flag to false)
#[inline(always)]
pub const fn op_maxu_w(a: u64, b: u64) -> (u64, bool) {
    if (a as u32) > (b as u32) {
        (a as i32 as i64 as u64, false)
    } else {
        (b as i32 as i64 as u64, false)
    }
}

/// InstContext-based wrapper over op_maxu_w()
#[inline(always)]
pub fn opc_maxu_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_maxu_w(ctx.a, ctx.b);
}

/// Sets c to the maximum of a and b as 32-bits signed values (and flag to false)
#[inline(always)]
pub const fn op_max_w(a: u64, b: u64) -> (u64, bool) {
    if (a as i32) > (b as i32) {
        (a as i32 as i64 as u64, false)
    } else {
        (b as i32 as i64 as u64, false)
    }
}

/// InstContext-based wrapper over op_max_w()
#[inline(always)]
pub fn opc_max_w(ctx: &mut InstContext) {
    (ctx.c, ctx.flag) = op_max_w(ctx.a, ctx.b);
}
