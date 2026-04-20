//! Non-recursive setup command: the main orchestrator for the setup pipeline.
//!
//! Ports the non-recursive path of `pil2-proofman-js/src/cmd/setup_cmd.js`.

use std::fs;
use std::path::{Path, PathBuf};
use std::sync::Arc;

use anyhow::{Context, Result};

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
        "Processing {} AIRs (forked child per AIR for memory isolation)",
        work_items.len()
    );

    // Share pilout and settings across threads
    let pilout = Arc::new(pilout);
    let settings_map = Arc::new(settings_map);
    let build_dir = opts.build_dir.clone();
    let fixed_dir = opts.fixed_dir.clone();
    let pilout_name_shared = pilout_name.clone();

    // Generate globalInfo.json and globalConstraints BEFORE per-AIR
    // processing so `run_recursive_setup` can read the airgroup / air
    // structure from disk. The serialized `hasCompressor` flags at this
    // point are placeholders filled from `starkstructs.json`; the
    // runtime compressor decision map returned by
    // `run_recursive_setup` is the authoritative source of truth and
    // drives a post-recursive-setup rewrite of the same file. This
    // mirrors golden JS `setup_cmd.js`, which mutates
    // `globalInfo.airs[..].hasCompressor` only after the runtime
    // `isCompressorNeeded()` has run and then writes the final
    // `pilout.globalInfo.json` at the end.
    write_global_info(&pilout, &pilout_name, &opts.build_dir, &settings_map, None)?;

    // Process each AIR in a forked child process. The child runs pil_info,
    // writes JSON/bin/bctree files, then exits. This fully isolates each
    // AIR's memory: the OS reclaims ALL pages when the child exits, preventing
    // VmHWM accumulation across 35 AIRs (which otherwise reaches ~89 GB from
    // glibc mmap fragmentation even with sequential processing + malloc_trim).
    let results: Vec<Result<()>> = work_items
        .iter()
        .map(|item| {
            if item.num_rows == 0 {
                tracing::info!("Skipping empty air '{}'", item.air_name);
                return Ok(());
            }
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

            // Run pil_info + JSON write + bctree + bin write in a forked
            // child process. The child inherits the parent's address space
            // (COW), does all heavy work, writes files to disk, then exits.
            // When the child exits, ALL its memory is freed by the OS -
            // no VmHWM accumulation across 35 AIRs.
            let starkinfo_path = files_dir.join(format!("{}.starkinfo.json", item.air_name));
            let child_pid = unsafe { libc::fork() };
            if child_pid == 0 {
                // === CHILD PROCESS ===
                // After fork(), the parent's rayon thread pool workers don't
                // exist in the child. The global pool is stale and will
                // deadlock on par_iter/par_chunks_mut. We install a fresh
                // pool; build_global() will succeed because the old global
                // is effectively dead (no worker threads survived fork).
                //
                // Use std::env to force rayon to create a new pool:
                std::env::set_var("RAYON_NUM_THREADS", "0");
                // Actually use install() on a new pool for this child's work:
                let pool = rayon::ThreadPoolBuilder::new()
                    .stack_size(64 * 1024 * 1024)
                    .build()
                    .expect("Failed to create rayon pool in child");
                let result = pool.install(|| -> Result<()> {
                    let prepare_opts = PrepareOptions {
                        debug: false,
                        im_pols_stages: false,
                    };
                    let pil_result =
                        pil_info::pil_info(&pilout, item.ag_idx, item.air_idx, &stark_struct, &prepare_opts);
                    let setup_result = &pil_result.setup;
                    let pil_code = &pil_result.pil_code;

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
                        setup_result, &stark_struct, pil_code, &opening_points,
                        &fri_security, item.ag_idx, item.air_idx, &item.air_name,
                        pil_result.c_exp_id, pil_result.fri_exp_id, pil_result.q_deg,
                    );

                    let starkinfo_json = json_output::to_json_string(&starkinfo_output)?;
                    fs::write(&starkinfo_path, &starkinfo_json)?;

                    let expr_info_json = build_expressions_info_json(&pil_code.expressions_info);
                    fs::write(
                        files_dir.join(format!("{}.expressionsinfo.json", item.air_name)),
                        &json_output::to_json_string(&expr_info_json)?,
                    )?;

                    let verifier_info_json = build_verifier_info_json(&pil_code.verifier_info);
                    fs::write(
                        files_dir.join(format!("{}.verifierinfo.json", item.air_name)),
                        &json_output::to_json_string(&verifier_info_json)?,
                    )?;

                    // bctree in the same child (no need for subprocess within subprocess)
                    let verkey_json_path = files_dir.join(format!("{}.verkey.json", item.air_name));
                    if const_path.exists() {
                        let const_root = crate::bctree::compute_const_tree(
                            const_path.to_str().unwrap_or(""),
                            starkinfo_path.to_str().unwrap_or(""),
                            verkey_json_path.to_str().unwrap_or(""),
                        )?;
                        let verkey_bin: Vec<u8> = const_root.iter()
                            .flat_map(|v| v.to_le_bytes())
                            .collect();
                        fs::write(files_dir.join(format!("{}.verkey.bin", item.air_name)), &verkey_bin)?;
                    }

                    write_bin_files_native(
                        &starkinfo_path,
                        &files_dir.join(format!("{}.expressionsinfo.json", item.air_name)),
                        &files_dir.join(format!("{}.verifierinfo.json", item.air_name)),
                        &files_dir.join(format!("{}.bin", item.air_name)),
                        &files_dir.join(format!("{}.verifier.bin", item.air_name)),
                    )?;
                    Ok(())
                });

                // Exit child: _exit avoids running destructors/atexit handlers
                let code = if result.is_ok() { 0 } else {
                    if let Err(e) = &result {
                        eprintln!("venus-setup child error for '{}': {:#}", item.air_name, e);
                    }
                    1
                };
                unsafe { libc::_exit(code); }
            }

            // === PARENT PROCESS ===
            if child_pid < 0 {
                anyhow::bail!("fork() failed for air '{}'", item.air_name);
            }
            let mut status: libc::c_int = 0;
            let waited = unsafe { libc::waitpid(child_pid, &mut status, 0) };
            if waited < 0 {
                anyhow::bail!("waitpid() failed for air '{}'", item.air_name);
            }
            if !libc::WIFEXITED(status) || libc::WEXITSTATUS(status) != 0 {
                let exit_code = if libc::WIFEXITED(status) { libc::WEXITSTATUS(status) } else { -1 };
                anyhow::bail!(
                    "Setup child for air '{}' failed with exit code {}",
                    item.air_name, exit_code
                );
            }
            tracing::info!("Setup for air '{}' complete", item.air_name);
            Ok(())
        })
        .collect();

    // Check for any errors and propagate them
    for result in results {
        result?;
    }

    // Recursive setup (if --recursive is set). When it completes, the
    // returned compressor decision map reflects the single runtime
    // source of truth: starkstructs.json overrides first, then
    // `is_compressor_needed()`. Rewrite `pilout.globalInfo.json` so the
    // persisted `hasCompressor` flags match the compressor directories
    // that actually ended up on disk. This is the same end-of-setup
    // write that golden JS performs at the end of `setup_cmd.js`.
    if opts.recursive {
        tracing::info!("Starting recursive setup...");
        let compressor_decisions =
            run_recursive_setup(&pilout, &pilout_name, opts, &settings_map)?;
        write_global_info(
            &pilout,
            &pilout_name,
            &opts.build_dir,
            &settings_map,
            Some(&compressor_decisions),
        )?;
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
/// Per-AIR compressor decision collected during recursive setup.
///
/// Keyed by `(airgroup_index, air_index_within_airgroup)`. A present key with
/// value `true` means the recursive pipeline generated a compressor for that
/// AIR. The same map is used to populate `pilout.globalInfo.json`'s
/// `hasCompressor` flags so generation and serialization share a single
/// source of truth (matching golden JS semantics).
pub type CompressorDecisionMap = std::collections::BTreeMap<(u32, u32), bool>;

/// Compute the per-AIR compressor decision map from real per-AIR
/// setup artifacts on disk.
///
/// **Side effects**: this function calls
/// `compressor_check::is_compressor_needed`, which on its
/// `n_bits < 17` branch rewrites the per-AIR
/// `<air>.starkinfo.json` to bump `nQueries`. That is
/// intentional and mirrors golden JS, but it means a caller
/// driving this helper against a `build/provingKey/` tree
/// they do not own (e.g. an integration test) will mutate
/// those files in place. The helper is therefore named
/// `_with_side_effects` to make the impurity explicit, and
/// the caller is responsible for ensuring the on-disk tree is
/// either disposable or rebuilt before re-use.
///
/// For each AIR with non-zero rows, this function:
///   1. Loads `<build_dir>/provingKey/<pilout>/<airgroup>/airs/<air>/air/<air>.{starkinfo,verifierinfo,verkey}.json`.
///   2. If `settings_map[air_name].has_compressor == Some(true)`,
///      records `true` (forced override, matches golden JS).
///   3. Otherwise invokes `compressor_check::is_compressor_needed`
///      and records its result.
///
/// Any missing artifact fails the call with a file-level error, so
/// callers (including integration tests) must guarantee the
/// per-AIR setup has run first.
pub fn compute_compressor_decisions_with_side_effects(
    pilout: &pb::PilOut,
    pilout_name: &str,
    build_dir: &str,
    settings_map: &IndexMap<String, StarkSettings>,
    circom_exec: &str,
    circuits_gl_path: &str,
) -> Result<CompressorDecisionMap> {
    use crate::compressor_check;
    let mut decisions: CompressorDecisionMap = CompressorDecisionMap::new();

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
                continue;
            }

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

            let stark_info: serde_json::Value =
                serde_json::from_str(&fs::read_to_string(&si_path).with_context(|| {
                    format!("Failed to read starkinfo for '{}'", air_name)
                })?)?;
            let verifier_info: serde_json::Value =
                serde_json::from_str(&fs::read_to_string(&vi_path).with_context(|| {
                    format!("Failed to read verifierinfo for '{}'", air_name)
                })?)?;
            let const_root_strings = parse_verkey_json(&vk_path)
                .with_context(|| format!("Failed to load verkey for '{}'", air_name))?;

            let forced = settings_map
                .get(&air_name)
                .and_then(|s| s.has_compressor)
                .unwrap_or(false);
            let needed = if forced {
                true
            } else {
                compressor_check::is_compressor_needed(
                    &const_root_strings,
                    &stark_info,
                    &verifier_info,
                    si_path.to_str().unwrap_or(""),
                    circom_exec,
                    circuits_gl_path,
                )?
                .needed
            };
            decisions.insert((ag_idx as u32, air_idx as u32), needed);
        }
    }

    Ok(decisions)
}

