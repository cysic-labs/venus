//! Non-recursive setup command: the main orchestrator for the setup pipeline.
//!
//! Ports the non-recursive path of `pil2-proofman-js/src/cmd/setup_cmd.js`.

use std::fs;
use std::path::{Path, PathBuf};

use anyhow::Result;
// IndexMap used in some helper functions below
#[allow(unused_imports)]
use indexmap::IndexMap;
use pilout::pilout as pb;
use prost::Message;
use serde_json::json;

use crate::json_output;
use crate::pil_info;
use crate::prepare_pil::PrepareOptions;
use crate::security::{self, FRISecurityParams};
use crate::stark_struct::{generate_stark_struct, StarkSettings, StarkStruct};
use crate::types::{
    BoundaryOutput, ChallengeMapEntryOutput, EvMapEntry, NameStageEntry,
    PolMapEntry, PublicMapEntry, SecurityInfo, StarkInfoOutput,
    StarkStructOutput, StepOutput,
};

/// Setup options parsed from CLI args.
pub struct SetupOptions {
    pub airout_path: String,
    pub build_dir: String,
    pub fixed_dir: Option<String>,
    pub stark_structs_path: Option<String>,
    pub recursive: bool,
}


/// Run the non-recursive setup pipeline.
pub fn run_setup(opts: &SetupOptions) -> Result<()> {
    // Load pilout
    let pilout_data = fs::read(&opts.airout_path)?;
    let pilout = pb::PilOut::decode(pilout_data.as_slice())?;
    let pilout_name = pilout.name.clone().unwrap_or_else(|| "pilout".to_string());

    // Load settings
    let settings_map: IndexMap<String, StarkSettings> =
        if let Some(ref settings_path) = opts.stark_structs_path {
            let data = fs::read_to_string(settings_path)?;
            serde_json::from_str(&data)?
        } else {
            IndexMap::new()
        };


    // Process each airgroup / air
    for (ag_idx, airgroup) in pilout.air_groups.iter().enumerate() {
        let airgroup_name = airgroup
            .name
            .clone()
            .unwrap_or_else(|| format!("airgroup_{}", ag_idx));

        for (air_idx, air) in airgroup.airs.iter().enumerate() {
            let air_name = air
                .name
                .clone()
                .unwrap_or_else(|| format!("air_{}", air_idx));
            let num_rows = air.num_rows.unwrap_or(0) as usize;

            if num_rows == 0 {
                tracing::warn!("Skipping air '{}' with numRows=0", air_name);
                continue;
            }

            // num_rows is the actual row count (a power of 2).
            // We need log2(num_rows) for the stark struct.
            let n_bits = log2_usize(num_rows);

            tracing::info!("Computing setup for air '{}'", air_name);

            // Resolve settings for this air.
            // Match JS setup_cmd behavior: default powBits to 16 when not set.
            let air_settings = {
                let mut s = settings_map
                    .get(&air_name)
                    .or_else(|| settings_map.get("default"))
                    .cloned()
                    .unwrap_or_default();
                if s.pow_bits.is_none() {
                    s.pow_bits = Some(16);
                }
                s
            };

            // Generate stark struct
            let stark_struct = if let Some(ref _existing) = None::<StarkStruct> {
                // Not used: would be for pre-existing starkStruct in settings
                unreachable!()
            } else {
                generate_stark_struct(&air_settings, n_bits)
            };

            // Prepare output directory
            let files_dir = PathBuf::from(&opts.build_dir)
                .join("provingKey")
                .join(&pilout_name)
                .join(&airgroup_name)
                .join("airs")
                .join(&air_name)
                .join("air");
            fs::create_dir_all(&files_dir)?;

            // Copy fixed columns from --fixed-dir or skip
            let const_path = files_dir.join(format!("{}.const", air_name));
            if let Some(ref fixed_dir) = opts.fixed_dir {
                let src = Path::new(fixed_dir).join(format!("{}.fixed", air_name));
                if src.exists() {
                    fs::copy(&src, &const_path)?;
                } else {
                    tracing::warn!(
                        "Fixed file not found: {}, skipping copy",
                        src.display()
                    );
                }
            }

            // Run pil_info
            let prepare_opts = PrepareOptions {
                debug: false,
                im_pols_stages: false,
            };

            let pil_result =
                pil_info::pil_info(&pilout, ag_idx, air_idx, &stark_struct, &prepare_opts);

            // Build starkinfo output
            let setup_result = &pil_result.setup;
            let pil_code = &pil_result.pil_code;

            // Compute FRI security params
            let ev_map_len = pil_code.ev_map.len();
            let folding_factors = compute_folding_factors(&stark_struct);
            let opening_points = collect_opening_points(setup_result);

            let field_size = security::goldilocks_cube_field_size();
            let fri_params = FRISecurityParams {
                field_size,
                dimension: 1u64 << stark_struct.n_bits,
                rate: 1.0 / (1u64 << (stark_struct.n_bits_ext - stark_struct.n_bits)) as f64,
                n_opening_points: opening_points.len() as u64,
                n_functions: ev_map_len.max(1) as u64,
                folding_factors: folding_factors.clone(),
                max_grinding_bits: stark_struct.pow_bits as u64,
                use_max_grinding_bits: true,
                tree_arity: stark_struct.merkle_tree_arity as u64,
                target_security_bits: 128,
            };

            let fri_security = security::get_optimal_fri_query_params("JBR", &fri_params);

            // Build StarkInfoOutput for JSON serialization
            let starkinfo_output = build_starkinfo_output(
                setup_result,
                &stark_struct,
                pil_code,
                &opening_points,
                &fri_security,
                ag_idx,
                air_idx,
                &air_name,
                pil_result.c_exp_id,
                pil_result.fri_exp_id,
                pil_result.q_deg,
            );

            // Write starkinfo.json
            let starkinfo_json = json_output::to_json_string(&starkinfo_output)?;
            let starkinfo_path = files_dir.join(format!("{}.starkinfo.json", air_name));
            fs::write(&starkinfo_path, &starkinfo_json)?;

            // Write expressionsinfo.json
            let expr_info_json = build_expressions_info_json(&pil_code.expressions_info);
            let expr_info_str = json_output::to_json_string(&expr_info_json)?;
            fs::write(
                files_dir.join(format!("{}.expressionsinfo.json", air_name)),
                &expr_info_str,
            )?;

            // Write verifierinfo.json
            let verifier_info_json = build_verifier_info_json(&pil_code.verifier_info);
            let verifier_info_str = json_output::to_json_string(&verifier_info_json)?;
            fs::write(
                files_dir.join(format!("{}.verifierinfo.json", air_name)),
                &verifier_info_str,
            )?;

            // Compute constant polynomial Merkle tree -> verkey.json / verkey.bin
            let verkey_json_path = files_dir.join(format!("{}.verkey.json", air_name));
            if const_path.exists() {
                tracing::info!("Computing Constant Tree...");
                match crate::bctree::compute_const_tree(
                    const_path.to_str().unwrap_or(""),
                    starkinfo_path.to_str().unwrap_or(""),
                    verkey_json_path.to_str().unwrap_or(""),
                ) {
                    Ok(const_root) => {
                        // Write verkey.bin from the returned root values
                        let mut verkey_bin = Vec::with_capacity(32);
                        for &val in const_root.iter() {
                            verkey_bin.extend_from_slice(&val.to_le_bytes());
                        }
                        fs::write(
                            files_dir.join(format!("{}.verkey.bin", air_name)),
                            &verkey_bin,
                        )?;
                    }
                    Err(e) => {
                        tracing::warn!(
                            "bctree failed for air '{}': {:#}. \
                             Skipping verkey generation.",
                            air_name, e
                        );
                    }
                }
            } else {
                tracing::warn!(
                    "Skipping bctree: const file not found at {}",
                    const_path.display()
                );
            }

            // Write binary files using native Rust implementation
            write_bin_files_native(
                &starkinfo_path,
                &files_dir.join(format!("{}.expressionsinfo.json", air_name)),
                &files_dir.join(format!("{}.verifierinfo.json", air_name)),
                &files_dir.join(format!("{}.bin", air_name)),
                &files_dir.join(format!("{}.verifier.bin", air_name)),
            )?;

            tracing::info!("Setup for air '{}' complete", air_name);
        }
    }

    // Generate globalInfo.json and globalConstraints
    write_global_info(&pilout, &pilout_name, &opts.build_dir)?;

    // Recursive setup (if --recursive is set)
    if opts.recursive {
        tracing::info!("Starting recursive setup...");
        run_recursive_setup(&pilout, &pilout_name, opts)?;
    }

    tracing::info!("Setup complete");
    Ok(())
}

