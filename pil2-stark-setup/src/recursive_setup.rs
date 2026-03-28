//! Port of `generateRecursiveSetup.js`: generate recursive verifier circuits,
//! compile them, and produce the proving key artifacts for recursive1,
//! recursive2, and compressor templates.
//!
//! The function drives:
//! 1. Circom verifier generation (pil2circom)
//! 2. Recursive circom generation (gencircom)
//! 3. Circom compilation to R1CS + C++
//! 4. R1CS-to-PIL conversion (plonk2pil)
//! 5. PIL compilation (pil2-compiler-rust)
//! 6. starkSetup (pil_info)
//! 7. Constant tree computation (bctree)
//! 8. Binary file generation

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
use crate::witness_gen::WitnessTracker;

/// Which recursive template to use.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RecursiveTemplate {
    Compressor,
    Recursive1,
    Recursive2,
}

impl RecursiveTemplate {
    pub fn as_str(&self) -> &'static str {
        match self {
            Self::Compressor => "compressor",
            Self::Recursive1 => "recursive1",
            Self::Recursive2 => "recursive2",
        }
    }

    pub fn tera_template(&self) -> &'static str {
        match self {
            Self::Compressor => "vadcop/compressor.circom.tera",
            Self::Recursive1 => "vadcop/recursive1.circom.tera",
            Self::Recursive2 => "vadcop/recursive2.circom.tera",
        }
    }
}

/// Configuration for the recursive setup.
pub struct RecursiveSetupConfig<'a> {
    pub build_dir: &'a str,
    pub template: RecursiveTemplate,
    pub airgroup_name: &'a str,
    pub airgroup_id: usize,
    pub air_id: usize,
    pub air_name: &'a str,
    pub global_info: &'a Value,
    pub const_root: &'a [String; 4],
    pub verification_keys: &'a [Vec<Vec<String>>],
    pub stark_info: &'a Value,
    pub verifier_info: &'a Value,
    pub stark_struct: Option<&'a Value>,
    pub has_compressor: bool,

    // Tool paths
    pub circom_exec: &'a str,
    pub circuits_gl_path: &'a str,
    pub recurser_circuits_path: &'a str,
    pub std_pil_path: &'a str,
    pub recurser_pil_path: &'a str,
    pub circom_helpers_dir: &'a str,
}

/// Result of a recursive setup step.
pub struct RecursiveSetupResult {
    /// The 4-element constant root.
    pub const_root: [u64; 4],
    /// Generated PIL source string.
    pub pil_str: String,
    /// The starkInfo JSON for this recursive circuit.
    pub stark_info: Option<Value>,
    /// The verifierInfo JSON for this recursive circuit.
    pub verifier_info: Option<Value>,
    /// The expressionsInfo JSON for this recursive circuit.
    pub expressions_info: Option<Value>,
}

