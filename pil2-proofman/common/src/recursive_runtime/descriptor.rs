use std::collections::{BTreeMap, BTreeSet};
use std::fs::File;
use std::io::Read;
use std::path::Path;
use std::sync::{Mutex, OnceLock};

use super::{
    NativeRecursiveRuntime, NativeRuntimeAssertion, NativeRuntimeConstraint, NativeRuntimeCustomGate,
    NativeRuntimeCustomGateKind, NativeRuntimeLcTerm, NativeRuntimeSection, NativeRuntimeSectionCopyOp,
    NativeRuntimeSourceAliasCheck,
};
use crate::{ProofmanError, ProofmanResult};

const MAGIC: &[u8; 8] = b"PIL2RSPD";
const RUNTIME_VERSION: u64 = 5;
const MAX_RECURSIVE_RUNTIME_BYTES: u64 = 1024 * 1024 * 1024;
const MAX_RECURSIVE_SOURCE_WORDS: u64 = 1024 * 1024;
const RUNTIME_EXTENSION_NONE: u64 = 0;
const RUNTIME_EXTENSION_SOURCE_ALIASES: u64 = 1;
const RUNTIME_EXTENSION_SOURCE_ALIASES_AND_IGNORED: u64 = 2;

impl NativeRecursiveRuntime {
    pub fn from_dat_file(path: &Path) -> ProofmanResult<Self> {
        let file = File::open(path)?;
        let file_len = file.metadata()?.len();
        if file_len > MAX_RECURSIVE_RUNTIME_BYTES {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} exceeds native recursive runtime size limit",
                path.display()
            )));
        }
        let mut bytes = Vec::with_capacity(file_len as usize);
        file.take(MAX_RECURSIVE_RUNTIME_BYTES + 1).read_to_end(&mut bytes)?;
        if bytes.len() as u64 > MAX_RECURSIVE_RUNTIME_BYTES {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} exceeds native recursive runtime size limit",
                path.display()
            )));
        }
        if bytes.len() < 64 || &bytes[..8] != MAGIC {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} is not a native recursive runtime descriptor",
                path.display()
            )));
        }

        let version = read_u64(&bytes, 8)?;
        if version != RUNTIME_VERSION {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has unsupported native recursive runtime descriptor version {version}",
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

        let (assertion_count, assertion_start, assertions_end) =
            if copy_end.checked_add(8).is_some_and(|end| end <= bytes.len()) {
                let assertion_count = read_count(path, &bytes, copy_end, "assertion")?;
                let assertion_start = copy_end.checked_add(8).ok_or_else(|| {
                    ProofmanError::InvalidSetup("native runtime assertion table is too large".to_string())
                })?;
                let assertions_end = checked_table_end(path, assertion_start, assertion_count, 16, "assertion")?;
                if assertions_end > bytes.len() {
                    return Err(ProofmanError::InvalidSetup(format!(
                        "{} has a truncated native runtime assertion table",
                        path.display()
                    )));
                }
                (assertion_count, assertion_start, assertions_end)
            } else {
                (0, copy_end, copy_end)
            };
        let mut source_assertions = Vec::with_capacity(assertion_count);
        for index in 0..assertion_count {
            let offset = assertion_start + index * 16;
            source_assertions.push(NativeRuntimeAssertion {
                source_word: read_u64(&bytes, offset)?,
                expected: read_u64(&bytes, offset + 8)?,
            });
        }
        let source_public_prefix_words =
            if bytes.len() >= assertions_end + 8 { read_u64(&bytes, assertions_end)? } else { n_publics };

        let sections_count_offset = assertions_end + 8;
        let (source_sections, sections_end) = if bytes.len() >= sections_count_offset + 8 {
            let sections_count = read_count(path, &bytes, sections_count_offset, "section")?;
            if sections_count > MAX_RECURSIVE_SOURCE_WORDS as usize {
                return Err(ProofmanError::InvalidSetup(format!(
                    "{} declares too many native runtime source sections",
                    path.display()
                )));
            }
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
            let copy_ops_count = read_count(path, &bytes, copy_ops_count_offset, "section copy op")?;
            if copy_ops_count > MAX_RECURSIVE_SOURCE_WORDS as usize {
                return Err(ProofmanError::InvalidSetup(format!(
                    "{} declares too many native runtime section copy ops",
                    path.display()
                )));
            }
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
        let (source_alias_checks, ignored_source_words, runtime_body_end) =
            parse_runtime_extension(path, &bytes, copy_ops_end)?;
        validate_source_bindings(
            path,
            &source_alias_checks,
            &ignored_source_words,
            &source_sections,
            &section_copy_ops,
            size_witness_words,
        )?;
        let (constraints, constraints_end) = if bytes.len() >= runtime_body_end + 8 {
            parse_constraints(path, &bytes, runtime_body_end)?
        } else {
            (Vec::new(), runtime_body_end)
        };
        let custom_gates = if bytes.len() >= constraints_end + 8 {
            parse_custom_gates(path, &bytes, constraints_end)?
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
            source_alias_checks,
            ignored_source_words,
            constraints,
            custom_gates,
            solver_index: OnceLock::new(),
            solve_plan: OnceLock::new(),
            solve_plan_build_lock: Mutex::new(()),
        })
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

fn read_count(path: &Path, bytes: &[u8], offset: usize, label: &str) -> ProofmanResult<usize> {
    usize::try_from(read_u64(bytes, offset)?).map_err(|_| {
        ProofmanError::InvalidSetup(format!("{} has too many native runtime {label} entries", path.display()))
    })
}

fn checked_count_body_start(path: &Path, count_offset: usize, label: &str) -> ProofmanResult<usize> {
    count_offset.checked_add(8).ok_or_else(|| {
        ProofmanError::InvalidSetup(format!("{} has an overflowing native runtime {label} table", path.display()))
    })
}

fn validate_min_encoded_table(
    path: &Path,
    bytes: &[u8],
    start: usize,
    count: usize,
    min_row_len: usize,
    label: &str,
) -> ProofmanResult<()> {
    let min_end = checked_table_end(path, start, count, min_row_len, label)?;
    if min_end > bytes.len() {
        return Err(ProofmanError::InvalidSetup(format!(
            "{} has a truncated native runtime {label} table",
            path.display()
        )));
    }
    Ok(())
}

fn parse_runtime_extension(
    path: &Path,
    bytes: &[u8],
    offset: usize,
) -> ProofmanResult<(Vec<NativeRuntimeSourceAliasCheck>, Vec<u64>, usize)> {
    let tag = read_u64(bytes, offset)?;
    if tag == RUNTIME_EXTENSION_NONE {
        let end = offset
            .checked_add(8)
            .ok_or_else(|| ProofmanError::InvalidSetup("native runtime extension offset overflows".to_string()))?;
        return Ok((Vec::new(), Vec::new(), end));
    }
    if tag != RUNTIME_EXTENSION_SOURCE_ALIASES && tag != RUNTIME_EXTENSION_SOURCE_ALIASES_AND_IGNORED {
        return Err(ProofmanError::InvalidSetup(format!(
            "{} has unsupported native runtime extension tag {tag}",
            path.display()
        )));
    }

    let count_offset = offset
        .checked_add(8)
        .ok_or_else(|| ProofmanError::InvalidSetup("native runtime source alias offset overflows".to_string()))?;
    let count = read_count(path, bytes, count_offset, "source alias")?;
    if count > MAX_RECURSIVE_SOURCE_WORDS as usize {
        return Err(ProofmanError::InvalidSetup(format!(
            "{} declares too many native runtime source aliases",
            path.display()
        )));
    }
    let start = count_offset
        .checked_add(8)
        .ok_or_else(|| ProofmanError::InvalidSetup("native runtime source alias offset overflows".to_string()))?;
    let end = checked_table_end(path, start, count, 24, "source alias")?;
    if end > bytes.len() {
        return Err(ProofmanError::InvalidSetup(format!(
            "{} has a truncated native runtime source alias table",
            path.display()
        )));
    }
    let mut checks = Vec::with_capacity(count);
    for index in 0..count {
        let row = start + index * 24;
        checks.push(NativeRuntimeSourceAliasCheck {
            first_source_word: read_u64(bytes, row)?,
            aliased_source_word: read_u64(bytes, row + 8)?,
            witness_word: read_u64(bytes, row + 16)?,
        });
    }
    if tag == RUNTIME_EXTENSION_SOURCE_ALIASES {
        return Ok((checks, Vec::new(), end));
    }

    let ignored_count = read_count(path, bytes, end, "ignored source")?;
    if ignored_count > MAX_RECURSIVE_SOURCE_WORDS as usize {
        return Err(ProofmanError::InvalidSetup(format!(
            "{} declares too many ignored native runtime source words",
            path.display()
        )));
    }
    let ignored_start = end
        .checked_add(8)
        .ok_or_else(|| ProofmanError::InvalidSetup("native runtime ignored source offset overflows".to_string()))?;
    let ignored_end = checked_table_end(path, ignored_start, ignored_count, 8, "ignored source")?;
    if ignored_end > bytes.len() {
        return Err(ProofmanError::InvalidSetup(format!(
            "{} has a truncated native runtime ignored source table",
            path.display()
        )));
    }
    let mut ignored_source_words = Vec::with_capacity(ignored_count);
    for index in 0..ignored_count {
        ignored_source_words.push(read_u64(bytes, ignored_start + index * 8)?);
    }
    Ok((checks, ignored_source_words, ignored_end))
}

fn validate_source_bindings(
    path: &Path,
    checks: &[NativeRuntimeSourceAliasCheck],
    ignored_source_words: &[u64],
    sections: &[NativeRuntimeSection],
    copy_ops: &[NativeRuntimeSectionCopyOp],
    size_witness_words: u64,
) -> ProofmanResult<()> {
    let mut source_ranges = Vec::with_capacity(sections.len());
    let mut total_source_words = 0u64;
    for section in sections {
        let end = section
            .start_word
            .checked_add(section.word_len)
            .ok_or_else(|| ProofmanError::InvalidSetup("native runtime source section end overflows".to_string()))?;
        total_source_words = total_source_words
            .checked_add(section.word_len)
            .ok_or_else(|| ProofmanError::InvalidSetup("native runtime source section size overflows".to_string()))?;
        if total_source_words > MAX_RECURSIVE_SOURCE_WORDS {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} declares too many native runtime source words",
                path.display()
            )));
        }
        if section.word_len != 0 {
            source_ranges.push((section.start_word, end));
        }
    }
    source_ranges.sort_unstable();
    for ranges in source_ranges.windows(2) {
        if ranges[1].0 < ranges[0].1 {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has overlapping native runtime source sections",
                path.display()
            )));
        }
    }

    let mut source_copy_ranges = Vec::with_capacity(copy_ops.len());
    let mut copy_ranges = Vec::with_capacity(copy_ops.len());
    let mut first_source_by_witness = BTreeMap::new();
    let mut expected_checks = BTreeSet::new();
    for copy_op in copy_ops {
        let section = sections.get(copy_op.section_index as usize).ok_or_else(|| {
            ProofmanError::InvalidSetup(format!(
                "{} has a section copy that references missing section {}",
                path.display(),
                copy_op.section_index
            ))
        })?;
        let section_copy_end = copy_op
            .section_offset_words
            .checked_add(copy_op.word_len)
            .ok_or_else(|| ProofmanError::InvalidSetup("native runtime section copy offset overflows".to_string()))?;
        if section_copy_end > section.word_len {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has a section copy outside its source section",
                path.display()
            )));
        }
        let source_start = section.start_word.checked_add(copy_op.section_offset_words).ok_or_else(|| {
            ProofmanError::InvalidSetup("native runtime section copy source offset overflows".to_string())
        })?;
        let source_end = source_start.checked_add(copy_op.word_len).ok_or_else(|| {
            ProofmanError::InvalidSetup("native runtime section copy source end overflows".to_string())
        })?;
        let witness_end = copy_op.witness_offset_words.checked_add(copy_op.word_len).ok_or_else(|| {
            ProofmanError::InvalidSetup("native runtime section copy witness offset overflows".to_string())
        })?;
        if witness_end > size_witness_words {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has a section copy outside the base witness",
                path.display()
            )));
        }
        if copy_op.word_len == 0 {
            continue;
        }
        source_copy_ranges.push((source_start, source_end));
        copy_ranges.push((copy_op.witness_offset_words, witness_end));
        if copy_op.word_len == 1 {
            match first_source_by_witness.entry(copy_op.witness_offset_words) {
                std::collections::btree_map::Entry::Vacant(entry) => {
                    entry.insert(source_start);
                }
                std::collections::btree_map::Entry::Occupied(entry) => {
                    let first_source_word = *entry.get();
                    if first_source_word != source_start {
                        expected_checks.insert((first_source_word, source_start, copy_op.witness_offset_words));
                    }
                }
            }
        }
    }

    source_copy_ranges.sort_unstable();
    for ranges in source_copy_ranges.windows(2) {
        if ranges[1].0 < ranges[0].1 {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has overlapping native runtime source copy ranges",
                path.display()
            )));
        }
    }
    let mut copied_source_words = BTreeSet::new();
    for (start, end) in source_copy_ranges {
        copied_source_words.extend(start..end);
    }

    copy_ranges.sort_unstable();
    let mut active_range: Option<(u64, u64)> = None;
    for (start, end) in copy_ranges {
        if let Some((active_start, active_end)) = active_range {
            if start < active_end {
                let duplicate_single_word = end - start == 1 && active_end - active_start == 1 && start == active_start;
                if !duplicate_single_word {
                    return Err(ProofmanError::InvalidSetup(format!(
                        "{} has overlapping ranged section copies in its native runtime descriptor",
                        path.display()
                    )));
                }
            }
            if start >= active_end || end > active_end {
                active_range = Some((start, end));
            }
        } else {
            active_range = Some((start, end));
        }
    }

    let mut provided_checks = BTreeSet::new();
    for check in checks {
        if check.first_source_word == check.aliased_source_word {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has a source alias check that references the same source word twice",
                path.display()
            )));
        }
        let encoded = (check.first_source_word, check.aliased_source_word, check.witness_word);
        if !provided_checks.insert(encoded) {
            return Err(ProofmanError::InvalidSetup(format!("{} has a duplicate source alias check", path.display())));
        }
    }
    if let Some(missing) = expected_checks.difference(&provided_checks).next() {
        return Err(ProofmanError::InvalidSetup(format!(
            "{} is missing source alias check {}:{}:{}",
            path.display(),
            missing.0,
            missing.1,
            missing.2
        )));
    }
    if let Some(unexpected) = provided_checks.difference(&expected_checks).next() {
        return Err(ProofmanError::InvalidSetup(format!(
            "{} has unexpected source alias check {}:{}:{}",
            path.display(),
            unexpected.0,
            unexpected.1,
            unexpected.2
        )));
    }

    let mut ignored = BTreeSet::new();
    for &source_word in ignored_source_words {
        let range_index = source_ranges.partition_point(|(start, _)| *start <= source_word);
        let declared = range_index != 0 && source_word < source_ranges[range_index - 1].1;
        if !declared {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} ignores source word {source_word} outside declared source sections",
                path.display()
            )));
        }
        if copied_source_words.contains(&source_word) {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} marks copied source word {source_word} as ignored",
                path.display()
            )));
        }
        if !ignored.insert(source_word) {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has duplicate ignored source word {source_word}",
                path.display()
            )));
        }
    }
    for &(start, end) in &source_ranges {
        for source_word in start..end {
            if !copied_source_words.contains(&source_word) && !ignored.contains(&source_word) {
                return Err(ProofmanError::InvalidSetup(format!(
                    "{} has unbound source word {source_word}",
                    path.display()
                )));
            }
        }
    }
    Ok(())
}

