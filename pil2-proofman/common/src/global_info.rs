use std::path::{Path, PathBuf};

use serde::{Serialize, Deserialize};
use serde_json::Value;
use std::fs;

use crate::ProofType;
use crate::{ProofmanResult, ProofmanError};

const FIELD_EXTENSION_WORDS: usize = 3;
const MAX_GLOBAL_AIR_GROUPS: usize = 1 << 16;
const MAX_GLOBAL_AIR_INSTANCES: usize = 1 << 17;
const MAX_GLOBAL_STAGE_COUNT: usize = 64;
const MAX_GLOBAL_PUBLICS: usize = 1 << 24;
const MAX_GLOBAL_PROOF_VALUES: usize = 1 << 20;
const MAX_GLOBAL_CHALLENGES: usize = 1 << 20;
const MAX_GLOBAL_AGG_VALUES: usize = 1 << 20;
const MAX_GLOBAL_PUBLIC_LENGTH_ENTRIES: usize = 1 << 24;
const MAX_GLOBAL_TRANSCRIPT_ARITY: usize = 1 << 20;
const MAX_GLOBAL_LATTICE_SIZE: usize = 1 << 30;

#[derive(Clone, Deserialize)]
pub struct ProofValueMap {
    pub name: String,
    #[serde(default)]
    pub id: u64,
    #[serde(default)]
    pub stage: u64,
}
#[derive(Clone, Deserialize)]
pub struct PublicMap {
    pub name: String,
    #[serde(default)]
    pub stage: u64,
    #[serde(default)]
    pub lengths: Vec<u64>,
}

#[derive(Clone, Serialize, Deserialize, PartialEq)]
#[serde(rename_all = "PascalCase")]
pub enum CurveType {
    None,
    EcGFp5,
    EcMasFp5,
}

#[derive(Clone, Deserialize)]
pub struct GlobalInfo {
    pub folder_path: String,
    pub name: String,
    pub airs: Vec<Vec<GlobalInfoAir>>,
    pub air_groups: Vec<String>,
    pub curve: CurveType,

    #[serde(rename = "latticeSize")]
    pub lattice_size: Option<usize>,
    #[serde(rename = "aggTypes")]
    pub agg_types: Vec<Vec<GlobalInfoAggType>>,

    #[serde(rename = "nPublics")]
    pub n_publics: usize,
    #[serde(rename = "numChallenges")]
    pub n_challenges: Vec<usize>,

    #[serde(rename = "numProofValues", default)]
    pub n_proof_values: Vec<usize>,

    #[serde(rename = "proofValuesMap")]
    pub proof_values_map: Option<Vec<ProofValueMap>>,

    #[serde(rename = "publicsMap")]
    pub publics_map: Option<Vec<PublicMap>>,

    #[serde(rename = "transcriptArity")]
    pub transcript_arity: usize,
}

#[derive(Debug, Clone, Deserialize)]
pub struct GlobalInfoAir {
    pub name: String,

    #[serde(rename = "hasCompressor", default)]
    pub has_compressor: Option<bool>,

    pub num_rows: usize,
}

impl GlobalInfoAir {
    pub fn new(name: String) -> Self {
        Self { name, has_compressor: None, num_rows: 0 }
    }
}

#[derive(Clone, Deserialize, Debug)]
pub struct GlobalInfoAggType {
    #[serde(rename = "aggType")]
    pub agg_type: usize,
}

#[derive(Clone, Deserialize)]
pub struct GlobalInfoStepsFRI {
    #[serde(rename = "nBits")]
    pub n_bits: usize,
}

impl GlobalInfo {
    pub fn new(proving_key_path: &Path) -> ProofmanResult<Self> {
        tracing::debug!("··· Loading GlobalInfo JSON {}", proving_key_path.display());

        Self::from_file(&proving_key_path.display().to_string())
    }

