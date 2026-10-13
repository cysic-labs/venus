use proofman_verifier::{verify_vadcop_final_bytes, verify_vadcop_final_compressed_bytes};

pub fn verify_vadcop_final_proof(zisk_proof: &[u8], vadcop_final_vk: &[u8]) -> bool {
    // Format: [compressed(8)][pubs_len(8)][pubs][proof_bytes]
    let Some((compressed, vadcop_proof)) = zisk_proof.split_first_chunk::<8>() else {
        return false;
    };

    // The compressed flag is a little-endian u64 that must be exactly 0 or 1, so that a proof has a
    // single encoding.
    match u64::from_le_bytes(*compressed) {
        0 => verify_vadcop_final_bytes(vadcop_proof, vadcop_final_vk),
        1 => verify_vadcop_final_compressed_bytes(vadcop_proof, vadcop_final_vk),
        _ => false,
    }
}
