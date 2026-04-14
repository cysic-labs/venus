//! Shared setup-time cross-artifact consistency validator (plan §6.3).
//!
//! Called by `final_setup.rs`, `recursive_setup.rs`, and `compressed_final.rs`
//! after the final JSON (starkinfo/expressionsinfo/verifierinfo) and binary
//! files (`.exec`, `.bin`, `.verifier.bin`) for a layer are written. Catches
//! silent drift between producers before the PK is handed to `make prove`.

use std::fs;
use std::path::Path;

use anyhow::{bail, Context, Result};

/// Run the full §6.3 cross-artifact check for one final-layer output directory.
///
/// * `files_dir` — directory containing `{template}.starkinfo.json`,
///   `{template}.expressionsinfo.json`, `{template}.exec`,
///   `{template}.bin`, `{template}.verifier.bin`.
/// * `template` — layer name (`vadcop_final`, `vadcop_final_compressed`,
///   `recursive1`, `recursive2`, ...).
/// * `exec_header` — optional (n_adds, n_rows) pair as written into the
///   first two u64 of the `.exec` file; when supplied, validates the file
///   size against `starkinfo.mapSectionsN.cm1`. Pass `None` to skip the
///   exec-size check (e.g. for layers where the exec writer uses a
///   different formula).
pub fn validate_final_artifacts(
    files_dir: &Path,
    template: &str,
    exec_header: Option<(u64, u64)>,
) -> Result<()> {
    let starkinfo_path = files_dir.join(format!("{template}.starkinfo.json"));
    let expressionsinfo_path = files_dir.join(format!("{template}.expressionsinfo.json"));

    let starkinfo: serde_json::Value = serde_json::from_str(
        &fs::read_to_string(&starkinfo_path)
            .with_context(|| format!("reading {}", starkinfo_path.display()))?,
    )
    .with_context(|| format!("parsing {}", starkinfo_path.display()))?;
    let expressions: serde_json::Value = serde_json::from_str(
        &fs::read_to_string(&expressionsinfo_path)
            .with_context(|| format!("reading {}", expressionsinfo_path.display()))?,
    )
    .with_context(|| format!("parsing {}", expressionsinfo_path.display()))?;

    let cm1 = starkinfo
        .pointer("/mapSectionsN/cm1")
        .and_then(|v| v.as_u64())
        .ok_or_else(|| anyhow::anyhow!("{}.starkinfo.json mapSectionsN.cm1 missing", template))?;
    let cm2 = starkinfo
        .pointer("/mapSectionsN/cm2")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    let n_constants = starkinfo
        .get("nConstants")
        .and_then(|v| v.as_u64())
        .ok_or_else(|| anyhow::anyhow!("{}.starkinfo.json nConstants missing", template))?;

    // 1) Max referenced column id (cm / const) in expressionsinfo must fit
    //    within the starkinfo-declared ranges. The `id` field for `op: "cm"`
    //    entries is the ABSOLUTE polynomial id across all stages, so for
    //    stage 1 the legal range is 0..cm1 and for stage 2 it is
    //    cm1..(cm1+cm2). The `const` family's id is absolute within the
    //    constant pols range, 0..nConstants.
    {
        let (max_cm1_id, max_cm2_id, max_const_id) = scan_max_referenced_ids(&expressions);
        if let Some(max_id) = max_cm1_id {
            if max_id >= cm1 {
                bail!(
                    "{}: expressionsinfo references cm1 id {} but starkinfo.mapSectionsN.cm1 = {}",
                    template, max_id, cm1
                );
            }
        }
        if let Some(max_id) = max_cm2_id {
            let upper = cm1 + cm2;
            if max_id >= upper {
                bail!(
                    "{}: expressionsinfo references cm2 id {} but cm1+cm2 = {}",
                    template, max_id, upper
                );
            }
        }
        if let Some(max_id) = max_const_id {
            if max_id >= n_constants {
                bail!(
                    "{}: expressionsinfo references const id {} but starkinfo.nConstants = {}",
                    template, max_id, n_constants
                );
            }
        }
    }

    // 2) `.exec` size vs starkinfo cm1, when exec_header is supplied.
    if let Some((n_adds, n_rows)) = exec_header {
        let exec_path = files_dir.join(format!("{template}.exec"));
        let exec_bytes = fs::metadata(&exec_path)
            .with_context(|| format!("stat {}", exec_path.display()))?
            .len();
        if exec_bytes < 16 {
            bail!("{}.exec truncated: {} B (< 16 B header)", template, exec_bytes);
        }
        let expected_u64 = 2 + n_adds * 4 + n_rows * cm1;
        let expected_bytes = expected_u64 * 8;
        if exec_bytes != expected_bytes {
            bail!(
                "{}.exec / starkinfo cm1 mismatch: file is {} B but starkinfo.cm1={} expects \
                 (2 + {}*4 + {}*{})*8 = {} B. Compiled pilout cm1 diverges from plonk2pil s_map \
                 width. The prover will reject this PK at load time.",
                template, exec_bytes, cm1, n_adds, n_rows, cm1, expected_bytes
            );
        }
    }

    // 3) `.bin` / `.verifier.bin` polynomial id sanity: file exists & non-empty.
    //    The binary format is opaque at this layer; we do not re-parse it here.
    //    A deeper range check would require re-reading the binary writer's
    //    structure. For now, guard against empty/truncated writes, which is the
    //    most common drift mode.
    for suffix in &[".bin", ".verifier.bin"] {
        let p = files_dir.join(format!("{template}{suffix}"));
        let len = fs::metadata(&p)
            .with_context(|| format!("stat {}", p.display()))?
            .len();
        if len == 0 {
            bail!("{}{}: empty file", template, suffix);
        }
    }

    Ok(())
}

/// Walk `expressionsinfo.json` and find the max referenced polynomial id per
/// column family (cm1, cm2, const). Returns `None` if no reference of that
/// family was encountered.
fn scan_max_referenced_ids(
    expressions: &serde_json::Value,
) -> (Option<u64>, Option<u64>, Option<u64>) {
    let mut max_cm1 = None;
    let mut max_cm2 = None;
    let mut max_const = None;
    fn update_max(slot: &mut Option<u64>, id: u64) {
        if slot.map(|cur| cur < id).unwrap_or(true) {
            *slot = Some(id);
        }
    }
    fn walk(
        v: &serde_json::Value,
        max_cm1: &mut Option<u64>,
        max_cm2: &mut Option<u64>,
        max_const: &mut Option<u64>,
    ) {
        match v {
            serde_json::Value::Object(m) => {
                let op = m.get("op").and_then(|s| s.as_str());
                let id = m.get("id").and_then(|s| s.as_u64());
                let stage = m.get("stage").and_then(|s| s.as_u64());
                if let (Some("cm"), Some(id), Some(stage)) = (op, id, stage) {
                    match stage {
                        1 => update_max(max_cm1, id),
                        2 => update_max(max_cm2, id),
                        _ => {}
                    }
                } else if let (Some("const"), Some(id)) = (op, id) {
                    update_max(max_const, id);
                }
                for val in m.values() {
                    walk(val, max_cm1, max_cm2, max_const);
                }
            }
            serde_json::Value::Array(arr) => {
                for val in arr {
                    walk(val, max_cm1, max_cm2, max_const);
                }
            }
            _ => {}
        }
    }
    walk(expressions, &mut max_cm1, &mut max_cm2, &mut max_const);
    (max_cm1, max_cm2, max_const)
}
