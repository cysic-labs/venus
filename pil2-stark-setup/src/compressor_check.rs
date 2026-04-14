//! Port of `is_compressor_needed.js`: determine whether a compressor stage
//! is needed before recursive1 for a given air.
//!
//! The logic compiles a verifier circom to R1CS, reads it, and checks whether
//! the resulting row count exceeds the recursive threshold (17 bits).

use std::fs;

use anyhow::{Context, Result};

use stark_recurser_rust::pil2circom::{pil2circom, Pil2CircomOptions};
use stark_recurser_rust::plonk2pil::setup_common::{get_number_constraints, SetupConfig};
use stark_recurser_rust::plonk2pil::r1cs_reader::read_r1cs;

/// Result of the compressor check.
pub struct CompressorCheckResult {
    /// Whether a compressor stage is needed.
    pub needed: bool,
    /// If the starkinfo was updated (n_queries adjusted), this is true.
    pub starkinfo_updated: bool,
}

/// Check whether a compressor is needed for the given air setup.
///
/// Ports `isCompressorNeeded()` from `is_compressor_needed.js`.
///
/// The function:
/// 1. Generates a verifier circom via `pil2circom` with `skipMain: true`
/// 2. Appends a `component main` line
/// 3. Compiles the circom to R1CS
/// 4. Reads the R1CS and counts constraints (using aggregation config with 59 cols)
/// 5. If n_bits > 17, compressor is needed
/// 6. If n_bits == 17, not needed
/// 7. If n_bits < 17, adjusts n_queries to meet minimum and returns not needed
///
/// # Arguments
/// * `const_root` - 4-element constant root strings
/// * `stark_info` - The starkInfo JSON for this air
/// * `verifier_info` - The verifierInfo JSON for this air
/// * `starkinfo_path` - Path to the starkinfo.json file (may be updated)
/// * `circom_exec` - Path to the circom compiler executable
/// * `circuits_gl_path` - Path to circuits.gl include directory
pub fn is_compressor_needed(
    const_root: &[String; 4],
    stark_info: &serde_json::Value,
    verifier_info: &serde_json::Value,
    starkinfo_path: &str,
    circom_exec: &str,
    circuits_gl_path: &str,
) -> Result<CompressorCheckResult> {
    let tmp_dir = tempfile::tempdir().context("Failed to create temp dir for compressor check")?;
    let tmp_path = tmp_dir.path();

    // Generate verifier circom with skipMain
    let options = Pil2CircomOptions {
        skip_main: true,
        ..Default::default()
    };

    let mut verifier_circom = pil2circom(const_root, stark_info, verifier_info, &options)
        .context("pil2circom failed in compressor check")?;

    // Append component main
    let airgroup_id = stark_info
        .get("airgroupId")
        .and_then(|v| v.as_u64())
        .unwrap_or(0);
    verifier_circom.push_str(&format!(
        "\n\ncomponent main = StarkVerifier{}();\n\n",
        airgroup_id
    ));

    // Write temporary circom file
    let circom_file = tmp_path.join("verifier.circom");
    let r1cs_file = tmp_path.join("verifier.r1cs");
    fs::write(&circom_file, &verifier_circom)?;

    // Compile circom to R1CS
    let compile_output = std::process::Command::new(circom_exec)
        .args([
            "--O1",
            "--r1cs",
            "--prime",
            "goldilocks",
            "-l",
            circuits_gl_path,
        ])
        .arg(circom_file.to_str().unwrap())
        .arg("-o")
        .arg(tmp_path.to_str().unwrap())
        .output()
        .context("Failed to execute circom compiler for compressor check")?;

    if !compile_output.status.success() {
        let stderr = String::from_utf8_lossy(&compile_output.stderr);
        // Save the failing circom for debugging
        let debug_path = std::path::PathBuf::from("/data/eric/venus/temp/compressor_check_debug.circom");
        let _ = fs::copy(&circom_file, &debug_path);
        tracing::warn!("Saved failing circom to {:?}", debug_path);
        anyhow::bail!("Circom compilation failed in compressor check: {}", stderr);
    }

    // Read R1CS
    let r1cs_data = fs::read(&r1cs_file)?;
    let r1cs = read_r1cs(&r1cs_data)?;

    // Use aggregation config (59 committed pols) to count constraints
    let agg_config = aggregation_check_config();
    let (_, _, _, n_used) = get_number_constraints(&r1cs, &agg_config);

    tracing::info!("Number of rows used: {}", n_used);

    let n_bits = if n_used <= 1 {
        1
    } else {
        log2_usize(n_used - 1) + 1
    };

    let recursive_bits: usize = 17;

    if n_bits > recursive_bits {
        Ok(CompressorCheckResult {
            needed: true,
            starkinfo_updated: false,
        })
    } else if n_bits == recursive_bits {
        Ok(CompressorCheckResult {
            needed: false,
            starkinfo_updated: false,
        })
    } else {
        // Adjust n_queries to meet the minimum row requirements
        let stark_struct = stark_info.get("starkStruct");
        let n_queries = stark_struct
            .and_then(|s| s.get("nQueries"))
            .and_then(|v| v.as_u64())
            .unwrap_or(1) as usize;

        let n_rows_per_fri = if n_queries > 0 {
            n_used / n_queries
        } else {
            n_used
        };

        let threshold = (1usize << (recursive_bits - 1)) + (1usize << 12);
        let min_queries = if n_rows_per_fri > 0 {
            (threshold + n_rows_per_fri - 1) / n_rows_per_fri
        } else {
            n_queries
        };

        // Update the starkinfo file with adjusted nQueries
        if min_queries != n_queries {
            let mut si = stark_info.clone();
            if let Some(ss) = si.get_mut("starkStruct") {
                ss.as_object_mut().map(|obj| {
                    obj.insert(
                        "nQueries".to_string(),
                        serde_json::json!(min_queries),
                    )
                });
            }
            let si_str = serde_json::to_string_pretty(&si)?;
            fs::write(starkinfo_path, &si_str)?;

            return Ok(CompressorCheckResult {
                needed: false,
                starkinfo_updated: true,
            });
        }

        Ok(CompressorCheckResult {
            needed: false,
            starkinfo_updated: false,
        })
    }
}

/// Build aggregation-like config for constraint counting (59 committed pols).
fn aggregation_check_config() -> SetupConfig {
    SetupConfig {
        committed_pols: 59,
        n_cols_connections: 27,
        template_name: "Aggregator".to_string(),
        template_file: "aggregator".to_string(),
        max_constraint_degree: 8,
        cmul_per_row: 3,
        poseidon_rows: 5,
        poseidon_first_col: 27,
        poseidon_second_col: Some(43),
        default_airgroup_name: "CompressorCheck".to_string(),
        plonk_first_half_max: 2,
        plonk_full_row_max: 9,
        layout: stark_recurser_rust::plonk2pil::setup_common::LayoutKind::Aggregation,
    }
}

fn log2_usize(n: usize) -> usize {
    if n == 0 {
        return 0;
    }
    (usize::BITS - 1 - n.leading_zeros()) as usize
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_log2_usize() {
        assert_eq!(log2_usize(1), 0);
        assert_eq!(log2_usize(2), 1);
        assert_eq!(log2_usize(3), 1);
        assert_eq!(log2_usize(4), 2);
        assert_eq!(log2_usize(128), 7);
        assert_eq!(log2_usize(131071), 16); // 2^17 - 1
        assert_eq!(log2_usize(131072), 17); // 2^17
    }
}
