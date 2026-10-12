// Statement shared by the aggregation host and both guests. Each of them uses only part of it.
#![allow(dead_code)]

use serde::{Deserialize, Serialize};

pub const INNER_PROOF_COUNT: usize = 2;
pub const VK_BYTES: usize = 32;

/// Public outputs committed by the inner program.
#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
pub struct InnerPublics {
    pub n: u32,
    pub module: u32,
    pub value: u32,
}

/// Keys the aggregation guest requires each inner proof to verify against.
#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
pub struct AggregationAuthorization {
    pub final_setup_vks: [[u8; VK_BYTES]; INNER_PROOF_COUNT],
    pub program_vks: [[u8; VK_BYTES]; INNER_PROOF_COUNT],
}

/// Public outputs committed by the aggregation program.
#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
pub struct AggregationStatement {
    pub authorization: AggregationAuthorization,
    pub inner_publics: [InnerPublics; INNER_PROOF_COUNT],
}

/// Iterate the Fibonacci recurrence `n` times modulo `module`.
pub fn compute_inner_publics(n: u32) -> InnerPublics {
    let module = 233;
    let mut a = 0;
    let mut b = 1;
    for _ in 0..n {
        let mut c = a + b;
        c %= module;
        a = b;
        b = c;
    }

    InnerPublics { n, module, value: b }
}

/// Decode the inner program outputs, rejecting any nonzero output after `InnerPublics`.
pub fn decode_inner_publics(outputs: &[u32]) -> Option<InnerPublics> {
    match outputs {
        [n, module, value, rest @ ..] if rest.iter().all(|&output| output == 0) => {
            Some(InnerPublics { n: *n, module: *module, value: *value })
        }
        _ => None,
    }
}
