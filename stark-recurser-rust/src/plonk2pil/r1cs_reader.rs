//! Reader for the R1CS binary file format.
//!
//! The R1CS format stores rank-1 constraint systems used by Circom / snarkjs.
//! The binary layout is:
//!
//! - 4-byte magic: `"r1cs"`
//! - u32 LE version (1)
//! - u32 LE num_sections
//! - For each section: u32 LE section_type, u64 LE section_size, then data bytes
//!
//! Section types:
//! - 1: Header
//! - 2: Constraints (A, B, C linear combinations)
//! - 3: Wire-to-label mapping
//! - 4: Custom gates list
//! - 5: Custom gates uses

use anyhow::{bail, Context, Result};
use std::collections::HashMap;
use std::io::{Cursor, Read, Seek, SeekFrom};

use byteorder::{LittleEndian, ReadBytesExt};

/// Section type constants matching the JS implementation.
pub const R1CS_HEADER: u32 = 1;
pub const R1CS_CONSTRAINTS: u32 = 2;
pub const R1CS_WIRE2LABEL: u32 = 3;
pub const R1CS_CUSTOM_GATES_LIST: u32 = 4;
pub const R1CS_CUSTOM_GATES_USES: u32 = 5;

/// A linear combination: mapping from wire index to field-element coefficient.
pub type LinearCombination = HashMap<u32, u64>;

/// A single R1CS constraint: A * B = C, where A, B, C are linear combinations.
#[derive(Debug, Clone)]
pub struct R1csConstraint {
    pub a: LinearCombination,
    pub b: LinearCombination,
    pub c: LinearCombination,
}

/// A custom gate definition (from section 4).
#[derive(Debug, Clone)]
pub struct CustomGate {
    pub template_name: String,
    pub parameters: Vec<u64>,
}

/// A custom gate usage instance (from section 5).
#[derive(Debug, Clone)]
pub struct CustomGateUse {
    pub id: u32,
    pub signals: Vec<u64>,
}

/// Parsed R1CS header information.
#[derive(Debug, Clone)]
pub struct R1csHeader {
    /// Size of a field element in bytes.
    pub n8: u32,
    /// The field prime, stored as raw bytes (little-endian, length `n8`).
    pub prime_bytes: Vec<u8>,
    /// Number of wires (variables).
    pub n_vars: u32,
    /// Number of public outputs.
    pub n_outputs: u32,
    /// Number of public inputs.
    pub n_pub_inputs: u32,
    /// Number of private inputs.
    pub n_prv_inputs: u32,
    /// Number of labels.
    pub n_labels: u64,
    /// Number of constraints.
    pub n_constraints: u32,
    /// Whether custom gates sections are present.
    pub use_custom_gates: bool,
}

/// Complete parsed R1CS file.
#[derive(Debug, Clone)]
pub struct R1csFile {
    pub header: R1csHeader,
    pub constraints: Vec<R1csConstraint>,
    pub wire_to_label: Vec<u64>,
    pub custom_gates: Vec<CustomGate>,
    pub custom_gates_uses: Vec<CustomGateUse>,
}

/// Tracks the position and size of each section in the binary file.
#[derive(Debug, Clone)]
struct SectionInfo {
    offset: u64,
    size: u64,
}

/// Read and parse a complete R1CS file from raw bytes.
///
/// By default loads constraints and custom gates but not the wire-to-label map
/// (matching the JS default). Use `read_r1cs_with_options` for finer control.
pub fn read_r1cs(data: &[u8]) -> Result<R1csFile> {
    read_r1cs_with_options(data, true, false, true)
}

