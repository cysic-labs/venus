use std::os::raw::{c_void, c_char};
use fields::PrimeField64;
use std::path::{Path, PathBuf};
use std::collections::HashSet;
use std::sync::RwLock;
use std::fs::File;
use std::io::Read;
use libloading::{Library, Symbol};
use std::ffi::{CString, OsString};
use bytemuck::cast_slice;
use std::sync::atomic::{AtomicBool, Ordering};
use crate::{NativeRecursiveRuntime, RowInfo};

use proofman_starks_lib_c::set_memory_expressions_c;
use proofman_starks_lib_c::{
    expressions_bin_new_c, stark_info_new_c, stark_info_free_c, expressions_bin_free_c, get_map_totaln_c,
    get_map_totaln_custom_commits_fixed_c, get_map_totaln_contributions_c, get_proof_size_c, get_max_n_tmp1_c,
    get_max_n_tmp3_c, get_const_tree_size_c, load_const_pols_c, load_const_tree_c, read_exec_file_c,
    get_proof_pinned_size_c, get_operations_quotient_c, calculate_words_per_row_c,
};
use proofman_util::create_buffer_fast;

use crate::{GlobalInfoAir, ProofmanError};
use crate::ProofType;
use crate::{EvMapEType, StarkInfo};
use crate::ProofmanResult;

pub type GetSizeWitnessFunc = unsafe extern "C" fn() -> u64;

pub type GetCircomCircuitFunc = unsafe extern "C" fn(dat_file: *const c_char) -> *mut c_void;

pub type FreeCircomCircuitFunc = unsafe extern "C" fn(circuit: *mut c_void);

const MAX_STARK_VECTOR_WORDS: usize = if usize::BITS >= 64 { 1usize << 33 } else { usize::MAX / 8 };
const MAX_STARK_COLUMNS: u64 = 1_000_000;
const MAX_SAFE_SHIFT_BITS: u64 = 30;
const MAX_STARK_BLOWUP_BITS: u64 = 32;
const MAX_FRI_QUERIES: u64 = 4096;
const MAX_CHALLENGE_MAP_ENTRIES: usize = 4096;
const MAX_METADATA_MAP_ENTRIES: usize = 1 << 20;
const MAX_QUERY_CONSTANT_VALUES: u64 = 1 << 20;
const SUPPORTED_STARK_N_STAGES: u32 = 2;
const FIELD_EXTENSION: u64 = 3;
const MAX_STARKINFO_JSON_BYTES: u64 = 64 * 1024 * 1024;
const MAX_VERKEY_JSON_BYTES: u64 = 16 * 1024 * 1024;

fn invalid_setup(message: impl Into<String>) -> ProofmanError {
    ProofmanError::InvalidSetup(message.into())
}

fn recursive_library_loading_allowed(value: Option<OsString>) -> bool {
    value
        .and_then(|value| value.into_string().ok())
        .is_some_and(|value| value == "1" || value.eq_ignore_ascii_case("true"))
}

fn unsafe_recursive_library_loading_enabled() -> bool {
    recursive_library_loading_allowed(std::env::var_os("PROOFMAN_ALLOW_UNSAFE_RECURSIVE_SO"))
}

fn read_to_string_limited(path: &Path, max_bytes: u64, label: &str) -> ProofmanResult<String> {
    let file =
        File::open(path).map_err(|err| invalid_setup(format!("Failed to open {label} {}: {err}", path.display())))?;
    let len = file
        .metadata()
        .map_err(|err| invalid_setup(format!("Failed to stat {label} {}: {err}", path.display())))?
        .len();
    if len > max_bytes {
        return Err(invalid_setup(format!("{label} {} exceeds size limit", path.display())));
    }
    let mut contents = String::with_capacity(len as usize);
    file.take(max_bytes + 1)
        .read_to_string(&mut contents)
        .map_err(|err| invalid_setup(format!("Failed to read {label} {}: {err}", path.display())))?;
    if contents.len() as u64 > max_bytes {
        return Err(invalid_setup(format!("{label} {} exceeds size limit", path.display())));
    }
    Ok(contents)
}

/// Parses a verkey, the Goldilocks Merkle root of the constant tree, which is always 4 field elements.
fn parse_goldilocks_verkey<F: PrimeField64>(contents: &str) -> ProofmanResult<Vec<F>> {
    let values: Vec<u64> =
        serde_json::from_str(contents).map_err(|err| invalid_setup(format!("Failed to parse verkey: {err}")))?;
    if values.len() != 4 {
        return Err(invalid_setup(format!("verkey must contain exactly 4 limbs, got {}", values.len())));
    }
    Ok(values.into_iter().map(F::from_u64).collect())
}

fn read_first_u64_limited(path: &Path, label: &str) -> ProofmanResult<u64> {
    let mut file =
        File::open(path).map_err(|err| invalid_setup(format!("Failed to open {label} {}: {err}", path.display())))?;
    let len = file
        .metadata()
        .map_err(|err| invalid_setup(format!("Failed to stat {label} {}: {err}", path.display())))?
        .len();
    if len < 8 {
        return Err(invalid_setup(format!("{label} {} is too short", path.display())));
    }
    let mut word = [0u8; 8];
    file.read_exact(&mut word)
        .map_err(|err| invalid_setup(format!("Failed to read {label} {}: {err}", path.display())))?;
    Ok(u64::from_le_bytes(word))
}

fn checked_domain_size(n_bits: u64, label: &str) -> ProofmanResult<usize> {
    if n_bits > MAX_SAFE_SHIFT_BITS {
        return Err(invalid_setup(format!("{label} n_bits exceeds supported limit")));
    }
    if n_bits >= usize::BITS as u64 {
        return Err(invalid_setup(format!("{label} n_bits is too large")));
    }
    1usize.checked_shl(n_bits as u32).ok_or_else(|| invalid_setup(format!("{label} n_bits is too large")))
}

