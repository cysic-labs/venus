//! Guest memory checks: the confinement of every guest memory access whose address depends on
//! guest data to the guest memory spans

use super::{
    control_flow::AsmError,
    registers::{REG_ADDRESS, REG_VALUE},
};
use crate::{ZiskAsmContext, ZiskRom2Asm, INPUT_ADDR, RAM_ADDR, RAM_SIZE, ROM_ADDR};

// The emulator maps the guest memory regions at their guest addresses, so the generated code uses
// guest addresses directly as host pointers.  Every access whose address depends on guest data is
// confined to a span with one unsigned comparison: reads to [INPUT_ADDR, GUEST_SPAN_END) and writes
// to [ROM_ADDR, GUEST_SPAN_END).  Inside these spans the emulator maps only the input data, the
// control shared memories (below ROM_ADDR, so never writable by the guest), the ROM and the RAM;
// the gap between ROM and RAM is part of the address range reserved by the emulator linker script,
// so an access to it touches no host data.
const GUEST_SPAN_END: u64 = RAM_ADDR + RAM_SIZE;

/// Kind of guest memory access, which selects the span its address range must lie in
#[derive(Clone, Copy)]
pub(super) enum GuestAccess {
    Read,
    Write,
}

impl GuestAccess {
    fn span_start(self) -> u64 {
        match self {
            GuestAccess::Read => INPUT_ADDR,
            GuestAccess::Write => ROM_ADDR,
        }
    }

    fn span_size(self) -> u64 {
        GUEST_SPAN_END - self.span_start()
    }

    /// Returns true if [address, address + length) lies inside the span
    fn allows(self, address: u64, length: u64) -> bool {
        let start = self.span_start();
        let size = self.span_size();
        address >= start && length <= size && address - start <= size - length
    }
}

impl ZiskRom2Asm {
    /// Confines an access of `length` bytes to the span of `access`: at generation time if the
    /// access address is the constant `constant_address`, or else at run time with the address
    /// held in `address_reg`, using REG_VALUE as scratch register.  An access outside the span
    /// stops the execution with AsmError::InvalidAddress.
    pub(super) fn guest_range_check(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
        address_reg: &str,
        constant_address: Option<u64>,
        length: u64,
        access: GuestAccess,
    ) {
        match constant_address {
            Some(address) if access.allows(address, length) => {}
            Some(_) => {
                let label = Self::error_label(ctx, unusual_code, AsmError::InvalidAddress);
                *code += &format!("\tjmp {} {}\n", label, ctx.comment_str("address out of range"));
            }
            None => {
                let label = Self::error_label(ctx, unusual_code, AsmError::InvalidAddress);
                *code += &format!(
                    "\tlea {}, [{} - 0x{:x}] {}\n",
                    REG_VALUE,
                    address_reg,
                    access.span_start(),
                    ctx.comment_str("value = address offset in span")
                );
                *code += &format!(
                    "\tcmp {}, 0x{:x} {}\n",
                    REG_VALUE,
                    access.span_size() - length,
                    ctx.comment_str("value ? span size - length")
                );
                *code += &format!("\tja {label}\n");
            }
        }
    }

    /// Confines the `count_reg` bytes at the address held in `address_reg` to the span of
    /// `access`, using REG_VALUE as scratch register; a zero count accesses no memory.  An access
    /// outside the span stops the execution with AsmError::InvalidAddress.
    pub(super) fn guest_dynamic_range_check(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
        address_reg: &str,
        count_reg: &str,
        access: GuestAccess,
    ) {
        let label = Self::error_label(ctx, unusual_code, AsmError::InvalidAddress);
        let done = format!("pc_{:x}_{}_range_checked", ctx.pc, address_reg);
        *code += &format!("\ttest {count_reg}, {count_reg}\n");
        *code += &format!("\tjz {done}\n");
        *code += &format!(
            "\tlea {}, [{} - 0x{:x}] {}\n",
            REG_VALUE,
            address_reg,
            access.span_start(),
            ctx.comment_str("value = address offset in span")
        );
        *code += &format!(
            "\tadd {}, {} {}\n",
            REG_VALUE,
            count_reg,
            ctx.comment_str("value = end offset in span")
        );
        *code += &format!("\tjc {label}\n");
        *code += &format!("\tdec {} {}\n", REG_VALUE, ctx.comment_str("value = last byte offset"));
        *code += &format!(
            "\tcmp {}, 0x{:x} {}\n",
            REG_VALUE,
            access.span_size() - 1,
            ctx.comment_str("value ? span size - 1")
        );
        *code += &format!("\tja {label}\n");
        *code += &format!("{done}:\n");
    }

    /// Confines the operands of a precompile whose params block, at the address held in rdi,
    /// holds params_count words: the first load_sizes.len() params point to the load_sizes words
    /// it reads, and params first_write..=last_write point to the write_size words it writes.  It
    /// must run before any operand is dereferenced.
    #[allow(clippy::too_many_arguments)]
    pub(super) fn precompiled_check_operands(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        unusual_code: &mut String,
        params_count: u64,
        load_sizes: &[usize],
        first_write: u64,
        last_write: u64,
        write_size: u64,
    ) {
        Self::guest_range_check(
            ctx,
            code,
            unusual_code,
            "rdi",
            None,
            params_count * 8,
            GuestAccess::Read,
        );
        let reads = load_sizes
            .iter()
            .enumerate()
            .map(|(i, &words)| (i as u64, words as u64, GuestAccess::Read));
        let writes = (first_write..=last_write).map(|i| (i, write_size, GuestAccess::Write));
        for (i, words, access) in reads.chain(writes).filter(|&(_, words, _)| words > 0) {
            *code += &format!(
                "\tmov {}, [rdi + {}*8] {}\n",
                REG_ADDRESS,
                i,
                ctx.comment(format!("address = param[{i}]"))
            );
            Self::guest_range_check(ctx, code, unusual_code, REG_ADDRESS, None, words * 8, access);
        }
    }
}