fn parse_constraints(
    path: &Path,
    bytes: &[u8],
    constraints_offset: usize,
) -> ProofmanResult<(Vec<NativeRuntimeConstraint>, usize)> {
    let count = read_count(path, bytes, constraints_offset, "R1CS constraint")?;
    let mut offset = checked_count_body_start(path, constraints_offset, "R1CS constraint")?;
    validate_min_encoded_table(path, bytes, offset, count, 24, "R1CS constraint")?;

    let mut constraints = Vec::with_capacity(count);
    for _ in 0..count {
        let (a, next) = parse_lc(path, bytes, offset)?;
        let (b, next) = parse_lc(path, bytes, next)?;
        let (c, next) = parse_lc(path, bytes, next)?;
        offset = next;
        constraints.push(NativeRuntimeConstraint { a, b, c });
    }
    Ok((constraints, offset))
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

fn parse_custom_gates(
    path: &Path,
    bytes: &[u8],
    custom_gates_offset: usize,
) -> ProofmanResult<Vec<NativeRuntimeCustomGate>> {
    let count = read_count(path, bytes, custom_gates_offset, "custom gate")?;
    let mut offset = checked_count_body_start(path, custom_gates_offset, "custom gate")?;
    validate_min_encoded_table(path, bytes, offset, count, 24, "custom gate")?;

    let mut custom_gates = Vec::with_capacity(count);
    for _ in 0..count {
        let kind_id = read_u64(bytes, offset)?;
        let kind = match kind_id {
            1 => NativeRuntimeCustomGateKind::CMul,
            2 => NativeRuntimeCustomGateKind::EvPol4,
            3 => NativeRuntimeCustomGateKind::TreeSelector4,
            4 => NativeRuntimeCustomGateKind::SelectValue1,
            5 => NativeRuntimeCustomGateKind::FFT4,
            6 => NativeRuntimeCustomGateKind::Poseidon16,
            7 => NativeRuntimeCustomGateKind::CustPoseidon16,
            other => {
                return Err(ProofmanError::InvalidSetup(format!(
                    "{} references unsupported native runtime custom gate kind {other}",
                    path.display()
                )))
            }
        };
        let parameter_count = read_count(path, bytes, offset + 8, "custom gate parameter")?;
        let parameters_start = offset + 16;
        let parameters_end = checked_table_end(path, parameters_start, parameter_count, 8, "custom gate parameter")?;
        if parameters_end > bytes.len() {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has a truncated native runtime custom gate parameter table",
                path.display()
            )));
        }
        let mut parameters = Vec::with_capacity(parameter_count);
        for index in 0..parameter_count {
            parameters.push(read_u64(bytes, parameters_start + index * 8)?);
        }
        let signal_count_offset = parameters_end;
        let signal_count = read_u64(bytes, signal_count_offset)? as usize;
        let signals_start = signal_count_offset + 8;
        let signals_end = checked_table_end(path, signals_start, signal_count, 8, "custom gate signal")?;
        if signals_end > bytes.len() {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has a truncated native runtime custom gate signal table",
                path.display()
            )));
        }
        let mut signals = Vec::with_capacity(signal_count);
        for index in 0..signal_count {
            signals.push(read_u64(bytes, signals_start + index * 8)?);
        }
        offset = signals_end;
        custom_gates.push(NativeRuntimeCustomGate { kind, parameters, signals });
    }
    Ok(custom_gates)
}

