//! Port of `generateCompressedFinalSetup.js`: generate the vadcop_final_compressed
//! circuit, compile it, and produce the proving key artifacts.
//!
//! The compressed final setup:
//! 1. Generates a verifier circom for vadcop_final using pil2circom
//! 2. Generates the compressed final circom via gencircom
//! 3. Compiles circom to R1CS + C++
//! 4. Converts R1CS to PIL (plonk2pil with "aggregation")
//! 5. Compiles PIL
//! 6. Runs starkSetup with specific compressed final settings
//! 7. Computes constant tree
//! 8. Writes verifier.rs for the compressed final circuit

use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{bail, Context, Result};
use serde_json::Value;

use pilout::pilout_proxy::PilOutProxy;
use stark_recurser_rust::gencircom::{gen_circom, GenCircomInput, GenCircomOptions};
use stark_recurser_rust::pil2circom::{pil2circom, Pil2CircomOptions};
use stark_recurser_rust::plonk2pil::{self, PlonkResult};
use stark_recurser_rust::plonk2pil::setup_common::PlonkOptions;

use crate::bctree;
use crate::fixed_cols;
use crate::recursive_setup::compile_pil;
use crate::witness_gen::WitnessTracker;

/// Configuration for the compressed final setup.
pub struct CompressedFinalConfig<'a> {
    pub build_dir: &'a str,
    pub name: &'a str,
    pub const_root: &'a [String; 4],
    pub verification_keys: &'a [Vec<Vec<String>>],
    pub stark_info: &'a Value,
    pub verifier_info: &'a Value,

    // Tool paths
    pub circom_exec: &'a str,
    pub circuits_gl_path: &'a str,
    pub recurser_circuits_path: &'a str,
    pub std_pil_path: &'a str,
    pub recurser_pil_path: &'a str,
    pub circom_helpers_dir: &'a str,
}

