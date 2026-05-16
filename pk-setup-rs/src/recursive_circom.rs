use std::collections::{BTreeMap, BTreeSet};

use serde::Deserialize;

use crate::stark_struct::StarkStruct;

const MIN_CHUNK_SIZE: usize = 1000;
const GOLDILOCKS_P: u64 = 0xFFFF_FFFF_0000_0001;
const GOLDILOCKS_SHIFT: u64 = 49;
const GOLDILOCKS_ROOTS: [u64; 33] = [
    1,
    18446744069414584320,
    281474976710656,
    16777216,
    4096,
    64,
    8,
    2198989700608,
    4404853092538523347,
    6434636298004421797,
    4255134452441852017,
    9113133275150391358,
    4355325209153869931,
    4308460244895131701,
    7126024226993609386,
    1873558160482552414,
    8167150655112846419,
    5718075921287398682,
    3411401055030829696,
    8982441859486529725,
    1971462654193939361,
    6553637399136210105,
    8124823329697072476,
    5936499541590631774,
    2709866199236980323,
    8877499657461974390,
    3757607247483852735,
    4969973714567017225,
    2147253751702802259,
    2530564950562219707,
    1905180297017055339,
    3524815499551269279,
    7277203076849721926,
];
const GOLDILOCKS_INV_ROOTS: [u64; 33] = [
    1,
    18446744069414584320,
    18446462594437873665,
    18446742969902956801,
    18442240469788262401,
    18158513693329981441,
    16140901060737761281,
    274873712576,
    9171943329124577373,
    5464760906092500108,
    4088309022520035137,
    6141391951880571024,
    386651765402340522,
    11575992183625933494,
    2841727033376697931,
    8892493137794983311,
    9071788333329385449,
    15139302138664925958,
    14996013474702747840,
    5708508531096855759,
    6451340039662992847,
    5102364342718059185,
    10420286214021487819,
    13945510089405579673,
    17538441494603169704,
    16784649996768716373,
    8974194941257008806,
    16194875529212099076,
    5506647088734794298,
    7731871677141058814,
    16558868196663692994,
    9896756522253134970,
    1644488454024429189,
];

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

#[derive(Debug, Clone, Copy, Default)]
#[allow(dead_code)]
pub struct VadcopAssignOptions {
    pub add_prefix_agg_types: bool,
    pub set_enable_input: bool,
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
            format_args!(
                "    signal input {prefix}airvalues[{}][3];",
                stark_info.air_values_map.len()
            ),
        );
    }
    for stage in 1..=stark_info.n_stages + 1 {
        line(&mut out, format_args!("    signal input {prefix}root{stage}[4];"));
    }
    line(&mut out, format_args!("    signal input {prefix}evals[{}][3];", stark_info.ev_map.len()));
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
        line(&mut out, format_args!("        {component_name}.publics[i] <== {prefix}publics[i];"));
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
    line(&mut out, format_args!("    {component_name}.s0_siblingsC <== {prefix}s0_siblingsC;"));
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
        line(
            &mut out,
            format_args!("    {component_name}.s0_vals{stage} <== {prefix}s0_vals{stage};"),
        );
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
            format_args!(
                "    signal {signal_type} {prefix}airgroupvalues[{}][3];",
                agg_types.len()
            ),
        );
    }
    if vadcop_info.curve == "None" {
        line(
            &mut out,
            format_args!(
                "    signal {signal_type} {prefix}stage1Hash[{}];",
                vadcop_info.lattice_size
            ),
        );
    } else {
        line(&mut out, format_args!("    signal {signal_type} {prefix}stage1Hash[2][5];"));
    }
    out
}

#[allow(dead_code)]
pub fn render_calculate_stage1_hash_template(
    stark_info: &CircomStarkInfo,
    vadcop_info: &CircomVadcopInfo,
) -> String {
    assert_eq!(vadcop_info.curve, "None", "only lattice VADCOP hashing is supported");
    let arity_words = 4 * stark_info.stark_struct.merkle_tree_arity as usize;
    let blocks = vadcop_info.lattice_size.div_ceil(arity_words);
    let mut out = String::new();
    line(&mut out, format_args!("template CalculateStage1Hash() {{"));
    line(&mut out, format_args!("    signal input rootC[4];"));
    line(&mut out, format_args!("    signal input root1[4];"));
    if stark_info.air_values_map.iter().any(|value| value.stage == 1) {
        line(
            &mut out,
            format_args!("    signal input airValues[{}][3];", stark_info.air_values_map.len()),
        );
    }
    out.push('\n');
    line(&mut out, format_args!("    signal output values[{}];", vadcop_info.lattice_size));
    out.push('\n');

    let mut transcript = TranscriptRenderer::new(stark_info, Some("stage1".to_string()));
    transcript.put("rootC", Some(4));
    transcript.put("root1", Some(4));
    for (idx, air_value) in stark_info.air_values_map.iter().enumerate() {
        if air_value.stage == 1 {
            transcript.put(&format!("airValues[{idx}]"), Some(1));
        } else {
            transcript
                .code
                .push(format!("_ <== airValues[{idx}]; // Unused air values at stage 1"));
        }
    }
    for idx in 0..arity_words.min(vadcop_info.lattice_size) {
        let field = transcript.get_fields1();
        transcript.code.push(format!("values[{idx}] <== {field};"));
    }
    out.push_str(&transcript.take_code());

    for block in 0..blocks.saturating_sub(1) {
        let signal = format!("transcriptHash_stage1_chain_{block}");
        let base = block * arity_words;
        let next_base = (block + 1) * arity_words;
        let pending = (0..(arity_words - 4))
            .map(|idx| format!("values[{}]", base + idx))
            .collect::<Vec<_>>()
            .join(", ");
        let state = ((arity_words - 4)..arity_words)
            .map(|idx| format!("values[{}]", base + idx))
            .collect::<Vec<_>>()
            .join(", ");
        line(
            &mut out,
            format_args!(
                "    signal {signal}[{arity_words}] <== Poseidon2({}, {arity_words})([{pending}], [{state}]);",
                stark_info.stark_struct.merkle_tree_arity
            ),
        );
        line(&mut out, format_args!("    for (var j = 0; j < {arity_words}; j++) {{"));
        line(&mut out, format_args!("        values[{next_base} + j] <== {signal}[j];"));
        line(&mut out, format_args!("    }}"));
        out.push('\n');
    }
    line(&mut out, format_args!("}}"));
    out
}

#[allow(dead_code)]
pub fn render_init_vadcop_inputs(
    component_name: &str,
    prefix: &str,
    prefix_stark: &str,
    airgroup_id: usize,
    stark_info: &CircomStarkInfo,
    vadcop_info: &CircomVadcopInfo,
) -> String {
    let prefix = prefixed(prefix);
    let prefix_stark = prefixed(prefix_stark);
    let agg_types = vadcop_info.agg_types.get(airgroup_id).map(Vec::as_slice).unwrap_or(&[]);
    let multiple_circuits = vadcop_info.air_groups.len() > 1
        || vadcop_info.airs.first().map(|airs| airs.len()).unwrap_or(0) > 1;
    let circuit_type = stark_info.air_id.unwrap_or(0) + if multiple_circuits { 2 } else { 1 };
    let mut out = String::new();

    line(&mut out, format_args!("    {component_name}.globalChallenge <== globalChallenge;"));
    line(&mut out, format_args!("    {prefix}circuitType <== {circuit_type};"));
    line(&mut out, format_args!("    {prefix}aggregatedProofs <== 1;"));
    if !agg_types.is_empty() {
        line(
            &mut out,
            format_args!(
                "    {prefix}aggregationTypes <== [{}];",
                agg_types.iter().map(|agg| agg.agg_type.to_string()).collect::<Vec<_>>().join(",")
            ),
        );
        for idx in 0..agg_types.len() {
            line(
                &mut out,
                format_args!(
                    "    {prefix}airgroupvalues[{idx}] <== {prefix_stark}airgroupvalues[{idx}];"
                ),
            );
        }
    }
    if stark_info.air_values_map.iter().any(|value| value.stage == 1) {
        line(
            &mut out,
            format_args!(
                "    {prefix}stage1Hash <== CalculateStage1Hash()({component_name}.rootC, {prefix_stark}root1, {prefix_stark}airvalues);"
            ),
        );
    } else {
        line(
            &mut out,
            format_args!(
                "    {prefix}stage1Hash <== CalculateStage1Hash()({component_name}.rootC, {prefix_stark}root1);"
            ),
        );
    }
    out
}

#[allow(dead_code)]
pub fn render_assign_vadcop_inputs(
    component_name: &str,
    vadcop_info: &CircomVadcopInfo,
    prefix: &str,
    airgroup_id: usize,
    options: VadcopAssignOptions,
) -> String {
    let prefix = prefixed(prefix);
    let agg_types = vadcop_info.agg_types.get(airgroup_id).map(Vec::as_slice).unwrap_or(&[]);
    let mut public_idx = 0usize;
    let mut out = String::new();

    line(
        &mut out,
        format_args!("    {component_name}.publics[{public_idx}] <== {prefix}circuitType;"),
    );
    public_idx += 1;
    line(
        &mut out,
        format_args!("    {component_name}.publics[{public_idx}] <== {prefix}aggregatedProofs;"),
    );
    public_idx += 1;

    if !agg_types.is_empty() {
        let agg_prefix = if options.add_prefix_agg_types { prefix.as_str() } else { "" };
        line(&mut out, format_args!("    for(var i = 0; i < {}; i++) {{", agg_types.len()));
        line(
            &mut out,
            format_args!("        {component_name}.publics[{public_idx} + i] <== {agg_prefix}aggregationTypes[i];"),
        );
        line(&mut out, format_args!("    }}"));
        public_idx += agg_types.len();
        line(&mut out, format_args!("    for(var i = 0; i < {}; i++) {{", agg_types.len()));
        line(
            &mut out,
            format_args!(
                "        {component_name}.publics[{public_idx} + 3*i] <== {prefix}airgroupvalues[i][0];"
            ),
        );
        line(
            &mut out,
            format_args!(
                "        {component_name}.publics[{public_idx} + 3*i + 1] <== {prefix}airgroupvalues[i][1];"
            ),
        );
        line(
            &mut out,
            format_args!(
                "        {component_name}.publics[{public_idx} + 3*i + 2] <== {prefix}airgroupvalues[i][2];"
            ),
        );
        line(&mut out, format_args!("    }}"));
        public_idx += 3 * agg_types.len();
    }

    line(&mut out, format_args!("    for (var i = 0; i < {}; i++) {{", vadcop_info.lattice_size));
    line(
        &mut out,
        format_args!(
            "        {component_name}.publics[{public_idx} + i] <== {prefix}stage1Hash[i];"
        ),
    );
    line(&mut out, format_args!("    }}"));
    public_idx += vadcop_info.lattice_size;

    if vadcop_info.n_publics > 0 {
        line(&mut out, format_args!("    for(var i = 0; i < {}; i++) {{", vadcop_info.n_publics));
        line(
            &mut out,
            format_args!("        {component_name}.publics[{public_idx} + i] <== publics[i];"),
        );
        line(&mut out, format_args!("    }}"));
        public_idx += vadcop_info.n_publics;
    }
    let proof_values = vadcop_info.proof_values_map.len();
    if proof_values > 0 {
        line(&mut out, format_args!("    for(var i = 0; i < {proof_values}; i++) {{"));
        line(
            &mut out,
            format_args!(
                "        {component_name}.publics[{public_idx} + 3*i] <== proofValues[i][0];"
            ),
        );
        line(
            &mut out,
            format_args!(
                "        {component_name}.publics[{public_idx} + 3*i + 1] <== proofValues[i][1];"
            ),
        );
        line(
            &mut out,
            format_args!(
                "        {component_name}.publics[{public_idx} + 3*i + 2] <== proofValues[i][2];"
            ),
        );
        line(&mut out, format_args!("    }}"));
        public_idx += proof_values * 3;
    }

    line(
        &mut out,
        format_args!("    {component_name}.publics[{public_idx}] <== globalChallenge[0];"),
    );
    line(
        &mut out,
        format_args!("    {component_name}.publics[{}] <== globalChallenge[1];", public_idx + 1),
    );
    line(
        &mut out,
        format_args!("    {component_name}.publics[{}] <== globalChallenge[2];", public_idx + 2),
    );
    if options.set_enable_input {
        out.push('\n');
        line(
            &mut out,
            format_args!("    signal {{binary}} {prefix}isNull <== IsZero()({prefix}circuitType);"),
        );
        line(&mut out, format_args!("    {component_name}.enable <== 1 - {prefix}isNull;"));
    }
    out
}

#[allow(dead_code)]
pub fn render_agg_vadcop_inputs(
    vadcop_info: &CircomVadcopInfo,
    airgroup_id: usize,
    prefix1: &str,
    prefix2: &str,
    prefix3: &str,
    prefix: &str,
) -> String {
    assert_eq!(vadcop_info.curve, "None", "only lattice VADCOP aggregation is supported");
    let agg_types = vadcop_info.agg_types.get(airgroup_id).map(Vec::as_slice).unwrap_or(&[]);
    let multiple_circuits = vadcop_info.air_groups.len() > 1
        || vadcop_info.airs.first().map(|airs| airs.len()).unwrap_or(0) > 1;
    let mut out = String::new();
    line(
        &mut out,
        format_args!("    {prefix}_circuitType <== {};", if multiple_circuits { 1 } else { 0 }),
    );
    if !agg_types.is_empty() {
        line(&mut out, format_args!("    {prefix}_aggregationTypes <== aggregationTypes;"));
        line(&mut out, format_args!("    signal {{binary}} aggTypes[{}];", agg_types.len()));
        line(&mut out, format_args!("    for (var i = 0; i < {}; i++) {{", agg_types.len()));
        line(
            &mut out,
            format_args!(
                "        {prefix}_aggregationTypes[i] * ({prefix}_aggregationTypes[i] - 1) === 0;"
            ),
        );
        line(&mut out, format_args!("        aggTypes[i] <== {prefix}_aggregationTypes[i];"));
        line(&mut out, format_args!("    }}"));
        out.push('\n');
    }

    if multiple_circuits {
        line(
            &mut out,
            format_args!(
                "    signal {{binary}} AB_isNull <== IsZero()(2 - {prefix1}_isNull - {prefix2}_isNull);"
            ),
        );
        if !agg_types.is_empty() {
            line(&mut out, format_args!("    signal airgroupValues_AB[{}][3];", agg_types.len()));
            line(&mut out, format_args!("    for (var i = 0; i < {}; i++) {{", agg_types.len()));
            line(
                &mut out,
                format_args!("        airgroupValues_AB[i] <== AggregateAirgroupValuesNull()({prefix1}_airgroupvalues[i], {prefix2}_airgroupvalues[i], aggTypes[i], {prefix1}_isNull, {prefix2}_isNull);"),
            );
            line(
                &mut out,
                format_args!("        {prefix}_airgroupvalues[i] <== AggregateAirgroupValuesNull()(airgroupValues_AB[i], {prefix3}_airgroupvalues[i], aggTypes[i], AB_isNull, {prefix3}_isNull);"),
            );
            line(&mut out, format_args!("    }}"));
        }
        line(
            &mut out,
            format_args!("    signal {{binary}} isNull[3] <== [{prefix1}_isNull, {prefix2}_isNull, {prefix3}_isNull];"),
        );
        line(
            &mut out,
            format_args!("    {prefix}_aggregatedProofs <== AggregateProofsNull(3)([{prefix1}_aggregatedProofs, {prefix2}_aggregatedProofs, {prefix3}_aggregatedProofs], isNull);"),
        );
        line(
            &mut out,
            format_args!("    signal AB_stage1Hash[{}] <== AggregateValuesNull({})( {prefix1}_stage1Hash, {prefix2}_stage1Hash, {prefix1}_isNull, {prefix2}_isNull);", vadcop_info.lattice_size, vadcop_info.lattice_size),
        );
        line(
            &mut out,
            format_args!("    {prefix}_stage1Hash <== AggregateValuesNull({})(AB_stage1Hash, {prefix3}_stage1Hash, AB_isNull, {prefix3}_isNull);", vadcop_info.lattice_size),
        );
    } else {
        if !agg_types.is_empty() {
            line(&mut out, format_args!("    signal airgroupValuesAB[{}][3];", agg_types.len()));
            line(&mut out, format_args!("    for (var i = 0; i < {}; i++) {{", agg_types.len()));
            line(
                &mut out,
                format_args!(
                    "        airgroupValuesAB[i] <== AggregateAirgroupValues()({prefix1}_airgroupvalues[i], {prefix2}_airgroupvalues[i], aggTypes[i]);"
                ),
            );
            line(
                &mut out,
                format_args!(
                    "        {prefix}_airgroupvalues[i] <== AggregateAirgroupValues()(airgroupValuesAB[i], {prefix3}_airgroupvalues[i], aggTypes[i]);"
                ),
            );
            line(&mut out, format_args!("    }}"));
        }
        line(
            &mut out,
            format_args!(
                "    {prefix}_aggregatedProofs <== AggregateProofs(3)([{prefix1}_aggregatedProofs, {prefix2}_aggregatedProofs, {prefix3}_aggregatedProofs]);"
            ),
        );
        line(
            &mut out,
            format_args!(
                "    signal AB_stage1Hash[{}] <== AggregateValues({})({prefix1}_stage1Hash, {prefix2}_stage1Hash);",
                vadcop_info.lattice_size, vadcop_info.lattice_size
            ),
        );
        line(
            &mut out,
            format_args!(
                "    {prefix}_stage1Hash <== AggregateValues({})(AB_stage1Hash, {prefix3}_stage1Hash);",
                vadcop_info.lattice_size
            ),
        );
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
            "add" => render_binary_op(
                &mut out,
                "+",
                &dest,
                stark_info,
                lhs,
                rhs.expect("missing rhs"),
                lhs_dim,
                rhs_dim.unwrap(),
            ),
            "sub" => render_sub(
                &mut out,
                &dest,
                stark_info,
                lhs,
                rhs.expect("missing rhs"),
                lhs_dim,
                rhs_dim.unwrap(),
            ),
            "mul" => render_mul(
                &mut out,
                &dest,
                stark_info,
                lhs,
                rhs.expect("missing rhs"),
                lhs_dim,
                rhs_dim.unwrap(),
            ),
            "copy" => {
                line(
                    &mut out,
                    format_args!(
                        "    {dest} <== {};",
                        render_ref(stark_info, lhs, false, &initialized)
                    ),
                );
            }
            op => panic!("unsupported verifier instruction op {op}"),
        }
    }
    out
}