fn read_u64(bytes: &[u8], offset: usize) -> ProofmanResult<u64> {
    let end = offset
        .checked_add(8)
        .ok_or_else(|| ProofmanError::InvalidSetup("native runtime descriptor offset overflows".to_string()))?;
    let chunk = bytes
        .get(offset..end)
        .ok_or_else(|| ProofmanError::InvalidSetup("native runtime descriptor is truncated".to_string()))?;
    Ok(u64::from_le_bytes(chunk.try_into()?))
}

#[cfg(test)]
mod tests {
    use fields::{Goldilocks, PrimeField64};

    use super::*;

    fn minimal_native_runtime_descriptor_prefix() -> Vec<u8> {
        let mut bytes = Vec::new();
        bytes.extend_from_slice(MAGIC);
        bytes.extend_from_slice(&RUNTIME_VERSION.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes
    }

    fn write_temp_descriptor(name: &str, bytes: &[u8]) -> ProofmanResult<std::path::PathBuf> {
        let path = std::env::temp_dir().join(format!("proofman_native_runtime_test_{}_{}", std::process::id(), name));
        std::fs::write(&path, bytes)?;
        Ok(path)
    }

    #[test]
    fn parses_native_runtime_descriptor() -> ProofmanResult<()> {
        let dir = std::env::temp_dir().join(format!("proofman_native_runtime_test_{}", std::process::id()));
        std::fs::create_dir_all(&dir)?;
        let path = dir.join("recursive2.dat");

        let mut bytes = Vec::new();
        bytes.extend_from_slice(MAGIC);
        bytes.extend_from_slice(&RUNTIME_VERSION.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&13u64.to_le_bytes());
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
        bytes.extend_from_slice(&2u64.to_le_bytes());
        bytes.extend_from_slice(&2u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&2u64.to_le_bytes());
        bytes.extend_from_slice(&6u64.to_le_bytes());
        bytes.extend_from_slice(&RUNTIME_EXTENSION_NONE.to_le_bytes());
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
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&9u64.to_le_bytes());
        for signal in [1u64, 2, 3, 4, 5, 6, 9, 10, 11] {
            bytes.extend_from_slice(&signal.to_le_bytes());
        }
        std::fs::write(&path, bytes)?;

        let runtime = NativeRecursiveRuntime::from_dat_file(&path)?;
        assert_eq!(runtime.size_witness_words, 13);
        assert_eq!(runtime.copy_indices, vec![4, 2]);
        assert_eq!(runtime.source_assertions.len(), 1);
        assert_eq!(runtime.source_public_prefix_words, 6);
        assert_eq!(runtime.source_sections.len(), 1);
        assert_eq!(runtime.section_copy_ops.len(), 1);
        assert_eq!(runtime.constraints.len(), 1);
        assert_eq!(runtime.custom_gates.len(), 1);

        let witness = runtime.generate_witness::<Goldilocks>(&[10, 20, 30, 40, 50], 13)?;
        assert_eq!(witness[0].as_canonical_u64(), 1);
        assert_eq!(witness[1].as_canonical_u64(), 50);
        assert_eq!(witness[2].as_canonical_u64(), 30);
        assert_eq!(witness[3].as_canonical_u64(), 30);
        assert_eq!(witness[6].as_canonical_u64(), 30);
        assert_eq!(witness[7].as_canonical_u64(), 40);
        assert_eq!(witness[8].as_canonical_u64(), 1200);
        assert_eq!(witness[9].as_canonical_u64(), 4400);
        assert_eq!(witness[10].as_canonical_u64(), 7000);
        assert_eq!(witness[11].as_canonical_u64(), 5100);

        std::fs::remove_dir_all(&dir)?;
        Ok(())
    }

