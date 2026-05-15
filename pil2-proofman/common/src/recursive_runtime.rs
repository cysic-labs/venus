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
    pub constraints: Vec<NativeRuntimeConstraint>,
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

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NativeRuntimeConstraint {
    pub a: Vec<NativeRuntimeLcTerm>,
    pub b: Vec<NativeRuntimeLcTerm>,
    pub c: Vec<NativeRuntimeLcTerm>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NativeRuntimeLcTerm {
    pub signal: u64,
    pub coeff: u64,
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
        let (section_copy_ops, copy_ops_end) = if bytes.len() >= copy_ops_count_offset + 8 {
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
            (copy_ops, copy_ops_end)
        } else {
            (Vec::new(), copy_ops_count_offset)
        };
        let constraints =
            if bytes.len() >= copy_ops_end + 8 { parse_constraints(path, &bytes, copy_ops_end)? } else { Vec::new() };

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
            constraints,
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
        let mut known = vec![false; total_witness_words as usize];
        if !witness.is_empty() {
            witness[0] = F::ONE;
            known[0] = true;
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
            known[(1 + offset) as usize] = true;
        }

        if self.copy_indices.is_empty() {
            let copy_words = self
                .public_input_copy_words
                .min(source_words.len() as u64)
                .min(self.size_witness_words.saturating_sub(self.public_input_offset_words));
            for offset in 0..copy_words {
                let dst = self.public_input_offset_words + offset;
                witness[dst as usize] = F::from_u64(source_words[offset as usize]);
                known[dst as usize] = true;
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
                    known[dst as usize] = true;
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
                known[(copy_op.witness_offset_words + offset) as usize] = true;
            }
        }

        self.solve_constraints(&mut witness, &mut known)?;

        Ok(witness)
    }

    fn solve_constraints<F: PrimeField64>(&self, witness: &mut [F], known: &mut [bool]) -> ProofmanResult<()> {
        if self.constraints.is_empty() {
            return Ok(());
        }

        let mut solved_any = true;
        while solved_any {
            solved_any = false;
            for constraint in &self.constraints {
                if self.try_solve_constraint(constraint, witness, known)? {
                    solved_any = true;
                }
            }
        }

        for constraint in &self.constraints {
            let a = eval_lc(&constraint.a, witness, known)?;
            let b = eval_lc(&constraint.b, witness, known)?;
            let c = eval_lc(&constraint.c, witness, known)?;
            if a.unknown.is_empty() && b.unknown.is_empty() && c.unknown.is_empty() && a.value * b.value != c.value {
                return Err(ProofmanError::InvalidProof(
                    "native recursive R1CS witness does not satisfy all constraints".to_string(),
                ));
            }
        }

        Ok(())
    }

    fn try_solve_constraint<F: PrimeField64>(
        &self,
        constraint: &NativeRuntimeConstraint,
        witness: &mut [F],
        known: &mut [bool],
    ) -> ProofmanResult<bool> {
        let a = eval_lc(&constraint.a, witness, known)?;
        let b = eval_lc(&constraint.b, witness, known)?;
        let c = eval_lc(&constraint.c, witness, known)?;

        if a.unknown.len() == 1 && b.unknown.is_empty() && c.unknown.is_empty() && !b.value.is_zero() {
            let desired = c.value / b.value;
            return solve_single_unknown(&a, desired, witness, known);
        }
        if b.unknown.len() == 1 && a.unknown.is_empty() && c.unknown.is_empty() && !a.value.is_zero() {
            let desired = c.value / a.value;
            return solve_single_unknown(&b, desired, witness, known);
        }
        if c.unknown.len() == 1 && a.unknown.is_empty() && b.unknown.is_empty() {
            let desired = a.value * b.value;
            return solve_single_unknown(&c, desired, witness, known);
        }

        if a.unknown.is_empty() && b.unknown.is_empty() && c.unknown.is_empty() && a.value * b.value != c.value {
            return Err(ProofmanError::InvalidProof(
                "native recursive R1CS constraint failed during witness solving".to_string(),
            ));
        }

        Ok(false)
    }
}

#[derive(Debug)]
struct LcEval<F: PrimeField64> {
    value: F,
    unknown: Vec<(usize, F)>,
}

