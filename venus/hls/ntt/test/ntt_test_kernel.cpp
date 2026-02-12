// AXI-wrapped NTT test kernel for HLS co-simulation and hw_emu.
//
// Interface:
//   - data_in[N]:    input array via AXI-MM
//   - data_out[N]:   output array via AXI-MM
//   - twiddles[N/2]: twiddle factor table via AXI-MM
//   - r_table[N]:    LDE shift factors via AXI-MM (when extend=true)
//   - log_n:         log2(domain_size)
//   - op:            0=forward NTT, 1=inverse NTT, 2=bit-reversal, 3=LDE
//   - count:         domain_size
//
// For small test sizes (N <= BATCH_SIZE), the NTT is done in a single pass.
// For larger sizes, the kernel loops over multiple passes.

#include "../ntt_butterfly.hpp"
#include "../ntt_bitrev.hpp"
#include "../ntt_twiddle.hpp"
#include "../ntt_transpose.hpp"

extern "C" {

void ntt_test_kernel(
    const ap_uint<64>* data_in,
    ap_uint<64>* data_out,
    const ap_uint<64>* twiddles,
    const ap_uint<64>* r_table,
    unsigned int log_n,
    unsigned int op,
    unsigned int count
) {
    #pragma HLS INTERFACE m_axi port=data_in  bundle=gmem0 offset=slave depth=4096
    #pragma HLS INTERFACE m_axi port=data_out bundle=gmem1 offset=slave depth=4096
    #pragma HLS INTERFACE m_axi port=twiddles bundle=gmem2 offset=slave depth=4096
    #pragma HLS INTERFACE m_axi port=r_table  bundle=gmem3 offset=slave depth=4096
    #pragma HLS INTERFACE s_axilite port=log_n
    #pragma HLS INTERFACE s_axilite port=op
    #pragma HLS INTERFACE s_axilite port=count
    #pragma HLS INTERFACE s_axilite port=return

    uint32_t n = 1u << log_n;

    switch (op) {
    case 0: { // Forward NTT (DIT)
        // Copy input to output buffer first
        for (unsigned int i = 0; i < n; i++) {
            #pragma HLS PIPELINE II=1
            data_out[i] = data_in[i];
        }

        // Bit-reversal permutation
        ntt_bitrev_inplace(data_out, log_n);

        // Butterfly passes
        gl64_t tw_buf[BATCH_HALF];
        for (unsigned int step = 0; step < log_n; step += BATCH_LOG) {
            unsigned int n_steps = (step + BATCH_LOG <= log_n)
                                 ? BATCH_LOG : (log_n - step);
            unsigned int n_batches = n / BATCH_SIZE;
            if (n_batches == 0) n_batches = 1;

            for (unsigned int b = 0; b < n_batches; b++) {
                gl64_t inv_f = gl64_t::zero(); // not used for forward
                process_batch_dit(
                    data_out, data_out,
                    (const gl64_t*)twiddles,
                    b, step, n_steps,
                    log_n, log_n,
                    n,     // domain_size_out
                    false, // not inverse
                    false, // not extend
                    inv_f, // unused
                    nullptr // unused
                );
            }
        }
        break;
    }

    case 1: { // Inverse NTT (DIT with inverse twiddles + scaling)
        // Copy input to output buffer
        for (unsigned int i = 0; i < n; i++) {
            #pragma HLS PIPELINE II=1
            data_out[i] = data_in[i];
        }

        // Bit-reversal permutation
        ntt_bitrev_inplace(data_out, log_n);

        gl64_t inv_n = ntt_domain_size_inverse(log_n);

        for (unsigned int step = 0; step < log_n; step += BATCH_LOG) {
            unsigned int n_steps = (step + BATCH_LOG <= log_n)
                                 ? BATCH_LOG : (log_n - step);
            unsigned int n_batches = n / BATCH_SIZE;
            if (n_batches == 0) n_batches = 1;

            for (unsigned int b = 0; b < n_batches; b++) {
                process_batch_dit(
                    data_out, data_out,
                    (const gl64_t*)twiddles, // should be inverse twiddles
                    b, step, n_steps,
                    log_n, log_n,
                    n,
                    true,  // inverse
                    false, // no extend
                    inv_n,
                    nullptr
                );
            }
        }
        break;
    }

    case 2: { // Bit-reversal only
        for (unsigned int i = 0; i < n; i++) {
            #pragma HLS PIPELINE II=1
            data_out[i] = data_in[i];
        }
        ntt_bitrev_inplace(data_out, log_n);
        break;
    }

    case 3: { // LDE: INTT with extend
        // Copy input to output
        for (unsigned int i = 0; i < n; i++) {
            #pragma HLS PIPELINE II=1
            data_out[i] = data_in[i];
        }

        ntt_bitrev_inplace(data_out, log_n);

        gl64_t inv_n = ntt_domain_size_inverse(log_n);

        for (unsigned int step = 0; step < log_n; step += BATCH_LOG) {
            unsigned int n_steps = (step + BATCH_LOG <= log_n)
                                 ? BATCH_LOG : (log_n - step);
            unsigned int n_batches = n / BATCH_SIZE;
            if (n_batches == 0) n_batches = 1;

            for (unsigned int b = 0; b < n_batches; b++) {
                process_batch_dit(
                    data_out, data_out,
                    (const gl64_t*)twiddles,
                    b, step, n_steps,
                    log_n, log_n,
                    n,
                    true,  // inverse
                    true,  // extend
                    inv_n,
                    (const gl64_t*)r_table
                );
            }
        }
        break;
    }

    default:
        break;
    }
}

} // extern "C"