#[derive(Debug, Clone, Copy, Default)]
#[allow(dead_code)]
pub struct StarkVerifierOptions {
    pub input_challenges: bool,
    pub skip_main: bool,
    pub verkey_input: bool,
    pub enable_input: bool,
    pub multi_fri: bool,
}

#[allow(dead_code)]
pub fn render_stark_verifier_circom(
    const_root: &[u64],
    stark_info: &CircomStarkInfo,
    verifier_info: &CircomVerifierInfo,
    options: StarkVerifierOptions,
) -> String {
    let mut out = String::new();
    line(&mut out, format_args!("pragma circom 2.1.0;"));
    line(&mut out, format_args!("pragma custom_templates;"));
    out.push('\n');
    for include in [
        "cmul.circom",
        "cinv.circom",
        "poseidon2.circom",
        "bitify.circom",
        "fft.circom",
        "evalpol.circom",
        "treeselector4.circom",
        "pow.circom",
        "merklehash.circom",
    ] {
        line(&mut out, format_args!("include \"{include}\";"));
    }
    out.push('\n');
    out.push_str(&render_calculate_fri_queries_template(stark_info));
    out.push('\n');
    out.push_str(&render_transcript_template(stark_info, options));
    out.push('\n');
    out.push_str(&render_verify_fri_template(stark_info));
    out.push('\n');
    out.push_str(&render_verify_evaluations_templates(stark_info, verifier_info));
    out.push('\n');
    out.push_str(&render_calculate_fri_pol_templates(stark_info, verifier_info));
    out.push('\n');
    out.push_str(&render_verify_final_pol_template(stark_info));
    out.push('\n');
    out.push_str(&render_stark_verifier_template(const_root, stark_info, options));
    out
}

#[allow(dead_code)]
pub fn render_recursive1_circom(
    stark_info: &CircomStarkInfo,
    vadcop_info: &CircomVadcopInfo,
    verifier_filename: &str,
    has_compressor: bool,
) -> String {
    let airgroup_id = stark_info.airgroup_id.unwrap_or(0) as usize;
    let mut out = String::new();
    line(&mut out, format_args!("pragma circom 2.1.0;"));
    line(&mut out, format_args!("pragma custom_templates;"));
    out.push('\n');
    line(&mut out, format_args!("include \"iszero.circom\";"));
    line(&mut out, format_args!("include \"{verifier_filename}\";"));
    if !has_compressor {
        line(&mut out, format_args!("include \"elliptic_curve.circom\";"));
        out.push_str(&render_calculate_stage1_hash_template(stark_info, vadcop_info));
        out.push('\n');
    }
    out.push('\n');
    line(&mut out, format_args!("template Recursive1() {{"));
    out.push_str(&render_define_vadcop_inputs(vadcop_info, airgroup_id, "sv", has_compressor));
    out.push('\n');
    out.push_str(&render_define_stark_inputs(
        stark_info,
        "",
        vadcop_info.n_publics,
        StarkInputOptions { add_publics: false, ..Default::default() },
    ));
    if vadcop_info.n_publics > 0 {
        line(&mut out, format_args!("    signal input publics[{}];", vadcop_info.n_publics));
    }
    if !vadcop_info.proof_values_map.is_empty() {
        line(
            &mut out,
            format_args!(
                "    signal input proofValues[{}][3];",
                vadcop_info.proof_values_map.len()
            ),
        );
    }
    line(&mut out, format_args!("    signal input globalChallenge[3];"));
    line(&mut out, format_args!("    signal input rootCAgg[4];"));
    out.push('\n');
    out.push_str(&render_assign_stark_inputs(
        "sV",
        stark_info,
        "",
        vadcop_info.n_publics,
        StarkInputOptions { add_publics: !has_compressor, ..Default::default() },
    ));
    out.push('\n');
    if !has_compressor {
        out.push_str(&render_init_vadcop_inputs(
            "sV",
            "sv",
            "",
            airgroup_id,
            stark_info,
            vadcop_info,
        ));
    } else {
        out.push_str(&render_assign_vadcop_inputs(
            "sV",
            vadcop_info,
            "sv",
            airgroup_id,
            VadcopAssignOptions { add_prefix_agg_types: true, set_enable_input: false },
        ));
    }
    line(&mut out, format_args!("}}"));
    out.push('\n');

    let mut public_names = Vec::new();
    if has_compressor {
        public_names.extend(vadcop_public_input_names(vadcop_info, airgroup_id, "sv"));
    }
    if vadcop_info.n_publics > 0 {
        public_names.push("publics".to_string());
    }
    if !vadcop_info.proof_values_map.is_empty() {
        public_names.push("proofValues".to_string());
    }
    public_names.push("globalChallenge".to_string());
    public_names.push("rootCAgg".to_string());
    line(
        &mut out,
        format_args!("component main {{public [{}]}} = Recursive1();", public_names.join(", ")),
    );
    out
}

#[allow(dead_code)]
pub fn render_compressor_circom(
    stark_info: &CircomStarkInfo,
    vadcop_info: &CircomVadcopInfo,
    verifier_filename: &str,
) -> String {
    let airgroup_id = stark_info.airgroup_id.unwrap_or(0) as usize;
    let mut out = String::new();
    line(&mut out, format_args!("pragma circom 2.1.0;"));
    line(&mut out, format_args!("pragma custom_templates;"));
    out.push('\n');
    line(&mut out, format_args!("include \"{verifier_filename}\";"));
    line(&mut out, format_args!("include \"elliptic_curve.circom\";"));
    out.push_str(&render_calculate_stage1_hash_template(stark_info, vadcop_info));
    out.push('\n');
    line(&mut out, format_args!("template Compressor() {{"));
    if vadcop_info.n_publics > 0 {
        line(&mut out, format_args!("    signal input publics[{}];", vadcop_info.n_publics));
    }
    if !vadcop_info.proof_values_map.is_empty() {
        line(
            &mut out,
            format_args!(
                "    signal input proofValues[{}][3];",
                vadcop_info.proof_values_map.len()
            ),
        );
    }
    line(&mut out, format_args!("    signal input globalChallenge[3];"));
    out.push('\n');
    out.push_str(&render_define_stark_inputs(
        stark_info,
        "",
        vadcop_info.n_publics,
        StarkInputOptions { add_publics: false, ..Default::default() },
    ));
    out.push('\n');
    out.push_str(&render_define_vadcop_inputs(vadcop_info, airgroup_id, "sv", false));
    out.push('\n');
    out.push_str(&render_assign_stark_inputs(
        "sV",
        stark_info,
        "",
        vadcop_info.n_publics,
        StarkInputOptions { add_publics: false, ..Default::default() },
    ));
    if vadcop_info.n_publics > 0 {
        line(&mut out, format_args!("    for (var i=0; i< {}; i++) {{", vadcop_info.n_publics));
        line(&mut out, format_args!("        sV.publics[i] <== publics[i];"));
        line(&mut out, format_args!("    }}"));
    }
    out.push_str(&render_init_vadcop_inputs("sV", "sv", "", airgroup_id, stark_info, vadcop_info));
    line(&mut out, format_args!("}}"));
    out.push('\n');
    let mut public_names = Vec::new();
    if vadcop_info.n_publics > 0 {
        public_names.push("publics".to_string());
    }
    if !vadcop_info.proof_values_map.is_empty() {
        public_names.push("proofValues".to_string());
    }
    public_names.push("globalChallenge".to_string());
    line(
        &mut out,
        format_args!("component main {{public [{}]}} = Compressor();", public_names.join(", ")),
    );
    out
}

#[allow(dead_code)]
pub fn render_recursive2_circom(
    stark_info: &CircomStarkInfo,
    vadcop_info: &CircomVadcopInfo,
    airgroup_id: usize,
    verifier_filename: &str,
    basic_verification_keys: &[Vec<u64>],
) -> String {
    let mut out = String::new();
    line(&mut out, format_args!("pragma circom 2.1.0;"));
    line(&mut out, format_args!("pragma custom_templates;"));
    out.push('\n');
    line(&mut out, format_args!("include \"select_vk.circom\";"));
    line(&mut out, format_args!("include \"agg_values.circom\";"));
    line(&mut out, format_args!("include \"acc_points.circom\";"));
    line(&mut out, format_args!("include \"{verifier_filename}\";"));
    out.push('\n');
    line(&mut out, format_args!("template Recursive2() {{"));
    let n_airs = vadcop_info.airs.get(airgroup_id).map(Vec::len).unwrap_or(0);
    line(&mut out, format_args!("    var rootCBasics[{n_airs}][4];"));
    for (idx, key) in basic_verification_keys.iter().enumerate() {
        line(&mut out, format_args!("    rootCBasics[{idx}] = [{}];", join_u64(key)));
    }
    out.push('\n');
    out.push_str(&render_define_vadcop_inputs(vadcop_info, airgroup_id, "sv", false));
    out.push('\n');
    if vadcop_info.n_publics > 0 {
        line(&mut out, format_args!("    signal input publics[{}];", vadcop_info.n_publics));
    }
    if !vadcop_info.proof_values_map.is_empty() {
        line(
            &mut out,
            format_args!(
                "    signal input proofValues[{}][3];",
                vadcop_info.proof_values_map.len()
            ),
        );
    }
    line(&mut out, format_args!("    signal input globalChallenge[3];"));
    line(&mut out, format_args!("    signal input rootCAgg[4];"));
    out.push('\n');

    for prefix in ["a", "b", "c"] {
        out.push_str(&render_define_vadcop_inputs(
            vadcop_info,
            airgroup_id,
            &format!("{prefix}_sv"),
            true,
        ));
        out.push_str(&render_define_stark_inputs(
            stark_info,
            prefix,
            vadcop_info.n_publics,
            StarkInputOptions { add_publics: false, ..Default::default() },
        ));
        out.push('\n');
    }

    let agg_types = vadcop_info.agg_types.get(airgroup_id).map(Vec::as_slice).unwrap_or(&[]);
    if !agg_types.is_empty() {
        line(&mut out, format_args!("    signal aggregationTypes[{}];", agg_types.len()));
        line(&mut out, format_args!("    for(var i = 0; i < {}; i++) {{", agg_types.len()));
        line(&mut out, format_args!("        aggregationTypes[i] <== a_sv_aggregationTypes[i];"));
        line(
            &mut out,
            format_args!("        a_sv_aggregationTypes[i] === b_sv_aggregationTypes[i];"),
        );
        line(
            &mut out,
            format_args!("        a_sv_aggregationTypes[i] === c_sv_aggregationTypes[i];"),
        );
        line(&mut out, format_args!("    }}"));
    }

    out.push_str(&render_assign_stark_inputs(
        "vA",
        stark_info,
        "a",
        vadcop_info.n_publics,
        StarkInputOptions { add_publics: false, ..Default::default() },
    ));
    out.push_str(&render_assign_stark_inputs(
        "vB",
        stark_info,
        "b",
        vadcop_info.n_publics,
        StarkInputOptions { add_publics: false, ..Default::default() },
    ));
    out.push_str(&render_assign_stark_inputs(
        "vC",
        stark_info,
        "c",
        vadcop_info.n_publics,
        StarkInputOptions { add_publics: false, ..Default::default() },
    ));
    let multiple_circuits = vadcop_info.air_groups.len() > 1
        || vadcop_info.airs.first().map(|airs| airs.len()).unwrap_or(0) > 1;
    out.push_str(&render_assign_vadcop_inputs(
        "vA",
        vadcop_info,
        "a_sv",
        airgroup_id,
        VadcopAssignOptions { add_prefix_agg_types: false, set_enable_input: multiple_circuits },
    ));
    out.push_str(&render_assign_vadcop_inputs(
        "vB",
        vadcop_info,
        "b_sv",
        airgroup_id,
        VadcopAssignOptions { add_prefix_agg_types: false, set_enable_input: multiple_circuits },
    ));
    out.push_str(&render_assign_vadcop_inputs(
        "vC",
        vadcop_info,
        "c_sv",
        airgroup_id,
        VadcopAssignOptions { add_prefix_agg_types: false, set_enable_input: multiple_circuits },
    ));
    out.push('\n');

    let selector =
        if multiple_circuits { "SelectVerificationKeyNull" } else { "SelectVerificationKey" };
    line(
        &mut out,
        format_args!(
            "    vA.rootC <== {selector}({n_airs})(a_sv_circuitType, rootCBasics, rootCAgg);"
        ),
    );
    line(
        &mut out,
        format_args!(
            "    vB.rootC <== {selector}({n_airs})(b_sv_circuitType, rootCBasics, rootCAgg);"
        ),
    );
    line(
        &mut out,
        format_args!(
            "    vC.rootC <== {selector}({n_airs})(c_sv_circuitType, rootCBasics, rootCAgg);"
        ),
    );
    out.push('\n');
    out.push_str(&render_agg_vadcop_inputs(vadcop_info, airgroup_id, "a_sv", "b_sv", "c_sv", "sv"));
    out.push('\n');
    line(&mut out, format_args!("    for (var i=0; i<4; i++) {{"));
    line(
        &mut out,
        format_args!("        vA.publics[{} + i] <== rootCAgg[i];", stark_info.n_publics - 4),
    );
    line(
        &mut out,
        format_args!("        vB.publics[{} + i] <== rootCAgg[i];", stark_info.n_publics - 4),
    );
    line(
        &mut out,
        format_args!("        vC.publics[{} + i] <== rootCAgg[i];", stark_info.n_publics - 4),
    );
    line(&mut out, format_args!("    }}"));
    line(&mut out, format_args!("}}"));
    out.push('\n');

    let mut public_names = Vec::new();
    if vadcop_info.n_publics > 0 {
        public_names.push("publics".to_string());
    }
    if !vadcop_info.proof_values_map.is_empty() {
        public_names.push("proofValues".to_string());
    }
    public_names.push("globalChallenge".to_string());
    public_names.push("rootCAgg".to_string());
    line(
        &mut out,
        format_args!("component main {{public [{}]}} = Recursive2();", public_names.join(", ")),
    );
    out
}

