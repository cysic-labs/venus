use clap::Parser;
use pil2_stark_setup::setup_cmd::{self, SetupOptions};

// Use system allocator - jemalloc retains freed pages too aggressively
// for the bctree workload pattern (large short-lived allocations).

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

    // Configure rayon: limit threads to bound peak memory from concurrent
    // bctree NTT/Merkle operations. Each large AIR's bctree can use
    // ~10 GB temporarily; with 2 threads the worst case is ~30 GB
    // which fits comfortably under the 90 GB budget.
    // VENUS_THREADS env var overrides for tuning on different hardware.
    let num_threads = std::env::var("VENUS_THREADS")
        .ok()
        .and_then(|s| s.parse::<usize>().ok())
        .unwrap_or(2);
    rayon::ThreadPoolBuilder::new()
        .num_threads(num_threads)
        .stack_size(64 * 1024 * 1024) // 64 MB per thread
        .build_global()
        .ok();

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

    let result = setup_cmd::run_setup(&opts);

    // Log peak memory at exit for measurement validation
    if let Ok(status) = std::fs::read_to_string("/proc/self/status") {
        for line in status.lines() {
            if line.starts_with("VmHWM:") || line.starts_with("VmPeak:") {
                tracing::info!("{}", line.trim());
            }
        }
    }

    result
}
