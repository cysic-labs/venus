//! I/O utilities for Zisk zkVM programs.
//!
//! This module provides a high-level API for reading inputs and committing public outputs.

use crate::{read_input, set_output};
use serde::{de::DeserializeOwned, Serialize};
use std::sync::atomic::{AtomicU32, AtomicUsize, Ordering};

/// Read a deserializable object from the input stream.
///
/// ### Examples
/// ```ignore
/// use serde::{Deserialize, Serialize};
///
/// #[derive(Serialize, Deserialize)]
/// struct MyStruct {
///     a: u32,
///     b: u32,
/// }
///
/// let data: MyStruct = ziskos::io::read();
/// ```
///
/// Note: This uses zero-copy deserialization on zkvm to avoid unnecessary data copies.
pub fn read<T: DeserializeOwned>() -> T {
    let bytes = read_input_slice();
    bincode::deserialize(&bytes).expect("Deserialization failed")
}

/// Read raw bytes from the input stream.
///
/// ### Examples
/// ```ignore
/// let data: Vec<u8> = ziskos::io::read_vec();
/// ```
pub fn read_vec() -> Vec<u8> {
    read_input()
}

#[cfg(all(target_os = "zkvm", target_vendor = "zisk"))]
pub fn read_input_slice<'a>() -> &'a [u8] {
    crate::read_slice_zerocopy()
}

#[allow(unused)]
#[cfg(not(all(target_os = "zkvm", target_vendor = "zisk")))]
pub fn read_input_slice() -> Box<[u8]> {
    read_input().into_boxed_slice()
}

#[cfg(all(target_os = "zkvm", target_vendor = "zisk"))]
pub fn read_proof<'a>() -> &'a [u8] {
    crate::read_slice_zerocopy()
}

#[allow(unused)]
#[cfg(not(all(target_os = "zkvm", target_vendor = "zisk")))]
pub fn read_proof() -> Box<[u8]> {
    read_input().into_boxed_slice()
}

/// Commit a serializable value to public outputs.
/// The value is serialized with bincode and appended to the output byte stream.
pub fn commit<T: Serialize>(value: &T) {
    let bytes = bincode::serialize(value).expect("Serialization failed");
    write(&bytes);
}

/// Bytes of a public output slot.
const OUTPUT_SLOT_BYTES: usize = std::mem::size_of::<u32>();

/// Bytes written to the public outputs so far.
static OUTPUT_LEN: AtomicUsize = AtomicUsize::new(0);
/// The bytes of the last output slot while it is partially written.
static OUTPUT_PARTIAL_SLOT: AtomicU32 = AtomicU32::new(0);

/// Append raw bytes to public outputs.
/// The outputs hold one byte stream as 32-bit little-endian values: successive calls append to it,
/// a call ending inside a slot leaves the rest of the slot zero until the next call fills it.
pub fn write(buf: &[u8]) {
    let start = OUTPUT_LEN.load(Ordering::Relaxed);
    let end = start + buf.len();
    let mut slot = OUTPUT_PARTIAL_SLOT.load(Ordering::Relaxed).to_le_bytes();
    for (pos, &byte) in (start..end).zip(buf) {
        slot[pos % OUTPUT_SLOT_BYTES] = byte;
        let slot_full = (pos + 1) % OUTPUT_SLOT_BYTES == 0;
        if slot_full || pos + 1 == end {
            set_output(pos / OUTPUT_SLOT_BYTES, u32::from_le_bytes(slot));
        }
        if slot_full {
            slot = [0; OUTPUT_SLOT_BYTES];
        }
    }
    OUTPUT_LEN.store(end, Ordering::Relaxed);
    OUTPUT_PARTIAL_SLOT.store(u32::from_le_bytes(slot), Ordering::Relaxed);
}

pub const VADCOP_FINAL_VK_BYTES: usize = 32;
pub const ZISK_PROGRAM_VK_BYTES: usize = 32;
pub const ZISK_PUBLIC_OUTPUTS: usize = 64;