/// Run the recursive setup pipeline after non-recursive AIR setup.
///
/// For each airgroup/air:
///   1. Check whether a compressor is needed
///   2. If so, run compressor recursive setup
///   3. Run recursive1
/// Then for each airgroup:
///   4. Run recursive2
/// Then globally:
///   5. Run final setup
///   6. Run compressed final setup
fn run_recursive_setup(
    pilout: &pb::PilOut,
    pilout_name: &str,
    opts: &SetupOptions,
) -> Result<()> {
    use crate::compressor_check;
    use crate::compressed_final;
    use crate::final_setup;
    use crate::recursive_setup::{self, RecursiveTemplate, RecursiveSetupConfig};
    use crate::witness_gen::WitnessTracker;

    let witness_tracker = WitnessTracker::new();
    let build_dir = &opts.build_dir;

    // Resolve tool paths (these would typically come from CLI args or env)
    let circom_exec = resolve_circom_exec();
    let circuits_gl_path = resolve_path_env("CIRCUITS_GL_PATH", "circuits.gl");
    let recurser_circuits_path =
        resolve_path_env("RECURSER_CIRCUITS_PATH", "vadcop/helpers/circuits");
    let std_pil_path = resolve_path_env("STD_PIL_PATH", "pil");
    let recurser_pil_path = resolve_path_env("RECURSER_PIL_PATH", "circom2pil/pil");
    let circom_helpers_dir = resolve_path_env("CIRCOM_HELPERS_DIR", "circom");

    // Read globalInfo
    let proving_key_dir = Path::new(build_dir).join("provingKey");
    let global_info_path = proving_key_dir.join("pilout.globalInfo.json");
    let global_info: serde_json::Value = if global_info_path.exists() {
        serde_json::from_str(&fs::read_to_string(&global_info_path)?)?
    } else {
        tracing::warn!("globalInfo.json not found, cannot run recursive setup");
        return Ok(());
    };

    let global_constraints_path = proving_key_dir.join("pilout.globalConstraints.json");
    let global_constraints: serde_json::Value = if global_constraints_path.exists() {
        serde_json::from_str(&fs::read_to_string(&global_constraints_path)?)?
    } else {
        serde_json::json!({"constraints": [], "hints": []})
    };

    // Per-airgroup, per-air: check compressor and run recursive1
    let mut recursive1_vkeys: Vec<Vec<Vec<String>>> = Vec::new();
    let mut recursive1_stark_infos: Vec<serde_json::Value> = Vec::new();
    let mut recursive1_verifier_infos: Vec<serde_json::Value> = Vec::new();

    for (ag_idx, airgroup) in pilout.air_groups.iter().enumerate() {
        let airgroup_name = airgroup
            .name
            .clone()
            .unwrap_or_else(|| format!("airgroup_{}", ag_idx));

        let mut ag_vkeys: Vec<Vec<String>> = Vec::new();

        for (air_idx, air) in airgroup.airs.iter().enumerate() {
            let air_name = air
                .name
                .clone()
                .unwrap_or_else(|| format!("air_{}", air_idx));
            let num_rows = air.num_rows.unwrap_or(0) as usize;
            if num_rows == 0 {
                continue;
            }

            // Read this air's starkinfo and verifierinfo
            let files_dir = PathBuf::from(build_dir)
                .join("provingKey")
                .join(pilout_name)
                .join(&airgroup_name)
                .join("airs")
                .join(&air_name)
                .join("air");

            let si_path = files_dir.join(format!("{}.starkinfo.json", air_name));
            let vi_path = files_dir.join(format!("{}.verifierinfo.json", air_name));
            let vk_path = files_dir.join(format!("{}.verkey.json", air_name));

            if !si_path.exists() || !vi_path.exists() {
                tracing::warn!(
                    "Skipping recursive setup for air '{}': starkinfo/verifierinfo not found",
                    air_name
                );
                continue;
            }

            let stark_info: serde_json::Value =
                serde_json::from_str(&fs::read_to_string(&si_path)?)?;
            let verifier_info: serde_json::Value =
                serde_json::from_str(&fs::read_to_string(&vi_path)?)?;

            let const_root_strings: [String; 4] = if vk_path.exists() {
                let vk: Vec<serde_json::Value> =
                    serde_json::from_str(&fs::read_to_string(&vk_path)?)?;
                [
                    vk.get(0).and_then(|v| v.as_u64()).unwrap_or(0).to_string(),
                    vk.get(1).and_then(|v| v.as_u64()).unwrap_or(0).to_string(),
                    vk.get(2).and_then(|v| v.as_u64()).unwrap_or(0).to_string(),
                    vk.get(3).and_then(|v| v.as_u64()).unwrap_or(0).to_string(),
                ]
            } else {
                ["0".into(), "0".into(), "0".into(), "0".into()]
            };

            // Check if compressor is needed
            let has_compressor = match compressor_check::is_compressor_needed(
                &const_root_strings,
                &stark_info,
                &verifier_info,
                si_path.to_str().unwrap_or(""),
                &circom_exec,
                &circuits_gl_path,
            ) {
                Ok(result) => result.needed,
                Err(e) => {
                    tracing::warn!(
                        "Compressor check failed for air '{}': {:#}, assuming not needed",
                        air_name,
                        e
                    );
                    false
                }
            };

            if has_compressor {
                tracing::info!("Air '{}' needs compressor", air_name);

                // Run compressor setup
                let compressor_config = RecursiveSetupConfig {
                    build_dir,
                    template: RecursiveTemplate::Compressor,
                    airgroup_name: &airgroup_name,
                    airgroup_id: ag_idx,
                    air_id: air_idx,
                    air_name: &air_name,
                    global_info: &global_info,
                    const_root: &const_root_strings,
                    verification_keys: &[],
                    stark_info: &stark_info,
                    verifier_info: &verifier_info,
                    stark_struct: None,
                    has_compressor: false,
                    circom_exec: &circom_exec,
                    circuits_gl_path: &circuits_gl_path,
                    recurser_circuits_path: &recurser_circuits_path,
                    std_pil_path: &std_pil_path,
                    recurser_pil_path: &recurser_pil_path,
                    circom_helpers_dir: &circom_helpers_dir,
                };

                match recursive_setup::gen_recursive_setup(&compressor_config, &witness_tracker) {
                    Ok(_result) => {
                        tracing::info!("Compressor setup complete for air '{}'", air_name);
                    }
                    Err(e) => {
                        tracing::error!("Compressor setup failed for air '{}': {:#}", air_name, e);
                    }
                }
            }

            // Run recursive1
            tracing::info!("Running recursive1 for air '{}'", air_name);
            let r1_config = RecursiveSetupConfig {
                build_dir,
                template: RecursiveTemplate::Recursive1,
                airgroup_name: &airgroup_name,
                airgroup_id: ag_idx,
                air_id: air_idx,
                air_name: &air_name,
                global_info: &global_info,
                const_root: &const_root_strings,
                verification_keys: &[],
                stark_info: &stark_info,
                verifier_info: &verifier_info,
                stark_struct: None,
                has_compressor,
                circom_exec: &circom_exec,
                circuits_gl_path: &circuits_gl_path,
                recurser_circuits_path: &recurser_circuits_path,
                std_pil_path: &std_pil_path,
                recurser_pil_path: &recurser_pil_path,
                circom_helpers_dir: &circom_helpers_dir,
            };

            match recursive_setup::gen_recursive_setup(&r1_config, &witness_tracker) {
                Ok(result) => {
                    let vk_str: Vec<String> =
                        result.const_root.iter().map(|v| v.to_string()).collect();
                    ag_vkeys.push(vk_str);
                    tracing::info!("Recursive1 setup complete for air '{}'", air_name);
                }
                Err(e) => {
                    tracing::error!("Recursive1 setup failed for air '{}': {:#}", air_name, e);
                }
            }
        }

        recursive1_vkeys.push(ag_vkeys);
    }

    // Per-airgroup: run recursive2
    for (ag_idx, airgroup) in pilout.air_groups.iter().enumerate() {
        let airgroup_name = airgroup
            .name
            .clone()
            .unwrap_or_else(|| format!("airgroup_{}", ag_idx));

        // Find the first valid air for this airgroup to get starkinfo
        let first_air = airgroup.airs.first();
        let air_name = first_air
            .and_then(|a| a.name.clone())
            .unwrap_or_else(|| "air_0".to_string());

        // Read recursive1 starkinfo and verifierinfo (from first air's recursive1 directory)
        let r1_dir = PathBuf::from(build_dir)
            .join("provingKey")
            .join(pilout_name)
            .join(&airgroup_name)
            .join("airs")
            .join(&air_name)
            .join("recursive1");

        let si_path = r1_dir.join("recursive1.starkinfo.json");
        let vi_path = r1_dir.join("recursive1.verifierinfo.json");

        // Fallback to the air starkinfo if recursive1 doesn't have one
        let (stark_info, verifier_info) = if si_path.exists() && vi_path.exists() {
            let si: serde_json::Value =
                serde_json::from_str(&fs::read_to_string(&si_path)?)?;
            let vi: serde_json::Value =
                serde_json::from_str(&fs::read_to_string(&vi_path)?)?;
            (si, vi)
        } else {
            let air_dir = PathBuf::from(build_dir)
                .join("provingKey")
                .join(pilout_name)
                .join(&airgroup_name)
                .join("airs")
                .join(&air_name)
                .join("air");
            let si: serde_json::Value = serde_json::from_str(
                &fs::read_to_string(air_dir.join(format!("{}.starkinfo.json", air_name)))?,
            )?;
            let vi: serde_json::Value = serde_json::from_str(
                &fs::read_to_string(air_dir.join(format!("{}.verifierinfo.json", air_name)))?,
            )?;
            (si, vi)
        };

        let const_root_strings: [String; 4] =
            ["0".into(), "0".into(), "0".into(), "0".into()];

        let vkeys = if ag_idx < recursive1_vkeys.len() {
            &recursive1_vkeys[ag_idx]
        } else {
            &vec![]
        };

        let vkeys_nested: Vec<Vec<Vec<String>>> = vec![vkeys.clone()];

        tracing::info!("Running recursive2 for airgroup '{}'", airgroup_name);
        let r2_config = RecursiveSetupConfig {
            build_dir,
            template: RecursiveTemplate::Recursive2,
            airgroup_name: &airgroup_name,
            airgroup_id: ag_idx,
            air_id: 0,
            air_name: &air_name,
            global_info: &global_info,
            const_root: &const_root_strings,
            verification_keys: &vkeys_nested,
            stark_info: &stark_info,
            verifier_info: &verifier_info,
            stark_struct: None,
            has_compressor: false,
            circom_exec: &circom_exec,
            circuits_gl_path: &circuits_gl_path,
            recurser_circuits_path: &recurser_circuits_path,
            std_pil_path: &std_pil_path,
            recurser_pil_path: &recurser_pil_path,
            circom_helpers_dir: &circom_helpers_dir,
        };

        match recursive_setup::gen_recursive_setup(&r2_config, &witness_tracker) {
            Ok(result) => {
                if let Some(si) = &result.stark_info {
                    recursive1_stark_infos.push(si.clone());
                }
                if let Some(vi) = &result.verifier_info {
                    recursive1_verifier_infos.push(vi.clone());
                }
                tracing::info!("Recursive2 setup complete for airgroup '{}'", airgroup_name);
            }
            Err(e) => {
                tracing::error!(
                    "Recursive2 setup failed for airgroup '{}': {:#}",
                    airgroup_name,
                    e
                );
            }
        }
    }

    // Run final setup
    tracing::info!("Running final setup...");
    let final_config = final_setup::FinalSetupConfig {
        build_dir,
        global_info: &global_info,
        global_constraints: &global_constraints,
        circom_exec: &circom_exec,
        circuits_gl_path: &circuits_gl_path,
        recurser_circuits_path: &recurser_circuits_path,
        std_pil_path: &std_pil_path,
        recurser_pil_path: &recurser_pil_path,
        circom_helpers_dir: &circom_helpers_dir,
    };

    let final_result = match final_setup::gen_final_setup(&final_config, &witness_tracker) {
        Ok(result) => {
            tracing::info!("Final setup complete");
            Some(result)
        }
        Err(e) => {
            tracing::error!("Final setup failed: {:#}", e);
            None
        }
    };

    // Run compressed final setup
    if let Some(ref fr) = final_result {
        tracing::info!("Running compressed final setup...");
        let const_root_str: [String; 4] = [
            fr.const_root[0].to_string(),
            fr.const_root[1].to_string(),
            fr.const_root[2].to_string(),
            fr.const_root[3].to_string(),
        ];

        let compressed_config = compressed_final::CompressedFinalConfig {
            build_dir,
            name: pilout_name,
            const_root: &const_root_str,
            verification_keys: &[],
            stark_info: &fr.stark_info,
            verifier_info: &fr.verifier_info,
            circom_exec: &circom_exec,
            circuits_gl_path: &circuits_gl_path,
            recurser_circuits_path: &recurser_circuits_path,
            std_pil_path: &std_pil_path,
            recurser_pil_path: &recurser_pil_path,
            circom_helpers_dir: &circom_helpers_dir,
        };

        match compressed_final::gen_compressed_final_setup(&compressed_config, &witness_tracker) {
            Ok(()) => tracing::info!("Compressed final setup complete"),
            Err(e) => tracing::error!("Compressed final setup failed: {:#}", e),
        }
    }

    // Wait for all witness library builds
    witness_tracker.await_all()?;

    tracing::info!("Recursive setup complete");
    Ok(())
}

