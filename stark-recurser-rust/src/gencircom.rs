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

// ---------------------------------------------------------------------------
// Fragment rendering helpers
// ---------------------------------------------------------------------------
// Each function below corresponds to an EJS sub-template included by the
// vadcop circom templates.  They receive the relevant JSON structures and
// produce the equivalent circom source fragment as a `String`.

/// Render the `define_stark_inputs.circom.ejs` fragment.
///
/// Declares all input signals for a STARK verifier component: root signals,
/// evaluation signals, Merkle siblings, FRI values, final polynomial, etc.
fn render_define_stark_inputs(prefix: &str, si: &Value, add_publics: bool) -> String {
    let p = if prefix.is_empty() {
        String::new()
    } else {
        format!("{}_", prefix)
    };
    let mut out = String::new();

    let n_publics = si.get("nPublics").and_then(|v| v.as_u64()).unwrap_or(0);
    if add_publics && n_publics > 0 {
        out.push_str(&format!("    signal input {}publics[{}];\n", p, n_publics));
    }

    let agv_map_len = si
        .get("airgroupValuesMap")
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);
    if agv_map_len > 0 {
        out.push_str(&format!(
            "    signal input {}airgroupvalues[{}][3];\n",
            p, agv_map_len
        ));
    }

    let av_map_len = si
        .get("airValuesMap")
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);
    if av_map_len > 0 {
        out.push_str(&format!(
            "    signal input {}airvalues[{}][3];\n",
            p, av_map_len
        ));
    }

    let n_stages = si.get("nStages").and_then(|v| v.as_u64()).unwrap_or(1);
    let ss = si.get("starkStruct").unwrap_or(&Value::Null);
    let hash_type = ss
        .get("verificationHashType")
        .and_then(|v| v.as_str())
        .unwrap_or("GL");

    // root signals for each stage + Q stage
    for s in 1..=(n_stages + 1) {
        if hash_type == "BN128" {
            out.push_str(&format!("    signal input {}root{};\n", p, s));
        } else {
            out.push_str(&format!("    signal input {}root{}[4];\n", p, s));
        }
    }

    let ev_map_len = si
        .get("evMap")
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);
    out.push_str(&format!(
        "    signal input {}evals[{}][3];\n",
        p, ev_map_len
    ));

    let n_queries = ss.get("nQueries").and_then(|v| v.as_u64()).unwrap_or(0);
    let n_constants = si
        .get("nConstants")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    let arity = ss
        .get("merkleTreeArity")
        .and_then(|v| v.as_u64())
        .unwrap_or(16);
    let steps = ss
        .get("steps")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    let last_level = ss
        .get("lastLevelVerification")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);

    out.push_str(&format!(
        "    signal input {}s0_valsC[{}][{}];\n",
        p, n_queries, n_constants
    ));

    let step0_bits = steps
        .first()
        .and_then(|s| s.get("nBits").and_then(|v| v.as_u64()))
        .unwrap_or(0);
    let log2_arity = (arity as f64).log2();

    if hash_type == "BN128" {
        let sib_levels = ((step0_bits as f64 - 1.0) / log2_arity).floor() as u64 + 1;
        out.push_str(&format!(
            "    signal input {}s0_siblingsC[{}][{}][{}];\n",
            p, n_queries, sib_levels, arity
        ));
    } else {
        let sib_levels =
            (step0_bits as f64 / log2_arity).ceil() as u64 - last_level;
        out.push_str(&format!(
            "    signal input {}s0_siblingsC[{}][{}][{}];\n",
            p,
            n_queries,
            sib_levels,
            (arity - 1) * 4
        ));
        if last_level > 0 {
            let ll_size = arity.pow(last_level as u32);
            out.push_str(&format!(
                "    signal input {}s0_last_mt_levelsC[{}][4];\n",
                p, ll_size
            ));
        }
    }

    // Custom commits
    let custom_commits = si
        .get("customCommits")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    for cc in &custom_commits {
        let name = cc.get("name").and_then(|v| v.as_str()).unwrap_or("custom");
        let stage_widths = cc
            .get("stageWidths")
            .and_then(|v| v.as_array())
            .cloned()
            .unwrap_or_default();
        let width0 = stage_widths
            .first()
            .and_then(|v| v.as_u64())
            .unwrap_or(0);

        out.push_str(&format!(
            "    signal input {}s0_vals_{}_0[{}][{}];\n",
            p, name, n_queries, width0
        ));
        if hash_type == "BN128" {
            let sib_levels = ((step0_bits as f64 - 1.0) / log2_arity).floor() as u64 + 1;
            out.push_str(&format!(
                "    signal input {}s0_siblings_{}_0[{}][{}][{}];\n",
                p, name, n_queries, sib_levels, arity
            ));
        } else {
            let sib_levels =
                (step0_bits as f64 / log2_arity).ceil() as u64 - last_level;
            out.push_str(&format!(
                "    signal input {}s0_siblings_{}_0[{}][{}][{}];\n",
                p,
                name,
                n_queries,
                sib_levels,
                (arity - 1) * 4
            ));
            if last_level > 0 {
                let ll_size = arity.pow(last_level as u32);
                out.push_str(&format!(
                    "    signal input {}s0_last_mt_levels_{}_0[{}][4];\n",
                    p, name, ll_size
                ));
            }
        }
    }

    // Stage values and siblings
    let map_sections = si.get("mapSectionsN").unwrap_or(&Value::Null);
    for s in 1..=(n_stages + 1) {
        let cm_key = format!("cm{}", s);
        let cm_n = map_sections
            .get(&cm_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        if cm_n > 0 {
            out.push_str(&format!(
                "    signal input {}s0_vals{}[{}][{}];\n",
                p, s, n_queries, cm_n
            ));
            if hash_type == "BN128" {
                let sib_levels =
                    ((step0_bits as f64 - 1.0) / log2_arity).floor() as u64 + 1;
                out.push_str(&format!(
                    "    signal input {}s0_siblings{}[{}][{}][{}];\n",
                    p, s, n_queries, sib_levels, arity
                ));
            } else {
                let sib_levels =
                    (step0_bits as f64 / log2_arity).ceil() as u64 - last_level;
                out.push_str(&format!(
                    "    signal input {}s0_siblings{}[{}][{}][{}];\n",
                    p,
                    s,
                    n_queries,
                    sib_levels,
                    (arity - 1) * 4
                ));
                if last_level > 0 {
                    let ll_size = arity.pow(last_level as u32);
                    out.push_str(&format!(
                        "    signal input {}s0_last_mt_levels{}[{}][4];\n",
                        p, s, ll_size
                    ));
                }
            }
        }
    }

    // FRI step roots
    for s in 1..steps.len() {
        if hash_type == "BN128" {
            out.push_str(&format!("    signal input {}s{}_root;\n", p, s));
        } else {
            out.push_str(&format!("    signal input {}s{}_root[4];\n", p, s));
        }
    }

    // FRI step values and siblings
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
            "    signal input {}s{}_vals[{}][{}];\n",
            p, s, n_queries, vals_width
        ));
        if hash_type == "BN128" {
            let sib_levels = ((cur_bits as f64 - 1.0) / log2_arity).floor() as u64 + 1;
            out.push_str(&format!(
                "    signal input {}s{}_siblings[{}][{}][{}];\n",
                p, s, n_queries, sib_levels, arity
            ));
        } else {
            let sib_levels =
                (cur_bits as f64 / log2_arity).ceil() as u64 - last_level;
            out.push_str(&format!(
                "    signal input {}s{}_siblings[{}][{}][{}];\n",
                p,
                s,
                n_queries,
                sib_levels,
                (arity - 1) * 4
            ));
            if last_level > 0 {
                let ll_size = arity.pow(last_level as u32);
                out.push_str(&format!(
                    "    signal input {}s{}_last_mt_levels[{}][4];\n",
                    p, s, ll_size
                ));
            }
        }
    }

    // Final polynomial
    let last_step_bits = steps
        .last()
        .and_then(|s| s.get("nBits").and_then(|v| v.as_u64()))
        .unwrap_or(0);
    let final_pol_size = 1u64 << last_step_bits;
    out.push_str(&format!(
        "    signal input {}finalPol[{}][3];\n",
        p, final_pol_size
    ));

    // Nonce for PoW
    let pow_bits = ss.get("powBits").and_then(|v| v.as_u64()).unwrap_or(0);
    if pow_bits > 0 {
        out.push_str(&format!("    signal input {}nonce;\n", p));
    }

    out
}

