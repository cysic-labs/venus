use std::fs;
use std::path::Path;

use anyhow::{Context, Result};
use pilout_crate::pilout::{self, SymbolType};
use pilout_crate::pilout_proxy::PilOutProxy;
use serde::Serialize;

use crate::pil_info::binfile::write_global_constraints_bin_file;
use crate::pil_info::global::{build_global_constraints, GlobalConstraintsJson};
use crate::stark_struct::StarkSettingsMap;

const MERKLE_TREE_ARITY: usize = 4;
const LATTICE_SIZE: usize = 368;

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct GlobalArtifacts {
    #[serde(rename = "globalInfo")]
    pub info: GlobalInfoJson,
    #[serde(rename = "globalConstraints")]
    pub constraints: GlobalConstraintsJson,
}

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct GlobalInfoJson {
    pub name: String,
    pub airs: Vec<Vec<GlobalAirJson>>,
    #[serde(rename = "air_groups")]
    pub air_groups: Vec<String>,
    pub agg_types: Vec<Vec<GlobalAggTypeJson>>,
    pub curve: String,
    pub lattice_size: usize,
    pub transcript_arity: usize,
    #[serde(rename = "nPublics")]
    pub n_publics: u32,
    pub num_challenges: Vec<u32>,
    pub num_proof_values: Vec<u32>,
    pub proof_values_map: Vec<NamedStageJson>,
    pub publics_map: Vec<PublicMapJson>,
}

#[derive(Debug, Serialize)]
pub struct GlobalAirJson {
    pub name: String,
    pub num_rows: u32,
    #[serde(rename = "hasCompressor", skip_serializing_if = "Option::is_none")]
    pub has_compressor: Option<bool>,
}

#[derive(Debug, Serialize)]
pub struct GlobalAggTypeJson {
    #[serde(rename = "aggType")]
    pub agg_type: i32,
    pub stage: u32,
}

#[derive(Debug, Serialize)]
pub struct NamedStageJson {
    pub name: String,
    pub stage: u32,
}

#[derive(Debug, Serialize)]
pub struct PublicMapJson {
    pub name: String,
    pub stage: u32,
    #[serde(skip_serializing_if = "Vec::is_empty")]
    pub lengths: Vec<u32>,
}

pub fn build_global_artifacts(
    pilout: &PilOutProxy,
    settings: &StarkSettingsMap,
) -> Result<GlobalArtifacts> {
    let root = &pilout.pilout;

    let mut airs = Vec::with_capacity(root.air_groups.len());
    let mut air_groups = Vec::with_capacity(root.air_groups.len());
    let mut agg_types = Vec::with_capacity(root.air_groups.len());

    for air_group in &root.air_groups {
        air_groups.push(required_string(air_group.name.as_ref(), "air group name")?);
        airs.push(
            air_group
                .airs
                .iter()
                .map(|air| {
                    let name = required_string(air.name.as_ref(), "air name")?;
                    let has_compressor = settings.for_air(&name).has_compressor;
                    Ok(GlobalAirJson {
                        name,
                        num_rows: air.num_rows.unwrap_or_default(),
                        has_compressor,
                    })
                })
                .collect::<Result<Vec<_>>>()?,
        );
        agg_types.push(
            air_group
                .air_group_values
                .iter()
                .map(|value| GlobalAggTypeJson { agg_type: value.agg_type, stage: value.stage })
                .collect(),
        );
    }

    let formatted_symbols = format_global_symbols(&root.symbols);
    let proof_values_map = formatted_symbols
        .iter()
        .filter_map(|symbol| match symbol {
            FormattedSymbol::ProofValue { id, name, stage } => Some((*id, name.clone(), *stage)),
            _ => None,
        })
        .collect::<Vec<_>>();
    let publics_map = formatted_symbols
        .iter()
        .filter_map(|symbol| match symbol {
            FormattedSymbol::Public { id, name, lengths } => {
                Some((*id, name.clone(), lengths.clone()))
            }
            _ => None,
        })
        .collect::<Vec<_>>();

    let info = GlobalInfoJson {
        name: required_string(root.name.as_ref(), "pilout name")?,
        airs,
        air_groups,
        agg_types,
        curve: "None".to_string(),
        lattice_size: LATTICE_SIZE,
        transcript_arity: MERKLE_TREE_ARITY,
        n_publics: root.num_public_values,
        num_challenges: if root.num_challenges.is_empty() {
            vec![0]
        } else {
            root.num_challenges.clone()
        },
        num_proof_values: root.num_proof_values.clone(),
        proof_values_map: sparse_named_stage_map(proof_values_map),
        publics_map: sparse_public_map(publics_map),
    };

    Ok(GlobalArtifacts { info, constraints: build_global_constraints(root)? })
}