    pub fn from_file(folder_path: &String) -> ProofmanResult<Self> {
        let file_path = Path::new(folder_path).join("pilout.globalInfo.json");

        // Read the JSON file
        let global_info_json = fs::read_to_string(&file_path)?;

        // Parse the JSON into a Value
        let mut global_info_value: Value = serde_json::from_str(&global_info_json)?;

        // Add the folder_path to the JSON object
        if let Some(obj) = global_info_value.as_object_mut() {
            obj.insert("folder_path".to_string(), Value::String(folder_path.to_string()));
        } else {
            return Err(ProofmanError::InvalidConfiguration(format!("JSON is not an object: {}", file_path.display())));
        }

        // Serialize the updated JSON object back to a string
        let updated_global_info_json = serde_json::to_string(&global_info_value)?;
        // Deserialize into GlobalInfo
        let global_info: GlobalInfo = serde_json::from_str(&updated_global_info_json)?;
        global_info.validate_shape()?;
        Ok(global_info)
    }

    /// Number of field elements of the proof values buffer: one per stage 1 value and a field
    /// extension per value of a later stage.
    pub fn proof_values_words(&self) -> ProofmanResult<usize> {
        let mut words = 0usize;
        for proof_value in self.proof_values_map.iter().flatten() {
            words = checked_count_add(
                words,
                proof_value_words(proof_value.stage),
                MAX_GLOBAL_PROOF_VALUES * FIELD_EXTENSION_WORDS,
                "proofValuesMap",
            )?;
        }
        Ok(words)
    }

    /// Number of field elements of the challenges buffer, a field extension per challenge.
    pub fn challenge_words(&self) -> ProofmanResult<usize> {
        let challenges = checked_sum_limited(&self.n_challenges, MAX_GLOBAL_CHALLENGES, "numChallenges")?;
        challenges
            .checked_mul(FIELD_EXTENSION_WORDS)
            .ok_or_else(|| ProofmanError::InvalidSetup("numChallenges word count overflows".into()))
    }

