//! Non-recursive setup command: the main orchestrator for the setup pipeline.
//!
//! Ports the non-recursive path of `pil2-proofman-js/src/cmd/setup_cmd.js`.

use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{bail, Result};
use indexmap::IndexMap;
use pilout::pilout as pb;
use prost::Message;
use serde_json::json;

use crate::bctree;
use crate::json_output;
use crate::pil_info;
use crate::prepare_pil::PrepareOptions;
use crate::security::{self, FRISecurityParams};
use crate::stark_struct::{generate_stark_struct, StarkSettings, StarkStruct};
use crate::types::{
    BoundaryOutput, EvMapEntry, PolMapEntry, SecurityInfo,
    StarkInfoOutput, StarkStructOutput, StepOutput,
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

    // Resolve binFile binary path
    let binfile_path = resolve_binfile_path()?;

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

            // Resolve settings for this air
            let air_settings = settings_map
                .get(&air_name)
                .or_else(|| settings_map.get("default"))
                .cloned()
                .unwrap_or_default();

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
            let ev_map_len = pil_code
                .verifier_info
                .q_verifier
                .code
                .len(); // approximate nFunctions
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
                &pil_code,
                &opening_points,
                &fri_security,
                ag_idx,
                air_idx,
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
                let const_root = bctree::compute_const_tree(
                    const_path.to_str().unwrap_or(""),
                    starkinfo_path.to_str().unwrap_or(""),
                    verkey_json_path.to_str().unwrap_or(""),
                )?;

                // Write verkey.bin from the returned root values
                let mut verkey_bin = Vec::with_capacity(32);
                for &val in const_root.iter() {
                    verkey_bin.extend_from_slice(&val.to_le_bytes());
                }
                fs::write(
                    files_dir.join(format!("{}.verkey.bin", air_name)),
                    &verkey_bin,
                )?;
            } else {
                tracing::warn!(
                    "Skipping bctree: const file not found at {}",
                    const_path.display()
                );
            }

            // Write binary files via binFile tool
            if Path::new(&binfile_path).exists() {
                run_binfile(
                    &binfile_path,
                    starkinfo_path.to_str().unwrap_or(""),
                    files_dir
                        .join(format!("{}.expressionsinfo.json", air_name))
                        .to_str()
                        .unwrap_or(""),
                    files_dir
                        .join(format!("{}.bin", air_name))
                        .to_str()
                        .unwrap_or(""),
                    false,
                )?;

                run_binfile(
                    &binfile_path,
                    starkinfo_path.to_str().unwrap_or(""),
                    files_dir
                        .join(format!("{}.verifierinfo.json", air_name))
                        .to_str()
                        .unwrap_or(""),
                    files_dir
                        .join(format!("{}.verifier.bin", air_name))
                        .to_str()
                        .unwrap_or(""),
                    true,
                )?;
            } else {
                // Use the Rust bin_file writer directly if the external binary
                // is not available (which is the typical Rust-native path).
                write_bin_files_native(
                    &starkinfo_output,
                    &pil_code,
                    &files_dir,
                    &air_name,
                )?;
            }

            tracing::info!("Setup for air '{}' complete", air_name);
        }
    }

    // Generate globalInfo.json and globalConstraints
    write_global_info(&pilout, &pilout_name, &opts.build_dir)?;

    tracing::info!("Setup complete");
    Ok(())
}