/// Resolve circom executable path.
fn resolve_circom_exec() -> String {
    let candidates = if cfg!(target_os = "macos") {
        vec!["circom_mac", "circom"]
    } else {
        vec!["circom", "./circom"]
    };
    for path in &candidates {
        if Path::new(path).exists() {
            return path.to_string();
        }
    }
    "circom".to_string()
}

/// Resolve a path from environment variable or fallback.
fn resolve_path_env(env_var: &str, fallback: &str) -> String {
    std::env::var(env_var).unwrap_or_else(|_| fallback.to_string())
}

/// Build the StarkInfoOutput for JSON serialization from internal types.
pub fn build_starkinfo_output(
    setup: &crate::pilout_info::SetupResult,
    stark_struct: &StarkStruct,
    pil_code: &crate::generate_pil_code::PilCodeResult,
    opening_points: &[i64],
    fri_security: &security::FRIQueryResult,
    airgroup_id: usize,
    air_id: usize,
    air_name: &str,
    c_exp_id: usize,
    fri_exp_id: usize,
    q_deg: i64,
) -> StarkInfoOutput {
    let steps: Vec<StepOutput> = stark_struct
        .steps
        .iter()
        .map(|s| StepOutput { n_bits: s.n_bits })
        .collect();

    let stark_struct_out = StarkStructOutput {
        n_bits: stark_struct.n_bits,
        merkle_tree_arity: stark_struct.merkle_tree_arity,
        transcript_arity: stark_struct.transcript_arity,
        merkle_tree_custom: stark_struct.merkle_tree_custom,
        last_level_verification: if stark_struct.last_level_verification > 0 {
            Some(stark_struct.last_level_verification)
        } else {
            None
        },
        pow_bits: fri_security.n_grinding_bits as usize,
        hash_commits: stark_struct.hash_commits,
        n_bits_ext: stark_struct.n_bits_ext,
        verification_hash_type: stark_struct.verification_hash_type.clone(),
        steps,
        n_queries: fri_security.n_queries as usize,
    };

    let boundaries: Vec<BoundaryOutput> = {
        let mut seen = Vec::new();
        let mut result = Vec::new();
        // Collect from constraints
        for c in &setup.constraints {
            if !seen.contains(&c.boundary) {
                seen.push(c.boundary.clone());
                let b = BoundaryOutput {
                    name: c.boundary.clone(),
                    offset_min: c.offset_min.map(|v| v as i64),
                    offset_max: c.offset_max.map(|v| v as i64),
                };
                result.push(b);
            }
        }
        if result.is_empty() {
            result.push(BoundaryOutput {
                name: "everyRow".to_string(),
                offset_min: None,
                offset_max: None,
            });
        }
        result
    };

    // Build evMap from verifier code context
    let ev_map: Vec<EvMapEntry> = pil_code
        .ev_map
        .iter()
        .map(|e| EvMapEntry {
            entry_type: e.entry_type.clone(),
            id: e.id,
            prime: e.prime,
            opening_pos: e.opening_pos,
            commit_id: e.commit_id,
        })
        .collect();

    let n_stages = setup.n_stages;

    // Build cmPolsMap as flat array matching golden schema.
    // Field order differs between Q-stage entries and regular entries.
    // JS map.js builds objects in this order:
    //   setSymbolSections: {stage, name, dim, polsMapId, [stageId], [lengths], [imPol, expId]}
    //   setStageInfoSymbols: adds stagePos, then stageId if not already set
    // Result for regular entries: stage, name, dim, polsMapId, stageId, [lengths], stagePos, [imPol, expId]
    // Result for Q-stage entries: stage, name, dim, polsMapId, stagePos, stageId
    let q_stage = n_stages + 1;
    let cm_pols_map: Vec<serde_json::Value> = setup
        .cm_pols_map
        .iter()
        .enumerate()
        .map(|(i, p)| {
            let stage = p.stage.unwrap_or(0);
            let mut obj = serde_json::Map::new();
            obj.insert("stage".to_string(), json!(stage));
            obj.insert("name".to_string(), json!(p.name));
            obj.insert("dim".to_string(), json!(p.dim));
            obj.insert("polsMapId".to_string(), json!(i));
            if stage == q_stage {
                // Q-stage: stagePos before stageId
                obj.insert("stagePos".to_string(), json!(p.stage_pos.unwrap_or(0)));
                obj.insert("stageId".to_string(), json!(p.stage_id.unwrap_or(0)));
            } else {
                // Regular: stageId first
                obj.insert("stageId".to_string(), json!(p.stage_id.unwrap_or(0)));
                // Then lengths (if present)
                if let Some(ref lengths) = p.lengths {
                    obj.insert("lengths".to_string(), json!(lengths));
                }
                // imPol and expId come before stagePos (matches JS insertion
                // order: addPol sets imPol/expId, then setStageInfoSymbols
                // appends stagePos)
                if p.im_pol {
                    obj.insert("imPol".to_string(), json!(true));
                    if let Some(eid) = p.exp_id {
                        obj.insert("expId".to_string(), json!(eid));
                    }
                }
                obj.insert("stagePos".to_string(), json!(p.stage_pos.unwrap_or(0)));
            }
            serde_json::Value::Object(obj)
        })
        .collect();

    let const_pols_map: Vec<PolMapEntry> = setup
        .const_pols_map
        .iter()
        .enumerate()
        .map(|(i, p)| PolMapEntry {
            stage: 0,
            name: p.name.clone(),
            dim: p.dim,
            pols_map_id: i,
            stage_id: p.stage_id.unwrap_or(0),
            lengths: None,
            stage_pos: None, // constPolsMap entries don't have stagePos in golden
            im_pol: None,
            exp_id: None,
        })
        .collect();

    // Build mapSectionsN as a serde_json::Map to preserve order
    let mut map_sections_n = serde_json::Map::new();
    for (key, &val) in &setup.map_sections_n {
        map_sections_n.insert(key.clone(), json!(val));
    }

    // Build custom commits JSON
    let custom_commits_json: Vec<serde_json::Value> = setup
        .custom_commits
        .iter()
        .map(|cc| {
            json!({
                "name": cc.name,
                "stageWidths": cc.stage_widths,
            })
        })
        .collect();

    // Build custom commits map
    let custom_commits_map: Vec<serde_json::Value> = Vec::new();

    // Build challengesMap from setup + FRI challenges.
    // Start from setup.challenges_map (may have default-filled gaps).
    let mut challenges_map: Vec<ChallengeMapEntryOutput> = setup
        .challenges_map
        .iter()
        .map(|s| ChallengeMapEntryOutput {
            name: s.name.clone(),
            stage: s.stage.unwrap_or(0),
            dim: s.dim,
            stage_id: s.stage_id.unwrap_or(0),
        })
        .collect();
    // Merge FRI challenges (std_vf1, std_vf2) by index position.
    // pil_code.challenges_map is indexed by challenge id; overwrite by name.
    for (i, ch) in pil_code.challenges_map.iter().enumerate() {
        if ch.name.is_empty() {
            continue;
        }
        let entry = ChallengeMapEntryOutput {
            name: ch.name.clone(),
            stage: ch.stage,
            dim: ch.dim,
            stage_id: ch.stage_id,
        };
        // Ensure the map is long enough
        while challenges_map.len() <= i {
            challenges_map.push(ChallengeMapEntryOutput::default());
        }
        challenges_map[i] = entry;
    }
    // Remove trailing empty entries
    while challenges_map.last().map_or(false, |e| e.name.is_empty()) {
        challenges_map.pop();
    }
    // Also remove any interior empty entries (they shouldn't exist in golden)
    challenges_map.retain(|e| !e.name.is_empty());

    // Build publicsMap
    let publics_map: Vec<PublicMapEntry> = setup
        .publics_map
        .iter()
        .map(|s| PublicMapEntry {
            name: s.name.clone(),
            stage: s.stage.unwrap_or(0),
            lengths: s.lengths.clone(),
        })
        .collect();

    // Build proofValuesMap
    let proof_values_map: Vec<NameStageEntry> = setup
        .proof_values_map
        .iter()
        .map(|s| NameStageEntry {
            name: s.name.clone(),
            stage: s.stage.unwrap_or(0),
            lengths: s.lengths.clone(),
        })
        .collect();

    // Build airgroupValuesMap
    let airgroup_values_map: Vec<NameStageEntry> = setup
        .airgroup_values_map
        .iter()
        .map(|s| NameStageEntry {
            name: s.name.clone(),
            stage: s.stage.unwrap_or(0),
            lengths: s.lengths.clone(),
        })
        .collect();

    // Build airValuesMap
    let air_values_map: Vec<NameStageEntry> = setup
        .air_values_map
        .iter()
        .map(|s| NameStageEntry {
            name: s.name.clone(),
            stage: s.stage.unwrap_or(0),
            lengths: s.lengths.clone(),
        })
        .collect();

    // Build airGroupValues
    let air_group_values: Vec<serde_json::Value> = setup
        .air_group_values
        .iter()
        .map(|v| json!({"aggType": v.agg_type, "stage": v.stage}))
        .collect();

    // nCommitmentsStage1: in JS this compares stage === "cm1" (number vs string),
    // which always evaluates to 0. Golden confirms nCommitmentsStage1=0.
    let n_commitments_stage1 = 0;

    StarkInfoOutput {
        name: air_name.to_string(),
        cm_pols_map,
        const_pols_map,
        challenges_map,
        publics_map,
        proof_values_map,
        airgroup_values_map,
        air_values_map,
        map_sections_n,
        air_id,
        airgroup_id,
        n_constants: setup.n_constants,
        n_publics: setup.n_publics,
        air_group_values,
        n_stages,
        custom_commits: custom_commits_json,
        custom_commits_map,
        stark_struct: stark_struct_out,
        boundaries,
        opening_points: opening_points.to_vec(),
        c_exp_id,
        q_dim: crate::pilout_info::FIELD_EXTENSION,
        q_deg: q_deg.max(1) as usize,
        n_constraints: setup.constraints.len(),
        n_commitments_stage1,
        ev_map,
        fri_exp_id,
        security: Some(SecurityInfo {
            proximity_gap: fri_security.proximity_gap,
            proximity_parameter: fri_security.proximity_parameter,
            regime: "JBR".to_string(),
        }),
    }
}

