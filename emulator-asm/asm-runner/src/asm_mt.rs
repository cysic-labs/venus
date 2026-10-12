use std::borrow::Cow;
use std::fmt::Debug;
use zisk_common::EmuTrace;
use zisk_common::EmuTraceStart;
use zisk_core::{REGS_IN_MAIN_FROM, REGS_IN_MAIN_TO, REGS_IN_MAIN_TOTAL_NUMBER};

use crate::{AsmShmemChunk, AsmShmemHeader};

#[repr(C)]
#[derive(Debug)]
pub struct AsmMTHeader {
    pub version: u64,
    pub exit_code: u64,
    pub shmem_allocated_size: u64,
    pub shmem_used_size: u64,
    pub num_chunks: u64,
}

impl AsmShmemHeader for AsmMTHeader {
    fn allocated_size(&self) -> u64 {
        self.shmem_allocated_size
    }
}

#[repr(C)]
#[derive(Debug)]
pub struct AsmMTChunk {
    pub pc: u64,
    pub sp: u64,
    pub c: u64,
    pub step: u64,
    pub registers: [u64; 33],
    pub last_c: u64,
    pub end: u64,
    pub steps: u64,
    pub mem_reads_size: u64,
}

// SAFETY: repr(C) struct of u64 fields.
unsafe impl AsmShmemChunk for AsmMTChunk {
    fn payload_len(&self) -> u64 {
        self.mem_reads_size
    }
}

impl AsmMTChunk {
    /// Builds the `EmuTrace` of this chunk, borrowing its memory reads from shared memory
    /// without copying them.
    pub fn to_emu_trace(&self, mem_reads: &'static [u64]) -> EmuTrace {
        let mut registers = [0u64; REGS_IN_MAIN_TOTAL_NUMBER];
        registers[REGS_IN_MAIN_FROM..].copy_from_slice(&self.registers[..REGS_IN_MAIN_TO]);

        EmuTrace {
            start_state: EmuTraceStart {
                pc: self.pc,
                sp: self.sp,
                c: self.c,
                step: self.step,
                regs: registers,
            },
            last_c: self.last_c,
            end: self.end == 1,
            steps: self.steps,
            mem_reads: Cow::Borrowed(mem_reads),
        }
    }
}

#[repr(C)]
#[derive(Debug)]
pub struct AsmInputHeader {
    pub zero: u64, // Not used
    pub input_data_size: u64,
}

impl AsmInputHeader {
    pub fn to_bytes(&self) -> Vec<u8> {
        let mut bytes = Vec::with_capacity(32);
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&self.input_data_size.to_le_bytes());
        bytes
    }
}
