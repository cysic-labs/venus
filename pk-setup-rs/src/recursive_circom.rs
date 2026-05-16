use std::collections::{BTreeMap, BTreeSet};

use serde::Deserialize;

use crate::stark_struct::StarkStruct;

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

#[allow(dead_code)]
pub fn render_define_stark_inputs(
    stark_info: &CircomStarkInfo,
    prefix: &str,
    n_publics: usize,
    options: StarkInputOptions,
) -> String {
    assert_eq!(
        stark_info.stark_struct.verification_hash_type, "GL",
        "only Goldilocks recursive Circom generation is supported"
    );
    let prefix = prefixed(prefix);
    let mut out = String::new();

    if options.add_publics && n_publics > 0 {
        line(&mut out, format_args!("    signal input {prefix}publics[{n_publics}];"));
    }
    if !stark_info.airgroup_values_map.is_empty() {
        line(
            &mut out,
            format_args!(
                "    signal input {prefix}airgroupvalues[{}][3];",
                stark_info.airgroup_values_map.len()
            ),
        );
    }
    if !stark_info.air_values_map.is_empty() {
        line(
            &mut out,
            format_args!("    signal input {prefix}airvalues[{}][3];", stark_info.air_values_map.len()),
        );
    }
    for stage in 1..=stark_info.n_stages + 1 {
        line(&mut out, format_args!("    signal input {prefix}root{stage}[4];"));
    }
    line(
        &mut out,
        format_args!("    signal input {prefix}evals[{}][3];", stark_info.ev_map.len()),
    );
    line(
        &mut out,
        format_args!(
            "    signal input {prefix}s0_valsC[{}][{}];",
            stark_info.n_queries(),
            stark_info.n_constants
        ),
    );
    line(
        &mut out,
        format_args!(
            "    signal input {prefix}s0_siblingsC[{}][{}][{}];",
            stark_info.n_queries(),
            stark_info.s0_sibling_levels(),
            stark_info.sibling_width()
        ),
    );
    if stark_info.stark_struct.last_level_verification > 0 {
        line(
            &mut out,
            format_args!(
                "    signal input {prefix}s0_last_mt_levelsC[{}][4];",
                stark_info.last_level_size()
            ),
        );
    }

    for custom in &stark_info.custom_commits {
        let width = custom.stage_widths.first().copied().unwrap_or_default();
        line(
            &mut out,
            format_args!(
                "    signal input {prefix}s0_vals_{}_0[{}][{}];",
                custom.name,
                stark_info.n_queries(),
                width
            ),
        );
        line(
            &mut out,
            format_args!(
                "    signal input {prefix}s0_siblings_{}_0[{}][{}][{}];",
                custom.name,
                stark_info.n_queries(),
                stark_info.s0_sibling_levels(),
                stark_info.sibling_width()
            ),
        );
        if stark_info.stark_struct.last_level_verification > 0 {
            line(
                &mut out,
                format_args!(
                    "    signal input {prefix}s0_last_mt_levels_{}_0[{}][4];",
                    custom.name,
                    stark_info.last_level_size()
                ),
            );
        }
    }

    for stage in 1..=stark_info.n_stages + 1 {
        let width = stark_info.map_section_width(&format!("cm{stage}"));
        if width == 0 {
            continue;
        }
        line(
            &mut out,
            format_args!(
                "    signal input {prefix}s0_vals{stage}[{}][{}];",
                stark_info.n_queries(),
                width
            ),
        );
        line(
            &mut out,
            format_args!(
                "    signal input {prefix}s0_siblings{stage}[{}][{}][{}];",
                stark_info.n_queries(),
                stark_info.s0_sibling_levels(),
                stark_info.sibling_width()
            ),
        );
        if stark_info.stark_struct.last_level_verification > 0 {
            line(
                &mut out,
                format_args!(
                    "    signal input {prefix}s0_last_mt_levels{stage}[{}][4];",
                    stark_info.last_level_size()
                ),
            );
        }
    }

    for step in 1..stark_info.stark_struct.steps.len() {
        line(&mut out, format_args!("    signal input {prefix}s{step}_root[4];"));
    }
    for step in 1..stark_info.stark_struct.steps.len() {
        let vals_width = (1u64
            << (stark_info.stark_struct.steps[step - 1].n_bits
                - stark_info.stark_struct.steps[step].n_bits))
            * 3;
        line(
            &mut out,
            format_args!(
                "    signal input {prefix}s{step}_vals[{}][{vals_width}];",
                stark_info.n_queries()
            ),
        );
        line(
            &mut out,
            format_args!(
                "    signal input {prefix}s{step}_siblings[{}][{}][{}];",
                stark_info.n_queries(),
                stark_info.step_sibling_levels(step),
                stark_info.sibling_width()
            ),
        );
        if stark_info.stark_struct.last_level_verification > 0 {
            line(
                &mut out,
                format_args!(
                    "    signal input {prefix}s{step}_last_mt_levels[{}][4];",
                    stark_info.last_level_size()
                ),
            );
        }
    }
    let last_step_bits = stark_info.stark_struct.steps.last().map(|s| s.n_bits).unwrap_or(0);
    line(
        &mut out,
        format_args!("    signal input {prefix}finalPol[{}][3];", 1u64 << last_step_bits),
    );
    if stark_info.stark_struct.pow_bits > 0 {
        line(&mut out, format_args!("    signal input {prefix}nonce;"));
    }

    out
}

