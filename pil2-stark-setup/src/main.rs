use clap::Parser;
use pil2_stark_setup::setup_cmd::{self, SetupOptions};

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

    // Configure rayon with larger stack size for deep expression evaluation
    rayon::ThreadPoolBuilder::new()
        .stack_size(64 * 1024 * 1024) // 64 MB per thread
        .build_global()
        .ok(); // Ignore error if already initialized

    tracing::info!("venus-setup: starting");
    tracing::info!("  airout: {}", cli.airout);
    tracing::info!("  build_dir: {}", cli.build_dir);
    tracing::info!("  recursive: {}", cli.recursive);

    let opts = SetupOptions {
        airout_path: cli.airout,
        build_dir: cli.build_dir,
        fixed_dir: cli.fixed_dir,
        stark_structs_path: cli.stark_structs,
        recursive: cli.recursive,
        std_pil_path: cli.std_path,
    };

    setup_cmd::run_setup(&opts)
}
