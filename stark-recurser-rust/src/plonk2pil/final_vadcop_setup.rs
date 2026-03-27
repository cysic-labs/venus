//! Final VADCOP setup: generates PIL and fixed polynomials for final VADCOP circuits.
//!
//! Uses 65 committed polynomials, 33 connection columns, and 5 rows per
//! Poseidon gate. Up to 3 CMul gates pack into a single row.
//!
//! Ported from `stark-recurser/src/circom2pil/final_vadcop/final_vadcop_setup.js`.

use super::r1cs_reader::R1csFile;
use super::setup_common::{LayoutKind, PlonkOptions, SetupConfig, SetupResult};

/// Build the final-VADCOP-specific setup configuration.
fn final_vadcop_config(options: &PlonkOptions) -> SetupConfig {
    SetupConfig {
        committed_pols: 65,
        n_cols_connections: 33,
        template_name: "FinalVadcop".to_string(),
        template_file: "final".to_string(),
        max_constraint_degree: options.max_constraint_degree.unwrap_or(8),
        cmul_per_row: 3,
        poseidon_rows: 5,
        poseidon_first_col: 33,
        poseidon_second_col: Some(49),
        default_airgroup_name: "FinalVadcop".to_string(),
        plonk_first_half_max: 2,
        plonk_full_row_max: 11,
        layout: LayoutKind::FinalVadcop,
    }
}

/// Run final VADCOP setup on an R1CS file.
pub fn final_vadcop_compressor(r1cs: &R1csFile, options: &PlonkOptions) -> SetupResult {
    let config = final_vadcop_config(options);
    super::setup_common::run_setup(r1cs, &config, options)
}
