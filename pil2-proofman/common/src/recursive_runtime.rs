use std::fs;
use std::path::Path;

use fields::PrimeField64;

use crate::{ProofmanError, ProofmanResult};

const MAGIC: &[u8; 8] = b"PIL2RSPD";

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NativeRecursiveRuntime {
    pub template_id: u64,
    pub size_witness_words: u64,
    pub n_publics: u64,
    pub public_input_offset_words: u64,
    pub public_input_copy_words: u64,
    pub copy_indices: Vec<u64>,
    pub source_assertions: Vec<NativeRuntimeAssertion>,
    pub source_public_prefix_words: u64,
    pub source_sections: Vec<NativeRuntimeSection>,
    pub section_copy_ops: Vec<NativeRuntimeSectionCopyOp>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NativeRuntimeAssertion {
    pub source_word: u64,
    pub expected: u64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NativeRuntimeSection {
    pub start_word: u64,
    pub word_len: u64,
    pub kind: u64,
    pub flags: u64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NativeRuntimeSectionCopyOp {
    pub section_index: u64,
    pub section_offset_words: u64,
    pub word_len: u64,
    pub witness_offset_words: u64,
}

impl NativeRecursiveRuntime {
    pub fn from_dat_file(path: &Path) -> ProofmanResult<Self> {
        let bytes = fs::read(path)?;
        if bytes.len() < 64 || &bytes[..8] != MAGIC {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} is not a native recursive runtime descriptor",
                path.display()
            )));
        }

        let template_id = read_u64(&bytes, 16)?;
        let size_witness_words = read_u64(&bytes, 24)?;
        let n_publics = read_u64(&bytes, 32)?;
        let public_input_offset_words = read_u64(&bytes, 40)?;
        let public_input_copy_words = read_u64(&bytes, 48)?;
        let copy_count = read_u64(&bytes, 56)? as usize;
        let copy_start = 64usize;
        let copy_end = copy_start
            .checked_add(copy_count.checked_mul(8).ok_or_else(|| {
                ProofmanError::InvalidSetup("native runtime copy index table is too large".to_string())
            })?)
            .ok_or_else(|| ProofmanError::InvalidSetup("native runtime copy index table is too large".to_string()))?;
        if copy_end > bytes.len() {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has a truncated native runtime copy index table",
                path.display()
            )));
        }
        let mut copy_indices = Vec::with_capacity(copy_count);
        for index in 0..copy_count {
            copy_indices.push(read_u64(&bytes, copy_start + index * 8)?);
        }

        let assertion_count = if bytes.len() >= copy_end + 8 { read_u64(&bytes, copy_end)? as usize } else { 0 };
        let assertions_end = copy_end
            .checked_add(8)
            .and_then(|start| start.checked_add(assertion_count.checked_mul(16)?))
            .unwrap_or(bytes.len());
        if assertion_count > 0 && assertions_end > bytes.len() {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has a truncated native runtime assertion table",
                path.display()
            )));
        }
        let mut source_assertions = Vec::with_capacity(assertion_count);
        for index in 0..assertion_count {
            let offset = copy_end + 8 + index * 16;
            source_assertions.push(NativeRuntimeAssertion {
                source_word: read_u64(&bytes, offset)?,
                expected: read_u64(&bytes, offset + 8)?,
            });
        }
        let source_public_prefix_words =
            if bytes.len() >= assertions_end + 8 { read_u64(&bytes, assertions_end)? } else { n_publics };

        let sections_count_offset = assertions_end + 8;
        let (source_sections, sections_end) = if bytes.len() >= sections_count_offset + 8 {
            let sections_count = read_u64(&bytes, sections_count_offset)? as usize;
            let sections_start = sections_count_offset + 8;
            let sections_end = checked_table_end(path, sections_start, sections_count, 32, "section")?;
            if sections_end > bytes.len() {
                return Err(ProofmanError::InvalidSetup(format!(
                    "{} has a truncated native runtime section table",
                    path.display()
                )));
            }
            let mut sections = Vec::with_capacity(sections_count);
            for index in 0..sections_count {
                let offset = sections_start + index * 32;
                sections.push(NativeRuntimeSection {
                    start_word: read_u64(&bytes, offset)?,
                    word_len: read_u64(&bytes, offset + 8)?,
                    kind: read_u64(&bytes, offset + 16)?,
                    flags: read_u64(&bytes, offset + 24)?,
                });
            }
            (sections, sections_end)
        } else {
            (Vec::new(), sections_count_offset)
        };

        let copy_ops_count_offset = sections_end;
        let section_copy_ops = if bytes.len() >= copy_ops_count_offset + 8 {
            let copy_ops_count = read_u64(&bytes, copy_ops_count_offset)? as usize;
            let copy_ops_start = copy_ops_count_offset + 8;
            let copy_ops_end = checked_table_end(path, copy_ops_start, copy_ops_count, 32, "section copy op")?;
            if copy_ops_end > bytes.len() {
                return Err(ProofmanError::InvalidSetup(format!(
                    "{} has a truncated native runtime section copy op table",
                    path.display()
                )));
            }
            let mut copy_ops = Vec::with_capacity(copy_ops_count);
            for index in 0..copy_ops_count {
                let offset = copy_ops_start + index * 32;
                copy_ops.push(NativeRuntimeSectionCopyOp {
                    section_index: read_u64(&bytes, offset)?,
                    section_offset_words: read_u64(&bytes, offset + 8)?,
                    word_len: read_u64(&bytes, offset + 16)?,
                    witness_offset_words: read_u64(&bytes, offset + 24)?,
                });
            }
            copy_ops
        } else {
            Vec::new()
        };

        Ok(Self {
            template_id,
            size_witness_words,
            n_publics,
            public_input_offset_words,
            public_input_copy_words,
            copy_indices,
            source_assertions,
            source_public_prefix_words,
            source_sections,
            section_copy_ops,
        })
    }

    pub fn generate_witness<F: PrimeField64>(
        &self,
        source_words: &[u64],
        total_witness_words: u64,
    ) -> ProofmanResult<Vec<F>> {
        if total_witness_words < self.size_witness_words {
            return Err(ProofmanError::InvalidSetup(format!(
                "native recursive witness buffer has {total_witness_words} words but base witness requires {}",
                self.size_witness_words
            )));
        }

        let mut witness = vec![F::ZERO; total_witness_words as usize];
        if !witness.is_empty() {
            witness[0] = F::ONE;
        }

        for assertion in &self.source_assertions {
            let actual = source_words.get(assertion.source_word as usize).ok_or_else(|| {
                ProofmanError::InvalidProof(format!(
                    "native recursive source assertion reads missing word {}",
                    assertion.source_word
                ))
            })?;
            if *actual != assertion.expected {
                return Err(ProofmanError::InvalidProof(format!(
                    "native recursive source assertion failed at word {}: expected {}, got {}",
                    assertion.source_word, assertion.expected, actual
                )));
            }
        }

        let prefix_words = self
            .source_public_prefix_words
            .min(self.size_witness_words.saturating_sub(1))
            .min(source_words.len() as u64);
        for offset in 0..prefix_words {
            witness[(1 + offset) as usize] = F::from_u64(source_words[offset as usize]);
        }

        if self.copy_indices.is_empty() {
            let copy_words = self
                .public_input_copy_words
                .min(source_words.len() as u64)
                .min(self.size_witness_words.saturating_sub(self.public_input_offset_words));
            for offset in 0..copy_words {
                let dst = self.public_input_offset_words + offset;
                witness[dst as usize] = F::from_u64(source_words[offset as usize]);
            }
        } else {
            for (offset, source_index) in self.copy_indices.iter().enumerate() {
                if offset as u64 >= self.public_input_copy_words {
                    break;
                }
                let dst = self.public_input_offset_words + offset as u64;
                if dst >= self.size_witness_words {
                    break;
                }
                if let Some(value) = source_words.get(*source_index as usize) {
                    witness[dst as usize] = F::from_u64(*value);
                }
            }
        }

        for copy_op in &self.section_copy_ops {
            let section = self.source_sections.get(copy_op.section_index as usize).ok_or_else(|| {
                ProofmanError::InvalidSetup(format!(
                    "native recursive section copy references missing section {}",
                    copy_op.section_index
                ))
            })?;
            let section_copy_end = copy_op.section_offset_words.checked_add(copy_op.word_len).ok_or_else(|| {
                ProofmanError::InvalidSetup("native recursive section copy section offset overflow".to_string())
            })?;
            if section_copy_end > section.word_len {
                return Err(ProofmanError::InvalidSetup(
                    "native recursive section copy exceeds section length".to_string(),
                ));
            }
            let source_start = section.start_word.checked_add(copy_op.section_offset_words).ok_or_else(|| {
                ProofmanError::InvalidSetup("native recursive section copy source overflow".to_string())
            })?;
            let source_end = source_start.checked_add(copy_op.word_len).ok_or_else(|| {
                ProofmanError::InvalidSetup("native recursive section copy source overflow".to_string())
            })?;
            let witness_end = copy_op.witness_offset_words.checked_add(copy_op.word_len).ok_or_else(|| {
                ProofmanError::InvalidSetup("native recursive section copy destination overflow".to_string())
            })?;
            if source_end > source_words.len() as u64 || witness_end > self.size_witness_words {
                return Err(ProofmanError::InvalidSetup("native recursive section copy is out of bounds".to_string()));
            }
            for offset in 0..copy_op.word_len {
                witness[(copy_op.witness_offset_words + offset) as usize] =
                    F::from_u64(source_words[(source_start + offset) as usize]);
            }
        }

        Ok(witness)
    }
}

