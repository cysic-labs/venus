// Merkle Proof Generation for AMD FPGA (Vitis HLS)
//
// Generates authentication paths for Merkle tree queries.
// Used by the FRI protocol to prove polynomial evaluations.
//
// Reference:
//   pil2-proofman/pil2-stark/src/starkpil/merkleTree/merkleTreeGL.cpp
//     genMerkleProof()
//   pil2-proofman/pil2-stark/src/starkpil/starks_gpu.cu
//     genMerkleProof_(), genMerkleProof()

#ifndef VENUS_MERKLE_PROOF_HPP
#define VENUS_MERKLE_PROOF_HPP

#include "../goldilocks/gl64_t.hpp"
#include "merkle_config.hpp"

// ---- Compute Merkle proof length ----
// Returns number of levels in the proof (excluding root).
// proof_length = ceil(log_arity(height))
static unsigned int mt_proof_length(unsigned int height, unsigned int arity) {
    #pragma HLS INLINE
    if (height <= 1) return 0;

    unsigned int levels = 0;
    unsigned int n = height;
    while (n > 1) {
        #pragma HLS LOOP_TRIPCOUNT min=1 max=MT_MAX_LEVELS
        n = (n + (arity - 1)) / arity;
        levels++;
    }
    return levels;
}

// ---- Compute Merkle proof size (in field elements) ----
// Each level contributes (arity-1) sibling hashes of MT_HASH_SIZE elements.
static unsigned int mt_proof_size(unsigned int height, unsigned int arity) {
    #pragma HLS INLINE
    return mt_proof_length(height, arity) * (arity - 1) * MT_HASH_SIZE;
}

// ---- Generate Merkle proof for a single leaf ----
// Walks up the tree collecting sibling hashes for the given leaf index.
//
// nodes[]: flat tree buffer (all levels concatenated)
// proof[]: output buffer, must hold mt_proof_size() elements
// idx:     leaf index to prove
// height:  total number of leaves
// arity:   tree arity (2, 3, or 4)
//
// Algorithm (matching CPU/GPU reference):
//   At each level:
//     currIdx = idx % arity   (position within sibling group)
//     si = idx - currIdx      (start of sibling group)
//     Copy (arity-1) sibling hashes to proof, skipping currIdx
//     idx = idx / arity       (move to parent level)
//     Advance offset to next level in tree buffer
static void mt_gen_proof(const ap_uint<64>* nodes,
                         ap_uint<64>* proof,
                         unsigned int idx,
                         unsigned int height,
                         unsigned int arity) {
    #pragma HLS INLINE off

    unsigned int offset = 0;
    unsigned int n = height;
    unsigned int proof_idx = 0;

    PROOF_LEVELS:
    while (n > 1) {
        #pragma HLS LOOP_TRIPCOUNT min=1 max=MT_MAX_LEVELS

        unsigned int currIdx = idx % arity;
        unsigned int nextIdx = idx / arity;
        unsigned int si = idx - currIdx;  // start of sibling group

        // Copy sibling hashes (skip the queried position)
        COPY_SIBLINGS:
        for (unsigned int i = 0; i < arity; i++) {
            #pragma HLS LOOP_TRIPCOUNT min=2 max=4
            if (i != currIdx) {
                COPY_HASH:
                for (unsigned int j = 0; j < MT_HASH_SIZE; j++) {
                    #pragma HLS PIPELINE II=1
                    proof[proof_idx + j] =
                        nodes[(offset + (si + i)) * MT_HASH_SIZE + j];
                }
                proof_idx += MT_HASH_SIZE;
            }
        }

        // Move to next level
        unsigned int nextN = (n + (arity - 1)) / arity;
        unsigned int extraZeros = (arity - (n % arity)) % arity;
        offset += (n + extraZeros);  // skip this level's allocated slots
        // Note: each level allocates (n + extraZeros) node positions,
        // but the "nextN" parent nodes start right after that.
        // The GPU/CPU reference uses: offset + nextN * arity
        // which equals n + extraZeros (since nextN * arity >= n + extraZeros
        // and the tree is packed with the extra zeros included).
        n = nextN;
        idx = nextIdx;
    }
}

// ---- Verify a Merkle proof against a known root ----
// Given a leaf hash, the proof (sibling hashes), the leaf index,
// and the tree parameters, reconstruct the root and compare.
// Returns true if the computed root matches the expected root.
static bool mt_verify_proof(const gl64_t leaf_hash[MT_HASH_SIZE],
                            const gl64_t* proof,
                            unsigned int idx,
                            unsigned int height,
                            unsigned int arity,
                            const gl64_t expected_root[MT_HASH_SIZE]) {
    #pragma HLS INLINE off

    gl64_t current[MT_HASH_SIZE];
    #pragma HLS ARRAY_PARTITION variable=current complete

    for (unsigned int i = 0; i < MT_HASH_SIZE; i++) {
        #pragma HLS UNROLL
        current[i] = leaf_hash[i];
    }

    unsigned int n = height;
    unsigned int proof_offset = 0;

    VERIFY_LEVELS:
    while (n > 1) {
        #pragma HLS LOOP_TRIPCOUNT min=1 max=MT_MAX_LEVELS

        unsigned int currIdx = idx % arity;
        idx = idx / arity;

        // Build the hash input: insert current hash at currIdx position,
        // fill other positions from proof siblings.
        // For arity=3: input has 12 elements (3 * 4)
        gl64_t input[P2_SPONGE_WIDTH];
        #pragma HLS ARRAY_PARTITION variable=input complete

        // Zero-initialize (for arity < 4)
        for (unsigned int i = 0; i < P2_SPONGE_WIDTH; i++) {
            #pragma HLS UNROLL
            input[i] = gl64_t::zero();
        }

        // Place sibling hashes and current hash
        unsigned int p = 0; // proof sibling counter
        for (unsigned int i = 0; i < arity; i++) {
            if (i == currIdx) {
                // Insert our current hash
                for (unsigned int j = 0; j < MT_HASH_SIZE; j++) {
                    input[i * MT_HASH_SIZE + j] = current[j];
                }
            } else {
                // Insert sibling from proof
                for (unsigned int j = 0; j < MT_HASH_SIZE; j++) {
                    input[i * MT_HASH_SIZE + j] = proof[proof_offset + p * MT_HASH_SIZE + j];
                }
                p++;
            }
        }
        proof_offset += (arity - 1) * MT_HASH_SIZE;

        // Hash to get parent
        gl64_t output[MT_HASH_SIZE];
        #pragma HLS ARRAY_PARTITION variable=output complete
        p2_hash(output, input);

        for (unsigned int i = 0; i < MT_HASH_SIZE; i++) {
            #pragma HLS UNROLL
            current[i] = output[i];
        }

        n = (n + (arity - 1)) / arity;
    }

    // Compare with expected root
    bool match = true;
    for (unsigned int i = 0; i < MT_HASH_SIZE; i++) {
        if (current[i].val != expected_root[i].val) {
            match = false;
        }
    }
    return match;
}

#endif // VENUS_MERKLE_PROOF_HPP
