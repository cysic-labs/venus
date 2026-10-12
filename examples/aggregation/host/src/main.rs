use anyhow::{bail, ensure, Context, Result};
use serde::Serialize;
use std::path::Path;
use zisk_sdk::{
    get_default_proving_key, include_elf, ElfBinary, ProofOpts, ProverClient, ZiskProof,
    ZiskPublics, ZiskStdin,
};

#[path = "../../protocol.rs"]
mod protocol;

pub const ELF: ElfBinary = include_elf!("guest");
pub const ELF2: ElfBinary = include_elf!("guest-agg");

fn key_array(bytes: &[u8], label: &str) -> Result<[u8; protocol::VK_BYTES]> {
    bytes
        .try_into()
        .with_context(|| format!("{label} must contain exactly {} bytes", protocol::VK_BYTES))
}

/// Load the final setup key for `proof` from the local proving key, never from the proof itself.
fn final_setup_vk(proof: &ZiskProof, proving_key: &Path) -> Result<[u8; protocol::VK_BYTES]> {
    let compressed = match proof {
        ZiskProof::VadcopFinal(_) => false,
        ZiskProof::VadcopFinalCompressed(_) => true,
        _ => bail!("aggregation accepts only VADCoP final proofs"),
    };
    let vk = proofman::get_vadcop_final_proof_vkey(proving_key, compressed)?;
    key_array(&vk, "final setup verification key")
}

fn ensure_publics(actual: &ZiskPublics, expected: &impl Serialize, label: &str) -> Result<()> {
    ensure!(
        actual.public_bytes() == ZiskPublics::write(expected)?.public_bytes(),
        "{label} public outputs do not match expectations"
    );
    Ok(())
}

fn main() -> Result<()> {
    println!("Starting ZisK Prover Client...\n");

    // Prove with the same proving key the trusted final setup keys are loaded from.
    let proving_key = get_default_proving_key();
    let client = ProverClient::builder().proving_key_path(proving_key.clone()).build()?;

    println!("Setting up inner program...");
    let (pk, vkey) = client.setup(&ELF)?;

    println!("Setting up aggregation program...");
    let (pk2, vkey2) = client.setup(&ELF2)?;

    let n1 = 1000u32;
    let stdin1 = ZiskStdin::new();
    stdin1.write(&n1);
    let expected_publics1 = protocol::compute_inner_publics(n1);

    // Execute the program using the `ProverClient.execute` method, without generating a proof.
    println!("Executing inner program...");
    let execution = client.execute(&pk, stdin1.clone())?;
    ensure_publics(execution.get_publics(), &expected_publics1, "execution")?;
    println!(
        "Program executed successfully: {} cycles in {:.2?}",
        execution.get_execution_steps(),
        execution.get_duration()
    );

    println!("Generating first inner proof...");
    let proof_opts = ProofOpts::default().minimal_memory();
    let result1 = client.prove(&pk, stdin1).with_proof_options(proof_opts).run()?;
    ensure_publics(result1.get_publics(), &expected_publics1, "first proof")?;

    let n2 = 2000u32;
    let stdin2 = ZiskStdin::new();
    stdin2.write(&n2);
    let expected_publics2 = protocol::compute_inner_publics(n2);

    println!("Generating second inner proof...");
    let proof_opts = ProofOpts::default().minimal_memory();
    let result2 = client.prove(&pk, stdin2).with_proof_options(proof_opts).run()?;
    ensure_publics(result2.get_publics(), &expected_publics2, "second proof")?;

    let proof1 = client.prepare_send_proof(result1.get_proof(), result1.get_publics(), &vkey)?;
    let proof2 = client.prepare_send_proof(result2.get_proof(), result2.get_publics(), &vkey)?;

    let program_vk = key_array(&vkey.vk, "program verification key")?;
    let authorization = protocol::AggregationAuthorization {
        final_setup_vks: [
            final_setup_vk(result1.get_proof(), &proving_key)?,
            final_setup_vk(result2.get_proof(), &proving_key)?,
        ],
        program_vks: [program_vk; protocol::INNER_PROOF_COUNT],
    };

    // Write the authorization and the proofs to be verified by the guest
    let stdin_aggregation = ZiskStdin::new();
    stdin_aggregation.write(&authorization);
    stdin_aggregation.write_proof(&proof1);
    stdin_aggregation.write_proof(&proof2);

    let proof_opts = ProofOpts::default().minimal_memory();
    let result_aggregation =
        client.prove(&pk2, stdin_aggregation).with_proof_options(proof_opts).run()?;

    client.verify(result_aggregation.get_proof(), result_aggregation.get_publics(), &vkey2)?;

    // The authorization was a guest input, so it is trusted only through its committed copy.
    let expected_statement = protocol::AggregationStatement {
        authorization,
        inner_publics: [expected_publics1, expected_publics2],
    };
    ensure_publics(result_aggregation.get_publics(), &expected_statement, "aggregation")?;

    Ok(())
}
