//! Control flow of the generated code: the jump to the next pc, the dynamic jump table that
//! maps a pc to the code of its instruction, and the exits that stop the execution with an
//! error

use super::registers::{REG_ADDRESS, REG_FLAG, REG_PC};
use crate::{
    ZiskAsmContext, ZiskInst, ZiskRom, ZiskRom2Asm, FLOAT_LIB_ROM_ADDR, ROM_ADDR, ROM_ENTRY,
};

/// Errors that stop the generated emulator: their code is stored in MEM_ERROR, which the emulator
/// reports to the host as the trace exit code, and the pc that raised them in MEM_ERROR_PC
#[derive(Clone, Copy)]
pub(super) enum AsmError {
    /// The program executed a halt instruction
    Halt = 1,
    /// A dynamic jump targeted an address that holds no ROM instruction
    InvalidPc = 2,
    /// A guest memory access fell outside the guest memory spans
    InvalidAddress = 3,
    /// An fcall exceeded the parameters or the results held by the fcall context
    FcallOverflow = 4,
}

impl AsmError {
    /// Errors that stop the execution as soon as they are detected
    const STOPPING: [AsmError; 3] =
        [AsmError::InvalidPc, AsmError::InvalidAddress, AsmError::FcallOverflow];

    fn name(self) -> &'static str {
        match self {
            AsmError::Halt => "halt",
            AsmError::InvalidPc => "invalid_pc",
            AsmError::InvalidAddress => "invalid_address",
            AsmError::FcallOverflow => "fcall_overflow",
        }
    }

    /// Label of the code that stores this error, with the pc held in REG_PC, and ends the execution
    fn exit_label(self) -> String {
        format!("error_{}_exit", self.name())
    }
}

/// Dense region of the dynamic jump table: map_pc_<base> labels the entry of pc `base`, followed by
/// one entry per pc up to `base + len - 1`
#[derive(Default, Debug, Clone, Copy)]
pub(super) struct JumpRegion {
    base: u64,
    len: u64,
}

impl JumpRegion {
    /// Splits the ROM pcs from ROM_ADDR on into the program region and the float library region
    pub(super) fn from_rom(rom: &ZiskRom) -> Vec<JumpRegion> {
        let mut regions: Vec<JumpRegion> = Vec::new();
        for &pc in rom.sorted_pc_list.iter().filter(|&&pc| pc >= ROM_ADDR) {
            match regions.last_mut() {
                Some(region) if pc != FLOAT_LIB_ROM_ADDR => region.len = pc - region.base + 1,
                _ => regions.push(JumpRegion { base: pc, len: 1 }),
            }
        }
        regions
    }

    fn contains(&self, pc: u64) -> bool {
        pc >= self.base && pc - self.base < self.len
    }

    /// Label of the code that stops the execution when a jump lands on a pc of this region that
    /// holds no instruction
    fn gap_label(&self) -> String {
        format!("dynamic_pc_gap_{:x}", self.base)
    }
}

impl ZiskRom2Asm {
    /**********/
    /* SET PC */
    /**********/