pub fn collect_opening_points(setup: &crate::pilout_info::SetupResult) -> Vec<i64> {
    let mut points: Vec<i64> = vec![0];
    for c in &setup.constraints {
        let offsets = &setup.expressions[c.e].rows_offsets;
        for &offset in offsets {
            if !points.contains(&offset) {
                points.push(offset);
            }
        }
    }
    points.sort();
    points
}

pub fn compute_folding_factors(stark_struct: &StarkStruct) -> Vec<u64> {
    let steps = &stark_struct.steps;
    let mut factors = Vec::new();
    for i in 0..steps.len() - 1 {
        factors.push((steps[i].n_bits - steps[i + 1].n_bits) as u64);
    }
    factors
}

/// Build the expressionsinfo JSON structure.
pub fn build_expressions_info_json(
    info: &crate::generate_pil_code::ExpressionsInfo,
) -> serde_json::Value {
    let expressions_code: Vec<serde_json::Value> = info
        .expressions_code
        .iter()
        .map(|e| {
            let mut obj = serde_json::Map::new();
            obj.insert("tmpUsed".to_string(), json!(e.tmp_used));
            obj.insert("code".to_string(), code_entries_to_json(&e.code));
            obj.insert("expId".to_string(), json!(e.exp_id));
            obj.insert("stage".to_string(), json!(e.stage));
            if let Some(ref dest) = e.dest {
                obj.insert(
                    "dest".to_string(),
                    json!({
                        "op": dest.op,
                        "stage": dest.stage,
                        "stageId": dest.stage_id,
                        "id": dest.id,
                    }),
                );
            }
            obj.insert("line".to_string(), json!(e.line));
            serde_json::Value::Object(obj)
        })
        .collect();

    let constraints: Vec<serde_json::Value> = info
        .constraints
        .iter()
        .map(|c| {
            let mut obj = serde_json::Map::new();
            obj.insert("tmpUsed".to_string(), json!(c.tmp_used));
            obj.insert("code".to_string(), code_entries_to_json(&c.code));
            obj.insert("boundary".to_string(), json!(c.boundary));
            if let Some(ref line) = c.line {
                obj.insert("line".to_string(), json!(line));
            }
            obj.insert("imPol".to_string(), json!(c.im_pol));
            obj.insert("stage".to_string(), json!(c.stage));
            if let Some(omin) = c.offset_min {
                obj.insert("offsetMin".to_string(), json!(omin));
            }
            if let Some(omax) = c.offset_max {
                obj.insert("offsetMax".to_string(), json!(omax));
            }
            serde_json::Value::Object(obj)
        })
        .collect();

    let hints_info: Vec<serde_json::Value> = info
        .hints_info
        .iter()
        .map(|h| {
            json!({
                "name": h.name,
                "fields": h.fields.iter().map(|f| {
                    json!({
                        "name": f.name,
                        "values": f.values.iter().map(|v| {
                            hint_value_to_json(v)
                        }).collect::<Vec<_>>(),
                    })
                }).collect::<Vec<serde_json::Value>>(),
            })
        })
        .collect();

    // Build with explicit ordering matching golden: hintsInfo, expressionsCode, constraints
    let mut result = serde_json::Map::new();
    result.insert("hintsInfo".to_string(), serde_json::Value::Array(hints_info));
    result.insert("expressionsCode".to_string(), serde_json::Value::Array(expressions_code));
    result.insert("constraints".to_string(), serde_json::Value::Array(constraints));
    serde_json::Value::Object(result)
}