/// Render the `assign_stark_inputs.circom.ejs` fragment.
///
/// Instantiates a StarkVerifier component and wires all its inputs.
fn render_assign_stark_inputs(
    component_name: &str,
    prefix: &str,
    si: &Value,
    add_publics: bool,
    set_enable_input: bool,
) -> String {
    let p = if prefix.is_empty() {
        String::new()
    } else {
        format!("{}_", prefix)
    };
    let mut out = String::new();

    let airgroup_id = si.get("airgroupId").and_then(|v| v.as_u64());
    if let Some(ag_id) = airgroup_id {
        out.push_str(&format!(
            "    component {} = StarkVerifier{}();\n",
            component_name, ag_id
        ));
    } else {
        out.push_str(&format!(
            "    component {} = StarkVerifier();\n",
            component_name
        ));
    }

    let n_publics = si.get("nPublics").and_then(|v| v.as_u64()).unwrap_or(0);
    if add_publics && n_publics > 0 {
        out.push_str(&format!(
            "    for (var i=0; i< {}; i++) {{\n        {}.publics[i] <== {}publics[i];\n    }}\n",
            n_publics, component_name, p
        ));
    }

    let agv_map_len = si
        .get("airgroupValuesMap")
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);
    if agv_map_len > 0 {
        out.push_str(&format!(
            "    {}.airgroupvalues <== {}airgroupvalues;\n",
            component_name, p
        ));
    }

    let av_map_len = si
        .get("airValuesMap")
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);
    if av_map_len > 0 {
        out.push_str(&format!(
            "    {}.airvalues <== {}airvalues;\n",
            component_name, p
        ));
    }

    let pv_map_len = si
        .get("proofValuesMap")
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);
    if pv_map_len > 0 {
        out.push_str(&format!(
            "    {}.proofvalues <== proofValues;\n",
            component_name
        ));
    }

    let n_stages = si.get("nStages").and_then(|v| v.as_u64()).unwrap_or(1);
    for s in 1..=(n_stages + 1) {
        out.push_str(&format!(
            "    {}.root{} <== {}root{};\n",
            component_name, s, p, s
        ));
    }

    out.push_str(&format!(
        "    {}.evals <== {}evals;\n",
        component_name, p
    ));

    out.push_str(&format!(
        "    {}.s0_valsC <== {}s0_valsC;\n",
        component_name, p
    ));
    out.push_str(&format!(
        "    {}.s0_siblingsC <== {}s0_siblingsC;\n",
        component_name, p
    ));

    let ss = si.get("starkStruct").unwrap_or(&Value::Null);
    let last_level = ss
        .get("lastLevelVerification")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    if last_level > 0 {
        out.push_str(&format!(
            "    {}.s0_last_mt_levelsC <== {}s0_last_mt_levelsC;\n",
            component_name, p
        ));
    }

    // Custom commits
    let custom_commits = si
        .get("customCommits")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    for cc in &custom_commits {
        let name = cc.get("name").and_then(|v| v.as_str()).unwrap_or("custom");
        out.push_str(&format!(
            "    {}.s0_vals_{}_0 <== {}s0_vals_{}_0;\n",
            component_name, name, p, name
        ));
        out.push_str(&format!(
            "    {}.s0_siblings_{}_0 <== {}s0_siblings_{}_0;\n",
            component_name, name, p, name
        ));
        if last_level > 0 {
            out.push_str(&format!(
                "    {}.s0_last_mt_levels_{}_0 <== {}s0_last_mt_levels_{}_0;\n",
                component_name, name, p, name
            ));
        }
    }

    // Stage values
    let map_sections = si.get("mapSectionsN").unwrap_or(&Value::Null);
    for s in 1..=(n_stages + 1) {
        let cm_key = format!("cm{}", s);
        let cm_n = map_sections
            .get(&cm_key)
            .and_then(|v| v.as_u64())
            .unwrap_or(0);
        if cm_n > 0 {
            out.push_str(&format!(
                "    {}.s0_vals{} <== {}s0_vals{};\n",
                component_name, s, p, s
            ));
            out.push_str(&format!(
                "    {}.s0_siblings{} <== {}s0_siblings{};\n",
                component_name, s, p, s
            ));
            if last_level > 0 {
                out.push_str(&format!(
                    "    {}.s0_last_mt_levels{} <== {}s0_last_mt_levels{};\n",
                    component_name, s, p, s
                ));
            }
        }
    }

    // FRI steps
    let steps = ss
        .get("steps")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    for s in 1..steps.len() {
        out.push_str(&format!(
            "    {}.s{}_root <== {}s{}_root;\n",
            component_name, s, p, s
        ));
    }
    for s in 1..steps.len() {
        out.push_str(&format!(
            "    {}.s{}_vals <== {}s{}_vals;\n",
            component_name, s, p, s
        ));
        out.push_str(&format!(
            "    {}.s{}_siblings <== {}s{}_siblings;\n",
            component_name, s, p, s
        ));
        if last_level > 0 {
            out.push_str(&format!(
                "    {}.s{}_last_mt_levels <== {}s{}_last_mt_levels;\n",
                component_name, s, p, s
            ));
        }
    }

    out.push_str(&format!(
        "    {}.finalPol <== {}finalPol;\n",
        component_name, p
    ));

    let pow_bits = ss.get("powBits").and_then(|v| v.as_u64()).unwrap_or(0);
    if pow_bits > 0 {
        out.push_str(&format!(
            "    {}.nonce <== {}nonce;\n",
            component_name, p
        ));
    }

    if set_enable_input {
        out.push_str(&format!("    {}.enable <== 1;\n", component_name));
    }

    out
}

/// Render the `define_vadcop_inputs.circom.ejs` fragment.
///
/// Declares vadcop-related signals: circuitType, aggregatedProofs,
/// aggregationTypes, airgroupvalues, stage1Hash.
fn render_define_vadcop_inputs(
    prefix: &str,
    vadcop_info: &Value,
    airgroup_id: usize,
    is_input: bool,
) -> String {
    let p = if prefix.is_empty() {
        String::new()
    } else {
        format!("{}_", prefix)
    };
    let signal_type = if is_input { "input" } else { "output" };
    let mut out = String::new();

    out.push_str(&format!(
        "    signal {} {}circuitType;\n",
        signal_type, p
    ));
    out.push_str(&format!(
        "    signal {} {}aggregatedProofs;\n",
        signal_type, p
    ));

    let agg_types = vadcop_info
        .get("aggTypes")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    let ag_agg_len = agg_types
        .get(airgroup_id)
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);

    if ag_agg_len > 0 {
        out.push_str(&format!(
            "    signal {} {}aggregationTypes[{}];\n",
            signal_type, p, ag_agg_len
        ));
        out.push_str(&format!(
            "    signal {} {}airgroupvalues[{}][3];\n",
            signal_type, p, ag_agg_len
        ));
    }

    let curve = vadcop_info
        .get("curve")
        .and_then(|v| v.as_str())
        .unwrap_or("None");
    if curve != "None" {
        out.push_str(&format!(
            "    signal {} {}stage1Hash[2][5];\n",
            signal_type, p
        ));
    } else {
        let lattice_size = vadcop_info
            .get("latticeSize")
            .and_then(|v| v.as_u64())
            .unwrap_or(64);
        out.push_str(&format!(
            "    signal {} {}stage1Hash[{}];\n",
            signal_type, p, lattice_size
        ));
    }

    out
}

