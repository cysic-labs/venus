//! Fixed column I/O: read and write fixed polynomial binary files.
//!
//! Ports `readFixedPolsBin` and `writeFixedPolsBin` from
//! `pil2-proofman-js/src/pil2-stark/witness_computation/fixed_cols.js`,
//! and `generateFixedCols` from `witness_calculator.js`.

use std::collections::HashMap;
use std::fs::File;
use std::io::{self, BufReader, BufWriter, Read, Write};

use anyhow::{bail, Result};

/// Metadata for a single fixed polynomial column within a binary file.
#[derive(Debug, Clone)]
pub struct FixedPolInfo {
    pub lengths: Vec<u32>,
    pub values: Vec<u64>,
}

/// Read a fixed polynomial binary file (.cnst format).
///
/// Returns a map from `"{airgroupName}_{airName}"` to a map of
/// polynomial name -> vector of `FixedPolInfo` entries.
///
/// File layout:
///   - 4-byte magic "cnst"
///   - u32 LE version
///   - u32 LE number of sections (1)
///   - Section 1:
///     - u32 LE section_id, u64 LE section_size
///     - string: airgroup_name
///     - string: air_name
///     - u64 LE: N (number of rows)
///     - u32 LE: nFixedPols
///     - For each fixed pol:
///       - string: name
///       - u32 LE: n_lengths
///       - u32 LE * n_lengths: lengths
///       - u64 LE * N: values
pub fn read_fixed_pols_bin(
    fixed_info: &mut HashMap<String, HashMap<String, Vec<FixedPolInfo>>>,
    bin_filename: &str,
) -> Result<()> {
    let file = File::open(bin_filename)?;
    let mut reader = BufReader::new(file);

    // Read header
    let mut magic = [0u8; 4];
    reader.read_exact(&mut magic)?;
    if &magic != b"cnst" {
        bail!("Invalid magic in fixed pols file: expected 'cnst'");
    }

    let _version = read_u32_le(&mut reader)?;
    let _n_sections = read_u32_le(&mut reader)?;

    // Read section header
    let _section_id = read_u32_le(&mut reader)?;
    let _section_size = read_u64_le(&mut reader)?;

    // Read data
    let airgroup_name = read_string(&mut reader)?;
    let air_name = read_string(&mut reader)?;
    let n = read_u64_le(&mut reader)?;
    let n_fixed_pols = read_u32_le(&mut reader)?;

    let mut pols_info: HashMap<String, Vec<FixedPolInfo>> = HashMap::new();

    for _ in 0..n_fixed_pols {
        let name = read_string(&mut reader)?;
        let n_lengths = read_u32_le(&mut reader)?;
        let mut lengths = Vec::with_capacity(n_lengths as usize);
        for _ in 0..n_lengths {
            lengths.push(read_u32_le(&mut reader)?);
        }

        let mut values = Vec::with_capacity(n as usize);
        let mut buf = vec![0u8; n as usize * 8];
        reader.read_exact(&mut buf)?;
        for i in 0..n as usize {
            let val = u64::from_le_bytes([
                buf[i * 8],
                buf[i * 8 + 1],
                buf[i * 8 + 2],
                buf[i * 8 + 3],
                buf[i * 8 + 4],
                buf[i * 8 + 5],
                buf[i * 8 + 6],
                buf[i * 8 + 7],
            ]);
            values.push(val);
        }

        pols_info
            .entry(name)
            .or_insert_with(Vec::new)
            .push(FixedPolInfo { lengths, values });
    }

    let key = format!("{}_{}", airgroup_name, air_name);
    fixed_info.insert(key, pols_info);

    Ok(())
}

