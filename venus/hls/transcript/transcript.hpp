// Fiat-Shamir Transcript for AMD FPGA (Vitis HLS)
//
// Poseidon2-based sponge construction for deriving verifier challenges
// from prover commitments. Implements the TranscriptGL class matching
// the CPU/GPU reference implementations.
//
// Sponge parameters (arity=3):
//   SPONGE_WIDTH = 12, RATE = 8, CAPACITY = 4
//
// Reference:
//   pil2-proofman/pil2-stark/src/starkpil/transcript/transcriptGL.hpp/.cpp
//   pil2-proofman/pil2-stark/src/starkpil/transcript/transcriptGL.cu/.cuh
//   pil2-proofman/fields/src/transcript.rs

#ifndef VENUS_TRANSCRIPT_HPP
#define VENUS_TRANSCRIPT_HPP

#include "../goldilocks/gl64_t.hpp"
#include "../poseidon2/poseidon2_core.hpp"
#include "../poseidon2/poseidon2_config.hpp"

// ---- Transcript sponge parameters (arity=3) ----
// These match P2_SPONGE_WIDTH=12, P2_CAPACITY=4 from poseidon2_config.hpp
#define TR_SPONGE_WIDTH  P2_SPONGE_WIDTH  // 12
#define TR_CAPACITY      P2_CAPACITY       // 4
#define TR_RATE          (TR_SPONGE_WIDTH - TR_CAPACITY)  // 8

// Hash output size (= CAPACITY)
#define TR_HASH_SIZE     TR_CAPACITY  // 4

// Maximum number of FRI queries for getPermutations
#define TR_MAX_QUERIES   128

// Maximum number of field elements for getPermutations
// ceil(TR_MAX_QUERIES * 27 / 63) + 1 = 55
#define TR_MAX_PERM_FIELDS 64

// ---- Transcript state ----
// Self-contained sponge state, stored on-chip.
struct transcript_state_t {
    gl64_t state[TR_SPONGE_WIDTH];    // Full sponge state
    gl64_t pending[TR_RATE];          // Input accumulation buffer
    gl64_t out[TR_SPONGE_WIDTH];      // Hash output buffer
    unsigned int pending_cursor;       // Elements in pending buffer
    unsigned int out_cursor;           // Elements remaining in output
};

// ---- Reset transcript to initial state ----
static void tr_reset(transcript_state_t& tr) {
    #pragma HLS INLINE
    for (unsigned int i = 0; i < TR_SPONGE_WIDTH; i++) {
        #pragma HLS UNROLL
        tr.state[i] = gl64_t::zero();
        tr.out[i] = gl64_t::zero();
    }
    for (unsigned int i = 0; i < TR_RATE; i++) {
        #pragma HLS UNROLL
        tr.pending[i] = gl64_t::zero();
    }
    tr.pending_cursor = 0;
    tr.out_cursor = 0;
}

// ---- Update sponge state (internal) ----
// Pads pending, builds hash input = pending || state[0:CAPACITY-1],
// hashes, and updates state/out.
//
// Reference: TranscriptGL::_updateState()
static void tr_update_state(transcript_state_t& tr) {
    #pragma HLS INLINE off

    // Zero-pad pending from cursor to RATE
    PAD_PENDING:
    for (unsigned int i = 0; i < TR_RATE; i++) {
        #pragma HLS UNROLL
        if (i >= tr.pending_cursor) {
            tr.pending[i] = gl64_t::zero();
        }
    }

    // Build hash input: pending[0:RATE-1] || state[0:CAPACITY-1]
    gl64_t inputs[TR_SPONGE_WIDTH];
    #pragma HLS ARRAY_PARTITION variable=inputs complete

    COPY_PENDING:
    for (unsigned int i = 0; i < TR_RATE; i++) {
        #pragma HLS UNROLL
        inputs[i] = tr.pending[i];
    }
    COPY_STATE:
    for (unsigned int i = 0; i < TR_CAPACITY; i++) {
        #pragma HLS UNROLL
        inputs[TR_RATE + i] = tr.state[i];
    }

    // Poseidon2 full hash (returns all 12 elements)
    p2_hash_full_result(inputs);

    // Copy output to state and out
    UPDATE:
    for (unsigned int i = 0; i < TR_SPONGE_WIDTH; i++) {
        #pragma HLS UNROLL
        tr.out[i] = inputs[i];
        tr.state[i] = inputs[i];
    }

    // Reset cursors
    tr.out_cursor = TR_SPONGE_WIDTH;
    tr.pending_cursor = 0;

    // Clear pending
    CLEAR_PENDING:
    for (unsigned int i = 0; i < TR_RATE; i++) {
        #pragma HLS UNROLL
        tr.pending[i] = gl64_t::zero();
    }
}