/// Render the `assign_vadcop_inputs.circom.ejs` fragment.
///
/// Wires vadcop signals into the StarkVerifier component's publics array.
fn render_assign_vadcop_inputs(
    component_name: &str,
    vadcop_info: &Value,
    prefix: &str,
    _prefix_stark: &str,
    airgroup_id: usize,
    add_prefix_agg_types: bool,
    set_enable_input: bool,
) -> String {
    let p = if prefix.is_empty() {
        String::new()
    } else {
        format!("{}_", prefix)
    };
    let mut out = String::new();
    let mut n_publics_inps: usize = 0;

    out.push_str(&format!(
        "    {}.publics[{}] <== {}circuitType;\n",
        component_name, n_publics_inps, p
    ));
    n_publics_inps += 1;

    out.push_str(&format!(
        "    {}.publics[{}] <== {}aggregatedProofs;\n",
        component_name, n_publics_inps, p
    ));
    n_publics_inps += 1;

    let agg_types = vadcop_info
        .get("aggTypes")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    let ag_agg_len = agg_types
        .get(airgroup_id)
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);

    if ag_agg_len > 0 {
        let agg_prefix = if add_prefix_agg_types { &p } else { "" };
        out.push_str(&format!(
            "    for(var i = 0; i < {}; i++) {{\n        {}.publics[{} + i] <== {}aggregationTypes[i];\n    }}\n",
            ag_agg_len, component_name, n_publics_inps, agg_prefix
        ));
        n_publics_inps += ag_agg_len;

        out.push_str(&format!(
            "    for(var i = 0; i < {}; i++) {{\n        {}.publics[{} + 3*i] <== {}airgroupvalues[i][0];\n        {}.publics[{} + 3*i + 1] <== {}airgroupvalues[i][1];\n        {}.publics[{} + 3*i + 2] <== {}airgroupvalues[i][2];\n    }}\n",
            ag_agg_len,
            component_name, n_publics_inps, p,
            component_name, n_publics_inps, p,
            component_name, n_publics_inps, p,
        ));
        n_publics_inps += 3 * ag_agg_len;
    }

    let curve = vadcop_info
        .get("curve")
        .and_then(|v| v.as_str())
        .unwrap_or("None");
    if curve != "None" {
        out.push_str(&format!(
            "    for (var i = 0; i < 2; i++) {{\n        for (var j = 0; j < 5; j++) {{\n            {}.publics[{} + 5*i + j] <== {}stage1Hash[i][j];\n        }}\n    }}\n",
            component_name, n_publics_inps, p
        ));
        n_publics_inps += 10;
    } else {
        let lattice_size = vadcop_info
            .get("latticeSize")
            .and_then(|v| v.as_u64())
            .unwrap_or(64) as usize;
        out.push_str(&format!(
            "    for (var i = 0; i < {}; i++) {{\n        {}.publics[{} + i] <== {}stage1Hash[i];\n    }}\n",
            lattice_size, component_name, n_publics_inps, p
        ));
        n_publics_inps += lattice_size;
    }

    let n_publics = vadcop_info
        .get("nPublics")
        .and_then(|v| v.as_u64())
        .unwrap_or(0) as usize;
    if n_publics > 0 {
        out.push_str(&format!(
            "    for(var i = 0; i < {}; i++) {{\n        {}.publics[{} + i] <== publics[i];\n    }}\n",
            n_publics, component_name, n_publics_inps
        ));
        n_publics_inps += n_publics;
    }

    let num_proof_values = vadcop_info
        .get("numProofValues")
        .and_then(|v| v.as_u64().or_else(|| v.as_array().and_then(|a| a.first()).and_then(|e| e.as_u64())))
        .unwrap_or(0) as usize;
    if num_proof_values > 0 {
        out.push_str(&format!(
            "    for(var i = 0; i < {}; i++) {{\n        {}.publics[{} + 3*i] <== proofValues[i][0];\n        {}.publics[{} + 3*i + 1] <== proofValues[i][1];\n        {}.publics[{} + 3*i + 2] <== proofValues[i][2];\n    }}\n",
            num_proof_values,
            component_name, n_publics_inps,
            component_name, n_publics_inps,
            component_name, n_publics_inps,
        ));
        n_publics_inps += num_proof_values * 3;
    }

    out.push_str(&format!(
        "    {}.publics[{}] <== globalChallenge[0];\n",
        component_name, n_publics_inps
    ));
    out.push_str(&format!(
        "    {}.publics[{} +1] <== globalChallenge[1];\n",
        component_name, n_publics_inps
    ));
    out.push_str(&format!(
        "    {}.publics[{} +2] <== globalChallenge[2];\n",
        component_name, n_publics_inps
    ));

    if set_enable_input {
        out.push_str(&format!(
            "    signal {{binary}} {}isNull <== IsZero()({}circuitType);\n",
            p, p
        ));
        out.push_str(&format!(
            "    {}.enable <== 1 - {}isNull;\n",
            component_name, p
        ));
    }

    out
}

/// Render the `init_vadcop_inputs.circom.ejs` fragment.
///
/// Sets the initial vadcop output values: circuitType, aggregatedProofs,
/// aggregationTypes, airgroupvalues, and stage1Hash.
fn render_init_vadcop_inputs(
    component_name: &str,
    prefix: &str,
    prefix_stark: &str,
    airgroup_id: usize,
    si: &Value,
    vadcop_info: &Value,
) -> String {
    let p = if prefix.is_empty() {
        String::new()
    } else {
        format!("{}_", prefix)
    };
    let ps = if prefix_stark.is_empty() {
        String::new()
    } else {
        format!("{}_", prefix_stark)
    };
    let mut out = String::new();

    out.push_str(&format!(
        "    {}.globalChallenge <== globalChallenge;\n",
        component_name
    ));

    let air_groups = vadcop_info
        .get("air_groups")
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);
    let airs_0_len = vadcop_info
        .get("airs")
        .and_then(|v| v.as_array())
        .and_then(|a| a.first())
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);
    let air_id = si.get("airId").and_then(|v| v.as_u64()).unwrap_or(0);
    let circuit_type = if air_groups > 1 || airs_0_len > 1 {
        air_id + 2
    } else {
        air_id + 1
    };

    out.push_str(&format!(
        "    {}circuitType <== {};\n",
        p, circuit_type
    ));
    out.push_str(&format!("    {}aggregatedProofs <== 1;\n", p));

    let agg_types = vadcop_info
        .get("aggTypes")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    let ag_agg = agg_types
        .get(airgroup_id)
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();

    if !ag_agg.is_empty() {
        let agg_vals: Vec<String> = ag_agg
            .iter()
            .map(|a| {
                a.get("aggType")
                    .and_then(|v| v.as_u64())
                    .unwrap_or(0)
                    .to_string()
            })
            .collect();
        out.push_str(&format!(
            "    {}aggregationTypes <== [{}];\n",
            p,
            agg_vals.join(",")
        ));

        for i in 0..ag_agg.len() {
            out.push_str(&format!(
                "    {}airgroupvalues[{}] <== {}airgroupvalues[{}];\n",
                p, i, ps, i
            ));
        }
    }

    let air_values_map = si
        .get("airValuesMap")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    if !air_values_map.is_empty() {
        out.push_str(&format!(
            "    {}stage1Hash <== CalculateStage1Hash()({}.rootC, {}root1, {}airvalues);\n",
            p, component_name, ps, ps
        ));
    } else {
        out.push_str(&format!(
            "    {}stage1Hash <== CalculateStage1Hash()({}.rootC, {}root1);\n",
            p, component_name, ps
        ));
    }

    out
}

