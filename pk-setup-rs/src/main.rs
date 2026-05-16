mod circom_compile;
mod circom_assets;
mod pil_info;
mod pilout_info;
mod recursive_circom;
mod recursive_cache;
mod recursive_setup;
mod setup_layout;
mod stark_struct;

use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use clap::Parser;
use pilout_crate::pilout_proxy::PilOutProxy;
use sm_arith::ArithFrops;
use sm_binary::{BinaryBasicFrops, BinaryExtensionFrops};
use tracing::info;

#[derive(Debug, Parser)]
#[command(version, about = "Native Rust proving-key setup generator")]
struct Args {
    /// Repository root.
    #[arg(long, default_value = ".")]
    root: PathBuf,

    /// Build directory where provingKey is generated.
    #[arg(short = 'b', long, default_value = "build")]
    build_dir: PathBuf,

    /// Existing PILOUT file. Native PIL compilation will be added in this crate; for now this must exist.
    #[arg(short = 'a', long, default_value = "pil/zisk.pilout")]
    airout: PathBuf,

    /// Stark settings JSON, compatible with the legacy state-machines/starkstructs.json.
    #[arg(short = 's', long, default_value = "state-machines/starkstructs.json")]
    starkstructs: PathBuf,

    /// Fixed columns directory used by the legacy setup.
    #[arg(short = 'u', long, default_value = "tmp/fixed")]
    fixed_dir: PathBuf,

    /// Proof scratch directory created by the legacy target.
    #[arg(long, default_value = "tmp")]
    proof_dir: PathBuf,

    /// Generate aggregation setup artifacts.
    #[arg(short = 'r', long, default_value_t = true)]
    recursive: bool,

    /// Cache containing previously generated recursive aggregation artifacts.
    #[arg(long, default_value = "build-recursive-cache/provingKey")]
    recursive_cache_dir: PathBuf,

    /// Optional manifest of native recursive R1CS layout jobs.
    #[arg(long)]
    recursive_layout_manifest: Option<PathBuf>,

    /// Verbosity (-v, -vv).
    #[arg(short, long, action = clap::ArgAction::Count)]
    verbose: u8,
}

fn main() -> Result<()> {
    std::thread::Builder::new()
        .name("pk-setup-rs".to_string())
        .stack_size(128 * 1024 * 1024)
        .spawn(run)?
        .join()
        .map_err(|panic| {
            if let Some(message) = panic.downcast_ref::<&str>() {
                anyhow::anyhow!("pk-setup-rs worker panicked: {message}")
            } else if let Some(message) = panic.downcast_ref::<String>() {
                anyhow::anyhow!("pk-setup-rs worker panicked: {message}")
            } else {
                anyhow::anyhow!("pk-setup-rs worker panicked")
            }
        })?
}

fn run() -> Result<()> {
    let args = Args::parse();
    init_tracing(args.verbose);

    let root = fs::canonicalize(&args.root).context("failed to canonicalize repository root")?;
    let build_dir = resolve_path(&root, &args.build_dir);
    let fixed_dir = resolve_path(&root, &args.fixed_dir);
    let proof_dir = resolve_path(&root, &args.proof_dir);
    let pilout_path = resolve_path(&root, &args.airout);
    let starkstructs_path = resolve_path(&root, &args.starkstructs);
    let recursive_cache_dir = resolve_path(&root, &args.recursive_cache_dir);
    let recursive_layout_manifest =
        args.recursive_layout_manifest.as_ref().map(|path| resolve_path(&root, path));
    let proving_key_dir = build_dir.join("provingKey");

    prepare_directories(&build_dir, &fixed_dir, &proof_dir, &proving_key_dir)?;
    generate_frequent_op_fixed_tables(&root)?;

    if !pilout_path.exists() {
        anyhow::bail!(
            "native PIL compilation is not implemented yet and PILOUT was not found at {}",
            pilout_path.display()
        );
    }

    let pilout = PilOutProxy::new(&pilout_path.display().to_string())
        .map_err(|err| anyhow::anyhow!("failed to load PILOUT {}: {err}", pilout_path.display()))?;

    let settings = stark_struct::StarkSettingsMap::from_file(&starkstructs_path)?;
    let global = pilout_info::build_global_artifacts(&pilout, &settings)?;
    pilout_info::write_global_artifacts(&proving_key_dir, &global)?;
    setup_layout::write_basic_air_layout(&proving_key_dir, &fixed_dir, &pilout, &settings)?;

    if args.recursive {
        if let Some(manifest_path) = recursive_layout_manifest.as_ref() {
            let artifacts = recursive_setup::manifest::write_layouts_from_manifest(
                manifest_path,
                &proving_key_dir,
            )?;
            info!("wrote {} native recursive layout artifact sets", artifacts.len());
        } else {
            recursive_cache::overlay_recursive_artifacts(
                &recursive_cache_dir,
                &proving_key_dir,
                &pilout,
                &global.info.name,
            )?;
        }
    }

    Ok(())
}

fn init_tracing(verbose: u8) {
    let level = match verbose {
        0 => tracing::Level::INFO,
        1 => tracing::Level::DEBUG,
        _ => tracing::Level::TRACE,
    };
    let _ = tracing_subscriber::fmt().with_max_level(level).with_target(false).try_init();
}

fn resolve_path(root: &Path, path: &Path) -> PathBuf {
    if path.is_absolute() {
        path.to_path_buf()
    } else {
        root.join(path)
    }
}

fn prepare_directories(
    build_dir: &Path,
    fixed_dir: &Path,
    proof_dir: &Path,
    proving_key_dir: &Path,
) -> Result<()> {
    fs::create_dir_all(build_dir)
        .with_context(|| format!("failed to create {}", build_dir.display()))?;
    fs::create_dir_all(fixed_dir)
        .with_context(|| format!("failed to create {}", fixed_dir.display()))?;
    fs::create_dir_all(proof_dir)
        .with_context(|| format!("failed to create {}", proof_dir.display()))?;
    if proving_key_dir.exists() {
        fs::remove_dir_all(proving_key_dir)
            .with_context(|| format!("failed to remove {}", proving_key_dir.display()))?;
    }
    fs::create_dir_all(proving_key_dir)
        .with_context(|| format!("failed to create {}", proving_key_dir.display()))?;
    Ok(())
}

fn generate_frequent_op_fixed_tables(root: &Path) -> Result<()> {
    let current_dir = std::env::current_dir().context("failed to get current directory")?;
    std::env::set_current_dir(root)
        .with_context(|| format!("failed to enter {}", root.display()))?;

    let result = (|| -> Result<()> {
        info!("generating arithmetic frequent-op fixed table");
        ArithFrops::new()
            .generate_file("state-machines/arith/src/arith_frops_fixed.bin")
            .map_err(|err| anyhow::anyhow!("failed to generate arith_frops_fixed.bin: {err}"))?;

        info!("generating binary basic frequent-op fixed table");
        BinaryBasicFrops::new()
            .generate_file("state-machines/binary/src/binary_basic_frops_fixed.bin")
            .map_err(|err| {
                anyhow::anyhow!("failed to generate binary_basic_frops_fixed.bin: {err}")
            })?;

        info!("generating binary extension frequent-op fixed table");
        BinaryExtensionFrops::new()
            .generate_file("state-machines/binary/src/binary_extension_frops_fixed.bin")
            .map_err(|err| {
                anyhow::anyhow!("failed to generate binary_extension_frops_fixed.bin: {err}")
            })?;
        Ok(())
    })();

    std::env::set_current_dir(&current_dir)
        .with_context(|| format!("failed to restore {}", current_dir.display()))?;

    result
}