#[allow(dead_code)]
pub fn render_assign_stark_inputs(
    component_name: &str,
    stark_info: &CircomStarkInfo,
    prefix: &str,
    n_publics: usize,
    options: StarkInputOptions,
) -> String {
    let prefix = prefixed(prefix);
    let mut out = String::new();
    let verifier_name = if !options.final_verifier {
        stark_info
            .airgroup_id
            .map(|id| format!("StarkVerifier{id}"))
            .unwrap_or_else(|| "StarkVerifier".to_string())
    } else {
        "StarkVerifier".to_string()
    };
    line(&mut out, format_args!("    component {component_name} = {verifier_name}();"));
    if options.add_publics && n_publics > 0 {
        line(&mut out, format_args!("    for (var i=0; i< {n_publics}; i++) {{"));
        line(
            &mut out,
            format_args!("        {component_name}.publics[i] <== {prefix}publics[i];"),
        );
        line(&mut out, format_args!("    }}"));
    }
    if !stark_info.airgroup_values_map.is_empty() {
        line(
            &mut out,
            format_args!("    {component_name}.airgroupvalues <== {prefix}airgroupvalues;"),
        );
    }
    if !stark_info.air_values_map.is_empty() {
        line(&mut out, format_args!("    {component_name}.airvalues <== {prefix}airvalues;"));
    }
    if !stark_info.proof_values_map.is_empty() {
        line(&mut out, format_args!("    {component_name}.proofvalues <== proofValues;"));
    }
    for stage in 1..=stark_info.n_stages + 1 {
        line(&mut out, format_args!("    {component_name}.root{stage} <== {prefix}root{stage};"));
    }
    line(&mut out, format_args!("    {component_name}.evals <== {prefix}evals;"));
    line(&mut out, format_args!("    {component_name}.s0_valsC <== {prefix}s0_valsC;"));
    line(
        &mut out,
        format_args!("    {component_name}.s0_siblingsC <== {prefix}s0_siblingsC;"),
    );
    if stark_info.stark_struct.last_level_verification > 0 {
        line(
            &mut out,
            format_args!("    {component_name}.s0_last_mt_levelsC <== {prefix}s0_last_mt_levelsC;"),
        );
    }
    for custom in &stark_info.custom_commits {
        line(
            &mut out,
            format_args!(
                "    {component_name}.s0_vals_{}_0 <== {prefix}s0_vals_{}_0;",
                custom.name, custom.name
            ),
        );
        line(
            &mut out,
            format_args!(
                "    {component_name}.s0_siblings_{}_0 <== {prefix}s0_siblings_{}_0;",
                custom.name, custom.name
            ),
        );
        if stark_info.stark_struct.last_level_verification > 0 {
            line(
                &mut out,
                format_args!(
                    "    {component_name}.s0_last_mt_levels_{}_0 <== {prefix}s0_last_mt_levels_{}_0;",
                    custom.name, custom.name
                ),
            );
        }
    }
    for stage in 1..=stark_info.n_stages + 1 {
        if stark_info.map_section_width(&format!("cm{stage}")) == 0 {
            continue;
        }
        line(&mut out, format_args!("    {component_name}.s0_vals{stage} <== {prefix}s0_vals{stage};"));
        line(
            &mut out,
            format_args!("    {component_name}.s0_siblings{stage} <== {prefix}s0_siblings{stage};"),
        );
        if stark_info.stark_struct.last_level_verification > 0 {
            line(
                &mut out,
                format_args!(
                    "    {component_name}.s0_last_mt_levels{stage} <== {prefix}s0_last_mt_levels{stage};"
                ),
            );
        }
    }
    for step in 1..stark_info.stark_struct.steps.len() {
        line(&mut out, format_args!("    {component_name}.s{step}_root <== {prefix}s{step}_root;"));
        line(&mut out, format_args!("    {component_name}.s{step}_vals <== {prefix}s{step}_vals;"));
        line(
            &mut out,
            format_args!("    {component_name}.s{step}_siblings <== {prefix}s{step}_siblings;"),
        );
        if stark_info.stark_struct.last_level_verification > 0 {
            line(
                &mut out,
                format_args!(
                    "    {component_name}.s{step}_last_mt_levels <== {prefix}s{step}_last_mt_levels;"
                ),
            );
        }
    }
    line(&mut out, format_args!("    {component_name}.finalPol <== {prefix}finalPol;"));
    if stark_info.stark_struct.pow_bits > 0 {
        line(&mut out, format_args!("    {component_name}.nonce <== {prefix}nonce;"));
    }
    if let Some(enable) = options.set_enable_input {
        line(&mut out, format_args!("    {component_name}.enable <== {enable};"));
    }
    out
}