/// Build the verifierinfo JSON structure.
pub fn build_verifier_info_json(
    info: &crate::generate_pil_code::VerifierInfo,
) -> serde_json::Value {
    // qVerifier: {tmpUsed, code, line: ""}
    let mut qv = serde_json::Map::new();
    qv.insert("tmpUsed".to_string(), json!(info.q_verifier.tmp_used));
    qv.insert("code".to_string(), code_entries_to_json(&info.q_verifier.code));
    qv.insert("line".to_string(), json!(""));

    // queryVerifier: {tmpUsed, code, expId, stage, line}
    let mut qr = serde_json::Map::new();
    qr.insert("tmpUsed".to_string(), json!(info.query_verifier.tmp_used));
    qr.insert("code".to_string(), code_entries_to_json(&info.query_verifier.code));
    qr.insert("expId".to_string(), json!(info.query_verifier.exp_id));
    qr.insert("stage".to_string(), json!(info.query_verifier.stage));
    qr.insert("line".to_string(), json!(info.query_verifier.line));

    let mut result = serde_json::Map::new();
    result.insert("qVerifier".to_string(), serde_json::Value::Object(qv));
    result.insert("queryVerifier".to_string(), serde_json::Value::Object(qr));
    serde_json::Value::Object(result)
}

/// Serialize a hint field value to JSON matching golden field order per op type.
///
/// Field order per op type (matching JS object spread behavior):
///   string:         op, string, pos
///   number:         op, value, pos
///   tmp:            op, id, dim, pos
///   cm/custom/const: op, id, stageId, rowOffset, stage, dim, [commitId,] rowOffsetIndex, pos
///   challenge/public/airgroupvalue/airvalue/proofvalue:
///                   op, id, dim, stage, [stageId,] [airgroupId,] pos
fn hint_value_to_json(v: &crate::generate_pil_code::ProcessedHintField) -> serde_json::Value {
    let mut obj = serde_json::Map::new();
    obj.insert("op".to_string(), json!(v.op));
    match v.op.as_str() {
        "string" => {
            // Golden: {"op":"string","string":"<value>","pos":[]}
            if let Some(ref val) = v.value {
                obj.insert("string".to_string(), json!(val));
            }
            obj.insert("pos".to_string(), json!(v.pos));
        }
        "number" => {
            // Golden: {"op":"number","value":"<value>","pos":[]}
            if let Some(ref val) = v.value {
                obj.insert("value".to_string(), json!(val));
            }
            obj.insert("pos".to_string(), json!(v.pos));
        }
        "tmp" => {
            // Golden: {"op":"tmp","id":<id>,"dim":<dim>,"pos":[...]}
            if let Some(id) = v.id {
                obj.insert("id".to_string(), json!(id));
            }
            if let Some(dim) = v.dim {
                obj.insert("dim".to_string(), json!(dim));
            }
            obj.insert("pos".to_string(), json!(v.pos));
        }
        "cm" | "custom" | "const" => {
            // Golden: {"op":"cm","id":<id>,"stageId":<sid>,"rowOffset":<ro>,
            //          "stage":<s>,"dim":<d>,[commitId,]"rowOffsetIndex":<roi>,"pos":[...]}
            if let Some(id) = v.id {
                obj.insert("id".to_string(), json!(id));
            }
            if let Some(sid) = v.stage_id {
                obj.insert("stageId".to_string(), json!(sid));
            }
            if let Some(ro) = v.row_offset {
                obj.insert("rowOffset".to_string(), json!(ro));
            }
            if let Some(stage) = v.stage {
                obj.insert("stage".to_string(), json!(stage));
            }
            if let Some(dim) = v.dim {
                obj.insert("dim".to_string(), json!(dim));
            }
            if let Some(cid) = v.commit_id {
                obj.insert("commitId".to_string(), json!(cid));
            }
            if let Some(roi) = v.row_offset_index {
                obj.insert("rowOffsetIndex".to_string(), json!(roi));
            }
            obj.insert("pos".to_string(), json!(v.pos));
        }
        "challenge" => {
            // JS: { op: "challenge", stage, stageId, id } + pos
            if let Some(stage) = v.stage {
                obj.insert("stage".to_string(), json!(stage));
            }
            if let Some(sid) = v.stage_id {
                obj.insert("stageId".to_string(), json!(sid));
            }
            if let Some(id) = v.id {
                obj.insert("id".to_string(), json!(id));
            }
            if let Some(dim) = v.dim {
                obj.insert("dim".to_string(), json!(dim));
            }
            obj.insert("pos".to_string(), json!(v.pos));
        }
        "airgroupvalue" => {
            // JS: { op: "airgroupvalue", id, airgroupId, dim, stage } + pos
            if let Some(id) = v.id {
                obj.insert("id".to_string(), json!(id));
            }
            if let Some(agid) = v.airgroup_id {
                obj.insert("airgroupId".to_string(), json!(agid));
            }
            if let Some(dim) = v.dim {
                obj.insert("dim".to_string(), json!(dim));
            }
            if let Some(stage) = v.stage {
                obj.insert("stage".to_string(), json!(stage));
            }
            obj.insert("pos".to_string(), json!(v.pos));
        }
        _ => {
            // airvalue, proofvalue, public
            // JS airvalue/proofvalue: { op, id, stage, dim } + pos
            // JS public: { op, id, stage } + pos
            if let Some(id) = v.id {
                obj.insert("id".to_string(), json!(id));
            }
            if let Some(stage) = v.stage {
                obj.insert("stage".to_string(), json!(stage));
            }
            if let Some(dim) = v.dim {
                obj.insert("dim".to_string(), json!(dim));
            }
            obj.insert("pos".to_string(), json!(v.pos));
        }
    }
    serde_json::Value::Object(obj)
}

