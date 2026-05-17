use std::fs;
use std::path::Path;

use anyhow::{Context, Result};
use serde::de::DeserializeOwned;
use serde::Serialize;
use tracing::info;

use crate::circom_assets::write_recursive_include_assets;
use crate::circom_compile::compile_file_to_r1cs_with_metadata;
use crate::recursive_circom::{
    render_compressor_circom, render_final_circom, render_final_compressed_circom,
    render_recursive1_circom, render_recursive2_circom, render_stark_verifier_circom,
    CircomGlobalConstraintsInfo, CircomStarkInfo, CircomVadcopInfo, CircomVerifierInfo,
    StarkVerifierOptions,
};
use crate::recursive_setup::plonk::calculate_layout_shape;
use crate::recursive_setup::r1cs::read_r1cs;
use crate::recursive_setup::runtime::RuntimeDescriptor;
use crate::recursive_setup::{
    write_setup_with_runtime_descriptor, PlonkLayoutKind, RecursiveAirSetupConfig,
};
use crate::stark_struct::{generate_stark_struct, StarkSettings, StarkStruct};

const RECURSIVE_N_BITS: u64 = 17;

#[derive(Debug, Clone)]
struct SetupProduct {
    stark_info: CircomStarkInfo,
    verifier_info: CircomVerifierInfo,
    verkey: Vec<u64>,
}

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
struct Recursive2VerificationKeys {
    #[serde(rename = "rootCRecursives1")]
    root_c_recursives1: Vec<Vec<u64>>,
    #[serde(rename = "rootCRecursive2")]
    root_c_recursive2: Vec<u64>,
}

pub fn write_recursive_artifacts(build_dir: &Path, proving_key_dir: &Path) -> Result<()> {
    let circom_dir = build_dir.join("circom");
    let r1cs_dir = build_dir.join("build");
    fs::create_dir_all(&circom_dir)
        .with_context(|| format!("failed to create {}", circom_dir.display()))?;
    fs::create_dir_all(&r1cs_dir)
        .with_context(|| format!("failed to create {}", r1cs_dir.display()))?;
    let includes = write_recursive_include_assets(&build_dir.join("circom-includes"))?;

    let vadcop_info: CircomVadcopInfo = read_json(&proving_key_dir.join("pilout.globalInfo.json"))?;
    let global_constraints: CircomGlobalConstraintsInfo =
        read_json(&proving_key_dir.join("pilout.globalConstraints.json"))?;
    let recursive_stark_struct = recursive_stark_struct()?;

    let mut recursive1_roots: Vec<Vec<Vec<u64>>> =
        vadcop_info.airs.iter().map(|airs| Vec::with_capacity(airs.len())).collect();
    let mut recursive2_products = Vec::with_capacity(vadcop_info.air_groups.len());
    let mut recursive2_roots = Vec::with_capacity(vadcop_info.air_groups.len());

    for (airgroup_id, airgroup_name) in vadcop_info.air_groups.iter().enumerate() {
        for (air_id, air) in vadcop_info.airs[airgroup_id].iter().enumerate() {
            let air_dir = proving_key_dir
                .join(&vadcop_info.name)
                .join(airgroup_name)
                .join("airs")
                .join(&air.name);
            let base_path = air_dir.join("air").join(&air.name);
            let base = read_setup_product(&base_path)?;
            let has_compressor = air.has_compressor.unwrap_or(false);

            let (recursive1_input, recursive1_const_root, recursive1_verifier_info) =
                if has_compressor {
                    let compressor = write_air_compressor(
                        &circom_dir,
                        &r1cs_dir,
                        &includes.gl,
                        &includes.vadcop,
                        &air_dir,
                        &vadcop_info,
                        airgroup_name,
                        airgroup_id,
                        air_id,
                        &air.name,
                        &base,
                    )?;
                    (compressor.stark_info, compressor.verkey, compressor.verifier_info)
                } else {
                    (base.stark_info, base.verkey, base.verifier_info)
                };

            let recursive1 = write_recursive1(
                &circom_dir,
                &r1cs_dir,
                &includes.gl,
                &includes.vadcop,
                &air_dir,
                &vadcop_info,
                airgroup_name,
                airgroup_id,
                air_id,
                &air.name,
                &recursive1_input,
                &recursive1_verifier_info,
                &recursive1_const_root,
                has_compressor,
                &recursive_stark_struct,
            )?;
            recursive1_roots[airgroup_id].push(recursive1.verkey);
        }

        let recursive2 = write_recursive2(
            &circom_dir,
            &r1cs_dir,
            &includes.gl,
            &includes.vadcop,
            proving_key_dir,
            &vadcop_info,
            airgroup_name,
            airgroup_id,
            &recursive_stark_struct,
            &recursive1_roots[airgroup_id],
        )?;
        recursive2_roots.push(recursive2.verkey.clone());
        recursive2_products.push(recursive2);
    }

    let final_product = write_vadcop_final(
        &circom_dir,
        &r1cs_dir,
        &includes.gl,
        &includes.vadcop,
        proving_key_dir,
        &vadcop_info,
        &global_constraints,
        &recursive2_products,
        &recursive2_roots,
        &recursive1_roots,
    )?;

    write_vadcop_final_compressed(
        &circom_dir,
        &r1cs_dir,
        &includes.gl,
        &includes.vadcop,
        proving_key_dir,
        &vadcop_info.name,
        &final_product,
    )?;

    Ok(())
}

