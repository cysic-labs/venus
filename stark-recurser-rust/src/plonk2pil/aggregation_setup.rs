//! Aggregation setup: generates PIL and fixed polynomials for aggregation circuits.
//!
//! Uses 59 committed polynomials, 27 connection columns, and 5 rows per
//! Poseidon gate. Up to 3 CMul gates pack into a single row.
//!
//! Ported from `stark-recurser/src/circom2pil/aggregation/aggregation_setup.js`.

use super::r1cs_reader::R1csFile;
use super::setup_common::{LayoutKind, PlonkOptions, SetupConfig, SetupResult};

/// Build the aggregation-specific setup configuration.
fn aggregation_config(options: &PlonkOptions) -> SetupConfig {
    SetupConfig {
        committed_pols: 59,
        n_cols_connections: 27,
        template_name: "Aggregator".to_string(),
        template_file: "aggregator".to_string(),
        max_constraint_degree: options.max_constraint_degree.unwrap_or(8),
        cmul_per_row: 3,
        poseidon_rows: 5,
        poseidon_first_col: 27,
        poseidon_second_col: Some(43),
        default_airgroup_name: format!(
            "Compressor{}",
            options
                .airgroup_name
                .as_deref()
                .unwrap_or(&format!("{:x}", rand_u64()))
        ),
        plonk_first_half_max: 2,
        plonk_full_row_max: 9,
        layout: LayoutKind::Aggregation,
    }
}

fn rand_u64() -> u64 {
    use std::time::{SystemTime, UNIX_EPOCH};
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap_or_default()
        .as_nanos() as u64
}

/// Run aggregation setup on an R1CS file.
pub fn aggregation_compressor(r1cs: &R1csFile, options: &PlonkOptions) -> SetupResult {
    let config = aggregation_config(options);
    super::setup_common::run_setup(r1cs, &config, options)
}
