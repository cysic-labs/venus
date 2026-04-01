//! Shared infrastructure for compressor/aggregation/final_vadcop setup routines.
//!
//! All three setup variants follow the same overall algorithm:
//! 1. Convert R1CS to PLONK constraints
//! 2. Classify custom gates and compute row counts
//! 3. Place custom gate signals into the signal map (sMap)
//! 4. Place PLONK constraints into remaining rows, sharing rows via partialRows/halfRows
//! 5. Build connection (S) polynomials
//! 6. Emit fixed polynomials [C_0..C_9, S_0..S_{nCols-1}]
//!
//! The differences between variants are parameterized through `SetupConfig`.

use std::collections::HashMap;

use super::r1cs2plonk::{
    self, filter_fft4_gate_uses, filter_gate_uses, get_custom_gates_info, CustomGatesInfo,
    PlonkAddition, PlonkConstraint, GOLDILOCKS_P,
};
use super::r1cs_reader::R1csFile;

/// Goldilocks generator table for roots of unity.
/// `GOLDILOCKS_GEN[n]` is a primitive 2^n-th root of unity.
pub const GOLDILOCKS_GEN: [u64; 33] = [
    1,
    18446744069414584320,
    281474976710656,
    18446744069397807105,
    17293822564807737345,
    70368744161280,
    549755813888,
    17870292113338400769,
    13797081185216407910,
    1803076106186727246,
    11353340290879379826,
    455906449640507599,
    17492915097719143606,
    1532612707718625687,
    16207902636198568418,
    17776499369601055404,
    6115771955107415310,
    12380578893860276750,
    9306717745644682924,
    18146160046829613826,
    3511170319078647661,
    17654865857378133588,
    5416168637041100469,
    16905767614792059275,
    9713644485405565297,
    5456943929260765144,
    17096174751763063430,
    1213594585890690845,
    6414415596519834757,
    16116352524544190054,
    9123114210336311365,
    4614640910117430873,
    1753635133440165772,
];

/// Goldilocks K constant for computing coset shifts.
pub const GOLDILOCKS_K: u64 = 12275445934081160404;

/// Compute `n` coset shift factors: K, K^2, K^3, ..., K^n.
pub fn get_ks(n: usize) -> Vec<u64> {
    let mut ks = Vec::with_capacity(n);
    if n == 0 {
        return ks;
    }
    ks.push(GOLDILOCKS_K);
    for i in 1..n {
        ks.push(mulp(ks[i - 1], ks[0]));
    }
    ks
}

/// Swap two values in connection polynomials (used for wiring).
pub fn connect(p1: &mut [u64], i1: usize, p2: &mut [u64], i2: usize) {
    let tmp = p1[i1];
    p1[i1] = p2[i2];
    p2[i2] = tmp;
}

/// Floor(log2(v)) for a u32 value.
pub fn log2(v: u32) -> u32 {
    if v == 0 {
        return 0;
    }
    31 - v.leading_zeros()
}

#[inline]
fn mulp(a: u64, b: u64) -> u64 {
    ((a as u128 * b as u128) % GOLDILOCKS_P as u128) as u64
}

/// Configuration that distinguishes compressor / aggregation / final_vadcop.
#[derive(Debug, Clone)]
pub struct SetupConfig {
    /// Total number of committed polynomials (columns in sMap).
    pub committed_pols: usize,
    /// Number of columns used for connection constraints (first N columns of sMap).
    pub n_cols_connections: usize,
    /// Template name for PIL generation (e.g. "Compressor", "Aggregator", "FinalVadcop").
    pub template_name: String,
    /// Template file name (e.g. "compressor", "aggregator", "final").
    pub template_file: String,
    /// Maximum constraint degree.
    pub max_constraint_degree: usize,
    /// How many CMul gates fit per row.
    pub cmul_per_row: usize,
    /// Number of rows each Poseidon gate occupies.
    pub poseidon_rows: usize,
    /// First column offset for Poseidon round wires (second block).
    pub poseidon_first_col: usize,
    /// Second column offset for Poseidon round wires (third block, if any).
    /// For compressor (52 cols) this is the same as first_col+16 implicitly via different offsets.
    /// For aggregation/final: first_col + 16.
    pub poseidon_second_col: Option<usize>,
    /// Default airgroup name if none provided.
    pub default_airgroup_name: String,

    // Row-sharing parameters for plonk constraint packing.
    // These describe the tier structure for how many plonk constraints can share custom-gate rows.

    /// Maximum number of plonk constraints that fit in the "first half" of a new plonk row.
    pub plonk_first_half_max: usize,
    /// Maximum number of plonk constraints that fit in the "second half" of a row.
    pub plonk_full_row_max: usize,

    /// The extra-constraint tier names differ per variant. We use a callback-style approach
    /// via the `LayoutStrategy` trait instead.
    pub layout: LayoutKind,
}

/// Distinguishes the three layout strategies.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum LayoutKind {
    Compressor,
    Aggregation,
    FinalVadcop,
}

/// Result of the setup computation.
#[derive(Debug, Clone)]
pub struct SetupResult {
    /// Fixed polynomial values: C[0..10] then S[0..n_cols_connections].
    pub fixed_pols: Vec<FixedPol>,
    /// Generated PIL source string.
    pub pil_str: String,
    /// log2(number of rows).
    pub n_bits: usize,
    /// The signal map (for exec file generation).
    pub s_map: Vec<Vec<u32>>,
    /// Plonk addition records.
    pub plonk_additions: Vec<PlonkAddition>,
    /// Airgroup name.
    pub airgroup_name: String,
    /// Air name.
    pub air_name: String,
}

/// A single fixed polynomial column.
#[derive(Debug, Clone)]
pub struct FixedPol {
    pub name: String,
    pub index: usize,
    pub values: Vec<u64>,
}

/// Options passed to setup functions.
#[derive(Debug, Clone, Default)]
pub struct PlonkOptions {
    pub airgroup_name: Option<String>,
    pub max_constraint_degree: Option<usize>,
}