fn checked_word_product(count: u64, domain_size: usize, label: &str) -> ProofmanResult<usize> {
    if count > MAX_STARK_COLUMNS {
        return Err(invalid_setup(format!("{label} column count exceeds limit")));
    }
    let count = usize::try_from(count).map_err(|_| invalid_setup(format!("{label} column count is too large")))?;
    let words = count.checked_mul(domain_size).ok_or_else(|| invalid_setup(format!("{label} size overflow")))?;
    if words > MAX_STARK_VECTOR_WORDS {
        return Err(invalid_setup(format!("{label} size exceeds limit")));
    }
    Ok(words)
}

fn require_map_section(stark_info: &StarkInfo, section: &str, label: &str) -> ProofmanResult<u64> {
    stark_info
        .map_sections_n
        .get(section)
        .copied()
        .ok_or_else(|| invalid_setup(format!("{label} is missing {section} section")))
}

fn checked_abs_opening(point: i64, label: &str) -> ProofmanResult<u64> {
    if point == i64::MIN {
        return Err(invalid_setup(format!("{label} contains unsupported opening point")));
    }
    Ok(if point < 0 { (-(point + 1)) as u64 + 1 } else { point as u64 })
}

fn validate_opening_points(
    stark_info: &StarkInfo,
    domain_size: usize,
    extended_domain_size: usize,
    label: &str,
) -> ProofmanResult<()> {
    if stark_info.opening_points.is_empty() {
        return Err(invalid_setup(format!("{label} has empty openingPoints")));
    }
    if stark_info.opening_points.len() as u64 > MAX_FRI_QUERIES {
        return Err(invalid_setup(format!("{label} openingPoints exceeds supported limit")));
    }
    let blowup = 1u64
        .checked_shl((stark_info.stark_struct.n_bits_ext - stark_info.stark_struct.n_bits) as u32)
        .ok_or_else(|| invalid_setup(format!("{label} blowup factor is too large")))?;
    let mut seen = HashSet::new();
    for &point in &stark_info.opening_points {
        if !seen.insert(point) {
            return Err(invalid_setup(format!("{label} has duplicate openingPoints")));
        }
        let abs_point = checked_abs_opening(point, label)?;
        if abs_point >= domain_size as u64 {
            return Err(invalid_setup(format!("{label} opening point exceeds trace domain")));
        }
        let extended = abs_point
            .checked_mul(blowup)
            .ok_or_else(|| invalid_setup(format!("{label} opening point extension overflow")))?;
        if extended >= extended_domain_size as u64 {
            return Err(invalid_setup(format!("{label} opening point exceeds extended domain")));
        }
    }
    Ok(())
}

fn validate_pol_span(stage_pos: u64, dim: u64, section_columns: u64, label: &str) -> ProofmanResult<()> {
    if dim != 1 && dim != FIELD_EXTENSION {
        return Err(invalid_setup(format!("{label} has unsupported polynomial dimension")));
    }
    let end = stage_pos.checked_add(dim).ok_or_else(|| invalid_setup(format!("{label} polynomial span overflow")))?;
    if end > section_columns {
        return Err(invalid_setup(format!("{label} polynomial column span is out of range")));
    }
    Ok(())
}

fn validate_pol_maps(stark_info: &StarkInfo, label: &str) -> ProofmanResult<()> {
    let const_columns = require_map_section(stark_info, "const", label)?;
    if const_columns != stark_info.n_constants {
        return Err(invalid_setup(format!("{label} const section does not match nConstants")));
    }

    let cm_pols =
        stark_info.cm_pols_map.as_deref().ok_or_else(|| invalid_setup(format!("{label} is missing cmPolsMap")))?;
    for (idx, pol) in cm_pols.iter().enumerate() {
        if pol.pols_map_id != idx as u64 {
            return Err(invalid_setup(format!("{label} cmPolsMap polsMapId does not match its index")));
        }
        if pol.stage == 0 || pol.stage > u64::from(stark_info.n_stages) + 1 {
            return Err(invalid_setup(format!("{label} cmPolsMap has invalid stage")));
        }
        let section_columns = require_map_section(stark_info, &format!("cm{}", pol.stage), label)?;
        validate_pol_span(pol.stage_pos, pol.dim, section_columns, label)?;
    }

    let const_pols = stark_info
        .const_pols_map
        .as_deref()
        .ok_or_else(|| invalid_setup(format!("{label} is missing constPolsMap")))?;
    for (idx, pol) in const_pols.iter().enumerate() {
        if pol.pols_map_id != idx as u64 {
            return Err(invalid_setup(format!("{label} constPolsMap polsMapId does not match its index")));
        }
        if pol.stage != 0 {
            return Err(invalid_setup(format!("{label} constPolsMap has invalid stage")));
        }
        validate_pol_span(pol.stage_id, pol.dim, stark_info.n_constants, label)?;
    }

    if stark_info.custom_commits_map.len() != stark_info.custom_commits.len() {
        return Err(invalid_setup(format!("{label} customCommitsMap size does not match customCommits")));
    }
    for (commit_id, maybe_pol_map) in stark_info.custom_commits_map.iter().enumerate() {
        let section = format!("{}0", stark_info.custom_commits[commit_id].name);
        let section_columns = require_map_section(stark_info, &section, label)?;
        let pol_map = maybe_pol_map
            .as_deref()
            .ok_or_else(|| invalid_setup(format!("{label} customCommitsMap has a null entry")))?;
        for (idx, pol) in pol_map.iter().enumerate() {
            if pol.commit_id != commit_id as u64 || pol.pols_map_id != idx as u64 {
                return Err(invalid_setup(format!("{label} customCommitsMap metadata does not match its index")));
            }
            validate_pol_span(pol.stage_pos, pol.dim, section_columns, label)?;
        }
    }
    Ok(())
}

