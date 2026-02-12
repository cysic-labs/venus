// NTT Butterfly Unit for AMD FPGA (Vitis HLS)
//
// Implements the radix-2 butterfly with on-chip BRAM ping-pong buffers.
// Processes BATCH_SIZE elements through BATCH_LOG stages per invocation.
//
// The butterfly is the core compute primitive:
//   DIT: t = W * a_odd;  a_even += t;  a_odd = a_even_orig - t;
//   DIF: t1 = a + b;  t2 = (a - b) * W;
//
// Reference: ntt_goldilocks.cu br_ntt_batch_steps_blocks_par

#ifndef VENUS_NTT_BUTTERFLY_HPP
#define VENUS_NTT_BUTTERFLY_HPP

#include "../goldilocks/gl64_t.hpp"
#include "ntt_config.hpp"
#include "ntt_addr_gen.hpp"

// Single radix-2 DIT butterfly.
// Reads a_even and a_odd, produces (a_even + W*a_odd) and (a_even - W*a_odd).
inline void butterfly_dit(
    gl64_t a_even,
    gl64_t a_odd,
    gl64_t twiddle,
    gl64_t& out_top,
    gl64_t& out_bot
) {
    #pragma HLS INLINE
    gl64_t t = a_odd * twiddle;
    out_top = a_even + t;
    out_bot = a_even - t;
}

// Single radix-2 DIF butterfly.
// Produces (a + b) and (a - b) * W.
inline void butterfly_dif(
    gl64_t a,
    gl64_t b,
    gl64_t twiddle,
    gl64_t& out_top,
    gl64_t& out_bot
) {
    #pragma HLS INLINE
    out_top = a + b;
    gl64_t diff = a - b;
    out_bot = diff * twiddle;
}

// Process one DIT butterfly stage on a batch of BATCH_SIZE elements in BRAM.
//
// For stage `loc_step` (0-based), processes BATCH_HALF butterflies.
// Each butterfly reads two elements, applies the twiddle factor, and
// writes two results.
//
// BRAM partitioning: To achieve II=1, we split the BRAM into two banks
// (even-indexed and odd-indexed elements).  For butterfly at (index1, index2),
// one index is even and the other is odd (since they differ by 2^loc_step,
// and for loc_step >= 1 this means different parity; for loc_step=0 they
// are adjacent, which is the special case handled by even/odd banking).
//
// Parameters:
//   bram_src:    source BRAM (BATCH_SIZE elements)
//   bram_dst:    destination BRAM (BATCH_SIZE elements)
//   twiddles:    twiddle factor table (indexed by global twiddle position)
//   loc_step:    local stage index (0 .. n_steps-1)
//   batch_id:    current batch ID (for twiddle indexing)
//   base_step:   first global stage for this pass
//   log_n:       log2(NTT domain size)
//   max_log_n:   log2(maximum domain size, for twiddle stride)
inline void butterfly_stage_dit(
    gl64_t bram_src[BATCH_SIZE],
    gl64_t bram_dst[BATCH_SIZE],
    const gl64_t* twiddles,
    unsigned int loc_step,
    unsigned int batch_id,
    unsigned int base_step,
    unsigned int log_n,
    unsigned int max_log_n
) {
    #pragma HLS INLINE off
    for (unsigned int i = 0; i < BATCH_HALF; i++) {
        #pragma HLS PIPELINE II=1
        uint32_t index1, index2;
        ntt_butterfly_indices(i, loc_step, index1, index2);

        // Read butterfly pair
        gl64_t a_even = bram_src[index1];
        gl64_t a_odd = bram_src[index2];

        // Compute twiddle factor from master table
        uint32_t tw_pos = ntt_twiddle_index_dit(
            batch_id, i, base_step, loc_step, log_n);
        uint32_t global_step = base_step + loc_step;
        uint64_t tw_stride = 1ULL << (max_log_n - 1 - global_step);
        gl64_t w = twiddles[tw_pos * tw_stride];

        // Butterfly
        gl64_t out_top, out_bot;
        butterfly_dit(a_even, a_odd, w, out_top, out_bot);

        // Write results
        bram_dst[index1] = out_top;
        bram_dst[index2] = out_bot;
    }
}

// Process one DIF butterfly stage.
inline void butterfly_stage_dif(
    gl64_t bram_src[BATCH_SIZE],
    gl64_t bram_dst[BATCH_SIZE],
    const gl64_t* twiddles,
    unsigned int loc_step,
    unsigned int batch_id,
    unsigned int base_step,
    unsigned int log_n,
    unsigned int max_log_n,
    unsigned int n_loc_steps
) {
    #pragma HLS INLINE off
    for (unsigned int i = 0; i < BATCH_HALF; i++) {
        #pragma HLS PIPELINE II=1
        uint32_t index1, index2;
        ntt_butterfly_indices(i, loc_step, index1, index2);

        gl64_t a = bram_src[index1];
        gl64_t b = bram_src[index2];

        uint32_t tw_pos = ntt_twiddle_index_dif(
            batch_id, i, base_step, loc_step, log_n, n_loc_steps);
        uint32_t gs = base_step - (n_loc_steps - 1 - loc_step);
        uint64_t tw_stride = 1ULL << (max_log_n - 1 - gs);
        gl64_t w = twiddles[tw_pos * tw_stride];

        gl64_t out_top, out_bot;
        butterfly_dif(a, b, w, out_top, out_bot);

        bram_dst[index1] = out_top;
        bram_dst[index2] = out_bot;
    }
}

