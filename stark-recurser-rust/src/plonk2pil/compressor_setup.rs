//! Compressor setup: generates PIL and fixed polynomials for compressor circuits.
//!
//! Uses 52 committed polynomials, 36 connection columns, and 10 rows per
//! Poseidon gate. Up to 4 CMul gates pack into a single row.
//!
//! Ported from `stark-recurser/src/circom2pil/compressor/compressor_setup.js`.

use super::r1cs_reader::R1csFile;
use super::setup_common::{LayoutKind, PlonkOptions, SetupConfig, SetupResult};

/// Build the compressor-specific setup configuration.
fn compressor_config(options: &PlonkOptions) -> SetupConfig {
    SetupConfig {
        committed_pols: 52,
        n_cols_connections: 36,
        template_name: "Compressor".to_string(),
        template_file: "compressor".to_string(),
        max_constraint_degree: 5,
        cmul_per_row: 4,
        poseidon_rows: 10,
        poseidon_first_col: 36,
        poseidon_second_col: None,
        default_airgroup_name: format!(
            "Compressor{}",
            options
                .airgroup_name
                .as_deref()
                .unwrap_or(&format!("{:x}", rand_u64()))
        ),
        plonk_first_half_max: 6,
        plonk_full_row_max: 12,
        layout: LayoutKind::Compressor,
    }
}

/// Simple pseudo-random u64 for default airgroup name generation.
fn rand_u64() -> u64 {
    use std::time::{SystemTime, UNIX_EPOCH};
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap_or_default()
        .as_nanos() as u64
}

/// Run compressor setup on an R1CS file.
pub fn compressor(r1cs: &R1csFile, options: &PlonkOptions) -> SetupResult {
    let config = compressor_config(options);
    super::setup_common::run_setup(r1cs, &config, options)
}
