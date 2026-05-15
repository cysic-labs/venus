use anyhow::{Context, Result};
use pilout_crate::pilout::{Air, FixedCol, Symbol, SymbolType};

use crate::recursive_setup::plonk::{FixedColumn, PlonkLayout, PlonkLayoutKind};

#[derive(Debug, Clone, PartialEq)]
pub struct RecursiveAirLayout {
    pub air: Air,
    pub symbols: Vec<Symbol>,
}

pub fn build_air_layout(
    layout: &PlonkLayout,
    airgroup_id: u32,
    air_id: u32,
    air_name: &str,
    n_publics: u32,
) -> Result<RecursiveAirLayout> {
    let n_rows = u32::try_from(layout.shape.n_rows)
        .with_context(|| format!("recursive AIR row count {} exceeds u32", layout.shape.n_rows))?;
    let witness_width = u32::try_from(layout.shape.committed_pols).with_context(|| {
        format!("recursive AIR witness width {} exceeds u32", layout.shape.committed_pols)
    })?;
    let connection_width = connection_intermediate_width(layout.shape.kind);

    let fixed_cols = layout.fixed_columns.iter().map(to_proto_fixed_col).collect();
    let air = Air {
        name: Some(air_name.to_string()),
        num_rows: Some(n_rows),
        periodic_cols: Vec::new(),
        fixed_cols,
        stage_widths: vec![witness_width, connection_width],
        expressions: Vec::new(),
        constraints: Vec::new(),
        air_values: Vec::new(),
        aggregable: false,
        custom_commits: Vec::new(),
    };

    let symbols = build_symbols(
        &layout.fixed_columns,
        layout.shape.kind,
        airgroup_id,
        air_id,
        witness_width,
        n_publics,
    )?;

    Ok(RecursiveAirLayout { air, symbols })
}

pub fn connection_intermediate_width(kind: PlonkLayoutKind) -> u32 {
    1 + connection_im_low_width(kind)
}

pub fn connection_im_low_width(kind: PlonkLayoutKind) -> u32 {
    match kind {
        PlonkLayoutKind::Aggregation => 3,
        PlonkLayoutKind::Compressor => 8,
        PlonkLayoutKind::FinalVadcop => 4,
    }
}

fn to_proto_fixed_col(column: &FixedColumn) -> FixedCol {
    FixedCol { values: column.values.iter().map(|value| value.to_le_bytes().to_vec()).collect() }
}

fn build_symbols(
    fixed_columns: &[FixedColumn],
    kind: PlonkLayoutKind,
    airgroup_id: u32,
    air_id: u32,
    witness_width: u32,
    n_publics: u32,
) -> Result<Vec<Symbol>> {
    let mut symbols = Vec::new();
    symbols.extend(group_fixed_symbols(fixed_columns, airgroup_id, air_id)?);

    symbols.push(pol_array_symbol(
        "a",
        SymbolType::WitnessCol,
        airgroup_id,
        air_id,
        1,
        0,
        witness_width,
    ));
    symbols.push(pol_scalar_symbol("gprod", SymbolType::WitnessCol, airgroup_id, air_id, 2, 0));
    symbols.push(pol_array_symbol(
        "im_low",
        SymbolType::WitnessCol,
        airgroup_id,
        air_id,
        2,
        1,
        connection_im_low_width(kind),
    ));

    if n_publics > 0 {
        symbols.push(array_symbol(
            "publics",
            SymbolType::PublicValue,
            airgroup_id,
            air_id,
            1,
            0,
            n_publics,
        ));
    }

    symbols.push(challenge_symbol("std_alpha", 2, 0));
    symbols.push(challenge_symbol("std_gamma", 2, 1));
    Ok(symbols)
}

fn group_fixed_symbols(
    fixed_columns: &[FixedColumn],
    airgroup_id: u32,
    air_id: u32,
) -> Result<Vec<Symbol>> {
    let mut symbols = Vec::new();
    let mut fixed_id = 0u32;
    let mut idx = 0usize;

    while idx < fixed_columns.len() {
        let column = &fixed_columns[idx];
        if let Some(width) = consecutive_array_width(fixed_columns, idx)? {
            symbols.push(pol_array_symbol(
                &column.name,
                SymbolType::FixedCol,
                airgroup_id,
                air_id,
                0,
                fixed_id,
                width,
            ));
            fixed_id += width;
            idx += width as usize;
        } else {
            symbols.push(pol_scalar_symbol(
                &column.name,
                SymbolType::FixedCol,
                airgroup_id,
                air_id,
                0,
                fixed_id,
            ));
            fixed_id += 1;
            idx += 1;
        }
    }

    Ok(symbols)
}