fn validate_ev_map(stark_info: &StarkInfo, label: &str) -> ProofmanResult<()> {
    let cm_pols_len = stark_info.cm_pols_map.as_ref().map(|v| v.len()).unwrap_or(0);
    let const_pols_len = stark_info.const_pols_map.as_ref().map(|v| v.len()).unwrap_or(0);
    for ev in &stark_info.ev_map {
        let opening_pos = match ev.opening_pos {
            Some(pos) => {
                usize::try_from(pos).map_err(|_| invalid_setup(format!("{label} evMap openingPos is too large")))?
            }
            None => stark_info
                .opening_points
                .iter()
                .position(|&point| point == ev.prime)
                .ok_or_else(|| invalid_setup(format!("{label} evMap prime is not in openingPoints")))?,
        };
        if opening_pos >= stark_info.opening_points.len() || stark_info.opening_points[opening_pos] != ev.prime {
            return Err(invalid_setup(format!("{label} evMap openingPos does not match prime")));
        }

        match ev.type_ {
            EvMapEType::Cm => {
                if ev.id >= cm_pols_len as u64 {
                    return Err(invalid_setup(format!("{label} evMap committed polynomial id is out of range")));
                }
            }
            EvMapEType::Const => {
                if ev.id >= const_pols_len as u64 {
                    return Err(invalid_setup(format!("{label} evMap const polynomial id is out of range")));
                }
            }
            EvMapEType::Custom => {
                let commit_id = ev
                    .commit_id
                    .ok_or_else(|| invalid_setup(format!("{label} evMap custom entry is missing commitId")))?;
                let commit_idx = usize::try_from(commit_id)
                    .map_err(|_| invalid_setup(format!("{label} evMap custom commitId is too large")))?;
                let pol_map = stark_info
                    .custom_commits_map
                    .get(commit_idx)
                    .and_then(|entry| entry.as_ref())
                    .ok_or_else(|| invalid_setup(format!("{label} evMap custom commitId is out of range")))?;
                if ev.id >= pol_map.len() as u64 {
                    return Err(invalid_setup(format!("{label} evMap custom polynomial id is out of range")));
                }
            }
        }
    }
    Ok(())
}

fn validate_metadata_map_len<T>(
    map: Option<&Vec<T>>,
    key: &str,
    max_entries: usize,
    label: &str,
) -> ProofmanResult<()> {
    if let Some(map) = map {
        if map.len() > max_entries {
            return Err(invalid_setup(format!("{label} {key} exceeds supported length")));
        }
    }
    Ok(())
}

fn validate_challenges_map(stark_info: &StarkInfo, label: &str) -> ProofmanResult<()> {
    let challenges = stark_info
        .challenges_map
        .as_deref()
        .ok_or_else(|| invalid_setup(format!("{label} is missing challengesMap")))?;
    if challenges.is_empty() || challenges.len() > MAX_CHALLENGE_MAP_ENTRIES {
        return Err(invalid_setup(format!("{label} challengesMap has invalid length")));
    }

    let mut seen = HashSet::new();
    let mut xi_count = 0usize;
    let max_stage = u64::from(stark_info.n_stages) + 3;
    for challenge in challenges {
        if challenge.dim != FIELD_EXTENSION {
            return Err(invalid_setup(format!("{label} challengesMap has invalid dimension")));
        }
        if challenge.stage == 0 || challenge.stage > max_stage {
            return Err(invalid_setup(format!("{label} challengesMap has invalid stage")));
        }
        if challenge.stage_id > MAX_CHALLENGE_MAP_ENTRIES as u64 {
            return Err(invalid_setup(format!("{label} challengesMap stageId exceeds supported range")));
        }
        if !seen.insert((challenge.stage, challenge.stage_id)) {
            return Err(invalid_setup(format!("{label} challengesMap has duplicate stage/stageId")));
        }
        if challenge.stage == u64::from(stark_info.n_stages) + 2 && challenge.stage_id == 0 {
            xi_count += 1;
        }
    }
    if xi_count != 1 {
        return Err(invalid_setup(format!("{label} must contain exactly one xi challenge")));
    }
    Ok(())
}