#[allow(dead_code)]
pub fn render_calculate_fri_queries_template(stark_info: &CircomStarkInfo) -> String {
    let name = suffixed_name("calculateFRIQueries", stark_info.airgroup_id);
    let mut out = String::new();
    line(&mut out, format_args!("template {name}() {{"));
    line(&mut out, format_args!("    signal input challengeFRIQueries[3];"));
    if stark_info.stark_struct.pow_bits > 0 {
        line(&mut out, format_args!("    signal input nonce;"));
    }
    line(&mut out, format_args!("    signal input {{binary}} enable;"));
    line(
        &mut out,
        format_args!(
            "    signal output {{binary}} queriesFRI[{}][{}];",
            stark_info.n_queries(),
            stark_info.stark_struct.steps[0].n_bits
        ),
    );
    out.push('\n');
    if stark_info.stark_struct.pow_bits > 0 {
        line(
            &mut out,
            format_args!(
                "    VerifyPoW({})(challengeFRIQueries, nonce, enable);",
                stark_info.stark_struct.pow_bits
            ),
        );
        out.push('\n');
    }
    let mut transcript = TranscriptRenderer::new(stark_info, Some("friQueries".to_string()));
    transcript.put("challengeFRIQueries", Some(3));
    if stark_info.stark_struct.pow_bits > 0 {
        transcript.put("nonce", None);
    }
    transcript.get_permutations(
        "queriesFRI",
        stark_info.n_queries(),
        stark_info.stark_struct.steps[0].n_bits,
    );
    out.push_str(&transcript.take_code());
    line(&mut out, format_args!("}}"));
    out
}

#[allow(dead_code)]
pub fn render_transcript_template(
    stark_info: &CircomStarkInfo,
    options: StarkVerifierOptions,
) -> String {
    let name = suffixed_name("Transcript", stark_info.airgroup_id);
    let calculate_fri_queries_name = suffixed_name("calculateFRIQueries", stark_info.airgroup_id);
    let q_stage = stark_info.n_stages + 1;
    let mut out = String::new();
    line(&mut out, format_args!("template {name}() {{"));

    if !options.input_challenges {
        if stark_info.n_publics > 0 {
            line(&mut out, format_args!("    signal input publics[{}];", stark_info.n_publics));
        }
        line(&mut out, format_args!("    signal input rootC[4];"));
        line(&mut out, format_args!("    signal input root1[4];"));
    } else {
        line(&mut out, format_args!("    signal input globalChallenge[3]; "));
    }
    out.push('\n');
    if !stark_info.air_values_map.is_empty() {
        line(
            &mut out,
            format_args!("    signal input airValues[{}][3];", stark_info.air_values_map.len()),
        );
        out.push('\n');
    }
    for stage in 2..=stark_info.n_stages {
        line(&mut out, format_args!("    signal input root{stage}[4];"));
    }
    line(&mut out, format_args!("    signal input root{q_stage}[4];"));
    line(&mut out, format_args!("    signal input evals[{}][3]; ", stark_info.ev_map.len()));
    for step in 1..stark_info.stark_struct.steps.len() {
        line(&mut out, format_args!("    signal input s{step}_root[4];"));
    }
    let last_pol_size =
        1u64 << stark_info.stark_struct.steps.last().map(|step| step.n_bits).unwrap_or(0);
    line(&mut out, format_args!("    signal input finalPol[{last_pol_size}][3];"));
    if stark_info.stark_struct.pow_bits > 0 {
        line(&mut out, format_args!("    signal input nonce;"));
    }
    line(&mut out, format_args!("    signal input {{binary}} enable;"));
    out.push('\n');

    for stage in 1..=stark_info.n_stages {
        let count = stark_info.challenge_count(stage as u64);
        if count > 0 {
            line(&mut out, format_args!("    signal output challengesStage{stage}[{count}][3];"));
        }
    }
    line(&mut out, format_args!("    signal output challengeQ[3];"));
    line(&mut out, format_args!("    signal output challengeXi[3];"));
    line(&mut out, format_args!("    signal output challengesFRI[2][3];"));
    line(
        &mut out,
        format_args!(
            "    signal output challengesFRISteps[{}][3];",
            stark_info.stark_struct.steps.len() + 1
        ),
    );
    line(
        &mut out,
        format_args!(
            "    signal output {{binary}} queriesFRI[{}][{}];",
            stark_info.n_queries(),
            stark_info.stark_struct.steps[0].n_bits
        ),
    );
    out.push('\n');
    if stark_info.stark_struct.hash_commits {
        if stark_info.n_publics > 0 {
            line(&mut out, format_args!("    signal publicsHash[4];"));
        }
        line(&mut out, format_args!("    signal evalsHash[4];"));
        line(&mut out, format_args!("    signal lastPolFRIHash[4];"));
        out.push('\n');
    }

    let mut transcript = TranscriptRenderer::new(stark_info, None);
    if !options.input_challenges {
        transcript.put("rootC", Some(4));
        if stark_info.n_publics > 0 {
            if !stark_info.stark_struct.hash_commits {
                transcript.put("publics", Some(stark_info.n_publics));
            } else {
                out.push_str(&transcript.take_code());
                let mut publics_transcript =
                    TranscriptRenderer::new(stark_info, Some("publics".to_string()));
                publics_transcript.put("publics", Some(stark_info.n_publics));
                publics_transcript.get_state("publicsHash");
                out.push_str(&publics_transcript.take_code());
                transcript.put("publicsHash", Some(4));
            }
        }
        transcript.put("root1", Some(4));
    } else {
        transcript.put("globalChallenge", Some(3));
    }

    for stage in 2..=stark_info.n_stages {
        for challenge_idx in 0..stark_info.challenge_count(stage as u64) {
            transcript.get_field(&format!("challengesStage{stage}[{challenge_idx}]"));
        }
        transcript.put(&format!("root{stage}"), Some(4));
        for (idx, air_value) in stark_info.air_values_map.iter().enumerate() {
            if air_value.stage == stage as u64 {
                transcript.put(&format!("airValues[{idx}]"), Some(3));
            }
        }
    }

    transcript.get_field("challengeQ");
    transcript.put(&format!("root{q_stage}"), Some(4));
    transcript.get_field("challengeXi");
    if !stark_info.stark_struct.hash_commits {
        for idx in 0..stark_info.ev_map.len() {
            transcript.put(&format!("evals[{idx}]"), Some(3));
        }
    } else {
        out.push_str(&transcript.take_code());
        let mut evals_transcript = TranscriptRenderer::new(stark_info, Some("evals".to_string()));
        for idx in 0..stark_info.ev_map.len() {
            evals_transcript.put(&format!("evals[{idx}]"), Some(3));
        }
        evals_transcript.get_state("evalsHash");
        out.push_str(&evals_transcript.take_code());
        transcript.put("evalsHash", Some(4));
    }

    transcript.get_field("challengesFRI[0]");
    transcript.get_field("challengesFRI[1]");
    for step_idx in 0..stark_info.stark_struct.steps.len() {
        transcript.get_field(&format!("challengesFRISteps[{step_idx}]"));
        if step_idx < stark_info.stark_struct.steps.len() - 1 {
            transcript.put(&format!("s{}_root", step_idx + 1), Some(4));
        } else if !stark_info.stark_struct.hash_commits {
            for idx in 0..last_pol_size {
                transcript.put(&format!("finalPol[{idx}]"), Some(3));
            }
        } else {
            out.push_str(&transcript.take_code());
            let mut last_pol_transcript =
                TranscriptRenderer::new(stark_info, Some("lastPolFRI".to_string()));
            for idx in 0..last_pol_size {
                last_pol_transcript.put(&format!("finalPol[{idx}]"), Some(3));
            }
            last_pol_transcript.get_state("lastPolFRIHash");
            out.push_str(&last_pol_transcript.take_code());
            transcript.put("lastPolFRIHash", Some(4));
        }
    }
    transcript.get_field(&format!("challengesFRISteps[{}]", stark_info.stark_struct.steps.len()));
    out.push_str(&transcript.take_code());
    out.push('\n');

    if stark_info.stark_struct.pow_bits > 0 {
        line(
            &mut out,
            format_args!(
                "    queriesFRI <== {calculate_fri_queries_name}()(challengesFRISteps[{}], nonce, enable);",
                stark_info.stark_struct.steps.len()
            ),
        );
    } else {
        line(
            &mut out,
            format_args!(
                "    queriesFRI <== {calculate_fri_queries_name}()(challengesFRISteps[{}], enable);",
                stark_info.stark_struct.steps.len()
            ),
        );
    }
    line(&mut out, format_args!("}}"));
    out
}

#[allow(dead_code)]
pub fn render_verify_fri_template(stark_info: &CircomStarkInfo) -> String {
    let name = suffixed_name("VerifyFRI", stark_info.airgroup_id);
    let mut out = String::new();
    line(
        &mut out,
        format_args!("template {name}(nBitsExt, prevStepBits, currStepBits, nextStepBits, e0) {{"),
    );
    line(&mut out, format_args!("    var nextStep = currStepBits - nextStepBits; "));
    line(&mut out, format_args!("    var step = prevStepBits - currStepBits;"));
    out.push('\n');
    line(&mut out, format_args!("    signal input {{binary}} queriesFRI[currStepBits];"));
    line(&mut out, format_args!("    signal input friChallenge[3];"));
    line(&mut out, format_args!("    signal input s_vals_curr[1<< step][3];"));
    line(&mut out, format_args!("    signal input s_vals_next[1<< nextStep][3];"));
    line(&mut out, format_args!("    signal input {{binary}} enable;"));
    out.push('\n');
    line(&mut out, format_args!("    signal sx[currStepBits];"));
    out.push('\n');
    line(
        &mut out,
        format_args!("    sx[0] <==  e0 *( queriesFRI[0] * (invroots(prevStepBits) -1) + 1);"),
    );
    line(&mut out, format_args!("    for (var i=1; i< currStepBits; i++) {{"));
    line(
        &mut out,
        format_args!(
            "        sx[i] <== sx[i-1] *  ( queriesFRI[i] * (invroots(prevStepBits -i) -1) +1);"
        ),
    );
    line(&mut out, format_args!("    }}"));
    out.push('\n');
    line(
        &mut out,
        format_args!("    signal coefs[1 << step][3] <== FFT(step, 3, 1)(s_vals_curr);"),
    );
    line(
        &mut out,
        format_args!(
            "    signal evalXprime[3] <== [friChallenge[0] *  sx[currStepBits - 1], friChallenge[1] * sx[currStepBits - 1], friChallenge[2] *  sx[currStepBits - 1]];"
        ),
    );
    line(
        &mut out,
        format_args!("    signal evalPol[3] <== EvalPol(1 << step)(coefs, evalXprime);"),
    );
    out.push('\n');
    line(&mut out, format_args!("    signal {{binary}} keys_lowValues[nextStep];"));
    line(
        &mut out,
        format_args!("    for(var i = 0; i < nextStep; i++) {{ keys_lowValues[i] <== queriesFRI[i + nextStepBits]; }} "),
    );
    line(
        &mut out,
        format_args!(
            "    signal lowValues[3] <== TreeSelector(nextStep, 3)(s_vals_next, keys_lowValues);"
        ),
    );
    out.push('\n');
    line(&mut out, format_args!("    enable * (lowValues[0] - evalPol[0]) === 0;"));
    line(&mut out, format_args!("    enable * (lowValues[1] - evalPol[1]) === 0;"));
    line(&mut out, format_args!("    enable * (lowValues[2] - evalPol[2]) === 0;"));
    line(&mut out, format_args!("}}"));
    out
}

#[allow(dead_code)]
pub fn render_verify_evaluations_templates(
    stark_info: &CircomStarkInfo,
    verifier_info: &CircomVerifierInfo,
) -> String {
    let chunks = build_expression_chunks(&verifier_info.q_verifier.code, MIN_CHUNK_SIZE);
    let mut out = String::new();

    for (idx, chunk) in chunks.chunks.iter().enumerate() {
        line(&mut out, format_args!("template VerifyEvaluationsChunks{idx}() {{"));
        render_challenge_stage_inputs(&mut out, stark_info, None);
        line(&mut out, format_args!("    signal input challengeQ[3];"));
        line(&mut out, format_args!("    signal input challengeXi[3];"));
        line(&mut out, format_args!("    signal input evals[{}][3];", stark_info.ev_map.len()));
        render_optional_value_inputs(&mut out, stark_info, None);
        out.push('\n');
        render_boundary_input_declarations(&mut out, stark_info, None);
        out.push('\n');
        for tmp in &chunk.inputs {
            render_tmp_declaration(&mut out, "input", *tmp, &chunks.tmps);
        }
        out.push('\n');
        for tmp in &chunk.outputs {
            render_tmp_declaration(&mut out, "output", *tmp, &chunks.tmps);
        }
        let initialized =
            chunk.inputs.iter().chain(chunk.outputs.iter()).copied().collect::<Vec<_>>();
        out.push_str(&render_unrolled_code(stark_info, &chunk.code, &initialized));
        line(&mut out, format_args!("}}"));
        out.push('\n');
    }

    out.push_str(&render_verify_evaluations_template(stark_info, verifier_info, &chunks));
    out
}

#[allow(dead_code)]
pub fn render_calculate_fri_pol_templates(
    stark_info: &CircomStarkInfo,
    verifier_info: &CircomVerifierInfo,
) -> String {
    let chunks = build_expression_chunks(&verifier_info.query_verifier.block.code, MIN_CHUNK_SIZE);
    let map_values_name = suffixed_name("MapValues", stark_info.airgroup_id);
    let mut out = String::new();

    for (idx, chunk) in chunks.chunks.iter().enumerate() {
        line(&mut out, format_args!("template CalculateFRIPolChunks{idx}() {{"));
        line(&mut out, format_args!("    signal input challengesFRI[2][3];"));
        line(&mut out, format_args!("    signal input evals[{}][3];", stark_info.ev_map.len()));
        out.push('\n');
        render_cm_value_inputs(&mut out, stark_info, None);
        line(&mut out, format_args!("    signal input consts[{}];", stark_info.n_constants));
        render_custom_commit_value_inputs(&mut out, stark_info, None);
        out.push('\n');
        line(
            &mut out,
            format_args!("    signal input xDivXSubXi[{}][3];", stark_info.opening_points.len()),
        );
        out.push('\n');
        line(&mut out, format_args!("    component mapValues = {map_values_name}();"));
        render_map_values_assignments(&mut out, stark_info);
        out.push('\n');
        for tmp in &chunk.inputs {
            render_tmp_declaration(&mut out, "input", *tmp, &chunks.tmps);
        }
        out.push('\n');
        for tmp in &chunk.outputs {
            render_tmp_declaration(&mut out, "output", *tmp, &chunks.tmps);
        }
        let initialized =
            chunk.inputs.iter().chain(chunk.outputs.iter()).copied().collect::<Vec<_>>();
        out.push_str(&render_unrolled_code(stark_info, &chunk.code, &initialized));
        out.push('\n');
        line(&mut out, format_args!("}}"));
        out.push('\n');
    }

    out.push_str(&render_calculate_fri_pol_template(stark_info, verifier_info, &chunks));
    out.push('\n');
    out.push_str(&render_verify_query_template(stark_info));
    out.push('\n');
    out.push_str(&render_map_values_template(stark_info));
    out
}