#[allow(dead_code)]
pub fn render_define_vadcop_inputs(
    vadcop_info: &CircomVadcopInfo,
    airgroup_id: usize,
    prefix: &str,
    is_input: bool,
) -> String {
    let signal_type = if is_input { "input" } else { "output" };
    let prefix = prefixed(prefix);
    let agg_types = vadcop_info.agg_types.get(airgroup_id).map(Vec::as_slice).unwrap_or(&[]);
    let mut out = String::new();
    line(&mut out, format_args!("    signal {signal_type} {prefix}circuitType;"));
    line(&mut out, format_args!("    signal {signal_type} {prefix}aggregatedProofs;"));
    if !agg_types.is_empty() {
        line(
            &mut out,
            format_args!("    signal {signal_type} {prefix}aggregationTypes[{}];", agg_types.len()),
        );
        line(
            &mut out,
            format_args!("    signal {signal_type} {prefix}airgroupvalues[{}][3];", agg_types.len()),
        );
    }
    if vadcop_info.curve == "None" {
        line(
            &mut out,
            format_args!("    signal {signal_type} {prefix}stage1Hash[{}];", vadcop_info.lattice_size),
        );
    } else {
        line(&mut out, format_args!("    signal {signal_type} {prefix}stage1Hash[2][5];"));
    }
    out
}

