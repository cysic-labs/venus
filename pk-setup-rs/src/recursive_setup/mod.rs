#[allow(dead_code)]
pub mod air;
#[allow(dead_code)]
pub mod circuit;
#[allow(dead_code)]
pub mod gadgets;
#[allow(dead_code)]
pub mod manifest;
#[allow(dead_code)]
pub mod plonk;
#[allow(dead_code)]
pub mod r1cs;
#[allow(dead_code)]
pub mod runtime;

use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use pilout_crate::pilout::AirGroupValue;
use serde::Serialize;

use crate::pil_info::binfile::{write_expressions_bin_file, write_verifier_expressions_bin_file};
use crate::pil_info::codegen::generate_pil_code;
use crate::pil_info::stark::{build_air_stark_draft, AirInput};
use crate::recursive_setup::plonk::{PlonkLayout, PlonkProgram};
use crate::setup_layout::write_const_root_files;
use crate::stark_struct::StarkStruct;
pub use plonk::PlonkLayoutKind;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RecursiveLayoutArtifacts {
    pub const_path: PathBuf,
    pub exec_path: PathBuf,
    pub dat_path: PathBuf,
    pub n_bits: u32,
    pub n_rows: usize,
    pub n_constants: usize,
    pub n_committed_pols: usize,
}

#[derive(Debug, Clone)]
pub struct RecursiveAirSetupConfig {
    pub airgroup_id: u32,
    pub air_id: u32,
    pub air_name: String,
    pub num_challenges: Vec<u32>,
    pub stark_struct: StarkStruct,
}

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
struct RecursiveSetupManifest {
    airgroup_id: u32,
    air_id: u32,
    air_name: String,
    kind: String,
    namespace: String,
    num_rows: usize,
    n_bits: u32,
    n_constants: usize,
    n_committed_pols: usize,
    n_publics: u32,
    stark_struct: StarkStruct,
}

#[allow(dead_code)]
pub fn write_layout_from_r1cs_file(
    r1cs_path: &Path,
    setup_path: &Path,
    kind: PlonkLayoutKind,
    namespace: &str,
) -> Result<RecursiveLayoutArtifacts> {
    let r1cs = r1cs::read_r1cs(r1cs_path)
        .with_context(|| format!("failed to read R1CS {}", r1cs_path.display()))?;
    write_layout(&r1cs, setup_path, kind, namespace)
}

#[allow(dead_code)]
pub fn write_setup_from_r1cs_file(
    r1cs_path: &Path,
    setup_path: &Path,
    kind: PlonkLayoutKind,
    namespace: &str,
    config: RecursiveAirSetupConfig,
) -> Result<RecursiveLayoutArtifacts> {
    let r1cs = r1cs::read_r1cs(r1cs_path)
        .with_context(|| format!("failed to read R1CS {}", r1cs_path.display()))?;
    write_setup(&r1cs, setup_path, kind, namespace, config)
}

pub fn write_layout(
    r1cs: &r1cs::R1cs,
    setup_path: &Path,
    kind: PlonkLayoutKind,
    namespace: &str,
) -> Result<RecursiveLayoutArtifacts> {
    let (program, layout) = build_layout_parts(r1cs, kind, namespace)?;
    write_layout_artifacts(r1cs, setup_path, &program, &layout)
}

#[allow(dead_code)]
pub fn write_setup(
    r1cs: &r1cs::R1cs,
    setup_path: &Path,
    kind: PlonkLayoutKind,
    namespace: &str,
    config: RecursiveAirSetupConfig,
) -> Result<RecursiveLayoutArtifacts> {
    let (program, layout) = build_layout_parts(r1cs, kind, namespace)?;
    let artifacts = write_layout_artifacts(r1cs, setup_path, &program, &layout)?;
    write_air_setup_files(setup_path, &layout, kind, namespace, config)?;
    Ok(artifacts)
}

