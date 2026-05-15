use std::collections::BTreeMap;
use std::fs;
use std::path::Path;

use anyhow::{Context, Result};
use serde::{Deserialize, Serialize};

#[derive(Debug, Default, Clone, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct StarkSettings {
    pub verification_hash_type: Option<String>,
    pub hash_commits: Option<bool>,
    pub blowup_factor: Option<u64>,
    pub folding_factor: Option<u64>,
    pub final_degree: Option<u64>,
    pub merkle_tree_arity: Option<u64>,
    pub merkle_tree_custom: Option<bool>,
    pub last_level_verification: Option<u64>,
    pub pow_bits: Option<u64>,
    pub stark_struct: Option<StarkStruct>,
    pub has_compressor: Option<bool>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct StarkStruct {
    #[serde(rename = "nBits")]
    pub n_bits: u64,
    #[serde(rename = "nBitsExt")]
    pub n_bits_ext: u64,
    #[serde(rename = "verificationHashType")]
    pub verification_hash_type: String,
    pub merkle_tree_arity: u64,
    pub transcript_arity: u64,
    pub merkle_tree_custom: bool,
    pub last_level_verification: u64,
    pub pow_bits: u64,
    pub hash_commits: bool,
    pub steps: Vec<StarkStep>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct StarkStep {
    #[serde(rename = "nBits")]
    pub n_bits: u64,
}

#[derive(Debug, Default)]
pub struct StarkSettingsMap {
    settings: BTreeMap<String, StarkSettings>,
}

impl StarkSettingsMap {
    pub fn from_file(path: &Path) -> Result<Self> {
        let json = fs::read_to_string(path)
            .with_context(|| format!("failed to read {}", path.display()))?;
        let settings = serde_json::from_str(&json)
            .with_context(|| format!("failed to parse {}", path.display()))?;
        Ok(Self { settings })
    }

    pub fn for_air(&self, air_name: &str) -> StarkSettings {
        self.settings
            .get(air_name)
            .or_else(|| self.settings.get("default"))
            .cloned()
            .unwrap_or_default()
    }
}

pub fn generate_stark_struct(settings: &StarkSettings, n_bits: u64) -> Result<StarkStruct> {
    if let Some(stark_struct) = &settings.stark_struct {
        return Ok(stark_struct.clone());
    }

    let verification_hash_type =
        settings.verification_hash_type.clone().unwrap_or_else(|| "GL".to_string());
    if verification_hash_type != "GL" && verification_hash_type != "BN128" {
        anyhow::bail!("invalid verificationHashType {verification_hash_type}");
    }

    let blowup_factor = settings.blowup_factor.unwrap_or(1);
    let folding_factor = settings.folding_factor.unwrap_or(3);
    let final_degree = settings.final_degree.unwrap_or(5);

    let (
        merkle_tree_arity,
        transcript_arity,
        merkle_tree_custom,
        last_level_verification,
        pow_bits,
        hash_commits,
    ) = if verification_hash_type == "BN128" {
        (
            settings.merkle_tree_arity.unwrap_or(16),
            settings.merkle_tree_arity.unwrap_or(16),
            settings.merkle_tree_custom.unwrap_or(false),
            0,
            settings.pow_bits.unwrap_or(0),
            false,
        )
    } else {
        (
            settings.merkle_tree_arity.unwrap_or(4),
            4,
            true,
            settings.last_level_verification.unwrap_or(2),
            settings.pow_bits.unwrap_or(20),
            settings.hash_commits.unwrap_or(true),
        )
    };

    let n_bits_ext = n_bits + blowup_factor;
    let mut steps = vec![StarkStep { n_bits: n_bits_ext }];
    let mut fri_step_bits = n_bits_ext;
    while fri_step_bits > final_degree + 1 {
        fri_step_bits = std::cmp::max(fri_step_bits.saturating_sub(folding_factor), final_degree);
        steps.push(StarkStep { n_bits: fri_step_bits });
    }

    Ok(StarkStruct {
        n_bits,
        n_bits_ext,
        verification_hash_type,
        merkle_tree_arity,
        transcript_arity,
        merkle_tree_custom,
        last_level_verification,
        pow_bits,
        hash_commits,
        steps,
    })
}
