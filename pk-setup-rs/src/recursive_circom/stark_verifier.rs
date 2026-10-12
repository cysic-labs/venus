//! Templates of the Circom STARK verifier: FRI, evaluations, Merkle proofs and the main verifier.

use super::*;

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

pub(super) fn render_verify_evaluations_template(
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

pub(super) fn render_calculate_fri_pol_template(
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

pub(super) fn render_verify_query_template(stark_info: &CircomStarkInfo) -> String {
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

pub(super) fn render_map_values_template(stark_info: &CircomStarkInfo) -> String {
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

pub(super) fn render_preprocess_values(out: &mut String, stark_info: &CircomStarkInfo) {
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

pub(super) fn render_merkle_verifications(out: &mut String, stark_info: &CircomStarkInfo) {
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

pub(super) fn render_s0_merkle_query_loop(
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

pub(super) fn render_merkle_root_check(
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

pub(super) fn render_fri_polynomial_checks(
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

pub(super) fn render_map_values_raw_inputs(out: &mut String, stark_info: &CircomStarkInfo) {
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

pub(super) fn render_map_values_assignments(out: &mut String, stark_info: &CircomStarkInfo) {
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

pub(super) fn render_map_output(out: &mut String, name: &str, dim: u64) {
    if dim == 1 {
        line(out, format_args!("    signal output {name};"));
    } else {
        line(out, format_args!("    signal output {name}[3];"));
    }
}

pub(super) fn render_map_assignment(
    out: &mut String,
    output: &str,
    input: &str,
    pol: &CircomPolMap,
) {
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

pub(super) fn render_zframe_step(out: &mut String, frame_idx: usize, position: u32, root: u64) {
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