pub fn write_global_artifacts(proving_key_dir: &Path, global: &GlobalArtifacts) -> Result<()> {
    fs::create_dir_all(proving_key_dir)
        .with_context(|| format!("failed to create {}", proving_key_dir.display()))?;

    let global_info_path = proving_key_dir.join("pilout.globalInfo.json");
    let global_constraints_path = proving_key_dir.join("pilout.globalConstraints.json");
    let global_constraints_bin_path = proving_key_dir.join("pilout.globalConstraints.bin");

    fs::write(
        &global_info_path,
        serde_json::to_string_pretty(&global.info).context("failed to serialize globalInfo")?,
    )
    .with_context(|| format!("failed to write {}", global_info_path.display()))?;

    fs::write(
        &global_constraints_path,
        serde_json::to_string_pretty(&global.constraints)
            .context("failed to serialize globalConstraints")?,
    )
    .with_context(|| format!("failed to write {}", global_constraints_path.display()))?;

    write_global_constraints_bin_file(
        &global_constraints_bin_path,
        &global.info,
        &global.constraints,
    )
    .with_context(|| format!("failed to write {}", global_constraints_bin_path.display()))?;

    Ok(())
}

fn required_string(value: Option<&String>, label: &str) -> Result<String> {
    value.cloned().with_context(|| format!("missing {label}"))
}

#[derive(Debug)]
enum FormattedSymbol {
    ProofValue { id: u32, name: String, stage: u32 },
    Public { id: u32, name: String, lengths: Vec<u32> },
}

fn format_global_symbols(symbols: &[pilout::Symbol]) -> Vec<FormattedSymbol> {
    symbols
        .iter()
        .flat_map(|symbol| match SymbolType::try_from(symbol.r#type).ok() {
            Some(SymbolType::ProofValue) => expand_scalar_or_array(
                symbol,
                symbol.id,
                symbol.stage.unwrap_or(1),
                FormattedKind::ProofValue,
            ),
            Some(SymbolType::PublicValue) => {
                expand_scalar_or_array(symbol, symbol.id, 1, FormattedKind::Public)
            }
            _ => Vec::new(),
        })
        .collect()
}

#[derive(Clone, Copy)]
enum FormattedKind {
    ProofValue,
    Public,
}

fn expand_scalar_or_array(
    symbol: &pilout::Symbol,
    base_id: u32,
    stage: u32,
    kind: FormattedKind,
) -> Vec<FormattedSymbol> {
    let name = symbol.name.clone();
    if symbol.lengths.is_empty() {
        return vec![match kind {
            FormattedKind::ProofValue => FormattedSymbol::ProofValue { id: base_id, name, stage },
            FormattedKind::Public => {
                FormattedSymbol::Public { id: base_id, name, lengths: Vec::new() }
            }
        }];
    }

    let mut out = Vec::new();
    let mut indexes = Vec::new();
    expand_array_symbol(symbol, &mut indexes, base_id, stage, kind, &mut out);
    out
}

fn expand_array_symbol(
    symbol: &pilout::Symbol,
    indexes: &mut Vec<u32>,
    base_id: u32,
    stage: u32,
    kind: FormattedKind,
    out: &mut Vec<FormattedSymbol>,
) {
    if indexes.len() == symbol.lengths.len() {
        let offset = linear_offset(&symbol.lengths, indexes);
        let id = base_id + offset;
        let name = symbol.name.clone();
        match kind {
            FormattedKind::ProofValue => out.push(FormattedSymbol::ProofValue { id, name, stage }),
            FormattedKind::Public => {
                out.push(FormattedSymbol::Public { id, name, lengths: indexes.clone() })
            }
        }
        return;
    }

    for idx in 0..symbol.lengths[indexes.len()] {
        indexes.push(idx);
        expand_array_symbol(symbol, indexes, base_id, stage, kind, out);
        indexes.pop();
    }
}

fn linear_offset(lengths: &[u32], indexes: &[u32]) -> u32 {
    let mut offset = 0;
    let mut stride = 1;
    for (length, index) in lengths.iter().rev().zip(indexes.iter().rev()) {
        offset += index * stride;
        stride *= length;
    }
    offset
}

fn sparse_named_stage_map(entries: Vec<(u32, String, u32)>) -> Vec<NamedStageJson> {
    let max_id = entries.iter().map(|(id, _, _)| *id as usize).max();
    let Some(max_id) = max_id else {
        return Vec::new();
    };
    let mut map =
        (0..=max_id).map(|_| NamedStageJson { name: String::new(), stage: 0 }).collect::<Vec<_>>();
    for (id, name, stage) in entries {
        map[id as usize] = NamedStageJson { name, stage };
    }
    map
}

fn sparse_public_map(entries: Vec<(u32, String, Vec<u32>)>) -> Vec<PublicMapJson> {
    let max_id = entries.iter().map(|(id, _, _)| *id as usize).max();
    let Some(max_id) = max_id else {
        return Vec::new();
    };
    let mut map = (0..=max_id)
        .map(|_| PublicMapJson { name: String::new(), stage: 1, lengths: Vec::new() })
        .collect::<Vec<_>>();
    for (id, name, lengths) in entries {
        map[id as usize] = PublicMapJson { name, stage: 1, lengths };
    }
    map
}
