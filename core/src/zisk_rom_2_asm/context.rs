//! Context of the generation: the generation method and options, the state of the registers
//! a, b and c of the instruction being generated, and the names of the memory variables

use super::control_flow::JumpRegion;
use crate::{zisk_ops::ZiskOp, AsmGenerationMethod, ZiskRom};

#[derive(Default, Debug, Clone)]
pub struct ZiskAsmRegister {
    pub(super) is_constant: bool, // register is a constant value known at compilation time
    pub(super) constant_value: u64, // register constant value, only valid if is_constant==true
    pub(super) is_saved: bool,    // register has been saved to memory/register
    pub(super) string_value: String, // register string value: a constant value (e.g. "0x3f") or a register
                                     // (e.g. "rax")
}

#[derive(Default, Debug, Clone)]
pub struct ZiskAsmContext {
    pub(super) pc: u64,
    pub(super) next_pc: u64,
    pub(super) flag_is_always_one: bool,
    pub(super) flag_is_always_zero: bool,
    pub(super) jump_to_dynamic_pc: bool,
    pub(super) jump_to_static_pc: String,
    pub(super) log_output: bool,
    pub(super) call_chunk_done: bool,
    pub(super) mode: AsmGenerationMethod,
    pub(super) a: ZiskAsmRegister,
    pub(super) b: ZiskAsmRegister,
    pub(super) c: ZiskAsmRegister,

    pub(super) address_is_constant: bool, // true if address is a constant value
    pub(super) address_constant_value: u64, // address constant value, only valid if address_is_constant==true

    // Dynamic jump table: BIOS entries, one per 4-byte aligned pc up to max_bios_pc, followed by
    // the program and float library regions
    pub(super) max_bios_pc: u64,
    pub(super) jump_regions: Vec<JumpRegion>,

    // Bit mask of the AsmError codes whose per-pc error label has been emitted for the current pc
    pub(super) error_labels: u64,

    // Force in which register a or b must be stored
    pub(super) store_a_in_c: bool,
    pub(super) store_a_in_a: bool,
    pub(super) store_b_in_c: bool,
    pub(super) store_b_in_b: bool,

    // Memory variables
    pub(super) mem_step: String,
    pub(super) mem_sp: String,
    pub(super) mem_end: String,
    pub(super) mem_error: String,
    pub(super) mem_error_pc: String,
    pub(super) mem_trace_address: String,
    pub(super) mem_chunk_address: String,
    pub(super) mem_chunk_start_step: String,
    pub(super) fcall_ctx: String,
    pub(super) mem_chunk_id: String,   // 0, 1, 2, 3, 4...
    pub(super) mem_chunk_mask: String, // Module 8 of the chunks we want to activate, e.g. 0x03
    pub(super) mem_rsp: String,        // Backup of rsp register value from caller
    pub(super) mem_free_input: String, // Free input address (0x40000000) used in free call operations, but stored in memory to allow sharing the input shared memory
    pub(super) mem_precompile_results_address: String, // Address where precompile results are read from
    pub(super) mem_precompile_written_address: String, // Address where precompile written counter is stored
    pub(super) mem_precompile_read_address: String, // Address where precompile read counter is stored
    pub(super) mem_input_written_address: String,   // Address where input written counter is stored

    pub(super) comments: bool, // true if we want to generate comments in the assembly source code
    pub(super) boc: String,    // begin of comment: '/*', ';', '#', etc.
    pub(super) eoc: String,    // end of comment: '*/', '', etc

    pub(super) ptr: String, // "ptr ", ""

    //assert_rsp_counter: u64,
    pub(super) precompile_results: bool, // Set to true is we are consuming precompile results
    pub(super) wait_for_prec_counter: u64, // Counter of wait_for_prec_avail calls, reset at every instruction
}

