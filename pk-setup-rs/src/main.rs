// proofman-starks-lib-c uses MPI symbols; keep the native link flags explicit.
extern crate mpi as _;

mod circom_assets;
mod circom_compile;
mod pil_info;
mod pilout_info;
mod recursive_circom;
mod recursive_generation;
mod recursive_setup;
mod rust_verifier;
mod setup_layout;
mod stark_struct;

use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use clap::Parser;
use pilout_crate::pilout_proxy::PilOutProxy;

const DEFAULT_AIROUT: &str = "pil/zisk.pilout";

#[derive(Debug, Parser)]
#[command(version, about = "Native Rust proving-key setup generator")]
struct Args {
    /// Repository root.
    #[arg(long, default_value = ".")]
    root: PathBuf,

    /// Build directory where provingKey is generated.
    #[arg(short = 'b', long, default_value = "build")]
    build_dir: PathBuf,

    /// Existing PILOUT file generated from the current PIL sources.
    #[arg(short = 'a', long, default_value = DEFAULT_AIROUT)]
    airout: PathBuf,

    /// Stark settings JSON, compatible with the legacy state-machines/starkstructs.json.
    #[arg(short = 's', long, default_value = "state-machines/starkstructs.json")]
    starkstructs: PathBuf,

    /// Fixed columns evaluated by the PIL compiler (`make compile-pil`).
    #[arg(short = 'u', long, default_value = "tmp/fixed")]
    fixed_dir: PathBuf,

    /// Proof scratch directory created by the legacy target.
    #[arg(long, default_value = "tmp")]
    proof_dir: PathBuf,

    /// Generate aggregation setup artifacts.
    #[arg(short = 'r', long, default_value_t = true)]
    recursive: bool,

    /// Skip aggregation setup artifacts. This keeps the default setup behavior unchanged.
    #[arg(long)]
    no_recursive: bool,

    /// Instead of the proving key, generate the SNARK wrapper's recursivef STARK into
    /// <build-dir>/provingKeySnark from the vadcop_final setup of the existing proving key.
    #[arg(long)]
    snark: bool,

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
    let proving_key_dir = build_dir.join("provingKey");

    if args.snark {
        return recursive_generation::write_recursivef_artifacts(
            &build_dir,
            &proving_key_dir,
            &build_dir.join("provingKeySnark"),
        );
    }

    prepare_directories(&build_dir, &fixed_dir, &proof_dir, &proving_key_dir)?;
    let pilout_path = resolve_airout(&pilout_path)?;

    let pilout = PilOutProxy::new(&pilout_path.display().to_string())
        .map_err(|err| anyhow::anyhow!("failed to load PILOUT {}: {err}", pilout_path.display()))?;

    let settings = stark_struct::StarkSettingsMap::from_file(&starkstructs_path)?;
    let global = pilout_info::build_global_artifacts(&pilout, &settings)?;
    pilout_info::write_global_artifacts(&proving_key_dir, &global)?;
    setup_layout::write_basic_air_layout(&proving_key_dir, &fixed_dir, &pilout, &settings)?;

    if args.recursive && !args.no_recursive {
        recursive_generation::write_recursive_artifacts(&build_dir, &proving_key_dir)?;
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

fn resolve_airout(requested: &Path) -> Result<PathBuf> {
    if requested.exists() {
        return Ok(requested.to_path_buf());
    }

    if requested.ends_with(Path::new(DEFAULT_AIROUT)) {
        anyhow::bail!(
            "PILOUT was not found at {}; run `make compile-pil` before generating the proving key",
            requested.display()
        );
    }

    anyhow::bail!("PILOUT was not found at {}", requested.display());
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