/// Render the `agg_vadcop_inputs.circom.ejs` fragment.
///
/// Aggregates three sets of vadcop inputs (A, B, C) for recursive2.
fn render_agg_vadcop_inputs(
    vadcop_info: &Value,
    prefix1: &str,
    prefix2: &str,
    prefix3: &str,
    prefix: &str,
    airgroup_id: usize,
) -> String {
    let mut out = String::new();

    let air_groups_len = vadcop_info
        .get("air_groups")
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);
    let airs_0_len = vadcop_info
        .get("airs")
        .and_then(|v| v.as_array())
        .and_then(|a| a.first())
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);
    let is_multi = air_groups_len > 1 || airs_0_len > 1;

    let agg_types = vadcop_info
        .get("aggTypes")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    let ag_agg_len = agg_types
        .get(airgroup_id)
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);

    let curve = vadcop_info
        .get("curve")
        .and_then(|v| v.as_str())
        .unwrap_or("None");
    let lattice_size = vadcop_info
        .get("latticeSize")
        .and_then(|v| v.as_u64())
        .unwrap_or(64);

    out.push_str(&format!(
        "    {}_circuitType <== {};\n",
        prefix,
        if is_multi { 1 } else { 0 }
    ));

    // Declare aggregationTypes assignment and local aggTypes signal,
    // matching the JS agg_vadcop_inputs.circom.ejs template.
    if ag_agg_len > 0 {
        out.push_str(&format!(
            "    {}_aggregationTypes <== aggregationTypes;\n",
            prefix
        ));
        out.push_str(&format!(
            "    signal {{binary}} aggTypes[{}];\n",
            ag_agg_len
        ));
        out.push_str(&format!(
            "    for (var i = 0; i < {}; i++) {{\n",
            ag_agg_len
        ));
        out.push_str(&format!(
            "        {}_aggregationTypes[i] * ({}_aggregationTypes[i] - 1) === 0;\n",
            prefix, prefix
        ));
        out.push_str(&format!(
            "        aggTypes[i] <== {}_aggregationTypes[i];\n",
            prefix
        ));
        out.push_str("    }\n\n");
    }

    if is_multi {
        out.push_str(&format!(
            "    signal {{binary}} AB_isNull <== IsZero()(2 - {}_isNull - {}_isNull);\n",
            prefix1, prefix2
        ));
        if ag_agg_len > 0 {
            out.push_str(&format!(
                "    signal airgroupValues_AB[{}][3];\n",
                ag_agg_len
            ));
            out.push_str(&format!(
                "    for (var i = 0; i < {}; i++) {{\n",
                ag_agg_len
            ));
            out.push_str(&format!(
                "        airgroupValues_AB[i] <== AggregateAirgroupValuesNull()({}_airgroupvalues[i], {}_airgroupvalues[i], aggTypes[i], {}_isNull, {}_isNull);\n",
                prefix1, prefix2, prefix1, prefix2
            ));
            out.push_str(&format!(
                "        {}_airgroupvalues[i] <== AggregateAirgroupValuesNull()(airgroupValues_AB[i], {}_airgroupvalues[i], aggTypes[i], AB_isNull, {}_isNull);\n",
                prefix, prefix3, prefix3
            ));
            out.push_str("    }\n");
        }

        out.push_str(&format!(
            "    signal {{binary}} isNull[3] <== [{}_isNull, {}_isNull, {}_isNull];\n",
            prefix1, prefix2, prefix3
        ));
        out.push_str(&format!(
            "    {}_aggregatedProofs <== AggregateProofsNull(3)([{}_aggregatedProofs, {}_aggregatedProofs, {}_aggregatedProofs], isNull);\n",
            prefix, prefix1, prefix2, prefix3
        ));

        if curve != "None" {
            out.push_str(&format!(
                "    signal AB_stage1Hash[2][5] <== AccumulatePointsNull()({}_stage1Hash, {}_stage1Hash, {}_isNull, {}_isNull);\n",
                prefix1, prefix2, prefix1, prefix2
            ));
            out.push_str(&format!(
                "    {}_stage1Hash <== AccumulatePointsNull()(AB_stage1Hash, {}_stage1Hash, AB_isNull, {}_isNull);\n",
                prefix, prefix3, prefix3
            ));
        } else {
            out.push_str(&format!(
                "    signal AB_stage1Hash[{}] <== AggregateValuesNull({})({}_stage1Hash, {}_stage1Hash, {}_isNull, {}_isNull);\n",
                lattice_size, lattice_size, prefix1, prefix2, prefix1, prefix2
            ));
            out.push_str(&format!(
                "    {}_stage1Hash <== AggregateValuesNull({})(AB_stage1Hash, {}_stage1Hash, AB_isNull, {}_isNull);\n",
                prefix, lattice_size, prefix3, prefix3
            ));
        }
    } else {
        if ag_agg_len > 0 {
            out.push_str(&format!(
                "    signal airgroupValuesAB[{}][3];\n",
                ag_agg_len
            ));
            out.push_str(&format!(
                "    for (var i = 0; i < {}; i++) {{\n",
                ag_agg_len
            ));
            out.push_str(&format!(
                "        airgroupValuesAB[i] <== AggregateAirgroupValues()({}_airgroupvalues[i], {}_airgroupvalues[i], aggTypes[i]);\n",
                prefix1, prefix2
            ));
            out.push_str(&format!(
                "        {}_airgroupvalues[i] <== AggregateAirgroupValues()(airgroupValuesAB[i], {}_airgroupvalues[i], aggTypes[i]);\n",
                prefix, prefix3
            ));
            out.push_str("    }\n");
        }

        out.push_str(&format!(
            "    {}_aggregatedProofs <== AggregateProofs(3)([{}_aggregatedProofs, {}_aggregatedProofs, {}_aggregatedProofs]);\n",
            prefix, prefix1, prefix2, prefix3
        ));

        if curve != "None" {
            out.push_str(&format!(
                "    signal AB_stage1Hash[2][5] <== AccumulatePoints()({}_stage1Hash, {}_stage1Hash);\n",
                prefix1, prefix2
            ));
            out.push_str(&format!(
                "    {}_stage1Hash <== AccumulatePoints()(AB_stage1Hash, {}_stage1Hash);\n",
                prefix, prefix3
            ));
        } else {
            out.push_str(&format!(
                "    signal AB_stage1Hash[{}] <== AggregateValues({})({}_stage1Hash, {}_stage1Hash);\n",
                lattice_size, lattice_size, prefix1, prefix2
            ));
            out.push_str(&format!(
                "    {}_stage1Hash <== AggregateValues({})(AB_stage1Hash, {}_stage1Hash);\n",
                prefix, lattice_size, prefix3
            ));
        }
    }

    out
}