/// Internal partial-row tracker for constraint packing.
#[derive(Debug, Clone)]
struct PartialRow {
    row: usize,
    n_used: usize,
    #[allow(dead_code)]
    custom: bool,
    max_used: usize,
}

/// Count how many new plonk-only rows are needed, considering how many plonk
/// constraints can be packed into custom-gate rows.
fn calculate_plonk_constraints_rows(
    plonk_constraints: &[PlonkConstraint],
    extra_tiers: &[(usize, usize, usize)], // (count, first_half_max, full_max)
    plonk_first_half_max: usize,
    plonk_full_max: usize,
) -> usize {
    // Build a list of extra-constraint tiers from highest capacity to lowest
    // Each tier: (remaining_count, initial_nUsed_for_partial, maxUsed_for_partial, maxUsed_for_half)
    struct Tier {
        remaining: usize,
        #[allow(dead_code)]
        partial_start: usize,
        partial_max: usize,
        half_start: usize,
        half_max: usize,
    }

    let mut tiers: Vec<Tier> = extra_tiers
        .iter()
        .map(|&(count, first_half_max, full_max)| Tier {
            remaining: count,
            partial_start: 1,
            partial_max: first_half_max,
            half_start: first_half_max,
            half_max: full_max,
        })
        .collect();

    let mut partial_rows: HashMap<String, PartialRow> = HashMap::new();
    let mut half_rows: Vec<PartialRow> = Vec::new();
    let mut r: usize = 0;

    for c in plonk_constraints {
        let k = constraint_key(c);

        if let Some(pr) = partial_rows.get_mut(&k) {
            pr.n_used += 1;
            if pr.n_used == pr.max_used {
                partial_rows.remove(&k);
            }
        } else if !half_rows.is_empty() {
            let mut pr = half_rows.remove(0);
            pr.n_used += 1;
            partial_rows.insert(k, pr);
        } else {
            // Try extra tiers
            let mut placed = false;
            for tier in tiers.iter_mut() {
                if tier.remaining > 0 {
                    tier.remaining -= 1;
                    // Match JS tier handling exactly:
                    // nine:  partial={n_used:1, max:2} + half={n_used:2, max:9}
                    // three: partial={n_used:7, max:9} (no half)
                    // two:   partial={n_used:8, max:9} (no half)
                    // one:   no partial, no half
                    if tier.partial_max < tier.half_start {
                        // nine-style: first half then second half
                        partial_rows.insert(
                            k.clone(),
                            PartialRow {
                                row: 0,
                                n_used: 1,
                                custom: true,
                                max_used: tier.partial_max,
                            },
                        );
                        half_rows.push(PartialRow {
                            row: 0,
                            n_used: tier.half_start,
                            custom: true,
                            max_used: tier.half_max,
                        });
                    } else if tier.half_start < tier.half_max {
                        // three/two-style: direct partial, no half
                        partial_rows.insert(
                            k.clone(),
                            PartialRow {
                                row: 0,
                                n_used: tier.half_start,
                                custom: true,
                                max_used: tier.half_max,
                            },
                        );
                    }
                    // one-style (half_start==half_max): no entries at all
                    placed = true;
                    break;
                }
            }
            if !placed {
                // New plonk-only row
                partial_rows.insert(
                    k.clone(),
                    PartialRow {
                        row: 0,
                        n_used: 1,
                        custom: false,
                        max_used: plonk_first_half_max,
                    },
                );
                half_rows.push(PartialRow {
                    row: 0,
                    n_used: plonk_first_half_max,
                    custom: false,
                    max_used: plonk_full_max,
                });
                r += 1;
            }
        }
    }

    r
}

/// Build the constraint key string (hex representation of qM,qL,qR,qO,qC).
fn constraint_key(c: &PlonkConstraint) -> String {
    format!(
        "{:x},{:x},{:x},{:x},{:x}",
        c[3], c[4], c[5], c[6], c[7]
    )
}

/// Compute the number of rows needed and return all intermediate results.
pub fn get_number_constraints(
    r1cs: &R1csFile,
    config: &SetupConfig,
) -> (
    Vec<PlonkConstraint>,
    Vec<PlonkAddition>,
    CustomGatesInfo,
    usize, // NUsed
) {
    let (plonk_constraints, plonk_additions) = r1cs2plonk::r1cs2plonk(r1cs);
    tracing::info!(
        "Number of plonk constraints: {}",
        plonk_constraints.len()
    );

    let mut custom_gates_info = get_custom_gates_info(r1cs);

    let n_cmul_rows = (custom_gates_info.n_cmul + config.cmul_per_row - 1) / config.cmul_per_row;
    let n_poseidon12_rows = custom_gates_info.n_poseidon12 * config.poseidon_rows;
    let n_cust_poseidon12_rows = custom_gates_info.n_cust_poseidon12 * config.poseidon_rows;
    let n_total_poseidon12_rows = n_poseidon12_rows + n_cust_poseidon12_rows;
    let n_fft4_rows = custom_gates_info.n_fft4;
    let n_ev_pol4_rows = custom_gates_info.n_ev_pol4;
    let n_tree_selector4_rows = custom_gates_info.n_tree_selector4;
    let n_select_val1_rows = custom_gates_info.n_select_val1;

    // Build extra-constraint tiers based on layout variant
    let extra_tiers = build_extra_tiers(&custom_gates_info, config);

    let c_plonk_constraints = calculate_plonk_constraints_rows(
        &plonk_constraints,
        &extra_tiers,
        config.plonk_first_half_max,
        config.plonk_full_row_max,
    );

    custom_gates_info.n_plonk_rows = c_plonk_constraints;

    let n_used = c_plonk_constraints
        + n_cmul_rows
        + n_total_poseidon12_rows
        + n_fft4_rows
        + n_ev_pol4_rows
        + n_tree_selector4_rows
        + n_select_val1_rows;

    tracing::info!(
        "CMul: {} -> {} rows, Poseidon sponge: {} -> {} rows, Poseidon compressor: {} -> {} rows",
        custom_gates_info.n_cmul,
        n_cmul_rows,
        custom_gates_info.n_poseidon12,
        n_poseidon12_rows,
        custom_gates_info.n_cust_poseidon12,
        n_cust_poseidon12_rows,
    );

    (plonk_constraints, plonk_additions, custom_gates_info, n_used)
}

