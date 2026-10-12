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
        num_challenges: vec![0, 2],
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
fn recursive1_inputs_follow_flat_proof_layout() {
    let stark = sample_stark_info();
    let mut vadcop = sample_vadcop_info();
    vadcop.proof_values_map = vec![CircomNamedMap { name: "value".to_string(), stage: 1 }];

    let out = render_recursive1_circom(&stark, &vadcop, "sample_verifier.circom", false);
    let out = recursive1_template(&out);
    assert_order(
        out,
        &[
            "signal input root1[4];",
            "signal input publics[2];",
            "signal input proofValues[1][3];",
            "signal input globalChallenge[3];",
            "signal input rootCAgg[4];",
        ],
    );

    let out = render_recursive1_circom(&stark, &vadcop, "sample_verifier.circom", true);
    let out = recursive1_template(&out);
    assert_order(
        out,
        &[
            "signal input sv_circuitType;",
            "signal input sv_aggregatedProofs;",
            "signal input sv_stage1Hash[16];",
            "signal input root1[4];",
            "signal input publics[2];",
            "signal input proofValues[1][3];",
        ],
    );
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
        CircomCodeLine { op: "copy".to_string(), dest: tmp_ref(2, 3), src: vec![tmp_ref(1, 3)] },
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
fn global_constraint_main_tmp_names_are_namespaced() {
    let stark = sample_stark_info();
    let vadcop = sample_vadcop_info();
    let global_constraints = CircomGlobalConstraintsInfo {
        constraints: vec![
            sample_global_constraint_with_tmp(3),
            sample_global_constraint_with_tmp(3),
        ],
    };

    let out = render_verify_global_constraints_templates(&stark, &vadcop, &global_constraints);
    let main = out
        .split_once("template VerifyGlobalConstraints() {")
        .map(|(_, rest)| rest)
        .expect("missing VerifyGlobalConstraints template");

    assert!(main.contains("signal gc0_tmp_3;"));
    assert!(main.contains("signal gc1_tmp_3;"));
    assert!(main.contains("(gc0_tmp_3) <== GlobalConstraint0_chunk0()"));
    assert!(main.contains("(gc1_tmp_3) <== GlobalConstraint1_chunk0()"));
    assert!(main.contains("gc0_tmp_3 === 0;"));
    assert!(main.contains("gc1_tmp_3 === 0;"));
    assert!(!main.contains("signal tmp_3;"));
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
    assert!(fri.contains("xacc[0] <== queriesFRI[0]*(7 * roots(8)-7) + 7;"));
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
        StarkVerifierOptions { input_challenges: true, enable_input: true, ..Default::default() },
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
        StarkVerifierOptions { input_challenges: true, enable_input: true, ..Default::default() },
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
    let wrapper =
        render_recursive1_circom(&stark, &sample_vadcop_info(), "sample_verifier.circom", false);
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
    let wrapper = render_compressor_circom(&stark, &sample_vadcop_info(), "sample_verifier.circom");
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

#[test]
fn compiles_sample_final_compressed_wrapper_circom() -> anyhow::Result<()> {
    let dir = std::env::temp_dir()
        .join(format!("pk_setup_final_compressed_circom_test_{}", std::process::id()));
    if dir.exists() {
        std::fs::remove_dir_all(&dir)?;
    }
    std::fs::create_dir_all(&dir)?;
    let includes = crate::circom_assets::write_recursive_include_assets(&dir)?;

    let mut stark = sample_stark_info();
    stark.airgroup_id = None;
    stark.air_id = None;
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
        StarkVerifierOptions { skip_main: true, ..Default::default() },
    );
    std::fs::write(dir.join("sample_final_verifier.circom"), verifier)?;
    let wrapper = render_final_compressed_circom(&stark, "sample_final_verifier.circom", 2);
    let input = dir.join("final_compressed.circom");
    let output = dir.join("final_compressed.r1cs");
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
fn final_wrapper_masks_null_slot_and_requires_aggregated_proofs() -> anyhow::Result<()> {
    let dir =
        std::env::temp_dir().join(format!("pk_setup_final_null_slot_test_{}", std::process::id()));
    if dir.exists() {
        std::fs::remove_dir_all(&dir)?;
    }
    std::fs::create_dir_all(&dir)?;
    let includes = crate::circom_assets::write_recursive_include_assets(&dir)?;

    // Two AIRs in the sole airgroup select the null-capable verification key path.
    let mut vadcop = sample_vadcop_info();
    vadcop.airs[0].push(CircomVadcopAir {
        name: "Rom".to_string(),
        num_rows: 8,
        has_compressor: None,
    });
    let mut stark = sample_stark_info();
    stark.n_publics = 31;
    stark.airgroup_values_map = vec![CircomNamedMap { name: "agg".to_string(), stage: 1 }];
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
        StarkVerifierOptions {
            verkey_input: true,
            enable_input: true,
            skip_main: true,
            ..Default::default()
        },
    );
    std::fs::write(dir.join("sample_final_recursive2_verifier.circom"), verifier)?;

    let global_constraints = CircomGlobalConstraintsInfo { constraints: Vec::new() };
    let wrapper = render_final_circom(
        &[stark],
        &vadcop,
        &global_constraints,
        &["sample_final_recursive2_verifier.circom".to_string()],
        &[vec![1, 2, 3, 4]],
        &[vec![vec![1, 2, 3, 4], vec![5, 6, 7, 8]]],
    );
    // A null slot disables its verifier, so only masked values may reach the global checks, and
    // the final proof must aggregate at least one verified proof.
    assert!(wrapper.contains("verifyChallenges.stage1Hash[0] <== s0_masked_stage1Hash;"));
    assert!(
        wrapper.contains("verifyGlobalConstraints.s0_airgroupvalues <== s0_masked_airgroupvalues;")
    );
    assert!(wrapper.contains("isNull[0] <== s0_sv_isNull;"));
    assert!(wrapper.contains("noAggregatedProofs === 0;"));

    let input = dir.join("final.circom");
    let output = dir.join("final.r1cs");
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
fn compiles_sample_final_wrapper_circom() -> anyhow::Result<()> {
    let dir =
        std::env::temp_dir().join(format!("pk_setup_final_circom_test_{}", std::process::id()));
    if dir.exists() {
        std::fs::remove_dir_all(&dir)?;
    }
    std::fs::create_dir_all(&dir)?;
    let includes = crate::circom_assets::write_recursive_include_assets(&dir)?;

    let vadcop = sample_vadcop_info();
    let mut stark = sample_stark_info();
    stark.n_publics = 31;
    stark.airgroup_values_map = vec![CircomNamedMap { name: "agg".to_string(), stage: 1 }];
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
    std::fs::write(dir.join("sample_final_recursive2_verifier.circom"), verifier)?;

    let global_constraints = CircomGlobalConstraintsInfo { constraints: Vec::new() };
    let wrapper = render_final_circom(
        &[stark],
        &vadcop,
        &global_constraints,
        &["sample_final_recursive2_verifier.circom".to_string()],
        &[vec![1, 2, 3, 4]],
        &[vec![vec![1, 2, 3, 4]]],
    );
    let input = dir.join("final.circom");
    let output = dir.join("final.r1cs");
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

fn assert_order(out: &str, needles: &[&str]) {
    let mut previous = 0;
    for needle in needles {
        let idx =
            out.find(needle).unwrap_or_else(|| panic!("missing expected declaration: {needle}"));
        assert!(
            idx >= previous,
            "declaration `{needle}` appears before the previous expected declaration"
        );
        previous = idx;
    }
}

fn recursive1_template(out: &str) -> &str {
    out.split_once("template Recursive1() {")
        .map(|(_, rest)| rest)
        .expect("missing Recursive1 template")
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
        num_challenges: vec![0, 2],
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

fn sample_global_constraint_with_tmp(tmp_id: u64) -> CircomGlobalConstraint {
    CircomGlobalConstraint {
        block: CircomCodeBlock {
            tmp_used: tmp_id + 1,
            code: vec![CircomCodeLine {
                op: "mul".to_string(),
                dest: tmp_ref(tmp_id, 1),
                src: vec![number_ref("1"), number_ref("0")],
            }],
        },
        boundary: None,
        line: None,
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
        airgroup_id: None,
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
        airgroup_id: None,
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
        airgroup_id: None,
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
        airgroup_id: None,
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
        airgroup_id: None,
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
        airgroup_id: None,
    }
}
