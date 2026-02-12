// AXI-wrapped Merkle tree test kernel for HLS co-simulation and hw_emu.
//
// Interface:
//   - source[]:  leaf source data via AXI-MM
//   - tree[]:    tree node buffer via AXI-MM
//   - proof[]:   proof output buffer via AXI-MM
//   - op:        0 = build tree (leaf hash + internal levels)
//                1 = generate Merkle proof for a leaf
//                2 = get root hash
//   - num_cols:  columns per leaf row
//   - num_rows:  number of leaf rows
//   - idx:       leaf index (for proof generation)
//   - arity:     tree arity (2, 3, or 4)

#include "../merkle_tree.hpp"
#include "../merkle_proof.hpp"

extern "C" {

void merkle_test_kernel(
    const ap_uint<64>* source,
    ap_uint<64>* tree,
    ap_uint<64>* proof,
    unsigned int op,
    unsigned int num_cols,
    unsigned int num_rows,
    unsigned int idx,
    unsigned int arity
) {
    #pragma HLS INTERFACE m_axi port=source bundle=gmem0 offset=slave depth=65536
    #pragma HLS INTERFACE m_axi port=tree   bundle=gmem1 offset=slave depth=65536
    #pragma HLS INTERFACE m_axi port=proof  bundle=gmem2 offset=slave depth=4096
    #pragma HLS INTERFACE s_axilite port=op
    #pragma HLS INTERFACE s_axilite port=num_cols
    #pragma HLS INTERFACE s_axilite port=num_rows
    #pragma HLS INTERFACE s_axilite port=idx
    #pragma HLS INTERFACE s_axilite port=arity
    #pragma HLS INTERFACE s_axilite port=return

    switch (op) {
    case 0: { // Build full tree (arity=3 only for now)
        mt_merkelize(source, tree, num_cols, num_rows);
        break;
    }

    case 1: { // Generate Merkle proof
        mt_gen_proof(tree, proof, idx, num_rows, arity);
        break;
    }

    case 2: { // Get root hash
        mt_get_root(tree, proof, num_rows, arity);
        break;
    }

    default:
        break;
    }
}

} // extern "C"