#[allow(dead_code)]
pub fn render_verify_final_pol_template(stark_info: &CircomStarkInfo) -> String {
    let name = suffixed_name("VerifyFinalPol", stark_info.airgroup_id);
    let last_bits = stark_info.stark_struct.steps.last().map(|step| step.n_bits).unwrap_or(0);
    let final_pol_size = pow2_u64(last_bits);
    let max_deg_bits = last_bits
        .saturating_sub(stark_info.stark_struct.n_bits_ext - stark_info.stark_struct.n_bits);
    let max_degree = pow2_u64(max_deg_bits);
    let mut out = String::new();
    line(&mut out, format_args!("template {name}() {{"));
    line(&mut out, format_args!("    ///////"));
    line(&mut out, format_args!("    // Check Degree last pol"));
    line(&mut out, format_args!("    ///////"));
    line(&mut out, format_args!("    signal input finalPol[{final_pol_size}][3];"));
    line(&mut out, format_args!("    signal input {{binary}} enable;"));
    out.push('\n');
    line(
        &mut out,
        format_args!(
            "    signal lastIFFT[{final_pol_size}][3] <== FFT({last_bits}, 3, 1)(finalPol);"
        ),
    );
    out.push('\n');
    line(&mut out, format_args!("    for (var k= {max_degree}; k< {final_pol_size}; k++) {{"));
    line(&mut out, format_args!("        for (var e=0; e<3; e++) {{"));
    line(&mut out, format_args!("            enable * lastIFFT[k][e] === 0;"));
    line(&mut out, format_args!("        }}"));
    line(&mut out, format_args!("    }}"));
    out.push('\n');
    line(&mut out, format_args!("    for (var k= 0; k < {max_degree}; k++) {{"));
    line(&mut out, format_args!("        _ <== lastIFFT[k];"));
    line(&mut out, format_args!("    }}"));
    line(&mut out, format_args!("}}"));
    out
}

#[allow(dead_code)]
pub fn render_stark_verifier_template(
    const_root: &[u64],
    stark_info: &CircomStarkInfo,
    options: StarkVerifierOptions,
) -> String {
    assert_eq!(const_root.len(), 4, "const root must contain four field elements");
    let verifier_name = suffixed_name("StarkVerifier", stark_info.airgroup_id);
    let transcript_name = suffixed_name("Transcript", stark_info.airgroup_id);
    let verify_evaluations_name = suffixed_name("VerifyEvaluations", stark_info.airgroup_id);
    let calculate_fri_pol_name = suffixed_name("CalculateFRIPolValue", stark_info.airgroup_id);
    let verify_query_name = suffixed_name("VerifyQuery", stark_info.airgroup_id);
    let verify_fri_name = suffixed_name("VerifyFRI", stark_info.airgroup_id);
    let verify_final_pol_name = suffixed_name("VerifyFinalPol", stark_info.airgroup_id);
    let q_stage = stark_info.q_stage();
    let steps = &stark_info.stark_struct.steps;
    let mut out = String::new();

    line(&mut out, format_args!("template {verifier_name}() {{"));
    if stark_info.n_publics > 0 {
        line(
            &mut out,
            format_args!(
                "    signal input publics[{}]; // publics polynomials",
                stark_info.n_publics
            ),
        );
    }
    if !stark_info.airgroup_values_map.is_empty() {
        line(
            &mut out,
            format_args!(
                "    signal input airgroupvalues[{}][3]; // airgroupvalue values",
                stark_info.airgroup_values_map.len()
            ),
        );
    }
    if !stark_info.air_values_map.is_empty() {
        line(
            &mut out,
            format_args!(
                "    signal input airvalues[{}][3]; // air values",
                stark_info.air_values_map.len()
            ),
        );
    }
    if !stark_info.proof_values_map.is_empty() {
        line(
            &mut out,
            format_args!(
                "    signal input proofvalues[{}][3]; // air values",
                stark_info.proof_values_map.len()
            ),
        );
    }
    for stage in 1..=stark_info.n_stages {
        line(
            &mut out,
            format_args!("    signal input root{stage}[4]; // Merkle tree root of stage {stage}"),
        );
    }
    line(
        &mut out,
        format_args!(
            "    signal input root{q_stage}[4]; // Merkle tree root of the evaluations of the quotient Q1 and Q2 polynomials"
        ),
    );
    if options.verkey_input {
        line(
            &mut out,
            format_args!("    signal input rootC[4]; // Merkle tree root of the evaluations of constant polynomials"),
        );
    } else if options.input_challenges {
        line(
            &mut out,
            format_args!(
                "    signal output rootC[4] <== [{}]; // Merkle tree root of the evaluations of constant polynomials",
                join_u64(const_root)
            ),
        );
    } else {
        line(
            &mut out,
            format_args!(
                "    signal rootC[4] <== [{}]; // Merkle tree root of the evaluations of constant polynomials",
                join_u64(const_root)
            ),
        );
    }
    out.push('\n');
    line(
        &mut out,
        format_args!(
            "    signal input evals[{}][3]; // Evaluations of the set polynomials at a challenge value z and gz",
            stark_info.ev_map.len()
        ),
    );
    out.push('\n');

    for stage in 1..=stark_info.n_stages {
        let width = stark_info.map_section_width(&format!("cm{stage}"));
        if width > 0 {
            line(
                &mut out,
                format_args!(
                    "    signal input s0_vals{stage}[{}][{width}];",
                    stark_info.n_queries()
                ),
            );
        }
    }
    line(
        &mut out,
        format_args!(
            "    signal input s0_vals{q_stage}[{}][{}];",
            stark_info.n_queries(),
            stark_info.map_section_width(&format!("cm{q_stage}"))
        ),
    );
    line(
        &mut out,
        format_args!(
            "    signal input s0_valsC[{}][{}];",
            stark_info.n_queries(),
            stark_info.n_constants
        ),
    );
    for commit in &stark_info.custom_commits {
        line(
            &mut out,
            format_args!(
                "    signal input s0_vals_{}_0[{}][{}];",
                commit.name,
                stark_info.n_queries(),
                stark_info.map_section_width(&format!("{}0", commit.name))
            ),
        );
    }
    out.push('\n');

    render_s0_sibling_inputs(&mut out, stark_info);
    out.push('\n');

    let mut si_roots = Vec::new();
    for step in 1..steps.len() {
        si_roots.push(format!("s{step}_root"));
        line(&mut out, format_args!("    signal input s{step}_root[4];"));
    }
    out.push('\n');
    for step in 1..steps.len() {
        let vals_width = pow2_u64(steps[step - 1].n_bits - steps[step].n_bits) * 3;
        line(
            &mut out,
            format_args!(
                "    signal input s{step}_vals[{}][{vals_width}];",
                stark_info.n_queries()
            ),
        );
        line(
            &mut out,
            format_args!(
                "    signal input s{step}_siblings[{}][{}][{}];",
                stark_info.n_queries(),
                stark_info.step_sibling_levels(step),
                stark_info.sibling_width()
            ),
        );
        if stark_info.stark_struct.last_level_verification > 0 {
            line(
                &mut out,
                format_args!(
                    "    signal input s{step}_last_mt_levels[{}][4];",
                    stark_info.last_level_size()
                ),
            );
        }
    }
    out.push('\n');
    let final_pol_size = pow2_u64(steps.last().map(|step| step.n_bits).unwrap_or(0));
    line(&mut out, format_args!("    signal input finalPol[{final_pol_size}][3];"));
    if stark_info.stark_struct.pow_bits > 0 {
        line(&mut out, format_args!("    signal input nonce;"));
    }
    out.push('\n');

    line(&mut out, format_args!("    signal {{binary}} enabled;"));
    if options.enable_input {
        line(&mut out, format_args!("    signal input enable;"));
        line(&mut out, format_args!("    enable * (enable -1) === 0;"));
        line(&mut out, format_args!("    enabled <== enable;"));
    } else {
        line(&mut out, format_args!("    enabled <== 1;"));
    }
    out.push('\n');
    if options.input_challenges {
        line(&mut out, format_args!("    signal input globalChallenge[3];"));
        out.push('\n');
    }

    if options.multi_fri {
        line(&mut out, format_args!("    signal output queryVals[{}][3];", stark_info.n_queries()));
    } else {
        line(&mut out, format_args!("    signal queryVals[{}][3];", stark_info.n_queries()));
    }
    out.push('\n');

    let mut challenge_names = Vec::new();
    for stage in 1..=stark_info.n_stages {
        let count = stark_info.challenge_count(stage as u64);
        if count > 0 {
            line(&mut out, format_args!("    signal challengesStage{stage}[{count}][3];"));
            challenge_names.push(format!("challengesStage{stage}"));
        }
    }
    line(&mut out, format_args!("    signal challengeQ[3];"));
    line(&mut out, format_args!("    signal challengeXi[3];"));
    line(&mut out, format_args!("    signal challengesFRI[2][3];"));
    challenge_names.extend([
        "challengeQ".to_string(),
        "challengeXi".to_string(),
        "challengesFRI".to_string(),
    ]);
    line(&mut out, format_args!("    signal challengesFRISteps[{}][3];", steps.len() + 1));
    line(
        &mut out,
        format_args!(
            "    signal {{binary}} queriesFRI[{}][{}];",
            stark_info.n_queries(),
            steps[0].n_bits
        ),
    );
    out.push('\n');

    let mut transcript_inputs = Vec::new();
    if !options.input_challenges {
        if stark_info.n_publics > 0 {
            transcript_inputs.push("publics".to_string());
        }
        transcript_inputs.push("rootC".to_string());
        transcript_inputs.push("root1".to_string());
    } else {
        transcript_inputs.push("globalChallenge".to_string());
    }
    if !stark_info.air_values_map.is_empty() {
        transcript_inputs.push("airvalues".to_string());
    }
    for stage in 2..=stark_info.n_stages {
        transcript_inputs.push(format!("root{stage}"));
    }
    transcript_inputs.push(format!("root{q_stage}"));
    transcript_inputs.push("evals".to_string());
    transcript_inputs.extend(si_roots.iter().cloned());
    transcript_inputs.push("finalPol".to_string());
    if stark_info.stark_struct.pow_bits > 0 {
        transcript_inputs.push("nonce".to_string());
    }
    transcript_inputs.push("enabled".to_string());
    line(
        &mut out,
        format_args!(
            "    ({},challengesFRISteps,queriesFRI) <== {transcript_name}()({});",
            challenge_names.join(","),
            transcript_inputs.join(",")
        ),
    );
    out.push('\n');

    let mut verify_eval_inputs = Vec::new();
    for stage in 1..=stark_info.n_stages {
        if stark_info.challenge_count(stage as u64) > 0 {
            verify_eval_inputs.push(format!("challengesStage{stage}"));
        }
    }
    verify_eval_inputs.extend([
        "challengeQ".to_string(),
        "challengeXi".to_string(),
        "evals".to_string(),
    ]);
    if stark_info.n_publics > 0 {
        verify_eval_inputs.push("publics".to_string());
    }
    if !stark_info.airgroup_values_map.is_empty() {
        verify_eval_inputs.push("airgroupvalues".to_string());
    }
    if !stark_info.air_values_map.is_empty() {
        verify_eval_inputs.push("airvalues".to_string());
    }
    if !stark_info.proof_values_map.is_empty() {
        verify_eval_inputs.push("proofvalues".to_string());
    }
    verify_eval_inputs.push("enabled".to_string());
    line(
        &mut out,
        format_args!("    {verify_evaluations_name}()({});", verify_eval_inputs.join(", ")),
    );
    out.push('\n');

    render_preprocess_values(&mut out, stark_info);
    out.push('\n');
    render_merkle_verifications(&mut out, stark_info);
    out.push('\n');
    render_fri_polynomial_checks(
        &mut out,
        stark_info,
        &calculate_fri_pol_name,
        &verify_query_name,
        &verify_fri_name,
    );
    out.push('\n');
    line(&mut out, format_args!("    {verify_final_pol_name}()(finalPol, enabled);"));
    line(&mut out, format_args!("}}"));
    if !options.skip_main {
        out.push('\n');
        if stark_info.n_publics > 0 {
            line(&mut out, format_args!("component main {{public [publics]}}= {verifier_name}();"));
        } else {
            line(&mut out, format_args!("component main = {verifier_name}();"));
        }
    }
    out
}