    #[test]
    fn rejects_legacy_runtime_versions() -> ProofmanResult<()> {
        for version in 1u64..RUNTIME_VERSION {
            let mut bytes = Vec::new();
            bytes.extend_from_slice(MAGIC);
            bytes.extend_from_slice(&version.to_le_bytes());
            bytes.resize(64, 0);
            let path = write_temp_descriptor(&format!("legacy_runtime_v{version}.dat"), &bytes)?;

            let err = NativeRecursiveRuntime::from_dat_file(&path).unwrap_err();
            assert!(err.to_string().contains("unsupported native recursive runtime descriptor version"));
            std::fs::remove_file(path)?;
        }
        Ok(())
    }

    #[test]
    fn enforces_source_aliases() -> ProofmanResult<()> {
        let mut bytes = Vec::new();
        bytes.extend_from_slice(MAGIC);
        for value in [RUNTIME_VERSION, 0, 3, 0, 0, 0, 0, 0, 0, 1] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        for value in [0u64, 2, 0, 0] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        bytes.extend_from_slice(&2u64.to_le_bytes());
        for value in [0u64, 0, 1, 1, 0, 1, 1, 1] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        for value in [RUNTIME_EXTENSION_SOURCE_ALIASES, 1, 0, 1, 1, 0, 0] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        let path = write_temp_descriptor("source_aliases.dat", &bytes)?;

        let runtime = NativeRecursiveRuntime::from_dat_file(&path)?;
        assert_eq!(
            runtime.source_alias_checks,
            vec![NativeRuntimeSourceAliasCheck { first_source_word: 0, aliased_source_word: 1, witness_word: 1 }]
        );
        let witness = runtime.generate_witness::<Goldilocks>(&[7, 7], 3)?;
        assert_eq!(witness[1].as_canonical_u64(), 7);

        let err = runtime.generate_witness::<Goldilocks>(&[7, 8], 3).unwrap_err();
        assert!(err.to_string().contains("source words 0 and 1 alias witness word 1 but differ"));

        std::fs::remove_file(path)?;
        Ok(())
    }

