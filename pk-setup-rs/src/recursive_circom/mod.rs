//! Rendering of the recursive Circom circuits (compressor, recursive1, recursive2, final) and of
//! the Circom STARK verifier they embed, from the setup STARK and verifier info.

use std::collections::{BTreeMap, BTreeSet};

use serde::Deserialize;

use crate::stark_struct::StarkStruct;

mod code;
mod field;
mod global;
mod inputs;
mod stark_verifier;
#[cfg(test)]
mod tests;
mod transcript;
mod wrappers;

use code::*;
use field::*;
use global::*;
use inputs::*;
use stark_verifier::*;
use transcript::*;
pub use wrappers::{
    render_compressor_circom, render_final_circom, render_final_compressed_circom,
    render_recursive1_circom, render_recursive2_circom, render_stark_verifier_circom,
};

const MIN_CHUNK_SIZE: usize = 1000;

#[derive(Debug, Clone, Deserialize)]
#[serde(rename_all = "camelCase")]
#[allow(dead_code)]
pub struct CircomStarkInfo {
    pub name: String,
    #[serde(rename = "airgroupId")]
    pub airgroup_id: Option<u32>,
    #[serde(rename = "airId")]
    pub air_id: Option<u32>,
    #[serde(rename = "starkStruct")]
    pub stark_struct: StarkStruct,
    #[serde(rename = "nPublics")]
    pub n_publics: usize,
    #[serde(rename = "nConstants")]
    pub n_constants: usize,
    #[serde(rename = "nStages")]
    pub n_stages: usize,
    #[serde(rename = "cmPolsMap", default)]
    pub cm_pols_map: Vec<CircomPolMap>,
    #[serde(rename = "proofValuesMap", default)]
    pub proof_values_map: Vec<CircomNamedMap>,
    #[serde(rename = "airgroupValuesMap", default)]
    pub airgroup_values_map: Vec<CircomNamedMap>,
    #[serde(rename = "airValuesMap", default)]
    pub air_values_map: Vec<CircomNamedMap>,
    #[serde(rename = "challengesMap", default)]
    pub challenges_map: Vec<CircomChallengeMap>,
    #[serde(rename = "customCommitsMap", default)]
    pub custom_commits_map: Vec<Vec<CircomPolMap>>,
    #[serde(rename = "customCommits", default)]
    pub custom_commits: Vec<CircomCustomCommit>,
    #[serde(rename = "openingPoints", default)]
    pub opening_points: Vec<i64>,
    #[serde(default)]
    pub boundaries: Vec<CircomBoundary>,
    #[serde(rename = "qDeg")]
    pub q_deg: u64,
    #[serde(rename = "mapSectionsN", default)]
    pub map_sections_n: BTreeMap<String, u64>,
    #[serde(rename = "evMap", default)]
    pub ev_map: Vec<CircomEvMap>,
}

#[derive(Debug, Clone, Deserialize)]
#[allow(dead_code)]
pub struct CircomPolMap {
    pub name: String,
    pub stage: u64,
    pub dim: u64,
    #[serde(rename = "stageId")]
    pub stage_id: Option<u64>,
    #[serde(rename = "stagePos")]
    pub stage_pos: Option<u64>,
}

#[derive(Debug, Clone, Deserialize)]
#[allow(dead_code)]
pub struct CircomNamedMap {
    pub name: String,
    pub stage: u64,
}

#[derive(Debug, Clone, Deserialize)]
#[allow(dead_code)]
pub struct CircomChallengeMap {
    pub name: String,
    pub stage: u64,
    pub dim: u64,
    #[serde(rename = "stageId")]
    pub stage_id: u64,
}

#[derive(Debug, Clone, Deserialize)]
#[serde(rename_all = "camelCase")]
#[allow(dead_code)]
pub struct CircomCustomCommit {
    pub name: String,
    pub stage_widths: Vec<u32>,
    pub public_values: Vec<CircomPublicValue>,
}