/// Write a fixed polynomial binary file (.cnst format).
///
/// `fixed_info` is a list of (name, lengths, values) tuples.
pub fn write_fixed_pols_bin(
    bin_filename: &str,
    airgroup_name: &str,
    air_name: &str,
    n: u64,
    fixed_info: &[(String, Vec<u32>, Vec<u64>)],
) -> Result<()> {
    let file = File::create(bin_filename)?;
    let mut writer = BufWriter::new(file);

    // We need to know the section size, so we build the section payload first
    let mut section_payload: Vec<u8> = Vec::new();

    // airgroup_name
    write_string_to_buf(&mut section_payload, airgroup_name)?;
    // air_name
    write_string_to_buf(&mut section_payload, air_name)?;
    // N
    section_payload.extend_from_slice(&n.to_le_bytes());
    // nFixedPols
    section_payload.extend_from_slice(&(fixed_info.len() as u32).to_le_bytes());

    for (name, lengths, values) in fixed_info {
        write_string_to_buf(&mut section_payload, name)?;
        section_payload.extend_from_slice(&(lengths.len() as u32).to_le_bytes());
        for &len in lengths {
            section_payload.extend_from_slice(&len.to_le_bytes());
        }
        for &val in values {
            section_payload.extend_from_slice(&val.to_le_bytes());
        }
    }

    // Write header: magic, version, n_sections
    writer.write_all(b"cnst")?;
    writer.write_all(&1u32.to_le_bytes())?; // version
    writer.write_all(&1u32.to_le_bytes())?; // n_sections

    // Write section header
    writer.write_all(&1u32.to_le_bytes())?; // section_id
    writer.write_all(&(section_payload.len() as u64).to_le_bytes())?; // section_size
    writer.write_all(&section_payload)?;

    writer.flush()?;
    Ok(())
}

/// Generate a flat fixed-column buffer from the pilout for a single air.
///
/// Returns `(n_fixed_cols, buffer)` where buffer is n_fixed_cols * N u64 values
/// in row-major layout (all columns for row 0, then all columns for row 1, etc.)
///
/// This is a simplified version of the JS `generateFixedCols` that extracts
/// fixed column values directly from the protobuf `FixedCol` data.
pub fn generate_fixed_cols_buffer(
    air: &pilout::pilout::Air,
) -> (usize, Vec<u64>) {
    let n_rows = 1usize << air.num_rows.unwrap_or(0);
    let n_fixed = air.fixed_cols.len();

    let mut buffer = vec![0u64; n_fixed * n_rows];

    for (col_idx, fixed_col) in air.fixed_cols.iter().enumerate() {
        for (row, val_bytes) in fixed_col.values.iter().enumerate() {
            if row >= n_rows {
                break;
            }
            let val = bytes_to_u64_le(val_bytes);
            buffer[row * n_fixed + col_idx] = val;
        }
    }

    (n_fixed, buffer)
}

/// Write a flat fixed-column buffer to a raw binary file (column-major u64 LE).
///
/// The format matches what bctree expects: n_cols * N u64 values, row-major.
pub fn write_fixed_cols_raw(
    path: &str,
    buffer: &[u64],
) -> Result<()> {
    let file = File::create(path)?;
    let mut writer = BufWriter::new(file);
    for &val in buffer {
        writer.write_all(&val.to_le_bytes())?;
    }
    writer.flush()?;
    Ok(())
}

// ------ Internal helpers ------

fn read_u32_le(reader: &mut impl Read) -> io::Result<u32> {
    let mut buf = [0u8; 4];
    reader.read_exact(&mut buf)?;
    Ok(u32::from_le_bytes(buf))
}

fn read_u64_le(reader: &mut impl Read) -> io::Result<u64> {
    let mut buf = [0u8; 8];
    reader.read_exact(&mut buf)?;
    Ok(u64::from_le_bytes(buf))
}

fn read_string(reader: &mut impl Read) -> io::Result<String> {
    let len = read_u32_le(reader)? as usize;
    let mut buf = vec![0u8; len];
    reader.read_exact(&mut buf)?;
    String::from_utf8(buf).map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))
}

fn write_string_to_buf(buf: &mut Vec<u8>, s: &str) -> io::Result<()> {
    buf.extend_from_slice(&(s.len() as u32).to_le_bytes());
    buf.extend_from_slice(s.as_bytes());
    Ok(())
}

fn bytes_to_u64_le(bytes: &[u8]) -> u64 {
    let mut val = 0u64;
    for (i, &b) in bytes.iter().enumerate().take(8) {
        val |= (b as u64) << (i * 8);
    }
    val
}
