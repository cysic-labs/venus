//! Non-recursive setup command: the main orchestrator for the setup pipeline.
//!
//! Ports the non-recursive path of `pil2-proofman-js/src/cmd/setup_cmd.js`.

use std::fs;
use std::path::{Path, PathBuf};
use std::sync::Arc;

use anyhow::{Context, Result};
use rayon::prelude::*;

// IndexMap used in some helper functions below
#[allow(unused_imports)]
use indexmap::IndexMap;
use pilout::pilout::{self as pb, SymbolType};
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
    pub std_pil_path: Option<String>,
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


    // Collect all AIR work items for parallel processing
    struct AirWorkItem {
        ag_idx: usize,
        air_idx: usize,
        airgroup_name: String,
        air_name: String,
        num_rows: usize,
    }

    let mut work_items = Vec::new();
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

            work_items.push(AirWorkItem {
                ag_idx,
                air_idx,
                airgroup_name: airgroup_name.clone(),
                air_name,
                num_rows,
            });
        }
    }

    tracing::info!(
        "Processing {} AIRs in parallel using rayon",
        work_items.len()
    );

    // Share pilout and settings across threads
    let pilout = Arc::new(pilout);
    let settings_map = Arc::new(settings_map);
    let build_dir = opts.build_dir.clone();
    let fixed_dir = opts.fixed_dir.clone();
    let pilout_name_shared = pilout_name.clone();

    // Generate globalInfo.json and globalConstraints BEFORE per-AIR processing
    // so they are always written even if a slow AIR causes a timeout.
    write_global_info(&pilout, &pilout_name, &opts.build_dir, &settings_map)?;

    // Process AIRs sequentially to control peak memory.
    // par_iter with even 1 worker thread allows 2 concurrent closures
    // (main + worker), which together can hold ~80 GB of pil_info data.
    let results: Vec<Result<()>> = work_items
        .iter()
        .map(|item| {
            let n_bits = log2_usize(item.num_rows);

            tracing::info!("Computing setup for air '{}'", item.air_name);

            // Resolve settings for this air
            let air_settings = {
                let mut s = settings_map
                    .get(&item.air_name)
                    .or_else(|| settings_map.get("default"))
                    .cloned()
                    .unwrap_or_default();
                if s.pow_bits.is_none() {
                    s.pow_bits = Some(16);
                }
                s
            };

            let stark_struct = generate_stark_struct(&air_settings, n_bits);

            // Prepare output directory
            let files_dir = PathBuf::from(&build_dir)
                .join("provingKey")
                .join(&pilout_name_shared)
                .join(&item.airgroup_name)
                .join("airs")
                .join(&item.air_name)
                .join("air");
            fs::create_dir_all(&files_dir)?;

            // Copy fixed columns from --fixed-dir or skip
            let const_path = files_dir.join(format!("{}.const", item.air_name));
            if let Some(ref fd) = fixed_dir {
                let src = Path::new(fd).join(format!("{}.fixed", item.air_name));
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
                pil_info::pil_info(&pilout, item.ag_idx, item.air_idx, &stark_struct, &prepare_opts);

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

            let starkinfo_output = build_starkinfo_output(
                setup_result,
                &stark_struct,
                pil_code,
                &opening_points,
                &fri_security,
                item.ag_idx,
                item.air_idx,
                &item.air_name,
                pil_result.c_exp_id,
                pil_result.fri_exp_id,
                pil_result.q_deg,
            );

            // Write starkinfo.json
            let starkinfo_json = json_output::to_json_string(&starkinfo_output)?;
            let starkinfo_path = files_dir.join(format!("{}.starkinfo.json", item.air_name));
            fs::write(&starkinfo_path, &starkinfo_json)?;

            // Write expressionsinfo.json
            let expr_info_json = build_expressions_info_json(&pil_code.expressions_info);
            let expr_info_str = json_output::to_json_string(&expr_info_json)?;
            fs::write(
                files_dir.join(format!("{}.expressionsinfo.json", item.air_name)),
                &expr_info_str,
            )?;

            // Write verifierinfo.json
            let verifier_info_json = build_verifier_info_json(&pil_code.verifier_info);
            let verifier_info_str = json_output::to_json_string(&verifier_info_json)?;
            fs::write(
                files_dir.join(format!("{}.verifierinfo.json", item.air_name)),
                &verifier_info_str,
            )?;

            // Free all pil_info data before bctree - it's no longer needed.
            // write_bin_files_native reads from the JSON files on disk.
            // For Keccakf (2218 columns), this frees ~5 GB.
            drop(starkinfo_output);
            drop(starkinfo_json);
            drop(expr_info_str);
            drop(verifier_info_str);
            drop(pil_result);
            // Force the allocator to return freed pages to the OS.
            // Without this, glibc's sbrk heap retains freed memory
            // across 35 AIRs, accumulating to ~90 GB.
            #[cfg(target_os = "linux")]
            unsafe { libc::malloc_trim(0); }
            tracing::info!("[mem-trim] AIR '{}' freed", item.air_name);

            // Compute constant polynomial Merkle tree -> verkey.json / verkey.bin
            // Run in a child process to isolate bctree memory: large NTT
            // buffers and Merkle tree nodes are freed when the child exits,
            // preventing accumulation across 35 AIRs.
            let verkey_json_path = files_dir.join(format!("{}.verkey.json", item.air_name));
            if const_path.exists() {
                tracing::info!("Computing Constant Tree for '{}'...", item.air_name);
                let bctree_result = run_bctree_subprocess(
                    const_path.to_str().unwrap_or(""),
                    starkinfo_path.to_str().unwrap_or(""),
                    verkey_json_path.to_str().unwrap_or(""),
                );
                match bctree_result {
                    Ok(const_root) => {
                        let mut verkey_bin = Vec::with_capacity(32);
                        for &val in const_root.iter() {
                            verkey_bin.extend_from_slice(&val.to_le_bytes());
                        }
                        fs::write(
                            files_dir.join(format!("{}.verkey.bin", item.air_name)),
                            &verkey_bin,
                        )?;
                    }
                    Err(e) => {
                        tracing::warn!(
                            "bctree failed for air '{}': {:#}. \
                             Skipping verkey generation.",
                            item.air_name, e
                        );
                    }
                }
            } else {
                tracing::warn!(
                    "Skipping bctree: const file not found at {}",
                    const_path.display()
                );
            }

            // Write binary files
            write_bin_files_native(
                &starkinfo_path,
                &files_dir.join(format!("{}.expressionsinfo.json", item.air_name)),
                &files_dir.join(format!("{}.verifierinfo.json", item.air_name)),
                &files_dir.join(format!("{}.bin", item.air_name)),
                &files_dir.join(format!("{}.verifier.bin", item.air_name)),
            )?;

            {
                let rss = std::fs::read_to_string("/proc/self/status").ok()
                    .and_then(|s| s.lines().find(|l| l.starts_with("VmRSS:"))
                        .and_then(|l| l.split_whitespace().nth(1)?.parse::<u64>().ok()))
                    .unwrap_or(0);
                tracing::info!("Setup for air '{}' complete (VmRSS: {} MB)", item.air_name, rss / 1024);
            }
            Ok(())
        })
        .collect();

    // Check for any errors and propagate them
    for result in results {
        result?;
    }

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
    let std_pil_path = opts.std_pil_path.clone()
        .or_else(|| std::env::var("STD_PIL_PATH").ok())
        .unwrap_or_else(|| "pil".to_string());
    let recurser_pil_path = resolve_path_env("RECURSER_PIL_PATH", "circom2pil/pil");
    let circom_helpers_dir = resolve_path_env("CIRCOM_HELPERS_DIR", "circom");

    // Read globalInfo
    let proving_key_dir = Path::new(build_dir).join("provingKey");
    let global_info_path = proving_key_dir.join("pilout.globalInfo.json");
    let global_info: serde_json::Value = if global_info_path.exists() {
        serde_json::from_str(&fs::read_to_string(&global_info_path)?)?
    } else {
        anyhow::bail!("globalInfo.json not found at {:?}, cannot run recursive setup", global_info_path);
    };

    let global_constraints_path = proving_key_dir.join("pilout.globalConstraints.json");
    let global_constraints: serde_json::Value = if global_constraints_path.exists() {
        serde_json::from_str(&fs::read_to_string(&global_constraints_path)?)?
    } else {
        anyhow::bail!(
            "globalConstraints.json not found at {:?}, cannot run recursive setup",
            global_constraints_path
        );
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
                anyhow::bail!(
                    "Recursive setup failed for air '{}': starkinfo/verifierinfo not found at {:?}",
                    air_name, files_dir
                );
            }

            let stark_info: serde_json::Value =
                serde_json::from_str(&fs::read_to_string(&si_path)?)?;
            let verifier_info: serde_json::Value =
                serde_json::from_str(&fs::read_to_string(&vi_path)?)?;

            let const_root_strings = parse_verkey_json(&vk_path)
                .with_context(|| format!("Failed to load verkey for air '{}'", air_name))?;

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
                    return Err(e.context(format!(
                        "Compressor check failed for air '{}'", air_name
                    )));
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
                        return Err(e.context(format!(
                            "Compressor setup failed for air '{}'", air_name
                        )));
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
                    return Err(e.context(format!(
                        "Recursive1 setup failed for air '{}'", air_name
                    )));
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

        // Require recursive1 artifacts to exist (no fallback to non-recursive AIR)
        if !si_path.exists() || !vi_path.exists() {
            anyhow::bail!(
                "Recursive2 requires recursive1 artifacts for airgroup '{}' air '{}': {:?} and {:?} must exist",
                airgroup_name, air_name, si_path, vi_path
            );
        }
        let stark_info: serde_json::Value =
            serde_json::from_str(&fs::read_to_string(&si_path)?)?;
        let verifier_info: serde_json::Value =
            serde_json::from_str(&fs::read_to_string(&vi_path)?)?;

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
                return Err(e.context(format!(
                    "Recursive2 setup failed for airgroup '{}'", airgroup_name
                )));
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

    let final_result = final_setup::gen_final_setup(&final_config, &witness_tracker)
        .context("Final setup failed")?;
    tracing::info!("Final setup complete");

    // Run compressed final setup
    {
        let fr = &final_result;
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

        compressed_final::gen_compressed_final_setup(&compressed_config, &witness_tracker)
            .context("Compressed final setup failed")?;
        tracing::info!("Compressed final setup complete");
    }

    // Wait for all witness library builds
    witness_tracker.await_all()?;

    tracing::info!("Recursive setup complete");
    Ok(())
}