    #[test]
    fn enforces_ignored_source_coverage() -> ProofmanResult<()> {
        let mut bytes = Vec::new();
        bytes.extend_from_slice(MAGIC);
        for value in [5u64, 0, 3, 0, 0, 0, 0, 0, 0, 1] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        for value in [0u64, 2, 0, 0] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        bytes.extend_from_slice(&1u64.to_le_bytes());
        for value in [0u64, 0, 1, 1] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        for value in [RUNTIME_EXTENSION_SOURCE_ALIASES_AND_IGNORED, 0, 1, 1, 0, 0] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        let path = write_temp_descriptor("ignored_sources_v5.dat", &bytes)?;

        let runtime = NativeRecursiveRuntime::from_dat_file(&path)?;
        assert_eq!(runtime.ignored_source_words, vec![1]);
        let witness = runtime.generate_witness::<Goldilocks>(&[7, 99], 3)?;
        assert_eq!(witness[1].as_canonical_u64(), 7);

        std::fs::remove_file(path)?;

        let mut missing = Vec::new();
        missing.extend_from_slice(MAGIC);
        for value in [RUNTIME_VERSION, 0, 3, 0, 0, 0, 0, 0, 0, 1] {
            missing.extend_from_slice(&value.to_le_bytes());
        }
        for value in [0u64, 2, 0, 0] {
            missing.extend_from_slice(&value.to_le_bytes());
        }
        missing.extend_from_slice(&1u64.to_le_bytes());
        for value in [0u64, 0, 1, 1, RUNTIME_EXTENSION_NONE, 0, 0] {
            missing.extend_from_slice(&value.to_le_bytes());
        }
        let path = write_temp_descriptor("missing_ignored_sources_v5.dat", &missing)?;
        let err = NativeRecursiveRuntime::from_dat_file(&path).unwrap_err();
        assert!(err.to_string().contains("unbound source word 1"));
        std::fs::remove_file(path)?;
        Ok(())
    }