fn checked_table_end(path: &Path, start: usize, count: usize, row_len: usize, label: &str) -> ProofmanResult<usize> {
    start
        .checked_add(
            count
                .checked_mul(row_len)
                .ok_or_else(|| ProofmanError::InvalidSetup(format!("native runtime {label} table is too large")))?,
        )
        .ok_or_else(|| {
            ProofmanError::InvalidSetup(format!("{} has an overflowing native runtime {label} table", path.display()))
        })
}

fn read_u64(bytes: &[u8], offset: usize) -> ProofmanResult<u64> {
    let end = offset + 8;
    let chunk = bytes
        .get(offset..end)
        .ok_or_else(|| ProofmanError::InvalidSetup("native runtime descriptor is truncated".to_string()))?;
    Ok(u64::from_le_bytes(chunk.try_into()?))
}

#[cfg(test)]
mod tests {
    use fields::Goldilocks;

    use super::*;

    #[test]
    fn parses_native_runtime_descriptor() -> ProofmanResult<()> {
        let dir = std::env::temp_dir().join(format!("proofman_native_runtime_test_{}", std::process::id()));
        std::fs::create_dir_all(&dir)?;
        let path = dir.join("recursive2.dat");

        let mut bytes = Vec::new();
        bytes.extend_from_slice(MAGIC);
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&8u64.to_le_bytes());
        bytes.extend_from_slice(&3u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&3u64.to_le_bytes());
        bytes.extend_from_slice(&2u64.to_le_bytes());
        bytes.extend_from_slice(&4u64.to_le_bytes());
        bytes.extend_from_slice(&2u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&10u64.to_le_bytes());
        bytes.extend_from_slice(&6u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&3u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&2u64.to_le_bytes());
        bytes.extend_from_slice(&6u64.to_le_bytes());
        std::fs::write(&path, bytes)?;

        let runtime = NativeRecursiveRuntime::from_dat_file(&path)?;
        assert_eq!(runtime.size_witness_words, 8);
        assert_eq!(runtime.copy_indices, vec![4, 2]);
        assert_eq!(runtime.source_assertions.len(), 1);
        assert_eq!(runtime.source_public_prefix_words, 6);
        assert_eq!(runtime.source_sections.len(), 1);
        assert_eq!(runtime.section_copy_ops.len(), 1);

        let witness = runtime.generate_witness::<Goldilocks>(&[10, 20, 30, 40, 50], 10)?;
        assert_eq!(witness[0].as_canonical_u64(), 1);
        assert_eq!(witness[1].as_canonical_u64(), 50);
        assert_eq!(witness[2].as_canonical_u64(), 30);
        assert_eq!(witness[3].as_canonical_u64(), 30);
        assert_eq!(witness[6].as_canonical_u64(), 30);
        assert_eq!(witness[7].as_canonical_u64(), 40);

        std::fs::remove_dir_all(&dir)?;
        Ok(())
    }
}