/// Resolve circom executable path.
/// Parse a verkey.json file and return exactly 4 u64 limb strings.
/// Returns Err if the file is missing, malformed, has fewer than 4 entries,
/// or contains non-numeric values.
fn parse_verkey_json(path: &Path) -> Result<[String; 4]> {
    if !path.exists() {
        anyhow::bail!("verkey.json not found: {:?}", path);
    }
    let content = fs::read_to_string(path)
        .with_context(|| format!("Failed to read verkey file: {:?}", path))?;
    let vk: Vec<serde_json::Value> = serde_json::from_str(&content)
        .with_context(|| format!("Failed to parse verkey JSON: {:?}", path))?;
    if vk.len() != 4 {
        anyhow::bail!(
            "verkey.json has {} entries, expected exactly 4: {:?}", vk.len(), path
        );
    }
    let mut limbs = [String::new(), String::new(), String::new(), String::new()];
    for i in 0..4 {
        limbs[i] = vk[i]
            .as_u64()
            .ok_or_else(|| anyhow::anyhow!(
                "verkey.json limb {} is not a valid u64: {:?} in {:?}",
                i, vk[i], path
            ))?
            .to_string();
    }
    Ok(limbs)
}

fn resolve_circom_exec() -> String {
    // Check env variable first
    if let Ok(path) = std::env::var("CIRCOM_EXEC") {
        if Path::new(&path).exists() {
            return path;
        }
    }
    let candidates = if cfg!(target_os = "macos") {
        vec!["circom_mac", "circom", "circom/circom_mac", "circom/circom"]
    } else {
        vec!["circom", "./circom", "circom/circom"]
    };
    for path in &candidates {
        let p = Path::new(path);
        if p.is_file() {
            // Return absolute path to avoid CWD-relative resolution issues
            if let Ok(abs) = p.canonicalize() {
                return abs.to_string_lossy().to_string();
            }
            return path.to_string();
        }
    }
    // Try which to find circom in PATH
    if let Ok(output) = std::process::Command::new("which").arg("circom").output() {
        if output.status.success() {
            let p = String::from_utf8_lossy(&output.stdout).trim().to_string();
            if !p.is_empty() {
                return p;
            }
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
    // Also collect offsets from kept (hint-referenced) and imPol expressions,
    // since generate_expressions_code produces code for them too.
    for expr in &setup.expressions {
        if expr.keep.unwrap_or(false) || expr.im_pol {
            for &offset in &expr.rows_offsets {
                if !points.contains(&offset) {
                    points.push(offset);
                }
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
        "public" => {
            // JS public: { op, id, stage } + pos (no dim)
            if let Some(id) = v.id {
                obj.insert("id".to_string(), json!(id));
            }
            if let Some(stage) = v.stage {
                obj.insert("stage".to_string(), json!(stage));
            }
            obj.insert("pos".to_string(), json!(v.pos));
        }
        _ => {
            // airvalue, proofvalue
            // JS airvalue/proofvalue: { op, id, stage, dim } + pos
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
    settings_map: &IndexMap<String, StarkSettings>,
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
            let has_compressor = settings_map
                .get(&a_name)
                .and_then(|s| s.has_compressor)
                .unwrap_or(false);
            let mut entry = json!({
                "name": a_name,
                "num_rows": air.num_rows.unwrap_or(0),
            });
            if has_compressor {
                entry.as_object_mut().unwrap().insert(
                    "hasCompressor".to_string(),
                    json!(true),
                );
            }
            air_list.push(entry);
        }
        airs.push(serde_json::Value::Array(air_list));
    }

    let num_challenges: Vec<u32> = if pilout.num_challenges.is_empty() {
        vec![0]
    } else {
        pilout.num_challenges.clone()
    };

    // Extract proofValuesMap from pilout symbols
    let proof_values_map = build_global_proof_values_map(&pilout.symbols);

    // Extract publicsMap from pilout symbols
    let publics_map = build_global_publics_map(&pilout.symbols);

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
        "proofValuesMap": proof_values_map,
        "publicsMap": publics_map,
    });

    let global_info_str = json_output::to_json_string(&global_info)?;
    fs::write(
        proving_key_dir.join("pilout.globalInfo.json"),
        &global_info_str,
    )?;

    // Build globalConstraints JSON from pilout data
    let global_constraints = build_global_constraints_json(pilout)?;
    let gc_str = json_output::to_json_string(&global_constraints)?;
    fs::write(
        proving_key_dir.join("pilout.globalConstraints.json"),
        &gc_str,
    )?;

    // Write globalConstraints.bin
    {
        use crate::global_constraints::write_global_constraints_bin_file;
        use crate::parser_args::{GlobalInfo as ParserGlobalInfo, ProofValueEntry};
        use crate::stark_info::GlobalConstraintsInfo;

        // Build GlobalInfo manually from the JSON
        let proof_values_map_json = global_info.get("proofValuesMap")
            .and_then(|v| v.as_array())
            .cloned()
            .unwrap_or_default();
        let pvm: Vec<ProofValueEntry> = proof_values_map_json.iter().map(|entry| {
            ProofValueEntry {
                stage: entry.get("stage").and_then(|s| s.as_u64()).unwrap_or(1),
            }
        }).collect();

        let agg_types_json = global_info.get("aggTypes")
            .and_then(|v| v.as_array())
            .cloned()
            .unwrap_or_default();
        let agg_types: Vec<Vec<u64>> = agg_types_json.iter().map(|ag| {
            ag.as_array().map(|arr| {
                arr.iter().map(|v| {
                    v.get("aggType").and_then(|a| a.as_u64()).unwrap_or(0)
                }).collect()
            }).unwrap_or_default()
        }).collect();

        let gi = ParserGlobalInfo {
            proof_values_map: pvm,
            agg_types,
        };

        let gci = GlobalConstraintsInfo::from_json(&global_constraints)?;
        let bin_path = proving_key_dir.join("pilout.globalConstraints.bin");
        write_global_constraints_bin_file(
            &gi,
            &gci,
            bin_path.to_str().unwrap_or(""),
        )?;
    }

    tracing::info!("Global info and constraints written");
    Ok(())
}

/// Build the `proofValuesMap` array from pilout symbols (sorted by id).
///
/// Each proof-value symbol produces one entry: `{"name": ..., "stage": ...}`.
/// Array symbols are expanded into one entry per element with the same name/stage.
fn build_global_proof_values_map(symbols: &[pb::Symbol]) -> Vec<serde_json::Value> {
    let mut entries: Vec<(u32, serde_json::Value)> = Vec::new();

    for s in symbols {
        if s.r#type != SymbolType::ProofValue as i32 {
            continue;
        }
        let stage = s.stage.unwrap_or(1);
        if s.dim == 0 {
            entries.push((s.id, json!({"name": s.name, "stage": stage})));
        } else {
            // Array proof value: expand each element
            let total: u32 = s.lengths.iter().product::<u32>().max(1);
            for offset in 0..total {
                entries.push((
                    s.id + offset,
                    json!({"name": s.name, "stage": stage}),
                ));
            }
        }
    }

    entries.sort_by_key(|(id, _)| *id);
    entries.into_iter().map(|(_, v)| v).collect()
}

/// Build the `publicsMap` array from pilout symbols (sorted by id).
///
/// Each scalar public produces `{"name": ..., "stage": 1}`.
/// Array publics are expanded and include `{"name": ..., "stage": 1, "lengths": [i, j, ...]}`.
fn build_global_publics_map(symbols: &[pb::Symbol]) -> Vec<serde_json::Value> {
    let mut entries: Vec<(u32, serde_json::Value)> = Vec::new();

    for s in symbols {
        if s.r#type != SymbolType::PublicValue as i32 {
            continue;
        }
        if s.dim == 0 || s.lengths.is_empty() {
            entries.push((s.id, json!({"name": s.name, "stage": 1})));
        } else {
            expand_public_array_entries(&mut entries, s, &[], 0);
        }
    }

    entries.sort_by_key(|(id, _)| *id);
    entries.into_iter().map(|(_, v)| v).collect()
}

