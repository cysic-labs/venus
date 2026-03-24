use anyhow::{Context, Result};
use std::time::Instant;
use tracing::debug;

use alloy_genesis::ChainConfig;
use alloy_provider::{ext::DebugApi, Provider, ProviderBuilder};
use alloy_rpc_types_debug::ExecutionWitness;
use alloy_rpc_types_eth::Block as RpcBlock;

use reth_chainspec::{mainnet_chain_config, Chain, NamedChain, HOLESKY, HOODI, SEPOLIA};
use stateless_reth::StatelessInput;

use guest_reth::{RethInput, RethInputPublic, RethInputWitness};

#[async_trait::async_trait]
pub trait FromRpc: Sized {
    /// Fetch from RPC using URL
    async fn from_rpc(rpc_url: &str, block_number: u64) -> Result<Self> {
        let provider = connect_provider(rpc_url).await?;
        Self::from_provider(&provider, block_number).await
    }

    /// Fetch using an existing provider
    async fn from_provider<P: Provider + DebugApi + Sync>(
        provider: &P,
        block_number: u64,
    ) -> Result<Self>;
}

#[async_trait::async_trait]
impl FromRpc for RethInput {
    async fn from_provider<P: Provider + DebugApi + Sync>(
        provider: &P,
        block_number: u64,
    ) -> Result<Self> {
        let block = fetch_block(provider, block_number).await?;
        let witness = fetch_witness(provider, block_number).await?;
        let chain_config = fetch_chain_config(provider).await?;

        let stateless_input = StatelessInput {
            block: block.into(),
            witness,
            chain_config,
        };

        RethInput::new(&stateless_input)
    }
}

#[async_trait::async_trait]
impl FromRpc for RethInputWitness {
    /// Fetch witness data using an existing provider
    async fn from_provider<P: Provider + DebugApi + Sync>(
        provider: &P,
        block_number: u64,
    ) -> Result<Self> {
        let witness = fetch_witness(provider, block_number).await?;

        Ok(RethInputWitness::new(witness))
    }
}

#[async_trait::async_trait]
impl FromRpc for RethInputPublic {
    /// Fetch and recover public keys using an existing provider
    async fn from_provider<P: Provider + DebugApi + Sync>(
        provider: &P,
        block_number: u64,
    ) -> Result<Self> {
        let block = fetch_block(provider, block_number).await?;
        let chain_config = fetch_chain_config(provider).await?;

        RethInputPublic::new(block.into(), chain_config)
    }
}

async fn connect_provider(rpc_url: &str) -> Result<impl Provider + DebugApi> {
    let start_rpc_connect = Instant::now();
    let provider = ProviderBuilder::new()
        .connect(rpc_url)
        .await
        .context("Failed to connect to RPC provider")?;
    let time_rpc_connect = start_rpc_connect.elapsed();
    debug!("RPC connect time: {:?}", time_rpc_connect);
    Ok(provider)
}

async fn fetch_block<P: Provider>(provider: &P, block_number: u64) -> Result<RpcBlock> {
    let start_block_fetch = Instant::now();
    let block = provider
        .get_block(block_number.into())
        .full()
        .await?
        .with_context(|| format!("Block #{block_number} not found"))?;
    let time_block_fetch = start_block_fetch.elapsed();
    debug!(
        "Block fetch time for block {block_number}: {:?}",
        time_block_fetch
    );
    Ok(block)
}

async fn fetch_witness<P: Provider + DebugApi>(
    provider: &P,
    block_number: u64,
) -> Result<ExecutionWitness> {
    let start_witness_fetch = Instant::now();
    let witness = provider
        .debug_execution_witness(block_number.into())
        .await
        .context("Failed to fetch execution witness")?;
    let time_witness_fetch = start_witness_fetch.elapsed();
    debug!(
        "Witness fetch time for block {block_number}: {:?}",
        time_witness_fetch
    );
    Ok(witness)
}

async fn fetch_chain_config<P: Provider>(provider: &P) -> Result<ChainConfig> {
    let start_chain_config_fetch = Instant::now();
    let chain_id = provider.get_chain_id().await?;

    let chain = Chain::from_id(chain_id);
    let chain_config = match chain.named() {
        Some(NamedChain::Mainnet) => mainnet_chain_config(),
        Some(NamedChain::Sepolia) => SEPOLIA.genesis.config.clone(),
        Some(NamedChain::Hoodi) => HOODI.genesis.config.clone(),
        Some(NamedChain::Holesky) => HOLESKY.genesis.config.clone(),
        _ => anyhow::bail!("Unsupported chain ID: {}", chain_id),
    };

    let time_chain_config_fetch = start_chain_config_fetch.elapsed();
    debug!("Chain config fetch time: {:?}", time_chain_config_fetch);
    Ok(chain_config)
}