pub fn code_entries_to_json(entries: &[crate::types::CodeEntry]) -> serde_json::Value {
    let arr: Vec<serde_json::Value> = entries
        .iter()
        .map(|e| {
            json!({
                "op": e.op,
                "dest": code_ref_to_json(&e.dest),
                "src": e.src.iter().map(|s| code_ref_to_json(s)).collect::<Vec<_>>(),
            })
        })
        .collect();
    serde_json::Value::Array(arr)
}

/// Serialize a code ref to JSON matching the golden field order per type.
///
/// Each type has its own property order matching the JS object construction
/// order in codegen.js. The patterns are:
///   tmp (from binary op):  type, id, dim
///   tmp (from exp ref):    type, [expId,] id, prime, dim
///   cm/const/custom:       type, id, prime, dim, [commitId]
///   eval:                  type, id, dim
///   challenge:             type, id, stageId, dim, stage
///   public:                type, id, dim
///   proofvalue:            type, id, stage, dim
///   number:                type, value, dim
///   airgroupvalue/airvalue: type, id, stage, dim, [airgroupId]
///   xDivXSubXi:            type, id, opening, dim
///   Zi:                    type, boundaryId, dim
pub fn code_ref_to_json(r: &crate::types::CodeRef) -> serde_json::Value {
    let mut obj = serde_json::Map::new();
    obj.insert("type".to_string(), json!(r.ref_type));
    match r.ref_type.as_str() {
        "tmp" => {
            // Three tmp patterns based on JS object construction order:
            //   1. Binary op dest:       type, id, dim (no prime, no expId)
            //   2. pilCodeGen wrapper:    type, prime, id, dim (prime present, no expId)
            //   3. evalExp exp ref:       type, expId, id, prime, dim
            if let Some(eid) = r.exp_id {
                // Pattern 3: expId before id
                obj.insert("expId".to_string(), json!(eid));
                obj.insert("id".to_string(), json!(r.id));
                if let Some(prime) = r.prime {
                    obj.insert("prime".to_string(), json!(prime));
                }
            } else if r.prime.is_some() {
                // Pattern 2: prime before id
                obj.insert("prime".to_string(), json!(r.prime.unwrap()));
                obj.insert("id".to_string(), json!(r.id));
            } else {
                // Pattern 1: just id
                obj.insert("id".to_string(), json!(r.id));
            }
            obj.insert("dim".to_string(), json!(r.dim));
        }
        "cm" | "const" | "custom" => {
            // For ImPol cm refs, expId comes before id (matching JS object
            // property insertion order from evalExp where r starts as
            // {type: "exp", expId, id, ...} then fixCommitPol changes type/id)
            if let Some(eid) = r.exp_id {
                obj.insert("expId".to_string(), json!(eid));
            }
            obj.insert("id".to_string(), json!(r.id));
            obj.insert("prime".to_string(), json!(r.prime.unwrap_or(0)));
            obj.insert("dim".to_string(), json!(r.dim));
            if let Some(cid) = r.commit_id {
                obj.insert("commitId".to_string(), json!(cid));
            }
        }
        "number" => {
            // No id field for number refs
            if let Some(ref value) = r.value {
                obj.insert("value".to_string(), json!(value));
            }
            obj.insert("dim".to_string(), json!(r.dim));
        }
        "challenge" => {
            obj.insert("id".to_string(), json!(r.id));
            if let Some(sid) = r.stage_id {
                obj.insert("stageId".to_string(), json!(sid));
            }
            obj.insert("dim".to_string(), json!(r.dim));
            if let Some(stage) = r.stage {
                obj.insert("stage".to_string(), json!(stage));
            }
        }
        "eval" => {
            // eval refs may carry an expId from the original exp ref
            // (through fixCommitPol -> fixEval, expId survives)
            if let Some(eid) = r.exp_id {
                obj.insert("expId".to_string(), json!(eid));
            }
            obj.insert("id".to_string(), json!(r.id));
            obj.insert("dim".to_string(), json!(r.dim));
        }
        "public" => {
            obj.insert("id".to_string(), json!(r.id));
            obj.insert("dim".to_string(), json!(r.dim));
        }
        "proofvalue" => {
            obj.insert("id".to_string(), json!(r.id));
            if let Some(stage) = r.stage {
                obj.insert("stage".to_string(), json!(stage));
            }
            obj.insert("dim".to_string(), json!(r.dim));
        }
        "airgroupvalue" | "airvalue" => {
            obj.insert("id".to_string(), json!(r.id));
            if let Some(stage) = r.stage {
                obj.insert("stage".to_string(), json!(stage));
            }
            obj.insert("dim".to_string(), json!(r.dim));
            if let Some(agid) = r.airgroup_id {
                obj.insert("airgroupId".to_string(), json!(agid));
            }
        }
        "xDivXSubXi" => {
            obj.insert("id".to_string(), json!(r.id));
            if let Some(opening) = r.opening {
                obj.insert("opening".to_string(), json!(opening));
            }
            obj.insert("dim".to_string(), json!(r.dim));
        }
        "Zi" => {
            if let Some(bid) = r.boundary_id {
                obj.insert("boundaryId".to_string(), json!(bid));
            }
            obj.insert("dim".to_string(), json!(r.dim));
        }
        _ => {
            // Fallback: emit all present fields
            obj.insert("id".to_string(), json!(r.id));
            obj.insert("dim".to_string(), json!(r.dim));
            if let Some(prime) = r.prime {
                obj.insert("prime".to_string(), json!(prime));
            }
            if let Some(ref value) = r.value {
                obj.insert("value".to_string(), json!(value));
            }
            if let Some(stage) = r.stage {
                obj.insert("stage".to_string(), json!(stage));
            }
        }
    }
    serde_json::Value::Object(obj)
}