/// Recursively expand a multi-dimensional public array symbol into individual entries.
fn expand_public_array_entries(
    entries: &mut Vec<(u32, serde_json::Value)>,
    sym: &pb::Symbol,
    indexes: &[u32],
    shift: u32,
) -> u32 {
    if indexes.len() == sym.lengths.len() {
        let idx_vec: Vec<serde_json::Value> =
            indexes.iter().map(|&i| serde_json::Value::from(i)).collect();
        entries.push((
            sym.id + shift,
            json!({"name": sym.name, "stage": 1, "lengths": idx_vec}),
        ));
        return shift + 1;
    }

    let len = sym.lengths[indexes.len()];
    let mut current_shift = shift;
    for i in 0..len {
        let mut new_indexes = indexes.to_vec();
        new_indexes.push(i);
        current_shift =
            expand_public_array_entries(entries, sym, &new_indexes, current_shift);
    }
    current_shift
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

/// Run bctree in a child process to isolate memory.
///
/// Uses fork+exec pattern: the child process computes the Merkle tree
/// and writes verkey.json, then exits. All NTT/Merkle memory is freed
/// by the OS when the child exits, preventing accumulation across AIRs.
fn run_bctree_subprocess(
    const_path: &str,
    starkinfo_path: &str,
    verkey_path: &str,
) -> Result<[u64; 4]> {
    // Find the venus-bctree binary next to the current executable.
    // Fails loudly if not found - never silently falls back to in-process.
    let bctree_exec = std::env::current_exe()
        .ok()
        .and_then(|exe| exe.parent().map(|d| d.join("venus-bctree")))
        .filter(|p| p.is_file())
        .ok_or_else(|| anyhow::anyhow!(
            "venus-bctree binary not found next to venus-setup. \
             Build it with: cargo build --release --bin venus-bctree"
        ))?;

    let output = std::process::Command::new(&bctree_exec)
        .args([const_path, starkinfo_path, verkey_path])
        .output()
        .with_context(|| format!("Failed to run venus-bctree: {}", bctree_exec.display()))?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        anyhow::bail!("venus-bctree failed: {}", stderr);
    }

    // Parse verkey from the written file
    let verkey_json = fs::read_to_string(verkey_path)?;
    let vk: Vec<serde_json::Value> = serde_json::from_str(&verkey_json)?;
    if vk.len() != 4 {
        anyhow::bail!("verkey.json expected 4 elements, got {}", vk.len());
    }
    let mut root = [0u64; 4];
    for i in 0..4 {
        root[i] = vk[i].as_u64()
            .ok_or_else(|| anyhow::anyhow!("verkey limb {} is not u64", i))?;
    }
    Ok(root)
}

/// Compute floor(log2(n)) for a nonzero usize.
fn log2_usize(n: usize) -> usize {
    assert!(n > 0, "log2_usize: n must be positive");
    (usize::BITS - 1 - n.leading_zeros()) as usize
}

// C++ bctree subprocess removed. Using native Rust bctree::compute_const_tree().

