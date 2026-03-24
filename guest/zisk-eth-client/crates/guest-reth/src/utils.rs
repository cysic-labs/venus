use std::sync::Arc;

use alloy_genesis::{ChainConfig, Genesis};
use reth_chainspec::ChainSpec;
use reth_ethereum_primitives::Block;

/// Get chain spec from chain config
pub fn get_chain_spec(chain_config: &ChainConfig) -> Arc<ChainSpec> {
    let genesis = Genesis {
        config: chain_config.clone(),
        ..Default::default()
    };

    Arc::new(ChainSpec::from_genesis(genesis))
}

/// Get chain name from chain ID
pub fn get_chain_name(chain_id: u64) -> &'static str {
    match chain_id {
        0x1 => "Mainnet",
        0xaa36a7 => "Sepolia",
        0x4268 => "Holesky",
        0x5 => "Goerli",
        _ => "Unknown",
        // Add more chain IDs as needed
    }
}

/// Extract common execution payload information across forks.
pub fn extract_block_info(block: &Block) -> (u64, u64, usize) {
    let block_number = block.header.number;
    let gas_used = block.header.gas_used;
    let tx_count = block.body.transactions.len();

    (block_number, gas_used, tx_count)
}