pub fn validate_stark_info(stark_info: &StarkInfo, label: &str) -> ProofmanResult<usize> {
    if stark_info.n_stages != SUPPORTED_STARK_N_STAGES {
        return Err(invalid_setup(format!(
            "{label} has unsupported nStages {}; expected {SUPPORTED_STARK_N_STAGES}",
            stark_info.n_stages
        )));
    }
    let n_bits = stark_info.stark_struct.n_bits;
    let n_bits_ext = stark_info.stark_struct.n_bits_ext;
    if n_bits_ext < n_bits {
        return Err(invalid_setup(format!("{label} has nBitsExt smaller than nBits")));
    }
    if n_bits_ext - n_bits > MAX_STARK_BLOWUP_BITS {
        return Err(invalid_setup(format!("{label} blowup factor exceeds limit")));
    }
    if stark_info.stark_struct.n_queries == 0 || stark_info.stark_struct.n_queries > MAX_FRI_QUERIES {
        return Err(invalid_setup(format!("{label} nQueries exceeds supported limit")));
    }
    let extended_domain_size = checked_domain_size(n_bits_ext, label)?;
    let domain_size = checked_domain_size(n_bits, label)?;
    validate_opening_points(stark_info, domain_size, extended_domain_size, label)?;
    let query_constant_values = stark_info
        .n_constants
        .checked_mul(stark_info.stark_struct.n_queries)
        .ok_or_else(|| invalid_setup(format!("{label} query constant value count overflow")))?;
    if query_constant_values > MAX_QUERY_CONSTANT_VALUES {
        return Err(invalid_setup(format!("{label} query constant values exceed supported limit")));
    }

    validate_metadata_map_len(stark_info.publics_map.as_ref(), "publicsMap", MAX_METADATA_MAP_ENTRIES, label)?;
    validate_metadata_map_len(stark_info.proof_values_map.as_ref(), "proofValuesMap", MAX_METADATA_MAP_ENTRIES, label)?;
    validate_metadata_map_len(
        stark_info.airgroupvalues_map.as_ref(),
        "airgroupValuesMap",
        MAX_METADATA_MAP_ENTRIES,
        label,
    )?;
    validate_metadata_map_len(stark_info.airvalues_map.as_ref(), "airValuesMap", MAX_METADATA_MAP_ENTRIES, label)?;
    validate_challenges_map(stark_info, label)?;
    if stark_info.ev_map.len() > MAX_METADATA_MAP_ENTRIES {
        return Err(invalid_setup(format!("{label} evMap exceeds supported length")));
    }

    for (section, &columns) in &stark_info.map_sections_n {
        if columns > MAX_STARK_COLUMNS {
            return Err(invalid_setup(format!("{label} section {section} column count exceeds limit")));
        }
        checked_word_product(columns, domain_size, &format!("{label} section {section}"))?;
    }
    for stage in 1..=(u64::from(stark_info.n_stages) + 1) {
        let section = format!("cm{stage}");
        if !stark_info.map_sections_n.contains_key(&section) {
            return Err(invalid_setup(format!("{label} is missing {section} section")));
        }
    }
    let const_columns = require_map_section(stark_info, "const", label)?;
    if const_columns != stark_info.n_constants {
        return Err(invalid_setup(format!("{label} const section does not match nConstants")));
    }
    if stark_info.q_dim != FIELD_EXTENSION {
        return Err(invalid_setup(format!("{label} qDim must match field extension width")));
    }
    if stark_info.q_deg == 0 {
        return Err(invalid_setup(format!("{label} qDeg must be nonzero")));
    }
    let blowup = 1u64
        .checked_shl((n_bits_ext - n_bits) as u32)
        .ok_or_else(|| invalid_setup(format!("{label} blowup factor is too large")))?;
    if stark_info.q_deg > blowup {
        return Err(invalid_setup(format!("{label} qDeg exceeds quotient blowup")));
    }
    let expected_q_columns = stark_info
        .q_deg
        .checked_mul(stark_info.q_dim)
        .ok_or_else(|| invalid_setup(format!("{label} quotient column count overflow")))?;
    if require_map_section(stark_info, "cm3", label)? != expected_q_columns {
        return Err(invalid_setup(format!("{label} cm3 section does not match qDeg*qDim")));
    }
    for custom_commit in &stark_info.custom_commits {
        if custom_commit.stage_widths.is_empty() {
            return Err(invalid_setup(format!("{label} custom commit {} has empty stageWidths", custom_commit.name)));
        }
        for (idx, &stage_width) in custom_commit.stage_widths.iter().enumerate() {
            checked_word_product(
                u64::from(stage_width),
                domain_size,
                &format!("{label} custom commit {} stageWidths[{idx}]", custom_commit.name),
            )?;
        }
        let section = format!("{}0", custom_commit.name);
        let section_columns = stark_info.map_sections_n.get(&section).copied().ok_or_else(|| {
            invalid_setup(format!("{label} custom commit {} is missing {section} section", custom_commit.name))
        })?;
        let expected_columns = u64::from(custom_commit.stage_widths[0]);
        if section_columns != expected_columns {
            return Err(invalid_setup(format!(
                "{label} custom commit {} stageWidths[0] does not match {section} section",
                custom_commit.name
            )));
        }
    }
    validate_pol_maps(stark_info, label)?;
    validate_ev_map(stark_info, label)?;
    if stark_info.boundaries.is_empty() {
        return Err(invalid_setup(format!("{label} must contain at least one boundary")));
    }
    for boundary in &stark_info.boundaries {
        match boundary.name.as_str() {
            "everyRow" | "firstRow" | "lastRow" => {
                if boundary.offset_min.is_some() || boundary.offset_max.is_some() {
                    return Err(invalid_setup(format!(
                        "{label} {} boundary must not carry frame offsets",
                        boundary.name
                    )));
                }
            }
            "everyFrame" => {
                let offset_min = boundary
                    .offset_min
                    .ok_or_else(|| invalid_setup(format!("{label} everyFrame boundary is missing offsetMin")))?;
                let offset_max = boundary
                    .offset_max
                    .ok_or_else(|| invalid_setup(format!("{label} everyFrame boundary is missing offsetMax")))?;
                let roots = offset_min
                    .checked_add(offset_max)
                    .ok_or_else(|| invalid_setup(format!("{label} everyFrame boundary offset overflow")))?;
                if roots > domain_size as u64 {
                    return Err(invalid_setup(format!("{label} everyFrame boundary offsets exceed trace size")));
                }
            }
            _ => return Err(invalid_setup(format!("{label} unsupported boundary type {}", boundary.name))),
        }
    }
    checked_word_product(stark_info.n_constants, domain_size, label)?;
    Ok(domain_size)
}

fn checked_packed_const_words(words_per_row: u64, domain_size: usize, n_constants: u64) -> ProofmanResult<usize> {
    let packed = checked_word_product(words_per_row, domain_size, "packed const polynomials")?;
    let n_constants =
        usize::try_from(n_constants).map_err(|_| invalid_setup("packed const n_constants is too large"))?;
    let words = packed
        .checked_add(1)
        .and_then(|words| words.checked_add(n_constants))
        .ok_or_else(|| invalid_setup("packed const polynomial size overflow"))?;
    if words > MAX_STARK_VECTOR_WORDS {
        return Err(invalid_setup("packed const polynomial size exceeds limit"));
    }
    Ok(words)
}

#[derive(Debug)]
#[repr(C)]
pub struct SetupC {
    pub p_stark_info: *mut c_void,
    pub p_expressions_bin: *mut c_void,
}

unsafe impl Send for SetupC {}
unsafe impl Sync for SetupC {}

impl From<&SetupC> for *mut c_void {
    fn from(setup: &SetupC) -> *mut c_void {
        setup as *const SetupC as *mut c_void
    }
}

impl Drop for SetupC {
    fn drop(&mut self) {
        stark_info_free_c(self.p_stark_info);
        expressions_bin_free_c(self.p_expressions_bin);
    }
}