/// Build the extra-constraint tier list for `calculatePlonkConstraintsRows`.
///
/// Each tier is (count, first_half_max, full_max). Tiers are ordered from
/// highest-capacity rows first.
fn build_extra_tiers(info: &CustomGatesInfo, config: &SetupConfig) -> Vec<(usize, usize, usize)> {
    let n_poseidon = info.n_poseidon12 + info.n_cust_poseidon12;
    match config.layout {
        LayoutKind::Compressor => {
            // twelveExtraConstraints, sixExtraConstraints, fiveExtraConstraints, fourExtraConstraints
            let twelve = n_poseidon * 8;
            let six = n_poseidon + info.n_tree_selector4;
            let five = info.n_ev_pol4;
            let four = n_poseidon + info.n_select_val1;
            vec![(twelve, 6, 12), (six, 7, 12), (five, 8, 12), (four, 9, 12)]
        }
        LayoutKind::Aggregation => {
            // nineExtraConstraints, threeExtraConstraints, twoExtraConstraints, oneExtraConstraint
            let nine = n_poseidon * 3;
            let three = n_poseidon + info.n_tree_selector4;
            let two = info.n_ev_pol4;
            let one = n_poseidon + info.n_select_val1;
            vec![(nine, 2, 9), (three, 7, 9), (two, 8, 9), (one, 9, 9)]
        }
        LayoutKind::FinalVadcop => {
            // elevenExtraConstraints, fiveExtraConstraints, fourExtraConstraints, threeExtraConstraints
            let eleven = n_poseidon * 3;
            let five = n_poseidon + info.n_tree_selector4;
            let four = info.n_ev_pol4;
            let three = n_poseidon + info.n_select_val1;
            vec![
                (eleven, 2, 11),
                (five, 7, 11),
                (four, 8, 11),
                (three, 9, 11),
            ]
        }
    }
}

/// Generate the PIL string from template parameters.
fn generate_pil_str(
    config: &SetupConfig,
    airgroup_name: &str,
    n_bits: usize,
    n_publics: u32,
    info: &CustomGatesInfo,
    n_cmul_rows: usize,
) -> String {
    format!(
        r#"require "{template_file}.pil";

set_std_mode(STD_MODE_ONE_INSTANCE);

set_max_constraint_degree({max_degree});

public publics[{n_publics}];

airgroup {namespace}  {{
    {template_name} (N: 2**{n_bits}, nPlonkRows: {n_plonk_rows}, nPoseidonCompressor: {n_poseidon_compressor}, nPoseidonSponge: {n_poseidon_sponge}, nCMulRows: {n_cmul_rows}, nEvPol4: {n_ev_pol4}, nFFT4: {n_fft4}, nTreeSelector4: {n_tree_selector4}, nSelectVal1: {n_select_val1}) alias {namespace};
}}"#,
        template_file = config.template_file,
        max_degree = config.max_constraint_degree,
        n_publics = n_publics,
        namespace = airgroup_name,
        template_name = config.template_name,
        n_bits = n_bits,
        n_plonk_rows = info.n_plonk_rows,
        n_poseidon_compressor = info.n_cust_poseidon12,
        n_poseidon_sponge = info.n_poseidon12,
        n_cmul_rows = n_cmul_rows,
        n_ev_pol4 = info.n_ev_pol4,
        n_fft4 = info.n_fft4,
        n_tree_selector4 = info.n_tree_selector4,
        n_select_val1 = info.n_select_val1,
    )
}

