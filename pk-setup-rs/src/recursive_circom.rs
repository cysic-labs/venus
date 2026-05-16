use std::collections::BTreeMap;

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

#[derive(Debug, Clone, Deserialize)]
#[allow(dead_code)]
pub struct CircomCodeLine {
    pub op: String,
    pub dest: CircomCodeRef,
    pub src: Vec<CircomCodeRef>,
}

#[derive(Debug, Clone, Deserialize)]
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
}
