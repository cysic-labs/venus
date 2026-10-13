use anyhow::Context;
use anyhow::Result;
use std::{
    path::{Path, PathBuf},
    process::{Command, Stdio},
};
use zisk_common::{ElfBinaryFromFile, ElfBinaryLike};
use zisk_core::{is_elf_file, AsmGenerationMethod, Riscv2zisk};

use crate::get_elf_data_hash_from_path;

fn find_workspace_root(start: &Path) -> Option<PathBuf> {
    let mut current = Some(start);

    while let Some(dir) = current {
        let cargo_toml = dir.join("Cargo.toml");

        if cargo_toml.exists() {
            if let Ok(contents) = std::fs::read_to_string(&cargo_toml) {
                if contents.contains("[workspace]") {
                    return Some(dir.to_path_buf());
                }
            }
        }

        current = dir.parent();
    }

    None
}

pub fn resolve_emulator_asm() -> Result<PathBuf> {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));

    let workspace_root =
        if manifest_dir.exists() { find_workspace_root(&manifest_dir) } else { None };

    let cargo_available = Command::new("cargo")
        .arg("--version")
        .status()
        .map(|status| status.success())
        .unwrap_or(false);

    // Check if we can build from workspace (need both cargo and workspace with ziskclib)
    let can_build_from_workspace = cargo_available
        && if let Some(ref root) = workspace_root {
            let candidate = root.join("emulator-asm");
            let ziskclib_path = root.join("ziskclib");
            candidate.exists() && ziskclib_path.exists()
        } else {
            false
        };

    let installed_path = crate::get_default_zisk_path();
    let installed_asm_path = installed_path.join("zisk/emulator-asm");

    let emulator_asm_path = if can_build_from_workspace {
        let candidate = workspace_root.unwrap().join("emulator-asm");
        tracing::debug!("Using emulator-asm from workspace: {}", candidate.display());
        candidate
    } else {
        if !cargo_available {
            tracing::debug!(
                "Cargo not available, using installed path: {}",
                installed_asm_path.display()
            );
        } else if workspace_root.is_none() {
            tracing::debug!(
                "No workspace found, using installed path: {}",
                installed_asm_path.display()
            );
        } else {
            tracing::debug!(
                "Workspace missing ziskclib source, using installed path: {}",
                installed_asm_path.display()
            );
        }

        installed_asm_path.clone()
    };

    tracing::info!("Looking for emulator-asm at: {}", emulator_asm_path.display());

    if !emulator_asm_path.exists() {
        anyhow::bail!("emulator-asm directory not found at: {}", emulator_asm_path.display());
    }

    let emulator_parent =
        emulator_asm_path.parent().context("Failed to get parent directory of emulator-asm")?;
    let ziskclib_path = emulator_parent.join("ziskclib");

    let target_lib_path = if emulator_asm_path == installed_asm_path {
        // For installed path, look in .zisk/bin/
        installed_path.join("bin").join("libziskclib.a")
    } else {
        // For workspace builds, look in target/release/
        emulator_parent.join("target/release/libziskclib.a")
    };

    tracing::info!("Looking for ziskclib at: {}", target_lib_path.display());

    // Only try to build if cargo is available and ziskclib source exists
    if cargo_available && ziskclib_path.exists() {
        tracing::debug!("Found ziskclib at: {}", ziskclib_path.display());
        tracing::debug!("Building ziskclib...");

        let output = Command::new("cargo")
            .args(["build", "--release", "-p", "ziskclib"])
            .current_dir(emulator_parent)
            .output()
            .context("Failed to execute cargo build for ziskclib")?;

        if !output.status.success() {
            let stderr = String::from_utf8_lossy(&output.stderr);
            let stdout = String::from_utf8_lossy(&output.stdout);
            anyhow::bail!("Failed to build ziskclib:\nstdout: {}\nstderr: {}", stdout, stderr);
        }

        if !target_lib_path.exists() {
            anyhow::bail!(
                "ziskclib build succeeded but library not found at: {}",
                target_lib_path.display()
            );
        }

        tracing::debug!("ziskclib built successfully at: {}", target_lib_path.display());
    } else {
        if !target_lib_path.exists() {
            if emulator_asm_path == installed_path {
                anyhow::bail!(
                    "Pre-built libziskclib.a not found at: {}\nPlease ensure zisk is properly installed",
                    target_lib_path.display()
                );
            } else if cargo_available {
                anyhow::bail!(
                    "libziskclib.a not found at: {}\nziskclib directory not found at: {}\nCannot build or locate ziskclib library",
                    target_lib_path.display(),
                    ziskclib_path.display()
                );
            } else {
                anyhow::bail!(
                    "libziskclib.a not found at: {}\nCargo not available for building from source\nConsider using the installed version instead",
                    target_lib_path.display()
                );
            }
        }
        tracing::debug!("Using existing ziskclib at: {}", target_lib_path.display());
    }

    Ok(emulator_asm_path)
}

/// Whether `c` can be part of a file name handed to `make` without being interpreted by `make`,
/// which expands `$` references in variable values, or by the shell that runs its recipes.
fn is_make_safe_char(c: char) -> bool {
    c.is_ascii_alphanumeric() || matches!(c, '.' | '_' | '-')
}

/// Returns `path` as a string that `make` and its recipe shell take literally.
fn make_safe_path(path: &Path) -> Result<&str> {
    path.to_str()
        .filter(|path| path.chars().all(|c| c == '/' || is_make_safe_char(c)))
        .with_context(|| {
            format!("Path {} contains characters that make would interpret", path.display())
        })
}