/// Build the globalConstraints JSON from pilout data.
///
/// Mirrors JS `getGlobalConstraintsInfo` from
/// `pil2-proofman-js/src/pil2-stark/pil_info/getGlobalConstraintsInfo.js`.
///
/// Processes pilout-level GlobalExpressions and GlobalConstraints through
/// the code generation pipeline to produce constraint code and hint data.
fn build_global_constraints_json(pilout: &pb::PilOut) -> Result<serde_json::Value> {
    use crate::codegen::{build_code, pil_code_gen, CodeGenCtx};
    use crate::helpers::add_info_expressions;
    use crate::pilout_info::{
        format_global_constraints, format_global_expressions, format_global_hints,
        format_global_symbols, SymbolInfo, FIELD_EXTENSION,
    };
    use crate::generate_pil_code::CodeGenParams;
    use crate::print_expression::{self, PrintCtx};

    // If no global constraints exist, return empty
    if pilout.constraints.is_empty() && pilout.hints.iter().all(|h| h.air_group_id.is_some() || h.air_id.is_some()) {
        return Ok(json!({"constraints": [], "hints": []}));
    }

    // Format global expressions
    let mut expressions = format_global_expressions(
        &pilout.expressions,
        &pilout.num_challenges,
        &pilout.air_groups,
    );

    // Format global constraints
    let constraints = format_global_constraints(&pilout.constraints);

    // Format global symbols for print context
    let symbols = format_global_symbols(
        &pilout.symbols,
        &pilout.num_challenges,
    );

    // Run add_info_expressions on all constraint expression indices
    for constraint in &constraints {
        add_info_expressions(&mut expressions, constraint.e);
    }

    // Build print context for generating line strings
    let publics_map: Vec<SymbolInfo> = symbols.iter()
        .filter(|s| s.sym_type == "public")
        .cloned()
        .collect();
    let challenges_map: Vec<SymbolInfo> = symbols.iter()
        .filter(|s| s.sym_type == "challenge")
        .cloned()
        .collect();
    let airgroup_values_map: Vec<SymbolInfo> = symbols.iter()
        .filter(|s| s.sym_type == "airgroupvalue")
        .cloned()
        .collect();
    let proof_values_map: Vec<SymbolInfo> = symbols.iter()
        .filter(|s| s.sym_type == "proofvalue")
        .cloned()
        .collect();

    // Build sorted maps indexed by ID for PrintCtx
    let max_public_id = publics_map.iter().filter_map(|s| s.id).max().unwrap_or(0);
    let mut publics_by_id = vec![SymbolInfo {
        name: String::new(), sym_type: "public".to_string(),
        stage: Some(1), dim: 1, id: None, pol_id: None, stage_id: None,
        air_id: None, airgroup_id: None, commit_id: None, lengths: None,
        idx: None, stage_pos: None, im_pol: false, exp_id: None,
    }; max_public_id + 1];
    for s in &publics_map {
        if let Some(id) = s.id {
            if id < publics_by_id.len() {
                publics_by_id[id] = s.clone();
            }
        }
    }

    let max_challenge_id = challenges_map.iter().filter_map(|s| s.id).max().unwrap_or(0);
    let mut challenges_by_id = vec![SymbolInfo {
        name: String::new(), sym_type: "challenge".to_string(),
        stage: Some(1), dim: FIELD_EXTENSION, id: None, pol_id: None, stage_id: None,
        air_id: None, airgroup_id: None, commit_id: None, lengths: None,
        idx: None, stage_pos: None, im_pol: false, exp_id: None,
    }; max_challenge_id + 1];
    for s in &challenges_map {
        if let Some(id) = s.id {
            if id < challenges_by_id.len() {
                challenges_by_id[id] = s.clone();
            }
        }
    }

    let max_agv_id = airgroup_values_map.iter().filter_map(|s| s.id).max().unwrap_or(0);
    let mut agv_by_id = vec![SymbolInfo {
        name: String::new(), sym_type: "airgroupvalue".to_string(),
        stage: None, dim: FIELD_EXTENSION, id: None, pol_id: None, stage_id: None,
        air_id: None, airgroup_id: None, commit_id: None, lengths: None,
        idx: None, stage_pos: None, im_pol: false, exp_id: None,
    }; max_agv_id + 1];
    for s in &airgroup_values_map {
        if let Some(id) = s.id {
            if id < agv_by_id.len() {
                agv_by_id[id] = s.clone();
            }
        }
    }

    let max_pv_id = proof_values_map.iter().filter_map(|s| s.id).max().unwrap_or(0);
    let mut pv_by_id = vec![SymbolInfo {
        name: String::new(), sym_type: "proofvalue".to_string(),
        stage: Some(1), dim: 1, id: None, pol_id: None, stage_id: None,
        air_id: None, airgroup_id: None, commit_id: None, lengths: None,
        idx: None, stage_pos: None, im_pol: false, exp_id: None,
    }; max_pv_id + 1];
    for s in &proof_values_map {
        if let Some(id) = s.id {
            if id < pv_by_id.len() {
                pv_by_id[id] = s.clone();
            }
        }
    }

    let empty_sym_vec: Vec<SymbolInfo> = Vec::new();
    let empty_custom_commits: Vec<Vec<SymbolInfo>> = Vec::new();
    let print_ctx = PrintCtx {
        cm_pols_map: &empty_sym_vec,
        const_pols_map: &empty_sym_vec,
        custom_commits_map: &empty_custom_commits,
        publics_map: &publics_by_id,
        challenges_map: &challenges_by_id,
        air_values_map: &empty_sym_vec,
        airgroup_values_map: &agv_by_id,
        proof_values_map: &pv_by_id,
    };

    // Generate constraint code blocks
    // Use a shared CodeGenCtx (accumulating tmpUsed across constraints)
    let n_stages = if !pilout.num_challenges.is_empty() {
        pilout.num_challenges.len()
    } else {
        1
    };

    let mut ctx = CodeGenCtx::new(
        0, 0, n_stages, "n", false, Vec::new(), Vec::new(),
    );

    let mut constraints_json = Vec::new();

    for constraint in &constraints {
        pil_code_gen(&mut ctx, &symbols, &expressions, constraint.e, 0);
        let block = build_code(&mut ctx);

        // Accumulate tmpUsed across constraints (matching JS behavior)
        ctx.tmp_used = block.tmp_used;

        // Generate the line string for this constraint
        let line = if let Some(ref debug_line) = constraint.line {
            // Print the expression to get a readable constraint string
            let expr_str = print_expression::print_expression_no_cache(
                &print_ctx,
                &mut expressions,
                constraint.e,
                true,
            );
            format!("{} ({})", debug_line, expr_str)
        } else {
            String::new()
        };

        let mut obj = serde_json::Map::new();
        obj.insert("tmpUsed".to_string(), json!(block.tmp_used));
        obj.insert("code".to_string(), code_entries_to_json(&block.code));
        obj.insert("boundary".to_string(), json!(constraint.boundary));
        obj.insert("line".to_string(), json!(line));
        constraints_json.push(serde_json::Value::Object(obj));
    }

    // Format and process global hints
    let hints = format_global_hints(pilout, &mut expressions);

    // Process hints through the hint processing pipeline
    let global_params = CodeGenParams {
        air_id: 0,
        airgroup_id: 0,
        n_stages,
        c_exp_id: 0,
        fri_exp_id: 0,
        q_deg: 0,
        q_dim: FIELD_EXTENSION,
        opening_points: Vec::new(),
        cm_pols_map: Vec::new(),
        custom_commits_count: 0,
    };

    let processed_hints = process_global_hints(
        &global_params,
        &mut expressions,
        &hints,
        Some(&print_ctx),
    );

    // Serialize hints to JSON
    let hints_json: Vec<serde_json::Value> = processed_hints.iter().map(|h| {
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
    }).collect();

    Ok(json!({
        "constraints": constraints_json,
        "hints": hints_json,
    }))
}

/// Process global hints into flat hint field values.
///
/// Similar to `add_hints_info` in generate_pil_code.rs but adapted for global mode.
fn process_global_hints(
    params: &crate::generate_pil_code::CodeGenParams,
    expressions: &mut Vec<crate::expression::Expression>,
    hints: &[crate::pilout_info::HintInfo],
    print_ctx: Option<&crate::print_expression::PrintCtx>,
) -> Vec<crate::generate_pil_code::ProcessedHint> {
    use crate::generate_pil_code::{ProcessedHint, ProcessedHintFieldEntry};

    let mut result = Vec::new();

    for hint in hints {
        let mut processed_fields = Vec::new();

        for field in &hint.fields {
            let flat_values = process_global_hint_values(
                &field.values,
                params,
                expressions,
                &[],
                print_ctx,
            );

            let mut entry = ProcessedHintFieldEntry {
                name: field.name.clone(),
                values: flat_values,
            };

            // If no lengths, set first value's pos to empty
            if field.lengths.is_none() {
                if let Some(first) = entry.values.first_mut() {
                    first.pos = Vec::new();
                }
            }

            processed_fields.push(entry);
        }

        result.push(ProcessedHint {
            name: hint.name.clone(),
            fields: processed_fields,
        });
    }

    result
}