#[allow(clippy::too_many_arguments)]
fn write_air_compressor(
    circom_dir: &Path,
    r1cs_dir: &Path,
    gl_include: &Path,
    vadcop_include: &Path,
    air_dir: &Path,
    vadcop_info: &CircomVadcopInfo,
    airgroup_name: &str,
    airgroup_id: usize,
    air_id: usize,
    air_name: &str,
    base: &SetupProduct,
) -> Result<SetupProduct> {
    let verifier_name = format!("{air_name}.verifier.circom");
    let verifier = render_stark_verifier_circom(
        &base.verkey,
        &base.stark_info,
        &base.verifier_info,
        StarkVerifierOptions { input_challenges: true, skip_main: true, ..Default::default() },
    );
    write_text(&circom_dir.join(&verifier_name), verifier)?;

    let circuit_name = format!("{air_name}_compressor");
    let circuit = render_compressor_circom(&base.stark_info, vadcop_info, &verifier_name);
    let setup_path = air_dir.join("compressor").join("compressor");
    let namespace = format!("{airgroup_name}_{air_name}_compressor");
    compile_and_write_setup(
        circom_dir,
        r1cs_dir,
        gl_include,
        vadcop_include,
        &circuit_name,
        circuit,
        &setup_path,
        PlonkLayoutKind::Compressor,
        &namespace,
        airgroup_id as u32,
        air_id as u32,
        namespace.clone(),
        StarkStructMode::Compressor,
    )
}

#[allow(clippy::too_many_arguments)]
fn write_recursive1(
    circom_dir: &Path,
    r1cs_dir: &Path,
    gl_include: &Path,
    vadcop_include: &Path,
    air_dir: &Path,
    vadcop_info: &CircomVadcopInfo,
    airgroup_name: &str,
    airgroup_id: usize,
    air_id: usize,
    air_name: &str,
    input_stark: &CircomStarkInfo,
    input_verifier: &CircomVerifierInfo,
    input_const_root: &[u64],
    has_compressor: bool,
    recursive_stark_struct: &StarkStruct,
) -> Result<SetupProduct> {
    let verifier_name = if has_compressor {
        format!("{air_name}_compressor.verifier.circom")
    } else {
        format!("{air_name}.verifier.circom")
    };
    let verifier = render_stark_verifier_circom(
        input_const_root,
        input_stark,
        input_verifier,
        StarkVerifierOptions {
            input_challenges: !has_compressor,
            skip_main: true,
            ..Default::default()
        },
    );
    write_text(&circom_dir.join(&verifier_name), verifier)?;

    let circuit_name = format!("{air_name}_recursive1");
    let circuit =
        render_recursive1_circom(input_stark, vadcop_info, &verifier_name, has_compressor);
    let setup_path = air_dir.join("recursive1").join("recursive1");
    let namespace = format!("{airgroup_name}_{air_name}_recursive1");
    compile_and_write_setup(
        circom_dir,
        r1cs_dir,
        gl_include,
        vadcop_include,
        &circuit_name,
        circuit,
        &setup_path,
        PlonkLayoutKind::Aggregation,
        &namespace,
        airgroup_id as u32,
        air_id as u32,
        namespace.clone(),
        StarkStructMode::Fixed(recursive_stark_struct.clone()),
    )
}