/// Read an R1CS file with configurable loading options.
pub fn read_r1cs_with_options(
    data: &[u8],
    load_constraints: bool,
    load_map: bool,
    load_custom_gates: bool,
) -> Result<R1csFile> {
    let mut cursor = Cursor::new(data);

    // Read and validate magic bytes
    let mut magic = [0u8; 4];
    cursor.read_exact(&mut magic).context("reading magic bytes")?;
    if &magic != b"r1cs" {
        bail!("invalid magic bytes: expected 'r1cs', got {:?}", magic);
    }

    // Read version
    let version = cursor.read_u32::<LittleEndian>().context("reading version")?;
    if version > 1 {
        bail!("unsupported R1CS version: {}", version);
    }

    // Read number of sections
    let n_sections = cursor.read_u32::<LittleEndian>().context("reading num sections")?;

    // Scan section table
    let mut sections: HashMap<u32, Vec<SectionInfo>> = HashMap::new();
    for _ in 0..n_sections {
        let section_type = cursor
            .read_u32::<LittleEndian>()
            .context("reading section type")?;
        let section_size = cursor
            .read_u64::<LittleEndian>()
            .context("reading section size")?;
        let offset = cursor.position();
        sections
            .entry(section_type)
            .or_default()
            .push(SectionInfo { offset, size: section_size });
        cursor
            .seek(SeekFrom::Current(section_size as i64))
            .context("seeking past section")?;
    }

    // Parse header (section 1)
    let header_info = get_unique_section(&sections, R1CS_HEADER)?;
    cursor.set_position(header_info.offset);
    let header = read_header(&mut cursor, &sections)?;

    // Parse constraints (section 2)
    let constraints = if load_constraints {
        let section_info = get_unique_section(&sections, R1CS_CONSTRAINTS)?;
        let section_data = &data[section_info.offset as usize
            ..(section_info.offset + section_info.size) as usize];
        read_constraints(section_data, &header)?
    } else {
        Vec::new()
    };

    // Parse wire-to-label map (section 3)
    let wire_to_label = if load_map {
        if let Ok(section_info) = get_unique_section(&sections, R1CS_WIRE2LABEL) {
            let section_data = &data[section_info.offset as usize
                ..(section_info.offset + section_info.size) as usize];
            read_map(section_data, &header)?
        } else {
            Vec::new()
        }
    } else {
        Vec::new()
    };

    // Parse custom gates
    let (custom_gates, custom_gates_uses) = if load_custom_gates && header.use_custom_gates {
        let gates = {
            let section_info = get_unique_section(&sections, R1CS_CUSTOM_GATES_LIST)?;
            let section_data = &data[section_info.offset as usize
                ..(section_info.offset + section_info.size) as usize];
            read_custom_gates_list(section_data, &header)?
        };
        let uses = {
            let section_info = get_unique_section(&sections, R1CS_CUSTOM_GATES_USES)?;
            let section_data = &data[section_info.offset as usize
                ..(section_info.offset + section_info.size) as usize];
            read_custom_gates_uses(section_data)?
        };
        (gates, uses)
    } else {
        (Vec::new(), Vec::new())
    };

    Ok(R1csFile {
        header,
        constraints,
        wire_to_label,
        custom_gates,
        custom_gates_uses,
    })
}

fn get_unique_section(
    sections: &HashMap<u32, Vec<SectionInfo>>,
    section_type: u32,
) -> Result<SectionInfo> {
    let entries = sections
        .get(&section_type)
        .with_context(|| format!("missing section {}", section_type))?;
    if entries.len() > 1 {
        bail!("duplicate section {}", section_type);
    }
    Ok(entries[0].clone())
}

fn read_header(
    cursor: &mut Cursor<&[u8]>,
    sections: &HashMap<u32, Vec<SectionInfo>>,
) -> Result<R1csHeader> {
    let n8 = cursor.read_u32::<LittleEndian>().context("reading n8")?;

    let mut prime_bytes = vec![0u8; n8 as usize];
    cursor.read_exact(&mut prime_bytes).context("reading prime")?;

    let n_vars = cursor.read_u32::<LittleEndian>().context("reading nVars")?;
    let n_outputs = cursor
        .read_u32::<LittleEndian>()
        .context("reading nOutputs")?;
    let n_pub_inputs = cursor
        .read_u32::<LittleEndian>()
        .context("reading nPubInputs")?;
    let n_prv_inputs = cursor
        .read_u32::<LittleEndian>()
        .context("reading nPrvInputs")?;
    let n_labels = cursor
        .read_u64::<LittleEndian>()
        .context("reading nLabels")?;
    let n_constraints = cursor
        .read_u32::<LittleEndian>()
        .context("reading nConstraints")?;

    let use_custom_gates = sections.contains_key(&R1CS_CUSTOM_GATES_LIST)
        && sections.contains_key(&R1CS_CUSTOM_GATES_USES);

    Ok(R1csHeader {
        n8,
        prime_bytes,
        n_vars,
        n_outputs,
        n_pub_inputs,
        n_prv_inputs,
        n_labels,
        n_constraints,
        use_custom_gates,
    })
}