/// Run the full setup algorithm for the given configuration.
pub fn run_setup(r1cs: &R1csFile, config: &SetupConfig, options: &PlonkOptions) -> SetupResult {
    let (plonk_constraints, plonk_additions, custom_gates_info, n_used) =
        get_number_constraints(r1cs, config);

    let n_bits = if n_used <= 1 {
        1
    } else {
        log2((n_used - 1) as u32) as usize + 1
    };
    let n = 1usize << n_bits;

    let n_publics = r1cs.header.n_outputs + r1cs.header.n_pub_inputs;

    let airgroup_name = options
        .airgroup_name
        .clone()
        .unwrap_or_else(|| config.default_airgroup_name.clone());

    let n_cmul_rows =
        (custom_gates_info.n_cmul + config.cmul_per_row - 1) / config.cmul_per_row;

    let pil_str = generate_pil_str(
        config,
        &airgroup_name,
        n_bits,
        n_publics,
        &custom_gates_info,
        n_cmul_rows,
    );

    tracing::info!("NUsed: {}, nBits: {}, N: {}", n_used, n_bits, n);

    // Initialize signal map: committed_pols columns, each of length N
    let mut s_map: Vec<Vec<u32>> = (0..config.committed_pols)
        .map(|_| vec![0u32; n])
        .collect();

    // Initialize 10 C (constant) polynomials
    let mut c_values: Vec<Vec<u64>> = (0..10).map(|_| vec![0u64; n]).collect();

    // Collect extra-constraint row indices for plonk packing
    let mut extra_rows: Vec<Vec<usize>> = vec![Vec::new(); 4]; // up to 4 tiers

    let mut r: usize = 0;

    // Filter gate uses
    let poseidon_gate_uses = filter_gate_uses(
        &r1cs.custom_gates_uses,
        custom_gates_info.poseidon12_id,
    );
    let poseidon_cust_gate_uses = filter_gate_uses(
        &r1cs.custom_gates_uses,
        custom_gates_info.cust_poseidon12_id,
    );
    let cmul_gate_uses = filter_gate_uses(
        &r1cs.custom_gates_uses,
        custom_gates_info.cmul_id,
    );
    let fft4_gate_uses = filter_fft4_gate_uses(
        &r1cs.custom_gates_uses,
        &custom_gates_info.fft4_parameters,
    );
    let ev_pol4_gate_uses = filter_gate_uses(
        &r1cs.custom_gates_uses,
        custom_gates_info.ev_pol4_id,
    );
    let tree_selector4_gate_uses = filter_gate_uses(
        &r1cs.custom_gates_uses,
        custom_gates_info.tree_selector4_id,
    );
    let select_val1_gate_uses = filter_gate_uses(
        &r1cs.custom_gates_uses,
        custom_gates_info.select_val1_id,
    );

    // Place Poseidon sponge gates
    tracing::info!(
        "Processing {} poseidon sponge gates...",
        poseidon_gate_uses.len()
    );
    place_poseidon_gates(
        &poseidon_gate_uses,
        false, // not custom
        config,
        &mut s_map,
        &mut c_values,
        &mut extra_rows,
        &mut r,
    );

    // Place Poseidon custom (compressor) gates
    tracing::info!(
        "Processing {} poseidon custom gates...",
        poseidon_cust_gate_uses.len()
    );
    place_poseidon_gates(
        &poseidon_cust_gate_uses,
        true, // custom
        config,
        &mut s_map,
        &mut c_values,
        &mut extra_rows,
        &mut r,
    );

    // Place CMul gates
    tracing::info!("Processing {} cmul gates...", cmul_gate_uses.len());
    place_cmul_gates(
        &cmul_gate_uses,
        config,
        &mut s_map,
        &mut c_values,
        &mut r,
    );

    // Place EvPol4 gates
    tracing::info!(
        "Processing {} evPol4 gates...",
        ev_pol4_gate_uses.len()
    );
    place_evpol4_gates(
        &ev_pol4_gate_uses,
        config,
        &mut s_map,
        &mut c_values,
        &mut extra_rows,
        &mut r,
    );

    // Place FFT4 gates
    tracing::info!("Processing {} fft4 gates...", fft4_gate_uses.len());
    place_fft4_gates(
        &fft4_gate_uses,
        &custom_gates_info,
        &mut s_map,
        &mut c_values,
        &mut r,
    );

    // Place TreeSelector4 gates
    tracing::info!(
        "Processing {} treeSelector4 gates...",
        tree_selector4_gate_uses.len()
    );
    place_tree_selector4_gates(
        &tree_selector4_gate_uses,
        config,
        &mut s_map,
        &mut c_values,
        &mut extra_rows,
        &mut r,
    );

    // Place SelectVal1 gates
    tracing::info!(
        "Processing {} selectVal1 gates...",
        select_val1_gate_uses.len()
    );
    place_select_val1_gates(
        &select_val1_gate_uses,
        config,
        &mut s_map,
        &mut c_values,
        &mut extra_rows,
        &mut r,
    );

    // Place PLONK constraints into remaining rows
    tracing::info!(
        "Placing {} plonk constraints...",
        plonk_constraints.len()
    );
    place_plonk_constraints(
        &plonk_constraints,
        config,
        &mut s_map,
        &mut c_values,
        &mut extra_rows,
        &mut r,
    );

    assert_eq!(
        r, n_used,
        "Number of rows used ({}) does not match expected ({})",
        r, n_used
    );

    // Build S (connection) polynomials
    let n_cols = config.n_cols_connections;
    let mut s_values: Vec<Vec<u64>> = (0..n_cols).map(|_| vec![0u64; n]).collect();

    let ks = get_ks(n_cols - 1);
    let mut w: u64 = 1;
    for i in 0..n {
        s_values[0][i] = w;
        for j in 1..n_cols {
            s_values[j][i] = mulp(w, ks[j - 1]);
        }
        w = mulp(w, GOLDILOCKS_GEN[n_bits]);
    }

    // Build connections
    let mut connections: usize = 0;
    let mut last_signal: HashMap<u32, (usize, usize)> = HashMap::new(); // signal -> (col, row)
    for i in 0..r {
        for j in 0..n_cols {
            let sig = s_map[j][i];
            if sig != 0 {
                if let Some(&(ls_col, ls_row)) = last_signal.get(&sig) {
                    connections += 1;
                    // Swap s_values[ls_col][ls_row] with s_values[j][i]
                    let tmp = s_values[ls_col][ls_row];
                    s_values[ls_col][ls_row] = s_values[j][i];
                    s_values[j][i] = tmp;
                }
                last_signal.insert(sig, (j, i));
            }
        }
    }
    tracing::info!("Number of connections: {}", connections);

    // Fill remaining rows with empty gates (C values are already 0)
    // r is already at n_used; values are 0-initialized

    // Build fixed polynomial output
    let mut fixed_pols: Vec<FixedPol> = Vec::with_capacity(10 + n_cols);
    for k in 0..10 {
        fixed_pols.push(FixedPol {
            name: format!("{}.C", airgroup_name),
            index: k,
            values: c_values[k].clone(),
        });
    }
    for j in 0..n_cols {
        fixed_pols.push(FixedPol {
            name: format!("{}.S", airgroup_name),
            index: j,
            values: s_values[j].clone(),
        });
    }

    SetupResult {
        fixed_pols,
        pil_str,
        n_bits,
        s_map,
        plonk_additions,
        airgroup_name: airgroup_name.clone(),
        air_name: airgroup_name,
    }
}