#[allow(clippy::too_many_arguments)]
fn write_recursive2(
    circom_dir: &Path,
    r1cs_dir: &Path,
    gl_include: &Path,
    vadcop_include: &Path,
    proving_key_dir: &Path,
    vadcop_info: &CircomVadcopInfo,
    airgroup_name: &str,
    airgroup_id: usize,
    recursive_stark_struct: &StarkStruct,
    recursive1_roots: &[Vec<u64>],
) -> Result<SetupProduct> {
    let recursive1_stark_path = proving_key_dir
        .join(&vadcop_info.name)
        .join(airgroup_name)
        .join("airs")
        .join(&vadcop_info.airs[airgroup_id][0].name)
        .join("recursive1")
        .join("recursive1");
    let recursive1 = read_setup_product(&recursive1_stark_path)?;

    let verifier_name = format!("{airgroup_name}_recursive2.verifier.circom");
    let multiple_circuits =
        vadcop_info.air_groups.len() > 1 || vadcop_info.airs.first().map(Vec::len).unwrap_or(0) > 1;
    let verifier = render_stark_verifier_circom(
        &recursive1.verkey,
        &recursive1.stark_info,
        &recursive1.verifier_info,
        StarkVerifierOptions {
            skip_main: true,
            verkey_input: true,
            enable_input: multiple_circuits,
            ..Default::default()
        },
    );
    write_text(&circom_dir.join(&verifier_name), verifier)?;

    let circuit_name = format!("{airgroup_name}_recursive2");
    let circuit = render_recursive2_circom(
        &recursive1.stark_info,
        vadcop_info,
        airgroup_id,
        &verifier_name,
        recursive1_roots,
    );
    let setup_path = proving_key_dir
        .join(&vadcop_info.name)
        .join(airgroup_name)
        .join("recursive2")
        .join("recursive2");
    let product = compile_and_write_setup(
        circom_dir,
        r1cs_dir,
        gl_include,
        vadcop_include,
        &circuit_name,
        circuit,
        &setup_path,
        PlonkLayoutKind::Aggregation,
        "Recursive2",
        airgroup_id as u32,
        0,
        "Recursive2".to_string(),
        StarkStructMode::Fixed(recursive_stark_struct.clone()),
    )?;

    let vks = Recursive2VerificationKeys {
        root_c_recursives1: recursive1_roots.to_vec(),
        root_c_recursive2: product.verkey.clone(),
    };
    write_text(&setup_path.with_extension("vks.json"), serde_json::to_string_pretty(&vks)?)?;

    Ok(product)
}