#[derive(Debug, Clone, PartialEq, Eq)]
#[allow(dead_code)]
pub struct ExpressionChunks {
    pub chunks: Vec<ExpressionChunk>,
    pub tmps: BTreeMap<u64, TmpInfo>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
#[allow(dead_code)]
pub struct ExpressionChunk {
    pub code: Vec<CircomCodeLine>,
    pub inputs: Vec<u64>,
    pub outputs: Vec<u64>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[allow(dead_code)]
pub struct TmpInfo {
    pub last_pos: usize,
    pub dim: u64,
}

#[allow(dead_code)]
pub fn build_expression_chunks(code: &[CircomCodeLine], min_chunk_size: usize) -> ExpressionChunks {
    let mut tmps = BTreeMap::<u64, TmpInfo>::new();
    for (idx, inst) in code.iter().enumerate() {
        if inst.dest.ref_type == "tmp" {
            if let Some(id) = inst.dest.id {
                tmps.insert(id, TmpInfo { last_pos: idx, dim: inst.dest.dim });
            }
        }
        for src in &inst.src {
            if src.ref_type == "tmp" {
                if let Some(id) = src.id {
                    if let Some(tmp) = tmps.get_mut(&id) {
                        tmp.last_pos = idx;
                    }
                }
            }
        }
    }

    let mut chunks = Vec::new();
    let mut current = Vec::new();
    let mut live_tmps = BTreeSet::<u64>::new();
    let mut previous_live_tmps = BTreeSet::<u64>::new();
    let mut inputs = BTreeSet::<u64>::new();
    let mut outputs = BTreeSet::<u64>::new();

    for (idx, inst) in code.iter().enumerate() {
        current.push(inst.clone());
        if inst.dest.ref_type == "tmp" {
            if let Some(id) = inst.dest.id {
                live_tmps.insert(id);
                outputs.insert(id);
            }
        }
        for src in &inst.src {
            if src.ref_type != "tmp" {
                continue;
            }
            let Some(id) = src.id else {
                continue;
            };
            let is_last = tmps.get(&id).map(|tmp| tmp.last_pos == idx).unwrap_or(false);
            if is_last {
                live_tmps.remove(&id);
                outputs.remove(&id);
            }
            if previous_live_tmps.contains(&id) {
                inputs.insert(id);
                if is_last {
                    previous_live_tmps.remove(&id);
                }
            }
        }

        if current.len() + 1 >= min_chunk_size {
            chunks.push(ExpressionChunk {
                code: std::mem::take(&mut current),
                inputs: inputs.iter().copied().collect(),
                outputs: outputs.iter().copied().collect(),
            });
            previous_live_tmps.extend(live_tmps.iter().copied());
            live_tmps.clear();
            inputs.clear();
            outputs.clear();
        }
    }
    if !current.is_empty() {
        chunks.push(ExpressionChunk {
            code: current,
            inputs: inputs.iter().copied().collect(),
            outputs: outputs.iter().copied().collect(),
        });
    }

    ExpressionChunks { chunks, tmps }
}

#[allow(dead_code)]
pub fn render_unrolled_code(
    stark_info: &CircomStarkInfo,
    code: &[CircomCodeLine],
    initialized: &[u64],
) -> String {
    let initialized = initialized.iter().copied().collect::<BTreeSet<_>>();
    let mut out = String::new();
    for inst in code {
        let dest = render_ref(stark_info, &inst.dest, true, &initialized);
        let lhs = inst.src.first().expect("missing first source");
        let rhs = inst.src.get(1);
        let lhs_dim = ref_dim(lhs);
        let rhs_dim = rhs.map(ref_dim);
        match inst.op.as_str() {
            "add" => render_binary_op(&mut out, "+", &dest, stark_info, lhs, rhs.expect("missing rhs"), lhs_dim, rhs_dim.unwrap()),
            "sub" => render_sub(&mut out, &dest, stark_info, lhs, rhs.expect("missing rhs"), lhs_dim, rhs_dim.unwrap()),
            "mul" => render_mul(&mut out, &dest, stark_info, lhs, rhs.expect("missing rhs"), lhs_dim, rhs_dim.unwrap()),
            "copy" => {
                line(
                    &mut out,
                    format_args!("    {dest} <== {};", render_ref(stark_info, lhs, false, &initialized)),
                );
            }
            op => panic!("unsupported verifier instruction op {op}"),
        }
    }
    out
}

fn render_binary_op(
    out: &mut String,
    op: &str,
    dest: &str,
    stark_info: &CircomStarkInfo,
    lhs: &CircomCodeRef,
    rhs: &CircomCodeRef,
    lhs_dim: u64,
    rhs_dim: u64,
) {
    let lhs = render_ref(stark_info, lhs, false, &BTreeSet::new());
    let rhs = render_ref(stark_info, rhs, false, &BTreeSet::new());
    match (lhs_dim, rhs_dim) {
        (1, 1) => line(out, format_args!("    {dest} <== {lhs} {op} {rhs};")),
        (1, 3) if op == "+" => {
            line(out, format_args!("    {dest} <== [{lhs} + {rhs}[0], {rhs}[1],  {rhs}[2]];"))
        }
        (3, 1) if op == "+" => {
            line(out, format_args!("    {dest} <== [{lhs}[0] + {rhs}, {lhs}[1], {lhs}[2]];"))
        }
        (3, 3) => line(
            out,
            format_args!(
                "    {dest} <== [{lhs}[0] {op} {rhs}[0], {lhs}[1] {op} {rhs}[1], {lhs}[2] {op} {rhs}[2]];"
            ),
        ),
        _ => panic!("unsupported dimensions {lhs_dim}, {rhs_dim}"),
    }
}

fn render_sub(
    out: &mut String,
    dest: &str,
    stark_info: &CircomStarkInfo,
    lhs: &CircomCodeRef,
    rhs: &CircomCodeRef,
    lhs_dim: u64,
    rhs_dim: u64,
) {
    let lhs_ref = render_ref(stark_info, lhs, false, &BTreeSet::new());
    let rhs_ref = render_ref(stark_info, rhs, false, &BTreeSet::new());
    match (lhs_dim, rhs_dim) {
        (1, 1) => line(out, format_args!("    {dest} <== {lhs_ref} - {rhs_ref};")),
        (1, 3) => line(
            out,
            format_args!("    {dest} <== [{lhs_ref} - {rhs_ref}[0], -{rhs_ref}[1], -{rhs_ref}[2]];"),
        ),
        (3, 1) => line(
            out,
            format_args!("    {dest} <== [{lhs_ref}[0] - {rhs_ref}, {lhs_ref}[1], {lhs_ref}[2]];"),
        ),
        (3, 3) => line(
            out,
            format_args!(
                "    {dest} <== [{lhs_ref}[0] - {rhs_ref}[0], {lhs_ref}[1] - {rhs_ref}[1], {lhs_ref}[2] - {rhs_ref}[2]];"
            ),
        ),
        _ => panic!("unsupported subtraction dimensions {lhs_dim}, {rhs_dim}"),
    }
}

fn render_mul(
    out: &mut String,
    dest: &str,
    stark_info: &CircomStarkInfo,
    lhs: &CircomCodeRef,
    rhs: &CircomCodeRef,
    lhs_dim: u64,
    rhs_dim: u64,
) {
    let lhs_ref = render_ref(stark_info, lhs, false, &BTreeSet::new());
    let rhs_ref = render_ref(stark_info, rhs, false, &BTreeSet::new());
    match (lhs_dim, rhs_dim) {
        (1, 1) => line(out, format_args!("    {dest} <== {lhs_ref} * {rhs_ref};")),
        (1, 3) => line(
            out,
            format_args!("    {dest} <== [{lhs_ref} * {rhs_ref}[0], {lhs_ref} * {rhs_ref}[1], {lhs_ref} * {rhs_ref}[2]];"),
        ),
        (3, 1) => line(
            out,
            format_args!("    {dest} <== [{lhs_ref}[0] * {rhs_ref}, {lhs_ref}[1] * {rhs_ref}, {lhs_ref}[2] * {rhs_ref}];"),
        ),
        (3, 3) => line(out, format_args!("    {dest} <== CMul()({lhs_ref}, {rhs_ref});")),
        _ => panic!("unsupported multiplication dimensions {lhs_dim}, {rhs_dim}"),
    }
}

fn render_ref(
    stark_info: &CircomStarkInfo,
    reference: &CircomCodeRef,
    dest: bool,
    initialized: &BTreeSet<u64>,
) -> String {
    match reference.ref_type.as_str() {
        "eval" => format!("evals[{}]", reference.id.expect("eval id")),
        "challenge" => {
            let stage = reference.stage.expect("challenge stage");
            let stage_id = reference.stage_id.expect("challenge stageId");
            let q_stage = stark_info.n_stages as u64 + 1;
            let evals_stage = stark_info.n_stages as u64 + 2;
            let fri_stage = stark_info.n_stages as u64 + 3;
            if stage == q_stage {
                "challengeQ".to_string()
            } else if stage == evals_stage {
                "challengeXi".to_string()
            } else if stage == fri_stage {
                format!("challengesFRI[{stage_id}]")
            } else {
                format!("challengesStage{stage}[{stage_id}]")
            }
        }
        "public" => format!("publics[{}]", reference.id.expect("public id")),
        "x" => "challengeXi".to_string(),
        "Zi" => {
            let boundary = &stark_info.boundaries[reference.boundary_id.expect("boundary id") as usize];
            match boundary.name.as_str() {
                "everyRow" => "Zh".to_string(),
                "firstRow" => "Zfirst".to_string(),
                "lastRow" => "Zlast".to_string(),
                "everyFrame" => {
                    let offset_min = boundary.offset_min.unwrap_or(0);
                    let offset_max = boundary.offset_max.unwrap_or(0);
                    let boundary_id = stark_info
                        .boundaries
                        .iter()
                        .filter(|boundary| boundary.name == "everyFrame")
                        .position(|candidate| {
                            candidate.offset_min.unwrap_or(0) == offset_min
                                && candidate.offset_max.unwrap_or(0) == offset_max
                        })
                        .expect("frame boundary");
                    format!("Zframe{boundary_id}[{}]", offset_min + offset_max - 1)
                }
                other => panic!("unsupported boundary {other}"),
            }
        }
        "xDivXSubXi" => format!("xDivXSubXi[{}]", reference.id.expect("xDivXSubXi id")),
        "tmp" => {
            let id = reference.id.expect("tmp id");
            if dest && !initialized.contains(&id) {
                if reference.dim == 1 {
                    format!("signal tmp_{id}")
                } else {
                    format!("signal tmp_{id}[3]")
                }
            } else {
                format!("tmp_{id}")
            }
        }
        "cm" => {
            let pol = &stark_info.cm_pols_map[reference.id.expect("cm id") as usize];
            format!("mapValues.cm{}_{}", pol.stage, pol.stage_id.expect("cm stageId"))
        }
        "custom" => {
            let commit_id = reference.commit_id.expect("custom commit id") as usize;
            let pol = &stark_info.custom_commits_map[commit_id][reference.id.expect("custom id") as usize];
            format!(
                "mapValues.custom_{}_{}_{}",
                stark_info.custom_commits[commit_id].name,
                pol.stage,
                pol.stage_id.expect("custom stageId")
            )
        }
        "const" => format!("consts[{}]", reference.id.expect("const id")),
        "number" => reference.value.clone().expect("number value"),
        "airgroupvalue" => format!("airgroupvalues[{}]", reference.id.expect("airgroupvalue id")),
        "airvalue" => {
            if reference.dim == 1 {
                format!("airvalues[{}][0]", reference.id.expect("airvalue id"))
            } else {
                format!("airvalues[{}]", reference.id.expect("airvalue id"))
            }
        }
        "proofvalue" => {
            if reference.dim == 1 {
                format!("proofvalues[{}][0]", reference.id.expect("proofvalue id"))
            } else {
                format!("proofvalues[{}]", reference.id.expect("proofvalue id"))
            }
        }
        other => panic!("unsupported verifier reference {other}"),
    }
}

fn ref_dim(reference: &CircomCodeRef) -> u64 {
    if reference.ref_type == "Zi" || reference.ref_type == "airgroupvalue" {
        3
    } else {
        reference.dim
    }
}

impl CircomStarkInfo {
    fn n_queries(&self) -> u64 {
        self.stark_struct.n_queries.unwrap_or(0)
    }