/// Recursively flatten global hint field values.
fn process_global_hint_values(
    values: &[crate::pilout_info::HintFieldValue],
    params: &crate::generate_pil_code::CodeGenParams,
    expressions: &mut Vec<crate::expression::Expression>,
    pos: &[usize],
    print_ctx: Option<&crate::print_expression::PrintCtx>,
) -> Vec<crate::generate_pil_code::ProcessedHintField> {
    use crate::pilout_info::HintFieldValue;

    let mut result = Vec::new();

    for (j, field) in values.iter().enumerate() {
        let mut current_pos: Vec<usize> = pos.to_vec();
        current_pos.push(j);

        match field {
            HintFieldValue::Array(arr) => {
                let inner = process_global_hint_values(arr, params, expressions, &current_pos, print_ctx);
                result.extend(inner);
            }
            HintFieldValue::Single(expr) => {
                let processed = process_global_single_hint_field(expr, params, expressions, &current_pos, print_ctx);
                result.push(processed);
            }
        }
    }

    result
}

/// Process a single global hint field value.
fn process_global_single_hint_field(
    expr: &crate::expression::Expression,
    _params: &crate::generate_pil_code::CodeGenParams,
    expressions: &mut Vec<crate::expression::Expression>,
    pos: &[usize],
    print_ctx: Option<&crate::print_expression::PrintCtx>,
) -> crate::generate_pil_code::ProcessedHintField {
    use crate::generate_pil_code::ProcessedHintField;

    match expr.op.as_str() {
        "exp" => {
            let ref_id = expr.id.unwrap_or(0);
            let dim = expressions.get(ref_id).map_or(expr.dim.max(1), |e| e.dim);

            if let Some(ctx) = print_ctx {
                if ref_id < expressions.len() {
                    crate::print_expression::print_expression(ctx, expressions, ref_id, false);
                }
            }

            ProcessedHintField {
                op: "tmp".to_string(),
                id: Some(ref_id),
                dim: Some(dim),
                pos: pos.to_vec(),
                stage: None,
                stage_id: None,
                value: None,
                row_offset: None,
                row_offset_index: None,
                commit_id: None,
                airgroup_id: None,
            }
        }
        "challenge" | "public" | "airgroupvalue" | "airvalue" | "number" | "string"
        | "proofvalue" => ProcessedHintField {
            op: expr.op.clone(),
            id: expr.id,
            dim: Some(expr.dim),
            pos: pos.to_vec(),
            stage: Some(expr.stage),
            stage_id: expr.stage_id,
            value: expr.value.clone(),
            row_offset: None,
            row_offset_index: None,
            commit_id: None,
            airgroup_id: expr.airgroup_id,
        },
        _ => {
            // For any other type in global context, treat as generic
            ProcessedHintField {
                op: expr.op.clone(),
                id: expr.id,
                dim: Some(expr.dim),
                pos: pos.to_vec(),
                stage: Some(expr.stage),
                stage_id: expr.stage_id,
                value: expr.value.clone(),
                row_offset: None,
                row_offset_index: None,
                commit_id: None,
                airgroup_id: expr.airgroup_id,
            }
        }
    }
}

#[cfg(test)]
mod tests_global_info {
    use super::*;

