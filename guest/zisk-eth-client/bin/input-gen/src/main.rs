use anyhow::{Context, Result};
use clap::{Parser, Subcommand};
use std::path::PathBuf;
use tracing_subscriber::EnvFilter;

mod client;
mod common;
mod processor;
mod source;

use client::{create_client, Client};
use source::{eest::EestSource, rpc::RpcSource, InputSource};

#[derive(Parser)]
#[command(name = "zisk-input-generator")]
#[command(about = "Generate ZisK inputs from a variety of sources")]
#[command(version)]
struct Cli {
    /// Execution client to generate inputs for
    #[arg(short, long, value_enum, default_value = "reth")]
    client: Client,

    /// Source of inputs
    #[command(subcommand)]
    source: SourceCommand,

    /// Output folder for the generated ZisK input files (default: <client>-inputs)
    #[arg(short, long)]
    output: Option<PathBuf>,
}

#[derive(Subcommand, Clone, Debug)]
enum SourceCommand {
    /// Generate from EEST fixtures
    Eest(#[command(flatten)] EestSource),
    /// Generate from RPC endpoint  
    Rpc(#[command(flatten)] RpcSource),
}

#[tokio::main]
async fn main() -> Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter(EnvFilter::from_default_env())
        .init();

    let cli = Cli::parse();

    // Create execution client
    let client = create_client(&cli.client);

    // Define output directory
    let output = cli
        .output
        .unwrap_or_else(|| PathBuf::from(format!("{}-inputs", client.name())));

    // Create output directory if it doesn't exist
    std::fs::create_dir_all(&output)
        .with_context(|| format!("Failed to create output folder: {}", output.display()))?;

    match cli.source {
        SourceCommand::Eest(eest_source) => {
            eest_source
                .generate_inputs(client.as_ref(), &output)
                .await?;
        }
        SourceCommand::Rpc(rpc_source) => {
            rpc_source.generate_inputs(client.as_ref(), &output).await?;
        }
    }

    Ok(())
}
