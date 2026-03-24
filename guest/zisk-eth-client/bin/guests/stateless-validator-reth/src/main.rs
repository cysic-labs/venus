#![no_main]
ziskos::entrypoint!(main);

use std::sync::Arc;

use alloy_consensus::crypto::install_default_provider;
use revm::install_crypto;

use guest_reth::{
    CustomEvmCrypto, RethInputPublic, RethInputWitness, extract_block_info, get_chain_name,
    get_chain_spec, validate_block_stateless, verify_signatures,
};

fn main() {
    #[cfg(zisk_hints)]
    {
        // Create ./hints directory if it doesn't exist
        let hints_dir = std::path::PathBuf::from("./hints");
        if !hints_dir.exists() {
            std::fs::create_dir_all(&hints_dir).expect("Failed to create hints directory");
        }

        // Initialize hints file
        let hints_file = std::path::PathBuf::from("./hints/block_hints.bin");
        if let Err(e) = ziskos::hints::init_hints_file(hints_file, None) {
            panic!("Failed to init hints, error: {}", e);
        }
    }

    // Install custom EVM crypto
    install_crypto(CustomEvmCrypto::default());
    install_default_provider(Arc::new(CustomEvmCrypto::default())).unwrap();

    // Read the public input
    let public: RethInputPublic = ziskos::io::read();

    // Get chain config
    let chain_config = public.chain_config().clone();

    // Extract useful information for logging
    let block = public.block().clone();
    let (block_number, gas_used, tx_count) = extract_block_info(&block);
    let chain_id = chain_config.chain_id;
    let chain = get_chain_name(chain_id);
    println!(
        "Executing block validation for {} Block #{} ({} txs)",
        chain, block_number, tx_count
    );

    // Verify signatures
    let chain_spec = get_chain_spec(&chain_config);
    let block = verify_signatures(block, chain_spec.clone(), public.public_keys)
        .expect("Signature verification failed");

    // Read the witness
    let witness: RethInputWitness = ziskos::io::read();

    // Validate the block
    let execution_witness = witness.witness().clone();
    let block_hash = validate_block_stateless(block, execution_witness, chain_spec)
        .expect("Block validation failed");

    // Commit to block hash as the output
    ziskos::io::commit(&block_hash);

    // Print block number and calculated hash
    println!("Block validation succeeded!");
    println!(
        "Execution summary:\n  - Chain: {} (ID: {})\n  - Block Number: {}\n  - Block Hash: {}\n  - Transaction Count: {}\n  - Gas Consumed: {}",
        chain, chain_id, block_number, block_hash, tx_count, gas_used
    );

    #[cfg(zisk_hints)]
    {
        // Close hints generation
        if let Err(e) = ziskos::hints::close_hints() {
            panic!("Failed to close hints, error: {}", e);
        }

        // Rename hint file
        let hints_file = std::path::PathBuf::from("./hints/block_hints.bin");
        let new_hints_file =
            std::path::PathBuf::from(format!("./hints/{}_hints.bin", block_number));
        std::fs::rename(&hints_file, &new_hints_file).unwrap();

        println!(
            "Hints generated successfully in file {}",
            &new_hints_file.display()
        );
    }
}