fn run_recursive_setup(
    pilout: &pb::PilOut,
    pilout_name: &str,
    opts: &SetupOptions,
    settings_map: &IndexMap<String, StarkSettings>,
) -> Result<CompressorDecisionMap> {
    use crate::compressor_check;
    use crate::compressed_final;
    use crate::final_setup;
    use crate::recursive_setup::{self, RecursiveTemplate, RecursiveSetupConfig};
    use crate::witness_gen::WitnessTracker;

    let mut compressor_decisions: CompressorDecisionMap = CompressorDecisionMap::new();

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

    // Read globalInfo. The `hasCompressor` flags in this file start
    // as placeholders written from `starkstructs.json`; the runtime
    // compressor decision map built below mutates them in place as
    // each decision is made, so downstream `gen_recursive_setup`
    // calls that read `global_info.airs[..].hasCompressor` see the
    // finalized value instead of the pre-recursive placeholder.
    // The same map is returned from this function and used by
    // `run_setup` to rewrite the on-disk file at the end.
    let proving_key_dir = Path::new(build_dir).join("provingKey");
    let global_info_path = proving_key_dir.join("pilout.globalInfo.json");
    let mut global_info: serde_json::Value = if global_info_path.exists() {
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

            let mut stark_info: serde_json::Value =
                serde_json::from_str(&fs::read_to_string(&si_path)?)?;
            let verifier_info: serde_json::Value =
                serde_json::from_str(&fs::read_to_string(&vi_path)?)?;

            let const_root_strings = parse_verkey_json(&vk_path)
                .with_context(|| format!("Failed to load verkey for air '{}'", air_name))?;

            // Check if compressor is needed. Mirror golden JS
            // setup_cmd.js: explicit `hasCompressor: true` in
            // `state-machines/starkstructs.json` is a forced override;
            // otherwise fall back to the runtime
            // `is_compressor_needed()` R1CS-row threshold.
            //
            // When `is_compressor_needed` lands in the
            // `nBits < 17` branch it rewrites the on-disk
            // `starkinfo.json` to bump `nQueries`. Golden JS
            // mutates the in-memory `starkInfo` object by
            // reference, so recursive1 picks up the adjusted
            // value automatically. We do the same here: when
            // `starkinfo_updated` is true, reload the file so
            // the in-memory `stark_info` matches the on-disk
            // copy before any downstream consumer reads it.
            let forced_by_settings = settings_map
                .get(&air_name)
                .and_then(|s| s.has_compressor)
                .unwrap_or(false);
            let has_compressor = if forced_by_settings {
                tracing::info!(
                    "Air '{}' flagged hasCompressor=true in starkstructs.json",
                    air_name
                );
                true
            } else {
                let result = compressor_check::is_compressor_needed(
                    &const_root_strings,
                    &stark_info,
                    &verifier_info,
                    si_path.to_str().unwrap_or(""),
                    &circom_exec,
                    &circuits_gl_path,
                )
                .with_context(|| format!("Compressor check failed for air '{}'", air_name))?;
                if result.starkinfo_updated {
                    stark_info = serde_json::from_str(&fs::read_to_string(&si_path)?)
                        .with_context(|| {
                            format!(
                                "Failed to reload rewritten starkinfo for air '{}'",
                                air_name
                            )
                        })?;
                }
                result.needed
            };
            compressor_decisions.insert((ag_idx as u32, air_idx as u32), has_compressor);

            // Mirror golden JS `setup_cmd.js:164-165`: as soon as the
            // runtime decision is made, write it into the in-memory
            // `global_info.airs[ag_idx][air_idx].hasCompressor` so
            // every downstream `gen_recursive_setup` call sees the
            // finalized flag. Without this, `recursive1` and the
            // subsequent compressor/recursive/final generation steps
            // read the stale pre-recursive placeholder that was
            // written from `starkstructs.json`.
            if has_compressor {
                if let Some(airs) = global_info.get_mut("airs").and_then(|v| v.as_array_mut()) {
                    if let Some(ag_arr) = airs.get_mut(ag_idx).and_then(|v| v.as_array_mut()) {
                        if let Some(air_obj) =
                            ag_arr.get_mut(air_idx).and_then(|v| v.as_object_mut())
                        {
                            air_obj.insert("hasCompressor".to_string(), serde_json::json!(true));
                        }
                    }
                }
            }

            let mut compressor_result: Option<recursive_setup::RecursiveSetupResult> = None;
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
                    Ok(result) => {
                        tracing::info!("Compressor setup complete for air '{}'", air_name);
                        compressor_result = Some(result);
                    }
                    Err(e) => {
                        return Err(e.context(format!(
                            "Compressor setup failed for air '{}'", air_name
                        )));
                    }
                }
            }

            // When has_compressor, use compressor's starkInfo/verifierInfo for recursive1
            let (r1_stark_info, r1_verifier_info) = if has_compressor {
                let cr = compressor_result.as_ref().expect("compressor result missing");
                (
                    cr.stark_info.as_ref().unwrap_or(&stark_info),
                    cr.verifier_info.as_ref().unwrap_or(&verifier_info),
                )
            } else {
                (&stark_info, &verifier_info)
            };

            // Compressor const root for recursive1 when has_compressor
            let r1_const_root = if has_compressor {
                let cr = compressor_result.as_ref().expect("compressor result missing");
                let cr_strs: Vec<String> = cr.const_root.iter().map(|v| v.to_string()).collect();
                [cr_strs[0].clone(), cr_strs[1].clone(), cr_strs[2].clone(), cr_strs[3].clone()]
            } else {
                const_root_strings.clone()
            };

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
                const_root: &r1_const_root,
                verification_keys: &[],
                stark_info: r1_stark_info,
                verifier_info: r1_verifier_info,
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

    // Pad recursive1 const files to match recursive2 nBits.
    // The prover loads recursive1 const using recursive2's starkinfo dimensions.
    // If recursive2 has more rows than recursive1 (different nBits from plonk2pil),
    // the const files need zero-padding to match.
    {
        let r2_dir = PathBuf::from(build_dir)
            .join("provingKey")
            .join(pilout_name)
            .join(&pilout.air_groups[0].name.clone().unwrap_or_else(|| "Zisk".to_string()))
            .join("recursive2");
        let r2_si_path = r2_dir.join("recursive2.starkinfo.json");
        if r2_si_path.exists() {
            let r2_si: serde_json::Value = serde_json::from_str(&fs::read_to_string(&r2_si_path)?)?;
            let r2_n_bits = r2_si.pointer("/starkStruct/nBits").and_then(|v| v.as_u64()).unwrap_or(0) as usize;
            let r2_n_constants = r2_si.get("nConstants").and_then(|v| v.as_u64()).unwrap_or(0) as usize;
            let r2_n_rows = 1usize << r2_n_bits;

            for airgroup in pilout.air_groups.iter() {
                let ag_name = airgroup.name.clone().unwrap_or_default();
                for air in airgroup.airs.iter() {
                    let air_name = air.name.clone().unwrap_or_default();
                    if air.num_rows.unwrap_or(0) == 0 { continue; }
                    let r1_const_path = PathBuf::from(build_dir)
                        .join("provingKey").join(pilout_name).join(&ag_name)
                        .join("airs").join(&air_name).join("recursive1")
                        .join("recursive1.const");
                    if r1_const_path.exists() {
                        let file_size = fs::metadata(&r1_const_path)?.len() as usize;
                        let expected_size = r2_n_rows * r2_n_constants * 8;
                        if file_size < expected_size {
                            tracing::info!(
                                "Padding {}/recursive1.const from {} to {} bytes (r2 nBits={})",
                                air_name, file_size, expected_size, r2_n_bits
                            );
                            let mut f = fs::OpenOptions::new().append(true).open(&r1_const_path)?;
                            let padding = vec![0u8; expected_size - file_size];
                            use std::io::Write;
                            f.write_all(&padding)?;
                            f.sync_all()?;
                        }
                        let actual = fs::metadata(&r1_const_path)?.len() as usize;
                        if actual != expected_size {
                            anyhow::bail!(
                                "recursive1.const size mismatch after padding for {}/{}: got {} B, expected {} B (recursive2 nBits={}, nConstants={})",
                                ag_name, air_name, actual, expected_size, r2_n_bits, r2_n_constants
                            );
                        }
                    }
                }
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
    Ok(compressor_decisions)
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
            // Array-declared fixed columns (e.g. `col fixed OPID[num_groups]`)
            // carry a per-index `lengths` vector that `generate_multi_array_symbols`
            // populates on the source SymbolInfo. The golden JS producer emits
            // that field on every such entry; preserve it here so constPolsMap
            // round-trips byte-identical with golden for array-backed fixed
            // columns while scalar columns (lengths None) stay unchanged.
            lengths: p.lengths.clone(),
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
            let public_values: Vec<serde_json::Value> = cc
                .public_values
                .iter()
                .map(|&idx| json!({"idx": idx}))
                .collect();
            json!({
                "name": cc.name,
                "publicValues": public_values,
                "stageWidths": cc.stage_widths,
            })
        })
        .collect();

    // Build custom commits map (array of arrays, one per custom commit)
    let custom_commits_map: Vec<serde_json::Value> = setup
        .custom_commits_map
        .iter()
        .map(|cc_entries| {
            let entries: Vec<serde_json::Value> = cc_entries
                .iter()
                .enumerate()
                .map(|(i, p)| {
                    let mut obj = serde_json::Map::new();
                    obj.insert("stage".to_string(), json!(p.stage.unwrap_or(0)));
                    // Strip namespace prefix (e.g. "Rom.line" -> "line")
                    let short_name = p.name.rsplit('.').next().unwrap_or(&p.name);
                    obj.insert("name".to_string(), json!(short_name));
                    obj.insert("dim".to_string(), json!(p.dim));
                    obj.insert("polsMapId".to_string(), json!(i));
                    obj.insert("stageId".to_string(), json!(p.stage_id.unwrap_or(0)));
                    obj.insert("stagePos".to_string(), json!(p.stage_pos.unwrap_or(0)));
                    serde_json::Value::Object(obj)
                })
                .collect();
            json!(entries)
        })
        .collect();

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
    // Lexicographic (string) sort to match the JS reference, which does
    //   [...new Set(...)].sort()
    // without a comparator — i.e., default JS Array.sort is lexicographic.
    // That produces ["-1", "-2", "0", "1"] for the set {-2, -1, 0, 1}, not
    // numeric ascending. The prover's rowOffsetIndex derives from this order
    // (see pil2-proofman-js src/pil2-stark/pil_info/helpers/code/codegen.js
    // findIndex by prime), so the order must match golden exactly.
    points.sort_by(|a, b| a.to_string().cmp(&b.to_string()));
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
    compressor_decisions: Option<&CompressorDecisionMap>,
) -> Result<()> {
    let proving_key_dir = Path::new(build_dir).join("provingKey");
    fs::create_dir_all(&proving_key_dir)?;

    // Build globalInfo (vadcopInfo in JS)
    let mut airs = Vec::new();
    let mut air_groups = Vec::new();
    let mut agg_types = Vec::new();

    for (ag_idx, airgroup) in pilout.air_groups.iter().enumerate() {
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
        for (air_idx, air) in airgroup.airs.iter().enumerate() {
            let a_name = air.name.clone().unwrap_or_else(|| "unnamed".to_string());
            // Runtime decision map wins when present; otherwise fall
            // back to the settings_map placeholder so the pre-recursive
            // write still produces a reasonable file.
            let has_compressor = match compressor_decisions {
                Some(map) => *map
                    .get(&(ag_idx as u32, air_idx as u32))
                    .unwrap_or(&false),
                None => settings_map
                    .get(&a_name)
                    .and_then(|s| s.has_compressor)
                    .unwrap_or(false),
            };
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
#[allow(dead_code)]
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

    /// Live-runtime regression for the compressor decision path.
    ///
    /// Unlike a manual-map test that hand-builds the expected
    /// `CompressorDecisionMap`, this drives `compute_compressor_decisions_with_side_effects`,
    /// which in turn calls `compressor_check::is_compressor_needed`
    /// on real per-AIR starkinfo / verifierinfo / verkey artifacts
    /// from a completed `build/provingKey/` tree. It asserts that
    /// the returned decision map, the compressor directories on
    /// disk, and the serialized `pilout.globalInfo.json` flags all
    /// agree with the golden six-AIR set
    /// `{DmaPrePost, ArithEq, ArithEq384, Blake2br, Keccakf,
    /// Sha256f}`.
    ///
    /// The test fails (not skips) when prerequisites are missing.
    /// It looks for `build/provingKey/` relative to the workspace
    /// root; set `SKIP_LIVE_COMPRESSOR_TEST=1` to opt out on
    /// environments that genuinely cannot run per-AIR setup first,
    /// but the default behavior is to fail so clean checkouts get
    /// an honest signal rather than a silent pass.
    #[test]
    fn test_global_info_has_compressor() {
        if std::env::var("SKIP_LIVE_COMPRESSOR_TEST").is_ok() {
            eprintln!(
                "Opt-out via SKIP_LIVE_COMPRESSOR_TEST; this is a \
                 live-runtime regression and should normally run."
            );
            return;
        }

        let manifest = std::path::Path::new(env!("CARGO_MANIFEST_DIR"));
        let workspace = manifest.parent().expect("manifest parent");

        let pilout_path = manifest.join("../pil/zisk.pilout");
        assert!(
            pilout_path.is_file(),
            "pilout not found at {}. Live-runtime regression needs a \
             compiled Zisk pilout; run `make setup` at least once.",
            pilout_path.display()
        );

        let build_dir = workspace.join("build");
        let proving_key_dir = build_dir.join("provingKey");
        assert!(
            proving_key_dir.is_dir(),
            "build/provingKey not found at {}. Live-runtime \
             regression needs a completed per-AIR setup run; this \
             test intentionally fails on a clean checkout rather \
             than silently passing.",
            proving_key_dir.display()
        );

        let pilout_data = std::fs::read(&pilout_path).unwrap();
        let pilout = pb::PilOut::decode(pilout_data.as_slice()).unwrap();
        let pilout_name = pilout.name.clone().unwrap_or_else(|| "pilout".to_string());

        let settings_path = manifest.join("../state-machines/starkstructs.json");
        let settings_map: IndexMap<String, StarkSettings> = if settings_path.exists() {
            serde_json::from_str(&std::fs::read_to_string(&settings_path).unwrap()).unwrap()
        } else {
            IndexMap::new()
        };

        let circom_exec = std::env::var("CIRCOM_EXEC")
            .unwrap_or_else(|_| workspace.join("circom/circom").display().to_string());
        // Align with runtime default in `run_recursive_setup`: the
        // include directory that holds cmul.circom lives at repo-root
        // `circuits.gl/`, not under a non-existent
        // `stark-recurser-rust/src/pil2circom/circuits.gl`. Hardcoding
        // the old path caused the live oracle to fail before reaching
        // any assertion with `error[P1014] cmul.circom to be included
        // has not been found`.
        let circuits_gl_path = std::env::var("CIRCUITS_GL_PATH")
            .unwrap_or_else(|_| workspace.join("circuits.gl").display().to_string());

        assert!(
            std::path::Path::new(&circom_exec).is_file(),
            "circom executable not found at {}; set CIRCOM_EXEC to override",
            circom_exec,
        );

        // Drive the live runtime decision path.
        let decisions = compute_compressor_decisions_with_side_effects(
            &pilout,
            &pilout_name,
            build_dir.to_str().unwrap(),
            &settings_map,
            &circom_exec,
            &circuits_gl_path,
        )
        .expect("compute_compressor_decisions_with_side_effects");

        let golden_set: std::collections::BTreeSet<String> = [
            "DmaPrePost",
            "ArithEq",
            "ArithEq384",
            "Blake2br",
            "Keccakf",
            "Sha256f",
        ]
        .iter()
        .map(|s| s.to_string())
        .collect();

        // Map (ag_idx, air_idx) -> air_name for reporting
        let mut name_of: std::collections::BTreeMap<(u32, u32), String> =
            std::collections::BTreeMap::new();
        for (ag_idx, airgroup) in pilout.air_groups.iter().enumerate() {
            for (air_idx, air) in airgroup.airs.iter().enumerate() {
                if let Some(n) = air.name.clone() {
                    name_of.insert((ag_idx as u32, air_idx as u32), n);
                }
            }
        }

        let decided_true: std::collections::BTreeSet<String> = decisions
            .iter()
            .filter_map(|(k, v)| if *v { name_of.get(k).cloned() } else { None })
            .collect();

        assert_eq!(
            decided_true, golden_set,
            "live-runtime compressor decision set must equal the golden six-AIR set; decisions={:?}",
            decisions,
        );

        // Serialize and verify the flag set matches.
        let out_dir = "/tmp/r42_live_compressor_test";
        let _ = std::fs::remove_dir_all(out_dir);
        write_global_info(&pilout, &pilout_name, out_dir, &settings_map, Some(&decisions))
            .unwrap();

        let gi_str = std::fs::read_to_string(format!(
            "{}/provingKey/pilout.globalInfo.json",
            out_dir
        ))
        .unwrap();
        let gi: serde_json::Value = serde_json::from_str(&gi_str).unwrap();
        let mut flagged: std::collections::BTreeSet<String> =
            std::collections::BTreeSet::new();
        for ag in gi.get("airs").unwrap().as_array().unwrap() {
            for air in ag.as_array().unwrap() {
                let name = air.get("name").unwrap().as_str().unwrap().to_string();
                if air
                    .get("hasCompressor")
                    .and_then(|v| v.as_bool())
                    .unwrap_or(false)
                {
                    flagged.insert(name);
                }
            }
        }
        assert_eq!(
            flagged, golden_set,
            "serialized hasCompressor set must equal the golden six-AIR set"
        );

        // Verify the on-disk compressor directories match too.
        let mut on_disk: std::collections::BTreeSet<String> =
            std::collections::BTreeSet::new();
        let airs_dir = proving_key_dir
            .join(&pilout_name)
            .join(
                pilout.air_groups[0]
                    .name
                    .clone()
                    .unwrap_or_else(|| "airgroup_0".to_string()),
            )
            .join("airs");
        if let Ok(rd) = std::fs::read_dir(&airs_dir) {
            for entry in rd.flatten() {
                if entry.path().join("compressor").is_dir() {
                    on_disk.insert(entry.file_name().to_string_lossy().to_string());
                }
            }
        }
        assert_eq!(
            on_disk, golden_set,
            "on-disk compressor directories must equal the golden six-AIR set; decisions set was {:?}",
            decided_true,
        );

        let _ = std::fs::remove_dir_all(out_dir);
    }

    /// Artifact-level regression for `virtual_table_data_global`.
    ///
    /// Upstream bug (closed in Round 4): a container-declared variable
    /// was leaking into top-level refs on scope pop, so `air_ids` in
    /// `std_virtual_table.pil` resolved to the 750-entry
    /// `proof.std.gsum.air_ids` shadow instead of the correct 2-entry
    /// `proof.std.vt.air_ids`. The emitted `virtual_table_data_global`
    /// hint carried 750 bogus entries and blew up the prover at
    /// `std_virtual_table.rs:67`.
    ///
    /// This test decodes the Rust-compiled `pil/zisk.pilout` and its
    /// serialized `pilout.globalConstraints.json`, locates the
    /// `virtual_table_data_global` hint, and asserts:
    ///   - `airgroup_ids` values are `[0, 0]`
    ///   - `air_ids` values are `[33, 34]`
    ///   - per-AIR `virtual_table_data` hints in the pilout itself
    ///     cover exactly the AIRs with air_id `{33, 34}` in
    ///     airgroup 0.
    /// Any regression that leaks the container variable again, or
    /// misaligns per-AIR coverage with the global hint, will fail here
    /// long before `make prove` does.
    #[test]
    fn test_virtual_table_data_global_artifact() {
        let pilout_path = concat!(env!("CARGO_MANIFEST_DIR"), "/../pil/zisk.pilout");
        if !std::path::Path::new(pilout_path).exists() {
            eprintln!("Skipping test_virtual_table_data_global_artifact: pilout not found");
            return;
        }

        let pilout_data = std::fs::read(pilout_path).unwrap();
        let pilout = pb::PilOut::decode(pilout_data.as_slice()).unwrap();
        let pilout_name = pilout.name.clone().unwrap_or_else(|| "pilout".to_string());

        let settings_map: IndexMap<String, StarkSettings> = IndexMap::new();
        let build_dir = "/tmp/r41_vtd_global_test";
        let _ = std::fs::remove_dir_all(build_dir);

        write_global_info(&pilout, &pilout_name, build_dir, &settings_map, None)
            .expect("write_global_info");

        let gc_path = format!("{}/provingKey/pilout.globalConstraints.json", build_dir);
        let gc_str = std::fs::read_to_string(&gc_path).unwrap();
        let gc: serde_json::Value = serde_json::from_str(&gc_str).unwrap();
        let hints = gc.get("hints").unwrap().as_array().unwrap();

        let vtd_global = hints
            .iter()
            .find(|h| {
                h.get("name").and_then(|v| v.as_str()) == Some("virtual_table_data_global")
            })
            .expect("virtual_table_data_global hint must be present");

        let fields = vtd_global.get("fields").unwrap().as_array().unwrap();
        let extract_field = |name: &str| -> Vec<u64> {
            let f = fields
                .iter()
                .find(|f| f.get("name").and_then(|v| v.as_str()) == Some(name))
                .unwrap_or_else(|| panic!("field {} missing", name));
            f.get("values")
                .unwrap()
                .as_array()
                .unwrap()
                .iter()
                .map(|v| {
                    v.get("value")
                        .unwrap()
                        .as_str()
                        .unwrap()
                        .parse::<u64>()
                        .unwrap()
                })
                .collect()
        };

        let airgroup_ids = extract_field("airgroup_ids");
        let air_ids = extract_field("air_ids");
        assert_eq!(
            airgroup_ids,
            vec![0u64, 0u64],
            "virtual_table_data_global.airgroup_ids must equal golden [0, 0]"
        );
        assert_eq!(
            air_ids,
            vec![33u64, 34u64],
            "virtual_table_data_global.air_ids must equal golden [33, 34]"
        );

        // Per-AIR virtual_table_data hints must cover exactly those
        // AIRs in the pilout proto itself. Hints are stored at
        // `pilout.hints` with optional `(airGroupId, airId)` scoping;
        // per-AIR hints are those that carry both.
        let expected: std::collections::BTreeSet<(u32, u32)> =
            [(0u32, 33u32), (0u32, 34u32)].into_iter().collect();
        let mut actual: std::collections::BTreeSet<(u32, u32)> =
            std::collections::BTreeSet::new();
        for hint in &pilout.hints {
            if hint.name != "virtual_table_data" {
                continue;
            }
            if let (Some(ag), Some(a)) = (hint.air_group_id, hint.air_id) {
                actual.insert((ag, a));
            }
        }
        assert_eq!(
            actual, expected,
            "per-AIR virtual_table_data hints must cover exactly air_ids [33, 34] in airgroup 0"
        );

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

        write_global_info(&pilout, &pilout_name, build_dir, &settings_map, None).unwrap();

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

        let empty_settings: IndexMap<String, StarkSettings> = IndexMap::new();
        let result = run_recursive_setup(&pilout, "zisk", &opts, &empty_settings);
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

        let empty_settings: IndexMap<String, StarkSettings> = IndexMap::new();
        let result = run_recursive_setup(&pilout, "zisk", &opts, &empty_settings);
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

        let empty_settings: IndexMap<String, StarkSettings> = IndexMap::new();
        let result = run_recursive_setup(&pilout, "test", &opts, &empty_settings);
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

    /// Round 16 artifact-level regression per the Codex Round 15
    /// review. `make prove` fails at recursive1 witness generation
    /// on instances 63 (SpecifiedRanges) and 64 (VirtualTable0) via
    /// `VerifyEvaluations0` asserts. The Codex consult pins the
    /// root cause at Rust pil2c producing drifted verifier
    /// artifacts on `SpecifiedRanges`, `VirtualTable0`, and
    /// `VirtualTable1`: an extra stage-2 `*.ImPol`, `qDeg` collapsed
    /// from 2 to 1, `Q1` missing from `cmPolsMap`, and `nConstraints`
    /// off by one.
    ///
    /// This test reads the current-head `build/provingKey` AIR
    /// artifacts for those three AIRs AND the checked-in
    /// `temp/golden_references` copies, asserts the golden shape on
    /// the first structural drift boundary, and FAILS loudly on the
    /// current drift. It is the regression lock the Codex Round 15
    /// review required.
    ///
    /// The test skips (not fails) when `build/provingKey/zisk/Zisk/airs`
    /// is missing, so a fresh checkout without a completed
    /// `make generate-key` still runs the lib test suite without
    /// false negatives. It fails loudly when the directory exists
    /// and contains the drifted shape, which is the current state
    /// on HEAD `533bc6a7`.
    #[test]
    fn test_three_air_verifier_artifact_shape_matches_golden() {
        let manifest = std::path::Path::new(env!("CARGO_MANIFEST_DIR"));
        let workspace = manifest.parent().expect("manifest parent");
        let build_airs = workspace.join("build/provingKey/zisk/Zisk/airs");
        let gold_airs = workspace
            .join("temp/golden_references/provingKey/zisk/Zisk/airs");
        if !build_airs.is_dir() {
            eprintln!(
                "Skipping: {} not present (run `make generate-key` first)",
                build_airs.display()
            );
            return;
        }
        assert!(
            gold_airs.is_dir(),
            "golden_references missing at {}; this regression requires \
             the checked-in golden artifacts",
            gold_airs.display()
        );

        let air_names = ["SpecifiedRanges", "VirtualTable0", "VirtualTable1"];
        let mut failures: Vec<String> = Vec::new();

        for name in air_names {
            let cur_path =
                build_airs.join(name).join("air").join(format!("{}.starkinfo.json", name));
            let gold_path =
                gold_airs.join(name).join("air").join(format!("{}.starkinfo.json", name));
            if !cur_path.is_file() || !gold_path.is_file() {
                failures.push(format!(
                    "{}: starkinfo.json missing (cur={} gold={})",
                    name,
                    cur_path.display(),
                    gold_path.display()
                ));
                continue;
            }
            let cur: serde_json::Value =
                serde_json::from_str(&std::fs::read_to_string(&cur_path).unwrap()).unwrap();
            let gold: serde_json::Value =
                serde_json::from_str(&std::fs::read_to_string(&gold_path).unwrap()).unwrap();

            let cur_q_deg = cur.get("qDeg").and_then(|v| v.as_i64()).unwrap_or(-1);
            let gold_q_deg = gold.get("qDeg").and_then(|v| v.as_i64()).unwrap_or(-1);
            if cur_q_deg != gold_q_deg {
                failures.push(format!(
                    "{}: qDeg drift cur={} gold={}",
                    name, cur_q_deg, gold_q_deg
                ));
            }

            // Round 30 semantic gate (per Codex Round 29 review):
            // assert starkinfo.cExpId matches golden. cExpId is the
            // index into the per-AIR `expressions` arena; if it
            // differs, recursive1's id-wired evaluation chain
            // expects different indices than what the basic prover
            // produces at runtime, breaking the
            // `enable * (tmp_N - qAcc[1][k]) === 0` checks in the
            // generated VerifyEvaluations0 circuit. The Round 17
            // assertions on starkinfo / verifierinfo SHAPES (lengths)
            // pass while make prove fails — this stronger gate
            // catches the surviving numbering drift.
            let cur_c_exp_id = cur.get("cExpId").and_then(|v| v.as_u64()).unwrap_or(0);
            let gold_c_exp_id = gold.get("cExpId").and_then(|v| v.as_u64()).unwrap_or(0);
            if cur_c_exp_id != gold_c_exp_id {
                failures.push(format!(
                    "{}: starkinfo.cExpId drift cur={} gold={}. \
                     The constraint poly's index in the per-AIR \
                     expressions arena differs from golden, which \
                     causes recursive1's expected evaluation chain \
                     to mismatch the basic prover's runtime \
                     computation. Make prove fails at \
                     VerifyEvaluations0 because of this.",
                    name, cur_c_exp_id, gold_c_exp_id
                ));
            }
            let cur_fri_exp_id = cur.get("friExpId").and_then(|v| v.as_u64()).unwrap_or(0);
            let gold_fri_exp_id = gold.get("friExpId").and_then(|v| v.as_u64()).unwrap_or(0);
            if cur_fri_exp_id != gold_fri_exp_id {
                failures.push(format!(
                    "{}: starkinfo.friExpId drift cur={} gold={}. \
                     The FRI poly's expressions-arena index differs \
                     from golden; downstream FRI-quotient checks in \
                     recursive1 may also drift.",
                    name, cur_fri_exp_id, gold_fri_exp_id
                ));
            }

            let cur_n_constraints =
                cur.get("nConstraints").and_then(|v| v.as_u64()).unwrap_or(0);
            let gold_n_constraints =
                gold.get("nConstraints").and_then(|v| v.as_u64()).unwrap_or(0);
            if cur_n_constraints != gold_n_constraints {
                failures.push(format!(
                    "{}: nConstraints drift cur={} gold={}",
                    name, cur_n_constraints, gold_n_constraints
                ));
            }

            let cur_stage2_impol = count_stage_impol(&cur, 2);
            let gold_stage2_impol = count_stage_impol(&gold, 2);
            if cur_stage2_impol != gold_stage2_impol {
                failures.push(format!(
                    "{}: stage-2 ImPol count drift cur={} gold={}. \
                     Expected to match golden; extra ImPol is the \
                     Round 16 root cause.",
                    name, cur_stage2_impol, gold_stage2_impol
                ));
            }

            let cur_q_names = stage_pol_names(&cur, 3);
            let gold_q_names = stage_pol_names(&gold, 3);
            if cur_q_names != gold_q_names {
                failures.push(format!(
                    "{}: stage-3 (Q) polynomial name set drift cur={:?} \
                     gold={:?}. Expected both Q0 and Q1 in golden.",
                    name, cur_q_names, gold_q_names
                ));
            }

            let cur_ev_map = cur.get("evMap").and_then(|v| v.as_array()).map(|a| a.len()).unwrap_or(0);
            let gold_ev_map = gold.get("evMap").and_then(|v| v.as_array()).map(|a| a.len()).unwrap_or(0);
            if cur_ev_map != gold_ev_map {
                failures.push(format!(
                    "{}: starkinfo.evMap.len drift cur={} gold={}. A patch \
                     that restores qDeg and the ImPol/Q shape but leaves \
                     evMap off golden size would leave the verifier artifact \
                     wrong; this assertion prevents that.",
                    name, cur_ev_map, gold_ev_map
                ));
            }

            let vi_path = build_airs.join(name).join("air").join(format!("{}.verifierinfo.json", name));
            let gold_vi_path = gold_airs.join(name).join("air").join(format!("{}.verifierinfo.json", name));
            if !vi_path.is_file() || !gold_vi_path.is_file() {
                failures.push(format!(
                    "{}: verifierinfo.json missing (cur={} gold={})",
                    name, vi_path.display(), gold_vi_path.display()
                ));
                continue;
            }
            let cur_vi: serde_json::Value =
                serde_json::from_str(&std::fs::read_to_string(&vi_path).unwrap()).unwrap();
            let gold_vi: serde_json::Value =
                serde_json::from_str(&std::fs::read_to_string(&gold_vi_path).unwrap()).unwrap();

            let cur_qv = cur_vi.pointer("/qVerifier/code").and_then(|v| v.as_array()).map(|a| a.len()).unwrap_or(0);
            let gold_qv = gold_vi.pointer("/qVerifier/code").and_then(|v| v.as_array()).map(|a| a.len()).unwrap_or(0);
            if cur_qv != gold_qv {
                failures.push(format!(
                    "{}: verifierinfo.qVerifier.code.len drift cur={} \
                     gold={}. This is the recursive1 VerifyEvaluations0 \
                     assertion that fails at make prove.",
                    name, cur_qv, gold_qv
                ));
            }

            let cur_query = cur_vi.pointer("/queryVerifier/code").and_then(|v| v.as_array()).map(|a| a.len()).unwrap_or(0);
            let gold_query = gold_vi.pointer("/queryVerifier/code").and_then(|v| v.as_array()).map(|a| a.len()).unwrap_or(0);
            if cur_query != gold_query {
                failures.push(format!(
                    "{}: verifierinfo.queryVerifier.code.len drift cur={} \
                     gold={}. Query verifier code must match golden to keep \
                     recursive1 verifier in sync.",
                    name, cur_query, gold_query
                ));
            }
        }

        assert!(
            failures.is_empty(),
            "Round 16 three-AIR drift regression FAILED on current \
             build/provingKey. This test must pass before `make prove` \
             can exit 0 on HEAD.\n{}",
            failures.join("\n"),
        );
    }

    fn count_stage_impol(info: &serde_json::Value, stage: i64) -> usize {
        info.get("cmPolsMap")
            .and_then(|v| v.as_array())
            .map(|arr| {
                arr.iter()
                    .filter(|p| {
                        p.get("stage").and_then(|s| s.as_i64()) == Some(stage)
                            && p.get("imPol").and_then(|b| b.as_bool()) == Some(true)
                    })
                    .count()
            })
            .unwrap_or(0)
    }

    fn stage_pol_names(info: &serde_json::Value, stage: i64) -> Vec<String> {
        info.get("cmPolsMap")
            .and_then(|v| v.as_array())
            .map(|arr| {
                let mut names: Vec<String> = arr
                    .iter()
                    .filter(|p| p.get("stage").and_then(|s| s.as_i64()) == Some(stage))
                    .filter_map(|p| {
                        p.get("name").and_then(|n| n.as_str()).map(|s| s.to_string())
                    })
                    .collect();
                names.sort();
                names
            })
            .unwrap_or_default()
    }
}