#[derive(Debug, Clone, Deserialize)]
#[allow(dead_code)]
pub struct CircomPublicValue {
    pub idx: u32,
}

#[derive(Debug, Clone, Deserialize)]
#[serde(rename_all = "camelCase")]
#[allow(dead_code)]
pub struct CircomBoundary {
    pub name: String,
    pub offset_min: Option<u32>,
    pub offset_max: Option<u32>,
}

#[derive(Debug, Clone, Deserialize)]
#[allow(dead_code)]
pub struct CircomEvMap {
    #[serde(rename = "type")]
    pub ev_type: String,
    pub id: u64,
    pub prime: i64,
    #[serde(rename = "openingPos")]
    pub opening_pos: usize,
    #[serde(rename = "commitId")]
    pub commit_id: Option<u64>,
}

#[derive(Debug, Clone, Deserialize)]
#[serde(rename_all = "camelCase")]
#[allow(dead_code)]
pub struct CircomVerifierInfo {
    #[serde(rename = "qVerifier")]
    pub q_verifier: CircomCodeBlock,
    #[serde(rename = "queryVerifier")]
    pub query_verifier: CircomExpressionCode,
}

#[derive(Debug, Clone, Deserialize)]
#[allow(dead_code)]
pub struct CircomGlobalConstraintsInfo {
    #[serde(default)]
    pub constraints: Vec<CircomGlobalConstraint>,
}

#[derive(Debug, Clone, Deserialize)]
#[allow(dead_code)]
pub struct CircomGlobalConstraint {
    #[serde(flatten)]
    pub block: CircomCodeBlock,
    pub boundary: Option<String>,
    pub line: Option<String>,
}

#[derive(Debug, Clone, Deserialize)]
#[serde(rename_all = "camelCase")]
#[allow(dead_code)]
pub struct CircomExpressionCode {
    #[serde(flatten)]
    pub block: CircomCodeBlock,
    #[serde(rename = "expId")]
    pub exp_id: usize,
    pub stage: u64,
}

#[derive(Debug, Clone, Deserialize)]
#[serde(rename_all = "camelCase")]
#[allow(dead_code)]
pub struct CircomCodeBlock {
    #[serde(rename = "tmpUsed")]
    pub tmp_used: u64,
    pub code: Vec<CircomCodeLine>,
}

#[derive(Debug, Clone, Deserialize, PartialEq, Eq)]
#[allow(dead_code)]
pub struct CircomCodeLine {
    pub op: String,
    pub dest: CircomCodeRef,
    pub src: Vec<CircomCodeRef>,
}

#[derive(Debug, Clone, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "camelCase")]
#[allow(dead_code)]
pub struct CircomCodeRef {
    #[serde(rename = "type")]
    pub ref_type: String,
    pub id: Option<u64>,
    pub dim: u64,
    pub stage: Option<u64>,
    #[serde(rename = "stageId")]
    pub stage_id: Option<u64>,
    pub value: Option<String>,
    #[serde(rename = "boundaryId")]
    pub boundary_id: Option<u64>,
    #[serde(rename = "commitId")]
    pub commit_id: Option<u64>,
    #[serde(rename = "airgroupId")]
    pub airgroup_id: Option<u64>,
}

#[derive(Debug, Clone, Deserialize)]
#[serde(rename_all = "camelCase")]
#[allow(dead_code)]
pub struct CircomVadcopInfo {
    pub name: String,
    pub airs: Vec<Vec<CircomVadcopAir>>,
    #[serde(rename = "air_groups")]
    pub air_groups: Vec<String>,
    #[serde(rename = "aggTypes", default)]
    pub agg_types: Vec<Vec<CircomAggType>>,
    pub curve: String,
    #[serde(rename = "latticeSize")]
    pub lattice_size: usize,
    #[serde(rename = "nPublics")]
    pub n_publics: usize,
    #[serde(rename = "proofValuesMap", default)]
    pub proof_values_map: Vec<CircomNamedMap>,
    #[serde(rename = "numChallenges", default)]
    pub num_challenges: Vec<u32>,
}