const GOLDILOCKS_FIELD_BYTES: usize = 8;
const ZISK_PROGRAM_VK_FIELDS: usize = ZISK_PROGRAM_VK_BYTES / GOLDILOCKS_FIELD_BYTES;
const ZISK_PUBLIC_FIELDS: usize = ZISK_PROGRAM_VK_FIELDS + ZISK_PUBLIC_OUTPUTS;
const WRAPPED_PROOF_HEADER_BYTES: usize = 8;
const PUBLIC_COUNT_BYTES: usize = 8;
const PUBLIC_VALUES_OFFSET: usize = WRAPPED_PROOF_HEADER_BYTES + PUBLIC_COUNT_BYTES;
const PUBLIC_VALUES_END: usize = PUBLIC_VALUES_OFFSET + ZISK_PUBLIC_FIELDS * GOLDILOCKS_FIELD_BYTES;

/// Program key and public outputs authenticated by a verified ZisK proof.
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct VerifiedZiskProof {
    program_vk: [u8; ZISK_PROGRAM_VK_BYTES],
    public_outputs: [u32; ZISK_PUBLIC_OUTPUTS],
}

impl VerifiedZiskProof {
    pub fn program_vk(&self) -> &[u8; ZISK_PROGRAM_VK_BYTES] {
        &self.program_vk
    }

    pub fn public_outputs(&self) -> &[u32; ZISK_PUBLIC_OUTPUTS] {
        &self.public_outputs
    }
}

/// Verify a wrapped ZisK proof against an application-trusted final verification key.
///
/// The wrapped proof is `[compressed][public count][program vk][outputs][proof][final vk]`, as
/// produced by the SDK `prepare_send_proof`. Its trailing final verification key is
/// producer-controlled and is accepted only when it matches `expected_vadcop_final_vk`. The
/// expected key must come from trusted application configuration or an authenticated outer public
/// statement, never from the wrapped proof itself.
/// Applications that require a specific inner program should use [`verify_zisk_proof_for_program`].
pub fn verify_zisk_proof(
    zisk_proof: &[u8],
    expected_vadcop_final_vk: &[u8; VADCOP_FINAL_VK_BYTES],
) -> bool {
    verify_zisk_proof_with_publics(zisk_proof, expected_vadcop_final_vk).is_some()
}

/// Verify a wrapped ZisK proof and return its authenticated program key and public outputs.
///
/// This function authenticates the returned program key but does not authorize a particular one.
/// Use [`verify_zisk_proof_for_program`] when program identity is part of the application policy.
pub fn verify_zisk_proof_with_publics(
    zisk_proof: &[u8],
    expected_vadcop_final_vk: &[u8; VADCOP_FINAL_VK_BYTES],
) -> Option<VerifiedZiskProof> {
    let proof = proof_for_trusted_vk(zisk_proof, expected_vadcop_final_vk)?;
    let claimed = parse_zisk_publics(proof)?;

    zisk_verifier::verify_vadcop_final_proof(proof, expected_vadcop_final_vk).then_some(claimed)
}

/// Verify a wrapped ZisK proof for an application-authorized program.
///
/// Both expected keys must come from trusted application configuration or an authenticated outer
/// public statement, never from the wrapped proof itself.
pub fn verify_zisk_proof_for_program(
    zisk_proof: &[u8],
    expected_vadcop_final_vk: &[u8; VADCOP_FINAL_VK_BYTES],
    expected_program_vk: &[u8; ZISK_PROGRAM_VK_BYTES],
) -> Option<VerifiedZiskProof> {
    let proof = proof_for_trusted_vk(zisk_proof, expected_vadcop_final_vk)?;
    let claimed = parse_zisk_publics(proof)?;
    if claimed.program_vk != *expected_program_vk {
        return None;
    }

    zisk_verifier::verify_vadcop_final_proof(proof, expected_vadcop_final_vk).then_some(claimed)
}

/// Split off the producer-supplied final verification key, keeping the proof only when that key
/// equals the trusted one.
fn proof_for_trusted_vk<'a>(
    zisk_proof: &'a [u8],
    expected_vadcop_final_vk: &[u8; VADCOP_FINAL_VK_BYTES],
) -> Option<&'a [u8]> {
    let proof_len = zisk_proof.len().checked_sub(VADCOP_FINAL_VK_BYTES)?;
    let (proof, embedded_vadcop_final_vk) = zisk_proof.split_at(proof_len);

    (embedded_vadcop_final_vk == expected_vadcop_final_vk).then_some(proof)
}