#[allow(clippy::too_many_arguments)]
fn write_vadcop_final(
    circom_dir: &Path,
    r1cs_dir: &Path,
    gl_include: &Path,
    vadcop_include: &Path,
    proving_key_dir: &Path,
    vadcop_info: &CircomVadcopInfo,
    global_constraints: &CircomGlobalConstraintsInfo,
    recursive2_products: &[SetupProduct],
    recursive2_roots: &[Vec<u64>],
    recursive1_roots: &[Vec<Vec<u64>>],
) -> Result<SetupProduct> {
    let mut verifier_names = Vec::with_capacity(recursive2_products.len());
    let mut stark_infos = Vec::with_capacity(recursive2_products.len());
    for (airgroup_id, product) in recursive2_products.iter().enumerate() {
        let airgroup_name = &vadcop_info.air_groups[airgroup_id];
        let verifier_name = format!("{airgroup_name}_recursive2.verifier.circom");
        let multiple_circuits = vadcop_info.air_groups.len() > 1
            || vadcop_info.airs.first().map(Vec::len).unwrap_or(0) > 1;
        let verifier = render_stark_verifier_circom(
            &product.verkey,
            &product.stark_info,
            &product.verifier_info,
            StarkVerifierOptions {
                skip_main: true,
                verkey_input: true,
                enable_input: multiple_circuits,
                ..Default::default()
            },
        );
        write_text(&circom_dir.join(&verifier_name), verifier)?;
        verifier_names.push(verifier_name);
        stark_infos.push(product.stark_info.clone());
    }

    let circuit = render_final_circom(
        &stark_infos,
        vadcop_info,
        global_constraints,
        &verifier_names,
        recursive2_roots,
        recursive1_roots,
    );
    let setup_path =
        proving_key_dir.join(&vadcop_info.name).join("vadcop_final").join("vadcop_final");
    compile_and_write_setup(
        circom_dir,
        r1cs_dir,
        gl_include,
        vadcop_include,
        "vadcop_final",
        circuit,
        &setup_path,
        PlonkLayoutKind::FinalVadcop,
        "FinalVadcop",
        0,
        0,
        "FinalVadcop".to_string(),
        StarkStructMode::Final,
    )
}

#[allow(clippy::too_many_arguments)]
fn write_vadcop_final_compressed(
    circom_dir: &Path,
    r1cs_dir: &Path,
    gl_include: &Path,
    vadcop_include: &Path,
    proving_key_dir: &Path,
    name: &str,
    final_product: &SetupProduct,
) -> Result<SetupProduct> {
    let verifier_name = "vadcop_final.verifier.circom";
    let mut final_stark_info = final_product.stark_info.clone();
    final_stark_info.airgroup_id = None;
    final_stark_info.air_id = None;
    let verifier = render_stark_verifier_circom(
        &final_product.verkey,
        &final_stark_info,
        &final_product.verifier_info,
        StarkVerifierOptions { skip_main: true, ..Default::default() },
    );
    write_text(&circom_dir.join(verifier_name), verifier)?;

    let circuit = render_final_compressed_circom(
        &final_stark_info,
        verifier_name,
        final_stark_info.n_publics,
    );
    let setup_path =
        proving_key_dir.join(name).join("vadcop_final_compressed").join("vadcop_final_compressed");
    compile_and_write_setup(
        circom_dir,
        r1cs_dir,
        gl_include,
        vadcop_include,
        "vadcop_final_compressed",
        circuit,
        &setup_path,
        PlonkLayoutKind::Aggregation,
        "VadcopFinalCompressed",
        0,
        0,
        "VadcopFinalCompressed".to_string(),
        StarkStructMode::FinalCompressed,
    )
}

#[derive(Debug, Clone)]
enum StarkStructMode {
    Fixed(StarkStruct),
    Compressor,
    Final,
    FinalCompressed,
}

