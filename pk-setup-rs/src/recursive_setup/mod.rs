#[allow(dead_code)]
pub mod manifest;
#[allow(dead_code)]
pub mod plonk;
#[allow(dead_code)]
pub mod r1cs;
#[allow(dead_code)]
pub mod runtime;

use std::path::{Path, PathBuf};

use anyhow::{Context, Result};

pub use plonk::PlonkLayoutKind;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RecursiveLayoutArtifacts {
    pub const_path: PathBuf,
    pub exec_path: PathBuf,
    pub dat_path: PathBuf,
    pub n_bits: u32,
    pub n_rows: usize,
    pub n_constants: usize,
    pub n_committed_pols: usize,
}

#[allow(dead_code)]
pub fn write_layout_from_r1cs_file(
    r1cs_path: &Path,
    setup_path: &Path,
    kind: PlonkLayoutKind,
    namespace: &str,
) -> Result<RecursiveLayoutArtifacts> {
    let r1cs = r1cs::read_r1cs(r1cs_path)
        .with_context(|| format!("failed to read R1CS {}", r1cs_path.display()))?;
    write_layout(&r1cs, setup_path, kind, namespace)
}

pub fn write_layout(
    r1cs: &r1cs::R1cs,
    setup_path: &Path,
    kind: PlonkLayoutKind,
    namespace: &str,
) -> Result<RecursiveLayoutArtifacts> {
    let program = plonk::r1cs_to_plonk(r1cs)?;
    let layout = plonk::build_layout_from_program(r1cs, &program, kind, namespace)?;
    let const_path = setup_path.with_extension("const");
    let exec_path = setup_path.with_extension("exec");
    let dat_path = setup_path.with_extension("dat");
    plonk::write_const_file(&const_path, &layout.fixed_columns)?;
    plonk::write_exec_file(&exec_path, &program.additions, &layout.signal_map)?;
    runtime::write_runtime_dat_file(&dat_path, r1cs)?;
    runtime::write_exec_sidecars(setup_path, r1cs, &program.additions, &layout.signal_map)?;

    Ok(RecursiveLayoutArtifacts {
        const_path,
        exec_path,
        dat_path,
        n_bits: layout.shape.n_bits,
        n_rows: layout.shape.n_rows,
        n_constants: layout.fixed_columns.len(),
        n_committed_pols: layout.signal_map.len(),
    })
}

#[cfg(test)]
mod tests {
    use anyhow::Result;

    use super::*;
    use crate::recursive_setup::r1cs::{R1cs, R1csConstraint, GOLDILOCKS_P};

    #[test]
    fn writes_recursive_const_and_exec_files() -> Result<()> {
        let dir = std::env::temp_dir()
            .join(format!("pk_setup_recursive_layout_test_{}", std::process::id()));
        std::fs::create_dir_all(&dir)?;
        let setup_path = dir.join("recursive2");
        let r1cs = R1cs {
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
        };

        let artifacts =
            write_layout(&r1cs, &setup_path, PlonkLayoutKind::Aggregation, "Recursive")?;
        assert_eq!(artifacts.n_constants, 49);
        assert_eq!(artifacts.n_committed_pols, 59);
        assert!(artifacts.const_path.exists());
        assert!(artifacts.exec_path.exists());
        assert!(artifacts.dat_path.exists());
        assert_eq!(std::fs::metadata(&artifacts.const_path)?.len(), (49 * 8) as u64);
        assert_eq!(std::fs::metadata(&artifacts.exec_path)?.len(), (2 + 59) * 8);
        assert_eq!(&std::fs::read(&artifacts.dat_path)?[..8], b"PIL2RSPD");

        std::fs::remove_dir_all(&dir)?;
        Ok(())
    }
}
