// AXI-wrapped Goldilocks field arithmetic test kernel
// Used for HLS co-simulation and hardware emulation (hw_emu) testing.
//
// Interface:
//   - a[N], b[N]: input arrays via AXI-MM (one HBM pseudo-channel each)
//   - result[N]:  output array via AXI-MM
//   - op:         operation selector (0=add, 1=sub, 2=mul, 3=inv(a), 4=cubic_mul)
//   - count:      number of elements to process
//
// For op=0,1,2: result[i] = a[i] op b[i]  (base field)
// For op=3:     result[i] = a[i]^(-1)       (base field inverse)
// For op=4:     result[i*3..i*3+2] = cubic_mul(a[i*3..], b[i*3..])

#include "../gl64_t.hpp"
#include "../gl64_cubic.hpp"

extern "C" {

void gl64_test_kernel(
    const ap_uint<64>* a,
    const ap_uint<64>* b,
    ap_uint<64>* result,
    unsigned int op,
    unsigned int count
) {
    #pragma HLS INTERFACE m_axi port=a      bundle=gmem0 offset=slave depth=4096
    #pragma HLS INTERFACE m_axi port=b      bundle=gmem1 offset=slave depth=4096
    #pragma HLS INTERFACE m_axi port=result bundle=gmem2 offset=slave depth=4096
    #pragma HLS INTERFACE s_axilite port=op
    #pragma HLS INTERFACE s_axilite port=count
    #pragma HLS INTERFACE s_axilite port=return

    switch (op) {
    case 0: // Base field addition
        for (unsigned int i = 0; i < count; i++) {
            #pragma HLS PIPELINE II=1
            gl64_t x(a[i]);
            gl64_t y(b[i]);
            gl64_t r = x + y;
            result[i] = r.val;
        }
        break;

    case 1: // Base field subtraction
        for (unsigned int i = 0; i < count; i++) {
            #pragma HLS PIPELINE II=1
            gl64_t x(a[i]);
            gl64_t y(b[i]);
            gl64_t r = x - y;
            result[i] = r.val;
        }
        break;

    case 2: // Base field multiplication
        for (unsigned int i = 0; i < count; i++) {
            #pragma HLS PIPELINE II=1
            gl64_t x(a[i]);
            gl64_t y(b[i]);
            gl64_t r = x * y;
            result[i] = r.val;
        }
        break;

    case 3: // Base field inverse (only uses 'a' input)
        for (unsigned int i = 0; i < count; i++) {
            // Note: inverse is NOT pipelineable (serial dependency)
            gl64_t x(a[i]);
            gl64_t r = x.reciprocal();
            result[i] = r.val;
        }
        break;

    case 4: // Cubic extension multiplication
        // Each cubic element uses 3 consecutive uint64_t values
        for (unsigned int i = 0; i < count; i++) {
            #pragma HLS PIPELINE II=1
            unsigned int base = i * 3;
            gl64_3_t x{gl64_t(a[base]), gl64_t(a[base+1]), gl64_t(a[base+2])};
            gl64_3_t y{gl64_t(b[base]), gl64_t(b[base+1]), gl64_t(b[base+2])};
            gl64_3_t r = x * y;
            result[base]   = r.v[0].val;
            result[base+1] = r.v[1].val;
            result[base+2] = r.v[2].val;
        }
        break;

    case 5: // Cubic extension inverse (only uses 'a' input)
        for (unsigned int i = 0; i < count; i++) {
            unsigned int base = i * 3;
            gl64_3_t x{gl64_t(a[base]), gl64_t(a[base+1]), gl64_t(a[base+2])};
            gl64_3_t r = x.inv();
            result[base]   = r.v[0].val;
            result[base+1] = r.v[1].val;
            result[base+2] = r.v[2].val;
        }
        break;

    default:
        break;
    }
}

} // extern "C"
