// Integration Test Kernel for Proof Flow (Vitis HLS)
//
// Chains transcript, FRI fold, and Merkle tree into a single kernel
// to verify end-to-end component interoperability.
//
// Operations:
//   op=0: Full FRI step
//         1. Absorb initial data into transcript
//         2. Squeeze FRI challenge
//         3. Fold polynomial
//         4. Build Merkle tree over folded result
//         5. Absorb Merkle root back into transcript
//         6. Output: folded polynomial, challenge, final transcript state

#include "../proof_flow.hpp"

extern "C" {

void proof_test_kernel(
    const ap_uint<64>* input_data,    // Data to absorb into transcript
    const ap_uint<64>* friPol,        // Input polynomial for fold
    ap_uint<64>*       output,        // Folded polynomial output
    ap_uint<64>*       challenge_out, // FRI challenge used (3 elements)
    ap_uint<64>*       state_out,     // Final transcript state (4 elements)
    ap_uint<64>*       tree_nodes,    // Merkle tree output
    unsigned int       op,
    unsigned int       inputSize,     // Elements to absorb
    unsigned int       prevBits,
    unsigned int       currentBits,
    ap_uint<64>        omega_inv_raw,
    ap_uint<64>        invShift_raw,
    ap_uint<64>        invW_raw
) {
    #pragma HLS INTERFACE m_axi port=input_data   bundle=gmem0 offset=slave depth=256
    #pragma HLS INTERFACE m_axi port=friPol       bundle=gmem1 offset=slave depth=65536
    #pragma HLS INTERFACE m_axi port=output       bundle=gmem2 offset=slave depth=65536
    #pragma HLS INTERFACE m_axi port=challenge_out bundle=gmem3 offset=slave depth=3
    #pragma HLS INTERFACE m_axi port=state_out    bundle=gmem4 offset=slave depth=4
    #pragma HLS INTERFACE m_axi port=tree_nodes   bundle=gmem5 offset=slave depth=65536
    #pragma HLS INTERFACE s_axilite port=op
    #pragma HLS INTERFACE s_axilite port=inputSize
    #pragma HLS INTERFACE s_axilite port=prevBits
    #pragma HLS INTERFACE s_axilite port=currentBits
    #pragma HLS INTERFACE s_axilite port=omega_inv_raw
    #pragma HLS INTERFACE s_axilite port=invShift_raw
    #pragma HLS INTERFACE s_axilite port=invW_raw
    #pragma HLS INTERFACE s_axilite port=return

    // Initialize transcript
    transcript_state_t tr;
    #pragma HLS ARRAY_PARTITION variable=tr.state complete
    #pragma HLS ARRAY_PARTITION variable=tr.pending complete
    #pragma HLS ARRAY_PARTITION variable=tr.out complete
    tr_reset(tr);

    switch (op) {
    case 0: { // Full FRI step: absorb -> challenge -> fold -> merkle -> absorb root
        // 1. Absorb initial data (simulated Merkle root / commitment)
        tr_put(tr, input_data, inputSize);

        // 2. Get FRI challenge and fold
        gl64_t omega_inv(omega_inv_raw);
        gl64_t invShift(invShift_raw);
        gl64_t invW(invW_raw);

        proof_fri_fold<FRI_MAX_FOLD_RATIO>(
            tr, friPol, output,
            omega_inv, invShift, invW,
            prevBits, currentBits,
            challenge_out
        );

        // 3. Build Merkle tree over folded polynomial and absorb root
        unsigned int sizeFolded = 1u << currentBits;
        unsigned int nCols = FRI_FIELD_EXTENSION;  // 3

        proof_merkelize_and_absorb(
            tr, output, tree_nodes,
            nCols, sizeFolded
        );

        // 4. Output final transcript state
        tr_get_state(tr, state_out);
        break;
    }
    default:
        break;
    }
}

} // extern "C"