/// Air instance context for managing air instances (traces)
#[derive(Debug)]
#[allow(dead_code)]
pub struct Setup<F: PrimeField64> {
    pub airgroup_id: usize,
    pub air_id: usize,
    pub p_setup: SetupC,
    pub stark_info: StarkInfo,
    pub const_pols_size: usize,
    pub const_pols_size_packed: usize,
    pub const_tree_size: usize,
    pub const_pols_path: String,
    pub const_pols_tree_path: String,
    pub const_pols: Vec<F>,
    pub const_pols_tree: Vec<F>,
    pub prover_buffer_size: u64,
    pub contributions_size: u64,
    pub custom_commits_fixed_buffer_size: u64,
    pub proof_size: u64,
    pub pinned_proof_size: u64,
    pub setup_path: PathBuf,
    pub setup_type: ProofType,
    pub size_witness: RwLock<Option<u64>>,
    pub circom_library: RwLock<Option<Library>>,
    pub circom_circuit: RwLock<Option<*mut c_void>>,
    pub native_runtime: RwLock<Option<NativeRecursiveRuntime>>,
    pub air_name: String,
    pub verkey: Vec<F>,
    pub verkey_file: String,
    pub exec_data: RwLock<Option<Vec<u64>>>,
    pub n_cols: u64,
    pub n_operations_quotient: u64,
    pub preallocate: bool,
    pub const_pols_loaded: AtomicBool,
}

impl<F: PrimeField64> Drop for Setup<F> {
    fn drop(&mut self) {
        let mut circom_circuit_guard = self.circom_circuit.write().unwrap();

        if circom_circuit_guard.is_some() {
            let circom_circuit = circom_circuit_guard.take().unwrap();

            let circom_library_guard = self.circom_library.read().unwrap();

            if let Some(circom_library) = circom_library_guard.as_ref() {
                unsafe {
                    let free_circom_circuit: Symbol<FreeCircomCircuitFunc> =
                        circom_library.get(b"freeCircuit\0").expect("Failed to get freeCircuit symbol");

                    free_circom_circuit(circom_circuit);
                }
            }
        }
    }
}

#[allow(clippy::too_many_arguments)]
impl<F: PrimeField64> Setup<F> {
    pub fn new(
        setup_path: &Path,
        airgroup_id: usize,
        air_id: usize,
        air_info: &GlobalInfoAir,
        setup_type: &ProofType,
        verify_constraints: bool,
        preallocate: bool,
        recursive2_path: Option<&PathBuf>,
    ) -> Self {
        let stark_info_path = match setup_type {
            ProofType::Recursive1 => {
                let setup_path_recursive2 =
                    recursive2_path.expect("recursive2_path must be provided for Recursive1 proof type");
                setup_path_recursive2.display().to_string() + ".starkinfo.json"
            }
            _ => setup_path.display().to_string() + ".starkinfo.json",
        };

        let expressions_bin_path = match setup_type {
            ProofType::Recursive1 => {
                let setup_path_recursive2 =
                    recursive2_path.expect("recursive2_path must be provided for Recursive1 proof type");
                setup_path_recursive2.display().to_string() + ".bin"
            }
            _ => setup_path.display().to_string() + ".bin",
        };

        let const_pols_path = match !cfg!(feature = "gpu") {
            true => setup_path.display().to_string() + ".const",
            false => setup_path.display().to_string() + ".const_gpu",
        };

        let const_pols_tree_path = match !cfg!(feature = "gpu") {
            true => setup_path.display().to_string() + ".consttree",
            false => setup_path.display().to_string() + ".consttree_gpu",
        };

        let (
            stark_info,
            p_stark_info,
            p_expressions_bin,
            const_pols,
            const_pols_tree,
            verkey,
            verkey_file,
            const_pols_size,
            const_pols_size_packed,
            const_tree_size,
            prover_buffer_size,
            contributions_size,
            custom_commits_fixed_buffer_size,
            proof_size,
            pinned_proof_size,
            n_cols,
            n_operations_quotient,
        ) = if setup_type == &ProofType::Compressor && !air_info.has_compressor.unwrap_or(false) {
            // If the condition is met, use None for each pointer
            (
                StarkInfo::default(),
                std::ptr::null_mut(),
                std::ptr::null_mut(),
                Vec::new(),
                Vec::new(),
                Vec::new(),
                String::new(),
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
            )
        } else {
            // Otherwise, initialize the pointers with their respective values
            let stark_info_json =
                read_to_string_limited(Path::new(&stark_info_path), MAX_STARKINFO_JSON_BYTES, "starkinfo")
                    .unwrap_or_else(|err| panic!("{err}"));
            let stark_info = StarkInfo::from_json(&stark_info_json);
            let domain_size = validate_stark_info(&stark_info, &stark_info_path).unwrap_or_else(|err| panic!("{err}"));
            let recursive = setup_type != &ProofType::Basic;
            let recursive_final = setup_type == &ProofType::RecursiveF;
            let preallocate_const = preallocate && cfg!(feature = "gpu");
            let p_stark_info = stark_info_new_c(
                stark_info_path.as_str(),
                recursive_final,
                recursive,
                verify_constraints,
                false,
                cfg!(feature = "gpu"),
                preallocate_const,
            );
            let expressions_bin = expressions_bin_new_c(expressions_bin_path.as_str(), false, false);
            let n_max_tmp1 = get_max_n_tmp1_c(expressions_bin);
            let n_max_tmp3 = get_max_n_tmp3_c(expressions_bin);
            set_memory_expressions_c(p_stark_info, n_max_tmp1, n_max_tmp3);
            let prover_buffer_size = get_map_totaln_c(p_stark_info);
            let contributions_size = get_map_totaln_contributions_c(p_stark_info);
            let custom_commits_fixed_buffer_size = get_map_totaln_custom_commits_fixed_c(p_stark_info);
            let proof_size = get_proof_size_c(p_stark_info);
            let pinned_proof_size = get_proof_pinned_size_c(p_stark_info);
            let const_pols_size = checked_word_product(stark_info.n_constants, domain_size, "constant polynomials")
                .unwrap_or_else(|err| panic!("{err}"));

            let const_tree_size =
                usize::try_from(get_const_tree_size_c(p_stark_info)).expect("const tree size does not fit in usize");
            if const_tree_size > MAX_STARK_VECTOR_WORDS {
                panic!("const tree size exceeds limit");
            }

            let n_operations_quotient = get_operations_quotient_c(expressions_bin, p_stark_info) as u64;

            let verkey_file = setup_path.display().to_string() + ".verkey.json";

            let verkey = if setup_type == &ProofType::RecursiveF {
                vec![]
            } else {
                let json_str = read_to_string_limited(Path::new(&verkey_file), MAX_VERKEY_JSON_BYTES, "verkey")
                    .unwrap_or_else(|err| panic!("{err}"));
                parse_goldilocks_verkey(&json_str).unwrap_or_else(|err| panic!("{err}"))
            };

            let n_cols = stark_info.map_sections_n["cm1"];

            if verify_constraints && !cfg!(feature = "gpu") {
                // SAFETY: the const polynomial loader writes the whole buffer before it is read.
                let const_pols: Vec<F> = unsafe { create_buffer_fast(const_pols_size) };
                (
                    stark_info,
                    p_stark_info,
                    expressions_bin,
                    const_pols,
                    Vec::new(),
                    verkey,
                    verkey_file,
                    const_pols_size,
                    0,
                    const_tree_size,
                    prover_buffer_size,
                    contributions_size,
                    custom_commits_fixed_buffer_size,
                    proof_size,
                    pinned_proof_size,
                    n_cols,
                    n_operations_quotient,
                )
            } else {
                // SAFETY: the const polynomial and const tree loaders write both buffers before they are read.
                let const_pols: Vec<F> = unsafe { create_buffer_fast(const_pols_size) };
                let const_pols_tree: Vec<F> = unsafe { create_buffer_fast(const_tree_size) };
                let mut const_pols_size_packed = 0;
                if cfg!(feature = "gpu") && setup_type != &ProofType::RecursiveF {
                    let words_per_row: u64 = if Path::new(&const_pols_path).exists() {
                        read_first_u64_limited(Path::new(&const_pols_path), "GPU const pols")
                            .unwrap_or_else(|err| panic!("{err}"))
                    } else {
                        calculate_words_per_row_c(p_stark_info, &(setup_path.display().to_string() + ".const"))
                    };
                    const_pols_size_packed =
                        checked_packed_const_words(words_per_row, domain_size, stark_info.n_constants)
                            .unwrap_or_else(|err| panic!("{err}"));
                }
                (
                    stark_info,
                    p_stark_info,
                    expressions_bin,
                    const_pols,
                    const_pols_tree,
                    verkey,
                    verkey_file,
                    const_pols_size,
                    const_pols_size_packed,
                    const_tree_size,
                    prover_buffer_size,
                    contributions_size,
                    custom_commits_fixed_buffer_size,
                    proof_size,
                    pinned_proof_size,
                    n_cols,
                    n_operations_quotient,
                )
            }
        };

        Self {
            air_id,
            airgroup_id,
            stark_info,
            p_setup: SetupC { p_stark_info, p_expressions_bin },
            const_pols_size,
            const_pols_size_packed,
            const_tree_size,
            const_pols,
            const_pols_tree,
            verkey,
            verkey_file,
            prover_buffer_size,
            custom_commits_fixed_buffer_size,
            contributions_size,
            proof_size,
            pinned_proof_size,
            size_witness: RwLock::new(None),
            circom_circuit: RwLock::new(None),
            circom_library: RwLock::new(None),
            native_runtime: RwLock::new(None),
            exec_data: RwLock::new(None),
            setup_path: setup_path.to_path_buf().clone(),
            setup_type: setup_type.clone(),
            air_name: air_info.name.clone(),
            const_pols_path,
            const_pols_tree_path,
            n_cols,
            n_operations_quotient,
            preallocate,
            const_pols_loaded: AtomicBool::new(false),
        }
    }

