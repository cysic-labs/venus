use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use pilout_crate::pilout_proxy::PilOutProxy;
use tracing::info;

pub fn overlay_recursive_artifacts(
    cache_proving_key_dir: &Path,
    proving_key_dir: &Path,
    pilout: &PilOutProxy,
    pilout_name: &str,
) -> Result<()> {
    if !cache_proving_key_dir.exists() {
        anyhow::bail!(
            "recursive setup generation is not native yet and recursive artifact cache was not found at {}",
            cache_proving_key_dir.display()
        );
    }

    let root = &pilout.pilout;
    for air_group in &root.air_groups {
        let airgroup_name = required_name(air_group.name.as_ref(), "air group")?;
        for air in &air_group.airs {
            let air_name = required_name(air.name.as_ref(), "air")?;
            copy_named_dir(
                cache_proving_key_dir
                    .join(pilout_name)
                    .join(&airgroup_name)
                    .join("airs")
                    .join(&air_name)
                    .join("recursive1"),
                proving_key_dir
                    .join(pilout_name)
                    .join(&airgroup_name)
                    .join("airs")
                    .join(&air_name)
                    .join("recursive1"),
            )?;

            let compressor_src = cache_proving_key_dir
                .join(pilout_name)
                .join(&airgroup_name)
                .join("airs")
                .join(&air_name)
                .join("compressor");
            if compressor_src.exists() {
                copy_named_dir(
                    compressor_src,
                    proving_key_dir
                        .join(pilout_name)
                        .join(&airgroup_name)
                        .join("airs")
                        .join(&air_name)
                        .join("compressor"),
                )?;
            }
        }

        copy_named_dir(
            cache_proving_key_dir.join(pilout_name).join(&airgroup_name).join("recursive2"),
            proving_key_dir.join(pilout_name).join(&airgroup_name).join("recursive2"),
        )?;
    }

    copy_named_dir(
        cache_proving_key_dir.join(pilout_name).join("vadcop_final"),
        proving_key_dir.join(pilout_name).join("vadcop_final"),
    )?;
    copy_named_dir(
        cache_proving_key_dir.join(pilout_name).join("vadcop_final_compressed"),
        proving_key_dir.join(pilout_name).join("vadcop_final_compressed"),
    )?;

    info!("overlaid recursive aggregation artifacts from {}", cache_proving_key_dir.display());
    Ok(())
}

fn copy_named_dir(src: PathBuf, dst: PathBuf) -> Result<()> {
    if !src.exists() {
        anyhow::bail!("recursive artifact cache entry is missing: {}", src.display());
    }
    if dst.exists() {
        fs::remove_dir_all(&dst).with_context(|| format!("failed to remove {}", dst.display()))?;
    }
    copy_dir_recursive(&src, &dst)
        .with_context(|| format!("failed to copy {} to {}", src.display(), dst.display()))
}

fn copy_dir_recursive(src: &Path, dst: &Path) -> Result<()> {
    fs::create_dir_all(dst).with_context(|| format!("failed to create {}", dst.display()))?;
    for entry in fs::read_dir(src).with_context(|| format!("failed to read {}", src.display()))? {
        let entry = entry?;
        let src_path = entry.path();
        let dst_path = dst.join(entry.file_name());
        let file_type = entry.file_type()?;
        if file_type.is_dir() {
            copy_dir_recursive(&src_path, &dst_path)?;
        } else if file_type.is_file() {
            copy_file_or_link(&src_path, &dst_path)?;
        }
    }
    Ok(())
}

fn copy_file_or_link(src: &Path, dst: &Path) -> Result<()> {
    if fs::hard_link(src, dst).is_ok() {
        return Ok(());
    }
    fs::copy(src, dst)
        .with_context(|| format!("failed to copy {} to {}", src.display(), dst.display()))?;
    Ok(())
}

fn required_name(value: Option<&String>, label: &str) -> Result<String> {
    value.cloned().with_context(|| format!("{label} is missing a name"))
}