/// Place Poseidon gate signals into the signal map.
///
/// The layout differs between compressor (10 rows, offsets 36/47) and
/// aggregation/final_vadcop (5 rows, different offsets).
fn place_poseidon_gates(
    gate_uses: &[&super::r1cs_reader::CustomGateUse],
    is_custom: bool,
    config: &SetupConfig,
    s_map: &mut [Vec<u32>],
    c_values: &mut [Vec<u64>],
    extra_rows: &mut [Vec<usize>],
    r: &mut usize,
) {
    let expected_signals = if is_custom { 14 * 16 + 2 } else { 14 * 16 };

    for cgu in gate_uses {
        assert_eq!(
            cgu.signals.len(),
            expected_signals,
            "Poseidon gate signal count mismatch"
        );

        let sigs = &cgu.signals;
        let (input, _extra_offset) = if is_custom {
            (&sigs[0..16], 2usize)
        } else {
            (&sigs[0..16], 0usize)
        };

        let base = if is_custom { 18 } else { 16 };
        let round0 = &sigs[base..base + 16];
        let round1 = &sigs[base + 16..base + 32];
        let round2 = &sigs[base + 32..base + 48];
        let round3 = &sigs[base + 48..base + 64];
        let round4 = &sigs[base + 64..base + 80];
        let im1 = &sigs[base + 80..base + 96];
        let _round15 = &sigs[base + 96..base + 112];
        let im2 = &sigs[base + 112..base + 128];
        let round26 = &sigs[base + 128..base + 144];
        let round27 = &sigs[base + 144..base + 160];
        let round28 = &sigs[base + 160..base + 176];
        let round29 = &sigs[base + 176..base + 192];
        let output = &sigs[base + 192..base + 208];

        match config.layout {
            LayoutKind::Compressor => {
                // 10 rows per Poseidon gate, offsets 36 for round columns
                let col_p = 36usize;
                for i in 0..16 {
                    s_map[i][*r] = input[i] as u32;
                    s_map[i + col_p][*r] = round0[i] as u32;
                    s_map[i + col_p][*r + 1] = round1[i] as u32;
                    s_map[i + col_p][*r + 2] = round2[i] as u32;
                    s_map[i + col_p][*r + 3] = round3[i] as u32;
                    s_map[i + col_p][*r + 4] = round4[i] as u32;
                    s_map[i + col_p][*r + 6] = round26[i] as u32;
                    s_map[i + col_p][*r + 7] = round27[i] as u32;
                    s_map[i + col_p][*r + 8] = round28[i] as u32;
                    s_map[i + col_p][*r + 9] = round29[i] as u32;
                    s_map[i][*r + 9] = output[i] as u32;
                }
                if is_custom {
                    s_map[16][*r] = sigs[16] as u32; // first_bit
                    s_map[17][*r] = sigs[17] as u32; // second_bit
                }
                for i in 0..11 {
                    s_map[i + col_p][*r + 5] = im1[i] as u32;
                    if i < 5 {
                        s_map[i + 47][*r + 5] = im2[i] as u32;
                    } else {
                        let pos = i - 5;
                        s_map[pos + 18][*r] = im2[i] as u32;
                    }
                }

                // Zero out C values for all 10 rows
                for row_off in 0..10 {
                    for k in 0..10 {
                        c_values[k][*r + row_off] = 0;
                    }
                }

                // Register extra constraint rows
                // fourExtraConstraints <- r
                extra_rows[3].push(*r);
                // twelveExtraConstraints <- r+1..r+8
                for off in 1..=8 {
                    extra_rows[0].push(*r + off);
                }
                // sixExtraConstraints <- r+9
                extra_rows[1].push(*r + 9);

                *r += 10;
            }
            LayoutKind::Aggregation => {
                // 5 rows per Poseidon gate
                let col_p1 = 27usize;
                let col_p2 = 43usize;
                for i in 0..16 {
                    s_map[i][*r] = input[i] as u32;
                    s_map[i + col_p1][*r] = round0[i] as u32;
                    s_map[i + col_p2][*r] = round1[i] as u32;
                    s_map[i + col_p1][*r + 1] = round2[i] as u32;
                    s_map[i + col_p2][*r + 1] = round3[i] as u32;
                    s_map[i + col_p1][*r + 2] = round4[i] as u32;
                    s_map[i + col_p1][*r + 3] = round26[i] as u32;
                    s_map[i + col_p2][*r + 3] = round27[i] as u32;
                    s_map[i + col_p1][*r + 4] = round28[i] as u32;
                    s_map[i + col_p2][*r + 4] = round29[i] as u32;
                    s_map[i][*r + 4] = output[i] as u32;
                }
                if is_custom {
                    s_map[16][*r] = sigs[16] as u32;
                    s_map[17][*r] = sigs[17] as u32;
                }
                for i in 0..11 {
                    s_map[i + col_p2][*r + 2] = im1[i] as u32;
                    if i < 5 {
                        s_map[i + 54][*r + 2] = im2[i] as u32;
                    } else {
                        let pos = i - 5;
                        s_map[pos + 18][*r] = im2[i] as u32;
                    }
                }

                let num_rows = if is_custom { 6 } else { 5 };
                for row_off in 0..num_rows {
                    for k in 0..10 {
                        c_values[k][*r + row_off] = 0;
                    }
                }

                // oneExtraConstraint <- r
                extra_rows[3].push(*r);
                // nineExtraConstraints <- r+1, r+2, r+3
                for off in 1..=3 {
                    extra_rows[0].push(*r + off);
                }
                // threeExtraConstraints <- r+4
                extra_rows[1].push(*r + 4);

                *r += 5;
            }
            LayoutKind::FinalVadcop => {
                // 5 rows per Poseidon gate, with firstColP = 33
                let first_col_p = 33usize;
                let col_p1 = first_col_p;
                let col_p2 = first_col_p + 16;
                for i in 0..16 {
                    s_map[i][*r] = input[i] as u32;
                    s_map[i + col_p1][*r] = round0[i] as u32;
                    s_map[i + col_p2][*r] = round1[i] as u32;
                    s_map[i + col_p1][*r + 1] = round2[i] as u32;
                    s_map[i + col_p2][*r + 1] = round3[i] as u32;
                    s_map[i + col_p1][*r + 2] = round4[i] as u32;
                    s_map[i + col_p1][*r + 3] = round26[i] as u32;
                    s_map[i + col_p2][*r + 3] = round27[i] as u32;
                    s_map[i + col_p1][*r + 4] = round28[i] as u32;
                    s_map[i + col_p2][*r + 4] = round29[i] as u32;
                    s_map[i][*r + 4] = output[i] as u32;
                }
                if is_custom {
                    s_map[16][*r] = sigs[16] as u32;
                    s_map[17][*r] = sigs[17] as u32;
                }
                for i in 0..11 {
                    s_map[i + col_p2][*r + 2] = im1[i] as u32;
                    if i < 5 {
                        s_map[i + col_p2 + 11][*r + 2] = im2[i] as u32;
                    } else {
                        let pos = i - 5;
                        s_map[pos + 18][*r] = im2[i] as u32;
                    }
                }

                let num_rows = if is_custom { 6 } else { 5 };
                for row_off in 0..num_rows {
                    for k in 0..10 {
                        c_values[k][*r + row_off] = 0;
                    }
                }

                // threeExtraConstraints <- r
                extra_rows[3].push(*r);
                // elevenExtraConstraints <- r+1, r+2, r+3
                for off in 1..=3 {
                    extra_rows[0].push(*r + off);
                }
                // fiveExtraConstraints <- r+4
                extra_rows[1].push(*r + 4);

                *r += 5;
            }
        }
    }
}