#[allow(clippy::too_many_arguments)]
fn compile_and_write_setup(
    circom_dir: &Path,
    r1cs_dir: &Path,
    gl_include: &Path,
    vadcop_include: &Path,
    circuit_name: &str,
    circuit: String,
    setup_path: &Path,
    kind: PlonkLayoutKind,
    namespace: &str,
    airgroup_id: u32,
    air_id: u32,
    air_name: String,
    stark_mode: StarkStructMode,
) -> Result<SetupProduct> {
    let circom_path = circom_dir.join(format!("{circuit_name}.circom"));
    let r1cs_path = r1cs_dir.join(format!("{circuit_name}.r1cs"));
    write_text(&circom_path, circuit)?;
    info!("compiling recursive Circom {}", circom_path.display());
    let metadata = compile_file_to_r1cs_with_metadata(
        &circom_path,
        [circom_dir.to_path_buf(), gl_include.to_path_buf(), vadcop_include.to_path_buf()],
        &r1cs_path,
    )?;

    let r1cs = read_r1cs(&r1cs_path)?;
    let runtime_descriptor = RuntimeDescriptor::for_circom_main_inputs(
        &r1cs,
        metadata.input_signal_start,
        metadata.input_signal_count,
        &metadata.signal_replacements,
    );
    let shape = calculate_layout_shape(&r1cs, kind)?;
    let stark_struct = match stark_mode {
        StarkStructMode::Fixed(stark_struct) => {
            if stark_struct.n_bits != u64::from(shape.n_bits) {
                anyhow::bail!(
                    "{} layout has nBits={} but fixed recursive starkStruct has nBits={}",
                    circuit_name,
                    shape.n_bits,
                    stark_struct.n_bits
                );
            }
            stark_struct
        }
        StarkStructMode::Compressor => compressor_stark_struct(shape.n_bits)?,
        StarkStructMode::Final => final_stark_struct(shape.n_bits)?,
        StarkStructMode::FinalCompressed => final_compressed_stark_struct(shape.n_bits)?,
    };

    if let Some(parent) = setup_path.parent() {
        fs::create_dir_all(parent)
            .with_context(|| format!("failed to create {}", parent.display()))?;
    }
    info!("writing native recursive setup {}", setup_path.display());
    write_setup_with_runtime_descriptor(
        &r1cs,
        setup_path,
        kind,
        namespace,
        &runtime_descriptor,
        RecursiveAirSetupConfig {
            airgroup_id,
            air_id,
            air_name,
            num_challenges: vec![0, 2],
            stark_struct,
        },
    )?;
    read_setup_product(setup_path)
}

fn recursive_stark_struct() -> Result<StarkStruct> {
    let settings = StarkSettings {
        blowup_factor: Some(3),
        last_level_verification: Some(1),
        pow_bits: Some(20),
        ..Default::default()
    };
    generate_stark_struct(&settings, RECURSIVE_N_BITS)
}

fn compressor_stark_struct(n_bits: u32) -> Result<StarkStruct> {
    let settings =
        StarkSettings { blowup_factor: Some(2), pow_bits: Some(20), ..Default::default() };
    generate_stark_struct(&settings, u64::from(n_bits))
}

fn final_stark_struct(n_bits: u32) -> Result<StarkStruct> {
    let settings = StarkSettings {
        blowup_factor: Some(5),
        folding_factor: Some(4),
        pow_bits: Some(22),
        last_level_verification: Some(2),
        ..Default::default()
    };
    generate_stark_struct(&settings, u64::from(n_bits))
}

fn final_compressed_stark_struct(n_bits: u32) -> Result<StarkStruct> {
    let settings = StarkSettings {
        blowup_factor: Some(4),
        folding_factor: Some(3),
        final_degree: Some(10),
        pow_bits: Some(22),
        merkle_tree_arity: Some(2),
        last_level_verification: Some(6),
        ..Default::default()
    };
    generate_stark_struct(&settings, u64::from(n_bits))
}

fn read_setup_product(setup_path: &Path) -> Result<SetupProduct> {
    Ok(SetupProduct {
        stark_info: read_json(&setup_path.with_extension("starkinfo.json"))?,
        verifier_info: read_json(&setup_path.with_extension("verifierinfo.json"))?,
        verkey: read_json(&setup_path.with_extension("verkey.json"))?,
    })
}

fn read_json<T: DeserializeOwned>(path: &Path) -> Result<T> {
    let json =
        fs::read_to_string(path).with_context(|| format!("failed to read {}", path.display()))?;
    serde_json::from_str(&json).with_context(|| format!("failed to parse {}", path.display()))
}

fn write_text(path: &Path, contents: impl AsRef<[u8]>) -> Result<()> {
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent)
            .with_context(|| format!("failed to create {}", parent.display()))?;
    }
    fs::write(path, contents).with_context(|| format!("failed to write {}", path.display()))
}
