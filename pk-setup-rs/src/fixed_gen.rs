use std::fs::File;
use std::io::{BufWriter, Write};
use std::path::Path;

use anyhow::{bail, Context, Result};
use pilout_crate::pilout::{hint_field, operand, Air, Hint, HintField, Symbol, SymbolType};
use sm_arith::ArithFrops;
use sm_binary::{BinaryBasicFrops, BinaryExtensionFrops};
use zisk_core::zisk_ops::ZiskOp;

const GOLDILOCKS_PRIME: u64 = 0xFFFF_FFFF_0000_0001;
const OPERATION_BUS_ID: u64 = 5000;

const ARITH_TABLE_ID: u64 = 331;
const ARITH_RANGE_TABLE_ID: u64 = 330;
const BINARY_TABLE_ID: u64 = 125;
const BINARY_EXTENSION_TABLE_ID: u64 = 124;
const ARITH_FROPS_TABLE_ID: u64 = 5010;
const BINARY_FROPS_TABLE_ID: u64 = 5011;
const BINARY_EXTENSION_FROPS_TABLE_ID: u64 = 5012;
const ARITH_EQ_LT_TABLE_ID: u64 = 5002;
const KECCAKF_TABLE_ID: u64 = 126;
const DMA_ROM_ID: u64 = 8001;
const DMA_PRE_POST_TABLE_ID: u64 = 8002;
const DMA_BYTE_CMP_TABLE_ID: u64 = 8003;
const DUAL_RANGE_7_BITS_ID: u64 = 77;
const DUAL_RANGE_BYTE_ID: u64 = 88;
const MEMORY_ALIGN_ROM_ID: u64 = 133;

const OP_MINU: u64 = 0x02;
const OP_MIN: u64 = 0x03;
const OP_MAXU: u64 = 0x04;
const OP_MAX: u64 = 0x05;
const OP_LTU: u64 = 0x06;
const OP_LT: u64 = 0x07;
const OP_GT: u64 = 0x08;
const OP_EQ: u64 = 0x09;
const OP_ADD: u64 = 0x0A;
const OP_SUB: u64 = 0x0B;
const OP_LEU: u64 = 0x0C;
const OP_LE: u64 = 0x0D;
const OP_AND: u64 = 0x0E;
const OP_OR: u64 = 0x0F;
const OP_XOR: u64 = 0x10;
const OP_LT_ABS_NP: u64 = 0x50;
const OP_LT_ABS_PN: u64 = 0x51;
const OP_SLL: u64 = 0x21;
const OP_SRL: u64 = 0x22;
const OP_SRA: u64 = 0x23;
const OP_SLL_W: u64 = 0x24;
const OP_SRL_W: u64 = 0x25;
const OP_SRA_W: u64 = 0x26;
const OP_SEXT_B: u64 = 0x27;
const OP_SEXT_H: u64 = 0x28;
const OP_SEXT_W: u64 = 0x29;
const OP_SEXT_00: u64 = 0x200;
const OP_SEXT_FF: u64 = 0x201;

#[derive(Debug, Clone)]
struct FixedColumn {
    name: String,
    indexes: Vec<u32>,
    pol_id: u32,
}

pub fn write_air_const(
    output: &Path,
    airgroup_id: usize,
    air_id: usize,
    air: &Air,
    symbols: &[Symbol],
    hints: &[Hint],
) -> Result<()> {
    let air_name = air
        .name
        .as_deref()
        .with_context(|| format!("air {airgroup_id}:{air_id} is missing a name"))?;
    let num_rows = air.num_rows.with_context(|| format!("air {air_name} is missing numRows"))?;
    let columns = fixed_columns(symbols, airgroup_id, air_id);
    if columns.len() != air.fixed_cols.len() {
        bail!(
            "air {air_name} fixed column count mismatch: symbols={}, pilout={}",
            columns.len(),
            air.fixed_cols.len()
        );
    }

    let mut generator =
        AirFixedGenerator::new(air_name, airgroup_id, air_id, num_rows as usize, &columns, hints)?;
    write_row_major(output, num_rows as usize, columns.len(), |row, out| {
        generator.fill_row(row, out)
    })
}

fn write_row_major<F>(
    output: &Path,
    num_rows: usize,
    num_cols: usize,
    mut fill_row: F,
) -> Result<()>
where
    F: FnMut(usize, &mut [u64]) -> Result<()>,
{
    let file =
        File::create(output).with_context(|| format!("failed to create {}", output.display()))?;
    let mut writer = BufWriter::with_capacity(16 * 1024 * 1024, file);
    let mut row_values = vec![0u64; num_cols];
    let mut bytes = Vec::with_capacity((num_cols * 8).min(64 * 1024));

    for row in 0..num_rows {
        row_values.fill(0);
        fill_row(row, &mut row_values)?;
        for value in &row_values {
            bytes.extend_from_slice(&value.to_le_bytes());
        }
        if bytes.len() >= 16 * 1024 * 1024 {
            writer.write_all(&bytes)?;
            bytes.clear();
        }
    }
    if !bytes.is_empty() {
        writer.write_all(&bytes)?;
    }
    writer.flush()?;
    Ok(())
}

fn fixed_columns(symbols: &[Symbol], airgroup_id: usize, air_id: usize) -> Vec<FixedColumn> {
    let mut columns = Vec::new();
    for symbol in symbols {
        if symbol.r#type != SymbolType::FixedCol as i32
            || symbol.air_group_id != Some(airgroup_id as u32)
            || symbol.air_id != Some(air_id as u32)
        {
            continue;
        }
        let base_pol_id = previous_fixed_pol_count(symbols, symbol);
        if symbol.dim == 0 || symbol.lengths.is_empty() {
            columns.push(FixedColumn {
                name: symbol.name.clone(),
                indexes: Vec::new(),
                pol_id: base_pol_id,
            });
        } else {
            let mut indexes = Vec::new();
            expand_fixed_symbol(symbol, base_pol_id, &mut indexes, &mut columns);
        }
    }
    columns.sort_by_key(|column| column.pol_id);
    columns
}

fn expand_fixed_symbol(
    symbol: &Symbol,
    base_pol_id: u32,
    indexes: &mut Vec<u32>,
    out: &mut Vec<FixedColumn>,
) {
    if indexes.len() == symbol.lengths.len() {
        out.push(FixedColumn {
            name: symbol.name.clone(),
            indexes: indexes.clone(),
            pol_id: base_pol_id + linear_offset(&symbol.lengths, indexes),
        });
        return;
    }
    for index in 0..symbol.lengths[indexes.len()] {
        indexes.push(index);
        expand_fixed_symbol(symbol, base_pol_id, indexes, out);
        indexes.pop();
    }
}

fn previous_fixed_pol_count(symbols: &[Symbol], symbol: &Symbol) -> u32 {
    symbols
        .iter()
        .filter(|other| {
            other.r#type == SymbolType::FixedCol as i32
                && other.air_id == symbol.air_id
                && other.air_group_id == symbol.air_group_id
                && ((other.stage.unwrap_or(0) < symbol.stage.unwrap_or(0))
                    || (other.stage == symbol.stage && other.id < symbol.id))
        })
        .map(symbol_width)
        .sum()
}