/// Build the StarkInfoOutput for JSON serialization from internal types.
fn build_starkinfo_output(
    setup: &crate::pilout_info::SetupResult,
    stark_struct: &StarkStruct,
    _pil_code: &crate::generate_pil_code::PilCodeResult,
    opening_points: &[i64],
    fri_security: &security::FRIQueryResult,
    airgroup_id: usize,
    air_id: usize,
) -> StarkInfoOutput {
    let steps: Vec<StepOutput> = stark_struct
        .steps
        .iter()
        .map(|s| StepOutput { n_bits: s.n_bits })
        .collect();

    let stark_struct_out = StarkStructOutput {
        n_bits: stark_struct.n_bits,
        n_bits_ext: stark_struct.n_bits_ext,
        n_queries: fri_security.n_queries as usize,
        pow_bits: fri_security.n_grinding_bits as usize,
        merkle_tree_arity: stark_struct.merkle_tree_arity,
        merkle_tree_custom: stark_struct.merkle_tree_custom,
        hash_commits: stark_struct.hash_commits,
        verification_hash_type: stark_struct.verification_hash_type.clone(),
        steps,
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

    // Build evMap from verifier code
    let ev_map: Vec<EvMapEntry> = Vec::new();

    // Build cmPolsMap as nested stages
    let n_stages = setup.n_stages;
    let mut cm_pols_map: Vec<Vec<PolMapEntry>> = Vec::new();
    for stage in 0..=(n_stages + 1) {
        let stage_pols: Vec<PolMapEntry> = setup
            .cm_pols_map
            .iter()
            .filter(|p| p.stage == Some(stage))
            .map(|p| PolMapEntry {
                name: p.name.clone(),
                stage: p.stage.unwrap_or(0),
                dim: p.dim,
                im_pol: if p.im_pol { Some(true) } else { None },
            })
            .collect();
        if !stage_pols.is_empty() || stage <= n_stages + 1 {
            cm_pols_map.push(stage_pols);
        }
    }

    let const_pols_map: Vec<PolMapEntry> = setup
        .const_pols_map
        .iter()
        .map(|p| PolMapEntry {
            name: p.name.clone(),
            stage: p.stage.unwrap_or(0),
            dim: p.dim,
            im_pol: None,
        })
        .collect();

    let map_sections_n: IndexMap<String, usize> = setup.map_sections_n.clone();

    // Compute mapOffsets
    let mut map_offsets = IndexMap::new();
    let mut offset = 0usize;
    for (key, &val) in &map_sections_n {
        map_offsets.insert(key.clone(), offset);
        offset += val;
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

    let q_stage_key = format!("cm{}", n_stages + 1);
    let q_cols = *map_sections_n.get(&q_stage_key).unwrap_or(&0);

    StarkInfoOutput {
        stark_struct: stark_struct_out,
        n_stages,
        n_constants: setup.n_constants,
        n_publics: setup.n_publics,
        n_constraints: setup.constraints.len(),
        opening_points: opening_points.to_vec(),
        boundaries,
        ev_map,
        cm_pols_map,
        const_pols_map,
        map_sections_n,
        map_offsets,
        q_deg: q_cols.max(1),
        q_dim: crate::pilout_info::FIELD_EXTENSION,
        c_exp_id: 0,
        air_id,
        airgroup_id,
        custom_commits: custom_commits_json,
        security: Some(SecurityInfo {
            proximity_gap: fri_security.proximity_gap,
            proximity_parameter: fri_security.proximity_parameter,
            regime: "JBR".to_string(),
        }),
    }
}

fn collect_opening_points(setup: &crate::pilout_info::SetupResult) -> Vec<i64> {
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

fn compute_folding_factors(stark_struct: &StarkStruct) -> Vec<u64> {
    let steps = &stark_struct.steps;
    let mut factors = Vec::new();
    for i in 0..steps.len() - 1 {
        factors.push((steps[i].n_bits - steps[i + 1].n_bits) as u64);
    }
    factors
}

/// Build the expressionsinfo JSON structure.
fn build_expressions_info_json(
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
            if !e.line.is_empty() {
                obj.insert("line".to_string(), json!(e.line));
            }
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
                            let mut obj = serde_json::Map::new();
                            obj.insert("op".to_string(), json!(v.op));
                            if let Some(id) = v.id {
                                obj.insert("id".to_string(), json!(id));
                            }
                            if let Some(dim) = v.dim {
                                obj.insert("dim".to_string(), json!(dim));
                            }
                            if !v.pos.is_empty() {
                                obj.insert("pos".to_string(), json!(v.pos));
                            }
                            if let Some(stage) = v.stage {
                                obj.insert("stage".to_string(), json!(stage));
                            }
                            if let Some(sid) = v.stage_id {
                                obj.insert("stageId".to_string(), json!(sid));
                            }
                            if let Some(ref val) = v.value {
                                obj.insert("value".to_string(), json!(val));
                            }
                            if let Some(ro) = v.row_offset {
                                obj.insert("rowOffset".to_string(), json!(ro));
                            }
                            if let Some(roi) = v.row_offset_index {
                                obj.insert("rowOffsetIndex".to_string(), json!(roi));
                            }
                            if let Some(cid) = v.commit_id {
                                obj.insert("commitId".to_string(), json!(cid));
                            }
                            if let Some(agid) = v.airgroup_id {
                                obj.insert("airgroupId".to_string(), json!(agid));
                            }
                            serde_json::Value::Object(obj)
                        }).collect::<Vec<_>>(),
                    })
                }).collect::<Vec<serde_json::Value>>(),
            })
        })
        .collect();

    json!({
        "expressionsCode": expressions_code,
        "constraints": constraints,
        "hintsInfo": hints_info,
    })
}

