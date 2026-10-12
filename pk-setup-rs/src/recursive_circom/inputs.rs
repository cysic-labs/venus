//! Declaration and assignment of the STARK and VADCOP inputs of the recursive circuits.

use super::*;

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

pub(super) fn render_challenge_stage_inputs(
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

pub(super) fn render_s0_sibling_inputs(out: &mut String, stark_info: &CircomStarkInfo) {
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

pub(super) fn vadcop_public_input_names(
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

pub(super) fn render_optional_value_inputs(
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

pub(super) fn render_boundary_input_declarations(
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

pub(super) fn render_cm_value_inputs(
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

pub(super) fn render_custom_commit_value_inputs(
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
