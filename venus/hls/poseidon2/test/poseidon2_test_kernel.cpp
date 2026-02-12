// AXI-wrapped Poseidon2 test kernel for HLS co-simulation and hw_emu.
//
// Interface:
//   - input[]:   input data via AXI-MM
//   - output[]:  output data via AXI-MM
//   - op:        0 = single hash (full result)
//                1 = single hash (capacity only)
//                2 = linear hash of one row
//                3 = linear hash of multiple rows
//   - num_cols:  number of columns per row (for linear hash)
//   - num_rows:  number of rows (for op=3)

#include "../poseidon2_core.hpp"
#include "../poseidon2_linear_hash.hpp"

extern "C" {

void poseidon2_test_kernel(
    const ap_uint<64>* input,
    ap_uint<64>* output,
    unsigned int op,
    unsigned int num_cols,
    unsigned int num_rows
) {
    #pragma HLS INTERFACE m_axi port=input  bundle=gmem0 offset=slave depth=4096
    #pragma HLS INTERFACE m_axi port=output bundle=gmem1 offset=slave depth=4096
    #pragma HLS INTERFACE s_axilite port=op
    #pragma HLS INTERFACE s_axilite port=num_cols
    #pragma HLS INTERFACE s_axilite port=num_rows
    #pragma HLS INTERFACE s_axilite port=return

    switch (op) {
    case 0: { // Single hash - full result (12 in, 12 out)
        gl64_t state[P2_SPONGE_WIDTH];
        #pragma HLS ARRAY_PARTITION variable=state complete
        for (unsigned int i = 0; i < P2_SPONGE_WIDTH; i++) {
            #pragma HLS PIPELINE II=1
            state[i] = gl64_t(input[i]);
        }
        p2_hash_full_result(state);
        for (unsigned int i = 0; i < P2_SPONGE_WIDTH; i++) {
            #pragma HLS PIPELINE II=1
            output[i] = state[i].val;
        }
        break;
    }

    case 1: { // Single hash - capacity only (12 in, 4 out)
        gl64_t in_buf[P2_SPONGE_WIDTH];
        gl64_t out_buf[P2_CAPACITY];
        #pragma HLS ARRAY_PARTITION variable=in_buf complete
        #pragma HLS ARRAY_PARTITION variable=out_buf complete
        for (unsigned int i = 0; i < P2_SPONGE_WIDTH; i++) {
            #pragma HLS PIPELINE II=1
            in_buf[i] = gl64_t(input[i]);
        }
        p2_hash(out_buf, in_buf);
        for (unsigned int i = 0; i < P2_CAPACITY; i++) {
            #pragma HLS PIPELINE II=1
            output[i] = out_buf[i].val;
        }
        break;
    }

    case 2: { // Linear hash of one row (num_cols in, 4 out)
        gl64_t in_buf[1024];
        gl64_t out_buf[P2_CAPACITY];
        unsigned int n = (num_cols > 1024) ? 1024 : num_cols;
        for (unsigned int i = 0; i < n; i++) {
            #pragma HLS PIPELINE II=1
            in_buf[i] = gl64_t(input[i]);
        }
        p2_linear_hash<1024>(out_buf, in_buf, n);
        for (unsigned int i = 0; i < P2_CAPACITY; i++) {
            #pragma HLS PIPELINE II=1
            output[i] = out_buf[i].val;
        }
        break;
    }

    case 3: { // Linear hash of multiple rows (num_rows * num_cols in, num_rows * 4 out)
        p2_linear_hash_rows<1024>(input, output, num_cols, num_rows);
        break;
    }

    default:
        break;
    }
}

} // extern "C"