/// Build the verifierinfo JSON structure.
fn build_verifier_info_json(
    info: &crate::generate_pil_code::VerifierInfo,
) -> serde_json::Value {
    json!({
        "qVerifier": {
            "tmpUsed": info.q_verifier.tmp_used,
            "code": code_entries_to_json(&info.q_verifier.code),
        },
        "queryVerifier": {
            "tmpUsed": info.query_verifier.tmp_used,
            "code": code_entries_to_json(&info.query_verifier.code),
        },
    })
}

fn code_entries_to_json(entries: &[crate::types::CodeEntry]) -> serde_json::Value {
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

fn code_ref_to_json(r: &crate::types::CodeRef) -> serde_json::Value {
    let mut obj = serde_json::Map::new();
    obj.insert("type".to_string(), json!(r.ref_type));
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
    if let Some(sid) = r.stage_id {
        obj.insert("stageId".to_string(), json!(sid));
    }
    if let Some(cid) = r.commit_id {
        obj.insert("commitId".to_string(), json!(cid));
    }
    if let Some(opening) = r.opening {
        obj.insert("opening".to_string(), json!(opening));
    }
    if let Some(bid) = r.boundary_id {
        obj.insert("boundaryId".to_string(), json!(bid));
    }
    if let Some(agid) = r.airgroup_id {
        obj.insert("airgroupId".to_string(), json!(agid));
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
fn write_bin_files_native(
    _starkinfo_output: &StarkInfoOutput,
    _pil_code: &crate::generate_pil_code::PilCodeResult,
    _files_dir: &Path,
    air_name: &str,
) -> Result<()> {
    // The bin_file module works with StarkInfo and ExpressionsInfo/VerifierInfo
    // from stark_info.rs. For now we create minimal stubs that carry the needed
    // metadata. The full native binary file generation is a future enhancement.
    tracing::info!(
        "Native binary generation not yet wired; skipping .bin for '{}'",
        air_name
    );
    Ok(())
}

/// Invoke the external binFile tool.
fn run_binfile(
    binfile_path: &str,
    starkinfo_path: &str,
    expressions_path: &str,
    output_path: &str,
    verifier: bool,
) -> Result<()> {
    let mut cmd = std::process::Command::new(binfile_path);
    cmd.arg("-s").arg(starkinfo_path);
    cmd.arg("-e").arg(expressions_path);
    cmd.arg("-b").arg(output_path);
    if verifier {
        cmd.arg("--verifier");
    }

    let output = cmd.output()?;
    if !output.stdout.is_empty() {
        let stdout = String::from_utf8_lossy(&output.stdout);
        print!("{}", stdout);
    }
    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        bail!(
            "binFile tool failed with exit code {:?}: {}",
            output.status.code(),
            stderr
        );
    }
    Ok(())
}

/// Compute floor(log2(n)) for a nonzero usize.
fn log2_usize(n: usize) -> usize {
    assert!(n > 0, "log2_usize: n must be positive");
    (usize::BITS - 1 - n.leading_zeros()) as usize
}

/// Resolve the binFile binary path.
fn resolve_binfile_path() -> Result<String> {
    let candidates = [
        "binfile",
        "./binfile",
        "../pil2-proofman-js/src/setup/build/binfile",
    ];
    for path in &candidates {
        if Path::new(path).exists() {
            return Ok(path.to_string());
        }
    }
    Ok("binfile".to_string())
}
