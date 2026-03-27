//! Port of `gencircom.js`: render a vadcop circom template.
//!
//! The JS version reads an EJS template file and renders it with a context
//! built from `starkInfos`, `vadcopInfo`, verifier filenames, verification
//! keys, publics, and options.
//!
//! In Rust we use Tera templates (stored under `templates/vadcop/`) with
//! the same structural logic. The Tera context is built from the same
//! JSON objects that the JS caller provides.

use anyhow::{Context as _, Result};
use serde_json::Value;
use tera::Context;

use crate::template::TemplateEngine;

/// Options controlling vadcop circom generation.
#[derive(Debug, Clone, Default)]
pub struct GenCircomOptions {
    /// Airgroup ID, if applicable.
    pub airgroup_id: Option<u64>,
    /// Whether there is a compressor stage before recursive1.
    pub has_compressor: bool,
    /// Whether there is a recursion layer.
    pub has_recursion: bool,
    /// Whether this is a "final" circuit.
    pub is_final: bool,
    /// Additional raw options (passed through to templates).
    pub raw: Value,
}

impl GenCircomOptions {
    /// Build from a JSON options object (mirrors the JS interface).
    pub fn from_json(v: &Value) -> Self {
        Self {
            airgroup_id: v.get("airgroupId").and_then(|v| v.as_u64()),
            has_compressor: v
                .get("hasCompressor")
                .and_then(|v| v.as_bool())
                .unwrap_or(false),
            has_recursion: v
                .get("hasRecursion")
                .and_then(|v| v.as_bool())
                .unwrap_or(false),
            is_final: v.get("final").and_then(|v| v.as_bool()).unwrap_or(false),
            raw: v.clone(),
        }
    }
}

/// All the inputs needed for vadcop circom generation, bundled into
/// a single struct to keep the public API ergonomic.
pub struct GenCircomInput<'a> {
    /// Tera template path relative to the templates directory,
    /// e.g. `"vadcop/compressor.circom.tera"`.
    pub template_name: &'a str,
    /// One or more starkInfo JSON objects.
    pub stark_infos: &'a [Value],
    /// The vadcop info JSON object.
    pub vadcop_info: &'a Value,
    /// Filenames of included verifier circom files.
    pub verifier_filenames: &'a [String],
    /// Per-airgroup, per-air verification keys (each key is 4 strings).
    pub basic_verification_keys: &'a [Vec<Vec<String>>],
    /// Per-airgroup aggregated verification keys (each key is 4 strings).
    pub agg_verification_keys: &'a [Vec<String>],
    /// Public values (JSON).
    pub publics: &'a [Value],
    /// Generation options.
    pub options: &'a GenCircomOptions,
}

