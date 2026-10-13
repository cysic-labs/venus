//! Zisk ROM to ASM
//!
//! Generates i86_64 assembly code that implements the Zisk ROM program

mod chunk_player;
mod chunks;
mod context;
mod control_flow;
mod guest_memory;
mod instruction;
mod main_trace;
mod mem_ops;
mod mem_reads;
mod ops;
mod precompile_results;
mod program;
mod registers;
mod sources;
mod store;

use std::path::Path;

use crate::{AsmGenerationMethod, ZiskRom};

pub use context::{ZiskAsmContext, ZiskAsmRegister};

pub struct ZiskRom2Asm {}

impl ZiskRom2Asm {
    /// Saves ZisK rom into an i64-64 assembly file: first save to a string, then
    /// save the string to the file
    pub fn save_to_asm_file(
        rom: &ZiskRom,
        file_name: &Path,
        generation_method: AsmGenerationMethod,
        log_output: bool,
        comments: bool,
        precompile_results: bool,
    ) {
        // Get a string with the ASM data
        let mut s = String::new();
        Self::save_to_asm(rom, &mut s, generation_method, log_output, comments, precompile_results);
        // Save to file
        let path = std::path::PathBuf::from(file_name);
        let result = std::fs::write(path, s);
        if result.is_err() {
            panic!(
                "ZiskRom2Asm::save_to_asm_file() failed writing to file={}",
                file_name.display()
            );
        }
    }

    /// Saves ZisK rom into an i86-64 assembly data string
    pub fn save_to_asm(
        rom: &ZiskRom,
        code: &mut String,
        generation_method: AsmGenerationMethod,
        log_output: bool,
        comments: bool,
        precompile_results: bool,
    ) {
        // println!(
        //     "ZiskRom2Asm::save_to_asm() generation_method={:?}, log_output={}, comments={}, precompile_results={}",
        //     generation_method, log_output, comments, precompile_results
        // );
        // Clear output data, just in case
        code.clear();

        // Store less usual code branches in distant memory to improve cache hits
        let mut unusual_code: String = String::new();

        // Create context
        let mut ctx =
            ZiskAsmContext::new(rom, generation_method, log_output, comments, precompile_results);

        Self::data_section(&mut ctx, code);
        Self::text_section_externs(&mut ctx, code);
        Self::chunk_functions(&mut ctx, code);
        Self::generation_info_functions(&mut ctx, rom, code);
        Self::emulator_start(&mut ctx, code);

        /********/
        /* LOOP */
        /********/

        // For all program addresses in the vector, create an assembly set of instructions with an
        // instruction label pc_<pc_in_hex>
        for k in 0..rom.sorted_pc_list.len() {
            Self::instruction_to_asm(&mut ctx, rom, k, code, &mut unusual_code);
        }

        Self::emulator_end(&mut ctx, code);

        /****************/
        /* UNUSUAL CODE */
        /****************/
        Self::dynamic_pc_slow(&mut ctx, &mut unusual_code);
        Self::error_exits(&mut ctx, &mut unusual_code);
        *code += unusual_code.as_str();

        /**********************/
        /* READ_ONLY ROM DATA */
        /**********************/
        /*
        *code += "\n";
        *code += ".global write_ro_data\n";
        *code += "write_ro_data:\n";

        Self::push_external_registers(&mut ctx, code);

        // Create a new read section for every RO data entry of the rom
        //let mut total_ro_data_len: usize = 0;
        for i in 0..rom.ro_data.len() {
            let mut address = rom.ro_data[i].from;
            let ro_data_len = rom.ro_data[i].data.len();
            //total_ro_data_len += ro_data_len;
            // println!(
            //     "ZiskRom2Asm::save_to_asm() ro_data[{}] len={} total_len={} address={:x}",
            //     i, ro_data_len, total_ro_data_len, address
            // );
            let mut written_bytes = 0;
            while written_bytes + 8 <= ro_data_len {
                let value = u64::from_le_bytes(
                    rom.ro_data[i].data[written_bytes..written_bytes + 8].try_into().unwrap(),
                );
                *code += &format!("\tmov {}, 0x{:x}\n", REG_ADDRESS, address);
                *code += &format!("\tmov {}, 0x{:x}\n", REG_VALUE, value);
                *code += &format!("\tmov qword {}[{}], {}\n", ctx.ptr, REG_ADDRESS, REG_VALUE);
                address += 8;
                written_bytes += 8;
            }
            while written_bytes + 4 <= ro_data_len {
                let value = u32::from_le_bytes(
                    rom.ro_data[i].data[written_bytes..written_bytes + 4].try_into().unwrap(),
                );
                *code += &format!("\tmov {}, 0x{:x}\n", REG_ADDRESS, address);
                *code += &format!("\tmov {}, 0x{:x}\n", REG_VALUE, value);
                *code += &format!("\tmov dword {}[{}], {}\n", ctx.ptr, REG_ADDRESS, REG_VALUE_W);
                address += 4;
                written_bytes += 4;
            }
            while written_bytes + 2 <= ro_data_len {
                let value = u16::from_le_bytes(
                    rom.ro_data[i].data[written_bytes..written_bytes + 2].try_into().unwrap(),
                );
                *code += &format!("\tmov {}, 0x{:x}\n", REG_ADDRESS, address);
                *code += &format!("\tmov {}, 0x{:x}\n", REG_VALUE, value);
                *code += &format!("\tmov word {}[{}], {}\n", ctx.ptr, REG_ADDRESS, REG_VALUE_H);
                address += 2;
                written_bytes += 2;
            }
            while written_bytes < ro_data_len {
                let value = rom.ro_data[i].data[written_bytes];
                *code += &format!("\tmov {}, 0x{:x}\n", REG_ADDRESS, address);
                *code += &format!("\tmov {}, 0x{:x}\n", REG_VALUE, value);
                *code += &format!("\tmov byte {}[{}], {}\n", ctx.ptr, REG_ADDRESS, REG_VALUE_B);
                address += 1;
                written_bytes += 1;
            }
        }

        Self::pop_external_registers(&mut ctx, code);
        *code += "\tret\n\n";
        */

        /*****************/
        /* BRANCH TABLES */
        /*****************/
        Self::jump_table(&mut ctx, rom, code);

        #[cfg(debug_assertions)]
        Self::log_statistics(&ctx, rom, code);
    }
}
