// TODO: Add old blocks via archive reth node
// TODO: Simplify when the `debug_execution_witness_by_block_hash` method gets available

use alloy_genesis::ChainConfig;
use alloy_rpc_types_eth::{Block, Header, Receipt, Transaction, TransactionRequest};
use anyhow::{Context, Result};
use clap::Args;
use jsonrpsee::http_client::{HeaderMap, HttpClient, HttpClientBuilder};
use std::path::Path;
use tokio_util::sync::CancellationToken;
use tracing::info;

use reth_chainspec::{mainnet_chain_config, Chain, NamedChain, HOLESKY, HOODI, SEPOLIA};
use reth_ethereum_primitives::TransactionSigned;
use reth_rpc_api::{DebugApiClient, EthApiClient};
use stateless_reth::{ExecutionWitness, StatelessInput};

use witness_generator::StatelessValidationFixture;

use super::{InputSource, SourceKind};
use crate::{client::ExecutionClient, processor::ProcessingTracker};

#[derive(Debug, Clone, Args)]
pub struct RpcSource {
    /// RPC URL to use
    #[arg(short = 'u', long)]
    rpc_url: String,

    /// Optional RPC headers (format: "Key:Value")
    #[arg(short = 'H', long)]
    rpc_headers: Option<Vec<String>>,

    /// Number of last blocks to fetch (default: 1 if no other block selection method is used)
    #[arg(short = 'l', long, group = "block_selection")]
    last_n_blocks: Option<usize>,

    /// Specific block number to fetch
    #[arg(short = 'b', long, group = "block_selection")]
    block: Option<u64>,

    /// Fetch blocks in a range (inclusive)
    #[arg(short = 'r', long, num_args = 2, value_names = ["START", "END"], group = "block_selection")]
    range_of_blocks: Option<Vec<u64>>,

    /// Listen for new blocks
    #[arg(short = 'f', long, default_value_t = false, group = "block_selection")]
    follow: bool,
}

#[async_trait::async_trait]
impl InputSource for RpcSource {
    fn kind(&self) -> SourceKind {
        SourceKind::Rpc
    }

    async fn generate_inputs(
        &self,
        client: &dyn ExecutionClient,
        output: &Path,
    ) -> anyhow::Result<()> {
        if !client.supports_source(self.kind()) {
            anyhow::bail!("{} doesn't support RPC source", client.display_name());
        }

        // Initialize the RPC client
        let (rpc_client, chain_config, chain_name) =
            Self::init_rpc_client(&self.rpc_url, self.rpc_headers.clone()).await?;

        info!(
            "Connected to chain: {} (ID: {})",
            chain_name, chain_config.chain_id
        );

        let client_name = client.display_name();
        info!("Generating inputs for the {} client...", client_name);

        // The RPC generator has two modes:
        //  1. Follow mode: Continuously listen for new blocks and generate inputs as they arrive.
        //  2. Batch mode: Process a specific block, a range of blocks, or the last N blocks, then exit.

        // If follow is enabled, continuously listen for new blocks.
        if self.follow {
            return self
                .follow_new_blocks(&rpc_client, &chain_config, chain_name, output, client)
                .await;
        }

        // Otherwise, process specified blocks.
        self.process_batch(&rpc_client, &chain_config, chain_name, output, client)
            .await
    }
}

impl RpcSource {
    /// Process a batch of blocks
    async fn process_batch(
        &self,
        rpc_client: &HttpClient,
        chain_config: &ChainConfig,
        chain_name: &str,
        output: &Path,
        client: &dyn ExecutionClient,
    ) -> Result<()> {
        let block_numbers: Vec<u64> = if let Some(block_num) = self.block {
            // Single block
            vec![block_num]
        } else if let Some(range) = &self.range_of_blocks {
            // Range of blocks
            if range.len() != 2 {
                anyhow::bail!("Range requires exactly 2 values: START and END");
            }
            let (start, end) = (range[0], range[1]);
            if start > end {
                anyhow::bail!("Range START ({}) must be <= END ({})", start, end);
            }
            (start..=end).collect()
        } else {
            // Default to last N blocks (default N=1)
            let n = self.last_n_blocks.unwrap_or(1);

            // Last N blocks
            if n == 0 {
                info!("No blocks to process (last_n_blocks = 0)");
                return Ok(());
            }
            let latest = Self::fetch_latest_block_number(rpc_client).await?;
            let start = latest.saturating_sub(n as u64 - 1);
            (start..=latest).collect()
        };

        info!(
            "Processing {} block(s): {:?}",
            block_numbers.len(),
            block_numbers
        );

        // Intitialize the tracker
        let mut tracker = ProcessingTracker::new(client.display_name());

        for block_num in block_numbers {
            let name = format!("Block #{}", block_num);
            match Self::process_block(
                rpc_client,
                block_num,
                chain_config,
                chain_name,
                output,
                client,
            )
            .await
            {
                Ok(_) => tracker.record_success(&name),
                Err(e) => tracker.record_error(&name, &e),
            }
        }

        tracker.log_summary();
        Ok(())
    }

    /// Process a single block
    async fn process_block(
        rpc_client: &HttpClient,
        block_num: u64,
        chain_config: &ChainConfig,
        chain_name: &str,
        output: &Path,
        client: &dyn ExecutionClient,
    ) -> Result<()> {
        // Fetch block and witness
        let (block, witness) = Self::fetch_block_and_witness(rpc_client, block_num).await?;

        // Generate fixture for the block
        let fixture = Self::generate_fixture(
            block_num,
            block,
            witness,
            chain_config,
            chain_name,
            client.name(),
        )?;

        // Generate input for the client and save to file
        client.process_fixture(&fixture, output)
    }