    /// Checks that the per-airgroup lists agree, that the maps the buffers are sized from are
    /// consistent, and that every count stays within the limits buffers are allocated for.
    fn validate_shape(&self) -> ProofmanResult<()> {
        if self.air_groups.is_empty() {
            return Err(ProofmanError::InvalidSetup("global info must contain at least one air group".into()));
        }
        if self.air_groups.len() > MAX_GLOBAL_AIR_GROUPS {
            return Err(ProofmanError::InvalidSetup("global info air group count exceeds limit".into()));
        }
        if self.airs.len() != self.air_groups.len() {
            return Err(ProofmanError::InvalidSetup("global info airs length must match air_groups".into()));
        }
        if self.agg_types.len() != self.air_groups.len() {
            return Err(ProofmanError::InvalidSetup("global info aggTypes length must match air_groups".into()));
        }

        let mut total_airs = 0usize;
        for (airgroup_id, airs) in self.airs.iter().enumerate() {
            if airs.is_empty() {
                return Err(ProofmanError::InvalidSetup(format!(
                    "air group {airgroup_id} must contain at least one air"
                )));
            }
            total_airs = checked_count_add(total_airs, airs.len(), MAX_GLOBAL_AIR_INSTANCES, "global info air count")?;
        }

        if self.n_publics > MAX_GLOBAL_PUBLICS {
            return Err(ProofmanError::InvalidSetup("global info nPublics exceeds limit".into()));
        }
        if self.n_challenges.len() > MAX_GLOBAL_STAGE_COUNT {
            return Err(ProofmanError::InvalidSetup("global info numChallenges stage count exceeds limit".into()));
        }
        self.challenge_words()?;

        if self.n_proof_values.len() > MAX_GLOBAL_STAGE_COUNT {
            return Err(ProofmanError::InvalidSetup("global info numProofValues stage count exceeds limit".into()));
        }
        let declared_proof_values =
            checked_sum_limited(&self.n_proof_values, MAX_GLOBAL_PROOF_VALUES, "numProofValues")?;

        let max_stage = self.n_challenges.len().max(1) as u64;
        if let Some(proof_values_map) = &self.proof_values_map {
            if proof_values_map.len() > MAX_GLOBAL_PROOF_VALUES {
                return Err(ProofmanError::InvalidSetup("global info proofValuesMap exceeds limit".into()));
            }
            if !self.n_proof_values.is_empty() && declared_proof_values != proof_values_map.len() {
                return Err(ProofmanError::InvalidSetup(
                    "global info numProofValues does not match proofValuesMap length".into(),
                ));
            }
            // Proof values are laid out stage by stage, which get_proof_values_by_stage relies on.
            let mut previous_stage = 0u64;
            for (idx, proof_value) in proof_values_map.iter().enumerate() {
                if proof_value.stage == 0 || proof_value.stage > max_stage {
                    return Err(ProofmanError::InvalidSetup(format!(
                        "global info proofValuesMap[{idx}] has invalid stage"
                    )));
                }
                if proof_value.stage < previous_stage {
                    return Err(ProofmanError::InvalidSetup("global info proofValuesMap stages must be sorted".into()));
                }
                previous_stage = proof_value.stage;
            }
            self.proof_values_words()?;
        } else if declared_proof_values != 0 {
            return Err(ProofmanError::InvalidSetup(
                "global info numProofValues is nonzero but proofValuesMap is missing".into(),
            ));
        }

        if let Some(publics_map) = &self.publics_map {
            if publics_map.len() > self.n_publics {
                return Err(ProofmanError::InvalidSetup("global info publicsMap exceeds nPublics".into()));
            }
            let mut total_lengths = 0usize;
            for (idx, public) in publics_map.iter().enumerate() {
                if public.stage == 0 || public.stage > max_stage {
                    return Err(ProofmanError::InvalidSetup(format!(
                        "global info publicsMap[{idx}] has invalid stage"
                    )));
                }
                total_lengths = checked_count_add(
                    total_lengths,
                    public.lengths.len(),
                    MAX_GLOBAL_PUBLIC_LENGTH_ENTRIES,
                    "publicsMap lengths",
                )?;
            }
        }

        let mut total_agg_values = 0usize;
        for (airgroup_id, agg_types) in self.agg_types.iter().enumerate() {
            total_agg_values = checked_count_add(total_agg_values, agg_types.len(), MAX_GLOBAL_AGG_VALUES, "aggTypes")?;
            for (idx, agg_type) in agg_types.iter().enumerate() {
                if agg_type.agg_type > 1 {
                    return Err(ProofmanError::InvalidSetup(format!(
                        "global info aggTypes[{airgroup_id}][{idx}] has unsupported aggType"
                    )));
                }
            }
        }

        if self.transcript_arity > MAX_GLOBAL_TRANSCRIPT_ARITY {
            return Err(ProofmanError::InvalidSetup("global info transcriptArity exceeds limit".into()));
        }
        if self.lattice_size.is_some_and(|lattice_size| lattice_size > MAX_GLOBAL_LATTICE_SIZE) {
            return Err(ProofmanError::InvalidSetup("global info latticeSize exceeds limit".into()));
        }

        Ok(())
    }

    pub fn get_proving_key_path(&self) -> PathBuf {
        PathBuf::from(self.folder_path.to_string())
    }

    pub fn get_setup_path(&self, template: &str) -> PathBuf {
        let vadcop_final_setup_folder = format!("{}/{}/{}/{}", self.folder_path, self.name, template, template);
        PathBuf::from(vadcop_final_setup_folder)
    }

    pub fn get_air_setup_path(&self, airgroup_id: usize, air_id: usize, proof_type: &ProofType) -> PathBuf {
        let type_str = match proof_type {
            ProofType::Basic => "air",
            ProofType::Compressor => "compressor",
            ProofType::Recursive1 => "recursive1",
            ProofType::Recursive2 => "recursive2",
            _ => panic!(),
        };

        let air_setup_folder = match proof_type {
            ProofType::Recursive2 => {
                format!("{}/{}/{}/recursive2/recursive2", self.folder_path, self.name, self.air_groups[airgroup_id])
            }
            ProofType::Compressor | ProofType::Recursive1 => {
                format!(
                    "{}/{}/{}/airs/{}/{}/{}",
                    self.folder_path,
                    self.name,
                    self.air_groups[airgroup_id],
                    self.airs[airgroup_id][air_id].name,
                    type_str,
                    type_str,
                )
            }
            ProofType::Basic => {
                format!(
                    "{}/{}/{}/airs/{}/{}/{}",
                    self.folder_path,
                    self.name,
                    self.air_groups[airgroup_id],
                    self.airs[airgroup_id][air_id].name,
                    type_str,
                    self.get_air_name(airgroup_id, air_id),
                )
            }
            _ => panic!(),
        };

        PathBuf::from(air_setup_folder)
    }