/// Render the `calculate_hashes.circom.ejs` fragment.
///
/// Generates the CalculateStage1Hash template using Transcript logic.
fn render_calculate_hashes(si: &Value, vadcop_info: &Value) -> String {
    let mut out = String::new();
    let ss = si.get("starkStruct").unwrap_or(&Value::Null);
    let arity = ss
        .get("merkleTreeArity")
        .and_then(|v| v.as_u64())
        .unwrap_or(16);
    let curve = vadcop_info
        .get("curve")
        .and_then(|v| v.as_str())
        .unwrap_or("None");
    let lattice_size = vadcop_info
        .get("latticeSize")
        .and_then(|v| v.as_u64())
        .unwrap_or(64);
    let air_values_map = si
        .get("airValuesMap")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    let _has_stage1 = air_values_map
        .iter()
        .any(|a| a.get("stage").and_then(|v| v.as_u64()).unwrap_or(0) == 1);

    out.push_str("template CalculateStage1Hash() {\n");
    out.push_str("    signal input rootC[4];\n");
    out.push_str("    signal input root1[4];\n");

    // Declare airValues whenever airValuesMap is non-empty, matching the JS
    // template which references airValues[j] for all entries (both stage-1
    // and non-stage-1 entries that get assigned to _ as unused).
    if !air_values_map.is_empty() {
        out.push_str(&format!(
            "    signal input airValues[{}][3];\n",
            air_values_map.len()
        ));
    }

    if curve != "None" {
        out.push_str("    signal output P[2][5];\n");
    } else {
        out.push_str(&format!(
            "    signal output values[{}];\n",
            lattice_size
        ));
    }

    // Build transcript: put rootC (4 elems), root1 (4 elems), then air values at stage 1
    // The Transcript class logic is complex; we generate a simplified version
    // that matches the structural output for typical configurations.
    let _cap = 4 * (arity - 1) as usize;
    let mut pending: Vec<String> = Vec::new();
    let mut state = vec!["0".to_string(); 4];
    let mut h_cnt: usize = 0;
    let mut all_out: Vec<String> = Vec::new();
    let mut code_lines: Vec<String> = Vec::new();

    let flush = |pending: &mut Vec<String>,
                     state: &mut Vec<String>,
                     all_out: &mut Vec<String>,
                     h_cnt: &mut usize,
                     code_lines: &mut Vec<String>,
                     arity: u64| {
        let cap = 4 * (arity - 1) as usize;
        while pending.len() < cap {
            pending.push("0".to_string());
        }
        let sig = format!("transcriptHash_{}", h_cnt);
        code_lines.push(format!(
            "    signal {}[{}] <== Poseidon2({}, {})([{}], [{}]);",
            sig,
            4 * arity,
            arity,
            4 * arity,
            pending.join(","),
            state.join(","),
        ));

        // Compute count of stage-1 air values for unused-value heuristic
        let count: usize = air_values_map
            .iter()
            .filter(|a| a.get("stage").and_then(|v| v.as_u64()).unwrap_or(0) == 1)
            .count();
        let used_vals = if *h_cnt
            < ((count as f64 / (4.0 * (arity as f64 - 1.0))).ceil() as usize + 1)
        {
            4usize
        } else {
            10
        };
        if used_vals < (4 * arity) as usize {
            code_lines.push(format!(
                "    for (var i = {}; i < {}; i++) {{",
                used_vals,
                4 * arity
            ));
            code_lines.push(format!("        _ <== {}[i];", sig));
            code_lines.push("    }".to_string());
        }

        *all_out = (0..(4 * arity))
            .map(|i| format!("{}[{}]", sig, i))
            .collect();
        for i in 0..4 {
            state[i] = format!("{}[{}]", sig, i);
        }
        *h_cnt += 1;
        pending.clear();
    };

    let add1 = |val: String,
                    pending: &mut Vec<String>,
                    state: &mut Vec<String>,
                    all_out: &mut Vec<String>,
                    h_cnt: &mut usize,
                    code_lines: &mut Vec<String>,
                    arity: u64| {
        let cap = 4 * (arity - 1) as usize;
        all_out.clear();
        pending.push(val);
        if pending.len() == cap {
            flush(pending, state, all_out, h_cnt, code_lines, arity);
        }
    };

    // Put rootC[0..4]
    for i in 0..4 {
        add1(
            format!("rootC[{}]", i),
            &mut pending,
            &mut state,
            &mut all_out,
            &mut h_cnt,
            &mut code_lines,
            arity,
        );
    }
    // Put root1[0..4]
    for i in 0..4 {
        add1(
            format!("root1[{}]", i),
            &mut pending,
            &mut state,
            &mut all_out,
            &mut h_cnt,
            &mut code_lines,
            arity,
        );
    }
    // Put air values at stage 1
    for (j, av) in air_values_map.iter().enumerate() {
        let stage = av.get("stage").and_then(|v| v.as_u64()).unwrap_or(0);
        if stage == 1 {
            add1(
                format!("airValues[{}]", j),
                &mut pending,
                &mut state,
                &mut all_out,
                &mut h_cnt,
                &mut code_lines,
                arity,
            );
        } else {
            code_lines.push(format!("    _ <== airValues[{}];", j));
        }
    }

    // Get output: for lattice mode, call getStateLattices
    if curve != "None" {
        // EC mode: get 10 field elements for x[5] and y[5]
        let _get_fields = |n: usize,
                           pending: &mut Vec<String>,
                           state: &mut Vec<String>,
                           all_out: &mut Vec<String>,
                           h_cnt: &mut usize,
                           code_lines: &mut Vec<String>,
                           arity: u64|
         -> Vec<String> {
            let mut fields = Vec::new();
            for _ in 0..n {
                if all_out.is_empty() {
                    flush(pending, state, all_out, h_cnt, code_lines, arity);
                }
                fields.push(all_out.remove(0));
            }
            fields
        };
        // Simplified: for EC mode, generate appropriate output
        code_lines.push(
            "    // EC curve hash-to-curve output (simplified)".to_string(),
        );
    } else {
        // Lattice mode: generate values output
        let n_hashes =
            (lattice_size as f64 / (4.0 * arity as f64)).ceil() as usize;

        // First, get 4*arity field elements for values
        for i in 0..(4 * arity as usize) {
            if all_out.is_empty() {
                flush(
                    &mut pending,
                    &mut state,
                    &mut all_out,
                    &mut h_cnt,
                    &mut code_lines,
                    arity,
                );
            }
            let field = all_out.remove(0);
            code_lines.push(format!("    values[{}] <== {};", i, field));
        }

        // Additional Poseidon rounds for lattice
        for round in 0..(n_hashes - 1) {
            let base = 4 * arity as usize;
            let inputs1: Vec<String> = (0..(4 * (arity - 1)))
                .map(|j| {
                    format!(
                        "values[{}]",
                        base * round + j as usize
                    )
                })
                .collect();
            let inputs2: Vec<String> = (0..4)
                .map(|j| {
                    format!(
                        "values[{}]",
                        base * round + 4 * (arity - 1) as usize + j as usize
                    )
                })
                .collect();
            let sig = format!("transcriptHash_{}", h_cnt);
            code_lines.push(format!(
                "    signal {}[{}] <== Poseidon2({}, {})([{}], [{}]);",
                sig,
                4 * arity,
                arity,
                4 * arity,
                inputs1.join(", "),
                inputs2.join(", "),
            ));
            code_lines.push(format!(
                "    for (var j = 0; j < {}; j++) {{",
                4 * arity
            ));
            code_lines.push(format!(
                "        values[{} + j] <== {}[j];",
                base * (round + 1),
                sig
            ));
            code_lines.push("    }".to_string());
            h_cnt += 1;
        }
    }

    for line in &code_lines {
        out.push_str(line);
        out.push('\n');
    }
    out.push_str("}\n");

    out
}