/// Place CMul gate signals.
fn place_cmul_gates(
    gate_uses: &[&super::r1cs_reader::CustomGateUse],
    config: &SetupConfig,
    s_map: &mut [Vec<u32>],
    c_values: &mut [Vec<u64>],
    r: &mut usize,
) {
    let cmul_per_row = config.cmul_per_row;
    let mut partial_cmul_row: i64 = -1;
    let mut partial_cmul_n_used: usize = 0;

    for cgu in gate_uses {
        assert_eq!(cgu.signals.len(), 9, "CMul gate should have 9 signals");

        if partial_cmul_row >= 0 {
            let row = partial_cmul_row as usize;
            for i in 0..9 {
                s_map[i + 9 * partial_cmul_n_used][row] = cgu.signals[i] as u32;
            }
            partial_cmul_n_used += 1;
            if partial_cmul_n_used == cmul_per_row {
                partial_cmul_row = -1;
                partial_cmul_n_used = 0;
            }
        } else {
            for i in 0..9 {
                s_map[i][*r] = cgu.signals[i] as u32;
            }
            for k in 0..10 {
                c_values[k][*r] = 0;
            }
            partial_cmul_row = *r as i64;
            partial_cmul_n_used = 1;
            *r += 1;
        }
    }
}

/// Place EvPol4 gate signals.
fn place_evpol4_gates(
    gate_uses: &[&super::r1cs_reader::CustomGateUse],
    config: &SetupConfig,
    s_map: &mut [Vec<u32>],
    c_values: &mut [Vec<u64>],
    extra_rows: &mut [Vec<usize>],
    r: &mut usize,
) {
    for cgu in gate_uses {
        for i in 0..21 {
            s_map[i][*r] = cgu.signals[i] as u32;
        }
        for k in 0..10 {
            c_values[k][*r] = 0;
        }

        // Register as extra constraint row (tier index depends on layout)
        match config.layout {
            LayoutKind::Compressor => extra_rows[2].push(*r), // fiveExtraConstraints
            LayoutKind::Aggregation => extra_rows[2].push(*r), // twoExtraConstraints
            LayoutKind::FinalVadcop => extra_rows[2].push(*r), // fourExtraConstraints
        }
        *r += 1;
    }
}

/// Place FFT4 gate signals and compute C polynomial values.
fn place_fft4_gates(
    gate_uses: &[&super::r1cs_reader::CustomGateUse],
    info: &CustomGatesInfo,
    s_map: &mut [Vec<u32>],
    c_values: &mut [Vec<u64>],
    r: &mut usize,
) {
    for cgu in gate_uses {
        for i in 0..24 {
            s_map[i][*r] = cgu.signals[i] as u32;
        }

        let params = info.fft4_parameters.get(&cgu.id).expect("FFT4 params");
        let fft_type = params[3];
        let scale = params[2];
        let first_w = params[0];
        let first_w2 = mulp(first_w, first_w);
        let inc_w = params[1];

        if fft_type == 4 {
            c_values[0][*r] = scale;
            c_values[1][*r] = mulp(scale, first_w2);
            c_values[2][*r] = mulp(scale, first_w);
            c_values[3][*r] = mulp(mulp(scale, first_w), first_w2);
            c_values[4][*r] = mulp(mulp(scale, first_w), inc_w);
            c_values[5][*r] = mulp(mulp(mulp(scale, first_w), first_w2), inc_w);
            c_values[6][*r] = 0;
            c_values[7][*r] = 0;
            c_values[8][*r] = 0;
            c_values[9][*r] = 0;
        } else if fft_type == 2 {
            c_values[0][*r] = 0;
            c_values[1][*r] = 0;
            c_values[2][*r] = 0;
            c_values[3][*r] = 0;
            c_values[4][*r] = 0;
            c_values[5][*r] = 0;
            c_values[6][*r] = scale;
            c_values[7][*r] = mulp(scale, first_w);
            c_values[8][*r] = mulp(mulp(scale, first_w), inc_w);
            c_values[9][*r] = 0;
        } else {
            panic!("Invalid FFT4 type: {}", fft_type);
        }

        *r += 1;
    }
}

/// Place TreeSelector4 gate signals.
fn place_tree_selector4_gates(
    gate_uses: &[&super::r1cs_reader::CustomGateUse],
    config: &SetupConfig,
    s_map: &mut [Vec<u32>],
    c_values: &mut [Vec<u64>],
    extra_rows: &mut [Vec<usize>],
    r: &mut usize,
) {
    for cgu in gate_uses {
        assert_eq!(
            cgu.signals.len(),
            17,
            "TreeSelector4 gate should have 17 signals"
        );
        for i in 0..17 {
            s_map[i][*r] = cgu.signals[i] as u32;
        }
        for k in 0..10 {
            c_values[k][*r] = 0;
        }

        // Register as extra constraint row
        match config.layout {
            LayoutKind::Compressor => extra_rows[1].push(*r), // sixExtraConstraints
            LayoutKind::Aggregation => extra_rows[1].push(*r), // threeExtraConstraints
            LayoutKind::FinalVadcop => extra_rows[1].push(*r), // fiveExtraConstraints
        }
        *r += 1;
    }
}