    pub fn get_air_group_name(&self, airgroup_id: usize) -> &str {
        &self.air_groups[airgroup_id]
    }

    pub fn get_airgroup_id(&self, air_group_name: &str) -> usize {
        self.air_groups
            .iter()
            .position(|name| name == air_group_name)
            .unwrap_or_else(|| panic!("Air group '{air_group_name}' not found"))
    }

    pub fn get_air_id(&self, air_group_name: &str, air_name: &str) -> (usize, usize) {
        let airgroup_id = self
            .air_groups
            .iter()
            .position(|name| name == air_group_name)
            .unwrap_or_else(|| panic!("Air group '{air_group_name}' not found"));

        let air_id = self.airs[airgroup_id]
            .iter()
            .position(|air| air.name == air_name)
            .unwrap_or_else(|| panic!("Air '{air_name}' not found in air group '{air_group_name}'"));

        (airgroup_id, air_id)
    }

    pub fn get_air_name(&self, airgroup_id: usize, air_id: usize) -> &str {
        &self.airs[airgroup_id][air_id].name
    }

    pub fn get_air_has_compressor(&self, airgroup_id: usize, air_id: usize) -> bool {
        self.airs[airgroup_id][air_id].has_compressor.unwrap_or(false)
    }

    pub fn get_n_airs_for_airgroup(&self, airgroup_id: usize) -> usize {
        self.airs[airgroup_id].len()
    }

    pub fn get_public_starting_pos(&self, public_name: &str) -> ProofmanResult<usize> {
        if let Some(publics_map) = &self.publics_map {
            for (pos, public) in publics_map.iter().enumerate() {
                if public.name == public_name {
                    return Ok(pos);
                }
            }
        }
        Err(ProofmanError::InvalidConfiguration(format!("Public '{}' not found in publics_map", public_name)))
    }
}

/// Field elements a proof value of `stage` takes in the proof values buffer: stage 1 values are
/// base field elements, values of later stages field extensions.
pub(crate) fn proof_value_words(stage: u64) -> usize {
    if stage == 1 {
        1
    } else {
        FIELD_EXTENSION_WORDS
    }
}

fn checked_count_add(total: usize, count: usize, max: usize, label: &str) -> ProofmanResult<usize> {
    let next =
        total.checked_add(count).ok_or_else(|| ProofmanError::InvalidSetup(format!("{label} count overflows")))?;
    if next > max {
        return Err(ProofmanError::InvalidSetup(format!("{label} count exceeds limit")));
    }
    Ok(next)
}

fn checked_sum_limited(values: &[usize], max: usize, label: &str) -> ProofmanResult<usize> {
    values.iter().try_fold(0usize, |total, &value| checked_count_add(total, value, max, label))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn proof_values_take_a_field_extension_after_stage_one() {
        let proof_value = |stage| ProofValueMap { name: String::new(), id: 0, stage };
        let global_info = GlobalInfo {
            folder_path: String::new(),
            name: "zisk".to_string(),
            airs: vec![vec![GlobalInfoAir::new("Rom".to_string())]],
            air_groups: vec!["Zisk".to_string()],
            curve: CurveType::None,
            lattice_size: None,
            agg_types: vec![Vec::new()],
            n_publics: 0,
            n_challenges: vec![0, 1],
            n_proof_values: vec![2],
            proof_values_map: Some(vec![proof_value(1), proof_value(2)]),
            publics_map: None,
            transcript_arity: 4,
        };

        assert!(global_info.validate_shape().is_ok());
        assert_eq!(global_info.proof_values_words().unwrap(), 4);
    }
}