    #[test]
    fn rejects_missing_source_aliases() -> ProofmanResult<()> {
        let mut bytes = Vec::new();
        bytes.extend_from_slice(MAGIC);
        for value in [RUNTIME_VERSION, 0, 3, 0, 0, 0, 0, 0, 0, 1] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        for value in [0u64, 2, 0, 0] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        bytes.extend_from_slice(&2u64.to_le_bytes());
        for value in [0u64, 0, 1, 1, 0, 1, 1, 1] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        for value in [RUNTIME_EXTENSION_NONE, 0, 0] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        let path = write_temp_descriptor("missing_source_aliases_v5.dat", &bytes)?;

        let err = NativeRecursiveRuntime::from_dat_file(&path).unwrap_err();
        assert!(err.to_string().contains("missing source alias check 0:1:1"));
        std::fs::remove_file(path)?;
        Ok(())
    }

    #[test]
    fn rejects_unknown_runtime_extension() -> ProofmanResult<()> {
        let mut bytes = minimal_native_runtime_descriptor_prefix();
        let tag_offset = bytes.len() - std::mem::size_of::<u64>();
        bytes[tag_offset..].copy_from_slice(&3u64.to_le_bytes());
        let path = write_temp_descriptor("unknown_extension.dat", &bytes)?;

        let err = NativeRecursiveRuntime::from_dat_file(&path).unwrap_err();
        assert!(err.to_string().contains("unsupported native runtime extension tag 3"));

        std::fs::remove_file(path)?;
        Ok(())
    }

