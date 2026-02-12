// Merkle Tree Construction for AMD FPGA (Vitis HLS)
//
// Implements Merkle tree building using Poseidon2 hash over Goldilocks.
// Two phases:
//   1. Leaf hashing: linearHash each source row -> 4-element digest
//   2. Internal levels: hash groups of (arity) children -> parent
//
// Reference:
//   pil2-proofman/pil2-stark/src/goldilocks/src/poseidon2_goldilocks.cpp
//     merkletree_seq()
//   pil2-proofman/pil2-stark/src/goldilocks/src/poseidon2_goldilocks.cu
//     merkletreeCoalesced(), merkletreeCoalescedBlocks()
//   pil2-proofman/pil2-stark/src/starkpil/merkleTree/merkleTreeGL.cpp

#ifndef VENUS_MERKLE_TREE_HPP
#define VENUS_MERKLE_TREE_HPP

#include "../goldilocks/gl64_t.hpp"
#include "../poseidon2/poseidon2_core.hpp"
#include "../poseidon2/poseidon2_linear_hash.hpp"
#include "merkle_config.hpp"

// ---- Compute total number of node elements for a tree ----
// Returns total number of gl64_t elements (not nodes) in the tree buffer.
// Each node = MT_HASH_SIZE (4) elements.
// Matches MerkleTreeGL::getNumNodes() and MerklehashGoldilocks::getTreeNumElements().
static unsigned int mt_get_num_elements(unsigned int height, unsigned int arity) {
    #pragma HLS INLINE
    unsigned int numNodes = height;
    unsigned int nodesLevel = height;

    CALC_NODES:
    while (nodesLevel > 1) {
        #pragma HLS LOOP_TRIPCOUNT min=1 max=MT_MAX_LEVELS
        unsigned int extraZeros = (arity - (nodesLevel % arity)) % arity;
        numNodes += extraZeros;
        unsigned int nextN = (nodesLevel + (arity - 1)) / arity;
        numNodes += nextN;
        nodesLevel = nextN;
    }

    return numNodes * MT_HASH_SIZE;
}

// ---- Phase 1: Leaf hashing ----
// Hash each source row using linearHash (sponge-mode Poseidon2).
// source[num_rows * num_cols] -> tree[0 .. num_rows * 4 - 1]
//
// This is a thin wrapper around p2_linear_hash_rows from poseidon2_linear_hash.hpp.
static void mt_hash_leaves(const ap_uint<64>* source,
                           ap_uint<64>* tree,
                           unsigned int num_cols,
                           unsigned int num_rows) {
    #pragma HLS INLINE off
    p2_linear_hash_rows<MT_MAX_COLS>(source, tree, num_cols, num_rows);
}

// ---- Phase 2: Build internal tree levels (arity=3) ----
// Iteratively hash groups of arity children into parent nodes.
// tree[] is both input and output (in-place construction).
//
// Algorithm (matching CPU/GPU reference exactly):
//   pending = num_rows
//   nextIndex = 0
//   while pending > 1:
//     extraZeros = (arity - (pending % arity)) % arity
//     zero-fill extraZeros padding nodes
//     nextN = ceil(pending / arity)
//     for each group of arity children:
//       input[0..11] = concatenation of arity child hashes (4 elements each)
//       parent[0..3] = Poseidon2_hash(input[0..11])
//     nextIndex += (pending + extraZeros) * 4
//     pending = nextN
static void mt_build_tree_arity3(ap_uint<64>* tree,
                                 unsigned int num_rows) {
    #pragma HLS INLINE off

    unsigned int pending = num_rows;
    unsigned int nextIndex = 0;

    BUILD_LEVELS:
    while (pending > 1) {
        #pragma HLS LOOP_TRIPCOUNT min=1 max=MT_MAX_LEVELS

        unsigned int extraZeros = (3 - (pending % 3)) % 3;

        // Zero-fill padding nodes
        if (extraZeros > 0) {
            ZERO_PAD:
            for (unsigned int i = 0; i < extraZeros * MT_HASH_SIZE; i++) {
                #pragma HLS PIPELINE II=1
                #pragma HLS LOOP_TRIPCOUNT min=0 max=8
                tree[nextIndex + pending * MT_HASH_SIZE + i] = ap_uint<64>(0);
            }
        }

        unsigned int nextN = (pending + 2) / 3; // ceil(pending / 3)

        // Hash each group of 3 children
        HASH_GROUPS:
        for (unsigned int i = 0; i < nextN; i++) {
            #pragma HLS LOOP_TRIPCOUNT min=1 max=1048576

            // Read 3 children (12 elements = SPONGE_WIDTH for arity=3)
            gl64_t input[P2_SPONGE_WIDTH];
            #pragma HLS ARRAY_PARTITION variable=input complete

            READ_CHILDREN:
            for (unsigned int j = 0; j < P2_SPONGE_WIDTH; j++) {
                #pragma HLS PIPELINE II=1
                input[j] = gl64_t(tree[nextIndex + i * P2_SPONGE_WIDTH + j]);
            }

            // Compute parent hash
            gl64_t output[MT_HASH_SIZE];
            #pragma HLS ARRAY_PARTITION variable=output complete
            p2_hash(output, input);

            // Write parent node
            unsigned int parent_offset = nextIndex +
                                         (pending + extraZeros + i) * MT_HASH_SIZE;
            WRITE_PARENT:
            for (unsigned int j = 0; j < MT_HASH_SIZE; j++) {
                #pragma HLS PIPELINE II=1
                tree[parent_offset + j] = output[j].val;
            }
        }

        nextIndex += (pending + extraZeros) * MT_HASH_SIZE;
        pending = nextN;
    }
}

// ---- Full Merkle tree construction (arity=3) ----
// Combines leaf hashing and tree building.
static void mt_merkelize(const ap_uint<64>* source,
                         ap_uint<64>* tree,
                         unsigned int num_cols,
                         unsigned int num_rows) {
    #pragma HLS INLINE off

    // Phase 1: Hash all leaf rows
    mt_hash_leaves(source, tree, num_cols, num_rows);

    // Phase 2: Build internal levels
    mt_build_tree_arity3(tree, num_rows);
}

// ---- Get root hash ----
// The root is the last MT_HASH_SIZE elements in the tree buffer.
static void mt_get_root(const ap_uint<64>* tree,
                        ap_uint<64> root[MT_HASH_SIZE],
                        unsigned int num_rows,
                        unsigned int arity) {
    #pragma HLS INLINE
    unsigned int numElements = mt_get_num_elements(num_rows, arity);
    for (unsigned int i = 0; i < MT_HASH_SIZE; i++) {
        #pragma HLS PIPELINE II=1
        root[i] = tree[numElements - MT_HASH_SIZE + i];
    }
}

#endif // VENUS_MERKLE_TREE_HPP