fn symbol_width(symbol: &Symbol) -> u32 {
    if symbol.dim == 0 || symbol.lengths.is_empty() {
        1
    } else {
        symbol.lengths.iter().product()
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

enum AirFixedGenerator {
    Generic { air_name: String, columns: Vec<FixedColumn>, num_rows: usize },
    SpecifiedRanges(SpecifiedRangesGen),
    VirtualTable(VirtualTableGen),
}

impl AirFixedGenerator {
    fn new(
        air_name: &str,
        airgroup_id: usize,
        air_id: usize,
        num_rows: usize,
        columns: &[FixedColumn],
        hints: &[Hint],
    ) -> Result<Self> {
        match air_name {
            "SpecifiedRanges" => {
                Ok(Self::SpecifiedRanges(SpecifiedRangesGen::new(num_rows, columns, hints)?))
            }
            "VirtualTable0" | "VirtualTable1" => Ok(Self::VirtualTable(VirtualTableGen::new(
                air_name,
                airgroup_id,
                air_id,
                num_rows,
                columns,
                hints,
            )?)),
            _ => Ok(Self::Generic {
                air_name: air_name.to_string(),
                columns: columns.to_vec(),
                num_rows,
            }),
        }
    }

    fn fill_row(&mut self, row: usize, out: &mut [u64]) -> Result<()> {
        match self {
            Self::Generic { air_name, columns, num_rows } => {
                for (idx, column) in columns.iter().enumerate() {
                    out[idx] = generic_fixed_value(air_name, column, row, *num_rows)?;
                }
                Ok(())
            }
            Self::SpecifiedRanges(gen) => {
                gen.fill_row(row, out);
                Ok(())
            }
            Self::VirtualTable(gen) => gen.fill_row(row, out),
        }
    }
}

fn generic_fixed_value(
    air_name: &str,
    column: &FixedColumn,
    row: usize,
    num_rows: usize,
) -> Result<u64> {
    match fixed_column_name(column) {
        "__L1__" | "SEGMENT_L1" | "L1" => Ok(if row == 0 { 1 } else { 0 }),
        "SEGMENT_STEP" => Ok(row as u64),
        "CLK_0" => Ok(match air_name {
            "ArithEq" => clk0(row, num_rows, 16, false),
            "ArithEq384" => clk0(row, num_rows, 24, true),
            "Keccakf" => clk0(row, num_rows, 25, true),
            "Sha256f" => clk0(row, num_rows, 72, true),
            "Poseidon2" => clk0(row, num_rows, 14, true),
            "Blake2br" => clk0(row, num_rows, 24, true),
            _ => bail!("unsupported CLK_0 column for {air_name}"),
        }),
        "MSG_IDX" if air_name == "Blake2br" => {
            const MSG_IDX: [u64; 24] =
                [0, 1, 0, 2, 3, 0, 4, 5, 0, 6, 7, 0, 8, 9, 0, 10, 11, 0, 12, 13, 0, 14, 15, 0];
            Ok(MSG_IDX[row % MSG_IDX.len()])
        }
        _ => bail!(
            "unsupported fixed column {}{:?} for air {air_name}",
            fixed_column_name(column),
            column.indexes
        ),
    }
}

fn fixed_column_name(column: &FixedColumn) -> &str {
    column.name.rsplit('.').next().unwrap_or(&column.name)
}

fn clk0(row: usize, num_rows: usize, period: usize, truncate_partial_cycle: bool) -> u64 {
    let active_len = if truncate_partial_cycle && num_rows % period != 0 {
        let complete = num_rows / period;
        complete.saturating_sub(1) * period
    } else {
        num_rows
    };
    if row < active_len && row % period == 0 {
        1
    } else {
        0
    }
}

#[derive(Clone)]
struct RangeDef {
    opid: u64,
    min: i64,
    max: i64,
}

struct SpecifiedRangesGen {
    num_rows: usize,
    num_groups: usize,
    ranges: Vec<RangeDef>,
}

impl SpecifiedRangesGen {
    fn new(num_rows: usize, columns: &[FixedColumn], hints: &[Hint]) -> Result<Self> {
        let num_groups =
            columns.iter().filter(|column| fixed_column_name(column) == "OPID").count();
        let data_hint = hints
            .iter()
            .find(|hint| hint.name == "specified_ranges_data")
            .context("SpecifiedRanges is missing specified_ranges_data hint")?;
        let opids_count = hint_field_u64(required_hint_field(data_hint, "opids_count")?)? as usize;
        let acc_heights = hint_field_array_u64(required_hint_field(data_hint, "acc_heights")?)?;
        let hint_num_groups = hint_field_u64(required_hint_field(data_hint, "num_muls")?)? as usize;

        if opids_count != acc_heights.len() {
            bail!("specified_ranges_data has inconsistent array lengths");
        }
        if hint_num_groups != num_groups {
            bail!(
                "SpecifiedRanges group count mismatch: hint={hint_num_groups}, fixed={num_groups}"
            );
        }

        let ranges = collect_specified_ranges(hints, opids_count)?;
        if ranges.len() != opids_count {
            bail!("specified range count mismatch: range_def={}, hint={opids_count}", ranges.len());
        }
        let mut acc = 0u64;
        for (idx, range) in ranges.iter().enumerate() {
            if acc_heights[idx] != acc {
                bail!(
                    "SpecifiedRanges acc_height mismatch at {idx}: computed={acc}, hint={}",
                    acc_heights[idx]
                );
            }
            acc += (range.max - range.min + 1) as u64;
        }

        Ok(Self { num_rows, num_groups, ranges })
    }

    fn fill_row(&self, row: usize, out: &mut [u64]) {
        out[self.num_groups * 2] = if row == 0 { 1 } else { 0 };
        let mut group = 0usize;
        let mut row_offset = 0usize;
        for range in &self.ranges {
            let mut value = range.min;
            let mut height = (range.max - range.min + 1) as usize;
            while height > 0 {
                let rows_available = self.num_rows - row_offset;
                let h = height.min(rows_available);
                if row >= row_offset && row < row_offset + h {
                    out[group] = range.opid;
                    out[self.num_groups + group] =
                        field_from_i128(value as i128 + (row - row_offset) as i128);
                }
                value += h as i64;
                height -= h;
                row_offset += h;
                if row_offset == self.num_rows {
                    group += 1;
                    row_offset = 0;
                }
            }
        }
    }
}

fn collect_specified_ranges(hints: &[Hint], expected_count: usize) -> Result<Vec<RangeDef>> {
    let mut ranges = Vec::with_capacity(expected_count);
    let mut seen = Vec::<(i64, i64, bool)>::new();
    for hint in hints.iter().filter(|hint| hint.name == "range_def") {
        let type_field = required_hint_field(hint, "type")?;
        if hint_field_string(type_field)? != "Specified" {
            continue;
        }
        let predefined = hint_field_u64(required_hint_field(hint, "predefined")?)? != 0;
        let min_neg = hint_field_u64(required_hint_field(hint, "min_neg")?)? != 0;
        let max_neg = hint_field_u64(required_hint_field(hint, "max_neg")?)? != 0;
        let min = signed_hint_value(hint_field_u64(required_hint_field(hint, "min")?)?, min_neg);
        let max = signed_hint_value(hint_field_u64(required_hint_field(hint, "max")?)?, max_neg);
        let key = (min, max, predefined);
        if seen.contains(&key) {
            continue;
        }
        seen.push(key);
        ranges.push(RangeDef {
            opid: hint_field_u64(required_hint_field(hint, "opid")?)?,
            min,
            max,
        });
        if ranges.len() == expected_count {
            break;
        }
    }
    Ok(ranges)
}

struct VirtualTableGen {
    num_groups: usize,
    sum_widths: usize,
    sources: Vec<PackedSource>,
    groups: Vec<VirtualGroup>,
}

struct VirtualGroup {
    col_offset: usize,
    width: usize,
    segments: Vec<VirtualSegment>,
}

struct VirtualSegment {
    start_row: usize,
    len: usize,
    source_idx: usize,
    source_row_start: usize,
}

struct PackedSource {
    uid: u64,
    width: usize,
    height: usize,
    inners: Vec<InnerSource>,
}

struct InnerSource {
    table_id: u64,
    height: usize,
    generator: SourceGenerator,
}

impl VirtualTableGen {
    fn new(
        air_name: &str,
        airgroup_id: usize,
        air_id: usize,
        num_rows: usize,
        columns: &[FixedColumn],
        hints: &[Hint],
    ) -> Result<Self> {
        let num_groups = columns.iter().filter(|column| fixed_column_name(column) == "UID").count();
        let sum_widths =
            columns.iter().filter(|column| fixed_column_name(column) == "column").count();
        let data_hint = hints
            .iter()
            .find(|hint| {
                hint.name == "virtual_table_data"
                    && hint.air_group_id == Some(airgroup_id as u32)
                    && hint.air_id == Some(air_id as u32)
            })
            .with_context(|| format!("{air_name} is missing virtual_table_data hint"))?;
        let table_ids = hint_field_array_u64(required_hint_field(data_hint, "table_ids")?)?;
        let acc_heights = hint_field_array_u64(required_hint_field(data_hint, "acc_heights")?)?;
        let hint_num_groups = hint_field_u64(required_hint_field(data_hint, "num_muls")?)? as usize;

        if hint_num_groups != num_groups {
            bail!("{air_name} group count mismatch: hint={hint_num_groups}, fixed={num_groups}");
        }
        if table_ids.len() != acc_heights.len() {
            bail!("{air_name} table_ids/acc_heights length mismatch");
        }

        let sources = build_packed_sources(&table_ids)?;
        let mut acc = 0u64;
        let mut flat_idx = 0usize;
        for source in &sources {
            for inner in &source.inners {
                if inner.table_id != table_ids[flat_idx] {
                    bail!(
                        "{air_name} table id mismatch at {flat_idx}: source={}, hint={}",
                        inner.table_id,
                        table_ids[flat_idx]
                    );
                }
                if acc_heights[flat_idx] != acc {
                    bail!(
                        "{air_name} acc height mismatch at {flat_idx} table_id={}: computed={acc}, hint={}",
                        table_ids[flat_idx],
                        acc_heights[flat_idx]
                    );
                }
                acc += inner.height as u64;
                flat_idx += 1;
            }
        }

        let groups = compute_virtual_groups(num_rows, &sources, num_groups)?;
        let computed_sum_widths: usize = groups.iter().map(|group| group.width).sum();
        if computed_sum_widths != sum_widths {
            bail!(
                "{air_name} column width mismatch: computed={computed_sum_widths}, fixed={sum_widths}"
            );
        }

        Ok(Self { num_groups, sum_widths, sources, groups })
    }

    fn fill_row(&self, row: usize, out: &mut [u64]) -> Result<()> {
        out[self.num_groups + self.sum_widths] = if row == 0 { 1 } else { 0 };
        for (group_idx, group) in self.groups.iter().enumerate() {
            let Some(segment) = group
                .segments
                .iter()
                .find(|segment| row >= segment.start_row && row < segment.start_row + segment.len)
            else {
                continue;
            };
            let source = &self.sources[segment.source_idx];
            let local_row = segment.source_row_start + row - segment.start_row;
            out[group_idx] = source.uid;
            source.fill_row(
                local_row,
                &mut out[self.num_groups + group.col_offset..][..source.width],
            )?;
        }
        Ok(())
    }
}

fn build_packed_sources(table_ids: &[u64]) -> Result<Vec<PackedSource>> {
    let mut sources = Vec::<PackedSource>::new();
    for table_id in table_ids {
        let generator = SourceGenerator::new(*table_id)?;
        let uid = generator.uid();
        let width = generator.width();
        let height = generator.height();
        let inner = InnerSource { table_id: *table_id, height, generator };
        if let Some(last) = sources.last_mut() {
            if last.uid == uid && last.width == width {
                last.height += height;
                last.inners.push(inner);
                continue;
            }
        }
        sources.push(PackedSource { uid, width, height, inners: vec![inner] });
    }
    Ok(sources)
}

impl PackedSource {
    fn fill_row(&self, row: usize, out: &mut [u64]) -> Result<()> {
        let mut offset = 0usize;
        for inner in &self.inners {
            if row < offset + inner.height {
                return inner.generator.fill_row(row - offset, out);
            }
            offset += inner.height;
        }
        Ok(())
    }
}

fn compute_virtual_groups(
    num_rows: usize,
    sources: &[PackedSource],
    expected_groups: usize,
) -> Result<Vec<VirtualGroup>> {
    let mut groups = Vec::<VirtualGroup>::new();
    let mut current = VirtualGroup { col_offset: 0, width: 0, segments: Vec::new() };
    let mut available_height = num_rows;
    let mut source_row_start = 0usize;
    for (source_idx, source) in sources.iter().enumerate() {
        let mut remaining = source.height;
        let mut consumed = 0usize;
        while remaining > 0 {
            let h = remaining.min(available_height);
            current.segments.push(VirtualSegment {
                start_row: num_rows - available_height,
                len: h,
                source_idx,
                source_row_start: source_row_start + consumed,
            });
            remaining -= h;
            consumed += h;
            available_height -= h;
            if available_height == 0 {
                current.width = source.width;
                groups.push(current);
                current = VirtualGroup { col_offset: 0, width: 0, segments: Vec::new() };
                available_height = num_rows;
            }
        }
        source_row_start = 0;
    }
    if !current.segments.is_empty() {
        current.width = sources.last().context("virtual table has no sources")?.width;
        groups.push(current);
    }
    if groups.len() != expected_groups {
        bail!(
            "virtual group count mismatch: computed={}, expected={expected_groups}",
            groups.len()
        );
    }
    let mut col_offset = 0usize;
    for group in &mut groups {
        group.col_offset = col_offset;
        col_offset += group.width;
    }
    Ok(groups)
}

enum SourceGenerator {
    DualRange { bits: u32 },
    DmaByteCmp,
    DmaRom,
    DmaPrePost(Vec<[u64; 6]>),
    MemAlignRom(Vec<[u64; 6]>),
    ArithTable,
    ArithRange,
    ArithFrops(Vec<(u8, u64, u64)>),
    BinaryTable,
    BinaryExtensionTable,
    BinaryFrops(Vec<(u8, u64, u64)>),
    BinaryExtensionFrops(Vec<(u8, u64, u64)>),
    ArithEqLt,
    KeccakfTable,
}

impl SourceGenerator {
    fn new(table_id: u64) -> Result<Self> {
        Ok(match table_id {
            DUAL_RANGE_7_BITS_ID => Self::DualRange { bits: 7 },
            DUAL_RANGE_BYTE_ID => Self::DualRange { bits: 8 },
            DMA_BYTE_CMP_TABLE_ID => Self::DmaByteCmp,
            DMA_ROM_ID => Self::DmaRom,
            DMA_PRE_POST_TABLE_ID => Self::DmaPrePost(build_dma_pre_post_table()),
            MEMORY_ALIGN_ROM_ID => Self::MemAlignRom(build_mem_align_rom()),
            ARITH_TABLE_ID => Self::ArithTable,
            ARITH_RANGE_TABLE_ID => Self::ArithRange,
            ARITH_FROPS_TABLE_ID => {
                let mut frops = ArithFrops::new();
                frops.build_table();
                Self::ArithFrops(frops.generate_table())
            }
            BINARY_TABLE_ID => Self::BinaryTable,
            BINARY_EXTENSION_TABLE_ID => Self::BinaryExtensionTable,
            BINARY_FROPS_TABLE_ID => {
                let mut frops = BinaryBasicFrops::new();
                frops.build_table();
                Self::BinaryFrops(frops.generate_table())
            }
            BINARY_EXTENSION_FROPS_TABLE_ID => {
                let mut frops = BinaryExtensionFrops::new();
                frops.build_table();
                Self::BinaryExtensionFrops(frops.generate_table())
            }
            ARITH_EQ_LT_TABLE_ID => Self::ArithEqLt,
            KECCAKF_TABLE_ID => Self::KeccakfTable,
            _ => bail!("unsupported virtual source table id {table_id}"),
        })
    }

    fn uid(&self) -> u64 {
        match self {
            Self::ArithFrops(_) | Self::BinaryFrops(_) | Self::BinaryExtensionFrops(_) => {
                OPERATION_BUS_ID
            }
            Self::DualRange { bits: 7 } => DUAL_RANGE_7_BITS_ID,
            Self::DualRange { bits: 8 } => DUAL_RANGE_BYTE_ID,
            Self::DmaByteCmp => DMA_BYTE_CMP_TABLE_ID,
            Self::DmaRom => DMA_ROM_ID,
            Self::DmaPrePost(_) => DMA_PRE_POST_TABLE_ID,
            Self::MemAlignRom(_) => MEMORY_ALIGN_ROM_ID,
            Self::ArithTable => ARITH_TABLE_ID,
            Self::ArithRange => ARITH_RANGE_TABLE_ID,
            Self::BinaryTable => BINARY_TABLE_ID,
            Self::BinaryExtensionTable => BINARY_EXTENSION_TABLE_ID,
            Self::ArithEqLt => ARITH_EQ_LT_TABLE_ID,
            Self::KeccakfTable => KECCAKF_TABLE_ID,
            Self::DualRange { bits } => unreachable!("unsupported dual range bits {bits}"),
        }
    }

    fn width(&self) -> usize {
        match self {
            Self::DualRange { .. } | Self::ArithRange | Self::ArithEqLt => 2,
            Self::DmaByteCmp => 3,
            Self::KeccakfTable | Self::ArithTable => 4,
            Self::DmaPrePost(_) | Self::MemAlignRom(_) => 6,
            Self::DmaRom | Self::BinaryTable | Self::BinaryExtensionTable => 7,
            Self::ArithFrops(_) | Self::BinaryFrops(_) | Self::BinaryExtensionFrops(_) => 8,
        }
    }

    fn height(&self) -> usize {
        match self {
            Self::DualRange { bits } => 1usize << (bits * 2),
            Self::DmaByteCmp => 256 * 255,
            Self::DmaRom => 8 * 8 * 512 * 3,
            Self::DmaPrePost(values) => values.len(),
            Self::MemAlignRom(values) => values.len(),
            Self::ArithTable => 1 << 7,
            Self::ArithRange => 1 << 22,
            Self::ArithFrops(values) => values.len(),
            Self::BinaryTable => (1 << 22) + (1 << 20) + (1 << 18),
            Self::BinaryExtensionTable => (1 << 19) * 6 + (1 << 11) * 3,
            Self::BinaryFrops(values) => values.len(),
            Self::BinaryExtensionFrops(values) => values.len(),
            Self::ArithEqLt => 1 << 18,
            Self::KeccakfTable => keccakf_table_size(),
        }
    }

    fn fill_row(&self, row: usize, out: &mut [u64]) -> Result<()> {
        out.fill(0);
        match self {
            Self::DualRange { bits } => fill_dual_range(*bits, row, out),
            Self::DmaByteCmp => fill_dma_byte_cmp(row, out),
            Self::DmaRom => fill_dma_rom(row, out),
            Self::DmaPrePost(values) => out.copy_from_slice(&values[row]),
            Self::MemAlignRom(values) => out.copy_from_slice(&values[row]),
            Self::ArithTable => {
                out.copy_from_slice(if row < ARITH_TABLE.len() {
                    &ARITH_TABLE[row]
                } else {
                    &ARITH_TABLE[0]
                });
            }
            Self::ArithRange => fill_arith_range(row, out),
            Self::ArithFrops(values)
            | Self::BinaryFrops(values)
            | Self::BinaryExtensionFrops(values) => fill_frops(values[row], out)?,
            Self::BinaryTable => fill_binary_table(row, out),
            Self::BinaryExtensionTable => fill_binary_extension_table(row, out),
            Self::ArithEqLt => fill_arith_eq_lt(row, out),
            Self::KeccakfTable => fill_keccakf_table(row, out),
        }
        Ok(())
    }
}

fn fill_dual_range(bits: u32, row: usize, out: &mut [u64]) {
    let count = 1usize << bits;
    out[0] = (row / count) as u64;
    out[1] = (row % count) as u64;
}

fn fill_dma_byte_cmp(row: usize, out: &mut [u64]) {
    let byte = row / 255;
    let k = row % 255;
    out[0] = byte as u64;
    if k < byte {
        out[1] = 0;
        out[2] = (byte - k) as u64;
    } else {
        let byte2 = k + 1;
        out[1] = 1;
        out[2] = (byte2 - byte) as u64;
    }
}

fn fill_dma_rom(row: usize, out: &mut [u64]) {
    let l_count = row % 512;
    let src_offset = (row / 512) % 8;
    let dst_offset = (row / (512 * 8)) % 8;
    let icase = row / (512 * 8 * 8);
    let use_src = icase < 2;
    let neq = icase == 1;

    out[0] = dst_offset as u64;
    out[1] = src_offset as u64;
    if l_count == 0 {
        out[2] = 0;
        out[3] = 16 + (neq as u64) * 32 + (use_src as u64) * 64;
        out[4] = 0;
        out[5] = src_offset as u64;
        out[6] = 0;
    } else {
        let use_pre = dst_offset > 0;
        let pre_count = if use_pre { (8 - dst_offset).min(l_count) } else { 0 };
        let mut post_count = (l_count - pre_count) % 8;
        let mut loop_count = (l_count - pre_count - post_count) / 8;
        if neq && post_count == 0 && loop_count > 0 {
            loop_count -= 1;
            post_count = 8;
        }
        let use_post = post_count > 0;
        let use_loop = loop_count > 0;
        let src64_inc_by_pre = use_pre && src_offset + pre_count >= 8;
        let count_lt_256 = l_count < 256;
        out[2] = l_count as u64;
        out[3] = (use_pre as u64)
            + (use_loop as u64) * 2
            + (use_post as u64) * 4
            + (src64_inc_by_pre as u64) * 8
            + (count_lt_256 as u64) * 16
            + (neq as u64) * 32
            + (use_src as u64) * 64;
        out[4] = pre_count as u64;
        out[5] = if use_src { ((src_offset + pre_count) % 8) as u64 } else { 0 };
        out[6] = loop_count as u64;
    }
}

fn build_dma_pre_post_table() -> Vec<[u64; 6]> {
    const ENABLED_SECOND_READ: u64 = 1 << 8;
    const DST_OFFSET_GT_SRC: u64 = 1 << 9;
    const SR_VALUE: u64 = 1 << 10;
    const MEMCMP_RESULT_IS_NEG: u64 = 1 << 13;
    const MEMCMP_RESULT_NZ: u64 = 1 << 14;
    const IS_POST: u64 = 1 << 15;
    const LOAD_SRC: u64 = 1 << 16;

    let flags_positive = MEMCMP_RESULT_NZ;
    let flags_negative = MEMCMP_RESULT_NZ + MEMCMP_RESULT_IS_NEG;
    let l_factors = [1u64, 1 << 8, 1 << 16, 1 << 24, 0, 0, 0, 0];
    let h_factors = [0u64, 0, 0, 0, 1, 1 << 8, 1 << 16, 1 << 24];
    let mut rows = Vec::with_capacity(288 * 4);

    for src_offset in 0..8u64 {
        for count in 1..9u64 {
            let selectors = (0xFFu64 << (8 - count)) & 0xFF;
            let enabled_second_read = u64::from(src_offset + count > 8);
            let flags_load_src = selectors
                + ENABLED_SECOND_READ * enabled_second_read
                + LOAD_SRC
                + SR_VALUE * src_offset
                + IS_POST;
            let flags_no_load_src = selectors + SR_VALUE * src_offset + IS_POST;
            let factor_index = count as usize - 1;
            push_dma_pre_post_variants(
                &mut rows,
                flags_load_src,
                flags_no_load_src,
                flags_positive,
                flags_negative,
                0,
                src_offset,
                count,
                l_factors[factor_index],
                h_factors[factor_index],
            );
        }
    }

    for dst_offset in 1..8u64 {
        let mask = 0xFFu64 >> dst_offset;
        for src_offset in 0..8u64 {
            for count in 1..(9 - dst_offset) {
                let selectors = mask & (0xFFu64 << (8 - (dst_offset + count)));
                let enabled_second_read = u64::from(src_offset + count > 8);
                let dst_offset_gt_src_offset = u64::from(dst_offset > src_offset);
                let selr_value = if dst_offset > src_offset {
                    dst_offset - src_offset
                } else {
                    src_offset - dst_offset
                };
                let flags_load_src = selectors
                    + ENABLED_SECOND_READ * enabled_second_read
                    + DST_OFFSET_GT_SRC * dst_offset_gt_src_offset
                    + LOAD_SRC
                    + SR_VALUE * selr_value;
                let flags_no_load_src = selectors
                    + DST_OFFSET_GT_SRC * dst_offset_gt_src_offset
                    + SR_VALUE * selr_value;
                let factor_index = (dst_offset + count - 1) as usize;
                push_dma_pre_post_variants(
                    &mut rows,
                    flags_load_src,
                    flags_no_load_src,
                    flags_positive,
                    flags_negative,
                    dst_offset,
                    src_offset,
                    count,
                    l_factors[factor_index],
                    h_factors[factor_index],
                );
            }
        }
    }
    rows
}

#[allow(clippy::too_many_arguments)]
fn push_dma_pre_post_variants(
    rows: &mut Vec<[u64; 6]>,
    flags_load_src: u64,
    flags_no_load_src: u64,
    flags_positive: u64,
    flags_negative: u64,
    dst_offset: u64,
    src_offset: u64,
    count: u64,
    l_factor: u64,
    h_factor: u64,
) {
    rows.push([flags_load_src, dst_offset, src_offset, count, 0, 0]);
    rows.push([flags_load_src + flags_positive, dst_offset, src_offset, count, l_factor, h_factor]);
    rows.push([
        flags_load_src + flags_negative,
        dst_offset,
        src_offset,
        count,
        field_neg(l_factor),
        field_neg(h_factor),
    ]);
    rows.push([flags_no_load_src, dst_offset, src_offset, count, 0, 0]);
}

fn build_mem_align_rom() -> Vec<[u64; 6]> {
    const CHUNK_NUM: usize = 8;
    let mut offset = vec![0u64; 256];
    let mut width = vec![0u64; 256];
    let mut line = 1usize;

    for off in 0..=7u64 {
        let widths: &[u64] = match off {
            0..=4 => &[1, 2, 4],
            5 | 6 => &[1, 2],
            7 => &[1],
            _ => unreachable!(),
        };
        for w in widths {
            offset[line] = 0;
            width[line] = 8;
            offset[line + 1] = off;
            width[line + 1] = *w;
            line += 2;
        }
    }
    for off in 0..=7u64 {
        let widths: &[u64] = match off {
            0..=4 => &[1, 2, 4],
            5 | 6 => &[1, 2],
            7 => &[1],
            _ => unreachable!(),
        };
        for w in widths {
            offset[line] = 0;
            width[line] = 8;
            offset[line + 1] = 0;
            width[line + 1] = 8;
            offset[line + 2] = off;
            width[line + 2] = *w;
            line += 3;
        }
    }
    for off in 1..=7u64 {
        let widths: &[u64] = match off {
            1..=4 => &[8],
            5 | 6 => &[4, 8],
            7 => &[2, 4, 8],
            _ => unreachable!(),
        };
        for w in widths {
            offset[line] = 0;
            width[line] = 8;
            offset[line + 1] = off;
            width[line + 1] = *w;
            offset[line + 2] = 0;
            width[line + 2] = 8;
            line += 3;
        }
    }
    for off in 1..=7u64 {
        let widths: &[u64] = match off {
            1..=4 => &[8],
            5 | 6 => &[4, 8],
            7 => &[2, 4, 8],
            _ => unreachable!(),
        };
        for w in widths {
            offset[line] = 0;
            width[line] = 8;
            offset[line + 1] = 0;
            width[line + 1] = 8;
            offset[line + 2] = off;
            width[line + 2] = *w;
            offset[line + 3] = 0;
            width[line + 3] = 8;
            offset[line + 4] = 0;
            width[line + 4] = 8;
            line += 5;
        }
    }
    debug_assert_eq!(line, 189);

    let mut rows = vec![[0u64; 6]; 256];
    for i in 0..256usize {
        let mut pc = 0i64;
        let mut delta_pc = 0i64;
        let mut delta_addr = 0i64;
        let mut is_write = 0u64;
        let mut reset = 0u64;
        let mut sel = [0u64; CHUNK_NUM];
        let mut sel_up_to_down = 0u64;
        let mut sel_down_to_up = 0u64;
        let prev_line = if i == 0 { 0 } else { i - 1 };
        let line_i = i;

        if line_i == 0 || line_i > 188 {
            reset = 1;
        } else if line_i < 41 {
            if line_i % 2 == 1 {
                delta_pc = line_i as i64;
                reset = 1;
                for j in 0..CHUNK_NUM {
                    if j as u64 >= offset[i + 1] && (j as u64) < offset[i + 1] + width[i + 1] {
                        sel[j] = 1;
                    }
                }
                sel_up_to_down = 1;
            } else {
                pc = prev_line as i64;
                delta_pc = -pc;
                sel[offset[i] as usize] = 1;
            }
        } else if line_i < 101 {
            if line_i % 3 == 2 {
                delta_pc = line_i as i64;
                reset = 1;
                for j in 0..CHUNK_NUM {
                    if (j as u64) < offset[i + 2] || (j as u64) >= offset[i + 2] + width[i + 2] {
                        sel[j] = 1;
                    }
                }
                sel_up_to_down = 1;
            } else if line_i % 3 == 0 {
                pc = prev_line as i64;
                delta_pc = 1;
                is_write = 1;
                for j in 0..CHUNK_NUM {
                    if j as u64 >= offset[i + 1] && (j as u64) < offset[i + 1] + width[i + 1] {
                        sel[j] = 1;
                    }
                }
                sel_up_to_down = 1;
            } else {
                pc = prev_line as i64;
                delta_pc = -pc;
                is_write = 1;
                sel[offset[i] as usize] = 1;
            }
        } else if line_i < 134 {
            if line_i % 3 == 2 {
                delta_pc = line_i as i64;
                reset = 1;
                for j in 0..CHUNK_NUM {
                    if j as u64 >= offset[i + 1] {
                        sel[j] = 1;
                    }
                }
                sel_up_to_down = 1;
            } else if line_i % 3 == 0 {
                pc = prev_line as i64;
                delta_pc = 1;
                sel[offset[i] as usize] = 1;
            } else {
                pc = prev_line as i64;
                delta_pc = -pc;
                delta_addr = 1;
                for j in 0..CHUNK_NUM {
                    if (j as u64) < (offset[i - 1] + width[i - 1]) % CHUNK_NUM as u64 {
                        sel[j] = 1;
                    }
                }
                sel_down_to_up = 1;
            }
        } else if line_i < 189 {
            if line_i % 5 == 4 {
                delta_pc = line_i as i64;
                reset = 1;
                for j in 0..CHUNK_NUM {
                    if (j as u64) < offset[i + 2] {
                        sel[j] = 1;
                    }
                }
                sel_up_to_down = 1;
            } else if line_i % 5 == 0 {
                pc = prev_line as i64;
                delta_pc = 1;
                is_write = 1;
                for j in 0..CHUNK_NUM {
                    if j as u64 >= offset[i + 1] {
                        sel[j] = 1;
                    }
                }
                sel_up_to_down = 1;
            } else if line_i % 5 == 1 {
                pc = prev_line as i64;
                delta_pc = 1;
                is_write = 1;
                sel[offset[i] as usize] = 1;
            } else if line_i % 5 == 2 {
                pc = prev_line as i64;
                delta_pc = 1;
                delta_addr = 1;
                is_write = 1;
                for j in 0..CHUNK_NUM {
                    if (j as u64) < (offset[i - 1] + width[i - 1]) % CHUNK_NUM as u64 {
                        sel[j] = 1;
                    }
                }
                sel_down_to_up = 1;
            } else {
                pc = prev_line as i64;
                delta_pc = -pc;
                for j in 0..CHUNK_NUM {
                    if j as u64 >= (offset[i - 2] + width[i - 2]) % CHUNK_NUM as u64 {
                        sel[j] = 1;
                    }
                }
                sel_down_to_up = 1;
            }
        }
        let mut flags = 0u64;
        for (j, bit) in sel.iter().enumerate() {
            flags += *bit << j;
        }
        flags += is_write * (1 << CHUNK_NUM)
            + reset * (1 << (CHUNK_NUM + 1))
            + sel_up_to_down * (1 << (CHUNK_NUM + 2))
            + sel_down_to_up * (1 << (CHUNK_NUM + 3));
        rows[i] = [
            field_from_i128(pc as i128),
            field_from_i128(delta_pc as i128),
            field_from_i128(delta_addr as i128),
            offset[i],
            width[i],
            flags,
        ];
    }
    rows
}

const ARITH_TABLE: [[u64; 4]; 74] = [
    [176, 512, 0, 0],
    [177, 0, 0, 0],
    [179, 2048, 3, 1],
    [179, 2052, 6, 1],
    [179, 2068, 6, 2],
    [180, 2560, 4, 1],
    [180, 2564, 7, 1],
    [180, 2568, 5, 1],
    [180, 2572, 8, 1],
    [180, 2580, 7, 2],
    [180, 2584, 5, 2],
    [181, 2048, 4, 1],
    [181, 2052, 7, 1],
    [181, 2056, 5, 1],
    [181, 2060, 8, 1],
    [181, 2068, 7, 2],
    [181, 2072, 5, 2],
    [182, 513, 0, 11],
    [182, 577, 0, 14],
    [184, 1026, 0, 0],
    [184, 1154, 0, 0],
    [185, 2, 0, 0],
    [185, 130, 0, 0],
    [186, 3074, 4, 4],
    [186, 3082, 5, 4],
    [186, 3086, 8, 4],
    [186, 3094, 7, 7],
    [186, 3098, 5, 7],
    [186, 3122, 4, 8],
    [186, 3126, 7, 8],
    [186, 3130, 5, 8],
    [186, 3206, 7, 4],
    [186, 3254, 7, 8],
    [186, 3358, 8, 7],
    [187, 2050, 4, 4],
    [187, 2058, 5, 4],
    [187, 2062, 8, 4],
    [187, 2070, 7, 7],
    [187, 2074, 5, 7],
    [187, 2098, 4, 8],
    [187, 2102, 7, 8],
    [187, 2106, 5, 8],
    [187, 2182, 7, 4],
    [187, 2230, 7, 8],
    [187, 2334, 8, 7],
    [188, 1027, 11, 0],
    [188, 1091, 14, 0],
    [188, 1219, 14, 0],
    [189, 3, 0, 9],
    [189, 67, 0, 10],
    [189, 131, 0, 9],
    [189, 195, 0, 10],
    [190, 3075, 12, 12],
    [190, 3083, 13, 12],
    [190, 3099, 13, 15],
    [190, 3123, 12, 16],
    [190, 3131, 13, 16],
    [190, 3151, 16, 12],
    [190, 3159, 15, 15],
    [190, 3191, 15, 16],
    [190, 3271, 15, 12],
    [190, 3319, 15, 16],
    [190, 3423, 16, 15],
    [191, 2051, 12, 12],
    [191, 2059, 13, 12],
    [191, 2063, 16, 12],
    [191, 2071, 15, 15],
    [191, 2075, 13, 15],
    [191, 2163, 12, 16],
    [191, 2167, 15, 16],
    [191, 2171, 13, 16],
    [191, 2183, 15, 12],
    [191, 2295, 15, 16],
    [191, 2335, 16, 15],
];

fn fill_arith_range(row: usize, out: &mut [u64]) {
    const FULL_IDS: [u64; 25] = [
        0, 1, 2, 9, 10, 11, 12, 13, 14, 15, 16, 17, 20, 23, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,
        36,
    ];
    const POS_IDS: [u64; 9] = [3, 4, 5, 18, 21, 24, 37, 38, 39];
    const NEG_IDS: [u64; 9] = [6, 7, 8, 19, 22, 25, 40, 41, 42];
    let full_len = 1usize << 16;
    let pos_len = 1usize << 15;
    if row < FULL_IDS.len() * full_len {
        out[0] = FULL_IDS[row / full_len];
        out[1] = (row % full_len) as u64;
    } else if row < FULL_IDS.len() * full_len + POS_IDS.len() * pos_len {
        let rel = row - FULL_IDS.len() * full_len;
        out[0] = POS_IDS[rel / pos_len];
        out[1] = (rel % pos_len) as u64;
    } else if row < FULL_IDS.len() * full_len + (POS_IDS.len() + NEG_IDS.len()) * pos_len {
        let rel = row - FULL_IDS.len() * full_len - POS_IDS.len() * pos_len;
        out[0] = NEG_IDS[rel / pos_len];
        out[1] = 0x8000 + (rel % pos_len) as u64;
    } else {
        let rel = row - FULL_IDS.len() * full_len - (POS_IDS.len() + NEG_IDS.len()) * pos_len;
        out[0] = 100;
        out[1] = field_from_i128(-0xEFFFF + rel as i128);
    }
}

fn fill_frops(row: (u8, u64, u64), out: &mut [u64]) -> Result<()> {
    let (op, a, b) = row;
    let (c, flag) = ZiskOp::try_from_code(op)
        .map_err(|_| anyhow::anyhow!("invalid frequent-op opcode {op}"))?
        .call_ab(a, b);
    out[0] = op as u64;
    out[1] = a as u32 as u64;
    out[2] = (a >> 32) as u32 as u64;
    out[3] = b as u32 as u64;
    out[4] = (b >> 32) as u32 as u64;
    out[5] = c as u32 as u64;
    out[6] = (c >> 32) as u32 as u64;
    out[7] = flag as u64;
    Ok(())
}

fn fill_binary_table(row: usize, out: &mut [u64]) {
    let a = (row & 0xFF) as u64;
    let b = ((row >> 8) & 0xFF) as u64;
    let (op, rel) = binary_op_and_rel(row);
    let pos_ind = binary_pos_ind(op, rel);
    let cin = binary_cin(op, rel);
    let (c, flags) = binary_result(op, rel, pos_ind, a, b, cin);
    out[0] = pos_ind;
    out[1] = op;
    out[2] = a;
    out[3] = b;
    out[4] = cin;
    out[5] = c;
    out[6] = flags;
}

fn binary_op_and_rel(row: usize) -> (u64, usize) {
    const OPS: [(u64, usize); 19] = [
        (OP_MINU, (1 << 18) + (1 << 17)),
        (OP_MIN, (1 << 18) + (1 << 17)),
        (OP_MAXU, (1 << 18) + (1 << 17)),
        (OP_MAX, (1 << 18) + (1 << 17)),
        (OP_LT_ABS_NP, 1 << 19),
        (OP_LT_ABS_PN, 1 << 19),
        (OP_LTU, 1 << 18),
        (OP_LT, 1 << 18),
        (OP_GT, 1 << 18),
        (OP_EQ, 1 << 18),
        (OP_ADD, 1 << 18),
        (OP_SUB, 1 << 18),
        (OP_LEU, 1 << 18),
        (OP_LE, 1 << 18),
        (OP_AND, 1 << 17),
        (OP_OR, 1 << 17),
        (OP_XOR, 1 << 17),
        (OP_SEXT_00, (1 << 17) + (1 << 16)),
        (OP_SEXT_FF, (1 << 17) + (1 << 16)),
    ];
    let mut offset = 0usize;
    for (op, len) in OPS {
        if row < offset + len {
            return (op, row - offset);
        }
        offset += len;
    }
    unreachable!("binary table row out of range")
}

fn binary_pos_ind(op: u64, rel: usize) -> u64 {
    match op {
        OP_MINU | OP_MIN | OP_MAXU | OP_MAX => {
            if rel < (1 << 18) {
                0
            } else {
                1
            }
        }
        OP_LT_ABS_NP | OP_LT_ABS_PN => match (rel / (1 << 16)) % 4 {
            0 => 0,
            1 => 1,
            _ => 2,
        },
        OP_LTU | OP_LT | OP_GT | OP_EQ | OP_ADD | OP_SUB | OP_LEU | OP_LE => {
            if (rel / (1 << 16)) % 2 == 0 {
                0
            } else {
                1
            }
        }
        OP_AND | OP_OR | OP_XOR => {
            if rel < (1 << 16) {
                0
            } else {
                1
            }
        }
        OP_SEXT_00 | OP_SEXT_FF => 0,
        _ => unreachable!(),
    }
}

fn binary_cin(op: u64, rel: usize) -> u64 {
    match op {
        OP_MINU | OP_MIN | OP_MAXU | OP_MAX => ((rel / (1 << 16)) % 2) as u64,
        OP_LT_ABS_NP | OP_LT_ABS_PN => {
            if rel < (1 << 18) {
                0
            } else {
                1
            }
        }
        OP_LTU | OP_LT | OP_GT | OP_EQ | OP_ADD | OP_SUB | OP_LEU | OP_LE => {
            if rel < (1 << 17) {
                0
            } else {
                1
            }
        }
        OP_AND | OP_OR | OP_XOR => 0,
        OP_SEXT_00 | OP_SEXT_FF => match rel / (1 << 16) {
            0 => 0,
            1 => 1,
            _ => 0,
        },
        _ => unreachable!(),
    }
}

fn binary_result(op: u64, rel: usize, pos_ind: u64, a: u64, b: u64, cin: u64) -> (u64, u64) {
    const SIGN_BYTE: u64 = 0x80;
    let pfirst = pos_ind == 2;
    let plast = pos_ind == 1;
    let mut c = 0u64;
    let mut cout = 0u64;
    let mut result_is_a = 0u64;
    let mut use_first_byte = 0u64;
    let mut c_is_signed = 0u64;

    match op {
        OP_MINU | OP_MIN => {
            cout = if a < b {
                1
            } else if a == b {
                cin
            } else {
                0
            };
            if !plast {
                result_is_a = u64::from(rel >= (1 << 17));
                c = if result_is_a != 0 { a } else { b };
            } else {
                result_is_a = cout;
                if op == OP_MIN && ((a & SIGN_BYTE) != (b & SIGN_BYTE)) {
                    result_is_a = u64::from((a & SIGN_BYTE) != 0);
                }
                c = if result_is_a != 0 { a } else { b };
                c_is_signed = u64::from((c & SIGN_BYTE) != 0);
                cout = 0;
            }
        }
        OP_MAXU | OP_MAX => {
            cout = if a > b {
                1
            } else if a == b {
                cin
            } else {
                0
            };
            if !plast {
                result_is_a = u64::from(rel >= (1 << 17));
                c = if result_is_a != 0 { a } else { b };
            } else {
                result_is_a = cout;
                if op == OP_MAX && ((a & SIGN_BYTE) != (b & SIGN_BYTE)) {
                    result_is_a = u64::from((b & SIGN_BYTE) != 0);
                }
                c = if result_is_a != 0 { a } else { b };
                c_is_signed = u64::from((c & SIGN_BYTE) != 0);
                cout = 0;
            }
        }
        OP_LT_ABS_NP => {
            let aa = (a ^ 0xFF) as i64;
            let bb = b as i64;
            let sub = if pfirst { (aa + 1) - bb } else { aa - bb };
            cout = if sub < 0 {
                1
            } else if sub == 0 {
                cin
            } else {
                0
            };
            use_first_byte = 1;
        }
        OP_LT_ABS_PN => {
            let aa = a as i64;
            let bb = (b ^ 0xFF) as i64;
            let sub = if pfirst { aa - (bb + 1) } else { aa - bb };
            cout = if sub < 0 {
                1
            } else if sub == 0 {
                cin
            } else {
                0
            };
            use_first_byte = 1;
        }
        OP_LTU | OP_LT => {
            cout = if a < b {
                1
            } else if a == b {
                cin
            } else {
                0
            };
            if op == OP_LT && plast && ((a & SIGN_BYTE) != (b & SIGN_BYTE)) {
                cout = u64::from((a & SIGN_BYTE) != 0);
            }
        }
        OP_GT => {
            cout = if a > b {
                1
            } else if a == b {
                cin
            } else {
                0
            };
            if plast && ((a & SIGN_BYTE) != (b & SIGN_BYTE)) {
                cout = u64::from((b & SIGN_BYTE) != 0);
            }
        }
        OP_EQ => {
            cout = if cin == 0 && a == b { 0 } else { 1 };
            if plast {
                cout = 1 - cout;
            }
        }
        OP_ADD => {
            let sum = cin + a + b;
            c = sum & 0xFF;
            cout = if plast { 0 } else { sum >> 8 };
            if plast {
                c_is_signed = u64::from((c & SIGN_BYTE) != 0);
            }
        }
        OP_SUB => {
            let borrow = u64::from(a < b + cin);
            c = 256 * borrow + a - cin - b;
            cout = if plast { 0 } else { borrow };
            if plast {
                c_is_signed = u64::from((c & SIGN_BYTE) != 0);
            }
        }
        OP_LEU | OP_LE => {
            cout = if a < b {
                0
            } else if a == b {
                cin
            } else {
                1
            };
            if plast {
                cout = 1 - cout;
                if op == OP_LE && ((a & SIGN_BYTE) != (b & SIGN_BYTE)) {
                    cout = u64::from((a & SIGN_BYTE) != 0);
                }
            }
        }
        OP_AND => c = a & b,
        OP_OR => c = a | b,
        OP_XOR => c = a ^ b,
        OP_SEXT_00 => {
            cout = cin;
            c = 0;
            result_is_a = u64::from(rel >= (1 << 17));
        }
        OP_SEXT_FF => {
            cout = cin;
            c = 0xFF;
            result_is_a = u64::from(rel >= (1 << 17));
            c_is_signed = 1;
        }
        _ => unreachable!(),
    }
    (c, cout + 2 * result_is_a + 4 * use_first_byte + 8 * c_is_signed)
}

fn fill_binary_extension_table(row: usize, out: &mut [u64]) {
    let (op, rel) = binary_extension_op_and_rel(row);
    let a = (row & 0xFF) as u64;
    let offset = ((row >> 8) & 0x7) as u64;
    let b = if matches!(op, OP_SEXT_B | OP_SEXT_H | OP_SEXT_W) {
        0
    } else {
        ((rel / (1 << 11)) & 0xFF) as u64
    };
    let (c0, c1, flags) = binary_extension_result(op, offset, a, b);
    out[0] = op;
    out[1] = offset;
    out[2] = a;
    out[3] = b;
    out[4] = c0;
    out[5] = c1;
    out[6] = flags;
}

fn binary_extension_op_and_rel(row: usize) -> (u64, usize) {
    const OPS: [(u64, usize); 9] = [
        (OP_SLL, 1 << 19),
        (OP_SRL, 1 << 19),
        (OP_SRA, 1 << 19),
        (OP_SLL_W, 1 << 19),
        (OP_SRL_W, 1 << 19),
        (OP_SRA_W, 1 << 19),
        (OP_SEXT_B, 1 << 11),
        (OP_SEXT_H, 1 << 11),
        (OP_SEXT_W, 1 << 11),
    ];
    let mut offset = 0usize;
    for (op, len) in OPS {
        if row < offset + len {
            return (op, row - offset);
        }
        offset += len;
    }
    unreachable!("binary extension table row out of range")
}

fn binary_extension_result(op: u64, offset: u64, a: u64, b: u64) -> (u64, u64, u64) {
    const MASK_32: u128 = 0xFFFF_FFFF;
    const MASK_64: u128 = 0xFFFF_FFFF_FFFF_FFFF;
    const SE_MASK_32: u128 = 0xFFFF_FFFF_0000_0000;
    const SE_MASK_16: u128 = 0xFFFF_FFFF_FFFF_0000;
    const SE_MASK_8: u128 = 0xFFFF_FFFF_FFFF_FF00;
    const SIGN_32_BIT: u128 = 0x8000_0000;
    const SIGN_BYTE: u64 = 0x80;
    let a_pos = (a as u128) << (8 * offset);
    let mut out = 0u128;
    let mut op_is_shift = 0u64;
    match op {
        OP_SLL => {
            out = (a_pos << (b & 0x3F)) & MASK_64;
            op_is_shift = 1;
        }
        OP_SRL => {
            out = a_pos >> (b & 0x3F);
            op_is_shift = 1;
        }
        OP_SRA => {
            let shift = b & 0x3F;
            out = a_pos >> shift;
            if offset == 7 && (a & SIGN_BYTE) != 0 && shift > 0 {
                out |= MASK_64 << (64 - shift);
            }
            out &= MASK_64;
            op_is_shift = 1;
        }
        OP_SLL_W => {
            if offset < 4 {
                out = (a_pos << (b & 0x1F)) & MASK_32;
                if (out & SIGN_32_BIT) != 0 {
                    out |= SE_MASK_32;
                }
            }
            op_is_shift = 1;
        }
        OP_SRL_W => {
            if offset < 4 {
                out = (a_pos >> (b & 0x1F)) & MASK_32;
                if (out & SIGN_32_BIT) != 0 {
                    out |= SE_MASK_32;
                }
            }
            op_is_shift = 1;
        }
        OP_SRA_W => {
            if offset < 4 {
                let shift = b & 0x1F;
                out = a_pos >> shift;
                if offset == 3 && (a & SIGN_BYTE) != 0 {
                    out |= MASK_64 << (32 - shift);
                }
                out &= MASK_64;
            }
            op_is_shift = 1;
        }
        OP_SEXT_B => {
            if offset == 0 {
                out = if (a & SIGN_BYTE) != 0 { (a as u128) | SE_MASK_8 } else { a as u128 };
            }
        }
        OP_SEXT_H => {
            if offset == 0 {
                out = a as u128;
            } else if offset == 1 {
                out = if (a & SIGN_BYTE) != 0 { a_pos | SE_MASK_16 } else { a_pos };
            }
        }
        OP_SEXT_W => {
            if offset <= 3 {
                out = a_pos;
                if offset == 3 && (a & SIGN_BYTE) != 0 {
                    out |= SE_MASK_32;
                }
            }
        }
        _ => unreachable!(),
    }
    ((out & MASK_32) as u64, ((out >> 32) & MASK_32) as u64, op_is_shift)
}

fn fill_arith_eq_lt(row: usize, out: &mut [u64]) {
    if row < 65536 {
        out[0] = 0;
        out[1] = row as u64;
    } else if row < 65536 + 65535 {
        out[0] = 1;
        out[1] = field_from_i128(-1 - (row - 65536) as i128);
    } else if row == 65536 + 65535 {
        out[0] = 0xFF;
        out[1] = 0;
    } else if row < 65536 + 65535 + 1 + 65535 {
        let rel = row - (65536 + 65535 + 1);
        out[0] = 2;
        out[1] = (rel + 1) as u64;
    } else if row == 65536 + 65535 + 1 + 65535 {
        out[0] = 0xFF;
        out[1] = 0;
    } else {
        let rel = row - (65536 + 65535 + 1 + 65535 + 1);
        out[0] = 3;
        out[1] = field_from_i128(-(rel as i128));
    }
}

fn fill_keccakf_table(row: usize, out: &mut [u64]) {
    const BASE: usize = 145;
    out[0] = row as u64;
    let mut value = row;
    for j in 0..3 {
        out[1 + j] = (value % BASE % 2) as u64;
        value /= BASE;
    }
}

fn keccakf_table_size() -> usize {
    let mut chunks = 1usize;
    while 145usize.pow((chunks + 1) as u32) < (1 << 23) {
        chunks += 1;
    }
    145usize.pow(chunks as u32)
}

fn required_hint_field<'a>(hint: &'a Hint, name: &str) -> Result<&'a HintField> {
    hint_payload_fields(hint)
        .iter()
        .find(|field| field.name.as_deref() == Some(name))
        .with_context(|| format!("hint {} is missing field {name}", hint.name))
}