fn read_constraints(section_data: &[u8], header: &R1csHeader) -> Result<Vec<R1csConstraint>> {
    let n8 = header.n8 as usize;
    let mut pos = 0;
    let mut constraints = Vec::with_capacity(header.n_constraints as usize);

    for i in 0..header.n_constraints {
        let a =
            read_lc(section_data, &mut pos, n8).with_context(|| format!("constraint {} LC A", i))?;
        let b =
            read_lc(section_data, &mut pos, n8).with_context(|| format!("constraint {} LC B", i))?;
        let c =
            read_lc(section_data, &mut pos, n8).with_context(|| format!("constraint {} LC C", i))?;
        constraints.push(R1csConstraint { a, b, c });
    }

    Ok(constraints)
}

fn read_lc(data: &[u8], pos: &mut usize, n8: usize) -> Result<LinearCombination> {
    if *pos + 4 > data.len() {
        bail!("unexpected end of data reading LC term count");
    }
    let n_terms = u32::from_le_bytes(data[*pos..*pos + 4].try_into().unwrap());
    *pos += 4;

    let mut lc = HashMap::with_capacity(n_terms as usize);
    let entry_size = 4 + n8;

    for _ in 0..n_terms {
        if *pos + entry_size > data.len() {
            bail!("unexpected end of data reading LC term");
        }

        let wire_id = u32::from_le_bytes(data[*pos..*pos + 4].try_into().unwrap());
        *pos += 4;

        // Read the coefficient as a field element.
        // For Goldilocks (n8=8), this is a single u64 LE.
        // For larger fields, we read the first 8 bytes as the value
        // (coefficients in Goldilocks circuits fit in u64).
        let coeff = if n8 >= 8 {
            let val = u64::from_le_bytes(data[*pos..*pos + 8].try_into().unwrap());
            *pos += n8;
            val
        } else {
            // For fields smaller than 8 bytes, read available bytes
            let mut bytes = [0u8; 8];
            bytes[..n8].copy_from_slice(&data[*pos..*pos + n8]);
            *pos += n8;
            u64::from_le_bytes(bytes)
        };

        lc.insert(wire_id, coeff);
    }

    Ok(lc)
}

fn read_map(section_data: &[u8], header: &R1csHeader) -> Result<Vec<u64>> {
    let mut map = Vec::with_capacity(header.n_vars as usize);
    let mut pos = 0;

    for _ in 0..header.n_vars {
        if pos + 8 > section_data.len() {
            bail!("unexpected end of data reading wire2label map");
        }
        let label = u64::from_le_bytes(section_data[pos..pos + 8].try_into().unwrap());
        pos += 8;
        map.push(label);
    }

    Ok(map)
}

fn read_custom_gates_list(section_data: &[u8], header: &R1csHeader) -> Result<Vec<CustomGate>> {
    let n8 = header.n8 as usize;
    let mut pos = 0;

    if pos + 4 > section_data.len() {
        bail!("unexpected end of data reading custom gates count");
    }
    let num = u32::from_le_bytes(section_data[pos..pos + 4].try_into().unwrap());
    pos += 4;

    let mut gates = Vec::with_capacity(num as usize);

    for _ in 0..num {
        // Read NUL-terminated string for template name (R1CS section 4 uses
        // actual NUL-terminated strings, not length-prefixed ones).
        let name = read_nul_string(section_data, &mut pos)?;

        if pos + 4 > section_data.len() {
            bail!("unexpected end of data reading custom gate parameters count");
        }
        let num_params = u32::from_le_bytes(section_data[pos..pos + 4].try_into().unwrap());
        pos += 4;

        let mut parameters = Vec::with_capacity(num_params as usize);
        for _ in 0..num_params {
            if pos + n8 > section_data.len() {
                bail!("unexpected end of data reading custom gate parameter");
            }
            let val = if n8 >= 8 {
                let v = u64::from_le_bytes(section_data[pos..pos + 8].try_into().unwrap());
                pos += n8;
                v
            } else {
                let mut bytes = [0u8; 8];
                bytes[..n8].copy_from_slice(&section_data[pos..pos + n8]);
                pos += n8;
                u64::from_le_bytes(bytes)
            };
            parameters.push(val);
        }

        gates.push(CustomGate {
            template_name: name,
            parameters,
        });
    }

    Ok(gates)
}