    /// Test that hasCompressor is correctly read from StarkSettings.
    #[test]
    fn test_has_compressor_parsing() {
        let json_str = r#"{
            "Keccakf": { "powBits": 23, "lastLevelVerification": 1, "hasCompressor": true },
            "Sha256f": { "hasCompressor": true },
            "SomeAir": { "blowupFactor": 2 }
        }"#;
        let settings: IndexMap<String, StarkSettings> = serde_json::from_str(json_str).unwrap();
        assert_eq!(settings["Keccakf"].has_compressor, Some(true));
        assert_eq!(settings["Sha256f"].has_compressor, Some(true));
        assert_eq!(settings["SomeAir"].has_compressor, None);
    }

    /// Test global info generation with hasCompressor from pilout file.
    #[test]
    fn test_global_info_has_compressor() {
        let pilout_path = concat!(env!("CARGO_MANIFEST_DIR"), "/../pil/zisk.pilout");
        if !std::path::Path::new(pilout_path).exists() {
            eprintln!("Skipping test_global_info_has_compressor: pilout not found");
            return;
        }

        let pilout_data = std::fs::read(pilout_path).unwrap();
        let pilout = pb::PilOut::decode(pilout_data.as_slice()).unwrap();
        let pilout_name = pilout.name.clone().unwrap_or_else(|| "pilout".to_string());

        let settings_path = concat!(env!("CARGO_MANIFEST_DIR"), "/../state-machines/starkstructs.json");
        let settings_map: IndexMap<String, StarkSettings> = if std::path::Path::new(settings_path).exists() {
            let data = std::fs::read_to_string(settings_path).unwrap();
            serde_json::from_str(&data).unwrap()
        } else {
            IndexMap::new()
        };

        let build_dir = "/tmp/r39_test_global_info";
        let _ = std::fs::remove_dir_all(build_dir);

        write_global_info(&pilout, &pilout_name, build_dir, &settings_map).unwrap();

        // Check globalInfo.json
        let gi_path = format!("{}/provingKey/pilout.globalInfo.json", build_dir);
        let gi_str = std::fs::read_to_string(&gi_path).unwrap();
        let gi: serde_json::Value = serde_json::from_str(&gi_str).unwrap();

        // Check that hasCompressor is set for known AIRs
        let airs = gi.get("airs").unwrap().as_array().unwrap();
        assert!(!airs.is_empty(), "airs should not be empty");

        let first_group = airs[0].as_array().unwrap();
        let mut found_has_compressor = false;
        for air in first_group {
            let name = air.get("name").unwrap().as_str().unwrap();
            if name == "Keccakf" || name == "Sha256f" || name == "ArithEq" || name == "ArithEq384" {
                assert!(
                    air.get("hasCompressor").is_some(),
                    "AIR '{}' should have hasCompressor", name
                );
                assert_eq!(
                    air.get("hasCompressor").unwrap().as_bool().unwrap(),
                    true,
                    "AIR '{}' hasCompressor should be true", name
                );
                found_has_compressor = true;
            }
            // AIRs without hasCompressor should not have the field
            if name == "Main" || name == "Mem" {
                assert!(
                    air.get("hasCompressor").is_none(),
                    "AIR '{}' should NOT have hasCompressor", name
                );
            }
        }
        assert!(found_has_compressor, "Should have found AIRs with hasCompressor");

        // Check globalConstraints.json exists and has data
        let gc_path = format!("{}/provingKey/pilout.globalConstraints.json", build_dir);
        let gc_str = std::fs::read_to_string(&gc_path).unwrap();
        let gc: serde_json::Value = serde_json::from_str(&gc_str).unwrap();
        let constraints = gc.get("constraints").unwrap().as_array().unwrap();
        assert!(!constraints.is_empty(), "constraints should not be empty");

        // Check constraint structure
        let c0 = &constraints[0];
        assert!(c0.get("tmpUsed").is_some(), "constraint should have tmpUsed");
        assert!(c0.get("code").is_some(), "constraint should have code");
        assert_eq!(c0.get("boundary").unwrap().as_str().unwrap(), "finalProof");
        assert!(c0.get("line").is_some(), "constraint should have line");

        let hints = gc.get("hints").unwrap().as_array().unwrap();
        assert!(!hints.is_empty(), "hints should not be empty");

        // Check globalConstraints.bin exists
        let bin_path = format!("{}/provingKey/pilout.globalConstraints.bin", build_dir);
        assert!(std::path::Path::new(&bin_path).exists(), "globalConstraints.bin should exist");

        // Cleanup
        let _ = std::fs::remove_dir_all(build_dir);
    }

    /// Byte-identical regression test: generate setup metadata and compare
    /// against checked-in golden reference files.
    #[test]
    fn test_golden_fixture_byte_identical() {
        let pilout_path = concat!(env!("CARGO_MANIFEST_DIR"), "/../pil/zisk.pilout");
        if !std::path::Path::new(pilout_path).exists() {
            eprintln!("Skipping test_golden_fixture_byte_identical: pilout not found");
            return;
        }

        let golden_dir = concat!(env!("CARGO_MANIFEST_DIR"), "/../golden_reference");
        if !std::path::Path::new(golden_dir).exists() {
            eprintln!("Skipping test_golden_fixture_byte_identical: golden_reference/ not found");
            return;
        }

        let pilout_data = std::fs::read(pilout_path).unwrap();
        let pilout = pb::PilOut::decode(pilout_data.as_slice()).unwrap();
        let pilout_name = pilout.name.clone().unwrap_or_else(|| "pilout".to_string());

        let settings_path = concat!(env!("CARGO_MANIFEST_DIR"), "/../state-machines/starkstructs.json");
        let settings_map: IndexMap<String, StarkSettings> = if std::path::Path::new(settings_path).exists() {
            let data = std::fs::read_to_string(settings_path).unwrap();
            serde_json::from_str(&data).unwrap()
        } else {
            IndexMap::new()
        };

        let build_dir = "/tmp/r40_golden_fixture_test";
        let _ = std::fs::remove_dir_all(build_dir);

        write_global_info(&pilout, &pilout_name, build_dir, &settings_map).unwrap();

        let files_to_check = [
            "pilout.globalInfo.json",
            "pilout.globalConstraints.json",
            "pilout.globalConstraints.bin",
        ];

        for filename in &files_to_check {
            let generated_path = format!("{}/provingKey/{}", build_dir, filename);
            let golden_path = format!("{}/{}", golden_dir, filename);

            let generated_bytes = std::fs::read(&generated_path)
                .unwrap_or_else(|e| panic!("Failed to read generated {}: {}", filename, e));
            let golden_bytes = std::fs::read(&golden_path)
                .unwrap_or_else(|e| panic!("Failed to read golden {}: {}", filename, e));

            assert_eq!(
                generated_bytes, golden_bytes,
                "{} differs from golden reference ({} generated bytes vs {} golden bytes)",
                filename,
                generated_bytes.len(),
                golden_bytes.len()
            );
        }

        // Cleanup
        let _ = std::fs::remove_dir_all(build_dir);
    }

    /// Test that the binary writer produces byte-identical .bin and .verifier.bin
    /// output from golden JSON inputs.
    #[test]
    fn test_bin_file_byte_identical_to_golden() {
        let base = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("..");
        let golden_dir = base.join("golden_reference/zisk/Zisk/airs/Dma/air");
        let si_path = golden_dir.join("Dma.starkinfo.json");
        let ei_path = golden_dir.join("Dma.expressionsinfo.json");
        let vi_path = golden_dir.join("Dma.verifierinfo.json");
        let golden_bin = golden_dir.join("Dma.bin");
        let golden_vbin = golden_dir.join("Dma.verifier.bin");

        if !si_path.exists() || !golden_bin.exists() {
            eprintln!("Skipping test: golden Dma files not found");
            return;
        }

        let tmp_dir = std::env::temp_dir().join(format!("pil2_bin_regression_{}", std::process::id()));
        let _ = std::fs::create_dir_all(&tmp_dir);
        let out_bin = tmp_dir.join("Dma.bin");
        let out_vbin = tmp_dir.join("Dma.verifier.bin");

        write_bin_files_native(
            &si_path, &ei_path, &vi_path, &out_bin, &out_vbin,
        ).expect("write_bin_files_native failed");

        let golden_data = std::fs::read(&golden_bin).unwrap();
        let actual_data = std::fs::read(&out_bin).unwrap();
        assert_eq!(
            golden_data.len(), actual_data.len(),
            "Dma.bin size mismatch: golden={} actual={}",
            golden_data.len(), actual_data.len()
        );
        assert_eq!(
            golden_data, actual_data,
            "Dma.bin content mismatch (first diff at byte {})",
            golden_data.iter().zip(actual_data.iter())
                .position(|(a, b)| a != b).unwrap_or(0)
        );

        let golden_vdata = std::fs::read(&golden_vbin).unwrap();
        let actual_vdata = std::fs::read(&out_vbin).unwrap();
        assert_eq!(
            golden_vdata, actual_vdata,
            "Dma.verifier.bin content mismatch"
        );

        let _ = std::fs::remove_dir_all(&tmp_dir);
    }

    /// Test Binary .bin byte-identity (has negative primes and large Goldilocks values).
    #[test]
    fn test_binary_bin_byte_identical_to_golden() {
        let base = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("..");
        let golden_dir = base.join("golden_reference/zisk/Zisk/airs/Binary/air");
        let si_path = golden_dir.join("Binary.starkinfo.json");
        let ei_path = golden_dir.join("Binary.expressionsinfo.json");
        let vi_path = golden_dir.join("Binary.verifierinfo.json");
        let golden_bin = golden_dir.join("Binary.bin");
        let golden_vbin = golden_dir.join("Binary.verifier.bin");

        if !si_path.exists() || !golden_bin.exists() {
            eprintln!("Skipping: golden Binary files not found");
            return;
        }

        let tmp_dir = std::env::temp_dir().join(format!("pil2_binary_bin_regression_{}", std::process::id()));
        let _ = std::fs::create_dir_all(&tmp_dir);
        let out_bin = tmp_dir.join("Binary.bin");
        let out_vbin = tmp_dir.join("Binary.verifier.bin");

        write_bin_files_native(&si_path, &ei_path, &vi_path, &out_bin, &out_vbin)
            .expect("write_bin_files_native failed for Binary");

        let golden_data = std::fs::read(&golden_bin).unwrap();
        let actual_data = std::fs::read(&out_bin).unwrap();
        assert_eq!(golden_data.len(), actual_data.len(),
            "Binary.bin size mismatch: golden={} actual={}", golden_data.len(), actual_data.len());
        if golden_data != actual_data {
            let diff_pos = golden_data.iter().zip(actual_data.iter())
                .position(|(a, b)| a != b).unwrap_or(0);
            panic!("Binary.bin content mismatch at byte {} (golden=0x{:02x} actual=0x{:02x})",
                diff_pos, golden_data[diff_pos], actual_data[diff_pos]);
        }

        let golden_vdata = std::fs::read(&golden_vbin).unwrap();
        let actual_vdata = std::fs::read(&out_vbin).unwrap();
        assert_eq!(golden_vdata, actual_vdata, "Binary.verifier.bin content mismatch");

        let _ = std::fs::remove_dir_all(&tmp_dir);
    }

    /// Test Arith .bin byte-identity (exercises Goldilocks number encoding).
    #[test]
    fn test_arith_bin_byte_identical_to_golden() {
        let base = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("..");
        let golden_dir = base.join("golden_reference/zisk/Zisk/airs/Arith/air");
        let si = golden_dir.join("Arith.starkinfo.json");
        let ei = golden_dir.join("Arith.expressionsinfo.json");
        let vi = golden_dir.join("Arith.verifierinfo.json");
        let golden_bin = golden_dir.join("Arith.bin");
        let golden_vbin = golden_dir.join("Arith.verifier.bin");

        if !si.exists() || !golden_bin.exists() {
            eprintln!("Skipping: golden Arith files not found");
            return;
        }

        let tmp_dir = std::env::temp_dir().join(format!("pil2_arith_bin_{}", std::process::id()));
        let _ = std::fs::create_dir_all(&tmp_dir);
        let out_bin = tmp_dir.join("Arith.bin");
        let out_vbin = tmp_dir.join("Arith.verifier.bin");

        write_bin_files_native(&si, &ei, &vi, &out_bin, &out_vbin)
            .expect("write_bin_files_native failed for Arith");

        let golden_data = std::fs::read(&golden_bin).unwrap();
        let actual_data = std::fs::read(&out_bin).unwrap();
        assert_eq!(golden_data, actual_data, "Arith.bin content mismatch at byte {}",
            golden_data.iter().zip(actual_data.iter()).position(|(a, b)| a != b).unwrap_or(0));

        let golden_vdata = std::fs::read(&golden_vbin).unwrap();
        let actual_vdata = std::fs::read(&out_vbin).unwrap();
        assert_eq!(golden_vdata, actual_vdata, "Arith.verifier.bin content mismatch");

        let _ = std::fs::remove_dir_all(&tmp_dir);
    }

    /// Test the run_setup contract: global files are written before per-AIR work.
    ///
    /// Verifies that run_setup with a zero-row PilOut writes all three
    /// global files and returns Ok.
    #[test]
    fn test_run_setup_writes_global_files_before_airs() {
        use pilout::pilout as pb;
        use prost::Message;

        let pilout_proto = pb::PilOut {
            name: Some("globaltest".to_string()),
            air_groups: vec![pb::AirGroup {
                name: Some("TestGroup".to_string()),
                airs: vec![pb::Air {
                    name: Some("TestAir".to_string()),
                    num_rows: Some(0), // zero rows: AIR loop is no-op
                    ..Default::default()
                }],
                ..Default::default()
            }],
            ..Default::default()
        };

        let tmp_dir = std::env::temp_dir().join(format!("pil2_run_setup_global_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&tmp_dir);
        let build_dir = tmp_dir.join("build");
        std::fs::create_dir_all(&build_dir).unwrap();

        let pilout_path = tmp_dir.join("test.pilout");
        let mut buf = Vec::new();
        pilout_proto.encode(&mut buf).unwrap();
        std::fs::write(&pilout_path, &buf).unwrap();

        let opts = SetupOptions {
            airout_path: pilout_path.to_str().unwrap().to_string(),
            build_dir: build_dir.to_str().unwrap().to_string(),
            fixed_dir: None,
            stark_structs_path: None,
            recursive: false,
            std_pil_path: None,
        };

        let result = run_setup(&opts);
        assert!(result.is_ok(), "run_setup should succeed: {:#}", result.unwrap_err());

        // Global files must exist
        let pk_dir = build_dir.join("provingKey");
        assert!(pk_dir.join("pilout.globalInfo.json").exists(),
            "globalInfo.json must exist after run_setup");
        assert!(pk_dir.join("pilout.globalConstraints.json").exists(),
            "globalConstraints.json must exist after run_setup");
        assert!(pk_dir.join("pilout.globalConstraints.bin").exists(),
            "globalConstraints.bin must exist after run_setup");

        let _ = std::fs::remove_dir_all(&tmp_dir);
    }

    /// Test that run_recursive_setup fails when globalConstraints.json is missing.
    #[test]
    fn test_recursive_fails_on_missing_global_constraints() {
        let base = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("..");
        let pilout_path = base.join("pil/zisk.pilout");
        if !pilout_path.exists() {
            eprintln!("Skipping test: zisk.pilout not found");
            return;
        }

        let tmp_dir = std::env::temp_dir().join(format!("pil2_recursive_failfast_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&tmp_dir);
        let build_dir = tmp_dir.join("build");
        let pk_dir = build_dir.join("provingKey");
        std::fs::create_dir_all(&pk_dir).unwrap();

        // Write globalInfo but NOT globalConstraints
        std::fs::write(
            pk_dir.join("pilout.globalInfo.json"),
            r#"{"name":"zisk","nPublics":68}"#,
        ).unwrap();

        // Call run_recursive_setup directly (avoids expensive AIR processing)
        let pilout_data = std::fs::read(&pilout_path).unwrap();
        let pilout = pilout::pilout::PilOut::decode(pilout_data.as_slice()).unwrap();
        let opts = SetupOptions {
            airout_path: pilout_path.to_str().unwrap().to_string(),
            build_dir: build_dir.to_str().unwrap().to_string(),
            fixed_dir: None,
            stark_structs_path: None,
            recursive: true,
            std_pil_path: None,
        };

        let result = run_recursive_setup(&pilout, "zisk", &opts);
        assert!(
            result.is_err(),
            "recursive setup should fail when globalConstraints.json is missing"
        );
        let err_msg = format!("{:#}", result.unwrap_err());
        assert!(
            err_msg.contains("globalConstraints.json not found"),
            "error should mention missing globalConstraints: {}",
            err_msg
        );

        let _ = std::fs::remove_dir_all(&tmp_dir);
    }

    /// Test that recursive setup fails when base AIR verkey.json is missing.
    #[test]
    fn test_recursive_fails_on_missing_verkey() {
        let base = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("..");
        let pilout_path = base.join("pil/zisk.pilout");
        if !pilout_path.exists() {
            eprintln!("Skipping test: zisk.pilout not found");
            return;
        }

        let tmp_dir = std::env::temp_dir().join(format!("pil2_verkey_failfast_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&tmp_dir);
        let build_dir = tmp_dir.join("build");
        let pk_dir = build_dir.join("provingKey").join("zisk").join("Zisk").join("airs").join("Dma").join("air");
        std::fs::create_dir_all(&pk_dir).unwrap();

        // Write globalInfo and globalConstraints
        let ginfo_dir = build_dir.join("provingKey");
        std::fs::write(ginfo_dir.join("pilout.globalInfo.json"),
            r#"{"name":"zisk","nPublics":68,"numProofValues":[8],"proofValuesMap":[],"publicsMap":[],"airGroupsInfo":[{"airGroupId":0,"nAirs":35}],"aggTypes":[[]]}"#
        ).unwrap();
        std::fs::write(ginfo_dir.join("pilout.globalConstraints.json"),
            r#"{"constraints":[],"hints":[]}"#
        ).unwrap();

        // Write starkinfo and verifierinfo but NOT verkey.json
        std::fs::write(pk_dir.join("Dma.starkinfo.json"), r#"{"nStages":2}"#).unwrap();
        std::fs::write(pk_dir.join("Dma.verifierinfo.json"), r#"{}"#).unwrap();

        let pilout_data = std::fs::read(&pilout_path).unwrap();
        let pilout = pilout::pilout::PilOut::decode(pilout_data.as_slice()).unwrap();
        let opts = SetupOptions {
            airout_path: pilout_path.to_str().unwrap().to_string(),
            build_dir: build_dir.to_str().unwrap().to_string(),
            fixed_dir: None,
            stark_structs_path: None,
            recursive: true,
            std_pil_path: None,
        };

        let result = run_recursive_setup(&pilout, "zisk", &opts);
        assert!(result.is_err(), "recursive should fail when verkey.json is missing");
        let err_msg = format!("{:#}", result.unwrap_err());
        assert!(
            err_msg.contains("verkey") || err_msg.contains("not found"),
            "error should mention missing verkey: {}", err_msg
        );

        let _ = std::fs::remove_dir_all(&tmp_dir);
    }

    /// Test that recursive2 fails when recursive1 starkinfo/verifierinfo are missing.
    /// Uses a minimal PilOut with one zero-row AIR so the per-AIR recursive loop
    /// skips it (num_rows=0), then recursive2 checks for recursive1 artifacts and fails.
    #[test]
    fn test_recursive2_fails_without_recursive1_artifacts() {
        use pilout::pilout as pb;
        use prost::Message;

        // Build minimal PilOut with one airgroup, one zero-row air
        let pilout = pb::PilOut {
            name: Some("test".to_string()),
            air_groups: vec![pb::AirGroup {
                name: Some("TestGroup".to_string()),
                airs: vec![pb::Air {
                    name: Some("TestAir".to_string()),
                    num_rows: Some(0), // zero rows -> skipped in recursive per-AIR loop
                    ..Default::default()
                }],
                ..Default::default()
            }],
            ..Default::default()
        };

        let tmp_dir = std::env::temp_dir().join(format!("pil2_r2_prereq_test_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&tmp_dir);
        let build_dir = tmp_dir.join("build");
        let pk_dir = build_dir.join("provingKey");
        std::fs::create_dir_all(&pk_dir).unwrap();

        // Write required global files
        std::fs::write(pk_dir.join("pilout.globalInfo.json"),
            r#"{"name":"test","nPublics":0}"#).unwrap();
        std::fs::write(pk_dir.join("pilout.globalConstraints.json"),
            r#"{"constraints":[],"hints":[]}"#).unwrap();

        // Do NOT create recursive1/ directory -> recursive2 should bail

        // Encode pilout to disk for the opts path
        let pilout_path = tmp_dir.join("test.pilout");
        let mut buf = Vec::new();
        pilout.encode(&mut buf).unwrap();
        std::fs::write(&pilout_path, &buf).unwrap();

        let opts = SetupOptions {
            airout_path: pilout_path.to_str().unwrap().to_string(),
            build_dir: build_dir.to_str().unwrap().to_string(),
            fixed_dir: None,
            stark_structs_path: None,
            recursive: true,
            std_pil_path: None,
        };

        let result = run_recursive_setup(&pilout, "test", &opts);
        assert!(result.is_err(), "recursive2 should fail when recursive1 artifacts are missing");
        let err_msg = format!("{:#}", result.unwrap_err());
        assert!(
            err_msg.contains("Recursive2 requires") || err_msg.contains("recursive1"),
            "error should mention missing recursive1 artifacts: {}", err_msg
        );

        let _ = std::fs::remove_dir_all(&tmp_dir);
    }

    /// Test the run_setup failure-path contract: global files survive when
    /// run_setup returns Err.
    ///
    /// Uses a name-collision trick: PilOut.name = "pilout.globalInfo.json"
    /// so write_global_info creates a FILE at provingKey/pilout.globalInfo.json,
    /// then the AIR loop tries to create a DIRECTORY under that same path
    /// (provingKey/pilout.globalInfo.json/<airgroup>/airs/<air>/air/),
    /// which fails because a file already occupies that path.
    #[test]
    fn test_run_setup_err_with_global_files_surviving() {
        use pilout::pilout as pb;
        use prost::Message;

        // PilOut.name collides with the globalInfo.json file path
        let pilout_proto = pb::PilOut {
            name: Some("pilout.globalInfo.json".to_string()),
            air_groups: vec![pb::AirGroup {
                name: Some("G".to_string()),
                airs: vec![pb::Air {
                    name: Some("A".to_string()),
                    num_rows: Some(4), // non-zero so the AIR loop processes it
                    ..Default::default()
                }],
                ..Default::default()
            }],
            ..Default::default()
        };

        let tmp_dir = std::env::temp_dir().join(format!("pil2_err_global_survive_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&tmp_dir);
        let build_dir = tmp_dir.join("build");
        std::fs::create_dir_all(&build_dir).unwrap();

        let pilout_path = tmp_dir.join("collision.pilout");
        let mut buf = Vec::new();
        pilout_proto.encode(&mut buf).unwrap();
        std::fs::write(&pilout_path, &buf).unwrap();

        let opts = SetupOptions {
            airout_path: pilout_path.to_str().unwrap().to_string(),
            build_dir: build_dir.to_str().unwrap().to_string(),
            fixed_dir: None,
            stark_structs_path: None,
            recursive: false,
            std_pil_path: None,
        };

        let result = run_setup(&opts);

        // run_setup must return Err (AIR dir creation collides with the file)
        assert!(result.is_err(),
            "run_setup should fail due to dir/file collision, got Ok");

        // All three global files must still exist on disk
        let pk_dir = build_dir.join("provingKey");
        assert!(pk_dir.join("pilout.globalInfo.json").exists(),
            "globalInfo.json must survive after run_setup Err");
        assert!(pk_dir.join("pilout.globalConstraints.json").exists(),
            "globalConstraints.json must survive after run_setup Err");
        assert!(pk_dir.join("pilout.globalConstraints.bin").exists(),
            "globalConstraints.bin must survive after run_setup Err");

        let _ = std::fs::remove_dir_all(&tmp_dir);
    }

    #[test]
    fn test_parse_verkey_json_valid() {
        let tmp = std::env::temp_dir().join(format!("pil2_vk_valid_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&tmp);
        std::fs::create_dir_all(&tmp).unwrap();
        let p = tmp.join("vk.json");
        std::fs::write(&p, "[1,2,3,4]").unwrap();
        let r = parse_verkey_json(&p).unwrap();
        assert_eq!(r, ["1", "2", "3", "4"]);
        let _ = std::fs::remove_dir_all(&tmp);
    }

    #[test]
    fn test_parse_verkey_json_rejects_5_entries() {
        let tmp = std::env::temp_dir().join(format!("pil2_vk_5_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&tmp);
        std::fs::create_dir_all(&tmp).unwrap();
        let p = tmp.join("vk.json");
        std::fs::write(&p, "[1,2,3,4,5]").unwrap();
        assert!(parse_verkey_json(&p).is_err());
        let _ = std::fs::remove_dir_all(&tmp);
    }

    #[test]
    fn test_parse_verkey_json_rejects_short_array() {
        let tmp = std::env::temp_dir().join(format!("pil2_vk_short_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&tmp);
        std::fs::create_dir_all(&tmp).unwrap();
        let p = tmp.join("vk.json");
        std::fs::write(&p, "[1,2]").unwrap();
        assert!(parse_verkey_json(&p).is_err());
        let _ = std::fs::remove_dir_all(&tmp);
    }

    #[test]
    fn test_parse_verkey_json_rejects_non_numeric() {
        let tmp = std::env::temp_dir().join(format!("pil2_vk_nan_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&tmp);
        std::fs::create_dir_all(&tmp).unwrap();
        let p = tmp.join("vk.json");
        std::fs::write(&p, r#"[1, "bad", 3, 4]"#).unwrap();
        assert!(parse_verkey_json(&p).is_err());
        let _ = std::fs::remove_dir_all(&tmp);
    }

    #[test]
    fn test_parse_verkey_json_rejects_non_array() {
        let tmp = std::env::temp_dir().join(format!("pil2_vk_obj_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&tmp);
        std::fs::create_dir_all(&tmp).unwrap();
        let p = tmp.join("vk.json");
        std::fs::write(&p, r#"{"a":1}"#).unwrap();
        assert!(parse_verkey_json(&p).is_err());
        let _ = std::fs::remove_dir_all(&tmp);
    }

    #[test]
    fn test_parse_verkey_json_rejects_missing() {
        let p = std::path::Path::new("/tmp/nonexistent_verkey.json");
        assert!(parse_verkey_json(p).is_err());
    }
}

