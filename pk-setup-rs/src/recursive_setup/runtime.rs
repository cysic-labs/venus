use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{bail, Result};

use crate::recursive_setup::plonk::PlonkAddition;
use crate::recursive_setup::r1cs::R1cs;

const MAGIC: &[u8; 8] = b"PIL2RSPD";
const VERSION: u64 = 1;
const TEMPLATE_PER_AIR: u64 = 0;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RuntimeDescriptor {
    pub template_id: u64,
    pub size_witness_words: u64,
    pub n_publics: u64,
    pub public_input_offset_words: u64,
    pub public_input_copy_words: u64,
    pub copy_indices: Vec<u64>,
    pub source_public_prefix_words: u64,
}

impl RuntimeDescriptor {
    pub fn for_r1cs(r1cs: &R1cs) -> Self {
        let n_publics = u64::from(r1cs.n_outputs + r1cs.n_pub_inputs);
        Self {
            template_id: TEMPLATE_PER_AIR,
            size_witness_words: u64::from(r1cs.n_vars),
            n_publics,
            public_input_offset_words: 1,
            public_input_copy_words: n_publics,
            copy_indices: (0..n_publics).collect(),
            source_public_prefix_words: u64::from(r1cs.n_vars.saturating_sub(1)),
        }
    }
}

pub fn write_runtime_dat_file(path: &Path, r1cs: &R1cs) -> Result<()> {
    fs::write(path, runtime_dat_buffer(&RuntimeDescriptor::for_r1cs(r1cs))?)
        .map_err(|err| anyhow::anyhow!("failed to write {}: {err}", path.display()))
}

pub fn runtime_dat_buffer(descriptor: &RuntimeDescriptor) -> Result<Vec<u8>> {
    let mut out = Vec::new();
    out.extend_from_slice(MAGIC);
    push_u64(&mut out, VERSION);
    push_u64(&mut out, descriptor.template_id);
    push_u64(&mut out, descriptor.size_witness_words);
    push_u64(&mut out, descriptor.n_publics);
    push_u64(&mut out, descriptor.public_input_offset_words);
    push_u64(&mut out, descriptor.public_input_copy_words);
    push_u64(&mut out, descriptor.copy_indices.len() as u64);
    for index in &descriptor.copy_indices {
        push_u64(&mut out, *index);
    }

    push_u64(&mut out, 0); // source assertions
    push_u64(&mut out, descriptor.source_public_prefix_words);
    push_u64(&mut out, 0); // source sections
    push_u64(&mut out, 0); // section copy ops
    Ok(out)
}

pub fn write_exec_sidecars(
    setup_path: &Path,
    r1cs: &R1cs,
    additions: &[PlonkAddition],
    signal_map: &[Vec<u32>],
) -> Result<()> {
    fs::write(sidecar_path(setup_path, "additions.bin"), exec_additions_buffer(additions)?)?;
    fs::write(sidecar_path(setup_path, "smap.bin"), exec_smap_buffer(signal_map)?)?;
    fs::write(sidecar_path(setup_path, "wiremap.bin"), exec_wiremap_buffer(r1cs)?)?;
    Ok(())
}

pub fn exec_additions_buffer(additions: &[PlonkAddition]) -> Result<Vec<u8>> {
    let mut out = Vec::with_capacity(8 + additions.len() * 24);
    push_u64(&mut out, additions.len() as u64);
    for addition in additions {
        push_u32(&mut out, addition.sl);
        push_u32(&mut out, addition.sr);
        push_u64(&mut out, addition.ql);
        push_u64(&mut out, addition.qr);
    }
    Ok(out)
}

pub fn exec_smap_buffer(signal_map: &[Vec<u32>]) -> Result<Vec<u8>> {
    if signal_map.is_empty() {
        bail!("cannot write recursive exec signal-map sidecar for empty signal map");
    }
    let n_rows = signal_map[0].len();
    if signal_map.iter().any(|col| col.len() != n_rows) {
        bail!("all recursive exec signal-map columns must have the same row count");
    }

    let n_cols = signal_map.len();
    let mut out = Vec::with_capacity(16 + n_cols * n_rows * 4);
    push_u64(&mut out, n_cols as u64);
    push_u64(&mut out, n_rows as u64);
    for row in 0..n_rows {
        for col in signal_map {
            push_u32(&mut out, col[row]);
        }
    }
    Ok(out)
}

