use clap::Parser;

#[derive(Parser)]
#[command(name = "venus-setup", about = "Proving key setup (replaces pil2-proofman-js)")]
struct Cli {
    /// Path to compiled .pilout file
    #[arg(short = 'a', long)]
    airout: String,

    /// Build output directory
    #[arg(short = 'b', long)]
    build_dir: String,

    /// Standard PIL library path
    #[arg(short = 't', long)]
    std_path: Option<String>,

    /// Directory containing fixed column files
    #[arg(short = 'u', long)]
    fixed_dir: Option<String>,

    /// Enable recursive/aggregation setup
    #[arg(short = 'r', long)]
    recursive: bool,

    /// Path to starkstructs.json settings
    #[arg(short = 's', long)]
    stark_structs: Option<String>,
}

fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();
    tracing_subscriber::fmt::init();
    tracing::info!("venus-setup: starting");
    tracing::info!("  airout: {}", cli.airout);
    tracing::info!("  build_dir: {}", cli.build_dir);
    tracing::info!("  recursive: {}", cli.recursive);
    // Full implementation will be added in subsequent tasks
    tracing::warn!("venus-setup: not yet fully implemented");
    Ok(())
}