pub fn write_setup_with_runtime_descriptor(
    r1cs: &r1cs::R1cs,
    setup_path: &Path,
    kind: PlonkLayoutKind,
    namespace: &str,
    runtime_descriptor: &runtime::RuntimeDescriptor,
    config: RecursiveAirSetupConfig,
) -> Result<RecursiveLayoutArtifacts> {
    let (program, layout) = build_layout_parts(r1cs, kind, namespace)?;
    let artifacts = write_layout_artifacts_with_runtime_descriptor(
        r1cs,
        setup_path,
        &program,
        &layout,
        Some(runtime_descriptor),
    )?;
    write_air_setup_files(setup_path, &layout, kind, namespace, config)?;
    Ok(artifacts)
}

fn build_layout_parts(
    r1cs: &r1cs::R1cs,
    kind: PlonkLayoutKind,
    namespace: &str,
) -> Result<(PlonkProgram, PlonkLayout)> {
    let program = plonk::r1cs_to_plonk(r1cs)?;
    let layout = plonk::build_layout_from_program(r1cs, &program, kind, namespace)?;
    Ok((program, layout))
}

fn write_layout_artifacts(
    r1cs: &r1cs::R1cs,
    setup_path: &Path,
    program: &PlonkProgram,
    layout: &PlonkLayout,
) -> Result<RecursiveLayoutArtifacts> {
    write_layout_artifacts_with_runtime_descriptor(r1cs, setup_path, program, layout, None)
}

fn write_layout_artifacts_with_runtime_descriptor(
    r1cs: &r1cs::R1cs,
    setup_path: &Path,
    program: &PlonkProgram,
    layout: &PlonkLayout,
    runtime_descriptor: Option<&runtime::RuntimeDescriptor>,
) -> Result<RecursiveLayoutArtifacts> {
    let const_path = setup_path.with_extension("const");
    let exec_path = setup_path.with_extension("exec");
    let dat_path = setup_path.with_extension("dat");
    plonk::write_const_file(&const_path, &layout.fixed_columns)?;
    plonk::write_exec_file(&exec_path, &program.additions, &layout.signal_map)?;
    if let Some(descriptor) = runtime_descriptor {
        runtime::write_runtime_dat_file_with_descriptor(&dat_path, r1cs, descriptor)?;
    } else {
        runtime::write_runtime_dat_file(&dat_path, r1cs)?;
    }
    runtime::write_exec_sidecars(setup_path, r1cs, &program.additions, &layout.signal_map)?;

    Ok(RecursiveLayoutArtifacts {
        const_path,
        exec_path,
        dat_path,
        n_bits: layout.shape.n_bits,
        n_rows: layout.shape.n_rows,
        n_constants: layout.fixed_columns.len(),
        n_committed_pols: layout.signal_map.len(),
    })
}