pub fn exec_wiremap_buffer(r1cs: &R1cs) -> Result<Vec<u8>> {
    let wire_map = if r1cs.wire_map.is_empty() {
        (0..u64::from(r1cs.n_vars)).collect::<Vec<_>>()
    } else {
        r1cs.wire_map.clone()
    };

    let mut out = Vec::with_capacity(8 + wire_map.len() * 8);
    push_u64(&mut out, wire_map.len() as u64);
    for signal in wire_map {
        push_u64(&mut out, signal);
    }
    Ok(out)
}

fn sidecar_path(setup_path: &Path, suffix: &str) -> PathBuf {
    PathBuf::from(format!("{}.exec.{suffix}", setup_path.display()))
}

fn push_u32(out: &mut Vec<u8>, value: u32) {
    out.extend_from_slice(&value.to_le_bytes());
}

fn push_u64(out: &mut Vec<u8>, value: u64) {
    out.extend_from_slice(&value.to_le_bytes());
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::recursive_setup::r1cs::{R1cs, GOLDILOCKS_P};

    fn synthetic_r1cs() -> R1cs {
        R1cs {
            n8: 8,
            prime: GOLDILOCKS_P,
            n_vars: 4,
            n_outputs: 1,
            n_pub_inputs: 2,
            n_prv_inputs: 0,
            n_labels: 0,
            n_constraints: 0,
            constraints: Vec::new(),
            wire_map: vec![0, 3, 1, 2],
            custom_gates: Vec::new(),
            custom_gate_uses: Vec::new(),
        }
    }

    #[test]
    fn writes_native_runtime_descriptor_header() -> Result<()> {
        let buffer = runtime_dat_buffer(&RuntimeDescriptor::for_r1cs(&synthetic_r1cs()))?;
        assert_eq!(&buffer[..8], MAGIC);
        assert_eq!(u64::from_le_bytes(buffer[8..16].try_into()?), VERSION);
        assert_eq!(u64::from_le_bytes(buffer[24..32].try_into()?), 4);
        assert_eq!(u64::from_le_bytes(buffer[32..40].try_into()?), 3);
        assert_eq!(u64::from_le_bytes(buffer[56..64].try_into()?), 3);
        Ok(())
    }

    #[test]
    fn writes_exec_sidecar_buffers() -> Result<()> {
        let additions = vec![PlonkAddition { sl: 2, sr: 3, ql: 5, qr: 7 }];
        let signal_map = vec![vec![1, 2], vec![3, 4]];

        let additions = exec_additions_buffer(&additions)?;
        assert_eq!(additions.len(), 32);
        assert_eq!(u64::from_le_bytes(additions[0..8].try_into()?), 1);
        assert_eq!(u32::from_le_bytes(additions[8..12].try_into()?), 2);
        assert_eq!(u32::from_le_bytes(additions[12..16].try_into()?), 3);

        let smap = exec_smap_buffer(&signal_map)?;
        assert_eq!(u64::from_le_bytes(smap[0..8].try_into()?), 2);
        assert_eq!(u64::from_le_bytes(smap[8..16].try_into()?), 2);
        assert_eq!(u32::from_le_bytes(smap[16..20].try_into()?), 1);
        assert_eq!(u32::from_le_bytes(smap[20..24].try_into()?), 3);
        assert_eq!(u32::from_le_bytes(smap[24..28].try_into()?), 2);
        assert_eq!(u32::from_le_bytes(smap[28..32].try_into()?), 4);

        let wiremap = exec_wiremap_buffer(&synthetic_r1cs())?;
        assert_eq!(u64::from_le_bytes(wiremap[0..8].try_into()?), 4);
        assert_eq!(u64::from_le_bytes(wiremap[16..24].try_into()?), 3);
        Ok(())
    }
}