fn hint_payload_fields(hint: &Hint) -> &[HintField] {
    hint.hint_fields
        .first()
        .and_then(|field| match field.value.as_ref() {
            Some(hint_field::Value::HintFieldArray(array)) => Some(array.hint_fields.as_slice()),
            _ => None,
        })
        .unwrap_or(&[])
}

fn hint_field_u64(field: &HintField) -> Result<u64> {
    match field.value.as_ref() {
        Some(hint_field::Value::Operand(operand)) => match operand.operand.as_ref() {
            Some(operand::Operand::Constant(constant)) => decode_field_element(&constant.value),
            _ => bail!("hint field {:?} is not a constant operand", field.name),
        },
        _ => bail!("hint field {:?} is not a constant", field.name),
    }
}

fn hint_field_string(field: &HintField) -> Result<&str> {
    match field.value.as_ref() {
        Some(hint_field::Value::StringValue(value)) => Ok(value),
        _ => bail!("hint field {:?} is not a string", field.name),
    }
}

fn hint_field_array_u64(field: &HintField) -> Result<Vec<u64>> {
    let mut values = Vec::new();
    collect_hint_field_u64(field, &mut values)?;
    Ok(values)
}

fn collect_hint_field_u64(field: &HintField, out: &mut Vec<u64>) -> Result<()> {
    match field.value.as_ref() {
        Some(hint_field::Value::HintFieldArray(array)) => {
            for subfield in &array.hint_fields {
                collect_hint_field_u64(subfield, out)?;
            }
            Ok(())
        }
        Some(hint_field::Value::Operand(_)) => {
            out.push(hint_field_u64(field)?);
            Ok(())
        }
        _ => bail!("hint field {:?} is not a numeric array", field.name),
    }
}

fn signed_hint_value(value: u64, neg: bool) -> i64 {
    if neg {
        (value as i128 - GOLDILOCKS_PRIME as i128) as i64
    } else {
        value as i64
    }
}

fn decode_field_element(bytes: &[u8]) -> Result<u64> {
    if bytes.len() > 8 {
        bail!("field element is wider than u64: {} bytes", bytes.len());
    }
    let mut buf = [0u8; 8];
    buf[8 - bytes.len()..].copy_from_slice(bytes);
    Ok(u64::from_be_bytes(buf))
}

fn field_from_i128(value: i128) -> u64 {
    let prime = GOLDILOCKS_PRIME as i128;
    let mut value = value % prime;
    if value < 0 {
        value += prime;
    }
    value as u64
}

fn field_neg(value: u64) -> u64 {
    if value == 0 {
        0
    } else {
        GOLDILOCKS_PRIME - value
    }
}