    /// Loads the constant polynomials into this setup's buffer.
    ///
    /// # Safety
    ///
    /// The loader writes through a shared reference: no reference to `self.const_pols` may be used
    /// while it runs.
    pub unsafe fn load_const_pols(&self) {
        if self.const_pols_loaded.load(Ordering::Acquire) {
            return;
        }
        assert!(
            self.const_pols.len() >= self.const_pols_size,
            "const_pols buffer too small: got {}, expected at least {}",
            self.const_pols.len(),
            self.const_pols_size
        );
        load_const_pols_c(
            self.const_pols.as_ptr() as *mut u8,
            self.const_pols_path.as_str(),
            self.const_pols_size as u64 * 8,
        );
        self.const_pols_loaded.store(true, Ordering::Release);
    }

    /// Loads the constant polynomial tree into this setup's buffer.
    ///
    /// # Safety
    ///
    /// The loader writes through a shared reference: no reference to `self.const_pols_tree` may be
    /// used while it runs.
    pub unsafe fn load_const_pols_tree(&self) -> ProofmanResult<()> {
        let const_pols_tree_size = self.const_tree_size;
        if self.const_pols_tree.len() < const_pols_tree_size {
            return Err(invalid_setup(format!(
                "const tree buffer too small: got {}, expected at least {}",
                self.const_pols_tree.len(),
                const_pols_tree_size
            )));
        }

        load_const_tree_c(
            self.p_setup.p_stark_info,
            self.const_pols_tree.as_ptr() as *mut u8,
            self.const_pols_tree_path.as_str(),
            (const_pols_tree_size * 8) as u64,
            &(self.setup_path.display().to_string() + ".verkey.json"),
        );
        Ok(())
    }

    pub fn get_const_pols(&self, first_row: usize, num_rows: usize, offset: Option<usize>) -> Vec<RowInfo> {
        let offset = offset.unwrap_or(1);
        let num_rows_available = self.const_pols.len() / self.stark_info.n_constants as usize;

        (0..num_rows)
            .map(|i| first_row + i * offset)
            .take_while(|&row| row < num_rows_available)
            .map(|row| {
                let start = row * self.stark_info.n_constants as usize;
                let end = start + self.stark_info.n_constants as usize;
                let values = self.const_pols[start..end].iter().map(|v| F::as_canonical_u64(v)).collect();
                RowInfo { row, values }
            })
            .collect()
    }

    pub fn get_const_ptr(&self) -> *mut u8 {
        self.const_pols.as_ptr() as *mut u8
    }

    pub fn get_const_tree_ptr(&self) -> *mut u8 {
        self.const_pols_tree.as_ptr() as *mut u8
    }

    pub fn get_vk(&self) -> Vec<u8> {
        let verkey_u64: Vec<u64> = self.verkey.iter().map(|x| x.as_canonical_u64()).collect();
        cast_slice(&verkey_u64).to_vec()
    }