/// Run the compressed final setup.
///
/// Ports `genCompressedFinalSetup()` from `generateCompressedFinalSetup.js`.
pub fn gen_compressed_final_setup(
    config: &CompressedFinalConfig<'_>,
    witness_tracker: &WitnessTracker,
) -> Result<()> {
    let template = "vadcop_final_compressed";
    let verifier_name = "vadcop_final.verifier.circom";
    let build_dir = PathBuf::from(config.build_dir);

    let files_dir = build_dir
        .join("provingKey")
        .join(config.name)
        .join(template);
    fs::create_dir_all(&files_dir)?;

    let circom_dir = build_dir.join("circom");
    let build_path = build_dir.join("build");
    let pil_dir = build_dir.join("pil");
    fs::create_dir_all(&circom_dir)?;
    fs::create_dir_all(&build_path)?;
    fs::create_dir_all(&pil_dir)?;

    // Generate verifier circom for vadcop_final
    let pil2circom_opts = Pil2CircomOptions {
        skip_main: true,
        verkey_input: false,
        enable_input: false,
        ..Default::default()
    };

    let verifier_circom =
        pil2circom(config.const_root, config.stark_info, config.verifier_info, &pil2circom_opts)
            .context("pil2circom failed in compressed final setup")?;

    fs::write(circom_dir.join(verifier_name), &verifier_circom)?;

    // Generate compressed final circom
    let verifier_filenames = vec![verifier_name.to_string()];
    let gen_circom_opts = GenCircomOptions {
        has_recursion: false,
        ..Default::default()
    };

    let gen_input = GenCircomInput {
        template_name: "vadcop/final_compressed.circom.tera",
        stark_infos: std::slice::from_ref(config.stark_info),
        vadcop_info: &serde_json::json!(null),
        verifier_filenames: &verifier_filenames,
        basic_verification_keys: config.verification_keys,
        agg_verification_keys: &[],
        publics: &[],
        options: &gen_circom_opts,
    };

    let compressed_circom =
        gen_circom(&gen_input).context("gen_circom failed in compressed final setup")?;

    let circom_out = circom_dir.join(format!("{}.circom", template));
    fs::write(&circom_out, &compressed_circom)?;

    // Compile circom
    // Note: uses recursion/helpers/circuits path instead of vadcop/helpers/circuits
    tracing::info!("Compiling {}...", template);
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
        .arg(circom_out.to_str().unwrap())
        .arg("-o")
        .arg(build_path.to_str().unwrap())
        .output()
        .context("Failed to execute circom for compressed final setup")?;

    if !compile_output.status.success() {
        let stderr = String::from_utf8_lossy(&compile_output.stderr);
        bail!(
            "Circom compilation failed for {}: {}",
            template,
            stderr
        );
    }

    // Copy .dat file
    tracing::info!("Copying circom files...");
    let dat_src = build_path
        .join(format!("{}_cpp", template))
        .join(format!("{}.dat", template));
    let dat_dst = files_dir.join(format!("{}.dat", template));
    if dat_src.exists() {
        fs::copy(&dat_src, &dat_dst)?;
    }

    // Generate witness library
    witness_tracker.run_witness_library_generation(
        config.build_dir,
        files_dir.to_str().unwrap_or(""),
        template,
        template,
        config.circom_helpers_dir,
    );

    // plonk2pil
    let r1cs_path = build_path.join(format!("{}.r1cs", template));
    let r1cs_data = fs::read(&r1cs_path)
        .with_context(|| format!("Failed to read R1CS: {}", r1cs_path.display()))?;

    let plonk_opts = PlonkOptions::default();
    let plonk_result: PlonkResult =
        plonk2pil::plonk2pil(&r1cs_data, "aggregation", &plonk_opts)
            .context("plonk2pil failed in compressed final setup")?;

    // Write fixed pols binary
    let fixed_bin_path = build_path.join(format!("{}.fixed.bin", template));
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
    let pil_path = pil_dir.join(format!("{}.pil", template));
    fs::write(&pil_path, &plonk_result.pil_str)?;

    // Compile PIL
    let pilout_path = build_path.join(format!("{}.pilout", template));
    compile_pil(
        pil_path.to_str().unwrap(),
        pilout_path.to_str().unwrap(),
        config.std_pil_path,
        config.recurser_pil_path,
    )?;

    // Write exec
    let exec_path = files_dir.join(format!("{}.exec", template));
    let exec_bytes: Vec<u8> = plonk_result
        .exec
        .iter()
        .flat_map(|v| v.to_le_bytes())
        .collect();
    fs::write(&exec_path, &exec_bytes)?;

    // Write const file
    let const_path = files_dir.join(format!("{}.const", template));
    let n_rows = 1usize << plonk_result.n_bits;
    let n_fixed = plonk_result.fixed_pols.len();
    let mut flat_buffer = vec![0u64; n_rows * n_fixed];
    for (col_idx, fp) in plonk_result.fixed_pols.iter().enumerate() {
        for (row, &val) in fp.values.iter().enumerate() {
            if row < n_rows {
                flat_buffer[row * n_fixed + col_idx] = val;
            }
        }
    }
    fixed_cols::write_fixed_cols_raw(const_path.to_str().unwrap(), &flat_buffer)?;

    // Compressed final stark struct settings
    let compressed_settings = crate::stark_struct::StarkSettings {
        blowup_factor: Some(4),
        folding_factor: Some(3),
        pow_bits: Some(22),
        merkle_tree_arity: Some(2),
        last_level_verification: Some(6),
        final_degree: Some(10),
        ..Default::default()
    };
    let compressed_stark_struct =
        crate::stark_struct::generate_stark_struct(&compressed_settings, plonk_result.n_bits);

    // Run real starkSetup via pil_info on the compiled compressed final pilout
    let starkinfo_path = files_dir.join(format!("{}.starkinfo.json", template));

    let pilout_file_str = pilout_path.to_str().unwrap_or("");
    if !Path::new(pilout_file_str).exists() {
        bail!("Compressed final pilout not found at {}", pilout_file_str);
    }

    let proxy = PilOutProxy::new(pilout_file_str).map_err(|e| anyhow::anyhow!("Failed to load pilout: {}", e))?;
    let pilout = &proxy.pilout;
    if pilout.air_groups.is_empty() || pilout.air_groups[0].airs.is_empty() {
        bail!("Compressed final pilout has no AIR groups");
    }

    let pil_info_result = crate::pil_info::pil_info(
        &pilout, 0, 0, &compressed_stark_struct, &Default::default(),
    );

    // Build JSON representations using the same helpers as the non-recursive path
    let opening_points = crate::setup_cmd::collect_opening_points(&pil_info_result.setup);
    let folding_factors = crate::setup_cmd::compute_folding_factors(&compressed_stark_struct);
    let ev_map_len = pil_info_result.pil_code.verifier_info.q_verifier.code.len();
    let field_size = crate::security::goldilocks_cube_field_size();
    let fri_params = crate::security::FRISecurityParams {
        field_size,
        dimension: 1u64 << compressed_stark_struct.n_bits,
        rate: 1.0 / (1u64 << (compressed_stark_struct.n_bits_ext - compressed_stark_struct.n_bits)) as f64,
        n_opening_points: opening_points.len() as u64,
        n_functions: ev_map_len.max(1) as u64,
        folding_factors: folding_factors.clone(),
        max_grinding_bits: compressed_stark_struct.pow_bits as u64,
        use_max_grinding_bits: true,
        tree_arity: compressed_stark_struct.merkle_tree_arity as u64,
        target_security_bits: 128,
    };
    let fri_security = crate::security::get_optimal_fri_query_params("JBR", &fri_params);

    let starkinfo_output = crate::setup_cmd::build_starkinfo_output(
        &pil_info_result.setup, &compressed_stark_struct, &pil_info_result.pil_code,
        &opening_points, &fri_security, 0, 0,
    );
    let verifier_info_json = crate::setup_cmd::build_verifier_info_json(&pil_info_result.pil_code.verifier_info);
    let expressions_info_json = crate::setup_cmd::build_expressions_info_json(&pil_info_result.pil_code.expressions_info);

    fs::write(&starkinfo_path, crate::json_output::to_json_string(&starkinfo_output)?)?;
    fs::write(
        files_dir.join(format!("{}.verifierinfo.json", template)),
        crate::json_output::to_json_string(&verifier_info_json)?,
    )?;
    fs::write(
        files_dir.join(format!("{}.expressionsinfo.json", template)),
        crate::json_output::to_json_string(&expressions_info_json)?,
    )?;

    // Write binary files
    {
        let si_val: serde_json::Value = serde_json::from_str(&fs::read_to_string(&starkinfo_path)?)?;
        let si_loaded = crate::stark_info::StarkInfo::from_json(&si_val)?;

        let expr_val: serde_json::Value = serde_json::from_str(
            &fs::read_to_string(files_dir.join(format!("{}.expressionsinfo.json", template)))?
        )?;
        let expr_loaded = crate::stark_info::ExpressionsInfo::from_json(&expr_val)?;
        crate::bin_file::write_expressions_bin_file(
            files_dir.join(format!("{}.bin", template)).to_str().unwrap(),
            &si_loaded, &expr_loaded,
        )?;

        let ver_val: serde_json::Value = serde_json::from_str(
            &fs::read_to_string(files_dir.join(format!("{}.verifierinfo.json", template)))?
        )?;
        let ver_loaded = crate::stark_info::VerifierInfo::from_json(&ver_val)?;
        crate::bin_file::write_verifier_expressions_bin_file(
            files_dir.join(format!("{}.verifier.bin", template)).to_str().unwrap(),
            &si_loaded, &ver_loaded,
        )?;
    }

    // Compute constant tree
    tracing::info!("Computing Constant Tree for {}...", template);
    let verkey_json_path = files_dir.join(format!("{}.verkey.json", template));
    if const_path.exists() {
        let root = bctree::compute_const_tree(
            const_path.to_str().unwrap(),
            starkinfo_path.to_str().unwrap(),
            verkey_json_path.to_str().unwrap(),
        )?;

        let mut verkey_bin = Vec::with_capacity(32);
        for &val in root.iter() {
            verkey_bin.extend_from_slice(&val.to_le_bytes());
        }
        fs::write(
            files_dir.join(format!("{}.verkey.bin", template)),
            &verkey_bin,
        )?;
    } else {
        tracing::warn!("Skipping const tree for {}: const file not found", template);
    }

    // Write verifier.rs
    tracing::info!(
        "Compressed final verifier.rs generation pending full starkSetup integration"
    );

    // Wait for witness library
    witness_tracker.await_all()?;

    Ok(())
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_compressed_final_types() {
        let si = serde_json::json!({"starkStruct": {"nBits": 17}});
        let vi = serde_json::json!({"qVerifier": {}, "queryVerifier": {}});
        let root = ["0".to_string(), "0".to_string(), "0".to_string(), "0".to_string()];

        let _config = super::CompressedFinalConfig {
            build_dir: "/tmp/test",
            name: "test_pilout",
            const_root: &root,
            verification_keys: &[],
            stark_info: &si,
            verifier_info: &vi,
            circom_exec: "circom",
            circuits_gl_path: "/tmp",
            recurser_circuits_path: "/tmp",
            std_pil_path: "/tmp",
            recurser_pil_path: "/tmp",
            circom_helpers_dir: "/tmp",
        };
    }
}
