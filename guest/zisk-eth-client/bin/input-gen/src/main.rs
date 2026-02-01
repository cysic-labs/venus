use anyhow::anyhow;
use clap::Parser;
use input::{InputGenerator, Network};
use std::{io::Write, path::PathBuf, str::FromStr};
use url::Url;

#[derive(Debug, Clone, Parser)]
pub struct InputGenArgs {
    #[clap(long, short)]
    pub block_number: u64,

    #[clap(long, short, value_enum, default_value_t = Network::Mainnet)]
    pub network: Network,

    #[clap(long, short)]
    pub rpc_url: String,

    #[clap(long, short)]
    pub input_dir: Option<PathBuf>,
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // Initialize the environment variables.
    dotenv::dotenv().ok();

    if std::env::var("RUST_LOG").is_err() {
        unsafe {
            std::env::set_var("RUST_LOG", "info");
        }
    }

    // Parse the command line arguments.
    let args = InputGenArgs::parse();
    let rpc_url = match Url::from_str(&args.rpc_url) {
        Ok(url) => url,
        Err(e) => return Err(anyhow!("Invalid RPC URL, error: {}", e)),
    };
    let input_generator = InputGenerator::new(rpc_url, args.network.clone());

    let start_time = std::time::Instant::now();
    let result = input_generator.generate(args.block_number).await?;

    // Create the input directory if it does not exist.
    let input_folder = args.input_dir.clone().unwrap_or("inputs".into());
    if !input_folder.exists() {
        std::fs::create_dir_all(&input_folder)?;
    }

    let mgas = result.gas_used / 1_000_000;

    let input_path = input_folder.join(format!(
        "{}_{}_{}_{}.bin",
        args.block_number, result.tx_count, mgas, result.guest
    ));

    let mut input_file = std::fs::File::create(&input_path)?;
    input_file.write_all(&result.input)?;

    println!(
        "Input file for block {} ({} txs, {} mgas) saved to {}, time: {} ms",
        args.block_number,
        result.tx_count,
        mgas,
        input_path.to_string_lossy(),
        start_time.elapsed().as_millis()
    );

    Ok(())
}
