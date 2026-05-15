use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use constraint_generation::{build_circuit, BuildConfig};
use constraint_writers::ConstraintExporter;
use program_structure::constants::UsefulConstants;
use program_structure::error_definition::Report;

const CIRCOM_COMPILER_VERSION: &str = "2.2.3";
const GOLDILOCKS_PRIME: &str = "goldilocks";

#[derive(Debug, Clone)]
pub struct CircomR1csConfig {
    pub input: PathBuf,
    pub include_dirs: Vec<PathBuf>,
    pub output: PathBuf,
}

#[allow(dead_code)]
pub fn compile_goldilocks_r1cs(config: &CircomR1csConfig) -> Result<()> {
    let input = config.input.display().to_string();
    let output = config.output.display().to_string();
    let include_dirs = config.include_dirs.clone();
    if let Some(parent) = config.output.parent() {
        std::fs::create_dir_all(parent)
            .with_context(|| format!("failed to create {}", parent.display()))?;
    }

    let prime = UsefulConstants::new(&GOLDILOCKS_PRIME.to_string()).get_p().clone();
    let mut program_archive =
        match parser::run_parser(input, CIRCOM_COMPILER_VERSION, include_dirs, &prime, false) {
            Ok((program_archive, warnings)) => {
                Report::print_reports(&warnings, program_archive.get_file_library());
                program_archive
            }
            Err((file_library, reports)) => {
                Report::print_reports(&reports, &file_library);
                anyhow::bail!("failed to parse Circom source {}", config.input.display());
            }
        };

    match type_analysis::check_types::check_types(&mut program_archive) {
        Ok(warnings) => {
            Report::print_reports(&warnings, program_archive.get_file_library());
        }
        Err(errors) => {
            Report::print_reports(&errors, program_archive.get_file_library());
            anyhow::bail!("failed to type-check Circom source {}", config.input.display());
        }
    }

    let custom_gates = program_archive.custom_gates;
    let (exporter, _) = build_circuit(
        program_archive,
        BuildConfig {
            no_rounds: 0,
            flag_json_sub: false,
            json_substitutions: String::new(),
            flag_s: true,
            flag_f: false,
            flag_p: false,
            flag_verbose: false,
            flag_old_heuristics: false,
            inspect_constraints: false,
            prime: GOLDILOCKS_PRIME.to_string(),
        },
    )
    .map_err(|_| anyhow::anyhow!("failed to build Circom constraints for {}", config.input.display()))?;

    write_r1cs(exporter.as_ref(), &output, custom_gates)
        .map_err(|_| anyhow::anyhow!("failed to write R1CS {}", config.output.display()))?;
    Ok(())
}

fn write_r1cs(exporter: &dyn ConstraintExporter, output: &str, custom_gates: bool) -> Result<(), ()> {
    exporter.r1cs(output, custom_gates)
}

#[allow(dead_code)]
pub fn compile_file_to_r1cs(
    input: impl AsRef<Path>,
    include_dirs: impl IntoIterator<Item = impl Into<PathBuf>>,
    output: impl AsRef<Path>,
) -> Result<()> {
    compile_goldilocks_r1cs(&CircomR1csConfig {
        input: input.as_ref().to_path_buf(),
        include_dirs: include_dirs.into_iter().map(Into::into).collect(),
        output: output.as_ref().to_path_buf(),
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn compiles_simple_circom_to_r1cs() -> Result<()> {
        let dir = std::env::temp_dir().join(format!("pk_setup_circom_test_{}", std::process::id()));
        std::fs::create_dir_all(&dir)?;
        let input = dir.join("mul.circom");
        let output = dir.join("mul.r1cs");
        std::fs::write(
            &input,
            r#"
pragma circom 2.1.0;

template Mul() {
    signal input a;
    signal input b;
    signal output c;

    c <== a * b;
}

component main {public [a]} = Mul();
"#,
        )?;

        compile_file_to_r1cs(&input, [dir.clone()], &output)?;
        let r1cs = crate::recursive_setup::r1cs::read_r1cs(&output)?;
        assert_eq!(r1cs.n_constraints, 1);
        assert_eq!(r1cs.n_pub_inputs, 1);

        std::fs::remove_dir_all(&dir)?;
        Ok(())
    }
}
