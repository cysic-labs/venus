use std::sync::Arc;

use rsp_host_executor::EthHostExecutor;
use rsp_primitives::genesis::Genesis;
use rsp_provider::create_provider;

use crate::types::{GuestProgram, InputGenerator, InputGeneratorResult, Network};

impl InputGenerator {
    pub async fn generate(&self, block_number: u64) -> anyhow::Result<InputGeneratorResult> {
        println!(
            "Generating input file for block {}, guest: zec-rsp",
            block_number
        );

        // Create the RPC provider
        let provider = create_provider(self.rpc_url.clone());

        let genesis = match self.network {
            Network::Mainnet => Genesis::Mainnet,
            Network::Sepolia => Genesis::Sepolia,
        };

        let executor = EthHostExecutor::eth(
            Arc::new(
                (&genesis)
                    .try_into()
                    .expect("Failed to convert genesis block into the required type"),
            ),
            None,
        );

        let input = executor
            .execute(block_number, &provider, genesis.clone(), None, false)
            .await
            .expect("Failed to execute client");

        let input_bytes = bincode::serialize(&input).expect("Failed to serialize input");

        Ok(InputGeneratorResult {
            guest: GuestProgram::Rsp,
            input: input_bytes,
            gas_used: input.current_block.gas_used,
            tx_count: input
                .current_block
                .body
                .transactions
                .len()
                .try_into()
                .unwrap(),
        })
    }
}
