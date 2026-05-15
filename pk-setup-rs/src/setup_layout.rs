use std::fs;
use std::io::Write;
use std::path::Path;

use anyhow::{Context, Result};
use pilout_crate::pilout::Air;
use pilout_crate::pilout_proxy::PilOutProxy;
use proofman_starks_lib_c::{
    calculate_const_tree_c, get_const_size_c, get_const_tree_size_c, load_const_pols_c,
    stark_info_free_c, stark_info_new_c,
};
use serde::Serialize;
use tracing::info;

use crate::pil_info::binfile::{write_expressions_bin_file, write_verifier_expressions_bin_file};
use crate::pil_info::codegen::generate_pil_code;
use crate::pil_info::stark::{build_air_stark_draft, AirInput};
use crate::stark_struct::{generate_stark_struct, StarkSettingsMap, StarkStruct};

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
struct AirSetupManifest {
    airgroup_id: usize,
    air_id: usize,
    airgroup_name: String,
    air_name: String,
    num_rows: u32,
    n_bits: u64,
    stark_struct: StarkStruct,
    has_compressor: bool,
}

pub fn write_basic_air_layout(
    proving_key_dir: &Path,
    fixed_dir: &Path,
    pilout: &PilOutProxy,
    settings: &StarkSettingsMap,
) -> Result<()> {
    let root = &pilout.pilout;
    let name = root.name.as_ref().context("PILOUT is missing a name")?.to_string();

    for (airgroup_id, air_group) in root.air_groups.iter().enumerate() {
        let airgroup_name = air_group
            .name
            .as_ref()
            .with_context(|| format!("airgroup {airgroup_id} is missing a name"))?;
        for (air_id, air) in air_group.airs.iter().enumerate() {
            write_basic_air(
                proving_key_dir,
                fixed_dir,
                &name,
                airgroup_id,
                airgroup_name,
                air_id,
                air,
                &root.symbols,
                &root.hints,
                &root.num_challenges,
                &air_group.air_group_values,
                settings,
            )?;
        }
    }
    Ok(())
}

#[allow(clippy::too_many_arguments)]
fn write_basic_air(
    proving_key_dir: &Path,
    fixed_dir: &Path,
    pilout_name: &str,
    airgroup_id: usize,
    airgroup_name: &str,
    air_id: usize,
    air: &Air,
    all_symbols: &[pilout_crate::pilout::Symbol],
    all_hints: &[pilout_crate::pilout::Hint],
    num_challenges: &[u32],
    airgroup_values: &[pilout_crate::pilout::AirGroupValue],
    settings: &StarkSettingsMap,
) -> Result<()> {
    let air_name = air
        .name
        .as_ref()
        .with_context(|| format!("air {airgroup_id}:{air_id} is missing a name"))?;
    let files_dir = proving_key_dir
        .join(pilout_name)
        .join(airgroup_name)
        .join("airs")
        .join(air_name)
        .join("air");
    fs::create_dir_all(&files_dir)
        .with_context(|| format!("failed to create {}", files_dir.display()))?;

    let fixed_src = fixed_dir.join(format!("{air_name}.fixed"));
    let const_dst = files_dir.join(format!("{air_name}.const"));
    fs::copy(&fixed_src, &const_dst).with_context(|| {
        format!("failed to copy {} to {}", fixed_src.display(), const_dst.display())
    })?;

    let num_rows = air.num_rows.with_context(|| format!("air {air_name} is missing numRows"))?;
    let n_bits = checked_log2(num_rows)
        .with_context(|| format!("air {air_name} numRows={num_rows} is not a power of two"))?;
    let air_settings = settings.for_air(air_name);
    let stark_struct = generate_stark_struct(&air_settings, n_bits)?;

    let manifest = AirSetupManifest {
        airgroup_id,
        air_id,
        airgroup_name: airgroup_name.to_string(),
        air_name: air_name.to_string(),
        num_rows,
        n_bits,
        stark_struct,
        has_compressor: air_settings.has_compressor.unwrap_or(false),
    };
    let manifest_path = files_dir.join(format!("{air_name}.setup-rs.json"));
    fs::write(
        &manifest_path,
        serde_json::to_string_pretty(&manifest)
            .context("failed to serialize AIR setup manifest")?,
    )
    .with_context(|| format!("failed to write {}", manifest_path.display()))?;

    let mut draft = build_air_stark_draft(AirInput {
        airgroup_id: airgroup_id as u32,
        air_id: air_id as u32,
        airgroup_values,
        all_symbols,
        all_hints,
        num_challenges,
        air,
        stark_struct: manifest.stark_struct.clone(),
    })?;
    let draft_path = files_dir.join(format!("{air_name}.starkinfo.json"));
    fs::write(
        &draft_path,
        serde_json::to_string_pretty(&draft.stark_info)
            .context("failed to serialize AIR STARK draft")?,
    )
    .with_context(|| format!("failed to write {}", draft_path.display()))?;

    let (expressions_info, verifier_info) = generate_pil_code(
        &draft.stark_info,
        &draft.symbols,
        &draft.constraints,
        &mut draft.expressions,
        &draft.hints,
        false,
    )?;
    let expressions_path = files_dir.join(format!("{air_name}.expressionsinfo.json"));
    fs::write(
        &expressions_path,
        serde_json::to_string_pretty(&expressions_info)
            .context("failed to serialize AIR expressions info draft")?,
    )
    .with_context(|| format!("failed to write {}", expressions_path.display()))?;
    let verifier_path = files_dir.join(format!("{air_name}.verifierinfo.json"));
    fs::write(
        &verifier_path,
        serde_json::to_string_pretty(&verifier_info)
            .context("failed to serialize AIR verifier info draft")?,
    )
    .with_context(|| format!("failed to write {}", verifier_path.display()))?;
    let expressions_bin_path = files_dir.join(format!("{air_name}.bin"));
    write_expressions_bin_file(&expressions_bin_path, &draft.stark_info, &expressions_info)
        .with_context(|| format!("failed to write {}", expressions_bin_path.display()))?;
    let verifier_bin_path = files_dir.join(format!("{air_name}.verifier.bin"));
    write_verifier_expressions_bin_file(&verifier_bin_path, &draft.stark_info, &verifier_info)
        .with_context(|| format!("failed to write {}", verifier_bin_path.display()))?;
    write_const_root_files(&files_dir.join(air_name))?;
    info!("prepared basic AIR layout for {airgroup_name}/{air_name}");

    Ok(())
}