/// Place SelectVal1 gate signals.
fn place_select_val1_gates(
    gate_uses: &[&super::r1cs_reader::CustomGateUse],
    config: &SetupConfig,
    s_map: &mut [Vec<u32>],
    c_values: &mut [Vec<u64>],
    extra_rows: &mut [Vec<usize>],
    r: &mut usize,
) {
    for cgu in gate_uses {
        assert_eq!(
            cgu.signals.len(),
            22,
            "SelectVal1 gate should have 22 signals"
        );
        for i in 0..22 {
            s_map[i][*r] = cgu.signals[i] as u32;
        }
        for k in 0..10 {
            c_values[k][*r] = 0;
        }

        // Register as extra constraint row
        match config.layout {
            LayoutKind::Compressor => extra_rows[3].push(*r), // fourExtraConstraints
            LayoutKind::Aggregation => extra_rows[3].push(*r), // oneExtraConstraint
            LayoutKind::FinalVadcop => extra_rows[3].push(*r), // threeExtraConstraints
        }
        *r += 1;
    }
}

/// Place PLONK constraints into remaining rows, packing multiple constraints per row
/// when they share the same gate equation (qM, qL, qR, qO, qC).
fn place_plonk_constraints(
    plonk_constraints: &[PlonkConstraint],
    config: &SetupConfig,
    s_map: &mut [Vec<u32>],
    c_values: &mut [Vec<u64>],
    extra_rows: &mut [Vec<usize>],
    r: &mut usize,
) {
    let mut partial_rows: HashMap<String, PartialRow> = HashMap::new();
    let mut half_rows: Vec<PartialRow> = Vec::new();

    // Determine layout-specific parameters for plonk placement
    let (first_half_max, full_max) = match config.layout {
        LayoutKind::Compressor => (6usize, 12usize),
        LayoutKind::Aggregation => (2usize, 9usize),
        LayoutKind::FinalVadcop => (2usize, 11usize),
    };

    for (i, c) in plonk_constraints.iter().enumerate() {
        if i % 10_000 == 0 {
            tracing::debug!(
                "Processing constraint... {}/{}",
                i,
                plonk_constraints.len()
            );
        }

        let k = constraint_key(c);

        if let Some(pr) = partial_rows.get_mut(&k) {
            let n = pr.n_used;
            s_map[n * 3][pr.row] = c[0] as u32;
            s_map[n * 3 + 1][pr.row] = c[1] as u32;
            s_map[n * 3 + 2][pr.row] = c[2] as u32;
            pr.n_used += 1;
            if pr.n_used == pr.max_used {
                partial_rows.remove(&k);
            }
        } else if !half_rows.is_empty() {
            let mut pr = half_rows.remove(0);
            // Set C[5..9] for the second half
            c_values[5][pr.row] = c[3];
            c_values[6][pr.row] = c[4];
            c_values[7][pr.row] = c[5];
            c_values[8][pr.row] = c[6];
            c_values[9][pr.row] = c[7];

            for idx in pr.n_used..pr.max_used {
                s_map[3 * idx][pr.row] = c[0] as u32;
                s_map[3 * idx + 1][pr.row] = c[1] as u32;
                s_map[3 * idx + 2][pr.row] = c[2] as u32;
            }

            pr.n_used += 1;
            partial_rows.insert(k, pr);
        } else {
            // Try extra-constraint tiers
            let mut placed = false;

            // Tier 0: highest capacity extra rows
            if !extra_rows[0].is_empty() {
                let row = extra_rows[0].remove(0);
                place_plonk_in_extra_row_first_half(
                    c, row, first_half_max, full_max, config, s_map, c_values,
                    &mut partial_rows, &mut half_rows, &k,
                );
                placed = true;
            }
            // Tier 1
            if !placed && !extra_rows[1].is_empty() {
                let row = extra_rows[1].remove(0);
                place_plonk_in_extra_row_second_half(
                    c, row, config, s_map, c_values, &mut partial_rows, &k,
                );
                placed = true;
            }
            // Tier 2
            if !placed && !extra_rows[2].is_empty() {
                let row = extra_rows[2].remove(0);
                place_plonk_in_extra_row_second_half_offset(
                    c, row, 1, config, s_map, c_values, &mut partial_rows, &k,
                );
                placed = true;
            }
            // Tier 3
            if !placed && !extra_rows[3].is_empty() {
                let row = extra_rows[3].remove(0);
                place_plonk_in_extra_row_second_half_offset(
                    c, row, 2, config, s_map, c_values, &mut partial_rows, &k,
                );
                placed = true;
            }

            if !placed {
                // New plonk-only row
                c_values[0][*r] = c[3];
                c_values[1][*r] = c[4];
                c_values[2][*r] = c[5];
                c_values[3][*r] = c[6];
                c_values[4][*r] = c[7];

                for idx in 0..first_half_max {
                    s_map[3 * idx][*r] = c[0] as u32;
                    s_map[3 * idx + 1][*r] = c[1] as u32;
                    s_map[3 * idx + 2][*r] = c[2] as u32;
                }

                partial_rows.insert(
                    k.clone(),
                    PartialRow {
                        row: *r,
                        n_used: 1,
                        custom: false,
                        max_used: first_half_max,
                    },
                );
                half_rows.push(PartialRow {
                    row: *r,
                    n_used: first_half_max,
                    custom: false,
                    max_used: full_max,
                });

                *r += 1;
            }
        }
    }
}

/// Place a plonk constraint into an extra row's first half (C[0..4] available).
fn place_plonk_in_extra_row_first_half(
    c: &PlonkConstraint,
    row: usize,
    first_half_max: usize,
    full_max: usize,
    _config: &SetupConfig,
    s_map: &mut [Vec<u32>],
    c_values: &mut [Vec<u64>],
    partial_rows: &mut HashMap<String, PartialRow>,
    half_rows: &mut Vec<PartialRow>,
    k: &str,
) {
    c_values[0][row] = c[3];
    c_values[1][row] = c[4];
    c_values[2][row] = c[5];
    c_values[3][row] = c[6];
    c_values[4][row] = c[7];

    for idx in 0..first_half_max {
        s_map[3 * idx][row] = c[0] as u32;
        s_map[3 * idx + 1][row] = c[1] as u32;
        s_map[3 * idx + 2][row] = c[2] as u32;
    }

    partial_rows.insert(
        k.to_string(),
        PartialRow {
            row,
            n_used: 1,
            custom: true,
            max_used: first_half_max,
        },
    );
    // Only add half_rows if the row can hold more constraints
    if first_half_max < full_max {
        half_rows.push(PartialRow {
            row,
            n_used: first_half_max,
            custom: true,
            max_used: full_max,
        });
    }
}

