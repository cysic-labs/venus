// This example program verifies inner proofs of authorized programs and commits their outputs.

// Mark the main function as the entry point for ZisK
#![no_main]
ziskos::entrypoint!(main);

#[path = "../../protocol.rs"]
mod protocol;

fn main() {
    // The authorization is an input: it is committed below so the outer verifier can compare it
    // with keys it trusts.
    let authorization: protocol::AggregationAuthorization = ziskos::io::read();

    let inner_publics = core::array::from_fn(|i| {
        let proof = ziskos::io::read_proof();
        let verified = ziskos::io::verify_zisk_proof_for_program(
            &proof,
            &authorization.final_setup_vks[i],
            &authorization.program_vks[i],
        )
        .unwrap_or_else(|| panic!("Proof {i} verification or authorization failed"));
        protocol::decode_inner_publics(verified.public_outputs())
            .unwrap_or_else(|| panic!("Proof {i} has unexpected trailing public outputs"))
    });

    ziskos::io::commit(&protocol::AggregationStatement { authorization, inner_publics });
}
