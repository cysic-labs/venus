//! Templates that check the global challenges and the global constraints in the final circuit.

use super::*;

#[allow(dead_code)]
pub fn render_verify_global_challenges_template(
    stark_info: &CircomStarkInfo,
    vadcop_info: &CircomVadcopInfo,
) -> String {
    assert_eq!(vadcop_info.curve, "None", "only lattice VADCOP global challenge is supported");
    let mut out = String::new();
    line(&mut out, format_args!("template VerifyGlobalChallenges() {{"));
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
    line(
        &mut out,
        format_args!(
            "    signal input stage1Hash[{}][{}];",
            vadcop_info.agg_types.len(),
            vadcop_info.lattice_size
        ),
    );
    line(&mut out, format_args!("    signal input globalChallenge[3];"));
    line(&mut out, format_args!("    signal calculatedGlobalChallenge[3];"));
    out.push('\n');

    let mut transcript = TranscriptRenderer::new(stark_info, Some("global".to_string()));
    if vadcop_info.n_publics > 0 {
        transcript.put("publics", Some(vadcop_info.n_publics));
    }
    for (idx, proof_value) in vadcop_info.proof_values_map.iter().enumerate() {
        if proof_value.stage == 1 {
            transcript.put(&format!("proofValues[{idx}]"), Some(1));
        } else {
            transcript
                .code
                .push(format!("_ <== proofValues[{idx}]; // Unused proof values at stage 1"));
        }
    }
    for group_idx in 0..vadcop_info.agg_types.len() {
        transcript.put(&format!("stage1Hash[{group_idx}]"), Some(vadcop_info.lattice_size));
    }
    transcript.get_field("calculatedGlobalChallenge");
    out.push_str(&transcript.take_code());
    out.push('\n');
    line(&mut out, format_args!("    globalChallenge === calculatedGlobalChallenge;"));
    line(&mut out, format_args!("}}"));
    out
}

#[allow(dead_code)]
pub fn render_verify_global_constraints_templates(
    stark_info: &CircomStarkInfo,
    vadcop_info: &CircomVadcopInfo,
    global_constraints: &CircomGlobalConstraintsInfo,
) -> String {
    let challenge_count = vadcop_info.num_challenges.get(1).copied().unwrap_or(0) as usize;
    let mut out = String::new();
    let mut chunk_sets = Vec::new();
    for constraint in &global_constraints.constraints {
        chunk_sets.push(build_expression_chunks(&constraint.block.code, 50));
    }

    for (constraint_idx, chunks) in chunk_sets.iter().enumerate() {
        for (chunk_idx, chunk) in chunks.chunks.iter().enumerate() {
            line(
                &mut out,
                format_args!("template GlobalConstraint{constraint_idx}_chunk{chunk_idx}() {{"),
            );
            render_global_constraint_common_inputs(&mut out, vadcop_info, challenge_count);
            for tmp in &chunk.inputs {
                render_tmp_declaration(&mut out, "input", *tmp, &chunks.tmps);
            }
            for tmp in &chunk.outputs {
                render_tmp_declaration(&mut out, "output", *tmp, &chunks.tmps);
            }
            let initialized =
                chunk.inputs.iter().chain(chunk.outputs.iter()).copied().collect::<Vec<_>>();
            out.push_str(&render_global_unrolled_code(&chunk.code, &initialized));
            line(&mut out, format_args!("}}"));
            out.push('\n');
        }
    }

    line(&mut out, format_args!("template VerifyGlobalConstraints() {{"));
    let mut inputs = Vec::new();
    render_global_constraint_main_inputs(&mut out, vadcop_info, &mut inputs);
    line(&mut out, format_args!("    signal input globalChallenge[3];"));
    line(&mut out, format_args!("    signal challenges[{challenge_count}][3];"));
    let mut transcript = TranscriptRenderer::new(stark_info, Some("globalConstraints".to_string()));
    transcript.put("globalChallenge", Some(3));
    for idx in 0..challenge_count {
        transcript.get_field(&format!("challenges[{idx}]"));
    }
    out.push_str(&transcript.take_code());
    inputs.push("challenges".to_string());
    out.push('\n');

    for (constraint_idx, chunks) in chunk_sets.iter().enumerate() {
        for (chunk_idx, chunk) in chunks.chunks.iter().enumerate() {
            for output in &chunk.outputs {
                render_global_constraint_tmp_declaration(
                    &mut out,
                    constraint_idx,
                    *output,
                    &chunks.tmps,
                );
            }
            let outputs = join_global_constraint_tmp_names(constraint_idx, &chunk.outputs);
            let mut call_inputs = inputs.clone();
            call_inputs.extend(
                chunk.inputs.iter().map(|tmp| global_constraint_tmp_name(constraint_idx, *tmp)),
            );
            line(
                &mut out,
                format_args!(
                    "    ({outputs}) <== GlobalConstraint{constraint_idx}_chunk{chunk_idx}()({});",
                    call_inputs.join(",")
                ),
            );
        }
        if let Some(last) = global_constraints.constraints[constraint_idx].block.code.last() {
            let result = last.dest.id.expect("global constraint result tmp");
            let result_name = global_constraint_tmp_name(constraint_idx, result);
            if last.dest.dim == 1 {
                line(&mut out, format_args!("    {result_name} === 0;"));
            } else {
                line(&mut out, format_args!("    {result_name}[0] === 0;"));
                line(&mut out, format_args!("    {result_name}[1] === 0;"));
                line(&mut out, format_args!("    {result_name}[2] === 0;"));
            }
        }
    }
    line(&mut out, format_args!("}}"));
    out
}