/// Place a plonk constraint into an extra row's second half (C[5..9]) with
/// specific start offset for wire placement.
fn place_plonk_in_extra_row_second_half(
    c: &PlonkConstraint,
    row: usize,
    config: &SetupConfig,
    s_map: &mut [Vec<u32>],
    c_values: &mut [Vec<u64>],
    partial_rows: &mut HashMap<String, PartialRow>,
    k: &str,
) {
    c_values[5][row] = c[3];
    c_values[6][row] = c[4];
    c_values[7][row] = c[5];
    c_values[8][row] = c[6];
    c_values[9][row] = c[7];

    let (start_idx, full_max) = match config.layout {
        LayoutKind::Compressor => (6usize, 12usize), // sixExtraConstraints: nUsed=7, fill cols 18..35
        LayoutKind::Aggregation => {
            // threeExtraConstraints: fill cols 18..26
            let start = 6usize; // n_used starts at 7 for 3-extra
            for idx in start..9 {
                s_map[3 * idx][row] = c[0] as u32;
                s_map[3 * idx + 1][row] = c[1] as u32;
                s_map[3 * idx + 2][row] = c[2] as u32;
            }
            partial_rows.insert(
                k.to_string(),
                PartialRow {
                    row,
                    n_used: 7,
                    custom: true,
                    max_used: 9,
                },
            );
            return;
        }
        LayoutKind::FinalVadcop => {
            // fiveExtraConstraints: fill cols 18..32
            let start = 6usize;
            for idx in start..11 {
                s_map[3 * idx][row] = c[0] as u32;
                s_map[3 * idx + 1][row] = c[1] as u32;
                s_map[3 * idx + 2][row] = c[2] as u32;
            }
            partial_rows.insert(
                k.to_string(),
                PartialRow {
                    row,
                    n_used: 7,
                    custom: true,
                    max_used: 11,
                },
            );
            return;
        }
    };

    for idx in start_idx..full_max {
        s_map[3 * idx][row] = c[0] as u32;
        s_map[3 * idx + 1][row] = c[1] as u32;
        s_map[3 * idx + 2][row] = c[2] as u32;
    }

    partial_rows.insert(
        k.to_string(),
        PartialRow {
            row,
            n_used: start_idx + 1,
            custom: true,
            max_used: full_max,
        },
    );
}

/// Place a plonk constraint into an extra row's second half with additional offset.
fn place_plonk_in_extra_row_second_half_offset(
    c: &PlonkConstraint,
    row: usize,
    tier_offset: usize, // 1 for five/two/four-extra, 2 for four/one/three-extra
    config: &SetupConfig,
    s_map: &mut [Vec<u32>],
    c_values: &mut [Vec<u64>],
    partial_rows: &mut HashMap<String, PartialRow>,
    k: &str,
) {
    c_values[5][row] = c[3];
    c_values[6][row] = c[4];
    c_values[7][row] = c[5];
    c_values[8][row] = c[6];
    c_values[9][row] = c[7];

    match config.layout {
        LayoutKind::Compressor => {
            // tier_offset=1 => fiveExtraConstraints: nUsed=8, maxUsed=12
            // tier_offset=2 => fourExtraConstraints: nUsed=9, maxUsed=12
            let n_used_start = if tier_offset == 1 { 7 } else { 8 };
            let full_max = 12usize;
            for idx in n_used_start..full_max {
                s_map[3 * idx][row] = c[0] as u32;
                s_map[3 * idx + 1][row] = c[1] as u32;
                s_map[3 * idx + 2][row] = c[2] as u32;
            }
            partial_rows.insert(
                k.to_string(),
                PartialRow {
                    row,
                    n_used: n_used_start + 1,
                    custom: true,
                    max_used: full_max,
                },
            );
        }
        LayoutKind::Aggregation => {
            if tier_offset == 1 {
                // twoExtraConstraints: nUsed=8, maxUsed=9
                for idx in 7..9 {
                    s_map[3 * idx][row] = c[0] as u32;
                    s_map[3 * idx + 1][row] = c[1] as u32;
                    s_map[3 * idx + 2][row] = c[2] as u32;
                }
                partial_rows.insert(
                    k.to_string(),
                    PartialRow {
                        row,
                        n_used: 8,
                        custom: true,
                        max_used: 9,
                    },
                );
            } else {
                // oneExtraConstraint: just fill col 24..26
                s_map[24][row] = c[0] as u32;
                s_map[25][row] = c[1] as u32;
                s_map[26][row] = c[2] as u32;
                // No partial row entry -- this slot is fully consumed
            }
        }
        LayoutKind::FinalVadcop => {
            if tier_offset == 1 {
                // fourExtraConstraints: nUsed=8, maxUsed=11
                for idx in 7..11 {
                    s_map[3 * idx][row] = c[0] as u32;
                    s_map[3 * idx + 1][row] = c[1] as u32;
                    s_map[3 * idx + 2][row] = c[2] as u32;
                }
                partial_rows.insert(
                    k.to_string(),
                    PartialRow {
                        row,
                        n_used: 8,
                        custom: true,
                        max_used: 11,
                    },
                );
            } else {
                // threeExtraConstraints: nUsed=9, maxUsed=11
                for idx in 8..11 {
                    s_map[3 * idx][row] = c[0] as u32;
                    s_map[3 * idx + 1][row] = c[1] as u32;
                    s_map[3 * idx + 2][row] = c[2] as u32;
                }
                partial_rows.insert(
                    k.to_string(),
                    PartialRow {
                        row,
                        n_used: 9,
                        custom: true,
                        max_used: 11,
                    },
                );
            }
        }
    }
}
