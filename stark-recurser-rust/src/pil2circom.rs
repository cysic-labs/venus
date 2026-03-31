//! Port of `pil2circom.js`: produces a circom STARK verifier circuit.
//!
//! The JS version renders a single EJS template that embeds heavy JavaScript
//! logic (Transcript class, unrollCode, getExpressionsChunks). In Rust we
//! pre-compute all the dynamic fragments and interpolate them into the
//! final circom string, matching the JS output exactly.

use anyhow::{bail, Result};
use serde_json::Value;
use std::collections::{BTreeMap, HashSet};

use crate::pil2circom_helpers::{
    compute_gl_root_power, compute_inv_shift_exp, get_expression_chunks, unroll_code,
    StarkVerifierCtx, Transcript,
};

/// Options that control verifier generation.
#[derive(Debug, Clone, Default)]
pub struct Pil2CircomOptions {
    /// Whether to skip emitting `component main ...`.
    pub skip_main: bool,
    /// Whether `rootC` is an input signal.
    pub verkey_input: bool,
    /// Whether challenges come as inputs rather than being derived.
    pub input_challenges: bool,
    /// Whether enable is an input signal.
    pub enable_input: bool,
    /// Whether to use multi-FRI mode.
    pub multi_fri: bool,
}

impl Pil2CircomOptions {
    /// Build from a JSON `options` object (mirrors the JS interface).
    pub fn from_json(v: &Value) -> Self {
        Self {
            skip_main: v.get("skipMain").and_then(|v| v.as_bool()).unwrap_or(false),
            verkey_input: v.get("verkeyInput").and_then(|v| v.as_bool()).unwrap_or(false),
            input_challenges: v
                .get("inputChallenges")
                .and_then(|v| v.as_bool())
                .unwrap_or(false),
            enable_input: v
                .get("enableInput")
                .and_then(|v| v.as_bool())
                .unwrap_or(false),
            multi_fri: v.get("multiFRI").and_then(|v| v.as_bool()).unwrap_or(false),
        }
    }
}

/// Compute floor(log2(n)).  Returns 0 for n<=1.
fn log2(n: u64) -> u64 {
    if n <= 1 {
        return 0;
    }
    63 - (n.leading_zeros() as u64)
}

/// Generate a circom STARK verifier from `starkInfo`, `verifierInfo`,
/// a constant-polynomial Merkle root, and rendering options.
///
/// This is the Rust equivalent of
/// ```js
/// pil2circom(constRoot, starkInfo, verifierInfo, options)
/// ```
///
/// The `const_root` is a 4-element array of stringified field elements.
///
/// Returns the full circom source as a `String`.
pub fn pil2circom(
    const_root: &[String; 4],
    stark_info: &Value,
    verifier_info: &Value,
    options: &Pil2CircomOptions,
) -> Result<String> {
    let stark_struct = stark_info
        .get("starkStruct")
        .ok_or_else(|| anyhow::anyhow!("starkInfo missing starkStruct"))?;

    let hash_type = stark_struct
        .get("verificationHashType")
        .and_then(|v| v.as_str())
        .unwrap_or("");

    match hash_type {
        "GL" => render_gl_verifier(const_root, stark_info, verifier_info, stark_struct, options),
        "BN128" => {
            render_bn128_verifier(const_root, stark_info, verifier_info, stark_struct, options)
        }
        other => bail!("Invalid Hash Type: {other}"),
    }
}