#[derive(Debug, Clone, Deserialize)]
#[allow(dead_code)]
pub struct CircomVadcopAir {
    pub name: String,
    pub num_rows: u32,
    #[serde(rename = "hasCompressor")]
    pub has_compressor: Option<bool>,
}

#[derive(Debug, Clone, Deserialize)]
#[allow(dead_code)]
pub struct CircomAggType {
    #[serde(rename = "aggType")]
    pub agg_type: i32,
    pub stage: u32,
}

#[derive(Debug, Clone, Copy, Default)]
#[allow(dead_code)]
pub struct StarkInputOptions {
    pub add_publics: bool,
    pub final_verifier: bool,
    pub set_enable_input: Option<u32>,
}

#[derive(Debug, Clone, Copy, Default)]
#[allow(dead_code)]
pub struct VadcopAssignOptions {
    pub add_prefix_agg_types: bool,
    pub set_enable_input: bool,
}

#[derive(Debug, Clone, Copy, Default)]
#[allow(dead_code)]
pub struct StarkVerifierOptions {
    pub input_challenges: bool,
    pub skip_main: bool,
    pub verkey_input: bool,
    pub enable_input: bool,
    pub multi_fri: bool,
}

fn join_u64(values: &[u64]) -> String {
    values.iter().map(u64::to_string).collect::<Vec<_>>().join(",")
}

impl CircomStarkInfo {
    fn n_queries(&self) -> u64 {
        self.stark_struct.n_queries.unwrap_or(0)
    }

    fn map_section_width(&self, key: &str) -> u64 {
        self.map_sections_n.get(key).copied().unwrap_or(0)
    }

    fn challenge_count(&self, stage: u64) -> usize {
        self.challenges_map.iter().filter(|challenge| challenge.stage == stage).count()
    }

    fn q_stage(&self) -> u64 {
        self.n_stages as u64 + 1
    }

    fn has_boundary(&self, name: &str) -> bool {
        self.boundaries.iter().any(|boundary| boundary.name == name)
    }

    fn frame_boundaries(&self) -> Vec<&CircomBoundary> {
        self.boundaries.iter().filter(|boundary| boundary.name == "everyFrame").collect()
    }

    fn arity_bits(&self) -> u64 {
        self.stark_struct.merkle_tree_arity.ilog2() as u64
    }

    fn sibling_width(&self) -> u64 {
        (self.stark_struct.merkle_tree_arity - 1) * 4
    }

    fn s0_sibling_levels(&self) -> u64 {
        self.merkle_levels(self.stark_struct.steps[0].n_bits)
    }

    fn step_sibling_levels(&self, step: usize) -> u64 {
        self.merkle_levels(self.stark_struct.steps[step].n_bits)
    }

    fn merkle_levels(&self, n_bits: u64) -> u64 {
        ceil_div(n_bits, self.arity_bits())
            .saturating_sub(self.stark_struct.last_level_verification)
    }

    fn last_level_size(&self) -> u64 {
        self.stark_struct
            .merkle_tree_arity
            .saturating_pow(self.stark_struct.last_level_verification as u32)
    }
}

fn ceil_div(value: u64, divisor: u64) -> u64 {
    value.div_ceil(divisor)
}

fn prefixed(prefix: &str) -> String {
    if prefix.is_empty() {
        String::new()
    } else {
        format!("{prefix}_")
    }
}

fn suffixed_name(base: &str, airgroup_id: Option<u32>) -> String {
    airgroup_id.map(|id| format!("{base}{id}")).unwrap_or_else(|| base.to_string())
}

fn line(out: &mut String, args: std::fmt::Arguments<'_>) {
    use std::fmt::Write;
    let _ = out.write_fmt(args);
    out.push('\n');
}
