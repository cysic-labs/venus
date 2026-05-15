use std::collections::BTreeMap;
use std::fs::File;
use std::io::{Read, Seek, SeekFrom};
use std::path::Path;

use anyhow::{bail, Context, Result};

pub const GOLDILOCKS_P: u64 = 0xFFFF_FFFF_0000_0001;

const MAGIC: &[u8; 4] = b"r1cs";
const VERSION: u32 = 1;
const HEADER_SECTION: u32 = 1;
const CONSTRAINTS_SECTION: u32 = 2;
const WIRE_MAP_SECTION: u32 = 3;
const CUSTOM_GATES_LIST_SECTION: u32 = 4;
const CUSTOM_GATES_USES_SECTION: u32 = 5;

pub type LinearCombination = BTreeMap<u32, u64>;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct R1cs {
    pub n8: u32,
    pub prime: u64,
    pub n_vars: u32,
    pub n_outputs: u32,
    pub n_pub_inputs: u32,
    pub n_prv_inputs: u32,
    pub n_labels: u64,
    pub n_constraints: u32,
    pub constraints: Vec<R1csConstraint>,
    pub wire_map: Vec<u64>,
    pub custom_gates: Vec<CustomGate>,
    pub custom_gate_uses: Vec<CustomGateUse>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct R1csConstraint {
    pub a: LinearCombination,
    pub b: LinearCombination,
    pub c: LinearCombination,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CustomGate {
    pub template_name: String,
    pub parameters: Vec<u64>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CustomGateUse {
    pub id: u32,
    pub signals: Vec<u64>,
}

#[derive(Debug, Clone, Copy)]
struct Section {
    offset: u64,
    size: u64,
}

pub fn read_r1cs(path: &Path) -> Result<R1cs> {
    let mut file =
        File::open(path).with_context(|| format!("failed to open {}", path.display()))?;
    let mut magic = [0u8; 4];
    file.read_exact(&mut magic)?;
    if &magic != MAGIC {
        bail!("{} is not an R1CS file", path.display());
    }

    let version = read_u32(&mut file)?;
    if version != VERSION {
        bail!("unsupported R1CS version {version}");
    }

    let n_sections = read_u32(&mut file)?;
    let mut sections = BTreeMap::new();
    for _ in 0..n_sections {
        let id = read_u32(&mut file)?;
        let size = read_u64(&mut file)?;
        let offset = file.stream_position()?;
        sections.insert(id, Section { offset, size });
        file.seek(SeekFrom::Current(size as i64))?;
    }

    let header = section(&sections, HEADER_SECTION)?;
    file.seek(SeekFrom::Start(header.offset))?;
    let n8 = read_u32(&mut file)?;
    let prime = read_field(&mut file, n8)?;
    if prime != GOLDILOCKS_P {
        bail!("unsupported R1CS prime {prime}; expected Goldilocks {GOLDILOCKS_P}");
    }
    let n_vars = read_u32(&mut file)?;
    let n_outputs = read_u32(&mut file)?;
    let n_pub_inputs = read_u32(&mut file)?;
    let n_prv_inputs = read_u32(&mut file)?;
    let n_labels = read_u64(&mut file)?;
    let n_constraints = read_u32(&mut file)?;
    assert_section_consumed(&mut file, header)?;

    let constraints_section = section(&sections, CONSTRAINTS_SECTION)?;
    file.seek(SeekFrom::Start(constraints_section.offset))?;
    let mut constraints = Vec::with_capacity(n_constraints as usize);
    for _ in 0..n_constraints {
        constraints.push(R1csConstraint {
            a: read_lc(&mut file, n8)?,
            b: read_lc(&mut file, n8)?,
            c: read_lc(&mut file, n8)?,
        });
    }
    assert_section_consumed(&mut file, constraints_section)?;

    let wire_map = if let Some(wire_section) = sections.get(&WIRE_MAP_SECTION) {
        file.seek(SeekFrom::Start(wire_section.offset))?;
        let mut map = Vec::with_capacity(n_vars as usize);
        for _ in 0..n_vars {
            map.push(read_u64(&mut file)?);
        }
        assert_section_consumed(&mut file, *wire_section)?;
        map
    } else {
        Vec::new()
    };

    let custom_gates = if let Some(gates_section) = sections.get(&CUSTOM_GATES_LIST_SECTION) {
        file.seek(SeekFrom::Start(gates_section.offset))?;
        let n_gates = read_u32(&mut file)?;
        let mut gates = Vec::with_capacity(n_gates as usize);
        for _ in 0..n_gates {
            let template_name = read_cstring(&mut file)?;
            let n_parameters = read_u32(&mut file)?;
            let mut parameters = Vec::with_capacity(n_parameters as usize);
            for _ in 0..n_parameters {
                parameters.push(read_field(&mut file, n8)?);
            }
            gates.push(CustomGate { template_name, parameters });
        }
        assert_section_consumed(&mut file, *gates_section)?;
        gates
    } else {
        Vec::new()
    };

    let custom_gate_uses = if let Some(uses_section) = sections.get(&CUSTOM_GATES_USES_SECTION) {
        file.seek(SeekFrom::Start(uses_section.offset))?;
        let n_uses = read_u32(&mut file)?;
        let mut uses = Vec::with_capacity(n_uses as usize);
        for _ in 0..n_uses {
            let id = read_u32(&mut file)?;
            let n_signals = read_u32(&mut file)?;
            let mut signals = Vec::with_capacity(n_signals as usize);
            for _ in 0..n_signals {
                signals.push(read_u64(&mut file)?);
            }
            uses.push(CustomGateUse { id, signals });
        }
        assert_section_consumed(&mut file, *uses_section)?;
        uses
    } else {
        Vec::new()
    };

    Ok(R1cs {
        n8,
        prime,
        n_vars,
        n_outputs,
        n_pub_inputs,
        n_prv_inputs,
        n_labels,
        n_constraints,
        constraints,
        wire_map,
        custom_gates,
        custom_gate_uses,
    })
}

fn section(sections: &BTreeMap<u32, Section>, id: u32) -> Result<Section> {
    sections.get(&id).copied().with_context(|| format!("R1CS section {id} is missing"))
}

fn assert_section_consumed(file: &mut File, section: Section) -> Result<()> {
    let pos = file.stream_position()?;
    let expected = section.offset + section.size;
    if pos != expected {
        bail!("invalid R1CS section read: consumed {pos}, expected {expected}");
    }
    Ok(())
}

fn read_lc(file: &mut File, n8: u32) -> Result<LinearCombination> {
    let n_terms = read_u32(file)?;
    let mut lc = LinearCombination::new();
    for _ in 0..n_terms {
        let signal = read_u32(file)?;
        let value = read_field(file, n8)?;
        if value != 0 {
            lc.insert(signal, value);
        }
    }
    Ok(lc)
}

fn read_field(file: &mut File, n8: u32) -> Result<u64> {
    if n8 > 8 {
        bail!("field element width {n8} does not fit in u64");
    }
    let mut bytes = [0u8; 8];
    file.read_exact(&mut bytes[..n8 as usize])?;
    Ok(u64::from_le_bytes(bytes))
}

fn read_cstring(file: &mut File) -> Result<String> {
    let mut bytes = Vec::new();
    loop {
        let mut byte = [0u8; 1];
        file.read_exact(&mut byte)?;
        if byte[0] == 0 {
            break;
        }
        bytes.push(byte[0]);
    }
    String::from_utf8(bytes).context("R1CS custom gate name is not UTF-8")
}

fn read_u32(file: &mut File) -> Result<u32> {
    let mut bytes = [0u8; 4];
    file.read_exact(&mut bytes)?;
    Ok(u32::from_le_bytes(bytes))
}

fn read_u64(file: &mut File) -> Result<u64> {
    let mut bytes = [0u8; 8];
    file.read_exact(&mut bytes)?;
    Ok(u64::from_le_bytes(bytes))
}

#[cfg(test)]
mod tests {
    use std::io::Write;

    use super::*;

    #[test]
    fn reads_goldilocks_r1cs_with_custom_gates() -> Result<()> {
        let dir = std::env::temp_dir().join(format!("pk_setup_r1cs_test_{}", std::process::id()));
        std::fs::create_dir_all(&dir)?;
        let path = dir.join("test.r1cs");
        write_test_r1cs(&path)?;

        let r1cs = read_r1cs(&path)?;
        assert_eq!(r1cs.n8, 8);
        assert_eq!(r1cs.prime, GOLDILOCKS_P);
        assert_eq!(r1cs.n_vars, 4);
        assert_eq!(r1cs.constraints.len(), 1);
        assert_eq!(r1cs.constraints[0].a.get(&1), Some(&7));
        assert_eq!(r1cs.constraints[0].b.get(&2), Some(&11));
        assert_eq!(r1cs.constraints[0].c.get(&3), Some(&13));
        assert_eq!(r1cs.wire_map, vec![0, 10, 11, 12]);
        assert_eq!(r1cs.custom_gates[0].template_name, "CMul");
        assert_eq!(r1cs.custom_gate_uses[0].signals, vec![1, 2, 3]);

        std::fs::remove_dir_all(&dir)?;
        Ok(())
    }

    fn write_test_r1cs(path: &Path) -> Result<()> {
        let mut sections = Vec::new();

        let mut header = Vec::new();
        write_u32(&mut header, 8)?;
        write_u64(&mut header, GOLDILOCKS_P)?;
        write_u32(&mut header, 4)?;
        write_u32(&mut header, 1)?;
        write_u32(&mut header, 1)?;
        write_u32(&mut header, 1)?;
        write_u64(&mut header, 4)?;
        write_u32(&mut header, 1)?;
        sections.push((HEADER_SECTION, header));

        let mut constraints = Vec::new();
        write_lc(&mut constraints, &[(1, 7)])?;
        write_lc(&mut constraints, &[(2, 11)])?;
        write_lc(&mut constraints, &[(3, 13)])?;
        sections.push((CONSTRAINTS_SECTION, constraints));

        let mut wire_map = Vec::new();
        for value in [0, 10, 11, 12] {
            write_u64(&mut wire_map, value)?;
        }
        sections.push((WIRE_MAP_SECTION, wire_map));

        let mut gates = Vec::new();
        write_u32(&mut gates, 1)?;
        gates.write_all(b"CMul\0")?;
        write_u32(&mut gates, 1)?;
        write_u64(&mut gates, 19)?;
        sections.push((CUSTOM_GATES_LIST_SECTION, gates));

        let mut uses = Vec::new();
        write_u32(&mut uses, 1)?;
        write_u32(&mut uses, 0)?;
        write_u32(&mut uses, 3)?;
        for signal in [1, 2, 3] {
            write_u64(&mut uses, signal)?;
        }
        sections.push((CUSTOM_GATES_USES_SECTION, uses));

        let mut file = File::create(path)?;
        file.write_all(MAGIC)?;
        write_u32(&mut file, VERSION)?;
        write_u32(&mut file, sections.len() as u32)?;
        for (id, data) in sections {
            write_u32(&mut file, id)?;
            write_u64(&mut file, data.len() as u64)?;
            file.write_all(&data)?;
        }
        Ok(())
    }

    fn write_lc(mut out: impl Write, values: &[(u32, u64)]) -> Result<()> {
        write_u32(&mut out, values.len() as u32)?;
        for (signal, value) in values {
            write_u32(&mut out, *signal)?;
            write_u64(&mut out, *value)?;
        }
        Ok(())
    }

    fn write_u32(mut out: impl Write, value: u32) -> Result<()> {
        out.write_all(&value.to_le_bytes())?;
        Ok(())
    }

    fn write_u64(mut out: impl Write, value: u64) -> Result<()> {
        out.write_all(&value.to_le_bytes())?;
        Ok(())
    }
}
