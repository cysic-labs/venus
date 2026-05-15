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
    #[serde(rename = "nQueries", skip_serializing_if = "Option::is_none", default)]
    pub n_queries: Option<u64>,
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
            settings.pow_bits.unwrap_or(16),
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

    let n_queries =
        estimate_fri_queries(n_bits, n_bits_ext, pow_bits, merkle_tree_arity, &steps, 1, 1, 1, 3);

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
        n_queries: Some(n_queries),
    })
}

pub fn apply_security_estimate(
    stark_struct: &mut StarkStruct,
    n_opening_points: usize,
    n_constraints: usize,
    n_functions: usize,
    max_constraint_degree: u64,
) -> SecurityEstimate {
    let estimate = estimate_security(
        stark_struct.n_bits,
        stark_struct.n_bits_ext,
        stark_struct.pow_bits,
        stark_struct.merkle_tree_arity,
        &stark_struct.steps,
        n_opening_points,
        n_constraints,
        n_functions,
        max_constraint_degree,
    );
    stark_struct.n_queries = Some(estimate.n_queries);
    stark_struct.pow_bits = estimate.n_grinding_bits;
    estimate
}

#[derive(Debug, Clone, Copy)]
pub struct SecurityEstimate {
    pub n_queries: u64,
    pub n_grinding_bits: u64,
    pub proximity_parameter: f64,
    pub proximity_gap: f64,
}

#[allow(clippy::too_many_arguments)]
fn estimate_fri_queries(
    n_bits: u64,
    n_bits_ext: u64,
    max_grinding_bits: u64,
    _tree_arity: u64,
    steps: &[StarkStep],
    n_opening_points: usize,
    n_constraints: usize,
    n_functions: usize,
    max_constraint_degree: u64,
) -> u64 {
    estimate_security(
        n_bits,
        n_bits_ext,
        max_grinding_bits,
        _tree_arity,
        steps,
        n_opening_points,
        n_constraints,
        n_functions,
        max_constraint_degree,
    )
    .n_queries
}

#[allow(clippy::too_many_arguments)]
fn estimate_security(
    n_bits: u64,
    n_bits_ext: u64,
    max_grinding_bits: u64,
    _tree_arity: u64,
    steps: &[StarkStep],
    n_opening_points: usize,
    n_constraints: usize,
    n_functions: usize,
    max_constraint_degree: u64,
) -> SecurityEstimate {
    const TARGET_SECURITY_BITS: f64 = 128.0;
    const FIELD_BITS: f64 = 64.0 * 3.0;

    let dimension = 2f64.powi(n_bits as i32);
    let rate = 2f64.powi(-((n_bits_ext - n_bits) as i32));
    let codeword_length = dimension / rate;
    let sqrt_rate = rate.sqrt();
    let augmented_rate = rate * (dimension + n_opening_points.max(1) as f64) / dimension;
    let sqrt_augmented_rate = augmented_rate.sqrt();
    let folding_factors: Vec<f64> =
        steps.windows(2).map(|window| (window[0].n_bits - window[1].n_bits) as f64).collect();

    let mut alpha = 0.0;
    loop {
        let gap = round_down_20((1.0 / 300.0) * (1.0 + alpha));
        let proximity_parameter = 1.0 - sqrt_rate - gap;
        let max_list_size = 1.0 / (2.0 * gap * sqrt_augmented_rate);
        let max_list_size_bits = max_list_size.log2();

        let single_query_error = 1.0 - proximity_parameter;
        let bits_per_query = -single_query_error.log2();
        let needed_from_queries = TARGET_SECURITY_BITS - max_grinding_bits as f64;
        let n_queries = if needed_from_queries > 0.0 {
            (needed_from_queries / bits_per_query).ceil().max(1.0) as u64
        } else {
            1
        };

        let ali_security = FIELD_BITS - max_list_size_bits - (n_constraints.max(1) as f64).log2();
        let deep_terms = ((max_constraint_degree.max(1) - 1) as f64)
            * (dimension + n_opening_points.max(1) as f64 - 1.0)
            + dimension
            - 1.0;
        let deep_security = FIELD_BITS - max_list_size_bits - deep_terms.max(1.0).log2();

        let linear_security = jbr_linear_security_bits(rate, sqrt_rate, codeword_length, gap);
        let batch_security =
            linear_security - ((n_functions.max(1).saturating_sub(1)) as f64).max(1.0).log2();
        let commit_security = folding_factors
            .iter()
            .map(|factor| linear_security - (factor - 1.0).max(1.0).log2())
            .fold(f64::INFINITY, f64::min);
        let query_security = n_queries as f64 * bits_per_query + max_grinding_bits as f64;
        let fri_security = batch_security.min(commit_security).min(query_security);
        let total_security = ali_security.min(deep_security).min(fri_security);

        if total_security >= TARGET_SECURITY_BITS || alpha > 100.0 {
            return SecurityEstimate {
                n_queries,
                n_grinding_bits: max_grinding_bits,
                proximity_parameter,
                proximity_gap: gap,
            };
        }
        alpha += 0.1;
    }
}

fn jbr_linear_security_bits(rate: f64, sqrt_rate: f64, codeword_length: f64, gap: f64) -> f64 {
    const FIELD_BITS: f64 = 64.0 * 3.0;

    let multiplicity = (sqrt_rate / gap).ceil().max(3.0);
    let shifted = multiplicity + 0.5;
    let numerator = (2.0 * shifted.powi(5) + 3.0 * shifted * rate) * codeword_length;
    let denominator_without_field = 3.0 * rate * sqrt_rate;

    FIELD_BITS + denominator_without_field.log2() - numerator.log2()
}

fn round_down_20(value: f64) -> f64 {
    (value * 1e20).floor() / 1e20
}
