// AXI-wrapped transcript test kernel for HLS co-simulation.
//
// Interface:
//   - input[]:     input data to absorb via AXI-MM
//   - output[]:    output buffer via AXI-MM
//   - queries[]:   query index output via AXI-MM
//   - op:          operation mode
//                    0 = put + getField (absorb then squeeze challenge)
//                    1 = put + getState (absorb then get state)
//                    2 = put + getPermutations (absorb then get query indices)
//                    3 = multi-round: put, getField, put, getField
//   - inputSize:   number of elements to absorb
//   - nQueries:    number of queries for getPermutations
//   - nBits:       bits per query for getPermutations

#include "../transcript.hpp"

extern "C" {

void transcript_test_kernel(
    const ap_uint<64>* input,
    ap_uint<64>*       output,
    unsigned int*      queries,
    unsigned int       op,
    unsigned int       inputSize,
    unsigned int       nQueries,
    unsigned int       nBits,
    unsigned int       inputSize2
) {
    #pragma HLS INTERFACE m_axi port=input   bundle=gmem0 offset=slave depth=256
    #pragma HLS INTERFACE m_axi port=output  bundle=gmem1 offset=slave depth=256
    #pragma HLS INTERFACE m_axi port=queries bundle=gmem2 offset=slave depth=128
    #pragma HLS INTERFACE s_axilite port=op
    #pragma HLS INTERFACE s_axilite port=inputSize
    #pragma HLS INTERFACE s_axilite port=nQueries
    #pragma HLS INTERFACE s_axilite port=nBits
    #pragma HLS INTERFACE s_axilite port=inputSize2
    #pragma HLS INTERFACE s_axilite port=return

    // Initialize transcript
    transcript_state_t tr;
    #pragma HLS ARRAY_PARTITION variable=tr.state complete
    #pragma HLS ARRAY_PARTITION variable=tr.pending complete
    #pragma HLS ARRAY_PARTITION variable=tr.out complete
    tr_reset(tr);

    switch (op) {
    case 0: { // put + getField
        tr_put(tr, input, inputSize);
        tr_get_field(tr, output);
        break;
    }
    case 1: { // put + getState
        tr_put(tr, input, inputSize);
        tr_get_state(tr, output);
        break;
    }
    case 2: { // put + getPermutations
        tr_put(tr, input, inputSize);
        tr_get_permutations(tr, queries, nQueries, nBits);
        break;
    }
    case 3: { // multi-round: put(input[0:inputSize-1]), getField,
              //              put(input[inputSize:inputSize+inputSize2-1]), getField
        tr_put(tr, input, inputSize);
        tr_get_field(tr, output);  // output[0:2]

        tr_put(tr, &input[inputSize], inputSize2);
        tr_get_field(tr, &output[3]);  // output[3:5]
        break;
    }
    default:
        break;
    }
}

} // extern "C"
