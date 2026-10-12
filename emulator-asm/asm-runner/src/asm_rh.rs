use std::fmt::Debug;

use anyhow::{anyhow, Context, Result};

use crate::{AsmSharedMemory, AsmShmemHeader};

#[repr(C)]
#[derive(Debug, Default)]
pub struct AsmRHHeader {
    pub version: u64,
    pub exit_code: u64,
    pub shmem_allocated_size: u64,
    pub steps: u64,
}

impl AsmShmemHeader for AsmRHHeader {
    fn allocated_size(&self) -> u64 {
        self.shmem_allocated_size
    }
}

#[repr(C)]
#[derive(Debug, Default)]
pub struct AsmRHData {
    pub steps: u64,
    pub bios_inst_count: Vec<u64>,
    pub prog_inst_count: Vec<u64>,
}

impl AsmRHData {
    pub fn new(steps: u64, bios_inst_count: Vec<u64>, prog_inst_count: Vec<u64>) -> Self {
        AsmRHData { steps, bios_inst_count, prog_inst_count }
    }
}

impl AsmRHData {
    /// Copies the ROM histogram out of shared memory: a length-prefixed section of BIOS
    /// instruction counts followed by a length-prefixed section of program instruction counts.
    pub fn from_shared_memory(
        asm_shared_memory: &AsmSharedMemory<AsmRHHeader>,
    ) -> Result<AsmRHData> {
        let data = asm_shared_memory.data_words();
        let (bios_inst_count, data) =
            split_length_prefixed(data).context("Invalid ROM histogram BIOS section")?;
        let (prog_inst_count, _) =
            split_length_prefixed(data).context("Invalid ROM histogram program section")?;

        Ok(AsmRHData {
            steps: asm_shared_memory.map_header().steps,
            bios_inst_count: bios_inst_count.to_vec(),
            prog_inst_count: prog_inst_count.to_vec(),
        })
    }
}

/// Splits a section prefixed by its `u64` length off the front of `data`.
fn split_length_prefixed(data: &[u64]) -> Result<(&[u64], &[u64])> {
    let (&len, rest) = data.split_first().ok_or_else(|| anyhow!("missing section length"))?;
    match usize::try_from(len) {
        Ok(len) if len <= rest.len() => Ok(rest.split_at(len)),
        _ => Err(anyhow!("section length {len} exceeds the {} mapped words", rest.len())),
    }
}