    pub fn set_circom_circuit(&self) -> ProofmanResult<()> {
        let dat_filename = self.setup_path.display().to_string() + ".dat";
        let runtime_dat_filename = self.setup_path.display().to_string() + ".runtime.dat";
        let mut native_runtime_errors = Vec::new();
        for dat_path in [Path::new(dat_filename.as_str()), Path::new(runtime_dat_filename.as_str())] {
            if dat_path.exists() {
                match NativeRecursiveRuntime::from_dat_file(dat_path) {
                    Ok(runtime) => {
                        *self.size_witness.write().unwrap() = Some(runtime.size_witness_words);
                        *self.native_runtime.write().unwrap() = Some(runtime);
                        return Ok(());
                    }
                    Err(err) => {
                        native_runtime_errors.push(format!("{}: {err}", dat_path.display()));
                    }
                }
            }
        }

        let lib_extension = if cfg!(target_os = "macos") { ".dylib" } else { ".so" };
        let rust_lib_filename = self.setup_path.display().to_string() + lib_extension;
        let rust_lib_path = Path::new(rust_lib_filename.as_str());

        if !rust_lib_path.exists() {
            if !native_runtime_errors.is_empty() {
                return Err(ProofmanError::InvalidSetup(format!(
                    "Failed to load native recursive runtime from {}",
                    native_runtime_errors.join("; ")
                )));
            }
            return Err(ProofmanError::InvalidSetup(format!(
                "Native recursive runtime not found at paths: {dat_filename:?}, {runtime_dat_filename:?}"
            )));
        }
        if !unsafe_recursive_library_loading_enabled() {
            let native_error_suffix = if native_runtime_errors.is_empty() {
                String::new()
            } else {
                format!(" Native runtime parse errors: {}", native_runtime_errors.join("; "))
            };
            return Err(ProofmanError::InvalidSetup(format!(
                "Refusing to load recursive setup dynamic library {rust_lib_path:?}; \
                 use native .dat/.runtime.dat setup artifacts or set \
                 PROOFMAN_ALLOW_UNSAFE_RECURSIVE_SO=1 for a trusted legacy setup.{native_error_suffix}"
            )));
        }

        tracing::warn!(
            "Loading trusted legacy recursive setup dynamic library {:?}; this executes host code",
            rust_lib_path
        );
        let dat_filename_str = CString::new(dat_filename.as_str()).unwrap();
        let dat_filename_ptr = dat_filename_str.as_ptr() as *mut std::os::raw::c_char;

        let library: Library = unsafe { Library::new(rust_lib_path)? };

        let circom_circuit = unsafe {
            let init_circom_circuit: Symbol<GetCircomCircuitFunc> = library.get(b"initCircuit\0")?;
            Some(init_circom_circuit(dat_filename_ptr))
        };

        let size_witness = unsafe {
            let get_size_witness: Symbol<GetSizeWitnessFunc> = library.get(b"getSizeWitness\0")?;
            Some(get_size_witness())
        };

        *self.circom_library.write().unwrap() = Some(library);
        *self.size_witness.write().unwrap() = size_witness;
        *self.circom_circuit.write().unwrap() = circom_circuit;
        Ok(())
    }

