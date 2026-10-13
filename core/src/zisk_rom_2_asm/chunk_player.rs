//! Chunk players: the methods that execute a chunk again from its minimal trace or its mem
//! reads, consuming the memory values recorded in them instead of reading memory

use super::{
    mem_ops::{F_MOPS_READ_8, F_MOPS_WRITE_1, F_MOPS_WRITE_2, F_MOPS_WRITE_4, F_MOPS_WRITE_8},
    registers::{
        REG_A, REG_ADDRESS, REG_AUX, REG_B, REG_C, REG_CHUNK_PLAYER_ADDRESS, REG_MEM_READS_ADDRESS,
        REG_MEM_READS_SIZE, REG_PC, REG_STEP, REG_VALUE,
    },
};
use crate::{ZiskAsmContext, ZiskInst, ZiskRom2Asm};

impl ZiskRom2Asm {
    pub(super) fn chunk_player_start(ctx: &mut ZiskAsmContext, code: &mut String) {
        *code += &ctx.full_line_comment("Chunk plater start".to_string());

        // Read from minimal trace setup
        ////////////////////////////////

        // Get chunk player address and store it in a register
        *code += &format!(
            "\tmov {}, qword {} [chunk_player_address] {}\n",
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.ptr,
            ctx.comment_str("set chunk player address")
        );

        // Init pc = chunk[0]
        *code += &format!(
            "\tmov {}, qword {} [{}] {}\n",
            REG_PC,
            ctx.ptr,
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.comment_str("pc = chunk.start.pc")
        );

        // Init sp = chunk[1]
        *code += &format!(
            "\tmov {}, qword {} [{} + 8] {}\n",
            REG_VALUE,
            ctx.ptr,
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.comment_str("value = chunk.start.sp")
        );
        *code += &format!(
            "\tmov {}, {} {}\n",
            ctx.mem_sp,
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.comment_str("sp = value")
        );

        // Init register c = chunk[2]
        *code += &format!(
            "\tmov {}, qword {} [{} + 8*2] {}\n",
            REG_C,
            ctx.ptr,
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.comment_str("c = chunk.start.c")
        );

        // Init step = chunk[3]
        *code += &format!(
            "\tmov {}, qword {} [{} + 8*3] {}\n",
            REG_VALUE,
            ctx.ptr,
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.comment_str("value = chunk.start.step")
        );
        *code +=
            &format!("\tmov {}, {} {}\n", ctx.mem_step, REG_VALUE, ctx.comment_str("step = value"));

        // Init RISC-V registers, reg[1...33] = chunk[4...36]
        *code += &format!("\tmov qword {}[reg_0], 0\n", ctx.ptr);
        for i in 0..34 {
            *code += &format!(
                "\tmov {}, qword {} [{} + 8*(4 + {})] {}\n",
                REG_VALUE,
                ctx.ptr,
                REG_CHUNK_PLAYER_ADDRESS,
                i,
                ctx.comment_str(&format!("value = chunk.start.reg[{}]", i + 1))
            );
            Self::write_riscv_reg(ctx, code, i + 1, REG_VALUE, "value");
        }
        *code += &format!("\tmov qword {}[reg_34], 0\n", ctx.ptr);

        // Skip last c = chunk[37]

        // Skip end = chunk[38]

        // Skip steps = chunk[39]

        // Skip mem reads size = chunk[40]

        // Advance address to the first memory reads position. i.e. to chunk.mem_reads[0]
        *code += &format!(
            "\tadd {}, 8*41 {}\n",
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.comment_str("advance chunk player address")
        );

        // Set step count down
        //////////////////////

        *code += &ctx.full_line_comment("Set step count down to chunk_size".to_string());
        *code += &format!(
            "\tmov {}, chunk_size {}\n",
            REG_STEP,
            ctx.comment_str("step_count_down = chunk_size")
        );

        // Output trace setup
        /////////////////////

        *code += &ctx.full_line_comment("Write mem reads address".to_string());
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_AUX,
            ctx.mem_chunk_address,
            ctx.comment_str("aux = chunk_size")
        );
        *code += &format!("\tadd {}, 8 {}\n", REG_AUX, ctx.comment_str("aux += 8"));
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_MEM_READS_ADDRESS,
            REG_AUX,
            ctx.comment_str("mem_reads_address = aux")
        );
        *code += &ctx.full_line_comment("Reset mem_reads size".to_string());
        *code += &format!(
            "\txor {}, {} {}\n",
            REG_MEM_READS_SIZE,
            REG_MEM_READS_SIZE,
            ctx.comment_str("mem_reads_size = 0")
        );

        // Jump to start pc
        Self::jumpt_to_dynamic_pc(ctx, code);
    }

    pub(super) fn chunk_player_end(ctx: &mut ZiskAsmContext, code: &mut String) {
        // Update step
        *code += &ctx.full_line_comment("Update total step from step count down".to_string());
        *code +=
            &format!("\tmov {}, {} {}\n", REG_VALUE, ctx.mem_step, ctx.comment_str("value = step"));
        *code += &format!(
            "\tadd {}, chunk_size {}\n",
            REG_VALUE,
            ctx.comment_str("value += chunk_size")
        );
        *code += &format!(
            "\tsub {}, {} {}\n",
            REG_VALUE,
            REG_STEP,
            ctx.comment_str("value -= step_count_down")
        );
        *code +=
            &format!("\tmov {}, {} {}\n", ctx.mem_step, REG_VALUE, ctx.comment_str("step = value"));

        // Update mem reads size
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_ADDRESS,
            ctx.mem_trace_address,
            ctx.comment_str("address = chunk_address")
        );
        *code += &format!(
            "\tmov [{}], {} {}\n",
            REG_ADDRESS,
            REG_MEM_READS_SIZE,
            ctx.comment_str("mem_reads_size = size")
        );
    }

    pub(super) fn chunk_player_mem_read_aligned(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        reg_to_store_value: &str,
        reg_to_store_value_desc: &str,
        micro_step: u64,
    ) {
        // Read value from minimal trace
        ////////////////////////////////

        // Read value from memory and store in the proper register: a or c
        *code += &format!(
            "\tmov {}, [{}] {}\n",
            reg_to_store_value,
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.comment(format!("{reg_to_store_value_desc} = mt[address]"))
        );

        // Increment chunk player address
        *code += &format!(
            "\tadd {}, 8 {}\n",
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.comment_str("chunk_address += 8")
        );

        // Trace memory
        ///////////////

        // Build the mask for this case
        let addr_step_mask: u64 = F_MOPS_READ_8 + (micro_step << 38);

        // Add mask to address
        *code += &format!(
            "\tmov {}, 0x{:x} {}\n",
            REG_AUX,
            addr_step_mask,
            ctx.comment_str("aux = addr_step_mask")
        );
        *code += &format!(
            "\tadd {}, {} {}\n",
            REG_ADDRESS,
            REG_AUX,
            ctx.comment_str("address += addr_step_mask")
        );

        // Build the step and add it to the address
        *code +=
            &format!("\tmov {}, chunk_size {}\n", REG_AUX, ctx.comment_str("aux = chunk_size"));
        *code += &format!(
            "\tsub {}, {} {}\n",
            REG_AUX,
            REG_STEP,
            ctx.comment_str("aux -= step_count_down")
        );
        *code += &format!("\tshl {}, 40 {}\n", REG_AUX, ctx.comment_str("aux <<= 40"));
        *code += &format!(
            "\tadd {}, {} {}\n",
            REG_ADDRESS,
            REG_AUX,
            ctx.comment_str("addr_step += step")
        );

        // Copy read data into mem_reads_address and increment it
        *code += &format!(
            "\tmov [{} + {}*8], {} {}\n",
            REG_MEM_READS_ADDRESS,
            REG_MEM_READS_SIZE,
            REG_ADDRESS,
            ctx.comment_str("mem_reads[@+size*8] = addr_step")
        );

        // Copy read data into mem_reads_address and increment it
        *code += &format!(
            "\tmov [{} + {}*8 + 8], {} {}\n",
            REG_MEM_READS_ADDRESS,
            REG_MEM_READS_SIZE,
            reg_to_store_value,
            ctx.comment(format!("mem_reads[@+size*8+8] = {reg_to_store_value_desc} = a"))
        );

        // Increment chunk.steps.mem_reads_size
        *code += &format!(
            "\tadd {}, 2 {}\n",
            REG_MEM_READS_SIZE,
            ctx.comment_str("mem_reads_size += 2")
        );
    }

    pub(super) fn chunk_player_a_src_mem_not_aligned(ctx: &mut ZiskAsmContext, code: &mut String) {
        // Copy address into reg c
        *code += &format!("\tmov rcx, {} {}\n", REG_ADDRESS, ctx.comment_str("rcx = address"));

        // Calculate address misalignment: 1, 2, 3, 4, 5, 6 or 7 bytes
        *code += &format!("\tand rcx, 0x7 {}\n", ctx.comment_str("rcx = misaligned bytes"));
        *code += &format!("\tshl rcx, 0x3 {}\n", ctx.comment_str("rcx = misaligned bits"));

        // Store previous aligned value in reg value
        *code += &format!(
            "\tmov {}, [{}] {}\n",
            REG_VALUE,
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.comment_str("value = mt[prev_address]")
        );

        // Shif it right the number of address misaligned bits
        *code += &format!("\tshr {}, cl {}\n", REG_VALUE, ctx.comment_str("value >> bits"));

        // Store next aligned value in reg aux
        *code += &format!(
            "\tmov {}, [{} + 8] {}\n",
            REG_AUX,
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.comment_str("aux = mt[next_address]")
        );

        // Shift it left 64 - the number of address misaligned bits
        // Calculate address misalignment: 1, 2, 3, 4, 5, 6 or 7 bytes
        *code += &format!("\tneg rcx {}\n", ctx.comment_str("rcx = 64 - rcx"));
        *code += &format!("\tadd rcx, 0x64 {}\n", ctx.comment_str("rcx = 64 - rcx"));

        // Shif it left the number of address misaligned bits
        *code += &format!("\tshl {}, cl {}\n", REG_AUX, ctx.comment_str("aux << bits"));

        // Shif it right the number of address misaligned bits
        *code += &format!("\tor {}, {} {}\n", REG_VALUE, REG_AUX, ctx.comment_str("value |= aux"));

        // Read value from memory and store in the proper register: a or c
        *code += &format!(
            "\tmov {}, [{}] {}\n",
            if ctx.store_a_in_c { REG_C } else { REG_A },
            REG_VALUE,
            ctx.comment(format!("{} = mt[address]", if ctx.store_a_in_c { "c" } else { "a" }))
        );

        // Increment chunk player address
        *code += &format!(
            "\tadd {}, 16 {}\n",
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.comment_str("chunk_address += 8")
        );
    }

    pub(super) fn chunk_player_b_src_mem_not_aligned(ctx: &mut ZiskAsmContext, code: &mut String) {
        // Copy address into reg c
        *code += &format!("\tmov rcx, {} {}\n", REG_ADDRESS, ctx.comment_str("rcx = address"));

        // Calculate address misalignment: 1, 2, 3, 4, 5, 6 or 7 bytes
        *code += &format!("\tand rcx, 0x7 {}\n", ctx.comment_str("rcx = misaligned bytes"));
        *code += &format!("\tshl rcx, 0x3 {}\n", ctx.comment_str("rcx = misaligned bits"));

        // Store previous aligned value in reg value
        *code += &format!(
            "\tmov {}, [{}] {}\n",
            REG_VALUE,
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.comment_str("value = mt[prev_address]")
        );

        // Shif it right the number of address misaligned bits
        *code += &format!("\tshr {}, cl {}\n", REG_VALUE, ctx.comment_str("value >> bits"));

        // Store next aligned value in reg aux
        *code += &format!(
            "\tmov {}, [{} + 8] {}\n",
            REG_AUX,
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.comment_str("aux = mt[next_address]")
        );

        // Shift it left 64 - the number of address misaligned bits
        // Calculate address misalignment: 1, 2, 3, 4, 5, 6 or 7 bytes
        *code += &format!("\tneg rcx {}\n", ctx.comment_str("rcx = - rcx"));
        *code += &format!("\tadd rcx, 64 {}\n", ctx.comment_str("rcx = 64 - rcx"));

        // Shif it left the number of address misaligned bits
        *code += &format!("\tshl {}, cl {}\n", REG_AUX, ctx.comment_str("aux << bits"));

        // Shif it right the number of address misaligned bits
        *code += &format!("\tor {}, {} {}\n", REG_VALUE, REG_AUX, ctx.comment_str("value |= aux"));

        // Read value from memory and store in the proper register: a or c
        *code += &format!(
            "\tmov {}, {} {}\n",
            if ctx.store_b_in_c { REG_C } else { REG_B },
            REG_VALUE,
            ctx.comment(format!("{} = mt[address]", if ctx.store_b_in_c { "c" } else { "b" }))
        );

        // Increment chunk player address
        *code += &format!(
            "\tadd {}, 16 {}\n",
            REG_CHUNK_PLAYER_ADDRESS,
            ctx.comment_str("chunk_address += 16")
        );
    }

    /// Consumes the mem reads of a b=SRC_IND read, whose address is held in reg_address, and
    /// traces the memory access
    pub(super) fn chunk_player_b_src_ind(
        ctx: &mut ZiskAsmContext,
        instruction: &ZiskInst,
        reg_address: &str,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        if ctx.chunk_player_mt_collect_mem() {
            match instruction.ind_width {
                8 => {
                    // // Check if address is aligned, i.e. it is a multiple of 8
                    *code += &format!(
                        "\ttest {}, 0x7 {}\n",
                        reg_address,
                        ctx.comment_str("address &= 7")
                    );
                    *code += &format!("\tjnz pc_{:x}_b_address_not_aligned\n", ctx.pc);

                    // b memory address is alligned
                    ///////////////////////////////

                    // Read value from memory and store in the proper register: a or c
                    *code += &format!(
                        "\tmov {}, [{}] {}\n",
                        if ctx.store_b_in_c { REG_C } else { REG_B },
                        REG_CHUNK_PLAYER_ADDRESS,
                        ctx.comment(format!(
                            "{} = mt[address]",
                            if ctx.store_b_in_c { "c" } else { "b" }
                        ))
                    );

                    // Increment chunk player address
                    *code += &format!(
                        "\tadd {}, 8 {}\n",
                        REG_CHUNK_PLAYER_ADDRESS,
                        ctx.comment_str("chunk_address += 8")
                    );

                    // b memory address is not aligned
                    //////////////////////////////////

                    *unusual_code += &format!("pc_{:x}_b_address_not_aligned:\n", ctx.pc);

                    Self::chunk_player_b_src_mem_not_aligned(ctx, unusual_code);

                    // Jump to check done
                    *unusual_code += &format!("\tjmp pc_{:x}_b_address_check_done\n", ctx.pc);

                    // Check done
                    *code += &format!("pc_{:x}_b_address_check_done:\n", ctx.pc);
                }
                4 | 2 => {
                    // Copy address into aux
                    *code += &format!(
                        "\tmov {}, {} {}\n",
                        REG_AUX,
                        reg_address,
                        ctx.comment_str("aux = address")
                    );

                    // Calculate previous aligned address
                    *code += &format!(
                        "\tand {}, 0xFFFFFFFFFFFFFFF8 {}\n",
                        reg_address,
                        ctx.comment_str("address = previous aligned address")
                    );

                    // Calculate next aligned address, keeping a copy of previous aligned
                    // address in value
                    *code += &format!(
                        "\tmov {}, {} {}\n",
                        REG_VALUE,
                        reg_address,
                        ctx.comment_str("value = copy of prev_address")
                    );
                    let address_increment = instruction.ind_width - 1;
                    *code += &format!(
                        "\tlea {}, [{} + {}] {}\n",
                        reg_address,
                        REG_AUX,
                        address_increment,
                        ctx.comment(format!("address = original address + {address_increment}"))
                    );
                    *code += &format!(
                        "\tand {}, 0xFFFFFFFFFFFFFFF8 {}\n",
                        reg_address,
                        ctx.comment_str("address = next aligned address")
                    );
                    *code += &format!(
                        "\tcmp {}, {} {}\n",
                        REG_VALUE,
                        reg_address,
                        ctx.comment_str("prev_address = next_address ?")
                    );
                    *code += &format!("\tjnz pc_{:x}_b_ind_different_address\n", ctx.pc);

                    // Same address
                    ///////////////

                    // Read value from memory and store in the proper register: a or c
                    *code += &format!(
                        "\tmov {}, [{}] {}\n",
                        REG_VALUE,
                        REG_CHUNK_PLAYER_ADDRESS,
                        ctx.comment_str("value = mt[address]")
                    );

                    // Increment chunk player address
                    *code += &format!(
                        "\tadd {}, 8 {}\n",
                        REG_CHUNK_PLAYER_ADDRESS,
                        ctx.comment_str("chunk_address += 8")
                    );

                    // Get bits to shift
                    *code += &format!(
                        "\tmov rcx, {} {}\n",
                        REG_AUX,
                        ctx.comment_str("rcx = aux = address")
                    );
                    *code +=
                        &format!("\tand rcx, 0x7 {}\n", ctx.comment_str("rcx = misaligned bytes"));
                    *code +=
                        &format!("\tshl rcx, 0x3 {}\n", ctx.comment_str("rcx = misaligned bits"));

                    // Shif it right the number of address misaligned bits
                    *code +=
                        &format!("\tshr {}, cl {}\n", REG_VALUE, ctx.comment_str("value >> bits"));

                    // Copy into destination register
                    *code += &format!(
                        "\tmov {}, {} {}\n",
                        if ctx.store_b_in_c { REG_C } else { REG_B },
                        REG_VALUE,
                        ctx.comment(format!(
                            "{} = mt[address]",
                            if ctx.store_b_in_c { "c" } else { "b" }
                        ))
                    );

                    // Take the lowest bytes
                    if instruction.ind_width == 2 {
                        *code += &format!(
                            "\tand {}, {} {}\n",
                            if ctx.store_b_in_c { REG_C } else { REG_B },
                            "0xFFFF",
                            ctx.comment_str("take lowest bytes")
                        );
                    } else {
                        *code += &format!(
                            "\tmov {}, 0xFFFFFFFF {}\n",
                            REG_AUX,
                            ctx.comment_str("aux = 4-B mask")
                        );
                        *code += &format!(
                            "\tand {}, {} {}\n",
                            if ctx.store_b_in_c { REG_C } else { REG_B },
                            REG_AUX,
                            ctx.comment_str("take lowest bytes")
                        );
                    }

                    // Different address
                    ////////////////////

                    *unusual_code += &format!("pc_{:x}_b_ind_different_address:\n", ctx.pc);

                    // Get bits to shift
                    *unusual_code += &format!(
                        "\tmov {}, {} {}\n",
                        REG_ADDRESS,
                        REG_AUX,
                        ctx.comment_str("address = aux")
                    );

                    Self::chunk_player_b_src_mem_not_aligned(ctx, unusual_code);

                    // Take the lowest bytes
                    if instruction.ind_width == 2 {
                        *unusual_code += &format!(
                            "\tand {}, {} {}\n",
                            if ctx.store_b_in_c { REG_C } else { REG_B },
                            "0xFFFF",
                            ctx.comment_str("take lowest bytes")
                        );
                    } else {
                        *unusual_code += &format!(
                            "\tmov {}, 0xFFFFFFFF {}\n",
                            REG_AUX,
                            ctx.comment_str("aux = 4-B mask")
                        );
                        *unusual_code += &format!(
                            "\tand {}, {} {}\n",
                            if ctx.store_b_in_c { REG_C } else { REG_B },
                            REG_AUX,
                            ctx.comment_str("take lowest bytes")
                        );
                    }

                    *unusual_code += &format!("\tjmp pc_{:x}_b_ind_address_done\n", ctx.pc);

                    // Done
                    *code += &format!("pc_{:x}_b_ind_address_done:\n", ctx.pc);
                }
                1 => {
                    // // Check if address is aligned, i.e. it is a multiple of 8
                    *code += &format!(
                        "\tand {}, 0x7 {}\n",
                        reg_address,
                        ctx.comment_str("address &= 7")
                    );
                    *code += &format!("\tjnz pc_{:x}_b_address_not_aligned\n", ctx.pc);

                    // b register memory address is alligned
                    ////////////////////////////////////////

                    // Read value from memory and store in the proper register: a or c
                    *code += &format!(
                        "\tmov {}, [{}] {}\n",
                        if ctx.store_b_in_c { REG_C } else { REG_B },
                        REG_CHUNK_PLAYER_ADDRESS,
                        ctx.comment(format!(
                            "{} = mt[address]",
                            if ctx.store_b_in_c { "c" } else { "b" }
                        ))
                    );

                    // Increment chunk player address
                    *code += &format!(
                        "\tadd {}, 8 {}\n",
                        REG_CHUNK_PLAYER_ADDRESS,
                        ctx.comment_str("chunk_address += 8")
                    );

                    // Take the lowest byte
                    *code += &format!(
                        "\tand {}, 0xFF {}\n",
                        if ctx.store_b_in_c { REG_C } else { REG_B },
                        ctx.comment(format!("{} &= 0xF", if ctx.store_b_in_c { "c" } else { "b" }))
                    );

                    // b memory address is not aligned
                    //////////////////////////////////

                    *unusual_code += &format!("pc_{:x}_b_address_not_aligned:\n", ctx.pc);

                    // Read value from memory
                    *unusual_code += &format!(
                        "\tmov {}, [{}] {}\n",
                        REG_VALUE,
                        REG_CHUNK_PLAYER_ADDRESS,
                        ctx.comment_str("value = mt[address]")
                    );

                    // Increment chunk player address
                    *unusual_code += &format!(
                        "\tadd {}, 8 {}\n",
                        REG_CHUNK_PLAYER_ADDRESS,
                        ctx.comment_str("chunk_address += 8")
                    );

                    // Shift right
                    *unusual_code += &format!(
                        "\tmov rcx, {} {}\n",
                        reg_address,
                        ctx.comment_str("rcx = address")
                    );
                    *unusual_code += &format!("\tshl rcx, 3 {}\n", ctx.comment_str("rcx *= 8"));
                    *unusual_code +=
                        &format!("\tshr {}, cl {}\n", REG_VALUE, ctx.comment_str("value >> bits"));

                    // Take the lowest byte
                    *unusual_code += &format!(
                        "\tmov {}, {} {}\n",
                        if ctx.store_b_in_c { REG_C } else { REG_B },
                        REG_VALUE,
                        ctx.comment(format!("{} = c", if ctx.store_b_in_c { "c" } else { "b" }))
                    );
                    *unusual_code += &format!(
                        "\tand {}, 0xFF {}\n",
                        if ctx.store_b_in_c { REG_C } else { REG_B },
                        ctx.comment(format!(
                            "{} &= 0xFF",
                            if ctx.store_b_in_c { "c" } else { "b" }
                        ))
                    );

                    // Jump to check done
                    *unusual_code += &format!("\tjmp pc_{:x}_b_address_check_done\n", ctx.pc);

                    // Check done
                    *code += &format!("pc_{:x}_b_address_check_done:\n", ctx.pc);
                }
                _ => panic!(
                    "ZiskRom2Asm::save_to_asm() Invalid ind_width={} pc={}",
                    instruction.ind_width, ctx.pc
                ),
            }
        }
    }

    fn chunk_player_mem_write(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        width: u64,
        reg_write_value: &str,
        number_of_memory_reads: u64,
    ) {
        assert!(number_of_memory_reads <= 2);

        // Trace memory
        ///////////////

        // Build the mask for this case
        const MICRO_STEP: u64 = 3;
        let addr_step_mask: u64 = (MICRO_STEP << 40)
            + match width {
                1 => F_MOPS_WRITE_1,
                2 => F_MOPS_WRITE_2,
                4 => F_MOPS_WRITE_4,
                8 => F_MOPS_WRITE_8,
                _ => panic!("Invalid width {width}"),
            };

        // Add mask to address
        *code += &format!(
            "\tmov {}, 0x{:x} {}\n",
            REG_AUX,
            addr_step_mask,
            ctx.comment_str("aux = addr_step_mask")
        );
        *code += &format!(
            "\tadd {}, {} {}\n",
            REG_ADDRESS,
            REG_AUX,
            ctx.comment_str("address += addr_step_mask")
        );

        // Build the step and add it to the address
        *code +=
            &format!("\tmov {}, chunk_size {}\n", REG_AUX, ctx.comment_str("aux = chunk_size"));
        *code += &format!(
            "\tsub {}, {} {}\n",
            REG_AUX,
            REG_STEP,
            ctx.comment_str("aux -= step_count_down")
        );
        *code += &format!("\tshl {}, 42 {}\n", REG_AUX, ctx.comment_str("aux <<= 40"));
        *code += &format!(
            "\tadd {}, {} {}\n",
            REG_ADDRESS,
            REG_AUX,
            ctx.comment_str("addr_step += step")
        );

        // Copy read data into mem_reads_address and increment it
        *code += &format!(
            "\tmov [{} + {}*8], {} {}\n",
            REG_MEM_READS_ADDRESS,
            REG_MEM_READS_SIZE,
            REG_ADDRESS,
            ctx.comment_str("mem_reads[@+size*8] = addr_step")
        );
        *code += &format!("\tinc {} {}\n", REG_MEM_READS_SIZE, ctx.comment_str("mem_reads_size++"));

        // Read values from minimal trace
        /////////////////////////////////

        for _i in 0..number_of_memory_reads {
            // Read value from memory and store in the proper register: a or c
            *code += &format!(
                "\tmov {}, [{}] {}\n",
                REG_AUX,
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment("aux = mt[address]".to_string())
            );

            // Increment chunk player address
            *code += &format!(
                "\tadd {}, 8 {}\n",
                REG_CHUNK_PLAYER_ADDRESS,
                ctx.comment_str("chunk_address += 8")
            );

            // Copy read data into mem_reads_address and increment it
            *code += &format!(
                "\tmov [{} + {}*8], {} {}\n",
                REG_MEM_READS_ADDRESS,
                REG_MEM_READS_SIZE,
                REG_ADDRESS,
                ctx.comment_str("mem_reads[@+size*8] = addr_step")
            );
            *code +=
                &format!("\tinc {} {}\n", REG_MEM_READS_SIZE, ctx.comment_str("mem_reads_size++"));
        }

        // Write value
        //////////////

        // Copy write data into mem_reads_address and increment it
        *code += &format!(
            "\tmov [{} + {}*8], {} {}\n",
            REG_MEM_READS_ADDRESS,
            REG_MEM_READS_SIZE,
            reg_write_value,
            ctx.comment_str("mem_reads[@+size*8] = write value")
        );
        *code += &format!("\tinc {} {}\n", REG_MEM_READS_SIZE, ctx.comment_str("mem_reads_size++"));
    }

    /// Consumes the mem reads of a STORE_IND write, whose address is held in REG_ADDRESS, and
    /// traces the memory access
    pub(super) fn chunk_player_c_store_ind(
        ctx: &mut ZiskAsmContext,
        instruction: &ZiskInst,
        address_is_constant: bool,
        address_is_aligned: bool,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        if ctx.chunk_player_mt_collect_mem() {
            match instruction.ind_width {
                8 => {
                    // Check if address is aligned, i.e. it is a multiple of 8
                    if address_is_constant {
                        if address_is_aligned {
                            Self::chunk_player_mem_write(ctx, code, 8, REG_C, 0);
                        } else {
                            Self::chunk_player_mem_write(ctx, code, 8, REG_C, 2);
                        }
                    } else {
                        *code += &format!(
                            "\ttest {}, 0x7 {}\n",
                            REG_ADDRESS,
                            ctx.comment_str("address &= 7")
                        );
                        *code += &format!("\tjnz pc_{:x}_c_address_not_aligned\n", ctx.pc);
                        *unusual_code += &format!("pc_{:x}_c_address_not_aligned:\n", ctx.pc);
                        Self::chunk_player_mem_write(ctx, unusual_code, 8, REG_C, 2);
                        *unusual_code += &format!("\tjmp pc_{:x}_c_address_done\n", ctx.pc);
                        Self::chunk_player_mem_write(ctx, code, 8, REG_C, 0);
                        *code += &format!("pc_{:x}_c_address_done:\n", ctx.pc);
                    }
                }
                4 | 2 => {
                    // Get a copy of the address to preserve it: aux = address
                    *code += &format!(
                        "\tmov {}, {} {}\n",
                        REG_AUX,
                        REG_ADDRESS,
                        ctx.comment_str("aux = address")
                    );

                    // Calculate previous aligned address
                    *code += &format!(
                        "\tand {}, 0xFFFFFFFFFFFFFFF8 {}\n",
                        REG_AUX,
                        ctx.comment_str("address = previous aligned address")
                    );

                    // Calculate next aligned address, keeping a copy of previous aligned
                    // address in value
                    *code += &format!(
                        "\tmov {}, {} {}\n",
                        REG_VALUE,
                        REG_AUX,
                        ctx.comment_str("value = copy of prev_address")
                    );
                    let address_increment = instruction.ind_width - 1;
                    *code += &format!(
                        "\tlea {}, [{} + {}] {}\n",
                        REG_AUX,
                        REG_ADDRESS,
                        address_increment,
                        ctx.comment(format!("address = original address + {address_increment}"))
                    );
                    *code += &format!(
                        "\tand {}, 0xFFFFFFFFFFFFFFF8 {}\n",
                        REG_AUX,
                        ctx.comment_str("address = next aligned address")
                    );
                    *code += &format!(
                        "\tcmp {}, {} {}\n",
                        REG_VALUE,
                        REG_AUX,
                        ctx.comment_str("prev_address = next_address ?")
                    );
                    *code += &format!("\tjnz pc_{:x}_c_ind_different_address\n", ctx.pc);

                    // Same address
                    ///////////////

                    Self::chunk_player_mem_write(ctx, code, instruction.ind_width, REG_C, 1);

                    // Different address
                    ////////////////////

                    *unusual_code += &format!("pc_{:x}_c_ind_different_address:\n", ctx.pc);

                    Self::chunk_player_mem_write(
                        ctx,
                        unusual_code,
                        instruction.ind_width,
                        REG_C,
                        2,
                    );

                    *unusual_code += &format!("\tjmp pc_{:x}_c_ind_address_done\n", ctx.pc);

                    // Done
                    ///////

                    *code += &format!("pc_{:x}_c_ind_address_done:\n", ctx.pc);
                }
                1 => {
                    // Since 1 byte always fits into one alligned 8B chunk, we always
                    // store the chunk in mem_reads

                    Self::chunk_player_mem_write(ctx, code, 1, REG_C, 1);
                }
                _ => panic!(
                    "ZiskRom2Asm::save_to_asm() Invalid ind_width={} pc={}",
                    instruction.ind_width, ctx.pc
                ),
            }
            if ctx.zip() {
                *code += &format!("pc_{:x}_c_active_chunk_done:\n", ctx.pc);
            }
        }
    }

    #[allow(dead_code)]
    fn chunk_player_buffer(
        ctx: &mut ZiskAsmContext,
        code: &mut String,
        buffer_address_register: &str,
        buffer_size: u64,
        write: u64,
    ) {
        assert!(buffer_size > 0);

        // Store address in aux
        *code += &format!(
            "\tmov {}, {} {}\n",
            REG_AUX,
            buffer_address_register,
            ctx.comment_str("aux += buffer_address")
        );

        // Build the mask for this case
        const WIDTH: u64 = 8;
        const MICRO_STEP: u64 = 2;
        let addr_step_mask: u64 =
            if write == 0 { F_MOPS_READ_8 } else { F_MOPS_WRITE_8 } + (MICRO_STEP << 40);

        // For every element
        for i in 0..buffer_size {
            // Load address first, increment it later
            if i == 0 {
                // Store address in aux
                *code += &format!(
                    "\tmov {}, {} {}\n",
                    REG_AUX,
                    buffer_address_register,
                    ctx.comment_str("aux += buffer_address")
                );
            } else {
                *code +=
                    &format!("\tadd {}, 8 {}\n", REG_AUX, ctx.comment_str("buffer_address += 8"));
            }

            // Trace memory
            ///////////////

            // Build the step into value
            *code += &format!(
                "\tmov {}, chunk_size {}\n",
                REG_VALUE,
                ctx.comment_str("value = chunk_size")
            );
            *code += &format!(
                "\tsub {}, {} {}\n",
                REG_VALUE,
                REG_STEP,
                ctx.comment_str("value -= step_count_down")
            );
            *code += &format!("\tshl {}, 42 {}\n", REG_VALUE, ctx.comment_str("value <<= 40"));

            // Add mask to value
            *code += &format!(
                "\tadd {}, 0x{:x} {}\n",
                REG_VALUE,
                addr_step_mask,
                ctx.comment_str("value = addr_step_mask")
            );

            // Add address to value
            *code += &format!(
                "\tadd {}, {} {}\n",
                REG_VALUE,
                REG_AUX,
                ctx.comment_str("value += address")
            );

            // Copy read data into mem_reads_address and increment it
            *code += &format!(
                "\tmov [{} + {}*8 + {}*8], {} {}\n",
                REG_MEM_READS_ADDRESS,
                REG_MEM_READS_SIZE,
                2 * i,
                REG_VALUE,
                ctx.comment_str("mem_reads[@+size*8] = addr_step")
            );

            // Trace value
            //////////////

            // Read value
            *code += &format!(
                "\tmov {}, [{} + {}*8] {}\n",
                REG_VALUE,
                REG_CHUNK_PLAYER_ADDRESS,
                i,
                ctx.comment("value = mt[address]".to_string())
            );

            // Trace value
            *code += &format!(
                "\tmov [{} + {}*8 + {}*8], {} {}\n",
                REG_MEM_READS_ADDRESS,
                REG_MEM_READS_SIZE,
                (2 * i) + 1,
                REG_VALUE,
                ctx.comment_str("mem_reads[@+size*8] = value")
            );
        }

        // Increment mem reads size
        *code += &format!(
            "\tadd {}, {} {}\n",
            REG_MEM_READS_SIZE,
            buffer_size * 2,
            ctx.comment_str("mem_reads_size += buffer_size")
        );

        // Increment chunk player address
        *code += &format!(
            "\tadd {}, 8*{} {}\n",
            REG_CHUNK_PLAYER_ADDRESS,
            buffer_size,
            ctx.comment_str("chunk_address += 8*buffer_size")
        );
    }
}