/// Parse the publics a proof claims: exactly the program key followed by 32-bit public outputs.
fn parse_zisk_publics(proof: &[u8]) -> Option<VerifiedZiskProof> {
    let public_count = proof.get(WRAPPED_PROOF_HEADER_BYTES..PUBLIC_VALUES_OFFSET)?;
    if u64::from_le_bytes(public_count.try_into().ok()?) != ZISK_PUBLIC_FIELDS as u64 {
        return None;
    }

    let public_values = proof.get(PUBLIC_VALUES_OFFSET..PUBLIC_VALUES_END)?;
    let (program_vk, output_values) = public_values.split_at(ZISK_PROGRAM_VK_BYTES);
    let mut public_outputs = [0u32; ZISK_PUBLIC_OUTPUTS];
    for (output, value) in
        public_outputs.iter_mut().zip(output_values.chunks_exact(GOLDILOCKS_FIELD_BYTES))
    {
        *output = u32::try_from(u64::from_le_bytes(value.try_into().ok()?)).ok()?;
    }

    Some(VerifiedZiskProof { program_vk: program_vk.try_into().ok()?, public_outputs })
}

#[cfg(test)]
mod tests {
    use super::*;

    const TRUSTED_VK: [u8; VADCOP_FINAL_VK_BYTES] = [0x11; VADCOP_FINAL_VK_BYTES];
    const PROGRAM_VK: [u8; ZISK_PROGRAM_VK_BYTES] = [0x22; ZISK_PROGRAM_VK_BYTES];

    // Proof bytes up to the public values, without a STARK proof body: every rejection checked here
    // must happen before the STARK verifier runs.
    fn proof_with_publics(public_count: usize, outputs: &[u64; ZISK_PUBLIC_OUTPUTS]) -> Vec<u8> {
        let mut proof = Vec::new();
        proof.extend_from_slice(&0u64.to_le_bytes());
        proof.extend_from_slice(&(public_count as u64).to_le_bytes());
        proof.extend_from_slice(&PROGRAM_VK);
        for output in outputs {
            proof.extend_from_slice(&output.to_le_bytes());
        }
        proof
    }

    fn wrapped(proof: &[u8], embedded_vk: &[u8; VADCOP_FINAL_VK_BYTES]) -> Vec<u8> {
        [proof, embedded_vk].concat()
    }

    #[test]
    fn admits_only_the_trusted_setup_and_authorized_program() {
        let proof = proof_with_publics(ZISK_PUBLIC_FIELDS, &[0; ZISK_PUBLIC_OUTPUTS]);
        let trusted = wrapped(&proof, &TRUSTED_VK);
        assert_eq!(proof_for_trusted_vk(&trusted, &TRUSTED_VK), Some(&proof[..]));

        // A proof made with a self-built setup carries that setup's key.
        let forged = wrapped(&proof, &[0x33; VADCOP_FINAL_VK_BYTES]);
        assert_eq!(proof_for_trusted_vk(&forged, &TRUSTED_VK), None);
        assert_eq!(verify_zisk_proof_with_publics(&forged, &TRUSTED_VK), None);
        assert_eq!(proof_for_trusted_vk(&TRUSTED_VK[1..], &TRUSTED_VK), None);

        let other_program_vk = [0x44; ZISK_PROGRAM_VK_BYTES];
        assert_eq!(verify_zisk_proof_for_program(&trusted, &TRUSTED_VK, &other_program_vk), None);
    }

    #[test]
    fn parses_exactly_the_zisk_publics() {
        let mut outputs = [0u64; ZISK_PUBLIC_OUTPUTS];
        outputs[ZISK_PUBLIC_OUTPUTS - 1] = u32::MAX as u64;
        let proof = proof_with_publics(ZISK_PUBLIC_FIELDS, &outputs);
        let parsed = parse_zisk_publics(&proof).unwrap();
        assert_eq!(parsed.program_vk(), &PROGRAM_VK);
        assert_eq!(parsed.public_outputs()[ZISK_PUBLIC_OUTPUTS - 1], u32::MAX);

        assert_eq!(parse_zisk_publics(&proof[..proof.len() - 1]), None);
        assert_eq!(parse_zisk_publics(&proof_with_publics(ZISK_PUBLIC_FIELDS - 1, &outputs)), None);

        outputs[0] = u32::MAX as u64 + 1;
        assert_eq!(parse_zisk_publics(&proof_with_publics(ZISK_PUBLIC_FIELDS, &outputs)), None);
    }
}