fn render_verify_evaluations_template(
    stark_info: &CircomStarkInfo,
    verifier_info: &CircomVerifierInfo,
    chunks: &ExpressionChunks,
) -> String {
    let name = suffixed_name("VerifyEvaluations", stark_info.airgroup_id);
    let q_stage = stark_info.q_stage();
    let mut inputs = Vec::new();
    let mut out = String::new();
    line(&mut out, format_args!("template {name}() {{"));
    render_challenge_stage_inputs(&mut out, stark_info, Some(&mut inputs));
    line(&mut out, format_args!("    signal input challengeQ[3];"));
    inputs.push("challengeQ".to_string());
    line(&mut out, format_args!("    signal input challengeXi[3];"));
    inputs.push("challengeXi".to_string());
    line(&mut out, format_args!("    signal input evals[{}][3];", stark_info.ev_map.len()));
    inputs.push("evals".to_string());
    render_optional_value_inputs(&mut out, stark_info, Some(&mut inputs));
    line(&mut out, format_args!("    signal input {{binary}} enable;"));
    out.push('\n');

    line(&mut out, format_args!("    signal zMul[{}][3];", stark_info.stark_struct.n_bits));
    line(
        &mut out,
        format_args!("    for (var i=0; i< {} ; i++) {{", stark_info.stark_struct.n_bits),
    );
    line(&mut out, format_args!("        if(i==0){{"));
    line(&mut out, format_args!("            zMul[i] <== CMul()(challengeXi, challengeXi);"));
    line(&mut out, format_args!("        }} else {{"));
    line(&mut out, format_args!("            zMul[i] <== CMul()(zMul[i-1], zMul[i-1]);"));
    line(&mut out, format_args!("        }}"));
    line(&mut out, format_args!("    }}"));
    out.push('\n');
    line(
        &mut out,
        format_args!(
            "    signal Z[3] <== [zMul[{}][0] - 1, zMul[{}][1], zMul[{}][2]];",
            stark_info.stark_struct.n_bits - 1,
            stark_info.stark_struct.n_bits - 1,
            stark_info.stark_struct.n_bits - 1
        ),
    );
    line(&mut out, format_args!("    signal Zh[3] <== CInv()(Z);"));
    inputs.push("Zh".to_string());
    out.push('\n');

    if stark_info.has_boundary("firstRow") {
        line(
            &mut out,
            format_args!("    signal Zfirst[3] <== CInv()([challengeXi[0] - 1, challengeXi[1], challengeXi[2]]);"),
        );
        inputs.push("Zfirst".to_string());
        out.push('\n');
    }
    if stark_info.has_boundary("lastRow") {
        let root = goldilocks_pow(
            root_at(stark_info.stark_struct.n_bits),
            pow2_u64(stark_info.stark_struct.n_bits) - 1,
        );
        line(
            &mut out,
            format_args!("    signal Zlast[3] <== CInv()([challengeXi[0] - {root}, challengeXi[1], challengeXi[2]]);"),
        );
        inputs.push("Zlast".to_string());
        out.push('\n');
    }
    for (idx, frame) in stark_info.frame_boundaries().iter().enumerate() {
        let offset_min = frame.offset_min.unwrap_or(0);
        let offset_max = frame.offset_max.unwrap_or(0);
        line(&mut out, format_args!("    signal Zframe{idx}[{}][3];", offset_min + offset_max));
        inputs.push(format!("Zframe{idx}"));
        let mut c = 0u32;
        for j in 0..offset_min {
            let root = goldilocks_pow(root_at(stark_info.stark_struct.n_bits), j as u64);
            render_zframe_step(&mut out, idx, c, root);
            c += 1;
        }
        for _j in 0..offset_max {
            let root = goldilocks_pow(
                root_at(stark_info.stark_struct.n_bits),
                pow2_u64(stark_info.stark_struct.n_bits) - idx as u64 - 1,
            );
            render_zframe_step(&mut out, idx, c, root);
            c += 1;
        }
        out.push('\n');
    }

    for (idx, chunk) in chunks.chunks.iter().enumerate() {
        for output in &chunk.outputs {
            render_tmp_declaration(&mut out, "", *output, &chunks.tmps);
        }
        let outputs = join_tmp_names(&chunk.outputs);
        let mut call_inputs = inputs.clone();
        call_inputs.extend(chunk.inputs.iter().map(|tmp| format!("tmp_{tmp}")));
        line(
            &mut out,
            format_args!(
                "    ({outputs}) <== VerifyEvaluationsChunks{idx}()({});",
                call_inputs.join(",")
            ),
        );
    }
    out.push('\n');

    let q_index = stark_info
        .cm_pols_map
        .iter()
        .position(|pol| pol.stage == q_stage && pol.stage_id.unwrap_or(u64::MAX) == 0)
        .expect("q polynomial index");
    let ev_id = stark_info
        .ev_map
        .iter()
        .position(|ev| ev.ev_type == "cm" && ev.id == q_index as u64)
        .expect("q evaluation id");
    line(&mut out, format_args!("    signal xAcc[{}][3];", stark_info.q_deg));
    line(&mut out, format_args!("    signal qStep[{}][3];", stark_info.q_deg.saturating_sub(1)));
    line(&mut out, format_args!("    signal qAcc[{}][3];", stark_info.q_deg));
    out.push('\n');
    line(&mut out, format_args!("    for (var i=0; i< {}; i++) {{", stark_info.q_deg));
    line(&mut out, format_args!("        if (i==0) {{"));
    line(&mut out, format_args!("            xAcc[0] <== [1, 0, 0];"));
    line(&mut out, format_args!("            qAcc[0] <== evals[{ev_id}+i];"));
    line(&mut out, format_args!("        }} else {{"));
    line(
        &mut out,
        format_args!(
            "            xAcc[i] <== CMul()(xAcc[i-1], zMul[{}]);",
            stark_info.stark_struct.n_bits - 1
        ),
    );
    line(&mut out, format_args!("            qStep[i-1] <== CMul()(xAcc[i], evals[{ev_id}+i]);"));
    line(&mut out, format_args!("            qAcc[i][0] <== qAcc[i-1][0] + qStep[i-1][0];"));
    line(&mut out, format_args!("            qAcc[i][1] <== qAcc[i-1][1] + qStep[i-1][1];"));
    line(&mut out, format_args!("            qAcc[i][2] <== qAcc[i-1][2] + qStep[i-1][2];"));
    line(&mut out, format_args!("        }}"));
    line(&mut out, format_args!("    }}"));
    out.push('\n');
    let result_tmp = last_dest_tmp_id(&verifier_info.q_verifier.code);
    line(
        &mut out,
        format_args!(
            "    enable * (tmp_{result_tmp}[0] - qAcc[{}][0]) === 0;",
            stark_info.q_deg - 1
        ),
    );
    line(
        &mut out,
        format_args!(
            "    enable * (tmp_{result_tmp}[1] - qAcc[{}][1]) === 0;",
            stark_info.q_deg - 1
        ),
    );
    line(
        &mut out,
        format_args!(
            "    enable * (tmp_{result_tmp}[2] - qAcc[{}][2]) === 0;",
            stark_info.q_deg - 1
        ),
    );
    line(&mut out, format_args!("}}"));
    out
}

fn render_calculate_fri_pol_template(
    stark_info: &CircomStarkInfo,
    verifier_info: &CircomVerifierInfo,
    chunks: &ExpressionChunks,
) -> String {
    let name = suffixed_name("CalculateFRIPolValue", stark_info.airgroup_id);
    let mut inputs = Vec::new();
    let mut out = String::new();
    line(&mut out, format_args!("template {name}() {{"));
    line(
        &mut out,
        format_args!(
            "    signal input {{binary}} queriesFRI[{}];",
            stark_info.stark_struct.steps[0].n_bits
        ),
    );
    line(&mut out, format_args!("    signal input challengeXi[3];"));
    line(&mut out, format_args!("    signal input challengesFRI[2][3];"));
    inputs.push("challengesFRI".to_string());
    line(&mut out, format_args!("    signal input evals[{}][3];", stark_info.ev_map.len()));
    inputs.push("evals".to_string());
    render_cm_value_inputs(&mut out, stark_info, Some(&mut inputs));
    line(&mut out, format_args!("    signal input consts[{}];", stark_info.n_constants));
    inputs.push("consts".to_string());
    render_custom_commit_value_inputs(&mut out, stark_info, Some(&mut inputs));
    out.push('\n');
    line(&mut out, format_args!("    signal output queryVals[3];"));
    out.push('\n');
    line(&mut out, format_args!("    signal xacc[{}];", stark_info.stark_struct.steps[0].n_bits));
    line(
        &mut out,
        format_args!(
            "    xacc[0] <== queriesFRI[0]*({GOLDILOCKS_SHIFT} * roots({})-{GOLDILOCKS_SHIFT}) + {GOLDILOCKS_SHIFT};",
            stark_info.stark_struct.steps[0].n_bits
        ),
    );
    line(
        &mut out,
        format_args!("    for (var i=1; i<{}; i++) {{", stark_info.stark_struct.steps[0].n_bits),
    );
    line(
        &mut out,
        format_args!(
            "        xacc[i] <== xacc[i-1] * ( queriesFRI[i]*(roots({} - i) - 1) +1);",
            stark_info.stark_struct.steps[0].n_bits
        ),
    );
    line(&mut out, format_args!("    }}"));
    out.push('\n');
    line(&mut out, format_args!("    signal xDivXSubXi[{}][3];", stark_info.opening_points.len()));
    inputs.push("xDivXSubXi".to_string());
    out.push('\n');
    for (idx, opening) in stark_info.opening_points.iter().enumerate() {
        let root = opening_root(stark_info.stark_struct.n_bits, *opening);
        line(
            &mut out,
            format_args!(
                "    xDivXSubXi[{idx}] <== CInv()([xacc[{}] - {root} * challengeXi[0], - {root} * challengeXi[1], - {root} * challengeXi[2]]);",
                stark_info.stark_struct.steps[0].n_bits - 1
            ),
        );
    }
    out.push('\n');
    for (idx, chunk) in chunks.chunks.iter().enumerate() {
        for output in &chunk.outputs {
            render_tmp_declaration(&mut out, "", *output, &chunks.tmps);
        }
        let outputs = join_tmp_names(&chunk.outputs);
        let mut call_inputs = inputs.clone();
        call_inputs.extend(chunk.inputs.iter().map(|tmp| format!("tmp_{tmp}")));
        line(
            &mut out,
            format_args!(
                "    ({outputs}) <== CalculateFRIPolChunks{idx}()({});",
                call_inputs.join(",")
            ),
        );
    }
    out.push('\n');
    let result_tmp = last_dest_tmp_id(&verifier_info.query_verifier.block.code);
    line(&mut out, format_args!("    queryVals[0] <== tmp_{result_tmp}[0];"));
    line(&mut out, format_args!("    queryVals[1] <== tmp_{result_tmp}[1];"));
    line(&mut out, format_args!("    queryVals[2] <== tmp_{result_tmp}[2];"));
    line(&mut out, format_args!("}}"));
    out
}

fn render_verify_query_template(stark_info: &CircomStarkInfo) -> String {
    let name = suffixed_name("VerifyQuery", stark_info.airgroup_id);
    let mut out = String::new();
    line(&mut out, format_args!("template {name}(currStepBits, nextStepBits) {{"));
    line(&mut out, format_args!("    var nextStep = currStepBits - nextStepBits; "));
    line(
        &mut out,
        format_args!(
            "    signal input {{binary}} queriesFRI[{}];",
            stark_info.stark_struct.steps[0].n_bits
        ),
    );
    line(&mut out, format_args!("    signal input queryVals[3];"));
    line(&mut out, format_args!("    signal input s1_vals[1 << nextStep][3];"));
    line(&mut out, format_args!("    signal input {{binary}} enable;"));
    out.push('\n');
    line(&mut out, format_args!("    signal {{binary}} s0_keys_lowValues[nextStep];"));
    line(&mut out, format_args!("    for(var i = 0; i < nextStep; i++) {{"));
    line(&mut out, format_args!("        s0_keys_lowValues[i] <== queriesFRI[i + nextStepBits];"));
    line(&mut out, format_args!("    }}"));
    out.push('\n');
    line(&mut out, format_args!("    for(var i = 0; i < nextStepBits; i++) {{"));
    line(&mut out, format_args!("        _ <== queriesFRI[i];"));
    line(&mut out, format_args!("    }}"));
    out.push('\n');
    line(
        &mut out,
        format_args!(
            "    signal lowValues[3] <== TreeSelector(nextStep, 3)(s1_vals, s0_keys_lowValues);"
        ),
    );
    out.push('\n');
    line(&mut out, format_args!("    enable * (lowValues[0] - queryVals[0]) === 0;"));
    line(&mut out, format_args!("    enable * (lowValues[1] - queryVals[1]) === 0;"));
    line(&mut out, format_args!("    enable * (lowValues[2] - queryVals[2]) === 0;"));
    line(&mut out, format_args!("}}"));
    out
}

fn render_map_values_template(stark_info: &CircomStarkInfo) -> String {
    let name = suffixed_name("MapValues", stark_info.airgroup_id);
    let mut out = String::new();
    line(&mut out, format_args!("template {name}() {{"));
    render_map_values_raw_inputs(&mut out, stark_info);

    for stage in 1..=stark_info.q_stage() {
        for (idx, pol) in stark_info.cm_pols_map.iter().filter(|pol| pol.stage == stage).enumerate()
        {
            render_map_output(
                &mut out,
                &format!("cm{stage}_{}", pol.stage_id.unwrap_or(idx as u64)),
                pol.dim,
            );
        }
    }
    for (commit_idx, commit) in stark_info.custom_commits.iter().enumerate() {
        for stage in 0..commit.stage_widths.len() as u64 {
            for (idx, pol) in stark_info.custom_commits_map[commit_idx]
                .iter()
                .filter(|pol| pol.stage == stage)
                .enumerate()
            {
                render_map_output(
                    &mut out,
                    &format!(
                        "custom_{}_{}_{}",
                        commit.name,
                        stage,
                        pol.stage_id.unwrap_or(idx as u64)
                    ),
                    pol.dim,
                );
            }
        }
    }
    out.push('\n');

    for (commit_idx, commit) in stark_info.custom_commits.iter().enumerate() {
        for stage in 0..commit.stage_widths.len() as u64 {
            for (idx, pol) in stark_info.custom_commits_map[commit_idx]
                .iter()
                .filter(|pol| pol.stage == stage)
                .enumerate()
            {
                let output = format!(
                    "custom_{}_{}_{}",
                    commit.name,
                    stage,
                    pol.stage_id.unwrap_or(idx as u64)
                );
                let input = format!("vals_{}_0", commit.name);
                render_map_assignment(&mut out, &output, &input, pol);
            }
        }
    }
    out.push('\n');
    for stage in 1..=stark_info.q_stage() {
        for (idx, pol) in stark_info.cm_pols_map.iter().filter(|pol| pol.stage == stage).enumerate()
        {
            let output = format!("cm{stage}_{}", pol.stage_id.unwrap_or(idx as u64));
            let input = format!("vals{stage}");
            render_map_assignment(&mut out, &output, &input, pol);
        }
    }
    line(&mut out, format_args!("}}"));
    out
}

fn render_challenge_stage_inputs(
    out: &mut String,
    stark_info: &CircomStarkInfo,
    mut names: Option<&mut Vec<String>>,
) {
    for stage in 1..=stark_info.n_stages {
        let count = stark_info.challenge_count(stage as u64);
        if count == 0 {
            continue;
        }
        line(out, format_args!("    signal input challengesStage{stage}[{count}][3];"));
        if let Some(names) = names.as_mut() {
            names.push(format!("challengesStage{stage}"));
        }
    }
}

fn render_s0_sibling_inputs(out: &mut String, stark_info: &CircomStarkInfo) {
    for stage in 1..=stark_info.n_stages {
        if stark_info.map_section_width(&format!("cm{stage}")) == 0 {
            continue;
        }
        line(
            out,
            format_args!(
                "    signal input s0_siblings{stage}[{}][{}][{}];",
                stark_info.n_queries(),
                stark_info.s0_sibling_levels(),
                stark_info.sibling_width()
            ),
        );
        if stark_info.stark_struct.last_level_verification > 0 {
            line(
                out,
                format_args!(
                    "    signal input s0_last_mt_levels{stage}[{}][4];",
                    stark_info.last_level_size()
                ),
            );
        }
    }
    let q_stage = stark_info.q_stage();
    line(
        out,
        format_args!(
            "    signal input s0_siblings{q_stage}[{}][{}][{}];",
            stark_info.n_queries(),
            stark_info.s0_sibling_levels(),
            stark_info.sibling_width()
        ),
    );
    if stark_info.stark_struct.last_level_verification > 0 {
        line(
            out,
            format_args!(
                "    signal input s0_last_mt_levels{q_stage}[{}][4];",
                stark_info.last_level_size()
            ),
        );
    }
    line(
        out,
        format_args!(
            "    signal input s0_siblingsC[{}][{}][{}];",
            stark_info.n_queries(),
            stark_info.s0_sibling_levels(),
            stark_info.sibling_width()
        ),
    );
    if stark_info.stark_struct.last_level_verification > 0 {
        line(
            out,
            format_args!(
                "    signal input s0_last_mt_levelsC[{}][4];",
                stark_info.last_level_size()
            ),
        );
    }
    for commit in &stark_info.custom_commits {
        line(
            out,
            format_args!(
                "    signal input s0_siblings_{}_0[{}][{}][{}];",
                commit.name,
                stark_info.n_queries(),
                stark_info.s0_sibling_levels(),
                stark_info.sibling_width()
            ),
        );
        if stark_info.stark_struct.last_level_verification > 0 {
            line(
                out,
                format_args!(
                    "    signal input s0_last_mt_levels_{}_0[{}][4];",
                    commit.name,
                    stark_info.last_level_size()
                ),
            );
        }
    }
}

fn vadcop_public_input_names(
    vadcop_info: &CircomVadcopInfo,
    airgroup_id: usize,
    prefix: &str,
) -> Vec<String> {
    let prefix = prefixed(prefix);
    let mut names = vec![format!("{prefix}circuitType"), format!("{prefix}aggregatedProofs")];
    if vadcop_info.agg_types.get(airgroup_id).map(Vec::is_empty).unwrap_or(true) == false {
        names.push(format!("{prefix}aggregationTypes"));
        names.push(format!("{prefix}airgroupvalues"));
    }
    names.push(format!("{prefix}stage1Hash"));
    names
}