    pub(super) fn set_pc(
        ctx: &mut ZiskAsmContext,
        instruction: &ZiskInst,
        code: &mut String,
        id: &str,
        rom: &ZiskRom,
    ) {
        ctx.jump_to_dynamic_pc = false;
        ctx.jump_to_static_pc = String::new();
        if instruction.set_pc {
            *code += &ctx.full_line_comment("set pc".to_string());
            if ctx.c.is_constant {
                let new_pc = (ctx.c.constant_value as i64 + instruction.jmp_offset1) as u64;
                *code += &format!(
                    "\tmov {}, 0x{:x} {}\n",
                    REG_PC,
                    new_pc,
                    ctx.comment_str("pc = c(const) + jmp_offset1")
                );
                // Check if target address exists in ROM before generating static jump
                if rom.sorted_pc_list.binary_search(&new_pc).is_ok() {
                    ctx.jump_to_static_pc =
                        format!("\tjmp pc_{:x} {}\n", new_pc, ctx.comment_str("jump to static pc"));
                } else {
                    ctx.jump_to_dynamic_pc = true;
                }
            } else {
                *code += &format!(
                    "\tmov {}, {} {}\n",
                    REG_PC,
                    ctx.c.string_value,
                    ctx.comment_str("pc = c")
                );
                if instruction.jmp_offset1 != 0 {
                    *code += &format!(
                        "\tadd {}, 0x{:x} {}\n",
                        REG_PC,
                        instruction.jmp_offset1,
                        ctx.comment_str("pc += jmp_offset1")
                    );
                }
                ctx.jump_to_dynamic_pc = true;
            }
        } else if ctx.flag_is_always_zero {
            let new_pc = (ctx.pc as i64 + instruction.jmp_offset2) as u64;
            if new_pc != ctx.next_pc {
                *code += &format!(
                    "\tmov {}, 0x{:x} {}\n",
                    REG_PC,
                    new_pc,
                    ctx.comment_str("flag=0: pc+=jmp_offset2")
                );
                // Check if target address exists in ROM before generating static jump
                if rom.sorted_pc_list.binary_search(&new_pc).is_ok() {
                    ctx.jump_to_static_pc = format!(
                        "\tjmp pc_{:x} {}\n",
                        new_pc,
                        ctx.comment_str("jump to pc+offset2")
                    );
                } else {
                    ctx.jump_to_dynamic_pc = true;
                }
            } else if id == "z" {
                *code += &format!(
                    "\tmov {}, 0x{:x} {}\n",
                    REG_PC,
                    ctx.next_pc,
                    ctx.comment_str("flag=0: pc += 4")
                );
            }
        } else if ctx.flag_is_always_one {
            let new_pc = (ctx.pc as i64 + instruction.jmp_offset1) as u64;
            if new_pc != ctx.next_pc {
                *code += &format!(
                    "\tmov {}, 0x{:x} {}\n",
                    REG_PC,
                    new_pc,
                    ctx.comment_str("flag=1: pc+=jmp_offset1")
                );
                // Check if target address exists in ROM before generating static jump
                if rom.sorted_pc_list.binary_search(&new_pc).is_ok() {
                    ctx.jump_to_static_pc = format!(
                        "\tjmp pc_{:x} {}\n",
                        new_pc,
                        ctx.comment_str("jump to pc+offset1")
                    );
                } else {
                    ctx.jump_to_dynamic_pc = true;
                }
            } else if id == "z" {
                *code += &format!(
                    "\tmov {}, 0x{:x} {}\n",
                    REG_PC,
                    ctx.next_pc,
                    ctx.comment_str("flag=1: pc += 4")
                );
            }
        } else if instruction.jmp_offset1 == instruction.jmp_offset2 {
            // The flag does not select the next pc
            let new_pc = (ctx.pc as i64 + instruction.jmp_offset1) as u64;
            if new_pc != ctx.next_pc {
                *code += &format!(
                    "\tmov {}, 0x{:x} {}\n",
                    REG_PC,
                    new_pc,
                    ctx.comment_str("pc += jmp_offset1 = jmp_offset2")
                );
                // Check if target address exists in ROM before generating static jump
                if rom.sorted_pc_list.binary_search(&new_pc).is_ok() {
                    ctx.jump_to_static_pc = format!(
                        "\tjmp pc_{:x} {}\n",
                        new_pc,
                        ctx.comment_str("jump to pc+offset1")
                    );
                } else {
                    ctx.jump_to_dynamic_pc = true;
                }
            } else if id == "z" {
                *code += &format!(
                    "\tmov {}, 0x{:x} {}\n",
                    REG_PC,
                    ctx.next_pc,
                    ctx.comment_str("pc += 4")
                );
            }
        } else {
            *code += &ctx.full_line_comment("pc = f(flag)".to_string());
            // Calculate the new pc
            *code += &format!("\tcmp {}, 1 {}\n", REG_FLAG, ctx.comment_str("flag == 1 ?"));
            *code += &format!("\tjne pc_{:x}_{}_flag_false\n", ctx.pc, id);
            *code += &format!(
                "\tmov {}, 0x{:x} {}\n",
                REG_PC,
                (ctx.pc as i64 + instruction.jmp_offset1) as u64,
                ctx.comment_str("pc += i.jmp_offset1")
            );
            *code += &format!("\tjmp pc_{:x}_{}_flag_done\n", ctx.pc, id);
            *code += &format!("pc_{:x}_{}_flag_false:\n", ctx.pc, id);
            *code += &format!(
                "\tmov {}, 0x{:x} {}\n",
                REG_PC,
                (ctx.pc as i64 + instruction.jmp_offset2) as u64,
                ctx.comment_str("pc += i.jmp_offset2")
            );
            *code += &format!("pc_{:x}_{}_flag_done:\n", ctx.pc, id);
            ctx.jump_to_dynamic_pc = true;
        }
    }