impl ZiskAsmContext {
    /// Creates the context of a generation, with the names of the memory variables used by the
    /// generated code
    pub(super) fn new(
        rom: &ZiskRom,
        generation_method: AsmGenerationMethod,
        log_output: bool,
        comments: bool,
        precompile_results: bool,
    ) -> ZiskAsmContext {
        let mut ctx = ZiskAsmContext {
            log_output,
            call_chunk_done: true,
            mode: generation_method,
            comments,
            boc: "/* ".to_string(),
            eoc: " */".to_string(),
            max_bios_pc: rom.max_bios_pc,
            jump_regions: JumpRegion::from_rom(rom),
            precompile_results,
            ..Default::default()
        };

        ctx.ptr = "ptr ".to_string();
        ctx.mem_step = format!("qword {}[MEM_STEP]", ctx.ptr);
        ctx.mem_sp = format!("qword {}[MEM_SP]", ctx.ptr);
        ctx.mem_end = format!("qword {}[MEM_END]", ctx.ptr);
        ctx.mem_error = format!("qword {}[MEM_ERROR]", ctx.ptr);
        ctx.mem_error_pc = format!("qword {}[MEM_ERROR_PC]", ctx.ptr);
        ctx.mem_trace_address = format!("qword {}[MEM_TRACE_ADDRESS]", ctx.ptr);
        ctx.mem_chunk_address = format!("qword {}[MEM_CHUNK_ADDRESS]", ctx.ptr);
        ctx.mem_chunk_start_step = format!("qword {}[MEM_CHUNK_START_STEP]", ctx.ptr);
        ctx.fcall_ctx = "fcall_ctx".to_string();
        ctx.mem_chunk_id = format!("qword {}[MEM_CHUNK_ID]", ctx.ptr);
        ctx.mem_chunk_mask = format!("qword {}[chunk_mask]", ctx.ptr);
        ctx.mem_rsp = format!("qword {}[MEM_RSP]", ctx.ptr);
        ctx.mem_free_input = format!("qword {}[MEM_FREE_INPUT]", ctx.ptr);
        if ctx.precompile_results() {
            ctx.mem_precompile_results_address =
                format!("qword {}[MEM_PRECOMPILE_RESULTS_ADDRESS]", ctx.ptr);
            ctx.mem_precompile_written_address = format!("qword {}[0x70000000]", ctx.ptr);
            ctx.mem_precompile_read_address = format!("qword {}[0x70001000]", ctx.ptr);
        }
        ctx.mem_input_written_address = format!("qword {}[0x70000010]", ctx.ptr);

        ctx
    }

    pub fn fast(&self) -> bool {
        self.mode == AsmGenerationMethod::AsmFast
    }
    pub fn minimal_trace(&self) -> bool {
        self.mode == AsmGenerationMethod::AsmMinimalTraces
    }
    pub fn rom_histogram(&self) -> bool {
        self.mode == AsmGenerationMethod::AsmRomHistogram
    }
    pub fn main_trace(&self) -> bool {
        self.mode == AsmGenerationMethod::AsmMainTrace
    }
    pub fn chunks(&self) -> bool {
        self.mode == AsmGenerationMethod::AsmChunks
    }
    pub fn zip(&self) -> bool {
        self.mode == AsmGenerationMethod::AsmZip
    }
    pub fn mem_op(&self) -> bool {
        self.mode == AsmGenerationMethod::AsmMemOp
    }
    pub fn chunk_player_mt_collect_mem(&self) -> bool {
        self.mode == AsmGenerationMethod::AsmChunkPlayerMTCollectMem
    }
    pub fn mem_reads(&self) -> bool {
        self.mode == AsmGenerationMethod::AsmMemReads
    }
    pub fn chunk_player_mem_reads_collect_main(&self) -> bool {
        self.mode == AsmGenerationMethod::AsmChunkPlayerMemReadsCollectMain
    }
    // Creates a comment with the specified prefix and sufix, i.e. with the requested syntax
    pub fn comment(&self, c: String) -> String {
        let mut s = String::new();
        if self.comments {
            s = format!("{}{}{}", self.boc, c, self.eoc);
        }
        s
    }

    // Creates a comment from a str
    pub fn comment_str(&self, c: &str) -> String {
        self.comment(c.to_string())
    }

    // Creates a full-line comment
    pub fn full_line_comment(&self, c: String) -> String {
        let mut s = String::new();
        if self.comments {
            s = format!("\t{}{}{}\n", self.boc, c, self.eoc);
        }
        s
    }

