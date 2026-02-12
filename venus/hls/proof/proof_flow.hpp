// Proof Flow Integration for AMD FPGA (Vitis HLS)
//
// Chains the individual HLS kernels into a coherent proving flow:
//   transcript -> FRI fold -> Merkle tree -> transcript (per FRI step)
//
// This module provides integration helpers used by the proof orchestration
// kernel. The full proving flow mirrors genProof_gpu() from the GPU backend:
//
//   1. Stage commits:  NTT extend -> linearHash -> Merkle tree -> transcript
//   2. Q polynomial:   expression eval -> NTT -> Merkle -> transcript
//   3. Evaluations:    polynomial openings at challenge point
//   4. FRI protocol:   iterative fold -> Merkle -> transcript
//   5. FRI queries:    Merkle proofs at random query positions
//
// Reference:
//   pil2-proofman/pil2-stark/src/starkpil/gen_proof.cuh  genProof_gpu()
//   pil2-proofman/pil2-stark/src/starkpil/starks_gpu.cu  fold_inplace()

#ifndef VENUS_PROOF_FLOW_HPP
#define VENUS_PROOF_FLOW_HPP

#include "../transcript/transcript.hpp"
#include "../fri/fri_fold.hpp"
#include "../fri/fri_query.hpp"
#include "../merkle/merkle_tree.hpp"
#include "../goldilocks/gl64_constants.hpp"

// ---- Single FRI fold step with transcript integration ----
// Squeezes a challenge from the transcript, folds the polynomial,
// and returns the folded data.
//
// Parameters:
//   tr:           transcript state (modified: challenge squeezed)
//   friPol:       input polynomial (AXI-MM)
//   foldedPol:    output folded polynomial (AXI-MM)
//   omega_inv:    inverse of primitive root for small INTT
//   invShift:     coset shift inverse
//   invW:         domain omega inverse
//   prevBits:     log2 of input domain size
//   currentBits:  log2 of output domain size
//   challenge_out: (optional) returns the challenge used
template <int MAX_RATIO>
static void proof_fri_fold(
    transcript_state_t& tr,
    const ap_uint<64>* friPol,
    ap_uint<64>* foldedPol,
    gl64_t omega_inv,
    gl64_t invShift,
    gl64_t invW,
    unsigned int prevBits,
    unsigned int currentBits,
    ap_uint<64>* challenge_out
) {
    #pragma HLS INLINE off

    // 1. Squeeze FRI challenge from transcript
    ap_uint<64> ch_raw[3];
    tr_get_field(tr, ch_raw);

    gl64_3_t challenge(
        gl64_t(ch_raw[0]),
        gl64_t(ch_raw[1]),
        gl64_t(ch_raw[2])
    );

    // Export challenge if requested
    if (challenge_out) {
        challenge_out[0] = ch_raw[0];
        challenge_out[1] = ch_raw[1];
        challenge_out[2] = ch_raw[2];
    }

    // 2. Fold the polynomial
    fri_fold_step<MAX_RATIO>(
        friPol, foldedPol, challenge,
        omega_inv, invShift, invW,
        prevBits, currentBits
    );
}

// ---- Merkelize folded polynomial and absorb root ----
// After folding, the result is hashed into a Merkle tree and the root
// is absorbed back into the transcript for the next round.
//
// Parameters:
//   tr:         transcript state (modified: root absorbed)
//   polData:    folded polynomial data (column-major for tree leaves)
//   treeNodes:  Merkle tree output buffer (AXI-MM)
//   nCols:      columns per leaf (FRI_FIELD_EXTENSION = 3)
//   nRows:      number of leaves (= sizeFoldedPol)
static void proof_merkelize_and_absorb(
    transcript_state_t& tr,
    const ap_uint<64>* polData,
    ap_uint<64>* treeNodes,
    unsigned int nCols,
    unsigned int nRows
) {
    #pragma HLS INLINE off

    // Build Merkle tree
    mt_merkelize(polData, treeNodes, nCols, nRows);

    // Extract root
    ap_uint<64> root[MT_HASH_SIZE];
    mt_get_root(treeNodes, root, nRows, MT_DEFAULT_ARITY);

    // Absorb root into transcript
    tr_put(tr, root, MT_HASH_SIZE);
}

// ---- Generate FRI query proofs ----
// After all fold steps, generate random query indices from the transcript
// and extract Merkle proofs at each query position.
static void proof_fri_queries(
    transcript_state_t& tr,
    unsigned int* queries,
    unsigned int nQueries,
    unsigned int nBits
) {
    #pragma HLS INLINE off

    tr_get_permutations(tr, queries, nQueries, nBits);
}

#endif // VENUS_PROOF_FLOW_HPP