fn render_preprocess_values(out: &mut String, stark_info: &CircomStarkInfo) {
    let q_stage = stark_info.q_stage();
    let steps = &stark_info.stark_struct.steps;
    for stage in 1..=stark_info.n_stages {
        let width = stark_info.map_section_width(&format!("cm{stage}"));
        if width > 0 {
            line(
                out,
                format_args!("    var s0_vals{stage}_p[{}][{width}][1];", stark_info.n_queries()),
            );
        }
    }
    line(
        out,
        format_args!(
            "    var s0_vals{q_stage}_p[{}][{}][1];",
            stark_info.n_queries(),
            stark_info.map_section_width(&format!("cm{q_stage}"))
        ),
    );
    line(
        out,
        format_args!(
            "    var s0_valsC_p[{}][{}][1];",
            stark_info.n_queries(),
            stark_info.n_constants
        ),
    );
    for commit in &stark_info.custom_commits {
        line(
            out,
            format_args!(
                "    var s0_vals_{}_0_p[{}][{}][1];",
                commit.name,
                stark_info.n_queries(),
                stark_info.map_section_width(&format!("{}0", commit.name))
            ),
        );
    }
    for step in 0..steps.len() {
        let exponent =
            if step == 0 { 1 } else { pow2_u64(steps[step - 1].n_bits - steps[step].n_bits) };
        line(
            out,
            format_args!("    var s{step}_vals_p[{}][{exponent}][3]; ", stark_info.n_queries()),
        );
    }
    out.push('\n');
    line(out, format_args!("    for (var q=0; q<{}; q++) {{", stark_info.n_queries()));
    for stage in 1..=stark_info.n_stages {
        let width = stark_info.map_section_width(&format!("cm{stage}"));
        if width > 0 {
            line(out, format_args!("        for (var i = 0; i < {width}; i++) {{"));
            line(
                out,
                format_args!("            s0_vals{stage}_p[q][i][0] = s0_vals{stage}[q][i];"),
            );
            line(out, format_args!("        }}"));
        }
    }
    let q_width = stark_info.map_section_width(&format!("cm{q_stage}"));
    line(out, format_args!("        for (var i = 0; i < {q_width}; i++) {{"));
    line(out, format_args!("            s0_vals{q_stage}_p[q][i][0] = s0_vals{q_stage}[q][i];"));
    line(out, format_args!("        }}"));
    line(out, format_args!("        for (var i = 0; i < {}; i++) {{", stark_info.n_constants));
    line(out, format_args!("            s0_valsC_p[q][i][0] = s0_valsC[q][i];"));
    line(out, format_args!("        }}"));
    for commit in &stark_info.custom_commits {
        let width = stark_info.map_section_width(&format!("{}0", commit.name));
        line(out, format_args!("        for (var i = 0; i < {width}; i++) {{"));
        line(
            out,
            format_args!(
                "            s0_vals_{}_0_p[q][i][0] = s0_vals_{}_0[q][i];",
                commit.name, commit.name
            ),
        );
        line(out, format_args!("        }}"));
    }
    out.push('\n');
    line(out, format_args!("        for(var e=0; e < 3; e++) {{"));
    for step in 1..steps.len() {
        let exponent = pow2_u64(steps[step - 1].n_bits - steps[step].n_bits);
        line(out, format_args!("            for(var c=0; c < {exponent}; c++) {{"));
        line(
            out,
            format_args!("                s{step}_vals_p[q][c][e] = s{step}_vals[q][c*3+e];"),
        );
        line(out, format_args!("            }}"));
    }
    line(out, format_args!("        }}"));
    line(out, format_args!("    }}"));
}

fn render_merkle_verifications(out: &mut String, stark_info: &CircomStarkInfo) {
    let q_stage = stark_info.q_stage();
    let arity = stark_info.stark_struct.merkle_tree_arity;
    let arity_bits = stark_info.arity_bits();
    let s0_tree_depth = ceil_div(stark_info.stark_struct.steps[0].n_bits, arity_bits);
    line(
        out,
        format_args!(
            "    signal {{binary}} queriesFRIBits[{}][{}][{}];",
            stark_info.n_queries(),
            s0_tree_depth,
            arity_bits
        ),
    );
    line(out, format_args!("    for(var i = 0; i < {}; i++) {{", stark_info.n_queries()));
    line(out, format_args!("        for(var j = 0; j < {s0_tree_depth}; j++) {{"));
    line(out, format_args!("            for(var k = 0; k < {arity_bits}; k++) {{"));
    line(
        out,
        format_args!(
            "                if (k + j * {arity_bits} >= {}) {{",
            stark_info.stark_struct.steps[0].n_bits
        ),
    );
    line(out, format_args!("                    queriesFRIBits[i][j][k] <== 0;"));
    line(out, format_args!("                }} else {{"));
    line(
        out,
        format_args!(
            "                    queriesFRIBits[i][j][k] <== queriesFRI[i][j*{arity_bits} + k];"
        ),
    );
    line(out, format_args!("                }}"));
    line(out, format_args!("            }}"));
    line(out, format_args!("        }}"));
    line(out, format_args!("    }}"));
    out.push('\n');

    for stage in 1..=stark_info.n_stages {
        let width = stark_info.map_section_width(&format!("cm{stage}"));
        if width == 0 {
            continue;
        }
        render_s0_merkle_query_loop(
            out,
            stark_info,
            1,
            width,
            &format!("s0_vals{stage}_p[q]"),
            &format!("s0_siblings{stage}[q]"),
            &format!("root{stage}"),
            &format!("s0_last_mt_levels{stage}"),
        );
    }
    render_s0_merkle_query_loop(
        out,
        stark_info,
        1,
        stark_info.map_section_width(&format!("cm{q_stage}")),
        &format!("s0_vals{q_stage}_p[q]"),
        &format!("s0_siblings{q_stage}[q]"),
        &format!("root{q_stage}"),
        &format!("s0_last_mt_levels{q_stage}"),
    );
    render_s0_merkle_query_loop(
        out,
        stark_info,
        1,
        stark_info.n_constants as u64,
        "s0_valsC_p[q]",
        "s0_siblingsC[q]",
        "rootC",
        "s0_last_mt_levelsC",
    );
    for commit in &stark_info.custom_commits {
        line(
            out,
            format_args!(
                "    signal root_{}_0[4] <== [publics[{}], publics[{}], publics[{}], publics[{}]];",
                commit.name,
                commit.public_values.first().map(|value| value.idx).unwrap_or(0),
                commit.public_values.get(1).map(|value| value.idx).unwrap_or(0),
                commit.public_values.get(2).map(|value| value.idx).unwrap_or(0),
                commit.public_values.get(3).map(|value| value.idx).unwrap_or(0)
            ),
        );
        render_s0_merkle_query_loop(
            out,
            stark_info,
            1,
            stark_info.map_section_width(&format!("{}0", commit.name)),
            &format!("s0_vals_{}_0_p[q]", commit.name),
            &format!("s0_siblings_{}_0[q]", commit.name),
            &format!("root_{}_0", commit.name),
            &format!("s0_last_mt_levels_{}_0", commit.name),
        );
    }

    for step in 1..stark_info.stark_struct.steps.len() {
        let step_bits = stark_info.stark_struct.steps[step].n_bits;
        let tree_depth = ceil_div(step_bits, arity_bits);
        let values = pow2_u64(
            stark_info.stark_struct.steps[step - 1].n_bits
                - stark_info.stark_struct.steps[step].n_bits,
        );
        line(
            out,
            format_args!(
                "    signal {{binary}} s{step}_keys_merkle_bits[{}][{tree_depth}][{arity_bits}];",
                stark_info.n_queries()
            ),
        );
        line(out, format_args!("    for (var q=0; q<{}; q++) {{", stark_info.n_queries()));
        line(out, format_args!("        for(var j = 0; j < {tree_depth}; j++) {{"));
        line(out, format_args!("            for(var k = 0; k < {arity_bits}; k++) {{"));
        line(out, format_args!("                if (k + j * {arity_bits} >= {step_bits}) {{"));
        line(out, format_args!("                    s{step}_keys_merkle_bits[q][j][k] <== 0;"));
        line(out, format_args!("                }} else {{"));
        line(
            out,
            format_args!(
                "                    s{step}_keys_merkle_bits[q][j][k] <== queriesFRI[q][j*{arity_bits} + k];"
            ),
        );
        line(out, format_args!("                }}"));
        line(out, format_args!("            }}"));
        line(out, format_args!("        }}"));
        if stark_info.stark_struct.last_level_verification > 0 {
            let levels = tree_depth.saturating_sub(stark_info.stark_struct.last_level_verification);
            if levels == 0 {
                line(
                    out,
                    format_args!(
                        "        VerifyMerkleHashUntilLevelEmpty(3, {values}, {arity}, {}, {})(s{step}_vals_p[q], s{step}_keys_merkle_bits[q], s{step}_last_mt_levels, enabled);",
                        stark_info.stark_struct.last_level_verification,
                        pow2_u64(step_bits)
                    ),
                );
            } else {
                line(
                    out,
                    format_args!(
                        "        VerifyMerkleHashUntilLevel(3, {values}, {arity}, {levels}, {}, {})(s{step}_vals_p[q], s{step}_siblings[q], s{step}_keys_merkle_bits[q], s{step}_last_mt_levels, enabled);",
                        stark_info.stark_struct.last_level_verification,
                        pow2_u64(step_bits)
                    ),
                );
            }
        } else {
            line(
                out,
                format_args!(
                    "        VerifyMerkleHash(3, {values}, {arity}, {tree_depth})(s{step}_vals_p[q], s{step}_siblings[q], s{step}_keys_merkle_bits[q], s{step}_root, enabled);"
                ),
            );
        }
        line(out, format_args!("    }}"));
    }

    if stark_info.stark_struct.last_level_verification > 0 {
        for stage in 1..=stark_info.n_stages {
            if stark_info.map_section_width(&format!("cm{stage}")) > 0 {
                render_merkle_root_check(
                    out,
                    stark_info,
                    &format!("s0_last_mt_levels{stage}"),
                    &format!("root{stage}"),
                    pow2_u64(stark_info.stark_struct.n_bits_ext),
                );
            }
        }
        render_merkle_root_check(
            out,
            stark_info,
            &format!("s0_last_mt_levels{q_stage}"),
            &format!("root{q_stage}"),
            pow2_u64(stark_info.stark_struct.n_bits_ext),
        );
        render_merkle_root_check(
            out,
            stark_info,
            "s0_last_mt_levelsC",
            "rootC",
            pow2_u64(stark_info.stark_struct.n_bits_ext),
        );
        for commit in &stark_info.custom_commits {
            render_merkle_root_check(
                out,
                stark_info,
                &format!("s0_last_mt_levels_{}_0", commit.name),
                &format!("root_{}_0", commit.name),
                pow2_u64(stark_info.stark_struct.n_bits_ext),
            );
        }
        for step in 1..stark_info.stark_struct.steps.len() {
            render_merkle_root_check(
                out,
                stark_info,
                &format!("s{step}_last_mt_levels"),
                &format!("s{step}_root"),
                pow2_u64(stark_info.stark_struct.steps[step].n_bits),
            );
        }
    }
}

fn render_s0_merkle_query_loop(
    out: &mut String,
    stark_info: &CircomStarkInfo,
    dim: u64,
    width: u64,
    values: &str,
    siblings: &str,
    root: &str,
    last_levels: &str,
) {
    let arity = stark_info.stark_struct.merkle_tree_arity;
    let tree_depth = ceil_div(stark_info.stark_struct.steps[0].n_bits, stark_info.arity_bits());
    line(out, format_args!("    for (var q=0; q<{}; q++) {{", stark_info.n_queries()));
    if stark_info.stark_struct.last_level_verification > 0 {
        line(
            out,
            format_args!(
                "        VerifyMerkleHashUntilLevel({dim}, {width}, {arity}, {}, {}, {} )({values}, {siblings}, queriesFRIBits[q], {last_levels}, enabled);",
                tree_depth.saturating_sub(stark_info.stark_struct.last_level_verification),
                stark_info.stark_struct.last_level_verification,
                pow2_u64(stark_info.stark_struct.n_bits_ext)
            ),
        );
    } else {
        line(
            out,
            format_args!(
                "        VerifyMerkleHash({dim}, {width}, {arity}, {tree_depth})({values}, {siblings}, queriesFRIBits[q], {root}, enabled);"
            ),
        );
    }
    line(out, format_args!("    }}"));
}

fn render_merkle_root_check(
    out: &mut String,
    stark_info: &CircomStarkInfo,
    levels: &str,
    root: &str,
    tree_size: u64,
) {
    line(
        out,
        format_args!(
            "    VerifyMerkleRoot({}, {}, {tree_size})({levels}, {root}, enabled);",
            stark_info.stark_struct.last_level_verification,
            stark_info.stark_struct.merkle_tree_arity
        ),
    );
}

fn render_fri_polynomial_checks(
    out: &mut String,
    stark_info: &CircomStarkInfo,
    calculate_fri_pol_name: &str,
    verify_query_name: &str,
    verify_fri_name: &str,
) {
    let q_stage = stark_info.q_stage();
    let steps = &stark_info.stark_struct.steps;
    line(out, format_args!("    for (var q=0; q<{}; q++) {{", stark_info.n_queries()));
    let mut query_vals = Vec::new();
    for stage in 1..=stark_info.n_stages {
        if stark_info.map_section_width(&format!("cm{stage}")) > 0 {
            query_vals.push(format!("s0_vals{stage}[q]"));
        }
    }
    query_vals.push(format!("s0_vals{q_stage}[q]"));
    query_vals.push("s0_valsC[q]".to_string());
    for commit in &stark_info.custom_commits {
        query_vals.push(format!("s0_vals_{}_0[q]", commit.name));
    }
    line(
        out,
        format_args!(
            "        queryVals[q] <== {calculate_fri_pol_name}()(queriesFRI[q], challengeXi, challengesFRI, evals, {});",
            query_vals.join(", ")
        ),
    );
    line(out, format_args!("    }}"));
    out.push('\n');

    for step in 1..steps.len() {
        line(
            out,
            format_args!(
                "    signal {{binary}} s{step}_queriesFRI[{}][{}];",
                stark_info.n_queries(),
                steps[step].n_bits
            ),
        );
    }
    out.push('\n');
    line(out, format_args!("    for (var q=0; q<{}; q++) {{", stark_info.n_queries()));
    let next_vals_pol = if steps.len() > 1 { "s1_vals_p[q]" } else { "finalPol" };
    let next_step = if steps.len() > 1 { steps[1].n_bits } else { 0 };
    line(
        out,
        format_args!(
            "        {verify_query_name}({}, {next_step})(queriesFRI[q], queryVals[q], {next_vals_pol}, enabled);",
            steps[0].n_bits
        ),
    );
    out.push('\n');
    for step in 1..steps.len() {
        line(
            out,
            format_args!(
                "        for(var i = 0; i < {}; i++) {{ s{step}_queriesFRI[q][i] <== queriesFRI[q][i]; }}  ",
                steps[step].n_bits
            ),
        );
        let next_pol = if step < steps.len() - 1 {
            format!("s{}_vals_p[q]", step + 1)
        } else {
            "finalPol".to_string()
        };
        let next_step_bits = if step < steps.len() - 1 { steps[step + 1].n_bits } else { 0 };
        let exponent = pow2_u64(stark_info.stark_struct.n_bits_ext - steps[step - 1].n_bits);
        let e0 = goldilocks_inv(goldilocks_pow(GOLDILOCKS_SHIFT, exponent));
        line(
            out,
            format_args!(
                "        {verify_fri_name}({}, {}, {}, {next_step_bits}, {e0})(s{step}_queriesFRI[q], challengesFRISteps[{step}], s{step}_vals_p[q], {next_pol}, enabled);",
                stark_info.stark_struct.n_bits_ext,
                steps[step - 1].n_bits,
                steps[step].n_bits
            ),
        );
    }
    line(out, format_args!("    }}"));
}