    fn generate_fixture(
        block_num: u64,
        block: Block<TransactionSigned>,
        witness: ExecutionWitness,
        chain_config: &ChainConfig,
        chain_name: &str,
        client_name: &str,
    ) -> Result<StatelessValidationFixture> {
        // Get transaction count and gas used from the block
        let tx_count = block.transactions.len();
        let gas_used = block.header.gas_used;
        let mgas = gas_used / 1_000_000;

        // Create the fixture
        let fixture_name = format!(
            "{}_{}_{}_{}_zec_{}",
            chain_name.to_lowercase(),
            block_num,
            tx_count,
            mgas,
            client_name
        );

        Ok(StatelessValidationFixture {
            name: fixture_name,
            stateless_input: StatelessInput {
                block: block.into_consensus(),
                witness,
                chain_config: chain_config.clone(),
            },
            success: true,
        })
    }
}

impl RpcSource {
    /// Continuously follow and process new blocks
    pub async fn follow_new_blocks(
        &self,
        rpc_client: &HttpClient,
        chain_config: &ChainConfig,
        chain_name: &str,
        output: &Path,
        client: &dyn ExecutionClient,
    ) -> Result<()> {
        info!("Following new blocks (press Ctrl+C to stop)...");

        let stop = CancellationToken::new();
        let stop_clone = stop.clone();

        // Spawn a task to handle Ctrl+C
        tokio::spawn(async move {
            tokio::signal::ctrl_c()
                .await
                .expect("Failed to listen for Ctrl+C");
            info!("Received Ctrl+C, stopping...");
            stop_clone.cancel();
        });

        // Initialize the tracker
        let client_name = client.display_name();
        let mut tracker = ProcessingTracker::new(client_name);

        let mut next_block_num = Self::fetch_latest_block_number(rpc_client).await?;
        loop {
            if stop.is_cancelled() {
                break;
            }

            // Check for new blocks
            let latest = Self::fetch_latest_block_number(rpc_client).await?;

            for block_num in next_block_num..=latest {
                let name = format!("Block #{}", block_num);
                match Self::process_block(
                    rpc_client,
                    block_num,
                    chain_config,
                    chain_name,
                    output,
                    client,
                )
                .await
                {
                    Ok(_) => tracker.record_success(&name),
                    Err(e) => tracker.record_error(&name, &e),
                }
            }

            next_block_num = latest + 1;

            // Wait before polling again (average block time is ~12s)
            tokio::select! {
                _ = stop.cancelled() => {
                    break;
                }
                _ = tokio::time::sleep(std::time::Duration::from_secs(6)) => {}
            }
        }

        tracker.log_summary();

        Ok(())
    }
}

impl RpcSource {
    /// Initialize the RPC client and fetch chain configuration
    async fn init_rpc_client(
        rpc_url: &str,
        rpc_headers: Option<Vec<String>>,
    ) -> Result<(HttpClient, ChainConfig, &'static str)> {
        // Build headers if provided
        let mut header_map = HeaderMap::new();
        if let Some(headers) = rpc_headers {
            for header in headers {
                let (key, value) = header
                    .split_once(':')
                    .with_context(|| format!("Invalid header format: {}", header))?;
                header_map.insert(
                    key.trim().parse::<http::HeaderName>()?,
                    value.trim().parse::<http::HeaderValue>()?,
                );
            }
        }

        // Build HTTP client
        let client = HttpClientBuilder::default()
            .set_headers(header_map)
            .max_response_size(1 << 30)
            .build(rpc_url)
            .context("Failed to build HTTP client")?;

        // Fetch chain ID and determine chain config
        let chain_id = EthApiClient::<(), (), (), (), (), ()>::chain_id(&client)
            .await
            .context("Failed to fetch chain ID")?
            .context("Chain ID not found")?;

        let chain = Chain::from_id(chain_id.to());

        let (chain_config, chain_name) = match chain.named() {
            Some(NamedChain::Mainnet) => (mainnet_chain_config(), "Mainnet"),
            Some(NamedChain::Sepolia) => (SEPOLIA.genesis.config.clone(), "Sepolia"),
            Some(NamedChain::Hoodi) => (HOODI.genesis.config.clone(), "Hoodi"),
            Some(NamedChain::Holesky) => (HOLESKY.genesis.config.clone(), "Holesky"),
            _ => anyhow::bail!("Unsupported chain ID: {}", chain_id),
        };

        Ok((client, chain_config, chain_name))
    }

    async fn fetch_latest_block_number(client: &HttpClient) -> Result<u64> {
        let block_number = EthApiClient::<
            TransactionRequest,
            Transaction,
            Block,
            Receipt,
            Header,
            TransactionSigned,
        >::block_number(client)
        .await
        .context("Failed to fetch latest block number")?;

        Ok(block_number.to::<u64>())
    }

    async fn fetch_block_and_witness(
        rpc_client: &HttpClient,
        block_num: u64,
    ) -> Result<(Block<TransactionSigned>, ExecutionWitness)> {
        let block = EthApiClient::<
            TransactionRequest,
            Transaction,
            Block<TransactionSigned>,
            Receipt,
            Header,
            TransactionSigned,
        >::block_by_number(rpc_client, block_num.into(), true)
        .await
        .context("Failed to fetch block")?
        .with_context(|| format!("Block {} not found", block_num))?;

        let witness = DebugApiClient::<()>::debug_execution_witness(rpc_client, block_num.into())
            .await
            .context("Failed to fetch execution witness")?;

        Ok((block, witness))
    }
}
