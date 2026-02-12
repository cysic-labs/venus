// FRI Query Operations for AMD FPGA (Vitis HLS)
//
// Implements FRI transpose and query-related operations:
//   - fri_transpose():        Reshape folded polynomial for Merkle tree
//   - fri_extract_query():    Read polynomial values at query index
//   - fri_module_queries():   Reduce query indices modulo current domain
//   - fri_set_final_pol():    Copy final polynomial to proof buffer
//
// Reference:
//   pil2-proofman/pil2-stark/src/starkpil/starks_gpu.cu
//     transposeFRI(), getTreeTracePols(), moduleQueries()
//   pil2-proofman/pil2-stark/src/starkpil/fri/fri.hpp
//     FRI<T>::getTransposed(), proveFRIQueries(), setFinalPol()

#ifndef VENUS_FRI_QUERY_HPP
#define VENUS_FRI_QUERY_HPP

#include "fri_config.hpp"

// ---- FRI Transpose ----
// Reorganizes the folded polynomial from natural order into the layout
// expected by the Merkle tree: (height x width) -> (width x height).
//
// Input:  pol[row * width + col]  for row in [0,height), col in [0,width)
// Output: aux[col * height + row]
//
// Each element is FRI_FIELD_EXTENSION (3) base field values.
//
// Reference: transposeFRI() GPU kernel, FRI<T>::getTransposed()
static void fri_transpose(
    const ap_uint<64>* pol,
    ap_uint<64>* aux,
    unsigned int degree,
    unsigned int width
) {
    #pragma HLS INLINE off

    unsigned int height = degree / width;

    TRANSPOSE_ROWS:
    for (unsigned int row = 0; row < height; row++) {
        #pragma HLS LOOP_TRIPCOUNT min=1 max=65536
        TRANSPOSE_COLS:
        for (unsigned int col = 0; col < width; col++) {
            #pragma HLS PIPELINE II=1
            #pragma HLS LOOP_TRIPCOUNT min=1 max=1024

            unsigned int fi = (row * width + col) * FRI_FIELD_EXTENSION;
            unsigned int di = (col * height + row) * FRI_FIELD_EXTENSION;

            COPY_EXT:
            for (unsigned int k = 0; k < FRI_FIELD_EXTENSION; k++) {
                aux[di + k] = pol[fi + k];
            }
        }
    }
}

// ---- Extract query values from tree source ----
// Reads the full row of polynomial values from the Merkle tree source
// buffer at a given query index.
//
// tree_source: transposed polynomial data (output of fri_transpose)
// query_idx:   leaf row index to extract
// tree_width:  number of field elements per row
// out:         output buffer (tree_width elements)
//
// Reference: getTreeTracePols() GPU kernel
static void fri_extract_query(
    const ap_uint<64>* tree_source,
    unsigned int query_idx,
    unsigned int tree_width,
    ap_uint<64>* out
) {
    #pragma HLS INLINE off

    unsigned int base = query_idx * tree_width;

    EXTRACT:
    for (unsigned int i = 0; i < tree_width; i++) {
        #pragma HLS PIPELINE II=1
        #pragma HLS LOOP_TRIPCOUNT min=1 max=512
        out[i] = tree_source[base + i];
    }
}

// ---- Reduce query indices modulo current domain ----
// After each fold step, query indices must be reduced to the smaller
// domain: queries[i] %= (1 << currentBits).
//
// Reference: moduleQueries() GPU kernel
static void fri_module_queries(
    unsigned int* queries,
    unsigned int nQueries,
    unsigned int currentBits
) {
    #pragma HLS INLINE off

    unsigned int mask = (1u << currentBits) - 1;

    MODULE:
    for (unsigned int i = 0; i < nQueries; i++) {
        #pragma HLS PIPELINE II=1
        #pragma HLS LOOP_TRIPCOUNT min=1 max=FRI_MAX_QUERIES
        queries[i] = queries[i] & mask;
    }
}

// ---- Copy final polynomial to proof buffer ----
// After all fold steps, the remaining small polynomial is stored
// directly into the proof.
//
// Reference: FRI<T>::setFinalPol()
static void fri_set_final_pol(
    const ap_uint<64>* friPol,
    ap_uint<64>* finalPol,
    unsigned int nElements
) {
    #pragma HLS INLINE off

    COPY_FINAL:
    for (unsigned int i = 0; i < nElements; i++) {
        #pragma HLS PIPELINE II=1
        #pragma HLS LOOP_TRIPCOUNT min=1 max=FRI_MAX_FINAL_POL
        finalPol[i] = friPol[i];
    }
}

#endif // VENUS_FRI_QUERY_HPP