fn render_optional_value_inputs(
    out: &mut String,
    stark_info: &CircomStarkInfo,
    mut names: Option<&mut Vec<String>>,
) {
    if stark_info.n_publics > 0 {
        line(out, format_args!("    signal input publics[{}];", stark_info.n_publics));
        if let Some(names) = names.as_mut() {
            names.push("publics".to_string());
        }
    }
    if !stark_info.airgroup_values_map.is_empty() {
        line(
            out,
            format_args!(
                "    signal input airgroupvalues[{}][3];",
                stark_info.airgroup_values_map.len()
            ),
        );
        if let Some(names) = names.as_mut() {
            names.push("airgroupvalues".to_string());
        }
    }
    if !stark_info.air_values_map.is_empty() {
        line(
            out,
            format_args!("    signal input airvalues[{}][3];", stark_info.air_values_map.len()),
        );
        if let Some(names) = names.as_mut() {
            names.push("airvalues".to_string());
        }
    }
    if !stark_info.proof_values_map.is_empty() {
        line(
            out,
            format_args!("    signal input proofvalues[{}][3];", stark_info.proof_values_map.len()),
        );
        if let Some(names) = names.as_mut() {
            names.push("proofvalues".to_string());
        }
    }
}

fn render_boundary_input_declarations(
    out: &mut String,
    stark_info: &CircomStarkInfo,
    mut names: Option<&mut Vec<String>>,
) {
    line(out, format_args!("    signal input Zh[3];"));
    if let Some(names) = names.as_mut() {
        names.push("Zh".to_string());
    }
    if stark_info.has_boundary("firstRow") {
        line(out, format_args!("    signal input Zfirst[3];"));
        if let Some(names) = names.as_mut() {
            names.push("Zfirst".to_string());
        }
    }
    if stark_info.has_boundary("lastRow") {
        line(out, format_args!("    signal input Zlast[3];"));
        if let Some(names) = names.as_mut() {
            names.push("Zlast".to_string());
        }
    }
    for (idx, frame) in stark_info.frame_boundaries().iter().enumerate() {
        let offset_min = frame.offset_min.unwrap_or(0);
        let offset_max = frame.offset_max.unwrap_or(0);
        line(out, format_args!("    signal input Zframe{idx}[{}][3];", offset_min + offset_max));
        if let Some(names) = names.as_mut() {
            names.push(format!("Zframe{idx}"));
        }
    }
}

fn render_cm_value_inputs(
    out: &mut String,
    stark_info: &CircomStarkInfo,
    mut names: Option<&mut Vec<String>>,
) {
    for stage in 1..=stark_info.n_stages {
        let width = stark_info.map_section_width(&format!("cm{stage}"));
        if width == 0 {
            continue;
        }
        line(out, format_args!("    signal input cm{stage}[{width}];"));
        if let Some(names) = names.as_mut() {
            names.push(format!("cm{stage}"));
        }
    }
    let q_stage = stark_info.q_stage();
    let width = stark_info.map_section_width(&format!("cm{q_stage}"));
    line(out, format_args!("    signal input cm{q_stage}[{width}];"));
    if let Some(names) = names.as_mut() {
        names.push(format!("cm{q_stage}"));
    }
}

fn render_custom_commit_value_inputs(
    out: &mut String,
    stark_info: &CircomStarkInfo,
    mut names: Option<&mut Vec<String>>,
) {
    for commit in &stark_info.custom_commits {
        let name = format!("custom_{}_0", commit.name);
        let width = stark_info.map_section_width(&format!("{}0", commit.name));
        line(out, format_args!("    signal input {name}[{width}];"));
        if let Some(names) = names.as_mut() {
            names.push(name);
        }
    }
}

fn render_map_values_raw_inputs(out: &mut String, stark_info: &CircomStarkInfo) {
    for stage in 1..=stark_info.n_stages {
        let width = stark_info.map_section_width(&format!("cm{stage}"));
        if width > 0 {
            line(out, format_args!("    signal input vals{stage}[{width}];"));
        }
    }
    let q_stage = stark_info.q_stage();
    let q_width = stark_info.map_section_width(&format!("cm{q_stage}"));
    line(out, format_args!("    signal input vals{q_stage}[{q_width}];"));
    for commit in &stark_info.custom_commits {
        let width = stark_info.map_section_width(&format!("{}0", commit.name));
        line(out, format_args!("    signal input vals_{}_0[{width}];", commit.name));
    }
}

fn render_map_values_assignments(out: &mut String, stark_info: &CircomStarkInfo) {
    for stage in 1..=stark_info.n_stages {
        if stark_info.map_section_width(&format!("cm{stage}")) > 0 {
            line(out, format_args!("    mapValues.vals{stage} <== cm{stage};"));
        }
    }
    let q_stage = stark_info.q_stage();
    line(out, format_args!("    mapValues.vals{q_stage} <== cm{q_stage};"));
    for commit in &stark_info.custom_commits {
        line(
            out,
            format_args!("    mapValues.vals_{}_0 <== custom_{}_0;", commit.name, commit.name),
        );
    }
}

fn render_tmp_declaration(
    out: &mut String,
    qualifier: &str,
    tmp_id: u64,
    tmps: &BTreeMap<u64, TmpInfo>,
) {
    let dim = tmps.get(&tmp_id).expect("tmp declaration").dim;
    let qualifier = if qualifier.is_empty() { String::new() } else { format!("{qualifier} ") };
    if dim == 1 {
        line(out, format_args!("    signal {qualifier}tmp_{tmp_id};"));
    } else {
        line(out, format_args!("    signal {qualifier}tmp_{tmp_id}[3];"));
    }
}

fn render_map_output(out: &mut String, name: &str, dim: u64) {
    if dim == 1 {
        line(out, format_args!("    signal output {name};"));
    } else {
        line(out, format_args!("    signal output {name}[3];"));
    }
}

fn render_map_assignment(out: &mut String, output: &str, input: &str, pol: &CircomPolMap) {
    let stage_pos = pol.stage_pos.expect("polynomial stagePos");
    if pol.dim == 1 {
        line(out, format_args!("    {output} <== {input}[{stage_pos}];"));
    } else {
        line(
            out,
            format_args!(
                "    {output} <== [{input}[{stage_pos}],{input}[{}] , {input}[{}]];",
                stage_pos + 1,
                stage_pos + 2
            ),
        );
    }
}

fn render_zframe_step(out: &mut String, frame_idx: usize, position: u32, root: u64) {
    if position == 0 {
        line(
            out,
            format_args!("    Zframe{frame_idx}[{position}] <== CMul()(Zh, [challengeXi[0] - {root}, challengeXi[1], challengeXi[2]]);"),
        );
    } else {
        line(
            out,
            format_args!("    Zframe{frame_idx}[{position}] <== CMul()(Zframe{frame_idx}[{}], [challengeXi[0] - {root}, challengeXi[1], challengeXi[2]]);", position - 1),
        );
    }
}

fn join_tmp_names(ids: &[u64]) -> String {
    ids.iter().map(|id| format!("tmp_{id}")).collect::<Vec<_>>().join(",")
}

fn join_u64(values: &[u64]) -> String {
    values.iter().map(u64::to_string).collect::<Vec<_>>().join(",")
}

fn last_dest_tmp_id(code: &[CircomCodeLine]) -> u64 {
    code.last().and_then(|line| line.dest.id).expect("verifier expression result tmp")
}

fn root_at(n_bits: u64) -> u64 {
    GOLDILOCKS_ROOTS[n_bits as usize]
}

fn inv_root_at(n_bits: u64) -> u64 {
    GOLDILOCKS_INV_ROOTS[n_bits as usize]
}

fn opening_root(n_bits: u64, opening: i64) -> u64 {
    if opening >= 0 {
        goldilocks_pow(root_at(n_bits), opening as u64)
    } else {
        goldilocks_pow(inv_root_at(n_bits), opening.unsigned_abs())
    }
}

fn pow2_u64(bits: u64) -> u64 {
    1u64.checked_shl(bits as u32).expect("power of two size")
}

fn goldilocks_pow(mut base: u64, mut exp: u64) -> u64 {
    let mut result = 1u64;
    while exp > 0 {
        if exp & 1 == 1 {
            result = goldilocks_mul(result, base);
        }
        base = goldilocks_mul(base, base);
        exp >>= 1;
    }
    result
}

fn goldilocks_inv(value: u64) -> u64 {
    goldilocks_pow(value, GOLDILOCKS_P - 2)
}

fn goldilocks_mul(left: u64, right: u64) -> u64 {
    ((left as u128 * right as u128) % GOLDILOCKS_P as u128) as u64
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
            let boundary =
                &stark_info.boundaries[reference.boundary_id.expect("boundary id") as usize];
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
            let pol = &stark_info.custom_commits_map[commit_id]
                [reference.id.expect("custom id") as usize];
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

#[derive(Debug, Clone)]
#[allow(dead_code)]
pub struct TranscriptRenderer<'a> {
    stark_info: &'a CircomStarkInfo,
    name: Option<String>,
    state: Vec<String>,
    pending: Vec<String>,
    out: Vec<String>,
    h_cnt: usize,
    hi_cnt: usize,
    n2b_cnt: usize,
    last_code_printed: usize,
    code: Vec<String>,
}

#[allow(dead_code)]
impl<'a> TranscriptRenderer<'a> {
    pub fn new(stark_info: &'a CircomStarkInfo, name: impl Into<Option<String>>) -> Self {
        Self {
            stark_info,
            name: name.into(),
            state: vec!["0".to_string(), "0".to_string(), "0".to_string(), "0".to_string()],
            pending: Vec::new(),
            out: Vec::new(),
            h_cnt: 0,
            hi_cnt: 0,
            n2b_cnt: 0,
            last_code_printed: 0,
            code: Vec::new(),
        }
    }

    pub fn get_field(&mut self, target: &str) {
        let values = [self.get_fields1(), self.get_fields1(), self.get_fields1()];
        self.code.push(format!("{target} <== [{}, {}, {}];", values[0], values[1], values[2]));
    }

    pub fn get_state(&mut self, target: &str) {
        let values =
            [self.get_fields1(), self.get_fields1(), self.get_fields1(), self.get_fields1()];
        self.code.push(format!(
            "{target} <== [{}, {}, {}, {}];",
            values[0], values[1], values[2], values[3]
        ));
    }

    pub fn put(&mut self, value: &str, len: Option<usize>) {
        if let Some(len) = len {
            for idx in 0..len {
                self.add_one(format!("{value}[{idx}]"));
            }
        } else {
            self.add_one(value.to_string());
        }
    }

    pub fn get_permutations(&mut self, target: &str, n: u64, n_bits: u64) {
        let total_bits = n * n_bits;
        let n_fields = ((total_bits - 1) / 63) + 1;
        let mut n2b = Vec::new();
        for _ in 0..n_fields {
            let field = self.get_fields1();
            let name = format!("transcriptN2b_{}", self.n2b_cnt);
            self.n2b_cnt += 1;
            self.code.push(format!("signal {{binary}} {name}[64] <== Num2Bits_strict()({field});"));
            n2b.push(name);
        }

        let arity_words = self.arity_words();
        if self.hi_cnt < arity_words {
            self.code.push(format!(
                "for(var i = {}; i < {}; i++){{\n        _ <== {}_{}[i]; // Unused transcript values        \n    }}\n",
                self.hi_cnt,
                arity_words,
                self.signal_name(),
                self.h_cnt.saturating_sub(1)
            ));
        }

        self.code.push(
            "// From each transcript hash converted to bits, we assign those bits to queriesFRI[q] to define the query positions".to_string(),
        );
        self.code.push("var q = 0; // Query number ".to_string());
        self.code.push("var b = 0; // Bit number ".to_string());
        for (idx, name) in n2b.iter().enumerate() {
            let bits = if idx + 1 == n2b.len() { total_bits - 63 * idx as u64 } else { 63 };
            self.code.push(format!(
                "for(var j = 0; j < {bits}; j++) {{\n        {target}[q][b] <== {name}[j];\n        b++;\n        if(b == {}) {{\n            b = 0; \n            q++;\n        }}\n    }}",
                self.stark_info.stark_struct.steps[0].n_bits
            ));
            if bits == 63 {
                self.code.push(format!("_ <== {name}[63]; // Unused last bit\n"));
            } else {
                self.code.push(format!(
                    "for(var j = {bits}; j < 64; j++) {{\n        _ <== {name}[j]; // Unused bits        \n    }}"
                ));
            }
        }
    }

    pub fn take_code(&mut self) -> String {
        let mut out = String::new();
        for idx in self.last_code_printed..self.code.len() {
            line(&mut out, format_args!("    {}", self.code[idx]));
        }
        self.last_code_printed = self.code.len();
        out
    }

    fn get_fields1(&mut self) -> String {
        if self.out.is_empty() {
            while self.pending.len()
                < 4 * (self.stark_info.stark_struct.merkle_tree_arity as usize - 1)
            {
                self.pending.push("0".to_string());
            }
            self.update_state();
        }
        let value = self.out.remove(0);
        self.hi_cnt += 1;
        value
    }

    fn add_one(&mut self, value: String) {
        self.out.clear();
        self.pending.push(value);
        if self.pending.len() == 4 * (self.stark_info.stark_struct.merkle_tree_arity as usize - 1) {
            self.update_state();
        }
    }

    fn update_state(&mut self) {
        let signal_name = self.signal_name();
        if self.h_cnt > 0 {
            let first_unused = self.hi_cnt.max(4);
            if first_unused < self.arity_words() {
                self.code.push(format!(
                    "for(var i = {first_unused}; i < {}; i++){{\n        _ <== {signal_name}_{}[i]; // Unused transcript values \n    }}",
                    self.arity_words(),
                    self.h_cnt - 1
                ));
            }
        }
        self.code.push(format!(
            "\n    signal {signal_name}_{}[{}] <== Poseidon2({}, {})([{}], [{}]);",
            self.h_cnt,
            self.arity_words(),
            self.stark_info.stark_struct.merkle_tree_arity,
            self.arity_words(),
            self.pending.join(","),
            self.state.join(",")
        ));
        self.out = (0..self.arity_words())
            .map(|idx| format!("{signal_name}_{}[{idx}]", self.h_cnt))
            .collect();
        self.state = (0..4).map(|idx| format!("{signal_name}_{}[{idx}]", self.h_cnt)).collect();
        self.h_cnt += 1;
        self.pending.clear();
        self.hi_cnt = 0;
    }

    fn signal_name(&self) -> String {
        if let Some(name) = &self.name {
            format!("transcriptHash_{name}")
        } else {
            "transcriptHash".to_string()
        }
    }

    fn arity_words(&self) -> usize {
        4 * self.stark_info.stark_struct.merkle_tree_arity as usize
    }
}

impl CircomStarkInfo {
    fn n_queries(&self) -> u64 {
        self.stark_struct.n_queries.unwrap_or(0)
    }

    fn map_section_width(&self, key: &str) -> u64 {
        self.map_sections_n.get(key).copied().unwrap_or(0)
    }

    fn challenge_count(&self, stage: u64) -> usize {
        self.challenges_map.iter().filter(|challenge| challenge.stage == stage).count()
    }

    fn q_stage(&self) -> u64 {
        self.n_stages as u64 + 1
    }

    fn has_boundary(&self, name: &str) -> bool {
        self.boundaries.iter().any(|boundary| boundary.name == name)
    }