    /// Jumps to the ROM instruction at the guest pc held in REG_PC.  The jump table region that
    /// holds the current pc (the program region for BIOS code) is looked up inline; any other
    /// target goes through dynamic_pc_slow, which stops the execution with AsmError::InvalidPc if
    /// the target holds no instruction.
    pub(super) fn jumpt_to_dynamic_pc(ctx: &mut ZiskAsmContext, code: &mut String) {
        *code += &ctx.full_line_comment("jump to dynamic pc".to_string());
        let region = ctx
            .jump_regions
            .iter()
            .find(|region| region.contains(ctx.pc))
            .or(ctx.jump_regions.first())
            .copied();
        let Some(region) = region else {
            *code += &format!("\txor {REG_ADDRESS}, {REG_ADDRESS}\n");
            *code += "\tjmp dynamic_pc_slow\n";
            return;
        };
        *code += &format!(
            "\tmov {}, 0x{:x} {}\n",
            REG_ADDRESS,
            region.base,
            ctx.comment_str("address = region base pc")
        );
        *code += &format!(
            "\tsub {}, {} {}\n",
            REG_PC,
            REG_ADDRESS,
            ctx.comment_str("pc -= region base pc")
        );
        *code += &format!(
            "\tcmp {}, 0x{:x} {}\n",
            REG_PC,
            region.len,
            ctx.comment_str("pc ? region length")
        );
        *code +=
            &format!("\tjae dynamic_pc_slow {}\n", ctx.comment_str("target outside the region"));
        *code += &format!(
            "\tmov {}, [map_pc_{:x} + {}*8] {}\n",
            REG_ADDRESS,
            region.base,
            REG_PC,
            ctx.comment_str("address = map[pc]")
        );
        *code += &format!("\tjmp {} {}\n", REG_ADDRESS, ctx.comment_str("jump to address"));
    }

    /// Emits the code shared by the dynamic jumps whose target lies outside the region looked up
    /// inline, which on entry holds the target minus REG_ADDRESS in REG_PC, and the code that
    /// stops the execution when a jump lands on a region pc that holds no instruction
    pub(super) fn dynamic_pc_slow(ctx: &mut ZiskAsmContext, code: &mut String) {
        *code += "dynamic_pc_slow:\n";
        *code += &format!("\tadd {}, {} {}\n", REG_PC, REG_ADDRESS, ctx.comment_str("pc = target"));
        for region in &ctx.jump_regions {
            *code += &format!("\tmov {}, 0x{:x}\n", REG_ADDRESS, region.base);
            *code += &format!("\tsub {REG_PC}, {REG_ADDRESS}\n");
            *code += &format!("\tcmp {}, 0x{:x}\n", REG_PC, region.len);
            *code += &format!("\tjb dynamic_pc_slow_{:x}\n", region.base);
            *code += &format!("\tadd {REG_PC}, {REG_ADDRESS}\n");
        }

        // BIOS entries take 8 bytes per 4-byte aligned pc
        *code += &format!("\tsub {}, 0x{:x} {}\n", REG_PC, ROM_ENTRY, ctx.comment_str("BIOS pc"));
        *code += &format!("\tcmp {}, 0x{:x}\n", REG_PC, ctx.max_bios_pc - ROM_ENTRY);
        *code += "\tja dynamic_pc_slow_invalid\n";
        *code += &format!("\ttest {REG_PC}, 0x3\n");
        *code += "\tjnz dynamic_pc_slow_invalid\n";
        *code += &format!("\tmov {}, [map_pc_{:x} + {}*2]\n", REG_ADDRESS, ROM_ENTRY, REG_PC);
        *code += &format!("\tjmp {REG_ADDRESS}\n");
        *code += "dynamic_pc_slow_invalid:\n";
        *code += &format!("\tadd {}, 0x{:x}\n", REG_PC, ROM_ENTRY);
        *code += &format!("\tjmp {}\n", AsmError::InvalidPc.exit_label());

        for region in &ctx.jump_regions {
            *code += &format!("dynamic_pc_slow_{:x}:\n", region.base);
            *code += &format!("\tmov {}, [map_pc_{:x} + {}*8]\n", REG_ADDRESS, region.base, REG_PC);
            *code += &format!("\tjmp {REG_ADDRESS}\n");
            *code += &format!("{}:\n", region.gap_label());
            *code += &format!("\tmov {}, 0x{:x}\n", REG_ADDRESS, region.base);
            *code += &format!("\tadd {REG_PC}, {REG_ADDRESS}\n");
            *code += &format!("\tjmp {}\n", AsmError::InvalidPc.exit_label());
        }
    }