pub(super) fn render_global_constraint_common_inputs(
    out: &mut String,
    vadcop_info: &CircomVadcopInfo,
    challenge_count: usize,
) {
    for (idx, agg_types) in vadcop_info.agg_types.iter().enumerate() {
        line(out, format_args!("    signal input s{idx}_airgroupvalues[{}][3];", agg_types.len()));
    }
    if vadcop_info.n_publics > 0 {
        line(out, format_args!("    signal input publics[{}];", vadcop_info.n_publics));
    }
    if !vadcop_info.proof_values_map.is_empty() {
        line(
            out,
            format_args!(
                "    signal input proofValues[{}][3];",
                vadcop_info.proof_values_map.len()
            ),
        );
    }
    line(out, format_args!("    signal input challenges[{challenge_count}][3];"));
}

pub(super) fn render_global_constraint_main_inputs(
    out: &mut String,
    vadcop_info: &CircomVadcopInfo,
    inputs: &mut Vec<String>,
) {
    for (idx, agg_types) in vadcop_info.agg_types.iter().enumerate() {
        line(out, format_args!("    signal input s{idx}_airgroupvalues[{}][3];", agg_types.len()));
        inputs.push(format!("s{idx}_airgroupvalues"));
    }
    if vadcop_info.n_publics > 0 {
        line(out, format_args!("    signal input publics[{}];", vadcop_info.n_publics));
        inputs.push("publics".to_string());
    }
    if !vadcop_info.proof_values_map.is_empty() {
        line(
            out,
            format_args!(
                "    signal input proofValues[{}][3];",
                vadcop_info.proof_values_map.len()
            ),
        );
        inputs.push("proofValues".to_string());
    }
}

pub(super) fn global_constraint_tmp_name(constraint_idx: usize, tmp_id: u64) -> String {
    format!("gc{constraint_idx}_tmp_{tmp_id}")
}

pub(super) fn join_global_constraint_tmp_names(constraint_idx: usize, ids: &[u64]) -> String {
    ids.iter()
        .map(|id| global_constraint_tmp_name(constraint_idx, *id))
        .collect::<Vec<_>>()
        .join(",")
}

pub(super) fn render_global_constraint_tmp_declaration(
    out: &mut String,
    constraint_idx: usize,
    tmp_id: u64,
    tmps: &BTreeMap<u64, TmpInfo>,
) {
    let dim = tmps.get(&tmp_id).expect("global constraint tmp declaration").dim;
    let name = global_constraint_tmp_name(constraint_idx, tmp_id);
    render_tmp_declaration_with_name(out, "", &name, dim);
}
