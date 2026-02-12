// AXI-wrapped FRI test kernel for HLS co-simulation.
//
// Interface:
//   - friPol[]:     input polynomial data via AXI-MM (cubic extension)
//   - output[]:     result buffer via AXI-MM
//   - challenge[]:  FRI challenge (3 elements) via AXI-MM
//   - queries[]:    query indices via AXI-MM
//   - op:           operation mode
//                     0 = fold step
//                     1 = transpose
//                     2 = extract query values
//                     3 = module (reduce) queries
//   - prevBits:     log2 of input polynomial size
//   - currentBits:  log2 of output (folded) polynomial size
//   - nextBits:     log2 of transpose width (for merkelize)
//   - nQueries:     number of queries
//   - omega_inv:    inverse of primitive root for small INTT
//   - invShift:     precomputed shift inverse
//   - invW:         precomputed omega(prevBits) inverse

#include "../fri_fold.hpp"
#include "../fri_query.hpp"

// Maximum fold ratio for test kernel
#define TEST_MAX_RATIO 16

extern "C" {

void fri_test_kernel(
    ap_uint<64>*       friPol,
    ap_uint<64>*       output,
    const ap_uint<64>* challenge_in,
    unsigned int*      queries,
    unsigned int       op,
    unsigned int       prevBits,
    unsigned int       currentBits,
    unsigned int       nextBits,
    unsigned int       nQueries,
    ap_uint<64>        omega_inv_raw,
    ap_uint<64>        invShift_raw,
    ap_uint<64>        invW_raw,
    unsigned int       treeWidth
) {
    #pragma HLS INTERFACE m_axi port=friPol       bundle=gmem0 offset=slave depth=65536
    #pragma HLS INTERFACE m_axi port=output       bundle=gmem1 offset=slave depth=65536
    #pragma HLS INTERFACE m_axi port=challenge_in bundle=gmem2 offset=slave depth=3
    #pragma HLS INTERFACE m_axi port=queries      bundle=gmem3 offset=slave depth=128
    #pragma HLS INTERFACE s_axilite port=op
    #pragma HLS INTERFACE s_axilite port=prevBits
    #pragma HLS INTERFACE s_axilite port=currentBits
    #pragma HLS INTERFACE s_axilite port=nextBits
    #pragma HLS INTERFACE s_axilite port=nQueries
    #pragma HLS INTERFACE s_axilite port=omega_inv_raw
    #pragma HLS INTERFACE s_axilite port=invShift_raw
    #pragma HLS INTERFACE s_axilite port=invW_raw
    #pragma HLS INTERFACE s_axilite port=treeWidth
    #pragma HLS INTERFACE s_axilite port=return

    switch (op) {
    case 0: { // FRI fold step
        // Load challenge from AXI
        gl64_3_t challenge;
        challenge.v[0] = gl64_t(challenge_in[0]);
        challenge.v[1] = gl64_t(challenge_in[1]);
        challenge.v[2] = gl64_t(challenge_in[2]);

        gl64_t omega_inv(omega_inv_raw);
        gl64_t invShift(invShift_raw);
        gl64_t invW(invW_raw);

        fri_fold_step<TEST_MAX_RATIO>(
            friPol, output, challenge,
            omega_inv, invShift, invW,
            prevBits, currentBits);
        break;
    }
    case 1: { // Transpose
        unsigned int degree = 1u << currentBits;
        unsigned int width = 1u << nextBits;
        fri_transpose(friPol, output, degree, width);
        break;
    }
    case 2: { // Extract query values
        fri_extract_query(friPol, queries[0], treeWidth, output);
        break;
    }
    case 3: { // Module queries
        fri_module_queries(queries, nQueries, currentBits);
        break;
    }
    default:
        break;
    }
}

} // extern "C"