    pub fn op_is_precompiled(&self, zisk_op: &ZiskOp) -> bool {
        matches!(
            zisk_op,
            ZiskOp::Keccak
                | ZiskOp::Sha256
                | ZiskOp::Poseidon2
                | ZiskOp::Arith256
                | ZiskOp::Arith256Mod
                | ZiskOp::Secp256k1Add
                | ZiskOp::Secp256k1Dbl
                | ZiskOp::Bn254CurveAdd
                | ZiskOp::Bn254CurveDbl
                | ZiskOp::Bn254ComplexAdd
                | ZiskOp::Bn254ComplexSub
                | ZiskOp::Bn254ComplexMul
                | ZiskOp::Arith384Mod
                | ZiskOp::Bls12_381CurveAdd
                | ZiskOp::Bls12_381CurveDbl
                | ZiskOp::Bls12_381ComplexAdd
                | ZiskOp::Bls12_381ComplexSub
                | ZiskOp::Bls12_381ComplexMul
                | ZiskOp::Add256
                | ZiskOp::Secp256r1Add
                | ZiskOp::Secp256r1Dbl
                | ZiskOp::Blake2
        )
    }

    pub fn precompile_results(&self) -> bool {
        self.precompile_results
    }
    pub fn precompile_results_keccak(&self) -> bool {
        //self.precompile_results()
        false
    }
    pub fn precompile_results_sha256(&self) -> bool {
        //self.precompile_results()
        false
    }
    pub fn precompile_results_arith256(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_arith256mod(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_secp256k1add(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_secp256k1dbl(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_secp256r1add(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_secp256r1dbl(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_fcall(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_bn254curveadd(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_bn254curvedbl(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_bn254complexadd(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_bn254complexsub(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_bn254complexmul(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_arith384mod(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_bls12_381curveadd(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_bls12_381curvedbl(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_bls12_381complexadd(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_bls12_381complexsub(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_bls12_381complexmul(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_add256(&self) -> bool {
        self.precompile_results()
    }
    pub fn precompile_results_blake2(&self) -> bool {
        //self.precompile_results()
        false
    }
    pub fn call_wait_for_prec_avail(&self) -> bool {
        self.precompile_results()
    }
}

// One-pass (single emulation) memory trace, used to count, plan and collect.
// If ZisK instruction contains at least one memory operation:
//   [32b] header (from higher bits to lower bits)
//     [1b] read_a
//       0 = no reg a mem op
//       1 = one reg a mem op
//     [3b] read_b
//       0 = no reg b mem op
//       1 = one reg b mem op of width 1
//       2 = one reg b mem op of width 2
//       3 = one reg b mem op of width 4
//       4 = one reg b mem op of width 8
//     [3b] write
//       0 = no write op
//       1 = one write c mem op of width 1
//       2 = one write c mem op of width 2
//       3 = one write c mem op of width 4
//       4 = one write c mem op of width 8
//       5 = one precompiled mem op of contiguous addresses
//       6 = one precompiled mem op of non-contiguous addresses
//     [25b] relative step: lower bits of step
// If header.read_a == 1:
//   [32b] a mem address
// If header.read_b == 1, 2, 3 or 4:
//   [32b] b mem address
// If header.write == 1, 2, 3 or 4
//   [32b] c mem address
//   [64b] c write value
// If header.write == 5
//   [32b] prec_cont_count = prec_read_count + prec_write_count<<16
//   [32b] prec_const_address
//   [64b x prec_write_count] prec_cont_write_data
// If header.write == 6
//   [32b] prec_non_cont_count = prec_read_count + prec_write_count<<16
//   [32b x prec_read_count] prec_non_cont_read_address = precompiled read addresses
//   [32b x prec_write_count] prec_non_const_write_address = precompiled write addresses
//   [64b x prec_write_count] prec_non_const_write_data = precompiled write data
// If not aligned to 64b
//   [32b] padding zeros

// pub struct ZiskAsmMemTraceContext {
//     // Header mask
//     header_mask: u32,

//     // a, b and c
//     a_mem_address_offset: u64,
//     b_mem_address_offset: u64,
//     c_mem_address_offset: u64,
//     c_write_value_offset: u64,

//     // Precompiled with continuous data
//     prec_cont_count_offset: u64,
//     prec_cont_address_offset: u64,
//     prec_cont_write_data_offset: u64,

//     // Precompiled with non-continuous data
//     prec_non_cont_count_offset: u64,
//     prec_non_cont_read_address_offset: u64,
//     prec_non_cont_write_address_offset: u64,
//     prec_non_cont_write_data_offset: u64,
// }
// const MEM_TRACE_HEADER_READ_A: u32 = 1u32 << 31;
// const MEM_TRACE_HEADER_READ_B_1: u32 = 1u32 << 27;
// const MEM_TRACE_HEADER_READ_B_2: u32 = 2u32 << 27;
// const MEM_TRACE_HEADER_READ_B_4: u32 = 3u32 << 27;
// const MEM_TRACE_HEADER_READ_B_8: u32 = 4u32 << 27;
// const MEM_TRACE_HEADER_WRITE_C_1: u32 = 1u32 << 24;
// const MEM_TRACE_HEADER_WRITE_C_2: u32 = 2u32 << 24;
// const MEM_TRACE_HEADER_WRITE_C_4: u32 = 3u32 << 24;
// const MEM_TRACE_HEADER_WRITE_C_8: u32 = 4u32 << 24;
// const MEM_TRACE_HEADER_WRITE_PREC_CONT: u32 = 5u32 << 24;
// const MEM_TRACE_HEADER_WRITE_PREC_NON_CONT: u32 = 6u32 << 24;

// impl ZiskAsmMemTraceContext {
//     pub fn reset(&mut self) {
//         self.header_mask = 0;
//         self.a_mem_address_offset = 0;
//         self.b_mem_address_offset = 0;
//         self.c_mem_address_offset = 0;
//         self.c_write_value_offset = 0;

//         self.prec_cont_count_offset = 0;
//         self.prec_cont_address_offset = 0;
//         self.prec_cont_write_data_offset = 0;

//         self.prec_non_cont_count_offset = 0;
//         self.prec_non_cont_read_address_offset = 0;
//         self.prec_non_cont_write_address_offset = 0;
//         self.prec_non_cont_write_data_offset = 0;
//     }
//     pub fn configure(&mut self, instruction: &ZiskInst) {
//         let mut offset: u64 = 4;

//         if instruction.a_src == SRC_MEM {
//             self.header_mask |= TRACE_CONTEXT_HEADER_READ_A;
//             self.a_mem_address_offset = offset;
//             offset += 4;
//         }
//         if instruction.b_src == SRC_MEM {
//             self.header_mask |= TRACE_CONTEXT_HEADER_READ_B_8;
//             self.b_mem_address_offset = offset;
//             offset += 4;
//         }
//         if instruction.b_src == SRC_IND {
//             match instruction.ind_width {
//                 1 => self.header_mask |= TRACE_CONTEXT_HEADER_READ_B_1,
//                 2 => self.header_mask |= TRACE_CONTEXT_HEADER_READ_B_2,
//                 4 => self.header_mask |= TRACE_CONTEXT_HEADER_READ_B_4,
//                 8 => self.header_mask |= TRACE_CONTEXT_HEADER_READ_B_8,
//                 _ => {
//                     panic!(
//                         "ZiskAsmMemTraceContext::configure() invalid instruction.ind_width={}",
//                         instruction.ind_width
//                     );
//                 }
//             }
//             self.b_mem_address_offset = offset;
//             offset += 4;
//         }
//         if instruction.store == STORE_MEM {
//             self.header_mask |= TRACE_CONTEXT_HEADER_WRITE_C_8;
//             self.c_mem_address_offset = offset;
//             offset += 4;
//         }
//         if instruction.store == STORE_IND {
//             match instruction.ind_width {
//                 1 => self.header_mask |= TRACE_CONTEXT_HEADER_WRITE_C_1,
//                 2 => self.header_mask |= TRACE_CONTEXT_HEADER_WRITE_C_2,
//                 4 => self.header_mask |= TRACE_CONTEXT_HEADER_WRITE_C_4,
//                 8 => self.header_mask |= TRACE_CONTEXT_HEADER_WRITE_C_4,
//                 _ => {
//                     panic!(
//                         "ZiskAsmMemTraceContext::configure() invalid instruction.ind_width={}",
//                         instruction.ind_width
//                     );
//                 }
//             }
//             self.c_mem_address_offset = offset;
//             offset += 4;
//             self.c_write_value_offset = offset;
//             offset += 8;
//         }
//         if instruction.op == ZiskOp::Keccak.code() || instruction.op == ZiskOp::Sha256.code() {
//             self.header_mask |= TRACE_CONTEXT_HEADER_WRITE_PREC_CONT;
//             self.prec_cont_count_offset = offset;
//             offset += 4;
//             self.prec_cont_address_offset = offset;
//             offset += 4;
//             self.prec_cont_write_data_offset = offset;
//             offset += 4;
//         }
//     }
// }
