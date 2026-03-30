use serde::{Deserialize, Serialize};

/// Default Merkle tree arity for GL hash type.
const MERKLE_TREE_ARITY: usize = 4;

/// Configuration settings provided by the user to generate a StarkStruct.
#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(rename_all = "camelCase")]
pub struct StarkSettings {
    #[serde(default)]
    pub verification_hash_type: Option<String>,
    #[serde(default)]
    pub hash_commits: Option<bool>,
    #[serde(default)]
    pub blowup_factor: Option<usize>,
    #[serde(default)]
    pub folding_factor: Option<usize>,
    #[serde(default)]
    pub final_degree: Option<usize>,
    #[serde(default)]
    pub merkle_tree_arity: Option<usize>,
    #[serde(default)]
    pub merkle_tree_custom: Option<bool>,
    #[serde(default)]
    pub last_level_verification: Option<usize>,
    #[serde(default)]
    pub pow_bits: Option<usize>,
    #[serde(default)]
    pub has_compressor: Option<bool>,
}

/// A generated stark struct describing FRI parameters for a given air.
#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(rename_all = "camelCase")]
pub struct StarkStruct {
    pub n_bits: usize,
    pub n_bits_ext: usize,
    pub merkle_tree_arity: usize,
    pub transcript_arity: usize,
    pub merkle_tree_custom: bool,
    pub hash_commits: bool,
    pub verification_hash_type: String,
    pub last_level_verification: usize,
    pub pow_bits: usize,
    pub steps: Vec<StarkStep>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct StarkStep {
    pub n_bits: usize,
}

/// Generate a StarkStruct from user settings and the air's power (nBits).
///
/// Mirrors `generateStarkStruct(settings, nBits)` from `pil2-proofman-js/src/setup/utils.js`.
pub fn generate_stark_struct(settings: &StarkSettings, n_bits: usize) -> StarkStruct {
    let verification_hash_type = settings
        .verification_hash_type
        .clone()
        .unwrap_or_else(|| "GL".to_string());

    if !["GL", "BN128"].contains(&verification_hash_type.as_str()) {
        panic!(
            "Invalid verificationHashType: {}",
            verification_hash_type
        );
    }

    let blowup_factor = settings.blowup_factor.unwrap_or(1);
    let folding_factor = settings.folding_factor.unwrap_or(3);
    let final_degree = settings.final_degree.unwrap_or(5);

    let (merkle_tree_arity, transcript_arity, merkle_tree_custom, hash_commits, last_level_verification, pow_bits) =
        if verification_hash_type == "BN128" {
            let mta = settings.merkle_tree_arity.unwrap_or(16);
            let mtc = settings.merkle_tree_custom.unwrap_or(false);
            let pb = settings.pow_bits.unwrap_or(0);
            (mta, mta, mtc, false, 0usize, pb)
        } else {
            let mta = settings.merkle_tree_arity.unwrap_or(MERKLE_TREE_ARITY);
            let pb = settings.pow_bits.unwrap_or(20);
            let llv = settings.last_level_verification.unwrap_or(2);
            (mta, MERKLE_TREE_ARITY, true, true, llv, pb)
        };

    let n_bits_ext = n_bits + blowup_factor;

    let mut steps = vec![StarkStep { n_bits: n_bits_ext }];
    let mut fri_step_bits = n_bits_ext;
    while fri_step_bits > final_degree + 1 {
        fri_step_bits = if fri_step_bits > folding_factor + final_degree {
            fri_step_bits - folding_factor
        } else {
            final_degree
        };
        steps.push(StarkStep {
            n_bits: fri_step_bits,
        });
    }

    StarkStruct {
        n_bits,
        n_bits_ext,
        merkle_tree_arity,
        transcript_arity,
        merkle_tree_custom,
        hash_commits,
        verification_hash_type,
        last_level_verification,
        pow_bits,
        steps,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_generate_stark_struct_defaults() {
        let settings = StarkSettings::default();
        let ss = generate_stark_struct(&settings, 20);

        assert_eq!(ss.n_bits, 20);
        assert_eq!(ss.n_bits_ext, 21); // 20 + 1 (default blowup)
        assert_eq!(ss.verification_hash_type, "GL");
        assert_eq!(ss.merkle_tree_arity, MERKLE_TREE_ARITY);
        assert_eq!(ss.transcript_arity, MERKLE_TREE_ARITY);
        assert!(ss.merkle_tree_custom);
        assert!(ss.hash_commits);
        assert_eq!(ss.pow_bits, 20);
        assert_eq!(ss.last_level_verification, 2);

        // First step should be nBitsExt
        assert_eq!(ss.steps[0].n_bits, 21);
        // Last step should reach finalDegree (6): nBitsExt=21 -> 18 -> 15 -> 12 -> 9 -> 6
        assert_eq!(ss.steps.last().unwrap().n_bits, 6);
    }

    #[test]
    fn test_generate_stark_struct_bn128() {
        let settings = StarkSettings {
            verification_hash_type: Some("BN128".to_string()),
            blowup_factor: Some(2),
            folding_factor: Some(4),
            final_degree: Some(3),
            ..Default::default()
        };
        let ss = generate_stark_struct(&settings, 16);

        assert_eq!(ss.n_bits, 16);
        assert_eq!(ss.n_bits_ext, 18);
        assert_eq!(ss.verification_hash_type, "BN128");
        assert_eq!(ss.merkle_tree_arity, 16);
        assert_eq!(ss.transcript_arity, 16);
        assert!(!ss.merkle_tree_custom);
        assert!(!ss.hash_commits);
        assert_eq!(ss.pow_bits, 0);
        assert_eq!(ss.last_level_verification, 0);
        assert_eq!(ss.steps[0].n_bits, 18);
    }

    #[test]
    fn test_steps_converge_to_final_degree() {
        let settings = StarkSettings {
            blowup_factor: Some(2),
            folding_factor: Some(3),
            final_degree: Some(5),
            ..Default::default()
        };
        let ss = generate_stark_struct(&settings, 20);

        // nBitsExt = 22, folding by 3 each step: 22, 19, 16, 13, 10, 7, 5
        assert_eq!(ss.steps[0].n_bits, 22);
        let last_step = ss.steps.last().unwrap().n_bits;
        assert!(
            last_step <= settings.final_degree.unwrap() + 1,
            "Last step {} should be <= finalDegree + 1 = {}",
            last_step,
            settings.final_degree.unwrap() + 1
        );
    }

    #[test]
    #[should_panic(expected = "Invalid verificationHashType")]
    fn test_invalid_hash_type() {
        let settings = StarkSettings {
            verification_hash_type: Some("INVALID".to_string()),
            ..Default::default()
        };
        generate_stark_struct(&settings, 10);
    }
}