fn write_air_setup_files(
    setup_path: &Path,
    layout: &PlonkLayout,
    kind: PlonkLayoutKind,
    namespace: &str,
    config: RecursiveAirSetupConfig,
) -> Result<()> {
    let recursive_air = air::build_air_layout(
        layout,
        config.airgroup_id,
        config.air_id,
        &config.air_name,
        layout.shape.n_publics,
    )?;
    let empty_airgroup_values: &[AirGroupValue] = &[];
    let mut draft = build_air_stark_draft(AirInput {
        airgroup_id: config.airgroup_id,
        air_id: config.air_id,
        airgroup_values: empty_airgroup_values,
        all_symbols: &recursive_air.symbols,
        all_hints: &recursive_air.hints,
        num_challenges: &config.num_challenges,
        air: &recursive_air.air,
        stark_struct: config.stark_struct.clone(),
    })?;

    std::fs::write(
        setup_path.with_extension("starkinfo.json"),
        serde_json::to_string_pretty(&draft.stark_info)
            .context("failed to serialize recursive STARK info")?,
    )
    .with_context(|| format!("failed to write {}.starkinfo.json", setup_path.display()))?;

    let (expressions_info, verifier_info) = generate_pil_code(
        &draft.stark_info,
        &draft.symbols,
        &draft.constraints,
        &mut draft.expressions,
        &draft.hints,
        false,
    )?;
    std::fs::write(
        setup_path.with_extension("expressionsinfo.json"),
        serde_json::to_string_pretty(&expressions_info)
            .context("failed to serialize recursive expressions info")?,
    )
    .with_context(|| format!("failed to write {}.expressionsinfo.json", setup_path.display()))?;
    std::fs::write(
        setup_path.with_extension("verifierinfo.json"),
        serde_json::to_string_pretty(&verifier_info)
            .context("failed to serialize recursive verifier info")?,
    )
    .with_context(|| format!("failed to write {}.verifierinfo.json", setup_path.display()))?;
    write_expressions_bin_file(
        &setup_path.with_extension("bin"),
        &draft.stark_info,
        &expressions_info,
    )
    .with_context(|| format!("failed to write {}.bin", setup_path.display()))?;
    write_verifier_expressions_bin_file(
        &setup_path.with_extension("verifier.bin"),
        &draft.stark_info,
        &verifier_info,
    )
    .with_context(|| format!("failed to write {}.verifier.bin", setup_path.display()))?;
    write_const_root_files(setup_path)?;

    let manifest = RecursiveSetupManifest {
        airgroup_id: config.airgroup_id,
        air_id: config.air_id,
        air_name: config.air_name,
        kind: recursive_kind_name(kind).to_string(),
        namespace: namespace.to_string(),
        num_rows: layout.shape.n_rows,
        n_bits: layout.shape.n_bits,
        n_constants: layout.fixed_columns.len(),
        n_committed_pols: layout.signal_map.len(),
        n_publics: layout.shape.n_publics,
        stark_struct: config.stark_struct,
    };
    std::fs::write(
        setup_path.with_extension("setup-rs.json"),
        serde_json::to_string_pretty(&manifest)
            .context("failed to serialize recursive setup manifest")?,
    )
    .with_context(|| format!("failed to write {}.setup-rs.json", setup_path.display()))?;

    Ok(())
}

fn recursive_kind_name(kind: PlonkLayoutKind) -> &'static str {
    match kind {
        PlonkLayoutKind::Aggregation => "aggregation",
        PlonkLayoutKind::Compressor => "compressor",
        PlonkLayoutKind::FinalVadcop => "final_vadcop",
    }
}

#[cfg(test)]
mod tests {
    use anyhow::Result;

    use super::*;
    use crate::recursive_setup::r1cs::{R1cs, R1csConstraint, GOLDILOCKS_P};

    #[test]
    fn writes_recursive_const_and_exec_files() -> Result<()> {
        let dir = std::env::temp_dir()
            .join(format!("pk_setup_recursive_layout_test_{}", std::process::id()));
        std::fs::create_dir_all(&dir)?;
        let setup_path = dir.join("recursive2");
        let r1cs = R1cs {
            n8: 8,
            prime: GOLDILOCKS_P,
            n_vars: 5,
            n_outputs: 0,
            n_pub_inputs: 0,
            n_prv_inputs: 0,
            n_labels: 0,
            n_constraints: 1,
            constraints: vec![R1csConstraint {
                a: [(1, 2)].into_iter().collect(),
                b: [(2, 3)].into_iter().collect(),
                c: [(3, 4)].into_iter().collect(),
            }],
            wire_map: Vec::new(),
            custom_gates: Vec::new(),
            custom_gate_uses: Vec::new(),
        };

        let artifacts =
            write_layout(&r1cs, &setup_path, PlonkLayoutKind::Aggregation, "Recursive")?;
        assert_eq!(artifacts.n_constants, 49);
        assert_eq!(artifacts.n_committed_pols, 59);
        assert!(artifacts.const_path.exists());
        assert!(artifacts.exec_path.exists());
        assert!(artifacts.dat_path.exists());
        assert_eq!(std::fs::metadata(&artifacts.const_path)?.len(), (49 * 8) as u64);
        assert_eq!(std::fs::metadata(&artifacts.exec_path)?.len(), (2 + 59) * 8);
        assert_eq!(&std::fs::read(&artifacts.dat_path)?[..8], b"PIL2RSPD");

        std::fs::remove_dir_all(&dir)?;
        Ok(())
    }
}
