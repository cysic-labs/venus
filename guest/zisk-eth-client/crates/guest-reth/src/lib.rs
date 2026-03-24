use anyhow::{anyhow, Context, Result};
use rayon::prelude::*;
use serde::{Deserialize, Serialize};
use serde_with::serde_as;

use alloy_genesis::ChainConfig;
use alloy_rpc_types_debug::ExecutionWitness;

use reth_ethereum_primitives::{Block, TransactionSigned};
use stateless_reth::{StatelessInput, UncompressedPublicKey};

mod crypto;
mod utils;
mod validation;

pub use crypto::*;
pub use utils::*;
pub use validation::*;

#[serde_as]
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RethInput {
    /// The stateless input for the stateless validation function.
    pub stateless_input: StatelessInput,
    /// The recovered signers for the transactions in the block.
    pub public_keys: Vec<UncompressedPublicKey>,
}

impl RethInput {
    pub fn new(stateless_input: &StatelessInput) -> anyhow::Result<Self> {
        let public_keys = public_keys_from_block(&stateless_input.block)
            .context("Failed to recover public keys from block transactions")?;

        Ok(Self {
            stateless_input: stateless_input.clone(),
            public_keys,
        })
    }

    /// Serialize to bytes
    pub fn serialize(&self) -> Result<Vec<u8>> {
        bincode::serialize(self).context("Failed to serialize RethInput")
    }

    /// Deserialize from bytes
    pub fn deserialize(bytes: &[u8]) -> Result<Self> {
        bincode::deserialize(bytes).context("Failed to deserialize RethInput")
    }
}

/// The witness part of the input
#[serde_as]
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RethInputWitness {
    /// `ExecutionWitness` for the stateless validation function
    pub witness: ExecutionWitness,
}

impl RethInputWitness {
    pub fn new(witness: ExecutionWitness) -> Self {
        Self { witness }
    }

    /// Get the execution witness
    pub fn witness(&self) -> &ExecutionWitness {
        &self.witness
    }

    /// Serialize to bytes
    pub fn serialize(&self) -> Result<Vec<u8>> {
        bincode::serialize(self).context("Failed to serialize witness")
    }

    /// Deserialize from bytes
    pub fn deserialize(bytes: &[u8]) -> Result<Self> {
        bincode::deserialize(bytes).context("Failed to deserialize witness")
    }
}

/// The public input part of the input
#[serde_as]
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RethInputPublic {
    /// The block being executed in the stateless validation function
    #[serde_as(
        as = "reth_primitives_traits::serde_bincode_compat::Block<reth_ethereum_primitives::TransactionSigned, alloy_consensus::Header>"
    )]
    pub block: Block,
    /// Chain configuration for the stateless validation function
    #[serde_as(as = "alloy_genesis::serde_bincode_compat::ChainConfig<'_>")]
    pub chain_config: ChainConfig,
    /// The recovered signers for the transactions in the block.
    pub public_keys: Vec<UncompressedPublicKey>,
}

impl RethInputPublic {
    pub fn new(block: Block, chain_config: ChainConfig) -> anyhow::Result<Self> {
        // Recover the public keys from the block's transactions
        let public_keys = public_keys_from_block(&block)?;

        Ok(Self {
            block,
            chain_config,
            public_keys,
        })
    }

    /// Get the block
    pub fn block(&self) -> &Block {
        &self.block
    }

    /// Get the chain config
    pub fn chain_config(&self) -> &ChainConfig {
        &self.chain_config
    }

    /// Get the public keys
    pub fn public_keys(&self) -> &Vec<UncompressedPublicKey> {
        &self.public_keys
    }

    /// Serialize to bytes
    pub fn serialize(&self) -> Result<Vec<u8>> {
        bincode::serialize(self).context("Failed to serialize public keys")
    }

    /// Deserialize from bytes
    pub fn deserialize(bytes: &[u8]) -> Result<Self> {
        bincode::deserialize(bytes).context("Failed to deserialize public keys")
    }
}

/// Recovers the public keys from a block
fn public_keys_from_block(block: &Block) -> Result<Vec<UncompressedPublicKey>> {
    recover_signers(&block.body.transactions)
}

// Recovers the public keys from a list of signed transactions
pub fn recover_signers(txs: &[TransactionSigned]) -> Result<Vec<UncompressedPublicKey>> {
    txs.par_iter()
        .enumerate()
        .map(|(i, tx)| {
            let keys = tx
                .signature()
                .recover_from_prehash(&tx.signature_hash())
                .with_context(|| format!("Failed to recover signature for tx #{i}"))?;

            let encoded_point: [u8; 65] = keys
                .to_encoded_point(false)
                .as_bytes()
                .try_into()
                .map_err(|e| anyhow!("Failed to encode public key for tx #{i}, error: {e}"))?;

            Ok(UncompressedPublicKey(encoded_point))
        })
        .collect()
}