pub(crate) fn write_const_root_files(setup_path: &Path) -> Result<()> {
    let stark_info_path = format!("{}.starkinfo.json", setup_path.display());
    let const_path = format!("{}.const", setup_path.display());
    let verkey_json_path = format!("{}.verkey.json", setup_path.display());
    let verkey_bin_path = format!("{}.verkey.bin", setup_path.display());

    let p_stark_info = stark_info_new_c(&stark_info_path, false, false, false, false, false, false);
    if p_stark_info.is_null() {
        anyhow::bail!("failed to load STARK info {}", stark_info_path);
    }

    let result = (|| -> Result<()> {
        let const_size = get_const_size_c(p_stark_info) as usize;
        let const_tree_size = get_const_tree_size_c(p_stark_info) as usize;
        if const_tree_size < 4 {
            anyhow::bail!("const tree for {} is too small", setup_path.display());
        }

        let mut const_pols = vec![0u64; const_size];
        load_const_pols_c(
            const_pols.as_mut_ptr() as *mut u8,
            &const_path,
            (const_size * std::mem::size_of::<u64>()) as u64,
        );

        let mut const_tree = vec![0u64; const_tree_size];
        calculate_const_tree_c(
            p_stark_info,
            const_pols.as_mut_ptr() as *mut u8,
            const_tree.as_mut_ptr() as *mut u8,
            std::ptr::null_mut(),
        );

        let root = &const_tree[const_tree_size - 4..const_tree_size];
        fs::write(&verkey_json_path, serde_json::to_string_pretty(root)?)
            .with_context(|| format!("failed to write {verkey_json_path}"))?;

        let mut file = fs::File::create(&verkey_bin_path)
            .with_context(|| format!("failed to create {verkey_bin_path}"))?;
        for value in root {
            file.write_all(&value.to_le_bytes())
                .with_context(|| format!("failed to write {verkey_bin_path}"))?;
        }
        Ok(())
    })();

    stark_info_free_c(p_stark_info);
    result
}

fn checked_log2(value: u32) -> Option<u64> {
    if value == 0 || !value.is_power_of_two() {
        return None;
    }
    Some(u64::from(value.trailing_zeros()))
}