/// Render the Goldilocks (GL) verifier.
///
/// This function implements the logic that was embedded as JavaScript
/// inside `circuits.gl/stark_verifier.circom.ejs`.  The approach is
/// imperative string building, exactly mirroring the JS flow.
fn render_gl_verifier(
    const_root: &[String; 4],
    stark_info: &Value,
    verifier_info: &Value,
    stark_struct: &Value,
    options: &Pil2CircomOptions,
) -> Result<String> {
    let arity = stark_struct
        .get("merkleTreeArity")
        .and_then(|v| v.as_u64())
        .unwrap_or(16);
    let custom = stark_struct
        .get("merkleTreeCustom")
        .and_then(|v| v.as_bool())
        .unwrap_or(false);
    let _transcript_arity = if custom { arity } else { 16 };
    let _n_bits_arity = log2(arity);

    let mut out = String::with_capacity(64 * 1024);

    // Extract verifier code for chunk processing
    let q_verifier_code = verifier_info
        .get("qVerifier")
        .and_then(|v| v.get("code"))
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    let query_verifier_code = verifier_info
        .get("queryVerifier")
        .and_then(|v| v.get("code"))
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();

    // Compute expression chunks
    let eval_p_chunks = get_expression_chunks(&q_verifier_code, 1000);
    let eval_q_chunks = get_expression_chunks(&query_verifier_code, 1000);

    out.push_str("pragma circom 2.1.0;\npragma custom_templates;\n\n");

    // Includes
    out.push_str("include \"cmul.circom\";\n");
    out.push_str("include \"cinv.circom\";\n");
    out.push_str("include \"poseidon2.circom\";\n");
    out.push_str("include \"bitify.circom\";\n");
    out.push_str("include \"fft.circom\";\n");
    out.push_str("include \"evalpol.circom\";\n");
    out.push_str("include \"treeselector4.circom\";\n");
    out.push_str("include \"pow.circom\";\n");

    let split_linear_hash = stark_struct
        .get("splitLinearHash")
        .and_then(|v| v.as_bool())
        .unwrap_or(false);
    if split_linear_hash {
        out.push_str("include \"merklehash_gpu.circom\";\n");
    } else {
        out.push_str("include \"merklehash.circom\";\n");
    }

    let airgroup_id = stark_info.get("airgroupId").and_then(|v| v.as_u64());
    let airgroup_suffix = airgroup_id
        .map(|id| id.to_string())
        .unwrap_or_default();

    let n_stages = stark_info
        .get("nStages")
        .and_then(|v| v.as_u64())
        .unwrap_or(1);
    let q_stage = n_stages + 1;
    let evals_stage = n_stages + 2;
    let fri_stage = n_stages + 3;

    let n_bits = stark_struct
        .get("nBits")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    let n_bits_ext = stark_struct
        .get("nBitsExt")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    let n_queries = stark_struct
        .get("nQueries")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    let pow_bits = stark_struct
        .get("powBits")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);

    let steps = stark_struct
        .get("steps")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();

    let ev_map_arr = stark_info
        .get("evMap")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    let ev_map = ev_map_arr.len();

    let n_publics = stark_info
        .get("nPublics")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);

    let n_constants = stark_info
        .get("nConstants")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);

    let cm_pols_map = stark_info
        .get("cmPolsMap")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();

    let custom_commits = stark_info
        .get("customCommits")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();

    let custom_commits_map = stark_info
        .get("customCommitsMap")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();

    let boundaries = stark_info
        .get("boundaries")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();

    let challenges_map = stark_info
        .get("challengesMap")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();

    let agv_map = stark_info
        .get("airgroupValuesMap")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();

    let air_values_map = stark_info
        .get("airValuesMap")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();

    let proof_values_map = stark_info
        .get("proofValuesMap")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();

    let map_sections = stark_info.get("mapSectionsN").unwrap_or(&Value::Null);

    let opening_points = stark_info
        .get("openingPoints")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();

    let q_deg = stark_info
        .get("qDeg")
        .and_then(|v| v.as_u64())
        .unwrap_or(2);

    let last_level = stark_struct
        .get("lastLevelVerification")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    let hash_commits = stark_struct
        .get("hashCommits")
        .and_then(|v| v.as_bool())
        .unwrap_or(false);

    let step0_bits = steps
        .first()
        .and_then(|s| s.get("nBits").and_then(|v| v.as_u64()))
        .unwrap_or(0);

    let n_fields = ((n_queries * step0_bits) as f64 - 1.0) / 63.0;
    let n_fields = n_fields.floor() as u64 + 1;

    // Build the context used by unroll_code for STARK verifier references
    let ctx = StarkVerifierCtx {
        stark_info,
        q_stage,
        evals_stage,
        fri_stage,
        cm_pols_map: &cm_pols_map,
        custom_commits: &custom_commits,
        custom_commits_map: &custom_commits_map,
        boundaries: &boundaries,
    };

    // =====================================================================
    // Generate calculateFRIQueries template
    // =====================================================================
    let calc_fri_queries_name = if airgroup_suffix.is_empty() {
        "calculateFRIQueries".to_string()
    } else {
        format!("calculateFRIQueries{}", airgroup_suffix)
    };

    out.push_str(&format!("template {}() {{\n", calc_fri_queries_name));
    out.push_str("    signal input challengeFRIQueries[3];\n");
    if pow_bits > 0 {
        out.push_str("    signal input nonce;\n");
    }
    out.push_str("    signal input {binary} enable;\n");
    out.push_str(&format!(
        "    signal output {{binary}} queriesFRI[{}][{}];\n\n",
        n_queries, step0_bits
    ));
    if pow_bits > 0 {
        out.push_str(&format!(
            "    VerifyPoW({})(challengeFRIQueries, nonce, enable);\n\n",
            pow_bits
        ));
    }
    // Transcript for query generation
    let mut t = Transcript::new(Some("friQueries"), arity);
    t.put("challengeFRIQueries", 3);
    if pow_bits > 0 {
        t.put_single("nonce");
    }
    t.get_permutations("queriesFRI", n_queries, step0_bits, n_fields);
    out.push_str(&t.get_code());
    out.push_str("}\n\n");

    // =====================================================================
    // Generate Transcript template
    // =====================================================================
    let transcript_name = if airgroup_suffix.is_empty() {
        "Transcript".to_string()
    } else {
        format!("Transcript{}", airgroup_suffix)
    };

    out.push_str(&format!("template {}() {{\n", transcript_name));

    if !options.input_challenges {
        if n_publics > 0 {
            out.push_str(&format!("    signal input publics[{}];\n", n_publics));
        }
        out.push_str("    signal input rootC[4];\n");
        out.push_str("    signal input root1[4];\n");
    } else {
        out.push_str("    signal input globalChallenge[3];\n");
    }

    if !air_values_map.is_empty() {
        out.push_str(&format!(
            "    signal input airValues[{}][3];\n",
            air_values_map.len()
        ));
    }

    for i in 1..n_stages {
        let stage = i + 1;
        out.push_str(&format!("    signal input root{}[4];\n", stage));
    }
    out.push_str(&format!("    signal input root{}[4];\n", q_stage));
    out.push_str(&format!("    signal input evals[{}][3];\n", ev_map));
    for s in 1..steps.len() {
        out.push_str(&format!("    signal input s{}_root[4];\n", s));
    }
    let last_step_bits = steps
        .last()
        .and_then(|s| s.get("nBits").and_then(|v| v.as_u64()))
        .unwrap_or(0);
    out.push_str(&format!(
        "    signal input finalPol[{}][3];\n",
        1u64 << last_step_bits
    ));
    if pow_bits > 0 {
        out.push_str("    signal input nonce;\n");
    }
    out.push_str("    signal input {binary} enable;\n\n");

    // Output challenges
    for i in 0..n_stages {
        let stage = i + 1;
        let stage_challenges: Vec<&Value> = challenges_map
            .iter()
            .filter(|c| c.get("stage").and_then(|v| v.as_u64()).unwrap_or(0) == stage)
            .collect();
        if stage_challenges.is_empty() {
            continue;
        }
        out.push_str(&format!(
            "    signal output challengesStage{}[{}][3];\n",
            stage,
            stage_challenges.len()
        ));
    }
    out.push_str("    signal output challengeQ[3];\n");
    out.push_str("    signal output challengeXi[3];\n");
    out.push_str("    signal output challengesFRI[2][3];\n");
    out.push_str(&format!(
        "    signal output challengesFRISteps[{}][3];\n",
        steps.len() + 1
    ));
    out.push_str(&format!(
        "    signal output {{binary}} queriesFRI[{}][{}];\n\n",
        n_queries, step0_bits
    ));

    if hash_commits {
        if n_publics > 0 {
            out.push_str("    signal publicsHash[4];\n");
        }
        out.push_str("    signal evalsHash[4];\n");
        out.push_str("    signal lastPolFRIHash[4];\n");
    }

    // Build transcript
    let mut transcript = Transcript::new(None, arity);

    if !options.input_challenges {
        transcript.put("rootC", 4);
        if n_publics > 0 {
            if !hash_commits {
                transcript.put("publics", n_publics);
            } else {
                out.push_str(&transcript.get_code());
                let mut tp = Transcript::new(Some("publics"), arity);
                tp.put("publics", n_publics);
                tp.get_state("publicsHash");
                out.push_str(&tp.get_code());
                transcript.put("publicsHash", 4);
            }
        }
        transcript.put("root1", 4);
    } else {
        transcript.put("globalChallenge", 3);
    }

    for i in 1..n_stages {
        let stage = i + 1;
        let stage_challenges: Vec<&Value> = challenges_map
            .iter()
            .filter(|c| c.get("stage").and_then(|v| v.as_u64()).unwrap_or(0) == stage)
            .collect();
        for j in 0..stage_challenges.len() {
            transcript.get_field(&format!("challengesStage{}[{}]", stage, j));
        }
        transcript.put(&format!("root{}", stage), 4);
        for (j, av) in air_values_map.iter().enumerate() {
            if av.get("stage").and_then(|v| v.as_u64()).unwrap_or(0) == stage {
                transcript.put(&format!("airValues[{}]", j), 3);
            }
        }
    }

    transcript.get_field("challengeQ");
    transcript.put(&format!("root{}", q_stage), 4);
    transcript.get_field("challengeXi");

    if !hash_commits {
        for i in 0..ev_map {
            transcript.put(&format!("evals[{}]", i), 3);
        }
    } else {
        out.push_str(&transcript.get_code());
        let mut te = Transcript::new(Some("evals"), arity);
        for i in 0..ev_map {
            te.put(&format!("evals[{}]", i), 3);
        }
        te.get_state("evalsHash");
        out.push_str(&te.get_code());
        transcript.put("evalsHash", 4);
    }

    transcript.get_field("challengesFRI[0]");
    transcript.get_field("challengesFRI[1]");

    for si in 0..steps.len() {
        transcript.get_field(&format!("challengesFRISteps[{}]", si));
        if si < steps.len() - 1 {
            transcript.put(&format!("s{}_root", si + 1), 4);
        } else if !hash_commits {
            for j in 0..(1u64 << last_step_bits) {
                transcript.put(&format!("finalPol[{}]", j), 3);
            }
        } else {
            out.push_str(&transcript.get_code());
            let mut tl = Transcript::new(Some("lastPolFRI"), arity);
            for j in 0..(1u64 << last_step_bits) {
                tl.put(&format!("finalPol[{}]", j), 3);
            }
            tl.get_state("lastPolFRIHash");
            out.push_str(&tl.get_code());
            transcript.put("lastPolFRIHash", 4);
        }
    }

    transcript.get_field(&format!("challengesFRISteps[{}]", steps.len()));
    out.push_str(&transcript.get_code());

    // Call calculateFRIQueries
    if pow_bits > 0 {
        out.push_str(&format!(
            "    queriesFRI <== {}()(challengesFRISteps[{}], nonce, enable);\n",
            calc_fri_queries_name,
            steps.len()
        ));
    } else {
        out.push_str(&format!(
            "    queriesFRI <== {}()(challengesFRISteps[{}], enable);\n",
            calc_fri_queries_name,
            steps.len()
        ));
    }
    out.push_str("}\n\n");

    // =====================================================================
    // Generate VerifyFRI template
    // =====================================================================
    let verify_fri_name = if airgroup_suffix.is_empty() {
        "VerifyFRI".to_string()
    } else {
        format!("VerifyFRI{}", airgroup_suffix)
    };
    out.push_str(&format!(
        "template {}(nBitsExt, prevStepBits, currStepBits, nextStepBits, e0) {{\n",
        verify_fri_name
    ));
    out.push_str("    var nextStep = currStepBits - nextStepBits;\n");
    out.push_str("    var step = prevStepBits - currStepBits;\n\n");
    out.push_str("    signal input {binary} queriesFRI[currStepBits];\n");
    out.push_str("    signal input friChallenge[3];\n");
    out.push_str("    signal input s_vals_curr[1<< step][3];\n");
    out.push_str("    signal input s_vals_next[1<< nextStep][3];\n");
    out.push_str("    signal input {binary} enable;\n\n");
    out.push_str("    signal sx[currStepBits];\n\n");
    out.push_str("    sx[0] <==  e0 *( queriesFRI[0] * (invroots(prevStepBits) -1) + 1);\n");
    out.push_str("    for (var i=1; i< currStepBits; i++) {\n");
    out.push_str(
        "        sx[i] <== sx[i-1] *  ( queriesFRI[i] * (invroots(prevStepBits -i) -1) +1);\n",
    );
    out.push_str("    }\n\n");
    out.push_str("    signal coefs[1 << step][3] <== FFT(step, 3, 1)(s_vals_curr);\n");
    out.push_str("    signal evalXprime[3] <== [friChallenge[0] *  sx[currStepBits - 1], friChallenge[1] * sx[currStepBits - 1], friChallenge[2] *  sx[currStepBits - 1]];\n");
    out.push_str("    signal evalPol[3] <== EvalPol(1 << step)(coefs, evalXprime);\n\n");
    out.push_str("    signal {binary} keys_lowValues[nextStep];\n");
    out.push_str(
        "    for(var i = 0; i < nextStep; i++) { keys_lowValues[i] <== queriesFRI[i + nextStepBits]; }\n",
    );
    out.push_str(
        "    signal lowValues[3] <== TreeSelector(nextStep, 3)(s_vals_next, keys_lowValues);\n\n",
    );
    out.push_str("    enable * (lowValues[0] - evalPol[0]) === 0;\n");
    out.push_str("    enable * (lowValues[1] - evalPol[1]) === 0;\n");
    out.push_str("    enable * (lowValues[2] - evalPol[2]) === 0;\n");
    out.push_str("}\n\n");

    // =====================================================================
    // Generate VerifyQuery template
    // =====================================================================
    let verify_query_name = if airgroup_suffix.is_empty() {
        "VerifyQuery".to_string()
    } else {
        format!("VerifyQuery{}", airgroup_suffix)
    };
    out.push_str(&format!(
        "template {}(currStepBits, nextStepBits) {{\n",
        verify_query_name
    ));
    out.push_str("    var nextStep = currStepBits - nextStepBits;\n");
    out.push_str(&format!(
        "    signal input {{binary}} queriesFRI[{}];\n",
        step0_bits
    ));
    out.push_str("    signal input queryVals[3];\n");
    out.push_str("    signal input s1_vals[1 << nextStep][3];\n");
    out.push_str("    signal input {binary} enable;\n\n");
    out.push_str("    signal {binary} s0_keys_lowValues[nextStep];\n");
    out.push_str("    for(var i = 0; i < nextStep; i++) {\n");
    out.push_str("        s0_keys_lowValues[i] <== queriesFRI[i + nextStepBits];\n");
    out.push_str("    }\n\n");
    out.push_str("    for(var i = 0; i < nextStepBits; i++) {\n");
    out.push_str("        _ <== queriesFRI[i];\n");
    out.push_str("    }\n\n");
    out.push_str(
        "    signal lowValues[3] <== TreeSelector(nextStep, 3)(s1_vals, s0_keys_lowValues);\n\n",
    );
    out.push_str("    enable * (lowValues[0] - queryVals[0]) === 0;\n");
    out.push_str("    enable * (lowValues[1] - queryVals[1]) === 0;\n");
    out.push_str("    enable * (lowValues[2] - queryVals[2]) === 0;\n");
    out.push_str("}\n\n");

    // =====================================================================
    // Generate VerifyFinalPol template
    // =====================================================================
    let verify_final_pol_name = if airgroup_suffix.is_empty() {
        "VerifyFinalPol".to_string()
    } else {
        format!("VerifyFinalPol{}", airgroup_suffix)
    };
    let n_last_bits = steps
        .last()
        .and_then(|s| s.get("nBits").and_then(|v| v.as_u64()))
        .unwrap_or(0);
    let max_deg_bits = if n_last_bits > (n_bits_ext - n_bits) {
        n_last_bits - (n_bits_ext - n_bits)
    } else {
        0
    };
    out.push_str(&format!("template {}() {{\n", verify_final_pol_name));
    out.push_str(&format!(
        "    signal input finalPol[{}][3];\n",
        1u64 << n_last_bits
    ));
    out.push_str("    signal input {binary} enable;\n\n");
    out.push_str(&format!(
        "    signal lastIFFT[{}][3] <== FFT({}, 3, 1)(finalPol);\n\n",
        1u64 << n_last_bits,
        n_last_bits
    ));
    out.push_str(&format!(
        "    for (var k= {}; k< {}; k++) {{\n        for (var e=0; e<3; e++) {{\n            enable * lastIFFT[k][e] === 0;\n        }}\n    }}\n\n",
        1u64 << max_deg_bits,
        1u64 << n_last_bits
    ));
    out.push_str(&format!(
        "    for (var k= 0; k < {}; k++) {{\n        _ <== lastIFFT[k];\n    }}\n",
        1u64 << max_deg_bits
    ));
    out.push_str("}\n\n");

    // =====================================================================
    // Generate VerifyEvaluationsChunks templates
    // =====================================================================
    for (i, chunk) in eval_p_chunks.chunks.iter().enumerate() {
        out.push_str(&format!("template VerifyEvaluationsChunks{}() {{\n", i));
        // Stage challenge inputs
        for si in 0..n_stages {
            let stage = si + 1;
            let stage_challenges: Vec<&Value> = challenges_map
                .iter()
                .filter(|c| c.get("stage").and_then(|v| v.as_u64()).unwrap_or(0) == stage)
                .collect();
            if stage_challenges.is_empty() {
                continue;
            }
            out.push_str(&format!(
                "    signal input challengesStage{}[{}][3];\n",
                stage,
                stage_challenges.len()
            ));
        }
        out.push_str("    signal input challengeQ[3];\n");
        out.push_str("    signal input challengeXi[3];\n");
        out.push_str(&format!("    signal input evals[{}][3];\n", ev_map));
        if n_publics > 0 {
            out.push_str(&format!("    signal input publics[{}];\n", n_publics));
        }
        if !agv_map.is_empty() {
            out.push_str(&format!(
                "    signal input airgroupvalues[{}][3];\n",
                agv_map.len()
            ));
        }
        if !air_values_map.is_empty() {
            out.push_str(&format!(
                "    signal input airvalues[{}][3];\n",
                air_values_map.len()
            ));
        }
        if !proof_values_map.is_empty() {
            out.push_str(&format!(
                "    signal input proofvalues[{}][3];\n",
                proof_values_map.len()
            ));
        }
        out.push_str("    signal input Zh[3];\n");
        if boundaries.iter().any(|b| {
            b.get("name").and_then(|v| v.as_str()) == Some("firstRow")
        }) {
            out.push_str("    signal input Zfirst[3];\n");
        }
        if boundaries.iter().any(|b| {
            b.get("name").and_then(|v| v.as_str()) == Some("lastRow")
        }) {
            out.push_str("    signal input Zlast[3];\n");
        }
        let frame_boundaries: Vec<&Value> = boundaries
            .iter()
            .filter(|b| b.get("name").and_then(|v| v.as_str()) == Some("everyFrame"))
            .collect();
        for (fi, frame) in frame_boundaries.iter().enumerate() {
            let off_min = frame
                .get("offsetMin")
                .and_then(|v| v.as_u64())
                .unwrap_or(0);
            let off_max = frame
                .get("offsetMax")
                .and_then(|v| v.as_u64())
                .unwrap_or(0);
            out.push_str(&format!(
                "    signal input Zframe{}[{}][3];\n",
                fi,
                off_min + off_max
            ));
        }

        // xDivXSubXi is computed in the parent template and passed to chunks
        if !opening_points.is_empty() {
            out.push_str(&format!(
                "    signal input xDivXSubXi[{}][3];\n",
                opening_points.len()
            ));
        }

        // Chunk inputs/outputs
        for &inp_id in &chunk.inputs {
            let dim = eval_p_chunks.tmps.get(&inp_id).map(|t| t.dim).unwrap_or(1);
            if dim == 1 {
                out.push_str(&format!("    signal input tmp_{};\n", inp_id));
            } else {
                out.push_str(&format!("    signal input tmp_{}[3];\n", inp_id));
            }
        }
        for &out_id in &chunk.outputs {
            let dim = eval_p_chunks
                .tmps
                .get(&out_id)
                .map(|t| t.dim)
                .unwrap_or(1);
            if dim == 1 {
                out.push_str(&format!("    signal output tmp_{};\n", out_id));
            } else {
                out.push_str(&format!("    signal output tmp_{}[3];\n", out_id));
            }
        }

        // Unroll code
        let initialized: HashSet<u64> = chunk
            .inputs
            .iter()
            .chain(chunk.outputs.iter())
            .copied()
            .collect();
        out.push_str(&unroll_code(&chunk.code, &initialized, &ctx));
        out.push_str("}\n\n");
    }

    // =====================================================================
    // Generate VerifyEvaluations template
    // =====================================================================
    let verify_eval_name = if airgroup_suffix.is_empty() {
        "VerifyEvaluations".to_string()
    } else {
        format!("VerifyEvaluations{}", airgroup_suffix)
    };
    out.push_str(&format!("template {}() {{\n", verify_eval_name));
    let mut inputs_p: Vec<String> = Vec::new();
    for si in 0..n_stages {
        let stage = si + 1;
        let stage_challenges: Vec<&Value> = challenges_map
            .iter()
            .filter(|c| c.get("stage").and_then(|v| v.as_u64()).unwrap_or(0) == stage)
            .collect();
        if stage_challenges.is_empty() {
            continue;
        }
        out.push_str(&format!(
            "    signal input challengesStage{}[{}][3];\n",
            stage,
            stage_challenges.len()
        ));
        inputs_p.push(format!("challengesStage{}", stage));
    }
    out.push_str("    signal input challengeQ[3];\n");
    out.push_str("    signal input challengeXi[3];\n");
    out.push_str(&format!("    signal input evals[{}][3];\n", ev_map));
    inputs_p.extend(["challengeQ", "challengeXi", "evals"].iter().map(|s| s.to_string()));
    if n_publics > 0 {
        out.push_str(&format!("    signal input publics[{}];\n", n_publics));
        inputs_p.push("publics".to_string());
    }
    if !agv_map.is_empty() {
        out.push_str(&format!(
            "    signal input airgroupvalues[{}][3];\n",
            agv_map.len()
        ));
        inputs_p.push("airgroupvalues".to_string());
    }
    if !air_values_map.is_empty() {
        out.push_str(&format!(
            "    signal input airvalues[{}][3];\n",
            air_values_map.len()
        ));
        inputs_p.push("airvalues".to_string());
    }
    if !proof_values_map.is_empty() {
        out.push_str(&format!(
            "    signal input proofvalues[{}][3];\n",
            proof_values_map.len()
        ));
        inputs_p.push("proofvalues".to_string());
    }
    out.push_str("    signal input {binary} enable;\n\n");

    // zMul powers
    out.push_str(&format!("    signal zMul[{}][3];\n", n_bits));
    out.push_str(&format!(
        "    for (var i=0; i< {} ; i++) {{\n",
        n_bits
    ));
    out.push_str("        if(i==0){\n");
    out.push_str("            zMul[i] <== CMul()(challengeXi, challengeXi);\n");
    out.push_str("        } else {\n");
    out.push_str("            zMul[i] <== CMul()(zMul[i-1], zMul[i-1]);\n");
    out.push_str("        }\n    }\n\n");

    out.push_str(&format!(
        "    signal Z[3] <== [zMul[{}][0] - 1, zMul[{}][1], zMul[{}][2]];\n",
        n_bits - 1,
        n_bits - 1,
        n_bits - 1
    ));
    out.push_str("    signal Zh[3] <== CInv()(Z);\n");
    inputs_p.push("Zh".to_string());

    if boundaries
        .iter()
        .any(|b| b.get("name").and_then(|v| v.as_str()) == Some("firstRow"))
    {
        out.push_str(
            "    signal Zfirst[3] <== CInv()([challengeXi[0] - 1, challengeXi[1], challengeXi[2]]);\n",
        );
        inputs_p.push("Zfirst".to_string());
    }

    if boundaries
        .iter()
        .any(|b| b.get("name").and_then(|v| v.as_str()) == Some("lastRow"))
    {
        // Compute root = w^(2^nBits - 1) using the Goldilocks root of unity
        let root = compute_gl_root_power(n_bits, (1u64 << n_bits) - 1);
        out.push_str(&format!(
            "    signal Zlast[3] <== CInv()([challengeXi[0] - {}, challengeXi[1], challengeXi[2]]);\n",
            root
        ));
        inputs_p.push("Zlast".to_string());
    }

    // everyFrame boundaries
    let frame_boundaries: Vec<&Value> = boundaries
        .iter()
        .filter(|b| b.get("name").and_then(|v| v.as_str()) == Some("everyFrame"))
        .collect();
    for (fi, frame) in frame_boundaries.iter().enumerate() {
        let off_min = frame
            .get("offsetMin")
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        let off_max = frame
            .get("offsetMax")
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        out.push_str(&format!(
            "    signal Zframe{}[{}][3];\n",
            fi,
            off_min + off_max
        ));
        inputs_p.push(format!("Zframe{}", fi));
        let mut c: u64 = 0;
        for j in 0..off_min {
            let root = compute_gl_root_power(n_bits, j);
            if c == 0 {
                out.push_str(&format!(
                    "    Zframe{}[{}] <== CMul()(Zh, [challengeXi[0] - {}, challengeXi[1], challengeXi[2]]);\n",
                    fi, c, root
                ));
            } else {
                out.push_str(&format!(
                    "    Zframe{}[{}] <== CMul()(Zframe{}, [challengeXi[0] - {}, challengeXi[1], challengeXi[2]]);\n",
                    fi, c, fi, root
                ));
            }
            c += 1;
        }
        for _j in 0..off_max {
            let root = compute_gl_root_power(n_bits, (1u64 << n_bits) - fi as u64 - 1);
            if c == 0 {
                out.push_str(&format!(
                    "    Zframe{}[{}] <== CMul()(Zh, [challengeXi[0] - {}, challengeXi[1], challengeXi[2]]);\n",
                    fi, c, root
                ));
            } else {
                out.push_str(&format!(
                    "    Zframe{}[{}] <== CMul()(Zframe{}, [challengeXi[0] - {}, challengeXi[1], challengeXi[2]]);\n",
                    fi, c, fi, root
                ));
            }
            c += 1;
        }
        let _ = off_max;
    }

    // Wire VerifyEvaluationsChunks
    for (j, chunk) in eval_p_chunks.chunks.iter().enumerate() {
        for &out_id in &chunk.outputs {
            let dim = eval_p_chunks
                .tmps
                .get(&out_id)
                .map(|t| t.dim)
                .unwrap_or(1);
            if dim == 1 {
                out.push_str(&format!("    signal tmp_{};\n", out_id));
            } else {
                out.push_str(&format!("    signal tmp_{}[3];\n", out_id));
            }
        }
        let out_names: Vec<String> = chunk.outputs.iter().map(|id| format!("tmp_{}", id)).collect();
        let mut inp_names = inputs_p.clone();
        inp_names.extend(chunk.inputs.iter().map(|id| format!("tmp_{}", id)));
        out.push_str(&format!(
            "    ({}) <== VerifyEvaluationsChunks{}()({});\n",
            out_names.join(","),
            j,
            inp_names.join(",")
        ));
    }

    // Q polynomial accumulation
    out.push_str(&format!(
        "\n    signal xAcc[{}][3];\n",
        q_deg
    ));
    out.push_str(&format!(
        "    signal qStep[{}][3];\n",
        q_deg.saturating_sub(1)
    ));
    out.push_str(&format!(
        "    signal qAcc[{}][3];\n\n",
        q_deg
    ));

    // Find qIndex and evId
    let q_index = cm_pols_map
        .iter()
        .position(|p| {
            p.get("stage").and_then(|v| v.as_u64()) == Some(q_stage)
                && p.get("stageId").and_then(|v| v.as_u64()) == Some(0)
        })
        .unwrap_or(0);
    let ev_id = ev_map_arr
        .iter()
        .position(|e| {
            e.get("type").and_then(|v| v.as_str()) == Some("cm")
                && e.get("id").and_then(|v| v.as_u64()) == Some(q_index as u64)
        })
        .unwrap_or(0);

    out.push_str(&format!(
        "    for (var i=0; i< {}; i++) {{\n",
        q_deg
    ));
    out.push_str("        if (i==0) {\n");
    out.push_str("            xAcc[0] <== [1, 0, 0];\n");
    out.push_str(&format!(
        "            qAcc[0] <== evals[{}+i];\n",
        ev_id
    ));
    out.push_str("        } else {\n");
    out.push_str(&format!(
        "            xAcc[i] <== CMul()(xAcc[i-1], zMul[{}]);\n",
        n_bits - 1
    ));
    out.push_str(&format!(
        "            qStep[i-1] <== CMul()(xAcc[i], evals[{}+i]);\n",
        ev_id
    ));
    out.push_str("            qAcc[i][0] <== qAcc[i-1][0] + qStep[i-1][0];\n");
    out.push_str("            qAcc[i][1] <== qAcc[i-1][1] + qStep[i-1][1];\n");
    out.push_str("            qAcc[i][2] <== qAcc[i-1][2] + qStep[i-1][2];\n");
    out.push_str("        }\n    }\n\n");

    // Final verification
    let last_q_dest_id = q_verifier_code
        .last()
        .and_then(|inst| inst.get("dest"))
        .and_then(|d| d.get("id"))
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    out.push_str(&format!(
        "    enable * (tmp_{}[0] - qAcc[{}][0]) === 0;\n",
        last_q_dest_id,
        q_deg - 1
    ));
    out.push_str(&format!(
        "    enable * (tmp_{}[1] - qAcc[{}][1]) === 0;\n",
        last_q_dest_id,
        q_deg - 1
    ));
    out.push_str(&format!(
        "    enable * (tmp_{}[2] - qAcc[{}][2]) === 0;\n",
        last_q_dest_id,
        q_deg - 1
    ));
    out.push_str("}\n\n");

    // =====================================================================
    // Generate MapValues template (omitted for brevity when no code needed)
    // =====================================================================
    let map_values_name = if airgroup_suffix.is_empty() {
        "MapValues".to_string()
    } else {
        format!("MapValues{}", airgroup_suffix)
    };
    // MapValues maps raw stage values into named polynomial signals
    out.push_str(&format!("template {}() {{\n", map_values_name));
    for si in 0..=n_stages {
        let stage = si + 1;
        let cm_key = format!("cm{}", stage);
        let cm_n = map_sections
            .get(&cm_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        if cm_n > 0 {
            out.push_str(&format!("    signal input vals{}[{}];\n", stage, cm_n));
        }
    }
    for cc in &custom_commits {
        let name = cc.get("name").and_then(|v| v.as_str()).unwrap_or("custom");
        let cc_key = format!("{}0", name);
        let cc_n = map_sections
            .get(&cc_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        if cc_n > 0 {
            out.push_str(&format!(
                "    signal input vals_{}_0[{}];\n",
                name, cc_n
            ));
        }
    }
    // Map cm polynomials
    let mut val_idx: BTreeMap<u64, u64> = BTreeMap::new();
    for pol in &cm_pols_map {
        let stage = pol.get("stage").and_then(|v| v.as_u64()).unwrap_or(0);
        let stage_id = pol.get("stageId").and_then(|v| v.as_u64()).unwrap_or(0);
        let dim = pol.get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
        let idx = val_idx.entry(stage).or_insert(0);
        if dim == 1 {
            out.push_str(&format!(
                "    signal output cm{}_{} <== vals{}[{}];\n",
                stage, stage_id, stage, *idx
            ));
            *idx += 1;
        } else {
            out.push_str(&format!(
                "    signal output cm{}_{}[3] <== [vals{}[{}], vals{}[{}], vals{}[{}]];\n",
                stage, stage_id, stage, *idx, stage, *idx + 1, stage, *idx + 2
            ));
            *idx += 3;
        }
    }
    // Map custom commits
    for (ci, cc) in custom_commits.iter().enumerate() {
        let name = cc.get("name").and_then(|v| v.as_str()).unwrap_or("custom");
        let cc_map = custom_commits_map
            .get(ci)
            .and_then(|v| v.as_array())
            .cloned()
            .unwrap_or_default();
        let mut cidx: u64 = 0;
        for pol in &cc_map {
            let stage = pol.get("stage").and_then(|v| v.as_u64()).unwrap_or(0);
            let stage_id = pol.get("stageId").and_then(|v| v.as_u64()).unwrap_or(0);
            let dim = pol.get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
            if dim == 1 {
                out.push_str(&format!(
                    "    signal output custom_{}_{}_{} <== vals_{}_0[{}];\n",
                    name, stage, stage_id, name, cidx
                ));
                cidx += 1;
            } else {
                out.push_str(&format!(
                    "    signal output custom_{}_{}_{}[3] <== [vals_{}_0[{}], vals_{}_0[{}], vals_{}_0[{}]];\n",
                    name, stage, stage_id, name, cidx, name, cidx + 1, name, cidx + 2
                ));
                cidx += 3;
            }
        }
    }
    out.push_str("}\n\n");

    // =====================================================================
    // Generate CalculateFRIPolChunks and CalculateFRIPolValue templates
    // =====================================================================
    for (i, chunk) in eval_q_chunks.chunks.iter().enumerate() {
        out.push_str(&format!("template CalculateFRIPolChunks{}() {{\n", i));
        out.push_str("    signal input challengesFRI[2][3];\n");
        out.push_str(&format!("    signal input evals[{}][3];\n", ev_map));
        for si in 0..n_stages {
            let stage = si + 1;
            let cm_key = format!("cm{}", stage);
            let cm_n = map_sections
                .get(&cm_key)
                .and_then(|v| v.as_u64())
                .unwrap_or(0);
            if cm_n > 0 {
                out.push_str(&format!("    signal input cm{}[{}];\n", stage, cm_n));
            }
        }
        let q_cm_key = format!("cm{}", q_stage);
        let q_cm_n = map_sections
            .get(&q_cm_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        out.push_str(&format!("    signal input cm{}[{}];\n", q_stage, q_cm_n));
        out.push_str(&format!("    signal input consts[{}];\n", n_constants));
        for cc in &custom_commits {
            let name = cc.get("name").and_then(|v| v.as_str()).unwrap_or("custom");
            let cc_key = format!("{}0", name);
            let cc_n = map_sections
                .get(&cc_key)
                .and_then(|v| v.as_u64())
                .unwrap_or(0);
            out.push_str(&format!(
                "    signal input custom_{}_0[{}];\n",
                name, cc_n
            ));
        }
        out.push_str(&format!(
            "    signal input xDivXSubXi[{}][3];\n",
            opening_points.len()
        ));

        out.push_str(&format!(
            "    component mapValues = {}();\n",
            map_values_name
        ));
        for si in 0..n_stages {
            let stage = si + 1;
            let cm_key = format!("cm{}", stage);
            let cm_n = map_sections
                .get(&cm_key)
                .and_then(|v| v.as_u64())
                .unwrap_or(0);
            if cm_n > 0 {
                out.push_str(&format!("    mapValues.vals{} <== cm{};\n", stage, stage));
            }
        }
        out.push_str(&format!(
            "    mapValues.vals{} <== cm{};\n",
            q_stage, q_stage
        ));
        for cc in &custom_commits {
            let name = cc.get("name").and_then(|v| v.as_str()).unwrap_or("custom");
            out.push_str(&format!(
                "    mapValues.vals_{}_0 <== custom_{}_0;\n",
                name, name
            ));
        }

        // Chunk inputs/outputs
        for &inp_id in &chunk.inputs {
            let dim = eval_q_chunks.tmps.get(&inp_id).map(|t| t.dim).unwrap_or(1);
            if dim == 1 {
                out.push_str(&format!("    signal input tmp_{};\n", inp_id));
            } else {
                out.push_str(&format!("    signal input tmp_{}[3];\n", inp_id));
            }
        }
        for &out_id in &chunk.outputs {
            let dim = eval_q_chunks
                .tmps
                .get(&out_id)
                .map(|t| t.dim)
                .unwrap_or(1);
            if dim == 1 {
                out.push_str(&format!("    signal output tmp_{};\n", out_id));
            } else {
                out.push_str(&format!("    signal output tmp_{}[3];\n", out_id));
            }
        }

        let initialized: HashSet<u64> = chunk
            .inputs
            .iter()
            .chain(chunk.outputs.iter())
            .copied()
            .collect();
        out.push_str(&unroll_code(&chunk.code, &initialized, &ctx));
        out.push_str("}\n\n");
    }

    // CalculateFRIPolValue
    let calc_fri_pol_name = if airgroup_suffix.is_empty() {
        "CalculateFRIPolValue".to_string()
    } else {
        format!("CalculateFRIPolValue{}", airgroup_suffix)
    };
    out.push_str(&format!("template {}() {{\n", calc_fri_pol_name));
    let mut inputs_q: Vec<String> = Vec::new();
    out.push_str(&format!(
        "    signal input {{binary}} queriesFRI[{}];\n",
        step0_bits
    ));
    out.push_str("    signal input challengeXi[3];\n");
    out.push_str("    signal input challengesFRI[2][3];\n");
    out.push_str(&format!("    signal input evals[{}][3];\n", ev_map));
    inputs_q.extend(["challengesFRI", "evals"].iter().map(|s| s.to_string()));
    for si in 0..n_stages {
        let stage = si + 1;
        let cm_key = format!("cm{}", stage);
        let cm_n = map_sections
            .get(&cm_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        if cm_n > 0 {
            out.push_str(&format!("    signal input cm{}[{}];\n", stage, cm_n));
            inputs_q.push(format!("cm{}", stage));
        }
    }
    let q_cm_key2 = format!("cm{}", q_stage);
    let q_cm_n2 = map_sections
        .get(&q_cm_key2)
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    out.push_str(&format!("    signal input cm{}[{}];\n", q_stage, q_cm_n2));
    inputs_q.push(format!("cm{}", q_stage));
    out.push_str(&format!("    signal input consts[{}];\n", n_constants));
    inputs_q.push("consts".to_string());
    for cc in &custom_commits {
        let name = cc.get("name").and_then(|v| v.as_str()).unwrap_or("custom");
        let cc_key = format!("{}0", name);
        let cc_n = map_sections
            .get(&cc_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        out.push_str(&format!(
            "    signal input custom_{}_0[{}];\n",
            name, cc_n
        ));
        inputs_q.push(format!("custom_{}_0", name));
    }
    out.push_str("    signal output queryVals[3];\n\n");

    // xacc computation
    let gl_shift: u64 = 7; // F.shift for Goldilocks
    out.push_str(&format!(
        "    signal xacc[{}];\n",
        step0_bits
    ));
    out.push_str(&format!(
        "    xacc[0] <== queriesFRI[0]*({} * roots({}) - {}) + {};\n",
        gl_shift, step0_bits, gl_shift, gl_shift
    ));
    out.push_str(&format!(
        "    for (var i=1; i<{}; i++) {{\n",
        step0_bits
    ));
    out.push_str(&format!(
        "        xacc[i] <== xacc[i-1] * ( queriesFRI[i]*(roots({} - i) - 1) +1);\n",
        step0_bits
    ));
    out.push_str("    }\n\n");

    // xDivXSubXi
    out.push_str(&format!(
        "    signal xDivXSubXi[{}][3];\n",
        opening_points.len()
    ));
    inputs_q.push("xDivXSubXi".to_string());

    for (i, op) in opening_points.iter().enumerate() {
        let opening = op.as_i64().unwrap_or(0);
        let root = if opening == 0 {
            1u64
        } else {
            compute_gl_root_power(n_bits, opening.unsigned_abs())
        };
        out.push_str(&format!(
            "    xDivXSubXi[{}] <== CInv()([xacc[{}] - {} * challengeXi[0], - {} * challengeXi[1], - {} * challengeXi[2]]);\n",
            i, step0_bits - 1, root, root, root
        ));
    }

    // Wire CalculateFRIPolChunks
    for (j, chunk) in eval_q_chunks.chunks.iter().enumerate() {
        for &out_id in &chunk.outputs {
            let dim = eval_q_chunks
                .tmps
                .get(&out_id)
                .map(|t| t.dim)
                .unwrap_or(1);
            if dim == 1 {
                out.push_str(&format!("    signal tmp_{};\n", out_id));
            } else {
                out.push_str(&format!("    signal tmp_{}[3];\n", out_id));
            }
        }
        let out_names: Vec<String> = chunk.outputs.iter().map(|id| format!("tmp_{}", id)).collect();
        let mut inp_names = inputs_q.clone();
        inp_names.extend(chunk.inputs.iter().map(|id| format!("tmp_{}", id)));
        out.push_str(&format!(
            "    ({}) <== CalculateFRIPolChunks{}()({});\n",
            out_names.join(","),
            j,
            inp_names.join(",")
        ));
    }

    // queryVals output
    let last_q_query_dest_id = query_verifier_code
        .last()
        .and_then(|inst| inst.get("dest"))
        .and_then(|d| d.get("id"))
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    out.push_str(&format!(
        "    queryVals[0] <== tmp_{}[0];\n",
        last_q_query_dest_id
    ));
    out.push_str(&format!(
        "    queryVals[1] <== tmp_{}[1];\n",
        last_q_query_dest_id
    ));
    out.push_str(&format!(
        "    queryVals[2] <== tmp_{}[2];\n",
        last_q_query_dest_id
    ));
    out.push_str("}\n\n");

    // =====================================================================
    // Generate the StarkVerifier template (main entry point)
    // =====================================================================
    let verifier_name = format!("StarkVerifier{}", airgroup_suffix);
    out.push_str(&format!("template {}() {{\n", verifier_name));

    if n_publics > 0 {
        out.push_str(&format!(
            "    signal input publics[{}];\n",
            n_publics
        ));
    }

    // rootC
    if options.verkey_input {
        out.push_str(
            "    signal input rootC[4];\n",
        );
    } else if options.input_challenges {
        out.push_str(&format!(
            "    signal output rootC[4] <== [{} ];\n",
            const_root.join(",")
        ));
    } else {
        out.push_str(&format!(
            "    signal rootC[4] <== [{} ];\n",
            const_root.join(",")
        ));
    }

    // airgroupvalues / airvalues / proofvalues
    if !agv_map.is_empty() {
        out.push_str(&format!(
            "    signal input airgroupvalues[{}][3];\n",
            agv_map.len()
        ));
    }
    if !air_values_map.is_empty() {
        out.push_str(&format!(
            "    signal input airvalues[{}][3];\n",
            air_values_map.len()
        ));
    }
    if !proof_values_map.is_empty() {
        out.push_str(&format!(
            "    signal input proofvalues[{}][3];\n",
            proof_values_map.len()
        ));
    }

    // Stage roots
    for s in 1..=(n_stages + 1) {
        out.push_str(&format!("    signal input root{}[4];\n", s));
    }

    // evals
    out.push_str(&format!(
        "    signal input evals[{}][3];\n",
        ev_map
    ));

    // enabled
    out.push_str("\n    signal {binary} enabled;\n");
    if options.enable_input {
        out.push_str("    signal input enable;\n");
        out.push_str("    enable * (enable -1) === 0;\n");
        out.push_str("    enabled <== enable;\n");
    } else {
        out.push_str("    enabled <== 1;\n");
    }

    if options.input_challenges {
        out.push_str("    signal input globalChallenge[3];\n");
    }

    // Leaf values for Merkle tree verification
    let log2_arity = (arity as f64).log2();
    for si in 0..n_stages {
        let stage = si + 1;
        let cm_key = format!("cm{}", stage);
        let cm_n = map_sections
            .get(&cm_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        if cm_n > 0 {
            out.push_str(&format!(
                "    signal input s0_vals{}[{}][{}];\n",
                stage, n_queries, cm_n
            ));
        }
    }
    let q_cm_key_sv = format!("cm{}", q_stage);
    let q_cm_n_sv = map_sections
        .get(&q_cm_key_sv)
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    out.push_str(&format!(
        "    signal input s0_vals{}[{}][{}];\n",
        q_stage, n_queries, q_cm_n_sv
    ));
    out.push_str(&format!(
        "    signal input s0_valsC[{}][{}];\n",
        n_queries, n_constants
    ));

    for cc in &custom_commits {
        let cc_name = cc.get("name").and_then(|v| v.as_str()).unwrap_or("custom");
        let cc_key = format!("{}0", cc_name);
        let cc_n = map_sections
            .get(&cc_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        out.push_str(&format!(
            "    signal input s0_vals_{}_0[{}][{}];\n",
            cc_name, n_queries, cc_n
        ));
    }

    // Merkle siblings
    let sib_levels_0 = (step0_bits as f64 / log2_arity).ceil() as u64 - last_level;
    let sib_width = (arity - 1) * 4;
    for si in 0..n_stages {
        let stage = si + 1;
        let cm_key = format!("cm{}", stage);
        let cm_n = map_sections
            .get(&cm_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        if cm_n > 0 {
            out.push_str(&format!(
                "    signal input s0_siblings{}[{}][{}][{}];\n",
                stage, n_queries, sib_levels_0, sib_width
            ));
            if last_level > 0 {
                let ll_size = arity.pow(last_level as u32);
                out.push_str(&format!(
                    "    signal input s0_last_mt_levels{}[{}][4];\n",
                    stage, ll_size
                ));
            }
        }
    }
    out.push_str(&format!(
        "    signal input s0_siblings{}[{}][{}][{}];\n",
        q_stage, n_queries, sib_levels_0, sib_width
    ));
    if last_level > 0 {
        let ll_size = arity.pow(last_level as u32);
        out.push_str(&format!(
            "    signal input s0_last_mt_levels{}[{}][4];\n",
            q_stage, ll_size
        ));
    }
    out.push_str(&format!(
        "    signal input s0_siblingsC[{}][{}][{}];\n",
        n_queries, sib_levels_0, sib_width
    ));
    if last_level > 0 {
        let ll_size = arity.pow(last_level as u32);
        out.push_str(&format!(
            "    signal input s0_last_mt_levelsC[{}][4];\n",
            ll_size
        ));
    }
    for cc in &custom_commits {
        let cc_name = cc.get("name").and_then(|v| v.as_str()).unwrap_or("custom");
        out.push_str(&format!(
            "    signal input s0_siblings_{}_0[{}][{}][{}];\n",
            cc_name, n_queries, sib_levels_0, sib_width
        ));
        if last_level > 0 {
            let ll_size = arity.pow(last_level as u32);
            out.push_str(&format!(
                "    signal input s0_last_mt_levels_{}_0[{}][4];\n",
                cc_name, ll_size
            ));
        }
    }

    // FRI step roots, vals and siblings
    let mut si_roots: Vec<String> = Vec::new();
    for s in 1..steps.len() {
        si_roots.push(format!("s{}_root", s));
        out.push_str(&format!("    signal input s{}_root[4];\n", s));
    }
    for s in 1..steps.len() {
        let prev_bits = steps[s - 1]
            .get("nBits")
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        let cur_bits = steps[s]
            .get("nBits")
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        let vals_width = (1u64 << (prev_bits - cur_bits)) * 3;
        out.push_str(&format!(
            "    signal input s{}_vals[{}][{}];\n",
            s, n_queries, vals_width
        ));
        let sib_levels_s = (cur_bits as f64 / log2_arity).ceil() as u64 - last_level;
        out.push_str(&format!(
            "    signal input s{}_siblings[{}][{}][{}];\n",
            s, n_queries, sib_levels_s, sib_width
        ));
        if last_level > 0 {
            let ll_size = arity.pow(last_level as u32);
            out.push_str(&format!(
                "    signal input s{}_last_mt_levels[{}][4];\n",
                s, ll_size
            ));
        }
    }

    // Final polynomial
    out.push_str(&format!(
        "    signal input finalPol[{}][3];\n",
        1u64 << last_step_bits
    ));

    if pow_bits > 0 {
        out.push_str("    signal input nonce;\n");
    }

    // queryVals signal
    if options.multi_fri {
        out.push_str(&format!(
            "    signal output queryVals[{}][3];\n",
            n_queries
        ));
    } else {
        out.push_str(&format!(
            "    signal queryVals[{}][3];\n",
            n_queries
        ));
    }

    // Challenge signals
    let mut challenge_names: Vec<String> = Vec::new();
    for si in 0..n_stages {
        let stage = si + 1;
        let stage_challenges: Vec<&Value> = challenges_map
            .iter()
            .filter(|c| c.get("stage").and_then(|v| v.as_u64()).unwrap_or(0) == stage)
            .collect();
        if stage_challenges.is_empty() {
            continue;
        }
        out.push_str(&format!(
            "    signal challengesStage{}[{}][3];\n",
            stage,
            stage_challenges.len()
        ));
        challenge_names.push(format!("challengesStage{}", stage));
    }
    out.push_str("    signal challengeQ[3];\n");
    out.push_str("    signal challengeXi[3];\n");
    out.push_str("    signal challengesFRI[2][3];\n");
    challenge_names.extend(["challengeQ", "challengeXi", "challengesFRI"].iter().map(|s| s.to_string()));

    out.push_str(&format!(
        "    signal challengesFRISteps[{}][3];\n",
        steps.len() + 1
    ));
    out.push_str(&format!(
        "    signal {{binary}} queriesFRI[{}][{}];\n\n",
        n_queries, step0_bits
    ));

    // Wire Transcript
    let mut inputs_c: Vec<String> = Vec::new();
    if !options.input_challenges {
        if n_publics > 0 {
            inputs_c.push("publics".to_string());
        }
        inputs_c.push("rootC".to_string());
        inputs_c.push("root1".to_string());
    } else {
        inputs_c.push("globalChallenge".to_string());
    }
    if !air_values_map.is_empty() {
        inputs_c.push("airvalues".to_string());
    }
    let mut stage_roots: Vec<String> = Vec::new();
    for i in 1..n_stages {
        stage_roots.push(format!("root{}", i + 1));
    }

    // Build Transcript call arguments
    let mut transcript_args = inputs_c;
    transcript_args.extend(stage_roots);
    transcript_args.push(format!("root{}", q_stage));
    transcript_args.push("evals".to_string());
    transcript_args.extend(si_roots.iter().cloned());
    transcript_args.push("finalPol".to_string());
    if pow_bits > 0 {
        transcript_args.push("nonce".to_string());
    }
    transcript_args.push("enabled".to_string());

    out.push_str(&format!(
        "    ({},challengesFRISteps,queriesFRI) <== {}()({});\n\n",
        challenge_names.join(","),
        transcript_name,
        transcript_args.join(",")
    ));

    // Wire VerifyEvaluations
    let mut verify_evals_inputs: Vec<String> = Vec::new();
    for si in 0..n_stages {
        let stage = si + 1;
        let stage_challenges: Vec<&Value> = challenges_map
            .iter()
            .filter(|c| c.get("stage").and_then(|v| v.as_u64()).unwrap_or(0) == stage)
            .collect();
        if !stage_challenges.is_empty() {
            verify_evals_inputs.push(format!("challengesStage{}", stage));
        }
    }
    verify_evals_inputs.push("challengeQ".to_string());
    verify_evals_inputs.push("challengeXi".to_string());
    verify_evals_inputs.push("evals".to_string());
    if n_publics > 0 {
        verify_evals_inputs.push("publics".to_string());
    }
    if !agv_map.is_empty() {
        verify_evals_inputs.push("airgroupvalues".to_string());
    }
    if !air_values_map.is_empty() {
        verify_evals_inputs.push("airvalues".to_string());
    }
    if !proof_values_map.is_empty() {
        verify_evals_inputs.push("proofvalues".to_string());
    }
    verify_evals_inputs.push("enabled".to_string());

    out.push_str(&format!(
        "    {}()({});\n\n",
        verify_eval_name,
        verify_evals_inputs.join(", ")
    ));

    // Preprocess s_i vals (transpose for MerkleHash)
    for si in 0..n_stages {
        let stage = si + 1;
        let cm_key = format!("cm{}", stage);
        let cm_n = map_sections
            .get(&cm_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        if cm_n > 0 {
            out.push_str(&format!(
                "    var s0_vals{}_p[{}][{}][1];\n",
                stage, n_queries, cm_n
            ));
        }
    }
    out.push_str(&format!(
        "    var s0_vals{}_p[{}][{}][1];\n",
        q_stage, n_queries, q_cm_n_sv
    ));
    out.push_str(&format!(
        "    var s0_valsC_p[{}][{}][1];\n",
        n_queries, n_constants
    ));
    for cc in &custom_commits {
        let cc_name = cc.get("name").and_then(|v| v.as_str()).unwrap_or("custom");
        let cc_key = format!("{}0", cc_name);
        let cc_n = map_sections
            .get(&cc_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        out.push_str(&format!(
            "    var s0_vals_{}_0_p[{}][{}][1];\n",
            cc_name, n_queries, cc_n
        ));
    }
    for s in 0..steps.len() {
        let exponent = if s == 0 {
            1u64
        } else {
            let prev_bits = steps[s - 1]
                .get("nBits")
                .and_then(|v| v.as_u64())
                .unwrap_or(0);
            let cur_bits = steps[s]
                .get("nBits")
                .and_then(|v| v.as_u64())
                .unwrap_or(0);
            1u64 << (prev_bits - cur_bits)
        };
        out.push_str(&format!(
            "    var s{}_vals_p[{}][{}][3];\n",
            s, n_queries, exponent
        ));
    }

    out.push_str(&format!(
        "\n    for (var q=0; q<{}; q++) {{\n",
        n_queries
    ));
    for si in 0..n_stages {
        let stage = si + 1;
        let cm_key = format!("cm{}", stage);
        let cm_n = map_sections
            .get(&cm_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        if cm_n > 0 {
            out.push_str(&format!(
                "        for (var i = 0; i < {}; i++) {{\n            s0_vals{}_p[q][i][0] = s0_vals{}[q][i];\n        }}\n",
                cm_n, stage, stage
            ));
        }
    }
    out.push_str(&format!(
        "        for (var i = 0; i < {}; i++) {{\n            s0_vals{}_p[q][i][0] = s0_vals{}[q][i];\n        }}\n",
        q_cm_n_sv, q_stage, q_stage
    ));
    out.push_str(&format!(
        "        for (var i = 0; i < {}; i++) {{\n            s0_valsC_p[q][i][0] = s0_valsC[q][i];\n        }}\n",
        n_constants
    ));
    for cc in &custom_commits {
        let cc_name = cc.get("name").and_then(|v| v.as_str()).unwrap_or("custom");
        let cc_key = format!("{}0", cc_name);
        let cc_n = map_sections
            .get(&cc_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        out.push_str(&format!(
            "    for (var i = 0; i < {}; i++) {{\n        s0_vals_{}_0_p[q][i][0] = s0_vals_{}_0[q][i];\n    }}\n",
            cc_n, cc_name, cc_name
        ));
    }
    // Preprocess FRI step vals
    out.push_str("        for(var e=0; e < 3; e++) {\n");
    for s in 1..steps.len() {
        let prev_bits = steps[s - 1]
            .get("nBits")
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        let cur_bits = steps[s]
            .get("nBits")
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        let count = 1u64 << (prev_bits - cur_bits);
        out.push_str(&format!(
            "            for(var c=0; c < {}; c++) {{\n                s{}_vals_p[q][c][e] = s{}_vals[q][c*3+e];\n            }}\n",
            count, s, s
        ));
    }
    out.push_str("        }\n    }\n\n");

    // Merkle root verification
    let n_bits_arity_ceil = (step0_bits as f64 / log2_arity).ceil() as u64;
    let log2_arity_u64 = log2_arity.ceil() as u64;
    out.push_str(&format!(
        "    signal {{binary}} queriesFRIBits[{}][{}][{}];\n",
        n_queries, n_bits_arity_ceil, log2_arity_u64
    ));
    out.push_str(&format!(
        "    for(var i = 0; i < {}; i++) {{\n        for(var j = 0; j < {}; j++) {{\n            for(var k = 0; k < {}; k++) {{\n                if (k + j * {} >= {}) {{\n                    queriesFRIBits[i][j][k] <== 0;\n                }} else {{\n                    queriesFRIBits[i][j][k] <== queriesFRI[i][j*{} + k];\n                }}\n            }}\n        }}\n    }}\n\n",
        n_queries, n_bits_arity_ceil, log2_arity_u64, log2_arity_u64, step0_bits, log2_arity_u64
    ));

    // Verify Merkle roots for stage polynomial commitments
    for si in 0..n_stages {
        let stage = si + 1;
        let cm_key = format!("cm{}", stage);
        let cm_n = map_sections
            .get(&cm_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        if cm_n > 0 {
            out.push_str(&format!("    for (var q=0; q<{}; q++) {{\n", n_queries));
            if last_level > 0 {
                out.push_str(&format!(
                    "        VerifyMerkleHashUntilLevel(1, {}, {}, {}, {}, {})(s0_vals{}_p[q], s0_siblings{}[q], queriesFRIBits[q], s0_last_mt_levels{}, enabled);\n",
                    cm_n, arity, sib_levels_0, last_level, 1u64 << n_bits_ext, stage, stage, stage
                ));
            } else {
                out.push_str(&format!(
                    "        VerifyMerkleHash(1, {}, {}, {})(s0_vals{}_p[q], s0_siblings{}[q], queriesFRIBits[q], root{}, enabled);\n",
                    cm_n, arity, n_bits_arity_ceil, stage, stage, stage
                ));
            }
            out.push_str("    }\n");
        }
    }

    // Q stage Merkle verification
    out.push_str(&format!("\n    for (var q=0; q<{}; q++) {{\n", n_queries));
    if last_level > 0 {
        out.push_str(&format!(
            "        VerifyMerkleHashUntilLevel(1, {}, {}, {}, {}, {})(s0_vals{}_p[q], s0_siblings{}[q], queriesFRIBits[q], s0_last_mt_levels{}, enabled);\n",
            q_cm_n_sv, arity, sib_levels_0, last_level, 1u64 << n_bits_ext, q_stage, q_stage, q_stage
        ));
    } else {
        out.push_str(&format!(
            "        VerifyMerkleHash(1, {}, {}, {})(s0_vals{}_p[q], s0_siblings{}[q], queriesFRIBits[q], root{}, enabled);\n",
            q_cm_n_sv, arity, n_bits_arity_ceil, q_stage, q_stage, q_stage
        ));
    }
    out.push_str("    }\n");

    // Constants Merkle verification
    out.push_str(&format!("\n    for (var q=0; q<{}; q++) {{\n", n_queries));
    if last_level > 0 {
        out.push_str(&format!(
            "        VerifyMerkleHashUntilLevel(1, {}, {}, {}, {}, {})(s0_valsC_p[q], s0_siblingsC[q], queriesFRIBits[q], s0_last_mt_levelsC, enabled);\n",
            n_constants, arity, sib_levels_0, last_level, 1u64 << n_bits_ext
        ));
    } else {
        out.push_str(&format!(
            "        VerifyMerkleHash(1, {}, {}, {})(s0_valsC_p[q], s0_siblingsC[q], queriesFRIBits[q], rootC, enabled);\n",
            n_constants, arity, n_bits_arity_ceil
        ));
    }
    out.push_str("    }\n");

    // Custom commits Merkle verification
    for cc in &custom_commits {
        let cc_name = cc.get("name").and_then(|v| v.as_str()).unwrap_or("custom");
        let public_values = cc
            .get("publicValues")
            .and_then(|v| v.as_array())
            .cloned()
            .unwrap_or_default();
        let idx: Vec<u64> = public_values
            .iter()
            .map(|pv| pv.get("idx").and_then(|v| v.as_u64()).unwrap_or(0))
            .collect();
        if idx.len() >= 4 {
            out.push_str(&format!(
                "\n    signal root_{}_0[4] <== [publics[{}], publics[{}], publics[{}], publics[{}]];\n",
                cc_name, idx[0], idx[1], idx[2], idx[3]
            ));
        }
        let cc_key = format!("{}0", cc_name);
        let cc_n = map_sections
            .get(&cc_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        out.push_str(&format!("    for (var q=0; q<{}; q++) {{\n", n_queries));
        if last_level > 0 {
            out.push_str(&format!(
                "        VerifyMerkleHashUntilLevel(1, {}, {}, {}, {}, {})(s0_vals_{}_0_p[q], s0_siblings_{}_0[q], queriesFRIBits[q], s0_last_mt_levels_{}_0, enabled);\n",
                cc_n, arity, sib_levels_0, last_level, 1u64 << n_bits_ext, cc_name, cc_name, cc_name
            ));
        } else {
            out.push_str(&format!(
                "        VerifyMerkleHash(1, {}, {}, {})(s0_vals_{}_0_p[q], s0_siblings_{}_0[q], queriesFRIBits[q], root_{}_0, enabled);\n",
                cc_n, arity, n_bits_arity_ceil, cc_name, cc_name, cc_name
            ));
        }
        out.push_str("    }\n");
    }

    // FRI step Merkle verification
    for s in 1..steps.len() {
        let cur_bits = steps[s]
            .get("nBits")
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        let prev_bits = steps[s - 1]
            .get("nBits")
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        let sib_levels_s = (cur_bits as f64 / log2_arity).ceil() as u64;
        let sib_levels_s_adj = sib_levels_s - last_level;
        let merkle_bits_s = (cur_bits as f64 / log2_arity).ceil() as u64;

        out.push_str(&format!(
            "\n    signal {{binary}} s{}_keys_merkle_bits[{}][{}][{}];\n",
            s, n_queries, merkle_bits_s, log2_arity_u64
        ));
        out.push_str(&format!(
            "    for (var q=0; q<{}; q++) {{\n        for(var j = 0; j < {}; j++) {{\n            for(var k = 0; k < {}; k++) {{\n                if (k + j * {} >= {}) {{\n                    s{}_keys_merkle_bits[q][j][k] <== 0;\n                }} else {{\n                    s{}_keys_merkle_bits[q][j][k] <== queriesFRI[q][j*{} + k];\n                }}\n            }}\n        }}\n",
            n_queries, merkle_bits_s, log2_arity_u64, log2_arity_u64, cur_bits, s, s, log2_arity_u64
        ));

        let n_vals = 1u64 << (prev_bits - cur_bits);
        if last_level > 0 {
            if sib_levels_s_adj == 0 {
                out.push_str(&format!(
                    "        VerifyMerkleHashUntilLevelEmpty(3, {}, {}, {}, {})(s{}_vals_p[q], s{}_keys_merkle_bits[q], s{}_last_mt_levels, enabled);\n",
                    n_vals, arity, last_level, 1u64 << cur_bits, s, s, s
                ));
            } else {
                out.push_str(&format!(
                    "        VerifyMerkleHashUntilLevel(3, {}, {}, {}, {}, {})(s{}_vals_p[q], s{}_siblings[q], s{}_keys_merkle_bits[q], s{}_last_mt_levels, enabled);\n",
                    n_vals, arity, sib_levels_s_adj, last_level, 1u64 << cur_bits, s, s, s, s
                ));
            }
        } else {
            out.push_str(&format!(
                "        VerifyMerkleHash(3, {}, {}, {})(s{}_vals_p[q], s{}_siblings[q], s{}_keys_merkle_bits[q], s{}_root, enabled);\n",
                n_vals, arity, merkle_bits_s, s, s, s, s
            ));
        }
        out.push_str("    }\n");
    }

    // VerifyMerkleRoot calls for lastLevelVerification
    if last_level > 0 {
        for si in 0..n_stages {
            let stage = si + 1;
            out.push_str(&format!(
                "    VerifyMerkleRoot({}, {}, {})(s0_last_mt_levels{}, root{}, enabled);\n",
                last_level, arity, 1u64 << n_bits_ext, stage, stage
            ));
        }
        out.push_str(&format!(
            "    VerifyMerkleRoot({}, {}, {})(s0_last_mt_levels{}, root{}, enabled);\n",
            last_level, arity, 1u64 << n_bits_ext, q_stage, q_stage
        ));
        out.push_str(&format!(
            "    VerifyMerkleRoot({}, {}, {})(s0_last_mt_levelsC, rootC, enabled);\n",
            last_level, arity, 1u64 << n_bits_ext
        ));
        for cc in &custom_commits {
            let cc_name = cc.get("name").and_then(|v| v.as_str()).unwrap_or("custom");
            out.push_str(&format!(
                "    VerifyMerkleRoot({}, {}, {})(s0_last_mt_levels_{}_0, root_{}_0, enabled);\n",
                last_level, arity, 1u64 << n_bits_ext, cc_name, cc_name
            ));
        }
        for s in 1..steps.len() {
            let cur_bits = steps[s]
                .get("nBits")
                .and_then(|v| v.as_u64())
                .unwrap_or(0);
            out.push_str(&format!(
                "    VerifyMerkleRoot({}, {}, {})(s{}_last_mt_levels, s{}_root, enabled);\n",
                last_level, arity, 1u64 << cur_bits, s, s
            ));
        }
    }

    // Calculate FRI Polynomial
    out.push_str(&format!(
        "\n    for (var q=0; q<{}; q++) {{\n",
        n_queries
    ));
    let mut query_vals: Vec<String> = Vec::new();
    for si in 0..n_stages {
        let stage = si + 1;
        let cm_key = format!("cm{}", stage);
        let cm_n = map_sections
            .get(&cm_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        if cm_n > 0 {
            query_vals.push(format!("s0_vals{}[q]", stage));
        }
    }
    query_vals.push(format!("s0_vals{}[q]", q_stage));
    query_vals.push("s0_valsC[q]".to_string());
    for cc in &custom_commits {
        let cc_name = cc.get("name").and_then(|v| v.as_str()).unwrap_or("custom");
        query_vals.push(format!("s0_vals_{}_0[q]", cc_name));
    }
    out.push_str(&format!(
        "        queryVals[q] <== {}()(queriesFRI[q], challengeXi, challengesFRI, evals, {});\n",
        calc_fri_pol_name,
        query_vals.join(", ")
    ));
    out.push_str("    }\n\n");

    // Verify FRI Polynomial
    let verify_query_name = if airgroup_suffix.is_empty() {
        "VerifyQuery".to_string()
    } else {
        format!("VerifyQuery{}", airgroup_suffix)
    };
    for s in 1..steps.len() {
        let cur_bits = steps[s]
            .get("nBits")
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        out.push_str(&format!(
            "    signal {{binary}} s{}_queriesFRI[{}][{}];\n",
            s, n_queries, cur_bits
        ));
    }

    out.push_str(&format!(
        "\n    for (var q=0; q<{}; q++) {{\n",
        n_queries
    ));
    // First FRI step verification
    let next_vals_pol_0 = if steps.len() > 1 {
        "s1_vals_p[q]".to_string()
    } else {
        "finalPol".to_string()
    };
    let next_step_0 = if steps.len() > 1 {
        steps[1]
            .get("nBits")
            .and_then(|v| v.as_u64())
            .unwrap_or(0)
    } else {
        0
    };
    out.push_str(&format!(
        "        {}({}, {})(queriesFRI[q], queryVals[q], {}, enabled);\n",
        verify_query_name, step0_bits, next_step_0, next_vals_pol_0
    ));

    for s in 1..steps.len() {
        let cur_bits = steps[s]
            .get("nBits")
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        let prev_bits = steps[s - 1]
            .get("nBits")
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        out.push_str(&format!(
            "        for(var i = 0; i < {}; i++) {{ s{}_queriesFRI[q][i] <== queriesFRI[q][i]; }}\n",
            cur_bits, s
        ));

        let next_pol_fri = if s < steps.len() - 1 {
            format!("s{}_vals_p[q]", s + 1)
        } else {
            "finalPol".to_string()
        };
        let next_step_fri = if s < steps.len() - 1 {
            steps[s + 1]
                .get("nBits")
                .and_then(|v| v.as_u64())
                .unwrap_or(0)
        } else {
            0
        };
        let exponent = 1u64 << (n_bits_ext - prev_bits);
        let e0 = compute_inv_shift_exp(exponent);
        out.push_str(&format!(
            "        {}({}, {}, {}, {}, {})(s{}_queriesFRI[q], challengesFRISteps[{}], s{}_vals_p[q], {}, enabled);\n",
            verify_fri_name, n_bits_ext, prev_bits, cur_bits, next_step_fri, e0, s, s, s, next_pol_fri
        ));
    }
    out.push_str("    }\n\n");

    // Verify Final Polynomial
    let verify_final_pol_name = if airgroup_suffix.is_empty() {
        "VerifyFinalPol".to_string()
    } else {
        format!("VerifyFinalPol{}", airgroup_suffix)
    };
    out.push_str(&format!(
        "    {}()(finalPol, enabled);\n",
        verify_final_pol_name
    ));

    // Close template
    out.push_str("}\n\n");

    if !options.skip_main {
        if n_publics > 0 {
            out.push_str(&format!(
                "component main {{public [publics]}}= {}();\n",
                verifier_name
            ));
        } else {
            out.push_str(&format!("component main = {}();\n", verifier_name));
        }
    }

    Ok(out)
}

/// Render the BN128 verifier, mirrors GL approach with BN128-specific includes.
fn render_bn128_verifier(
    const_root: &[String; 4],
    stark_info: &Value,
    verifier_info: &Value,
    stark_struct: &Value,
    options: &Pil2CircomOptions,
) -> Result<String> {
    let arity = stark_struct
        .get("merkleTreeArity")
        .and_then(|v| v.as_u64())
        .unwrap_or(16);
    let custom = stark_struct
        .get("merkleTreeCustom")
        .and_then(|v| v.as_bool())
        .unwrap_or(false);
    let transcript_arity = if custom { arity } else { 16 };

    let airgroup_id = stark_info.get("airgroupId").and_then(|v| v.as_u64());
    let airgroup_suffix = airgroup_id
        .map(|id| id.to_string())
        .unwrap_or_default();

    let n_stages = stark_info
        .get("nStages")
        .and_then(|v| v.as_u64())
        .unwrap_or(1);
    let _q_stage = n_stages + 1;
    let n_bits = stark_struct
        .get("nBits")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    let n_queries = stark_struct
        .get("nQueries")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    let pow_bits = stark_struct
        .get("powBits")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);

    let steps = stark_struct
        .get("steps")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();

    let ev_map = stark_info
        .get("evMap")
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);

    let n_publics = stark_info
        .get("nPublics")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);

    let _q_verifier = verifier_info.get("qVerifier");
    let _query_verifier = verifier_info.get("queryVerifier");

    let mut out = String::with_capacity(64 * 1024);

    out.push_str("pragma circom 2.1.0;\n");
    if custom {
        out.push_str("pragma custom_templates;\n");
    }
    out.push('\n');

    // BN128 specific includes
    out.push_str("include \"cmul.circom\";\n");
    out.push_str("include \"cinv.circom\";\n");
    out.push_str("include \"bn1togl3.circom\";\n");
    out.push_str("include \"glconst.circom\";\n");
    if custom {
        out.push_str("include \"poseidon_custom.circom\";\n");
    } else {
        out.push_str("include \"poseidonex.circom\";\n");
    }
    out.push_str("include \"bitify.circom\";\n");
    out.push_str("include \"fft.circom\";\n");
    out.push_str("include \"evalpol.circom\";\n");
    out.push_str("include \"treeselector4.circom\";\n");
    out.push_str("include \"pow.circom\";\n");
    if custom {
        out.push_str("include \"merklehash_custom.circom\";\n");
    } else {
        out.push_str("include \"merklehash_bn128.circom\";\n");
    }

    out.push_str(&format!(
        "\n// BN128 Stark Verifier{}\n",
        if airgroup_suffix.is_empty() {
            String::new()
        } else {
            format!(" (airgroup {})", airgroup_suffix)
        }
    ));
    out.push_str(&format!(
        "// nStages={}, nBits={}, nQueries={}, arity={}, transcriptArity={}\n",
        n_stages, n_bits, n_queries, arity, transcript_arity
    ));
    out.push_str(&format!(
        "// steps={}, evMap.length={}, nPublics={}, powBits={}\n\n",
        steps.len(),
        ev_map,
        n_publics,
        pow_bits
    ));

    // Emit the StarkVerifier template header
    let verifier_name = format!("StarkVerifier{}", airgroup_suffix);
    out.push_str(&format!("template {}() {{\n", verifier_name));

    if n_publics > 0 {
        out.push_str(&format!(
            "    signal input publics[{}]; // publics polynomials\n",
            n_publics
        ));
    }

    // rootC
    if options.verkey_input {
        out.push_str(
            "    signal input rootC; // Merkle tree root of the evaluations of constant polynomials\n",
        );
    } else if options.input_challenges {
        out.push_str(&format!(
            "    signal output rootC <== {}; // Merkle tree root of the evaluations of constant polynomials\n",
            const_root[0]
        ));
    } else {
        out.push_str(&format!(
            "    signal rootC <== {}; // Merkle tree root of the evaluations of constant polynomials\n",
            const_root[0]
        ));
    }

    // evals
    out.push_str(&format!(
        "    signal input evals[{}][3]; // Evaluations of the set polynomials at a challenge value z and gz\n",
        ev_map
    ));

    out.push_str("\n    signal {binary} enabled;\n");
    if options.enable_input {
        out.push_str("    signal input enable;\n");
        out.push_str("    enable * (enable -1) === 0;\n");
        out.push_str("    enabled <== enable;\n");
    } else {
        out.push_str("    enabled <== 1;\n");
    }

    if options.input_challenges {
        out.push_str("    signal input globalChallenge[3];\n");
    }

    out.push_str("}\n\n");

    if !options.skip_main {
        if n_publics > 0 {
            out.push_str(&format!(
                "component main {{public [publics]}}= {}();\n",
                verifier_name
            ));
        } else {
            out.push_str(&format!("component main = {}();\n", verifier_name));
        }
    }

    Ok(out)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn make_test_stark_info(hash_type: &str) -> Value {
        serde_json::json!({
            "starkStruct": {
                "verificationHashType": hash_type,
                "merkleTreeArity": 16,
                "merkleTreeCustom": false,
                "nBits": 20,
                "nBitsExt": 21,
                "nQueries": 32,
                "powBits": 0,
                "splitLinearHash": false,
                "hashCommits": false,
                "lastLevelVerification": 0,
                "steps": [
                    {"nBits": 21},
                    {"nBits": 7}
                ]
            },
            "nStages": 2,
            "nPublics": 4,
            "nConstants": 3,
            "evMap": [{"type": "cm", "id": 0}],
            "cmPolsMap": [],
            "customCommits": [],
            "customCommitsMap": [],
            "boundaries": [],
            "challengesMap": [],
            "airgroupValuesMap": [],
            "airValuesMap": [],
            "proofValuesMap": [],
            "mapSectionsN": {},
            "openingPoints": [0, 1],
            "qDeg": 2
        })
    }

    #[test]
    fn test_gl_verifier() {
        let root = [
            "123".to_string(),
            "456".to_string(),
            "789".to_string(),
            "101".to_string(),
        ];
        let si = make_test_stark_info("GL");
        let vi = serde_json::json!({
            "qVerifier": {"code": []},
            "queryVerifier": {"code": []}
        });
        let opts = Pil2CircomOptions::default();
        let result = pil2circom(&root, &si, &vi, &opts).unwrap();
        assert!(result.contains("pragma circom 2.1.0;"));
        assert!(result.contains("pragma custom_templates;"));
        assert!(result.contains("template StarkVerifier()"));
        assert!(result.contains("signal input publics[4]"));
        assert!(result.contains("123,456,789,101"));
        assert!(result.contains("component main"));
    }

    #[test]
    fn test_bn128_verifier() {
        let root = ["999".to_string(), "0".into(), "0".into(), "0".into()];
        let si = make_test_stark_info("BN128");
        let vi = serde_json::json!({
            "qVerifier": {"code": []},
            "queryVerifier": {"code": []}
        });
        let opts = Pil2CircomOptions {
            skip_main: true,
            ..Default::default()
        };
        let result = pil2circom(&root, &si, &vi, &opts).unwrap();
        assert!(result.contains("BN128 Stark Verifier"));
        assert!(!result.contains("component main"));
    }

    #[test]
    fn test_invalid_hash_type() {
        let root = ["0".into(), "0".into(), "0".into(), "0".into()];
        let si = serde_json::json!({
            "starkStruct": { "verificationHashType": "UNKNOWN" }
        });
        let vi = serde_json::json!({});
        let opts = Pil2CircomOptions::default();
        assert!(pil2circom(&root, &si, &vi, &opts).is_err());
    }

    #[test]
    fn test_airgroup_suffix() {
        let root = ["0".into(), "0".into(), "0".into(), "0".into()];
        let mut si = make_test_stark_info("GL");
        si["airgroupId"] = serde_json::json!(3);
        let vi = serde_json::json!({
            "qVerifier": {"code": []},
            "queryVerifier": {"code": []}
        });
        let opts = Pil2CircomOptions::default();
        let result = pil2circom(&root, &si, &vi, &opts).unwrap();
        assert!(result.contains("template StarkVerifier3()"));
    }

    #[test]
    fn test_verkey_input_mode() {
        let root = ["0".into(), "0".into(), "0".into(), "0".into()];
        let si = make_test_stark_info("GL");
        let vi = serde_json::json!({
            "qVerifier": {"code": []},
            "queryVerifier": {"code": []}
        });
        let opts = Pil2CircomOptions {
            verkey_input: true,
            ..Default::default()
        };
        let result = pil2circom(&root, &si, &vi, &opts).unwrap();
        assert!(result.contains("signal input rootC[4]"));
    }
}