    #[test]
    fn rejects_oversized_version_five_source_tables_before_allocation() -> ProofmanResult<()> {
        let mut sections = Vec::new();
        sections.extend_from_slice(MAGIC);
        for value in [RUNTIME_VERSION, 0, 0, 0, 0, 0, 0, 0, 0, MAX_RECURSIVE_SOURCE_WORDS + 1] {
            sections.extend_from_slice(&value.to_le_bytes());
        }
        let path = write_temp_descriptor("oversized_source_sections_v5.dat", &sections)?;
        let err = NativeRecursiveRuntime::from_dat_file(&path).unwrap_err();
        assert!(err.to_string().contains("too many native runtime source sections"));
        std::fs::remove_file(path)?;

        let mut copy_ops = Vec::new();
        copy_ops.extend_from_slice(MAGIC);
        for value in [RUNTIME_VERSION, 0, 0, 0, 0, 0, 0, 0, 0, 0, MAX_RECURSIVE_SOURCE_WORDS + 1] {
            copy_ops.extend_from_slice(&value.to_le_bytes());
        }
        let path = write_temp_descriptor("oversized_source_copy_ops_v5.dat", &copy_ops)?;
        let err = NativeRecursiveRuntime::from_dat_file(&path).unwrap_err();
        assert!(err.to_string().contains("too many native runtime section copy ops"));
        std::fs::remove_file(path)?;

        let mut aliases = minimal_native_runtime_descriptor_prefix();
        aliases[8..16].copy_from_slice(&5u64.to_le_bytes());
        let tag_offset = aliases.len() - std::mem::size_of::<u64>();
        aliases[tag_offset..].copy_from_slice(&RUNTIME_EXTENSION_SOURCE_ALIASES.to_le_bytes());
        aliases.extend_from_slice(&(MAX_RECURSIVE_SOURCE_WORDS + 1).to_le_bytes());
        let path = write_temp_descriptor("oversized_source_aliases_v5.dat", &aliases)?;
        let err = NativeRecursiveRuntime::from_dat_file(&path).unwrap_err();
        assert!(err.to_string().contains("too many native runtime source aliases"));
        std::fs::remove_file(path)?;

        let mut ignored = minimal_native_runtime_descriptor_prefix();
        ignored[8..16].copy_from_slice(&5u64.to_le_bytes());
        let tag_offset = ignored.len() - std::mem::size_of::<u64>();
        ignored[tag_offset..].copy_from_slice(&RUNTIME_EXTENSION_SOURCE_ALIASES_AND_IGNORED.to_le_bytes());
        ignored.extend_from_slice(&0u64.to_le_bytes());
        ignored.extend_from_slice(&(MAX_RECURSIVE_SOURCE_WORDS + 1).to_le_bytes());
        let path = write_temp_descriptor("oversized_ignored_sources_v5.dat", &ignored)?;
        let err = NativeRecursiveRuntime::from_dat_file(&path).unwrap_err();
        assert!(err.to_string().contains("too many ignored native runtime source words"));
        std::fs::remove_file(path)?;
        Ok(())
    }