fn read_custom_gates_uses(section_data: &[u8]) -> Result<Vec<CustomGateUse>> {
    if section_data.len() < 4 {
        bail!("custom gates uses section too short");
    }

    // The JS implementation reads this section as a u32 array
    let n_uses = u32::from_le_bytes(section_data[0..4].try_into().unwrap());
    let mut pos = 4usize;

    let mut uses = Vec::with_capacity(n_uses as usize);

    for _ in 0..n_uses {
        if pos + 8 > section_data.len() {
            bail!("unexpected end of data reading custom gate use");
        }
        let id = u32::from_le_bytes(section_data[pos..pos + 4].try_into().unwrap());
        pos += 4;
        let num_signals = u32::from_le_bytes(section_data[pos..pos + 4].try_into().unwrap());
        pos += 4;

        let mut signals = Vec::with_capacity(num_signals as usize);
        for _ in 0..num_signals {
            if pos + 8 > section_data.len() {
                bail!("unexpected end of data reading custom gate signal");
            }
            // Signals stored as two u32 LE (LSB, MSB) forming a u64
            let lsb = u32::from_le_bytes(section_data[pos..pos + 4].try_into().unwrap()) as u64;
            pos += 4;
            let msb = u32::from_le_bytes(section_data[pos..pos + 4].try_into().unwrap()) as u64;
            pos += 4;
            signals.push(msb * 0x1_0000_0000 + lsb);
        }

        uses.push(CustomGateUse { id, signals });
    }

    Ok(uses)
}

/// Read a length-prefixed string from the data.
///
/// The JS `fd.readString()` method in binfileutils reads a u32 length prefix
/// followed by that many bytes. This is used by some R1CS section readers.
#[allow(dead_code)]
fn read_length_prefixed_string(data: &[u8], pos: &mut usize) -> Result<String> {
    if *pos + 4 > data.len() {
        bail!("unexpected end of data reading string length");
    }
    let len = u32::from_le_bytes(data[*pos..*pos + 4].try_into().unwrap()) as usize;
    *pos += 4;

    if *pos + len > data.len() {
        bail!("unexpected end of data reading string of length {}", len);
    }
    let s = std::str::from_utf8(&data[*pos..*pos + len])
        .context("invalid UTF-8 in string")?
        .to_string();
    *pos += len;

    Ok(s)
}

/// Read a NUL-terminated (C-style) string from the data.
///
/// R1CS section 4 (custom gates list) encodes gate names as raw bytes terminated
/// by a 0x00 byte, matching Rapidsnark's `BinFile::readString()` behaviour.
fn read_nul_string(data: &[u8], pos: &mut usize) -> Result<String> {
    let start = *pos;
    while *pos < data.len() && data[*pos] != 0 {
        *pos += 1;
    }
    if *pos >= data.len() {
        bail!("unexpected end of data reading NUL-terminated string");
    }
    let s = String::from_utf8_lossy(&data[start..*pos]).to_string();
    *pos += 1; // skip NUL terminator
    Ok(s)
}

