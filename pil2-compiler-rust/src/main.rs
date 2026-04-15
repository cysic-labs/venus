
use clap::Parser;

#[global_allocator]
static GLOBAL: tikv_jemallocator::Jemalloc = tikv_jemallocator::Jemalloc;

#[derive(Parser)]
#[command(name = "pil2c", about = "PIL2 compiler (Rust implementation)")]
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

    /// Compile-time defines (NAME=VALUE)
    #[arg(short = 'D', long)]
    define: Option<Vec<String>>,

    /// Verbose output
    #[arg(short = 'v', long)]
    verbose: bool,
}

fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();
    tracing_subscriber::fmt::init();

    // Parse include paths.
    let include_paths: Vec<String> = cli
        .include
        .map(|s| s.split(',').map(|p| p.trim().to_string()).collect())
        .unwrap_or_default();

    // Parse options.
    let options_list: Vec<String> = cli.option.unwrap_or_default();
    let fixed_to_file = options_list.iter().any(|o| o == "fixed-to-file");

    // Parse defines.
    let mut defines = std::collections::BTreeMap::new();
    if let Some(defs) = cli.define {
        for d in defs {
            if let Some((name, val_str)) = d.split_once('=') {
                if let Ok(val) = val_str.parse::<i128>() {
                    defines.insert(name.to_string(), val);
                } else {
                    eprintln!("Warning: ignoring invalid define: {}", d);
                }
            } else {
                // Define without value defaults to 1.
                defines.insert(d, 1);
            }
        }
    }

    let compile_options = pil2_compiler_rust::CompileOptions {
        source: cli.source,
        include_paths,
        output: cli.output,
        output_dir: cli.outputdir,
        defines,
        name: cli.name,
        fixed_to_file,
        verbose: cli.verbose,
    };

    eprintln!("pil2c: compiling {}", compile_options.source);
    pil2_compiler_rust::compile(&compile_options)?;

    Ok(())
}