/// Run the recursive setup for a single air/template combination.
///
/// Ports `genRecursiveSetup()` from `generateRecursiveSetup.js`.
pub fn gen_recursive_setup(
    config: &RecursiveSetupConfig<'_>,
    witness_tracker: &WitnessTracker,
) -> Result<RecursiveSetupResult> {
    let template = config.template;
    let template_str = template.as_str();

    // Determine naming and paths based on template
    let (verifier_name, name_filename, files_dir, input_challenges, verkey_input, enable_input) =
        resolve_names_and_paths(config)?;

    let airgroup_pil_name = match template {
        RecursiveTemplate::Compressor => {
            format!("{}_{}_{}",
                config.airgroup_name, config.air_name, template_str)
        }
        RecursiveTemplate::Recursive1 => {
            format!("{}_{}_{}",
                config.airgroup_name, config.air_name, template_str)
        }
        RecursiveTemplate::Recursive2 => "Recursive2".to_string(),
    };

    // Create directories
    let circom_dir = PathBuf::from(config.build_dir).join("circom");
    let build_dir_path = PathBuf::from(config.build_dir).join("build");
    let pil_dir = PathBuf::from(config.build_dir).join("pil");
    fs::create_dir_all(&circom_dir)?;
    fs::create_dir_all(&build_dir_path)?;
    fs::create_dir_all(&pil_dir)?;
    fs::create_dir_all(&files_dir)?;

    // Generate verifier circom
    let const_root_circuit: [String; 4] = if config.const_root.iter().all(|s| s.is_empty()) {
        ["0".to_string(), "0".to_string(), "0".to_string(), "0".to_string()]
    } else {
        config.const_root.clone()
    };

    let pil2circom_opts = Pil2CircomOptions {
        skip_main: true,
        verkey_input,
        input_challenges,
        enable_input,
        ..Default::default()
    };

    let verifier_circom = pil2circom(
        &const_root_circuit,
        config.stark_info,
        config.verifier_info,
        &pil2circom_opts,
    )
    .context("pil2circom failed in recursive setup")?;

    let verifier_path = circom_dir.join(&verifier_name);
    fs::write(&verifier_path, &verifier_circom)?;

    // Generate recursive circom
    let verifier_filenames = vec![verifier_name.clone()];
    let gen_circom_opts = GenCircomOptions {
        airgroup_id: Some(config.airgroup_id as u64),
        has_compressor: config.has_compressor,
        ..Default::default()
    };

    let gen_input = GenCircomInput {
        template_name: template.tera_template(),
        stark_infos: std::slice::from_ref(config.stark_info),
        vadcop_info: config.global_info,
        verifier_filenames: &verifier_filenames,
        basic_verification_keys: config.verification_keys,
        agg_verification_keys: &[],
        publics: &[],
        options: &gen_circom_opts,
    };

    let recursive_circom = gen_circom(&gen_input)
        .context("gen_circom failed in recursive setup")?;

    let circom_out_path = circom_dir.join(format!("{}.circom", name_filename));
    fs::write(&circom_out_path, &recursive_circom)?;

    // Compile circom
    tracing::info!("Compiling {}...", name_filename);
    let compile_status = std::process::Command::new(config.circom_exec)
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
        .arg(circom_out_path.to_str().unwrap())
        .arg("-o")
        .arg(build_dir_path.to_str().unwrap())
        .output()
        .context("Failed to execute circom compiler")?;

    if !compile_status.status.success() {
        let stderr = String::from_utf8_lossy(&compile_status.stderr);
        bail!("Circom compilation failed for {}: {}", name_filename, stderr);
    }

    // Copy .dat file
    tracing::info!("Copying circom files...");
    let dat_src = build_dir_path
        .join(format!("{}_cpp", name_filename))
        .join(format!("{}.dat", name_filename));
    let dat_dst = files_dir.join(format!("{}.dat", template_str));
    if dat_src.exists() {
        fs::copy(&dat_src, &dat_dst)?;
    }

    // Generate witness library (background)
    witness_tracker.run_witness_library_generation(
        config.build_dir,
        files_dir.to_str().unwrap_or(""),
        &name_filename,
        template_str,
        config.circom_helpers_dir,
    );

    // plonk2pil: convert R1CS to PIL
    let mut plonk_opts = PlonkOptions {
        airgroup_name: Some(airgroup_pil_name),
        max_constraint_degree: None,
    };
    if template == RecursiveTemplate::Compressor {
        plonk_opts.max_constraint_degree = Some(5);
    }

    let type_compressor = match template {
        RecursiveTemplate::Compressor => "compressor",
        _ => "aggregation",
    };

    let r1cs_path = build_dir_path.join(format!("{}.r1cs", name_filename));
    let r1cs_data = fs::read(&r1cs_path)
        .with_context(|| format!("Failed to read R1CS file: {}", r1cs_path.display()))?;

    let plonk_result: PlonkResult =
        plonk2pil::plonk2pil(&r1cs_data, type_compressor, &plonk_opts)
            .context("plonk2pil failed in recursive setup")?;

    // Write fixed polynomials binary
    let fixed_bin_path = build_dir_path.join(format!("{}.fixed.bin", name_filename));
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

    // Write PIL source
    let pil_path = pil_dir.join(format!("{}.pil", name_filename));
    fs::write(&pil_path, &plonk_result.pil_str)?;

    // Write exec buffer
    let exec_path = files_dir.join(format!("{}.exec", template_str));
    let exec_bytes: Vec<u8> = plonk_result
        .exec
        .iter()
        .flat_map(|v| v.to_le_bytes())
        .collect();
    fs::write(&exec_path, &exec_bytes)?;

    // Compile PIL (invoke pil2-compiler-rust as external command)
    let pilout_path = build_dir_path.join(format!("{}.pilout", name_filename));
    compile_pil(
        pil_path.to_str().unwrap(),
        pilout_path.to_str().unwrap(),
        config.std_pil_path,
        config.recurser_pil_path,
    )?;

    // Write fixed columns in .const format
    let const_path = files_dir.join(format!("{}.const", template_str));
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

    // Generate stark struct if not provided
    // For compressor template without a pre-existing starkStruct, use blowupFactor=2
    let need_setup = template != RecursiveTemplate::Recursive1;

    // Run real starkSetup via pil_info on the compiled pilout
    tracing::info!("Running starkSetup for recursive circuit...");
    let starkinfo_path = files_dir.join(format!("{}.starkinfo.json", template_str));

    // Load the compiled pilout and run the real pil_info pipeline
    let pilout_path_str = pilout_path.to_str().unwrap_or("");
    let (setup_stark_info, setup_verifier_info, setup_expressions_info) = if need_setup && Path::new(pilout_path_str).exists() {
        // Load pilout to get AIR structure
        let proxy = PilOutProxy::new(pilout_path_str).map_err(|e| anyhow::anyhow!("Failed to load pilout: {}", e))?;
        let pilout = &proxy.pilout;
        if pilout.air_groups.is_empty() || pilout.air_groups[0].airs.is_empty() {
            bail!("Compiled pilout has no AIR groups: {}", pilout_path_str);
        }
        let air = &pilout.air_groups[0].airs[0];
        let num_rows_air = air.num_rows.unwrap_or(0) as usize;
        let n_bits_air = if num_rows_air > 0 { (num_rows_air as f64).log2() as usize } else { plonk_result.n_bits };

        // Generate stark struct for this recursive circuit
        let stark_struct = if let Some(ss_val) = config.stark_struct {
            serde_json::from_value::<crate::stark_struct::StarkStruct>(ss_val.clone())
                .unwrap_or_else(|_| {
                    let blowup = if template == RecursiveTemplate::Compressor { 2 } else { 3 };
                    let settings = crate::stark_struct::StarkSettings {
                        blowup_factor: Some(blowup),
                        folding_factor: Some(3),
                        final_degree: Some(5),
                        ..Default::default()
                    };
                    crate::stark_struct::generate_stark_struct(&settings, n_bits_air)
                })
        } else {
            let blowup = if template == RecursiveTemplate::Compressor { 2 } else { 3 };
            let settings = crate::stark_struct::StarkSettings {
                blowup_factor: Some(blowup),
                folding_factor: Some(3),
                final_degree: Some(5),
                ..Default::default()
            };
            crate::stark_struct::generate_stark_struct(&settings, n_bits_air)
        };

        // Run pil_info to get real starkinfo/expressionsinfo/verifierinfo
        let pil_info_result = crate::pil_info::pil_info(
            &pilout, 0, 0, &stark_struct, &Default::default(),
        );

        // Build JSON representations using the same helpers as the non-recursive path
        let opening_points = crate::setup_cmd::collect_opening_points(&pil_info_result.setup);
        let folding_factors = crate::setup_cmd::compute_folding_factors(&stark_struct);
        let ev_map_len = pil_info_result.pil_code.verifier_info.q_verifier.code.len();
        let field_size = crate::security::goldilocks_cube_field_size();
        let fri_params = crate::security::FRISecurityParams {
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
        let fri_security = crate::security::get_optimal_fri_query_params("JBR", &fri_params);

        let starkinfo_output = crate::setup_cmd::build_starkinfo_output(
            &pil_info_result.setup, &stark_struct, &pil_info_result.pil_code,
            &opening_points, &fri_security, 0, 0,
        );
        let verifier_info_json = crate::setup_cmd::build_verifier_info_json(&pil_info_result.pil_code.verifier_info);
        let expressions_info_json = crate::setup_cmd::build_expressions_info_json(&pil_info_result.pil_code.expressions_info);
        let si_json = serde_json::to_value(&starkinfo_output)?;

        // Write all JSON files
        fs::write(&starkinfo_path, crate::json_output::to_json_string(&starkinfo_output)?)?;
        fs::write(
            files_dir.join(format!("{}.verifierinfo.json", template_str)),
            crate::json_output::to_json_string(&verifier_info_json)?,
        )?;
        fs::write(
            files_dir.join(format!("{}.expressionsinfo.json", template_str)),
            crate::json_output::to_json_string(&expressions_info_json)?,
        )?;

        // Write binary files using native Rust writer
        let si_val: serde_json::Value = serde_json::from_str(
            &fs::read_to_string(&starkinfo_path)?
        )?;
        let stark_info_loaded = crate::stark_info::StarkInfo::from_json(&si_val)?;

        let expr_val: serde_json::Value = serde_json::from_str(
            &fs::read_to_string(files_dir.join(format!("{}.expressionsinfo.json", template_str)))?
        )?;
        let expressions_loaded = crate::stark_info::ExpressionsInfo::from_json(&expr_val)?;
        crate::bin_file::write_expressions_bin_file(
            files_dir.join(format!("{}.bin", template_str)).to_str().unwrap(),
            &stark_info_loaded, &expressions_loaded,
        )?;

        let ver_val: serde_json::Value = serde_json::from_str(
            &fs::read_to_string(files_dir.join(format!("{}.verifierinfo.json", template_str)))?
        )?;
        let verifier_loaded = crate::stark_info::VerifierInfo::from_json(&ver_val)?;
        crate::bin_file::write_verifier_expressions_bin_file(
            files_dir.join(format!("{}.verifier.bin", template_str)).to_str().unwrap(),
            &stark_info_loaded, &verifier_loaded,
        )?;

        (Some(si_json), Some(verifier_info_json), Some(expressions_info_json))
    } else if need_setup {
        bail!("Pilout not found at {}. Cannot run starkSetup for recursive circuit.", pilout_path_str);
    } else {
        (None, None, None)
    };

    // Compute const tree and verkey
    let verkey_json_path = files_dir.join(format!("{}.verkey.json", template_str));
    let const_root = if const_path.exists() && starkinfo_path.exists() {
        let root = bctree::compute_const_tree(
            const_path.to_str().unwrap(),
            starkinfo_path.to_str().unwrap(),
            verkey_json_path.to_str().unwrap(),
        )?;

        // Write verkey.bin
        let mut verkey_bin = Vec::with_capacity(32);
        for &val in root.iter() {
            verkey_bin.extend_from_slice(&val.to_le_bytes());
        }
        fs::write(
            files_dir.join(format!("{}.verkey.bin", template_str)),
            &verkey_bin,
        )?;

        root
    } else {
        tracing::warn!(
            "Skipping const tree: const={} starkinfo={}",
            const_path.display(),
            starkinfo_path.display()
        );
        [0u64; 4]
    };

    // JSON files already written by the real pil_info pipeline above

    // For recursive2, write vks.json and verifier.rs
    if template == RecursiveTemplate::Recursive2 {
        let vks = serde_json::json!({
            "rootCRecursives1": config.verification_keys,
            "rootCRecursive2": const_root.iter().map(|v| v.to_string()).collect::<Vec<_>>(),
        });
        fs::write(
            files_dir.join(format!("{}.vks.json", template_str)),
            serde_json::to_string_pretty(&vks)?,
        )?;

        // Write verifier Rust file using the real starkinfo and verifierinfo
        if let (Some(ref si_val), Some(ref vi_val)) = (&setup_stark_info, &setup_verifier_info) {
            let si_loaded = crate::stark_info::StarkInfo::from_json(si_val)?;
            let vi_loaded = crate::stark_info::VerifierInfo::from_json(vi_val)?;
            crate::verifier_rs_gen::write_verifier_rust_file(
                files_dir.join(format!("{}.verifier.rs", template_str)).to_str().unwrap(),
                &si_loaded,
                &vi_loaded,
            )?;
        }
    }

    Ok(RecursiveSetupResult {
        const_root,
        pil_str: plonk_result.pil_str,
        stark_info: setup_stark_info,
        verifier_info: setup_verifier_info,
        expressions_info: setup_expressions_info,
    })
}

/// Resolve names and output paths based on the template type.
fn resolve_names_and_paths(
    config: &RecursiveSetupConfig<'_>,
) -> Result<(
    String,       // verifier_name
    String,       // name_filename
    PathBuf,      // files_dir
    bool,         // input_challenges
    bool,         // verkey_input
    bool,         // enable_input
)> {
    let template = config.template;
    let build_dir = PathBuf::from(config.build_dir);

    match template {
        RecursiveTemplate::Compressor => {
            let verifier_name = format!("{}.verifier.circom", config.air_name);
            let name_filename = format!("{}_{}", config.air_name, template.as_str());
            let files_dir = build_dir
                .join("provingKey")
                .join(get_global_name(config.global_info))
                .join(config.airgroup_name)
                .join("airs")
                .join(config.air_name)
                .join(template.as_str());
            Ok((verifier_name, name_filename, files_dir, true, false, false))
        }
        RecursiveTemplate::Recursive1 if !config.has_compressor => {
            let verifier_name = format!("{}.verifier.circom", config.air_name);
            let name_filename = format!("{}_{}", config.air_name, template.as_str());
            let files_dir = build_dir
                .join("provingKey")
                .join(get_global_name(config.global_info))
                .join(config.airgroup_name)
                .join("airs")
                .join(config.air_name)
                .join(template.as_str());
            Ok((verifier_name, name_filename, files_dir, true, false, false))
        }
        RecursiveTemplate::Recursive1 => {
            // With compressor
            let verifier_name = format!("{}_compressor.verifier.circom", config.air_name);
            let name_filename = format!("{}_{}", config.air_name, template.as_str());
            let files_dir = build_dir
                .join("provingKey")
                .join(get_global_name(config.global_info))
                .join(config.airgroup_name)
                .join("airs")
                .join(config.air_name)
                .join("recursive1");
            Ok((verifier_name, name_filename, files_dir, false, false, false))
        }
        RecursiveTemplate::Recursive2 => {
            let verifier_name = format!("{}_recursive2.verifier.circom", config.airgroup_name);
            let name_filename = format!("{}_{}", config.airgroup_name, template.as_str());
            let files_dir = build_dir
                .join("provingKey")
                .join(get_global_name(config.global_info))
                .join(config.airgroup_name)
                .join(template.as_str());

            // enableInput is true when there are multiple airgroups or multiple airs
            let n_airgroups = config
                .global_info
                .get("air_groups")
                .and_then(|v| v.as_array())
                .map(|a| a.len())
                .unwrap_or(1);
            let n_airs_first = config
                .global_info
                .get("airs")
                .and_then(|v| v.as_array())
                .and_then(|a| a.first())
                .and_then(|v| v.as_array())
                .map(|a| a.len())
                .unwrap_or(1);
            let enable_input = n_airgroups > 1 || n_airs_first > 1;

            Ok((
                verifier_name,
                name_filename,
                files_dir,
                false,
                true,
                enable_input,
            ))
        }
    }
}

/// Extract the global name from vadcopInfo.
fn get_global_name(global_info: &Value) -> String {
    global_info
        .get("name")
        .and_then(|v| v.as_str())
        .unwrap_or("pilout")
        .to_string()
}

/// Compile PIL source using the pil2-compiler-rust library directly.
pub fn compile_pil(
    pil_path: &str,
    output_path: &str,
    std_pil_path: &str,
    recurser_pil_path: &str,
) -> Result<()> {
    tracing::info!("Compiling PIL: {}", pil_path);

    let options = pil2_compiler_rust::CompileOptions {
        source: pil_path.to_string(),
        include_paths: vec![
            std_pil_path.to_string(),
            recurser_pil_path.to_string(),
        ],
        output: Some(output_path.to_string()),
        ..Default::default()
    };

    pil2_compiler_rust::compile(&options)
        .map_err(|e| anyhow::anyhow!("PIL compilation failed: {}", e))?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_recursive_template_str() {
        assert_eq!(RecursiveTemplate::Compressor.as_str(), "compressor");
        assert_eq!(RecursiveTemplate::Recursive1.as_str(), "recursive1");
        assert_eq!(RecursiveTemplate::Recursive2.as_str(), "recursive2");
    }

    #[test]
    fn test_get_global_name() {
        let info = serde_json::json!({"name": "myPilout"});
        assert_eq!(get_global_name(&info), "myPilout");

        let info_empty = serde_json::json!({});
        assert_eq!(get_global_name(&info_empty), "pilout");
    }
}
