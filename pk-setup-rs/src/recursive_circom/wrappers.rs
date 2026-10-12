//! Top-level recursive circuits: compressor, recursive1, recursive2 and the final wrappers.

use super::*;

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
    out.push_str(&render_define_stark_inputs(
        stark_info,
        "",
        vadcop_info.n_publics,
        StarkInputOptions { add_publics: false, ..Default::default() },
    ));
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
pub fn render_final_compressed_circom(
    stark_info: &CircomStarkInfo,
    verifier_filename: &str,
    n_publics: usize,
) -> String {
    let mut out = String::new();
    line(&mut out, format_args!("pragma circom 2.1.0;"));
    line(&mut out, format_args!("pragma custom_templates;"));
    out.push('\n');
    line(&mut out, format_args!("include \"{verifier_filename}\";"));
    out.push('\n');
    line(&mut out, format_args!("template FinalCompressed() {{"));
    out.push_str(&render_define_stark_inputs(
        stark_info,
        "",
        n_publics,
        StarkInputOptions { add_publics: true, ..Default::default() },
    ));
    out.push('\n');
    out.push_str(&render_assign_stark_inputs(
        "sV",
        stark_info,
        "",
        n_publics,
        StarkInputOptions { add_publics: true, final_verifier: true, ..Default::default() },
    ));
    line(&mut out, format_args!("}}"));
    out.push('\n');
    line(&mut out, format_args!("component main {{public [ publics ]}}= FinalCompressed();"));
    out
}

