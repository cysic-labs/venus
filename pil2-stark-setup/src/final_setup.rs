//! Port of `generateFinalSetup.js`: generate the vadcop_final circuit,
//! compile it, and produce the proving key artifacts.
//!
//! The final setup:
//! 1. Reads all recursive2 starkInfo/verifierInfo/vks for each airgroup
//! 2. Generates the final circom via gencircom with the "final" template
//! 3. Compiles circom to R1CS + C++
//! 4. Converts R1CS to PIL (plonk2pil with "final_vadcop")
//! 5. Compiles PIL
//! 6. Runs starkSetup with specific final settings
//! 7. Computes constant tree and writes all artifacts
//! 8. Writes verifier.rs for the final circuit

use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{bail, Context, Result};
use serde_json::Value;

use pilout::pilout_proxy::PilOutProxy;
use stark_recurser_rust::gencircom::{gen_circom, GenCircomInput, GenCircomOptions};
use stark_recurser_rust::plonk2pil::{self, PlonkResult};
use stark_recurser_rust::plonk2pil::setup_common::PlonkOptions;

use crate::bctree;
use crate::fixed_cols;
use crate::recursive_setup::compile_pil;
use crate::witness_gen::WitnessTracker;

/// Configuration for the final setup.
pub struct FinalSetupConfig<'a> {
    pub build_dir: &'a str,
    pub global_info: &'a Value,
    pub global_constraints: &'a Value,

    // Tool paths
    pub circom_exec: &'a str,
    pub circuits_gl_path: &'a str,
    pub recurser_circuits_path: &'a str,
    pub std_pil_path: &'a str,
    pub recurser_pil_path: &'a str,
    pub circom_helpers_dir: &'a str,
}

/// Result of the final setup.
pub struct FinalSetupResult {
    pub stark_info: Value,
    pub verifier_info: Value,
    pub const_root: [u64; 4],
}