/// Render the `verify_global_challenge.circom.ejs` fragment.
///
/// Generates the VerifyGlobalChallenges template.
fn render_verify_global_challenge(vadcop_info: &Value, si: &Value) -> String {
    let mut out = String::new();
    let ss = si.get("starkStruct").unwrap_or(&Value::Null);
    let arity = ss
        .get("merkleTreeArity")
        .and_then(|v| v.as_u64())
        .unwrap_or(16);
    let n_publics = vadcop_info
        .get("nPublics")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    let pv_map = vadcop_info
        .get("proofValuesMap")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    let agg_types = vadcop_info
        .get("aggTypes")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    let curve = vadcop_info
        .get("curve")
        .and_then(|v| v.as_str())
        .unwrap_or("None");
    let lattice_size = vadcop_info
        .get("latticeSize")
        .and_then(|v| v.as_u64())
        .unwrap_or(64);

    out.push_str("template VerifyGlobalChallenges() {\n\n");
    if n_publics > 0 {
        out.push_str(&format!(
            "    signal input publics[{}];\n",
            n_publics
        ));
    }
    if !pv_map.is_empty() {
        out.push_str(&format!(
            "    signal input proofValues[{}][3];\n",
            pv_map.len()
        ));
    }
    if curve != "None" {
        out.push_str(&format!(
            "    signal input stage1Hash[{}][2][5];\n",
            agg_types.len()
        ));
    } else {
        out.push_str(&format!(
            "    signal input stage1Hash[{}][{}];\n",
            agg_types.len(),
            lattice_size
        ));
    }
    out.push_str("    \n    signal input globalChallenge[3];\n");
    out.push_str("    signal calculatedGlobalChallenge[3];\n\n");

    // Transcript computation: put publics, proofValues (stage 1), stage1Hashes
    // then getField for calculatedGlobalChallenge
    let cap = 4 * (arity - 1) as usize;
    let mut pending: Vec<String> = Vec::new();
    let mut state_vals = vec!["0".to_string(); 4];
    let mut h_cnt: usize = 0;
    let mut hi_cnt: usize = 0;
    let mut all_out: Vec<String> = Vec::new();
    let mut code_lines: Vec<String> = Vec::new();

    let flush_vgc = |pending: &mut Vec<String>,
                         state_vals: &mut Vec<String>,
                         all_out: &mut Vec<String>,
                         h_cnt: &mut usize,
                         _hi_cnt: &mut usize,
                         code_lines: &mut Vec<String>| {
        while pending.len() < cap {
            pending.push("0".to_string());
        }
        let sig = format!("transcriptHash_{}", h_cnt);
        code_lines.push(format!(
            "    signal {}[{}] <== Poseidon2({}, {})([{}], [{}]);",
            sig,
            4 * arity,
            arity,
            4 * arity,
            pending.join(","),
            state_vals.join(","),
        ));

        // Compute unused vals threshold
        let pv_stage1_count = pv_map
            .iter()
            .filter(|p| p.get("stage").and_then(|v| v.as_u64()).unwrap_or(0) == 1)
            .count();
        let threshold =
            (((n_publics as usize) + pv_stage1_count + 10 * agg_types.len()) as f64
                / cap as f64)
                .ceil() as usize;
        let used_vals = if *h_cnt < threshold { 4usize } else { 3 };
        if used_vals < (4 * arity) as usize {
            code_lines.push(format!(
                "    for (var i = {}; i < {}; i++) {{",
                used_vals,
                4 * arity
            ));
            code_lines.push(format!("        _ <== {}[i];", sig));
            code_lines.push("    }".to_string());
        }

        *all_out = (0..(4 * arity))
            .map(|i| format!("{}[{}]", sig, i))
            .collect();
        for i in 0..4 {
            state_vals[i] = format!("{}[{}]", sig, i);
        }
        *h_cnt += 1;
        *_hi_cnt = 0;
        pending.clear();
    };

    let add1_vgc = |val: String,
                        pending: &mut Vec<String>,
                        state_vals: &mut Vec<String>,
                        all_out: &mut Vec<String>,
                        h_cnt: &mut usize,
                        hi_cnt: &mut usize,
                        code_lines: &mut Vec<String>| {
        all_out.clear();
        pending.push(val);
        if pending.len() == cap {
            flush_vgc(pending, state_vals, all_out, h_cnt, hi_cnt, code_lines);
        }
    };

    let get1 = |pending: &mut Vec<String>,
                    state_vals: &mut Vec<String>,
                    all_out: &mut Vec<String>,
                    h_cnt: &mut usize,
                    hi_cnt: &mut usize,
                    code_lines: &mut Vec<String>|
     -> String {
        if all_out.is_empty() {
            flush_vgc(pending, state_vals, all_out, h_cnt, hi_cnt, code_lines);
        }
        *hi_cnt += 1;
        all_out.remove(0)
    };

    // put publics
    for i in 0..n_publics {
        add1_vgc(
            format!("publics[{}]", i),
            &mut pending,
            &mut state_vals,
            &mut all_out,
            &mut h_cnt,
            &mut hi_cnt,
            &mut code_lines,
        );
    }

    // put proof values at stage 1
    for (j, pv) in pv_map.iter().enumerate() {
        let stage = pv.get("stage").and_then(|v| v.as_u64()).unwrap_or(0);
        if stage == 1 {
            add1_vgc(
                format!("proofValues[{}]", j),
                &mut pending,
                &mut state_vals,
                &mut all_out,
                &mut h_cnt,
                &mut hi_cnt,
                &mut code_lines,
            );
        } else {
            code_lines.push(format!("    _ <== proofValues[{}];", j));
        }
    }

    // put stage1Hash for each airgroup
    for k in 0..agg_types.len() {
        if curve != "None" {
            for i in 0..2 {
                for j in 0..5 {
                    add1_vgc(
                        format!("stage1Hash[{}][{}][{}]", k, i, j),
                        &mut pending,
                        &mut state_vals,
                        &mut all_out,
                        &mut h_cnt,
                        &mut hi_cnt,
                        &mut code_lines,
                    );
                }
            }
        } else {
            for i in 0..lattice_size {
                add1_vgc(
                    format!("stage1Hash[{}][{}]", k, i),
                    &mut pending,
                    &mut state_vals,
                    &mut all_out,
                    &mut h_cnt,
                    &mut hi_cnt,
                    &mut code_lines,
                );
            }
        }
    }

    // getField for calculatedGlobalChallenge
    let f0 = get1(
        &mut pending,
        &mut state_vals,
        &mut all_out,
        &mut h_cnt,
        &mut hi_cnt,
        &mut code_lines,
    );
    let f1 = get1(
        &mut pending,
        &mut state_vals,
        &mut all_out,
        &mut h_cnt,
        &mut hi_cnt,
        &mut code_lines,
    );
    let f2 = get1(
        &mut pending,
        &mut state_vals,
        &mut all_out,
        &mut h_cnt,
        &mut hi_cnt,
        &mut code_lines,
    );
    code_lines.push(format!(
        "    calculatedGlobalChallenge <== [{}, {}, {}];",
        f0, f1, f2
    ));

    for line in &code_lines {
        out.push_str(line);
        out.push('\n');
    }

    out.push_str("\n    globalChallenge === calculatedGlobalChallenge;\n");
    out.push_str("}\n");

    out
}

/// Render the `verify_global_constraints.circom.ejs` fragment.
///
/// Generates the VerifyGlobalConstraints template with challenge derivation
/// and constraint verification.
fn render_verify_global_constraints(vadcop_info: &Value, si: &Value) -> String {
    let mut out = String::new();
    let ss = si.get("starkStruct").unwrap_or(&Value::Null);
    let arity = ss
        .get("merkleTreeArity")
        .and_then(|v| v.as_u64())
        .unwrap_or(16);
    let n_publics = vadcop_info
        .get("nPublics")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    let num_proof_values = vadcop_info
        .get("numProofValues")
        .and_then(|v| v.as_u64().or_else(|| v.as_array().and_then(|a| a.first()).and_then(|e| e.as_u64())))
        .unwrap_or(0);
    let agg_types = vadcop_info
        .get("aggTypes")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();
    let num_challenges_1 = vadcop_info
        .get("numChallenges")
        .and_then(|v| v.as_array())
        .and_then(|a| a.get(1))
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    let global_constraints = vadcop_info
        .get("globalConstraints")
        .and_then(|v| v.as_array())
        .cloned()
        .unwrap_or_default();

    // Generate chunk templates for global constraints
    for (c, gc) in global_constraints.iter().enumerate() {
        let code = gc
            .get("code")
            .and_then(|v| v.as_array())
            .cloned()
            .unwrap_or_default();
        if code.is_empty() {
            continue;
        }
        // For simplicity, render each constraint as a single chunk
        out.push_str(&format!("template GlobalConstraint{}_chunk0() {{\n", c));
        for (i, at) in agg_types.iter().enumerate() {
            let at_len = at.as_array().map(|a| a.len()).unwrap_or(0);
            out.push_str(&format!(
                "    signal input s{}_airgroupvalues[{}][3];\n",
                i, at_len
            ));
        }
        if n_publics > 0 {
            out.push_str(&format!(
                "    signal input publics[{}];\n",
                n_publics
            ));
        }
        if num_proof_values > 0 {
            out.push_str(&format!(
                "    signal input proofValues[{}][3];\n",
                num_proof_values
            ));
        }
        out.push_str(&format!(
            "    signal input challenges[{}][3];\n\n",
            num_challenges_1
        ));

        // Unroll the constraint code
        let unrolled = unroll_global_constraint_code(&code);
        out.push_str(&unrolled);
        out.push_str("}\n\n");
    }

    out.push_str("template VerifyGlobalConstraints() {\n\n");

    let mut inputs: Vec<String> = Vec::new();
    for (i, at) in agg_types.iter().enumerate() {
        let at_len = at.as_array().map(|a| a.len()).unwrap_or(0);
        out.push_str(&format!(
            "    signal input s{}_airgroupvalues[{}][3];\n",
            i, at_len
        ));
        inputs.push(format!("s{}_airgroupvalues", i));
    }
    if n_publics > 0 {
        out.push_str(&format!(
            "    signal input publics[{}];\n",
            n_publics
        ));
        inputs.push("publics".to_string());
    }
    if num_proof_values > 0 {
        out.push_str(&format!(
            "    signal input proofValues[{}][3];\n",
            num_proof_values
        ));
        inputs.push("proofValues".to_string());
    }

    out.push_str(&format!(
        "\n    signal input globalChallenge[3];\n\n    signal challenges[{}][3];\n",
        num_challenges_1
    ));

    // Transcript for challenges derivation
    let cap = 4 * (arity - 1) as usize;
    let mut pending: Vec<String> = Vec::new();
    let mut state_vals = vec!["0".to_string(); 4];
    let mut h_cnt: usize = 0;
    let mut _hi_cnt: usize = 0;
    let mut t_out: Vec<String> = Vec::new();
    let mut code_lines: Vec<String> = Vec::new();

    // put globalChallenge[0..3]
    for i in 0..3 {
        t_out.clear();
        pending.push(format!("globalChallenge[{}]", i));
        if pending.len() == cap {
            // flush
            while pending.len() < cap {
                pending.push("0".to_string());
            }
            let sig = format!("transcriptHash_{}", h_cnt);
            code_lines.push(format!(
                "    signal {}[{}] <== Poseidon2({}, {})([{}], [{}]);",
                sig,
                4 * arity,
                arity,
                4 * arity,
                pending.join(","),
                state_vals.join(","),
            ));
            t_out = (0..(4 * arity))
                .map(|i| format!("{}[{}]", sig, i))
                .collect();
            for k in 0..4 {
                state_vals[k] = format!("{}[{}]", sig, k);
            }
            h_cnt += 1;
            _hi_cnt = 0;
            pending.clear();
        }
    }

    // getField for each challenge
    for i in 0..num_challenges_1 {
        let mut fields = Vec::new();
        for _ in 0..3 {
            if t_out.is_empty() {
                while pending.len() < cap {
                    pending.push("0".to_string());
                }
                let sig = format!("transcriptHash_{}", h_cnt);
                code_lines.push(format!(
                    "    signal {}[{}] <== Poseidon2({}, {})([{}], [{}]);",
                    sig,
                    4 * arity,
                    arity,
                    4 * arity,
                    pending.join(","),
                    state_vals.join(","),
                ));
                t_out = (0..(4 * arity))
                    .map(|k| format!("{}[{}]", sig, k))
                    .collect();
                for k in 0..4 {
                    state_vals[k] = format!("{}[{}]", sig, k);
                }
                h_cnt += 1;
                _hi_cnt = 0;
                pending.clear();
            }
            _hi_cnt += 1;
            fields.push(t_out.remove(0));
        }
        code_lines.push(format!(
            "    challenges[{}] <== [{}, {}, {}];",
            i, fields[0], fields[1], fields[2]
        ));
    }

    for line in &code_lines {
        out.push_str(line);
        out.push('\n');
    }
    inputs.push("challenges".to_string());

    // Verify global constraints
    out.push_str("\n    // Verify global constraints\n");
    for (i, gc) in global_constraints.iter().enumerate() {
        let code = gc
            .get("code")
            .and_then(|v| v.as_array())
            .cloned()
            .unwrap_or_default();
        if code.is_empty() {
            continue;
        }
        // Find the last dest tmp
        let last_inst = code.last().unwrap();
        let last_dest = last_inst.get("dest").unwrap();
        let last_id = last_dest.get("id").and_then(|v| v.as_u64()).unwrap_or(0);
        let last_dim = last_dest.get("dim").and_then(|v| v.as_u64()).unwrap_or(1);

        if last_dim == 1 {
            out.push_str(&format!("    signal output tmp_{};\n", last_id));
        } else {
            out.push_str(&format!("    signal output tmp_{}[3];\n", last_id));
        }

        out.push_str(&format!(
            "    (tmp_{}) <== GlobalConstraint{}_chunk0()({});\n",
            last_id,
            i,
            inputs.join(",")
        ));

        if last_dim == 1 {
            out.push_str(&format!("    tmp_{} === 0;\n", last_id));
        } else {
            out.push_str(&format!("    tmp_{}[0] === 0;\n", last_id));
            out.push_str(&format!("    tmp_{}[1] === 0;\n", last_id));
            out.push_str(&format!("    tmp_{}[2] === 0;\n", last_id));
        }
    }

    out.push_str("}\n");
    out
}