    fn frame_boundaries(&self) -> Vec<&CircomBoundary> {
        self.boundaries.iter().filter(|boundary| boundary.name == "everyFrame").collect()
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
        ceil_div(n_bits, self.arity_bits())
            .saturating_sub(self.stark_struct.last_level_verification)
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

fn suffixed_name(base: &str, airgroup_id: Option<u32>) -> String {
    airgroup_id.map(|id| format!("{base}{id}")).unwrap_or_else(|| base.to_string())
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
        let out = render_define_stark_inputs(
            &stark,
            "a",
            stark.n_publics,
            StarkInputOptions { add_publics: true, ..Default::default() },
        );

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
            airs: vec![vec![CircomVadcopAir {
                name: "Main".to_string(),
                num_rows: 8,
                has_compressor: None,
            }]],
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

        let stark = sample_stark_info();
        let hash = render_calculate_stage1_hash_template(&stark, &vadcop);
        assert!(hash.contains("template CalculateStage1Hash()"));
        assert!(hash.contains("signal output values[368];"));
        assert!(hash.contains("Poseidon2(4, 16)"));

        let assign = render_assign_vadcop_inputs(
            "sV",
            &vadcop,
            "sv",
            0,
            VadcopAssignOptions { add_prefix_agg_types: true, set_enable_input: true },
        );
        assert!(assign.contains("sV.publics[0] <== sv_circuitType;"));
        assert!(assign.contains("sV.publics[2 + i] <== sv_aggregationTypes[i];"));
        assert!(assign.contains("sV.enable <== 1 - sv_isNull;"));
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

    #[test]
    fn renders_transcript_hash_and_query_bits() {
        let stark = sample_stark_info();
        let mut transcript = TranscriptRenderer::new(&stark, Some("friQueries".to_string()));
        transcript.put("challengeFRIQueries", Some(3));
        transcript.put("nonce", None);
        transcript.get_permutations(
            "queriesFRI",
            stark.stark_struct.n_queries.unwrap(),
            stark.stark_struct.steps[0].n_bits,
        );
        let out = transcript.take_code();

        assert!(out.contains("Poseidon2(4, 16)([challengeFRIQueries[0],challengeFRIQueries[1],challengeFRIQueries[2],nonce"));
        assert!(out.contains("signal {binary} transcriptN2b_0[64] <== Num2Bits_strict()"));
        assert!(out.contains("queriesFRI[q][b] <== transcriptN2b_0[j];"));
    }

    #[test]
    fn renders_verifier_evaluation_and_fri_pol_templates() {
        let mut stark = sample_stark_info();
        stark.challenges_map =
            vec![CircomChallengeMap { name: "alpha".to_string(), stage: 1, dim: 3, stage_id: 0 }];
        stark.cm_pols_map = vec![
            CircomPolMap {
                name: "trace".to_string(),
                stage: 1,
                dim: 1,
                stage_id: Some(0),
                stage_pos: Some(0),
            },
            CircomPolMap {
                name: "q".to_string(),
                stage: 2,
                dim: 3,
                stage_id: Some(0),
                stage_pos: Some(0),
            },
        ];
        stark.map_sections_n.insert("cm2".to_string(), 3);
        stark.ev_map = sample_q_evals();
        let verifier = sample_verifier_info();

        let evals = render_verify_evaluations_templates(&stark, &verifier);
        assert!(evals.contains("template VerifyEvaluationsChunks0()"));
        assert!(evals.contains("signal input challengesStage1[1][3];"));
        assert!(evals.contains("signal qAcc[3][3];"));
        assert!(evals.contains("enable * (tmp_0[0] - qAcc[2][0]) === 0;"));

        let fri = render_calculate_fri_pol_templates(&stark, &verifier);
        assert!(fri.contains("component mapValues = MapValues0();"));
        assert!(fri.contains("template CalculateFRIPolValue0()"));
        assert!(fri.contains("xacc[0] <== queriesFRI[0]*(49 * roots(8)-49) + 49;"));
        assert!(fri.contains("queryVals[0] <== tmp_1[0];"));

        let final_pol = render_verify_final_pol_template(&stark);
        assert!(final_pol.contains("template VerifyFinalPol0()"));
        assert!(final_pol.contains("signal lastIFFT[32][3] <== FFT(5, 3, 1)(finalPol);"));
    }

    #[test]
    fn renders_stark_verifier_wrapper() {
        let mut stark = sample_stark_info();
        stark.cm_pols_map = vec![
            CircomPolMap {
                name: "trace".to_string(),
                stage: 1,
                dim: 1,
                stage_id: Some(0),
                stage_pos: Some(0),
            },
            CircomPolMap {
                name: "q".to_string(),
                stage: 2,
                dim: 3,
                stage_id: Some(0),
                stage_pos: Some(0),
            },
        ];
        stark.map_sections_n.insert("cm2".to_string(), 3);
        stark.ev_map = sample_q_evals();
        let out = render_stark_verifier_template(
            &[1, 2, 3, 4],
            &stark,
            StarkVerifierOptions {
                input_challenges: true,
                enable_input: true,
                ..Default::default()
            },
        );

        assert!(out.contains("template StarkVerifier0()"));
        assert!(out.contains("signal output rootC[4] <== [1,2,3,4];"));
        assert!(out.contains(
            "(challengeQ,challengeXi,challengesFRI,challengesFRISteps,queriesFRI) <== Transcript0()("
        ));
        assert!(out.contains("VerifyMerkleHashUntilLevel(1, 4, 4"));
        assert!(out.contains("queryVals[q] <== CalculateFRIPolValue0()"));
        assert!(out.contains("VerifyFRI0(8, 8, 5, 0,"));
        assert!(out.contains("VerifyFinalPol0()(finalPol, enabled);"));
    }

    #[test]
    fn compiles_sample_stark_verifier_circom() -> anyhow::Result<()> {
        let dir = std::env::temp_dir()
            .join(format!("pk_setup_recursive_verifier_circom_test_{}", std::process::id()));
        if dir.exists() {
            std::fs::remove_dir_all(&dir)?;
        }
        std::fs::create_dir_all(&dir)?;
        let includes = crate::circom_assets::write_recursive_include_assets(&dir)?;

        let mut stark = sample_stark_info();
        stark.cm_pols_map = vec![
            CircomPolMap {
                name: "trace".to_string(),
                stage: 1,
                dim: 1,
                stage_id: Some(0),
                stage_pos: Some(0),
            },
            CircomPolMap {
                name: "q".to_string(),
                stage: 2,
                dim: 3,
                stage_id: Some(0),
                stage_pos: Some(0),
            },
        ];
        stark.map_sections_n.insert("cm2".to_string(), 3);
        stark.ev_map = sample_q_evals();
        let verifier = sample_verifier_info();
        let source = render_stark_verifier_circom(
            &[1, 2, 3, 4],
            &stark,
            &verifier,
            StarkVerifierOptions {
                input_challenges: true,
                enable_input: true,
                ..Default::default()
            },
        );
        let input = dir.join("sample_verifier.circom");
        let output = dir.join("sample_verifier.r1cs");
        std::fs::write(&input, source)?;
        crate::circom_compile::compile_file_to_r1cs(
            &input,
            [dir.clone(), includes.gl, includes.vadcop],
            &output,
        )?;
        let r1cs = crate::recursive_setup::r1cs::read_r1cs(&output)?;
        assert!(r1cs.n_constraints > 0);
        std::fs::remove_dir_all(&dir)?;
        Ok(())
    }

    #[test]
    fn compiles_sample_recursive1_wrapper_circom() -> anyhow::Result<()> {
        let dir = std::env::temp_dir()
            .join(format!("pk_setup_recursive1_circom_test_{}", std::process::id()));
        if dir.exists() {
            std::fs::remove_dir_all(&dir)?;
        }
        std::fs::create_dir_all(&dir)?;
        let includes = crate::circom_assets::write_recursive_include_assets(&dir)?;

        let mut stark = sample_stark_info();
        stark.airgroup_values_map = vec![CircomNamedMap { name: "agg".to_string(), stage: 2 }];
        stark.cm_pols_map = vec![
            CircomPolMap {
                name: "trace".to_string(),
                stage: 1,
                dim: 1,
                stage_id: Some(0),
                stage_pos: Some(0),
            },
            CircomPolMap {
                name: "q".to_string(),
                stage: 2,
                dim: 3,
                stage_id: Some(0),
                stage_pos: Some(0),
            },
        ];
        stark.map_sections_n.insert("cm2".to_string(), 3);
        stark.ev_map = sample_q_evals();
        let verifier = render_stark_verifier_circom(
            &[1, 2, 3, 4],
            &stark,
            &sample_verifier_info(),
            StarkVerifierOptions { input_challenges: true, skip_main: true, ..Default::default() },
        );
        std::fs::write(dir.join("sample_verifier.circom"), verifier)?;
        let wrapper = render_recursive1_circom(
            &stark,
            &sample_vadcop_info(),
            "sample_verifier.circom",
            false,
        );
        let input = dir.join("recursive1.circom");
        let output = dir.join("recursive1.r1cs");
        std::fs::write(&input, wrapper)?;
        crate::circom_compile::compile_file_to_r1cs(
            &input,
            [dir.clone(), includes.gl, includes.vadcop],
            &output,
        )?;
        let r1cs = crate::recursive_setup::r1cs::read_r1cs(&output)?;
        assert!(r1cs.n_constraints > 0);
        std::fs::remove_dir_all(&dir)?;
        Ok(())
    }

    #[test]
    fn compiles_sample_compressor_wrapper_circom() -> anyhow::Result<()> {
        let dir = std::env::temp_dir()
            .join(format!("pk_setup_compressor_circom_test_{}", std::process::id()));
        if dir.exists() {
            std::fs::remove_dir_all(&dir)?;
        }
        std::fs::create_dir_all(&dir)?;
        let includes = crate::circom_assets::write_recursive_include_assets(&dir)?;

        let mut stark = sample_stark_info();
        stark.airgroup_values_map = vec![CircomNamedMap { name: "agg".to_string(), stage: 2 }];
        stark.cm_pols_map = vec![
            CircomPolMap {
                name: "trace".to_string(),
                stage: 1,
                dim: 1,
                stage_id: Some(0),
                stage_pos: Some(0),
            },
            CircomPolMap {
                name: "q".to_string(),
                stage: 2,
                dim: 3,
                stage_id: Some(0),
                stage_pos: Some(0),
            },
        ];
        stark.map_sections_n.insert("cm2".to_string(), 3);
        stark.ev_map = sample_q_evals();
        let verifier = render_stark_verifier_circom(
            &[1, 2, 3, 4],
            &stark,
            &sample_verifier_info(),
            StarkVerifierOptions { input_challenges: true, skip_main: true, ..Default::default() },
        );
        std::fs::write(dir.join("sample_verifier.circom"), verifier)?;
        let wrapper =
            render_compressor_circom(&stark, &sample_vadcop_info(), "sample_verifier.circom");
        let input = dir.join("compressor.circom");
        let output = dir.join("compressor.r1cs");
        std::fs::write(&input, wrapper)?;
        crate::circom_compile::compile_file_to_r1cs(
            &input,
            [dir.clone(), includes.gl, includes.vadcop],
            &output,
        )?;
        let r1cs = crate::recursive_setup::r1cs::read_r1cs(&output)?;
        assert!(r1cs.n_constraints > 0);
        std::fs::remove_dir_all(&dir)?;
        Ok(())
    }

    #[test]
    fn compiles_sample_recursive2_wrapper_circom() -> anyhow::Result<()> {
        let dir = std::env::temp_dir()
            .join(format!("pk_setup_recursive2_circom_test_{}", std::process::id()));
        if dir.exists() {
            std::fs::remove_dir_all(&dir)?;
        }
        std::fs::create_dir_all(&dir)?;
        let includes = crate::circom_assets::write_recursive_include_assets(&dir)?;

        let vadcop = sample_vadcop_info();
        let mut stark = sample_stark_info();
        stark.n_publics = 31;
        stark.airgroup_values_map = vec![CircomNamedMap { name: "agg".to_string(), stage: 2 }];
        stark.cm_pols_map = vec![
            CircomPolMap {
                name: "trace".to_string(),
                stage: 1,
                dim: 1,
                stage_id: Some(0),
                stage_pos: Some(0),
            },
            CircomPolMap {
                name: "q".to_string(),
                stage: 2,
                dim: 3,
                stage_id: Some(0),
                stage_pos: Some(0),
            },
        ];
        stark.map_sections_n.insert("cm2".to_string(), 3);
        stark.ev_map = sample_q_evals();
        let verifier = render_stark_verifier_circom(
            &[1, 2, 3, 4],
            &stark,
            &sample_verifier_info(),
            StarkVerifierOptions { verkey_input: true, skip_main: true, ..Default::default() },
        );
        std::fs::write(dir.join("sample_recursive2_verifier.circom"), verifier)?;
        let wrapper = render_recursive2_circom(
            &stark,
            &vadcop,
            0,
            "sample_recursive2_verifier.circom",
            &[vec![1, 2, 3, 4]],
        );
        let input = dir.join("recursive2.circom");
        let output = dir.join("recursive2.r1cs");
        std::fs::write(&input, wrapper)?;
        crate::circom_compile::compile_file_to_r1cs(
            &input,
            [dir.clone(), includes.gl, includes.vadcop],
            &output,
        )?;
        let r1cs = crate::recursive_setup::r1cs::read_r1cs(&output)?;
        assert!(r1cs.n_constraints > 0);
        std::fs::remove_dir_all(&dir)?;
        Ok(())
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
                CircomEvMap {
                    ev_type: "cm".to_string(),
                    id: 0,
                    prime: 0,
                    opening_pos: 0,
                    commit_id: None,
                },
                CircomEvMap {
                    ev_type: "const".to_string(),
                    id: 0,
                    prime: 0,
                    opening_pos: 0,
                    commit_id: None,
                },
            ],
        }
    }

    fn sample_vadcop_info() -> CircomVadcopInfo {
        CircomVadcopInfo {
            name: "zisk".to_string(),
            airs: vec![vec![CircomVadcopAir {
                name: "Main".to_string(),
                num_rows: 8,
                has_compressor: None,
            }]],
            air_groups: vec!["Zisk".to_string()],
            agg_types: vec![vec![CircomAggType { agg_type: 1, stage: 2 }]],
            curve: "None".to_string(),
            lattice_size: 16,
            n_publics: 2,
            proof_values_map: Vec::new(),
        }
    }

    fn sample_verifier_info() -> CircomVerifierInfo {
        CircomVerifierInfo {
            q_verifier: CircomCodeBlock {
                tmp_used: 1,
                code: vec![CircomCodeLine {
                    op: "mul".to_string(),
                    dest: tmp_ref(0, 3),
                    src: vec![eval_ref(0), challenge_ref(2, 0)],
                }],
            },
            query_verifier: CircomExpressionCode {
                block: CircomCodeBlock {
                    tmp_used: 2,
                    code: vec![
                        CircomCodeLine {
                            op: "add".to_string(),
                            dest: tmp_ref(0, 1),
                            src: vec![cm_ref(0, 1), const_ref(0)],
                        },
                        CircomCodeLine {
                            op: "mul".to_string(),
                            dest: tmp_ref(1, 3),
                            src: vec![tmp_ref(0, 1), challenge_ref(4, 0)],
                        },
                    ],
                },
                exp_id: 0,
                stage: 0,
            },
        }
    }

    fn sample_q_evals() -> Vec<CircomEvMap> {
        (0..3)
            .map(|opening_pos| CircomEvMap {
                ev_type: "cm".to_string(),
                id: 1,
                prime: 0,
                opening_pos,
                commit_id: None,
            })
            .collect()
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

    fn eval_ref(id: u64) -> CircomCodeRef {
        CircomCodeRef {
            ref_type: "eval".to_string(),
            id: Some(id),
            dim: 3,
            stage: None,
            stage_id: None,
            value: None,
            boundary_id: None,
            commit_id: None,
        }
    }

    fn const_ref(id: u64) -> CircomCodeRef {
        CircomCodeRef {
            ref_type: "const".to_string(),
            id: Some(id),
            dim: 1,
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