    /// Maps fixed-length pc labels to real variable-length instruction labels.  This is used to
    /// implement dynamic jumps, i.e. to jump to an address that is not a constant in the
    /// instruction, but dynamically built as part of the emulation.
    pub(super) fn jump_table(ctx: &mut ZiskAsmContext, rom: &ZiskRom, code: &mut String) {
        *code += "\n";
        *code += ".section .rodata\n";
        *code += ".align 64\n";

        // BIOS entries, one per 4-byte aligned pc
        for &pc in rom.sorted_pc_list.iter().take_while(|&&pc| pc < ROM_ADDR) {
            *code += &format!("map_pc_{pc:x}: \t.quad pc_{pc:x}\n");
        }

        // Program and float library regions, one entry per pc: a chunk can start at any pc,
        // including the internal ones that are not 4-byte aligned, so the gaps between
        // instructions are filled to keep the entry of a pc at a constant distance from the
        // region base
        let mut pcs = rom.sorted_pc_list.iter().copied().skip_while(|&pc| pc < ROM_ADDR).peekable();
        for region in &ctx.jump_regions {
            let gap_label = region.gap_label();
            for pc in region.base..region.base + region.len {
                if pcs.next_if_eq(&pc).is_some() {
                    *code += &format!("map_pc_{pc:x}: \t.quad pc_{pc:x}\n");
                } else {
                    *code += &format!("\t.quad {gap_label}\n");
                }
            }
        }
        *code += "\n";
    }

    /// Emits the code that stores each stopping error with the pc held in REG_PC and ends the
    /// execution
    pub(super) fn error_exits(ctx: &mut ZiskAsmContext, code: &mut String) {
        for error in AsmError::STOPPING {
            *code += &format!("{}:\n", error.exit_label());
            *code += &format!(
                "\tmov {}, {} {}\n",
                ctx.mem_error,
                error as u64,
                ctx.comment(format!("error = {}", error.name()))
            );
            *code += &format!(
                "\tmov {}, {} {}\n",
                ctx.mem_error_pc,
                REG_PC,
                ctx.comment_str("error pc = pc")
            );
            *code += "\tjmp execute_end\n";
        }
    }

    /// Returns the label that stops the execution at the current pc with `error`, emitting its
    /// code into the unusual code the first time the current instruction uses it
    pub(super) fn error_label(
        ctx: &mut ZiskAsmContext,
        unusual_code: &mut String,
        error: AsmError,
    ) -> String {
        let label = format!("pc_{:x}_{}", ctx.pc, error.name());
        let mask = 1u64 << (error as u64);
        if ctx.error_labels & mask == 0 {
            ctx.error_labels |= mask;
            *unusual_code += &format!("{label}:\n");
            *unusual_code +=
                &format!("\tmov {}, 0x{:x} {}\n", REG_PC, ctx.pc, ctx.comment_str("pc"));
            *unusual_code += &format!("\tjmp {}\n", error.exit_label());
        }
        label
    }
}