    fn map_section_width(&self, key: &str) -> u64 {
        self.map_sections_n.get(key).copied().unwrap_or(0)
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
        ceil_div(n_bits, self.arity_bits()).saturating_sub(self.stark_struct.last_level_verification)
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

fn line(out: &mut String, args: std::fmt::Arguments<'_>) {
    use std::fmt::Write;
    let _ = out.write_fmt(args);
    out.push('\n');
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::stark_struct::StarkStep;

    #[test]
    fn renders_gl_stark_input_declarations() {
        let stark = sample_stark_info();
        let out =
            render_define_stark_inputs(&stark, "a", stark.n_publics, StarkInputOptions { add_publics: true, ..Default::default() });

        assert!(out.contains("signal input a_publics[2];"));
        assert!(out.contains("signal input a_root1[4];"));
        assert!(out.contains("signal input a_s0_siblingsC[3][2][12];"));
        assert!(out.contains("signal input a_s1_vals[3][24];"));
        assert!(out.contains("signal input a_nonce;"));
    }

    #[test]
    fn renders_vadcop_input_declarations() {
        let vadcop = CircomVadcopInfo {
            name: "zisk".to_string(),
            airs: vec![vec![CircomVadcopAir { name: "Main".to_string(), num_rows: 8, has_compressor: None }]],
            air_groups: vec!["Zisk".to_string()],
            agg_types: vec![vec![CircomAggType { agg_type: 1, stage: 2 }]],
            curve: "None".to_string(),
            lattice_size: 368,
            n_publics: 2,
            proof_values_map: Vec::new(),
        };
        let out = render_define_vadcop_inputs(&vadcop, 0, "sv", true);

        assert!(out.contains("signal input sv_circuitType;"));
        assert!(out.contains("signal input sv_aggregationTypes[1];"));
        assert!(out.contains("signal input sv_stage1Hash[368];"));
    }

    #[test]
    fn chunks_and_unrolls_verifier_code() {
        let mut stark = sample_stark_info();
        stark.cm_pols_map = vec![CircomPolMap {
            name: "a".to_string(),
            stage: 1,
            dim: 1,
            stage_id: Some(0),
            stage_pos: Some(0),
        }];
        let code = vec![
            CircomCodeLine {
                op: "add".to_string(),
                dest: tmp_ref(0, 1),
                src: vec![number_ref("7"), cm_ref(0, 1)],
            },
            CircomCodeLine {
                op: "mul".to_string(),
                dest: tmp_ref(1, 3),
                src: vec![tmp_ref(0, 1), challenge_ref(1, 0)],
            },
            CircomCodeLine {
                op: "copy".to_string(),
                dest: tmp_ref(2, 3),
                src: vec![tmp_ref(1, 3)],
            },
        ];

        let chunks = build_expression_chunks(&code, 3);
        assert_eq!(chunks.chunks.len(), 2);
        assert_eq!(chunks.chunks[1].inputs, vec![1]);
        assert_eq!(chunks.tmps[&1].dim, 3);

        let rendered = render_unrolled_code(&stark, &chunks.chunks[0].code, &[]);
        assert!(rendered.contains("signal tmp_0 <== 7 + mapValues.cm1_0;"));
        assert!(rendered.contains("signal tmp_1[3] <== [tmp_0 * challengesStage1[0][0]"));

        let rendered_second = render_unrolled_code(&stark, &chunks.chunks[1].code, &[1]);
        assert!(rendered_second.contains("signal tmp_2[3] <== tmp_1;"));
    }

    fn sample_stark_info() -> CircomStarkInfo {
        let stark_struct = StarkStruct {
            n_bits: 5,
            n_bits_ext: 8,
            verification_hash_type: "GL".to_string(),
            merkle_tree_arity: 4,
            transcript_arity: 4,
            merkle_tree_custom: true,
            last_level_verification: 2,
            pow_bits: 16,
            hash_commits: true,
            steps: vec![StarkStep { n_bits: 8 }, StarkStep { n_bits: 5 }],
            n_queries: Some(3),
        };
        let mut map_sections_n = BTreeMap::new();
        map_sections_n.insert("cm1".to_string(), 4);
        map_sections_n.insert("cm2".to_string(), 0);
        CircomStarkInfo {
            name: "Test".to_string(),
            airgroup_id: Some(0),
            air_id: Some(0),
            stark_struct,
            n_publics: 2,
            n_constants: 7,
            n_stages: 1,
            cm_pols_map: Vec::new(),
            proof_values_map: Vec::new(),
            airgroup_values_map: Vec::new(),
            air_values_map: Vec::new(),
            challenges_map: Vec::new(),
            custom_commits_map: Vec::new(),
            custom_commits: Vec::new(),
            opening_points: vec![0],
            boundaries: Vec::new(),
            q_deg: 3,
            map_sections_n,
            ev_map: vec![
                CircomEvMap { ev_type: "cm".to_string(), id: 0, prime: 0, opening_pos: 0, commit_id: None },
                CircomEvMap { ev_type: "const".to_string(), id: 0, prime: 0, opening_pos: 0, commit_id: None },
            ],
        }
    }

    fn tmp_ref(id: u64, dim: u64) -> CircomCodeRef {
        CircomCodeRef {
            ref_type: "tmp".to_string(),
            id: Some(id),
            dim,
            stage: None,
            stage_id: None,
            value: None,
            boundary_id: None,
            commit_id: None,
        }
    }

    fn number_ref(value: &str) -> CircomCodeRef {
        CircomCodeRef {
            ref_type: "number".to_string(),
            id: None,
            dim: 1,
            stage: None,
            stage_id: None,
            value: Some(value.to_string()),
            boundary_id: None,
            commit_id: None,
        }
    }

    fn cm_ref(id: u64, dim: u64) -> CircomCodeRef {
        CircomCodeRef {
            ref_type: "cm".to_string(),
            id: Some(id),
            dim,
            stage: None,
            stage_id: None,
            value: None,
            boundary_id: None,
            commit_id: None,
        }
    }

    fn challenge_ref(stage: u64, stage_id: u64) -> CircomCodeRef {
        CircomCodeRef {
            ref_type: "challenge".to_string(),
            id: None,
            dim: 3,
            stage: Some(stage),
            stage_id: Some(stage_id),
            value: None,
            boundary_id: None,
            commit_id: None,
        }
    }
}
