use std::sync::Arc;

use alloy_primitives::B256;
use alloy_rpc_types_debug::ExecutionWitness;

use reth_chainspec::ChainSpec;
use reth_ethereum_primitives::Block;
use reth_evm_ethereum::EthEvmConfig;
use reth_primitives_traits::RecoveredBlock;
use stateless_reth::{
    recover_block_with_public_keys, stateless_validation_recovered_with_trie,
    validation::StatelessValidationError, UncompressedPublicKey,
};
use zeth_mpt_state::SparseState;

/// Verifies transaction signatures against provided public keys.
pub fn verify_signatures(
    block: Block,
    chain_spec: Arc<ChainSpec>,
    public_keys: Vec<UncompressedPublicKey>,
) -> Result<RecoveredBlock<Block>, StatelessValidationError> {
    // Recover block with public keys while validating signatures
    let recovered_block = recover_block_with_public_keys(block, public_keys, &*chain_spec)?;

    Ok(recovered_block)
}

/// Performs stateless validation of a block using pre-verified signatures.
pub fn validate_block_stateless(
    recovered_block: RecoveredBlock<Block>,
    witness: ExecutionWitness,
    chain_spec: Arc<ChainSpec>,
) -> Result<B256, StatelessValidationError> {
    // Create EVM config from chain spec
    let evm_config = EthEvmConfig::new(chain_spec.clone());

    // Perform stateless validation
    let (hash, _) = stateless_validation_recovered_with_trie::<SparseState, _, _>(
        recovered_block,
        witness,
        chain_spec,
        evm_config,
    )?;

    Ok(hash)
}
