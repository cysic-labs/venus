use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use serde::Deserialize;

use crate::recursive_setup::{
    write_layout_from_r1cs_file, PlonkLayoutKind, RecursiveLayoutArtifacts,
};

#[derive(Debug, Clone, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct RecursiveLayoutManifestEntry {
    pub r1cs: PathBuf,
    pub setup: PathBuf,
    pub kind: RecursiveLayoutKind,
    pub namespace: String,
}

#[derive(Debug, Clone, Copy, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum RecursiveLayoutKind {
    Aggregation,
    Compressor,
    FinalVadcop,
}

impl From<RecursiveLayoutKind> for PlonkLayoutKind {
    fn from(value: RecursiveLayoutKind) -> Self {
        match value {
            RecursiveLayoutKind::Aggregation => PlonkLayoutKind::Aggregation,
            RecursiveLayoutKind::Compressor => PlonkLayoutKind::Compressor,
            RecursiveLayoutKind::FinalVadcop => PlonkLayoutKind::FinalVadcop,
        }
    }
}

pub fn write_layouts_from_manifest(
    manifest_path: &Path,
    proving_key_dir: &Path,
) -> Result<Vec<RecursiveLayoutArtifacts>> {
    let entries = read_manifest(manifest_path)?;
    let manifest_dir = manifest_path.parent().unwrap_or_else(|| Path::new("."));
    let mut artifacts = Vec::with_capacity(entries.len());

    for entry in entries {
        let r1cs_path = resolve_path(manifest_dir, &entry.r1cs);
        let setup_path = resolve_path(proving_key_dir, &entry.setup);
        if let Some(parent) = setup_path.parent() {
            fs::create_dir_all(parent)
                .with_context(|| format!("failed to create {}", parent.display()))?;
        }
        artifacts.push(write_layout_from_r1cs_file(
            &r1cs_path,
            &setup_path,
            entry.kind.into(),
            &entry.namespace,
        )?);
    }

    Ok(artifacts)
}

fn read_manifest(path: &Path) -> Result<Vec<RecursiveLayoutManifestEntry>> {
    let json = fs::read_to_string(path)
        .with_context(|| format!("failed to read recursive layout manifest {}", path.display()))?;
    serde_json::from_str(&json)
        .with_context(|| format!("failed to parse recursive layout manifest {}", path.display()))
}

fn resolve_path(base: &Path, path: &Path) -> PathBuf {
    if path.is_absolute() {
        path.to_path_buf()
    } else {
        base.join(path)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_layout_manifest_entries() -> Result<()> {
        let entries: Vec<RecursiveLayoutManifestEntry> = serde_json::from_str(
            r#"[
                {
                    "r1cs": "build/recursive2.r1cs",
                    "setup": "zisk/Zisk/recursive2/recursive2",
                    "kind": "aggregation",
                    "namespace": "Recursive2"
                },
                {
                    "r1cs": "/tmp/final.r1cs",
                    "setup": "zisk/vadcop_final/vadcop_final",
                    "kind": "final_vadcop",
                    "namespace": "FinalVadcop"
                }
            ]"#,
        )?;

        assert_eq!(entries.len(), 2);
        assert_eq!(entries[0].kind, RecursiveLayoutKind::Aggregation);
        assert_eq!(entries[1].kind, RecursiveLayoutKind::FinalVadcop);
        assert_eq!(entries[0].namespace, "Recursive2");
        Ok(())
    }
}