    pub fn set_exec_file_data(&self) -> ProofmanResult<()> {
        let exec_filename = self.setup_path.display().to_string() + ".exec";
        let exec_filename_str = CString::new(exec_filename.as_str()).unwrap();
        let exec_filename_ptr = exec_filename_str.as_ptr() as *mut std::os::raw::c_char;

        let mut file = File::open(exec_filename)?;

        let mut bytes = [0u8; 8];

        file.read_exact(&mut bytes)?;
        let n_adds = u64::from_le_bytes(bytes);

        file.read_exact(&mut bytes)?;
        let n_smap = u64::from_le_bytes(bytes);

        let exec_data_size = 2 + n_adds * 4 + n_smap * self.n_cols;
        let mut exec_file_data: Vec<u64> = vec![0; exec_data_size as usize];
        read_exec_file_c(exec_file_data.as_mut_ptr(), exec_filename_ptr, self.n_cols);
        *self.exec_data.write().unwrap() = Some(exec_file_data);
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{Boundary, CustomCommits, EvMap, PolMap, PublicValues};
    use std::collections::HashMap;

    fn minimal_valid_stark_info() -> StarkInfo {
        let mut map_sections_n = HashMap::new();
        map_sections_n.insert("const".to_string(), 1);
        map_sections_n.insert("cm1".to_string(), 1);
        map_sections_n.insert("cm2".to_string(), 1);
        map_sections_n.insert("cm3".to_string(), FIELD_EXTENSION);

        let mut stark_info = StarkInfo::default();
        stark_info.stark_struct.n_bits = 4;
        stark_info.stark_struct.n_bits_ext = 4;
        stark_info.stark_struct.n_queries = 1;
        stark_info.n_stages = SUPPORTED_STARK_N_STAGES;
        stark_info.n_constants = 1;
        stark_info.q_deg = 1;
        stark_info.q_dim = FIELD_EXTENSION;
        stark_info.opening_points = vec![0];
        stark_info.boundaries = vec![Boundary { name: "everyRow".to_string(), offset_min: None, offset_max: None }];
        stark_info.challenges_map = Some(vec![PolMap {
            name: "std_xi".to_string(),
            stage: u64::from(SUPPORTED_STARK_N_STAGES) + 2,
            dim: FIELD_EXTENSION,
            stage_id: 0,
            ..PolMap::default()
        }]);
        stark_info.const_pols_map =
            Some(vec![PolMap { name: "const".to_string(), dim: 1, stage_id: 0, pols_map_id: 0, ..PolMap::default() }]);
        stark_info.cm_pols_map = Some(Vec::new());
        stark_info.map_sections_n = map_sections_n;
        stark_info
    }

    #[test]
    fn stark_info_validation_rejects_bad_bit_order() {
        let mut stark_info = minimal_valid_stark_info();
        stark_info.stark_struct.n_bits = 20;
        stark_info.stark_struct.n_bits_ext = 19;
        let err = validate_stark_info(&stark_info, "bad.starkinfo.json").unwrap_err();
        assert!(matches!(err, ProofmanError::InvalidSetup(_)));
    }

    #[test]
    fn stark_info_validation_rejects_cpp_unsupported_bit_width() {
        let mut stark_info = minimal_valid_stark_info();
        stark_info.stark_struct.n_bits = MAX_SAFE_SHIFT_BITS + 1;
        stark_info.stark_struct.n_bits_ext = MAX_SAFE_SHIFT_BITS + 1;
        let err = validate_stark_info(&stark_info, "bad.starkinfo.json").unwrap_err();
        assert!(matches!(err, ProofmanError::InvalidSetup(_)));
    }

    #[test]
    fn stark_info_validation_rejects_unsupported_stage_count() {
        let mut stark_info = minimal_valid_stark_info();
        stark_info.n_stages = SUPPORTED_STARK_N_STAGES + 1;
        let err = validate_stark_info(&stark_info, "bad.starkinfo.json").unwrap_err();
        assert!(matches!(err, ProofmanError::InvalidSetup(_)));
    }

    #[test]
    fn stark_info_validation_rejects_missing_stage_section() {
        let mut stark_info = minimal_valid_stark_info();
        stark_info.map_sections_n.remove("cm3");
        let err = validate_stark_info(&stark_info, "bad.starkinfo.json").unwrap_err();
        assert!(matches!(err, ProofmanError::InvalidSetup(_)));
    }

    #[test]
    fn stark_info_validation_rejects_empty_custom_commit_stage_widths() {
        let mut stark_info = minimal_valid_stark_info();
        stark_info.custom_commits.push(CustomCommits {
            name: "custom".to_string(),
            stage_widths: Vec::new(),
            public_values: Vec::<PublicValues>::new(),
        });
        let err = validate_stark_info(&stark_info, "bad.starkinfo.json").unwrap_err();
        assert!(matches!(err, ProofmanError::InvalidSetup(_)));
    }

    #[test]
    fn stark_info_validation_rejects_custom_commit_section_mismatch() {
        let mut stark_info = minimal_valid_stark_info();
        stark_info.map_sections_n.insert("custom0".to_string(), 2);
        stark_info.custom_commits.push(CustomCommits {
            name: "custom".to_string(),
            stage_widths: vec![1],
            public_values: Vec::<PublicValues>::new(),
        });
        let err = validate_stark_info(&stark_info, "bad.starkinfo.json").unwrap_err();
        assert!(matches!(err, ProofmanError::InvalidSetup(_)));
    }

    #[test]
    fn stark_info_validation_accepts_custom_commit_section_match() {
        let mut stark_info = minimal_valid_stark_info();
        stark_info.map_sections_n.insert("custom0".to_string(), 1);
        stark_info.custom_commits.push(CustomCommits {
            name: "custom".to_string(),
            stage_widths: vec![1],
            public_values: Vec::<PublicValues>::new(),
        });
        stark_info.custom_commits_map.push(Some(Vec::new()));
        assert!(validate_stark_info(&stark_info, "ok.starkinfo.json").is_ok());
    }

    #[test]
    fn stark_info_validation_rejects_bad_q_dim() {
        let mut stark_info = minimal_valid_stark_info();
        stark_info.q_dim = 1;
        let err = validate_stark_info(&stark_info, "bad.starkinfo.json").unwrap_err();
        assert!(matches!(err, ProofmanError::InvalidSetup(_)));
    }

    #[test]
    fn stark_info_validation_rejects_opening_point_out_of_domain() {
        let mut stark_info = minimal_valid_stark_info();
        stark_info.opening_points = vec![16];
        let err = validate_stark_info(&stark_info, "bad.starkinfo.json").unwrap_err();
        assert!(matches!(err, ProofmanError::InvalidSetup(_)));
    }

    #[test]
    fn stark_info_validation_rejects_bad_ev_map_id() {
        let mut stark_info = minimal_valid_stark_info();
        stark_info.ev_map.push(EvMap {
            type_: EvMapEType::Const,
            id: 1,
            prime: 0,
            opening_pos: Some(0),
            ..EvMap::default()
        });
        let err = validate_stark_info(&stark_info, "bad.starkinfo.json").unwrap_err();
        assert!(matches!(err, ProofmanError::InvalidSetup(_)));
    }

    #[test]
    fn stark_info_validation_rejects_empty_boundaries() {
        let mut stark_info = minimal_valid_stark_info();
        stark_info.boundaries.clear();
        let err = validate_stark_info(&stark_info, "bad.starkinfo.json").unwrap_err();
        assert!(matches!(err, ProofmanError::InvalidSetup(_)));
    }

    #[test]
    fn stark_info_validation_rejects_offsets_on_non_frame_boundary() {
        let mut stark_info = minimal_valid_stark_info();
        stark_info.boundaries[0].offset_min = Some(1);
        let err = validate_stark_info(&stark_info, "bad.starkinfo.json").unwrap_err();
        assert!(matches!(err, ProofmanError::InvalidSetup(_)));
    }

    #[test]
    fn stark_info_validation_accepts_frame_boundary_offsets() {
        let mut stark_info = minimal_valid_stark_info();
        stark_info.boundaries.push(Boundary {
            name: "everyFrame".to_string(),
            offset_min: Some(1),
            offset_max: Some(1),
        });
        assert!(validate_stark_info(&stark_info, "ok.starkinfo.json").is_ok());
    }

    #[test]
    fn recursive_library_loading_requires_opt_in_value() {
        assert!(!recursive_library_loading_allowed(None));
        assert!(!recursive_library_loading_allowed(Some(OsString::new())));
        assert!(!recursive_library_loading_allowed(Some(OsString::from("0"))));
        assert!(!recursive_library_loading_allowed(Some(OsString::from("false"))));
        assert!(recursive_library_loading_allowed(Some(OsString::from("1"))));
        assert!(recursive_library_loading_allowed(Some(OsString::from("true"))));
        assert!(recursive_library_loading_allowed(Some(OsString::from("TRUE"))));
    }
}
