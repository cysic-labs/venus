use clap::Parser;

#[derive(Parser)]
#[command(name = "pil2c", about = "PIL2 compiler (Rust replacement)")]
struct Cli {
    /// PIL source file
    source: String,

    /// Include paths (comma-separated)
    #[arg(short = 'I', long)]
    include: Option<String>,

    /// Output pilout file
    #[arg(short = 'o', long)]
    output: Option<String>,

    /// Output directory for fixed columns
    #[arg(short = 'u', long)]
    outputdir: Option<String>,

    /// Options (e.g., fixed-to-file)
    #[arg(short = 'O', long)]
    option: Option<Vec<String>>,

    /// PIL name
    #[arg(short = 'n', long)]
    name: Option<String>,

    /// Config file
    #[arg(short = 'P', long)]
    config: Option<String>,
}

fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();
    tracing_subscriber::fmt::init();
    tracing::info!("pil2c: compiling {}", cli.source);
    tracing::warn!("pil2c: not yet fully implemented");
    Ok(())
}