fn eval_lc<F: PrimeField64>(terms: &[NativeRuntimeLcTerm], witness: &[F], known: &[bool]) -> ProofmanResult<LcEval<F>> {
    let mut value = F::ZERO;
    let mut unknown = Vec::new();
    for term in terms {
        let signal = usize::try_from(term.signal).map_err(|_| {
            ProofmanError::InvalidSetup(format!("native recursive R1CS signal {} is too large", term.signal))
        })?;
        if signal >= witness.len() {
            return Err(ProofmanError::InvalidSetup(format!(
                "native recursive R1CS signal {signal} is outside witness size {}",
                witness.len()
            )));
        }
        let coeff = F::from_u64(term.coeff);
        if known[signal] {
            value += witness[signal] * coeff;
        } else {
            unknown.push((signal, coeff));
        }
    }
    Ok(LcEval { value, unknown })
}

fn solve_single_unknown<F: PrimeField64>(
    lc: &LcEval<F>,
    desired: F,
    witness: &mut [F],
    known: &mut [bool],
) -> ProofmanResult<bool> {
    if lc.unknown.len() != 1 {
        return Ok(false);
    }
    let (signal, coeff) = lc.unknown[0];
    if coeff.is_zero() {
        return Ok(false);
    }
    let value = (desired - lc.value) / coeff;
    if known[signal] {
        if witness[signal] != value {
            return Err(ProofmanError::InvalidProof(format!(
                "native recursive R1CS solved conflicting value for signal {signal}"
            )));
        }
        Ok(false)
    } else {
        witness[signal] = value;
        known[signal] = true;
        Ok(true)
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

fn parse_constraints(
    path: &Path,
    bytes: &[u8],
    constraints_offset: usize,
) -> ProofmanResult<Vec<NativeRuntimeConstraint>> {
    let count = read_u64(bytes, constraints_offset)? as usize;
    let mut offset = constraints_offset + 8;
    let mut constraints = Vec::with_capacity(count);
    for _ in 0..count {
        let (a, next) = parse_lc(path, bytes, offset)?;
        let (b, next) = parse_lc(path, bytes, next)?;
        let (c, next) = parse_lc(path, bytes, next)?;
        offset = next;
        constraints.push(NativeRuntimeConstraint { a, b, c });
    }
    Ok(constraints)
}

fn parse_lc(path: &Path, bytes: &[u8], offset: usize) -> ProofmanResult<(Vec<NativeRuntimeLcTerm>, usize)> {
    let count = read_u64(bytes, offset)? as usize;
    let terms_start = offset + 8;
    let terms_end = checked_table_end(path, terms_start, count, 16, "R1CS linear-combination")?;
    if terms_end > bytes.len() {
        return Err(ProofmanError::InvalidSetup(format!(
            "{} has a truncated native runtime R1CS linear-combination table",
            path.display()
        )));
    }

    let mut terms = Vec::with_capacity(count);
    for index in 0..count {
        let offset = terms_start + index * 16;
        terms.push(NativeRuntimeLcTerm { signal: read_u64(bytes, offset)?, coeff: read_u64(bytes, offset + 8)? });
    }
    Ok((terms, terms_end))
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
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&6u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&7u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&8u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        std::fs::write(&path, bytes)?;

        let runtime = NativeRecursiveRuntime::from_dat_file(&path)?;
        assert_eq!(runtime.size_witness_words, 8);
        assert_eq!(runtime.copy_indices, vec![4, 2]);
        assert_eq!(runtime.source_assertions.len(), 1);
        assert_eq!(runtime.source_public_prefix_words, 6);
        assert_eq!(runtime.source_sections.len(), 1);
        assert_eq!(runtime.section_copy_ops.len(), 1);
        assert_eq!(runtime.constraints.len(), 1);

        let witness = runtime.generate_witness::<Goldilocks>(&[10, 20, 30, 40, 50], 10)?;
        assert_eq!(witness[0].as_canonical_u64(), 1);
        assert_eq!(witness[1].as_canonical_u64(), 50);
        assert_eq!(witness[2].as_canonical_u64(), 30);
        assert_eq!(witness[3].as_canonical_u64(), 30);
        assert_eq!(witness[6].as_canonical_u64(), 30);
        assert_eq!(witness[7].as_canonical_u64(), 40);
        assert_eq!(witness[8].as_canonical_u64(), 1200);

        std::fs::remove_dir_all(&dir)?;
        Ok(())
    }
}
