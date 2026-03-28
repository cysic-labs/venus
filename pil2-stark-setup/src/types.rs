use indexmap::IndexMap;
use serde::{Deserialize, Serialize};

/// Matches the starkinfo.json format read by proofman-common StarkInfo.
/// Fields use camelCase to match JS JSON.stringify output.
#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(rename_all = "camelCase")]
pub struct StarkInfoOutput {
    pub stark_struct: StarkStructOutput,
    pub n_stages: usize,
    pub n_constants: usize,
    pub n_publics: usize,
    pub n_constraints: usize,
    pub opening_points: Vec<i64>,
    pub boundaries: Vec<BoundaryOutput>,
    pub ev_map: Vec<EvMapEntry>,
    pub cm_pols_map: Vec<PolMapEntry>,
    pub const_pols_map: Vec<PolMapEntry>,
    pub map_sections_n: IndexMap<String, usize>,
    pub map_offsets: IndexMap<String, usize>,
    pub q_deg: usize,
    pub q_dim: usize,
    pub c_exp_id: usize,
    pub air_id: usize,
    pub airgroup_id: usize,
    pub custom_commits: Vec<serde_json::Value>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub security: Option<SecurityInfo>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(rename_all = "camelCase")]
pub struct StarkStructOutput {
    pub n_bits: usize,
    pub n_bits_ext: usize,
    pub n_queries: usize,
    pub pow_bits: usize,
    pub merkle_tree_arity: usize,
    pub merkle_tree_custom: bool,
    pub hash_commits: bool,
    pub verification_hash_type: String,
    pub steps: Vec<StepOutput>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct StepOutput {
    pub n_bits: usize,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BoundaryOutput {
    pub name: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub offset_min: Option<i64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub offset_max: Option<i64>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct EvMapEntry {
    #[serde(rename = "type")]
    pub entry_type: String,
    pub id: usize,
    pub opening_pos: usize,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub commit_id: Option<usize>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct PolMapEntry {
    pub stage: usize,
    pub name: String,
    pub dim: usize,
    pub pols_map_id: usize,
    pub stage_id: usize,
    pub stage_pos: usize,
    #[serde(skip_serializing_if = "Option::is_none")]
    #[serde(rename = "imPol")]
    pub im_pol: Option<bool>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct SecurityInfo {
    pub proximity_gap: f64,
    pub proximity_parameter: f64,
    pub regime: String,
}

/// Code block used in expressionsinfo.json and verifierinfo.json
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct CodeOutput {
    pub tmp_used: usize,
    pub code: Vec<CodeEntry>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CodeEntry {
    pub op: String,
    pub dest: CodeRef,
    pub src: Vec<CodeRef>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CodeRef {
    #[serde(rename = "type")]
    pub ref_type: String,
    pub id: usize,
    pub dim: usize,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub prime: Option<i64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub value: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub stage: Option<usize>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub stage_id: Option<usize>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub commit_id: Option<usize>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub opening: Option<usize>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub boundary_id: Option<usize>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub airgroup_id: Option<usize>,
}
