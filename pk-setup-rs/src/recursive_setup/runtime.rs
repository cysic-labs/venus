use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{bail, Result};

use crate::recursive_setup::plonk::PlonkAddition;
use crate::recursive_setup::r1cs::R1cs;

const MAGIC: &[u8; 8] = b"PIL2RSPD";
const VERSION: u64 = 3;
const TEMPLATE_PER_AIR: u64 = 0;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RuntimeDescriptor {
    pub template_id: u64,
    pub size_witness_words: u64,
    pub n_publics: u64,
    pub public_input_offset_words: u64,
    pub public_input_copy_words: u64,
    pub copy_indices: Vec<u64>,
    pub source_assertions: Vec<RuntimeAssertion>,
    pub source_public_prefix_words: u64,
    pub source_sections: Vec<RuntimeSection>,
    pub section_copy_ops: Vec<RuntimeSectionCopyOp>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RuntimeAssertion {
    pub source_word: u64,
    pub expected: u64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RuntimeSection {
    pub start_word: u64,
    pub word_len: u64,
    pub kind: u64,
    pub flags: u64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RuntimeSectionCopyOp {
    pub section_index: u64,
    pub section_offset_words: u64,
    pub word_len: u64,
    pub witness_offset_words: u64,
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
            source_assertions: Vec::new(),
            source_public_prefix_words: u64::from(r1cs.n_vars.saturating_sub(1)),
            source_sections: Vec::new(),
            section_copy_ops: Vec::new(),
        }
    }

    pub fn for_circom_main_inputs(
        r1cs: &R1cs,
        input_signal_start: u64,
        input_signal_count: u64,
        signal_replacements: &[(u64, u64)],
    ) -> Self {
        let n_publics = u64::from(r1cs.n_outputs + r1cs.n_pub_inputs);
        let wire_map = if r1cs.wire_map.is_empty() {
            (0..u64::from(r1cs.n_vars)).collect::<Vec<_>>()
        } else {
            r1cs.wire_map.clone()
        };
        let signal_to_wire = wire_map
            .iter()
            .enumerate()
            .map(|(wire, &signal)| (signal, wire as u64))
            .collect::<HashMap<_, _>>();
        let replacement_map = signal_replacements.iter().copied().collect::<HashMap<_, _>>();
        let mut section_copy_ops = Vec::new();
        for source_offset in 0..input_signal_count {
            let signal = input_signal_start + source_offset;
            if let Some(wire) = resolve_input_signal_wire(signal, &signal_to_wire, &replacement_map)
            {
                section_copy_ops.push(RuntimeSectionCopyOp {
                    section_index: 0,
                    section_offset_words: source_offset,
                    word_len: 1,
                    witness_offset_words: wire,
                });
            }
        }

        Self {
            template_id: TEMPLATE_PER_AIR,
            size_witness_words: u64::from(r1cs.n_vars),
            n_publics,
            public_input_offset_words: 0,
            public_input_copy_words: 0,
            copy_indices: Vec::new(),
            source_assertions: Vec::new(),
            source_public_prefix_words: 0,
            source_sections: vec![RuntimeSection {
                start_word: 0,
                word_len: input_signal_count,
                kind: 0,
                flags: 0,
            }],
            section_copy_ops,
        }
    }
}

fn resolve_input_signal_wire(
    signal: u64,
    signal_to_wire: &HashMap<u64, u64>,
    replacement_map: &HashMap<u64, u64>,
) -> Option<u64> {
    if let Some(&wire) = signal_to_wire.get(&signal) {
        return Some(wire);
    }
    let mut current = signal;
    for _ in 0..32 {
        let next = *replacement_map.get(&current)?;
        if let Some(&wire) = signal_to_wire.get(&next) {
            return Some(wire);
        }
        if next == current {
            return None;
        }
        current = next;
    }
    None
}

pub fn write_runtime_dat_file(path: &Path, r1cs: &R1cs) -> Result<()> {
    fs::write(path, runtime_dat_buffer_for_r1cs(r1cs)?)
        .map_err(|err| anyhow::anyhow!("failed to write {}: {err}", path.display()))
}

pub fn write_runtime_dat_file_with_descriptor(
    path: &Path,
    r1cs: &R1cs,
    descriptor: &RuntimeDescriptor,
) -> Result<()> {
    fs::write(path, runtime_dat_buffer_for_descriptor(r1cs, descriptor)?)
        .map_err(|err| anyhow::anyhow!("failed to write {}: {err}", path.display()))
}

pub fn runtime_dat_buffer_for_r1cs(r1cs: &R1cs) -> Result<Vec<u8>> {
    runtime_dat_buffer_for_descriptor(r1cs, &RuntimeDescriptor::for_r1cs(r1cs))
}

pub fn runtime_dat_buffer_for_descriptor(
    r1cs: &R1cs,
    descriptor: &RuntimeDescriptor,
) -> Result<Vec<u8>> {
    let mut out = runtime_dat_buffer(descriptor)?;
    append_constraints(&mut out, r1cs);
    Ok(out)
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

    push_u64(&mut out, descriptor.source_assertions.len() as u64);
    for assertion in &descriptor.source_assertions {
        push_u64(&mut out, assertion.source_word);
        push_u64(&mut out, assertion.expected);
    }
    push_u64(&mut out, descriptor.source_public_prefix_words);
    push_u64(&mut out, descriptor.source_sections.len() as u64);
    for section in &descriptor.source_sections {
        push_u64(&mut out, section.start_word);
        push_u64(&mut out, section.word_len);
        push_u64(&mut out, section.kind);
        push_u64(&mut out, section.flags);
    }
    push_u64(&mut out, descriptor.section_copy_ops.len() as u64);
    for copy_op in &descriptor.section_copy_ops {
        push_u64(&mut out, copy_op.section_index);
        push_u64(&mut out, copy_op.section_offset_words);
        push_u64(&mut out, copy_op.word_len);
        push_u64(&mut out, copy_op.witness_offset_words);
    }
    append_circom_wasm(&mut out);
    Ok(out)
}

fn append_circom_wasm(out: &mut Vec<u8>) {
    push_u64(out, 0);
}

fn append_constraints(out: &mut Vec<u8>, r1cs: &R1cs) {
    push_u64(out, r1cs.constraints.len() as u64);
    for constraint in &r1cs.constraints {
        append_linear_combination(out, &constraint.a);
        append_linear_combination(out, &constraint.b);
        append_linear_combination(out, &constraint.c);
    }
    append_custom_gates(out, r1cs);
}

fn append_linear_combination(
    out: &mut Vec<u8>,
    lc: &crate::recursive_setup::r1cs::LinearCombination,
) {
    push_u64(out, lc.len() as u64);
    for (&signal, &coeff) in lc {
        push_u64(out, signal as u64);
        push_u64(out, coeff);
    }
}

fn append_custom_gates(out: &mut Vec<u8>, r1cs: &R1cs) {
    let supported_gate_uses = r1cs
        .custom_gate_uses
        .iter()
        .filter_map(|gate_use| {
            let gate = r1cs.custom_gates.get(gate_use.id as usize)?;
            let kind = match gate.template_name.as_str() {
                "CMul" => Some(1u64),
                "EvPol4" => Some(2u64),
                "TreeSelector4" => Some(3u64),
                "SelectValue1" => Some(4u64),
                "FFT4" => Some(5u64),
                "Poseidon16" => Some(6u64),
                "CustPoseidon16" => Some(7u64),
                _ => None,
            }?;
            Some((kind, &gate.parameters, gate_use))
        })
        .collect::<Vec<_>>();

    push_u64(out, supported_gate_uses.len() as u64);
    for (kind, parameters, gate_use) in supported_gate_uses {
        push_u64(out, kind);
        push_u64(out, parameters.len() as u64);
        for &parameter in parameters {
            push_u64(out, parameter);
        }
        push_u64(out, gate_use.signals.len() as u64);
        for &signal in &gate_use.signals {
            push_u64(out, signal);
        }
    }
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
        let buffer = runtime_dat_buffer_for_r1cs(&synthetic_r1cs())?;
        assert_eq!(&buffer[..8], MAGIC);
        assert_eq!(u64::from_le_bytes(buffer[8..16].try_into()?), VERSION);
        assert_eq!(u64::from_le_bytes(buffer[24..32].try_into()?), 4);
        assert_eq!(u64::from_le_bytes(buffer[32..40].try_into()?), 3);
        assert_eq!(u64::from_le_bytes(buffer[56..64].try_into()?), 3);
        assert_eq!(u64::from_le_bytes(buffer[120..128].try_into()?), 0);
        Ok(())
    }

    #[test]
    fn maps_circom_main_inputs_to_witness_wires() {
        let mut r1cs = synthetic_r1cs();
        r1cs.n_vars = 5;
        r1cs.wire_map = vec![0, 12, 10, 11, 20];
        let descriptor = RuntimeDescriptor::for_circom_main_inputs(&r1cs, 10, 3, &[]);
        assert_eq!(descriptor.copy_indices, Vec::<u64>::new());
        assert_eq!(descriptor.source_public_prefix_words, 0);
        assert_eq!(descriptor.source_sections[0].start_word, 0);
        assert_eq!(descriptor.source_sections[0].word_len, 3);
        assert_eq!(descriptor.section_copy_ops.len(), 3);
        assert_eq!(descriptor.section_copy_ops[0].section_offset_words, 0);
        assert_eq!(descriptor.section_copy_ops[0].witness_offset_words, 2);
        assert_eq!(descriptor.section_copy_ops[1].section_offset_words, 1);
        assert_eq!(descriptor.section_copy_ops[1].witness_offset_words, 3);
        assert_eq!(descriptor.section_copy_ops[2].section_offset_words, 2);
        assert_eq!(descriptor.section_copy_ops[2].witness_offset_words, 1);
    }

    #[test]
    fn maps_simplified_circom_inputs_to_replacement_wires() {
        let mut r1cs = synthetic_r1cs();
        r1cs.n_vars = 6;
        r1cs.wire_map = vec![0, 50, 51, 12, 80, 81];
        let descriptor =
            RuntimeDescriptor::for_circom_main_inputs(&r1cs, 10, 3, &[(10, 80), (11, 81)]);
        assert_eq!(descriptor.section_copy_ops.len(), 3);
        assert_eq!(descriptor.section_copy_ops[0].witness_offset_words, 4);
        assert_eq!(descriptor.section_copy_ops[1].witness_offset_words, 5);
        assert_eq!(descriptor.section_copy_ops[2].witness_offset_words, 3);
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