fn consecutive_array_width(columns: &[FixedColumn], start: usize) -> Result<Option<u32>> {
    let first = &columns[start];
    if first.lengths != [0] {
        return Ok(None);
    }

    let mut width = 1usize;
    while start + width < columns.len() {
        let column = &columns[start + width];
        if column.name != first.name {
            break;
        }
        if column.lengths != [width as u32] {
            break;
        }
        width += 1;
    }

    if width == 1 {
        return Ok(None);
    }
    u32::try_from(width)
        .map(Some)
        .with_context(|| format!("fixed column array {} is too wide", first.name))
}

fn pol_array_symbol(
    name: &str,
    symbol_type: SymbolType,
    airgroup_id: u32,
    air_id: u32,
    stage: u32,
    id: u32,
    len: u32,
) -> Symbol {
    array_symbol(name, symbol_type, airgroup_id, air_id, stage, id, len)
}

fn array_symbol(
    name: &str,
    symbol_type: SymbolType,
    airgroup_id: u32,
    air_id: u32,
    stage: u32,
    id: u32,
    len: u32,
) -> Symbol {
    Symbol {
        name: name.to_string(),
        air_group_id: Some(airgroup_id),
        air_id: Some(air_id),
        r#type: symbol_type as i32,
        id,
        stage: Some(stage),
        dim: 1,
        lengths: vec![len],
        commit_id: None,
        debug_line: None,
    }
}

fn pol_scalar_symbol(
    name: &str,
    symbol_type: SymbolType,
    airgroup_id: u32,
    air_id: u32,
    stage: u32,
    id: u32,
) -> Symbol {
    Symbol {
        name: name.to_string(),
        air_group_id: Some(airgroup_id),
        air_id: Some(air_id),
        r#type: symbol_type as i32,
        id,
        stage: Some(stage),
        dim: 1,
        lengths: Vec::new(),
        commit_id: None,
        debug_line: None,
    }
}

fn challenge_symbol(name: &str, stage: u32, id: u32) -> Symbol {
    Symbol {
        name: name.to_string(),
        air_group_id: None,
        air_id: None,
        r#type: SymbolType::Challenge as i32,
        id,
        stage: Some(stage),
        dim: 3,
        lengths: Vec::new(),
        commit_id: None,
        debug_line: None,
    }
}

#[cfg(test)]
mod tests {
    use anyhow::Result;

    use super::*;
    use crate::recursive_setup::plonk::{build_layout, PlonkLayoutKind};
    use crate::recursive_setup::r1cs::{R1cs, R1csConstraint, GOLDILOCKS_P};

    #[test]
    fn builds_aggregation_air_column_schema() -> Result<()> {
        let layout =
            build_layout(&one_constraint_r1cs(), PlonkLayoutKind::Aggregation, "Recursive2")?;
        let air = build_air_layout(&layout, 0, 0, "recursive2", 473)?;

        assert_eq!(air.air.name.as_deref(), Some("recursive2"));
        assert_eq!(air.air.fixed_cols.len(), 49);
        assert_eq!(air.air.stage_widths, vec![59, 4]);
        assert!(air.symbols.iter().any(|symbol| {
            symbol.name == "Recursive2.S"
                && symbol.r#type == SymbolType::FixedCol as i32
                && symbol.lengths == [27]
        }));
        assert!(air.symbols.iter().any(|symbol| {
            symbol.name == "Recursive2.C"
                && symbol.r#type == SymbolType::FixedCol as i32
                && symbol.lengths == [10]
        }));
        assert!(air.symbols.iter().any(|symbol| {
            symbol.name == "a"
                && symbol.r#type == SymbolType::WitnessCol as i32
                && symbol.stage == Some(1)
                && symbol.lengths == [59]
        }));
        assert!(air.symbols.iter().any(|symbol| {
            symbol.name == "im_low"
                && symbol.r#type == SymbolType::WitnessCol as i32
                && symbol.stage == Some(2)
                && symbol.id == 1
                && symbol.lengths == [3]
        }));
        assert!(air.symbols.iter().any(|symbol| {
            symbol.name == "publics"
                && symbol.r#type == SymbolType::PublicValue as i32
                && symbol.lengths == [473]
        }));
        Ok(())
    }

    #[test]
    fn records_kind_specific_connection_widths() {
        assert_eq!(connection_intermediate_width(PlonkLayoutKind::Aggregation), 4);
        assert_eq!(connection_intermediate_width(PlonkLayoutKind::Compressor), 9);
        assert_eq!(connection_intermediate_width(PlonkLayoutKind::FinalVadcop), 5);
    }

    fn one_constraint_r1cs() -> R1cs {
        R1cs {
            n8: 8,
            prime: GOLDILOCKS_P,
            n_vars: 5,
            n_outputs: 0,
            n_pub_inputs: 0,
            n_prv_inputs: 0,
            n_labels: 0,
            n_constraints: 1,
            constraints: vec![R1csConstraint {
                a: [(1, 2)].into_iter().collect(),
                b: [(2, 3)].into_iter().collect(),
                c: [(3, 4)].into_iter().collect(),
            }],
            wire_map: Vec::new(),
            custom_gates: Vec::new(),
            custom_gate_uses: Vec::new(),
        }
    }
}