#[allow(dead_code)]
pub fn render_final_circom(
    stark_infos: &[CircomStarkInfo],
    vadcop_info: &CircomVadcopInfo,
    global_constraints: &CircomGlobalConstraintsInfo,
    verifier_filenames: &[String],
    aggregated_verification_keys: &[Vec<u64>],
    basic_verification_keys: &[Vec<Vec<u64>>],
) -> String {
    let transcript_stark = stark_infos.first().expect("final verifier stark info");
    let mut out = String::new();
    line(&mut out, format_args!("pragma circom 2.1.0;"));
    line(&mut out, format_args!("pragma custom_templates;"));
    out.push('\n');
    for verifier in verifier_filenames {
        line(&mut out, format_args!("include \"{verifier}\";"));
    }
    line(&mut out, format_args!("include \"iszero.circom\";"));
    line(&mut out, format_args!("include \"select_vk.circom\";"));
    line(&mut out, format_args!("include \"agg_values.circom\";"));
    out.push('\n');
    out.push_str(&render_verify_global_challenges_template(transcript_stark, vadcop_info));
    out.push('\n');
    out.push_str(&render_verify_global_constraints_templates(
        transcript_stark,
        vadcop_info,
        global_constraints,
    ));
    out.push('\n');
    line(&mut out, format_args!("template Final() {{"));
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

    for group_idx in 0..vadcop_info.agg_types.len() {
        let stark_info =
            if stark_infos.len() > 1 { &stark_infos[group_idx] } else { &stark_infos[0] };
        out.push_str(&render_define_vadcop_inputs(
            vadcop_info,
            group_idx,
            &format!("s{group_idx}_sv"),
            true,
        ));
        out.push_str(&render_define_stark_inputs(
            stark_info,
            &format!("s{group_idx}"),
            vadcop_info.n_publics,
            StarkInputOptions { add_publics: false, ..Default::default() },
        ));
        out.push('\n');
    }

    let multiple_circuits = vadcop_info.air_groups.len() > 1
        || vadcop_info.airs.first().map(|airs| airs.len()).unwrap_or(0) > 1;
    for group_idx in 0..vadcop_info.agg_types.len() {
        let stark_info =
            if stark_infos.len() > 1 { &stark_infos[group_idx] } else { &stark_infos[0] };
        out.push_str(&render_assign_stark_inputs(
            &format!("sV{group_idx}"),
            stark_info,
            &format!("s{group_idx}"),
            vadcop_info.n_publics,
            StarkInputOptions { add_publics: false, ..Default::default() },
        ));
        out.push_str(&render_assign_vadcop_inputs(
            &format!("sV{group_idx}"),
            vadcop_info,
            &format!("s{group_idx}_sv"),
            group_idx,
            VadcopAssignOptions { add_prefix_agg_types: true, set_enable_input: multiple_circuits },
        ));
        let agg_vk =
            aggregated_verification_keys.get(group_idx).map(Vec::as_slice).unwrap_or(&[0, 0, 0, 0]);
        line(
            &mut out,
            format_args!("    var s{group_idx}_sv_rootCAgg[4] = [{}];", join_u64(agg_vk)),
        );
        let basic_keys = basic_verification_keys.get(group_idx).map(Vec::as_slice).unwrap_or(&[]);
        line(
            &mut out,
            format_args!("    var s{group_idx}_sv_rootCBasics[{}][4];", basic_keys.len()),
        );
        for (key_idx, key) in basic_keys.iter().enumerate() {
            line(
                &mut out,
                format_args!("    s{group_idx}_sv_rootCBasics[{key_idx}] = [{}];", join_u64(key)),
            );
        }
        let selector =
            if multiple_circuits { "SelectVerificationKeyNull" } else { "SelectVerificationKey" };
        line(
            &mut out,
            format_args!("    sV{group_idx}.rootC <== {selector}({})(s{group_idx}_sv_circuitType, s{group_idx}_sv_rootCBasics, s{group_idx}_sv_rootCAgg);", basic_keys.len()),
        );
        line(&mut out, format_args!("    for (var i=0; i<4; i++) {{"));
        line(
            &mut out,
            format_args!(
                "        sV{group_idx}.publics[{} + i] <== s{group_idx}_sv_rootCAgg[i];",
                stark_info.n_publics - 4
            ),
        );
        line(&mut out, format_args!("    }}"));
        out.push('\n');
    }

    // A null slot (circuitType 0) disables its STARK verifier, so its stage1Hash and
    // airgroupvalues are unconstrained. Mask them to zero before they reach the global checks,
    // as recursive2 does for its null children.
    let stage1_hash_source = |group_idx: usize| {
        if multiple_circuits {
            format!("s{group_idx}_masked_stage1Hash")
        } else {
            format!("s{group_idx}_sv_stage1Hash")
        }
    };
    let airgroupvalues_source = |group_idx: usize| {
        if multiple_circuits {
            format!("s{group_idx}_masked_airgroupvalues")
        } else {
            format!("s{group_idx}_sv_airgroupvalues")
        }
    };
    if multiple_circuits {
        for group_idx in 0..vadcop_info.agg_types.len() {
            line(
                &mut out,
                format_args!(
                    "    signal s{group_idx}_masked_stage1Hash[{}];",
                    vadcop_info.lattice_size
                ),
            );
            line(
                &mut out,
                format_args!("    for (var i = 0; i < {}; i++) {{", vadcop_info.lattice_size),
            );
            line(
                &mut out,
                format_args!(
                    "        s{group_idx}_masked_stage1Hash[i] <== (1 - s{group_idx}_sv_isNull) * s{group_idx}_sv_stage1Hash[i];"
                ),
            );
            line(&mut out, format_args!("    }}"));
            let n_agg = vadcop_info.agg_types[group_idx].len();
            if n_agg > 0 {
                line(
                    &mut out,
                    format_args!("    signal s{group_idx}_masked_airgroupvalues[{n_agg}][3];"),
                );
                line(&mut out, format_args!("    for (var i = 0; i < {n_agg}; i++) {{"));
                line(&mut out, format_args!("        for (var j = 0; j < 3; j++) {{"));
                line(
                    &mut out,
                    format_args!(
                        "            s{group_idx}_masked_airgroupvalues[i][j] <== (1 - s{group_idx}_sv_isNull) * s{group_idx}_sv_airgroupvalues[i][j];"
                    ),
                );
                line(&mut out, format_args!("        }}"));
                line(&mut out, format_args!("    }}"));
            }
        }
        out.push('\n');
    }

    line(&mut out, format_args!("    component verifyChallenges = VerifyGlobalChallenges();"));
    if vadcop_info.n_publics > 0 {
        line(&mut out, format_args!("    verifyChallenges.publics <== publics;"));
    }
    if !vadcop_info.proof_values_map.is_empty() {
        line(&mut out, format_args!("    verifyChallenges.proofValues <== proofValues;"));
    }
    for group_idx in 0..vadcop_info.agg_types.len() {
        line(
            &mut out,
            format_args!(
                "    verifyChallenges.stage1Hash[{group_idx}] <== {};",
                stage1_hash_source(group_idx)
            ),
        );
    }
    line(&mut out, format_args!("    verifyChallenges.globalChallenge <== globalChallenge;"));
    out.push('\n');

    line(
        &mut out,
        format_args!("    component verifyGlobalConstraints = VerifyGlobalConstraints();"),
    );
    if vadcop_info.n_publics > 0 {
        line(&mut out, format_args!("    verifyGlobalConstraints.publics <== publics;"));
    }
    if !vadcop_info.proof_values_map.is_empty() {
        line(&mut out, format_args!("    verifyGlobalConstraints.proofValues <== proofValues;"));
    }
    line(
        &mut out,
        format_args!("    verifyGlobalConstraints.globalChallenge <== globalChallenge;"),
    );
    for group_idx in 0..vadcop_info.agg_types.len() {
        if !vadcop_info.agg_types[group_idx].is_empty() {
            line(
                &mut out,
                format_args!(
                    "    verifyGlobalConstraints.s{group_idx}_airgroupvalues <== {};",
                    airgroupvalues_source(group_idx)
                ),
            );
        }
    }
    out.push('\n');

    line(&mut out, format_args!("    signal {{binary}} isNull[{}];", vadcop_info.agg_types.len()));
    line(&mut out, format_args!("    signal nAggregatedProofs[{}];", vadcop_info.agg_types.len()));
    for group_idx in 0..vadcop_info.agg_types.len() {
        if multiple_circuits {
            line(&mut out, format_args!("    isNull[{group_idx}] <== s{group_idx}_sv_isNull;"));
        } else {
            // Without a null circuit type, circuitType 0 selects the aggregated key.
            line(&mut out, format_args!("    isNull[{group_idx}] <== 0;"));
        }
        line(
            &mut out,
            format_args!(
                "    nAggregatedProofs[{group_idx}] <== s{group_idx}_sv_aggregatedProofs;"
            ),
        );
    }
    // The final proof must aggregate at least one verified basic proof; otherwise every slot
    // could be null and the global checks would run on unverified values.
    line(
        &mut out,
        format_args!(
            "    signal totalAggregatedProofs <== AggregateProofsNull({})(nAggregatedProofs, isNull);",
            vadcop_info.agg_types.len()
        ),
    );
    line(
        &mut out,
        format_args!("    signal noAggregatedProofs <== IsZero()(totalAggregatedProofs);"),
    );
    line(&mut out, format_args!("    noAggregatedProofs === 0;"));
    line(&mut out, format_args!("}}"));
    out.push('\n');
    if vadcop_info.n_publics > 0 {
        line(&mut out, format_args!("component main {{public [publics]}}= Final();"));
    } else {
        line(&mut out, format_args!("component main = Final();"));
    }
    out
}