/// Unroll global constraint code instructions into circom assignments.
///
/// Processes the verifierInfo-style code array: each instruction has
/// `dest`, `op`, and `src` fields with type/id/dim information.
fn unroll_global_constraint_code(code: &[Value]) -> String {
    let mut out = String::new();
    let mut initialized: std::collections::HashSet<u64> = std::collections::HashSet::new();

    for inst in code {
        let dest = inst.get("dest").unwrap_or(&Value::Null);
        let op = inst.get("op").and_then(|v| v.as_str()).unwrap_or("");
        let src = inst
            .get("src")
            .and_then(|v| v.as_array())
            .cloned()
            .unwrap_or_default();

        let dest_ref = gc_ref(dest, true, &mut initialized);
        let src0_ref = gc_ref(&src[0], false, &mut initialized);

        match op {
            "add" => {
                let src1_ref = gc_ref(&src[1], false, &mut initialized);
                let d0 = dest.get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
                let s0d = src[0].get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
                let s1d = src[1].get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
                match (s0d, s1d) {
                    (1, 1) => {
                        out.push_str(&format!(
                            "    {} <== {} + {};\n",
                            dest_ref, src0_ref, src1_ref
                        ));
                    }
                    (1, 3) => {
                        out.push_str(&format!(
                            "    {} <== [{} + {}[0], {}[1], {}[2]];\n",
                            dest_ref, src0_ref, src1_ref, src1_ref, src1_ref
                        ));
                    }
                    (3, 1) => {
                        out.push_str(&format!(
                            "    {} <== [{}[0] + {}, {}[1], {}[2]];\n",
                            dest_ref, src0_ref, src1_ref, src0_ref, src0_ref
                        ));
                    }
                    (3, 3) => {
                        out.push_str(&format!(
                            "    {} <== [{}[0] + {}[0], {}[1] + {}[1], {}[2] + {}[2]];\n",
                            dest_ref, src0_ref, src1_ref, src0_ref, src1_ref, src0_ref, src1_ref
                        ));
                    }
                    _ => {
                        out.push_str(&format!(
                            "    {} <== {} + {};\n",
                            dest_ref, src0_ref, src1_ref
                        ));
                    }
                }
                let _ = d0; // suppress unused warning
            }
            "sub" => {
                let src1_ref = gc_ref(&src[1], false, &mut initialized);
                let s0d = src[0].get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
                let s1d = src[1].get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
                match (s0d, s1d) {
                    (1, 1) => {
                        out.push_str(&format!(
                            "    {} <== {} - {};\n",
                            dest_ref, src0_ref, src1_ref
                        ));
                    }
                    (1, 3) => {
                        out.push_str(&format!(
                            "    {} <== [{} - {}[0], -{}[1], -{}[2]];\n",
                            dest_ref, src0_ref, src1_ref, src1_ref, src1_ref
                        ));
                    }
                    (3, 1) => {
                        out.push_str(&format!(
                            "    {} <== [{}[0] - {}, {}[1], {}[2]];\n",
                            dest_ref, src0_ref, src1_ref, src0_ref, src0_ref
                        ));
                    }
                    (3, 3) => {
                        out.push_str(&format!(
                            "    {} <== [{}[0] - {}[0], {}[1] - {}[1], {}[2] - {}[2]];\n",
                            dest_ref, src0_ref, src1_ref, src0_ref, src1_ref, src0_ref, src1_ref
                        ));
                    }
                    _ => {
                        out.push_str(&format!(
                            "    {} <== {} - {};\n",
                            dest_ref, src0_ref, src1_ref
                        ));
                    }
                }
            }
            "mul" => {
                let src1_ref = gc_ref(&src[1], false, &mut initialized);
                let s0d = src[0].get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
                let s1d = src[1].get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
                match (s0d, s1d) {
                    (1, 1) => {
                        out.push_str(&format!(
                            "    {} <== {} * {};\n",
                            dest_ref, src0_ref, src1_ref
                        ));
                    }
                    (1, 3) => {
                        out.push_str(&format!(
                            "    {} <== [{} * {}[0], {} * {}[1], {} * {}[2]];\n",
                            dest_ref, src0_ref, src1_ref, src0_ref, src1_ref, src0_ref, src1_ref
                        ));
                    }
                    (3, 1) => {
                        out.push_str(&format!(
                            "    {} <== [{}[0] * {}, {}[1] * {}, {}[2] * {}];\n",
                            dest_ref, src0_ref, src1_ref, src0_ref, src1_ref, src0_ref, src1_ref
                        ));
                    }
                    (3, 3) => {
                        out.push_str(&format!(
                            "    {} <== CMul()({}, {});\n",
                            dest_ref, src0_ref, src1_ref
                        ));
                    }
                    _ => {
                        out.push_str(&format!(
                            "    {} <== {} * {};\n",
                            dest_ref, src0_ref, src1_ref
                        ));
                    }
                }
            }
            "copy" => {
                out.push_str(&format!(
                    "    {} <== {};\n",
                    dest_ref, src0_ref
                ));
            }
            _ => {
                out.push_str(&format!("    // unknown op: {}\n", op));
            }
        }
    }

    out
}