/// Run the final setup.
///
/// Ports `genFinalSetup()` from `generateFinalSetup.js`.
pub fn gen_final_setup(
    config: &FinalSetupConfig<'_>,
    witness_tracker: &WitnessTracker,
) -> Result<FinalSetupResult> {
    let build_dir = PathBuf::from(config.build_dir);
    let global_name = config
        .global_info
        .get("name")
        .and_then(|v| v.as_str())
        .unwrap_or("pilout");

    let agg_types = config
        .global_info
        .get("aggTypes")
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0);

    let air_groups: Vec<String> = config
        .global_info
        .get("air_groups")
        .and_then(|v| v.as_array())
        .map(|a| {
            a.iter()
                .map(|v| v.as_str().unwrap_or("unnamed").to_string())
                .collect()
        })
        .unwrap_or_default();

    let mut stark_infos = Vec::new();
    let mut verifier_infos = Vec::new();
    let mut agg_keys_recursive2 = Vec::new();
    let mut basic_keys_recursive1 = Vec::new();
    let mut verifier_names = Vec::new();

    // Read recursive2 artifacts for each airgroup
    for (i, ag_name) in air_groups.iter().enumerate() {
        let r2_dir = build_dir
            .join("provingKey")
            .join(global_name)
            .join(ag_name)
            .join("recursive2");

        let si_path = r2_dir.join("recursive2.starkinfo.json");
        let vi_path = r2_dir.join("recursive2.verifierinfo.json");
        let vks_path = r2_dir.join("recursive2.vks.json");

        if si_path.exists() && vi_path.exists() && vks_path.exists() {
            let si: Value = serde_json::from_str(&fs::read_to_string(&si_path)?)?;
            let vi: Value = serde_json::from_str(&fs::read_to_string(&vi_path)?)?;
            let vks: Value = serde_json::from_str(&fs::read_to_string(&vks_path)?)?;

            stark_infos.push(si);
            verifier_infos.push(vi);

            if let Some(root) = vks.get("rootCRecursive2") {
                agg_keys_recursive2.push(
                    root.as_array()
                        .map(|a| {
                            a.iter()
                                .map(|v| v.as_str().unwrap_or("0").to_string())
                                .collect::<Vec<_>>()
                        })
                        .unwrap_or_default(),
                );
            } else {
                agg_keys_recursive2.push(vec![]);
            }

            if let Some(keys) = vks.get("rootCRecursives1") {
                basic_keys_recursive1.push(
                    keys.as_array()
                        .map(|a| {
                            a.iter()
                                .map(|v| {
                                    v.as_array()
                                        .map(|inner| {
                                            inner
                                                .iter()
                                                .map(|x| x.as_str().unwrap_or("0").to_string())
                                                .collect::<Vec<_>>()
                                        })
                                        .unwrap_or_default()
                                })
                                .collect::<Vec<_>>()
                        })
                        .unwrap_or_default(),
                );
            } else {
                basic_keys_recursive1.push(vec![]);
            }
        } else {
            bail!(
                "Recursive2 artifacts not found for airgroup '{}'. \
                 Run recursive setup first.",
                ag_name
            );
        }

        verifier_names.push(format!("{}_recursive2.verifier.circom", ag_name));
    }

    let files_dir = build_dir
        .join("provingKey")
        .join(global_name)
        .join("vadcop_final");
    fs::create_dir_all(&files_dir)?;

    let circom_dir = build_dir.join("circom");
    let build_path = build_dir.join("build");
    let pil_dir = build_dir.join("pil");
    fs::create_dir_all(&circom_dir)?;
    fs::create_dir_all(&build_path)?;
    fs::create_dir_all(&pil_dir)?;

    // Build global info with constraints for the template
    let mut final_global_info = config.global_info.clone();
    if let Some(constraints) = config.global_constraints.get("constraints") {
        final_global_info
            .as_object_mut()
            .map(|obj| obj.insert("globalConstraints".to_string(), constraints.clone()));
    }

    // Generate final circom
    let gen_circom_opts = GenCircomOptions {
        is_final: true,
        ..Default::default()
    };

    let gen_input = GenCircomInput {
        template_name: "vadcop/final.circom.tera",
        stark_infos: &stark_infos,
        vadcop_info: &final_global_info,
        verifier_filenames: &verifier_names,
        basic_verification_keys: &basic_keys_recursive1,
        agg_verification_keys: &agg_keys_recursive2,
        publics: &[],
        options: &gen_circom_opts,
    };

    let final_circom = gen_circom(&gen_input).context("gen_circom failed in final setup")?;

    let final_circom_path = circom_dir.join("vadcop_final.circom");
    fs::write(&final_circom_path, &final_circom)?;

    // Compile circom
    tracing::info!("Compiling vadcop_final...");
    let compile_output = std::process::Command::new(config.circom_exec)
        .args([
            "--O1",
            "--r1cs",
            "--prime",
            "goldilocks",
            "--c",
            "--verbose",
            "-l",
            config.recurser_circuits_path,
            "-l",
            config.circuits_gl_path,
        ])
        .arg(final_circom_path.to_str().unwrap())
        .arg("-o")
        .arg(build_path.to_str().unwrap())
        .output()
        .context("Failed to execute circom for final setup")?;

    if !compile_output.status.success() {
        let stderr = String::from_utf8_lossy(&compile_output.stderr);
        bail!("Circom compilation failed for vadcop_final: {}", stderr);
    }

    // Copy .dat file
    tracing::info!("Copying circom files...");
    let dat_src = build_path
        .join("vadcop_final_cpp")
        .join("vadcop_final.dat");
    let dat_dst = files_dir.join("vadcop_final.dat");
    if dat_src.exists() {
        fs::copy(&dat_src, &dat_dst)?;
    }

    // Generate witness library
    witness_tracker.run_witness_library_generation(
        config.build_dir,
        files_dir.to_str().unwrap_or(""),
        "vadcop_final",
        "vadcop_final",
        config.circom_helpers_dir,
    );

    // plonk2pil
    let r1cs_path = build_path.join("vadcop_final.r1cs");
    let r1cs_data = fs::read(&r1cs_path)
        .with_context(|| format!("Failed to read R1CS: {}", r1cs_path.display()))?;

    let plonk_opts = PlonkOptions::default();
    let plonk_result: PlonkResult =
        plonk2pil::plonk2pil(&r1cs_data, "final_vadcop", &plonk_opts)
            .context("plonk2pil failed in final setup")?;

    // Write fixed pols binary
    let fixed_bin_path = build_path.join("vadcop_final.fixed.bin");
    let fixed_info: Vec<(String, Vec<u32>, Vec<u64>)> = plonk_result
        .fixed_pols
        .iter()
        .map(|fp| (fp.name.clone(), vec![fp.index as u32], fp.values.clone()))
        .collect();
    fixed_cols::write_fixed_pols_bin(
        fixed_bin_path.to_str().unwrap(),
        &plonk_result.airgroup_name,
        &plonk_result.air_name,
        1u64 << plonk_result.n_bits,
        &fixed_info,
    )?;

    // Write PIL
    let pil_path = pil_dir.join("vadcop_final.pil");
    fs::write(&pil_path, &plonk_result.pil_str)?;

    // Compile PIL
    let pilout_path = build_path.join("vadcop_final.pilout");
    compile_pil(
        pil_path.to_str().unwrap(),
        pilout_path.to_str().unwrap(),
        config.std_pil_path,
        config.recurser_pil_path,
    )?;

    // Write exec
    let exec_path = files_dir.join("vadcop_final.exec");
    let exec_bytes: Vec<u8> = plonk_result
        .exec
        .iter()
        .flat_map(|v| v.to_le_bytes())
        .collect();
    fs::write(&exec_path, &exec_bytes)?;

    // Const file writing is deferred until after pil_info, which determines
    // the true nConstants (may be larger than plonk2pil's fixedPols count).
    let const_path = files_dir.join("vadcop_final.const");
    let plonk_n_rows = 1usize << plonk_result.n_bits;
    let plonk_n_fixed = plonk_result.fixed_pols.len();

    // Final stark struct settings
    let final_settings = crate::stark_struct::StarkSettings {
        blowup_factor: Some(5),
        folding_factor: Some(4),
        pow_bits: Some(22),
        last_level_verification: Some(2),
        ..Default::default()
    };
    let final_stark_struct =
        crate::stark_struct::generate_stark_struct(&final_settings, plonk_result.n_bits);

    // Run real starkSetup via pil_info on the compiled vadcop_final pilout
    let starkinfo_path = files_dir.join("vadcop_final.starkinfo.json");

    let pilout_file_str = pilout_path.to_str().unwrap_or("");
    if !Path::new(pilout_file_str).exists() {
        bail!("vadcop_final pilout not found at {}", pilout_file_str);
    }

    let proxy = PilOutProxy::new(pilout_file_str).map_err(|e| anyhow::anyhow!("Failed to load pilout: {}", e))?;
    let pilout = &proxy.pilout;
    if pilout.air_groups.is_empty() || pilout.air_groups[0].airs.is_empty() {
        bail!("vadcop_final pilout has no AIR groups");
    }

    let pil_info_result = crate::pil_info::pil_info(
        &pilout, 0, 0, &final_stark_struct, &Default::default(),
    );

    // Build JSON representations using the same helpers as the non-recursive path
    let opening_points = crate::setup_cmd::collect_opening_points(&pil_info_result.setup);
    let folding_factors = crate::setup_cmd::compute_folding_factors(&final_stark_struct);
    let ev_map_len = pil_info_result.pil_code.verifier_info.q_verifier.code.len();
    let field_size = crate::security::goldilocks_cube_field_size();
    let fri_params = crate::security::FRISecurityParams {
        field_size,
        dimension: 1u64 << final_stark_struct.n_bits,
        rate: 1.0 / (1u64 << (final_stark_struct.n_bits_ext - final_stark_struct.n_bits)) as f64,
        n_opening_points: opening_points.len() as u64,
        n_functions: ev_map_len.max(1) as u64,
        folding_factors: folding_factors.clone(),
        max_grinding_bits: final_stark_struct.pow_bits as u64,
        use_max_grinding_bits: true,
        tree_arity: final_stark_struct.merkle_tree_arity as u64,
        target_security_bits: 128,
    };
    let fri_security = crate::security::get_optimal_fri_query_params("JBR", &fri_params);

    let starkinfo_output = crate::setup_cmd::build_starkinfo_output(
        &pil_info_result.setup, &final_stark_struct, &pil_info_result.pil_code,
        &opening_points, &fri_security, 0, 0,
        "vadcop_final",
        pil_info_result.c_exp_id,
        pil_info_result.fri_exp_id,
        pil_info_result.q_deg,
    );
    let verifier_info_json = crate::setup_cmd::build_verifier_info_json(&pil_info_result.pil_code.verifier_info);
    let expressions_info_json = crate::setup_cmd::build_expressions_info_json(&pil_info_result.pil_code.expressions_info);

    // Write all JSON files
    fs::write(&starkinfo_path, crate::json_output::to_json_string(&starkinfo_output)?)?;
    fs::write(
        files_dir.join("vadcop_final.expressionsinfo.json"),
        crate::json_output::to_json_string(&expressions_info_json)?,
    )?;
    fs::write(
        files_dir.join("vadcop_final.verifierinfo.json"),
        crate::json_output::to_json_string(&verifier_info_json)?,
    )?;

    // Write binary files using native Rust writer
    {
        let si_val: serde_json::Value = serde_json::from_str(&fs::read_to_string(&starkinfo_path)?)?;
        let stark_info_loaded = crate::stark_info::StarkInfo::from_json(&si_val)?;

        let expr_val: serde_json::Value = serde_json::from_str(
            &fs::read_to_string(files_dir.join("vadcop_final.expressionsinfo.json"))?
        )?;
        let expressions_loaded = crate::stark_info::ExpressionsInfo::from_json(&expr_val)?;
        crate::bin_file::write_expressions_bin_file(
            files_dir.join("vadcop_final.bin").to_str().unwrap(),
            &stark_info_loaded, &expressions_loaded,
        )?;

        let ver_val: serde_json::Value = serde_json::from_str(
            &fs::read_to_string(files_dir.join("vadcop_final.verifierinfo.json"))?
        )?;
        let verifier_loaded = crate::stark_info::VerifierInfo::from_json(&ver_val)?;
        crate::bin_file::write_verifier_expressions_bin_file(
            files_dir.join("vadcop_final.verifier.bin").to_str().unwrap(),
            &stark_info_loaded, &verifier_loaded,
        )?;

        // Write verifier Rust file
        crate::verifier_rs_gen::write_verifier_rust_file(
            files_dir.join("vadcop_final.verifier.rs").to_str().unwrap(),
            &stark_info_loaded,
            &verifier_loaded,
        )?;

        // Write const file with the correct number of columns from pil_info.
        // plonk2pil gives plonk_n_fixed columns, but the PIL defines
        // n_constants total. Extra columns are zero-filled.
        let n_constants = stark_info_loaded.n_constants as usize;
        {
            let n_rows = plonk_n_rows;
            let mut flat_buffer = vec![0u64; n_rows * n_constants];
            for (col_idx, fp) in plonk_result.fixed_pols.iter().enumerate() {
                if col_idx >= n_constants {
                    break;
                }
                for (row, &val) in fp.values.iter().enumerate() {
                    if row < n_rows {
                        flat_buffer[row * n_constants + col_idx] = val;
                    }
                }
            }
            fixed_cols::write_fixed_cols_raw(const_path.to_str().unwrap(), &flat_buffer)?;
            tracing::info!(
                "Wrote vadcop_final const file: {} cols ({} from plonk + {} zero-fill), {} rows",
                n_constants, plonk_n_fixed, n_constants.saturating_sub(plonk_n_fixed), n_rows
            );
        }
    }

    // Compute constant tree
    tracing::info!("Computing Constant Tree for vadcop_final...");
    let verkey_json_path = files_dir.join("vadcop_final.verkey.json");
    let const_root = if const_path.exists() {
        let root = bctree::compute_const_tree(
            const_path.to_str().unwrap(),
            starkinfo_path.to_str().unwrap(),
            verkey_json_path.to_str().unwrap(),
        )?;

        let mut verkey_bin = Vec::with_capacity(32);
        for &val in root.iter() {
            verkey_bin.extend_from_slice(&val.to_le_bytes());
        }
        fs::write(files_dir.join("vadcop_final.verkey.bin"), &verkey_bin)?;

        root
    } else {
        tracing::warn!("Skipping const tree for vadcop_final: const file not found");
        [0u64; 4]
    };

    // Write verifier.rs
    tracing::info!("Final setup verifier.rs generation pending full starkSetup integration");

    // Wait for witness library
    witness_tracker.await_all()?;

    let result_stark_info = serde_json::to_value(&starkinfo_output)?;
    let result_verifier_info = verifier_info_json;

    Ok(FinalSetupResult {
        stark_info: result_stark_info,
        verifier_info: result_verifier_info,
        const_root,
    })
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_final_setup_types() {
        // Basic type check: FinalSetupConfig can be constructed
        let gi = serde_json::json!({"name": "test", "air_groups": [], "aggTypes": []});
        let gc = serde_json::json!({"constraints": [], "hints": []});

        let _config = super::FinalSetupConfig {
            build_dir: "/tmp/test",
            global_info: &gi,
            global_constraints: &gc,
            circom_exec: "circom",
            circuits_gl_path: "/tmp",
            recurser_circuits_path: "/tmp",
            std_pil_path: "/tmp",
            recurser_pil_path: "/tmp",
            circom_helpers_dir: "/tmp",
        };
    }
}