/// Write globalInfo.json and globalConstraints.json/bin files.
fn write_global_info(
    pilout: &pb::PilOut,
    pilout_name: &str,
    build_dir: &str,
) -> Result<()> {
    let proving_key_dir = Path::new(build_dir).join("provingKey");
    fs::create_dir_all(&proving_key_dir)?;

    // Build globalInfo (vadcopInfo in JS)
    let mut airs = Vec::new();
    let mut air_groups = Vec::new();
    let mut agg_types = Vec::new();

    for airgroup in &pilout.air_groups {
        let ag_name = airgroup
            .name
            .clone()
            .unwrap_or_else(|| "unnamed".to_string());
        air_groups.push(ag_name);

        let agv: Vec<serde_json::Value> = airgroup
            .air_group_values
            .iter()
            .map(|v| json!({"aggType": v.agg_type, "stage": v.stage}))
            .collect();
        agg_types.push(agv);

        let mut air_list = Vec::new();
        for air in &airgroup.airs {
            let a_name = air.name.clone().unwrap_or_else(|| "unnamed".to_string());
            air_list.push(json!({
                "name": a_name,
                "num_rows": air.num_rows.unwrap_or(0),
            }));
        }
        airs.push(serde_json::Value::Array(air_list));
    }

    let num_challenges: Vec<u32> = if pilout.num_challenges.is_empty() {
        vec![0]
    } else {
        pilout.num_challenges.clone()
    };

    let global_info = json!({
        "name": pilout_name,
        "airs": airs,
        "air_groups": air_groups,
        "aggTypes": agg_types,
        "curve": "None",
        "latticeSize": 368,
        "transcriptArity": 4,
        "nPublics": pilout.num_public_values,
        "numChallenges": num_challenges,
        "numProofValues": pilout.num_proof_values,
    });

    let global_info_str = json_output::to_json_string(&global_info)?;
    fs::write(
        proving_key_dir.join("pilout.globalInfo.json"),
        &global_info_str,
    )?;

    // Build globalConstraints JSON
    let global_constraints = json!({
        "constraints": [],
        "hints": [],
    });
    let gc_str = json_output::to_json_string(&global_constraints)?;
    fs::write(
        proving_key_dir.join("pilout.globalConstraints.json"),
        &gc_str,
    )?;

    tracing::info!("Global info and constraints written");
    Ok(())
}