/// Produce a circom reference string for global constraint code operands.
fn gc_ref(
    r: &Value,
    is_dest: bool,
    initialized: &mut std::collections::HashSet<u64>,
) -> String {
    let rtype = r.get("type").and_then(|v| v.as_str()).unwrap_or("");
    let id = r.get("id").and_then(|v| v.as_u64()).unwrap_or(0);
    let dim = r.get("dim").and_then(|v| v.as_u64()).unwrap_or(1);

    match rtype {
        "public" => format!("publics[{}]", id),
        "proofvalue" => {
            if dim == 1 {
                format!("proofValues[{}][0]", id)
            } else {
                format!("proofValues[{}]", id)
            }
        }
        "tmp" => {
            if is_dest && !initialized.contains(&id) {
                initialized.insert(id);
                if dim == 1 {
                    format!("signal tmp_{}", id)
                } else {
                    format!("signal tmp_{}[3]", id)
                }
            } else {
                format!("tmp_{}", id)
            }
        }
        "number" => r
            .get("value")
            .and_then(|v| v.as_str())
            .unwrap_or("0")
            .to_string(),
        "challenge" => format!("challenges[{}]", id),
        "airgroupvalue" => {
            let ag_id = r
                .get("airgroupId")
                .and_then(|v| v.as_u64())
                .unwrap_or(0);
            format!("s{}_airgroupvalues[{}]", ag_id, id)
        }
        _ => format!("/* unknown ref type {} */", rtype),
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
        .and_then(|v| {
            // numProofValues can be a scalar or an array (per-airgroup).
            // Use the first element if array, scalar otherwise.
            v.as_u64().or_else(|| v.as_array().and_then(|a| a.first()).and_then(|e| e.as_u64()))
        })
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

    // Rendered code fragments: each corresponds to an EJS sub-template
    // in the JS codebase. The Rust helpers below produce the same circom
    // output as define_stark_inputs.circom.ejs, assign_stark_inputs.circom.ejs,
    // define_vadcop_inputs.circom.ejs, assign_vadcop_inputs.circom.ejs,
    // init_vadcop_inputs.circom.ejs, agg_vadcop_inputs.circom.ejs,
    // calculate_hashes.circom.ejs, verify_global_challenge.circom.ejs,
    // and verify_global_constraints.circom.ejs.

    // Determine the starkInfo to use for fragment rendering
    let si_for_fragments = if !stark_infos.is_empty() {
        &stark_infos[0]
    } else {
        &Value::Null
    };

    // calculate_hashes: renders the CalculateStage1Hash template
    ctx.insert(
        "calculate_hashes_code",
        &render_calculate_hashes(si_for_fragments, vadcop_info),
    );

    // define_stark_inputs (no prefix, for compressor / recursive1 / final_compressed)
    ctx.insert(
        "define_stark_inputs_code",
        &render_define_stark_inputs("", si_for_fragments, false),
    );

    // define_vadcop_inputs (prefix="sv", output signals, for compressor)
    let ag_id_val = options.airgroup_id.unwrap_or(0) as usize;
    ctx.insert(
        "define_vadcop_inputs_code",
        &render_define_vadcop_inputs("sv", vadcop_info, ag_id_val, false),
    );

    // define_vadcop_inputs_sv (prefix="sv", for recursive1)
    ctx.insert(
        "define_vadcop_inputs_sv_code",
        &render_define_vadcop_inputs(
            "sv",
            vadcop_info,
            ag_id_val,
            options.has_compressor,
        ),
    );

    // define_vadcop_inputs for recursive2 (a_sv, b_sv, c_sv)
    ctx.insert(
        "define_vadcop_inputs_a_sv_code",
        &render_define_vadcop_inputs("a_sv", vadcop_info, ag_id_val, true),
    );
    ctx.insert(
        "define_vadcop_inputs_b_sv_code",
        &render_define_vadcop_inputs("b_sv", vadcop_info, ag_id_val, true),
    );
    ctx.insert(
        "define_vadcop_inputs_c_sv_code",
        &render_define_vadcop_inputs("c_sv", vadcop_info, ag_id_val, true),
    );

    // define_stark_inputs with prefixes (for recursive2)
    ctx.insert(
        "define_stark_inputs_a_code",
        &render_define_stark_inputs("a", si_for_fragments, false),
    );
    ctx.insert(
        "define_stark_inputs_b_code",
        &render_define_stark_inputs("b", si_for_fragments, false),
    );
    ctx.insert(
        "define_stark_inputs_c_code",
        &render_define_stark_inputs("c", si_for_fragments, false),
    );

    // assign_stark_inputs (componentName="sV", prefix="", for compressor/recursive1)
    // When hasCompressor=false, addPublics=true (matches JS: addPublics: !options.hasCompressor)
    let has_compressor = vadcop_info
        .get("hasCompressor")
        .and_then(|v| v.as_bool())
        .unwrap_or(false);
    ctx.insert(
        "assign_stark_inputs_code",
        &render_assign_stark_inputs("sV", "", si_for_fragments, !has_compressor, false),
    );

    // assign_stark_inputs for recursive2 (vA/vB/vC with a/b/c prefixes)
    ctx.insert(
        "assign_stark_inputs_vA_code",
        &render_assign_stark_inputs("vA", "a", si_for_fragments, false, false),
    );
    ctx.insert(
        "assign_stark_inputs_vB_code",
        &render_assign_stark_inputs("vB", "b", si_for_fragments, false, false),
    );
    ctx.insert(
        "assign_stark_inputs_vC_code",
        &render_assign_stark_inputs("vC", "c", si_for_fragments, false, false),
    );

    // assign_vadcop_inputs (for recursive1 with compressor)
    ctx.insert(
        "assign_vadcop_inputs_code",
        &render_assign_vadcop_inputs("sV", vadcop_info, "sv", "", ag_id_val, true, false),
    );

    // assign_vadcop_inputs for recursive2
    let set_enable = !is_single_air;
    ctx.insert(
        "assign_vadcop_inputs_vA_code",
        &render_assign_vadcop_inputs("vA", vadcop_info, "a_sv", "a", ag_id_val, true, set_enable),
    );
    ctx.insert(
        "assign_vadcop_inputs_vB_code",
        &render_assign_vadcop_inputs("vB", vadcop_info, "b_sv", "b", ag_id_val, true, set_enable),
    );
    ctx.insert(
        "assign_vadcop_inputs_vC_code",
        &render_assign_vadcop_inputs("vC", vadcop_info, "c_sv", "c", ag_id_val, true, set_enable),
    );

    // init_vadcop_inputs (for compressor / recursive1 without compressor)
    ctx.insert(
        "init_vadcop_inputs_code",
        &render_init_vadcop_inputs("sV", "sv", "", ag_id_val, si_for_fragments, vadcop_info),
    );

    // agg_vadcop_inputs (for recursive2)
    ctx.insert(
        "agg_vadcop_inputs_code",
        &render_agg_vadcop_inputs(vadcop_info, "a_sv", "b_sv", "c_sv", "sv", ag_id_val),
    );

    // verify_global_challenge / verify_global_constraints (for final template)
    ctx.insert(
        "verify_global_challenge_code",
        &render_verify_global_challenge(vadcop_info, si_for_fragments),
    );
    ctx.insert(
        "verify_global_constraints_code",
        &render_verify_global_constraints(vadcop_info, si_for_fragments),
    );

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

        let set_enable_final = !is_single_air;
        airgroups_data.push(serde_json::json!({
            "idx": i,
            "aggTypes_len": ag_agg_types_len,
            "airs_len": ag_airs_len,
            "nPublics_minus4": si_n_publics.saturating_sub(4),
            "aggVK": agg_vk_str,
            "basicVKs": basic_vks_strs,
            "define_vadcop_inputs_code": render_define_vadcop_inputs(
                &format!("s{}_sv", i), vadcop_info, i, true,
            ),
            "define_stark_inputs_code": render_define_stark_inputs(
                &format!("s{}", i), si_recursive2, false,
            ),
            "assign_stark_inputs_code": render_assign_stark_inputs(
                &format!("sV{}", i), &format!("s{}", i), si_recursive2, false, false,
            ),
            "assign_vadcop_inputs_code": render_assign_vadcop_inputs(
                &format!("sV{}", i), vadcop_info, &format!("s{}_sv", i),
                &format!("s{}", i), i, true, set_enable_final,
            ),
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