/// Paths of the assembly emulator binaries of an ELF in `output_path`, for the minimal trace, the
/// ROM histogram and the memory operations, in this order. They are built with `make`, so every
/// character of the ELF name that `make` could interpret is replaced by `_`.
pub fn assembly_file_paths(
    output_path: &Path,
    elf_name: &str,
    elf_hash: &str,
    hints: bool,
) -> [PathBuf; 3] {
    let name: String =
        elf_name.chars().map(|c| if is_make_safe_char(c) { c } else { '_' }).collect();
    let hints = if hints { "-hints" } else { "" };
    ["mt", "rh", "mo"]
        .map(|trace| output_path.join(format!("{name}{hints}-{elf_hash}-{trace}.bin")))
}

/// Get the paths to all assembly binary files for a given ELF and output path
pub fn get_assembly_file_paths(
    elf: &Path,
    output_path: &Path,
    hints: bool,
) -> Result<Vec<PathBuf>> {
    let elf_hash = get_elf_data_hash_from_path(elf)?;

    let stem = elf
        .file_stem()
        .context("Failed to extract file stem from ELF path")?
        .to_str()
        .context("Failed to convert ELF file stem to string")?;

    Ok(assembly_file_paths(output_path, stem, &elf_hash, hints).to_vec())
}

/// Check if all assembly binary files exist for a given ELF and output path
pub fn assembly_files_exist(elf: &Path, output_path: &Path, hints: bool) -> Result<bool> {
    let files = get_assembly_file_paths(elf, output_path, hints)?;
    Ok(files.iter().all(|f| f.exists()))
}

pub fn gen_assembly(
    elf: &Path,
    output_dir: &Option<PathBuf>,
    hints: bool,
    verbose: bool,
) -> Result<(), anyhow::Error> {
    gen_assembly_from_elf(&ElfBinaryFromFile::new(elf, hints)?, output_dir, verbose)
}

/// Generates the assembly setup from an already loaded ELF, so that it is derived from the same
/// bytes as the rest of the ROM setup.
pub fn gen_assembly_from_elf(
    _elf: &impl ElfBinaryLike,
    _output_dir: &Option<PathBuf>,
    _verbose: bool,
) -> Result<(), anyhow::Error> {
    // Assembly setup is not needed on macOS due to the lack of support for assembly generation.
    #[cfg(not(target_os = "macos"))]
    {
        let output_path = crate::get_output_path(_output_dir)?;
        tracing::info!("Computing assembly setup");
        generate_assembly(
            _elf.elf(),
            _elf.name(),
            output_path.as_path(),
            _elf.with_hints(),
            _verbose,
        )?;
        tracing::info!("Assembly setup generated at {}", output_path.display());
    }
    Ok(())
}

pub fn generate_assembly(
    elf: &[u8],
    elf_name: &str,
    output_path: &Path,
    hints: bool,
    verbose: bool,
) -> Result<(), anyhow::Error> {
    let elf_hash = blake3::hash(elf).to_hex().to_string();

    if !is_elf_file(elf).context("Error reading ROM file")? {
        anyhow::bail!("ROM file is not a valid ELF file");
    }

    let [bin_mt_file, bin_rh_file, bin_mo_file] =
        assembly_file_paths(output_path, elf_name, &elf_hash, hints);

    // The file names are make-safe by construction, but the output directory is chosen by the user
    make_safe_path(output_path)?;

    let emulator_asm_path = resolve_emulator_asm()?;

    let emulator_asm_path =
        emulator_asm_path.to_str().context("Failed to convert emulator-asm path to string")?;

    for (file, gen_method, trace_target) in [
        (bin_mt_file, AsmGenerationMethod::AsmMinimalTraces, "MT"),
        (bin_rh_file, AsmGenerationMethod::AsmRomHistogram, "RH"),
        (bin_mo_file, AsmGenerationMethod::AsmMemOp, "MO"),
    ] {
        let asm_file = file.with_extension("asm");
        // Convert the ELF file to Zisk format and generates an assembly file
        let rv2zk = Riscv2zisk::new(elf);
        let asm_file_str = make_safe_path(&asm_file)?;
        rv2zk
            .runfile(asm_file_str.to_string(), gen_method, false, false, hints)
            .map_err(|e| anyhow::anyhow!("Error converting ELF to assembly: {}", e))?;

        // Build the emulator assembly
        let status = Command::new("make")
            .arg("clean")
            .current_dir(emulator_asm_path)
            .stdout(if verbose { Stdio::inherit() } else { Stdio::null() })
            .stderr(if verbose { Stdio::inherit() } else { Stdio::null() })
            .status()
            .context("Failed to execute 'make clean' command")?;

        if !status.success() {
            anyhow::bail!("'make clean' failed with exit code: {:?}", status.code());
        }

        let out_file_str = make_safe_path(&file)?;

        let status = Command::new("make")
            .arg(format!("EMU_PATH={}", asm_file_str))
            .arg(format!("OUT_PATH={}", out_file_str))
            .arg(format!("TRACE_TARGET={trace_target}"))
            .current_dir(emulator_asm_path)
            .stdout(if verbose { Stdio::inherit() } else { Stdio::null() })
            .stderr(if verbose { Stdio::inherit() } else { Stdio::null() })
            .status()
            .context("Failed to execute 'make' command")?;

        if !status.success() {
            anyhow::bail!("'make' failed with exit code: {:?}", status.code());
        }
    }

    Ok(())
}