/// Generate a vadcop-style circom file by rendering a Tera template.
///
/// This is the Rust equivalent of:
/// ```js
/// genCircom(templateFile, starkInfos, vadcopInfo,
///           verifierFilenames, basicVerificationKeys,
///           aggVerificationKeys, publics, options)
/// ```
///
/// Returns the rendered circom source.
pub fn gen_circom(input: &GenCircomInput<'_>) -> Result<String> {
    let GenCircomInput {
        template_name,
        stark_infos,
        vadcop_info,
        verifier_filenames,
        basic_verification_keys,
        agg_verification_keys,
        publics,
        options,
    } = input;
    let engine = TemplateEngine::new().context("loading template engine")?;

    let mut ctx = Context::new();

    // verifierFilenames
    ctx.insert("verifierFilenames", verifier_filenames);

    // starkInfo: single or array
    if stark_infos.len() == 1 {
        ctx.insert("starkInfo", &stark_infos[0]);
    } else {
        ctx.insert("starkInfo", stark_infos);
    }

    // publics
    if !publics.is_empty() {
        if publics.len() == 1 {
            ctx.insert("publics", &publics[0]);
        } else {
            ctx.insert("publics", publics);
        }
    }

    // Verification keys
    ctx.insert("basicVK", basic_verification_keys);
    ctx.insert("aggregatedVK", agg_verification_keys);

    // vadcopInfo fields
    ctx.insert("vadcopInfo", vadcop_info);
    let n_publics = vadcop_info
        .get("nPublics")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    ctx.insert("vadcopInfo_nPublics", &n_publics);
    let num_proof_values = vadcop_info
        .get("numProofValues")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    ctx.insert("vadcopInfo_numProofValues", &num_proof_values);

    let proof_values_map_len = vadcop_info
        .get("proofValuesMap")
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);
    ctx.insert("vadcopInfo_proofValuesMap_len", &proof_values_map_len);

    // aggTypes
    let agg_types = vadcop_info
        .get("aggTypes")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    ctx.insert("aggTypes_total_len", &agg_types.len());

    // options
    ctx.insert("options_hasCompressor", &options.has_compressor);
    ctx.insert("options_hasRecursion", &options.has_recursion);
    if let Some(ag_id) = options.airgroup_id {
        ctx.insert("airgroupId", &ag_id);
    }

    // air_groups
    let air_groups = vadcop_info
        .get("air_groups")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    let airs = vadcop_info
        .get("airs")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    let is_single_air =
        air_groups.len() == 1 && airs.first().and_then(|a| a.as_array()).map(|a| a.len()).unwrap_or(0) == 1;
    ctx.insert("is_single_air", &is_single_air);

    // main_public_clause for final template
    if n_publics > 0 {
        ctx.insert("main_public_clause", "{public [publics]}");
    } else {
        ctx.insert("main_public_clause", "");
    }

    // pubNames (computed for compressor/recursive1/recursive2)
    let mut pub_names: Vec<String> = Vec::new();
    if options.has_compressor {
        // publicsNames would be populated by define_vadcop_inputs
        // (simplified: just add the known names)
    }
    if n_publics > 0 {
        pub_names.push("publics".to_string());
    }
    if num_proof_values > 0 {
        pub_names.push("proofValues".to_string());
    }
    pub_names.push("globalChallenge".to_string());

    // For recursive1/recursive2 we also add rootCAgg
    if template_name.contains("recursive") {
        pub_names.push("rootCAgg".to_string());
    }
    ctx.insert("pubNames", &pub_names);

    // Pre-rendered code fragments. In a full implementation, each
    // included EJS fragment would be rendered by dedicated Rust
    // functions. For now we emit placeholder comments that mark where
    // each fragment goes, allowing incremental implementation.
    let placeholder = |name: &str| format!("    // [rendered fragment: {}]\n", name);

    ctx.insert("calculate_hashes_code", &placeholder("calculate_hashes"));
    ctx.insert("define_stark_inputs_code", &placeholder("define_stark_inputs"));
    ctx.insert("define_vadcop_inputs_code", &placeholder("define_vadcop_inputs"));
    ctx.insert("define_vadcop_inputs_sv_code", &placeholder("define_vadcop_inputs_sv"));
    ctx.insert("define_vadcop_inputs_a_sv_code", &placeholder("define_vadcop_inputs_a_sv"));
    ctx.insert("define_vadcop_inputs_b_sv_code", &placeholder("define_vadcop_inputs_b_sv"));
    ctx.insert("define_vadcop_inputs_c_sv_code", &placeholder("define_vadcop_inputs_c_sv"));
    ctx.insert("define_stark_inputs_a_code", &placeholder("define_stark_inputs_a"));
    ctx.insert("define_stark_inputs_b_code", &placeholder("define_stark_inputs_b"));
    ctx.insert("define_stark_inputs_c_code", &placeholder("define_stark_inputs_c"));
    ctx.insert("assign_stark_inputs_code", &placeholder("assign_stark_inputs"));
    ctx.insert("assign_stark_inputs_vA_code", &placeholder("assign_stark_inputs_vA"));
    ctx.insert("assign_stark_inputs_vB_code", &placeholder("assign_stark_inputs_vB"));
    ctx.insert("assign_stark_inputs_vC_code", &placeholder("assign_stark_inputs_vC"));
    ctx.insert("assign_vadcop_inputs_code", &placeholder("assign_vadcop_inputs"));
    ctx.insert("assign_vadcop_inputs_vA_code", &placeholder("assign_vadcop_inputs_vA"));
    ctx.insert("assign_vadcop_inputs_vB_code", &placeholder("assign_vadcop_inputs_vB"));
    ctx.insert("assign_vadcop_inputs_vC_code", &placeholder("assign_vadcop_inputs_vC"));
    ctx.insert("init_vadcop_inputs_code", &placeholder("init_vadcop_inputs"));
    ctx.insert("agg_vadcop_inputs_code", &placeholder("agg_vadcop_inputs"));
    ctx.insert("verify_global_challenge_code", &placeholder("verify_global_challenge"));
    ctx.insert("verify_global_constraints_code", &placeholder("verify_global_constraints"));

    // Extra fields for recursive2/final
    if let Some(ag_id) = options.airgroup_id {
        let airs_in_ag = airs
            .get(ag_id as usize)
            .and_then(|v| v.as_array())
            .map(|a| a.len())
            .unwrap_or(0);
        ctx.insert("airs_in_airgroup_len", &airs_in_ag);

        let ag_agg_types_len = agg_types
            .get(ag_id as usize)
            .and_then(|v| v.as_array())
            .map(|a| a.len())
            .unwrap_or(0);
        ctx.insert("aggTypes_len", &ag_agg_types_len);

        // starkInfo_nPublics_minus4
        let si_n_publics = if stark_infos.len() == 1 {
            stark_infos[0]
                .get("nPublics")
                .and_then(|v| v.as_u64())
                .unwrap_or(0)
        } else {
            0
        };
        ctx.insert("starkInfo_nPublics_minus4", &(si_n_publics.saturating_sub(4)));
    } else {
        ctx.insert("airs_in_airgroup_len", &0_usize);
        ctx.insert("aggTypes_len", &0_usize);
        ctx.insert("starkInfo_nPublics_minus4", &0_u64);
    }

    // basicVK formatted for templates (as joined strings)
    let basic_vk_strs: Vec<String> = basic_verification_keys
        .iter()
        .flat_map(|vks| vks.iter())
        .map(|vk| vk.join(","))
        .collect();
    ctx.insert("basicVK", &basic_vk_strs);

    // airgroups array for the final template
    let mut airgroups_data: Vec<Value> = Vec::new();
    for i in 0..agg_types.len() {
        let ag_agg_types_len = agg_types
            .get(i)
            .and_then(|v| v.as_array())
            .map(|a| a.len())
            .unwrap_or(0);
        let ag_airs_len = airs
            .get(i)
            .and_then(|v| v.as_array())
            .map(|a| a.len())
            .unwrap_or(0);

        let si_recursive2 = if air_groups.len() > 1 && i < stark_infos.len() {
            &stark_infos[i]
        } else if !stark_infos.is_empty() {
            &stark_infos[0]
        } else {
            &Value::Null
        };

        let si_n_publics = si_recursive2
            .get("nPublics")
            .and_then(|v| v.as_u64())
            .unwrap_or(0);

        let agg_vk_str = agg_verification_keys
            .get(i)
            .map(|vk| vk.join(","))
            .unwrap_or_default();

        let basic_vks_strs: Vec<String> = basic_verification_keys
            .get(i)
            .map(|vks| vks.iter().map(|vk| vk.join(",")).collect())
            .unwrap_or_default();

        airgroups_data.push(serde_json::json!({
            "idx": i,
            "aggTypes_len": ag_agg_types_len,
            "airs_len": ag_airs_len,
            "nPublics_minus4": si_n_publics.saturating_sub(4),
            "aggVK": agg_vk_str,
            "basicVKs": basic_vks_strs,
            "define_vadcop_inputs_code": placeholder(&format!("define_vadcop_inputs_s{}_sv", i)),
            "define_stark_inputs_code": placeholder(&format!("define_stark_inputs_s{}", i)),
            "assign_stark_inputs_code": placeholder(&format!("assign_stark_inputs_sV{}", i)),
            "assign_vadcop_inputs_code": placeholder(&format!("assign_vadcop_inputs_sV{}", i)),
        }));
    }
    ctx.insert("airgroups", &airgroups_data);

    engine.render(template_name, &ctx)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn make_vadcop_info() -> Value {
        serde_json::json!({
            "nPublics": 2,
            "numProofValues": 1,
            "proofValuesMap": [{"stage": 1}],
            "aggTypes": [[{"aggType": 0}]],
            "air_groups": [{"id": 0}],
            "airs": [[{"id": 0}]],
            "curve": "None",
            "latticeSize": 64,
            "numChallenges": [0, 3],
            "globalConstraints": [],
            "curveConstants": {}
        })
    }

    fn make_stark_info() -> Value {
        serde_json::json!({
            "starkStruct": {
                "verificationHashType": "GL",
                "merkleTreeArity": 16,
                "nBits": 20,
                "nBitsExt": 21,
                "nQueries": 32,
                "powBits": 0,
                "steps": [{"nBits": 21}],
                "lastLevelVerification": 0
            },
            "nStages": 2,
            "nPublics": 10,
            "airgroupId": 0,
            "airId": 0,
            "nConstants": 3,
            "evMap": [],
            "cmPolsMap": [],
            "customCommits": [],
            "customCommitsMap": [],
            "boundaries": [],
            "challengesMap": [],
            "airgroupValuesMap": [],
            "airValuesMap": [],
            "proofValuesMap": [],
            "mapSectionsN": {}
        })
    }

    #[test]
    fn test_gen_circom_compressor() {
        let si = make_stark_info();
        let vi = make_vadcop_info();
        let opts = GenCircomOptions {
            airgroup_id: Some(0),
            ..Default::default()
        };
        let vf = vec!["verifier0.circom".to_string()];
        let bvk = vec![vec![vec!["1".into(), "2".into(), "3".into(), "4".into()]]];
        let avk = vec![vec!["5".into(), "6".into(), "7".into(), "8".into()]];
        let result = gen_circom(&GenCircomInput {
            template_name: "vadcop/compressor.circom.tera",
            stark_infos: &[si],
            vadcop_info: &vi,
            verifier_filenames: &vf,
            basic_verification_keys: &bvk,
            agg_verification_keys: &avk,
            publics: &[],
            options: &opts,
        })
        .unwrap();
        assert!(result.contains("pragma circom 2.1.0;"));
        assert!(result.contains("template Compressor()"));
        assert!(result.contains("include \"verifier0.circom\";"));
        assert!(result.contains("signal input publics[2]"));
        assert!(result.contains("signal input proofValues[1][3]"));
        assert!(result.contains("Compressor()"));
    }

    #[test]
    fn test_gen_circom_recursive1() {
        let si = make_stark_info();
        let vi = make_vadcop_info();
        let opts = GenCircomOptions {
            airgroup_id: Some(0),
            has_compressor: false,
            ..Default::default()
        };
        let vf = vec!["verifier0.circom".to_string()];
        let result = gen_circom(&GenCircomInput {
            template_name: "vadcop/recursive1.circom.tera",
            stark_infos: &[si],
            vadcop_info: &vi,
            verifier_filenames: &vf,
            basic_verification_keys: &[],
            agg_verification_keys: &[],
            publics: &[],
            options: &opts,
        })
        .unwrap();
        assert!(result.contains("template Recursive1()"));
        assert!(result.contains("signal input rootCAgg[4]"));
    }

    #[test]
    fn test_gen_circom_final_compressed() {
        let si = make_stark_info();
        let vi = make_vadcop_info();
        let opts = GenCircomOptions::default();
        let vf = vec!["verifier0.circom".to_string()];
        let result = gen_circom(&GenCircomInput {
            template_name: "vadcop/final_compressed.circom.tera",
            stark_infos: &[si],
            vadcop_info: &vi,
            verifier_filenames: &vf,
            basic_verification_keys: &[],
            agg_verification_keys: &[],
            publics: &[],
            options: &opts,
        })
        .unwrap();
        assert!(result.contains("template FinalCompressed()"));
        assert!(result.contains("component main {public [ publics ]}= FinalCompressed();"));
    }
}