// ---- Add one element to transcript (internal) ----
// Reference: TranscriptGL::_add1()
static void tr_add1(transcript_state_t& tr, gl64_t input) {
    #pragma HLS INLINE off

    tr.pending[tr.pending_cursor] = input;
    tr.pending_cursor++;
    tr.out_cursor = 0;  // Invalidate output when new input arrives

    if (tr.pending_cursor == TR_RATE) {
        tr_update_state(tr);
    }
}

// ---- Absorb multiple elements into transcript ----
// Reference: TranscriptGL::put()
static void tr_put(transcript_state_t& tr,
                    const ap_uint<64>* input,
                    unsigned int size) {
    #pragma HLS INLINE off

    PUT_LOOP:
    for (unsigned int i = 0; i < size; i++) {
        #pragma HLS LOOP_TRIPCOUNT min=1 max=64
        tr_add1(tr, gl64_t(input[i]));
    }
}

// ---- Squeeze one field element from transcript (internal) ----
// Reference: TranscriptGL::getFields1()
static gl64_t tr_get_field1(transcript_state_t& tr) {
    #pragma HLS INLINE off

    if (tr.out_cursor == 0) {
        tr_update_state(tr);
    }

    gl64_t res = tr.out[(TR_SPONGE_WIDTH - tr.out_cursor) % TR_SPONGE_WIDTH];
    tr.out_cursor--;
    return res;
}

// ---- Squeeze cubic extension challenge (3 field elements) ----
// Reference: TranscriptGL::getField()
static void tr_get_field(transcript_state_t& tr,
                          ap_uint<64> output[3]) {
    #pragma HLS INLINE off

    GET_3:
    for (unsigned int i = 0; i < 3; i++) {
        #pragma HLS PIPELINE off
        gl64_t val = tr_get_field1(tr);
        output[i] = val.val;
    }
}

// ---- Get transcript state (capacity portion) ----
// Flushes pending if needed, then returns state[0:CAPACITY-1].
// Reference: TranscriptGL::getState()
static void tr_get_state(transcript_state_t& tr,
                          ap_uint<64> output[TR_HASH_SIZE]) {
    #pragma HLS INLINE off

    if (tr.pending_cursor > 0) {
        tr_update_state(tr);
    }

    GET_STATE:
    for (unsigned int i = 0; i < TR_HASH_SIZE; i++) {
        #pragma HLS PIPELINE II=1
        output[i] = tr.state[i].val;
    }
}

// ---- Generate FRI query permutations ----
// Squeezes field elements from the transcript and extracts nBits
// per query index. Each 64-bit field element provides 63 usable bits
// (since values are in [0, p-1] and p < 2^64).
//
// Reference: TranscriptGL::getPermutations()
static void tr_get_permutations(transcript_state_t& tr,
                                 unsigned int* queries,
                                 unsigned int nQueries,
                                 unsigned int nBits) {
    #pragma HLS INLINE off

    // Compute number of field elements needed
    unsigned int totalBits = nQueries * nBits;
    // NFields = floor((totalBits - 1) / 63) + 1
    unsigned int nFields = (totalBits > 0) ? ((totalBits - 1) / 63 + 1) : 0;

    // Squeeze field elements
    uint64_t fields[TR_MAX_PERM_FIELDS];
    SQUEEZE_FIELDS:
    for (unsigned int i = 0; i < TR_MAX_PERM_FIELDS; i++) {
        #pragma HLS PIPELINE off
        #pragma HLS LOOP_TRIPCOUNT min=1 max=TR_MAX_PERM_FIELDS
        if (i >= nFields) break;
        gl64_t val = tr_get_field1(tr);
        fields[i] = (uint64_t)val.val;
    }

    // Extract bits to form query indices
    unsigned int curField = 0;
    unsigned int curBit = 0;

    EXTRACT_QUERIES:
    for (unsigned int i = 0; i < TR_MAX_QUERIES; i++) {
        #pragma HLS LOOP_TRIPCOUNT min=1 max=TR_MAX_QUERIES
        if (i >= nQueries) break;

        unsigned int a = 0;
        EXTRACT_BITS:
        for (unsigned int j = 0; j < 27; j++) {
            #pragma HLS LOOP_TRIPCOUNT min=1 max=27
            if (j >= nBits) break;

            unsigned int bit = (fields[curField] >> curBit) & 1;
            if (bit) {
                a |= (1u << j);
            }
            curBit++;
            if (curBit == 63) {
                curBit = 0;
                curField++;
            }
        }
        queries[i] = a;
    }
}

#endif // VENUS_TRANSCRIPT_HPP
