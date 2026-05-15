use std::collections::{BTreeMap, HashMap};
use std::fs;
use std::path::Path;

use anyhow::{bail, Result};

use crate::recursive_setup::r1cs::{CustomGateUse, LinearCombination, R1cs, GOLDILOCKS_P};

const GOLDILOCKS_K: u64 = 12_275_445_934_081_160_404;
const GOLDILOCKS_GEN: [u64; 33] = [
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

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PlonkProgram {
    pub constraints: Vec<PlonkConstraint>,
    pub additions: Vec<PlonkAddition>,
    pub n_vars: u32,
    pub custom_gates_info: CustomGatesInfo,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PlonkConstraint {
    pub sl: u32,
    pub sr: u32,
    pub so: u32,
    pub qm: u64,
    pub ql: u64,
    pub qr: u64,
    pub qo: u64,
    pub qc: u64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PlonkAddition {
    pub sl: u32,
    pub sr: u32,
    pub ql: u64,
    pub qr: u64,
}

#[derive(Debug, Default, Clone, PartialEq, Eq)]
pub struct CustomGatesInfo {
    pub cmul_id: Option<usize>,
    pub poseidon12_id: Option<usize>,
    pub cust_poseidon12_id: Option<usize>,
    pub ev_pol4_id: Option<usize>,
    pub tree_selector4_id: Option<usize>,
    pub select_val1_id: Option<usize>,
    pub fft4_parameters: HashMap<usize, Vec<u64>>,
    pub n_cmul: usize,
    pub n_poseidon12: usize,
    pub n_cust_poseidon12: usize,
    pub n_fft4: usize,
    pub n_ev_pol4: usize,
    pub n_tree_selector4: usize,
    pub n_select_val1: usize,
    pub n_plonk_rows: usize,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PlonkLayoutKind {
    Aggregation,
    Compressor,
    FinalVadcop,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PlonkLayoutShape {
    pub kind: PlonkLayoutKind,
    pub committed_pols: usize,
    pub n_bits: u32,
    pub n_rows: usize,
    pub n_used_rows: usize,
    pub n_publics: u32,
    pub n_plonk_constraints: usize,
    pub n_plonk_rows: usize,
    pub n_plonk_constraints_in_rows: usize,
    pub n_plonk_constraints_in_custom_rows: usize,
    pub n_additions: usize,
    pub n_cmul_rows: usize,
    pub n_poseidon12_rows: usize,
    pub n_cust_poseidon12_rows: usize,
    pub n_fft4_rows: usize,
    pub n_ev_pol4_rows: usize,
    pub n_tree_selector4_rows: usize,
    pub n_select_val1_rows: usize,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FixedColumn {
    pub name: String,
    pub lengths: Vec<u32>,
    pub values: Vec<u64>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PlonkLayout {
    pub shape: PlonkLayoutShape,
    pub signal_map: Vec<Vec<u32>>,
    pub fixed_columns: Vec<FixedColumn>,
    pub connections: usize,
}

pub fn r1cs_to_plonk(r1cs: &R1cs) -> Result<PlonkProgram> {
    let mut converter =
        Converter { constraints: Vec::new(), additions: Vec::new(), next_var: r1cs.n_vars };

    for constraint in &r1cs.constraints {
        converter.process(constraint.a.clone(), constraint.b.clone(), constraint.c.clone())?;
    }

    Ok(PlonkProgram {
        constraints: converter.constraints,
        additions: converter.additions,
        n_vars: converter.next_var,
        custom_gates_info: get_custom_gates_info(r1cs)?,
    })
}

pub fn calculate_layout_shape(r1cs: &R1cs, kind: PlonkLayoutKind) -> Result<PlonkLayoutShape> {
    let program = r1cs_to_plonk(r1cs)?;
    calculate_layout_shape_from_program(r1cs, &program, kind)
}

pub fn calculate_layout_shape_from_program(
    r1cs: &R1cs,
    program: &PlonkProgram,
    kind: PlonkLayoutKind,
) -> Result<PlonkLayoutShape> {
    let policy = LayoutPolicy::for_kind(kind);
    let counts = &program.custom_gates_info;
    let n_cmul_rows = ceil_div(counts.n_cmul, policy.cmul_per_row);
    let n_poseidon12_rows = counts.n_poseidon12 * policy.poseidon_rows_per_gate;
    let n_cust_poseidon12_rows = counts.n_cust_poseidon12 * policy.poseidon_rows_per_gate;
    let n_fft4_rows = counts.n_fft4;
    let n_ev_pol4_rows = counts.n_ev_pol4;
    let n_tree_selector4_rows = counts.n_tree_selector4;
    let n_select_val1_rows = counts.n_select_val1;

    let plonk_row_info =
        calculate_plonk_constraint_rows(&program.constraints, policy, &program.custom_gates_info);
    let n_used_rows = plonk_row_info.n_rows
        + n_cmul_rows
        + n_poseidon12_rows
        + n_cust_poseidon12_rows
        + n_fft4_rows
        + n_ev_pol4_rows
        + n_tree_selector4_rows
        + n_select_val1_rows;
    let n_bits = checked_domain_bits(n_used_rows)?;
    let n_rows = 1usize
        .checked_shl(n_bits)
        .ok_or_else(|| anyhow::anyhow!("recursive PLONK domain is too large"))?;

    Ok(PlonkLayoutShape {
        kind,
        committed_pols: policy.committed_pols,
        n_bits,
        n_rows,
        n_used_rows,
        n_publics: r1cs.n_outputs + r1cs.n_pub_inputs,
        n_plonk_constraints: program.constraints.len(),
        n_plonk_rows: plonk_row_info.n_rows,
        n_plonk_constraints_in_rows: plonk_row_info.constraints_in_rows,
        n_plonk_constraints_in_custom_rows: plonk_row_info.constraints_in_custom_rows,
        n_additions: program.additions.len(),
        n_cmul_rows,
        n_poseidon12_rows,
        n_cust_poseidon12_rows,
        n_fft4_rows,
        n_ev_pol4_rows,
        n_tree_selector4_rows,
        n_select_val1_rows,
    })
}

pub fn build_layout(r1cs: &R1cs, kind: PlonkLayoutKind, namespace: &str) -> Result<PlonkLayout> {
    let program = r1cs_to_plonk(r1cs)?;
    build_layout_from_program(r1cs, &program, kind, namespace)
}

pub fn build_layout_from_program(
    r1cs: &R1cs,
    program: &PlonkProgram,
    kind: PlonkLayoutKind,
    namespace: &str,
) -> Result<PlonkLayout> {
    let policy = LayoutPolicy::for_kind(kind);
    let shape = calculate_layout_shape_from_program(r1cs, program, kind)?;
    let mut signal_map = vec![vec![0u32; shape.n_rows]; policy.committed_pols];
    let mut c_cols = vec![vec![0u64; shape.n_rows]; 10];
    let mut extra_rows = vec![Vec::<usize>::new(), Vec::new(), Vec::new(), Vec::new()];
    let mut row = 0usize;

    for gate_use in gate_uses(r1cs, program.custom_gates_info.poseidon12_id) {
        place_poseidon_gate(&mut signal_map, gate_use, row, policy, false)?;
        push_poseidon_extra_rows(&mut extra_rows, row, policy);
        row += policy.poseidon_rows_per_gate;
    }

    for gate_use in gate_uses(r1cs, program.custom_gates_info.cust_poseidon12_id) {
        place_poseidon_gate(&mut signal_map, gate_use, row, policy, true)?;
        push_poseidon_extra_rows(&mut extra_rows, row, policy);
        row += policy.poseidon_rows_per_gate;
    }

    place_cmul_gates(
        &mut signal_map,
        &gate_uses(r1cs, program.custom_gates_info.cmul_id),
        &mut row,
        policy,
    )?;

    for gate_use in gate_uses(r1cs, program.custom_gates_info.ev_pol4_id) {
        ensure_signal_len(gate_use, 21, "EvPol4")?;
        copy_signals(&mut signal_map, row, 0, &gate_use.signals[..21])?;
        extra_rows[2].push(row);
        row += 1;
    }

    for gate_use in fft4_gate_uses(r1cs, &program.custom_gates_info) {
        ensure_signal_len(gate_use, 24, "FFT4")?;
        copy_signals(&mut signal_map, row, 0, &gate_use.signals[..24])?;
        place_fft4_constants(&mut c_cols, row, gate_use, &program.custom_gates_info)?;
        row += 1;
    }

    for gate_use in gate_uses(r1cs, program.custom_gates_info.tree_selector4_id) {
        ensure_signal_len(gate_use, 17, "TreeSelector4")?;
        copy_signals(&mut signal_map, row, 0, &gate_use.signals[..17])?;
        extra_rows[1].push(row);
        row += 1;
    }

    for gate_use in gate_uses(r1cs, program.custom_gates_info.select_val1_id) {
        ensure_signal_len(gate_use, 22, "SelectValue1")?;
        copy_signals(&mut signal_map, row, 0, &gate_use.signals[..22])?;
        extra_rows[3].push(row);
        row += 1;
    }

    place_plonk_constraints(
        &mut signal_map,
        &mut c_cols,
        &program.constraints,
        &mut row,
        policy,
        &mut extra_rows,
    )?;

    if row != shape.n_used_rows {
        bail!("recursive PLONK layout used {row} rows but expected {}", shape.n_used_rows);
    }

    let (s_cols, connections) = build_connection_polynomials(&signal_map, row, policy)?;
    let fixed_columns =
        build_fixed_columns(namespace, &shape, policy, s_cols, c_cols, &program.custom_gates_info)?;

    Ok(PlonkLayout { shape, signal_map, fixed_columns, connections })
}

pub fn write_exec_buffer(additions: &[PlonkAddition], signal_map: &[Vec<u32>]) -> Result<Vec<u8>> {
    if signal_map.is_empty() {
        bail!("cannot write exec file for empty signal map");
    }
    let n_rows = signal_map[0].len();
    if signal_map.iter().any(|col| col.len() != n_rows) {
        bail!("all signal-map columns must have the same row count");
    }

    let n_words = 2 + additions.len() * 4 + signal_map.len() * n_rows;
    let mut out = Vec::with_capacity(n_words * 8);
    push_u64(&mut out, additions.len() as u64);
    push_u64(&mut out, n_rows as u64);

    for addition in additions {
        push_u64(&mut out, addition.sl as u64);
        push_u64(&mut out, addition.sr as u64);
        push_u64(&mut out, addition.ql);
        push_u64(&mut out, addition.qr);
    }

    for row in 0..n_rows {
        for col in signal_map {
            push_u64(&mut out, col[row] as u64);
        }
    }

    Ok(out)
}

pub fn write_exec_file(
    path: &Path,
    additions: &[PlonkAddition],
    signal_map: &[Vec<u32>],
) -> Result<()> {
    fs::write(path, write_exec_buffer(additions, signal_map)?)
        .map_err(|err| anyhow::anyhow!("failed to write {}: {err}", path.display()))
}

pub fn write_const_buffer(fixed_columns: &[FixedColumn]) -> Result<Vec<u8>> {
    if fixed_columns.is_empty() {
        bail!("cannot write const file with no fixed columns");
    }
    let n_rows = fixed_columns[0].values.len();
    if fixed_columns.iter().any(|column| column.values.len() != n_rows) {
        bail!("all fixed columns must have the same row count");
    }

    let mut out = Vec::with_capacity(n_rows * fixed_columns.len() * 8);
    for row in 0..n_rows {
        for column in fixed_columns {
            push_u64(&mut out, column.values[row]);
        }
    }
    Ok(out)
}

pub fn write_const_file(path: &Path, fixed_columns: &[FixedColumn]) -> Result<()> {
    fs::write(path, write_const_buffer(fixed_columns)?)
        .map_err(|err| anyhow::anyhow!("failed to write {}: {err}", path.display()))
}

struct Converter {
    constraints: Vec<PlonkConstraint>,
    additions: Vec<PlonkAddition>,
    next_var: u32,
}

#[derive(Debug, Clone, Copy)]
struct LayoutPolicy {
    committed_pols: usize,
    connection_cols: usize,
    cmul_per_row: usize,
    poseidon_rows_per_gate: usize,
    poseidon_first_col: usize,
    normal_first_row_max: usize,
    normal_remainder_start: usize,
    normal_remainder_max: usize,
    custom_rules: [ExtraRule; 4],
}

impl LayoutPolicy {
    fn for_kind(kind: PlonkLayoutKind) -> Self {
        match kind {
            PlonkLayoutKind::Aggregation => Self {
                committed_pols: 59,
                connection_cols: 27,
                cmul_per_row: 3,
                poseidon_rows_per_gate: 5,
                poseidon_first_col: 27,
                normal_first_row_max: 2,
                normal_remainder_start: 2,
                normal_remainder_max: 9,
                custom_rules: [
                    ExtraRule::Split { initial_max: 2, remainder_start: 2, remainder_max: 9 },
                    ExtraRule::Partial { used_after_current: 7, max_used: 9 },
                    ExtraRule::Partial { used_after_current: 8, max_used: 9 },
                    ExtraRule::Single,
                ],
            },
            PlonkLayoutKind::Compressor => Self {
                committed_pols: 52,
                connection_cols: 36,
                cmul_per_row: 4,
                poseidon_rows_per_gate: 10,
                poseidon_first_col: 36,
                normal_first_row_max: 6,
                normal_remainder_start: 6,
                normal_remainder_max: 12,
                custom_rules: [
                    ExtraRule::Split { initial_max: 6, remainder_start: 6, remainder_max: 12 },
                    ExtraRule::Partial { used_after_current: 7, max_used: 12 },
                    ExtraRule::Partial { used_after_current: 8, max_used: 12 },
                    ExtraRule::Partial { used_after_current: 9, max_used: 12 },
                ],
            },
            PlonkLayoutKind::FinalVadcop => Self {
                committed_pols: 65,
                connection_cols: 33,
                cmul_per_row: 3,
                poseidon_rows_per_gate: 5,
                poseidon_first_col: 33,
                normal_first_row_max: 2,
                normal_remainder_start: 2,
                normal_remainder_max: 11,
                custom_rules: [
                    ExtraRule::Split { initial_max: 2, remainder_start: 2, remainder_max: 11 },
                    ExtraRule::Partial { used_after_current: 7, max_used: 11 },
                    ExtraRule::Partial { used_after_current: 8, max_used: 11 },
                    ExtraRule::Partial { used_after_current: 9, max_used: 11 },
                ],
            },
        }
    }
}

#[derive(Debug, Clone, Copy)]
enum ExtraRule {
    Split { initial_max: usize, remainder_start: usize, remainder_max: usize },
    Partial { used_after_current: usize, max_used: usize },
    Single,
}

#[derive(Debug, Clone, Copy)]
struct PartialRow {
    n_used: usize,
    custom: bool,
    max_used: usize,
}

#[derive(Debug, Default, PartialEq, Eq)]
struct PlonkRowInfo {
    n_rows: usize,
    constraints_in_rows: usize,
    constraints_in_custom_rows: usize,
}

fn calculate_plonk_constraint_rows(
    constraints: &[PlonkConstraint],
    policy: LayoutPolicy,
    custom_gates_info: &CustomGatesInfo,
) -> PlonkRowInfo {
    let n_poseidon = custom_gates_info.n_poseidon12 + custom_gates_info.n_cust_poseidon12;
    let mut extra_counts = match policy.committed_pols {
        59 => [
            n_poseidon * 3,
            n_poseidon + custom_gates_info.n_tree_selector4,
            custom_gates_info.n_ev_pol4,
            n_poseidon + custom_gates_info.n_select_val1,
        ],
        52 => [
            n_poseidon * 8,
            n_poseidon + custom_gates_info.n_tree_selector4,
            custom_gates_info.n_ev_pol4,
            n_poseidon + custom_gates_info.n_select_val1,
        ],
        65 => [
            n_poseidon * 3,
            n_poseidon + custom_gates_info.n_tree_selector4,
            custom_gates_info.n_ev_pol4,
            n_poseidon + custom_gates_info.n_select_val1,
        ],
        _ => unreachable!("unknown recursive PLONK layout"),
    };

    let mut partial_rows: HashMap<[u64; 5], PartialRow> = HashMap::new();
    let mut remainder_rows: Vec<PartialRow> = Vec::new();
    let mut info = PlonkRowInfo::default();

    for constraint in constraints {
        let key = [constraint.qm, constraint.ql, constraint.qr, constraint.qo, constraint.qc];
        if let Some(row) = partial_rows.get_mut(&key) {
            count_constraint(&mut info, row.custom);
            row.n_used += 1;
            if row.n_used == row.max_used {
                partial_rows.remove(&key);
            }
        } else if !remainder_rows.is_empty() {
            let mut row = remainder_rows.remove(0);
            row.n_used += 1;
            count_constraint(&mut info, row.custom);
            partial_rows.insert(key, row);
        } else if let Some((idx, _)) =
            extra_counts.iter().enumerate().find(|(_, count)| **count > 0)
        {
            extra_counts[idx] -= 1;
            count_constraint(&mut info, true);
            match policy.custom_rules[idx] {
                ExtraRule::Split { initial_max, remainder_start, remainder_max } => {
                    partial_rows
                        .insert(key, PartialRow { n_used: 1, custom: true, max_used: initial_max });
                    remainder_rows.push(PartialRow {
                        n_used: remainder_start,
                        custom: true,
                        max_used: remainder_max,
                    });
                }
                ExtraRule::Partial { used_after_current, max_used } => {
                    partial_rows.insert(
                        key,
                        PartialRow { n_used: used_after_current, custom: true, max_used },
                    );
                }
                ExtraRule::Single => {}
            }
        } else {
            count_constraint(&mut info, false);
            info.n_rows += 1;
            partial_rows.insert(
                key,
                PartialRow { n_used: 1, custom: false, max_used: policy.normal_first_row_max },
            );
            remainder_rows.push(PartialRow {
                n_used: policy.normal_remainder_start,
                custom: false,
                max_used: policy.normal_remainder_max,
            });
        }
    }

    info
}

fn count_constraint(info: &mut PlonkRowInfo, custom: bool) {
    if custom {
        info.constraints_in_custom_rows += 1;
    } else {
        info.constraints_in_rows += 1;
    }
}

fn checked_domain_bits(n_used_rows: usize) -> Result<u32> {
    if n_used_rows == 0 {
        bail!("recursive PLONK layout has no rows");
    }
    Ok(usize::BITS - (n_used_rows - 1).leading_zeros())
}

fn ceil_div(value: usize, divisor: usize) -> usize {
    if value == 0 {
        0
    } else {
        1 + (value - 1) / divisor
    }
}

fn gate_uses(r1cs: &R1cs, id: Option<usize>) -> Vec<&CustomGateUse> {
    r1cs.custom_gate_uses.iter().filter(|gate_use| Some(gate_use.id as usize) == id).collect()
}

fn fft4_gate_uses<'a>(r1cs: &'a R1cs, info: &CustomGatesInfo) -> Vec<&'a CustomGateUse> {
    r1cs.custom_gate_uses
        .iter()
        .filter(|gate_use| info.fft4_parameters.contains_key(&(gate_use.id as usize)))
        .collect()
}

fn ensure_signal_len(gate_use: &CustomGateUse, expected: usize, gate: &str) -> Result<()> {
    if gate_use.signals.len() != expected {
        bail!(
            "{gate} custom gate use must have {expected} signals, got {}",
            gate_use.signals.len()
        );
    }
    Ok(())
}

fn copy_signals(
    signal_map: &mut [Vec<u32>],
    row: usize,
    start_col: usize,
    signals: &[u64],
) -> Result<()> {
    if start_col + signals.len() > signal_map.len() {
        bail!("signal map write exceeds committed-polynomial width");
    }
    for (offset, &signal) in signals.iter().enumerate() {
        signal_map[start_col + offset][row] = checked_signal(signal)?;
    }
    Ok(())
}

fn checked_signal(signal: u64) -> Result<u32> {
    u32::try_from(signal).map_err(|_| anyhow::anyhow!("R1CS signal id {signal} exceeds u32"))
}

fn place_poseidon_gate(
    signal_map: &mut [Vec<u32>],
    gate_use: &CustomGateUse,
    row: usize,
    policy: LayoutPolicy,
    custom: bool,
) -> Result<()> {
    let expected = if custom { 14 * 16 + 2 } else { 14 * 16 };
    ensure_signal_len(gate_use, expected, if custom { "CustPoseidon16" } else { "Poseidon16" })?;
    let signals = &gate_use.signals;
    let first_col = policy.poseidon_first_col;

    let (input, rest) = signals.split_at(16);
    let (first_bit, second_bit, rest) =
        if custom { (Some(rest[0]), Some(rest[1]), &rest[2..]) } else { (None, None, rest) };

    let round0 = &rest[0..16];
    let round1 = &rest[16..32];
    let round2 = &rest[32..48];
    let round3 = &rest[48..64];
    let round4 = &rest[64..80];
    let im1 = &rest[80..96];
    let im2 = &rest[112..128];
    let round26 = &rest[128..144];
    let round27 = &rest[144..160];
    let round28 = &rest[160..176];
    let round29 = &rest[176..192];
    let output = &rest[192..208];

    if policy.poseidon_rows_per_gate == 10 {
        for i in 0..16 {
            signal_map[i][row] = checked_signal(input[i])?;
            signal_map[first_col + i][row] = checked_signal(round0[i])?;
            signal_map[first_col + i][row + 1] = checked_signal(round1[i])?;
            signal_map[first_col + i][row + 2] = checked_signal(round2[i])?;
            signal_map[first_col + i][row + 3] = checked_signal(round3[i])?;
            signal_map[first_col + i][row + 4] = checked_signal(round4[i])?;
            signal_map[first_col + i][row + 6] = checked_signal(round26[i])?;
            signal_map[first_col + i][row + 7] = checked_signal(round27[i])?;
            signal_map[first_col + i][row + 8] = checked_signal(round28[i])?;
            signal_map[first_col + i][row + 9] = checked_signal(round29[i])?;
            signal_map[i][row + 9] = checked_signal(output[i])?;
        }
        for i in 0..11 {
            signal_map[first_col + i][row + 5] = checked_signal(im1[i])?;
            if i < 5 {
                signal_map[first_col + 11 + i][row + 5] = checked_signal(im2[i])?;
            } else {
                signal_map[18 + i - 5][row] = checked_signal(im2[i])?;
            }
        }
    } else {
        for i in 0..16 {
            signal_map[i][row] = checked_signal(input[i])?;
            signal_map[first_col + i][row] = checked_signal(round0[i])?;
            signal_map[first_col + 16 + i][row] = checked_signal(round1[i])?;
            signal_map[first_col + i][row + 1] = checked_signal(round2[i])?;
            signal_map[first_col + 16 + i][row + 1] = checked_signal(round3[i])?;
            signal_map[first_col + i][row + 2] = checked_signal(round4[i])?;
            signal_map[first_col + i][row + 3] = checked_signal(round26[i])?;
            signal_map[first_col + 16 + i][row + 3] = checked_signal(round27[i])?;
            signal_map[first_col + i][row + 4] = checked_signal(round28[i])?;
            signal_map[first_col + 16 + i][row + 4] = checked_signal(round29[i])?;
            signal_map[i][row + 4] = checked_signal(output[i])?;
        }
        for i in 0..11 {
            signal_map[first_col + 16 + i][row + 2] = checked_signal(im1[i])?;
            if i < 5 {
                signal_map[first_col + 27 + i][row + 2] = checked_signal(im2[i])?;
            } else {
                signal_map[18 + i - 5][row] = checked_signal(im2[i])?;
            }
        }
    }

    if let Some(first_bit) = first_bit {
        signal_map[16][row] = checked_signal(first_bit)?;
    }
    if let Some(second_bit) = second_bit {
        signal_map[17][row] = checked_signal(second_bit)?;
    }
    Ok(())
}

fn push_poseidon_extra_rows(extra_rows: &mut [Vec<usize>], row: usize, policy: LayoutPolicy) {
    if policy.poseidon_rows_per_gate == 10 {
        extra_rows[3].push(row);
        for offset in 1..=8 {
            extra_rows[0].push(row + offset);
        }
        extra_rows[1].push(row + 9);
    } else {
        extra_rows[3].push(row);
        extra_rows[0].push(row + 1);
        extra_rows[0].push(row + 2);
        extra_rows[0].push(row + 3);
        extra_rows[1].push(row + 4);
    }
}

fn place_cmul_gates(
    signal_map: &mut [Vec<u32>],
    gate_uses: &[&CustomGateUse],
    row: &mut usize,
    policy: LayoutPolicy,
) -> Result<()> {
    let mut partial_row = None::<(usize, usize)>;
    for gate_use in gate_uses {
        ensure_signal_len(gate_use, 9, "CMul")?;
        if let Some((target_row, n_used)) = partial_row {
            copy_signals(signal_map, target_row, 9 * n_used, &gate_use.signals)?;
            let next_used = n_used + 1;
            if next_used == policy.cmul_per_row {
                partial_row = None;
            } else {
                partial_row = Some((target_row, next_used));
            }
        } else {
            copy_signals(signal_map, *row, 0, &gate_use.signals)?;
            partial_row = Some((*row, 1));
            *row += 1;
        }
    }
    Ok(())
}

fn place_fft4_constants(
    c_cols: &mut [Vec<u64>],
    row: usize,
    gate_use: &CustomGateUse,
    info: &CustomGatesInfo,
) -> Result<()> {
    let parameters = info
        .fft4_parameters
        .get(&(gate_use.id as usize))
        .ok_or_else(|| anyhow::anyhow!("FFT4 parameters missing for gate id {}", gate_use.id))?;
    if parameters.len() != 4 {
        bail!("FFT4 custom gate must have 4 parameters");
    }
    let first_w = parameters[0];
    let inc_w = parameters[1];
    let scale = parameters[2];
    let fft_type = parameters[3];
    let first_w2 = mul_mod(first_w, first_w);
    if fft_type == 4 {
        c_cols[0][row] = scale;
        c_cols[1][row] = mul_mod(scale, first_w2);
        c_cols[2][row] = mul_mod(scale, first_w);
        c_cols[3][row] = mul_mod(mul_mod(scale, first_w), first_w2);
        c_cols[4][row] = mul_mod(mul_mod(scale, first_w), inc_w);
        c_cols[5][row] = mul_mod(mul_mod(mul_mod(scale, first_w), first_w2), inc_w);
    } else if fft_type == 2 {
        c_cols[6][row] = scale;
        c_cols[7][row] = mul_mod(scale, first_w);
        c_cols[8][row] = mul_mod(mul_mod(scale, first_w), inc_w);
    } else {
        bail!("invalid FFT4 type {fft_type}");
    }
    Ok(())
}

fn place_plonk_constraints(
    signal_map: &mut [Vec<u32>],
    c_cols: &mut [Vec<u64>],
    constraints: &[PlonkConstraint],
    row: &mut usize,
    policy: LayoutPolicy,
    extra_rows: &mut [Vec<usize>],
) -> Result<()> {
    let mut partial_rows: HashMap<[u64; 5], PartialPlacement> = HashMap::new();
    let mut remainder_rows: Vec<PartialPlacement> = Vec::new();

    for constraint in constraints {
        let key = [constraint.qm, constraint.ql, constraint.qr, constraint.qo, constraint.qc];
        if let Some(placement) = partial_rows.get_mut(&key) {
            fill_constraint_slots(
                signal_map,
                placement.row,
                placement.n_used,
                placement.n_used + 1,
                constraint,
            )?;
            placement.n_used += 1;
            if placement.n_used == placement.max_used {
                partial_rows.remove(&key);
            }
        } else if !remainder_rows.is_empty() {
            let mut placement = remainder_rows.remove(0);
            set_q(c_cols, placement.row, 5, constraint);
            fill_constraint_slots(
                signal_map,
                placement.row,
                placement.n_used,
                placement.max_used,
                constraint,
            )?;
            placement.n_used += 1;
            partial_rows.insert(key, placement);
        } else if let Some((idx, rows)) =
            extra_rows.iter_mut().enumerate().find(|(_, rows)| !rows.is_empty())
        {
            let target_row = rows.remove(0);
            match policy.custom_rules[idx] {
                ExtraRule::Split { initial_max, remainder_start, remainder_max } => {
                    set_q(c_cols, target_row, 0, constraint);
                    fill_constraint_slots(signal_map, target_row, 0, remainder_start, constraint)?;
                    partial_rows.insert(
                        key,
                        PartialPlacement { row: target_row, n_used: 1, max_used: initial_max },
                    );
                    remainder_rows.push(PartialPlacement {
                        row: target_row,
                        n_used: remainder_start,
                        max_used: remainder_max,
                    });
                }
                ExtraRule::Partial { used_after_current, max_used } => {
                    set_q(c_cols, target_row, 5, constraint);
                    fill_constraint_slots(
                        signal_map,
                        target_row,
                        used_after_current - 1,
                        max_used,
                        constraint,
                    )?;
                    partial_rows.insert(
                        key,
                        PartialPlacement { row: target_row, n_used: used_after_current, max_used },
                    );
                }
                ExtraRule::Single => {
                    set_q(c_cols, target_row, 5, constraint);
                    fill_constraint_slots(
                        signal_map,
                        target_row,
                        policy.normal_remainder_max - 1,
                        policy.normal_remainder_max,
                        constraint,
                    )?;
                }
            }
        } else {
            set_q(c_cols, *row, 0, constraint);
            fill_constraint_slots(signal_map, *row, 0, policy.normal_remainder_start, constraint)?;
            partial_rows.insert(
                key,
                PartialPlacement { row: *row, n_used: 1, max_used: policy.normal_first_row_max },
            );
            remainder_rows.push(PartialPlacement {
                row: *row,
                n_used: policy.normal_remainder_start,
                max_used: policy.normal_remainder_max,
            });
            *row += 1;
        }
    }

    Ok(())
}

#[derive(Debug, Clone, Copy)]
struct PartialPlacement {
    row: usize,
    n_used: usize,
    max_used: usize,
}

fn set_q(c_cols: &mut [Vec<u64>], row: usize, offset: usize, constraint: &PlonkConstraint) {
    c_cols[offset][row] = constraint.qm;
    c_cols[offset + 1][row] = constraint.ql;
    c_cols[offset + 2][row] = constraint.qr;
    c_cols[offset + 3][row] = constraint.qo;
    c_cols[offset + 4][row] = constraint.qc;
}

fn fill_constraint_slots(
    signal_map: &mut [Vec<u32>],
    row: usize,
    start_slot: usize,
    end_slot: usize,
    constraint: &PlonkConstraint,
) -> Result<()> {
    for slot in start_slot..end_slot {
        let col = 3 * slot;
        if col + 2 >= signal_map.len() {
            bail!("PLONK constraint slot {slot} exceeds committed-polynomial width");
        }
        signal_map[col][row] = constraint.sl;
        signal_map[col + 1][row] = constraint.sr;
        signal_map[col + 2][row] = constraint.so;
    }
    Ok(())
}

fn build_connection_polynomials(
    signal_map: &[Vec<u32>],
    used_rows: usize,
    policy: LayoutPolicy,
) -> Result<(Vec<Vec<u64>>, usize)> {
    let n_rows = signal_map.first().map(|col| col.len()).unwrap_or(0);
    let mut s_cols = vec![vec![0u64; n_rows]; policy.connection_cols];
    let ks = get_ks(policy.connection_cols - 1);
    let generator = *GOLDILOCKS_GEN
        .get(checked_domain_bits(n_rows)? as usize)
        .ok_or_else(|| anyhow::anyhow!("recursive PLONK domain exceeds Goldilocks generators"))?;
    let mut w = 1;
    for row in 0..n_rows {
        s_cols[0][row] = w;
        for col in 1..policy.connection_cols {
            s_cols[col][row] = mul_mod(w, ks[col - 1]);
        }
        w = mul_mod(w, generator);
    }

    let mut connections = 0;
    let mut last_signal = HashMap::<u32, (usize, usize)>::new();
    for row in 0..used_rows {
        for col in 0..policy.connection_cols {
            let signal = signal_map[col][row];
            if signal == 0 {
                continue;
            }
            if let Some(&(last_col, last_row)) = last_signal.get(&signal) {
                connections += 1;
                let tmp = s_cols[last_col][last_row];
                s_cols[last_col][last_row] = s_cols[col][row];
                s_cols[col][row] = tmp;
            } else {
                last_signal.insert(signal, (col, row));
            }
        }
    }
    Ok((s_cols, connections))
}

fn build_fixed_columns(
    namespace: &str,
    shape: &PlonkLayoutShape,
    policy: LayoutPolicy,
    s_cols: Vec<Vec<u64>>,
    c_cols: Vec<Vec<u64>>,
    custom_gates_info: &CustomGatesInfo,
) -> Result<Vec<FixedColumn>> {
    let mut out = Vec::new();
    for (idx, values) in s_cols.into_iter().enumerate() {
        out.push(FixedColumn { name: format!("{namespace}.S"), lengths: vec![idx as u32], values });
    }
    for (idx, values) in c_cols.into_iter().enumerate() {
        out.push(FixedColumn { name: format!("{namespace}.C"), lengths: vec![idx as u32], values });
    }

    out.push(flag_column(namespace, "POSEIDONSPONGE", shape.n_rows, |row| {
        row < custom_gates_info.n_poseidon12 * policy.poseidon_rows_per_gate
            && row % policy.poseidon_rows_per_gate == 0
    }));
    out.push(flag_column(namespace, "POSEIDONCOMPRESSION", shape.n_rows, |row| {
        row >= custom_gates_info.n_poseidon12 * policy.poseidon_rows_per_gate
            && row
                < (custom_gates_info.n_poseidon12 + custom_gates_info.n_cust_poseidon12)
                    * policy.poseidon_rows_per_gate
            && row % policy.poseidon_rows_per_gate == 0
    }));
    out.push(flag_column(namespace, "POSEIDON_PARTIAL_ROUND", shape.n_rows, |row| {
        row < (custom_gates_info.n_poseidon12 + custom_gates_info.n_cust_poseidon12)
            * policy.poseidon_rows_per_gate
            && row % policy.poseidon_rows_per_gate == policy.poseidon_rows_per_gate / 2
    }));
    out.push(flag_column(namespace, "POSEIDON_FINAL", shape.n_rows, |row| {
        row < (custom_gates_info.n_poseidon12 + custom_gates_info.n_cust_poseidon12)
            * policy.poseidon_rows_per_gate
            && row % policy.poseidon_rows_per_gate == policy.poseidon_rows_per_gate - 1
    }));

    let mut start = (custom_gates_info.n_poseidon12 + custom_gates_info.n_cust_poseidon12)
        * policy.poseidon_rows_per_gate;
    push_range_flag(&mut out, namespace, "CMUL", shape.n_rows, start, shape.n_cmul_rows);
    start += shape.n_cmul_rows;
    push_range_flag(&mut out, namespace, "EVPOL4", shape.n_rows, start, shape.n_ev_pol4_rows);
    start += shape.n_ev_pol4_rows;
    push_range_flag(&mut out, namespace, "FFT4", shape.n_rows, start, shape.n_fft4_rows);
    start += shape.n_fft4_rows;
    push_range_flag(
        &mut out,
        namespace,
        "TREESELECTOR4",
        shape.n_rows,
        start,
        shape.n_tree_selector4_rows,
    );
    start += shape.n_tree_selector4_rows;
    push_range_flag(
        &mut out,
        namespace,
        "SELECTVAL1",
        shape.n_rows,
        start,
        shape.n_select_val1_rows,
    );
    start += shape.n_select_val1_rows;
    push_range_flag(&mut out, namespace, "PLONK", shape.n_rows, start, shape.n_plonk_rows);

    out.push(id_column(namespace, shape.n_rows)?);
    out.push(l1_column(shape.n_rows));
    Ok(out)
}

fn flag_column(
    namespace: &str,
    name: &str,
    n_rows: usize,
    predicate: impl Fn(usize) -> bool,
) -> FixedColumn {
    let mut values = vec![0; n_rows];
    for (row, value) in values.iter_mut().enumerate() {
        if predicate(row) {
            *value = 1;
        }
    }
    FixedColumn { name: format!("{namespace}.{name}"), lengths: Vec::new(), values }
}

fn push_range_flag(
    out: &mut Vec<FixedColumn>,
    namespace: &str,
    name: &str,
    n_rows: usize,
    start: usize,
    len: usize,
) {
    out.push(flag_column(namespace, name, n_rows, |row| row >= start && row < start + len));
}

fn id_column(namespace: &str, n_rows: usize) -> Result<FixedColumn> {
    let n_bits = checked_domain_bits(n_rows)?;
    let generator = *GOLDILOCKS_GEN
        .get(n_bits as usize)
        .ok_or_else(|| anyhow::anyhow!("recursive PLONK domain exceeds Goldilocks generators"))?;
    let mut values = vec![0; n_rows];
    let mut w = 1;
    for value in &mut values {
        *value = w;
        w = mul_mod(w, generator);
    }
    Ok(FixedColumn { name: format!("{namespace}.ID"), lengths: Vec::new(), values })
}

fn l1_column(n_rows: usize) -> FixedColumn {
    let mut values = vec![0; n_rows];
    if let Some(first) = values.first_mut() {
        *first = 1;
    }
    FixedColumn { name: "__L1__".to_string(), lengths: Vec::new(), values }
}

fn get_ks(n: usize) -> Vec<u64> {
    let mut ks = Vec::with_capacity(n);
    if n == 0 {
        return ks;
    }
    ks.push(GOLDILOCKS_K);
    for idx in 1..n {
        ks.push(mul_mod(ks[idx - 1], GOLDILOCKS_K));
    }
    ks
}

impl Converter {
    fn process(
        &mut self,
        mut a: LinearCombination,
        mut b: LinearCombination,
        mut c: LinearCombination,
    ) -> Result<()> {
        let a_type = lc_type(&mut a);
        let b_type = lc_type(&mut b);
        if a_type == LcType::Zero || b_type == LcType::Zero {
            normalize(&mut c);
            self.add_constraint_sum(&c)?;
        } else if let LcType::Constant(k) = a_type {
            let joined = join(&b, k, &c);
            self.add_constraint_sum(&joined)?;
        } else if let LcType::Constant(k) = b_type {
            let joined = join(&a, k, &c);
            self.add_constraint_sum(&joined)?;
        } else {
            self.add_constraint_mul(&a, &b, &c)?;
        }
        Ok(())
    }

    fn add_constraint_sum(&mut self, lc: &LinearCombination) -> Result<()> {
        let reduced = self.reduce_coefs(lc, 3)?;
        self.constraints.push(PlonkConstraint {
            sl: reduced.signals[0],
            sr: reduced.signals[1],
            so: reduced.signals[2],
            qm: 0,
            ql: reduced.coefs[0],
            qr: reduced.coefs[1],
            qo: reduced.coefs[2],
            qc: reduced.constant,
        });
        Ok(())
    }

    fn add_constraint_mul(
        &mut self,
        a_lc: &LinearCombination,
        b_lc: &LinearCombination,
        c_lc: &LinearCombination,
    ) -> Result<()> {
        let a = self.reduce_coefs(a_lc, 1)?;
        let b = self.reduce_coefs(b_lc, 1)?;
        let c = self.reduce_coefs(c_lc, 1)?;

        let qm = mul_mod(a.coefs[0], b.coefs[0]);
        let ql = mul_mod(a.coefs[0], b.constant);
        let qr = mul_mod(a.constant, b.coefs[0]);
        let qo = neg_mod(c.coefs[0]);
        let qc = sub_mod(mul_mod(a.constant, b.constant), c.constant);

        self.constraints.push(PlonkConstraint {
            sl: a.signals[0],
            sr: b.signals[0],
            so: c.signals[0],
            qm,
            ql,
            qr,
            qo,
            qc,
        });
        Ok(())
    }

    fn reduce_coefs(&mut self, lc: &LinearCombination, max_coefs: usize) -> Result<ReducedCoefs> {
        let mut constant = 0;
        let mut coefs = Vec::new();
        for (&signal, &value) in lc {
            if signal == 0 {
                constant = add_mod(constant, value);
            } else if value != 0 {
                coefs.push((signal, value));
            }
        }

        while coefs.len() > max_coefs {
            let (sl, ql) = coefs.remove(0);
            let (sr, qr) = coefs.remove(0);
            let so = self.next_var;
            self.next_var = self
                .next_var
                .checked_add(1)
                .ok_or_else(|| anyhow::anyhow!("PLONK variable id overflow"))?;

            self.constraints.push(PlonkConstraint {
                sl,
                sr,
                so,
                qm: 0,
                ql: neg_mod(ql),
                qr: neg_mod(qr),
                qo: 1,
                qc: 0,
            });
            self.additions.push(PlonkAddition { sl, sr, ql, qr });
            coefs.push((so, 1));
        }

        let mut signals = Vec::with_capacity(max_coefs);
        let mut reduced_coefs = Vec::with_capacity(max_coefs);
        for (signal, value) in coefs {
            signals.push(signal);
            reduced_coefs.push(value);
        }
        while signals.len() < max_coefs {
            signals.push(0);
            reduced_coefs.push(0);
        }

        Ok(ReducedCoefs { constant, signals, coefs: reduced_coefs })
    }
}

#[derive(Debug)]
struct ReducedCoefs {
    constant: u64,
    signals: Vec<u32>,
    coefs: Vec<u64>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum LcType {
    Zero,
    Constant(u64),
    Signals,
}

fn lc_type(lc: &mut LinearCombination) -> LcType {
    normalize(lc);
    let constant = lc.get(&0).copied().unwrap_or(0);
    let n_signals = lc.keys().filter(|&&signal| signal != 0).count();
    if n_signals > 0 {
        LcType::Signals
    } else if constant != 0 {
        LcType::Constant(constant)
    } else {
        LcType::Zero
    }
}

fn join(lc1: &LinearCombination, k: u64, lc2: &LinearCombination) -> LinearCombination {
    let mut out = BTreeMap::new();
    for (&signal, &value) in lc1 {
        out.insert(signal, mul_mod(k, value));
    }
    for (&signal, &value) in lc2 {
        let entry = out.entry(signal).or_insert(0);
        *entry = sub_mod(*entry, value);
    }
    normalize(&mut out);
    out
}

fn normalize(lc: &mut LinearCombination) {
    lc.retain(|_, value| *value != 0);
}

pub fn get_custom_gates_info(r1cs: &R1cs) -> Result<CustomGatesInfo> {
    let mut info = CustomGatesInfo::default();
    for (id, gate) in r1cs.custom_gates.iter().enumerate() {
        match gate.template_name.as_str() {
            "CMul" => {
                ensure_no_parameters(&gate.parameters, &gate.template_name)?;
                info.cmul_id = Some(id);
            }
            "Poseidon16" => info.poseidon12_id = Some(id),
            "CustPoseidon16" => info.cust_poseidon12_id = Some(id),
            "EvPol4" => {
                ensure_no_parameters(&gate.parameters, &gate.template_name)?;
                info.ev_pol4_id = Some(id);
            }
            "TreeSelector4" => {
                ensure_no_parameters(&gate.parameters, &gate.template_name)?;
                info.tree_selector4_id = Some(id);
            }
            "SelectValue1" => {
                ensure_no_parameters(&gate.parameters, &gate.template_name)?;
                info.select_val1_id = Some(id);
            }
            "FFT4" => {
                if gate.parameters.len() != 4 {
                    bail!("FFT4 custom gate must have 4 parameters");
                }
                info.fft4_parameters.insert(id, gate.parameters.clone());
            }
            other => bail!("invalid custom gate template {other}"),
        }
    }

    for gate_use in &r1cs.custom_gate_uses {
        count_gate_use(&mut info, gate_use)?;
    }

    Ok(info)
}

fn count_gate_use(info: &mut CustomGatesInfo, gate_use: &CustomGateUse) -> Result<()> {
    let id = gate_use.id as usize;
    if Some(id) == info.cmul_id {
        info.n_cmul += 1;
    } else if Some(id) == info.poseidon12_id {
        info.n_poseidon12 += 1;
    } else if Some(id) == info.cust_poseidon12_id {
        info.n_cust_poseidon12 += 1;
    } else if info.fft4_parameters.contains_key(&id) {
        info.n_fft4 += 1;
    } else if Some(id) == info.ev_pol4_id {
        info.n_ev_pol4 += 1;
    } else if Some(id) == info.tree_selector4_id {
        info.n_tree_selector4 += 1;
    } else if Some(id) == info.select_val1_id {
        info.n_select_val1 += 1;
    } else {
        bail!("custom gate use references undefined gate id {id}");
    }
    Ok(())
}

fn ensure_no_parameters(parameters: &[u64], name: &str) -> Result<()> {
    if !parameters.is_empty() {
        bail!("{name} custom gate must not have parameters");
    }
    Ok(())
}

fn push_u64(out: &mut Vec<u8>, value: u64) {
    out.extend_from_slice(&value.to_le_bytes());
}

fn add_mod(lhs: u64, rhs: u64) -> u64 {
    ((lhs as u128 + rhs as u128) % GOLDILOCKS_P as u128) as u64
}

fn sub_mod(lhs: u64, rhs: u64) -> u64 {
    ((lhs as u128 + GOLDILOCKS_P as u128 - rhs as u128) % GOLDILOCKS_P as u128) as u64
}

fn neg_mod(value: u64) -> u64 {
    if value == 0 {
        0
    } else {
        GOLDILOCKS_P - value
    }
}

fn mul_mod(lhs: u64, rhs: u64) -> u64 {
    ((lhs as u128 * rhs as u128) % GOLDILOCKS_P as u128) as u64
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::recursive_setup::r1cs::{CustomGate, CustomGateUse, R1csConstraint};

    #[test]
    fn converts_sum_and_mul_constraints_like_js_r1cs2plonk() -> Result<()> {
        let mut constraints = Vec::new();
        constraints.push(R1csConstraint {
            a: lc(&[]),
            b: lc(&[(1, 1)]),
            c: lc(&[(1, 3), (2, 5), (3, 7), (4, 11), (0, 13)]),
        });
        constraints.push(R1csConstraint {
            a: lc(&[(1, 2), (0, 3)]),
            b: lc(&[(2, 5), (0, 7)]),
            c: lc(&[(3, 11), (0, 13)]),
        });
        let r1cs = R1cs {
            n8: 8,
            prime: GOLDILOCKS_P,
            n_vars: 5,
            n_outputs: 0,
            n_pub_inputs: 0,
            n_prv_inputs: 0,
            n_labels: 0,
            n_constraints: constraints.len() as u32,
            constraints,
            wire_map: Vec::new(),
            custom_gates: vec![CustomGate {
                template_name: "CMul".to_string(),
                parameters: vec![],
            }],
            custom_gate_uses: vec![CustomGateUse { id: 0, signals: vec![1, 2, 3] }],
        };

        let plonk = r1cs_to_plonk(&r1cs)?;
        assert_eq!(plonk.additions, vec![PlonkAddition { sl: 1, sr: 2, ql: 3, qr: 5 }]);
        assert_eq!(
            plonk.constraints[0],
            PlonkConstraint {
                sl: 1,
                sr: 2,
                so: 5,
                qm: 0,
                ql: neg_mod(3),
                qr: neg_mod(5),
                qo: 1,
                qc: 0,
            }
        );
        assert_eq!(
            plonk.constraints[1],
            PlonkConstraint { sl: 3, sr: 4, so: 5, qm: 0, ql: 7, qr: 11, qo: 1, qc: 13 }
        );
        assert_eq!(
            plonk.constraints[2],
            PlonkConstraint { sl: 1, sr: 2, so: 3, qm: 10, ql: 14, qr: 15, qo: neg_mod(11), qc: 8 }
        );
        assert_eq!(plonk.n_vars, 6);
        assert_eq!(plonk.custom_gates_info.n_cmul, 1);
        Ok(())
    }

    #[test]
    fn writes_exec_buffer_in_row_major_signal_map_order() -> Result<()> {
        let exec = write_exec_buffer(
            &[PlonkAddition { sl: 1, sr: 2, ql: 3, qr: 4 }],
            &[vec![10, 11], vec![20, 21], vec![30, 31]],
        )?;
        let words = exec
            .chunks_exact(8)
            .map(|chunk| u64::from_le_bytes(chunk.try_into().unwrap()))
            .collect::<Vec<_>>();
        assert_eq!(words, vec![1, 2, 1, 2, 3, 4, 10, 20, 30, 11, 21, 31]);
        Ok(())
    }

    #[test]
    fn packs_plain_constraints_into_rows_like_js_layouts() {
        let constraint = PlonkConstraint { sl: 1, sr: 2, so: 3, qm: 4, ql: 5, qr: 6, qo: 7, qc: 8 };
        let custom_gates_info = CustomGatesInfo::default();

        let aggregation_rows = calculate_plonk_constraint_rows(
            &vec![constraint.clone(); 10],
            LayoutPolicy::for_kind(PlonkLayoutKind::Aggregation),
            &custom_gates_info,
        );
        assert_eq!(aggregation_rows.n_rows, 2);
        assert_eq!(aggregation_rows.constraints_in_rows, 10);
        assert_eq!(aggregation_rows.constraints_in_custom_rows, 0);

        let compressor_rows = calculate_plonk_constraint_rows(
            &vec![constraint.clone(); 13],
            LayoutPolicy::for_kind(PlonkLayoutKind::Compressor),
            &custom_gates_info,
        );
        assert_eq!(compressor_rows.n_rows, 2);
        assert_eq!(compressor_rows.constraints_in_rows, 13);

        let final_rows = calculate_plonk_constraint_rows(
            &vec![constraint; 12],
            LayoutPolicy::for_kind(PlonkLayoutKind::FinalVadcop),
            &custom_gates_info,
        );
        assert_eq!(final_rows.n_rows, 2);
        assert_eq!(final_rows.constraints_in_rows, 12);
    }

    #[test]
    fn reports_layout_shape_for_custom_gate_rows() -> Result<()> {
        let r1cs = R1cs {
            n8: 8,
            prime: GOLDILOCKS_P,
            n_vars: 1,
            n_outputs: 2,
            n_pub_inputs: 3,
            n_prv_inputs: 0,
            n_labels: 0,
            n_constraints: 0,
            constraints: Vec::new(),
            wire_map: Vec::new(),
            custom_gates: Vec::new(),
            custom_gate_uses: Vec::new(),
        };
        let program = PlonkProgram {
            constraints: Vec::new(),
            additions: Vec::new(),
            n_vars: 1,
            custom_gates_info: CustomGatesInfo {
                n_cmul: 4,
                n_poseidon12: 1,
                n_ev_pol4: 1,
                ..Default::default()
            },
        };

        let shape =
            calculate_layout_shape_from_program(&r1cs, &program, PlonkLayoutKind::Aggregation)?;
        assert_eq!(shape.committed_pols, 59);
        assert_eq!(shape.n_publics, 5);
        assert_eq!(shape.n_cmul_rows, 2);
        assert_eq!(shape.n_poseidon12_rows, 5);
        assert_eq!(shape.n_ev_pol4_rows, 1);
        assert_eq!(shape.n_used_rows, 8);
        assert_eq!(shape.n_bits, 3);
        assert_eq!(shape.n_rows, 8);
        Ok(())
    }

    #[test]
    fn builds_aggregation_signal_map_and_fixed_columns() -> Result<()> {
        let r1cs = empty_r1cs(0, 0);
        let program = PlonkProgram {
            constraints: vec![PlonkConstraint {
                sl: 1,
                sr: 2,
                so: 3,
                qm: 4,
                ql: 5,
                qr: 6,
                qo: 7,
                qc: 8,
            }],
            additions: Vec::new(),
            n_vars: 4,
            custom_gates_info: CustomGatesInfo::default(),
        };

        let layout =
            build_layout_from_program(&r1cs, &program, PlonkLayoutKind::Aggregation, "Agg")?;
        assert_eq!(layout.shape.n_used_rows, 1);
        assert_eq!(layout.signal_map.len(), 59);
        assert_eq!(
            (0..6).map(|col| layout.signal_map[col][0]).collect::<Vec<_>>(),
            vec![1, 2, 3, 1, 2, 3]
        );
        assert_eq!(layout.fixed_columns.len(), 49);
        assert_eq!(layout.fixed_columns[0].name, "Agg.S");
        assert_eq!(layout.fixed_columns[27].name, "Agg.C");
        assert_eq!(layout.fixed_columns[27].values[0], 4);
        assert_eq!(layout.fixed_columns[31].values[0], 8);
        assert_eq!(layout.fixed_columns[46].name, "Agg.PLONK");
        assert_eq!(layout.fixed_columns[46].values[0], 1);
        assert_eq!(layout.fixed_columns[47].name, "Agg.ID");
        assert_eq!(layout.fixed_columns[47].values[0], 1);
        assert_eq!(layout.fixed_columns[48].name, "__L1__");
        assert_eq!(layout.fixed_columns[48].values[0], 1);
        Ok(())
    }

    #[test]
    fn builds_poseidon_flags_for_aggregation_layout() -> Result<()> {
        let mut r1cs = empty_r1cs(0, 0);
        r1cs.custom_gates
            .push(CustomGate { template_name: "Poseidon16".to_string(), parameters: vec![] });
        r1cs.custom_gate_uses.push(CustomGateUse { id: 0, signals: (1..=(14 * 16)).collect() });

        let layout = build_layout(&r1cs, PlonkLayoutKind::Aggregation, "Agg")?;
        assert_eq!(layout.shape.n_used_rows, 5);
        assert_eq!(layout.shape.n_rows, 8);
        assert_eq!(layout.fixed_columns[37].values, vec![1, 0, 0, 0, 0, 0, 0, 0]);
        assert_eq!(layout.fixed_columns[39].values, vec![0, 0, 1, 0, 0, 0, 0, 0]);
        assert_eq!(layout.fixed_columns[40].values, vec![0, 0, 0, 0, 1, 0, 0, 0]);
        assert_eq!(layout.signal_map[0][0], 1);
        assert_eq!(layout.signal_map[27][0], 17);
        assert_eq!(layout.signal_map[43][0], 33);
        assert_eq!(layout.signal_map[0][4], 209);
        Ok(())
    }

    #[test]
    fn writes_const_buffer_in_row_major_fixed_column_order() -> Result<()> {
        let columns = vec![
            FixedColumn { name: "A".to_string(), lengths: Vec::new(), values: vec![1, 2] },
            FixedColumn { name: "B".to_string(), lengths: Vec::new(), values: vec![3, 4] },
            FixedColumn { name: "C".to_string(), lengths: Vec::new(), values: vec![5, 6] },
        ];
        let bytes = write_const_buffer(&columns)?;
        let words = bytes
            .chunks_exact(8)
            .map(|chunk| u64::from_le_bytes(chunk.try_into().unwrap()))
            .collect::<Vec<_>>();
        assert_eq!(words, vec![1, 3, 5, 2, 4, 6]);
        Ok(())
    }

    fn empty_r1cs(n_outputs: u32, n_pub_inputs: u32) -> R1cs {
        R1cs {
            n8: 8,
            prime: GOLDILOCKS_P,
            n_vars: 1,
            n_outputs,
            n_pub_inputs,
            n_prv_inputs: 0,
            n_labels: 0,
            n_constraints: 0,
            constraints: Vec::new(),
            wire_map: Vec::new(),
            custom_gates: Vec::new(),
            custom_gate_uses: Vec::new(),
        }
    }

    fn lc(values: &[(u32, u64)]) -> LinearCombination {
        values.iter().copied().collect()
    }
}