/// Build a synthetic R1CS binary blob for testing purposes.
/// Creates a minimal file with 1 constraint: wire0 * wire1 = wire2 (all coeff = 1).
#[cfg(test)]
fn build_test_r1cs() -> Vec<u8> {
    let mut buf: Vec<u8> = Vec::new();

    // Magic
    buf.extend_from_slice(b"r1cs");
    // Version = 1
    buf.extend_from_slice(&1u32.to_le_bytes());
    // Num sections = 2 (header + constraints)
    buf.extend_from_slice(&2u32.to_le_bytes());

    // --- Build header section data ---
    let mut header_data: Vec<u8> = Vec::new();
    let n8: u32 = 8;
    header_data.extend_from_slice(&n8.to_le_bytes()); // n8
    // prime (Goldilocks) = 0xFFFFFFFF00000001 in LE
    header_data.extend_from_slice(&0xFFFF_FFFF_0000_0001u64.to_le_bytes());
    header_data.extend_from_slice(&3u32.to_le_bytes()); // nVars = 3
    header_data.extend_from_slice(&1u32.to_le_bytes()); // nOutputs = 1
    header_data.extend_from_slice(&1u32.to_le_bytes()); // nPubInputs = 1
    header_data.extend_from_slice(&1u32.to_le_bytes()); // nPrvInputs = 1
    header_data.extend_from_slice(&3u64.to_le_bytes()); // nLabels = 3
    header_data.extend_from_slice(&1u32.to_le_bytes()); // nConstraints = 1

    // Section 1 descriptor
    buf.extend_from_slice(&R1CS_HEADER.to_le_bytes());
    buf.extend_from_slice(&(header_data.len() as u64).to_le_bytes());
    buf.extend_from_slice(&header_data);

    // --- Build constraints section data ---
    // One constraint: A(wire_0=1) * B(wire_1=1) = C(wire_2=1)
    let mut constraints_data: Vec<u8> = Vec::new();

    // LC A: 1 term, wire=0, coeff=1
    constraints_data.extend_from_slice(&1u32.to_le_bytes()); // nTerms
    constraints_data.extend_from_slice(&0u32.to_le_bytes()); // wire_id
    constraints_data.extend_from_slice(&1u64.to_le_bytes()); // coeff

    // LC B: 1 term, wire=1, coeff=1
    constraints_data.extend_from_slice(&1u32.to_le_bytes());
    constraints_data.extend_from_slice(&1u32.to_le_bytes());
    constraints_data.extend_from_slice(&1u64.to_le_bytes());

    // LC C: 1 term, wire=2, coeff=1
    constraints_data.extend_from_slice(&1u32.to_le_bytes());
    constraints_data.extend_from_slice(&2u32.to_le_bytes());
    constraints_data.extend_from_slice(&1u64.to_le_bytes());

    // Section 2 descriptor
    buf.extend_from_slice(&R1CS_CONSTRAINTS.to_le_bytes());
    buf.extend_from_slice(&(constraints_data.len() as u64).to_le_bytes());
    buf.extend_from_slice(&constraints_data);

    buf
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_read_synthetic_r1cs() {
        let data = build_test_r1cs();
        let r1cs = read_r1cs(&data).expect("should parse synthetic R1CS");

        assert_eq!(r1cs.header.n8, 8);
        assert_eq!(r1cs.header.n_vars, 3);
        assert_eq!(r1cs.header.n_outputs, 1);
        assert_eq!(r1cs.header.n_pub_inputs, 1);
        assert_eq!(r1cs.header.n_prv_inputs, 1);
        assert_eq!(r1cs.header.n_labels, 3);
        assert_eq!(r1cs.header.n_constraints, 1);
        assert!(!r1cs.header.use_custom_gates);

        // Verify prime is Goldilocks
        let prime_val = u64::from_le_bytes(r1cs.header.prime_bytes[..8].try_into().unwrap());
        assert_eq!(prime_val, 0xFFFF_FFFF_0000_0001);

        // Verify constraint
        assert_eq!(r1cs.constraints.len(), 1);
        let c = &r1cs.constraints[0];

        assert_eq!(c.a.len(), 1);
        assert_eq!(*c.a.get(&0).unwrap(), 1u64);

        assert_eq!(c.b.len(), 1);
        assert_eq!(*c.b.get(&1).unwrap(), 1u64);

        assert_eq!(c.c.len(), 1);
        assert_eq!(*c.c.get(&2).unwrap(), 1u64);
    }

    #[test]
    fn test_invalid_magic() {
        let data = b"xxxx\x01\x00\x00\x00\x00\x00\x00\x00";
        let result = read_r1cs(data);
        assert!(result.is_err());
        let err_msg = format!("{}", result.unwrap_err());
        assert!(err_msg.contains("invalid magic"), "error: {}", err_msg);
    }

    #[test]
    fn test_multi_term_constraint() {
        let mut buf: Vec<u8> = Vec::new();

        buf.extend_from_slice(b"r1cs");
        buf.extend_from_slice(&1u32.to_le_bytes());
        buf.extend_from_slice(&2u32.to_le_bytes()); // 2 sections

        // Header
        let mut hdr: Vec<u8> = Vec::new();
        hdr.extend_from_slice(&8u32.to_le_bytes()); // n8
        hdr.extend_from_slice(&0xFFFF_FFFF_0000_0001u64.to_le_bytes()); // prime
        hdr.extend_from_slice(&4u32.to_le_bytes()); // nVars
        hdr.extend_from_slice(&0u32.to_le_bytes()); // nOutputs
        hdr.extend_from_slice(&0u32.to_le_bytes()); // nPubInputs
        hdr.extend_from_slice(&0u32.to_le_bytes()); // nPrvInputs
        hdr.extend_from_slice(&4u64.to_le_bytes()); // nLabels
        hdr.extend_from_slice(&1u32.to_le_bytes()); // nConstraints

        buf.extend_from_slice(&R1CS_HEADER.to_le_bytes());
        buf.extend_from_slice(&(hdr.len() as u64).to_le_bytes());
        buf.extend_from_slice(&hdr);

        // Constraints: A has 2 terms (wire0*3 + wire1*5), B has 1 term (wire2*7), C has 0 terms
        let mut cdata: Vec<u8> = Vec::new();

        // LC A: 2 terms
        cdata.extend_from_slice(&2u32.to_le_bytes());
        cdata.extend_from_slice(&0u32.to_le_bytes());
        cdata.extend_from_slice(&3u64.to_le_bytes());
        cdata.extend_from_slice(&1u32.to_le_bytes());
        cdata.extend_from_slice(&5u64.to_le_bytes());

        // LC B: 1 term
        cdata.extend_from_slice(&1u32.to_le_bytes());
        cdata.extend_from_slice(&2u32.to_le_bytes());
        cdata.extend_from_slice(&7u64.to_le_bytes());

        // LC C: 0 terms
        cdata.extend_from_slice(&0u32.to_le_bytes());

        buf.extend_from_slice(&R1CS_CONSTRAINTS.to_le_bytes());
        buf.extend_from_slice(&(cdata.len() as u64).to_le_bytes());
        buf.extend_from_slice(&cdata);

        let r1cs = read_r1cs(&buf).expect("should parse multi-term R1CS");
        assert_eq!(r1cs.constraints.len(), 1);
        let c = &r1cs.constraints[0];
        assert_eq!(c.a.len(), 2);
        assert_eq!(*c.a.get(&0).unwrap(), 3u64);
        assert_eq!(*c.a.get(&1).unwrap(), 5u64);
        assert_eq!(c.b.len(), 1);
        assert_eq!(*c.b.get(&2).unwrap(), 7u64);
        assert_eq!(c.c.len(), 0);
    }

    #[test]
    fn test_read_with_map() {
        let mut buf: Vec<u8> = Vec::new();

        buf.extend_from_slice(b"r1cs");
        buf.extend_from_slice(&1u32.to_le_bytes());
        buf.extend_from_slice(&3u32.to_le_bytes()); // 3 sections

        // Header
        let mut hdr: Vec<u8> = Vec::new();
        hdr.extend_from_slice(&8u32.to_le_bytes());
        hdr.extend_from_slice(&0xFFFF_FFFF_0000_0001u64.to_le_bytes());
        hdr.extend_from_slice(&3u32.to_le_bytes()); // nVars
        hdr.extend_from_slice(&0u32.to_le_bytes());
        hdr.extend_from_slice(&0u32.to_le_bytes());
        hdr.extend_from_slice(&0u32.to_le_bytes());
        hdr.extend_from_slice(&3u64.to_le_bytes());
        hdr.extend_from_slice(&0u32.to_le_bytes()); // 0 constraints

        buf.extend_from_slice(&R1CS_HEADER.to_le_bytes());
        buf.extend_from_slice(&(hdr.len() as u64).to_le_bytes());
        buf.extend_from_slice(&hdr);

        // Constraints (empty)
        let cdata: Vec<u8> = Vec::new();
        buf.extend_from_slice(&R1CS_CONSTRAINTS.to_le_bytes());
        buf.extend_from_slice(&(cdata.len() as u64).to_le_bytes());

        // Wire2Label map
        let mut map_data: Vec<u8> = Vec::new();
        map_data.extend_from_slice(&100u64.to_le_bytes());
        map_data.extend_from_slice(&200u64.to_le_bytes());
        map_data.extend_from_slice(&300u64.to_le_bytes());

        buf.extend_from_slice(&R1CS_WIRE2LABEL.to_le_bytes());
        buf.extend_from_slice(&(map_data.len() as u64).to_le_bytes());
        buf.extend_from_slice(&map_data);

        let r1cs = read_r1cs_with_options(&buf, true, true, false)
            .expect("should parse R1CS with map");
        assert_eq!(r1cs.wire_to_label, vec![100, 200, 300]);
    }

    /// Regression test: section 4 custom gate names must be parsed as
    /// NUL-terminated strings, not length-prefixed.  A length-prefixed reader
    /// would interpret the first four ASCII bytes of the gate name as a u32
    /// length and fail with "unexpected end of data".
    #[test]
    fn test_custom_gate_nul_terminated_string() {
        let n8: u32 = 8;

        let mut buf: Vec<u8> = Vec::new();
        buf.extend_from_slice(b"r1cs");
        buf.extend_from_slice(&1u32.to_le_bytes()); // version
        buf.extend_from_slice(&4u32.to_le_bytes()); // 4 sections

        // --- Header (section 1) ---
        let mut hdr: Vec<u8> = Vec::new();
        hdr.extend_from_slice(&n8.to_le_bytes());
        hdr.extend_from_slice(&0xFFFF_FFFF_0000_0001u64.to_le_bytes());
        hdr.extend_from_slice(&3u32.to_le_bytes()); // nVars
        hdr.extend_from_slice(&0u32.to_le_bytes()); // nOutputs
        hdr.extend_from_slice(&0u32.to_le_bytes()); // nPubInputs
        hdr.extend_from_slice(&0u32.to_le_bytes()); // nPrvInputs
        hdr.extend_from_slice(&3u64.to_le_bytes()); // nLabels
        hdr.extend_from_slice(&0u32.to_le_bytes()); // nConstraints

        buf.extend_from_slice(&R1CS_HEADER.to_le_bytes());
        buf.extend_from_slice(&(hdr.len() as u64).to_le_bytes());
        buf.extend_from_slice(&hdr);

        // --- Constraints (section 2, empty) ---
        buf.extend_from_slice(&R1CS_CONSTRAINTS.to_le_bytes());
        buf.extend_from_slice(&0u64.to_le_bytes());

        // --- Custom gates list (section 4) ---
        let mut sec4: Vec<u8> = Vec::new();
        sec4.extend_from_slice(&1u32.to_le_bytes()); // 1 gate
        sec4.extend_from_slice(b"Poseidon16\0");     // NUL-terminated name
        sec4.extend_from_slice(&2u32.to_le_bytes()); // 2 parameters
        sec4.extend_from_slice(&42u64.to_le_bytes()); // param 0
        sec4.extend_from_slice(&99u64.to_le_bytes()); // param 1

        buf.extend_from_slice(&R1CS_CUSTOM_GATES_LIST.to_le_bytes());
        buf.extend_from_slice(&(sec4.len() as u64).to_le_bytes());
        buf.extend_from_slice(&sec4);

        // --- Custom gates uses (section 5, empty list) ---
        let mut sec5: Vec<u8> = Vec::new();
        sec5.extend_from_slice(&0u32.to_le_bytes()); // 0 uses

        buf.extend_from_slice(&R1CS_CUSTOM_GATES_USES.to_le_bytes());
        buf.extend_from_slice(&(sec5.len() as u64).to_le_bytes());
        buf.extend_from_slice(&sec5);

        // Parse
        let r1cs = read_r1cs(&buf).expect("should parse R1CS with custom gate");
        assert!(r1cs.header.use_custom_gates);
        assert_eq!(r1cs.custom_gates.len(), 1);
        assert_eq!(r1cs.custom_gates[0].template_name, "Poseidon16");
        assert_eq!(r1cs.custom_gates[0].parameters, vec![42, 99]);
        assert!(r1cs.custom_gates_uses.is_empty());
    }
}