    #[test]
    fn rejects_source_aliases_without_matching_copy_ops() -> ProofmanResult<()> {
        let mut bytes = Vec::new();
        bytes.extend_from_slice(MAGIC);
        for value in [RUNTIME_VERSION, 0, 3, 0, 0, 0, 0, 0, 0, 1] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        for value in [0u64, 2, 0, 0] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        bytes.extend_from_slice(&2u64.to_le_bytes());
        for value in [0u64, 0, 1, 1, 0, 1, 1, 2] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        for value in [RUNTIME_EXTENSION_SOURCE_ALIASES, 1, 0, 1, 1, 0, 0] {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        let path = write_temp_descriptor("invalid_source_alias_copy.dat", &bytes)?;

        let err = NativeRecursiveRuntime::from_dat_file(&path).unwrap_err();
        assert!(err.to_string().contains("unexpected source alias check 0:1:1"));

        std::fs::remove_file(path)?;
        Ok(())
    }

    #[test]
    fn rejects_overlapping_ranged_copies() {
        let sections = vec![NativeRuntimeSection { start_word: 0, word_len: 4, kind: 0, flags: 0 }];
        let copy_ops = vec![
            NativeRuntimeSectionCopyOp {
                section_index: 0,
                section_offset_words: 0,
                word_len: 2,
                witness_offset_words: 1,
            },
            NativeRuntimeSectionCopyOp {
                section_index: 0,
                section_offset_words: 2,
                word_len: 2,
                witness_offset_words: 2,
            },
        ];

        let err = validate_source_bindings(Path::new("overlap.dat"), &[], &[], &sections, &copy_ops, 4).unwrap_err();
        assert!(err.to_string().contains("overlapping ranged section copies"));

        let copy_ops = vec![
            NativeRuntimeSectionCopyOp {
                section_index: 0,
                section_offset_words: 0,
                word_len: 2,
                witness_offset_words: 1,
            },
            NativeRuntimeSectionCopyOp {
                section_index: 0,
                section_offset_words: 1,
                word_len: 2,
                witness_offset_words: 3,
            },
        ];
        let err =
            validate_source_bindings(Path::new("source-overlap.dat"), &[], &[], &sections, &copy_ops, 5).unwrap_err();
        assert!(err.to_string().contains("overlapping native runtime source copy ranges"));
    }

    #[test]
    fn rejects_truncated_constraint_count_before_allocation() -> ProofmanResult<()> {
        let mut bytes = minimal_native_runtime_descriptor_prefix();
        bytes.extend_from_slice(&1u64.to_le_bytes());
        let path = write_temp_descriptor("truncated_constraints.dat", &bytes)?;

        let err = NativeRecursiveRuntime::from_dat_file(&path).unwrap_err();
        assert!(err.to_string().contains("truncated native runtime R1CS constraint table"));

        std::fs::remove_file(path)?;
        Ok(())
    }

    #[test]
    fn rejects_truncated_custom_gate_count_before_allocation() -> ProofmanResult<()> {
        let mut bytes = minimal_native_runtime_descriptor_prefix();
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        let path = write_temp_descriptor("truncated_custom_gates.dat", &bytes)?;

        let err = NativeRecursiveRuntime::from_dat_file(&path).unwrap_err();
        assert!(err.to_string().contains("truncated native runtime custom gate table"));

        std::fs::remove_file(path)?;
        Ok(())
    }

    #[test]
    fn rejects_oversized_assertion_count_before_allocation() -> ProofmanResult<()> {
        let mut bytes = Vec::new();
        bytes.extend_from_slice(MAGIC);
        bytes.extend_from_slice(&RUNTIME_VERSION.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&u64::MAX.to_le_bytes());
        let path = write_temp_descriptor("oversized_assertions.dat", &bytes)?;

        let err = NativeRecursiveRuntime::from_dat_file(&path).unwrap_err();
        let message = err.to_string();
        assert!(
            message.contains("native runtime assertion table is too large")
                || message.contains("too many native runtime assertion entries")
        );

        std::fs::remove_file(path)?;
        Ok(())
    }
}