// Process a complete batch through all K butterfly stages (DIT).
//
// Loads BATCH_SIZE elements from HBM, runs K butterfly stages using
// ping-pong BRAMs, optionally applies INTT scaling, and writes back.
//
// This is the main compute function, called once per batch per pass.
inline void process_batch_dit(
    const ap_uint<64>* data_in,
    ap_uint<64>* data_out,
    const gl64_t* twiddles,
    unsigned int batch_id,
    unsigned int base_step,
    unsigned int n_steps,
    unsigned int log_n,
    unsigned int max_log_n,
    unsigned int domain_size_out,
    bool inverse,
    bool extend,
    gl64_t inv_factor,
    const gl64_t* r_table
) {
    #pragma HLS INLINE off

    // On-chip BRAM buffers (ping-pong)
    gl64_t bram_a[BATCH_SIZE];
    gl64_t bram_b[BATCH_SIZE];
    #pragma HLS BIND_STORAGE variable=bram_a type=ram_2p impl=bram
    #pragma HLS BIND_STORAGE variable=bram_b type=ram_2p impl=bram

    uint32_t domain_size = 1u << log_n;

    // --- Load from HBM into bram_a ---
    for (unsigned int idx = 0; idx < BATCH_SIZE; idx++) {
        #pragma HLS PIPELINE II=1
        uint32_t global_row = ntt_global_row_dit(batch_id, idx, base_step, log_n);
        bram_a[idx] = gl64_t(data_in[global_row]);
    }

    // --- K butterfly stages with ping-pong ---
    // Even stages: read from bram_a, write to bram_b
    // Odd stages: read from bram_b, write to bram_a
    for (unsigned int s = 0; s < n_steps; s++) {
        #pragma HLS UNROLL factor=1
        if (s % 2 == 0) {
            butterfly_stage_dit(bram_a, bram_b, twiddles, s,
                                batch_id, base_step, log_n, max_log_n);
        } else {
            butterfly_stage_dit(bram_b, bram_a, twiddles, s,
                                batch_id, base_step, log_n, max_log_n);
        }
    }

    // Result is in bram_a if n_steps is even, bram_b if odd
    gl64_t* bram_result = (n_steps % 2 == 0) ? bram_a : bram_b;

    // --- Write back to HBM ---
    bool is_final_pass = (base_step + n_steps >= log_n);
    for (unsigned int idx = 0; idx < BATCH_SIZE; idx++) {
        #pragma HLS PIPELINE II=1
        uint32_t global_row = ntt_global_row_dit(batch_id, idx, base_step, log_n);
        gl64_t val = bram_result[idx];

        // Apply INTT scaling on final pass
        if (is_final_pass && inverse) {
            val = val * inv_factor;
            if (extend) {
                val = val * r_table[global_row];
            }
        }

        data_out[global_row] = val.val;
    }
}

// Process a complete batch through K butterfly stages (DIF).
inline void process_batch_dif(
    const ap_uint<64>* data_in,
    ap_uint<64>* data_out,
    const gl64_t* twiddles,
    unsigned int batch_id,
    unsigned int base_step,
    unsigned int n_steps,
    unsigned int log_n,
    unsigned int max_log_n,
    unsigned int domain_size_out,
    bool inverse,
    bool extend,
    gl64_t inv_factor,
    const gl64_t* r_table
) {
    #pragma HLS INLINE off

    gl64_t bram_a[BATCH_SIZE];
    gl64_t bram_b[BATCH_SIZE];
    #pragma HLS BIND_STORAGE variable=bram_a type=ram_2p impl=bram
    #pragma HLS BIND_STORAGE variable=bram_b type=ram_2p impl=bram

    uint32_t domain_size = 1u << log_n;

    // --- Load from HBM ---
    for (unsigned int idx = 0; idx < BATCH_SIZE; idx++) {
        #pragma HLS PIPELINE II=1
        uint32_t global_row = ntt_global_row_dif(
            batch_id, idx, base_step, log_n, n_steps);
        bram_a[idx] = gl64_t(data_in[global_row]);
    }

    // --- DIF butterfly stages (reverse order within batch) ---
    for (unsigned int s_rev = 0; s_rev < n_steps; s_rev++) {
        #pragma HLS UNROLL factor=1
        unsigned int loc_step = n_steps - 1 - s_rev;
        if (s_rev % 2 == 0) {
            butterfly_stage_dif(bram_a, bram_b, twiddles, loc_step,
                                batch_id, base_step, log_n, max_log_n,
                                n_steps);
        } else {
            butterfly_stage_dif(bram_b, bram_a, twiddles, loc_step,
                                batch_id, base_step, log_n, max_log_n,
                                n_steps);
        }
    }

    gl64_t* bram_result = (n_steps % 2 == 0) ? bram_a : bram_b;

    // --- Write back with optional scaling ---
    bool is_final_pass = (base_step + 1 - (int)n_steps <= 0);
    for (unsigned int idx = 0; idx < BATCH_SIZE; idx++) {
        #pragma HLS PIPELINE II=1
        uint32_t global_row = ntt_global_row_dif(
            batch_id, idx, base_step, log_n, n_steps);
        gl64_t val = bram_result[idx];

        if (is_final_pass && inverse) {
            uint32_t row_br = bit_reverse(global_row, log_n);
            val = val * inv_factor;
            if (extend) {
                val = val * r_table[row_br];
            }
        }

        data_out[global_row] = val.val;
    }
}

#endif // VENUS_NTT_BUTTERFLY_HPP