/// Write binary files using native Rust implementation.
/// Reads the JSON files back and uses the bin_file module to generate .bin output.
fn write_bin_files_native(
    starkinfo_path: &Path,
    expressions_path: &Path,
    verifier_path: &Path,
    bin_output: &Path,
    verifier_bin_output: &Path,
) -> Result<()> {
    use crate::stark_info::{StarkInfo, ExpressionsInfo, VerifierInfo};

    let si_data = fs::read_to_string(starkinfo_path)?;
    let si_json: serde_json::Value = serde_json::from_str(&si_data)?;
    let stark_info = StarkInfo::from_json(&si_json)?;

    let expr_data = fs::read_to_string(expressions_path)?;
    let expr_json: serde_json::Value = serde_json::from_str(&expr_data)?;
    let expressions_info = ExpressionsInfo::from_json(&expr_json)?;

    crate::bin_file::write_expressions_bin_file(
        bin_output.to_str().unwrap_or(""),
        &stark_info,
        &expressions_info,
    )?;

    let ver_data = fs::read_to_string(verifier_path)?;
    let ver_json: serde_json::Value = serde_json::from_str(&ver_data)?;
    let verifier_info = VerifierInfo::from_json(&ver_json)?;

    crate::bin_file::write_verifier_expressions_bin_file(
        verifier_bin_output.to_str().unwrap_or(""),
        &stark_info,
        &verifier_info,
    )?;

    Ok(())
}

/// Compute floor(log2(n)) for a nonzero usize.
fn log2_usize(n: usize) -> usize {
    assert!(n > 0, "log2_usize: n must be positive");
    (usize::BITS - 1 - n.leading_zeros()) as usize
}

// C++ bctree subprocess removed. Using native Rust bctree::compute_const_tree().

